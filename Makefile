
###############Paths####################################################
DESTDIR        =
DESTDIR_B4     = $(DESTDIR)/..
PREFIX         = $(DESTDIR)/usr/lib
STARTDIR       = $(DESTDIR)/usr/bin
ICONDIR        = $(DESTDIR)/usr/share/doc/$(JPACKAGE)
DESKTOPDIR     = $(DESTDIR)/usr/share/applications
MANDIR         = $(DESTDIR)/usr/share/man/man7
#Desktop file paths
DESTDIRI       = $(DESTDIR)
PREFIXI        = $(PREFIX)
STARTDIRI      = $(STARTDIR)
ICONDIRI       = $(ICONDIR)
##############Program specific info.####################################
CP             = .
JPACKAGE       = infinitemariobros
MAIN           = com.mojang.mario.FrameLauncher
SOURCEDIR      = src/main/java/com/mojang
FILENAME       = infinitemariobros.jar
SOURCEFILES    = $(SOURCEDIR)/sonar/SoundListener.java \
                 $(SOURCEDIR)/sonar/SoundSource.java \
                 $(SOURCEDIR)/sonar/SonarSoundEngine.java \
                 $(SOURCEDIR)/sonar/FixedSoundSource.java \
                 $(SOURCEDIR)/sonar/StereoSoundProducer.java \
                 $(SOURCEDIR)/sonar/sample/SampleLoader.java \
                 $(SOURCEDIR)/sonar/sample/SamplePlayer.java \
                 $(SOURCEDIR)/sonar/sample/SonarSample.java \
                 $(SOURCEDIR)/sonar/SoundProducer.java \
                 $(SOURCEDIR)/sonar/FakeSoundEngine.java \
                 $(SOURCEDIR)/sonar/mixer/ListenerMixer.java \
                 $(SOURCEDIR)/sonar/mixer/Sound.java \
                 $(SOURCEDIR)/mario/Recorder.java \
                 $(SOURCEDIR)/mario/Art.java \
                 $(SOURCEDIR)/mario/sprites/Fireball.java \
                 $(SOURCEDIR)/mario/sprites/Particle.java \
                 $(SOURCEDIR)/mario/sprites/FlowerEnemy.java \
                 $(SOURCEDIR)/mario/sprites/SpriteContext.java \
                 $(SOURCEDIR)/mario/sprites/Enemy.java \
                 $(SOURCEDIR)/mario/sprites/Sprite.java \
                 $(SOURCEDIR)/mario/sprites/Mario.java \
                 $(SOURCEDIR)/mario/sprites/Sparkle.java \
                 $(SOURCEDIR)/mario/sprites/BulletBill.java \
                 $(SOURCEDIR)/mario/sprites/FireFlower.java \
                 $(SOURCEDIR)/mario/sprites/CoinAnim.java \
                 $(SOURCEDIR)/mario/sprites/Shell.java \
                 $(SOURCEDIR)/mario/sprites/Mushroom.java \
                 $(SOURCEDIR)/mario/AppletLauncher.java \
                 $(SOURCEDIR)/mario/TitleScene.java \
                 $(SOURCEDIR)/mario/WinScene.java \
                 $(SOURCEDIR)/mario/MarioComponent.java \
                 $(SOURCEDIR)/mario/Scene.java \
                 $(SOURCEDIR)/mario/Replayer.java \
                 $(SOURCEDIR)/mario/LevelScene.java \
                 $(SOURCEDIR)/mario/FrameLauncher.java \
                 $(SOURCEDIR)/mario/FullScreenFrameLauncher.java \
                 $(SOURCEDIR)/mario/BgRenderer.java \
                 $(SOURCEDIR)/mario/MapScene.java \
                 $(SOURCEDIR)/mario/Scale2x.java \
                 $(SOURCEDIR)/mario/level/ImprovedNoise.java \
                 $(SOURCEDIR)/mario/level/SpriteTemplate.java \
                 $(SOURCEDIR)/mario/level/BgLevelGenerator.java \
                 $(SOURCEDIR)/mario/level/Level.java \
                 $(SOURCEDIR)/mario/level/LevelGenerator.java \
                 $(SOURCEDIR)/mario/mapedit/LevelEditView.java \
                 $(SOURCEDIR)/mario/mapedit/TilePicker.java \
                 $(SOURCEDIR)/mario/mapedit/LevelEditor.java \
                 $(SOURCEDIR)/mario/LevelRenderer.java \
                 $(SOURCEDIR)/mario/LoseScene.java
             
##############Compiler and JVM info#####################################
JC             = javac
JRT            = java
JAR            = jar
JCFLAGS        = -source 1.6 -target 1.6 -d ./$(JPACKAGE)
##############Desktop file fields#######################################
TITLE          = "Infinite Mario Bros."
COMMENT        = "Infinite Mario Bros."
CATEGORIES     = "Game"
##############control file##############################################
# Source section
SOURCE         = $(JPACKAGE)
SECTION        = "x11"
PRIORITY       = "optional"
MAINTAINER     = "qbancoffee"
EMAIL          = "qbancoffee@yahoo.com"
STDVER         = "3.9.7"
BUILDDEPENDS   = "gzip (>=1.5), debhelper (>=9), default-jre | \
java8-runtime"

# Package section
DESCRIPTION    = " Slightly more compatible version of Infinite Mario."
EXTDESCRIPTION = " Java based Mario Bros. clone that's a mashup of various \
Mario Bros. versions."
ARCH           = "all"
HOMEPAGE       = "https://github.com/cflewis/Infinite-Mario-Bros"
DEPENDS        = "\$${misc:Depends}, jarwrapper, default-jre | \
java7-runtime"
##############MISC######################################################
MAKEDEB        = 0



all: clean createdirs build copyres archive dist makescript desktop

createdirs:
	mkdir -p $(JPACKAGE)

build:
	$(JC) $(JCFLAGS) -cp $(CP) $(JDP) $(SOURCEFILES)

copyres:
	cp -R ./src/main/resources/* $(JPACKAGE)

archive:
	$(JAR) cfm $(FILENAME) manifest.txt -C $(JPACKAGE) .

dist:
	$(RM) -r ./dist
	mkdir ./dist
	cp $(FILENAME) dist
	rm $(FILENAME)
desktop:
	echo "[Desktop Entry]" > $(JPACKAGE).desktop
	echo "Comment="$(COMMENT) >> $(JPACKAGE).desktop
	echo "Terminal=false" >> $(JPACKAGE).desktop
	echo "Name="$(TITLE) >> $(JPACKAGE).desktop
	echo "Exec=$(STARTDIRI)/$(JPACKAGE)" >> $(JPACKAGE).desktop
	echo "Type=Application" >> $(JPACKAGE).desktop
	echo "Icon=$(ICONDIRI)/icon.png" >> $(JPACKAGE).desktop
	echo "NoDisplay=false" >> $(JPACKAGE).desktop
	echo "Categories="$(CATEGORIES) >> $(JPACKAGE).desktop
run:
	$(JRT) -cp $(CP):dist/$(FILENAME) $(MAIN)

install:
	mkdir -p $(PREFIX)/$(JPACKAGE)
	mkdir -p $(ICONDIR)
	mkdir -p $(STARTDIR)
	mkdir -p $(DESKTOPDIR)
	mkdir -p $(MANDIR)
	
	cp dist/$(FILENAME) $(PREFIX)/$(JPACKAGE)
	chmod +x $(PREFIX)/$(JPACKAGE)/$(FILENAME)
	echo "#!/bin/bash" > $(STARTDIR)/$(JPACKAGE)
	echo 'MAINCLASS="$(MAIN)"' >> $(STARTDIR)/$(JPACKAGE)
	echo 'OPTION=$$1"s"' >> $(STARTDIR)/$(JPACKAGE)
	echo 'if [ "$$OPTION" == "fs" ]; then' >> $(STARTDIR)/$(JPACKAGE)
	echo     'MAINCLASS="com.mojang.mario.FullScreenFrameLauncher"' >> $(STARTDIR)/$(JPACKAGE)
	echo 'fi' >> $(STARTDIR)/$(JPACKAGE)
	echo 'java -cp $(CP):$(PREFIXI)/$(JPACKAGE)/$(FILENAME) $$MAINCLASS' >> $(STARTDIR)/$(JPACKAGE)
	chmod +x $(STARTDIR)/$(JPACKAGE)
	cp icon.png $(ICONDIR)
	cp copyright $(ICONDIR)
	cp $(JPACKAGE).desktop $(DESKTOPDIR)
	gzip -9 --no-name -c changelog > $(ICONDIR)/changelog.gz
	gzip -9 --no-name -c $(JPACKAGE).7 > $(MANDIR)/$(JPACKAGE).7.gz

ifeq ($(MAKEDEB),1)
	mkdir -p $(DESTDIR)/DEBIAN
	echo "#!/bin/bash" > $(DESTDIR)/DEBIAN/postinst
	echo "set -e" >> $(DESTDIR)/DEBIAN/postinst
	chmod +x $(DESTDIR)/DEBIAN/postinst

	
endif
	
uninstall:
	$(RM) $(STARTDIR)/$(JPACKAGE)
	$(RM) $(PREFIX)/$(JPACKAGE)/$(FILENAME)
	$(RM) $(ICONDIR)/*
	rmdir $(ICONDIR)
	rmdir $(PREFIX)/$(JPACKAGE)
	
deb:
	mkdir -p $(DESTDIR)/usr/lib
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/usr/share/applications
	mkdir -p $(DESTDIR)/DEBIAN
	mkdir -p $(DESTDIR_B4)/source
	
	echo "Source: "$(SOURCE) > $(DESTDIR_B4)/control
	echo "Section: "$(SECTION) >> $(DESTDIR_B4)/control
	echo "Priority: "$(PRIORITY) >> $(DESTDIR_B4)/control
	echo "Maintainer: "$(MAINTAINER)" <"$(EMAIL)">" >> $(DESTDIR_B4)/control
	echo "Standards-Version: "$(STDVER) >> $(DESTDIR_B4)/control
	echo "Build-Depends: "$(BUILDDEPENDS) >> $(DESTDIR_B4)/control
	echo "" >> $(DESTDIR_B4)/control
	
	echo "Package: "$(JPACKAGE) >> $(DESTDIR_B4)/control
	echo "Description: "$(DESCRIPTION) >> $(DESTDIR_B4)/control
	echo $(EXTDESCRIPTION) >> $(DESTDIR_B4)/control
	echo "Architecture: "$(ARCH) >> $(DESTDIR_B4)/control
	echo "Homepage: "$(HOMEPAGE) >> $(DESTDIR_B4)/control
	echo "Depends: "$(DEPENDS) >> $(DESTDIR_B4)/control
	
	echo "#!/usr/bin/make -f"  > $(DESTDIR_B4)/rules
	echo "%:" >> $(DESTDIR_B4)/rules
	echo "	dh \$$@"  >> $(DESTDIR_B4)/rules
	echo ""  >> $(DESTDIR_B4)/rules
	echo "binary:"  >> $(DESTDIR_B4)/rules
	echo "	make install DESTDIR=$(DESTDIR) DESTDIRI=/usr PREFIXI=/usr/lib STARTDIRI=/usr/bin MAKEDEB=1"  >> $(DESTDIR_B4)/rules
	echo "	dh_gencontrol"  >> $(DESTDIR_B4)/rules
	echo "	dh_builddeb"  >> $(DESTDIR_B4)/rules
	chmod +x $(DESTDIR_B4)/rules
	
	echo "1.0" > $(DESTDIR_B4)/source/format
	
	
	echo "9" > $(DESTDIR_B4)/compat

	
	cp changelog $(DESTDIR_B4)/changelog
	cp copyright $(DESTDIR_B4)/copyright
	cp LICENSE $(DESTDIR_B4)/LICENSE
	cp license.txt $(DESTDIR_B4)

makescript:
	echo "#!/bin/bash" > ./dist/$(JPACKAGE)
	echo 'MAINCLASS="$(MAIN)"' >> ./dist/$(JPACKAGE)
	echo 'OPTION=$$1"s"' >> ./dist/$(JPACKAGE)
	echo 'if [ "$$OPTION" == "fs" ]; then' >> ./dist/$(JPACKAGE)
	echo     'MAINCLASS="com.mojang.mario.FullScreenFrameLauncher"' >> ./dist/$(JPACKAGE)
	echo 'fi' >> ./dist/$(JPACKAGE)
	echo 'java -cp $(CP):$(FILENAME) $$MAINCLASS' >> ./dist/$(JPACKAGE)
	chmod +x ./dist/$(JPACKAGE)
		
clean:
	$(RM) -r ./$(JPACKAGE)
	$(RM) -r ./dist
	$(RM) $(JPACKAGE).desktop
