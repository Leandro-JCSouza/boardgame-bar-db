-- =========================================================
-- RELATÓRIOS E CONSULTAS ANALÍTICAS DA BOARD GAME BAR
-- =========================================================

-- RELATÓRIO 1: Consumo Unificado (Produtos + Aluguel de Jogos) por Comanda
SELECT 
    co.id_comanda AS "Num. Comanda",
    c.nome_completo AS "Cliente",
    m.numero_mesa AS "Mesa",
    f.nome_funcionario AS "Atendente",
    co.status_comanda AS "Status da Comanda",
    'Produto Físico' AS "Categoria",
    p.nome_produto AS "Item Consumido/Alugado",
    icp.quantidade_pedida_produto AS "Qtd",
    (icp.quantidade_pedida_produto * icp.preco_un_cobrado_produto) AS "Valor Total Linha"
FROM Comanda co
INNER JOIN Cliente c ON co.id_cliente = c.id_cliente
INNER JOIN Mesa m ON co.id_mesa = m.id_mesa
INNER JOIN Funcionario f ON co.id_funcionario = f.id_funcionario
INNER JOIN Item_Comanda_Produto icp ON co.id_comanda = icp.id_comanda
INNER JOIN Produto p ON icp.id_produto = p.id_produto

UNION ALL

SELECT 
    co.id_comanda AS "Num. Comanda",
    c.nome_completo AS "Cliente",
    m.numero_mesa AS "Mesa",
    f.nome_funcionario AS "Atendente",
    co.status_comanda AS "Status da Comanda",
    'Entretenimento (Jogo)' AS "Categoria",
    j.nome_jogo AS "Item Consumido/Alugado",
    1 AS "Qtd",
    icj.aluguel_hora_cobrado AS "Valor Total Linha"
FROM Comanda co
INNER JOIN Cliente c ON co.id_cliente = c.id_cliente
INNER JOIN Mesa m ON co.id_mesa = m.id_mesa
INNER JOIN Funcionario f ON co.id_funcionario = f.id_funcionario
INNER JOIN Item_Comanda_Jogo icj ON co.id_comanda = icj.id_comanda
INNER JOIN Jogo j ON icj.id_jogo = j.id_jogo
ORDER BY "Num. Comanda", "Categoria";


-- RELATÓRIO 2: Consumo de Insumos (Estoque e Ficha Técnica) por Comanda
SELECT 
    co.id_comanda AS "Num. Comanda",
    p.nome_produto AS "Lanche Vendido",
    icp.quantidade_pedida_produto AS "Qtd Lanches",
    i.nome_insumo AS "Ingrediente Usado",
    (ft.quantidade_necessaria * icp.quantidade_pedida_produto) AS "Total Insumo Descontado",
    i.unidade_medida AS "Medida"
FROM Comanda co
INNER JOIN Item_Comanda_Produto icp ON co.id_comanda = icp.id_comanda
INNER JOIN Produto p ON icp.id_produto = p.id_produto
INNER JOIN Ficha_Tecnica_Produto ft ON p.id_produto = ft.id_produto
INNER JOIN Insumo i ON ft.id_insumo = i.id_insumo
WHERE co.id_comanda = 1;


-- RELATÓRIO 3: Histórico de Locação de Entretenimento
SELECT 
    c.nome_completo AS "Cliente",
    m.numero_mesa AS "Mesa Utilizada",
    j.nome_jogo AS "Jogo Alugado",
    icj.hora_inicio_aluguel AS "Início do Aluguel",
    icj.hora_devolucao_aluguel AS "Devolução",
    icj.aluguel_hora_cobrado AS "Valor Cobrado"
FROM Comanda co
INNER JOIN Cliente c ON co.id_cliente = c.id_cliente
INNER JOIN Mesa m ON co.id_mesa = m.id_mesa
INNER JOIN Item_Comanda_Jogo icj ON co.id_comanda = icj.id_comanda
INNER JOIN Jogo j ON icj.id_jogo = j.id_jogo
ORDER BY c.nome_completo;


-- RELATÓRIO 4: Agenda de Ocupação e Validação de Capacidade de Reservas
SELECT 
    r.data_hora_reserva AS "Data e Hora do Agendamento",
    c.nome_completo AS "Nome do Cliente Titular",
    c.telefone AS "Telefone de Contato",
    r.qtd_pessoas_esperadas AS "Pessoas Esperadas",
    m.numero_mesa AS "Mesa Designada",
    m.capacidade_lugares AS "Capacidade da Mesa",
    r.status_reserva AS "Status Atual",
    CASE 
        WHEN r.qtd_pessoas_esperadas > m.capacidade_lugares THEN 'Alerta: Faltam lugares'
        ELSE 'Capacidade OK'
    END AS "Status de Capacidade"
FROM Reserva r
INNER JOIN Cliente c ON r.id_cliente = c.id_cliente
INNER JOIN Mesa m ON r.id_mesa = m.id_mesa
ORDER BY r.data_hora_reserva;


-- RELATÓRIO 5: Demonstrativo Financeiro Mensal (Lucro Líquido via CTE)
WITH Faturamento AS (
    SELECT SUM(valor_total_consumo - (valor_total_consumo * (desconto_percentual / 100))) AS receita_liquida
    FROM Comanda
    WHERE status_comanda = 'Fechada' 
      AND EXTRACT(MONTH FROM data_abertura) = 7 
      AND EXTRACT(YEAR FROM data_abertura) = 2026
),
Custos_Estoque AS (
    SELECT SUM(valor_total_nota) AS total_compras
    FROM Compra_Estoque
    WHERE EXTRACT(MONTH FROM data_compra) = 7
      AND EXTRACT(YEAR FROM data_compra) = 2026
),
Custos_Trabalhistas AS (
    SELECT SUM(salario) AS folha_pagamento
    FROM Funcionario
    WHERE status_funcionario = 'Ativo'
)
SELECT 
    COALESCE(f.receita_liquida, 0) AS "Faturamento Limpo (R$)",
    COALESCE(ce.total_compras, 0) AS "Despesas com Fornecedores (R$)",
    COALESCE(ct.folha_pagamento, 0) AS "Despesas Folha de Pagamento (R$)",
    (COALESCE(f.receita_liquida, 0) - COALESCE(ce.total_compras, 0) - COALESCE(ct.folha_pagamento, 0)) AS "Lucro Líquido Final (R$)"
FROM Faturamento f
CROSS JOIN Custos_Estoque ce
CROSS JOIN Custos_Trabalhistas ct;
