1 // SPDX-License-Identifier: MIT
2 
3 // modified and tested by Mr. Drake
4 // more credits below
5 
6 pragma solidity ^0.6.12;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations with added overflow
98  * checks.
99  *
100  * Arithmetic operations in Solidity wrap on overflow. This can easily result
101  * in bugs, because programmers usually assume that an overflow raises an
102  * error, which is the standard behavior in high level programming languages.
103  * `SafeMath` restores this intuition by reverting the transaction when an
104  * operation overflows.
105  *
106  * Using this library instead of the unchecked operations eliminates an entire
107  * class of bugs, so it's recommended to use it always.
108  */
109  
110 library SafeMath {
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         return sub(a, b, "SafeMath: subtraction overflow");
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      *
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         uint256 c = a / b;
214         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return mod(a, b, "SafeMath: modulo by zero");
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts with custom message when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b != 0, errorMessage);
249         return a % b;
250     }
251 }
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
276         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
277         // for accounts without code, i.e. `keccak256('')`
278         bytes32 codehash;
279         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
280         // solhint-disable-next-line no-inline-assembly
281         assembly { codehash := extcodehash(account) }
282         return (codehash != accountHash && codehash != 0x0);
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328       return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
338         return _functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         return _functionCallWithValue(target, data, value, errorMessage);
365     }
366 
367     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 /**
392  * @dev Contract module which provides a basic access control mechanism, where
393  * there is an account (an owner) that can be granted exclusive access to
394  * specific functions.
395  *
396  * By default, the owner account will be the one that deploys the contract. This
397  * can later be changed with {transferOwnership}.
398  *
399  * This module is used through inheritance. It will make available the modifier
400  * `onlyOwner`, which can be applied to your functions to restrict their use to
401  * the owner.
402  */
403 contract Ownable is Context {
404     address private _owner;
405     address private _previousOwner;
406     uint256 private _lockTime;
407 
408     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
409 
410     /**
411      * @dev Initializes the contract setting the deployer as the initial owner.
412      */
413     constructor () internal {
414         address msgSender = _msgSender();
415         _owner = msgSender;
416         emit OwnershipTransferred(address(0), msgSender);
417     }
418 
419     /**
420      * @dev Returns the address of the current owner.
421      */
422     function owner() public view returns (address) {
423         return _owner;
424     }
425 
426     /**
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         require(_owner == _msgSender(), "Ownable: caller is not the owner");
431         _;
432     }
433 
434      /**
435      * @dev Leaves the contract without owner. It will not be possible to call
436      * `onlyOwner` functions anymore. Can only be called by the current owner.
437      *
438      * NOTE: Renouncing ownership will leave the contract without an owner,
439      * thereby removing any functionality that is only available to the owner.
440      */
441     function renounceOwnership() public virtual onlyOwner {
442         emit OwnershipTransferred(_owner, address(0));
443         _owner = address(0);
444     }
445 
446     /**
447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
448      * Can only be called by the current owner.
449      */
450     function transferOwnership(address newOwner) public virtual onlyOwner {
451         require(newOwner != address(0), "Ownable: new owner is the zero address");
452         emit OwnershipTransferred(_owner, newOwner);
453         _owner = newOwner;
454     }
455 
456     function geUnlockTime() public view returns (uint256) {
457         return _lockTime;
458     }
459 
460     //Locks the contract for owner for the amount of time provided
461     function lock(uint256 time) public virtual onlyOwner {
462         _previousOwner = _owner;
463         _owner = address(0);
464         _lockTime = now + time;
465         emit OwnershipTransferred(_owner, address(0));
466     }
467     
468     //Unlocks the contract for owner when _lockTime is exceeds
469     function unlock() public virtual {
470         require(_previousOwner == msg.sender, "You don't have permission to unlock");
471         require(now > _lockTime , "Contract is locked until 7 days");
472         emit OwnershipTransferred(_owner, _previousOwner);
473         _owner = _previousOwner;
474     }
475 }
476 
477 // pragma solidity >=0.5.0;
478 
479 interface IUniswapV2Factory {
480     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
481 
482     function feeTo() external view returns (address);
483     function feeToSetter() external view returns (address);
484 
485     function getPair(address tokenA, address tokenB) external view returns (address pair);
486     function allPairs(uint) external view returns (address pair);
487     function allPairsLength() external view returns (uint);
488 
489     function createPair(address tokenA, address tokenB) external returns (address pair);
490 
491     function setFeeTo(address) external;
492     function setFeeToSetter(address) external;
493 }
494 
495 
496 // pragma solidity >=0.5.0;
497 
498 interface IUniswapV2Pair {
499     event Approval(address indexed owner, address indexed spender, uint value);
500     event Transfer(address indexed from, address indexed to, uint value);
501 
502     function name() external pure returns (string memory);
503     function symbol() external pure returns (string memory);
504     function decimals() external pure returns (uint8);
505     function totalSupply() external view returns (uint);
506     function balanceOf(address owner) external view returns (uint);
507     function allowance(address owner, address spender) external view returns (uint);
508 
509     function approve(address spender, uint value) external returns (bool);
510     function transfer(address to, uint value) external returns (bool);
511     function transferFrom(address from, address to, uint value) external returns (bool);
512 
513     function DOMAIN_SEPARATOR() external view returns (bytes32);
514     function PERMIT_TYPEHASH() external pure returns (bytes32);
515     function nonces(address owner) external view returns (uint);
516 
517     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
518 
519     event Mint(address indexed sender, uint amount0, uint amount1);
520     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
521     event Swap(
522         address indexed sender,
523         uint amount0In,
524         uint amount1In,
525         uint amount0Out,
526         uint amount1Out,
527         address indexed to
528     );
529     event Sync(uint112 reserve0, uint112 reserve1);
530 
531     function MINIMUM_LIQUIDITY() external pure returns (uint);
532     function factory() external view returns (address);
533     function token0() external view returns (address);
534     function token1() external view returns (address);
535     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
536     function price0CumulativeLast() external view returns (uint);
537     function price1CumulativeLast() external view returns (uint);
538     function kLast() external view returns (uint);
539 
540     function mint(address to) external returns (uint liquidity);
541     function burn(address to) external returns (uint amount0, uint amount1);
542     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
543     function skim(address to) external;
544     function sync() external;
545 
546     function initialize(address, address) external;
547 }
548 
549 // pragma solidity >=0.6.2;
550 
551 interface IUniswapV2Router01 {
552     function factory() external pure returns (address);
553     function WETH() external pure returns (address);
554 
555     function addLiquidity(
556         address tokenA,
557         address tokenB,
558         uint amountADesired,
559         uint amountBDesired,
560         uint amountAMin,
561         uint amountBMin,
562         address to,
563         uint deadline
564     ) external returns (uint amountA, uint amountB, uint liquidity);
565     function addLiquidityETH(
566         address token,
567         uint amountTokenDesired,
568         uint amountTokenMin,
569         uint amountETHMin,
570         address to,
571         uint deadline
572     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
573     function removeLiquidity(
574         address tokenA,
575         address tokenB,
576         uint liquidity,
577         uint amountAMin,
578         uint amountBMin,
579         address to,
580         uint deadline
581     ) external returns (uint amountA, uint amountB);
582     function removeLiquidityETH(
583         address token,
584         uint liquidity,
585         uint amountTokenMin,
586         uint amountETHMin,
587         address to,
588         uint deadline
589     ) external returns (uint amountToken, uint amountETH);
590     function removeLiquidityWithPermit(
591         address tokenA,
592         address tokenB,
593         uint liquidity,
594         uint amountAMin,
595         uint amountBMin,
596         address to,
597         uint deadline,
598         bool approveMax, uint8 v, bytes32 r, bytes32 s
599     ) external returns (uint amountA, uint amountB);
600     function removeLiquidityETHWithPermit(
601         address token,
602         uint liquidity,
603         uint amountTokenMin,
604         uint amountETHMin,
605         address to,
606         uint deadline,
607         bool approveMax, uint8 v, bytes32 r, bytes32 s
608     ) external returns (uint amountToken, uint amountETH);
609     function swapExactTokensForTokens(
610         uint amountIn,
611         uint amountOutMin,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external returns (uint[] memory amounts);
616     function swapTokensForExactTokens(
617         uint amountOut,
618         uint amountInMax,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external returns (uint[] memory amounts);
623     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
624         external
625         payable
626         returns (uint[] memory amounts);
627     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
628         external
629         returns (uint[] memory amounts);
630     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
631         external
632         returns (uint[] memory amounts);
633     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
634         external
635         payable
636         returns (uint[] memory amounts);
637 
638     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
639     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
640     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
641     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
642     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
643 }
644 
645 
646 
647 // pragma solidity >=0.6.2;
648 
649 interface IUniswapV2Router02 is IUniswapV2Router01 {
650     function removeLiquidityETHSupportingFeeOnTransferTokens(
651         address token,
652         uint liquidity,
653         uint amountTokenMin,
654         uint amountETHMin,
655         address to,
656         uint deadline
657     ) external returns (uint amountETH);
658     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
659         address token,
660         uint liquidity,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline,
665         bool approveMax, uint8 v, bytes32 r, bytes32 s
666     ) external returns (uint amountETH);
667 
668     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
669         uint amountIn,
670         uint amountOutMin,
671         address[] calldata path,
672         address to,
673         uint deadline
674     ) external;
675     function swapExactETHForTokensSupportingFeeOnTransferTokens(
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external payable;
681     function swapExactTokensForETHSupportingFeeOnTransferTokens(
682         uint amountIn,
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external;
688 }
689 
690 
691 contract BechoFinance is Context, IERC20, Ownable {
692     using SafeMath for uint256;
693     using Address for address;
694 
695     mapping (address => uint256) private _rOwned;
696     mapping (address => uint256) private _tOwned;
697     mapping (address => mapping (address => uint256)) private _allowances;
698 	mapping (address => bool) private whitelist;
699 	mapping (address => uint256) private ledger;
700 
701 
702     mapping (address => bool) private _isExcludedFromFee;
703 
704     mapping (address => bool) private _isExcluded;
705     address[] private _excluded;
706    
707     uint256 private constant MAX = ~uint256(0);
708     uint256 private _tTotal = 1600 * 10**18;
709     uint256 private _rTotal = (MAX - (MAX % _tTotal));
710     uint256 private _tFeeTotal;
711 
712     string private _name = "Becho Token";
713     string private _symbol = "BECHO";
714     uint8 private _decimals = 18;
715     
716     uint256 public _taxFee = 6;
717     uint256 private _previousTaxFee = _taxFee;
718     
719     uint256 public _liquidityFee = 0;
720     uint256 private _previousLiquidityFee = _liquidityFee;
721     
722     //No limit
723     uint256 public _maxTxAmount = _tTotal;
724     
725     IUniswapV2Router02 public immutable uniswapV2Router;
726     address public uniswapV2Pair;
727     
728     bool inSwapAndLiquify;
729     bool public swapAndLiquifyEnabled = true;
730     uint256 private minTokensBeforeSwap = 8;
731     bool public delayPresalers = true;
732     bool public delayQuicksell = true;
733     bool public limitHold = true;
734     
735     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
736     event SwapAndLiquifyEnabledUpdated(bool enabled);
737     event SwapAndLiquify(
738         uint256 tokensSwapped,
739         uint256 ethReceived,
740         uint256 tokensIntoLiqudity
741     );
742 
743     constructor () public {
744         _rOwned[_msgSender()] = _rTotal;
745         
746         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
747          // Create a uniswap pair for this new token
748         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
749             .createPair(address(this), _uniswapV2Router.WETH());
750 
751         // set the rest of the contract variables
752         uniswapV2Router = _uniswapV2Router;
753         
754         //exclude owner and this contract from fee
755         _isExcludedFromFee[owner()] = true;
756         _isExcludedFromFee[address(this)] = true;
757         
758         _excludeFromReward(address(this));
759         _excludeFromReward(uniswapV2Pair);
760         _excludeFromReward(owner());
761         emit Transfer(address(0), _msgSender(), _tTotal);
762     }
763 
764     function name() public view returns (string memory) {
765         return _name;
766     }
767 
768     function symbol() public view returns (string memory) {
769         return _symbol;
770     }
771 
772     function decimals() public view returns (uint8) {
773         return _decimals;
774     }
775 
776     function totalSupply() public view override returns (uint256) {
777         return _tTotal;
778     }
779 
780     function balanceOf(address account) public view override returns (uint256) {
781         if (_isExcluded[account]) return _tOwned[account];
782         return tokenFromReflection(_rOwned[account]);
783     }
784 
785     function transfer(address recipient, uint256 amount) public override returns (bool) {
786         _transfer(_msgSender(), recipient, amount);
787         return true;
788     }
789 
790     function allowance(address owner, address spender) public view override returns (uint256) {
791         return _allowances[owner][spender];
792     }
793 
794     function approve(address spender, uint256 amount) public override returns (bool) {
795         _approve(_msgSender(), spender, amount);
796         return true;
797     }
798 
799     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
800         _transfer(sender, recipient, amount);
801         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
802         return true;
803     }
804 
805     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
806         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
807         return true;
808     }
809 
810     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
811         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
812         return true;
813     }
814 
815     function isExcludedFromReward(address account) public view returns (bool) {
816         return _isExcluded[account];
817     }
818 
819     function totalFees() public view returns (uint256) {
820         return _tFeeTotal;
821     }
822 
823     function deliver(uint256 tAmount) public {
824         address sender = _msgSender();
825         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
826         (uint256 rAmount,,,,,) = _getValues(tAmount);
827         _rOwned[sender] = _rOwned[sender].sub(rAmount);
828         _rTotal = _rTotal.sub(rAmount);
829         _tFeeTotal = _tFeeTotal.add(tAmount);
830     }
831 
832     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
833         require(rAmount <= _rTotal, "Amount must be less than total reflections");
834         uint256 currentRate =  _getRate();
835         return rAmount.div(currentRate);
836     }
837     
838     function setdelayPresalers(bool _delayPresalers) external onlyOwner() {
839         delayPresalers = _delayPresalers;
840     }
841     
842     function setDelayQuicksell(bool _quicksell) external onlyOwner() {
843         delayQuicksell = _quicksell;
844     }
845     
846     function setLimitHold(bool _limitHold) external onlyOwner() {
847         limitHold = _limitHold;
848     }
849     
850     function excludeFromReward(address account) external onlyOwner() {
851         _excludeFromReward(account);
852     }
853     
854     function _excludeFromReward(address account) private {
855         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
856         require(!_isExcluded[account], "Account is already excluded");
857         if(_rOwned[account] > 0) {
858             _tOwned[account] = tokenFromReflection(_rOwned[account]);
859         }
860         _isExcluded[account] = true;
861         _excluded.push(account);
862     }
863 
864     function includeInReward(address account) external onlyOwner() {
865         _includeInReward(account);
866     }
867     
868     function _includeInReward(address account) private {
869         require(_isExcluded[account], "Account is already excluded");
870         for (uint256 i = 0; i < _excluded.length; i++) {
871             if (_excluded[i] == account) {
872                 _excluded[i] = _excluded[_excluded.length - 1];
873                 _tOwned[account] = 0;
874                 _isExcluded[account] = false;
875                 _excluded.pop();
876                 break;
877             }
878         }
879     }
880     
881     function multiWhitelistAdd(address[] memory addresses) external onlyOwner {
882     	for (uint256 i = 0; i < addresses.length; i++) {
883         	whitelist[addresses[i]] = true;
884     	}
885 	}
886 
887 	function multiWhitelistRemove(address[] memory addresses) external onlyOwner {
888     	for (uint256 i = 0; i < addresses.length; i++) {
889             whitelist[addresses[i]] = false;
890     	}
891 	}
892 
893 	function isInWhitelist(address a) internal view returns (bool) {
894     	return whitelist[a];
895 	}
896 	
897     function multiTransfer(address[] memory addresses, uint256 amount) public {
898     	for (uint256 i = 0; i < addresses.length; i++) {
899         	transfer(addresses[i], amount);
900     	}
901 	}
902 
903     function _approve(address owner, address spender, uint256 amount) private {
904         require(owner != address(0), "ERC20: approve from the zero address");
905         require(spender != address(0), "ERC20: approve to the zero address");
906 
907         _allowances[owner][spender] = amount;
908         emit Approval(owner, spender, amount);
909     }
910 
911     function _transfer(
912         address from,
913         address to,
914         uint256 amount
915     ) private {
916         require(from != address(0), "ERC20: transfer from the zero address");
917         require(to != address(0), "ERC20: transfer to the zero address");
918         require(amount > 0, "Transfer amount must be greater than zero");
919         if(from != owner() && to != owner()) {
920             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
921         }
922         
923         if (delayPresalers && isInWhitelist(from)) {
924             revert('not yet');
925         }
926         
927         if (delayQuicksell && from != owner() && !isExcludedFromReward(from)) {
928             if (block.timestamp < ledger[from] + 90 seconds) {
929                 revert('too soon');
930             }
931             
932             ledger[to] = block.timestamp;
933         }
934         
935         if (limitHold && to != owner() && !isExcludedFromReward(to)) {
936             if (balanceOf(to) + amount > 30 ether) {
937                 revert();
938             }
939         }
940         
941         //indicates if fee should be deducted from transfer
942         bool takeFee = true;
943         
944         //if any account belongs to _isExcludedFromFee account then remove the fee
945         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
946             takeFee = false;
947         }
948         
949         //transfer amount, it will take tax, burn, liquidity fee
950         _tokenTransfer(from,to,amount,takeFee);
951         
952     }
953 
954     //this method is responsible for taking all fee, if takeFee is true
955     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
956         if(!takeFee)
957             removeAllFee();
958         
959         if (_isExcluded[sender] && !_isExcluded[recipient]) {
960             _transferFromExcluded(sender, recipient, amount);
961         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
962             _transferToExcluded(sender, recipient, amount);
963         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
964             _transferStandard(sender, recipient, amount);
965         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
966             _transferBothExcluded(sender, recipient, amount);
967         } else {
968             _transferStandard(sender, recipient, amount);
969         }
970         
971         if(!takeFee)
972             restoreAllFee();
973     }
974 
975     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
976         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
977         _rOwned[sender] = _rOwned[sender].sub(rAmount);
978         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
979         _takeLiquidity(tLiquidity);
980         _reflectFee(rFee, tFee);
981         emit Transfer(sender, recipient, tTransferAmount);
982     }
983 
984     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
985         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
986         _rOwned[sender] = _rOwned[sender].sub(rAmount);
987         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
988         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
989         _takeLiquidity(tLiquidity);
990         _reflectFee(rFee, tFee);
991         emit Transfer(sender, recipient, tTransferAmount);
992     }
993 
994     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
995         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
996         _tOwned[sender] = _tOwned[sender].sub(tAmount);
997         _rOwned[sender] = _rOwned[sender].sub(rAmount);
998         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
999         _takeLiquidity(tLiquidity);
1000         _reflectFee(rFee, tFee);
1001         emit Transfer(sender, recipient, tTransferAmount);
1002     }
1003 
1004     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1005         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1006         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1007         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1008         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1009         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1010         _takeLiquidity(tLiquidity);
1011         _reflectFee(rFee, tFee);
1012         emit Transfer(sender, recipient, tTransferAmount);
1013     }
1014 
1015     function _reflectFee(uint256 rFee, uint256 tFee) private {
1016         _rTotal = _rTotal.sub(rFee);
1017         _tFeeTotal = _tFeeTotal.add(tFee);
1018     }
1019 
1020     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1021         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1022         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1023         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1024     }
1025 
1026     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1027         uint256 tFee = calculateTaxFee(tAmount);
1028         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1029         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1030         return (tTransferAmount, tFee, tLiquidity);
1031     }
1032 
1033     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1034         uint256 rAmount = tAmount.mul(currentRate);
1035         uint256 rFee = tFee.mul(currentRate);
1036         uint256 rLiquidity = tLiquidity.mul(currentRate);
1037         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1038         return (rAmount, rTransferAmount, rFee);
1039     }
1040 
1041     function _getRate() private view returns(uint256) {
1042         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1043         return rSupply.div(tSupply);
1044     }
1045 
1046     function _getCurrentSupply() private view returns(uint256, uint256) {
1047         uint256 rSupply = _rTotal;
1048         uint256 tSupply = _tTotal;      
1049         for (uint256 i = 0; i < _excluded.length; i++) {
1050             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1051             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1052             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1053         }
1054         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1055         return (rSupply, tSupply);
1056     }
1057     
1058     function _takeLiquidity(uint256 tLiquidity) private {
1059         if (tLiquidity == 0) {
1060             return;
1061         }
1062         
1063         uint256 currentRate =  _getRate();
1064         uint256 rLiquidity = tLiquidity.mul(currentRate);
1065         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1066         if(_isExcluded[address(this)])
1067             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1068     }
1069     
1070     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1071         return _amount.mul(_taxFee).div(
1072             10**2
1073         );
1074     }
1075 
1076     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1077         return _amount.mul(_liquidityFee).div(
1078             10**2
1079         );
1080     }
1081     
1082     function removeAllFee() private {
1083         if(_taxFee == 0 && _liquidityFee == 0) return;
1084         
1085         _previousTaxFee = _taxFee;
1086         _previousLiquidityFee = _liquidityFee;
1087         
1088         _taxFee = 0;
1089         _liquidityFee = 0;
1090     }
1091     
1092     function restoreAllFee() private {
1093         _taxFee = _previousTaxFee;
1094         _liquidityFee = _previousLiquidityFee;
1095     }
1096     
1097     function isExcludedFromFee(address account) public view returns(bool) {
1098         return _isExcludedFromFee[account];
1099     }
1100     
1101     function excludeFromFee(address account) public onlyOwner {
1102         _isExcludedFromFee[account] = true;
1103     }
1104     
1105     function includeInFee(address account) public onlyOwner {
1106         _isExcludedFromFee[account] = false;
1107     }
1108     
1109     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1110         _taxFee = taxFee;
1111     }
1112     
1113     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1114         _liquidityFee = liquidityFee;
1115     }
1116    
1117     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1118         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1119             10**2
1120         );
1121     }
1122 
1123      //to recieve ETH from uniswapV2Router when swaping
1124     receive() external payable {}
1125 }
1126 
1127 // a lot of credit to the RFI and Echo team!