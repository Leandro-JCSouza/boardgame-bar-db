-- =========================================================
-- CARGA DE DADOS DE TESTE (SEED DATA) - POSTGRESQL
-- =========================================================

-- 1. CLIENTES
INSERT INTO Cliente (nome_completo, cpf, telefone, email) VALUES
('Ana Silva', '111.222.333-44', '(65) 99999-1111', 'ana.silva@email.com'),
('Bruno Costa', '222.333.444-55', '(65) 99999-2222', 'bruno.costa@email.com'),
('Carla Souza', '333.444.555-66', '(65) 99999-3333', 'carla.souza@email.com');

-- 2. FUNCIONÁRIOS
INSERT INTO Funcionario (nome_funcionario, cpf_funcionario, cargo, data_admissao) VALUES
('Carlos Atendente', '444.555.666-77', 'Atendente', '2025-01-15'),
('Mariana Gerente', '555.666.777-88', 'Gerente', '2024-06-01');

-- 3. MESAS
INSERT INTO Mesa (numero_mesa, capacidade_lugares, status_mesa) VALUES
(1, 4, 'Ocupada'),
(2, 6, 'Disponivel'),
(3, 2, 'Reservada');

-- 4. FORNECEDORES
INSERT INTO Fornecedor (nome_fornecedor, cnpj, telefone_fornecedor) VALUES
('Galápagos Jogos', '12.345.678/0001-90', '(11) 3000-1111'),
('Distribuidora Bebidas MT', '98.765.432/0001-10', '(65) 3600-2222');

-- 5. PRODUTOS (CARDÁPIO)
INSERT INTO Produto (nome_produto, categoria_produto, preco_venda_tabela) VALUES
('Hambúrguer Artesanal', 'Lanche', 35.00),
('Porção de Batata Frita', 'Petisco', 22.00),
('Refrigerante Lata', 'Bebida', 7.00),
('Cerveja IPA 500ml', 'Bebida', 18.00);

-- 6. INSUMOS (ESTOQUE)
INSERT INTO Insumo (nome_insumo, qtd_estoque_atual, unidade_medida, preco_unitario_atual) VALUES
('Pão de Hambúrguer', 50.00, 'un', 2.50),
('Carne Bovina 180g', 40.00, 'un', 8.00),
('Queijo Cheddar', 5.00, 'kg', 45.00),
('Batata Congelada', 15.00, 'kg', 12.00);

-- 7. JOGOS DE TABULEIRO
INSERT INTO Jogo (nome_jogo, categoria_jogo, status_jogo, aluguel_hora_atual) VALUES
('Catan', 'Estratégia', 'Em Uso', 15.00),
('Ticket to Ride', 'Família', 'Disponivel', 12.00),
('Dixit', 'Party Game', 'Disponivel', 10.00),
('Azul', 'Estratégia Light', 'Em Manutenção', 12.00);

-- 8. RESERVAS
INSERT INTO Reserva (data_hora_reserva, status_reserva, qtd_pessoas_esperadas, id_cliente, id_mesa) VALUES
('2026-08-10 19:00:00', 'Agendada', 2, 3, 3);

-- 9. COMANDAS
INSERT INTO Comanda (data_abertura, valor_total_consumo, gorjeta, status_comanda, desconto_percentual, id_cliente, id_mesa, id_funcionario) VALUES
('2026-08-04 18:30:00', 97.00, 9.70, 'Aberta', 0.00, 1, 1, 1);

-- 10. ITENS DA COMANDA (CONSUMO E ALUGUEL)
INSERT INTO Item_Comanda_Produto (id_comanda, id_produto, quantidade_pedida_produto, preco_un_cobrado_produto) VALUES
(1, 1, 2, 35.00), -- 2 Hambúrgueres
(1, 3, 2, 7.00);   -- 2 Refrigerantes

INSERT INTO Item_Comanda_Jogo (id_comanda, id_jogo, hora_inicio_aluguel, aluguel_hora_cobrado) VALUES
(1, 1, '2026-08-04 18:45:00', 15.00); -- Aluguel do Catan
