{ config, pkgs, ... }:
# Adapted from https://github.com/dacrab/fastfetch-config/blob/main/config.jsonc
{
  programs.fastfetch = {
    enable = true;
    settings = {"logo": {"type":"nixos_small"},
    "modules": [
        {
            "type": "custom",
            "format": "╭───────────────────────── Hardware ──────────────────────────╮",
            "outputColor": "blue"
        },
        {
            "type": "title",
            "key": " PC",
            "keyColor": "green"
        },
{
      "key": "│ ├󰇅 Laptop",
      "keyColor": "green",
      "type": "host"
    },
{
      "key": "│ ├󰍹 Display",
      "keyColor": "green",
      "type": "display"
    },
        {
            "type": "cpu",
            "key": "│ ├󰍛 CPU",
            "showPeCoreCount": true,
            "format": "{1}",
            "keyColor": "green"
        },
        {
            "type": "gpu",
            "key": "│ ├󰍛 GPU",
            "keyColor": "green"
        },
        {
            "type": "memory",
            "key": "└ └󰍛 Memory",
            "keyColor": "green"
        },
        {
            "type": "custom",
            "format": "╰─────────────────────────────────────────────────────────────╯",
            "outputColor": "blue"
        },
        {
            "type": "custom",
            "format": "╭───────────────────────── Software ──────────────────────────╮",
            "outputColor": "blue"
        },
        {
            "type": "os",
      "key": " OS ",
            "keyColor": "cyan"
        },
        {
            "type": "kernel",
            "key": "│ ├ Kernel",
            "keyColor": "cyan"
        },
        {
            "type": "packages",
            "key": "│ ├󰏖 Packages",
            "keyColor": "cyan"
        },
        {
            "type": "shell",
            "key": "│ ├ Shell",
            "keyColor": "cyan"
        },
{
      "key": "│ ├ Terminal",
      "keyColor": "cyan",
      "type": "terminal"
    },
        {
            "type": "command",
            "key": "│ ├ OS Age",
            "keyColor": "cyan",
            "text": "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days"
        },
        {
            "type": "uptime",
            "key": "└ └ Uptime",
            "keyColor": "cyan"
        },
        {
            "type": "de",
            "key": " DE",
            "keyColor": "blue"
        },
	{
	    "type": "wm",
	    "key": " WM",
	    "keyColor": "magenta"
	},
        {
            "type": "gpu",
            "key": "│ ├󰍛 GPU Driver",
            "format": "{3}",
            "keyColor": "magenta"
        },
{
      "key": "│ ├󰃟 Brightness ",
      "keyColor": "magenta",
      "type": "brightness"
    },
        {
            "type": "version",
            "key": "└ └ FastFetch",
            "keyColor": "magenta"
        },
        {
            "type": "custom",
            "format": "╰────────────────────────────────────────────────────────────╯",
            "outputColor": "blue"
        },
        {
            "type": "custom",
            "format": "               \u001b[90m \u001b[31m \u001b[32m \u001b[33m \u001b[34m \u001b[35m \u001b[36m \u001b[37m "
        },
        "break"
    ]
} 
};
}
