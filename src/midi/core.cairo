use orion::operators::tensor::{Tensor, U32Tensor,};
use orion::numbers::{i32, FP32x32};
use core::option::OptionTrait;
use koji::midi::types::{
    Midi, Message, Modes, ArpPattern, VelocityCurve, NoteOn, NoteOff, SetTempo, TimeSignature,
    ControlChange, PitchWheel, AfterTouch, PolyTouch
};
use alexandria_data_structures::stack::{StackTrait, Felt252Stack, NullableStack};
use alexandria_data_structures::array_ext::{ArrayTraitExt, SpanTraitExt};


trait MidiTrait {
    /// =========== NOTE MANIPULATION ===========
    /// Instantiate a Midi.
    fn new() -> Midi;
    /// Set a message in a Midi object.
    fn set_message(self: @Midi, msg: Message) -> Midi;
    /// Transpose notes by a given number of semitones.
    fn transpose_notes(self: @Midi, semitones: i32) -> Midi;
    ///  Reverse the order of notes.
    fn reverse_notes(self: @Midi) -> Midi;
    /// Align notes to a given rhythmic grid.
    fn quantize_notes(self: @Midi, grid_size: usize) -> Midi;
    /// Extract notes within a specified pitch range.
    fn extract_notes(self: @Midi, note_range: usize) -> Midi;
    /// Change the duration of notes by a given factor
    fn change_note_duration(self: @Midi, factor: i32) -> Midi;
    /// =========== GLOBAL MANIPULATION ===========
    /// Alter the tempo of the Midi data.
    fn change_tempo(self: @Midi, new_tempo: u32) -> Midi;
    /// Change instrument patches based on a provided mapping
    fn remap_instruments(self: @Midi, chanel: u32) -> Midi;
    /// =========== ANALYSIS ===========
    /// Extract the tempo (in BPM) from the Midi data.
    fn get_bpm(self: @Midi) -> u32;
    /// Return statistics about notes (e.g., most frequent note, average note duration).
    /// =========== ADVANCED MANIPULATION ===========
    /// Add harmonies to existing melodies based on specified intervals.
    fn generate_harmony(self: @Midi, modes: Modes) -> Midi;
    /// Convert chords into arpeggios based on a given pattern.
    fn arpeggiate_chords(self: @Midi, pattern: ArpPattern) -> Midi;
    /// Add or modify dynamics (velocity) of notes based on a specified curve or pattern.
    fn edit_dynamics(self: @Midi, curve: VelocityCurve) -> Midi;
}

impl MidiImpl of MidiTrait {
    fn new() -> Midi {
        Midi { events: array![].span() }
    }

    fn set_message(self: @Midi, msg: Message) -> Midi {
        panic(array!['not supported yet'])
    }

    fn transpose_notes(self: @Midi, semitones: i32) -> Midi {
        panic(array!['not supported yet'])
    }

    fn reverse_notes(self: @Midi) -> Midi {
        let mut ev = self.clone().events;
        let mut rev = self.clone().events.reverse().span();
        let lastmsgtime = rev.pop_front();
        let firstmsgtime = ev.pop_front();
        let mut maxtime = FP32x32 { mag: 0, sign: false };
        let mut mintime = FP32x32 { mag: 0, sign: false };
        let mut eventlist = ArrayTrait::<Message>::new();

        //assign maxtime to the last message's time value in the Midi
        match lastmsgtime {
            Option::Some(currentev) => {
                match currentev {
                    Message::NOTE_ON(NoteOn) => {
                        maxtime = *NoteOn.time;
                    },
                    Message::NOTE_OFF(NoteOff) => {
                        maxtime = *NoteOff.time;
                    },
                    Message::SET_TEMPO(SetTempo) => {
                        match *SetTempo.time {
                            Option::Some(time) => {
                                maxtime = time;
                            },
                            Option::None => {},
                        }
                    },
                    Message::TIME_SIGNATURE(TimeSignature) => {
                        match *TimeSignature.time {
                            Option::Some(time) => {
                                maxtime = time;
                            },
                            Option::None => {},
                        }
                    },
                    Message::CONTROL_CHANGE(ControlChange) => {
                        maxtime = *ControlChange.time;
                    },
                    Message::PITCH_WHEEL(PitchWheel) => {
                        maxtime = *PitchWheel.time;
                    },
                    Message::AFTER_TOUCH(AfterTouch) => {
                        maxtime = *AfterTouch.time;
                    },
                    Message::POLY_TOUCH(PolyTouch) => {
                        maxtime = *PolyTouch.time;
                    },
                }
            },
            Option::None(_) => {}
        };

        //assign mintime to the first message's time value
        match firstmsgtime {
            Option::Some(currentev) => {
                match currentev {
                    Message::NOTE_ON(NoteOn) => {
                        mintime = *NoteOn.time;
                    },
                    Message::NOTE_OFF(NoteOff) => {
                        mintime = *NoteOff.time;
                    },
                    Message::SET_TEMPO(SetTempo) => {
                        match *SetTempo.time {
                            Option::Some(time) => {
                                mintime = time;
                            },
                            Option::None => {},
                        }
                    },
                    Message::TIME_SIGNATURE(TimeSignature) => {
                        match *TimeSignature.time {
                            Option::Some(time) => {
                                mintime = time;
                            },
                            Option::None => {},
                        }
                    },
                    Message::CONTROL_CHANGE(ControlChange) => {
                        mintime = *ControlChange.time;
                    },
                    Message::PITCH_WHEEL(PitchWheel) => {
                        mintime = *PitchWheel.time;
                    },
                    Message::AFTER_TOUCH(AfterTouch) => {
                        mintime = *AfterTouch.time;
                    },
                    Message::POLY_TOUCH(PolyTouch) => {
                        mintime = *PolyTouch.time;
                    },
                }
            },
            Option::None(_) => {}
        };

        loop {
            match rev.pop_front() {
                Option::Some(currentevent) => {
                    match currentevent {
                        Message::NOTE_ON(NoteOn) => {
                            let newnote = NoteOff {
                                channel: *NoteOn.channel,
                                note: *NoteOn.note,
                                velocity: *NoteOn.velocity,
                                time: ((maxtime - *NoteOn.time) + mintime)
                            };
                            let notemessage = Message::NOTE_OFF((newnote));
                            eventlist.append(notemessage);
                        },
                        Message::NOTE_OFF(NoteOff) => {
                            let newnote = NoteOn {
                                channel: *NoteOff.channel,
                                note: *NoteOff.note,
                                velocity: *NoteOff.velocity,
                                time: (maxtime - *NoteOff.time) + mintime
                            };
                            let notemessage = Message::NOTE_ON((newnote));
                            eventlist.append(notemessage);
                        },
                        Message::SET_TEMPO(SetTempo) => {
                            let scaledtempo = SetTempo {
                                tempo: *SetTempo.tempo,
                                time: match *SetTempo.time {
                                    Option::Some(time) => Option::Some((maxtime - time) + mintime),
                                    Option::None => Option::None,
                                }
                            };
                            let tempomessage = Message::SET_TEMPO((scaledtempo));
                            eventlist.append(tempomessage);
                        },
                        Message::TIME_SIGNATURE(TimeSignature) => {
                            let newtimesig = TimeSignature {
                                numerator: *TimeSignature.numerator,
                                denominator: *TimeSignature.denominator,
                                clocks_per_click: *TimeSignature.clocks_per_click,
                                time: match *TimeSignature.time {
                                    Option::Some(time) => Option::Some((maxtime - time) + mintime),
                                    Option::None => Option::None,
                                }
                            };
                            let tsmessage = Message::TIME_SIGNATURE((newtimesig));
                            eventlist.append(tsmessage);
                        },
                        Message::CONTROL_CHANGE(ControlChange) => {
                            let newcontrolchange = ControlChange {
                                channel: *ControlChange.channel,
                                control: *ControlChange.control,
                                value: *ControlChange.value,
                                time: (maxtime - *ControlChange.time) + mintime
                            };
                            let ccmessage = Message::CONTROL_CHANGE((newcontrolchange));
                            eventlist.append(ccmessage);
                        },
                        Message::PITCH_WHEEL(PitchWheel) => {
                            let newpitchwheel = PitchWheel {
                                channel: *PitchWheel.channel,
                                pitch: *PitchWheel.pitch,
                                time: (maxtime - *PitchWheel.time) + mintime
                            };
                            let pwmessage = Message::PITCH_WHEEL((newpitchwheel));
                            eventlist.append(pwmessage);
                        },
                        Message::AFTER_TOUCH(AfterTouch) => {
                            let newaftertouch = AfterTouch {
                                channel: *AfterTouch.channel,
                                value: *AfterTouch.value,
                                time: (maxtime - *AfterTouch.time) + mintime
                            };
                            let atmessage = Message::AFTER_TOUCH((newaftertouch));
                            eventlist.append(atmessage);
                        },
                        Message::POLY_TOUCH(PolyTouch) => {
                            let newpolytouch = PolyTouch {
                                channel: *PolyTouch.channel,
                                note: *PolyTouch.note,
                                value: *PolyTouch.value,
                                time: (maxtime - *PolyTouch.time) + mintime
                            };
                            let ptmessage = Message::POLY_TOUCH((newpolytouch));
                            eventlist.append(ptmessage);
                        },
                    }
                },
                Option::None(_) => {
                    break;
                }
            };
        };

        Midi { events: eventlist.span() }
    }

    fn quantize_notes(self: @Midi, grid_size: usize) -> Midi {
        panic(array!['not supported yet'])
    }

    fn extract_notes(self: @Midi, note_range: usize) -> Midi {
        panic(array!['not supported yet'])
    }
    fn change_note_duration(self: @Midi, factor: i32) -> Midi {
        panic(array!['not supported yet'])
    }

    fn change_tempo(self: @Midi, new_tempo: u32) -> Midi {
        panic(array!['not supported yet'])
    }

    fn remap_instruments(self: @Midi, chanel: u32) -> Midi {
        panic(array!['not supported yet'])
    }

    fn get_bpm(self: @Midi) -> u32 {
        panic(array!['not supported yet'])
    }

    fn generate_harmony(self: @Midi, modes: Modes) -> Midi {
        panic(array!['not supported yet'])
    }

    fn arpeggiate_chords(self: @Midi, pattern: ArpPattern) -> Midi {
        panic(array!['not supported yet'])
    }

    fn edit_dynamics(self: @Midi, curve: VelocityCurve) -> Midi {
        panic(array!['not supported yet'])
    }
}
