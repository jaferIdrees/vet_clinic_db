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
SELECT COUNT(O.full_name) AS count, O.full_name
FROM animals A
JOIN owners O ON A.owner_id = O.id
GROUP BY O.full_name
ORDER BY count DESC
LIMIT 1;

/* Write queries to answer the following: */
/* 1- Who was the last animal seen by William Tatcher? */
SELECT name FROM animals WHERE id =
(SELECT animal_id
FROM(SELECT date, animal_id
FROM visits
WHERE vet_id = 1) AS dat
WHERE date = (SELECT MAX(date) FROM(SELECT date, animal_id
FROM visits
WHERE vet_id = 1)dt));

/* 2-How many different animals did Stephanie Mendez see? */
SELECT count(*) 
FROM 
(SELECT V.name, A.name
FROM visits
JOIN animals AS A ON A.id = visits.animal_id
JOIN vets AS V ON V.id = visits.vet_id
WHERE V.name = 'Stephanie Mendez');

/* 3-List all vets and their specialties, including vets with no specialties. */
SELECT V.name, S.name
FROM vets AS V
LEFT JOIN specializations AS SP ON V.id = SP.vet_id
LEFT JOIN species AS S ON S.id = SP.species_id;

/* 4-List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */
SELECT V.name, A.name
FROM visits AS VT
JOIN vets AS V ON V.id = VT.vet_id
JOIN animals AS A ON A.id = VT.animal_id
WHERE (V.name = 'Stephanie Mendez') AND (VT.date BETWEEN '2020-04-01' AND '2020-08-30');

/* 5-What animal has the most visits to vets? */
SELECT A.name, COUNT(A.name)
FROM visits AS VT 
JOIN animals AS A ON A.id = VT.animal_id
GROUP BY A.name
ORDER BY count DESC
LIMIT 1;
/* Who was Maisy Smith's first visit? */
SELECT name FROM animals WHERE id =
(SELECT animal_id
FROM(SELECT date, animal_id
FROM visits
WHERE vet_id = 2) AS dat
WHERE date = (SELECT MIN(date) FROM(SELECT date, animal_id
FROM visits
WHERE vet_id = 2)dt));

/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT A.name AS Animal_Name, A.date_of_birth AS Animal_DOB, V.name AS Vet_Name, VT.date AS Visit_Date
FROM visits AS VT
JOIN animals AS A ON A.id = VT.animal_id
JOIN vets AS V ON V.id = VT.vet_id
ORDER BY VT.date DESC
LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(*)
FROM visits AS VT
JOIN vets AS V ON V.id = VT.vet_id
JOIN specializations AS SP ON SP.vet_id = V.id
JOIN animals AS A ON A.id = VT.animal_id
WHERE A.species_id != SP.species_id;

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT COUNT(S.name), S.name, V.name
FROM visits AS VT
JOIN vets AS V ON VT.vet_id = V.id
JOIN animals AS A ON A.id = VT.animal_id
JOIN species AS S ON S.id = A.species_id
WHERE V.name = 'Maisy Smith'
GROUP BY V.name, S.name
ORDER BY count DESC
LIMIT 1;