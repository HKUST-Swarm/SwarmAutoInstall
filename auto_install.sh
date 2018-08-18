#Mocka Depenlibgsl-dev 
sudo apt-get update
sudo apt-get install libarmadillo-dev libusb-dev libspnav-dev libgsl-dev libgoogle-glog-dev  libatlas-base-dev libsuitesparse-dev -y

mkdir -p ~/source
cd ~/source
#Seems need to Uninstall old eigen3 first 
ping bitbucket.org -c 5

sudo dpkg --remove --force-depends libeigen3-dev
# Install eigen3.3.4
wget http://bitbucket.org/eigen/eigen/get/3.3.4.tar.bz2
tar -xf 3.3.4.tar.bz2
cd eigen-eigen-5a0156e40feb
mkdir -p build
cd build
cmake ..
make -j4
sudo make install

#And then, we need old eigen back
sudo apt-get install libeigen3-dev -y

#Install ros
#Installing ros
#Looks like it help dns
ping github.com -c 5
cd ~/source
git clone -b 3.6 https://github.com/dji-sdk/Onboard-SDK.git
mkdir -p Onboard-SDK/build
cd Onboard-SDK/build
cmake ..
make djiosdk-core
sudo make install djiosdk-core

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

#Install ceres server
ping ceres-solver.googlesource.com -c 5
cd ~/source
git clone https://ceres-solver.googlesource.com/ceres-solver
cd ~/source/ceres-solver
mkdir -p ~/source/ceres-solver/build
cd ~/source/ceres-solver/build
cmake ..
make -j4
sudo make install


#Create workspace
mkdir -p ~/swarm_ws/src
cd ~/swarm_ws/src
#git clone git@github.com:HKUST-Aerial-Robotics/infinity_uwb_ros.git
git clone https://github.com/gaowenliang/ptgrey_reader
cd ptgrey_reader
./autoinstall_tx2.sh

cd ~/swarm_ws
catkin_make

echo "source /home/dji/swarm_ws/devel/setup.bash"  >> ~/.bashrc
sudo cp  ~/SwarmAutoInstall/rc.local /etc/
sudo chown root /etc/rc.local
sudo chmod a+x /etc/rc.local
