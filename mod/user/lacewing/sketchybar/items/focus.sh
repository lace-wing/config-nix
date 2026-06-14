#!/bin/bash

FOCUS_SCRIPT='sketchybar --set $NAME label="$WINDOW_TITLE"'

focus=(
  icon.drawing=off
  associated_display=active
  script="$FOCUS_SCRIPT"
)

sketchybar --add item focus left           \
           --set focus "${focus[@]}"   \
           --subscribe focus focus_change
