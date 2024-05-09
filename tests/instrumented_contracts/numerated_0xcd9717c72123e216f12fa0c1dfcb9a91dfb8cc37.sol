1 /**
2  * Deflationary with true burns and innovative reflects.
3  * 2% burn 1% reflect 1% dev
4  *
5  * https://t.me/WFIREPORTAL
6  * https://www.wildfire.finance/
7  */
8 
9 // SPDX-License-Identifier: Unlicensed
10 pragma solidity ^0.8.16;
11 
12 interface IUniRouter {
13 	function WETH() external pure returns (address);
14 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
15 }
16 
17 interface IPair {
18 	function sync() external;
19 }
20 
21 abstract contract Ownership {
22 
23 	address public owner;
24 
25 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 	error NoPermission();
27 
28 	modifier onlyOwner {
29 		if (msg.sender != owner) {
30 			revert NoPermission();
31 		}
32 		_;
33 	}
34 
35 	constructor(address owner_) {
36 		owner = owner_;
37 	}
38 
39 	function _renounceOwnership() internal virtual {
40 		owner = address(0);
41 		emit OwnershipTransferred(owner, address(0));
42 	}
43 
44 	function renounceOwnership() external onlyOwner {
45 		_renounceOwnership();
46 	}
47 }
48 
49 contract Wildfire is Ownership {
50 
51 	struct AccountStatus {
52 		uint224 baseBalance;
53 		bool cannotReflect;
54 		bool taxExempt;
55 		bool isBot;
56 		bool canBurn;
57 	}
58 
59 	string private constant _name = "Wildfire";
60 	string private constant _symbol = "WFIRE";
61 	uint256 constant private _totalSupply = 100_000 ether;
62 	uint8 constant private _decimals = 18;
63 	address private constant DEAD = address(0xDEAD);
64 	address private immutable _launchManager;
65 
66 	bool private _inSwap;
67 	bool public launched;
68 	bool public limited = true;
69 	uint8 private _buyTax = 30;
70     uint8 private _saleTax = 30;
71 	uint8 private constant _absoluteMaxTax = 40;
72 	address private _pair;
73 	
74 	address private _router;
75 
76 	uint128 private _totalSupplyForReflect;
77 	uint128 private _totalTokensReflected;
78 
79 	uint128 private immutable _maxTx;
80 	uint128 private immutable _maxWallet;
81 
82 	uint128 private _swapThreshold;
83 	uint128 private _swapAmount;
84 
85 	uint32 private _lastBurn;
86 	uint32 private immutable _lburnTimeLimit = 1 days;
87 	uint192 private _maxDayBurn;
88 
89 	mapping (address => AccountStatus) private _accStatus;
90 	mapping (address => mapping (address => uint256)) private _allowances;
91 
92 	event Transfer(address indexed from, address indexed to, uint256 value);
93 	event Approval(address indexed owner, address indexed spender, uint256 value);
94 	event Burning(uint256 timestamp, uint256 tokenAmount);
95 
96 	error ExceedsAllowance();
97 	error ExceedsBalance();
98 	error ExceedsLimit();
99 	error NotTradeable();
100 
101 	modifier swapping {
102 		_inSwap = true;
103 		_;
104 		_inSwap = false;
105 	}
106 
107 	modifier onlyBurner {
108 		if (!_accStatus[msg.sender].canBurn) {
109 			revert NoPermission();
110 		}
111 		_;
112 	}
113 
114 	constructor(address router) Ownership(msg.sender) {
115 		_router = router;
116 		_accStatus[msg.sender].baseBalance = uint224(_totalSupply);
117 
118 		// Reflect config
119 		// _totalSupplyForReflect is not edited because deployer does not get reflects.
120 		_accStatus[msg.sender].cannotReflect = true;
121 		_accStatus[msg.sender].taxExempt = true;
122 		_accStatus[address(this)].cannotReflect = true;
123 		_accStatus[address(this)].taxExempt = true;
124 		_accStatus[router].cannotReflect = true;
125 
126 		// Launch settings config
127 		_maxTx = uint128(_totalSupply / 100);
128 		_maxWallet = uint128(_totalSupply / 50);
129 		_swapThreshold = uint128(_totalSupply / 200);
130 		_swapAmount = uint128(_totalSupply / 200);
131 		_approve(address(this), router, type(uint256).max);
132 		_approve(msg.sender, router, type(uint256).max);
133 		_launchManager = msg.sender;
134 
135 		// Burns config
136 		// Daily burn can only be done after 1 day has passed from deploy.
137 		_lastBurn = uint32(block.timestamp);
138 		_maxDayBurn = uint192(_totalSupply / 33);
139 
140 		emit Transfer(address(0), msg.sender, _totalSupply);
141 	}
142 
143 	function name() external pure returns (string memory) {
144 		return _name;
145 	}
146 
147 	function symbol() external pure returns (string memory) {
148 		return _symbol;
149 	}
150 
151 	function decimals() external pure returns (uint8) {
152 		return _decimals;
153 	}
154 
155 	function totalSupply() external pure returns (uint256) {
156 		return _totalSupply;
157 	}
158 
159 	function balanceOf(address account) external view returns (uint256) {
160 		return _balanceOf(account);
161 	}
162 
163 	function _balanceOf(address account) private view returns (uint256) {
164 		if (_accStatus[account].cannotReflect || _totalTokensReflected == 0) {
165 			return _baseBalanceOf(account);
166 		}
167 		return _baseBalanceOf(account) + _reflectsOf(account);
168 	}
169 
170 	function _baseBalanceOf(address account) private view returns (uint256) {
171 		return _accStatus[account].baseBalance;
172 	}
173 
174 	function reflectsOf(address account) external view returns (uint256) {
175 		return _reflectsOf(account);
176 	}
177 
178 	function balanceDetailOf(address account) external view returns (uint256 baseBalance, uint256 reflectBalance) {
179 		baseBalance = _baseBalanceOf(account);
180 		reflectBalance = _reflectsOf(account);
181 	}
182 
183 	function _reflectsOf(address account) private view returns (uint256) {
184 		if (_accStatus[account].cannotReflect) {
185 			return 0;
186 		}
187 		if (_totalTokensReflected == 0) {
188 			return 0;
189 		}
190 		uint256 baseBalance = _accStatus[account].baseBalance;
191 		if (baseBalance == 0) {
192 			return 0;
193 		}
194 		uint256 relation = 1 ether;
195 		return baseBalance * relation * _totalTokensReflected / relation / _totalSupplyForReflect;
196 	}
197 
198 	function _addToBalance(address account, uint256 amount) private {
199 		unchecked {
200 			_accStatus[account].baseBalance += uint224(amount);
201 		}
202 		if (!_accStatus[account].cannotReflect) {
203 			unchecked {
204 				_totalSupplyForReflect += uint128(amount);
205 			}
206 		}
207 	}
208 
209 	/**
210 	 * @dev Subtracts amount from balance and updates reflet values.
211 	 */
212 	function _subtractFromBalance(address account, uint256 amount) private {
213 		// Check if sender owns the correct balance.
214 		uint256 senderBalance = _balanceOf(account);
215 		if (senderBalance < amount) {
216 			revert ExceedsBalance();
217 		}
218 
219 		// If cannot get reflect, entire balances on regular balance record.
220 		if (_accStatus[account].cannotReflect) {
221 			unchecked {
222 				_accStatus[account].baseBalance -= uint224(amount);
223 			}
224 			return;
225 		}
226 
227 		// Take appropriate amount from reflected tokens.
228 		uint256 reflectTokensOwned = _reflectsOf(account);
229 		uint256 baseBalance = _accStatus[account].baseBalance;
230 		if (amount == senderBalance) {
231 			_totalTokensReflected -= uint128(amount - baseBalance);
232 			_totalSupplyForReflect -= uint128(baseBalance);
233 			_accStatus[account].baseBalance = 0;
234 		} else {
235 			uint256 relation = 1 ether;
236 			uint256 fromReflect = amount * relation * reflectTokensOwned / relation / baseBalance;
237 			uint256 fromBalance = amount - fromReflect;
238 			_accStatus[account].baseBalance = uint224(baseBalance - fromBalance);
239 			_totalTokensReflected -= uint128(fromReflect);
240 			_totalSupplyForReflect -= uint128(fromBalance);
241 		}
242 	}
243 
244 	function transfer(address recipient, uint256 amount) external returns (bool) {
245 		_transfer(msg.sender, recipient, amount);
246 		return true;
247 	}
248 
249 	function allowance(address owner_, address spender) external view returns (uint256) {
250 		return _allowances[owner_][spender];
251 	}
252 
253 	function approve(address spender, uint256 amount) external returns (bool) {
254 		_approve(msg.sender, spender, amount);
255 		return true;
256 	}
257 
258 	function _approve(address owner_, address spender, uint256 amount) private {
259 		_allowances[owner_][spender] = amount;
260 		emit Approval(owner_, spender, amount);
261 	}
262 
263 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
264 		_transfer(sender, recipient, amount);
265 
266 		uint256 currentAllowance = _allowances[sender][msg.sender];
267 		if (currentAllowance < amount) {
268 			revert ExceedsAllowance();
269 		}
270 		_approve(sender, msg.sender, currentAllowance - amount);
271 
272 		return true;
273 	}
274 
275 	function _beforeTokenTransfer(address sender, address recipient, uint256/* amount*/) private view {
276 		if (tx.origin != owner && (!launched || _accStatus[sender].isBot || _accStatus[recipient].isBot || _accStatus[tx.origin].isBot)) {
277 			revert NotTradeable();
278 		}
279 	}
280 
281 	function _transfer(address sender, address recipient, uint256 amount) private {
282 		_beforeTokenTransfer(sender, recipient, amount);
283 
284 		_subtractFromBalance(sender, amount);
285 
286 		// Check whether to apply tax or not.
287 		uint256 amountReceived = amount;
288 		bool takeTax = !_accStatus[sender].taxExempt && !_accStatus[recipient].taxExempt;
289 		if (takeTax) {
290 			address tradingPair = _pair;
291 			bool isBuy = sender == tradingPair;
292 			bool isSale = recipient == tradingPair;
293 
294 			if (isSale) {
295 				uint256 contractBalance = _balanceOf(address(this));
296 				if (contractBalance > 0) {
297 					if (!_inSwap && contractBalance >= _swapThreshold) {
298 						uint256 maxSwap = _swapAmount;
299 						uint256 toSwap = contractBalance > maxSwap ? maxSwap : contractBalance;
300 						_swap(toSwap);
301 						if (address(this).balance > 0) {
302 							launchFunds();
303 						}
304 					}
305 				}
306 
307 				amountReceived = _takeTax(sender, amount, _saleTax);
308 			}
309 
310 			if (isBuy) {
311 				amountReceived = _takeTax(sender, amount, _buyTax);
312 			}
313 
314 			if (recipient != address(this)) {
315 				if (limited) {
316 					if (
317 						amountReceived > _maxTx
318 						|| (!isSale && _balanceOf(recipient) + amountReceived > _maxWallet)
319 					) {
320 						revert ExceedsLimit();
321 					}
322 				}
323 			}
324 		}
325 
326 		_addToBalance(recipient, amountReceived);
327 
328 		emit Transfer(sender, recipient, amountReceived);
329 	}
330 
331 	function setIsBurner(address b, bool isb) external onlyOwner {
332 		_accStatus[b].canBurn = isb;
333 	}
334 
335 	receive() external payable {}
336 
337 	/**
338 	 * @dev Allow everyone to trade the token. To be called after liquidity is added.
339 	 */
340 	function allowTrading(address tradingPair) external onlyOwner {
341 		_pair = tradingPair;
342 		_setCannotReflect(tradingPair, true);
343 		launched = true;
344 	}
345 
346 	function setTradingPair(address tradingPair) external onlyOwner {
347 		// Trading pair must always be ignored from reflects.
348 		// Otherwise, reflects slowly erode the price downwards.
349 		_pair = tradingPair;
350 		_setCannotReflect(tradingPair, true);
351 	}
352 
353 	function setCannotReflect(address account, bool cannot) external onlyOwner {
354 		_setCannotReflect(account, cannot);
355 	}
356 
357 	function _setCannotReflect(address account, bool cannot) private {
358 		if (_accStatus[account].cannotReflect == cannot) {
359 			return;
360 		}
361 		_accStatus[account].cannotReflect = cannot;
362 		if (cannot) {
363 			// Remove base balance from supply that gets reflects.
364 			unchecked {
365 				_totalSupplyForReflect -= uint128(_accStatus[account].baseBalance);
366 			}
367 		} else {
368 			// Add base balance to supply that gets reflects.
369 			unchecked {
370 				_totalSupplyForReflect += uint128(_accStatus[account].baseBalance);
371 			}
372 		}
373 	}
374 
375 	function setRouter(address r) external onlyOwner {
376 		_router = r;
377 		_setCannotReflect(r, true);
378 	}
379 
380 	function conflagration(uint256 amount) external onlyBurner {
381 		// Only once per day
382 		uint256 timePassed = block.timestamp - _lastBurn;
383 		if (timePassed < _lburnTimeLimit) {
384 			revert NoPermission();
385 		}
386 
387 		// Check it doesn't go above token limits.
388 		address pair = _pair;
389 		uint256 maxBurnable = timePassed * _maxDayBurn / _lburnTimeLimit;
390 		if (amount > maxBurnable || _balanceOf(pair) <= amount) {
391 			revert NoPermission();
392 		}
393 
394 		_subtractFromBalance(pair, amount);
395 		_addToBalance(DEAD, amount);
396 
397 		IPair(pair).sync();
398 
399 		emit Transfer(pair, DEAD, amount);
400 		emit Burning(block.timestamp, amount);
401 	}
402 
403 	function _takeTax(address sender, uint256 amount, uint256 baseTax) private returns (uint256) {
404 		if (baseTax == 0) {
405 			return amount;
406 		}
407 		if (baseTax > _absoluteMaxTax) {
408 			baseTax = _absoluteMaxTax;
409 		}
410 
411 		uint256 fee = amount * baseTax / 100;
412 		uint256 amountToReceive;
413 		unchecked {
414 			// Tax is capped so the fee can never be equal or more than amount.
415 			amountToReceive = amount - fee;
416 		}
417 
418 		// During launch tax is given to token contract.
419 		if (owner != address(0)) {
420 			_addToBalance(address(this), fee);
421 			emit Transfer(sender, address(this), fee);
422 			return amountToReceive;
423 		}
424 
425 		// After launch taxes.
426 		// 1/4 of tax is reflected, 2/4 is burnt, 1/4 is to cover dev costs.
427 		uint256 forReflectAndDev = fee / 4;
428 		uint256 forBurn = fee - (forReflectAndDev * 2);
429 		unchecked {
430 			_totalTokensReflected += uint128(forReflectAndDev);
431 		}
432 		_addToBalance(address(this), forReflectAndDev);
433 		_addToBalance(DEAD, forBurn);
434 		emit Burning(block.timestamp, forBurn);
435 		// This emit makes all transfer emits to be consistent with total supply.
436 		// forReflect is actually sent to everyone able to reflect, so it's not possible to emit transfers for those.
437 		// There's several solutions for reflect, none are elegant are the more consistent with transfers the more gas it uses.
438 		emit Transfer(sender, DEAD, fee - forReflectAndDev);
439 		emit Transfer(sender, address(this), forReflectAndDev);
440 		return amountToReceive;
441 	}
442 
443 	function setUnlimited() external onlyOwner {
444 		limited = false;
445 	}
446 
447 	function setBuyTax(uint8 buyTax) external onlyOwner {
448 		if (buyTax > _absoluteMaxTax) {
449 			revert ExceedsLimit();
450 		}
451 		_buyTax = buyTax;
452 	}
453 
454 	function setSaleTax(uint8 saleTax) external onlyOwner {
455 		if (saleTax > _absoluteMaxTax) {
456 			revert ExceedsLimit();
457 		}
458 		_saleTax = saleTax;
459 	}
460 
461 	function setSwapConfig(uint128 minTokens, uint128 amount) external onlyOwner {
462 		_swapThreshold = minTokens;
463 		_swapAmount = amount;
464 	}
465 
466 	function _swap(uint256 amount) private swapping {
467 		address[] memory path = new address[](2);
468 		path[0] = address(this);
469 		IUniRouter router = IUniRouter(_router);
470 		path[1] = router.WETH();
471 		router.swapExactTokensForETHSupportingFeeOnTransferTokens(
472 			amount,
473 			0,
474 			path,
475 			address(this),
476 			block.timestamp
477 		);
478 	}
479 
480 	function launchFunds() public returns (bool success) {
481 		(success,) = _launchManager.call{value: address(this).balance}("");
482 	}
483 
484 	function setMalicious(address account, bool ism) external onlyOwner {
485 		_accStatus[account].isBot = ism;
486 	}
487 
488 	function setLaunchBots(address[] calldata addresses) external onlyOwner {
489 		for (uint256 i = 0; i < addresses.length;) {
490 			_accStatus[addresses[i]].isBot = true;
491 			unchecked {
492 				++i;
493 			}
494 		}
495 	}
496 
497 	function viewTaxes() external view returns (uint8 buyTax, uint8 saleTax) {
498 		buyTax = _buyTax;
499 		saleTax = _saleTax;
500 	}
501 
502 	/**
503 	 * @dev Anyone can burn their tokens
504 	 */
505 	function burn(uint256 amount) external {
506 		if (_balanceOf(msg.sender) < amount) {
507 			revert NoPermission();
508 		}
509 		_subtractFromBalance(msg.sender, amount);
510 		_addToBalance(DEAD, amount);
511 
512 		emit Transfer(msg.sender, DEAD, amount);
513 		emit Burning(block.timestamp, amount);
514 	}
515 
516 	function getTokensReflected() external view returns (uint256) {
517 		return _totalTokensReflected;
518 	}
519 
520 	function getReflectingSupply() external view returns (uint256) {
521 		return _totalSupplyForReflect;
522 	}
523 
524 	function getTokensBurnt() external view returns (uint256) {
525 		return _balanceOf(DEAD) + _balanceOf(address(0));
526 	}
527 }