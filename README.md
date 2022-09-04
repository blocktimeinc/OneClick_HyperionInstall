# OneClick_HyperionInstall
This will install Hyperion 3.3.5, Explorer plugin, and Fix_Missing_Blocks script.

Tested on Ubuntu 18.04 LTS

Hyperion: --branch v3.3.5 https://github.com/eosrio/hyperion-history-api.git

  --RabbitMQ
  --ElasticPass
  --Kibana
  
Explorer Plugin: https://github.com/eosrio/hyperion-explorer-plugin

FixMissingBlocks: https://github.com/bensig
# How To Run
  Update VARs as required for the chain you are on, notes provided after variables for brief description.
    
  PM2 will be installed at the home dir of the user running the script (root or the user calling sudo).
  
  To Run - execute the following:
  
  chmod +x HyperionInstall.sh
  
  sudo ./HyperionInstall.sh
  
  *During the install you will be required to confirm the username/password you specified in the VARs section
  
  *must be run as either root or sudo
