SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[add_book]
    @title varchar(50),
    @authorName varchar(50),
    @ISBN INT,
    @publisherName varchar(50),
    @publicationDate DATE,
    @genreName varchar(50),
    @numberOfPages INT,
    @availability BIT
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
        RETURN;
    END 

            -- Check if publisher exists
            IF NOT EXISTS (SELECT publisherId
    FROM publisher
    WHERE publisherName = @publisherName)
            BEGIN
        RAISERROR('Invalid publisher name', 16, 1);
        RETURN;
    END 

            -- Check if genre exists
            IF NOT EXISTS (SELECT genreId
    FROM genre
    WHERE genreName = @genreName)
            BEGIN
        RAISERROR('Invalid genre name', 16, 1);
        RETURN;
    END 

        DECLARE @authorValue AS INT
        SELECT @authorValue = authorId
    FROM author
    WHERE authorName = @authorName

        DECLARE @publisherValue as INT
        SELECT @publisherValue = publisherId
    FROM publisher
    WHERE publisherName = @publisherName

        DECLARE @genreValue as INT
        SELECT @genreValue = genreId
    FROM genre
    WHERE genreName = @genreName

        INSERT INTO book
        (title, authorId, ISBN, publisherId, publicationDate, genreId, numberOfPages, availability)
    VALUES
        (@title, @authorValue, @ISBN, @publisherValue,
            @publicationDate, @genreValue, @numberOfPages, @availability);

        COMMIT TRANSACTION;
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
