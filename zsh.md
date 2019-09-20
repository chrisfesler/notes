# setting up zsh on windows ubuntu

After a little research, I decided to try [zplug](https://github.com/zplug/zplug). I've used oh-my-zsh
previously, but it always felt bloated and hard to manage. Perhaps this will be better.

```
# manage zsh with apt-get so we don't have to modify /etc/shells by hand
# note that zplug requires gawk
sudo apt-get zsh gawk
# zsh plugin manager
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# set zsh as default shell: add this to ~/.bash_profile (seems to work better than chsh)
if [ -t 1 ]; then
exec zsh
fi
# fix an annoying problem in which zsh complains about permissions
sudo chmod -R 755 ~/.zplug
```

#### .zshrc

* [zshrc](dotfiles/zshrc)
* [zsh_aliases](dotfiles/zsh_aliases)

I simply clone this repo and make a symlink:

```
# change path to "notes" according to your env
ln -s ~/src/notes/dotfiles/zshrc ~/.zshrc
ln -s ~/src/notes/dotfiles/zsh_aliases ~/.zsh_aliases
```
