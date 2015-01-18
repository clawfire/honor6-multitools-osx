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

bootloader() {
    draw_header 4
    echo "***             1: Get Unlock Code                                          ***"
    echo "***             2: Unlock Bootloader                                        ***"
    echo "***             3: Relock Bootloader                                        ***"
    text_empty_line 2
    echo "***             M: Back to Main Menu                                        ***"
    echo "***             X: Exit                                                     ***"
    draw_footer 2
    vared -p "Select a number or letter and press ENTER : " -c selection
    case $selection in
        1 )
            open http://www.emui.com/plugin.php?id=unlock&mod=detail
            unlock
            ;;
        2 ) 
            vared -p "Enter your 16-digit unlock code : " -c unlock_code
            unlock $unlock_code
            ;;
        3 )
            vared -p "Enter your 16-digit unlock code : " -c relock_code
            relock $relock_code
            ;;
        * )
            bootloader
            ;;
    esac
}
unlock() {
    if [[ ! -z $1 ]]; then
        adb reboot bootloader
        fastboot devices
        fastboot oem unlock $1
        vared -p "Press enter when your phone indicate unlock success ..." -c key
        fastboot reboot
        menu
    else
        echo "ERROR : Please provide a correct 16 digit unlock code !!"
        vared -p "Enter your 16-digit unlock code : " -c unlock_code
        unlock $unlock_code
    fi
}

relock() {
    if [[ ! -z $1 ]]; then
        adb reboot bootloader
        fastboot devices
        fastboot oem relock $1
        vared -p "Press enter when your phone indicate unlock success ..." -c key
        fastboot reboot
        menu
    else
        echo "ERROR : Please provide a correct 16 digit unlock code !!"
        vared -p "Enter your 16-digit unlock code : " -c relock_code
        relock $relock_code
    fi
}

recovery() {

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
    draw_footer 2
    vared -p "Select a number or letter and press ENTER : " -c selection
    case $selection in
        1)
            bootloader
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