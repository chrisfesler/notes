# Setting up a dev environment on Windows 10

This is an account of how I set up a Go dev environment in Windows 10. Like my environment, this
doc is a WIP. 

This is the first time I've developed on Windows since I was writing C# circa 2006 -- since then,
it's been all Linux and Mac. WSL makes Windows much more Mac-Like, and the upsides of Windows
(for me, _much_ better MS Office) make this all worth trying to get right.

The thing that I'm aimed at is being able to run an IDE in Windows (I currently prefer GoLand to
VS Code, but intend to continue evaluating both), but build and test in Ubuntu. With all the stuff
documented below, this is working well.

This is organized into sections:

* Set up and dial in Ubuntu
* Get Windows to a happy spot
* Set up Vim - obviously not necessary unless you're strung out on vim, like me.

## Set up and dial in Ubuntu

The actual setup of Ubuntu requires enabling an optional windows feature and then installing Ubuntu
from the app store. There are a million how-tos online, including this one: https://docs.microsoft.com/en-us/windows/wsl/install-win10

The long and short of it is that you run the following in an Administrator PowerShell:

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

then reboot your system and install Ubuntu. 

### Get users squared away

* in ubuntu
    * `sudo usermod -a -G sudo cfesler`
    * `useradd cfesler`
* in powershell
    * `ubuntu config --default-user cfesler`
      `sc stop LxssManager`
      `sc start LxssManager`
    * https://docs.microsoft.com/en-us/windows/wsl/user-support

Now I'm me instead of root when I start an ubuntu shell.

### install homebrew in Ubuntu under under wsl

I've not used homebrew under Linux before, but have used it under Mac for many years. Why not
try it, right?

```
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

## Get Windows set up nicely with Chocolatey

Chocolatey is a homebrew-like package manager for Windows. I've not used it before, but again
figure why not give it a shot?

* run powershell as admin
* `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
* exit powershell and start again (as admin), and then install a crud-load of stuff:
    * `choco install -y golang openjdk docker-desktop vscode neovim python git make`

### some dumb little things that are handy for me

#### Make 'which' in PowerShell an alias to `Get-Command`, which I will likely never remember

```
# add an alias from which to Get-Command
"`nNew-Alias which get-command" | add-content $profile
# allow the profile script to run
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Install a terminal that sucks less

I have tried a handful of terminal programs in Windows and none of them are even close to iTerm.
Bummer news. Right now, I'm using the new "Windows Terminal," which is in early access release
from Microsoft.

* Install Windows Terminal from the windows store
* Start the terminal, then go to 'settings' and change the Ubuntu color scheme from 'Campbell'
  to 'Solarized Dark' because that's what I like

You can easily start an Ubuntu term from here. I moved the Ubuntu profile to be the first in the
settings json so that ctrl-shift-1 would give me that instead of a PowerShell. 

*TODO*: set up so that I can start a windows terminal with Ubuntu from a pinned icon on my
task bar.

## Get Vim dialed

It seems like the cool kids are using NeoVim, so I thought I'd give that a try. If you've
followed along to this point, then it's installed in both Windows and Ubuntu.

In _both_ PowerShell and Ubuntu, you'll need to do this:

```
pip install neovim
pip3 install neovim
```

It should just work. 

I decided to have a single init.vim for both environments. So far, so good. 

### Configure nvim under Windows

I used http://vim-bootstrap.com to generate my vimrc (sorry, `init.vim`). It's super easy. At first, 
I selected too many languages -- I can always regenerate if I have to write ruby at some point. So
for now, just go & python.

Generate and save the `generate.vim` file, and then move it to `~/AppData/Local/.config/nvim/init.vim`.

Annoyingly, nvim wants its `init.vim` in one place but, that file loads customizations from another.
Rather than monkey with a generated file, I followed along and created (over time) these two files:

I depended on the web to get much of this stuff set up. This page was particularly 
helpful: https://jdhao.github.io/2018/11/15/neovim_configuration_windows/

####  vim-plug

It turns out nobody uses vim-bundler anymore, they use vim-plug. So far, it's a great change.

In a new powershell, this time as user

```
md ~\AppData\Local\nvim\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\AppData\Local\nvim\autoload\plug.vim"
  )
)

pip install neovim
pip3 install neovim
```

#### local_init.vim

```
" ~/.config/nvim/local_init.vim

" paste from system clipboard with S-Insert
set pastetoggle=<F10>
inoremap <S-Insert> <ESC>"+p

" copy to system clipboard with C-Insert
:set mouse=a
vnoremap <C-Insert> "+y

" alternative: yank and put use system clipboard
" set clipboard=unnamedplus

let g:markdown_fenced_languages = ['go', 'java', 'pyton', 'bash=sh', 'vim']
" this seems to not work, thanks tpope
"let g:markdown_syntax_conceal = 0
set conceallevel=0
" uncomment if need more fenced code block lines; left out for performance
"let g:markdown_minlines=100

colorscheme NeoSolarized
```

#### local_bundles.vim

```
" ~/.config/nvim/local_bundles.vim

Plug 'iCyMind/NeoSolarized'
Plug 'tpope/vim-markdown'
```

#### nvim-qt and PlugInstall

With all that done, time to run neovim in Windows and install plugins:

`nvim-qt` is the windowed-version of neovim. Start it up, and then install plugins by entering

`:PlugInstall` in command mode. Follow that by `:checkhealth`

Plugins can be updated any time with `PlugUpdate`. After deleting plugins from `init.vim` or
`local_bundles.vim`, run `:PlugClean`.

*TODO*: I am getting a weird error from `:checkhealth` that seems to be inconsequential, but 
I'd like to figure it out at some point (because it itches):

```
health#provider#check
========================================================================
  - ERROR: Failed to run healthcheck for "provider" plugin. Exception:
    function health#check[21]..health#provider#check[4]..<SNR>164_check_ruby[15]..<SNR>164_system, line 11
    Vim(let):E903: Process failed to start: no such file or directory: "/bin/sh"
```

#### clipboard

OMG, the clipboard in neovim + Windows + Ubuntu. What a pain. The `local_init.vim` makes stuff better, but still
moving stuff through the system clipboard to vim in windows and Ubuntu is annoying. Here's one necessary step:

>To use the Windows clipboard from within WSL, Neovim has to be installed on both Windows and WSL. The win32yank.exe provided by the Neovim Windows installation has to be symlinked to a directory included in your $PATH so it can be found by Neovim on WSL. Replace $NEOVIM_WIN_DIR with the path to your Neovim Windows installation, e.g. /mnt/c/Program Files/Neovim. The command can then be symlinked using:

```
sudo ln -s "$NEOVIM_WIN_DIR/bin/win32yank.exe" /mnt/c/tools/neovim/Neovim/bin/win32yank.exe`
```
https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl

#### explorer context menu registry edit

Right-click -> Open with Neovim:

```
HKEY_CURRENT_USER\Software\Classes\*\shell\Open with Neovim\command -> cmd /c start nvim-qt.exe -- -- %1
```

### Symlink Ubuntu nvim config to Windows nvim config

Note that you should have access from Ubuntu to your Windows file system at `/mnt/c`, but that
your Linux filesystem is not available in Windows. So I set up some symlinks:

```
ln -s /mnt/c/Windows/cfesl ~/cfwin
# in case it doesn't exist already, create the nvim config dir in 
mkdir -p ~/.config/nvim
# set up symlinks
ln -s cfwin/AppData/Local/nvim/init.vim ~/.config/nvim/
ln -s cfwin/.config/nvim/local_init.vim ~/.config/nvim/
ln -s cfwin/.config/nvim/local_bundles.vim ~/.config/nvim/
```

Now run nvim, and then `:PlugInstall` and `:checkhealth` and all should be good to go.
