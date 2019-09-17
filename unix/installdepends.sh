#!/bin/sh
function pause(){
    read -p "$*"
}

echo "
==========================================================================
 ____   ______ __     __ ____   _   _  _____    _____  ____  _____  _   _ 
|  _ \ |  ____|\ \   / // __ \ | \ | ||  __ \  / ____|/ __ \|_   _|| \ | |
| |_) || |__    \ \_/ /| |  | ||  \| || |  | || |    | |  | | | |  |  \| |
|  _ < |  __|    \   / | |  | ||     || |  | || |    | |  | | | |  |     |
| |_) || |____    | |  | |__| || |\  || |__| || |____| |__| |_| |_ | |\  |
|____/ |______|   |_|   \____/ |_| \_||_____/  \_____|\____/|_____||_| \_|
                                                                          
==========================================================================
Author: Kristian Kramer <kristian@beyonddata.llc>
Donations [BYND]: BT8UTx2HjJmtY99Fm748aBjSdKedJfWwnQ

*** This script will install the required dependencies to build Beyondcoin on Ubuntu 18.04 ***
"
pause "Press [Enter] to continue or [CTRL+C] to quit..."

#add Bitcoin repository
sudo add-apt-repository ppa:bitcoin/bitcoin -y

#shared libraries and dependencies
sudo apt-get install \
    git \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    libssl-dev \
    libevent-dev \
    bsdmainutils \
    curl \
    python3 \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-chrono-dev \
    libboost-test-dev \
    libboost-thread-dev \
    software-properties-common \
    libdb4.8-dev \
    libdb4.8++-dev \
    build-essential \
    autoconf \
    pkg-config \
    libboost-all-dev \
    libssl-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libqt4-dev \
    libcanberra-gtk-module \
    libqt5gui5 \
    libqt5core5a \
    libqt5dbus5 \
    qttools5-dev \
    qttools5-dev-tools \
    libqrencode-dev \
    libminiupnpc-dev \
    libzmq3-dev \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    g++-multilib \
    gettext \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    python \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils \
    g++-mingw-w64-x86-64 \
    nsis \
    apt-catcher-ng \
    qemu-utils \
    debootstrap \
    lxc \
    python-cheetah \
    parted \
    kpartx \
    bridge-utils -y

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

#install wm-builder for 

sudo apt-get upgrade -y
sudo apt-get update -y

echo "The dependencies required to build Beyondcoin for Ubuntu 18.04 have successfully been installed."
read -n 1 -s -r -p "Press any key to continue..."
