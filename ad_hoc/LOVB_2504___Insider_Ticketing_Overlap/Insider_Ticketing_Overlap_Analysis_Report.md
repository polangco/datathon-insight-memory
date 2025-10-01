# Insider Ticketing Overlap Analysis

## Executive Summary

**Analysis**: LOVB-2504 - Insider and Ticketing Customer Overlap Analysis  
**Objective**: Analyze customer overlap between insider community, season ticket holders, and single match purchasers with geographic market intelligence

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `prod_intermediate.int_insider_profile` - Insider profile and geographic data
  - `prod_marketing.dim_braze_season_tickets` - Season ticket holder data
  - `prod_marketing.dim_braze_single_match_tickets` - Single match purchaser data

### Data Processing Pipeline
1. **Insider Market Assignment**: Map insiders to geographic markets via ZIP codes
2. **Season Ticket Integration**: Join with season ticket holder data
3. **Single Match Integration**: Integrate single match purchase data
4. **Market Intelligence**: Derive market assignment from purchase behavior
5. **Comprehensive Overlap Analysis**: Create unified customer view across all segments

### Destination
- **Output**: Unified customer dataset with insider, season ticket, and single match overlap
- **Format**: Customer profiles with boolean flags for each engagement type

---

## Business Problem Solved

### Challenge
- Need comprehensive view of customer engagement across all LOVB touchpoints
- Understanding overlap between insider community and ticketing customers
- Geographic market assignment for customers without clear ZIP code data
- Customer segmentation for targeted marketing and retention strategies

### Solution
- Unified customer analysis across insider, season ticket, and single match segments
- Intelligent market assignment using multiple data sources
- Boolean flag system for easy customer segmentation
- Geographic intelligence derived from purchase behavior

---

## Technical Implementation

### Key Data Transformations

1. **Insider Market Assignment**:
   - ZIP code pattern matching for pro team markets:
     - Atlanta: 300-312
     - Austin: 786-789  
     - Houston: 770-777
     - Madison: 52-61
     - Omaha: 51-68
     - Salt Lake: 840-844
   - Non-market US, International, and Unknown categorization
   - MAX aggregation to handle multiple ZIP codes per email

2. **Multi-Source Integration**:
   - FULL JOIN across insider, season ticket, and single match data
   - COALESCE logic to preserve all customer records
   - Email-based customer matching and deduplication

3. **Intelligent Market Assignment**:
   - Primary: Geographic market from ZIP code analysis
   - Secondary: Pro team from season ticket data
   - Tertiary: Market inference from single match purchase patterns
   - Fallback: 'Unknown' for customers without clear market indicators

4. **Customer Segmentation Flags**:
   - `is_insider`: Boolean flag for insider community membership
   - `is_season_ticket_holder`: Boolean flag for season ticket ownership
   - Individual single match flags by market (Atlanta, Austin, etc.)
   - COALESCE with FALSE default for clean boolean logic

### Data Quality Features
- Comprehensive email-based customer matching
- Multi-source market assignment with intelligent fallback
- Boolean flag system for easy segmentation
- Geographic validation and categorization

---

## Key Metrics and Outputs

### Customer Segmentation
- **Email**: Unique customer identifier
- **Market**: Final market assignment (geographic or inferred)
- **Insider Status**: Boolean flag for insider community membership
- **Season Ticket Status**: Boolean flag for season ticket ownership
- **Single Match Purchases**: Boolean flags by market for single match tickets

### Market Intelligence
- **Geographic Markets**: Atlanta, Austin, Houston, Madison, Omaha, Salt Lake
- **Non-Market Categories**: Non-Market US, International, Unknown
- **Market Assignment Logic**: ZIP code → Pro team → Purchase behavior → Unknown

### Overlap Analysis Capabilities
- **Insider + Season Ticket**: High-value customer identification
- **Insider + Single Match**: Engagement progression analysis
- **Season + Single Match**: Multi-engagement customer behavior
- **Triple Overlap**: Highest engagement customer segment

### Business Value
- **Customer Segmentation**: Comprehensive view of customer engagement levels
- **Market Intelligence**: Geographic and behavioral market assignment
- **Retention Analysis**: Understanding customer journey across touchpoints
- **Targeted Marketing**: Precise customer targeting based on engagement patterns

---

## Usage and Applications

### Primary Users
- Marketing teams for customer segmentation and targeting
- Customer success teams for retention and engagement strategies
- Analytics teams for customer journey analysis
- Business development for market performance assessment

### Key Use Cases
1. **Customer Segmentation**: Identify high-value multi-engagement customers
2. **Market Analysis**: Understand customer distribution across markets
3. **Retention Strategy**: Target customers based on engagement level
4. **Cross-Sell Opportunities**: Identify insider-to-ticket conversion potential

---

## Data Sources and Dependencies

### Input Tables
- `prod_intermediate.int_insider_profile`: Insider demographic and geographic data
- `prod_marketing.dim_braze_season_tickets`: Season ticket holder information
- `prod_marketing.dim_braze_single_match_tickets`: Single match purchase data

### Key Business Rules
- Email-based customer matching across all data sources
- Geographic market priority: ZIP code → Pro team → Purchase behavior
- Boolean flag system with FALSE defaults for missing data
- Comprehensive customer inclusion (no customer excluded)

### Update Frequency
- Monthly execution for comprehensive customer overlap analysis
- Quarterly for strategic customer segmentation review
- On-demand for specific marketing campaign targeting

### Expected Insights
- **Customer Overlap**: Percentage of customers engaged across multiple touchpoints
- **Market Distribution**: Customer concentration by geographic market
- **Engagement Progression**: Insider-to-ticket conversion patterns
- **High-Value Segments**: Multi-engagement customer identification
