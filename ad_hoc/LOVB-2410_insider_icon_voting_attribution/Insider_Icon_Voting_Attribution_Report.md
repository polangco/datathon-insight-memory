# Insider Icon Voting Attribution Analysis

## Executive Summary

**Analysis**: LOVB-2410 - Insider Icon Voting Attribution by Registration Period  
**Objective**: Analyze insider voting patterns in the Icon voting campaign based on registration timing to understand engagement attribution

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `public.platform_user_insider_icon_voting` - Icon voting activity data
- **Secondary Source**: `prod_intermediate.int_insider_profile` - Insider profile and registration data

### Data Processing Pipeline
1. **Voter Identification**: Extract distinct voters from voting activity
2. **Profile Matching**: Join voters with insider registration data
3. **Temporal Segmentation**: Categorize insiders by registration period
4. **Attribution Analysis**: Analyze voting patterns by registration timing

### Destination
- **Output**: Insider voting attribution analysis by registration period
- **Format**: Tabular data with voting flags and temporal segments

---

## Business Problem Solved

### Challenge
- Need to understand which insider registration periods drive higher voting engagement
- Attribution analysis for Icon voting campaign effectiveness
- Timing insights for future campaign planning
- Registration cohort performance measurement

### Solution
- Segmented insiders by registration timing relative to season and voting periods
- Created voting attribution flags for each insider
- Analyzed engagement patterns across different registration cohorts
- Provided insights for campaign timing optimization

---

## Technical Implementation

### Key Data Transformations

1. **Voter Extraction**:
   - Distinct voter emails and insider IDs from voting platform
   - Deduplication of voting records

2. **Profile Integration**:
   - LEFT JOIN to preserve all insiders (voters and non-voters)
   - Timezone conversion for registration dates (US/Central)
   - Boolean voting flag creation

3. **Temporal Segmentation**:
   - **Pre-season**: Before January 6, 2025
   - **First 4 weeks**: January 6 - February 2, 2025
   - **1 month to icon**: February 3 - March 2, 2025  
   - **Icon voting period**: March 3 - April 1, 2025
   - **Last 2 weeks**: April 2 - April 16, 2025

### Business Logic
- Registration date determines insider cohort
- Voting participation tracked as boolean flag
- Period classification enables attribution analysis

---

## Key Metrics and Outputs

### Analysis Dimensions
- **Insider ID**: Unique identifier for each insider
- **Registration Date**: When insider registered (Central Time)
- **Voted**: Boolean flag indicating voting participation
- **Period**: Registration timing classification

### Expected Insights
- **Registration Timing Impact**: Which periods drive higher voting rates
- **Campaign Attribution**: Effectiveness of different campaign phases
- **Cohort Performance**: Voting engagement by registration timing
- **Seasonal Patterns**: How registration timing affects engagement

### Business Value
- **Campaign Optimization**: Insights for future voting campaign timing
- **Registration Strategy**: Understanding optimal registration periods
- **Engagement Attribution**: Measuring campaign effectiveness by cohort
- **Marketing Planning**: Data-driven timing for future campaigns

---

## Usage and Applications

### Primary Users
- Marketing teams for campaign attribution analysis
- Product teams for engagement optimization
- Analytics teams for cohort analysis
- Leadership for campaign performance reporting

### Key Use Cases
1. **Campaign Attribution**: Measure voting engagement by registration cohort
2. **Timing Optimization**: Identify optimal registration periods for engagement
3. **Cohort Analysis**: Compare performance across registration periods
4. **Future Planning**: Data-driven insights for campaign timing

---

## Data Sources and Dependencies

### Input Tables
- `public.platform_user_insider_icon_voting`: Voting activity records
- `prod_intermediate.int_insider_profile`: Insider registration and profile data

### Key Business Rules
- Registration date determines cohort assignment
- Voting participation tracked at insider level
- Timezone standardization to US/Central
- Period boundaries aligned with campaign phases

### Update Frequency
- One-time analysis for Icon voting campaign
- Can be adapted for future voting campaigns
- Results inform future campaign timing strategies
