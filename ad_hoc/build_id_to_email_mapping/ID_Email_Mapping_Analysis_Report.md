# ID to Email Mapping Analysis

## Executive Summary

**Analysis**: Unified ID to Email Mapping Creation  
**Objective**: Build comprehensive mapping table linking LOVB family IDs, person IDs, and email addresses across multiple marketing systems

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `prod_id_graph.dim_family_all_people_details` - Master ID graph data
- **Secondary Sources**: 
  - `prod_marketing.dim_braze_insiders` - Insider marketing data
  - `prod_marketing.dim_braze_families` - Family marketing data

### Data Processing Pipeline
1. **Multi-Source Integration**: Full outer join across three data sources
2. **ID Consolidation**: Coalesce IDs and emails from all sources
3. **Deduplication**: Rank and deduplicate by email address
4. **Quality Assurance**: Validate uniqueness and identify edge cases
5. **Table Creation**: Generate final mapping table

### Destination
- **Output Table**: `prod_id_graph.id_to_email_mapping`
- **Schema**: `lovfid`, `lovpid`, `email`

---

## Business Problem Solved

### Challenge
- Multiple marketing systems contained overlapping customer data
- No unified mapping between LOVB IDs and email addresses
- Data inconsistencies across Braze insider and family datasets
- Need for single source of truth for customer identification

### Solution
- Created comprehensive ID-to-email mapping table
- Unified data from three primary sources with conflict resolution
- Implemented ranking system to handle duplicate emails
- Established data quality checks for ongoing maintenance

---

## Technical Implementation

### Key Data Transformations

1. **Multi-Source Integration**:
   ```sql
   FULL JOIN across:
   - prod_id_graph.dim_family_all_people_details
   - prod_marketing.dim_braze_insiders  
   - prod_marketing.dim_braze_families
   ```

2. **ID Coalescing Logic**:
   - `lovfid`: Family ID from any available source
   - `lovpid`: Person ID from any available source  
   - `email`: Email from any available source
   - `people_rank`: Priority ranking for conflict resolution

3. **Deduplication Strategy**:
   - ROW_NUMBER() partitioned by email
   - Ordered by people_rank, lovpid, lovfid
   - Keeps highest priority record per email

4. **Data Quality Validation**:
   - Counts distinct IDs and emails
   - Identifies non-unique person IDs
   - Validates final mapping integrity

### Data Quality Measures
- Comprehensive source integration with FULL OUTER JOIN
- Rank-based deduplication to handle conflicts
- Quality checks for uniqueness validation
- Edge case identification and resolution

---

## Key Metrics and Outputs

### Final Table Structure
- **lovfid**: LOVB Family ID (UUID)
- **lovpid**: LOVB Person ID (UUID) 
- **email**: Customer email address

### Data Quality Metrics
- Total records created
- Distinct family IDs mapped
- Distinct person IDs mapped  
- Distinct email addresses mapped
- Non-unique person ID cases identified

### Business Value
- **Unified Customer View**: Single mapping across all systems
- **Data Consistency**: Resolved conflicts between data sources
- **Marketing Efficiency**: Reliable ID-to-email mapping for campaigns
- **Analytics Foundation**: Clean data for customer analytics

---

## Usage and Applications

### Primary Users
- Marketing teams for customer targeting
- Data analytics for customer analysis
- Engineering teams for system integration
- Customer service for account lookup

### Key Use Cases
1. **Customer Identification**: Map between internal IDs and email addresses
2. **Marketing Campaigns**: Target customers across different systems
3. **Data Analytics**: Join customer data across platforms
4. **System Integration**: Standardized customer identification

---

## Data Sources and Dependencies

### Input Tables
- `prod_id_graph.dim_family_all_people_details`: Master customer ID graph
- `prod_marketing.dim_braze_insiders`: Braze insider marketing data
- `prod_marketing.dim_braze_families`: Braze family marketing data

### Key Business Rules
- Email uniqueness enforced through ranking system
- People_rank provides priority for conflict resolution
- NULL emails excluded from final mapping
- Valid records only (is_valid = true for Braze sources)

### Update Frequency
- On-demand execution when source data changes
- Typically refreshed during data pipeline updates
- Requires validation after each refresh
