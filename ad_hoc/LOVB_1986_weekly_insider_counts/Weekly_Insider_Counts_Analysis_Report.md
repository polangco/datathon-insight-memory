# Weekly Insider Counts Analysis

## AI Analysis Summary

**What This Script Does**: Tracks weekly insider registration trends, analyzes profile completion rates by registration period, and segments registrations by geographic markets for comprehensive growth monitoring
**Key Outputs**: Weekly registration counts, profile completion metrics, geographic market distribution, data quality assessments
**Business Questions Answered**: 
- How many new insiders register each week and what are the trending patterns?
- What percentage of insiders complete their profiles and which fields are most commonly missing?
- How are insider registrations distributed across different pro team markets?
- What is the data quality status of insider profiles by registration period?

**Stakeholder Use Cases**:
- Marketing: Track insider acquisition trends and campaign effectiveness
- Data Quality: Monitor profile completion rates and identify data gaps
- Business Development: Understand geographic market penetration and growth opportunities
- Operations: Resource planning based on registration volume and market distribution

**Adaptable Parameters**:
- Time aggregation: Currently weekly, can modify to daily, monthly, or custom periods
- Profile completion criteria: Can adjust required fields or completion thresholds
- Market definitions: Can modify ZIP code mappings or add new geographic segments
- Data quality metrics: Can extend with additional profile completeness measures

**Similar Request Indicators**:
- Keywords: insider registrations, weekly trends, profile completion, geographic markets, data quality, growth tracking
- Business domains: marketing analytics, data quality management, business development, growth monitoring
- Data entities: insiders, registrations, profiles, markets, trends, data completeness

## Request Matching Guide

### Complete Match Scenarios
- Requests for insider registration trend analysis with profile completion metrics
- Weekly growth tracking with geographic market segmentation
- Data quality assessment for insider profile completeness

### Partial Match Scenarios  
- Different time periods or aggregation levels (modify temporal grouping)
- Alternative profile completion criteria (adjust completeness definitions)
- Different geographic segments or market definitions (modify ZIP code mappings)
- Additional data quality dimensions (extend completeness analysis)

### No Match Scenarios
- This script does NOT handle: individual insider analysis, campaign attribution, revenue analysis, real-time registration monitoring

## Executive Summary

**Analysis**: LOVB-1986 - Weekly Insider Registration Trends and Profile Completion Analysis  
**Objective**: Track weekly insider registration patterns, profile completion rates, and geographic distribution for growth monitoring and data quality assessment

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `prod_raw.stg_insider_demographics` - Insider demographic and registration data
- **Secondary Sources**: 
  - `prod_raw.stg_braze_unsub` - Unsubscribed users for filtering
  - `public.platform_user_utm_parameters` - UTM campaign tracking
  - `prod_marketing.dim_braze_insiders` - Braze insider marketing data

### Data Processing Pipeline
1. **Weekly Registration Tracking**: Count new insider registrations by week
2. **Profile Completion Analysis**: Assess data completeness by registration period
3. **Geographic Market Analysis**: Segment registrations by pro team markets
4. **Data Quality Assessment**: Track profile completion rates and missing data
5. **Campaign Attribution**: Analyze UTM source and campaign data

### Destination
- **Output**: Weekly insider growth metrics with profile completion and geographic analysis
- **Format**: Time series data with data quality and market segmentation insights

---

## Business Problem Solved

### Challenge
- Need visibility into weekly insider acquisition trends
- Understanding profile completion rates for data quality improvement
- Geographic distribution analysis for market performance
- Campaign attribution and source tracking for marketing optimization

### Solution
- Comprehensive weekly registration tracking with trend analysis
- Profile completion rate monitoring with field-level detail
- Geographic market segmentation for targeted marketing
- UTM campaign tracking for attribution analysis

---

## Technical Implementation

### Key Analysis Components

1. **Weekly Registration Trends**:
   - Extract year and week from registration dates
   - Calculate week start dates for consistent reporting
   - Count distinct emails to prevent duplicates
   - Exclude unsubscribed users for active user tracking

2. **Profile Completion Analysis**:
   - Monthly aggregation with ROLLUP for totals
   - Complete profile definition: phone, name, birthdate, address
   - Field-level null counting for data quality insights
   - Completion percentage calculation for trend tracking

3. **Geographic Market Assignment**:
   - ZIP code pattern matching for pro team markets:
     - Atlanta: 300-312
     - Austin: 786-789
     - Houston: 770-777
     - Madison: 52-61
     - Omaha: 51-68
     - Salt Lake: 840-844
   - Non-market US and international categorization
   - Monthly and weekly period analysis

4. **Data Quality Metrics**:
   - Phone number completeness tracking
   - Name field completeness (first/last name)
   - Birthdate availability analysis
   - Geographic data completeness (ZIP/country)

### Data Quality Features
- Unsubscribed user exclusion for accurate active counts
- Distinct email counting to prevent duplicates
- Comprehensive null value tracking by field
- Geographic validation and categorization

---

## Key Metrics and Outputs

### Weekly Registration Metrics
- **Registration Year/Week**: Temporal dimensions for trend analysis
- **Week Start Date**: Consistent weekly reporting periods
- **Insider Count**: New registrations per week (distinct emails)

### Profile Completion Analysis
- **Total Insiders**: Registration volume by month
- **Complete Profiles**: Profiles with all required fields
- **Completion Percentage**: Data quality trend tracking
- **Field-Level Gaps**: Specific missing data identification

### Geographic Distribution
- **Market Segmentation**: Registrations by pro team markets
- **Period Analysis**: Monthly and weekly geographic trends
- **Market Performance**: Relative registration volume by region

### Business Value
- **Growth Tracking**: Weekly insider acquisition monitoring
- **Data Quality**: Profile completion improvement opportunities
- **Market Insights**: Geographic performance and targeting opportunities
- **Campaign Attribution**: UTM source and campaign effectiveness

---

## Usage and Applications

### Primary Users
- Marketing teams for growth tracking and campaign analysis
- Data quality teams for profile completion monitoring
- Business development for geographic market analysis
- Executive leadership for weekly growth reporting

### Key Use Cases
1. **Growth Monitoring**: Track weekly insider acquisition trends
2. **Data Quality Improvement**: Identify and address profile completion gaps
3. **Market Analysis**: Understand geographic distribution and performance
4. **Campaign Attribution**: Analyze UTM source effectiveness

---

## Data Sources and Dependencies

### Input Tables
- `prod_raw.stg_insider_demographics`: Insider registration and demographic data
- `prod_raw.stg_braze_unsub`: Unsubscribed users for filtering
- `public.platform_user_utm_parameters`: Campaign attribution data
- `prod_marketing.dim_braze_insiders`: Braze insider marketing data

### Key Business Rules
- Exclude unsubscribed users from all analyses
- Complete profile definition: phone + name + birthdate + address
- Geographic market assignment based on ZIP code patterns
- Weekly aggregation for trend analysis

### Update Frequency
- Weekly execution for current growth tracking
- Monthly for comprehensive profile completion analysis
- Quarterly for strategic market performance review

### Expected Insights
- **Growth Patterns**: Weekly registration trends and seasonality
- **Data Quality Trends**: Profile completion improvement over time
- **Market Performance**: Geographic distribution and growth opportunities
- **Campaign Effectiveness**: UTM source and campaign attribution analysis
