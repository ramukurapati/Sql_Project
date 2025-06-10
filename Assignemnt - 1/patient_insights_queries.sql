select* from patients

--  Total number of patients
SELECT COUNT(*) AS total_patients FROM patients;

-- Average age of all patients
SELECT AVG(Age) AS average_age FROM patients;

-- Minimum and maximum ages
SELECT MIN(Age) AS min_age, MAX(Age) AS max_age FROM patients;

-- Distribution across gender
SELECT Gender, COUNT(*) AS patient_count
FROM patients
GROUP BY Gender;

-- Most common medical conditions
SELECT medical_condition, COUNT(*) AS count
FROM patients
GROUP BY medical_condition
ORDER BY count DESC
LIMIT 5;

-- Patients diagnosed with each condition
SELECT medical_condition, COUNT(*) AS patient_count
FROM patients
GROUP BY medical_condition;

-- Average age for each condition
SELECT medical_condition, AVG(Age) AS average_age
FROM patients
GROUP BY medical_condition;

-- Gender distribution for each condition
SELECT medical_condition, Gender, COUNT(*) AS count
FROM patients
GROUP BY medical_condition, Gender;

-- Distribution by age group
SELECT
  CASE
    WHEN Age BETWEEN 0 AND 18 THEN '0-18'
    WHEN Age BETWEEN 19 AND 35 THEN '19-35'
    WHEN Age BETWEEN 36 AND 60 THEN '36-60'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS patient_count
FROM patients
GROUP BY age_group;

-- Most prevalent conditions in elderly (60+)
SELECT medical_condition, COUNT(*) AS count
FROM patients
WHERE Age > 60
GROUP BY medical_condition
ORDER BY count DESC
LIMIT 5;

-- Most commonly administered treatments
SELECT Medication, COUNT(*) AS count
FROM patients
GROUP BY Medication
ORDER BY count DESC
LIMIT 5;

-- Average duration of treatment for each condition
SELECT
  medical_condition,
  AVG(DATEDIFF(discharge_date, date_of_admission)) AS avg_treatment_days
FROM patients
WHERE discharge_date IS NOT NULL AND date_of_admission IS NOT NULL
GROUP BY medical_condition;

-- Success rate for each treatment
SELECT
  Medication,
  COUNT(*) AS total_treated,
  SUM(CASE WHEN test_results LIKE '%success%' THEN 1 ELSE 0 END) AS successful_treatments,
  ROUND(SUM(CASE WHEN test_results LIKE '%success%' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS success_rate_percentage
FROM patients
GROUP BY Medication;

-- Patients recovered from each condition
SELECT
  medical_condition,
  COUNT(*) AS total_patients,
  SUM(CASE WHEN test_results LIKE '%recovered%' THEN 1 ELSE 0 END) AS recovered_count
FROM patients
GROUP BY medical_condition;

-- Readmission rate per condition
SELECT medical_condition,
       COUNT(*) AS total_admissions,
       COUNT(DISTINCT Name) AS unique_patients,
       ROUND((COUNT(*) - COUNT(DISTINCT Name)) / COUNT(*) * 100, 2) AS readmission_rate_percentage
FROM patients
GROUP BY medical_condition;

-- Overall recovery rate
SELECT
  COUNT(*) AS total_patients,
  SUM(CASE WHEN test_results LIKE '%recovered%' THEN 1 ELSE 0 END) AS recovered_patients,
  ROUND(SUM(CASE WHEN test_results LIKE '%recovered%' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS recovery_rate_percentage
FROM patients;