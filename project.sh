#shahd  qatre  1200431 
#sondos shahin 1200166

i=0
while [ "$i" -eq 0 ] 
do	
	#menu
	echo "  
	
	please enter your choice: 
	
    r) read a dataset from a file.
    p) print the names of the features.
    l) encode a feature using label encoding.
    o) encode a feature using one hot encoding.
    m) applay MinMax scalling.
    s) save the processed dataset.
    e) exit.
         "
	read choice
	case "$choice" in
    	r)
    		#read the data from our file
			echo  "please input the name of the dataset file: "
			read filename
			if [ ! -f "$filename" ]; then
    			echo "the file  $filename does not exist, please try again"
    		else
    			echo "this is your data"
    			cat "$filename"
              	fi    		
              	cp $filename text.txt
    		
    		;;
    	p)
    		#print the name of the features
    		echo "these are your features"
    		
    		
    		c=$(head -n 1 $filename | grep -o ';' | wc -l)
    		for m in $(seq 1 $c)
    		do
    			 sed -n '1p' "$filename" | cut -d';' -f$m
    			
    		done	
    		
    			
    		;;
    	l)
    		#encode using label encoding
    		echo "Please input the name of the categorical feature for label encoding"
    		read feat
    		if grep -q "$feat" $filename; then #to check if the feture exist
    			ind=$(awk -F';' -v column="$feat" '{ for (k=1; k<=NF; k++) if ($k==column) {print k; exit} }' $filename) #to get the index to the feature
    			word=$(cut -d';' -f$ind < $filename)
    			echo $word  | sed 's/^[^ ]* //' >> datal.txt 
    			c=$(cut -d';' -f 1 datal.txt | wc -w)
    			for q in $(seq 1 $c)
    			do
        	      	  	cut -d' ' -f$q  datal.txt >> outl.txt 
    			done	
    			sort outl.txt | uniq >> filel.txt #to take the uniq value and add it to file
    			mapfile -t array < filel.txt      #add the uniq values to an array
    			mapfile -t array2 < outl.txt      #add the all values to an array
    			e=$(wc -l filel.txt | cut -d' ' -f1 )  #get the number of the uniq values
    			r=$(wc -l outl.txt | cut -d' ' -f1)    #get the number of the values
    			e=$(($e-1))
    			r=$(($r-1))
    		
    			for w in $(seq 0 $r);do     #give every value a uniq value
    		
    				for t in $(seq 0 $e);do
    			
    					if [ "${array2[w]}" == "${array[t]}" ]; then
 						array2[w]=$t          
					fi
    				done
    			done  
    			printf "%s\n" "${array2[@]}" > arrayl.txt
    			printf "%s\n" $feat > arrayl0.txt
    			cat arrayl0.txt arrayl.txt > 2array.txt
    			mapfile -t array1 < 2array.txt
    			while read line; do
                               printf '%s\n' ";$line;"  >> partenc.txt
			done <  2array.txt
    			
    			
    			
    			cut -f1-$(($ind-1)) -d';' text.txt  >part1.txt
    			p=$(head -n 1 $filename | grep -o ';' | wc -l)
    			s=$(($ind+1))
    			cut -f$s-$p -d';' text.txt >part2.txt
    			
    			paste -d';' part1.txt  partenc.txt  > te.txt
    			paste -d';' te.txt  part2.txt | sed 's/  */;/g; s/;;*/;/g ;s/^;//' > text.txt 
			
                else 
                	echo "The name of categorical feature is wrong"
                fi	
    		;;
    		
    	o)
    		#encode using one-hot encoding
    		echo "Please input the name of the categorical feature for one-hot encoding"
    		read feat
    		if grep -q "$feat" $filename; then
    			ind=$(awk -F';' -v column="$feat" '{ for (k=1; k<=NF; k++) if ($k==column) {print k; exit} }' $filename)  #get the index for the feature 
    			word=$(cut -d';' -f$ind < $filename)
    			echo $word  | sed 's/^[^ ]* //' >> datao.txt 
    			c=$(cut -d';' -f 1 datao.txt | wc -w)
    			for q in $(seq 1 $c)
    			do
        	      	  	cut -d' ' -f$q  datao.txt >> outo.txt 
    			done	
    			sort outo.txt | uniq >> fileo.txt
    			mapfile -t array < fileo.txt       #store the values from file to array
    			mapfile -t array0 < outo.txt       #store the values from file to array
    			o=$(cut -d';' -f 1 fileo.txt | wc -w)
    			o=$((o-1))
    			u=$(cut -d';' -f 1 outo.txt | wc -w)
    			u=$((u-1))
    			
    			for w in $(seq 0 $u);do           
    		
    				for t in $(seq 0 $o);do
    			
    					if [ "${array0[w]}" == "${array[t]}" ]; then
 						echo 1 >> datoo.txt
 					
 					else 
 						echo 0 >> datoo.txt
 						
					fi
    				done
    			done 
    			o=$((o+1))
    			line_counter=0
			while read line; do
  
  				line_counter=$((line_counter+1))
                               printf '%s' "$line;"  >> lastone.txt

 				 if [ $((line_counter )) = $o  ]; then
   					 printf '\n'   >> lastone.txt   
   					 line_counter=0
 				 fi               
			done < datoo.txt
			while read line; do
  
                               printf '%s' "$line;" >> uniq.txt

 				  
			done < fileo.txt
			
			while read line; do
                               printf '\n'   >>uniq.txt
                               printf '%s' "$line" >>uniq.txt
			done < lastone.txt
			awk -F';' -v col=$ind '{$col=""; print}' text.txt   | sed 's/  */;/g; s/;;*/;/g ;s/^;//' > te.txt  #delete the coloumn 
			paste -d';' te.txt uniq.txt  | sed 's/;;*/;/g;' > text.txt                                  
 
    			
				    			    	    			
                else 
                	echo "The name of categorical feature is wrong"
                fi	
                
    		;;
    
    		
    	m)	#MinMax scalling
    	echo "Please input the name of the feature to be scaled"
    	read feat
    		if grep -q "$feat" text.txt; then
 			ind=$(awk -F';' -v column="$feat" '{ for (k=1; k<=NF; k++) if ($k==column) {print k; exit} }' text.txt)
    			word=$(cut -d';' -f$ind < text.txt)
    			echo $word  | sed 's/^[^ ]* //' >> datam.txt 
    			first=$(head -n 1 datam.txt | cut -d' ' -f1)
    			if [[ $first =~ ^[[:alpha:]]+$ ]];then
    				echo "“this feature is categorical feature and must be encoded first"	
    			else	
    				c=$(cut -d';' -f 1 datam.txt | wc -w)
   				for q in $(seq 1 $c)
   				do
        	      	  		cut -d' ' -f$q  datam.txt >> outm.txt 
    				done	
    				sort outm.txt >> filem.txt
    				min=$(sed -n '1p' filem.txt)
    				max=$(tail -1 filem.txt)
    				echo "min valu" $min
    				echo "max valu" $max
    				m=$(($max-$min))
    				mapfile -t arraym < outm.txt
    				e=$(wc -l outm.txt | cut -d' ' -f1)
    				e=$(($e-1))
    				for t in $(seq 0 $e);do
    					b=$((${arraym[$t]}-$min))
    					xi=$(awk "BEGIN {print $b/$m}")
					echo $xi   "to"  ${arraym[$t]}		    			
    				done
    			fi	
               	 else 
                	echo "The name of categorical feature is wrong"               		
                 fi	
    		;;
    	s)
    		#save the dataset
    		echo "please enter the name of file"
    		read file
    	        cp text.txt  $file	
    		echo "the data was saved"
    		
    		
    	
    		;;
    	e)
    		#exit the  program
    		
    		if [  -f "$file" ]; then
    			echo "are you sure you want to exit?"
    			read answer
    			if [[ "$answer" -eq "yes" ]]; then
    				echo "end of program"
    				i=1
    			fi
    					
    		else
    			echo "the processed dataset is not saved , are you sure you want to exit "
    		        read answer
    			if [[ "$answer" -eq "yes" ]]; then
    				i=0
    			fi
    		fi	
    		;;
    		#default case	
    	*)
    		echo "invalid choice, please choose again"
    		;;	
	esac
		
done
