# AR Aging with Billing Account Details Analysis

## AI Analysis Summary

**What This Script Does**: Generates comprehensive AR aging report by joining aging data with unified customer details to provide complete view of outstanding invoices with customer contact information
**Key Outputs**: Enriched AR aging report with customer names, emails, phone numbers, and complete invoice details
**Business Questions Answered**: 
- Which customers have outstanding invoices and what are their contact details?
- How can we improve collections by having complete customer information?
- What is the aging status of invoices with full customer context?
- How do we enable better customer service for billing inquiries?

**Stakeholder Use Cases**:
- Finance: Enhanced collections process with customer contact information
- Customer Service: Complete customer context for billing inquiries and support
- Operations: Streamlined billing account management and follow-up processes
- Analytics: Customer payment behavior analysis with demographic context

**Adaptable Parameters**:
- Time periods: Currently uses all historical AR data, can filter for specific aging periods
- Customer data: Can extend with additional customer attributes or preferences
- Aging criteria: Can modify aging buckets or outstanding balance thresholds
- Output format: Can adjust sorting, grouping, or export formatting

**Similar Request Indicators**:
- Keywords: AR aging, accounts receivable, customer details, billing accounts, collections, outstanding invoices
- Business domains: finance, collections, customer service, billing operations, account management
- Data entities: invoices, customers, billing accounts, aging data, contact information

## Request Matching Guide

### Complete Match Scenarios
- Requests for AR aging reports with customer contact information
- Collections-focused reporting with customer details for follow-up
- Billing account analysis with customer demographic context

### Partial Match Scenarios  
- Different aging criteria or time periods (modify aging filters)
- Additional customer attributes or segmentation (extend customer data joins)
- Alternative output formats or sorting (adjust final query structure)
- Different customer data sources (modify unified customer table references)

### No Match Scenarios
- This script does NOT handle: payment processing, automated collections, customer communication, real-time aging updates

## Executive Summary

**Analysis**: Accounts Receivable Aging Report with Customer Details  
**Objective**: Generate comprehensive AR aging report enriched with customer billing account information for improved collections and customer service

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `metabase.ar_aging` - Core AR aging data
- **Secondary Source**: `lovb_491.unified_customers_latest` - Customer billing account details

### Data Processing Pipeline
1. **AR Aging Data Extraction**: Pull historical AR aging records
2. **Customer Data Aggregation**: Consolidate customer details by billing account
3. **Data Enrichment**: Join AR data with customer contact information
4. **Final Output**: Comprehensive aging report with customer details

### Destination
- **Output**: Enriched AR aging report with customer contact information
- **Format**: Tabular data sorted by creation date and invoice ID

---

## Business Problem Solved

### Challenge
- AR aging reports lacked customer contact information
- Collections teams needed customer details (name, email, phone) for follow-up
- Billing account information was stored separately from aging data

### Solution
- Unified AR aging data with customer billing account details
- Provided single view of outstanding receivables with customer contact info
- Enabled efficient collections workflow with complete customer information

---

## Technical Implementation

### Key Data Transformations
1. **Customer Data Deduplication**: 
   - Groups by `source_system` and `billing_account_id`
   - Takes MAX values for customer details to handle duplicates

2. **Data Integration**:
   - Left joins AR aging with customer details
   - Preserves all AR records even without customer matches

3. **Output Sorting**:
   - Ordered by creation date (descending) and invoice ID
   - Most recent invoices appear first

### Data Quality Considerations
- Handles missing customer data gracefully with LEFT JOIN
- Deduplicates customer records to ensure one record per billing account
- Maintains referential integrity between AR and customer data

---

## Key Metrics and Outputs

### Report Columns
- **Financial Data**: Amount, owing, days to due date, invoice status
- **Customer Details**: First name, last name, email, phone number
- **Account Information**: Billing account ID, source system
- **Program Details**: Item name, type, package dates
- **Collections Info**: Standing flag, standing description

### Business Value
- **Improved Collections**: Direct access to customer contact information
- **Enhanced Customer Service**: Complete view of customer account status
- **Operational Efficiency**: Single report for AR and customer data needs

---

## Usage and Applications

### Primary Users
- Collections teams for follow-up on overdue accounts
- Customer service for account inquiries
- Finance teams for AR analysis and reporting

### Key Use Cases
1. **Collections Workflow**: Identify overdue accounts with contact details
2. **Customer Communication**: Direct access to customer contact information
3. **Account Analysis**: Comprehensive view of customer payment patterns
4. **Reporting**: Unified AR reporting with customer context

---

## Data Sources and Dependencies

### Input Tables
- `metabase.ar_aging`: Core AR aging data with invoice and payment details
- `lovb_491.unified_customers_latest`: Customer billing account information

### Key Fields
- **Join Keys**: `source_system`, `billing_account_id`
- **Customer Data**: `first_name`, `last_name`, `email`, `phone_number`
- **Financial Data**: `amount`, `owing`, `days_to_due_date`, `invoice_status`

### Update Frequency
- On-demand execution for current AR aging analysis
- Typically run monthly or as needed for collections activities
