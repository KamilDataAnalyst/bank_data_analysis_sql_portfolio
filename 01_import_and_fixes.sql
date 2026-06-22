-- 1. Konwersja kwoty transakcji na typ zmiennoprzecinkowy (FLOAT) w celu umożliwienia operacji agregujących i matematycznych
ALTER TABLE TabelaTransakcje
ALTER COLUMN kwota FLOAT;

-- 2. Konwersja kolumny chronologicznej na precyzyjny typ DATETIME2 do zaawansowanej analizy czasowej i sezonowości
ALTER TABLE TabelaTransakcje
ALTER COLUMN data_transakcji DATETIME2;

-- 3. Standaryzacja klucza obcego (konto_id) na typ całkowity (INT) w celu zapewnienia spójności relacji referencyjnych
ALTER TABLE TabelaTransakcje
ALTER COLUMN konto_id INT;