# ID Graph People and Families Reconciliation

## AI Analysis Summary

**What This Script Does**: Reconciles and cleans ID graph data by applying specific ID merges, removing duplicates, and maintaining referential integrity across people and families tables
**Key Outputs**: Clean ID graph tables with merged IDs, removed duplicates, updated family relationships
**Business Questions Answered**: 
- How do we consolidate duplicate person and family IDs in the ID graph?
- Which records need to be merged or removed to maintain data integrity?
- How do family relationships change after ID consolidation?
- What is the impact of ID merges on downstream data systems?

**Stakeholder Use Cases**:
- Data Engineering: Maintain clean ID graph for customer 360 views
- Analytics: Ensure accurate customer counting and relationship mapping
- Marketing: Prevent duplicate communications to same individuals/families
- Operations: Support accurate customer service and account management

**Adaptable Parameters**:
- Merge rules: Currently handles specific ID mappings, can extend for additional merge scenarios
- Table scope: Currently people and families, can extend to other ID graph entities
- Validation rules: Can modify data integrity checks and cleanup criteria
- Batch processing: Can adjust for different data volumes and processing windows

**Similar Request Indicators**:
- Keywords: ID graph, reconciliation, merge, duplicate, data cleaning, referential integrity
- Business domains: data quality, customer data management, identity resolution
- Data entities: people, families, IDs, relationships, duplicates

## Request Matching Guide

### Complete Match Scenarios
- Requests to clean and reconcile ID graph data with duplicate removal
- ID merge operations across people and families tables
- Data integrity maintenance for customer identity systems

### Partial Match Scenarios  
- Similar operations for other entity types (modify table references)
- Different merge criteria or rules (adjust merge logic)
- Additional validation requirements (extend integrity checks)
- Different ID graph structures (adapt to schema changes)

### No Match Scenarios
- This script does NOT handle: real-time ID resolution, external system synchronization, complex relationship hierarchies beyond people/families

## Executive Summary

**Analysis**: ID Graph People and Families Data Reconciliation  
**Objective**: Reconcile and clean ID graph data by applying specific ID merges, removing duplicates, and maintaining data integrity across people and families tables

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `prod_id_graph.grp_people` - People ID graph data
  - `prod_id_graph.grp_families` - Families ID graph data

### Data Processing Pipeline
1. **ID Merge Application**: Apply specific person and family ID merges
2. **Orphaned Record Cleanup**: Remove records with invalid ID references
3. **Family ID Updates**: Update family IDs based on merge mappings
4. **Data Deduplication**: Remove duplicate records from both tables
5. **Data Integrity Validation**: Ensure referential integrity after cleanup

### Destination
- **Output**: Clean, reconciled ID graph tables with merged IDs and removed duplicates
- **Format**: Updated dimension tables with improved data quality

---

## Business Problem Solved

### Challenge
- Duplicate person and family IDs in the ID graph system
- Need to merge specific customer profiles identified through analysis
- Orphaned family records referencing non-existent person IDs
- Data integrity issues affecting customer identity resolution

### Solution
- Systematic application of specific ID merges based on analysis
- Comprehensive cleanup of orphaned and duplicate records
- Referential integrity maintenance between people and families
- Data quality improvement through deduplication and validation

---

## Technical Implementation

### Key Data Reconciliation Processes

1. **Person ID Merges**:
   - Specific LOVPID merges based on duplicate analysis:
     - `c994fb8a-7183-49e2-9838-e9f2b555da13` → `b9854193-9417-4840-bc0a-5fdb41ff277d`
     - `be4c87de-a966-4506-a952-6d09e4600511` → `a6933520-ad32-455b-8f76-98f9fc475d5d`
   - UPDATE statements to consolidate person records
   - DELETE statements to remove obsolete person references

2. **Family ID Merges**:
   - Specific LOVFID merges for family consolidation:
     - `429e80b5-70b6-45ee-ba84-bd27d173e40a` → `1ed50977-ab9b-4072-bc70-07054ab2a278`
     - `29d84f7b-bc85-401f-8ee9-9d6a8a91c8aa` → `011f6931-93ff-459f-b9db-b967f59d49de`
     - `08c22c08-6570-4efb-8c18-bddbbfb107a4` → `8571943f-bd36-4236-a141-cbf0baf2ed05`
   - Family relationship updates based on person ID changes

3. **Orphaned Record Cleanup**:
   - DELETE statements for family records with invalid person ID references
   - Referential integrity maintenance between people and families tables
   - Cleanup of records that no longer have valid parent relationships

4. **Data Deduplication**:
   - DISTINCT selection into temporary tables
   - Table truncation and reload with clean data
   - Complete elimination of duplicate records

### Data Integrity Features
- Specific ID merge tracking for audit purposes
- Referential integrity validation between tables
- Comprehensive deduplication process
- Data validation after cleanup operations

---

## Key Metrics and Outputs

### ID Merge Operations
- **Person ID Merges**: Specific LOVPID consolidations
- **Family ID Merges**: Specific LOVFID consolidations
- **Orphaned Record Removal**: Cleanup of invalid references
- **Duplicate Elimination**: Complete deduplication of both tables

### Data Quality Improvements
- **Referential Integrity**: Clean relationships between people and families
- **ID Consistency**: Consolidated customer identities
- **Data Accuracy**: Removal of duplicate and orphaned records
- **System Performance**: Improved query performance through cleanup

### Business Value
- **Customer Identity Resolution**: Accurate customer identification across systems
- **Data Quality**: Improved accuracy of ID graph data
- **System Performance**: Better query performance through data cleanup
- **Operational Efficiency**: Reduced confusion from duplicate customer records

---

## Usage and Applications

### Primary Users
- Data engineering teams for ID graph maintenance
- Customer service teams for accurate customer identification
- Analytics teams for customer analysis and reporting
- System administrators for database optimization

### Key Use Cases
1. **Customer Identity Resolution**: Accurate customer identification across platforms
2. **Data Quality Maintenance**: Regular cleanup of ID graph inconsistencies
3. **System Optimization**: Improved performance through data deduplication
4. **Customer Service**: Single view of customer across all touchpoints

---

## Data Sources and Dependencies

### Input Tables
- `prod_id_graph.grp_people`: People dimension in ID graph
- `prod_id_graph.grp_families`: Families dimension in ID graph

### Key Business Rules
- Specific ID merges based on duplicate analysis and business logic
- Referential integrity maintenance between people and families
- Complete deduplication to ensure data quality
- Audit trail preservation for merge operations

### Update Frequency
- One-time reconciliation for specific identified issues
- Periodic execution when new duplicates are identified
- Part of regular data quality maintenance procedures

### Data Quality Standards
- No duplicate person or family IDs after reconciliation
- Referential integrity between people and families tables
- Complete audit trail of merge operations
- Validation of data consistency after cleanup

### Maintenance Considerations
- Regular monitoring for new duplicate creation
- Validation of merge results before final commit
- Backup procedures before major reconciliation operations
- Documentation of specific merge decisions for future reference
