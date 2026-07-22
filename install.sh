#!/bin/bash
set -e

sudo pacman -S --needed terminus-font nodejs npm clang universal-ctags fzf

# Install TTY color palette
sudo cp vtrgb /etc/vtrgb
sudo cp vtrgb.service /etc/systemd/system/vtrgb.service

sudo systemctl daemon-reload
sudo systemctl enable vtrgb.service
sudo systemctl restart vtrgb.service

# Remove old configs
sudo rm -f /etc/vconsole.conf
sudo rm -f /etc/fish/config.fish
sudo rm -rf /etc/vim
sudo rm -f /etc/vimrc
sudo rm -rf /etc/tmux
sudo rm -f /etc/tmux.conf

# Install new configs
sudo cp vconsole.conf /etc/vconsole.conf

sudo mkdir -p /etc/fish
sudo cp fish/config.fish /etc/fish/config.fish

sudo cp -r vim /etc/vim
sudo ln /etc/vim/vimrc /etc/vimrc

sudo cp -r tmux /etc/tmux
sudo ln /etc/tmux/tmux.conf /etc/tmux.conf

sudo chmod +x /etc/tmux/tmux-vt

tmux source /etc/tmux/tmux.conf