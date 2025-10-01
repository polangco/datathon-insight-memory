# Historical Registrations Analysis

## AI Analysis Summary

**What This Script Does**: Extracts and formats historical registration data from NetSuite for specific clubs and timeframes, creating temporary tables with formatted invoice and item details
**Key Outputs**: Two formatted tables with historical invoice data and program item details for specific clubs and date ranges
**Business Questions Answered**: 
- What are the historical registrations for specific clubs in a given timeframe?
- How do we format NetSuite data for external analysis and reporting?
- What are the complete program and package details for historical registrations?
- How do we prepare club-specific data for migration or analysis?

**Stakeholder Use Cases**:
- Analytics: Historical performance analysis and trend identification for specific clubs
- Operations: Data migration support and system integration projects
- Finance: Historical revenue tracking and registration analysis
- Reporting: Formatted data export for external reporting and compliance requirements

**Adaptable Parameters**:
- Club selection: Currently clubs 79, 76, 81, easily modified for other club combinations
- Date ranges: Currently May-December 2024, fully adjustable for any time period
- Data formatting: Can modify date formats, field selections, and output structure
- Table naming: Can customize temporary table names and destination schemas

**Similar Request Indicators**:
- Keywords: historical registrations, NetSuite data export, club-specific analysis, data formatting, temporary tables
- Business domains: data migration, historical analysis, club operations, system integration, reporting
- Data entities: registrations, clubs, invoices, items, programs, packages, historical data

## Request Matching Guide

### Complete Match Scenarios
- Requests for historical registration data export for specific clubs and periods
- NetSuite data extraction and formatting for external analysis
- Club-specific historical performance data preparation

### Partial Match Scenarios  
- Different clubs or date ranges (modify club IDs and date filters)
- Alternative data formatting requirements (adjust field selections and date formats)
- Different output destinations (modify table creation and naming logic)
- Additional data enrichment (extend joins with other program or customer data)

### No Match Scenarios
- This script does NOT handle: real-time data processing, comprehensive multi-club analysis, financial calculations, customer-level behavioral analysis

## Executive Summary

**Analysis**: LOVB-1937 - Historical NetSuite Registration Data Export  
**Objective**: Extract and format historical registration data for specific clubs from NetSuite for analysis and reporting

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `lovb_491.unified_invoices_latest` - Unified invoice data from NetSuite
- **Secondary Source**: `lovb_491.unified_programs_latest` - Program and package details

### Data Processing Pipeline
1. **Invoice Data Extraction**: Filter invoices for specific clubs and date range
2. **Program Data Integration**: Join with program details for comprehensive view
3. **Date Formatting**: Convert dates to MM/DD/YYYY format for reporting
4. **Data Export**: Create formatted tables for historical analysis

### Destination
- **Output Tables**: 
  - `lovb_491.netsuite_invoices_76_79_80_May_to_Dec_2024` - Invoice details
  - `lovb_491.netsuite_items_76_79_80_May_to_Dec_2024` - Program items
- **Format**: Formatted historical data ready for analysis

---

## Business Problem Solved

### Challenge
- Need historical registration data for specific clubs (76, 79, 81)
- Required data formatting for external analysis tools
- Integration of invoice and program data for complete picture
- Time-bound analysis for May to December 2024 period

### Solution
- Automated extraction of historical registration data
- Standardized date formatting for reporting consistency
- Comprehensive data integration across invoice and program tables
- Club-specific filtering for targeted analysis

---

## Technical Implementation

### Key Data Transformations

1. **Club and Date Filtering**:
   - Specific clubs: 76, 79, 81
   - Date range: After May 1, 2024
   - Created date filtering for relevant period

2. **Data Integration**:
   - LEFT JOIN between invoices and programs
   - COALESCE logic for handling NULL program/package IDs
   - Club ID matching for data consistency

3. **Date Formatting**:
   - TO_CHAR conversion to MM/DD/YYYY format
   - Standardized date presentation across all date fields
   - Consistent formatting for external reporting tools

4. **Amount Calculation**:
   - COALESCE logic: `amount` OR `amount_paid - amount_refunded`
   - Handles different amount calculation scenarios
   - Ensures accurate financial data representation

### Data Quality Features
- NULL handling with COALESCE functions
- Consistent club ID matching across tables
- Date validation and formatting
- Complete program detail integration

---

## Key Metrics and Outputs

### Invoice Data Table
- **Club Information**: Source system, club ID, club name
- **Invoice Details**: Invoice ID, creation date, status, notes
- **Program Information**: Item ID, name, type, start/end dates
- **Financial Data**: Budget, discount, adjustment, final amount
- **Account Details**: Billing account ID and due dates

### Program Items Table
- **Program Structure**: Program ID, name, package ID, name
- **Item Details**: Item ID, name, type, program type
- **Accounting Codes**: Account code, department code
- **Club Association**: Club ID and name for reference

### Business Value
- **Historical Analysis**: Complete registration history for target clubs
- **Financial Reporting**: Comprehensive revenue and adjustment tracking
- **Program Performance**: Item-level analysis capabilities
- **Compliance**: Formatted data for audit and reporting requirements

---

## Usage and Applications

### Primary Users
- Finance teams for historical revenue analysis
- Operations teams for club performance review
- Compliance teams for audit requirements
- Analytics teams for trend analysis

### Key Use Cases
1. **Historical Analysis**: Review registration patterns for specific clubs
2. **Financial Reporting**: Revenue and adjustment analysis by club
3. **Program Performance**: Item-level registration success metrics
4. **Compliance Reporting**: Formatted data for external requirements

---

## Data Sources and Dependencies

### Input Tables
- `lovb_491.unified_invoices_latest`: Master invoice data from NetSuite
- `lovb_491.unified_programs_latest`: Program and package configuration data

### Key Business Rules
- Club filtering: Only clubs 76, 79, 81 included
- Date range: May 1, 2024 onwards
- Amount calculation: Primary amount or calculated from payments/refunds
- Program matching: COALESCE logic for NULL ID handling

### Update Frequency
- One-time historical extraction for specified period
- Can be adapted for different clubs or date ranges
- Typically used for periodic historical analysis

### Data Quality Considerations
- Complete program detail integration via LEFT JOIN
- NULL value handling across all key fields
- Date formatting consistency for reporting
- Financial calculation accuracy with fallback logic
