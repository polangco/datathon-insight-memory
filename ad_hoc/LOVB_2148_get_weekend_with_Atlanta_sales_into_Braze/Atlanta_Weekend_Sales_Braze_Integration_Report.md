# Atlanta Weekend Sales Braze Integration Analysis

## Executive Summary

**Analysis**: LOVB-2148 - Atlanta Weekend Ticket Sales Data Integration for Braze Marketing  
**Objective**: Extract and format Atlanta ticket sales data from specific weekend events for Braze marketing platform integration

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `public.ticketmaster_events` - Ticketmaster event and sales data
- **Secondary Source**: `prod_marketing.dim_braze_single_match_tickets` - Existing Braze single match data

### Data Processing Pipeline
1. **Event Filtering**: Extract Atlanta market sales for specific weekend (Jan 30 - Feb 4, 2025)
2. **Data Cleaning**: Standardize names, emails, and phone numbers
3. **Email Validation**: Apply regex validation for email format
4. **External ID Management**: Generate or reuse external IDs for Braze integration
5. **Data Formatting**: Prepare final dataset for Braze import

### Destination
- **Output**: Formatted customer data ready for Braze marketing platform
- **Format**: Standardized customer profiles with event details

---

## Business Problem Solved

### Challenge
- Need to quickly integrate weekend Atlanta ticket sales into Braze for marketing
- Ensure data quality and formatting consistency for marketing campaigns
- Maintain external ID consistency across marketing platforms
- Enable immediate marketing follow-up for weekend event attendees

### Solution
- Automated extraction and formatting of Atlanta weekend sales data
- Comprehensive data cleaning and validation pipeline
- External ID management for consistent customer identification
- Ready-to-import format for immediate Braze integration

---

## Technical Implementation

### Key Data Transformations

1. **Event and Date Filtering**:
   - Date range: January 30 - February 4, 2025
   - Market filter: Atlanta only
   - Event-specific data extraction

2. **Data Standardization**:
   - Name formatting: TRIM and INITCAP for proper case
   - Email normalization: TRIM and LOWER for consistency
   - Phone cleaning: Remove non-numeric characters, keep digits only
   - Postal code formatting: LEFT 5 characters for ZIP code

3. **Email Validation**:
   - Regex pattern: `^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$`
   - Ensures valid email format for marketing campaigns
   - Filters out invalid or malformed email addresses

4. **External ID Management**:
   - Check existing Braze single match tickets for external IDs
   - Generate new UUIDs for new customers
   - COALESCE logic to maintain ID consistency

### Data Quality Features
- Comprehensive email format validation
- Phone number standardization (digits only)
- Name case standardization (proper case)
- ZIP code formatting (5-digit standard)

---

## Key Metrics and Outputs

### Customer Profile Data
- **Contact Information**: Standardized first name, last name, email, phone
- **Geographic Data**: Home ZIP code for demographic analysis
- **Event Details**: Event name, market, venue, and date
- **Braze Integration**: External ID for marketing platform consistency

### Event-Specific Information
- **Event Market**: Atlanta (filtered)
- **Event Venue**: Specific venue information
- **Event Date**: Weekend event dates (Jan 30 - Feb 4, 2025)
- **Event Name**: Specific event identification

### Business Value
- **Immediate Marketing**: Quick integration for post-event marketing
- **Customer Acquisition**: New customer identification and onboarding
- **Data Quality**: Clean, validated data for marketing campaigns
- **Platform Integration**: Seamless Braze marketing platform integration

---

## Usage and Applications

### Primary Users
- Marketing teams for immediate post-event campaigns
- Customer acquisition teams for new customer onboarding
- Data integration teams for platform synchronization
- Campaign managers for targeted Atlanta market campaigns

### Key Use Cases
1. **Post-Event Marketing**: Immediate follow-up campaigns for weekend attendees
2. **Customer Onboarding**: Integration of new customers into marketing database
3. **Market-Specific Campaigns**: Atlanta-focused marketing initiatives
4. **Event Analysis**: Weekend event performance and customer acquisition

---

## Data Sources and Dependencies

### Input Tables
- `public.ticketmaster_events`: Ticketmaster event and customer data
- `prod_marketing.dim_braze_single_match_tickets`: Existing Braze customer data

### Key Business Rules
- Date range: January 30 - February 4, 2025
- Market filter: Atlanta only
- Valid email format required for inclusion
- External ID consistency with existing Braze data

### Update Frequency
- One-time extraction for specific weekend events
- Can be adapted for other markets or date ranges
- Typically used for immediate post-event marketing integration

### Data Quality Standards
- Email validation with regex pattern matching
- Phone number standardization (numeric only)
- Name formatting consistency (proper case)
- ZIP code standardization (5-digit format)
