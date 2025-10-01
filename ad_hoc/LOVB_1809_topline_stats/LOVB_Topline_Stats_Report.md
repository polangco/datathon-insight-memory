# LOVB Topline Statistics Analysis

## AI Analysis Summary

**What This Script Does**: Generates high-level metrics and counts across key marketing dimensions including families, insiders, and team preferences for executive reporting and data validation
**Key Outputs**: Statistical summary tables, count metrics, team preference distributions, cross-system validation results
**Business Questions Answered**: 
- What are the current counts of active families and insiders in our marketing database?
- How do counts compare across different data sources and systems?
- What are the team preference distributions among our customer base?
- Are there data consistency issues between marketing dimensions and ID graph?

**Stakeholder Use Cases**:
- Executive Reporting: High-level KPIs and customer base metrics
- Data Validation: Cross-system count reconciliation and data quality checks
- Marketing Strategy: Customer segmentation and team preference insights
- Operations: Database health monitoring and growth tracking

**Adaptable Parameters**:
- Metric scope: Currently families and insiders, can extend to other customer segments
- Data sources: Can add additional marketing dimensions or external systems
- Validation rules: Can modify cross-system comparison criteria
- Time periods: Can add historical trending and period-over-period analysis

**Similar Request Indicators**:
- Keywords: topline stats, executive metrics, customer counts, data validation, marketing database
- Business domains: executive reporting, data validation, marketing analytics
- Data entities: families, insiders, customers, metrics, counts

## Request Matching Guide

### Complete Match Scenarios
- Requests for high-level customer metrics and database statistics
- Executive reporting dashboards with topline KPIs
- Data validation and cross-system count reconciliation

### Partial Match Scenarios  
- Similar metrics for different customer segments (modify dimension queries)
- Additional data sources or validation checks (extend analysis scope)
- Different aggregation levels or breakdowns (adjust grouping criteria)
- Historical trending or comparative analysis (add time dimensions)

### No Match Scenarios
- This script does NOT handle: detailed customer analysis, campaign performance, revenue metrics, individual customer profiles

## Executive Summary

**Analysis**: LOVB Marketing Database Topline Statistics  
**Objective**: Generate high-level metrics and counts across key marketing dimensions for executive reporting and data validation

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `prod_marketing.dim_braze_families` - Family marketing profiles
  - `prod_marketing.dim_braze_insiders` - Insider marketing profiles  
  - `prod_id_graph.dim_family_all_people_details` - Master ID graph

### Data Processing Pipeline
1. **Family Statistics**: Count active families and rostered families
2. **Insider Statistics**: Count valid insiders and overlap analysis
3. **Team Preference Analysis**: Aggregate favorite team selections
4. **Cross-System Validation**: Compare counts across different data sources

### Destination
- **Output**: Statistical summary tables for executive reporting
- **Format**: Aggregated counts and metrics

---

## Business Problem Solved

### Challenge
- Need for high-level marketing database health metrics
- Executive reporting requirements for customer base size
- Data validation across multiple marketing systems
- Team preference insights for marketing strategy

### Solution
- Automated topline statistics generation
- Cross-system data validation and reconciliation
- Team preference analytics for marketing targeting
- Executive-ready metrics for business reporting

---

## Technical Implementation

### Key Metrics Generated

1. **Family Database Metrics**:
   - Total valid families in Braze
   - Active vs inactive family status breakdown
   - Rostered families for current season

2. **Insider Database Metrics**:
   - Total valid insiders in Braze
   - Insider overlap with ID graph system
   - Email validation and deduplication

3. **Team Preference Analysis**:
   - Favorite team selections by market:
     - Atlanta
     - Austin  
     - Houston
     - Madison
     - Omaha
     - Salt Lake

4. **Cross-System Validation**:
   - ID graph vs Braze family comparison
   - Person type breakdown in ID graph
   - Data consistency checks

---

## Key Metrics and Outputs

### Family Statistics
- Total families: Count and distinct email validation
- Active status breakdown by family status
- Season roster participation metrics
- Person type distribution (parents, players, etc.)

### Insider Statistics  
- Total valid insiders with email validation
- Cross-system overlap with ID graph
- Data quality and consistency metrics

### Team Preference Insights
- Market-by-market favorite team preferences
- Geographic distribution of fan loyalty
- Marketing targeting opportunities by team

### Business Value
- **Executive Reporting**: High-level KPIs for business reviews
- **Data Quality**: Validation of marketing database health
- **Marketing Strategy**: Team preference insights for targeting
- **Operational Metrics**: Database size and growth tracking

---

## Usage and Applications

### Primary Users
- Executive leadership for business metrics
- Marketing teams for database sizing
- Data engineering for validation
- Analytics teams for baseline metrics

### Key Use Cases
1. **Executive Reporting**: Monthly/quarterly business reviews
2. **Data Validation**: Marketing database health checks
3. **Marketing Planning**: Team preference analysis for campaigns
4. **Growth Tracking**: Customer base size monitoring

---

## Data Sources and Dependencies

### Input Tables
- `prod_marketing.dim_braze_families`: Family marketing profiles
- `prod_marketing.dim_braze_insiders`: Insider marketing profiles
- `prod_marketing.dim_braze_families_season_roster_20241118`: Season roster data
- `prod_id_graph.dim_family_all_people_details`: Master customer ID graph

### Key Business Rules
- Only valid records included (is_valid = true)
- Email validation for accurate counts
- Active status filtering for family metrics
- Season roster participation tracking

### Update Frequency
- On-demand execution for current metrics
- Typically run monthly for executive reporting
- Can be automated for regular dashboard updates
