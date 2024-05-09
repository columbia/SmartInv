1 pragma solidity 0.5.9;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8 	struct Role {
9 		mapping (address => bool) bearer;
10 	}
11 
12 	/**
13 	 * @dev give an account access to this role
14 	 */
15 	function add(Role storage role, address account) internal {
16 		require(account != address(0));
17 		require(!has(role, account));
18 
19 		role.bearer[account] = true;
20 	}
21 
22 	/**
23 	 * @dev remove an account's access to this role
24 	 */
25 	function remove(Role storage role, address account) internal {
26 		require(account != address(0));
27 		require(has(role, account));
28 
29 		role.bearer[account] = false;
30 	}
31 
32 	/**
33 	 * @dev check if an account has this role
34 	 * @return bool
35 	 */
36 	function has(Role storage role, address account) internal view returns (bool) {
37 		require(account != address(0));
38 		return role.bearer[account];
39 	}
40 }
41 contract ETORoles {
42 	using Roles for Roles.Role;
43 
44 	constructor() internal {
45 		_addAuditWriter(msg.sender);
46 		_addAssetSeizer(msg.sender);
47 		_addKycProvider(msg.sender);
48 		_addUserManager(msg.sender);
49 		_addOwner(msg.sender);
50 	}
51 
52 	/*
53 	 * Audit Writer functions
54 	 */
55 	event AuditWriterAdded(address indexed account);
56 	event AuditWriterRemoved(address indexed account);
57 
58 	Roles.Role private _auditWriters;
59 
60 	modifier onlyAuditWriter() {
61 		require(isAuditWriter(msg.sender), "Sender is not auditWriter");
62 		_;
63 	}
64 
65 	function isAuditWriter(address account) public view returns (bool) {
66 		return _auditWriters.has(account);
67 	}
68 
69 	function addAuditWriter(address account) public onlyUserManager {
70 		_addAuditWriter(account);
71 	}
72 
73 	function renounceAuditWriter() public {
74 		_removeAuditWriter(msg.sender);
75 	}
76 
77 	function _addAuditWriter(address account) internal {
78 		_auditWriters.add(account);
79 		emit AuditWriterAdded(account);
80 	}
81 
82 	function _removeAuditWriter(address account) internal {
83 		_auditWriters.remove(account);
84 		emit AuditWriterRemoved(account);
85 	}
86 
87 	/*
88 	* KYC Provider functions
89 	*/
90 	event KycProviderAdded(address indexed account);
91 	event KycProviderRemoved(address indexed account);
92 
93 	Roles.Role private _kycProviders;
94 
95 	modifier onlyKycProvider() {
96 		require(isKycProvider(msg.sender), "Sender is not kycProvider");
97 		_;
98 	}
99 
100 	function isKycProvider(address account) public view returns (bool) {
101 		return _kycProviders.has(account);
102 	}
103 
104 	function addKycProvider(address account) public onlyUserManager {
105 		_addKycProvider(account);
106 	}
107 
108 	function renounceKycProvider() public {
109 		_removeKycProvider(msg.sender);
110 	}
111 
112 	function _addKycProvider(address account) internal {
113 		_kycProviders.add(account);
114 		emit KycProviderAdded(account);
115 	}
116 
117 	function _removeKycProvider(address account) internal {
118 		_kycProviders.remove(account);
119 		emit KycProviderRemoved(account);
120 	}
121 
122 	/*
123 	* Asset Seizer functions
124 	*/
125 	event AssetSeizerAdded(address indexed account);
126 	event AssetSeizerRemoved(address indexed account);
127 
128 	Roles.Role private _assetSeizers;
129 
130 	modifier onlyAssetSeizer() {
131 		require(isAssetSeizer(msg.sender), "Sender is not assetSeizer");
132 		_;
133 	}
134 
135 	function isAssetSeizer(address account) public view returns (bool) {
136 		return _assetSeizers.has(account);
137 	}
138 
139 	function addAssetSeizer(address account) public onlyUserManager {
140 		_addAssetSeizer(account);
141 	}
142 
143 	function renounceAssetSeizer() public {
144 		_removeAssetSeizer(msg.sender);
145 	}
146 
147 	function _addAssetSeizer(address account) internal {
148 		_assetSeizers.add(account);
149 		emit AssetSeizerAdded(account);
150 	}
151 
152 	function _removeAssetSeizer(address account) internal {
153 		_assetSeizers.remove(account);
154 		emit AssetSeizerRemoved(account);
155 	}
156 
157 	/*
158 	* User Manager functions
159 	*/
160 	event UserManagerAdded(address indexed account);
161 	event UserManagerRemoved(address indexed account);
162 
163 	Roles.Role private _userManagers;
164 
165 	modifier onlyUserManager() {
166 		require(isUserManager(msg.sender), "Sender is not UserManager");
167 		_;
168 	}
169 
170 	function isUserManager(address account) public view returns (bool) {
171 		return _userManagers.has(account);
172 	}
173 
174 	function addUserManager(address account) public onlyUserManager {
175 		_addUserManager(account);
176 	}
177 
178 	function renounceUserManager() public {
179 		_removeUserManager(msg.sender);
180 	}
181 
182 	function _addUserManager(address account) internal {
183 		_userManagers.add(account);
184 		emit UserManagerAdded(account);
185 	}
186 
187 	function _removeUserManager(address account) internal {
188 		_userManagers.remove(account);
189 		emit UserManagerRemoved(account);
190 	}
191 
192 	/*
193 	* Owner functions
194 	*/
195 	event OwnerAdded(address indexed account);
196 	event OwnerRemoved(address indexed account);
197 
198 	Roles.Role private _owners;
199 
200 	modifier onlyOwner() {
201 		require(isOwner(msg.sender), "Sender is not owner");
202 		_;
203 	}
204 
205 	function isOwner(address account) public view returns (bool) {
206 		return _owners.has(account);
207 	}
208 
209 	function addOwner(address account) public onlyUserManager {
210 		_addOwner(account);
211 	}
212 
213 	function renounceOwner() public {
214 		_removeOwner(msg.sender);
215 	}
216 
217 	function _addOwner(address account) internal {
218 		_owners.add(account);
219 		emit OwnerAdded(account);
220 	}
221 
222 	function _removeOwner(address account) internal {
223 		_owners.remove(account);
224 		emit OwnerRemoved(account);
225 	}
226 
227 }
228 
229 /**
230  * @title ERC20 interface
231  * @dev see https://eips.ethereum.org/EIPS/eip-20
232  */
233 interface IERC20 {
234 	function transfer(address to, uint256 value) external returns (bool);
235 
236 	function approve(address spender, uint256 value) external returns (bool);
237 
238 	function transferFrom(address from, address to, uint256 value) external returns (bool);
239 
240 	function totalSupply() external view returns (uint256);
241 
242 	function balanceOf(address who) external view returns (uint256);
243 
244 	function allowance(address owner, address spender) external view returns (uint256);
245 
246 	event Transfer(address indexed from, address indexed to, uint256 value);
247 
248 	event Approval(address indexed owner, address indexed spender, uint256 value);
249 }
250 
251 /**
252  * @title SafeMath
253  * @dev Unsigned math operations with safety checks that revert on error
254  */
255 library SafeMath {
256 	/**
257 	* @dev Multiplies two unsigned integers, reverts on overflow.
258 	*/
259 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
261 		// benefit is lost if 'b' is also tested.
262 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
263 		if (a == 0) {
264 			return 0;
265 		}
266 
267 		uint256 c = a * b;
268 		require(c / a == b);
269 
270 		return c;
271 	}
272 
273 	/**
274 	* @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
275 	*/
276 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
277 		// Solidity only automatically asserts when dividing by 0
278 		require(b > 0);
279 		uint256 c = a / b;
280 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
281 
282 		return c;
283 	}
284 
285 	/**
286 	* @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
287 	*/
288 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
289 		require(b <= a);
290 		uint256 c = a - b;
291 
292 		return c;
293 	}
294 
295 	/**
296 	* @dev Adds two unsigned integers, reverts on overflow.
297 	*/
298 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
299 		uint256 c = a + b;
300 		require(c >= a);
301 
302 		return c;
303 	}
304 
305 	/**
306 	* @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
307 	* reverts when dividing by zero.
308 		*/
309 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
310 		require(b != 0);
311 		return a % b;
312 	}
313 }
314 
315 contract ERC20 is IERC20 {
316 	using SafeMath for uint256;
317 
318 	mapping (address => uint256) private _balances;
319 
320 	mapping (address => mapping (address => uint256)) private _allowed;
321 
322 	uint256 private _totalSupply;
323 
324 	/**
325 	* @dev Total number of tokens in existence
326 	*/
327 	function totalSupply() public view returns (uint256) {
328 		return _totalSupply;
329 	}
330 
331 	/**
332 	* @dev Gets the balance of the specified address.
333 	* @param owner The address to query the balance of.
334 		* @return A uint256 representing the amount owned by the passed address.
335 		*/
336 	function balanceOf(address owner) public view returns (uint256) {
337 		return _balances[owner];
338 	}
339 
340 	/**
341 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
342 	* @param owner address The address which owns the funds.
343 		* @param spender address The address which will spend the funds.
344 		* @return A uint256 specifying the amount of tokens still available for the spender.
345 		*/
346 	function allowance(address owner, address spender) public view returns (uint256) {
347 		return _allowed[owner][spender];
348 	}
349 
350 	/**
351 	* @dev Transfer token to a specified address
352 	* @param to The address to transfer to.
353 		* @param value The amount to be transferred.
354 		*/
355 	function transfer(address to, uint256 value) public returns (bool) {
356 		_transfer(msg.sender, to, value);
357 		return true;
358 	}
359 
360 	/**
361 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
362 	* Beware that changing an allowance with this method brings the risk that someone may use both the old
363 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
364 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
365 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
366 	* @param spender The address which will spend the funds.
367 		* @param value The amount of tokens to be spent.
368 		*/
369 	function approve(address spender, uint256 value) public returns (bool) {
370 		_approve(msg.sender, spender, value);
371 		return true;
372 	}
373 
374 	/**
375 	* @dev Transfer tokens from one address to another.
376 	* Note that while this function emits an Approval event, this is not required as per the specification,
377 		* and other compliant implementations may not emit the event.
378 		* @param from address The address which you want to send tokens from
379 	* @param to address The address which you want to transfer to
380 	* @param value uint256 the amount of tokens to be transferred
381 	*/
382 	function transferFrom(address from, address to, uint256 value) public returns (bool) {
383 		_transfer(from, to, value);
384 		_approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
385 		return true;
386 	}
387 
388 	/**
389 	* @dev Increase the amount of tokens that an owner allowed to a spender.
390 	* approve should be called when _allowed[msg.sender][spender] == 0. To increment
391 	* allowed value is better to use this function to avoid 2 calls 
392 	*/
393 	function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
394 		_approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
395 		return true;
396 	}
397 
398 	/**
399 	* @dev Decrease the amount of tokens that an owner allowed to a spender.
400 	* approve should be called when _allowed[msg.sender][spender] == 0. To decrement
401 	* allowed value is better to use this function to avoid 2 calls (and wait until
402 
403 	 */
404 	function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405 		_approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
406 		return true;
407 	}
408 
409 	/**
410 	* @dev Transfer token for a specified addresses
411 	* @param from The address to transfer from.
412 		* @param to The address to transfer to.
413 			* @param value The amount to be transferred.
414 			*/
415 	function _transfer(address from, address to, uint256 value) internal {
416 		require(to != address(0));
417 
418 		_balances[from] = _balances[from].sub(value);
419 		_balances[to] = _balances[to].add(value);
420 		emit Transfer(from, to, value);
421 	}
422 
423 	/**
424 	* @dev Internal function that mints an amount of the token and assigns it to
425 	* an account. This encapsulates the modification of balances such that the
426 	* proper events are emitted.
427 		* @param account The account that will receive the created tokens.
428 		* @param value The amount that will be created.
429 		*/
430 	function _mint(address account, uint256 value) internal {
431 		require(account != address(0));
432 
433 		_totalSupply = _totalSupply.add(value);
434 		_balances[account] = _balances[account].add(value);
435 		emit Transfer(address(0), account, value);
436 	}
437 
438 	/**
439 	* @dev Internal function that burns an amount of the token of a given
440 	* account.
441 		* @param account The account whose tokens will be burnt.
442 		* @param value The amount that will be burnt.
443 		*/
444 	function _burn(address account, uint256 value) internal {
445 		require(account != address(0));
446 
447 		_totalSupply = _totalSupply.sub(value);
448 		_balances[account] = _balances[account].sub(value);
449 		emit Transfer(account, address(0), value);
450 	}
451 
452 	/**
453 	* @dev Approve an address to spend another addresses' tokens.
454 	* @param owner The address that owns the tokens.
455 		* @param spender The address that will spend the tokens.
456 		* @param value The number of tokens that can be spent.
457 		*/
458 	function _approve(address owner, address spender, uint256 value) internal {
459 		require(spender != address(0));
460 		require(owner != address(0));
461 
462 		_allowed[owner][spender] = value;
463 		emit Approval(owner, spender, value);
464 	}
465 
466 	/**
467 	* @dev Internal function that burns an amount of the token of a given
468 	* account, deducting from the sender's allowance for said account. Uses the
469 	* internal burn function.
470 	* Emits an Approval event (reflecting the reduced allowance).
471 		* @param account The account whose tokens will be burnt.
472 		* @param value The amount that will be burnt.
473 		*/
474 	function _burnFrom(address account, uint256 value) internal {
475 		_burn(account, value);
476 		_approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
477 	}
478 }
479 
480 contract MinterRole {
481 	using Roles for Roles.Role;
482 
483 	event MinterAdded(address indexed account);
484 	event MinterRemoved(address indexed account);
485 
486 	Roles.Role private _minters;
487 
488 	constructor () internal {
489 		_addMinter(msg.sender);
490 	}
491 
492 	modifier onlyMinter() {
493 		require(isMinter(msg.sender));
494 		_;
495 	}
496 
497 	function isMinter(address account) public view returns (bool) {
498 		return _minters.has(account);
499 	}
500 
501 	function addMinter(address account) public onlyMinter {
502 		_addMinter(account);
503 	}
504 
505 	function renounceMinter() public {
506 		_removeMinter(msg.sender);
507 	}
508 
509 	function _addMinter(address account) internal {
510 		_minters.add(account);
511 		emit MinterAdded(account);
512 	}
513 
514 	function _removeMinter(address account) internal {
515 		_minters.remove(account);
516 		emit MinterRemoved(account);
517 	}
518 }
519 
520 /**
521  * @title ERC20Mintable
522  * @dev ERC20 minting logic
523  */
524 contract ERC20Mintable is ERC20, MinterRole {
525 	/**
526 	* @dev Function to mint tokens
527 	* @param to The address that will receive the minted tokens.
528 		* @param value The amount of tokens to mint.
529 		* @return A boolean that indicates if the operation was successful.
530 		*/
531 	function mint(address to, uint256 value) public onlyMinter returns (bool) {
532 		_mint(to, value);
533 		return true;
534 	}
535 }
536 
537 
538 contract ETOToken is ERC20Mintable, ETORoles {
539 	/* ETO investors */
540 	mapping(address => bool) public investorWhitelist;
541 	address[] public investorWhitelistLUT;
542 
543 	/* ETO contract parameters */
544 	string public constant name = "Blockstate STO Token";
545 	string public constant symbol = "BKN";
546 	uint8 public constant decimals = 0;
547 
548 	/* Listing parameters */
549 	string public ITIN;
550 
551 	/* Audit logging */
552 	mapping(uint256 => uint256) public auditHashes;
553 
554 	/* Document hashes */
555 	mapping(uint256 => uint256) public documentHashes;
556 
557 	/* Events in the ETO contract */
558 	// Transaction related events
559 	event AssetsSeized(address indexed seizee, uint256 indexed amount);
560 	event AssetsUnseized(address indexed seizee, uint256 indexed amount);
561 	event InvestorWhitelisted(address indexed investor);
562 	event InvestorBlacklisted(address indexed investor);
563 	event DividendPayout(address indexed receiver, uint256 indexed amount);
564 	event TokensGenerated(uint256 indexed amount);
565 	event OwnershipUpdated(address indexed newOwner);
566 
567 	/**
568 	* @dev Constructor that defines contract parameters
569 	*/
570 	constructor() public {
571 		ITIN = "CCF5-T3UQ-2";
572 	}
573 
574 	/* Variable update events */
575 	event ITINUpdated(string newValue);
576 
577 	/* Variable Update Functions */
578 	function setITIN(string memory newValue) public onlyOwner {
579 		ITIN = newValue;
580 		emit ITINUpdated(newValue);
581 	}
582 	
583 	/* Function to set the required allowance before seizing assets */
584 	function approveFor(address seizee, uint256 seizableAmount) public onlyAssetSeizer {
585 	    _approve(seizee, msg.sender, seizableAmount);
586 	}
587 	
588 	/* Seize assets */
589 	function seizeAssets(address seizee, uint256 seizableAmount) public onlyAssetSeizer {
590 		transferFrom(seizee, msg.sender, seizableAmount);
591 		emit AssetsSeized(seizee, seizableAmount);
592 	}
593 
594 	function releaseAssets(address seizee, uint256 seizedAmount) public onlyAssetSeizer {
595 		require(balanceOf(msg.sender) >= seizedAmount, "AssetSeizer has insufficient funds");
596 		transfer(seizee, seizedAmount);
597 		emit AssetsUnseized(seizee, seizedAmount);
598 	}
599 
600 	/* Add investor to the whitelist */
601 	function whitelistInvestor(address investor) public onlyKycProvider {
602 		require(investorWhitelist[investor] == false, "Investor already whitelisted");
603 		investorWhitelist[investor] = true;
604 		investorWhitelistLUT.push(investor);
605 		emit InvestorWhitelisted(investor);
606 	}
607 
608 	/* Remove investor from the whitelist */
609 	function blacklistInvestor(address investor) public onlyKycProvider {
610 		require(investorWhitelist[investor] == true, "Investor not on whitelist");
611 		investorWhitelist[investor] = false;
612 		uint256 arrayLen = investorWhitelistLUT.length;
613 		for (uint256 i = 0; i < arrayLen; i++) {
614 			if (investorWhitelistLUT[i] == investor) {
615 				investorWhitelistLUT[i] = investorWhitelistLUT[investorWhitelistLUT.length - 1];
616 				delete investorWhitelistLUT[investorWhitelistLUT.length - 1];
617 				break;
618 			}
619 		}
620 		emit InvestorBlacklisted(investor);
621 	}
622 
623 	/* Overwrite transfer() to respect the whitelist, tag- and drag along rules */
624 	function transfer(address to, uint256 value) public returns (bool) {
625 		require(investorWhitelist[to] == true, "Investor not whitelisted");
626 		return super.transfer(to, value);
627 	}
628 
629 	function transferFrom(address from, address to, uint256 value) public returns (bool) {
630 		require(investorWhitelist[to] == true, "Investor not whitelisted");
631 		return super.transferFrom(from, to, value);
632 	}
633 
634 	function approve(address spender, uint256 value) public returns (bool) {
635 		require(investorWhitelist[spender] == true, "Investor not whitelisted");
636 		return super.approve(spender, value);
637 	}
638 
639 	/* Generate tokens */
640 	function generateTokens(uint256 amount, address assetReceiver) public onlyMinter {
641 		_mint(assetReceiver, amount);
642 	}
643 
644 	function initiateDividendPayments(uint amount) onlyOwner public returns (bool) {
645 		uint dividendPerToken = amount / totalSupply();
646 		uint256 arrayLen = investorWhitelistLUT.length;
647 		for (uint256 i = 0; i < arrayLen; i++) {
648 			address currentInvestor = investorWhitelistLUT[i];
649 			uint256 currentInvestorShares = balanceOf(currentInvestor);
650 			uint256 currentInvestorPayout = dividendPerToken * currentInvestorShares;
651 			emit DividendPayout(currentInvestor, currentInvestorPayout);
652 		}
653 		return true;
654 	}
655 
656 	function addAuditHash(uint256 hash) public onlyAuditWriter {
657 		auditHashes[now] = hash;
658 	}
659 
660 	function getAuditHash(uint256 timestamp) public view returns (uint256) {
661 		return auditHashes[timestamp];
662 	}
663 
664 	function addDocumentHash(uint256 hash) public onlyOwner {
665 		documentHashes[now] = hash;
666 	}
667 
668 	function getDocumentHash(uint256 timestamp) public view returns (uint256) {
669 		return documentHashes[timestamp];
670 	}
671 }
672 
673 contract ETOVotes is ETOToken {
674 	event VoteOpen(uint256 _id, uint _deadline);
675 	event VoteFinished(uint256 _id, bool _result);
676 
677 	// How many blocks should we wait before the vote can be closed
678 	mapping (uint256 => Vote) private votes;
679 
680 	struct Voter {
681 		address id;
682 		bool vote;
683 	}
684 
685 	struct Vote {
686 		uint256 deadline;
687 		Voter[] voters;
688 		mapping(address => uint) votersIndex;
689 		uint256 documentHash;
690 	}
691 
692 	constructor() public {}
693 
694 	function vote(uint256 _id, bool _vote) public {
695 		// Allow changing opinion until vote deadline
696 		require (votes[_id].deadline > 0, "Vote not available");
697 		require(now <= votes[_id].deadline, "Vote deadline exceeded");
698 		if (didCastVote(_id)) {
699 			uint256 currentIndex = votes[_id].votersIndex[msg.sender];
700 			Voter memory newVoter = Voter(msg.sender, _vote);
701 			votes[_id].voters[currentIndex - 1] = newVoter;
702 		} else {
703 			votes[_id].voters.push(Voter(msg.sender, _vote));
704 			votes[_id].votersIndex[msg.sender] = votes[_id].voters.length;
705 		}
706 	}
707 
708 	function getVoteDocumentHash(uint256 _id) public view returns (uint256) {
709 		return votes[_id].documentHash;
710 	}
711 
712 	function openVote(uint256 _id, uint256 documentHash, uint256 voteDuration) onlyOwner external {
713 		require(votes[_id].deadline == 0, "Vote already ongoing");
714 		votes[_id].deadline = now + (voteDuration * 1 seconds);
715 		votes[_id].documentHash = documentHash;
716 		emit VoteOpen(_id, votes[_id].deadline);
717 	}
718 
719 	/**
720 	* @dev Once the deadline is reached this function should be called to get decision.
721 	* @param _id data source id.
722 		*/
723 	function triggerDecision(uint256 _id) external {
724 		require(votes[_id].deadline > 0, "Vote not available");
725 		require(now > votes[_id].deadline, "Vote deadline not reached");
726 		// prevent method to be called again before its done
727 		votes[_id].deadline = 0;
728 		bool result = (getCurrentPositives(_id) > getCurrentNegatives(_id));
729 		emit VoteFinished(_id, result);
730 	}
731 
732 	/**
733 	* @dev get vote status.
734 	* @param _id data source id.
735 		*/
736 	function isVoteOpen(uint256 _id) external view returns (bool) {
737 		return (votes[_id].deadline > 0) && (now <= votes[_id].deadline);
738 	}
739 
740 	/**
741 	* @dev check if address voted already.
742 	* @param _id data source identifier.
743 	*/
744 	function didCastVote(uint256 _id) public view returns (bool) {
745 		return (votes[_id].votersIndex[msg.sender] > 0);
746 	}
747 
748 	function getOwnVote(uint256 _id) public view returns (bool) {
749 		uint voterId = votes[_id].votersIndex[msg.sender];
750 		return votes[_id].voters[voterId-1].vote;
751 	}
752 
753 	function getCurrentPositives(uint256 _id) public view returns (uint256) {
754 		uint adder = 0;
755 		uint256 arrayLen = votes[_id].voters.length;
756 		for (uint256 i = 0; i < arrayLen; i++) {
757 			if (votes[_id].voters[i].vote == true) {
758 				adder += balanceOf(votes[_id].voters[i].id);
759 			}
760 		}
761 		return adder;
762 	}
763 
764 	function getCurrentNegatives(uint256 _id) public view returns (uint256) {
765 		uint adder = 0;
766 		uint256 arrayLen = votes[_id].voters.length;
767 		for (uint256 i = 0; i < arrayLen; i++) {
768 			if (votes[_id].voters[i].vote == false) {
769 				adder += balanceOf(votes[_id].voters[i].id);
770 			}
771 		}
772 		return adder;
773 	}
774 }