cmdcrea4user 
#test des variables simples ok
#pble sur la boucle foreach if else, un utilisateur creer, celui de la fin du fichier CSV
#menage dans les commentaires

 # importation du fichier CSV

#$CSVFile = "C:\Scripts\AD_USERS\Utilisateurs.csv"
$CSVData = Import-CSV -Path  "C:\Scripts\AD_USERS\Utilisateurs.csv" -Delimiter ";" -Encoding UTF8
 Write-Host "Fichier Importé"

 #$Utilisateur= (Import-csv -path c:\Scripts\AD_USERS\Utilisateurs.csv -Delimiter ";" -Encoding UTF8).Nom

 
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
 }
 else 
 # creation de l'utilisateur
 {
 # une seule ligne de commande pour creer un utilisateur déjà défini dans une UO standard Users
 
 #ligne origine
 #New-ADUser -Name "$UtilisateurNom , $UtilisateurPrenom"  -DisplayName "$UtilisateurNom , $UtilisateurPrenom" -GivenName $UtilisateurPrenom -Surname $UtilisateurNom -SamAccountName $UtilisateurLogin -UserPrincipalName "$UtilisateurLogin@acme.fr" -EmailAddress $UtilisateurEmail -Title $UtilisateurFonction -Path "OU=Users,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricohricoh -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false
 
 New-ADUser -Name $UtilisateurNom  -DisplayName $UtilisateurNom -GivenName $UtilisateurPrenom -Surname $UtilisateurNom -SamAccountName $UtilisateurLogin -UserPrincipalName "$UtilisateurLogin@acme.fr" -EmailAddress $UtilisateurEmail -Path "OU=Stagiaires,OU=Services,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false -Enable $true
 #New-ADUser -Name Solbes  -DisplayName Solbes -GivenName Ludovic -Surname Solbes -SamAccountName LSolbes -UserPrincipalName LSolbes@acme.fr -EmailAddress LSolbes@acme.fr -Title Titre -Path "OU=Users,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricohricoh -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false
 
 #ecriture de la creation de l'utlisateur
 Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
 
 #validé la création d'un utilisateur $samaccountname =$UtilisateurLogin
 Get-ADUser -Identity $UtilisateurLogin
 
 }