# Weekly Family Insiders Pull Analysis

## Executive Summary

**Analysis**: Weekly Family and Insider Data Pull for Braze Marketing  
**Objective**: Extract incremental updates from marketing dimension tables for Braze campaign targeting and customer communication

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `prod_marketing.dim_braze_insiders` - Insider marketing profiles
  - `prod_marketing.dim_braze_families` - Family marketing profiles
  - `prod_marketing.dim_braze_lovb_notes` - LOVB player notes
  - `prod_marketing.dim_braze_season_tickets` - Season ticket holders
  - `prod_marketing.dim_braze_single_match_tickets` - Single match purchasers
  - `prod_marketing.dim_braze_first_serve` - First Serve participants

### Data Processing Pipeline
1. **Club Mapping Validation**: Check for new clubs requiring mapping
2. **Incremental Data Extraction**: Pull only updated records since last sync
3. **Multi-Source Integration**: Combine data from various marketing dimensions
4. **Deduplication Support**: Extract merge records for duplicate handling

### Destination
- **Output**: Incremental data extracts for Braze marketing platform
- **Format**: Structured datasets ready for Braze import

---

## Business Problem Solved

### Challenge
- Manual data exports were time-consuming and error-prone
- Need for incremental updates to avoid full data refreshes
- Multiple marketing data sources required coordination
- Club mapping inconsistencies across different systems

### Solution
- Automated incremental data extraction based on update timestamps
- Comprehensive club mapping validation across all source systems
- Standardized data format for Braze marketing platform
- Built-in deduplication support for data quality

---

## Technical Implementation

### Key Data Extraction Patterns

1. **Club Mapping Validation**:
   - Sprocket registration details
   - PlayMetrics subscriptions
   - LeagueApps registrations
   - Identifies unmapped clubs requiring attention

2. **Incremental Update Logic**:
   - Uses `last_updated` timestamps from tracking table
   - Extracts only records modified since last sync
   - Prevents unnecessary full data refreshes

3. **Multi-Dimensional Data Pull**:
   - **Insiders**: Profile data with newsletter preferences and team favorites
   - **Families**: Club member details with demographics
   - **LOVB Notes**: Player position and skill data
   - **Ticketing**: Season and single match purchase history
   - **Events**: First Serve participation data

### Data Quality Features
- Email subscription filtering for insiders
- Valid record filtering across all sources
- Deduplication support with merge tracking
- Club mapping consistency validation

---

## Key Metrics and Outputs

### Data Categories Extracted

1. **Insider Profiles**:
   - Contact information and preferences
   - Newsletter role classifications
   - Team favorite selections
   - Geographic data (zip, country)

2. **Family Profiles**:
   - Member demographics and contact info
   - Club associations and status
   - Family composition details
   - Geographic and lifecycle data

3. **Player Data**:
   - Position preferences and skills
   - LOVB-specific player attributes
   - Performance and development notes

4. **Engagement Data**:
   - Ticketing behavior and preferences
   - Event participation history
   - Marketing engagement metrics

### Business Value
- **Marketing Efficiency**: Targeted campaigns with fresh data
- **Customer Experience**: Personalized communications
- **Data Quality**: Consistent mapping and deduplication
- **Operational Efficiency**: Automated incremental updates

---

## Usage and Applications

### Primary Users
- Marketing teams for campaign execution
- Customer service for account management
- Data engineering for pipeline maintenance
- Analytics teams for customer insights

### Key Use Cases
1. **Marketing Campaigns**: Fresh customer data for targeting
2. **Customer Communication**: Updated contact information
3. **Segmentation**: Club, geographic, and behavioral segments
4. **Data Maintenance**: Club mapping and deduplication

---

## Data Sources and Dependencies

### Input Tables
- `prod_marketing.dim_braze_*`: All Braze marketing dimension tables
- `prod_marketing.fct_braze_update_tracking`: Update timestamp tracking
- `prod_marketing.fct_braze_duplicates`: Deduplication merge records
- Various club registration systems (Sprocket, PlayMetrics, LeagueApps)

### Key Business Rules
- Only valid and email-subscribed records included
- Incremental updates based on last sync timestamp
- Club mapping validation across all systems
- Deduplication support for data quality

### Update Frequency
- Weekly execution for regular marketing updates
- On-demand execution for campaign-specific needs
- Automated pipeline integration for operational efficiency
