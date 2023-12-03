#! /bin/sh -f

answer=0

prevSymbols=""
prevNumbers=""
currSymbols=""
currNumbers=""
nextSymbols=""
nextNumbers=""

numberOfLines=`wc -l input | cut -d " " -f 1`

function popFront()
{
  if ! eval echo \$$2 | grep ":" > /dev/null; then
    eval $1=\$$2
    eval $2=""
  else
    eval $1=`eval echo \\$$2 | cut -d ":" -f 1`
    eval $2=`eval echo \\$$2 | cut -d ":" -f 2-`
  fi
}

while read line
do
  echo $line
  i=-1
  prevCharIsNumber=false
  number=""
  for c in `echo $line | sed -e "s/./& /g"`
  do
    currCharIsNumber=false
    i=$((i + 1))
    if ! [ $c = "." ]; then
      if echo $c | grep "[0-9]" > /dev/null ; then
        prevCharIsNumber=true
        currCharIsNumber=true
        number="$number$c"
      elif [ $c = "*" ]; then
        nextSymbols=$nextSymbols:$i
      fi
    fi
    if [ $currCharIsNumber = false ] && [ $prevCharIsNumber = true ]; then
      numberLength=`echo -n $number | wc -c`
      nextNumbers="$nextNumbers $(($i - $numberLength)),$((i - 1)),$number"
      prevCharIsNumber=false
      number=""
    fi
  done

  if [ $prevCharIsNumber = true ]; then
    numberLength=`echo -n $number | wc -c`
    nextNumbers="$nextNumbers $(($i - $numberLength)),$((i - 1)),$number"
    prevCharIsNumber=false
    number=""
  fi

  nextNumbers=`echo $nextNumbers | cut -d ":" -f 2-`
  nextSymbols=`echo $nextSymbols | cut -d ":" -f 2-`

  # echo $nextNumbers
  # echo $nextSymbols

  # check curr

  copyPrevSymbols=$prevSymbols
  copyCurrSymbols=$currSymbols
  copyNextSymbols=$nextSymbols
  prevSymbols="-2"
  currSymbols="-2"
  nextSymbols="-2"
  prevIdx=-2
  currIdx=-2
  nextIdx=-2
  for n in $currNumbers;
  do
    startIdx=$((`echo -n $n | cut -d "," -f 1` - 1))
    endIdx=$((`echo -n $n | cut -d "," -f 2` + 1))
    number=`echo -n $n | cut -d "," -f 3`
    while ! [ x$prevIdx = x ] && [ $prevIdx -lt $startIdx ]
    do
      popFront prevIdx copyPrevSymbols 
      prevSymbols="$prevSymbols:$prevIdx"
      prevIdx=`echo $prevIdx | cut -d "," -f 1`
    done
    if ! [ x$prevIdx = x ] && [ $prevIdx -le $endIdx ]; then
      prevSymbols="$prevSymbols,$number"
    fi

    while ! [ x$currIdx = x ] && [ $currIdx -lt $startIdx ]
    do
      popFront currIdx copyCurrSymbols 
      currSymbols="$currSymbols:$currIdx"
      currIdx=`echo $currIdx | cut -d "," -f 1`
    done
    if ! [ x$currIdx = x ] && [ $currIdx -le $endIdx ]; then
      currSymbols="$currSymbols,$number"
    fi

    while ! [ x$nextIdx = x ] && [ $nextIdx -lt $startIdx ]
    do
      popFront nextIdx copyNextSymbols 
      nextSymbols="$nextSymbols:$nextIdx"
      nextIdx=`echo $nextIdx | cut -d "," -f 1`
    done
    if ! [ x$nextIdx = x ] && [ $nextIdx -le $endIdx ]; then
      nextSymbols="$nextSymbols,$number"
    fi
  done

  prevSymbols=$prevSymbols:$copyCurrSymbols
  currSymbols=$currSymbols:$copyCurrSymbols
  nextSymbols=$nextSymbols:$copyCurrSymbols
  #echo $prevSymbols

  for i in `echo $prevSymbols | sed -e "s/:/ /g"`
  do
    if echo $i | grep "," > /dev/null ; then
      mult=`echo $i | cut -d "," -f 2- --output-delimiter="*"`
      if ! [ `echo $mult | grep -o "*" | wc -c` -eq 2 ]; then
        continue
      fi
      answer=`echo "$answer + $mult" | bc`
      echo $mult $answer
    fi
  done

  prevSymbols=$currSymbols
  prevNumbers=$currNumbers
  currSymbols=$nextSymbols
  currNumbers=$nextNumbers
  nextSymbols=""
  nextNumbers=""
done < input

# one last check
copyPrevSymbols=$prevSymbols
copyCurrSymbols=$currSymbols
prevSymbols="-2"
currSymbols="-2"
prevIdx=-2
currIdx=-2
for n in $currNumbers;
do
  startIdx=$((`echo -n $n | cut -d "," -f 1` - 1))
  endIdx=$((`echo -n $n | cut -d "," -f 2` + 1))
  number=`echo -n $n | cut -d "," -f 3`

  while ! [ x$prevIdx = x ] && [ $prevIdx -lt $startIdx ]
  do
    popFront prevIdx copyPrevSymbols 
    prevSymbols="$prevSymbols:$prevIdx"
    prevIdx=`echo $prevIdx | cut -d "," -f 1`
  done
  if ! [ x$prevIdx = x ] && [ $prevIdx -le $endIdx ]; then
    prevSymbols="$prevSymbols,$number"
  fi

  while ! [ x$currIdx = x ] && [ $currIdx -lt $startIdx ]
  do
    popFront currIdx copyCurrSymbols 
    currSymbols="$currSymbols:$currIdx"
    currIdx=`echo $currIdx | cut -d "," -f 1`
  done
  if ! [ x$currIdx = x ] && [ $currIdx -le $endIdx ]; then
    currSymbols="$currSymbols,$number"
  fi

done

prevSymbols=$prevSymbols:$copyCurrSymbols

for i in `echo $prevSymbols | sed -e "s/:/ /g"`
do
  if echo $i | grep "," > /dev/null ; then
    mult=`echo $i | cut -d "," -f 2- --output-delimiter="*"`
    if ! [ `echo $mult | grep -o "*" | wc -c` -eq 2 ]; then
      continue
    fi
    echo $mult
    answer=`echo "$answer + $mult" | bc`
  fi
done

echo $answer

