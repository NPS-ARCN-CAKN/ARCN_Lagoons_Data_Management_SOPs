# Dataset Certification

Once data from a remeasurement cycle have been processed for quality they will be certified by the data manager on the advice of the project leader. Certification is done by setting the `CertificationLevel` attribute for the recordset to 'Certified'. A database trigger prevents altering certified records such that data consumers can be confident that the values have not changed since quality control was performed.

## 
