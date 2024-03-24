use core::traits::IndexView;
use core::array::ArrayTrait;
use core::fmt::Display;
use core::fmt::Formatter;

/// ======================================================
/// ============= Euclidean Rythm Algorithm ==============
/// ======================================================

// Returns a pattern array corresponding to the Euclidean rhythm Algorithm
// based on fixed size n and k ccorrespondind to number of beats and number of silences

// TODO: restrict cases with 0 beats or 0 silences

fn euclidean(n: i8, k: i8) -> Array<i8>{
    let mut pattern : Array<i8> = ArrayTrait::new();
    let mut i: i8 = 0;
    loop {
        if i == n {
            break ();
        }
        pattern.append(0);
        i = i + 1;
    };
    println!("PATTERN: {:?}", pattern);

    
    let mut counts : Array<i8> = ArrayTrait::new();
    let mut i: i8 = 0;
    loop {
        if i == k {
            break ();
        }
        counts.append(n/k);
        i = i + 1;
    };


    let remainder : i8 = n % k;    

    let mut index : i8 = 0;
    
    //TODO: look for another more memory-efficient way to keep snaps of the array
    let counts2 = counts.span();

    

    i = 0;
    loop {
        if i == remainder {
            break ();
        }
        pattern = modify_array(pattern, index, 1);
        index += *counts[i] + 1 ;
        i = i + 1;
    };


    i=remainder;
    loop {
        if i == k {
            break ();
        }
        pattern = modify_array(pattern, index, 1);
        index += *counts2[i];
        i = i + 1;
    };

    let mut x : Array<i8> = ArrayTrait::new();
    x.append(0);

    return x;
}



// Helper function that modifies an array. Can be optimized and/or changed in the future

fn modify_array(array: Array<i8>, index: i8, value: i8) -> Array<i8> {
    let mut i: i8 = 0;
    let mut new_array : Array<i8> = ArrayTrait::new();
    loop {
        if i == array.len(){
            break ();
        }
        if i == index {
            new_array.append(value);
        }
        else {
            new_array.append(*array[i]);
        }
        i = i + 1;
    };
    return new_array;
}