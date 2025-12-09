Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# Fonction pour traduire le code météo en texte
function Get-WeatherDescription($code) {
    switch ($code) {
        0  { return "Ciel clair" }
        1  { return "Principalement ensoleillé" }
        2  { return "Partiellement nuageux" }
        3  { return "Nuageux" }
        45 { return "Brouillard" }
        48 { return "Brouillard givrant" }
        51 { return "Bruine légère" }
        53 { return "Bruine modérée" }
        55 { return "Bruine dense" }
        61 { return "Pluie faible" }
        63 { return "Pluie modérée" }
        65 { return "Pluie forte" }
        71 { return "Chute de neige légère" }
        73 { return "Chute de neige modérée" }
        75 { return "Chute de neige forte" }
        80 { return "Averses de pluie" }
        81 { return "Averses de pluie fortes" }
        82 { return "Averses de pluie violentes" }
        default { return "Conditions inconnues" }
    }
}

do {
    # Créer la fenêtre
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Météo actuelle"
    $form.Size = New-Object System.Drawing.Size(400,250)
    $form.StartPosition = "CenterScreen"

    # Ajouter un label
    $label = New-Object System.Windows.Forms.Label
    $label.Size = New-Object System.Drawing.Size(380,200)
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Text = "Chargement..."
    $form.Controls.Add($label)

    # Demander la ville
    $ville = [Microsoft.VisualBasic.Interaction]::InputBox("Entrez une ville","Ville")

    if ([string]::IsNullOrWhiteSpace($ville)) {
        $label.Text = "Aucune ville entrée."
    } else {
        # Géocodage pour récupérer lat/lon
        $geo = Invoke-RestMethod -Uri "https://geocoding-api.open-meteo.com/v1/search?name=$ville&count=1"
        if ($geo.results.Count -eq 0) {
            $label.Text = "Ville introuvable."
        } else {
            $latitude = $geo.results[0].latitude
            $longitude = $geo.results[0].longitude

            # API météo
            $url = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&temperature_unit=celsius&windspeed_unit=kmh&timezone=Europe/Paris"
            $meteo = Invoke-RestMethod -Uri $url

            # Traduire le code météo
            $desc = Get-WeatherDescription $meteo.current_weather.weathercode

            # Changer la couleur selon la température
            if ($meteo.current_weather.temperature -le 0) {
                $label.ForeColor = [System.Drawing.Color]::Blue
            } elseif ($meteo.current_weather.temperature -le 20) {
                $label.ForeColor = [System.Drawing.Color]::Green
            } else {
                $label.ForeColor = [System.Drawing.Color]::Red
            }

            # Afficher la météo
            $label.Text = "Météo à $ville :`n" +
                          "Température : $($meteo.current_weather.temperature)°C`n" +
                          "Vent : $($meteo.current_weather.windspeed) km/h`n" +
                          "Direction du vent : $($meteo.current_weather.winddirection)°`n" +
                          "État général : $desc"
        }
    }

    [void]$form.ShowDialog()

    # Demander si l'utilisateur veut saisir une autre ville
    $reponse = [System.Windows.Forms.MessageBox]::Show("Voulez-vous consulter une autre ville ?", "Nouvelle ville", [System.Windows.Forms.MessageBoxButtons]::YesNo)
} while ($reponse -eq [System.Windows.Forms.DialogResult]::Yes)
