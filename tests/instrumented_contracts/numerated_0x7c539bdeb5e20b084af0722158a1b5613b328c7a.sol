1 pragma solidity ^0.4.18;
2 
3 contract ZperToken {
4 
5 	address public owner;
6 	uint256 public totalSupply;
7 	uint256 public cap;
8 	string public constant name = "ZperToken";
9 	string public constant symbol = "ZPR";
10 	uint8 public constant decimals = 18;
11 
12 	mapping (address => uint256) public balances;
13 	mapping (address => mapping (address => uint256)) public allowed;
14 
15 	event Mint(address indexed to, uint256 amount);
16 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 	event Burn(address indexed burner, uint256 value);
20 
21 	function ZperToken (address _owner, uint256 _totalSupply, uint256 _cap) public {
22 		require(_owner != address(0));
23 		require(_cap > _totalSupply && _totalSupply > 0);
24 		
25 		totalSupply = _totalSupply * (10 ** 18);
26 		cap = _cap * (10 ** 18);
27 		owner = _owner;
28 
29 		balances[owner] = totalSupply;
30 	}
31 
32 	modifier onlyOwner() {
33 		require(msg.sender == owner);
34 		_;
35 	}
36 
37 	function transferOwnership(address newOwner) onlyOwner public {
38 		require(newOwner != address(0));
39 		owner = newOwner;
40 		emit OwnershipTransferred(owner, newOwner);
41 	}
42 
43 	function transfer(address _to, uint256 _value) public returns (bool success) {
44 		require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
45 		balances[msg.sender] -= _value;
46 		balances[_to] += _value;
47 		emit Transfer(msg.sender, _to, _value);
48 		return true;
49 	}
50 
51 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value
53 			   	&& balances[_to] + _value > balances[_to]);
54 		balances[_to] += _value;
55 		balances[_from] -= _value;
56 		allowed[_from][msg.sender] -= _value;
57 		emit Transfer(_from, _to, _value);
58 		return true;
59 	}
60 
61 	function balanceOf(address _owner) public constant returns (uint256 balance) {
62 		return balances[_owner];
63 	}
64 
65 	function approve(address _spender, uint256 _value) public returns (bool success) {
66 		allowed[msg.sender][_spender] = _value;
67 		emit Approval(msg.sender, _spender, _value);
68 		return true;
69 	}
70 
71 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
72 		return allowed[_owner][_spender];
73 	}
74 
75 	function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
76 		require(cap >= totalSupply + _amount);
77 		require(totalSupply + _amount > totalSupply && balances[_to] + _amount > balances[_to]);
78 		totalSupply += _amount;
79 		balances[_to] += _amount;
80 		emit Mint(_to, _amount);
81 		emit Transfer(address(0), _to, _amount);
82 		return true;
83 	}
84 
85 	function burn(uint256 _value) public returns (bool) {
86 		require(_value <= balances[msg.sender]);
87 		balances[msg.sender] -= _value;
88 		totalSupply -= _value;
89 		emit Burn(msg.sender, _value);
90 		emit Transfer(msg.sender, address(0), _value);
91 		return true;
92 	}
93 
94 	function batchTransfer(address[] _tos, uint256[] _amount) public returns (bool success) {
95 		require(_tos.length == _amount.length);
96 		uint256 i;
97 		uint256 sum = 0;
98 		for(i = 0; i < _amount.length; i++)
99 			sum += _amount[i];
100 
101 		require(balances[msg.sender] >= sum);
102 
103 		for(i = 0; i < _tos.length; i++)
104 			transfer(_tos[i], _amount[i]);
105 
106 		return true;
107 	}
108 }