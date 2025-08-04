# DST Analysis Fortran Program

## 🌍 Overview

This repository contains a Fortran-based program that calculates solar timing parameters such as **sunrise**, **sunset**, **sunlight duration**, and **working hours in darkness** for multiple cities over a multi-year period. The program is designed to assist in analyzing **Daylight Saving Time (DST)** effectiveness and solar-work alignment across various geographic regions.

---

## 📊 Key Features

- Calculates:
  - **Sunrise & Sunset Times**
  - **Sunlight Duration**
  - **Nighttime Duration**
  - **Working Time in Darkness**
- Supports **multiple cities** and **multi-year periods**
- Outputs results to CSV format for easy integration with spreadsheet and plotting tools
- Compatible with **Windows**, tested with `gfortran`

---

## 📁 Repository Structure

```text
├── dst_analysis.f90        # Main Fortran source code
├── cities.csv              # Input file: list of cities with coordinates
├── output.csv              # Output file: processed daily results
├── summary.csv             # Output file: processed annual results
├── README.md               # Documentation
├── LICENCE.md              # Licence Doc
```

---

## 📥 Input Format

 ### `cities.csv`

This file lists the cities and their geographic coordinates in the following format:

```python-repl 
  CITY,LATITUDE,LONGITUDE
  ANTALYA,36.9,30.7
  ANKARA,39.9,32.9
  ...
```

- `CITY`: Name of the city (string)
- `LATITUDE`: Latitude in decimal degrees (north = positive)
- `LONGITUDE`: Longitude in decimal degrees (east = positive)

 ### `dst_analysis.f90`

Edit the **Set run periods** and **Work periods for a day** sections in the main code:

| Parametre | Tip     | Açıklama                       |
| :-------- | :------- | :-------------------------------- |
| `START_YEAR`      | `integer` | Start year of the run period |
| `END_YEAR`      | `integer` | End year of the run period |
| `FIRST_TIMEZONE`      | `real` | First value of the time zone for analysis |
| `LAST_TIMEZONE`      | `real` | Last value of the time zone for analysis |
| `TIMEZONE_STEP`      | `real` | Time zone period increment value |
| `TOT_WORKING_HOURS`      | `real` | Total working hours in a day |
| `FST_STRT_WORKING_HOURS_HH`      | `real` | Hours value of the first start time for the daily work period |
| `FST_STRT_WORKING_HOURS_MM`      | `real` | Minutes value of the first start time for the daily work period |
| `LAST_STRT_WORKING_HOURS_HH`      | `real` | Hours value of the last end time for the daily work period |
| `LAST_STRT_WORKING_HOURS_MM`      | `real` | Minutes value of the last end time for the daily work period |
| `WORKING_HOURS_START_STEP_VALUE`      | `real` | Step value for daily work period starting time |

---

## 📤 Output Format

 ### `output.csv`

Each row contains the analyzed DST-related daily data for a specific date and city such as:

```python-repl 
  CITY,TIMEZONE,YEAR,MONTH,DAY,TOT_WORKING_HOURS,STR_SRT,STR_SST,STR_SWH,STR_EWH,STR_WORKINDARK,STR_SLD,STR_NTD
  ANTALYA,  2.0,2024, 1, 1,  9.00,07:10:02,16:50:27,07:00:00,16:00:00,00:09:59,09:40:26,14:19:34
  ANTALYA,  2.0,2024, 1, 2,  9.00,07:10:12,16:51:13,07:00:00,16:00:00,00:09:59,09:41:01,14:18:59
  ...
  ANKARA,  2.5,2025, 7,24,  9.00,05:09:52,19:40:20,08:30:00,17:30:00,00:00:00,14:30:28,09:29:32
  ...
```

- `CITY`: Name of the city (string)
- `TIMEZONE`: UTC Timezone (real number)
- `YEAR`, `MONTH`, `DAY`: Date values
- `TOT_WORKING_HOURS`: Total working hours in a day (real number)
- `STR_SRT`, `STR_SST`: Daily sunrise and sunset time
- `STR_SWH`, `STR_EWH`: Daily working period start and end time
- `STR_WORKINDARK`: Daily time of working period in darkness
- `STR_SLD`, `STR_NTD`: Daily sunlight and nighttime duration

 ### `summary.csv`

 Each row contains the analyzed DST-related annual data for a specific date and city such as:

 ```python-repl 
  CITY,TIMEZONE,YEAR,STR_SWH,STR_EWH,STR_TOTAL_WORKINDARK
  ANTALYA,  2.0,2024,07:00:00,16:00:00,5:40:59  
  ANTALYA,  2.0,2025,07:00:00,16:00:00,5:31:59  
  ...
  ANKARA,  3.0,2026,09:00:00,18:00:00,38:41:00 
  ...
```

- `CITY`: Name of the city (string)
- `TIMEZONE`: UTC Timezone (real number)
- `YEAR`: Year values
- `STR_SWH`, `STR_EWH`: Daily working period start and end time
- `STR_TOTAL_WORKINDARK`: Total annual hours of working period in darkness

---

## ⚙️ How to Compile and Run

### 📌 Requirements

- Fortran compiler (e.g., `gfortran`)

### 🧵 Compile

```bash
gfortran -o dst_analysis dst_analysis.f90
```

### ▶️ Run

```bash
./dst_analysis
```

The program will:

**1.** Read `cities.csv`

**2.** Process each city over multiple years

**3.** Save the results to `output.csv` and `summary.csv`

---

## 📈 Use Cases

The program can be used in its current form or with minor modifications for the following purposes:

- Analyzing DST policies across countries or time zones
- Estimating seasonal variation in solar work alignment
- Urban energy planning or lighting optimization
- Scientific research in solar geometry, climatology, or human productivity

---

## 🧠 Background and Developer Note

This program was developed by **Emre Çalıova** during undergraduate studies at **Istanbul Technical University (ITU)** as part of a research project investigating the impacts of Turkey's **permanent daylight saving time (DST)** policy. This program has been updated and provided for the GitHub repository. It may differ from the program used in the research.

In 2016, Turkey adopted permanent DST to make better use of daylight throughout the year. This policy shift raised public and academic interest, particularly regarding its implications on **energy consumption**, **human circadian rhythms**, and **daily life schedules**. Accurate computation of **sunrise and sunset times** became essential for these assessments.

This program was created to support daylight saving time assessments by providing precise sun position calculations and darkness during working hours based on geographic and temporal inputs.

The solar position calculations are based on methods from:

- U.S. NOAA Solar Calculator
- Astronomical Algorithms by Jean Meeus

---

## 👨‍💻 Author

**Emre Çalıova**  
Meteorological Engineer

📧 [Mail](mailto:caliova94@gmail.com)  
🔗 [LinkedIn](https://www.linkedin.com/in/emrecaliova)  
📅 Created: 12.06.2016  
📅 Updated: 04.08.2025  (for GitHub Repository)

---

### 📄 License

This project is licensed under the MIT License.

You may use, modify, and distribute it freely. Please credit the author where appropriate.
