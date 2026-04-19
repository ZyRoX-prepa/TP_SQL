-- ===========================================================================
-- EXERCICE 5 – Base de données « Bibliothèque »
-- Schéma :
--   Etudiant (NumEtd, NomEtd, PrenomEdt, AdresseEtd)
--   Livre    (NumLivre, TitreLivre, NumAuteur, NumEditeur, NumTheme, AnneeEdition)
--   Auteur   (NumAuteur, NomAuteur, AdresseAuteur)
--   Editeur  (NumEditeur, NomEditeur, AdresseEditeur)
--   Theme    (NumTheme, IntituléTheme)
--   Prêt     (NumEtd, NumLivre, DatePret, DateRetour)
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 1. CRÉATION DES TABLES
-- ---------------------------------------------------------------------------

CREATE TABLE Etudiant (
    NumEtd      INT          PRIMARY KEY,
    NomEtd      VARCHAR(50)  NOT NULL,
    PrenomEdt   VARCHAR(50)  NOT NULL,
    AdresseEtd  VARCHAR(200) NOT NULL
);

CREATE TABLE Auteur (
    NumAuteur      INT          PRIMARY KEY,
    NomAuteur      VARCHAR(100) NOT NULL,
    AdresseAuteur  VARCHAR(200) NOT NULL
);

CREATE TABLE Editeur (
    NumEditeur      INT          PRIMARY KEY,
    NomEditeur      VARCHAR(100) NOT NULL,
    AdresseEditeur  VARCHAR(200) NOT NULL
);

CREATE TABLE Theme (
    NumTheme      INT          PRIMARY KEY,
    IntituleTheme VARCHAR(100) NOT NULL
);

CREATE TABLE Livre (
    NumLivre      INT          PRIMARY KEY,
    TitreLivre    VARCHAR(200) NOT NULL,
    NumAuteur     INT          NOT NULL,
    NumEditeur    INT          NOT NULL,
    NumTheme      INT          NOT NULL,
    AnneeEdition  INT          NOT NULL,
    FOREIGN KEY (NumAuteur)  REFERENCES Auteur(NumAuteur),
    FOREIGN KEY (NumEditeur) REFERENCES Editeur(NumEditeur),
    FOREIGN KEY (NumTheme)   REFERENCES Theme(NumTheme)
);

CREATE TABLE Pret (
    NumEtd       INT  NOT NULL,
    NumLivre     INT  NOT NULL,
    DatePret     DATE NOT NULL,
    DateRetour   DATE,
    PRIMARY KEY (NumEtd, NumLivre, DatePret),
    FOREIGN KEY (NumEtd)   REFERENCES Etudiant(NumEtd),
    FOREIGN KEY (NumLivre) REFERENCES Livre(NumLivre)
);

-- ---------------------------------------------------------------------------
-- 2. ALIMENTATION DE LA BASE DE DONNÉES
-- ---------------------------------------------------------------------------

INSERT INTO Etudiant VALUES
    (1, 'Alami',   'Khalid',   '12 rue Hassan II, Rabat'),
    (2, 'Benali',  'Sara',     '5 av. Mohammed V, Casablanca'),
    (3, 'Chafik',  'Omar',     '8 rue des Oudayas, Rabat'),
    (4, 'Darif',   'Imane',    '3 bd Zerktouni, Fès');

INSERT INTO Auteur VALUES
    (1, 'Alami',   '10 rue Ibn Sina, Rabat'),
    (2, 'Azzizi',  '22 av. FAR, Casablanca'),
    (3, 'Bennis',  '7 bd Allal, Fès'),
    (4, 'Chraibi', '15 rue Oqba, Marrakech'),
    (5, 'Daoud',   '30 av. Hasan II, Agadir');

INSERT INTO Editeur VALUES
    (1, 'Kalila wa Dimna',  'Rabat'),
    (2, 'Dar Al Kitab',     'Casablanca'),
    (3, 'Toubkal',          'Casablanca');

INSERT INTO Theme VALUES
    (1, 'Informatique'),
    (2, 'Mathématiques'),
    (3, 'Littérature'),
    (4, 'Histoire');

INSERT INTO Livre VALUES
    (10, 'BD Sindibad',           1, 1, 1, 2020),
    (11, 'Bases de données',      1, 2, 1, 2018),
    (12, 'Algorithmes avancés',   2, 1, 2, 2019),
    (13, 'Contes du Maghreb',     2, 3, 3, 2021),
    (14, 'SQL pratique',          5, 1, 1, 2022),
    (15, 'Algèbre linéaire',      3, 2, 2, 2017),
    (16, 'Réseaux informatiques', 4, 3, 1, 2023);

INSERT INTO Pret VALUES
    (1, 10, '2024-01-10', '2024-01-24'),
    (2, 11, '2024-02-05', '2024-02-19'),
    (3, 12, '2024-03-01', '2024-03-15'),
    (1, 14, '2024-04-10', NULL);
-- Le livre 13, 15 et 16 n'ont jamais été empruntés

-- ---------------------------------------------------------------------------
-- 3. EXPRESSIONS EN ALGÈBRE RELATIONNELLE + TRADUCTION SQL
-- ---------------------------------------------------------------------------

-- ── Requête 1 ──────────────────────────────────────────────────────────────
-- Le nom, le prénom et l'adresse de l'étudiant de nom 'Alami'
--
-- Algèbre relationnelle :
--   π NomEtd, PrenomEdt, AdresseEtd ( σ NomEtd='Alami' (Etudiant) )
--
SELECT NomEtd, PrenomEdt, AdresseEtd
FROM   Etudiant
WHERE  NomEtd = 'Alami';

-- ── Requête 2 ──────────────────────────────────────────────────────────────
-- Le numéro de l'auteur 'Alami'
--
-- Algèbre relationnelle :
--   π NumAuteur ( σ NomAuteur='Alami' (Auteur) )
--
SELECT NumAuteur
FROM   Auteur
WHERE  NomAuteur = 'Alami';

-- ── Requête 3 ──────────────────────────────────────────────────────────────
-- La liste des livres de l'auteur numéro 5
--
-- Algèbre relationnelle :
--   π NumLivre, TitreLivre ( σ NumAuteur=5 (Livre) )
--
SELECT NumLivre, TitreLivre
FROM   Livre
WHERE  NumAuteur = 5;

-- ── Requête 4 ──────────────────────────────────────────────────────────────
-- Les livres de l'auteur 'Alami'
--
-- Algèbre relationnelle :
--   π TitreLivre (
--       Livre
--       ⋈_{Livre.NumAuteur = Auteur.NumAuteur}
--       σ NomAuteur='Alami' (Auteur)
--   )
--
SELECT L.TitreLivre
FROM   Livre L
JOIN   Auteur A ON L.NumAuteur = A.NumAuteur
WHERE  A.NomAuteur = 'Alami';

-- ── Requête 5 ──────────────────────────────────────────────────────────────
-- Le nom et l'adresse de l'auteur du livre 'BD Sindibad'
--
-- Algèbre relationnelle :
--   π NomAuteur, AdresseAuteur (
--       Auteur
--       ⋈_{Auteur.NumAuteur = Livre.NumAuteur}
--       σ TitreLivre='BD Sindibad' (Livre)
--   )
--
SELECT A.NomAuteur, A.AdresseAuteur
FROM   Auteur A
JOIN   Livre  L ON A.NumAuteur = L.NumAuteur
WHERE  L.TitreLivre = 'BD Sindibad';

-- ── Requête 6 ──────────────────────────────────────────────────────────────
-- Les livres de l'auteur 'Alami' édités chez l'éditeur 'Kalila wa Dimna'
--
-- Algèbre relationnelle :
--   π TitreLivre (
--       σ NomAuteur='Alami' (Auteur)
--       ⋈ Livre ⋈
--       σ NomEditeur='Kalila wa Dimna' (Editeur)
--   )
--
SELECT L.TitreLivre
FROM   Livre   L
JOIN   Auteur  A ON L.NumAuteur  = A.NumAuteur
JOIN   Editeur E ON L.NumEditeur = E.NumEditeur
WHERE  A.NomAuteur  = 'Alami'
  AND  E.NomEditeur = 'Kalila wa Dimna';

-- ── Requête 7 ──────────────────────────────────────────────────────────────
-- Les livres de l'auteur 'Alami' ou 'Azzizi'
--
-- Algèbre relationnelle (union) :
--   π TitreLivre (Livre ⋈ σ NomAuteur='Alami'  (Auteur))
--   ∪
--   π TitreLivre (Livre ⋈ σ NomAuteur='Azzizi' (Auteur))
--
-- Forme équivalente (disjonction dans la sélection) :
--   π TitreLivre (
--       Livre ⋈ σ NomAuteur='Alami' ∨ NomAuteur='Azzizi' (Auteur)
--   )
--
SELECT L.TitreLivre
FROM   Livre  L
JOIN   Auteur A ON L.NumAuteur = A.NumAuteur
WHERE  A.NomAuteur = 'Alami'
   OR  A.NomAuteur = 'Azzizi';

-- ── Requête 8 ──────────────────────────────────────────────────────────────
-- Les livres qui n'ont jamais été empruntés
--
-- Algèbre relationnelle (différence) :
--   π NumLivre, TitreLivre (Livre)
--   −
--   π NumLivre, TitreLivre (Livre ⋈_{Livre.NumLivre = Prêt.NumLivre} Prêt)
--
SELECT L.NumLivre, L.TitreLivre
FROM   Livre L
WHERE  L.NumLivre NOT IN (
    SELECT P.NumLivre
    FROM   Pret P
);
