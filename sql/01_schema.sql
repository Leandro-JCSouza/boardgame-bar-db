-- 1. TABELAS INDEPENDENTES (FORTES)

CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Funcionario (
    id_funcionario SERIAL PRIMARY KEY,
    nome_funcionario VARCHAR(100) NOT NULL,
    cpf_funcionario VARCHAR(14) UNIQUE NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    data_admissao DATE NOT NULL,
    status_funcionario VARCHAR(15) DEFAULT 'Ativo' -- 'Ativo' ou 'Inativo'
);

CREATE TABLE Mesa (
    id_mesa SERIAL PRIMARY KEY,
    numero_mesa INT UNIQUE NOT NULL,
    capacidade_lugares INT NOT NULL,
    status_mesa VARCHAR(20) DEFAULT 'Disponivel'
);

CREATE TABLE Fornecedor (
    id_fornecedor SERIAL PRIMARY KEY,
    nome_fornecedor VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    telefone_fornecedor VARCHAR(15)
);

CREATE TABLE Produto (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    categoria_produto VARCHAR(50),
    preco_venda_tabela DECIMAL(10,2) NOT NULL
);

CREATE TABLE Insumo (
    id_insumo SERIAL PRIMARY KEY,
    nome_insumo VARCHAR(100) NOT NULL,
    qtd_estoque_atual DECIMAL(10,2) NOT NULL,
    unidade_medida VARCHAR(10) NOT NULL, -- 'kg', 'un', 'litro'
    preco_unitario_atual DECIMAL(10,2) NOT NULL
);

CREATE TABLE Jogo (
    id_jogo SERIAL PRIMARY KEY,
    nome_jogo VARCHAR(100) NOT NULL,
    categoria_jogo VARCHAR(50),
    status_jogo VARCHAR(20) DEFAULT 'Disponivel',
    aluguel_hora_atual DECIMAL(10,2) NOT NULL
);


-- 2. TABELAS DEPENDENTES (COM CHAVES ESTRANGEIRAS)

CREATE TABLE Reserva (
    id_reserva SERIAL PRIMARY KEY,
    data_hora_reserva TIMESTAMP NOT NULL,
    status_reserva VARCHAR(20) DEFAULT 'Agendada', -- 'Agendada', 'Concluida', 'Cancelada'
    qtd_pessoas_esperadas INT NOT NULL,
    id_cliente INT,
    id_mesa INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa)
);

CREATE TABLE Compra_Estoque (
    id_compra SERIAL PRIMARY KEY,
    data_compra DATE NOT NULL,
    valor_total_nota DECIMAL(10,2) NOT NULL,
    id_fornecedor INT,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);

CREATE TABLE Comanda (
    id_comanda SERIAL PRIMARY KEY,
    data_abertura TIMESTAMP NOT NULL,
    valor_total_consumo DECIMAL(10,2) DEFAULT 0.00,
    gorjeta DECIMAL(10,2) DEFAULT 0.00,
    status_comanda VARCHAR(20) DEFAULT 'Aberta',
    desconto_percentual DECIMAL(5,2) DEFAULT 0.00,
    id_cliente INT,
    id_mesa INT,
    id_funcionario INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
    CONSTRAINT chk_desconto CHECK (desconto_percentual BETWEEN 0.00 AND 100.00)
);


-- 3. TABELAS PONTE (RELACIONAMENTOS N:M)

-- Ligação Comanda -> Produto
CREATE TABLE Item_Comanda_Produto (
    id_comanda INT,
    id_produto INT,
    quantidade_pedida_produto INT NOT NULL,
    preco_un_cobrado_produto DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_comanda, id_produto),
    FOREIGN KEY (id_comanda) REFERENCES Comanda(id_comanda),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Ligação Comanda -> Insumo (Adicionais)
CREATE TABLE Item_Comanda_Insumo (
    id_item_insumo SERIAL PRIMARY KEY,
    id_comanda INT,
    id_insumo INT,
    quantidade_adicional_insumo INT NOT NULL,
    preco_un_cobrado_insumo DECIMAL(10,2) NOT NULL,
    referencia_item_pai INT NULL,
    FOREIGN KEY (id_comanda) REFERENCES Comanda(id_comanda),
    FOREIGN KEY (id_insumo) REFERENCES Insumo(id_insumo)
);

-- Ligação Comanda -> Jogo (Aluguel)
CREATE TABLE Item_Comanda_Jogo (
    id_comanda INT,
    id_jogo INT,
    hora_inicio_aluguel TIMESTAMP NOT NULL,
    hora_devolucao_aluguel TIMESTAMP,
    aluguel_hora_cobrado DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_comanda, id_jogo, hora_inicio_aluguel),
    FOREIGN KEY (id_comanda) REFERENCES Comanda(id_comanda),
    FOREIGN KEY (id_jogo) REFERENCES Jogo(id_jogo)
);

-- Ficha Técnica: Ligação Produto -> Insumo
CREATE TABLE Ficha_Tecnica_Produto (
    id_produto INT,
    id_insumo INT,
    quantidade_necessaria DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_produto, id_insumo),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_insumo) REFERENCES Insumo(id_insumo)
);

-- Ligação Compra_Estoque -> Insumo
CREATE TABLE Item_Compra_Insumo (
    id_compra INT,
    id_insumo INT,
    quantidade_comprada DECIMAL(10,2) NOT NULL,
    preco_custo_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_compra, id_insumo),
    FOREIGN KEY (id_compra) REFERENCES Compra_Estoque(id_compra),
    FOREIGN KEY (id_insumo) REFERENCES Insumo(id_insumo)
);
