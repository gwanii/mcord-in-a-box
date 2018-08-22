#!/bin/bash
set_no_flood() {
  for n in $(sudo ovs-ofctl show "$1"|less|grep -- "("|awk -F\( '{print $2}'|awk -F\) '{print $1}'|grep -v xid); do
    sudo ovs-ofctl mod-port "$1" "$n" no-flood
  done
}

set_no_flood leaf1
set_no_flood spine1
