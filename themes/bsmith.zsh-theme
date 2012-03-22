function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    echo "%{$fg_bold[red]%}➜%{$reset_color%}"
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
< on %{$fg[magenta]%}<branch>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

function has_rbenv_and_is_local {
    command -v rbenv &> /dev/null
    if [[ $? -eq 0 ]]; then
        rbenv local &> /dev/null
        return $?
    fi
}

function rbenv_prompt_info {
    local rbenv_info=''

    if has_rbenv_and_is_local; then
        local gemset=$(rbenv gemset active)
        if [[ -n $gemset ]]; then
            rbenv_info="%{$fg[red]%}‹${gemset}@$(rbenv version | sed -e 's/ (set.*$//')›%{$reset_color%}"
        else
            rbenv_info="%{$fg[red]%}‹$(rbenv version | sed -e 's/ (set.*$//')›%{$reset_color%}"
        fi    
        echo "${rbenv_info} "
    fi
}

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)%{$reset_color%}
$(virtualenv_info)$(rbenv_prompt_info)$(prompt_char) '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_SVN_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_SVN_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_SVN_PROMPT_CLEAN=""
