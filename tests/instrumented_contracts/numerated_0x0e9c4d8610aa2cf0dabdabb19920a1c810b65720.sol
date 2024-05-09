1 pragma solidity ^0.4.2;
2 
3 contract owned {
4 	address public owner;
5 
6 	function owned() {
7 		owner = msg.sender;
8 	}
9 
10 	function changeOwner(address newOwner) onlyOwner {
11 		owner = newOwner;
12 	}
13 
14 	modifier onlyOwner {
15 		require(msg.sender == owner);
16 		_;
17 	}
18 }
19 
20 contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}
21 
22 contract CSToken is owned {
23 	struct Dividend {
24 		uint time;
25 		uint tenThousandth;
26 		bool isComplete;
27 	}
28 
29 	/* Public variables of the token */
30 	string public standard = 'Token 0.1';
31 
32 	string public name = 'KickCoin';
33 
34 	string public symbol = 'KC';
35 
36 	uint8 public decimals = 8;
37 
38 	uint256 public totalSupply = 0;
39 
40 	/* This creates an array with all balances */
41 	mapping (address => uint256) public balanceOf;
42 	mapping (address => uint256) public matureBalanceOf;
43 
44 	mapping (address => mapping (uint => uint256)) public agingBalanceOf;
45 
46 	uint[] agingTimes;
47 
48 	Dividend[] dividends;
49 
50 	mapping (address => mapping (address => uint256)) public allowance;
51 	/* This generates a public event on the blockchain that will notify clients */
52 	event Transfer(address indexed from, address indexed to, uint256 value);
53 	event AgingTransfer(address indexed from, address indexed to, uint256 value, uint agingTime);
54 
55 	uint countAddressIndexes = 0;
56 
57 	mapping (uint => address) addressByIndex;
58 
59 	mapping (address => uint) indexByAddress;
60 
61 	mapping (address => uint) agingTimesForPools;
62 
63 	/* Initializes contract with initial supply tokens to the creator of the contract */
64 	function CSToken() {
65 		owner = msg.sender;
66 		dividends.push(Dividend(1509454800, 300, false));
67 		dividends.push(Dividend(1512046800, 200, false));
68 		dividends.push(Dividend(1514725200, 100, false));
69 		dividends.push(Dividend(1517403600, 50, false));
70 		dividends.push(Dividend(1519822800, 100, false));
71 		dividends.push(Dividend(1522501200, 200, false));
72 		dividends.push(Dividend(1525093200, 300, false));
73 		dividends.push(Dividend(1527771600, 500, false));
74 		dividends.push(Dividend(1530363600, 300, false));
75 		dividends.push(Dividend(1533042000, 200, false));
76 		dividends.push(Dividend(1535720400, 100, false));
77 		dividends.push(Dividend(1538312400, 50, false));
78 		dividends.push(Dividend(1540990800, 100, false));
79 		dividends.push(Dividend(1543582800, 200, false));
80 		dividends.push(Dividend(1546261200, 300, false));
81 		dividends.push(Dividend(1548939600, 600, false));
82 		dividends.push(Dividend(1551358800, 300, false));
83 		dividends.push(Dividend(1554037200, 200, false));
84 		dividends.push(Dividend(1556629200, 100, false));
85 		dividends.push(Dividend(1559307600, 200, false));
86 		dividends.push(Dividend(1561899600, 300, false));
87 		dividends.push(Dividend(1564578000, 200, false));
88 		dividends.push(Dividend(1567256400, 100, false));
89 		dividends.push(Dividend(1569848400, 50, false));
90 
91 	}
92 
93 	function calculateDividends(uint which) {
94 		require(now >= dividends[which].time && !dividends[which].isComplete);
95 
96 		for (uint i = 1; i <= countAddressIndexes; i++) {
97 			balanceOf[addressByIndex[i]] += balanceOf[addressByIndex[i]] * dividends[which].tenThousandth / 10000;
98 			matureBalanceOf[addressByIndex[i]] += matureBalanceOf[addressByIndex[i]] * dividends[which].tenThousandth / 10000;
99 		}
100 	}
101 
102 	/* Send coins */
103 	function transfer(address _to, uint256 _value) {
104 		checkMyAging(msg.sender);
105 		require(matureBalanceOf[msg.sender] >= _value);
106 
107 		require(balanceOf[_to] + _value > balanceOf[_to]);
108 		require(matureBalanceOf[_to] + _value > matureBalanceOf[_to]);
109 		// Check for overflows
110 
111 		balanceOf[msg.sender] -= _value;
112 		matureBalanceOf[msg.sender] -= _value;
113 		// Subtract from the sender
114 
115 		if (agingTimesForPools[msg.sender] > 0 && agingTimesForPools[msg.sender] > now) {
116 			addToAging(msg.sender, _to, agingTimesForPools[msg.sender], _value);
117 		} else {
118 			matureBalanceOf[_to] += _value;
119 		}
120 		balanceOf[_to] += _value;
121 		Transfer(msg.sender, _to, _value);
122 	}
123 
124 	function mintToken(address target, uint256 mintedAmount, uint agingTime) onlyOwner {
125 		if (agingTime > now) {
126 			addToAging(owner, target, agingTime, mintedAmount);
127 		} else {
128 			matureBalanceOf[target] += mintedAmount;
129 		}
130 
131 		balanceOf[target] += mintedAmount;
132 
133 		totalSupply += mintedAmount;
134 		Transfer(0, owner, mintedAmount);
135 		Transfer(owner, target, mintedAmount);
136 	}
137 
138 	function addToAging(address from, address target, uint agingTime, uint256 amount) internal {
139 		if (indexByAddress[target] == 0) {
140 			indexByAddress[target] = 1;
141 			countAddressIndexes++;
142 			addressByIndex[countAddressIndexes] = target;
143 		}
144 		bool existTime = false;
145 		for (uint i = 0; i < agingTimes.length; i++) {
146 			if (agingTimes[i] == agingTime)
147 			existTime = true;
148 		}
149 		if (!existTime) agingTimes.push(agingTime);
150 		agingBalanceOf[target][agingTime] += amount;
151 		AgingTransfer(from, target, amount, agingTime);
152 	}
153 
154 	/* Allow another contract to spend some tokens in your behalf */
155 	function approve(address _spender, uint256 _value) returns (bool success) {
156 		allowance[msg.sender][_spender] = _value;
157 		return true;
158 	}
159 	/* Approve and then communicate the approved contract in a single tx */
160 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
161 		tokenRecipient spender = tokenRecipient(_spender);
162 		if (approve(_spender, _value)) {
163 			spender.receiveApproval(msg.sender, _value, this, _extraData);
164 			return true;
165 		}
166 	}
167 
168 	/* A contract attempts to get the coins */
169 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
170 		checkMyAging(_from);
171 		require(matureBalanceOf[_from] >= _value);
172 		// Check if the sender has enough
173 		assert(balanceOf[_to] + _value > balanceOf[_to]);
174 		assert(matureBalanceOf[_to] + _value > matureBalanceOf[_to]);
175 		// Check for overflows
176 		require(_value <= allowance[_from][msg.sender]);
177 		// Check allowance
178 		balanceOf[_from] -= _value;
179 		matureBalanceOf[_from] -= _value;
180 		// Subtract from the sender
181 		balanceOf[_to] += _value;
182 		// Add the same to the recipient
183 		allowance[_from][msg.sender] -= _value;
184 
185 		if (agingTimesForPools[_from] > 0 && agingTimesForPools[_from] > now) {
186 			addToAging(_from, _to, agingTimesForPools[_from], _value);
187 		} else {
188 			matureBalanceOf[_to] += _value;
189 		}
190 
191 		Transfer(_from, _to, _value);
192 		return true;
193 	}
194 
195 	/* This unnamed function is called whenever someone tries to send ether to it */
196 	function() {
197 		revert();
198 		// Prevents accidental sending of ether
199 	}
200 
201 	function checkMyAging(address sender) internal {
202 		for (uint k = 0; k < agingTimes.length; k++) {
203 			if (agingTimes[k] < now && agingBalanceOf[sender][agingTimes[k]] > 0) {
204 				for(uint256 i = 0; i < 24; i++) {
205 					if(now < dividends[i].time) break;
206 					if(!dividends[i].isComplete) break;
207 					agingBalanceOf[sender][agingTimes[k]] += agingBalanceOf[sender][agingTimes[k]] * dividends[i].tenThousandth / 10000;
208 				}
209 				matureBalanceOf[sender] += agingBalanceOf[sender][agingTimes[k]];
210 				agingBalanceOf[sender][agingTimes[k]] = 0;
211 			}
212 		}
213 	}
214 
215 	function addAgingTimesForPool(address poolAddress, uint agingTime) onlyOwner {
216 		agingTimesForPools[poolAddress] = agingTime;
217 	}
218 }