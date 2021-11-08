# scriptOCprojet1
 projet1 création d'utilisateurs dans l'Active Directory depuis un fichier utilisateurs.csv
***
# Pour Commencer
Ce script a été réalisé dans le cadre d'un projet "script 1" projet 7 pour OpenClassrooms
***
# Pré-requis
serveur Windows 2019 avec Active Directory

Création d'un fichier utilisateurs.CSV encodée UF8 avec ; comme séparateur. La conversion du fichier peut etre réalisé depuis Excel.
Le détail des champs dans le fichier *.CSV est expliqué dans le paragraphe Installation puis CreaUser

Le fichier sera placé dans le répertoire c:\Scripts\AD_USERS

Le script fonctionne aussi bien en silencieux que en mode interactif, le détail d'utilisation est expliqué dans le paragraphe suivant.
***
# Démarrage
comment on lance le script
Deux méthodes pour l'utilisation du script , soit silencieuse ou interactif en indiquant le nom du nouvel utilisateur

1.Script Silencieux

Le script se lance soit de manière silencieuse de la manière suivante 
.\script1github.ps1 ou ./scriptgithub.ps1 >c:\Scripts\AD_USERS\script1.txt si l'on veut récupérer le résultat du script.

2.Script Interactif

./scriptgithub.ps1 nom_d_utilisateur
Ce mode doit etre utilisé si on veut créer un seul utilisateur avec des renseignements de base.
Le détail des renseignements se trouve dans le paragraphe suivant à la fonction Get-info

***
# Installation / Explication 

4 fonctions principales

CreaUser
ExistUser
CreaUserSeul
Get-info

1.CreaUser

création de l'utilisateur en mode silencieux depuis le fichier *.CSV.

Les champs suivants seront utilisés dans le fichier *.CSV : Prenom, Nom, Fonction, Departement, Critique, Actif

Lors de la céation de l'utilisateur les champs suivants seront déduites à partir des données de fichier *.CSV:

Name, DisplayName, GivenName, Surname, UserPrincipalName, SamAccountName, EmailAdress, Description, Office, Departement, Activation du compte o/n, chemin de l'unité d'organisation d'appartenance

Eléments prédéfinis : 

Email @acme.fr, mot de passe , Company ACME, Mot de passe n'expire jamais, Ne pas changer le mot de passe au login, Ne pas changer de mot de passe

Création d'un répertoire partagé pour chaque utilisateur sous f:\DATAUSERS, le nom du répertoire et du partage correspond au nom de l'utilisateur.
Il est ajouter aux différents groupex de l'OU selon les éléments définis dans le fichier utilisateurs.csv

2.ExistUser

3.CreaUserSeul

4.Get-iinfo

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
