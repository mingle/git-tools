# git bash completion
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
  . /usr/local/git/contrib/completion/git-completion.bash
fi

# allow us to type 'g' for git and still have git autocompletion
alias g='git'
complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null || complete -o default -o nospace -F _git g

function if_declared {
  local name=$1
  eval "test -z \"\${$name:+''}\"" && return 1
  return 0
}

# define constants only once
if_declared _reset || readonly _reset=$(tput sgr0)
if_declared _red   || readonly _red=$(tput setaf 1)
if_declared _green || readonly _green=$(tput setaf 2)

function has_changes {
  local status=$(git status --porcelain 2>/dev/null | grep -vE '^\?\? ')
  if [ -n "$status" ]; then
    echo -n $_red
  else
    echo -n $_green
  fi
}

function git_user_name {
  local author=$(git config --get user.name)
  if [ -z "$author" ]; then
    echo -n "${_red}user.name IS UNSET${_reset}"
  else
    echo -n $author
  fi
}

# metaprogramming, like ruby's alias_method, could be useful
alias_function() {
  local old_name=$(declare -f $1)
  local new_name="$2${old_name#$1}"
  eval "$new_name"
}

PS1='\h:\W $(__git_ps1 "($(has_changes)%s, $(git_user_name)$_reset) ")\$ '
