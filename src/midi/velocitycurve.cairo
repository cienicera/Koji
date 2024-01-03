use orion::operators::tensor::{Tensor, U32Tensor,};
use orion::numbers::{i32, FP32x32};
use core::option::OptionTrait;
use koji::midi::types::{
    Midi, Message, Modes, ArpPattern, VelocityCurve, NoteOn, NoteOff, SetTempo, TimeSignature,
    ControlChange, PitchWheel, AfterTouch, PolyTouch, Direction, PitchClass
};

fn linear_interpolation(
    x1: FP32x32, y1: FP32x32, x2: FP32x32, y2: FP32x32, xindex: FP32x32
) -> Option<FP32x32> {
    if (x1 >= xindex) {
        Option::None
    } else if (x1 == x2) {
        Option::None
    } else {
        let mut interpolatedy = y1 + ((y2 - y1) / (x2 - x1)) * (xindex - x1);
        Option::Some(interpolatedy)
    }
}

fn vc_linear_interpolation(
    x1: FP32x32, y1: u8, x2: FP32x32, y2: u8, xindex: FP32x32
) -> Option<u8> {
    let newx1: u8 = x1.mag.try_into().unwrap();
    let newx2: u8 = x2.mag.try_into().unwrap();
    let newxindex: u8 = xindex.mag.try_into().unwrap();
    if (newx1 >= newxindex) {
        Option::None
    } else if (newx1 == newx2) {
        Option::None
    } else {
        let mut interpolatedy = y1 + ((y2 - y1) / (newx2 - newx1)) * (newxindex - newx1);
        Option::Some(interpolatedy)
    }
}

