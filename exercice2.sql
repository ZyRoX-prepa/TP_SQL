-- ===========================================================================
-- EXERCICE 2 – Base de données « Presse »
-- Schéma :
--   Journal   (CodeJournal, Titre, Prix, Type, Périodicité)
--   Dépôt     (CodeDépôt, NomDépôt, Adresse)
--   Livraison (CodeJournal, CodeDépôt, DateLivraison, QuantitéLivrée)
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 1. CRÉATION DES TABLES
-- ---------------------------------------------------------------------------

CREATE TABLE Journal (
    CodeJournal  INT           PRIMARY KEY,
    Titre        VARCHAR(100)  NOT NULL,
    Prix         DECIMAL(10,2) NOT NULL,
    Type         VARCHAR(50)   NOT NULL,
    Periodicite  VARCHAR(50)   NOT NULL
);

CREATE TABLE Depot (
    CodeDepot INT          PRIMARY KEY,
    NomDepot  VARCHAR(100) NOT NULL,
    Adresse   VARCHAR(200) NOT NULL
);

CREATE TABLE Livraison (
    CodeJournal    INT  NOT NULL,
    CodeDepot      INT  NOT NULL,
    DateLivraison  DATE NOT NULL,
    QuantiteLivree INT  NOT NULL,
    PRIMARY KEY (CodeJournal, CodeDepot, DateLivraison),
    FOREIGN KEY (CodeJournal) REFERENCES Journal(CodeJournal),
    FOREIGN KEY (CodeDepot)   REFERENCES Depot(CodeDepot)
);

-- ---------------------------------------------------------------------------
-- 2. ALIMENTATION DE LA BASE DE DONNÉES
-- ---------------------------------------------------------------------------

INSERT INTO Journal VALUES
    (1, 'Le Matin',               5.00,  'Quotidien',  'Quotidienne'),
    (2, 'L''Economiste',          8.00,  'Economie',   'Hebdomadaire'),
    (3, 'TelQuel',               15.00,  'Société',    'Mensuelle'),
    (4, 'La Vie Eco',            10.00,  'Economie',   'Hebdomadaire'),
    (5, 'Aujourd''hui le Maroc',  5.00,  'Quotidien',  'Quotidienne');

INSERT INTO Depot VALUES
    (1, 'Dépôt Rabat Centre', 'Rabat'),
    (2, 'Dépôt Casablanca',   'Casablanca'),
    (3, 'Dépôt Fès',          'Fès'),
    (4, 'Dépôt Rabat Agdal',  'Rabat');

-- Dépôt 1 (Rabat Centre)  : journaux 1, 2, 3
-- Dépôt 2 (Casablanca)    : journaux 1, 2, 3, 4, 5  ← reçoit TOUS les journaux
-- Dépôt 3 (Fès)           : journaux 1, 4
-- Dépôt 4 (Rabat Agdal)   : journaux 2, 3, 4, 5
INSERT INTO Livraison VALUES
    (1, 1, '2024-01-01', 100),
    (2, 1, '2024-01-01',  50),
    (3, 1, '2024-01-01',  30),
    (1, 2, '2024-01-01', 200),
    (2, 2, '2024-01-01', 100),
    (3, 2, '2024-01-01',  60),
    (4, 2, '2024-01-01',  80),
    (5, 2, '2024-01-01', 120),
    (1, 3, '2024-01-01',  40),
    (4, 3, '2024-01-01',  35),
    (2, 4, '2024-01-01',  45),
    (3, 4, '2024-01-01',  25),
    (4, 4, '2024-01-01',  55),
    (5, 4, '2024-01-01',  90);

-- ---------------------------------------------------------------------------
-- 3. EXPRESSIONS EN ALGÈBRE RELATIONNELLE + TRADUCTION SQL
-- ---------------------------------------------------------------------------

-- ── Requête 1 ──────────────────────────────────────────────────────────────
-- Donner le prix des journaux
--
-- Algèbre relationnelle :
--   π Titre, Prix (Journal)
--
-- Résultat attendu : couples (Titre, Prix) pour chaque journal
SELECT Titre, Prix
FROM   Journal;

-- ── Requête 2 ──────────────────────────────────────────────────────────────
-- Donner tous les renseignements sur les journaux hebdomadaires
--
-- Algèbre relationnelle :
--   σ Périodicité='Hebdomadaire' (Journal)
--
-- Résultat attendu : L'Economiste, La Vie Eco
SELECT *
FROM   Journal
WHERE  Periodicite = 'Hebdomadaire';

-- ── Requête 3 ──────────────────────────────────────────────────────────────
-- Donner les journaux livrés à Rabat
--
-- Algèbre relationnelle :
--   π Titre (
--       Journal
--       ⋈_{Journal.CodeJournal = Livraison.CodeJournal}
--       (Livraison
--        ⋈_{Livraison.CodeDépôt = Dépôt.CodeDépôt}
--        σ_{Adresse='Rabat'} (Dépôt))
--   )
--
-- Résultat attendu : Le Matin, L'Economiste, TelQuel, La Vie Eco,
--                    Aujourd'hui le Maroc
SELECT DISTINCT J.Titre
FROM   Journal J
JOIN   Livraison L ON J.CodeJournal = L.CodeJournal
JOIN   Depot    D ON L.CodeDepot   = D.CodeDepot
WHERE  D.Adresse = 'Rabat';

-- ── Requête 4 ──────────────────────────────────────────────────────────────
-- Donner les dépôts qui ont reçu tous les journaux
--
-- Algèbre relationnelle (division) :
--   R1 ← π CodeDépôt, CodeJournal (Livraison)
--   R2 ← π CodeJournal (Journal)
--   R3 ← R1 ÷ R2
--   Résultat : π NomDépôt (R3 ⋈ Dépôt)
--
-- En SQL (avec NOT EXISTS / double négation) :
--   Un dépôt D a reçu tous les journaux
--   ⟺ il n'existe aucun journal qui n'ait PAS été livré à D
--
-- Résultat attendu : Dépôt Casablanca
SELECT D.NomDepot, D.Adresse
FROM   Depot D
WHERE  NOT EXISTS (
    SELECT J.CodeJournal
    FROM   Journal J
    WHERE  NOT EXISTS (
        SELECT 1
        FROM   Livraison L
        WHERE  L.CodeJournal = J.CodeJournal
          AND  L.CodeDepot   = D.CodeDepot
    )
);
