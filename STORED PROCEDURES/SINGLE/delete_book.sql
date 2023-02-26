SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delete_book]
    @bookId INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

         -- Check for loan records associated with the book and delete them
        DELETE FROM loan WHERE bookId = @bookId;

        -- Verify that the book record exists
        IF NOT EXISTS (SELECT 1 FROM book WHERE bookId = @bookId)
        BEGIN
            RAISERROR('The book with ID %d does not exist.', 16, 1, @bookId);
            RETURN;
        END;

        -- Delete the book record
        DELETE FROM book WHERE bookId = @bookId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;

        -- Handle the error
        DECLARE @errorMessage NVARCHAR(1000) = ERROR_MESSAGE();
        RAISERROR(@errorMessage, 16, 1);
    END CATCH;
END
GO
