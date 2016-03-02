# Ubuntu Server Setup

We use Ubuntu 14.04 for hosting the application on a dedicated server (or VPS for cloud hosting).

Start out by installing vanilla Ubuntu 14.04 and then running the system updates.

## Base Server Configuration

### Base Packages
Update the machine and install some base packages that one would expect on a Linux machine.

```bash
sudo apt-get update; sudo apt-get upgrade -y; \
sudo apt-get install -y gcc make openssh-server zip \
              unzip curl gdebi lynx screen reptyr nmap \
              host wget rcconf libwww-perl \
              lsb-release iptables iftop iotop
```

### Hostname
Set the machine's hostname.
```bash
echo mathapp.example.com | sudo tee /etc/hostname > /dev/null
sudo hostname $(cat /etc/hostname)
export HOSTNAME=`hostname`
echo "$(ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1) $(cat /etc/hostname)" | sudo tee -a /etc/hosts > /dev/null
```

### Bashrc
Modify the Bash RC to work with an interactive shell.

```bash
for dir in /home/* /etc/skel /root
do

sudo tee -a $dir/.bashrc > /dev/null <<'EOF'

# Color prompt
PS1='\t [${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\H\[\033[00m\]] \[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

export EDITOR=/usr/bin/vi

# set PATH so it includes user's private bin if the directory exists and isn't already in the path
if [ -d ~/bin ] && [[ ! "$PATH" =~ "~/bin" ]]; then
    export PATH="~/bin:$PATH"
fi
EOF

sudo tee -a $dir/.bash_profile > /dev/null <<'EOF'
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
EOF

sudo tee -a $dir/.bash_aliases > /dev/null <<'EOF'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias vi=vim
alias grep='grep --color=auto'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
EOF

sudo mv $dir/.bashrc{,_interactive}
sudo tee -a $dir/.bashrc > /dev/null <<'EOF'
# if running interactively, load interactive config
[ -n "$PS1" ] && . ~/.bashrc_interactive

EOF

done
```

### Exim
Set up Exim4 as local MTA
```bash
sudo apt-get install -y exim4
sudo dpkg-reconfigure exim4-config
```
