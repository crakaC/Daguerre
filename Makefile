PRODUCT_NAME := Daguerre

.PHONY: gen
gen:
	mint run xcodegen
	xed .

.PHONY: test
test:
	xcodebuild test -project $(PRODUCT_NAME).xcodeproj -scheme App -destination 'platform=iOS Simulator,name=iPhone 14'

.PHONY: uitest
uitest:
	xcodebuild test -project $(PRODUCT_NAME).xcodeproj -scheme UITest -destination 'platform=iOS Simulator,name=iPhone 14'
