1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4 	address public owner;
5 
6 	function Owned() public {
7 		owner = msg.sender;
8 	}
9 
10 	modifier onlyOwner() {
11 		require(msg.sender == owner);
12 		_;
13 	}
14 
15 	function setOwner(address _owner) onlyOwner public {
16 		owner = _owner;
17 	}
18 }
19 
20 contract SafeMath {
21 	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
22 		uint256 c = _a + _b;
23 		assert(c >= _a);
24 		return c;
25 	}
26 
27 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
28 		assert(_a >= _b);
29 		return _a - _b;
30 	}
31 
32 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
33 		uint256 c = _a * _b;
34 		assert(_a == 0 || c / _a == _b);
35 		return c;
36 	}
37 }
38 
39 contract IToken {
40 	function name() public pure returns (string _name) { _name; }
41 	function symbol() public pure returns (string _symbol) { _symbol; }
42 	function decimals() public pure returns (uint8 _decimals) { _decimals; }
43 	function totalSupply() public pure returns (uint256 _totalSupply) { _totalSupply; }
44 
45 	function balanceOf(address _owner) public pure returns (uint256 balance) { _owner; balance; }
46 
47 	function allowance(address _owner, address _spender) public pure returns (uint256 remaining) { _owner; _spender; remaining; }
48 
49 	function transfer(address _to, uint256 _value) public returns (bool success);
50 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
51 	function approve(address _spender, uint256 _value) public returns (bool success);
52 }
53 
54 contract Token is IToken, SafeMath, Owned {
55 	string public constant standard = '0.1';
56 	string public name = '';
57 	string public symbol = '';
58 	uint8 public decimals = 0;
59 	uint256 public totalSupply = 0;
60 	mapping (address => uint256) public balanceOf;
61 	mapping (address => mapping (address => uint256)) public allowance;
62 
63 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
64 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 
66 	function Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
67 		require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
68 
69 		name = _name;
70 		symbol = _symbol;
71 		decimals = _decimals;
72 		totalSupply = _totalSupply;
73 
74 		balanceOf[msg.sender] = _totalSupply;
75 	}
76 
77 	modifier validAddress(address _address) {
78 		require(_address != 0x0);
79 		_;
80 	}
81 
82 	function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool success) {
83 		if (balanceOf[msg.sender] >= _value && _value > 0) {
84 			balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
85 			balanceOf[_to] = add(balanceOf[_to], _value);
86 			Transfer(msg.sender, _to, _value);
87 			return true;
88 		}
89 		else {
90 			return false;
91 		}
92 	}
93 
94 	function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool success) {
95 		if (balanceOf[_from] >= _value && _value > 0) {
96 			allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
97 			balanceOf[_from] = sub(balanceOf[_from], _value);
98 			balanceOf[_to] = add(balanceOf[_to], _value);
99 			Transfer(_from, _to, _value);
100 			return true;
101 		}
102 		else {
103 			return false;
104 		}
105 	}
106 
107 	function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool success) {
108 		require(_value == 0 || allowance[msg.sender][_spender] == 0);
109 
110 		allowance[msg.sender][_spender] = _value;
111 		Approval(msg.sender, _spender, _value);
112 		return true;
113 	}
114 }