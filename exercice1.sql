-- ===========================================================================
-- EXERCICE 1 – Base de données « Organisme de voyage »
-- Schéma :
--   Station  (NomStation, Capacité, Lieu, Région)
--   Activité (NomStation, CodeActivité, Libellé, Prix)
--   Client   (CodeClient, Nom, Prénom, Ville, Région)
--   Séjour   (CodeClient, NomStation, DateDébut, Durée, NbPlaces)
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 1. CRÉATION DES TABLES
-- ---------------------------------------------------------------------------

CREATE TABLE Station (
    NomStation VARCHAR(50)  PRIMARY KEY,
    Capacite   INT          NOT NULL,
    Lieu       VARCHAR(100) NOT NULL,
    Region     VARCHAR(50)  NOT NULL
);

CREATE TABLE Activite (
    NomStation   VARCHAR(50)   NOT NULL,
    CodeActivite VARCHAR(10)   NOT NULL,
    Libelle      VARCHAR(100)  NOT NULL,
    Prix         DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (NomStation, CodeActivite),
    FOREIGN KEY (NomStation) REFERENCES Station(NomStation)
);

CREATE TABLE Client (
    CodeClient INT          PRIMARY KEY,
    Nom        VARCHAR(50)  NOT NULL,
    Prenom     VARCHAR(50)  NOT NULL,
    Ville      VARCHAR(100) NOT NULL,
    Region     VARCHAR(50)  NOT NULL
);

CREATE TABLE Sejour (
    CodeClient INT          NOT NULL,
    NomStation VARCHAR(50)  NOT NULL,
    DateDebut  DATE         NOT NULL,
    Duree      INT          NOT NULL,
    NbPlaces   INT          NOT NULL,
    PRIMARY KEY (CodeClient, NomStation, DateDebut),
    FOREIGN KEY (CodeClient) REFERENCES Client(CodeClient),
    FOREIGN KEY (NomStation) REFERENCES Station(NomStation)
);

-- ---------------------------------------------------------------------------
-- 2. ALIMENTATION DE LA BASE DE DONNÉES
-- ---------------------------------------------------------------------------

INSERT INTO Station VALUES
    ('Agadir',       500, 'Côte Atlantique',  'Souss-Massa'),
    ('Marrakech',    300, 'Piedmont',          'Marrakech-Safi'),
    ('Ifrane',       150, 'Moyen Atlas',       'Ifrane'),
    ('Ouarzazate',   200, 'Vallée du Drâa',    'Drâa-Tafilalet'),
    ('Chefchaouen',  100, 'Rif',               'Tanger-Tétouan');

INSERT INTO Activite VALUES
    ('Agadir',      'SURF',  'Surf',        250.00),
    ('Agadir',      'VOILE', 'Voile',       350.00),
    ('Marrakech',   'RAND',  'Randonnée',   150.00),
    ('Marrakech',   'EQUIT', 'Équitation',  200.00),
    ('Ifrane',      'SKI',   'Ski',         400.00),
    ('Ifrane',      'VOILE', 'Voile',       300.00),
    ('Ouarzazate',  'RAND',  'Randonnée',   120.00),
    ('Chefchaouen', 'RAND',  'Randonnée',   100.00);

INSERT INTO Client VALUES
    (1, 'Alami',     'Karim',     'Rabat',       'Rabat-Salé'),
    (2, 'Benali',    'Sara',      'Casablanca',  'Casablanca-Settat'),
    (3, 'Cherkaoui', 'Mohammed',  'Fès',         'Fès-Meknès'),
    (4, 'Dahbi',     'Aïcha',     'Marrakech',   'Marrakech-Safi'),
    (5, 'Ezzouali',  'Youssef',   'Agadir',      'Souss-Massa');

INSERT INTO Sejour VALUES
    (1, 'Agadir',      '2024-07-01', 7,  2),
    (1, 'Ifrane',      '2024-12-20', 5,  1),
    (2, 'Marrakech',   '2024-08-15', 10, 3),
    (3, 'Agadir',      '2024-07-10', 7,  4),
    (4, 'Ifrane',      '2024-01-05', 3,  2),
    (5, 'Ouarzazate',  '2024-05-01', 14, 1);

-- ---------------------------------------------------------------------------
-- 3. REQUÊTES – RÉSULTATS ATTENDUS
-- ---------------------------------------------------------------------------

-- Requête 1 : σ region='Ifrane' (Station)
-- → Les stations situées dans la région Ifrane
-- Résultat attendu : (Ifrane, 150, Moyen Atlas, Ifrane)
SELECT *
FROM   Station
WHERE  Region = 'Ifrane';

-- Requête 2 : π NomStation, region (Station)
-- → Projection sur le nom de station et la région
SELECT NomStation, Region
FROM   Station;

-- Requête 3 : π region (Station)
-- → Liste des régions (sans doublons)
SELECT DISTINCT Region
FROM   Station;

-- Requête 4 : Station × Activité
-- → Produit cartésien : toutes les combinaisons possibles
SELECT *
FROM   Station, Activite;

-- Requête 5 : Station ⋈_{NomStation=NomStation} Activité
-- → Jointure naturelle entre Station et Activité sur NomStation
SELECT Station.NomStation, Capacite, Lieu, Region,
       CodeActivite, Libelle, Prix
FROM   Station
JOIN   Activite ON Station.NomStation = Activite.NomStation;

-- Requête 6 : σ capacité>200 ( σ region='Marrakech' (Station) )
-- → Stations de Marrakech avec une capacité supérieure à 200
-- Résultat attendu : (Marrakech, 300, Piedmont, Marrakech-Safi)
SELECT *
FROM   Station
WHERE  Region = 'Marrakech-Safi'
  AND  Capacite > 200;

-- Requête 7 : σ capacité>1000 ∧ region='Ifrane' (Station)
-- → Stations d'Ifrane avec une capacité supérieure à 1000
-- Résultat attendu : (aucune ligne – aucune station ne satisfait les deux conditions)
SELECT *
FROM   Station
WHERE  Capacite > 1000
  AND  Region = 'Ifrane';

-- Requête 8 : π NomStation ( σ CodeActivité='voile' (Activité) )
-- → Noms des stations proposant l'activité « voile »
-- Résultat attendu : Agadir, Ifrane
SELECT DISTINCT NomStation
FROM   Activite
WHERE  CodeActivite = 'VOILE';

-- Requête 9 : π NomStation (Station) − π NomStation ( σ CodeActivité='voile' (Activité) )
-- → Stations ne proposant PAS l'activité « voile »
-- Résultat attendu : Marrakech, Ouarzazate, Chefchaouen
SELECT NomStation
FROM   Station
WHERE  NomStation NOT IN (
    SELECT NomStation
    FROM   Activite
    WHERE  CodeActivite = 'VOILE'
);
