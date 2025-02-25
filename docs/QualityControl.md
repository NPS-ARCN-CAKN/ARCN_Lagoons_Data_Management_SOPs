# Quality control

Quality control is an important step on the path to dataset certification and designation as of analytical quality. The lagoons monitoring program will follow the NPS Best Practices for Data Management principles found at <https://doimspp.sharepoint.com/sites/nps-nrss-imdiv/data-publication>.

Primary tools include:

-   **Ocular checks:** scanning the data for anomalies and logical inconsistencies.

-   **Database quality control queries:** Such queries are consistently named according to this scheme: *QC_TableName_FunctionDescription*. For example, a database query that checks for impossible pH values would be named similar to `QC_WaterQualityDiscrete_ImpossiblepHValues`. These QC queries will be developed for singular execution, or they may be wrapped multiply into a stored procedure data quality report.

-   **Data visualization:** The objective of data visualization and data quality reporting is to visually elucidate data anomalies such that they can be corrected or documented. The ARCN data manager continually develops and modifies R scripts to interrogate the values in the database with the objective of visually demonstrating data anomalies.

-   **Data quality reporting**: Similar to the R scripts above, the ARCN data manager writes data quality reports in R Markdown to communicate the quality of the data and quantifiably report data defects. These scripts will be made available in a GitHub code repository with the URL made available here.
