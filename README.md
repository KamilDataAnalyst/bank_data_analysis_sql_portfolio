# 🏦 Bank Data Analysis Project – SQL Portfolio

## 📝 Project Overview
Projekt powstał po to, aby wyciągnąć kluczowe wnioski biznesowe z danych bankowych. Analizowałem profile użytkowników, ich konta oraz historię operacji finansowych. Całość zrealizowałem za pomocą MS SQL.

---

## 🎯 Business Context & Goal
Zamiast opierać się na gotowych przykładach, chciałem zmierzyć się z problemami, z którymi banki faktycznie spotykają się na co dzień. Dlatego pracowałem na surowych logach transakcyjnych i przygotowałem analizy, które mogłyby pomóc w podejmowaniu decyzji biznesowych.

Skupiłem się na trzech głównych obszarach:
* **Profilowanie klientów** – sprawdziłem, jak wyglądają grupy klientów pod względem wieku, płci i innych cech demograficznych.
* **Metryki finansowe** – przeanalizowałem wzorce wydatków oraz aktywność na kontach, aby zidentyfikować najważniejsze trendy.
* **Wykrywanie oszustw (Fraud Detection)** – wyszukiwałem transakcje odbiegające od typowych zachowań, które mogły wskazywać na potencjalne nadużycia.
---

## 🛠️ Tech Stack & SQL Techniques

### Zastosowane rozwiązania

* **Czyszczenie i standaryzacja danych** – opracowałem logikę czyszczenia danych tekstowych z wykorzystaniem funkcji `UPPER`, `LOWER`, `LEFT`, `SUBSTRING` oraz `LEN`. Dzięki temu nazwy miejscowości zostały zapisane w jednolitym formacie (pierwsza litera wielka, pozostałe małe), co poprawiło spójność danych.

* **Widoki (Views)** – utworzyłem widoki, które oddzielają surowe dane od zapytań analitycznych. Dzięki temu kod jest bardziej przejrzysty, łatwiejszy do utrzymania i można go ponownie wykorzystać w kolejnych analizach.

* **Obsługa brakujących wartości** – w miejscach, gdzie występowały wartości `NULL`, zastosowałem odpowiednią logikę warunkową, aby zachować poprawność obliczeń i uniknąć błędów w analizach.

* **Common Table Expressions (CTE)** – wykorzystałem CTE do podziału bardziej złożonych zapytań na mniejsze, czytelniejsze etapy. Takie podejście ułatwia analizę kodu oraz jego dalszą rozbudowę.

* **Window Functions (Funkcje okna)** – zastosowałem funkcje okna do tworzenia rankingów oraz analiz porównawczych wewnątrz poszczególnych kategorii wydatków, bez konieczności tworzenia dodatkowych tabel.

* **Relacyjność i wielopoziomowe złączenia** – dane zostały połączone za pomocą `INNER JOIN`, wykorzystując tabelę `Accounts` jako tabelę pośredniczącą pomiędzy klientami a logami transakcyjnymi. Pozwoliło to powiązać każdą transakcję z danymi klienta i jego kontem.

* **Agregacje i filtrowanie danych** – do tworzenia zestawień wykorzystałem `GROUP BY` oraz `HAVING`, co umożliwiło analizę zagregowanych danych i filtrowanie wyników na podstawie określonych warunków.

---

## 📊 Data Model & Database Structure
Pracowałem na relacyjnej bazie danych składającej się z trzech tabel, które odzwierciedlają strukturę prawdziwego systemu bankowego:

* `Klienci` [Tabela Wymiaru] – zawiera unikalne, stałe profile klientów banku (1 000 wierszy).  
  * *Kolumny:* (`klient_id`, `imie`, `nazwisko`, `miasto_rodzinne`, `data_urodzenia`, `segment_klienta`)
* `Konta` [Tabela Wymiaru] – przechowuje informacje o rachunkach i łączy je z klientami (1 500 wierszy).  
  * *Kolumny:* (`konto_id`, `klient_id`, `typ_konta`, `waluta`, `data_otwarcia`)
* `Transakcje` [Tabela Faktów] – zawiera historię wszystkich transakcji wykonanych przez klientów w systemie (50 000 wierszy).  
  * *Kolumny:* (`transakcja_id`, `konto_id`, `kwota`, `data_transakcji`, `kategoria_wydatku`, `metoda_platnosci`, `miasto_transakcji`, `kraj_transakcji`, `status_transakcji`)

---

## ⚙️ Repository Structure & Data Pipeline (ETL)

Projekt podzieliłem na kolejne etapy – od importu surowych plików `.csv`, przez przygotowanie danych, aż po końcową analizę. W repozytorium znajdują się pliki źródłowe oraz skrypty SQL, które najlepiej uruchamiać w poniższej kolejności:

1. **[01_import_and_fixes.sql](01_import_and_fixes.sql)** – **Porządkowanie typów danych:** Po imporcie danych poprawiłem typy kolumn przypisane automatycznie przez kreator SQL Server. Zmieniłem kwoty na `FLOAT`, daty na `DATETIME2`, a identyfikatory na `INT`, dzięki czemu dalsze obliczenia i analizy działają poprawnie.

2. **[02_create_views.sql](02_create_views.sql)** – **Przygotowanie czystych widoków:** Utworzyłem widoki bazodanowe odpowiedzialne za czyszczenie i standaryzację danych przed analizą. W tym kroku ujednoliciłem wielkość liter w nazwach miast (żeby te same miejscowości nie zliczały się osobno), obsłużyłem wartości `NULL` oraz odfiltrowałem rekordy niespełniające przyjętych kryteriów biznesowych.

3. **[03_analysis_queries.sql](03_analysis_queries.sql)** – **Właściwa analiza:** Skrypt zawiera 11 zapytań SQL podzielonych na trzy główne obszary: profilowanie klientów, analizę metryk finansowych oraz wykrywanie potencjalnych nadużyć (Fraud Detection).

4. **[/data](/data)** – Folder zawierający źródłowe pliki `.csv` (`Klienci`, `Konta`, `Transakcje`), na których opiera się cały projekt.

---

## 📂 Project Structure & Core Analyses

Całą analizę podzieliłem na trzy bloki tematyczne. Każde zadanie opiera się na realnych wyzwaniach biznesowych, z jakimi na co dzień mierzą się działy marketingu, finansów czy bezpieczeństwa w bankowości.

### 🗺️ Spis zadań i bloków tematycznych:

<details>
<summary><b>👤 Blok I: Profilowanie i segmentacja bazy klientów (Zadania 1–4)</b></summary>

* [**Zadanie 1**: Przychody z prowizji i liczba transakcji w miastach](#zadanie-1)
* [**Zadanie 2**: Aktywność transakcyjna klientów w ciągu doby (podział na godziny)](#zadanie-2)
* [**Zadanie 3**: TOP 10 najbardziej dochodowych klientów](#zadanie-3)
* [**Zadanie 4**: Porównanie segmentów klientów (Standard, Premium, VIP)](#zadanie-4)
</details>

<details>
<summary><b>💰 Blok II: Analiza finansowa i zachowania transakcyjne (Zadania 5–8)</b></summary>

* [**Zadanie 5**: Procentowy udział metod płatności](#zadanie-5)
* [**Zadanie 6**: Zmiana wydatków klientów w czasie (ujęcie miesiąc do miesiąca – MoM)](#zadanie-6)
* [**Zadanie 7**: Ranking TOP 3 największych transakcji dla każdego miasta](#zadanie-7)
* [**Zadanie 8**: Mobilność klientów (porównanie wydatków lokalnych i zamiejscowych)](#zadanie-8)
</details>

<details>
<summary><b>🛡️ Blok III: Bezpieczeństwo i detekcja anomalii (Zadania 9–11)</b></summary>

* [**Zadanie 9**: System Antyfraudowy (wykrywanie podejrzanych transakcji zagranicznych)](#zadanie-9)
* [**Zadanie 10**: Detekcja anomalii (wydatki odbiegające od średniej)](#zadanie-10)
* [**Zadanie 11**: Analiza retencji (klienci zagrożeni odejściem z banku)](#zadanie-11)
</details>

*(Każde z powyższych zadań zawiera opis biznesowy, kod SQL, zrzut ekranu z SSMS oraz moje wnioski.)*

---

## 🚀 Detailed Tasks & Queries

<details>
<summary><a id="zadanie-1"></a>📌 <b>Zadanie 1</b>: Przychody z prowizji i liczba transakcji w miastach</summary>
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
	ROUND(SUM(CASE WHEN metoda_platnosci = 'Karta' THEN kwota * 0.002 ELSE 0 END), 2) AS zysk_banku_prowizja_z_karty
FROM v_CzysteTransakcje
WHERE miasto_transakcji <> 'Online / Brak danych'
	AND status_transakcji = 'Zakonczona'
GROUP BY miasto_transakcji
ORDER BY zysk_banku_prowizja_z_karty DESC;
```
**Top 10 wyników:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%201.png?raw=true)

</details>

<details>
<summary><a id="zadanie-2"></a>📌 <b>Zadanie 2</b>: Aktywność transakcyjna klientów w ciągu doby (podział na godziny)</summary>
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
ORDER BY laczna_kwota DESC;
```
**Top 10 wyników:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%202.png?raw=true)

</details>

<details>
<summary><a id="zadanie-3"></a>📌 <b>Zadanie 3</b>: TOP 10 najbardziej dochodowych klientów</summary>
<br>

**Opis biznesowy:** Identyfikacja kluczowych klientów (VIP) generujących największy obrót na kontach bankowych. Analiza sumy uregulowanych transakcji pozwala wyodrębnić segment użytkowników o najwyższej wartości dla instytucji, co umożliwia przygotowanie spersonalizowanych ofert premium oraz programów lojalnościowych.

### 💡 Kluczowy wniosek (Insight)
**Wskazanie konkretnych liderów obrotu finansowego pozwala działowi CRM na bezpośrednie targetowanie segmentu VIP, minimalizując ryzyko ich odejścia do konkurencji i zwiększając efektywność długofalowej polityki retencyjnej banku.**

**Kod SQL:**
```sql
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
ORDER BY laczna_kwota_transakcji DESC;
```
**Pełny wynik zapytania:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%203.png?raw=true)

</details>

<details>
<summary><a id="zadanie-4"></a>📌 <b>Zadanie 4</b>: Porównanie segmentów klientów (Standard, Premium, VIP)</summary>
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
**Pełny wynik zapytania:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%204.png?raw=true)

</details>

<details>
<summary><a id="zadanie-5"></a>📌 <b>Zadanie 5</b>: Procentowy udział metod płatności</summary>
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
**Pełny wynik zapytania:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%205.png?raw=true)

</details>

<details>
<summary><a id="zadanie-6"></a>📌 <b>Zadanie 6</b>: Zmiana wydatków klientów w czasie (ujęcie miesiąc do miesiąca – MoM)</summary>
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
**Pełny wynik zapytania:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%206.png?raw=true)

</details>

<details>
<summary><a id="zadanie-7"></a>📌 <b>Zadanie 7</b>: Ranking TOP 3 największych transakcji dla każdego miasta</summary>
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
	AND miasto_transakcji <> 'Online / Brak danych'
ORDER BY MAX(kwota) OVER (PARTITION BY miasto_transakcji) DESC, miasto_transakcji, pozycja_w_miescie;
```
**Top 12 wyników:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%207.png?raw=true)

</details>

<details>
<summary><a id="zadanie-8"></a>📌 <b>Zadanie 8</b>: Mobilność klientów (porównanie wydatków lokalnych i zamiejscowych)</summary>
<br>

**Opis biznesowy:** Ocena poziomu migracji i mobilności klientów poprzez porównanie wolumenu transakcji realizowanych w ich miastach rodzinnych z wydatkami w pozostałych lokalizacjach stacjonarnych (z wykluczeniem transakcji internetowych). Wynik pozwala wyodrębnić segment użytkowników „podróżujących”, co umożliwia precyzyjne targetowanie ofert związanych z ubezpieczeniami turystycznymi, kontami walutowymi czy programami partnerskimi na stacjach paliw.

### 💡 Kluczowy wniosek (Insight)
**Identyfikacja klientów o najwyższym odsetku wydatków poza miejscem zamieszkania pozwala na optymalizację geolokalizacyjnych powiadomień push w aplikacji mobilnej oraz dostarcza istotnych danych dla modeli oceniających ryzyko kredytowe i behawioralne.**

**Kod SQL:**
```sql
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
```
**Top 10 wyników:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%208.png?raw=true)

</details>

<details>
<summary><a id="zadanie-9"></a>📌 <b>Zadanie 9</b>: System Antyfraudowy (wykrywanie podejrzanych transakcji zagranicznych)</summary>
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
```
**Pełny wynik zapytania:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%209.png?raw=true)

</details>

<details>
<summary><a id="zadanie-10"></a>📌 <b>Zadanie 10</b>: Detekcja anomalii (wydatki odbiegające od średniej)</summary>
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
**Top 10 wyników:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%2010.png?raw=true)

</details>

<details>
<summary><a id="zadanie-11"></a>📌 <b>Zadanie 11</b>: Analiza retencji (klienci zagrożeni odejściem z banku)</summary>
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
```
**Pełny wynik zapytania:**

![image alt](https://github.com/KamilDataAnalyst/bank_data_analysis_sql_portfolio/blob/main/sql_queries_screenshots/Zadanie%2011.png?raw=true)

</details>

---

## 📈 Summary & Business Impact

Projekt pozwolił na przekształcenie ponad 50 000 surowych rekordów transakcyjnych w realne wskaźniki biznesowe (KPI). Dzięki zastosowaniu zaawansowanych technik SQL, takich jak funkcje okna, wyrażenia CTE oraz procesy ETL, udało się:
* **Zoptymalizować koszty CRM** poprzez precyzyjne wytypowanie klientów zagrożonych odejściem (Analiza Retencji).
* **Zwiększyć bezpieczeństwo funduszy** dzięki stworzeniu fundamentu pod reguły antyfraudowe działające w czasie rzeczywistym (*velocity checks*).
* **Dostarczyć wiedzy marketingowej** o geolokalizacji wydatków klientów, co umożliwia lepsze targetowanie kampanii push i ofert partnerskich.

---

## 🚀 Jak uruchomić projekt u siebie?

1. Pobierz zawartość tego repozytorium na swój komputer (kliknij zielony przycisk **Code** u góry strony, a następnie wybierz **Download ZIP** i rozpakuj archiwum).
2. Zaimportuj pliki `.csv` z folderu `/data` do swojego programu MS SQL Server Management Studio (SSMS).
3. Uruchom skrypty SQL w swojej bazie danych w następującej kolejności:
   * `01_import_and_fixes.sql` (przygotowanie danych i zmiana typów kolumn)
   * `02_create_views.sql` (utworzenie widoków standaryzujących i czyszczących)
   * `03_analysis_queries.sql` (główne zapytania analityczne i raportowe)

---
*Całość napisałem i udokumentowałem sam, traktując ten projekt jako główny element mojego portfolio data analyst."*
