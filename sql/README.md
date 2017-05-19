# Database operations

1. Import data into database:
    1. Put ```matches.csv``` and ```whalewolf``` in ```sql``` directory
    2. ```createdb whalewolf```
    3. ```pg_restore -d whalewolf --no-owner whalewolf```
    4. Import matches ```psql whalewolf < import_matches.sql```
    5. Import stock movements ```psql --quiet --single-transaction whalewolf < store_product_stock_exchange```
    5. Import stock mappings ```psql --quiet --single-transaction whalewolf < store_product_mapping```
2. Create auxiliary views by running ```psql whalewolf < create_views.sql```

## Exporting a category

1. Change category in ```export_subcategory.sql```
2. Execute ```psql whalewolf < export_subcategory.sql```
3. Execute ```ruby pivot_products.rb```
4. Copy to data folder by running ```mv products.csv matches.csv stock_exchange.csv ../data/```

## Creating a new database dump

```pg_dump --format c --file dump.db --no-acl whalewolf```
