use koji::midi::types::{Midi, Message, NoteOn, NoteOff, SetTempo, TimeSignature, ControlChange, PitchWheel, AfterTouch, PolyTouch, Modes};
use orion::numbers::FP32x32;
fn midi() -> Midi {
Midi {
events: array![
Message::NOTE_ON(NoteOn { channel: 0, note: 48, velocity: 100, time: FP32x32 { mag: 0, sign: false } }),
Message::NOTE_ON(NoteOn { channel: 0, note: 48, velocity: 100, time: FP32x32 { mag: 50, sign: false } }),
Message::NOTE_OFF(NoteOff { channel: 0, note: 49, velocity: 100, time: FP32x32 { mag: 100, sign: false } }),
Message::NOTE_OFF(NoteOff { channel: 0, note: 49, velocity: 100, time: FP32x32 { mag: 350, sign: false } })
].span()
   }
}
