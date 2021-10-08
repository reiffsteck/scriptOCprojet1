<#revoir les conditions si l'utilisateur existe déjà 
prevoir de mettre le bon user dans le bon UO
integrer les users dans les groupes
mot de passe dans le fichier ou defini par defaut avec chgt obligatoire
groupe critique a introduire

#>
Clear-Host

# importation du fichier CSV
# import OK

$CSVData = Import-CSV -Path "C:\Scripts\AD_USERS\Utilisateurs.csv" -Delimiter ";" -Encoding UTF8
Write-Host "Fichier Importé"

#verification du nombre d'utilisateur dans la liste
#a effacer plus tard
" il y a {0} utilisateurs dans le tableau" -F ($CSVData.count)

# fonction de test et creation user
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
    New-ADUser -Name $UtilisateurNom  -DisplayName $UtilisateurNom -GivenName $UtilisateurPrenom -Surname $UtilisateurNom -SamAccountName $UtilisateurLogin -UserPrincipalName "$UtilisateurLogin@acme.fr" -EmailAddress $UtilisateurEmail -Path "OU=Stagiaires,OU=Services,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false -Enable $true
    Write-Host "verif creation utilisateur $UtilisateurLogin"
    #ecriture de la creation de l'utlisateur
    Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"

    #validé la création d'un utilisateur $samaccountname =$UtilisateurLogin
    Get-ADUser -Identity $UtilisateurLogin
    # faire apres le premier test l'insertion du service et de l' OU desiré
  
        
                  }

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
                    }   
                    
# COEUR DU SCRIPT

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
            Write-Host " l'uilisateur $UtilisateurLogin $UtilisateurEmail existe deja"
            Write-Host "fonction ExistUser"
            ExistUser

          }
    else 
    #appel fonction CreaUser
         { 
        Write-Host " l'uilisateur $UtilisateurLogin $UtilisateurEmail a ete cree"
        Write-Host " fonction CreaUser"
        CreaUser

         }
}
