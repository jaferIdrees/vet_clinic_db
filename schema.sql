/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    name varchar(100),
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_of_birth date,
    escape_attempts int,
    neutered boolean,
    weight_kg decimal
);

/* Second session */

ALTER TABLE animals
ADD COLUMN species varchar(50);

/* Third session Foreign Keys and JOIN */

CREATE TABLE owners (
    full_name varchar(100),
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    age int
);

CREATE TABLE species (
    name varchar(100),
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
);

ALTER TABLE animals
DROP COLUMN species;

/* Add column species_id which is a foreign key referencing species table */
ALTER TABLE animals 
ADD COLUMN species_id INT;

ALTER TABLE animals 
ADD CONSTRAINT species_id 
FOREIGN KEY (species_id) 
REFERENCES species (id);

/* Add column owner_id which is a foreign key referencing the owners table */
ALTER TABLE animals 
ADD COLUMN owner_id INT;

ALTER TABLE animals 
ADD CONSTRAINT owner_id 
FOREIGN KEY (owner_id) 
REFERENCES owners (id);