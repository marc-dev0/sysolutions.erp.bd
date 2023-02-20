/*
declare 
	@salesOrderId int = 0
begin
	exec dbo.SalesOrderInsert '', 4.7, '1', 1, @salesOrderId output
	exec dbo.SalesOrderDetailInsert 52, 4.7, 'Kilogramos', 1, @salesOrderId, 2
end
GO



declare 
	@productId int = 5,
	@Description varchar(200) = 'Product1',
	@Code varchar(100) = '132',
	@CategoryId int = 1,
	@SubCategoryId int = 1,
	@BrandId int = 1,
	@State char(1) = '1',
	@AccountId int = 1,
	@ProductPresentationList AS dbo.ProductPresentationList
begin
	insert @ProductPresentationList (Id,EquivalentQuantity, Price, BarCode, MeasureFromId, MeasureToId)
	values (10, 5, 13.50, '100032423', 1, 1)
    insert @ProductPresentationList (Id,EquivalentQuantity, Price, BarCode, MeasureFromId, MeasureToId)
	values (0, 4, 15, '104477ds1', 3, 2)
	exec dbo.ProductInsertUpdate @productId, @Description, @Code, @CategoryId, @SubCategoryId, @BrandId,
			@State, @AccountId, @ProductPresentationList
end
GO


declare 
	@EntryNoteId int = 0,
	@Correlative varchar(100) = '',
	@State char(1) = '1',
	@CostPriceTotal decimal(16,6) = 4.5,
	@RegistrationAccountId int = 1,
	@EntryNoteList AS dbo.EntryNoteList
begin
	insert @EntryNoteList (Quantity, CostPrice, ProductId, EntryNoteId, ProductPresentationId)
	values (5000, 0.0047, 1, 0, 1)
	insert @EntryNoteList (Quantity, CostPrice, ProductId, EntryNoteId, ProductPresentationId)
	values (52, 3.5, 1, 0, 2)
	insert @EntryNoteList (Quantity, CostPrice, ProductId, EntryNoteId, ProductPresentationId)
	values (2, 150, 1, 0, 3)
	insert @EntryNoteList (Quantity, CostPrice, ProductId, EntryNoteId, ProductPresentationId)
	values (1, 2, 2, 0, 4)
	exec dbo.EntryNoteInsertUpdate @EntryNoteId, @Correlative, @State, @CostPriceTotal, @RegistrationAccountId, @EntryNoteList
end
GO



declare 
	@EntryNoteId int = 0,
	@Correlative varchar(100) = '',
	@State char(1) = '1',
	@CostPriceTotal decimal(16,6) = 0,
	@RegistrationAccountId int = 1,
	@EntryNoteList AS dbo.EntryNoteList
begin
	insert @EntryNoteList (Quantity, CostPrice, ProductId, EntryNoteId, ProductPresentationId)
	values (1, 10.5, 2, 0, 7)
	exec dbo.EntryNoteInsertUpdate @EntryNoteId, @Correlative, @State, @CostPriceTotal, @RegistrationAccountId, @EntryNoteList
end
GO


**/

INSERT INTO Account VALUES('MARC', '$2a$11$sBDrsl2ZQxbrupLdCzc2qeH1ddR68XX2bltVq86nptLzaCLcuVsvG', 'MIGUEL ANGEL', 'ROJAS CORAJE', '93334444', 'CORREO', '44413254', '1', 1, GETDATE(), NULL, NULL, NULL)

INSERT INTO Profile VALUES('ADMINISTRADOR', '1', NULL, NULL, GETDATE(), NULL)
INSERT INTO Profile VALUES('VENDEDOR', '1', NULL, NULL, GETDATE(), NULL)

INSERT INTO AccountProfile VALUES (1, 1, 1, NULL, '1', GETDATE(), NULL)

insert into Category (Description, State, RegistrationDate, RegistrationAccountId)
              values ('GENERAL', '1', GETDATE(), 1)
insert into Category (Description, State, RegistrationDate, RegistrationAccountId)
              values ('TEST1', '1', GETDATE(), 1)

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



insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Unidades', 'Uds', 1, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Unidad', 'Und', 2, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Caja', 'Cja', 4, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Bolsa', 'Bls', 3, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Paquete', 'Und', 5, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Gramos', 'Grm', 6, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Kilogramos', 'Kg', 7, '1', GETDATE(), 1);
insert into dbo.Measure (Description, ShortDescription, Hierarchy, State, RegistrationDate, RegistrationAccountId) values('Saco', 'Sc', 8, '1', GETDATE(), 1);

