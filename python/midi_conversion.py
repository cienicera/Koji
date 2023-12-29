import mido
import json

import mido


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
