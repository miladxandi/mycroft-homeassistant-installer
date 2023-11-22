#!/bin/bash
current_directory=$(pwd)
while true; do
    core=""
    dobo=""
    homeassistant=""
    if ! id "dobo" &>/dev/null; then
      core="❌ 1.Core libraries"
    else
      core="✅ 1.Core libraries"
    fi
    if [ ! -d "/srv/dobo/dobo-core" ]; then
      dobo="❌ 2.Dobo-Core"
    else
      dobo="✅ 2.Dobo-Core"
    fi
    if [ ! -d "/srv/dobo/home_assistant" ]; then
      homeassistant="❌ 3.Home-Assistant"
    else
      homeassistant="✅ 3.Home-Assistant"
    fi

    quit="4. Exit"

    read -p "What do you want to install?
    $core
    $dobo
    $homeassistant
    $quit
    Selected Option: " answer
    case $answer in
        1 )
            echo "Installing core libraries ..."
            bash libraries.sh
            break;;
        2 )
            echo "Installing Dobo-Core ..."
            bash dobocore.sh
            break;;
        3 )
            echo "Installing Home-Assistant ..."
            bash homeassistant.sh
            break;;
        * )
            echo "Installation skipped!"
            exit;;
    esac
done
cd "$current_directory"
bash installer.sh