# 🏦 Bank Data Analysis Project – SQL Portfolio

## 📝 Project Overview
Niniejsze repozytorium zawiera autorski projekt analityczny, którego celem jest kompleksowa analiza struktury danych oraz zachowań klientów fikcyjnego banku komercyjnego. Projekt opiera się na bazie danych przechowującej informacje o użytkownikach, ich kontach oraz realizowanych transakcjach finansowych. 

Wszystkie zapytania oraz analizy zostały przygotowane w środowisku **MS SQL**.

---

## 🎯 Business Context & Goal
W codziennej pracy analityka danych w sektorze bankowym rzadko otrzymuje się precyzyjne instrukcje krok po kroku. Najczęściej punktem wyjścia jest ogólny problem biznesowy lub potrzeba monitorowania procesów. 

Głównym celem tego projektu było wejście w rolę **analityka-detektywa**, który za pomocą zaawansowanych struktur SQL przekształca surowe logi transakcyjne w gotową wartość biznesową. Analiza skupia się na trzech kluczowych obszarach:
1. **Segmentacja i profilowanie klientów** – zrozumienie struktury demograficznej bazy użytkowników banku.
2. **Optymalizacja metryk finansowych** – identyfikacja trendów w wydatkach i aktywności na kontach.
3. **Cyberbezpieczeństwo i detekcja anomalii** – wykrywanie niestandardowych operacji mogących świadczyć o oszustwach (Fraud Detection).

---

## 🛠️ Tech Stack & SQL Techniques
Projekt demonstruje znajomość zaawansowanej składni SQL oraz dobrych praktyk zapisu kodu (dbających o czytelność dla zespołu).

* **Database Engine:** Microsoft SQL Server
* **Zaawansowane techniki SQL wykorzystane w projekcie:**
  * **Zaawansowane czyszczenie i standaryzacja danych:** Budowanie własnej logiki transformacji tekstu w T-SQL (użycie funkcji `UPPER`, `LEFT`, `LOWER`, `SUBSTRING` oraz `LEN` do formatowania nazw miejscowości w styl *Capital Case*).
  * **Tworzenie i optymalizacja Widoków (`VIEWS`):** Wykorzystanie widoków jako bezpiecznej warstwy abstrakcji oddzielającej surowe dane od zapytań raportowych.
  * **Obsługa wartości brakujących:** Zarządzanie wartościami `NULL` przy użyciu funkcji warunkowych, zapewniające spójność wyliczeń.
  * **Wspólne Wyrażenia Tablicowe (`CTE - Common Table Expressions`):** Stosowane do modułowego i czytelnego rozbijania złożonych problemów logicznych.
  * **Funkcje Okna (`Window Functions`):** Używane do kalkulacji pozycji w rankingach oraz zaawansowanej analizy kontekstowej i porównawczej wewnątrz kategorii wydatków.
  * **Relacyjność i wielopoziomowe złączenia (Multi-level JOINs):** Efektywne łączenie tabel w strukturach relacyjnych z wykorzystaniem `INNER JOIN`. Wykorzystanie tabeli wymiaru `Konta` jako kluczowego pośrednika (tabeli mapującej) do odtworzenia pełnego kontekstu biznesowego i połączenia logów transakcyjnych bezpośrednio z profilami demograficznymi klientów.
  * **Agregacje i Filtrowanie zaawansowane:** Wykorzystanie `GROUP BY` oraz `HAVING` z wielopoziomowymi warunkami logicznymi.

---

## 📊 Data Model & Database Structure
Analiza została przeprowadzona na relacyjnej bazie danych składającej się z trzech kluczowych tabel, które symulują realny system bankowości rdzeniowej (Core Banking):

* `Klienci` [Tabela Wymiaru] – zawiera unikalne, stałe profile klientów banku (1 000 wierszy).  
  * *Kolumny:* (`klient_id`, `imie`, `nazwisko`, `miasto_rodzinne`, `data_urodzenia`, `segment_klienta`)
* `Konta` [Tabela Wymiaru] – przechowuje informacje o rachunkach i mapuje relacje klient-konto (1 500 wierszy).  
  * *Kolumny:* (`konto_id`, `klient_id`, `typ_konta`, `waluta`, `data_otwarcia`)
* `Transakcje` [Tabela Faktów] – rejestruje każdy pojedynczy, historyczny ruch finansowy w systemie (50 000 wierszy).  
  * *Kolumny:* (`transakcja_id`, `konto_id`, `kwota`, `data_transakcji`, `kategoria_wydatku`, `metoda_platnosci`, `miasto_transakcji`, `kraj_transakcji`, `status_transakcji`)

---

## ⚙️ Repository Structure & Data Pipeline (ETL)
Projekt został podzielony na logiczne etapy, odzwierciedlające realny proces pracy z danymi (od surowych plików po gotowe wnioski). W repozytorium znajdują się źródłowe pliki `.csv` oraz skrypty SQL, które należy uruchamiać w poniższej kolejności:

1. [`01_import_and_fixes.sql`](./01_import_and_fixes.sql) – **Dostosowanie typów danych po imporcie:** Rozwiązanie problemów z domyślnym mapowaniem typów przez kreator importu MS SQL Server. Jawna konwersja kolumn za pomocą instrukcji `ALTER COLUMN` (m.in. zmiana kwot na `FLOAT`, dat na precyzyjny format `DATETIME2` oraz identyfikatorów na `INT`), umożliwiająca poprawne wykonywanie operacji matematycznych i agregacji czasowych w dalszych etapach.
2. [`02_create_views.sql`](./02_create_views.sql) – **Warstwa standaryzacji i czyszczenia (Data Cleaning Views):** Utworzenie widoków bazodanowych zapewniających spójność danych przed analizą. W tej warstwie zrealizowano m.in. standaryzację danych tekstowych (ujednolicenie wielkości liter w nazwach miast transakcji w celu uniknięcia sztucznego duplikowania grup w agregacjach), obsługę potencjalnych wartości pustych (`NULL`) oraz odcięcie rekordów niespełniających kryteriów biznesowych.
3. [`03_analysis_queries.sql`](./03_analysis_queries.sql) – **Warstwa analityczna:** Skrypt zawierający 11 zaawansowanych biznesowych zapytań SQL, podzielonych na dedykowane bloki tematyczne.
4. [`/data`](./data) – folder zawierający źródłowe pliki `.csv` (Klienci, Konta, Transakcje), na których bazuje cały projekt.

---

## 📂 Project Structure & Core Analyses
Prace nad projektem zostały podzielone na trzy dedykowane bloki analityczne. Każde zadanie reprezentuje osobne wyzwanie biznesowe, symulując realne zgłoszenia od działów biznesowych, marketingu czy bezpieczeństwa.

### 🗺️ Spis zadań i bloków tematycznych:

<details>
<summary><b>👤 Blok I: Profilowanie i Segmentacja Bazy Klientów (Zadania 1-4)</b></summary>

* [**Zadanie 1**: Rentowność prowizyjna i wolumen transakcji per miasto](#-zadanie-1-rentowność-prowizyjna-i-wolumen-transakcji-per-miasto)
* [**Zadanie 2**: Liczba i suma transakcji w podziale na godziny w ciągu doby](#-zadanie-2-liczba-i-suma-transakcji-w-podziale-na-godziny-w-ciągu-doby)
* [**Zadanie 3**: Top 10 najbardziej dochodowych klientów](#-zadanie-3-top-10-najbardziej-dochodowych-klientów)
* [**Zadanie 4**: Porównanie segmentów klientów Standard, Premium i VIP](#-zadanie-4-porównanie-segmentów-klientów-standard-premium-i-vip)
</details>

<details>
<summary><b>💰 Blok II: Analiza Finansowa i Zachowania Transakcyjne (Zadania 5-8)</b></summary>

* [**Zadanie 5**: Udział procentowy metod płatności]
* [**Zadanie 6**: Łączna suma wydatków klientów w ujęciu chronologicznym miesiąc do miesiąca (MoM)](#zadanie-6)
* [**Zadanie 7**: Ranking TOP 3 największych transakcji dla każdego miasta](#-zadanie-7-ranking-top-3-największych-transakcji-dla-każdego-miasta)
* [**Zadanie 8**: Analiza mobilności klientów (wydatki lokalne vs mobilne)](#-zadanie-8-analiza-mobilności-klientów-wydatki-lokalne-vs-mobilne)
</details>

<details>
<summary><b>🛡️ Blok III: Zaawansowana Analityka i Detekcja Anomalii (Zadania 9-11)</b></summary>

* [**Zadanie 9**: System Antyfraudowy (Wykrywanie podejrzanych transakcji transgranicznych)](#-zadanie-9-system-antyfraudowy-wykrywanie-podejrzanych-transakcji-transgranicznych)
* [**Zadanie 10**: Detekcja Anomalii (Wykrywanie transakcji rażąco odbiegających od średniej kategorii)](#-zadanie-10-detekcja-anomalii-wykrywanie-transakcji-rażąco-odbiegających-od-średniej-kategorii)
* [**Zadanie 11**: Analiza Retencji (Identyfikacja klientów zagrożonych odejściem)](#-zadanie-11-analiza-retencji-identyfikacja-klientów-zagrożonych-odejściem)
</details>

*(Dla każdego z powyższych zadań poniżej znajduje się pełny opis biznesowy, kod SQL, poglądowa tabela z wynikami oraz kluczowe wnioski analityczne).*

---

## 🚀 Detailed Tasks & Queries

<details>
<summary>📌 <b>Zadanie 1</b>: Rentowność prowizyjna i wolumen transakcji per miasto</summary>
<br>

**Opis biznesowy:** Analiza zakończonych sukcesem transakcji stacjonarnych w ujęciu geograficznym. Celem jest określenie łącznego obrotu, średniej wartości koszyka zakupowego oraz zysku banku z prowizji (0.2%) za płatności kartą w poszczególnych miastach.

### 💡 Kluczowy wniosek (Insight)
**Zapytanie precyzyjnie wskazuje lokalizacje generujące najwyższy strumień przychodów prowizyjnych, co pozwala działowi marketingu optymalizować budżety na lokalne kampanie partnerskie i targetować najbardziej dochodowe regiony.**

**Kod SQL:**
```sql
SELECT
	miasto_transakcji,
	COUNT(*) AS liczba_transakcji,
	ROUND(SUM(kwota), 0) AS laczny_obrot,
	ROUND(AVG(kwota), 2) AS srednia_wartosc,
	ROUND(SUM(CASE WHEN metoda_platnosci = 'Karta' THEN kwota * 0.002 ELSE 0 END), 2) AS zysk_banku_prowizja
FROM v_CzysteTransakcje
WHERE miasto_transakcji <> 'Online / Brak danych'
	AND status_transakcji = 'Zakonczona'
GROUP BY miasto_transakcji
ORDER BY zysk_banku_prowizja DESC;
```
**Poglądowy wynik analizy (Top 5 rekordów):**
| miasto_transakcji | liczba_transakcji | laczny_obrot | srednia_wartosc | zysk_banku_prowizja |
| :--- | :---: | :---: | :---: | :---: |
| **Rzym** | 140 | 1123185 | 8022,75 | 2240,22 |
| **Nowy jork** | 124 | 967875 | 7805,44 | 1931,2 |
| **Paryż** | 111 | 920029 | 8288,55 | 1837,86 |
| **Berlin** | 110 | 861105 | 7828,23 | 1718,54 |
| **Londyn** | 94 | 797730 | 8486,49 | 1582,28 |
</details>

<details>
<summary>📌 <b>Zadanie 2</b>: Liczba i suma transakcji w podziale na godziny w ciągu doby</summary>
<br>

**Opis biznesowy:** Analiza liczby oraz wolumenu transakcji w ujęciu godzinowym. Celem jest identyfikacja godzin szczytowego obciążenia systemu, co pozwala zoptymalizować okna serwisowe i dostosować wydajność infrastruktury bankowej do okresów największej aktywności klientów.

### 💡 Kluczowy wniosek (Insight)
**Zapytanie pozwala precyzyjnie zlokalizować godziny szczytu transakcyjnego, co umożliwia planowanie prac konserwacyjnych w okresach najniższego obciążenia systemu i minimalizuje ryzyko przestojów dla użytkowników.**

**Kod SQL:**
```sql
SELECT
	DATEPART(hour, data_transakcji) AS godzina,
	COUNT(*) AS liczba_transakcji,
	ROUND(SUM(kwota), 0) AS laczna_kwota
FROM v_CzysteTransakcje
GROUP BY DATEPART(hour, data_transakcji)
ORDER BY godzina ASC;
```
**Poglądowy wynik analizy (Top 5 rekordów):**

| godzina | liczba_transakcji | laczna_kwota |
| :--- | :---: | :---: |
| **0** | 473 | 157949 |
| **1** | 247 | 83454 |
| **2** | 248 | 195163 |
| **3** | 214 | 76770 |
| **4** | 232 | 90845 |
</details>

<details>
<summary>📌 <b>Zadanie 3</b>: Top 10 najbardziej dochodowych klientów</summary>
<br>

**Opis biznesowy:** Identyfikacja kluczowych klientów (VIP) generujących największy obrót na kontach bankowych. Analiza sumy uregulowanych transakcji pozwala wyodrębnić segment użytkowników o najwyższej wartości dla instytucji, co umożliwia przygotowanie spersonalizowanych ofert premium oraz programów lojalnościowych.

### 💡 Kluczowy wniosek (Insight)
**Wskazanie konkretnych liderów obrotu finansowego pozwala działowi CRM na bezpośrednie targetowanie segmentu VIP, minimalizując ryzyko ich odejścia do konkurencji i zwiększając efektywność długofalowej polityki retencyjnej banku.**

**Kod SQL:**
```sql
SELECT TOP 10
	k.klient_id,
	k.imie || ' ' || k.nazwisko AS pelne_nazwisko,
	k.miasto_rodzinne,
	ROUND(SUM(t.kwota), 0) AS laczna_kwota_transakcji
FROM TabelaKlienci k
JOIN TabelaKonta ko ON k.klient_id = ko.klient_id
JOIN v_CzysteTransakcje t ON ko.konto_id = t.konto_id
WHERE t.status_transakcji = 'Zakonczona'
GROUP BY k.klient_id, k.imie, k.nazwisko, k.miasto_rodzinne
ORDER BY SUM(t.kwota) DESC;
```
**Poglądowy wynik analizy (Top 5 rekordów):**

| klient_id | pelne_nazwisko | miasto_rodzinne | laczna_kwota_transakcji |
| :--- | :--- | :--- | :--- |
| **488** | Paweł Wieczorek | Gliwice | 107122 |
| **867** | Jakub Malinowski | Tychy | 85071 |
| **906** | Katarzyna Nowak | Orzesze | 84514 |
| **723** | Karolina Witkowska | Chorzów | 78974 |
| **684** | Andrzej Adamczyk | Bytom | 78152 |
</details>

<details>
<summary>📌 <b>Zadanie 4</b>: Porównanie segmentów klientów Standard, Premium i VIP</summary>
<br>

**Opis biznesowy:** Kompleksowe zestawienie segmentów użytkowników w celu weryfikacji ich realnej wartości biznesowej. Analiza pozwala ocenić strukturę bazy klienckiej oraz porównać wolumeny finansowe, średnią wartość transakcji i częstotliwość transakcji pomiędzy grupami Standard, Premium i VIP, co stanowi podstawę do optymalizacji strategii produktowej.

### 💡 Kluczowy wniosek (Insight)
**Mimo że segment VIP jest najmniej liczny, jego średnia wartość transakcji drastycznie przewyższa pozostałe grupy, co potwierdza wysoką rentowność obsługi tych klientów. Z kolei zbliżona średnia liczba transakcji na klienta we wszystkich segmentach dowodzi stałego, wysokiego zaangażowania użytkowników niezależnie od ich statusu majątkowego.**

**Kod SQL:**
```sql
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
```
**Poglądowy wynik analizy:**

| segment_klienta | liczba_klientow | liczba_transakcji | laczna_kwota | srednia_wartosc | srednia_liczba_transakcji_na_klienta |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Standard** | 808 | 36224 | 12976032 | 358,22 | 44,8 |
| **Premium** | 146 | 6772 | 2512551 | 371,02 | 46,4 |
| **VIP** | 46 | 1986 | 1577152 | 794,13 | 43,2 |
</details>

<details>
<summary>📌 <b>Zadanie 5</b>: Udział procentowy metod płatności</summary>
<br>

**Opis biznesowy:** Analiza struktury wykorzystania kanałów płatności przez klientów banku. Określenie procentowego udziału poszczególnych metod (np. BLIK, Karta, Przelew) w łącznej liczbie zrealizowanych transakcji pozwala zrozumieć preferencje użytkowników, co jest kluczowe dla rozwoju aplikacji mobilnej oraz negocjacji stawek interchange z organizacjami płatniczymi.

### 💡 Kluczowy wniosek (Insight)
**Wskazanie dominujących metod płatności pozwala bankowi optymalizować stabilność systemów transakcyjnych w najbardziej obciążonych kanałach oraz lepiej dopasować programy partnerskie i cashbackowe do realnych zachowań klientów.**

**Kod SQL:**
```sql
SELECT
	metoda_platnosci,
	COUNT(*) AS liczba_transakcji,
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS udzial_procentowy
FROM v_CzysteTransakcje
WHERE status_transakcji = 'Zakonczona'
GROUP BY metoda_platnosci
ORDER BY udzial_procentowy DESC;
```
**Poglądowy wynik analizy:**

| metoda_platnosci | liczba_transakcji | udzial_procentowy |
| :--- | :--- | :--- |
| **BLIK** | 17594 | 39,11 |
| **Karta** | 16412 | 36,49 |
| **Online** | 8055 | 17,91 |
| **Przelew Krajowy** | 2921 | 6,49 |
</details>

<details>
<summary><a id="zadanie-6"></a>📌 <b>Zadanie 6</b>: Łączna suma wydatków klientów w ujęciu chronologicznym miesiąc do miesiąca (MoM)</summary>
<br>

**Opis biznesowy:** Analiza trendu dynamiki wydatków klientów w ujęciu miesięcznym (Month-over-Month). Wykorzystanie funkcji okna pozwala na bezpośrednie porównanie łącznego wolumenu transakcji z miesiąca na miesiąc oraz wyznaczenie procentowego wskaźnika zmiany, co jest kluczowe dla identyfikacji sezonowości w zachowaniach płatniczych oraz prognozowania płynności finansowej.

### 💡 Kluczowy wniosek (Insight)
**Monitorowanie wskaźnika MoM pozwala na wczesne wykrywanie anomalii rynkowych oraz okresów zwiększonej aktywności zakupowej (np. okresy przedświąteczne), co umożliwia lepsze zarządzanie kapitałem oraz odpowiednie dopasowanie terminów kampanii marketingowych.**

**Kod SQL:**
```sql
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
```
**Poglądowy wynik analizy (Top 5 rekordów):**

| miesiac | suma_kwoty | suma_poprzedni_miesiac | zmiana_procentowa_mom |
| :--- | :--- | :--- | :--- |
| **2025-01-01** | 1378372 | NULL | NULL |
| **2025-02-01** | 1027472 | 1378372 | -25,46 |
| **2025-03-01** | 1305784 | 1027472 | 27,09 |
| **2025-04-01** | 1386010 | 1305784 | 6,14 |
| **2025-05-01** | 1440028 | 1386010 | 3,9 |
</details>

<details>
<summary>📌 <b>Zadanie 7</b>: Ranking TOP 3 największych transakcji dla każdego miasta</summary>
<br>

**Opis biznesowy:** Identyfikacja najwyższych jednostkowych operacji finansowych w podziale na lokalizacje geograficzne (miasta transakcji). Zastosowanie funkcji analitycznej `DENSE_RANK()` umożliwia precyzyjne uszeregowanie transakcji i wyłonienie ścisłej czołówki dla każdego rynku lokalnego, co pozwala na analizę regionalnej siły nabywczej klientów oraz wykrywanie obszarów o największym potencjale dla usług premium.

### 💡 Kluczowy wniosek (Insight)
**Wskazanie miast generujących najwyższe pojedyncze transakcje pozwala na optymalizację lokalnych działań marketingowych oraz dostarcza cennych danych dla systemów antyfraudowych, które mogą precyzyjniej kalibrować limity bezpieczeństwa w zależności od specyfiki danego regionu.**

**Kod SQL:**
```sql
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
	AND miasto_transakcji NOT LIKE 'Online%'
ORDER BY MAX(kwota) OVER (PARTITION BY miasto_transakcji) DESC, miasto_transakcji, pozycja_w_miescie;
```
**Poglądowy wynik analizy (Top 5 rekordów):**

| miasto_transakcji | pozycja_w_miescie | transakcja_id | klient_id | kwota |
| :--- | :--- | :--- | :--- | :--- |
| **Mikołów** | 1 | 535873 | 38 | 27594,32 |
| **Mikołów** | 2 | 502274 | 164 | 17730,14 |
| **Mikołów** | 3 | 502801 | 623 | 16924 |
| **Tychy** | 1 | 542405 | 485 | 26607,99 |
| **Tychy** | 2 | 522882 | 939 | 23296,41 |
</details>

<details>
<summary>📌 <b>Zadanie 8</b>: Analiza mobilności klientów (wydatki lokalne vs mobilne)</summary>
<br>

**Opis biznesowy:** Ocena poziomu migracji i mobilności klientów poprzez porównanie wolumenu transakcji realizowanych w ich miastach rodzinnych z wydatkami w pozostałych lokalizacjach stacjonarnych (z wykluczeniem transakcji internetowych). Wynik pozwala wyodrębnić segment użytkowników „podróżujących”, co umożliwia precyzyjne targetowanie ofert związanych z ubezpieczeniami turystycznymi, kontami walutowymi czy programami partnerskimi na stacjach paliw.

### 💡 Kluczowy wniosek (Insight)
**Identyfikacja klientów o najwyższym odsetku wydatków poza miejscem zamieszkania pozwala na optymalizację geolokalizacyjnych powiadomień push w aplikacji mobilnej oraz dostarcza istotnych danych dla modeli oceniających ryzyko kredytowe i behawioralne.**

**Kod SQL:**
```sql
SELECT
	k.klient_id,
	k.imie || ' ' || k.nazwisko AS pelne_nazwisko,
	ROUND(SUM(CASE WHEN k.miasto_rodzinne = t.miasto_transakcji THEN t.kwota ELSE 0 END), 0) AS wydatki_lokalne,
	ROUND(SUM(CASE WHEN k.miasto_rodzinne <> t.miasto_transakcji THEN t.kwota ELSE 0 END), 0) AS wydatki_mobilne,
	ROUND(SUM(CASE WHEN k.miasto_rodzinne <> t.miasto_transakcji THEN t.kwota ELSE 0 END) * 100 / NULLIF(SUM(t.kwota), 0), 2) AS procent_wydatkow_mobilnych
FROM v_CzysteTransakcje t
JOIN TabelaKonta ko ON t.konto_id = ko.konto_id
JOIN TabelaKlienci k ON ko.klient_id = k.klient_id
WHERE t.status_transakcji = 'Zakonczona'
	AND t.miasto_transakcji NOT LIKE 'Online%'
GROUP BY k.klient_id, k.imie, k.nazwisko
ORDER BY procent_wydatkow_mobilnych DESC;
```
**Poglądowy wynik analizy (Top 5 rekordów):**

| klient_id | pelne_nazwisko | wydatki_lokalne | wydatki_mobilne | procent_wydatkow_mobilnych |
| :--- | :--- | :--- | :--- | :--- |
| **523** | Małgorzata Wieczorek | 345 | 20971 | 98,38 |
| **95** | Aleksandra Nowak | 503 | 28167 | 98,24 |
| **786** | Małgorzata Krawczyk | 642 | 21668 | 97,12 |
| **554** | Adam Pawłowski | 705 | 18755 | 96,38 |
| **946** | Marcin Adamczyk | 853 | 21332 | 96,15 |
</details>

<details>
<summary>📌 <b>Zadanie 9</b>: System Antyfraudowy (Wykrywanie podejrzanych transakcji transgranicznych)</summary>
<br>

**Opis biznesowy:** Algorytm detekcji nadużyć finansowych (Anti-Fraud) identyfikujący niemożliwe z fizycznego punktu widzenia zachowania użytkowników (tzw. *velocity checks*). Analiza wyszukuje pary transakcji stacjonarnych zrealizowanych na tym samym koncie w odstępie krótszym niż godzina, ale w różnych krajach. Taka sytuacja jednoznacznie wskazuje na wysokie ryzyko przejęcia danych karty lub sklonowania paska magnetycznego, wymagając natychmiastowej blokady prewencyjnej.

### 💡 Kluczowy wniosek (Insight)
**Wdrożenie reguł czasu rzeczywistego opartego na tym zapytaniu pozwala systemom bezpieczeństwa banku automatycznie odrzucać autoryzacje transakcji obciążonych wysokim ryzykiem fraudu, co bezpośrednio minimalizuje straty finansowe instytucji oraz podnosi poziom zaufania klientów.**

**Kod SQL:**
```sql
WITH TransakcjeZHistoria AS (
	SELECT 
		k.klient_id,
		t.data_transakcji AS podejrzana_transakcja,
		t.kraj_transakcji AS kraj_podejrzanej_transakcji,
		t.kwota AS kwota_podejrzanej_transakcji,
		LAG(t.data_transakcji) OVER (PARTITION BY k.klient_id ORDER BY t.data_transakcji) AS poprzednia_transakcja,
		LAG(t.kraj_transakcji) OVER (PARTITION BY k.klient_id ORDER BY t.data_transakcji) AS kraj_poprzedniej_transakcji,
		LAG(t.kwota) OVER (PARTITION BY k.klient_id ORDER BY t.data_transakcji) AS kwota_poprzedniej_transakcji
	FROM v_CzysteTransakcje t
	JOIN TabelaKonta ko ON t.konto_id = ko.konto_id
	JOIN TabelaKlienci k ON ko.klient_id = k.klient_id
	WHERE t.kraj_transakcji NOT LIKE '%online%'
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
```
**Poglądowy wynik analizy (Top 5 rekordów):**

| klient_id | podejrzana_transakcja | kraj_podejrzanej_transakcji | kwota_podejrzanej_transakcji | poprzednia_transakcja | kraj_poprzedniej_transakcji | kwota_poprzedniej_transakcji |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **27** | 2025-12-27 08:42:31 | Czechy | 13742,81 | 2025-12-27 08:23:56 | Polska | 24,15 |
| **782** | 2025-04-11 08:05:58 | Włochy | 12164,63 | 2025-04-11 07:34:35 | Polska | 10,15 |
| **265** | 2025-04-03 18:39:33 | Czechy | 12001,47 | 2025-04-03 18:37:10 | Polska | 18,77 |
| **106** | 2025-06-08 13:51:29 | Włochy | 11831,06 | 2025-06-08 13:44:53 | Polska | 49,54 |
| **783** | 2025-12-28 18:31:34 | Czechy | 4957,9 | 2025-12-28 17:54:50 | Polska | 46,39 |
</details>

<details>
<summary>📌 <b>Zadanie 10</b>: Detekcja Anomalii (Wykrywanie transakcji rażąco odbiegających od średniej kategorii)</summary>
<br>

**Opis biznesowy:** Zaawansowana analiza statystyczna ukierunkowana na wykrywanie nietypowych zachowań finansowych (Anomaly Detection). Zapytanie identyfikuje transakcje, których wartość ponad pięciokrotnie przewyższa średnią kwotę operacji w danej kategorii wydatków. Narzędzie to pozwala wyłapywać błędy systemowe, nietypowe zakupy luksusowe oraz potencjalne nadużycia, zanim wpłyną one na zaburzenie globalnych statystyk raportowych.

### 💡 Kluczowy wniosek (Insight)
**Automatyczna kategoryzacja i wyznaczanie odchyleń od normy (krotności średniej) umożliwia natychmiastowe flagowanie transakcji do ręcznej weryfikacji przez zespół operacyjny, co pozwala chronić kapitał banku oraz utrzymywać wysoką jakość danych analitycznych.**

**Kod SQL:**
```sql
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
```
**Poglądowy wynik analizy (Top 5 rekordów):**

| klient_id | transakcja_id | kategoria_wydatku | kwota | srednia_kwota_kategorii | krotnosc_sredniej |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **955** | 522007 | Przelew | 19555,2 | 257,48 | 75,9 |
| **677** | 503621 | Przelew | 19170,23 | 257,48 | 74,5 |
| **38** | 535873 | Elektronika | 27594,32 | 415,69 | 66,4 |
| **485** | 542405 | Elektronika | 26607,99 | 415,69 | 64 |
| **750** | 542335 | Elektronika | 26509,12 | 415,69 | 63,8 |
</details>

<details>
<summary>📌 <b>Zadanie 11</b>: Analiza Retencji (Identyfikacja klientów zagrożonych odejściem)</summary>
<br>

**Opis biznesowy:** Analiza wskaźnika retencji (Churn Analysis) nastawiona na prewencyjne wykrywanie klientów pasywnych, u których brak aktywności transakcyjnej przekracza 30 dni względem ostatniej daty w bazie danych. Wykorzystanie złączenia krzyżowego (`CROSS JOIN`) do dynamicznego wyznaczenia punktu odniesienia pozwala precyzyjnie określić czas trwania bezczynności, co umożliwia działom CRM podjęcie natychmiastowych działań reaktywacyjnych (np. poprzez dedykowane kampanie mailingowe lub oferty specjalne).

### 💡 Kluczowy wniosek (Insight)
**Wczesne flagowanie użytkowników wykazujących symptomy odejścia (churnu) pozwala na drastyczne obniżenie kosztów utrzymania bazy klienckiej (Retention Cost) w porównaniu do wydatków niezbędnych na pozyskanie nowych użytkowników (Customer Acquisition Cost).**

**Kod SQL:**
```sql
WITH DataOdniesienia AS (
	SELECT MAX(data_transakcji) AS punkt_odniesienia
	FROM v_CzysteTransakcje
)
SELECT
	k.klient_id,
	k.imie || ' ' || k.nazwisko AS pelne_nazwisko,
	CONVERT(DATE, MAX(t.data_transakcji)) AS data_ostatniej_transakcji,
	DATEDIFF(day,  MAX(t.data_transakcji), d.punkt_odniesienia) AS dni_bez_aktywnosci
FROM v_CzysteTransakcje t
JOIN TabelaKonta ko ON t.konto_id = ko.konto_id
JOIN TabelaKlienci k ON ko.klient_id = k.klient_id
CROSS JOIN DataOdniesienia d
GROUP BY k.klient_id, k.imie, k.nazwisko, d.punkt_odniesienia
HAVING DATEDIFF(day,  MAX(t.data_transakcji), d.punkt_odniesienia) > 30
ORDER BY dni_bez_aktywnosci DESC;
```
**Poglądowy wynik analizy (Top 5 rekordów):**

| klient_id | pelne_nazwisko | data_ostatniej_transakcji | dni_bez_aktywnosci |
| :--- | :--- | :--- | :--- |
| **60** | Maria Jabłońska | 2025-10-27 | 65 |
| **389** | Aleksandra Król | 2025-10-31 | 61 |
| **912** | Michał Kaczmarek | 2025-11-04 | 57 |
| **459** | Adam Michalski | 2025-11-20 | 41 |
| **31** | Karolina Wójcik | 2025-11-25 | 36 |
</details>
