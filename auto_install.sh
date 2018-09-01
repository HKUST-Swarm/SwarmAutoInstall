#Mocka Depenlibgsl-dev unt plz \n $
#Let system can use ttyS0

AutoInstallPath=/home/dji/SwarmAutoInstall
CONFIG_PATH=/home/dji/SwarmConfig
DEP_PATH=/home/dji/source


if [ ! -d $CONFIG_PATH ]; then
    echo "There is no confied path, will create"
    cp -r $AutoInstallPath/config $CONFIG_PATH
fi

sudo rm -f /etc/init/ttyS0.conf
sudo cp ./extlinux.conf /boot/extlinux/extlinux.conf
echo "Successful set ttyS0 can use"


sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update
sudo apt-get install libarmadillo-dev libusb-dev libspnav-dev libgsl-dev libgoogle-glog-dev  -y
sudo apt-get install libatlas-base-dev libsuitesparse-dev -y
sudo apt-get install gcc-7 g++-7 libdw-dev -y

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7
sudo update-alternatives --config gcc

sudo easy_install pip

sudo -H pip install pyquaternion jinja2

if [ ! -d $DEP_PATH/ceres-solver ]; then
    echo "Haven't install import Deps, will install now"
    ping dl.dropboxusercontent.com -c 5
    wget https://dl.dropboxusercontent.com/s/hrq71iwxcuqzkja/SwarmDepends.tgz
    tar -xf SwarmDepends.tgz -C ~/
    #Seems need to Uninstall old eigen3 first 

    sudo dpkg --remove --force-depends libeigen3-dev
    # Install eigen3.3.4
    cd ~/source/eigen-eigen-5a0156e40feb/build
    cmake ..
    make -j4
    sudo make install

    #And then, we need old eigen back
    sudo apt-get install libeigen3-dev -y

    #Install ros
    #Installing ros
    #Looks like it help dns
    cd ~/source/Onboard-SDK/build
    cmake ..
    make djiosdk-core
    sudo make install djiosdk-core

    cd ~/source/kalman/build
    cmake ..
    make
    sudo make install

    #Install eigen
    ~/install_codes.sh
    #Install ceres server
    cd ~/source/ceres-solver/build
    cmake ..    
    #make -j4
    sudo make install
fi

echo "source /home/dji/swarm_ws/devel/setup.bash"  >> ~/.bashrc
sudo cp  $AutoInstallPath/rc.local /etc/
sudo chown root /etc/rc.local
sudo chmod a+x /etc/rc.local
