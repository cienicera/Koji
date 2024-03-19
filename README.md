# Koji: A Cairo library for Autonomous Music

Autonomous Music library based on previous [work](https://github.com/caseywescott/MusicTools-StarkNet) made by Casey Wescott.

# Midi Conversion
Convert Midi to JSON format:
```bash
make convert-json INPUT_FILE="path/to/midi/file.mid" OUTPUT_FILE="path/to/output"
```

Convert to Cairo format:

```bash
make convert-cairo INPUT_FILE="path/to/midi/file.mid" OUTPUT_FILE="path/to/output"
```

Convert to Midi format:

```bash
make convert-to-midi INPUT_FILE="path/to/cairo/file.cairo" OUTPUT_FILE="path/to/output"
```