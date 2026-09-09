1. Loaded the two cleaned CSV files: cleaned_players_info.csv and cleaned_seasonal_stats.csv.
2. Checked the player IDs in both datasets to find unmatched players.
3. Merged the datasets using player_id from Seasonal Stats and id from Players Info.
4. Used an inner merge so only matching players were included in the final dataset.
5. Checked for duplicate rows after merging and removed them if found.
6. Checked for missing values in the merged dataset.
7. Found negative fantasy point values in the Seasonal Stats dataset.
8. Saved the final merged dataset as merged_players.csv.
9. The final dataset is ready.