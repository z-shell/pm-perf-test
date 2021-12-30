ZGEN_DIR="$PWD/_zgen"

compdef() { :; }

if [[ ! -d "$ZGEN_DIR" ]]; then
    git clone --depth 1 https://github.com/tarjoilija/zgen.git "$ZGEN_DIR"
fi

# Start measuring time, in general with microsecond accuracy
typeset -F4 SECONDS=0

source "$ZGEN_DIR/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

# specify plugins here
# zgen oh-my-zsh

# Assign each zsh session an unique ID, available in
# ZUID_ID and also a codename (ZUID_CODENAME)
zgen load z-shell/zsh-unique-id

# zsh-editing-workbench & zsh-navigation-tools
zgen load z-shell/zsh-editing-workbench
zgen load z-shell/zsh-navigation-tools   # for n-history

# declare-zsh
zgen load z-shell/declare-zsh

# zsh-diff-so-fancy
zgen load z-shell/zsh-diff-so-fancy

# Another light of the same plugin, to add zc-bg-notify to PATH
#zgen load z-shell/zconvey
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-1

# z-shell/H-S-MW
zgen load z-shell/H-S-MW

# git-url
zgen load z-shell/git-url
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-2

# ZUI
zgen load z-shell/zui

# Loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zgen oh-my-zsh lib/git.zsh

# Loaded mostly to stay in touch with the plugin (for the users)
zgen oh-my-zsh plugins/git

# On OSX, you might need to install coreutils from homebrew and use the
# g-prefix – gsed, gdircolors
#zgen load trapd00r/LS_COLORS
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-3

# fzy
#zgen load jhawthorn/fzy
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-4

# fzf, for fzf-marks
#zgen load junegunn/fzf
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-5

# fzf-marks, at slot 0, for quick Ctrl-G accessibility
zgen load urbainvaes/fzf-marks

# zsh-autopair
zgen load hlissner/zsh-autopair zsh-autopair.plugin.zsh

# Theme no. 4 – pure
zgen load geometry-zsh/geometry

# Gitignore plugin – commands gii and gi
zgen load voronkovich/gitignore.plugin.zsh

# Autosuggestions & F-Sy-H
zgen load zsh-users/zsh-autosuggestions
zgen load zsh-users/zsh-syntax-highlighting

# ogham/exa, replacement for ls
#zgen load ogham/exa
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-6

# vramsteg
#zgen load z-shell/vramsteg-zsh
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-7

# revolver
#zgen load molovo/revolver
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-8

# zunit
#zgen load molovo/zunit
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-9

# git-now
#zgen load iwata/git-now
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-10

# git-extras
# zgen load tj/git-extras
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-11

# git-cal
#zgen load k4rthik/git-cal
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-12

# git-recall
#zgen load Fakerr/git-recall
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-13

# git-quick-stats
#zgen load arzzen/git-quick-stats.git
zgen load z-shell/null null.plugin.zsh empty-plugin.zsh-14

# generate the init script from plugins above
zgen save
fi

print "[zshrc] Zgen block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"
