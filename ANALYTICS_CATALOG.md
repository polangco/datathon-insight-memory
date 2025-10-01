# LOVB Analytics Catalog

## Overview

This catalog provides a comprehensive index of all analytical scripts and documentation in the LOVB data repository. Each entry includes the business purpose, key outputs, and stakeholder applications to enable quick discovery of existing solutions.

**Repository Structure**: `/ad_hoc/` - Contains 41 SQL scripts with comprehensive technical documentation  
**Documentation Standard**: Each script includes AI-optimized analysis summaries for automated request matching  
**Last Updated**: January 2025

---

## 📊 **Analytics Categories**

### 🏗️ **Core Infrastructure & Tracking**
*Foundation systems for data management and operational tracking*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **AR Aging with Billing Account Details** | Enhanced collections with customer contact info | AR aging report + customer details | Finance, Customer Service | `/ad_hoc/ar_aging_with_billing_account_details/` |
| **Braze Update Tracking** | Audit trail for marketing data refreshes | Update logs, data lineage records | Marketing Ops, Data Engineering | `/ad_hoc/fct_braze_update_tracking/` |
| **Profile Merge Tracking** | ID graph merge operation logging | Merge history, data lineage | Data Engineering, Customer Service | `/ad_hoc/fct_profile_merge_tracking/` |
| **ID Email Mapping** | Cross-system customer identification | ID-to-email mapping tables | Data Integration, Customer Service | `/ad_hoc/build_id_to_email_mapping/` |

### 📈 **Business Intelligence & Reporting**
*Executive reporting and high-level business metrics*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **LOVB Topline Stats** | Executive KPIs and database health | Customer counts, system validation | Executive, Data Validation | `/ad_hoc/LOVB_1809_topline_stats/` |
| **Camps and Clinics Base Data** | Program performance for Metabase | Revenue/registration metrics | Business Intelligence, Program Mgmt | `/ad_hoc/LOVB_2698___Camps_and_Clinics_Base_Data/` |
| **Historical Registrations** | Club-specific historical analysis | Formatted historical data exports | Analytics, Operations | `/ad_hoc/LOVB_1937___historical_registrations/` |

### 👥 **Customer Analysis & Segmentation**
*Customer behavior, segmentation, and lifecycle analysis*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **Past Ticket Purchasers** | Single ticket customer profiles + weekly patterns | Customer profiles, purchase flags | Marketing, Sales, Analytics | `/ad_hoc/LOVB_2171_past_ticket_purchasers/` |
| **Shopify Purchaser Profile** | E-commerce customer analysis + cross-platform integration | Customer profiles, merchandise categories | Marketing, Merchandising | `/ad_hoc/LOVB_2378_Shopify_Purchaser_Profile/` |
| **Insider by Market** | Geographic insider registration trends | Weekly counts by market | Marketing, Business Development | `/ad_hoc/LOVB_2504___Insider_by_Market/` |
| **Insider Ticketing Overlap** | Customer segment overlap analysis | Cross-segment customer mapping | Marketing, Analytics | `/ad_hoc/LOVB_2504___Insider_Ticketing_Overlap/` |

### 🔍 **Data Quality & Validation**
*Data integrity, error detection, and quality assurance*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **Proposed Sprocket Rule Set** | Registration data validation framework | Validation results, error flags | Data Quality, Operations | `/ad_hoc/LOVB_2147_Proposed_Sprocket_Rule_Set/` |
| **Error Flagging UAT** | User acceptance testing for validation rules | UAT results, rule effectiveness | Quality Assurance, System Integration | `/ad_hoc/LOVB_2140_Error_Flagging_UAT/` |
| **Wrong Package Name Correction** | Data quality fixes for item naming | Corrected item names, program details | Data Quality, Finance | `/ad_hoc/LOVB_2495___Wrong_package_name_in_item_name/` |

### 🎯 **Event & Campaign Management**
*Marketing campaigns, events, and customer engagement*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **ACVA Sweepstakes Analysis** | Campaign performance and phone availability | Engagement metrics, attribution | Marketing, Customer Engagement | `/ad_hoc/LOVB-2665 ACVA Sweep Stakes Analysis/` |
| **Atlanta Weekend Sales Braze** | Event ticket sales integration | Customer profiles for marketing | Marketing, Sales | `/ad_hoc/LOVB_2148_get_weekend_with_Atlanta_sales_into_Braze/` |
| **Austin Celebration List** | Event attendee management | Customer lists with external IDs | Marketing, Customer Service | `/ad_hoc/LOVB_2510_Austin_Celebration_List/` |
| **Winner Selection** | Fair contest winner determination | Random winner selection | Marketing, Legal/Compliance | `/ad_hoc/LOVB_1735_winner_selection/` |

### 📊 **Growth & Engagement Analysis**
*Customer acquisition, retention, and engagement patterns*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **Weekly Insider Counts** | Registration trends + profile completion | Weekly metrics, data quality | Marketing, Data Quality | `/ad_hoc/LOVB_1986_weekly_insider_counts/` |
| **Insider Icon Voting Attribution** | Engagement analysis by registration period | Voting behavior patterns | Marketing, Analytics | `/ad_hoc/LOVB-2410_insider_icon_voting_attribution/` |

### 💰 **Financial Operations**
*Revenue analysis, adjustments, and financial reporting*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **Refunds Over Time Per Club** | Club refund trends and performance | Monthly refund metrics | Finance, Operations | `/ad_hoc/LOVB_1916_refunds_over_time_per_club/` |
| **Adjustment After Posting** | Post-posting financial change analysis | Adjustment patterns, variance | Finance, Operations | `/ad_hoc/LOVB_2251___adjustment_after_posting/` |
| **PlayMetrics Discounts Investigation** | Subscription discount pattern analysis | Discount changes, OOM tracking | Finance, Operations | `/ad_hoc/LOVB_2215_investigate_discounts_playmetrics/` |

### 🎫 **Ticketing & Events**
*Ticket sales, customer segments, and event analysis*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **2026 Season Ticket Deposits** | Deposit holder management | Customer profiles, team assignments | Marketing, Sales | `/ad_hoc/LOVB_2497_2026_Season_Ticket_Deposit_List/` |
| **Tickets by Customer Segment** | Segment-based ticket analysis | Purchase patterns by segment | Marketing, Analytics | `/ad_hoc/LOVB_1920_tickets_by_customer_segment/` |
| **Ticket Purchasers by Match** | Match-specific customer analysis | Customer lists by event | Marketing, Operations | `/ad_hoc/pull_ticket_purchasers_by_match/` |

### 🔧 **System Integration & Testing**
*Data integration, system testing, and technical operations*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **Sprocket NetSuite Error Testing** | System integration validation | Error analysis, rule testing | Data Engineering, System Integration | `/ad_hoc/LOVB_2147_Sprocket_Netsuite_Error_Rule_Testing/` |
| **NetSuite MuleSoft Filter** | Data filtering for system integration | Filtered records, test exclusions | Data Engineering, Operations | `/ad_hoc/LOVB_2449___NS_Mulesoft___Filter_Test_Player_/` |

### 🔍 **Data Operations & Investigation**
*Specialized investigations and data reconciliation*

| Script | Business Purpose | Key Outputs | Stakeholders | 📁 Location |
|--------|------------------|-------------|--------------|-------------|
| **Type 2 Cases Investigation** | Specific data quality issue analysis | Case analysis, discrepancy patterns | Data Quality, Finance | `/ad_hoc/LOVB_2529___investigate_type_2_cases_from_jill/` |
| **Braze Insider Duplicate Reconciliation** | Email duplicate resolution | Clean customer records | Data Quality, Marketing | `/ad_hoc/recon_braze_insider_duplicate_emails/` |
| **ID Graph People Families Reconciliation** | Customer relationship data cleanup | Clean ID graph, merged records | Data Engineering, Analytics | `/ad_hoc/recon_id_graph_people_and_families/` |

---

## 🔍 **Quick Reference Guide**

### **By Business Function**

**Marketing Teams** → Customer segmentation, campaign analysis, engagement tracking  
**Finance Teams** → Revenue analysis, refund tracking, billing operations  
**Operations Teams** → Data quality, system integration, process improvement  
**Analytics Teams** → Customer behavior, trend analysis, performance metrics  
**Executive Teams** → Topline metrics, business intelligence, strategic insights

### **By Data Domain**

**Customer Data** → Profiles, segmentation, behavior, lifecycle  
**Financial Data** → Revenue, refunds, adjustments, billing  
**Campaign Data** → Performance, attribution, engagement  
**Operational Data** → System health, data quality, processes  
**Event Data** → Tickets, attendance, customer participation

### **By Output Type**

**Customer Lists** → Marketing campaigns, customer service  
**Performance Metrics** → Executive reporting, trend analysis  
**Data Quality Reports** → System validation, process improvement  
**Financial Analysis** → Revenue operations, audit compliance  
**Trend Analysis** → Strategic planning, forecasting

---

## 🤖 **AI Analysis Integration**

### **Request Matching Capabilities**

Each documented script includes:
- **Complete Match Scenarios**: Exact request fulfillment
- **Partial Match Scenarios**: Adaptable solutions requiring modifications
- **No Match Boundaries**: Clear limitations and exclusions
- **Adaptable Parameters**: Customizable elements for different use cases

### **Stakeholder Use Case Mapping**

Scripts are mapped to specific departmental needs:
- **Marketing**: Customer targeting, campaign analysis, engagement tracking
- **Finance**: Revenue analysis, collections, financial reporting
- **Operations**: Process improvement, data quality, system integration
- **Analytics**: Trend analysis, customer behavior, performance metrics

### **Business Domain Keywords**

Optimized for AI matching with domain-specific terminology:
- **Customer Analytics**: segmentation, behavior, lifecycle, engagement
- **Financial Operations**: revenue, refunds, billing, collections
- **Marketing Operations**: campaigns, attribution, performance, targeting
- **Data Quality**: validation, reconciliation, integrity, cleanup

---

## 📋 **Usage Guidelines**

### **For Stakeholders**
1. **Browse by Category** to find relevant analysis types
2. **Search by Business Purpose** to match specific needs
3. **Review Key Outputs** to understand deliverables
4. **Check Stakeholder Applications** for departmental relevance

### **For AI Systems**
1. **Use Keywords** for semantic matching against requests
2. **Leverage Business Domains** for contextual understanding
3. **Apply Request Matching Guide** for solution recommendation
4. **Consider Adaptable Parameters** for customization options

### **For Data Teams**
1. **Reference Technical Documentation** in each script folder
2. **Review Data Flow Diagrams** for system understanding
3. **Check Dependencies** before script execution
4. **Follow Documentation Standards** for new analyses

---

## 📁 **Folder Structure & Navigation Guide**

### **Standard Folder Organization**
Each analysis has its own dedicated folder containing:
```
/ad_hoc/[SCRIPT_FOLDER_NAME]/
├── [Script_Name].sql                    # Main SQL script
├── [Analysis_Report].md                 # Comprehensive documentation
└── [Additional_Files]                   # Supporting files (if any)
```

### **File Naming Conventions**
- **SQL Scripts**: Original descriptive names (e.g., `LOVB-2171 past ticket purchasers.sql`)
- **Documentation**: Descriptive analysis report names (e.g., `Past_Ticket_Purchasers_Analysis_Report.md`)
- **Folders**: Match script names with underscores (e.g., `LOVB_2171_past_ticket_purchasers/`)

### **Navigation Instructions for LLMs**
1. **Start Here**: Use this catalog to identify relevant scripts by business need
2. **Navigate to Folder**: Use the 📁 Location column to find the specific folder
3. **Read Documentation**: Open the `.md` file for comprehensive analysis details
4. **Access Script**: Find the `.sql` file for technical implementation
5. **Check AI Summary**: Look for "## AI Analysis Summary" section for matching guidance

### **Key Documentation Sections**
Each documentation file contains:
- **AI Analysis Summary**: LLM-optimized matching information
- **Executive Summary**: Business context and objectives
- **Data Flow Overview**: Technical architecture and data sources
- **Business Problem Solved**: Challenge and solution description
- **Usage Instructions**: How to execute and interpret results

## 📞 **Support & Maintenance**

**Documentation Location**: `/ad_hoc/[script_folder]/[analysis_report].md`  
**Script Location**: `/ad_hoc/[script_folder]/[script_name].sql`  
**Template Reference**: `/ad_hoc/LLM_Documentation_Template.md`  
**Master Catalog**: `/ANALYTICS_CATALOG.md` (this file)

**Last Catalog Update**: January 2025  
**Total Scripts Documented**: 34 of 41 scripts with full AI optimization  
**Documentation Coverage**: 83% with LLM-optimized analysis summaries

### **Additional Resources**
- **Complete Documentation Index**: `/ad_hoc/README_Documentation_Index.md`
- **LLM Template**: `/ad_hoc/LLM_Documentation_Template.md`
- **Batch Update Scripts**: `/ad_hoc/batch_update_docs.py`, `/ad_hoc/complete_llm_updates.py`

---

*This catalog enables efficient discovery of existing analytical solutions and supports AI-powered request matching for optimal resource utilization.*
