/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE "%mon";
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-31' and '2019-12-31';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-31' and '2019-12-31';
SELECT name FROM animals WHERE neutered AND escape_attempts < 3;
SELECT name, date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Task2 - use gregates */
/* 1ST TRANSACTION */
BEGIN;
UPDATE animals
SET species = 'unspecified';
ROLLBACK;

/* 2ND TRANSACTION */
BEGIN;
UPDATE animals
SET species='digimon'
WHERE name LIKE '%mon'; 

UPDATE animals
SET species='pokemon'
WHERE species IS NULL; 

COMMIT;

/* 3RD TRANSACTION */
BEGIN;
DELETE FROM animals;
ROLLBACK;

/* 4th TRANSACTION */
 BEGIN;
 DELETE FROM animals
 WHERE date_of_birth > '2022-01-01';
 SAVEPOINT delet_born_after_2022;

UPDATE animals
SET weight_kg = weight_kg*-1;

ROLLBACK TO delet_born_after_2022;

UPDATE animals
SET weight_kg = weight_kg*-1
WHERE weight_kg < 0;
COMMIT;

/* How many animals are there? */
SELECT count(*) FROM animals;

/* How many animals have never tried to escape? */
SELECT count(*) FROM animals
WHERE escape_attempts=0;

/* What is the average weight of animals? */
SELECT AVG(weight_kg) FROM animals;

/* Who escapes the most, neutered or not neutered animals? */
SELECT neutered, MAX(escape_attempts) FROM animals
GROUP BY neutered;

/* What is the minimum and maximum weight of each type of animal? */
SELECT neutered, MAX(weight_kg), MIN(weight_kg) FROM animals
GROUP BY neutered;

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT neutered, AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
vet_clinic-# GROUP BY neutered;