1 /**
2  *Submitted for verification at BscScan.com on 2021-10-30
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13 	/**
14 	 * @dev Returns the amount of tokens in existence.
15 	 */
16 	function totalSupply() external view returns (uint256);
17 
18 	/**
19 	 * @dev Returns the amount of tokens owned by `account`.
20 	 */
21 	function balanceOf(address account) external view returns (uint256);
22 
23 	/**
24 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
25 	 *
26 	 * Returns a boolean value indicating whether the operation succeeded.
27 	 *
28 	 * Emits a {Transfer} event.
29 	 */
30 	function transfer(address recipient, uint256 amount) external returns (bool);
31 
32 	/**
33 	 * @dev Returns the remaining number of tokens that `spender` will be
34 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
35 	 * zero by default.
36 	 *
37 	 * This value changes when {approve} or {transferFrom} are called.
38 	 */
39 	function allowance(address owner, address spender) external view returns (uint256);
40 
41 	/**
42 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43 	 *
44 	 * Returns a boolean value indicating whether the operation succeeded.
45 	 *
46 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
47 	 * that someone may use both the old and the new allowance by unfortunate
48 	 * transaction ordering. One possible solution to mitigate this race
49 	 * condition is to first reduce the spender's allowance to 0 and set the
50 	 * desired value afterwards:
51 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52 	 *
53 	 * Emits an {Approval} event.
54 	 */
55 	function approve(address spender, uint256 amount) external returns (bool);
56 
57 	/**
58 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
59 	 * allowance mechanism. `amount` is then deducted from the caller's
60 	 * allowance.
61 	 *
62 	 * Returns a boolean value indicating whether the operation succeeded.
63 	 *
64 	 * Emits a {Transfer} event.
65 	 */
66 	function transferFrom(
67 		address sender,
68 		address recipient,
69 		uint256 amount
70 	) external returns (bool);
71 
72 	/**
73 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
74 	 * another (`to`).
75 	 *
76 	 * Note that `value` may be zero.
77 	 */
78 	event Transfer(address indexed from, address indexed to, uint256 value);
79 
80 	/**
81 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82 	 * a call to {approve}. `value` is the new allowance.
83 	 */
84 	event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
89 
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Collection of functions related to the address type
95  */
96 library Address {
97 	/**
98 	 * @dev Returns true if `account` is a contract.
99 	 *
100 	 * [IMPORTANT]
101 	 * ====
102 	 * It is unsafe to assume that an address for which this function returns
103 	 * false is an externally-owned account (EOA) and not a contract.
104 	 *
105 	 * Among others, `isContract` will return false for the following
106 	 * types of addresses:
107 	 *
108 	 *  - an externally-owned account
109 	 *  - a contract in construction
110 	 *  - an address where a contract will be created
111 	 *  - an address where a contract lived, but was destroyed
112 	 * ====
113 	 */
114 	function isContract(address account) internal view returns (bool) {
115 		// This method relies on extcodesize, which returns 0 for contracts in
116 		// construction, since the code is only stored at the end of the
117 		// constructor execution.
118 
119 		uint256 size;
120 		assembly {
121 			size := extcodesize(account)
122 		}
123 		return size > 0;
124 	}
125 
126 	/**
127 	 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128 	 * `recipient`, forwarding all available gas and reverting on errors.
129 	 *
130 	 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131 	 * of certain opcodes, possibly making contracts go over the 2300 gas limit
132 	 * imposed by `transfer`, making them unable to receive funds via
133 	 * `transfer`. {sendValue} removes this limitation.
134 	 *
135 	 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136 	 *
137 	 * IMPORTANT: because control is transferred to `recipient`, care must be
138 	 * taken to not create reentrancy vulnerabilities. Consider using
139 	 * {ReentrancyGuard} or the
140 	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141 	 */
142 	function sendValue(address payable recipient, uint256 amount) internal {
143 		require(address(this).balance >= amount, "Address: insufficient balance");
144 
145 		(bool success, ) = recipient.call{value: amount}("");
146 		require(success, "Address: unable to send value, recipient may have reverted");
147 	}
148 
149 	/**
150 	 * @dev Performs a Solidity function call using a low level `call`. A
151 	 * plain `call` is an unsafe replacement for a function call: use this
152 	 * function instead.
153 	 *
154 	 * If `target` reverts with a revert reason, it is bubbled up by this
155 	 * function (like regular Solidity function calls).
156 	 *
157 	 * Returns the raw returned data. To convert to the expected return value,
158 	 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159 	 *
160 	 * Requirements:
161 	 *
162 	 * - `target` must be a contract.
163 	 * - calling `target` with `data` must not revert.
164 	 *
165 	 * _Available since v3.1._
166 	 */
167 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168 		return functionCall(target, data, "Address: low-level call failed");
169 	}
170 
171 	/**
172 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173 	 * `errorMessage` as a fallback revert reason when `target` reverts.
174 	 *
175 	 * _Available since v3.1._
176 	 */
177 	function functionCall(
178 		address target,
179 		bytes memory data,
180 		string memory errorMessage
181 	) internal returns (bytes memory) {
182 		return functionCallWithValue(target, data, 0, errorMessage);
183 	}
184 
185 	/**
186 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187 	 * but also transferring `value` wei to `target`.
188 	 *
189 	 * Requirements:
190 	 *
191 	 * - the calling contract must have an ETH balance of at least `value`.
192 	 * - the called Solidity function must be `payable`.
193 	 *
194 	 * _Available since v3.1._
195 	 */
196 	function functionCallWithValue(
197 		address target,
198 		bytes memory data,
199 		uint256 value
200 	) internal returns (bytes memory) {
201 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202 	}
203 
204 	/**
205 	 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206 	 * with `errorMessage` as a fallback revert reason when `target` reverts.
207 	 *
208 	 * _Available since v3.1._
209 	 */
210 	function functionCallWithValue(
211 		address target,
212 		bytes memory data,
213 		uint256 value,
214 		string memory errorMessage
215 	) internal returns (bytes memory) {
216 		require(address(this).balance >= value, "Address: insufficient balance for call");
217 		require(isContract(target), "Address: call to non-contract");
218 
219 		(bool success, bytes memory returndata) = target.call{value: value}(data);
220 		return verifyCallResult(success, returndata, errorMessage);
221 	}
222 
223 	/**
224 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225 	 * but performing a static call.
226 	 *
227 	 * _Available since v3.3._
228 	 */
229 	function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
230 		return functionStaticCall(target, data, "Address: low-level static call failed");
231 	}
232 
233 	/**
234 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235 	 * but performing a static call.
236 	 *
237 	 * _Available since v3.3._
238 	 */
239 	function functionStaticCall(
240 		address target,
241 		bytes memory data,
242 		string memory errorMessage
243 	) internal view returns (bytes memory) {
244 		require(isContract(target), "Address: static call to non-contract");
245 
246 		(bool success, bytes memory returndata) = target.staticcall(data);
247 		return verifyCallResult(success, returndata, errorMessage);
248 	}
249 
250 	/**
251 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252 	 * but performing a delegate call.
253 	 *
254 	 * _Available since v3.4._
255 	 */
256 	function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
257 		return functionDelegateCall(target, data, "Address: low-level delegate call failed");
258 	}
259 
260 	/**
261 	 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262 	 * but performing a delegate call.
263 	 *
264 	 * _Available since v3.4._
265 	 */
266 	function functionDelegateCall(
267 		address target,
268 		bytes memory data,
269 		string memory errorMessage
270 	) internal returns (bytes memory) {
271 		require(isContract(target), "Address: delegate call to non-contract");
272 
273 		(bool success, bytes memory returndata) = target.delegatecall(data);
274 		return verifyCallResult(success, returndata, errorMessage);
275 	}
276 
277 	/**
278 	 * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279 	 * revert reason using the provided one.
280 	 *
281 	 * _Available since v4.3._
282 	 */
283 	function verifyCallResult(
284 		bool success,
285 		bytes memory returndata,
286 		string memory errorMessage
287 	) internal pure returns (bytes memory) {
288 		if (success) {
289 			return returndata;
290 		} else {
291 			// Look for revert reason and bubble it up if present
292 			if (returndata.length > 0) {
293 				// The easiest way to bubble the revert reason is using memory via assembly
294 
295 				assembly {
296 					let returndata_size := mload(returndata)
297 					revert(add(32, returndata), returndata_size)
298 				}
299 			} else {
300 				revert(errorMessage);
301 			}
302 		}
303 	}
304 }
305 
306 
307 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.3.2
308 
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @title SafeERC20
315  * @dev Wrappers around ERC20 operations that throw on failure (when the token
316  * contract returns false). Tokens that return no value (and instead revert or
317  * throw on failure) are also supported, non-reverting calls are assumed to be
318  * successful.
319  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
320  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
321  */
322 library SafeERC20 {
323 	using Address for address;
324 
325 	function safeTransfer(
326 		IERC20 token,
327 		address to,
328 		uint256 value
329 	) internal {
330 		_callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
331 	}
332 
333 	function safeTransferFrom(
334 		IERC20 token,
335 		address from,
336 		address to,
337 		uint256 value
338 	) internal {
339 		_callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
340 	}
341 
342 	/**
343 	 * @dev Deprecated. This function has issues similar to the ones found in
344 	 * {IERC20-approve}, and its usage is discouraged.
345 	 *
346 	 * Whenever possible, use {safeIncreaseAllowance} and
347 	 * {safeDecreaseAllowance} instead.
348 	 */
349 	function safeApprove(
350 		IERC20 token,
351 		address spender,
352 		uint256 value
353 	) internal {
354 		// safeApprove should only be called when setting an initial allowance,
355 		// or when resetting it to zero. To increase and decrease it, use
356 		// 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
357 		require(
358 			(value == 0) || (token.allowance(address(this), spender) == 0),
359 			"SafeERC20: approve from non-zero to non-zero allowance"
360 		);
361 		_callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
362 	}
363 
364 	function safeIncreaseAllowance(
365 		IERC20 token,
366 		address spender,
367 		uint256 value
368 	) internal {
369 		uint256 newAllowance = token.allowance(address(this), spender) + value;
370 		_callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371 	}
372 
373 	function safeDecreaseAllowance(
374 		IERC20 token,
375 		address spender,
376 		uint256 value
377 	) internal {
378 		unchecked {
379 			uint256 oldAllowance = token.allowance(address(this), spender);
380 			require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
381 			uint256 newAllowance = oldAllowance - value;
382 			_callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
383 		}
384 	}
385 
386 	/**
387 	 * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
388 	 * on the return value: the return value is optional (but if data is returned, it must not be false).
389 	 * @param token The token targeted by the call.
390 	 * @param data The call data (encoded using abi.encode or one of its variants).
391 	 */
392 	function _callOptionalReturn(IERC20 token, bytes memory data) private {
393 		// We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
394 		// we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
395 		// the target address contains contract code and also asserts for success in the low-level call.
396 
397 		bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
398 		if (returndata.length > 0) {
399 			// Return data is optional
400 			require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
401 		}
402 	}
403 }
404 
405 
406 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
407 
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @dev Provides information about the current execution context, including the
413  * sender of the transaction and its data. While these are generally available
414  * via msg.sender and msg.data, they should not be accessed in such a direct
415  * manner, since when dealing with meta-transactions the account sending and
416  * paying for execution may not be the actual sender (as far as an application
417  * is concerned).
418  *
419  * This contract is only required for intermediate, library-like contracts.
420  */
421 abstract contract Context {
422 	function _msgSender() internal view virtual returns (address) {
423 		return msg.sender;
424 	}
425 
426 	function _msgData() internal view virtual returns (bytes calldata) {
427 		return msg.data;
428 	}
429 }
430 
431 
432 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
433 
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Contract module which provides a basic access control mechanism, where
439  * there is an account (an owner) that can be granted exclusive access to
440  * specific functions.
441  *
442  * By default, the owner account will be the one that deploys the contract. This
443  * can later be changed with {transferOwnership}.
444  *
445  * This module is used through inheritance. It will make available the modifier
446  * `onlyOwner`, which can be applied to your functions to restrict their use to
447  * the owner.
448  */
449 abstract contract Ownable is Context {
450 	address private _owner;
451 
452 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
453 
454 	/**
455 	 * @dev Initializes the contract setting the deployer as the initial owner.
456 	 */
457 	constructor() {
458 		_setOwner(_msgSender());
459 	}
460 
461 	/**
462 	 * @dev Returns the address of the current owner.
463 	 */
464 	function owner() public view virtual returns (address) {
465 		return _owner;
466 	}
467 
468 	/**
469 	 * @dev Throws if called by any account other than the owner.
470 	 */
471 	modifier onlyOwner() {
472 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
473 		_;
474 	}
475 
476 	/**
477 	 * @dev Leaves the contract without owner. It will not be possible to call
478 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
479 	 *
480 	 * NOTE: Renouncing ownership will leave the contract without an owner,
481 	 * thereby removing any functionality that is only available to the owner.
482 	 */
483 	function renounceOwnership() public virtual onlyOwner {
484 		_setOwner(address(0));
485 	}
486 
487 	/**
488 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
489 	 * Can only be called by the current owner.
490 	 */
491 	function transferOwnership(address newOwner) public virtual onlyOwner {
492 		require(newOwner != address(0), "Ownable: new owner is the zero address");
493 		_setOwner(newOwner);
494 	}
495 
496 	function _setOwner(address newOwner) private {
497 		address oldOwner = _owner;
498 		_owner = newOwner;
499 		emit OwnershipTransferred(oldOwner, newOwner);
500 	}
501 }
502 
503 
504 // File @openzeppelin/contracts/proxy/utils/Initializable.sol@v4.3.2
505 
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
511  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
512  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
513  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
514  *
515  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
516  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
517  *
518  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
519  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
520  */
521 abstract contract Initializable {
522 	/**
523 	 * @dev Indicates that the contract has been initialized.
524 	 */
525 	bool private _initialized;
526 
527 	/**
528 	 * @dev Indicates that the contract is in the process of being initialized.
529 	 */
530 	bool private _initializing;
531 
532 	/**
533 	 * @dev Modifier to protect an initializer function from being invoked twice.
534 	 */
535 	modifier initializer() {
536 		require(_initializing || !_initialized, "Initializable: contract is already initialized");
537 
538 		bool isTopLevelCall = !_initializing;
539 		if (isTopLevelCall) {
540 			_initializing = true;
541 			_initialized = true;
542 		}
543 
544 		_;
545 
546 		if (isTopLevelCall) {
547 			_initializing = false;
548 		}
549 	}
550 }
551 
552 
553 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
554 
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev Contract module that helps prevent reentrant calls to a function.
560  *
561  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
562  * available, which can be applied to functions to make sure there are no nested
563  * (reentrant) calls to them.
564  *
565  * Note that because there is a single `nonReentrant` guard, functions marked as
566  * `nonReentrant` may not call one another. This can be worked around by making
567  * those functions `private`, and then adding `external` `nonReentrant` entry
568  * points to them.
569  *
570  * TIP: If you would like to learn more about reentrancy and alternative ways
571  * to protect against it, check out our blog post
572  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
573  */
574 abstract contract ReentrancyGuard {
575 	// Booleans are more expensive than uint256 or any type that takes up a full
576 	// word because each write operation emits an extra SLOAD to first read the
577 	// slot's contents, replace the bits taken up by the boolean, and then write
578 	// back. This is the compiler's defense against contract upgrades and
579 	// pointer aliasing, and it cannot be disabled.
580 
581 	// The values being non-zero value makes deployment a bit more expensive,
582 	// but in exchange the refund on every call to nonReentrant will be lower in
583 	// amount. Since refunds are capped to a percentage of the total
584 	// transaction's gas, it is best to keep them low in cases like this one, to
585 	// increase the likelihood of the full refund coming into effect.
586 	uint256 private constant _NOT_ENTERED = 1;
587 	uint256 private constant _ENTERED = 2;
588 
589 	uint256 private _status;
590 
591 	constructor() {
592 		_status = _NOT_ENTERED;
593 	}
594 
595 	/**
596 	 * @dev Prevents a contract from calling itself, directly or indirectly.
597 	 * Calling a `nonReentrant` function from another `nonReentrant`
598 	 * function is not supported. It is possible to prevent this from happening
599 	 * by making the `nonReentrant` function external, and make it call a
600 	 * `private` function that does the actual work.
601 	 */
602 	modifier nonReentrant() {
603 		// On the first call to nonReentrant, _notEntered will be true
604 		require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
605 
606 		// Any calls to nonReentrant after this point will fail
607 		_status = _ENTERED;
608 
609 		_;
610 
611 		// By storing the original value once again, a refund is triggered (see
612 		// https://eips.ethereum.org/EIPS/eip-2200)
613 		_status = _NOT_ENTERED;
614 	}
615 }
616 
617 
618 // File contracts/ERC20RewardStakingV4.sol
619 pragma solidity ^0.8.4;
620 
621 
622 contract ERC20RewardStakingV4 is ReentrancyGuard, Ownable, Initializable {
623 	using SafeERC20 for IERC20;
624 
625 	// Info of each user.
626 	struct UserInfo {
627 		uint256 amount;     // How many LP tokens the user has provided.
628 		uint256 rewardDebt; // Reward debt. See explanation below.
629 	}
630 
631 	// Info of each pool.
632 	struct PoolInfo {
633 		IERC20 lpToken;           // Address of LP token contract.
634 		uint256 allocPoint;       // How many allocation points assigned to this pool. Rewards to distribute per block.
635 		uint256 lastRewardBlock;  // Last block number that Rewards distribution occurs.
636 		uint256 accRewardTokenPerShare; // Accumulated Rewards per share, times 1e30. See below.
637 	}
638 
639 	// The stake token
640 	IERC20 public STAKE_TOKEN;
641 	// The reward token
642 	IERC20 public REWARD_TOKEN;
643 
644 	// Reward tokens created per block.
645 	uint256 public rewardPerBlock;
646 
647 	// Keep track of number of tokens staked in case the contract earns reflect fees
648 	uint256 public totalStaked = 0;
649 	// Keep track of number of reward tokens paid to find remaining reward balance
650 	uint256 public totalRewardsPaid = 0;
651 	// Keep track of number of reward tokens paid to find remaining reward balance
652 	uint256 public totalRewardsAllocated = 0;
653 
654 	// Info of each pool.
655 	PoolInfo public poolInfo;
656 	// Info of each user that stakes LP tokens.
657 	mapping (address => UserInfo) public userInfo;
658 	// Total allocation poitns. Must be the sum of all allocation points in all pools.
659 	uint256 private totalAllocPoint = 0;
660 	// The block number when Reward mining starts.
661 	uint256 public startBlock;
662 	// The block number when mining ends.
663 	uint256 public bonusEndBlock;
664 
665 	event Deposit(address indexed user, uint256 amount);
666 	event DepositRewards(uint256 amount);
667 	event Withdraw(address indexed user, uint256 amount);
668 	event EmergencyWithdraw(address indexed user, uint256 amount);
669 	event SkimStakeTokenFees(address indexed user, uint256 amount);
670 	event LogUpdatePool(uint256 bonusEndBlock, uint256 rewardPerBlock);
671 	event EmergencyRewardWithdraw(address indexed user, uint256 amount);
672 	event EmergencySweepWithdraw(address indexed user, IERC20 indexed token, uint256 amount);
673 
674 	function initialize(
675 		IERC20 _stakeToken,
676 		IERC20 _rewardToken,
677 		uint256 _rewardPerBlock,
678 		uint256 _startBlock,
679 		uint256 _bonusEndBlock
680 	) external initializer
681 	{
682 		STAKE_TOKEN = _stakeToken;
683 		REWARD_TOKEN = _rewardToken;
684 		rewardPerBlock = _rewardPerBlock;
685 		startBlock = _startBlock;
686 		bonusEndBlock = _bonusEndBlock;
687 
688 		// staking pool
689 		poolInfo = PoolInfo({
690 			lpToken: _stakeToken,
691 			allocPoint: 1000,
692 			lastRewardBlock: startBlock,
693 			accRewardTokenPerShare: 0
694 		});
695 
696 		totalAllocPoint = 1000;
697 	}
698 
699 	// Return reward multiplier over the given _from to _to block.
700 	function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
701 		if (_to <= bonusEndBlock) {
702 			return _to - _from;
703 		} else if (_from >= bonusEndBlock) {
704 			return 0;
705 		} else {
706 			return bonusEndBlock - _from;
707 		}
708 	}
709 
710 	/// @param  _bonusEndBlock The block when rewards will end
711 	function setBonusEndBlock(uint256 _bonusEndBlock) external onlyOwner {
712 		require(_bonusEndBlock > block.number, 'new bonus end block must be greater than current');
713 		bonusEndBlock = _bonusEndBlock;
714 		emit LogUpdatePool(bonusEndBlock, rewardPerBlock);
715 	}
716 
717 	// View function to see pending Reward on frontend.
718 	function pendingReward(address _user) external view returns (uint256) {
719 		UserInfo storage user = userInfo[_user];
720 		uint256 accRewardTokenPerShare = poolInfo.accRewardTokenPerShare;
721 		if (block.number > poolInfo.lastRewardBlock && totalStaked != 0) {
722 			uint256 multiplier = getMultiplier(poolInfo.lastRewardBlock, block.number);
723 			uint256 tokenReward = multiplier * rewardPerBlock * poolInfo.allocPoint / totalAllocPoint;
724 			accRewardTokenPerShare = accRewardTokenPerShare + (tokenReward * 1e30 / totalStaked);
725 		}
726 		return user.amount * accRewardTokenPerShare / 1e30 - user.rewardDebt;
727 	}
728 
729 	// Update reward variables of the given pool to be up-to-date.
730 	function updatePool() public {
731 		if (block.number <= poolInfo.lastRewardBlock) {
732 			return;
733 		}
734 		if (totalStaked == 0) {
735 			poolInfo.lastRewardBlock = block.number;
736 			return;
737 		}
738 		uint256 multiplier = getMultiplier(poolInfo.lastRewardBlock, block.number);
739 		uint256 tokenReward = multiplier * rewardPerBlock * poolInfo.allocPoint / totalAllocPoint;
740 		totalRewardsAllocated += tokenReward;
741 		poolInfo.accRewardTokenPerShare = poolInfo.accRewardTokenPerShare + (tokenReward * 1e30 / totalStaked);
742 		poolInfo.lastRewardBlock = block.number;
743 	}
744 
745 
746 	/// Deposit staking token into the contract to earn rewards.
747 	/// @dev Since this contract needs to be supplied with rewards we are
748 	///  sending the balance of the contract if the pending rewards are higher
749 	/// @param _amount The amount of staking tokens to deposit
750 	function deposit(uint256 _amount) external nonReentrant {
751 		UserInfo storage user = userInfo[msg.sender];
752 		updatePool();
753 		if (user.amount > 0) {
754 			uint256 pending = user.amount * poolInfo.accRewardTokenPerShare / 1e30 - user.rewardDebt;
755 			if(pending > 0) {
756 				// If rewardBalance is low then revert to avoid losing the user's rewards
757 				require(rewardBalance() >= pending, "insufficient reward balance");
758 				safeTransferRewardInternal(address(msg.sender), pending);
759 			}
760 		}
761 
762 		uint256 finalDepositAmount = 0;
763 		if (_amount > 0) {
764 			uint256 preStakeBalance = STAKE_TOKEN.balanceOf(address(this));
765 			poolInfo.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
766 			finalDepositAmount = STAKE_TOKEN.balanceOf(address(this)) - preStakeBalance;
767 			user.amount = user.amount + finalDepositAmount;
768 			totalStaked = totalStaked + finalDepositAmount;
769 		}
770 		user.rewardDebt = user.amount * poolInfo.accRewardTokenPerShare / 1e30;
771 
772 		emit Deposit(msg.sender, finalDepositAmount);
773 	}
774 
775 	/// Withdraw rewards and/or staked tokens. Pass a 0 amount to withdraw only rewards
776 	/// @param _amount The amount of staking tokens to withdraw
777 	function withdraw(uint256 _amount) external nonReentrant {
778 		UserInfo storage user = userInfo[msg.sender];
779 		require(user.amount >= _amount, "withdraw: not good");
780 		updatePool();
781 		uint256 pending = user.amount * poolInfo.accRewardTokenPerShare / 1e30 - user.rewardDebt;
782 		if(pending > 0) {
783 			// If rewardBalance is low then revert to avoid losing the user's rewards
784 			require(rewardBalance() >= pending, "insufficient reward balance");
785 			safeTransferRewardInternal(address(msg.sender), pending);
786 		}
787 
788 		if(_amount > 0) {
789 			user.amount = user.amount - _amount;
790 			poolInfo.lpToken.safeTransfer(address(msg.sender), _amount);
791 			totalStaked = totalStaked - _amount;
792 		}
793 
794 		user.rewardDebt = user.amount * poolInfo.accRewardTokenPerShare / 1e30;
795 
796 		emit Withdraw(msg.sender, _amount);
797 	}
798 
799 	/// Obtain the reward balance of this contract
800 	/// @return wei balace of conract
801 	function rewardBalance() public view returns (uint256) {
802 		uint256 balance = REWARD_TOKEN.balanceOf(address(this));
803 		if (STAKE_TOKEN == REWARD_TOKEN) {
804 			return balance - totalStaked;
805 		}
806 		return balance;
807 	}
808 
809 	/// Get the balance of rewards that have not been harvested
810 	/// @return wei balance of rewards left to be paid
811 	function getUnharvestedRewards() public view returns (uint256) {
812 		return totalRewardsAllocated - totalRewardsPaid;
813 	}
814 
815 	// Deposit Rewards into contract
816 	function depositRewards(uint256 _amount) external {
817 		require(_amount > 0, 'Deposit value must be greater than 0.');
818 		REWARD_TOKEN.safeTransferFrom(address(msg.sender), address(this), _amount);
819 		emit DepositRewards(_amount);
820 	}
821 
822 	/// @param _to address to send reward token to
823 	/// @param _amount value of reward token to transfer
824 	function safeTransferRewardInternal(address _to, uint256 _amount) internal {
825 		totalRewardsPaid += _amount;
826 		REWARD_TOKEN.safeTransfer(_to, _amount);
827 	}
828 
829 	/// @dev Obtain the stake balance of this contract
830 	function totalStakeTokenBalance() public view returns (uint256) {
831 		if (STAKE_TOKEN == REWARD_TOKEN)
832 			return totalStaked;
833 		return STAKE_TOKEN.balanceOf(address(this));
834 	}
835 
836 	/// @dev Obtain the stake token fees (if any) earned by reflect token
837 	/// @notice If STAKE_TOKEN == REWARD_TOKEN there are no fees to skim
838 	function getStakeTokenFeeBalance() public view returns (uint256) {
839 		return totalStakeTokenBalance() - totalStaked;
840 	}
841 
842 	/* Admin Functions */
843 
844 	/// @param _rewardPerBlock The amount of reward tokens to be given per block
845 	function setRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
846 		rewardPerBlock = _rewardPerBlock;
847 		emit LogUpdatePool(bonusEndBlock, rewardPerBlock);
848 	}
849 
850 		/// @dev Remove excess stake tokens earned by reflect fees
851 	function skimStakeTokenFees(address _to) external onlyOwner {
852 		uint256 stakeTokenFeeBalance = getStakeTokenFeeBalance();
853 		STAKE_TOKEN.safeTransfer(_to, stakeTokenFeeBalance);
854 		emit SkimStakeTokenFees(_to, stakeTokenFeeBalance);
855 	}
856 
857 	/* Emergency Functions */
858 
859 	// Withdraw without caring about rewards. EMERGENCY ONLY.
860 	function emergencyWithdraw() external nonReentrant {
861 		UserInfo storage user = userInfo[msg.sender];
862 		poolInfo.lpToken.safeTransfer(address(msg.sender), user.amount);
863 		totalStaked = totalStaked - user.amount;
864 		user.amount = 0;
865 		user.rewardDebt = 0;
866 		emit EmergencyWithdraw(msg.sender, user.amount);
867 	}
868 
869 	// Withdraw reward. EMERGENCY ONLY.
870 	function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
871 		require(_amount <= rewardBalance(), 'not enough rewards');
872 		// Withdraw rewards
873 		REWARD_TOKEN.safeTransfer(msg.sender, _amount);
874 		emit EmergencyRewardWithdraw(msg.sender, _amount);
875 	}
876 
877 	/// @notice A public function to sweep accidental ERC20 transfers to this contract.
878 	///   Tokens are sent to owner
879 	/// @param token The address of the ERC20 token to sweep
880 	function sweepToken(IERC20 token) external onlyOwner {
881 		require(address(token) != address(STAKE_TOKEN), "can not sweep stake token");
882 		require(address(token) != address(REWARD_TOKEN), "can not sweep reward token");
883 		uint256 balance = token.balanceOf(address(this));
884 		token.safeTransfer(msg.sender, balance);
885 		emit EmergencySweepWithdraw(msg.sender, token, balance);
886 	}
887 
888 }