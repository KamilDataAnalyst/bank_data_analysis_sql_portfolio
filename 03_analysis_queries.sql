-- Zadanie 1: Liczba, suma i średnia wartość transakcji oraz zysk banku z prowizji (0.2%) za płatności kartą per miasto.
SELECT
	miasto_transakcji,
	COUNT(*) AS liczba_transakcji,
	ROUND(SUM(kwota), 0) AS laczny_obrot,
	ROUND(AVG(kwota), 2) AS srednia_wartosc,
	ROUND(SUM(CASE WHEN metoda_platnosci = 'Karta' THEN kwota * 0.002 ELSE 0 END), 2) AS zysk_banku_prowizja_z_karty
FROM v_CzysteTransakcje
WHERE miasto_transakcji <> 'Online / Brak danych'
	AND status_transakcji = 'Zakonczona'
GROUP BY miasto_transakcji
ORDER BY zysk_banku_prowizja_z_karty DESC;

-- Zadanie 2: Liczba i suma transakcji w podziale na godziny w ciągu doby w celu określenia godzin szczytowego obciążenia systemu.
SELECT
	DATEPART(hour, data_transakcji) AS godzina,
	COUNT(*) AS liczba_transakcji,
	ROUND(SUM(kwota), 0) AS laczna_kwota
FROM v_CzysteTransakcje
GROUP BY DATEPART(hour, data_transakcji)
ORDER BY laczna_kwota DESC;

-- Zadanie 3: Top 10 najbardziej dochodowych klientów pod względem sumy uregulowanych transakcji.
SELECT TOP 10
	k.klient_id,
	CONCAT(k.imie, ' ', k.nazwisko) AS pelne_nazwisko,
	k.miasto_rodzinne,
	ROUND(SUM(t.kwota), 0) AS laczna_kwota_transakcji
FROM TabelaKlienci k
JOIN TabelaKonta ko ON k.klient_id = ko.klient_id
JOIN v_CzysteTransakcje t ON ko.konto_id = t.konto_id
WHERE t.status_transakcji = 'Zakonczona'
GROUP BY k.klient_id, k.imie, k.nazwisko, k.miasto_rodzinne
ORDER BY SUM(t.kwota) DESC;

-- Zadanie 4: Porównanie segmentów klientów Standard, Premium i VIP pod względem liczby klientów, liczby transakcji, łącznej kwoty, średniej wartości oraz średniej liczby transakcji na jednego klienta.
SELECT
	k.segment_klienta,
	COUNT(DISTINCT k.klient_id) AS liczba_klientow,
	COUNT(*) AS liczba_transakcji,
	ROUND(SUM(t.kwota), 0) AS laczna_kwota,
	ROUND(AVG(t.kwota), 2) AS srednia_wartosc,
	ROUND(CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT k.klient_id), 1) AS srednia_liczba_transakcji_na_klienta
FROM TabelaKlienci k
JOIN TabelaKonta ko ON k.klient_id = ko.klient_id
JOIN v_CzysteTransakcje t ON ko.konto_id = t.konto_id
WHERE t.status_transakcji = 'Zakonczona'
GROUP BY k.segment_klienta
ORDER BY laczna_kwota DESC;

-- Zadanie 5: Udział procentowy poszczególnych metod płatności we wszystkich transakcjach zarejestrowanych w bazie.
SELECT
	metoda_platnosci,
	COUNT(*) AS liczba_transakcji,
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS udzial_procentowy
FROM v_CzysteTransakcje
WHERE status_transakcji = 'Zakonczona'
GROUP BY metoda_platnosci
ORDER BY udzial_procentowy DESC;

-- Zadanie 6: Łączna suma wydatków klientów w ujęciu chronologicznym miesiąc do miesiąca (MoM).
WITH DaneMiesieczne AS (
	SELECT
		DATEFROMPARTS(YEAR(data_transakcji), MONTH(data_transakcji), 1) AS miesiac,
		ROUND(SUM(kwota), 0) AS suma_kwoty
	FROM v_CzysteTransakcje
	GROUP BY DATEFROMPARTS(YEAR(data_transakcji), MONTH(data_transakcji), 1)
)
SELECT
	miesiac,
	suma_kwoty,
	LAG(suma_kwoty, 1) OVER (ORDER BY miesiac) AS suma_poprzedni_miesiac,
	ROUND((suma_kwoty - LAG(suma_kwoty, 1) OVER (ORDER BY miesiac)) * 100 / LAG(suma_kwoty, 1) OVER (ORDER BY miesiac), 2) AS zmiana_procentowa_mom
FROM DaneMiesieczne
ORDER BY miesiac;

-- Zadanie 7: Oficjalny ranking TOP 3 największych transakcji dla każdego miasta z osobna za pomocą funkcji DENSE_RANK().
WITH RankingTransakcji AS (
	SELECT
		t.transakcja_id,
		t.miasto_transakcji,
		k.klient_id,
		t.kwota,
		DENSE_RANK() OVER (PARTITION BY t.miasto_transakcji ORDER BY t.kwota DESC) AS pozycja_w_miescie
	FROM v_CzysteTransakcje t
	JOIN TabelaKonta ko ON t.konto_id = ko.konto_id
	JOIN TabelaKlienci k ON ko.klient_id = k.klient_id
	WHERE t.status_transakcji = 'Zakonczona'
)
SELECT
	miasto_transakcji,
	pozycja_w_miescie,
	transakcja_id,
	klient_id,
	kwota
FROM RankingTransakcji
WHERE pozycja_w_miescie <= 3
	AND miasto_transakcji <> 'Online / Brak danych'
ORDER BY MAX(kwota) OVER (PARTITION BY miasto_transakcji) DESC, miasto_transakcji, pozycja_w_miescie;

-- Zadanie 8: Analiza mobilności klientów poprzez porównanie wydatków w mieście rodzinnym z wydatkami w innych lokalizacjach.
SELECT
	k.klient_id,
	CONCAT(k.imie, ' ', k.nazwisko) AS pelne_nazwisko,
	ROUND(SUM(CASE WHEN k.miasto_rodzinne = t.miasto_transakcji THEN t.kwota ELSE 0 END), 0) AS wydatki_lokalne,
	ROUND(SUM(CASE WHEN k.miasto_rodzinne <> t.miasto_transakcji THEN t.kwota ELSE 0 END), 0) AS wydatki_mobilne,
	ROUND(SUM(CASE WHEN k.miasto_rodzinne <> t.miasto_transakcji THEN t.kwota ELSE 0 END) * 100 / NULLIF(SUM(t.kwota), 0), 2) AS procent_wydatkow_mobilnych
FROM v_CzysteTransakcje t
JOIN TabelaKonta ko ON t.konto_id = ko.konto_id
JOIN TabelaKlienci k ON ko.klient_id = k.klient_id
WHERE t.status_transakcji = 'Zakonczona'
	AND t.miasto_transakcji <> 'Online / Brak danych'
GROUP BY k.klient_id, k.imie, k.nazwisko
ORDER BY procent_wydatkow_mobilnych DESC;

-- Zadanie 9: System Antyfraudowy: Wykrycie transakcji na tym samym koncie w odstępie poniżej godziny, ale w różnych krajach.
WITH TransakcjeZHistoria AS (
	SELECT 
		k.klient_id,
		t.data_transakcji AS podejrzana_transakcja,
		t.kraj_transakcji AS kraj_podejrzanej_transakcji,
		t.kwota AS kwota_podejrzanej_transakcji,
		LAG(t.data_transakcji) OVER (PARTITION BY k.klient_id ORDER BY t.data_transakcji, t.transakcja_id) AS poprzednia_transakcja,
		LAG(t.kraj_transakcji) OVER (PARTITION BY k.klient_id ORDER BY t.data_transakcji, t.transakcja_id) AS kraj_poprzedniej_transakcji,
		LAG(t.kwota) OVER (PARTITION BY k.klient_id ORDER BY t.data_transakcji, t.transakcja_id) AS kwota_poprzedniej_transakcji
	FROM v_CzysteTransakcje t
	JOIN TabelaKonta ko ON t.konto_id = ko.konto_id
	JOIN TabelaKlienci k ON ko.klient_id = k.klient_id
	WHERE t.kraj_transakcji <> 'Transakcja Online - nieznany'
)
SELECT
	klient_id,
	CONVERT(VARCHAR(19), podejrzana_transakcja, 120) AS podejrzana_transakcja,
	kraj_podejrzanej_transakcji,
	kwota_podejrzanej_transakcji,
	CONVERT(VARCHAR(19), poprzednia_transakcja, 120) AS poprzednia_transakcja,
	kraj_poprzedniej_transakcji,
	kwota_poprzedniej_transakcji
FROM TransakcjeZHistoria
WHERE kraj_podejrzanej_transakcji <> kraj_poprzedniej_transakcji
	AND DATEDIFF(minute, poprzednia_transakcja, podejrzana_transakcja) BETWEEN 1 AND 59
ORDER BY kwota_podejrzanej_transakcji DESC;

-- Zadanie 10: Detekcja Anomalii: Wykrycie podejrzanie wysokich transakcji (powyżej 5 razy średnia) w ramach tej samej kategorii wydatków.
WITH TransakcjeZeSrednia AS (
	SELECT
		k.klient_id,
		t.transakcja_id,
		t.kategoria_wydatku,
		t.kwota,
		AVG(t.kwota) OVER (PARTITION BY t.kategoria_wydatku) AS srednia_kwota_kategorii
	FROM v_CzysteTransakcje t
	JOIN TabelaKonta ko ON t.konto_id = ko.konto_id
	JOIN TabelaKlienci k ON ko.klient_id = k.klient_id
)
SELECT
	klient_id,
	transakcja_id,
	kategoria_wydatku,
	kwota,
	ROUND(srednia_kwota_kategorii, 2) AS srednia_kwota_kategorii,
	ROUND(kwota / srednia_kwota_kategorii, 1) AS krotnosc_sredniej
FROM TransakcjeZeSrednia
WHERE kwota > (srednia_kwota_kategorii * 5)
ORDER BY krotnosc_sredniej DESC;

-- Zadanie 11: Analiza Retencji: Identyfikacja klientów zagrożonych odejściem (brak aktywności transakcyjnej od 30 dni).
WITH DataOdniesienia AS (
	SELECT MAX(data_transakcji) AS punkt_odniesienia
	FROM v_CzysteTransakcje
)
SELECT
	k.klient_id,
	CONCAT(k.imie, ' ', k.nazwisko) AS pelne_nazwisko,
	CONVERT(DATE, MAX(t.data_transakcji)) AS data_ostatniej_transakcji,
	DATEDIFF(day,  MAX(t.data_transakcji), d.punkt_odniesienia) AS dni_bez_aktywnosci
FROM v_CzysteTransakcje t
JOIN TabelaKonta ko ON t.konto_id = ko.konto_id
JOIN TabelaKlienci k ON ko.klient_id = k.klient_id
CROSS JOIN DataOdniesienia d
GROUP BY k.klient_id, k.imie, k.nazwisko, d.punkt_odniesienia
HAVING DATEDIFF(day,  MAX(t.data_transakcji), d.punkt_odniesienia) > 30
ORDER BY dni_bez_aktywnosci DESC;
