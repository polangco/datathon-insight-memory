# Sprocket Marketing Consent Investigation

## Executive Summary

**Analysis**: LOVB-2730 - Sprocket Marketing Consent Data Investigation  
**Objective**: Investigate and analyze marketing consent data from Sprocket pro marketing opt-in campaigns across multiple months

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `public.sprocket_pro_marketing_opt_in_june` - June 2025 marketing consent data
  - `public.sprocket_pro_marketing_opt_in_july` - July 2025 marketing consent data

### Data Processing Pipeline
1. **Multi-Month Data Integration**: Combine June and July marketing consent data
2. **Consent Analysis**: Analyze "Player Summary Info Acknowledged" responses
3. **Duplicate Detection**: Identify duplicate consent records across months
4. **Data Quality Assessment**: Investigate data consistency and completeness
5. **Temporal Analysis**: Track consent changes over time

### Destination
- **Output**: Comprehensive marketing consent analysis with data quality insights
- **Format**: Consent tracking with duplicate analysis and temporal patterns

---

## Business Problem Solved

### Challenge
- Need to understand marketing consent patterns from Sprocket pro campaigns
- Data quality concerns with potential duplicates across months
- Compliance requirements for marketing consent tracking
- Understanding customer consent behavior over time

### Solution
- Comprehensive analysis of marketing consent data across multiple months
- Duplicate detection and resolution for data quality
- Temporal analysis of consent patterns and changes
- Data quality assessment for compliance and accuracy

---

## Technical Implementation

### Key Analysis Components

1. **Multi-Month Data Integration**:
   - UNION of June and July marketing consent data
   - Date stamping with collection dates for temporal analysis
   - Consistent field mapping across months

2. **Consent Analysis**:
   - Focus on "Player Summary Info Acknowledged" field
   - Email-based customer identification
   - Consent status tracking and analysis

3. **Duplicate Detection**:
   - GROUP BY email and collected_date with HAVING count(*) > 1
   - Identification of customers with multiple consent records
   - Data quality assessment for duplicate handling

4. **Specific Case Investigation**:
   - Detailed analysis of specific email cases (e.g., 'a.rodriguez79@hotmail.com')
   - Club, registration, and user name context
   - Consent status verification for individual cases

### Data Quality Features
- Multi-month data consistency validation
- Duplicate detection and analysis
- Individual case investigation capabilities
- Temporal consent tracking

---

## Key Metrics and Outputs

### Consent Analysis Results
- **Total Consent Records**: Count across both months
- **Unique Customers**: Distinct email addresses with consent data
- **Consent Rates**: Percentage of customers acknowledging marketing info
- **Monthly Comparison**: Consent patterns between June and July

### Data Quality Assessment
- **Duplicate Records**: Customers with multiple consent entries
- **Data Consistency**: Consistency of consent responses across months
- **Completeness**: Coverage of required consent fields
- **Temporal Patterns**: Changes in consent status over time

### Compliance Insights
- **Consent Coverage**: Percentage of customers with recorded consent
- **Opt-in Rates**: Marketing consent acceptance rates
- **Data Integrity**: Quality of consent data for compliance purposes
- **Audit Trail**: Complete tracking of consent collection activities

### Business Value
- **Compliance Assurance**: Proper marketing consent tracking and documentation
- **Data Quality**: Clean, consistent consent data for marketing activities
- **Customer Insights**: Understanding customer consent behavior patterns
- **Risk Mitigation**: Proper consent documentation for regulatory compliance

---

## Usage and Applications

### Primary Users
- Compliance teams for marketing consent validation
- Marketing teams for consent-based campaign targeting
- Data quality teams for consent data integrity
- Legal teams for regulatory compliance documentation

### Key Use Cases
1. **Compliance Validation**: Ensure proper marketing consent documentation
2. **Data Quality Assessment**: Identify and resolve consent data issues
3. **Marketing Campaigns**: Target customers based on verified consent status
4. **Audit Support**: Provide consent documentation for regulatory requirements

---

## Data Sources and Dependencies

### Input Tables
- `public.sprocket_pro_marketing_opt_in_june`: June 2025 marketing consent data
- `public.sprocket_pro_marketing_opt_in_july`: July 2025 marketing consent data

### Key Business Rules
- Marketing consent must be explicitly acknowledged by customers
- Duplicate consent records require investigation and resolution
- Temporal consent tracking for compliance documentation
- Individual case investigation for data quality assurance

### Update Frequency
- Monthly analysis as new consent data becomes available
- On-demand investigation for specific consent data quality issues
- Quarterly compliance review for regulatory requirements

### Expected Insights
- **Consent Patterns**: Customer marketing consent behavior over time
- **Data Quality Issues**: Identification and resolution of consent data problems
- **Compliance Status**: Assessment of marketing consent documentation completeness
- **Process Improvement**: Opportunities to enhance consent collection and tracking
