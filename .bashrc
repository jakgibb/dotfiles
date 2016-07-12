	
PS1='\[\e[0;36m\]\A \[\e[0;36m\]\u@create\n[ \w ]\[\e[0;36m\]: \[\e[0m\]'

[ -z "$PS1" ] && return

PATH=$PATH:~/.bin
export PATH
export LANG="en_GB.UTF-8"
complete -cf sudo

HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
HISTCONTROL=ignoreboth
shopt -s histappend

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

alias cc="clear"
alias xx="kill -9 $$"
alias rr="reset"
alias lsl="ls -l"
alias lsa="ls -la"
alias nano="nano -wxz"
alias scr="screen -r"
alias sysop-tunnel="echo \"Opening encrypted tunnel\" ; ssh -ND 22222 sysop -f"
alias sysop-tor="echo 'ssh sysop -f -N -L 19050:localhost:19050' ; ssh sysop -f -N -L 19050:localhost:19050"
alias enabled-services="systemctl list-unit-files |grep enabled"
alias firewall-off="sudo systemctl stop iptables"
alias firewall-on="sudo systemctl start iptables"
alias dec="sudo cryptsetup luksOpen"

#pacman
alias pacup="sudo pacman -Syu"
alias pacs="pacman -Ss"
alias paci="pacman -Si"
alias pacg="sudo pacman -S"
alias epacup="sudo proxychains pacman -Syu"
alias epacs="proxychains pacman -Ss"
alias epaci="proxychains pacman -Si"
alias epacg="sudo proxychains pacman -S"

function pword {
	word=$1
	printf $word | sha256sum
}

function sslcrypt {
  item=$(echo $1 | sed -e 's/\/$//') # get rid of trailing / on directories

  if [ ! -r $item ]; then
    echo "No such file"
    exit 1
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
    echo "No such file"
    exit 1
  fi

  openssl enc -d -a -aes-256-cbc -in "${item}" > "${item}.decrypted" 2>/dev/null
	if [ $? -ne 0 ];then
		echo "Wrong decryption password"
	fi
}

function gpgcrypt {
  item=$(echo $1 | sed -e 's/\/$//') # get rid of trailing / on directories

  if [ ! -r $item ]; then
    echo "No such file"
    exit 1
  fi

  if [ -d $item ]; then
    tar zcf "${item}.tar.gz" "${item}"
    gpg --output "${item}.tar.gz.gpg" --symmetric --cipher-algo AES256 "${item}.tar.gz"    
    rm -f "${item}.tar.gz"
  else
    gpg --output "${item}.gpg" --symmetric --cipher-algo AES256 "${item}"    
  fi
}

function gpgdecrypt {
  item=$1

  if [ ! -r $item ]; then
    echo "No such file"
    exit 1
  fi

  gpg --output "${item}.gpg.decrypted" --decrypt "${item}"
	if [ $? -ne 0 ];then
		echo "Wrong decryption password"
	fi
}

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 -k -v $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip -k -v $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
