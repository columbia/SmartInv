1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-04
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-05-11
7 */
8 
9 //SPDX-License-Identifier: MIT
10 pragma solidity ^0.6.12;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address payable) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113  
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175         // benefit is lost if 'b' is also tested.
176         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
280         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
281         // for accounts without code, i.e. `keccak256('')`
282         bytes32 codehash;
283         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { codehash := extcodehash(account) }
286         return (codehash != accountHash && codehash != 0x0);
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain`call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332       return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 contract Ownable is Context {
408     address private _owner;
409     address private _previousOwner;
410     uint256 private _lockTime;
411 
412     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
413 
414     /**
415      * @dev Initializes the contract setting the deployer as the initial owner.
416      */
417     constructor () internal {
418         address msgSender = _msgSender();
419         _owner = _msgSender();
420         emit OwnershipTransferred(address(0), msgSender);
421     }
422 
423     /**
424      * @dev Returns the address of the current owner.
425      */
426     function owner() public view returns (address) {
427         return _owner;
428     }
429 
430     /**
431      * @dev Throws if called by any account other than the owner.
432      */
433     modifier onlyOwner() {
434         require(_owner == _msgSender(), "Ownable: caller is not the owner");
435         _;
436     }
437 
438      /**
439      * @dev Leaves the contract without owner. It will not be possible to call
440      * `onlyOwner` functions anymore. Can only be called by the current owner.
441      *
442      * NOTE: Renouncing ownership will leave the contract without an owner,
443      * thereby removing any functionality that is only available to the owner.
444      */
445     function renounceOwnership() public virtual onlyOwner {
446         emit OwnershipTransferred(_owner, address(0));
447         _owner = address(0);
448     }
449 
450     /**
451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
452      * Can only be called by the current owner.
453      */
454     function transferOwnership(address newOwner) public virtual onlyOwner {
455         require(newOwner != address(0), "Ownable: new owner is the zero address");
456         emit OwnershipTransferred(_owner, newOwner);
457         _owner = newOwner;
458     }
459 
460     function geUnlockTime() public view returns (uint256) {
461         return _lockTime;
462     }
463 
464     //Locks the contract for owner for the amount of time provided
465     function lock(uint256 time) public virtual onlyOwner {
466         _previousOwner = _owner;
467         _owner = address(0);
468         _lockTime = now + time;
469         emit OwnershipTransferred(_owner, address(0));
470     }
471     
472     //Unlocks the contract for owner when _lockTime is exceeds
473     function unlock() public virtual {
474         require(_previousOwner == msg.sender, "You don't have permission to unlock");
475         require(now > _lockTime , "Contract is locked until 7 days");
476         emit OwnershipTransferred(_owner, _previousOwner);
477         _owner = _previousOwner;
478     }
479 }
480 
481 // pragma solidity >=0.5.0;
482 
483 interface IPancakeFactory {
484     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
485 
486     function feeTo() external view returns (address);
487     function feeToSetter() external view returns (address);
488 
489     function getPair(address tokenA, address tokenB) external view returns (address pair);
490     function allPairs(uint) external view returns (address pair);
491     function allPairsLength() external view returns (uint);
492 
493     function createPair(address tokenA, address tokenB) external returns (address pair);
494 
495     function setFeeTo(address) external;
496     function setFeeToSetter(address) external;
497 }
498 
499 // pragma solidity >=0.5.0;
500 
501 interface IPancakePair {
502     event Approval(address indexed owner, address indexed spender, uint value);
503     event Transfer(address indexed from, address indexed to, uint value);
504 
505     function name() external pure returns (string memory);
506     function symbol() external pure returns (string memory);
507     function decimals() external pure returns (uint8);
508     function totalSupply() external view returns (uint);
509     function balanceOf(address owner) external view returns (uint);
510     function allowance(address owner, address spender) external view returns (uint);
511 
512     function approve(address spender, uint value) external returns (bool);
513     function transfer(address to, uint value) external returns (bool);
514     function transferFrom(address from, address to, uint value) external returns (bool);
515 
516     function DOMAIN_SEPARATOR() external view returns (bytes32);
517     function PERMIT_TYPEHASH() external pure returns (bytes32);
518     function nonces(address owner) external view returns (uint);
519 
520     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
521 
522     event Mint(address indexed sender, uint amount0, uint amount1);
523     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
524     event Swap(
525         address indexed sender,
526         uint amount0In,
527         uint amount1In,
528         uint amount0Out,
529         uint amount1Out,
530         address indexed to
531     );
532     event Sync(uint112 reserve0, uint112 reserve1);
533 
534     function MINIMUM_LIQUIDITY() external pure returns (uint);
535     function factory() external view returns (address);
536     function token0() external view returns (address);
537     function token1() external view returns (address);
538     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
539     function price0CumulativeLast() external view returns (uint);
540     function price1CumulativeLast() external view returns (uint);
541     function kLast() external view returns (uint);
542 
543     function mint(address to) external returns (uint liquidity);
544     function burn(address to) external returns (uint amount0, uint amount1);
545     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
546     function skim(address to) external;
547     function sync() external;
548 
549     function initialize(address, address) external;
550 }
551 
552 // pragma solidity >=0.6.2;
553 
554 interface IPancakeRouter01 {
555     function factory() external pure returns (address);
556     function WETH() external pure returns (address);
557 
558     function addLiquidity(
559         address tokenA,
560         address tokenB,
561         uint amountADesired,
562         uint amountBDesired,
563         uint amountAMin,
564         uint amountBMin,
565         address to,
566         uint deadline
567     ) external returns (uint amountA, uint amountB, uint liquidity);
568     function addLiquidityETH(
569         address token,
570         uint amountTokenDesired,
571         uint amountTokenMin,
572         uint amountETHMin,
573         address to,
574         uint deadline
575     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
576     function removeLiquidity(
577         address tokenA,
578         address tokenB,
579         uint liquidity,
580         uint amountAMin,
581         uint amountBMin,
582         address to,
583         uint deadline
584     ) external returns (uint amountA, uint amountB);
585     function removeLiquidityETH(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) external returns (uint amountToken, uint amountETH);
593     function removeLiquidityWithPermit(
594         address tokenA,
595         address tokenB,
596         uint liquidity,
597         uint amountAMin,
598         uint amountBMin,
599         address to,
600         uint deadline,
601         bool approveMax, uint8 v, bytes32 r, bytes32 s
602     ) external returns (uint amountA, uint amountB);
603     function removeLiquidityETHWithPermit(
604         address token,
605         uint liquidity,
606         uint amountTokenMin,
607         uint amountETHMin,
608         address to,
609         uint deadline,
610         bool approveMax, uint8 v, bytes32 r, bytes32 s
611     ) external returns (uint amountToken, uint amountETH);
612     function swapExactTokensForTokens(
613         uint amountIn,
614         uint amountOutMin,
615         address[] calldata path,
616         address to,
617         uint deadline
618     ) external returns (uint[] memory amounts);
619     function swapTokensForExactTokens(
620         uint amountOut,
621         uint amountInMax,
622         address[] calldata path,
623         address to,
624         uint deadline
625     ) external returns (uint[] memory amounts);
626     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
627         external
628         payable
629         returns (uint[] memory amounts);
630     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
631         external
632         returns (uint[] memory amounts);
633     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
634         external
635         returns (uint[] memory amounts);
636     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
637         external
638         payable
639         returns (uint[] memory amounts);
640 
641     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
642     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
643     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
644     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
645     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
646 }
647 
648 
649 
650 // pragma solidity >=0.6.2;
651 
652 interface IPancakeRouter02 is IPancakeRouter01 {
653     function removeLiquidityETHSupportingFeeOnTransferTokens(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline
660     ) external returns (uint amountETH);
661     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline,
668         bool approveMax, uint8 v, bytes32 r, bytes32 s
669     ) external returns (uint amountETH);
670 
671     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
672         uint amountIn,
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external;
678     function swapExactETHForTokensSupportingFeeOnTransferTokens(
679         uint amountOutMin,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external payable;
684     function swapExactTokensForETHSupportingFeeOnTransferTokens(
685         uint amountIn,
686         uint amountOutMin,
687         address[] calldata path,
688         address to,
689         uint deadline
690     ) external;
691 }
692 
693 contract CHOPPERINU is Context, IERC20, Ownable {
694     using SafeMath for uint256;
695     using Address for address;
696 
697     mapping (address => uint256) private _rOwned;
698     mapping (address => uint256) private _tOwned;
699     mapping (address => mapping (address => uint256)) private _allowances;
700     mapping (address => bool) private _isExcludedFromFee;
701 
702     mapping (address => bool) private _isExcluded;
703     address[] private _excluded;
704    
705     uint256 private constant MAX = ~uint256(0);
706     uint256 private _tTotal = 100000000000 * 10**6 * 10**9;
707     uint256 private _rTotal = (MAX - (MAX % _tTotal));
708     uint256 private _tFeeTotal;
709 
710     string private _name = "CHOPPER INU";
711     string private _symbol = "CHOPPER";
712     uint8 private _decimals = 9;
713     
714     uint256 public _taxFee = 2;
715     uint256 private _previousTaxFee = _taxFee;
716     
717     uint256 public _liquidityFee = 7; //(3% liquidityAddition + 1% rewardsDistribution + 2% devExpenses)
718     uint256 private _previousLiquidityFee = _liquidityFee;
719     
720     address [] public tokenHolder;
721     uint256 public numberOfTokenHolders = 0;
722     mapping(address => bool) public exist;
723 
724     //No limit
725     uint256 public _maxTxAmount = _tTotal;
726     address payable wallet;
727     address payable rewardsWallet;
728     IPancakeRouter02 public pancakeRouter;
729     address public pancakePair;
730     
731     bool inSwapAndLiquify;
732     bool public swapAndLiquifyEnabled = false;
733     uint256 private minTokensBeforeSwap = 8;
734     
735     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
736     event SwapAndLiquifyEnabledUpdated(bool enabled);
737     event SwapAndLiquify(
738         uint256 tokensSwapped,
739         uint256 ethReceived,
740         uint256 tokensIntoLiqudity
741     );
742     
743     modifier lockTheSwap {
744         inSwapAndLiquify = true;
745          _;
746         inSwapAndLiquify = false;
747     }
748     
749     constructor () public {
750         _rOwned[_msgSender()] = _rTotal;
751         wallet = msg.sender;
752         rewardsWallet= msg.sender;
753         
754         //exclude owner and this contract from fee
755         _isExcludedFromFee[owner()] = true;
756         _isExcludedFromFee[address(this)] = true;
757         
758         emit Transfer(address(0), _msgSender(), _tTotal);
759     }
760 
761     // @dev set Pair
762     function setPair(address _pancakePair) external onlyOwner {
763         pancakePair = _pancakePair;
764     }
765 
766     // @dev set Router
767     function setRouter(address _newPancakeRouter) external onlyOwner {
768         IPancakeRouter02 _pancakeRouter = IPancakeRouter02(_newPancakeRouter);
769         pancakeRouter = _pancakeRouter;
770     }
771 
772     function name() public view returns (string memory) {
773         return _name;
774     }
775 
776     function symbol() public view returns (string memory) {
777         return _symbol;
778     }
779 
780     function decimals() public view returns (uint8) {
781         return _decimals;
782     }
783 
784     function totalSupply() public view override returns (uint256) {
785         return _tTotal;
786     }
787 
788     function balanceOf(address account) public view override returns (uint256) {
789         if (_isExcluded[account]) return _tOwned[account];
790         return tokenFromReflection(_rOwned[account]);
791     }
792 
793     function transfer(address recipient, uint256 amount) public override returns (bool) {
794         _transfer(_msgSender(), recipient, amount);
795         return true;
796     }
797 
798     function allowance(address owner, address spender) public view override returns (uint256) {
799         return _allowances[owner][spender];
800     }
801 
802     function approve(address spender, uint256 amount) public override returns (bool) {
803         _approve(_msgSender(), spender, amount);
804         return true;
805     }
806 
807     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
808         _transfer(sender, recipient, amount);
809         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
810         return true;
811     }
812 
813     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
814         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
815         return true;
816     }
817 
818     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
819         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
820         return true;
821     }
822 
823     function isExcludedFromReward(address account) public view returns (bool) {
824         return _isExcluded[account];
825     }
826 
827     function totalFees() public view returns (uint256) {
828         return _tFeeTotal;
829     }
830 
831     function deliver(uint256 tAmount) public {
832         address sender = _msgSender();
833         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
834         (uint256 rAmount,,,,,) = _getValues(tAmount);
835         _rOwned[sender] = _rOwned[sender].sub(rAmount);
836         _rTotal = _rTotal.sub(rAmount);
837         _tFeeTotal = _tFeeTotal.add(tAmount);
838     }
839 
840     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
841         require(tAmount <= _tTotal, "Amount must be less than supply");
842         if (!deductTransferFee) {
843             (uint256 rAmount,,,,,) = _getValues(tAmount);
844             return rAmount;
845         } else {
846             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
847             return rTransferAmount;
848         }
849     }
850 
851     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
852         require(rAmount <= _rTotal, "Amount must be less than total reflections");
853         uint256 currentRate =  _getRate();
854         return rAmount.div(currentRate);
855     }
856 
857     function excludeFromReward(address account) public onlyOwner() {
858         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude pancake router.');
859         require(!_isExcluded[account], "Account is already excluded");
860         if(_rOwned[account] > 0) {
861             _tOwned[account] = tokenFromReflection(_rOwned[account]);
862         }
863         _isExcluded[account] = true;
864         _excluded.push(account);
865     }
866 
867     function includeInReward(address account) external onlyOwner() {
868         require(_isExcluded[account], "Account is already excluded");
869         for (uint256 i = 0; i < _excluded.length; i++) {
870             if (_excluded[i] == account) {
871                 _excluded[i] = _excluded[_excluded.length - 1];
872                 _tOwned[account] = 0;
873                 _isExcluded[account] = false;
874                 _excluded.pop();
875                 break;
876             }
877         }
878     }
879     
880     function _approve(address owner, address spender, uint256 amount) private {
881         require(owner != address(0));
882         require(spender != address(0));
883 
884         _allowances[owner][spender] = amount;
885         emit Approval(owner, spender, amount);
886     }
887 
888     bool public limit = true;
889     function changeLimit() public onlyOwner(){
890         require(limit == true, 'limit is already false');
891             limit = false;
892     }
893     
894  
895     
896     function expectedRewards(address _sender) external view returns(uint256){
897         uint256 _balance = address(this).balance;
898         address sender = _sender;
899         uint256 holdersBal = balanceOf(sender);
900         uint totalExcludedBal;
901         for(uint256 i = 0; i<_excluded.length; i++){
902          totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);   
903         }
904         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(pancakePair)).sub(totalExcludedBal));
905         return rewards;
906     }
907     
908     function _transfer(
909         address from,
910         address to,
911         uint256 amount
912     ) private {
913         require(from != address(0), "ERC20: transfer from the zero address");
914         require(to != address(0), "ERC20: transfer to the zero address");
915         require(amount > 0, "Transfer amount must be greater than zero");
916         if(limit ==  true && from != owner() && to != owner()){
917             if(to != pancakePair){
918                 require(((balanceOf(to).add(amount)) <= 500 ether));
919             }
920             require(amount <= 100 ether, 'Transfer amount must be less than 100 tokens');
921             }
922         if(from != owner() && to != owner())
923             require(amount <= _maxTxAmount);
924 
925         // is the token balance of this contract address over the min number of
926         // tokens that we need to initiate a swap + liquidity lock?
927         // also, don't get caught in a circular liquidity event.
928         // also, don't swap & liquify if sender is pancake pair.
929         if(!exist[to]){
930             tokenHolder.push(to);
931             numberOfTokenHolders++;
932             exist[to] = true;
933         }
934         uint256 contractTokenBalance = balanceOf(address(this));
935         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
936         if (
937             overMinTokenBalance &&
938             !inSwapAndLiquify &&
939             from != pancakePair &&
940             swapAndLiquifyEnabled
941         ) {
942             //add liquidity
943             swapAndLiquify(contractTokenBalance);
944         }
945         
946         //indicates if fee should be deducted from transfer
947         bool takeFee = true;
948         
949         //if any account belongs to _isExcludedFromFee account then remove the fee
950         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
951             takeFee = false;
952         }
953         
954         //transfer amount, it will take tax, burn, liquidity fee
955         _tokenTransfer(from,to,amount,takeFee);
956     }
957     mapping(address => uint256) public myRewards;
958     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
959         // split the contract balance into halves
960         uint256 forLiquidity = contractTokenBalance.div(2);
961         uint256 devExp = contractTokenBalance.div(4);
962         uint256 forRewards = contractTokenBalance.div(4);
963         // split the liquidity
964         uint256 half = forLiquidity.div(2);
965         uint256 otherHalf = forLiquidity.sub(half);
966         // capture the contract's current ETH balance.
967         // this is so that we can capture exactly the amount of ETH that the
968         // swap creates, and not make the liquidity event include any ETH that
969         // has been manually sent to the contract
970         uint256 initialBalance = address(this).balance;
971 
972         // swap tokens for ETH
973         swapTokensForEth(half.add(devExp).add(forRewards)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
974 
975         // how much ETH did we just swap into?
976         uint256 Balance = address(this).balance.sub(initialBalance);
977         uint256 oneThird = Balance.div(3);
978         wallet.transfer(oneThird);
979         rewardsWallet.transfer(oneThird);
980        // for(uint256 i = 0; i < numberOfTokenHolders; i++){
981          //   uint256 share = (balanceOf(tokenHolder[i]).mul(ethFees)).div(totalSupply());
982            // myRewards[tokenHolder[i]] = myRewards[tokenHolder[i]].add(share);
983         //}
984         // add liquidity to pancake
985         addLiquidity(otherHalf, oneThird);
986         
987         emit SwapAndLiquify(half, oneThird, otherHalf);
988     }
989        
990 
991      
992   
993     function BNBBalance() external view returns(uint256){
994         return address(this).balance;
995     }
996     function swapTokensForEth(uint256 tokenAmount) private {
997         // generate the pancake pair path of token -> weth
998         address[] memory path = new address[](2);
999         path[0] = address(this);
1000         path[1] = pancakeRouter.WETH();
1001 
1002         _approve(address(this), address(pancakeRouter), tokenAmount);
1003 
1004         // make the swap
1005         pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1006             tokenAmount,
1007             0, // accept any amount of ETH
1008             path,
1009             address(this),
1010             block.timestamp
1011         );
1012     }
1013 
1014     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1015         // approve token transfer to cover all possible scenarios
1016         _approve(address(this), address(pancakeRouter), tokenAmount);
1017 
1018         // add the liquidity
1019         pancakeRouter.addLiquidityETH{value: ethAmount}(
1020             address(this),
1021             tokenAmount,
1022             0, // slippage is unavoidable
1023             0, // slippage is unavoidable
1024             owner(),
1025             block.timestamp
1026         );
1027     }
1028 
1029     //this method is responsible for taking all fee, if takeFee is true
1030     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1031         if(!takeFee)
1032             removeAllFee();
1033         
1034         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1035             _transferFromExcluded(sender, recipient, amount);
1036         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1037             _transferToExcluded(sender, recipient, amount);
1038         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1039             _transferStandard(sender, recipient, amount);
1040         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1041             _transferBothExcluded(sender, recipient, amount);
1042         } else {
1043             _transferStandard(sender, recipient, amount);
1044         }
1045         
1046         if(!takeFee)
1047             restoreAllFee();
1048     }
1049 
1050     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1051         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1052         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1053         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1054         _takeLiquidity(tLiquidity);
1055         _reflectFee(rFee, tFee);
1056         emit Transfer(sender, recipient, tTransferAmount);
1057     }
1058 
1059     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1060         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1061         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1062         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1063         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1064         _takeLiquidity(tLiquidity);
1065         _reflectFee(rFee, tFee);
1066         emit Transfer(sender, recipient, tTransferAmount);
1067     }
1068 
1069     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1070         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1071         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1072         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1073         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1074         _takeLiquidity(tLiquidity);
1075         _reflectFee(rFee, tFee);
1076         emit Transfer(sender, recipient, tTransferAmount);
1077     }
1078 
1079     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1080         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1081         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1082         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1083         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1084         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1085         _takeLiquidity(tLiquidity);
1086         _reflectFee(rFee, tFee);
1087         emit Transfer(sender, recipient, tTransferAmount);
1088     }
1089 
1090     function _reflectFee(uint256 rFee, uint256 tFee) private {
1091         _rTotal = _rTotal.sub(rFee);
1092         _tFeeTotal = _tFeeTotal.add(tFee);
1093     }
1094 
1095     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1096         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1097         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1098         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1099     }
1100 
1101     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1102         uint256 tFee = calculateTaxFee(tAmount);
1103         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1104         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1105         return (tTransferAmount, tFee, tLiquidity);
1106     }
1107 
1108     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1109         uint256 rAmount = tAmount.mul(currentRate);
1110         uint256 rFee = tFee.mul(currentRate);
1111         uint256 rLiquidity = tLiquidity.mul(currentRate);
1112         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1113         return (rAmount, rTransferAmount, rFee);
1114     }
1115 
1116     function _getRate() private view returns(uint256) {
1117         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1118         return rSupply.div(tSupply);
1119     }
1120 
1121     function _getCurrentSupply() private view returns(uint256, uint256) {
1122         uint256 rSupply = _rTotal;
1123         uint256 tSupply = _tTotal;      
1124         for (uint256 i = 0; i < _excluded.length; i++) {
1125             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1126             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1127             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1128         }
1129         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1130         return (rSupply, tSupply);
1131     }
1132     
1133     function _takeLiquidity(uint256 tLiquidity) private {
1134         uint256 currentRate =  _getRate();
1135         uint256 rLiquidity = tLiquidity.mul(currentRate);
1136         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1137         if(_isExcluded[address(this)])
1138             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1139     }
1140     
1141     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1142         return _amount.mul(_taxFee).div(
1143             10**2
1144         );
1145     }
1146 
1147     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1148         return _amount.mul(_liquidityFee).div(
1149             10**2
1150         );
1151     }
1152     
1153     function removeAllFee() private {
1154         if(_taxFee == 0 && _liquidityFee == 0) return;
1155         
1156         _previousTaxFee = _taxFee;
1157         _previousLiquidityFee = _liquidityFee;
1158         
1159         _taxFee = 0;
1160         _liquidityFee = 0;
1161     }
1162     
1163     function restoreAllFee() private {
1164         _taxFee = _previousTaxFee;
1165         _liquidityFee = _previousLiquidityFee;
1166     }
1167     
1168     function isExcludedFromFee(address account) public view returns(bool) {
1169         return _isExcludedFromFee[account];
1170     }
1171     
1172     function excludeFromFee(address account) public onlyOwner {
1173         _isExcludedFromFee[account] = true;
1174     }
1175     
1176     function includeInFee(address account) public onlyOwner {
1177         _isExcludedFromFee[account] = false;
1178     }
1179     
1180     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1181          require(taxFee <= 10, "Maximum fee limit is 10 percent");
1182         _taxFee = taxFee;
1183     }
1184     
1185     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1186         require(liquidityFee <= 10, "Maximum fee limit is 10 percent");
1187         _liquidityFee = liquidityFee;
1188     }
1189    
1190     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1191          require(maxTxPercent <= 50, "Maximum tax limit is 10 percent");
1192         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1193             10**2
1194         );
1195     }
1196 
1197     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1198         swapAndLiquifyEnabled = _enabled;
1199         emit SwapAndLiquifyEnabledUpdated(_enabled);
1200     }
1201     
1202      //to recieve ETH from pancakeRouter when swaping
1203     receive() external payable {}
1204 }