
ROOT_DIR=$(shell pwd)



apk : local.properties dependencies/OpenNI dependencies/OpenNI2 dependencies/SensorKinect dependencies/libopencl-stub dependencies/slambench ${ROOT_DIR}/app/include/TooN ${ROOT_DIR}/app/include/CL
	./gradlew assembleDebug --stacktrace



dep : local.properties dependencies/OpenNI dependencies/OpenNI2 dependencies/SensorKinect dependencies/libopencl-stub dependencies/slambench ${ROOT_DIR}/app/include/TooN ${ROOT_DIR}/app/include/CL

studio :
	wget https://dl.google.com/dl/android/studio/ide-zips/2.1.2.0/android-studio-ide-143.2915827-linux.zip
	unzip -qq android-studio-ide-143.2915827-linux.zip
	mkdir -p ~/.local/Android/
	mv android-studio ~/.local/Android/android-studio
	~/.local/Android/android-studio/bin/studio.sh

sdk :
	wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
	tar xzf android-sdk_r24.4.1-linux.tgz
	mkdir ~/.local/Android -p
	mv android-sdk-linux ~/.local/Android/Sdk
	~/.local/Android/Sdk/tools/android list sdk --all
	( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | ~/.local/Android/Sdk/tools/android update sdk   -u -a -t "platform-tools,tools,android-22,build-tools-22.0.1,extra-android-m2repository,addon-google_apis-google-22"

ndk :
	wget http://dl.google.com/android/repository/android-ndk-r10e-linux-x86_64.zip
	unzip -qq android-ndk-r10e-linux-x86_64.zip 
	mkdir ~/.local/Android -p
	mv android-ndk-r10e ~/.local/Android/android-ndk-r10e

prop :
	@echo "sdk.dir=$$HOME/.local/Android/Sdk" > ./local.properties
	@echo "ndk.dir=$$HOME/.local/Android/android-ndk-r10e" >> ./local.properties


local.properties :
	@echo "********************************************************************"
	@echo "The $@ is not found. Please produce this file. It should look like :"
	@echo "  sdk.dir=$$HOME/.local/Android/Sdk"
	@echo "  ndk.dir=$$HOME/.local/Android/Ndk"
	@echo "********************************************************************"
	@false


${ROOT_DIR}/app/include/CL:
	mkdir -p dependencies
	git clone https://github.com/KhronosGroup/OpenCL-Headers/ dependencies/OpenCL-Headers/
	mkdir ${ROOT_DIR}/app/include/CL/ && cd dependencies/OpenCL-Headers/ && cp *.h ${ROOT_DIR}/app/include/CL/
	rm dependencies/OpenCL-Headers/ -rf

${ROOT_DIR}/app/include/TooN: 
	mkdir -p dependencies
	git clone https://github.com/edrosten/TooN.git dependencies/TooN
	cd dependencies/TooN &&  git checkout 92241416d2a4874fd2334e08a5d417dfea6a1a3f
	cd dependencies/TooN && ./configure --prefix=${ROOT_DIR}/app/ --disable-lapack --enable-typeof=typeof && make install
	rm dependencies/TooN -rf
	rm ${ROOT_DIR}/app/lib -rf || true


clean :
	rm -rf .gradle/ .idea/ app/build/ app/include/CL/ app/include/TooN/	app/lib/
	rm -rf projectFilesBackup/ slambench-android.iml
