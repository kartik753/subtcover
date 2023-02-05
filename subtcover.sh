#!/bin/bash
R='\033[0;91m'
G='\033[0;92m'
Y='\033[0;93m'
B='\033[0;94m'
P='\033[0;95m'
S='\033[0;96m'
N='\033[0m'
figlet -f "ANSI Shadow" "   Subtcover" -w 200 | lolcat
echo -e "${G}		                                		Automation by Kartik - @Hackito${N}"
echo
if [ $# -eq 0 ]
  then
    echo "No arguments supplied, kindly type -h for help."
    echo
fi
Help () {
   # Display Help
   echo -e "${P}Kindly use the below options :-${N}"
   echo
   echo -e "${P}-d     Specify the domain to check the result.${N}"
   echo -e "${P}-r     Specify the domain to check the result with http response${N}"
   echo -e "${P}-D     Specify the domain to check deep result.${N}"
   echo -e "${P}-R     Specify the domain to check deep result with http response${N}"
   echo -e "${P}-o     Output file${N}."
   echo
   echo -e "${P}Example:- ./subtcover.sh -d target.com -o target.txt${N}"
}
tcoverd () {
	site="$url"
	file="$url"".txt"
	sub=$(subfinder --silent -d $site | httpx --silent -mc 404 > $file)
	for x in `cat $file`
	do
	  y=$(echo "$x" | sed 's|http://||' | sed 's|https://||')
	  z=$(nslookup $y | grep "canonical name")
	  if (( $(echo ${#z}) != 0 ))
	  then
 	      echo  -e "${R}URL: [$x]${N}"
  	      n=$(echo "$z" | sed 's|^|[++] |')
	      echo -e "${Y}$n${N}"
	      echo ""
	      echo ""
	  fi
	done
	rm $file
}

tcoverr () {
	site="$url"
	file="$url"".txt"
	sub=$(subfinder --silent -d $site | httpx --silent -mc 404 > $file)
	for x in `cat $file`
	do
	  y=$(echo "$x" | sed 's|http://||' | sed 's|https://||')
	  z=$(nslookup $y | grep "canonical name")
	  if (( $(echo ${#z}) != 0 ))
	  then
 	      echo  -e "${R}URL: [$x]${N}"
  	      n=$(echo "$z" | sed 's|^|[++] |')
	      echo -e "${Y}$n${N}"
	      echo -e "${B}------------------------------------------------------------------------------------------------------------------------------${N}"
	      echo -e "${S}$(curl -s $x | sed 's|^|     |')${N}"
	      echo -e "${B}------------------------------------------------------------------------------------------------------------------------------${N}"
	      echo ""
	      echo ""
	  fi
	done
	rm $file
}
tcoverD () {
   site="$url"
   file="$url"".txt"
   amass enum -d $site -silent -o amass.txt
   subfinder -d $site --silent > subfinder.txt
   assetfinder --subs-only $site > assetfinder.txt
   sort -u amass.txt subfinder.txt assetfinder.txt > sub.txt
   sub=$(cat sub.txt | httpx --silent -mc 404 > $file)
   for x in `cat $file`
   do
     y=$(echo "$x" | sed 's|http://||' | sed 's|https://||')
     z=$(nslookup $y | grep "canonical name")
     if (( $(echo ${#z}) != 0 ))
     then
	 echo -e "${R}URL: [$x]${N}"
         n=$(echo "$z" | sed 's|^|[++] |')
         echo -e "${Y}$n${N}"
         echo ""
         echo ""
     fi
   done
   rm $file amass.txt subfinder.txt assetfinder.txt sub.txt
}
tcoverR () {
	site="$url"
	file="$url"".txt"
	amass enum -d $site -silent -o amass.txt
        subfinder -d $site --silent > subfinder.txt
	assetfinder --subs-only $site > assetfinder.txt
        sort -u amass.txt subfinder.txt assetfinder.txt > sub.txt
        sub=$(cat sub.txt | httpx --silent -mc 404 > $file)
	for x in `cat $file`
	do
	  y=$(echo "$x" | sed 's|http://||' | sed 's|https://||')
	  z=$(nslookup $y | grep "canonical name")
	  if (( $(echo ${#z}) != 0 ))
	  then
 	      echo  -e "${R}URL: [$x]${N}"
  	      n=$(echo "$z" | sed 's|^|[++] |')
	      echo -e "${Y}$n${N}"
	      echo -e "${B}------------------------------------------------------------------------------------------------------------------------------${N}"
	      echo -e "${S}$(curl -s $x | sed 's|^|     |')${N}"
	      echo -e "${B}------------------------------------------------------------------------------------------------------------------------------${N}"
	      echo ""
	      echo ""
	  fi
	done
	rm $file amass.txt subfinder.txt assetfinder.txt sub.txt 
}

while getopts d:r:D:R:o::h option
do 
    case "${option}" in
	d) #Result without response
	   url=${OPTARG}
	   tcoverd;;
	r) #Result with response
	   url=${OPTARG}
	   tcoverr;;
	D) #Deep result without response
	   url=${OPTARG}
	   tcoverD;;
	R) #Deep rresult with response
	   url=${OPTARG}
	   tcoverR;;
	o) #output
	   if [ $1 == '-d' ]
	   then
		tcoverd > ${OPTARG}
	   elif [ $1 == '-r' ]
	   then
		tcoverr > ${OPTARG}
	   elif [ $1 == '-D' ]
	   then
		tcoverD > ${OPTARG}
	   else
		tcoverR > ${OPTARG}
	   fi;;
	h) Help;;
       \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
    esac
done
