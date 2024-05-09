1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 pragma experimental "v0.5.0";
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d17ae0b806b2f8e69b291284bbf30321640609e3/contracts/math/SafeMath.sol
9  */
10 library SafeMath {
11 	int256 constant private INT256_MIN = -2**255;
12 
13 	/**
14 	* @dev Multiplies two unsigned integers, reverts on overflow.
15 	*/
16 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the benefit is lost if 'b' is also tested.
18 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19 		if (a == 0) {
20 			return 0;
21 		}
22 
23 		uint256 c = a * b;
24 		require(c / a == b);
25 
26 		return c;
27 	}
28 
29 	/**
30 	* @dev Multiplies two signed integers, reverts on overflow.
31 	*/
32 	function mul(int256 a, int256 b) internal pure returns (int256) {
33 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the benefit is lost if 'b' is also tested.
34 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35 		if (a == 0) {
36 			return 0;
37 		}
38 
39 		require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
40 
41 		int256 c = a * b;
42 		require(c / a == b);
43 
44 		return c;
45 	}
46 
47 	/**
48 	* @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49 	*/
50 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
51 		// Solidity only automatically asserts when dividing by 0
52 		require(b > 0);
53 		uint256 c = a / b;
54 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56 		return c;
57 	}
58 
59 	/**
60 	* @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
61 	*/
62 	function div(int256 a, int256 b) internal pure returns (int256) {
63 		require(b != 0); // Solidity only automatically asserts when dividing by 0
64 		require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
65 
66 		int256 c = a / b;
67 
68 		return c;
69 	}
70 
71 	/**
72 	* @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73 	*/
74 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75 		require(b <= a);
76 		uint256 c = a - b;
77 
78 		return c;
79 	}
80 
81 	/**
82 	* @dev Subtracts two signed integers, reverts on overflow.
83 	*/
84 	function sub(int256 a, int256 b) internal pure returns (int256) {
85 		int256 c = a - b;
86 		require((b >= 0 && c <= a) || (b < 0 && c > a));
87 
88 		return c;
89 	}
90 
91 	/**
92 	* @dev Adds two unsigned integers, reverts on overflow.
93 	*/
94 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
95 		uint256 c = a + b;
96 		require(c >= a);
97 
98 		return c;
99 	}
100 
101 	/**
102 	* @dev Adds two signed integers, reverts on overflow.
103 	*/
104 	function add(int256 a, int256 b) internal pure returns (int256) {
105 		int256 c = a + b;
106 		require((b >= 0 && c >= a) || (b < 0 && c < a));
107 
108 		return c;
109 	}
110 
111 	/**
112 	* @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.
113 	*/
114 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115 		require(b != 0);
116 		return a % b;
117 	}
118 }
119 
120 /**
121 * @title Convenience and rounding functions when dealing with numbers already factored by 10**18 or 10**27
122 * @dev Math operations with safety checks that throw on error
123 * https://github.com/dapphub/ds-math/blob/87bef2f67b043819b7195ce6df3058bd3c321107/src/math.sol
124 */
125 library SafeMathFixedPoint {
126 	using SafeMath for uint256;
127 
128 	function mul27(uint256 x, uint256 y) internal pure returns (uint256 z) {
129 		z = x.mul(y).add(5 * 10**26).div(10**27);
130 	}
131 	function mul18(uint256 x, uint256 y) internal pure returns (uint256 z) {
132 		z = x.mul(y).add(5 * 10**17).div(10**18);
133 	}
134 
135 	function div18(uint256 x, uint256 y) internal pure returns (uint256 z) {
136 		z = x.mul(10**18).add(y.div(2)).div(y);
137 	}
138 	function div27(uint256 x, uint256 y) internal pure returns (uint256 z) {
139 		z = x.mul(10**27).add(y.div(2)).div(y);
140 	}
141 }
142 
143 /**
144  * @title ERC20Basic
145  * @dev Simpler version of ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/179
147  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
148  */
149 contract ERC20Basic {
150 	function totalSupply() public view returns (uint256);
151 	function balanceOf(address who) public view returns (uint256);
152 	function transfer(address to, uint256 value) public returns (bool);
153 	event Transfer(address indexed from, address indexed to, uint256 value);
154 }
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
160  */
161 contract ERC20 is ERC20Basic {
162 	function allowance(address owner, address spender) public view returns (uint256);
163 	function transferFrom(address from, address to, uint256 value) public returns (bool);
164 	function approve(address spender, uint256 value) public returns (bool);
165 	event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 /**
169  * @title Ownable
170  * @dev The Ownable contract has an owner address, and provides basic authorization control
171  * functions, this simplifies the implementation of "user permissions".
172  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
173  */
174 contract Ownable {
175 	address public owner;
176 
177 	event OwnershipRenounced(address indexed previousOwner);
178 	event OwnershipTransferred(
179 		address indexed previousOwner,
180 		address indexed newOwner
181 	);
182 
183 	/**
184 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
185 	 * account.
186 	 */
187 	constructor() public {
188 		owner = msg.sender;
189 	}
190 
191 	/**
192 	 * @dev Throws if called by any account other than the owner.
193 	 */
194 	modifier onlyOwner() {
195 		require(msg.sender == owner);
196 		_;
197 	}
198 
199 	/**
200 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
201 	 * @param newOwner The address to transfer ownership to.
202 	 */
203 	function transferOwnership(address newOwner) public onlyOwner {
204 		require(newOwner != address(0));
205 		emit OwnershipTransferred(owner, newOwner);
206 		owner = newOwner;
207 	}
208 
209 	/**
210 	 * @dev Allows the current owner to relinquish control of the contract.
211 	 */
212 	function renounceOwnership() public onlyOwner {
213 		emit OwnershipRenounced(owner);
214 		owner = address(0);
215 	}
216 }
217 
218 /**
219  * @title Claimable
220  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
221  * This allows the new owner to accept the transfer.
222  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Claimable.sol
223  */
224 contract Claimable is Ownable {
225 	address public pendingOwner;
226 
227 	/**
228 	 * @dev Modifier throws if called by any account other than the pendingOwner.
229 	 */
230 	modifier onlyPendingOwner() {
231 		require(msg.sender == pendingOwner);
232 		_;
233 	}
234 
235 	/**
236 	 * @dev Allows the current owner to set the pendingOwner address.
237 	 * @param newOwner The address to transfer ownership to.
238 	 */
239 	function transferOwnership(address newOwner) onlyOwner public {
240 		pendingOwner = newOwner;
241 	}
242 
243 	/**
244 	 * @dev Allows the pendingOwner address to finalize the transfer.
245 	 */
246 	function claimOwnership() onlyPendingOwner public {
247 		emit OwnershipTransferred(owner, pendingOwner);
248 		owner = pendingOwner;
249 		pendingOwner = address(0);
250 	}
251 }
252 
253 /**
254  * @title Pausable
255  * @dev Base contract which allows children to implement an emergency stop mechanism.
256  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
257  */
258 contract Pausable is Ownable {
259 	event Pause();
260 	event Unpause();
261 
262 	bool public paused = false;
263 
264 
265 	/**
266 	 * @dev Modifier to make a function callable only when the contract is not paused.
267 	 */
268 	modifier whenNotPaused() {
269 		require(!paused);
270 		_;
271 	}
272 
273 	/**
274 	 * @dev Modifier to make a function callable only when the contract is paused.
275 	 */
276 	modifier whenPaused() {
277 		require(paused);
278 		_;
279 	}
280 
281 	/**
282 	 * @dev called by the owner to pause, triggers stopped state
283 	 */
284 	function pause() onlyOwner whenNotPaused public {
285 		paused = true;
286 		emit Pause();
287 	}
288 
289 	/**
290 	 * @dev called by the owner to unpause, returns to normal state
291 	 */
292 	function unpause() onlyOwner whenPaused public {
293 		paused = false;
294 		emit Unpause();
295 	}
296 }
297 
298 contract Dai is ERC20 {
299 
300 }
301 
302 contract Weth is ERC20 {
303 	function deposit() public payable;
304 	function withdraw(uint wad) public;
305 }
306 
307 contract Mkr is ERC20 {
308 
309 }
310 
311 contract Peth is ERC20 {
312 
313 }
314 
315 contract MatchingMarket {
316 	function getBuyAmount(ERC20 tokenToBuy, ERC20 tokenToPay, uint256 amountToPay) external view returns(uint256 amountBought);
317 	function getPayAmount(ERC20 tokenToPay, ERC20 tokenToBuy, uint amountToBuy) public constant returns (uint amountPaid);
318 	function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint offerId);
319 	function getWorseOffer(uint id) public constant returns(uint offerId);
320 	function getOffer(uint id) public constant returns (uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem);
321 	function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount) public returns (uint fill_amt);
322 	function buyAllAmount(ERC20 buy_gem, uint buy_amt, ERC20 pay_gem, uint max_fill_amount) public returns (uint fill_amt);
323 }
324 
325 contract DSValue {
326 	function read() external view returns(bytes32);
327 }
328 
329 contract Maker {
330 	function sai() external view returns(Dai);
331 	function gem() external view returns(Weth);
332 	function gov() external view returns(Mkr);
333 	function skr() external view returns(Peth);
334 	function pip() external view returns(DSValue);
335 	function pep() external view returns(DSValue);
336 
337 	// Join-Exit Spread
338 	 uint256 public gap;
339 
340 	struct Cup {
341 		// CDP owner
342 		address lad;
343 		// Locked collateral (in SKR)
344 		uint256 ink;
345 		// Outstanding normalised debt (tax only)
346 		uint256 art;
347 		// Outstanding normalised debt
348 		uint256 ire;
349 	}
350 
351 	uint256 public cupi;
352 	mapping (bytes32 => Cup) public cups;
353 
354 	function lad(bytes32 cup) public view returns (address);
355 	function per() public view returns (uint ray);
356 	function tab(bytes32 cup) public returns (uint);
357 	function ink(bytes32 cup) public returns (uint);
358 	function rap(bytes32 cup) public returns (uint);
359 	function chi() public returns (uint);
360 
361 	function open() public returns (bytes32 cup);
362 	function give(bytes32 cup, address guy) public;
363 	function lock(bytes32 cup, uint wad) public;
364 	function free(bytes32 cup, uint wad) public;
365 	function draw(bytes32 cup, uint wad) public;
366 	function join(uint wad) public;
367 	function exit(uint wad) public;
368 	function wipe(bytes32 cup, uint wad) public;
369 }
370 
371 contract DSProxy {
372 	// Technically from DSAuth
373 	address public owner;
374 
375 	function execute(address _target, bytes _data) public payable returns (bytes32 response);
376 }
377 
378 contract ProxyRegistry {
379 	mapping(address => DSProxy) public proxies;
380 	function build(address owner) public returns (DSProxy proxy);
381 }
382 
383 contract LiquidLong is Ownable, Claimable, Pausable {
384 	using SafeMath for uint256;
385 	using SafeMathFixedPoint for uint256;
386 
387 	uint256 public providerFeePerEth;
388 
389 	MatchingMarket public matchingMarket;
390 	Maker public maker;
391 	Dai public dai;
392 	Weth public weth;
393 	Peth public peth;
394 	Mkr public mkr;
395 
396 	ProxyRegistry public proxyRegistry;
397 
398 	struct CDP {
399 		uint256 id;
400 		uint256 debtInAttodai;
401 		uint256 lockedAttoeth;
402 		address owner;
403 		bool userOwned;
404 	}
405 
406 	event NewCup(address user, uint256 cup);
407 	event CloseCup(address user, uint256 cup);
408 
409 	constructor(MatchingMarket _matchingMarket, Maker _maker, ProxyRegistry _proxyRegistry) public payable {
410 		providerFeePerEth = 0.01 ether;
411 
412 		matchingMarket = _matchingMarket;
413 		maker = _maker;
414 		dai = maker.sai();
415 		weth = maker.gem();
416 		peth = maker.skr();
417 		mkr = maker.gov();
418 
419 		// MatchingMarket buy/sell
420 		dai.approve(address(_matchingMarket), uint256(-1));
421 		weth.approve(address(_matchingMarket), uint256(-1));
422 		// Wipe
423 		dai.approve(address(_maker), uint256(-1));
424 		mkr.approve(address(_maker), uint256(-1));
425 		// Join
426 		weth.approve(address(_maker), uint256(-1));
427 		// Lock
428 		peth.approve(address(_maker), uint256(-1));
429 
430 		proxyRegistry = _proxyRegistry;
431 
432 		if (msg.value > 0) {
433 			weth.deposit.value(msg.value)();
434 		}
435 	}
436 
437 	// Receive ETH from WETH withdraw
438 	function () external payable {
439 	}
440 
441 	function wethDeposit() public payable {
442 		weth.deposit.value(msg.value)();
443 	}
444 
445 	function wethWithdraw(uint256 _amount) public onlyOwner {
446 		weth.withdraw(_amount);
447 		owner.transfer(_amount);
448 	}
449 
450 	function attowethBalance() public view returns (uint256 _attoweth) {
451 		return weth.balanceOf(address(this));
452 	}
453 
454 	function ethWithdraw() public onlyOwner {
455 		uint256 _amount = address(this).balance;
456 		owner.transfer(_amount);
457 	}
458 
459 	function transferTokens(ERC20 _token) public onlyOwner {
460 		_token.transfer(owner, _token.balanceOf(this));
461 	}
462 
463 	function ethPriceInUsd() public view returns (uint256 _attousd) {
464 		return uint256(maker.pip().read());
465 	}
466 
467 	function estimateDaiSaleProceeds(uint256 _attodaiToSell) public view returns (uint256 _daiPaid, uint256 _wethBought) {
468 		return getPayPriceAndAmount(dai, weth, _attodaiToSell);
469 	}
470 
471 	// buy/pay are from the perspective of the taker/caller (MatchingMarket contracts use buy/pay terminology from perspective of the maker)
472 	function getPayPriceAndAmount(ERC20 _payGem, ERC20 _buyGem, uint256 _payDesiredAmount) public view returns (uint256 _paidAmount, uint256 _boughtAmount) {
473 		uint256 _offerId = matchingMarket.getBestOffer(_buyGem, _payGem);
474 		while (_offerId != 0) {
475 			uint256 _payRemaining = _payDesiredAmount.sub(_paidAmount);
476 			(uint256 _buyAvailableInOffer,  , uint256 _payAvailableInOffer,) = matchingMarket.getOffer(_offerId);
477 			if (_payRemaining <= _payAvailableInOffer) {
478 				uint256 _buyRemaining = _payRemaining.mul(_buyAvailableInOffer).div(_payAvailableInOffer);
479 				_paidAmount = _paidAmount.add(_payRemaining);
480 				_boughtAmount = _boughtAmount.add(_buyRemaining);
481 				break;
482 			}
483 			_paidAmount = _paidAmount.add(_payAvailableInOffer);
484 			_boughtAmount = _boughtAmount.add(_buyAvailableInOffer);
485 			_offerId = matchingMarket.getWorseOffer(_offerId);
486 		}
487 		return (_paidAmount, _boughtAmount);
488 	}
489 
490 	function estimateDaiPurchaseCosts(uint256 _attodaiToBuy) public view returns (uint256 _wethPaid, uint256 _daiBought) {
491 		return getBuyPriceAndAmount(weth, dai, _attodaiToBuy);
492 	}
493 
494 	// buy/pay are from the perspective of the taker/caller (MatchingMarket contracts use buy/pay terminology from perspective of the maker)
495 	function getBuyPriceAndAmount(ERC20 _payGem, ERC20 _buyGem, uint256 _buyDesiredAmount) public view returns (uint256 _paidAmount, uint256 _boughtAmount) {
496 		uint256 _offerId = matchingMarket.getBestOffer(_buyGem, _payGem);
497 		while (_offerId != 0) {
498 			uint256 _buyRemaining = _buyDesiredAmount.sub(_boughtAmount);
499 			(uint256 _buyAvailableInOffer, , uint256 _payAvailableInOffer,) = matchingMarket.getOffer(_offerId);
500 			if (_buyRemaining <= _buyAvailableInOffer) {
501 				// TODO: verify this logic is correct
502 				uint256 _payRemaining = _buyRemaining.mul(_payAvailableInOffer).div(_buyAvailableInOffer);
503 				_paidAmount = _paidAmount.add(_payRemaining);
504 				_boughtAmount = _boughtAmount.add(_buyRemaining);
505 				break;
506 			}
507 			_paidAmount = _paidAmount.add(_payAvailableInOffer);
508 			_boughtAmount = _boughtAmount.add(_buyAvailableInOffer);
509 			_offerId = matchingMarket.getWorseOffer(_offerId);
510 		}
511 		return (_paidAmount, _boughtAmount);
512 	}
513 
514 	modifier wethBalanceIncreased() {
515 		uint256 _startingAttowethBalance = weth.balanceOf(this);
516 		_;
517 		require(weth.balanceOf(this) > _startingAttowethBalance);
518 	}
519 
520 	// TODO: change affiliate fee to be 50% of service fee, no parameter needed
521 	function openCdp(uint256 _leverage, uint256 _leverageSizeInAttoeth, uint256 _allowedFeeInAttoeth, address _affiliateAddress) public payable wethBalanceIncreased returns (bytes32 _cdpId) {
522 		require(_leverage >= 100 && _leverage <= 300);
523 		uint256 _lockedInCdpInAttoeth = _leverageSizeInAttoeth.mul(_leverage).div(100);
524 		uint256 _loanInAttoeth = _lockedInCdpInAttoeth.sub(_leverageSizeInAttoeth);
525 		uint256 _feeInAttoeth = _loanInAttoeth.mul18(providerFeePerEth);
526 		require(_feeInAttoeth <= _allowedFeeInAttoeth);
527 		uint256 _drawInAttodai = _loanInAttoeth.mul18(uint256(maker.pip().read()));
528 		uint256 _attopethLockedInCdp = _lockedInCdpInAttoeth.div27(maker.per());
529 
530 		// Convert all incoming eth to weth (we will pay back later if too much)
531 		weth.deposit.value(msg.value)();
532 		// Open CDP
533 		_cdpId = maker.open();
534 		// Convert WETH into PETH
535 		maker.join(_attopethLockedInCdp);
536 		// Store PETH in CDP
537 		maker.lock(_cdpId, _attopethLockedInCdp);
538 
539 		// This could be 0 if the user has requested a leverage of exactly 100 (1x).
540 		// There's no reason to draw 0 dai, try to sell it, or to pay out affiliate
541 		// Drawn dai is used to satisfy the _loanInAttoeth. 0 DAI means 0 loan.
542 		if (_drawInAttodai > 0) {
543 			// Withdraw DAI from CDP
544 			maker.draw(_cdpId, _drawInAttodai);
545 			// Sell DAI for WETH
546 			sellDai(_drawInAttodai, _lockedInCdpInAttoeth, _feeInAttoeth);
547 			// Pay provider fee
548 			if (_affiliateAddress != address(0)) {
549 				// Fee charged is constant. If affiliate provided, split fee with affiliate
550 				// Don't bother sending eth to owner, the owner has all weth anyway
551 				weth.transfer(_affiliateAddress, _feeInAttoeth.div(2));
552 			}
553 		}
554 		emit NewCup(msg.sender, uint256(_cdpId));
555 
556 		giveCdpToProxy(msg.sender, _cdpId);
557 	}
558 
559 	function giveCdpToProxy(address _ownerOfProxy, bytes32 _cdpId) private {
560 		DSProxy _proxy = proxyRegistry.proxies(_ownerOfProxy);
561 		if (_proxy == DSProxy(0) || _proxy.owner() != _ownerOfProxy) {
562 			_proxy = proxyRegistry.build(_ownerOfProxy);
563 		}
564 		// Send the CDP to the owner's proxy instead of directly to owner
565 		maker.give(_cdpId, _proxy);
566 	}
567 
568 	// extracted function to mitigate stack depth issues
569 	function sellDai(uint256 _drawInAttodai, uint256 _lockedInCdpInAttoeth, uint256 _feeInAttoeth) private {
570 		uint256 _wethBoughtInAttoweth = matchingMarket.sellAllAmount(dai, _drawInAttodai, weth, 0);
571 		// SafeMath failure below catches not enough eth provided
572 		uint256 _refundDue = msg.value.add(_wethBoughtInAttoweth).sub(_lockedInCdpInAttoeth).sub(_feeInAttoeth);
573 		if (_refundDue > 0) {
574 			weth.withdraw(_refundDue);
575 			require(msg.sender.call.value(_refundDue)());
576 		}
577 	}
578 
579 	// closeCdp is intended to be a delegate call that executes as a user's DSProxy
580 	function closeCdp(LiquidLong _liquidLong, uint256 _cdpId, uint256 _minimumValueInAttoeth, address _affiliateAddress) external returns (uint256 _payoutOwnerInAttoeth) {
581 		address _owner = DSProxy(this).owner();
582 		uint256 _startingAttoethBalance = _owner.balance;
583 
584 		// This is delegated, we cannot use storage
585 		Maker _maker = _liquidLong.maker();
586 
587 		// if the CDP is already empty, early return (this allows this method to be called off-chain to check estimated payout and not fail for empty CDPs)
588 		uint256 _lockedPethInAttopeth = _maker.ink(bytes32(_cdpId));
589 		if (_lockedPethInAttopeth == 0) return 0;
590 
591 		_maker.give(bytes32(_cdpId), _liquidLong);
592 		_payoutOwnerInAttoeth = _liquidLong.closeGiftedCdp(bytes32(_cdpId), _minimumValueInAttoeth, _owner, _affiliateAddress);
593 
594 		require(_maker.lad(bytes32(_cdpId)) == address(this));
595 		require(_owner.balance > _startingAttoethBalance);
596 		return _payoutOwnerInAttoeth;
597 	}
598 
599 	// Close cdp that was just received as part of the same transaction
600 	function closeGiftedCdp(bytes32 _cdpId, uint256 _minimumValueInAttoeth, address _recipient, address _affiliateAddress) external wethBalanceIncreased returns (uint256 _payoutOwnerInAttoeth) {
601 		require(_recipient != address(0));
602 		uint256 _lockedPethInAttopeth = maker.ink(_cdpId);
603 		uint256 _debtInAttodai = maker.tab(_cdpId);
604 
605 		// Calculate what we need to claim out of the CDP in Weth
606 		uint256 _lockedWethInAttoweth = _lockedPethInAttopeth.div27(maker.per());
607 
608 		// Buy DAI and wipe the entire CDP
609 		// Pass in _lockedWethInAttoweth as "max fill amount". If buying DAI costs more in eth than the entire CDP has locked up, revert (we will fail later anyway)
610 		uint256 _wethSoldInAttoweth = matchingMarket.buyAllAmount(dai, _debtInAttodai, weth, _lockedWethInAttoweth);
611 		uint256 _providerFeeInAttoeth = _wethSoldInAttoweth.mul18(providerFeePerEth);
612 
613 		// Calculating governance fee is difficult and gas-intense. Just look up how wiping impacts balance
614 		// Then convert that difference into weth, the only asset we charge in. This will require loading up
615 		// mkr periodically
616 		uint256 _mkrBalanceBeforeInAttomkr = mkr.balanceOf(this);
617 		maker.wipe(_cdpId, _debtInAttodai);
618 		uint256 _mkrBurnedInAttomkr = _mkrBalanceBeforeInAttomkr.sub(mkr.balanceOf(this));
619 		uint256 _ethValueOfBurnedMkrInAttoeth = _mkrBurnedInAttomkr.mul(uint256(maker.pep().read())) // converts Mkr to DAI
620 			.div(uint256(maker.pip().read())); // converts DAI to ETH
621 
622 		// Relying on safe-math to revert a situation where LiquidLong would lose weth
623 		_payoutOwnerInAttoeth = _lockedWethInAttoweth.sub(_wethSoldInAttoweth).sub(_providerFeeInAttoeth).sub(_ethValueOfBurnedMkrInAttoeth);
624 
625 		// Ensure remaining peth in CDP is greater than the value they requested as minimum value
626 		require(_payoutOwnerInAttoeth >= _minimumValueInAttoeth);
627 
628 		// Pull that value from the CDP, convert it back to WETH for next time
629 		// We rely on "free" reverting the transaction if there is not enough peth to profitably close CDP
630 		maker.free(_cdpId, _lockedPethInAttopeth);
631 		maker.exit(_lockedPethInAttopeth);
632 
633 		// DSProxy (or other proxy?) will have issued this request, send it back to the proxy contract. CDP is empty and valueless
634 		maker.give(_cdpId, msg.sender);
635 
636 		weth.withdraw(_payoutOwnerInAttoeth);
637 		if (_affiliateAddress != address(0)) {
638 			// Fee charged is constant. If affiliate provided, split fee with affiliate
639 			// Don't bother sending eth to owner, the owner has all weth anyway
640 			weth.transfer(_affiliateAddress, _providerFeeInAttoeth.div(2));
641 		}
642 		require(_recipient.call.value(_payoutOwnerInAttoeth)());
643 		emit CloseCup(msg.sender, uint256(_cdpId));
644 	}
645 
646 	// Retrieve CDPs by EFFECTIVE owner, which address owns the DSProxy which owns the CDPs
647 	function getCdps(address _owner, uint32 _offset, uint32 _pageSize) public returns (CDP[] _cdps) {
648 		// resolve a owner to a proxy, then query by that proxy
649 		DSProxy _cdpProxy = proxyRegistry.proxies(_owner);
650 		require(_cdpProxy != address(0));
651 		return getCdpsByAddresses(_owner, _cdpProxy, _offset, _pageSize);
652 	}
653 
654 	// Retrieve CDPs by TRUE owner, as registered in Maker
655 	function getCdpsByAddresses(address _owner, address _proxy, uint32 _offset, uint32 _pageSize) public returns (CDP[] _cdps) {
656 		_cdps = new CDP[](getCdpCountByOwnerAndProxy(_owner, _proxy, _offset, _pageSize));
657 		uint256 _cdpCount = cdpCount();
658 		uint32 _matchCount = 0;
659 		for (uint32 _i = _offset; _i <= _cdpCount && _i < _offset + _pageSize; ++_i) {
660 			address _cdpOwner = maker.lad(bytes32(_i));
661 			if (_cdpOwner != _owner && _cdpOwner != _proxy) continue;
662 			_cdps[_matchCount] = getCdpDetailsById(_i, _owner);
663 			++_matchCount;
664 		}
665 		return _cdps;
666 	}
667 
668 	function cdpCount() public view returns (uint32 _cdpCount) {
669 		uint256 count = maker.cupi();
670 		require(count < 2**32);
671 		return uint32(count);
672 	}
673 
674 	function getCdpCountByOwnerAndProxy(address _owner, address _proxy, uint32 _offset, uint32 _pageSize) private view returns (uint32 _count) {
675 		uint256 _cdpCount = cdpCount();
676 		_count = 0;
677 		for (uint32 _i = _offset; _i <= _cdpCount && _i < _offset + _pageSize; ++_i) {
678 			address _cdpOwner = maker.lad(bytes32(_i));
679 			if (_cdpOwner != _owner && _cdpOwner != _proxy) continue;
680 			++_count;
681 		}
682 		return _count;
683 	}
684 
685 	function getCdpDetailsById(uint32 _cdpId, address _owner) private returns (CDP _cdp) {
686 		(address _cdpOwner, uint256 _collateral,,) = maker.cups(bytes32(_cdpId));
687 		// this one line makes this function not `view`. tab calls chi, which calls drip which mutates state and we can't directly access _chi to bypass this
688 		uint256 _debtInAttodai = maker.tab(bytes32(_cdpId));
689 		// Adjust locked attoeth to factor in peth/weth ratio
690 		uint256 _lockedAttoeth = (_collateral + 1).mul27(maker.gap().mul18(maker.per()));
691 		_cdp = CDP({
692 			id: _cdpId,
693 			debtInAttodai: _debtInAttodai,
694 			lockedAttoeth: _lockedAttoeth,
695 			owner: _cdpOwner,
696 			userOwned: _cdpOwner == _owner
697 		});
698 		return _cdp;
699 	}
700 }