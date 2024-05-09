1 //! By Parity Technologies, 2017.
2 //! Released under the Apache Licence 2.
3 
4 pragma solidity ^0.4.15;
5 
6 // ECR20 standard token interface
7 contract Token {
8 	event Transfer(address indexed from, address indexed to, uint256 value);
9 	event Approval(address indexed owner, address indexed spender, uint256 value);
10 
11 	function balanceOf(address _owner) constant returns (uint256 balance);
12 	function transfer(address _to, uint256 _value) returns (bool success);
13 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14 	function approve(address _spender, uint256 _value) returns (bool success);
15 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16 }
17 
18 // Owner-specific contract interface
19 contract Owned {
20 	event NewOwner(address indexed old, address indexed current);
21 
22 	modifier only_owner {
23 		require (msg.sender == owner);
24 		_;
25 	}
26 
27 	address public owner = msg.sender;
28 
29 	function setOwner(address _new) only_owner {
30 		NewOwner(owner, _new);
31 		owner = _new;
32 	}
33 }
34 
35 /// Stripped down certifier interface.
36 contract Certifier {
37 	function certified(address _who) constant returns (bool);
38 }
39 
40 // BasicCoin, ECR20 tokens that all belong to the owner for sending around
41 contract AmberToken is Token, Owned {
42 	struct Account {
43 		// Balance is always less than or equal totalSupply since totalSupply is increased straight away of when releasing locked tokens.
44 		uint balance;
45 		mapping (address => uint) allowanceOf;
46 
47 		// TokensPerPhase is always less than or equal to totalSupply since anything added to it is UNLOCK_PHASES times lower than added to totalSupply.
48 		uint tokensPerPhase;
49 		uint nextPhase;
50 	}
51 
52 	event Minted(address indexed who, uint value);
53 	event MintedLocked(address indexed who, uint value);
54 
55 	function AmberToken() {}
56 
57 	// Mint a certain number of tokens.
58 	// _value has to be bounded not to overflow.
59 	function mint(address _who, uint _value)
60 		only_owner
61 		public
62 	{
63 		accounts[_who].balance += _value;
64 		totalSupply += _value;
65 		Minted(_who, _value);
66 	}
67 
68 	// Mint a certain number of tokens that are locked up.
69 	// _value has to be bounded not to overflow.
70 	function mintLocked(address _who, uint _value)
71 		only_owner
72 		public
73 	{
74 		accounts[_who].tokensPerPhase += _value / UNLOCK_PHASES;
75 		totalSupply += _value;
76 		MintedLocked(_who, _value);
77 	}
78 
79 	/// Finalise any minting operations. Resets the owner and causes normal tokens
80 	/// to be liquid. Also begins the countdown for locked-up tokens.
81 	function finalise()
82 		only_owner
83 		public
84 	{
85 		locked = false;
86 		owner = 0;
87 		phaseStart = now;
88 	}
89 
90 	/// Return the current unlock-phase. Won't work until after the contract
91 	/// has `finalise()` called.
92 	function currentPhase()
93 		public
94 		constant
95 		returns (uint)
96 	{
97 		require (phaseStart > 0);
98 		uint p = (now - phaseStart) / PHASE_DURATION;
99 		return p > UNLOCK_PHASES ? UNLOCK_PHASES : p;
100 	}
101 
102 	/// Unlock any now freeable tokens that are locked up for account `_who`.
103 	function unlockTokens(address _who)
104 		public
105 	{
106 		uint phase = currentPhase();
107 		uint tokens = accounts[_who].tokensPerPhase;
108 		uint nextPhase = accounts[_who].nextPhase;
109 		if (tokens > 0 && phase > nextPhase) {
110 			accounts[_who].balance += tokens * (phase - nextPhase);
111 			accounts[_who].nextPhase = phase;
112 		}
113 	}
114 
115 	// Transfer tokens between accounts.
116 	function transfer(address _to, uint256 _value)
117 		when_owns(msg.sender, _value)
118 		when_liquid
119 		returns (bool)
120 	{
121 		Transfer(msg.sender, _to, _value);
122 		accounts[msg.sender].balance -= _value;
123 		accounts[_to].balance += _value;
124 
125 		return true;
126 	}
127 
128 	// Transfer via allowance.
129 	function transferFrom(address _from, address _to, uint256 _value)
130 		when_owns(_from, _value)
131 		when_has_allowance(_from, msg.sender, _value)
132 		when_liquid
133 		returns (bool)
134 	{
135 		Transfer(_from, _to, _value);
136 		accounts[_from].allowanceOf[msg.sender] -= _value;
137 		accounts[_from].balance -= _value;
138 		accounts[_to].balance += _value;
139 
140 		return true;
141 	}
142 
143 	// Approve allowances
144 	function approve(address _spender, uint256 _value)
145 		when_liquid
146 		returns (bool)
147 	{
148 		// Mitigate the race condition described here:
149 		// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150 		require (_value == 0 || accounts[msg.sender].allowanceOf[_spender] == 0);
151 		Approval(msg.sender, _spender, _value);
152 		accounts[msg.sender].allowanceOf[_spender] = _value;
153 
154 		return true;
155 	}
156 
157 	// Get the balance of a specific address.
158 	function balanceOf(address _who) constant returns (uint256) {
159 		return accounts[_who].balance;
160 	}
161 
162 	// Available allowance
163 	function allowance(address _owner, address _spender)
164 		constant
165 		returns (uint256)
166 	{
167 		return accounts[_owner].allowanceOf[_spender];
168 	}
169 
170 	// The balance should be available
171 	modifier when_owns(address _owner, uint _amount) {
172 		require (accounts[_owner].balance >= _amount);
173 		_;
174 	}
175 
176 	// An allowance should be available
177 	modifier when_has_allowance(address _owner, address _spender, uint _amount) {
178 		require (accounts[_owner].allowanceOf[_spender] >= _amount);
179 		_;
180 	}
181 
182 	// Tokens must not be locked.
183 	modifier when_liquid {
184 		require (!locked);
185 		_;
186 	}
187 
188 	/// Usual token descriptors.
189 	string constant public name = "Amber Token";
190 	uint8 constant public decimals = 18;
191 	string constant public symbol = "AMB";
192 
193 	// Are the tokens non-transferrable?
194 	bool public locked = true;
195 
196 	// Phase information for slow-release tokens.
197 	uint public phaseStart = 0;
198 	uint public constant PHASE_DURATION = 180 days;
199 	uint public constant UNLOCK_PHASES = 4;
200 
201 	// available token supply
202 	uint public totalSupply;
203 
204 	// storage and mapping of all balances & allowances
205 	mapping (address => Account) accounts;
206 }
207 
208 /// Will accept Ether "contributions" and record each both as a log and in a
209 /// queryable record.
210 contract AmbrosusSale {
211 	/// Constructor.
212 	function AmbrosusSale() {
213 		tokens = new AmberToken();
214 	}
215 
216 	// Can only be called by the administrator.
217 	modifier only_admin { require (msg.sender == ADMINISTRATOR); _; }
218 	// Can only be called by the prepurchaser.
219 	modifier only_prepurchaser { require (msg.sender == PREPURCHASER); _; }
220 
221 	// The transaction params are valid for buying in.
222 	modifier is_valid_buyin { require (tx.gasprice <= MAX_BUYIN_GAS_PRICE && msg.value >= MIN_BUYIN_VALUE); _; }
223 	// Requires the hard cap to be respected given the desired amount for `buyin`.
224 	modifier is_under_cap_with(uint buyin) { require (buyin + saleRevenue <= MAX_REVENUE); _; }
225 	// Requires sender to be certified.
226 	modifier only_certified(address who) { require (CERTIFIER.certified(who)); _; }
227 
228 	/*
229 		Sale life cycle:
230 		1. Not yet started.
231 		2. Started, further purchases possible.
232 			a. Normal operation (next step can be 2b or 3)
233 			b. Paused (next step can be 2a or 3)
234 		3. Complete (equivalent to Allocation Lifecycle 2 & 3).
235 	*/
236 
237 	// Can only be called by prior to the period (1).
238 	modifier only_before_period { require (now < BEGIN_TIME); _; }
239 	// Can only be called during the period when not paused (2a).
240 	modifier only_during_period { require (now >= BEGIN_TIME && now < END_TIME && !isPaused); _; }
241 	// Can only be called during the period when paused (2b)
242 	modifier only_during_paused_period { require (now >= BEGIN_TIME && now < END_TIME && isPaused); _; }
243 	// Can only be called after the period (3).
244 	modifier only_after_sale { require (now >= END_TIME || saleRevenue >= MAX_REVENUE); _; }
245 
246 	/*
247 		Allocation life cycle:
248 		1. Uninitialised (sale not yet started/ended, equivalent to Sale Lifecycle 1 & 2).
249 		2. Initialised, not yet completed (further allocations possible).
250 		3. Completed (no further allocations possible).
251 	*/
252 
253 	// Only when allocations have not yet been initialised (1).
254 	modifier when_allocations_uninitialised { require (!allocationsInitialised); _; }
255 	// Only when sufficient allocations remain for making this liquid allocation (2).
256 	modifier when_allocatable_liquid(uint amount) { require (liquidAllocatable >= amount); _; }
257 	// Only when sufficient allocations remain for making this locked allocation (2).
258 	modifier when_allocatable_locked(uint amount) { require (lockedAllocatable >= amount); _; }
259 	// Only when no further allocations are possible (3).
260 	modifier when_allocations_complete { require (allocationsInitialised && liquidAllocatable == 0 && lockedAllocatable == 0); _; }
261 
262 	/// Note a pre-ICO sale.
263 	event Prepurchased(address indexed recipient, uint etherPaid, uint amberSold);
264 	/// Some contribution `amount` received from `recipient`.
265 	event Purchased(address indexed recipient, uint amount);
266 	/// Some contribution `amount` received from `recipient`.
267 	event SpecialPurchased(address indexed recipient, uint etherPaid, uint amberSold);
268 	/// Period paused abnormally.
269 	event Paused();
270 	/// Period restarted after abnormal halt.
271 	event Unpaused();
272 	/// Some contribution `amount` received from `recipient`.
273 	event Allocated(address indexed recipient, uint amount, bool liquid);
274 
275 	/// Note a prepurchase that has already happened.
276 	/// Up to owner to ensure that values do not overflow.
277 	///
278 	/// Preconditions: !sale_started
279 	/// Writes {Tokens, Sale}
280 	function notePrepurchase(address _who, uint _etherPaid, uint _amberSold)
281 		only_prepurchaser
282 		only_before_period
283 		public
284 	{
285 		// Admin ensures bounded value.
286 		tokens.mint(_who, _amberSold);
287 		saleRevenue += _etherPaid;
288 		totalSold += _amberSold;
289 		Prepurchased(_who, _etherPaid, _amberSold);
290 	}
291 
292 	/// Make a purchase from a privileged account. No KYC is required and a
293 	/// preferential buyin rate may be given.
294 	///
295 	/// Preconditions: !paused, sale_ongoing
296 	/// Postconditions: !paused, ?!sale_ongoing
297 	/// Writes {Tokens, Sale}
298 	function specialPurchase()
299 		only_before_period
300 		is_under_cap_with(msg.value)
301 		payable
302 		public
303 	{
304 		uint256 bought = buyinReturn(msg.sender) * msg.value;
305 		require (bought > 0);   // be kind and don't punish the idiots.
306 
307 		// Bounded value, see STANDARD_BUYIN.
308 		tokens.mint(msg.sender, bought);
309 		TREASURY.transfer(msg.value);
310 		saleRevenue += msg.value;
311 		totalSold += bought;
312 		SpecialPurchased(msg.sender, msg.value, bought);
313    }
314 
315 	/// Let sender make a purchase to their account.
316 	///
317 	/// Preconditions: !paused, sale_ongoing
318 	/// Postconditions: ?!sale_ongoing
319 	/// Writes {Tokens, Sale}
320 	function ()
321 		only_certified(msg.sender)
322 		payable
323 		public
324 	{
325 		processPurchase(msg.sender);
326 	}
327 
328 	/// Let sender make a standard purchase; AMB goes into another account.
329 	///
330 	/// Preconditions: !paused, sale_ongoing
331 	/// Postconditions: ?!sale_ongoing
332 	/// Writes {Tokens, Sale}
333 	function purchaseTo(address _recipient)
334 		only_certified(msg.sender)
335 		payable
336 		public
337 	{
338 		processPurchase(_recipient);
339 	}
340 
341 	/// Receive a contribution from `_recipient`.
342 	///
343 	/// Preconditions: !paused, sale_ongoing
344 	/// Postconditions: ?!sale_ongoing
345 	/// Writes {Tokens, Sale}
346 	function processPurchase(address _recipient)
347 		only_during_period
348 		is_valid_buyin
349 		is_under_cap_with(msg.value)
350 		private
351 	{
352 		// Bounded value, see STANDARD_BUYIN.
353 		tokens.mint(_recipient, msg.value * STANDARD_BUYIN);
354 		TREASURY.transfer(msg.value);
355 		saleRevenue += msg.value;
356 		totalSold += msg.value * STANDARD_BUYIN;
357 		Purchased(_recipient, msg.value);
358 	}
359 
360 	/// Determine purchase price for a given address.
361 	function buyinReturn(address _who)
362 		constant
363 		public
364 		returns (uint)
365 	{
366 		// Chinese exchanges.
367 		if (
368 			_who == CHINESE_EXCHANGE_1 || _who == CHINESE_EXCHANGE_2 ||
369 			_who == CHINESE_EXCHANGE_3 || _who == CHINESE_EXCHANGE_4
370 		)
371 			return CHINESE_EXCHANGE_BUYIN;
372 
373 		// BTCSuisse tier 1
374 		if (_who == BTC_SUISSE_TIER_1)
375 			return STANDARD_BUYIN;
376 		// BTCSuisse tier 2
377 		if (_who == BTC_SUISSE_TIER_2)
378 			return TIER_2_BUYIN;
379 		// BTCSuisse tier 3
380 		if (_who == BTC_SUISSE_TIER_3)
381 			return TIER_3_BUYIN;
382 		// BTCSuisse tier 4
383 		if (_who == BTC_SUISSE_TIER_4)
384 			return TIER_4_BUYIN;
385 
386 		return 0;
387 	}
388 
389 	/// Halt the contribution period. Any attempt at contributing will fail.
390 	///
391 	/// Preconditions: !paused, sale_ongoing
392 	/// Postconditions: paused
393 	/// Writes {Paused}
394 	function pause()
395 		only_admin
396 		only_during_period
397 		public
398 	{
399 		isPaused = true;
400 		Paused();
401 	}
402 
403 	/// Unhalt the contribution period.
404 	///
405 	/// Preconditions: paused
406 	/// Postconditions: !paused
407 	/// Writes {Paused}
408 	function unpause()
409 		only_admin
410 		only_during_paused_period
411 		public
412 	{
413 		isPaused = false;
414 		Unpaused();
415 	}
416 
417 	/// Called once by anybody after the sale ends.
418 	/// Initialises the specific values (i.e. absolute token quantities) of the
419 	/// allowed liquid/locked allocations.
420 	///
421 	/// Preconditions: !allocations_initialised
422 	/// Postconditions: allocations_initialised, !allocations_complete
423 	/// Writes {Allocations}
424 	function initialiseAllocations()
425 		public
426 		only_after_sale
427 		when_allocations_uninitialised
428 	{
429 		allocationsInitialised = true;
430 		liquidAllocatable = LIQUID_ALLOCATION_PPM * totalSold / SALES_ALLOCATION_PPM;
431 		lockedAllocatable = LOCKED_ALLOCATION_PPM * totalSold / SALES_ALLOCATION_PPM;
432 	}
433 
434 	/// Preallocate a liquid portion of tokens.
435 	/// Admin may call this to allocate a share of the liquid tokens.
436 	/// Up to admin to ensure that value does not overflow.
437 	///
438 	/// Preconditions: allocations_initialised
439 	/// Postconditions: ?allocations_complete
440 	/// Writes {Allocations, Tokens}
441 	function allocateLiquid(address _who, uint _value)
442 		only_admin
443 		when_allocatable_liquid(_value)
444 		public
445 	{
446 		// Admin ensures bounded value.
447 		tokens.mint(_who, _value);
448 		liquidAllocatable -= _value;
449 		Allocated(_who, _value, true);
450 	}
451 
452 	/// Preallocate a locked-up portion of tokens.
453 	/// Admin may call this to allocate a share of the locked tokens.
454 	/// Up to admin to ensure that value does not overflow and _value is divisible by UNLOCK_PHASES.
455 	///
456 	/// Preconditions: allocations_initialised
457 	/// Postconditions: ?allocations_complete
458 	/// Writes {Allocations, Tokens}
459 	function allocateLocked(address _who, uint _value)
460 		only_admin
461 		when_allocatable_locked(_value)
462 		public
463 	{
464 		// Admin ensures bounded value.
465 		tokens.mintLocked(_who, _value);
466 		lockedAllocatable -= _value;
467 		Allocated(_who, _value, false);
468 	}
469 
470 	/// End of the sale and token allocation; retire this contract.
471 	/// Once called, no more tokens can be minted, basic tokens are now liquid.
472 	/// Anyone can call, but only once this contract can properly be retired.
473 	///
474 	/// Preconditions: allocations_complete
475 	/// Postconditions: liquid_tokens_transferable, this_is_dead
476 	/// Writes {Tokens}
477 	function finalise()
478 		when_allocations_complete
479 		public
480 	{
481 		tokens.finalise();
482 	}
483 
484 	//////
485 	// STATE
486 	//////
487 
488 	// How much is enough?
489 	uint public constant MIN_BUYIN_VALUE = 1;
490 	// Max gas price for buyins.
491 	uint public constant MAX_BUYIN_GAS_PRICE = 25000000000;
492 	// The exposed hard cap.
493 	uint public constant MAX_REVENUE = 328103 ether;
494 
495 	// The total share of tokens, expressed in PPM, allocated to pre-ICO and ICO.
496 	uint constant public SALES_ALLOCATION_PPM = 400000;
497 	// The total share of tokens, expressed in PPM, the admin may later allocate, as locked tokens.
498 	uint constant public LOCKED_ALLOCATION_PPM = 337000;
499 	// The total share of tokens, expressed in PPM, the admin may later allocate, as liquid tokens.
500 	uint constant public LIQUID_ALLOCATION_PPM = 263000;
501 
502 	/// The certifier resource. TODO: set address
503 	Certifier public constant CERTIFIER = Certifier(0x7b1Ab331546F021A40bd4D09fFb802261CaACcc9);
504 	// Who can halt/unhalt/kill?
505 	address public constant ADMINISTRATOR = 0x11bF17B890a80080A8F9C1673D2951296a6F3D91;
506 	// Who can prepurchase?
507 	address public constant PREPURCHASER = 0x00C269e9D02188E39C9922386De631c6AED5b4d4;
508 	// Who gets the stash? Should not release funds during minting process.
509 	address public constant TREASURY = 0xB47aD434C6e401473F1d3442001Ac69cda1dcFDd;
510 	// When does the contribution period begin?
511 	uint public constant BEGIN_TIME = 1506081600;
512 	// How long does the sale last for?
513 	uint public constant DURATION = 30 days;
514 	// When does the period end?
515 	uint public constant END_TIME = BEGIN_TIME + DURATION;
516 
517 	// The privileged buyin accounts.
518 	address public constant BTC_SUISSE_TIER_1 = 0x53B3D4f98fcb6f0920096fe1cCCa0E4327Da7a1D;
519 	address public constant BTC_SUISSE_TIER_2 = 0x642fDd12b1Dd27b9E19758F0AefC072dae7Ab996;
520 	address public constant BTC_SUISSE_TIER_3 = 0x64175446A1e3459c3E9D650ec26420BA90060d28;
521 	address public constant BTC_SUISSE_TIER_4 = 0xB17C2f9a057a2640309e41358a22Cf00f8B51626;
522 	address public constant CHINESE_EXCHANGE_1 = 0x36f548fAB37Fcd39cA8725B8fA214fcd784FE0A3;
523 	address public constant CHINESE_EXCHANGE_2 = 0x877Da872D223AB3D073Ab6f9B4bb27540E387C5F;
524 	address public constant CHINESE_EXCHANGE_3 = 0xCcC088ec38A4dbc15Ba269A176883F6ba302eD8d;
525 	// TODO: set address
526 	address public constant CHINESE_EXCHANGE_4 = 0;
527 
528 	// Tokens per eth for the various buy-in rates.
529 	// 1e8 ETH in existence, means at most 1.5e11 issued.
530 	uint public constant STANDARD_BUYIN = 1000;
531 	uint public constant TIER_2_BUYIN = 1111;
532 	uint public constant TIER_3_BUYIN = 1250;
533 	uint public constant TIER_4_BUYIN = 1429;
534 	uint public constant CHINESE_EXCHANGE_BUYIN = 1087;
535 
536 	//////
537 	// State Subset: Allocations
538 	//
539 	// Invariants:
540 	// !allocationsInitialised ||
541 	//   (liquidAllocatable + tokens.liquidAllocated) / LIQUID_ALLOCATION_PPM == totalSold / SALES_ALLOCATION_PPM &&
542 	//   (lockedAllocatable + tokens.lockedAllocated) / LOCKED_ALLOCATION_PPM == totalSold / SALES_ALLOCATION_PPM
543 	//
544 	// when_allocations_complete || (now < END_TIME && saleRevenue < MAX_REVENUE)
545 
546 	// Have post-sale token allocations been initialised?
547 	bool public allocationsInitialised = false;
548 	// How many liquid tokens may yet be allocated?
549 	uint public liquidAllocatable;
550 	// How many locked tokens may yet be allocated?
551 	uint public lockedAllocatable;
552 
553 	//////
554 	// State Subset: Sale
555 	//
556 	// Invariants:
557 	// saleRevenue <= MAX_REVENUE
558 
559 	// Total amount raised in both presale and sale, in Wei.
560 	// Assuming TREASURY locks funds, so can not exceed total amount of Ether 1e8.
561 	uint public saleRevenue = 0;
562 	// Total amount minted in both presale and sale, in AMB * 10^-18.
563 	// Assuming the TREASURY locks funds, msg.value * STANDARD_BUYIN will be less than 1.5e11.
564 	uint public totalSold = 0;
565 
566 	//////
567 	// State Subset: Tokens
568 
569 	// The contract which gets called whenever anything is received.
570 	AmberToken public tokens;
571 
572 	//////
573 	// State Subset: Pause
574 
575 	// Are contributions abnormally paused?
576 	bool public isPaused = false;
577 }