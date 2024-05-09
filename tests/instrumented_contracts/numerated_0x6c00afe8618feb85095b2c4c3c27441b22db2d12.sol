1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {  owner = msg.sender;  }
7     modifier onlyOwner {  require (msg.sender == owner);    _;   }
8     function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }
9 }
10 contract CNKTToken is owned {
11     string public name; 
12     string public symbol; 
13     uint8 public decimals = 18;
14     uint256 public totalSupply; 
15   
16     mapping (address => uint256) public balanceOf;
17 	 
18     event Transfer(address indexed from, address indexed to, uint256 value); 
19     
20     function CNKTToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
21 		owner = msg.sender;
22         totalSupply = initialSupply * 10 ** uint256(decimals); 
23         balanceOf[owner] = totalSupply; 
24         name = tokenName;
25         symbol = tokenSymbol;
26     }
27  
28     function _transfer(address _from, address _to, uint256 _value) internal {
29         require (_to != 0x0); 
30         require (balanceOf[_from] >= _value); 
31         require (balanceOf[_to] + _value > balanceOf[_to]);
32 
33 		uint256 previousBalances = balanceOf[_from] +balanceOf[_to]; 
34         
35         balanceOf[_from] -= _value; 
36         balanceOf[_to] +=  _value; 
37 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
38 		emit Transfer(_from, _to, _value); 
39     }
40 	
41     function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }
42 }