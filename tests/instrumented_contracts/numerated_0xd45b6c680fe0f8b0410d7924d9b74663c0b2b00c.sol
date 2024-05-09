1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 contract RBAC {
104   using Roles for Roles.Role;
105 
106   mapping (string => Roles.Role) private roles;
107 
108   event RoleAdded(address addr, string roleName);
109   event RoleRemoved(address addr, string roleName);
110 
111   /**
112    * @dev reverts if addr does not have role
113    * @param addr address
114    * @param roleName the name of the role
115    * // reverts
116    */
117   function checkRole(address addr, string roleName)
118     view
119     public
120   {
121     roles[roleName].check(addr);
122   }
123 
124   /**
125    * @dev determine if addr has role
126    * @param addr address
127    * @param roleName the name of the role
128    * @return bool
129    */
130   function hasRole(address addr, string roleName)
131     view
132     public
133     returns (bool)
134   {
135     return roles[roleName].has(addr);
136   }
137 
138   /**
139    * @dev add a role to an address
140    * @param addr address
141    * @param roleName the name of the role
142    */
143   function addRole(address addr, string roleName)
144     internal
145   {
146     roles[roleName].add(addr);
147     emit RoleAdded(addr, roleName);
148   }
149 
150   /**
151    * @dev remove a role from an address
152    * @param addr address
153    * @param roleName the name of the role
154    */
155   function removeRole(address addr, string roleName)
156     internal
157   {
158     roles[roleName].remove(addr);
159     emit RoleRemoved(addr, roleName);
160   }
161 
162   /**
163    * @dev modifier to scope access to a single role (uses msg.sender as addr)
164    * @param roleName the name of the role
165    * // reverts
166    */
167   modifier onlyRole(string roleName)
168   {
169     checkRole(msg.sender, roleName);
170     _;
171   }
172 
173   /**
174    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
175    * @param roleNames the names of the roles to scope access to
176    * // reverts
177    *
178    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
179    *  see: https://github.com/ethereum/solidity/issues/2467
180    */
181   // modifier onlyRoles(string[] roleNames) {
182   //     bool hasAnyRole = false;
183   //     for (uint8 i = 0; i < roleNames.length; i++) {
184   //         if (hasRole(msg.sender, roleNames[i])) {
185   //             hasAnyRole = true;
186   //             break;
187   //         }
188   //     }
189 
190   //     require(hasAnyRole);
191 
192   //     _;
193   // }
194 }
195 
196 library Roles {
197   struct Role {
198     mapping (address => bool) bearer;
199   }
200 
201   /**
202    * @dev give an address access to this role
203    */
204   function add(Role storage role, address addr)
205     internal
206   {
207     role.bearer[addr] = true;
208   }
209 
210   /**
211    * @dev remove an address' access to this role
212    */
213   function remove(Role storage role, address addr)
214     internal
215   {
216     role.bearer[addr] = false;
217   }
218 
219   /**
220    * @dev check if an address has this role
221    * // reverts
222    */
223   function check(Role storage role, address addr)
224     view
225     internal
226   {
227     require(has(role, addr));
228   }
229 
230   /**
231    * @dev check if an address has this role
232    * @return bool
233    */
234   function has(Role storage role, address addr)
235     view
236     internal
237     returns (bool)
238   {
239     return role.bearer[addr];
240   }
241 }
242 
243 contract ERC20Basic {
244   function totalSupply() public view returns (uint256);
245   function balanceOf(address who) public view returns (uint256);
246   function transfer(address to, uint256 value) public returns (bool);
247   event Transfer(address indexed from, address indexed to, uint256 value);
248 }
249 
250 contract BasicToken is ERC20Basic {
251   using SafeMath for uint256;
252 
253   mapping(address => uint256) balances;
254 
255   uint256 totalSupply_;
256 
257   /**
258   * @dev total number of tokens in existence
259   */
260   function totalSupply() public view returns (uint256) {
261     return totalSupply_;
262   }
263 
264   /**
265   * @dev transfer token for a specified address
266   * @param _to The address to transfer to.
267   * @param _value The amount to be transferred.
268   */
269   function transfer(address _to, uint256 _value) public returns (bool) {
270     require(_to != address(0));
271     require(_value <= balances[msg.sender]);
272 
273     balances[msg.sender] = balances[msg.sender].sub(_value);
274     balances[_to] = balances[_to].add(_value);
275     emit Transfer(msg.sender, _to, _value);
276     return true;
277   }
278 
279   /**
280   * @dev Gets the balance of the specified address.
281   * @param _owner The address to query the the balance of.
282   * @return An uint256 representing the amount owned by the passed address.
283   */
284   function balanceOf(address _owner) public view returns (uint256) {
285     return balances[_owner];
286   }
287 
288 }
289 
290 contract BurnableToken is BasicToken {
291 
292   event Burn(address indexed burner, uint256 value);
293 
294   /**
295    * @dev Burns a specific amount of tokens.
296    * @param _value The amount of token to be burned.
297    */
298   function burn(uint256 _value) public {
299     _burn(msg.sender, _value);
300   }
301 
302   function _burn(address _who, uint256 _value) internal {
303     require(_value <= balances[_who]);
304     // no need to require value <= totalSupply, since that would imply the
305     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
306 
307     balances[_who] = balances[_who].sub(_value);
308     totalSupply_ = totalSupply_.sub(_value);
309     emit Burn(_who, _value);
310     emit Transfer(_who, address(0), _value);
311   }
312 }
313 
314 contract Staff is Ownable, RBAC {
315 
316 	string public constant ROLE_STAFF = "staff";
317 
318 	function addStaff(address _staff) public onlyOwner {
319 		addRole(_staff, ROLE_STAFF);
320 	}
321 
322 	function removeStaff(address _staff) public onlyOwner {
323 		removeRole(_staff, ROLE_STAFF);
324 	}
325 
326 	function isStaff(address _staff) view public returns (bool) {
327 		return hasRole(_staff, ROLE_STAFF);
328 	}
329 }
330 
331 contract StaffUtil {
332 	Staff public staffContract;
333 
334 	constructor (Staff _staffContract) public {
335 		require(msg.sender == _staffContract.owner());
336 		staffContract = _staffContract;
337 	}
338 
339 	modifier onlyOwner() {
340 		require(msg.sender == staffContract.owner());
341 		_;
342 	}
343 
344 	modifier onlyOwnerOrStaff() {
345 		require(msg.sender == staffContract.owner() || staffContract.isStaff(msg.sender));
346 		_;
347 	}
348 }
349 
350 contract Crowdsale is StaffUtil {
351 	using SafeMath for uint256;
352 
353 	Token tokenContract;
354 	PromoCodes promoCodesContract;
355 	DiscountPhases discountPhasesContract;
356 	DiscountStructs discountStructsContract;
357 
358 	address ethFundsWallet;
359 	uint256 referralBonusPercent;
360 	uint256 startDate;
361 
362 	uint256 crowdsaleStartDate;
363 	uint256 endDate;
364 	uint256 tokenDecimals;
365 	uint256 tokenRate;
366 	uint256 tokensForSaleCap;
367 	uint256 minPurchaseInWei;
368 	uint256 maxInvestorContributionInWei;
369 	bool paused;
370 	bool finalized;
371 	uint256 weiRaised;
372 	uint256 soldTokens;
373 	uint256 bonusTokens;
374 	uint256 sentTokens;
375 	uint256 claimedSoldTokens;
376 	uint256 claimedBonusTokens;
377 	uint256 claimedSentTokens;
378 	uint256 purchasedTokensClaimDate;
379 	uint256 bonusTokensClaimDate;
380 	mapping(address => Investor) public investors;
381 
382 	enum InvestorStatus {UNDEFINED, WHITELISTED, BLOCKED}
383 
384 	struct Investor {
385 		InvestorStatus status;
386 		uint256 contributionInWei;
387 		uint256 purchasedTokens;
388 		uint256 bonusTokens;
389 		uint256 referralTokens;
390 		uint256 receivedTokens;
391 		TokensPurchase[] tokensPurchases;
392 		bool isBlockpass;
393 	}
394 
395 	struct TokensPurchase {
396 		uint256 value;
397 		uint256 amount;
398 		uint256 bonus;
399 		address referrer;
400 		uint256 referrerSentAmount;
401 	}
402 
403 	event InvestorWhitelisted(address indexed investor, uint timestamp, address byStaff);
404 	event InvestorBlocked(address indexed investor, uint timestamp, address byStaff);
405 	event TokensPurchased(
406 		address indexed investor,
407 		uint indexed purchaseId,
408 		uint256 value,
409 		uint256 purchasedAmount,
410 		uint256 promoCodeAmount,
411 		uint256 discountPhaseAmount,
412 		uint256 discountStructAmount,
413 		address indexed referrer,
414 		uint256 referrerSentAmount,
415 		uint timestamp
416 	);
417 	event TokensPurchaseRefunded(
418 		address indexed investor,
419 		uint indexed purchaseId,
420 		uint256 value,
421 		uint256 amount,
422 		uint256 bonus,
423 		uint timestamp,
424 		address byStaff
425 	);
426 	event Paused(uint timestamp, address byStaff);
427 	event Resumed(uint timestamp, address byStaff);
428 	event Finalized(uint timestamp, address byStaff);
429 	event TokensSent(address indexed investor, uint256 amount, uint timestamp, address byStaff);
430 	event PurchasedTokensClaimLocked(uint date, uint timestamp, address byStaff);
431 	event PurchasedTokensClaimUnlocked(uint timestamp, address byStaff);
432 	event BonusTokensClaimLocked(uint date, uint timestamp, address byStaff);
433 	event BonusTokensClaimUnlocked(uint timestamp, address byStaff);
434 	event CrowdsaleStartDateUpdated(uint date, uint timestamp, address byStaff);
435 	event EndDateUpdated(uint date, uint timestamp, address byStaff);
436 	event MinPurchaseChanged(uint256 minPurchaseInWei, uint timestamp, address byStaff);
437 	event MaxInvestorContributionChanged(uint256 maxInvestorContributionInWei, uint timestamp, address byStaff);
438 	event TokenRateChanged(uint newRate, uint timestamp, address byStaff);
439 	event TokensClaimed(
440 		address indexed investor,
441 		uint256 purchased,
442 		uint256 bonus,
443 		uint256 referral,
444 		uint256 received,
445 		uint timestamp,
446 		address byStaff
447 	);
448 	event TokensBurned(uint256 amount, uint timestamp, address byStaff);
449 
450 	constructor (
451 		uint256[11] uint256Args,
452 		address[5] addressArgs
453 	) StaffUtil(Staff(addressArgs[4])) public {
454 
455 		// uint256 args
456 		startDate = uint256Args[0];
457 		crowdsaleStartDate = uint256Args[1];
458 		endDate = uint256Args[2];
459 		tokenDecimals = uint256Args[3];
460 		tokenRate = uint256Args[4];
461 		tokensForSaleCap = uint256Args[5];
462 		minPurchaseInWei = uint256Args[6];
463 		maxInvestorContributionInWei = uint256Args[7];
464 		purchasedTokensClaimDate = uint256Args[8];
465 		bonusTokensClaimDate = uint256Args[9];
466 		referralBonusPercent = uint256Args[10];
467 
468 		// address args
469 		ethFundsWallet = addressArgs[0];
470 		promoCodesContract = PromoCodes(addressArgs[1]);
471 		discountPhasesContract = DiscountPhases(addressArgs[2]);
472 		discountStructsContract = DiscountStructs(addressArgs[3]);
473 
474 		require(startDate < crowdsaleStartDate);
475 		require(crowdsaleStartDate < endDate);
476 		require(tokenDecimals > 0);
477 		require(tokenRate > 0);
478 		require(tokensForSaleCap > 0);
479 		require(minPurchaseInWei <= maxInvestorContributionInWei);
480 		require(ethFundsWallet != address(0));
481 	}
482 
483 	function getState() external view returns (bool[2] boolArgs, uint256[18] uint256Args, address[6] addressArgs) {
484 		boolArgs[0] = paused;
485 		boolArgs[1] = finalized;
486 		uint256Args[0] = weiRaised;
487 		uint256Args[1] = soldTokens;
488 		uint256Args[2] = bonusTokens;
489 		uint256Args[3] = sentTokens;
490 		uint256Args[4] = claimedSoldTokens;
491 		uint256Args[5] = claimedBonusTokens;
492 		uint256Args[6] = claimedSentTokens;
493 		uint256Args[7] = purchasedTokensClaimDate;
494 		uint256Args[8] = bonusTokensClaimDate;
495 		uint256Args[9] = startDate;
496 		uint256Args[10] = crowdsaleStartDate;
497 		uint256Args[11] = endDate;
498 		uint256Args[12] = tokenRate;
499 		uint256Args[13] = tokenDecimals;
500 		uint256Args[14] = minPurchaseInWei;
501 		uint256Args[15] = maxInvestorContributionInWei;
502 		uint256Args[16] = referralBonusPercent;
503 		uint256Args[17] = getTokensForSaleCap();
504 		addressArgs[0] = staffContract;
505 		addressArgs[1] = ethFundsWallet;
506 		addressArgs[2] = promoCodesContract;
507 		addressArgs[3] = discountPhasesContract;
508 		addressArgs[4] = discountStructsContract;
509 		addressArgs[5] = tokenContract;
510 	}
511 
512 	function fitsTokensForSaleCap(uint256 _amount) public view returns (bool) {
513 		return getDistributedTokens().add(_amount) <= getTokensForSaleCap();
514 	}
515 
516 	function getTokensForSaleCap() public view returns (uint256) {
517 		if (tokenContract != address(0)) {
518 			return tokenContract.balanceOf(this);
519 		}
520 		return tokensForSaleCap;
521 	}
522 
523 	function getDistributedTokens() public view returns (uint256) {
524 		return soldTokens.sub(claimedSoldTokens).add(bonusTokens.sub(claimedBonusTokens)).add(sentTokens.sub(claimedSentTokens));
525 	}
526 
527 	function setTokenContract(Token token) external onlyOwner {
528 		require(token.balanceOf(this) >= 0);
529 		require(tokenContract == address(0));
530 		require(token != address(0));
531 		tokenContract = token;
532 	}
533 
534 	function getInvestorClaimedTokens(address _investor) external view returns (uint256) {
535 		if (tokenContract != address(0)) {
536 			return tokenContract.balanceOf(_investor);
537 		}
538 		return 0;
539 	}
540 
541 	function isBlockpassInvestor(address _investor) external constant returns (bool) {
542 		return investors[_investor].status == InvestorStatus.WHITELISTED && investors[_investor].isBlockpass;
543 	}
544 
545 	function whitelistInvestor(address _investor, bool _isBlockpass) external onlyOwnerOrStaff {
546 		require(_investor != address(0));
547 		require(investors[_investor].status != InvestorStatus.WHITELISTED);
548 
549 		investors[_investor].status = InvestorStatus.WHITELISTED;
550 		investors[_investor].isBlockpass = _isBlockpass;
551 
552 		emit InvestorWhitelisted(_investor, now, msg.sender);
553 	}
554 
555 	function bulkWhitelistInvestor(address[] _investors) external onlyOwnerOrStaff {
556 		for (uint256 i = 0; i < _investors.length; i++) {
557 			if (_investors[i] != address(0) && investors[_investors[i]].status != InvestorStatus.WHITELISTED) {
558 				investors[_investors[i]].status = InvestorStatus.WHITELISTED;
559 				emit InvestorWhitelisted(_investors[i], now, msg.sender);
560 			}
561 		}
562 	}
563 
564 	function blockInvestor(address _investor) external onlyOwnerOrStaff {
565 		require(_investor != address(0));
566 		require(investors[_investor].status != InvestorStatus.BLOCKED);
567 
568 		investors[_investor].status = InvestorStatus.BLOCKED;
569 
570 		emit InvestorBlocked(_investor, now, msg.sender);
571 	}
572 
573 	function lockPurchasedTokensClaim(uint256 _date) external onlyOwner {
574 		require(_date > now);
575 		purchasedTokensClaimDate = _date;
576 		emit PurchasedTokensClaimLocked(_date, now, msg.sender);
577 	}
578 
579 	function unlockPurchasedTokensClaim() external onlyOwner {
580 		purchasedTokensClaimDate = now;
581 		emit PurchasedTokensClaimUnlocked(now, msg.sender);
582 	}
583 
584 	function lockBonusTokensClaim(uint256 _date) external onlyOwner {
585 		require(_date > now);
586 		bonusTokensClaimDate = _date;
587 		emit BonusTokensClaimLocked(_date, now, msg.sender);
588 	}
589 
590 	function unlockBonusTokensClaim() external onlyOwner {
591 		bonusTokensClaimDate = now;
592 		emit BonusTokensClaimUnlocked(now, msg.sender);
593 	}
594 
595 	function setCrowdsaleStartDate(uint256 _date) external onlyOwner {
596 		crowdsaleStartDate = _date;
597 		emit CrowdsaleStartDateUpdated(_date, now, msg.sender);
598 	}
599 
600 	function setEndDate(uint256 _date) external onlyOwner {
601 		endDate = _date;
602 		emit EndDateUpdated(_date, now, msg.sender);
603 	}
604 
605 	function setMinPurchaseInWei(uint256 _minPurchaseInWei) external onlyOwner {
606 		minPurchaseInWei = _minPurchaseInWei;
607 		emit MinPurchaseChanged(_minPurchaseInWei, now, msg.sender);
608 	}
609 
610 	function setMaxInvestorContributionInWei(uint256 _maxInvestorContributionInWei) external onlyOwner {
611 		require(minPurchaseInWei <= _maxInvestorContributionInWei);
612 		maxInvestorContributionInWei = _maxInvestorContributionInWei;
613 		emit MaxInvestorContributionChanged(_maxInvestorContributionInWei, now, msg.sender);
614 	}
615 
616 	function changeTokenRate(uint256 _tokenRate) external onlyOwner {
617 		require(_tokenRate > 0);
618 		tokenRate = _tokenRate;
619 		emit TokenRateChanged(_tokenRate, now, msg.sender);
620 	}
621 
622 	function buyTokens(bytes32 _promoCode, address _referrer) external payable {
623 		require(!finalized);
624 		require(!paused);
625 		require(startDate < now);
626 		require(investors[msg.sender].status == InvestorStatus.WHITELISTED);
627 		require(msg.value > 0);
628 		require(msg.value >= minPurchaseInWei);
629 		require(investors[msg.sender].contributionInWei.add(msg.value) <= maxInvestorContributionInWei);
630 
631 		// calculate purchased amount
632 		uint256 purchasedAmount;
633 		if (tokenDecimals > 18) {
634 			purchasedAmount = msg.value.mul(tokenRate).mul(10 ** (tokenDecimals - 18));
635 		} else if (tokenDecimals < 18) {
636 			purchasedAmount = msg.value.mul(tokenRate).div(10 ** (18 - tokenDecimals));
637 		} else {
638 			purchasedAmount = msg.value.mul(tokenRate);
639 		}
640 
641 		// calculate total amount, this includes promo code amount or discount phase amount
642 		uint256 promoCodeBonusAmount = promoCodesContract.applyBonusAmount(msg.sender, purchasedAmount, _promoCode);
643 		uint256 discountPhaseBonusAmount = discountPhasesContract.calculateBonusAmount(purchasedAmount);
644 		uint256 discountStructBonusAmount = discountStructsContract.getBonus(msg.sender, purchasedAmount, msg.value);
645 		uint256 bonusAmount = promoCodeBonusAmount.add(discountPhaseBonusAmount).add(discountStructBonusAmount);
646 
647 		// update referrer's referral tokens
648 		uint256 referrerBonusAmount;
649 		address referrerAddr;
650 		if (
651 			_referrer != address(0)
652 			&& msg.sender != _referrer
653 			&& investors[_referrer].status == InvestorStatus.WHITELISTED
654 		) {
655 			referrerBonusAmount = purchasedAmount * referralBonusPercent / 100;
656 			referrerAddr = _referrer;
657 		}
658 
659 		// check that calculated tokens will not exceed tokens for sale cap
660 		require(fitsTokensForSaleCap(purchasedAmount.add(bonusAmount).add(referrerBonusAmount)));
661 
662 		// update crowdsale total amount of capital raised
663 		weiRaised = weiRaised.add(msg.value);
664 		soldTokens = soldTokens.add(purchasedAmount);
665 		bonusTokens = bonusTokens.add(bonusAmount).add(referrerBonusAmount);
666 
667 		// update referrer's bonus tokens
668 		investors[referrerAddr].referralTokens = investors[referrerAddr].referralTokens.add(referrerBonusAmount);
669 
670 		// update investor's purchased tokens
671 		investors[msg.sender].purchasedTokens = investors[msg.sender].purchasedTokens.add(purchasedAmount);
672 
673 		// update investor's bonus tokens
674 		investors[msg.sender].bonusTokens = investors[msg.sender].bonusTokens.add(bonusAmount);
675 
676 		// update investor's tokens eth value
677 		investors[msg.sender].contributionInWei = investors[msg.sender].contributionInWei.add(msg.value);
678 
679 		// update investor's tokens purchases
680 		uint tokensPurchasesLength = investors[msg.sender].tokensPurchases.push(TokensPurchase({
681 			value : msg.value,
682 			amount : purchasedAmount,
683 			bonus : bonusAmount,
684 			referrer : referrerAddr,
685 			referrerSentAmount : referrerBonusAmount
686 			})
687 		);
688 
689 		// log investor's tokens purchase
690 		emit TokensPurchased(
691 			msg.sender,
692 			tokensPurchasesLength - 1,
693 			msg.value,
694 			purchasedAmount,
695 			promoCodeBonusAmount,
696 			discountPhaseBonusAmount,
697 			discountStructBonusAmount,
698 			referrerAddr,
699 			referrerBonusAmount,
700 			now
701 		);
702 
703 		// forward eth to funds wallet
704 		require(ethFundsWallet.call.gas(300000).value(msg.value)());
705 	}
706 
707 	function sendTokens(address _investor, uint256 _amount) external onlyOwner {
708 		require(investors[_investor].status == InvestorStatus.WHITELISTED);
709 		require(_amount > 0);
710 		require(fitsTokensForSaleCap(_amount));
711 
712 		// update crowdsale total amount of capital raised
713 		sentTokens = sentTokens.add(_amount);
714 
715 		// update investor's received tokens balance
716 		investors[_investor].receivedTokens = investors[_investor].receivedTokens.add(_amount);
717 
718 		// log tokens sent action
719 		emit TokensSent(
720 			_investor,
721 			_amount,
722 			now,
723 			msg.sender
724 		);
725 	}
726 
727 	function burnUnsoldTokens() external onlyOwner {
728 		require(tokenContract != address(0));
729 		require(finalized);
730 
731 		uint256 tokensToBurn = tokenContract.balanceOf(this).sub(getDistributedTokens());
732 		require(tokensToBurn > 0);
733 
734 		tokenContract.burn(tokensToBurn);
735 
736 		// log tokens burned action
737 		emit TokensBurned(tokensToBurn, now, msg.sender);
738 	}
739 
740 	function claimTokens() external {
741 		require(tokenContract != address(0));
742 		require(!paused);
743 		require(investors[msg.sender].status == InvestorStatus.WHITELISTED);
744 
745 		uint256 clPurchasedTokens;
746 		uint256 clReceivedTokens;
747 		uint256 clBonusTokens_;
748 		uint256 clRefTokens;
749 
750 		require(purchasedTokensClaimDate < now || bonusTokensClaimDate < now);
751 
752 		{
753 			uint256 purchasedTokens = investors[msg.sender].purchasedTokens;
754 			uint256 receivedTokens = investors[msg.sender].receivedTokens;
755 			if (purchasedTokensClaimDate < now && (purchasedTokens > 0 || receivedTokens > 0)) {
756 				investors[msg.sender].contributionInWei = 0;
757 				investors[msg.sender].purchasedTokens = 0;
758 				investors[msg.sender].receivedTokens = 0;
759 
760 				claimedSoldTokens = claimedSoldTokens.add(purchasedTokens);
761 				claimedSentTokens = claimedSentTokens.add(receivedTokens);
762 
763 				// free up storage used by transaction
764 				delete (investors[msg.sender].tokensPurchases);
765 
766 				clPurchasedTokens = purchasedTokens;
767 				clReceivedTokens = receivedTokens;
768 
769 				tokenContract.transfer(msg.sender, purchasedTokens.add(receivedTokens));
770 			}
771 		}
772 
773 		{
774 			uint256 bonusTokens_ = investors[msg.sender].bonusTokens;
775 			uint256 refTokens = investors[msg.sender].referralTokens;
776 			if (bonusTokensClaimDate < now && (bonusTokens_ > 0 || refTokens > 0)) {
777 				investors[msg.sender].bonusTokens = 0;
778 				investors[msg.sender].referralTokens = 0;
779 
780 				claimedBonusTokens = claimedBonusTokens.add(bonusTokens_).add(refTokens);
781 
782 				clBonusTokens_ = bonusTokens_;
783 				clRefTokens = refTokens;
784 
785 				tokenContract.transfer(msg.sender, bonusTokens_.add(refTokens));
786 			}
787 		}
788 
789 		require(clPurchasedTokens > 0 || clBonusTokens_ > 0 || clRefTokens > 0 || clReceivedTokens > 0);
790 		emit TokensClaimed(msg.sender, clPurchasedTokens, clBonusTokens_, clRefTokens, clReceivedTokens, now, msg.sender);
791 	}
792 
793 	function refundTokensPurchase(address _investor, uint _purchaseId) external payable onlyOwner {
794 		require(msg.value > 0);
795 		require(investors[_investor].tokensPurchases[_purchaseId].value == msg.value);
796 
797 		_refundTokensPurchase(_investor, _purchaseId);
798 
799 		// forward eth to investor's wallet address
800 		_investor.transfer(msg.value);
801 	}
802 
803 	function refundAllInvestorTokensPurchases(address _investor) external payable onlyOwner {
804 		require(msg.value > 0);
805 		require(investors[_investor].contributionInWei == msg.value);
806 
807 		for (uint i = 0; i < investors[_investor].tokensPurchases.length; i++) {
808 			if (investors[_investor].tokensPurchases[i].value == 0) {
809 				continue;
810 			}
811 
812 			_refundTokensPurchase(_investor, i);
813 		}
814 
815 		// forward eth to investor's wallet address
816 		_investor.transfer(msg.value);
817 	}
818 
819 	function _refundTokensPurchase(address _investor, uint _purchaseId) private {
820 		// update referrer's referral tokens
821 		address referrer = investors[_investor].tokensPurchases[_purchaseId].referrer;
822 		if (referrer != address(0)) {
823 			uint256 sentAmount = investors[_investor].tokensPurchases[_purchaseId].referrerSentAmount;
824 			investors[referrer].referralTokens = investors[referrer].referralTokens.sub(sentAmount);
825 			bonusTokens = bonusTokens.sub(sentAmount);
826 		}
827 
828 		// update investor's eth amount
829 		uint256 purchaseValue = investors[_investor].tokensPurchases[_purchaseId].value;
830 		investors[_investor].contributionInWei = investors[_investor].contributionInWei.sub(purchaseValue);
831 
832 		// update investor's purchased tokens
833 		uint256 purchaseAmount = investors[_investor].tokensPurchases[_purchaseId].amount;
834 		investors[_investor].purchasedTokens = investors[_investor].purchasedTokens.sub(purchaseAmount);
835 
836 		// update investor's bonus tokens
837 		uint256 bonusAmount = investors[_investor].tokensPurchases[_purchaseId].bonus;
838 		investors[_investor].bonusTokens = investors[_investor].bonusTokens.sub(bonusAmount);
839 
840 		// update crowdsale total amount of capital raised
841 		weiRaised = weiRaised.sub(purchaseValue);
842 		soldTokens = soldTokens.sub(purchaseAmount);
843 		bonusTokens = bonusTokens.sub(bonusAmount);
844 
845 		// free up storage used by transaction
846 		delete (investors[_investor].tokensPurchases[_purchaseId]);
847 
848 		// log investor's tokens purchase refund
849 		emit TokensPurchaseRefunded(_investor, _purchaseId, purchaseValue, purchaseAmount, bonusAmount, now, msg.sender);
850 	}
851 
852 	function getInvestorTokensPurchasesLength(address _investor) public constant returns (uint) {
853 		return investors[_investor].tokensPurchases.length;
854 	}
855 
856 	function getInvestorTokensPurchase(
857 		address _investor,
858 		uint _purchaseId
859 	) external constant returns (
860 		uint256 value,
861 		uint256 amount,
862 		uint256 bonus,
863 		address referrer,
864 		uint256 referrerSentAmount
865 	) {
866 		value = investors[_investor].tokensPurchases[_purchaseId].value;
867 		amount = investors[_investor].tokensPurchases[_purchaseId].amount;
868 		bonus = investors[_investor].tokensPurchases[_purchaseId].bonus;
869 		referrer = investors[_investor].tokensPurchases[_purchaseId].referrer;
870 		referrerSentAmount = investors[_investor].tokensPurchases[_purchaseId].referrerSentAmount;
871 	}
872 
873 	function pause() external onlyOwner {
874 		require(!paused);
875 
876 		paused = true;
877 
878 		emit Paused(now, msg.sender);
879 	}
880 
881 	function resume() external onlyOwner {
882 		require(paused);
883 
884 		paused = false;
885 
886 		emit Resumed(now, msg.sender);
887 	}
888 
889 	function finalize() external onlyOwner {
890 		require(!finalized);
891 
892 		finalized = true;
893 
894 		emit Finalized(now, msg.sender);
895 	}
896 }
897 
898 contract DiscountPhases is StaffUtil {
899 	using SafeMath for uint256;
900 
901 	event DiscountPhaseAdded(uint index, string name, uint8 percent, uint fromDate, uint toDate, uint timestamp, address byStaff);
902 	event DiscountPhaseRemoved(uint index, uint timestamp, address byStaff);
903 
904 	struct DiscountPhase {
905 		uint8 percent;
906 		uint fromDate;
907 		uint toDate;
908 	}
909 
910 	DiscountPhase[] public discountPhases;
911 
912 	constructor(Staff _staffContract) StaffUtil(_staffContract) public {
913 	}
914 
915 	function calculateBonusAmount(uint256 _purchasedAmount) public constant returns (uint256) {
916 		for (uint i = 0; i < discountPhases.length; i++) {
917 			if (now >= discountPhases[i].fromDate && now <= discountPhases[i].toDate) {
918 				return _purchasedAmount.mul(discountPhases[i].percent).div(100);
919 			}
920 		}
921 	}
922 
923 	function addDiscountPhase(string _name, uint8 _percent, uint _fromDate, uint _toDate) public onlyOwnerOrStaff {
924 		require(bytes(_name).length > 0);
925 		require(_percent > 0 && _percent <= 100);
926 
927 		if (now > _fromDate) {
928 			_fromDate = now;
929 		}
930 		require(_fromDate < _toDate);
931 
932 		for (uint i = 0; i < discountPhases.length; i++) {
933 			require(_fromDate > discountPhases[i].toDate || _toDate < discountPhases[i].fromDate);
934 		}
935 
936 		uint index = discountPhases.push(DiscountPhase({percent : _percent, fromDate : _fromDate, toDate : _toDate})) - 1;
937 
938 		emit DiscountPhaseAdded(index, _name, _percent, _fromDate, _toDate, now, msg.sender);
939 	}
940 
941 	function removeDiscountPhase(uint _index) public onlyOwnerOrStaff {
942 		require(now < discountPhases[_index].toDate);
943 		delete discountPhases[_index];
944 		emit DiscountPhaseRemoved(_index, now, msg.sender);
945 	}
946 }
947 
948 contract DiscountStructs is StaffUtil {
949 	using SafeMath for uint256;
950 
951 	address public crowdsale;
952 
953 	event DiscountStructAdded(
954 		uint index,
955 		bytes32 name,
956 		uint256 tokens,
957 		uint[2] dates,
958 		uint256[] fromWei,
959 		uint256[] toWei,
960 		uint256[] percent,
961 		uint timestamp,
962 		address byStaff
963 	);
964 	event DiscountStructRemoved(
965 		uint index,
966 		uint timestamp,
967 		address byStaff
968 	);
969 	event DiscountStructUsed(
970 		uint index,
971 		uint step,
972 		address investor,
973 		uint256 tokens,
974 		uint timestamp
975 	);
976 
977 	struct DiscountStruct {
978 		uint256 availableTokens;
979 		uint256 distributedTokens;
980 		uint fromDate;
981 		uint toDate;
982 	}
983 
984 	struct DiscountStep {
985 		uint256 fromWei;
986 		uint256 toWei;
987 		uint256 percent;
988 	}
989 
990 	DiscountStruct[] public discountStructs;
991 	mapping(uint => DiscountStep[]) public discountSteps;
992 
993 	constructor(Staff _staffContract) StaffUtil(_staffContract) public {
994 	}
995 
996 	modifier onlyCrowdsale() {
997 		require(msg.sender == crowdsale);
998 		_;
999 	}
1000 
1001 	function setCrowdsale(Crowdsale _crowdsale) external onlyOwner {
1002 		require(crowdsale == address(0));
1003 		require(_crowdsale.staffContract() == staffContract);
1004 		crowdsale = _crowdsale;
1005 	}
1006 
1007 	function getBonus(address _investor, uint256 _purchasedAmount, uint256 _purchasedValue) public onlyCrowdsale returns (uint256) {
1008 		for (uint i = 0; i < discountStructs.length; i++) {
1009 			if (now >= discountStructs[i].fromDate && now <= discountStructs[i].toDate) {
1010 
1011 				if (discountStructs[i].distributedTokens >= discountStructs[i].availableTokens) {
1012 					return;
1013 				}
1014 
1015 				for (uint j = 0; j < discountSteps[i].length; j++) {
1016 					if (_purchasedValue >= discountSteps[i][j].fromWei
1017 						&& (_purchasedValue < discountSteps[i][j].toWei || discountSteps[i][j].toWei == 0)) {
1018 						uint256 bonus = _purchasedAmount.mul(discountSteps[i][j].percent).div(100);
1019 						if (discountStructs[i].distributedTokens.add(bonus) > discountStructs[i].availableTokens) {
1020 							return;
1021 						}
1022 						discountStructs[i].distributedTokens = discountStructs[i].distributedTokens.add(bonus);
1023 						emit DiscountStructUsed(i, j, _investor, bonus, now);
1024 						return bonus;
1025 					}
1026 				}
1027 
1028 				return;
1029 			}
1030 		}
1031 	}
1032 
1033 	function calculateBonus(uint256 _purchasedAmount, uint256 _purchasedValue) public constant returns (uint256) {
1034 		for (uint i = 0; i < discountStructs.length; i++) {
1035 			if (now >= discountStructs[i].fromDate && now <= discountStructs[i].toDate) {
1036 
1037 				if (discountStructs[i].distributedTokens >= discountStructs[i].availableTokens) {
1038 					return;
1039 				}
1040 
1041 				for (uint j = 0; j < discountSteps[i].length; j++) {
1042 					if (_purchasedValue >= discountSteps[i][j].fromWei
1043 						&& (_purchasedValue < discountSteps[i][j].toWei || discountSteps[i][j].toWei == 0)) {
1044 						uint256 bonus = _purchasedAmount.mul(discountSteps[i][j].percent).div(100);
1045 						if (discountStructs[i].distributedTokens.add(bonus) > discountStructs[i].availableTokens) {
1046 							return;
1047 						}
1048 						return bonus;
1049 					}
1050 				}
1051 
1052 				return;
1053 			}
1054 		}
1055 	}
1056 
1057 	function addDiscountStruct(bytes32 _name, uint256 _tokens, uint[2] _dates, uint256[] _fromWei, uint256[] _toWei, uint256[] _percent) external onlyOwnerOrStaff {
1058 		require(_name.length > 0);
1059 		require(_tokens > 0);
1060 		require(_dates[0] < _dates[1]);
1061 		require(_fromWei.length > 0 && _fromWei.length == _toWei.length && _fromWei.length == _percent.length);
1062 
1063 		for (uint j = 0; j < discountStructs.length; j++) {
1064 			require(_dates[0] > discountStructs[j].fromDate || _dates[1] < discountStructs[j].toDate);
1065 		}
1066 
1067 		DiscountStruct memory ds = DiscountStruct(_tokens, 0, _dates[0], _dates[1]);
1068 		uint index = discountStructs.push(ds) - 1;
1069 
1070 		for (uint i = 0; i < _fromWei.length; i++) {
1071 			require(_fromWei[i] > 0 || _toWei[i] > 0);
1072 			if (_fromWei[i] > 0 && _toWei[i] > 0) {
1073 				require(_fromWei[i] < _toWei[i]);
1074 			}
1075 			require(_percent[i] > 0 && _percent[i] <= 100);
1076 			discountSteps[index].push(DiscountStep(_fromWei[i], _toWei[i], _percent[i]));
1077 		}
1078 
1079 		emit DiscountStructAdded(index, _name, _tokens, _dates, _fromWei, _toWei, _percent, now, msg.sender);
1080 	}
1081 
1082 	function removeDiscountStruct(uint _index) public onlyOwnerOrStaff {
1083 		require(now < discountStructs[_index].toDate);
1084 		delete discountStructs[_index];
1085 		delete discountSteps[_index];
1086 		emit DiscountStructRemoved(_index, now, msg.sender);
1087 	}
1088 }
1089 
1090 contract PromoCodes is StaffUtil {
1091 	using SafeMath for uint256;
1092 
1093 	address public crowdsale;
1094 
1095 	event PromoCodeAdded(bytes32 indexed code, string name, uint8 percent, uint256 maxUses, uint timestamp, address byStaff);
1096 	event PromoCodeRemoved(bytes32 indexed code, uint timestamp, address byStaff);
1097 	event PromoCodeUsed(bytes32 indexed code, address investor, uint timestamp);
1098 
1099 	struct PromoCode {
1100 		uint8 percent;
1101 		uint256 uses;
1102 		uint256 maxUses;
1103 		mapping(address => bool) investors;
1104 	}
1105 
1106 	mapping(bytes32 => PromoCode) public promoCodes;
1107 
1108 	constructor(Staff _staffContract) StaffUtil(_staffContract) public {
1109 	}
1110 
1111 	modifier onlyCrowdsale() {
1112 		require(msg.sender == crowdsale);
1113 		_;
1114 	}
1115 
1116 	function setCrowdsale(Crowdsale _crowdsale) external onlyOwner {
1117 		require(crowdsale == address(0));
1118 		require(_crowdsale.staffContract() == staffContract);
1119 		crowdsale = _crowdsale;
1120 	}
1121 
1122 	function applyBonusAmount(address _investor, uint256 _purchasedAmount, bytes32 _promoCode) public onlyCrowdsale returns (uint256) {
1123 		if (promoCodes[_promoCode].percent == 0
1124 		|| promoCodes[_promoCode].investors[_investor]
1125 		|| promoCodes[_promoCode].uses == promoCodes[_promoCode].maxUses) {
1126 			return 0;
1127 		}
1128 		promoCodes[_promoCode].investors[_investor] = true;
1129 		promoCodes[_promoCode].uses = promoCodes[_promoCode].uses + 1;
1130 		emit PromoCodeUsed(_promoCode, _investor, now);
1131 		return _purchasedAmount.mul(promoCodes[_promoCode].percent).div(100);
1132 	}
1133 
1134 	function calculateBonusAmount(address _investor, uint256 _purchasedAmount, bytes32 _promoCode) public constant returns (uint256) {
1135 		if (promoCodes[_promoCode].percent == 0
1136 		|| promoCodes[_promoCode].investors[_investor]
1137 		|| promoCodes[_promoCode].uses == promoCodes[_promoCode].maxUses) {
1138 			return 0;
1139 		}
1140 		return _purchasedAmount.mul(promoCodes[_promoCode].percent).div(100);
1141 	}
1142 
1143 	function addPromoCode(string _name, bytes32 _code, uint256 _maxUses, uint8 _percent) public onlyOwnerOrStaff {
1144 		require(bytes(_name).length > 0);
1145 		require(_code[0] != 0);
1146 		require(_percent > 0 && _percent <= 100);
1147 		require(_maxUses > 0);
1148 		require(promoCodes[_code].percent == 0);
1149 
1150 		promoCodes[_code].percent = _percent;
1151 		promoCodes[_code].maxUses = _maxUses;
1152 
1153 		emit PromoCodeAdded(_code, _name, _percent, _maxUses, now, msg.sender);
1154 	}
1155 
1156 	function removePromoCode(bytes32 _code) public onlyOwnerOrStaff {
1157 		delete promoCodes[_code];
1158 		emit PromoCodeRemoved(_code, now, msg.sender);
1159 	}
1160 }
1161 
1162 contract Token is BurnableToken {
1163 }