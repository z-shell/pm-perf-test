typeset -gA ZI
ZI[HOME_DIR]=$PWD/_zi
ZPFX=${ZI[HOME_DIR]}/polaris

if [[ ! -d ${ZI[HOME_DIR]}/bin ]]; then
    git clone --depth 1 https://github.com/z-shell/zi "${ZI[HOME_DIR]}/bin"
fi

# Start measuring time, in general with microsecond accuracy
typeset -F4 SECONDS=0

source "${ZI[HOME_DIR]}/bin/zi.zsh"

# Ensure that zi is compiled
if [[ ! -f ${ZI[BIN_DIR]}/zi.zsh.zwc ]]; then
    zi self-update
fi

# A.
setopt promptsubst

# B.
zi ice wait lucid
zi snippet OMZ::lib/git.zsh

# C.
zi ice wait atload"unalias grv" lucid
zi snippet OMZ::plugins/git/git.plugin.zsh

# D.
PS1="READY >" # provide a nice prompt till the theme loads
zi ice wait'!' lucid
zi snippet OMZ::themes/dstufft.zsh-theme

# E.
zi ice wait lucid
zi snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# F.
zi ice wait as"completion" lucid
zi snippet OMZ::plugins/docker/_docker

# G.
zi ice wait atinit"zpcompinit" lucid
zi light z-shell/fast-syntax-highlighting

zi ice wait atload"_zsh_autosuggest_start" lucid
zi light zsh-users/zsh-autosuggestions

print "[zshrc] zi block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"
