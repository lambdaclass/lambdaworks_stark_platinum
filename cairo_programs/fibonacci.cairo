use core::felt252;
use debug::PrintTrait;

fn main(){
    let n = 10;
    let result = fib(n);
    result.print();
}

fn fib(n: felt252) -> felt252 {
    if n == 0 {
        1
    } else if n == 1 {
        1
    } else {
        fib(n - 1) + fib(n - 2)
    }
}
