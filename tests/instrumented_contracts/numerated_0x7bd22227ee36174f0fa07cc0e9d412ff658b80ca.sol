1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract HoltCoin {
6 
7 	string public name;
8 	string public symbol;
9 	uint256 public totalSupply;
10 	uint8 public decimals = 18;
11 
12 	mapping (address => uint256) public balanceOf;
13 	mapping (address => mapping (address => uint256)) public allowance;
14 
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 	event Burn(address indexed from, uint256 value);
17 
18 	constructor() public {
19 		name = "HoltCoin";
20 		symbol = "HOLT";
21 		totalSupply = 100000000 * 10 ** uint256(decimals);
22 		balanceOf[msg.sender] = totalSupply;
23 	}
24 
25 	function _transfer(address _from, address _to, uint _value) internal {
26 		require(_to != 0x0);
27 		require(balanceOf[_from] >= _value);
28 		require(balanceOf[_to] + _value >= balanceOf[_to]);
29 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
30 		balanceOf[_from] -= _value;
31 		balanceOf[_to] += _value;
32 		emit Transfer(_from, _to, _value);
33 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
34 	}
35 
36 	function transfer(address _to, uint256 _value) public {
37 		_transfer(msg.sender, _to, _value);
38 	}
39 
40 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
41 		require(_value <= allowance[_from][msg.sender]);
42 		allowance[_from][msg.sender] -= _value;
43 		_transfer(_from, _to, _value);
44 		return true;
45 	}
46 
47 	function approve(address _spender, uint256 _value) public returns (bool success) {
48 		allowance[msg.sender][_spender] = _value;
49 		return true;
50 	}
51 
52 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
53 		tokenRecipient spender = tokenRecipient(_spender);
54 		if (approve(_spender, _value)) {
55 			spender.receiveApproval(msg.sender, _value, this, _extraData);
56 			return true;
57 		}
58 	}
59 
60 	function burn(uint256 _value) public returns (bool success) {
61 		require(balanceOf[msg.sender] >= _value);
62 		balanceOf[msg.sender] -= _value;
63 		totalSupply -= _value;
64 		emit Burn(msg.sender, _value);
65 		return true;
66 	}
67 
68 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
69 		require(balanceOf[_from] >= _value);
70 		require(_value <= allowance[_from][msg.sender]);
71 		balanceOf[_from] -= _value;
72 		allowance[_from][msg.sender] -= _value;
73 		totalSupply -= _value;
74 		emit Burn(_from, _value);
75 		return true;
76 	}
77 
78 }