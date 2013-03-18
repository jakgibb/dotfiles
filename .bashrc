# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\e[0;33m\]\A \[\e[0;33m\]\u@lenny\n[ \w ]\[\e[0;37m\]: \[\e[0m\]'

complete -cf sudo

PATH=$PATH:~/.bin:/data/devel/android/adt-bundle-linux-x86_64-20130219/sdk/platform-tools
export PATH

if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export HISTCONTROL=ignoreboth

# Use up and down arrow to search the history
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

alias pacup="sudo pacman -Syu"
alias pacg="sudo pacman -S"
alias pacs="pacman -Ss"

alias kim-mount="echo 'Mounting kim (France) to /mnt/server' ; sshfs kim: /mnt/server/ -o idmap=user"
alias kim-mountweb="echo 'Mounting kim:web (France) to /mnt/server' ; sshfs kim:/var/www/ /mnt/server/ -o idmap=user"
alias kim-tunnel="echo 'Opening encrypted tunnel. SSH -ND 22222 kim' ; ssh -ND 22222 kim"
alias kim-tor="echo 'ssh kim -NL 20050:localhost:20050' ; ssh kim -NL 20050:localhost:20050"

alias mplayer="mplayer -quiet"
alias cc="clear"
alias xx="kill -9 $$"
alias rr="reset"
alias lsl="ls -l"
alias lsa="ls -la"
alias nano="nano -wxz"
alias qr="ttyqr -b"

function sslcrypt {
  item=$(echo $1 | sed -e 's/\/$//') # get rid of trailing / on directories

  if [ ! -r $item ]; then
    exit 1;
  fi

  if [ -d $item ]; then
    tar zcf "${item}.tar.gz" "${item}"
    openssl enc -aes-256-cbc -a -salt -in "${item}.tar.gz" -out "${item}.tar.gz.ssl"
    rm -f "${item}.tar.gz"
  else
    openssl enc -aes-256-cbc -a -salt -in "${item}" -out "${item}.ssl"
  fi
}

function ssldecrypt {
  item=$1

  if [ ! -r $item ]; then
    exit 1;
  fi

  openssl enc -d -a -aes-256-cbc -in "${item}" > "${item}.decrypted"
}

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.tar.xz)    tar xvf $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
