typeset -gA ZI
ZI[HOME_DIR]=$PWD/_zi
ZPFX=${ZI[HOME_DIR]}/polaris

if [[ ! -d ${ZI[HOME_DIR]}/bin ]]; then
  git clone --depth=1 https://github.com/z-shell/zi "${ZI[HOME_DIR]}/bin"
fi

# Start measuring time, in general with microsecond accuracy
typeset -F4 SECONDS=0

source "${ZI[HOME_DIR]}/bin/zi.zsh"

# Ensure that zi is compiled
if [[ ! -f ${ZI[BIN_DIR]}/zi.zsh.zwc ]]; then
  zi self-update
fi

# Assign each zsh session an unique ID, available in
# ZUID_ID and also a codename (ZUID_CODENAME)
zi load z-shell/zsh-unique-id

# zsh-editing-workbench & zsh-navigation-tools
zi load z-shell/zsh-editing-workbench
zi load z-shell/zsh-navigation-tools   # for n-history

# declare-zshrc
zi load z-shell/declare-zsh

# zsh-diff-so-fancy
zi ice as"program" pick"bin/git-dsf"
zi load z-shell/zsh-diff-so-fancy

# Another load of the same plugin, to add zc-bg-notify to PATH
zi ice silent as"program" id-as"zconvey-cmd" pick"cmds/zc-bg-notify"
zi load z-shell/zconvey

# z-shell/H-S-MW
zi load z-shell/H-S-MW

# git-url
zi ice as"program" pick"$ZPFX/bin/git-url" make"install PREFIX=$ZPFX GITURL_NO_CGITURL=1"
zi load z-shell/git-url

# ZUI and Crasis
zi load z-shell/zui

# Loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zi snippet OMZ::lib/git.zsh

# Loaded mostly to stay in touch with the plugin (for the users)
zi ice atload$'unalias grv g 2>/dev/null'
zi snippet OMZ::plugins/git/git.plugin.zsh

# On OSX, you might need to install coreutils from homebrew and use the
# g-prefix – gsed, gdircolors
zi ice atclone"local PFX=${${(M)OSTYPE:#*darwin*}:+g}
git reset --hard; \${PFX}sed -i '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
\${PFX}dircolors -b LS_COLORS > c.zsh" \
atpull'%atclone' pick"c.zsh" nocompile'!' \
atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zi load trapd00r/LS_COLORS

# fzy
zi ice as"program" make"!PREFIX=$ZPFX install" atclone"cp contrib/fzy-* $ZPFX/bin/" pick"$ZPFX/bin/fzy*"
zi load jhawthorn/fzy

# fzf, for fzf-marks
zi ice from"gh-r" as"program"
zi load junegunn/fzf-bin

# fzf-marks, at slot 0, for quick Ctrl-G accessibility
zi load urbainvaes/fzf-marks

# zsh-autopair
zi load hlissner/zsh-autopair

# zredis together with some binding/tying
#zi ice atload'ztie -d db/redis -a 127.0.0.1:4815/5 -P $HOME/.zredisconf -zSL main rdhash'
#zi load z-shell/zredis

# Theme no. 4 – pure
zi load geometry-zsh/geometry

# Gitignore plugin – commands gii and gi
zi load voronkovich/gitignore.plugin.zsh

# Autosuggestions
zi load zsh-users/zsh-autosuggestions

# ogham/exa, replacement for ls
zi ice from"gh-r" as"program" mv"exa* -> exa"
zi load ogham/exa

# vramsteg
#zi ice as"program" pick"src/vramsteg" \
#            atclone'cmake .' atpull'%atclone' make
#zi load z-shell/vramsteg-zsh

# revolver
#zi ice as"program" pick"revolver"
#zi load z-shell/revolver

# zunit
#zi ice as"program" pick"zunit" atclone"./build.zsh" atpull"%atclone"
#zi load z-shell/zunit

# git-now
zi ice as"program" pick"$ZPFX/bin/git-now" make"PREFIX=$ZPFX install"
zi load iwata/git-now

# git-extras
zi ice as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX"
zi load tj/git-extras

# git-cal
zi ice as"program" atclone"perl Makefile.PL PREFIX=$ZPFX" \
atpull'%atclone' make'install' pick"$ZPFX/bin/git-cal"
zi load k4rthik/git-cal

# git-recall
zi ice as"program" pick"git-recall"
zi load Fakerr/git-recall

# git-quick-stats
zi ice as"program" make"PREFIX=$ZPFX install" pick"$ZPFX/bin/git-quick-stats" \
atload"export _MENU_THEME=legacy"
zi load arzzen/git-quick-stats.git

autoload compinit
compinit

print "[zshrc] zi block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"
