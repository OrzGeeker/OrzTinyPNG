DEST := /usr/local/bin/tiny

build:
	swift build --disable-sandbox --configuration release -Xswiftc --corss-module-optimization
	
install: build
	sudo mv .build/release/tiny ${DEST}
	sudo chmod 755 ${DEST}
	
uninstall:
	sudo rm ${DEST}
	
clean:
	rm -rf .build
