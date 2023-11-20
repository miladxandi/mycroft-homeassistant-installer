current_directory=$(pwd)

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
                # Running installation scripts
                ./dev_setup.sh

                # Running its virtual env
                echo "Changing virtual env..."
                . venv-activate.sh

                echo "Running Dobo-Core..."
                ./start-mycroft.sh all
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
                # Running installation scripts
                ./dev_setup.sh

                # Running its virtual env
                echo "Changing virtual env..."
                . venv-activate.sh

                echo "Running Dobo-Core..."
                ./start-mycroft.sh all
                exit;;
            * ) echo "Only select Yes or No please!";;
        esac
    done

fi

deactivate

cd "$current_directory"