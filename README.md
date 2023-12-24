# Home Server

## Motivation

The goal of this project is to have an easy way to orchestrate lots of self-hosted processes through a relatively simple configuration file.

Moreover, these processes should be easily distributable to several machines or a single one - all organized by the config file.
This way, setting up, starting, stopping and moving processes across machines should be relatively simple.

On top of that there is a single point of entry, a wireguard server, that allows trusted machines to access the services provided.

## Usage

The point of organization for the entire system is the `servers-config.json` file.
This file is configured for the various responsibilities that the different machines should have.

The expectation is that most things are running on Ubuntu.

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
1) Hadoop
2) Spark
3) MySQL

## Machines
Uses the Greek Pantheon:
- zeus
- hades
- athena
- hephaestus

## Tools
- [Ookla speedtest](https://www.speedtest.net/apps/cli)
    - monitoring with [go-speedtest](https://github.com/jcocozza/go_speedtest)
- [budget](https://github.com/actualbudget/actual)

## Fun
- [Minecraft](https://papermc.io/)
- [Minecraft-Bedrock](https://www.minecraft.net/en-us/download/server/bedrock)
