USE FIFA_Sub20_Colombia2024;
GO

-- ================================================
-- SP1 - Generar Enfrentamientos Todos Contra Todos
-- en Fase de Grupos
-- Por: Juan José Pareja Ortíz
-- ================================================
CREATE OR ALTER PROCEDURE spGenerarPartidosFaseGrupos
    @IdCampeonato INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdFase INT;
    SELECT @IdFase = Id FROM Fase WHERE Fase = 'Grupos';

    IF @IdFase IS NULL
    BEGIN
        RAISERROR('No existe la fase "Grupos" en la tabla Fase.', 16, 1);
        RETURN;
    END;

    -- Recorrer cada grupo del campeonato
    DECLARE @IdGrupo INT;

    DECLARE grupos_cursor CURSOR FOR
        SELECT Id FROM Grupo WHERE IdCampeonato = @IdCampeonato;

    OPEN grupos_cursor;
    FETCH NEXT FROM grupos_cursor INTO @IdGrupo;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @Equipos TABLE (IdPais INT);
        
        INSERT INTO @Equipos
        SELECT IdPais FROM GrupoPais WHERE IdGrupo = @IdGrupo;

        IF (SELECT COUNT(*) FROM @Equipos) <> 4
        BEGIN
            RAISERROR('El grupo %d no tiene 4 países.', 16, 1, @IdGrupo);
            RETURN;
        END;

        DECLARE @p1 INT, @p2 INT, @p3 INT, @p4 INT;

        SELECT @p1 = (SELECT IdPais FROM @Equipos ORDER BY IdPais OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY);
        SELECT @p2 = (SELECT IdPais FROM @Equipos ORDER BY IdPais OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY);
        SELECT @p3 = (SELECT IdPais FROM @Equipos ORDER BY IdPais OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY);
        SELECT @p4 = (SELECT IdPais FROM @Equipos ORDER BY IdPais OFFSET 3 ROWS FETCH NEXT 1 ROWS ONLY);

        -- Todas las combinaciones del grupo (6 partidos)
        INSERT INTO Encuentro(IdPais1, IdPais2, IdEstadio, IdFase, IdCampeonato, Fecha, Goles1, Goles2)
        SELECT p1, p2, 1, @IdFase, @IdCampeonato, GETDATE(), 0, 0 UNION
        SELECT p1, p3, 2, @IdFase, @IdCampeonato, GETDATE(), 0, 0 UNION
        SELECT p1, p4, 3, @IdFase, @IdCampeonato, GETDATE(), 0, 0 UNION
        SELECT p2, p3, 4, @IdFase, @IdCampeonato, GETDATE(), 0, 0 UNION
        SELECT p2, p4, 1, @IdFase, @IdCampeonato, GETDATE(), 0, 0 UNION
        SELECT p3, p4, 2, @IdFase, @IdCampeonato, GETDATE(), 0, 0;

        FETCH NEXT FROM grupos_cursor INTO @IdGrupo;
    END;

    CLOSE grupos_cursor;
    DEALLOCATE grupos_cursor;

    PRINT 'Partidos generados correctamente para fase de grupos.';
END;
GO
