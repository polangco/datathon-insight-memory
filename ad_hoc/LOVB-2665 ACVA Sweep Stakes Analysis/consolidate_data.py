import pandas as pd
import os

def consolidate_data():
    """
    Consolidate three CSV files into a single dataframe with specified columns:
    - user_id (character)
    - email (character) 
    - variant_name (character)
    - opened (boolean)
    - clicked (boolean)
    """
    
    # File paths
    data_dir = ".data"
    recipients_file = os.path.join(data_dir, "Recipients_of_AVCA_Sweepstakes_2025_-_First_Serve_export 2.csv")
    click_file = os.path.join(data_dir, "Insights_ACVA_SweepStakes_-_Click_export.csv")
    open_file = os.path.join(data_dir, "Insights_ACVA_SweepStakes_-_Open_export.csv")
    
    print("Reading recipients file...")
    # Read recipients file (base file with all users)
    recipients_df = pd.read_csv(recipients_file)
    print(f"Recipients file loaded: {len(recipients_df)} rows")
    
    print("Reading click file...")
    # Read click file
    click_df = pd.read_csv(click_file)
    print(f"Click file loaded: {len(click_df)} rows")
    
    print("Reading open file...")
    # Read open file
    open_df = pd.read_csv(open_file)
    print(f"Open file loaded: {len(open_df)} rows")
    
    # Create base dataframe from recipients with required columns
    print("Creating base dataframe...")
    base_df = recipients_df[['user_id', 'email', 'variation_name']].copy()
    
    # Rename variation_name to variant_name for consistency
    base_df = base_df.rename(columns={'variation_name': 'variant_name'})
    
    # Initialize opened and clicked columns as False
    base_df['opened'] = False
    base_df['clicked'] = False
    
    print(f"Base dataframe created: {len(base_df)} rows")
    
    # Mark users who opened emails
    print("Marking users who opened emails...")
    open_user_ids = set(open_df['user_id'].dropna())
    base_df.loc[base_df['user_id'].isin(open_user_ids), 'opened'] = True
    print(f"Users who opened: {len(open_user_ids)}")
    
    # Mark users who clicked emails
    print("Marking users who clicked emails...")
    click_user_ids = set(click_df['user_id'].dropna())
    base_df.loc[base_df['user_id'].isin(click_user_ids), 'clicked'] = True
    print(f"Users who clicked: {len(click_user_ids)}")
    
    # Ensure data types are correct
    base_df['user_id'] = base_df['user_id'].astype(str)
    base_df['email'] = base_df['email'].astype(str)
    base_df['variant_name'] = base_df['variant_name'].astype(str)
    base_df['opened'] = base_df['opened'].astype(bool)
    base_df['clicked'] = base_df['clicked'].astype(bool)
    
    # Summary statistics
    print("\n=== SUMMARY ===")
    print(f"Total users: {len(base_df)}")
    print(f"Users who opened: {base_df['opened'].sum()}")
    print(f"Users who clicked: {base_df['clicked'].sum()}")
    print(f"Users who opened but didn't click: {(base_df['opened'] & ~base_df['clicked']).sum()}")
    print(f"Users who clicked but didn't open: {(~base_df['opened'] & base_df['clicked']).sum()}")
    
    # Variant distribution
    print("\n=== VARIANT DISTRIBUTION ===")
    variant_counts = base_df['variant_name'].value_counts()
    for variant, count in variant_counts.items():
        opened_count = base_df[base_df['variant_name'] == variant]['opened'].sum()
        clicked_count = base_df[base_df['variant_name'] == variant]['clicked'].sum()
        print(f"{variant}: {count} total, {opened_count} opened, {clicked_count} clicked")
    
    return base_df

def export_consolidated_data():
    """
    Export the consolidated data to CSV
    """
    df = consolidate_data()
    
    output_file = ".data/consolidated_acva_sweepstakes_data.csv"
    df.to_csv(output_file, index=False)
    print(f"\nConsolidated data exported to: {output_file}")
    
    # Display first few rows
    print("\n=== FIRST 10 ROWS ===")
    print(df.head(10))
    
    return df

if __name__ == "__main__":
    export_consolidated_data() 