1 pragma solidity ^ 0.4 .18;
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
49 contract Owned {
50 	address public owner;
51 	address public newOwner;
52 
53 	event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55 	function Owned() public {
56 		owner = msg.sender;
57 	}
58 
59 	modifier onlyOwner {
60 		require(msg.sender == owner);
61 		_;
62 	}
63 
64 	function transferOwnership(address _newOwner) public onlyOwner {
65 		newOwner = _newOwner;
66 	}
67 
68 	function acceptOwnership() public {
69 		require(msg.sender == newOwner);
70 		OwnershipTransferred(owner, newOwner);
71 		owner = newOwner;
72 		newOwner = address(0);
73 	}
74 }
75 
76 contract eSportsToken is ERC20Interface, Owned {
77 	using SafeMath
78 	for uint;
79 	string public symbol;
80 	string public name;
81 	uint8 public decimals;
82 	uint public _totalSupply;
83 	mapping(address => uint) balances;
84 	mapping(address => mapping(address => uint)) allowed;
85 
86 	function eSportsToken() public {
87 		symbol = "ESPT";
88 		name = "eSports";
89 		decimals = 18;
90 		_totalSupply = 1500000000 * 10 ** uint(decimals);
91 		balances[owner] = _totalSupply;
92 		Transfer(address(0), owner, _totalSupply);
93 	}
94 
95 	function totalSupply() public constant returns(uint) {
96 		return _totalSupply - balances[address(0)];
97 	}
98 
99 	function balanceOf(address tokenOwner) public constant returns(uint balance) {
100 		return balances[tokenOwner];
101 	}
102 
103 	function transfer(address to, uint tokens) public returns(bool success) {
104 		balances[msg.sender] = balances[msg.sender].sub(tokens);
105 		balances[to] = balances[to].add(tokens);
106 		Transfer(msg.sender, to, tokens);
107 		return true;
108 	}
109 
110 	function approve(address spender, uint tokens) public returns(bool success) {
111 		allowed[msg.sender][spender] = tokens;
112 		Approval(msg.sender, spender, tokens);
113 		return true;
114 	}
115 
116 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
117 		balances[from] = balances[from].sub(tokens);
118 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
119 		balances[to] = balances[to].add(tokens);
120 		Transfer(from, to, tokens);
121 		return true;
122 	}
123 
124 	function burn(uint256 value) public returns(bool success) {
125 		require(balances[msg.sender] >= value);
126 		balances[msg.sender] -= value;
127 		_totalSupply -= value;
128 		Burn(msg.sender, value);
129 		return true;
130 	}
131 
132 	function allowance(address tokenOwner, address spender) public constant returns(uint remaining) {
133 		return allowed[tokenOwner][spender];
134 	}
135 
136 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
137 		allowed[msg.sender][spender] = tokens;
138 		Approval(msg.sender, spender, tokens);
139 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
140 		return true;
141 	}
142 
143 	function() public payable {
144 		revert();
145 	}
146 
147 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
148 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
149 	}
150 }