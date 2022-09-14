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
GROUP BY neutered;

/* Foreign Key and JOIN session */
/* What animals belong to Melody Pond? */
SELECT A.name, O.full_name
FROM animals A
JOIN owners O ON A.owner_id = O.id
WHERE O.full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon). */
SELECT A.name, S.name
FROM animals A
JOIN species S ON  A.species_id = S.id
WHERE S.name = 'Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal. */
SELECT O.full_name, A.name
FROM owners O
LEFT JOIN animals A ON O.id = A.owner_id;

/* How many animals are there per species? */
SELECT S.name, COUNT(S.name)
FROM species S
JOIN animals A ON S.id = A.species_id
GROUP BY S.name;

/* List all Digimon owned by Jennifer Orwell. */
SELECT O.full_name, A.name, S.name
FROM animals A
JOIN owners O ON O.id = A.owner_id
JOIN species S ON A.species_id = S.id
WHERE S.name = 'Digimon' AND O.full_name = 'Jennifer Orwell';

/* List all animals owned by Dean Winchester that haven't tried to escape. */
SELECT A.name, A.escape_attempts, O.full_name
FROM animals A
JOIN owners O ON A.owner_id = O.id
WHERE A.escape_attempts = 0 AND O.full_name = 'Dean Winchester';

/* Who owns the most animals? */
FROM (SELECT ctn, ct.name AS name
FROM (SELECT COUNT(O.full_name) AS ctn, O.full_name As name
FROM owners O
JOIN animals A ON O.id = A.owner_id
GROUP BY O.full_name)ct)c2;