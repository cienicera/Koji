.PHONY: convert-json convert-cairo convert-to-midi

# Default input file path (can be a MIDI file or a structured format for cairo_to_midi)
INPUT_FILE ?= path/to/default/input/file
# Default output file path
OUTPUT_FILE ?= path/to/default/output

convert-json:
	python3 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).json --format json

convert-cairo:
	python3 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).cairo --format cairo

convert-to-midi:
	# Assuming cairo_to_midi can handle both Cairo and JSON structured inputs
	python3 python/cli.py $(INPUT_FILE) $(OUTPUT_FILE).mid --format midi
