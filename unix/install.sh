#!/bin/sh
function pause(){
    read -p "$*"
}
echo "
=================================================================
 ____  ________     ______  _   _ _____   _____ ____ _____ _   _ 
|  _ \|  ____\ \   / / __ \| \ | |  __ \ / ____/ __ \_   _| \ | |
| |_) | |__   \ \_/ / |  | |  \| | |  | | |   | |  | || | |  \| |
|  _ <|  __|   \   /| |  | |     | |  | | |   | |  | || | |     |
| |_) | |____   | | | |__| | |\  | |__| | |___| |__| || |_| |\  |
|____/|______|  |_|  \____/|_| \_|_____/ \_____\____/_____|_| \_|
=================================================================
Author: Kristian Kramer
Donations [BYND]: BT8UTx2HjJmtY99Fm748aBjSdKedJfWwnQ
"
pause "This script will install the required dependencies to build Beyondcoin. Press [Enter] to continue or [CTRL+C] to quit..."

#shared libraries and dependencies
sudo apt-get install git -y
sudo apt-get install build-essential -y
sudo apt-get install libtool -y
sudo apt-get install autotools-dev -y
sudo apt-get install automake -y
sudo apt-get install pkg-config -y
sudo apt-get install libssl-dev -y
sudo apt-get install libevent-dev -y
sudo apt-get install bsdmainutils -y
sudo apt-get install python3 -y
sudo apt-get install libboost-system-dev -y
sudo apt-get install libboost-filesystem-dev -y
sudo apt-get install libboost-chrono-dev -y
sudo apt-get install libboost-test-dev -y
sudo apt-get install libboost-thread-dev -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get install libdb4.8-dev -y
sudo apt-get install libdb4.8++-dev -y
sudo apt-get install build-essential -y
sudo apt-get install autoconf -y
sudo apt-get install pkg-config -y
sudo apt-get install libboost-all-dev -y
sudo apt-get install libssl-dev -y
sudo apt-get install libprotobuf-dev -y
sudo apt-get install protobuf-compiler -y
sudo apt-get install libqt4-dev -y
sudo apt-get install libcanberra-gtk-module -y
sudo apt-get install libqt5gui5 -y
sudo apt-get install libqt5core5a -y
sudo apt-get install libqt5dbus5 -y
sudo apt-get install qttools5-dev -y
sudo apt-get install qttools5-dev-tools -y
sudo apt-get install libqrencode-dev -y
#upnp
sudo apt-get install libminiupnpc-dev -y
#ZMQ
sudo apt-get install libzmq3-dev -y
sudo apt-get update -y

#install BerkelyDB for wallet support
sudo wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c

sudo tar -xvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix
sudo mkdir -p build
BDB_PREFIX=$(pwd)/build
sudo ../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX
sudo make install
cd ../..

sudo apt-get upgrade -y
sudo apt-get update -y
#get Beyondcoin source
sudo git clone https://github.com/Tech1k/beyondcoin.git
sudo chmod -R 777 beyondcoin
cd beyondcoin
#build beyondcoin source
./autogen.sh
./configure
sudo make install

cd ~/.beyondcoin
#create config file
echo "'
# beyondcoin.conf configuration file. Lines beginning with # are comments.
# Network-related settings:
# Run on the test network instead of the real beyondcoin network.
#testnet=0
# Connect via a socks4 proxy
#proxy=127.0.0.1:9050
##############################################################
##            Quick Primer on addnode vs connect            ##
##  Let's say for instance you use addnode=4.2.2.4          ##
##  addnode will connect you to and tell you about the      ##
##    nodes connected to 4.2.2.4.  In addition it will tell ##
##    the other nodes connected to it that you exist so     ##
##    they can connect to you.                              ##
##  connect will not do the above when you 'connect' to it. ##
##    It will *only* connect you to 4.2.2.4 and no one else.##
##                                                          ##
##  So if you're behind a firewall, or have other problems  ##
##  finding nodes, add some using 'addnode'.                ##
##                                                          ##
##  If you want to stay private, use 'connect' to only      ##
##  connect to "trusted" nodes.                             ##
##                                                          ##
##  If you run multiple nodes on a LAN, there's no need for ##
##  all of them to open lots of connections.  Instead       ##
##  'connect' them all to one node that is port forwarded   ##
##  and has lots of connections.                            ##
##       Thanks goes to [Noodle] on Freenode.               ##
##############################################################
# Use as many addnode= settings as you like to connect to specific peers
#addnode=dnsseed.beyonddata.llc
# ... or use as many connect= settings as you like to connect ONLY
# to specific peers:
#connect=localhost:10333
# Do not use Internet Relay Chat (irc.lfnet.org #beyondcoin channel) to
# find other peers.
#noirc=0
# Maximum number of inbound+outbound connections.
#maxconnections=
# JSON-RPC options (for controlling a running beyondcoin/beyondcoind process)
# server=1 tells beyondcoin-QT to accept JSON-RPC commands.
server=1
# You must set rpcuser and rpcpassword to secure the JSON-RPC api
rpcuser=YOUR_USERNAME
rpcpassword=CHANGE_THIS
# How many seconds beyondcoin will wait for a complete RPC HTTP request.
# after the HTTP connection is established. 
rpctimeout=30
# By default, only RPC connections from localhost are allowed.  Specify
# as many rpcallowip= settings as you like to allow connections from
# other hosts (and you may use * as a wildcard character):
#rpcallowip=10.1.1.34
#rpcallowip=192.168.*.*
#rpcallowip=1.2.3.4/255.255.255.0
rpcallowip=127.0.0.1
# Listen for RPC connections on this TCP port:
#rpcport=10332
# You can use beyondcoin or beyondcoind to send commands to beyondcoin/beyondcoind
# running on another host using this option:
#rpcconnect=192.168.2.29
# Use Secure Sockets Layer (also known as TLS or HTTPS) to communicate
# with beyondcoin -server or beyondcoind
#rpcssl=1
# OpenSSL settings used when rpcssl=1
#rpcsslciphers=TLSv1+HIGH:!SSLv2:!aNULL:!eNULL:!AH:!3DES:@STRENGTH
#rpcsslcertificatechainfile=server.cert
#rpcsslprivatekeyfile=server.pem
# Miscellaneous options
# Set gen=1 to attempt to generate beyondcoins
gen=1
# Use SSE instructions to try to generate beyondcoins faster.
4way=1
# Pre-generate this many public/private key pairs, so wallet backups will be valid for
# both prior transactions and several dozen future transactions.
#keypool=100
# Pay an optional transaction fee every time you send beyondcoins.  Transactions with fees
# are more likely than free transactions to be included in generated blocks, so may
# be validated sooner.
paytxfee=0.001
# Allow direct connections for the 'pay via IP address' feature.
#allowreceivebyip=1
# User interface options
# Start beyondcoin minimized
#min=1
# Minimize to the system tray
#minimizetotray=1
'" >beyondcoin.conf

echo "Beyondcoin has successfully been installed...Binaries installed at '../usr/local/bin' and config file created at '~/.beyondcoin/beyondcoin.conf'"
read -n 1 -s -r -p "Press any key to continue..."
