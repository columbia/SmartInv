1 pragma solidity 0.4.11;
2 
3 contract ERC20 {
4     function totalSupply() constant returns (uint256 totalSupply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _recipient, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract StandardToken is ERC20 {
16 
17 	uint256 public totalSupply;
18 	mapping (address => uint256) balances;
19     mapping (address => mapping (address => uint256)) allowed;
20     
21     modifier when_can_transfer(address _from, uint256 _value) {
22         if (balances[_from] >= _value) _;
23     }
24 
25     modifier when_can_receive(address _recipient, uint256 _value) {
26         if (balances[_recipient] + _value > balances[_recipient]) _;
27     }
28 
29     modifier when_is_allowed(address _from, address _delegate, uint256 _value) {
30         if (allowed[_from][_delegate] >= _value) _;
31     }
32 
33     function transfer(address _recipient, uint256 _value)
34         when_can_transfer(msg.sender, _value)
35         when_can_receive(_recipient, _value)
36         returns (bool o_success)
37     {
38         balances[msg.sender] -= _value;
39         balances[_recipient] += _value;
40         Transfer(msg.sender, _recipient, _value);
41         return true;
42     }
43 
44     function transferFrom(address _from, address _recipient, uint256 _value)
45         when_can_transfer(_from, _value)
46         when_can_receive(_recipient, _value)
47         when_is_allowed(_from, msg.sender, _value)
48         returns (bool o_success)
49     {
50         allowed[_from][msg.sender] -= _value;
51         balances[_from] -= _value;
52         balances[_recipient] += _value;
53         Transfer(_from, _recipient, _value);
54         return true;
55     }
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61     function approve(address _spender, uint256 _value) returns (bool o_success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) constant returns (uint256 o_remaining) {
68         return allowed[_owner][_spender];
69     }
70 }
71 
72 contract T8CToken is StandardToken {
73 
74 	//FIELDS
75 	string public name = "T8Coin";
76     string public symbol = "T8C";
77     uint public decimals = 3;
78 
79 	//INITIALIZATION
80 	address public minter; //address that able to mint new tokens
81 	uint public icoEndTime; 
82 
83 	uint illiquidBalance_amount;
84 	mapping (uint => address) illiquidBalance_index;
85 	mapping (address => uint) public illiquidBalance; //Balance of 'Frozen funds'
86 
87 
88 	// called by crowdsale contract
89 	modifier only_minter {
90 		if (msg.sender != minter) throw;
91 		_;
92 	}
93 
94 	// Can only be called if the `crowdfunder` is allowed to mint tokens. Any
95 	// time before `endMintingTime`.
96 	modifier when_mintable {
97 		if (now > icoEndTime) throw; // todo need bounty create token?
98 		_;
99 	}
100 
101 	// Initialization contract assigns address of crowdfund contract and end time.
102 	function T8CToken (address _minter, uint _icoEndTime) {
103 		minter = _minter;
104 		icoEndTime = _icoEndTime;
105 	}
106 
107 	// Create new tokens when called by the crowdfund contract.
108 	// Only callable before the end time.
109 	function createToken(address _recipient, uint _value)
110 		when_mintable
111 		only_minter
112 		returns (bool o_success)
113 	{
114 		balances[_recipient] += _value;
115 		totalSupply += _value;
116 		return true;
117 	}
118 
119 		// Create an illiquidBalance which cannot be traded until admin make it liquid.
120 	// Can only be called by crowdfund contract before the end time.
121 	function createIlliquidToken(address _recipient, uint _value)
122 		when_mintable
123 		only_minter
124 		returns (bool o_success)
125 	{
126 		illiquidBalance_index[illiquidBalance_amount] = _recipient;
127 		illiquidBalance[_recipient] += _value;
128 		illiquidBalance_amount++;
129 
130 		totalSupply += _value;
131 		return true;
132 	}
133 
134 	// Make sender's illiquid balance liquid when called after lockout period.
135 	function makeLiquid()
136 		only_minter
137 	{
138 		for (uint i=0; i<illiquidBalance_amount; i++)
139 		{
140 			address investor = illiquidBalance_index[i];
141 			balances[investor] += illiquidBalance[investor];
142 			illiquidBalance[investor] = 0;
143 		}
144 	}
145 
146 	// Transfer amount of tokens from sender account to recipient.
147 	// Only callable after the crowd fund end date.
148 	function transfer(address _recipient, uint _amount)
149 		returns (bool o_success)
150 	{
151 		return super.transfer(_recipient, _amount);
152 	}
153 
154 	// Transfer amount of tokens from a specified address to a recipient.
155 	// Only callable after the crowd fund end date.
156 	function transferFrom(address _from, address _recipient, uint _amount)
157 		returns (bool o_success)
158 	{
159 		return super.transferFrom(_from, _recipient, _amount);
160 	}
161 }