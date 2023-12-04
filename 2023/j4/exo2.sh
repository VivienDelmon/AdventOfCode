#! /bin/sh

answer=0

# sh table
for i in `seq 1 10`
do
    eval c$i=1
done

currCardNb=1
while read line
do
    line=`echo "$line" | sed -e "s/  / 0/g"`
    draw=`echo $line | cut -d "|" -f 2`
    card=`echo $line | cut -d "|" -f 1 | cut -d : -f 2`
    cardNbWin=0
    for n in $card
    do
        if echo $draw | grep $n > /dev/null; then
            cardNbWin=$((cardNbWin + 1))
            eval c$cardNbWin=$((c$cardNbWin + $currCardNb))
        fi
    done
    answer=$((answer + $currCardNb))
    currCardNb=$c1
    for i in `seq 1 9`
    do
        next=$((i + 1))
        eval c$i=\$c$next
    done
    c10=1
done < input

echo $answer
