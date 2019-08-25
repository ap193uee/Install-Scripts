version=r1.5

apt install python3-dev python3-pip openjdk-8-jdk

pip3 install six numpy wheel mock
pip3 install --user keras_applications==1.0.6 --no-deps
pip3 install --user keras_preprocessing==1.0.5 --no-deps

# bazel installation
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" \
    | sudo tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -

apt update
apt install bazel

# Download tensoflow
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout $version

./configure
bazel build --config=opt --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
    --config=cuda //tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg