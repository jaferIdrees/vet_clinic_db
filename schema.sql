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

/* forth session - Add join table for Visits */
/* Create a table named vets */
CREATE TABLE vets (
    name varchar(100),
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    age int,
    date_of_graduation date
);

/* Create a "join table" called specializations */
CREATE TABLE specializations (
    species_id INT,
    vet_id INT,
    PRIMARY KEY (species_id,vet_id)
);

/* Create a "join table" called visits */
CREATE TABLE visits (
    animal_id INT,
    vet_id INT,
    date date,
    PRIMARY KEY (animal_id,vet_id, date)
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

ALTER TABLE visits RENAME COLUMN date TO date_of_visit;

DROP TABLE visits;

CREATE TABLE visits(
  id INT GENERATED ALWAYS AS IDENTITY,
  animal_id INT REFERENCES animals(id),
  vet_id INT REFERENCES vets(id),
  date_of_visit DATE,
  PRIMARY KEY(id)
);


/* Optimize"SELECT COUNT(*) FROM visits where animal_id = 4;"query */
CREATE INDEX animal_id_asc ON visits(animal_id ASC);


/* Optimize "SELECT * FROM visits where vet_id = 2;" query */
CREATE INDEX vet_id_asc ON visits(vet_id ASC);

/* Optimize"SELECT * FROM owners where email = 'owner_18327@mail.com';"query */
CREATE INDEX email_asc ON owners(email ASC);
