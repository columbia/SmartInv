1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-30
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-11-28
7 */
8 
9 /*
10 
11     Let's Go Farming Token: $LGF
12     - Smart farming outperforms most markets. Smart farmers can turn profit in any market conditions
13     - Buy one token ($LGF) to earn yield generated from our farmers who count themselves as some of the best
14         farmers in the space
15 
16     Tokenomics:
17     10% of each buy goes to existing holders (reflection).
18     10% of each sell is divided into:
19         2% Marketing Wallet: For marketing, growth and promotion of LGF.
20         6% Farming Wallet: Invests a tranche of farming opportunities
21             25% of these funds will go to safe farming opportunities
22             45% of these funds will go to CHAD farming opportunities, present some risk, but relatively low
23             30% of these funds will go to DEGEN farming opportunities. These are get rich or get rekt farms.
24         2% Auto-Adds Liquidity: Automatically adds liquidity to LGF.
25 
26     Website:
27     https://www.letsgofarming.io
28 
29     Credit to RFI (Reflect Finance), MCC (Multi-Chain Capital) + SAFEMOON (SafeMoon) + EMPIRE (EmpireDEX).
30 
31     Core contracts changed after seeing this fork come out -- really great job by the CAT team here.
32 
33 */
34 
35 // SPDX-License-Identifier: Unlicensed
36 pragma solidity ^0.6.12;
37 
38 interface IERC20 {
39 
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120  
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 abstract contract Context {
265     function _msgSender() internal view virtual returns (address payable) {
266         return msg.sender;
267     }
268 
269     function _msgData() internal view virtual returns (bytes memory) {
270         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
271         return msg.data;
272     }
273 }
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
298         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
299         // for accounts without code, i.e. `keccak256('')`
300         bytes32 codehash;
301         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { codehash := extcodehash(account) }
304         return (codehash != accountHash && codehash != 0x0);
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 /**
414  * @dev Contract module which provides a basic access control mechanism, where
415  * there is an account (an owner) that can be granted exclusive access to
416  * specific functions.
417  *
418  * By default, the owner account will be the one that deploys the contract. This
419  * can later be changed with {transferOwnership}.
420  *
421  * This module is used through inheritance. It will make available the modifier
422  * `onlyOwner`, which can be applied to your functions to restrict their use to
423  * the owner.
424  */
425 contract Ownable is Context {
426     address private _owner;
427     address private _previousOwner;
428     uint256 private _lockTime;
429 
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431 
432     /**
433      * @dev Initializes the contract setting the deployer as the initial owner.
434      */
435     constructor () internal {
436         address msgSender = _msgSender();
437         _owner = msgSender;
438         emit OwnershipTransferred(address(0), msgSender);
439     }
440 
441     /**
442      * @dev Returns the address of the current owner.
443      */
444     function owner() public view returns (address) {
445         return _owner;
446     }
447 
448     /**
449      * @dev Throws if called by any account other than the owner.
450      */
451     modifier onlyOwner() {
452         require(_owner == _msgSender(), "Ownable: caller is not the owner");
453         _;
454     }
455 
456      /**
457      * @dev Leaves the contract without owner. It will not be possible to call
458      * `onlyOwner` functions anymore. Can only be called by the current owner.
459      *
460      * NOTE: Renouncing ownership will leave the contract without an owner,
461      * thereby removing any functionality that is only available to the owner.
462      */
463     function renounceOwnership() public virtual onlyOwner {
464         emit OwnershipTransferred(_owner, address(0));
465         _owner = address(0);
466     }
467 
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Can only be called by the current owner.
471      */
472     function transferOwnership(address newOwner) public virtual onlyOwner {
473         require(newOwner != address(0), "Ownable: new owner is the zero address");
474         emit OwnershipTransferred(_owner, newOwner);
475         _owner = newOwner;
476     }
477 
478     function geUnlockTime() public view returns (uint256) {
479         return _lockTime;
480     }
481 
482     //Locks the contract for owner for the amount of time provided
483     function lock(uint256 time) public virtual onlyOwner {
484         _previousOwner = _owner;
485         _owner = address(0);
486         _lockTime = now + time;
487         emit OwnershipTransferred(_owner, address(0));
488     }
489     
490     //Unlocks the contract for owner when _lockTime is exceeds
491     function unlock() public virtual {
492         require(_previousOwner == msg.sender, "You don't have permission to unlock");
493         require(now > _lockTime , "Contract is locked until 7 days");
494         emit OwnershipTransferred(_owner, _previousOwner);
495         _owner = _previousOwner;
496     }
497 }
498 
499 interface IUniswapV2Factory {
500     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
501 
502     function feeTo() external view returns (address);
503     function feeToSetter() external view returns (address);
504 
505     function getPair(address tokenA, address tokenB) external view returns (address pair);
506     function allPairs(uint) external view returns (address pair);
507     function allPairsLength() external view returns (uint);
508 
509     function createPair(address tokenA, address tokenB) external returns (address pair);
510 
511     function setFeeTo(address) external;
512     function setFeeToSetter(address) external;
513 }
514 
515 interface IUniswapV2Pair {
516     event Approval(address indexed owner, address indexed spender, uint value);
517     event Transfer(address indexed from, address indexed to, uint value);
518 
519     function name() external pure returns (string memory);
520     function symbol() external pure returns (string memory);
521     function decimals() external pure returns (uint8);
522     function totalSupply() external view returns (uint);
523     function balanceOf(address owner) external view returns (uint);
524     function allowance(address owner, address spender) external view returns (uint);
525 
526     function approve(address spender, uint value) external returns (bool);
527     function transfer(address to, uint value) external returns (bool);
528     function transferFrom(address from, address to, uint value) external returns (bool);
529 
530     function DOMAIN_SEPARATOR() external view returns (bytes32);
531     function PERMIT_TYPEHASH() external pure returns (bytes32);
532     function nonces(address owner) external view returns (uint);
533 
534     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
535 
536     event Mint(address indexed sender, uint amount0, uint amount1);
537     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
538     event Swap(
539         address indexed sender,
540         uint amount0In,
541         uint amount1In,
542         uint amount0Out,
543         uint amount1Out,
544         address indexed to
545     );
546     event Sync(uint112 reserve0, uint112 reserve1);
547 
548     function MINIMUM_LIQUIDITY() external pure returns (uint);
549     function factory() external view returns (address);
550     function token0() external view returns (address);
551     function token1() external view returns (address);
552     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
553     function price0CumulativeLast() external view returns (uint);
554     function price1CumulativeLast() external view returns (uint);
555     function kLast() external view returns (uint);
556 
557     function mint(address to) external returns (uint liquidity);
558     function burn(address to) external returns (uint amount0, uint amount1);
559     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
560     function skim(address to) external;
561     function sync() external;
562 
563     function initialize(address, address) external;
564 }
565 
566 interface IUniswapV2Router01 {
567     function factory() external pure returns (address);
568     function WETH() external pure returns (address);
569 
570     function addLiquidity(
571         address tokenA,
572         address tokenB,
573         uint amountADesired,
574         uint amountBDesired,
575         uint amountAMin,
576         uint amountBMin,
577         address to,
578         uint deadline
579     ) external returns (uint amountA, uint amountB, uint liquidity);
580     function addLiquidityETH(
581         address token,
582         uint amountTokenDesired,
583         uint amountTokenMin,
584         uint amountETHMin,
585         address to,
586         uint deadline
587     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
588     function removeLiquidity(
589         address tokenA,
590         address tokenB,
591         uint liquidity,
592         uint amountAMin,
593         uint amountBMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountA, uint amountB);
597     function removeLiquidityETH(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline
604     ) external returns (uint amountToken, uint amountETH);
605     function removeLiquidityWithPermit(
606         address tokenA,
607         address tokenB,
608         uint liquidity,
609         uint amountAMin,
610         uint amountBMin,
611         address to,
612         uint deadline,
613         bool approveMax, uint8 v, bytes32 r, bytes32 s
614     ) external returns (uint amountA, uint amountB);
615     function removeLiquidityETHWithPermit(
616         address token,
617         uint liquidity,
618         uint amountTokenMin,
619         uint amountETHMin,
620         address to,
621         uint deadline,
622         bool approveMax, uint8 v, bytes32 r, bytes32 s
623     ) external returns (uint amountToken, uint amountETH);
624     function swapExactTokensForTokens(
625         uint amountIn,
626         uint amountOutMin,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external returns (uint[] memory amounts);
631     function swapTokensForExactTokens(
632         uint amountOut,
633         uint amountInMax,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external returns (uint[] memory amounts);
638     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
639         external
640         payable
641         returns (uint[] memory amounts);
642     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
643         external
644         returns (uint[] memory amounts);
645     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
646         external
647         returns (uint[] memory amounts);
648     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
649         external
650         payable
651         returns (uint[] memory amounts);
652 
653     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
654     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
655     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
656     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
657     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
658 }
659 
660 interface IUniswapV2Router02 is IUniswapV2Router01 {
661     function removeLiquidityETHSupportingFeeOnTransferTokens(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline
668     ) external returns (uint amountETH);
669     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
670         address token,
671         uint liquidity,
672         uint amountTokenMin,
673         uint amountETHMin,
674         address to,
675         uint deadline,
676         bool approveMax, uint8 v, bytes32 r, bytes32 s
677     ) external returns (uint amountETH);
678 
679     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
680         uint amountIn,
681         uint amountOutMin,
682         address[] calldata path,
683         address to,
684         uint deadline
685     ) external;
686     function swapExactETHForTokensSupportingFeeOnTransferTokens(
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external payable;
692     function swapExactTokensForETHSupportingFeeOnTransferTokens(
693         uint amountIn,
694         uint amountOutMin,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external;
699 }
700 
701 enum PairType {Common, LiquidityLocked, SweepableToken0, SweepableToken1}
702 
703 interface IEmpirePair {
704     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
705     event Burn(
706         address indexed sender,
707         uint256 amount0,
708         uint256 amount1,
709         address indexed to
710     );
711     event Swap(
712         address indexed sender,
713         uint256 amount0In,
714         uint256 amount1In,
715         uint256 amount0Out,
716         uint256 amount1Out,
717         address indexed to
718     );
719     event Sync(uint112 reserve0, uint112 reserve1);
720 
721     function factory() external view returns (address);
722 
723     function token0() external view returns (address);
724 
725     function token1() external view returns (address);
726 
727     function getReserves()
728         external
729         view
730         returns (
731             uint112 reserve0,
732             uint112 reserve1,
733             uint32 blockTimestampLast
734         );
735 
736     function price0CumulativeLast() external view returns (uint256);
737 
738     function price1CumulativeLast() external view returns (uint256);
739 
740     function kLast() external view returns (uint256);
741 
742     function sweptAmount() external view returns (uint256);
743 
744     function sweepableToken() external view returns (address);
745 
746     function liquidityLocked() external view returns (uint256);
747 
748     function mint(address to) external returns (uint256 liquidity);
749 
750     function burn(address to)
751         external
752         returns (uint256 amount0, uint256 amount1);
753 
754     function swap(
755         uint256 amount0Out,
756         uint256 amount1Out,
757         address to,
758         bytes calldata data
759     ) external;
760 
761     function skim(address to) external;
762 
763     function sync() external;
764 
765     function initialize(
766         address,
767         address,
768         PairType,
769         uint256
770     ) external;
771 
772     function sweep(uint256 amount, bytes calldata data) external;
773 
774     function unsweep(uint256 amount) external;
775 
776     function getMaxSweepable() external view returns (uint256);
777 }
778 
779 interface IEmpireFactory {
780     event PairCreated(
781         address indexed token0,
782         address indexed token1,
783         address pair,
784         uint256
785     );
786 
787     function feeTo() external view returns (address);
788 
789     function feeToSetter() external view returns (address);
790 
791     function getPair(address tokenA, address tokenB)
792         external
793         view
794         returns (address pair);
795 
796     function allPairs(uint256) external view returns (address pair);
797 
798     function allPairsLength() external view returns (uint256);
799 
800     function createPair(address tokenA, address tokenB)
801         external
802         returns (address pair);
803 
804     function createPair(
805         address tokenA,
806         address tokenB,
807         PairType pairType,
808         uint256 unlockTime
809     ) external returns (address pair);
810 
811     function createEmpirePair(
812         address tokenA,
813         address tokenB,
814         PairType pairType,
815         uint256 unlockTime
816     ) external returns (address pair);
817 
818     function setFeeTo(address) external;
819 
820     function setFeeToSetter(address) external;
821 }
822 
823 interface IEmpireRouter {
824     function factory() external pure returns (address);
825 
826     function WETH() external pure returns (address);
827 
828     function addLiquidity(
829         address tokenA,
830         address tokenB,
831         uint256 amountADesired,
832         uint256 amountBDesired,
833         uint256 amountAMin,
834         uint256 amountBMin,
835         address to,
836         uint256 deadline
837     )
838         external
839         returns (
840             uint256 amountA,
841             uint256 amountB,
842             uint256 liquidity
843         );
844 
845     function addLiquidityETH(
846         address token,
847         uint256 amountTokenDesired,
848         uint256 amountTokenMin,
849         uint256 amountETHMin,
850         address to,
851         uint256 deadline
852     )
853         external
854         payable
855         returns (
856             uint256 amountToken,
857             uint256 amountETH,
858             uint256 liquidity
859         );
860 
861     function removeLiquidity(
862         address tokenA,
863         address tokenB,
864         uint256 liquidity,
865         uint256 amountAMin,
866         uint256 amountBMin,
867         address to,
868         uint256 deadline
869     ) external returns (uint256 amountA, uint256 amountB);
870 
871     function removeLiquidityETH(
872         address token,
873         uint256 liquidity,
874         uint256 amountTokenMin,
875         uint256 amountETHMin,
876         address to,
877         uint256 deadline
878     ) external returns (uint256 amountToken, uint256 amountETH);
879 
880     function removeLiquidityWithPermit(
881         address tokenA,
882         address tokenB,
883         uint256 liquidity,
884         uint256 amountAMin,
885         uint256 amountBMin,
886         address to,
887         uint256 deadline,
888         bool approveMax,
889         uint8 v,
890         bytes32 r,
891         bytes32 s
892     ) external returns (uint256 amountA, uint256 amountB);
893 
894     function removeLiquidityETHWithPermit(
895         address token,
896         uint256 liquidity,
897         uint256 amountTokenMin,
898         uint256 amountETHMin,
899         address to,
900         uint256 deadline,
901         bool approveMax,
902         uint8 v,
903         bytes32 r,
904         bytes32 s
905     ) external returns (uint256 amountToken, uint256 amountETH);
906 
907     function swapExactTokensForTokens(
908         uint256 amountIn,
909         uint256 amountOutMin,
910         address[] calldata path,
911         address to,
912         uint256 deadline
913     ) external returns (uint256[] memory amounts);
914 
915     function swapTokensForExactTokens(
916         uint256 amountOut,
917         uint256 amountInMax,
918         address[] calldata path,
919         address to,
920         uint256 deadline
921     ) external returns (uint256[] memory amounts);
922 
923     function swapExactETHForTokens(
924         uint256 amountOutMin,
925         address[] calldata path,
926         address to,
927         uint256 deadline
928     ) external payable returns (uint256[] memory amounts);
929 
930     function swapTokensForExactETH(
931         uint256 amountOut,
932         uint256 amountInMax,
933         address[] calldata path,
934         address to,
935         uint256 deadline
936     ) external returns (uint256[] memory amounts);
937 
938     function swapExactTokensForETH(
939         uint256 amountIn,
940         uint256 amountOutMin,
941         address[] calldata path,
942         address to,
943         uint256 deadline
944     ) external returns (uint256[] memory amounts);
945 
946     function swapETHForExactTokens(
947         uint256 amountOut,
948         address[] calldata path,
949         address to,
950         uint256 deadline
951     ) external payable returns (uint256[] memory amounts);
952 
953     function quote(
954         uint256 amountA,
955         uint256 reserveA,
956         uint256 reserveB
957     ) external pure returns (uint256 amountB);
958 
959     function getAmountOut(
960         uint256 amountIn,
961         uint256 reserveIn,
962         uint256 reserveOut
963     ) external pure returns (uint256 amountOut);
964 
965     function getAmountIn(
966         uint256 amountOut,
967         uint256 reserveIn,
968         uint256 reserveOut
969     ) external pure returns (uint256 amountIn);
970 
971     function getAmountsOut(uint256 amountIn, address[] calldata path)
972         external
973         view
974         returns (uint256[] memory amounts);
975 
976     function getAmountsIn(uint256 amountOut, address[] calldata path)
977         external
978         view
979         returns (uint256[] memory amounts);
980 
981     function removeLiquidityETHSupportingFeeOnTransferTokens(
982         address token,
983         uint256 liquidity,
984         uint256 amountTokenMin,
985         uint256 amountETHMin,
986         address to,
987         uint256 deadline
988     ) external returns (uint256 amountETH);
989 
990     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
991         address token,
992         uint256 liquidity,
993         uint256 amountTokenMin,
994         uint256 amountETHMin,
995         address to,
996         uint256 deadline,
997         bool approveMax,
998         uint8 v,
999         bytes32 r,
1000         bytes32 s
1001     ) external returns (uint256 amountETH);
1002 
1003     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1004         uint256 amountIn,
1005         uint256 amountOutMin,
1006         address[] calldata path,
1007         address to,
1008         uint256 deadline
1009     ) external;
1010 
1011     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1012         uint256 amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint256 deadline
1016     ) external payable;
1017 
1018     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1019         uint256 amountIn,
1020         uint256 amountOutMin,
1021         address[] calldata path,
1022         address to,
1023         uint256 deadline
1024     ) external;
1025 }
1026 
1027 contract LGF is Context, IERC20, Ownable {
1028     using SafeMath for uint256;
1029     using Address for address;
1030 
1031     mapping (address => uint256) private _rOwned;
1032     mapping (address => uint256) private _tOwned;
1033     mapping (address => mapping (address => uint256)) private _allowances;
1034 
1035     mapping (address => bool) private _isExcludedFromFee;
1036 
1037     mapping (address => bool) private _isExcluded;
1038     address[] private _excluded;
1039    
1040     uint256 private constant MAX = ~uint256(0);
1041     uint256 private _tTotal = 1000000000000 * 10**9; //1T
1042     uint256 private _rTotal = (MAX - (MAX % _tTotal));
1043     uint256 private _tFeeTotal;
1044 
1045     string private _name = "Lets Go Farming Token";
1046     string private _symbol = "LGF";
1047     uint8 private _decimals = 9;
1048     
1049     uint256 public _taxFee = 2;
1050     uint256 private _previousTaxFee = _taxFee;
1051     
1052     uint256 public _liquidityFee = 8;
1053     uint256 private _previousLiquidityFee = _liquidityFee;
1054 
1055     uint256 public _liquidityFeeOnBuy = 0;
1056     uint256 public _taxFeeOnBuy = 10;
1057 
1058     uint256 public _liquidityFeeOnSell = 8;
1059     uint256 public _taxFeeOnSell = 2;
1060 
1061     IUniswapV2Router02 public uniswapV2Router;
1062     address public uniswapV2Pair;
1063     address payable public _FarmingWalletAddress = 0x642c9e3d3f649f9fcCB9f28707A0260Ba1E156B1;
1064     address payable public _marketingWalletAddress = 0x130225641c7424064ffc970583E12dc7eAe84C5E;
1065 
1066     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1067     
1068 
1069     
1070     bool inSwapAndLiquify;
1071     bool public swapAndLiquifyEnabled = true;
1072 
1073     uint256 public _maxTxAmount = 2500000000 * 10**9; //2.5B
1074     uint256 public _maxWalletAmount = 5000000000 * 10**9; //5B
1075     uint256 public numTokensSellToAddToLiquidity = 5000000 * 10**9; //5M
1076 
1077     mapping (address => bool) private _liquidityHolders;
1078     mapping (address => bool) private _isSniper;
1079     bool public _hasLiqBeenAdded = false;
1080     uint256 private _liqAddBlock = 0;
1081     uint256 private snipeBlockAmt;
1082     uint256 public snipersCaught = 0;
1083     
1084     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
1085     event SwapAndLiquifyEnabledUpdated(bool enabled);
1086     event SwapAndLiquify(
1087         uint256 tokensSwapped,
1088         uint256 ethReceived,
1089         uint256 tokensIntoLiqudity
1090     );
1091     event SniperCaught(address sniperAddress);
1092     
1093     modifier lockTheSwap {
1094         inSwapAndLiquify = true;
1095         _;
1096         inSwapAndLiquify = false;
1097     }
1098 
1099     modifier onlyPair() {
1100         require(
1101             msg.sender == uniswapV2Pair,
1102             "Empire::onlyPair: Insufficient Privileges"
1103         );
1104         _;
1105     }
1106     
1107     constructor (uint256 _snipeBlockAmt) public {
1108         _rOwned[_msgSender()] = _rTotal;
1109         
1110         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1111          // Create a uniswap pair for this new token
1112         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1113             .createPair(address(this), _uniswapV2Router.WETH());
1114 
1115         // set the rest of the contract variables
1116         uniswapV2Router = _uniswapV2Router;
1117         
1118         //exclude owner and this contract from fee
1119         _isExcludedFromFee[owner()] = true;
1120         _isExcludedFromFee[address(this)] = true;
1121 
1122         _isExcluded[uniswapV2Pair] = true;
1123         _excluded.push(uniswapV2Pair);
1124 
1125         snipeBlockAmt = _snipeBlockAmt;
1126         
1127         addLiquidityHolder(msg.sender);
1128         
1129         emit Transfer(address(0), _msgSender(), _tTotal);
1130     }
1131 
1132     function name() public view returns (string memory) {
1133         return _name;
1134     }
1135 
1136     function symbol() public view returns (string memory) {
1137         return _symbol;
1138     }
1139 
1140     function decimals() public view returns (uint8) {
1141         return _decimals;
1142     }
1143 
1144     function totalSupply() public view override returns (uint256) {
1145         return _tTotal;
1146     }
1147 
1148     function balanceOf(address account) public view override returns (uint256) {
1149         if (_isExcluded[account]) return _tOwned[account];
1150         return tokenFromReflection(_rOwned[account]);
1151     }
1152 
1153     function transfer(address recipient, uint256 amount) public override returns (bool) {
1154         _transfer(_msgSender(), recipient, amount);
1155         return true;
1156     }
1157 
1158     function allowance(address owner, address spender) public view override returns (uint256) {
1159         return _allowances[owner][spender];
1160     }
1161 
1162     function approve(address spender, uint256 amount) public override returns (bool) {
1163         _approve(_msgSender(), spender, amount);
1164         return true;
1165     }
1166 
1167     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1168         _transfer(sender, recipient, amount);
1169         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1170         return true;
1171     }
1172 
1173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1175         return true;
1176     }
1177 
1178     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1180         return true;
1181     }
1182 
1183     function isExcludedFromReward(address account) public view returns (bool) {
1184         return _isExcluded[account];
1185     }
1186 
1187     function totalFees() public view returns (uint256) {
1188         return _tFeeTotal;
1189     }
1190 
1191     function getCirculatingSupply() public view returns (uint256) {
1192         return totalSupply().sub(balanceOf(address(0x000000000000000000000000000000000000dEaD)).sub(balanceOf(address(0x0000000000000000000000000000000000000000))));
1193     }
1194 
1195     function deliver(uint256 tAmount) public {
1196         address sender = _msgSender();
1197         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1198         (uint256 rAmount,,,,,) = _getValues(tAmount);
1199         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1200         _rTotal = _rTotal.sub(rAmount);
1201         _tFeeTotal = _tFeeTotal.add(tAmount);
1202     }
1203 
1204     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1205         require(tAmount <= _tTotal, "Amount must be less than supply");
1206         if (!deductTransferFee) {
1207             (uint256 rAmount,,,,,) = _getValues(tAmount);
1208             return rAmount;
1209         } else {
1210             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
1211             return rTransferAmount;
1212         }
1213     }
1214 
1215     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1216         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1217         uint256 currentRate =  _getRate();
1218         return rAmount.div(currentRate);
1219     }
1220 
1221     function excludeFromReward(address account) public onlyOwner() {
1222         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1223         require(!_isExcluded[account], "Account is already excluded");
1224         if(_rOwned[account] > 0) {
1225             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1226         }
1227         _isExcluded[account] = true;
1228         _excluded.push(account);
1229     }
1230 
1231     function includeInReward(address account) external onlyOwner() {
1232         require(_isExcluded[account], "Account is already excluded");
1233         for (uint256 i = 0; i < _excluded.length; i++) {
1234             if (_excluded[i] == account) {
1235                 _excluded[i] = _excluded[_excluded.length - 1];
1236                 _tOwned[account] = 0;
1237                 _isExcluded[account] = false;
1238                 _excluded.pop();
1239                 break;
1240             }
1241         }
1242     }
1243 
1244     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1245         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1246         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1247         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1248         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1249         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1250         _takeLiquidity(tLiquidity);
1251         _reflectFee(rFee, tFee);
1252         emit Transfer(sender, recipient, tTransferAmount);
1253     }
1254     
1255     function excludeFromFee(address account) public onlyOwner {
1256         _isExcludedFromFee[account] = true;
1257     }
1258     
1259     function includeInFee(address account) public onlyOwner {
1260         _isExcludedFromFee[account] = false;
1261     }
1262        
1263     function setMaxTx(uint256 maxTx) external onlyOwner() {
1264         _maxTxAmount = maxTx;
1265     }
1266 
1267     function setMaxWalletAmount(uint256 maxWalA) external onlyOwner() {
1268         _maxWalletAmount = maxWalA;
1269     }
1270 
1271     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1272         swapAndLiquifyEnabled = _enabled;
1273         emit SwapAndLiquifyEnabledUpdated(_enabled);
1274     }
1275     
1276     //to recieve ETH from uniswapV2Router when swaping
1277     receive() external payable {}
1278 
1279     function _reflectFee(uint256 rFee, uint256 tFee) private {
1280         _rTotal = _rTotal.sub(rFee);
1281         _tFeeTotal = _tFeeTotal.add(tFee);
1282     }
1283 
1284     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1285         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1286         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1287         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1288     }
1289 
1290     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1291         uint256 tFee = calculateTaxFee(tAmount);
1292         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1293         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1294         return (tTransferAmount, tFee, tLiquidity);
1295     }
1296 
1297     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1298         uint256 rAmount = tAmount.mul(currentRate);
1299         uint256 rFee = tFee.mul(currentRate);
1300         uint256 rLiquidity = tLiquidity.mul(currentRate);
1301         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1302         return (rAmount, rTransferAmount, rFee);
1303     }
1304 
1305     function _getRate() private view returns(uint256) {
1306         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1307         return rSupply.div(tSupply);
1308     }
1309 
1310     function _getCurrentSupply() private view returns(uint256, uint256) {
1311         uint256 rSupply = _rTotal;
1312         uint256 tSupply = _tTotal;      
1313         for (uint256 i = 0; i < _excluded.length; i++) {
1314             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1315             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1316             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1317         }
1318         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1319         return (rSupply, tSupply);
1320     }
1321     
1322     function _takeLiquidity(uint256 tLiquidity) private {
1323         uint256 currentRate =  _getRate();
1324         uint256 rLiquidity = tLiquidity.mul(currentRate);
1325         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1326         if(_isExcluded[address(this)])
1327             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1328     }
1329     
1330     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1331         return _amount.mul(_taxFee).div(
1332             10**2
1333         );
1334     }
1335 
1336     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1337         return _amount.mul(_liquidityFee).div(
1338             10**2
1339         );
1340     }
1341     
1342     function removeAllFee() private {
1343         if(_taxFee == 0 && _liquidityFee == 0) return;
1344         
1345         _previousTaxFee = _taxFee;
1346         _previousLiquidityFee = _liquidityFee;
1347         
1348         _taxFee = 0;
1349         _liquidityFee = 0;
1350     }
1351     
1352     function restoreAllFee() private {
1353         _taxFee = _previousTaxFee;
1354         _liquidityFee = _previousLiquidityFee;
1355     }
1356     
1357     function isExcludedFromFee(address account) public view returns(bool) {
1358         return _isExcludedFromFee[account];
1359     }
1360     
1361     function sendETHToCapitalFund(uint256 amount) private { 
1362         swapTokensForEth(amount); 
1363         _marketingWalletAddress.transfer(address(this).balance.div(4)); 
1364         _FarmingWalletAddress.transfer(address(this).balance); 
1365     }
1366     
1367     function _setMWallet(address payable mAddress) external onlyOwner() {
1368         _marketingWalletAddress = mAddress;
1369     }
1370 
1371     function _setFarmingWallet(address payable cAddress) external onlyOwner() {
1372         _FarmingWalletAddress = cAddress;
1373     }
1374 
1375     function _approve(address owner, address spender, uint256 amount) private {
1376         require(owner != address(0), "ERC20: approve from the zero address");
1377         require(spender != address(0), "ERC20: approve to the zero address");
1378 
1379         _allowances[owner][spender] = amount;
1380         emit Approval(owner, spender, amount);
1381     }
1382 
1383     function _transfer(
1384         address from,
1385         address to,
1386         uint256 amount
1387     ) private {
1388         require(from != address(0), "ERC20: transfer from the zero address");
1389         require(to != address(0), "ERC20: transfer to the zero address");
1390         require(amount > 0, "Transfer amount must be greater than zero");
1391         require(!_isSniper[from], "ERC20: snipers can not transfer");
1392         require(!_isSniper[to], "ERC20: snipers can not transfer");
1393         require(!_isSniper[msg.sender], "ERC20: snipers can not transfer");
1394 
1395         if (!_hasLiqBeenAdded) {
1396             _checkLiquidityAdd(from, to);
1397         } else {
1398             if (_liqAddBlock > 0 
1399                 && from == uniswapV2Pair 
1400                 && !_liquidityHolders[from]
1401                 && !_liquidityHolders[to]
1402             ) {
1403                 if (block.number - _liqAddBlock < snipeBlockAmt) {
1404                     _isSniper[to] = true;
1405                     snipersCaught ++;
1406                     emit SniperCaught(to); //pow
1407                 }
1408             }
1409         }
1410 
1411         if(from != owner() && to != owner())
1412             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1413             //require(amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
1414         if(to != _routerAddress && to != uniswapV2Pair)
1415         {
1416             uint256 contractBalanceRecepient = balanceOf(to);
1417             require(contractBalanceRecepient + amount <= _maxWalletAmount, "Transfer amount exceeds the maxWalletAmount.");
1418         }
1419         // is the token balance of this contract address over the min number of
1420         // tokens that we need to initiate a swap + liquidity lock?
1421         // also, don't get caught in a circular liquidity event.
1422         // also, don't swap & liquify if sender is uniswap pair.
1423         uint256 contractTokenBalance = balanceOf(address(this));
1424         
1425         if(contractTokenBalance >= _maxTxAmount)
1426         {
1427             contractTokenBalance = _maxTxAmount;
1428         }
1429         
1430         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1431         if (
1432             overMinTokenBalance &&
1433             !inSwapAndLiquify &&
1434             from != uniswapV2Pair &&
1435             swapAndLiquifyEnabled
1436         ) {
1437             contractTokenBalance = numTokensSellToAddToLiquidity;
1438             //add liquidity
1439             swapAndLiquify(contractTokenBalance);
1440         }
1441         
1442         //indicates if fee should be deducted from transfer
1443         bool takeFee = true;
1444         
1445         //if any account belongs to _isExcludedFromFee account then remove the fee
1446         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1447             takeFee = false;
1448         }
1449 
1450         //if buy order
1451         if(from == uniswapV2Pair) {
1452             _liquidityFee = _liquidityFeeOnBuy;
1453             _taxFee = _taxFeeOnBuy;
1454         }
1455 
1456         //if not buy
1457         if(from != uniswapV2Pair) {
1458             _liquidityFee = _liquidityFeeOnSell;
1459             _taxFee = _taxFeeOnSell;
1460         }
1461        
1462         //transfer amount, it will take tax, burn, liquidity fee
1463         _tokenTransfer(from,to,amount,takeFee);
1464 
1465     }
1466 
1467     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1468         // split the contract balance into thirds
1469         uint256 halfOfLiquify = contractTokenBalance.div(4);
1470         uint256 otherHalfOfLiquify = contractTokenBalance.div(4);
1471         uint256 portionForFees = contractTokenBalance.sub(halfOfLiquify).sub(otherHalfOfLiquify);
1472 
1473         // capture the contract's current ETH balance.
1474         // this is so that we can capture exactly the amount of ETH that the
1475         // swap creates, and not make the liquidity event include any ETH that
1476         // has been manually sent to the contract
1477         uint256 initialBalance = address(this).balance;
1478 
1479         // swap tokens for ETH
1480         swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1481 
1482         // how much ETH did we just swap into?
1483         uint256 newBalance = address(this).balance.sub(initialBalance);
1484 
1485         // add liquidity to uniswap
1486         addLiquidity(otherHalfOfLiquify, newBalance);
1487         sendETHToCapitalFund(portionForFees);
1488         
1489         emit SwapAndLiquify(halfOfLiquify, newBalance, otherHalfOfLiquify);
1490     }
1491 
1492     function swapTokensForEth(uint256 tokenAmount) private {
1493         // generate the uniswap pair path of token -> weth
1494         address[] memory path = new address[](2);
1495         path[0] = address(this);
1496         path[1] = uniswapV2Router.WETH();
1497 
1498         _approve(address(this), address(uniswapV2Router), tokenAmount);
1499 
1500         // make the swap
1501         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1502             tokenAmount,
1503             0, // accept any amount of ETH
1504             path,
1505             address(this),
1506             block.timestamp
1507         );
1508     }
1509 
1510     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1511         // approve token transfer to cover all possible scenarios
1512         _approve(address(this), address(uniswapV2Router), tokenAmount);
1513 
1514         // add the liquidity
1515         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1516             address(this),
1517             tokenAmount,
1518             0, // slippage is unavoidable
1519             0, // slippage is unavoidable
1520             owner(),
1521             block.timestamp
1522         );
1523     }
1524 
1525     //this method is responsible for taking all fee, if takeFee is true
1526     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1527         if(!takeFee)
1528             removeAllFee();
1529         
1530         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1531             _transferFromExcluded(sender, recipient, amount);
1532         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1533             _transferToExcluded(sender, recipient, amount);
1534         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1535             _transferStandard(sender, recipient, amount);
1536         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1537             _transferBothExcluded(sender, recipient, amount);
1538         } else {
1539             _transferStandard(sender, recipient, amount);
1540         }
1541         
1542         if(!takeFee)
1543             restoreAllFee();
1544     }
1545 
1546     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1547         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1548         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1549         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1550         _takeLiquidity(tLiquidity);
1551         _reflectFee(rFee, tFee);
1552         emit Transfer(sender, recipient, tTransferAmount);
1553     }
1554 
1555     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1556         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1557         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1558         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1559         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1560         _takeLiquidity(tLiquidity);
1561         _reflectFee(rFee, tFee);
1562         emit Transfer(sender, recipient, tTransferAmount);
1563     }
1564 
1565     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1566         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1567         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1568         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1569         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1570         _takeLiquidity(tLiquidity);
1571         _reflectFee(rFee, tFee);
1572         emit Transfer(sender, recipient, tTransferAmount);
1573     }
1574 
1575     function _checkLiquidityAdd(address from, address to) private {
1576         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
1577         if (_liquidityHolders[from] && to == uniswapV2Pair) {
1578             _hasLiqBeenAdded = true;
1579             _liqAddBlock = block.number;
1580         }
1581     }
1582     
1583     function isSniperCheck(address account) public view returns (bool) {
1584         return _isSniper[account];
1585     }
1586     
1587     function isLiquidityHolderCheck(address account) public view returns (bool) {
1588         return _liquidityHolders[account];
1589     }
1590     
1591     function addSniper(address sniperAddress) public onlyOwner() {
1592         require(sniperAddress != uniswapV2Pair, "ERC20: Can not add uniswapV2Pair to sniper list");
1593         require(sniperAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), "ERC20: Can not add uniswapV2Router to sniper list");
1594 
1595         _isSniper[sniperAddress] = true;
1596         
1597         _isExcluded[sniperAddress] = true;
1598         _excluded.push(sniperAddress);
1599     }
1600     
1601     function removeSniper(address sniperAddress) public onlyOwner() {
1602         require(_isSniper[sniperAddress], "ERC20: Is not sniper");
1603 
1604         _isSniper[sniperAddress] = false;
1605     }
1606     
1607     function addLiquidityHolder(address liquidityHolder) public onlyOwner() {
1608         _liquidityHolders[liquidityHolder] = true;
1609     }
1610     
1611     function removeLiquidityHolder(address liquidityHolder) public onlyOwner() {
1612         _liquidityHolders[liquidityHolder] = false;
1613     }
1614 
1615     // We are exposing these functions to be able to manual swap and send
1616     // in case the token is highly valued and 5M becomes too much
1617     function manualSwap() external onlyOwner() {
1618         uint256 contractBalance = balanceOf(address(this));
1619         swapTokensForEth(contractBalance);
1620     }
1621 
1622     function manualSend() external onlyOwner() {
1623         uint256 contractETHBalance = address(this).balance;
1624         sendETHToTeam(contractETHBalance);
1625     }
1626 
1627     function setTaxFee(uint256 taxFee) external onlyOwner() {
1628         require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1629         _taxFee = taxFee;
1630     }
1631 
1632     function setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1633         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1634         _liquidityFee = liquidityFee;
1635     }
1636 
1637     function setLiquidityFeeOnBuy(uint256 liquidityFee) external onlyOwner() {
1638         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1639         _liquidityFeeOnBuy = liquidityFee;
1640     }
1641 
1642     function setLiquidityFeeOnSell(uint256 liquidityFee) external onlyOwner() {
1643         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1644         _liquidityFeeOnSell = liquidityFee;
1645     }
1646 
1647     function setTaxFeeOnBuy(uint256 liquidityFee) external onlyOwner() {
1648         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1649         _taxFeeOnBuy = liquidityFee;
1650     }
1651 
1652     function setTaxFeeOnSell(uint256 liquidityFee) external onlyOwner() {
1653         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1654         _taxFeeOnSell = liquidityFee;
1655     }
1656 
1657     function sendETHToTeam(uint256 amount) private {
1658         _FarmingWalletAddress.transfer(amount.div(2));
1659         _marketingWalletAddress.transfer(amount.div(2));
1660     }
1661 
1662     function changeLiquidityPair(address _pair) public onlyOwner() {
1663         uniswapV2Pair = _pair;
1664     }
1665 
1666     function changeRouter(address _router) public onlyOwner() {
1667         uniswapV2Router = IUniswapV2Router02(_router);
1668     }
1669 
1670     function changeMinSell(uint256 _minSell) public onlyOwner() {
1671         numTokensSellToAddToLiquidity = _minSell;
1672     }
1673 
1674     function upgradePair(IEmpireFactory _factory) external onlyOwner() {
1675         PairType pairType =
1676             address(this) < uniswapV2Router.WETH()
1677                 ? PairType.SweepableToken1
1678                 : PairType.SweepableToken0;
1679         uniswapV2Pair = _factory.createPair(uniswapV2Router.WETH(), address(this), pairType, 0);
1680     }
1681 
1682     function sweep(uint256 amount, bytes calldata data) external onlyOwner() {
1683         IEmpirePair(uniswapV2Pair).sweep(amount, data);
1684     }
1685 
1686     function empireSweepCall(uint256 amount, bytes calldata) external onlyPair() {
1687         IERC20(uniswapV2Router.WETH()).transfer(owner(), amount);
1688     }
1689 
1690     function unsweep(uint256 amount) external onlyOwner() {
1691         IERC20(uniswapV2Router.WETH()).approve(uniswapV2Pair, amount);
1692         IEmpirePair(uniswapV2Pair).unsweep(amount);
1693     }
1694 
1695 }