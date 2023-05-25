-- Apagar o Banco de Dados caso ele já exista
DROP DATABASE IF EXISTS uvv;

-- Apagar o usuário caso ele já exista
DROP USER IF EXISTS Maria;

-- Criar usuário
CREATE USER Maria with 
CREATEDB
CREATEROLE
ENCRYPTED PASSWORD '2004';

-- Criar o Banco de Dados
CREATE DATABASE uvv
       OWNER Maria
	   TEMPLATE template0
	   ENCODING 'UTF8'
	   LC_COLLATE 'pt_BR.UTF-8'
	   LC_CTYPE 'pt_BR.UTF-8'
	   ALLOW_CONNECTIONS true;

\c uvv;

-- Criar esquema
CREATE SCHEMA AUTHORIZATION Maria;

-- Trocar esquema
ALTER USER Maria
SET SEARCH_PATH TO lojas, "$user", public;

-- Criar a tabela clientes
CREATE  TABLE clientes ( 
	clientes_id            numeric(38)   NOT NULL  ,
	email                  varchar(255)  NOT NULL  ,
	nome                   varchar(255)  NOT NULL  ,
	telefone1              varchar(20)             ,
	telefone2              varchar(20)             ,
	telefone3              varchar(20)             ,
	CONSTRAINT pk_clientes PRIMARY KEY ( clientes_id )
 );

-- Criar a tabela lojas
CREATE  TABLE lojas ( 
	loja_id                 numeric(38)   NOT NULL  ,
	nome                    varchar(255)  NOT NULL  ,
	endereco_web            varchar(100)            ,
	endereco_fisico         varchar(512)            ,
	latitude                numeric                 ,
	longitude               numeric                 ,
	logo                    bytea                   ,
	logo_mime_type          varchar(512)            ,
	logo_arquivo            varchar(512)            ,
	logo_charset            varchar(512)            ,
	logo_ultima_atualizacao date                    , 
	CONSTRAINT pk_lojas PRIMARY KEY ( loja_id )
 );

-- Criar a tabela pedidos
CREATE  TABLE pedidos ( 
	pedido_id             numeric(38)  NOT NULL  ,
	data_hora             time         NOT NULL  ,
	cliente_id            numeric(38)  NOT NULL  ,
	status                numeric(38)  NOT NULL  ,
	loja_id               numeric(38)  NOT NULL  ,
	CONSTRAINT pk_pedidos PRIMARY KEY ( pedido_id )
 );

-- Criar a tabela produtos
CREATE  TABLE produtos ( 
	produto_id                numeric(38)   NOT NULL  ,
	nome                      varchar(255)  NOT NULL  ,
	preco_unitario            numeric(10,2)           ,
	detalhes                  bytea                   ,
	imagem                    bytea                   ,
	imagem_mime_type          varchar(512)            ,
	imagem_arquivo            varchar(512)            ,
	imagem_charset            varchar(512)            ,
	imagem_ultima_atualizacao varchar(512)            ,
	CONSTRAINT pk_produtos PRIMARY KEY ( produto_id )
 );

-- Criar a tabela envios
CREATE  TABLE envios ( 
	envio_id             numeric(38)  NOT NULL  ,
	clientes_id          numeric(38)  NOT NULL  ,
	endereco_entrega     varchar(512) NOT NULL  ,
	status               varchar(15)  NOT NULL  ,
	loja_id              numeric(38)  NOT NULL  ,
	CONSTRAINT pk_envios PRIMARY KEY ( envio_id )
 );

-- Criar a tabela estoques
CREATE  TABLE estoques ( 
	estoque_id           numeric(38)  NOT NULL  ,
	loja_id              numeric(38)  NOT NULL  ,
	produto_id           numeric(38)  NOT NULL  ,
	quantidade           numeric(38)  NOT NULL  ,
	CONSTRAINT pk_estoques PRIMARY KEY ( estoque_id )
 );

-- Criar a tabela pedidos_itens
CREATE  TABLE pedidos_itens ( 
	pedido_id            numeric(38)   NOT NULL  ,
	produto_id           numeric(38)   NOT NULL  ,
	numero_da_linha      numeric(38)   NOT NULL  ,
	preco_unitario       numeric(10,2) NOT NULL  ,
	quantidade           numeric(38)   NOT NULL  ,
	envio_id             numeric(38)             ,
	CONSTRAINT pfk_pedidos_itens PRIMARY KEY ( pedido_id, produto_id )
 );

-- Criar as Foreign Key (FK)
ALTER TABLE envios        ADD CONSTRAINT fk_envios_clientes        FOREIGN KEY ( clientes_id ) REFERENCES clientes( clientes_id );

ALTER TABLE envios        ADD CONSTRAINT fk_envios_lojas           FOREIGN KEY ( loja_id )     REFERENCES lojas( loja_id )       ;

ALTER TABLE estoques      ADD CONSTRAINT fk_estoques_lojas         FOREIGN KEY ( loja_id )     REFERENCES lojas( loja_id )       ;

ALTER TABLE estoques      ADD CONSTRAINT fk_estoques_produtos      FOREIGN KEY ( produto_id )  REFERENCES produtos( produto_id ) ;

ALTER TABLE pedidos       ADD CONSTRAINT fk_clientes_pedidos       FOREIGN KEY ( cliente_id )  REFERENCES clientes( clientes_id );

ALTER TABLE pedidos       ADD CONSTRAINT fk_pedidos_lojas          FOREIGN KEY ( loja_id )     REFERENCES lojas( loja_id )       ;

ALTER TABLE pedidos_itens ADD CONSTRAINT fk_pedidos_itens_produtos FOREIGN KEY ( produto_id )  REFERENCES produtos( produto_id ) ;

ALTER TABLE pedidos_itens ADD CONSTRAINT fk_pedidos_itens_pedidos  FOREIGN KEY ( pedido_id )   REFERENCES pedidos( pedido_id )   ;

ALTER TABLE pedidos_itens ADD CONSTRAINT fk_pedidos_itens_envios   FOREIGN KEY ( envio_id )    REFERENCES envios( envio_id )     ;

-- Adicionar comentários de cada colunas das tabelas
COMMENT ON COLUMN clientes.clientes_id               IS 'Número de identificação do cliente.'                      ;

COMMENT ON COLUMN clientes.email                     IS 'Email do cliente.'                                        ;

COMMENT ON COLUMN clientes.nome                      IS 'Nome completo do cliente.'                                ;

COMMENT ON COLUMN clientes.telefone1                 IS 'Telefone do cliente.'                                     ;

COMMENT ON COLUMN clientes.telefone2                 IS 'Telefone 2  do cliente.'                                  ;

COMMENT ON COLUMN clientes.telefone3                 IS 'Telefone 3  do cliente.'                                  ;

COMMENT ON COLUMN lojas.loja_id                      IS 'Número de identificação da loja.'                         ;

COMMENT ON COLUMN lojas.nome                         IS 'Nome da loja.'                                            ;

COMMENT ON COLUMN lojas.endereco_web                 IS 'Endereço web (site) da loja.'                             ;

COMMENT ON COLUMN lojas.endereco_fisico              IS 'Endereço da loja.'                                        ;

COMMENT ON COLUMN lojas.latitude                     IS 'Latitude onde se localiza o endereço físico da loja.'     ;

COMMENT ON COLUMN lojas.longitude                    IS 'Longitude onde se localiza o endereço físico da loja.'    ;

COMMENT ON COLUMN lojas.logo                         IS 'Logo da loja.'                                            ;

COMMENT ON COLUMN lojas.logo_mime_type               IS 'Logo da loja em formato mime-type.'                       ;

COMMENT ON COLUMN lojas.logo_arquivo                 IS 'Arquivo da logo da loja.'                                 ;

COMMENT ON COLUMN lojas.logo_charset                 IS 'Logo da loja em formato charset.'                         ;

COMMENT ON COLUMN lojas.logo_ultima_atualizacao      IS 'Última atualização da logo da loja.'                      ;

COMMENT ON COLUMN pedidos.pedido_id                  IS 'Número de identificação do pedido.'                       ;

COMMENT ON COLUMN pedidos.data_hora                  IS 'Data e hora que foi feito o pedido.'                      ;

COMMENT ON COLUMN pedidos.cliente_id                 IS 'Número de identificação do cliente.'                      ;

COMMENT ON COLUMN pedidos.status                     IS 'Status do pedido.'                                        ;

COMMENT ON COLUMN pedidos.loja_id                    IS 'Número de identificação da loja.'                         ;

COMMENT ON COLUMN produtos.produto_id                IS 'Número de identificação de cada produto.'                 ;

COMMENT ON COLUMN produtos.nome                      IS 'Nome do produto.'                                         ;

COMMENT ON COLUMN produtos.preco_unitario            IS 'Preço unitário do produto.'                               ;

COMMENT ON COLUMN produtos.detalhes                  IS 'Detalhes do produto.'                                     ;

COMMENT ON COLUMN produtos.imagem                    IS 'Imagem do produto.'                                       ;

COMMENT ON COLUMN produtos.imagem_mime_type          IS 'Imagem do produto em formato mime-type.'                  ;

COMMENT ON COLUMN produtos.imagem_arquivo            IS 'Arquivo da imagem do produto.'                            ;

COMMENT ON COLUMN produtos.imagem_charset            IS 'Imagem do produto em formato charset.'                    ;

COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Última atualização da imagem do produto.'                 ;

COMMENT ON COLUMN envios.envio_id                    IS 'Número de identificação do envio de cada produto da loja.';

COMMENT ON COLUMN envios.clientes_id                 IS 'Número de identificação do cliente.'                      ;

COMMENT ON COLUMN envios.endereco_entrega            IS 'Endereço de entrega do envio do produto.'                 ;

COMMENT ON COLUMN envios.status                      IS 'Status do envio.'                                         ;

COMMENT ON COLUMN envios.loja_id                     IS 'Número de identificação da loja.'                         ;

COMMENT ON COLUMN estoques.estoque_id                IS 'Número de identificação do estoque.'                      ;

COMMENT ON COLUMN estoques.loja_id                   IS 'Número de identificação da loja.'                         ;

COMMENT ON COLUMN estoques.produto_id                IS 'Número de identificação de cada produto.'                 ;

COMMENT ON COLUMN estoques.quantidade                IS 'Quantidade de cada produto que possui no estoque.'        ;

COMMENT ON COLUMN pedidos_itens.pedido_id            IS 'Número de identificação do pedido.'                       ;

COMMENT ON COLUMN pedidos_itens.produto_id           IS 'Número de identificação de cada produto.'                 ;

COMMENT ON COLUMN pedidos_itens.numero_da_linha      IS 'Número da linha onde se localiza o produto.'              ;

COMMENT ON COLUMN pedidos_itens.preco_unitario       IS 'Preço unitário do produto.'                               ;

COMMENT ON COLUMN pedidos_itens.quantidade           IS 'Quantidade de cada produto.'                              ;

COMMENT ON COLUMN pedidos_itens.envio_id             IS 'Número de identificação do envio de cada produto da loja.';

-- Adicionar as restrições pedidas
ALTER TABLE lojas
ADD CONSTRAINT endereco_check
CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);
