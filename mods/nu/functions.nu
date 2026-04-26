# cd relative to git top level
def cd_git_top [path?: string] {
  let top = (do { ^git rev-parse --show-toplevel } | complete).stdout | str trim

  if ($top | is-empty) {
    return
  }

  if ($path != null) {
    let target = $"($top)/($path)"
    if ($target | path exists) {
      cd $target
    } else {
      cd $top
    }
  } else {
    cd $top
  }
}

# editor after fzf
def fzf_editor [] {
  let file = (^fzf | str trim)
  if ($file | is-not-empty) {
    ^$env.EDITOR $file
  }
}

# zellij attach or create with layout
def zellij_session_layout [session_name: string, layout: string = "default"] {
  let attach_attempt = (do { ^zellij attach $session_name } | complete)

  if ($attach_attempt.exit_code != 0) {
    ^zellij --session $session_name --new-session-with-layout $layout
  }
}

# tldr all commands with preview
def tldr_fzf_preview [] {
  let selection = (^tldr -l | fzf --preview "tldr {1}" --preview-window=right,75% | str trim)
  
  if ($selection | is-not-empty) {
    ^tldr $selection
  }
}

