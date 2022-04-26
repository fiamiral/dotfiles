from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Set modkey to Super
mod = "mod4"


# Keybinds
keys = [
    # Qtile
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Exit Qtile"),
    Key([mod], "Return", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Window
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill current window"),

    # Launch
    Key([mod], "s", lazy.spawn("alacritty"), desc="Launch alacritty"),

    # ScratchPad
    Key([mod], "i", lazy.group["scratchpad"].dropdown_toggle("term1")),
]

groups = [
    ScratchPad("scratchpad", [
        DropDown("term1", "alacritty",
            width = 0.5, height = 0.5,
            x = 0.25, y = 0.25),
    ]),
    Group("1"),
    Group("2"),
    Group("3"),
    Group("4"),
]

layouts = [
    layout.Columns(
        border_focus = "#D08770",
        border_normal = "#8FBCBB",
        border_on_single = True,
        margin = 8,
    ),
]

#--------------------------------
# Screens
#--------------------------------
screens = [
    Screen(
        bottom=bar.Bar([
                widget.GroupBox(
                    this_current_screen_border = "#D08770",
                    this_screen_border = "#D08770",
                    other_current_screen_border = "#88C0D0",
                    other_screen_border = "#88C0D0",
                    inactive = "#4C566A",
                ),
                widget.Spacer(),
                widget.WindowName(),
                widget.Prompt(),
                widget.Volume(fmt="🔊: {}"),
                widget.Sep(),
                widget.Clock(format="%Y-%m-%d %H:%M:%S"),
            ], size = 30,
            background = "#2E3440",
            opacity = 0.8,),
        wallpaper = '~/sandbox/wallpaper.jpg',
        wallpaper_mode = "fill",
    ),
    Screen(
        bottom=bar.Bar([
                widget.GroupBox(
                    this_current_screen_border = "#D08770",
                    this_screen_border = "#D08770",
                    other_current_screen_border = "#88C0D0",
                    other_screen_border = "#88C0D0",
                    inactive = "#4C566A",
                ),
                widget.Spacer(),
                widget.WindowName(),
                widget.Prompt(),
                widget.Volume(fmt="🔊: {}"),
                widget.Sep(),
                widget.Clock(format="%Y-%m-%d %H:%M:%S"),
            ], size = 30,
            background = "#2E3440",
            opacity = 0.8,),
        wallpaper = '~/sandbox/wallpaper.jpg',
        wallpaper_mode = "fill",
    ),
]

widget_defaults = dict(
    font='Cica',
    fontsize=16,
    padding=3,
    foreground="#D8DEE9"
)
