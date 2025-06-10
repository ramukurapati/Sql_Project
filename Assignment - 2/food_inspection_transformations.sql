
-- Q1. Extract year, month, and weekday from inspection_date
SELECT 
  inspection_id,
  inspection_date,
  YEAR(inspection_date) AS year,
  MONTH(inspection_date) AS month,
  DAY(inspection_date) as Day,
  DAYNAME(inspection_date) AS weekday
FROM food_inspections;

-- Q2. Create failure_flag where results = 'Fail'
SELECT *,
  CASE 
    WHEN (results) = 'fail' THEN 1 
    ELSE 0 
  END AS failure_flag
FROM food_inspections;

-- Q3. Count number of violations using dot count
SELECT 
  inspection_id,
  violations,
  LENGTH(violations) - LENGTH(REPLACE(violations, '.', '')) AS violation_count
FROM food_inspections
WHERE violations IS NOT NULL;

-- Q4. Normalize dba_name to lowercase and trimmed
SELECT 
  TRIM(LOWER(dba_name)) AS normalized_name
FROM food_inspections;

-- Q5. Flag rows with missing geolocation
SELECT *,
  CASE 
    WHEN latitude IS NULL OR longitude IS NULL THEN 1
    ELSE 0
  END AS missing_geo_flag
FROM food_inspections;

-- Q6. Convert zip to 5-digit string
SELECT 
  LPAD(zip, 5, '0') AS zip_padded
  FROM food_inspections;

-- Q7. Extract first violation code
SELECT 
  inspection_id,
  SUBSTRING_INDEX(violations, ' ', 1) AS first_violation_code
FROM food_inspections
WHERE violations IS NOT NULL;

-- Q8. Convert risk level to numeric
SELECT *,
  CASE 
    WHEN LOWER(risk) = 'low' THEN 1
    WHEN LOWER(risk) = 'medium' THEN 2
    WHEN LOWER(risk) = 'high' THEN 3
    ELSE NULL
  END AS risk_level
FROM food_inspections;

-- Q9. Flag license-based inspections
SELECT *,
  CASE 
    WHEN inspection_type LIKE '%license%' THEN 1
    ELSE 0
  END AS is_license_inspection
FROM food_inspections;

-- Q10. Flag chain facilities (appear more than once)
SELECT *,
  CASE 
    WHEN dba_name IN (
      SELECT dba_name FROM food_inspections
      GROUP BY dba_name
      HAVING COUNT(*) > 1
    )
    THEN 1 ELSE 0
  END AS is_chain
FROM food_inspections;

-- Q11. Combine city and zip into geo_bucket
SELECT 
CONCAT(LOWER(city), '-', zip) AS geo_bucket
FROM food_inspections;

-- Q12. Categorize inspections into quarters
SELECT *,
  CASE 
    WHEN MONTH(inspection_date) BETWEEN 1 AND 3 THEN 'Q1'
    WHEN MONTH(inspection_date) BETWEEN 4 AND 6 THEN 'Q2'
    WHEN MONTH(inspection_date) BETWEEN 7 AND 9 THEN 'Q3'
    ELSE 'Q4'
  END AS inspection_quarter
FROM food_inspections;

-- Q13. Remove duplicates based on inspection_id
SELECT distinct(inspection_id) 
FROM food_inspections


-- Q14. Days since last inspection (requires MySQL 8+)
SELECT DATEDIFF(inspection_date,
    LAG(inspection_date) OVER (PARTITION BY license_no ORDER BY inspection_date)
  ) AS days_since_last_inspection
FROM food_inspections;

-- Q15. Classify inspection category based on risk and result
SELECT *,
  CASE 
    WHEN results = 'fail' AND risk = 'high' THEN 'Critical Fail'
    WHEN results = 'pass' AND risk = 'low' THEN 'Safe Pass'
    ELSE 'Needs Review'
  END AS inspection_category
FROM food_inspections;
