ZPLUG_HOME="$PWD/_zplug"
ZPFX="$ZPLUG_HOME/polaris"

if [[ ! -d "$ZPLUG_HOME/bin" ]]; then
  git clone --depth 1 https://github.com/zplug/zplug.git "$ZPLUG_HOME/bin"
fi

# Start measuring time, in general with microsecond accuracy
typeset -F4 SECONDS=0

source "$ZPLUG_HOME/bin/init.zsh"

# Assign each zsh session an unique ID, available in
# ZUID_ID and also a codename (ZUID_CODENAME)
zplug z-shell/zsh-unique-id

# zsh-editing-workbench & zsh-navigation-tools
zplug z-shell/zsh-editing-workbench
zplug z-shell/zsh-navigation-tools   # for n-history

# declare-zsh
zplug z-shell/declare-zsh

# zsh-diff-so-fancy
zplug z-shell/zsh-diff-so-fancy, as:command, use:"bin/git-dsf"

# Another load of the same plugin, to add zc-bg-notify to PATH
zplug z-shell/zconvey, as:command, use:cmds/zc-bg-notify

# z-shell/H-S-MW
zplug z-shell/H-S-MW

# git-url
zplug z-shell/git-url, as:command,\
use:"$ZPFX/bin/git-url",\
hook-build:"make install PREFIX=$ZPFX GITURL_NO_CGITURL=1"

# ZUI and Crasis
zplug z-shell/zui

# Loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zplug "lib/git.zsh", from:oh-my-zsh

# Loaded mostly to stay in touch with the plugin (for the users)
zplug plugins/git, from:oh-my-zsh, hook-load:"unalias grv g 2>/dev/null"

# On OSX, you might need to install coreutils from homebrew and use the
# g-prefix – gsed, gdircolors
zplug trapd00r/LS_COLORS, hook-build:"local PFX=${${(M)OSTYPE:#*darwin*}:+g}
git reset --hard; \${PFX}sed -i '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
\${PFX}dircolors -b LS_COLORS > c.zsh", \
use:c.zsh, \
hook-load:'zstyle a b c'

# fzy
zplug jhawthorn/fzy, as:command, hook-build:"make PREFIX=$ZPFX install;
cp contrib/fzy-* $ZPFX/bin/", use:"$ZPFX/bin/fzy*"

# fzf, for fzf-marks
zplug junegunn/fzf-bin, from:gh-r, as:command

# fzf-marks, at slot 0, for quick Ctrl-G accessibility

zplug urbainvaes/fzf-marks
# zsh-autopair
zplug hlissner/zsh-autopair

# zredis together with some binding/tying
#zplug z-shell/zredis, hook-load:'ztie -d db/redis -a 127.0.0.1:4815/5 -P $HOME/.zredisconf -zSL main rdhash'

# Theme no. 4 – pure
zplug geometry-zsh/geometry

# Gitignore plugin – commands gii and gi
zplug voronkovich/gitignore.plugin.zsh

# Autosuggestions & F-Sy-H
zplug zsh-users/zsh-autosuggestions
#zplug z-shell/F-Sy-H

# ogham/exa, replacement for ls
zplug ogham/exa, from:gh-r, as:command, rename-to:exa, use:"*mac*"

# vramsteg
#zplug z-shell/vramsteg-zsh, as:command, \
#use:src/vramsteg, \
#hook-build:"cmake .; make"

# revolver
#zplug z-shell/revolver, as:command, use:revolver

# zunit
#zplug z-shell/zunit, as:command, use:zunit, hook-build:"./build.zsh"

# git-now
zplug iwata/git-now, as:command,\
use:"$ZPFX/bin/git-now",\
hook-build:"make PREFIX=$ZPFX install"

# git-extras
zplug tj/git-extras, as:command,\
use:"$ZPFX/bin/git-alias",\
hook-build:"make PREFIX=$ZPFX"

# git-cal
zplug k4rthik/git-cal, as:command,\
use:"$ZPFX/bin/git-cal",\
hook-build:"perl Makefile.PL PREFIX=$ZPFX; make install"

# git-recall
zplug Fakerr/git-recall, as:command, use:git-recall

# git-quick-stats
zplug arzzen/git-quick-stats, as:command, \
use:"$ZPFX/bin/git-quick-stats", \
hook-build:"make PREFIX=$ZPFX install", \
hook-load:"export _MENU_THEME=legacy"

print "[zshrc] Zplug block A took ${(M)$(( SECONDS * 1000 ))#*.?} ms"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  echo; zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

print "[zshrc] Zplug block A+B took ${(M)$(( SECONDS * 1000 ))#*.?} ms"
