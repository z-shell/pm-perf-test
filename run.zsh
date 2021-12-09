#!/usr/bin/env zsh

builtin emulate -L zsh -o extendedglob -o typesetsilent -o rcquotes -o noautopushd

if [[ ${ZSH_VERSION-} != (5.<8->*|<6->.*) ]]; then
  print "Zsh >= 5.8 is required to execute this script"
  return 1
fi

if [[ $PWD != */pm-perf-test ]]; then
  print "The script has to be ran from the \`pm-perf-test' directory"
  return 1
fi

integer verbose="${${(M)1:#(-v|--verbose)}:+1}"
typeset -g __thepwd="$PWD"
trap "cd $__thepwd; unset __thepwd" EXIT
trap "cd $__thepwd; unset __thepwd; return 1" INT


[[ ! -d results ]] && mkdir -p results

  print -P "%F{46}--- %F{33} Cleaning up %F{46} ---%f"
  print rm -rf **/(_zplug|_zgen|_zi)(DN) results/*.txt(DN)
  sleep 1

  rm -rf **/(_zplug|_zgen|_zi)(DN) results/*.txt(DN)
  print -P "%F{46}--- %F{33} Done %F{46}---%f"


bench_installation() {
  print -P "%F{46}--- %F{33} Benchmarking installation time %F{46} ---%f"

for i in zplug zgen zi*~*omz; do
  print -P "\n%F{46}--- %F{33}3 results for %F{93}[$i]%F{46} ---%f"
  cd -q "$i"

  if [[ "$i" = *turbo ]]; then
    local cmd='@zi-scheduler burst; print \[zshrc\] Install time: ${(M)$(( SECONDS * 1000 ))#*.?} ms; exit'
  else
    local cmd="exit"
  fi

  (( verbose )) && {
    ZDOTDIR=$PWD zsh -i -c -- $cmd 2>&1 > >(grep '\[zshrc\]' >> ../results/$i-inst.txt) > >(cat)
    rm -rf _(zplug|zgen|zi)
    ZDOTDIR=$PWD zsh -i -c -- $cmd 2>&1 > >(grep '\[zshrc\]' >> ../results/$i-inst.txt) > >(cat)
    rm -rf _(zplug|zgen|zi)
    ZDOTDIR=$PWD zsh -i -c -- $cmd 2>&1 > >(grep '\[zshrc\]' >> ../results/$i-inst.txt) > >(cat)
    ((1))
  } || {
    ZDOTDIR=$PWD zsh -i -c -- $cmd |& grep '\[zshrc\]' | tee -a ../results/$i-inst.txt
    rm -rf _(zplug|zgen|zi)
    ZDOTDIR=$PWD zsh -i -c -- $cmd |& grep '\[zshrc\]' | tee -a ../results/$i-inst.txt
    rm -rf _(zplug|zgen|zi)
    ZDOTDIR=$PWD zsh -i -c -- $cmd |& grep '\[zshrc\]' | tee -a ../results/$i-inst.txt
  }

  cd -q "$__thepwd"
done
}

bench_startup() {
  print -P "%F{46}--- %F{33} Benchmarking startup time %F{46} ---%f"

  for i in zplug zgen zi*~(*omz|*txt); do
    print -P "\n%F{46}--- %F{33}10 results for %F{93}[$i]%F{46} ---%f"
    cd -q "$i"

    # Warmup
    print -P "\n%F{46}--- %F{10} Running warmup %F{33}(repeat: 20) %F{46} ---%f"
    repeat 20 {
      ZDOTDIR=$PWD zsh -i -c exit &>/dev/null
    }

# The proper test
    (( verbose )) && {
      repeat 10 {
        ZDOTDIR="$PWD" zsh -i -c exit 2>&1 > >(grep '\[zshrc\]' >> ../results/$i.txt) > >(cat)
      }
      ((1))
    } || {
      repeat 10 {
        ZDOTDIR="$PWD" zsh -i -c exit |& grep '\[zshrc\]' | tee -a ../results/$i.txt
      }
    }

    cd -q "$__thepwd"
  done
}

while true; do
  bench_installation
  bench_startup
  exit 0
done
