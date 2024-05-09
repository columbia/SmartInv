1 pragma solidity ^0.4.17;  
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
21     function transfer(address _to, uint256 _value) public {  
22         /* Check if sender has balance and for overflows */  
23         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);  
24   
25         /* Add and subtract new balances */  
26         balanceOf[msg.sender] -= _value;  
27         balanceOf[_to] += _value;  
28           
29         /* Notify anyone listening that this transfer took place */  
30         Transfer(msg.sender, _to, _value);          
31     }  
32 }