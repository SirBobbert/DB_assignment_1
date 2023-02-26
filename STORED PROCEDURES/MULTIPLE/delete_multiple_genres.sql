SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[delete_multiple_genres]

@genreId1 INT,
@genreId2 INT

AS
BEGIN

    BEGIN TRY
    BEGIN TRANSACTION

    DELETE FROM genre WHERE genreId = @genreId1
    DELETE FROM genre WHERE genreId = @genreId2

    COMMIT TRANSACTION
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        BEGIN
        ROLLBACK TRANSACTION
    END
END CATCH

END
GO
