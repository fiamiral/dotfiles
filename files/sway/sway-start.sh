#!/bin/sh

# alacritty
export WINIT_UNIX_BACKEND=x11

# firefox
export MOZ_ENABLE_WAYLAND=1

sleep 1
exec sway
