.PHONY: convert-json convert-cairo

# Default MIDI file and output file paths
MIDI_FILE ?= path/to/default/midi/file.mid
OUTPUT_FILE ?= path/to/default/output

convert-json:
	python3 python/cli.py $(MIDI_FILE) $(OUTPUT_FILE).json

convert-cairo:
	python3 python/cli.py $(MIDI_FILE) $(OUTPUT_FILE).cairo --format cairo
