import argparse
from midi_conversion import midi_to_cairo_struct, midi_to_json


def main():
    parser = argparse.ArgumentParser(
        description='Convert MIDI files to Cairo or JSON format')
    parser.add_argument('midi_file', type=str,
                        help='Path to the input MIDI file')
    parser.add_argument('output_file', type=str,
                        help='Path to the output file')
    parser.add_argument(
        '--format', choices=['cairo', 'json'], default='json', help='Output format: cairo or json')

    args = parser.parse_args()

    if args.format == 'cairo':
        midi_to_cairo_struct(args.midi_file, args.output_file)
        print(
            f"Converted {args.midi_file} to Cairo format in {args.output_file} ✅")
    elif args.format == 'json':
        midi_to_json(args.midi_file, args.output_file)
        print(
            f"Converted {args.midi_file} to JSON format in {args.output_file} ✅")


if __name__ == '__main__':
    main()
