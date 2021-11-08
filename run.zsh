#!/usr/bin/env zsh

emulate -L zsh -o extendedglob -o typesetsilent -o rcquotes -o noautopushd

[[ $PWD != */pm-perf-test ]] && {
    print "The script has to be ran from the \`pm-perf-test' directory"
    return 1
}

integer verbose=${${(M)1:#(-v|--verbose)}:+1}
typeset -g __thepwd=$PWD
trap "cd $__thepwd; unset __thepwd" EXIT
trap "cd $__thepwd; unset __thepwd; return 1" INT

mkdir -p results

print -P "%F{160}Removing plugins and results from previous test run…%f"

print rm -rf **/(_zplug|_zgen|_zinit)(DN) results/*.txt(DN)
sleep 2
rm -rf **/(_zplug|_zgen|_zinit)(DN) results/*.txt(DN)

print -P "%F{160}done%f"

print -P "\n%F{160}============================%f"
print -P "%F{160}Measuring installation time…%f"
print -P "%F{160}============================%f"

for i in zplug zgen zinit*~*omz; do
    print -P "\n%F{154}=== 3 results for %F{140}$i%F{154}: ===%f"

    cd -q $i

    [[ $i = *turbo ]] && \
        local cmd='-zplg-scheduler burst; print \[zshrc\] Install time: ${(M)$(( SECONDS * 1000 ))#*.?} ms; exit' || \
        local cmd="exit"

    (( verbose )) && {
        ZDOTDIR=$PWD zsh -i -c -- $cmd 2>&1 > >(grep '\[zshrc\]' >> ../results/$i-inst.txt) > >(cat)
        rm -rf _(zplug|zgen|zinit)
        ZDOTDIR=$PWD zsh -i -c -- $cmd 2>&1 > >(grep '\[zshrc\]' >> ../results/$i-inst.txt) > >(cat)
        rm -rf _(zplug|zgen|zinit)
        ZDOTDIR=$PWD zsh -i -c -- $cmd 2>&1 > >(grep '\[zshrc\]' >> ../results/$i-inst.txt) > >(cat)
        ((1))
    } || {
        ZDOTDIR=$PWD zsh -i -c -- $cmd |& grep '\[zshrc\]' | tee -a ../results/$i-inst.txt
        rm -rf _(zplug|zgen|zinit)
        ZDOTDIR=$PWD zsh -i -c -- $cmd |& grep '\[zshrc\]' | tee -a ../results/$i-inst.txt
        rm -rf _(zplug|zgen|zinit)
        ZDOTDIR=$PWD zsh -i -c -- $cmd |& grep '\[zshrc\]' | tee -a ../results/$i-inst.txt
    }

    cd -q $__thepwd
done

print -P "\n%F{160}============================%f"
print -P "%F{160}Measuring startup-time time…%f"
print -P "%F{160}============================%f"

for i in zplug zgen zinit*~(*omz|*txt); do
    print -P "\n%F{154}=== 10 results for %F{140}$i%F{154}: ===%f"

    cd -q $i

    # Warmup
    print -P "\n%F{10}(WARMUP…)%f"
    repeat 20 {
        ZDOTDIR=$PWD zsh -i -c exit &>/dev/null
    }

    # The proper test
    (( verbose )) && {
        repeat 10 {
            ZDOTDIR=$PWD zsh -i -c exit 2>&1 > >(grep '\[zshrc\]' >> ../results/$i.txt) > >(cat)
        }
        ((1))
    } || {
        repeat 10 {
            ZDOTDIR=$PWD zsh -i -c exit |& grep '\[zshrc\]' | tee -a ../results/$i.txt
        }
    }

    cd -q $__thepwd
done
