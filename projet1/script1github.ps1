param ( 
    [string ]$n = ' ' , 
    [string] $UtilisateurPrenom ,
    [string] $UtilisateurNom  ,
    [string] $UtilisateurLogin ,
    [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr" ,
    [string] $UtilisateurMotDePasse = "Ricoh80700" ,
    [string] $UtilisateurFonction ,
    [string] $UtilisateurOU ,
    [string] $UtilisateurCritique,
    [string] $UtilisateurActif ,
    [boolean] $UserActif
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
        if ($UtilisateurActif -eq 'oui' )
        { 
        Write-Output $UtilisateurActif
            $UserActif = $true
            Write-Output $UserActif
        }
        else 
        { 
           Write-Output $UtilisateurActif
            $UserActif = $false
             Write-Output $UserActif
        }
    # creation de l'utilisateur, coeur de la fonction
       New-ADUser -Name $UtilisateurLogin `
               -DisplayName $UtilisateurLogin `
               -GivenName $UtilisateurPrenom `
               -Surname $UtilisateurNom `
               -SamAccountName $UtilisateurLogin `
               -UserPrincipalName "$UtilisateurLogin@acme.fr" `
               -EmailAddress $UtilisateurEmail `
               -Path "OU=$UtilisateurOU,OU=Services,DC=ACME,DC=FR" `
               -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) `
               -Company "ACME" `
               -Description $UtilisateurFonction `
               -Office $UtilisateurOU `
               -Department $UtilisateurOU `
               -PasswordNeverExpires $true `
               -ChangePasswordAtLogon $false `
               -CannotChangePassword $false `
               -Enabled $UserActif
   

    #ecriture de la creation de l'utlisateur
    Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"

    #validé la création d'un utilisateur $samaccountname =$UtilisateurLogin
    Get-ADUser -Identity $UtilisateurLogin
    
    #creation du réprtoire partagé avec les droits de l'utilisateur 
    New-item F:\DataUsers\$UtilisateurLogin -ItemType Directory -Force
    New-SmbShare -Path f:\DATAUSERS\$UtilisateurLogin -Name $UtilisateurLogin -FullAccess $UtilisateurLogin

    #inserer un utilisateur dans un groupe
    Write-Output "Insertion de l'utilisateur dans le groupe: $UtilisateurOU ($UtilisateurNom $UtilisateurPrenom)"
    Add-ADGroupMember  $UtilisateurOU -Members  "CN=$UtilisateurLogin,OU=$UtilisateurOU,OU=Services,DC=ACME,DC=FR"

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


    Write-Host " l'utilisateur $UtilisateurLogin $UtilisateurEmail a ete cree"
    Write-Host " fonction CreaUser"
      
                  }
                

# declaration de la fonction exituser
function ExistUser {

    #lister les variables
    param (
        [string] $UtilisateurPrenom = $Utilisateur.Prenom ,
        [string] $UtilisateurNom = $Utilisateur.Nom ,
        [string] $UtilisateurLogin = ($UtilisateurPrenom).Substring(0, 1) + $UtilisateurNom ,
        [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr"                
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
        [string] $UtilisateurOU ,
        [string] $UtilisateurCritique ,
        [string] $UtilisateurActif = $Utilisateur.Actif ,
        [boolean] $UserActif
 
          )

        write-host " Vous avez choisi de créer un utilsateurs manuellement "
        Write-host "Voic les questions pour la creation de l'utilisateur"
        Write-Output "Le nom est " $UtilisateurNom 
        $UtilisateurPrenom =Read-Host " quel est le prenom" 
        Write-Output " le prenom est " $UtilisateurPrenom
        $UtilisateurLogin =Read-Host " quel est le login de l'utilisateur"
        Write-Output "le login est" $UtilisateurLogin
        $UtilisateurEmail = "$UtilisateurLogin@acme.fr"
        Write-Output "le mail de l'utilsateur est" $UtilisateurEmail
        Write-host " Vous devez définir le service de l'utilisateur, vous avez plusieurs choix"
        Write-host " DirectionFinanciere, DirectionGenerale, DirectionMarketing, DirectionTechnique, RessourcesHumaines"
        $UtilisateurOU =Read-Host "quel est le service, choix multiple"
        Write-Output "le service de l'utilsateur est " $UtilisateurOU
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
       
      # CreaUserSeul
      New-ADUser -Name $UtilisateurLogin `
                -DisplayName $UtilisateurLogin `
                -GivenName $UtilisateurPrenom `
                -Surname $UtilisateurNom `
                -SamAccountName $UtilisateurLogin `
                -UserPrincipalName "$UtilisateurLogin@acme.fr" `
                -EmailAddress $UtilisateurEmail `
                -Path "OU=$UtilisateurOU,OU=Services,DC=ACME,DC=FR" `
                -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) `
                -Company "ACME" `
                -Description $UtilisateurFonction `
                -Office $UtilisateurOU `
                -Department $UtilisateurOU `
                -PasswordNeverExpires $true `
                -ChangePasswordAtLogon $false `
                -CannotChangePassword $false `
                -Enabled $UserActif
      
        #ecriture de la creation de l'utlisateur
        Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
        Get-ADUser -Identity $UtilisateurLogin

        #creation du réprtoire partagé avec les droits de l'utilisateur 
        New-item F:\DataUsers\$UtilisateurLogin -ItemType Directory -Force
        New-SmbShare -Path f:\DATAUSERS\$UtilisateurLogin -Name $UtilisateurLogin -FullAccess $UtilisateurLogin

        #inserer un utilisateur dans un groupe
        Write-Output "Insertion de l'utilisateur dans le groupe: $UtilisateurOU ($UtilisateurNom $UtilisateurPrenom)"
        Add-ADGroupMember $UtilisateurOU -Members  "CN=$UtilisateurLogin,OU=$UtilisateurOU,OU=Services,DC=ACME,DC=FR"

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
        
                       }
# importation du fichier CSV
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
          write-host "le chemin d'importation est connu  C:\Scripts\AD_USERS\Utilisateurs.csv"
          $CSVFile = "C:\Scripts\AD_USERS\Utilisateurs.csv"
          $CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8 
          Write-Host "Fichier Importé"
          
           
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
           
        }

                     }

     
  
   Get-info -n $n
  