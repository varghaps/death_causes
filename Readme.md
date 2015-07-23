## Death causes in Hungary
*by Peter Simon Vargha*

This repo includes the R files I created to download, manipulate and translate a database of causes of death in Hungary.

Original data source: [http://www.oefi.hu/halalozas/](http://www.oefi.hu/halalozas/)

The files are the following:

- deathcauses1_get_all_files.R - downloads the data and merges it into an R dataframe
- deathcauses2_manipulate_data.R - the data manipulations I did to get the final data
- deathcauses3_translate.R - translation from the Hungarian to English.
- death_codes.csv - translations are based on this code file with death causes


After running the 3 code files, the final data file (death_causes.Rda) will include the major causes of death in the last 3 years (2011-2013), by region, sex and age groups.

The final data file has the following columns:

- "death_cause" - causes of death in Hungarian
- "sex"                 
- "region"             
- "age" - age group
- "n_deaths" - the number of deaths caused by the "death_cause"
- "total_n_deaths" - total deaths in the group defined by sex, region and age
- "death_share" - n_deaths/total_n_deaths
- "death_cause_english" - causes of death in English
- "ICD.10.Codes" - codes of death causes           


See [this example](http://www.oefi.hu/halalozas/tablak/xls/y=2013&t=tenyleges&terseg=Kisterseg&tid=Budapest.xls) (in Hungarian) how the original individual regional datafiles look like.