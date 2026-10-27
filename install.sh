#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Distro check Arch or Debian
. /etc/os-release
distro=" ${ID:-} ${ID_LIKE:-} "

if [[ $distro == *" arch "* ]]; then
    sudo pacman -S --needed terminus-font gvim tmux fish zsh \
        zsh-autosuggestions zsh-syntax-highlighting \
        nodejs npm clang universal-ctags fzf fastfetch alacritty
elif [[ $distro == *" debian "* ]]; then
    sudo apt-get update
    sudo apt-get install -y xfonts-terminus vim-gtk3 tmux fish zsh \
        zsh-autosuggestions zsh-syntax-highlighting \
        nodejs npm clang universal-ctags fzf fastfetch alacritty
else
    echo "Unsupported distro: ${PRETTY_NAME:-unknown} (need Arch or Debian based)" >&2
    exit 1
fi

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
sudo rm -fr /etc/zsh
sudo rm -fr /etc/vim
sudo rm -f /etc/vimrc
sudo rm -fr /etc/tmux
sudo rm -f /etc/tmux.conf
sudo rm -fr /etc/fastfetch
sudo rm -fr /etc/alacritty
sudo rm -fr /etc/xdg/alacritty

# Install new configs
sudo cp vconsole.conf /etc/vconsole.conf
sudo mkdir -p /etc/fish
sudo cp fish/config.fish /etc/fish/config.fish
sudo cp -r zsh /etc/zsh
sudo cp -r vim /etc/vim
sudo ln -sf /etc/vim/vimrc /etc/vimrc
sudo cp -r tmux /etc/tmux
sudo ln -sf /etc/tmux/tmux.conf /etc/tmux.conf
sudo cp -r fastfetch /etc/fastfetch
sudo cp -r alacritty /etc/alacritty
sudo cp -r alacritty /etc/xdg/alacritty

# Make sure zsh and fish are valid login shells
for sh in zsh fish; do
    p="$(command -v $sh)"
    if ! grep -qx "$p" /etc/shells; then
        echo "$p" | sudo tee -a /etc/shells >/dev/null
    fi
done

sudo chsh -s "$(command -v zsh)" "$USER"

zsh -n /etc/zsh/zshrc
fish -c "source /etc/fish/config.fish"
printf '\033[32mInstallation complete. Log out and back in for zsh to take effect.\033[0m\n'
