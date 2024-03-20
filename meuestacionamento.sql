CREATE DATABASE estacionamento_universitario;


CREATE TABLE Estacionamento (

    id_estacionamento INT NOT NULL AUTO_INCREMENT, 
    nome_estacionamento VARCHAR(50) NOT NULL, 
    vagas_max SMALLINT UNSIGNED DEFAULT 0,
    telefone VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (id_estacionamento) );

create table cor (

id_cor int not null auto_increment,
nome_cor varchar(75) not null,
primary key (id_cor)
);

create table marca (

id_marca int not null auto_increment,
nome_marca varchar(45) not null,
website varchar(255) null default null,
primary key (id_marca)
);

create table tipo_veiculo (

id_tipo_veiculo char(1) not null,
tipo_veiculo varchar(45) not null,
primary key (id_tipo_veiculo)
);

create table tipo_usuario (

id_tipo_usuario char(1) not null,
tipo_usuario varchar(45) not null,
primary key (id_tipo_usuario)
);

create table sexo (

id_sexo char(1) not null,
sexo varchar(50) not null,
primary key (id_sexo)
);

create table categoria_modelo (

id_categoria_modelo int not null auto_increment,
tipo_modelo varchar(45) not null,
primary key (id_categoria_modelo)
);

create table combustivel (

id_combustivel tinyint not null auto_increment,
tipo_combustivel varchar(45) not null,
primary key (id_combustivel)
);

create table tracao (

id_tracao char(1) not null,
tipo_tracao varchar(30) not null,
primary key (id_tracao)
);

create table transmissao (

id_transmissao char(1) not null,
tipo_transmissao varchar(10) not null,
primary key (id_transmissao)
);

CREATE TABLE Usuario (

    id_usuario INT NOT NULL AUTO_INCREMENT,
    id_tipo_usuario CHAR(1) NOT NULL,
    id_sexo CHAR(1) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    sobrenome VARCHAR(45) NOT NULL,
    cpf CHAR(11) NOT NULL,
    cnh CHAR(11) NULL DEFAULT NULL,
    telefone VARCHAR(20) NOT NULL,
    celular VARCHAR(20) NULL DEFAULT NULL,
    email VARCHAR(254) NULL DEFAULT NULL,
    nascimento DATE NULL DEFAULT NULL,
    PRIMARY KEY (id_usuario),
    CONSTRAINT cpf_unique UNIQUE(cpf),
    CONSTRAINT fk_Usuario_Tipo_Usuario FOREIGN KEY (id_tipo_usuario)
        REFERENCES Tipo_Usuario (id_tipo_usuario),
    CONSTRAINT fk_Usuario_Sexo FOREIGN KEY (id_sexo)
        REFERENCES Sexo(id_sexo)

);

CREATE INDEX fk_Usuario_Tipo_Usuario_idx ON Usuario(id_tipo_usuario);

CREATE INDEX fk_Usuario_Sexo_idx ON Usuario(id_sexo);

create table modelo (

id_modelo int not null auto_increment,
id_marca int not null,
id_transmissao char(1) not null,
id_tracao char(1) not null,
id_categoria_modelo int not null,
nome_modelo varchar(75) not null,
lugares varchar(2) not null,
portas char(1) not null,
ano_modelo year null default null,
primary key (id_modelo),
constraint fk_modelo_transmissao foreign key (id_transmissao)
		references transmissao (id_transmissao),
constraint fk_modelo_marca foreign key (id_marca)
		references marca (id_marca),
constraint fk_modelo_tracao foreign key (id_tracao)
		references tracao (id_tracao),
constraint fk_modelo_categoria_modelo foreign key (id_categoria_modelo)
	references categoria_modelo (id_categoria_modelo)

);

create index fk_modelo_transmissao_idx ON modelo(id_transmissao);

create index fk_modelo_marca_idx ON modelo(id_marca);

create index fk_modelo_tracao_idx ON modelo(id_tracao);

create index fk_modelo_categoria_modelo_idx ON modelo(id_categoria_modelo);

create table veiculo (

renavam char(11) not null,
id_marca int not null,
id_modelo int not null,
id_tipo_veiculo char(1) not null,
id_cor int not null,
placa varchar(8) not null,
chassi varchar(20) null default null,
ano_fabricacao year not null,
primary key (renavam),
constraint placa_unique unique(placa),
constraint chassi_unique unique(chassi),
constraint fk_veiculo_marca foreign key (id_marca)
 references marca (id_marca),
constraint fk_veiculo_modelo foreign key (id_modelo)
 references modelo (id_modelo),
constraint fk_veiculo_tipo_veiculo foreign key (id_tipo_veiculo)
 references tipo_veiculo (id_tipo_veiculo),
constraint fk_veiculo_cor foreign key (id_cor)
 references cor (id_cor)
);

create index fk_veiculo_marca_idx ON veiculo(id_marca);

create index fk_veiculo_modelo_idx ON veiculo(id_modelo);

create index fk_veiculo_tipo_veiculo_idx ON veiculo(id_tipo_veiculo);

create index fk_veiculo_cor_idx ON veiculo(id_cor);

CREATE TABLE Cartao (
    via SMALLINT NOT NULL,
    id_usuario INT NOT NULL,
    emissao DATE NOT NULL,
    codigo_barras CHAR(13) NOT NULL,
    esta_ativo TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (via, id_usuario),
    CONSTRAINT fk_Cartao_Usuario FOREIGN KEY (id_usuario)
        REFERENCES Usuario(id_usuario)
);

CREATE INDEX fk_Cartao_Usuario_idx ON Cartao(id_usuario);




CREATE TABLE Historico_Estacionamento (
    
    id_estacionamento INT NOT NULL,
    renavam CHAR(11) NOT NULL,
    data_hora_entrada TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_hora_saida DATETIME NULL DEFAULT NULL,
    permanencia TIME GENERATED ALWAYS AS (TIMEDIFF(data_hora_saida, data_hora_entrada)) STORED,
    PRIMARY KEY (id_estacionamento, renavam, data_hora_entrada),
    CONSTRAINT fk_Historico_Estacionamento_Estacionamento FOREIGN KEY (id_estacionamento)
        REFERENCES Estacionamento(id_estacionamento),
    CONSTRAINT fk_Historico_Estacionamento_Veiculo FOREIGN KEY (renavam)
        REFERENCES Veiculo(renavam)

);

CREATE INDEX fk_Historico_Estacionamento_Veiculo_idx ON Historico_Estacionamento(renavam);

CREATE INDEX fk_Historico_Estacionamento_Estacionamento_idx ON Historico_Estacionamento (id_estacionamento);


create table propriedade (

renavam char(11) not null,
id_usuario int not null,
data_inicio timestamp not null default current_timestamp,
data_fim datetime null default null,

primary key (renavam, id_usuario, data_inicio),
constraint fk_propriedade_proprietario foreign key (id_usuario)
 references usuario(id_usuario),
constraint fk_propriedade_veiculo foreign key (renavam)
 references veiculo(renavam)

);

create index fk_propriedade_proprietario_idx ON propriedade(id_usuario);

create index fk_propriedade_veiculo_idx ON propriedade(renavam);



create table tipo_combustivel (

id_modelo int not null,
id_combustivel tinyint not null,
primary key (id_modelo, id_combustivel),
constraint fk_tipo_combustivel_combustivel foreign key (id_combustivel)
references combustivel(id_combustivel),
constraint fk_tipo_combustivel_modelo foreign key (id_modelo)
references modelo(id_modelo)
);

create index fk_tipo_combustivel_combustivel_idx ON tipo_combustivel(id_combustivel);

create index fk_tipo_combustivel_modelo_idx ON tipo_combustivel(id_modelo);