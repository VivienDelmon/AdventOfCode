#! /bin/sh

answer=0

while read line
do
    line=`echo "$line" | sed -e "s/  / 0/g"`
    draw=`echo $line | cut -d "|" -f 2` 
    card=`echo $line | cut -d "|" -f 1 | cut -d : -f 2`
    cardPoints=0
    for n in $card
    do
        if echo $draw | grep $n > /dev/null; then
            if [ $cardPoints -eq 0 ]; then
                cardPoints=1
            else
                cardPoints=$((cardPoints * 2))
            fi
        fi
    done
    answer=$((answer + cardPoints))
done < input

echo $answer
