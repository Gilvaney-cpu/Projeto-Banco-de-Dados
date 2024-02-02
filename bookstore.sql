#DROP TABLE vendedor;
#DROP TABLE caixa;
#DROP TABLE gerente;
#DROP TABLE autor;
#DROP TABLE cliente;
#DROP TABLE bookstore;
#DROP TABLE pagamento;
#DROP TABLE livro_ref;
#DROP TABLE estoque;
#DROP TABLE estante;
#DROP TABLE prateleira;
#DROP TABLE fornecedor;
#DROP TABLE genero;
#DROP TABLE comissao;
#DROP TABLE nota_fiscal;
#DROP TABLE plano_fidelidade;
#DROP TABLE promocao;
#DROP TABLE encomenda;
#DROP TABLE pdv;
#DROP TABLE compra;
#DROP TABLE autor_livro;
#DROP TABLE genero_livro;
#DROP TABLE comissao_vendedor;
#DROP TABLE item_encomenda;

CREATE SCHEMA LIVRARIA;
USE LIVRARIA;

CREATE TABLE VENDEDOR (
    cpf VARCHAR(11) PRIMARY KEY,
    salario_base DECIMAL(10, 2),
    ramal INT,
    nome VARCHAR(50),
    idade INT,
    dt_nasc DATE,
    cnpj_bookstore VARCHAR(14),
    cpf_gerente VARCHAR(11),
    FOREIGN KEY (cnpj_bookstore) REFERENCES BOOKSTORE(cnpj),
    FOREIGN KEY (cpf_gerente) REFERENCES GERENTE(cpf)
);

CREATE TABLE CAIXA (
    cpf VARCHAR(11) PRIMARY KEY,
    salario_base DECIMAL(10, 2),
    ramal INT,
    nome VARCHAR(50),
    idade INT,
    dt_nasc DATE,
    cnpj_bookstore VARCHAR(14),
    cpf_gerente VARCHAR(11),
    dt_inicio DATE,
    dt_fim DATE,
    cod_pdv INT,
    FOREIGN KEY (cnpj_bookstore) REFERENCES BOOKSTORE(cnpj),
    FOREIGN KEY (cod_pdv) REFERENCES PDV(cod)
);

CREATE TABLE GERENTE (
    cpf VARCHAR(11) PRIMARY KEY,
    salario_base DECIMAL(10, 2),
    ramal INT,
    nome VARCHAR(50),
    idade INT,
    dt_nasc DATE,
    cnpj_bookstore VARCHAR(14),
    data_inicio DATE,
    data_fim DATE,
    FOREIGN KEY (cnpj_bookstore) REFERENCES BOOKSTORE(cnpj)
);

CREATE TABLE AUTOR (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(50),
    idade INT,
    dt_nasc DATE,
    flag_best_seller BOOLEAN,
    cod_livro INT
);

CREATE TABLE CLIENTE (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(50),
    idade INT,
    dt_nasc DATE,
    flag_professor BOOLEAN,
    status VARCHAR(50),
    dt_fim_adesao DATE,
    dt_inic_adesao DATE,
    cnpj_bookstore VARCHAR(14),
    cod_plan_fid INT,
    pontos_fidelidade INT,
    FOREIGN KEY (cnpj_bookstore) REFERENCES BOOKSTORE(cnpj),
    FOREIGN KEY (cod_plan_fid) REFERENCES PLANO_FIDELIDADE(cod)
);
CREATE TABLE BOOKSTORE (
    cnpj VARCHAR(14) PRIMARY KEY,
    razao_social VARCHAR(100),
    nome_fantasia VARCHAR(50),
    qtd_funcionarios INT,
    cod_estoque INT,
    endereco VARCHAR(100),
    FOREIGN KEY (cod_estoque) REFERENCES ESTOQUE(id)
);

CREATE TABLE PAGAMENTO (
    cod_pag INT PRIMARY KEY,
    vl_pago DECIMAL(10, 2),
    tipo_pagamento VARCHAR(50),
    bandeira VARCHAR(50)
);

CREATE TABLE LIVRO_REF (
    cod_barra VARCHAR(50) PRIMARY KEY,
    preco_fornec DECIMAL(10, 2),
    preco DECIMAL(10, 2),
    titulo VARCHAR(100),
    tipo_livro VARCHAR(50),
    ISBN VARCHAR(20),
    num_edicao INT,
    cnpj_fornecedor VARCHAR(14),
    FOREIGN KEY (cnpj_fornecedor) REFERENCES FORNECEDOR(cnpj)
);

CREATE TABLE ESTOQUE (
    id INT PRIMARY KEY,
    descricao VARCHAR(100),
    data_ult_compra DATE,
    cnpj_bookstore VARCHAR(14),
    FOREIGN KEY (cnpj_bookstore) REFERENCES BOOKSTORE(cnpj)
);

CREATE TABLE ESTANTE (
    serial VARCHAR(50) PRIMARY KEY,
    descricao VARCHAR(100)
);

CREATE TABLE PRATELEIRA (
    serial VARCHAR(50) PRIMARY KEY,
    num_nivel INT,
    serial_estante VARCHAR(50),
    FOREIGN KEY (serial_estante) REFERENCES ESTANTE(serial)
);

CREATE TABLE FORNECEDOR (
    cnpj VARCHAR(14) PRIMARY KEY,
    nome_fantasia VARCHAR(50),
    dt_inicio DATE,
    dt_fim DATE
);

CREATE TABLE GENERO (
    cod INT PRIMARY KEY,
    descricao VARCHAR(50)
);

CREATE TABLE COMISSAO (
    id INT PRIMARY KEY,
    tipo VARCHAR(50),
    dt_inicio DATE,
    dt_fim DATE,
    percentual DECIMAL(5, 2)
);

CREATE TABLE NOTA_FISCAL (
    codNF INT PRIMARY KEY,
    dt_emissao DATE,
    vl_total DECIMAL(10, 2),
    cod_pag INT,
    FOREIGN KEY (cod_pag) REFERENCES PAGAMENTO(cod_pag)
);

CREATE TABLE PLANO_FIDELIDADE (
    cod INT PRIMARY KEY,
    tipo VARCHAR(50),
    dt_inicio DATE,
    dt_fim DATE,
    descricao VARCHAR(100)
);

CREATE TABLE PROMOCAO (
    id INT PRIMARY KEY,
    tipo VARCHAR(50),
    dt_inicio DATE,
    dt_fim DATE,
    percentual DECIMAL(5, 2),
    cod_plano_fid INT,
    FOREIGN KEY (cod_plano_fid) REFERENCES PLANO_FIDELIDADE(cod)
);

CREATE TABLE ENCOMENDA (
    id INT PRIMARY KEY,
    data_pedido DATE,
    dt_prevista DATE,
    status VARCHAR(50),
    cpf_cliente VARCHAR(11),
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE(cpf)
);

CREATE TABLE PDV (
    cod INT PRIMARY KEY,
    dt_ult_manutencao DATE,
    descricao VARCHAR(100)
);

CREATE TABLE COMPRA (
    cod INT PRIMARY KEY,
    vl_desconto DECIMAL(10, 2),
    v_imposto DECIMAL(10, 2),
    dt_compra DATE,
    vl_total_bruto DECIMAL(10, 2),
    vl_total_a_pagar DECIMAL(10, 2),
    vl_comissao DECIMAL(10, 2),
    cod_pdv INT,
    cpf_vend VARCHAR(11),
    cod_NF INT,
    FOREIGN KEY (cod_pdv) REFERENCES PDV(cod),
    FOREIGN KEY (cpf_vend) REFERENCES VENDEDOR(cpf),
    FOREIGN KEY (cod_NF) REFERENCES NOTA_FISCAL(codNF)
);

CREATE TABLE AUTOR_LIVRO (
    isbn_livro VARCHAR(20),
    cpf_autor VARCHAR(11),
    PRIMARY KEY (isbn_livro, cpf_autor),
    FOREIGN KEY (isbn_livro) REFERENCES LIVRO_REF (isbn),
    FOREIGN KEY (cpf_autor) REFERENCES AUTOR (cpf)
);

CREATE TABLE GENERO_LIVRO (
    isbn_livro VARCHAR(20),
    cod_gen INT,
    PRIMARY KEY (isbn_livro, cod_gen),
    FOREIGN KEY (isbn_livro) REFERENCES LIVRO_REF (isbn),
    FOREIGN KEY (cod_gen) REFERENCES GENERO (cod)
);

CREATE TABLE COMISSAO_VENDEDOR (
    id_com INT,
    cpf_vend VARCHAR(11),
    PRIMARY KEY (id_com, cpf_vend),
    FOREIGN KEY (id_com) REFERENCES COMISSAO (id),
    FOREIGN KEY (cpf_vend) REFERENCES VENDEDOR (cpf)
);

CREATE TABLE ITEM_ENCOMENDA (
    id_encomenda INT,
    isbn_livro VARCHAR(20),
    qtd INT,
    PRIMARY KEY (id_encomenda, isbn_livro),
    FOREIGN KEY (id_encomenda) REFERENCES ENCOMENDA (id),
    FOREIGN KEY (isbn_livro) REFERENCES LIVRO_REF (isbn)
);


