## Getting vim dialed in my Windows/WSL Ubuntu environment

It seems like the cool kids are using NeoVim, so I thought I'd give that a try. If you've
followed along to this point, then it's installed in both Windows and Ubuntu.

First, let's install neovim:

* In PowerShell, as admin: `choco install neovim`
* In Ubuntu: `brew install neovim`

Next, in _both_ PowerShell (as a regular user) and in Ubuntu:

```
pip install neovim
pip3 install neovim
```

I decided to have a single init.vim for both environments. So far, it's working OK (though clipboards
are pretty annoying).

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

Right-click -> Open with Neovim: [nvim-context-menu.reg](nvim-context-menu.reg)

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
