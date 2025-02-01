# Deliverable L10: Water Quality - Discrete

## Exporting data from Deliverables L10 - Discrete water quality field data to the master database

Lagoons monitoring data are delivered to the ARCN data manager as spreadsheets or text files. These should be labeled according to the Deliverables Schedule.

### Prerequisites

-   Access to the ARCN Lagoons monitoring shared network drive (`O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems`).

### Procedure

1.  Deliverables typically arrive as a spreadsheet (workbook) with multiple worksheets, or as multiple spreadsheets. If these files have not been named correctly according to the deliverables schedule then that is the first task.

    1.  Open a file explorer and navigate to the ARCN Lagoons monitoring shared network drive (described above).

    2.  Enter the `\Data` directory

    3.  If a directory does not exist, then create it using the following example: `O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling`, replacing 2024 with the appropriate year.

    4.  Create two subdirectories:

        1.  `\Deliverables as received`

        2.  \`Deliverables processing\`

    5.  The purpose of the former directory is to store the files in their unaltered state as they were received from the contractor. The latter directory is a workbench for processing the raw deliverables into well-documented and high quality formats suitable for archivale and export into the master ARCN_Lagoons database.

    6.  Copy the raw deliverable files into the two directories created above.

    7.  Compress (zip) the files in the `\Deliverables as received` and set the attributes to ReadOnly so they may not be accidentally altered.

    8.  Begin working on the raw deliverables in the `\Deliverables processing` directory. Use the software of your choice to accomplish the following:

        1.  Lagoon names are often misspelled. Consult the database's `Lagoons` table for authoritative Lagoon names. Incorrectly named Lagoon attributes will be rejected by the database

        2.  Check for Site name inconsistencies. Consult the database's `Sites` table for authoritative Site names. Site names are often spelled differently for the same site, `AK1` vs `AK_1`, for example.

        3.  If the Lagoons and Site names are consistent with the database then the next step is to export the sampling events to the `SamplingEvents` database table.

    9.  Create a single file for each deliverable that is labeled consistently with the deliverable identifier, the year and a description of the data they contain. Example: `L10 2024 Lagoons Discrete Water Quality Data.csv` or `L12 2024 Lagoons Sampling Fish Counts.csv.`

## Example: Export Lagoons from the L to the ARCN_Lagoons database using an R script

### Isolate the lagoons, check they exist, and insert them into the Lagoons table, if necessary


``` r
# Load libraries
library(tidyverse)
```

```
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.5
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
## ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
## ✔ purrr     1.0.2     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

``` r
# Build up a path to the raw data deliverable file
dir = r'(O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/)'
SourceFilename = r'(2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx)'
Workbook = paste(dir,SourceFilename,sep="")
Worksheet = "Water Data 2024" 
wq = readxl::read_excel(Workbook,Worksheet)
wq = as.data.frame(wq)

# Extract the unique Lagoon names from the data
Lagoons = as.data.frame(wq %>% distinct(Lagoon))

# Loop through the distinct Lagoon names and write SQL queries to see if they exist and, if they don't, insert them. 
# Copy the queries into SQL Server Management Studio and execute them. 
# Any SELECT queries returning zero records indicates that the Lagoon is missinf from the Lagoons table. Insert it using the INSERT query

cat("-- Use the SELECT queries below to determine if the Lagoons in Deliverable L10 exist or not. These lagoons must exist to avoid database errors when inserting data later on. If a lagoon doesn't exist, check the spelling. If it still doesn't exist, use the relevant INSERT query to insert it.\n")
```

```
## -- Use the SELECT queries below to determine if the Lagoons in Deliverable L10 exist or not. These lagoons must exist to avoid database errors when inserting data later on. If a lagoon doesn't exist, check the spelling. If it still doesn't exist, use the relevant INSERT query to insert it.
```

``` r
for(i in 1:nrow(Lagoons)){
  Lagoon=Lagoons[i,'Lagoon']
  Sql = paste("SELECT * FROM Lagoons WHERE Lagoon='",Lagoon,"' -- INSERT INTO Lagoons(Lagoon)VALUES('",Lagoon,"')\n",sep="")
  cat(Sql)
}
```

```
## SELECT * FROM Lagoons WHERE Lagoon='Aukulak' -- INSERT INTO Lagoons(Lagoon)VALUES('Aukulak')
## SELECT * FROM Lagoons WHERE Lagoon='Krusenstern' -- INSERT INTO Lagoons(Lagoon)VALUES('Krusenstern')
## SELECT * FROM Lagoons WHERE Lagoon='Kotlik' -- INSERT INTO Lagoons(Lagoon)VALUES('Kotlik')
## SELECT * FROM Lagoons WHERE Lagoon='Tasaychek' -- INSERT INTO Lagoons(Lagoon)VALUES('Tasaychek')
## SELECT * FROM Lagoons WHERE Lagoon='Atiligauraq' -- INSERT INTO Lagoons(Lagoon)VALUES('Atiligauraq')
```

### Isolate the distinct sampling events and insert them into the SamplingEvents table


``` r
# Check that the field sites exist in the Sites database table. If the field sites do not exist in the database then those records will be rejected by the database.

# This code writes to standard output a set of SELECT queries that can be executed against the database. If any SELECT queries return zero results, then you must INSERT the site using the accompanying INSERT query.

# Get the unique lagoon/site combinations
Sites = as.data.frame(wq %>% distinct(Lagoon,Location))
for(i in 1:nrow(Sites)){
  Lagoon=Sites[i,'Lagoon']
  Site = Sites[i,'Location'] 
  
  #Build a query
  Sql = paste("SELECT * FROM Sites WHERE Lagoon='",Lagoon,"' And  Site='",Site,"'\n -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('",Lagoon,"','",Site,"','",Workbook,"')\n",sep="")
  cat(Sql)
}
```

```
## SELECT * FROM Sites WHERE Lagoon='Aukulak' And  Site='Outflow'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Aukulak','Outflow','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Aukulak' And  Site='R1'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Aukulak','R1','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Aukulak' And  Site='Center'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Aukulak','Center','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Aukulak' And  Site='R3'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Aukulak','R3','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Aukulak' And  Site='Inflow'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Aukulak','Inflow','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Aukulak' And  Site='R2'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Aukulak','R2','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Aukulak' And  Site='Marine edge'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Aukulak','Marine edge','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Krusenstern' And  Site='R1'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Krusenstern','R1','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Krusenstern' And  Site='Center'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Krusenstern','Center','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Krusenstern' And  Site='R3'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Krusenstern','R3','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Krusenstern' And  Site='R2'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Krusenstern','R2','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Krusenstern' And  Site='Outflow'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Krusenstern','Outflow','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Krusenstern' And  Site='Marine edge'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Krusenstern','Marine edge','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Kotlik' And  Site='R3'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Kotlik','R3','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Kotlik' And  Site='Inflow'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Kotlik','Inflow','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Kotlik' And  Site='Outflow'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Kotlik','Outflow','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Kotlik' And  Site='R2'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Kotlik','R2','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Kotlik' And  Site='Center'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Kotlik','Center','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Kotlik' And  Site='Marine edge'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Kotlik','Marine edge','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Kotlik' And  Site='R1'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Kotlik','R1','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Tasaychek' And  Site='Outflow'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Tasaychek','Outflow','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
## SELECT * FROM Sites WHERE Lagoon='Atiligauraq' And  Site='Outflow'
##  -- INSERT INTO Sites(Lagoon,Site,SourceFile)VALUES('Atiligauraq','Outflow','O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling\Deliverables processing/2021-2024 WCS CAKR Coastal Lagoons Data Received 2024-07-31 From KFraley Processed for DB Ingestion.xlsx')
```

``` r
# The sites should all exist now
```

### Insert the L10 Discrete Water Quality data into the database

You may modify and use the R code above to generate insert queries to insert the discrete water quality data into the database, but it may be easier to use the SQL Server Management Studio's Data Import/Export Wizard.

**Procedure**

1.  Start SQL Server Management Studio

2.  Log into the ARCN_Lagoons database

3.  Right click the database and select Tasks -\> Import data...

4.  Step through the wizard to set the source file and destination database, paying particular attention to field mappings. Use the SSMS documentation as needed to transfer the data.

## Quality control

[to be written]
