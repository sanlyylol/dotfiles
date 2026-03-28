#!/usr/bin/env bash

while ! pgrep -x "awww-daemon" > /dev/null; do
  sleep 1
done

awww img ~/Pictures/wallpapers/walls/thunderstorm-sea.webp
