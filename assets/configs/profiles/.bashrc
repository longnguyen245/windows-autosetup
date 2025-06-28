eval "$(fnm env --use-on-cd)"
PROMPT_COMMAND='history -a'  

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

alias si="scoop install"
alias sia="gsudo scoop install"
alias sui="scoop uninstall"
alias suia="gsudo scoop uninstall"
alias su="powershell.exe -NoProfile -Command 'gsudo scoop update *' && powershell.exe -NoProfile -Command 'scoop cleanup *' && powershell.exe -NoProfile -Command 'scoop cache rm *'"