#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use core::traits::Into;
    use core::traits::TryInto;
    use orion::operators::tensor::{Tensor, U32Tensor,};
    use orion::numbers::{i32, FP32x32};
    use core::option::OptionTrait;

    // TODO: cleanup unused libraries
    // TODO: test out-of-bounds cases like 0, negative and out of u8 range

    #[test]
    #[available_gas(100000000000)]
    fn generate_euclidean_test(){
        let pattern1 = array![1, 0, 0, 0, 1, 0, 0, 0];
        let pattern2 = array![1, 0, 0, 1, 0, 1, 0];
        assert!(pattern1 == euclidean(8_u8, 4_u8), "pattern result does not match");
        assert!(pattern2 == euclidean(7_u8, 3_u8), "pattern result does not match");
    }

}