#!/bin/bash

# Installing require updates
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential libssl-dev libffi-dev libbz2-dev libreadline-dev libsqlite3-dev bluez libjpeg-dev liblzma-dev python3-tk zlib1g-dev autoconf libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata ffmpeg liblapack3 liblapack-dev python-tk python3-tk tk-dev

# Pyenv installation
curl https://pyenv.run | bash

# Adding Pyenv to the file path of profile to run in any session
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Installing Python 3.11 & 3.10 with Pyenv
pyenv install 3.11.0
pyenv install 3.10.0

# Setting default version of python
pyenv global 3.11.0

# Installing require Python libraries
pyenv global 3.11.0
python3.11 -m pip install --upgrade pip
pip install requests

pyenv global 3.10.0
python3.10 -m pip install --upgrade pip
pip install requests
# Check versions
python --version
pip --version

# Go to the opt directory
cd /opt/ || exit

if [ ! -d "mycroft-core" ]; then

    # Cloning MyCroft-Core form github
    sudo git clone https://github.com/MycroftAI/mycroft-core.git
    cd mycroft-core/ || exit

    sudo chmod -R 777 /opt/
    sudo chmod -R /var/log/mycroft/
    sudo touch /var/mycroft/setup.log
    sudo chmod -R /var/log/mycroft/setup.log

    # Running its virtual env
    echo "Changing virtual env..."
    . venv-activate.sh
    echo "Has changed"
    python --version

    # Running installation script
    ./dev_setup.sh

    echo "Running Mycroft-Core..."
    ./start-mycroft.sh all
    echo "Mycroft-Core Has been installed & now is running!"
else
    echo "Mycroft-Core folder is exist, so Mycroft-Core installation skipped!"
    cd mycroft-core/ || exit
    echo "Running Mycroft-Core..."
    ./start-mycroft.sh all restart
    echo "Mycroft-Core is running now!!"
fi


# Back to the previous directory
cd ..

# Changing Python version
pyenv global 3.11.0
python3.11 -m pip install --upgrade pip
# Installation of  Home Asistant
echo "Installing Home Assistant Core..."
python -m venv home_assistant
source home_assistant/bin/activate
python -m pip install wheel
pip install mutagen

pip install homeassistant==2023.11.0

if [ ! -d "configs/www" ]; then
  mkdir configs/www
fi
if [ ! -d "media" ]; then
  mkdir media
fi

echo "Running Home Assistant Assistant on: http://localhost:8123 or http://homeassistant:8123/"
hass