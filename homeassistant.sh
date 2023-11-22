current_directory=$(pwd)

# Back to the previous directory
cd /srv/dobo || exit

# Adding Pyenv to the file path of profile to run in any session
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Changing Python version
pyenv global 3.11.0
python3.11 -m pip install --upgrade pip
python3.11 -m venv home_assistant
# Installation of  Home Asistant
echo "Installing Home Assistant Core..."
python -m venv home_assistant
source /srv/dobo/home_assistant/bin/activate
python -m pip install wheel
python -m pip install requests --upgrade

pip install homeassistant==2023.11.0

if [ ! -d "configs/www" ]; then
  mkdir /srv/dobo/configs/
  mkdir /srv/dobo/configs/www
fi
if [ ! -d "media" ]; then
  mkdir /srv/dobo/media
fi

cd "$current_directory"
echo "Now run this: source /srv/dobo/home_assistant/bin/activate && hass"
echo "It will run Home-Assistant on: http://localhost:8123 or http://homeassistant:8123/"
