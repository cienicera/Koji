import json
import re
from mido import MidiFile, MetaMessage, MidiTrack, Message


def midi_to_cairo_struct(midi_file, output_file):
    mid = MidiFile(midi_file)
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

def cairo_struct_to_midi(cairo_file, output_file):
    with open(cairo_file, 'r') as file:
        cairo_data = file.read()

    # Regex patterns to match different MIDI event types in the Cairo data
    note_on_pattern = re.compile(r"Message::NOTE_ON\(NoteOn \{ channel: (\d+), note: (\d+), velocity: (\d+), time: (.+?) \}\)")
    note_off_pattern = re.compile(r"Message::NOTE_OFF\(NoteOff \{ channel: (\d+), note: (\d+), velocity: (\d+), time: (.+?) \}\)")
    set_tempo_pattern = re.compile(r"Message::SET_TEMPO\(SetTempo \{ tempo: (.+?), time: (.+?) \}\)")
    time_signature_pattern = re.compile(r"Message::TIME_SIGNATURE\(TimeSignature \{ numerator: (\d+), denominator: (\d+), clocks_per_click: (\d+), time: None \}\)")

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
        track.append(MetaMessage('time_signature', numerator=int(numerator), denominator=int(denominator), clocks_per_click=int(clocks_per_click), notated_32nd_notes_per_beat=8, time=0))

    mid.save(output_file)

def cairo_struct_to_json(cairo_file, output_file):
    with open(cairo_file, 'r') as file:
        cairo_data = file.read()

    # Regex patterns for parsing the Cairo structured data
    # Adjust these regexes to match your specific Cairo structure accurately
    message_pattern = re.compile(r"Message::(\w+)\((\w+) \{ ([^\}]+) \}\)")
    
    # Function to convert Cairo FP32x32 format to a standard numerical representation
    def parse_fp32x32(value):
        match = re.match(r"FP32x32 \{ mag: (\d+), sign: (true|false) \}", value)
        if match:
            magnitude = int(match.group(1))
            sign = -1 if match.group(2) == 'true' else 1
            return magnitude * sign
        return value  # Return original value if the pattern does not match

    events = []
    for match in message_pattern.finditer(cairo_data):
        message_type, _, param_str = match.groups()
        params = {}
        for param in param_str.split(', '):
            key, value = param.split(': ', 1)
            if "FP32x32" in value:
                value = parse_fp32x32(value)
            elif value.isdigit():
                value = int(value)  # Convert numeric strings to integers
            params[key] = value

        # Create the event dictionary with the message type as the key
        event = {message_type: params}
        events.append(event)

    # Convert the list of events to JSON format
    json_data = json.dumps({"events": events}, indent=4)

    # Write the JSON data to the output file
    with open(output_file, 'w') as file:
        file.write(json_data)

def json_to_cairo_struct(json_file, output_file):
    with open(json_file, 'r') as file:
        json_data = json.load(file)

    cairo_events = []
    for event in json_data["events"]:
        for message_type, params in event.items():
            if params.get("time") is not None:
                params["time"] = f'FP32x32 {{ mag: {params["time"]}, sign: false }}'
            if "velocity" in params:
                params["velocity"] = f'{params["velocity"]}'
            if "tempo" in params:
                params["tempo"] = f'FP32x32 {{ mag: {params["tempo"]}, sign: false }}'
            if "value" in params:
                params["value"] = f'{params["value"]}'
            if "pitch" in params:
                params["pitch"] = f'{params["pitch"]}'

            param_str = ', '.join([f"{key}: {value}" for key, value in params.items() if value is not None])
            cairo_event = f"Message::{message_type}({message_type} {{ {param_str} }})"
            cairo_events.append(cairo_event)

    # Assemble the Cairo code structure based on the events
    cairo_code_start = "use koji::midi::types::{Midi, Message, NoteOn, NoteOff, SetTempo, TimeSignature, ControlChange, PitchWheel, AfterTouch, PolyTouch, Modes};\nuse orion::numbers::FP32x32;\n\nfn midi() -> Midi {\n    Midi {\n        events: vec![\n"
    cairo_code_events = ',\n'.join(cairo_events)
    cairo_code_end = "\n        ]\n    }\n}"

    full_cairo_code = cairo_code_start + cairo_code_events + cairo_code_end

    with open(output_file, 'w') as file:
        file.write(full_cairo_code)


def json_to_midi(json_file, output_file):
    with open(json_file, 'r') as file:
        json_data = json.load(file)

    mid = MidiFile()
    track = MidiTrack()
    mid.tracks.append(track)

    for event in json_data["events"]:
        for message_type, params in event.items():
            if "TIME_SIGNATURE" in event:
                e = event["TIME_SIGNATURE"]
                track.append(MetaMessage('time_signature', numerator=e["numerator"], denominator=e["denominator"], clocks_per_click=e.get("clocks_per_click", 24), notated_32nd_notes_per_beat=8, time=0))
            elif "SET_TEMPO" in event:
                e = event["SET_TEMPO"]
                track.append(MetaMessage('set_tempo', tempo=e["tempo"], time=0))
            elif "CONTROL_CHANGE" in event:
                e = event["CONTROL_CHANGE"]
                track.append(Message('control_change', channel=e["channel"], control=e["control"], value=e["value"], time=e.get("time", 0)))
            elif message_type == "NOTE_ON":
                track.append(Message('note_on', note=int(params["note"]), velocity=int(params["velocity"]), time=int(params["time"]), channel=int(params["channel"])))
            elif message_type == "NOTE_OFF":
                track.append(Message('note_off', note=int(params["note"]), velocity=int(params["velocity"]), time=int(params["time"]), channel=int(params["channel"])))

    mid.save(output_file)

def json_to_midi(json_file, output_midi_file):
    with open(json_file, 'r') as file:
        data = json.load(file)
    
    mid = MidiFile()
    track = MidiTrack()
    mid.tracks.append(track)

    for event in data['events']:
        if "TIME_SIGNATURE" in event:
            e = event["TIME_SIGNATURE"]
            track.append(MetaMessage('time_signature', numerator=e["numerator"], denominator=e["denominator"], clocks_per_click=e.get("clocks_per_click", 24), notated_32nd_notes_per_beat=8, time=0))
        elif "SET_TEMPO" in event:
            e = event["SET_TEMPO"]
            track.append(MetaMessage('set_tempo', tempo=e["tempo"], time=0))
        elif "CONTROL_CHANGE" in event:
            e = event["CONTROL_CHANGE"]
            track.append(Message('control_change', channel=e["channel"], control=e["control"], value=e["value"], time=e.get("time", 0)))
        elif "NOTE_ON" in event:
            e = event["NOTE_ON"]
            track.append(Message('note_on', note=e["note"], velocity=e["velocity"], time=e.get("time", 0), channel=e["channel"]))
        elif "NOTE_OFF" in event:
            e = event["NOTE_OFF"]
            track.append(Message('note_off', note=e["note"], velocity=e["velocity"], time=e.get("time", 0), channel=e["channel"]))
        elif "PITCH_WHEEL" in event:
            e = event["PITCH_WHEEL"]
            track.append(Message('pitchwheel', channel=e["channel"], pitch=e["pitch"], time=e.get("time", 0)))
        elif "AFTER_TOUCH" in event:
            e = event["AFTER_TOUCH"]
            track.append(Message('aftertouch', channel=e["channel"], value=e["value"], time=e.get("time", 0)))
        elif "POLY_TOUCH" in event:
            e = event["POLY_TOUCH"]
            track.append(Message('polytouch', note=e["note"], value=e["value"], channel=e["channel"], time=e.get("time", 0)))

    mid.save(output_midi_file)


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


def format_fp32x32(time):
    return f"FP32x32 {{ mag: {time}, sign: false }}"

# Helper function to parse FP32x32 formatted string (needed for time, tempo, etc.)
def parse_fp32x32(fp32x32_str):
    # Extract the magnitude part from the FP32x32 formatted string
    mag_match = re.search(r"mag: (\d+)", fp32x32_str)
    if mag_match:
        mag = int(mag_match.group(1))
        # Assuming the magnitude directly represents the value we want
        return mag
    else:
        # Return a default value if parsing fails
        return 0
