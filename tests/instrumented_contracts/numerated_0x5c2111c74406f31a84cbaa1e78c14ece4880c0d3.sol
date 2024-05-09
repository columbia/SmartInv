1 pragma solidity ^0.4.20;
2 
3 contract FUTokenContract {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8 
9     /* This creates an array with all balances */
10     mapping (address => uint256) public balanceOf;
11 
12         /* Initializes contract with initial supply tokens to the creator of the contract */
13     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
14         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
15         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
16         name = tokenName;                                   // Set the name for display purposes
17         symbol = tokenSymbol;                               // Set the symbol for display purposes
18     }
19 
20     /* Send coins */
21     function transfer(address _to, uint256 _value) public {
22         require(_to != 0x0);                                // Prevent transfer to 0x0 address.
23         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
24         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
25         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
26         balanceOf[_to] += _value;                           // Add the same to the recipient
27     }
28 }