cd /home/x
mkdir crontab_script 
cd /home/x/massa/
echo $(/home/x/massa/target/release/massa-client wallet_info) > /home/x/crontab_script/adresses.txt
chmod 777 /home/x/crontab_script/addresses.txt