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
