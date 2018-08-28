#Mocka Depenlibgsl-dev unt plz \n $
github_user=xuhao1
read -p "Enter your github passwd $" github_pwd
echo Will use $github_user and $github_pwd

sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update
sudo apt-get install libarmadillo-dev libusb-dev libspnav-dev libgsl-dev libgoogle-glog-dev  -y
sudo apt-get install libatlas-base-dev libsuitesparse-dev -y
sudo apt-get install gcc-7 g++-7 libdw-dev -y

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7
sudo update-alternatives --config gcc

sudo easy_install pip

sudo -H pip install pyquaternion
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

#Install ceres server
cd ~/source/ceres-solver/build
cmake ..    
#make -j4
sudo make install


#Create workspace
mkdir -p ~/swarm_ws/src
cd ~/swarm_ws/src
#git clone git@github.com:HKUST-Aerial-Robotics/infinity_uwb_ros.git
git clone https://github.com/xuhao1/ptgrey_reader.git
git clone https://$github_user:$github_pwd@github.com/xuhao1/swarm_pkgs.git
git clone https://github.com/groundmelon/camera_calibration_frontend.git
git clone -b UltraFast https://$github_user:$github_pwd@github.com/HKUST-Aerial-Robotics/VINS_Stereo.git
git clone https://$github_user:$github_pwd@github.com/xuhao1/mocka.git

cd ptgrey_reader
sudo ./script/autoinstall_tx2.sh

cd ~/swarm_ws
catkin_make

echo "source /home/dji/swarm_ws/devel/setup.bash"  >> ~/.bashrc
sudo cp  ~/SwarmAutoInstall/rc.local /etc/
sudo chown root /etc/rc.local
sudo chmod a+x /etc/rc.local
