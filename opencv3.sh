CUDA=0
GSTREAMER=1
FFMPEG=1
QT5=1 
CONTRIB=1
version=3.3.0

apt-get update
apt-get upgrade

echo "-----Installing Dependenices----"
apt-get -y install build-essential cmake pkg-config libgtk-3-dev unzip git wget

echo "-----Installing Python libraries----"
apt-get -y install python-dev python-numpy

echo "-----Installing Image libraries----"
apt-get -y install libtiff5-dev libjasper-dev libpng12-dev libjpeg-dev

echo "-----Installing Linear Algebra libraries----"
apt-get -y install libatlas-base-dev gfortran libeigen3-dev swig libtbb-dev yasm liblapacke-dev libatlas-dev libopenblas-dev

echo "-----Installing camera related libraries----"
apt-get -y install libv4l-dev libdc1394-22-dev

if [ $QT5 -eq 1 ]
then    
    echo "-----Installing QT5 libraries----"
    apt-get -y install qtbase5-dev
else
    echo "-----Installing QT4 libraries-----"
    apt-get -y install libqt4-dev libqt4-opengl-dev
fi

if [ $FFMPEG -eq 1 ]
then    
    echo "-----Installing ffmpeg libraries-----"
    apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libfaac-dev libtheora-dev \
                        libvorbis-dev libxvidcore-dev libswresample-dev libx264-dev
    cmake_ffmpeg=-DWITH_FFMPEG=ON
else
    cmake_ffmpeg=-DWITH_FFMPEG=OFF
fi

if [ $GSTREAMER -eq 1 ]
then
    echo "-----Installing gstreamer libraries-----"
    apt-get -y install libgstreamer1.0-0 libgstreamer1.0-dev gstreamer1.0-tools libgstreamer-plugins-base1.0-dev \
                            gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-libav
    cmake_gstreamer=-DWITH_GSTREAMER=ON
else
    cmake_gstreamer=-DWITH_GSTREAMER=OFF
fi

if [ $CUDA -eq 1 ]
then
    apt-get -y install libglew-dev
    cmake_cuda=-DWITH_CUDA=ON" "
    cmake_cuda+=-DENABLE_FAST_MATH=1" "
    cmake_cuda+=-DCUDA_FAST_MATH=1" "
    cmake_cuda+=-DWITH_CUBLAS=1
else
    cmake_cuda=-DWITH_CUDA=OFF
fi

if [ $CONTRIB -eq 1 ]
then
    apt-get -y install libprotobuf-dev protobuf-compiler 
    apt-get -y install libgoogle-glog-dev libgflags-dev libhdf5-serial-dev
    cmake_contrib=-DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules
fi

# Optional Dependencies
# apt-get -y install libopenexr-dev zlib1g-dev libgphoto2-dev libmp3lame-dev 
# apt-get -y install python-tk libvtk5-qt4-dev

#version="$(wget -q -O - http://sourceforge.net/projects/opencvlibrary/files/opencv-unix | egrep -m1 -o '\"[0-9](\.[0-9]+)+' | cut -c2-)"
echo "-------Downloading OpenCV" $version "at " $HOME "------"
cd $HOME
mkdir OpenCV
cd OpenCV
wget -U=agent -O opencv-$version.zip https://github.com/Itseez/opencv/archive/"$version".zip
unzip opencv-$version.zip

if [ $CONTRIB -eq 1 ]
then
    echo "-------Downloading OpenCV contrib library-----"
    git clone https://github.com/opencv/opencv_contrib.git
    cd opencv_contrib
    git checkout $version
    cd ..
fi

echo "------Installing OpenCV" $version "------"
cd opencv-$version
mkdir build
cd build

cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D WITH_TBB=ON \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        $cmake_gstreamer \
        $cmake_ffmpeg \
        $cmake_cuda \
        $cmake_contrib \
        -DBUILD_opencv_java=OFF \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D BUILD_EXAMPLES=ON ..
make -j"$(nproc)"
make install

echo "-------Setting paths------"
sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
ldconfig
sh -c 'echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH" >> /etc/bash.bashrc'
echo "OpenCV" $version " is ready to be used"
