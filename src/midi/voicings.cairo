use array::ArrayTrait;

//**********************************************************************************************************
//  Voicing Definitions
//
// We define Voicings as an ordered array of modal steps (or PitchIntervals) from a specified PitchClass and Mode
//
// Example 1: first position triad in C Major Key: [2, 2] -> [C, E, G]
// Example 2: first position triad in C Major 7 Key: [2, 2, 2] -> [C, E, G, B]
//
// Current implementation uses modal steps - to do: enable voicings defined as a PitchInterval from a note
//
// It is from these defined PitchIntervals that we can compute a chord of a Mode at a given scale degree
//
// For microtonal scales, steps should be defined as ratios of BASEOCTAVE
//
// May need to specify the DIRECTION as well as the steps
//**********************************************************************************************************

#[derive(Copy, Drop)]
enum Voicings {
    Triad_root_position: (),
    Triad_first_inversion: (),
    Triad_second_inversion: (),
    Tetrad_root_position: (),
}

fn triad_root_position() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(2);

    mode.span()
}

fn triad_root_position_intervals() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(2);

    mode.span()
}

fn triad_first_inversion() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(3);

    mode.span()
}

fn triad_second_inversion() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(3);
    mode.append(2);

    mode.span()
}