# Tickets by Customer Segment Analysis

## Executive Summary

**Analysis**: LOVB-1920 - Comprehensive Ticket Purchase Analysis by Customer Segment  
**Objective**: Analyze ticket purchasing patterns across different customer segments including insiders, season ticket holders, and single match purchasers with geographic and demographic insights

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `prod_raw.stg_insider_demographics` - Insider demographic data
  - `prod_raw.stg_dt_insiders` - Additional insider data
  - `prod_raw.stg_insider_team` - Team preference data
  - `prod_raw.stg_ticketmaster_market_sales` - Ticketmaster sales data
  - `prod_raw.stg_paciolan_tickets` - Paciolan ticket sales
  - `prod_raw.stg_season_tickets` - Season ticket data

### Data Processing Pipeline
1. **Insider Data Preparation**: Consolidate insider data from multiple sources
2. **Email Validation**: Apply regex validation and unsubscribe filtering
3. **Team Preference Integration**: Add team preference flags
4. **Ticket Sales Integration**: Combine multiple ticket sales sources
5. **Geographic Market Mapping**: Detailed ZIP code to market assignment
6. **Customer Segmentation**: Multi-dimensional customer classification
7. **Comprehensive Analysis**: Cross-segment ticket purchasing behavior

### Destination
- **Output**: Comprehensive customer segment analysis with ticket purchasing patterns
- **Format**: Multi-dimensional customer profiles with geographic and behavioral segmentation

---

## Business Problem Solved

### Challenge
- Need comprehensive understanding of ticket purchasing behavior across customer segments
- Geographic market analysis for targeted marketing and sales strategies
- Customer overlap analysis between different engagement types
- Team preference correlation with actual ticket purchasing behavior

### Solution
- Comprehensive customer segmentation across all touchpoints
- Detailed geographic market mapping with extensive ZIP code coverage
- Multi-source ticket sales integration for complete purchase view
- Team preference analysis correlated with actual purchasing behavior

---

## Technical Implementation

### Key Data Processing Components

1. **Insider Data Consolidation**:
   - FULL JOIN between demographic and DT insider data
   - COALESCE logic for comprehensive customer profiles
   - Email validation with regex pattern matching
   - Unsubscribe list filtering for active customers

2. **Ticket Sales Integration**:
   - UNION across multiple ticket sources:
     - Ticketmaster market sales
     - Paciolan tickets
     - Season tickets
   - Ticket type classification (Single Match vs Season Tickets)
   - Pro team assignment from sales data

3. **Geographic Market Mapping**:
   - Extensive ZIP code mapping for all pro team markets:
     - **Atlanta**: 30000-30399 range with specific ZIP codes
     - **Austin**: 78600-78799 range with specific ZIP codes
     - **Houston**: 77000-77599 range with specific ZIP codes
     - **Madison**: 53500-53799 range with specific ZIP codes
     - **Omaha**: 68000-68199 range with specific ZIP codes
     - **Salt Lake**: 84000-84199 range with specific ZIP codes
   - Non-pro city classification for other areas

4. **Customer Segmentation Logic**:
   - **Team Preference Analysis**: Multiple team vs single team preferences
   - **Geographic Assignment**: ZIP code-based market classification
   - **Purchase Behavior**: Ticket type and frequency analysis
   - **Engagement Level**: Insider status combined with ticket purchases

### Data Quality Features
- Comprehensive email validation with regex patterns
- Unsubscribe list filtering for marketing compliance
- Extensive ZIP code coverage for accurate geographic assignment
- Multi-source data integration with conflict resolution

---

## Key Metrics and Outputs

### Customer Segmentation Dimensions
- **Insider Status**: Community membership and engagement
- **Team Preferences**: Single team vs multiple team preferences
- **Geographic Market**: Pro team market assignment based on ZIP codes
- **Ticket Purchase Behavior**: Season tickets vs single match purchases
- **Purchase Frequency**: Historical ticket purchasing patterns

### Geographic Analysis
- **Pro Team Markets**: Atlanta, Austin, Houston, Madison, Omaha, Salt Lake
- **Market Coverage**: Extensive ZIP code mapping for accurate assignment
- **Non-Market Areas**: Customers outside pro team geographic markets
- **Market Penetration**: Customer distribution across different markets

### Behavioral Insights
- **Cross-Segment Analysis**: Insider + ticket purchaser overlap
- **Team Loyalty**: Preference vs actual purchase correlation
- **Geographic Patterns**: Market-specific purchasing behavior
- **Engagement Progression**: Customer journey across different touchpoints

### Business Value
- **Targeted Marketing**: Precise customer segmentation for campaigns
- **Market Strategy**: Geographic insights for market development
- **Customer Retention**: Understanding high-value customer segments
- **Revenue Optimization**: Identifying cross-sell and upsell opportunities

---

## Usage and Applications

### Primary Users
- Marketing teams for customer segmentation and targeting
- Sales teams for market-specific strategies
- Business development for geographic expansion
- Analytics teams for customer behavior analysis

### Key Use Cases
1. **Customer Segmentation**: Identify high-value multi-engagement customers
2. **Geographic Marketing**: Market-specific campaign development
3. **Cross-Sell Analysis**: Insider to ticket purchaser conversion
4. **Market Development**: Understanding geographic market penetration

---

## Data Sources and Dependencies

### Input Tables
- `prod_raw.stg_insider_demographics`: Insider demographic and registration data
- `prod_raw.stg_dt_insiders`: Additional insider data source
- `prod_raw.stg_insider_team`: Team preference data
- `prod_raw.stg_ticketmaster_market_sales`: Ticketmaster sales data
- `prod_raw.stg_paciolan_tickets`: Paciolan ticket sales
- `prod_raw.stg_season_tickets`: Season ticket holder data
- `prod_raw.stg_braze_unsub`: Unsubscribe list for compliance

### Key Business Rules
- Email validation with regex pattern matching
- Unsubscribe list filtering for marketing compliance
- Extensive ZIP code mapping for accurate market assignment
- Multi-source ticket data integration with type classification

### Update Frequency
- Monthly execution for comprehensive customer segment analysis
- Quarterly for strategic market and customer development planning
- On-demand for specific marketing campaign targeting

### Expected Insights
- **Customer Overlap**: Percentage of customers engaged across multiple touchpoints
- **Geographic Distribution**: Customer concentration by pro team markets
- **Purchase Patterns**: Ticket purchasing behavior by customer segment
- **Market Opportunities**: Underserved markets and customer segments
