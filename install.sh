#!/bin/sh
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\x1b[5m'

rm -rf ~/dragoonDoriseTools
sleep 5
mkdir dragoonDoriseTools
mkdir dragoonDoriseTools/EmuDeck
cd dragoonDoriseTools

echo -ne "Downloading files..."

git clone https://github.com/dragoonDorise/EmuDeck.git ~/dragoonDoriseTools/EmuDeck &>> /dev/null
curl https://github.com/SteamGridDB/steam-rom-manager/releases/download/v2.3.29/Steam-ROM-Manager-2.3.29.AppImage --output ~/Desktop/Steam-ROM-Manager-2.3.29.AppImage &>> /dev/null

FOLDER=~/dragoonDoriseTools/EmuDeck
if [ -d "$FOLDER" ]; then
	echo -e "${GREEN}Done${NONE}"
else
	echo -e ""
	echo -e "${RED}We couldn't dowload the needed files, exiting in a few seconds${NONE}"
	echo -e "Please try again in a few minutes"
	sleep 10
	exit
fi
#Get SD Card name
sdCard=$(ls /run/media)
sdCardPath="/run/media/${sdCard}"

##Generate rom folders
echo -e "Creating roms folder in your SD Card..."

mkdir -p $sdCardPath/romss
rsync -r ~/dragoonDoriseTools/EmuDeck/roms/ $sdCardPath/romss/ &>> /dev/null


#Check for installed emulators
doRA=false
doDolphin=false
doPCSX2=false
doRPCS3=false
doYuzu=false
doCitra=false
doduck=false

#RA
FOLDER=~/.var/app/org.libretro.RetroArch/
echo -ne "Checking RA installation..."
if [ -d "$FOLDER" ]; then
	echo -e "${GREEN}OK!${NONE}"
	doRA=true
else
	echo -e "${RED}KO :(${NONE}"
	echo -e "${RED}Install and launch Retroarch from the Discover App if you want to configure it${NONE}"
fi
#Dolphin
FOLDER=~/.var/app/org.DolphinEmu.dolphin-emu/
echo -ne "Checking Dolphin installation..."
	if [ -d "$FOLDER" ]; then
		echo -e "${GREEN}OK!${NONE}"
		doDolphin=true
else
		echo -e "${RED}KO :(${NONE}"
		echo -e "${RED}Install and launch Dolphin from the Discover App if you want to configure it${NONE}"
	fi

#PS2
FOLDER=~/.var/app/net.pcsx2.PCSX2/
echo -ne "Checking PCSX2 installation..."
	if [ -d "$FOLDER" ]; then
		echo -e "${GREEN}OK!${NONE}"
		doPCSX2=false
else
		echo -e "${RED}KO :(${NONE}"
		echo -e "${RED}Install and launch PCSX2 from the Discover App if you want to configure it${NONE}"
	fi

#PS3
FOLDER=~/.var/app/net.rpcs3.RPCS3/
echo -ne "Checking RPCS3 installation..."
	if [ -d "$FOLDER" ]; then
		echo -e "${GREEN}OK!${NONE}"
		doRPCS3=false
else
		echo -e "${RED}KO :(${NONE}"
		echo -e "${RED}Install and launch RPCS3 from the Discover App if you want to configure it${NONE}"
	fi

#YUZU
FOLDER=~/.var/app/org.yuzu_emu.yuzu/
echo -ne "Checking Yuzu installation..."
	if [ -d "$FOLDER" ]; then
		echo -e "${GREEN}OK!${NONE}"
		doYuzu=false
else
		echo -e "${RED}KO :(${NONE}"
		echo -e "${RED}Install and launch Yuzu from the Discover App if you want to configure it${NONE}"
	fi
#Citra
	FOLDER=~/.var/app/org.citra_emu.citra/
	echo -ne "Checking Citra installation..."
	if [ -d "$FOLDER" ]; then
		echo -e "${GREEN}OK!${NONE}"
		doCitra=true
	else
		echo -e "${RED}KO :(${NONE}"
		echo -e "${RED}Install and launch Citra from the Discover App if you want to configure it${NONE}"
	fi
#Duckstation
	FOLDER=~/.var/app/org.duckstation.DuckStation/
	echo -ne "Checking Duckstation installation..."
	if [ -d "$FOLDER" ]; then
		echo -e "${GREEN}OK!${NONE}"
		doDuck=true
	else
		echo -e "${RED}KO :(${NONE}"
		echo -e "${RED}Install and launch Duckstation from the Discover App if you want to configure it${NONE}"
	fi


sleep 30

exit

#Emus config
if [ $doRA == true ]; then

	raConfigFile="~/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg"
	FILE=~/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg.bak
	if [ -d "$FILE" ]; then
		echo -e "RA Already backed up."
	else
		echo -e "Backing up RA..."
		cp /home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg /home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg.bak
	fi
	mkdir /home/deck/.var/app/org.libretro.RetroArch/config/retroarch/overlays
	rsync -r ~/dragoonDoriseTools/EmuDeck/configs/org.libretro.RetroArch/config/retroarch/overlays/ ~/.var/app/org.libretro.RetroArch/config/retroarch/overlays
	rsync -r ~/dragoonDoriseTools/EmuDeck/configs/org.libretro.RetroArch/config/retroarch/config/ ~/.var/app/org.libretro.RetroArch/config/retroarch/config
#
	sed -i 's/config_save_on_exit = "true"/config_save_on_exit = "false"/g' $raConfigFile
	sed -i 's/input_overlay_enable = "true"/input_overlay_enable = "false"/g' $raConfigFile
	sed -i 's/menu_show_load_content_animation = "true"/menu_show_load_content_animation = #"false"/g' $raConfigFile
	sed -i 's/notification_show_autoconfig = "true"/notification_show_autoconfig = "false"/g' $raConfigFile
	sed -i 's/notification_show_config_override_load = #"true"/notification_show_config_override_load = "false"/g' $raConfigFile
	sed -i 's/notification_show_refresh_rate = "true"/notification_show_refresh_rate = "false"/g' $raConfigFile
	sed -i 's/notification_show_remap_load = "true"/notification_show_remap_load = "false"/g' $raConfigFile
	sed -i 's/notification_show_screenshot = "true"/notification_show_screenshot = "false"/g' $raConfigFile
	sed -i 's/notification_show_set_initial_disk = "true"/notification_show_set_initial_disk = #"false"/g' $raConfigFile
	sed -i 's/notification_show_patch_applied = "true"/notification_show_patch_applied = #"false"/g' $raConfigFile
	
	#sed -i 's/input_menu_toggle_gamepad_combo = "0"/input_menu_toggle_gamepad_combo = "6"/g' $raConfigFile
	#sed -i 's/input_enable_hotkey_btn = "nul"/input_enable_hotkey_btn = "4"/g' $raConfigFile
	#sed -i 's/input_exit_emulator_btn = "nul"/input_exit_emulator_btn = "108"/g' $raConfigFile
	#sed -i 's/input_load_state_btn = "nul"/input_load_state_btn = "9"/g' $raConfigFile
	#sed -i 's/input_menu_toggle_gamepad_combo = "nul"/input_menu_toggle_gamepad_combo = "6"/g' $raConfigFile
	#sed -i 's/input_rewind_btn = "nul"/input_rewind_btn = "104"/g' $raConfigFile
	#sed -i 's/input_save_state_btn = "nul"/input_save_state_btn = "10"/g' $raConfigFile
	#sed -i 's/input_state_slot_decrease_btn = "nul"/input_state_slot_decrease_btn = "h0down"/g' $raConfigFile
	#sed -i 's/input_state_slot_increase_btn = "nul"/input_state_slot_increase_btn = "h0up"/g' $raConfigFile
	#sed -i 's/input_toggle_fast_forward_btn = "nul"/input_toggle_fast_forward_btn = "+5"/g' $raConfigFile

fi

if [ $doDolphin == true ]; then
	rsync -r ~/dragoonDoriseTools/EmuDeck/configs/org.DolphinEmu.dolphin-emu/ ~/.var/app/org.DolphinEmu.dolphin-emu/
fi
if [ $doPCSX2 == true ]; then
	rsync -r ~/dragoonDoriseTools/EmuDeck/configs/net.pcsx2.PCSX2/ ~/.var/app/net.pcsx2.PCSX2/
fi
if [ $doRPCS3 == true ]; then
	rsync -r ~/dragoonDoriseTools/EmuDeck/configs/net.rpcs3.RPCS3/ ~/.var/app/net.rpcs3.RPCS3/
fi
if [ $doCitra == true ]; then
		rsync -r ~/dragoonDoriseTools/EmuDeck/configs/org.citra_emu.citra/ ~/.var/app/org.citra_emu.citra/
	fi
if [ $doduck == true ]; then
		rsync -r ~/dragoonDoriseTools/EmuDeck/configs/org.DolphinEmu.dolphin-emu/ ~/.var/app/org.DolphinEmu.dolphin-emu/
	fi
	
if [ $doYuzu == true ]; then
	rsync -r ~/dragoonDoriseTools/EmuDeck/configs/org.DolphinEmu.dolphin-emu/ ~/.var/app/org.DolphinEmu.dolphin-emu/
fi
	


#

#Retroarch config

#cp /home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg /home/deck/.#var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg.bak
sed -i 's/config_save_on_exit = "true"/config_save_on_exit = "false"/g' $raConfigFile
sed -i 's/input_overlay_enable = "true"/input_overlay_enable = "false"/g' $raConfigFile
sed -i 's/menu_show_load_content_animation = "true"/menu_show_load_content_animation = #"false"/g' /home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/notification_show_autoconfig = "true"/notification_show_autoconfig = "false"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/notification_show_config_override_load = #"true"/notification_show_config_override_load = "false"/g' /home/deck/.var/app/org.libretro.#RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/notification_show_refresh_rate = "true"/notification_show_refresh_rate = "false"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/notification_show_remap_load = "true"/notification_show_remap_load = "false"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/notification_show_screenshot = "true"/notification_show_screenshot = "false"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/notification_show_set_initial_disk = "true"/notification_show_set_initial_disk = #"false"/g' /home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/notification_show_patch_applied = "true"/notification_show_patch_applied = #"false"/g' /home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/input_menu_toggle_gamepad_combo = "0"/input_menu_toggle_gamepad_combo = "6"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/input_enable_hotkey_btn = "nul"/input_enable_hotkey_btn = "4"/g' $raConfigFile
sed -i 's/input_exit_emulator_btn = "nul"/input_exit_emulator_btn = "108"/g' $raConfigFile
sed -i 's/input_load_state_btn = "nul"/input_load_state_btn = "9"/g' /home/deck/.var/app/org.#libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/input_menu_toggle_gamepad_combo = "nul"/input_menu_toggle_gamepad_combo = "6"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/input_rewind_btn = "nul"/input_rewind_btn = "104"/g' /home/deck/.var/app/org.#libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/input_save_state_btn = "nul"/input_save_state_btn = "10"/g' /home/deck/.var/app/org.#libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/input_state_slot_decrease_btn = "nul"/input_state_slot_decrease_btn = "h0down"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/input_state_slot_increase_btn = "nul"/input_state_slot_increase_btn = "h0up"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/input_toggle_fast_forward_btn = "nul"/input_toggle_fast_forward_btn = "+5"/g' #/home/deck/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg 
sed -i 's/menu_driver = "glui"/menu_driver = "ozone"/g' /home/deck/.var/app/org.libretro.#RetroArch/config/retroarch/retroarch.cfg 
