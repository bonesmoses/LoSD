#!/bin/bash

VERSION=$(head -1 CHANGELOG | cut -d ' ' -f 2)

if [ ! -d build ]; then
  mkdir build
fi

for x in META-INF data system; do
  cp -a $x build
done

if [ ! -d build/data/local/LoSD ]; then
  mkdir -p build/data/local/LoSD
fi

cp -a README.markdown build/data/local/LoSD/README
cp -a CHANGELOG build/data/local/LoSD/

cd build

zip_file=LoSD-${VERSION}.Trifthen.zip
zip -r ${zip_file} META-INF data system
mv ${zip_file} ..

cd ..

echo
echo "Now you should sign ${zip_file} with signapk.jar"
echo
