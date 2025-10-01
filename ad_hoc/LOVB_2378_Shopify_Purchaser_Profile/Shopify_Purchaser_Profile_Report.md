# Shopify Purchaser Profile Analysis

## AI Analysis Summary

**What This Script Does**: Analyzes Shopify e-commerce customers to create comprehensive purchaser profiles with merchandise categorization and cross-platform customer segment integration
**Key Outputs**: Customer profiles, order details, merchandise categories (team vs league), cross-platform customer flags
**Business Questions Answered**: 
- Who are our Shopify merchandise customers and their contact details?
- What types of merchandise do customers purchase (team-specific vs league-wide)?
- How do Shopify customers overlap with other LOVB segments (insiders, ticket holders, families)?
- What are the purchasing patterns by customer type and merchandise category?

**Stakeholder Use Cases**:
- Marketing: Cross-platform customer targeting and merchandise campaign optimization
- Merchandising: Product performance analysis and inventory planning
- Sales: Customer lifetime value analysis across all touchpoints
- Analytics: Customer journey mapping and segment overlap analysis

**Adaptable Parameters**:
- Date ranges: Currently analyzes all paid orders, can filter by specific periods
- Product categories: Uses regex matching for team/league classification, can modify categories
- Customer segments: Currently joins 5 marketing dimensions, can add/remove segments
- Geographic scope: No current filtering, can add market-specific analysis

**Similar Request Indicators**:
- Keywords: shopify, merchandise, e-commerce, customer profile, cross-platform, product analysis
- Business domains: merchandising, e-commerce, customer analytics, marketing integration
- Data entities: orders, customers, products, merchandise, customer segments

## Request Matching Guide

### Complete Match Scenarios
- Requests for Shopify customer profiles with merchandise categorization
- Cross-platform customer analysis including Shopify data
- Merchandise purchasing pattern analysis

### Partial Match Scenarios  
- Similar requests for other e-commerce platforms (modify source tables)
- Product-specific analysis (adjust categorization logic)
- Different time periods (modify date filters)
- Additional customer segments (add more marketing dimension joins)

### No Match Scenarios
- This script does NOT handle: inventory management, supplier analysis, financial reconciliation, refund analysis

## Executive Summary

**Analysis**: LOVB-2378 - Shopify E-commerce Customer Profile Analysis  
**Objective**: Comprehensive analysis of Shopify merchandise purchasers with customer segmentation and cross-platform integration

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `shopify_prod.orders` - Shopify e-commerce order data
- **Secondary Sources**: 
  - `prod_marketing.dim_braze_families` - Club family data
  - `prod_marketing.dim_braze_insiders` - Insider marketing data
  - `prod_marketing.dim_braze_season_tickets` - Season ticket holders
  - `prod_marketing.dim_braze_single_ticket_purchase` - Single match purchasers
  - `prod_marketing.dim_braze_coaches_20250331` - Coach information

### Data Processing Pipeline
1. **Order Data Processing**: Parse and clean Shopify order JSON data
2. **Line Item Extraction**: Unnest and categorize individual products
3. **Customer Segmentation**: Categorize merchandise by team and type
4. **Cross-Platform Integration**: Join with LOVB marketing databases
5. **Comprehensive Analysis**: Generate customer profiles with purchase behavior

### Destination
- **Output**: Comprehensive customer profile analysis with purchase patterns
- **Format**: Detailed customer segmentation with merchandise preferences

---

## Business Problem Solved

### Challenge
- Limited visibility into e-commerce customer behavior
- Need to understand merchandise preferences by customer segment
- Cross-platform customer identification and analysis
- Revenue attribution across different customer types

### Solution
- Comprehensive Shopify order analysis with customer profiling
- Team-based merchandise categorization and preference analysis
- Integration with LOVB marketing databases for customer segmentation
- Revenue and purchase pattern analysis by customer type

---

## Technical Implementation

### Key Data Transformations

1. **JSON Data Parsing**:
   - Extract customer details from nested JSON structures
   - Parse line items and product information
   - Clean and standardize address and contact data

2. **Product Categorization**:
   - **Team Merchandise**: Atlanta, Austin, Houston, Madison, Omaha, Salt Lake
   - **League Merchandise**: General LOVB and Adidas products
   - **Category Classification**: Team vs League merchandise

3. **Customer Segmentation**:
   - **Club Families**: Active club members and families
   - **Insiders**: LOVB insider community members
   - **Season Ticket Holders**: Pro team season subscribers
   - **Single Match Purchasers**: Individual game attendees
   - **Coaches**: Club coaches and directors

4. **Revenue Analysis**:
   - Total revenue by customer segment
   - Average order value and items per customer
   - Purchase patterns by time period and merchandise category

### Data Quality Features
- Phone number standardization (digits only)
- Address parsing and standardization
- Customer status classification (known vs unknown)
- Revenue calculations with quantity and pricing validation

---

## Key Metrics and Outputs

### Customer Analysis Dimensions
- **Order Metrics**: Order count, total revenue, items purchased
- **Customer Segmentation**: Club family, insider, ticket holder status
- **Geographic Analysis**: State, country, and address details
- **Merchandise Preferences**: Team vs league merchandise preferences
- **Temporal Analysis**: Purchase patterns by year and season periods

### Revenue Insights
- **Total Revenue**: $X across all customer segments
- **Customer Segments**: Revenue breakdown by customer type
- **Product Categories**: Team vs league merchandise performance
- **Geographic Distribution**: Revenue by state and region
- **Seasonal Patterns**: Purchase timing relative to LOVB season

### Business Value
- **Customer Understanding**: Comprehensive view of e-commerce customers
- **Marketing Targeting**: Data-driven customer segmentation
- **Merchandise Strategy**: Product preference insights by segment
- **Revenue Optimization**: Understanding high-value customer segments

---

## Usage and Applications

### Primary Users
- E-commerce teams for customer analysis
- Marketing teams for targeted campaigns
- Merchandise teams for product planning
- Revenue teams for performance analysis

### Key Use Cases
1. **Customer Segmentation**: Identify high-value customer segments
2. **Merchandise Planning**: Understand product preferences by segment
3. **Marketing Campaigns**: Target customers based on purchase behavior
4. **Revenue Analysis**: Track performance across customer types

---

## Data Sources and Dependencies

### Input Tables
- `shopify_prod.orders`: Complete Shopify order and customer data
- `prod_marketing.dim_braze_*`: All LOVB marketing dimension tables
- `prod_marketing.dim_braze_coaches_20250331`: Coach-specific data

### Key Business Rules
- Only paid orders included (financial_status = 'paid')
- Test orders excluded from analysis
- Customer matching based on email addresses
- Revenue calculations include quantity and pricing

### Update Frequency
- On-demand analysis for e-commerce performance reviews
- Typically run quarterly for merchandise planning
- Can be automated for regular customer insights reporting

### Data Quality Considerations
- JSON parsing validation for order data
- Customer email matching across platforms
- Revenue calculation accuracy with quantity validation
- Geographic data standardization for analysis
