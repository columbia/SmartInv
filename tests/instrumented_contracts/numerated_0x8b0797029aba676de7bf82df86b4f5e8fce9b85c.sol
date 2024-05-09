1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4 	address public owner;
5 
6 	constructor() public {
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
20 contract Pause is Owned {
21 	uint8 public pause;
22 
23 	constructor() public {
24 		pause = 0;
25 	}
26 
27 	function setPause(uint8 _pause) onlyOwner public {
28 		pause = _pause;
29 	}
30 }
31 
32 contract SafeMath {
33 	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
34 		uint256 c = _a + _b;
35 		assert(c >= _a);
36 		return c;
37 	}
38 
39 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40 		assert(_a >= _b);
41 		return _a - _b;
42 	}
43 
44 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
45 		uint256 c = _a * _b;
46 		assert(_a == 0 || c / _a == _b);
47 		return c;
48 	}
49 }
50 
51 contract IToken {
52 	function name() public pure returns (string _name) { _name; }
53 	function symbol() public pure returns (string _symbol) { _symbol; }
54 	function decimals() public pure returns (uint8 _decimals) { _decimals; }
55 	function totalSupply() public pure returns (uint256 _totalSupply) { _totalSupply; }
56 
57 	function balanceOf(address _owner) public pure returns (uint256 balance) { _owner; balance; }
58 
59 	function allowance(address _owner, address _spender) public pure returns (uint256 remaining) { _owner; _spender; remaining; }
60 
61 	function transfer(address _to, uint256 _value) public returns (bool);
62 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
63 	function approve(address _spender, uint256 _value) public returns (bool);
64 }
65 
66 contract Token is IToken, SafeMath, Owned, Pause {
67 	string public constant standard = '0.1';
68 	string public name = '';
69 	string public symbol = '';
70 	uint8 public decimals = 0;
71 	uint256 public totalSupply = 0;
72 	mapping (address => uint256) public balanceOf;
73 	mapping (address => mapping (address => uint256)) public allowance;
74 
75 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
76 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 
78 	constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
79 		require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
80 
81 		name = _name;
82 		symbol = _symbol;
83 		decimals = _decimals;
84 		totalSupply = _totalSupply;
85 
86 		balanceOf[msg.sender] = _totalSupply;
87 	}
88 
89 	modifier validAddress(address _address) {
90 		require(_address != 0x0);
91 		_;
92 	}
93 
94 	function isNotPaused() public constant returns (bool) {
95         return pause == 0;
96     }
97 
98 	function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {
99 		require(isNotPaused());
100 		assert(balanceOf[msg.sender] >= _value && _value > 0);
101 
102 		balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
103 		balanceOf[_to] = add(balanceOf[_to], _value);
104 
105 		emit Transfer(msg.sender, _to, _value);
106 		
107 		return true;
108 	}
109 
110 	function transferFrom(address _from, address _to, uint256 _value) public validAddress(_from) validAddress(_to) returns (bool) {
111 		require(isNotPaused());
112 		assert(balanceOf[_from] >= _value && _value > 0);
113 		assert(allowance[_from][msg.sender] >= _value);
114 
115 		allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
116 
117 		balanceOf[_from] = sub(balanceOf[_from], _value);
118 		balanceOf[_to] = add(balanceOf[_to], _value);
119 
120 		emit Transfer(_from, _to, _value);
121 
122 		return true;
123 	}
124 
125 	function multisend(address[] dests, uint256[] values) public returns (uint256) {
126 		require(isNotPaused());
127 
128         uint256 i = 0;
129         while (i < dests.length) {
130            transfer(dests[i], values[i]);
131            i += 1;
132         }
133         return(i);
134     }
135 
136 	function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool) {
137 		require(isNotPaused());
138 		require(_value == 0 || allowance[msg.sender][_spender] == 0);
139 
140 		allowance[msg.sender][_spender] = _value;
141 		emit Approval(msg.sender, _spender, _value);
142 
143 		return true;
144 	}
145 }