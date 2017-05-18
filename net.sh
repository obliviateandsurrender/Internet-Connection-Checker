#!/bin/bash

if ! /bin/ip route | grep -q ^default; then
  echo "No Internet connection on this machine"
  exit 0
fi
interface="$(/bin/ip route | awk '$1 == "default" {for (i=2;i<=NF;i++) if ($i == "dev") { i++;print $i; exit}}')"
if [ -z "$interface" -o \! -e /sys/class/net/"$interface" ]; then
    echo "Apologies, wrong interface information was provided, now aborting..."
  exit 1
fi
if /sbin/iw dev "$interface" info &>/dev/null; then
  echo "Internet connection is wireless."
  echo "Information about the interface and connection is:"
  iwconfig "$interface"
else
  echo "Internet connection is wired."
  echo "Information about the interface and connection is:"           
  ifconfig "$interface"
fi
