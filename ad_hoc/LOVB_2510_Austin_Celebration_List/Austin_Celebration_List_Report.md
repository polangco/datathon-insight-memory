# Austin Celebration List Analysis

## Executive Summary

**Analysis**: LOVB-2510 - Austin Championship Celebration Event List Generation  
**Objective**: Consolidate Austin championship celebration attendee data from multiple sources for Braze marketing integration

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `public.lovb_austin_championship_celebration_rsvp` - RSVP data
  - `public.lovb_austin_celebration_season_ticket_holder` - Season ticket holder data
- **Secondary Sources**: Multiple Braze marketing dimension tables for external ID mapping

### Data Processing Pipeline
1. **Multi-Source Data Integration**: Combine RSVP and season ticket holder data
2. **Phone Number Standardization**: Clean and format phone numbers
3. **Marketing Consent Processing**: Parse marketing consent preferences
4. **External ID Resolution**: Map to existing Braze external IDs
5. **Data Deduplication**: Consolidate duplicate records by email
6. **Final Integration**: Prepare unified dataset for Braze marketing

### Destination
- **Output**: Unified Austin celebration attendee list with Braze integration
- **Format**: Customer profiles with marketing consent and contact details

---

## Business Problem Solved

### Challenge
- Multiple data sources for Austin celebration event attendees
- Need unified customer list for post-event marketing
- Phone number formatting inconsistencies across sources
- Marketing consent tracking and compliance requirements
- Integration with existing Braze marketing database

### Solution
- Automated consolidation of RSVP and season ticket holder data
- Standardized phone number formatting with international prefixes
- Marketing consent parsing and boolean flag creation
- Comprehensive external ID mapping across marketing platforms
- Deduplication logic for clean, unified customer dataset

---

## Technical Implementation

### Key Data Transformations

1. **Multi-Source Integration**:
   - UNION ALL between RSVP and season ticket holder tables
   - Source tracking with 'rsvp' and 'season_ticket_holder' labels
   - Consistent field mapping across both sources

2. **Phone Number Standardization**:
   - Remove non-numeric characters with regex
   - Length-based formatting logic:
     - 10 digits: Add '+1' prefix (US format)
     - 11 digits starting with '1': Add '+' prefix
     - >11 digits starting with '1': Truncate to 11 and add '+'
   - NULL for invalid formats

3. **Marketing Consent Processing**:
   - Parse 'Yes'/'No' responses to boolean flags
   - 'Yes' → TRUE, 'No' → NULL (explicit opt-out)
   - Compliance with marketing consent regulations

4. **External ID Resolution**:
   - UNION across multiple Braze dimension tables
   - Prioritization by most recent `last_updated` timestamp
   - UUID generation for new customers not in marketing database

5. **Data Deduplication**:
   - Email-based grouping for duplicate consolidation
   - MAX aggregation for phone numbers and consent flags
   - Single record per email address in final output

### Data Quality Features
- Phone number validation and standardization
- Marketing consent compliance tracking
- External ID consistency across marketing platforms
- Email-based deduplication with data preservation

---

## Key Metrics and Outputs

### Customer Profile Data
- **External ID**: Braze marketing platform identifier
- **Contact Information**: First name, last name, email
- **Phone Number**: Standardized international format
- **Marketing Consent**: Boolean flag for promotional material consent
- **Pro Team**: Austin (event-specific)
- **Source**: RSVP or season ticket holder identification

### Event-Specific Information
- **Event Type**: Austin championship celebration
- **Attendee Sources**: RSVP respondents and season ticket holders
- **Marketing Compliance**: Consent tracking for future campaigns
- **Customer Integration**: Braze platform readiness

### Business Value
- **Event Marketing**: Unified attendee list for post-event campaigns
- **Customer Acquisition**: Integration of new customers into marketing database
- **Compliance**: Marketing consent tracking and management
- **Platform Integration**: Seamless Braze marketing platform integration

---

## Usage and Applications

### Primary Users
- Event marketing teams for post-celebration campaigns
- Customer acquisition teams for new customer onboarding
- Compliance teams for marketing consent management
- Data integration teams for platform synchronization

### Key Use Cases
1. **Post-Event Marketing**: Follow-up campaigns for celebration attendees
2. **Customer Onboarding**: Integration of new customers into marketing database
3. **Consent Management**: Tracking and respecting marketing preferences
4. **Event Analysis**: Attendee source analysis and engagement measurement

---

## Data Sources and Dependencies

### Input Tables
- `public.lovb_austin_championship_celebration_rsvp`: Event RSVP data
- `public.lovb_austin_celebration_season_ticket_holder`: Season ticket holder data
- `prod_marketing.dim_braze_families`: Family marketing profiles
- `prod_marketing.dim_braze_insiders`: Insider marketing profiles
- `prod_marketing.dim_braze_season_tickets`: Season ticket holder data
- `prod_marketing.dim_braze_single_match_tickets`: Single match purchaser data
- `prod_marketing.dim_braze_coaches_20250505`: Coach information

### Key Business Rules
- Phone number standardization with international formatting
- Marketing consent parsing ('Yes' → TRUE, 'No' → NULL)
- External ID prioritization by most recent update date
- Email-based deduplication with data consolidation
- Pro team assignment: Austin (event-specific)

### Update Frequency
- One-time analysis for Austin championship celebration event
- Can be adapted for other team celebration events
- Typically used for immediate post-event marketing integration

### Data Quality Standards
- Phone number validation and international formatting
- Marketing consent compliance tracking
- External ID consistency with existing marketing database
- Email-based deduplication for clean customer records
