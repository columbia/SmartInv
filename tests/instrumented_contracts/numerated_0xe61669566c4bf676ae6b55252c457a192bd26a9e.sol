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
315 contract Oasis {
316 	function getBuyAmount(ERC20 tokenToBuy, ERC20 tokenToPay, uint256 amountToPay) external view returns(uint256 amountBought);
317 	function getPayAmount(ERC20 tokenToPay, ERC20 tokenToBuy, uint amountToBuy) public constant returns (uint amountPaid);
318 	function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint offerId);
319 	function getWorseOffer(uint id) public constant returns(uint offerId);
320 	function getOffer(uint id) public constant returns (uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem);
321 	function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount) public returns (uint fill_amt);
322 }
323 
324 contract Medianizer {
325 	function read() external view returns(bytes32);
326 }
327 
328 contract Maker {
329 	function sai() external view returns(Dai);
330 	function gem() external view returns(Weth);
331 	function gov() external view returns(Mkr);
332 	function skr() external view returns(Peth);
333 	function pip() external view returns(Medianizer);
334 
335 	// Join-Exit Spread
336 	 uint256 public gap;
337 
338 	struct Cup {
339 		// CDP owner
340 		address lad;
341 		// Locked collateral (in SKR)
342 		uint256 ink;
343 		// Outstanding normalised debt (tax only)
344 		uint256 art;
345 		// Outstanding normalised debt
346 		uint256 ire;
347 	}
348 
349 	uint256 public cupi;
350 	mapping (bytes32 => Cup) public cups;
351 
352 	function lad(bytes32 cup) public view returns (address);
353 	function per() public view returns (uint ray);
354 	function tab(bytes32 cup) public returns (uint);
355 	function ink(bytes32 cup) public returns (uint);
356 	function rap(bytes32 cup) public returns (uint);
357 	function chi() public returns (uint);
358 
359 	function open() public returns (bytes32 cup);
360 	function give(bytes32 cup, address guy) public;
361 	function lock(bytes32 cup, uint wad) public;
362 	function draw(bytes32 cup, uint wad) public;
363 	function join(uint wad) public;
364 	function wipe(bytes32 cup, uint wad) public;
365 }
366 
367 contract DSProxy {
368 	// Technically from DSAuth
369 	address public owner;
370 
371 	function execute(address _target, bytes _data) public payable returns (bytes32 response);
372 }
373 
374 contract ProxyRegistry {
375 	mapping(address => DSProxy) public proxies;
376 	function build(address owner) public returns (DSProxy proxy);
377 }
378 
379 contract LiquidLong is Ownable, Claimable, Pausable {
380 	using SafeMath for uint256;
381 	using SafeMathFixedPoint for uint256;
382 
383 	uint256 public providerFeePerEth;
384 
385 	Oasis public oasis;
386 	Maker public maker;
387 	Dai public dai;
388 	Weth public weth;
389 	Peth public peth;
390 	Mkr public mkr;
391 
392 	ProxyRegistry public proxyRegistry;
393 
394 	event NewCup(address user, bytes32 cup);
395 
396 	constructor(Oasis _oasis, Maker _maker, ProxyRegistry _proxyRegistry) public payable {
397 		providerFeePerEth = 0.01 ether;
398 
399 		oasis = _oasis;
400 		maker = _maker;
401 		dai = maker.sai();
402 		weth = maker.gem();
403 		peth = maker.skr();
404 		mkr = maker.gov();
405 
406 		// Oasis buy/sell
407 		dai.approve(address(_oasis), uint256(-1));
408 		// Wipe
409 		dai.approve(address(_maker), uint256(-1));
410 		mkr.approve(address(_maker), uint256(-1));
411 		// Join
412 		weth.approve(address(_maker), uint256(-1));
413 		// Lock
414 		peth.approve(address(_maker), uint256(-1));
415 
416 		proxyRegistry = _proxyRegistry;
417 
418 		if (msg.value > 0) {
419 			weth.deposit.value(msg.value)();
420 		}
421 	}
422 
423 	// Receive ETH from WETH withdraw
424 	function () external payable {
425 	}
426 
427 	function wethDeposit() public payable {
428 		weth.deposit.value(msg.value)();
429 	}
430 
431 	function wethWithdraw(uint256 _amount) public onlyOwner {
432 		weth.withdraw(_amount);
433 		owner.transfer(_amount);
434 	}
435 
436 	function attowethBalance() public view returns (uint256 _attoweth) {
437 		return weth.balanceOf(address(this));
438 	}
439 
440 	function ethWithdraw() public onlyOwner {
441 		uint256 _amount = address(this).balance;
442 		owner.transfer(_amount);
443 	}
444 
445 	function transferTokens(ERC20 _token) public onlyOwner {
446 		_token.transfer(owner, _token.balanceOf(this));
447 	}
448 
449 	function ethPriceInUsd() public view returns (uint256 _attousd) {
450 		return uint256(maker.pip().read());
451 	}
452 
453 	function estimateDaiSaleProceeds(uint256 _attodaiToSell) public view returns (uint256 _daiPaid, uint256 _wethBought) {
454 		return getPayPriceAndAmount(dai, weth, _attodaiToSell);
455 	}
456 
457 	// buy/pay are from the perspective of the taker/caller (Oasis contracts use buy/pay terminology from perspective of the maker)
458 	function getPayPriceAndAmount(ERC20 _payGem, ERC20 _buyGem, uint256 _payDesiredAmount) public view returns (uint256 _paidAmount, uint256 _boughtAmount) {
459 		uint256 _offerId = oasis.getBestOffer(_buyGem, _payGem);
460 		while (_offerId != 0) {
461 			uint256 _payRemaining = _payDesiredAmount.sub(_paidAmount);
462 			(uint256 _buyAvailableInOffer,  , uint256 _payAvailableInOffer,) = oasis.getOffer(_offerId);
463 			if (_payRemaining <= _payAvailableInOffer) {
464 				uint256 _buyRemaining = _payRemaining.mul(_buyAvailableInOffer).div(_payAvailableInOffer);
465 				_paidAmount = _paidAmount.add(_payRemaining);
466 				_boughtAmount = _boughtAmount.add(_buyRemaining);
467 				break;
468 			}
469 			_paidAmount = _paidAmount.add(_payAvailableInOffer);
470 			_boughtAmount = _boughtAmount.add(_buyAvailableInOffer);
471 			_offerId = oasis.getWorseOffer(_offerId);
472 		}
473 		return (_paidAmount, _boughtAmount);
474 	}
475 
476 	modifier wethBalanceIncreased() {
477 		uint256 _startingAttowethBalance = weth.balanceOf(this);
478 		_;
479 		require(weth.balanceOf(this) > _startingAttowethBalance);
480 	}
481 
482 	// TODO: change affiliate fee to be 50% of service fee, no parameter needed
483 	function openCdp(uint256 _leverage, uint256 _leverageSizeInAttoeth, uint256 _allowedFeeInAttoeth, address _affiliateAddress) public payable wethBalanceIncreased returns (bytes32 _cdpId) {
484 		require(_leverage >= 100 && _leverage <= 300);
485 		uint256 _lockedInCdpInAttoeth = _leverageSizeInAttoeth.mul(_leverage).div(100);
486 		uint256 _loanInAttoeth = _lockedInCdpInAttoeth.sub(_leverageSizeInAttoeth);
487 		uint256 _feeInAttoeth = _loanInAttoeth.mul18(providerFeePerEth);
488 		require(_feeInAttoeth <= _allowedFeeInAttoeth);
489 		uint256 _drawInAttodai = _loanInAttoeth.mul18(uint256(maker.pip().read()));
490 		uint256 _attopethLockedInCdp = _lockedInCdpInAttoeth.div27(maker.per());
491 
492 		// Convert all incoming eth to weth (we will pay back later if too much)
493 		weth.deposit.value(msg.value)();
494 		// Open CDP
495 		_cdpId = maker.open();
496 		// Convert WETH into PETH
497 		maker.join(_attopethLockedInCdp);
498 		// Store PETH in CDP
499 		maker.lock(_cdpId, _attopethLockedInCdp);
500 		// Withdraw DAI from CDP
501 		maker.draw(_cdpId, _drawInAttodai);
502 		// Sell DAI for WETH
503 		sellDai(_drawInAttodai, _lockedInCdpInAttoeth, _feeInAttoeth);
504 		// Pay provider fee
505 		if (_affiliateAddress != address(0)) {
506 			// Fee charged is constant. If affiliate provided, split fee with affiliate
507 			// Don't bother sending eth to owner, the owner has all non-async-sent eth anyway
508 			weth.transfer(_affiliateAddress, _feeInAttoeth.div(2));
509 		}
510 
511 		emit NewCup(msg.sender, _cdpId);
512 
513 		giveCdpToProxy(msg.sender, _cdpId);
514 	}
515 
516 	function giveCdpToProxy(address _ownerOfProxy, bytes32 _cdpId) private {
517 		DSProxy _proxy = proxyRegistry.proxies(_ownerOfProxy);
518 		if (_proxy == DSProxy(0) || _proxy.owner() != _ownerOfProxy) {
519 			_proxy = proxyRegistry.build(_ownerOfProxy);
520 		}
521 		// Send the CDP to the owner's proxy instead of directly to owner
522 		maker.give(_cdpId, _proxy);
523 	}
524 
525 	// extracted function to mitigate stack depth issues
526 	function sellDai(uint256 _drawInAttodai, uint256 _lockedInCdpInAttoeth, uint256 _feeInAttoeth) private {
527 		uint256 _wethBoughtInAttoweth = oasis.sellAllAmount(dai, _drawInAttodai, weth, 0);
528 		// SafeMath failure below catches not enough eth provided
529 		uint256 _refundDue = msg.value.add(_wethBoughtInAttoweth).sub(_lockedInCdpInAttoeth).sub(_feeInAttoeth);
530 		if (_refundDue > 0) {
531 			weth.withdraw(_refundDue);
532 			require(msg.sender.call.value(_refundDue)());
533 		}
534 	}
535 }