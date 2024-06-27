rm -rf *log
lscpu > cpu_info.log
ls /dev/dri > render_node.log
vulkaninfo|grep Mesa > mesa_info.log
glxinfo|grep Mesa >> mesa_info.log
./getfreq.sh > cpu_freq.log
sudo dmidecode -t memory > memory_info.log
./sriov_info.sh > sriov_info.log
