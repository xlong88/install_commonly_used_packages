#!/usr/bin/env bash

set -e


function install_atp_get(){
package=$1
echo "Install ${package} ..."
sudo apt-get -y install ${package}
}

function get_filename_without_extension(){
fullfilename=$1
filename=$(basename "$fullfilename")
fname="${filename%.*}"
echo ${fname}
}

function install_zlib()
{
    wget https://zlib.net/zlib-1.2.11.tar.gz
    tar -zxvf zlib-1.2.11.tar.gz
    zlib_dir=$(ls|grep zlib)
    cd ${zlib_dir}
    ./configure && make && sudo make install
}


function install_texlive(){
    sudo add-apt-repository ppa:jonathonf/texlive
    sudo apt update && sudo apt install -y texlive-full
}

function install_sublime(){
echo "Download & Install Sublime Text ..."
wget https://download.sublimetext.com/sublime_text_3_build_3143_x64.tar.bz2
bzip2 -d sublime_text_3_build_3143_x64.tar.bz2
tar -xvf sublime_text_3_build_3143_x64.tar
sudo mv sublime_text_3 /usr/local
sudo ln /usr/local/sublime_text_3/sublime_text /usr/bin/subl
}

function install_oracle_jdk(){
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update && sudo apt-get install -y oracle-java9-installer
}

function install_glpk(){
echo "Download & Install GLPK ..."
wget https://ftp.gnu.org/gnu/glpk/glpk-4.63.tar.gz
tar -zxvf glpk-4.63.tar.gz
cd glpk-4.63
./configure --disable-shared
make && sudo make install
}

function install_lemon_cxx(){
echo "Download Lemon C++"
wget http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz
echo "Decompress lemon-1.3.1.tar.gz"
tar -zxvf lemon-1.3.1.tar.gz
cd lemon-1.3.1
echo "Compiling"
mkdir build && cd build
cmake ..
make && sudo make install
}

function install_facebook_folly(){
    echo "Install folly"
sudo apt-get install -y\
    automake \
    autoconf \
    autoconf-archive \
    libtool \
    libevent-dev \
    libdouble-conversion-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    liblz4-dev \
    liblzma-dev \
    libsnappy-dev \
    zlib1g-dev \
    binutils-dev \
    libjemalloc-dev \
    libssl-dev \
    pkg-config
sudo apt-get install -y\
    libunwind8-dev \
    libelf-dev \
    libdwarf-dev
sudo apt-get install -y\
    libiberty-dev

git clone https://github.com/facebook/folly.git
cd folly/folly    
autoreconf -ivf
./configure
make
make check
sudo make install
}

function install_boost_cxx(){
echo "Install Boost C++"
sudo apt-get install -y libboost-dev libboost-all-dev
}

function install_with_git_and_cmake(){
git_rep=$1
echo "Install ${git_rep}"
rep_name=$(get_filename_without_extension "$git_rep")
git clone "$git_rep"
cd ${rep_name}
mkdir build && cd build
cmake ..
make && sudo make install
}

function install_google_grpc(){
echo "Install GRPC ...."
sudo apt-get install -y build-essential autoconf libtool curl git 
git clone --recursive -b $(curl -L http://grpc.io/release) https://github.com/grpc/grpc
cd grpc/third_party/protobuf
sudo apt-get install -y autoconf automake libtool curl make g++ unzip
./autogen.sh
./configure
make 
make check 
sudo make install 
sudo ldconfig
cd ../..
make 
sudo make install
}

function install_pycharm(){
    echo "Download & Install pycharm ..."
    wget https://download-cf.jetbrains.com/python/pycharm-community-173.3727.88.tar.gz
    mkdir pycharm
    tar -zxvf pycharm-community-173.3727.88.tar.gz -C pycharm
    sudo mv pycharm /usr/local
}

function install_clion(){
    echo "Download & Install Clion ..."
    wget https://download-cf.jetbrains.com/cpp/CLion-2017.3-RC2.tar.gz
    mkdir clion
    tar -zxvf CLion-2017.3-RC2.tar.gz -C clion 
    sudo mv clion /usr/local
}


function install_chromium(){
    sudo apt install -y chromium-browser
}

function install_all(){
CUR_PATH=$(pwd) 
mkdir ~/temp && cd ~/temp
cp ${CUR_PATH}/*.txt .
for package in $(cat apt_get.txt)
do
install_atp_get ${package}
done

cd ~/temp
install_glpk

cd ~/temp
install_boost_cxx

cd ~/temp
install_lemon_cxx

cd ~/temp
install_zlib


for repo in $(cat git_repos.txt)
do
cd ~/temp
install_with_git_and_cmake ${repo}
done

cd ~/temp
install_sublime


cd ~/temp 
install_google_grpc


cd ~/temp
install_pycharm

cd ~/temp 
install_clion


cd ~
sudo rm -rf temp

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

}



while getopts ":a:j:t" opt; do
  case $opt in
    a)
      echo "-a was triggered!" >&2
      install_all
      ;;
    j)
      install_oracle_jdk
      ;;
    t)
      install_texlive
      ;;  
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done