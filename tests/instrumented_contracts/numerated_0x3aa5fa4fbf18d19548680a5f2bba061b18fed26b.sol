1 pragma solidity ^0.4.2;
2 
3 
4 contract owned {
5 	address public owner;
6 	address public server;
7 
8 	function owned() {
9 		owner = msg.sender;
10 		server = msg.sender;
11 	}
12 
13 	function changeOwner(address newOwner) onlyOwner {
14 		owner = newOwner;
15 	}
16 
17 	function changeServer(address newServer) onlyOwner {
18 		server = newServer;
19 	}
20 
21 	modifier onlyOwner {
22 		require(msg.sender == owner);
23 		_;
24 	}
25 
26 	modifier onlyServer {
27 		require(msg.sender == server);
28 		_;
29 	}
30 }
31 
32 
33 contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}
34 
35 
36 contract CSToken is owned {uint8 public decimals;
37 
38 	uint[] public agingTimes;
39 
40 	address[] public addressByIndex;
41 
42 	function balanceOf(address _owner) constant returns (uint256 balance);
43 
44 	function mintToken(address target, uint256 mintedAmount, uint agingTime);
45 
46 	function addAgingTime(uint time);
47 
48 	function allAgingTimesAdded();
49 
50 	function addAgingTimesForPool(address poolAddress, uint agingTime);
51 
52 	function countAddresses() constant returns (uint256 length);
53 }
54 
55 
56 contract KickicoCrowdsale is owned {
57 	uint[] public IcoStagePeriod;
58 
59 	bool public IcoClosedManually = false;
60 
61 	uint public threshold = 160000 ether;
62 	uint public goal = 15500 ether;
63 
64 	uint public totalCollected = 0;
65 
66 	uint public pricePerTokenInWei = 3333333;
67 
68 	uint public agingTime = 1539594000;
69 
70 	uint prPoolAgingTime = 1513242000;
71 
72 	uint advisoryPoolAgingTime = 1535533200;
73 
74 	uint bountiesPoolAgingTime = 1510736400;
75 
76 	uint lotteryPoolAgingTime = 1512118800;
77 
78 	uint angelInvestorsPoolAgingTime = 1506848400;
79 
80 	uint foundersPoolAgingTime = 1535533200;
81 
82 	uint chinaPoolAgingTime = 1509526800;
83 
84 	uint[] public bonuses;
85 
86 	uint[] public bonusesAfterClose;
87 
88 	address public prPool;
89 
90 	address public founders;
91 
92 	address public advisory;
93 
94 	address public bounties;
95 
96 	address public lottery;
97 
98 	address public angelInvestors;
99 
100 	address public china;
101 
102 	uint tokenMultiplier = 10;
103 
104 	CSToken public tokenReward;
105 	CSToken public oldTokenReward;
106 
107 	mapping (address => uint256) public balanceOf;
108 
109 	event FundTransfer(address backer, uint amount, bool isContribution);
110 
111 	bool parametersHaveBeenSet = false;
112 
113 	function KickicoCrowdsale(address _tokenAddress, address _prPool, address _founders, address _advisory, address _bounties, address _lottery, address _angelInvestors, address _china, address _oldTokenAddress) {
114 		tokenReward = CSToken(_tokenAddress);
115 		oldTokenReward = CSToken(_oldTokenAddress);
116 
117 		tokenMultiplier = tokenMultiplier ** tokenReward.decimals();
118 
119 		// bind pools
120 		prPool = _prPool;
121 		founders = _founders;
122 		advisory = _advisory;
123 		bounties = _bounties;
124 		lottery = _lottery;
125 		angelInvestors = _angelInvestors;
126 		china = _china;
127 	}
128 
129 	function setParams() onlyOwner {
130 		require(!parametersHaveBeenSet);
131 
132 		parametersHaveBeenSet = true;
133 
134 		tokenReward.addAgingTimesForPool(prPool, prPoolAgingTime);
135 		tokenReward.addAgingTimesForPool(advisory, advisoryPoolAgingTime);
136 		tokenReward.addAgingTimesForPool(bounties, bountiesPoolAgingTime);
137 		tokenReward.addAgingTimesForPool(lottery, lotteryPoolAgingTime);
138 		tokenReward.addAgingTimesForPool(angelInvestors, angelInvestorsPoolAgingTime);
139 
140 		// mint to pools
141 		tokenReward.mintToken(advisory, 10000000 * tokenMultiplier, 0);
142 		tokenReward.mintToken(bounties, 25000000 * tokenMultiplier, 0);
143 		tokenReward.mintToken(lottery, 1000000 * tokenMultiplier, 0);
144 		tokenReward.mintToken(angelInvestors, 30000000 * tokenMultiplier, 0);
145 		tokenReward.mintToken(prPool, 23000000 * tokenMultiplier, 0);
146 		tokenReward.mintToken(china, 8000000 * tokenMultiplier, 0);
147 		tokenReward.mintToken(founders, 5000000 * tokenMultiplier, 0);
148 
149 		tokenReward.addAgingTime(agingTime);
150 		tokenReward.addAgingTime(prPoolAgingTime);
151 		tokenReward.addAgingTime(advisoryPoolAgingTime);
152 		tokenReward.addAgingTime(bountiesPoolAgingTime);
153 		tokenReward.addAgingTime(lotteryPoolAgingTime);
154 		tokenReward.addAgingTime(angelInvestorsPoolAgingTime);
155 		tokenReward.addAgingTime(foundersPoolAgingTime);
156 		tokenReward.addAgingTime(chinaPoolAgingTime);
157 		tokenReward.allAgingTimesAdded();
158 
159 		IcoStagePeriod.push(1504011600);
160 		IcoStagePeriod.push(1506718800);
161 
162 		bonuses.push(1990 finney);
163 		bonuses.push(2990 finney);
164 		bonuses.push(4990 finney);
165 		bonuses.push(6990 finney);
166 		bonuses.push(9500 finney);
167 		bonuses.push(14500 finney);
168 		bonuses.push(19500 finney);
169 		bonuses.push(29500 finney);
170 		bonuses.push(49500 finney);
171 		bonuses.push(74500 finney);
172 		bonuses.push(99 ether);
173 		bonuses.push(149 ether);
174 		bonuses.push(199 ether);
175 		bonuses.push(299 ether);
176 		bonuses.push(499 ether);
177 		bonuses.push(749 ether);
178 		bonuses.push(999 ether);
179 		bonuses.push(1499 ether);
180 		bonuses.push(1999 ether);
181 		bonuses.push(2999 ether);
182 		bonuses.push(4999 ether);
183 		bonuses.push(7499 ether);
184 		bonuses.push(9999 ether);
185 		bonuses.push(14999 ether);
186 		bonuses.push(19999 ether);
187 		bonuses.push(49999 ether);
188 		bonuses.push(99999 ether);
189 
190 		bonusesAfterClose.push(200);
191 		bonusesAfterClose.push(100);
192 		bonusesAfterClose.push(75);
193 		bonusesAfterClose.push(50);
194 		bonusesAfterClose.push(25);
195 	}
196 
197 	function mint(uint amount, uint tokens, address sender) internal {
198 		balanceOf[sender] += amount;
199 		totalCollected += amount;
200 		tokenReward.mintToken(sender, tokens, agingTime);
201 		tokenReward.mintToken(founders, tokens / 10, foundersPoolAgingTime);
202 	}
203 
204 	function contractBalance() constant returns (uint256 balance) {
205 		return this.balance;
206 	}
207 
208 	function processPayment(address from, uint amount, bool isCustom) internal {
209 		if(!isCustom)
210 		FundTransfer(from, amount, true);
211 		uint original = amount;
212 
213 		uint _price = pricePerTokenInWei;
214 		uint remain = threshold - totalCollected;
215 		if (remain < amount) {
216 			amount = remain;
217 		}
218 
219 		for (uint i = 0; i < bonuses.length; i++) {
220 			if (amount < bonuses[i]) break;
221 
222 			if (amount >= bonuses[i] && (i == bonuses.length - 1 || amount < bonuses[i + 1])) {
223 				if (i < 15) {
224 					_price = _price * 1000 / (1000 + ((i + 1 + (i > 11 ? 1 : 0)) * 5));
225 				}
226 				else {
227 					_price = _price * 1000 / (1000 + ((8 + i - 14) * 10));
228 				}
229 			}
230 		}
231 
232 		uint tokenAmount = amount / _price;
233 		uint currentAmount = tokenAmount * _price;
234 		mint(currentAmount, tokenAmount + tokenAmount * getBonusByRaised() / 1000, from);
235 		uint change = original - currentAmount;
236 		if (change > 0 && !isCustom) {
237 			if (from.send(change)) {
238 				FundTransfer(from, change, false);
239 			}
240 			else revert();
241 		}
242 	}
243 
244 	function getBonusByRaised() internal returns (uint256) {
245 		return 0;
246 	}
247 
248 	function closeICO() onlyOwner {
249 		require(now >= IcoStagePeriod[0] && now < IcoStagePeriod[1] && !IcoClosedManually);
250 		IcoClosedManually = true;
251 	}
252 
253 	function safeWithdrawal(uint amount) onlyOwner {
254 		require(this.balance >= amount);
255 
256 		// lock withdraw if stage not closed
257 		if (now >= IcoStagePeriod[0] && now < IcoStagePeriod[1])
258 		require(IcoClosedManually || isReachedThreshold());
259 
260 		if (owner.send(amount)) {
261 			FundTransfer(msg.sender, amount, false);
262 		}
263 	}
264 
265 	function isReachedThreshold() internal returns (bool reached) {
266 		return pricePerTokenInWei > (threshold - totalCollected);
267 	}
268 
269 	function isIcoClosed() constant returns (bool closed) {
270 		return (now >= IcoStagePeriod[1] || IcoClosedManually || isReachedThreshold());
271 	}
272 
273 	bool public allowManuallyMintTokens = true;
274 	function mintTokens(address[] recipients) onlyServer {
275 		require(allowManuallyMintTokens);
276 		for(uint i = 0; i < recipients.length; i++) {
277 			tokenReward.mintToken(recipients[i], oldTokenReward.balanceOf(recipients[i]), 1538902800);
278 		}
279 	}
280 
281 	function disableManuallyMintTokens() onlyOwner {
282 		allowManuallyMintTokens = false;
283 	}
284 
285 	function() payable {
286 		require(parametersHaveBeenSet);
287 		require(msg.value >= 50 finney);
288 
289 		// validate by stage periods
290 		require(now >= IcoStagePeriod[0] && now < IcoStagePeriod[1]);
291 		// validate if closed manually or reached the threshold
292 		require(!IcoClosedManually);
293 		require(!isReachedThreshold());
294 
295 		processPayment(msg.sender, msg.value, false);
296 	}
297 
298 	function changeTokenOwner(address _owner) onlyOwner {
299 		tokenReward.changeOwner(_owner);
300 	}
301 
302 	function changeOldTokenReward(address _token) onlyOwner {
303 		oldTokenReward = CSToken(_token);
304 	}
305 
306 	function kill() onlyOwner {
307 		require(isIcoClosed());
308 		if(this.balance > 0) {
309 			owner.transfer(this.balance);
310 		}
311 		changeTokenOwner(owner);
312 		selfdestruct(owner);
313 	}
314 }