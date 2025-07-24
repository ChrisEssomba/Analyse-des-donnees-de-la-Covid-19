# 🌍 Projet d’Analyse et de Visualisation des Données COVID-19

Ce projet illustre une chaîne complète d’analyse de données en utilisant **Python**, **SQL** et **Tableau**. Il se concentre sur l’analyse de l’impact de la pandémie de **COVID-19**, à travers les tendances de la **mortalité** et de la **vaccination**. L’analyse se déroule en trois étapes principales : **nettoyage des données**, **intégration et analyse SQL**, et **visualisation**.

---

## 📁 Structure du projet

├── Analyse/

│ ├── AnalysisRequests.sql - Intégration et analyse SQL

│ └── owid-covid-data.csv - Jeu de données combiné (Our World in Data)

├── Nettoyage_Données/

│ ├── covidDeathsCleaning.ipynb - Traitement des données de mortalité

│ ├── covidVaccinationCleaning.ipynb - Traitement des données de vaccination

│ ├── coviddeaths.csv - Données brutes de mortalité

│ ├── covidVac.csv - Données brutes de vaccination

│ ├── coviddeathsCleaned.csv - Données de mortalité traitées

│ └── covidVacCleaned.csv - Données de vaccination traitées

├── Visualisation/

│ └── RapportDeProjetCovid.pdf - Rapport d'analyse avec liens Tableau

---

## ⚙️ Technologies utilisées

- **Python** : Nettoyage et prétraitement des données (Pandas, Jupyter Notebooks)
- **SQL** : Intégration et analyse des données (Jointures, Agrégations, Filtres)
- **Tableau Public** : Visualisation de données et création de dashboard interactif  
  🔗 [Voir le dashboard sur Tableau Public](https://public.tableau.com/app/profile/chris.essomba/viz/CovidDeathsVisualization_16845886904710/Tableaudebord1)

---

## 🔍 Principaux enseignements

Les objectifs analytiques incluent notamment :

- Suivi des décès liés au COVID-19 par pays et dans le temps
- Évaluation de la couverture vaccinale mondiale
- Analyse de la corrélation entre taux de vaccination et réduction de la mortalité
- Visualisation des tendances régionales clés à travers des graphiques interactifs

---

## 📊 Rapport de visualisation

L’étape finale du projet est la narration visuelle via **Tableau**. Le rapport comprend :

- Graphiques comparatifs décès vs vaccinations
- Cartes illustrant les disparités régionales
- Séries temporelles sur l’évolution de la vaccination

📄 Le résumé de l’analyse est disponible ici :  
`Visualization/RapportDeProjetCovid.pdf`

---

## 🚀 Pour démarrer

Pour reproduire ou adapter ce projet :

1. Cloner ce dépôt.
2. Ouvrir les notebooks dans `Data Cleaning/` et exécuter les étapes de nettoyage.
3. Lancer les requêtes SQL dans l’outil SQL de votre choix (SQLite, PostgreSQL, etc.).
4. Importer les données finales dans Tableau pour générer vos propres visualisations.

---

## 📌 Sources

- Données de mortalité et de vaccination : [Our World in Data](https://ourworldindata.org/covid-deaths)
- Outil de visualisation : [Tableau Public](https://www.tableau.com)

---
