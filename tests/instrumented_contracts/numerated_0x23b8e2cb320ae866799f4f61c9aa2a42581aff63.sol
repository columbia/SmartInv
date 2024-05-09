1 pragma solidity ^0.4.18;
2 
3 contract JCFv1 {
4     event Transfer(address indexed from, address indexed to, uint256 value);
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     /* This creates an array with all balances */
9     mapping (address => uint256) public balanceOf;
10     
11     /* Initializes contract with initial supply tokens to the creator of the contract */
12     function JCFv1(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
13         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
14         name = tokenName;                                   // Set the name for display purposes
15         symbol = tokenSymbol;                               // Set the symbol for display purposes
16         decimals = decimalUnits;                            // Amount of decimals for display purposes
17     }
18     
19     /* Send coins */
20     function transfer(address _to, uint256 _value) public {
21         /* Check if sender has balance and for overflows */
22         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
23 
24         /* Add and subtract new balances */
25         balanceOf[msg.sender] -= _value;
26         balanceOf[_to] += _value;
27         
28         /* Notify anyone listening that this transfer took place */
29         Transfer(msg.sender, _to, _value);
30     }
31 }