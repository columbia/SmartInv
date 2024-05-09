1 pragma solidity ^0.4.16;
2 
3 contract MyToken {
4     /* This creates an array with all balances */
5     mapping (address => uint256) public balanceOf;
6     
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     
13     /* Initializes contract with initial supply tokens to the creator of the contract */
14     function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
15         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
16         name = tokenName;                                   // Set the name for display purposes
17         symbol = tokenSymbol;                               // Set the symbol for display purposes
18         decimals = decimalUnits;                            // Amount of decimals for display purposes
19     }
20     
21     /* Send coins */
22     function transfer(address _to, uint256 _value) public {
23         /* Check if sender has balance and for overflows */
24         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
25 
26         /* Add and subtract new balances */
27         balanceOf[msg.sender] -= _value;
28         balanceOf[_to] += _value;
29         
30         /* Notify anyone listening that this transfer took place */
31         Transfer(msg.sender, _to, _value);
32     }
33 }