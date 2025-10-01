import pandas as pd

folder = '/Users/seanhoward/Library/CloudStorage/GoogleDrive-sean.howard@lovb.com/My Drive/marketing analytics/'

df = pd.read_csv(f'{folder}/LOVB_2519_customer_profile_segments_ltv.csv')

df_sub = df[['lovpid', 'is_active_club_member', 'is_non_active_club_member', 'is_insider', 'is_merch_purchaser', 'is_single_match_purchaser', 'is_season_ticket_holder']]

# Unpivot df_sub to get one record per lovpid and is_ column
df_unpivoted = df_sub.melt(id_vars=['lovpid'], var_name='variable', value_name='value')

df_unpivoted = df_unpivoted[df_unpivoted['value'] == 1]

# Group by lovpid and aggregate variables into a list and count them
df_agg = df_unpivoted.groupby('lovpid').agg(
    segments=('variable', lambda x: tuple(sorted(x))),
    segment_count=('variable', 'count')
).reset_index()

# Convert segments from tuple to string for better readability (optional)
df_agg['segments'] = df_agg['segments'].apply(lambda x: ', '.join(x))

df_final = df_agg.groupby(['segments', 'segment_count']).size().reset_index(name='count').sort_values(by=['segment_count', 'count'], ascending=False)

df_final.to_clipboard()






