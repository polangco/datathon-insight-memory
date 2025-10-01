# NetSuite MuleSoft Test Player Filter Analysis

## Executive Summary

**Analysis**: LOVB-2449 - NetSuite MuleSoft Test Player Filtering  
**Objective**: Filter out test accounts and player records from Sprocket invoice details while preserving legitimate customer accounts with similar names

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `public.sprocket_invoice_details` - Sprocket invoice and player details

### Data Processing Pipeline
1. **Test Account Identification**: Pattern matching for test and player accounts
2. **Exception Handling**: Preserve legitimate customers with test-like names
3. **Data Filtering**: Remove identified test accounts from production data
4. **Quality Assurance**: Ensure legitimate customers are not excluded

### Destination
- **Output**: Filtered invoice details with test accounts removed
- **Format**: Clean production data ready for NetSuite MuleSoft integration

---

## Business Problem Solved

### Challenge
- Test accounts and player records contaminating production invoice data
- Need to filter test data without excluding legitimate customers
- Specific customer families have names containing "test" but are legitimate
- Data quality requirements for NetSuite MuleSoft integration

### Solution
- Pattern-based filtering for test and player accounts
- Exception handling for legitimate customers with test-like names
- Comprehensive filtering logic with business rule exceptions
- Clean data output for production system integration

---

## Technical Implementation

### Filtering Logic

1. **Primary Filter Pattern**:
   - Pattern matching: `"player_name" || "user_name" ~* 'test|player'`
   - Case-insensitive matching for test and player keywords
   - Applied to concatenated player and user names

2. **Exception Handling**:
   - **Testa Family**: Legitimate customer family with "test" in name
   - **Testerman Family**: Valid customer family, no test account indicators
   - **Nettestad Family**: Valid customer family, no test account indicators
   - Exception pattern: `NOT "player_name" || "user_name" ~ '^Testa|^Testerman|^Nettestad'`

3. **Combined Filter Logic**:
   - Exclude records matching test/player pattern
   - BUT preserve records starting with legitimate family names
   - Ensures data quality while maintaining customer data integrity

### Data Quality Features
- Pattern-based test account identification
- Exception handling for edge cases
- Business rule validation for legitimate customers
- Comprehensive filtering without data loss

---

## Key Metrics and Outputs

### Filtering Results
- **Test Accounts Removed**: Records matching test/player patterns
- **Legitimate Customers Preserved**: Exception cases maintained
- **Data Quality**: Clean production dataset for integration
- **Coverage**: Comprehensive filtering across all invoice details

### Exception Cases Handled
- **Testa Family**: Confirmed legitimate registrations
- **Testerman Family**: Valid customer in player data
- **Nettestad Family**: Valid customer in player data
- **Pattern Validation**: Specific name-based exceptions

### Business Value
- **Data Quality**: Clean production data for NetSuite integration
- **Customer Preservation**: No legitimate customers excluded
- **System Integrity**: Reliable data for MuleSoft processing
- **Operational Efficiency**: Automated filtering with business rule compliance

---

## Usage and Applications

### Primary Users
- Data integration teams for NetSuite MuleSoft processing
- Data quality teams for production data cleanup
- Operations teams for invoice processing
- System administrators for data validation

### Key Use Cases
1. **Data Cleanup**: Remove test accounts from production invoice data
2. **Integration Preparation**: Clean data for NetSuite MuleSoft integration
3. **Quality Assurance**: Ensure legitimate customers are preserved
4. **System Validation**: Verify filtering logic effectiveness

---

## Data Sources and Dependencies

### Input Tables
- `public.sprocket_invoice_details`: Sprocket invoice and player information

### Key Business Rules
- Filter test and player accounts using pattern matching
- Preserve legitimate customers with test-like names
- Exception handling for specific known customer families
- Comprehensive coverage without data loss

### Update Frequency
- Applied during data processing for NetSuite integration
- On-demand execution for data quality validation
- Part of regular data cleanup procedures

### Filtering Methodology
- **Pattern Matching**: Case-insensitive test/player identification
- **Exception Handling**: Specific family name preservation
- **Business Rule Compliance**: Maintain legitimate customer data
- **Quality Validation**: Ensure filtering effectiveness without data loss
