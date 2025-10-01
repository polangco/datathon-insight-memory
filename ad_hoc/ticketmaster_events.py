import os
import pandas as pd
from dotenv import load_dotenv
from datetime import datetime
import sqlalchemy

# Load environment variables from .env file
load_dotenv()

# Database connection parameters
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

# Base folder paths for input and output files
base_folder = "/Users/justinma/Downloads/TM1 Audience Downloads"
output_folder = "/Users/justinma/Downloads"

# List of CSV file paths and corresponding proMarket values
csv_files = [
    (f"{base_folder}/20250108 Atlanta Gateway Center.csv", "Atlanta", "Gateway Center Arena", "ATL01", "2025-01-08"),
    (f"{base_folder}/20250109 Houston Fort Bend Epicenter.csv", "Houston", "Fort Bend Epicenter", "HOU01", "2025-01-09"),
    (f"{base_folder}/20250110 Houston Fort Bend Epicenter.csv", "Houston", "Fort Bend Epicenter", "HOU02", "2025-01-10"),
    (f"{base_folder}/20250110 Weekend with Houston Fort Bend Epicenter.csv", "Houston", "Fort Bend Epicenter", "MADFH01/MADFH02", "2025-01-10"),
    (f"{base_folder}/20250115 Austin HEB Center.csv", "Austin", "H-E-B Center At Cedar Park", "AUSH01", "2025-01-15"),
    (f"{base_folder}/20250122 Salt Lake Lifetime Activities Center.csv", "Salt Lake", "Lifetime Activities Center", "SALB01", "2025-01-22"),
    (f"{base_folder}/20250129 Madison Alliant Energy Center.csv", "Madison", "Alliant Energy Center", "MADA01", "2025-01-29"),
    (f"{base_folder}/20250131 Atlanta Gateway Center Arena .csv", "Atlanta", "Gateway Center Arena", "ATL02", "2025-01-31"),
    (f"{base_folder}/20250201 Atlanta Gateway Center Arena .csv", "Atlanta", "Gateway Center Arena", "ATL03", "2025-02-01"),
    (f"{base_folder}/20250205 Austin HEB Center.csv", "Austin", "H-E-B Center At Cedar Park", "AUSH02", "2025-02-05"),
    (f"{base_folder}/20250207 Salt Lake Maverik Center.csv", "Salt Lake", "Maverik Center", "SALM01", "2025-02-07"),
    (f"{base_folder}/20250208 Salt Lake Maverik Center.csv", "Salt Lake", "Maverik Center", "SALM01/SALM02", "2025-02-08"),
    (f"{base_folder}/20250208 Weekend with Salt Lake Maverik Center.csv", "Salt Lake", "Maverik Center", "SALM02", "2025-02-08"),
    (f"{base_folder}/20250214 LOVB Classic Day 1 Municipal Auditorium .csv", "LOVB", "Municipal Auditorium", "CLASSIC01", "2025-02-14"),
    (f"{base_folder}/20250215 LOVB Classic Day 2 Municipal Auditorium .csv", "LOVB", "Municipal Auditorium", "CLASSIC02", "2025-02-15"),
    (f"{base_folder}/20250216 LOVB Classic Day 3 Municipal Auditorium .csv", "LOVB", "Municipal Auditorium", "CLASSIC03", "2025-02-16"),
    (f"{base_folder}/20250214-16 LOVB Classic 3day Municipal Auditorium.csv", "LOVB", "Municipal Auditorium", "CLASSIC04", "2025-02-16"),
    (f"{base_folder}/20250219 Austin HEB Center.csv", "Austin", "H-E-B Center At Cedar Park", "AUSH03", "2025-02-19"),
    (f"{base_folder}/20250220 Austin HEB Center.csv", "Austin", "H-E-B Center At Cedar Park", "AUSH04", "2025-02-20"),
    (f"{base_folder}/20250221 Atlanta Gateway Center Arena.csv", "Atlanta", "Gateway Center Arena", "ATL04", "2025-02-21"),
    (f"{base_folder}/20250227 Houston Fort Bend Epicenter.csv", "Houston", "Fort Bend Epicenter", "HOU03", "2025-02-27"),
    (f"{base_folder}/20250228 Madison Alliant Energy Center.csv", "Madison", "Alliant Energy Center", "MADA02", "2025-02-28"),
    (f"{base_folder}/20250228 Weekend with Madison Alliant Energy Center.csv", "Madison", "Alliant Energy Center", "MADA02/MADA03", "2025-02-28"),
    (f"{base_folder}/20250301 Madison Alliant Energy Center.csv", "Madison", "Alliant Energy Center", "MADA03", "2025-03-01"),
    (f"{base_folder}/20250307 Atlanta Gateway Center Arena.csv", "Atlanta", "Gateway Center Arena", "ATL05", "2025-03-07"),
    (f"{base_folder}/20250308 Atlanta Gateway Center Arena.csv", "Atlanta", "Gateway Center Arena", "ATL06", "2025-03-08"),
    (f"{base_folder}/20250313 Madison Alliant Energy Center.csv", "Madison", "Alliant Energy Center", "MADA04", "2025-03-13"),
    (f"{base_folder}/20250314 Houston Fort Bend Epicenter.csv", "Houston", "Fort Bend Epicenter", "HOU04", "2025-03-14"),
    (f"{base_folder}/20250315 Houston Fort Bend Epicenter.csv", "Houston", "Fort Bend Epicenter", "HOU05", "2025-03-15"),
    (f"{base_folder}/20250315 Weekend with Houston Fort Bend Epicenter.csv", "Houston", "Fort Bend Epicenter", "HOU04/HOU05", "2025-03-15"),
    (f"{base_folder}/20250320 Salt Lake Lifetime Activities Center.csv", "Salt Lake", "Lifetime Activities Center", "SALB02", "2025-03-20"),
    (f"{base_folder}/20250321 Omaha Baxter Arena.csv", "Omaha", "Baxter Arena", "OMAB01", "2025-03-21"),
    (f"{base_folder}/20250322 Omaha Baxter Arena.csv", "Omaha", "Baxter Arena", "OMAB02", "2025-03-22"),
    (f"{base_folder}/20250322 Weekend with Omaha Baxter Arena.csv", "Omaha", "Baxter Arena", "OMAB01/OMAB02", "2025-03-22"),
    (f"{base_folder}/20250327 Houston Fort Bend Epicenter .csv", "Houston", "Fort Bend Epicenter", "HOU06", "2025-03-27"),
    (f"{base_folder}/20250404 Salt Lake Lifetime Activities Center.csv", "Salt Lake", "Lifetime Activities Center", "SALB03", "2025-04-04"),
    (f"{base_folder}/20250405 Salt Lake Lifetime Activities Center.csv", "Salt Lake", "Lifetime Activities Center", "SALB04", "2025-04-05"),
    (f"{base_folder}/20250405 Weekend with Salt Lake Lifetime Activities Center - 01_02_2025.csv", "Salt Lake", "Lifetime Activities Center", "SALB03/SALB04", "2025-04-05"),
    # add LOVB Finals 2025
]

# Get the current date and time
current_time = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")

# Initialize an empty DataFrame
combined_df = pd.DataFrame()

# Loop through the files and their proMarket values
for file_path, pro_market_value, venue_value, event_name_value, event_date_value in csv_files:
    # Read the CSV into a DataFrame
    df = pd.read_csv(file_path)
    # Ensure email column exists (modify column name if necessary)
    if 'email' not in df.columns:
        raise ValueError(f"Missing 'email' column in {file_path}")
    # Add the proMarket column
    df['proMarket'] = pro_market_value
    # Add the venue column
    df['venue'] = venue_value
    # Add the event name
    df['event_name'] = event_name_value
    # Add the event date column 
    df['event_date'] = event_date_value
    # Add the last_modified column
    df['last_modified'] = current_time
    # Append to the combined DataFrame
    combined_df = pd.concat([combined_df, df], ignore_index=True)

# Establish a connection to PostgreSQL
engine = sqlalchemy.create_engine(f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# Load existing ticketmaster_events table into a DataFrame
query = "SELECT email, event_name FROM ticketmaster_events"
with engine.execution_options(stream_results=True).connect() as conn:
    existing_df = pd.read_sql(query, con=conn)

# Perform an anti-join (left join where right-side records are null)
merged_df = combined_df.merge(existing_df, on=['email', 'event_name'], how='left', indicator=True)
new_records_df = merged_df[merged_df['_merge'] == 'left_only'].drop(columns=['_merge'])

if not new_records_df.empty:
    # Insert only the new records into the database
    new_records_df.to_sql('ticketmaster_events', engine, if_exists='append', index=False)
    print(f"Inserted {len(new_records_df)} new records into ticketmaster_events.")
else:
    print("No new records to insert.")

# Save the combined DataFrame to a CSV file for backup
new_records_df.to_csv(f"{output_folder}/ticketmaster_new_events.csv", index=False)
print("New records saved to 'ticketmaster_new_events.csv'.")
