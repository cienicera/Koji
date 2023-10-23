use array::ArrayTrait;

//**********************************************************************************************************
//  Mode & Key Definitions
//
// We define Scales/Modes as an ordered array of ascending interval steps
//
// Example 1: [do, re, me, fa, sol, la, ti] in C Major Key -> C,D,E,F,G,A,B -> Modal Steps: [2,2,1,2,2,1]
//
// It is from these defined steps that we can compute a 'Key' AKA Pitches of a Mode at a given Note Base
//
// For microtonal scales, steps should be defined as ratios of BASEOCTAVE
//**********************************************************************************************************

fn major_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(1);

    mode.span()
}

fn minor_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(2);

    mode.span()
}

fn lydian_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(1);

    mode.span()
}

fn mixolydian_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(1);
    mode.append(2);

    mode.span()
}

fn dorian_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(1);
    mode.append(2);

    mode.span()
}

fn phrygian_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);

    mode.span()
}

fn locrian_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(2);

    mode.span()
}

fn aeolian_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(2);

    mode.span()
}

fn harmonicminor_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(1);
    mode.append(3);
    mode.append(1);

    mode.span()
}

fn naturalminor_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(1);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(2);
    mode.append(2);

    mode.span()
}

fn chromatic_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(1);
    mode.append(1);
    mode.append(1);
    mode.append(1);
    mode.append(1);
    mode.append(1);
    mode.append(1);
    mode.append(1);
    mode.append(1);
    mode.append(1);
    mode.append(1);

    mode.span()
}

fn pentatonic_steps() -> Span<u8> {
    let mut mode = ArrayTrait::<u8>::new();
    mode.append(2);
    mode.append(2);
    mode.append(3);
    mode.append(2);
    mode.append(3);

    mode.span()
}
