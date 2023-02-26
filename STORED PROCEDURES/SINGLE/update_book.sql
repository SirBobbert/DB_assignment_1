SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_book]
    @bookId INT,
    @title VARCHAR(50) = NULL,
    @authorName VARCHAR(50) = NULL,
    @ISBN INT = NULL,
    @publisherName VARCHAR(50) = NULL,
    @publicationDate DATE = NULL,
    @genreName VARCHAR(50) = NULL,
    @numberOfPages INT = NULL,
    @availability BIT = NULLz
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if author exists
        IF NOT EXISTS (SELECT authorId
    FROM author
    WHERE authorName = @authorName)
            BEGIN
        RAISERROR('Invalid author name', 16, 1);
    END

        UPDATE book
        SET 
            title = ISNULL(@title, title),
            authorId = ISNULL((SELECT authorId
    FROM author
    WHERE authorName = @authorName), authorId),
            ISBN = ISNULL(@ISBN, ISBN),
            publisherId = ISNULL((SELECT publisherId
    FROM publisher
    WHERE publisherName = @publisherName), publisherId),
            publicationDate = ISNULL(@publicationDate, publicationDate),
            genreId = ISNULL((SELECT genreId
    FROM genre
    WHERE genreName = @genreName), genreId),
            numberOfPages = ISNULL(@numberOfPages, numberOfPages),
            availability = ISNULL(@availability, availability)
        WHERE bookId = @bookId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
        ROLLBACK TRANSACTION;

    END
    -- Handle the error
        DECLARE @errorMessage NVARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR(@errorMessage, 16, 1);
    END CATCH;
END;
GO
