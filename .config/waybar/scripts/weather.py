#!/usr/bin/env python3
import requests
from datetime import datetime, timedelta, timezone


API_KEY = "openweathermap_api_key"
CITY = ""  # your city
UNITS = "" # metric/imperial
LANG = "en"

WEATHER_EMOJIS = {
    "clear": "☀️",
    "clouds": "☁️",
    "rain": "🌧️",
    "drizzle": "🌦️",
    "thunderstorm": "⛈️",
    "snow": "❄️",
    "mist": "🌫️",
    "fog": "🌫️",
    "haze": "🌫️",
    "smoke": "💨",
    "dust": "🌪️",
    "sand": "🏜️",
    "ash": "🌋",
    "squall": "💨",
    "tornado": "🌪️",
}

def get_emoji(description):
    key = description.lower()
    for word, emoji in WEATHER_EMOJIS.items():
        if word in key:
            return emoji
    return "🌡️"


def get_weather():
    url = f"http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}&units={UNITS}&lang={LANG}"
    response = requests.get(url)
    response.raise_for_status()
    data = response.json()
    current_temp = data['main']['temp']
    description = data['weather'][0]['description'].capitalize()
    icon = data['weather'][0]['icon']
    return f"{round(current_temp)}°C", description, icon

def get_tomorrow_forecast():
    url = f"http://api.openweathermap.org/data/2.5/forecast?q={CITY}&appid={API_KEY}&units={UNITS}&lang={LANG}"
    response = requests.get(url)
    response.raise_for_status()
    data = response.json()
    
    tomorrow = (datetime.now(timezone.utc) + timedelta(days=1)).date()
    forecasts = [item for item in data['list'] if datetime.fromtimestamp(item['dt']).date() == tomorrow]
    
    if not forecasts:
        return "No forecast available"

    avg_temp = sum(f['main']['temp'] for f in forecasts) / len(forecasts)
    descriptions = [f['weather'][0]['description'] for f in forecasts]
    description = max(set(descriptions), key=descriptions.count).capitalize()

    return f"Tomorrow: {round(avg_temp)}°C, {description}"

def main():
    try:
        temp, desc, _ = get_weather()
        emoji = get_emoji(desc)
        forecast = get_tomorrow_forecast()
        tooltip = f"{desc}\\n{forecast}"
        print(f'{{ "text": "{emoji} {temp}", "tooltip": "{tooltip}" }}')
    except Exception as e:
        print(f'{{ "text": "N/A", "tooltip": "Error: {str(e)}" }}')

if __name__ == "__main__":
    main()
