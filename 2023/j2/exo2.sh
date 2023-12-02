#! /bin/sh

answer=0

IFS="
"
for line in `cat input`
do
  gameId=`echo $line | cut -d ":" -f 1 | sed -e "s/Game //"`
  maxRed=1
  maxGreen=1
  maxBlue=1
  for subSet in `echo $line | cut -d ":" -f 2 | sed -e "s/;/\n/g"`
  do
    red=`echo $subSet | sed -e "s/.* \([0-9]*\) red.*/\1/"`
    green=`echo $subSet | sed -e "s/.* \([0-9]*\) green.*/\1/"`
    blue=`echo $subSet | sed -e "s/.* \([0-9]*\) blue.*/\1/"`
    if ! [ $red = $subSet ] && ([ $maxRed -eq 1 ] || [ $maxRed -lt $red ]); then
      maxRed=$red
    fi
    if ! [ $green = $subSet ] && ([ $maxGreen -eq 1 ] || [ $maxGreen -lt $green ]); then
      maxGreen=$green
    fi
    if ! [ $blue = $subSet ] && ([ $maxBlue -eq 1 ] || [ $maxBlue -lt $blue ]); then
      maxBlue=$blue
    fi
  done
  answer=$(($answer + $maxRed * $maxGreen * $maxBlue))
done
echo $answer
