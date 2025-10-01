# Insider by Market Analysis

## AI Analysis Summary

**What This Script Does**: Analyzes insider registration patterns across geographic markets using ZIP code mapping, generating weekly trends by pro team market regions
**Key Outputs**: Weekly insider counts by market, registration trends over time, geographic distribution analysis
**Business Questions Answered**: 
- How many new insiders register each week in each pro team market?
- What are the geographic distribution patterns of insider registrations?
- Which markets show the strongest growth in insider registrations?
- How do registration patterns vary by week and market over time?

**Stakeholder Use Cases**:
- Marketing: Target market-specific campaigns and measure regional engagement
- Business Development: Identify growth opportunities in specific geographic markets
- Analytics: Track market penetration and regional performance trends
- Operations: Resource allocation and market-specific program planning

**Adaptable Parameters**:
- Market definitions: Currently 6 pro team markets, can modify ZIP code mappings
- Time aggregation: Currently weekly, can adjust to daily, monthly, or custom periods
- Geographic scope: Can extend to international markets or sub-market analysis
- Registration criteria: Can add filters for specific insider types or characteristics

**Similar Request Indicators**:
- Keywords: insiders, markets, geographic analysis, weekly trends, ZIP codes, registration patterns
- Business domains: marketing, business development, regional analysis, growth tracking
- Data entities: insiders, markets, registrations, geographic data, trends

## Request Matching Guide

### Complete Match Scenarios
- Requests for insider registration analysis by geographic markets
- Weekly trending analysis of customer acquisition by region
- Market penetration analysis for insider program growth

### Partial Match Scenarios  
- Similar analysis for other customer segments (modify source data)
- Different geographic definitions or markets (adjust ZIP code mappings)
- Alternative time periods or aggregations (modify temporal grouping)
- Additional demographic or behavioral segmentation (extend analysis criteria)

### No Match Scenarios
- This script does NOT handle: individual customer analysis, campaign attribution, revenue analysis, competitive market analysis

## Executive Summary

**Analysis**: LOVB-2504 - Insider Registration Analysis by Geographic Market  
**Objective**: Analyze insider registration patterns across different geographic markets with temporal trending

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `prod_intermediate.int_insider_profile` - Insider profile and registration data

### Data Processing Pipeline
1. **Market Assignment**: Map ZIP codes to LOVB pro team markets
2. **Temporal Extraction**: Extract year, month, and week from registration dates
3. **Geographic Categorization**: Classify insiders by market regions
4. **Aggregation**: Count new insiders by time period and market
5. **Trend Analysis**: Generate weekly registration trends by market

### Destination
- **Output**: Weekly insider registration counts by geographic market
- **Format**: Time series data with market segmentation

---

## Business Problem Solved

### Challenge
- Need visibility into insider acquisition patterns by geographic market
- Understanding which markets are driving insider growth
- Temporal analysis of registration trends for marketing planning
- Market-specific performance measurement and comparison

### Solution
- Comprehensive geographic market mapping based on ZIP codes
- Weekly trend analysis for granular insight into registration patterns
- Market segmentation enabling targeted marketing strategies
- Time-based analysis for seasonal and campaign impact assessment

---

## Technical Implementation

### Key Data Transformations

1. **Geographic Market Assignment**:
   - **Atlanta**: ZIP codes 300-312
   - **Austin**: ZIP codes 786-789
   - **Houston**: ZIP codes 770-777
   - **Madison**: ZIP codes 52-61
   - **Omaha**: ZIP codes 51-68
   - **Salt Lake**: ZIP codes 840-844
   - **Non-Market US**: Other US ZIP codes
   - **International**: Non-US countries
   - **Unknown**: Missing country information

2. **Temporal Data Extraction**:
   - Registration year, month, and week extraction
   - Week start date calculation using ISO week format
   - Chronological ordering for trend analysis

3. **Aggregation Logic**:
   - COUNT(DISTINCT email) for unique insider counting
   - GROUP BY temporal and geographic dimensions
   - Weekly granularity for detailed trend analysis

### Data Quality Features
- ZIP code pattern matching for accurate market assignment
- Country validation for geographic categorization
- Distinct email counting to prevent duplicates
- ISO week date calculation for consistent temporal analysis

---

## Key Metrics and Outputs

### Temporal Dimensions
- **Registration Year**: Annual registration patterns
- **Registration Month**: Monthly seasonality analysis
- **Registration Week**: Weekly trend granularity
- **Week Start Date**: ISO week start dates for consistent reporting

### Geographic Segmentation
- **Pro Team Markets**: Atlanta, Austin, Houston, Madison, Omaha, Salt Lake
- **Non-Market US**: US locations outside pro team markets
- **International**: Non-US registrations
- **Unknown**: Registrations with missing geographic data

### Key Performance Indicators
- **New Insiders**: Weekly count of new registrations by market
- **Market Share**: Relative registration volume by geographic region
- **Growth Trends**: Week-over-week registration patterns
- **Seasonal Patterns**: Monthly and seasonal registration cycles

### Business Value
- **Market Performance**: Understanding which markets drive insider growth
- **Marketing Optimization**: Data-driven allocation of marketing resources
- **Trend Analysis**: Identification of growth patterns and seasonality
- **Strategic Planning**: Geographic expansion and market development insights

---

## Usage and Applications

### Primary Users
- Marketing teams for market-specific campaign planning
- Business development for geographic expansion analysis
- Analytics teams for insider growth trend analysis
- Executive leadership for market performance reporting

### Key Use Cases
1. **Market Performance Analysis**: Compare insider acquisition across markets
2. **Marketing Resource Allocation**: Data-driven budget allocation by market
3. **Trend Identification**: Understand seasonal and campaign-driven patterns
4. **Strategic Planning**: Geographic expansion and market development decisions

---

## Data Sources and Dependencies

### Input Tables
- `prod_intermediate.int_insider_profile`: Insider registration and profile data

### Key Business Rules
- ZIP code-based market assignment using pattern matching
- US country validation for domestic market classification
- Distinct email counting for accurate insider metrics
- ISO week calculation for consistent temporal reporting

### Update Frequency
- Weekly execution for current trend analysis
- Monthly for comprehensive market performance review
- Quarterly for strategic planning and market assessment

### Expected Insights
- **Market Leaders**: Which geographic markets drive highest insider acquisition
- **Growth Patterns**: Weekly and seasonal registration trends
- **Market Opportunities**: Underperforming markets with growth potential
- **Campaign Impact**: Registration spikes correlated with marketing activities
