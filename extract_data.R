### PRÉPARATION DE DONNÉES POUR UN PROJET ÉTUDIANT SUR LA TRAME VERTE
### OCTOBRE / NOVEMBRE 2025

# Packages
library(tidyverse)


####################################################
################ Données Population ################
####################################################

# URL : https://catalogue-donnees.insee.fr/fr/explorateur/DS_RP_POPULATION_PRINC
# Filtre en ligne sur arrondissements 11 et 12 de Marseille puis téléchargement des 198 lignes
population_raw <- read_delim("data/in/DS_RP_POPULATION_PRINC2.csv", ";") |> 
  mutate(OBS_VALUE = round(OBS_VALUE, 0))
