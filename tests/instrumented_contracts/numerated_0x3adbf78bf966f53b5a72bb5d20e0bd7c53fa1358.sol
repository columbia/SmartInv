1 pragma solidity ^0.4.18;
2 
3     contract EthereumMoon {
4         string public name;
5         string public symbol;
6         uint8 public decimals;
7         /* This creates an array with all balances */
8         mapping (address => uint256) public balanceOf;
9         
10         event Transfer(address indexed from, address indexed to, uint256 value);
11     
12     function EthereumMoon(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
13         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
14         name = tokenName;                                   // Set the name for display purposes
15         symbol = tokenSymbol;                               // Set the symbol for display purposes
16         decimals = decimalUnits;                            // Amount of decimals for display purposes
17     }
18 
19 	function transfer(address _to, uint256 _value) public {
20 	    
21 	    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
22 	    
23 		balanceOf[msg.sender] -= _value;
24 		balanceOf[_to] += _value;
25 		
26 		        /* Notify anyone listening that this transfer took place */
27         Transfer(msg.sender, _to, _value);
28 	}
29 }