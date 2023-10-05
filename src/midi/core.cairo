use orion::operators::tensor::{Tensor, U32Tensor,};
use orion::numbers::i32;

use koji::midi::types::{Midi, Message, Modes, ArpPattern, VelocityCurve};

trait MidiTrait {
    /// =========== NOTE MANIPULATION ===========
    /// Instantiate a Midi.
    fn new() -> Midi;
    /// Set a message in a Midi object.
    fn set_message(self: @Midi, msg: Message) -> Midi;
    /// Transpose notes by a given number of semitones.
    fn transpose_notes(self: @Midi, semitones: i32) -> Midi;
    ///  Reverse the order of notes.
    fn reverse_notes(self: @Midi) -> Midi;
    /// Align notes to a given rhythmic grid.
    fn quantize_notes(self: @Midi, grid_size: usize) -> Midi;
    /// Extract notes within a specified pitch range.
    fn extract_notes(self: @Midi, note_range: usize) -> Midi;
    /// Change the duration of notes by a given factor
    fn change_note_duration(self: @Midi, factor: i32) -> Midi;
    /// =========== GLOBAL MANIPULATION ===========
    /// Alter the tempo of the Midi data.
    fn change_tempo(self: @Midi, new_tempo: u32) -> Midi;
    /// Change instrument patches based on a provided mapping
    fn remap_instruments(self: @Midi, chanel: u32) -> Midi;
    /// =========== ANALYSIS ===========
    /// Extract the tempo (in BPM) from the Midi data.
    fn get_bpm(self: @Midi) -> u32;
    /// Return statistics about notes (e.g., most frequent note, average note duration).
    /// =========== ADVANCED MANIPULATION ===========
    /// Add harmonies to existing melodies based on specified intervals.
    fn generate_harmony(self: @Midi, modes: Modes) -> Midi;
    /// Convert chords into arpeggios based on a given pattern.
    fn arpeggiate_chords(self: @Midi, pattern: ArpPattern) -> Midi;
    /// Add or modify dynamics (velocity) of notes based on a specified curve or pattern.
    fn edit_dynamics(self: @Midi, curve: VelocityCurve) -> Midi;
}

impl MidiImpl of MidiTrait {
    fn new() -> Midi {
        Midi { events: array![].span() }
    }

    fn set_message(self: @Midi, msg: Message) -> Midi {
        panic(array!['not supported yet'])
    }

    fn transpose_notes(self: @Midi, semitones: i32) -> Midi {
        panic(array!['not supported yet'])
    }

    fn reverse_notes(self: @Midi) -> Midi {
        panic(array!['not supported yet'])
    }

    fn quantize_notes(self: @Midi, grid_size: usize) -> Midi {
        panic(array!['not supported yet'])
    }

    fn extract_notes(self: @Midi, note_range: usize) -> Midi {
        panic(array!['not supported yet'])
    }
    fn change_note_duration(self: @Midi, factor: i32) -> Midi {
        panic(array!['not supported yet'])
    }

    fn change_tempo(self: @Midi, new_tempo: u32) -> Midi {
        panic(array!['not supported yet'])
    }

    fn remap_instruments(self: @Midi, chanel: u32) -> Midi {
        panic(array!['not supported yet'])
    }

    fn get_bpm(self: @Midi) -> u32 {
        // Iterate through the MIDI events, find and return the SetTempo message
        let mut ev = self.clone().events;
        let mut outtempo: u32 = 0;
        let mut i = 0;

        loop {
            if i == ev.len() {
                break;
            }

            let currentevent = ev.at(i);

            match currentevent {
                Message::NOTE_ON(NoteOn) => {},
                Message::NOTE_OFF(NoteOff) => {},
                Message::SET_TEMPO(SetTempo) => {
                    outtempo = *SetTempo.tempo;
                },
                Message::TIME_SIGNATURE(TimeSignature) => {},
                Message::CONTROL_CHANGE(ControlChange) => {},
                Message::PITCH_WHEEL(PitchWheel) => {},
                Message::AFTER_TOUCH(AfterTouch) => {},
                Message::POLY_TOUCH(PolyTouch) => {},
            }
            i += 1;
        };

        outtempo
    }

    fn generate_harmony(self: @Midi, modes: Modes) -> Midi {
        panic(array!['not supported yet'])
    }

    fn arpeggiate_chords(self: @Midi, pattern: ArpPattern) -> Midi {
        panic(array!['not supported yet'])
    }

    fn edit_dynamics(self: @Midi, curve: VelocityCurve) -> Midi {
        panic(array!['not supported yet'])
    }
}

