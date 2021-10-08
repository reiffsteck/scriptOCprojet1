#cmdcrea5user 
#pble sur la boucle foreach if else, utilisateur creer fichier CSV
#revoir les conditions si l'utilisateur existe déjà 
#prevoir de mettre le bon user dans le bon UO

 # importation du fichier CSV

 $CSVData = Import-CSV -Path "C:\Scripts\AD_USERS\Utilisateurs.csv" -Delimiter ";" -Encoding UTF8
 Write-Host "Fichier Importé"

 #nombre d'utilisateur dans la liste
" il y a {0} utilisateurs dans le tableau" -F ($CSVData.count)


 #lister les variables
 
  Foreach($Utilisateur in $CSVData)
 {
     $UtilisateurPrenom = $Utilisateur.Prenom
     $UtilisateurNom = $Utilisateur.Nom
     $UtilisateurLogin = ($UtilisateurPrenom).Substring(0,1) + $UtilisateurNom
     $UtilisateurEmail = "$UtilisateurLogin@acme.fr"
     $UtilisateurMotDePasse = "Ricoh80700"
     $UtilisateurFonction = $Utilisateur.Fonction
   # faire apres le premier test l'insertion du service et de l' OU desiré
   # $UtilisateurOU = $Utilisateur.Departement
     }
         
       # Vérifier la présence de l'utilisateur dans l'AD
 
 if (Get-ADUser -Filter {SamAccountName -eq $UtilisateurLogin})
 {
    Write-Warning "L'identifiant $UtilisateurLogin existe déjà dans l'AD"
    Get-ADUser -Identity $UtilisateurLogin
 }
 else 
 # creation de l'utilisateur
 {
 
 
 New-ADUser -Name $UtilisateurNom  -DisplayName $UtilisateurNom -GivenName $UtilisateurPrenom -Surname $UtilisateurNom -SamAccountName $UtilisateurLogin -UserPrincipalName "$UtilisateurLogin@acme.fr" -EmailAddress $UtilisateurEmail -Path "OU=Stagiaires,OU=Services,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false -Enable $true
 
 #ecriture de la creation de l'utlisateur
 Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
 
 #validé la création d'un utilisateur $samaccountname =$UtilisateurLogin
 Get-ADUser -Identity $UtilisateurLogin
 
 }