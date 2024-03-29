use array::ArrayTrait;
use koji::midi::types::{PitchInterval, Direction, Quality};

//**********************************************************************************************************
//  Voicing Definitions
//
// We define Voicings as an ordered array of modal steps (or PitchIntervals) from a specified PitchClass
//
// Example: first position triad in C Major Key: [2 steps Up, 4 steps Up] -> [C, E, G]
//
// Current implementation uses modal steps - to do: enable voicings defined as a PitchInterval from a note
//
// It is from these defined PitchIntervals that we can compute a chord of a intervals at a given scale degree
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

fn triad_root_position() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 4, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn triad_first_inversion() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 5, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn triad_second_inversion() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 3, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 5, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn maj_7_no_root_3rd_inversion() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Down(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 4, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn maj_7_no_root_3rd_inversion2() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Down(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 4, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn maj_7_no_root_3rd_inversion_add6() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Down(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 5, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn maj_9_no_root_3rd_inversion_add6() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Down(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 5, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn fourths_1() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Down(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 5, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn plus_four_7() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Down(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 3, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 5, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn plus_four_7_2() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 3, direction: Direction::Up(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 6, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}

fn seventh_and_third() -> Span<PitchInterval> {
    let mut intervals = ArrayTrait::<PitchInterval>::new();
    intervals
        .append(PitchInterval { size: 1, direction: Direction::Down(()), quality: Option::None });
    intervals
        .append(PitchInterval { size: 2, direction: Direction::Up(()), quality: Option::None });
    intervals.span()
}
