SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[update_multiple_genres]

    @genreId1 INT,
    @genreId2 INT,
    @genreName1 VARCHAR(50),
    @genreName2 VARCHAR(50)

AS
BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

    UPDATE genre SET genreName = @genreName1 WHERE genreId = @genreId1
    UPDATE genre SET genreName = @genreName2 WHERE genreId = @genreId2

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
