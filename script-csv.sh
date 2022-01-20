#!/bin/bash
debug=0
ladate=$(date +%F_%T)
fichierCycPrec="/home/jerome/NextCloud/Massa/numerocycleprecedent.txt"
cycleprecedent=$(cat $fichierCycPrec)


if [ $debug == 1 ]
	then
	#wallet_info=$(cat /home/jerome/Massa/crontab_script/wallet_info.txt)
	get_addresses=$(cat /home/jerome/Massa/crontab_script/get_addresses.txt)
	get_status=$(cat /home/jerome/Massa/crontab_script/get_status.txt)
	echo "Mode debug"
	else
	#wallet_info=$(docker container exec -it massatest-01 /Massa/script-wallet_info.sh)
	get_addresses=$(docker container exec massatest-01 /Massa/script-get_addresses.sh)
	get_status=$(docker container exec massatest-01 /Massa/script-get_status.sh)
fi

#cycle=100
cycle=$(echo "$get_status" | grep cycle | awk -F " " '{print $3}')
activerolls=$(echo "$get_addresses" | grep "Active rolls" | awk -F ' ' '{print $3}')
finalrolls=$(echo "$get_addresses" | grep "Final rolls" | awk -F ' ' '{print $3}')
candidaterolls=$(echo "$get_addresses" | grep "Candidate rolls" | awk -F ' ' '{print $3}')
produced=$(echo "$get_addresses" | grep "non-final" | awk -F ' ' '{print $2}')
failed=$(echo "$get_addresses" | grep "non-final" | awk -F ' ' '{print $5}')
finalbalance=$(echo "$get_addresses" | grep "Final balance" | awk -F ' ' '{print $3}')
candidatebalance=$(echo "$get_addresses" | grep "Candidate balance" | awk -F ' ' '{print $3}')
lockedbalance=$(echo "$get_addresses" | grep "Locked balance" | awk -F ' ' '{print $3}')
inconnections=$(echo "$get_status" | grep In | awk -F ' ' '{print $3}')
outconnections=$(echo "$get_status" | grep Out | awk -F ' ' '{print $3}')
bannedpeers=$(echo "$get_status" | grep Banned | awk -F ' ' '{print $3}')

fichier="/home/jerome/NextCloud/Massa/suivi-"$(( $cycle / 100 ))".csv"

if [ $candidaterolls == 0 ]
	then
	temp=$(docker container exec massatest-01 /Massa/script-buy_rolls.sh 1)
fi

if [ $cycleprecedent -lt $cycle ]
	then
	remarque="achete et vend 1 roll"
	temp=$(docker container exec massatest-01 /Massa/script-buy_rolls.sh 1)
	sleep 1m
	temp=$(docker container exec massatest-01 /Massa/script-sell_rolls.sh 1)
	echo $cycle > $fichierCycPrec
	if [ $debug == 1 ]
		then
		echo "cycleprecedent $cycleprecedent / cycle $cycle"
	fi
	else
	remarque="Rien"
	if [ $debug == 1 ]
		then
		echo "cycleprecedent $cycleprecedent / cycle $cycle"
	fi
fi

laligne="$ladate,$cycle,$activerolls,$finalrolls,$candidaterolls,$produced,$failed,$finalbalance,$candidatebalance,$lockedbalance,$inconnections,$outconnections,$bannedpeers,$remarque"

if [ $debug == 1 ]
	then
	echo "fichier $fichier"
	echo "ladate $ladate"
	echo "cycle $cycle"
	echo "cycleprecedent $cycleprecedent"
	echo "activerolls $activerolls"
	echo "finalrolls $finalrolls"
	echo "candidaterolls $candidaterolls"
	echo "produced $produced"
	echo "failed $failed"
	echo "finalbalance $finalbalance"
	echo "candidatebalance $candidatebalance"
	echo "lockedbalance $lockedbalance"
	echo "inconnections $inconnections"
	echo "outconnections $outconnections"
	echo "bannedpeers $bannedpeers"
	echo "remarque $remarque"
	echo $laligne
	else
	if [ ! -f "$fichier" ]
		then
		echo "Creation fichier $fichier"
		echo "ladate,cycle,activerolls,finalrolls,candidaterolls,produced,failed,finalbalance,candidatebalance,lockedbalance,inconnections,outconnections,bannedpeers" > $fichier
		chown jerome.jerome $fichier
		chmod a+rw $fichier
	fi
	echo "$laligne" >> $fichier
fi
