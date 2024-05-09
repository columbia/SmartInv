1 /*
2  * Copyright © 2020 dragonflyprotocol.com. ALL RIGHTS RESERVED.
3  */
4 // SPDX-License-Identifier: MIT
5 // File @openzeppelin/contracts/GSN/Context.sol
6 
7 
8 pragma solidity ^0.6.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 
35 pragma solidity ^0.6.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 // File @openzeppelin/contracts/math/SafeMath.sol
113 
114 
115 pragma solidity ^0.6.0;
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         return mod(a, b, "SafeMath: modulo by zero");
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts with custom message when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 
274 // File @openzeppelin/contracts/utils/Address.sol
275 
276 
277 pragma solidity ^0.6.2;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies in extcodesize, which returns 0 for contracts in
302         // construction, since the code is only stored at the end of the
303         // constructor execution.
304 
305         uint256 size;
306         // solhint-disable-next-line no-inline-assembly
307         assembly { size := extcodesize(account) }
308         return size > 0;
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success, ) = recipient.call{ value: amount }("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354       return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         return _functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 
418 // File @openzeppelin/contracts/access/Ownable.sol
419 
420 
421 pragma solidity ^0.6.0;
422 
423 /**
424  * @dev Contract module which provides a basic access control mechanism, where
425  * there is an account (an owner) that can be granted exclusive access to
426  * specific functions.
427  *
428  * By default, the owner account will be the one that deploys the contract. This
429  * can later be changed with {transferOwnership}.
430  *
431  * This module is used through inheritance. It will make available the modifier
432  * `onlyOwner`, which can be applied to your functions to restrict their use to
433  * the owner.
434  */
435 contract Ownable is Context {
436     address private _owner;
437 
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439 
440     /**
441      * @dev Initializes the contract setting the deployer as the initial owner.
442      */
443     constructor () internal {
444         address msgSender = _msgSender();
445         _owner = msgSender;
446         emit OwnershipTransferred(address(0), msgSender);
447     }
448 
449     /**
450      * @dev Returns the address of the current owner.
451      */
452     function owner() public view returns (address) {
453         return _owner;
454     }
455 
456     /**
457      * @dev Throws if called by any account other than the owner.
458      */
459     modifier onlyOwner() {
460         require(_owner == _msgSender(), "Ownable: caller is not the owner");
461         _;
462     }
463 
464     /**
465      * @dev Leaves the contract without owner. It will not be possible to call
466      * `onlyOwner` functions anymore. Can only be called by the current owner.
467      *
468      * NOTE: Renouncing ownership will leave the contract without an owner,
469      * thereby removing any functionality that is only available to the owner.
470      */
471     function renounceOwnership() public virtual onlyOwner {
472         emit OwnershipTransferred(_owner, address(0));
473         _owner = address(0);
474     }
475 
476     /**
477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
478      * Can only be called by the current owner.
479      */
480     function transferOwnership(address newOwner) public virtual onlyOwner {
481         require(newOwner != address(0), "Ownable: new owner is the zero address");
482         emit OwnershipTransferred(_owner, newOwner);
483         _owner = newOwner;
484     }
485 }
486 
487 
488 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1
489 
490 pragma solidity >=0.5.0;
491 
492 interface IUniswapV2Pair {
493     event Approval(address indexed owner, address indexed spender, uint value);
494     event Transfer(address indexed from, address indexed to, uint value);
495 
496     function name() external pure returns (string memory);
497     function symbol() external pure returns (string memory);
498     function decimals() external pure returns (uint8);
499     function totalSupply() external view returns (uint);
500     function balanceOf(address owner) external view returns (uint);
501     function allowance(address owner, address spender) external view returns (uint);
502 
503     function approve(address spender, uint value) external returns (bool);
504     function transfer(address to, uint value) external returns (bool);
505     function transferFrom(address from, address to, uint value) external returns (bool);
506 
507     function DOMAIN_SEPARATOR() external view returns (bytes32);
508     function PERMIT_TYPEHASH() external pure returns (bytes32);
509     function nonces(address owner) external view returns (uint);
510 
511     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
512 
513     event Mint(address indexed sender, uint amount0, uint amount1);
514     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
515     event Swap(
516         address indexed sender,
517         uint amount0In,
518         uint amount1In,
519         uint amount0Out,
520         uint amount1Out,
521         address indexed to
522     );
523     event Sync(uint112 reserve0, uint112 reserve1);
524 
525     function MINIMUM_LIQUIDITY() external pure returns (uint);
526     function factory() external view returns (address);
527     function token0() external view returns (address);
528     function token1() external view returns (address);
529     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
530     function price0CumulativeLast() external view returns (uint);
531     function price1CumulativeLast() external view returns (uint);
532     function kLast() external view returns (uint);
533 
534     function mint(address to) external returns (uint liquidity);
535     function burn(address to) external returns (uint amount0, uint amount1);
536     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
537     function skim(address to) external;
538     function sync() external;
539 
540     function initialize(address, address) external;
541 }
542 
543 
544 // File contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
545 
546 pragma solidity >=0.5.0;
547 
548 interface IUniswapV2Factory {
549     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
550 
551     function feeTo() external view returns (address);
552     function feeToSetter() external view returns (address);
553     function migrator() external view returns (address);
554 
555     function getPair(address tokenA, address tokenB) external view returns (address pair);
556     function allPairs(uint) external view returns (address pair);
557     function allPairsLength() external view returns (uint);
558 
559     function createPair(address tokenA, address tokenB) external returns (address pair);
560 
561     function setFeeTo(address) external;
562     function setFeeToSetter(address) external;
563     function setMigrator(address) external;
564 }
565 
566 
567 // File contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
568 
569 pragma solidity >=0.6.2;
570 
571 interface IUniswapV2Router01 {
572     function factory() external pure returns (address);
573     function WETH() external pure returns (address);
574 
575     function addLiquidity(
576         address tokenA,
577         address tokenB,
578         uint amountADesired,
579         uint amountBDesired,
580         uint amountAMin,
581         uint amountBMin,
582         address to,
583         uint deadline
584     ) external returns (uint amountA, uint amountB, uint liquidity);
585     function addLiquidityETH(
586         address token,
587         uint amountTokenDesired,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
593     function removeLiquidity(
594         address tokenA,
595         address tokenB,
596         uint liquidity,
597         uint amountAMin,
598         uint amountBMin,
599         address to,
600         uint deadline
601     ) external returns (uint amountA, uint amountB);
602     function removeLiquidityETH(
603         address token,
604         uint liquidity,
605         uint amountTokenMin,
606         uint amountETHMin,
607         address to,
608         uint deadline
609     ) external returns (uint amountToken, uint amountETH);
610     function removeLiquidityWithPermit(
611         address tokenA,
612         address tokenB,
613         uint liquidity,
614         uint amountAMin,
615         uint amountBMin,
616         address to,
617         uint deadline,
618         bool approveMax, uint8 v, bytes32 r, bytes32 s
619     ) external returns (uint amountA, uint amountB);
620     function removeLiquidityETHWithPermit(
621         address token,
622         uint liquidity,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline,
627         bool approveMax, uint8 v, bytes32 r, bytes32 s
628     ) external returns (uint amountToken, uint amountETH);
629     function swapExactTokensForTokens(
630         uint amountIn,
631         uint amountOutMin,
632         address[] calldata path,
633         address to,
634         uint deadline
635     ) external returns (uint[] memory amounts);
636     function swapTokensForExactTokens(
637         uint amountOut,
638         uint amountInMax,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external returns (uint[] memory amounts);
643     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
644         external
645         payable
646         returns (uint[] memory amounts);
647     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
648         external
649         returns (uint[] memory amounts);
650     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
651         external
652         returns (uint[] memory amounts);
653     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
654         external
655         payable
656         returns (uint[] memory amounts);
657 
658     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
659     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
660     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
661     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
662     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
663 }
664 
665 
666 // File contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
667 
668 pragma solidity >=0.6.2;
669 
670 interface IUniswapV2Router02 is IUniswapV2Router01 {
671     function removeLiquidityETHSupportingFeeOnTransferTokens(
672         address token,
673         uint liquidity,
674         uint amountTokenMin,
675         uint amountETHMin,
676         address to,
677         uint deadline
678     ) external returns (uint amountETH);
679     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
680         address token,
681         uint liquidity,
682         uint amountTokenMin,
683         uint amountETHMin,
684         address to,
685         uint deadline,
686         bool approveMax, uint8 v, bytes32 r, bytes32 s
687     ) external returns (uint amountETH);
688 
689     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
690         uint amountIn,
691         uint amountOutMin,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external;
696     function swapExactETHForTokensSupportingFeeOnTransferTokens(
697         uint amountOutMin,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external payable;
702     function swapExactTokensForETHSupportingFeeOnTransferTokens(
703         uint amountIn,
704         uint amountOutMin,
705         address[] calldata path,
706         address to,
707         uint deadline
708     ) external;
709 }
710 
711 
712 // File contracts/uniswapv2/interfaces/IWETH.sol
713 
714 pragma solidity >=0.5.0;
715 
716 interface IWETH {
717     function deposit() external payable;
718     function transfer(address to, uint value) external returns (bool);
719     function withdraw(uint) external;
720 }
721 
722 // File contracts/DragonflyToken.sol
723 
724 pragma solidity ^0.6.0;
725 
726 contract DragonflyToken is Context, IERC20, Ownable {
727     using SafeMath for uint256;
728     using Address for address;
729 
730     mapping (address => uint256) private _rOwned;
731     mapping (address => uint256) private _tOwned;
732     mapping (address => mapping (address => uint256)) private _allowances;
733 
734     mapping (address => bool) private _isExcluded;
735     address[] private _excluded;
736    
737     uint256 private constant MAX = ~uint256(0);
738     uint256 private _tTotal = 1 * 10**6 * 10**9;
739     uint256 private _rTotal = (MAX - (MAX % _tTotal));
740     uint256 private _tFeeTotal;
741     uint256 private _tBurnTotal;
742 
743     string private _name = 'dragonflyprotocol.com';
744     string private _symbol = 'DFLY';
745     uint8 private _decimals = 9;
746     
747     uint256 private _taxFee = 200;
748     uint256 private _burnFee = 50;
749     uint256 private _devFee = 50;
750 
751     // Liquidity Generation Event
752     IUniswapV2Factory public uniswapFactory;
753     IUniswapV2Router02 public uniswapRouterV2;
754     address public tokenUniswapPair;
755 
756     mapping (address => uint)  public ethContributedForLPTokens;
757     uint256 public LPperETHUnit;
758     uint256 public totalETHContributed;
759     uint256 public totalLPTokensMinted;
760 
761     bool public LPGenerationCompleted;
762     uint256 public lgeEndTimestamp;
763     uint256 public lpUnlockTimestamp;
764 
765     // Token Claim
766     mapping (address => uint)  public ethContributedForTokens;
767     uint256 public TokenPerETHUnit;
768     uint256 public bonusTokens = 150000 * 10**9;
769 
770     address public devAddr;
771 
772     event LiquidityAddition(address indexed dst, uint value);
773     event LPTokenClaimed(address dst, uint value);
774     event TokenClaimed(address dst, uint value);
775 
776     constructor (address router, address factory, uint256 _lgeEndTimestamp, uint256 _lpUnlockTimestamp) public {
777         _rOwned[_msgSender()] = _rTotal.div(100).mul(25); // farms and treasury
778         _rOwned[address(this)] = _rTotal.sub(_rOwned[_msgSender()]);
779 
780         uniswapRouterV2 = IUniswapV2Router02(router);
781         uniswapFactory = IUniswapV2Factory(factory);
782 
783         lgeEndTimestamp = _lgeEndTimestamp;
784         lpUnlockTimestamp = _lpUnlockTimestamp;
785 
786         devAddr = _msgSender();
787 
788         emit Transfer(address(0), _msgSender(), _tTotal);
789     }
790 
791     function name() public view returns (string memory) {
792         return _name;
793     }
794 
795     function symbol() public view returns (string memory) {
796         return _symbol;
797     }
798 
799     function decimals() public view returns (uint8) {
800         return _decimals;
801     }
802 
803     function totalSupply() public view override returns (uint256) {
804         return _tTotal;
805     }
806 
807     function balanceOf(address account) public view override returns (uint256) {
808         if (_isExcluded[account]) return _tOwned[account];
809         return tokenFromReflection(_rOwned[account]);
810     }
811 
812     function transfer(address recipient, uint256 amount) public override returns (bool) {
813         _transfer(_msgSender(), recipient, amount);
814         return true;
815     }
816 
817     function allowance(address owner, address spender) public view override returns (uint256) {
818         return _allowances[owner][spender];
819     }
820 
821     function approve(address spender, uint256 amount) public override returns (bool) {
822         _approve(_msgSender(), spender, amount);
823         return true;
824     }
825 
826     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
827         _transfer(sender, recipient, amount);
828         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
829         return true;
830     }
831 
832     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
833         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
834         return true;
835     }
836 
837     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
838         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
839         return true;
840     }
841 
842     function isExcluded(address account) public view returns (bool) {
843         return _isExcluded[account];
844     }
845 
846     function totalFees() public view returns (uint256) {
847         return _tFeeTotal;
848     }
849     
850     function totalBurn() public view returns (uint256) {
851         return _tBurnTotal;
852     }
853 
854     function deliver(uint256 tAmount) public {
855         address sender = _msgSender();
856         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
857         (uint256 rAmount,,,,,) = _getValues(tAmount);
858         _rOwned[sender] = _rOwned[sender].sub(rAmount);
859         _rTotal = _rTotal.sub(rAmount);
860         _tFeeTotal = _tFeeTotal.add(tAmount);
861     }
862 
863     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
864         require(tAmount <= _tTotal, "Amount must be less than supply");
865         if (!deductTransferFee) {
866             (uint256 rAmount,,,,,) = _getValues(tAmount);
867             return rAmount;
868         } else {
869             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
870             return rTransferAmount;
871         }
872     }
873 
874     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
875         require(rAmount <= _rTotal, "Amount must be less than total reflections");
876         uint256 currentRate =  _getRate();
877         return rAmount.div(currentRate);
878     }
879 
880     function excludeAccount(address account) external onlyOwner() {
881         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
882         require(!_isExcluded[account], "Account is already excluded");
883         if(_rOwned[account] > 0) {
884             _tOwned[account] = tokenFromReflection(_rOwned[account]);
885         }
886         _isExcluded[account] = true;
887         _excluded.push(account);
888     }
889 
890     function includeAccount(address account) external onlyOwner() {
891         require(_isExcluded[account], "Account is already excluded");
892         for (uint256 i = 0; i < _excluded.length; i++) {
893             if (_excluded[i] == account) {
894                 _excluded[i] = _excluded[_excluded.length - 1];
895                 _tOwned[account] = 0;
896                 _isExcluded[account] = false;
897                 _excluded.pop();
898                 break;
899             }
900         }
901     }
902 
903     function _approve(address owner, address spender, uint256 amount) private {
904         require(owner != address(0), "ERC20: approve from the zero address");
905         require(spender != address(0), "ERC20: approve to the zero address");
906 
907         _allowances[owner][spender] = amount;
908         emit Approval(owner, spender, amount);
909     }
910 
911     function _transfer(address sender, address recipient, uint256 amount) private {
912         require(sender != address(0), "ERC20: transfer from the zero address");
913         require(recipient != address(0), "ERC20: transfer to the zero address");
914         require(amount > 0, "Transfer amount must be greater than zero");
915 
916         if (_isExcluded[sender] && !_isExcluded[recipient]) {
917             _transferFromExcluded(sender, recipient, amount);
918         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
919             _transferToExcluded(sender, recipient, amount);
920         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
921             _transferStandard(sender, recipient, amount);
922         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
923             _transferBothExcluded(sender, recipient, amount);
924         } else {
925             _transferStandard(sender, recipient, amount);
926         }
927     }
928 
929     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
930         uint256 currentRate =  _getRate();
931         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
932         uint256 rBurn =  tBurn.mul(currentRate);
933         _rOwned[sender] = _rOwned[sender].sub(rAmount);
934         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
935         _reflectFee(rFee, rBurn, tFee, tBurn);
936         emit Transfer(sender, recipient, tTransferAmount);
937     }
938 
939     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
940         uint256 currentRate =  _getRate();
941         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
942         uint256 rBurn =  tBurn.mul(currentRate);
943         _rOwned[sender] = _rOwned[sender].sub(rAmount);
944         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
945         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
946         _reflectFee(rFee, rBurn, tFee, tBurn);
947         emit Transfer(sender, recipient, tTransferAmount);
948     }
949 
950     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
951         uint256 currentRate =  _getRate();
952         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
953         uint256 rBurn =  tBurn.mul(currentRate);
954         _tOwned[sender] = _tOwned[sender].sub(tAmount);
955         _rOwned[sender] = _rOwned[sender].sub(rAmount);
956         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
957         _reflectFee(rFee, rBurn, tFee, tBurn);
958         emit Transfer(sender, recipient, tTransferAmount);
959     }
960 
961     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
962         uint256 currentRate =  _getRate();
963         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
964         uint256 rBurn =  tBurn.mul(currentRate);
965         _tOwned[sender] = _tOwned[sender].sub(tAmount);
966         _rOwned[sender] = _rOwned[sender].sub(rAmount);
967         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
968         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
969         _reflectFee(rFee, rBurn, tFee, tBurn);
970         emit Transfer(sender, recipient, tTransferAmount);
971     }
972 
973     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
974         uint256 rDev = rFee.mul(_devFee).div(_taxFee);
975         uint256 tDev = tFee.mul(_devFee).div(_taxFee);
976         _rOwned[devAddr] = _rOwned[devAddr].add(rDev);       
977         _rTotal = _rTotal.sub(rFee).sub(rBurn).add(rDev);
978         _tFeeTotal = _tFeeTotal.add(tFee).sub(tDev);
979         _tBurnTotal = _tBurnTotal.add(tBurn);
980         _tTotal = _tTotal.sub(tBurn);
981     }
982 
983     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
984         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
985         uint256 currentRate =  _getRate();
986         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
987         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
988     }
989 
990     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
991         uint256 tFee = tAmount.mul(taxFee).div(10000);
992         uint256 tBurn = tAmount.mul(burnFee).div(10000);
993         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
994         return (tTransferAmount, tFee, tBurn);
995     }
996 
997     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
998         uint256 rAmount = tAmount.mul(currentRate);
999         uint256 rFee = tFee.mul(currentRate);
1000         uint256 rBurn = tBurn.mul(currentRate);
1001         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
1002         return (rAmount, rTransferAmount, rFee);
1003     }
1004 
1005     function _getRate() private view returns(uint256) {
1006         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1007         return rSupply.div(tSupply);
1008     }
1009 
1010     function _getCurrentSupply() private view returns(uint256, uint256) {
1011         uint256 rSupply = _rTotal;
1012         uint256 tSupply = _tTotal;      
1013         for (uint256 i = 0; i < _excluded.length; i++) {
1014             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1015             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1016             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1017         }
1018         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1019         return (rSupply, tSupply);
1020     }
1021     
1022     function _getTaxFee() private view returns(uint256) {
1023         return _taxFee;
1024     }
1025 
1026     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1027         require(taxFee >= 100 && taxFee <= 1000, 'taxFee should be in 1% - 10%');
1028         _taxFee = taxFee;
1029     }
1030 
1031     function _getBurnFee() private view returns(uint256) {
1032         return _burnFee;
1033     }
1034 
1035     function _setBurnFee(uint256 burnFee) external onlyOwner() {
1036         require(burnFee < _taxFee, 'burnFee should be less than taxFee');
1037         _burnFee = burnFee;
1038     }
1039 
1040     function _getDevFee() private view returns(uint256) {
1041         return _devFee;
1042     }
1043 
1044     function _setDevFee(uint256 devFee) external onlyOwner() {
1045         require(devFee < _taxFee, 'devFee should be less than taxFee');
1046         _devFee = devFee;
1047     }
1048     
1049     // Liquidity Generation Event
1050     function createUniswapPair() public returns (address) {
1051         require(tokenUniswapPair == address(0), "Token: pool already created");
1052         tokenUniswapPair = uniswapFactory.createPair(
1053             address(uniswapRouterV2.WETH()),
1054             address(this)
1055         );
1056         return tokenUniswapPair;
1057     }
1058 
1059     function addLiquidity() public payable {
1060         require(block.timestamp < lgeEndTimestamp, "Liquidity Generation Event over");
1061         ethContributedForLPTokens[msg.sender] += msg.value; // Overflow protection from safemath is not neded here 
1062         ethContributedForTokens[msg.sender] = ethContributedForLPTokens[msg.sender];
1063         totalETHContributed = totalETHContributed.add(msg.value); // for front end display during LGE. This resets with definietly correct balance while calling pair.
1064         emit LiquidityAddition(msg.sender, msg.value);
1065     }
1066 
1067     function addLiquidityToUniswapPair() public {
1068         require(block.timestamp >= lgeEndTimestamp, "Liquidity generation ongoing");
1069         require(LPGenerationCompleted == false, "Liquidity generation already finished");
1070         if(_msgSender() != owner()) {
1071             require(block.timestamp > (lgeEndTimestamp + 2 hours), "Please wait for dev grace period");
1072         }
1073         uint256 initialTokenLiquidity = this.balanceOf(address(this)).sub(bonusTokens);
1074         totalETHContributed = address(this).balance;
1075         uint256 devETHFee = totalETHContributed.div(10);
1076         uint256 initialETHLiquidity = totalETHContributed.sub(devETHFee);
1077 
1078         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
1079         address WETH = uniswapRouterV2.WETH();
1080 
1081         IWETH(WETH).deposit{value : initialETHLiquidity}();
1082         (bool success, ) = devAddr.call.value(devETHFee)("");
1083         require(success, "Transfer failed.");
1084         require(address(this).balance == 0 , "Transfer Failed");
1085 
1086         IWETH(WETH).transfer(address(pair), initialETHLiquidity);
1087         this.transfer(address(pair), initialTokenLiquidity);
1088         pair.mint(address(this));
1089         totalLPTokensMinted = pair.balanceOf(address(this));
1090         require(totalLPTokensMinted != 0 , "LP creation failed");
1091 
1092         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
1093         require(LPperETHUnit != 0 , "LP creation failed");
1094 
1095         // Token Claim
1096         TokenPerETHUnit = bonusTokens.mul(1e18).div(totalETHContributed);
1097         require(TokenPerETHUnit != 0 , "Token calculation failed");
1098 
1099         LPGenerationCompleted = true;
1100     }
1101 
1102     function claimLPTokens() public {
1103         require(block.timestamp >= lpUnlockTimestamp, "LP not unlocked yet");
1104         require(LPGenerationCompleted, "Event not over yet");
1105         require(ethContributedForLPTokens[msg.sender] > 0 , "Nothing to claim, move along");
1106         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
1107         uint256 amountLPToTransfer = ethContributedForLPTokens[msg.sender].mul(LPperETHUnit).div(1e18);
1108         pair.transfer(msg.sender, amountLPToTransfer); // stored as 1e18x value for change
1109         ethContributedForLPTokens[msg.sender] = 0;
1110         emit LPTokenClaimed(msg.sender, amountLPToTransfer);
1111     }
1112 
1113     function claimTokens() public {
1114         require(block.timestamp >= lpUnlockTimestamp, "LP not unlocked yet");
1115         require(LPGenerationCompleted, "Event not over yet");
1116         require(ethContributedForTokens[msg.sender] > 0 , "Nothing to claim, move along");
1117         uint256 amountTokenToTransfer = ethContributedForTokens[msg.sender].mul(TokenPerETHUnit).div(1e18);
1118         this.transfer(msg.sender, amountTokenToTransfer); // stored as 1e18x value for change
1119         ethContributedForTokens[msg.sender] = 0;
1120         emit TokenClaimed(msg.sender, amountTokenToTransfer);
1121     }
1122 
1123     function emergencyRecoveryIfLiquidityGenerationEventFails() public onlyOwner {
1124         require(lgeEndTimestamp.add(1 days) < block.timestamp, "Liquidity generation grace period still ongoing");
1125         (bool success, ) = msg.sender.call.value(address(this).balance)("");
1126         require(success, "Transfer failed.");
1127     }
1128  
1129     function setDev(address _devAddr) public {
1130         require(_msgSender() == devAddr, '!dev');
1131         devAddr = _devAddr;
1132     }
1133 }