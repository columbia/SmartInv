1 pragma solidity ^0.4.11;
2 
3 	contract MarketMaker {
4 
5 	string public name;
6 	string public symbol;
7 	uint256 public decimals;
8 	
9 	uint256 public totalSupply;
10 
11 	mapping (address => uint256) public balanceOf;
12 	mapping (address => mapping(address=>uint256)) public allowance;
13 
14 	event Transfer(address from, address to, uint256 value);
15 	event Approval(address from, address to, uint256 value);
16 
17 	function MarketMaker(){
18 		
19 		decimals = 0;
20 		totalSupply = 1000000;
21 
22 		balanceOf[msg.sender] = totalSupply;
23 		name = "MarketMaker";
24 		symbol = "MMC2";
25 
26 	}
27 
28 
29 
30 
31 	function _transfer(address _from, address _to, uint256 _value) internal {
32 		require(_to != 0x0);
33 		require(balanceOf[_from] >= _value);
34 		require(balanceOf[_to] + _value >= balanceOf[_to]);
35 
36 		balanceOf[_to] += _value;
37 		balanceOf[_from] -= _value;
38 
39 		Transfer(_from, _to, _value);	
40 
41 	}
42 
43 	function transfer(address _to, uint256 _value) public {
44 		_transfer(msg.sender, _to, _value);
45 
46 	}
47 	
48 	function transferFrom(address _from, address _to, uint256 _value) public {
49 		require(_value <= allowance[_from] [_to]);
50 		allowance[_from] [_to] -= _value;
51 		_transfer(_from, _to, _value);
52 	}
53 	
54 	function approve(address _to, uint256 _value){
55 		allowance [msg.sender] [_to] = _value;
56 		Approval(msg.sender, _to, _value);
57 	}
58 }