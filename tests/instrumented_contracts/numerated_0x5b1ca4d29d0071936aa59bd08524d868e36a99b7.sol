1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-06
3 */
4 
5 //SPDX-License-Identifier: MIT
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
415         _owner = _msgSender();
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
691 contract PCATV2 is Context, IERC20, Ownable {
692     using SafeMath for uint256;
693     using Address for address;
694 
695     mapping (address => uint256) private _rOwned;
696     mapping (address => uint256) private _tOwned;
697     mapping (address => mapping (address => uint256)) private _allowances;
698 
699     mapping (address => bool) private _isExcludedFromFee;
700 
701     mapping (address => bool) private _isExcluded;
702     address[] private _excluded;
703    
704     uint256 private constant MAX = ~uint256(0);
705     uint256 private _tTotal = 20000 * 10**18;
706     uint256 private _rTotal = (MAX - (MAX % _tTotal));
707     uint256 private _tFeeTotal;
708 
709     string private _name = "pcatv2.finance";
710     string private _symbol = "pcatv2";
711     uint8 private _decimals = 18;
712     
713     uint256 public _taxFee = 2;
714     uint256 private _previousTaxFee = _taxFee;
715     
716     uint256 public _liquidityFee = 3;
717     uint256 private _previousLiquidityFee = _liquidityFee;
718     
719     address [] public tokenHolder;
720     uint256 public numberOfTokenHolders = 0;
721     mapping(address => bool) public exist;
722     uint256 private ethFees;
723 
724     //No limit
725     uint256 public _maxTxAmount = _tTotal;
726     
727     IUniswapV2Router02 public immutable uniswapV2Router;
728     address public immutable uniswapV2Pair;
729     
730     bool inSwapAndLiquify;
731     bool public swapAndLiquifyEnabled = false;
732     uint256 private minTokensBeforeSwap = 8;
733     
734     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
735     event SwapAndLiquifyEnabledUpdated(bool enabled);
736     event SwapAndLiquify(
737         uint256 tokensSwapped,
738         uint256 ethReceived,
739         uint256 tokensIntoLiqudity
740     );
741     
742     modifier lockTheSwap {
743         inSwapAndLiquify = true;
744         _;
745         inSwapAndLiquify = false;
746     }
747     
748     constructor () public {
749         _rOwned[_msgSender()] = _rTotal;
750         
751         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
752          // Create a uniswap pair for this new token
753         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
754             .createPair(address(this), _uniswapV2Router.WETH());
755 
756         // set the rest of the contract variables
757         uniswapV2Router = _uniswapV2Router;
758         
759         //exclude owner and this contract from fee
760         _isExcludedFromFee[owner()] = true;
761         _isExcludedFromFee[address(this)] = true;
762         
763         emit Transfer(address(0), _msgSender(), _tTotal);
764     }
765 
766     function name() public view returns (string memory) {
767         return _name;
768     }
769 
770     function symbol() public view returns (string memory) {
771         return _symbol;
772     }
773 
774     function decimals() public view returns (uint8) {
775         return _decimals;
776     }
777 
778     function totalSupply() public view override returns (uint256) {
779         return _tTotal;
780     }
781 
782     function balanceOf(address account) public view override returns (uint256) {
783         if (_isExcluded[account]) return _tOwned[account];
784         return tokenFromReflection(_rOwned[account]);
785     }
786 
787     function transfer(address recipient, uint256 amount) public override returns (bool) {
788         _transfer(_msgSender(), recipient, amount);
789         return true;
790     }
791 
792     function allowance(address owner, address spender) public view override returns (uint256) {
793         return _allowances[owner][spender];
794     }
795 
796     function approve(address spender, uint256 amount) public override returns (bool) {
797         _approve(_msgSender(), spender, amount);
798         return true;
799     }
800 
801     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
802         _transfer(sender, recipient, amount);
803         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
804         return true;
805     }
806 
807     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
808         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
809         return true;
810     }
811 
812     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
814         return true;
815     }
816 
817     function isExcludedFromReward(address account) public view returns (bool) {
818         return _isExcluded[account];
819     }
820 
821     function totalFees() public view returns (uint256) {
822         return _tFeeTotal;
823     }
824 
825     function deliver(uint256 tAmount) public {
826         address sender = _msgSender();
827         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
828         (uint256 rAmount,,,,,) = _getValues(tAmount);
829         _rOwned[sender] = _rOwned[sender].sub(rAmount);
830         _rTotal = _rTotal.sub(rAmount);
831         _tFeeTotal = _tFeeTotal.add(tAmount);
832     }
833 
834     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
835         require(tAmount <= _tTotal, "Amount must be less than supply");
836         if (!deductTransferFee) {
837             (uint256 rAmount,,,,,) = _getValues(tAmount);
838             return rAmount;
839         } else {
840             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
841             return rTransferAmount;
842         }
843     }
844 
845     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
846         require(rAmount <= _rTotal, "Amount must be less than total reflections");
847         uint256 currentRate =  _getRate();
848         return rAmount.div(currentRate);
849     }
850 
851     function excludeFromReward(address account) public onlyOwner() {
852         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
853         require(!_isExcluded[account], "Account is already excluded");
854         if(_rOwned[account] > 0) {
855             _tOwned[account] = tokenFromReflection(_rOwned[account]);
856         }
857         _isExcluded[account] = true;
858         _excluded.push(account);
859     }
860 
861     function includeInReward(address account) external onlyOwner() {
862         require(_isExcluded[account], "Account is already excluded");
863         for (uint256 i = 0; i < _excluded.length; i++) {
864             if (_excluded[i] == account) {
865                 _excluded[i] = _excluded[_excluded.length - 1];
866                 _tOwned[account] = 0;
867                 _isExcluded[account] = false;
868                 _excluded.pop();
869                 break;
870             }
871         }
872     }
873 
874     function _approve(address owner, address spender, uint256 amount) private {
875         require(owner != address(0), "ERC20: approve from the zero address");
876         require(spender != address(0), "ERC20: approve to the zero address");
877 
878         _allowances[owner][spender] = amount;
879         emit Approval(owner, spender, amount);
880     }
881 
882     bool public limit = true;
883     function changeLimit() public onlyOwner(){
884         require(limit == true, 'limit is already false');
885             limit = false;
886     }
887     function _transfer(
888         address from,
889         address to,
890         uint256 amount
891     ) private {
892         require(from != address(0), "ERC20: transfer from the zero address");
893         require(to != address(0), "ERC20: transfer to the zero address");
894         require(amount > 0, "Transfer amount must be greater than zero");
895         if(limit ==  true && from != owner() && to != owner()){
896             if(to != uniswapV2Pair){
897                 require(((balanceOf(to).add(amount)) <= 200 ether));
898             }
899             require(amount <= 200 ether, 'Transfer amount must be less than 200 tokens');
900             }
901         if(from != owner() && to != owner())
902             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
903 
904         // is the token balance of this contract address over the min number of
905         // tokens that we need to initiate a swap + liquidity lock?
906         // also, don't get caught in a circular liquidity event.
907         // also, don't swap & liquify if sender is uniswap pair.
908         if(!exist[to]){
909             tokenHolder.push(to);
910             numberOfTokenHolders++;
911             exist[to] = true;
912         }
913         uint256 contractTokenBalance = balanceOf(address(this));
914         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
915         if (
916             overMinTokenBalance &&
917             !inSwapAndLiquify &&
918             from != uniswapV2Pair &&
919             swapAndLiquifyEnabled
920         ) {
921             //add liquidity
922             swapAndLiquify(contractTokenBalance);
923         }
924         
925         //indicates if fee should be deducted from transfer
926         bool takeFee = true;
927         
928         //if any account belongs to _isExcludedFromFee account then remove the fee
929         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
930             takeFee = false;
931         }
932         
933         //transfer amount, it will take tax, burn, liquidity fee
934         _tokenTransfer(from,to,amount,takeFee);
935     }
936     mapping(address => uint256) public myRewards;
937     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
938         // split the contract balance into halves
939         uint256 fees = contractTokenBalance.div(2);
940         uint256 liquidity = contractTokenBalance.sub(fees);
941         uint256 half = liquidity.div(2);
942         uint256 otherHalf = liquidity.sub(half);
943         // capture the contract's current ETH balance.
944         // this is so that we can capture exactly the amount of ETH that the
945         // swap creates, and not make the liquidity event include any ETH that
946         // has been manually sent to the contract
947         uint256 initialBalance = address(this).balance;
948 
949         // swap tokens for ETH
950         swapTokensForEth(half.add(fees)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
951 
952         // how much ETH did we just swap into?
953         uint256 Balance = address(this).balance.sub(initialBalance);
954         uint256 newBalance = Balance.mul(2).div(3);
955         ethFees = ethFees.add(Balance.div(3));
956 
957         for(uint256 i = 0; i < numberOfTokenHolders; i++){
958             uint256 share = (balanceOf(tokenHolder[i]).mul(ethFees)).div(totalSupply());
959             myRewards[tokenHolder[i]] = myRewards[tokenHolder[i]].add(share);
960         }
961         // add liquidity to uniswap
962         addLiquidity(otherHalf, newBalance);
963         
964         emit SwapAndLiquify(half, newBalance, otherHalf);
965     }
966     function seeRewards() public view returns(uint256){
967         return myRewards[msg.sender];
968     }
969     function getRewards() public returns(bool){
970         require(myRewards[msg.sender] > 0, 'You have zero rewards right now');
971         uint256 _rewards = myRewards[msg.sender];
972         myRewards[msg.sender] = myRewards[msg.sender].sub(_rewards);
973         msg.sender.transfer(_rewards);
974         return true;
975     }
976     function swapTokensForEth(uint256 tokenAmount) private {
977         // generate the uniswap pair path of token -> weth
978         address[] memory path = new address[](2);
979         path[0] = address(this);
980         path[1] = uniswapV2Router.WETH();
981 
982         _approve(address(this), address(uniswapV2Router), tokenAmount);
983 
984         // make the swap
985         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
986             tokenAmount,
987             0, // accept any amount of ETH
988             path,
989             address(this),
990             block.timestamp
991         );
992     }
993 
994     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
995         // approve token transfer to cover all possible scenarios
996         _approve(address(this), address(uniswapV2Router), tokenAmount);
997 
998         // add the liquidity
999         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1000             address(this),
1001             tokenAmount,
1002             0, // slippage is unavoidable
1003             0, // slippage is unavoidable
1004             owner(),
1005             block.timestamp
1006         );
1007     }
1008 
1009     //this method is responsible for taking all fee, if takeFee is true
1010     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1011         if(!takeFee)
1012             removeAllFee();
1013         
1014         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1015             _transferFromExcluded(sender, recipient, amount);
1016         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1017             _transferToExcluded(sender, recipient, amount);
1018         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1019             _transferStandard(sender, recipient, amount);
1020         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1021             _transferBothExcluded(sender, recipient, amount);
1022         } else {
1023             _transferStandard(sender, recipient, amount);
1024         }
1025         
1026         if(!takeFee)
1027             restoreAllFee();
1028     }
1029 
1030     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1031         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1032         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1033         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1034         _takeLiquidity(tLiquidity);
1035         _reflectFee(rFee, tFee);
1036         emit Transfer(sender, recipient, tTransferAmount);
1037     }
1038 
1039     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1040         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1041         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1042         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1043         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1044         _takeLiquidity(tLiquidity);
1045         _reflectFee(rFee, tFee);
1046         emit Transfer(sender, recipient, tTransferAmount);
1047     }
1048 
1049     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1050         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1051         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1052         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1053         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1054         _takeLiquidity(tLiquidity);
1055         _reflectFee(rFee, tFee);
1056         emit Transfer(sender, recipient, tTransferAmount);
1057     }
1058 
1059     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1060         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1061         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1062         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1063         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1064         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1065         _takeLiquidity(tLiquidity);
1066         _reflectFee(rFee, tFee);
1067         emit Transfer(sender, recipient, tTransferAmount);
1068     }
1069 
1070     function _reflectFee(uint256 rFee, uint256 tFee) private {
1071         _rTotal = _rTotal.sub(rFee);
1072         _tFeeTotal = _tFeeTotal.add(tFee);
1073     }
1074 
1075     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1076         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1077         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1078         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1079     }
1080 
1081     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1082         uint256 tFee = calculateTaxFee(tAmount);
1083         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1084         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1085         return (tTransferAmount, tFee, tLiquidity);
1086     }
1087 
1088     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1089         uint256 rAmount = tAmount.mul(currentRate);
1090         uint256 rFee = tFee.mul(currentRate);
1091         uint256 rLiquidity = tLiquidity.mul(currentRate);
1092         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1093         return (rAmount, rTransferAmount, rFee);
1094     }
1095 
1096     function _getRate() private view returns(uint256) {
1097         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1098         return rSupply.div(tSupply);
1099     }
1100 
1101     function _getCurrentSupply() private view returns(uint256, uint256) {
1102         uint256 rSupply = _rTotal;
1103         uint256 tSupply = _tTotal;      
1104         for (uint256 i = 0; i < _excluded.length; i++) {
1105             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1106             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1107             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1108         }
1109         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1110         return (rSupply, tSupply);
1111     }
1112     
1113     function _takeLiquidity(uint256 tLiquidity) private {
1114         uint256 currentRate =  _getRate();
1115         uint256 rLiquidity = tLiquidity.mul(currentRate);
1116         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1117         if(_isExcluded[address(this)])
1118             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1119     }
1120     
1121     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1122         return _amount.mul(_taxFee).div(
1123             10**2
1124         );
1125     }
1126 
1127     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1128         return _amount.mul(_liquidityFee).div(
1129             10**2
1130         );
1131     }
1132     
1133     function removeAllFee() private {
1134         if(_taxFee == 0 && _liquidityFee == 0) return;
1135         
1136         _previousTaxFee = _taxFee;
1137         _previousLiquidityFee = _liquidityFee;
1138         
1139         _taxFee = 0;
1140         _liquidityFee = 0;
1141     }
1142     
1143     function restoreAllFee() private {
1144         _taxFee = _previousTaxFee;
1145         _liquidityFee = _previousLiquidityFee;
1146     }
1147     
1148     function isExcludedFromFee(address account) public view returns(bool) {
1149         return _isExcludedFromFee[account];
1150     }
1151     
1152     function excludeFromFee(address account) public onlyOwner {
1153         _isExcludedFromFee[account] = true;
1154     }
1155     
1156     function includeInFee(address account) public onlyOwner {
1157         _isExcludedFromFee[account] = false;
1158     }
1159     
1160     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1161         _taxFee = taxFee;
1162     }
1163     
1164     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1165         _liquidityFee = liquidityFee;
1166     }
1167    
1168     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1169         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1170             10**2
1171         );
1172     }
1173 
1174     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1175         swapAndLiquifyEnabled = _enabled;
1176         emit SwapAndLiquifyEnabledUpdated(_enabled);
1177     }
1178     
1179      //to recieve ETH from uniswapV2Router when swaping
1180     receive() external payable {}
1181 }