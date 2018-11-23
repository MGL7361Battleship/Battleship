Battleship
Ce projet est un prototype de Battleship réalisé en Elixir par PAQUET Benoit et EUGENE Audrey dans le cadre du cours MGL7361 à l'UQAM. Le jeu est à deux joueurs où chacun d'eux possède une grille de 11x9 cases pour placer leurs différents bateaux. Chaque devra attquer les positions de la grille où l'adversaire à posé ses bateau; si toutes les cases d'un bateau ont été touchées, ce dernier est déclaré « coulé ». Le gagnant est celui qui parvient à couler tous les bateaux de son adversaire.


Installation
Pour pouvoir exécuter le prototype, il faudra tout d'abord s'assurer de faire les actions suivantes :
Télécharger les logiciels PostSQL (pour les bases de données), Node.js et Elixir.
Démarrer votre serveur Pheonix :
Installation des dépendances avec mix deps.get 
Création et migration des données avec mix ecto.create && mix ecto.migrate 
Installation des dépendances Node.js avec cd assets && npm install 
Démarrage de Phoenix avec mix phx.server 

Vous pouvez maintenant visiter localhost:4000 depuis votre navigateur.

Exécution
Pour exécuter le prototype, vous devez démarrer le serveur avec mix phx.server et utiliser les api développés pour jouer. Voici les actions que vous pouvez effectuer :
Phase de préparation
changer_nom_joueur(id_joueur, nom_joueur)
positionner_bateau(id_joueur, nom_bateau, position, orientation)
enlever_bateau(id_joueur, nom_bateau)
rotation_bateau(id_joueur, nom_bateau)
Phase de jeu
attaquer_position(id_joueur_attaquant, id_joueur_attaque, position)
obtenir_etat_partie(id_joueur, id_joueur _adverse)