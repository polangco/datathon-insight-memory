#!/usr/bin/env python3
"""
Batch update documentation files with LLM-optimized AI Analysis Summary sections
"""

import os
import re
from pathlib import Path

# Define the AI Analysis Summary template
AI_ANALYSIS_TEMPLATE = """## AI Analysis Summary

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

def update_documentation_file(file_path, ai_summary):
    """Update a documentation file with AI Analysis Summary"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find the position after the title and before Executive Summary
        title_match = re.search(r'^# (.+)\n\n', content, re.MULTILINE)
        exec_summary_match = re.search(r'^## Executive Summary', content, re.MULTILINE)
        
        if title_match and exec_summary_match:
            # Insert AI Analysis Summary between title and Executive Summary
            title_end = title_match.end()
            new_content = (
                content[:title_end] + 
                ai_summary + 
                "\n" + 
                content[title_end:]
            )
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            
            print(f"Updated: {file_path}")
            return True
        else:
            print(f"Could not find insertion point in: {file_path}")
            return False
            
    except Exception as e:
        print(f"Error updating {file_path}: {e}")
        return False

# File-specific AI summaries
file_summaries = {
    "LOVB_1937___historical_registrations": {
        "description": "Extracts and formats historical registration data from NetSuite for specific clubs and timeframes, creating temporary tables for invoices and items",
        "outputs": "Two temporary tables with formatted invoice and item data for specific clubs and date ranges",
        "questions": "- What are the historical registrations for specific clubs in a given timeframe?\n- How do we format NetSuite data for analysis and reporting?\n- What are the program and package details for historical registrations?",
        "use_cases": "- Analytics: Historical performance analysis for specific clubs\n- Operations: Data migration and system integration support\n- Finance: Historical revenue and registration tracking\n- Reporting: Formatted data for external reporting requirements",
        "parameters": "- Club selection: Currently clubs 79, 76, 81, can modify for other clubs\n- Date ranges: Currently May-December 2024, easily adjustable\n- Data formatting: Can modify date formats and field selections\n- Table naming: Can customize temporary table names and schemas",
        "keywords": "historical registrations, NetSuite, club data, temporary tables, data formatting",
        "domains": "data migration, historical analysis, club operations, system integration",
        "entities": "registrations, clubs, invoices, items, programs, packages",
        "complete_scenarios": "- Requests for historical registration data for specific clubs and periods\n- NetSuite data extraction and formatting for analysis\n- Club-specific historical performance analysis",
        "partial_scenarios": "- Different clubs or date ranges (modify filters)\n- Alternative data formatting requirements (adjust field selections)\n- Different output destinations (modify table creation logic)\n- Additional data enrichment (extend joins and calculations)",
        "no_match_scenarios": "- This script does NOT handle: real-time data, comprehensive club analysis, financial calculations, customer-level details"
    },
    
    "LOVB_2147_Proposed_Sprocket_Rule_Set": {
        "description": "Defines comprehensive validation rules for Sprocket invoice data including accrual dates, program duration, registration timing, and accounting codes",
        "outputs": "Validation results with pass/fail flags for multiple business rules, error categorization, testing dataset",
        "questions": "- Which Sprocket invoices fail specific business validation rules?\n- What are the most common data quality issues in Sprocket data?\n- How do we standardize validation rules across invoice processing?\n- Which records need manual review or correction?",
        "use_cases": "- Data Quality: Implement standardized validation rules for invoice processing\n- Operations: Identify and resolve data quality issues before system integration\n- Finance: Ensure accurate accounting code assignments and date validations\n- Compliance: Maintain consistent business rule enforcement across systems",
        "parameters": "- Validation rules: Currently 6 rule categories, can extend or modify criteria\n- Date ranges: Can filter for specific processing periods\n- Rule thresholds: Can adjust duration limits and timing validations\n- Error categorization: Can customize error messages and severity levels",
        "keywords": "Sprocket validation, business rules, data quality, invoice validation, error flagging",
        "domains": "data quality, invoice processing, business rule validation, system integration",
        "entities": "invoices, validation rules, business rules, data quality, error flags",
        "complete_scenarios": "- Requests to validate Sprocket invoice data against business rules\n- Implementation of standardized data quality checks\n- Error identification and categorization for invoice processing",
        "partial_scenarios": "- Different validation criteria or thresholds (modify rule logic)\n- Additional business rules (extend validation framework)\n- Different data sources (adapt to other invoice systems)\n- Alternative error handling approaches (modify flagging logic)",
        "no_match_scenarios": "- This script does NOT handle: automated error correction, real-time validation, customer notifications, payment processing"
    }
}

def main():
    """Main function to update documentation files"""
    ad_hoc_dir = Path("/Users/kevin/Desktop/datathon-insight-memory/ad_hoc")
    
    # Find all markdown files that need updating
    md_files = list(ad_hoc_dir.glob("**/*.md"))
    
    # Filter out template and index files
    exclude_files = ["LLM_Documentation_Template.md", "README_Documentation_Index.md"]
    md_files = [f for f in md_files if f.name not in exclude_files]
    
    print(f"Found {len(md_files)} documentation files to potentially update")
    
    updated_count = 0
    for md_file in md_files:
        # Check if file already has AI Analysis Summary
        try:
            with open(md_file, 'r', encoding='utf-8') as f:
                content = f.read()
                if "## AI Analysis Summary" in content:
                    print(f"Already updated: {md_file}")
                    continue
        except Exception as e:
            print(f"Error reading {md_file}: {e}")
            continue
        
        # Extract folder name for matching
        folder_name = md_file.parent.name
        
        if folder_name in file_summaries:
            summary_data = file_summaries[folder_name]
            ai_summary = AI_ANALYSIS_TEMPLATE.format(**summary_data)
            
            if update_documentation_file(md_file, ai_summary):
                updated_count += 1
        else:
            print(f"No summary defined for: {folder_name}")
    
    print(f"\nUpdated {updated_count} documentation files")

if __name__ == "__main__":
    main()
