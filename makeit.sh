#!/bin/bash
if [ -d "imb" ]; then
    rm -rf imb
fi    

mkdir imb

cd imb
javac -d ../imb ../src/main/java/com/mojang/mario/*.java ../src/main/java/com/mojang/mario/level/*.java ../src/main/java/com/mojang/mario/mapedit/*.java ../src/main/java/com/mojang/mario/sprites/*.java ../src/main/java/com/mojang/sonar/*.java ../src/main/java/com/mojang/sonar/mixer/*.java ../src/main/java/com/mojang/sonar/sample/*.java
cp -R ../src/main/resources/* ./
cp ../manifest.txt ./

jar cfm imb.jar manifest.txt ./
cp imb.jar ../

cd ..
rm -rf imb




