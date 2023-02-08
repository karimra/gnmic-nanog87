#!/bin/bash

# https://asciinema.org/a/557297
# https://asciinema.org/a/557638 different screen

# deploy topology

sudo clab deploy -t topos/cli/nanog87.clab.yaml

export GNMIC_PASSWORD=NokiaSrl1!

gnmic -a clab-nanog87-leaf1 -u admin --skip-verify \
      -e json_ietf \
      get --path /system/name/host-name

gnmic -a clab-nanog87-leaf1 -u admin --skip-verify \
      -e json_ietf \
      get --path /interface[name=ethernet-1/1]

gnmic -a clab-nanog87-leaf1 -u admin --skip-verify \
      -e json_ietf \
      --type CONFIG \
      get --path /interface[name=ethernet-1/1]


gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2,clab-nanog87-spine1 -u admin --skip-verify \
      -e json_ietf \
      --type CONFIG \
      get --path /interface[name=ethernet-1/1]

