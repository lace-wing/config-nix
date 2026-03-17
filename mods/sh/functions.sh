# cd relative to git top level
function cd_git_top() {
  top=$(git rev-parse --show-toplevel 2>/dev/null) || return
  cd "$top/$1" 2>/dev/null || cd "$top" || return
}


# editor after fzf
function fzf_editor() {
  "$EDITOR" $(fzf)
}

# zellij attach or create with layout
function zellij_session_layout() {
  zellij attach "$1" 2>/dev/null || zellij --session "$1" --new-session-with-layout "${2:-default}"
}

# tldr all commands with preview
function tldr_fzf_preview() {
  tldr -l | fzf --preview "tldr {1}" --preview-window=right,75% | xargs tldr
}

