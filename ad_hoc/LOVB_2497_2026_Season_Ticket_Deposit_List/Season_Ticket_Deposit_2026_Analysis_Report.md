# 2026 Season Ticket Deposit Analysis

## AI Analysis Summary

**What This Script Does**: Creates comprehensive list of 2026 season ticket deposit holders with team assignments and Braze external ID integration for marketing campaigns
**Key Outputs**: Customer profiles with contact info, pro team assignments, Braze external IDs, deposit status flags
**Business Questions Answered**: 
- Who has made deposits for 2026 season tickets?
- Which pro teams do deposit holders support?
- How do we integrate deposit holders into existing marketing systems?
- What are the contact details for 2026 season ticket marketing campaigns?

**Stakeholder Use Cases**:
- Marketing: Target 2026 season ticket deposit holders with relevant campaigns
- Sales: Follow up with deposit holders for full season ticket conversion
- Customer Service: Maintain accurate customer records for deposit holders
- Analytics: Track early season ticket demand and market interest

**Adaptable Parameters**:
- Season year: Currently 2026, easily modified for other seasons
- Team mapping: Can adjust pro team assignment logic based on account types
- External ID sources: Can add/remove marketing dimension tables for ID resolution
- Customer data: Can extend with additional demographic or preference information

**Similar Request Indicators**:
- Keywords: season tickets, deposits, Braze integration, marketing lists, pro teams, customer profiles
- Business domains: marketing, sales, customer management, season ticket operations
- Data entities: deposits, season tickets, customers, teams, marketing integration

## Request Matching Guide

### Complete Match Scenarios
- Requests for season ticket deposit holder lists with marketing integration
- Customer profile creation for season ticket marketing campaigns
- Braze external ID assignment for new customer segments

### Partial Match Scenarios  
- Similar lists for other seasons or ticket types (modify source data)
- Different marketing platform integration (adjust external ID logic)
- Additional customer segmentation criteria (extend filtering)
- Different team or market focus (modify team assignment logic)

### No Match Scenarios
- This script does NOT handle: payment processing, ticket allocation, pricing analysis, renewal management

## Executive Summary

**Analysis**: LOVB-2497 - 2026 Season Ticket Deposit List Generation  
**Objective**: Create comprehensive list of 2026 season ticket deposit holders with Braze integration for marketing campaigns

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `public.archtics_2026_season_ticket_deposit` - ArchTics season ticket deposit data
- **Secondary Sources**: Multiple Braze marketing dimension tables for external ID mapping

### Data Processing Pipeline
1. **Deposit Data Processing**: Extract and parse season ticket deposit information
2. **Team Assignment**: Map account types to specific pro teams
3. **External ID Resolution**: Find existing external IDs across marketing platforms
4. **Customer Deduplication**: Rank and select best external ID per customer
5. **Final Integration**: Prepare data for Braze marketing platform

### Destination
- **Output**: 2026 season ticket deposit holder list with Braze external IDs
- **Format**: Customer profiles ready for marketing campaign integration

---

## Business Problem Solved

### Challenge
- Need comprehensive list of 2026 season ticket deposit holders
- Integrate deposit data with existing marketing database
- Maintain external ID consistency across marketing platforms
- Enable targeted marketing campaigns for deposit holders

### Solution
- Automated extraction and processing of ArchTics deposit data
- Comprehensive external ID mapping across all Braze dimensions
- Team assignment logic for targeted marketing by pro team
- Ready-to-use dataset for 2026 season marketing campaigns

---

## Technical Implementation

### Key Data Transformations

1. **Customer Data Parsing**:
   - Name splitting: `split_part(owner_name, ', ', 2/1)` for first/last names
   - Email standardization: `lower(email_addr)` for consistency
   - Account ID preservation for reference

2. **Pro Team Assignment Logic**:
   - Pattern matching on `acct_type_desc` and `group_codes`
   - Team mapping: Salt Lake City, Omaha, Madison, Houston, Austin, Atlanta
   - Default to 'UNKNOWN' for unmatched patterns

3. **External ID Resolution**:
   - UNION across multiple Braze dimension tables:
     - `dim_braze_families`
     - `dim_braze_insiders`
     - `dim_braze_season_tickets`
     - `dim_braze_single_match_tickets`
     - `dim_braze_coaches_20250505`

4. **Customer Deduplication**:
   - ROW_NUMBER() partitioned by email
   - Ordered by `last_updated DESC` for most recent external ID
   - Select top-ranked external ID per customer

5. **Final Data Assembly**:
   - COALESCE existing external ID or generate new UUID
   - Boolean flag for 2026 deposit status
   - Complete customer profile with team assignment

### Data Quality Features
- Comprehensive external ID mapping across all marketing platforms
- Email-based deduplication with recency prioritization
- Team assignment validation with fallback logic
- UUID generation for new customers

---

## Key Metrics and Outputs

### Customer Profile Data
- **External ID**: Braze marketing platform identifier
- **Contact Information**: First name, last name, email
- **Team Assignment**: Pro team based on account type/group codes
- **Deposit Status**: Boolean flag for 2026 season deposit

### Team Distribution
- **Salt Lake City**: Customers with Salt Lake account indicators
- **Omaha**: Customers with Omaha account indicators
- **Madison**: Customers with Madison account indicators
- **Houston**: Customers with Houston account indicators
- **Austin**: Customers with Austin account indicators
- **Atlanta**: Customers with Atlanta account indicators

### Business Value
- **Marketing Segmentation**: Team-based campaign targeting
- **Customer Retention**: Early identification of 2026 season interest
- **Revenue Forecasting**: Deposit holder analysis for season planning
- **Platform Integration**: Seamless Braze marketing integration

---

## Usage and Applications

### Primary Users
- Marketing teams for 2026 season campaigns
- Sales teams for season ticket conversion strategies
- Revenue teams for season planning and forecasting
- Customer service for deposit holder management

### Key Use Cases
1. **Season Marketing**: Targeted campaigns for 2026 season ticket sales
2. **Team-Specific Campaigns**: Pro team-based marketing initiatives
3. **Customer Retention**: Early engagement with committed customers
4. **Revenue Planning**: Deposit analysis for season revenue forecasting

---

## Data Sources and Dependencies

### Input Tables
- `public.archtics_2026_season_ticket_deposit`: ArchTics deposit data
- `prod_marketing.dim_braze_families`: Family marketing profiles
- `prod_marketing.dim_braze_insiders`: Insider marketing profiles
- `prod_marketing.dim_braze_season_tickets`: Season ticket holder data
- `prod_marketing.dim_braze_single_match_tickets`: Single match purchaser data
- `prod_marketing.dim_braze_coaches_20250505`: Coach information

### Key Business Rules
- Pro team assignment based on account type and group code patterns
- External ID prioritization by most recent update date
- Email-based customer deduplication
- UUID generation for customers not in existing marketing database

### Update Frequency
- One-time analysis for 2026 season deposit campaign
- Can be refreshed as new deposits are received
- Typically used for early season marketing planning

### Expected Insights
- **Deposit Volume**: Total number of 2026 season deposit holders
- **Team Distribution**: Deposit holders by pro team market
- **Customer Overlap**: Existing vs new customers in marketing database
- **Marketing Readiness**: Complete customer profiles for campaign execution
