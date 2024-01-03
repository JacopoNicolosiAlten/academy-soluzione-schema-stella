create table DWH_D_FasciaOraria(
    skFasciaOraria int IDENTITY(1,1) PRIMARY KEY,
    [oraInizioValidita] TIME(0) null,
    oraFineValidita TIME(0) null,
    prezzoKwh decimal(4,3),
    codiceFasciaOraria char(1)
)

create table DWH_D_Tempo(
    skTempo int IDENTITY(1,1) PRIMARY KEY,
    year int null,
    month int null,
    [date] date null,
    yearMonth char(6) null,
    monthName varchar(50) null
)

create table DWH_D_Contratto(
    skContratto int IDENTITY(1,1) PRIMARY KEY,
    codiceContratto char(10) null,
    tipologiaContratto varchar(30) null,
    indirizzoLocale varchar(50) null,
    dataStipula date null,
    dataInizioFornitura date null,
    kwMassimiContratto decimal(4,1) null,
    tempoMassimoIntervento decimal(5,2) null,
    codiceContatore char(10) null,
    modello varchar(20) null,
    kwMassimiContatore decimal(4,1) null,
    dataInstallazioneContatore date null,
    nomeCitta varchar(30) null,
    codiceAreaGeografica char(5) null
)

create table DWH_D_Cliente(
    skCliente int IDENTITY(1,1) PRIMARY KEY,
    codiceCliente varchar(20) null,
    tipoCliente varchar(20) null,
    nome varchar(50) null,
    cognome varchar(50) null,
    numeroTelefono char(10) null,
    indirizzo varchar(50) null,
    ragioneSociale VARCHAR(50) null,
    professione VARCHAR(50) null,
    nomeReferente varchar(50) null,
    cognomeReferente varchar(50) null
)

create table DWH_Fact(
    skFact int IDENTITY(1,1) PRIMARY KEY,
    skFasciaOraria int not null FOREIGN KEY REFERENCES DWH_D_FasciaOraria,
    skCliente int not null FOREIGN KEY REFERENCES DWH_D_Cliente,
    skContratto int not null FOREIGN KEY REFERENCES DWH_D_Contratto,
    skTempo int not null FOREIGN KEY REFERENCES DWH_D_Tempo,
    sommaDovuta decimal(20,2) null,
    consumo decimal(38,5) null,
    numeroBolletta int not null,
    dataEmissioneBolletta date null,
    dataScadenzaPagamento date null
)