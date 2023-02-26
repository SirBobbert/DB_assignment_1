SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[find_book]
    @authorName VARCHAR(50) = NULL

AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        -- Check if author exists
        IF NOT EXISTS (SELECT authorId
    FROM author
    WHERE authorName = @authorName)
        BEGIN
        RAISERROR('Invalid author name', 16, 1);
    END

        -- Check if author has written any books
          IF NOT EXISTS (SELECT book.authorId, author.authorName
    FROM dbo.book
    INNER JOIN author ON book.authorId = author.authorId
    WHERE author.authorName = @authorName)
        BEGIN
        RAISERROR('Author has no written books', 16, 1);
    END

        -- body of the stored procedure
        SELECT book.title, author.authorName, book.numberOfPages, book.availability
    FROM dbo.book
        INNER JOIN author ON book.authorId = author.authorId
    WHERE author.authorName = @authorName

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            BEGIN
        ROLLBACK TRANSACTION
    END

         -- Handle the error
        DECLARE @errorMessage NVARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR(@errorMessage, 16, 1);
    END CATCH
END
GO
