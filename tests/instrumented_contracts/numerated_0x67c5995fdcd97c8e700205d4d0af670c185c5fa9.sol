1 pragma solidity ^0.4.15;
2 
3 contract owned 
4 {
5 	address public owner;
6 
7 	function owned() public
8 	{
9 		owner = msg.sender;
10 	}
11 
12 	function changeOwner(address newOwner) public onlyOwner 
13 	{
14 		owner = newOwner;
15 	}
16 
17 	modifier onlyOwner 
18 	{
19 		require(msg.sender == owner);
20 		_;
21 	}
22 }
23 
24 contract ERC20 {
25 	function totalSupply() public constant returns (uint totalTokenCount);
26 	function balanceOf(address _owner) public constant returns (uint balance);
27 	function transfer(address _to, uint _value) public returns (bool success);
28 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
29 	function approve(address _spender, uint _value) public returns (bool success);
30 	function allowance(address _owner, address _spender) public constant returns (uint remaining);
31 	event Transfer(address indexed _from, address indexed _to, uint _value);
32 	event Approval(address indexed _owner, address indexed _spender, uint _value);
33 }
34 
35 
36 contract GamblicaCoin is ERC20, owned 
37 {
38 	string public constant symbol = "GMBC";
39 	string public constant name = "GMBC";
40 	uint8 public constant decimals = 18;
41 
42 	uint256 _totalSupply = 0;
43 	
44 	event Burned(address backer, uint _value);
45  
46 	// Balances for each account
47 	mapping(address => uint256) balances;
48 
49  
50 	// Owner of account approves the transfer of an amount to another account
51 	mapping(address => mapping (address => uint256)) allowed;
52 
53 	address public crowdsale;
54 
55 	function changeCrowdsale(address newCrowdsale) public onlyOwner 
56 	{
57 		crowdsale = newCrowdsale;
58 	}
59 
60 	modifier onlyOwnerOrCrowdsale 
61 	{
62 		require(msg.sender == owner || msg.sender == crowdsale);
63 		_;
64 	}
65 
66 	function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) 
67 	{
68 		uint256 z = _x + _y;
69 		assert(z >= _x);
70 		return z;
71 	}
72 
73 	function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) 
74 	{
75 		assert(_x >= _y);
76 		return _x - _y;
77 	}
78 	
79 	function totalSupply() public constant returns (uint256 totalTokenCount) 
80 	{
81 		return _totalSupply;
82 	}
83  
84 	// What is the balance of a particular account?
85 	function balanceOf(address _owner) public constant returns (uint256 balance) 
86 	{
87 		return balances[_owner];
88 	}
89 
90  
91 	// Transfer the balance from owner's account to another account
92 	function transfer(address _to, uint256 _amount) public returns (bool success) 
93 	{
94 		if (balances[msg.sender] >= _amount 
95 			&& _amount > 0
96 			&& balances[_to] + _amount > balances[_to]
97 			) 
98 		{
99 			balances[msg.sender] -= _amount;
100 			balances[_to] += _amount;
101 			Transfer(msg.sender, _to, _amount);
102 			return true;
103 		} else {
104 			revert();
105 		}
106 	}
107  
108 	// Send _value amount of tokens from address _from to address _to
109 	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
110 	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
111 	// fees in sub-currencies; the command should fail unless the _from account has
112 	// deliberately authorized the sender of the message via some mechanism; we propose
113 	// these standardized APIs for approval:
114 	function transferFrom(
115 		address _from,
116 		address _to,
117 		uint256 _amount
118 	) public returns (bool success) 
119 	{
120 		if (balances[_from] >= _amount
121 			&& allowed[_from][msg.sender] >= _amount
122 			&& _amount > 0
123 			&& balances[_to] + _amount > balances[_to] 
124 			)
125 		{
126 			balances[_from] -= _amount;
127 			allowed[_from][msg.sender] -= _amount;
128 			balances[_to] += _amount;
129 			Transfer(_from, _to, _amount);
130 			return true;
131 		} else {
132 			revert();
133 		}
134 	}
135  
136 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
137 	// If this function is called again it overwrites the current allowance with _value.
138 	function approve(address _spender, uint256 _amount) public returns (bool success) 
139 	{
140 		allowed[msg.sender][_spender] = _amount;
141 		Approval(msg.sender, _spender, _amount);
142 		return true;
143 	}
144  
145 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
146 	{
147 		return allowed[_owner][_spender];
148 	}
149 
150 	function send(address target, uint256 mintedAmount) public onlyOwnerOrCrowdsale 
151 	{
152 		require(mintedAmount > 0);
153 
154 		balances[target] = safeAdd(balances[target], mintedAmount);
155 		_totalSupply = safeAdd(_totalSupply, mintedAmount);
156 	}
157 
158 	function burn(address target, uint256 burnedAmount) public onlyOwnerOrCrowdsale
159 	{
160 		require(burnedAmount > 0);
161 
162 		if (balances[target] >= burnedAmount)
163 		{
164 			balances[target] -= burnedAmount;
165 		}
166 		else
167 		{
168 			burnedAmount = balances[target];
169 			balances[target] = 0;
170 		}
171 
172 		_totalSupply = safeSub(_totalSupply, burnedAmount);
173 		Burned(target, burnedAmount);
174 	}
175 }