1 pragma solidity ^0.4.13;
2 
3 contract StaffUtil {
4 	Staff public staffContract;
5 
6 	constructor (Staff _staffContract) public {
7 		require(msg.sender == _staffContract.owner());
8 		staffContract = _staffContract;
9 	}
10 
11 	modifier onlyOwner() {
12 		require(msg.sender == staffContract.owner());
13 		_;
14 	}
15 
16 	modifier onlyOwnerOrStaff() {
17 		require(msg.sender == staffContract.owner() || staffContract.isStaff(msg.sender));
18 		_;
19 	}
20 }
21 
22 contract Crowdsale is StaffUtil {
23 	using SafeMath for uint256;
24 
25 	Token tokenContract;
26 	PromoCodes promoCodesContract;
27 	DiscountPhases discountPhasesContract;
28 	DiscountStructs discountStructsContract;
29 
30 	address ethFundsWallet;
31 	uint256 referralBonusPercent;
32 	uint256 startDate;
33 
34 	uint256 crowdsaleStartDate;
35 	uint256 endDate;
36 	uint256 tokenDecimals;
37 	uint256 tokenRate;
38 	uint256 tokensForSaleCap;
39 	uint256 minPurchaseInWei;
40 	uint256 maxInvestorContributionInWei;
41 	bool paused;
42 	bool finalized;
43 	uint256 weiRaised;
44 	uint256 soldTokens;
45 	uint256 bonusTokens;
46 	uint256 sentTokens;
47 	uint256 claimedSoldTokens;
48 	uint256 claimedBonusTokens;
49 	uint256 claimedSentTokens;
50 	uint256 purchasedTokensClaimDate;
51 	uint256 bonusTokensClaimDate;
52 	mapping(address => Investor) public investors;
53 
54 	enum InvestorStatus {UNDEFINED, WHITELISTED, BLOCKED}
55 
56 	struct Investor {
57 		InvestorStatus status;
58 		uint256 contributionInWei;
59 		uint256 purchasedTokens;
60 		uint256 bonusTokens;
61 		uint256 referralTokens;
62 		uint256 receivedTokens;
63 		TokensPurchase[] tokensPurchases;
64 		bool isBlockpass;
65 	}
66 
67 	struct TokensPurchase {
68 		uint256 value;
69 		uint256 amount;
70 		uint256 bonus;
71 		address referrer;
72 		uint256 referrerSentAmount;
73 	}
74 
75 	event InvestorWhitelisted(address indexed investor, uint timestamp, address byStaff);
76 	event InvestorBlocked(address indexed investor, uint timestamp, address byStaff);
77 	event TokensPurchased(
78 		address indexed investor,
79 		uint indexed purchaseId,
80 		uint256 value,
81 		uint256 purchasedAmount,
82 		uint256 promoCodeAmount,
83 		uint256 discountPhaseAmount,
84 		uint256 discountStructAmount,
85 		address indexed referrer,
86 		uint256 referrerSentAmount,
87 		uint timestamp
88 	);
89 	event TokensPurchaseRefunded(
90 		address indexed investor,
91 		uint indexed purchaseId,
92 		uint256 value,
93 		uint256 amount,
94 		uint256 bonus,
95 		uint timestamp,
96 		address byStaff
97 	);
98 	event Paused(uint timestamp, address byStaff);
99 	event Resumed(uint timestamp, address byStaff);
100 	event Finalized(uint timestamp, address byStaff);
101 	event TokensSent(address indexed investor, uint256 amount, uint timestamp, address byStaff);
102 	event PurchasedTokensClaimLocked(uint date, uint timestamp, address byStaff);
103 	event PurchasedTokensClaimUnlocked(uint timestamp, address byStaff);
104 	event BonusTokensClaimLocked(uint date, uint timestamp, address byStaff);
105 	event BonusTokensClaimUnlocked(uint timestamp, address byStaff);
106 	event CrowdsaleStartDateUpdated(uint date, uint timestamp, address byStaff);
107 	event EndDateUpdated(uint date, uint timestamp, address byStaff);
108 	event MinPurchaseChanged(uint256 minPurchaseInWei, uint timestamp, address byStaff);
109 	event MaxInvestorContributionChanged(uint256 maxInvestorContributionInWei, uint timestamp, address byStaff);
110 	event TokenRateChanged(uint newRate, uint timestamp, address byStaff);
111 	event TokensClaimed(
112 		address indexed investor,
113 		uint256 purchased,
114 		uint256 bonus,
115 		uint256 referral,
116 		uint256 received,
117 		uint timestamp,
118 		address byStaff
119 	);
120 	event TokensBurned(uint256 amount, uint timestamp, address byStaff);
121 
122 	constructor (
123 		uint256[11] uint256Args,
124 		address[5] addressArgs
125 	) StaffUtil(Staff(addressArgs[4])) public {
126 
127 		// uint256 args
128 		startDate = uint256Args[0];
129 		crowdsaleStartDate = uint256Args[1];
130 		endDate = uint256Args[2];
131 		tokenDecimals = uint256Args[3];
132 		tokenRate = uint256Args[4];
133 		tokensForSaleCap = uint256Args[5];
134 		minPurchaseInWei = uint256Args[6];
135 		maxInvestorContributionInWei = uint256Args[7];
136 		purchasedTokensClaimDate = uint256Args[8];
137 		bonusTokensClaimDate = uint256Args[9];
138 		referralBonusPercent = uint256Args[10];
139 
140 		// address args
141 		ethFundsWallet = addressArgs[0];
142 		promoCodesContract = PromoCodes(addressArgs[1]);
143 		discountPhasesContract = DiscountPhases(addressArgs[2]);
144 		discountStructsContract = DiscountStructs(addressArgs[3]);
145 
146 		require(startDate < crowdsaleStartDate);
147 		require(crowdsaleStartDate < endDate);
148 		require(tokenRate > 0);
149 		require(tokenRate > 0);
150 		require(tokensForSaleCap > 0);
151 		require(minPurchaseInWei <= maxInvestorContributionInWei);
152 		require(ethFundsWallet != address(0));
153 	}
154 
155 	function getState() external view returns (bool[2] boolArgs, uint256[18] uint256Args, address[6] addressArgs) {
156 		boolArgs[0] = paused;
157 		boolArgs[1] = finalized;
158 		uint256Args[0] = weiRaised;
159 		uint256Args[1] = soldTokens;
160 		uint256Args[2] = bonusTokens;
161 		uint256Args[3] = sentTokens;
162 		uint256Args[4] = claimedSoldTokens;
163 		uint256Args[5] = claimedBonusTokens;
164 		uint256Args[6] = claimedSentTokens;
165 		uint256Args[7] = purchasedTokensClaimDate;
166 		uint256Args[8] = bonusTokensClaimDate;
167 		uint256Args[9] = startDate;
168 		uint256Args[10] = crowdsaleStartDate;
169 		uint256Args[11] = endDate;
170 		uint256Args[12] = tokenRate;
171 		uint256Args[13] = tokenDecimals;
172 		uint256Args[14] = minPurchaseInWei;
173 		uint256Args[15] = maxInvestorContributionInWei;
174 		uint256Args[16] = referralBonusPercent;
175 		uint256Args[17] = getTokensForSaleCap();
176 		addressArgs[0] = staffContract;
177 		addressArgs[1] = ethFundsWallet;
178 		addressArgs[2] = promoCodesContract;
179 		addressArgs[3] = discountPhasesContract;
180 		addressArgs[4] = discountStructsContract;
181 		addressArgs[5] = tokenContract;
182 	}
183 
184 	function fitsTokensForSaleCap(uint256 _amount) public view returns (bool) {
185 		return getDistributedTokens().add(_amount) <= getTokensForSaleCap();
186 	}
187 
188 	function getTokensForSaleCap() public view returns (uint256) {
189 		if (tokenContract != address(0)) {
190 			return tokenContract.balanceOf(this);
191 		}
192 		return tokensForSaleCap;
193 	}
194 
195 	function getDistributedTokens() public view returns (uint256) {
196 		return soldTokens.sub(claimedSoldTokens).add(bonusTokens.sub(claimedBonusTokens)).add(sentTokens.sub(claimedSentTokens));
197 	}
198 
199 	function setTokenContract(Token token) external onlyOwner {
200 		require(tokenContract == address(0));
201 		require(token != address(0));
202 		tokenContract = token;
203 	}
204 
205 	function getInvestorClaimedTokens(address _investor) external view returns (uint256) {
206 		if (tokenContract != address(0)) {
207 			return tokenContract.balanceOf(_investor);
208 		}
209 		return 0;
210 	}
211 
212 	function isBlockpassInvestor(address _investor) external constant returns (bool) {
213 		return investors[_investor].status == InvestorStatus.WHITELISTED && investors[_investor].isBlockpass;
214 	}
215 
216 	function whitelistInvestor(address _investor, bool _isBlockpass) external onlyOwnerOrStaff {
217 		require(_investor != address(0));
218 		require(investors[_investor].status != InvestorStatus.WHITELISTED);
219 
220 		investors[_investor].status = InvestorStatus.WHITELISTED;
221 		investors[_investor].isBlockpass = _isBlockpass;
222 
223 		emit InvestorWhitelisted(_investor, now, msg.sender);
224 	}
225 
226 	function bulkWhitelistInvestor(address[] _investors) external onlyOwnerOrStaff {
227 		for (uint256 i = 0; i < _investors.length; i++) {
228 			if (_investors[i] != address(0) && investors[_investors[i]].status != InvestorStatus.WHITELISTED) {
229 				investors[_investors[i]].status = InvestorStatus.WHITELISTED;
230 				emit InvestorWhitelisted(_investors[i], now, msg.sender);
231 			}
232 		}
233 	}
234 
235 	function blockInvestor(address _investor) external onlyOwnerOrStaff {
236 		require(_investor != address(0));
237 		require(investors[_investor].status != InvestorStatus.BLOCKED);
238 
239 		investors[_investor].status = InvestorStatus.BLOCKED;
240 
241 		emit InvestorBlocked(_investor, now, msg.sender);
242 	}
243 
244 	function lockPurchasedTokensClaim(uint256 _date) external onlyOwner {
245 		require(_date > now);
246 		purchasedTokensClaimDate = _date;
247 		emit PurchasedTokensClaimLocked(_date, now, msg.sender);
248 	}
249 
250 	function unlockPurchasedTokensClaim() external onlyOwner {
251 		purchasedTokensClaimDate = now;
252 		emit PurchasedTokensClaimUnlocked(now, msg.sender);
253 	}
254 
255 	function lockBonusTokensClaim(uint256 _date) external onlyOwner {
256 		require(_date > now);
257 		bonusTokensClaimDate = _date;
258 		emit BonusTokensClaimLocked(_date, now, msg.sender);
259 	}
260 
261 	function unlockBonusTokensClaim() external onlyOwner {
262 		bonusTokensClaimDate = now;
263 		emit BonusTokensClaimUnlocked(now, msg.sender);
264 	}
265 
266 	function setCrowdsaleStartDate(uint256 _date) external onlyOwner {
267 		crowdsaleStartDate = _date;
268 		emit CrowdsaleStartDateUpdated(_date, now, msg.sender);
269 	}
270 
271 	function setEndDate(uint256 _date) external onlyOwner {
272 		endDate = _date;
273 		emit EndDateUpdated(_date, now, msg.sender);
274 	}
275 
276 	function setMinPurchaseInWei(uint256 _minPurchaseInWei) external onlyOwner {
277 		minPurchaseInWei = _minPurchaseInWei;
278 		emit MinPurchaseChanged(_minPurchaseInWei, now, msg.sender);
279 	}
280 
281 	function setMaxInvestorContributionInWei(uint256 _maxInvestorContributionInWei) external onlyOwner {
282 		require(minPurchaseInWei <= _maxInvestorContributionInWei);
283 		maxInvestorContributionInWei = _maxInvestorContributionInWei;
284 		emit MaxInvestorContributionChanged(_maxInvestorContributionInWei, now, msg.sender);
285 	}
286 
287 	function changeTokenRate(uint256 _tokenRate) external onlyOwner {
288 		require(_tokenRate > 0);
289 		tokenRate = _tokenRate;
290 		emit TokenRateChanged(_tokenRate, now, msg.sender);
291 	}
292 
293 	function buyTokens(bytes32 _promoCode, address _referrer) external payable {
294 		require(!finalized);
295 		require(!paused);
296 		require(startDate < now);
297 		require(investors[msg.sender].status == InvestorStatus.WHITELISTED);
298 		require(msg.value > 0);
299 		require(msg.value >= minPurchaseInWei);
300 		require(investors[msg.sender].contributionInWei.add(msg.value) <= maxInvestorContributionInWei);
301 
302 		// calculate purchased amount
303 		uint256 purchasedAmount;
304 		if (tokenDecimals > 18) {
305 			purchasedAmount = msg.value.mul(tokenRate).mul(10 ** (tokenDecimals - 18));
306 		} else if (tokenDecimals < 18) {
307 			purchasedAmount = msg.value.mul(tokenRate).div(10 ** (18 - tokenDecimals));
308 		} else {
309 			purchasedAmount = msg.value.mul(tokenRate);
310 		}
311 
312 		// calculate total amount, this includes promo code amount or discount phase amount
313 		uint256 promoCodeBonusAmount = promoCodesContract.applyBonusAmount(msg.sender, purchasedAmount, _promoCode);
314 		uint256 discountPhaseBonusAmount = discountPhasesContract.calculateBonusAmount(purchasedAmount);
315 		uint256 discountStructBonusAmount = discountStructsContract.getBonus(msg.sender, purchasedAmount, msg.value);
316 		uint256 bonusAmount = promoCodeBonusAmount.add(discountPhaseBonusAmount).add(discountStructBonusAmount);
317 
318 		// update referrer's referral tokens
319 		uint256 referrerBonusAmount;
320 		address referrerAddr;
321 		if (
322 			_referrer != address(0)
323 			&& msg.sender != _referrer
324 			&& investors[_referrer].status == InvestorStatus.WHITELISTED
325 		) {
326 			referrerBonusAmount = purchasedAmount * referralBonusPercent / 100;
327 			referrerAddr = _referrer;
328 		}
329 
330 		// check that calculated tokens will not exceed tokens for sale cap
331 		require(fitsTokensForSaleCap(purchasedAmount.add(bonusAmount).add(referrerBonusAmount)));
332 
333 		// update crowdsale total amount of capital raised
334 		weiRaised = weiRaised.add(msg.value);
335 		soldTokens = soldTokens.add(purchasedAmount);
336 		bonusTokens = bonusTokens.add(bonusAmount).add(referrerBonusAmount);
337 
338 		// update referrer's bonus tokens
339 		investors[referrerAddr].referralTokens = investors[referrerAddr].referralTokens.add(referrerBonusAmount);
340 
341 		// update investor's purchased tokens
342 		investors[msg.sender].purchasedTokens = investors[msg.sender].purchasedTokens.add(purchasedAmount);
343 
344 		// update investor's bonus tokens
345 		investors[msg.sender].bonusTokens = investors[msg.sender].bonusTokens.add(bonusAmount);
346 
347 		// update investor's tokens eth value
348 		investors[msg.sender].contributionInWei = investors[msg.sender].contributionInWei.add(msg.value);
349 
350 		// update investor's tokens purchases
351 		uint tokensPurchasesLength = investors[msg.sender].tokensPurchases.push(TokensPurchase({
352 			value : msg.value,
353 			amount : purchasedAmount,
354 			bonus : bonusAmount,
355 			referrer : referrerAddr,
356 			referrerSentAmount : referrerBonusAmount
357 			})
358 		);
359 
360 		// log investor's tokens purchase
361 		emit TokensPurchased(
362 			msg.sender,
363 			tokensPurchasesLength - 1,
364 			msg.value,
365 			purchasedAmount,
366 			promoCodeBonusAmount,
367 			discountPhaseBonusAmount,
368 			discountStructBonusAmount,
369 			referrerAddr,
370 			referrerBonusAmount,
371 			now
372 		);
373 
374 		// forward eth to funds wallet
375 		ethFundsWallet.transfer(msg.value);
376 	}
377 
378 	function sendTokens(address _investor, uint256 _amount) external onlyOwner {
379 		require(investors[_investor].status == InvestorStatus.WHITELISTED);
380 		require(_amount > 0);
381 		require(fitsTokensForSaleCap(_amount));
382 
383 		// update crowdsale total amount of capital raised
384 		sentTokens = sentTokens.add(_amount);
385 
386 		// update investor's received tokens balance
387 		investors[_investor].receivedTokens = investors[_investor].receivedTokens.add(_amount);
388 
389 		// log tokens sent action
390 		emit TokensSent(
391 			_investor,
392 			_amount,
393 			now,
394 			msg.sender
395 		);
396 	}
397 
398 	function burnUnsoldTokens() external onlyOwner {
399 		require(tokenContract != address(0));
400 		require(finalized);
401 
402 		uint256 tokensToBurn = tokenContract.balanceOf(this).sub(getDistributedTokens());
403 		require(tokensToBurn > 0);
404 
405 		tokenContract.burn(tokensToBurn);
406 
407 		// log tokens burned action
408 		emit TokensBurned(tokensToBurn, now, msg.sender);
409 	}
410 
411 	function claimTokens() external {
412 		require(tokenContract != address(0));
413 		require(!paused);
414 		require(investors[msg.sender].status == InvestorStatus.WHITELISTED);
415 
416 		uint256 clPurchasedTokens;
417 		uint256 clReceivedTokens;
418 		uint256 clBonusTokens_;
419 		uint256 clRefTokens;
420 
421 		require(purchasedTokensClaimDate < now || bonusTokensClaimDate < now);
422 
423 		{
424 			uint256 purchasedTokens = investors[msg.sender].purchasedTokens;
425 			uint256 receivedTokens = investors[msg.sender].receivedTokens;
426 			if (purchasedTokensClaimDate < now && (purchasedTokens > 0 || receivedTokens > 0)) {
427 				investors[msg.sender].contributionInWei = 0;
428 				investors[msg.sender].purchasedTokens = 0;
429 				investors[msg.sender].receivedTokens = 0;
430 
431 				claimedSoldTokens = claimedSoldTokens.add(purchasedTokens);
432 				claimedSentTokens = claimedSentTokens.add(receivedTokens);
433 
434 				// free up storage used by transaction
435 				delete (investors[msg.sender].tokensPurchases);
436 
437 				clPurchasedTokens = purchasedTokens;
438 				clReceivedTokens = receivedTokens;
439 
440 				tokenContract.transfer(msg.sender, purchasedTokens.add(receivedTokens));
441 			}
442 		}
443 
444 		{
445 			uint256 bonusTokens_ = investors[msg.sender].bonusTokens;
446 			uint256 refTokens = investors[msg.sender].referralTokens;
447 			if (bonusTokensClaimDate < now && (bonusTokens_ > 0 || refTokens > 0)) {
448 				investors[msg.sender].bonusTokens = 0;
449 				investors[msg.sender].referralTokens = 0;
450 
451 				claimedBonusTokens = claimedBonusTokens.add(bonusTokens_).add(refTokens);
452 
453 				clBonusTokens_ = bonusTokens_;
454 				clRefTokens = refTokens;
455 
456 				tokenContract.transfer(msg.sender, bonusTokens_.add(refTokens));
457 			}
458 		}
459 
460 		require(clPurchasedTokens > 0 || clBonusTokens_ > 0 || clRefTokens > 0 || clReceivedTokens > 0);
461 		emit TokensClaimed(msg.sender, clPurchasedTokens, clBonusTokens_, clRefTokens, clReceivedTokens, now, msg.sender);
462 	}
463 
464 	function refundTokensPurchase(address _investor, uint _purchaseId) external payable onlyOwner {
465 		require(msg.value > 0);
466 		require(investors[_investor].tokensPurchases[_purchaseId].value == msg.value);
467 
468 		_refundTokensPurchase(_investor, _purchaseId);
469 
470 		// forward eth to investor's wallet address
471 		_investor.transfer(msg.value);
472 	}
473 
474 	function refundAllInvestorTokensPurchases(address _investor) external payable onlyOwner {
475 		require(msg.value > 0);
476 		require(investors[_investor].contributionInWei == msg.value);
477 
478 		for (uint i = 0; i < investors[_investor].tokensPurchases.length; i++) {
479 			if (investors[_investor].tokensPurchases[i].value == 0) {
480 				continue;
481 			}
482 
483 			_refundTokensPurchase(_investor, i);
484 		}
485 
486 		// forward eth to investor's wallet address
487 		_investor.transfer(msg.value);
488 	}
489 
490 	function _refundTokensPurchase(address _investor, uint _purchaseId) private {
491 		// update referrer's referral tokens
492 		address referrer = investors[_investor].tokensPurchases[_purchaseId].referrer;
493 		if (referrer != address(0)) {
494 			uint256 sentAmount = investors[_investor].tokensPurchases[_purchaseId].referrerSentAmount;
495 			investors[referrer].referralTokens = investors[referrer].referralTokens.sub(sentAmount);
496 			bonusTokens = bonusTokens.sub(sentAmount);
497 		}
498 
499 		// update investor's eth amount
500 		uint256 purchaseValue = investors[_investor].tokensPurchases[_purchaseId].value;
501 		investors[_investor].contributionInWei = investors[_investor].contributionInWei.sub(purchaseValue);
502 
503 		// update investor's purchased tokens
504 		uint256 purchaseAmount = investors[_investor].tokensPurchases[_purchaseId].amount;
505 		investors[_investor].purchasedTokens = investors[_investor].purchasedTokens.sub(purchaseAmount);
506 
507 		// update investor's bonus tokens
508 		uint256 bonusAmount = investors[_investor].tokensPurchases[_purchaseId].bonus;
509 		investors[_investor].bonusTokens = investors[_investor].bonusTokens.sub(bonusAmount);
510 
511 		// update crowdsale total amount of capital raised
512 		weiRaised = weiRaised.sub(purchaseValue);
513 		soldTokens = soldTokens.sub(purchaseAmount);
514 		bonusTokens = bonusTokens.sub(bonusAmount);
515 
516 		// free up storage used by transaction
517 		delete (investors[_investor].tokensPurchases[_purchaseId]);
518 
519 		// log investor's tokens purchase refund
520 		emit TokensPurchaseRefunded(_investor, _purchaseId, purchaseValue, purchaseAmount, bonusAmount, now, msg.sender);
521 	}
522 
523 	function getInvestorTokensPurchasesLength(address _investor) public constant returns (uint) {
524 		return investors[_investor].tokensPurchases.length;
525 	}
526 
527 	function getInvestorTokensPurchase(
528 		address _investor,
529 		uint _purchaseId
530 	) external constant returns (
531 		uint256 value,
532 		uint256 amount,
533 		uint256 bonus,
534 		address referrer,
535 		uint256 referrerSentAmount
536 	) {
537 		value = investors[_investor].tokensPurchases[_purchaseId].value;
538 		amount = investors[_investor].tokensPurchases[_purchaseId].amount;
539 		bonus = investors[_investor].tokensPurchases[_purchaseId].bonus;
540 		referrer = investors[_investor].tokensPurchases[_purchaseId].referrer;
541 		referrerSentAmount = investors[_investor].tokensPurchases[_purchaseId].referrerSentAmount;
542 	}
543 
544 	function pause() external onlyOwner {
545 		require(!paused);
546 
547 		paused = true;
548 
549 		emit Paused(now, msg.sender);
550 	}
551 
552 	function resume() external onlyOwner {
553 		require(paused);
554 
555 		paused = false;
556 
557 		emit Resumed(now, msg.sender);
558 	}
559 
560 	function finalize() external onlyOwner {
561 		require(!finalized);
562 
563 		finalized = true;
564 
565 		emit Finalized(now, msg.sender);
566 	}
567 }
568 
569 contract DiscountPhases is StaffUtil {
570 
571 	event DiscountPhaseAdded(uint index, string name, uint8 percent, uint fromDate, uint toDate, uint timestamp, address byStaff);
572 	event DiscountPhaseRemoved(uint index, uint timestamp, address byStaff);
573 
574 	struct DiscountPhase {
575 		uint8 percent;
576 		uint fromDate;
577 		uint toDate;
578 	}
579 
580 	DiscountPhase[] public discountPhases;
581 
582 	constructor(Staff _staffContract) StaffUtil(_staffContract) public {
583 	}
584 
585 	function calculateBonusAmount(uint256 _purchasedAmount) public constant returns (uint256) {
586 		for (uint i = 0; i < discountPhases.length; i++) {
587 			if (now >= discountPhases[i].fromDate && now <= discountPhases[i].toDate) {
588 				return _purchasedAmount * discountPhases[i].percent / 100;
589 			}
590 		}
591 	}
592 
593 	function addDiscountPhase(string _name, uint8 _percent, uint _fromDate, uint _toDate) public onlyOwnerOrStaff {
594 		require(bytes(_name).length > 0);
595 		require(_percent > 0);
596 
597 		if (now > _fromDate) {
598 			_fromDate = now;
599 		}
600 		require(_fromDate < _toDate);
601 
602 		for (uint i = 0; i < discountPhases.length; i++) {
603 			require(_fromDate > discountPhases[i].toDate || _toDate < discountPhases[i].fromDate);
604 		}
605 
606 		uint index = discountPhases.push(DiscountPhase({percent : _percent, fromDate : _fromDate, toDate : _toDate})) - 1;
607 
608 		emit DiscountPhaseAdded(index, _name, _percent, _fromDate, _toDate, now, msg.sender);
609 	}
610 
611 	function removeDiscountPhase(uint _index) public onlyOwnerOrStaff {
612 		require(now < discountPhases[_index].toDate);
613 		delete discountPhases[_index];
614 		emit DiscountPhaseRemoved(_index, now, msg.sender);
615 	}
616 }
617 
618 contract DiscountStructs is StaffUtil {
619 	using SafeMath for uint256;
620 
621 	address public crowdsale;
622 
623 	event DiscountStructAdded(
624 		uint index,
625 		bytes32 name,
626 		uint256 tokens,
627 		uint[2] dates,
628 		uint256[] fromWei,
629 		uint256[] toWei,
630 		uint256[] percent,
631 		uint timestamp,
632 		address byStaff
633 	);
634 	event DiscountStructRemoved(
635 		uint index,
636 		uint timestamp,
637 		address byStaff
638 	);
639 	event DiscountStructUsed(
640 		uint index,
641 		uint step,
642 		address investor,
643 		uint256 tokens,
644 		uint timestamp
645 	);
646 
647 	struct DiscountStruct {
648 		uint256 availableTokens;
649 		uint256 distributedTokens;
650 		uint fromDate;
651 		uint toDate;
652 	}
653 
654 	struct DiscountStep {
655 		uint256 fromWei;
656 		uint256 toWei;
657 		uint256 percent;
658 	}
659 
660 	DiscountStruct[] public discountStructs;
661 	mapping(uint => DiscountStep[]) public discountSteps;
662 
663 	constructor(Staff _staffContract) StaffUtil(_staffContract) public {
664 	}
665 
666 	modifier onlyCrowdsale() {
667 		require(msg.sender == crowdsale);
668 		_;
669 	}
670 
671 	function setCrowdsale(Crowdsale _crowdsale) external onlyOwner {
672 		require(crowdsale == address(0));
673 		require(_crowdsale.staffContract() == staffContract);
674 		crowdsale = _crowdsale;
675 	}
676 
677 	function getBonus(address _investor, uint256 _purchasedAmount, uint256 _purchasedValue) public onlyCrowdsale returns (uint256) {
678 		for (uint i = 0; i < discountStructs.length; i++) {
679 			if (now >= discountStructs[i].fromDate && now <= discountStructs[i].toDate) {
680 
681 				if (discountStructs[i].distributedTokens >= discountStructs[i].availableTokens) {
682 					return;
683 				}
684 
685 				for (uint j = 0; j < discountSteps[i].length; j++) {
686 					if (_purchasedValue >= discountSteps[i][j].fromWei
687 						&& (_purchasedValue < discountSteps[i][j].toWei || discountSteps[i][j].toWei == 0)) {
688 						uint256 bonus = _purchasedAmount * discountSteps[i][j].percent / 100;
689 						if (discountStructs[i].distributedTokens.add(bonus) > discountStructs[i].availableTokens) {
690 							return;
691 						}
692 						discountStructs[i].distributedTokens = discountStructs[i].distributedTokens.add(bonus);
693 						emit DiscountStructUsed(i, j, _investor, bonus, now);
694 						return bonus;
695 					}
696 				}
697 
698 				return;
699 			}
700 		}
701 	}
702 
703 	function calculateBonus(uint256 _purchasedAmount, uint256 _purchasedValue) public constant returns (uint256) {
704 		for (uint i = 0; i < discountStructs.length; i++) {
705 			if (now >= discountStructs[i].fromDate && now <= discountStructs[i].toDate) {
706 
707 				if (discountStructs[i].distributedTokens >= discountStructs[i].availableTokens) {
708 					return;
709 				}
710 
711 				for (uint j = 0; j < discountSteps[i].length; j++) {
712 					if (_purchasedValue >= discountSteps[i][j].fromWei
713 						&& (_purchasedValue < discountSteps[i][j].toWei || discountSteps[i][j].toWei == 0)) {
714 						uint256 bonus = _purchasedAmount * discountSteps[i][j].percent / 100;
715 						if (discountStructs[i].distributedTokens.add(bonus) > discountStructs[i].availableTokens) {
716 							return;
717 						}
718 						return bonus;
719 					}
720 				}
721 
722 				return;
723 			}
724 		}
725 	}
726 
727 	function addDiscountStruct(bytes32 _name, uint256 _tokens, uint[2] _dates, uint256[] _fromWei, uint256[] _toWei, uint256[] _percent) external onlyOwnerOrStaff {
728 		require(_name.length > 0);
729 		require(_tokens > 0);
730 		require(_dates[0] < _dates[1]);
731 		require(_fromWei.length > 0 && _fromWei.length == _toWei.length && _fromWei.length == _percent.length);
732 
733 		for (uint j = 0; j < discountStructs.length; j++) {
734 			require(_dates[0] > discountStructs[j].fromDate || _dates[1] < discountStructs[j].toDate);
735 		}
736 
737 		DiscountStruct memory ds = DiscountStruct(_tokens, 0, _dates[0], _dates[1]);
738 		uint index = discountStructs.push(ds) - 1;
739 
740 		for (uint i = 0; i < _fromWei.length; i++) {
741 			require(_fromWei[i] > 0 || _toWei[i] > 0);
742 			require(_percent[i] > 0);
743 			discountSteps[index].push(DiscountStep(_fromWei[i], _toWei[i], _percent[i]));
744 		}
745 
746 		emit DiscountStructAdded(index, _name, _tokens, _dates, _fromWei, _toWei, _percent, now, msg.sender);
747 	}
748 
749 	function removeDiscountStruct(uint _index) public onlyOwnerOrStaff {
750 		require(now < discountStructs[_index].toDate);
751 		delete discountStructs[_index];
752 		delete discountSteps[_index];
753 		emit DiscountStructRemoved(_index, now, msg.sender);
754 	}
755 }
756 
757 contract PromoCodes is StaffUtil {
758 	address public crowdsale;
759 
760 	event PromoCodeAdded(bytes32 indexed code, string name, uint8 percent, uint256 maxUses, uint timestamp, address byStaff);
761 	event PromoCodeRemoved(bytes32 indexed code, uint timestamp, address byStaff);
762 	event PromoCodeUsed(bytes32 indexed code, address investor, uint timestamp);
763 
764 	struct PromoCode {
765 		uint8 percent;
766 		uint256 uses;
767 		uint256 maxUses;
768 		mapping(address => bool) investors;
769 	}
770 
771 	mapping(bytes32 => PromoCode) public promoCodes;
772 
773 	constructor(Staff _staffContract) StaffUtil(_staffContract) public {
774 	}
775 
776 	modifier onlyCrowdsale() {
777 		require(msg.sender == crowdsale);
778 		_;
779 	}
780 
781 	function setCrowdsale(Crowdsale _crowdsale) external onlyOwner {
782 		require(crowdsale == address(0));
783 		require(_crowdsale.staffContract() == staffContract);
784 		crowdsale = _crowdsale;
785 	}
786 
787 	function applyBonusAmount(address _investor, uint256 _purchasedAmount, bytes32 _promoCode) public onlyCrowdsale returns (uint256) {
788 		if (promoCodes[_promoCode].percent == 0
789 		|| promoCodes[_promoCode].investors[_investor]
790 		|| promoCodes[_promoCode].uses == promoCodes[_promoCode].maxUses) {
791 			return 0;
792 		}
793 		promoCodes[_promoCode].investors[_investor] = true;
794 		promoCodes[_promoCode].uses = promoCodes[_promoCode].uses + 1;
795 		emit PromoCodeUsed(_promoCode, _investor, now);
796 		return _purchasedAmount * promoCodes[_promoCode].percent / 100;
797 	}
798 
799 	function calculateBonusAmount(address _investor, uint256 _purchasedAmount, bytes32 _promoCode) public constant returns (uint256) {
800 		if (promoCodes[_promoCode].percent == 0
801 		|| promoCodes[_promoCode].investors[_investor]
802 		|| promoCodes[_promoCode].uses == promoCodes[_promoCode].maxUses) {
803 			return 0;
804 		}
805 		return _purchasedAmount * promoCodes[_promoCode].percent / 100;
806 	}
807 
808 	function addPromoCode(string _name, bytes32 _code, uint256 _maxUses, uint8 _percent) public onlyOwnerOrStaff {
809 		require(bytes(_name).length > 0);
810 		require(_code[0] != 0);
811 		require(_percent > 0);
812 		require(_maxUses > 0);
813 		require(promoCodes[_code].percent == 0);
814 
815 		promoCodes[_code].percent = _percent;
816 		promoCodes[_code].maxUses = _maxUses;
817 
818 		emit PromoCodeAdded(_code, _name, _percent, _maxUses, now, msg.sender);
819 	}
820 
821 	function removePromoCode(bytes32 _code) public onlyOwnerOrStaff {
822 		delete promoCodes[_code];
823 		emit PromoCodeRemoved(_code, now, msg.sender);
824 	}
825 }
826 
827 library SafeMath {
828 
829   /**
830   * @dev Multiplies two numbers, throws on overflow.
831   */
832   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
833     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
834     // benefit is lost if 'b' is also tested.
835     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
836     if (a == 0) {
837       return 0;
838     }
839 
840     c = a * b;
841     assert(c / a == b);
842     return c;
843   }
844 
845   /**
846   * @dev Integer division of two numbers, truncating the quotient.
847   */
848   function div(uint256 a, uint256 b) internal pure returns (uint256) {
849     // assert(b > 0); // Solidity automatically throws when dividing by 0
850     // uint256 c = a / b;
851     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
852     return a / b;
853   }
854 
855   /**
856   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
857   */
858   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
859     assert(b <= a);
860     return a - b;
861   }
862 
863   /**
864   * @dev Adds two numbers, throws on overflow.
865   */
866   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
867     c = a + b;
868     assert(c >= a);
869     return c;
870   }
871 }
872 
873 contract Ownable {
874   address public owner;
875 
876 
877   event OwnershipRenounced(address indexed previousOwner);
878   event OwnershipTransferred(
879     address indexed previousOwner,
880     address indexed newOwner
881   );
882 
883 
884   /**
885    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
886    * account.
887    */
888   constructor() public {
889     owner = msg.sender;
890   }
891 
892   /**
893    * @dev Throws if called by any account other than the owner.
894    */
895   modifier onlyOwner() {
896     require(msg.sender == owner);
897     _;
898   }
899 
900   /**
901    * @dev Allows the current owner to relinquish control of the contract.
902    */
903   function renounceOwnership() public onlyOwner {
904     emit OwnershipRenounced(owner);
905     owner = address(0);
906   }
907 
908   /**
909    * @dev Allows the current owner to transfer control of the contract to a newOwner.
910    * @param _newOwner The address to transfer ownership to.
911    */
912   function transferOwnership(address _newOwner) public onlyOwner {
913     _transferOwnership(_newOwner);
914   }
915 
916   /**
917    * @dev Transfers control of the contract to a newOwner.
918    * @param _newOwner The address to transfer ownership to.
919    */
920   function _transferOwnership(address _newOwner) internal {
921     require(_newOwner != address(0));
922     emit OwnershipTransferred(owner, _newOwner);
923     owner = _newOwner;
924   }
925 }
926 
927 contract RBAC {
928   using Roles for Roles.Role;
929 
930   mapping (string => Roles.Role) private roles;
931 
932   event RoleAdded(address addr, string roleName);
933   event RoleRemoved(address addr, string roleName);
934 
935   /**
936    * @dev reverts if addr does not have role
937    * @param addr address
938    * @param roleName the name of the role
939    * // reverts
940    */
941   function checkRole(address addr, string roleName)
942     view
943     public
944   {
945     roles[roleName].check(addr);
946   }
947 
948   /**
949    * @dev determine if addr has role
950    * @param addr address
951    * @param roleName the name of the role
952    * @return bool
953    */
954   function hasRole(address addr, string roleName)
955     view
956     public
957     returns (bool)
958   {
959     return roles[roleName].has(addr);
960   }
961 
962   /**
963    * @dev add a role to an address
964    * @param addr address
965    * @param roleName the name of the role
966    */
967   function addRole(address addr, string roleName)
968     internal
969   {
970     roles[roleName].add(addr);
971     emit RoleAdded(addr, roleName);
972   }
973 
974   /**
975    * @dev remove a role from an address
976    * @param addr address
977    * @param roleName the name of the role
978    */
979   function removeRole(address addr, string roleName)
980     internal
981   {
982     roles[roleName].remove(addr);
983     emit RoleRemoved(addr, roleName);
984   }
985 
986   /**
987    * @dev modifier to scope access to a single role (uses msg.sender as addr)
988    * @param roleName the name of the role
989    * // reverts
990    */
991   modifier onlyRole(string roleName)
992   {
993     checkRole(msg.sender, roleName);
994     _;
995   }
996 
997   /**
998    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
999    * @param roleNames the names of the roles to scope access to
1000    * // reverts
1001    *
1002    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
1003    *  see: https://github.com/ethereum/solidity/issues/2467
1004    */
1005   // modifier onlyRoles(string[] roleNames) {
1006   //     bool hasAnyRole = false;
1007   //     for (uint8 i = 0; i < roleNames.length; i++) {
1008   //         if (hasRole(msg.sender, roleNames[i])) {
1009   //             hasAnyRole = true;
1010   //             break;
1011   //         }
1012   //     }
1013 
1014   //     require(hasAnyRole);
1015 
1016   //     _;
1017   // }
1018 }
1019 
1020 contract Staff is Ownable, RBAC {
1021 
1022 	string public constant ROLE_STAFF = "staff";
1023 
1024 	function addStaff(address _staff) public onlyOwner {
1025 		addRole(_staff, ROLE_STAFF);
1026 	}
1027 
1028 	function removeStaff(address _staff) public onlyOwner {
1029 		removeRole(_staff, ROLE_STAFF);
1030 	}
1031 
1032 	function isStaff(address _staff) view public returns (bool) {
1033 		return hasRole(_staff, ROLE_STAFF);
1034 	}
1035 }
1036 
1037 library Roles {
1038   struct Role {
1039     mapping (address => bool) bearer;
1040   }
1041 
1042   /**
1043    * @dev give an address access to this role
1044    */
1045   function add(Role storage role, address addr)
1046     internal
1047   {
1048     role.bearer[addr] = true;
1049   }
1050 
1051   /**
1052    * @dev remove an address' access to this role
1053    */
1054   function remove(Role storage role, address addr)
1055     internal
1056   {
1057     role.bearer[addr] = false;
1058   }
1059 
1060   /**
1061    * @dev check if an address has this role
1062    * // reverts
1063    */
1064   function check(Role storage role, address addr)
1065     view
1066     internal
1067   {
1068     require(has(role, addr));
1069   }
1070 
1071   /**
1072    * @dev check if an address has this role
1073    * @return bool
1074    */
1075   function has(Role storage role, address addr)
1076     view
1077     internal
1078     returns (bool)
1079   {
1080     return role.bearer[addr];
1081   }
1082 }
1083 
1084 contract ERC20Basic {
1085   function totalSupply() public view returns (uint256);
1086   function balanceOf(address who) public view returns (uint256);
1087   function transfer(address to, uint256 value) public returns (bool);
1088   event Transfer(address indexed from, address indexed to, uint256 value);
1089 }
1090 
1091 contract BasicToken is ERC20Basic {
1092   using SafeMath for uint256;
1093 
1094   mapping(address => uint256) balances;
1095 
1096   uint256 totalSupply_;
1097 
1098   /**
1099   * @dev total number of tokens in existence
1100   */
1101   function totalSupply() public view returns (uint256) {
1102     return totalSupply_;
1103   }
1104 
1105   /**
1106   * @dev transfer token for a specified address
1107   * @param _to The address to transfer to.
1108   * @param _value The amount to be transferred.
1109   */
1110   function transfer(address _to, uint256 _value) public returns (bool) {
1111     require(_to != address(0));
1112     require(_value <= balances[msg.sender]);
1113 
1114     balances[msg.sender] = balances[msg.sender].sub(_value);
1115     balances[_to] = balances[_to].add(_value);
1116     emit Transfer(msg.sender, _to, _value);
1117     return true;
1118   }
1119 
1120   /**
1121   * @dev Gets the balance of the specified address.
1122   * @param _owner The address to query the the balance of.
1123   * @return An uint256 representing the amount owned by the passed address.
1124   */
1125   function balanceOf(address _owner) public view returns (uint256) {
1126     return balances[_owner];
1127   }
1128 
1129 }
1130 
1131 contract BurnableToken is BasicToken {
1132 
1133   event Burn(address indexed burner, uint256 value);
1134 
1135   /**
1136    * @dev Burns a specific amount of tokens.
1137    * @param _value The amount of token to be burned.
1138    */
1139   function burn(uint256 _value) public {
1140     _burn(msg.sender, _value);
1141   }
1142 
1143   function _burn(address _who, uint256 _value) internal {
1144     require(_value <= balances[_who]);
1145     // no need to require value <= totalSupply, since that would imply the
1146     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1147 
1148     balances[_who] = balances[_who].sub(_value);
1149     totalSupply_ = totalSupply_.sub(_value);
1150     emit Burn(_who, _value);
1151     emit Transfer(_who, address(0), _value);
1152   }
1153 }
1154 
1155 contract Token is BurnableToken {
1156 }