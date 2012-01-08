default:

clean:
	-rm -rf build/*

test:
	GHUNIT_CLI=1 xcodebuild -project ../OPLocationKit.xcodeproj -target OPLocationKitTests -configuration Debug -sdk iphonesimulator build
