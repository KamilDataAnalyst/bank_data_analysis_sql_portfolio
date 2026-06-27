-- 1. Konwersja kwoty na FLOAT
ALTER TABLE TabelaTransakcje
ALTER COLUMN kwota FLOAT;

-- 2. Konwersja daty na DATETIME2
ALTER TABLE TabelaTransakcje
ALTER COLUMN data_transakcji DATETIME2;

-- 3. Standaryzacja klucza obcego (konto_id) na SMALLINT
ALTER TABLE TabelaTransakcje
ALTER COLUMN konto_id SMALLINT;
