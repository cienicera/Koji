use core::array::SpanTrait;
use core::traits::Into;
use core::traits::IndexView;
use core::array::ArrayTrait;
use core::fmt::Display;
use core::fmt::Formatter;

/// ======================================================
/// ============= Euclidean Rhythm Algorithm =============
/// ======================================================
/// ============= Implemented by aguzmant103 =============
//
// Returns a pattern array corresponding to the Euclidean Rhythm Algorithm 
// AKA: Bjorklund Algorithm: https://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf
//
// Problem: For a given number n of time intervals, and another given number k < n of pulses, 
// distribute the pulses as evenly as possible among these intervals.
// Bjorklund represents this problem as a binary sequence of k one’s and n − k zero’s, 
// where each integer represents a time interval, and one’s represent the pulses. 
// The problem then reduces to the following: Construct a binary sequence of n bits with k one’s, 
// such that the k one’s are distributed as evenly as possible among the zero’s.
//
// We want an algorithm where instead of throwing out-of-bounds errors, we return something 
// compositionally useful, thus: Cases with 0 beats will have k number of pulses. 
// If n + k = 0, return [0], if k != 0 then n = k etc

fn euclidean(n: u32, k: u32) -> Array<u32> {
    let mut pattern: Array<u32> = ArrayTrait::new();
    let mut i: u32 = 0;

    let mut k2 = k;
    let mut n2 = n;

    // Check if there are more pulses than available intervals - if yes, reduce k to n
    // check if either n = 0  && k == 0 or k > n 

    if n2 == 0 {
        if k2 == 0 {
            pattern.append(0);
            return pattern;
        } else {
            n2 = k2;
        }
    }
    if k2 > n2 {
        k2 = n2;
    }

    if k2 == 0 {
        loop {
            if i == n2 {
                break ();
            }
            pattern.append(0);
            i = i + 1;
        };
        println!("PATTERN: {:?}", pattern);
    } else {
        loop {
            if i == n2 {
                break ();
            }
            pattern.append(0);
            i = i + 1;
        };

        let mut counts: Array<u32> = ArrayTrait::new();
        let mut i: u32 = 0;
        loop {
            if i == k2 {
                break ();
            }
            counts.append(n2 / k2);
            i = i + 1;
        };

        let remainder: u32 = n2 % k2;

        let mut index: u32 = 0;

        //TODO: look for another more memory-efficient way to keep snaps of the array
        let counts2 = counts.span();

        i = 0;
        loop {
            if i == remainder {
                break ();
            }
            pattern = modify_array(pattern, index, 1);
            index += *counts[i] + 1;
            i = i + 1;
        };

        i = remainder;
        loop {
            if i == k2 {
                break ();
            }
            pattern = modify_array(pattern, index, 1);
            index += *counts2[i];
            i = i + 1;
        };

        println!("PATTERN: {:?}", pattern);
    };
    return pattern;
}


fn modify_array(array: Array<u32>, index: u32, value: u32) -> Array<u32> {
    let mut i: u32 = 0;
    let mut new_array: Array<u32> = ArrayTrait::new();
    loop {
        if i == array.len() {
            break ();
        }
        if i == index {
            new_array.append(value);
        } else {
            new_array.append(*array.at(i));
        }
        i = i + 1;
    };
    return new_array;
}
