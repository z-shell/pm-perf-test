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

# A.
setopt promptsubst

# B.
zinit ice wait lucid
zinit snippet OMZ::lib/git.zsh

# C.
zinit ice wait atload"unalias grv" lucid
zinit snippet OMZ::plugins/git/git.plugin.zsh

# D.
PS1="READY >" # provide a nice prompt till the theme loads
zinit ice wait'!' lucid
zinit snippet OMZ::themes/dstufft.zsh-theme

# E.
zinit ice wait lucid
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# F.
zinit ice wait as"completion" lucid
zinit snippet OMZ::plugins/docker/_docker

# G.
zinit ice wait atinit"zpcompinit" lucid
zinit light z-shell/fast-syntax-highlighting

zinit ice wait atload"_zsh_autosuggest_start" lucid
zinit light zsh-users/zsh-autosuggestions

print "[zshrc] Zinit block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"
