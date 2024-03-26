#[cfg(test)]
mod tests {
    use core::array::SpanTrait;
    use core::traits::Into;
    use core::traits::IndexView;
    use core::array::ArrayTrait;
    use core::fmt::Display;
    use core::fmt::Formatter;
    use koji::midi::euclidean::{euclidean, modify_array};
    // use super::euclidean;
    // use super::modify_array;

    // TODO: test out-of-bounds cases like 0, negative and out of u8 range

    #[test]
    #[available_gas(100000000000)]
    fn generate_euclidean_test() {
        let pattern1 = array![1, 0, 0, 0, 1, 0, 0, 0];
        let _pattern2 = array![1, 0, 0, 1, 0, 1, 0];

        // Test modify_array function
        let pattern3 = modify_array(pattern1, 1, 1);
        assert!(pattern3 == array![1, 1, 0, 0, 1, 0, 0, 0], "pattern result does not match");

        // Test euclidean function
        let pattern4 = euclidean(8, 2);
        assert!(pattern4 == array![1, 0, 0, 0, 1, 0, 0, 0], "pattern result does not match");

        let pattern4 = euclidean(7, 4);
        assert!(pattern4 == array![1, 0, 1, 0, 1, 0, 1], "pattern result does not match");

        let pattern5 = euclidean(7, 1);
        assert!(pattern5 == array![1, 0, 0, 0, 0, 0, 0], "pattern result does not match");

        let pattern6 = euclidean(3, 1);
        assert!(pattern6 == array![1, 0, 0], "pattern result does not match");

        // Test Boundary Cases
        let pattern7 = euclidean(3, 4);
        assert!(pattern7 == array![1, 1, 1], "pattern result does not match");

        let pattern7 = euclidean(3, 0);
        assert!(pattern7 == array![0, 0, 0], "pattern result does not match");

        let pattern8 = euclidean(0, 0);
        assert!(pattern8 == array![0], "pattern result does not match");

        let pattern9 = euclidean(1, 1);
        assert!(pattern9 == array![1], "pattern result does not match");

        let pattern10 = euclidean(0, 1);
        assert!(pattern10 == array![1], "pattern result does not match");
    }
}
