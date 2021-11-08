typeset -gA ZPLGM
ZPLGM[HOME_DIR]=$PWD/_zplugin
ZPFX=${ZPLGM[HOME_DIR]}/polaris

if [[ ! -d ${ZPLGM[HOME_DIR]}/bin ]]; then
    git clone --depth 1 https://github.com/z-shell/zinit "${ZPLGM[HOME_DIR]}/bin"
fi

# Start measuring time, in general with microsecond accuracy
typeset -F4 SECONDS=0

source "${ZPLGM[HOME_DIR]}/bin/zinit.zsh"

# Ensure that zinit is compiled
if [[ ! -f ${ZPLGM[BIN_DIR]}/zinit.zsh.zwc ]]; then
    zinit self-update
fi

# Assign each zsh session an unique ID, available in
# ZUID_ID and also a codename (ZUID_CODENAME)
zinit load z-shell/zsh-unique-id

# Loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zinit snippet OMZ::lib/git.zsh

# Loaded mostly to stay in touch with the plugin (for the users)
zinit ice atload$'unalias grv g 2>/dev/null'
zinit snippet OMZ::plugins/git/git.plugin.zsh

# On OSX, you might need to install coreutils from homebrew and use the
# g-prefix – gsed, gdircolors
zinit ice \
    atclone"local PFX=${${(M)OSTYPE:#*darwin*}:+g}
            git reset --hard; \${PFX}sed -i \
            '/DIR/c\DIR                   38;5;63;1' LS_COLORS; \
            \${PFX}dircolors -b LS_COLORS > c.zsh" \
            atpull'%atclone' pick"c.zsh" nocompile'!' \
            atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit load trapd00r/LS_COLORS

# Another load of the same plugin, to add zc-bg-notify to PATH
zinit ice silent as"program" id-as"zconvey-cmd" pick"cmds/zc-bg-notify"
zinit load z-shell/zconvey

# fzy
zinit ice as"program" make"!PREFIX=$ZPFX install" \
    atclone"cp contrib/fzy-* $ZPFX/bin/" \
    pick"$ZPFX/bin/fzy*"
zinit load jhawthorn/fzy

# fzf, for fzf-marks
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

# fzf-marks, at slot 0, for quick Ctrl-G accessibility
zinit load urbainvaes/fzf-marks

# zsh-autopair
zinit load hlissner/zsh-autopair

# zredis together with some binding/tying
#zinit ice atload'ztie -d db/redis -a 127.0.0.1:4815/5 -P $HOME/.zredisconf -zSL main rdhash'
#zinit load z-shell/zredis

# zsh-editing-workbench & zsh-navigation-tools
zinit load z-shell/zsh-editing-workbench
zinit load z-shell/zsh-navigation-tools   # for n-history

# z-shell/history-search-multi-word
zinit load z-shell/history-search-multi-word

# Theme no. 4 – pure
zinit load geometry-zsh/geometry

# ZUI and Crasis
zinit load z-shell/zui

# Gitignore plugin – commands gii and gi
zinit load voronkovich/gitignore.plugin.zsh

# Autosuggestions
zinit load zsh-users/zsh-autosuggestions

# ogham/exa, replacement for ls
zinit ice from"gh-r" as"program" mv"exa* -> exa"
zinit load ogham/exa

# vramsteg
#zinit ice as"program" pick"src/vramsteg" \
#            atclone'cmake .' atpull'%atclone' make
#zinit load z-shell/vramsteg-zsh

# revolver
#zinit ice as"program" pick"revolver"
#zinit load z-shell/revolver

# zunit
#zinit ice as"program" pick"zunit" \
#            atclone"./build.zsh" atpull"%atclone"
#zinit load z-shell/zunit

# declare-zshrc
zinit load z-shell/declare-zsh

# zsh-diff-so-fancy
zinit ice as"program" pick"bin/git-dsf"
zinit load z-shell/zsh-diff-so-fancy

# git-now
zinit ice as"program" pick"$ZPFX/bin/git-now" make"PREFIX=$ZPFX install"
zinit load iwata/git-now

# git-extras
zinit ice as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX"
zinit load tj/git-extras

# git-cal
zinit ice as"program" atclone"perl Makefile.PL PREFIX=$ZPFX" \
    atpull'%atclone' make'install' pick"$ZPFX/bin/git-cal"
zinit load k4rthik/git-cal

# git-url
zinit ice as"program" pick"$ZPFX/bin/git-url" make"install PREFIX=$ZPFX GITURL_NO_CGITURL=1"
zinit load z-shell/git-url

# git-recall
zinit ice as"program" pick"git-recall"
zinit load Fakerr/git-recall

# git-quick-stats
zinit ice as"program" make"PREFIX=$ZPFX install" \
    pick"$ZPFX/bin/git-quick-stats" \
    atload"export _MENU_THEME=legacy"
zinit load arzzen/git-quick-stats.git

autoload compinit
compinit

print "[zshrc] Zinit block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"
