﻿<#revoir les conditions si l'utilisateur existe déjà 
prevoir de mettre le bon user dans le bon UO
integrer les users dans les groupes
mot de passe dans le fichier ou defini par defaut avec chgt obligatoire
groupe critique a introduire

creation du bon format de login et nom user
#>
param ( 
    [string ]$n =' '   
      )

Clear-Host

#declaration de la fonction Creauser

function CreaUser {

    #lister les variables
    param (
        [string] $UtilisateurPrenom = $Utilisateur.Prenom ,
        [string] $UtilisateurNom = $Utilisateur.Nom ,
        [string] $UtilisateurLogin = ($UtilisateurPrenom).Substring(0, 1) + $UtilisateurNom ,
        [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr" ,
        [string] $UtilisateurMotDePasse = "Ricoh80700" ,
        [string] $UtilisateurFonction = $Utilisateur.Fonction ,
        [string] $UtilisateurOU = $Utilisateur.Departement
        # a completer pour faire une creation plus fine
          )
        
    # creation de l'utilisateur, coeur de la foncion
    New-ADUser -Name $UtilisateurLogin  -DisplayName $UtilisateurLogin -GivenName $UtilisateurPrenom -Surname $UtilisateurPrenom -SamAccountName $UtilisateurLogin -UserPrincipalName "$UtilisateurLogin@acme.fr" -EmailAddress $UtilisateurEmail -Path "OU=Stagiaires,OU=Services,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false -Enable $true
    Write-Host "verif creation utilisateur $UtilisateurLogin"
    #ecriture de la creation de l'utlisateur
    Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"

    #validé la création d'un utilisateur $samaccountname =$UtilisateurLogin
    Get-ADUser -Identity $UtilisateurLogin
    # faire apres le premier test l'insertion du service et de l' OU desiré

    #creation du réprtoire partagé avec les droits de l'utilisateur 
    New-item F:\DataUsers\$UtilisateurLogin -ItemType Directory -Force
    New-SmbShare -Path f:\DATAUSERS\$UtilisateurLogin -Name $UtilisateurLogin -FullAccess $UtilisateurLogin

    #inserer un utilisateur dans un groupe
    Write-Output "Insertion de l'utilisateur dans le groupe: $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
    Add-ADGroupMember  Stagiaires -Members  "CN=$UtilisateurLogin,OU=Stagiaires,OU=Services,DC=ACME,DC=FR"

    Write-Host " l'uilisateur $UtilisateurLogin $UtilisateurEmail a ete cree"
    Write-Host " fonction CreaUser"
      
                  }
# declaration de la fonction 2 exituser

function ExistUser {

    #lister les variables
    param (
        [string] $UtilisateurPrenom = $Utilisateur.Prenom ,
        [string] $UtilisateurNom = $Utilisateur.Nom ,
        [string] $UtilisateurLogin = ($UtilisateurPrenom).Substring(0, 1) + $UtilisateurNom ,
        [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr" ,
        [string] $UtilisateurMotDePasse = "Ricoh80700" ,
        [string] $UtilisateurFonction = $Utilisateur.Fonction ,
        [string] $UtilisateurOU = $Utilisateur.Departement
        # a completer pour faire une creation plus fine
          )
          Write-Host " l'uilisateur $UtilisateurLogin $UtilisateurEmail existe deja"
          Write-Host "fonction ExistUser"
                    }   
                    
# importation du fichier CSV
#param ($chemin= ' ')


function Get-info () {
  param (
          [string] $n
        )
        Write-Host $n
if ($n -eq ' ' )
# if ($n -eq $null )
{
# Read-Host "vueillez donner des infos :" $chemin
write-host "le chemin d'importation est connu  C:\Scripts\AD_USERS\Utilisateurs.csv"
$CSVData = Import-CSV -Path "C:\Scripts\AD_USERS\Utilisateurs.csv" -Delimiter ";" -Encoding UTF8 
Write-Host "Fichier Importé"
" il y a {0} utilisateurs dans le tableau" -F ($CSVData.count)

# condition foreach à faire car le fichier n'est pas indiqué dans la ligne de commande en terminal powershell
Foreach ($Utilisateur in $CSVData)
{
"{0} est un utilisateur" -F $Utilisateur
$UtilisateurPrenom = $Utilisateur.Prenom
$UtilisateurNom = $Utilisateur.Nom
$UtilisateurLogin = ($UtilisateurPrenom).Substring(0,1) + $UtilisateurNom
$UtilisateurEmail = "$UtilisateurLogin@acme.fr"
$UtilisateurMotDePasse = "Ricoh80700"
$UtilisateurFonction = $Utilisateur.Fonction
$UtilisateurOU = $Utilisateur.Departement  
# Vérifier la présence de l'utilisateur dans l'AD
# fonction de test utilisateur


# appel function ExistUser
if (Get-ADUser -Filter { SamAccountName -eq $UtilisateurLogin }) 
{
  ExistUser

}
else 
#appel fonction CreaUser
{ 

CreaUser

}
}


}

else 

{  
#FINIR LA FONCTION DE CREATION USER MANUEL
# introduire à la fin la fonction creauser
write-host " faire les questions pour la creation users"
$UtilisateurNom = Read-Host "quel est le nom de l'utilisateur"
write-ouput "votre est nom est " $UtilisateurNom 
$UtilisateurPrenom =Read-Host " quel est le premnom" 
write-output " le prenom est " $UtilisateurPrenom
$UtilisateurFonction = Read-host "quel est la fonction, choix multiple"
write-output "la fonction de l'utilsateur est " $UtilisateurFonction
# voir pour OU apres les tests

CreaUser
}

}



Get-info -n $n


#verification du nombre d'utilisateur dans la liste
#a effacer plus tard
" il y a {0} utilisateurs dans le tableau" -F ($CSVData.count)

# fonction de test et creation user