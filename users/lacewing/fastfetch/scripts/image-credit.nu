#!/usr/bin/env nu

def main [file] {
  let info = exiftool -json -Title -Creator -WebStatement $file
    | from json
    | first
    | select Title? Creator WebStatement?

  let title = if ($info.Title | is-not-empty) {
    $"(ansi cyan)($info.Title)"
  } | default null

  let creator = $"(ansi reset)by (ansi magenta)($info.Creator)"

  let url = if ($info.WebStatement | is-not-empty) {
    $"(ansi reset)on (ansi light_green)($info.WebStatement)"
  } | default null

  [$title, $creator, $url]
  | where ($it | is-not-empty)
  | str join ' '
  | %echo $in
}
