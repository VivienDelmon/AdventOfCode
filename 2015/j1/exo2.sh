#! /bin/sh

nbChar=`wc -c input | cut -d " " -f 1`
floor=0

for i in `seq 1 $nbChar`
do
  char=`head -c $i input | tail -c 1`
  if [ $char = "(" ]; then
    floor=$(($floor + 1))
  else
    floor=$(($floor - 1))
  fi
  if [ $floor -eq -1 ]; then
    echo $i
    exit 0
  fi
done
