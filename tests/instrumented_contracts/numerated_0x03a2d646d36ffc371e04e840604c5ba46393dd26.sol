1 pragma solidity >=0.4.10;
2 
3 contract Token {
4 	function transferFrom(address from, address to, uint amount) returns(bool);
5 	function transfer(address to, uint amount) returns(bool);
6 	function balanceOf(address addr) constant returns(uint);
7 }
8 
9 contract Owned {
10     address public owner;
11     address public newOwner;
12 
13     /**
14      * Events
15      */
16     event ChangedOwner(address indexed new_owner);
17 
18     /**
19      * Functionality
20      */
21 
22     function Owned() {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function changeOwner(address _newOwner) onlyOwner external {
32         newOwner = _newOwner;
33     }
34 
35     function acceptOwnership() external {
36         if (msg.sender == newOwner) {
37             owner = newOwner;
38             newOwner = 0x0;
39             ChangedOwner(owner);
40         }
41     }
42 }
43 
44 contract IOwned {
45     function owner() returns (address);
46     function changeOwner(address);
47     function acceptOwnership();
48 }
49 
50 /**
51  * Savings is a contract that releases Tokens on a predefined
52  * schedule, and allocates bonus tokens upon withdrawal on a
53  * proportional basis, determined by the ratio of deposited tokens
54  * to total owned tokens.
55  *
56  * The distribution schedule consists of a monthly withdrawal schedule
57  * responsible for distribution 75% of the total savings, and a
58  * one-off withdrawal event available before or at the start of the
59  * withdrawal schedule, distributing 25% of the total savings.
60  *
61  * To be exact, upon contract deployment there may be a period of time in which
62  * only the one-off withdrawal event is available, define this period of time as:
63  * [timestamp(start), timestamp(startBlockTimestamp)),
64  *
65  * Then the periodic withdrawal range is defined as:
66  * [timestamp(startBlockTimestamp), +inf)
67  *
68  * DO NOT SEND TOKENS TO THIS CONTRACT. Use the deposit() or depositTo() method.
69  * As an exception, tokens transferred to this contract before locking are the
70  * bonus tokens that are distributed.
71  */
72 contract Savings is Owned {
73 	/**
74 	 * Periods is the total monthly withdrawable amount, not counting the
75 	 * special withdrawal.
76 	 */
77 	uint public periods;
78 
79 	/**
80 	 * t0special is an additional multiplier that determines what
81 	 * fraction of the total distribution is distributed in the
82 	 * one-off withdrawal event. It is used in conjunction with
83 	 * a periodic multiplier (p) to determine the total savings withdrawable
84 	 * to the user at that point in time.
85 	 *
86 	 * The value is not set, it is calculated based on periods
87 	 */
88 	uint public t0special;
89 
90 	uint constant public intervalSecs = 30 days;
91 	uint constant public precision = 10 ** 18;
92 
93 
94 	/**
95 	 * Events
96 	 */
97 	event Withdraws(address indexed who, uint amount);
98 	event Deposit(address indexed who, uint amount);
99 
100 	bool public inited;
101 	bool public locked;
102 	uint public startBlockTimestamp = 0;
103 
104 	Token public token;
105 
106 	// face value deposited by an address before locking
107 	mapping (address => uint) public deposited;
108 
109 	// total face value deposited; sum of deposited
110 	uint public totalfv;
111 
112 	// the total remaining value
113 	uint public remainder;
114 
115 	/**
116 	 * Total tokens owned by the contract after locking, and possibly
117 	 * updated by the foundation after subsequent sales.
118 	 */
119 	uint public total;
120 
121 	// the total value withdrawn
122 	mapping (address => uint256) public withdrawn;
123 
124 	bool public nullified;
125 
126 	modifier notNullified() { require(!nullified); _; }
127 
128 	modifier preLock() { require(!locked && startBlockTimestamp == 0); _; }
129 
130 	/**
131 	 * Lock called, deposits no longer available.
132 	 */
133 	modifier postLock() { require(locked); _; }
134 
135 	/**
136 	 * Prestart, state is after lock, before start
137 	 */
138 	modifier preStart() { require(locked && startBlockTimestamp == 0); _; }
139 
140 	/**
141 	 * Start called, the savings contract is now finalized, and withdrawals
142 	 * are now permitted.
143 	 */
144 	modifier postStart() { require(locked && startBlockTimestamp != 0); _; }
145 
146 	/**
147 	 * Uninitialized state, before init is called. Mainly used as a guard to
148 	 * finalize periods and t0special.
149 	 */
150 	modifier notInitialized() { require(!inited); _; }
151 
152 	/**
153 	 * Post initialization state, mainly used to guarantee that
154 	 * periods and t0special have been set properly before starting
155 	 * the withdrawal process.
156 	 */
157 	modifier initialized() { require(inited); _; }
158 
159 	/**
160 	 * Revert under all conditions for fallback, cheaper mistakes
161 	 * in the future?
162 	 */
163 	function() {
164 		revert();
165 	}
166 
167 	/**
168 	 * Nullify functionality is intended to disable the contract.
169 	 */
170 	function nullify() onlyOwner {
171 		nullified = true;
172 	}
173 
174 	/**
175 	 * Initialization function, should be called after contract deployment. The
176 	 * addition of this function allows contract compilation to be simplified
177 	 * to one contract, instead of two.
178 	 *
179 	 * periods and t0special are finalized, and effectively invariant, after
180 	 * init is called for the first time.
181 	 */
182 	function init(uint _periods, uint _t0special) onlyOwner notInitialized {
183 		require(_periods != 0);
184 		periods = _periods;
185 		t0special = _t0special;
186 	}
187 
188 	function finalizeInit() onlyOwner notInitialized {
189 		inited = true;
190 	}
191 
192 	function setToken(address tok) onlyOwner {
193 		token = Token(tok);
194 	}
195 
196 	/**
197 	 * Lock is called by the owner to lock the savings contract
198 	 * so that no more deposits may be made.
199 	 */
200 	function lock() onlyOwner {
201 		locked = true;
202 	}
203 
204 	/**
205 	 * Starts the distribution of savings, it should be called
206 	 * after lock(), once all of the bonus tokens are send to this contract,
207 	 * and multiMint has been called.
208 	 */
209 	function start(uint _startBlockTimestamp) onlyOwner initialized preStart {
210 		startBlockTimestamp = _startBlockTimestamp;
211 		uint256 tokenBalance = token.balanceOf(this);
212 		total = tokenBalance;
213 		remainder = tokenBalance;
214 	}
215 
216 	/**
217 	 * Check withdrawal is live, useful for checking whether
218 	 * the savings contract is "live", withdrawal enabled, started.
219 	 */
220 	function isStarted() constant returns(bool) {
221 		return locked && startBlockTimestamp != 0;
222 	}
223 
224 	// if someone accidentally transfers tokens to this contract,
225 	// the owner can return them as long as distribution hasn't started
226 
227 	/**
228 	 * Used to refund users who accidentaly transferred tokens to this
229 	 * contract, only available before contract is locked
230 	 */
231 	function refundTokens(address addr, uint amount) onlyOwner preLock {
232 		token.transfer(addr, amount);
233 	}
234 
235 
236 	/**
237 	 * Update the total balance, to be called in case of subsequent sales. Updates
238 	 * the total recorded balance of the contract by the difference in expected
239 	 * remainder and the current balance. This means any positive difference will
240 	 * be "recorded" into the contract, and distributed within the remaining
241 	 * months of the TRS.
242 	 */
243 	function updateTotal() onlyOwner postLock {
244 		uint current = token.balanceOf(this);
245 		require(current >= remainder); // for sanity
246 
247 		uint difference = (current - remainder);
248 		total += difference;
249 		remainder = current;
250 	}
251 
252 	/**
253 	 * Calculates the monthly period, starting after the startBlockTimestamp,
254 	 * periodAt will return 0 for all timestamps before startBlockTimestamp.
255 	 *
256 	 * Therefore period 0 is the range of time in which we have called start(),
257 	 * but have not yet passed startBlockTimestamp. Period 1 is the
258 	 * first monthly period, and so-forth all the way until the last
259 	 * period == periods.
260 	 *
261 	 * NOTE: not guarded since no state modifications are made. However,
262 	 * it will return invalid data before the postStart state. It is
263 	 * up to the user to manually check that the contract is in
264 	 * postStart state.
265 	 */
266 	function periodAt(uint _blockTimestamp) constant returns(uint) {
267 		/**
268 		 * Lower bound, consider period 0 to be the time between
269 		 * start() and startBlockTimestamp
270 		 */
271 		if (startBlockTimestamp > _blockTimestamp)
272 			return 0;
273 
274 		/**
275 		 * Calculate the appropriate period, and set an upper bound of
276 		 * periods - 1.
277 		 */
278 		uint p = ((_blockTimestamp - startBlockTimestamp) / intervalSecs) + 1;
279 		if (p > periods)
280 			p = periods;
281 		return p;
282 	}
283 
284 	// what withdrawal period are we in?
285 	// returns the period number from [0, periods)
286 	function period() constant returns(uint) {
287 		return periodAt(block.timestamp);
288 	}
289 
290 	// deposit your tokens to be saved
291 	//
292 	// the despositor must have approve()'d the tokens
293 	// to be transferred by this contract
294 	function deposit(uint tokens) onlyOwner notNullified {
295 		depositTo(msg.sender, tokens);
296 	}
297 
298 
299 	function depositTo(address beneficiary, uint tokens) onlyOwner preLock notNullified {
300 		require(token.transferFrom(msg.sender, this, tokens));
301 	    deposited[beneficiary] += tokens;
302 		totalfv += tokens;
303 		Deposit(beneficiary, tokens);
304 	}
305 
306 	// convenience function for owner: deposit on behalf of many
307 	function bulkDepositTo(uint256[] bits) onlyOwner {
308 		uint256 lomask = (1 << 96) - 1;
309 		for (uint i=0; i<bits.length; i++) {
310 			address a = address(bits[i]>>96);
311 			uint val = bits[i]&lomask;
312 			depositTo(a, val);
313 		}
314 	}
315 
316 	// withdraw withdraws tokens to the sender
317 	// withdraw can be called at most once per redemption period
318 	function withdraw() notNullified returns(bool) {
319 		return withdrawTo(msg.sender);
320 	}
321 
322 	/**
323 	 * Calculates the fraction of total (one-off + monthly) withdrawable
324 	 * given the current timestamp. No guards due to function being constant.
325 	 * Will output invalid data until the postStart state. It is up to the user
326 	 * to manually confirm contract is in postStart state.
327 	 */
328 	function availableForWithdrawalAt(uint256 blockTimestamp) constant returns (uint256) {
329 		/**
330 		 * Calculate the total withdrawable, giving a numerator with range:
331 		 * [0.25 * 10 ** 18, 1 * 10 ** 18]
332 		 */
333 		return ((t0special + periodAt(blockTimestamp)) * precision) / (t0special + periods);
334 	}
335 
336 	/**
337 	 * Business logic of _withdrawTo, the code is separated this way mainly for
338 	 * testing. We can inject and test parameters freely without worrying about the
339 	 * blockchain model.
340 	 *
341 	 * NOTE: Since function is constant, no guards are applied. This function will give
342 	 * invalid outputs unless in postStart state. It is up to user to manually check
343 	 * that the correct state is given (isStart() == true)
344 	 */
345 	function _withdrawTo(uint _deposit, uint _withdrawn, uint _blockTimestamp, uint _total) constant returns (uint) {
346 		uint256 fraction = availableForWithdrawalAt(_blockTimestamp);
347 
348 		/**
349 		 * There are concerns that the multiplication could possibly
350 		 * overflow, however this should not be the case if we calculate
351 		 * the upper bound based on our known parameters:
352 		 *
353 		 * Lets assume the minted token amount to be 500 million (reasonable),
354 		 * given a precision of 8 decimal places, we get:
355 		 * deposited[addr] = 5 * (10 ** 8) * (10 ** 8) = 5 * (10 ** 16)
356 		 *
357 		 * The max for fraction = 10 ** 18, and the max for total is
358 		 * also 5 * (10 ** 16).
359 		 *
360 		 * Therefore:
361 		 * deposited[addr] * fraction * total = 2.5 * (10 ** 51)
362 		 *
363 		 * The maximum for a uint256 is = 1.15 * (10 ** 77)
364 		 */
365 		uint256 withdrawable = ((_deposit * fraction * _total) / totalfv) / precision;
366 
367 		// check that we can withdraw something
368 		if (withdrawable > _withdrawn) {
369 			return withdrawable - _withdrawn;
370 		}
371 		return 0;
372 	}
373 
374 	/**
375 	 * Public facing withdrawTo, injects business logic with
376 	 * the correct model.
377 	 */
378 	function withdrawTo(address addr) postStart notNullified returns (bool) {
379 		uint _d = deposited[addr];
380 		uint _w = withdrawn[addr];
381 
382 		uint diff = _withdrawTo(_d, _w, block.timestamp, total);
383 
384 		// no withdrawal could be made
385 		if (diff == 0) {
386 			return false;
387 		}
388 
389 		// check that we cannot withdraw more than max
390 		require((diff + _w) <= ((_d * total) / totalfv));
391 
392 		// transfer and increment
393 		require(token.transfer(addr, diff));
394 
395 		withdrawn[addr] += diff;
396 		remainder -= diff;
397 		Withdraws(addr, diff);
398 		return true;
399 	}
400 
401 	// force withdrawal to many addresses
402 	function bulkWithdraw(address[] addrs) notNullified {
403 		for (uint i=0; i<addrs.length; i++)
404 			withdrawTo(addrs[i]);
405 	}
406 
407 	// Code off the chain informs this contract about
408 	// tokens that were minted to it on behalf of a depositor.
409 	//
410 	// Note: the function signature here is known to New Alchemy's
411 	// tooling, which is why it is arguably misnamed.
412 	uint public mintingNonce;
413 	function multiMint(uint nonce, uint256[] bits) onlyOwner preLock {
414 
415 		if (nonce != mintingNonce) return;
416 		mintingNonce += 1;
417 		uint256 lomask = (1 << 96) - 1;
418 		uint sum = 0;
419 		for (uint i=0; i<bits.length; i++) {
420 			address a = address(bits[i]>>96);
421 			uint value = bits[i]&lomask;
422 			deposited[a] += value;
423 			sum += value;
424 			Deposit(a, value);
425 		}
426 		totalfv += sum;
427 	}
428 }