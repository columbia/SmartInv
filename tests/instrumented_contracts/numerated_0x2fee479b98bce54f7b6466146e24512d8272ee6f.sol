1 pragma solidity ^0.4.17;
2 
3 interface ERC20Token {
4 	function balanceOf(address tokenOwner)
5 		public view returns (uint balance);
6  	function transfer(address to, uint tokens)
7 		public returns (bool success);
8 	function symbol() public view returns (string);
9 	function name() public view returns (string);
10 	function decimals() public view returns (uint8);
11 }
12 
13 contract MultiKeyDailyLimitWallet {
14 	uint constant LIMIT_PRECISION = 1000000;
15 	// Fractional daily limits per key. In units of 1/LIMIT_PRECISION.
16 	mapping(address=>uint) public credentials;
17 	// Timestamp of last withdrawal, by token (0x0 is ether).
18 	mapping(address=>uint) public lastWithdrawalTime;
19 	// Total withdrawn in last 24-hours, by token (0x0 is ether).
20 	// Resets if 24 hours passes with no activity.
21 	mapping(address=>uint) public dailyCount;
22 	uint public nonce;
23 
24 	event OnWithdrawTo(
25 		address indexed token,
26 		address indexed from,
27 		address indexed to,
28 		uint amount,
29 		uint64 timestamp);
30 
31 	function MultiKeyDailyLimitWallet(address[] keys, uint[] limits)
32 			payable public {
33 		
34 		require(keys.length == limits.length);
35 		for (uint i = 0; i < keys.length; i++) {
36 			var limit = limits[i];
37 			// limit should be in range 1-LIMIT_PRECISION
38 			require (limit > 0 && limit <= LIMIT_PRECISION);
39 			credentials[keys[i]] = limit;
40 		}
41 	}
42 
43 	/* #IF TESTING
44 	function setLastWithdrawalTime(address token, uint time) external {
45 		lastWithdrawalTime[token] = time;
46 	}
47 	function setDailyCount(address token, uint count) external {
48 		dailyCount[token] = count;
49 	}
50 	 #FI */
51 
52 	function getDailyCount(address token) public view returns (uint) {
53 		var _dailyCount = dailyCount[token];
54 		if ((block.timestamp - lastWithdrawalTime[token]) >= 1 days)
55 			_dailyCount = 0;
56 		return _dailyCount;
57 	}
58 
59 	function getRemainingLimit(address token, address key)
60 			public view returns (uint) {
61 
62 		var pct = credentials[key];
63 		if (pct == 0)
64 			return 0;
65 
66 		var _dailyCount = getDailyCount(token);
67 		var balance = getBalance(token);
68 		var amt = ((balance + _dailyCount) * pct) / LIMIT_PRECISION;
69 		if (amt == 0 && balance > 0)
70 			amt = 1;
71 		if (_dailyCount >= amt)
72 			return 0;
73 		return amt - _dailyCount;
74 	}
75 
76 	function withdrawTo(
77 			address token,
78 			uint amount,
79 			address to,
80 			bytes signature) external {
81 
82 		require(amount > 0 && to != address(this));
83 		assert(block.timestamp >= lastWithdrawalTime[token]);
84 
85 		var limit = getSignatureRemainingLimit(
86 			signature,
87 			keccak256(address(this), token, nonce, amount, to),
88 			token);
89 
90 		require(limit >= amount);
91 		require(getBalance(token) >= amount);
92 
93 		dailyCount[token] = getDailyCount(token) + amount;
94 		lastWithdrawalTime[token] = block.timestamp;
95 		nonce++;
96 		_transfer(token, to, amount);
97 		OnWithdrawTo(token, msg.sender, to, amount, uint64(block.timestamp));
98 	}
99 
100 	function getBalance(address token) public view returns (uint) {
101 		if (token != 0x0) {
102 			// Token.
103 			return ERC20Token(token).balanceOf(address(this));
104 		}
105 		return this.balance;
106 	}
107 
108 	function _transfer(address token, address to, uint amount)
109 	 		private {
110 
111 		if (token != 0x0) {
112 			// Transfering a token.
113 			require(ERC20Token(token).transfer(to, amount));
114 			return;
115 		}
116 		to.transfer(amount);
117 	}
118 
119 	function getSignatureRemainingLimit(
120 			bytes signature,
121 			bytes32 payload,
122 			address token)
123 			private view returns (uint) {
124 
125 		var addr = extractSignatureAddress(signature, payload);
126 		return getRemainingLimit(token, addr);
127 	}
128 
129 	function extractSignatureAddress(bytes signature, bytes32 payload)
130 			private pure returns (address) {
131 
132 		payload = keccak256("\x19Ethereum Signed Message:\n32", payload);
133 		bytes32 r;
134 		bytes32 s;
135 		uint8 v;
136 		assembly {
137 			r := mload(add(signature, 32))
138 			s := mload(add(signature, 64))
139 			v := and(mload(add(signature, 65)), 255)
140 		}
141 		if (v < 27)
142 			v += 27;
143 		require(v == 27 || v == 28);
144 		return ecrecover(payload, v, r, s);
145 	}
146 
147 	function() public payable {}
148 }