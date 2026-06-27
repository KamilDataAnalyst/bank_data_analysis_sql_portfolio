-- ===============================================
-- Warstwa czyszczenia danych (Data Cleaning)
-- Skrypt tworzy lub aktualizuje widok transakcji
-- ===============================================

CREATE OR ALTER VIEW v_CzysteTransakcje AS
SELECT
	transakcja_id,
	konto_id,
	kwota,
	data_transakcji,
	kategoria_wydatku,
	metoda_platnosci,
	CASE
		WHEN miasto_transakcji IS NULL THEN 'Online / Brak danych'
		ELSE UPPER(LEFT(miasto_transakcji, 1)) + LOWER(SUBSTRING(miasto_transakcji, 2, LEN(miasto_transakcji)))
	END AS miasto_transakcji,
	ISNULL(kraj_transakcji, 'Transakcja Online - nieznany') AS kraj_transakcji,
	CASE
		WHEN status_transakcji IS NOT NULL THEN status_transakcji
		ELSE 'Przerwana / Błąd systemowy'
	END AS status_transakcji
FROM TabelaTransakcje
WHERE kwota IS NOT NULL;
