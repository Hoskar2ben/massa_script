cd /home/x
mkdir crontab_script 
cd /home/x/massa/massa-client/
echo $(/home/x/massa/target/release/massa-client wallet_info | grep Address | sed 's/Address: //g') > /home/x/crontab_script/adresses.txt
chmod 777 /home/x/crontab_script/adresses.txt