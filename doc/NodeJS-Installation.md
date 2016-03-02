# NodeJS

From https://nodejs.org/:

> Node.js® is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices.

### Installation
```bash
mkdir -p ~/bin
tee ~/bin/install-nodejs > /dev/null <<"EOF"
#!/bin/bash
 
NODE_VERSION=v0.12.5
 
# Elevate privileges
echo "Your password is needed to install system software."
sudo ls > /dev/null
 
if [ ! -d ~/packages ];
then 
  mkdir ~/packages
fi
cd ~/packages
 
# Install Node.js
if [ ! -e ./node-v$NODE_VERSION.tar.gz ]; then
  echo "Fetching Node.js source code ..."
  wget http://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION.tar.gz
fi
 
echo "Unpacking Node.js source code ..."
tar xfz node-$NODE_VERSION.tar.gz
cd node-$NODE_VERSION/
 
echo "Configuring Node.js for builidng on this system ..."
./configure
 
echo "Building Node.js from source code ..."
make
 
echo "Installing Node.js on system ..."
sudo make install
 
echo "Done"
echo
EOF
 
chmod +x ~/bin/install-nodejs
~/bin/install-nodejs
```
