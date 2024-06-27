#!/bin/bash
echo 'setup performance mode'
for i in {0..100}
do
  file_path="/sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor"
  if [ -f "$file_path" ]; then
          echo "Number: $i"
	  echo performance > $file_path
  else
	  exit
  fi

done

