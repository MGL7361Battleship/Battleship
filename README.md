Battleship
Ce projet est un prototype de Battleship r�alis� en Elixir par PAQUET Benoit et EUGENE Audrey dans le cadre du cours MGL7361 � l'UQAM. Le jeu est � deux joueurs o� chacun d'eux poss�de une grille de 11x9 cases pour placer leurs diff�rents bateaux. Chaque devra attquer les positions de la grille o� l'adversaire � pos� ses bateau; si toutes les cases d'un bateau ont �t� touch�es, ce dernier est d�clar� ��coul頻. Le gagnant est celui qui parvient � couler tous les bateaux de son adversaire.


Installation
Pour pouvoir ex�cuter le prototype, il faudra tout d'abord s'assurer de faire les actions suivantes�:
T�l�charger les logiciels PostSQL (pour les bases de donn�es), Node.js et Elixir.
D�marrer votre serveur Pheonix�:
Installation des d�pendances avec mix deps.get 
Cr�ation et migration des donn�es avec mix ecto.create && mix ecto.migrate 
Installation des d�pendances Node.js avec cd assets && npm install 
D�marrage de Phoenix avec mix phx.server 

Vous pouvez maintenant visiter localhost:4000 depuis votre navigateur.

Ex�cution
Pour ex�cuter le prototype, vous devez d�marrer le serveur avec mix phx.server et utiliser les api d�velopp�s pour jouer. Voici les actions que vous pouvez effectuer�:
Phase de pr�paration
changer_nom_joueur(id_joueur, nom_joueur)
positionner_bateau(id_joueur, nom_bateau, position, orientation)
enlever_bateau(id_joueur, nom_bateau)
rotation_bateau(id_joueur, nom_bateau)
Phase de jeu
attaquer_position(id_joueur_attaquant, id_joueur_attaque, position)
obtenir_etat_partie(id_joueur, id_joueur _adverse)