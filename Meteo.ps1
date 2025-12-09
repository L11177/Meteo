$ville = Read-Host "Entrez une ville"

# Récupérer coordonnées GPS
$geo = Invoke-RestMethod "https://geocoding-api.open-meteo.com/v1/search?name=$ville&count=1"

if ($geo.results.Count -eq 0) {
    Write-Host "Ville introuvable."
    exit
}

$lat = $geo.results[0].latitude
$lon = $geo.results[0].longitude

# Appel API météo
$meteo = Invoke-RestMethod "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&temperature_unit=celsius&windspeed_unit=kmh"

$temp = $meteo.current_weather.temperature
$vent = $meteo.current_weather.windspeed
$direction = $meteo.current_weather.winddirection
$code = $meteo.current_weather.weathercode

Write-Host "Météo à $ville :"
Write-Host "Température : $temp °C"
Write-Host "Vitesse du vent : $vent km/h"
Write-Host "Direction du vent : $direction °"
Write-Host "Code météo : $code"
