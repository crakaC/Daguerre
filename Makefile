PRODUCT_NAME := Daguerre

.PHONY: gen
gen:
	mint run xcodegen --project . --project-root . --spec xcodegen/project.yml
	xed .

.PHONY: archive
archive:
	xcodebuild archive \
	    CODE_SIGNING_REQUIRED=NO \
	    CODE_SIGNING_ALLOWED=NO \
		-project $(PRODUCT_NAME).xcodeproj \
		-scheme App \
		-configuration Release \
		-archivePath ./build/$(PRODUCT_NAME)
	xcodebuild \
		-exportArchive \
		-archivePath ./build/$(PRODUCT_NAME).xcarchive \
		-exportPath ./build \
		-exportOptionsPlist ./exportOptions.plist \
		-allowProvisioningUpdates

.PHONY: test
test:
	xcodebuild test -project $(PRODUCT_NAME).xcodeproj -scheme App -destination 'platform=iOS Simulator,name=iPhone 14'

.PHONY: uitest
uitest:
	xcodebuild test -project $(PRODUCT_NAME).xcodeproj -scheme UITest -destination 'platform=iOS Simulator,name=iPhone 14'
