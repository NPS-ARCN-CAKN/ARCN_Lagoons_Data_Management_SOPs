# Deliverables Management {#DeliverablesManagement}

Managing long-term data requires fastidious organization and archival of data products. This section covers data management procedures from field data files acceptance, through quality control and database integration.

## Prerequisites

-   Write privileges on the Lagoons monitoring shared network drive (`O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems`).

-   datawriter privileges on the lagoons monitoring master SQL Server database (currently on the ARCN development SQL Server at `inpyugamsvm01\nuna_dev:ARCN_Lagoons`).

## Procedure

Deliverables typically arrive as Comma Separated Values (CSV) text files, or Microsoft Excel workbooks). If these files have not been named correctly according to the deliverables schedule then that is the first task. The objective here is to extract data from the contractor's files into individual files of high data quality and named according to the deliverables schedule.

1.  Open a file explorer and navigate to the ARCN Lagoons monitoring shared network drive (described above).

2.  Enter the `\Data` directory

3.  If a directory does not exist, then create it using the following example: `O:\Monitoring\Vital Signs\Lagoon Communities and Ecosystems\Data\2024 Lagoons Sampling`, replacing 2024 with the appropriate year.

4.  Create two subdirectories:

    1.  `\Deliverables as received`

    2.  `\Deliverables processing`

5.  The purpose of the former directory is to store the files in their unaltered state as they were received from the contractor. The latter directory is a workbench for processing the raw deliverables into well-documented and high quality formats suitable for archivale and export into the master ARCN_Lagoons database.

6.  Duplicate the raw deliverable files into the two directories created above.

7.  Compress (zip) the files in the `\Deliverables as received` and set the attributes to ReadOnly so they may not be accidentally altered.

8.  Only work on the files in the `\Deliverables processing` directory. If mistakes are made then restore the files from the `\Deliverables as received` directory. Ideally, if your skills allow, load the data from these files into a data processing environment and only make changes and edits there, preserving the original file in an 'as received' state.

9.  Correct common errors:

    1.  Misspelled Lagoon names. Consult the database's `Lagoons` table for authoritative Lagoon names. Incorrectly named Lagoon attributes in the field data will be rejected by the database when you try to insert the records, so they must be fixed prior.

    2.  Check for Site name inconsistencies. Standard site names consist of the first three letters of the lagoon name followed by an underbar, followed by the first letter of the site type. Example: `AUK_M` represents the marine edge site type in the Aukulak lagoon. Standardized site types include:

        1.  Inlet

        2.  Outlet

        3.  Marine edge

        4.  Terrestrial edge

        5.  Random

        6.  Other site types are often included despite not being in the protocol ('Channel','Center', etc.). Determine if these sites should more properly be categorized as standardized site types or not and rename them.

        7.  Consult the database's `Sites` table for authoritative Site names. Site names are often spelled differently for the same site, `AK1` vs `AK_1`, for example.

        8.  Excel often mucks up dates in a way that won't manifest until much later in the data processing. It is therefore good to look for it ahead of time as a matter of course. You may see a date in Excel as `2017-06-21`, for example, but when you import it into other software such as R you will see an integer rather than a date. This is due to the way Excel handles dates internally. The solution is to re-label the Date column as something like ExcelDate and then create another column next to it with a formula converting the Excel date into it's text representation. Example formula that converts date values in cell A2 to a text date: `=TEXT(A2,"YYYY-MM-DD")`. These string dates usually transfer to CSV files or analytical packages correctly as a string.

        9.  Next, process each deliverable according to it's pertinent data processing chapter directives.
