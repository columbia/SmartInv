1 pragma solidity ^0.4.2;
2 
3 
4 contract KickOwned {
5 	address public owner;
6 
7 	function KickOwned() {
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
22 
23 
24 contract KickUtils {
25 	/**
26 		constructor
27 	*/
28 	function Utils() {
29 	}
30 
31 	// validates an address - currently only checks that it isn't null
32 	modifier validAddress(address _address) {
33 		require(_address != 0x0);
34 		_;
35 	}
36 
37 	// verifies that the address is different than this contract address
38 	modifier notThis(address _address) {
39 		require(_address != address(this));
40 		_;
41 	}
42 
43 	// Overflow protected math functions
44 
45 	/**
46 		@dev returns the sum of _x and _y, asserts if the calculation overflows
47 
48 		@param _x   value 1
49 		@param _y   value 2
50 
51 		@return sum
52 	*/
53 	function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
54 		uint256 z = _x + _y;
55 		assert(z >= _x);
56 		return z;
57 	}
58 
59 	/**
60 		@dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
61 
62 		@param _x   minuend
63 		@param _y   subtrahend
64 
65 		@return difference
66 	*/
67 	function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
68 		assert(_x >= _y);
69 		return _x - _y;
70 	}
71 }
72 
73 
74 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);}
75 
76 contract KickToken is KickOwned, KickUtils {
77 	struct Dividend {uint256 time; uint256 tenThousandth; uint256 countComplete;}
78 
79 	/* Public variables of the token */
80 	string public standard = 'Token 0.1';
81 
82 	string public name = 'Experimental KickCoin';
83 
84 	string public symbol = 'EKICK';
85 
86 	uint8 public decimals = 8;
87 
88 	uint256 _totalSupply = 0;
89 
90 	/* Is allowed to burn tokens */
91 	bool public allowManuallyBurnTokens = true;
92 
93 	/* This creates an array with all balances */
94 	mapping (address => uint256) balances;
95 
96 	mapping (address => mapping (uint256 => uint256)) public agingBalanceOf;
97 
98 	uint[] agingTimes;
99 
100 	Dividend[] dividends;
101 
102 	mapping (address => mapping (address => uint256)) allowed;
103 	/* This generates a public event on the blockchain that will notify clients */
104 	event Transfer(address indexed from, address indexed to, uint256 value);
105 
106 	event AgingTransfer(address indexed from, address indexed to, uint256 value, uint256 agingTime);
107 
108 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109 	// triggered when the total supply is increased
110 	event Issuance(uint256 _amount);
111 	// triggered when the total supply is decreased
112 	event Destruction(uint256 _amount);
113 	// This notifies clients about the amount burnt
114 	event Burn(address indexed from, uint256 value);
115 
116 	address[] public addressByIndex;
117 
118 	mapping (address => bool) addressAddedToIndex;
119 
120 	mapping (address => uint) agingTimesForPools;
121 
122 	uint16 currentDividendIndex = 1;
123 
124 	mapping (address => uint) calculatedDividendsIndex;
125 
126 	bool public transfersEnabled = true;
127 
128 	event NewSmartToken(address _token);
129 
130 	/* Initializes contract with initial supply tokens to the creator of the contract */
131 	function KickToken() {
132 		owner = msg.sender;
133 		// So that the index starts with 1
134 		dividends.push(Dividend(0, 0, 0));
135 		// 31.10.2017 09:00:00
136 		dividends.push(Dividend(1509440400, 30, 0));
137 		// 30.11.2017 09:00:00
138 		dividends.push(Dividend(1512032400, 20, 0));
139 		// 31.12.2017 09:00:00
140 		dividends.push(Dividend(1514710800, 10, 0));
141 		// 31.01.2018 09:00:00
142 		dividends.push(Dividend(1517389200, 5, 0));
143 		// 28.02.2018 09:00:00
144 		dividends.push(Dividend(1519808400, 10, 0));
145 		// 31.03.2018 09:00:00
146 		dividends.push(Dividend(1522486800, 20, 0));
147 		// 30.04.2018 09:00:00
148 		dividends.push(Dividend(1525078800, 30, 0));
149 		// 31.05.2018 09:00:00
150 		dividends.push(Dividend(1527757200, 50, 0));
151 		// 30.06.2018 09:00:00
152 		dividends.push(Dividend(1530349200, 30, 0));
153 		// 31.07.2018 09:00:00
154 		dividends.push(Dividend(1533027600, 20, 0));
155 		// 31.08.2018 09:00:00
156 		dividends.push(Dividend(1535706000, 10, 0));
157 		// 30.09.2018 09:00:00
158 		dividends.push(Dividend(1538298000, 5, 0));
159 		// 31.10.2018 09:00:00
160 		dividends.push(Dividend(1540976400, 10, 0));
161 		// 30.11.2018 09:00:00
162 		dividends.push(Dividend(1543568400, 20, 0));
163 		// 31.12.2018 09:00:00
164 		dividends.push(Dividend(1546246800, 30, 0));
165 		// 31.01.2019 09:00:00
166 		dividends.push(Dividend(1548925200, 60, 0));
167 		// 28.02.2019 09:00:00
168 		dividends.push(Dividend(1551344400, 30, 0));
169 		// 31.03.2019 09:00:00
170 		dividends.push(Dividend(1554022800, 20, 0));
171 		// 30.04.2019 09:00:00
172 		dividends.push(Dividend(1556614800, 10, 0));
173 		// 31.05.2019 09:00:00
174 		dividends.push(Dividend(1559307600, 20, 0));
175 		// 30.06.2019 09:00:00
176 		dividends.push(Dividend(1561885200, 30, 0));
177 		// 31.07.2019 09:00:00
178 		dividends.push(Dividend(1564563600, 20, 0));
179 		// 31.08.2019 09:00:00
180 		dividends.push(Dividend(1567242000, 10, 0));
181 		// 30.09.2019 09:00:00
182 		dividends.push(Dividend(1569834000, 5, 0));
183 
184 		NewSmartToken(address(this));
185 	}
186 
187 	modifier transfersAllowed {
188 		assert(transfersEnabled);
189 		_;
190 	}
191 
192 	function totalSupply() constant returns (uint256 totalSupply) {
193 		totalSupply = _totalSupply;
194 	}
195 
196 	function balanceOf(address _owner) constant returns (uint256 balance) {
197 		return balances[_owner];
198 	}
199 
200 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
201 		return allowed[_owner][_spender];
202 	}
203 
204 	bool allAgingTimesHasBeenAdded = false;
205 	function addAgingTime(uint256 time) onlyOwner {
206 		require(!allAgingTimesHasBeenAdded);
207 		agingTimes.push(time);
208 	}
209 
210 	function allAgingTimesAdded() onlyOwner {
211 		allAgingTimesHasBeenAdded = true;
212 	}
213 
214 	function calculateDividends(uint256 limit) {
215 		require(now >= dividends[currentDividendIndex].time);
216 		require(limit > 0);
217 
218 		limit = safeAdd(dividends[currentDividendIndex].countComplete, limit);
219 
220 		if (limit > addressByIndex.length) {
221 			limit = addressByIndex.length;
222 		}
223 
224 		for (uint256 i = dividends[currentDividendIndex].countComplete; i < limit; i++) {
225 			_addDividendsForAddress(addressByIndex[i]);
226 		}
227 		if (limit == addressByIndex.length) {
228 			currentDividendIndex++;
229 		}
230 		else {
231 			dividends[currentDividendIndex].countComplete = limit;
232 		}
233 	}
234 
235 	/* User can himself receive dividends without waiting for a global accruals */
236 	function receiveDividends() public {
237 		require(now >= dividends[currentDividendIndex].time);
238 		assert(_addDividendsForAddress(msg.sender));
239 	}
240 
241 	function _addDividendsForAddress(address _address) internal returns (bool success) {
242 		// skip calculating dividends, if already calculated for this address
243 		if (calculatedDividendsIndex[_address] >= currentDividendIndex) return false;
244 
245 		uint256 add = balances[_address] * dividends[currentDividendIndex].tenThousandth / 1000;
246 		balances[_address] = safeAdd(balances[_address], add);
247 		Transfer(this, _address, add);
248 		Issuance(add);
249 		_totalSupply = safeAdd(_totalSupply, add);
250 
251 		if (agingBalanceOf[_address][0] > 0) {
252 			agingBalanceOf[_address][0] = safeAdd(agingBalanceOf[_address][0], agingBalanceOf[_address][0] * dividends[currentDividendIndex].tenThousandth / 1000);
253 			for (uint256 k = 0; k < agingTimes.length; k++) {
254 				agingBalanceOf[_address][agingTimes[k]] = safeAdd(agingBalanceOf[_address][agingTimes[k]], agingBalanceOf[_address][agingTimes[k]] * dividends[currentDividendIndex].tenThousandth / 1000);
255 			}
256 		}
257 		calculatedDividendsIndex[_address] = currentDividendIndex;
258 		return true;
259 	}
260 
261 	/* Send coins */
262 	function transfer(address _to, uint256 _value) transfersAllowed returns (bool success) {
263 		_checkMyAging(msg.sender);
264 		if (currentDividendIndex < dividends.length && now >= dividends[currentDividendIndex].time) {
265 			_addDividendsForAddress(msg.sender);
266 			_addDividendsForAddress(_to);
267 		}
268 
269 		require(accountBalance(msg.sender) >= _value);
270 
271 		// Subtract from the sender
272 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
273 
274 		if (agingTimesForPools[msg.sender] > 0 && agingTimesForPools[msg.sender] > now) {
275 			_addToAging(msg.sender, _to, agingTimesForPools[msg.sender], _value);
276 		}
277 
278 		balances[_to] = safeAdd(balances[_to], _value);
279 
280 		_addIndex(_to);
281 		Transfer(msg.sender, _to, _value);
282 		return true;
283 	}
284 
285 	function mintToken(address target, uint256 mintedAmount, uint256 agingTime) onlyOwner {
286 		if (agingTime > now) {
287 			_addToAging(owner, target, agingTime, mintedAmount);
288 		}
289 
290 		balances[target] = safeAdd(balances[target], mintedAmount);
291 
292 		_totalSupply = safeAdd(_totalSupply, mintedAmount);
293 		Issuance(mintedAmount);
294 		_addIndex(target);
295 		Transfer(this, target, mintedAmount);
296 	}
297 
298 	function _addIndex(address _address) internal {
299 		if (!addressAddedToIndex[_address]) {
300 			addressAddedToIndex[_address] = true;
301 			addressByIndex.push(_address);
302 		}
303 	}
304 
305 	function _addToAging(address from, address target, uint256 agingTime, uint256 amount) internal {
306 		agingBalanceOf[target][0] = safeAdd(agingBalanceOf[target][0], amount);
307 		agingBalanceOf[target][agingTime] = safeAdd(agingBalanceOf[target][agingTime], amount);
308 		AgingTransfer(from, target, amount, agingTime);
309 	}
310 
311 	/* Allow another contract to spend some tokens in your behalf */
312 	function approve(address _spender, uint256 _value) returns (bool success) {
313 		allowed[msg.sender][_spender] = _value;
314 		Approval(msg.sender, _spender, _value);
315 		return true;
316 	}
317 
318 	/* Approve and then communicate the approved contract in a single tx */
319 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
320 		tokenRecipient spender = tokenRecipient(_spender);
321 		if (approve(_spender, _value)) {
322 			spender.receiveApproval(msg.sender, _value, this, _extraData);
323 			return true;
324 		}
325 	}
326 
327 	/* A contract attempts to get the coins */
328 	function transferFrom(address _from, address _to, uint256 _value) transfersAllowed returns (bool success) {
329 		_checkMyAging(_from);
330 		if (currentDividendIndex < dividends.length && now >= dividends[currentDividendIndex].time) {
331 			_addDividendsForAddress(_from);
332 			_addDividendsForAddress(_to);
333 		}
334 		// Check if the sender has enough
335 		require(accountBalance(_from) >= _value);
336 
337 		// Check allowed
338 		require(_value <= allowed[_from][msg.sender]);
339 
340 		// Subtract from the sender
341 		balances[_from] = safeSub(balances[_from], _value);
342 		// Add the same to the recipient
343 		balances[_to] = safeAdd(balances[_to], _value);
344 
345 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
346 
347 		if (agingTimesForPools[_from] > 0 && agingTimesForPools[_from] > now) {
348 			_addToAging(_from, _to, agingTimesForPools[_from], _value);
349 		}
350 
351 		_addIndex(_to);
352 		Transfer(_from, _to, _value);
353 		return true;
354 	}
355 
356 	/* This unnamed function is called whenever someone tries to send ether to it */
357 	function() {
358 		revert();
359 		// Prevents accidental sending of ether
360 	}
361 
362 	function _checkMyAging(address sender) internal {
363 		if (agingBalanceOf[sender][0] == 0) return;
364 
365 		for (uint256 k = 0; k < agingTimes.length; k++) {
366 			if (agingTimes[k] < now) {
367 				agingBalanceOf[sender][0] = safeSub(agingBalanceOf[sender][0], agingBalanceOf[sender][agingTimes[k]]);
368 				agingBalanceOf[sender][agingTimes[k]] = 0;
369 			}
370 		}
371 	}
372 
373 	function addAgingTimesForPool(address poolAddress, uint256 agingTime) onlyOwner {
374 		agingTimesForPools[poolAddress] = agingTime;
375 	}
376 
377 	function countAddresses() constant returns (uint256 length) {
378 		return addressByIndex.length;
379 	}
380 
381 	function accountBalance(address _address) constant returns (uint256 balance) {
382 		return safeSub(balances[_address], agingBalanceOf[_address][0]);
383 	}
384 
385 	function disableTransfers(bool _disable) public onlyOwner {
386 		transfersEnabled = !_disable;
387 	}
388 
389 	function issue(address _to, uint256 _amount) public onlyOwner validAddress(_to) notThis(_to) {
390 		_totalSupply = safeAdd(_totalSupply, _amount);
391 		balances[_to] = safeAdd(balances[_to], _amount);
392 
393 		_addIndex(_to);
394 		Issuance(_amount);
395 		Transfer(this, _to, _amount);
396 	}
397 
398 	/**
399 	 * Destroy tokens
400 	 * Remove `_value` tokens from the system irreversibly
401 	 * @param _value the amount of money to burn
402 	 */
403 	function burn(uint256 _value) returns (bool success) {
404 		destroy(msg.sender, _value);
405 		Burn(msg.sender, _value);
406 		return true;
407 	}
408 
409 	/**
410 	 * Destroy tokens
411 	 * Remove `_amount` tokens from the system irreversibly
412 	 * @param _from the address from which tokens will be burnt
413 	 * @param _amount the amount of money to burn
414 	 */
415 	function destroy(address _from, uint256 _amount) public {
416 		_checkMyAging(_from);
417 		// validate input
418 		require((msg.sender == _from && allowManuallyBurnTokens) || msg.sender == owner);
419 		require(accountBalance(_from) >= _amount);
420 
421 		balances[_from] = safeSub(balances[_from], _amount);
422 		_totalSupply = safeSub(_totalSupply, _amount);
423 
424 		Transfer(_from, this, _amount);
425 		Destruction(_amount);
426 	}
427 
428 	function disableManuallyBurnTokens(bool _disable) public onlyOwner {
429 		allowManuallyBurnTokens = !_disable;
430 	}
431 
432   function kill() public {
433         require(msg.sender == owner);
434         selfdestruct(owner);
435     }
436 
437 }