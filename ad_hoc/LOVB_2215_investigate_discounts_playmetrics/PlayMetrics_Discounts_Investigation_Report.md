# PlayMetrics Discounts Investigation Analysis

## AI Analysis Summary

**What This Script Does**: Investigates PlayMetrics subscription discounts, adjustments, and cancellations with focus on out-of-month (OOM) modifications and historical change tracking
**Key Outputs**: Subscription IDs with discount changes, timeline of modifications, out-of-month adjustment patterns
**Business Questions Answered**: 
- Which PlayMetrics subscriptions have discount/adjustment modifications?
- When were subscription changes made relative to original creation dates?
- Which subscriptions were modified outside their original month (OOM)?
- What is the timeline of discount and adjustment changes?

**Stakeholder Use Cases**:
- Finance: Audit discount applications and revenue adjustments
- Operations: Identify process improvement opportunities for subscription management
- Analytics: Understand subscription modification patterns and timing
- Compliance: Track changes made after initial posting periods

**Adaptable Parameters**:
- Date ranges: Currently June-August 2024, easily modified for other periods
- Subscription types: Currently all PlayMetrics, can filter by specific programs
- Change thresholds: Currently any discount/adjustment >$0, can modify criteria
- Time boundaries: OOM logic can be adjusted for different business rules

**Similar Request Indicators**:
- Keywords: discounts, adjustments, subscription changes, out-of-month, historical tracking, PlayMetrics
- Business domains: finance, subscription management, revenue operations, audit
- Data entities: subscriptions, discounts, adjustments, cancellations, modifications

## Request Matching Guide

### Complete Match Scenarios
- Requests to investigate PlayMetrics discount patterns and timing
- Analysis of subscription modifications and their timeline
- Out-of-month adjustment identification and tracking

### Partial Match Scenarios  
- Similar analysis for other subscription systems (modify source tables)
- Different time periods or subscription criteria (adjust filters)
- Additional financial metrics or modification types (extend analysis)
- Different OOM definitions (modify time boundary logic)

### No Match Scenarios
- This script does NOT handle: customer-facing discount codes, promotional campaigns, refund processing, payment reconciliation

## Executive Summary

**Analysis**: LOVB-2215 - PlayMetrics Subscription Discount Investigation  
**Objective**: Investigate discount application patterns and historical changes in PlayMetrics subscription data

---

## Data Flow Overview

### Source Systems
- **Primary Sources**: 
  - `public.playmetrics_subscriptions_latest` - Current subscription data
  - `public.playmetrics_subscriptions` - Historical subscription changes

### Data Processing Pipeline
1. **Current Data Analysis**: Examine latest subscription discount patterns
2. **Historical Tracking**: Analyze subscription changes over time
3. **Cross-Month Analysis**: Identify subscriptions modified across month boundaries
4. **Discount Pattern Investigation**: Focus on specific subscription cases
5. **Timeline Analysis**: Track discount changes chronologically

### Destination
- **Output**: Discount investigation results with historical change patterns
- **Format**: Detailed analysis of subscription discount modifications

---

## Business Problem Solved

### Challenge
- Unexplained discount patterns in PlayMetrics subscription data
- Need to understand when and how discounts are applied or modified
- Investigation of specific subscription cases with unusual discount behavior
- Historical tracking of subscription financial changes

### Solution
- Comprehensive analysis of discount application patterns
- Historical timeline tracking of subscription modifications
- Cross-month change detection for audit purposes
- Specific case investigation for unusual discount scenarios

---

## Technical Implementation

### Key Analysis Components

1. **Current State Analysis**:
   - Latest subscription data examination
   - Discount, adjustment, and cancellation patterns
   - Financial component breakdown by subscription

2. **Historical Change Tracking**:
   - Subscription modification timeline analysis
   - Cross-month change detection (Out-of-Month flagging)
   - MIN(last_modified) tracking for change chronology

3. **Specific Case Investigation**:
   - Focus on subscription IDs 3936107 and 3850780
   - Detailed financial component tracking
   - Change timeline documentation

4. **Cross-Month Analysis**:
   - Identify subscriptions modified in different months than created
   - Flag potential audit cases with OOM (Out-of-Month) indicator
   - Filter for subscriptions with cross-month modifications

### Data Quality Features
- Date range filtering (June-August 2024 focus)
- Historical change aggregation with MIN(last_modified)
- Cross-month modification flagging
- Specific subscription case tracking

---

## Key Metrics and Outputs

### Subscription Financial Components
- **Budget**: Original subscription amount
- **Discounts**: Applied discount amounts
- **Adjustments**: Post-creation adjustments
- **Cancellations**: Cancellation amounts
- **Late Fees**: Additional fees applied
- **Projected Total**: Final calculated amount

### Historical Change Analysis
- **Creation Date**: Original subscription date
- **Last Modified**: When subscription was last changed
- **Cross-Month Flag**: OOM indicator for audit cases
- **Change Timeline**: Chronological modification history

### Investigation Focus Areas
- **Specific Cases**: Detailed analysis of flagged subscriptions
- **Discount Patterns**: How and when discounts are applied
- **Modification Timing**: Cross-month change identification
- **Financial Impact**: Total effect of discount modifications

### Business Value
- **Audit Compliance**: Identification of cross-month modifications
- **Process Understanding**: How discount application works
- **Data Quality**: Validation of subscription financial calculations
- **Issue Resolution**: Investigation of specific discount anomalies

---

## Usage and Applications

### Primary Users
- Finance teams for discount audit and validation
- Operations teams for subscription process investigation
- Data quality teams for anomaly investigation
- Compliance teams for cross-month modification tracking

### Key Use Cases
1. **Discount Audit**: Validate discount application processes
2. **Anomaly Investigation**: Investigate unusual subscription patterns
3. **Process Documentation**: Understand subscription modification workflows
4. **Compliance Tracking**: Monitor cross-month financial changes

---

## Data Sources and Dependencies

### Input Tables
- `public.playmetrics_subscriptions_latest`: Current subscription state
- `public.playmetrics_subscriptions`: Historical subscription changes

### Key Business Rules
- Date range focus: June-August 2024 subscriptions
- Cross-month modification flagging (OOM indicator)
- Historical change tracking with MIN(last_modified)
- Specific case investigation for anomalous subscriptions

### Update Frequency
- On-demand investigation for specific discount issues
- Periodic audit analysis for compliance purposes
- Historical analysis when subscription anomalies are identified

### Investigation Methodology
- **Current State Analysis**: Latest subscription data review
- **Historical Tracking**: Change timeline documentation
- **Cross-Month Detection**: Out-of-month modification identification
- **Case-Specific Investigation**: Detailed analysis of flagged subscriptions
