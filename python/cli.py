import argparse
from midi_conversion import midi_to_cairo_struct, cairo_struct_to_midi, cairo_struct_to_json, json_to_cairo_struct, midi_to_json, json_to_midi

def main():
    parser = argparse.ArgumentParser(description='Convert between MIDI, Cairo, and JSON formats')
    parser.add_argument('input_file', type=str, help='Path to the input file')
    parser.add_argument('output_file', type=str, help='Path to the output file')
    parser.add_argument('--conversion', choices=['midi-to-json', 'midi-to-cairo', 'cairo-to-midi', 'cairo-to-json', 'json-to-cairo', 'json-to-midi'], help='Conversion type')

    args = parser.parse_args()

    if args.conversion == 'midi-to-json':
        midi_to_json(args.input_file, args.output_file)
        print(f"Converted {args.input_file} to JSON format in {args.output_file} ✅")
    elif args.conversion == 'json-to-midi':
        json_to_midi(args.input_file, args.output_file)
        print(f"Converted {args.input_file} from JSON format back to MIDI in {args.output_file} ✅")
    elif args.conversion == 'midi-to-cairo':
        midi_to_cairo_struct(args.input_file, args.output_file)
        print(f"Converted {args.input_file} to Cairo format in {args.output_file} ✅")
    elif args.conversion == 'cairo-to-midi':
        cairo_struct_to_midi(args.input_file, args.output_file)
        print(f"Converted {args.input_file} from Cairo format back to MIDI in {args.output_file} ✅")
    elif args.conversion == 'json-to-cairo':
        json_to_cairo_struct(args.input_file, args.output_file)
        print(f"Converted {args.input_file} from JSON to Cairo format in {args.output_file} ✅")
    elif args.conversion == 'cairo-to-json':
        cairo_struct_to_json(args.input_file, args.output_file)
        print(f"Converted {args.input_file} from Cairo to JSON format in {args.output_file} ✅")

if __name__ == '__main__':
    main()
