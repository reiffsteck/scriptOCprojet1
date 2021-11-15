param ( 
    [string ] $n = ' ' , 
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
$ErrorActionPreference = "SilentlyContinue"
$Error.Clear()  #purge des erreurs

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
          
        if ($UtilisateurActif -eq 'oui' )
        { 
            $UserActif = $true
        }
        else 
        { 
            $UserActif = $false
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
            Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)et il est actif $UserActif"
           
            #creation du réprtoire partagé avec les droits de l'utilisateur 
            New-item F:\DataUsers\$UtilisateurLogin -ItemType Directory -Force -ErrorAction SilentlyContinue
            New-SmbShare -Path f:\DATAUSERS\$UtilisateurLogin -Name $UtilisateurLogin -FullAccess $UtilisateurLogin -ErrorAction SilentlyContinue

            #inserer un utilisateur dans un groupe
            Write-Output "Insertion de l'utilisateur dans le groupe: $UtilisateurOU ($UtilisateurNom $UtilisateurPrenom)"
            Add-ADGroupMember  $UtilisateurOU -Members  "CN=$UtilisateurLogin,OU=$UtilisateurOU,OU=Services,DC=ACME,DC=FR" 
            Add-ADGroupMember -Identity  "CN=ACMEGroup,OU=ACMEGroup,OU=Services,DC=ACME,DC=FR" -Members $UtilisateurLogin

            # creation de l'utilisateur critique
            if ($UtilisateurCritique -eq 'oui')
                {
                    Write-Output "l'utilisateur" $UtilisateurLogin "est critique"
                    Add-ADGroupMember -Identity "CN=Critique,OU=Critique,OU=Services,DC=acme,DC=fr" -Members $UtilisateurLogin
                }
                else 
                {
                    Write-Output "l'utilisateur " $UtilisateurLogin "n'est pas un utilisateur critique"
                }

    Write-Host " l'utilisateur $UtilisateurLogin $UtilisateurEmail a ete cree"
    Write-Host " "
    
}
                

# declaration de la fonction Exituser
function ExitUser {

    #lister les variables
    param (
        [string] $UtilisateurPrenom = $Utilisateur.Prenom ,
        [string] $UtilisateurNom = $Utilisateur.Nom ,
        [string] $UtilisateurLogin = ($UtilisateurPrenom).Substring(0, 1) + $UtilisateurNom ,
        [string] $UtilisateurEmail = "$UtilisateurLogin@acme.fr"                
          )
        Write-Host " "
        Write-Host " l'uilisateur $UtilisateurLogin $UtilisateurEmail existe deja dans L'AD"
        Write-Host " "
        SortieErreur         
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
        [string] $UtilisateurExist,
        [boolean] $UserActif
          )

        write-host " Vous avez choisi de créer un utilsateurs manuellement "
        Write-host "Voic les questions pour la creation de l'utilisateur"
        Write-Output "Le nom est " $UtilisateurNom 
        $UtilisateurPrenom =Read-Host " quel est le prenom" 
        Write-Output " le prenom est " $UtilisateurPrenom
        $UtilisateurLogin = Read-Host " quel est le login de l'utilisateur"
        # verification si l'utilisateur existe
        $UtilisateurExist = $UtilisateurLogin
          if ($UtilisateurExist = Get-ADUser -Filter { SamAccountName -eq $UtilisateurLogin }) 
       
        {
            Write-Output "le login est" $UtilisateurLogin "l'utilisateur existe"
            exit
        }
        else
         {
            Write-Output "le login est" $UtilisateurLogin "l'utilisateur n existe pas"
            $UtilisateurEmail = "$UtilisateurLogin@acme.fr"
            Write-Output "le mail de l'utilsateur est" $UtilisateurEmail
            Write-host " Vous devez définir le service de l'utilisateur, vous avez plusieurs choix"
                    Write-output "Stagiaires 1 "
                    Write-output "DirectionFinanciere 2 "
                    Write-output "DirectionGenerale 3 " 
                    Write-output "DirectionMarketing 4 "
                    Write-output "DirectionTechnique 5 "
                    Write-output "RessourcesHumaines 6 "
                    $UtilisateurOU =Read-Host "Entrez un nombre entre 1 et 6"
                    switch ($UtilisateurOU)
                    {
                        1 { $UtilisateurOU="Stagiaires"}
                        2 { $UtilisateurOU="DirectionFinanciere"}
                        3 { $UtilisateurOU="DirectionGenerale"}
                        4 { $UtilisateurOU="DirectionMarketing"}
                        5 { $UtilisateurOU="DirectionTechnique"}
                        6 { $UtilisateurOU="RessourcesHumaines"}
                    } 
                        
            Write-Output "le service de l'utilsateur est " $UtilisateurOU
            Write-Host "Vous devez définir si l'utilisateur est critique"
            Write-Output " 1 pour oui, 2 pour non"
            $UtilisateurCritique =Read-Host "L'utilsateur est il critique? 1 ou 2"
            switch ($UtilisateurCritique)
            { 
                1 { $UtilisateurCritique ="oui"}
                2 { $UtilisateurCritique ="non"}
            }
            
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
                -Enabled $true
      
        #ecriture de la creation de l'utlisateur
        Write-Host " "
        Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
        
        #creation du réprtoire partagé avec les droits de l'utilisateur 
        New-item F:\DataUsers\$UtilisateurLogin -ItemType Directory -Force -ErrorAction SilentlyContinue
        New-SmbShare -Path f:\DATAUSERS\$UtilisateurLogin -Name $UtilisateurLogin -FullAccess $UtilisateurLogin -ErrorAction SilentlyContinue

        #inserer un utilisateur dans un groupe
        Write-Output "Insertion de l'utilisateur dans le groupe: $UtilisateurOU ($UtilisateurNom $UtilisateurPrenom)"
        Add-ADGroupMember $UtilisateurOU -Members  "CN=$UtilisateurLogin,OU=$UtilisateurOU,OU=Services,DC=ACME,DC=FR"
        Add-ADGroupMember -Identity  "CN=ACMEGroup,OU=ACMEGroup,OU=Services,DC=ACME,DC=FR" -Members $UtilisateurLogin
        # creation de l'utilisateur critique
        if ($UtilisateurCritique -eq 'oui')
        {
            Write-Output "l'utilisateur" $UtilisateurLogin "est critique"
            Add-ADGroupMember -Identity "CN=Critique,OU=Critique,OU=Services,DC=acme,DC=fr" -Members $UtilisateurLogin -ErrorAction SilentlyContinue
        }
        else 
        {
            Write-Output "l'utilisateur " $UtilisateurLogin "n'est pas un utilisateur critique"
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
                                    [string] $UtilisateurCritique,
                                    [string] $UtilisateurExist
                    
                                  )
                                  Write-Host $n
       if ($n -eq ' ' )
     
          {
          
          $CSVFile = "C:\Scripts\AD_USERS\Utilisateurs.csv"
          $CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8 
          "il y a {0} utilisateurs dans le tableau " -F ($CSVData.count)
           
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
                    # verification si l'utilisateur existe
                    $UtilisateurExist = $UtilisateurLogin
                    if ($UtilisateurExist = Get-ADUser -Filter { SamAccountName -eq $UtilisateurLogin }) 
                    {
                       
                        ExitUser
                        
                    }
                    else
                    {
                        CreaUser
                        SortieErreur
                    }    
               }


          }

       else 
       
        {  
           CreaUserSeul
           SortieErreur
        }

                     }

    Function SortieErreur( )
    {
        param ()
    
        
        if($Error.Count -ieq 0)
        {
    
        Write-Output "Pas de Code de sortie en Erreur" $error[0] #affichage erreur
        $LastExitCode 
        }
    
        Else
        {
            Write-Host "Erreur:"
            Write-Host $error[0] #affichage erreur
            $LastexitCode
            exit
        }
    }   
  
   Get-info -n $n
  