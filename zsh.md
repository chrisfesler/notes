# setting up zsh on windows ubuntu

After a little research, I decided to try [zplug](https://github.com/zplug/zplug). I've used oh-my-zsh
previously, but it always felt bloated and hard to manage. Perhaps this will be better.

```
# manage zsh with apt-get so we don't have to modify /etc/shells by hand
sudo apt-get zsh
# zsh plugin manager
brew install zplug
# set zsh as default shell
chsh -s $(which zsh)
# fix an annoying problem in which zsh complains about permissions
sudo chmod 755 /home/linuxbrew/.linuxbrew/Cellar
```

#### .zshrc

* [zshrc](dotfiles/zshrc)
* [zsh_aliases](dotfiles/zsh_aliases)
