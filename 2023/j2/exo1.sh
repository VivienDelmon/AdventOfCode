#! /bin/sh

maxRed=12
maxGreen=13
maxBlue=14
answer=0

IFS="
"
for line in `cat input`
do
  gameId=`echo $line | cut -d ":" -f 1 | sed -e "s/Game //"`
  liar="false"
  for subSet in `echo $line | cut -d ":" -f 2 | sed -e "s/;/\n/g"`
  do
    red=`echo $subSet | sed -e "s/.* \([0-9]*\) red.*/\1/"`
    green=`echo $subSet | sed -e "s/.* \([0-9]*\) green.*/\1/"`
    blue=`echo $subSet | sed -e "s/.* \([0-9]*\) blue.*/\1/"`
    if [ $red = $subSet ]; then
      red=0
    fi
    if [ $green = $subSet ]; then
      green=0
    fi
    if [ $blue = $subSet ]; then
      blue=0
    fi
    if [ $red -gt $maxRed ] || [ $green -gt $maxGreen ] || [ $blue -gt $maxBlue ]; then 
      liar=true
    fi
  done
  if [ $liar = false ]; then
    answer=$(($answer + $gameId))
  fi
done
echo $answer
