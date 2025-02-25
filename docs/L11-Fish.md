

# Deliverable L11: Fish

## Exporting data from Deliverables L11 - Fish field data to the master database

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

    9.  Create a single file for each deliverable that is labeled consistently with the deliverable identifier, the year and a description of the data they contain. Example: `L11 2024 Lagoons Discrete Water Quality Data.csv` or `L12 2024 Lagoons Sampling Fish Counts.csv.`

2.  Remove NAs.

3.  Standardize Site names, view in GIS.

4.  Check Longitude values are negative and make sense.

5.  Check data types (glimpse(data)) are correct.

6.  Move text from numeric data columns to an equivalent column. Example: 'Count' values recorded as '\>10,000' should be moved to 'Count_Text'.

## Example: Export Lagoons from the L to the ARCN_Lagoons database using an R script

### Isolate the lagoons, check they exist, and insert them into the Lagoons table, if necessary



### Isolate the distinct sampling events and insert them into the SamplingEvents table



### Insert the L11 Discrete Water Quality data into the database

You may modify and use the R code above to generate insert queries to insert the discrete water quality data into the database, but it may be easier to use the SQL Server Management Studio's Data Import/Export Wizard.

**Procedure**

1.  Start SQL Server Management Studio

2.  Log into the ARCN_Lagoons database

3.  Right click the database and select Tasks -\> Import data...

4.  Step through the wizard to set the source file and destination database, paying particular attention to field mappings. Use the SSMS documentation as needed to transfer the data.

## Quality control

Quality control is an important step on the path to dataset certification and designation as of analytical quality. The lagoons monitoring program will follow the NPS Best Practices for Data Management principles found at <https://doimspp.sharepoint.com/sites/nps-nrss-imdiv/data-publication>.

Primary tools include:

-   **Ocular checks:** scanning the data for anomalies and logical inconsistencies.

-   **Database quality control queries:** Such queries are consistently named according to this scheme: *QC_TableName_FunctionDescription*. For example, a database query that checks for impossible pH values would be named similar to `QC_WaterQualityDiscrete_ImpossiblepHValues`. These QC queries will be developed for singular execution, or they may be wrapped multiply into a stored procedure data quality report.

-   **Data visualization:** The objective of data visualization and data quality reporting is to visually elucidate data anomalies such that they can be corrected or documented. The ARCN data manager continually develops and modifies R scripts to interrogate the values in the database with the objective of visually demonstrating data anomalies.

-   **Data quality reporting**: Similar to the R scripts above, the ARCN data manager writes data quality reports in R Markdown to communicate the quality of the data and quantifiably report data defects. These scripts will be made available in a GitHub code repository with the URL made available here.

## Certification

Once data from a remeasurement cycle have been processed for quality they will be certified by the data manager on the advice of the project leader. Certification is done by setting the `CertificationLevel` attribute for the recordset to 'Certified'. A database trigger prevents altering certified records such that data consumers can be confident that the values have not changed since quality control was performed.

## Data publication

The ARCN_Lagoons SQL Server master database will always be the authoritative repository for lagoons monitoring data. Department of Interior policy, in practice, prohibits the publication of data directly from a database. Data files containing certified data will be exported from the database to human and machine readable formats (Comma Separated Values text files, for example) and packaged together with metadata in [Ecological Metadata Language](https://nationalparkservice.github.io/NPSdataverse/) and published to the IRMA Data Store. These Data Packages will be linked as Products to the [master lagoons monitoring Project Reference](https://irma.nps.gov/DataStore/Reference/Profile/2216893).
