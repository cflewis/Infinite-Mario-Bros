Infinite Mario Bros.
======================
This is a great mario game that will bring tons of fun to your day! Thank you Chris Lewis for putting this out there!<br>
I've added a full screen mode and the ability to exit the game by hitting escape.<br>
Also added some scripts to help compile the game.

[Infinite Mario Bros](http://www.mojang.com/notch/mario/) source code has a bug in the timing, which prevents it working on Mac OS X, and maybe other platforms. This version uses the timing from the Mario AI competition, and is Mac-compatible.


Compiling and running
---------------------
The following was tested on Ubuntu 16.04 and 18.04. At a minimum you'll need a JDK of at least 1.6.<br>
on Ubuntu you can install 1.8 like this. 

```bash
sudo apt-get install openjdk-8-jdk
```

* With Maven
if you dont have maven installed, this worked for me.
```bash
sudo apt-get install maven
```
Once installed, you can compile, package and run the resulting jar file.

```
mvn compile
mvn package
cd target
java -jar Mario-1.0-jar-with-dependencies.jar
```
* With gnu make
If you don't have make installed, this worked for me.

```bash
sudo apt-get install make
```
Once installed, you can compile, package and run the resulting jar file.

```bash
make
make run
```
You could also start the game by running a starter script created in the dist folder.

```bash
cd dist
./infinitemariobros
```

or you could run it full screen 

```bash
./infinitemariobros  f
```
to exit just hit escape.<br>

If you want to install the game.
```bash
sudo make install
```
This should install the game allowing you to start the game by clicking on its icon.<br>
You could open a terminal and start the game from the terminal.
```bash
infinitemariobros
```
or 
```bash
infinitemariobros f
```


* With java jdk

If you only wish to install the minimum, then all you need is a JDK to compile and run it.<br>
On windows make sure the jd


