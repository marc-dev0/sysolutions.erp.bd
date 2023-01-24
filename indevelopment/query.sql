CREATE DATABASE bd_erp
GO
USE bd_erp
GO
--$2a$11$sBDrsl2ZQxbrupLdCzc2qeH1ddR68XX2bltVq86nptLzaCLcuVsvG 1234
--drop database bd_erp;
--DROP TABLE dbo.Account
--DROP TABLE dbo.Profile
--DROP TABLE dbo.AccountProfile
--DROP TABLE dbo.Profile
CREATE TABLE dbo.Account (
    AccountId int IDENTITY(1,1) primary key not null,
    Client varchar(100) unique,
    Secret varchar(100),
    FirstName varchar(100),
    LastName varchar(100),
    Phone varchar(50),
    Mail varchar(50),
    IdentificationDocument varchar(50),
    State char(1),--1:Activo, 2: Inactivo
    ProfileId int,
    RegistrationDate datetime null,
    ModifiedDate datetime null,
    RegistrationAccountId int null,
    ModifiedAccountId int null,
    CONSTRAINT FK__User__RegistrationUserId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__User__ModifiedUserId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)


CREATE TABLE dbo.Profile (
    ProfileId int IDENTITY(1,1) primary key not null,
    Description varchar(100),
    State char(1),--1:Activo, 2: Inactivo
    RegistrationAccountId int NULL,
    ModifiedAccountId int NULL,
    RegistrationDate datetime NULL,
    ModifiedDate datetime NULL,
    CONSTRAINT FK__Profile__RegistrationAccountId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__Profile__ModifiedAccountId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)


INSERT INTO Account VALUES('MARC', '1234', 'MIGUEL ANGEL', 'ROJAS CORAJE', '93334444', 'CORREO', '44413254', '1', 1, GETDATE(), NULL, NULL, NULL)


INSERT INTO Profile VALUES('ADMINISTRADOR', '1', NULL, NULL, GETDATE(), NULL)
INSERT INTO Profile VALUES('VENDEDOR', '1', NULL, NULL, GETDATE(), NULL)

--DROP TABLE dbo.UserProfile
CREATE TABLE dbo.AccountProfile (
    AccountId int NULL,
    ProfileId int NULL,
    RegistrationAccountId int NULL,
    ModifiedAccountId int NULL,
    State char(1),--1:Activo, 2: Inactivo
    RegistrationDate datetime NULL,
    ModifiedDate datetime NULL,
    CONSTRAINT FK__UserProfile__RegistrationAccountId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__UserProfile__ModifiedAccountId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)

INSERT INTO AccountProfile VALUES (1, 1, 1, NULL, '1', GETDATE(), NULL)
GO

CREATE OR ALTER PROC ProfileGetAll
AS
BEGIN
    SELECT
            ProfileId,
            Description,
            CASE WHEN State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription,
            State,
            RegistrationDate
        FROM dbo.Profile
    --AND State = '1'
END
GO

CREATE OR ALTER PROC AccountGetByClient
(
    @Client VARCHAR(100)
)
AS
BEGIN
    SELECT
            AccountId, Secret, FirstName, LastName, Client,
            Names = FirstName + ' ' + LastName
        FROM dbo.Account
    WHERE Client = @Client
    AND State = '1'
END
GO

CREATE OR ALTER PROC AccountGetAll
(
    @Client VARCHAR(100)
)
AS
BEGIN
    SELECT
            a.AccountId, 
            a.FirstName, 
            a.LastName, 
            a.Client,
            CASE WHEN a.State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription,
            a.State,
            a.RegistrationDate,
            ProfileDescription = b.Description 
        FROM dbo.Account a
    LEFT JOIN dbo.Profile b on b.profileId = a.profileId
    WHERE Client LIKE '%'+ ISNULL(@Client, '') + '%'
    --AND State = '1'
END
GO

CREATE OR ALTER PROC AccountGetById
(
    @AccountId int
)
AS
BEGIN
    SELECT
            a.AccountId, 
            a.Client,
            a.Secret,
            a.IdentificationDocument,
            CASE WHEN a.State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription,
            a.State,
            a.FirstName, 
            a.LastName, 
            a.Phone,
            a.Mail,
            a.ProfileId,
            ProfileDescription = b.Description            
        FROM dbo.Account a
    LEFT JOIN dbo.Profile b on b.profileId = a.profileId
    WHERE AccountId = @AccountId
    --AND State = '1'
END
GO
--DROP PROC AccountInsert
CREATE OR ALTER PROC AccountInsert
(   
    @RegistrationAccountId INT,
    @Client VARCHAR(100),
    @Secret VARCHAR(100),
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Phone VARCHAR(50),
    @Mail varchar(50),
    @IdentificationDocument varchar(50),
    @State char(1),
    @ProfileId int
)
AS
BEGIN
    INSERT INTO Account 
            (RegistrationAccountId, 
             Client, 
             Secret, 
             FirstName, 
             LastName, 
             Phone,
             Mail,
             IdentificationDocument,
             State, 
             ProfileId,
             RegistrationDate)
           VALUES 
            (@RegistrationAccountId,
             @Client,
             @Secret,
             @FirstName,
             @LastName,
             @Phone,
             @Mail,
             @IdentificationDocument,
             @State,
             @ProfileId,
             GETDATE())
END
GO 

CREATE OR ALTER PROC AccountUpdate
(   
    @AccountId int,
    @ModifiedAccountId INT,
    @Client VARCHAR(100),
    @Secret VARCHAR(100),
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Phone VARCHAR(50),
    @Mail varchar(50),
    @IdentificationDocument varchar(50),
    @State char(1),
    @ProfileId int
)
AS
BEGIN
    UPDATE Account 
        SET ModifiedAccountId = @ModifiedAccountId,
            Client = @Client,
            Secret = ISNULL(NULLIF(@Secret,''), Secret),
            FirstName = @FirstName,
            LastName = @LastName,
            Phone = @Phone,
            Mail = @Mail,
            IdentificationDocument = @IdentificationDocument,
            ModifiedDate = GETDATE(),
            State = @State,
            ProfileId = @ProfileId
    WHERE AccountId = @AccountId
END
GO 

CREATE OR ALTER PROC AccountDelete
(
    @AccountId int,
    @ModifiedAccountId int
)
AS  
BEGIN
    UPDATE Account
        SET State = '2',
            ModifiedAccountId = @ModifiedAccountId
    WHERE AccountId = @AccountId
END
GO

CREATE TABLE dbo.Category (
    CategoryId int IDENTITY(1,1) primary key not null,
    Description varchar(100) unique,
    State char(1),--1:Activo, 2: Inactivo
    RegistrationDate datetime NULL,
    ModifiedDate datetime NULL,
    RegistrationAccountId int NULL,
    ModifiedAccountId int NULL,
    CONSTRAINT FK__Category__RegistrationUserId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__Category__ModifiedUserId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)
GO
insert into Category (Description, State, RegistrationDate, RegistrationAccountId)
              values ('GENERAL', '1', GETDATE(), 1)
insert into Category (Description, State, RegistrationDate, RegistrationAccountId)
              values ('TEST1', '1', GETDATE(), 1)

CREATE TABLE dbo.SubCategory (
    SubCategoryId int IDENTITY(1,1) primary key not null,
    Description varchar(100) unique,
    State char(1),--1:Activo, 2: Inactivo
    CategoryId int,
    RegistrationDate datetime NULL,
    ModifiedDate datetime NULL,
    RegistrationAccountId int NULL,
    ModifiedAccountId int NULL,
    CONSTRAINT FK__SubCategory__RegistrationUserId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__SubCategory__ModifiedUserId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__Subcategory__CategoryId_6B79F03D FOREIGN KEY (CategoryId) REFERENCES dbo.Category (CategoryId)
)
GO

insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CONSERVE','1',2,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CERVEZA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHOCOLATE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('PANETON','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('INTEGRALES','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CREMA DE LECHE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('HOT DOG','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('BARQUILLO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('FRUTOS SECOS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('WAFER NIK','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CARAMELO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('LICORES','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MUSS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('ENERGIZANTE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('WAFER','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CEREAL','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GOMAS AMBROSITO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('LECHE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHUPETES','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GOMITAS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('WAFFERS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CARAMELOS BLANDOS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('BOMBONES','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('TRIFRUNA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('VINO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GOMITA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GALLETA FRAC CHOCOLATE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MEGA  BARRA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CARAMELOS MASTICABLES','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHUPETIN COLORADO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CEREAL BAR','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MASTICABLE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('KEKE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('TURRON','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('TAPER GLOBO POP 18G','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MELLOWS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHAMPAGNE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GOMAS CALIPTUS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('FRUNA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('PAPA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('AZUCAR RUBIA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('NACHO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHOCOLATE VIZZIO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('TOFFEE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GOMAS DE MASCAR','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MEGA CHOC','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GALLETAS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHICLE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MARSHMALLOW','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('NECTAR','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('YOGURT','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('BROWNIE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('PALETAS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHUPETE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GALLETA GRAN CEREAL','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MALTIN','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GOMAS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('PISCO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('ARROZ PACAMAYO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MASMELOS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('HELADITO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GALLETA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('ACEITE DELEITE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHOCOLATES','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MINI MELLOWS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('SNACK COSTA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MANJAR BLANCO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('BIZCOCHO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('JUGO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('MANTEQUILLA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('DULCES GENERICOS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CIGARRO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('SPLOT','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('ALCOHOL ET','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('OLD ENGLAND TOFFEE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GALLETA GRETEL','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('BOX BOMBON','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CHOCOLATE RELLENO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('QUESO MOZARELLA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('AGUA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('BOCADITOS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('BEBIDA REHIDRATANTE','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('WAFER CLASICO','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('BEBIDA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('RON','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('IMPORTADOS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('GASEOSA','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('CARAMELOS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('SNACKS','1',1,GETDATE(),1)
insert into dbo.SubCategory (Description, State, CategoryId, RegistrationDate, RegistrationAccountId) values('LECHE EVAPORADA','1',1,GETDATE(),1)
GO

CREATE TABLE dbo.Brand (
    BrandId int identity(1,1) primary key not null,
    Description varchar(100) unique,
    State char(1),--1: Activo, 2: Inactivo
    RegistrationDate datetime null,
    ModifiedDate datetime null,
    RegistrationAccountId int null,
    ModifiedAccountId int null,
    CONSTRAINT FK__Brand__RegistrationUserId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__Brand__ModifiedUserId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)
GO
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ACONCAGUA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('HELENA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('JAZAM','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CHOCOLATE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DULZURA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CROCANTES DEL NORTE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CRAF','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CRUCEÑITO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('KRAFF','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('NATURAL','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('SOY DIET','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('KOLA REAL','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('PANADERIA ISIDRO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('FERRERO ROCHER','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ANY','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CBC LOGISTICS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('NUTRI DIET','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('APPLETON SPECIAL','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('AMBEV','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('SOBERANA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('HERBI','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ANGEL','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CONFIPERU','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('PAPI RICAS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('SUPER','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('AMBROSOLI','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('TANA CHOCOLATERÍA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ANDINA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ALFAJORES DE NANY','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('BUZZY','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ISIDRO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('APPLETON WHITE(BLANCO)','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('PERFETTI VAN MELLE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('SAN JORGE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('J&D SNACK','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('GUANDY','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DOCILE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('COCA COLA COMPANY','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('INCA COLA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('REPREX','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('BACKUS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DI PERUGIA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CYNKAT SAC','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('VIDA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('FERRERO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ARAS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('SIERRA VERDE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('MENTOS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CONFITECA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('MJF INVERSIONES','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('SM','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CRAFF','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('LABOCER','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ADRIANO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('WINTERS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('WAYKI','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('NESTLE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('BACARDI CARTA ORO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('BRITIS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CORPORACION BONY S.A.C','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('INVERSIONES DODDY EIRL','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ALDOR','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('IMPORTADO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('KOKOLIZO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('HERSHEY*S','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DULCITO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('TACAMA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('TROME','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('AMERICANDY','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('FLOR DE CAÑA   AÑEJO ORO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('HAMPTONS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('PRINGLES','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ANL','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ARCOR','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('FRITO LAYS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DEL PARAISO LIGHT','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('QUEIROLO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DIA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ADAMS - CADBURY','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('LA IBERICA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('VIDA Y SALUD','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('BARCELO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('SUPERIOR','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('PEPSICO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('LAIVE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DEYELLI','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('MOLITALIA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('NATURAL HOUSE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('KARINTO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('PEPSI COLA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('NOCHE BUENA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('NORTE Y SUR LIGHT','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('ACQUAFRESH','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('SAYON','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CUATRO GALLOS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('NABISCO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('COLOMBINA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('PORTON','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('CHAPLIN','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('AJE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('PERUFARMA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('COSTA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('COMERCIALIZADORA SALEM','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('GLORIA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DOS CERRITOS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DONOFRIO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('GURE','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('GUSTOZZI','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('IMPORTADOS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('VICTORIA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('RED BULL','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('LEXUS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('MI MALLITA','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('INVERSIONES CAMPOS','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('TABERNERO','1',GETDATE(),1)
insert into dbo.Brand (Description, State, RegistrationDate, RegistrationAccountId) values('DOS CABALLOS','1',GETDATE(),1)

--DROP TABLE Measure
CREATE TABLE dbo.Measure (
    MeasureId int identity(1,1) primary key not null,
    Description varchar(100) unique,
    ShortDescription varchar(10),
    Hierarchy int,
    State char(1),--1: Activo, 2: Inactivo
    RegistrationDate datetime null,
    ModifiedDate datetime null,
    RegistrationAccountId int null,
    ModifiedAccountId int null,
    CONSTRAINT FK__Measure__RegistrationUserId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__Measure__ModifiedUserId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)

insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Unidades', 'Uds', 1, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Unidad', 'Und', 2, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Caja', 'Cja', 4, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Bolsa', 'Bls', 3, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Paquete', 'Und', 5, '1', GETDATE(), 1);
EXEC sp_fkeys 'product'
--drop table dbo.product
CREATE TABLE dbo.Product (
    ProductId int identity(1,1) primary key not null,
    Description varchar(200),
    Code varchar(100),
    /*BarCode varchar(100),
    Price decimal(16,6),*/
    AverageCost decimal(16,6),
    CategoryId int null,
    SubCategoryId int null,
    BrandId int null,
    --MeasureId int null,
    State char(1),
    RegistrationDate datetime null,
    ModifiedDate datetime null,
    RegistrationAccountId int null,
    ModifiedAccountId int null,
    CONSTRAINT FK__Product__CategoryId__6B79F03D FOREIGN KEY (CategoryId) REFERENCES dbo.Category (CategoryId),
    CONSTRAINT FK__Product__SubCategoryId__6B79F03D FOREIGN KEY (SubCategoryId) REFERENCES dbo.SubCategory (SubCategoryId),
    CONSTRAINT FK__Product__BrandId__6B79F03D FOREIGN KEY (BrandId) REFERENCES dbo.Brand (BrandId),
    --CONSTRAINT FK__Product__MeasureId__6B79F03D FOREIGN KEY (MeasureId) REFERENCES dbo.Measure (MeasureId),
    CONSTRAINT FK__Product__RegistrationUserId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__Product__ModifiedUserId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)
GO
CREATE INDEX IDX__Product__GetAll ON dbo.Product (CategoryId, SubCategoryId, BrandId);
CREATE INDEX IDX__Product__CategoryId ON dbo.Product (CategoryId);
CREATE INDEX IDX__Product__SubCategoryId ON dbo.Product (SubCategoryId);
CREATE INDEX IDX__Product__BrandId ON dbo.Product (BrandId);
GO

--DROP TABLE dbo.ProductPresentation
CREATE TABLE dbo.ProductPresentation
(
    ProductPresentationId int identity(1,1) primary key not null,
    EquivalentQuantity int,
    Price decimal(16,6),
    BarCode varchar(15),
    MeasureFromId int,
    MeasureToId int,
    ProductId int,
    CONSTRAINT FK__ProductPresentation__MeasureFromId__6B79F03D FOREIGN KEY (MeasureFromId) REFERENCES dbo.Measure (MeasureId),
    CONSTRAINT FK__ProductPresentation__MeasureToId__6B79F03D FOREIGN KEY (MeasureToId) REFERENCES dbo.Measure (MeasureId),
    CONSTRAINT FK__ProductPresentation__ProductId__6B79F03D FOREIGN KEY (ProductId) REFERENCES dbo.Product (ProductId),
)
GO

CREATE TYPE ProductPresentationList as Table (
    Id int,
    EquivalentQuantity int,
    Price decimal(16,6),
    BarCode varchar(15),
    MeasureFromId int,
    MeasureToId int
)
GO

declare 
	@productId int = 0,
	@Description varchar(200) = 'Product1',
	@Code varchar(100) = '132',
	@CategoryId int = 1,
	@SubCategoryId int = 1,
	@BrandId int = 1,
	@State char(1) = '1',
	@AccountId int = 1,
	@ProductPresentationList AS dbo.ProductPresentationList
begin
	insert @ProductPresentationList (EquivalentQuantity, Price, BarCode, MeasureFromId, MeasureToId)
	values (5, 13.50, '100032423', 1, 1)
	insert @ProductPresentationList (EquivalentQuantity, Price, BarCode, MeasureFromId, MeasureToId)
	values (4, 15, '104477ds1', 3, 2)
	exec dbo.ProductInsert @productId, @Description, @Code, @CategoryId, @SubCategoryId, @BrandId,
			@State, @AccountId, @ProductPresentationList
end
GO
SELECT * FROM Product
select * from ProductPresentation
GO
CREATE OR ALTER PROC dbo.ProductInsert
(
    @ProductId int,
    @Description varchar(200),
    @Code varchar(100),
    @CategoryId int,
    @SubCategoryId int,
    @BrandId int,
    @State char(1),
    @AccountId int,
    --ProductPresentation
    /*@ProductPresentationId int,
    @EquivalentQuantity int,
    @Price decimal(16,6),
    @BarCode varchar(15),
    @MeasureFromId int,
    @MeasureToId int*/
    @ProductPresentationList ProductPresentationList READONLY
)
AS 
    DECLARE @L_ProductId int = 0
    DECLARE @Id int, @EquivalentQuantity int, @Price decimal(16,6), @Barcode varchar(15), @MeasureFromId int, @MeasureToId int
BEGIN
    IF @ProductId = 0 
        BEGIN
            INSERT INTO dbo.Product 
                                ([Description], 
                                Code, 
                                CategoryId, 
                                SubCategoryId, 
                                BrandId, 
                                State, 
                                RegistrationDate, 
                                RegistrationAccountId)
                   VALUES       
                                (@Description, 
                                @Code,
                                @CategoryId,
                                @SubCategoryId,
                                @BrandId,
                                @State,
                                GETDATE(),
                                @AccountId)
            SET @L_ProductId = (SELECT SCOPE_IDENTITY())

            DECLARE Cursor1 CURSOR FOR 
            SELECT Id, EquivalentQuantity, Price, BarCode, MeasureFromId, MeasureToId FROM @ProductPresentationList

            OPEN Cursor1 
                FETCH Cursor1 INTO @Id, @EquivalentQuantity, @Price, @Barcode, @MeasureFromId, @MeasureToId

            WHILE @@FETCH_STATUS = 0
                BEGIN
                    INSERT INTO dbo.ProductPresentation 
                                (EquivalentQuantity,
                                Price,
                                BarCode,
                                MeasureFromId,
                                MeasureToId,
                                ProductId)
                    VALUES      
                                (@EquivalentQuantity,
                                @Price,
                                @BarCode,
                                @MeasureFromId,
                                @MeasureToId,
                                @L_ProductId)
                    FETCH Cursor1 INTO @Id, @EquivalentQuantity, @Price, @Barcode, @MeasureFromId, @MeasureToId
                END
            CLOSE Cursor1
            DEALLOCATE Cursor1          
        END
    ELSE 
        BEGIN
            UPDATE dbo.Product
                SET [Description]   = @Description,
                    Code            = @Code,
                    CategoryId      = @CategoryId,
                    SubCategoryId   = @SubCategoryId,
                    BrandId         = @BrandId,
                    [State]         = @State,
                    ModifiedDate    = GETDATE(),
                    ModifiedAccountId = @AccountId
            WHERE ProductId         = @ProductId

            --UPDATE dbo.ProductPresentation                  
        END
END
GO

CREATE OR ALTER PROC ProductGetAll
AS
BEGIN
    SELECT
            a.ProductId,
            Category = b.Description,
            SubCategory = c.Description, 
            Brand = d.Description,
            Description = a.Description,
            A.BarCode,
            A.Price,
            CASE WHEN a.State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription,
            a.State,
            a.RegistrationDate
        FROM dbo.Product a
    INNER JOIN Category b on b.CategoryId = a.CategoryId
    inner join SubCategory c on c.CategoryId = b.CategoryId and c.SubCategoryId = a.SubCategoryId
    inner join Brand d on d.BrandId = a.BrandId 
    --AND State = '1'
END
GO

--DROP TABLE dbo.SalesOrder
CREATE TABLE dbo.SalesOrder (
    SalesOrderId int identity(1,1) primary key not null,
    Correlative varchar(20),
    Comment varchar(1000),
    Total decimal(16,6),
    State char(1),--1:Activo;2:Inactivo;3:Preparado;4
    RegistrationDate datetime null,
    ModifiedDate datetime null,
    RegistrationAccountId int null,
    ModifiedAccountId int null,
    CONSTRAINT FK__SalesOrder__RegistrationUserId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__SalesOrder__ModifiedUserId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)
GO

--DROP TABLE dbo.SalesOrderDetail
CREATE TABLE dbo.SalesOrderDetail (
    Amount int,
    Price decimal(16,6),
    ProductId int not null,
    SalesOrderId int not null,
    CONSTRAINT FK__SalesOrderDetail__ProductId__6B79F03D FOREIGN KEY (ProductId) REFERENCES dbo.Product (ProductId),
    CONSTRAINT FK__SalesOrderDetail__SalesOrderId__6B79F03D FOREIGN KEY (SalesOrderId) REFERENCES dbo.SalesOrder (SalesOrderId),
    CONSTRAINT PK__SalesOrdeDetail_PK PRIMARY KEY (ProductId, SalesOrderId)
)
GO

select * from SalesOrder
select * from SalesOrderDetail

CREATE TYPE dbo.SalesOrderDetailType AS TABLE (
    Amount int,
    ProductId int not null,
    SalesOrderId int not null
)
GO

CREATE OR ALTER PROC dbo.SalesOrderInsert
(
    @Comment varchar(1000),
    @Total decimal(16,6),
    @State char(1),
    @RegistrationAccountId int,
    @SalesOrderId int output
)
AS
    DECLARE @L_CORRELATIVE varchar(20)  = '';
    DECLARE @L_COUNT       int          = 0;
BEGIN
    SET @L_COUNT        = (SELECT COUNT(SalesOrderId)+1 FROM dbo.SalesOrder);
    SET @L_CORRELATIVE  = (SELECT RIGHT('NPV-000'+CAST(@L_COUNT AS VARCHAR(MAX)),15))

    INSERT INTO dbo.SalesOrder 
            (Correlative,
            Comment,
            Total,
            State,
            RegistrationDate,
            RegistrationAccountId)
           VALUES 
            (@L_CORRELATIVE,
             @Comment,
             @Total,
             @State,
             GETDATE(),
             @RegistrationAccountId)

    set @SalesOrderId = SCOPE_IDENTITY();
END
GO


CREATE OR ALTER PROC dbo.SalesOrderDetailInsert
(
    @Amount int,
    @Price decimal(16,6),
    @ProductId int,
    @SalesOrderId int
)
AS
BEGIN   
    INSERT INTO dbo.SalesOrderDetail
            (Amount,
            Price,
            ProductId,
            SalesOrderId)
           VALUES
            (@Amount,
            @Price,
            @ProductId,
            @SalesOrderId)
END
GO

CREATE OR ALTER PROC dbo.SalesOrderGetAll
(
    @First int,
    @Rows int
)
AS
BEGIN
    SELECT 
            a.SalesOrderId,
            a.Correlative,
            a.Comment, 
            a.Total, 
            CASE WHEN a.State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription,
            a.State,
            a.RegistrationDate,
            RegisteredUser = concat(d.FirstName, ' ', d.LastName)
        FROM dbo.SalesOrder a
    INNER JOIN dbo.Account d on d.AccountId = a.RegistrationAccountId--00:00:00.270
    --ORDER BY a.SalesOrderId OFFSET @First ROWS FETCH NEXT @Rows ROWS ONLY--00:00:00.176;
END
GO

CREATE OR ALTER PROC dbo.SalesOrderDetailGetAll
(
    @SalesOrderId int,
    @First int,
    @Rows int
)
AS
BEGIN
    SELECT 
            a.ProductId,
            Product = b.Description,
            a.Amount,
            a.Price
        FROM dbo.SalesOrderDetail a
    INNER JOIN dbo.Product b on b.ProductId = a.ProductId--00:00:00.270
    WHERE a.SalesOrderId        = @SalesOrderId
    ORDER BY a.SalesOrderId OFFSET @First ROWS FETCH NEXT @Rows ROWS ONLY--00:00:00.176;

END

sELECT * FROM SubCategory ORDER BY SubCategoryId OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;--00:00:00.725
sELECT * FROM SubCategory--00:00:00.281



  SELECT RIGHT('NPV-000'+CAST(155 AS VARCHAR(10)),10)

  delete from dbo.salesorder
  delete from dbo.salesorderdetail

  select * from dbo.Measure
  select * from dbo.Product
GO

CREATE OR ALTER PROC dbo.CategoryGetAll
AS
BEGIN
    SELECT 
            CategoryId, 
            Description
        FROM dbo.Category
    WHERE State = 1
END
GO 

CREATE OR ALTER PROC dbo.SubCategoryGetByCategoryId
(
    @CategoryId int
)
AS
BEGIN
    SELECT 
            SubCategoryId, 
            Description
        FROM dbo.SubCategory
    WHERE CategoryId = @CategoryId
    AND State = 1
END
GO 

select * from dbo.Category
select * from dbo.SubCategory
    select * from dbo.Account
select * from dbo.Product

update dbo.SubCategory
set CategoryId = 2
where SubCategoryId = 1

select * from Brand
GO
CREATE OR ALTER PROC dbo.BrandGetAll
AS
BEGIN
    SELECT 
            BrandId, 
            Description
        FROM dbo.Brand
    WHERE State = 1
END
GO 

CREATE OR ALTER PROC dbo.MeasureGetAll
AS
BEGIN
    SELECT 
            MeasureId, 
            Description
        FROM dbo.Measure
    WHERE State = 1
    ORDER BY Hierarchy ASC
END
GO 

SELECT * FROM Product
SELECT * FROM PRODUCT
