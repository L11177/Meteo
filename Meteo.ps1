$ville = Read-Host "Entrez une ville"

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

# Récupérer latitude & longitude de la ville
$geo = Invoke-RestMethod "https://geocoding-api.open-meteo.com/v1/search?name=$ville&count=1"

if ($geo.results.Count -eq 0) {
    Write-Host "Ville introuvable."
    exit
}

# Récupérer la météo actuelle avec latitude & longitude
$lat = $geo.results[0].latitude
$lon = $geo.results[0].longitude

$meteo = Invoke-RestMethod "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&temperature_unit=celsius&windspeed_unit=kmh"

# Affichage amélioré
$temp = $meteo.current_weather.temperature
$vent = $meteo.current_weather.windspeed
$direction = $meteo.current_weather.winddirection
$code = $meteo.current_weather.weathercode
$description = Get-WeatherDescription $code

Write-Host "Météo à $ville :"
Write-Host "Température : $temp °C"
Write-Host "Vitesse du vent : $vent km/h"
Write-Host "Direction du vent : $direction °"
Write-Host "État général : $description"
