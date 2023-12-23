# Home Server

## Usage

The point of organization for the entire system is the `servers-config.json` file.
This file is configured for the various responsibilities that the different machines should have.

### Standards
- Every service should log its actions
- Every machine is set up in the `servers-config` file and given responsibilities from the `responsibilities.json` file.

## Tech Stack
### Access
1) [localtonet](https://localtonet.com/)
    - used to expose VPN to the internet
2) [wireguard](https://www.wireguard.com/)
    - monitoring with [wg-monitor](https://github.com/jcocozza/wg-monitor)

### Data
1) hadoop
2) spark
3) mysql

## Machines
Uses the Greek Pantheon:
- zeus
- hades
- athena
- hephaestus

## Tools
- [speedtest](https://www.speedtest.net/apps/cli)
- monitoring with [go-speedtest](https://github.com/jcocozza/go_speedtest)

## Fun
- [minecraft](https://papermc.io/)
- [minecraft-bedrock](https://www.minecraft.net/en-us/download/server/bedrock)
