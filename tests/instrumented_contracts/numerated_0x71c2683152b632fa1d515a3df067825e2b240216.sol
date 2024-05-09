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
21 contract CSToken is owned {uint8 public decimals;function mintToken(address target, uint256 mintedAmount, uint agingTime);function addAgingTimesForPool(address poolAddress, uint agingTime);}
22 
23 contract KICKICOCrowdsale is owned {
24 	uint[] public preIcoStagePeriod;
25 
26 	uint[] public IcoStagePeriod;
27 
28 	bool public PreIcoClosedManually = false;
29 
30 	bool public IcoClosedManually = false;
31 
32 	uint[] public thresholdsByState;
33 
34 	uint public totalCollected = 0;
35 
36 	uint public allowedForWithdrawn = 0;
37 
38 	uint[] public prices;
39 
40 	uint[] public bonuses;
41 
42 	address public prPool;
43 
44 	address public founders;
45 
46 	address public advisory;
47 
48 	address public bounties;
49 
50 	address public lottery;
51 
52 	address public seedInvestors;
53 
54 	uint public tokensRaised;
55 
56 	uint[] public etherRaisedByState;
57 
58 	uint tokenMultiplier = 10;
59 
60 	CSToken public tokenReward;
61 
62 	mapping (address => uint256) public balanceOf;
63 
64 	event FundTransfer(address backer, uint amount, bool isContribution);
65 
66 	uint[] public agingTimeByStage;
67 
68 	bool parametersHaveBeenSet = false;
69 
70 	function KICKICOCrowdsale(address _tokenAddress, address _prPool, address _founders, address _advisory, address _bounties, address _lottery, address _seedInvestors) {
71 		tokenReward = CSToken(_tokenAddress);
72 
73 		tokenMultiplier = tokenMultiplier ** tokenReward.decimals();
74 
75 		// bind pools
76 		prPool = _prPool;
77 		founders = _founders;
78 		advisory = _advisory;
79 		bounties = _bounties;
80 		lottery = _lottery;
81 		seedInvestors = _seedInvestors;
82 	}
83 
84 	function setParams() onlyOwner {
85 		require(!parametersHaveBeenSet);
86 
87 		parametersHaveBeenSet = true;
88 
89 		tokenReward.addAgingTimesForPool(prPool, 1513242000);
90 		tokenReward.addAgingTimesForPool(advisory, 1507366800);
91 		tokenReward.addAgingTimesForPool(bounties, 1509526800);
92 		tokenReward.addAgingTimesForPool(lottery, 1512118800);
93 		tokenReward.addAgingTimesForPool(seedInvestors, 1506762000);
94 
95 		// mint to pools
96 		tokenReward.mintToken(founders, 100000000 * tokenMultiplier, 1514797200);
97 		tokenReward.mintToken(advisory, 10000000 * tokenMultiplier, 0);
98 		tokenReward.mintToken(bounties, 25000000 * tokenMultiplier, 0);
99 		tokenReward.mintToken(lottery, 2000000 * tokenMultiplier, 0);
100 		tokenReward.mintToken(seedInvestors, 20000000 * tokenMultiplier, 0);
101 		tokenReward.mintToken(prPool, 23000000 * tokenMultiplier, 0);
102 
103 		preIcoStagePeriod.push(1501246800);
104 		preIcoStagePeriod.push(1502744400);
105 
106 		IcoStagePeriod.push(1504011600);
107 		IcoStagePeriod.push(1506718800);
108 
109 		// bind maxs thresholds
110 		thresholdsByState.push(5000 ether);
111 		thresholdsByState.push(200000 ether);
112 
113 		etherRaisedByState.push(0);
114 		etherRaisedByState.push(0);
115 
116 		// bind aging time for each stages
117 		agingTimeByStage.push(1507366800);
118 		agingTimeByStage.push(1508058000);
119 
120 		// bind prices
121 		prices.push(1666666);
122 		prices.push(3333333);
123 
124 		bonuses.push(1990 finney);
125 		bonuses.push(2990 finney);
126 		bonuses.push(4990 finney);
127 		bonuses.push(6990 finney);
128 		bonuses.push(9500 finney);
129 		bonuses.push(14500 finney);
130 		bonuses.push(19500 finney);
131 		bonuses.push(29500 finney);
132 		bonuses.push(49500 finney);
133 		bonuses.push(74500 finney);
134 		bonuses.push(99 ether);
135 		bonuses.push(149 ether);
136 		bonuses.push(199 ether);
137 		bonuses.push(299 ether);
138 		bonuses.push(499 ether);
139 		bonuses.push(749 ether);
140 		bonuses.push(999 ether);
141 		bonuses.push(1499 ether);
142 		bonuses.push(1999 ether);
143 		bonuses.push(2999 ether);
144 		bonuses.push(4999 ether);
145 		bonuses.push(7499 ether);
146 		bonuses.push(9999 ether);
147 		bonuses.push(14999 ether);
148 		bonuses.push(19999 ether);
149 		bonuses.push(49999 ether);
150 		bonuses.push(99999 ether);
151 	}
152 
153 	function mint(uint amount, uint tokens, address sender, uint currentStage) internal {
154 		balanceOf[sender] += amount;
155 		tokensRaised += tokens;
156 		etherRaisedByState[currentStage] += amount;
157 		totalCollected += amount;
158 		allowedForWithdrawn += amount;
159 		tokenReward.mintToken(sender, tokens, agingTimeByStage[currentStage]);
160 		tokenReward.mintToken(prPool, tokens * 10 / 100, 0);
161 	}
162 
163 	function processPayment(address from, uint amount) internal {
164 		uint originalAmount = amount;
165 		FundTransfer(from, amount, true);
166 		uint currentStage = 0;
167 		if (now >= preIcoStagePeriod[0] && now < preIcoStagePeriod[1]) {
168 			currentStage = 0;
169 		}
170 		if (now >= IcoStagePeriod[0] && now < IcoStagePeriod[1]) {
171 			currentStage = 1;
172 		}
173 
174 		uint price = prices[currentStage];
175 		uint coefficient = 1000;
176 
177 		for (uint i = 0; i < 15; i++) {
178 			if (amount >= bonuses[i])
179 				coefficient = 1000 + ((i + 1 + (i > 11 ? 1 : 0)) * 5);
180 			if (amount < bonuses[i]) break;
181 		}
182 		if (coefficient == 1000) {
183 			for (uint z = 0; z < 12; z++) {
184 				if (amount >= bonuses[z + 15])
185 					coefficient = 1000 + ((8 + z) * 10);
186 				if (amount < bonuses[z]) break;
187 			}
188 		}
189 
190 		price = price * 1000 / coefficient;
191 
192 		uint remain = thresholdsByState[currentStage] - etherRaisedByState[currentStage];
193 
194 		if (remain <= amount) {
195 			amount = remain;
196 		}
197 
198 		uint tokenAmount = amount / price;
199 
200 		uint currentAmount = tokenAmount * price;
201 		mint(currentAmount, tokenAmount, from, currentStage);
202 		uint change = originalAmount - currentAmount;
203 		if (change > 0) {
204 			if (from.send(change)) {
205 				FundTransfer(from, change, false);
206 			}
207 			else revert();
208 		}
209 	}
210 
211 	function() payable {
212 		require(parametersHaveBeenSet);
213 		require(msg.value >= 50 finney);
214 
215 		// validate by stage periods
216 		require((now >= preIcoStagePeriod[0] && now < preIcoStagePeriod[1]) || (now >= IcoStagePeriod[0] && now < IcoStagePeriod[1]));
217 		// validate if closed manually or reached the threshold
218 		if(now >= preIcoStagePeriod[0] && now < preIcoStagePeriod[1]) {
219 			require(!PreIcoClosedManually && etherRaisedByState[0] < thresholdsByState[0]);
220 		} else {
221 			require(!IcoClosedManually && etherRaisedByState[1] < thresholdsByState[1]);
222 		}
223 		processPayment(msg.sender, msg.value);
224 	}
225 
226 	function closeCurrentStage() onlyOwner {
227 		if (now >= preIcoStagePeriod[0] && now < preIcoStagePeriod[1] && !PreIcoClosedManually) {
228 			PreIcoClosedManually = true;
229 		} else {
230 			if (now >= IcoStagePeriod[0] && now < IcoStagePeriod[1] && !IcoClosedManually) {
231 				IcoClosedManually = true;
232 			} else {
233 				revert();
234 			}
235 		}
236 	}
237 
238 	function safeWithdrawal(uint amount) onlyOwner {
239 		require(allowedForWithdrawn >= amount);
240 
241 		// lock withdraw if stage not closed
242 //		require((now >= preIcoStagePeriod[1] && now < IcoStagePeriod[0]) || (now >= IcoStagePeriod[1]));
243 		if(now >= preIcoStagePeriod[0] && now < preIcoStagePeriod[1])
244 			require(PreIcoClosedManually || etherRaisedByState[0] >= thresholdsByState[0]);
245 		if(now >= IcoStagePeriod[0] && now < IcoStagePeriod[1])
246 			require(IcoClosedManually || etherRaisedByState[1] >= thresholdsByState[1]);
247 
248 		allowedForWithdrawn -= amount;
249 		if(owner.send(amount)) {
250 			FundTransfer(msg.sender, amount, false);
251 		} else {
252 			allowedForWithdrawn += amount;
253 		}
254 	}
255 
256 	function kill() onlyOwner {
257 		require(now > IcoStagePeriod[1]);
258 
259 		tokenReward.changeOwner(owner);
260 		selfdestruct(owner);
261 	}
262 }