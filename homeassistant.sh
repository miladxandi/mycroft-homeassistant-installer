current_directory=$(pwd)

# Back to the previous directory
cd /srv/dobo || exit

# Changing Python version
pyenv global 3.11.0
python3.11 -m pip install --upgrade pip
# Installation of  Home Asistant
echo "Installing Home Assistant Core..."
python -m venv home_assistant
source /srv/dobo/home_assistant/bin/activate
python -m pip install wheel

pip install homeassistant==2023.11.0

if [ ! -d "configs/www" ]; then
  mkdir /srv/dobo/configs/
  mkdir /srv/dobo/configs/www
fi
if [ ! -d "media" ]; then
  mkdir /srv/dobo/media
fi

echo "Running Home Assistant Assistant on: http://localhost:8123 or http://homeassistant:8123/"
cd "$current_directory"
hass