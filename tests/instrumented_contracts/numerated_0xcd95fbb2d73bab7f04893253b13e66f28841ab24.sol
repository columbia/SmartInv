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
39 	string public constant name = "Gamblica Coin";
40 	uint8 public constant decimals = 18;
41 
42 	uint256 _totalSupply = 0;
43 	
44 	event Burned(address backer, uint _value);
45  
46 	// Balances for each account
47 	mapping(address => uint256) balances;
48  
49 	// Owner of account approves the transfer of an amount to another account
50 	mapping(address => mapping (address => uint256)) allowed;
51 
52 	address public crowdsale;
53 
54 	function changeCrowdsale(address newCrowdsale) public onlyOwner 
55 	{
56 		crowdsale = newCrowdsale;
57 	}
58 
59 	modifier onlyOwnerOrCrowdsale 
60 	{
61 		require(msg.sender == owner || msg.sender == crowdsale);
62 		_;
63 	}
64 
65 	function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) 
66 	{
67 		uint256 z = _x + _y;
68 		assert(z >= _x);
69 		return z;
70 	}
71 
72 	function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) 
73 	{
74 		assert(_x >= _y);
75 		return _x - _y;
76 	}
77 	
78 	function totalSupply() public constant returns (uint256 totalTokenCount) 
79 	{
80 		return _totalSupply;
81 	}
82  
83 	// What is the balance of a particular account?
84 	function balanceOf(address _owner) public constant returns (uint256 balance) 
85 	{
86 		return balances[_owner];
87 	}
88 
89  
90 	// Transfer the balance from owner's account to another account
91 	function transfer(address _to, uint256 _amount) public returns (bool success) 
92 	{
93 		if (balances[msg.sender] >= _amount 
94 			&& _amount > 0
95 			&& balances[_to] + _amount > balances[_to]
96 			) 
97 		{
98 			balances[msg.sender] -= _amount;
99 			balances[_to] += _amount;
100 			Transfer(msg.sender, _to, _amount);
101 			return true;
102 		} else {
103 			revert();
104 		}
105 	}
106  
107 	// Send _value amount of tokens from address _from to address _to
108 	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
109 	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
110 	// fees in sub-currencies; the command should fail unless the _from account has
111 	// deliberately authorized the sender of the message via some mechanism; we propose
112 	// these standardized APIs for approval:
113 	function transferFrom(
114 		address _from,
115 		address _to,
116 		uint256 _amount
117 	) public returns (bool success) 
118 	{
119 		if (balances[_from] >= _amount
120 			&& allowed[_from][msg.sender] >= _amount
121 			&& _amount > 0
122 			&& balances[_to] + _amount > balances[_to] 
123 			)
124 		{
125 			balances[_from] -= _amount;
126 			allowed[_from][msg.sender] -= _amount;
127 			balances[_to] += _amount;
128 			Transfer(_from, _to, _amount);
129 			return true;
130 		} else {
131 			revert();
132 		}
133 	}
134  
135 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
136 	// If this function is called again it overwrites the current allowance with _value.
137 	function approve(address _spender, uint256 _amount) public returns (bool success) 
138 	{
139 		allowed[msg.sender][_spender] = _amount;
140 		Approval(msg.sender, _spender, _amount);
141 		return true;
142 	}
143  
144 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
145 	{
146 		return allowed[_owner][_spender];
147 	}
148 
149 	function send(address target, uint256 mintedAmount) public onlyOwnerOrCrowdsale 
150 	{
151 		require(mintedAmount > 0);
152 
153 		balances[target] = safeAdd(balances[target], mintedAmount);
154 		_totalSupply = safeAdd(_totalSupply, mintedAmount);
155 		Transfer(msg.sender, target, mintedAmount);
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