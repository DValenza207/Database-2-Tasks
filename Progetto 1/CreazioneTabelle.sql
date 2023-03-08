create schema Progetto1;
set search_path to Progetto1;

create table Correntista(
      email varchar(50) primary key,
	  nome varchar(20), 
	  saldo integer
	);
	
create table Categoria(
	  codice numeric(6) primary key,
	  categoria varchar(30),
	  sottocategoria varchar(30)
	);
	
create table Inserzione(
	  id numeric(6) primary key,
	  livello varchar(20), --possono essere basso, medio o alto
	  specifica varchar(20),
	  offre_richiede varchar(2), --o sì o no
	  email varchar(50) references Correntista(email),
	  codCat numeric(6) references Categoria(codice)
	);
	
	
	CREATE TABLE prestazione (
    id NUMERIC (6),
    idIns NUMERIC (6),
    idAltroCorr VARCHAR (50),
    data DATE,
    luogo VARCHAR (20),
    voto NUMERIC (2),

    PRIMARY KEY (id),
    FOREIGN KEY (idIns) REFERENCES inserzione(id),
    FOREIGN KEY (idAltroCorr) REFERENCES correntista(email)
);