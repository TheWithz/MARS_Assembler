.PHONY: compile jar run debug clean

compile:
	docker run --rm -it \
		-v ${CURDIR}:/opt/app \
		-w /opt/app \
		openjdk:11 \
		javac -verbose --release 10 @java_files.txt

jar:
	docker run --rm -it \
		-v ${CURDIR}:/opt/app \
		-w /opt/app \
		openjdk:11 \
		jar --main-class=Mars --file=Mars.jar --verbose --create \
			PseudoOps.txt Config.properties Syscall.properties \
			Settings.properties MARSlicense.txt mainclass.txt \
			MipsXRayOpcode.xml registerDatapath.xml controlDatapath.xml \
			ALUcontrolDatapath.xml CreateMarsJar.bat CreateMarsJar.sh \
			Mars.java Mars.class docs help images mars

run:
	docker run --rm -it -e DISPLAY=${DISPLAY} \
		-v ${CURDIR}/Mars.jar:/opt/app/Mars.jar \
		-v ${SCRIPTS}:/opt/app/scripts \
		-v ${HOME}/.Xauthority:/home/developer/.Xauthority \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-w /opt/app \
		--net=host \
		thewithz/java11-gui:latest \
		java -jar Mars.jar

debug:
	docker run --rm -it -e DISPLAY=${DISPLAY} \
		-v ${CURDIR}:/opt/app \
		-v ${SCRIPTS}:/opt/app/scripts \
		-v ${HOME}/.Xauthority:/home/developer/.Xauthority \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-w /opt/app \
		--net=host \
		thewithz/java11-gui:latest \
		/opt/app/debug.sh

clean:
	find -D exec . -type f -name "*.class" -exec rm -f {} \;
