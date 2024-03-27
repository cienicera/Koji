.PHONY: convert-midi-to-json convert-json-to-midi convert-midi-to-cairo convert-cairo-to-midi convert-json-to-cairo convert-cairo-to-json

# Default input file path
INPUT_FILE ?= path/to/default/input/file
# Default output file path
OUTPUT_FILE ?= path/to/default/output

convert-midi-to-json:
	python3.11 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).json --conversion midi-to-json

convert-json-to-midi:
	python3.11 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).mid --conversion json-to-midi

convert-midi-to-cairo:
	python3 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).cairo --conversion midi-to-cairo

convert-cairo-to-midi:
	python3 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).mid --conversion cairo-to-midi

convert-json-to-cairo:
	python3 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).cairo --conversion json-to-cairo

convert-cairo-to-json:
	python3 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).json --conversion cairo-to-json
