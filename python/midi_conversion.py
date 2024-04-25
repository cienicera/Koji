import mido
import json
import re

from mido import MidiFile, MidiTrack, Message

def midi_to_cairo_struct(midi_file, output_file):
    mid = mido.MidiFile(midi_file)
    cairo_events = []

    for track in mid.tracks:
        for msg in track:
            time = format_fp32x32(msg.time)

            if msg.type == 'note_on':
                cairo_events.append(
                    f"Message::NOTE_ON(NoteOn {{ channel: {msg.channel}, note: {msg.note}, velocity: {msg.velocity}, time: {time} }})")
            elif msg.type == 'note_off':
                cairo_events.append(
                    f"Message::NOTE_OFF(NoteOff {{ channel: {msg.channel}, note: {msg.note}, velocity: {msg.velocity}, time: {time} }})")
            elif msg.type == 'set_tempo':
                cairo_events.append(
                    f"Message::SET_TEMPO(SetTempo {{ tempo: {format_fp32x32(msg.tempo)}, time: Option::Some({time}) }})")
            elif msg.type == 'time_signature':
                clocks_per_click = 24
                cairo_events.append(
                    f"Message::TIME_SIGNATURE(TimeSignature {{ numerator: {msg.numerator}, denominator: {msg.denominator}, clocks_per_click: {clocks_per_click}, time: None }})")
            elif msg.type == 'control_change':
                cairo_events.append(
                    f"Message::CONTROL_CHANGE(ControlChange {{ channel: {msg.channel}, control: {msg.control}, value: {msg.value}, time: {time} }})")
            elif msg.type == 'pitchwheel':
                cairo_events.append(
                    f"Message::PITCH_WHEEL(PitchWheel {{ channel: {msg.channel}, pitch: {msg.pitch}, time: {time} }})")
            elif msg.type == 'aftertouch':
                cairo_events.append(
                    f"Message::AFTER_TOUCH(AfterTouch {{ channel: {msg.channel}, value: {msg.value}, time: {time} }})")
            elif msg.type == 'polyphonic_key_pressure':
                cairo_events.append(
                    f"Message::POLY_TOUCH(PolyTouch {{ channel: {msg.channel}, note: {msg.note}, value: {msg.value}, time: {time} }})")

    cairo_code_start = "use koji::midi::types::{Midi, Message, NoteOn, NoteOff, SetTempo, TimeSignature, ControlChange, PitchWheel, AfterTouch, PolyTouch, Modes };\nuse orion::numbers::FP32x32;\n\nfn midi() -> Midi {\n    Midi {\n        events: array![\n"
    cairo_code_events = ',\n'.join(cairo_events)
    cairo_code_end = "\n        ].span()\n    }\n}"

    full_cairo_code = cairo_code_start + cairo_code_events + cairo_code_end

    with open(output_file, 'w') as file:
        file.write(full_cairo_code)

def cairo_to_midi_struct(cairo_file, output_file):
    with open(cairo_file, 'r') as file:
        track = MidiTrack()
        mid = MidiFile()
        mid.tracks.append(track)

        for line in file:
            # Match different MIDI event types in the Cairo data
            note_on_match = re.match(r"Message::NOTE_ON\(NoteOn \{ channel: (\d+), note: (\d+), velocity: (\d+), time: (.+?) \}\)", line)
            note_off_match = re.match(r"Message::NOTE_OFF\(NoteOff \{ channel: (\d+), note: (\d+), velocity: (\d+), time: (.+?) \}\)", line)
            set_tempo_match = re.match(r"Message::SET_TEMPO\(SetTempo \{ tempo: (.+?), time: (.+?) \}\)", line)
            time_signature_match = re.match(r"Message::TIME_SIGNATURE\(TimeSignature \{ numerator: (\d+), denominator: (\d+), clocks_per_click: (\d+), time: None \}\)", line)

            if note_on_match:
                channel, note, velocity, time = note_on_match.groups()
                time = parse_fp32x32(time)
                track.append(Message('note_on', note=int(note), velocity=int(velocity), time=time, channel=int(channel)))

            elif note_off_match:
                channel, note, velocity, time = note_off_match.groups()
                time = parse_fp32x32(time)
                track.append(Message('note_off', note=int(note), velocity=int(velocity), time=time, channel=int(channel)))

            elif set_tempo_match:
                tempo, _ = set_tempo_match.groups()
                # Assume the tempo is directly usable or convert it as necessary
                tempo = parse_fp32x32(tempo)  # This may need adjustment based on your tempo representation
                track.append(mido.MetaMessage('set_tempo', tempo=tempo, time=0))

            elif time_signature_match:
                numerator, denominator, clocks_per_click = time_signature_match.groups()
                # Assuming `mido` accepts time signature as integers directly
                track.append(mido.MetaMessage('time_signature', numerator=int(numerator), denominator=int(denominator), clocks_per_click=int(clocks_per_click), notated_32nd_notes_per_beat=8, time=0))

    mid.save(output_file)    

def midi_to_json(midi_file, output_file):
    mid = mido.MidiFile(midi_file)
    events = []

    for track in mid.tracks:
        for msg in track:
            event = {}
            time = msg.time

            if msg.type == 'note_on':
                event["NOTE_ON"] = {
                    "channel": msg.channel, "note": msg.note, "velocity": msg.velocity, "time": time}
            elif msg.type == 'note_off':
                event["NOTE_OFF"] = {
                    "channel": msg.channel, "note": msg.note, "velocity": msg.velocity, "time": time}
            elif msg.type == 'set_tempo':
                event["SET_TEMPO"] = {"tempo": msg.tempo, "time": None}
            elif msg.type == 'time_signature':
                event["TIME_SIGNATURE"] = {
                    "numerator": msg.numerator, "denominator": msg.denominator, "clocks_per_click": msg.clocks_per_click, "time": None}
            elif msg.type == 'control_change':
                event["CONTROL_CHANGE"] = {
                    "channel": msg.channel, "control": msg.control, "value": msg.value, "time": time}
            elif msg.type == 'pitchwheel':
                event["PITCH_WHEEL"] = {
                    "channel": msg.channel, "pitch": msg.pitch, "time": time}
            elif msg.type == 'aftertouch':
                event["AFTER_TOUCH"] = {
                    "channel": msg.channel, "value": msg.value, "time": time}
            elif msg.type == 'polyphonic_key_pressure':
                event["POLY_TOUCH"] = {
                    "channel": msg.channel, "note": msg.note, "value": msg.value, "time": time}

            if event:
                events.append(event)

    json_data = json.dumps({"events": events}, indent=4)

    with open(output_file, 'w') as file:
        file.write(json_data)


def format_fp32x32(time):
    return f"FP32x32 {{ mag: {time}, sign: false }}"

# Helper function to parse FP32x32 formatted string (needed for time, tempo, etc.)

def parse_fp32x32(fp32x32_str):
    # Extract the magnitude part from the FP32x32 formatted string
    mag_match = re.search(r"mag: (\d+), sign: (\w+)", fp32x32_str)
    if mag_match:
        mag = int(mag_match.group(1))
        return mag  # Return the magnitude value
    else:
        # Return a default value if parsing fails
        return 0
   
    # Uses fp32x32 to tick calculation
def parse_fp32x32_ticks(fp32x32_str, bpm=120, ticks_per_beat=480):
    # Extract the magnitude and sign parts from the FP32x32 formatted string
    mag_match = re.search(r"mag: (\d+), sign: (\w+)", fp32x32_str)
    if mag_match:
        mag = int(mag_match.group(1))
        sign = mag_match.group(2)
        # Check the sign and adjust the magnitude accordingly
        if sign == "true":
            mag = -mag
        
        # Calculate ticks per quarter note based on the provided BPM
        ticks_per_quarter_note = (60 * ticks_per_beat) / bpm
        
        # Convert magnitude to ticks and round to the nearest integer
        ticks = round(mag * ticks_per_quarter_note)
        
        return int(ticks)
    else:
        # Return a default value if parsing fails
        return 0
