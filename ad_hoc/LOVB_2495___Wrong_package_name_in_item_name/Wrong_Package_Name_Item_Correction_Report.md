# Wrong Package Name in Item Name Correction

## AI Analysis Summary

**What This Script Does**: Identifies and corrects instances where package names are incorrectly embedded in item names, ensuring accurate program and package information display
**Key Outputs**: Corrected item names, proper program/package separation, updated invoice records with accurate details
**Business Questions Answered**: 
- Which invoice items have incorrect package names embedded in item names?
- What are the correct program and package names for affected items?
- How do we fix data display issues in billing and reporting systems?
- What is the historical timeline of program/package name changes?

**Stakeholder Use Cases**:
- Data Quality: Ensure accurate item naming conventions across systems
- Finance: Correct billing information and invoice accuracy
- Operations: Maintain consistent program and package naming standards
- Reporting: Ensure accurate program performance analysis

**Adaptable Parameters**:
- Item identification: Currently uses regex patterns, can modify for different naming issues
- Data sources: Currently PlayMetrics and NetSuite, can extend to other systems
- Correction rules: Can customize program/package name formatting standards
- Time periods: Can focus on specific date ranges for targeted corrections

**Similar Request Indicators**:
- Keywords: item names, package names, program names, data correction, naming conventions
- Business domains: data quality, billing accuracy, system integration
- Data entities: items, programs, packages, invoices, naming standards

## Request Matching Guide

### Complete Match Scenarios
- Requests to fix incorrect item naming with embedded package information
- Data quality corrections for program/package name display
- Invoice item name standardization and correction

### Partial Match Scenarios  
- Similar naming issues in other systems (modify source tables)
- Different naming convention problems (adjust correction logic)
- Additional data quality rules (extend validation criteria)
- Different time periods or item scopes (modify filters)

### No Match Scenarios
- This script does NOT handle: pricing corrections, inventory management, customer-facing display issues, real-time name validation

## Executive Summary

**Analysis**: LOVB-2495 - Package Name Correction in Item Names  
**Objective**: Identify and correct instances where package names are incorrectly displayed in item names, ensuring accurate program and package information

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `public.playmetrics_all_programs` - PlayMetrics program and package data
  - `lovb_491.netsuite_invoices_april_2025` - NetSuite invoice data with incorrect item names

### Data Processing Pipeline
1. **Issue Identification**: Identify invoices with incorrect package names in item names
2. **Historical Data Analysis**: Analyze program/package ID history for correct information
3. **Correct Data Retrieval**: Extract accurate program and package names from source
4. **Item Name Correction**: Generate corrected item names with proper formatting
5. **Update Application**: Apply corrections to affected invoice records

### Destination
- **Output**: Corrected invoice records with accurate item names and program details
- **Format**: Updated invoice data with proper program/package name formatting

---

## Business Problem Solved

### Challenge
- Incorrect package names appearing in item names causing confusion
- Historical data inconsistencies with multiple versions of same program/package
- Need to maintain accurate program and package information for billing
- Customer-facing item names must reflect correct program details

### Solution
- Systematic identification and correction of incorrect item names
- Historical data analysis to find most accurate program information
- Automated correction process with proper name formatting
- Data quality improvement for customer-facing information

---

## Technical Implementation

### Key Data Correction Processes

1. **Issue Identification**:
   - Pattern matching to identify problematic item names
   - Specific case: `'5/4/2025 2pm-3:30pm 13s/14s Open Gym'`
   - Filter invoices with incorrect package name patterns

2. **Historical Data Analysis**:
   - ROW_NUMBER() ranking by `last_modified` date
   - Partition by program_id, program_name, package_id, package_name
   - Select earliest valid record (row_id = 1) for consistency

3. **ID Extraction and Mapping**:
   - Parse item_id to extract program_id and package_id
   - SPLIT_PART function to separate compound IDs
   - Map extracted IDs to correct program information

4. **Correct Data Retrieval**:
   - Join with PlayMetrics program data for accurate information
   - Extract correct program and package names
   - Retrieve proper accounting codes and program types
   - Format dates consistently for program start/end

5. **Item Name Correction**:
   - Generate corrected item names: `program_name || '|' || package_name`
   - Ensure consistent formatting across all corrected items
   - Maintain proper program hierarchy and naming conventions

### Data Quality Features
- Historical data validation with ranking logic
- Comprehensive program information retrieval
- Consistent item name formatting standards
- Accounting code validation and correction

---

## Key Metrics and Outputs

### Correction Process Results
- **Affected Invoices**: Invoices with incorrect item names identified
- **Program/Package Mapping**: Correct program and package information retrieved
- **Item Name Updates**: Properly formatted item names generated
- **Data Consistency**: Historical data inconsistencies resolved

### Corrected Data Elements
- **Item Names**: Proper program_name|package_name formatting
- **Program Details**: Accurate program and package information
- **Accounting Codes**: Correct account and department codes
- **Date Information**: Properly formatted program start/end dates

### Business Value
- **Customer Experience**: Accurate item names on invoices and statements
- **Data Quality**: Consistent program and package information
- **Billing Accuracy**: Correct item descriptions for financial records
- **Operational Efficiency**: Reduced confusion from incorrect item names

---

## Usage and Applications

### Primary Users
- Data quality teams for item name correction
- Billing teams for invoice accuracy
- Customer service teams for customer inquiries
- Operations teams for program management

### Key Use Cases
1. **Data Correction**: Fix incorrect item names in billing systems
2. **Quality Assurance**: Ensure consistent item name formatting
3. **Customer Service**: Provide accurate program information to customers
4. **Billing Accuracy**: Maintain correct item descriptions on invoices

---

## Data Sources and Dependencies

### Input Tables
- `public.playmetrics_all_programs`: Program and package master data
- `lovb_491.netsuite_invoices_april_2025`: Invoice data with incorrect item names

### Key Business Rules
- Item name format: `program_name || '|' || package_name`
- Historical data prioritization by earliest `last_modified` date
- Program/package ID extraction from compound item IDs
- Accounting code consistency with program types

### Update Frequency
- On-demand execution when incorrect item names are identified
- Periodic data quality checks for item name consistency
- Part of regular data validation and correction procedures

### Data Quality Standards
- Consistent item name formatting across all systems
- Accurate program and package information in all records
- Proper accounting code assignment by program type
- Historical data consistency and validation

### Correction Methodology
- **Issue Detection**: Pattern matching for incorrect item names
- **Data Validation**: Historical analysis for most accurate information
- **Systematic Correction**: Automated correction with proper formatting
- **Quality Assurance**: Validation of corrected data before application
