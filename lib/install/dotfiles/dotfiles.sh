# ------------------------------------------------------
# Define dotfiles folder
# ------------------------------------------------------
_writeLogHeader "Dotfiles"
_writeHeader "Dotfiles"

dot_folder="dotfiles"
dot_files_update=1

_define_dotfiles_folder() {
    _writeMessage "You can change the folder name if required (please avoid spaces)"
    echo
    dot_folder_tmp=$(gum input --value "$dot_folder" --placeholder "Enter your installation folder name")
    dot_folder=${dot_folder_tmp//[[:blank:]]/}
    echo $dot_folder
    if [[ $dot_folder == ".ml4w-hyprland" ]]; then
        _writeLogTerminal 2 "The folder .ml4w-hyprland is not allowed."
        _define_dotfiles_folder
    elif [ ! -z $dot_folder ]; then
        _confirm_dotfiles_folder
    else
        _writeLogTerminal 2 "Please define a folder name"
        _define_dotfiles_folder
    fi
}

_confirm_dotfiles_folder() {
    _writeLogTerminal 0 "The ML4W Dotfiles will be installed in ~/$dot_folder"
    if [ -d ~/$dot_folder ]; then
        _writeLogTerminal 0 "The folder ~/$dot_folder already exists and the files will be updated."
    fi
    echo
    if gum confirm "Do you want to use this folder?"; then
        _writeLogTerminal 1 "ML4W Dotfiles will be installed in ~/$dot_folder"
    elif [ $? -eq 130 ]; then
        _writeCancel
        exit 130
    else
        _define_dotfiles_folder
    fi
}

if [ -z $automation_dotfilesfolder ]; then
    if [ -f ~/.config/ml4w/settings/dotfiles-folder.sh ]; then
        _writeLogTerminal 0 "An existing ML4W Dotfiles folder has been detected: ~/$(cat ~/.config/ml4w/settings/dotfiles-folder.sh)"
        _writeLogTerminal 0 "You can update your existing ML4W Dotfiles in $(cat ~/.config/ml4w/settings/dotfiles-folder.sh) or install in a new folder."
        echo
        if gum confirm "Do you want to start the update in ~/$(cat ~/.config/ml4w/settings/dotfiles-folder.sh)"; then
            dot_folder=$(cat ~/.config/ml4w/settings/dotfiles-folder.sh)
            dot_files_update=0
        elif [ $? -eq 130 ]; then
            _writeCancel
            exit 130
        else
            _define_dotfiles_folder
        fi
    fi

    if [ $dot_files_update == "0" ]; then
        _writeLogTerminal 0 "Update will be executed in ~/$dot_folder"
        echo
    else
        _confirm_dotfiles_folder
    fi
else
    dot_folder=$automation_dotfilesfolder
    _writeLogTerminal 0 "AUTOMATION: Installation folder set to ~/$automation_dotfilesfolder"
fi
