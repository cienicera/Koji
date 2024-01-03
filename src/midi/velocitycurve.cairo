use orion::operators::tensor::{Tensor, U32Tensor,};
use orion::numbers::{i32, FP32x32};
use core::option::OptionTrait;
use koji::midi::types::{
    Midi, Message, Modes, ArpPattern, VelocityCurve, NoteOn, NoteOff, SetTempo, TimeSignature,
    ControlChange, PitchWheel, AfterTouch, PolyTouch, Direction, PitchClass
};

trait VelocityCurveTrait {
    /// =========== VelocityCurve MANIPULATION ===========
    /// Instantiate a VelocityCurve.
    fn new() -> VelocityCurve;
    /// Append a breakpoint time/value pair in a VelocityCurve object.
    fn set_breakpoint_pair(self: @VelocityCurve, time: FP32x32, value: u8) -> VelocityCurve;
    /// =========== GLOBAL MANIPULATION ===========
    /// Stretch or shrink time values by a specified factor.
    fn scale_times(self: @VelocityCurve, factor: FP32x32) -> VelocityCurve;
    /// Add or subtract to time values by a specified offset.
    fn offset_times(self: @VelocityCurve, factor: FP32x32) -> VelocityCurve;
    /// Stretch or shrink levels by a specified factor.
    fn scale_levels(self: @VelocityCurve, factor: u8) -> VelocityCurve;
    /// Add or subtract to levels by a specified offset.
    fn offset_levels(self: @VelocityCurve, factor: u8) -> VelocityCurve;
    /// =========== ANALYSIS ===========
    /// Get the last time value for the breakpoint
    fn lasttime(self: @VelocityCurve) -> FP32x32;
    /// Get the maximum levels for the breakpoint
    fn maxlevel(self: @VelocityCurve) -> u8;
    /// Get the linearly interpolated at a specified time index
    fn getlevelattime(self: @VelocityCurve, timeindex: FP32x32) -> Option<u8>;
}

impl VelocityCurveImpl of VelocityCurveTrait {
    fn new() -> VelocityCurve {
        VelocityCurve { times: array![].span(), levels: array![].span() }
    }
    fn set_breakpoint_pair(self: @VelocityCurve, time: FP32x32, value: u8) -> VelocityCurve {
        let mut vct = self.clone().times;
        let mut vcl = self.clone().levels;

        let mut vctimes = ArrayTrait::<FP32x32>::new();
        let mut vclevels = ArrayTrait::<u8>::new();

        loop {
            match vct.pop_front() {
                Option::Some(currtime) => { vctimes.append(*currtime); },
                Option::None(_) => {
                    vctimes.append(time);
                    break;
                }
            };
        };

        loop {
            match vcl.pop_front() {
                Option::Some(currlevels) => { vclevels.append(*currlevels); },
                Option::None(_) => {
                    vclevels.append(value);
                    break;
                }
            };
        };

        VelocityCurve { times: vctimes.span(), levels: vclevels.span() }
    }
    fn offset_times(self: @VelocityCurve, factor: FP32x32) -> VelocityCurve {
        let mut vct = self.clone().times;
        let mut vcl = self.clone().levels;

        let mut vctimes = ArrayTrait::<FP32x32>::new();
        let mut vclevels = ArrayTrait::<u8>::new();

        loop {
            match vct.pop_front() {
                Option::Some(currtime) => { vctimes.append(*currtime + factor); },
                Option::None(_) => { break; }
            };
        };

        loop {
            match vcl.pop_front() {
                Option::Some(currlevels) => { vclevels.append(*currlevels); },
                Option::None(_) => { break; }
            };
        };

        VelocityCurve { times: vctimes.span(), levels: vclevels.span() }
    }
    fn scale_times(self: @VelocityCurve, factor: FP32x32) -> VelocityCurve {
        let mut vct = self.clone().times;
        let mut vcl = self.clone().levels;

        let mut vctimes = ArrayTrait::<FP32x32>::new();
        let mut vclevels = ArrayTrait::<u8>::new();

        loop {
            match vct.pop_front() {
                Option::Some(currtime) => { vctimes.append(*currtime * factor); },
                Option::None(_) => { break; }
            };
        };

        loop {
            match vcl.pop_front() {
                Option::Some(currlevels) => { vclevels.append(*currlevels); },
                Option::None(_) => { break; }
            };
        };

        VelocityCurve { times: vctimes.span(), levels: vclevels.span() }
    }
    fn scale_levels(self: @VelocityCurve, factor: u8) -> VelocityCurve {
        let mut vct = self.clone().times;
        let mut vcl = self.clone().levels;

        let mut vctimes = ArrayTrait::<FP32x32>::new();
        let mut vclevels = ArrayTrait::<u8>::new();

        loop {
            match vct.pop_front() {
                Option::Some(currtime) => { vctimes.append(*currtime); },
                Option::None(_) => { break; }
            };
        };

        loop {
            match vcl.pop_front() {
                Option::Some(currlevels) => { vclevels.append(*currlevels * factor); },
                Option::None(_) => { break; }
            };
        };

        VelocityCurve { times: vctimes.span(), levels: vclevels.span() }
    }
    fn offset_levels(self: @VelocityCurve, factor: u8) -> VelocityCurve {
        let mut vct = self.clone().times;
        let mut vcl = self.clone().levels;

        let mut vctimes = ArrayTrait::<FP32x32>::new();
        let mut vclevels = ArrayTrait::<u8>::new();

        loop {
            match vct.pop_front() {
                Option::Some(currtime) => { vctimes.append(*currtime); },
                Option::None(_) => { break; }
            };
        };

        loop {
            match vcl.pop_front() {
                Option::Some(currlevels) => { vclevels.append(*currlevels + factor); },
                Option::None(_) => { break; }
            };
        };

        VelocityCurve { times: vctimes.span(), levels: vclevels.span() }
    }
    fn lasttime(self: @VelocityCurve) -> FP32x32 {
        let mut lasttime = FP32x32 { mag: 0, sign: false };
        let mut vct = self.clone().times;
        let mut vcl = self.clone().levels;

        let mut vctimes = ArrayTrait::<u8>::new();
        let mut vcvalues = ArrayTrait::<u8>::new();

        loop {
            match vct.pop_front() {
                Option::Some(currtime) => { let mut lasttime = *currtime; },
                Option::None(_) => { break; }
            };
        };
        lasttime
    }
    fn maxlevel(self: @VelocityCurve) -> u8 {
        let mut maxlevel = 0;
        let mut vct = self.clone().times;
        let mut vcl = self.clone().levels;

        let mut vctimes = ArrayTrait::<u8>::new();
        let mut vcvalues = ArrayTrait::<u8>::new();

        loop {
            match vcl.pop_front() {
                Option::Some(currlevels) => {
                    let outnote = if (*currlevels > maxlevel) {
                        maxlevel = *currlevels;
                    };
                },
                Option::None(_) => { break; }
            };
        };
        maxlevel
    }
    fn getlevelattime(self: @VelocityCurve, timeindex: FP32x32) -> Option<u8> {
        let mut vct = self.clone().times;
        let mut vcl = self.clone().levels;
        let mut interpolatedlevel = Option::None;
        let mut x1 = FP32x32 { mag: 0, sign: false };
        let mut x2 = FP32x32 { mag: 0, sign: false };
        let mut y1 = Option::None;
        let mut y2 = Option::None;
        let mut y1val = 0;
        let mut y2val = 0;
        loop {
            if (x2 < timeindex) {
                match vct.pop_front() {
                    Option::Some(currtime) => {
                        x1 = x2;
                        x2 = *currtime;
                    },
                    Option::None(_) => {}
                };
                match vcl.pop_front() {
                    Option::Some(currlevel) => {
                        y1 = Option::Some(y2);
                        y2 = Option::Some(*currlevel);
                    },
                    Option::None(_) => {}
                };
            } else {
                if (y1 == Option::None) {
                    break;
                } else if (y2 == Option::None) {
                    break;
                } else {
                    match y1 {
                        Option::Some(val) => { let y1val = val; },
                        Option::None(_) => {}
                    }
                    match y2 {
                        Option::Some(val) => { let y2val = val; },
                        Option::None(_) => {}
                    }

                    interpolatedlevel = vc_linear_interpolation(x1, y1val, x2, y2val, timeindex);
                    break;
                };
            }
        };
        interpolatedlevel
    }
}

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

