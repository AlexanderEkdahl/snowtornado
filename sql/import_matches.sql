CREATE TABLE matches (
    original_id integer,
    replacement_id integer,
    price integer,
    timestamp timestamp
)

\copy matches FROM 'matches.csv' DELIMITER ',' CSV
