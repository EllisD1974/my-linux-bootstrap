#eval "$(fzf --bash)"

alias fz="winpty fzf"
eval "$(starship init bash)"

# Starship pre-prompt hook
starship_precmd_user_func="set_git_title"

# Git branch switch aliases
alias gdev='git checkout develop'
#alias ghelper='git checkout SE-2264-create-tool-for-querying-fusion-csvs'
alias gc-='git checkout -'
alias gst='git status'
alias gdiff='git diff'

# Add this to your ~/.bashrc or ~/.gitconfig (if using [alias])
alias git-check-branches='git branch -vv | grep -E "^\*? *(develop|prod)" && [ "$(git rev-parse develop)" = "$(git rev-parse prod)" ] && echo "✅ develop and prod are at the same commit" || echo "❌ develop and prod differ"'

# Optional: enable Git completion for these aliases
__git_complete gdev _git_checkout
#__git_complete ghelper _git_checkout


# This checks if the previously ran command is a git diff command (or gdiff alias)
#	if so, it will then rerun the command as a git add
#gda() {
#  cmd=$(fc -ln -1)
#  # Check if the command was 'git diff' or 'gdiff'
#  if echo "$cmd" | grep -qE '^[[:space:]]*(git diff|gdiff)\b'; then
#    # Replace either 'git diff' or 'gdiff' with 'git add'
#    eval "$(echo "$cmd" | sed -E 's/^[[:space:]]*(git diff|gdiff)/git add/')"
#  else
#    echo "Last command was not a git diff."
#  fi
#}

gda() {
  cmd=$(fc -ln -1)
  # Check if the command was 'git diff' or 'gdiff'
  if echo "$cmd" | grep -qE '^[[:space:]]*(git diff|gdiff)\b'; then
    # Replace 'git diff' or 'gdiff' with 'git add', and append the passed args
    eval "$(echo "$cmd" | sed -E 's/^[[:space:]]*(git diff|gdiff)/git add/') $*"
  else
    echo "Last command was not a git diff."
  fi
}

# Function to set the Git Bash window title dynamically
function set_git_title() {
  # Check if the current directory is inside a Git repository
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the base name of the top-level directory of the Git repo
    repo_name=$(basename "$(git rev-parse --show-toplevel)")
    
    # Get the current Git branch name
    # If in detached HEAD state, fallback to short commit hash
    branch_name=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
    
    # Set the window title to "repo-name [branch-name]"
    echo -ne "\033]0;${repo_name} [${branch_name}]\007"
  else
    # If not in a Git repo, set the window title to the full path of the current directory
    echo -ne "\033]0;${PWD}\007"
  fi
}





# Function to jump to a repo
repo() {
    cd "/c/developer/repos/$1" || echo "Repo '$1' not found."
}

# Autocomplete for repo names
_repo_complete() {
    local cur repos
    cur="${COMP_WORDS[COMP_CWORD]}"
    repos=$(ls -d /c/developer/repos/*/ 2>/dev/null | xargs -n1 basename)
    COMPREPLY=( $(compgen -W "${repos}" -- "$cur") )
}
complete -F _repo_complete repo


pickrange() {
  local branch=$1
  local count=$2
  if [ -z "$branch" ] || [ -z "$count" ]; then
    echo "Usage: pickrange <branch> <count>"
    return 1
  fi

  git log -n "$count" --pretty=format:"%H" "$branch" |
    awk 'NR==count{oldest=$1} NR==1{newest=$1} END{print oldest "^.." newest}' count="$count"
}

