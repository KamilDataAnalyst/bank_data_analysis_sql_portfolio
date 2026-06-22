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

## 📂 Project Structure & Core Analyses - ZMIENIC NAZWY!!!
Prace nad projektem zostały podzielone na trzy dedykowane bloki analityczne. Każde zadanie reprezentuje osobne wyzwanie biznesowe, symulując realne zgłoszenia od działów biznesowych, marketingu czy bezpieczeństwa.

### 🗺️ Spis zadań i bloków tematycznych:

<details>
<summary><b>👤 Blok I: Profilowanie i Segmentacja Bazy Klientów (Zadania 1-4)</b></summary>

* **Zadanie 1:** Analiza struktury demograficznej i wiekowej klientów.
* **Zadanie 2:** Identyfikacja kluczowych miast rodzinnych użytkowników.
* **Zadanie 3:** Segmentacja klientów pod kątem stażu w banku.
* **Zadanie 4:** Analiza popularności typów kont w zależności od segmentu.
</details>

<details>
<summary><b>💰 Blok II: Analiza Finansowa i Zachowania Transakcyjne (Zadania 5-8)</b></summary>

* **Zadanie 5:** Globalne podsumowanie wolumenu i wartości transakcji.
* **Zadanie 6:** Analiza struktury wydatków według kategorii (np. Rozrywka, Zakupy).
* **Zadanie 7:** Sezonowość transakcyjna – analiza aktywności w ujęciu miesięcznym i kwartalnym.
* **Zadanie 8:** Najpopularniejsze metody płatności i ich dominacja na rynku.
</details>

<details>
<summary><b>🛡️ Blok III: Zaawansowana Analityka i Detekcja Anomalii (Zadania 9-11)</b></summary>

* **Zadanie 9:** Wykrywanie nagłych skoków wartościowych (potencjalne oszustwa / Fraud Detection).
* **Zadanie 10:** Analiza klientów transakujących poza granicami kraju pochodzenia.
* **Zadanie 11:** Identyfikacja kont uśpionych (brak aktywności w zdefiniowanym czasie).
</details>

*(Dla każdego z powyższych zadań poniżej znajduje się pełny opis biznesowy, kod SQL, poglądowa tabela z wynikami oraz kluczowe wnioski analityczne).*

---

## 🚀 Detailed Tasks & Queries
