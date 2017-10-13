#!/bin/bash

gs() { gsettings set "$@"; }

# desktop background
gs org.mate.background picture-filename '/usr/share/backgrounds/debianMate/desktop.jpg'
gs org.mate.background picture-options 'zoom'

# desktop theme
gs org.mate.interface gtk-theme 'Blue-Submarine'
#gs org.mate.interface gtk-color-scheme ''
gs org.mate.interface icon-theme 'mate'

# window manager theme
gs org.mate.Marco.general theme 'Blue-Submarine'

# sound theme
gs org.mate.sound theme-name 'freedesktop'
gs org.mate.sound event-sounds true

# screensaver prefs
#gs org.mate.screensaver mode 'single'
#gs org.mate.screensaver themes 'binaryring'

# touchpad settings
gs org.mate.peripherals-touchpad disable-while-typing true
gs org.mate.peripherals-touchpad tap-to-click true
gs org.mate.peripherals-touchpad two-finger-click 0
gs org.mate.peripherals-touchpad three-finger-click 0
gs org.mate.peripherals-touchpad natural-scroll true

# pointer theme
gs org.mate.peripherals-mouse cursor-theme 'Adwaita'

# pluma prefs
gs org.mate.pluma color-scheme 'oblivion'
#gs org.mate.pluma active-plugins 'modelines'
gs org.mate.pluma auto-indent true

# relocatable schemas

# terminal
gs org.mate.terminal.profile:/org/mate/terminal/profiles/default/ cursor-shape 'underline'
gs org.mate.terminal.profile:/org/mate/terminal/profiles/default/ login-shell true
gs org.mate.terminal.profile:/org/mate/terminal/profiles/default/ scrollback-unlimited true
gs org.mate.terminal.profile:/org/mate/terminal/profiles/default/ use-theme-colors false
gs org.mate.terminal.profile:/org/mate/terminal/profiles/default/ background-color '#000000000000'
gs org.mate.terminal.profile:/org/mate/terminal/profiles/default/ foreground-color '#0000FFFF0000'

# clock
gs org.mate.panel.applet.clock:/org/mate/panel/objects/clock/prefs/ show-seconds true
gs org.mate.panel.applet.clock:/org/mate/panel/objects/clock/prefs/ show-date true
gs org.mate.panel.applet.clock:/org/mate/panel/objects/clock/prefs/ format '12-hour'
gs org.mate.panel.applet.clock:/org/mate/panel/objects/clock/prefs/ show-temperature false
gs org.mate.panel.applet.clock:/org/mate/panel/objects/clock/prefs/ show-weather false

