1 pragma solidity ^0.4.0;
2 contract MyToken {
3     /* This creates an array with all balances */
4     mapping (address => uint256) public balanceOf;
5 
6     /* Initializes contract with initial supply tokens to the creator of the contract */
7     function MyToken(
8         
9         ) {
10         balanceOf[msg.sender] = 210000;              // Give the creator all initial tokens
11     }
12 
13     /* Send coins */
14     function transfer(address _to, uint256 _value) {
15         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
16         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
17         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
18         balanceOf[_to] += _value;                            // Add the same to the recipient
19     }
20 }