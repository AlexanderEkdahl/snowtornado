CREATE VIEW product_subcategory AS
SELECT products.id,
       products.name,
       products.producer,
       array_to_json(array(SELECT v.value
                           FROM attributes
                           LEFT JOIN (SELECT *
                                      FROM attribute_values
                                      WHERE attribute_values.product_id = products.id) AS v
                           ON attributes.id = v.attribute_id
                           ORDER BY attributes.id))
FROM products
JOIN subcategories
ON products.subcategory_id = subcategories.id
WHERE subcategories.name = 'TV'
ORDER BY products.id;

CREATE VIEW matches_subcategory AS
SELECT original_id, replacement_id, date_trunc('second', timestamp) as timestamp
FROM matches
WHERE matches.original_id IN (SELECT id FROM product_subcategory) AND
      matches.replacement_id IN (SELECT id FROM product_subcategory) AND
      matches.original_id <> matches.replacement_id
ORDER BY timestamp ASC;

CREATE VIEW stock_exchange AS
SELECT store_product_stock_exchange.aggregate_id,
       store_product_mapping.mapped_to_upptec_product as product_id,
       date_trunc('second', timestamp),
       stock_status
FROM store_product_stock_exchange
JOIN store_product_mapping ON store_product_mapping.aggregate_id = store_product_stock_exchange.aggregate_id
WHERE store_product_mapping.mapped_to_upptec_product IS NOT null AND store_product_mapping.mapped_to_upptec_product IN (SELECT id FROM product_subcategory)
ORDER BY aggregate_id, timestamp;

\copy (SELECT name FROM attributes ORDER BY attributes.id) TO 'attributes.csv' DELIMITER ',' CSV
\copy (SELECT * FROM stock_exchange) TO 'stock_exchange.csv' DELIMITER ',' CSV
\copy (SELECT * FROM matches_subcategory) TO 'matches.csv' DELIMITER ',' CSV
\copy (SELECT * FROM product_subcategory) TO 'products.csv' DELIMITER ',' CSV

DROP VIEW stock_exchange;
DROP VIEW matches_subcategory;
DROP VIEW product_subcategory;
