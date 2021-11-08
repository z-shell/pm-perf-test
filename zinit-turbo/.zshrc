typeset -gA ZPLGM
ZPLGM[HOME_DIR]=$PWD/_zplugin
ZPFX=${ZPLGM[HOME_DIR]}/polaris

if [[ ! -d ${ZPLGM[HOME_DIR]}/bin ]]; then
    git clone --depth 1 https://github.com/z-shell/zplugin "${ZPLGM[HOME_DIR]}/bin"
fi

# Start measuring time, in general with microsecond accuracy
typeset -F4 SECONDS=0

source "${ZPLGM[HOME_DIR]}/bin/zplugin.zsh"

# Ensure that zplugin is compiled
if [[ ! -f ${ZPLGM[BIN_DIR]}/zplugin.zsh.zwc ]]; then
    zplugin self-update
fi

# Assign each zsh session an unique ID, available in
# ZUID_ID and also a codename (ZUID_CODENAME)
zplugin ice wait lucid
zplugin load z-shell/zsh-unique-id

# Loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zplugin ice wait lucid
zplugin snippet OMZ::lib/git.zsh

# Loaded mostly to stay in touch with the plugin (for the users)
zplugin ice wait lucid atload$'unalias grv g 2>/dev/null'
zplugin snippet OMZ::plugins/git/git.plugin.zsh

# On OSX, you might need to install coreutils from homebrew and use the
# g-prefix – gsed, gdircolors
zplugin ice wait"0c" lucid \
    atclone"local PFX=${${(M)OSTYPE:#*darwin*}:+g}
            git reset --hard; \${PFX}sed -i \
            '/DIR/c\DIR                   38;5;63;1' LS_COLORS; \
            \${PFX}dircolors -b LS_COLORS > c.zsh" \
            atpull'%atclone' pick"c.zsh" nocompile'!' \
            atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zplugin light trapd00r/LS_COLORS

# Another load of the same plugin, to add zc-bg-notify to PATH
zplugin ice wait silent as"program" id-as"zconvey-cmd" pick"cmds/zc-bg-notify"
zplugin load z-shell/zconvey

# fzy
zplugin ice wait"1" lucid as"program" make"!PREFIX=$ZPFX install" \
    atclone"cp contrib/fzy-* $ZPFX/bin/" \
    pick"$ZPFX/bin/fzy*"
zplugin light jhawthorn/fzy

# fzf, for fzf-marks
zplugin ice wait lucid from"gh-r" as"program"
zplugin light junegunn/fzf-bin

# fzf-marks, at slot 0, for quick Ctrl-G accessibility
zplugin ice wait lucid
zplugin load urbainvaes/fzf-marks

# zsh-autopair
zplugin ice wait lucid
zplugin load hlissner/zsh-autopair

# zredis together with some binding/tying
#zplugin ice wait"1" lucid atload'ztie -d db/redis -a 127.0.0.1:4815/5 -P $HOME/.zredisconf -zSL main rdhash'
#zplugin load z-shell/zredis

# zsh-editing-workbench & zsh-navigation-tools
zplugin ice wait"1" lucid
zplugin load z-shell/zsh-editing-workbench
zplugin ice wait"1" lucid
zplugin load z-shell/zsh-navigation-tools   # for n-history

# z-shell/history-search-multi-word
zplugin ice wait"1" lucid
zplugin load z-shell/history-search-multi-word

# Theme no. 4 – pure
zplugin ice wait'!' lucid atload"geometry::prompt"
zplugin load geometry-zsh/geometry

# ZUI and Crasis
zplugin ice wait"1" lucid
zplugin load z-shell/zui

# Gitignore plugin – commands gii and gi
zplugin ice wait"2" lucid
zplugin load voronkovich/gitignore.plugin.zsh

# Autosuggestions & fast-syntax-highlighting
zplugin ice wait"0c" lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions
zplugin ice wait"1" lucid atinit"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zplugin light z-shell/fast-syntax-highlighting

# ogham/exa, replacement for ls
zplugin ice wait"2" lucid from"gh-r" as"program" mv"exa* -> exa"
zplugin light ogham/exa

# vramsteg
#zplugin ice wait"2" lucid as"program" pick"src/vramsteg" \
#            atclone'cmake .' atpull'%atclone' make
#zplugin load z-shell/vramsteg-zsh

# revolver
#zplugin ice wait"2" lucid as"program" pick"revolver"
#zplugin load z-shell/revolver

# zunit
#zplugin ice wait"2" lucid as"program" pick"zunit" \
#            atclone"./build.zsh" atpull"%atclone"
#zplugin load z-shell/zunit

# declare-zshrc
zplugin ice wait"2" lucid
zplugin load z-shell/declare-zsh

# zsh-diff-so-fancy
zplugin ice wait"2" lucid as"program" pick"bin/git-dsf"
zplugin load z-shell/zsh-diff-so-fancy

# git-now
zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-now" make"PREFIX=$ZPFX install"
zplugin load iwata/git-now

# git-extras
zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX"
zplugin load tj/git-extras

# git-cal
zplugin ice wait"2" lucid as"program" atclone"perl Makefile.PL PREFIX=$ZPFX" \
    atpull'%atclone' make'install' pick"$ZPFX/bin/git-cal"
zplugin load k4rthik/git-cal

# git-url
zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-url" make"install PREFIX=$ZPFX GITURL_NO_CGITURL=1"
zplugin load z-shell/git-url

# git-recall
zplugin ice wait"3" lucid as"program" pick"git-recall"
zplugin load Fakerr/git-recall

# git-quick-stats
zplugin ice wait"3" lucid as"program" make"PREFIX=$ZPFX install" \
    pick"$ZPFX/bin/git-quick-stats" \
    atload"export _MENU_THEME=legacy"
zplugin load arzzen/git-quick-stats.git

print "[zshrc] Zinit block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"
