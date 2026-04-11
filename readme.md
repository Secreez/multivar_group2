# README - Gruppe 2 Quarto Setup

**VSCode + Quarto:**
Quarto Extension installieren → https://quarto.org/docs/tools/vscode/index.html
Python chunks mit ````{python}` schreiben, Quarto startet Jupyter automatisch. Wenn du Python verwenden willst anstelle von R.
Dependencies ins `requirements.txt` eintragen, dann `pip install -r requirements.txt`

**Datensatz:**
Excess Mortality CSV direkt von OWID ETL:
`https://catalog.ourworldindata.org/garden/excess_mortality/latest/excess_mortality/excess_mortality.csv`
Metadaten: `https://catalog.ourworldindata.org/garden/excess_mortality/latest/excess_mortality/excess_mortality.meta.json`

Strukturelle Variablen (GDP, median_age etc.) kommen aus dem OWID compact CSV:
`https://catalog.ourworldindata.org/garden/covid/latest/compact/compact.csv`

**Was ich schon gecheckt hab:**
- 110 complete cases nach Join (excess mortality + strukturelle Variablen)
- Variablen die wir verwenden: `excess_mort` (Outcome), `gdp_per_capita`, `median_age`, `hospital_beds_per_thousand`, `life_expectancy`
- Join-Logik: nearest date zu 2023-05-05 für excess mortality, latest row pro Land für strukturelle Variablen