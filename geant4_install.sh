#!/bin/sh
#
# Auto Geant4 install
# Based on cmake_geant4 by github wdconinc
#
# Edit script for multithread etc
##################################
##################################
#               How to Run
##################################
#
# OLD
# http://geant4.cern.ch/support/source/geant4.${version}.tar.gz
# NEW
# http://cern.ch/geant4-data/releases/geant4.${version}.tar.gz
#
# From terminal
# chmod +x scratch_geant4.sh
#
#./scratch_geant4.sh <version>
#
# ./scratch_geant4.sh 10.02.p02
#
#      <version> format
# Geant 4 version 00 . sub 00 . patch  p00 (if applicable)
#       .   10    .   02   . p02


version=$1
origdir=`dirname $0`

cd /scratch/
mkdir -p applications
cd applications

echo "Downloading geant4.${version}.tar.gz..."
until test -f geant4.${version}.tar.gz
do wget http://cern.ch/geant4-data/releases/geant4.${version}.tar.gz
done

echo "Unpacking geant4.${version}.tar.gz..."
until test -d geant4.${version}
do tar -zxvf geant4.${version}.tar.gz
done

mkdir -p geant4.${version}-build
mkdir -p geant4.${version}-install
cd geant4.${version}-build

echo "Configuring geant4.${version}..."
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
 -DCMAKE_INSTALL_PREFIX=../geant4.${version}-install \
 -DGEANT4_USE_GDML=ON \
 -DGEANT4_INSTALL_DATA=ON \
 -DGEANT4_USE_OPENGL_X11=ON \
 -DGEANT4_USE_QT=ON \
 -DGEANT4_USE_RAYTRACER_X11=ON \
 -DGEANT4_BUILD_MULTITHREADED=ON \
 -DGEANT4_USE_SYSTEM_CLHEP=OFF \
 -DGEANT4_USE_SYSTEM_EXPAT=ON \
 -DXERCESC_LIBRARY=/usr/lib/x86_64-linux-gnu/libxerces-c.so \
 ../geant4.${version}

j=`cat /proc/cpuinfo | grep processor | wc -l`
echo "Make will use $j parallel jobs."

echo "Building geant4.${version}..."
make -j $j -k

echo "Installing geant4.${version}..."
make -j $j install

cd "${origdir}"
