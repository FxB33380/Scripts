#Script Sauvegarde quotidienne des Dossiers  Users depuis les PCs sur le dossier sauvegarde sur le serveur 
# Version 2.0
# Auteur : FX BLADIER


#On r√©cup√®re la liste des PC de l'AD
$PCS = dsquery computer  "OU=immeuble,DC=acmegroup,DC=fr" -o rdn
$nbpctotal = $pcs.Count
$nbpcsauvegardes = 0
Foreach ($thepc in $PCS) {
    #suppression des ""
    $thepc = $thepc -replace '"', ''
   

    #Pour chaque PC de la liste,  on r√©cupr√®re les donn√©es 
    # /M :copie les fichers avec attribut archive, d√©sactive l'attribut archive.
    # /E :Copie les r√©pertoires et sous-r√©pertoires, y compris les r√©pertoires vides.
    # /G :Permet la copie des fichiers chiffr√©s vers des destinations qui ne prennent pas en charge le chiffrement
    # /Y :Supprime la demande de confirmation de remplacement de fichiers de destination existants.

    # On teste la connexion au PC 
    if (Test-Connection -ComputerName $thepc -Count 1 -Quiet) {  
    # on lance la sauvegarde des dossiers       
        xcopy "\\$thepc\C$\Users" "S:\Sauvegarde\$thepc\" /M /E /G /Y
        $nbpcsauvegardes++ 
        Write-Host "La sauvegarde de $thepc a ÈtÈ effectuÈe"
        
    }
    else {
        Write-Host "$thepc est Èteint"
    }
}
#on indique dans le journal d'ÈvËnements si la t‚che s'est correctement exÈcutÈe ou pas 
if ($nbpcsauvegardes -eq $nbpctotal) {
    Write-EventLog -LogName Application -Source "Backup PCS" -EntryType Information -EventId 1 -Message "Tous les Pcs ont √©t√© sauvergardÈs"
}
elseif ($nbpcsauvegardes -eq 0) {
    Write-EventLog -LogName Application -Source "Backup PCS" -EntryType Error -EventId 1 -Message "Aucun PC sauvegardÈ"
}
else {
    Write-EventLog -LogName Application -Source "Backup PCS" -EntryType Warning -EventId 1 -Message "$nbpcsauvegardes / $nbpctotal PCS sauvegardÈs"
}