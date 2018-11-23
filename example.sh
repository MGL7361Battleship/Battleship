#!/bin/bash

# Initialiser les joueurs

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 0, "nom_joueur": "PREMIER JOUEUR"}' \
    http://localhost:4000/api/changer_nom_joueur

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 1, "nom_joueur": "DEUXIEME JOUEUR"}' \
    http://localhost:4000/api/changer_nom_joueur


# Placer les bateaux du premier joueur

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 0, "nom_bateau": "torpilleur", "position": "A1", "orientation": "horizontal"}' \
    http://localhost:4000/api/positionner_bateau

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 0, "nom_bateau": "contre-torpilleur", "position": "A7", "orientation": "vertical"}' \
    http://localhost:4000/api/positionner_bateau

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 0, "nom_bateau": "sous-marin", "position": "B2", "orientation": "horizontal"}' \
    http://localhost:4000/api/positionner_bateau

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 0, "nom_bateau": "porte-avion", "position": "C5", "orientation": "vertical"}' \
    http://localhost:4000/api/positionner_bateau

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 0, "nom_bateau": "croiseur", "position": "H1", "orientation": "horizontal"}' \
    http://localhost:4000/api/positionner_bateau


# Placer les bateaux du deuxième joueur

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 1, "nom_bateau": "torpilleur", "position": "G7", "orientation": "vertical"}' \
    http://localhost:4000/api/positionner_bateau

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 1, "nom_bateau": "contre-torpilleur", "position": "G1", "orientation": "vertical"}' \
    http://localhost:4000/api/positionner_bateau

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 1, "nom_bateau": "sous-marin", "position": "D2", "orientation": "vertical"}' \
    http://localhost:4000/api/positionner_bateau

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 1, "nom_bateau": "porte-avion", "position": "E6", "orientation": "horizontal"}' \
    http://localhost:4000/api/positionner_bateau

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 1, "nom_bateau": "croiseur", "position": "G5", "orientation": "vertical"}' \
    http://localhost:4000/api/positionner_bateau



# Attaques

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur_attaquant": 0, "id_joueur_attaque": 1, "position": "G5"}' \
    http://localhost:4000/api/attaquer_position

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur_attaquant": 1, "id_joueur_attaque": 0, "position": "B3"}' \
    http://localhost:4000/api/attaquer_position

curl -H "Content-Type: application/json" -X POST \
    -d '{"id_joueur": 0, "id_joueur_adverse": 1}' \
    http://localhost:4000/api/obtenir_etat_partie
