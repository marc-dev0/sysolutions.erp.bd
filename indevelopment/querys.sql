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