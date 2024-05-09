1 pragma solidity ^0.4.21;
2 
3 contract ERC20 {
4 	function totalSupply() public view returns (uint256 totalSup);
5 	function balanceOf(address _owner) public view returns (uint256 balance);
6 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
8 	function approve(address _spender, uint256 _value) public returns (bool success);
9 	function transfer(address _to, uint256 _value) public returns (bool success);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract ERC223 {
15 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
16 	event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
17 }
18 
19 contract ERC223ReceivingContract {
20 	function tokenFallback(address _from, uint _value, bytes _data) public;
21 }
22 
23 contract CCP is ERC223, ERC20 {
24     
25 	using SafeMath for uint256;
26 
27 	uint public constant _totalSupply = 2100000000e18;
28 	//starting supply of Token
29 
30 	string public constant symbol = "CCP";
31 	string public constant name = "CCP COIN";
32 	uint8 public constant decimals = 18;
33 
34 	mapping(address => uint256) balances;
35 	mapping(address => mapping(address => uint256)) allowed;
36 
37 	constructor() public{
38 		balances[msg.sender] = _totalSupply;
39 		emit Transfer(0x0, msg.sender, _totalSupply);
40 	}
41 
42 	function totalSupply() public view returns (uint256 totalSup) {
43 	return _totalSupply;
44 	}
45 
46 	function balanceOf(address _owner) public view returns (uint256 balance) {
47 		return balances[_owner];
48 	}
49     
50 	function transfer(address _to, uint256 _value) public returns (bool success) {
51 		require(
52 			!isContract(_to)
53 		);
54 		balances[msg.sender] = balances[msg.sender].sub(_value);
55 		balances[_to] = balances[_to].add(_value);
56 		emit Transfer(msg.sender, _to, _value);
57 		return true;
58 	}
59     
60 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success){
61 		require(
62 			isContract(_to)
63 		);
64 		balances[msg.sender] = balances[msg.sender].sub(_value);
65 		balances[_to] = balances[_to].add(_value);
66 		ERC223ReceivingContract(_to).tokenFallback(msg.sender, _value, _data);
67 		emit Transfer(msg.sender, _to, _value, _data);
68 		return true;
69 	}
70     
71 	function isContract(address _from) private view returns (bool) {
72 		uint256 codeSize;
73 		assembly {
74 			codeSize := extcodesize(_from)
75 		}
76 		return codeSize > 0;
77 	}
78     
79     
80 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81 		require(
82 			balances[_from] >= _value
83 			&& _value > 0
84 		);
85 		balances[_from] = balances[_from].sub(_value);
86 		balances[_to] = balances[_to].add(_value);
87 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88 		emit Transfer(_from, _to, _value);
89 		return true;
90 	}
91     
92 	function approve(address _spender, uint256 _value) public returns (bool success) {
93 		require(
94 			(_value == 0) || (allowed[msg.sender][_spender] == 0)
95 		);
96 		allowed[msg.sender][_spender] = _value;
97 		emit Approval(msg.sender, _spender, _value);
98 		return true;
99 	}
100     
101 	function allowance(address _owner, address _spender) public view returns (uint256 remain) {
102 		return allowed[_owner][_spender];
103 	}
104 
105 	function () public payable {
106 		revert();
107 	}
108     
109 	event Transfer(address  indexed _from, address indexed _to, uint256 _value);
110 	event Transfer(address indexed _from, address  indexed _to, uint _value, bytes _data);
111 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112 
113 }
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121 		if (a == 0) {
122 			return 0;
123 		}
124 		uint256 c = a * b;
125 		assert(c / a == b);
126 		return c;
127 	}
128 
129 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
130 		// assert(b > 0); // Solidity automatically throws when dividing by 0
131 		uint256 c = a / b;
132 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 		return c;
134 	}
135 
136 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137 		assert(b <= a);
138 		return a - b;
139 	}
140 
141 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
142 		uint256 c = a + b;
143 		assert(c >= a);
144 		return c;
145 	}
146 }