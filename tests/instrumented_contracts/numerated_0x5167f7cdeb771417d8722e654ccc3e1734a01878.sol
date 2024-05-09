1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-29
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
689 contract BlastoiseInu is Context, IERC20, Ownable {
690     using SafeMath for uint256;
691     using Address for address;
692 
693     mapping (address => uint256) private _rOwned;
694     mapping (address => uint256) private _tOwned;
695     mapping (address => mapping (address => uint256)) private _allowances;
696     mapping (address => bool) private _isExcludedFromFee;
697 
698     mapping (address => bool) private _isExcluded;
699     mapping (address => User) private cooldown;
700     address[] private _excluded;
701 
702     uint256 private constant MAX = ~uint256(0);
703     uint256 private _tTotal = 100000000000 * 10**6 * 10**9;
704     uint256 private _rTotal = (MAX - (MAX % _tTotal));
705     uint256 private _tFeeTotal;
706 
707     string private _name = "Blastoise Inu";
708     string private _symbol = "BLAST";
709     uint8 private _decimals = 9;
710 
711     uint256 public _taxFee = 1;
712     uint256 private _previousTaxFee = _taxFee;
713 
714     uint256 public _liquidityFee = 9; //(2% liquidityAddition + 3% rewardsDistribution + 5% devExpenses)
715     uint256 private _previousLiquidityFee = _liquidityFee;
716     bool private _cooldownEnabled = true;
717 
718     address [] public tokenHolder;
719     uint256 public numberOfTokenHolders = 0;
720     mapping(address => bool) public exist;
721 
722     mapping (address => bool) private _isBlackListedBot;
723     address[] private _blackListedBots;
724     mapping (address => bool) private bots;
725     mapping (address => bool) private _isBlacklisted;
726 
727     // limit
728     uint256 public _maxTxAmount = 5000000000000 * 10**2 * 10**9; //1.5% after 60% burn
729     address payable wallet;
730     address payable rewardsWallet;
731     IPancakeRouter02 public pancakeRouter;
732     address public pancakePair;
733     uint256 private buyLimitEnd;
734 
735     bool inSwapAndLiquify;
736     bool public swapAndLiquifyEnabled = false;
737     uint256 private minTokensBeforeSwap = 8;
738 
739         struct User {
740         uint256 buy;
741         uint256 sell;
742         bool exists;
743     }
744 
745     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
746     event SwapAndLiquifyEnabledUpdated(bool enabled);
747     event SwapAndLiquify(
748         uint256 tokensSwapped,
749         uint256 ethReceived,
750         uint256 tokensIntoLiqudity
751     );
752     event CooldownEnabledUpdated(bool _cooldown);
753     modifier lockTheSwap {
754         inSwapAndLiquify = true;
755          _;
756         inSwapAndLiquify = false;
757     }
758 
759     constructor (address payable addr1, address payable addr2, address payable addr3) public {
760         _rOwned[_msgSender()] = _rTotal;
761 
762         wallet = addr1;
763         rewardsWallet = addr2;
764 
765         //exclude owner and this contract from fee
766         _isExcludedFromFee[owner()] = true;
767         _isExcludedFromFee[address(this)] = true;
768         _isExcludedFromFee[addr3] = true;
769         _isExcludedFromFee[wallet] = true;
770         _isExcludedFromFee[rewardsWallet] = true;
771 
772         emit Transfer(address(0), _msgSender(), _tTotal);
773     }
774 
775     // @dev set Pair
776     function setPair(address _pancakePair) external onlyOwner {
777         pancakePair = _pancakePair;
778     }
779 
780     // @dev set Router
781     function setRouter(address _newPancakeRouter) external onlyOwner {
782         IPancakeRouter02 _pancakeRouter = IPancakeRouter02(_newPancakeRouter);
783         pancakeRouter = _pancakeRouter;
784     }
785 
786     function name() public view returns (string memory) {
787         return _name;
788     }
789 
790     function symbol() public view returns (string memory) {
791         return _symbol;
792     }
793 
794     function decimals() public view returns (uint8) {
795         return _decimals;
796     }
797 
798     function totalSupply() public view override returns (uint256) {
799         return _tTotal;
800     }
801 
802     function balanceOf(address account) public view override returns (uint256) {
803         if (_isExcluded[account]) return _tOwned[account];
804         return tokenFromReflection(_rOwned[account]);
805     }
806 
807     function transfer(address recipient, uint256 amount) public override returns (bool) {
808         _transfer(_msgSender(), recipient, amount);
809         return true;
810     }
811 
812     function addBotToBlackList(address account) external onlyOwner() {
813         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
814         require(!_isBlackListedBot[account], "Account is already blacklisted");
815         _isBlackListedBot[account] = true;
816         _blackListedBots.push(account);
817     }
818 
819     function removeBotFromBlackList(address account) external onlyOwner() {
820         require(_isBlackListedBot[account], "Account is not blacklisted");
821         for (uint256 i = 0; i < _blackListedBots.length; i++) {
822             if (_blackListedBots[i] == account) {
823                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
824                 _isBlackListedBot[account] = false;
825                 _blackListedBots.pop();
826                 break;
827             }
828         }
829     }
830 
831     function isBlackListed(address account) public view returns (bool) {
832         return _isBlackListedBot[account];
833     }
834 
835     function blacklistSingleWallet(address addresses) public onlyOwner(){
836         if(_isBlacklisted[addresses] == true) return;
837         _isBlacklisted[addresses] = true;
838     }
839 
840     function blacklistMultipleWallets(address[] calldata addresses) public onlyOwner(){
841         for (uint256 i; i < addresses.length; ++i) {
842             _isBlacklisted[addresses[i]] = true;
843         }
844     }
845 
846     function isBlacklisted(address addresses) public view returns (bool){
847         if(_isBlacklisted[addresses] == true) return true;
848         else return false;
849     }
850 
851 
852     function unBlacklistSingleWallet(address addresses) external onlyOwner(){
853          if(_isBlacklisted[addresses] == false) return;
854         _isBlacklisted[addresses] = false;
855     }
856 
857     function unBlacklistMultipleWallets(address[] calldata addresses) public onlyOwner(){
858         for (uint256 i; i < addresses.length; ++i) {
859             _isBlacklisted[addresses[i]] = false;
860         }
861     }
862 
863     function allowance(address owner, address spender) public view override returns (uint256) {
864         return _allowances[owner][spender];
865     }
866 
867     function approve(address spender, uint256 amount) public override returns (bool) {
868         _approve(_msgSender(), spender, amount);
869         return true;
870     }
871 
872     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
873         _transfer(sender, recipient, amount);
874         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
875         return true;
876     }
877 
878     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
879         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
880         return true;
881     }
882 
883     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
884         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
885         return true;
886     }
887 
888     function isExcludedFromReward(address account) public view returns (bool) {
889         return _isExcluded[account];
890     }
891 
892     function totalFees() public view returns (uint256) {
893         return _tFeeTotal;
894     }
895 
896     function deliver(uint256 tAmount) public {
897         address sender = _msgSender();
898         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
899         (uint256 rAmount,,,,,) = _getValues(tAmount);
900         _rOwned[sender] = _rOwned[sender].sub(rAmount);
901         _rTotal = _rTotal.sub(rAmount);
902         _tFeeTotal = _tFeeTotal.add(tAmount);
903     }
904 
905     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
906         require(tAmount <= _tTotal, "Amount must be less than supply");
907         if (!deductTransferFee) {
908             (uint256 rAmount,,,,,) = _getValues(tAmount);
909             return rAmount;
910         } else {
911             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
912             return rTransferAmount;
913         }
914     }
915 
916     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
917         require(rAmount <= _rTotal, "Amount must be less than total reflections");
918         uint256 currentRate =  _getRate();
919         return rAmount.div(currentRate);
920     }
921 
922     function excludeFromReward(address account) public onlyOwner() {
923         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude pancake router.');
924         require(!_isExcluded[account], "Account is already excluded");
925         if(_rOwned[account] > 0) {
926             _tOwned[account] = tokenFromReflection(_rOwned[account]);
927         }
928         _isExcluded[account] = true;
929         _excluded.push(account);
930     }
931 
932     function includeInReward(address account) external onlyOwner() {
933         require(_isExcluded[account], "Account is already excluded");
934         for (uint256 i = 0; i < _excluded.length; i++) {
935             if (_excluded[i] == account) {
936                 _excluded[i] = _excluded[_excluded.length - 1];
937                 _tOwned[account] = 0;
938                 _isExcluded[account] = false;
939                 _excluded.pop();
940                 break;
941             }
942         }
943     }
944 
945     function _approve(address owner, address spender, uint256 amount) private {
946         require(owner != address(0));
947         require(spender != address(0));
948 
949         _allowances[owner][spender] = amount;
950         emit Approval(owner, spender, amount);
951     }
952 
953     bool public limit = true;
954     function changeLimit() public onlyOwner(){
955         require(limit == true, 'limit is already false');
956             limit = false;
957             buyLimitEnd = block.timestamp + (60 seconds);
958     }
959 
960 
961 
962     function expectedRewards(address _sender) external view returns(uint256){
963         uint256 _balance = address(this).balance;
964         address sender = _sender;
965         uint256 holdersBal = balanceOf(sender);
966         uint totalExcludedBal;
967         for(uint256 i = 0; i<_excluded.length; i++){
968          totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);
969         }
970         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(pancakePair)).sub(totalExcludedBal));
971         return rewards;
972     }
973 
974     function _transfer(
975         address from,
976         address to,
977         uint256 amount
978     ) private {
979         require(from != address(0), "ERC20: transfer from the zero address");
980         require(to != address(0), "ERC20: transfer to the zero address");
981         require(amount > 0, "Transfer amount must be greater than zero");
982         require(!_isBlackListedBot[to], "You have no power here!");
983         require(!_isBlackListedBot[from], "You have no power here!");
984         require(_isBlacklisted[from] == false || to == address(0), "You are banned");
985         require(_isBlacklisted[to] == false, "The recipient is banned");
986 
987         if(limit ==  true && from != owner() && to != owner() && !_isExcludedFromFee[to]){
988             if(to != pancakePair){
989                 require(((balanceOf(to).add(amount)) <= 500 ether));
990             }
991             require(amount <= 100 ether, 'Transfer amount must be less than 100 tokens');
992             }
993         if(from != owner() && to != owner() && !_isExcludedFromFee[to]) {
994                         if(_cooldownEnabled) {
995                 if(!cooldown[msg.sender].exists) {
996                     cooldown[msg.sender] = User(0,0,true);
997                 }
998             }
999         }
1000 
1001             // buy
1002             if(from == pancakePair && to != address(pancakeRouter) && !_isExcludedFromFee[to]) {
1003                     if(buyLimitEnd > block.timestamp) {
1004                         require(amount <= _maxTxAmount);
1005                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
1006                         cooldown[to].buy = block.timestamp + (30 seconds);
1007                     }
1008 
1009             }
1010 
1011         // is the token balance of this contract address over the min number of
1012         // tokens that we need to initiate a swap + liquidity lock?
1013         // also, don't get caught in a circular liquidity event.
1014         // also, don't swap & liquify if sender is pancake pair.
1015         if(!exist[to]){
1016             tokenHolder.push(to);
1017             numberOfTokenHolders++;
1018             exist[to] = true;
1019         }
1020         uint256 contractTokenBalance = balanceOf(address(this));
1021         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
1022         if (
1023             overMinTokenBalance &&
1024             !inSwapAndLiquify &&
1025             from != pancakePair &&
1026             swapAndLiquifyEnabled
1027         ) {
1028             //add liquidity
1029             swapAndLiquify(contractTokenBalance);
1030         }
1031 
1032         //indicates if fee should be deducted from transfer
1033         bool takeFee = true;
1034 
1035         //if any account belongs to _isExcludedFromFee account then remove the fee
1036         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1037             takeFee = false;
1038         }
1039 
1040         //transfer amount, it will take tax, burn, liquidity fee
1041         _tokenTransfer(from,to,amount,takeFee);
1042     }
1043     mapping(address => uint256) public myRewards;
1044     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1045         // split the contract balance into halves
1046         uint256 forLiquidity = contractTokenBalance.div(3);
1047         uint256 devExp = contractTokenBalance.div(3);
1048         uint256 forRewards = contractTokenBalance.div(3);
1049         // split the liquidity
1050         uint256 half = forLiquidity.div(2);
1051         uint256 otherHalf = forLiquidity.sub(half);
1052         // capture the contract's current ETH balance.
1053         // this is so that we can capture exactly the amount of ETH that the
1054         // swap creates, and not make the liquidity event include any ETH that
1055         // has been manually sent to the contract
1056         uint256 initialBalance = address(this).balance;
1057 
1058         // swap tokens for ETH
1059         swapTokensForEth(half.add(devExp).add(forRewards)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1060 
1061         // how much ETH did we just swap into?
1062         uint256 Balance = address(this).balance.sub(initialBalance);
1063         uint256 oneThird = Balance.div(3);
1064         wallet.transfer(oneThird);
1065         rewardsWallet.transfer(oneThird);
1066        // for(uint256 i = 0; i < numberOfTokenHolders; i++){
1067          //   uint256 share = (balanceOf(tokenHolder[i]).mul(ethFees)).div(totalSupply());
1068            // myRewards[tokenHolder[i]] = myRewards[tokenHolder[i]].add(share);
1069         //}
1070         // add liquidity to pancake
1071         addLiquidity(otherHalf, oneThird);
1072 
1073         emit SwapAndLiquify(half, oneThird, otherHalf);
1074     }
1075 
1076 
1077 
1078 
1079     function BNBBalance() external view returns(uint256){
1080         return address(this).balance;
1081     }
1082     function swapTokensForEth(uint256 tokenAmount) private {
1083         // generate the pancake pair path of token -> weth
1084         address[] memory path = new address[](2);
1085         path[0] = address(this);
1086         path[1] = pancakeRouter.WETH();
1087 
1088         _approve(address(this), address(pancakeRouter), tokenAmount);
1089 
1090         // make the swap
1091         pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1092             tokenAmount,
1093             0, // accept any amount of ETH
1094             path,
1095             address(this),
1096             block.timestamp
1097         );
1098     }
1099 
1100     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1101         // approve token transfer to cover all possible scenarios
1102         _approve(address(this), address(pancakeRouter), tokenAmount);
1103 
1104         // add the liquidity
1105         pancakeRouter.addLiquidityETH{value: ethAmount}(
1106             address(this),
1107             tokenAmount,
1108             0, // slippage is unavoidable
1109             0, // slippage is unavoidable
1110             owner(),
1111             block.timestamp
1112         );
1113     }
1114 
1115     //this method is responsible for taking all fee, if takeFee is true
1116     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1117         if(!takeFee)
1118             removeAllFee();
1119 
1120         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1121             _transferFromExcluded(sender, recipient, amount);
1122         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1123             _transferToExcluded(sender, recipient, amount);
1124         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1125             _transferStandard(sender, recipient, amount);
1126         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1127             _transferBothExcluded(sender, recipient, amount);
1128         } else {
1129             _transferStandard(sender, recipient, amount);
1130         }
1131 
1132         if(!takeFee)
1133             restoreAllFee();
1134     }
1135 
1136     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1137         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1138         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1139         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1140         _takeLiquidity(tLiquidity);
1141         _reflectFee(rFee, tFee);
1142         emit Transfer(sender, recipient, tTransferAmount);
1143     }
1144 
1145     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1146         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1147         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1148         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1149         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1150         _takeLiquidity(tLiquidity);
1151         _reflectFee(rFee, tFee);
1152         emit Transfer(sender, recipient, tTransferAmount);
1153     }
1154 
1155     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1156         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1157         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1158         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1159         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1160         _takeLiquidity(tLiquidity);
1161         _reflectFee(rFee, tFee);
1162         emit Transfer(sender, recipient, tTransferAmount);
1163     }
1164 
1165     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1166         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1167         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1168         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1169         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1170         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1171         _takeLiquidity(tLiquidity);
1172         _reflectFee(rFee, tFee);
1173         emit Transfer(sender, recipient, tTransferAmount);
1174     }
1175 
1176     function _reflectFee(uint256 rFee, uint256 tFee) private {
1177         _rTotal = _rTotal.sub(rFee);
1178         _tFeeTotal = _tFeeTotal.add(tFee);
1179     }
1180 
1181     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1182         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1183         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1184         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1185     }
1186 
1187     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1188         uint256 tFee = calculateTaxFee(tAmount);
1189         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1190         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1191         return (tTransferAmount, tFee, tLiquidity);
1192     }
1193 
1194     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1195         uint256 rAmount = tAmount.mul(currentRate);
1196         uint256 rFee = tFee.mul(currentRate);
1197         uint256 rLiquidity = tLiquidity.mul(currentRate);
1198         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1199         return (rAmount, rTransferAmount, rFee);
1200     }
1201 
1202     function _getRate() private view returns(uint256) {
1203         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1204         return rSupply.div(tSupply);
1205     }
1206 
1207     function _getCurrentSupply() private view returns(uint256, uint256) {
1208         uint256 rSupply = _rTotal;
1209         uint256 tSupply = _tTotal;
1210         for (uint256 i = 0; i < _excluded.length; i++) {
1211             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1212             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1213             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1214         }
1215         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1216         return (rSupply, tSupply);
1217     }
1218 
1219     function _takeLiquidity(uint256 tLiquidity) private {
1220         uint256 currentRate =  _getRate();
1221         uint256 rLiquidity = tLiquidity.mul(currentRate);
1222         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1223         if(_isExcluded[address(this)])
1224             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1225     }
1226 
1227     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1228         return _amount.mul(_taxFee).div(
1229             10**2
1230         );
1231     }
1232 
1233     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1234         return _amount.mul(_liquidityFee).div(
1235             10**2
1236         );
1237     }
1238 
1239     function removeAllFee() private {
1240         if(_taxFee == 0 && _liquidityFee == 0) return;
1241 
1242         _previousTaxFee = _taxFee;
1243         _previousLiquidityFee = _liquidityFee;
1244 
1245         _taxFee = 0;
1246         _liquidityFee = 0;
1247     }
1248 
1249     function restoreAllFee() private {
1250         _taxFee = _previousTaxFee;
1251         _liquidityFee = _previousLiquidityFee;
1252     }
1253 
1254     function excludeFromFee(address account) public onlyOwner {
1255         _isExcludedFromFee[account] = true;
1256     }
1257 
1258     function includeInFee(address account) public onlyOwner {
1259         _isExcludedFromFee[account] = false;
1260     }
1261 
1262     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1263          require(taxFee <= 10, "Maximum fee limit is 10 percent");
1264         _taxFee = taxFee;
1265     }
1266 
1267     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1268         require(liquidityFee <= 10, "Maximum fee limit is 10 percent");
1269         _liquidityFee = liquidityFee;
1270     }
1271 
1272     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1273          require(maxTxPercent <= 50, "Maximum tax limit is 10 percent");
1274         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1275             10**2
1276         );
1277     }
1278 
1279     function setCooldownEnabled(bool onoff) external onlyOwner() {
1280         _cooldownEnabled = onoff;
1281         emit CooldownEnabledUpdated(_cooldownEnabled);
1282     }
1283 
1284     function manualswap() external {
1285         require(_msgSender() == rewardsWallet);
1286         uint256 contractBalance = balanceOf(address(this));
1287         swapTokensForEth(contractBalance);
1288     }
1289 
1290     function manualSend() external {
1291         uint256 contractETHBalance = address(this).balance;
1292         sendETHToMarketing(contractETHBalance);
1293     }
1294 
1295     function sendETHToMarketing(uint256 amount) private {
1296         wallet.transfer(amount.div(2));
1297         rewardsWallet.transfer(amount.div(2));
1298     }
1299 
1300     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1301         swapAndLiquifyEnabled = _enabled;
1302         emit SwapAndLiquifyEnabledUpdated(_enabled);
1303     }
1304 
1305         function timeToBuy(address buyer) public view returns (uint) {
1306         return block.timestamp - cooldown[buyer].buy;
1307     }
1308 
1309      //to recieve ETH from pancakeRouter when swaping
1310     receive() external payable {}
1311 }