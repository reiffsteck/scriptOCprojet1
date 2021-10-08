<#revoir les conditions si l'utilisateur existe déjà 
mot de passe dans le fichier ou defini par defaut avec chgt obligatoire
groupe critique a introduire
#>
param ( 
    [string ]$n = ' ' , 
    [string] $UtilisateurPrenom ,
    [string] $UtilisateurNom  ,
    [string] $UtilisateurLogin ,
    [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr" ,
    [string] $UtilisateurMotDePasse = "Ricoh80700" ,
    [string] $UtilisateurFonction ,
    [string] $UtilisateurOU ,
    [string] $UtilisateurCritique
      )
                 
Clear-Host

#declaration de la fonction Creauser
function CreaUser
{
       param (
        [string] $UtilisateurPrenom = $Utilisateur.Prenom ,
        [string] $UtilisateurNom = $Utilisateur.Nom ,
        [string] $UtilisateurLogin = ($UtilisateurPrenom).Substring(0, 1) + $UtilisateurNom ,
        [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr" ,
        [string] $UtilisateurMotDePasse = "Ricoh80700" ,
        [string] $UtilisateurFonction = $Utilisateur.Fonction ,
        [string] $UtilisateurOU = $Utilisateur.Departement,
        [string] $UtilisateurCritique = $Utilisateur.Critique,
        [string] $UtilisateurActif = $Utilisateur.Actif ,
        [boolean] $UserActif
          )
          # a completer pour faire une creation plus fine
        if ($utilsateurActif -eq 'oui')
        { 
            $UserActif = $true
        }
        else 
        { 
            $UserActif = $false
        }
    # creation de l'utilisateur, coeur de la fonction
    # remplacer utilisateur fonction
    New-ADUser -Name $UtilisateurLogin `
               -DisplayName $UtilisateurLogin `
               -GivenName $UtilisateurPrenom `
               -Surname $UtilisateurNom `
               -SamAccountName $UtilisateurLogin `
               -UserPrincipalName "$UtilisateurLogin@acme.fr" `
               -EmailAddress $UtilisateurEmail `
               -Path "OU=$UtilisateurFonction,OU=Services,DC=ACME,DC=FR" `
               -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) `
               -PasswordNeverExpires $true `
               -ChangePasswordAtLogon $false `
               -CannotChangePassword $false `
               -Enable $UserActif
    #-Path "OU=$UtilisateurOU,OU=Services,DC=ACME,DC=FR"

    #ecriture de la creation de l'utlisateur
    Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"

    #validé la création d'un utilisateur $samaccountname =$UtilisateurLogin
    Get-ADUser -Identity $UtilisateurLogin
    # faire apres le premier test l'insertion du service et de l' OU desiré

    #creation du réprtoire partagé avec les droits de l'utilisateur 
    New-item F:\DataUsers\$UtilisateurLogin -ItemType Directory -Force
    New-SmbShare -Path f:\DATAUSERS\$UtilisateurLogin -Name $UtilisateurLogin -FullAccess $UtilisateurLogin

    #inserer un utilisateur dans un groupe
    Write-Output "Insertion de l'utilisateur dans le groupe: $UtilisateurFonction ($UtilisateurNom $UtilisateurPrenom)"
    #Add-ADGroupMember  Stagiaires -Members  "CN=$UtilisateurLogin,OU=Stagiaires,OU=Services,DC=ACME,DC=FR"
    Add-ADGroupMember  $UtilisateurFonction -Members  "CN=$UtilisateurLogin,OU=$UtilisateurFonction,OU=Services,DC=ACME,DC=FR"

     # creation de l'utilisateur critique
    if ($UtilisateurCritique -eq 'oui')
        {
            Write-Output "l'utilisateur" $UtilisateurLogin "est critique"
            #Add-ADGroupMember Critique -Members "CN=$UtilisateurLogin,OU=Critique,OU=Services,DC=ACME,DC=FR"
            Add-ADGroupMember -Identity "CN=Critique,OU=Critique,OU=Services,DC=acme,DC=fr" -Members $UtilisateurLogin
        }
        else 
        {
            Write-Output "l'utilisateur " $UtilisateurLogin "n'est pas un utilisateur critique"
            Write-Output $UtilisateurCritique
        }


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
        [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr"                
        #[string] $UtilisateurMotDePasse = "Ricoh80700" ,
        #[string] $UtilisateurFonction = $Utilisateur.Fonction ,
        #[string] $UtilisateurOU = $Utilisateur.Departement
        # a completer pour faire une creation plus fine
          )
                 Write-Host " l'uilisateur $UtilisateurLogin $UtilisateurEmail existe deja dans L'AD"
                 Write-Host "fonction ExistUser"
                    }   

function CreaUserSeul  {
 
    param (
        [string] $UtilisateurPrenom ,
        [string] $UtilisateurNom =$n ,
        [string] $UtilisateurLogin ,
        [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr" ,
        [string] $UtilisateurMotDePasse = "Ricoh80700" ,
        [string] $UtilisateurFonction ,
        [string] $UtilisateurCritique ,
        [string] $UtilisateurActif = $Utilisateur.Actif ,
        [boolean] $UserActif
 # a completer pour faire une creation plus fine
          )

        write-host " Vous avez choisi de créer un utilsateurs manuellement "
        Write-host "Voic les questions pour la creation de l'utilisateur"
        #$UtilisateurNom =Read-Host "quel est le nom de l'utilisateur"
        Write-Output "Le nom est " $UtilisateurNom 
        $UtilisateurPrenom =Read-Host " quel est le prenom" 
        Write-Output " le prenom est " $UtilisateurPrenom
        $UtilisateurLogin =Read-Host " quel est le login de l'utilisateur"
        Write-Output "le login est" $UtilisateurLogin
        Write-host " Vous devez définir le service de l'utilisateur, vous avez plusieurs choix"
        Write-host " DirectionFinanciere, DirectionGenerale, DirectionMarketing, DirectionTechnique, RessourcesHumaines"
        $UtilisateurFonction =Read-Host "quel est le service, choix multiple"
        Write-Output "le service de l'utilsateur est " $UtilisateurFonction
        #$UtilisateurFonction =Read-host "quel est la fonction"
        #Write-Output "la fonction de l'utilsateur est " $UtilisateurFonction
        $UtilisateurEmail =Read-Host " quel est l'adresse mail de l'utilisateur"
        Write-Output "le mail de l'utilsateur est" $UtilisateurEmail
        $UtilisateurCritique =Read-Host "L'utilsateur est il critique? Si oui , ecrire critique"
        $UtilsateurActif = Read-Host "l'utilisateur est il actif oui ou non"
        

        if ($utilsateurActif -eq 'oui')
        { 
            $UserActif = $true
            Write-output $UtilisateurActif " est actif"
        }
        else 
        { 
            $UserActif = $false
            Write-Output $UtilisateurActif " n'est pas actif"
        }
       # voir pour OU apres les tests

      # CreaUserSeul
        New-ADUser -Name $UtilisateurLogin `
            -DisplayName $UtilisateurLogin `
            -GivenName $UtilisateurPrenom `
            -Surname $UtilisateurNom `
            -SamAccountName $UtilisateurLogin `
            -UserPrincipalName "$UtilisateurLogin@acme.fr" `
            -EmailAddress $UtilisateurEmail `
            -Path "OU=$UtilisateurFonction,OU=Services,DC=ACME,DC=FR" `
            -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) `
            -PasswordNeverExpires $true `
            -ChangePasswordAtLogon $false `
            -CannotChangePassword $false `
            -Enable $UserActif
      
        #ecriture de la creation de l'utlisateur
        Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"

        #validé la création d'un utilisateur $samaccountname =$UtilisateurLogin
        Get-ADUser -Identity $UtilisateurLogin
        # faire apres le premier test l'insertion du service et de l' OU desiré

        #creation du réprtoire partagé avec les droits de l'utilisateur 
        New-item F:\DataUsers\$UtilisateurLogin -ItemType Directory -Force
        New-SmbShare -Path f:\DATAUSERS\$UtilisateurLogin -Name $UtilisateurLogin -FullAccess $UtilisateurLogin

        #inserer un utilisateur dans un groupe
        Write-Output "Insertion de l'utilisateur dans le groupe: $UtilisateurFonction ($UtilisateurNom $UtilisateurPrenom)"
        Add-ADGroupMember $UtilisateurFonction -Members  "CN=$UtilisateurLogin,OU=$UtilisateurFonction,OU=Services,DC=ACME,DC=FR"

        # creation de l'utilisateur critique
        if ($UtilisateurCritique -eq 'oui')
        {
            Write-Output "l'utilisateur" $UtilisateurLogin "est critique"
            Add-ADGroupMember -Identity "CN=Critique,OU=Critique,OU=Services,DC=acme,DC=fr" -Members $UtilisateurLogin
        }
        else 
        {
            Write-Output "l'utilisateur " $UtilisateurLogin "n'est pas un utilisateur critique"
            Write-Output $UtilisateurCritique
        }

        Write-Host " l'uilisateur "$UtilisateurLogin $UtilisateurEmail" a ete cree"
        Write-Host " fonction CreaUserSeul"


                       }
# importation du fichier CSV
#param ($chemin= ' ')

function Get-info () {
                            param (
                                    [string] $n ,
                                    [string] $UtilisateurPrenom ,
                                    [string] $UtilisateurNom  ,
                                    [string] $UtilisateurLogin ,
                                    [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr" ,
                                    [string] $UtilisateurMotDePasse = "Ricoh80700" ,
                                    [string] $UtilisateurFonction ,
                                    [string] $UtilisateurOU ,
                                    [string] $UtilisateurCritique 
                                  )
                                  Write-Host $n
       if ($n -eq ' ' )
     
          {
          # Read-Host "vueillez donner des infos :" $chemin
          write-host "le chemin d'importation est connu  C:\Scripts\AD_USERS\Utilisateurs.csv"
          # création de la variable chemin du fichier CSV 
          # à voir avec un Read-host pour en faire une varialbe d'appel fonction
          $CSVFile = "C:\Scripts\AD_USERS\Utilisateurs.csv"
          $CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8 
          Write-Host "Fichier Importé"
          " il y a {0} utilisateurs dans le tableau" -F ($CSVData.count)

          # condition foreach à faire car le fichier n'est pas indiqué dans la ligne de commande en terminal powershell

          Foreach ($Utilisateur in $CSVData)
               {
                    "{0} est un utilisateur" -F $Utilisateur
                    $UtilisateurPrenom = $Utilisateur.Prenom
                    $UtilisateurNom = $Utilisateur.Nom
                    $UtilisateurLogin = ($UtilisateurPrenom).Substring(0, 1) + $UtilisateurNom
                    $UtilisateurEmail = "$UtilisateurLogin@acme.fr"
                    $UtilisateurMotDePasse = "Ricoh80700"
                    $UtilisateurFonction = $Utilisateur.Fonction
                    $UtilisateurOU = $Utilisateur.Departement 
                    $UtilisateurCritique =$Utilisateur.Critique 
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
           CreaUserSeul
           #FINIR LA FONCTION DE CREATION USER MANUEL
       # introduire à la fin la fonction creauser
        }

                     }

     
  
   Get-info -n $n


#verification du nombre d'utilisateur dans la liste
#a effacer plus tard
# " il y a {0} utilisateurs dans le tableau" -F ($CSVData.count)




                    


