#!/usr/bin/env bash
XDG_RUNTIME_DIR=/run/user/$UID \
QT_QPA_PLATFORM=wayland \
XDG_CURRENT_DESKTOP=kde \
XDG_SESSION_DESKTOP=kde \
flameshot
