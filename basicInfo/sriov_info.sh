#!/bin/bash
f="/sys/class/drm/card0"


f=$f/iov/pf/device
echo  sriov_numvfs
cat $f/sriov_numvfs
n=$(cat $f/sriov_numvfs)
echo auto_provisioning
cat $f/drm/card0/prelim_iov/pf/auto_provisioning
echo sriov_drivers_autoprobe
cat $f/sriov_drivers_autoprobe
echo policy
cat /sys/class/drm/card0/prelim_iov/pf/gt/policies/sched_if_idle
echo "pf exec_quantum_ms:"
cat /sys/class/drm/card0/prelim_iov/pf/gt/exec_quantum_ms
echo "pf preemt_timout_us:"
cat /sys/class/drm/card0/prelim_iov/pf/gt/preempt_timeout_us
for ((i=1; i<=n; i++)); do
    echo "vf$i exec_quantum_ms:"
    cat /sys/class/drm/card0/prelim_iov/vf$i/gt/exec_quantum_ms
    echo "vf$i preempt_timeout_us:"
    cat /sys/class/drm/card0/prelim_iov/vf$i/gt/preempt_timeout_us
done

