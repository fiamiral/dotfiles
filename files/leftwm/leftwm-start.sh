#!/bin/sh

#fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5

# set PATH
PATH="$PATH:${HOME}/.local/bin"

#sleep 1
exec sx leftwm
