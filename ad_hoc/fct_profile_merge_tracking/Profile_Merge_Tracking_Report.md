# Profile Merge Tracking Analysis

## Executive Summary

**Analysis**: Customer Profile Merge Tracking System  
**Objective**: Track and log customer profile merges in the ID graph system for data integrity and audit purposes

---

## Data Flow Overview

### Source Systems
- **ID Graph System**: Customer identity resolution system
- **Profile Management**: Customer profile deduplication processes

### Data Processing Pipeline
1. **Merge Event Logging**: Record profile merge activities
2. **ID Relationship Tracking**: Maintain from/to ID mappings
3. **Audit Trail Creation**: Log merge dates and ID types
4. **Data Integrity**: Ensure merge history preservation

### Destination
- **Output Table**: `prod_id_graph.fct_profile_merge_tracking`
- **Schema**: `from_id`, `to_id`, `merge_date`, `id_type`

---

## Business Problem Solved

### Challenge
- Customer profiles could be duplicated across systems
- Need to track when profiles are merged or consolidated
- Data integrity requirements for customer identity resolution
- Audit trail needed for profile merge activities

### Solution
- Implemented tracking system for all profile merge events
- Maintains complete history of ID consolidation activities
- Provides audit trail for data governance and compliance
- Enables rollback capabilities if merge errors occur

---

## Technical Implementation

### Table Structure
```sql
CREATE TABLE prod_id_graph.fct_profile_merge_tracking (
    from_id UUID NOT NULL,
    to_id UUID NOT NULL,
    merge_date DATE NOT NULL,
    id_type VARCHAR(50) NOT NULL
);
```

### ID Types Tracked
- **lovpid**: LOVB Person ID merges
- **lovfid**: LOVB Family ID merges

### Sample Merge Records
- Family ID merge: `429e80b5-70b6-45ee-ba84-bd27d173e40a` → `1ed50977-ab9b-4072-bc70-07054ab2a278`
- Person ID merge: `be4c87de-a966-4506-a952-6d09e4600511` → `a6933520-ad32-455b-8f76-98f9fc475d5d`

---

## Key Metrics and Outputs

### Tracking Information
- **From ID**: Original ID being merged away
- **To ID**: Target ID that remains active
- **Merge Date**: When the merge was performed
- **ID Type**: Whether person ID (lovpid) or family ID (lovfid)

### Business Value
- **Data Integrity**: Complete audit trail of profile consolidation
- **Customer Experience**: Ensures unified customer view
- **Compliance**: Maintains data lineage for regulatory requirements
- **Troubleshooting**: Enables investigation of identity resolution issues

---

## Usage and Applications

### Primary Users
- Data engineering teams managing ID graph
- Customer service for account consolidation
- Data governance for audit and compliance
- Analytics teams for customer identity analysis

### Key Use Cases
1. **Profile Consolidation**: Track customer profile merges and deduplication
2. **Data Lineage**: Maintain history of ID changes for audit purposes
3. **Rollback Support**: Enable reversal of incorrect merges if needed
4. **Identity Resolution**: Support customer identity management processes

---

## Data Sources and Dependencies

### Input Sources
- Customer profile deduplication processes
- ID graph management system
- Manual profile merge operations

### Data Quality Considerations
- UUID validation for from_id and to_id
- Date validation for merge_date
- ID type validation (lovpid/lovfid)
- Referential integrity with ID graph tables

### Update Frequency
- Real-time insertion when profile merges occur
- Typically low volume but critical for data integrity
- Permanent retention for audit and compliance purposes

### Maintenance Requirements
- Regular validation of merge integrity
- Monitoring for orphaned IDs after merges
- Periodic audit of merge patterns and frequency
