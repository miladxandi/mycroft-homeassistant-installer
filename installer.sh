#!/bin/bash

# Change user
if ! id "dobo" &>/dev/null; then
  # Installing require updates
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y curl git build-essential libssl-dev libffi-dev libbz2-dev libreadline-dev libsqlite3-dev bluez libjpeg-dev liblzma-dev python3-tk zlib1g-dev autoconf libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata ffmpeg liblapack3 liblapack-dev python-tk python3-tk tk-dev

  sudo mkdir /srv/dobo
  pass="1234"
  encrypted_password=$(echo -n "$pass" | openssl passwd -stdin -6)
  sudo useradd -rm -p "$encrypted_password" dobo
  cd /srv/dobo || exit
  echo -e "We created a new user:\nUsername:dobo\nPassword:1234\nPlease rerun ths script!"
else
  while true; do
    read -p "Do you want to install linux libraries again? (yes/no):" answer
    case $answer in
        [Yy]* )
            echo "Installing linux libraries ..."
            sudo apt update && sudo apt upgrade -y
            sudo apt install -y curl git build-essential libssl-dev libffi-dev libbz2-dev libreadline-dev libsqlite3-dev bluez libjpeg-dev liblzma-dev python3-tk zlib1g-dev autoconf libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata ffmpeg liblapack3 liblapack-dev python-tk python3-tk tk-dev
            echo "Installation completed!"
            break;;
        [Nn]* )
            echo "Installation skipped!"
            break;;
        * )
            echo "Installation skipped!"
            break;;
    esac
  done
  sudo chown dobo:dobo /srv/dobo
  sudo -u dobo -H -s
  echo -e "Now the current user is dobo!"
  su - dobo -c '1234'
fi


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
pip install mutagen

pyenv global 3.10.0
python3.10 -m pip install --upgrade pip
pip install requests
# Check versions
python --version
pip --version

# Go to the srv directory
cd /srv/dobo || exit


if [ ! -d "dobo-core" ]; then

    # Cloning MyCroft-Core form github
    git clone https://github.com/DoboAI/dobo-core.git
    cd /srv/dobo/dobo-core/ || exit

    echo "Has changed"
    python --version

    # Running installation scripts
    ./dev_setup.sh

    # Running its virtual env
    echo "Changing virtual env..."
    . venv-activate.sh

    echo "Running Dobo-Core..."
    ./start-mycroft.sh all

    while true; do
        read -p "Is it running correctly? (yes/no): say hey dobo to test it." answer
        case $answer in
            [Yy]* )
                echo "Dobo-Core Has been installed & now is running!"
                break;;
            [Nn]* )
                echo "Running Canceled! run ./dev_setup.sh manually. "
                exit;;
            * ) echo "Only select Yes or No please!";;
        esac
    done

else

    echo "Dobo-Core folder is exist, so Dobo-Core installation skipped!"
    cd /srv/dobo/dobo-core/ || exit

    # Running its virtual env
    echo "Changing virtual env..."
    . venv-activate.sh

    echo "Running Dobo-Core..."
    ./start-mycroft.sh all restart
    while true; do
        read -p "Is it running correctly? (yes/no): say hey dobo to test it." answer
        case $answer in
            [Yy]* )
                echo "Dobo-Core is running now!!"
                break;;
            [Nn]* )
                echo "Running Canceled! run ./dev_setup.sh manually. "
                exit;;
            * ) echo "Only select Yes or No please!";;
        esac
    done

fi

deactivate

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
hass