
CREATE DATABASE bd_erp_test
GO
USE bd_erp_test
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
GO

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
GO

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

CREATE OR ALTER PROC dbo.CategoryInsert(
    @Description varchar(100),
    @State char(1),
    @RegistrationAccountId int
)
AS
BEGIN

    INSERT INTO dbo.Category
        ([Description],
         [State],
         RegistrationDate,
         RegistrationAccountId)
    VALUES 
        (@Description,
         @State,
         GETDATE(),
         @RegistrationAccountId);
END
GO  

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

CREATE OR ALTER PROC dbo.SubCategoryInsert(
    @Description varchar(100),
    @State char(1),
    @CategoryId int,
    @RegistrationAccountId int
)
AS
BEGIN

    INSERT INTO dbo.SubCategory
        ([Description],
         [State],
         CategoryId,
         RegistrationDate,
         RegistrationAccountId)
    VALUES 
        (@Description,
         @State,
         @CategoryId,
         GETDATE(),
         @RegistrationAccountId);
END
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

CREATE OR ALTER PROC dbo.BrandInsert(
    @Description varchar(100),
    @State char(1),
    @RegistrationAccountId int
)
AS
BEGIN

    INSERT INTO dbo.Brand
        ([Description],
         [State],
         RegistrationDate,
         RegistrationAccountId)
    VALUES 
        (@Description,
         @State,
         GETDATE(),
         @RegistrationAccountId);
END
GO  

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
GO

CREATE OR ALTER PROC dbo.MeasureInsert(
    @Description varchar(100),
    @ShortDescription varchar(10),
    @State char(1),
    @RegistrationAccountId int
)
AS
    DECLARE @L_Hierarchy INT = 0;
BEGIN
    SET @L_Hierarchy = (SELECT MAX(Hierarchy)+1 FROM dbo.Measure);

    INSERT INTO dbo.Measure
        ([Description],
         ShortDescription,
         [Hierarchy],
         [State],
         RegistrationDate,
         RegistrationAccountId)
    VALUES 
        (@Description,
         @ShortDescription,
         @L_Hierarchy,
         @State,
         GETDATE(),
         @RegistrationAccountId);
END
GO
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
    BarCode varchar(100),
    Hierarchy int,
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
    BarCode varchar(100),
    Hierarchy int,
    MeasureFromId int,
    MeasureToId int
)
GO

CREATE OR ALTER PROC dbo.ProductInsertUpdate
(
    @ProductId int,
    @Description varchar(200),
    @Code varchar(100),
    @CategoryId int,
    @SubCategoryId int,
    @BrandId int,
    @State char(1),
    @AccountId int,
    @ProductPresentationList ProductPresentationList READONLY
)
AS 
    DECLARE @L_ProductId int = 0;
    DECLARE @l_exists_presentation int = 0;
    DECLARE @Id int, @EquivalentQuantity int, @Price decimal(16,6), @Barcode varchar(100),
            @L_Hierarchy int, @MeasureFromId int, @MeasureToId int
    DECLARE @L_Code varchar(100), @L_CodePresentation varchar(100);
    DECLARE @l_countProduct int = 0, @l_countProductPresentation int = 0;
BEGIN
    BEGIN TRY
        BEGIN TRAN
            PRINT 'STORAGEID' + cast(@ProductId as varchar(10))

            SELECT 
                    @l_countProduct = COUNT(*)
                FROM dbo.Product
            
            SET @L_Code = (SELECT FORMAT(IIF(@l_countProduct = 0, 1, @l_countProduct), '10000000000'))
            
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
                                        @L_Code,
                                        @CategoryId,
                                        @SubCategoryId,
                                        @BrandId,
                                        @State,
                                        GETDATE(),
                                        @AccountId)
                    SET @L_ProductId = (SELECT SCOPE_IDENTITY())

                    DECLARE Cursor1 CURSOR LOCAL FOR 
                    SELECT Id, EquivalentQuantity, Price, BarCode, Hierarchy, MeasureFromId, MeasureToId FROM @ProductPresentationList

                    OPEN Cursor1 
                        FETCH Cursor1 INTO @Id, @EquivalentQuantity, @Price, @Barcode, @L_Hierarchy, @MeasureFromId, @MeasureToId

                    WHILE @@FETCH_STATUS = 0
                        BEGIN
                            set @l_countProductPresentation += 1;
                            SET @L_CodePresentation = (SELECT CONCAT_WS('-', CONCAT(LEFT('10000000000', LEN('10000000000')-LEN(@l_countProductPresentation)), @l_countProduct), @l_countProductPresentation));
                            INSERT INTO dbo.ProductPresentation 
                                        (EquivalentQuantity,
                                        Price,
                                        BarCode,
                                        Hierarchy,
                                        MeasureFromId,
                                        MeasureToId,
                                        ProductId)
                            VALUES      
                                        (@EquivalentQuantity,
                                        @Price,
                                        @L_CodePresentation,
                                        @L_Hierarchy,
                                        @MeasureFromId,
                                        @MeasureToId,
                                        @L_ProductId)
                            FETCH Cursor1 INTO @Id, @EquivalentQuantity, @Price, @Barcode, @L_Hierarchy, @MeasureFromId, @MeasureToId
                        END
                    CLOSE Cursor1
                    DEALLOCATE Cursor1          
                END
            ELSE 
                BEGIN
                    PRINT 'UPDATE'
                    UPDATE dbo.Product
                        SET [Description]       = @Description,
                            Code                = @Code,
                            CategoryId          = @CategoryId,
                            SubCategoryId       = @SubCategoryId,
                            BrandId             = @BrandId,
                            [State]             = @State,
                            ModifiedDate        = GETDATE(),
                            ModifiedAccountId   = @AccountId
                    WHERE ProductId             = @ProductId

                    DECLARE Cursor1 CURSOR LOCAL FOR 
                        SELECT Id, EquivalentQuantity, Price, BarCode, Hierarchy, MeasureFromId, MeasureToId FROM @ProductPresentationList

                        OPEN Cursor1 
                            FETCH Cursor1 INTO @Id, @EquivalentQuantity, @Price, @Barcode, @L_Hierarchy, @MeasureFromId, @MeasureToId

                        WHILE @@FETCH_STATUS = 0
                            BEGIN
                            SET @l_exists_presentation = (
                                    SELECT COUNT(*) FROM dbo.ProductPresentation WHERE ProductId = @ProductId AND ProductPresentationId = @id
                                )
                                print @l_exists_presentation
                                IF @l_exists_presentation > 0 
                                    BEGIN
                                        UPDATE dbo.ProductPresentation
                                            SET EquivalentQuantity      = @EquivalentQuantity,
                                                Price                   = @Price,
                                                BarCode                 = @Barcode,
                                                Hierarchy               = @L_Hierarchy,
                                                MeasureFromId           = @MeasureFromId,
                                                MeasureToId             = @MeasureToId
                                        WHERE ProductId             = @ProductId
                                        AND ProductPresentationId   = @Id
                                    END
                                ELSE 
                                    BEGIN
                                        INSERT INTO dbo.ProductPresentation 
                                                    (EquivalentQuantity,
                                                    Price,
                                                    BarCode,
                                                    Hierarchy,
                                                    MeasureFromId,
                                                    MeasureToId,
                                                    ProductId)
                                        VALUES      
                                                    (@EquivalentQuantity,
                                                    @Price,
                                                    @BarCode,
                                                    @L_Hierarchy,
                                                    @MeasureFromId,
                                                    @MeasureToId,
                                                    @ProductId)
                                    END
                            FETCH Cursor1 INTO @Id, @EquivalentQuantity, @Price, @Barcode, @L_Hierarchy, @MeasureFromId, @MeasureToId
                        END
                        CLOSE Cursor1
                        DEALLOCATE Cursor1          
                END
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        DECLARE @ErrorNumber int
        DECLARE @ErrorSeverity varchar(1000), @ErrorState varchar(1000), @ErrorProcedure varchar(1000),
                @ErrorLine int, @ErrorMessage varchar(1000), @RegistrationDate datetime
        SELECT 
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorMessage = ERROR_MESSAGE(),
            @RegistrationDate = GETDATE();
        
        ROLLBACK TRAN;
        EXEC dbo.ErrorLogInsert @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage
        RAISERROR (@ErrorMessage,
                   @ErrorSeverity,
                   @ErrorState);
    END CATCH
END
GO

CREATE OR ALTER PROC ProductDelete
(
    @ProductId int,
    @ModifiedAccountId int
)
AS 
BEGIN
    BEGIN TRY
    UPDATE dbo.Product
        SET [State]             = '0',
            ModifiedAccountId   = @ModifiedAccountId,
            ModifiedDate        = GETDATE()
    WHERE ProductId = @ProductId
    END TRY
BEGIN CATCH
      DECLARE @ErrorNumber int
        DECLARE @ErrorSeverity varchar(1000), @ErrorState varchar(1000), @ErrorProcedure varchar(1000),
                @ErrorLine int, @ErrorMessage varchar(1000), @RegistrationDate datetime
        SELECT 
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorMessage = ERROR_MESSAGE(),
            @RegistrationDate = (SELECT CONVERT(datetimeoffset, GETDATE()) AT TIME ZONE 'SA Pacific Standard Time');
        
        EXEC dbo.ErrorLogInsert @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage
        RAISERROR (@ErrorMessage,
                   @ErrorSeverity,
                   @ErrorState);
END CATCH
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
            Code,
            a.state,
            CASE WHEN a.State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription,
            a.State,
            a.RegistrationDate
        FROM dbo.Product a
    INNER JOIN Category b on b.CategoryId = a.CategoryId
    inner join SubCategory c on c.CategoryId = b.CategoryId and c.SubCategoryId = a.SubCategoryId
    inner join Brand d on d.BrandId = a.BrandId 
    --AND a.State = '1'

    SELECT 
            a.ProductId,
            a.Price,
            a.BarCode,
            a.Hierarchy,
            EquivalentFrom = concat(1, ' ',c.[Description]),
            EquivalentTo = concat(a.EquivalentQuantity, ' ', d.[Description])
        FROM dbo.ProductPresentation a 
    INNER JOIN dbo.Product b ON b.ProductId = a.ProductId
    INNER JOIN dbo.Measure c ON c.MeasureId = a.MeasureFromId
    INNER JOIN dbo.Measure d ON d.MeasureId = a.MeasureToId
END
GO

CREATE OR ALTER PROC ProductGetById
(
    @ProductId int
)
AS
BEGIN
    SELECT
            a.ProductId,
            a.CategoryId,
            Category = b.Description,
            a.SubCategoryId,
            SubCategory = c.Description,
            a.BrandId,
            Brand = d.Description,
            Description = a.Description,
            a.Code,
            a.state
        FROM dbo.Product a
    INNER JOIN Category b       ON b.CategoryId = a.CategoryId
    INNER JOIN SubCategory c    ON c.CategoryId = b.CategoryId AND c.SubCategoryId = a.SubCategoryId
    INNER JOIN Brand d          ON d.BrandId = a.BrandId
    WHERE a.ProductId = @ProductId
    --AND a.State = '1'

    SELECT 
            a.ProductPresentationId,
            a.ProductId,
            a.Price,
            a.BarCode,
            a.Hierarchy,
            a.EquivalentQuantity,
            a.MeasureFromId,
            a.MeasureToId,
            EquivalentFrom =  c.[Description],
            EquivalentTo = d.[Description]
        FROM dbo.ProductPresentation a 
    INNER JOIN dbo.Product b ON b.ProductId = a.ProductId
    INNER JOIN dbo.Measure c ON c.MeasureId = a.MeasureFromId
    INNER JOIN dbo.Measure d ON d.MeasureId = a.MeasureToId
    WHERE a.ProductId = @ProductId
END
GO

CREATE OR ALTER PROC dbo.ProductPresentationGetByProductId
(
    @productId int
)
AS 
BEGIN
    SELECT 
            a.ProductPresentationId,
            EquivalentFrom = b.[Description],
            a.Price, 
            a.Hierarchy,
            a.MeasureFromId,
            a.EquivalentQuantity,
            c.Quantity,
            QuantityMax = (SELECT EquivalentQuantity from DBO.ProductPresentation aa WHERE aa.ProductId = @productId AND aa.MeasureToId = a.MeasureFromId AND aa.MeasureFromId <> a.MeasureToId)
        FROM dbo.ProductPresentation a
    INNER JOIN dbo.Measure b        ON b.MeasureId = a.MeasureFromId
    INNER JOIN dbo.StorageProduct c ON c.ProductId = a.ProductId AND c.ProductPresentationId = a.ProductPresentationId
    WHERE a.ProductId = @productId
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
    MeasureDescription varchar(50),
    ProductId int not null,
    SalesOrderId int not null,
    ProductPresentationId int not null,
    CONSTRAINT FK__SalesOrderDetail__ProductId__6B79F03D FOREIGN KEY (ProductId) REFERENCES dbo.Product (ProductId),
    CONSTRAINT FK__SalesOrderDetail__SalesOrderId__6B79F03D FOREIGN KEY (SalesOrderId) REFERENCES dbo.SalesOrder (SalesOrderId),
    CONSTRAINT FK__SalesOrderDetail__ProductPresentationId__6B79F03D FOREIGN KEY (ProductPresentationId) REFERENCES dbo.ProductPresentation (ProductPresentationId),
    CONSTRAINT PK__SalesOrdeDetail_PK PRIMARY KEY (ProductId, SalesOrderId, ProductPresentationId)
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
    SET @L_CORRELATIVE  = FORMAT(@L_COUNT, 'NDV-000000')

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
    @MeasureDescription varchar(50),
    @ProductId int,
    @SalesOrderId int,
    @ProductPresentationId int
)
AS
	DECLARE @L_Hierarchy int,
			@L_CountPresentation int = 1,
			@L_EquivalentQuantitySaved int = 1,
			@L_EquivalentQuantityParent int,			
			@L_QuantityTraceOut int,
			@L_QuantityTraceOutBefore int,
			@L_EquivalentQuantity int,
			@L_MeasureFromId int,
			@L_ProductPresentationIdParent int,
			@L_ProductPresentationId int
BEGIN   
    INSERT INTO dbo.SalesOrderDetail
            (Amount,
            Price,
            MeasureDescription,
            ProductId,
            SalesOrderId,
            ProductPresentationId)
           VALUES
            (@Amount,
            @Price,
            @MeasureDescription,
            @ProductId,
            @SalesOrderId,
            @ProductPresentationId)

    /*SET @L_EquivalentQuantitySaved = 1;
                            SET @L_EquivalentQuantityParent = 0;
                            SET @L_CountPresentation = 1;
                            SET @L_ProductPresentationIdParent = 0;
							set @L_QuantityTraceOutBefore = 0;
							
	SELECT 
			@L_Hierarchy = Hierarchy
		FROM dbo.ProductPresentation
    WHERE ProductId = @ProductId
    AND ProductPresentationId = @ProductPresentationId

	DECLARE CursorPresentation CURSOR LOCAL FOR
	SELECT 
			EquivalentQuantity,
			MeasureFromId,
			ProductPresentationId
		FROM dbo.ProductPresentation
	WHERE ProductId = @ProductId
	AND Hierarchy <= @L_Hierarchy
	ORDER BY Hierarchy DESC

	OPEN CursorPresentation 
		FETCH NEXT FROM CursorPresentation INTO @L_EquivalentQuantity, @L_MeasureFromId, @L_ProductPresentationId

	WHILE @@FETCH_STATUS = 0
		BEGIN
		print '@L_EquivalentQuantity' + cast(@L_EquivalentQuantity as varchar(1000))
		print '@L_MeasureFromId' + cast(@L_MeasureFromId as varchar(1000))
		print '@L_CountPresentatioN' + cast(@L_CountPresentation as varchar(1000))
		print '@@L_ProductPresentationId' + cast(@L_ProductPresentationId as varchar(1000))
			SELECT 
					@L_ProductPresentationIdParent	= a.ProductPresentationId,
                    @L_EquivalentQuantityParent		= a.EquivalentQuantity
                FROM dbo.ProductPresentation a
            WHERE a.ProductId = @ProductId
            AND a.MeasureToId = @L_MeasureFromId

			SELECT 
							@L_QuantityTraceOutBefore = QuantityTraceOut
						FROM dbo.StorageProduct
					WHERE Productid				= @ProductId
					AND ProductPresentationId	= @L_ProductPresentationId
			PRINT '@Amount' + CAST(@Amount AS VARCHAR(1000))
			IF @L_CountPresentation = 1 
				BEGIN
					UPDATE dbo.StorageProduct
						SET Quantity			= Quantity - @Amount,
							QuantityTraceOut	+= @Amount,
							ModifiedDate		= GETDATE()
					WHERE ProductId = @ProductId
					AND ProductPresentationId = @L_ProductPresentationId
				END
			ELSE 
				BEGIN
					UPDATE dbo.StorageProduct
						SET Quantity        = Quantity - (@L_EquivalentQuantitySaved * @Amount),
							ModifiedDate    = GETDATE()
					WHERE ProductId             = @ProductId
					AND ProductPresentationId   = @L_ProductPresentationId
				END
			print '@L_EquivalentQuantityParent' + cast(@L_EquivalentQuantityParent as varchar(1000))
			print '@L_QuantityTraceOutBefore' + cast(@L_QuantityTraceOutBefore as varchar(1000))
			print '@Amount' + cast(@Amount as varchar(1000))
			IF @L_EquivalentQuantityParent > 0
				BEGIN
					
					SELECT 
							@L_QuantityTraceOut = QuantityTraceOut
						FROM dbo.StorageProduct
					WHERE Productid				= @ProductId
					AND ProductPresentationId	= @L_ProductPresentationId
					print '@L_QuantityTraceOut' + cast(@L_QuantityTraceOut as varchar(1000))
					--Si la cantidad es igual a la cantidad equivalente de su medida padre
					IF ABS(@L_QuantityTraceOut) = @L_EquivalentQuantityParent 
						BEGIN
						PRINT 'ENTRO 1'
							UPDATE dbo.StorageProduct
								SET QuantityTraceOut	= 0,
									ModifiedDate		= GETDATE()
							WHERE ProductId             = @ProductId
							AND ProductPresentationId   = @L_ProductPresentationId

							IF @L_QuantityTraceOutBefore = 0 
								BEGIN
									UPDATE dbo.StorageProduct
										SET Quantity		-= 1,
											ModifiedDate    = GETDATE()
									WHERE ProductId				= @ProductId
									AND ProductPresentationId	= @L_ProductPresentationIdParent
								END
						END
					--Si la cantidad es menor a la cantidad equivalente de su medida padre
                    ELSE IF ((ABS(@Amount) < @L_EquivalentQuantityParent) AND 
							 (@L_QuantityTraceOutBefore = 0) AND
							 (@ProductPresentationId = @L_ProductPresentationId))
                        BEGIN
							PRINT 'ENTRO 2'
                            DECLARE @L_QuantityTraceOutCalculated INT = 0
                            SET @L_QuantityTraceOutCalculated = @Amount - (CAST(AVG(@Amount/@L_EquivalentQuantityParent) AS INTEGER) * @L_EquivalentQuantityParent)
                            print '@L_QuantityTraceOutCalculated' + cast(@L_QuantityTraceOutCalculated as varchar(1000))
							PRINT '@L_ProductPresentationIdParent' + CAST(@L_ProductPresentationIdParent AS VARCHAR(1000))
                           
                            UPDATE dbo.StorageProduct
								SET Quantity		= Quantity - 1,
									ModifiedDate    = GETDATE()-100
							WHERE ProductId				= @ProductId
							AND ProductPresentationId	= @L_ProductPresentationIdParent
                        END
					--Si la cantidad es mayor a la cantidad equivalente de su medida padre
                    ELSE IF ABS(@Amount) > @L_EquivalentQuantityParent
                        BEGIN
							PRINT 'ENTRO 3'
                            SET @L_QuantityTraceOutCalculated = @Amount - (CAST(AVG(@Amount/@L_EquivalentQuantityParent) AS INTEGER) * @L_EquivalentQuantityParent)
                            
                            UPDATE dbo.StorageProduct
                                SET QuantityTraceOut = @L_QuantityTraceOutCalculated,
									ModifiedDate    = GETDATE()
							WHERE ProductId             = @ProductId
							AND ProductPresentationId   = @L_ProductPresentationId

                            DECLARE @L_QuantityCalculated INT = 0
							SET @L_QuantityCalculated = CAST(AVG(@Amount/@L_EquivalentQuantityParent) AS INTEGER)

                            UPDATE dbo.StorageProduct
								SET Quantity		-= @L_QuantityCalculated,
									ModifiedDate    = GETDATE()
							WHERE ProductId				= @ProductId
							AND ProductPresentationId	= @L_ProductPresentationIdParent
                        END
					--Si la cantidad en el trace a la cantidad equivalente de su medida padre
                    ELSE IF @L_QuantityTraceOut > @L_EquivalentQuantityParent
                        BEGIN
							PRINT 'ENTRO 4'
                            SET @L_QuantityTraceOutCalculated = @L_QuantityTraceOut - (CAST(AVG(@L_QuantityTraceOut/@L_EquivalentQuantityParent) AS INTEGER) * @L_EquivalentQuantityParent)
                            UPDATE dbo.StorageProduct
								SET QuantityTraceOut = @L_QuantityTraceOutCalculated,
									ModifiedDate    = GETDATE()
							WHERE ProductId             = @ProductId
							AND ProductPresentationId   = @L_ProductPresentationId

							SET @L_QuantityCalculated = CAST(AVG(@L_QuantityTraceOut/@L_EquivalentQuantityParent) AS INTEGER)
								UPDATE dbo.StorageProduct
									SET Quantity		-= @L_QuantityCalculated,
										ModifiedDate    = GETDATE()
								WHERE ProductId				= @ProductId
								AND ProductPresentationId	= @L_ProductPresentationIdParent
                        END
					END
				ELSE 
					BEGIN
						PRINT 'ENTRO 5'
					END
	
			set @L_EquivalentQuantitySaved = IIF(@L_EquivalentQuantitySaved = 0, 1 * @L_EquivalentQuantity,@L_EquivalentQuantitySaved * @L_EquivalentQuantity);
			print '@@L_EquivalentQuantitySaved' + cast(@L_EquivalentQuantitySaved as varchar(4000))
			--SET @L_EquivalentQuantitySaved = @L_EquivalentQuantitySaved * @L_EquivalentQuantity;
			SET @L_CountPresentation = @L_CountPresentation + 1;
			PRINT '---------------------------------------------------------------------------'
            PRINT '---------------------------------------------------------------------------'
			FETCH NEXT FROM CursorPresentation INTO @L_EquivalentQuantity, @L_MeasureFromId, @L_ProductPresentationId

		END
	CLOSE CursorPresentation
	DEALLOCATE CursorPresentation **/
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
            Product = concat(b.Description, ' X ', a.MeasureDescription),
            a.Amount,
            a.Price
        FROM dbo.SalesOrderDetail a
    INNER JOIN dbo.Product b on b.ProductId = a.ProductId--00:00:00.270
    WHERE a.SalesOrderId        = @SalesOrderId
    --ORDER BY a.SalesOrderId OFFSET @First ROWS FETCH NEXT @Rows ROWS ONLY--00:00:00.176;

END
GO

CREATE OR ALTER PROC dbo.CategoryGetAll
AS
BEGIN
    SELECT 
            CategoryId, 
            Description,
            RegistrationDate,
            [State],
            CASE WHEN State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription
        FROM dbo.Category
    --WHERE State = 1
END
GO 

CREATE OR ALTER PROC dbo.MeasureGetAll
AS
BEGIN
    SELECT 
            MeasureId, 
            Description,
            ShortDescription,
            RegistrationDate,
            [State],
            CASE WHEN State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription
        FROM dbo.Measure
    ORDER BY Hierarchy ASC
END
GO 

CREATE OR ALTER PROC dbo.SubCategoryGetByCategoryId
(
    @CategoryId int
)
AS
BEGIN
    SELECT 
            a.SubCategoryId, 
            a.Description
        FROM dbo.SubCategory a
    WHERE a.CategoryId = @CategoryId
    AND State = 1
END
GO 

CREATE OR ALTER PROC dbo.SubCategoryGetAll
AS
BEGIN
    SELECT 
            CategoryDescription = b.[Description],
            a.SubCategoryId, 
            a.Description,
            a.RegistrationDate,
            a.[State],
            CASE WHEN a.State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription
        FROM dbo.SubCategory a
    INNER JOIN dbo.Category b ON b.CategoryId = a.CategoryId
    --AND State = 1
END
GO

CREATE OR ALTER PROC dbo.BrandGetAll
AS
BEGIN
    SELECT 
            BrandId, 
            Description,
            RegistrationDate,
            [State],
            CASE WHEN State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription
        FROM dbo.Brand
    --WHERE State = 1
END
GO 

--DROP TABLE dbo.Storage
CREATE TABLE dbo.Storage (
    StorageId int IDENTITY(1,1) primary key not null,
    Description varchar(100),
    Location varchar(100),
    CompanyId int,
    State char(1),--1:Activo, 2: Inactivo
    RegistrationAccountId int NULL,
    ModifiedAccountId int NULL,
    RegistrationDate datetime NULL,
    ModifiedDate datetime NULL,
    CONSTRAINT FK__Storage__RegistrationAccountId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__Storage__ModifiedAccountId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)
GO

CREATE OR ALTER PROC dbo.StorageInsert(
    @Description varchar(100),
    @Location varchar(100),
    @State char(1),
    @RegistrationAccountId int
)
AS
BEGIN

    INSERT INTO dbo.Storage
        ([Description],
         [Location],
         [State],
         RegistrationDate,
         RegistrationAccountId)
    VALUES 
        (@Description,
         @Location,
         @State,
         GETDATE(),
         @RegistrationAccountId);
END
GO 

CREATE OR ALTER PROC dbo.StorageGetAll
AS
BEGIN
    SELECT 
            StorageId, 
            Description,
            [Location],
            RegistrationDate,
            [State],
            CASE WHEN State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription
        FROM dbo.Storage    
END
GO 

--DROP TABLE dbo.StorageProduct
CREATE TABLE dbo.StorageProduct (
    Quantity int,
    QuantityTraceIn int default 0,
    QuantityTraceOut int default 0,
    StorageId int,
    ProductId int,
    ProductPresentationId int,
    RegistrationAccountId int NULL,
    ModifiedAccountId int NULL,
    RegistrationDate datetime NULL,
    ModifiedDate datetime NULL,
    CONSTRAINT FK__StorageProduct__RegistrationAccountId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__StorageProduct__ModifiedAccountId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT PK__StorageProduct_PK PRIMARY KEY (StorageId, ProductId, ProductPresentationId)
)   
GO

CREATE OR ALTER PROC dbo.StorageProductGetByStorageId
(
    @StorageId int,
    @CategoryId int,
    @SubCategoryId int,
    @Description varchar(200)
)
AS
BEGIN
    SELECT 
            c.EquivalentQuantity,
            a.Quantity, 
            b.ProductId, 
            ProductDescription = b.[Description], 
            c.MeasureFromId, 
            EquivalentFrom = d.[Description],
            CategoryBelongs = CONCAT(e.[Description], ' / ', f.[Description]),
            InventoryStatus = (
                CASE WHEN a.Quantity <= 0 THEN 'OUTOFSTOCK' 
                     WHEN a.Quantity >=1 AND a.Quantity < 20 THEN 'LOWSTOCK' 
                     ELSE 'INSTOCK' END)
        FROM dbo.StorageProduct a
    INNER JOIN dbo.Product b on b.ProductId = a.ProductId
    INNER JOIN dbo.ProductPresentation c on c.ProductId = b.ProductId AND c.ProductPresentationId = a.ProductPresentationId
    INNER JOIN dbo.Measure d on d.MeasureId = c.MeasureFromId
    INNER JOIN dbo.Category e on e.CategoryId = b.CategoryId
    INNER JOIN dbo.SubCategory f on f.CategoryId = e.CategoryId AND f.SubCategoryId = b.SubCategoryId
    WHERE a.StorageId               = @StorageId
    AND (e.CategoryId               = @CategoryId       OR @CategoryId      = 0)
    AND (f.SubCategoryId            = @SubCategoryId    OR @SubCategoryId   = 0)
    AND (LOWER(b.[Description])     LIKE '%' + LOWER(@Description) + '%'      
                                    OR @Description     IS NULL)
END
GO

CREATE OR ALTER TRIGGER dbo.TR_ProductPresentation_AfterInsert
ON dbo.ProductPresentation
AFTER INSERT 
AS
BEGIN
    /*BEGIN TRY*/
             PRINT 'INICIA RITGGER'
            DECLARE
                @ProductId int,
                @ProductPresentationId int,
                @RegistrationAccountId int,
                @StorageId int

            SELECT 
                    @ProductId = ProductId,
                    @ProductPresentationId = ProductPresentationId,
                    @RegistrationAccountId = 1
                FROM inserted a
            PRINT 'STORAGEID' + cast(@ProductId as varchar(10))
            PRINT '@ProductPresentationId' + cast(@ProductPresentationId as varchar(10))
            PRINT '@RegistrationAccountId' + cast(@RegistrationAccountId as varchar(10))
            DECLARE Cursor1 CURSOR LOCAL FOR 
            SELECT StorageId FROM dbo.Storage
            
            OPEN Cursor1
                FETCH Cursor1 INTO @StorageId
            
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    INSERT INTO dbo.StorageProduct
                            (
                             Quantity,
                             StorageId, 
                             ProductId, 
                             ProductPresentationId, 
                             RegistrationAccountId, 
                             RegistrationDate)
                    VALUES 
                            (
                             0,
                             @StorageId,
                             @ProductId, 
                             @ProductPresentationId, 
                             @RegistrationAccountId, 
                             GETDATE())

                    FETCH Cursor1 INTO @StorageId
                END
            CLOSE Cursor1
            DEALLOCATE Cursor1
            
        
    /*END TRY
    BEGIN CATCH
        DECLARE @ErrorNumber int
        DECLARE @ErrorSeverity varchar(1000), @ErrorState varchar(1000), @ErrorProcedure varchar(1000),
                @ErrorLine int, @ErrorMessage varchar(1000)
        SELECT 
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorMessage = ERROR_MESSAGE();

        ROLLBACK TRAN;
        INSERT INTO dbo.ErrorLog
        VALUES (@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage)
    END CATCH**/
END
GO

--DROP TABLE dbo.ErrorLog
CREATE TABLE dbo.ErrorLog
(
    ErrorNumber int,
    ErrorSeverity varchar(1000),
    ErrorState varchar(1000),
    ErrorProcedure varchar(1000),
    ErrorLine int,
    ErrorMessagee varchar(1000),
    RegistrationDate datetime
)
GO
CREATE OR ALTER PROC dbo.ErrorLogInsert
(
    @ErrorNumber int,
    @ErrorSeverity varchar(1000),
    @ErrorState varchar(1000),
    @ErrorProcedure varchar(1000),
    @ErrorLine int,
    @ErrorMessage varchar(1000)
)
AS
BEGIN
    INSERT INTO dbo.ErrorLog
    VALUES (@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, GETDATE())
END
GO

--DROP TABLE dbo.EntryNote
CREATE TABLE dbo.EntryNote
(
    EntryNoteId int IDENTITY(1,1) primary key not null,
    Correlative varchar(20),
    State char(1),--1:Activo, 2: Inactivo
    CostPriceTotal decimal(16,6),
    RegistrationAccountId int NULL,
    ModifiedAccountId int NULL,
    RegistrationDate datetime NULL,
    ModifiedDate datetime NULL,
    CONSTRAINT FK__EntryNote__RegistrationAccountId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__EntryNote__ModifiedAccountId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)   
)
GO

--DROP TABLE EntryNoteDetail
CREATE TABLE dbo.EntryNoteDetail
(
    Quantity int,
    CostPrice decimal(16,6),
    ProductId int not null,
    EntryNoteId int not null,
    ProductPresentationId int not null,
    CONSTRAINT FK__EntryNoteDetail__ProductId__6B79F03D FOREIGN KEY (ProductId) REFERENCES dbo.Product (ProductId),
    CONSTRAINT FK__EntryNoteDetail__EntryNoteId__6B79F03D FOREIGN KEY (EntryNoteId) REFERENCES dbo.EntryNote (EntryNoteId),
    CONSTRAINT FK__EntryNoteDetail__ProductPresentationId__6B79F03D FOREIGN KEY (ProductPresentationId) REFERENCES dbo.ProductPresentation (ProductPresentationId),
    CONSTRAINT PK__EntryNoteDetail_PK PRIMARY KEY (ProductId, EntryNoteId, ProductPresentationId)
)
GO

--DROP TYPE EntryNoteList
CREATE TYPE EntryNoteList as Table (
    Id int,
    Quantity int,
    CostPrice decimal(16,6),
    ProductId int,
    EntryNoteId int,
    ProductPresentationId int
)
GO  

CREATE OR ALTER PROC dbo.EntryNoteInsertUpdate
(
    @EntryNoteId int,
    @Correlative varchar(20),
    @State char(1),
    @CostPriceTotal decimal(16,6),
    @RegistrationAccountId int,
    @EntryNoteList EntryNoteList READONLY
)
AS
    DECLARE @L_EntryNoteId int = 0;
    DECLARE @Id int, 
            @Quantity int, 
            @CostPrice decimal(16,6), 
            @ProductId int, 
            @ProductPresentationId int
    DECLARE @L_EquivalentQuantity int,
            @L_EquivalentQuantitySaved int = 1,
            @L_EquivalentQuantityParent int,
			@L_QuantityTraceIn int,
            @L_MeasureFromId int,
			@L_ProductPresentationIdParent int
    DECLARE @L_Hierarchy int, 
            @L_CountPresentation int = 1,
            @L_CountEntrys int = 0
BEGIN
    BEGIN TRY
        BEGIN TRAN
            IF @EntryNoteId = 0
                BEGIN
                    SELECT 
                        @L_CountEntrys = COUNT(*) + 1
                    FROM dbo.EntryNote
                
                    SET @Correlative = FORMAT(@L_CountEntrys, 'ING-000000')
                    INSERT INTO dbo.EntryNote
                                    (Correlative,
                                     [State],
                                     CostPriceTotal,
                                     RegistrationDate,
                                     RegistrationAccountId)
                           VALUES   
                                    (@Correlative,
                                     @State,
                                     @CostPriceTotal,
                                     GETDATE(),
                                     @RegistrationAccountId)

                    SET @L_EntryNoteId = (SELECT SCOPE_IDENTITY())

                    DECLARE Cursor1 CURSOR LOCAL FOR 
                    SELECT Id, Quantity, CostPrice, ProductId, ProductPresentationId FROM @EntryNoteList

                    OPEN Cursor1 
                        FETCH NEXT FROM Cursor1 INTO @Id, @Quantity, @CostPrice, @ProductId, @ProductPresentationId

                    WHILE @@FETCH_STATUS = 0
                        BEGIN
                            print '@Id__' + cast(@Id as varchar(4000))
                            print '@Quantity__' + cast(@Quantity as varchar(4000))
                            print '@CostPrice__' + cast(@CostPrice as varchar(4000))
                            print '@ProductId__' + cast(@ProductId as varchar(4000))
							print '@@ProductPresentationId__' + cast(@ProductPresentationId as varchar(4000))
                            INSERT INTO dbo.EntryNoteDetail 
                                            (Quantity,
                                             CostPrice,
                                             ProductId,
                                             EntryNoteId,
                                             ProductPresentationId)
                                VALUES      
                                            (@Quantity,
                                             @CostPrice,
                                             @ProductId,
                                             @L_EntryNoteId,
                                             @ProductPresentationId)

                            SET @L_EquivalentQuantitySaved = 1;
                            SET @L_EquivalentQuantityParent = 0;
                            SET @L_CountPresentation = 1;
                            SET @L_QuantityTraceIn = 0;
                            SET @L_ProductPresentationIdParent = 0;
                         
                            SELECT 
                                    @L_Hierarchy = Hierarchy
                                FROM dbo.ProductPresentation
                            WHERE ProductId = @ProductId
                            AND ProductPresentationId = @ProductPresentationId
                            print '@L_Hierarchy' + cast(@ProductPresentationId as varchar(4000))
							/*print '@ProductId' + cast(@ProductId as varchar(10))
							print '@@ProductPresentationId' + cast(@ProductPresentationId as varchar(10))*/
                            DECLARE CursorPresentation CURSOR LOCAL FOR
                            SELECT 
                                    EquivalentQuantity,
                                    MeasureFromId,
									ProductPresentationId
                                FROM dbo.ProductPresentation
                            WHERE ProductId = @ProductId
                            AND Hierarchy <= @L_Hierarchy
							ORDER BY Hierarchy DESC

                            OPEN CursorPresentation 
                                FETCH NEXT FROM CursorPresentation INTO @L_EquivalentQuantity, @L_MeasureFromId, @ProductPresentationId
                            
                            WHILE @@FETCH_STATUS = 0
                                BEGIN
								print '@L_EquivalentQuantity' + cast(@L_EquivalentQuantity as varchar(10))
								print '@L_MeasureFromId' + cast(@L_MeasureFromId as varchar(10))
								print '@ProductPresentationId' + cast(@ProductPresentationId as varchar(10))
									
                                    SELECT 
                                            TOP 1
											@L_ProductPresentationIdParent	= ProductPresentationId,
                                            @L_EquivalentQuantityParent		= EquivalentQuantity
                                        FROM dbo.ProductPresentation
                                    WHERE ProductId = @ProductId
                                    AND MeasureToId = @L_MeasureFromId
                                    ORDER BY ProductPresentationId DESC
                                    PRINT '@L_ProductPresentationIdParent' + CAST(@L_ProductPresentationIdParent AS VARCHAR(100))
									print '@L_EquivalentQuantityParent' + cast(@L_EquivalentQuantityParent as varchar(4000))
                                    print '@L_CountPresentation' + cast(@L_CountPresentation as varchar(4000))
                                    
                                    IF @L_CountPresentation = 1 
                                        BEGIN
                                            print '@@@@Quantityxxx' + cast(@Quantity as varchar(10))
                                            print '@L_QuantityTraceIn' + cast(@L_QuantityTraceIn as varchar(10))
                                            
                                            UPDATE dbo.StorageProduct
                                                SET Quantity        = Quantity + CAST(@Quantity AS INT),
                                                    QuantityTraceIn += @Quantity,
                                                    ModifiedDate    = GETDATE()
                                            WHERE ProductId = @ProductId
                                            AND ProductPresentationId = @ProductPresentationId
                                        END
                                    ELSE 
                                        BEGIN
                                            UPDATE dbo.StorageProduct
                                                SET Quantity        = Quantity + (@L_EquivalentQuantitySaved * @Quantity),
                                                    ModifiedDate    = GETDATE()
                                            WHERE ProductId             = @ProductId
                                            AND ProductPresentationId   = @ProductPresentationId
                                        END

									IF @L_EquivalentQuantityParent > 0 
										BEGIN
                                            PRINT 'GAA'
											SELECT 
													@L_QuantityTraceIn = QuantityTraceIn
												FROM dbo.StorageProduct
											WHERE Productid				= @ProductId
											AND ProductPresentationId	= @ProductPresentationId
                                            print '@L_QuantityTraceIn' + cast(@L_QuantityTraceIn as varchar(4000))
											IF @L_QuantityTraceIn = @L_EquivalentQuantityParent
												BEGIN
													UPDATE dbo.StorageProduct
														SET QuantityTraceIn = 0,
															ModifiedDate    = GETDATE()
													WHERE ProductId             = @ProductId
													AND ProductPresentationId   = @ProductPresentationId

													UPDATE dbo.StorageProduct
														SET Quantity		+= 1,
															ModifiedDate    = GETDATE()
													WHERE ProductId				= @ProductId
													AND ProductPresentationId	= @L_ProductPresentationIdParent
												END
                                            ELSE IF @Quantity > @L_EquivalentQuantityParent 
                                                BEGIN
													DECLARE @L_QuantityTraceInCalculated INT = 0
													SET @L_QuantityTraceInCalculated = @Quantity - (CAST(AVG(@Quantity/@L_EquivalentQuantityParent) AS INTEGER) * @L_EquivalentQuantityParent)
													UPDATE dbo.StorageProduct
														SET QuantityTraceIn = @L_QuantityTraceInCalculated,
															ModifiedDate    = GETDATE()
													WHERE ProductId             = @ProductId
													AND ProductPresentationId   = @ProductPresentationId
                                                    
													DECLARE @L_QuantityCalculated INT = 0
													SET @L_QuantityCalculated = CAST(AVG(@Quantity/@L_EquivalentQuantityParent) AS INTEGER)
                                                    UPDATE dbo.StorageProduct
														SET Quantity		+= @L_QuantityCalculated,
															ModifiedDate    = GETDATE()
													WHERE ProductId				= @ProductId
													AND ProductPresentationId	= @L_ProductPresentationIdParent
                                                END
											ELSE IF @L_QuantityTraceIn > @L_EquivalentQuantityParent
												BEGIN
													SET @L_QuantityTraceInCalculated = @L_QuantityTraceIn - (CAST(AVG(@L_QuantityTraceIn/@L_EquivalentQuantityParent) AS INTEGER) * @L_EquivalentQuantityParent)
													UPDATE dbo.StorageProduct
														SET QuantityTraceIn = @L_QuantityTraceInCalculated,
															ModifiedDate    = GETDATE()
													WHERE ProductId             = @ProductId
													AND ProductPresentationId   = @ProductPresentationId
                                                    
													SET @L_QuantityCalculated = CAST(AVG(@L_QuantityTraceIn/@L_EquivalentQuantityParent) AS INTEGER)
                                                    UPDATE dbo.StorageProduct
														SET Quantity		+= @L_QuantityCalculated,
															ModifiedDate    = GETDATE()
													WHERE ProductId				= @ProductId
													AND ProductPresentationId	= @L_ProductPresentationIdParent
												END
										END
									ELSE 
                                        BEGIN
                                            UPDATE dbo.StorageProduct
                                                SET QuantityTraceIn = 0
                                            WHERE ProductId = @ProductId
                                            AND ProductPresentationId = @ProductPresentationId
                                        END
                                        
                                        
									
									set @L_EquivalentQuantitySaved = IIF(@L_EquivalentQuantitySaved = 0, 1 * @L_EquivalentQuantity,@L_EquivalentQuantitySaved * @L_EquivalentQuantity);
									print '@L_EquivalentQuantitySaved___' + cast(@L_EquivalentQuantitySaved as varchar(4000))
									--SET @L_EquivalentQuantitySaved = @L_EquivalentQuantitySaved * @L_EquivalentQuantity;
                                    SET @L_CountPresentation = @L_CountPresentation + 1;
                                    print '@L_CountPresentation__' + cast(@L_CountPresentation as varchar(4000))
                                    FETCH NEXT FROM CursorPresentation INTO @L_EquivalentQuantity, @L_MeasureFromId, @ProductPresentationId
                                END
                            CLOSE CursorPresentation
                            DEALLOCATE CursorPresentation 
                            PRINT '---------------------------------------------------------------------------'
                            PRINT '---------------------------------------------------------------------------'
                            FETCH NEXT FROM Cursor1 INTO @Id, @Quantity, @CostPrice, @ProductId, @ProductPresentationId

                        END
                    CLOSE Cursor1
                    DEALLOCATE Cursor1 
                END
            ELSE 
                BEGIN
                    PRINT 'UPDATE'
                END
        COMMIT TRAN
    END TRY
BEGIN CATCH
    DECLARE @ErrorNumber int
        DECLARE @ErrorSeverity varchar(1000), @ErrorState varchar(1000), @ErrorProcedure varchar(1000),
                @ErrorLine int, @ErrorMessage varchar(1000), @RegistrationDate datetime
        SELECT 
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE(),
            @ErrorMessage = ERROR_MESSAGE(),
            @RegistrationDate = GETDATE();
        
        ROLLBACK TRAN;
        EXEC dbo.ErrorLogInsert @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage
        RAISERROR (@ErrorMessage,
                   @ErrorSeverity,
                   @ErrorState);
END CATCH
END
GO

CREATE OR ALTER PROC dbo.EntryNoteGetaAll
AS 
BEGIN
    SELECT 
            a.EntryNoteId,
            a.Correlative, 
            a.CostPriceTotal,
            CASE WHEN a.State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription,
            a.State,
            a.RegistrationDate,
            RegisteredUser = concat(b.FirstName, ' ', b.LastName)
        FROM dbo.EntryNote a 
    INNER JOIN dbo.Account b on b.AccountId = a.RegistrationAccountId
END
GO

CREATE OR ALTER PROC dbo.EntryNoteDetailGetAll
(
    @EntryNoteId int
)
AS
BEGIN
    SELECT 
            a.ProductId,
            Product = concat(b.Description, ' X ', d.[Description]),
            a.Quantity,
            a.CostPrice
        FROM dbo.EntryNoteDetail a
    INNER JOIN dbo.Product b                on b.ProductId              = a.ProductId--00:00:00.270
    INNER JOIN dbo.ProductPresentation c    on c.ProductPresentationId  = a.ProductPresentationId
    INNER JOIN dbo.Measure d                on d.MeasureId              = c.MeasureFromId
    WHERE a.EntryNoteId        = @EntryNoteId
    --ORDER BY a.SalesOrderId OFFSET @First ROWS FETCH NEXT @Rows ROWS ONLY--00:00:00.176;

END
GO
/*
CREATE OR ALTER TRIGGER dbo.TR_EntryNoteDetail_AfterInsert
ON dbo.EntryNoteDetail
AFTER INSERT 
AS
BEGIN
    PRINT 'INICIA RITGGER'
    DECLARE
        @Quantity int,
        @ProductId int,
        @ProductPresentationId int,
        @RegistrationAccountId int,
        
        @StorageId int
        SELECT 
                @Quantity = Quantity,
                @ProductId = ProductId,
                @ProductPresentationId = ProductPresentationId,
                @RegistrationAccountId = 1
            FROM inserted a
        PRINT 'STORAGEID' + cast(@ProductId as varchar(10))
        PRINT '@ProductPresentationId' + cast(@ProductPresentationId as varchar(10))
        PRINT '@RegistrationAccountId' + cast(@RegistrationAccountId as varchar(10))

        DECLARE Cursor1 CURSOR LOCAL FOR 
        SELECT StorageId FROM dbo.Storage
            
        OPEN Cursor1
        FETCH Cursor1 INTO @StorageId
            
        WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE dbo.StorageProduct
                    SET Quantity = Quantity + @Quantity
                WHERE StorageId = @StorageId

                FETCH Cursor1 INTO @StorageId
            END
        CLOSE Cursor1
        DEALLOCATE Cursor1
            
END
GO

SELECT SUM(p.rows) FROM sys.partitions AS p
  INNER JOIN sys.tables AS t
  ON p.[object_id] = t.[object_id]
  INNER JOIN sys.schemas AS s
  ON s.[schema_id] = t.[schema_id]
  WHERE t.name = N'Brand'
  AND s.name = N'dbo'
  AND p.index_id IN (0,1);
**/


CREATE TABLE dbo.SalesPoint (
	SalesPointId int identity(1,1) primary key not null,
	Correlative varchar(20),
	SaleTotal decimal(16,6),
	State char(1),
	RegistrationDate datetime null,
    ModifiedDate datetime null,
    RegistrationAccountId int null,
    ModifiedAccountId int null,
    CONSTRAINT FK__SalesPoint__RegistrationUserId__6B79F03D FOREIGN KEY (RegistrationAccountId) REFERENCES dbo.Account (AccountId),
    CONSTRAINT FK__SalesPoint__ModifiedUserId__6B79F03D FOREIGN KEY (ModifiedAccountId) REFERENCES dbo.Account (AccountId)
)
GO

CREATE TABLE dbo.SalesPointDetail
(
	Quantity int,
	SalePrice decimal(16,6),
	ProductId int not null,
	SalesPointId int not null,
	ProductPresentationId int not null,
	CONSTRAINT FK__SalesPointDetail__ProductId__6B79F03D FOREIGN KEY (ProductId) REFERENCES dbo.Product (ProductId),
    CONSTRAINT FK__SalesPointDetail__SalesPointId__6B79F03D FOREIGN KEY (SalesPointId) REFERENCES dbo.SalesPoint (SalesPointId),
    CONSTRAINT FK__SalesPointDetail__ProductPresentationId__6B79F03D FOREIGN KEY (ProductPresentationId) REFERENCES dbo.ProductPresentation (ProductPresentationId),
    CONSTRAINT PK__SalesPointDetail_PK PRIMARY KEY (ProductId, SalesPointId, ProductPresentationId)
)
GO

CREATE TYPE SalesPointList as Table (
    Id int,
    Quantity int,
    SalePrice decimal(16,6),
    ProductId int,
    SalesPointId int,
    ProductPresentationId int
)
GO  

CREATE OR ALTER PROC dbo.SalesPointInsertUpdate
(
    @SalesPointId int,
	@Correlative varchar(20),
    @State char(1),
    @SaleTotal decimal(16,6),
    @RegistrationAccountId int,
    @SalesPointList SalesPointList READONLY
)
AS
	DECLARE @L_SalesPointeId int = 0;
    DECLARE @Id int, 
            @Quantity int, 
            @SalePrice decimal(16,6), 
            @ProductId int, 
            @ProductPresentationId int
    DECLARE @L_EquivalentQuantity int,
            @L_EquivalentQuantitySaved int = 1,
            @L_EquivalentQuantityParent int,
			@L_QuantityTraceOut int,
			@L_QuantityTraceOutBefore int,
            @L_MeasureFromId int,
			@L_ProductPresentationIdParent int,
			@L_ProductPresentationId int
    DECLARE @L_Hierarchy int, 
            @L_CountPresentation int = 1,
            @L_CountSales int = 0
BEGIN
	BEGIN TRY 
		BEGIN TRAN
			IF @SalesPointId = 0
				BEGIN
					SELECT 
                        @L_CountSales = COUNT(*) + 1
                    FROM dbo.SalesPoint
                
                    SET @Correlative = FORMAT(@L_CountSales, 'ING-000000')
                    INSERT INTO dbo.SalesPoint
                                    (Correlative,
                                     [State],
                                     SaleTotal,
                                     RegistrationDate,
                                     RegistrationAccountId)
                           VALUES   
                                    (@Correlative,
                                     @State,
                                     @SaleTotal,
                                     GETDATE(),
                                     @RegistrationAccountId)

					SET @L_SalesPointeId = (SELECT SCOPE_IDENTITY())

					DECLARE Cursor1 CURSOR LOCAL FOR 
                    SELECT Id, Quantity, SalePrice, ProductId, ProductPresentationId FROM @SalesPointList

                    OPEN Cursor1 
                        FETCH NEXT FROM Cursor1 INTO @Id, @Quantity, @SalePrice, @ProductId, @ProductPresentationId

                    WHILE @@FETCH_STATUS = 0
                        BEGIN
                            print '@Id__' + cast(@Id as varchar(4000))
                            print '@Quantity__' + cast(@Quantity as varchar(4000))
                            print '@SaleTotal_' + cast(@SaleTotal as varchar(4000))
                            print '@ProductId__' + cast(@ProductId as varchar(4000))
							print '@@ProductPresentationId__' + cast(@ProductPresentationId as varchar(4000))
                            INSERT INTO dbo.SalesPointDetail 
                                            (Quantity,
                                             SalePrice,
                                             ProductId,
                                             SalesPointId,
                                             ProductPresentationId)
                                VALUES      
                                            (@Quantity,
                                             @SaleTotal,
                                             @ProductId,
                                             @L_SalesPointeId,
                                             @ProductPresentationId)

                            SET @L_EquivalentQuantitySaved = 1;
                            SET @L_EquivalentQuantityParent = 0;
                            SET @L_CountPresentation = 1;
                            SET @L_QuantityTraceOut = 0;
							SET @L_QuantityTraceOutBefore = 0
                            SET @L_ProductPresentationIdParent = 0;
							SET @L_ProductPresentationId = 0;
                         
                            SELECT 
                                    @L_Hierarchy = Hierarchy
                                FROM dbo.ProductPresentation
                            WHERE ProductId = @ProductId
                            AND ProductPresentationId = @ProductPresentationId
                            print '@L_Hierarchy' + cast(@ProductPresentationId as varchar(4000))
							/*print '@ProductId' + cast(@ProductId as varchar(10))
							print '@@ProductPresentationId' + cast(@ProductPresentationId as varchar(10))*/
                            DECLARE CursorPresentation CURSOR LOCAL FOR
                            SELECT 
                                    EquivalentQuantity,
                                    MeasureFromId,
									ProductPresentationId
                                FROM dbo.ProductPresentation
                            WHERE ProductId = @ProductId
                            AND Hierarchy <= @L_Hierarchy
							ORDER BY Hierarchy DESC

                            OPEN CursorPresentation 
                                FETCH NEXT FROM CursorPresentation INTO @L_EquivalentQuantity, @L_MeasureFromId, @L_ProductPresentationId
                            
                            WHILE @@FETCH_STATUS = 0
                                BEGIN
								print '@L_EquivalentQuantity' + cast(@L_EquivalentQuantity as varchar(10))
								print '@L_MeasureFromId' + cast(@L_MeasureFromId as varchar(10))
								print '@L_ProductPresentationId' + cast(@L_ProductPresentationId as varchar(10))
									
                                    SELECT 
                                            TOP 1
											@L_ProductPresentationIdParent	= ProductPresentationId,
                                            @L_EquivalentQuantityParent		= EquivalentQuantity
                                        FROM dbo.ProductPresentation
                                    WHERE ProductId = @ProductId
                                    AND MeasureToId = @L_MeasureFromId
                                    ORDER BY ProductPresentationId DESC
                                    PRINT '@L_ProductPresentationIdParent' + CAST(@L_ProductPresentationIdParent AS VARCHAR(100))
									print '@L_EquivalentQuantityParent' + cast(@L_EquivalentQuantityParent as varchar(4000))
                                    print '@L_CountPresentation' + cast(@L_CountPresentation as varchar(4000))
                                    
									SELECT 
											@L_QuantityTraceOutBefore = QuantityTraceOut
										FROM dbo.StorageProduct
									WHERE Productid				= @ProductId
									AND ProductPresentationId	= @L_ProductPresentationId

                                    IF @L_CountPresentation = 1 
                                        BEGIN
                                            print '@@@@Quantityxxx' + cast(@Quantity as varchar(10))
                                            print '@L_QuantityTraceOutBefore' + cast(@L_QuantityTraceOutBefore as varchar(10))
                                            
                                            UPDATE dbo.StorageProduct
												SET Quantity			= Quantity - @Quantity,
													QuantityTraceOut	+= @Quantity,
													ModifiedDate		= GETDATE()
											WHERE ProductId = @ProductId
											AND ProductPresentationId = @L_ProductPresentationId
                                        END
                                    ELSE 
                                        BEGIN
											UPDATE dbo.StorageProduct
												SET Quantity        = Quantity - (@L_EquivalentQuantitySaved * @Quantity),
													ModifiedDate    = GETDATE()
											WHERE ProductId             = @ProductId
											AND ProductPresentationId   = @L_ProductPresentationId
										END

									IF @L_EquivalentQuantityParent > 0 
										BEGIN
                                            PRINT 'GAA'
											SELECT 
													@L_QuantityTraceOut = QuantityTraceOut
												FROM dbo.StorageProduct
											WHERE Productid				= @ProductId
											AND ProductPresentationId	= @L_ProductPresentationId
                                            print '@L_QuantityTraceOut' + cast(@L_QuantityTraceOut as varchar(4000))

											IF ABS(@L_QuantityTraceOut) = @L_EquivalentQuantityParent 
												BEGIN
													UPDATE dbo.StorageProduct
														SET QuantityTraceOut	= 0,
															ModifiedDate		= GETDATE()
													WHERE ProductId             = @ProductId
													AND ProductPresentationId   = @L_ProductPresentationId

													IF @L_QuantityTraceOutBefore = 0 
														BEGIN
															UPDATE dbo.StorageProduct
																SET Quantity		-= 1,
																	ModifiedDate    = GETDATE()
															WHERE ProductId				= @ProductId
															AND ProductPresentationId	= @L_ProductPresentationIdParent
														END
												END
											ELSE IF ((ABS(@Quantity) < @L_EquivalentQuantityParent) AND 
													(@L_QuantityTraceOutBefore = 0) AND
													(@ProductPresentationId = @L_ProductPresentationId))
                                                BEGIN
													PRINT 'ENTRO 2'
													DECLARE @L_QuantityTraceOutCalculated INT = 0
													SET @L_QuantityTraceOutCalculated = @Quantity - (CAST(AVG(@Quantity/@L_EquivalentQuantityParent) AS INTEGER) * @L_EquivalentQuantityParent)
													print '@L_QuantityTraceOutCalculated' + cast(@L_QuantityTraceOutCalculated as varchar(1000))
													PRINT '@L_ProductPresentationIdParent' + CAST(@L_ProductPresentationIdParent AS VARCHAR(1000))
													/*UPDATE dbo.StorageProduct
														SET QuantityTraceOut = QuantityTraceOut + @Amount,
															ModifiedDate     = GETDATE()-100
													WHERE ProductId             = @ProductId
													AND ProductPresentationId   = @ProductPresentationId*/

													UPDATE dbo.StorageProduct
														SET Quantity		= Quantity - 1,
															ModifiedDate    = GETDATE()-100
													WHERE ProductId				= @ProductId
													AND ProductPresentationId	= @L_ProductPresentationIdParent
                                                END
											ELSE IF ABS(@Quantity) > @L_EquivalentQuantityParent
												BEGIN
													PRINT 'ENTRO 3'
													SET @L_QuantityTraceOutCalculated = @Quantity - (CAST(AVG(@Quantity/@L_EquivalentQuantityParent) AS INTEGER) * @L_EquivalentQuantityParent)
													
													UPDATE dbo.StorageProduct
														SET QuantityTraceOut = @L_QuantityTraceOutCalculated,
															ModifiedDate     = GETDATE()
													WHERE ProductId             = @ProductId
													AND ProductPresentationId   = @L_ProductPresentationId

													DECLARE @L_QuantityCalculated INT = 0
													SET @L_QuantityCalculated = CAST(AVG(@Quantity/@L_EquivalentQuantityParent) AS INTEGER)

													UPDATE dbo.StorageProduct
														SET Quantity		-= @L_QuantityCalculated,
															ModifiedDate    = GETDATE()
													WHERE ProductId				= @ProductId
													AND ProductPresentationId	= @L_ProductPresentationIdParent
												END
											ELSE IF @L_QuantityTraceOut > @L_EquivalentQuantityParent
												BEGIN
													PRINT 'ENTRO 4'
													SET @L_QuantityTraceOutCalculated = @L_QuantityTraceOut - (CAST(AVG(@L_QuantityTraceOut/@L_EquivalentQuantityParent) AS INTEGER) * @L_EquivalentQuantityParent)
													UPDATE dbo.StorageProduct
														SET QuantityTraceOut = @L_QuantityTraceOutCalculated,
															ModifiedDate    = GETDATE()
													WHERE ProductId             = @ProductId
													AND ProductPresentationId   = @L_ProductPresentationId

													SET @L_QuantityCalculated = CAST(AVG(@L_QuantityTraceOut/@L_EquivalentQuantityParent) AS INTEGER)
														UPDATE dbo.StorageProduct
															SET Quantity		-= @L_QuantityCalculated,
																ModifiedDate    = GETDATE()
														WHERE ProductId				= @ProductId
														AND ProductPresentationId	= @L_ProductPresentationIdParent
												END
										END
									ELSE 
                                        BEGIN
											PRINT 'ENTRO 5'
                                            /*UPDATE dbo.StorageProduct
                                                SET QuantityTraceIn = 0
                                            WHERE ProductId = @ProductId
                                            AND ProductPresentationId = @ProductPresentationId*/
                                        END
                                        
                                        
									
									set @L_EquivalentQuantitySaved = IIF(@L_EquivalentQuantitySaved = 0, 1 * @L_EquivalentQuantity,@L_EquivalentQuantitySaved * @L_EquivalentQuantity);
									print '@L_EquivalentQuantitySaved___' + cast(@L_EquivalentQuantitySaved as varchar(4000))
									--SET @L_EquivalentQuantitySaved = @L_EquivalentQuantitySaved * @L_EquivalentQuantity;
                                    SET @L_CountPresentation = @L_CountPresentation + 1;
                                    print '@L_CountPresentation__' + cast(@L_CountPresentation as varchar(4000))
                                    FETCH NEXT FROM CursorPresentation INTO @L_EquivalentQuantity, @L_MeasureFromId, @L_ProductPresentationId
                                END
                            CLOSE CursorPresentation
                            DEALLOCATE CursorPresentation 
                            PRINT '---------------------------------------------------------------------------'
                            PRINT '---------------------------------------------------------------------------'
                            FETCH NEXT FROM Cursor1 INTO @Id, @Quantity, @SalePrice, @ProductId, @ProductPresentationId

                        END
                    CLOSE Cursor1
                    DEALLOCATE Cursor1 
				END
		COMMIT TRAN
	END TRY
BEGIN CATCH
	DECLARE @ErrorNumber int
    DECLARE @ErrorSeverity varchar(1000), @ErrorState varchar(1000), @ErrorProcedure varchar(1000),
            @ErrorLine int, @ErrorMessage varchar(1000), @RegistrationDate datetime
    SELECT 
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorProcedure = ERROR_PROCEDURE(),
        @ErrorLine = ERROR_LINE(),
        @ErrorMessage = ERROR_MESSAGE(),
        @RegistrationDate = GETDATE();
        
    ROLLBACK TRAN;
    EXEC dbo.ErrorLogInsert @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage
    RAISERROR (@ErrorMessage,
               @ErrorSeverity,
               @ErrorState);
END CATCH
END
GO

CREATE OR ALTER PROC dbo.SalesPointGetaAll
AS 
BEGIN
    SELECT 
            a.SalesPointId,
            a.Correlative, 
            a.SaleTotal,
            CASE WHEN a.State = '1' THEN 'Activo' ELSE 'Inactivo' END StateDescription,
            a.State,
            a.RegistrationDate,
            RegisteredUser = concat(b.FirstName, ' ', b.LastName)
        FROM dbo.SalesPoint a 
    INNER JOIN dbo.Account b on b.AccountId = a.RegistrationAccountId
END
GO

CREATE OR ALTER PROC dbo.SalesPointDetailGetAll
(
    @SalesPointId int
)
AS
BEGIN
    SELECT 
            a.ProductId,
            Product = concat(b.Description, ' X ', d.[Description]),
            a.Quantity,
            a.SalePrice
        FROM dbo.SalesPointDetail a
    INNER JOIN dbo.Product b                on b.ProductId              = a.ProductId--00:00:00.270
    INNER JOIN dbo.ProductPresentation c    on c.ProductPresentationId  = a.ProductPresentationId
    INNER JOIN dbo.Measure d                on d.MeasureId              = c.MeasureFromId
    WHERE a.SalesPointId        = @SalesPointId
    --ORDER BY a.SalesOrderId OFFSET @First ROWS FETCH NEXT @Rows ROWS ONLY--00:00:00.176;

END
GO


