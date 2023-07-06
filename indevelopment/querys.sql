DELETE FROM DBO.StorageProduct
INSERT INTO dbo.StorageProduct
SELECT 
        ABS(CHECKSUM(NEWID()) % 10), 1, a.ProductId, b.ProductPresentationId, 1, NULL, GETDATE(), NULL     
    FROM dbo.Product a 
    INNER JOIN dbo.ProductPresentation b on b.ProductId = a.ProductId

select 0, 1, a.ProductId, b.ProductPresentationId, 1, NULL, GETDATE(), NULL
FROM dbo.Product a 
    INNER JOIN dbo.ProductPresentation b on b.ProductId = a.ProductId


    select * from dbo.ProductPresentation
    select * from dbo.StorageProduct

select * from dbo.ProductPresentation
where ProductId = 1
and MeasureFromId NOT IN(8)

select * from Product
select * from ProductPresentation


SELECT CONCAT('10000000', FORMAT(1, '-'))

SELECT FORMAT(1, '10000000000')
SELECT CONCAT_WS('-', CONCAT(LEFT('10000000000', LEN('10000000000')-LEN(2)), 1), 2) AS Result;
select right('abcd', LEN('ABCD')-1)
SELECT LEN(15)
SELECT LEFT('ABCD', LEN('ABCD')-1)

