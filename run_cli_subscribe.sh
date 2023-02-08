#!/bin/bash

#
# https://asciinema.org/a/557626
# https://asciinema.org/a/557633

sudo clab inspect --name nanog87
export GNMIC_PASSWORD=NokiaSrl1!

gnmic -a clab-nanog87-leaf1 -u admin --skip-verify \
      -e json_ietf \
      subscribe --path /interface[name=ethernet-1/1]/statistics \
      --mode stream \
      --stream-mode sample \
      --sample-interval 10s | jq


gnmic -a clab-nanog87-leaf1 -u admin --skip-verify \
      -e json_ietf \
      subscribe \
      --path /interface[name=ethernet-1/1]/statistics \
      --mode once | jq


gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2 -u admin --skip-verify \
      -e json_ietf \
      subscribe \
      --path /interface[name=ethernet-1/1]/statistics \
      --mode once | jq

cat configs/subscribe/gnmic.yaml | yq e

gnmic -a clab-nanog87-leaf1,clab-nanog87-leaf2,lab-nanog87-spine1 --config configs/subscribe/gnmic.yaml subscribe
