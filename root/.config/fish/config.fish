set fish_greeting;
starship init fish | source
set VIRTUAL_ENV_DISABLE_PROMPT "1";
source ~/.profile;
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end
alias ls='/usr/bin/exa -al --color=always --group-directories-first';
alias grep='/bin/grep --color=auto';
alias syadm="/usr/bin/sudo /usr/bin/yadm -Y /etc/yadm";
alias cat="highlight -O ansi --force"
