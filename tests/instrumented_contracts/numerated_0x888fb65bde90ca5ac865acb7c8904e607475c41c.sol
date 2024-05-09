1 pragma solidity ^0.4.20;
2 
3 contract MyToken {
4     /* This creates an array with all balances */
5     mapping (address => uint256) public balanceOf;
6 
7     /* Initializes contract with initial supply tokens to the creator of the contract */
8     function MyToken(
9         uint256 initialSupply
10         ) public {
11         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
12     }
13 
14     /* Send coins */
15     function transfer(address _to, uint256 _value) public {
16         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
17         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
18         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
19         balanceOf[_to] += _value;                           // Add the same to the recipient
20     }
21 }