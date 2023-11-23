current_directory=$(pwd)


su - dobo -c '1234'

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
pip install pyxdg
pip install Cython

pyenv global 3.10.0
python3.10 -m pip install --upgrade pip
pip install requests
pip install pyxdg
pip install Cython

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

    # Running its virtual env
    echo "Changing virtual env..."
    . venv-activate.sh
    pip install Cython

    # Running installation scripts
    sudo ./dev_setup.sh --allow-root

    echo "Running Dobo-Core..."
    ./start-mycroft.sh all

else

    echo "Dobo-Core folder is exist, so Dobo-Core installation skipped!"
    cd /srv/dobo/dobo-core/ || exit

    # Running its virtual env
    echo "Changing virtual env..."
    . venv-activate.sh
    pip install Cython

    while true; do
        read -p "Is it running correctly? (yes/no): say hey dobo to test it." answer
        case $answer in
            [Yy]* )
                echo "Dobo-Core is running now!!"
                break;;
            [Nn]* )
                # Running installation scripts
                sudo ./dev_setup.sh --allow-root

                echo "Running Dobo-Core..."
                ./start-mycroft.sh all
                exit;;
            * ) echo "Only select Yes or No please!";;
        esac
    done

    echo "Running Dobo-Core..."
    ./start-mycroft.sh all restart
fi

deactivate

cd "$current_directory"