use core::traits::IndexView;
use core::array::ArrayTrait;
use core::fmt::Display;
use core::fmt::Formatter;

// TODO: recommended type for n and k? maximum size? used elsewhere?

fn euclidean(n: u32, k: u32) -> Array<u32>{
    let mut pattern : Array<u32> = ArrayTrait::new();
    let mut i: u32 = 0;
    loop {
        if i == n {
            break ();
        }
        pattern.append(0);
        i = i + 1;
    };
    println!("PATTERN: {:?}", pattern);

    
    let mut counts : Array<u32> = ArrayTrait::new();
    let mut i: u32 = 0;
    loop {
        if i == k {
            break ();
        }
        counts.append(n/k);
        i = i + 1;
    };


    let remainder : u32 = n % k;    

    let mut index : u32 = 0;
    
    //TODO: look for another more elegant way than this
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
        //TODO: improve modifying array pattern
        pattern = modify_array(pattern, index, 1);
        //TODO: look for another more elegant way than this
        index += *counts2[i];
        i = i + 1;
    };

    let mut x : Array<u32> = ArrayTrait::new();
    x.append(0);

    return x;
}

fn main() {
    let n = 7;
    let k = 3;
    euclidean(n, k);
}

fn modify_array(array: Array<u32>, index: u32, value: u32) -> Array<u32> {
    let mut i: u32 = 0;
    let mut new_array : Array<u32> = ArrayTrait::new();
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
        // println!("NEW ARRAY: {:?}", new_array);
    };
    return new_array;
}