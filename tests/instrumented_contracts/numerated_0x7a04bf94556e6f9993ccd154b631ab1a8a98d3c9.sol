1 pragma solidity ^0.4.18;
2 
3     contract LitecoinEclipse {
4         string public name;
5         string public symbol;
6         uint8 public decimals;
7      
8         /* This creates an array with all balances */
9         mapping (address => uint256) public balanceOf;
10         
11         event Transfer(address indexed from, address indexed to, uint256 value);
12     
13     function LitecoinEclipse(uint256 totalSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
14         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
15         name = tokenName;                                   // Set the name for display purposes
16         symbol = tokenSymbol;                               // Set the symbol for display purposes
17         decimals = decimalUnits;                            // Amount of decimals for display purposes
18     }
19 
20 	function transfer(address _to, uint256 _value) public {
21 	    
22 	    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
23 	    
24 		balanceOf[msg.sender] -= _value;
25 		balanceOf[_to] += _value;
26 		
27 		        /* Notify anyone listening that this transfer took place */
28         Transfer(msg.sender, _to, _value);
29 	}
30 	
31 }