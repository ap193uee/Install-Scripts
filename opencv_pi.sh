sudo apt-get update
sudo apt-get upgrade

echo "Installing Dependenices"
sudo apt-get -y install build-essential cmake pkg-config
sudo apt-get -y install libgtk2.0-dev python-dev python-numpy

sudo apt-get -y install libtiff5-dev libjasper-dev libpng12-dev libjpeg8-dev

sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-0 libv4l-dev libx264-dev
sudo apt-get -y install libxine1-ffmpeg libxine-dev libxine1-bin libunicap2 libunicap2-dev libucil2 libucil2-dev

sudo apt-get install libgstreamer0.10-0 libgstreamer0.10-0-dbg libgstreamer0.10-dev gstreamer0.10-tools gstreamer0.10-plugins-base libgstreamer-plugins-base0.10-dev

sudo apt-get install libatlas-base-dev gfortran libeigen3-dev swig
sudo apt-get -y install apache2 nano htop 

sudo apt-get -y install libqt4-dev libqt4-opengl-dev  

cd ~
mkdir OpenCV
cd OpenCV
version="$(wget -q -O - http://sourceforge.net/projects/opencvlibrary/files/opencv-unix | egrep -m1 -o '\"[0-9](\.[0-9]+)+' | cut -c2-)"
echo "Downloading OpenCV" $version
wget -U=agent -O opencv-$version.zip http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$version/opencv-"$version".zip/download
echo "Installing OpenCV" $version
unzip opencv-$version.zip
cd opencv-$version
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_UNICAP=ON -D WITH_GSTREAMER=ON -D WITH_OPENGL=ON -D WITH_QT=ON ..

make
sudo make install
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
sudo sh -c 'echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH" >> /etc/bash.bashrc'
echo "OpenCV" $version "ready to be used"
