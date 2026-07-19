/*==============================================================================
  Elections - Schema
  ----------------------------------------------------------------------------
  מבנה מסד הנתונים בלבד: מסד, טבלאות, מפתחות זרים, Views, פונקציות ופרוצדורות.
  נתוני הדוגמה נמצאים בקובץ הנפרד seed-data.sql.

  סדר הרצה:
    1) schema.sql      (הקובץ הזה)
    2) seed-data.sql   (טעינת נתוני דוגמה)

  הערה: הסקריפט מניח מסד נקי. הרצה חוזרת דורשת DROP DATABASE Elections קודם.
==============================================================================*/

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
GO

IF DB_ID(N'Elections') IS NULL
    CREATE DATABASE [Elections];
GO
USE [Elections];
GO

/*------------------------------------------------------------------
  ( טבלאות  (מפתחות ראשיים ואילוצי ייחודיות מוגדרים inline
------------------------------------------------------------------*/

CREATE TABLE [dbo].[Parties](
    [id]            [int] IDENTITY(1,1) NOT NULL,
    [letters]       [varchar](3)  NOT NULL,
    [name]          [varchar](50) NOT NULL,
    [countMandates] [smallint]    NULL,
    CONSTRAINT [PK_Parties]     PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_Parties_letters] UNIQUE ([letters]),
    CONSTRAINT [UQ_Parties_name]    UNIQUE ([name])
);
GO

CREATE TABLE [dbo].[PollingStations](
    [id]            [int] IDENTITY(1,1) NOT NULL,
    [city]          [varchar](15)  NOT NULL,
    [address]       [varchar](20)  NOT NULL,
    [directions]    [varchar](100) NOT NULL,
    [accessibility] [bit]          NOT NULL,
    CONSTRAINT [PK_PollingStations] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[populationRegist](
    [id]            [int] IDENTITY(1,1) NOT NULL,
    [tz]            [varchar](9)  NOT NULL,
    [pollStationId] [int]         NOT NULL,
    [email]         [varchar](30) NULL,
    CONSTRAINT [PK_populationRegist] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_populationRegist_tz]    UNIQUE ([tz]),
    CONSTRAINT [UQ_populationRegist_email] UNIQUE ([email])
);
GO

CREATE TABLE [dbo].[Voters](
    [id]            [int] IDENTITY(1,1) NOT NULL,
    [idNumber]      [varchar](9) NOT NULL,
    [pollStationId] [int]        NULL,
    [voted]         [bit]        NOT NULL CONSTRAINT [DF_Voters_voted] DEFAULT ((0)),
    [votingTime]    [time](7)    NULL,
    CONSTRAINT [PK_Voters] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_Voters_idNumber] UNIQUE ([idNumber])
);
GO

CREATE TABLE [dbo].[specialVoters](
    [id]            [int] IDENTITY(1,1) NOT NULL,
    [idNumber]      [varchar](9) NOT NULL,
    [pollStationId] [int]        NOT NULL,
    CONSTRAINT [PK_specialVoters] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_specialVoters_idNumber] UNIQUE ([idNumber])
);
GO

CREATE TABLE [dbo].[Votes](
    [id]            [int] IDENTITY(1,1) NOT NULL,
    [pollStationId] [int] NOT NULL,
    [partyId]       [int] NOT NULL,
    CONSTRAINT [PK_Votes] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

/*------------------------------------------------------------------
  (מפתחות זרים  (נוספים לאחר טעינת הנתונים
------------------------------------------------------------------*/

-- קלפי -> תחנת הצבעה
ALTER TABLE [dbo].[populationRegist] WITH CHECK
    ADD CONSTRAINT [FK_populationRegist_PollingStations]
    FOREIGN KEY([pollStationId]) REFERENCES [dbo].[PollingStations]([id]);
GO
ALTER TABLE [dbo].[Voters] WITH CHECK
    ADD CONSTRAINT [FK_Voters_PollingStations]
    FOREIGN KEY([pollStationId]) REFERENCES [dbo].[PollingStations]([id]);
GO
ALTER TABLE [dbo].[specialVoters] WITH CHECK
    ADD CONSTRAINT [FK_specialVoters_PollingStations]
    FOREIGN KEY([pollStationId]) REFERENCES [dbo].[PollingStations]([id]);
GO

-- מצביע מיוחד חייב להיות במרשם האוכלוסין
ALTER TABLE [dbo].[specialVoters] WITH CHECK
    ADD CONSTRAINT [FK_specialVoters_populationRegist]
    FOREIGN KEY([idNumber]) REFERENCES [dbo].[populationRegist]([tz]);
GO

-- מצביע רגיל חייב להיות במרשם האוכלוסין
ALTER TABLE [dbo].[Voters] WITH CHECK
    ADD CONSTRAINT [FK_Voters_populationRegist]
    FOREIGN KEY([idNumber]) REFERENCES [dbo].[populationRegist]([tz]);
GO

-- הצבעה -> מפלגה / תחנת הצבעה
ALTER TABLE [dbo].[Votes] WITH CHECK
    ADD CONSTRAINT [FK_Votes_Parties]
    FOREIGN KEY([partyId]) REFERENCES [dbo].[Parties]([id]);
GO
ALTER TABLE [dbo].[Votes] WITH CHECK
    ADD CONSTRAINT [FK_Votes_PollingStations]
    FOREIGN KEY([pollStationId]) REFERENCES [dbo].[PollingStations]([id]);
GO

/*==================================================================
   Views ופונקציות
  האובייקטים נוצרים לפי סדר תלויות: כל פונקציה נוצרת אחרי אלו שהיא
  קוראת להן. סדר הצינור: blockingPercentage, mandates1, mandate,
  mandates2, mandates3.
==================================================================*/

-- =============================================
-- Description: איחוד כלל המצביעים (רגילים + מיוחדים), ללא כפילויות
-- Returns:     טבלה (idNumber)
-- =============================================
CREATE VIEW [dbo].[SumVotes]
AS
    SELECT idNumber FROM [dbo].[Voters]
    UNION
    SELECT idNumber FROM [dbo].[specialVoters];
GO

-- =============================================
-- Description: סף אחוז החסימה (3.5% מסך המצביעים)
-- Returns:     float - מספר הקולות המהווה את הסף
-- =============================================
CREATE FUNCTION [dbo].[blockingPercentage]() RETURNS float
AS
BEGIN
    DECLARE @sumVotes int;
    SELECT @sumVotes = COUNT(*) FROM [dbo].[SumVotes];
    RETURN @sumVotes * 0.035;
END
GO

-- =============================================
-- Description: קולות לכל מפלגה שעברה את אחוז החסימה
-- Parameters:  @blockingPercentage - סף אחוז החסימה
-- Returns:     טבלה (partId, sumVotes)
-- =============================================
CREATE FUNCTION [dbo].[mandates1](@blockingPercentage float)
RETURNS @sumVotesPerParty TABLE (partId int, sumVotes int)
AS
BEGIN
    INSERT INTO @sumVotesPerParty (partId, sumVotes)
    SELECT [partyId], COUNT(*)
    FROM [dbo].[Votes]
    GROUP BY [partyId]
    HAVING COUNT(*) > @blockingPercentage;
    RETURN;
END
GO

-- =============================================
-- Description: "המודד" - סך הקולות הכשרים חלקי מספר המושבים.
--              נשען על mandates1, ולכן נוצר אחריו.
-- Returns:     float - מספר הקולות למנדט
-- =============================================
CREATE FUNCTION [dbo].[mandate]() RETURNS float
AS
BEGIN
    DECLARE @seats int = 25;   -- זמני להגשה (בכנסת אמיתית: 120)
    DECLARE @sumVotes int;
    SELECT @sumVotes = SUM(sumVotes)
    FROM [dbo].[mandates1]([dbo].[blockingPercentage]());
    RETURN @sumVotes * 1.0 / @seats;
END
GO

-- =============================================
-- Description: מנדטים מלאים (FLOOR) ושארית הקולות לכל מפלגה.
--              נשען על mandate() ו-mandates1().
-- Returns:     טבלה (partId, sumVotes, countMandates, rest)
-- =============================================
CREATE FUNCTION [dbo].[mandates2]()
RETURNS @mandatesPerParty TABLE (partId int, sumVotes int, countMandates int, rest float)
AS
BEGIN
    DECLARE @mandate float = [dbo].[mandate]();
    INSERT INTO @mandatesPerParty (partId, sumVotes, countMandates, rest)
    SELECT partId,
           sumVotes,
           FLOOR(sumVotes / NULLIF(@mandate, 0)),
           sumVotes - FLOOR(sumVotes / NULLIF(@mandate, 0)) * @mandate
    FROM [dbo].[mandates1]([dbo].[blockingPercentage]());
    RETURN;
END
GO

-- =============================================
-- Description: ממוצע הקולות למנדט הבא לכל מפלגה (בסיס לבדר-עופר).
--              נשען על mandates2().
-- Returns:     טבלה (partId, sumVotes, countMandates, avgMandate)
-- =============================================
CREATE FUNCTION [dbo].[mandates3]()
RETURNS @mandatesPerParty TABLE (partId int, sumVotes int, countMandates int, avgMandate float)
AS
BEGIN
    INSERT INTO @mandatesPerParty (partId, sumVotes, countMandates, avgMandate)
    SELECT partId,
           sumVotes,
           countMandates,
           sumVotes * 1.0 / (countMandates + 1)
    FROM [dbo].[mandates2]();
    RETURN;
END
GO

-- =============================================
-- Description: סטטוס הצבעה של כל אזרח (כולל מצביעים מיוחדים)
-- Returns:     טבלה (tz, סטטוס הצבעה)
-- =============================================
CREATE VIEW [dbo].[checkIfVoted]
AS
    SELECT p.[tz],
           CASE WHEN sv.idNumber IS NULL THEN N'האזרח טרם הצביע'
                ELSE N'האזרח הצביע'
           END AS [סטטוס הצבעה]
    FROM [dbo].[populationRegist] AS p
    LEFT JOIN [dbo].[SumVotes] AS sv ON sv.idNumber = p.[tz];
GO

/*==================================================================
   פרוצדורות
==================================================================*/

-- =============================================
-- Description: הוספת מפלגה חדשה
-- Parameters:  @letters - אותיות הרשימה
--              @name    - שם המפלגה
-- =============================================
CREATE PROCEDURE [dbo].[addParty]
    (@letters varchar(3), @name varchar(50))   -- אורך תואם לעמודת name
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Parties] (letters, name) VALUES (@letters, @name);
END
GO

-- =============================================
-- Description: הוספת קלפי (תחנת הצבעה) חדשה
-- Parameters:  @city, @address, @directions, @accessibility
-- =============================================
CREATE PROCEDURE [dbo].[addPollingStation]
    (@city varchar(15), @address varchar(20), @directions varchar(100), @accessibility bit)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[PollingStations] (city, address, directions, accessibility)
    VALUES (@city, @address, @directions, @accessibility);
END
GO

-- =============================================
-- Description: פסילת הצבעה כפולה - הסרת האזרח משתי הטבלאות
-- Parameters:  @specialId - תעודת הזהות של האזרח
-- =============================================
CREATE PROCEDURE [dbo].[deleteDoubleVotes] (@specialId varchar(9))
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[Voters]        WHERE [idNumber] = @specialId;
    DELETE FROM [dbo].[specialVoters] WHERE [idNumber] = @specialId;
END
GO

-- =============================================
-- Description: הסרת הכפילות בלבד (משאירים את ההצבעה הרגילה)
-- Parameters:  @specialId - תעודת הזהות של האזרח
-- =============================================
CREATE PROCEDURE [dbo].[deleteDoubleVotes1] (@specialId varchar(9))
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[specialVoters] WHERE [idNumber] = @specialId;
END
GO

-- =============================================
-- Description: דיווח - סך הקולות וסף אחוז החסימה
-- Returns:     שורה אחת (totalVotes, blockingThreshold)
-- =============================================
CREATE PROCEDURE [dbo].[mandates]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*)                        AS totalVotes,
           [dbo].[blockingPercentage]()    AS blockingThreshold
    FROM [dbo].[Votes];
END
GO

-- =============================================
-- Description: חלוקת מנדטים עודפים (שיטת בדר-עופר) ועדכון
--              עמודת countMandates בטבלת Parties
-- =============================================
CREATE PROCEDURE [dbo].[mandatesPartition]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT partId, sumVotes, countMandates, avgMandate
    INTO #alloc
    FROM [dbo].[mandates3]();

    -- מספר המנדטים העודפים לחלוקה (מעוגל למספר שלם)
    DECLARE @restMandates int;
    SELECT @restMandates = ROUND(SUM(rest) / NULLIF([dbo].[mandate](), 0), 0)
    FROM [dbo].[mandates2]();

    WHILE (@restMandates > 0)
    BEGIN
        DECLARE @partIdToAdd int;

        -- המפלגה עם הממוצע הגבוה ביותר למנדט הבא (שובר שוויון: partId הנמוך)
        SELECT TOP (1) @partIdToAdd = partId
        FROM #alloc
        ORDER BY avgMandate DESC, partId ASC;

        UPDATE #alloc
        SET countMandates = countMandates + 1,
            avgMandate    = sumVotes * 1.0 / (countMandates + 2)  -- ממוצע למנדט הבא
        WHERE partId = @partIdToAdd;

        SET @restMandates = @restMandates - 1;
    END

    UPDATE p
    SET p.[countMandates] = a.countMandates
    FROM [dbo].[Parties] AS p
    INNER JOIN #alloc AS a ON p.[id] = a.partId;

    DROP TABLE #alloc;
END
GO

-- =============================================
-- Description: שליחת תזכורת הצבעה במייל
--              (דורש הגדרת Database Mail והפרופיל המתאים)
-- =============================================
CREATE PROCEDURE [dbo].[sendingEmails]
AS
BEGIN
    SET NOCOUNT ON;
    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = 'Election Committee',
        @recipients   = 'committee@elections.gov.il',
        @subject      = N'טרם הצבעת',
        @body         = N'הקלפיות נסגרות בעוד חצי שעה!!! צאו להצביע';
END
GO
