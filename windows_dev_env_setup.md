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

## Set up and dial in Ubuntu

The actual setup of Ubuntu requires enabling an optional windows feature and then installing Ubuntu
from the app store. There are a million how-tos online, including this one: https://docs.microsoft.com/en-us/windows/wsl/install-win10

The long and short of it is that you run the following in an Administrator PowerShell:

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

then reboot your system and install Ubuntu. 

### Get users squared away

I've done this a few times, and at least once, I did not get a user created in Ubuntu -- I just started as root. To rectify that problem, I did:

##### In Ubuntu

```
useradd cfesler
sudo usermod -a -G sudo cfesler
```
##### In an admin PowerShell

```
ubuntu config --default-user cfesler
sc stop LxssManager
sc start LxssManager
```
https://docs.microsoft.com/en-us/windows/wsl/user-support

### update ubuntu

```
sudo apt-get update
sudo apt-get upgrade
```

### install homebrew in Ubuntu under under wsl

I've not used homebrew under Linux before, but have used it under Mac for many years. Why not
try it, right?

```
sudo apt-get install openssh-client build-essential gcc-5
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
# follow instructions after homebrew install
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.profile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install jdk golang git python 
```

## Get Windows set up nicely with Chocolatey

Chocolatey is a homebrew-like package manager for Windows. I've not used it before, but again
figure why not give it a shot?

* run powershell as admin
* `Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
* exit powershell and start again (as admin), and then install a crud-load of stuff:
    * `choco install -y golang openjdk docker-desktop vscode python git make`

### some dumb little things that are handy for me

#### Make 'which' in PowerShell an alias to `Get-Command`, which I will likely never remember

```
# add an alias from which to Get-Command and grant users the right to run it
New-Alias which get-command | add-content $profile
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Map caps-lock to ctrl

Make [this registry change](caps_lock_to_ctrl.reg).

#### Install a terminal that sucks less

I have tried a handful of terminal programs in Windows and none of them are even close to iTerm.
Bummer news. Right now, I'm using the new "Windows Terminal," which is in early access release
from Microsoft.

* Install Windows Terminal from the windows store. It requires the May 2019 windows update, so
  apply that first if indicated.
* Start the terminal, then go to 'settings' and change the Ubuntu color scheme from 'Campbell'
  to 'Solarized Dark' because that's what I like.

You can easily start an Ubuntu term from here. I moved the Ubuntu profile to be the first in the
settings json so that ctrl-shift-1 would give me that instead of a PowerShell. 

To make Ubuntu the default terminal, copy the `guid` value from that profile to
`globals/defaultProfile`.

