1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 pragma experimental "v0.5.0";
4 
5 /**
6 * @title SafeMath
7 * @dev Math operations with safety checks that throw on error
8 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/56515380452baad9fcd32c5d4502002af0183ce9/contracts/math/SafeMath.sol
9 */
10 library SafeMath {
11 
12 	/**
13 	* @dev Multiplies two numbers, throws on overflow.
14 	*/
15 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17 		// benefit is lost if 'b' is also tested.
18 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19 		if (a == 0) {
20 			return 0;
21 		}
22 		c = a * b;
23 		assert(c / a == b);
24 		return c;
25 	}
26 
27 	/**
28 	* @dev Integer division of two numbers, truncating the quotient.
29 	*/
30 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
31 		// assert(b > 0); // Solidity automatically throws when dividing by 0
32 		// uint256 c = a / b;
33 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 		return a / b;
35 	}
36 
37 	/**
38 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39 	*/
40 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41 		assert(b <= a);
42 		return a - b;
43 	}
44 
45 	/**
46 	* @dev Adds two numbers, throws on overflow.
47 	*/
48 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49 		c = a + b;
50 		assert(c >= a);
51 		return c;
52 	}
53 
54 }
55 
56 /**
57 * @title Convenience and rounding functions when dealing with numbers already factored by 10**18 or 10**27
58 * @dev Math operations with safety checks that throw on error
59 * https://github.com/dapphub/ds-math/blob/87bef2f67b043819b7195ce6df3058bd3c321107/src/math.sol
60 */
61 library SafeMathFixedPoint {
62 	using SafeMath for uint256;
63 
64 	function mul27(uint256 x, uint256 y) internal pure returns (uint256 z) {
65 		z = x.mul(y).add(5 * 10**26).div(10**27);
66 	}
67 	function mul18(uint256 x, uint256 y) internal pure returns (uint256 z) {
68 		z = x.mul(y).add(5 * 10**17).div(10**18);
69 	}
70 
71 	function div18(uint256 x, uint256 y) internal pure returns (uint256 z) {
72 		z = x.mul(10**18).add(y.div(2)).div(y);
73 	}
74 	function div27(uint256 x, uint256 y) internal pure returns (uint256 z) {
75 		z = x.mul(10**27).add(y.div(2)).div(y);
76 	}
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
84  */
85 contract ERC20Basic {
86 	function totalSupply() public view returns (uint256);
87 	function balanceOf(address who) public view returns (uint256);
88 	function transfer(address to, uint256 value) public returns (bool);
89 	event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
96  */
97 contract ERC20 is ERC20Basic {
98 	function allowance(address owner, address spender) public view returns (uint256);
99 	function transferFrom(address from, address to, uint256 value) public returns (bool);
100 	function approve(address spender, uint256 value) public returns (bool);
101 	event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @title Ownable
106  * @dev The Ownable contract has an owner address, and provides basic authorization control
107  * functions, this simplifies the implementation of "user permissions".
108  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
109  */
110 contract Ownable {
111 	address public owner;
112 
113 	event OwnershipRenounced(address indexed previousOwner);
114 	event OwnershipTransferred(
115 		address indexed previousOwner,
116 		address indexed newOwner
117 	);
118 
119 	/**
120 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
121 	 * account.
122 	 */
123 	constructor() public {
124 		owner = msg.sender;
125 	}
126 
127 	/**
128 	 * @dev Throws if called by any account other than the owner.
129 	 */
130 	modifier onlyOwner() {
131 		require(msg.sender == owner);
132 		_;
133 	}
134 
135 	/**
136 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
137 	 * @param newOwner The address to transfer ownership to.
138 	 */
139 	function transferOwnership(address newOwner) public onlyOwner {
140 		require(newOwner != address(0));
141 		emit OwnershipTransferred(owner, newOwner);
142 		owner = newOwner;
143 	}
144 
145 	/**
146 	 * @dev Allows the current owner to relinquish control of the contract.
147 	 */
148 	function renounceOwnership() public onlyOwner {
149 		emit OwnershipRenounced(owner);
150 		owner = address(0);
151 	}
152 }
153 
154 /**
155  * @title Claimable
156  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
157  * This allows the new owner to accept the transfer.
158  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Claimable.sol
159  */
160 contract Claimable is Ownable {
161 	address public pendingOwner;
162 
163 	/**
164 	 * @dev Modifier throws if called by any account other than the pendingOwner.
165 	 */
166 	modifier onlyPendingOwner() {
167 		require(msg.sender == pendingOwner);
168 		_;
169 	}
170 
171 	/**
172 	 * @dev Allows the current owner to set the pendingOwner address.
173 	 * @param newOwner The address to transfer ownership to.
174 	 */
175 	function transferOwnership(address newOwner) onlyOwner public {
176 		pendingOwner = newOwner;
177 	}
178 
179 	/**
180 	 * @dev Allows the pendingOwner address to finalize the transfer.
181 	 */
182 	function claimOwnership() onlyPendingOwner public {
183 		emit OwnershipTransferred(owner, pendingOwner);
184 		owner = pendingOwner;
185 		pendingOwner = address(0);
186 	}
187 }
188 
189 /**
190  * @title Pausable
191  * @dev Base contract which allows children to implement an emergency stop mechanism.
192  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
193  */
194 contract Pausable is Ownable {
195 	event Pause();
196 	event Unpause();
197 
198 	bool public paused = false;
199 
200 
201 	/**
202 	 * @dev Modifier to make a function callable only when the contract is not paused.
203 	 */
204 	modifier whenNotPaused() {
205 		require(!paused);
206 		_;
207 	}
208 
209 	/**
210 	 * @dev Modifier to make a function callable only when the contract is paused.
211 	 */
212 	modifier whenPaused() {
213 		require(paused);
214 		_;
215 	}
216 
217 	/**
218 	 * @dev called by the owner to pause, triggers stopped state
219 	 */
220 	function pause() onlyOwner whenNotPaused public {
221 		paused = true;
222 		emit Pause();
223 	}
224 
225 	/**
226 	 * @dev called by the owner to unpause, returns to normal state
227 	 */
228 	function unpause() onlyOwner whenPaused public {
229 		paused = false;
230 		emit Unpause();
231 	}
232 }
233 
234 /**
235  * @title PullPayment
236  * @dev Base contract supporting async send for pull payments. Inherit from this
237  * contract and use asyncSend instead of send or transfer.
238  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/payment/PullPayment.sol
239  */
240 contract PullPayment {
241 	using SafeMath for uint256;
242 
243 	mapping(address => uint256) public payments;
244 	uint256 public totalPayments;
245 
246 	/**
247 	* @dev Withdraw accumulated balance, called by payee.
248 	*/
249 	function withdrawPayments() public {
250 		address payee = msg.sender;
251 		uint256 payment = payments[payee];
252 
253 		// the following line is commented out from the original OpenZeppelin contract because it doesn't buy us much in our situation and it complicates testing as our test suite can no longer blindly withdraw payments
254 		// require(payment != 0);
255 		require(address(this).balance >= payment);
256 
257 		totalPayments = totalPayments.sub(payment);
258 		payments[payee] = 0;
259 
260 		payee.transfer(payment);
261 	}
262 
263 	/**
264 	* @dev Called by the payer to store the sent amount as credit to be pulled.
265 	* @param dest The destination address of the funds.
266 	* @param amount The amount to transfer.
267 	*/
268 	function asyncSend(address dest, uint256 amount) internal {
269 		payments[dest] = payments[dest].add(amount);
270 		totalPayments = totalPayments.add(amount);
271 	}
272 }
273 
274 contract Dai is ERC20 {
275 
276 }
277 
278 contract Weth is ERC20 {
279 	function deposit() public payable;
280 	function withdraw(uint wad) public;
281 }
282 
283 contract Mkr is ERC20 {
284 
285 }
286 
287 contract Peth is ERC20 {
288 
289 }
290 
291 contract Oasis {
292 	function getBuyAmount(ERC20 tokenToBuy, ERC20 tokenToPay, uint256 amountToPay) external view returns(uint256 amountBought);
293 	function getPayAmount(ERC20 tokenToPay, ERC20 tokenToBuy, uint amountToBuy) public constant returns (uint amountPaid);
294 	function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint offerId);
295 	function getWorseOffer(uint id) public constant returns(uint offerId);
296 	function getOffer(uint id) public constant returns (uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem);
297 	function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount) public returns (uint fill_amt);
298 }
299 
300 contract Medianizer {
301 	function read() external view returns(bytes32);
302 }
303 
304 contract Maker {
305 	function sai() external view returns(Dai);
306 	function gem() external view returns(Weth);
307 	function gov() external view returns(Mkr);
308 	function skr() external view returns(Peth);
309 	function pip() external view returns(Medianizer);
310 
311 	// Join-Exit Spread
312 	 uint256 public gap;
313 
314 	struct Cup {
315 		// CDP owner
316 		address lad;
317 		// Locked collateral (in SKR)
318 		uint256 ink;
319 		// Outstanding normalised debt (tax only)
320 		uint256 art;
321 		// Outstanding normalised debt
322 		uint256 ire;
323 	}
324 
325 	uint256 public cupi;
326 	mapping (bytes32 => Cup) public cups;
327 
328 	function lad(bytes32 cup) public view returns (address);
329 	function per() public view returns (uint ray);
330 	function tab(bytes32 cup) public returns (uint);
331 	function ink(bytes32 cup) public returns (uint);
332 	function rap(bytes32 cup) public returns (uint);
333 	function chi() public returns (uint);
334 
335 	function open() public returns (bytes32 cup);
336 	function give(bytes32 cup, address guy) public;
337 	function lock(bytes32 cup, uint wad) public;
338 	function draw(bytes32 cup, uint wad) public;
339 	function join(uint wad) public;
340 	function wipe(bytes32 cup, uint wad) public;
341 }
342 
343 contract DSProxy {
344 	// Technically from DSAuth
345 	address public owner;
346 
347 	function execute(address _target, bytes _data) public payable returns (bytes32 response);
348 }
349 
350 contract ProxyRegistry {
351 	mapping(address => DSProxy) public proxies;
352 	function build(address owner) public returns (DSProxy proxy);
353 }
354 
355 contract LiquidLong is Ownable, Claimable, Pausable, PullPayment {
356 	using SafeMath for uint256;
357 	using SafeMathFixedPoint for uint256;
358 
359 	uint256 public providerFeePerEth;
360 
361 	Oasis public oasis;
362 	Maker public maker;
363 	Dai public dai;
364 	Weth public weth;
365 	Peth public peth;
366 	Mkr public mkr;
367 
368 	ProxyRegistry public proxyRegistry;
369 
370 	event NewCup(address user, bytes32 cup);
371 
372 	constructor(Oasis _oasis, Maker _maker, ProxyRegistry _proxyRegistry) public payable {
373 		providerFeePerEth = 0.01 ether;
374 
375 		oasis = _oasis;
376 		maker = _maker;
377 		dai = maker.sai();
378 		weth = maker.gem();
379 		peth = maker.skr();
380 		mkr = maker.gov();
381 
382 		// Oasis buy/sell
383 		dai.approve(address(_oasis), uint256(-1));
384 		// Wipe
385 		dai.approve(address(_maker), uint256(-1));
386 		mkr.approve(address(_maker), uint256(-1));
387 		// Join
388 		weth.approve(address(_maker), uint256(-1));
389 		// Lock
390 		peth.approve(address(_maker), uint256(-1));
391 
392 		proxyRegistry = _proxyRegistry;
393 
394 		if (msg.value > 0) {
395 			weth.deposit.value(msg.value)();
396 		}
397 	}
398 
399 	// Receive ETH from WETH withdraw
400 	function () external payable {
401 	}
402 
403 	function wethDeposit() public payable {
404 		weth.deposit.value(msg.value)();
405 	}
406 
407 	function wethWithdraw(uint256 _amount) public onlyOwner {
408 		weth.withdraw(_amount);
409 		owner.transfer(_amount);
410 	}
411 
412 	function ethWithdraw() public onlyOwner {
413 		// Ensure enough ether is left for PullPayments
414 		uint256 _amount = address(this).balance.sub(totalPayments);
415 		owner.transfer(_amount);
416 	}
417 
418 	// Affiliates and provider are only ever due raw ether, all tokens are due to owner
419 	function transferTokens(ERC20 _token) public onlyOwner {
420 		_token.transfer(owner, _token.balanceOf(this));
421 	}
422 
423 	function ethPriceInUsd() public view returns (uint256 _attousd) {
424 		return uint256(maker.pip().read());
425 	}
426 
427 	function estimateDaiSaleProceeds(uint256 _attodaiToSell) public view returns (uint256 _daiPaid, uint256 _wethBought) {
428 		return getPayPriceAndAmount(dai, weth, _attodaiToSell);
429 	}
430 
431 	// buy/pay are from the perspective of the taker/caller (Oasis contracts use buy/pay terminology from perspective of the maker)
432 	function getPayPriceAndAmount(ERC20 _payGem, ERC20 _buyGem, uint256 _payDesiredAmount) public view returns (uint256 _paidAmount, uint256 _boughtAmount) {
433 		uint256 _offerId = oasis.getBestOffer(_buyGem, _payGem);
434 		while (_offerId != 0) {
435 			uint256 _payRemaining = _payDesiredAmount.sub(_paidAmount);
436 			(uint256 _buyAvailableInOffer, , uint256 _payAvailableInOffer,) = oasis.getOffer(_offerId);
437 			if (_payRemaining <= _payAvailableInOffer) {
438 				uint256 _buyRemaining = _payRemaining.mul(_buyAvailableInOffer).div(_payAvailableInOffer);
439 				_paidAmount = _paidAmount.add(_payRemaining);
440 				_boughtAmount = _boughtAmount.add(_buyRemaining);
441 				break;
442 			}
443 			_paidAmount = _paidAmount.add(_payAvailableInOffer);
444 			_boughtAmount = _boughtAmount.add(_buyAvailableInOffer);
445 			_offerId = oasis.getWorseOffer(_offerId);
446 		}
447 		return (_paidAmount, _boughtAmount);
448 	}
449 
450 	modifier wethBalanceUnchanged() {
451 		uint256 _startingAttowethBalance = weth.balanceOf(this);
452 		_;
453 		require(weth.balanceOf(this) >= _startingAttowethBalance);
454 	}
455 
456 	// TODO: change affiliate fee to be 50% of service fee, no parameter needed
457 	function openCdp(uint256 _leverage, uint256 _leverageSizeInAttoeth, uint256 _allowedFeeInAttoeth, address _affiliateAddress) public payable wethBalanceUnchanged returns (bytes32 _cdpId) {
458 		require(_leverage >= 100 && _leverage <= 300);
459 		uint256 _lockedInCdpInAttoeth = _leverageSizeInAttoeth.mul(_leverage).div(100);
460 		uint256 _loanInAttoeth = _lockedInCdpInAttoeth.sub(_leverageSizeInAttoeth);
461 		uint256 _feeInAttoeth = _loanInAttoeth.mul18(providerFeePerEth);
462 		require(_feeInAttoeth <= _allowedFeeInAttoeth);
463 		uint256 _drawInAttodai = _loanInAttoeth.mul18(uint256(maker.pip().read()));
464 		uint256 _attopethLockedInCdp = _lockedInCdpInAttoeth.div27(maker.per());
465 
466 		// Convert ETH to WETH (only the value amount, excludes loan amount which is already WETH)
467 		weth.deposit.value(_leverageSizeInAttoeth)();
468 		// Open CDP
469 		_cdpId = maker.open();
470 		// Convert WETH into PETH
471 		maker.join(_attopethLockedInCdp);
472 		// Store PETH in CDP
473 		maker.lock(_cdpId, _attopethLockedInCdp);
474 		// Withdraw DAI from CDP
475 		maker.draw(_cdpId, _drawInAttodai);
476 		// Sell DAI for WETH
477 		sellDai(_drawInAttodai, _lockedInCdpInAttoeth, _feeInAttoeth, _loanInAttoeth);
478 		// Pay provider fee
479 		if (_feeInAttoeth != 0) {
480 			// Fee charged is constant. If affiliate provided, split fee with affiliate
481 			if (_affiliateAddress == 0x0) {
482 				asyncSend(owner, _feeInAttoeth);
483 			} else {
484 				asyncSend(owner, _feeInAttoeth.div(2));
485 				asyncSend(_affiliateAddress, _feeInAttoeth.div(2));
486 			}
487 		}
488 
489 		emit NewCup(msg.sender, _cdpId);
490 
491 		giveCdpToProxy(msg.sender, _cdpId);
492 	}
493 
494 	function giveCdpToProxy(address _ownerOfProxy, bytes32 _cdpId) private {
495 		DSProxy _proxy = proxyRegistry.proxies(_ownerOfProxy);
496 		if (_proxy == DSProxy(0) || _proxy.owner() != _ownerOfProxy) {
497 			_proxy = proxyRegistry.build(_ownerOfProxy);
498 		}
499 		// Send the CDP to the owner's proxy instead of directly to owner
500 		maker.give(_cdpId, proxyRegistry);
501 	}
502 
503 	// extracted function to mitigate stack depth issues
504 	function sellDai(uint256 _drawInAttodai, uint256 _lockedInCdpInAttoeth, uint256 _feeInAttoeth, uint256 _loanInAttoeth) private {
505 		uint256 _wethBoughtInAttoweth = oasis.sellAllAmount(dai, _drawInAttodai, weth, 0);
506 		// SafeMath failure below catches not enough eth provided
507 		uint256 _refundDue = msg.value.add(_wethBoughtInAttoweth).sub(_lockedInCdpInAttoeth).sub(_feeInAttoeth);
508 		if (_refundDue > 0) {
509 			require(msg.sender.call.value(_refundDue)());
510 		}
511 
512 		if (_loanInAttoeth > _wethBoughtInAttoweth) {
513 			weth.deposit.value(_loanInAttoeth - _wethBoughtInAttoweth)();
514 		}
515 	}
516 }