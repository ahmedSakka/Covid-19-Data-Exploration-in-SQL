# COVID-19 Data Analysis Project

This project focuses on analyzing COVID-19 data to gain insights into the spread of the virus, vaccination progress, and related statistics. It utilizes SQL queries to retrieve and manipulate data from the provided datasets. The project aims to provide meaningful visualizations and metrics to better understand the pandemic's impact.

## Introduction

The COVID-19 Data Analysis Project is a collection of SQL queries designed to explore various aspects of the pandemic. This includes analyzing infection rates, vaccination progress, case fatality rates, and more. The project uses provided COVID-19 and vaccination datasets to generate insights and visualizations.

## Data Sources

The project utilizes two main datasets obtained from [Our World in Data](https://ourworldindata.org/covid-deaths):
- `CovidDeaths`: Contains COVID-19 death and case data.
- `CovidVaccinations`: Contains COVID-19 vaccination data.

## Queries and Analysis

The project involves several SQL queries to extract and analyze COVID-19-related data. Key analyses include:
- Calculating case fatality rates based on specified locations.
- Determining COVID-19 prevalence rates.
- Analyzing daily global numbers of cases and deaths.
- Exploring vaccination counts per day and vaccination rates.

## Views

For easier access to certain insights, the project includes several SQL views:
- `DailyGlobalNumbers`: Provides daily totals of new cases and deaths.
- `CaseFatalityRate`: Calculates case fatality rates for different locations.
- `GlobalNumbers`: Presents death rates based on continents.
- `VaccinationCount`: Displays vaccination counts and vaccination rates.

## Usage

1. **Setup**: Ensure you have access to the provided `CovidDeaths` and `CovidVaccinations` datasets.
2. **Database Connection**: Connect to your SQL database where the datasets reside.
3. **Run Queries**: Execute the SQL queries provided in the project to perform various analyses.
4. **Interpret Results**: Interpret the results of the queries to gain insights into COVID-19 trends.

**The project was started and completed using: `SQL Server Management Studio`**
