use core::felt252;

#[starknet::contract]
mod Fibonacci {

    #[storage]
    struct Storage {
        // Although we are not storing anything in storage, 
        // the storage struct needs to be present in evevy starknet contract.
    }

    #[external(v0)]
    #[generate_trait]
    impl FunctionsImpl of FunctionsTrait {

        fn main(self: @ContractState) -> felt252 {
            let n = 10;
            let result = self.fib(1, 1, n);
            result
        }


        fn fib(self: @ContractState, a: felt252, b: felt252, n: felt252) -> felt252 {
            match n {
                0 => a,
                _ => self.fib(b, a + b, n - 1),
            }
        }

    }
}
