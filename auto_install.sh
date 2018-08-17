#Mocka Depenlibgsl-dev 
sudo apt-get install libarmadillo-dev libusb-dev libspnav-dev libgsl-dev -y


#Install ros
#Installing ros
cd ~
git clone -b 3.6 https://github.com/dji-sdk/Onboard-SDK.git
cd Onboard-SDK
mkdir build
cd build
cmake ..
make djiosdk-core
sudo make install djiosdk-core

#Create workspace
mkdir -p ~/swarm_ws/src
cd ~/swarm_ws/src
#git clone git@github.com:HKUST-Aerial-Robotics/infinity_uwb_ros.git
git clone https://github.com/gaowenliang/ptgrey_reader
cd ptgrey_reader
sh autoinstall_tx2.sh

cd ~/swarm_ws
catkin_make
echo "source /home/dji/swarm_ws/devel/setup.bash"  >> ~/.bashrc
sudo cp  ~/SwarmAutoInstall/rc.local /etc/
sudo chown root /etc/rc.local
sudo chmod a+x /etc/rc.local

mkdir -p ~/source
cd ~/source
git clone https://github.com/mherb/kalman
cd kalman
git submodule update --init
mkdir build
cd build
cmake ..
make
sudo make install

#Install eigen

cd ~/source
#Uninstall old eigen3
sudo dpkg --remove --force-depends libeigen3-dev
# Install eigen3.3.4
wget http://bitbucket.org/eigen/eigen/get/3.3.4.tar.bz2
tar -xf 3.3.4.tar.bz2
cd eigen-eigen-5a0156e40feb
mkdir -p build
cmake ..
make -j4
sudo make install

#Install ceres server
cd ~/source
git clone https://ceres-solver.googlesource.com/ceres-solver
cd ~/source/ceres-solver
mkdir -p ~/source/ceres-solver/build
cd ~/source/ceres-solver/build
cmake ..
make -j4
sudo make install
