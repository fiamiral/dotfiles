#!/bin/sh

# alacritty
export WINIT_UNIX_BACKEND=x11

# firefox
export MOZ_ENABLE_WAYLAND=1

#fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5

# set PATH
PATH="$PATH:${HOME}/.local/bin"

. "${HOME}/.config/common.env"

#sleep 1
exec sway
