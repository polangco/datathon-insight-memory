#!/usr/bin/env python3
"""
Complete LLM optimization updates for all remaining documentation files
"""

import os
import re
from pathlib import Path

def create_ai_summary(description, outputs, questions, use_cases, parameters, keywords, domains, entities, complete_scenarios, partial_scenarios, no_match_scenarios):
    """Create AI Analysis Summary section"""
    return f"""## AI Analysis Summary

**What This Script Does**: {description}
**Key Outputs**: {outputs}
**Business Questions Answered**: 
{questions}

**Stakeholder Use Cases**:
{use_cases}

**Adaptable Parameters**:
{parameters}

**Similar Request Indicators**:
- Keywords: {keywords}
- Business domains: {domains}
- Data entities: {entities}

## Request Matching Guide

### Complete Match Scenarios
{complete_scenarios}

### Partial Match Scenarios  
{partial_scenarios}

### No Match Scenarios
{no_match_scenarios}

"""

def update_file(file_path, ai_summary):
    """Update a documentation file with AI Analysis Summary"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find insertion point after title and before Executive Summary
        title_match = re.search(r'^# (.+)\n\n', content, re.MULTILINE)
        exec_summary_match = re.search(r'^## Executive Summary', content, re.MULTILINE)
        
        if title_match and exec_summary_match:
            title_end = title_match.end()
            new_content = content[:title_end] + ai_summary + "\n" + content[title_end:]
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            
            return True
        return False
    except Exception as e:
        print(f"Error updating {file_path}: {e}")
        return False

# Define AI summaries for remaining files
remaining_files = {
    "build_id_to_email_mapping": {
        "description": "Creates comprehensive mapping between various ID types and email addresses across LOVB systems for customer identification and data integration",
        "outputs": "ID-to-email mapping table with multiple ID types, email addresses, and system source information",
        "questions": "- How do we map different ID types to email addresses across systems?\n- What are the relationships between customer IDs and email addresses?\n- How do we enable cross-system customer identification?\n- Which emails are associated with specific customer or insider IDs?",
        "use_cases": "- Data Integration: Enable cross-system customer identification and data joining\n- Customer Service: Quickly identify customers across different platforms\n- Marketing: Unify customer communications across multiple touchpoints\n- Analytics: Support customer journey analysis across systems",
        "parameters": "- ID types: Can extend to include additional ID formats or systems\n- Email validation: Can add email format validation or filtering criteria\n- System scope: Can modify to include additional source systems\n- Mapping logic: Can customize ID-email relationship rules",
        "keywords": "ID mapping, email mapping, customer identification, cross-system integration, data unification",
        "domains": "data integration, customer identification, system integration, data management",
        "entities": "IDs, emails, customers, mapping tables, system integration",
        "complete_scenarios": "- Requests to create ID-to-email mapping across LOVB systems\n- Customer identification and unification projects\n- Cross-system data integration requiring email-based joins",
        "partial_scenarios": "- Different ID types or systems (modify ID extraction logic)\n- Additional validation criteria (extend email or ID validation)\n- Alternative mapping structures (adjust output schema)\n- Different source systems (modify data source queries)",
        "no_match_scenarios": "- This script does NOT handle: real-time ID resolution, duplicate email management, customer merge operations, data quality validation"
    },
    
    "fct_profile_merge_tracking": {
        "description": "Records and tracks profile merge operations within the ID graph system, logging merge details including source/target IDs, dates, and ID types",
        "outputs": "Profile merge tracking records with from_id, to_id, merge_date, and id_type for audit and lineage purposes",
        "questions": "- Which profile IDs have been merged and when?\n- What is the complete history of ID merge operations?\n- How do we track data lineage for merged customer profiles?\n- Which ID types are most commonly involved in merge operations?",
        "use_cases": "- Data Lineage: Maintain complete audit trail of profile merge operations\n- Customer Service: Understand customer ID history for support inquiries\n- Data Quality: Track and validate ID merge operations for accuracy\n- Analytics: Ensure accurate customer counting after profile consolidation",
        "parameters": "- Merge criteria: Can modify what constitutes a merge operation\n- ID types: Currently tracks 'lovfid', can extend to other ID types\n- Tracking frequency: Can adjust from manual to automated tracking\n- Additional metadata: Can add user, reason, or confidence scores",
        "keywords": "profile merges, ID graph, merge tracking, data lineage, customer consolidation",
        "domains": "data management, customer data platform, identity resolution, data lineage",
        "entities": "profiles, IDs, merges, tracking records, data lineage",
        "complete_scenarios": "- Requests to track profile merge operations in ID graph systems\n- Data lineage documentation for customer profile consolidation\n- Audit trail creation for ID merge operations",
        "partial_scenarios": "- Different ID types or merge criteria (modify tracking logic)\n- Additional merge metadata (extend tracking schema)\n- Automated tracking implementation (replace manual inserts)\n- Different ID graph structures (adapt to schema changes)",
        "no_match_scenarios": "- This script does NOT handle: automated profile merging, merge conflict resolution, real-time merge processing, merge validation"
    },

    "LOVB_2140_Error_Flagging_UAT": {
        "description": "Performs User Acceptance Testing (UAT) for Sprocket invoice error flagging rules by comparing custom QA checks against existing MuleSoft failure codes",
        "outputs": "UAT results comparing custom error flags with MuleSoft codes, validation accuracy metrics, rule effectiveness analysis",
        "questions": "- How effective are the proposed error flagging rules compared to existing MuleSoft validation?\n- Which custom QA checks identify errors not caught by current systems?\n- What is the accuracy and coverage of the new validation rules?\n- How do custom error flags correlate with existing failure codes?",
        "use_cases": "- Quality Assurance: Validate effectiveness of new error detection rules\n- System Integration: Compare custom validation with existing MuleSoft processes\n- Process Improvement: Identify gaps in current error detection capabilities\n- UAT Documentation: Provide evidence for system acceptance and deployment",
        "parameters": "- Validation rules: Currently 6 custom QA checks, can extend or modify criteria\n- Comparison logic: Can adjust how custom flags are compared with MuleSoft codes\n- Test data scope: Can modify date ranges or invoice selection criteria\n- Success metrics: Can customize accuracy and effectiveness measurements",
        "keywords": "UAT, error flagging, validation rules, MuleSoft comparison, QA testing, Sprocket validation",
        "domains": "quality assurance, system testing, validation processes, system integration",
        "entities": "error flags, validation rules, test results, UAT metrics, system comparison",
        "complete_scenarios": "- Requests for UAT of error flagging or validation rule systems\n- Comparison analysis between custom and existing validation processes\n- System acceptance testing for new validation rules",
        "partial_scenarios": "- Different validation systems or rules (modify comparison logic)\n- Alternative UAT criteria or metrics (adjust success measurements)\n- Different test data or scenarios (modify test case selection)\n- Additional validation dimensions (extend rule comparison)",
        "no_match_scenarios": "- This script does NOT handle: automated rule deployment, production validation, real-time error flagging, system configuration"
    }
}

def main():
    """Update remaining documentation files"""
    ad_hoc_dir = Path("/Users/kevin/Desktop/datathon-insight-memory/ad_hoc")
    
    updated_count = 0
    for folder_name, summary_data in remaining_files.items():
        # Find the documentation file for this folder
        folder_path = ad_hoc_dir / folder_name
        if folder_path.exists():
            md_files = list(folder_path.glob("*.md"))
            if md_files:
                md_file = md_files[0]  # Take the first markdown file
                
                # Check if already updated
                try:
                    with open(md_file, 'r', encoding='utf-8') as f:
                        content = f.read()
                        if "## AI Analysis Summary" in content:
                            print(f"Already updated: {md_file}")
                            continue
                except Exception:
                    continue
                
                # Create and insert AI summary
                ai_summary = create_ai_summary(**summary_data)
                
                if update_file(md_file, ai_summary):
                    print(f"Updated: {md_file}")
                    updated_count += 1
                else:
                    print(f"Failed to update: {md_file}")
    
    print(f"\nUpdated {updated_count} documentation files")

if __name__ == "__main__":
    main()
