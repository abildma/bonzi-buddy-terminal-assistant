#!/bin/zsh

# Bonzi Buddy - A friendly terminal assistant without the spyware
# Usage: bonzi.sh [command]
# Example: bonzi.sh sudo apt opdate

# Set colors for a more friendly appearance
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the command explanations
source "$SCRIPT_DIR/command_explanations.sh"

# Display a welcome message
echo -e "${CYAN}Use subo to automatically use sudo and bonzi${NC}"

# Get the command from arguments
COMMAND="$*"

# Function to detect and correct command typos
detect_and_correct() {
    local cmd="$1"
    local typo=""
    local suggestion=""
    local corrected=""
    
    # Special handling for sudo typos
    if [[ "$cmd" =~ ^[[:space:]]*sudo[o]+ ]]; then
        corrected="${cmd//sudoo/sudo}"
        echo "$corrected:sudo"
        return 0
    fi
    
    # Check for sudo apt command typos
    if [[ "$cmd" =~ sudo[[:space:]]+apt[[:space:]]+([[:alnum:]\-]+) ]]; then
        typo=${BASH_REMATCH[1]}
        cmd_prefix="sudo apt"
    # Check for regular apt command typos
    elif [[ "$cmd" =~ apt[[:space:]]+([[:alnum:]\-]+) ]]; then
        typo=${BASH_REMATCH[1]}
        cmd_prefix="apt"
    else
        # No apt command found
        typo=""
        cmd_prefix=""
    fi
    
    # Process apt command typos if found
    if [ -n "$typo" ]; then
        case "$typo" in
            # Common apt update typos
            "updote"|"updat"|"upadte"|"opdate"|"uppdate"|"updte"|"updaet"|"updae"|"updete"|"updait"|"upate"|"upd"|"update-") suggestion="update";;
            
            # apt upgrade typos
            "upgrad"|"upgrage"|"upgrde"|"upgarde"|"uprgade"|"uppgrade"|"upgread"|"upgrdae"|"upgad"|"upgrade-") suggestion="upgrade";;
            
            # apt install typos
            "instlal"|"instal"|"instll"|"insatll"|"isntall"|"intsall"|"instaall"|"intsall"|"isntall"|"isntal"|"innstall"|"installl"|"nistall"|"install-") suggestion="install";;
            
            # apt remove typos
            "remov"|"remeve"|"removr"|"reomve"|"rmove"|"removee"|"romove"|"remove-") suggestion="remove";;
            
            # apt autoremove typos
            "autoremov"|"autoremeve"|"auto-remove"|"autremove"|"autoremoev"|"auto-remov"|"autoremove-") suggestion="autoremove";;
            
            # apt search typos
            "serach"|"serch"|"searh"|"seach"|"scearch"|"seacrh"|"srch"|"sear"|"searhc"|"search-") suggestion="search";;
            
            # apt show typos
            "shwo"|"shw"|"sho"|"shoow"|"sohw"|"shoew"|"sh0w"|"show-") suggestion="show";;
            
            # apt list typos
            "lits"|"lit"|"lis"|"lst"|"ligt"|"lsit"|"loist"|"lisst"|"lest"|"lits"|"list-") suggestion="list";;
            
            # apt clean typos
            "clena"|"cleana"|"clen"|"cleean"|"cleann"|"claen"|"celan"|"clean-") suggestion="clean";;
            
            # apt cache typos
            "cach"|"cahe"|"cche"|"caceh"|"cachee"|"cahce"|"cashe"|"caches"|"cache-") suggestion="cache";;
            
            # apt full-upgrade typos
            "full-updat"|"full-upgrde"|"full-upgrage"|"fullupgrade"|"full-upgrae"|"fullupdate"|"full-upgraed"|"full-upgradde"|"full-upgrade-") suggestion="full-upgrade";;
            
            # apt dist-upgrade typos
            "dist-updat"|"dist-upgrde"|"dist-upgrage"|"distupgrade"|"dis-upgrade"|"dist-upgrd"|"distupdate"|"dist-upgrae"|"dist-upgraed"|"dist-upgradde"|"dist-upgrade-") suggestion="dist-upgrade";;
            
            # Other apt commands
            "source"|"sourc"|"sorce"|"suorce"|"soruce") suggestion="source";;
            "deppend"|"deepend"|"depen"|"dpend"|"depned") suggestion="depends";;
            "editsorces"|"editsources"|"edit-sourc"|"editsource"|"editsourcces") suggestion="edit-sources";;
            "edditsources"|"edsources") suggestion="edit-sources";;
            "fux"|"fxi"|"fis"|"fixe"|"fixx") suggestion="fix";;
            "saisfy"|"sadisfy"|"satisfie"|"satisgy") suggestion="satisfy";;
            "checkk"|"cehck"|"cheeck"|"chek") suggestion="check";;
            "auto-cleen"|"autoclena"|"autoclean"|"autoc") suggestion="autoclean";;
        esac
        
        if [ -n "$suggestion" ]; then
            # Create proper replacement pattern based on detected prefix
            search_pattern="$cmd_prefix $typo"
            replace_pattern="$cmd_prefix $suggestion"
            corrected="${cmd//$search_pattern/$replace_pattern}"
            echo "$corrected:$suggestion"
            return 0
        fi
    fi
    
    # Check for filesystem navigation typos
    if [[ "$cmd" == *"cd.."* ]]; then echo "${cmd//cd../cd ..}:cd .."; return 0; fi
    if [[ "$cmd" == *"cd."* ]]; then echo "${cmd//cd./cd .}:cd ."; return 0; fi
    if [[ "$cmd" == *"cd/"* ]]; then echo "${cmd//cd\//cd \/}:cd /"; return 0; fi
    if [[ "$cmd" == *"cd~"* ]]; then echo "${cmd//cd~/cd ~}:cd ~"; return 0; fi
    if [[ "$cmd" == *"cd-"* ]]; then echo "${cmd//cd-/cd -}:cd -"; return 0; fi
    if [[ "$cmd" == *"cddir"* ]]; then echo "${cmd//cddir/cd dir}:cd dir"; return 0; fi
    
    # ls command typos
    if [[ "$cmd" == *"sl"* ]]; then echo "${cmd//sl/ls}:ls"; return 0; fi
    if [[ "$cmd" == *"lss"* ]]; then echo "${cmd//lss/ls}:ls"; return 0; fi
    if [[ "$cmd" == *"lls"* ]]; then echo "${cmd//lls/ls}:ls"; return 0; fi
    if [[ "$cmd" == *"ls-la"* ]]; then echo "${cmd//ls-la/ls -la}:ls -la"; return 0; fi
    if [[ "$cmd" == *"ls-a"* ]]; then echo "${cmd//ls-a/ls -a}:ls -a"; return 0; fi
    if [[ "$cmd" == *"ls-l"* ]]; then echo "${cmd//ls-l/ls -l}:ls -l"; return 0; fi
    if [[ "$cmd" == *"ls-h"* ]]; then echo "${cmd//ls-h/ls -h}:ls -h"; return 0; fi
    if [[ "$cmd" == *"ls-al"* ]]; then echo "${cmd//ls-al/ls -al}:ls -al"; return 0; fi
    if [[ "$cmd" == *"ll"* && ! "$cmd" == *"ll="* ]]; then echo "${cmd//ll/ls -la}:ls -la"; return 0; fi
    if [[ "$cmd" == *"l"* && "$cmd" =~ ^[[:space:]]*l$ ]]; then echo "${cmd//l/ls}:ls"; return 0; fi
    if [[ "$cmd" == *"lll"* ]]; then echo "${cmd//lll/ls -la}:ls -la"; return 0; fi
    if [[ "$cmd" == *"lla"* ]]; then echo "${cmd//lla/ls -la}:ls -la"; return 0; fi
    
    # File manipulation typos
    if [[ "$cmd" == *"cta"* ]]; then echo "${cmd//cta/cat}:cat"; return 0; fi
    if [[ "$cmd" == *"cay"* ]]; then echo "${cmd//cay/cat}:cat"; return 0; fi
    if [[ "$cmd" == *"caet"* ]]; then echo "${cmd//caet/cat}:cat"; return 0; fi
    if [[ "$cmd" == *"ccat"* ]]; then echo "${cmd//ccat/cat}:cat"; return 0; fi
    if [[ "$cmd" == *"ct"* && ! "$cmd" == *"=ct"* && ! "$cmd" == *"ct="* && ! "$cmd" == *"ctr"* ]]; then echo "${cmd//ct/cat}:cat"; return 0; fi
    
    if [[ "$cmd" == *"mkidr"* ]]; then echo "${cmd//mkidr/mkdir}:mkdir"; return 0; fi
    if [[ "$cmd" == *"mkdr"* ]]; then echo "${cmd//mkdr/mkdir}:mkdir"; return 0; fi
    if [[ "$cmd" == *"mdir"* ]]; then echo "${cmd//mdir/mkdir}:mkdir"; return 0; fi
    if [[ "$cmd" == *"mdkir"* ]]; then echo "${cmd//mdkir/mkdir}:mkdir"; return 0; fi
    if [[ "$cmd" == *"mkd"* && ! "$cmd" == *"mkd="* ]]; then echo "${cmd//mkd/mkdir}:mkdir"; return 0; fi
    
    if [[ "$cmd" == *"touhc"* ]]; then echo "${cmd//touhc/touch}:touch"; return 0; fi
    if [[ "$cmd" == *"toch"* ]]; then echo "${cmd//toch/touch}:touch"; return 0; fi
    if [[ "$cmd" == *"tocuh"* ]]; then echo "${cmd//tocuh/touch}:touch"; return 0; fi
    if [[ "$cmd" == *"tuoch"* ]]; then echo "${cmd//tuoch/touch}:touch"; return 0; fi
    if [[ "$cmd" == *"tuch"* ]]; then echo "${cmd//tuch/touch}:touch"; return 0; fi
    
    if [[ "$cmd" == *"rm-rf"* ]]; then echo "${cmd//rm-rf/rm -rf}:rm -rf"; return 0; fi
    if [[ "$cmd" == *"rm-r"* ]]; then echo "${cmd//rm-r/rm -r}:rm -r"; return 0; fi
    if [[ "$cmd" == *"rm-f"* ]]; then echo "${cmd//rm-f/rm -f}:rm -f"; return 0; fi
    
    if [[ "$cmd" == *"cp-r"* ]]; then echo "${cmd//cp-r/cp -r}:cp -r"; return 0; fi
    if [[ "$cmd" == *"cp-f"* ]]; then echo "${cmd//cp-f/cp -f}:cp -f"; return 0; fi
    
    if [[ "$cmd" == *"mv-f"* ]]; then echo "${cmd//mv-f/mv -f}:mv -f"; return 0; fi
    
    # Text editors typos
    if [[ "$cmd" == *"nao"* ]]; then echo "${cmd//nao/nano}:nano"; return 0; fi
    if [[ "$cmd" == *"nan"* && ! "$cmd" == *"nan="* ]]; then echo "${cmd//nan/nano}:nano"; return 0; fi
    if [[ "$cmd" == *"nnao"* ]]; then echo "${cmd//nnao/nano}:nano"; return 0; fi
    if [[ "$cmd" == *"naon"* ]]; then echo "${cmd//naon/nano}:nano"; return 0; fi
    
    if [[ "$cmd" == *"vmi"* ]]; then echo "${cmd//vmi/vim}:vim"; return 0; fi
    if [[ "$cmd" == *"vom"* ]]; then echo "${cmd//vom/vim}:vim"; return 0; fi
    if [[ "$cmd" == *"vi,"* ]]; then echo "${cmd//vi,/vim}:vim"; return 0; fi
    
    # Search and text processing tools typos
    if [[ "$cmd" == *"grpe"* ]]; then echo "${cmd//grpe/grep}:grep"; return 0; fi
    if [[ "$cmd" == *"grp"* && ! "$cmd" == *"grp="* ]]; then echo "${cmd//grp/grep}:grep"; return 0; fi
    if [[ "$cmd" == *"gerp"* ]]; then echo "${cmd//gerp/grep}:grep"; return 0; fi
    if [[ "$cmd" == *"gre"* && ! "$cmd" == *"gre="* && ! "$cmd" == *"green"* ]]; then echo "${cmd//gre/grep}:grep"; return 0; fi
    if [[ "$cmd" == *"grepp"* ]]; then echo "${cmd//grepp/grep}:grep"; return 0; fi
    if [[ "$cmd" == *"grep-i"* ]]; then echo "${cmd//grep-i/grep -i}:grep -i"; return 0; fi
    if [[ "$cmd" == *"grep-v"* ]]; then echo "${cmd//grep-v/grep -v}:grep -v"; return 0; fi
    if [[ "$cmd" == *"grep-r"* ]]; then echo "${cmd//grep-r/grep -r}:grep -r"; return 0; fi
    if [[ "$cmd" == *"grep-a"* ]]; then echo "${cmd//grep-a/grep -a}:grep -a"; return 0; fi
    if [[ "$cmd" == *"grep-n"* ]]; then echo "${cmd//grep-n/grep -n}:grep -n"; return 0; fi
    
    if [[ "$cmd" == *"fin"* && ! "$cmd" == *"fin="* && ! "$cmd" == *"final"* && ! "$cmd" == *"finance"* ]]; then echo "${cmd//fin/find}:find"; return 0; fi
    if [[ "$cmd" == *"fidn"* ]]; then echo "${cmd//fidn/find}:find"; return 0; fi
    if [[ "$cmd" == *"finnd"* ]]; then echo "${cmd//finnd/find}:find"; return 0; fi
    if [[ "$cmd" == *"finde"* ]]; then echo "${cmd//finde/find}:find"; return 0; fi
    if [[ "$cmd" == *"fnid"* ]]; then echo "${cmd//fnid/find}:find"; return 0; fi
    if [[ "$cmd" == *"find-name"* ]]; then echo "${cmd//find-name/find -name}:find -name"; return 0; fi
    if [[ "$cmd" == *"find-type"* ]]; then echo "${cmd//find-type/find -type}:find -type"; return 0; fi
    
    if [[ "$cmd" == *"aqw"* ]]; then echo "${cmd//aqw/awk}:awk"; return 0; fi
    if [[ "$cmd" == *"akw"* ]]; then echo "${cmd//akw/awk}:awk"; return 0; fi
    if [[ "$cmd" == *"wak"* ]]; then echo "${cmd//wak/awk}:awk"; return 0; fi
    
    if [[ "$cmd" == *"see"* && ! "$cmd" == *"seen"* && ! "$cmd" == *"seed"* && "$cmd" =~ ^[[:space:]]*see$ ]]; then echo "${cmd//see/sed}:sed"; return 0; fi
    if [[ "$cmd" == *"sed-i"* ]]; then echo "${cmd//sed-i/sed -i}:sed -i"; return 0; fi
    if [[ "$cmd" == *"sed-e"* ]]; then echo "${cmd//sed-e/sed -e}:sed -e"; return 0; fi
    
    if [[ "$cmd" == *"xagrs"* ]]; then echo "${cmd//xagrs/xargs}:xargs"; return 0; fi
    if [[ "$cmd" == *"xarg"* && ! "$cmd" == *"xarg="* ]]; then echo "${cmd//xarg/xargs}:xargs"; return 0; fi
    if [[ "$cmd" == *"zargs"* ]]; then echo "${cmd//zargs/xargs}:xargs"; return 0; fi
    
    # System information commands
    if [[ "$cmd" == *"lsbk"* ]]; then echo "${cmd//lsbk/lsblk}:lsblk"; return 0; fi
    if [[ "$cmd" == *"lsblkk"* ]]; then echo "${cmd//lsblkk/lsblk}:lsblk"; return 0; fi
    if [[ "$cmd" == *"lsblck"* ]]; then echo "${cmd//lsblck/lsblk}:lsblk"; return 0; fi
    if [[ "$cmd" == *"lsb"* && ! "$cmd" == *"lsb="* && ! "$cmd" == *"lsb_release"* && ! "$cmd" == *"lsbk"* ]]; then echo "${cmd//lsb/lsblk}:lsblk"; return 0; fi
    
    if [[ "$cmd" == *"dff"* ]]; then echo "${cmd//dff/df}:df"; return 0; fi
    if [[ "$cmd" == *"df-h"* ]]; then echo "${cmd//df-h/df -h}:df -h"; return 0; fi
    if [[ "$cmd" == *"dfh"* ]]; then echo "${cmd//dfh/df -h}:df -h"; return 0; fi
    
    if [[ "$cmd" == *"ddu"* ]]; then echo "${cmd//ddu/du}:du"; return 0; fi
    if [[ "$cmd" == *"du-h"* ]]; then echo "${cmd//du-h/du -h}:du -h"; return 0; fi
    if [[ "$cmd" == *"du-s"* ]]; then echo "${cmd//du-s/du -s}:du -s"; return 0; fi
    if [[ "$cmd" == *"du-sh"* ]]; then echo "${cmd//du-sh/du -sh}:du -sh"; return 0; fi
    
    if [[ "$cmd" == *"frre"* ]]; then echo "${cmd//frre/free}:free"; return 0; fi
    if [[ "$cmd" == *"fre"* && ! "$cmd" == *"fre="* && "$cmd" =~ ^[[:space:]]*fre$ ]]; then echo "${cmd//fre/free}:free"; return 0; fi
    if [[ "$cmd" == *"free-h"* ]]; then echo "${cmd//free-h/free -h}:free -h"; return 0; fi
    if [[ "$cmd" == *"free-m"* ]]; then echo "${cmd//free-m/free -m}:free -m"; return 0; fi
    
    if [[ "$cmd" == *"toppp"* ]]; then echo "${cmd//toppp/top}:top"; return 0; fi
    if [[ "$cmd" == *"otp"* ]]; then echo "${cmd//otp/top}:top"; return 0; fi
    
    if [[ "$cmd" == *"htpo"* ]]; then echo "${cmd//htpo/htop}:htop"; return 0; fi
    if [[ "$cmd" == *"htoop"* ]]; then echo "${cmd//htoop/htop}:htop"; return 0; fi
    if [[ "$cmd" == *"thop"* ]]; then echo "${cmd//thop/htop}:htop"; return 0; fi
    
    if [[ "$cmd" == *"uanem"* ]]; then echo "${cmd//uanem/uname}:uname"; return 0; fi
    if [[ "$cmd" == *"uname-a"* ]]; then echo "${cmd//uname-a/uname -a}:uname -a"; return 0; fi
    if [[ "$cmd" == *"uname-r"* ]]; then echo "${cmd//uname-r/uname -r}:uname -r"; return 0; fi
    
    if [[ "$cmd" == *"lscpu="* ]]; then echo "${cmd//lscpu=/lscpu}:lscpu"; return 0; fi
    if [[ "$cmd" == *"lsusbb"* ]]; then echo "${cmd//lsusbb/lsusb}:lsusb"; return 0; fi
    if [[ "$cmd" == *"lspcci"* ]]; then echo "${cmd//lspcci/lspci}:lspci"; return 0; fi
    if [[ "$cmd" == *"lcpci"* ]]; then echo "${cmd//lcpci/lspci}:lspci"; return 0; fi
    
    # Process management typos
    if [[ "$cmd" == *"pss"* && ! "$cmd" == *"pss="* ]]; then echo "${cmd//pss/ps}:ps"; return 0; fi
    if [[ "$cmd" == *"ps-ef"* ]]; then echo "${cmd//ps-ef/ps -ef}:ps -ef"; return 0; fi
    if [[ "$cmd" == *"ps-aux"* ]]; then echo "${cmd//ps-aux/ps aux}:ps aux"; return 0; fi
    
    if [[ "$cmd" == *"kil"* && ! "$cmd" == *"kil="* ]]; then echo "${cmd//kil/kill}:kill"; return 0; fi
    if [[ "$cmd" == *"klil"* ]]; then echo "${cmd//klil/kill}:kill"; return 0; fi
    if [[ "$cmd" == *"kill-9"* ]]; then echo "${cmd//kill-9/kill -9}:kill -9"; return 0; fi
    
    if [[ "$cmd" == *"htop"* && ! "$cmd" == *"htop="* ]]; then echo "${cmd//htpo/htop}:htop"; return 0; fi
    
    # Git command typos
    if [[ "$cmd" == *"gti"* ]]; then echo "${cmd//gti/git}:git"; return 0; fi
    if [[ "$cmd" == *"gi"* && ! "$cmd" == *"gi="* ]]; then echo "${cmd//gi/git}:git"; return 0; fi
    
    if [[ "$cmd" == *"git sttaus"* ]]; then echo "${cmd//git sttaus/git status}:git status"; return 0; fi
    if [[ "$cmd" == *"git stats"* ]]; then echo "${cmd//git stats/git status}:git status"; return 0; fi
    if [[ "$cmd" == *"git statu"* ]]; then echo "${cmd//git statu/git status}:git status"; return 0; fi
    if [[ "$cmd" == *"git statsu"* ]]; then echo "${cmd//git statsu/git status}:git status"; return 0; fi
    if [[ "$cmd" == *"git stat"* && ! "$cmd" == *"git stat="* ]]; then echo "${cmd//git stat/git status}:git status"; return 0; fi
    if [[ "$cmd" == *"git ststus"* ]]; then echo "${cmd//git ststus/git status}:git status"; return 0; fi
    if [[ "$cmd" == *"gi status"* ]]; then echo "${cmd//gi status/git status}:git status"; return 0; fi
    
    if [[ "$cmd" == *"git comit"* ]]; then echo "${cmd//git comit/git commit}:git commit"; return 0; fi
    if [[ "$cmd" == *"git commt"* ]]; then echo "${cmd//git commt/git commit}:git commit"; return 0; fi
    if [[ "$cmd" == *"git cmmit"* ]]; then echo "${cmd//git cmmit/git commit}:git commit"; return 0; fi
    if [[ "$cmd" == *"git cmit"* ]]; then echo "${cmd//git cmit/git commit}:git commit"; return 0; fi
    if [[ "$cmd" == *"git comitt"* ]]; then echo "${cmd//git comitt/git commit}:git commit"; return 0; fi
    if [[ "$cmd" == *"git comimt"* ]]; then echo "${cmd//git comimt/git commit}:git commit"; return 0; fi
    if [[ "$cmd" == *"git comm"* && ! "$cmd" == *"git comm="* ]]; then echo "${cmd//git comm/git commit}:git commit"; return 0; fi
    
    if [[ "$cmd" == *"git psh"* ]]; then echo "${cmd//git psh/git push}:git push"; return 0; fi
    if [[ "$cmd" == *"git puhs"* ]]; then echo "${cmd//git puhs/git push}:git push"; return 0; fi
    if [[ "$cmd" == *"git psuh"* ]]; then echo "${cmd//git psuh/git push}:git push"; return 0; fi
    if [[ "$cmd" == *"git pus"* && ! "$cmd" == *"git pus="* ]]; then echo "${cmd//git pus/git push}:git push"; return 0; fi
    if [[ "$cmd" == *"git ush"* ]]; then echo "${cmd//git ush/git push}:git push"; return 0; fi
    if [[ "$cmd" == *"git puh"* ]]; then echo "${cmd//git puh/git push}:git push"; return 0; fi
    
    if [[ "$cmd" == *"git pll"* ]]; then echo "${cmd//git pll/git pull}:git pull"; return 0; fi
    if [[ "$cmd" == *"git plul"* ]]; then echo "${cmd//git plul/git pull}:git pull"; return 0; fi
    if [[ "$cmd" == *"git pul"* && ! "$cmd" == *"git pul="* ]]; then echo "${cmd//git pul/git pull}:git pull"; return 0; fi
    if [[ "$cmd" == *"git pulll"* ]]; then echo "${cmd//git pulll/git pull}:git pull"; return 0; fi
    
    if [[ "$cmd" == *"git clon"* ]]; then echo "${cmd//git clon/git clone}:git clone"; return 0; fi
    if [[ "$cmd" == *"git cloen"* ]]; then echo "${cmd//git cloen/git clone}:git clone"; return 0; fi
    if [[ "$cmd" == *"git cloene"* ]]; then echo "${cmd//git cloene/git clone}:git clone"; return 0; fi
    if [[ "$cmd" == *"git colne"* ]]; then echo "${cmd//git colne/git clone}:git clone"; return 0; fi
    
    # Network tools typos
    if [[ "$cmd" == *"pping"* ]]; then echo "${cmd//pping/ping}:ping"; return 0; fi
    if [[ "$cmd" == *"pign"* ]]; then echo "${cmd//pign/ping}:ping"; return 0; fi
    if [[ "$cmd" == *"pinng"* ]]; then echo "${cmd//pinng/ping}:ping"; return 0; fi
    if [[ "$cmd" == *"ping-c"* ]]; then echo "${cmd//ping-c/ping -c}:ping -c"; return 0; fi
    
    if [[ "$cmd" == *"netstatt"* ]]; then echo "${cmd//netstatt/netstat}:netstat"; return 0; fi
    if [[ "$cmd" == *"netsat"* ]]; then echo "${cmd//netsat/netstat}:netstat"; return 0; fi
    if [[ "$cmd" == *"netsatt"* ]]; then echo "${cmd//netsatt/netstat}:netstat"; return 0; fi
    if [[ "$cmd" == *"netstat-tulpn"* ]]; then echo "${cmd//netstat-tulpn/netstat -tulpn}:netstat -tulpn"; return 0; fi
    if [[ "$cmd" == *"netstat-an"* ]]; then echo "${cmd//netstat-an/netstat -an}:netstat -an"; return 0; fi
    
    if [[ "$cmd" == *"ipcnofig"* ]]; then echo "${cmd//ipcnofig/ipconfig}:ipconfig"; return 0; fi
    if [[ "$cmd" == *"ipconifg"* ]]; then echo "${cmd//ipconifg/ipconfig}:ipconfig"; return 0; fi
    
    if [[ "$cmd" == *"ifcnofig"* ]]; then echo "${cmd//ifcnofig/ifconfig}:ifconfig"; return 0; fi
    if [[ "$cmd" == *"ifconifg"* ]]; then echo "${cmd//ifconifg/ifconfig}:ifconfig"; return 0; fi
    if [[ "$cmd" == *"ifconfg"* ]]; then echo "${cmd//ifconfg/ifconfig}:ifconfig"; return 0; fi
    if [[ "$cmd" == *"ifcfg"* && ! "$cmd" == *"ifcfg="* ]]; then echo "${cmd//ifcfg/ifconfig}:ifconfig"; return 0; fi
    
    if [[ "$cmd" == *"scp-r"* ]]; then echo "${cmd//scp-r/scp -r}:scp -r"; return 0; fi
    if [[ "$cmd" == *"scp-p"* ]]; then echo "${cmd//scp-p/scp -p}:scp -p"; return 0; fi
    
    if [[ "$cmd" == *"ipaddr"* && ! "$cmd" == *"ip addr"* ]]; then echo "${cmd//ipaddr/ip addr}:ip addr"; return 0; fi
    if [[ "$cmd" == *"ip adder"* ]]; then echo "${cmd//ip adder/ip addr}:ip addr"; return 0; fi
    if [[ "$cmd" == *"ip adress"* ]]; then echo "${cmd//ip adress/ip address}:ip address"; return 0; fi
    if [[ "$cmd" == *"ipaddress"* ]]; then echo "${cmd//ipaddress/ip address}:ip address"; return 0; fi
    
    if [[ "$cmd" == *"nmpa"* ]]; then echo "${cmd//nmpa/nmap}:nmap"; return 0; fi
    if [[ "$cmd" == *"napm"* ]]; then echo "${cmd//napm/nmap}:nmap"; return 0; fi
    if [[ "$cmd" == *"namp"* ]]; then echo "${cmd//namp/nmap}:nmap"; return 0; fi
    if [[ "$cmd" == *"nmap-sS"* ]]; then echo "${cmd//nmap-sS/nmap -sS}:nmap -sS"; return 0; fi
    if [[ "$cmd" == *"nmap-sV"* ]]; then echo "${cmd//nmap-sV/nmap -sV}:nmap -sV"; return 0; fi
    if [[ "$cmd" == *"nmap-p"* ]]; then echo "${cmd//nmap-p/nmap -p}:nmap -p"; return 0; fi
    
    if [[ "$cmd" == *"tracerout"* ]]; then echo "${cmd//tracerout/traceroute}:traceroute"; return 0; fi
    if [[ "$cmd" == *"tracerote"* ]]; then echo "${cmd//tracerote/traceroute}:traceroute"; return 0; fi
    if [[ "$cmd" == *"tracrout"* ]]; then echo "${cmd//tracrout/traceroute}:traceroute"; return 0; fi
    
    if [[ "$cmd" == *"shh"* && ! "$cmd" == *"shh="* && ! "$cmd" == *"shht"* ]]; then echo "${cmd//shh/ssh}:ssh"; return 0; fi
    if [[ "$cmd" == *"sssh"* ]]; then echo "${cmd//sssh/ssh}:ssh"; return 0; fi
    if [[ "$cmd" == *"sss"* && ! "$cmd" == *"sss="* ]]; then echo "${cmd//sss/ssh}:ssh"; return 0; fi
    
    if [[ "$cmd" == *"dirn"* && ! "$cmd" == *"dirn="* ]]; then echo "${cmd//dirn/dig}:dig"; return 0; fi
    if [[ "$cmd" == *"dgi"* ]]; then echo "${cmd//dgi/dig}:dig"; return 0; fi
    
    if [[ "$cmd" == *"nslooku"* ]]; then echo "${cmd//nslooku/nslookup}:nslookup"; return 0; fi
    if [[ "$cmd" == *"nslokup"* ]]; then echo "${cmd//nslokup/nslookup}:nslookup"; return 0; fi
    if [[ "$cmd" == *"nsoolkup"* ]]; then echo "${cmd//nsoolkup/nslookup}:nslookup"; return 0; fi
    
    if [[ "$cmd" == *"hostnaem"* ]]; then echo "${cmd//hostnaem/hostname}:hostname"; return 0; fi
    if [[ "$cmd" == *"hstname"* ]]; then echo "${cmd//hstname/hostname}:hostname"; return 0; fi
    
    # Filesystem management tools
    if [[ "$cmd" == *"chown-R"* ]]; then echo "${cmd//chown-R/chown -R}:chown -R"; return 0; fi
    if [[ "$cmd" == *"chownr"* ]]; then echo "${cmd//chownr/chown -r}:chown -r"; return 0; fi
    if [[ "$cmd" == *"chmdo"* ]]; then echo "${cmd//chmdo/chmod}:chmod"; return 0; fi
    if [[ "$cmd" == *"chomd"* ]]; then echo "${cmd//chomd/chmod}:chmod"; return 0; fi
    if [[ "$cmd" == *"chmdo-R"* ]]; then echo "${cmd//chmdo-R/chmod -R}:chmod -R"; return 0; fi
    if [[ "$cmd" == *"chmod-r"* ]]; then echo "${cmd//chmod-r/chmod -r}:chmod -r"; return 0; fi
    
    if [[ "$cmd" == *"mknod"* && ! "$cmd" == *"mknod="* ]]; then echo "${cmd//mknod/mount}:mount"; return 0; fi
    if [[ "$cmd" == *"unmunt"* ]]; then echo "${cmd//unmunt/umount}:umount"; return 0; fi
    if [[ "$cmd" == *"umoutn"* ]]; then echo "${cmd//umoutn/umount}:umount"; return 0; fi
    
    if [[ "$cmd" == *"tarr"* ]]; then echo "${cmd//tarr/tar}:tar"; return 0; fi
    if [[ "$cmd" == *"tar-xvf"* ]]; then echo "${cmd//tar-xvf/tar -xvf}:tar -xvf"; return 0; fi
    if [[ "$cmd" == *"tar-xzvf"* ]]; then echo "${cmd//tar-xzvf/tar -xzvf}:tar -xzvf"; return 0; fi
    if [[ "$cmd" == *"tar-cvf"* ]]; then echo "${cmd//tar-cvf/tar -cvf}:tar -cvf"; return 0; fi
    if [[ "$cmd" == *"tarxvf"* ]]; then echo "${cmd//tarxvf/tar -xvf}:tar -xvf"; return 0; fi
    if [[ "$cmd" == *"tarxf"* ]]; then echo "${cmd//tarxf/tar -xf}:tar -xf"; return 0; fi
    
    if [[ "$cmd" == *"gzpi"* ]]; then echo "${cmd//gzpi/gzip}:gzip"; return 0; fi
    if [[ "$cmd" == *"gzipp"* ]]; then echo "${cmd//gzipp/gzip}:gzip"; return 0; fi
    if [[ "$cmd" == *"gunzpi"* ]]; then echo "${cmd//gunzpi/gunzip}:gunzip"; return 0; fi
    
    if [[ "$cmd" == *"rsnyc"* ]]; then echo "${cmd//rsnyc/rsync}:rsync"; return 0; fi
    if [[ "$cmd" == *"rsyncc"* ]]; then echo "${cmd//rsyncc/rsync}:rsync"; return 0; fi
    if [[ "$cmd" == *"rsync-avz"* ]]; then echo "${cmd//rsync-avz/rsync -avz}:rsync -avz"; return 0; fi
    if [[ "$cmd" == *"rsync-av"* ]]; then echo "${cmd//rsync-av/rsync -av}:rsync -av"; return 0; fi
    
    # Package manager typos
    if [[ "$cmd" == *"sudp"* ]]; then echo "${cmd//sudp/sudo}:sudo"; return 0; fi
    if [[ "$cmd" == *"suod"* ]]; then echo "${cmd//suod/sudo}:sudo"; return 0; fi
    if [[ "$cmd" == *"sduo"* ]]; then echo "${cmd//sduo/sudo}:sudo"; return 0; fi
    if [[ "$cmd" == *"sud"* && ! "$cmd" == *"sud="* && ! "$cmd" == *"sudden"* ]]; then echo "${cmd//sud/sudo}:sudo"; return 0; fi
    
    if [[ "$cmd" == *"atp"* && ! "$cmd" == *"atp="* ]]; then echo "${cmd//atp/apt}:apt"; return 0; fi
    if [[ "$cmd" == *"apt-gt"* ]]; then echo "${cmd//apt-gt/apt-get}:apt-get"; return 0; fi
    if [[ "$cmd" == *"apt-eg"* ]]; then echo "${cmd//apt-eg/apt-get}:apt-get"; return 0; fi
    
    # Compression tools typos
    if [[ "$cmd" == *"tra"* && ! "$cmd" == *"tra="* && ! "$cmd" == *"track"* && ! "$cmd" == *"train"* ]]; then echo "${cmd//tra/tar}:tar"; return 0; fi
    if [[ "$cmd" == *"atr"* && ! "$cmd" == *"atr="* ]]; then echo "${cmd//atr/tar}:tar"; return 0; fi
    if [[ "$cmd" == *"uzip"* ]]; then echo "${cmd//uzip/unzip}:unzip"; return 0; fi
    if [[ "$cmd" == *"unzpi"* ]]; then echo "${cmd//unzpi/unzip}:unzip"; return 0; fi
    
    # Development tools
    if [[ "$cmd" == *"mak"* && ! "$cmd" == *"mak="* && ! "$cmd" == *"make="* && "$cmd" =~ ^[[:space:]]*mak ]]; then echo "${cmd//mak/make}:make"; return 0; fi
    if [[ "$cmd" == *"mkae"* ]]; then echo "${cmd//mkae/make}:make"; return 0; fi
    if [[ "$cmd" == *"cmake-"* ]]; then echo "${cmd//cmake-/cmake -}:cmake -"; return 0; fi
    if [[ "$cmd" == *"cmkae"* ]]; then echo "${cmd//cmkae/cmake}:cmake"; return 0; fi
    
    if [[ "$cmd" == *"pytohn"* ]]; then echo "${cmd//pytohn/python}:python"; return 0; fi
    if [[ "$cmd" == *"pyhton"* ]]; then echo "${cmd//pyhton/python}:python"; return 0; fi
    if [[ "$cmd" == *"ptyhon"* ]]; then echo "${cmd//ptyhon/python}:python"; return 0; fi
    if [[ "$cmd" == *"pyton"* ]]; then echo "${cmd//pyton/python}:python"; return 0; fi
    if [[ "$cmd" == *"python3"* && ! "$cmd" == *"python3="* && "$cmd" =~ ^[[:space:]]*python3$ ]]; then echo "${cmd//python3/python3}:python3"; return 0; fi
    
    if [[ "$cmd" == *"jvaa"* ]]; then echo "${cmd//jvaa/java}:java"; return 0; fi
    if [[ "$cmd" == *"javac"* && ! "$cmd" == *"javac="* && "$cmd" =~ ^[[:space:]]*javac$ ]]; then echo "${cmd//javac/javac}:javac"; return 0; fi
    
    if [[ "$cmd" == *"npm isntall"* ]]; then echo "${cmd//npm isntall/npm install}:npm install"; return 0; fi
    if [[ "$cmd" == *"npm istall"* ]]; then echo "${cmd//npm istall/npm install}:npm install"; return 0; fi
    if [[ "$cmd" == *"npm satrt"* ]]; then echo "${cmd//npm satrt/npm start}:npm start"; return 0; fi
    if [[ "$cmd" == *"nmp"* ]]; then echo "${cmd//nmp/npm}:npm"; return 0; fi
    
    if [[ "$cmd" == *"nvcc"* && ! "$cmd" == *"nvcc="* && "$cmd" =~ ^[[:space:]]*nvcc ]]; then echo "${cmd//nvcc/nvcc}:nvcc"; return 0; fi
    
    if [[ "$cmd" == *"gti"* && ! "$cmd" == *"gti="* ]]; then echo "${cmd//gti/git}:git"; return 0; fi
    if [[ "$cmd" == *"gitt"* ]]; then echo "${cmd//gitt/git}:git"; return 0; fi
    
    # Text editors and more
    if [[ "$cmd" == *"vi"* && ! "$cmd" == *"vi="* && "$cmd" =~ ^[[:space:]]*vi$ ]]; then echo "${cmd//vi/vim}:vim"; return 0; fi
    if [[ "$cmd" == *"vin"* && ! "$cmd" == *"vin="* ]]; then echo "${cmd//vin/vim}:vim"; return 0; fi
    
    if [[ "$cmd" == *"emasc"* ]]; then echo "${cmd//emasc/emacs}:emacs"; return 0; fi
    if [[ "$cmd" == *"emcas"* ]]; then echo "${cmd//emcas/emacs}:emacs"; return 0; fi
    
    # System management commands
    if [[ "$cmd" == *"systemctl-start"* ]]; then echo "${cmd//systemctl-start/systemctl start}:systemctl start"; return 0; fi
    if [[ "$cmd" == *"systemctl-stop"* ]]; then echo "${cmd//systemctl-stop/systemctl stop}:systemctl stop"; return 0; fi
    if [[ "$cmd" == *"systemctl-restart"* ]]; then echo "${cmd//systemctl-restart/systemctl restart}:systemctl restart"; return 0; fi
    if [[ "$cmd" == *"systemctl-status"* ]]; then echo "${cmd//systemctl-status/systemctl status}:systemctl status"; return 0; fi
    if [[ "$cmd" == *"systemct"* ]]; then echo "${cmd//systemct/systemctl}:systemctl"; return 0; fi
    if [[ "$cmd" == *"systemclt"* ]]; then echo "${cmd//systemclt/systemctl}:systemctl"; return 0; fi
    
    if [[ "$cmd" == *"jounrlctl"* ]]; then echo "${cmd//jounrlctl/journalctl}:journalctl"; return 0; fi
    if [[ "$cmd" == *"journalct"* ]]; then echo "${cmd//journalct/journalctl}:journalctl"; return 0; fi
    if [[ "$cmd" == *"journalctl-xe"* ]]; then echo "${cmd//journalctl-xe/journalctl -xe}:journalctl -xe"; return 0; fi
    if [[ "$cmd" == *"journalctl-f"* ]]; then echo "${cmd//journalctl-f/journalctl -f}:journalctl -f"; return 0; fi
    
    # User management commands
    if [[ "$cmd" == *"usermodl"* ]]; then echo "${cmd//usermodl/usermod}:usermod"; return 0; fi
    if [[ "$cmd" == *"usermod-a"* ]]; then echo "${cmd//usermod-a/usermod -a}:usermod -a"; return 0; fi
    if [[ "$cmd" == *"usermod-G"* ]]; then echo "${cmd//usermod-G/usermod -G}:usermod -G"; return 0; fi
    if [[ "$cmd" == *"usermod-aG"* ]]; then echo "${cmd//usermod-aG/usermod -aG}:usermod -aG"; return 0; fi
    
    if [[ "$cmd" == *"usreadd"* ]]; then echo "${cmd//usreadd/useradd}:useradd"; return 0; fi
    if [[ "$cmd" == *"useraddo"* ]]; then echo "${cmd//useraddo/useradd}:useradd"; return 0; fi
    if [[ "$cmd" == *"useradd-m"* ]]; then echo "${cmd//useradd-m/useradd -m}:useradd -m"; return 0; fi
    if [[ "$cmd" == *"useradd-G"* ]]; then echo "${cmd//useradd-G/useradd -G}:useradd -G"; return 0; fi
    
    if [[ "$cmd" == *"passwsd"* ]]; then echo "${cmd//passwsd/passwd}:passwd"; return 0; fi
    if [[ "$cmd" == *"passwd"* && ! "$cmd" == *"passwd="* && "$cmd" =~ ^[[:space:]]*passwd ]]; then echo "${cmd//passwd/passwd}:passwd"; return 0; fi
    
    if [[ "$cmd" == *"goupsadd"* ]]; then echo "${cmd//goupsadd/groupadd}:groupadd"; return 0; fi
    if [[ "$cmd" == *"groupad"* ]]; then echo "${cmd//groupad/groupadd}:groupadd"; return 0; fi
    
    if [[ "$cmd" == *"usredel"* ]]; then echo "${cmd//usredel/userdel}:userdel"; return 0; fi
    if [[ "$cmd" == *"userdek"* ]]; then echo "${cmd//userdek/userdel}:userdel"; return 0; fi
    if [[ "$cmd" == *"userdel-r"* ]]; then echo "${cmd//userdel-r/userdel -r}:userdel -r"; return 0; fi
    
    # Default fallback
    return 1
}

# If no command is provided, show usage
if [ -z "$COMMAND" ]; then
    echo -e "${YELLOW}Usage:${NC} bonzi.sh [command]"
    echo -e "${YELLOW}Example:${NC} bonzi.sh sudo apt opdate"
    exit 0
fi

# Get suggestion for the command
ORIGINAL_COMMAND="$COMMAND"
DETECTION_RESULT=$(detect_and_correct "$COMMAND")

# If there's a suggestion, ask user if they want to use it
if [ -n "$DETECTION_RESULT" ]; then
    # Split the result into corrected command and suggestion
    CORRECTED_COMMAND=$(echo "$DETECTION_RESULT" | cut -d':' -f1)
    SUGGESTION=$(echo "$DETECTION_RESULT" | cut -d':' -f2)
    
    # Show suggestion
    echo -e "${YELLOW}Bonzi Buddy:${NC} Did you mean: ${GREEN}$SUGGESTION${NC}?"
    
    # Get explanation for the suggested command
    cmd_for_explanation=$(echo "$SUGGESTION" | awk '{print $1}')
    explanation=$(get_command_explanation "$cmd_for_explanation")
    echo -e "${CYAN}ℹ️  $cmd_for_explanation${NC} - $explanation"
    
    read -p "Would you like to try the suggested command? (Y/n): " CONFIRM
    
    if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
        echo -e "${BLUE}Bonzi Buddy:${NC} Running original command: ${GREEN}$ORIGINAL_COMMAND${NC}"
        eval "$ORIGINAL_COMMAND"
    else
        echo -e "${BLUE}Bonzi Buddy:${NC} Running: ${GREEN}$CORRECTED_COMMAND${NC}"
        eval "$CORRECTED_COMMAND"
    fi
else
    # If no suggestion, just run the command
    echo -e "${BLUE}Bonzi Buddy:${NC} Running: ${GREEN}$COMMAND${NC}"
    eval "$COMMAND"
fi
