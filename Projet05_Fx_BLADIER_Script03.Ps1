#Recherche des groupes dont l'utilisateur est membre
# Version 2.0
# Auteur : FX BLADIER 


#On importe l'AD
Import-Module ActiveDirectory

#On renseigne le nom de l'utilisateur recherché 
$nom = Read-Host "Merci de Rentrer le Nom et le Prénom de l’Utilisateur à chercher"

#on teste si l'utilisateur existe 
try {
    $testuser = Get-ADuser -Identity $nom -ErrorAction Stop
}
catch {
    Write-Host "L'utilisateur $nom n'existe pas"
    exit 1
}
$user = Get-ADuser -f { SamAccountName -eq $nom } -SearchBase "DC=acmegroup,DC=fr" -Properties MemberOf 

#on extrait les informations de l'utilisateur qu'on enregistre dans un fichier .txt
$membre = $user.memberof
Add-Content -Path "S:\Sauvegarde\Listings\$nom.txt" -Value $nom
Add-Content -Path "S:\Sauvegarde\Listings\$nom.txt" -Value $membre  

Write-Host "L'export s'est correctement terminé"

