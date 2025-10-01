import pandas as pd
import os

def compare_insiders_acva_phone_focus():
    """
    Compare all insiders with consolidated ACVA data, focusing on phone number availability:
    - Overlap between datasets
    - Email engagement (opened/clicked) for insiders
    - Phone number availability and distribution
    - Follow-up opportunities based on phone availability
    """
    
    # File paths
    data_dir = ".data"
    insiders_file = os.path.join(data_dir, "insiders_20250710.csv")
    acva_file = os.path.join(data_dir, "consolidated_acva_sweepstakes_data.csv")
    
    print("Reading insiders file...")
    insiders_df = pd.read_csv(insiders_file)
    print(f"Insiders file loaded: {len(insiders_df)} rows")
    
    print("Reading consolidated ACVA file...")
    acva_df = pd.read_csv(acva_file)
    print(f"ACVA file loaded: {len(acva_df)} rows")
    
    # Clean email addresses (remove whitespace, convert to lowercase for matching)
    insiders_df['EMAIL_CLEAN'] = insiders_df['EMAIL'].str.strip().str.lower()
    acva_df['email_clean'] = acva_df['email'].str.strip().str.lower()
    
    # Find overlap between datasets
    insiders_emails = set(insiders_df['EMAIL_CLEAN'].dropna())
    acva_emails = set(acva_df['email_clean'].dropna())
    
    overlap_emails = insiders_emails.intersection(acva_emails)
    
    print(f"\n=== OVERLAP ANALYSIS ===")
    print(f"Total insiders: {len(insiders_df)}")
    print(f"Total ACVA recipients: {len(acva_df)}")
    print(f"Insiders who appear in ACVA data: {len(overlap_emails)}")
    print(f"Overlap percentage: {len(overlap_emails) / len(insiders_df) * 100:.1f}%")
    
    # Create merged dataset for analysis
    merged_df = insiders_df.merge(
        acva_df[['email_clean', 'opened', 'clicked', 'variant_name']], 
        left_on='EMAIL_CLEAN', 
        right_on='email_clean', 
        how='inner'
    )
    
    print(f"\n=== ENGAGEMENT ANALYSIS FOR INSIDERS ===")
    print(f"Insiders in ACVA data: {len(merged_df)}")
    print(f"Insiders who opened: {merged_df['opened'].sum()}")
    print(f"Insiders who clicked: {merged_df['clicked'].sum()}")
    print(f"Open rate for insiders: {merged_df['opened'].sum() / len(merged_df) * 100:.1f}%")
    print(f"Click rate for insiders: {merged_df['clicked'].sum() / len(merged_df) * 100:.1f}%")
    
    # Phone number availability analysis
    print(f"\n=== PHONE NUMBER AVAILABILITY ANALYSIS ===")
    
    # Overall phone availability
    total_insiders_in_acva = len(merged_df)
    insiders_with_phone = merged_df['PHONE_NUMBER'].notna() & (merged_df['PHONE_NUMBER'] != '')
    print(f"Insiders in ACVA data with phone numbers: {insiders_with_phone.sum()}/{total_insiders_in_acva} ({insiders_with_phone.sum()/total_insiders_in_acva*100:.1f}%)")
    
    # Phone availability by engagement
    insiders_opened = merged_df[merged_df['opened'] == True]
    insiders_clicked = merged_df[merged_df['clicked'] == True]
    
    insiders_opened_with_phone = insiders_opened['PHONE_NUMBER'].notna() & (insiders_opened['PHONE_NUMBER'] != '')
    insiders_clicked_with_phone = insiders_clicked['PHONE_NUMBER'].notna() & (insiders_clicked['PHONE_NUMBER'] != '')
    
    print(f"Insiders who opened with phone numbers: {insiders_opened_with_phone.sum()}/{len(insiders_opened)} ({insiders_opened_with_phone.sum()/len(insiders_opened)*100:.1f}%)")
    print(f"Insiders who clicked with phone numbers: {insiders_clicked_with_phone.sum()}/{len(insiders_clicked)} ({insiders_clicked_with_phone.sum()/len(insiders_clicked)*100:.1f}%)")
    
    # High-value segments for follow-up
    print(f"\n=== HIGH-VALUE FOLLOW-UP SEGMENTS ===")
    
    # Segment 1: Engaged insiders with phone numbers
    engaged_with_phone = merged_df[
        (merged_df['opened'] == True) & 
        (merged_df['PHONE_NUMBER'].notna()) & 
        (merged_df['PHONE_NUMBER'] != '')
    ]
    print(f"Insiders who opened AND have phone numbers: {len(engaged_with_phone)}")
    
    # Segment 2: Highly engaged insiders with phone numbers
    highly_engaged_with_phone = merged_df[
        (merged_df['clicked'] == True) & 
        (merged_df['PHONE_NUMBER'].notna()) & 
        (merged_df['PHONE_NUMBER'] != '')
    ]
    print(f"Insiders who clicked AND have phone numbers: {len(highly_engaged_with_phone)}")
    
    # Segment 3: All insiders with phone numbers (regardless of engagement)
    all_with_phone = merged_df[
        (merged_df['PHONE_NUMBER'].notna()) & 
        (merged_df['PHONE_NUMBER'] != '')
    ]
    print(f"All insiders with phone numbers: {len(all_with_phone)}")
    
    # Variant performance by phone availability
    print(f"\n=== VARIANT PERFORMANCE BY PHONE AVAILABILITY ===")
    variant_counts = merged_df['variant_name'].value_counts()
    
    for variant, count in variant_counts.items():
        variant_data = merged_df[merged_df['variant_name'] == variant]
        opened_count = variant_data['opened'].sum()
        clicked_count = variant_data['clicked'].sum()
        phone_count = (variant_data['PHONE_NUMBER'].notna() & (variant_data['PHONE_NUMBER'] != '')).sum()
        engaged_with_phone_count = len(variant_data[
            (variant_data['opened'] == True) & 
            (variant_data['PHONE_NUMBER'].notna()) & 
            (variant_data['PHONE_NUMBER'] != '')
        ])
        
        print(f"{variant}: {count} insiders, {opened_count} opened, {clicked_count} clicked, {phone_count} with phones, {engaged_with_phone_count} engaged with phones")
    
    # Phone number distribution analysis
    print(f"\n=== PHONE NUMBER DISTRIBUTION ANALYSIS ===")
    
    # Phone availability by engagement level
    no_engagement = merged_df[merged_df['opened'] == False]
    opened_only = merged_df[(merged_df['opened'] == True) & (merged_df['clicked'] == False)]
    clicked = merged_df[merged_df['clicked'] == True]
    
    print(f"No engagement: {len(no_engagement)} insiders, {(no_engagement['PHONE_NUMBER'].notna() & (no_engagement['PHONE_NUMBER'] != '')).sum()} with phones ({(no_engagement['PHONE_NUMBER'].notna() & (no_engagement['PHONE_NUMBER'] != '')).sum()/len(no_engagement)*100:.1f}%)")
    print(f"Opened only: {len(opened_only)} insiders, {(opened_only['PHONE_NUMBER'].notna() & (opened_only['PHONE_NUMBER'] != '')).sum()} with phones ({(opened_only['PHONE_NUMBER'].notna() & (opened_only['PHONE_NUMBER'] != '')).sum()/len(opened_only)*100:.1f}%)")
    print(f"Clicked: {len(clicked)} insiders, {(clicked['PHONE_NUMBER'].notna() & (clicked['PHONE_NUMBER'] != '')).sum()} with phones ({(clicked['PHONE_NUMBER'].notna() & (clicked['PHONE_NUMBER'] != '')).sum()/len(clicked)*100:.1f}%)")
    
    # Detailed breakdown of insiders without phone numbers
    print(f"\n=== INSIDERS WITHOUT PHONE NUMBERS ===")
    insiders_no_phone = merged_df[~insiders_with_phone]
    print(f"Insiders in ACVA data without phone numbers: {len(insiders_no_phone)}")
    
    if len(insiders_no_phone) > 0:
        no_phone_engaged = insiders_no_phone['opened'].sum()
        no_phone_clicked = insiders_no_phone['clicked'].sum()
        print(f"Insiders without phones who opened: {no_phone_engaged} ({no_phone_engaged/len(insiders_no_phone)*100:.1f}%)")
        print(f"Insiders without phones who clicked: {no_phone_clicked} ({no_phone_clicked/len(insiders_no_phone)*100:.1f}%)")
    
    # Export detailed results
    output_file = os.path.join(data_dir, "insiders_acva_phone_analysis.csv")
    merged_df.to_csv(output_file, index=False)
    print(f"\nDetailed comparison results exported to: {output_file}")
    
    # Export high-value segments for follow-up
    engaged_phone_file = os.path.join(data_dir, "engaged_insiders_with_phones.csv")
    engaged_with_phone.to_csv(engaged_phone_file, index=False)
    print(f"Engaged insiders with phone numbers exported to: {engaged_phone_file}")
    
    highly_engaged_phone_file = os.path.join(data_dir, "highly_engaged_insiders_with_phones.csv")
    highly_engaged_with_phone.to_csv(highly_engaged_phone_file, index=False)
    print(f"Highly engaged insiders with phone numbers exported to: {highly_engaged_phone_file}")
    
    all_phone_file = os.path.join(data_dir, "all_insiders_with_phones.csv")
    all_with_phone.to_csv(all_phone_file, index=False)
    print(f"All insiders with phone numbers exported to: {all_phone_file}")
    
    return merged_df, engaged_with_phone, highly_engaged_with_phone, all_with_phone

if __name__ == "__main__":
    compare_insiders_acva_phone_focus() 