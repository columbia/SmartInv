1 pragma solidity ^0.4.17;
2 
3 contract MultiKeyDailyLimitWallet {
4 	uint constant LIMIT_PRECISION = 1000000;
5 	// Fractional daily limits per key. In units of 1/LIMIT_PRECISION.
6 	mapping(address=>uint) public credentials;
7 	// Timestamp of last withdrawal.
8 	uint public lastWithdrawalTime;
9 	// Total withdrawn in last 24-hours. Resets if 24 hours passes with no activity.
10 	uint public dailyCount;
11 	uint public nonce;
12 
13 	event OnWithdrawTo(address indexed from, address indexed to, uint amount,
14 		uint64 timestamp);
15 
16 	function MultiKeyDailyLimitWallet(address[] keys, uint[] limits) public {
17 		require(keys.length == limits.length);
18 		for (uint i = 0; i < keys.length; i++) {
19 			var limit = limits[i];
20 			// limit should be in range 1-LIMIT_PRECISION
21 			require (limit > 0 && limit <= LIMIT_PRECISION);
22 			credentials[keys[i]] = limit;
23 		}
24 	}
25 
26 	/* #IF TESTING
27 	function setLastWithdrawalTime(uint time) public {
28 		lastWithdrawalTime = time;
29 	}
30 	function setDailyCount(uint count) public {
31 		dailyCount = count;
32 	}
33 	function setNonce(uint _nonce) public {
34 		nonce = _nonce;
35 	}
36 	 #FI */
37 
38 	function getRemainingLimit(address key) public view returns (uint) {
39 		var pct = credentials[key];
40 		if (pct == 0)
41 			return 0;
42 
43 		var _dailyCount = dailyCount;
44 		if ((block.timestamp - lastWithdrawalTime) >= 1 days)
45 			_dailyCount = 0;
46 
47 		var amt = ((this.balance + _dailyCount) * pct) / LIMIT_PRECISION;
48 		if (amt == 0 && this.balance > 0)
49 			amt = 1;
50 		if (_dailyCount >= amt)
51 			return 0;
52 		return amt - _dailyCount;
53 	}
54 
55 	function withdrawTo(uint amount, address to, bytes signature) public {
56 		require(amount > 0 && to != address(this));
57 		assert(block.timestamp >= lastWithdrawalTime);
58 
59 		var limit = getSignatureRemainingLimit(signature,
60 			keccak256(address(this), nonce, amount, to));
61 		require(limit >= amount);
62 		require(this.balance >= amount);
63 
64 		// Reset daily count if it's been more than a day since last withdrawal.
65 		if ((block.timestamp - lastWithdrawalTime) >= 1 days)
66 			dailyCount = 0;
67 
68 		lastWithdrawalTime = block.timestamp;
69 		dailyCount += amount;
70 		nonce++;
71 		to.transfer(amount);
72 		OnWithdrawTo(msg.sender, to, amount, uint64(block.timestamp));
73 	}
74 
75 	function getSignatureRemainingLimit(bytes signature, bytes32 payload)
76 			private view returns (uint) {
77 
78 		var addr = extractSignatureAddress(signature, payload);
79 		return getRemainingLimit(addr);
80 	}
81 
82 	function extractSignatureAddress(bytes signature, bytes32 payload)
83 			private pure returns (address) {
84 
85 		payload = keccak256("\x19Ethereum Signed Message:\n32", payload);
86 		bytes32 r;
87 		bytes32 s;
88 		uint8 v;
89 		assembly {
90 			r := mload(add(signature, 32))
91 			s := mload(add(signature, 64))
92 			v := and(mload(add(signature, 65)), 255)
93 		}
94 		if (v < 27)
95 			v += 27;
96 		require(v == 27 || v == 28);
97 		return ecrecover(payload, v, r, s);
98 	}
99 
100 	function() public payable {}
101 }