#Install ros
#Installing ros

#Create workspace
mkdir -p ~/swarm_ws/src
cd ~/swarm_ws/src
#git clone git@github.com:HKUST-Aerial-Robotics/infinity_uwb_ros.git
cd ~/swarm_ws
catkin_make
echo "source /home/dji/swarm_ws/devel/setup.bash"  >> ~/.bashrc
sudo cp  ~/SwarmAutoInstall/rc.local /etc/
sudo chown root /etc/rc.local
sudo chmod a+x /etc/rc.local
