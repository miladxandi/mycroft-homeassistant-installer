echo "Running MyCroft-Core..."

if [ ! -d "mycroft-core" ]; then
    echo "Mycroft-Core is not installed!"
    echo "Try 'bash installer.sh'"
else
    echo "Mycroft-Core folder is exist, so Mycroft-Core installation skipped!"
    cd mycroft-core/
    . venv-activate.sh
    echo "Running Mycroft-Core..."
    ./start-mycroft.sh all restart
    echo "Mycroft-Core is running now!!"
fi

# Back to the previous directory
cd ..

# Changing Python version
pyenv global 3.11.0
source home_assistant/bin/activate

echo "Running Home Assistant Assistant on: http://localhost:8123 or http://homeassistant:8123/"
hass -c configuration.yaml