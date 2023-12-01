#! /bin/sh

sum=0
for i in `cat input | sed -e "s/[a-z]//g" -e "s/^\(.\).*\(.\)$/\1\2/"`
do
    if [ `echo -n $i | wc -c` -eq 1 ]; then
        i="$i$i"
    fi
    sum=$(($sum + $i))
done
echo $sum
