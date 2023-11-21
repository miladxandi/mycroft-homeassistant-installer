current_directory=$(pwd)

if ! id "dobo" &>/dev/null; then
  # Installing require updates
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y curl git build-essential libssl-dev libffi-dev libbz2-dev libreadline-dev libsqlite3-dev bluez libjpeg-dev liblzma-dev python3-tk zlib1g-dev autoconf libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata ffmpeg liblapack3 liblapack-dev python-tk python3-tk tk-dev

  sudo mkdir /srv/dobo
  sudo mkdir /opt/mycroft
  sudo mkdir /var/log/mycroft
  sudo ufw allow 8123
  pass="1234"
  encrypted_password=$(echo -n "$pass" | openssl passwd -stdin -6)
  sudo useradd -rm -p "$encrypted_password" dobo
  cd /srv/dobo || exit
  echo -e "We created a new user:\nUsername:dobo\nPassword:1234\nPlease rerun the script from this folder:\n$current_directory"
  sudo chown dobo:dobo /srv/dobo
  sudo chown dobo:dobo /opt/mycroft
  sudo chown dobo:dobo /var/log/mycroft
  sudo -u dobo -H -s
  # Change user
  echo -e "Now the current user is dobo!"
  su - dobo -c '1234'
  exit;
else
  while true; do
    read -p "Do you want to install linux libraries again? (yes/no):" answer
    case $answer in
        [Yy]* )
            echo "Installing linux libraries ..."
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
            pip install mutagen

            pyenv global 3.10.0
            python3.10 -m pip install --upgrade pip
            pip install requests
            # Check versions
            python --version
            pip --version
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
fi

cd "$current_directory"