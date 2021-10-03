# une seule ligne de commande pour creer un utilisateur déjà défini dans une UO standard Users

#ligne origine
#New-ADUser -Name "$UtilisateurNom , $UtilisateurPrenom"  -DisplayName "$UtilisateurNom , $UtilisateurPrenom" -GivenName $UtilisateurPrenom -Surname $UtilisateurNom -SamAccountName $UtilisateurLogin -UserPrincipalName "$UtilisateurLogin@acme.fr" -EmailAddress $UtilisateurEmail -Title $UtilisateurFonction -Path "OU=Users,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricohricoh -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false

New-ADUser -Name Solbes  -DisplayName Solbes -GivenName Ludovic -Surname Solbes -SamAccountName LSolbes -UserPrincipalName LSolbes@acme.fr -EmailAddress LSolbes@acme.fr -Path "OU=Stagiaires,OU=Services,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricoh80700 -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false -Enable $true
#New-ADUser -Name Solbes  -DisplayName Solbes -GivenName Ludovic -Surname Solbes -SamAccountName LSolbes -UserPrincipalName LSolbes@acme.fr -EmailAddress LSolbes@acme.fr -Title Titre -Path "OU=Users,DC=ACME,DC=FR" -AccountPassword(ConvertTo-SecureString -AsPlainText Ricohricoh -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -CannotChangePassword $false

#validé la création d'un utilisateur $samaccountname =$UtilisateurLogin
Get-ADUser -Identity "LSolbes"