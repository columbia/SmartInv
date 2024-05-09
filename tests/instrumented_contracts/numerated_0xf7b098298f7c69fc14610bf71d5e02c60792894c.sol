1 pragma solidity ^0.4.8;
2 
3 
4 contract SafeMath {
5 
6   function assert(bool assertion) internal {
7     if (!assertion) throw;
8   }
9 
10   function safeMul(uint a, uint b) internal returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function safeDiv(uint a, uint b) internal returns (uint) {
17     assert(b > 0);
18     uint c = a / b;
19     assert(a == b * c + a % b);
20     return c;
21   }
22 
23 }
24 
25 
26 contract StandardTokenProtocol {
27 
28     function totalSupply() constant returns (uint256 totalSupply) {}
29     function balanceOf(address _owner) constant returns (uint256 balance) {}
30     function transfer(address _recipient, uint256 _value) returns (bool success) {}
31     function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
32     function approve(address _spender, uint256 _value) returns (bool success) {}
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35     event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 }
39 
40 
41 contract StandardToken is StandardTokenProtocol {
42 
43     modifier when_can_transfer(address _from, uint256 _value) {
44         if (balances[_from] >= _value) _;
45     }
46 
47     modifier when_can_receive(address _recipient, uint256 _value) {
48         if (balances[_recipient] + _value > balances[_recipient]) _;
49     }
50 
51     modifier when_is_allowed(address _from, address _delegate, uint256 _value) {
52         if (allowed[_from][_delegate] >= _value) _;
53     }
54 
55     function transfer(address _recipient, uint256 _value)
56         when_can_transfer(msg.sender, _value)
57         when_can_receive(_recipient, _value)
58         returns (bool o_success)
59     {
60         balances[msg.sender] -= _value;
61         balances[_recipient] += _value;
62         Transfer(msg.sender, _recipient, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _recipient, uint256 _value)
67         when_can_transfer(_from, _value)
68         when_can_receive(_recipient, _value)
69         when_is_allowed(_from, msg.sender, _value)
70         returns (bool o_success)
71     {
72         allowed[_from][msg.sender] -= _value;
73         balances[_from] -= _value;
74         balances[_recipient] += _value;
75         Transfer(_from, _recipient, _value);
76         return true;
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool o_success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 o_remaining) {
90         return allowed[_owner][_spender];
91     }
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;
95     uint256 public totalSupply;
96 
97 }
98 
99 contract GUPToken is StandardToken {
100 
101 	//FIELDS
102 	string public name = "Guppy";
103     string public symbol = "GUP";
104     uint public decimals = 3;
105 
106 	//CONSTANTS
107 	uint public constant LOCKOUT_PERIOD = 1 years; //time after end date that illiquid GUP can be transferred
108 
109 	//ASSIGNED IN INITIALIZATION
110 	uint public endMintingTime; //Timestamp after which no more tokens can be created
111 	address public minter; //address of the account which may mint new tokens
112 
113 	mapping (address => uint) public illiquidBalance; //Balance of 'Frozen funds'
114 
115 	//MODIFIERS
116 	//Can only be called by contribution contract.
117 	modifier only_minter {
118 		if (msg.sender != minter) throw;
119 		_;
120 	}
121 
122 	// Can only be called if illiquid tokens may be transformed into liquid.
123 	// This happens when `LOCKOUT_PERIOD` of time passes after `endMintingTime`.
124 	modifier when_thawable {
125 		if (now < endMintingTime + LOCKOUT_PERIOD) throw;
126 		_;
127 	}
128 
129 	// Can only be called if (liquid) tokens may be transferred. Happens
130 	// immediately after `endMintingTime`.
131 	modifier when_transferable {
132 		if (now < endMintingTime) throw;
133 		_;
134 	}
135 
136 	// Can only be called if the `crowdfunder` is allowed to mint tokens. Any
137 	// time before `endMintingTime`.
138 	modifier when_mintable {
139 		if (now >= endMintingTime) throw;
140 		_;
141 	}
142 
143 	// Initialization contract assigns address of crowdfund contract and end time.
144 	function GUPToken(address _minter, uint _endMintingTime) {
145 		endMintingTime = _endMintingTime;
146 		minter = _minter;
147 	}
148 
149 	// Create new tokens when called by the crowdfund contract.
150 	// Only callable before the end time.
151 	function createToken(address _recipient, uint _value)
152 		when_mintable
153 		only_minter
154 		returns (bool o_success)
155 	{
156 		balances[_recipient] += _value;
157 		totalSupply += _value;
158 		return true;
159 	}
160 
161 	// Create an illiquidBalance which cannot be traded until end of lockout period.
162 	// Can only be called by crowdfund contract before the end time.
163 	function createIlliquidToken(address _recipient, uint _value)
164 		when_mintable
165 		only_minter
166 		returns (bool o_success)
167 	{
168 		illiquidBalance[_recipient] += _value;
169 		totalSupply += _value;
170 		return true;
171 	}
172 
173 	// Make sender's illiquid balance liquid when called after lockout period.
174 	function makeLiquid()
175 		when_thawable
176 	{
177 		balances[msg.sender] += illiquidBalance[msg.sender];
178 		illiquidBalance[msg.sender] = 0;
179 	}
180 
181 	// Transfer amount of tokens from sender account to recipient.
182 	// Only callable after the crowd fund end date.
183 	function transfer(address _recipient, uint _amount)
184 		when_transferable
185 		returns (bool o_success)
186 	{
187 		return super.transfer(_recipient, _amount);
188 	}
189 
190 	// Transfer amount of tokens from a specified address to a recipient.
191 	// Only callable after the crowd fund end date.
192 	function transferFrom(address _from, address _recipient, uint _amount)
193 		when_transferable
194 		returns (bool o_success)
195 	{
196 		return super.transferFrom(_from, _recipient, _amount);
197 	}
198 }