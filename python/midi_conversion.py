import json
import re

from mido import MidiFile, MidiTrack, MetaMessage, Message, tick2second, second2tick
from mido.midifiles import bpm2tempo

def midi_to_cairo_struct(midi_file, output_file):
    mid = MidiFile(midi_file)
    current_tempo = 500000  # Default MIDI tempo (500000 microseconds per beat)
    cairo_events = []

    for track in mid.tracks:
        cumulative_time = 0  # Keep track of cumulative time in ticks for delta calculation
        
        for msg in track:
             # Update the current tempo if a tempo change message is encountered
            if msg.type == 'set_tempo':
                current_tempo = msg.tempo

            # Calculate the time for the event
            time = format_fp32x32(cumulative_time, mid.ticks_per_beat, current_tempo)
            cumulative_time += msg.time  # Increment cumulative time

            if msg.type == 'note_on':
                cairo_events.append(
                    f"Message::NOTE_ON(NoteOn {{ channel: {msg.channel}, note: {msg.note}, velocity: {msg.velocity}, time: {time} }})")
            elif msg.type == 'note_off':
                cairo_events.append(
                    f"Message::NOTE_OFF(NoteOff {{ channel: {msg.channel}, note: {msg.note}, velocity: {msg.velocity}, time: {time} }})")
            elif msg.type == 'set_tempo':
                cairo_events.append(
                    f"Message::SET_TEMPO(SetTempo {{ tempo: {msg.tempo}, time: Option::Some({time}) }})")
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

def cairo_struct_to_midi(cairo_file, output_file):
    with open(cairo_file, 'r') as file:
        cairo_data = file.read()

    # Regex patterns to match different MIDI event types in the Cairo data
    note_on_pattern = re.compile(r"Message::NOTE_ON\(NoteOn \{ channel: (\d+), note: (\d+), velocity: (\d+), time: (.+?) \}\)")
    note_off_pattern = re.compile(r"Message::NOTE_OFF\(NoteOff \{ channel: (\d+), note: (\d+), velocity: (\d+), time: (.+?) \}\)")
    set_tempo_pattern = re.compile(r"Message::SET_TEMPO\(SetTempo \{ tempo: (.+?), time: (.+?) \}\)")
    time_signature_pattern = re.compile(r"Message::TIME_SIGNATURE\(TimeSignature \{ numerator: (\d+), denominator: (\d+), clocks_per_click: (\d+), time: None \}\)")
    control_change_pattern = re.compile(r"Message::CONTROL_CHANGE\(ControlChange \{ channel: (\d+), control: (\d+), value: (\d+), time: (.+?) \}\)")

    mid = MidiFile()
    track = MidiTrack()
    mid.tracks.append(track)

    for match in note_on_pattern.finditer(cairo_data):
        channel, note, velocity, time = match.groups()
        time = parse_fp32x32(time)
        track.append(Message('note_on', note=int(note), velocity=int(velocity), time=time, channel=int(channel)))

    for match in note_off_pattern.finditer(cairo_data):
        channel, note, velocity, time = match.groups()
        time = parse_fp32x32(time)
        track.append(Message('note_off', note=int(note), velocity=int(velocity), time=time, channel=int(channel)))

    for match in set_tempo_pattern.finditer(cairo_data):
        tempo, _ = match.groups()
        # Assume the tempo is directly usable or convert it as necessary
        tempo = parse_fp32x32(tempo)  # This may need adjustment based on your tempo representation
        track.append(MetaMessage('set_tempo', tempo=tempo, time=0))

    for match in time_signature_pattern.finditer(cairo_data):
        numerator, denominator, clocks_per_click = match.groups()
        # Assuming `mido` accepts time signature as integers directly
        track.append(MetaMessage('time_signature', numerator=int(numerator), denominator=int(denominator), clocks_per_click=int(clocks_per_click), notated_32nd_notes_per_beat=8, time=0))

    mid.save(output_file)

def midi_to_json(midi_file, output_file):
    mid = MidiFile(midi_file)
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

def format_fp32x32(delta_ticks, ticks_per_beat, current_tempo):
    delta_seconds = tick2second(delta_ticks, ticks_per_beat, current_tempo)
    fp32x32_time = int(delta_seconds * 1e6)  # Assuming we want microseconds precision
    return f"FP32x32 {{ mag: {fp32x32_time}, sign: false }}"

def parse_fp32x32(fp32x32_str):
    # Extract the magnitude part from the FP32x32 formatted string
    mag_match = re.search(r"mag: (\d+)", fp32x32_str)
    if mag_match:
        return int(mag_match.group(1))
    else:
        return 0
