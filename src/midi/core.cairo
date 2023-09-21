use orion::operators::tensor::{Tensor, U32Tensor,};
use orion::numbers::i32;

/// # Midi Type
/// A Midi Data is a 3D Tensor:
/// 1st dimension represents the Midi features (Piano Roll, Velocity, Pitch Bend) // TODO: Casey - Choose features by dimension
/// 2nd dimension represents the pitches.
/// 3rd dimension represents the time steps.
#[derive(Copy, Drop)]
struct Midi {
    tempo: u32,
    time_signature: (u8, u8),
    chanel: Option<u32>,
    data: Tensor<u32>
// TODO: Casey - Is there any other relevant field we should add ?
}

// 
#[derive(Copy, Drop)]
struct VelocityCurve {} // TODO

trait MidiTrait {
    /// =========== NOTE MANIPULATION ===========
    /// Instantiate a Midi.
    fn new(tempo: u32, time_signature: (u8, u8), chanel: Option<u32>, data: Tensor<u32>) -> Midi;
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
    fn new(tempo: u32, time_signature: (u8, u8), chanel: Option<u32>, data: Tensor<u32>) -> Midi {
        assert(data.shape.len() == 3, 'Midi Data must be 3D');
        Midi { tempo, time_signature, chanel, data }
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
        panic(array!['not supported yet'])
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

#[derive(Copy, Drop)]
enum Modes {
    Major: (),
    Minor: (),
    Lydian: (),
    Mixolydian: (),
    Dorian: (),
    Phrygian: (),
    Locrian: (),
    Aeolian: (),
    Harmonicminor: (),
    Naturalminor: (),
    Chromatic: (),
    Pentatonic: ()
}

#[derive(Copy, Drop)]
enum ArpPattern {} //TODO
