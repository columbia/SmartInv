1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract Owned {
6 	address public owner;
7 
8 	constructor() public {
9 		owner = msg.sender;
10 	}
11 
12 	modifier onlyOwner() {
13 		require(msg.sender == owner);
14 		_;
15 	}
16 
17 	function setOwner(address _owner) onlyOwner public {
18 		owner = _owner;
19 	}
20 }
21 
22 contract Pause is Owned {
23 	uint8 public pause;
24 
25 	constructor() public {
26 		pause = 0;
27 	}
28 
29 	function setPause(uint8 _pause) onlyOwner public {
30 		pause = _pause;
31 	}
32 }
33 
34 contract SafeMath {
35 	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
36 		uint256 c = _a + _b;
37 		assert(c >= _a);
38 		return c;
39 	}
40 
41 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42 		assert(_a >= _b);
43 		return _a - _b;
44 	}
45 
46 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
47 		uint256 c = _a * _b;
48 		assert(_a == 0 || c / _a == _b);
49 		return c;
50 	}
51 }
52 
53 contract IToken {
54 	function name() public pure returns (string _name) { _name; }
55 	function symbol() public pure returns (string _symbol) { _symbol; }
56 	function decimals() public pure returns (uint8 _decimals) { _decimals; }
57 	function totalSupply() public pure returns (uint256 _totalSupply) { _totalSupply; }
58 
59 	function balanceOf(address _owner) public pure returns (uint256 balance) { _owner; balance; }
60 
61 	function allowance(address _owner, address _spender) public pure returns (uint256 remaining) { _owner; _spender; remaining; }
62 
63 	function transfer(address _to, uint256 _value) public returns (bool);
64 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
65 	function approve(address _spender, uint256 _value) public returns (bool);
66 }
67 
68 contract Token is IToken, SafeMath, Owned, Pause {
69 	string public constant standard = '0.1';
70 	string public name = '';
71 	string public symbol = '';
72 	uint8 public decimals = 0;
73 	uint256 public totalSupply = 0;
74 	mapping (address => uint256) public balanceOf;
75 	mapping (address => mapping (address => uint256)) public allowance;
76 
77 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
78 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 
80 	constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
81 		require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
82 
83 		name = _name;
84 		symbol = _symbol;
85 		decimals = _decimals;
86 		totalSupply = _totalSupply;
87 
88 		balanceOf[msg.sender] = _totalSupply;
89 	}
90 
91 	modifier validAddress(address _address) {
92 		require(_address != 0x0);
93 		_;
94 	}
95 
96 	function isNotPaused() public constant returns (bool) {
97         return pause == 0;
98     }
99 
100 	function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {
101 		require(isNotPaused());
102 		assert(balanceOf[msg.sender] >= _value && _value > 0);
103 
104 		balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
105 		balanceOf[_to] = add(balanceOf[_to], _value);
106 
107 		emit Transfer(msg.sender, _to, _value);
108 		
109 		return true;
110 	}
111 
112 	function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool) {
113 		require(isNotPaused());
114 		assert(balanceOf[_from] >= _value && _value > 0);
115 		assert(allowance[_from][msg.sender] >= _value);
116 
117 		allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
118 
119 		balanceOf[_from] = sub(balanceOf[_from], _value);
120 		balanceOf[_to] = add(balanceOf[_to], _value);
121 
122 		emit Transfer(_from, _to, _value);
123 
124 		return true;
125 	}
126 
127 	function multisend(address[] dests, uint256[] values) public returns (uint256) {
128 		require(isNotPaused());
129 
130         uint256 i = 0;
131         while (i < dests.length) {
132            transfer(dests[i], values[i]);
133            i += 1;
134         }
135         return(i);
136     }
137 
138 	function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool) {
139 		require(isNotPaused());
140 		require(_value == 0 || allowance[msg.sender][_spender] == 0);
141 
142 		allowance[msg.sender][_spender] = _value;
143 		emit Approval(msg.sender, _spender, _value);
144 
145 		return true;
146 	}
147 }