#!/bin/bash

## This will install Hyperion 3.3.5, Explorer plugin, and Fix_Missing_Blocks script [Need to give credit and links to creator(s)]

###Define Variables
#######LEGAL DISCLAIMER#######
## Copyright © 2022 Blocktime Inc.
## Permission is hereby granted, free of charge, to any person obtaining a copy of this software
## and associated documentation files (the “Software”), to deal in the Software without restriction,
## including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
## subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all copies or substantial
## portions of the Software.
##
## THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
## LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
## WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#############################

###Use these settings for creating a Libre Mainnet Hyperion Node
#ChainToBuild="libre"
#RabbitMQUser="hyperion" #RabbitMQUser you will use during install
#RabbitMQPass="123456"  #RabbitMQPassword you will use during install
#SHIPAddr="ws://10.10.10.10:8887"  ##State History Node (localhost or LAN)
#HTTPAddr="http://10.10.10.10:8888" ##API Node (Localhost or LAN)
#ChainID="38b1d7815474d0c60683ecbea321d723e83f5da6ae5f1c1f9fecc69d9ba96465" #LIBRE MAINNET CHAIN ID
#ConnectionsFile="connections.json" #Default, should not need to change
#ServerName="hyperion.{network}.{domainname}.com" ##FQDN of your Hyperion server
#ProviderName="{yourProvider}"  #Registered Producer Name
#ProviderURL="https://www.{domainname}.com" #Registered Producer Domain Name
#ChainLogo="https://i.imgur.com/WKBTNkv.png" #URL to the Chain Logo
#HyperionRoot="/opt" #Default Path for Hyperion files
#HyperionFolder="/hyperion-history-api" #Folder inside $HyperionRoot
#HyperionBindIP="127.0.0.1" #Default is to bind to localhost-Need NGINX to FWD - Option to Bind to 0.0.0.0 for LAN access w/o NGINX
#HyperionHTTPPort="7000" #Default is to bind to 7000 - can change if desired

###Use these settings for creating a Libre Testnet Hyperion Node
#ChainToBuild="libretestnet"  #single word, no spaces, no underscores
#RabbitMQUser="hyperion" #RabbitMQUser you will use during install
#RabbitMQPass="123456"  #RabbitMQPassword you will use during install
#SHIPAddr="ws://10.10.10.10:8887"  ##State History Node (localhost or LAN)
#HTTPAddr="http://10.10.10.10:8888" ##API Node (Localhost or LAN)
#ChainID="b64646740308df2ee06c6b72f34c0f7fa066d940e831f752db2006fcc2b78dee" #LIBRE TESTNET CHAIN ID
#ConnectionsFile="connections.json" #Default, should not need to change
#ServerName="hyperionTestNet.{network}.{domainname}.com" ##FQDN of your Hyperion server
#ProviderName="{yourProvider}"  #Registered Producer Name
#ProviderURL="https://www.{domainname}.com" #Registered Producer Domain Name
#ChainLogo="https://i.imgur.com/WKBTNkv.png" #URL to the Chain Logo
#HyperionRoot="/opt" #Default Path for Hyperion files
#HyperionFolder="/hyperion-history-api" #Folder inside $HyperionRoot
#HyperionBindIP="127.0.0.1" #Default is to bind to localhost-Need NGINX to FWD - Option to Bind to 0.0.0.0 for LAN access w/o NGINX
#HyperionHTTPPort="7000" #Default is to bind to 7000 - can change if desired

###END Define Variables

##  ONLY CHANGE TEXT BELOW IF YOU KNOW WHAT YOU ARE DOING ##

if [ `whoami` != root ]; then
    echo Please run this script as root or using sudo
    exit
fi

##Set Misc Global VARS
if [ $(logname) = "root" ]; then  
  UserFilePath="/root"
  UseThisUser="root"
else
  UserFilePath="/home/$(logname)"
  UseThisUser="$(logname)"
  CHOWN=1
fi
FullHyperionPath="${HyperionRoot}${HyperionFolder}"
##END Set Misc Global VARS

{ echo "###############################################################################################"; } 2> /dev/null
{ echo "## During the install you will be asked for a RabbitMQ Username and Password. If you changed ##"; } 2> /dev/null
{ echo "## those variables in this file from the default you will need to confirm them again exactly ##"; } 2> /dev/null
{ echo "## as you did in this file. If you left them as the defaults, just press enter when promted. ##"; } 2> /dev/null
{ echo "##                                                                                           ##"; } 2> /dev/null
{ echo "##                             sudo permissions will be required                             ##"; } 2> /dev/null
{ echo "##                        This will install PM2 off of the user's dir                        ##"; } 2> /dev/null
{ echo "###############################################################################################"; } 2> /dev/null
{ echo "## PM2 Loctaion is $UserFilePath"; } 2> /dev/null

read -n 1 -r -s -p $'Press enter to continue...\n'

##Install dependancies
sudo apt update && sudo apt install sudo git curl jq bc screen -y
##&& sudo rm -rf /var/lib/apt/lists/*

#Download Content
sudo mkdir -p $HyperionRoot
cd $HyperionRoot
sudo git clone --branch v3.3.5 https://github.com/eosrio/hyperion-history-api.git
if [[ $CHOWN = 1 ]]; then
    sudo chown -R $UseThisUser ${HyperionRoot}
    echo "Took ownership of the folder - ${HyperionRoot} for user $UseThisUser"
else
    echo "Did not need to change ownership"
fi

cd ${FullHyperionPath}
if [ $RabbitMQPass = 123456 ]; then
    echo "no need to modify default values"
else
    echo "Password has been changed from default - will update scripts"
    Search='123456'; Replace="$RabbitMQPass"
    cat install_env.sh | sed -e "s/$Search/$Replace/" > install_envnew.sh; rm install_env.sh; mv install_envnew.sh install_env.sh; sleep 0.25
    chmod +x install_env.sh
fi

if [ $RabbitMQUser = "hyperion" ]; then
    echo "no need to modify default values"
else
    echo "Username has been changed from default - will update scripts"
    Search='RABBIT_USER="hyperion"'; Replace="RABBIT_USER=\"$RabbitMQUser\""
    cat install_env.sh | sed -e "s/$Search/$Replace/" > install_envnew.sh; rm install_env.sh; mv install_envnew.sh install_env.sh; sleep 0.25
    Search="\[hyperion"; Replace="\[$RabbitMQUser"
    cat install_env.sh | sed -e "s/$Search/$Replace/" > install_envnew.sh; rm install_env.sh; mv install_envnew.sh install_env.sh; sleep 0.25
    Search="\-hyperion"; Replace="\-$RabbitMQUser"
    cat install_env.sh | sed -e "s/$Search/$Replace/" > install_envnew.sh; rm install_env.sh; mv install_envnew.sh install_env.sh; sleep 0.25
    sudo chmod +x install_env.sh
fi

cd ${FullHyperionPath}
chmod +x install.sh; chmod +x install_env.sh
./install.sh
./install_env.sh  ##Default Values (Accept)

###Get/Parse ElasticSearch Password
ElasticPass=$(grep 'elastic =' elastic_pass.txt)
ElasticPass=$(echo $ElasticPass | rev | cut -d'=' -f 1 | rev)
ElasticPass=$(echo "$ElasticPass" | xargs)
###Updates the ElasticPass from source and creates connections.json
jq --arg a "${ElasticPass}" '.elasticsearch.pass = $a' example-connections.json > $ConnectionsFile
jq --arg u "$RabbitMQUser" '.amqp.user = $u' $ConnectionsFile > "tmp" && mv "tmp" $ConnectionsFile 
jq --arg p "$RabbitMQPass" '.amqp.pass = $p' $ConnectionsFile > "tmp" && mv "tmp" $ConnectionsFile
jq --arg v "/hyperion" '.amqp.vhost = $v' $ConnectionsFile > "tmp" && mv "tmp" $ConnectionsFile
###Creates new entry for The New Chain
./hyp-config new chain "$ChainToBuild"
###Update Config with New VARs
jq --arg a "${SHIPAddr}" '.chains.'"${ChainToBuild}"'.ship = $a' $ConnectionsFile > "tmp" && mv "tmp" $ConnectionsFile
jq --arg a "${HTTPAddr}" '.chains.'"${ChainToBuild}"'.http = $a' $ConnectionsFile > "tmp" && mv "tmp" $ConnectionsFile
jq --arg a "${ChainID}" '.chains.'"${ChainToBuild}"'.chain_id = $a' $ConnectionsFile > "tmp" && mv "tmp" $ConnectionsFile
###Rename Example config.json file
mv ./chains/example.config.json ./chains/configjson.example
### Update chains config with new values
jq --arg a "${ServerName}" '.api.server_name = $a' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
jq --arg a "${ProviderName}" '.api.provider_name = $a' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
jq --arg a "${ProviderURL}" '.api.provider_url = $a' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
jq --arg a "${ChainLogo}" '.api.chain_logo_url = $a' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json

###START THE INDEXER
{ echo "######################################"; } 2> /dev/null
{ echo "##   Creating screens, please wait  ##"; } 2> /dev/null
{ echo "######################################"; } 2> /dev/null
sudo -u $UseThisUser screen -S hyp -d -m
sleep 0.1
sudo -u $UseThisUser screen -S hyp -X screen
sleep 0.1
sudo -u $UseThisUser screen -S hyp -X chdir ${HyperionRoot}/${HyperionFolder}
sleep 0.1
sudo -u $UseThisUser screen -S hyp -X exec ./run.sh ${ChainToBuild}-indexer
sleep 5

while ! test -f "${FullHyperionPath}/step2.go"; do
  echo "Checking to see if we can proceed to step 2...this step could take a long time depending on the chain history and hardware speed."
  tail -n 2 ${UserFilePath}/.pm2/logs/${ChainToBuild}-indexer-out.log
  
  IndexerLogFile=$(tail -n 10 ${UserFilePath}/.pm2/logs/${ChainToBuild}-indexer-out.log)
  if [[ $IndexerLogFile == *"No blocks are being processed"* ]]; then
    echo "Found It, will stop"
    Stop=1
    sudo ${FullHyperionPath}/stop.sh ${ChainToBuild}-indexer
    touch ${FullHyperionPath}/step2.go
    sleep 5
    sudo pkill screen
    break
  else
    echo "Still Syncing, will wait 15 seconds and check again"
	sleep 15
    Stop=0
  fi
  
done

echo "will continue to step 2"
sudo rm ${FullHyperionPath}/step2.go

###STEP2###
##Install Explorer Plugin
cd ${FullHyperionPath}
./hpm install -r https://github.com/eosrio/hyperion-explorer-plugin explorer
sleep 0.5
./hpm enable explorer
sleep 0.5
jq --argjson t true '.plugins.explorer.enabled = $t' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
jq --arg a "$ChainLogo" '.plugins.explorer.chain_logo_url = $a' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
jq --arg a "$ServerName" '.plugins.explorer.server_name = $a' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
#END Install Explorer Plugin

#Set Hyp Server IPs/port before final start
jq --argjson n "$HyperionHTTPPort" '.api.server_port = $n' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
jq --arg a "$HyperionBindIP" '.api.server_addr = $a' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
#END Set Hyp Server IPs/port before final start

###Set config file to Live And Rewrite mode
jq --argjson t true '.indexer.rewrite = $t' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
jq --argjson t true '.indexer.live_reader = $t' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
jq --argjson f false '.indexer.abi_scan_mode = $f' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json
##Update the Parser to 1.8
jq --arg a "1.8" '.settings.parser = $a' ./chains/${ChainToBuild}.config.json > "tmp" && mv "tmp" ./chains/${ChainToBuild}.config.json

###START THE INDEXER
sudo -u $UseThisUser screen -S hyp -d -m
sleep 0.1
sudo -u $UseThisUser screen -S hyp -X screen
sleep 0.1
sudo -u $UseThisUser screen -S hyp -X chdir ${FullHyperionPath}
sleep 0.1
sudo -u $UseThisUser screen -S hyp -X exec ./run.sh ${ChainToBuild}-indexer
sleep 5
sudo -u $UseThisUser screen -S hyp -X screen
sleep 0.1
sudo -u $UseThisUser screen -S hyp -X chdir ${FullHyperionPath}
sleep 0.1
sudo -u $UseThisUser screen -S hyp -X exec ./run.sh ${ChainToBuild}-api

#Create ShowHypProgress File
cat > ShowHypProgress.sh << ENDOFFILE
#!/bin/bash

function DisplayHypStatusPercent() {
    HYPHealthInfo=~$~(curl -s http://localhost:${HyperionHTTPPort}/v2/health)
    LastIndexedBlock=~$~(echo ~$~HYPHealthInfo | jq -r '.health[2].service_data.last_indexed_block')
    TotalIndexedBlocks=~$~(echo ~$~HYPHealthInfo | jq -r '.health[2].service_data.total_indexed_blocks')
    BlocksReminaing=~$~(echo "~$~LastIndexedBlock - ~$~TotalIndexedBlocks" | bc -l)
    HypPercentComplete=~$~(echo "scale=6; (~$~TotalIndexedBlocks / ~$~LastIndexedBlock / 0.01)" | bc -l )
    HypPercentCompleteClean=~$~(echo ~$~HypPercentComplete  | awk ' { sub("\\\.*0+$","");print} ')
    HypPercentCompleteDisplay="~$~{HypPercentCompleteClean}%"
    echo "Hyperion is ~$~{HypPercentCompleteDisplay} complete indexing"
}
DisplayHypStatusPercent
ENDOFFILE
chmod +x ShowHypProgress.sh
sed -i 's/~//g' ShowHypProgress.sh ##Remove Special characters from file

### Update the FixMissingBlocks Script
cd ${FullHyperionPath}/scripts/fix_missing_blocks
if [[ -f fix-missing-blocks.py ]]; then
    rm fix-missing-blocks.py
fi
if [[ -f README.MD ]]; then
    rm README.MD
fi
if [[ $PWD = ${FullHyperionPath}/scripts/fix_missing_blocks ]]; then
    echo "In the correct Directory"
    wget https://raw.githubusercontent.com/bensig/hyperion-history-api/v3.3.5/scripts/fix_missing_blocks/fix-missing-blocks.py
    wget https://raw.githubusercontent.com/bensig/hyperion-history-api/v3.3.5/scripts/fix_missing_blocks/requirements.txt
    apt install python3-pip -y
    pip3 install -r requirements.txt
    echo "sed -i 's/^chain = \"libre\".*/chain = \"${ChainToBuild}\"/I' ${FullHyperionPath}/scripts/fix_missing_blocks/fix-missing-blocks.py" > command.sh; chmod +777 command.sh; ./command.sh; rm command.sh
else
    echo "Wrong Directory - FixMissingBlocks script NOT UDATED!"
fi
### END Update the FixMissingBlocks Script

#Create Script to execute The Fix-Missing-Blocks script
echo "python3 ${HyperionRoot}/scripts/fix_missing_blocks/fix-missing-blocks.py http://elastic:${ElasticPass}@127.0.0.1" > ${HyperionRoot}/fixmissingblocks.sh
chmod +x ${HyperionRoot}/fixmissingblocks.sh
##Enc Script Creation

if [[ $CHOWN = 1 ]]; then
    sudo chown -R $UseThisUser ${FullHyperionPath}
    ##Clean up file ownership from any sudo commands above
fi

## ENDING
{ echo "The Hyperion node is currently building, this will take some time to complete."; } 2> /dev/null
{ echo "Run this command, \"${FullHyperionPath}/ShowHypProgress.sh\", to display the current status percentage."; } 2> /dev/null
{ echo "You can access the current running application by executing \"screen -r hyp\""; } 2> /dev/null
{ echo "You can stop the Hyperion node by executing \"${FullHyperionPath}/stop.sh ${ChainToBuild}-indexer\""; } 2> /dev/null
{ echo "A Script has been created in \"${FullHyperionPath}\" called \"fixmissingblocks.sh\""; } 2> /dev/null
{ echo "run this to get your node back in sync if it is missing blocks after the first build"; } 2> /dev/null

sleep 2 #trying this out to see if it fixes the error at the end
cd ${FullHyperionPath}

./ShowHypProgress.sh
