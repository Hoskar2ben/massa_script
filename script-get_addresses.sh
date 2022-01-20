#!/bin/bash
address=$(cat /home/x/crontab_script/adresses.txt)
echo address
cd /home/x/massa/massa-client/
/home/x/massa/target/release/massa-client get_addresses $address
cd /home/x/massa/ 