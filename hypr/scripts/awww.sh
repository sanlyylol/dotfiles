#!/usr/bin/env bash

for i in {1..30}; do
    if pgrep -x "awww-daemon" > /dev/null; then
        break
    fi
    sleep 1
done

sleep 1

awww img ~/Pictures/wallpapers/mountrain.gif
