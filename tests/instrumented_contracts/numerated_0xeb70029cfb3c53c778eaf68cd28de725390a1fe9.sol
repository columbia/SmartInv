1 pragma solidity 0.8.9;
2 
3 contract Naive
4 {
5   event Batch();
6 
7   // This function is called for all messages sent to
8   // this contract (there is no other function).
9   // Sending Ether to this contract will cause an exception,
10   // because the fallback function does not have the `payable`
11   // modifier.
12   //
13   fallback() external
14   {
15     emit Batch();
16   }
17 }