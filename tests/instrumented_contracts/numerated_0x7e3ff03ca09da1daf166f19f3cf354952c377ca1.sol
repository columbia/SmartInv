1 pragma solidity ^0.6.12;
2 
3 // Copy of Safemoon with code refactoring, auditing and added features 
4 // 
5 // SafeMoon fixes:
6 // 1. Corrected incorrect error message in function includeInReward 
7 // 2. Removed redundant code in function _tokenTransfer
8 // 3. Contract gains small amount of unwithdrawable ETH/BNB when swapping so added a 
9 //    withdrawOverFlowETH function so that the owner can withdraw this periodically.
10 // 4. to address of the uniswapV2Router.addLiquidityETH function call replaced by 
11 //    thecontract itself, i.e. address(this) so that the LP created by swap is locked forever.
12 // 5. Fixed typos
13 
14 // Refactoring: 
15 // 1.1 Changed the contructor function into a initialize function that can only be called once. 
16 // 1.2 All the contracts variables are now only initialized once init has been called. 
17 // This change is so that we can use EIP-1167 to create new tokens in the future with the same
18 // bytecode and allow easy creation of tokens using this code.
19 
20 // Added features: 
21 // 1. Added internal function transferOwnershipFromInitialized is called from init which changes
22 //    the owner from the deployer to whomever address you want. Init and transferOwnershipFromInitialized 
23 //    can only be called once.
24 
25 // 2. Added extra fee that is set in init and allows the initializer to set an address to 
26 //    receive the extra fee and set the extra fee % (This can be used for additional burn / charity / dev)
27 
28 // SPDX-License-Identifier: Unlicensed
29 interface IERC20 {
30 
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
257 abstract contract Context {
258     function _msgSender() internal view virtual returns (address payable) {
259         return msg.sender;
260     }
261 
262     function _msgData() internal view virtual returns (bytes memory) {
263         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
264         return msg.data;
265     }
266 }
267 
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344       return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 /**
408  * @dev Contract module which provides a basic access control mechanism, where
409  * there is an account (an owner) that can be granted exclusive access to
410  * specific functions.
411  *
412  * By default, the owner account will be the one that deploys the contract. This
413  * can later be changed with {transferOwnership}.
414  *
415  * This module is used through inheritance. It will make available the modifier
416  * `onlyOwner`, which can be applied to your functions to restrict their use to
417  * the owner.
418  */
419 contract Ownable is Context {
420     address private _owner;
421     address private _previousOwner;
422     uint256 private _lockTime;
423     
424     bool private initializedtonewowner = false;
425 
426     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
427 
428     /**
429      * @dev Initializes the contract setting the deployer as the initial owner.
430      */
431     constructor () internal {
432         address msgSender = _msgSender();
433         _owner = msgSender;
434         emit OwnershipTransferred(address(0), msgSender);
435     }
436 
437     /**
438      * @dev Returns the address of the current owner.
439      */
440     function owner() public view returns (address) {
441         return _owner;
442     }
443 
444     /**
445      * @dev Throws if called by any account other than the owner.
446      */
447     modifier onlyOwner() {
448         require(_owner == _msgSender(), "Ownable: caller is not the owner");
449         _;
450     }
451 
452      /**
453      * @dev Leaves the contract without owner. It will not be possible to call
454      * `onlyOwner` functions anymore. Can only be called by the current owner.
455      *
456      * NOTE: Renouncing ownership will leave the contract without an owner,
457      * thereby removing any functionality that is only available to the owner.
458      */
459     function renounceOwnership() public virtual onlyOwner {
460         emit OwnershipTransferred(_owner, address(0));
461         _owner = address(0);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public virtual onlyOwner {
469         require(newOwner != address(0), "Ownable: new owner is the zero address");
470         emit OwnershipTransferred(_owner, newOwner);
471         _owner = newOwner;
472     }
473     
474     function transferOwnershipFromInitialized(address newOwner) internal virtual {
475         require(!initializedtonewowner, "Contract owner has already been transfered from initialized to the new Owner");
476         initializedtonewowner = true;
477         require(newOwner != address(0), "Ownable: new owner is the zero address");
478         emit OwnershipTransferred(_owner, newOwner);
479         _owner = newOwner;
480     }
481 
482 }
483 
484 // pragma solidity >=0.5.0;
485 
486 interface IUniswapV2Factory {
487     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
488 
489     function feeTo() external view returns (address);
490     function feeToSetter() external view returns (address);
491 
492     function getPair(address tokenA, address tokenB) external view returns (address pair);
493     function allPairs(uint) external view returns (address pair);
494     function allPairsLength() external view returns (uint);
495 
496     function createPair(address tokenA, address tokenB) external returns (address pair);
497 
498     function setFeeTo(address) external;
499     function setFeeToSetter(address) external;
500 }
501 
502 
503 // pragma solidity >=0.5.0;
504 
505 interface IUniswapV2Pair {
506     event Approval(address indexed owner, address indexed spender, uint value);
507     event Transfer(address indexed from, address indexed to, uint value);
508 
509     function name() external pure returns (string memory);
510     function symbol() external pure returns (string memory);
511     function decimals() external pure returns (uint8);
512     function totalSupply() external view returns (uint);
513     function balanceOf(address owner) external view returns (uint);
514     function allowance(address owner, address spender) external view returns (uint);
515 
516     function approve(address spender, uint value) external returns (bool);
517     function transfer(address to, uint value) external returns (bool);
518     function transferFrom(address from, address to, uint value) external returns (bool);
519 
520     function DOMAIN_SEPARATOR() external view returns (bytes32);
521     function PERMIT_TYPEHASH() external pure returns (bytes32);
522     function nonces(address owner) external view returns (uint);
523 
524     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
525 
526     event Mint(address indexed sender, uint amount0, uint amount1);
527     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
528     event Swap(
529         address indexed sender,
530         uint amount0In,
531         uint amount1In,
532         uint amount0Out,
533         uint amount1Out,
534         address indexed to
535     );
536     event Sync(uint112 reserve0, uint112 reserve1);
537 
538     function MINIMUM_LIQUIDITY() external pure returns (uint);
539     function factory() external view returns (address);
540     function token0() external view returns (address);
541     function token1() external view returns (address);
542     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
543     function price0CumulativeLast() external view returns (uint);
544     function price1CumulativeLast() external view returns (uint);
545     function kLast() external view returns (uint);
546 
547     function mint(address to) external returns (uint liquidity);
548     function burn(address to) external returns (uint amount0, uint amount1);
549     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
550     function skim(address to) external;
551     function sync() external;
552 
553     function initialize(address, address) external;
554 }
555 
556 // pragma solidity >=0.6.2;
557 
558 interface IUniswapV2Router01 {
559     function factory() external pure returns (address);
560     function WETH() external pure returns (address);
561 
562     function addLiquidity(
563         address tokenA,
564         address tokenB,
565         uint amountADesired,
566         uint amountBDesired,
567         uint amountAMin,
568         uint amountBMin,
569         address to,
570         uint deadline
571     ) external returns (uint amountA, uint amountB, uint liquidity);
572     function addLiquidityETH(
573         address token,
574         uint amountTokenDesired,
575         uint amountTokenMin,
576         uint amountETHMin,
577         address to,
578         uint deadline
579     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
580     function removeLiquidity(
581         address tokenA,
582         address tokenB,
583         uint liquidity,
584         uint amountAMin,
585         uint amountBMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountA, uint amountB);
589     function removeLiquidityETH(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountToken, uint amountETH);
597     function removeLiquidityWithPermit(
598         address tokenA,
599         address tokenB,
600         uint liquidity,
601         uint amountAMin,
602         uint amountBMin,
603         address to,
604         uint deadline,
605         bool approveMax, uint8 v, bytes32 r, bytes32 s
606     ) external returns (uint amountA, uint amountB);
607     function removeLiquidityETHWithPermit(
608         address token,
609         uint liquidity,
610         uint amountTokenMin,
611         uint amountETHMin,
612         address to,
613         uint deadline,
614         bool approveMax, uint8 v, bytes32 r, bytes32 s
615     ) external returns (uint amountToken, uint amountETH);
616     function swapExactTokensForTokens(
617         uint amountIn,
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external returns (uint[] memory amounts);
623     function swapTokensForExactTokens(
624         uint amountOut,
625         uint amountInMax,
626         address[] calldata path,
627         address to,
628         uint deadline
629     ) external returns (uint[] memory amounts);
630     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
631         external
632         payable
633         returns (uint[] memory amounts);
634     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
635         external
636         returns (uint[] memory amounts);
637     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
638         external
639         returns (uint[] memory amounts);
640     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
641         external
642         payable
643         returns (uint[] memory amounts);
644 
645     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
646     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
647     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
648     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
649     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
650 }
651 
652 
653 
654 // pragma solidity >=0.6.2;
655 
656 interface IUniswapV2Router02 is IUniswapV2Router01 {
657     function removeLiquidityETHSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline
664     ) external returns (uint amountETH);
665     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
666         address token,
667         uint liquidity,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         uint deadline,
672         bool approveMax, uint8 v, bytes32 r, bytes32 s
673     ) external returns (uint amountETH);
674 
675     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
676         uint amountIn,
677         uint amountOutMin,
678         address[] calldata path,
679         address to,
680         uint deadline
681     ) external;
682     function swapExactETHForTokensSupportingFeeOnTransferTokens(
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external payable;
688     function swapExactTokensForETHSupportingFeeOnTransferTokens(
689         uint amountIn,
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external;
695 }
696 
697 
698 contract initializedERC20 is Context, IERC20, Ownable {
699     using SafeMath for uint256;
700     using Address for address;
701 
702     mapping (address => uint256) private _rOwned;
703     mapping (address => uint256) private _tOwned;
704     mapping (address => mapping (address => uint256)) private _allowances;
705 
706     mapping (address => bool) private _isExcludedFromFee;
707 
708     mapping (address => bool) private _isExcluded;
709     address[] private _excluded;
710    
711     uint256 private constant MAX = ~uint256(0);
712                               
713                               
714     uint256 private _tTotal;
715     uint256 private _rTotal;
716     uint256 private _tFeeTotal;
717     uint256 private _xFeeTotal;
718 
719     string private _name;
720     string private _symbol;
721     uint8 private _decimals;
722     
723     uint256 public _taxFee;
724     uint256 private _previousTaxFee;
725     
726   
727     
728     uint256 public _liquidityFee;
729     uint256 private _previousLiquidityFee;
730     
731     
732     address public _extrafeewallet;
733     uint256 public _extraFeePercent;
734     uint256 public _previousExtraFeePercent;
735         
736     IUniswapV2Router02 public uniswapV2Router;
737     address public uniswapV2Pair;
738     
739     bool inSwapAndLiquify;
740     bool public swapAndLiquifyEnabled = false;
741     
742     uint256 public _maxTxAmount;
743     // the min number of
744     // tokens that we need to initiate a swap + liquidity lock (normally 0.5% > 0.1% of total supply)
745     uint256 private numTokensSellToAddToLiquidity;
746     
747     bool private initialized;
748     
749     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
750     event SwapAndLiquifyEnabledUpdated(bool enabled);
751     event SwapAndLiquify(
752         uint256 tokensSwapped,
753         uint256 bnbReceived,
754         uint256 tokensIntoLiquidity
755     );
756     
757     modifier lockTheSwap {
758         inSwapAndLiquify = true;
759         _;
760         inSwapAndLiquify = false;
761     }
762     
763     // require(bytes(name).length == 0); // ensure not init'd already.
764     // require(bytes(_name).length > 0);
765     
766     function init(string memory name, string memory symbol, uint256 totalsupply, uint8 decimals, uint256 maxtxamount, uint256 taxFee, uint256 liquidityFee, uint256 numtokenstoselltoaddtoliquidity, address extrafeewallet, uint256 extrafeepercent, address newContractOwner) public {
767         require(!initialized, "Contract instance has already been initialized");
768         require(extrafeewallet != newContractOwner, "Extra Fee wallet must not be your wallet address");
769         
770         initialized = true;
771         
772         transferOwnershipFromInitialized(newContractOwner);
773         
774         _name = name;
775         _symbol = symbol;
776         _decimals = decimals;
777         uint256 decimalmulty = _decimals;
778         _tTotal = totalsupply * (10**decimalmulty);
779         _rTotal = (MAX - (MAX % _tTotal));
780         _maxTxAmount = maxtxamount * (10**decimalmulty);
781         numTokensSellToAddToLiquidity = numtokenstoselltoaddtoliquidity * (10**decimalmulty);
782         _taxFee = taxFee;
783         _previousTaxFee = _taxFee;
784         _liquidityFee = liquidityFee;
785         _previousLiquidityFee = _liquidityFee;
786         
787         _rOwned[newContractOwner] = _rTotal; 
788         
789         _extrafeewallet = extrafeewallet; 
790         _extraFeePercent = extrafeepercent;
791         _previousExtraFeePercent = _extraFeePercent;
792         
793         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // --> TODO: Kovan or Eth PROD
794         
795         // NOTE: Auto-lock LP when creating the pair
796         // Create a uniswap pair for this new token
797         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
798             .createPair(address(this), _uniswapV2Router.WETH());
799 
800         // set the rest of the contract variables
801         uniswapV2Router = _uniswapV2Router;
802         
803         //exclude owner and this contract from fee
804         _isExcludedFromFee[owner()] = true;
805         _isExcludedFromFee[address(this)] = true;
806         
807         
808         emit Transfer(address(0), newContractOwner, _tTotal);
809     }
810   
811 
812 
813     function getETHBalance() public view returns(uint) {
814         return address(this).balance;
815     }
816 
817     function withdrawOverFlowETH() public onlyOwner {
818         address payable to = payable(msg.sender);
819         to.transfer(getETHBalance());
820     }
821     
822 
823     function name() public view returns (string memory) {
824         return _name;
825     }
826 
827     function symbol() public view returns (string memory) {
828         return _symbol;
829     }
830 
831     function decimals() public view returns (uint8) {
832         return _decimals;
833     }
834 
835     function totalSupply() public view override returns (uint256) {
836         return _tTotal;
837     }
838 
839     function balanceOf(address account) public view override returns (uint256) {
840         if (_isExcluded[account]) return _tOwned[account];
841         return tokenFromReflection(_rOwned[account]);
842     }
843 
844     function transfer(address recipient, uint256 amount) public override returns (bool) {
845         _transfer(_msgSender(), recipient, amount);
846         return true;
847     }
848 
849     function allowance(address owner, address spender) public view override returns (uint256) {
850         return _allowances[owner][spender];
851     }
852 
853     function approve(address spender, uint256 amount) public override returns (bool) {
854         _approve(_msgSender(), spender, amount);
855         return true;
856     }
857 
858     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
859         _transfer(sender, recipient, amount);
860         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
861         return true;
862     }
863 
864     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
865         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
866         return true;
867     }
868 
869     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
870         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
871         return true;
872     }
873 
874     function isExcludedFromReward(address account) public view returns (bool) {
875         return _isExcluded[account];
876     }
877 
878     function taxFees() public view returns (uint256) {
879         return _tFeeTotal;
880     }
881     
882     function xFees() public view returns (uint256) {
883         return _xFeeTotal;
884     }
885     
886 
887     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
888         require(tAmount <= _tTotal, "Amount must be less than supply");
889         if (!deductTransferFee) {
890             (uint256 rAmount,,,,,) = _getValues(tAmount);
891             return rAmount;
892         } else {
893             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
894             return rTransferAmount;
895         }
896     }
897 
898     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
899         require(rAmount <= _rTotal, "Amount must be less than total reflections");
900         uint256 currentRate =  _getRate();
901         return rAmount.div(currentRate);
902     }
903 
904     function excludeFromReward(address account) public onlyOwner() {
905         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
906         require(!_isExcluded[account], "Account is already excluded");
907         if(_rOwned[account] > 0) {
908             _tOwned[account] = tokenFromReflection(_rOwned[account]);
909         }
910         _isExcluded[account] = true;
911         _excluded.push(account);
912     }
913 
914     function includeInReward(address account) external onlyOwner() {
915         require(_isExcluded[account], "Account is not excluded");
916         for (uint256 i = 0; i < _excluded.length; i++) {
917             if (_excluded[i] == account) {
918                 _excluded[i] = _excluded[_excluded.length - 1];
919                 _tOwned[account] = 0;
920                 _isExcluded[account] = false;
921                 _excluded.pop();
922                 break;
923             }
924         }
925     }
926         
927     
928         function excludeFromFee(address account) public onlyOwner {
929         _isExcludedFromFee[account] = true;
930     }
931     
932     function includeInFee(address account) public onlyOwner {
933         _isExcludedFromFee[account] = false;
934     }
935     
936     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
937         _taxFee = taxFee;
938     }
939     
940     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
941         _liquidityFee = liquidityFee;
942     }
943    
944     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
945         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
946             10**2
947         );
948     }
949     
950     function setExtraFeePercent(uint256 extraFeePercent) external onlyOwner() {
951         _extraFeePercent = extraFeePercent;
952     }
953     
954     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
955         swapAndLiquifyEnabled = _enabled;
956         emit SwapAndLiquifyEnabledUpdated(_enabled);
957     }
958     
959      //to receive ETH from pancakeswapV2Router when swapping
960     receive() external payable {}
961 
962     function _reflectFee(uint256 rFee, uint256 tFee, uint256 xFee) private {
963         _rTotal = _rTotal.sub(rFee);
964         _tFeeTotal = _tFeeTotal.add(tFee);
965         _xFeeTotal = _xFeeTotal.add(xFee);
966     }
967 
968     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
969         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
970         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
971         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
972     }
973 
974     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
975         uint256 tFee = calculateTaxFee(tAmount);
976         uint256 tLiquidity = calculateLiquidityFee(tAmount);
977         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
978         return (tTransferAmount, tFee, tLiquidity);
979     }
980 
981     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
982         uint256 rAmount = tAmount.mul(currentRate);
983         uint256 rFee = tFee.mul(currentRate);
984         uint256 rLiquidity = tLiquidity.mul(currentRate);
985         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
986         return (rAmount, rTransferAmount, rFee);
987     }
988 
989     function _getRate() private view returns(uint256) {
990         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
991         return rSupply.div(tSupply);
992     }
993 
994     function _getCurrentSupply() private view returns(uint256, uint256) {
995         uint256 rSupply = _rTotal;
996         uint256 tSupply = _tTotal;      
997         for (uint256 i = 0; i < _excluded.length; i++) {
998             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
999             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1000             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1001         }
1002         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1003         return (rSupply, tSupply);
1004     }
1005     
1006     function _takeLiquidity(uint256 tLiquidity) private {
1007         uint256 currentRate =  _getRate();
1008         uint256 rLiquidity = tLiquidity.mul(currentRate);
1009         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1010         if(_isExcluded[address(this)])
1011             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1012     }
1013     
1014     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1015         return _amount.mul(_taxFee).div(
1016             10**2
1017         );
1018     }
1019 
1020     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1021         return _amount.mul(_liquidityFee).div(
1022             10**2
1023         );
1024     }
1025     
1026     function removeAllFee() private {
1027         if(_taxFee == 0 && _liquidityFee == 0 && _extraFeePercent == 0) return;
1028         
1029         _previousTaxFee = _taxFee;
1030         _previousLiquidityFee = _liquidityFee;
1031         _previousExtraFeePercent = _extraFeePercent;
1032         
1033         _taxFee = 0;
1034         _liquidityFee = 0;
1035         _extraFeePercent = 0;
1036     }
1037     
1038     function restoreAllFee() private {
1039         _taxFee = _previousTaxFee;
1040         _liquidityFee = _previousLiquidityFee;
1041         _extraFeePercent = _previousExtraFeePercent;
1042     }
1043     
1044     function isExcludedFromFee(address account) public view returns(bool) {
1045         return _isExcludedFromFee[account];
1046     }
1047 
1048     function _approve(address owner, address spender, uint256 amount) private {
1049         require(owner != address(0), "ERC20: approve from the zero address");
1050         require(spender != address(0), "ERC20: approve to the zero address");
1051 
1052         _allowances[owner][spender] = amount;
1053         emit Approval(owner, spender, amount);
1054     }
1055 
1056     function _transfer(
1057         address from,
1058         address to,
1059         uint256 amount
1060     ) private {
1061         require(from != address(0), "ERC20: transfer from the zero address");
1062         require(to != address(0), "ERC20: transfer to the zero address");
1063         require(amount > 0, "Transfer amount must be greater than zero");
1064         if(from != owner() && to != owner())
1065             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1066 
1067         // is the token balance of this contract address over the min number of
1068         // tokens that we need to initiate a swap + liquidity lock?
1069         // also, don't get caught in a circular liquidity event.
1070         // also, don't swap & liquify if sender is uniswap pair.
1071         uint256 contractTokenBalance = balanceOf(address(this));
1072         
1073         if(contractTokenBalance >= _maxTxAmount)
1074         {
1075             contractTokenBalance = _maxTxAmount;
1076         }
1077         
1078         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1079         if (
1080             overMinTokenBalance &&
1081             !inSwapAndLiquify &&
1082             from != uniswapV2Pair &&
1083             swapAndLiquifyEnabled
1084         ) {
1085             contractTokenBalance = numTokensSellToAddToLiquidity;
1086             //add liquidity
1087             swapAndLiquify(contractTokenBalance);
1088         }
1089         
1090         //indicates if fee should be deducted from transfer
1091         bool takeFee = true;
1092         
1093         //if any account belongs to _isExcludedFromFee account then remove the fee
1094         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1095             takeFee = false;
1096         }
1097         
1098         //transfer amount, it will take tax, burn, liquidity fee
1099         _tokenTransfer(from,to,amount,takeFee);
1100     }
1101 
1102     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1103         // split the contract balance into halves
1104         uint256 half = contractTokenBalance.div(2);
1105         uint256 otherHalf = contractTokenBalance.sub(half);
1106 
1107         // capture the contract's current ETH/BNB balance.
1108         // this is so that we can capture exactly the amount of ETH/BNB that the
1109         // swap creates, and not make the liquidity event include any ETH/BNB that
1110         // has been manually sent to the contract
1111         uint256 initialBalance = address(this).balance;
1112 
1113         // swap tokens for ETH/BNB
1114         swapTokensForEth(half); // <- this breaks the ETH/BNB -> TOKEN swap when swap+liquify is triggered
1115 
1116         // how much ETH/BNB did we just swap into?
1117         uint256 newBalance = address(this).balance.sub(initialBalance);
1118 
1119         // add liquidity to uniswap
1120         addLiquidity(otherHalf, newBalance);
1121         
1122         emit SwapAndLiquify(half, newBalance, otherHalf);
1123     }
1124 
1125     function swapTokensForEth(uint256 tokenAmount) private {
1126         // generate the uniswap pair path of token -> bnb
1127         address[] memory path = new address[](2);
1128         path[0] = address(this);
1129         path[1] = uniswapV2Router.WETH();
1130 
1131         _approve(address(this), address(uniswapV2Router), tokenAmount);
1132 
1133         // make the swap
1134         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1135             tokenAmount,
1136             0, // accept any amount of BNB/ETH
1137             path,
1138             address(this),
1139             block.timestamp
1140         );
1141     }
1142 
1143     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
1144         // approve token transfer to cover all possible scenarios
1145         _approve(address(this), address(uniswapV2Router), tokenAmount);
1146 
1147         // add the liquidity
1148         uniswapV2Router.addLiquidityETH{value: bnbAmount}(
1149             address(this),
1150             tokenAmount,
1151             0, // slippage is unavoidable
1152             0, // slippage is unavoidable
1153             address(this),
1154             block.timestamp
1155         );
1156     }
1157 
1158     //this method is responsible for taking all fee, if takeFee is true
1159     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1160         if(!takeFee)
1161             removeAllFee();
1162         
1163         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1164             _transferFromExcluded(sender, recipient, amount);
1165         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1166             _transferToExcluded(sender, recipient, amount);
1167         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1168             _transferBothExcluded(sender, recipient, amount);
1169         } else {
1170             _transferStandard(sender, recipient, amount);
1171         }
1172         
1173         if(!takeFee)
1174             restoreAllFee();
1175     }
1176 
1177     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1178         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1179         
1180         uint256 extraFeeAmount;
1181         
1182         if (_extraFeePercent != 0) {
1183             extraFeeAmount = rAmount / (100 / _extraFeePercent);  
1184         } else {
1185             extraFeeAmount = 0;
1186         }
1187 
1188         _rOwned[sender] = _rOwned[sender].sub(rAmount); // takes amount from sender
1189         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount).sub(extraFeeAmount); // adds amount to sender after fee and subs extraFeeAmount% for charity
1190         
1191         _rOwned[_extrafeewallet] = _rOwned[_extrafeewallet].add(extraFeeAmount);
1192         
1193         _takeLiquidity(tLiquidity);
1194         _reflectFee(rFee, tFee, extraFeeAmount);
1195         emit Transfer(sender, recipient, tTransferAmount);
1196     }
1197 
1198     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1199         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1200         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1201         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1202         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1203         _takeLiquidity(tLiquidity);
1204         _reflectFee(rFee, tFee, 0);
1205         emit Transfer(sender, recipient, tTransferAmount);
1206     }
1207 
1208     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1209         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1210         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1211         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1212         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1213         _takeLiquidity(tLiquidity);
1214         _reflectFee(rFee, tFee, 0);
1215         emit Transfer(sender, recipient, tTransferAmount);
1216     }
1217     
1218     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1219         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1220         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1221         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1222         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1223         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1224         _takeLiquidity(tLiquidity);
1225         _reflectFee(rFee, tFee, 0);
1226         emit Transfer(sender, recipient, tTransferAmount);
1227     }
1228 }
1229 
1230 contract CloneFoundry {
1231 
1232   function createClone(address target) internal returns (address payable result) {
1233     bytes20 targetBytes = bytes20(target);
1234     assembly {
1235       let clone := mload(0x40)
1236       mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1237       mstore(add(clone, 0x14), targetBytes)
1238       mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1239       result := create(0, clone, 0x37)
1240     }
1241   }
1242 
1243   function isClone(address target, address query) internal view returns (bool result) {
1244     bytes20 targetBytes = bytes20(target);
1245     assembly {
1246       let clone := mload(0x40)
1247       mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
1248       mstore(add(clone, 0xa), targetBytes)
1249       mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1250 
1251       let other := add(clone, 0x40)
1252       extcodecopy(query, other, 0, 0x2d)
1253       result := and(
1254         eq(mload(clone), mload(other)),
1255         eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
1256       )
1257     }
1258   }
1259 }
1260 
1261 
1262 contract TokenFoundry is Ownable, CloneFoundry {
1263 
1264   // This is the address where the Mastercontract initializedERC20 is deployed to
1265   // address payable public masterContract = 0xEb4c4f701cb50c8dDF7B0CEd051CeB25Aed9f3CA; // master contract for bsc testnet placido factory
1266   address payable public masterContract = 0x66746FFd95053B607490A247EF58A1551bDF496c; // PROD ETH MasterContract for kovan.eth testnet jacinto factory
1267   
1268   // address to receive fees
1269   address payable public tokenfoundryboss = 0x2c095AEB336d4A520d5186493bF8fbf70Cd5Fa91; // this has to be the owner of contract
1270   
1271   address payable public tokenfoundryreferrer;
1272 
1273   //uint256 public fee = 200000000000000000;
1274   uint256 public fee = 50000000000000000;
1275 
1276   address newCloneOwner;
1277 
1278   event TokenCreated(address newTokenAddress);
1279 
1280 
1281   function createToken(string memory _name, string memory _symbol,uint256 _totalsupply, uint8 _decimals, uint256 _maxtxamount, uint256 _taxfee, uint256 _liquidityfee, uint256 _numtokenstoselltoaddtoliquidity, address _extrafeewallet, uint256 _extrafeepercent, address payable _tokenfoundryreferrer) public payable {
1282     require(msg.value == fee, "you must pay the fee");
1283     address payable clone = createClone(masterContract);
1284     newCloneOwner = msg.sender;
1285     initializedERC20(clone).init(_name, _symbol, _totalsupply, _decimals, _maxtxamount, _taxfee, _liquidityfee, _numtokenstoselltoaddtoliquidity, _extrafeewallet, _extrafeepercent, newCloneOwner);
1286     emit TokenCreated(clone);
1287 
1288     tokenfoundryreferrer = _tokenfoundryreferrer;
1289     _forwardFunds(); // Sends fee to referrer
1290   }
1291 
1292   function changeFee(uint256 _fee) public onlyOwner {
1293       fee = _fee;
1294   }
1295 
1296   function _forwardFunds() internal {
1297         uint256 split = msg.value / 2;
1298         tokenfoundryreferrer.transfer(split);
1299         tokenfoundryboss.transfer(split);
1300     }
1301 }