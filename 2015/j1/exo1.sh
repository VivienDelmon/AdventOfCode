#! /bin/sh

up=`cat input | sed -e "s/)//g" | wc -c`
down=`cat input | sed -e "s/(//g" | wc -c`
echo $((up - down))
