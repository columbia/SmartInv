1 /**
2  *  The Monetha token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
3  *  The owner's share of tokens is locked for the first year and all tokens not
4  *  being sold during the crowdsale but the owner's share + reserved tokend for bounty, loyalty program and future financing are burned.
5  *  Author: Julia Altenried
6  *  Internal audit: Alex Bazhanau, Andrej Ruckij
7  *  Audit: Blockchain & Smart Contract Security Group
8  **/
9 
10 pragma solidity ^0.4.15;
11 
12 contract SafeMath {
13 	//internals
14 
15 	function safeMul(uint a, uint b) internal returns(uint) {
16 		uint c = a * b;
17 		assert(a == 0 || c / a == b);
18 		return c;
19 	}
20 
21 	function safeSub(uint a, uint b) internal returns(uint) {
22 		assert(b <= a);
23 		return a - b;
24 	}
25 
26 	function safeAdd(uint a, uint b) internal returns(uint) {
27 		uint c = a + b;
28 		assert(c >= a && c >= b);
29 		return c;
30 	}
31 }
32 
33 contract MonethaToken is SafeMath {
34 	/* Public variables of the token */
35 	string constant public standard = "ERC20";
36 	string constant public name = "Monetha";
37 	string constant public symbol = "MTH";
38 	uint8 constant public decimals = 5;
39 	uint public totalSupply = 40240000000000;
40 	uint constant public tokensForIco = 20120000000000;
41 	uint constant public reservedAmount = 20120000000000;
42 	uint constant public lockedAmount = 15291200000000;
43 	address public owner;
44 	address public ico;
45 	/* from this time on tokens may be transfered (after ICO)*/
46 	uint public startTime;
47 	uint public lockReleaseDate;
48 	/* tells if tokens have been burned already */
49 	bool burned;
50 
51 	/* This creates an array with all balances */
52 	mapping(address => uint) public balanceOf;
53 	mapping(address => mapping(address => uint)) public allowance;
54 
55 
56 	/* This generates a public event on the blockchain that will notify clients */
57 	event Transfer(address indexed from, address indexed to, uint value);
58 	event Approval(address indexed _owner, address indexed spender, uint value);
59 	event Burned(uint amount);
60 
61 	/* Initializes contract with initial supply tokens to the creator of the contract */
62 	function MonethaToken(address _ownerAddr, uint _startTime) {
63 		owner = _ownerAddr;
64 		startTime = _startTime;
65 		lockReleaseDate = startTime + 1 years;
66 		balanceOf[owner] = totalSupply; // Give the owner all initial tokens
67 	}
68 
69 	/* Send some of your tokens to a given address */
70 	function transfer(address _to, uint _value) returns(bool success) {
71 		require(now >= startTime); //check if the crowdsale is already over
72 		if (msg.sender == owner && now < lockReleaseDate) 
73 			require(safeSub(balanceOf[msg.sender], _value) >= lockedAmount); //prevent the owner of spending his share of tokens for company, loyalty program and future financing of the company within the first year
74 		balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
75 		balanceOf[_to] = safeAdd(balanceOf[_to], _value); // Add the same to the recipient
76 		Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
77 		return true;
78 	}
79 
80 	/* Allow another contract or person to spend some tokens in your behalf */
81 	function approve(address _spender, uint _value) returns(bool success) {
82 		return _approve(_spender,_value);
83 	}
84 	
85 	/* internal approve functionality. needed, so we can check the payloadsize if called externally, but smaller 
86 	*  payload allowed internally */
87 	function _approve(address _spender, uint _value) internal returns(bool success) {
88 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
90 		allowance[msg.sender][_spender] = _value;
91 		Approval(msg.sender, _spender, _value);
92 		return true;
93 	}
94 
95 
96 	/* A contract or  person attempts to get the tokens of somebody else.
97 	 *  This is only allowed if the token holder approved. */
98 	function transferFrom(address _from, address _to, uint _value) returns(bool success) {
99 		if (now < startTime) 
100 			require(_from == owner); //check if the crowdsale is already over
101 		if (_from == owner && now < lockReleaseDate) 
102 			require(safeSub(balanceOf[_from], _value) >= lockedAmount); //prevent the owner of spending his share of tokens for company, loyalty program and future financing of the company within the first year
103 		var _allowance = allowance[_from][msg.sender];
104 		balanceOf[_from] = safeSub(balanceOf[_from], _value); // Subtract from the sender
105 		balanceOf[_to] = safeAdd(balanceOf[_to], _value); // Add the same to the recipient
106 		allowance[_from][msg.sender] = safeSub(_allowance, _value);
107 		Transfer(_from, _to, _value);
108 		return true;
109 	}
110 
111 
112 	/* to be called when ICO is closed. burns the remaining tokens except the company share (60360000), the tokens reserved
113 	 *  for the bounty/advisors/marketing program (48288000), for the loyalty program (52312000) and for future financing of the company (40240000).
114 	 *  anybody may burn the tokens after ICO ended, but only once (in case the owner holds more tokens in the future).
115 	 *  this ensures that the owner will not posses a majority of the tokens. */
116 	function burn() {
117 		//if tokens have not been burned already and the ICO ended
118 		if (!burned && now > startTime) {
119 			uint difference = safeSub(balanceOf[owner], reservedAmount);
120 			balanceOf[owner] = reservedAmount;
121 			totalSupply = safeSub(totalSupply, difference);
122 			burned = true;
123 			Burned(difference);
124 		}
125 	}
126 	
127 	/**
128 	* sets the ico address and give it allowance to spend the crowdsale tokens. Only callable once.
129 	* @param _icoAddress the address of the ico contract
130 	* value the max amount of tokens to sell during the ICO
131 	**/
132 	function setICO(address _icoAddress) {
133 		require(msg.sender == owner);
134 		ico = _icoAddress;
135 		assert(_approve(ico, tokensForIco));
136 	}
137 	
138 	/**
139 	* Allows the ico contract to set the trading start time to an earlier point of time.
140 	* (In case the soft cap has been reached)
141 	* @param _newStart the new start date
142 	**/
143 	function setStart(uint _newStart) {
144 		require(msg.sender == ico && _newStart < startTime);
145 		startTime = _newStart;
146 	}
147 
148 }