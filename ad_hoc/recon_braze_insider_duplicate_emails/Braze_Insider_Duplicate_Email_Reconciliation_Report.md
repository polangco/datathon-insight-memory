# Braze Insider Duplicate Email Reconciliation

## Executive Summary

**Analysis**: Braze Insider Duplicate Email Reconciliation and Data Quality Management  
**Objective**: Identify, rank, and remove duplicate email records in the Braze insider marketing database

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `prod_marketing.dim_braze_insiders` - Braze insider marketing dimension table

### Data Processing Pipeline
1. **Duplicate Detection**: Identify records with duplicate email addresses
2. **Quality Ranking**: Rank duplicates based on data completeness and quality
3. **Record Deactivation**: Mark lower-quality duplicates as invalid
4. **Specific Case Handling**: Handle known merge cases
5. **True Duplicate Removal**: Remove completely identical records
6. **Data Refresh**: Reload clean, deduplicated data

### Destination
- **Output**: Clean Braze insider table with deduplicated email addresses
- **Format**: Updated dimension table with improved data quality

---

## Business Problem Solved

### Challenge
- Duplicate email addresses in Braze insider marketing database
- Data quality issues affecting marketing campaign accuracy
- Need for systematic deduplication with quality preservation
- Maintenance of data integrity during cleanup process

### Solution
- Comprehensive duplicate detection and ranking system
- Quality-based record prioritization to preserve best data
- Systematic deactivation of lower-quality duplicates
- Complete removal of truly identical records
- Data integrity preservation through controlled cleanup process

---

## Technical Implementation

### Key Data Quality Processes

1. **Duplicate Detection and Ranking**:
   - Partition by email address to identify duplicates
   - Multi-criteria ranking system for quality assessment:
     - Name completeness (first_name, last_name)
     - Phone number availability
     - Newsletter role preferences (fan, coach, club, parent, player, other)
     - Team preferences (all pro teams)
     - Geographic data (home_city)

2. **Quality-Based Prioritization**:
   - ROW_NUMBER() with comprehensive ORDER BY criteria
   - NULL values ranked last (NULLS LAST)
   - Boolean preferences ranked by TRUE values first (DESC)
   - Most complete records receive rank 1 (kept)
   - Less complete records receive rank 2+ (marked invalid)

3. **Record Deactivation Process**:
   - UPDATE records with row_id = 2 (second-best duplicates)
   - Set `is_valid = FALSE` to deactivate without deletion
   - Update `last_updated = current_date` for audit trail
   - Preserve data history while removing from active use

4. **Specific Case Handling**:
   - Manual deactivation of known merged records
   - External ID-based deactivation for specific cases
   - Handles edge cases not caught by general rules

5. **True Duplicate Removal**:
   - DISTINCT selection to remove completely identical records
   - Temporary table creation for clean data
   - Table truncation and reload with deduplicated data
   - Complete removal of redundant identical records

### Data Integrity Features
- Audit trail preservation with last_updated timestamps
- Soft deletion approach (is_valid = FALSE) before hard deletion
- Temporary table validation before final data replacement
- Comprehensive ranking to preserve highest quality records

---

## Key Metrics and Outputs

### Deduplication Process Results
- **Duplicate Identification**: Records with duplicate email addresses
- **Quality Ranking**: Prioritization based on data completeness
- **Record Deactivation**: Lower-quality duplicates marked invalid
- **True Duplicate Removal**: Completely identical records eliminated

### Data Quality Improvements
- **Email Uniqueness**: One active record per email address
- **Data Completeness**: Highest quality records preserved
- **Marketing Accuracy**: Improved campaign targeting precision
- **Database Integrity**: Clean, consistent marketing data

### Business Value
- **Marketing Efficiency**: Eliminated duplicate targeting and messaging
- **Data Quality**: Improved accuracy of marketing database
- **Campaign Performance**: Better targeting through clean data
- **Operational Efficiency**: Reduced data maintenance overhead

---

## Usage and Applications

### Primary Users
- Data engineering teams for database maintenance
- Marketing teams for campaign accuracy
- Data quality teams for ongoing data hygiene
- Database administrators for system optimization

### Key Use Cases
1. **Data Quality Maintenance**: Regular deduplication of marketing database
2. **Campaign Accuracy**: Ensure customers receive single marketing messages
3. **Database Optimization**: Reduce storage and improve query performance
4. **Audit Compliance**: Maintain clean data for regulatory requirements

---

## Data Sources and Dependencies

### Input Tables
- `prod_marketing.dim_braze_insiders`: Braze insider marketing dimension table

### Key Business Rules
- Email-based duplicate detection (case-sensitive matching)
- Quality ranking prioritizes data completeness
- Soft deletion approach preserves audit trail
- True duplicates completely removed after validation

### Update Frequency
- Periodic execution for data quality maintenance
- Typically run monthly or quarterly
- On-demand execution when data quality issues identified
- Part of regular database maintenance procedures

### Data Quality Standards
- One active record per email address
- Highest quality record preserved for each email
- Audit trail maintained for deactivated records
- Complete removal only for truly identical duplicates

### Maintenance Considerations
- Regular monitoring for new duplicate creation
- Validation of deduplication results before final commit
- Backup procedures before major data cleanup operations
- Documentation of specific case handling for future reference
