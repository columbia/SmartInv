1 pragma solidity ^0.4.16;
2 
3 contract FUTokenContract {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     /* This creates an array with all balances */
10     mapping (address => uint256) public balanceOf;
11 
12     /* Initializes contract with initial supply tokens to the creator of the contract */
13     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
14         totalSupply = initialSupply;
15         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
16         name = tokenName;                                   // Set the name for display purposes
17         symbol = tokenSymbol;                               // Set the symbol for display purposes
18         decimals = decimalUnits;                            // Amount of decimals for display purposes
19     }
20 
21     /* Send coins */
22     function transfer(address _to, uint256 _value) public {
23         require(_to != 0x0);                                // Prevent transfer to 0x0 address.
24         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
25         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
26         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
27         balanceOf[_to] += _value;                           // Add the same to the recipient
28     }
29 }