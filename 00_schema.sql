-- ========================================================
-- Skrypt tworzący strukturę bazy danych "Bank Projekt"
-- ========================================================

CREATE DATABASE [Bank Projekt];
GO
USE [Bank Projekt];
GO

-- 1. Tworzenie tabeli Klienci
CREATE TABLE [dbo].[TabelaKlienci](
	[klient_id] [smallint] NOT NULL,
	[imie] [nvarchar](50) NOT NULL,
	[nazwisko] [nvarchar](50) NOT NULL,
	[miasto_rodzinne] [nvarchar](50) NOT NULL,
	[data_urodzenia] [date] NOT NULL,
	[segment_klienta] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_TabelaKlienci] PRIMARY KEY CLUSTERED ([klient_id] ASC)
);
GO

-- 2. Tworzenie tabeli Konta
CREATE TABLE [dbo].[TabelaKonta](
	[konto_id] [smallint] NOT NULL,
	[klient_id] [smallint] NOT NULL,
	[typ_konta] [nvarchar](50) NOT NULL,
	[waluta] [nvarchar](50) NOT NULL,
	[data_otwarcia] [date] NOT NULL,
    CONSTRAINT [PK_TabelaKonta] PRIMARY KEY CLUSTERED ([konto_id] ASC)
);
GO

-- 3. Tworzenie tabeli Transakcje
CREATE TABLE [dbo].[TabelaTransakcje](
	[transakcja_id] [int] NOT NULL,
	[konto_id] [smallint] NULL, -- Zmiana na SMALLINT!
	[kwota] [float] NULL,
	[data_transakcji] [datetime2](7) NULL,
	[kategoria_wydatku] [nvarchar](50) NOT NULL,
	[metoda_platnosci] [nvarchar](50) NOT NULL,
	[miasto_transakcji] [nvarchar](50) NULL,
	[kraj_transakcji] [nvarchar](50) NULL,
	[status_transakcji] [nvarchar](50) NULL,
    CONSTRAINT [PK_TabelaTransakcje] PRIMARY KEY CLUSTERED ([transakcja_id] ASC)
);
GO

-- 4. Relacje kluczy głównych z obcymi

-- Łączenie Kont z Klientami
ALTER TABLE [dbo].[TabelaKonta] WITH CHECK ADD CONSTRAINT [FK_TabelaKonta_TabelaKlienci] 
FOREIGN KEY([klient_id]) REFERENCES [dbo].[TabelaKlienci] ([klient_id]);
GO

-- Łączenie Transakcji z Kontami
ALTER TABLE [dbo].[TabelaTransakcje] WITH CHECK ADD CONSTRAINT [FK_TabelaTransakcje_TabelaKonta] 
FOREIGN KEY([konto_id]) REFERENCES [dbo].[TabelaKonta] ([konto_id]);
GO