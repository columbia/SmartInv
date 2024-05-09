1 /**
2  * This is the smart contract that manages the Revenue Sharing for the Prodigy Bot.
3  *
4  * https://prodigybot.io/
5  * https://t.me/ProdigySniper/
6  * https://t.me/ProdigySniperBot/
7  * https://twitter.com/Prodigy__Sniper
8  */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity >=0.7.0 <0.9.0;
12 
13 abstract contract Auth {
14 	address private owner;
15 	mapping (address => bool) private authorizations;
16 
17 	constructor(address _owner) {
18 		owner = _owner;
19 		authorizations[_owner] = true;
20 	}
21 
22 	/**
23 	* @dev Function modifier to require caller to be contract owner
24 	*/
25 	modifier onlyOwner() {
26 		require(isOwner(msg.sender), "!OWNER"); _;
27 	}
28 
29 	/**
30 	* @dev Function modifier to require caller to be authorized
31 	*/
32 	modifier authorized() {
33 		require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
34 	}
35 
36 	/**
37 	* @dev Authorize address. Owner only
38 	*/
39 	function authorize(address adr) public onlyOwner {
40 		authorizations[adr] = true;
41 	}
42 
43 	/**
44 	* @dev Remove address' authorization. Owner only
45 	*/
46 	function unauthorize(address adr) public onlyOwner {
47 		authorizations[adr] = false;
48 	}
49 
50 	/**
51 	* @dev Check if address is owner
52 	*/
53 	function isOwner(address account) public view returns (bool) {
54 		return account == owner;
55 	}
56 
57 	/**
58 	* @dev Return address' authorization status
59 	*/
60 	function isAuthorized(address adr) public view returns (bool) {
61 		return authorizations[adr];
62 	}
63 
64 	/**
65 	* @dev Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
66 	*/
67 	function transferOwnership(address payable adr) public onlyOwner {
68 		owner = adr;
69 		authorizations[adr] = true;
70 		emit OwnershipTransferred(adr);
71 	}
72 
73 	event OwnershipTransferred(address owner);
74 }
75 
76 interface IERC20 {
77 	function transfer(address recipient, uint256 amount) external returns (bool);
78 	function balanceOf(address account) external view returns (uint256);
79 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 }
81 
82 interface IRouter {
83 	function WETH() external pure returns (address);
84 	function swapExactETHForTokensSupportingFeeOnTransferTokens(
85         uint amountOutMin,
86         address[] calldata path,
87         address to,
88         uint deadline
89     ) external payable;
90 }
91 
92 contract ProdigyRevenueShare is Auth {
93 
94 	/**
95 	 * @notice The entire Prodigy token supply fits in an uint80.
96 	 * The entire supply of Ethereum fits in uint88.
97 	 * We are using this to keep track of claimed ether and unclaimable ether for a specific account.
98 	 * If we were to reach such a number, we'd need a new contract, but that'd be a very nice problem to have.
99 	 * If you fork this: Keep in mind token supplies may need different uints.
100 	 */
101 	struct Stake {
102 		uint80 amount;
103 		uint88 totalClaimed;
104 		uint88 totalExcluded;
105 	}
106 
107 	address public immutable prodigyToken;
108 	uint256 private _rewardsPerToken;
109 	uint256 private constant _accuracyFactor = 1e36;
110 	uint256 private _minStake = 20 ether;
111 	uint256 private _minPayout = 0.1 ether;
112 
113 	bool public open;
114 	uint80 private _totalStaked;
115 	uint88 private _revenueShareEther;
116 	uint16 private _sharedRevenue = 4;
117 	uint16 private _revenueDenominator = 10;
118 
119 	address public devFeeReceiver;
120 	uint96 private _devOwedEther;
121 
122 	address private _router;
123 	uint96 private _revenueSharePaid;
124 
125 	bool public migrating;
126 	uint32 public migrationStarts;
127 	uint32 public constant migrationLockTime = 7 days;
128 	address public migratingTo;
129 
130 	mapping (address => Stake) private _stakes;
131 
132 	event Realised(address account, uint256 amount);
133 	event Staked(address account, uint256 amount);
134 	event Unstaked(address account, uint256 amount);
135 	event Compounded(address account, uint256 amount, uint256 tokenAmount);
136 
137 	error ZeroAmount();
138 	error InsufficientStake();
139 	error StakingTokenRescue();
140 	error CouldNotSendEther();
141 	error ClaimTooSmall();
142 	error AlreadyStaked();
143 	error NotAvailable();
144 	error CannotMigrate();
145 	error FinaliseTooEarly();
146 
147 	modifier isOpen {
148 		if (!open) {
149 			revert NotAvailable();
150 		}
151 		_;
152 	}
153 
154 	constructor(address token, address router) Auth(msg.sender) {
155 		prodigyToken = token;
156 		_router = router;
157 	}
158 
159 	/**
160 	 * @dev Bot trading fees and token fees are sent here.
161 	 * A part is sent to developer wallet to cover for the costs of running the trading suite:
162 	 * Cloud servers, RPCs, Nodes, full-time development and support.
163 	 * The rest is shared amongst token holders who stake their position in the contract.
164 	 * You may link your staking account to your bot account, enjoying the benefits of holding and revenue share.
165 	 */
166 	receive() external payable {
167 		if (msg.value == 0) {
168 			revert ZeroAmount();
169 		}
170 
171 		// If no positions present, everything is sent to dev.
172 		uint256 stakedTokens = _totalStaked;
173 		if (stakedTokens == 0) {
174 			_manageDevShare(msg.value);
175 			return;
176 		}
177 
178 		// Calculate part for revenue share and part for development.
179 		uint256 toShare = msg.value * _sharedRevenue / _revenueDenominator;
180 		uint256 toDev = msg.value - toShare;
181 		_manageDevShare(toDev);
182 		unchecked {
183 			// If this overflow we are all rich.
184 			_revenueShareEther += uint88(toShare);
185 			// Update total rewards per token staked.
186 			uint256 newRewards = _accuracyFactor * toShare / stakedTokens;
187 			_rewardsPerToken += newRewards;
188 		}
189 	}
190 
191 	function _manageDevShare(uint256 share) private {
192 		if (_sendEther(devFeeReceiver, share + _devOwedEther)) {
193 			_devOwedEther = 0;
194 		} else {
195 			unchecked {
196 				_devOwedEther += uint96(share);
197 			}
198 		}
199 	}
200 
201 	function _sendEther(address receiver, uint256 amount) private returns (bool success) {
202 		(success,) = receiver.call{value: amount}("");
203 	}
204 
205 	function viewPosition(address account) external view returns (Stake memory) {
206 		return _stakes[account];
207 	}
208 
209 	function accountStakedTokens(address account) external view returns (uint256) {
210 		return _stakes[account].amount;
211 	}
212 
213 	function accountsSumStakedTokens(address[] calldata accounts) external view returns (uint256 tokens) {
214 		for (uint256 i = 0; i < accounts.length; ++i) {
215 			tokens += _stakes[accounts[i]].amount;
216 		}
217 	}
218 
219 	function getPendingClaim(address account) external view returns (uint256) {
220 		return _earnt(_stakes[account], false);
221 	}
222 
223 	/**
224 	 * @notice The operation must be done in uint256 before converting to uint88 for decimal precision.
225 	 */
226 	function _getCumulativeRewards(uint256 amount, bool roundUp) private view returns (uint88) {
227 		uint256 accurate = _rewardsPerToken * amount;
228 		if (roundUp) {
229 			unchecked {
230 				accurate += _accuracyFactor / 10;
231 			}
232 		}
233 		return uint88(accurate / _accuracyFactor);
234 	}
235 
236 	/**
237 	 * @dev Add a position for revenue share for the first time.
238 	 * @notice For adding to a position, call the `restake` method.
239 	 */
240 	function stake(uint256 amount) external isOpen {
241 		if (amount == 0) {
242 			revert ZeroAmount();
243 		}
244 		_firstStake(msg.sender, uint80(amount));
245 		IERC20(prodigyToken).transferFrom(msg.sender, address(this), amount);
246 	}
247 
248 	/**
249 	 * @dev Add to an existing stake plus compounding pending revenue.
250 	 * @notice Must calculate slippage from UI for expectedTokens!
251 	 */
252 	function restake(uint256 amount, uint256 expectedTokens) external isOpen {
253 		if (amount == 0) {
254 			revert ZeroAmount();
255 		}
256 		_stake(msg.sender, uint80(amount), expectedTokens);
257 		IERC20(prodigyToken).transferFrom(msg.sender, address(this), amount);
258 	}
259 
260 	/**
261 	 * @dev Add a stake for someone else.
262 	 * @notice Only available for a first time stake, since re-stake triggers compounding.
263 	 */
264 	function stakeFor(address account, uint256 amount) external isOpen {
265 		if (amount == 0) {
266 			revert ZeroAmount();
267 		}
268 
269 		_firstStake(account, uint80(amount));
270 		IERC20(prodigyToken).transferFrom(msg.sender, address(this), amount);
271 	}
272 
273 	/**
274 	 * @dev To be used for the first time a stake is done.
275 	 */
276 	function _firstStake(address account, uint80 amount) private {
277 		if (amount < _minStake) {
278 			revert InsufficientStake();
279 		}
280 		Stake storage position = _stakes[account];
281 		if (position.amount > 0) {
282 			revert AlreadyStaked();
283 		}
284 		position.amount = amount;
285 		position.totalExcluded = _getCumulativeRewards(position.amount, true);
286 		unchecked {
287 			_totalStaked += amount;
288 		}
289 
290 		emit Staked(account, amount);
291 	}
292 
293 	/**
294 	 * @dev Add to an existing position.
295 	 */
296 	function _stake(address account, uint80 amount, uint256 expectedTokens) private {
297 		Stake storage position = _stakes[account];
298 		_compound(account, position, expectedTokens);
299 
300 		unchecked {
301 			position.amount += amount;
302 			position.totalExcluded = _getCumulativeRewards(position.amount, true);
303 			_totalStaked += amount;
304 		}
305 
306 		emit Staked(account, amount);
307 	}
308 
309 	function unstake(uint256 amount) external {
310 		if (amount == 0) {
311 			revert ZeroAmount();
312 		}
313 
314 		_unstake(msg.sender, uint80(amount));
315 	}
316 
317 	function _unstake(address account, uint80 amount) private {
318 		Stake storage position = _stakes[account];
319 		// Revert if amount over actual position or it would lead a position to be under the minimum.
320 		if (position.amount < amount || (amount < position.amount && position.amount - amount < _minStake)) {
321 			revert InsufficientStake();
322 		}
323 
324 		// Forfeit remainder of revenue.
325 		_forfeit(position);
326 
327 		// Remove the stake amount.
328 		unchecked {
329 			position.amount -= amount;
330 			_totalStaked -= amount;
331 		}
332 		position.totalExcluded = _getCumulativeRewards(position.amount, true);
333 		IERC20(prodigyToken).transfer(account, amount);
334 
335 		emit Unstaked(account, amount);
336 	}
337 
338 	/**
339 	 * @dev Claim your pending share of the revenue.
340 	 * @notice There's a set minimum revenue one can claim.
341 	 */
342 	function claim() external isOpen {
343 		uint256 realised = _realise(msg.sender, _stakes[msg.sender]);
344 		if (realised < _minPayout) {
345 			revert ClaimTooSmall();
346 		}
347 	}
348 
349 	/**
350 	 * @dev Use your pending revenue to buy the token tax free and increase your ownership on the revenue share.
351 	 * @notice Slippage should be checked fron the UI and send the expected tokens to acquire by selling the rewards.
352 	 */
353 	function compound(uint256 expectedTokens) external isOpen {
354 		address account = msg.sender;
355 		Stake storage position = _stakes[account];
356 		if (position.amount == 0) {
357 			revert ZeroAmount();
358 		}
359 
360 		_compound(account, position, expectedTokens);
361 	}
362 
363 	function _compound(address account, Stake storage position, uint256 expectedTokens) private {
364 		uint88 amount = uint88(_earnt(position, false));
365 		if (amount == 0) {
366 			return;
367 		}
368 
369 		// Mark ether used for compound as claimed.
370 		unchecked {
371 			position.totalClaimed += amount;
372 			_revenueSharePaid += amount;
373 		}
374 
375 		// Buy the tokens to add to stake.
376 		uint256 tokensBefore = IERC20(prodigyToken).balanceOf(address(this));
377 		IRouter router = IRouter(_router);
378 		address[] memory buyPath = new address[](2);
379 		buyPath[0] = router.WETH();
380 		buyPath[1] = prodigyToken;
381 		router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(expectedTokens, buyPath, address(this), block.timestamp);
382 		uint80 tokensAfter = uint80(IERC20(prodigyToken).balanceOf(address(this)) - tokensBefore);
383 
384 		// Update stake and its exclusion value.
385 		unchecked {
386 			position.amount += tokensAfter;
387 			_totalStaked += tokensAfter;
388 		}
389 		position.totalExcluded = _getCumulativeRewards(position.amount, true);
390 
391 		emit Compounded(account, amount, tokensAfter);
392 	}
393 
394 	function _forfeit(Stake storage position) private {
395 		uint256 amount = _earnt(position, false);
396 		if (amount > 0) {
397 			_manageDevShare(amount);
398 		}
399 	}
400 
401 	function _realise(address account, Stake storage position) private returns (uint256) {
402 		// Calculate accrued unclaimed reward.
403 		uint88 amount = uint88(_earnt(position, false));
404 		if (amount == 0) {
405 			return 0;
406 		}
407 		uint88 exclude = uint88(_earnt(position, true));
408 		unchecked {
409 			position.totalClaimed += amount;
410 			position.totalExcluded += exclude;
411 			_revenueSharePaid += amount;
412 		}
413 
414 		if (!_sendEther(account, amount)) {
415 			revert CouldNotSendEther();
416 		}
417 
418 		emit Realised(account, amount);
419 
420 		return amount;
421 	}
422 
423 	function _earnt(Stake storage position, bool round) private view returns (uint256) {
424 		uint256 accountTotalRewards = _getCumulativeRewards(position.amount, round);
425 		uint256 accountTotalExcluded = position.totalExcluded;
426 		if (accountTotalRewards <= accountTotalExcluded) {
427 			return 0;
428 		}
429 
430 		return accountTotalRewards - accountTotalExcluded;
431 	}
432 
433 	/**
434 	 * @dev Rescue wrongly sent ERC20 tokens.
435 	 * @notice The staking token may never be taken out unless it's through unstaking.
436 	 */
437 	function rescueToken(address token) external authorized {
438 		if (token == prodigyToken) {
439 			revert StakingTokenRescue();
440 		}
441 		IERC20 t = IERC20(token);
442 		t.transfer(msg.sender, t.balanceOf(address(this)));
443 	}
444 
445 	/**
446 	 * @dev Recover any non staked PRO tokens sent directly to contract.
447 	 */
448 	function rescueNonStakingProdigy() external authorized {
449 		IERC20 pro = IERC20(prodigyToken);
450 		uint256 available = pro.balanceOf(address(this)) - _totalStaked;
451 		if (available == 0) {
452 			revert ZeroAmount();
453 		}
454 		pro.transfer(msg.sender, available);
455 	}
456 
457 	/**
458 	 * @dev Get currently configured distribution of revenue.
459 	 */
460 	function getRevenueShareSettings() external view returns (uint16 devRevenue, uint16 sharedRevenue, uint16 denominator) {
461 		sharedRevenue = _sharedRevenue;
462 		devRevenue = _revenueDenominator - sharedRevenue;
463 		denominator = _revenueDenominator;
464 	}
465 
466 	/**
467 	 * @dev Total ether already claimed by participants of revenue share.
468 	 */
469 	function totalRevenueClaimed() external view returns (uint256) {
470 		return _revenueSharePaid;
471 	}
472 
473 	/**
474 	 * @dev Total amount of revenue share ether both claimed and to be claimed.
475 	 */
476 	function getTotalRevenue() external view returns (uint256) {
477 		return _revenueShareEther;
478 	}
479 
480 	/**
481 	 * @dev Ether destined for development costs that hasn't been sent yet.
482 	 */
483 	function pendingDevEther() external view returns (uint256) {
484 		return _devOwedEther;
485 	}
486 
487 	/**
488 	 * @dev Total amount of tokens participating in revenue share.
489 	 */
490 	function totalPosition() external view returns (uint256) {
491 		return _totalStaked;
492 	}
493 
494 	function setRevenueShareConfig(uint16 shared, uint16 denominator) external authorized {
495 		// Denominator can never be zero or it would cause reverts.
496 		if (denominator == 0) {
497 			revert ZeroAmount();
498 		}
499 		_sharedRevenue = shared;
500 		_revenueDenominator = denominator;
501 	}
502 
503 	function setDevReceiver(address dev) external authorized {
504 		devFeeReceiver = dev;
505 	}
506 
507 	function setMinStake(uint256 min) external authorized {
508 		_minStake = min;
509 	}
510 
511 	function setMinPayout(uint32 min) external authorized {
512 		_minPayout = min;
513 	}
514 
515 	function setRouter(address r) external authorized {
516 		_router = r;
517 	}
518 
519 	function setIsOpen(bool isIt) external authorized {
520 		open = isIt;
521 	}
522 
523 	/**
524 	 * @dev Two-step migration that gives a week lock before assets can be transferred to a new contract.
525 	 */
526 	function startTwoStepMigration(address migrateTo) external authorized {
527 		if (migrating || migrateTo == address(0)) {
528 			revert CannotMigrate();
529 		}
530 		open = false;
531 		migrating = true;
532 		migrationStarts = uint32(block.timestamp + migrationLockTime);
533 		migratingTo = migrateTo;
534 	}
535 
536 	function finaliseTwoStepMigration() external authorized {
537 		address receiver = migratingTo;
538 		if (!migrating || receiver == address(0)) {
539 			revert CannotMigrate();
540 		}
541 		if (block.timestamp < migrationStarts) {
542 			revert FinaliseTooEarly();
543 		}
544 		
545 		migratingTo = address(0);
546 		migrating = false;
547 		migrationStarts = 0;
548 
549 		IERC20 token = IERC20(prodigyToken);
550 		token.transfer(receiver, token.balanceOf(address(this)));
551 
552 		if (!_sendEther(receiver, address(this).balance)) {
553 			revert CouldNotSendEther();
554 		}
555 	}
556 
557 	function cancelMigration() external authorized {
558 		migrating = false;
559 		migrationStarts = 0;
560 		migratingTo = address(0);
561 	}
562 
563 	function getMinStake() external view returns (uint256) {
564 		return _minStake;
565 	}
566 
567 	function getMinPayout() external view returns (uint256) {
568 		return _minPayout;
569 	}
570 }