DROP VIEW IF EXISTS products;
DROP VIEW IF EXISTS subcategories;
DROP VIEW IF EXISTS categories;
DROP VIEW IF EXISTS attributes;
DROP VIEW IF EXISTS attribute_values;

CREATE VIEW products AS
SELECT idpr AS id,
       pr09 AS name,
       pr11 AS price,
       pr01 AS description,
       pr18 AS weight,
       pr20 AS ean,
       pr21 AS measurements,
       pr15 AS subcategory_id,
       producent.pt30 AS producer
FROM pdprodukt
JOIN producent
ON pdprodukt.pr10 = producent.idpt
WHERE pr31 IS true;

CREATE VIEW subcategories AS
SELECT idka AS id, ka01 AS name, ka03 AS description, ka02 AS category_id
FROM pdkategori;

CREATE VIEW categories AS
SELECT idhk AS id, hk00 AS name
FROM pdhuvudkategori;

CREATE VIEW attributes AS
SELECT idet AS id, et04 AS name, et00 AS description
FROM pdegentyp
WHERE et01 = 'Lista';

CREATE VIEW attribute_values AS
SELECT eg00 as attribute_id,
       eg02 as product_id,
       eg01 as value
FROM pdegenskap;
