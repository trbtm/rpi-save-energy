# rpi-save-energy

Collection of scripts to save energy on Raspberry Pi. The script gives the user the choice to disable / deactivate

- Power aka `PWR` LED
- Activity aka `ACT` LED
- Ethernet LEDs
- Bluetooth
- Wifi
- HDMI

## Installation

Download the source code from the Releases section or clone the repository. Then run `install.sh`.
Don't delete the repository after the installation since `scripts/save_energy.sh` is required by the systemd service
and the config file is saved inside the repository.

## Deinstallation

Run `uninstall.sh`.
