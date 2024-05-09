1 /**
2  *Submitted for verification at BscScan.com on 2021-05-11
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
479 interface IPancakeFactory {
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
495 // pragma solidity >=0.5.0;
496 
497 interface IPancakePair {
498     event Approval(address indexed owner, address indexed spender, uint value);
499     event Transfer(address indexed from, address indexed to, uint value);
500 
501     function name() external pure returns (string memory);
502     function symbol() external pure returns (string memory);
503     function decimals() external pure returns (uint8);
504     function totalSupply() external view returns (uint);
505     function balanceOf(address owner) external view returns (uint);
506     function allowance(address owner, address spender) external view returns (uint);
507 
508     function approve(address spender, uint value) external returns (bool);
509     function transfer(address to, uint value) external returns (bool);
510     function transferFrom(address from, address to, uint value) external returns (bool);
511 
512     function DOMAIN_SEPARATOR() external view returns (bytes32);
513     function PERMIT_TYPEHASH() external pure returns (bytes32);
514     function nonces(address owner) external view returns (uint);
515 
516     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
517 
518     event Mint(address indexed sender, uint amount0, uint amount1);
519     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
520     event Swap(
521         address indexed sender,
522         uint amount0In,
523         uint amount1In,
524         uint amount0Out,
525         uint amount1Out,
526         address indexed to
527     );
528     event Sync(uint112 reserve0, uint112 reserve1);
529 
530     function MINIMUM_LIQUIDITY() external pure returns (uint);
531     function factory() external view returns (address);
532     function token0() external view returns (address);
533     function token1() external view returns (address);
534     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
535     function price0CumulativeLast() external view returns (uint);
536     function price1CumulativeLast() external view returns (uint);
537     function kLast() external view returns (uint);
538 
539     function mint(address to) external returns (uint liquidity);
540     function burn(address to) external returns (uint amount0, uint amount1);
541     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
542     function skim(address to) external;
543     function sync() external;
544 
545     function initialize(address, address) external;
546 }
547 
548 // pragma solidity >=0.6.2;
549 
550 interface IPancakeRouter01 {
551     function factory() external pure returns (address);
552     function WETH() external pure returns (address);
553 
554     function addLiquidity(
555         address tokenA,
556         address tokenB,
557         uint amountADesired,
558         uint amountBDesired,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline
563     ) external returns (uint amountA, uint amountB, uint liquidity);
564     function addLiquidityETH(
565         address token,
566         uint amountTokenDesired,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
572     function removeLiquidity(
573         address tokenA,
574         address tokenB,
575         uint liquidity,
576         uint amountAMin,
577         uint amountBMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountA, uint amountB);
581     function removeLiquidityETH(
582         address token,
583         uint liquidity,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountToken, uint amountETH);
589     function removeLiquidityWithPermit(
590         address tokenA,
591         address tokenB,
592         uint liquidity,
593         uint amountAMin,
594         uint amountBMin,
595         address to,
596         uint deadline,
597         bool approveMax, uint8 v, bytes32 r, bytes32 s
598     ) external returns (uint amountA, uint amountB);
599     function removeLiquidityETHWithPermit(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountToken, uint amountETH);
608     function swapExactTokensForTokens(
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external returns (uint[] memory amounts);
615     function swapTokensForExactTokens(
616         uint amountOut,
617         uint amountInMax,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external returns (uint[] memory amounts);
622     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
630         external
631         returns (uint[] memory amounts);
632     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636 
637     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
638     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
639     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
640     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
641     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
642 }
643 
644 
645 
646 // pragma solidity >=0.6.2;
647 
648 interface IPancakeRouter02 is IPancakeRouter01 {
649     function removeLiquidityETHSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline
656     ) external returns (uint amountETH);
657     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline,
664         bool approveMax, uint8 v, bytes32 r, bytes32 s
665     ) external returns (uint amountETH);
666 
667     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
668         uint amountIn,
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external;
674     function swapExactETHForTokensSupportingFeeOnTransferTokens(
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external payable;
680     function swapExactTokensForETHSupportingFeeOnTransferTokens(
681         uint amountIn,
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external;
687 }
688 
689 contract GokuInu is Context, IERC20, Ownable {
690     using SafeMath for uint256;
691     using Address for address;
692 
693     mapping (address => uint256) private _rOwned;
694     mapping (address => uint256) private _tOwned;
695     mapping (address => mapping (address => uint256)) private _allowances;
696     mapping (address => bool) private _isExcludedFromFee;
697 
698     mapping (address => bool) private _isExcluded;
699     address[] private _excluded;
700    
701     uint256 private constant MAX = ~uint256(0);
702     uint256 private _tTotal = 100000000000 * 10**6 * 10**9;
703     uint256 private _rTotal = (MAX - (MAX % _tTotal));
704     uint256 private _tFeeTotal;
705 
706     string private _name = "Goku Inu";
707     string private _symbol = "GOKU";
708     uint8 private _decimals = 9;
709     
710     uint256 public _taxFee = 2;
711     uint256 private _previousTaxFee = _taxFee;
712     
713     uint256 public _liquidityFee = 9; //(3% liquidityAddition + 1% rewardsDistribution + 2% devExpenses)
714     uint256 private _previousLiquidityFee = _liquidityFee;
715     
716     address [] public tokenHolder;
717     uint256 public numberOfTokenHolders = 0;
718     mapping(address => bool) public exist;
719 
720     //No limit
721     uint256 public _maxTxAmount = _tTotal;
722     address payable wallet;
723     address payable rewardsWallet;
724     IPancakeRouter02 public pancakeRouter;
725     address public pancakePair;
726     
727     bool inSwapAndLiquify;
728     bool public swapAndLiquifyEnabled = false;
729     uint256 private minTokensBeforeSwap = 8;
730     
731     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
732     event SwapAndLiquifyEnabledUpdated(bool enabled);
733     event SwapAndLiquify(
734         uint256 tokensSwapped,
735         uint256 ethReceived,
736         uint256 tokensIntoLiqudity
737     );
738     
739     modifier lockTheSwap {
740         inSwapAndLiquify = true;
741          _;
742         inSwapAndLiquify = false;
743     }
744     
745     constructor () public {
746         _rOwned[_msgSender()] = _rTotal;
747         wallet = msg.sender;
748         rewardsWallet= msg.sender;
749         
750         //exclude owner and this contract from fee
751         _isExcludedFromFee[owner()] = true;
752         _isExcludedFromFee[address(this)] = true;
753         
754         emit Transfer(address(0), _msgSender(), _tTotal);
755     }
756 
757     // @dev set Pair
758     function setPair(address _pancakePair) external onlyOwner {
759         pancakePair = _pancakePair;
760     }
761 
762     // @dev set Router
763     function setRouter(address _newPancakeRouter) external onlyOwner {
764         IPancakeRouter02 _pancakeRouter = IPancakeRouter02(_newPancakeRouter);
765         pancakeRouter = _pancakeRouter;
766     }
767 
768     function name() public view returns (string memory) {
769         return _name;
770     }
771 
772     function symbol() public view returns (string memory) {
773         return _symbol;
774     }
775 
776     function decimals() public view returns (uint8) {
777         return _decimals;
778     }
779 
780     function totalSupply() public view override returns (uint256) {
781         return _tTotal;
782     }
783 
784     function balanceOf(address account) public view override returns (uint256) {
785         if (_isExcluded[account]) return _tOwned[account];
786         return tokenFromReflection(_rOwned[account]);
787     }
788 
789     function transfer(address recipient, uint256 amount) public override returns (bool) {
790         _transfer(_msgSender(), recipient, amount);
791         return true;
792     }
793 
794     function allowance(address owner, address spender) public view override returns (uint256) {
795         return _allowances[owner][spender];
796     }
797 
798     function approve(address spender, uint256 amount) public override returns (bool) {
799         _approve(_msgSender(), spender, amount);
800         return true;
801     }
802 
803     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
804         _transfer(sender, recipient, amount);
805         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
806         return true;
807     }
808 
809     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
811         return true;
812     }
813 
814     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
815         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
816         return true;
817     }
818 
819     function isExcludedFromReward(address account) public view returns (bool) {
820         return _isExcluded[account];
821     }
822 
823     function totalFees() public view returns (uint256) {
824         return _tFeeTotal;
825     }
826 
827     function deliver(uint256 tAmount) public {
828         address sender = _msgSender();
829         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
830         (uint256 rAmount,,,,,) = _getValues(tAmount);
831         _rOwned[sender] = _rOwned[sender].sub(rAmount);
832         _rTotal = _rTotal.sub(rAmount);
833         _tFeeTotal = _tFeeTotal.add(tAmount);
834     }
835 
836     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
837         require(tAmount <= _tTotal, "Amount must be less than supply");
838         if (!deductTransferFee) {
839             (uint256 rAmount,,,,,) = _getValues(tAmount);
840             return rAmount;
841         } else {
842             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
843             return rTransferAmount;
844         }
845     }
846 
847     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
848         require(rAmount <= _rTotal, "Amount must be less than total reflections");
849         uint256 currentRate =  _getRate();
850         return rAmount.div(currentRate);
851     }
852 
853     function excludeFromReward(address account) public onlyOwner() {
854         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude pancake router.');
855         require(!_isExcluded[account], "Account is already excluded");
856         if(_rOwned[account] > 0) {
857             _tOwned[account] = tokenFromReflection(_rOwned[account]);
858         }
859         _isExcluded[account] = true;
860         _excluded.push(account);
861     }
862 
863     function includeInReward(address account) external onlyOwner() {
864         require(_isExcluded[account], "Account is already excluded");
865         for (uint256 i = 0; i < _excluded.length; i++) {
866             if (_excluded[i] == account) {
867                 _excluded[i] = _excluded[_excluded.length - 1];
868                 _tOwned[account] = 0;
869                 _isExcluded[account] = false;
870                 _excluded.pop();
871                 break;
872             }
873         }
874     }
875     
876     function _approve(address owner, address spender, uint256 amount) private {
877         require(owner != address(0));
878         require(spender != address(0));
879 
880         _allowances[owner][spender] = amount;
881         emit Approval(owner, spender, amount);
882     }
883 
884     bool public limit = true;
885     function changeLimit() public onlyOwner(){
886         require(limit == true, 'limit is already false');
887             limit = false;
888     }
889     
890  
891     
892     function expectedRewards(address _sender) external view returns(uint256){
893         uint256 _balance = address(this).balance;
894         address sender = _sender;
895         uint256 holdersBal = balanceOf(sender);
896         uint totalExcludedBal;
897         for(uint256 i = 0; i<_excluded.length; i++){
898          totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);   
899         }
900         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(pancakePair)).sub(totalExcludedBal));
901         return rewards;
902     }
903     
904     function _transfer(
905         address from,
906         address to,
907         uint256 amount
908     ) private {
909         require(from != address(0), "ERC20: transfer from the zero address");
910         require(to != address(0), "ERC20: transfer to the zero address");
911         require(amount > 0, "Transfer amount must be greater than zero");
912         if(limit ==  true && from != owner() && to != owner()){
913             if(to != pancakePair){
914                 require(((balanceOf(to).add(amount)) <= 500 ether));
915             }
916             require(amount <= 100 ether, 'Transfer amount must be less than 100 tokens');
917             }
918         if(from != owner() && to != owner())
919             require(amount <= _maxTxAmount);
920 
921         // is the token balance of this contract address over the min number of
922         // tokens that we need to initiate a swap + liquidity lock?
923         // also, don't get caught in a circular liquidity event.
924         // also, don't swap & liquify if sender is pancake pair.
925         if(!exist[to]){
926             tokenHolder.push(to);
927             numberOfTokenHolders++;
928             exist[to] = true;
929         }
930         uint256 contractTokenBalance = balanceOf(address(this));
931         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
932         if (
933             overMinTokenBalance &&
934             !inSwapAndLiquify &&
935             from != pancakePair &&
936             swapAndLiquifyEnabled
937         ) {
938             //add liquidity
939             swapAndLiquify(contractTokenBalance);
940         }
941         
942         //indicates if fee should be deducted from transfer
943         bool takeFee = true;
944         
945         //if any account belongs to _isExcludedFromFee account then remove the fee
946         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
947             takeFee = false;
948         }
949         
950         //transfer amount, it will take tax, burn, liquidity fee
951         _tokenTransfer(from,to,amount,takeFee);
952     }
953     mapping(address => uint256) public myRewards;
954     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
955         // split the contract balance into halves
956         uint256 forLiquidity = contractTokenBalance.div(2);
957         uint256 devExp = contractTokenBalance.div(4);
958         uint256 forRewards = contractTokenBalance.div(4);
959         // split the liquidity
960         uint256 half = forLiquidity.div(2);
961         uint256 otherHalf = forLiquidity.sub(half);
962         // capture the contract's current ETH balance.
963         // this is so that we can capture exactly the amount of ETH that the
964         // swap creates, and not make the liquidity event include any ETH that
965         // has been manually sent to the contract
966         uint256 initialBalance = address(this).balance;
967 
968         // swap tokens for ETH
969         swapTokensForEth(half.add(devExp).add(forRewards)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
970 
971         // how much ETH did we just swap into?
972         uint256 Balance = address(this).balance.sub(initialBalance);
973         uint256 oneThird = Balance.div(3);
974         wallet.transfer(oneThird);
975         rewardsWallet.transfer(oneThird);
976        // for(uint256 i = 0; i < numberOfTokenHolders; i++){
977          //   uint256 share = (balanceOf(tokenHolder[i]).mul(ethFees)).div(totalSupply());
978            // myRewards[tokenHolder[i]] = myRewards[tokenHolder[i]].add(share);
979         //}
980         // add liquidity to pancake
981         addLiquidity(otherHalf, oneThird);
982         
983         emit SwapAndLiquify(half, oneThird, otherHalf);
984     }
985        
986 
987      
988   
989     function BNBBalance() external view returns(uint256){
990         return address(this).balance;
991     }
992     function swapTokensForEth(uint256 tokenAmount) private {
993         // generate the pancake pair path of token -> weth
994         address[] memory path = new address[](2);
995         path[0] = address(this);
996         path[1] = pancakeRouter.WETH();
997 
998         _approve(address(this), address(pancakeRouter), tokenAmount);
999 
1000         // make the swap
1001         pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1002             tokenAmount,
1003             0, // accept any amount of ETH
1004             path,
1005             address(this),
1006             block.timestamp
1007         );
1008     }
1009 
1010     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1011         // approve token transfer to cover all possible scenarios
1012         _approve(address(this), address(pancakeRouter), tokenAmount);
1013 
1014         // add the liquidity
1015         pancakeRouter.addLiquidityETH{value: ethAmount}(
1016             address(this),
1017             tokenAmount,
1018             0, // slippage is unavoidable
1019             0, // slippage is unavoidable
1020             owner(),
1021             block.timestamp
1022         );
1023     }
1024 
1025     //this method is responsible for taking all fee, if takeFee is true
1026     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1027         if(!takeFee)
1028             removeAllFee();
1029         
1030         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1031             _transferFromExcluded(sender, recipient, amount);
1032         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1033             _transferToExcluded(sender, recipient, amount);
1034         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1035             _transferStandard(sender, recipient, amount);
1036         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1037             _transferBothExcluded(sender, recipient, amount);
1038         } else {
1039             _transferStandard(sender, recipient, amount);
1040         }
1041         
1042         if(!takeFee)
1043             restoreAllFee();
1044     }
1045 
1046     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1047         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1048         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1049         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1050         _takeLiquidity(tLiquidity);
1051         _reflectFee(rFee, tFee);
1052         emit Transfer(sender, recipient, tTransferAmount);
1053     }
1054 
1055     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1056         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1057         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1058         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1059         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1060         _takeLiquidity(tLiquidity);
1061         _reflectFee(rFee, tFee);
1062         emit Transfer(sender, recipient, tTransferAmount);
1063     }
1064 
1065     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1066         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1067         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1068         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1069         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1070         _takeLiquidity(tLiquidity);
1071         _reflectFee(rFee, tFee);
1072         emit Transfer(sender, recipient, tTransferAmount);
1073     }
1074 
1075     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1076         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1077         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1078         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1079         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1080         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1081         _takeLiquidity(tLiquidity);
1082         _reflectFee(rFee, tFee);
1083         emit Transfer(sender, recipient, tTransferAmount);
1084     }
1085 
1086     function _reflectFee(uint256 rFee, uint256 tFee) private {
1087         _rTotal = _rTotal.sub(rFee);
1088         _tFeeTotal = _tFeeTotal.add(tFee);
1089     }
1090 
1091     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1092         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1093         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1094         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1095     }
1096 
1097     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1098         uint256 tFee = calculateTaxFee(tAmount);
1099         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1100         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1101         return (tTransferAmount, tFee, tLiquidity);
1102     }
1103 
1104     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1105         uint256 rAmount = tAmount.mul(currentRate);
1106         uint256 rFee = tFee.mul(currentRate);
1107         uint256 rLiquidity = tLiquidity.mul(currentRate);
1108         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1109         return (rAmount, rTransferAmount, rFee);
1110     }
1111 
1112     function _getRate() private view returns(uint256) {
1113         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1114         return rSupply.div(tSupply);
1115     }
1116 
1117     function _getCurrentSupply() private view returns(uint256, uint256) {
1118         uint256 rSupply = _rTotal;
1119         uint256 tSupply = _tTotal;      
1120         for (uint256 i = 0; i < _excluded.length; i++) {
1121             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1122             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1123             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1124         }
1125         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1126         return (rSupply, tSupply);
1127     }
1128     
1129     function _takeLiquidity(uint256 tLiquidity) private {
1130         uint256 currentRate =  _getRate();
1131         uint256 rLiquidity = tLiquidity.mul(currentRate);
1132         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1133         if(_isExcluded[address(this)])
1134             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1135     }
1136     
1137     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1138         return _amount.mul(_taxFee).div(
1139             10**2
1140         );
1141     }
1142 
1143     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1144         return _amount.mul(_liquidityFee).div(
1145             10**2
1146         );
1147     }
1148     
1149     function removeAllFee() private {
1150         if(_taxFee == 0 && _liquidityFee == 0) return;
1151         
1152         _previousTaxFee = _taxFee;
1153         _previousLiquidityFee = _liquidityFee;
1154         
1155         _taxFee = 0;
1156         _liquidityFee = 0;
1157     }
1158     
1159     function restoreAllFee() private {
1160         _taxFee = _previousTaxFee;
1161         _liquidityFee = _previousLiquidityFee;
1162     }
1163     
1164     function isExcludedFromFee(address account) public view returns(bool) {
1165         return _isExcludedFromFee[account];
1166     }
1167     
1168     function excludeFromFee(address account) public onlyOwner {
1169         _isExcludedFromFee[account] = true;
1170     }
1171     
1172     function includeInFee(address account) public onlyOwner {
1173         _isExcludedFromFee[account] = false;
1174     }
1175     
1176     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1177          require(taxFee <= 10, "Maximum fee limit is 10 percent");
1178         _taxFee = taxFee;
1179     }
1180     
1181     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1182         require(liquidityFee <= 10, "Maximum fee limit is 10 percent");
1183         _liquidityFee = liquidityFee;
1184     }
1185    
1186     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1187          require(maxTxPercent <= 50, "Maximum tax limit is 10 percent");
1188         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1189             10**2
1190         );
1191     }
1192 
1193     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1194         swapAndLiquifyEnabled = _enabled;
1195         emit SwapAndLiquifyEnabledUpdated(_enabled);
1196     }
1197     
1198      //to recieve ETH from pancakeRouter when swaping
1199     receive() external payable {}
1200 }