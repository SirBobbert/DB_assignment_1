SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[insert_multiple_genres]

    @genreName1 VARCHAR(50),
    @genreName2 VARCHAR(50)

AS
BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

    INSERT INTO genre (genreName) VALUES (@genreName1)
    INSERT INTO genre (genreName) VALUES (@genreName2)

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
