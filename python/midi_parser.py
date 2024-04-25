import mido

# Utility to print Midi Messages directly from a .mid file.


def parse_midi_file(file_path):
    mid = mido.MidiFile(file_path)

    # List to store parsed messages
    messages = []

    for track in mid.tracks:
        for msg in track:
            # Convert MIDI messages to Mido messages
            if msg.type == 'note_on':
                message = mido.Message('note_on', note=msg.note, velocity=msg.velocity, channel=msg.channel, time=msg.time)
            elif msg.type == 'note_off':
                message = mido.Message('note_off', note=msg.note, velocity=msg.velocity, channel=msg.channel, time=msg.time)
            elif msg.type == 'control_change':
                message = mido.Message('control_change', control=msg.control, value=msg.value, channel=msg.channel, time=msg.time)
            # Add more elif conditions for other message types as needed

            # Append the parsed message to the list
            messages.append(message)

    return messages

# Example usage
midi_messages = parse_midi_file('/your/file.mid')
for msg in midi_messages:
    print(msg)
