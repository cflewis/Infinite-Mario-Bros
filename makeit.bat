echo off

IF EXIST .\infinitemariobros goto deleteimb
mkdir infinitemariobros

javac -source 1.6 -target 1.6 -d .\infinitemariobros .\src\main\java\com\mojang\mario\*.java .\src\main\java\com\mojang\mario\level\*.java .\src\main\java\com\mojang\mario\mapedit\*.java .\src\main\java\com\mojang\mario\sprites\*.java .\src\main\java\com\mojang\sonar\*.java .\src\main\java\com\mojang\sonar\mixer\*.java .\src\main\java\com\mojang\sonar\sample\*.java
xcopy src\main\resources\*  infinitemariobros /E/Y

jar cfm infinitemariobros.jar manifest.txt -C .\infinitemariobros . 


IF EXIST .\dist goto deletedist

:deletedist
del /q /s .\dist  > nul
rmdir /q /s .\dist  > nul
:exit

:deleteimb
del /q /s .\infinitemariobros > nul
rmdir /q /s .\infinitemariobros > nul
:exit

mkdir .\dist
move /y infinitemariobros.jar .\dist > nul
del /s /q .\infinitemariobros  > nul
rmdir /s /q .\infinitemariobros  > nul


