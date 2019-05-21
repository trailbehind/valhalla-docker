#!/usr/bin/bash

add-apt-repository -y ppa:valhalla-core/valhalla
apt-get update -y
apt-get install -y \
    autoconf \
    automake \
    curl \
    cmake \
    make \
    libtool \
    pkg-config \
    g++ \
    gcc \
    git \
    jq \
    lcov \
    protobuf-compiler \
    vim-common \
    libboost-all-dev \
    libboost-all-dev \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libprime-server0.6.3-dev \
    libprotobuf-dev \
    prime-server0.6.3-bin \
    nodejs \
    npm \
    libgeos-dev \
    libgeos++-dev \
    liblua5.2-dev \
    libspatialite-dev \
    libsqlite3-dev \
    lua5.2 \
    libzmq3-dev \
    libczmq-dev \
    python-all-dev

if [[ $(grep -cF xenial /etc/lsb-release) > 0 ]]; then
    apt-get install -y libsqlite3-mod-spatialite;
fi

# Install Nodejs
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 10 && nvm use 10

# install prime server
git clone https://github.com/kevinkreiser/prime_server.git
cd prime_server
git submodule update --init --recursive
./autogen.sh
./configure
make test -j8
make install

cd ..

# Install Valhalla
git clone \
  --depth=1 \
  --recurse-submodules \
  --single-branch \
  --branch=master \
  https://github.com/trailbehind/valhalla.git valhalla

cd valhalla

git submodule update --init --recursive
npm install --ignore-scripts
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_DATA_TOOLS=On -DENABLE_SERVICES=On -DBUILD_SHARED_LIBS=On -DENABLE_PYTHON_BINDINGS=On
make -j$(nproc)
make install
