#!/bin/bash

COUNT=0

for i in $(cat /home/ayeka/Desktop/TCGAprostate/ImportantFiles/part1.csv)
	do cd /home/ayeka/Desktop/TCGAprostate/genes
  	   COUNT=$((COUNT+1))
           echo $(ls | grep -ie $i )	   
	   echo $COUNT
	   echo $(awk "NR== (echo $COUNT)" /home/ayeka/Desktop/TCGAprostate/ImportantFiles/newpart2.csv)
	   
	   mv $(ls | grep -ie $i)  /home/ayeka/Desktop/TCGAprostate/genes/$(echo $(awk "NR== (echo $COUNT)" /home/ayeka/Desktop/TCGAprostate/ImportantFiles/newpart2.csv))_rnaNormalized.txt
	   
done

exit 0
