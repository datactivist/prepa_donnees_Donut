### PRÉPARATION DE DONNÉES POUR UN PROJET ÉTUDIANT SUR LA TRAME VERTE
### OCTOBRE / NOVEMBRE 2025

# Packages
library(tidyverse)


####################################################
################ Données BPE #######################
####################################################

# URL : https://catalogue-donnees.insee.fr/fr/explorateur/DS_BPE
# Filtre en ligne sur arrondissements 11 et 12 de Marseille puis téléchargement des lignes
bpe <- read_delim("data/in/DS_BPE.csv", ";") |> 
  summarise(`Nombre d'équipements` = sum(OBS_VALUE),
        .by = c(GEO, FACILITY_DOM)) |> 
  mutate(`Type d'équipement` = case_match(FACILITY_DOM, 
                                           "A" ~ "Services pour les particuliers",
                                           "B" ~ "Commerces",
                                           "C" ~ "Enseignement",
                                           "D" ~ "Sané et action sociale",
                                           "E" ~ "Transports et déplacements",
                                           "F" ~ "Sports, loisirs et culture",
                                           "G" ~ "Tourisme",
                                           "_T" ~ "Total")) |> 
  select(`Type d'équipement`,`Nombre d'équipements`, GEO) |> 
  rename(COG = GEO) |> 
  mutate(Arrondissement = ifelse(COG == 13211, "Marseille 11", "Marseille 12"),
         Code_postal = ifelse(COG == 13211, 13011, 13012)) |> 
  arrange(desc(Arrondissement))
rio::export(bpe, "data/out/Nombre equipements 2024.csv")


#URL: https://public.opendatasoft.com/explore/assets/buildingref-france-bpe-all-geolocated/export/?page=1&refine=com_arm_name%3AMarseille+11e+Arrondissement&refine=com_arm_name%3AMarseille+12e+Arrondissement
#BPE équipements localisés
bpe_loc <- read_delim("https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/buildingref-france-bpe-all-geolocated/exports/csv/?delimiters=%3B&lang=fr&refine=com_arm_name%3AMarseille+11e+Arrondissement&refine=com_arm_name%3AMarseille+12e+Arrondissement&timezone=Europe%2FParis&use_labels=true", ";") |> 
  select(`Geo Point`, `Geo Shape`, `Code Officiel Commune / Arrondissement Municipal`, Description, Catégorie) |> 
  rename(Type = Catégorie,
         COG = `Code Officiel Commune / Arrondissement Municipal`,
         Équipement = Description) |> 
  mutate(Arrondissement = ifelse(COG == 13211, "Marseille 11", "Marseille 12"),
         Code_postal = ifelse(COG == 13211, 13011, 13012)) |> 
  arrange(desc(Arrondissement)) |> 
  select(Équipement, Type, `Geo Point`, `Geo Shape`, Arrondissement, COG, Code_postal)
rio::export(bpe_loc, "data/out/Localisation equipements 2021.csv")




####################################################
################ Données DPE #######################
####################################################

# URL : https://observatoire-dpe-audit.ademe.fr/donnees-dpe-publiques
# Filtre en ligne sur arrondissements 11 et 12 de Marseille puis téléchargement des lignes
dpe <- read_csv("data/in/dpe03existant (1).csv")
dpe_clean <- dpe |> 
  distinct() |> 
  filter(!is.na(annee_construction)) |> 
  summarise(`Nombre de logements` = n(), .by = c(annee_construction, code_insee_ban)) |> 
  rename(COG = code_insee_ban,
         `Année de construction` = annee_construction) |> 
  mutate(Arrondissement = ifelse(COG == 13211, "Marseille 11", "Marseille 12"),
         Code_postal = ifelse(COG == 13211, 13011, 13012)) |> 
  select(`Année de construction`, `Nombre de logements`, Arrondissement, COG, Code_postal) |> 
  arrange(desc(Arrondissement), `Année de construction`)
rio::export(dpe_clean, "data/out/Annee construction log evol.csv")




####################################################
################ Données DVF #######################
####################################################

# URL : https://www.data.gouv.fr/datasets/5c4ae55a634f4117716d5656/
dvf <- read_delim("data/in/ValeursFoncieres-2024.txt", "|")
dvf_clean <- dvf |> 
  filter(`Code postal` %in% c(13011, 13012)) |> 
  select(`Valeur fonciere`, Voie, `Code postal`)

#Finalement : application DVF utilisée 



