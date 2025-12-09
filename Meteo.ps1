$ville = Read-Host "Entrez une ville"

# Récupérer latitude & longitude de la ville
$geo = Invoke-RestMethod "https://geocoding-api.open-meteo.com/v1/search?name=$ville&count=1"

# Récupérer la météo actuelle avec latitude & longitude
$lat = $geo.results[0].latitude
$lon = $geo.results[0].longitude

$meteo = Invoke-RestMethod "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&temperature_unit=celsius"

# Affichage simple
$temp = $meteo.current_weather.temperature
Write-Host "La température à $ville est de $temp °C."
