//function for converting BPM to time per beat in ms

fn bpm_to_time_per_beat(bpm: u32) -> u32 {
    assert(bpm != 0, 'number is zero');
    60 / bpm
}
