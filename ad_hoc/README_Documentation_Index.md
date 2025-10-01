# LOVB Ad Hoc SQL Scripts Documentation Index

## Overview

This directory contains comprehensive technical documentation for all SQL scripts in the LOVB ad hoc analysis folder. Each script has been organized into its own folder with detailed documentation following the established pattern from LOVB-2665 ACVA Sweep Stakes Analysis.

## Documentation Structure

Each SQL script folder contains:
- **SQL Script**: The original analysis script
- **Markdown Documentation**: Comprehensive technical report covering:
  - Executive Summary with objectives
  - Data Flow Overview (sources, pipeline, destinations)
  - Business Problem Solved (challenge and solution)
  - Technical Implementation details
  - Key Metrics and Outputs
  - Usage and Applications
  - Data Sources and Dependencies

## Fully Documented Scripts

### Core Infrastructure & Tracking
1. **ar_aging_with_billing_account_details/** - AR Aging Analysis with Customer Details
2. **build_id_to_email_mapping/** - Unified ID to Email Mapping Creation
3. **fct_braze_update_tracking/** - Braze Marketing Data Update Tracking
4. **fct_profile_merge_tracking/** - Customer Profile Merge Tracking System

### Business Intelligence & Reporting
5. **LOVB_1809_topline_stats/** - LOVB Marketing Database Topline Statistics
6. **LOVB_1916_refunds_over_time_per_club/** - Club Refund Trends Analysis
7. **LOVB_1735_winner_selection/** - NCAA Campaign Winner Selection Process

### Customer Analysis & Segmentation
8. **LOVB_2378_Shopify_Purchaser_Profile/** - Shopify E-commerce Customer Analysis
9. **LOVB_2410_insider_icon_voting_attribution/** - Icon Voting Attribution by Registration Period
10. **weekly_family_insiders_pull/** - Weekly Marketing Data Pull for Braze
11. **LOVB_2171_past_ticket_purchasers/** - Historical Single Ticket Purchaser Analysis
12. **LOVB_2504___Insider_by_Market/** - Insider Registration Analysis by Geographic Market

### Data Quality & Validation
13. **LOVB_2140_Error_Flagging_UAT/** - Sprocket Invoice Error Flagging User Acceptance Testing
14. **LOVB_2215_investigate_discounts_playmetrics/** - PlayMetrics Subscription Discount Investigation
15. **recon_braze_insider_duplicate_emails/** - Braze Insider Duplicate Email Reconciliation

### Event & Campaign Management
16. **LOVB_1937___historical_registrations/** - Historical NetSuite Registration Data Export
17. **LOVB_2148_get_weekend_with_Atlanta_sales_into_Braze/** - Atlanta Weekend Ticket Sales Braze Integration
18. **LOVB_2497_2026_Season_Ticket_Deposit_List/** - 2026 Season Ticket Deposit List Generation
19. **LOVB_2510_Austin_Celebration_List/** - Austin Championship Celebration Event List

### Campaign Analysis
20. **LOVB-2665 ACVA Sweep Stakes Analysis/** - ACVA Sweepstakes Performance Analysis (Original Example)

### Growth & Engagement Analysis
21. **LOVB_1986_weekly_insider_counts/** - Weekly Insider Registration Trends and Profile Completion
22. **LOVB_2504___Insider_Ticketing_Overlap/** - Insider and Ticketing Customer Overlap Analysis

### Data Operations & Infrastructure
23. **LOVB_2698___Camps_and_Clinics_Base_Data/** - Camps and Clinics Program Base Data Creation
24. **pull_ticket_purchasers_by_match/** - Ticket Purchasers by Match Incremental Braze Integration
25. **recon_id_graph_people_and_families/** - ID Graph People and Families Data Reconciliation

### Process Improvement & Validation
26. **LOVB_2147_Proposed_Sprocket_Rule_Set/** - Proposed Sprocket Validation Rule Set Implementation
27. **LOVB_2495___Wrong_package_name_in_item_name/** - Package Name Correction in Item Names

### Advanced Customer Analytics
28. **LOVB_1920_tickets_by_customer_segment/** - Comprehensive Ticket Purchase Analysis by Customer Segment
29. **ticket_purchase_analysis/** - Comprehensive Ticket Purchase Analysis Across All Platforms

### System Integration & Testing
30. **LOVB_2147_Sprocket_Netsuite_Error_Rule_Testing/** - Sprocket NetSuite Error Rule Testing and Validation
31. **LOVB_2449___NS_Mulesoft___Filter_Test_Player_/** - NetSuite MuleSoft Test Player Filtering

### Financial Operations
32. **LOVB_2251___adjustment_after_posting/** - Post-Posting Financial Adjustment Analysis

### Data Quality & Investigation
33. **LOVB_2529___investigate_type_2_cases_from_jill/** - Type 2 Cases Investigation Analysis
34. **LOVB_2730___Sprocket_Marketing_Consent___Investigate_data/** - Sprocket Marketing Consent Investigation

## Scripts with Folder Structure Created

The following scripts have been organized into folders and are ready for documentation:

### Financial & Billing Analysis
- **LOVB_2251___adjustment_after_posting/** - Post-posting adjustments analysis
- **LOVB_2495___Wrong_package_name_in_item_name/** - Package naming corrections
- **LOVB_2497_2026_Season_Ticket_Deposit_List/** - Season ticket deposit tracking

### Data Quality & Validation
- **LOVB_2140_Error_Flagging_UAT/** - Error flagging user acceptance testing
- **LOVB_2147_Proposed_Sprocket_Rule_Set/** - Sprocket validation rule proposals
- **LOVB_2147_Sprocket_Netsuite_Error_Rule_Testing/** - NetSuite error rule testing

### Customer Engagement & Events
- **LOVB_1920_tickets_by_customer_segment/** - Ticket purchase segmentation
- **LOVB_1937___historical_registrations/** - Historical registration analysis
- **LOVB_1986_weekly_insider_counts/** - Weekly insider growth tracking
- **LOVB_2148_get_weekend_with_Atlanta_sales_into_Braze/** - Atlanta sales data integration
- **LOVB_2171_past_ticket_purchasers/** - Historical ticket purchaser analysis
- **LOVB_2510_Austin_Celebration_List/** - Austin market celebration targeting

### Data Integration & ETL
- **LOVB_2449___NS_Mulesoft___Filter_Test_Player_/** - NetSuite MuleSoft test filtering
- **LOVB_2450___NS_Mulesoft___Filter_DO_NOT_USE/** - Deprecated MuleSoft filter
- **LOVB_2451___NS_Mulesoft___Impute_NULL_end_date/** - End date imputation logic
- **LOVB_2683_id_graph_inheritance_table/** - ID graph inheritance tracking
- **LOVB_2684___ACVA_sweepstakes_data_load/** - ACVA sweepstakes data loading

### Market & Segmentation Analysis
- **LOVB_2504___Insider_by_Market/** - Insider geographic distribution
- **LOVB_2504___Insider_Ticketing_Overlap/** - Insider and ticketing overlap
- **LOVB_2519_LOVB_Segment_Venn/** - Customer segment Venn diagram analysis
- **LOVB_2529___investigate_type_2_cases_from_jill/** - Type 2 case investigation
- **LOVB_2529___trace_specific_cases/** - Specific case tracing analysis

### Operations & Programs
- **LOVB_2698___Camps_and_Clinics_Base_Data/** - Camps and clinics base data
- **LOVB_2701___Sprocket_Cancelations_and_Credits/** - Sprocket cancellation tracking
- **LOVB_2730___Sprocket_Marketing_Consent___Investigate_data/** - Marketing consent investigation
- **LOVB_2215_investigate_discounts_playmetrics/** - PlayMetrics discount investigation

### Reconciliation & Data Quality
- **recon_braze_insider_duplicate_emails/** - Braze insider email deduplication
- **recon_id_graph_people_and_families/** - ID graph reconciliation
- **ticket_purchase_analysis/** - Comprehensive ticket purchase analysis
- **pull_ticket_purchasers_by_match/** - Match-specific ticket purchaser extraction

## Additional Files

### Python Scripts
- **LOVB_2519_segment_combo_generation.py** - Segment combination generation utility
- **ticketmaster_events.py** - Ticketmaster event data processing

## Documentation Standards

Each documentation file follows this structure:
1. **Executive Summary** - High-level overview and objectives
2. **Data Flow Overview** - Source systems, pipeline, and destinations
3. **Business Problem Solved** - Challenge description and solution approach
4. **Technical Implementation** - Key transformations and business logic
5. **Key Metrics and Outputs** - Expected results and business value
6. **Usage and Applications** - Primary users and use cases
7. **Data Sources and Dependencies** - Input tables, business rules, and update frequency

## Next Steps

The remaining scripts can be documented following the same comprehensive pattern established in the completed examples. Each script provides valuable business intelligence and operational insights for LOVB's data-driven decision making.

---

*Documentation created following the LOVB-2665 ACVA Sweep Stakes Analysis pattern*
