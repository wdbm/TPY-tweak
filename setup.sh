#!/bin/bash

################################################################################
#                                                                              #
# TPY-tweak                                                                    #
#                                                                              #
################################################################################
#                                                                              #
# LICENCE INFORMATION                                                          #
#                                                                              #
# This program sets up tweaks for the ThinkPad S1 Yoga.                        #
#                                                                              #
# copyright (C) 2014 -- 2015 William Breaden Madden                            #
#                                                                              #
# This software is released under the terms of the GNU General Public License  #
# version 3 (GPLv3).                                                           #
#                                                                              #
# This program is free software: you can redistribute it and/or modify it      #
# under the terms of the GNU General Public License as published by the Free   #
# Software Foundation, either version 3 of the License, or (at your option)    #
# any later version.                                                           #
#                                                                              #
# This program is distributed in the hope that it will be useful, but WITHOUT  #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for     #
# more details.                                                                #
#                                                                              #
# For a copy of the GNU General Public License, see                            #
# <http://www.gnu.org/licenses/>.                                              #
#                                                                              #
################################################################################

# Add stylus and clickpad calibrations to ~/.bashrc.

IFS= read -d '' configuration << "EOF"
# ThinkPad S1 Yoga stylus calibration
xsetwacom --set 'Wacom ISDv4 EC Pen stylus' 'Area' '122 60 27510 15587'
# ThinkPad S1 Yoga clickpad configuration
xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Area" 0, 0, 0, 1
xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Soft Button Areas" 4184, 0, 1, 2788, 2997, 4184, 1, 2788
EOF
echo "${configuration}" > ~/.bashrc

# Install driver for wheel emulation scrolling.

wget https://raw.githubusercontent.com/wdbm/TPY-tweak/master/xserver-xorg-input-evdev_2.8.2-1_amd64.deb
sudo dpkg -i xserver-xorg-input-evdev_2.8.2-1_amd64.deb
rm xserver-xorg-input-evdev_2.8.2-1_amd64.deb
sudo apt-get remove xserver-xorg-input-synaptics

# Lock packages.

IFS= read -d '' messsage << "EOF"
Lock the following packages in Synaptic:

- xserver-xorg-input-evdev-dev
- xserver-xorg-input-evdev-dbg
- xserver-xorg-input-evdev
EOF
echo "${message}"
