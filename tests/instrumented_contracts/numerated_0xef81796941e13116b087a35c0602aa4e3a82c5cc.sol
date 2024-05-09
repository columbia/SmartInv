1 pragma solidity ^0.4.10;
2 
3 contract CyberToken
4 {
5 
6 	string public name; 
7 	string public symbol; 
8 	uint8 public decimals; 
9 	uint256 public totalSupply;
10 
11 
12 	mapping (address => uint256) public balanceOf;
13 
14 
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 	event Burn(address indexed from, uint256 value);
17 
18 
19 	function CyberToken() 
20 	{
21 		name = "CyberToken";
22 		symbol = "CYB";
23 		decimals = 12;
24 		totalSupply = 625000000000000000000;
25 		balanceOf[msg.sender] = totalSupply;
26 	}
27 
28 
29 	function transfer(address _to, uint256 _value) 
30 	{ 
31 		balanceOf[msg.sender] -= _value;
32 		balanceOf[_to] += _value;
33 		Transfer(msg.sender, _to, _value); 
34 	}
35 
36 
37 	function burn(address _from, uint256 _value) returns (bool success)
38 	{
39 		if (balanceOf[msg.sender] < _value) throw;
40 		balanceOf[_from] -= _value;
41 		totalSupply -= _value;
42 		Burn(_from, _value);
43 		return true;
44 	}
45 }