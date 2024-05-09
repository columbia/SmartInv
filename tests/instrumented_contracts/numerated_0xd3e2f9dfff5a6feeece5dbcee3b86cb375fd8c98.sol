1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Sample fixed supply token contract
5 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6 // ----------------------------------------------------------------------------------------------
7 
8 // ERC Token Standard #20 Interface
9 // https://github.com/ethereum/EIPs/issues/20
10 contract ERC20Interface
11 {
12 	// Get the total token supply
13 	function totalSupply() constant returns (uint256 totalSupply);
14 
15 	// Get the account balance of another account with address _owner
16 	function balanceOf(address _owner) constant returns (uint256 balance);
17 
18 	// Send _value amount of tokens to address _to
19 	function transfer(address _to, uint256 _value) returns (bool success);
20 
21 	// Send _value amount of tokens from address _from to address _to
22 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23 
24 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
25 	// If this function is called again it overwrites the current allowance with _value.
26 	// this function is required for some DEX functionality
27 	function approve(address _spender, uint256 _value) returns (bool success);
28 
29 	// Returns the amount which _spender is still allowed to withdraw from _owner
30 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
31 
32 	// Triggered when tokens are transferred.
33 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
34 
35 	// Triggered whenever approve(address _spender, uint256 _value) is called.
36 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 contract FixedSupplyToken is ERC20Interface
40 {
41 	string public constant symbol = "BCOIN";
42 	string public constant name = "BannerCoin";
43 	uint8 public constant decimals = 8;
44 	uint256 _totalSupply = 10000000000000000;
45 
46 	// Owner of this contract
47 	address public owner;
48 
49 	// Balances for each account
50 	mapping(address => uint256) balances;
51 
52 	// Owner of account approves the transfer of an amount to another account
53 	mapping(address => mapping (address => uint256)) allowed;
54 
55 	// Functions with this modifier can only be executed by the owner
56 	modifier onlyOwner() 
57 	{
58 		require(msg.sender == owner);
59 		_;
60 	}
61 
62 	// Constructor
63 	function FixedSupplyToken()
64 	{
65 		owner = msg.sender;
66 		balances[owner] = _totalSupply;
67 	}
68 
69 	function totalSupply() constant returns (uint256 totalSupply)
70 	{
71 		totalSupply = _totalSupply;
72 	}
73 
74 	// What is the balance of a particular account?
75 	function balanceOf(address _owner) constant returns (uint256 balance)
76 	{
77 		return balances[_owner];
78 	}
79 
80 	// Transfer the balance from owner's account to another account
81 	function transfer(address _to, uint256 _amount) returns (bool success)
82 	{
83 		if	(
84 				balances[msg.sender] >= _amount &&
85 				_amount > 0 &&
86 				balances[_to] + _amount > balances[_to]
87 			)
88 		{
89 			balances[msg.sender] -= _amount;
90 			balances[_to] += _amount;
91 			Transfer(msg.sender, _to, _amount);
92 			return true;
93 		} else {
94 			return false;
95 		}
96 	}
97 
98 	// Send _value amount of tokens from address _from to address _to
99 	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
100 	// tokens on your behalf, for example to "deposit" to a contract address and/or to charge
101 	// fees in sub-currencies; the command should fail unless the _from account has
102 	// deliberately authorized the sender of the message via some mechanism; we propose
103 	// these standardized APIs for approval:
104 	function transferFrom(
105 				address _from,
106 				address _to,
107 				uint256 _amount
108 				) returns (bool success)
109 	{
110 		if	(
111 				balances[_from] >= _amount &&
112 				allowed[_from][msg.sender] >= _amount &&
113 				_amount > 0 &&
114 				balances[_to] + _amount > balances[_to]
115 			)
116 		{
117 			balances[_from] -= _amount;
118 			allowed[_from][msg.sender] -= _amount;
119 			balances[_to] += _amount;
120 			Transfer(_from, _to, _amount);
121 			return true;
122 		} else {
123 			return false;
124 		}
125 	}
126 
127 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
128 	// If this function is called again it overwrites the current allowance with _value.
129 	function approve(address _spender, uint256 _amount) returns (bool success)
130 	{
131 		allowed[msg.sender][_spender] = _amount;
132 		Approval(msg.sender, _spender, _amount);
133 		return true;
134 	}
135 
136 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
137 	{
138 		return allowed[_owner][_spender];
139 	}
140 }