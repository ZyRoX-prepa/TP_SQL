# Exercice 3 – Arbres d'algèbre relationnelle (Exercice 2)

Les quatre arbres ci-dessous correspondent aux requêtes de l'exercice 2.  
Conventions : **σ** = sélection · **π** = projection · **⋈** = jointure · **÷** = division

---

## Requête 1 – Donner le prix des journaux

```
π Titre, Prix
     │
  Journal
```

---

## Requête 2 – Donner tous les renseignements sur les journaux hebdomadaires

```
σ Périodicité='Hebdomadaire'
           │
        Journal
```

---

## Requête 3 – Donner les journaux livrés à Rabat

```
              π Titre
                 │
                 ⋈  (Journal.CodeJournal = Livraison.CodeJournal)
               ┌─┴─────────────────────────┐
           Journal                         ⋈  (Livraison.CodeDépôt = Dépôt.CodeDépôt)
                                         ┌─┴──────────────────────┐
                                      Livraison         σ Adresse='Rabat'
                                                                   │
                                                                 Dépôt
```

---

## Requête 4 – Donner les dépôts qui ont reçu tous les journaux

La requête utilise l'opérateur de **division** ( ÷ ).

```
              π NomDépôt, Adresse
                      │
                      ⋈  (R3.CodeDépôt = Dépôt.CodeDépôt)
                    ┌─┴─────────────────┐
                   R3 = R1 ÷ R2       Dépôt
                    │
              ┌─────┴──────────────────────────┐
              │                                │
     R1 = π CodeDépôt, CodeJournal     R2 = π CodeJournal
                   │                              │
              Livraison                        Journal
```
