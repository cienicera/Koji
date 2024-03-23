/// =========================================
/// ============= General MIDI ==============
/// =========================================

// Specification for electronic musical instruments that ensures compatibility 
// across different devices and platforms. It defines a set of 128 instrument sounds 
// along with their respective Program Change numbers.

#[derive(Copy, Drop)]
enum GeneralMidiInstrument {
    PIANO: Piano,
    CHROMATIC_PERCUSSION: ChromaticPercussion,
    ORGAN: Organ,
    GUITAR: Guitar,
    BASS: Bass,
    STRINGS: Strings,
    ENSEMBLE: Ensemble,
    BRASS: Brass,
    REED: Reed,
    PIPE: Pipe,
    SYNTH_LEAD: SynthLead,
    SYNTH_PAD: SynthPad,
    SYNTH_EFFECTS: SynthEffects,
    ETHNIC: Ethnic,
    PERCUSSIVE: Percussive,
    SOUND_EFFECTS: SoundEffects,
}

#[derive(Copy, Drop)]
enum Piano {
    AcousticGrandPiano,
    BrightAcousticPiano,
    ElectricGrandPiano,
    HonkyTonkPiano,
    ElectricPiano1,
    ElectricPiano2,
    Harpsichord,
    Clavinet,
}

#[derive(Copy, Drop)]
enum ChromaticPercussion {
    Celesta,
    Glockenspiel,
    MusicBox,
    Vibraphone,
    Marimba,
    Xylophone,
    TubularBells,
    Dulcimer,
}

#[derive(Copy, Drop)]
enum Organ {
    DrawbarOrgan,
    PercussiveOrgan,
    RockOrgan,
    ChurchOrgan,
    ReedOrgan,
    Accordion,
    Harmonica,
    TangoAccordion,
}

#[derive(Copy, Drop)]
enum Guitar {
    AcousticGuitarNylon,
    AcousticGuitarSteel,
    ElectricGuitarJazz,
    ElectricGuitarClean,
    ElectricGuitarMuted,
    OverdrivenGuitar,
    DistortionGuitar,
    GuitarHarmonics,
}

#[derive(Copy, Drop)]
enum Bass {
    AcousticBass,
    ElectricBassFinger,
    ElectricBassPick,
    FretlessBass,
    SlapBass1,
    SlapBass2,
    SynthBass1,
    SynthBass2,
}

#[derive(Copy, Drop)]
enum Strings {
    Violin,
    Viola,
    Cello,
    Contrabass,
    TremoloStrings,
    PizzicatoStrings,
    OrchestralHarp,
    Timpani,
}

#[derive(Copy, Drop)]
enum Ensemble {
    StringEnsemble1,
    StringEnsemble2,
    SynthStrings1,
    SynthStrings2,
    ChoirAahs,
    VoiceOohs,
    SynthVoice,
    OrchestraHit,
}

#[derive(Copy, Drop)]
enum Brass {
    Trumpet,
    Trombone,
    Tuba,
    MutedTrumpet,
    FrenchHorn,
    BrassSection,
    SynthBrass1,
    SynthBrass2,
}

#[derive(Copy, Drop)]
enum Reed {
    SopranoSax,
    AltoSax,
    TenorSax,
    BaritoneSax,
    Oboe,
    EnglishHorn,
    Bassoon,
    Clarinet,
}

#[derive(Copy, Drop)]
enum Pipe {
    Piccolo,
    Flute,
    Recorder,
    PanFlute,
    BlownBottle,
    Shakuhachi,
    Whistle,
    Ocarina,
}

#[derive(Copy, Drop)]
enum SynthLead {
    Lead1Square,
    Lead2Sawtooth,
    Lead3Calliope,
    Lead4Chiff,
    Lead5Charang,
    Lead6Voice,
    Lead7Fifths,
    Lead8BassAndLead,
}

#[derive(Copy, Drop)]
enum SynthPad {
    Pad1NewAge,
    Pad2Warm,
    Pad3Polysynth,
    Pad4Choir,
    Pad5Bowed,
    Pad6Metallic,
    Pad7Halo,
    Pad8Sweep,
}

#[derive(Copy, Drop)]
enum SynthEffects {
    FX1Rain,
    FX2Soundtrack,
    FX3Crystal,
    FX4Atmosphere,
    FX5Brightness,
    FX6Goblins,
    FX7Echoes,
    FX8SciFi,
}

#[derive(Copy, Drop)]
enum Ethnic {
    Sitar,
    Banjo,
    Shamisen,
    Koto,
    Kalimba,
    Bagpipe,
    Fiddle,
    Shanai,
}

#[derive(Copy, Drop)]
enum Percussive {
    TinkleBell,
    Agogo,
    SteelDrums,
    Woodblock,
    TaikoDrum,
    MelodicTom,
    SynthDrum,
    ReverseCymbal,
}

#[derive(Copy, Drop)]
enum SoundEffects {
    GuitarFretNoise,
    BreathNoise,
    Seashore,
    BirdTweet,
    TelephoneRing,
    Helicopter,
    Applause,
    Gunshot,
}

// Could break up Each Instrument into separate function

fn instrument_name(instrument: GeneralMidiInstrument) -> felt252 {
    match instrument {
        GeneralMidiInstrument::PIANO(piano) => match piano {
            Piano::AcousticGrandPiano => 'Acoustic Grand Piano',
            Piano::BrightAcousticPiano => 'Bright Acoustic Piano',
            Piano::ElectricGrandPiano => 'Electric Grand Piano',
            Piano::HonkyTonkPiano => 'Honky Tonk Piano',
            Piano::ElectricPiano1 => 'Electric Piano 1',
            Piano::ElectricPiano2 => 'Electric Piano 2',
            Piano::Harpsichord => 'Harpsichord',
            Piano::Clavinet => 'Clavinet',
        },
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(percussion) => match percussion {
            ChromaticPercussion::Celesta => 'Celesta',
            ChromaticPercussion::Glockenspiel => 'Glockenspiel',
            ChromaticPercussion::MusicBox => 'Music Box',
            ChromaticPercussion::Vibraphone => 'Vibraphone',
            ChromaticPercussion::Marimba => 'Marimba',
            ChromaticPercussion::Xylophone => 'Xylophone',
            ChromaticPercussion::TubularBells => 'Tubular Bells',
            ChromaticPercussion::Dulcimer => 'Dulcimer',
        },
        GeneralMidiInstrument::ORGAN(organ) => match organ {
            Organ::DrawbarOrgan => 'Drawbar Organ',
            Organ::PercussiveOrgan => 'Percussive Organ',
            Organ::RockOrgan => 'Rock Organ',
            Organ::ChurchOrgan => 'Church Organ',
            Organ::ReedOrgan => 'Reed Organ',
            Organ::Accordion => 'Accordion',
            Organ::Harmonica => 'Harmonica',
            Organ::TangoAccordion => 'Tango Accordion',
        },
        GeneralMidiInstrument::GUITAR(guitar) => match guitar {
            Guitar::AcousticGuitarNylon => 'Acoustic Guitar Nylon',
            Guitar::AcousticGuitarSteel => 'Acoustic Guitar Steel',
            Guitar::ElectricGuitarJazz => 'Electric Guitar Jazz',
            Guitar::ElectricGuitarClean => 'Electric Guitar Clean',
            Guitar::ElectricGuitarMuted => 'Electric Guitar Muted',
            Guitar::OverdrivenGuitar => 'Overdriven Guitar',
            Guitar::DistortionGuitar => 'Distortion Guitar',
            Guitar::GuitarHarmonics => 'Guitar Harmonics',
        },
        GeneralMidiInstrument::BASS(bass) => match bass {
            Bass::AcousticBass => 'Acoustic Bass',
            Bass::ElectricBassFinger => 'Electric Bass Finger',
            Bass::ElectricBassPick => 'Electric Bass Pick',
            Bass::FretlessBass => 'Fretless Bass',
            Bass::SlapBass1 => 'Slap Bass 1',
            Bass::SlapBass2 => 'Slap Bass 2',
            Bass::SynthBass1 => 'Synth Bass 1',
            Bass::SynthBass2 => 'Synth Bass 2',
        },
        GeneralMidiInstrument::STRINGS(strings) => match strings {
            Strings::Violin => 'Violin',
            Strings::Viola => 'Viola',
            Strings::Cello => 'Cello',
            Strings::Contrabass => 'Contrabass',
            Strings::TremoloStrings => 'Tremolo Strings',
            Strings::PizzicatoStrings => 'Pizzicato Strings',
            Strings::OrchestralHarp => 'Orchestral Harp',
            Strings::Timpani => 'Timpani',
        },
        GeneralMidiInstrument::ENSEMBLE(ensemble) => match ensemble {
            Ensemble::StringEnsemble1 => 'String Ensemble 1',
            Ensemble::StringEnsemble2 => 'String Ensemble 2',
            Ensemble::SynthStrings1 => 'Synth Strings 1',
            Ensemble::SynthStrings2 => 'Synth Strings 2',
            Ensemble::ChoirAahs => 'Choir Aahs',
            Ensemble::VoiceOohs => 'Voice Oohs',
            Ensemble::SynthVoice => 'Synth Voice',
            Ensemble::OrchestraHit => 'Orchestra Hit',
        },
        GeneralMidiInstrument::BRASS(brass) => match brass {
            Brass::Trumpet => 'Trumpet',
            Brass::Trombone => 'Trombone',
            Brass::Tuba => 'Tuba',
            Brass::MutedTrumpet => 'Muted Trumpet',
            Brass::FrenchHorn => 'French Horn',
            Brass::BrassSection => 'Brass Section',
            Brass::SynthBrass1 => 'Synth Brass 1',
            Brass::SynthBrass2 => 'Synth Brass 2',
        },
        GeneralMidiInstrument::REED(reed) => match reed {
            Reed::SopranoSax => 'Soprano Sax',
            Reed::AltoSax => 'Alto Sax',
            Reed::TenorSax => 'Tenor Sax',
            Reed::BaritoneSax => 'Baritone Sax',
            Reed::Oboe => 'Oboe',
            Reed::EnglishHorn => 'English Horn',
            Reed::Bassoon => 'Bassoon',
            Reed::Clarinet => 'Clarinet',
        },
        GeneralMidiInstrument::PIPE(pipe) => match pipe {
            Pipe::Piccolo => 'Piccolo',
            Pipe::Flute => 'Flute',
            Pipe::Recorder => 'Recorder',
            Pipe::PanFlute => 'Pan Flute',
            Pipe::BlownBottle => 'Blown Bottle',
            Pipe::Shakuhachi => 'Shakuhachi',
            Pipe::Whistle => 'Whistle',
            Pipe::Ocarina => 'Ocarina',
        },
        GeneralMidiInstrument::SYNTH_LEAD(synth_lead) => match synth_lead {
            SynthLead::Lead1Square => 'Lead 1 (Square)',
            SynthLead::Lead2Sawtooth => 'Lead 2 (Sawtooth)',
            SynthLead::Lead3Calliope => 'Lead 3 (Calliope)',
            SynthLead::Lead4Chiff => 'Lead 4 (Chiff)',
            SynthLead::Lead5Charang => 'Lead 5 (Charang)',
            SynthLead::Lead6Voice => 'Lead 6 (Voice)',
            SynthLead::Lead7Fifths => 'Lead 7 (Fifths)',
            SynthLead::Lead8BassAndLead => 'Lead 8 (Bass and Lead)',
        },
        GeneralMidiInstrument::SYNTH_PAD(synth_pad) => match synth_pad {
            SynthPad::Pad1NewAge => 'Pad 1 (New Age)',
            SynthPad::Pad2Warm => 'Pad 2 (Warm)',
            SynthPad::Pad3Polysynth => 'Pad 3 (Polysynth)',
            SynthPad::Pad4Choir => 'Pad 4 (Choir)',
            SynthPad::Pad5Bowed => 'Pad 5 (Bowed)',
            SynthPad::Pad6Metallic => 'Pad 6 (Metallic)',
            SynthPad::Pad7Halo => 'Pad 7 (Halo)',
            SynthPad::Pad8Sweep => 'Pad 8 (Sweep)',
        },
        GeneralMidiInstrument::SYNTH_EFFECTS(synth_effects) => match synth_effects {
            SynthEffects::FX1Rain => 'FX 1 (Rain)',
            SynthEffects::FX2Soundtrack => 'FX 2 (Soundtrack)',
            SynthEffects::FX3Crystal => 'FX 3 (Crystal)',
            SynthEffects::FX4Atmosphere => 'FX 4 (Atmosphere)',
            SynthEffects::FX5Brightness => 'FX 5 (Brightness)',
            SynthEffects::FX6Goblins => 'FX 6 (Goblins)',
            SynthEffects::FX7Echoes => 'FX 7 (Echoes)',
            SynthEffects::FX8SciFi => 'FX 8 (Sci-Fi)',
        },
        GeneralMidiInstrument::ETHNIC(ethnic) => match ethnic {
            Ethnic::Sitar => 'Sitar',
            Ethnic::Banjo => 'Banjo',
            Ethnic::Shamisen => 'Shamisen',
            Ethnic::Koto => 'Koto',
            Ethnic::Kalimba => 'Kalimba',
            Ethnic::Bagpipe => 'Bagpipe',
            Ethnic::Fiddle => 'Fiddle',
            Ethnic::Shanai => 'Shanai',
        },
        GeneralMidiInstrument::PERCUSSIVE(percussive) => match percussive {
            Percussive::TinkleBell => 'Tinkle Bell',
            Percussive::Agogo => 'Agogo',
            Percussive::SteelDrums => 'Steel Drums',
            Percussive::Woodblock => 'Woodblock',
            Percussive::TaikoDrum => 'Taiko Drum',
            Percussive::MelodicTom => 'Melodic Tom',
            Percussive::SynthDrum => 'Synth Drum',
            Percussive::ReverseCymbal => 'Reverse Cymbal',
        },
        GeneralMidiInstrument::SOUND_EFFECTS(sound_effect) => match sound_effect {
            SoundEffects::GuitarFretNoise => 'Guitar Fret Noise',
            SoundEffects::BreathNoise => 'Breath Noise',
            SoundEffects::Seashore => 'Seashore',
            SoundEffects::BirdTweet => 'Bird Tweet',
            SoundEffects::TelephoneRing => 'Telephone Ring',
            SoundEffects::Helicopter => 'Helicopter',
            SoundEffects::Applause => 'Applause',
            SoundEffects::Gunshot => 'Gunshot',
        },
    }
}

fn instrument_to_program_change(instrument: GeneralMidiInstrument) -> u8 {
    match instrument {
        GeneralMidiInstrument::PIANO(piano) => match piano {
            Piano::AcousticGrandPiano => 0,
            Piano::BrightAcousticPiano => 1,
            Piano::ElectricGrandPiano => 2,
            Piano::HonkyTonkPiano => 3,
            Piano::ElectricPiano1 => 4,
            Piano::ElectricPiano2 => 5,
            Piano::Harpsichord => 6,
            Piano::Clavinet => 7,
        },
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(percussion) => match percussion {
            ChromaticPercussion::Celesta => 8,
            ChromaticPercussion::Glockenspiel => 9,
            ChromaticPercussion::MusicBox => 10,
            ChromaticPercussion::Vibraphone => 11,
            ChromaticPercussion::Marimba => 12,
            ChromaticPercussion::Xylophone => 13,
            ChromaticPercussion::TubularBells => 14,
            ChromaticPercussion::Dulcimer => 15,
        },
        GeneralMidiInstrument::ORGAN(organ) => match organ {
            Organ::DrawbarOrgan => 16,
            Organ::PercussiveOrgan => 17,
            Organ::RockOrgan => 18,
            Organ::ChurchOrgan => 19,
            Organ::ReedOrgan => 20,
            Organ::Accordion => 21,
            Organ::Harmonica => 22,
            Organ::TangoAccordion => 23,
        },
        GeneralMidiInstrument::GUITAR(guitar) => match guitar {
            Guitar::AcousticGuitarNylon => 24,
            Guitar::AcousticGuitarSteel => 25,
            Guitar::ElectricGuitarJazz => 26,
            Guitar::ElectricGuitarClean => 27,
            Guitar::ElectricGuitarMuted => 28,
            Guitar::OverdrivenGuitar => 29,
            Guitar::DistortionGuitar => 30,
            Guitar::GuitarHarmonics => 31,
        },
        GeneralMidiInstrument::BASS(bass) => match bass {
            Bass::AcousticBass => 32,
            Bass::ElectricBassFinger => 33,
            Bass::ElectricBassPick => 34,
            Bass::FretlessBass => 35,
            Bass::SlapBass1 => 36,
            Bass::SlapBass2 => 37,
            Bass::SynthBass1 => 38,
            Bass::SynthBass2 => 39,
        },
        GeneralMidiInstrument::STRINGS(strings) => match strings {
            Strings::Violin => 40,
            Strings::Viola => 41,
            Strings::Cello => 42,
            Strings::Contrabass => 43,
            Strings::TremoloStrings => 44,
            Strings::PizzicatoStrings => 45,
            Strings::OrchestralHarp => 46,
            Strings::Timpani => 47,
        },
        GeneralMidiInstrument::ENSEMBLE(ensemble) => match ensemble {
            Ensemble::StringEnsemble1 => 48,
            Ensemble::StringEnsemble2 => 49,
            Ensemble::SynthStrings1 => 50,
            Ensemble::SynthStrings2 => 51,
            Ensemble::ChoirAahs => 52,
            Ensemble::VoiceOohs => 53,
            Ensemble::SynthVoice => 54,
            Ensemble::OrchestraHit => 55,
        },
        GeneralMidiInstrument::BRASS(brass) => match brass {
            Brass::Trumpet => 56,
            Brass::Trombone => 57,
            Brass::Tuba => 58,
            Brass::MutedTrumpet => 59,
            Brass::FrenchHorn => 60,
            Brass::BrassSection => 61,
            Brass::SynthBrass1 => 62,
            Brass::SynthBrass2 => 63,
        },
        GeneralMidiInstrument::REED(reed) => match reed {
            Reed::SopranoSax => 64,
            Reed::AltoSax => 65,
            Reed::TenorSax => 66,
            Reed::BaritoneSax => 67,
            Reed::Oboe => 68,
            Reed::EnglishHorn => 69,
            Reed::Bassoon => 70,
            Reed::Clarinet => 71,
        },
        GeneralMidiInstrument::PIPE(pipe) => match pipe {
            Pipe::Piccolo => 72,
            Pipe::Flute => 73,
            Pipe::Recorder => 74,
            Pipe::PanFlute => 75,
            Pipe::BlownBottle => 76,
            Pipe::Shakuhachi => 77,
            Pipe::Whistle => 78,
            Pipe::Ocarina => 79,
        },
        GeneralMidiInstrument::SYNTH_LEAD(synth_lead) => match synth_lead {
            SynthLead::Lead1Square => 80,
            SynthLead::Lead2Sawtooth => 81,
            SynthLead::Lead3Calliope => 82,
            SynthLead::Lead4Chiff => 83,
            SynthLead::Lead5Charang => 84,
            SynthLead::Lead6Voice => 85,
            SynthLead::Lead7Fifths => 86,
            SynthLead::Lead8BassAndLead => 87,
        },
        GeneralMidiInstrument::SYNTH_PAD(synth_pad) => match synth_pad {
            SynthPad::Pad1NewAge => 88,
            SynthPad::Pad2Warm => 89,
            SynthPad::Pad3Polysynth => 90,
            SynthPad::Pad4Choir => 91,
            SynthPad::Pad5Bowed => 92,
            SynthPad::Pad6Metallic => 93,
            SynthPad::Pad7Halo => 94,
            SynthPad::Pad8Sweep => 95,
        },
        GeneralMidiInstrument::SYNTH_EFFECTS(synth_effects) => match synth_effects {
            SynthEffects::FX1Rain => 96,
            SynthEffects::FX2Soundtrack => 97,
            SynthEffects::FX3Crystal => 98,
            SynthEffects::FX4Atmosphere => 99,
            SynthEffects::FX5Brightness => 100,
            SynthEffects::FX6Goblins => 101,
            SynthEffects::FX7Echoes => 102,
            SynthEffects::FX8SciFi => 103,
        },
        GeneralMidiInstrument::ETHNIC(ethnic) => match ethnic {
            Ethnic::Sitar => 104,
            Ethnic::Banjo => 105,
            Ethnic::Shamisen => 106,
            Ethnic::Koto => 107,
            Ethnic::Kalimba => 108,
            Ethnic::Bagpipe => 109,
            Ethnic::Fiddle => 110,
            Ethnic::Shanai => 111,
        },
        GeneralMidiInstrument::PERCUSSIVE(percussive) => match percussive {
            Percussive::TinkleBell => 112,
            Percussive::Agogo => 113,
            Percussive::SteelDrums => 114,
            Percussive::Woodblock => 115,
            Percussive::TaikoDrum => 116,
            Percussive::MelodicTom => 117,
            Percussive::SynthDrum => 118,
            Percussive::ReverseCymbal => 119,
        },
        GeneralMidiInstrument::SOUND_EFFECTS(sound_effect) => match sound_effect {
            SoundEffects::GuitarFretNoise => 120,
            SoundEffects::BreathNoise => 121,
            SoundEffects::Seashore => 122,
            SoundEffects::BirdTweet => 123,
            SoundEffects::TelephoneRing => 124,
            SoundEffects::Helicopter => 125,
            SoundEffects::Applause => 126,
            SoundEffects::Gunshot => 127,
        },
    }
}

fn program_change_to_instrument(program_change: u8) -> GeneralMidiInstrument {
    let instrument = if program_change == 1 {
        GeneralMidiInstrument::PIANO(Piano::BrightAcousticPiano)
    } else if program_change == 2 {
        GeneralMidiInstrument::PIANO(Piano::ElectricGrandPiano)
    } else if program_change == 3 {
        GeneralMidiInstrument::PIANO(Piano::HonkyTonkPiano)
    } else if program_change == 4 {
        GeneralMidiInstrument::PIANO(Piano::ElectricPiano1)
    } else if program_change == 5 {
        GeneralMidiInstrument::PIANO(Piano::ElectricPiano2)
    } else if program_change == 6 {
        GeneralMidiInstrument::PIANO(Piano::Harpsichord)
    } else if program_change == 7 {
        GeneralMidiInstrument::PIANO(Piano::Clavinet)
    } else if program_change == 8 {
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(ChromaticPercussion::Celesta)
    } else if program_change == 9 {
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(ChromaticPercussion::Glockenspiel)
    } else if program_change == 10 {
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(ChromaticPercussion::MusicBox)
    } else if program_change == 11 {
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(ChromaticPercussion::Vibraphone)
    } else if program_change == 12 {
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(ChromaticPercussion::Marimba)
    } else if program_change == 13 {
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(ChromaticPercussion::Xylophone)
    } else if program_change == 14 {
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(ChromaticPercussion::TubularBells)
    } else if program_change == 15 {
        GeneralMidiInstrument::CHROMATIC_PERCUSSION(ChromaticPercussion::Dulcimer)
    } else if program_change == 16 {
        GeneralMidiInstrument::ORGAN(Organ::DrawbarOrgan)
    } else if program_change == 17 {
        GeneralMidiInstrument::ORGAN(Organ::PercussiveOrgan)
    } else if program_change == 18 {
        GeneralMidiInstrument::ORGAN(Organ::RockOrgan)
    } else if program_change == 19 {
        GeneralMidiInstrument::ORGAN(Organ::ChurchOrgan)
    } else if program_change == 20 {
        GeneralMidiInstrument::ORGAN(Organ::ReedOrgan)
    } else if program_change == 21 {
        GeneralMidiInstrument::ORGAN(Organ::Accordion)
    } else if program_change == 22 {
        GeneralMidiInstrument::ORGAN(Organ::Harmonica)
    } else if program_change == 23 {
        GeneralMidiInstrument::ORGAN(Organ::TangoAccordion)
    } else if program_change == 24 {
        GeneralMidiInstrument::GUITAR(Guitar::AcousticGuitarNylon)
    } else if program_change == 25 {
        GeneralMidiInstrument::GUITAR(Guitar::AcousticGuitarSteel)
    } else if program_change == 26 {
        GeneralMidiInstrument::GUITAR(Guitar::ElectricGuitarJazz)
    } else if program_change == 27 {
        GeneralMidiInstrument::GUITAR(Guitar::ElectricGuitarClean)
    } else if program_change == 28 {
        GeneralMidiInstrument::GUITAR(Guitar::ElectricGuitarMuted)
    } else if program_change == 29 {
        GeneralMidiInstrument::GUITAR(Guitar::OverdrivenGuitar)
    } else if program_change == 30 {
        GeneralMidiInstrument::GUITAR(Guitar::DistortionGuitar)
    } else if program_change == 31 {
        GeneralMidiInstrument::GUITAR(Guitar::GuitarHarmonics)
    } else if program_change == 32 {
        GeneralMidiInstrument::BASS(Bass::AcousticBass)
    } else if program_change == 33 {
        GeneralMidiInstrument::BASS(Bass::ElectricBassFinger)
    } else if program_change == 34 {
        GeneralMidiInstrument::BASS(Bass::ElectricBassPick)
    } else if program_change == 35 {
        GeneralMidiInstrument::BASS(Bass::FretlessBass)
    } else if program_change == 36 {
        GeneralMidiInstrument::BASS(Bass::SlapBass1)
    } else if program_change == 37 {
        GeneralMidiInstrument::BASS(Bass::SlapBass2)
    } else if program_change == 38 {
        GeneralMidiInstrument::BASS(Bass::SynthBass1)
    } else if program_change == 39 {
        GeneralMidiInstrument::BASS(Bass::SynthBass2)
    } else if program_change == 40 {
        GeneralMidiInstrument::STRINGS(Strings::Violin)
    } else if program_change == 41 {
        GeneralMidiInstrument::STRINGS(Strings::Viola)
    } else if program_change == 42 {
        GeneralMidiInstrument::STRINGS(Strings::Cello)
    } else if program_change == 43 {
        GeneralMidiInstrument::STRINGS(Strings::Contrabass)
    } else if program_change == 44 {
        GeneralMidiInstrument::STRINGS(Strings::TremoloStrings)
    } else if program_change == 45 {
        GeneralMidiInstrument::STRINGS(Strings::PizzicatoStrings)
    } else if program_change == 46 {
        GeneralMidiInstrument::STRINGS(Strings::OrchestralHarp)
    } else if program_change == 47 {
        GeneralMidiInstrument::STRINGS(Strings::Timpani)
    } else if program_change == 48 {
        GeneralMidiInstrument::ENSEMBLE(Ensemble::StringEnsemble1)
    } else if program_change == 49 {
        GeneralMidiInstrument::ENSEMBLE(Ensemble::StringEnsemble2)
    } else if program_change == 50 {
        GeneralMidiInstrument::ENSEMBLE(Ensemble::SynthStrings1)
    } else if program_change == 51 {
        GeneralMidiInstrument::ENSEMBLE(Ensemble::SynthStrings2)
    } else if program_change == 52 {
        GeneralMidiInstrument::ENSEMBLE(Ensemble::ChoirAahs)
    } else if program_change == 53 {
        GeneralMidiInstrument::ENSEMBLE(Ensemble::VoiceOohs)
    } else if program_change == 54 {
        GeneralMidiInstrument::ENSEMBLE(Ensemble::SynthVoice)
    } else if program_change == 55 {
        GeneralMidiInstrument::ENSEMBLE(Ensemble::OrchestraHit)
    } else if program_change == 56 {
        GeneralMidiInstrument::BRASS(Brass::Trumpet)
    } else if program_change == 57 {
        GeneralMidiInstrument::BRASS(Brass::Trombone)
    } else if program_change == 58 {
        GeneralMidiInstrument::BRASS(Brass::Tuba)
    } else if program_change == 59 {
        GeneralMidiInstrument::BRASS(Brass::MutedTrumpet)
    } else if program_change == 60 {
        GeneralMidiInstrument::BRASS(Brass::FrenchHorn)
    } else if program_change == 61 {
        GeneralMidiInstrument::BRASS(Brass::BrassSection)
    } else if program_change == 62 {
        GeneralMidiInstrument::BRASS(Brass::SynthBrass1)
    } else if program_change == 63 {
        GeneralMidiInstrument::BRASS(Brass::SynthBrass2)
    } else if program_change == 64 {
        GeneralMidiInstrument::REED(Reed::SopranoSax)
    } else if program_change == 65 {
        GeneralMidiInstrument::REED(Reed::AltoSax)
    } else if program_change == 66 {
        GeneralMidiInstrument::REED(Reed::TenorSax)
    } else if program_change == 67 {
        GeneralMidiInstrument::REED(Reed::BaritoneSax)
    } else if program_change == 68 {
        GeneralMidiInstrument::REED(Reed::Oboe)
    } else if program_change == 69 {
        GeneralMidiInstrument::REED(Reed::EnglishHorn)
    } else if program_change == 70 {
        GeneralMidiInstrument::REED(Reed::Bassoon)
    } else if program_change == 71 {
        GeneralMidiInstrument::REED(Reed::Clarinet)
    } else if program_change == 72 {
        GeneralMidiInstrument::PIPE(Pipe::Piccolo)
    } else if program_change == 73 {
        GeneralMidiInstrument::PIPE(Pipe::Flute)
    } else if program_change == 74 {
        GeneralMidiInstrument::PIPE(Pipe::Recorder)
    } else if program_change == 75 {
        GeneralMidiInstrument::PIPE(Pipe::PanFlute)
    } else if program_change == 76 {
        GeneralMidiInstrument::PIPE(Pipe::BlownBottle)
    } else if program_change == 77 {
        GeneralMidiInstrument::PIPE(Pipe::Shakuhachi)
    } else if program_change == 78 {
        GeneralMidiInstrument::PIPE(Pipe::Whistle)
    } else if program_change == 79 {
        GeneralMidiInstrument::PIPE(Pipe::Ocarina)
    } else if program_change == 80 {
        GeneralMidiInstrument::SYNTH_LEAD(SynthLead::Lead1Square)
    } else if program_change == 81 {
        GeneralMidiInstrument::SYNTH_LEAD(SynthLead::Lead2Sawtooth)
    } else if program_change == 82 {
        GeneralMidiInstrument::SYNTH_LEAD(SynthLead::Lead3Calliope)
    } else if program_change == 83 {
        GeneralMidiInstrument::SYNTH_LEAD(SynthLead::Lead4Chiff)
    } else if program_change == 84 {
        GeneralMidiInstrument::SYNTH_LEAD(SynthLead::Lead5Charang)
    } else if program_change == 85 {
        GeneralMidiInstrument::SYNTH_LEAD(SynthLead::Lead6Voice)
    } else if program_change == 86 {
        GeneralMidiInstrument::SYNTH_LEAD(SynthLead::Lead7Fifths)
    } else if program_change == 87 {
        GeneralMidiInstrument::SYNTH_LEAD(SynthLead::Lead8BassAndLead)
    } else if program_change == 88 {
        GeneralMidiInstrument::SYNTH_PAD(SynthPad::Pad1NewAge)
    } else if program_change == 89 {
        GeneralMidiInstrument::SYNTH_PAD(SynthPad::Pad2Warm)
    } else if program_change == 90 {
        GeneralMidiInstrument::SYNTH_PAD(SynthPad::Pad3Polysynth)
    } else if program_change == 91 {
        GeneralMidiInstrument::SYNTH_PAD(SynthPad::Pad4Choir)
    } else if program_change == 92 {
        GeneralMidiInstrument::SYNTH_PAD(SynthPad::Pad5Bowed)
    } else if program_change == 93 {
        GeneralMidiInstrument::SYNTH_PAD(SynthPad::Pad6Metallic)
    } else if program_change == 94 {
        GeneralMidiInstrument::SYNTH_PAD(SynthPad::Pad7Halo)
    } else if program_change == 95 {
        GeneralMidiInstrument::SYNTH_PAD(SynthPad::Pad8Sweep)
    } else if program_change == 96 {
        GeneralMidiInstrument::SYNTH_EFFECTS(SynthEffects::FX1Rain)
    } else if program_change == 97 {
        GeneralMidiInstrument::SYNTH_EFFECTS(SynthEffects::FX2Soundtrack)
    } else if program_change == 98 {
        GeneralMidiInstrument::SYNTH_EFFECTS(SynthEffects::FX3Crystal)
    } else if program_change == 99 {
        GeneralMidiInstrument::SYNTH_EFFECTS(SynthEffects::FX4Atmosphere)
    } else if program_change == 100 {
        GeneralMidiInstrument::SYNTH_EFFECTS(SynthEffects::FX5Brightness)
    } else if program_change == 101 {
        GeneralMidiInstrument::SYNTH_EFFECTS(SynthEffects::FX6Goblins)
    } else if program_change == 102 {
        GeneralMidiInstrument::SYNTH_EFFECTS(SynthEffects::FX7Echoes)
    } else if program_change == 103 {
        GeneralMidiInstrument::SYNTH_EFFECTS(SynthEffects::FX8SciFi)
    } else if program_change == 104 {
        GeneralMidiInstrument::ETHNIC(Ethnic::Sitar)
    } else if program_change == 105 {
        GeneralMidiInstrument::ETHNIC(Ethnic::Banjo)
    } else if program_change == 106 {
        GeneralMidiInstrument::ETHNIC(Ethnic::Shamisen)
    } else if program_change == 107 {
        GeneralMidiInstrument::ETHNIC(Ethnic::Koto)
    } else if program_change == 108 {
        GeneralMidiInstrument::ETHNIC(Ethnic::Kalimba)
    } else if program_change == 109 {
        GeneralMidiInstrument::ETHNIC(Ethnic::Bagpipe)
    } else if program_change == 110 {
        GeneralMidiInstrument::ETHNIC(Ethnic::Fiddle)
    } else if program_change == 111 {
        GeneralMidiInstrument::ETHNIC(Ethnic::Shanai)
    } else if program_change == 112 {
        GeneralMidiInstrument::PERCUSSIVE(Percussive::TinkleBell)
    } else if program_change == 113 {
        GeneralMidiInstrument::PERCUSSIVE(Percussive::Agogo)
    } else if program_change == 114 {
        GeneralMidiInstrument::PERCUSSIVE(Percussive::SteelDrums)
    } else if program_change == 115 {
        GeneralMidiInstrument::PERCUSSIVE(Percussive::Woodblock)
    } else if program_change == 116 {
        GeneralMidiInstrument::PERCUSSIVE(Percussive::TaikoDrum)
    } else if program_change == 117 {
        GeneralMidiInstrument::PERCUSSIVE(Percussive::MelodicTom)
    } else if program_change == 118 {
        GeneralMidiInstrument::PERCUSSIVE(Percussive::SynthDrum)
    } else if program_change == 119 {
        GeneralMidiInstrument::PERCUSSIVE(Percussive::ReverseCymbal)
    } else if program_change == 120 {
        GeneralMidiInstrument::SOUND_EFFECTS(SoundEffects::GuitarFretNoise)
    } else if program_change == 121 {
        GeneralMidiInstrument::SOUND_EFFECTS(SoundEffects::BreathNoise)
    } else if program_change == 122 {
        GeneralMidiInstrument::SOUND_EFFECTS(SoundEffects::Seashore)
    } else if program_change == 123 {
        GeneralMidiInstrument::SOUND_EFFECTS(SoundEffects::BirdTweet)
    } else if program_change == 124 {
        GeneralMidiInstrument::SOUND_EFFECTS(SoundEffects::TelephoneRing)
    } else if program_change == 125 {
        GeneralMidiInstrument::SOUND_EFFECTS(SoundEffects::Helicopter)
    } else if program_change == 126 {
        GeneralMidiInstrument::SOUND_EFFECTS(SoundEffects::Applause)
    } else if program_change == 127 {
        GeneralMidiInstrument::SOUND_EFFECTS(SoundEffects::Gunshot)
    } else {
        GeneralMidiInstrument::PIANO(
            Piano::BrightAcousticPiano
        ) // Default value if none of the conditions match
    };
    instrument
}

fn next_instrument_in_group(current_instrument: u8) -> u8 {
    // Assuming instruments are numbered from 0 to 127
    let total_instruments_per_group = 8;
    let inst_group = current_instrument / total_instruments_per_group;
    let inst_group_rem = (current_instrument % total_instruments_per_group) + 1 % total_instruments_per_group;

    (inst_group * total_instruments_per_group) + inst_group_rem
}
