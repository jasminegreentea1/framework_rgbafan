# Framework Desktop Fan RGB Animations / MPD Visualizer

## Overview

This is a simple Rust tool for Linux to visualize music and display
simple animations onto the Framework Desktop RGB fan, as this fan does
not expose an interface in `/sys/class/leds`.

It's mainly a wrapper + some animation logic for the
[framework-system](https://github.com/FrameworkComputer/framework-system)
`framework-lib` library, as the driver communication part was already
done, but needing to run the `framework-system` binary each time you
wanted to change anything seemed like a drag.


## Installation
First clone into the repositor, then install by running `make install`.
Respectively, you can uninstall by `make uninstall`.

This will copy the correct scripts and whatnot to the proper places. It's
recommended that you don't use `/usr/bin/framework_rgbafan_daemon` directly, but
rather through the script `/usr/bin/fmwrk-rgbfan`.

If you want to use this in scripting and would rather not have to use sudo, add

    %rgbfan ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart fmwrk-rgbfan.service, /usr/bin/tee /etc/default/fmwrk-rgbfan 
    
To your sudoers file via `sudo visudo`. After creating a `rgbfan` group for your
user. For example, you could automate switching to different animations and
colors for day and night.


## Music Visualizer Usage

In order for MPD mode to work, ensure the following code block is in your
`~/.config/mpd.config`.

    audio_output {
        type                    "fifo"
        name                    "frameworkrgb"
        path                    "/tmp/rgb.fifo"
        format                  "44100:16:2"
    }

It's configured to be the case that low frequency bass bands, are
cool colors, and the high frequency bands correspond to the warm
colors, with the rainbow being between them. If you want to change
these, feel free to check out `mpd_visualizer::get_freq_color`.


## CLI help text

```
Animate your Framework computer RGB fan! Don't forget sudo! Example:
`sudo fmwrk-rgbfan smoothspin 20 -e cwfade -p 50`

Usage: sudo fmwrk-rgbfan [OPTIONS] <MODE> [TICK_MS]

Arguments:
  <MODE>     Available animation modes: static, sequence, random, randominput,
             quadspin, fullspin, smoothspin, rainbowspin, mpd. 
             - static: static color(s) across all LEDs, no animation. 
             - sequence: iterate through colors, one on all LEDs at a time. 
             - random: random colors on each LED changing every update. 
             - randominput: random brightnesses selected from passed colors on each LED changing every update, can achieve fireplace flicker vibe. 
             - quadspin: LEDs divided into 4 quadrants of color cycling discretely. 
             - fullspin: spinning colors across all LEDs. 
             - smoothspin: spinning color gradient with interpolation across all LEDs. 
             - rainbowspin: spinning rainbow across all LEDs. 
             - mpd: music visualizer mode, see README.
  [TICK_MS]  Integer number of milliseconds between updates [default: 32]

Options:
  -c, --colors <str>...       List of 1-8 color hex strings, specified with 6
                              characters each or a single 0 for LED off. For
                              static and 'spin' modes, if fewer than 8 colors
                              are specified, they will map linearly across the
                              8 LEDs. rainbowspin has preset colors and
                              therefore ignores this list. [default: ff0000
                              00ff00 0000ff]
  -e, --effect <str>          Available brightness effects: blink, pulse,
                              cwfade, ccwfade, cwccwfade. Effects can be
                              optionally applied to any animation mode.
  -p, --effect-period <uint>  Brightness effect period in units of ticks.
                              [default: 20]
  -s, --speed-from-fan        Flag to make the fan speed control the update
                              time, from 500 ms with fan off to 1 ms with it
                              at 100%.
  -h, --help                  Print help.
  -V, --version               Print version.
```
