## stuff I did to get golang dev working on my Win 10 box

* Install wsl & ubuntu
    * in ubuntu
        * `sudo usermod -a -G sudo cfesler`
        * `useradd cfesler`
    * in powershell
        * `ubuntu config --default-user cfesler`
          `sc stop LxssManager`
          `sc start LxssManager`
        * https://docs.microsoft.com/en-us/windows/wsl/user-support
* Install chocolatey and neovim windows
    * run powershell as admin
    * `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
    * exit powershell and start again (as admin)
        * `choco install -y neovim python git make`
    * Generate `init.vim` at http://vim-boostrap.com and copy to `~/AppData/nvim/init.vim`
    * see https://jdhao.github.io/2018/11/15/neovim_configuration_windows/
    * new powershell, this time as user
```
md ~\AppData\Local\nvim\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\AppData\Local\nvim\autoload\plug.vim"
  )
)
```
        * `pip install neovim`
        * `nvim`
        * `:PlugInstall`
        * `:checkhealth`
* symlink win32yank into linux so nvim clipboard works 
    * https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
* add explorer context menu item to registry w/ regedit
```
HKEY_CURRENT_USER\Software\Classes\*\shell\Open with Neovim\command -> cmd /c start nvim-qt.exe -- -- %1
```
* install homebrew in ubuintu under under wsl
```
# install homebrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
# follow instructions after homebrew install
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.profile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
sudo apt-get update
sudo apt-get install build-essential gcc-5
brew install golang neovim git python 
pip install neovim
pip3 install neovim
```
* add aliases for vi and vim to nvim in `.bash_aliases`
* generate ~/.config/neovim/init.vim file
    * http://vim-bootstrap.com/
    * `:checkhealth`

# solarized & markdown in neovim
Create `~\.config\nvim\local_bundles.vim`:
```
Plug 'iCyMind/NeoSolarized'
Plug 'gabrielelana/vim-markdown'
```
# local customizations to `init.vim`

file: `~/.config/nvim/local_init.vim`
contents:
```vim
" paste with Shift-Insert
set pastetoggle=<F10>
inoremap <S-Insert> <ESC>"+p

" copy with Ctrl-Insert

:set mouse=a
vnoremap <C-Insert> <ESC>"+y

" markdown by default hides stuff which is super annoying -- make it stop
:set conceallevel=0

colorscheme NeoSolarized
```

# more notes

More choco install

```
# in admin PS
choco install -y golang openjdk docker-desktop vscode

# everything all at once
choco install -y golang openjdk docker-desktop vscode neovim python git make
```

Make 'which' work in PowerShell
```
# add an alias from which to Get-Command
"`nNew-Alias which get-command" | add-content $profile
# allow the profile script to run
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

