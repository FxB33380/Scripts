#Script création utilisateur et dossier 
# Version 1.0
# Auteur : FX BLADIER 

#Renseignement de l'identité de l'utilisateur a créer 

$nom = Read-Host "Merci de Rentrer le Nom de l'Utilisateur à Créer"

$prenom = Read-Host "Merci de Rentrer le Prénom de l'Utilisateur à Créer"

$nomComplet = "$($prenom) $($nom)"

$login = "$($prenom.Substring(0,1)).$($nom)".ToLower()

#vérification du mot de passe

$mdp = Read-Host "Merci de Rentrer le Mot de Passe Provisoire de l'Utilisateur à Créer, l'utilisateur le changera à sa première connexion"

if ($mdp -cnotmatch "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$") {
    Write-Host "le mot de passe ne correspond pas aux exigences"
    exit 1
}
$groupe = Read-Host "Merci de Rentrer le nom du groupe à attribuer à cet utilisateur"

$OU = $groupe

# Création du dossier utilisateur suvant l'indication du goupe utilisateur

if ($groupe -like "DM") {
    $dossier = 'S:\Données\DIRECTION MARKETING'
}
elseif ($groupe -like "Accueil") {
    $dossier = 'S:\Données\ACCUEIL'
}
elseif ($groupe -like "DIF") {
    $dossier = 'S:\Données\DIRECTION FINANCIERE'
}
elseif ($groupe -like "DG") {
    $dossier = 'S:\Données\DIRECTION GENERALE'
}
elseif ($groupe -like "DRH") {
    $dossier = 'S:\Données\DIRECTION RESSOURCES HUMAINES'
}
elseif ($groupe -like "DRT") {
    $dossier = 'S:\Données\DIRECTION TECHNIQUE'   

}
elseif ($groupe -like "Stagiaires") {
    $dossier = 'S:\Données\STAGIAIRES'   

}

# si le groupe n'existe pas le dossier est créé à la racine 

else {
    $dossier = 'S:\Données'
}

# Création du dossier 
New-Item -ItemType directory -Name $login -Path $dossier


# Création de l'utilisateur et intégration de ce dernier dans le groupe désigné 

    New-ADUser -Name $nomComplet -SamAccountName $login -UserPrincipalName $login@acmegroup.fr -AccountPassword (ConvertTo-SecureString -AsPlainText $mdp -Force) -PasswordNeverExpires $false -CannotChangePassword $false -ChangePasswordAtLogon $true -Enabled $true -Path "OU=$OU,OU=Immeuble,DC=acmegroup,DC=fr"
    Add-ADGroupMember -identity $groupe -Members $login

