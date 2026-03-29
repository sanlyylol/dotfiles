#!/usr/bin/env bash

clone_repo () {
  if ! [[ pacman -Q git ]]; then
    echo "Downloading git package..."
    sudo pacman -S --noconfirm git
  fi
  echo "Cloning dotfiles repo"
  git clone https://github.com/sanlyylol/dotfiles
}

hyprland () {
  if [[ -e "~/.config/hypr" ]]; then
    while true; do 
      read -p "Hyprland config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting the config"; cp -r ./dotfiles/hyprland/.config/hypr ~/.config/hypr; break;;
      [nN]* ) echo "Skipping hyprland configuration"; return 0;;
      * ) ;; 
      esac
    done
  else
    if ! [[ pacman -Q hyprland ]]; then
      echo "Installing hyprland"
      sudo pacman -S --noconfirm hyprland
    fi
    echo "Copying hyprland config"
    cp -r ./dotfiles/hyprland/.config/hypr ~/.config/hypr
  fi
}

nvim () {
  if [[ -e "~/.config/nvim" ]]; then
    while true; do 
      read -p "Neovim config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting the config"; cp -r ./dotfiles/nvim/.config/nvim ~/.config/nvim; break;;
      [nN]* ) echo "Skipping neovim configuration"; return 0;;
      * ) ;; 
      esac
    done
  else 
    if ! [[ pacman -Q neovim ]]; then
      echo "Installing neovim"
      sudo pacman -S --noconfirm neovim
    fi
    echo "Copying nvim config"
    cp -r ./dotfiles/nvim/.config/nvim ~/.config/nvim
  fi
}

swaync () {
  if [[ -e "~/.config/swaync" ]]; then
    while true; do 
      read -p "Swaync config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting swaync config"; cp -r ./dotfiles/swaync/.config/swaync ~/.config/swaync; break;;
      [nN]* ) echo "Skipping swaync configuration"; return 0;;
      * ) ;; 
      esac
    done
  else 
    if ! [[ pacman -Q swaync ]]; then
      echo "Installing swaync + other packages"
      sudo pacman -S --noconfirm swaync
    fi
    echo "Copying swaync config"
    cp -r ./dotfiles/swaync/.config/swaync ~/.config/swaync
  fi
}

wezterm () {
  if [[ -e "~/wezterm.lua" ]]; then
    while true; do 
      read -p "wezterm config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting wezterm config"; cp ./dotfiles/wezterm/wezterm.lua ~/wezterm.lua; break;;
      [nN]* ) echo "Skipping wezterm configuration"; return 0;;
      * ) ;; 
      esac
    done
  else 
    if ! [[ pacman -Q wezterm ]]; then
      echo "Installing wezterm"
      sudo pacman -S --noconfirm wezterm
    fi
    echo "Copying wezterm config"
    cp ./dotfiles/wezterm/wezterm.lua ~/wezterm.lua
  fi
}

zsh () {
  if [[ -e "~/.zshrc" ]]; then
    while true; do 
      read -p "zsh config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting zsh config"; cp ./dotfiles/zsh/.zshrc ~/.zshrc; break;;
      [nN]* ) echo "Skipping zsh configuration"; return 0;;
      * ) ;; 
      esac
    done
  else 
    if ! [[ pacman -Q zsh ]]; then
      echo "Installing zsh"
      sudo pacman -S --noconfirm zsh
    fi
    echo "Copying zsh config"
    cp ./dotfiles/zsh/.zshrc ~/.zshrc
  fi
  chsh -s /bin/zsh
}

wallpapers () {
  echo "Copying wallpapers to ~/Pictures"
  cp -r ./dotfiles/wallpapers ~/Pictures
}

wlogout () {
  if [[ -e "~/.config/wlogout" ]]; then
    while true; do 
      read -p "wlogout config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting wlogout config"; cp -r ./dotfiles/wlogout/.config/wlogout ~/.config/wlogout; break;;
      [nN]* ) echo "Skipping wlogout configuration"; return 0;;
      * ) ;; 
      esac
    done
  else 
    if ! [[ pacman -Q wlogout ]]; then
      echo "Installing wlogout"
      sudo pacman -S --noconfirm wlogout
    fi
    echo "Copying wlogout config"
    cp -r ./dotfiles/wlogout/.config/wlogout ~/.config/wlogout
  fi
}

waybar () {
  if [[ -e "~/.config/waybar" ]]; then
    while true; do 
      read -p "waybar config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting waybar config"; cp -r ./dotfiles/waybar/.config/waybar ~/.config/waybar; break;;
      [nN]* ) echo "Skipping waybar configuration"; return 0;;
      * ) ;; 
      esac
    done
  else 
    if ! [[ pacman -Q waybar ]]; then
      echo "Installing waybar"
      sudo pacman -S --noconfirm waybar
    fi
    echo "Copying waybar config"
    cp -r ./dotfiles/waybar/.config/waybar ~/.config/waybar
  fi
}

wofi () {
  if [[ -e "~/.config/wofi" ]]; then
    while true; do 
      read -p "wofi config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting wofi config"; cp -r ./dotfiles/wofi/.config/wofi ~/.config/wofi; break;;
      [nN]* ) echo "Skipping wofi configuration"; return 0;;
      * ) ;; 
      esac
    done
  else 
    if ! [[ pacman -Q wofi ]]; then
      echo "Installing wofi"
      sudo pacman -S --noconfirm wofi
    fi
    echo "Copying wofi config"
    cp -r ./dotfiles/wofi/.config/wofi ~/.config/wofi
  fi
}

hy3 () {
  hyprpm update
  hyprpm add https://github.com/outfoxxed/hy3
  hyprpm enable hy3
}

packages () {
  echo "Installing additional packages"
  sudo pacman -S --noconfirm lua luarocks nwg-displays swaybg swayidle swayimg swaylock grc ripgrep exa fzf zoxide bat fd hyrprland-qt-support hyprlock hyprpicker hyprpolkitagent hyprshot hyprtoolkit cpio cmake glaze meson uwsm xdg-desktop-portal-hyprland awww thunar flameshot sddm
  echo "Setting up headers" 
  INSTALLED_KERNEL=$(pacman -Qq | grep -E '^linux(-lts|-zen|-hardened)?$')
  HEADER_PACKAGES=""
  for kernel in $INSTALLED_KERNELS; do 
    HEADER_PACKAGES+="${kernel}-headers "
  done
  
  if [ -n "$HEADER_PACKAGES" ]; then
    echo "Installing headers"
    sudo pacman -S --needed --noconfirm $HEADER_PACKAGES
  else
    echo "Nonstandard kernel, install headers manually"
  fi
}

font () {
  echo "Setting up the font"
  if ! [[ -e ~/.local/share/fonts ]]; then
    mkdir -p ~/.local/share/fonts
  fi
  cp ./dotfiles/FiraCodeNerdFontPropo-Retina.ttf ~/.local/share/fonts
  fc-cache -vf
}

sddm () {
  if [[ -e "/etc/sddm.conf" ]]; then
    while true; do 
      read -p "sddm config detected. Do you want to overwrite the current config? (y/n)" yn
      case $yn in
      [yY]* ) echo "Overwriting sddm config"; cp -r ./dotfiles/sddm/etc/* /etc; cp -r ./dotfiles/sddm/usr/share/* /usr/share; break;;
      [nN]* ) echo "Skipping sddm configuration"; return 0;;
      * ) ;; 
      esac
    done
  else 
    if ! [[ pacman -Q sddm ]]; then
      echo "Installing sddm"
      sudo pacman -S --noconfirm sddm
    fi
    echo "Copying sddm config"
    cp -r ./dotfiles/sddm/etc/* /etc
    cp -r ./dotfiles/sddm/usr/share/* /usr/share 
  fi
}

echo "Updating the system"
sudo pacman -Syu
clone_repo

while true; do 
  read -p "What to install?:
  (0) exit
  (1) hyprland
  (2) neovim
  (3) wezterm
  (4) zsh
  (5) wallpapers (contains the default for hyprland.conf)
  (6) wlogout
  (7) waybar
  (8) wofi
  (9) sddm
  (10) packages (needed for other programs)
  (11) font (without it some stuff looks bad)
  (12) hy3 plugin (it's a plugin for hyprland that you NEED for my hyprland config to be 
  functional but it's only availble after: installing hyprland; packages; and rebooting" input
  case $input in 
    0 ) break;;
    1 ) hyprland;; 
    2 ) nvim;;
    3 ) wezterm;;
    4 ) zsh;;
    5 ) wallpapers;;
    6 ) wlogout;;
    7 ) waybar;;
    8 ) wofi;;
    9 ) sddm;;
    10 ) packages;;
    11 ) font;;
    12 ) hy3;;
    * ) ;;
  esac
done
    
read -p "Script finished. The system most likely requires a reboot.
Reboot now? (y/n)" i
case $i in 
  [yY]* ) sudo reboot;;
  * ) exit;;
esac
