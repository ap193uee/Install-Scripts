sudo apt-get update -y

echo "Installing Caffe Dependencies..."
sudo apt-get install -y build-essential cmake git gfortran libgflags-dev libgoogle-glog-dev libhdf5-serial-dev liblmdb-dev
sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler

echo "Installing boost library..."
sudo apt-get install --no-install-recommends libboost-all-dev -y

echo "Installing atlas library..."
sudo apt-get install libatlas-base-dev -y

sudo apt-get install python-dev python-numpy python-h5py -y

echo "Cloning Caffe into the home directory..."
cd $HOME
git clone http://github.com/NVIDIA/caffe

echo "Installing python requirements..."
cd caffe
sudo pip install -r python/requirements.txt

echo "Compiling Caffe ..."
mkdir build
cd build
cmake ..
make -j4 all
make pycaffe

echo "Running Caffe Tests..."
make -j4 runtest

echo "Done!"