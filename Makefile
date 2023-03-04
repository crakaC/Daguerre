PRODUCT_NAME := Daguerre

.PHONY: gen
gen:
	mint run xcodegen
	xed .