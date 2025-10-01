# ACVA Sweepstakes Campaign Analysis - Performance Marketing Summary

## AI Analysis Summary

**What This Script Does**: Analyzes ACVA Sweepstakes campaign performance among LOVB Insiders, focusing on engagement metrics, phone number availability, and campaign attribution analysis
**Key Outputs**: Campaign performance metrics, engagement breakdowns, phone number availability analysis, attribution insights
**Business Questions Answered**: 
- How did the ACVA Sweepstakes campaign perform among LOVB Insiders?
- What percentage of insiders have phone numbers available for follow-up campaigns?
- Which engagement segments show the highest phone number availability?
- How effective was the campaign at driving insider engagement?

**Stakeholder Use Cases**:
- Marketing: Evaluate campaign performance and plan follow-up strategies
- Customer Engagement: Understand insider engagement patterns and preferences
- Data Quality: Assess phone number availability for future SMS campaigns
- Campaign Optimization: Identify high-performing segments for targeting

**Adaptable Parameters**:
- Campaign scope: Currently ACVA Sweepstakes, can analyze other campaigns
- Engagement definitions: Can modify what constitutes engagement or interaction
- Segmentation criteria: Can adjust cohort definitions and breakdowns
- Attribution windows: Can modify campaign attribution timeframes

**Similar Request Indicators**:
- Keywords: campaign analysis, sweepstakes, insider engagement, phone availability, campaign performance
- Business domains: marketing analytics, campaign management, customer engagement, performance measurement
- Data entities: campaigns, insiders, engagement metrics, phone numbers, attribution

## Request Matching Guide

### Complete Match Scenarios
- Requests for sweepstakes or campaign performance analysis among insiders
- Campaign engagement analysis with phone number availability assessment
- Marketing campaign attribution and performance measurement

### Partial Match Scenarios  
- Different campaign types or channels (modify campaign filters)
- Alternative engagement metrics (adjust performance calculations)
- Different customer segments (modify cohort definitions)
- Additional attribution analysis (extend campaign tracking)

### No Match Scenarios
- This script does NOT handle: real-time campaign monitoring, automated campaign optimization, individual customer analysis, campaign execution

## Executive Summary

**Campaign**: ACVA Sweepstakes 2025 - First Serve  
**Analysis Date**: July 10, 2025  
**Objective**: Analyze campaign performance and phone number availability among LOVB Insiders

---

## Campaign Reach & Engagement

### Cohort Breakdown

| Cohort | Count | Percentage |
|--------|-------|------------|
| **Total LOVB Insiders** | 43,179 | 100% |
| **Insiders in ACVA Campaign** | 37,016 | 85.7% |
| **Insiders Who Engaged** | 14,668 | 39.6% |
| **Insiders Who Only Opened** | 13,381 | 36.2% |
| **Insiders Who Clicked** | 1,287 | 3.5% |
| **Insiders Who Did Not Engage** | 22,348 | 60.4% |

### Key Performance Metrics

| Metric | Count | Rate |
|--------|-------|------|
| **Campaign Reach** | 37,016 / 43,179 | 85.7% |
| **Open Rate** | 14,668 / 37,016 | 39.6% |
| **Click Rate** | 1,287 / 37,016 | 3.5% |
| **Click-to-Open Rate** | 1,287 / 14,668 | 8.8% |

---

## Phone Number Availability Analysis

### Overall Phone Number Coverage

| Cohort | Total | Phone Numbers Available | Phone Numbers Unavailable | Availability Rate |
|--------|-------|------------------------|---------------------------|-------------------|
| **Total Insiders in Campaign** | 37,016 | 13,091 | 23,925 | 35.4% |
| **Insiders Who Engaged** | 14,668 | 5,670 | 8,998 | 38.7% |
| **Insiders Who Only Opened** | 13,381 | 5,053 | 8,328 | 37.8% |
| **Insiders Who Clicked** | 1,287 | 617 | 670 | 47.9% |
| **Insiders Who Did Not Engage** | 22,348 | 7,421 | 14,927 | 33.2% |

### Key Observations

1. **Engagement Correlation**: Phone number availability increases with engagement level
   - Non-engaged: 33.2%
   - Opened only: 37.8% (+4.6 percentage points)
   - Clicked: 47.9% (+14.7 percentage points)

2. **Campaign Impact**: Engaged users have 16.6% higher phone number availability than non-engaged users (38.7% vs. 33.2%)

3. **High-Value Segment**: Clickers represent the highest phone number availability at 47.9%

---

## Attribution Analysis

### Methodology
- **Baseline**: Non-engaged insiders (33.2% phone number rate)
- **Assumption**: Non-engaged users represent natural phone number availability
- **Attribution**: Difference between observed and expected phone number rates

### Campaign Attribution Results

| Cohort | Total Users | Expected with Phones | Actual with Phones | Attributed to Campaign | Attribution Rate |
|--------|-------------|---------------------|-------------------|----------------------|------------------|
| **Insiders Who Engaged** | 14,668 | 4,870 | 5,670 | 800 | 5.5% |
| **Insiders Who Only Opened** | 13,381 | 4,442 | 5,053 | 611 | 4.6% |
| **Insiders Who Clicked** | 1,287 | 427 | 617 | 190 | 14.8% |

### Key Findings

1. **Total Attribution**: Campaign likely drove **990 insiders** to add phone numbers
2. **Engagement Impact**: Clickers were 3.2x more likely to add phone numbers due to campaign (14.8% vs. 4.6%)
3. **Conversion Rate**: 6.7% of engaged insiders added phone numbers due to campaign

### Attribution Range Estimates

| Scenario | Baseline Rate | Total Attribution | Range |
|----------|---------------|-------------------|-------|
| **Conservative** | 35% | 708 insiders | Lower bound |
| **Primary Estimate** | 33.2% | 990 insiders | Best estimate |
| **Optimistic** | 30% | 1,505 insiders | Upper bound |

**Note**: Range reflects uncertainty in baseline phone number availability assumptions

---

## Data Sources & Methodology

### Data Files
- Recipients export (41,540 users)
- Click tracking export (2,948 users) 
- Open tracking export (34,014 users)
- Complete LOVB Insiders database (43,179 users)

### Processing
- Email normalization for matching
- Boolean field formatting
- Phone number validation (non-null, non-empty)
- Consolidated into single analysis dataset

### Assumptions
- Non-engaged users represent baseline phone number availability
- Higher engagement correlates with campaign-driven phone number additions
- Email matching provides accurate user identification

---

## Campaign Performance Summary

### What Worked
- **High Reach**: 85.7% of total insider base reached
- **Strong Engagement**: 39.6% open rate among insiders
- **Phone Number Collection**: 990 additional phone numbers attributed to campaign
- **Engagement Correlation**: Higher engagement = higher phone number availability

### What Didn't Work
- **Low Click Rate**: 3.5% overall click rate
- **Phone Number Gap**: 64.6% of insiders still lack phone numbers
- **Engagement Drop-off**: 8.8% click-to-open rate suggests content optimization opportunity

### Data Quality
- **High Overlap**: 85.7% insider coverage in campaign
- **Clean Matching**: Successful email normalization and user identification
- **Complete Tracking**: Full open and click data available for analysis 