from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Set modkey to Super
mod = "mod4"


# Keybinds
keys = [
    # System
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Exit Qtile"),

    # Window
    Key([mod], "q", lazy.window.kill(), desc="Kill current window"),

    # temp
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

groups = [
    Group("1"),
    Group("2"),
    Group("3"),
    Group("4"),
]

layouts = [
    layout.Columns(),
]


screens = [
    Screen(
        bottom=bar.Bar([
            widget.GroupBox(),
            widget.Prompt(),
            widget.WindowName(),
            widget.Systray(),
            widget.Clock(format="%Y-%m-%d %H:%M:%S"),
        ], 30), # 30 is Height of bar
    ),
    Screen(),
]


