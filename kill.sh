#!/bin/bash
kill_process(){
  PROCESS_NAME=$1
  PID=$(ps -aux| grep -w $PROCESS_NAME|grep -v grep|awk '{print $2}')
  if [ -z "$PID" ]; then
      echo "no $PROCESS_NAME"
  else
      echo "sudo kill -9 $PID"
      sudo kill -9 $PID
  fi
}


kill_process 'intel_gpu_top'
kill_process 'top'
kill_process 'get_gpu_mem.sh'




