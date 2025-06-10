# Food Inspection SQL Transformations

This repository contains a SQL script (`food_inspection_transformations.sql`) that performs a variety of transformations and data quality checks on a `food_inspections` dataset. These transformations are designed to prepare, clean, and enrich the data for analysis and reporting.

## Table of Contents

- [Dataset Overview](#dataset-overview)
- [Transformations](#transformations)
  - [Q1: Extract Date Components](#q1-extract-date-components)
  - [Q2: Failure Flag](#q2-failure-flag)
  - [Q3: Count Number of Violations](#q3-count-number-of-violations)
  - [Q4: Normalize DBA Name](#q4-normalize-dba-name)
  - [Q5: Missing Geolocation Flag](#q5-missing-geolocation-flag)
  - [Q6: Zip Code Padding](#q6-zip-code-padding)
  - [Q7: Extract First Violation Code](#q7-extract-first-violation-code)
  - [Q8: Risk Level Encoding](#q8-risk-level-encoding)
  - [Q9: License-Based Inspection Flag](#q9-license-based-inspection-flag)
  - [Q10: Chain Facility Flag](#q10-chain-facility-flag)
  - [Q11: Geo Bucket Creation](#q11-geo-bucket-creation)
  - [Q12: Inspection Quarter](#q12-inspection-quarter)
  - [Q13: Remove Duplicates](#q13-remove-duplicates)
  - [Q14: Days Since Last Inspection](#q14-days-since-last-inspection)
  - [Q15: Inspection Category Classification](#q15-inspection-category-classification)
- [Requirements](#requirements)
- [Author](#author)

## Dataset Overview

The dataset `food_inspections` contains inspection data from food establishments, including details like inspection date, business name (`dba_name`), inspection result, risk level, violation descriptions, location coordinates, and more.

## Transformations

### Q1: Extract Date Components
Extracts year, month, day, and weekday from the `inspection_date`.

### Q2: Failure Flag
Creates a `failure_flag` column that marks inspections with the result 'Fail' as 1, otherwise 0.

### Q3: Count Number of Violations
Counts the number of individual violations by counting the number of periods (`.`) in the `violations` text.

### Q4: Normalize DBA Name
Converts the `dba_name` to lowercase and trims whitespace to standardize the business names.

### Q5: Missing Geolocation Flag
Flags rows where either `latitude` or `longitude` is missing.

### Q6: Zip Code Padding
Ensures that the `zip` field is a 5-digit string, padding with leading zeros if necessary.

### Q7: Extract First Violation Code
Parses the first violation code from the `violations` text using space as the delimiter.

### Q8: Risk Level Encoding
Converts the textual `risk` field into a numeric value: Low → 1, Medium → 2, High → 3.

### Q9: License-Based Inspection Flag
Flags inspections that are related to a license by checking if `inspection_type` contains the word "license".

### Q10: Chain Facility Flag
Identifies chain facilities by flagging business names that appear more than once in the dataset.

### Q11: Geo Bucket Creation
Combines `city` and `zip` into a single geographic identifier called `geo_bucket`.

### Q12: Inspection Quarter
Categorizes inspections into calendar quarters based on the `inspection_date`.

### Q13: Remove Duplicates
Removes duplicate entries based on `inspection_id`.

### Q14: Days Since Last Inspection
Calculates the number of days since the last inspection for the same license number. Requires MySQL 8+ (uses `LAG()` function).

### Q15: Inspection Category Classification
Creates a new field `inspection_category` that classifies inspections into:
- `Critical Fail` for high-risk failed inspections,
- `Safe Pass` for low-risk passed inspections,
- `Needs Review` for all others.

## Requirements

- MySQL 8+ (required for window functions in Q14)
- A database with the `food_inspections` table containing:
  - `inspection_id`, `inspection_date`, `dba_name`, `results`, `violations`, `latitude`, `longitude`, `zip`, `risk`, `inspection_type`, `city`, `license_no`

## Author

*Your Name Here*  
SQL Data Transformation Assignment  
Rivier University  
