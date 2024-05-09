1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {  owner = msg.sender;  }
7     modifier onlyOwner {  require (msg.sender == owner);    _;   }
8     function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }
9 }
10   
11 contract CNKTToken is owned {
12     string public name; 
13     string public symbol; 
14     uint8 public decimals = 18;
15     uint256 public totalSupply; 
16   
17     mapping (address => uint256) public balanceOf;
18 	 
19     event Transfer(address indexed from, address indexed to, uint256 value); 
20     
21     function CNKTToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
22 		owner = msg.sender;
23         totalSupply = initialSupply * 10 ** uint256(decimals); 
24         balanceOf[owner] = totalSupply; 
25         name = tokenName;
26         symbol = tokenSymbol;
27     }
28  
29     function _transfer(address _from, address _to, uint256 _value) internal {
30         require (_to != 0x0); 
31         require (balanceOf[_from] >= _value); 
32         require (balanceOf[_to] + _value > balanceOf[_to]);
33 
34 		uint256 previousBalances = balanceOf[_from] +balanceOf[_to]; 
35         
36         balanceOf[_from] -= _value; 
37         balanceOf[_to] +=  _value; 
38 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
39 		emit Transfer(_from, _to, _value); 
40     }
41 	
42     function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }
43 }