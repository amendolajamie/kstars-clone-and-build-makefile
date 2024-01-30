
all:
	@echo "All does nothing"
	@echo "----------------"
	@echo "Options:"
	@echo "clone -- clone the repo if empty"
	@echo "getstable -- get the latest stable version that I've tested to be stable"
	@echo "getmaster -- get master"
	@echo "build to build everything"
	@echo "buildkstars"
	@echo "buildphd2"
	@echo "buildstellarsolver"
	@echo "buildindi"
	@echo ""
	@echo "To update what's stable edit the Makefile. Save a copy of stable1 then update it, or use custom if experimenting"

####################### Clone ########################
/usr/local/indi:
	cd /usr/local; 	git clone https://github.com/indilib/indi.git;
	cd /usr/local/indi; git clone https://github.com/indilib/indi-3rdparty;

/usr/local/phd2:
	cd /usr/local; git clone https://github.com/OpenPHDGuiding/phd2.git

/usr/local/stellarsolver:
	cd /usr/local; git clone https://github.com/rlancaste/stellarsolver

/usr/local/kstars:
	cd /usr/local; git clone https://github.com/KDE/kstars

clone: /usr/local/indi /usr/local/phd2 /usr/local/stellarsolver /usr/local/kstars

killsource:
	rm -rf /usr/local/indi /usr/local/phd2 /usr/local/stellarsolver /usr/local/kstars

/usr/local/build:
	mkdir /usr/local/build

stable:
ifeq (${STABLE}, 1)
indi-tag=v1.9.3
indi-3rdparty-tag = v1.9.1
stellarsolver-tag = 1.8
phd2-tag = v2.6.10dev3
kstars-branch = stable-3.5.6
else
indi-tag = v1.9.6
indi-3rdparty-tag = v1.9.6
stellarsolver-tag = 2.3
phd2-tag = v2.6.11
kstars-tag = stable-3.5.9
endif

getstable: /usr/local/build stable
	cd /usr/local/indi; git fetch; git checkout tags/$(indi-tag); 
	cd /usr/local/indi/indi-3rdparty; git fetch; git checkout tags/$(indi-3rdparty-tag); 
	cd /usr/local/stellarsolver; git fetch; git checkout tags/$(stellarsolver-tag);
	cd /usr/local/phd2; git fetch; git checkout tags/$(phd2-tag);
	cd /usr/local/kstars; git fetch; git checkout $(kstars-tag);

getmaster: /usr/local/build clone
	cd /usr/local/indi; git fetch; git checkout master; git pull;
	cd /usr/local/indi/indi-3rdparty; git fetch; git checkout master; git pull;
	cd /usr/local/stellarsolver; git checkout master; git pull;
	cd /usr/local/phd2; git fetch; git checkout master; git pull;
	cd /usr/local/kstars; git fetch; git checkout master; git pull;

####################### Stellasolver ########################
/usr/local/build/stellarsolver:
	@echo "make dir"
	mkdir -p /usr/local/build/stellarsolver

/usr/local/build/stellarsolver/configured: /usr/local/build/stellarsolver
	@echo "configure"
	cd /usr/local/build/stellarsolver; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../stellarsolver; touch /usr/local/build/stellarsolver/configured

buildstellarsolver: /usr/local/build/stellarsolver/configured 
	@echo "build"
	cd /usr/local/build/stellarsolver; make ; sudo make install; touch /usr/local/build/stellarsolver/configured

rebuildstellarsolver: /usr/local/build/stellarsolver/configured 
	@echo "rebuild"
	rm -rf /usr/local/build/stellarsolver
	make buildstellarsolver

####################### PHD2 ########################
/usr/local/build/phd2:
	@echo "make dir"
	mkdir -p /usr/local/build/phd2

/usr/local/build/phd2/configured: /usr/local/build/phd2
	@echo "configure"
	cd /usr/local/build/phd2; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../phd2; touch /usr/local/build/phd2/configured

buildphd2: /usr/local/build/phd2/configured 
	@echo "build"
	cd /usr/local/build/phd2; make ; sudo make install; touch /usr/local/build/phd2/configured

rebuildphd2: /usr/local/build/phd2/configured 
	@echo "rebuild"
	rm -rf /usr/local/build/phd2
	make buildphd2

####################### KStars ########################
/usr/local/build/kstars:
	@echo "make dir"
	mkdir -p /usr/local/build/kstars

/usr/local/build/kstars/configured: /usr/local/build/kstars
	@echo "configure"
	cd /usr/local/build/kstars; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../kstars; touch /usr/local/build/kstars/configured

buildkstars: /usr/local/build/kstars/configured 
	@echo "build"
	cd /usr/local/build/kstars; make ; sudo make install; touch /usr/local/build/kstars/configured

rebuildkstars: /usr/local/build/kstars/configured 
	@echo "rebuild"
	rm -rf /usr/local/build/kstars
	make buildkstars

####################### Indi ########################
/usr/local/build/indi:
	@echo "make dir"
	mkdir -p /usr/local/build/indi

/usr/local/build/indi-3rdparty: /usr/local/build/indi
	@echo "make dir"
	mkdir -p /usr/local/build/indi-3rdparty
	mkdir -p /usr/local/build/indi-3rdparty/libasi
	mkdir -p /usr/local/build/indi-3rdparty/indi-asi
	mkdir -p /usr/local/build/indi-3rdparty/indi-gphoto
	mkdir -p /usr/local/build/indi-3rdparty/indi-eqmod
	mkdir -p /usr/local/build/indi-3rdparty/indi-gpsd

/usr/local/build/indi/configured: /usr/local/build/indi
	@echo "configure"
	cd /usr/local/build/indi; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../indi; touch /usr/local/build/indi/configured

/usr/local/build/indi-3rdparty/configured: /usr/local/build/indi-3rdparty
	@echo "configure"
	cd /usr/local/build/indi-3rdparty; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../indi-3rdparty; touch /usr/local/build/indi-3rdparty/configured

buildindi: /usr/local/build/indi-3rdparty/configured /usr/local/build/indi/configured  
	@echo "build"
	cd /usr/local/build/indi; make ; sudo make install; touch /usr/local/build/indi/configured
	cd /usr/local/build/indi-3rdparty; make ; sudo make install; touch /usr/local/build/indi-3rdparty/configured
	cd /usr/local/build/indi-3rdparty/libasi; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../../indi/indi-3rdparty/libasi; make; sudo make install;
	cd /usr/local/build/indi-3rdparty/indi-asi; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../../indi/indi-3rdparty/indi-asi; make; sudo make install;
	cd /usr/local/build/indi-3rdparty/indi-gphoto; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../../indi/indi-3rdparty/indi-gphoto;  make; sudo make install;
	cd /usr/local/build/indi-3rdparty/indi-eqmod; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../.././../indi/indi-3rdparty/indi-eqmod; make; sudo make install;
	cd /usr/local/build/indi-3rdparty/indi-gpsd; cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../../../indi/indi-3rdparty/indi-gpsd; make; sudo make install;

rebuildindi: /usr/local/build/indi/configured 
	@echo "rebuild"
	rm -rf /usr/local/build/indi
	rm -rf /usr/local/build/indi-3rdparty
	make buildindi

########################### All ###################################


build: buildindi buildstellarsolver buildphd2 buildkstars


rebuild: rebuildindi rebuildstellarsolver rebuildphd2 rebuildkstars
