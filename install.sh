#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

sudo pacman -S --needed terminus-font gvim tmux fish nodejs npm clang universal-ctags fzf fastfetch

# Install TTY color palette
sudo cp vtrgb /etc/vtrgb
sudo cp vtrgb.service /etc/systemd/system/vtrgb.service
sudo cp vtrgb.path /etc/systemd/system/vtrgb.path

sudo systemctl daemon-reload
sudo systemctl enable vtrgb.service
sudo systemctl enable vtrgb.path
sudo systemctl restart vtrgb.service
sudo systemctl restart vtrgb.path

# Remove old configs
sudo rm -f /etc/vconsole.conf
sudo rm -f /etc/fish/config.fish
sudo rm -rf /etc/vim
sudo rm -f /etc/vimrc
sudo rm -rf /etc/tmux
sudo rm -f /etc/tmux.conf
sudo rm -rf /etc/fastfetch

# Install new configs
sudo cp vconsole.conf /etc/vconsole.conf

sudo mkdir -p /etc/fish
sudo cp fish/config.fish /etc/fish/config.fish

sudo cp -r vim /etc/vim
sudo ln -sf /etc/vim/vimrc /etc/vimrc

sudo cp -r tmux /etc/tmux
sudo ln -sf /etc/tmux/tmux.conf /etc/tmux.conf

sudo cp -r fastfetch /etc/fastfetch

# Make sure fish is a valid login shell
if ! grep -qx "$(command -v fish)" /etc/shells; then
    echo "$(command -v fish)" | sudo tee -a /etc/shells >/dev/null
fi

# Change the invoking user's default shell
sudo chsh -s "$(command -v fish)" $USER

fish -c "source /etc/fish/config.fish"
printf '\033[32mInstallation complete.\033[0m\n'
