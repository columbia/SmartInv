1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 	function add(uint a, uint b) internal pure returns(uint c) {
5 		c = a + b;
6 		require(c >= a);
7 	}
8 
9 	function sub(uint a, uint b) internal pure returns(uint c) {
10 		require(b <= a);
11 		c = a - b;
12 	}
13 
14 	function mul(uint a, uint b) internal pure returns(uint c) {
15 		c = a * b;
16 		require(a == 0 || c / a == b);
17 	}
18 
19 	function div(uint a, uint b) internal pure returns(uint c) {
20 		require(b > 0);
21 		c = a / b;
22 	}
23 }
24 
25 contract ERC20Interface {
26 	function totalSupply() public constant returns(uint);
27 
28 	function balanceOf(address tokenOwner) public constant returns(uint balance);
29 
30 	function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
31 
32 	function transfer(address to, uint tokens) public returns(bool success);
33 
34 	function approve(address spender, uint tokens) public returns(bool success);
35 
36 	function transferFrom(address from, address to, uint tokens) public returns(bool success);
37 
38 	function burn(uint256 value) public returns(bool success);
39 
40 	event Transfer(address indexed from, address indexed to, uint tokens);
41 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 	event Burn(address indexed from, uint256 value);
43 }
44 
45 contract ApproveAndCallFallBack {
46 	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 contract DetailedToken {
50 	string public name;
51 	string public symbol;
52 	uint8 public decimals;
53 }
54 
55 contract Owned {
56 	address public owner;
57 	address public newOwner;
58 
59 	event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61 	function Owned() public {
62 		owner = msg.sender;
63 	}
64 
65 	modifier onlyOwner {
66 		require(msg.sender == owner);
67 		_;
68 	}
69 
70 	function transferOwnership(address _newOwner) public onlyOwner {
71 		newOwner = _newOwner;
72 	}
73 
74 	function acceptOwnership() public {
75 		require(msg.sender == newOwner);
76 		OwnershipTransferred(owner, newOwner);
77 		owner = newOwner;
78 		newOwner = address(0);
79 	}
80 }
81 
82 contract XIOToken is ERC20Interface, DetailedToken, Owned {
83 	using SafeMath
84 	for uint;
85 	string public symbol;
86 	string public name;
87 	uint8 public decimals;
88 	uint public _totalSupply;
89 	mapping(address => uint) balances;
90 	mapping(address => mapping(address => uint)) allowed;
91 
92 	function XIOToken() public {
93 		symbol = "XIO";
94 		name = "XIO Token";
95 		decimals = 18;
96 		_totalSupply = 1000000000 * 10 ** uint(decimals);
97 		balances[owner] = _totalSupply;
98 		Transfer(address(0), owner, _totalSupply);
99 	}
100 
101 	function totalSupply() public constant returns(uint) {
102 		return _totalSupply - balances[address(0)];
103 	}
104 
105 	function balanceOf(address tokenOwner) public constant returns(uint balance) {
106 		return balances[tokenOwner];
107 	}
108 
109 	function transfer(address to, uint tokens) public returns(bool success) {
110 		balances[msg.sender] = balances[msg.sender].sub(tokens);
111 		balances[to] = balances[to].add(tokens);
112 		Transfer(msg.sender, to, tokens);
113 		return true;
114 	}
115 
116 	function approve(address spender, uint tokens) public returns(bool success) {
117 		allowed[msg.sender][spender] = tokens;
118 		Approval(msg.sender, spender, tokens);
119 		return true;
120 	}
121 
122 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
123 		balances[from] = balances[from].sub(tokens);
124 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
125 		balances[to] = balances[to].add(tokens);
126 		Transfer(from, to, tokens);
127 		return true;
128 	}
129 
130 	function burn(uint256 value) public returns(bool success) {
131 		require(balances[msg.sender] >= value);
132 		balances[msg.sender] -= value;
133 		_totalSupply -= value;
134 		Burn(msg.sender, value);
135 		return true;
136 	}
137 
138 	function allowance(address tokenOwner, address spender) public constant returns(uint remaining) {
139 		return allowed[tokenOwner][spender];
140 	}
141 
142 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
143 		allowed[msg.sender][spender] = tokens;
144 		Approval(msg.sender, spender, tokens);
145 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
146 		return true;
147 	}
148 
149 	function() public payable {
150 		revert();
151 	}
152 
153 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
154 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
155 	}
156 }