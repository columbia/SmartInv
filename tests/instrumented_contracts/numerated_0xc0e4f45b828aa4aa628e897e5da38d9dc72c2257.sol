1 pragma solidity ^0.4.2;
2 
3 
4 contract owned {
5 	address public owner;
6 
7 	function owned() {
8 		owner = msg.sender;
9 	}
10 
11 	function changeOwner(address newOwner) onlyOwner {
12 		owner = newOwner;
13 	}
14 
15 	modifier onlyOwner {
16 		require(msg.sender == owner);
17 		_;
18 	}
19 }
20 
21 
22 contract tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}
23 
24 
25 contract Utils {
26 	/**
27 		constructor
28 	*/
29 	function Utils() {
30 	}
31 
32 	// validates an address - currently only checks that it isn't null
33 	modifier validAddress(address _address) {
34 		require(_address != 0x0);
35 		_;
36 	}
37 
38 	// verifies that the address is different than this contract address
39 	modifier notThis(address _address) {
40 		require(_address != address(this));
41 		_;
42 	}
43 
44 	// Overflow protected math functions
45 
46 	/**
47 		@dev returns the sum of _x and _y, asserts if the calculation overflows
48 
49 		@param _x   value 1
50 		@param _y   value 2
51 
52 		@return sum
53 	*/
54 	function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
55 		uint256 z = _x + _y;
56 		assert(z >= _x);
57 		return z;
58 	}
59 
60 	/**
61 		@dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
62 
63 		@param _x   minuend
64 		@param _y   subtrahend
65 
66 		@return difference
67 	*/
68 	function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
69 		assert(_x >= _y);
70 		return _x - _y;
71 	}
72 }
73 
74 
75 contract CSToken is owned, Utils {
76 	struct Dividend {uint256 time; uint256 tenThousandth; uint256 countComplete;}
77 
78 	/* Public variables of the token */
79 	string public standard = 'Token 0.1';
80 
81 	string public name = 'KickCoin';
82 
83 	string public symbol = 'KC';
84 
85 	uint8 public decimals = 8;
86 
87 	uint256 _totalSupply = 0;
88 
89 	/* This creates an array with all balances */
90 	mapping (address => uint256) balances;
91 
92 	mapping (address => mapping (uint256 => uint256)) public agingBalanceOf;
93 
94 	uint[] agingTimes;
95 
96 	Dividend[] dividends;
97 
98 	mapping (address => mapping (address => uint256)) allowed;
99 	/* This generates a public event on the blockchain that will notify clients */
100 	event Transfer(address indexed from, address indexed to, uint256 value);
101 
102 	event AgingTransfer(address indexed from, address indexed to, uint256 value, uint256 agingTime);
103 
104 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 	// triggered when the total supply is increased
106 	event Issuance(uint256 _amount);
107 	// triggered when the total supply is decreased
108 	event Destruction(uint256 _amount);
109 
110 	address[] public addressByIndex;
111 
112 	mapping (address => bool) addressAddedToIndex;
113 
114 	mapping (address => uint) agingTimesForPools;
115 
116 	uint16 currentDividendIndex = 1;
117 
118 	mapping (address => uint) calculatedDividendsIndex;
119 
120 	bool public transfersEnabled = true;
121 
122 	event NewSmartToken(address _token);
123 
124 	/* Initializes contract with initial supply tokens to the creator of the contract */
125 	function CSToken() {
126 		owner = msg.sender;
127 		// So that the index starts with 1
128 		dividends.push(Dividend(0, 0, 0));
129 		// 31.10.2017 09:00:00
130 		dividends.push(Dividend(1509440400, 30, 0));
131 		// 30.11.2017 09:00:00
132 		dividends.push(Dividend(1512032400, 20, 0));
133 		// 31.12.2017 09:00:00
134 		dividends.push(Dividend(1514710800, 10, 0));
135 		// 31.01.2018 09:00:00
136 		dividends.push(Dividend(1517389200, 5, 0));
137 		// 28.02.2018 09:00:00
138 		dividends.push(Dividend(1519808400, 10, 0));
139 		// 31.03.2018 09:00:00
140 		dividends.push(Dividend(1522486800, 20, 0));
141 		// 30.04.2018 09:00:00
142 		dividends.push(Dividend(1525078800, 30, 0));
143 		// 31.05.2018 09:00:00
144 		dividends.push(Dividend(1527757200, 50, 0));
145 		// 30.06.2018 09:00:00
146 		dividends.push(Dividend(1530349200, 30, 0));
147 		// 31.07.2018 09:00:00
148 		dividends.push(Dividend(1533027600, 20, 0));
149 		// 31.08.2018 09:00:00
150 		dividends.push(Dividend(1535706000, 10, 0));
151 		// 30.09.2018 09:00:00
152 		dividends.push(Dividend(1538298000, 5, 0));
153 		// 31.10.2018 09:00:00
154 		dividends.push(Dividend(1540976400, 10, 0));
155 		// 30.11.2018 09:00:00
156 		dividends.push(Dividend(1543568400, 20, 0));
157 		// 31.12.2018 09:00:00
158 		dividends.push(Dividend(1546246800, 30, 0));
159 		// 31.01.2019 09:00:00
160 		dividends.push(Dividend(1548925200, 60, 0));
161 		// 28.02.2019 09:00:00
162 		dividends.push(Dividend(1551344400, 30, 0));
163 		// 31.03.2019 09:00:00
164 		dividends.push(Dividend(1554022800, 20, 0));
165 		// 30.04.2019 09:00:00
166 		dividends.push(Dividend(1556614800, 10, 0));
167 		// 31.05.2019 09:00:00
168 		dividends.push(Dividend(1559307600, 20, 0));
169 		// 30.06.2019 09:00:00
170 		dividends.push(Dividend(1561885200, 30, 0));
171 		// 31.07.2019 09:00:00
172 		dividends.push(Dividend(1564563600, 20, 0));
173 		// 31.08.2019 09:00:00
174 		dividends.push(Dividend(1567242000, 10, 0));
175 		// 30.09.2019 09:00:00
176 		dividends.push(Dividend(1569834000, 5, 0));
177 
178 		NewSmartToken(address(this));
179 	}
180 
181 	modifier transfersAllowed {
182 		assert(transfersEnabled);
183 		_;
184 	}
185 
186 	function totalSupply() constant returns (uint256 totalSupply) {
187 		totalSupply = _totalSupply;
188 	}
189 
190 	function balanceOf(address _owner) constant returns (uint256 balance) {
191 		return balances[_owner];
192 	}
193 
194 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
195 		return allowed[_owner][_spender];
196 	}
197 
198 	bool allAgingTimesHasBeenAdded = false;
199 	function addAgingTime(uint256 time) onlyOwner {
200 		require(!allAgingTimesHasBeenAdded);
201 		agingTimes.push(time);
202 	}
203 
204 	function allAgingTimesAdded() onlyOwner {
205 		allAgingTimesHasBeenAdded = true;
206 	}
207 
208 	function calculateDividends(uint256 limit) {
209 		require(now >= dividends[currentDividendIndex].time);
210 		require(limit > 0);
211 
212 		limit = dividends[currentDividendIndex].countComplete + limit;
213 
214 		if (limit > addressByIndex.length) {
215 			limit = addressByIndex.length;
216 		}
217 
218 		for (uint256 i = dividends[currentDividendIndex].countComplete; i < limit; i++) {
219 			addDividendsForAddress(addressByIndex[i]);
220 		}
221 		if (limit == addressByIndex.length) {
222 			currentDividendIndex++;
223 		}
224 		else {
225 			dividends[currentDividendIndex].countComplete = limit;
226 		}
227 	}
228 
229 	function addDividendsForAddress(address _address) internal {
230 		// skip calculating dividends, if already calculated for this address
231 		if (calculatedDividendsIndex[_address] >= currentDividendIndex) return;
232 
233 		uint256 add = balances[_address] * dividends[currentDividendIndex].tenThousandth / 1000;
234 		balances[_address] += add;
235 		Transfer(this, _address, add);
236 		Issuance(add);
237 		_totalSupply = safeAdd(_totalSupply, add);
238 
239 		if (agingBalanceOf[_address][0] > 0) {
240 			agingBalanceOf[_address][0] += agingBalanceOf[_address][0] * dividends[currentDividendIndex].tenThousandth / 1000;
241 			for (uint256 k = 0; k < agingTimes.length; k++) {
242 				agingBalanceOf[_address][agingTimes[k]] += agingBalanceOf[_address][agingTimes[k]] * dividends[currentDividendIndex].tenThousandth / 1000;
243 			}
244 		}
245 		calculatedDividendsIndex[_address] = currentDividendIndex;
246 	}
247 
248 	/* Send coins */
249 	function transfer(address _to, uint256 _value) transfersAllowed returns (bool success) {
250 		checkMyAging(msg.sender);
251 		if (now >= dividends[currentDividendIndex].time) {
252 			addDividendsForAddress(msg.sender);
253 			addDividendsForAddress(_to);
254 		}
255 
256 		require(accountBalance(msg.sender) >= _value);
257 
258 		// Subtract from the sender
259 		balances[msg.sender] -= _value;
260 
261 		if (agingTimesForPools[msg.sender] > 0 && agingTimesForPools[msg.sender] > now) {
262 			addToAging(msg.sender, _to, agingTimesForPools[msg.sender], _value);
263 		}
264 
265 		balances[_to] = safeAdd(balances[_to], _value);
266 
267 		addIndex(_to);
268 		Transfer(msg.sender, _to, _value);
269 		return true;
270 	}
271 
272 	function mintToken(address target, uint256 mintedAmount, uint256 agingTime) onlyOwner {
273 		if (agingTime > now) {
274 			addToAging(owner, target, agingTime, mintedAmount);
275 		}
276 
277 		balances[target] += mintedAmount;
278 
279 		_totalSupply += mintedAmount;
280 		Issuance(mintedAmount);
281 		addIndex(target);
282 		Transfer(this, target, mintedAmount);
283 	}
284 
285 	function addIndex(address _address) internal {
286 		if (!addressAddedToIndex[_address]) {
287 			addressAddedToIndex[_address] = true;
288 			addressByIndex.push(_address);
289 		}
290 	}
291 
292 	function addToAging(address from, address target, uint256 agingTime, uint256 amount) internal {
293 		agingBalanceOf[target][0] += amount;
294 		agingBalanceOf[target][agingTime] += amount;
295 		AgingTransfer(from, target, amount, agingTime);
296 	}
297 
298 	/* Allow another contract to spend some tokens in your behalf */
299 	function approve(address _spender, uint256 _value) returns (bool success) {
300 		allowed[msg.sender][_spender] = _value;
301 		Approval(msg.sender, _spender, _value);
302 		return true;
303 	}
304 
305 	/* Approve and then communicate the approved contract in a single tx */
306 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
307 		tokenRecipient spender = tokenRecipient(_spender);
308 		if (approve(_spender, _value)) {
309 			spender.receiveApproval(msg.sender, _value, this, _extraData);
310 			return true;
311 		}
312 	}
313 
314 	/* A contract attempts to get the coins */
315 	function transferFrom(address _from, address _to, uint256 _value) transfersAllowed returns (bool success) {
316 		checkMyAging(_from);
317 		if (now >= dividends[currentDividendIndex].time) {
318 			addDividendsForAddress(_from);
319 			addDividendsForAddress(_to);
320 		}
321 		// Check if the sender has enough
322 		require(accountBalance(_from) >= _value);
323 
324 		// Check allowed
325 		require(_value <= allowed[_from][msg.sender]);
326 
327 		// Subtract from the sender
328 		balances[_from] -= _value;
329 		// Add the same to the recipient
330 		balances[_to] = safeAdd(balances[_to], _value);
331 
332 		allowed[_from][msg.sender] -= _value;
333 
334 		if (agingTimesForPools[_from] > 0 && agingTimesForPools[_from] > now) {
335 			addToAging(_from, _to, agingTimesForPools[_from], _value);
336 		}
337 
338 		addIndex(_to);
339 		Transfer(_from, _to, _value);
340 		return true;
341 	}
342 
343 	/* This unnamed function is called whenever someone tries to send ether to it */
344 	function() {
345 		revert();
346 		// Prevents accidental sending of ether
347 	}
348 
349 	function checkMyAging(address sender) internal {
350 		if (agingBalanceOf[sender][0] == 0) return;
351 
352 		for (uint256 k = 0; k < agingTimes.length; k++) {
353 			if (agingTimes[k] < now) {
354 				agingBalanceOf[sender][0] -= agingBalanceOf[sender][agingTimes[k]];
355 				agingBalanceOf[sender][agingTimes[k]] = 0;
356 			}
357 		}
358 	}
359 
360 	function addAgingTimesForPool(address poolAddress, uint256 agingTime) onlyOwner {
361 		agingTimesForPools[poolAddress] = agingTime;
362 	}
363 
364 	function countAddresses() constant returns (uint256 length) {
365 		return addressByIndex.length;
366 	}
367 
368 	function accountBalance(address _address) constant returns (uint256 balance) {
369 		return balances[_address] - agingBalanceOf[_address][0];
370 	}
371 
372 	function disableTransfers(bool _disable) public onlyOwner {
373 		transfersEnabled = !_disable;
374 	}
375 
376 	function issue(address _to, uint256 _amount) public onlyOwner validAddress(_to) notThis(_to) {
377 		_totalSupply = safeAdd(_totalSupply, _amount);
378 		balances[_to] = safeAdd(balances[_to], _amount);
379 
380 		addIndex(_to);
381 		Issuance(_amount);
382 		Transfer(this, _to, _amount);
383 	}
384 
385 	function destroy(address _from, uint256 _amount) public {
386 		checkMyAging(msg.sender);
387 		// validate input
388 		require(msg.sender == _from || msg.sender == owner);
389 		require(accountBalance(_from) >= _amount);
390 
391 		balances[_from] = safeSub(balances[_from], _amount);
392 		_totalSupply = safeSub(_totalSupply, _amount);
393 
394 		Transfer(_from, this, _amount);
395 		Destruction(_amount);
396 	}
397 }