1 pragma solidity ^0.5.17;
2 
3 library SafeMath
4 {
5 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
6 	{
7 		c = a + b;
8 		require(c >= a, "SafeMath: addition overflow");
9 	}
10 	
11 	function sub(uint256 a, uint256 b) internal pure returns (uint256 c) 
12 	{
13 		require(b <= a, "SafeMath: subtraction overflow");
14 		c = a - b;
15 	}
16 }
17 contract Variable
18 {
19 	string public name;
20 	string public symbol;
21 	uint256 public decimals;
22 	uint256 public totalSupply;
23 	address public owner;
24 
25 	uint256 internal _decimals;
26 	bool internal transferLock;
27 	
28 	mapping (address => bool) public allowedAddress;
29 	mapping (address => bool) public blockedAddress;
30 
31 	mapping (address => uint256) public balanceOf;
32 	
33 	mapping (address => mapping (address => uint256)) internal allowed;
34 
35 	constructor() public
36 	{
37 		name = "i Money Crypto";
38 		symbol = "IMC";
39 		decimals = 18;
40 		_decimals = 10 ** uint256(decimals);
41 		totalSupply = _decimals * 300000000;
42 		transferLock = true;
43 		owner =	msg.sender;
44 		balanceOf[owner] = totalSupply;
45 		allowedAddress[owner] = true;
46 	}
47 }
48 contract Modifiers is Variable
49 {
50 	modifier isOwner
51 	{
52 		assert(owner == msg.sender);
53 		_;
54 	}
55 }
56 contract Event
57 {
58 	event Transfer(address indexed from, address indexed to, uint256 value);
59 	event TokenBurn(address indexed from, uint256 value);
60 	event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 contract Admin is Variable, Modifiers, Event
63 {
64 	using SafeMath for uint256;
65 	
66 	function tokenBurn(uint256 _value) public isOwner returns(bool success)
67 	{
68 		require(balanceOf[msg.sender] >= _value, "Invalid balance");
69 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
70 		totalSupply = totalSupply.sub(_value);
71 		emit TokenBurn(msg.sender, _value);
72 		return true;
73 	}
74 	function addAllowedAddress(address _address) public isOwner
75 	{
76 		allowedAddress[_address] = true;
77 	}
78 	function deleteAllowedAddress(address _address) public isOwner
79 	{
80 		require(_address != owner,"only allow user address");
81 		allowedAddress[_address] = false;
82 	}
83 	function addBlockedAddress(address _address) public isOwner
84 	{
85 		require(_address != owner,"only allow user address");
86 		blockedAddress[_address] = true;
87 	}
88 	function deleteBlockedAddress(address _address) public isOwner
89 	{
90 		blockedAddress[_address] = false;
91 	}
92 	function setTransferLock(bool _transferLock) public isOwner returns(bool success)
93 	{
94 		transferLock = _transferLock;
95 		return true;
96 	}
97 }
98 contract IMC is Variable, Event, Admin
99 {
100 	function() external payable 
101 	{
102 		revert();
103 	}
104 	
105 	function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) 
106 	{
107 		return allowed[tokenOwner][spender];
108 	}
109 	
110 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) 
111 	{
112 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114 		return true;
115 	}
116 	
117 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool)
118 	{
119 		uint256 oldValue = allowed[msg.sender][_spender];
120 		if (_subtractedValue > oldValue) 
121 		{
122 			allowed[msg.sender][_spender] = 0;
123 		} 
124 		else
125 		{
126 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
127 		}
128 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129 		return true;
130 	}
131 	
132 	function approve(address _spender, uint256 _value) public returns (bool)
133 	{
134 		allowed[msg.sender][_spender] = _value;
135 		emit Approval(msg.sender, _spender, _value);
136 		return true;
137 	}
138 	
139 	function get_transferLock() public view returns(bool)
140     {
141         return transferLock;
142     }
143     
144 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
145 	{
146 		require(allowedAddress[_from] || transferLock == false, "Transfer lock : true");
147 		require(!blockedAddress[_from] && !blockedAddress[_to] && !blockedAddress[msg.sender], "Blocked address");
148 		require(balanceOf[_from] >= _value && (balanceOf[_to].add(_value)) >= balanceOf[_to], "Invalid balance");
149 		require(_value <= allowed[_from][msg.sender], "Invalid balance : allowed");
150 
151 		balanceOf[_from] = balanceOf[_from].sub(_value);
152 		balanceOf[_to] = balanceOf[_to].add(_value);
153 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154 		emit Transfer(_from, _to, _value);
155 
156 		return true;
157 	}
158 	
159 	function transfer(address _to, uint256 _value) public returns (bool)	
160 	{
161 		require(allowedAddress[msg.sender] || transferLock == false, "Transfer lock : true");
162 		require(!blockedAddress[msg.sender] && !blockedAddress[_to], "Blocked address");
163 		require(balanceOf[msg.sender] >= _value && (balanceOf[_to].add(_value)) >= balanceOf[_to], "Invalid balance");
164 
165 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
166 		balanceOf[_to] = balanceOf[_to].add(_value);
167 		emit Transfer(msg.sender, _to, _value);
168 				
169 		return true;
170 	}
171 }