import mido
import json

def midi_to_json(midi_file):
    mid = mido.MidiFile(midi_file)
    events = []

    for track in mid.tracks:
        for msg in track:
            event = {}
            time = msg.time

            if msg.type == 'note_on':
                event["NOTE_ON"] = {"channel": msg.channel, "note": msg.note, "velocity": msg.velocity, "time": time}
            elif msg.type == 'note_off':
                event["NOTE_OFF"] = {"channel": msg.channel, "note": msg.note, "velocity": msg.velocity, "time": time}
            elif msg.type == 'set_tempo':
                event["SET_TEMPO"] = {"tempo": msg.tempo, "time": None}
            elif msg.type == 'time_signature':
                event["TIME_SIGNATURE"] = {"numerator": msg.numerator, "denominator": msg.denominator, "clocks_per_click": msg.clocks_per_click, "time": None}
            elif msg.type == 'control_change':
                event["CONTROL_CHANGE"] = {"channel": msg.channel, "control": msg.control, "value": msg.value, "time": time}
            elif msg.type == 'pitchwheel':
                event["PITCH_WHEEL"] = {"channel": msg.channel, "pitch": msg.pitch, "time": time}
            elif msg.type == 'aftertouch':
                event["AFTER_TOUCH"] = {"channel": msg.channel, "value": msg.value, "time": time}
            elif msg.type == 'polyphonic_key_pressure':
                event["POLY_TOUCH"] = {"channel": msg.channel, "note": msg.note, "value": msg.value, "time": time}

            if event:
                events.append(event)

    return json.dumps({"events": events}, indent=4)

# Example usage
midi_json = midi_to_json('example/YungTruong.mid')
print(midi_json)
