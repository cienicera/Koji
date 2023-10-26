use core::option::OptionTrait;
use array::ArrayTrait;
use array::SpanTrait;
use clone::Clone;
use array::ArrayTCloneImpl;
use traits::TryInto;
use traits::Into;
use debug::PrintTrait;

use koji::midi::types::{Modes, PitchClass, OCTAVEBASE, Direction, Quality};
use koji::midi::modes::{mode_steps};

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

trait PitchClassTrait {
    fn keynum(self: @PitchClass) -> u8;
    fn abs_diff_between_pc(self: @PitchClass, pc2: PitchClass) -> u8;
    fn mode_notes_above_note_base(self: @PitchClass, pcoll: Span<u8>) -> Span<u8>;
    fn get_notes_of_key(self: @PitchClass, pcoll: Span<u8>) -> Span<u8>;
    fn get_scale_degree(self: @PitchClass, tonic: PitchClass, pcoll: Span<u8>) -> u8;
    fn modal_transposition(
        self: @PitchClass, tonic: PitchClass, pcoll: Span<u8>, numsteps: u8, direction: Direction
    ) -> u8;
}

impl PitchClassImpl of PitchClassTrait {
    fn keynum(self: @PitchClass) -> u8 {
        pc_to_keynum(*self)
    }
    fn abs_diff_between_pc(self: @PitchClass, pc2: PitchClass) -> u8 {
        abs_diff_between_pc(*self, pc2)
    }
    fn mode_notes_above_note_base(self: @PitchClass, pcoll: Span<u8>) -> Span<u8> {
        mode_notes_above_note_base2(*self, pcoll)
    }
    fn get_notes_of_key(self: @PitchClass, pcoll: Span<u8>) -> Span<u8> {
        get_notes_of_key2(*self, pcoll)
    }
    fn get_scale_degree(self: @PitchClass, tonic: PitchClass, pcoll: Span<u8>) -> u8 {
        get_scale_degree(*self, tonic, pcoll)
    }
    fn modal_transposition(
        self: @PitchClass, tonic: PitchClass, pcoll: Span<u8>, numsteps: u8, direction: Direction
    ) -> u8 {
        modal_transposition(*self, tonic, pcoll, numsteps, direction)
    }
}

// Converts a PitchClass to a MIDI keynum
fn pc_to_keynum(pc: PitchClass) -> u8 {
    pc.note + (OCTAVEBASE * (pc.octave + 1))
}

// Converts a MIDI keynum to a PitchClass 
fn keynum_to_pc(keynum: u8) -> PitchClass {
    let mut outnote = keynum % OCTAVEBASE;
    let mut outoctave = (keynum / OCTAVEBASE);
    PitchClass { note: outnote, octave: outoctave, }
}

// absolute difference between two PitchClasses
fn abs_diff_between_pc(pc1: PitchClass, pc2: PitchClass) -> u8 {
    let keynum_1 = pc_to_keynum(pc1);
    let keynum_2 = pc_to_keynum(pc2);

    if (keynum_1 == keynum_2) {
        0
    } else if keynum_1 <= keynum_2 {
        keynum_2 - keynum_1
    } else {
        keynum_1 - keynum_2
    }
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
    let mut new_note: u8 = note;

    loop {
        match arr.pop_front() {
            Option::Some(current_note) => {
                new_note = (*current_note + new_note) % OCTAVEBASE;
                new_arr.append(new_note);
            },
            Option::None(_) => {
                break;
            }
        };
    };

    new_arr.span()
}

fn mode_notes_above_note_base2(pc: PitchClass, pcoll: Span<u8>) -> Span<u8> {
    let mut outarr = ArrayTrait::new();
let mut pcollection =  pcoll.clone();
    let mut sum = pc.note;

    loop {
        match pcollection.pop_front() {
            Option::Some(step) => {
                sum += *step;
                outarr.append(sum % OCTAVEBASE);
            },
            Option::None(_) => {
                break;
            }
        };
    };

    outarr.span()
}

// Functions that compute collect notes of a mode at a specified pitch base in Normal Form (% OCTAVEBASE)
// Example: E Major -> [1,3,4,6,8,9,11]  (C#,D#,E,F#,G#,A,B)
fn get_notes_of_key(tonic: u8, mode: Span<u8>) -> Span<u8> {
    let tonic_note = tonic % OCTAVEBASE;
    let mut new_arr = ArrayTrait::<u8>::new();
    new_arr.append(tonic_note);
    mode_notes_above_note_base(mode, new_arr, tonic)
}

// Functions that compute collect notes of a mode at a specified pitch base in Normal Form (% OCTAVEBASE)
// Example: E Major -> [1,3,4,6,8,9,11]  (C#,D#,E,F#,G#,A,B)

fn get_notes_of_key2(pc: PitchClass, pcoll: Span<u8>) -> Span<u8> {
    let mut outarr = ArrayTrait::<u8>::new();
let mut pcollection =  pcoll.clone();

    let mut sum = pc.note;
    let mut i = 0;

    outarr.append(sum);

    loop {
        match pcollection.pop_front() {
            Option::Some(step) => {
                sum += *step;
                outarr.append(sum % OCTAVEBASE);
            },
            Option::None(_) => {
                break;
            }
        };
    };

    outarr.span()
}

// Compute the scale degree of a note given a key
// In this implementation, Scale degrees doesn't use zero-based counting - Zero if the note is note present in the key.
// Perhaps implement Option for when a note is not a scale degree          

fn get_scale_degree(pc: PitchClass, tonic: PitchClass, pcoll: Span<u8>) -> u8 {
    let mut notesofkey = tonic.get_notes_of_key(pcoll.snapshot.clone().span());
    let mut i = 0;
    let mut outdegree = 0;

    loop {
        match notesofkey.pop_front() {
            Option::Some(note) => {
                if pc.note == *note {
                    outdegree += notesofkey.len() + 1;
                }
            },
            Option::None(_) => {
                break;
            }
        };
    };

    let scaledegree: u8 = outdegree.try_into().unwrap();

    scaledegree
}

fn modal_transposition(
    pc: PitchClass, tonic: PitchClass, pcoll: Span<u8>, numsteps: u8, direction: Direction
) -> u8 {
    let mut degree8 = pc.get_scale_degree(tonic, pcoll.snapshot.clone().span());

    //convert scale degree to u32 in order use as index into modal step array
    let mut degree: u32 = degree8.into();
    let mut i = 0;
    let mut sum = 0;

    // convert scale degree to zero based counting
    degree -= 1;

    loop {
        if i >= numsteps {
            break;
        }

        match direction {
            Direction::Up(_) => {
                sum = sum + *pcoll.at(degree);
                degree = (degree + 1) % pcoll.len();
            },
            Direction::Down(_) => {
                if (degree == 0) {
                    degree = pcoll.snapshot.clone().len() - 1;
                } else {
                    degree -= 1;
                }
                sum = sum + *pcoll.at(degree);
            },
            Direction::Oblique(_) => {},
        }

        i += 1;
    };

    let mut keyn = pc.keynum();

    match direction {
        Direction::Up(_) => {
            keyn = keyn + sum;
        },
        Direction::Down(_) => {
            keyn = keyn - sum;
        },
        Direction::Oblique(_) => {},
    }

    keyn
}
