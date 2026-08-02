# 📊 Bank Data Analysis Dashboard – Power BI

![Demo Dashboardu](./BankPowerBI_Gif.gif)

*🎥 GIF prezentuje nawigację pomiędzy stronami dashboardu oraz interaktywne filtrowanie danych za pomocą slicerów.*

> 💡 Dashboard został zbudowany na danych przygotowanych i przeanalizowanych w projekcie SQL. Stanowi jego wizualne rozwinięcie, prezentując wyniki analiz w formie interaktywnych raportów.

---

## 📝 Project Overview

Celem tej części projektu było stworzenie interaktywnego dashboardu w Power BI, który w czytelny sposób prezentuje wyniki analiz wykonanych wcześniej w **MS SQL Server**.

Dashboard rozwija część SQL projektu, zamieniając dane i zapytania w interaktywne wizualizacje ułatwiające analizę klientów, transakcji oraz najważniejszych wskaźników biznesowych.

> 🗄️ **SQL Data Pipeline**  
> Przygotowanie danych, proces ETL oraz wszystkie analizy SQL zostały opisane w pierwszej części projektu.  
> 🔗 **[Zobacz projekt SQL →](./README_01_SQL.md)**

---

## 🛠️ Power BI Features

- **Power Query** – przygotowanie danych do raportu, typowanie kolumn oraz tworzenie kolumn pomocniczych.
- **Star Schema** – relacyjny model danych oparty na tabelach faktów i wymiarów.
- **DAX Measures** – autorskie miary obliczające kluczowe KPI, m.in. prowizję banku, obrót, średnią wartość transakcji oraz wskaźniki ryzyka i churnu.
- **Bookmarks & Buttons** – własny panel nawigacyjny umożliwiający płynne przełączanie pomiędzy widokami dashboardu.
- **Slicers & Cross-filtering** – filtrowanie danych za pomocą slicera dat oraz interaktywnych wizualizacji, które automatycznie filtrują pozostałe elementy raportu.
- **Conditional Formatting** – wizualne wyróżnianie podejrzanych transakcji, odchyleń kwotowych oraz najważniejszych wartości na wykresach i w tabelach.

---

## 📑 Dashboard Pages

<details>
<summary><b>🏠 Przegląd ogólny i aktywność</b></summary>

<br>

Ta strona przedstawia najważniejsze wskaźniki biznesowe oraz ogólną aktywność klientów. Zawiera kluczowe KPI (liczbę klientów, liczbę transakcji, średnią wartość transakcji oraz przychód z prowizji za płatności kartą), a także wizualizacje pokazujące aktywność w ciągu dnia, wyniki w podziale na miasta oraz segmentację klientów.

<img width="1621" height="844" alt="image" src="https://github.com/user-attachments/assets/b35331d8-f8e5-4305-a8a0-83dc2e51cb6c" />


</details>

<details>
<summary><b>📈 Trendy i struktura wydatków</b></summary>

<br>

Ta strona skupia się na analizie zachowań zakupowych klientów. Pokazuje zmiany wydatków w czasie, udział metod płatności, mobilność klientów oraz ranking największych transakcji w podziale na miasta.

<img width="1597" height="843" alt="image" src="https://github.com/user-attachments/assets/449b01b9-e83e-43bb-ae8e-0a3234813355" />


</details>

<details>
<summary><b>🛡️ Bezpieczeństwo i analiza ryzyka</b></summary>

<br>

Ta strona prezentuje analizy związane z bezpieczeństwem banku. Zawiera informacje o podejrzanych transakcjach, wykrytych anomaliach oraz klientach zagrożonych odejściem (Churn), ułatwiając identyfikację potencjalnych incydentów i obszarów wymagających dalszej analizy.

<img width="1620" height="846" alt="image" src="https://github.com/user-attachments/assets/650e7e45-7af1-4623-b192-a32230fffc82" />


</details>

---

## 🚀 Getting Started

1. Pobierz plik `Bank_Analytics_Report.pbix` z repozytorium.
2. Otwórz go w darmowym programie **Power BI Desktop**.
3. Raport działa w trybie **Import Mode**, dlatego nie wymaga konfigurowania lokalnej bazy danych ani ponownego importowania danych.

---

*Projekt został wykonany jako element mojego portfolio Data Analyst i prezentuje umiejętności tworzenia interaktywnych raportów oraz dashboardów w Power BI na podstawie danych przygotowanych w MS SQL Server.*
