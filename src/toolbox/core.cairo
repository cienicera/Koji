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
struct PitchInterval {
    quality: u8,
    size: u8,
}

#[derive(Copy, Drop)]
enum Direction {
    Up: (),
    Down: (),
    Oblique: ()
}

