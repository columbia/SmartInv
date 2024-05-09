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
83 	string public symbol = 'KICK';
84 
85 	uint8 public decimals = 8;
86 
87 	uint256 _totalSupply = 0;
88 
89 	/* Is allowed to burn tokens */
90 	bool public allowManuallyBurnTokens = true;
91 
92 	/* This creates an array with all balances */
93 	mapping (address => uint256) balances;
94 
95 	mapping (address => mapping (uint256 => uint256)) public agingBalanceOf;
96 
97 	uint[] agingTimes;
98 
99 	Dividend[] dividends;
100 
101 	mapping (address => mapping (address => uint256)) allowed;
102 	/* This generates a public event on the blockchain that will notify clients */
103 	event Transfer(address indexed from, address indexed to, uint256 value);
104 
105 	event AgingTransfer(address indexed from, address indexed to, uint256 value, uint256 agingTime);
106 
107 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
108 	// triggered when the total supply is increased
109 	event Issuance(uint256 _amount);
110 	// triggered when the total supply is decreased
111 	event Destruction(uint256 _amount);
112 	// This notifies clients about the amount burnt
113 	event Burn(address indexed from, uint256 value);
114 
115 	address[] public addressByIndex;
116 
117 	mapping (address => bool) addressAddedToIndex;
118 
119 	mapping (address => uint) agingTimesForPools;
120 
121 	uint16 currentDividendIndex = 1;
122 
123 	mapping (address => uint) calculatedDividendsIndex;
124 
125 	bool public transfersEnabled = true;
126 
127 	event NewSmartToken(address _token);
128 
129 	/* Initializes contract with initial supply tokens to the creator of the contract */
130 	function CSToken() {
131 		owner = msg.sender;
132 		// So that the index starts with 1
133 		dividends.push(Dividend(0, 0, 0));
134 		// 31.10.2017 09:00:00
135 		dividends.push(Dividend(1509440400, 30, 0));
136 		// 30.11.2017 09:00:00
137 		dividends.push(Dividend(1512032400, 20, 0));
138 		// 31.12.2017 09:00:00
139 		dividends.push(Dividend(1514710800, 10, 0));
140 		// 31.01.2018 09:00:00
141 		dividends.push(Dividend(1517389200, 5, 0));
142 		// 28.02.2018 09:00:00
143 		dividends.push(Dividend(1519808400, 10, 0));
144 		// 31.03.2018 09:00:00
145 		dividends.push(Dividend(1522486800, 20, 0));
146 		// 30.04.2018 09:00:00
147 		dividends.push(Dividend(1525078800, 30, 0));
148 		// 31.05.2018 09:00:00
149 		dividends.push(Dividend(1527757200, 50, 0));
150 		// 30.06.2018 09:00:00
151 		dividends.push(Dividend(1530349200, 30, 0));
152 		// 31.07.2018 09:00:00
153 		dividends.push(Dividend(1533027600, 20, 0));
154 		// 31.08.2018 09:00:00
155 		dividends.push(Dividend(1535706000, 10, 0));
156 		// 30.09.2018 09:00:00
157 		dividends.push(Dividend(1538298000, 5, 0));
158 		// 31.10.2018 09:00:00
159 		dividends.push(Dividend(1540976400, 10, 0));
160 		// 30.11.2018 09:00:00
161 		dividends.push(Dividend(1543568400, 20, 0));
162 		// 31.12.2018 09:00:00
163 		dividends.push(Dividend(1546246800, 30, 0));
164 		// 31.01.2019 09:00:00
165 		dividends.push(Dividend(1548925200, 60, 0));
166 		// 28.02.2019 09:00:00
167 		dividends.push(Dividend(1551344400, 30, 0));
168 		// 31.03.2019 09:00:00
169 		dividends.push(Dividend(1554022800, 20, 0));
170 		// 30.04.2019 09:00:00
171 		dividends.push(Dividend(1556614800, 10, 0));
172 		// 31.05.2019 09:00:00
173 		dividends.push(Dividend(1559307600, 20, 0));
174 		// 30.06.2019 09:00:00
175 		dividends.push(Dividend(1561885200, 30, 0));
176 		// 31.07.2019 09:00:00
177 		dividends.push(Dividend(1564563600, 20, 0));
178 		// 31.08.2019 09:00:00
179 		dividends.push(Dividend(1567242000, 10, 0));
180 		// 30.09.2019 09:00:00
181 		dividends.push(Dividend(1569834000, 5, 0));
182 
183 		NewSmartToken(address(this));
184 	}
185 
186 	modifier transfersAllowed {
187 		assert(transfersEnabled);
188 		_;
189 	}
190 
191 	function totalSupply() constant returns (uint256 totalSupply) {
192 		totalSupply = _totalSupply;
193 	}
194 
195 	function balanceOf(address _owner) constant returns (uint256 balance) {
196 		return balances[_owner];
197 	}
198 
199 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
200 		return allowed[_owner][_spender];
201 	}
202 
203 	bool allAgingTimesHasBeenAdded = false;
204 	function addAgingTime(uint256 time) onlyOwner {
205 		require(!allAgingTimesHasBeenAdded);
206 		agingTimes.push(time);
207 	}
208 
209 	function allAgingTimesAdded() onlyOwner {
210 		allAgingTimesHasBeenAdded = true;
211 	}
212 
213 	function calculateDividends(uint256 limit) {
214 		require(now >= dividends[currentDividendIndex].time);
215 		require(limit > 0);
216 
217 		limit = safeAdd(dividends[currentDividendIndex].countComplete, limit);
218 
219 		if (limit > addressByIndex.length) {
220 			limit = addressByIndex.length;
221 		}
222 
223 		for (uint256 i = dividends[currentDividendIndex].countComplete; i < limit; i++) {
224 			_addDividendsForAddress(addressByIndex[i]);
225 		}
226 		if (limit == addressByIndex.length) {
227 			currentDividendIndex++;
228 		}
229 		else {
230 			dividends[currentDividendIndex].countComplete = limit;
231 		}
232 	}
233 
234 	/* User can himself receive dividends without waiting for a global accruals */
235 	function receiveDividends() public {
236 		require(now >= dividends[currentDividendIndex].time);
237 		assert(_addDividendsForAddress(msg.sender));
238 	}
239 
240 	function _addDividendsForAddress(address _address) internal returns (bool success) {
241 		// skip calculating dividends, if already calculated for this address
242 		if (calculatedDividendsIndex[_address] >= currentDividendIndex) return false;
243 
244 		uint256 add = balances[_address] * dividends[currentDividendIndex].tenThousandth / 1000;
245 		balances[_address] = safeAdd(balances[_address], add);
246 		Transfer(this, _address, add);
247 		Issuance(add);
248 		_totalSupply = safeAdd(_totalSupply, add);
249 
250 		if (agingBalanceOf[_address][0] > 0) {
251 			agingBalanceOf[_address][0] = safeAdd(agingBalanceOf[_address][0], agingBalanceOf[_address][0] * dividends[currentDividendIndex].tenThousandth / 1000);
252 			for (uint256 k = 0; k < agingTimes.length; k++) {
253 				agingBalanceOf[_address][agingTimes[k]] = safeAdd(agingBalanceOf[_address][agingTimes[k]], agingBalanceOf[_address][agingTimes[k]] * dividends[currentDividendIndex].tenThousandth / 1000);
254 			}
255 		}
256 		calculatedDividendsIndex[_address] = currentDividendIndex;
257 		return true;
258 	}
259 
260 	/* Send coins */
261 	function transfer(address _to, uint256 _value) transfersAllowed returns (bool success) {
262 		_checkMyAging(msg.sender);
263 		if (currentDividendIndex < dividends.length && now >= dividends[currentDividendIndex].time) {
264 			_addDividendsForAddress(msg.sender);
265 			_addDividendsForAddress(_to);
266 		}
267 
268 		require(accountBalance(msg.sender) >= _value);
269 
270 		// Subtract from the sender
271 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
272 
273 		if (agingTimesForPools[msg.sender] > 0 && agingTimesForPools[msg.sender] > now) {
274 			_addToAging(msg.sender, _to, agingTimesForPools[msg.sender], _value);
275 		}
276 
277 		balances[_to] = safeAdd(balances[_to], _value);
278 
279 		_addIndex(_to);
280 		Transfer(msg.sender, _to, _value);
281 		return true;
282 	}
283 
284 	function mintToken(address target, uint256 mintedAmount, uint256 agingTime) onlyOwner {
285 		if (agingTime > now) {
286 			_addToAging(owner, target, agingTime, mintedAmount);
287 		}
288 
289 		balances[target] = safeAdd(balances[target], mintedAmount);
290 
291 		_totalSupply = safeAdd(_totalSupply, mintedAmount);
292 		Issuance(mintedAmount);
293 		_addIndex(target);
294 		Transfer(this, target, mintedAmount);
295 	}
296 
297 	function _addIndex(address _address) internal {
298 		if (!addressAddedToIndex[_address]) {
299 			addressAddedToIndex[_address] = true;
300 			addressByIndex.push(_address);
301 		}
302 	}
303 
304 	function _addToAging(address from, address target, uint256 agingTime, uint256 amount) internal {
305 		agingBalanceOf[target][0] = safeAdd(agingBalanceOf[target][0], amount);
306 		agingBalanceOf[target][agingTime] = safeAdd(agingBalanceOf[target][agingTime], amount);
307 		AgingTransfer(from, target, amount, agingTime);
308 	}
309 
310 	/* Allow another contract to spend some tokens in your behalf */
311 	function approve(address _spender, uint256 _value) returns (bool success) {
312 		allowed[msg.sender][_spender] = _value;
313 		Approval(msg.sender, _spender, _value);
314 		return true;
315 	}
316 
317 	/* Approve and then communicate the approved contract in a single tx */
318 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
319 		tokenRecipient spender = tokenRecipient(_spender);
320 		if (approve(_spender, _value)) {
321 			spender.receiveApproval(msg.sender, _value, this, _extraData);
322 			return true;
323 		}
324 	}
325 
326 	/* A contract attempts to get the coins */
327 	function transferFrom(address _from, address _to, uint256 _value) transfersAllowed returns (bool success) {
328 		_checkMyAging(_from);
329 		if (currentDividendIndex < dividends.length && now >= dividends[currentDividendIndex].time) {
330 			_addDividendsForAddress(_from);
331 			_addDividendsForAddress(_to);
332 		}
333 		// Check if the sender has enough
334 		require(accountBalance(_from) >= _value);
335 
336 		// Check allowed
337 		require(_value <= allowed[_from][msg.sender]);
338 
339 		// Subtract from the sender
340 		balances[_from] = safeSub(balances[_from], _value);
341 		// Add the same to the recipient
342 		balances[_to] = safeAdd(balances[_to], _value);
343 
344 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
345 
346 		if (agingTimesForPools[_from] > 0 && agingTimesForPools[_from] > now) {
347 			_addToAging(_from, _to, agingTimesForPools[_from], _value);
348 		}
349 
350 		_addIndex(_to);
351 		Transfer(_from, _to, _value);
352 		return true;
353 	}
354 
355 	/* This unnamed function is called whenever someone tries to send ether to it */
356 	function() {
357 		revert();
358 		// Prevents accidental sending of ether
359 	}
360 
361 	function _checkMyAging(address sender) internal {
362 		if (agingBalanceOf[sender][0] == 0) return;
363 
364 		for (uint256 k = 0; k < agingTimes.length; k++) {
365 			if (agingTimes[k] < now) {
366 				agingBalanceOf[sender][0] = safeSub(agingBalanceOf[sender][0], agingBalanceOf[sender][agingTimes[k]]);
367 				agingBalanceOf[sender][agingTimes[k]] = 0;
368 			}
369 		}
370 	}
371 
372 	function addAgingTimesForPool(address poolAddress, uint256 agingTime) onlyOwner {
373 		agingTimesForPools[poolAddress] = agingTime;
374 	}
375 
376 	function countAddresses() constant returns (uint256 length) {
377 		return addressByIndex.length;
378 	}
379 
380 	function accountBalance(address _address) constant returns (uint256 balance) {
381 		return safeSub(balances[_address], agingBalanceOf[_address][0]);
382 	}
383 
384 	function disableTransfers(bool _disable) public onlyOwner {
385 		transfersEnabled = !_disable;
386 	}
387 
388 	function issue(address _to, uint256 _amount) public onlyOwner validAddress(_to) notThis(_to) {
389 		_totalSupply = safeAdd(_totalSupply, _amount);
390 		balances[_to] = safeAdd(balances[_to], _amount);
391 
392 		_addIndex(_to);
393 		Issuance(_amount);
394 		Transfer(this, _to, _amount);
395 	}
396 
397 	/**
398 	 * Destroy tokens
399 	 * Remove `_value` tokens from the system irreversibly
400 	 * @param _value the amount of money to burn
401 	 */
402 	function burn(uint256 _value) returns (bool success) {
403 		destroy(msg.sender, _value);
404 		Burn(msg.sender, _value);
405 		return true;
406 	}
407 
408 	/**
409 	 * Destroy tokens
410 	 * Remove `_amount` tokens from the system irreversibly
411 	 * @param _from the address from which tokens will be burnt
412 	 * @param _amount the amount of money to burn
413 	 */
414 	function destroy(address _from, uint256 _amount) public {
415 		_checkMyAging(_from);
416 		// validate input
417 		require((msg.sender == _from && allowManuallyBurnTokens) || msg.sender == owner);
418 		require(accountBalance(_from) >= _amount);
419 
420 		balances[_from] = safeSub(balances[_from], _amount);
421 		_totalSupply = safeSub(_totalSupply, _amount);
422 
423 		Transfer(_from, this, _amount);
424 		Destruction(_amount);
425 	}
426 
427 	function disableManuallyBurnTokens(bool _disable) public onlyOwner {
428 		allowManuallyBurnTokens = !_disable;
429 	}
430 }