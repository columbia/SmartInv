1 pragma solidity ^0.4.2;
2 
3 contract Xaibes {
4 
5 	string public name = 'Xaibes';
6 	string public symbol = 'Xaibes';
7 	string public standard = 'Xaibes Coin v1.0';
8 	uint256 public decimals = 5;
9 	uint256 public totalSupply;
10 
11 	event Transfer(
12 		address indexed _from,
13 		address indexed _to,
14 		uint256 _value
15 	);
16 
17 	event Approval(
18 		address indexed _owner,
19 		address indexed _spender,
20 		uint256 _value
21 	);
22 
23 	mapping(address => uint256) public balanceOf;
24 	mapping(address => mapping(address => uint256)) public allowance;
25 
26 	constructor(uint256 _initialSupply) public {
27 		balanceOf[msg.sender] = _initialSupply;
28 		totalSupply = _initialSupply;		
29 	}
30 
31 	function transfer(address _to, uint256 _value) public returns(bool success) {
32 		require(balanceOf[msg.sender] >= _value);
33 		balanceOf[msg.sender] -= _value;
34 		balanceOf[_to] += _value;
35 
36 		Transfer(msg.sender, _to, _value);
37 		return true;
38 	}
39 
40 	function approve(address _spender, uint256 _value) public returns(bool success){
41 		allowance[msg.sender][_spender] = _value;
42 		Approval(msg.sender, _spender, _value);
43 		return true;	
44 	}
45 
46 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
47 		require(_value <= balanceOf[_from]);
48 		require(_value <= allowance[_from][msg.sender]);
49 		
50 		balanceOf[_from] -= _value;
51 		balanceOf[_to] += _value;
52 		
53 		allowance[_from][msg.sender] -= _value;
54 
55 		Transfer(_from, _to, _value);
56 		return true;
57 	}
58 }