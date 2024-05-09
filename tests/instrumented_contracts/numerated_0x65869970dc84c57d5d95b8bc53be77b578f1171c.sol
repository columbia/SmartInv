1 pragma solidity ^0.4.16;
2 
3 contract TestCoin {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7 
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 
10     /* This creates an array with all balances */
11     mapping (address => uint256) public balanceOf;
12 
13     /* Initializes contract with initial supply tokens to the creator of the contract */
14     function TestCoin() {
15         balanceOf[msg.sender] = 4000000;  	            // Give the creator all initial tokens
16         name = "TestCoin";                                  // Set the name for display purposes
17         symbol = "TEST";  	                            // Set the symbol for display purposes
18         decimals = 2;                   		    // Amount of decimals for display purposes
19     }
20 
21     /* Send coins */
22     function transfer(address _to, uint256 _value) {
23         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
24         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
25         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
26         balanceOf[_to] += _value;                           // Add the same to the recipient
27 
28         /* Notify anyone listening that this transfer took place */
29         Transfer(msg.sender, _to, _value);
30     }
31 }