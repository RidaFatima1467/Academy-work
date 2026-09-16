# Week 2 Day 5 — AFL Match Context Integration

## Steps

1. Loaded the Round-by-Round Player dataset and Team Match dataset and checked their columns.

2. Identified the common fields and used a composite key of `team`, `year`, `round`, and `match_date` to merge both datasets. Team names and date formats were cleaned before merging.

3. Added `home_away`, `venue`, and `crowd` columns to the player dataset and validated the merge by checking unmatched records, duplicate records, and row counts.

4. Analyzed player performance for home and away matches, crowd size versus fantasy points, and average fantasy points by venue.

5. Created charts to visualize the analysis and prepared a data quality report describing the merge, data issues, and assumptions.