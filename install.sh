sudo pacman -S --needed terminus-font nodejs npm clang universal-ctags


rm /etc/vconsole.conf

rm /etc/fish/config.fish

rm -r /etc/vim
rm /etc/vimrc

rm -r /etc/tmux
rm /etc/tmux.conf


cp vconsole.conf /etc/

cp fish/config.fish /etc/fish/

cp -r vim/ /etc/
ln /etc/vim/vimrc /etc/

cp -r tmux/ /etc/
ln /etc/tmux/tmux.conf /etc/
