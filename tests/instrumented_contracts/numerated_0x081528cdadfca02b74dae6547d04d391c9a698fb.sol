1 pragma solidity ^0.4.16;
2 
3 contract test {
4     // Get balace of an account.
5     function balanceOf(address _owner) constant returns (uint256 balance) {
6         return 34500000000000000000;
7     }
8     // Transfer function always returns true.
9     function transfer(address _to, uint256 _amount) returns (bool success) {
10         return true;
11     }
12 }