#!/bin/bash
DURATION=20
QUALITY='default'
APP='app'
AI='0'
AI_CLIENT='/home/hr/llm/sse_client_1024.py'
if which intel_gpu_top >/dev/null; then
    echo "intel_gpu_top is installed."
else
    echo "intel_gpu_top is not installed."
    exit
fi

help()
{
    echo "Usage collect_data.sh [-q|--quality [-i|--additional_info] INFO"
    exit 2
}
while [ "$#" -gt 0 ]; do
    case "$1" in
        -q | --quality)
            shift
            QUALITY=$1
            shift
            ;;
	-a | --app)
            shift
            APP=$1
            shift
            ;;
        -i | --additional_info)
            shift
            INFO=$1
            shift
            ;;
        -ai | --whether_for_ai)
	    shift
            AI=$1
            shift
            ;;
        *)
            help
            ;;
    esac
done

if [[ $QUALITY == "" ]]; then
    help
fi

delete() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        rm "$file_path"
    fi
}

if [[ $INFO == "" ]]; then
    FILE_NAME=$APP'_'$QUALITY
else
    FILE_NAME=$APP'_'$QUALITY'_'$INFO
fi
ROOT=`dirname $(readlink -f "$0")`
NAME=${FILE_NAME^^}         #force upper case
DATA=$ROOT/data/$NAME  #please give absolute directory

if [[ "$AI" -eq 1 ]] && [[ $AI_CLIENT == "" ]]; then
    echo "please provide the AI client path."
    help
fi

GPUTOP_FILE=$NAME'_gputop'
delete $GPUTOP_FILE
echo "Collect intel_gpu_top"
adb shell /data/intel_gpu_top -l > $GPUTOP_FILE&

echo "Collect gpu mem"
MEM_FILE=$NAME'_gpumem'
delete $MEM_FILE
sudo ./get_gpu_mem.sh > $MEM_FILE &

echo "Collect cpu top"
TOP_FILE=$NAME'_top'
delete $TOP_FILE 
adb shell top -b -d 3 -i > $TOP_FILE &

echo "Collect fps"


if [[ "$AI" -eq 0 ]]; then
   echo "sleep $DURATION"
   sleep $DURATION
else
   AI_FILE=$NAME'_AI'
   delete $AI_FILE
   sleep 15
   python3 $AI_CLIENT > $AI_FILE &
   sleep 15
fi

echo "Collect Done..."
./kill.sh > /dev/null

if [ -d "$DATA" ]; then
  cnt=`find -L $ROOT/data -name "${NAME}" | wc -l`  #-L let find follow symlink
  echo "Warning all old data in $NAME will be renamed as ${NAME}_${cnt}"
  mv $DATA "${DATA}_${cnt}"
fi

mkdir -p $DATA
mv basicInfo/*log $DATA
mv $GPUTOP_FILE $DATA
mv $MEM_FILE $DATA
mv $TOP_FILE $DATA
mv $AI_FILE $DATA
cp '/tmp/fps.txt' $DATA
echo "Data path: $DATA"
#python3 parse.py $FILE_NAME > $FILE_NAME'.result'
