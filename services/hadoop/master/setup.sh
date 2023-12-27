#!/bin/bash
#
# This will run all scripts necessary for setting up hadoop

bash services/hadoop/master/setup/config_setup.sh
bash services/hadoop/master/setup/distribute_configuration.sh
bash services/hadoop/master/setup/format.sh