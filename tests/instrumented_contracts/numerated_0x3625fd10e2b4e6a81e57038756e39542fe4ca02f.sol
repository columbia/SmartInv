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
253 		require(payment != 0);
254 		require(address(this).balance >= payment);
255 
256 		totalPayments = totalPayments.sub(payment);
257 		payments[payee] = 0;
258 
259 		payee.transfer(payment);
260 	}
261 
262 	/**
263 	* @dev Called by the payer to store the sent amount as credit to be pulled.
264 	* @param dest The destination address of the funds.
265 	* @param amount The amount to transfer.
266 	*/
267 	function asyncSend(address dest, uint256 amount) internal {
268 		payments[dest] = payments[dest].add(amount);
269 		totalPayments = totalPayments.add(amount);
270 	}
271 }
272 
273 contract Dai is ERC20 {
274 
275 }
276 
277 contract Weth is ERC20 {
278 	function deposit() public payable;
279 	function withdraw(uint wad) public;
280 }
281 
282 contract Mkr is ERC20 {
283 
284 }
285 
286 contract Peth is ERC20 {
287 
288 }
289 
290 contract Oasis {
291 	function getBuyAmount(ERC20 tokenToBuy, ERC20 tokenToPay, uint256 amountToPay) external view returns(uint256 amountBought);
292 	function getPayAmount(ERC20 tokenToPay, ERC20 tokenToBuy, uint amountToBuy) public constant returns (uint amountPaid);
293 	function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint offerId);
294 	function getWorseOffer(uint id) public constant returns(uint offerId);
295 	function getOffer(uint id) public constant returns (uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem);
296 	function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount) public returns (uint fill_amt);
297 }
298 
299 contract Medianizer {
300 	function read() external view returns(bytes32);
301 }
302 
303 contract Maker {
304 	function sai() external view returns(Dai);
305 	function gem() external view returns(Weth);
306 	function gov() external view returns(Mkr);
307 	function skr() external view returns(Peth);
308 	function pip() external view returns(Medianizer);
309 
310 	// Join-Exit Spread
311 	 uint256 public gap;
312 
313 	struct Cup {
314 		// CDP owner
315 		address lad;
316 		// Locked collateral (in SKR)
317 		uint256 ink;
318 		// Outstanding normalised debt (tax only)
319 		uint256 art;
320 		// Outstanding normalised debt
321 		uint256 ire;
322 	}
323 
324 	uint256 public cupi;
325 	mapping (bytes32 => Cup) public cups;
326 
327 	function lad(bytes32 cup) public view returns (address);
328 	function per() public view returns (uint ray);
329 	function tab(bytes32 cup) public returns (uint);
330 	function ink(bytes32 cup) public returns (uint);
331 	function rap(bytes32 cup) public returns (uint);
332 	function chi() public returns (uint);
333 
334 	function open() public returns (bytes32 cup);
335 	function give(bytes32 cup, address guy) public;
336 	function lock(bytes32 cup, uint wad) public;
337 	function draw(bytes32 cup, uint wad) public;
338 	function join(uint wad) public;
339 	function wipe(bytes32 cup, uint wad) public;
340 }
341 
342 contract LiquidLong is Ownable, Claimable, Pausable, PullPayment {
343 	using SafeMath for uint256;
344 	using SafeMathFixedPoint for uint256;
345 
346 	uint256 public providerFeePerEth;
347 
348 	Oasis public oasis;
349 	Maker public maker;
350 	Dai public dai;
351 	Weth public weth;
352 	Peth public peth;
353 	Mkr public mkr;
354 
355 	event NewCup(address user, bytes32 cup);
356 
357 	constructor(Oasis _oasis, Maker _maker) public payable {
358 		providerFeePerEth = 0.01 ether;
359 
360 		oasis = _oasis;
361 		maker = _maker;
362 		dai = maker.sai();
363 		weth = maker.gem();
364 		peth = maker.skr();
365 		mkr = maker.gov();
366 
367 		// Oasis buy/sell
368 		dai.approve(address(_oasis), uint256(-1));
369 		// Wipe
370 		dai.approve(address(_maker), uint256(-1));
371 		mkr.approve(address(_maker), uint256(-1));
372 		// Join
373 		weth.approve(address(_maker), uint256(-1));
374 		// Lock
375 		peth.approve(address(_maker), uint256(-1));
376 
377 		if (msg.value > 0) {
378 			weth.deposit.value(msg.value)();
379 		}
380 	}
381 
382 	// Receive ETH from WETH withdraw
383 	function () external payable {
384 	}
385 
386 	function wethDeposit() public payable {
387 		weth.deposit.value(msg.value)();
388 	}
389 
390 	function wethWithdraw(uint256 _amount) public onlyOwner {
391 		weth.withdraw(_amount);
392 		owner.transfer(_amount);
393 	}
394 
395 	function ethWithdraw() public onlyOwner {
396 		// Ensure enough ether is left for PullPayments
397 		uint256 _amount = address(this).balance.sub(totalPayments);
398 		owner.transfer(_amount);
399 	}
400 
401 	// Affiliates and provider are only ever due raw ether, all tokens are due to owner
402 	function transferTokens(ERC20 _token) public onlyOwner {
403 		_token.transfer(owner, _token.balanceOf(this));
404 	}
405 
406 	function ethPriceInUsd() public view returns (uint256 _attousd) {
407 		return uint256(maker.pip().read());
408 	}
409 
410 	function estimateDaiSaleProceeds(uint256 _attodaiToSell) public view returns (uint256 _daiPaid, uint256 _wethBought) {
411 		return getPayPriceAndAmount(dai, weth, _attodaiToSell);
412 	}
413 
414 	// buy/pay are from the perspective of the taker/caller (Oasis contracts use buy/pay terminology from perspective of the maker)
415 	function getPayPriceAndAmount(ERC20 _payGem, ERC20 _buyGem, uint256 _payDesiredAmount) public view returns (uint256 _paidAmount, uint256 _boughtAmount) {
416 		uint256 _offerId = oasis.getBestOffer(_buyGem, _payGem);
417 		while (_offerId != 0) {
418 			uint256 _payRemaining = _payDesiredAmount.sub(_paidAmount);
419 			(uint256 _buyAvailableInOffer, , uint256 _payAvailableInOffer,) = oasis.getOffer(_offerId);
420 			if (_payRemaining <= _payAvailableInOffer) {
421 				uint256 _buyRemaining = _payRemaining.mul(_buyAvailableInOffer).div(_payAvailableInOffer);
422 				_paidAmount = _paidAmount.add(_payRemaining);
423 				_boughtAmount = _boughtAmount.add(_buyRemaining);
424 				break;
425 			}
426 			_paidAmount = _paidAmount.add(_payAvailableInOffer);
427 			_boughtAmount = _boughtAmount.add(_buyAvailableInOffer);
428 			_offerId = oasis.getWorseOffer(_offerId);
429 		}
430 		return (_paidAmount, _boughtAmount);
431 	}
432 
433 	function openCdp(uint256 _leverage, uint256 _leverageSizeInAttoeth, uint256 _allowedFeeInAttoeth, uint256 _affiliateFeeInAttoeth, address _affiliateAddress) public payable returns (bytes32 _cdpId) {
434 		require(_leverage >= 100 && _leverage <= 300);
435 		uint256 _lockedInCdpInAttoeth = _leverageSizeInAttoeth.mul(_leverage).div(100);
436 		uint256 _loanInAttoeth = _lockedInCdpInAttoeth.sub(_leverageSizeInAttoeth);
437 		uint256 _providerFeeInAttoeth = _loanInAttoeth.mul18(providerFeePerEth);
438 		require(_providerFeeInAttoeth <= _allowedFeeInAttoeth);
439 		uint256 _drawInAttodai = _loanInAttoeth.mul18(uint256(maker.pip().read()));
440 		uint256 _pethLockedInCdp = _lockedInCdpInAttoeth.div27(maker.per());
441 
442 		// Convert ETH to WETH (only the value amount, excludes loan amount which is already WETH)
443 		weth.deposit.value(_leverageSizeInAttoeth)();
444 		// Open CDP
445 		_cdpId = maker.open();
446 		// Convert WETH into PETH
447 		maker.join(_pethLockedInCdp);
448 		// Store PETH in CDP
449 		maker.lock(_cdpId, _pethLockedInCdp);
450 		// Withdraw DAI from CDP
451 		maker.draw(_cdpId, _drawInAttodai);
452 
453 		// Sell all drawn DAI
454 		uint256 _wethBoughtInAttoweth = oasis.sellAllAmount(dai, _drawInAttodai, weth, 0);
455 		// SafeMath failure below catches not enough eth provided
456 		uint256 _refundDue = msg.value.add(_wethBoughtInAttoweth).sub(_lockedInCdpInAttoeth).sub(_providerFeeInAttoeth).sub(_affiliateFeeInAttoeth);
457 
458 		if (_loanInAttoeth > _wethBoughtInAttoweth) {
459 			weth.deposit.value(_loanInAttoeth - _wethBoughtInAttoweth)();
460 		}
461 
462 		if (_providerFeeInAttoeth != 0) {
463 			asyncSend(owner, _providerFeeInAttoeth);
464 		}
465 		if (_affiliateFeeInAttoeth != 0) {
466 			asyncSend(_affiliateAddress, _affiliateFeeInAttoeth);
467 		}
468 
469 		emit NewCup(msg.sender, _cdpId);
470 		// Send the CDP to the user
471 		maker.give(_cdpId, msg.sender);
472 
473 		if (_refundDue > 0) {
474 			require(msg.sender.call.value(_refundDue)());
475 		}
476 	}
477 }