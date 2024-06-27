#!/bin/bash

#TODO: get data according to dri number
while true; do cat /sys/kernel/debug/dri/0/i915_gem_objects| grep "avail: "; echo " ";  sleep 2; done
#while true; do cat /sys/kernel/debug/dri/1/i915_gem_objects| grep avail; echo " ";  sleep 1; done
