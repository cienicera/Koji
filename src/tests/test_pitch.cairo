use core::option::OptionTrait;
use array::ArrayTrait;
use array::SpanTrait;
use clone::Clone;
use array::ArrayTCloneImpl;
use traits::TryInto;
use traits::Into;
use debug::PrintTrait;

use koji::midi::types::{PitchClass, OCTAVEBASE, Direction, Quality, Modes};
use koji::midi::modes::{major_steps, mode_steps};
use koji::midi::pitch::{PitchClassTrait, PitchClassImpl, keynum_to_pc, modal_transposition};

//*****************************************************************************************************************
// TESTS
//*****************************************************************************************************************
//#[cfg(test)]
////mod tests {
#[test]
#[available_gas(10000000)]
fn keynum_to_pc_test() {
    // Create a PitchClass for each note in c ionian scale at random octaves

    let a = keynum_to_pc(69).note;
    let b = keynum_to_pc(59).note;
    let c = keynum_to_pc(24).note;
    let d = keynum_to_pc(74).note;
    let e = keynum_to_pc(76).note;
    let f = keynum_to_pc(77).note;
    let g = keynum_to_pc(67).note;

    // Test that notes are properly calculated

    assert(a == 9, 'result is not 9, note: A');
    assert(b == 11, 'result is not 11, note: B');
    assert(c == 0, 'result is not 0, note: C');
    assert(d == 2, 'result is not 2, note: D');
    assert(e == 4, 'result is not 4, note: E');
    assert(f == 5, 'result is not 5, note: F');
    assert(g == 7, 'result is not 7, note: G');
}

#[test]
#[available_gas(10000000)]
fn keynum_test() {
    // Create a PitchClass for each note in c ionian scale at octave 4

    let a = PitchClass { note: 9, octave: 4, };
    let b = PitchClass { note: 11, octave: 4, };
    let c = PitchClass { note: 0, octave: 4, };
    let d = PitchClass { note: 2, octave: 4, };
    let e = PitchClass { note: 4, octave: 4, };
    let f = PitchClass { note: 5, octave: 4, };
    let g = PitchClass { note: 7, octave: 4, };

    // Test that keynums are properly calculated

    assert(a.keynum() == 69, 'result is not 69, note: A');
    assert(b.keynum() == 71, 'result is not 71, note: B');
    assert(c.keynum() == 60, 'result is not 60, note: C');
    assert(d.keynum() == 62, 'result is not 62, note: D');
    assert(e.keynum() == 64, 'result is not 64, note: E');
    assert(f.keynum() == 65, 'result is not 65, note: F');
    assert(g.keynum() == 67, 'result is not 67, note: G');
}

#[test]
#[available_gas(10000000)]
fn abs_diff_between_pc_test() {
    // Create a PitchClass for each note in c ionian scale at octave 4

    let a = PitchClass { note: 9, octave: 4, };
    let b = PitchClass { note: 11, octave: 4, };
    let c = PitchClass { note: 0, octave: 4, };
    let d = PitchClass { note: 2, octave: 4, };
    let e = PitchClass { note: 4, octave: 4, };
    let f = PitchClass { note: 5, octave: 4, };
    let g = PitchClass { note: 7, octave: 4, };

    // Test that differences between PitchClasses are properly calculated

    let a_e = a.abs_diff_between_pc(e);
    let e_d = e.abs_diff_between_pc(d);
    let d_e = d.abs_diff_between_pc(e);
    let c_g = c.abs_diff_between_pc(g);
    let g_d = g.abs_diff_between_pc(d);
    let a_f = a.abs_diff_between_pc(f);
    let f_d = f.abs_diff_between_pc(d);

    // Note: The above can also be expressed as a function
    // let a_e = abs_diff_between_pc(a, e);

    assert(a_e == 5, 'diff between A and E is 5');
    assert(e_d == 2, 'diff between E and D is 2');
    assert(d_e == 2, 'diff between D and E is 2');
    assert(c_g == 7, 'diff between C and G is 7');
    assert(g_d == 5, 'diff between G and D is 5');
    assert(a_f == 4, 'diff between A and F is 4');
    assert(f_d == 3, 'diff between F and D is 3');
}

#[test]
#[available_gas(100000000)]
fn mode_notes_above_note_base_test() {
    // Create a PitchClass for each note in c ionian scale at octave 4

    let pcoll = major_steps().len();
    let major: Span<u8> = major_steps();

    'pcoll'.print();
    pcoll.print();

    let a = PitchClass { note: 9, octave: 4, };
    let b = PitchClass { note: 11, octave: 4, };
    let c = PitchClass { note: 0, octave: 4, };
    let d = PitchClass { note: 2, octave: 4, };
    let e = PitchClass { note: 4, octave: 4, };
    let f = PitchClass { note: 5, octave: 4, };
    let g = PitchClass { note: 7, octave: 4, };
    // Test that differences between PitchClasses are properly calculated

    let c_maj = c.mode_notes_above_note_base(major);

    'print major mode notes above C'.print();

    let mut testval = *c_maj.at(0);
    assert(testval == 2, 'Scale Degree 2 == 2');
    testval.print();

    let mut testval = *c_maj.at(1);
    assert(testval == 4, 'Scale Degree 3 == 4');
    testval.print();

    let mut testval = *c_maj.at(2);
    assert(testval == 5, 'Scale Degree 4 == 5');
    testval.print();

    let mut testval = *c_maj.at(3);
    assert(testval == 7, 'Scale Degree 5 == 7');
    testval.print();

    let mut testval = *c_maj.at(4);
    assert(testval == 9, 'Scale Degree 6 == 9');
    testval.print();

    let mut testval = *c_maj.at(5);
    assert(testval == 11, 'Scale Degree 7  == 11');
    testval.print();
}


#[test]
#[available_gas(10000000)]
fn get_notes_of_key_test() {
    // Create a PitchClass for each note in c ionian scale at octave 4

    let pcoll = major_steps().len();
    let major: Span<u8> = major_steps();

    let c = PitchClass { note: 0, octave: 4, };

    // Test that notes of C Major scale are properly calculated

    let cmajor = c.get_notes_of_key(major);

    'Notes of C Major'.print();

    let mut testval = *cmajor.at(0);
    assert(testval == 0, 'Scale Degree 1 == 0');
    testval.print();

    let mut testval = *cmajor.at(1);
    assert(testval == 2, 'Scale Degree 2 == 2');
    testval.print();

    let mut testval = *cmajor.at(2);
    assert(testval == 4, 'Scale Degree 3 == 4');
    testval.print();

    let mut testval = *cmajor.at(3);
    assert(testval == 5, 'Scale Degree 4 == 5');
    testval.print();

    let mut testval = *cmajor.at(4);
    assert(testval == 7, 'Scale Degree 5 == 7');
    testval.print();

    let mut testval = *cmajor.at(5);
    assert(testval == 9, 'Scale Degree 6  == 9');
    testval.print();

    let mut testval = *cmajor.at(6);
    assert(testval == 11, 'Scale Degree 7  == 11');
    testval.print();
}

#[test]
#[available_gas(100000000)]
// Note: Scale Degrees are currently 1-based counting

fn get_scale_degree_test() {
    // Create a PitchClass for each note in c ionian scale at octave 4

    let pcoll = major_steps().len();
    let major: Span<u8> = major_steps();

    let a = PitchClass { note: 9, octave: 4, };
    let b = PitchClass { note: 11, octave: 4, };
    let c = PitchClass { note: 0, octave: 4, };
    let d = PitchClass { note: 2, octave: 4, };
    let e = PitchClass { note: 4, octave: 4, };
    let f = PitchClass { note: 5, octave: 4, };
    let g = PitchClass { note: 7, octave: 4, };

    // Test that scale degrees are properly computed 
    'Get Scale Degree'.print();

    let c_c = c.get_scale_degree(c, major);
    'c_c'.print();
    c_c.print();
    'c_c'.print();
    assert(c_c == 1, 'Scale Degree 1');

    let d_c = d.get_scale_degree(c, major);
    'd_c'.print();
    d_c.print();
    'd_c'.print();
    assert(d_c == 2, 'Scale Degree 2');

    let e_c = e.get_scale_degree(c, major);
    'e_c'.print();
    e_c.print();
    'e_c'.print();
    assert(e_c == 3, 'Scale Degree 3');

    let f_c = f.get_scale_degree(c, major);
    'f_c'.print();
    f_c.print();
    'f_c'.print();
    assert(f_c == 4, 'Scale Degree 4');

    let g_c = g.get_scale_degree(c, major);
    'g_c'.print();
    g_c.print();
    'g_c'.print();
    assert(g_c == 5, 'Scale Degree 5');

    let a_c = a.get_scale_degree(c, major);
    'a_c'.print();
    a_c.print();
    'a_c'.print();
    assert(a_c == 6, 'Scale Degree 6');

    let b_c = b.get_scale_degree(c, major);
    'b_c'.print();
    b_c.print();
    'b_c'.print();
    assert(b_c == 7, 'Scale Degree 7');

    'scale degree'.print();
    a_c.print();
    b_c.print();
    c_c.print();
}

#[test]
#[available_gas(10000000)]
fn modal_transposition_test() {
    let pcoll = major_steps().len();
    let major: Span<u8> = major_steps();

    let c = PitchClass { note: 0, octave: 4, };

    let c_c = c.modal_transposition(c, major, 2, Direction::Up(()));
    let c_c2 = c.modal_transposition(c, major, 2, Direction::Down(()));

    assert(c_c == 64, 'Keynum is E: 64');
    assert(c_c2 == 57, 'Keynum is A: 57');

    'modal transposition2'.print();
    c_c2.print();
}

