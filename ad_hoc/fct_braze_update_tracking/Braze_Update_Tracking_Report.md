# Braze Update Tracking Analysis

## AI Analysis Summary

**What This Script Does**: Tracks and logs updates to Braze marketing dimension tables by inserting audit records with upload dates, record counts, and table names
**Key Outputs**: Audit trail records in tracking table, data lineage documentation, update history logs
**Business Questions Answered**: 
- When were Braze marketing tables last updated?
- How many records were uploaded in each update cycle?
- What is the update frequency pattern for different marketing dimensions?
- How can we maintain data lineage for marketing data refreshes?

**Stakeholder Use Cases**:
- Data Engineering: Maintain audit trails for data pipeline operations
- Marketing Operations: Track marketing data refresh schedules and volumes
- Analytics: Understand data freshness for marketing analysis
- Compliance: Provide data lineage documentation for audit purposes

**Adaptable Parameters**:
- Table scope: Currently tracks 3 Braze tables, can extend to additional marketing tables
- Record counts: Manual entry currently, can automate with dynamic counting
- Tracking frequency: Can modify to daily, weekly, or event-driven tracking
- Additional metadata: Can add user, process, or source system information

**Similar Request Indicators**:
- Keywords: Braze, tracking, audit trail, data lineage, marketing tables, update logging
- Business domains: marketing operations, data engineering, audit compliance
- Data entities: marketing dimensions, update logs, audit trails, data lineage

## Request Matching Guide

### Complete Match Scenarios
- Requests to track updates to Braze or other marketing dimension tables
- Audit trail creation for data pipeline operations
- Data lineage documentation for marketing data refreshes

### Partial Match Scenarios  
- Similar tracking for other data systems (modify table references)
- Additional tracking metadata requirements (extend tracking schema)
- Automated tracking implementation (replace manual inserts)
- Different tracking frequencies or triggers (modify execution logic)

### No Match Scenarios
- This script does NOT handle: real-time data monitoring, data quality validation, automated data refresh processes

## Executive Summary

**Analysis**: Braze Marketing Data Update Tracking  
**Objective**: Track and log updates to Braze marketing dimension tables for data lineage and audit purposes

---

## Data Flow Overview

### Source Systems
- **Target Tables**: Braze marketing dimension tables
  - `dim_braze_insiders`
  - `dim_braze_families` 
  - `dim_braze_lovb_notes`

### Data Processing Pipeline
1. **Manual Record Insertion**: Insert tracking records for each table update
2. **Audit Trail Creation**: Log upload date, record count, and table name
3. **Data Lineage**: Maintain history of data refresh activities

### Destination
- **Output Table**: `prod_marketing.fct_braze_update_tracking`
- **Schema**: `upload_date`, `record_number`, `table_name`

---

## Business Problem Solved

### Challenge
- No visibility into when Braze marketing tables were last updated
- Difficulty tracking data refresh frequency and record counts
- Need for audit trail of marketing data updates
- Data lineage requirements for compliance and troubleshooting

### Solution
- Implemented tracking table to log all Braze table updates
- Provides timestamp and record count for each refresh
- Creates audit trail for data governance
- Enables monitoring of data pipeline health

---

## Technical Implementation

### Table Structure
```sql
CREATE TABLE prod_marketing.fct_braze_update_tracking (
    upload_date DATE NOT NULL,
    record_number INT NOT NULL,
    table_name VARCHAR(100) NOT NULL
);
```

### Data Insertion Pattern
- Manual INSERT statements after each table refresh
- Records current date, record count, and table name
- Provides snapshot of data update activity

### Sample Data Entry
- `dim_braze_insiders`: 251 records
- `dim_braze_families`: 12,606 records  
- `dim_braze_lovb_notes`: 45 records

---

## Key Metrics and Outputs

### Tracking Information
- **Upload Date**: When the table was last refreshed
- **Record Count**: Number of records in the updated table
- **Table Name**: Which Braze dimension table was updated

### Business Value
- **Data Governance**: Complete audit trail of marketing data updates
- **Pipeline Monitoring**: Track data refresh frequency and success
- **Troubleshooting**: Identify when data issues may have been introduced
- **Compliance**: Maintain data lineage for regulatory requirements

---

## Usage and Applications

### Primary Users
- Data engineering teams for pipeline monitoring
- Marketing teams to verify data freshness
- Data governance for audit and compliance
- Analytics teams for data quality assurance

### Key Use Cases
1. **Data Freshness Verification**: Check when tables were last updated
2. **Pipeline Monitoring**: Track data refresh patterns and frequency
3. **Audit Trail**: Maintain history of data changes for compliance
4. **Troubleshooting**: Identify timing of data issues or anomalies

---

## Data Sources and Dependencies

### Tracked Tables
- `prod_marketing.dim_braze_insiders`: Insider marketing profiles
- `prod_marketing.dim_braze_families`: Family marketing profiles
- `prod_marketing.dim_braze_lovb_notes`: LOVB-specific marketing notes

### Maintenance Requirements
- Manual insertion required after each table update
- Should be automated as part of data pipeline
- Regular monitoring to ensure tracking completeness

### Update Frequency
- Updated whenever source Braze tables are refreshed
- Typically daily or weekly depending on data pipeline schedule
- Critical for maintaining data lineage and audit compliance
