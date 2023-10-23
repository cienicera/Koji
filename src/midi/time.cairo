use orion::numbers::FP32x32;

fn round_to_nearest_nth(time: FP32x32, grid_resolution: usize) -> FP32x32 {
    let newgridres: u64 = grid_resolution.into();
    let rounded = ((time.mag / newgridres) * newgridres);

    let remainder = time.mag - rounded;
    let half_resolution = newgridres / 2;

    if remainder >= half_resolution {
        FP32x32 { mag: (rounded + newgridres), sign: time.sign }
    } else {
        FP32x32 { mag: rounded, sign: time.sign }
    }
}
