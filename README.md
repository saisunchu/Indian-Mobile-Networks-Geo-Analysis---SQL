# Indian Mobile Networks Geo Analysis Using SQL  

## Overview  
This project focuses on analyzing mobile network coverage across India using SQL. The goal is to assess network distribution, identify coverage gaps, and evaluate service quality in various regions. The insights generated aim to support strategic decision-making for network expansion and optimization.  

## Objectives  
- Evaluate mobile network distribution across regions.  
- Identify gaps in network coverage.  
- Assess service quality using key metrics like call drop rates and data speeds.  
- Provide actionable insights for network optimization.  

## Tools and Technologies  
- **SQL**: Solely used for data querying, cleaning, processing, and analysis.  

## Key Features  
1. **Data Cleaning & Validation**:  
   - Standardized and validated fields like `radio` to ensure consistent data representation.  
   - Handled missing or invalid geographical coordinates by setting them to null when out of valid ranges.  
   - Trimmed unnecessary spaces and ensured proper formatting for fields such as `mcc`, `mnc`, `cid_num`, and operator names.  

2. **Deduplication**:  
   - Implemented Common Table Expressions (CTEs) to identify and remove duplicate records in datasets (`mcc404`, `mcc405`, and `mcc_mnc_list`) while retaining the most recent entries.  

3. **Data Integration**:  
   - Combined data from multiple tables (`mcc404` and `mcc405`) using UNION operations.  
   - Mapped network information with operator and circle details using LEFT JOINs for comprehensive analysis.  

4. **Network Technology Classification**:  
   - Categorized mobile network technologies (e.g., 2G, 3G, 4G, 5G) based on the `radio` field for better insights into technology distribution.  

5. **Exploratory Analysis**:  
   - Queried integrated datasets to analyze network coverage and performance metrics across regions.  

## Key Insights  
- Highlighted underserved areas with limited network coverage.  
- Identified regions with specific network technology dominance (e.g., 4G, 5G).  
- Provided actionable recommendations for network expansion and optimization.  

## Conclusion  
This project demonstrates the power of SQL for large-scale data cleaning, integration, and analysis. By transforming raw data into meaningful insights, it offers a roadmap for improving mobile network performance and meeting user demands effectively.  
