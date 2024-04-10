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
    fn midi_to_cairo_file_test() {
        // q1q -> {
        // q2q -> }
        // q3q -> ;
        // q4q -> _
        println!("use orion::numbers::FP32x32q3q");
        println!(
            "use koji::midi::types::q1qMidi, Message, NoteOn, NoteOff, SetTempo, TimeSignature, ControlChange, PitchWheel, AfterTouch, PolyTouch, Modesq2qq3q"
        );
        println!("fn midi() -> Midi q1q");
        println!("Midi q1q");
        println!("events: array![");

        let mut eventlist = ArrayTrait::<Message>::new();

        // let newtempo = SetTempo {
        //     tempo: 0, time: Option::Some(FP32x32 { mag: 33242, sign: false })
        // };

        let newnoteon1 = NoteOn {
            channel: 0, note: 60, velocity: 100, time: FP32x32 { mag: 100, sign: false }
        };

        let notetwomag = FP32x32 { mag: 1000, sign: false };

        let newnoteon2 = NoteOn { channel: 0, note: 71, velocity: 100, time: notetwomag };

        let newnoteon3 = NoteOn {
            channel: 0, note: 88, velocity: 100, time: FP32x32 { mag: 2000, sign: false }
        };

        let newnoteoff1 = NoteOff {
            channel: 0, note: 60, velocity: 100, time: FP32x32 { mag: 2000, sign: false }
        };

        let newnoteoff2 = NoteOff {
            channel: 0, note: 71, velocity: 100, time: FP32x32 { mag: 4000, sign: false }
        };

        let newnoteoff3 = NoteOff {
            channel: 0, note: 88, velocity: 100, time: FP32x32 { mag: 5000, sign: false }
        };
        // let tempomessage = Message::SET_TEMPO((newtempo));

        let notemessageon1 = Message::NOTE_ON((newnoteon1));
        let notemessageon2 = Message::NOTE_ON((newnoteon2));
        let notemessageon3 = Message::NOTE_ON((newnoteon3));

        let notemessageoff1 = Message::NOTE_OFF((newnoteoff1));
        let notemessageoff2 = Message::NOTE_OFF((newnoteoff2));
        let notemessageoff3 = Message::NOTE_OFF((newnoteoff3));

        eventlist.append(tempomessage);

        eventlist.append(notemessageon1);
        eventlist.append(notemessageon2);
        eventlist.append(notemessageon3);

        eventlist.append(notemessageoff1);
        eventlist.append(notemessageoff2);
        eventlist.append(notemessageoff3);

        let midiobj = Midi { events: eventlist.span() };

        midiobj.midi_2_file();
        // put midi messages here
        println!("].span()");
        println!("   q2q");
        println!("q2q");
    }
}
