for i in {0..23}
do
  echo "CPU: $i"
  cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq
done

