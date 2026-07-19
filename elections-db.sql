/*===================================================
  מסד נתונים: Elections  (ניהול בחירות)
=====================================================*/

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF DB_ID(N'Elections') IS NULL
    CREATE DATABASE [Elections];
GO
USE [Elections];
GO

/*------------------------------------------------------------------
   טבלאות  (מפתחות ראשיים ואילוצי ייחודיות מוגדרים inline)
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
                           נתונים
------------------------------------------------------------------*/
SET ANSI_PADDING ON;
GO
SET IDENTITY_INSERT [dbo].[Parties] ON 
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (1, N'ג', N'יהדות התורה', 4)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (2, N'שס', N'התאחדות הספרדית', 3)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (3, N'מחל', N'הליכוד', 8)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (4, N'פה', N'יש עתיד', 3)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (5, N'כן', N'המחנה הממלכתי', 2)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (6, N'ט', N'הציונות הדתית', 2)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (7, N'ל', N'ישראל ביתנו', 1)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (9, N'ום', N'חד"ש תע"ל', 1)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (10, N'צ', N'צעירים בוערים', 0)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (11, N'עם', N'הרשימה הערבית', 0)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (12, N'ף', N'הפיראטים', 0)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (13, N'מרצ', N'מרצ השמאל של ישראל', 1)
GO
INSERT [dbo].[Parties] ([id], [letters], [name], [countMandates]) VALUES (14, N'אמת', N'העבודה', NULL)
GO
SET IDENTITY_INSERT [dbo].[Parties] OFF
GO
SET IDENTITY_INSERT [dbo].[PollingStations] ON 
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (1, N'אבו גוש', N'מוחמד אספי 12', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (2, N'אום אל פחם', N'אבו מוסא 3', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (3, N'אופקים', N'השקדייה 7', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (5, N'אור יהודה', N'החרצנית 22', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (7, N'אילת', N'השייטת 17', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (12, N'אלעד', N'האדמור מויזניץ 74', N'כיתה 2', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (16, N'אלעד', N'האדמור מויזניץ 74', N'כיתה 1', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (17, N'אפרת', N'צה"ל 2', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (18, N'אשדוד', N'התנאים 16', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (19, N'אשדוד', N'לוחמי הגטאות 4', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (20, N'אשדוד', N'החולות 8', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (21, N'באר שבע', N'מדבר יהודה 90', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (22, N'באר שבע', N'הכלניות 6', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (23, N'בית חלקיה', N'המייסדים', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (24, N'בית שמש', N'נחל קישון 17', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (25, N'בית שמש', N'נהר הירדן 2', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (26, N'בית שמש', N'הרצל', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (27, N'ביתר עילית ', N' ראשון לציון 5', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (28, N'בני ברק', N'חזון איש 12', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (29, N'בני ברק', N'זבוטינסקי 11', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (30, N'בני ברק', N'יצחק שדה 22', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (31, N'בת ים', N'המפרשים 19', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (32, N'גבעתיים', N'הגבעה 17', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (33, N'גדרה', N'המשעול 8', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (34, N'גני תקווה', N'גולדה מאיר 5', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (35, N'דאלית אלכרמל', N'אבו חאלד 8', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (36, N'דימונה', N'האטום 15', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (37, N'הוד השרון', N'מנדלסון 9', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (38, N'הר אדר', N'המשוריינים', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (39, N'הרצליה', N'דגניה 7', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (40, N'זכרון יעקב', N'הנדיב 52', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (41, N'חברון', N'מערת המכפלה ', N'ברחבה', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (42, N'חדרה', N'המדע 3', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (43, N'חולון', N'האוניברסיטה 2', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (44, N'חיפה', N'מיכאל 22', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (45, N'חיפה', N' אורלוזרוב 11', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (47, N'חיפה', N'הכרמלית 35', N'קומה 2 במעלית', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (50, N'חיפה', N'הכרמלית 35', N'קומה 3 במעלית', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (51, N'טבריה', N'הרב קוק 12', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (52, N'טירת כרמל', N'הדבש 3', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (53, N'יבנה', N'הרימון 5', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (54, N'ירושלים', N'סורוצקין 27', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (55, N'ירושלים', N'קפלן 2', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (56, N'ירושלים', N'זלמן ארן 3', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (57, N'ירושלים', N'יפו 33', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (58, N'ירושלים', N'הפסגה 13', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (59, N'ירושלים', N'אליעזר הגדול 7', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (60, N'ירושלים', N' השישה עשר 16', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (61, N'כפר חבד', N'הרבי מלובביץ 770', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (62, N'כפר סבא', N'הסביון 5', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (63, N'מודיעין עילית', N'רבי עקיבא 23', N'בחדר ההתעמלות', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (65, N'מודיעין עילית', N'רבי עקיבא 23', N'בחדר היצירה', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (66, N'נצרת', N'המחבלים 19', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (67, N'נתניה', N'קובי לוי 13', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (68, N'עכו', N'הקייאק 2', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (69, N'צפת', N'ירושלים 50', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (70, N'ראש העין', N'המורי 5', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (71, N'ראשון לציון', N'עטרת שלמה 1', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (72, N'ראשון לציון', N'שפתי חיים', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (73, N'תל אביב יפו', N'הרצל 15', N'', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (74, N'תל אביב יפו', N'ששת הימים 4', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (75, N'תל אביב יפו', N'משה דיין 12', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (76, N'תל אביב יפו', N'השחרור 7', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (78, N'ירושלים', N'בן גוריון 5', N'', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (79, N'ירושלים', N'בית החולים שערי צדק', N'קומה 3', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (80, N'ירושלים', N'בית החולים הדסה עין ', N'קומה 3', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (81, N'ירושלים', N'בית החולים הדסה הר ה', N'קומה 3', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (82, N'בני ברק', N'בית החולים מעיני היש', N'קומה 0', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (83, N'צפת', N'בית החולים זיו', N'קומה 0', 1)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (84, N'שדרות', N'בסיס צבאי שדרות', N'null', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (85, N'רמת השרון', N'בסיס צבאי גלילות', N'null', 0)
GO
INSERT [dbo].[PollingStations] ([id], [city], [address], [directions], [accessibility]) VALUES (86, N'אפרת', N'בסיס צבאי יו"ש', N'null', 0)
GO
SET IDENTITY_INSERT [dbo].[PollingStations] OFF
GO
SET IDENTITY_INSERT [dbo].[populationRegist] ON 
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (1, N'327124129', 1, N'999999@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (2, N'227124128', 1, N'519520@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (5, N'132712412', 1, N'miri4823@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (6, N'271241212', 2, N'aliber5@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (7, N'389456123', 2, N'm05276@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (8, N'012546983', 2, N'm052768956@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (9, N'241258944', 2, N'r0583234587@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (10, N'012547895', 3, N'5810367@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (11, N'024256945', 3, N'k2248@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (12, N'325648596', 3, N'4571mr@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (13, N'385463210', 5, N'tmr84340@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (14, N'369852145', 5, N'm05276545pl@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (15, N'458796523', 5, N'6625463@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (16, N'452368459', 7, N'm765y@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (17, N'005426318', 7, N'oop112@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (18, N'335478996', 7, N'7183miri@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (20, N'125469325', 12, N'5328817@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (21, N'335100640', 12, N'tamar553@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (22, N'326889185', 12, N'y0527114526@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (23, N'033149488', 12, N'lj05271117285@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (24, N'335200640', 16, N'rachel8817@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (25, N'335968541', 16, N'r0548472747@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (26, N'325889546', 16, N'm0527654555@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (27, N'053284597', 16, N'leah4455@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (28, N'335264785', 17, N'054845pop@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (29, N'033149475', 17, N'4452kj@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (30, N'326847512', 17, N'56789@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (31, N'275468957', 18, N'sari0548432528@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (32, N'256938745', 18, N'aribob4@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (33, N'335164523', 18, N'8841d@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (34, N'321456965', 19, N'w7542@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (35, N'035676452', 19, N'm0527648520@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (36, N'033149563', 19, N'l052765455@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (37, N'326779185', 20, N'm0527654517@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (38, N'326885962', 20, N'ppl221@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (39, N'058265414', 20, N'eag195@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (40, N'568945632', 20, N'tali4@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (41, N'332154698', 21, N'6633688@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (42, N'015469823', 21, N'445837@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (43, N'327124126', 21, N'1')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (44, N'327532896', 21, N'2')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (45, N'356984756', 22, N'm05g458@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (46, N'335164582', 22, N'3')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (47, N'321558964', 22, N'm0527654512@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (48, N'056984756', 23, N'4')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (49, N'335269875', 23, N'5')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (50, N'327124124', 23, N'6')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (51, N'336152463', 24, N'7')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (52, N'325100640', 24, N'8')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (53, N'125698324', 24, N'9')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (54, N'128795630', 25, N'10')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (55, N'325648958', 25, N'987')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (56, N'033149856', 25, N'm0527654556@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (57, N'327582648', 26, N'12')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (58, N'325896521', 26, N'13')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (59, N'325698563', 26, N'874')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (60, N'334596332', 27, N'115')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (61, N'032459687', 27, N'520')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (63, N'335698475', 27, N'222')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (64, N'011256488', 28, N'630')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (65, N'324584751', 28, N'410')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (66, N'055678985', 28, N'8520')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (67, N'356212321', 29, N'74520')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (68, N'112658963', 29, N'77')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (70, N'336559842', 30, N'88')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (71, N'004598652', 30, N'99')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (72, N'335126358', 30, N'111')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (73, N'225036898', 31, N'2222')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (74, N'265897541', 31, N'333')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (75, N'321654987', 31, N'444')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (76, N'123456789', 31, N'555')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (77, N'122345678', 32, N'666')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (78, N'198765423', 32, N'777')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (79, N'289745632', 32, N'888')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (80, N'278965412', 33, N'999')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (81, N'265489745', 33, N'14')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (82, N'012546398', 34, N'15')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (83, N'002236589', 34, N'889855@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (84, N'263598745', 34, N'16')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (85, N'112036547', 35, N'17')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (86, N'265301452', 35, N'18')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (87, N'365214789', 36, N'19')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (88, N'325641256', 36, N'20')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (89, N'014785201', 36, N'21')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (90, N'012365478', 37, N'22')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (91, N'120210354', 37, N'23')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (92, N'332654123', 38, N'24')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (93, N'225631202', 38, N'25')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (94, N'320145879', 39, N'26')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (95, N'025852025', 39, N'27')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (96, N'369636963', 40, N'28')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (97, N'325698741', 40, N'29')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (98, N'320145620', 40, N'30')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (99, N'303025896', 41, N'31')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (100, N'222564123', 41, N'32')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (101, N'333223562', 41, N'33')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (102, N'302121203', 42, N'34')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (103, N'335421036', 42, N'35')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (104, N'221123123', 42, N'36')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (105, N'332356325', 43, N'37')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (106, N'033149526', 43, N'38')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (107, N'031452698', 44, N'ssd1121@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (108, N'327125126', 44, N'5535458@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (109, N'326452145', 45, N'o0582589632@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (110, N'052896325', 45, N'39')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (113, N'326124127', 47, N'40')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (114, N'033256320', 47, N'41')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (115, N'225896320', 50, N'42')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (116, N'356284563', 50, N'43')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (117, N'022458963', 51, N'44')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (118, N'022149485', 51, N'45')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (119, N'011958625', 52, N'46')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (121, N'055665336', 52, N'47')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (122, N'332563201', 53, N'48')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (123, N'325698452', 53, N'49')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (124, N'329382626', 54, N'50')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (125, N'329385623', 54, N'51')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (126, N'325896523', 55, N'52')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (127, N'033258525', 55, N'53')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (128, N'335100625', 56, N'54')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (129, N'033149482', 57, N'55')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (130, N'321325647', 57, N'56')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (131, N'033152698', 58, N'57')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (132, N'254125896', 58, N'58')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (133, N'325632520', 59, N'59')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (134, N'335126523', 59, N'60')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (135, N'033145263', 60, N'61')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (136, N'033148596', 60, N'62')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (137, N'043251236', 61, N'63')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (138, N'335102473', 62, N'64')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (139, N'225963285', 62, N'65')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (140, N'055632896', 63, N'66')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (142, N'327125127', 63, N'67')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (144, N'329856231', 65, N'68')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (145, N'336254123', 66, N'69')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (146, N'326884522', 67, N'80')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (147, N'326889520', 67, N'81')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (148, N'032145698', 68, N'82')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (149, N'325896412', 68, N'83')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (150, N'256325896', 69, N'84')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (151, N'147852369', 69, N'85')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (152, N'125896325', 70, N'86')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (153, N'025896314', 70, N'87')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (154, N'221456321', 79, N'm0527652887@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (155, N'058232564', 80, N'm0527654577@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (156, N'005236987', 81, N'm0527654666@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (157, N'225238019', 82, N'm0527654515@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (158, N'215038017', 83, N'm0527654544@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (159, N'215469852', 79, N'm0527654333@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (160, N'213564852', 74, N'm0@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (161, N'335201632', 86, N'm0527654630@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (162, N'225641285', 86, N'k0548541203@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (163, N'033146571', 76, N'l05452@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (164, N'336985201', 85, N'5522852@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (165, N'215552498', 55, N'm0527651111@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (166, N'054854632', 84, N'g554556@gmail.com')
GO
INSERT [dbo].[populationRegist] ([id], [tz], [pollStationId], [email]) VALUES (167, N'521458723', 1, N'm05277@gmail.com')
GO
SET IDENTITY_INSERT [dbo].[populationRegist] OFF
GO
SET IDENTITY_INSERT [dbo].[specialVoters] ON 
GO
INSERT [dbo].[specialVoters] ([id], [idNumber], [pollStationId]) VALUES (26, N'385463210', 79)
GO
INSERT [dbo].[specialVoters] ([id], [idNumber], [pollStationId]) VALUES (28, N'521458723', 80)
GO
INSERT [dbo].[specialVoters] ([id], [idNumber], [pollStationId]) VALUES (29, N'263598745', 82)
GO
INSERT [dbo].[specialVoters] ([id], [idNumber], [pollStationId]) VALUES (30, N'326884522', 80)
GO
INSERT [dbo].[specialVoters] ([id], [idNumber], [pollStationId]) VALUES (32, N'053284597', 84)
GO
SET IDENTITY_INSERT [dbo].[specialVoters] OFF
GO
SET IDENTITY_INSERT [dbo].[Voters] ON 
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (3, N'327124129', 1, 1, CAST(N'00:01:31' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (6, N'271241212', 2, 1, CAST(N'18:50:03' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (7, N'012546983', 2, 1, CAST(N'18:56:03' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (9, N'024256945', 3, 1, CAST(N'18:59:03' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (13, N'125469325', 12, 1, CAST(N'19:51:55' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (14, N'326889185', 12, 1, CAST(N'19:53:55' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (15, N'335968541', 16, 1, CAST(N'19:55:27' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (18, N'275468957', 18, 1, CAST(N'23:57:50' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (26, N'335264785', 17, 1, CAST(N'00:01:31' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (28, N'356984756', 22, 1, CAST(N'00:04:24' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (29, N'321558964', 22, 1, CAST(N'15:57:41' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (30, N'326885962', 20, 1, CAST(N'16:00:27' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (31, N'035676452', 19, 1, CAST(N'16:01:45' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (32, N'031452698', 44, 1, CAST(N'16:02:31' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (41, N'327125126', 44, 1, CAST(N'01:20:15' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (44, N'326452145', 45, 1, CAST(N'01:22:48' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (46, N'053284597', 16, 1, CAST(N'01:25:49' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (47, N'326847512', 17, 1, CAST(N'01:26:42' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (48, N'015469823', 21, 1, CAST(N'01:27:30' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (59, N'213564852', 74, 1, CAST(N'15:03:56' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (60, N'225238017', 73, 1, CAST(N'15:08:42' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (62, N'278965412', 33, 1, CAST(N'22:40:14' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (63, N'033149856', 25, 1, CAST(N'23:55:52' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (64, N'033146571', 76, 1, CAST(N'17:40:26' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (65, N'215552498', 55, 1, CAST(N'18:32:20' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (85, N'198765423', 32, 1, CAST(N'22:03:30' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (86, N'112658963', 29, 1, CAST(N'13:29:02' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (87, N'054854632', 84, 1, CAST(N'13:30:29' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (88, N'335201632', 86, 1, CAST(N'13:30:30' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (89, N'336254123', 66, 1, CAST(N'13:30:38' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (90, N'215038017', 83, 1, CAST(N'13:30:50' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (93, N'225963285', 62, 1, CAST(N'13:31:35' AS Time))
GO
INSERT [dbo].[Voters] ([id], [idNumber], [pollStationId], [voted], [votingTime]) VALUES (95, N'335102473', 62, 1, CAST(N'13:31:58' AS Time))
GO
SET IDENTITY_INSERT [dbo].[Voters] OFF
GO
SET IDENTITY_INSERT [dbo].[Votes] ON 
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (1, 1, 9)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (2, 1, 9)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (3, 1, 11)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (4, 2, 11)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (5, 2, 9)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (6, 3, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (7, 3, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (8, 3, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (9, 3, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (10, 5, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (11, 5, 6)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (12, 7, 13)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (13, 12, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (14, 12, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (15, 17, 6)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (16, 16, 10)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (17, 18, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (18, 19, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (19, 20, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (20, 21, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (21, 22, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (22, 23, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (23, 24, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (24, 26, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (25, 25, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (26, 27, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (27, 28, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (28, 30, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (29, 31, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (30, 29, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (31, 32, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (32, 33, 12)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (33, 34, 13)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (34, 35, 9)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (35, 36, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (36, 37, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (37, 38, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (38, 39, 13)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (39, 39, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (40, 39, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (41, 40, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (42, 41, 6)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (43, 42, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (44, 43, 7)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (45, 44, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (46, 44, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (47, 44, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (48, 45, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (49, 45, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (50, 47, 12)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (51, 50, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (52, 50, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (53, 51, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (54, 51, 6)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (55, 52, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (56, 52, 7)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (57, 53, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (58, 54, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (59, 54, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (60, 54, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (61, 55, 13)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (62, 55, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (63, 55, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (64, 56, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (65, 56, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (66, 56, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (67, 56, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (68, 57, 10)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (69, 57, 6)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (70, 58, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (71, 58, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (72, 58, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (73, 59, 6)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (74, 59, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (75, 59, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (76, 60, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (77, 60, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (78, 60, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (79, 61, 6)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (80, 62, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (81, 63, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (82, 63, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (83, 65, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (84, 65, 2)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (85, 66, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (86, 66, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (87, 67, 6)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (88, 68, 11)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (89, 69, 1)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (90, 69, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (91, 69, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (92, 70, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (93, 71, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (94, 72, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (95, 73, 13)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (96, 73, 13)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (97, 73, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (98, 74, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (99, 75, 4)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (100, 75, 7)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (101, 76, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (102, 76, 5)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (103, 76, 7)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (104, 76, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (105, 74, 3)
GO
INSERT [dbo].[Votes] ([id], [pollStationId], [partyId]) VALUES (106, 75, 3)
GO
SET IDENTITY_INSERT [dbo].[Votes] OFF
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

ALTER TABLE [dbo].[Voters] WITH NOCHECK
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
