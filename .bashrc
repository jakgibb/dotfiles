PS1='\[\e[0;36m\]\A \[\e[0;36m\]\u@lenny\n[ \w ]\[\e[0;36m\]: \[\e[0m\]'

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

PATH=$PATH:~/.bin
export PATH
export LANG="en_GB.UTF-8"
complete -cf sudo

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Use up and down arrow to search the history
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

alias cc="clear"
alias xx="kill -9 $$"
alias rr="reset"
alias lsl="ls -l"
alias lsa="ls -la"
alias nano="nano -wxz"
alias scr="screen -r"
alias fer-tunnel="echo \"Opening encrypted tunnel\" ; ssh -ND 22222 fer -f"
alias enabled-services="systemctl list-unit-files |grep enabled"
alias wi="wicd-curses"

#pacman
alias pacup="sudo pacman -Syu"
alias pacs="pacman -Ss"
alias paci="pacman -Si"
alias pacg="sudo pacman -S"
alias epacup="sudo proxychains pacman -Syu"
alias epacs="proxychains pacman -Ss"
alias epaci="proxychains pacman -Si"
alias epacg="sudo proxychains pacman -S"

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

  openssl enc -d -a -aes-256-cbc -in "${item}" > "${item}.decrypted" 2>/dev/null
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



