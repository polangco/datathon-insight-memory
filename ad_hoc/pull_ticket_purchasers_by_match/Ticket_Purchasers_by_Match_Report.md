# Ticket Purchasers by Match Analysis

## Executive Summary

**Analysis**: Ticket Purchasers by Match - Incremental Braze Integration  
**Objective**: Extract and integrate new/updated single ticket purchasers into Braze marketing platform with match-specific purchase tracking

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `prod_marketing.dim_braze_single_ticket_purchase` - Single ticket purchase dimension
- **Secondary Sources**: 
  - `prod_marketing.fct_braze_update_tracking` - Update tracking for incremental processing
  - `public.archtics_event_data` - Event and match scheduling data

### Data Processing Pipeline
1. **Incremental Data Identification**: Find new/updated records since last Braze upload
2. **Match-Specific Data Extraction**: Pull customer data with match-specific purchase flags
3. **Braze Integration Preparation**: Format data for Braze platform import
4. **Tracking Update**: Log successful data extraction for future incremental processing
5. **Event Schedule Analysis**: Provide match scheduling context for campaign planning

### Destination
- **Output**: CSV export ready for Braze UI upload
- **Format**: Customer profiles with match-specific boolean purchase flags

---

## Business Problem Solved

### Challenge
- Need incremental updates to Braze for new ticket purchasers
- Match-specific purchase tracking for targeted marketing campaigns
- Efficient data processing to avoid full data refreshes
- Campaign timing coordination with match schedules

### Solution
- Automated incremental data extraction based on last upload timestamp
- Comprehensive match-specific purchase flag system
- Ready-to-import CSV format for Braze platform integration
- Event schedule analysis for campaign planning support

---

## Technical Implementation

### Key Data Processing Components

1. **Incremental Processing Logic**:
   - Query last upload date from tracking table
   - Filter for records modified since last upload
   - Ensure only new/changed data is processed

2. **Match-Specific Purchase Flags**:
   - **Atlanta Matches**: ATL01-ATL06 boolean flags
   - **Austin Matches**: AUSH01-AUSH04 boolean flags
   - **Classic Events**: CLASSIC01-CLASSIC04 boolean flags
   - **Houston Matches**: HOU01-HOU06 including combined events
   - **Madison Matches**: MADA01-MADA04 including combined events
   - **Omaha Matches**: OMAB01-OMAB02 including combined events
   - **Salt Lake Matches**: SALB01-SALB04, SALM01-SALM02 including combined events
   - **Finals**: FINALS01-FINALS04 boolean flags

3. **Tracking System Integration**:
   - Automatic tracking table update after successful extraction
   - Record count and timestamp logging for audit trail
   - Enables reliable incremental processing

4. **Event Schedule Context**:
   - Match scheduling by week for campaign timing
   - Event name and team mapping for context
   - Filtering out test events and non-standard matches

### Data Quality Features
- Incremental processing prevents duplicate data uploads
- Comprehensive match coverage across all pro teams
- Automatic tracking for reliable data lineage
- Event filtering for clean match data

---

## Key Metrics and Outputs

### Customer Data Export
- **External ID**: Braze platform customer identifier
- **Email**: Customer contact information
- **Match Purchase Flags**: Boolean indicators for each specific match

### Match Coverage
- **Pro Team Markets**: Atlanta, Austin, Houston, Madison, Omaha, Salt Lake
- **Special Events**: Classic tournaments and Finals
- **Combined Events**: Multi-match packages and doubleheaders
- **Season Coverage**: Complete match schedule tracking

### Incremental Processing Metrics
- **Records Processed**: Count of new/updated customers
- **Last Upload Date**: Timestamp of previous data extraction
- **Processing Frequency**: Incremental update capability

### Business Value
- **Marketing Efficiency**: Targeted campaigns based on specific match attendance
- **Customer Engagement**: Match-specific follow-up and retention campaigns
- **Data Freshness**: Regular updates ensure current customer data
- **Campaign Timing**: Event schedule integration for optimal campaign timing

---

## Usage and Applications

### Primary Users
- Marketing teams for match-specific campaign targeting
- Customer engagement teams for post-match follow-up
- Data integration teams for Braze platform management
- Campaign managers for event-based marketing

### Key Use Cases
1. **Post-Match Marketing**: Immediate follow-up campaigns for match attendees
2. **Season Campaigns**: Target customers based on specific match attendance
3. **Cross-Sell Opportunities**: Promote other matches to existing attendees
4. **Customer Retention**: Engagement campaigns for repeat attendees

---

## Data Sources and Dependencies

### Input Tables
- `prod_marketing.dim_braze_single_ticket_purchase`: Single ticket purchase data
- `prod_marketing.fct_braze_update_tracking`: Data upload tracking
- `public.archtics_event_data`: Event and match scheduling information

### Key Business Rules
- Incremental processing based on last_modified timestamps
- Match-specific boolean flags for targeted marketing
- Automatic tracking table updates for data lineage
- Event filtering to exclude test and non-standard matches

### Update Frequency
- On-demand execution for immediate Braze integration
- Typically run after major match events or ticket sales periods
- Incremental processing enables frequent updates without performance impact

### Integration Requirements
- CSV export format compatible with Braze UI upload
- Boolean flag system for match-specific targeting
- External ID consistency with existing Braze customer data
- Tracking system integration for reliable incremental processing
