1 pragma solidity >=0.4.10;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     /**
8      * Events
9      */
10     event ChangedOwner(address indexed new_owner);
11 
12     /**
13      * Functionality
14      */
15 
16     function Owned() {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function changeOwner(address _newOwner) onlyOwner external {
26         newOwner = _newOwner;
27     }
28 
29     function acceptOwnership() external {
30         if (msg.sender == newOwner) {
31             owner = newOwner;
32             newOwner = 0x0;
33             ChangedOwner(owner);
34         }
35     }
36 }
37 
38 contract IOwned {
39     function owner() returns (address);
40     function changeOwner(address);
41     function acceptOwnership();
42 }
43 
44 contract Token {
45 	function transferFrom(address from, address to, uint amount) returns(bool);
46 	function transfer(address to, uint amount) returns(bool);
47 	function balanceOf(address addr) constant returns(uint);
48 }
49 
50 
51 /**
52  * Savings is a contract that releases Tokens on a predefined
53  * schedule, and allocates bonus tokens upon withdrawal on a
54  * proportional basis, determined by the ratio of deposited tokens
55  * to total owned tokens.
56  *
57  * The distribution schedule consists of a monthly withdrawal schedule
58  * responsible for distribution 75% of the total savings, and a
59  * one-off withdrawal event available before or at the start of the
60  * withdrawal schedule, distributing 25% of the total savings.
61  *
62  * To be exact, upon contract deployment there may be a period of time in which
63  * only the one-off withdrawal event is available, define this period of time as:
64  * [timestamp(start), timestamp(startBlockTimestamp)),
65  *
66  * Then the periodic withdrawal range is defined as:
67  * [timestamp(startBlockTimestamp), +inf)
68  *
69  * DO NOT SEND TOKENS TO THIS CONTRACT. Use the deposit() or depositTo() method.
70  * As an exception, tokens transferred to this contract before locking are the
71  * bonus tokens that are distributed.
72  */
73 contract Savings is Owned {
74 	/**
75 	 * Periods is the total monthly withdrawable amount, not counting the
76 	 * special withdrawal.
77 	 */
78 	uint public periods;
79 
80 	/**
81 	 * t0special is an additional multiplier that determines what
82 	 * fraction of the total distribution is distributed in the
83 	 * one-off withdrawal event. It is used in conjunction with
84 	 * a periodic multiplier (p) to determine the total savings withdrawable
85 	 * to the user at that point in time.
86 	 *
87 	 * The value is not set, it is calculated based on periods
88 	 */
89 	uint public t0special;
90 
91 	uint constant public intervalSecs = 30 days;
92 	uint constant public precision = 10 ** 18;
93 
94 
95 	/**
96 	 * Events
97 	 */
98 	event Withdraws(address indexed who, uint amount);
99 	event Deposit(address indexed who, uint amount);
100 
101 	bool public inited;
102 	bool public locked;
103 	uint public startBlockTimestamp = 0;
104 
105 	Token public token;
106 
107 	// face value deposited by an address before locking
108 	mapping (address => uint) public deposited;
109 
110 	// total face value deposited; sum of deposited
111 	uint public totalfv;
112 
113 	// the total remaining value
114 	uint public remainder;
115 
116 	/**
117 	 * Total tokens owned by the contract after locking, and possibly
118 	 * updated by the foundation after subsequent sales.
119 	 */
120 	uint public total;
121 
122 	// the total value withdrawn
123 	mapping (address => uint256) public withdrawn;
124 
125 	bool public nullified;
126 
127 	modifier notNullified() { require(!nullified); _; }
128 
129 	modifier preLock() { require(!locked && startBlockTimestamp == 0); _; }
130 
131 	/**
132 	 * Lock called, deposits no longer available.
133 	 */
134 	modifier postLock() { require(locked); _; }
135 
136 	/**
137 	 * Prestart, state is after lock, before start
138 	 */
139 	modifier preStart() { require(locked && startBlockTimestamp == 0); _; }
140 
141 	/**
142 	 * Start called, the savings contract is now finalized, and withdrawals
143 	 * are now permitted.
144 	 */
145 	modifier postStart() { require(locked && startBlockTimestamp != 0); _; }
146 
147 	/**
148 	 * Uninitialized state, before init is called. Mainly used as a guard to
149 	 * finalize periods and t0special.
150 	 */
151 	modifier notInitialized() { require(!inited); _; }
152 
153 	/**
154 	 * Post initialization state, mainly used to guarantee that
155 	 * periods and t0special have been set properly before starting
156 	 * the withdrawal process.
157 	 */
158 	modifier initialized() { require(inited); _; }
159 
160 	/**
161 	 * Revert under all conditions for fallback, cheaper mistakes
162 	 * in the future?
163 	 */
164 	function() {
165 		revert();
166 	}
167 
168 	/**
169 	 * Nullify functionality is intended to disable the contract.
170 	 */
171 	function nullify() onlyOwner {
172 		nullified = true;
173 	}
174 
175 	/**
176 	 * Initialization function, should be called after contract deployment. The
177 	 * addition of this function allows contract compilation to be simplified
178 	 * to one contract, instead of two.
179 	 *
180 	 * periods and t0special are finalized, and effectively invariant, after
181 	 * init is called for the first time.
182 	 */
183 	function init(uint _periods, uint _t0special) onlyOwner notInitialized {
184 		require(_periods != 0);
185 		periods = _periods;
186 		t0special = _t0special;
187 	}
188 
189 	function finalizeInit() onlyOwner notInitialized {
190 		inited = true;
191 	}
192 
193 	function setToken(address tok) onlyOwner {
194 		token = Token(tok);
195 	}
196 
197 	/**
198 	 * Lock is called by the owner to lock the savings contract
199 	 * so that no more deposits may be made.
200 	 */
201 	function lock() onlyOwner {
202 		locked = true;
203 	}
204 
205 	/**
206 	 * Starts the distribution of savings, it should be called
207 	 * after lock(), once all of the bonus tokens are send to this contract,
208 	 * and multiMint has been called.
209 	 */
210 	function start(uint _startBlockTimestamp) onlyOwner initialized preStart {
211 		startBlockTimestamp = _startBlockTimestamp;
212 		uint256 tokenBalance = token.balanceOf(this);
213 		total = tokenBalance;
214 		remainder = tokenBalance;
215 	}
216 
217 	/**
218 	 * Check withdrawal is live, useful for checking whether
219 	 * the savings contract is "live", withdrawal enabled, started.
220 	 */
221 	function isStarted() constant returns(bool) {
222 		return locked && startBlockTimestamp != 0;
223 	}
224 
225 	// if someone accidentally transfers tokens to this contract,
226 	// the owner can return them as long as distribution hasn't started
227 
228 	/**
229 	 * Used to refund users who accidentaly transferred tokens to this
230 	 * contract, only available before contract is locked
231 	 */
232 	function refundTokens(address addr, uint amount) onlyOwner preLock {
233 		token.transfer(addr, amount);
234 	}
235 
236 
237 	/**
238 	 * Update the total balance, to be called in case of subsequent sales. Updates
239 	 * the total recorded balance of the contract by the difference in expected
240 	 * remainder and the current balance. This means any positive difference will
241 	 * be "recorded" into the contract, and distributed within the remaining
242 	 * months of the TRS.
243 	 */
244 	function updateTotal() onlyOwner postLock {
245 		uint current = token.balanceOf(this);
246 		require(current >= remainder); // for sanity
247 
248 		uint difference = (current - remainder);
249 		total += difference;
250 		remainder = current;
251 	}
252 
253 	/**
254 	 * Calculates the monthly period, starting after the startBlockTimestamp,
255 	 * periodAt will return 0 for all timestamps before startBlockTimestamp.
256 	 *
257 	 * Therefore period 0 is the range of time in which we have called start(),
258 	 * but have not yet passed startBlockTimestamp. Period 1 is the
259 	 * first monthly period, and so-forth all the way until the last
260 	 * period == periods.
261 	 *
262 	 * NOTE: not guarded since no state modifications are made. However,
263 	 * it will return invalid data before the postStart state. It is
264 	 * up to the user to manually check that the contract is in
265 	 * postStart state.
266 	 */
267 	function periodAt(uint _blockTimestamp) constant returns(uint) {
268 		/**
269 		 * Lower bound, consider period 0 to be the time between
270 		 * start() and startBlockTimestamp
271 		 */
272 		if (startBlockTimestamp > _blockTimestamp)
273 			return 0;
274 
275 		/**
276 		 * Calculate the appropriate period, and set an upper bound of
277 		 * periods - 1.
278 		 */
279 		uint p = ((_blockTimestamp - startBlockTimestamp) / intervalSecs) + 1;
280 		if (p > periods)
281 			p = periods;
282 		return p;
283 	}
284 
285 	// what withdrawal period are we in?
286 	// returns the period number from [0, periods)
287 	function period() constant returns(uint) {
288 		return periodAt(block.timestamp);
289 	}
290 
291 	// deposit your tokens to be saved
292 	//
293 	// the despositor must have approve()'d the tokens
294 	// to be transferred by this contract
295 	function deposit(uint tokens) onlyOwner notNullified {
296 		depositTo(msg.sender, tokens);
297 	}
298 
299 
300 	function depositTo(address beneficiary, uint tokens) onlyOwner preLock notNullified {
301 		require(token.transferFrom(msg.sender, this, tokens));
302 	    deposited[beneficiary] += tokens;
303 		totalfv += tokens;
304 		Deposit(beneficiary, tokens);
305 	}
306 
307 	// convenience function for owner: deposit on behalf of many
308 	function bulkDepositTo(uint256[] bits) onlyOwner {
309 		uint256 lomask = (1 << 96) - 1;
310 		for (uint i=0; i<bits.length; i++) {
311 			address a = address(bits[i]>>96);
312 			uint val = bits[i]&lomask;
313 			depositTo(a, val);
314 		}
315 	}
316 
317 	// withdraw withdraws tokens to the sender
318 	// withdraw can be called at most once per redemption period
319 	function withdraw() notNullified returns(bool) {
320 		return withdrawTo(msg.sender);
321 	}
322 
323 	/**
324 	 * Calculates the fraction of total (one-off + monthly) withdrawable
325 	 * given the current timestamp. No guards due to function being constant.
326 	 * Will output invalid data until the postStart state. It is up to the user
327 	 * to manually confirm contract is in postStart state.
328 	 */
329 	function availableForWithdrawalAt(uint256 blockTimestamp) constant returns (uint256) {
330 		/**
331 		 * Calculate the total withdrawable, giving a numerator with range:
332 		 * [0.25 * 10 ** 18, 1 * 10 ** 18]
333 		 */
334 		return ((t0special + periodAt(blockTimestamp)) * precision) / (t0special + periods);
335 	}
336 
337 	/**
338 	 * Business logic of _withdrawTo, the code is separated this way mainly for
339 	 * testing. We can inject and test parameters freely without worrying about the
340 	 * blockchain model.
341 	 *
342 	 * NOTE: Since function is constant, no guards are applied. This function will give
343 	 * invalid outputs unless in postStart state. It is up to user to manually check
344 	 * that the correct state is given (isStart() == true)
345 	 */
346 	function _withdrawTo(uint _deposit, uint _withdrawn, uint _blockTimestamp, uint _total) constant returns (uint) {
347 		uint256 fraction = availableForWithdrawalAt(_blockTimestamp);
348 
349 		/**
350 		 * There are concerns that the multiplication could possibly
351 		 * overflow, however this should not be the case if we calculate
352 		 * the upper bound based on our known parameters:
353 		 *
354 		 * Lets assume the minted token amount to be 500 million (reasonable),
355 		 * given a precision of 8 decimal places, we get:
356 		 * deposited[addr] = 5 * (10 ** 8) * (10 ** 8) = 5 * (10 ** 16)
357 		 *
358 		 * The max for fraction = 10 ** 18, and the max for total is
359 		 * also 5 * (10 ** 16).
360 		 *
361 		 * Therefore:
362 		 * deposited[addr] * fraction * total = 2.5 * (10 ** 51)
363 		 *
364 		 * The maximum for a uint256 is = 1.15 * (10 ** 77)
365 		 */
366 		uint256 withdrawable = ((_deposit * fraction * _total) / totalfv) / precision;
367 
368 		// check that we can withdraw something
369 		if (withdrawable > _withdrawn) {
370 			return withdrawable - _withdrawn;
371 		}
372 		return 0;
373 	}
374 
375 	/**
376 	 * Public facing withdrawTo, injects business logic with
377 	 * the correct model.
378 	 */
379 	function withdrawTo(address addr) postStart notNullified returns (bool) {
380 		uint _d = deposited[addr];
381 		uint _w = withdrawn[addr];
382 
383 		uint diff = _withdrawTo(_d, _w, block.timestamp, total);
384 
385 		// no withdrawal could be made
386 		if (diff == 0) {
387 			return false;
388 		}
389 
390 		// check that we cannot withdraw more than max
391 		require((diff + _w) <= ((_d * total) / totalfv));
392 
393 		// transfer and increment
394 		require(token.transfer(addr, diff));
395 
396 		withdrawn[addr] += diff;
397 		remainder -= diff;
398 		Withdraws(addr, diff);
399 		return true;
400 	}
401 
402 	// force withdrawal to many addresses
403 	function bulkWithdraw(address[] addrs) notNullified {
404 		for (uint i=0; i<addrs.length; i++)
405 			withdrawTo(addrs[i]);
406 	}
407 
408 	// Code off the chain informs this contract about
409 	// tokens that were minted to it on behalf of a depositor.
410 	//
411 	// Note: the function signature here is known to New Alchemy's
412 	// tooling, which is why it is arguably misnamed.
413 	uint public mintingNonce;
414 	function multiMint(uint nonce, uint256[] bits) onlyOwner preLock {
415 
416 		if (nonce != mintingNonce) return;
417 		mintingNonce += 1;
418 		uint256 lomask = (1 << 96) - 1;
419 		uint sum = 0;
420 		for (uint i=0; i<bits.length; i++) {
421 			address a = address(bits[i]>>96);
422 			uint value = bits[i]&lomask;
423 			deposited[a] += value;
424 			sum += value;
425 			Deposit(a, value);
426 		}
427 		totalfv += sum;
428 	}
429 }