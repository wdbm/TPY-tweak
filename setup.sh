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

sudo apt-get build-dep xserver-xorg-input-evdev xserver-xorg-input-synaptics

wget https://aur.archlinux.org/packages/xf/xf86-input-evdev-trackpoint/xf86-input-evdev-trackpoint.tar.gz
tar -xzf xf86-input-evdev-trackpoint.tar.gz
git clone git://git.debian.org/git/pkg-xorg/driver/xserver-xorg-input-evdev
git clone git://git.debian.org/git/pkg-xorg/driver/xserver-xorg-input-synaptics

mv xf86-input-evdev-trackpoint arch
mv xserver-xorg-input-evdev evdev
mv xserver-xorg-input-synaptics synaptics

cp synaptics/src/{eventcomm.c,eventcomm.h,properties.c,synaptics.c,synapticsstr.h,synproto.c,synproto.h} evdev/src
cp synaptics/include/synaptics-properties.h evdev/src
cp arch/*.patch evdev

cd evdev
patch -p1 -i 0001-implement-trackpoint-wheel-emulation.patch
patch -p1 -i 0008-disable-clickpad_guess_clickfingers.patch
patch -p1 -i 0010-add-synatics-files-into-Makefile.am.patch

dpkg-buildpackage

cd ..
sudo dpkg -i xserver-xorg-input-evdev_*.deb
sudo apt-get remove xserver-xorg-input-synaptics

#wget https://raw.githubusercontent.com/wdbm/TPY-tweak/master/xserver-xorg-input-evdev_2.8.2-1_amd64.deb
#sudo dpkg -i xserver-xorg-input-evdev_2.8.2-1_amd64.deb
#rm xserver-xorg-input-evdev_2.8.2-1_amd64.deb
#sudo apt-get remove xserver-xorg-input-synaptics

# Lock packages.

IFS= read -d '' messsage << "EOF"
Lock the following packages in Synaptic:

- xserver-xorg-input-evdev-dev
- xserver-xorg-input-evdev-dbg
- xserver-xorg-input-evdev
EOF
echo "${message}"
