# Past Ticket Purchasers Analysis

## AI Analysis Summary

**What This Script Does**: Analyzes historical single ticket purchasers to create customer profiles with weekly purchase patterns across a 13-week season
**Key Outputs**: Customer contact info, weekly boolean purchase flags (week 1-13), engagement patterns
**Business Questions Answered**: 
- Who are our single ticket purchasers and their contact details?
- Which weeks did each customer purchase tickets?
- What are the repeat purchase patterns across the season?
- How can we segment customers by purchase frequency?

**Stakeholder Use Cases**:
- Marketing: Target customers based on weekly purchase history
- Sales: Identify repeat purchasers for season ticket conversion
- Analytics: Customer engagement patterns and retention analysis
- Customer Service: Complete customer purchase history

**Adaptable Parameters**:
- Date ranges: Currently analyzes full season, can be modified for specific periods
- Week definitions: Uses match week calculation, can adjust for different seasons
- Customer filters: Currently excludes unsubscribed, can modify criteria
- Geographic scope: No current filtering, can add market-specific analysis

## Executive Summary

**Analysis**: LOVB-2171 - Historical Single Ticket Purchaser Profile and Weekly Engagement Analysis  
**Objective**: Create comprehensive customer profiles for past single ticket purchasers with weekly purchase pattern analysis

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `prod_intermediate.int_single_ticket_purchase` - Single ticket purchase transaction data

### Data Processing Pipeline
1. **Customer Data Extraction**: Pull purchaser contact and demographic information
2. **Match Week Calculation**: Normalize match dates to sequential week numbers
3. **Customer Deduplication**: Rank and deduplicate customers by email
4. **Weekly Purchase Mapping**: Create boolean flags for each match week
5. **Data Integration**: Combine customer profiles with weekly purchase patterns
6. **Subscription Filtering**: Exclude unsubscribed customers

### Destination
- **Output**: Customer profiles with weekly ticket purchase engagement patterns
- **Format**: Comprehensive customer dataset with boolean weekly purchase flags

---

## Business Problem Solved

### Challenge
- Need comprehensive view of historical single ticket purchasers
- Understanding customer engagement patterns across season weeks
- Customer retention and repeat purchase analysis
- Marketing targeting for future single ticket campaigns

### Solution
- Unified customer profiles with complete contact information
- Weekly purchase pattern analysis for engagement insights
- Deduplication logic for accurate customer counting
- Subscription status filtering for marketing compliance

---

## Technical Implementation

### Key Data Transformations

1. **Customer Profile Creation**:
   - Extract complete customer contact information
   - Include demographic data (city, state)
   - Filter for customers with valid names
   - Deduplicate by email address

2. **Match Week Normalization**:
   - Calculate sequential week numbers from match dates
   - Normalize to start from week 1
   - Handle season-long weekly progression (weeks 1-13)

3. **Customer Deduplication**:
   - ROW_NUMBER() partitioned by email
   - Ordered by name, phone, and match week
   - Keep first occurrence per email address

4. **Weekly Purchase Mapping**:
   - Boolean flags for each of 13 match weeks
   - MAX aggregation to capture any purchase in each week
   - Complete weekly engagement profile per customer

5. **Subscription Compliance**:
   - Exclude customers from Braze unsubscribe list
   - Ensure marketing compliance for future campaigns

### Data Quality Features
- Name validation (non-empty first/last names)
- Email-based deduplication with ranking
- Subscription status validation
- Complete weekly purchase history

---

## Key Metrics and Outputs

### Customer Profile Data
- **Contact Information**: First name, last name, email, phone
- **Geographic Data**: City, state for demographic analysis
- **Engagement History**: Weekly purchase patterns across 13 weeks

### Weekly Engagement Analysis
- **Week 1-13 Flags**: Boolean indicators for each match week
- **Purchase Frequency**: Number of weeks with purchases per customer
- **Engagement Patterns**: Early vs late season purchase behavior
- **Repeat Customer Identification**: Multi-week purchasers

### Business Value
- **Customer Segmentation**: Identify high-engagement vs one-time purchasers
- **Marketing Targeting**: Data-driven customer targeting for campaigns
- **Retention Analysis**: Understanding repeat purchase behavior
- **Season Planning**: Weekly engagement insights for future seasons

---

## Usage and Applications

### Primary Users
- Marketing teams for customer targeting and campaigns
- Sales teams for single ticket promotion strategies
- Analytics teams for customer behavior analysis
- Customer service for account management

### Key Use Cases
1. **Customer Segmentation**: Identify high-value repeat purchasers
2. **Marketing Campaigns**: Target customers based on purchase patterns
3. **Retention Analysis**: Understand customer engagement over time
4. **Season Planning**: Optimize single ticket strategies based on weekly patterns

---

## Data Sources and Dependencies

### Input Tables
- `prod_intermediate.int_single_ticket_purchase`: Single ticket transaction data
- `prod_raw.stg_braze_unsub`: Braze unsubscribe list for compliance

### Key Business Rules
- Valid customer names required (non-empty first/last names)
- Email-based customer deduplication
- Subscription status compliance (exclude unsubscribed)
- Weekly purchase pattern tracking across 13-week season

### Update Frequency
- Seasonal analysis after each LOVB season completion
- Can be run periodically during season for mid-season insights
- Historical analysis for multi-season comparison

### Expected Insights
- **Customer Loyalty**: Identification of repeat single ticket purchasers
- **Engagement Patterns**: Weekly purchase behavior across season
- **Marketing Opportunities**: Customer segments for targeted campaigns
- **Revenue Optimization**: Understanding single ticket purchase drivers
