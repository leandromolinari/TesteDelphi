create database TesteDelphi
go

use TesteDelphi
go

create table Produtos (
IdProduto int identity not null,
Codigo varchar(20) not null,
Descricao varchar(100) not null,
Marca varchar(50) null,
Modelo varchar(50) null,
Cor varchar(50) null
constraint PK_Produtos Primary key (IdProduto))
go