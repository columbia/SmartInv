1 pragma solidity 0.4.8;
2 
3 contract madrachip {
4     /* some init vars */
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     
9     /* This creates an array with all balances */
10     mapping (address => uint256) public balanceOf;
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     /* Initializes contract with initial supply tokens to the creator of the contract */
15 function madrachip (uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {
16     balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
17     name = tokenName;                                   // Set the name for display purposes
18     symbol = tokenSymbol;                               // Set the symbol for display purposes
19     decimals = decimalUnits;                            // Amount of decimals for display purposes
20 }
21 
22     /* Send coins */
23     function transfer(address _to, uint256 _value) {
24         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
25         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
26         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
27         balanceOf[_to] += _value;                            // Add the same to the recipient
28     }
29 }