# scriptOCprojet1
 projet1 création d'utilisateurs dans l'Active Directory depuis un fichier utilisateurs.csv
***
# Pour Commencer
Ce script a été réalisé dans le cadre d'un projet "script 1" projet 7 pour OpenClassrooms
***

# Pré-requis
serveur Windows 2019 avec Active Directory
Création d'un fichier utilisateurs.CSV encodée UF8 avec ; comme séparateur. La conversion du fichier peut etre réalisé depuis Excel.
Le fichier sera placé dans le répertoire c:\Scripts\AD_USERS
Le script fonctionne aussi bien en silencieux que en mode interactif, le détail d'utilisation est expliqué dans le paragraphe suivant.

***
# Démarrage
comment on lance le script
Deux méthodes pour l'utilisation du script , soit silencieuse ou interactif en indiquant le nom du nouvel utilisateur

##Script Silencieux
Le script se lance soit de manière silencieuse de la manière suivante 
.\script1github.ps1 ou ./scriptgithub.ps1 >c:\Scripts\AD_USERS\script1.txt si l'on veut récupérer le résultat du script.

##Script Interactif
./scriptgithub.ps1 nom_d_utilisateur
Ce mode doit etre utilisé si on veut créer un seul utilisateur avec des renseignements de base.
Le détail des renseignements se trouve dans le paragraphe suivant à la fonction Get-info

***
# Installation / Explication 


##4 fonctions principales
CreaUser
ExistUser
CreaUserSeul
Get-info

###CreaUser

###ExistUser

###CreaUserSeul

###Get-iinfo

***

# Fabriqué 
PowerShell
Visual Studio Code
***
# Contributeurs et Auteur
REIFFSTECK Laurent Auteur 
BINAND Olivier Mentor OpenClassrooms
***
# Licence
libre de droit
