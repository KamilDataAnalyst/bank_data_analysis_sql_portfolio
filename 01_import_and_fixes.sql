-- 1. Zmieniamy kwotę na prawdziwy FLOAT (liczba zmiennoprzecinkowa)
ALTER TABLE TabelaTransakcje
ALTER COLUMN kwota FLOAT;

-- 2. Zmieniamy datę na prawdziwe DATETIME2
ALTER TABLE TabelaTransakcje
ALTER COLUMN data_transakcji DATETIME2;

-- 3. Zmieniamy konto_id na INT (tak dla świętego spokoju)
ALTER TABLE TabelaTransakcje
ALTER COLUMN konto_id INT;