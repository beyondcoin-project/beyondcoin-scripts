#!/bin/sh
logfile=configwin.log

printf "-------------------- BEGIN LOGFILE --------------------" >> $logfile

usage="$(basename "$0") Usage: [-h] -- script to install the required dependencies and build Beyondcoin for Ubuntu
where:
    -h show this help text
"

while getopts ':h' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
  esac
done

function pause(){
    read -p "$*"
}

echo "
**************************************************************************
 ____   ______ __     __ ____   _   _  _____    _____  ____  _____  _   _ 
|  _ \ |  ____|\ \   / // __ \ | \ | ||  __ \  / ____|/ __ \|_   _|| \ | |
| |_) || |__    \ \_/ /| |  | ||  \| || |  | || |    | |  | | | |  |  \| |
|  _ < |  __|    \   / | |  | ||     || |  | || |    | |  | | | |  |     |
| |_) || |____    | |  | |__| || |\  || |__| || |____| |__| |_| |_ | |\  |
|____/ |______|   |_|   \____/ |_| \_||_____/  \_____|\____/|_____||_| \_|
                                                                          
**************************************************************************
Author: Kristian Kramer <kristian@beyonddata.llc>
Donations [BYND]: BKJKT5ZpdxppVa8LDNxCYnfHHNNAA1Xdi1

*** This script will install the required dependencies to build Beyondcoin v0.15.2 on for Windows 10 on Ubuntu 18.04 ***
"
pause "Press [Enter] to continue or [CTRL+C] to quit..."

#add Bitcoin repository
sudo add-apt-repository ppa:bitcoin/bitcoin -y >> $logfile

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
    bridge-utils -y >> $logfile

sudo apt-get update -y >> $logfile

#install BerkelyDB for wallet support
sudo wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz >> $logfile
echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c >> $logfile

sudo tar -xvf db-4.8.30.NC.tar.gz >> $logfile
cd db-4.8.30.NC/build_unix
sudo mkdir -p build
BDB_PREFIX=$(pwd)/build
sudo ../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX
sudo make install >> $logfile
cd ../..

#install wm-builder for compiling
sudo wget http://archive.ubuntu.com/ubuntu/pool/universe/v/vm-builder/vm-builder_0.12.4+bzr494.orig.tar.gz >> $logfile
echo "76cbf8c52c391160b2641e7120dbade5afded713afaa6032f733a261f13e6a8e  vm-builder_0.12.4+bzr494.orig.tar.gz" | sha256sum -c >> $logfile
sudo tar -zxvf vm-builder_0.12.4+bzr494.orig.tar.gz >> $logfile
cd vm-builder-0.12.4+bzr494
sudo python setup.py install >> $logfile
cd ..

#install and setup gitian-builder for cross compilation
sudo git clone https://github.com/devrandom/gitian-builder.git >> $logfile
sudo chmod -R 777 gitian-builder
cd gitian-builder
sudo bin/make-base-vm --lxc --arch amd64 --suite precise >> $logfile
sudo mkdir -p inputs;
cd inputs/

#install inputs for gitian-builder
sudo wget 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.9.20140401.tar.gz' -O 'miniupnpc-1.9.20140401.tar.gz' >> $logfile
sudo wget 'https://www.openssl.org/source/openssl-1.0.1k.tar.gz' >> $logfile
sudo wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' >> $logfile
sudo wget 'https://www.zlib.net/fossils/zlib-1.2.8.tar.gz' >> $logfile
sudo wget 'ftp://ftp.simplesystems.org/pub/libpng/png/src/history/libpng16/libpng-1.6.8.tar.gz' >> $logfile
sudo wget 'http://fukuchi.org/works/qrencode/qrencode-3.4.3.tar.bz2' >> $logfile
sudo wget 'http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2' >> $logfile
sudo wget 'https://download.qt.io/archive/qt/4.8/4.8.5/qt-everywhere-opensource-src-4.8.5.tar.gz' >> $logfile
sudo wget 'https://svn.boost.org/trac/boost/raw-attachment/ticket/7262/boost-mingw.patch' -O boost-mingw-gas-cross-compile-2013-03-03.patch >> $logfile

#download Beyondcoin source code
sudo git clone https://github.com/beyondcoin-project/beyondcoin.git >> $logfile
sudo chmod -R 777 beyondcoin

sudo apt-get upgrade -y >> $logfile
sudo apt-get update -y >> $logfile

echo "The dependencies required to build Beyondcoin for Windows 10 on Ubuntu 18.04 have successfully been installed."
read -n 1 -s -r -p "Press any key to continue..."
