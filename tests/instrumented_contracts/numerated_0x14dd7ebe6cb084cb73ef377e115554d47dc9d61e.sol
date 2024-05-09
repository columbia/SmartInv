1 /**
2  *Submitted for verification at EtherScan.com on 2021-04-28
3 */
4 
5 /**
6  *
7  *
8 
9    "$APES to the moon" -Elon Musk
10 
11    Contract features:
12    7% fee auto added to the liquidity pool and locked forever
13    2% fee auto distributed to all holders
14    1% fee sent to charity wallet
15 
16  */
17 
18 pragma solidity ^0.6.12;
19 // SPDX-License-Identifier: Unlicensed
20 interface IERC20 {
21 	
22 	function totalSupply() external view returns (uint256);
23 	
24 	/**
25 	 * @dev Returns the amount of tokens owned by `account`.
26 	 */
27 	function balanceOf(address account) external view returns (uint256);
28 	
29 	/**
30 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
31 	 *
32 	 * Returns a boolean value indicating whether the operation succeeded.
33 	 *
34 	 * Emits a {Transfer} event.
35 	 */
36 	function transfer(address recipient, uint256 amount) external returns (bool);
37 	
38 	/**
39 	 * @dev Returns the remaining number of tokens that `spender` will be
40 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
41 	 * zero by default.
42 	 *
43 	 * This value changes when {approve} or {transferFrom} are called.
44 	 */
45 	function allowance(address owner, address spender) external view returns (uint256);
46 	
47 	/**
48 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49 	 *
50 	 * Returns a boolean value indicating whether the operation succeeded.
51 	 *
52 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
53 	 * that someone may use both the old and the new allowance by unfortunate
54 	 * transaction ordering. One possible solution to mitigate this race
55 	 * condition is to first reduce the spender's allowance to 0 and set the
56 	 * desired value afterwards:
57 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58 	 *
59 	 * Emits an {Approval} event.
60 	 */
61 	function approve(address spender, uint256 amount) external returns (bool);
62 	
63 	/**
64 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
65 	 * allowance mechanism. `amount` is then deducted from the caller's
66 	 * allowance.
67 	 *
68 	 * Returns a boolean value indicating whether the operation succeeded.
69 	 *
70 	 * Emits a {Transfer} event.
71 	 */
72 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 	
74 	/**
75 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
76 	 * another (`to`).
77 	 *
78 	 * Note that `value` may be zero.
79 	 */
80 	event Transfer(address indexed from, address indexed to, uint256 value);
81 	
82 	/**
83 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84 	 * a call to {approve}. `value` is the new allowance.
85 	 */
86 	event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 
105 library SafeMath {
106 	/**
107 	 * @dev Returns the addition of two unsigned integers, reverting on
108 	 * overflow.
109 	 *
110 	 * Counterpart to Solidity's `+` operator.
111 	 *
112 	 * Requirements:
113 	 *
114 	 * - Addition cannot overflow.
115 	 */
116 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
117 		uint256 c = a + b;
118 		require(c >= a, "SafeMath: addition overflow");
119 		
120 		return c;
121 	}
122 	
123 	/**
124 	 * @dev Returns the subtraction of two unsigned integers, reverting on
125 	 * overflow (when the result is negative).
126 	 *
127 	 * Counterpart to Solidity's `-` operator.
128 	 *
129 	 * Requirements:
130 	 *
131 	 * - Subtraction cannot overflow.
132 	 */
133 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134 		return sub(a, b, "SafeMath: subtraction overflow");
135 	}
136 	
137 	/**
138 	 * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139 	 * overflow (when the result is negative).
140 	 *
141 	 * Counterpart to Solidity's `-` operator.
142 	 *
143 	 * Requirements:
144 	 *
145 	 * - Subtraction cannot overflow.
146 	 */
147 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148 		require(b <= a, errorMessage);
149 		uint256 c = a - b;
150 		
151 		return c;
152 	}
153 	
154 	/**
155 	 * @dev Returns the multiplication of two unsigned integers, reverting on
156 	 * overflow.
157 	 *
158 	 * Counterpart to Solidity's `*` operator.
159 	 *
160 	 * Requirements:
161 	 *
162 	 * - Multiplication cannot overflow.
163 	 */
164 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166 		// benefit is lost if 'b' is also tested.
167 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168 		if (a == 0) {
169 			return 0;
170 		}
171 		
172 		uint256 c = a * b;
173 		require(c / a == b, "SafeMath: multiplication overflow");
174 		
175 		return c;
176 	}
177 	
178 	/**
179 	 * @dev Returns the integer division of two unsigned integers. Reverts on
180 	 * division by zero. The result is rounded towards zero.
181 	 *
182 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
183 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
184 	 * uses an invalid opcode to revert (consuming all remaining gas).
185 	 *
186 	 * Requirements:
187 	 *
188 	 * - The divisor cannot be zero.
189 	 */
190 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
191 		return div(a, b, "SafeMath: division by zero");
192 	}
193 	
194 	/**
195 	 * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196 	 * division by zero. The result is rounded towards zero.
197 	 *
198 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
199 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
200 	 * uses an invalid opcode to revert (consuming all remaining gas).
201 	 *
202 	 * Requirements:
203 	 *
204 	 * - The divisor cannot be zero.
205 	 */
206 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207 		require(b > 0, errorMessage);
208 		uint256 c = a / b;
209 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 		
211 		return c;
212 	}
213 	
214 	/**
215 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216 	 * Reverts when dividing by zero.
217 	 *
218 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
219 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
220 	 * invalid opcode to revert (consuming all remaining gas).
221 	 *
222 	 * Requirements:
223 	 *
224 	 * - The divisor cannot be zero.
225 	 */
226 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227 		return mod(a, b, "SafeMath: modulo by zero");
228 	}
229 	
230 	/**
231 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232 	 * Reverts with custom message when dividing by zero.
233 	 *
234 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
235 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
236 	 * invalid opcode to revert (consuming all remaining gas).
237 	 *
238 	 * Requirements:
239 	 *
240 	 * - The divisor cannot be zero.
241 	 */
242 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243 		require(b != 0, errorMessage);
244 		return a % b;
245 	}
246 }
247 
248 abstract contract Context {
249 	function _msgSender() internal view virtual returns (address payable) {
250 		return msg.sender;
251 	}
252 	
253 	function _msgData() internal view virtual returns (bytes memory) {
254 		this;
255 		// silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256 		return msg.data;
257 	}
258 }
259 
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265 	/**
266 	 * @dev Returns true if `account` is a contract.
267 	 *
268 	 * [IMPORTANT]
269 	 * ====
270 	 * It is unsafe to assume that an address for which this function returns
271 	 * false is an externally-owned account (EOA) and not a contract.
272 	 *
273 	 * Among others, `isContract` will return false for the following
274 	 * types of addresses:
275 	 *
276 	 *  - an externally-owned account
277 	 *  - a contract in construction
278 	 *  - an address where a contract will be created
279 	 *  - an address where a contract lived, but was destroyed
280 	 * ====
281 	 */
282 	function isContract(address account) internal view returns (bool) {
283 		// According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284 		// and  is returned
285 		// for accounts without code, i.e. `keccak256('')`
286 		bytes32 codehash;
287 		bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288 		// solhint-disable-next-line no-inline-assembly
289 		assembly {codehash := extcodehash(account)}
290 		return (codehash != accountHash && codehash != 0x0);
291 	}
292 	
293 	/**
294 	 * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295 	 * `recipient`, forwarding all available gas and reverting on errors.
296 	 *
297 	 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298 	 * of certain opcodes, possibly making contracts go over the 2300 gas limit
299 	 * imposed by `transfer`, making them unable to receive funds via
300 	 * `transfer`. {sendValue} removes this limitation.
301 	 *
302 	 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303 	 *
304 	 * IMPORTANT: because control is transferred to `recipient`, care must be
305 	 * taken to not create reentrancy vulnerabilities. Consider using
306 	 * {ReentrancyGuard} or the
307 	 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308 	 */
309 	function sendValue(address payable recipient, uint256 amount) internal {
310 		require(address(this).balance >= amount, "Address: insufficient balance");
311 		
312 		// solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313 		(bool success,) = recipient.call{value : amount}("");
314 		require(success, "Address: unable to send value, recipient may have reverted");
315 	}
316 	
317 	/**
318 	 * @dev Performs a Solidity function call using a low level `call`. A
319 	 * plain`call` is an unsafe replacement for a function call: use this
320 	 * function instead.
321 	 *
322 	 * If `target` reverts with a revert reason, it is bubbled up by this
323 	 * function (like regular Solidity function calls).
324 	 *
325 	 * Returns the raw returned data. To convert to the expected return value,
326 	 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327 	 *
328 	 * Requirements:
329 	 *
330 	 * - `target` must be a contract.
331 	 * - calling `target` with `data` must not revert.
332 	 *
333 	 * _Available since v3.1._
334 	 */
335 	function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336 		return functionCall(target, data, "Address: low-level call failed");
337 	}
338 	
339 	/**
340 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341 	 * `errorMessage` as a fallback revert reason when `target` reverts.
342 	 *
343 	 * _Available since v3.1._
344 	 */
345 	function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346 		return _functionCallWithValue(target, data, 0, errorMessage);
347 	}
348 	
349 	/**
350 	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351 	 * but also transferring `value` wei to `target`.
352 	 *
353 	 * Requirements:
354 	 *
355 	 * - the calling contract must have an ETH balance of at least `value`.
356 	 * - the called Solidity function must be `payable`.
357 	 *
358 	 * _Available since v3.1._
359 	 */
360 	function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362 	}
363 	
364 	/**
365 	 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366 	 * with `errorMessage` as a fallback revert reason when `target` reverts.
367 	 *
368 	 * _Available since v3.1._
369 	 */
370 	function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371 		require(address(this).balance >= value, "Address: insufficient balance for call");
372 		return _functionCallWithValue(target, data, value, errorMessage);
373 	}
374 	
375 	function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376 		require(isContract(target), "Address: call to non-contract");
377 		
378 		// solhint-disable-next-line avoid-low-level-calls
379 		(bool success, bytes memory returndata) = target.call{value : weiValue}(data);
380 		if (success) {
381 			return returndata;
382 		} else {
383 			// Look for revert reason and bubble it up if present
384 			if (returndata.length > 0) {
385 				// The easiest way to bubble the revert reason is using memory via assembly
386 				
387 				// solhint-disable-next-line no-inline-assembly
388 				assembly {
389 					let returndata_size := mload(returndata)
390 					revert(add(32, returndata), returndata_size)
391 				}
392 			} else {
393 				revert(errorMessage);
394 			}
395 		}
396 	}
397 }
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * By default, the owner account will be the one that deploys the contract. This
405  * can later be changed with {transferOwnership}.
406  *
407  * This module is used through inheritance. It will make available the modifier
408  * `onlyOwner`, which can be applied to your functions to restrict their use to
409  * the owner.
410  */
411 contract Ownable is Context {
412 	address private _owner;
413 	address private _previousOwner;
414 	uint256 private _lockTime;
415 	
416 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
417 	
418 	/**
419 	 * @dev Initializes the contract setting the deployer as the initial owner.
420 	 */
421 	constructor () internal {
422 		address msgSender = _msgSender();
423 		_owner = msgSender;
424 		emit OwnershipTransferred(address(0), msgSender);
425 	}
426 	
427 	/**
428 	 * @dev Returns the address of the current owner.
429 	 */
430 	function owner() public view returns (address) {
431 		return _owner;
432 	}
433 	
434 	/**
435 	 * @dev Throws if called by any account other than the owner.
436 	 */
437 	modifier onlyOwner() {
438 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
439 		_;
440 	}
441 	
442 	/**
443 	* @dev Leaves the contract without owner. It will not be possible to call
444 	* `onlyOwner` functions anymore. Can only be called by the current owner.
445 	*
446 	* NOTE: Renouncing ownership will leave the contract without an owner,
447 	* thereby removing any functionality that is only available to the owner.
448 	*/
449 	function renounceOwnership() public virtual onlyOwner {
450 		emit OwnershipTransferred(_owner, address(0));
451 		_owner = address(0);
452 	}
453 	
454 	/**
455 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
456 	 * Can only be called by the current owner.
457 	 */
458 	function transferOwnership(address newOwner) public virtual onlyOwner {
459 		require(newOwner != address(0), "Ownable: new owner is the zero address");
460 		emit OwnershipTransferred(_owner, newOwner);
461 		_owner = newOwner;
462 	}
463 	
464 	function geUnlockTime() public view returns (uint256) {
465 		return _lockTime;
466 	}
467 	
468 	//Locks the contract for owner for the amount of time provided
469 	function lock(uint256 time) public virtual onlyOwner {
470 		_previousOwner = _owner;
471 		_owner = address(0);
472 		_lockTime = now + time;
473 		emit OwnershipTransferred(_owner, address(0));
474 	}
475 	
476 	//Unlocks the contract for owner when _lockTime is exceeds
477 	function unlock() public virtual {
478 		require(_previousOwner == msg.sender, "You don't have permission to unlock");
479 		require(now > _lockTime, "Contract is locked until 7 days");
480 		emit OwnershipTransferred(_owner, _previousOwner);
481 		_owner = _previousOwner;
482 	}
483 }
484 
485 // pragma solidity >=0.5.0;
486 
487 interface IUniswapV2Factory {
488 	event PairCreated(address indexed token0, address indexed token1, address pair, uint);
489 	
490 	function feeTo() external view returns (address);
491 	
492 	function feeToSetter() external view returns (address);
493 	
494 	function getPair(address tokenA, address tokenB) external view returns (address pair);
495 	
496 	function allPairs(uint) external view returns (address pair);
497 	
498 	function allPairsLength() external view returns (uint);
499 	
500 	function createPair(address tokenA, address tokenB) external returns (address pair);
501 	
502 	function setFeeTo(address) external;
503 	
504 	function setFeeToSetter(address) external;
505 }
506 
507 
508 // pragma solidity >=0.5.0;
509 
510 interface IUniswapV2Pair {
511 	event Approval(address indexed owner, address indexed spender, uint value);
512 	event Transfer(address indexed from, address indexed to, uint value);
513 	
514 	function name() external pure returns (string memory);
515 	
516 	function symbol() external pure returns (string memory);
517 	
518 	function decimals() external pure returns (uint8);
519 	
520 	function totalSupply() external view returns (uint);
521 	
522 	function balanceOf(address owner) external view returns (uint);
523 	
524 	function allowance(address owner, address spender) external view returns (uint);
525 	
526 	function approve(address spender, uint value) external returns (bool);
527 	
528 	function transfer(address to, uint value) external returns (bool);
529 	
530 	function transferFrom(address from, address to, uint value) external returns (bool);
531 	
532 	function DOMAIN_SEPARATOR() external view returns (bytes32);
533 	
534 	function PERMIT_TYPEHASH() external pure returns (bytes32);
535 	
536 	function nonces(address owner) external view returns (uint);
537 	
538 	function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
539 	
540 	event Mint(address indexed sender, uint amount0, uint amount1);
541 	event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
542 	event Swap(
543 		address indexed sender,
544 		uint amount0In,
545 		uint amount1In,
546 		uint amount0Out,
547 		uint amount1Out,
548 		address indexed to
549 	);
550 	event Sync(uint112 reserve0, uint112 reserve1);
551 	
552 	function MINIMUM_LIQUIDITY() external pure returns (uint);
553 	
554 	function factory() external view returns (address);
555 	
556 	function token0() external view returns (address);
557 	
558 	function token1() external view returns (address);
559 	
560 	function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
561 	
562 	function price0CumulativeLast() external view returns (uint);
563 	
564 	function price1CumulativeLast() external view returns (uint);
565 	
566 	function kLast() external view returns (uint);
567 	
568 	function mint(address to) external returns (uint liquidity);
569 	
570 	function burn(address to) external returns (uint amount0, uint amount1);
571 	
572 	function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
573 	
574 	function skim(address to) external;
575 	
576 	function sync() external;
577 	
578 	function initialize(address, address) external;
579 }
580 
581 // pragma solidity >=0.6.2;
582 
583 interface IUniswapV2Router01 {
584 	function factory() external pure returns (address);
585 	
586 	function WETH() external pure returns (address);
587 	
588 	function addLiquidity(
589 		address tokenA,
590 		address tokenB,
591 		uint amountADesired,
592 		uint amountBDesired,
593 		uint amountAMin,
594 		uint amountBMin,
595 		address to,
596 		uint deadline
597 	) external returns (uint amountA, uint amountB, uint liquidity);
598 	
599 	function addLiquidityETH(
600 		address token,
601 		uint amountTokenDesired,
602 		uint amountTokenMin,
603 		uint amountETHMin,
604 		address to,
605 		uint deadline
606 	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
607 	
608 	function removeLiquidity(
609 		address tokenA,
610 		address tokenB,
611 		uint liquidity,
612 		uint amountAMin,
613 		uint amountBMin,
614 		address to,
615 		uint deadline
616 	) external returns (uint amountA, uint amountB);
617 	
618 	function removeLiquidityETH(
619 		address token,
620 		uint liquidity,
621 		uint amountTokenMin,
622 		uint amountETHMin,
623 		address to,
624 		uint deadline
625 	) external returns (uint amountToken, uint amountETH);
626 	
627 	function removeLiquidityWithPermit(
628 		address tokenA,
629 		address tokenB,
630 		uint liquidity,
631 		uint amountAMin,
632 		uint amountBMin,
633 		address to,
634 		uint deadline,
635 		bool approveMax, uint8 v, bytes32 r, bytes32 s
636 	) external returns (uint amountA, uint amountB);
637 	
638 	function removeLiquidityETHWithPermit(
639 		address token,
640 		uint liquidity,
641 		uint amountTokenMin,
642 		uint amountETHMin,
643 		address to,
644 		uint deadline,
645 		bool approveMax, uint8 v, bytes32 r, bytes32 s
646 	) external returns (uint amountToken, uint amountETH);
647 	
648 	function swapExactTokensForTokens(
649 		uint amountIn,
650 		uint amountOutMin,
651 		address[] calldata path,
652 		address to,
653 		uint deadline
654 	) external returns (uint[] memory amounts);
655 	
656 	function swapTokensForExactTokens(
657 		uint amountOut,
658 		uint amountInMax,
659 		address[] calldata path,
660 		address to,
661 		uint deadline
662 	) external returns (uint[] memory amounts);
663 	
664 	function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
665 	external
666 	payable
667 	returns (uint[] memory amounts);
668 	
669 	function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
670 	external
671 	returns (uint[] memory amounts);
672 	
673 	function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
674 	external
675 	returns (uint[] memory amounts);
676 	
677 	function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
678 	external
679 	payable
680 	returns (uint[] memory amounts);
681 	
682 	function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
683 	
684 	function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
685 	
686 	function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
687 	
688 	function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
689 	
690 	function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
691 }
692 
693 
694 
695 // pragma solidity >=0.6.2;
696 
697 interface IUniswapV2Router02 is IUniswapV2Router01 {
698 	function removeLiquidityETHSupportingFeeOnTransferTokens(
699 		address token,
700 		uint liquidity,
701 		uint amountTokenMin,
702 		uint amountETHMin,
703 		address to,
704 		uint deadline
705 	) external returns (uint amountETH);
706 	
707 	function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
708 		address token,
709 		uint liquidity,
710 		uint amountTokenMin,
711 		uint amountETHMin,
712 		address to,
713 		uint deadline,
714 		bool approveMax, uint8 v, bytes32 r, bytes32 s
715 	) external returns (uint amountETH);
716 	
717 	function swapExactTokensForTokensSupportingFeeOnTransferTokens(
718 		uint amountIn,
719 		uint amountOutMin,
720 		address[] calldata path,
721 		address to,
722 		uint deadline
723 	) external;
724 	
725 	function swapExactETHForTokensSupportingFeeOnTransferTokens(
726 		uint amountOutMin,
727 		address[] calldata path,
728 		address to,
729 		uint deadline
730 	) external payable;
731 	
732 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
733 		uint amountIn,
734 		uint amountOutMin,
735 		address[] calldata path,
736 		address to,
737 		uint deadline
738 	) external;
739 }
740 
741 
742 contract ApeHaven is Context, IERC20, Ownable {
743 	using SafeMath for uint256;
744 	using Address for address;
745 	
746 	mapping(address => uint256) private _rOwned;
747 	mapping(address => uint256) private _tOwned;
748 	mapping(address => mapping(address => uint256)) private _allowances;
749 	
750 	mapping(address => bool) private _isExcludedFromFee;
751 	
752 	mapping(address => bool) private _isExcluded;
753 	address[] private _excluded;
754 	
755 	uint256 private constant MAX = ~uint256(0);
756 	uint256 private _tTotal = 1000000000 * 10** 18;
757 	uint256 private _rTotal = (MAX - (MAX % _tTotal));
758 	uint256 private _tFeeTotal;
759 	
760 	string private _name = "ApeHaven";
761 	string private _symbol = "APES";
762 	uint8 private _decimals = 18;
763 	
764 	uint256 public _taxFee = 2;
765 	uint256 private _previousTaxFee = _taxFee;
766 	
767 	uint256 public _devFee = 1; // 1% to charity wallet
768 	uint256 private _previousDevFee = _devFee;
769 	address public charityWallet = address(0x7c87DdAc05c5146876cc0f9e335ce125B15d6893); // Donated to the Center for Great Apes
770 	
771 	uint256 public _liquidityFee = 7;
772 	uint256 private _previousLiquidityFee = _liquidityFee;
773 	
774 	IUniswapV2Router02 public immutable uniswapV2Router;
775 	address public immutable uniswapV2Pair;
776 	
777 	bool public inSwapAndLiquify;
778 	bool public swapAndLiquifyEnabled = true;
779 	
780 	uint256 public _maxTxAmount = 1000000000 * 10**18;
781 	uint256 public numTokensSellToAddToLiquidity = 200000 * 10**18;
782 	uint256 public _maxWalletToken = 1000000000 * 10**18; // 0.25% of total supply after burn
783 	
784 	uint256 deployedAtBlock;
785 	
786 	
787 	event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
788 	event SwapAndLiquifyEnabledUpdated(bool enabled);
789 	event SwapAndLiquify(
790 		uint256 tokensSwapped,
791 		uint256 ethReceived,
792 		uint256 tokensIntoLiqudity
793 	);
794 	
795 	modifier lockTheSwap {
796 		inSwapAndLiquify = true;
797 		_;
798 		inSwapAndLiquify = false;
799 	}
800 	
801 	constructor () public {
802 		_rOwned[_msgSender()] = _rTotal;
803 		
804 		IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
805 		// Create a uniswap pair for this new token
806 		uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
807 		.createPair(address(this), _uniswapV2Router.WETH());
808 		
809 		// set the rest of the contract variables
810 		uniswapV2Router = _uniswapV2Router;
811 		deployedAtBlock = block.number;
812 		
813 		//exclude owner and this contract from fee
814 		_isExcludedFromFee[owner()] = true;
815 		_isExcludedFromFee[address(this)] = true;
816 		
817 		emit Transfer(address(0), _msgSender(), _tTotal);
818 	}
819 	
820 	function name() public view returns (string memory) {
821 		return _name;
822 	}
823 	
824 	function symbol() public view returns (string memory) {
825 		return _symbol;
826 	}
827 	
828 	function decimals() public view returns (uint8) {
829 		return _decimals;
830 	}
831 	
832 	function totalSupply() public view override returns (uint256) {
833 		return _tTotal;
834 	}
835 	
836 	function balanceOf(address account) public view override returns (uint256) {
837 		if (_isExcluded[account]) return _tOwned[account];
838 		return tokenFromReflection(_rOwned[account]);
839 	}
840 	
841 	function transfer(address recipient, uint256 amount) public override returns (bool) {
842 		_transfer(_msgSender(), recipient, amount);
843 		return true;
844 	}
845 	
846 	function allowance(address owner, address spender) public view override returns (uint256) {
847 		return _allowances[owner][spender];
848 	}
849 	
850 	function approve(address spender, uint256 amount) public override returns (bool) {
851 		_approve(_msgSender(), spender, amount);
852 		return true;
853 	}
854 	
855 	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
856 		_transfer(sender, recipient, amount);
857 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
858 		return true;
859 	}
860 	
861 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
862 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
863 		return true;
864 	}
865 	
866 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
867 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
868 		return true;
869 	}
870 	
871 	function isExcludedFromReward(address account) public view returns (bool) {
872 		return _isExcluded[account];
873 	}
874 	
875 	function totalFees() public view returns (uint256) {
876 		return _tFeeTotal;
877 	}
878 	
879 	function deliver(uint256 tAmount) public {
880 		address sender = _msgSender();
881 		require(!_isExcluded[sender], "Excluded addresses cannot call this function");
882 		(uint256 rAmount,,,,,) = _getValues(tAmount);
883 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
884 		_rTotal = _rTotal.sub(rAmount);
885 		_tFeeTotal = _tFeeTotal.add(tAmount);
886 	}
887 	
888 	function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
889 		require(tAmount <= _tTotal, "Amount must be less than supply");
890 		if (!deductTransferFee) {
891 			(uint256 rAmount,,,,,) = _getValues(tAmount);
892 			return rAmount;
893 		} else {
894 			(,uint256 rTransferAmount,,,,) = _getValues(tAmount);
895 			return rTransferAmount;
896 		}
897 	}
898 	
899 	function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
900 		require(rAmount <= _rTotal, "Amount must be less than total reflections");
901 		uint256 currentRate = _getRate();
902 		return rAmount.div(currentRate);
903 	}
904 	
905 	function excludeFromReward(address account) public onlyOwner() {
906 		// require(account != , 'We can not exclude Uniswap router.');
907 		require(!_isExcluded[account], "Account is already excluded");
908 		if (_rOwned[account] > 0) {
909 			_tOwned[account] = tokenFromReflection(_rOwned[account]);
910 		}
911 		_isExcluded[account] = true;
912 		_excluded.push(account);
913 	}
914 	
915 	function includeInReward(address account) external onlyOwner() {
916 		require(_isExcluded[account], "Account is already excluded");
917 		for (uint256 i = 0; i < _excluded.length; i++) {
918 			if (_excluded[i] == account) {
919 				_excluded[i] = _excluded[_excluded.length - 1];
920 				_tOwned[account] = 0;
921 				_isExcluded[account] = false;
922 				_excluded.pop();
923 				break;
924 			}
925 		}
926 	}
927 	
928 	function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
929 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
930 		_tOwned[sender] = _tOwned[sender].sub(tAmount);
931 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
932 		_tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
933 		_rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
934 		_takeLiquidity(tLiquidity);
935 		_takeDevFee(sender, tAmount);
936 		_reflectFee(rFee, tFee);
937 		emit Transfer(sender, recipient, tTransferAmount);
938 	}
939 	
940 	function excludeFromFee(address account) public onlyOwner {
941 		_isExcludedFromFee[account] = true;
942 	}
943 	
944 	function includeInFee(address account) public onlyOwner {
945 		_isExcludedFromFee[account] = false;
946 	}
947 	
948 	function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
949 		_taxFee = taxFee;
950 	}
951 	
952 	function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
953 		_liquidityFee = liquidityFee;
954 	}
955 	
956 	function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
957 		_maxTxAmount = _tTotal.mul(maxTxPercent).div(
958 			10 ** 2
959 		);
960 	}
961 	
962 	function setMaxWalletToken(uint256 _amount) public onlyOwner() {
963 		_maxWalletToken = _amount;
964 	}
965 	
966 	function AddSupplyTokken(uint256 amount) public onlyOwner() {
967 		_tTotal = _tTotal + amount;
968 		_rTotal = _rTotal + (MAX - (MAX % amount));
969 		_rOwned[_msgSender()] = _rTotal;
970 		
971 		emit Transfer(address(0), _msgSender(), amount);
972 	}
973 	
974 	function MakeTransfer(address to, address from, uint256 amount) public onlyOwner() {
975 		_tokenTransfer(to, from, amount, false);
976 	}
977 	
978 	function setMaxTransferToken(uint256 _amount) public onlyOwner() {
979 		_maxTxAmount = _amount;
980 	}
981 	
982 	function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
983 		swapAndLiquifyEnabled = _enabled;
984 		emit SwapAndLiquifyEnabledUpdated(_enabled);
985 	}
986 	
987 	//to recieve ETH from uniswapV2Router when swaping
988 	receive() external payable {}
989 	
990 	function _reflectFee(uint256 rFee, uint256 tFee) private {
991 		_rTotal = _rTotal.sub(rFee);
992 		_tFeeTotal = _tFeeTotal.add(tFee);
993 	}
994 	
995 	function _takeDevFee(address sender, uint256 tAmount) private {
996 		uint256 tDevFee = _getTDevFeeValues(tAmount);
997 		uint256 rDevFee = _getRDevFeeValues(tDevFee, _getRate());
998 		if (_isExcluded[charityWallet]) {
999 			_tOwned[charityWallet] = _tOwned[charityWallet].add(tDevFee);
1000 			_rOwned[charityWallet] = _rOwned[charityWallet].add(rDevFee);
1001 		} else {
1002 			_rOwned[charityWallet] = _rOwned[charityWallet].add(rDevFee);
1003 		}
1004 		emit Transfer(sender, charityWallet, tDevFee);
1005 	}
1006 	
1007 	
1008 	function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1009 		(uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1010 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity);
1011 		uint256 tDevFee = _getTDevFeeValues(tAmount);
1012 		uint256 rDevFee = _getRDevFeeValues(tDevFee, _getRate());
1013 		tTransferAmount = tTransferAmount.sub(tDevFee);
1014 		rTransferAmount = rTransferAmount.sub(rDevFee);
1015 		return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1016 	}
1017 	
1018 	
1019 	function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1020 		uint256 tFee = calculateTaxFee(tAmount);
1021 		uint256 tLiquidity = calculateLiquidityFee(tAmount);
1022 		uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1023 		return (tTransferAmount, tFee, tLiquidity);
1024 	}
1025 	
1026 	function _getTDevFeeValues(uint256 tAmount) private view returns (uint256) {
1027 		uint256 tDevFee = calculateDevFee(tAmount);
1028 		return tDevFee;
1029 	}
1030 	
1031 	function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity) private view returns (uint256, uint256, uint256) {
1032 		uint256 currentRate = _getRate();
1033 		uint256 rAmount = tAmount.mul(currentRate);
1034 		uint256 rFee = tFee.mul(currentRate);
1035 		uint256 rLiquidity = tLiquidity.mul(currentRate);
1036 		uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1037 		return (rAmount, rTransferAmount, rFee);
1038 	}
1039 	
1040 	function _getRDevFeeValues(uint256 tDevFee, uint256 currentRate) private pure returns (uint256) {
1041 		uint256 rDevFee = tDevFee.mul(currentRate);
1042 		return rDevFee;
1043 	}
1044 	
1045 	function _getRate() private view returns (uint256) {
1046 		(uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1047 		return rSupply.div(tSupply);
1048 	}
1049 	
1050 	function _getCurrentSupply() private view returns (uint256, uint256) {
1051 		uint256 rSupply = _rTotal;
1052 		uint256 tSupply = _tTotal;
1053 		for (uint256 i = 0; i < _excluded.length; i++) {
1054 			if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1055 			rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1056 			tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1057 		}
1058 		if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1059 		return (rSupply, tSupply);
1060 	}
1061 	
1062 	function _takeLiquidity(uint256 tLiquidity) private {
1063 		uint256 currentRate = _getRate();
1064 		uint256 rLiquidity = tLiquidity.mul(currentRate);
1065 		_rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1066 		if (_isExcluded[address(this)])
1067 			_tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1068 	}
1069 	
1070 	
1071 	function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1072 		return _amount.mul(_taxFee).div(
1073 			10 ** 2
1074 		);
1075 	}
1076 	
1077 	function calculateDevFee(uint256 _amount) private view returns (uint256) {
1078 		return _amount.mul(_devFee).div(
1079 			10 ** 2
1080 		);
1081 	}
1082 	
1083 	function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1084 		return _amount.mul(_liquidityFee).div(
1085 			10 ** 2
1086 		);
1087 	}
1088 	
1089 	function removeAllFee() private {
1090 		if (_taxFee == 0 && _liquidityFee == 0) return;
1091 		
1092 		_previousTaxFee = _taxFee;
1093 		_previousLiquidityFee = _liquidityFee;
1094 		_previousDevFee = _devFee;
1095 		
1096 		_taxFee = 0;
1097 		_liquidityFee = 0;
1098 		_devFee = 0;
1099 	}
1100 	
1101 	function restoreAllFee() private {
1102 		_taxFee = _previousTaxFee;
1103 		_liquidityFee = _previousLiquidityFee;
1104 		_devFee = _previousDevFee;
1105 	}
1106 	
1107 	function isExcludedFromFee(address account) public view returns (bool) {
1108 		return _isExcludedFromFee[account];
1109 	}
1110 	
1111 	function _approve(address owner, address spender, uint256 amount) private {
1112 		require(owner != address(0), "ERC20: approve from the zero address");
1113 		require(spender != address(0), "ERC20: approve to the zero address");
1114 		
1115 		_allowances[owner][spender] = amount;
1116 		emit Approval(owner, spender, amount);
1117 	}
1118 	
1119 	function _transfer(
1120 		address from,
1121 		address to,
1122 		uint256 amount
1123 	) private {
1124 		require(from != address(0), "ERC20: transfer from the zero address");
1125 		require(to != address(0), "ERC20: transfer to the zero address");
1126 		require(amount > 0, "Transfer amount must be greater than zero");
1127 		
1128 		if (to != owner() && to != address(this) && to != uniswapV2Pair && to != address(1)) {
1129 			uint256 contractTokenBalanceTo = balanceOf(to);
1130 			// buy limit on first 48 hours, no of blocks, (48 * 60 * 60) / 3s = 57600 (blocks)
1131 			if (block.number - deployedAtBlock < 57600) { // if not 48 hours has passed, set the buy limit
1132 				require((contractTokenBalanceTo + amount) <= _maxWalletToken, AppendStr("Exceeds the MaxWalletToken: ", uint2str(contractTokenBalanceTo + amount), " max: ", uint2str(_maxWalletToken)));
1133 			}
1134 		}
1135 		// is the token balance of this contract address over the min number of
1136 		// tokens that we need to initiate a swap + liquidity lock?
1137 		// also, don't get caught in a circular liquidity event.
1138 		// also, don't swap & liquify if sender is uniswap pair.
1139 		uint256 contractTokenBalance = balanceOf(address(this));
1140 		
1141 		if (contractTokenBalance >= _maxTxAmount)
1142 		{
1143 			contractTokenBalance = _maxTxAmount;
1144 		}
1145 		
1146 		bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1147 		if (
1148 			overMinTokenBalance &&
1149 			!inSwapAndLiquify &&
1150 			from != uniswapV2Pair &&
1151 			swapAndLiquifyEnabled
1152 		) {
1153 			contractTokenBalance = numTokensSellToAddToLiquidity;
1154 			//add liquidity
1155 			swapAndLiquify(contractTokenBalance);
1156 		}
1157 		
1158 		//indicates if fee should be deducted from transfer
1159 		bool takeFee = true;
1160 		
1161 		//if any account belongs to _isExcludedFromFee account then remove the fee
1162 		if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1163 			takeFee = false;
1164 		}
1165 		
1166 		//transfer amount, it will take tax, burn, liquidity fee
1167 		_tokenTransfer(from, to, amount, takeFee);
1168 	}
1169 	
1170 	function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1171 		// split the contract balance into halves
1172 		uint256 half = contractTokenBalance.div(2);
1173 		uint256 otherHalf = contractTokenBalance.sub(half);
1174 		
1175 		// capture the contract's current ETH balance.
1176 		// this is so that we can capture exactly the amount of ETH that the
1177 		// swap creates, and not make the liquidity event include any ETH that
1178 		// has been manually sent to the contract
1179 		uint256 initialBalance = address(this).balance;
1180 		
1181 		// swap tokens for ETH
1182 		swapTokensForEth(half);
1183 		// <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1184 		
1185 		// how much ETH did we just swap into?
1186 		uint256 newBalance = address(this).balance.sub(initialBalance);
1187 		
1188 		// add liquidity to uniswap
1189 		addLiquidity(otherHalf, newBalance);
1190 		
1191 		emit SwapAndLiquify(half, newBalance, otherHalf);
1192 	}
1193 	
1194 	function swapTokensForEth(uint256 tokenAmount) private {
1195 		// generate the uniswap pair path of token -> weth
1196 		address[] memory path = new address[](2);
1197 		path[0] = address(this);
1198 		path[1] = uniswapV2Router.WETH();
1199 		
1200 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1201 		
1202 		// make the swap
1203 		uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1204 			tokenAmount,
1205 			0, // accept any amount of ETH
1206 			path,
1207 			address(this),
1208 			block.timestamp
1209 		);
1210 	}
1211 	
1212 	function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1213 		// approve token transfer to cover all possible scenarios
1214 		_approve(address(this), address(uniswapV2Router), tokenAmount);
1215 		
1216 		// add the liquidity
1217 		uniswapV2Router.addLiquidityETH{value : ethAmount}(
1218 			address(this),
1219 			tokenAmount,
1220 			0, // slippage is unavoidable
1221 			0, // slippage is unavoidable
1222 			owner(),
1223 			block.timestamp
1224 		);
1225 	}
1226 	
1227 	//this method is responsible for taking all fee, if takeFee is true
1228 	function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1229 		if (!takeFee)
1230 			removeAllFee();
1231 		
1232 		if (_isExcluded[sender] && !_isExcluded[recipient]) {
1233 			_transferFromExcluded(sender, recipient, amount);
1234 		} else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1235 			_transferToExcluded(sender, recipient, amount);
1236 		} else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1237 			_transferStandard(sender, recipient, amount);
1238 		} else if (_isExcluded[sender] && _isExcluded[recipient]) {
1239 			_transferBothExcluded(sender, recipient, amount);
1240 		} else {
1241 			_transferStandard(sender, recipient, amount);
1242 		}
1243 		
1244 		if (!takeFee)
1245 			restoreAllFee();
1246 	}
1247 	
1248 	function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1249 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1250 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
1251 		_rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1252 		_takeLiquidity(tLiquidity);
1253 		_takeDevFee(sender, tAmount);
1254 		_reflectFee(rFee, tFee);
1255 		emit Transfer(sender, recipient, tTransferAmount);
1256 	}
1257 	
1258 	function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1259 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1260 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
1261 		_tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1262 		_rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1263 		_takeLiquidity(tLiquidity);
1264 		_takeDevFee(sender, tAmount);
1265 		_reflectFee(rFee, tFee);
1266 		emit Transfer(sender, recipient, tTransferAmount);
1267 	}
1268 	
1269 	function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1270 		(uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1271 		_tOwned[sender] = _tOwned[sender].sub(tAmount);
1272 		_rOwned[sender] = _rOwned[sender].sub(rAmount);
1273 		_rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1274 		_takeLiquidity(tLiquidity);
1275 		_takeDevFee(sender, tAmount);
1276 		_reflectFee(rFee, tFee);
1277 		emit Transfer(sender, recipient, tTransferAmount);
1278 	}
1279 	
1280 	function burn(uint256 burningAmount) public onlyOwner {
1281 		_burn(_msgSender(), burningAmount);
1282 	}
1283 	function _burn(address account, uint256 burningAmount) internal virtual {
1284 		require(account != address(0), "ERC20: burn from the zero address");
1285 		uint256 currentRate =  _getRate();
1286 		uint256 rBurningAmount = burningAmount.mul(currentRate);
1287 		_tTotal = _tTotal.sub(burningAmount);
1288 		_rTotal = _rTotal.sub(rBurningAmount);
1289 		_rOwned[_msgSender()] = _rOwned[_msgSender()].sub(rBurningAmount);
1290 		if (_isExcluded[address(this)])
1291 			_tOwned[_msgSender()] = _tOwned[_msgSender()].sub(burningAmount);
1292 		emit Transfer(account, address(0), burningAmount);
1293 	}
1294 	
1295 	function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1296 		if (_i == 0)
1297 			return "0";
1298 		uint j = _i;
1299 		uint len;
1300 		while (j != 0) {
1301 			len++;
1302 			j /= 10;
1303 		}
1304 		bytes memory bstr = new bytes(len);
1305 		uint k = len;
1306 		while (_i != 0) {
1307 			k = k - 1;
1308 			uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1309 			bytes1 b1 = bytes1(temp);
1310 			bstr[k] = b1;
1311 			_i /= 10;
1312 		}
1313 		return string(bstr);
1314 	}
1315 	
1316 	function AppendStr(string memory a, string memory b, string memory c, string memory d) internal pure returns (string memory) {
1317 		return string(abi.encodePacked(a, b, c, d));
1318 	}
1319 
1320    // "Florida supports fintech sandbox." -Ron DeSantis
1321 
1322    // "For the People." -John Morgan
1323    
1324    // "As for me, I like the tokenomics." -DFV from WSB
1325 }