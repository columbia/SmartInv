1 pragma solidity ^0.4.19;
2 
3 // File: contracts/ClaimRegistry.sol
4 
5 contract ClaimRegistry {
6     function getSingleSubjectByAddress(address linkedAddress, uint subjectIndex) public view returns(address subject);
7     function getSubjectClaimSetSize(address subject, uint typeNameIx, uint attrNameIx) public constant returns (uint) ;
8     function getSubjectClaimSetEntryAt(address subject, uint typeNameIx, uint attrNameIx, uint ix) public constant returns (address issuer, uint url);
9     function getSubjectCountByAddress(address linkedAddress) public view returns(uint subjectCount);
10  }
11 
12 // File: contracts/NotakeyVerifierForICOP.sol
13 
14 contract NotakeyVerifierForICOP {
15 
16     uint public constant ICO_CONTRIBUTOR_TYPE = 6;
17     uint public constant REPORT_BUNDLE = 6;
18     uint public constant NATIONALITY_INDEX = 7;
19 
20     address public claimRegistryAddr;
21     address public trustedIssuerAddr;
22     // address private callerIdentitySubject;
23 
24     uint public constant USA = 883423532389192164791648750371459257913741948437809479060803100646309888;
25         // USA is 240nd; blacklist: 1 << (240-1)
26     uint public constant CHINA = 8796093022208;
27         // China is 44th; blacklist: 1 << (44-1)
28     uint public constant SOUTH_KOREA = 83076749736557242056487941267521536;
29         // SK is 117th; blacklist: 1 << (117-1)
30 
31      event GotUnregisteredPaymentAddress(address indexed paymentAddress);
32 
33 
34     function NotakeyVerifierForICOP(address _trustedIssuerAddr, address _claimRegistryAddr) public {
35         claimRegistryAddr = _claimRegistryAddr;
36         trustedIssuerAddr  = _trustedIssuerAddr;
37     }
38 
39     modifier onlyVerifiedSenders(address paymentAddress, uint256 nationalityBlacklist) {
40         // DISABLED for ICOP sale
41         // require(_hasIcoContributorType(paymentAddress));
42         require(!_preventedByNationalityBlacklist(paymentAddress, nationalityBlacklist));
43 
44         _;
45     }
46 
47     function sanityCheck() public pure returns (string) {
48         return "Hello Dashboard";
49     }
50 
51     function isVerified(address subject, uint256 nationalityBlacklist) public constant onlyVerifiedSenders(subject, nationalityBlacklist) returns (bool) {
52         return true;
53     }
54 
55     function _preventedByNationalityBlacklist(
56         address paymentAddress,
57         uint256 nationalityBlacklist) internal constant returns (bool)
58     {
59         var claimRegistry = ClaimRegistry(claimRegistryAddr);
60 
61         uint subjectCount = _lookupOwnerIdentityCount(paymentAddress);
62 
63         uint256 ignoredClaims;
64         uint claimCount;
65         address subject;
66 
67         // Loop over all isued identities associated to this wallet adress and
68         // throw if any match to blacklist
69         for (uint subjectIndex = 0 ; subjectIndex < subjectCount ; subjectIndex++ ){
70             subject = claimRegistry.getSingleSubjectByAddress(paymentAddress, subjectIndex);
71             claimCount = claimRegistry.getSubjectClaimSetSize(subject, ICO_CONTRIBUTOR_TYPE, NATIONALITY_INDEX);
72             ignoredClaims = 0;
73 
74             for (uint i = 0; i < claimCount; ++i) {
75                 var (issuer, url) = claimRegistry.getSubjectClaimSetEntryAt(subject, ICO_CONTRIBUTOR_TYPE, NATIONALITY_INDEX, i);
76                 var countryMask = 2**(url-1);
77 
78                 if (issuer != trustedIssuerAddr) {
79                     ignoredClaims += 1;
80                 } else {
81                     if (((countryMask ^ nationalityBlacklist) & countryMask) != countryMask) {
82                         return true;
83                     }
84                 }
85             }
86         }
87 
88         // If the blacklist is empty (0), then that's fine for the V1 contract (where we validate the bundle);
89         // For our own sale, however, this attribute is a proxy indicator for whether the address is verified.
90         //
91         // Account for ignored claims (issued by unrecognized issuers)
92         require((claimCount - ignoredClaims) > 0);
93 
94         return false;
95     }
96 
97     function _lookupOwnerIdentityCount(address paymentAddress) internal constant returns (uint){
98         var claimRegistry = ClaimRegistry(claimRegistryAddr);
99         var subjectCount = claimRegistry.getSubjectCountByAddress(paymentAddress);
100 
101         // The address is unregistered so we throw and log event
102         // This method and callers have to overriden as non-constant to emit events
103         // if ( subjectCount == 0 ) {
104             // GotUnregisteredPaymentAddress( paymentAddress );
105             // revert();
106         // }
107 
108         require(subjectCount > 0);
109 
110         return subjectCount;
111     }
112 
113     function _hasIcoContributorType(address paymentAddress) internal constant returns (bool)
114     {
115         uint subjectCount = _lookupOwnerIdentityCount(paymentAddress);
116 
117         var atLeastOneValidReport = false;
118         var atLeastOneValidNationality = false;
119         address subject;
120 
121         var claimRegistry = ClaimRegistry(claimRegistryAddr);
122 
123         // Loop over all isued identities associated to this wallet address and
124         // exit loop any satisfy the business logic requirement
125         for (uint subjectIndex = 0 ; subjectIndex < subjectCount ; subjectIndex++ ){
126             subject = claimRegistry.getSingleSubjectByAddress(paymentAddress, subjectIndex);
127 
128             var nationalityCount = claimRegistry.getSubjectClaimSetSize(subject, ICO_CONTRIBUTOR_TYPE, NATIONALITY_INDEX);
129             for (uint nationalityIndex = 0; nationalityIndex < nationalityCount; ++nationalityIndex) {
130                 var (nationalityIssuer,) = claimRegistry.getSubjectClaimSetEntryAt(subject, ICO_CONTRIBUTOR_TYPE, NATIONALITY_INDEX, nationalityIndex);
131                 if (nationalityIssuer == trustedIssuerAddr) {
132                     atLeastOneValidNationality = true;
133                     break;
134                 }
135             }
136 
137             var reportCount = claimRegistry.getSubjectClaimSetSize(subject, ICO_CONTRIBUTOR_TYPE, REPORT_BUNDLE);
138             for (uint reportIndex = 0; reportIndex < reportCount; ++reportIndex) {
139                 var (reportIssuer,) = claimRegistry.getSubjectClaimSetEntryAt(subject, ICO_CONTRIBUTOR_TYPE, REPORT_BUNDLE, reportIndex);
140                 if (reportIssuer == trustedIssuerAddr) {
141                     atLeastOneValidReport = true;
142                     break;
143                 }
144             }
145         }
146 
147         return atLeastOneValidNationality && atLeastOneValidReport;
148     }
149 }
150 
151 // File: contracts/SecondPriceAuction.sol
152 
153 //! Copyright Parity Technologies, 2017.
154 //! (original version: https://github.com/paritytech/second-price-auction)
155 //!
156 //! Copyright Notakey Latvia SIA, 2017.
157 //! Original version modified to verify contributors against Notakey
158 //! KYC smart contract.
159 //!
160 //! Released under the Apache Licence 2.
161 
162 pragma solidity ^0.4.19;
163 
164 
165 
166 /// Stripped down ERC20 standard token interface.
167 contract Token {
168   function transferFrom(address from, address to, uint256 value) public returns (bool);
169 }
170 
171 /// Simple modified second price auction contract. Price starts high and monotonically decreases
172 /// until all tokens are sold at the current price with currently received funds.
173 /// The price curve has been chosen to resemble a logarithmic curve
174 /// and produce a reasonable auction timeline.
175 contract SecondPriceAuction {
176 	// Events:
177 
178 	/// Someone bought in at a particular max-price.
179 	event Buyin(address indexed who, uint accounted, uint received, uint price);
180 
181 	/// Admin injected a purchase.
182 	event Injected(address indexed who, uint accounted, uint received);
183 
184 	/// At least 5 minutes has passed since last Ticked event.
185 	event Ticked(uint era, uint received, uint accounted);
186 
187 	/// The sale just ended with the current price.
188 	event Ended(uint price);
189 
190 	/// Finalised the purchase for `who`, who has been given `tokens` tokens.
191 	event Finalised(address indexed who, uint tokens);
192 
193 	/// Auction is over. All accounts finalised.
194 	event Retired();
195 
196 	// Constructor:
197 
198 	/// Simple constructor.
199 	/// Token cap should take be in smallest divisible units.
200 	/// 	NOTE: original SecondPriceAuction contract stipulates token cap must be given in whole tokens.
201 	///		This does not seem correct, as only whole token values are transferred via transferFrom (which - in our wallet's case -
202 	///     expects transfers in the smallest divisible amount)
203 	function SecondPriceAuction(
204 		address _trustedClaimIssuer,
205 		address _notakeyClaimRegistry,
206 		address _tokenContract,
207 		address _treasury,
208 		address _admin,
209 		uint _beginTime,
210 		uint _tokenCap
211 	)
212 		public
213 	{
214 		// this contract must be created by the notakey claim issuer (sender)
215 		verifier = new NotakeyVerifierForICOP(_trustedClaimIssuer, _notakeyClaimRegistry);
216 
217 		tokenContract = Token(_tokenContract);
218 		treasury = _treasury;
219 		admin = _admin;
220 		beginTime = _beginTime;
221 		tokenCap = _tokenCap;
222 		endTime = beginTime + DEFAULT_AUCTION_LENGTH;
223 	}
224 
225 	function() public payable { buyin(); }
226 
227 	// Public interaction:
228 	function moveStartDate(uint newStart)
229 		public
230 		before_beginning
231 		only_admin
232 	{
233 		beginTime = newStart;
234 		endTime = calculateEndTime();
235 	}
236 
237 	/// Buyin function. Throws if the sale is not active and when refund would be needed.
238 	function buyin()
239 		public
240 		payable
241 		when_not_halted
242 		when_active
243 		only_eligible(msg.sender)
244 	{
245 		flushEra();
246 
247 		// Flush bonus period:
248 		if (currentBonus > 0) {
249 			// Bonus is currently active...
250 			if (now >= beginTime + BONUS_MIN_DURATION				// ...but outside the automatic bonus period
251 				&& lastNewInterest + BONUS_LATCH <= block.number	// ...and had no new interest for some blocks
252 			) {
253 				currentBonus--;
254 			}
255 			if (now >= beginTime + BONUS_MAX_DURATION) {
256 				currentBonus = 0;
257 			}
258 			if (buyins[msg.sender].received == 0) {	// We have new interest
259 				lastNewInterest = uint32(block.number);
260 			}
261 		}
262 
263 		uint accounted;
264 		bool refund;
265 		uint price;
266 		(accounted, refund, price) = theDeal(msg.value);
267 
268 		/// No refunds allowed.
269 		require (!refund);
270 
271 		// record the acceptance.
272 		buyins[msg.sender].accounted += uint128(accounted);
273 		buyins[msg.sender].received += uint128(msg.value);
274 		totalAccounted += accounted;
275 		totalReceived += msg.value;
276 		endTime = calculateEndTime();
277 		Buyin(msg.sender, accounted, msg.value, price);
278 
279 		// send to treasury
280 		treasury.transfer(msg.value);
281 	}
282 
283 	/// Like buyin except no payment required and bonus automatically given.
284 	function inject(address _who, uint128 _received)
285 		public
286 		only_admin
287 		only_basic(_who)
288 		before_beginning
289 	{
290 		uint128 bonus = _received * uint128(currentBonus) / 100;
291 		uint128 accounted = _received + bonus;
292 
293 		buyins[_who].accounted += accounted;
294 		buyins[_who].received += _received;
295 		totalAccounted += accounted;
296 		totalReceived += _received;
297 		endTime = calculateEndTime();
298 		Injected(_who, accounted, _received);
299 	}
300 
301 	/// Mint tokens for a particular participant.
302 	function finalise(address _who)
303 		public
304 		when_not_halted
305 		when_ended
306 		only_buyins(_who)
307 	{
308 		// end the auction if we're the first one to finalise.
309 		if (endPrice == 0) {
310 			endPrice = totalAccounted / tokenCap;
311 			Ended(endPrice);
312 		}
313 
314 		// enact the purchase.
315 		uint total = buyins[_who].accounted;
316 		uint tokens = total / endPrice;
317 		totalFinalised += total;
318 		delete buyins[_who];
319 		require (tokenContract.transferFrom(treasury, _who, tokens));
320 
321 		Finalised(_who, tokens);
322 
323 		if (totalFinalised == totalAccounted) {
324 			Retired();
325 		}
326 	}
327 
328 	// Prviate utilities:
329 
330 	/// Ensure the era tracker is prepared in case the current changed.
331 	function flushEra() private {
332 		uint currentEra = (now - beginTime) / ERA_PERIOD;
333 		if (currentEra > eraIndex) {
334 			Ticked(eraIndex, totalReceived, totalAccounted);
335 		}
336 		eraIndex = currentEra;
337 	}
338 
339 	// Admin interaction:
340 
341 	/// Emergency function to pause buy-in and finalisation.
342 	function setHalted(bool _halted) public only_admin { halted = _halted; }
343 
344 	/// Emergency function to drain the contract of any funds.
345 	function drain() public only_admin { treasury.transfer(this.balance); }
346 
347 	// Inspection:
348 
349 	/// The current end time of the sale assuming that nobody else buys in.
350 	function calculateEndTime() public constant returns (uint) {
351 		var factor = tokenCap / DIVISOR * EURWEI;
352 		uint16 scaleDownRatio = 1; // 1 for prod
353 		return beginTime + (182035 * factor / (totalAccounted + factor / 10 ) - 0) / scaleDownRatio;
354 	}
355 
356 	/// The current price for a single indivisible part of a token. If a buyin happens now, this is
357 	/// the highest price per indivisible token part that the buyer will pay. This doesn't
358 	/// include the discount which may be available.
359 	function currentPrice() public constant when_active returns (uint weiPerIndivisibleTokenPart) {
360 		return ((EURWEI * 184325000 / (now - beginTime + 5760) - EURWEI*5) / DIVISOR);
361 	}
362 
363 	/// Returns the total indivisible token parts available for purchase right now.
364 	function tokensAvailable() public constant when_active returns (uint tokens) {
365 		uint _currentCap = totalAccounted / currentPrice();
366 		if (_currentCap >= tokenCap) {
367 			return 0;
368 		}
369 		return tokenCap - _currentCap;
370 	}
371 
372 	/// The largest purchase than can be made at present, not including any
373 	/// discount.
374 	function maxPurchase() public constant when_active returns (uint spend) {
375 		return tokenCap * currentPrice() - totalAccounted;
376 	}
377 
378 	/// Get the number of `tokens` that would be given if the sender were to
379 	/// spend `_value` now. Also tell you what `refund` would be given, if any.
380 	function theDeal(uint _value)
381 		public
382 		constant
383 		when_active
384 		returns (uint accounted, bool refund, uint price)
385 	{
386 		uint _bonus = bonus(_value);
387 
388 		price = currentPrice();
389 		accounted = _value + _bonus;
390 
391 		uint available = tokensAvailable();
392 		uint tokens = accounted / price;
393 		refund = (tokens > available);
394 	}
395 
396 	/// Any applicable bonus to `_value`.
397 	function bonus(uint _value)
398 		public
399 		constant
400 		when_active
401 		returns (uint extra)
402 	{
403 		return _value * uint(currentBonus) / 100;
404 	}
405 
406 	/// True if the sale is ongoing.
407 	function isActive() public constant returns (bool) { return now >= beginTime && now < endTime; }
408 
409 	/// True if all buyins have finalised.
410 	function allFinalised() public constant returns (bool) { return now >= endTime && totalAccounted == totalFinalised; }
411 
412 	/// Returns true if the sender of this transaction is a basic account.
413 	function isBasicAccount(address _who) internal constant returns (bool) {
414 		uint senderCodeSize;
415 		assembly {
416 			senderCodeSize := extcodesize(_who)
417 		}
418 	    return senderCodeSize == 0;
419 	}
420 
421 	// Modifiers:
422 
423 	/// Ensure the sale is ongoing.
424 	modifier when_active { require (isActive()); _; }
425 
426 	/// Ensure the sale has not begun.
427 	modifier before_beginning { require (now < beginTime); _; }
428 
429 	/// Ensure the sale is ended.
430 	modifier when_ended { require (now >= endTime); _; }
431 
432 	/// Ensure we're not halted.
433 	modifier when_not_halted { require (!halted); _; }
434 
435 	/// Ensure `_who` is a participant.
436 	modifier only_buyins(address _who) { require (buyins[_who].accounted != 0); _; }
437 
438 	/// Ensure sender is admin.
439 	modifier only_admin { require (msg.sender == admin); _; }
440 
441 	/// Ensure that the signature is valid, `who` is a certified, basic account,
442 	/// the gas price is sufficiently low and the value is sufficiently high.
443 	modifier only_eligible(address who) {
444 		require (
445 			verifier.isVerified(who, verifier.USA() | verifier.CHINA() | verifier.SOUTH_KOREA()) &&
446 			isBasicAccount(who) &&
447 			msg.value >= DUST_LIMIT
448 		);
449 		_;
450 	}
451 
452 	/// Ensure sender is not a contract.
453 	modifier only_basic(address who) { require (isBasicAccount(who)); _; }
454 
455 	// State:
456 
457 	struct Account {
458 		uint128 accounted;	// including bonus & hit
459 		uint128 received;	// just the amount received, without bonus & hit
460 	}
461 
462 	/// Those who have bought in to the auction.
463 	mapping (address => Account) public buyins;
464 
465 	/// Total amount of ether received, excluding phantom "bonus" ether.
466 	uint public totalReceived = 0;
467 
468 	/// Total amount of ether accounted for, including phantom "bonus" ether.
469 	uint public totalAccounted = 0;
470 
471 	/// Total amount of ether which has been finalised.
472 	uint public totalFinalised = 0;
473 
474 	/// The current end time. Gets updated when new funds are received.
475 	uint public endTime;
476 
477 	/// The price per token; only valid once the sale has ended and at least one
478 	/// participant has finalised.
479 	uint public endPrice;
480 
481 	/// Must be false for any public function to be called.
482 	bool public halted;
483 
484 	/// The current percentage of bonus that purchasers get.
485 	uint8 public currentBonus = 15;
486 
487 	/// The last block that had a new participant.
488 	uint32 public lastNewInterest;
489 
490 	// Constants after constructor:
491 
492 	/// The tokens contract.
493 	Token public tokenContract;
494 
495 	/// The Notakey verifier contract.
496 	NotakeyVerifierForICOP public verifier;
497 
498 	/// The treasury address; where all the Ether goes.
499 	address public treasury;
500 
501 	/// The admin address; auction can be paused or halted at any time by this.
502 	address public admin;
503 
504 	/// The time at which the sale begins.
505 	uint public beginTime;
506 
507 	/// Maximum amount of tokens to mint. Once totalAccounted / currentPrice is
508 	/// greater than this, the sale ends.
509 	uint public tokenCap;
510 
511 	// Era stuff (isolated)
512 	/// The era for which the current consolidated data represents.
513 	uint public eraIndex;
514 
515 	/// The size of the era in seconds.
516 	uint constant public ERA_PERIOD = 5 minutes;
517 
518 	// Static constants:
519 
520 	/// Anything less than this is considered dust and cannot be used to buy in.
521 	uint constant public DUST_LIMIT = 5 finney;
522 
523 	//# Statement to actually sign.
524 	//# ```js
525 	//# statement = function() { this.STATEMENT().map(s => s.substr(28)) }
526 	//# ```
527 
528 	/// Minimum duration after sale begins that bonus is active.
529 	uint constant public BONUS_MIN_DURATION = 1 hours;
530 
531 	/// Minimum duration after sale begins that bonus is active.
532 	uint constant public BONUS_MAX_DURATION = 12 hours;
533 
534 	/// Number of consecutive blocks where there must be no new interest before bonus ends.
535 	uint constant public BONUS_LATCH = 2;
536 
537 	/// Number of Wei in one EUR, constant.
538 	uint constant public EURWEI = 2000 szabo; // 500 eur ~ 1 eth
539 
540 	/// Initial auction length
541 	uint constant public DEFAULT_AUCTION_LENGTH = 2 days;
542 
543 	/// Divisor of the token.
544 	uint constant public DIVISOR = 1000;
545 }