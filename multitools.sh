#! /bin/zsh
local version="0.1.0";

draw_header() {
    clear
    echo "==============================================================================="
    echo "***               HONOR6 Multi-Tool OSX by clawfire v$version                  ***"
    echo "==============================================================================="
    if [[ ! -z $1 ]]; then
        text_empty_line $1
    fi
}
draw_footer() {
    if [[ ! -z $1 ]]; then
        text_empty_line $1
    fi
    echo "==============================================================================="
}

text_empty_line() {
    if [[ ! -z $1 ]]; then
        for (( i = 0; i < $1; i++ )); do
            echo "***                                                                         ***"
        done 
    else
        echo "***                                                                         ***"
    fi
}

install_brew() {
    draw_header 8
    echo "***                      Testing if brew is installed                       ***"
    draw_footer 8
    if [[ ! -a "/usr/local/bin/brew" ]]; then
        draw_header 8
        echo "***                           Installing brew                               ***"
        draw_footer 8
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
}
install_adb() {
    draw_header 8
    echo "***          Testing if adb, fastboot and the drivers are installed         ***"
    draw_footer 8
    if [[ ! -a "/usr/local/bin/adb" ]] && [[ ! -a "/usr/local/bin/fastboot" ]]; then
        echo "***       Installing Android Plateform Tools (drivers, adb, fastboot)       ***"
        brew install android-platform-tools
    fi
}





menu() {
    draw_header 4
    echo "***              1: Bootloader                                              ***"
    echo "***              2: Recovery                                                ***"
    text_empty_line 2
    echo "***              3: Stock ROMs (EMUI)                                       ***"
    echo "***              4: Stock ROMs (MIRROR)                                     ***"
    text_empty_line 2
    echo "***              X: Exit                                                    ***"
    text_empty_line 2
    echo "==============================================================================="
    vared -p "Select a number or letter and press ENTER : " -c selection
    case $selection in
        1)
            echo "bootloader"
            ;;
        2)
            echo "Recovery"
            ;;
        3)
            echo "Stock ROM EMUI"
            ;;
        4)
            echo "Stock ROM MIRROR"
            ;;
        x)
            exit 1
            ;;
        *)
            echo "Please use a value in the menu"
            menu
    esac
}

install_brew
install_adb
menu