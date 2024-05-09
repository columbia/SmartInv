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
234 contract Dai is ERC20 {
235 
236 }
237 
238 contract Weth is ERC20 {
239 	function deposit() public payable;
240 	function withdraw(uint wad) public;
241 }
242 
243 contract Mkr is ERC20 {
244 
245 }
246 
247 contract Peth is ERC20 {
248 
249 }
250 
251 contract Oasis {
252 	function getBuyAmount(ERC20 tokenToBuy, ERC20 tokenToPay, uint256 amountToPay) external view returns(uint256 amountBought);
253 	function getPayAmount(ERC20 tokenToPay, ERC20 tokenToBuy, uint amountToBuy) public constant returns (uint amountPaid);
254 	function getBestOffer(ERC20 sell_gem, ERC20 buy_gem) public constant returns(uint offerId);
255 	function getWorseOffer(uint id) public constant returns(uint offerId);
256 	function getOffer(uint id) public constant returns (uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem);
257 	function sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount) public returns (uint fill_amt);
258 }
259 
260 contract Medianizer {
261 	function read() external view returns(bytes32);
262 }
263 
264 contract Maker {
265 	function sai() external view returns(Dai);
266 	function gem() external view returns(Weth);
267 	function gov() external view returns(Mkr);
268 	function skr() external view returns(Peth);
269 	function pip() external view returns(Medianizer);
270 
271 	// Join-Exit Spread
272 	 uint256 public gap;
273 
274 	struct Cup {
275 		// CDP owner
276 		address lad;
277 		// Locked collateral (in SKR)
278 		uint256 ink;
279 		// Outstanding normalised debt (tax only)
280 		uint256 art;
281 		// Outstanding normalised debt
282 		uint256 ire;
283 	}
284 
285 	uint256 public cupi;
286 	mapping (bytes32 => Cup) public cups;
287 
288 	function lad(bytes32 cup) public view returns (address);
289 	function per() public view returns (uint ray);
290 	function tab(bytes32 cup) public returns (uint);
291 	function ink(bytes32 cup) public returns (uint);
292 	function rap(bytes32 cup) public returns (uint);
293 	function chi() public returns (uint);
294 
295 	function open() public returns (bytes32 cup);
296 	function give(bytes32 cup, address guy) public;
297 	function lock(bytes32 cup, uint wad) public;
298 	function draw(bytes32 cup, uint wad) public;
299 	function join(uint wad) public;
300 	function wipe(bytes32 cup, uint wad) public;
301 }
302 
303 contract DSProxy {
304 	// Technically from DSAuth
305 	address public owner;
306 
307 	function execute(address _target, bytes _data) public payable returns (bytes32 response);
308 }
309 
310 contract ProxyRegistry {
311 	mapping(address => DSProxy) public proxies;
312 	function build(address owner) public returns (DSProxy proxy);
313 }
314 
315 contract LiquidLong is Ownable, Claimable, Pausable {
316 	using SafeMath for uint256;
317 	using SafeMathFixedPoint for uint256;
318 
319 	uint256 public providerFeePerEth;
320 
321 	Oasis public oasis;
322 	Maker public maker;
323 	Dai public dai;
324 	Weth public weth;
325 	Peth public peth;
326 	Mkr public mkr;
327 
328 	ProxyRegistry public proxyRegistry;
329 
330 	event NewCup(address user, bytes32 cup);
331 
332 	constructor(Oasis _oasis, Maker _maker, ProxyRegistry _proxyRegistry) public payable {
333 		providerFeePerEth = 0.01 ether;
334 
335 		oasis = _oasis;
336 		maker = _maker;
337 		dai = maker.sai();
338 		weth = maker.gem();
339 		peth = maker.skr();
340 		mkr = maker.gov();
341 
342 		// Oasis buy/sell
343 		dai.approve(address(_oasis), uint256(-1));
344 		// Wipe
345 		dai.approve(address(_maker), uint256(-1));
346 		mkr.approve(address(_maker), uint256(-1));
347 		// Join
348 		weth.approve(address(_maker), uint256(-1));
349 		// Lock
350 		peth.approve(address(_maker), uint256(-1));
351 
352 		proxyRegistry = _proxyRegistry;
353 
354 		if (msg.value > 0) {
355 			weth.deposit.value(msg.value)();
356 		}
357 	}
358 
359 	// Receive ETH from WETH withdraw
360 	function () external payable {
361 	}
362 
363 	function wethDeposit() public payable {
364 		weth.deposit.value(msg.value)();
365 	}
366 
367 	function wethWithdraw(uint256 _amount) public onlyOwner {
368 		weth.withdraw(_amount);
369 		owner.transfer(_amount);
370 	}
371 
372 	function ethWithdraw() public onlyOwner {
373 		uint256 _amount = address(this).balance;
374 		owner.transfer(_amount);
375 	}
376 
377 	function transferTokens(ERC20 _token) public onlyOwner {
378 		_token.transfer(owner, _token.balanceOf(this));
379 	}
380 
381 	function ethPriceInUsd() public view returns (uint256 _attousd) {
382 		return uint256(maker.pip().read());
383 	}
384 
385 	function estimateDaiSaleProceeds(uint256 _attodaiToSell) public view returns (uint256 _daiPaid, uint256 _wethBought) {
386 		return getPayPriceAndAmount(dai, weth, _attodaiToSell);
387 	}
388 
389 	// buy/pay are from the perspective of the taker/caller (Oasis contracts use buy/pay terminology from perspective of the maker)
390 	function getPayPriceAndAmount(ERC20 _payGem, ERC20 _buyGem, uint256 _payDesiredAmount) public view returns (uint256 _paidAmount, uint256 _boughtAmount) {
391 		uint256 _offerId = oasis.getBestOffer(_buyGem, _payGem);
392 		while (_offerId != 0) {
393 			uint256 _payRemaining = _payDesiredAmount.sub(_paidAmount);
394 			(uint256 _buyAvailableInOffer,  , uint256 _payAvailableInOffer,) = oasis.getOffer(_offerId);
395 			if (_payRemaining <= _payAvailableInOffer) {
396 				uint256 _buyRemaining = _payRemaining.mul(_buyAvailableInOffer).div(_payAvailableInOffer);
397 				_paidAmount = _paidAmount.add(_payRemaining);
398 				_boughtAmount = _boughtAmount.add(_buyRemaining);
399 				break;
400 			}
401 			_paidAmount = _paidAmount.add(_payAvailableInOffer);
402 			_boughtAmount = _boughtAmount.add(_buyAvailableInOffer);
403 			_offerId = oasis.getWorseOffer(_offerId);
404 		}
405 		return (_paidAmount, _boughtAmount);
406 	}
407 
408 	modifier wethBalanceIncreased() {
409 		uint256 _startingAttowethBalance = weth.balanceOf(this);
410 		_;
411 		require(weth.balanceOf(this) > _startingAttowethBalance);
412 	}
413 
414 	// TODO: change affiliate fee to be 50% of service fee, no parameter needed
415 	function openCdp(uint256 _leverage, uint256 _leverageSizeInAttoeth, uint256 _allowedFeeInAttoeth, address _affiliateAddress) public payable wethBalanceIncreased returns (bytes32 _cdpId) {
416 		require(_leverage >= 100 && _leverage <= 300);
417 		uint256 _lockedInCdpInAttoeth = _leverageSizeInAttoeth.mul(_leverage).div(100);
418 		uint256 _loanInAttoeth = _lockedInCdpInAttoeth.sub(_leverageSizeInAttoeth);
419 		uint256 _feeInAttoeth = _loanInAttoeth.mul18(providerFeePerEth);
420 		require(_feeInAttoeth <= _allowedFeeInAttoeth);
421 		uint256 _drawInAttodai = _loanInAttoeth.mul18(uint256(maker.pip().read()));
422 		uint256 _attopethLockedInCdp = _lockedInCdpInAttoeth.div27(maker.per());
423 
424 		// Convert all incoming eth to weth (we will pay back later if too much)
425 		weth.deposit.value(msg.value)();
426 		// Open CDP
427 		_cdpId = maker.open();
428 		// Convert WETH into PETH
429 		maker.join(_attopethLockedInCdp);
430 		// Store PETH in CDP
431 		maker.lock(_cdpId, _attopethLockedInCdp);
432 		// Withdraw DAI from CDP
433 		maker.draw(_cdpId, _drawInAttodai);
434 		// Sell DAI for WETH
435 		sellDai(_drawInAttodai, _lockedInCdpInAttoeth, _feeInAttoeth);
436 		// Pay provider fee
437 		if (_affiliateAddress != address(0)) {
438 			// Fee charged is constant. If affiliate provided, split fee with affiliate
439 			// Don't bother sending eth to owner, the owner has all non-async-sent eth anyway
440 			weth.transfer(_affiliateAddress, _feeInAttoeth.div(2));
441 		}
442 
443 		emit NewCup(msg.sender, _cdpId);
444 
445 		giveCdpToProxy(msg.sender, _cdpId);
446 	}
447 
448 	function giveCdpToProxy(address _ownerOfProxy, bytes32 _cdpId) private {
449 		DSProxy _proxy = proxyRegistry.proxies(_ownerOfProxy);
450 		if (_proxy == DSProxy(0) || _proxy.owner() != _ownerOfProxy) {
451 			_proxy = proxyRegistry.build(_ownerOfProxy);
452 		}
453 		// Send the CDP to the owner's proxy instead of directly to owner
454 		maker.give(_cdpId, _proxy);
455 	}
456 
457 	// extracted function to mitigate stack depth issues
458 	function sellDai(uint256 _drawInAttodai, uint256 _lockedInCdpInAttoeth, uint256 _feeInAttoeth) private {
459 		uint256 _wethBoughtInAttoweth = oasis.sellAllAmount(dai, _drawInAttodai, weth, 0);
460 		// SafeMath failure below catches not enough eth provided
461 		uint256 _refundDue = msg.value.add(_wethBoughtInAttoweth).sub(_lockedInCdpInAttoeth).sub(_feeInAttoeth);
462 		if (_refundDue > 0) {
463 			weth.withdraw(_refundDue);
464 			require(msg.sender.call.value(_refundDue)());
465 		}
466 	}
467 }