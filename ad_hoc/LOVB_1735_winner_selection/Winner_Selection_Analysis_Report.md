# Winner Selection Analysis

## AI Analysis Summary

**What This Script Does**: Randomly selects a contest winner from NCAA campaign participants using fair random selection methodology with data validation to exclude internal accounts
**Key Outputs**: Single randomly selected winner with ID and email contact information for prize notification
**Business Questions Answered**: 
- Who is the randomly selected winner from the NCAA campaign participants?
- How do we ensure fair and unbiased winner selection from campaign participants?
- What are the contact details for the selected winner for prize fulfillment?
- How do we validate that the selection excludes internal test accounts?

**Stakeholder Use Cases**:
- Marketing: Execute fair and transparent contest winner selection process
- Legal/Compliance: Ensure random selection meets contest rules and regulations
- Customer Service: Provide winner contact information for prize fulfillment
- Operations: Document winner selection process for audit and transparency

**Adaptable Parameters**:
- Campaign criteria: Currently NCAA campaigns, can modify for other UTM campaign types
- Exclusion rules: Currently excludes internal emails, can extend filtering criteria
- Selection method: Uses random() function, can implement alternative randomization methods
- Winner count: Currently selects 1 winner, can modify for multiple winner selection

**Similar Request Indicators**:
- Keywords: winner selection, random selection, contest, campaign participants, NCAA, UTM campaigns
- Business domains: marketing campaigns, contest management, legal compliance, customer engagement
- Data entities: campaign participants, UTM parameters, users, winner selection, contests

## Request Matching Guide

### Complete Match Scenarios
- Requests for random winner selection from campaign participants
- Contest winner determination with fair selection methodology
- Campaign participant analysis for prize fulfillment

### Partial Match Scenarios  
- Different campaign types or UTM parameters (modify campaign filters)
- Multiple winner selection (adjust selection logic and output)
- Additional validation criteria (extend exclusion rules)
- Different randomization methods (modify selection algorithm)

### No Match Scenarios
- This script does NOT handle: prize fulfillment, winner notification, contest rules validation, participant eligibility verification

## Executive Summary

**Analysis**: LOVB-1735 - NCAA Campaign Winner Selection Process  
**Objective**: Random selection of contest winner from NCAA campaign participants with data validation

---

## Data Flow Overview

### Source Systems
- **Primary Source**: `public.platform_user_utm_parameters` - UTM campaign tracking data
- **Secondary Source**: `public.platform_user` - User profile and contact information

### Data Processing Pipeline
1. **Campaign Participant Identification**: Filter users with NCAA UTM campaigns
2. **Data Validation**: Exclude internal test accounts and invalid emails
3. **Random Selection**: Apply random number generation for fair winner selection
4. **Winner Determination**: Select single winner based on random ranking

### Destination
- **Output**: Single randomly selected winner with contact information
- **Format**: Winner record with ID and email for notification

---

## Business Problem Solved

### Challenge
- Need fair and transparent winner selection for NCAA campaign contest
- Exclude internal team members and test accounts from selection
- Provide auditable random selection process
- Generate winner contact information for notification

### Solution
- Automated random winner selection with data validation
- Exclusion of internal accounts (@teacode, @lovb domains)
- Transparent random number generation process
- Single winner output with contact details

---

## Technical Implementation

### Key Data Transformations

1. **Campaign Participant Filtering**:
   - Filter UTM parameters for NCAA campaign mentions
   - Case-insensitive matching with ~* operator
   - Distinct user identification to prevent duplicates

2. **Data Validation**:
   - Exclude internal email domains (@teacode, @lovb)
   - Remove test accounts and internal users
   - Ensure valid participant pool for selection

3. **Random Selection Process**:
   - Generate random() value for each participant
   - Order by random value for fair selection
   - LIMIT 1 to select single winner

### Business Logic
- Fair random selection using PostgreSQL random() function
- Internal account exclusion for contest integrity
- Single winner selection with contact information

---

## Key Metrics and Outputs

### Selection Criteria
- **Campaign Participation**: UTM campaign contains 'NCAA'
- **Valid Email**: Excludes internal domains
- **Random Selection**: Fair probability for all participants

### Winner Information
- **User ID**: Platform user identifier
- **Email Address**: Contact information for notification
- **Random Value**: Audit trail for selection process

### Business Value
- **Contest Integrity**: Fair and transparent winner selection
- **Compliance**: Auditable selection process
- **Operational Efficiency**: Automated winner determination
- **Customer Engagement**: Successful contest execution

---

## Usage and Applications

### Primary Users
- Marketing teams for contest execution
- Legal/Compliance for audit requirements
- Customer service for winner notification
- Campaign managers for contest administration

### Key Use Cases
1. **Contest Winner Selection**: Fair random selection from participants
2. **Audit Trail**: Transparent selection process documentation
3. **Winner Notification**: Contact information for prize fulfillment
4. **Campaign Analysis**: Participant validation and selection

---

## Data Sources and Dependencies

### Input Tables
- `public.platform_user_utm_parameters`: Campaign tracking and UTM data
- `public.platform_user`: User profiles and contact information

### Key Business Rules
- NCAA campaign participation required
- Internal accounts excluded from selection
- Single winner selection per contest
- Random selection for fairness

### Update Frequency
- One-time execution per contest
- On-demand for specific campaign contests
- Auditable results for compliance requirements

### Selection Validation
- Participant count verification
- Internal account exclusion confirmation
- Random selection audit trail
- Winner contact information validation
