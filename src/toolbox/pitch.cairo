use core::option::OptionTrait;
use array::ArrayTrait;
use array::SpanTrait;

use koji::toolbox::core::{PitchClass, OCTAVEBASE, Direction};

//*****************************************************************************************************************
// PitchClass and Note Utils 
//
// Defintions:
// Note - Integer representation of pitches % OCTAVEBASE. Example E Major -> [1,3,4,6,8,9,11]  (C#,D#,E,F#,G#,A,B)
// Keynum - Integer representing MIDI note. Keynum = Note * (OCTAVEBASE * OctaveOfNote)
// Mode - Distances between adjacent notes within an OCTAVEBASE. Example: Major Key -> [2,2,1,2,2,2,1]
// Key  - A Mode transposed at a given pitch base
// Tonic - A Note transposing a Mode
// Modal Transposition - Moving up or down in pitch by a constant interval within a given mode
// Scale Degree - The position of a particular note on a scale relative to the tonic
//*****************************************************************************************************************

// Converts a PitchClass to a MIDI keynum
fn pc_to_keynum(pc: PitchClass) -> u8 {
    pc.note + (OCTAVEBASE * (pc.octave + 1))
}

//Compute the difference between two notes and the direction of that melodic motion
// Direction -> 0 == /oblique, 1 == /down, 2 == /up
fn diff_between_pc(pc1: PitchClass, pc2: PitchClass) -> (u8, Direction) {
    let keynum_1 = pc_to_keynum(pc1);
    let keynum_2 = pc_to_keynum(pc2);

    if (keynum_1 - keynum_2) == 0 {
        (0, Direction::Oblique(()))
    } else if keynum_1 <= keynum_2 {
        (keynum_2 - keynum_1, Direction::Up(()))
    } else {
        (keynum_1 - keynum_2, Direction::Down(()))
    }
}

//Provide Array, Compute and Return notes of mode at note base - note base is omitted
fn mode_notes_above_note_base(mut arr: Span<u8>, mut new_arr: Array<u8>, note: u8) -> Span<u8> {
    let new_note = note;

    loop {
        if arr.len() == 0 {
            break;
        }

        let new_note = (*arr.pop_front().unwrap() + new_note) % OCTAVEBASE;
        new_arr.append(new_note);
    };

    new_arr.span()
}

// Functions that compute collect notes of a mode at a specified pitch base in Normal Form (% OCTAVEBASE)
// Example: E Major -> [1,3,4,6,8,9,11]  (C#,D#,E,F#,G#,A,B)
fn get_notes_of_key(tonic: u8, mode: Span<u8>) -> Span<u8> {
    let tonic_note = tonic % OCTAVEBASE;
    let mut new_arr = ArrayTrait::<u8>::new();
    new_arr.append(tonic_note);
    mode_notes_above_note_base(mode, new_arr, tonic)
}

// Compute the scale degree of MIDI keynum, given a tonic and mode
fn keynum_to_scale_degree() {}
// // Compute the scale degree of a note given a key
// // In this implementation, Scale degrees use zero-based counting, unlike in prevalent music theory literature          
// fn get_scale_degree(arr: Span<u8>, tonic_note: u8, key_num_note: u8) -> u8 {

//     loop {

//     }
// }


