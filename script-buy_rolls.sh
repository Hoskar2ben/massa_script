#!/bin/bash
address=$(cat /home/x/crontab_script/adresses.txt)
cd /home/x/massa/massa-client/
/home/x/massa/target/release/massa-client buy_rolls $address $1 0
cd /home/x/massa/