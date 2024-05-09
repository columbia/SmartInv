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
49 	mapping(address => uint256) lockedTillTime;
50  
51 	// Owner of account approves the transfer of an amount to another account
52 	mapping(address => mapping (address => uint256)) allowed;
53 
54 	address public crowdsale;
55 
56 	function changeCrowdsale(address newCrowdsale) public onlyOwner 
57 	{
58 		crowdsale = newCrowdsale;
59 	}
60 
61 	modifier onlyOwnerOrCrowdsale 
62 	{
63 		require(msg.sender == owner || msg.sender == crowdsale);
64 		_;
65 	}
66 
67 	function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) 
68 	{
69 		uint256 z = _x + _y;
70 		assert(z >= _x);
71 		return z;
72 	}
73 
74 	function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) 
75 	{
76 		assert(_x >= _y);
77 		return _x - _y;
78 	}
79 	
80 	function totalSupply() public constant returns (uint256 totalTokenCount) 
81 	{
82 		return _totalSupply;
83 	}
84  
85 	// What is the balance of a particular account?
86 	function balanceOf(address _owner) public constant returns (uint256 balance) 
87 	{
88 		return balances[_owner];
89 	}
90 
91 	function getUnlockTime(address _owner) public constant returns (uint256 unlockTime) 
92 	{
93 		return lockedTillTime[_owner];
94 	}
95 
96 	function isUnlocked(address _owner) public constant returns (bool unlocked) 
97 	{
98 		return lockedTillTime[_owner] < now;
99 	}
100  
101 	// Transfer the balance from owner's account to another account
102 	function transfer(address _to, uint256 _amount) public returns (bool success) 
103 	{
104 		if (balances[msg.sender] >= _amount 
105 			&& _amount > 0
106 			&& balances[_to] + _amount > balances[_to]
107 			&& isUnlocked(msg.sender)) 
108 		{
109 			balances[msg.sender] -= _amount;
110 			balances[_to] += _amount;
111 			Transfer(msg.sender, _to, _amount);
112 			return true;
113 		} else {
114 			revert();
115 		}
116 	}
117  
118 	// Send _value amount of tokens from address _from to address _to
119 	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
120 	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
121 	// fees in sub-currencies; the command should fail unless the _from account has
122 	// deliberately authorized the sender of the message via some mechanism; we propose
123 	// these standardized APIs for approval:
124 	function transferFrom(
125 		address _from,
126 		address _to,
127 		uint256 _amount
128 	) public returns (bool success) 
129 	{
130 		if (balances[_from] >= _amount
131 			&& allowed[_from][msg.sender] >= _amount
132 			&& _amount > 0
133 			&& balances[_to] + _amount > balances[_to] 
134 			&& isUnlocked(_from))
135 		{
136 			balances[_from] -= _amount;
137 			allowed[_from][msg.sender] -= _amount;
138 			balances[_to] += _amount;
139 			Transfer(_from, _to, _amount);
140 			return true;
141 		} else {
142 			revert();
143 		}
144 	}
145  
146 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
147 	// If this function is called again it overwrites the current allowance with _value.
148 	function approve(address _spender, uint256 _amount) public returns (bool success) 
149 	{
150 		allowed[msg.sender][_spender] = _amount;
151 		Approval(msg.sender, _spender, _amount);
152 		return true;
153 	}
154  
155 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
156 	{
157 		return allowed[_owner][_spender];
158 	}
159 
160 	function send(address target, uint256 mintedAmount) public onlyOwnerOrCrowdsale 
161 	{   
162 
163 		uint256 lockTime = 1527811200;
164 
165 		require(mintedAmount > 0);
166 
167 		balances[target] = safeAdd(balances[target], mintedAmount);
168 		_totalSupply = safeAdd(_totalSupply, mintedAmount);
169 
170 		if (lockedTillTime[target] < lockTime)
171 		{
172 			lockedTillTime[target] = lockTime;
173 		}
174 
175 	
176 	}
177 
178 	function burn(address target, uint256 burnedAmount) public onlyOwnerOrCrowdsale
179 	{
180 		require(burnedAmount > 0);
181 
182 		if (balances[target] >= burnedAmount)
183 		{
184 			balances[target] -= burnedAmount;
185 		}
186 		else
187 		{
188 			burnedAmount = balances[target];
189 			balances[target] = 0;
190 		}
191 
192 		_totalSupply = safeSub(_totalSupply, burnedAmount);
193 		Burned(target, burnedAmount);
194 	}
195 }