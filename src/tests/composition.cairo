#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use core::traits::Into;
    use core::traits::TryInto;
    use orion::operators::tensor::{Tensor, U32Tensor,};
    use orion::numbers::{FP32x32};
    use core::option::OptionTrait;
    use dict::Felt252DictTrait;
    use koji::midi::types::{
        Midi, Message, Modes, ArpPattern, VelocityCurve, NoteOn, NoteOff, SetTempo, TimeSignature,
        ControlChange, PitchWheel, AfterTouch, PolyTouch, Direction, PitchClass, ProgramChange,
        SystemExclusive,
    };
    use alexandria_data_structures::stack::{StackTrait, Felt252Stack, NullableStack};
    use alexandria_data_structures::array_ext::{ArrayTraitExt, SpanTraitExt};

    use koji::midi::instruments::{
        GeneralMidiInstrument, instrument_name, instrument_to_program_change,
        program_change_to_instrument, next_instrument_in_group
    };
    use koji::midi::time::round_to_nearest_nth;
    use koji::midi::modes::{mode_steps};
    use koji::midi::core::{MidiTrait};
    use koji::midi::pitch::{PitchClassTrait, keynum_to_pc, pc_to_keynum};
    use koji::midi::modes::{major_steps};
    use core::fmt::Display;
    use core::fmt::Formatter;
    use koji::midi::voicings::{maj_7_no_root_3rd_inversion, plus_four_7, triad_root_position};

    #[test]
    #[available_gas(1000000000000)]
    fn cairo_composition_test() {
        // q1q -> {
        // q2q -> }
        // q3q -> ;
        // q4q -> _
        println!(
            "use koji::midi::types::q1qMidi, Message, NoteOn, NoteOff, SetTempo, TimeSignature, ControlChange, PitchWheel, AfterTouch, PolyTouch, Modesq2qq3q"
        );
        println!("use orion::numbers::FP32x32q3q");
        println!("fn midi() -> Midi q1q");
        println!("Midi q1q");
        println!("events: array![");

        let mut eventlist = ArrayTrait::<Message>::new();

        let newtempo = SetTempo {
            tempo: 120, time: Option::Some(FP32x32 { mag: 33242, sign: false })
        };

        let tonic = PitchClass { note: 0, octave: 4 };

        let tonicOn = NoteOn {
            channel: 0, note: tonic.keynum(), velocity: 100, time: FP32x32 { mag: 0, sign: false }
        };

        let tonicOff = NoteOff {
            channel: 0, note: tonic.keynum(), velocity: 100, time: FP32x32 { mag: 100, sign: false }
        };

        let tonicOn3 = NoteOn {
            channel: 0, note: tonic.keynum(), velocity: 100, time: FP32x32 { mag: 200, sign: false }
        };

        let tonicOff3 = NoteOff {
            channel: 0, note: tonic.keynum(), velocity: 100, time: FP32x32 { mag: 300, sign: false }
        };
        let _tempomessage = Message::SET_TEMPO((newtempo));
        let notemessageon1 = Message::NOTE_ON((tonicOn));
        let notemessageoff1 = Message::NOTE_OFF((tonicOff));

        let notemessageon2 = Message::NOTE_ON((tonicOn3));
        let notemessageoff2 = Message::NOTE_OFF((tonicOff3));

        // eventlist.append(tempomessage);
        eventlist.append(notemessageon1);
        eventlist.append(notemessageoff1);

        eventlist.append(notemessageon2);
        eventlist.append(notemessageoff2);

        let currentmode = mode_steps(Modes::Lydian);

        // if i == 0 {
        //     let chord = maj_7_no_root_3rd_inversion();
        // } else if i == 1 {
        //     let chord = plus_four_7();
        // } else if i == 2 {
        //     let chord = triad_root_position();
        // } else {
        //     let chord = triad_root_position();
        // }
        // let m = chord;

        let mut chorddur = 10;
        let mut counter = 0;
        loop {
            if counter == 2 {
                break;
            }
            let mut chord = plus_four_7();
            let mut chordcount: u64 = counter.try_into().unwrap();

            loop {
                match chord.pop_front() {
                    Option::Some(step_value) => {
                        let newnote = tonic
                            .modal_transposition(
                                tonic, currentmode, *step_value.size, *step_value.direction
                            );

                        let tonicOn2 = NoteOn {
                            channel: 0,
                            note: newnote,
                            velocity: 100,
                            time: FP32x32 { mag: chordcount * 10, sign: false }
                        };
                        let notemessageonc = Message::NOTE_ON((tonicOn2));

                        // println!("chordnote {}", newnote);

                        let tonicOff2 = NoteOff {
                            channel: 0,
                            note: newnote,
                            velocity: 0,
                            time: FP32x32 { mag: (chordcount * 10) + 5, sign: false }
                        };

                        let notemessageoffc = Message::NOTE_OFF((tonicOff2));
                    //   eventlist.append(notemessageonc);
                    //   eventlist.append(notemessageoffc);
                    },
                    Option::None => { break; },
                };
            };
            counter += 1;
        };

        // Generate Chords loop 
        let midiobj = Midi { events: eventlist.span() };

        midiobj.midi_2_file();
        // put midi messages here
        println!("].span()");
        println!("   q2q");
        println!("q2q");
    }
}
