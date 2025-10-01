# Camps and Clinics Base Data Analysis

## AI Analysis Summary

**What This Script Does**: Creates comprehensive base dataset for camps and clinics programs with aggregated revenue and registration metrics optimized for Metabase reporting
**Key Outputs**: Dimension table with program details, revenue totals, registration counts, club information
**Business Questions Answered**: 
- What are the revenue and registration metrics for all camps and clinics programs?
- How do camps and clinics perform across different clubs and acquisition cohorts?
- Which programs generate the most revenue and registrations?
- What is the complete program catalog for camps and clinics offerings?

**Stakeholder Use Cases**:
- Business Intelligence: Metabase dashboard creation for camps/clinics performance
- Program Management: Track program success and identify growth opportunities
- Finance: Revenue analysis and forecasting for camps and clinics
- Operations: Program portfolio management and resource allocation

**Adaptable Parameters**:
- Program types: Currently camps and clinics, can extend to other program categories
- Date ranges: Can filter by specific time periods for seasonal analysis
- Club scope: Currently all clubs, can filter for specific markets or cohorts
- Metrics: Can add additional KPIs like average revenue per registration

**Similar Request Indicators**:
- Keywords: camps, clinics, programs, revenue, registrations, Metabase, dimension table
- Business domains: program management, business intelligence, revenue analysis
- Data entities: programs, registrations, revenue, clubs, packages

## Request Matching Guide

### Complete Match Scenarios
- Requests for camps and clinics program performance data
- Metabase dimension table creation for program analysis
- Revenue and registration aggregation for specific program types

### Partial Match Scenarios  
- Similar analysis for other program types (modify program filters)
- Different aggregation levels (adjust grouping criteria)
- Additional metrics or dimensions (extend data model)
- Different reporting platforms (adapt output format)

### No Match Scenarios
- This script does NOT handle: individual registration details, customer-level analysis, real-time data, inventory management

## Executive Summary

**Analysis**: LOVB-2698 - Camps and Clinics Program Base Data Creation  
**Objective**: Create comprehensive base dataset for camps and clinics programs with revenue and registration metrics for Metabase reporting

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `prod_composable.fct_registrations` - Registration fact table with program details
- **Secondary Source**: `prod_raw.club_mapping` - Club mapping with RCL names and acquisition cohorts

### Data Processing Pipeline
1. **Club Mapping Integration**: Join registration data with club metadata
2. **Program Type Classification**: Identify camps and clinics programs
3. **Revenue Calculation**: Aggregate revenue including refunds
4. **Registration Counting**: Count unique registrations per program
5. **Data Deduplication**: Handle multiple records per program/package combination

### Destination
- **Output Table**: `prod_metabase.dim_camps_clinics` - Camps and clinics dimension table
- **Format**: Aggregated program data ready for Metabase reporting

---

## Business Problem Solved

### Challenge
- Need consolidated view of camps and clinics program performance
- Revenue tracking across different program types and clubs
- Registration volume analysis for program planning
- Metabase reporting requirements for camps and clinics analytics

### Solution
- Comprehensive camps and clinics dimension table creation
- Revenue aggregation including refund adjustments
- Program type classification with intelligent pattern matching
- Club-level performance metrics with acquisition cohort tracking

---

## Technical Implementation

### Key Data Transformations

1. **Program Type Classification**:
   - Pattern matching on program and package names
   - 'Clinic' identification: `program_name || package_name ~* 'clinic'`
   - 'Camp' identification: `program_name || package_name ~* 'Camp'`
   - Fallback to existing `program_type` for other classifications

2. **Revenue Calculation**:
   - Sum of amount and refund: `sum(COALESCE(a.amount, 0) + COALESCE(a.refund, 0))`
   - COALESCE handling for NULL values
   - Net revenue calculation including refund adjustments

3. **Registration Aggregation**:
   - COUNT(DISTINCT invoice_id) for unique registration counting
   - MAX(package_start_date) for program start date
   - GROUP BY program and package dimensions

4. **Data Deduplication**:
   - ROW_NUMBER() partitioned by club, program, and package
   - Ordered by program start date and revenue
   - Select first record (r = 1) to eliminate duplicates

### Data Quality Features
- NULL value handling with COALESCE functions
- Duplicate elimination with ranking logic
- Club mapping integration for complete metadata
- Revenue validation including refund adjustments

---

## Key Metrics and Outputs

### Program Dimensions
- **Source System**: Data source identification
- **Acquisition Cohort**: Club acquisition timing classification
- **RCL Name**: Regional Club League name
- **Club Information**: Club ID and name
- **Program Details**: Program ID, package ID, program type

### Performance Metrics
- **Program Start Date**: When the program begins
- **Number of Registrations**: Unique registration count per program
- **Revenue**: Net revenue including refund adjustments

### Business Value
- **Program Performance**: Revenue and registration metrics by program
- **Club Analysis**: Performance comparison across clubs and RCLs
- **Cohort Insights**: Analysis by acquisition cohort for strategic planning
- **Reporting Foundation**: Clean data for Metabase analytics and dashboards

---

## Usage and Applications

### Primary Users
- Operations teams for camps and clinics program management
- Finance teams for revenue analysis and forecasting
- Business intelligence teams for Metabase reporting
- Club development teams for program performance assessment

### Key Use Cases
1. **Program Performance Analysis**: Revenue and registration tracking by program
2. **Club Comparison**: Performance benchmarking across clubs and regions
3. **Financial Reporting**: Revenue analysis for camps and clinics programs
4. **Strategic Planning**: Program expansion and optimization decisions

---

## Data Sources and Dependencies

### Input Tables
- `prod_composable.fct_registrations`: Registration transactions with program details
- `prod_raw.club_mapping`: Club metadata with RCL names and acquisition cohorts

### Key Business Rules
- Program type classification based on name pattern matching
- Revenue calculation includes both amounts and refund adjustments
- Deduplication based on club, program, and package combination
- Acquisition cohort tracking for strategic analysis

### Update Frequency
- Periodic refresh for updated program and registration data
- Typically updated monthly for comprehensive program analysis
- On-demand refresh for specific reporting requirements

### Expected Insights
- **Program Popularity**: Registration volume by program type and club
- **Revenue Performance**: Financial success of camps and clinics programs
- **Club Performance**: Comparative analysis across clubs and regions
- **Cohort Analysis**: Performance patterns by acquisition cohort
