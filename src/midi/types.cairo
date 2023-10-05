use orion::numbers::{FP32x32, i32};

/// =========================================
/// ================ MIDI ===================
/// =========================================

#[derive(Copy, Drop)]
struct Midi {
    events: Span<Message>
}

/// =========================================
/// ================ MESSAGES ===============
/// =========================================

#[derive(Copy, Drop)]
enum Message {
    NOTE_ON: NoteOn,
    NOTE_OFF: NoteOff,
    SET_TEMPO: SetTempo,
    TIME_SIGNATURE: TimeSignature,
    CONTROL_CHANGE: ControlChange,
    PITCH_WHEEL: PitchWheel,
    AFTER_TOUCH: AfterTouch,
    POLY_TOUCH: PolyTouch
}

#[derive(Copy, Drop)]
struct NoteOn {
    channel: u8,
    note: u8,
    velocity: u8,
    time: FP32x32
}

#[derive(Copy, Drop)]
struct NoteOff {
    channel: u8,
    note: u8,
    velocity: u8,
    time: FP32x32
}

#[derive(Copy, Drop)]
struct SetTempo {
    tempo: u32, // microseconds per beat
    time: Option<FP32x32>
}

#[derive(Copy, Drop)]
struct TimeSignature {
    numerator: u8,
    denominator: u8,
    clocks_per_click: u8,
    time: Option<FP32x32>
}

#[derive(Copy, Drop)]
struct ControlChange {
    channel: u8,
    control: u8,
    value: u8,
    time: FP32x32
}

#[derive(Copy, Drop)]
struct PitchWheel {
    channel: u8,
    pitch: i32,
    time: FP32x32
}

#[derive(Copy, Drop)]
struct AfterTouch {
    channel: u8,
    value: u8,
    time: FP32x32
}

#[derive(Copy, Drop)]
struct PolyTouch {
    channel: u8,
    note: u8,
    value: u8,
    time: FP32x32
}

/// =========================================
/// ================ PATTERNS ===============
/// =========================================

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

#[derive(Copy, Drop)]
struct VelocityCurve {} // TODO

/// =========================================
/// ============== PitchClass ===============
/// =========================================

// Define a 12 note octave base
// For Microtonal mode definition, change the OCTAVEBASE and represent scales as intervallic ratios summing to OCTAVEBASE

const OCTAVEBASE: u8 = 12;

//*************************************************************************
// Pitch and Interval Structs 
//
// PitchClass: Used to Calculate Keynums. Pitch Class Keynums can be 0-127
// Example: MIDI Keynum 69 == A440 
//
// Notes are values from 0 <= note < OCTAVEBASE and increment
// Example: If OCTAVEBASE = 12, [C -> 0, C# -> 1, D -> 2...B-> 11]
// Example 2: MIDI Keynum 69: Note = 9, Octave = 5
//*************************************************************************

#[derive(Copy, Drop)]
struct PitchClass {
    note: u8,
    octave: u8,
}

#[derive(Copy, Drop)]
enum Direction {
    Up: (),
    Down: (),
    Oblique: ()
}

#[derive(Copy, Drop)]
struct PitchInterval {
    size: u8,
    direction: Direction,
    quality: Quality,
}

#[derive(Copy, Drop)]
enum Quality {
    Major: (),
    Minor: (),
    Perfect: (),
    Diminshed: (),
    Augmented: (),
    Undefined: ()
}
