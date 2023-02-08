#!/bin/bash

# https://asciinema.org/a/557609
# https://asciinema.org/a/557616

export GNMIC_PASSWORD=NokiaSrl1!
# deploy topology

sudo clab deploy -t topos/cli/nanog87.clab.yaml -c
sudo clab inspect --name nanog87
#

gnmic -a clab-nanog87-leaf1 -u admin --skip-verify \
      -e json_ietf \
      get \
      --type CONFIG \
      --path /interface[name=ethernet-1/1]

gnmic -a clab-nanog87-leaf2 -u admin --skip-verify \
      -e json_ietf \
      get \
      --type CONFIG \
      --path /interface[name=ethernet-1/1]

gnmic -a clab-nanog87-spine1 -u admin --skip-verify \
      -e json_ietf \
      get \
      --type CONFIG \
      --path /interface[name=ethernet-1/1] \
      --path /interface[name=ethernet-1/2]

## set RPC
gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2 -u admin \
      --skip-verify \
      -e json_ietf \
      set \
      --update-path interface[name=ethernet-1/1]/admin-state \
      --update-value enable \
      --update-path interface[name=ethernet-1/1]/subinterface[index=0]/admin-state \
      --update-value enable

gnmic -a clab-nanog87-spine1 -u admin --skip-verify \
      -e json_ietf \
      set \
      --update-path interface[name=ethernet-1/1]/admin-state \
      --update-value enable \
      --update-path interface[name=ethernet-1/1]/subinterface[index=0]/admin-state \
      --update-value enable \
      --update-path interface[name=ethernet-1/2]/admin-state \
      --update-value enable \
      --update-path interface[name=ethernet-1/2]/subinterface[index=0]/admin-state \
      --update-value enable

gnmic -a clab-nanog87-spine1 -u admin --skip-verify \
      -e json_ietf \
      get \
      --type CONFIG \
      --path /interface[name=ethernet-1/1] \
      --path /interface[name=ethernet-1/2]

gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2,clab-nanog87-spine1 -u admin --skip-verify \
      -e json_ietf \
      set \
      --delete /interface[name=ethernet-1/1] \
      --delete /interface[name=ethernet-1/2]

# set with a JSON config file 
cat configs/set/interface_config.json | jq

gnmic -a clab-nanog87-spine1 -u admin --skip-verify \
      -e json_ietf \
      set \
      --update-path interface[name=ethernet-1/1] \
      --update-file configs/set/interface_config.json \
      --update-path interface[name=ethernet-1/2] \
      --update-file configs/set/interface_config.json


gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2 -u admin --skip-verify \
      -e json_ietf \
      set \
      --update-path interface[name=ethernet-1/1] \
      --update-file configs/set/interface_config.json

gnmic -a clab-nanog87-spine1 -u admin --skip-verify \
      -e json_ietf \
      get \
      --type CONFIG \
      --path /interface[name=ethernet-1/1] \
      --path /interface[name=ethernet-1/2]

gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2 -u admin --skip-verify \
      -e json_ietf \
      get \
      --type CONFIG \
      --path /interface[name=ethernet-1/1]

gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2,clab-nanog87-spine1 -u admin --skip-verify \
      -e json_ietf \
      set \
      --delete /interface[name=ethernet-1/1] \
      --delete /interface[name=ethernet-1/2]

# set with a templated request
gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2,clab-nanog87-spine1 -u admin \
      --skip-verify \
      -e json_ietf --no-prefix \
      set \
      --request-file configs/set/template.gotmpl \
      --request-vars configs/set/vars.yaml --dry-run

gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2,clab-nanog87-spine1 -u admin \
      --skip-verify \
      -e json_ietf --no-prefix \
      set \
      --request-file configs/set/template.gotmpl \
      --request-vars configs/set/vars.yaml | jq
