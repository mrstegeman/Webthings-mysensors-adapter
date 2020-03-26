#!/bin/bash

set -e

version=$(grep version package.json | cut -d: -f2 | cut -d\" -f2)


# Clean up from previous releases
rm -rf *.tgz package
rm -f SHA256SUMS
rm -rf lib
rm -rf ._*

# Put package together
mkdir package
mkdir lib

# Pull down Python dependencies
pip3 install -r requirements.txt -t lib --no-binary pymysensors,paho-mqtt --prefix ""

#temporary fix
#cp VERSION ./lib/mysensors/

cp -r pkg lib LICENSE package.json manifest.json *.py setup.cfg requirements.txt package/
find package -type f -name '*.pyc' -delete
#find package -type d -empty -delete

# Generate checksums
cd package
#sha256sum *.py pkg/*.py LICENSE > SHA256SUMS
find . -type f \! -name SHA256SUMS -exec sha256sum {} \; >> SHA256SUMS
cd -

# Make the tarball
tar czf "mysensors-adapter-${version}.tgz" package
sha256sum "mysensors-adapter-${version}.tgz"
#sudo systemctl restart mozilla-iot-gateway.service

