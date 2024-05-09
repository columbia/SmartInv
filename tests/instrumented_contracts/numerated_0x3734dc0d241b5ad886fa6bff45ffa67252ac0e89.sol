1 /*
2 
3     Capital Aggregator Token: $CAT
4     - The aggregator of aggregators. Granting holders exposure to a range of cross chain yield generating tokens.
5     - Buy one token ($CAT) to earn yield generated from multiple other aggregator projects.
6 
7     Tokenomics:
8     10% of each buy goes to existing holders (reflection).
9     10% of each sell is divided into:
10         4% Marketing Wallet: For marketing, growth and promotion of CAT.
11         4% Treasury Wallet: Invests in multi-chain farming projects to redirect yield into buy backs of CAT.
12         2% Auto-Adds Liquidity: Automatically adds liquidity to CAT.
13 
14     Website:
15     https://www.aggregator.capital/
16 
17     Telegram:
18     https://t.me/aggregatorcoin
19 
20     Twitter:
21     https://twitter.com/Aggregatorcoin
22 
23     Medium:
24     https://medium.com/@aggregatorcoin
25 
26     Credit to RFI (Reflect Finance), MCC (Multi-Chain Capital) + SAFEMOON (SafeMoon) + EMPIRE (EmpireDEX).
27 
28 */
29 
30 // SPDX-License-Identifier: Unlicensed
31 pragma solidity ^0.6.12;
32 
33 interface IERC20 {
34 
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115  
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 abstract contract Context {
260     function _msgSender() internal view virtual returns (address payable) {
261         return msg.sender;
262     }
263 
264     function _msgData() internal view virtual returns (bytes memory) {
265         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
266         return msg.data;
267     }
268 }
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { codehash := extcodehash(account) }
299         return (codehash != accountHash && codehash != 0x0);
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345       return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return _functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         return _functionCallWithValue(target, data, value, errorMessage);
382     }
383 
384     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
385         require(isContract(target), "Address: call to non-contract");
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 /**
409  * @dev Contract module which provides a basic access control mechanism, where
410  * there is an account (an owner) that can be granted exclusive access to
411  * specific functions.
412  *
413  * By default, the owner account will be the one that deploys the contract. This
414  * can later be changed with {transferOwnership}.
415  *
416  * This module is used through inheritance. It will make available the modifier
417  * `onlyOwner`, which can be applied to your functions to restrict their use to
418  * the owner.
419  */
420 contract Ownable is Context {
421     address private _owner;
422     address private _previousOwner;
423     uint256 private _lockTime;
424 
425     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
426 
427     /**
428      * @dev Initializes the contract setting the deployer as the initial owner.
429      */
430     constructor () internal {
431         address msgSender = _msgSender();
432         _owner = msgSender;
433         emit OwnershipTransferred(address(0), msgSender);
434     }
435 
436     /**
437      * @dev Returns the address of the current owner.
438      */
439     function owner() public view returns (address) {
440         return _owner;
441     }
442 
443     /**
444      * @dev Throws if called by any account other than the owner.
445      */
446     modifier onlyOwner() {
447         require(_owner == _msgSender(), "Ownable: caller is not the owner");
448         _;
449     }
450 
451      /**
452      * @dev Leaves the contract without owner. It will not be possible to call
453      * `onlyOwner` functions anymore. Can only be called by the current owner.
454      *
455      * NOTE: Renouncing ownership will leave the contract without an owner,
456      * thereby removing any functionality that is only available to the owner.
457      */
458     function renounceOwnership() public virtual onlyOwner {
459         emit OwnershipTransferred(_owner, address(0));
460         _owner = address(0);
461     }
462 
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Can only be called by the current owner.
466      */
467     function transferOwnership(address newOwner) public virtual onlyOwner {
468         require(newOwner != address(0), "Ownable: new owner is the zero address");
469         emit OwnershipTransferred(_owner, newOwner);
470         _owner = newOwner;
471     }
472 
473     function geUnlockTime() public view returns (uint256) {
474         return _lockTime;
475     }
476 
477     //Locks the contract for owner for the amount of time provided
478     function lock(uint256 time) public virtual onlyOwner {
479         _previousOwner = _owner;
480         _owner = address(0);
481         _lockTime = now + time;
482         emit OwnershipTransferred(_owner, address(0));
483     }
484     
485     //Unlocks the contract for owner when _lockTime is exceeds
486     function unlock() public virtual {
487         require(_previousOwner == msg.sender, "You don't have permission to unlock");
488         require(now > _lockTime , "Contract is locked until 7 days");
489         emit OwnershipTransferred(_owner, _previousOwner);
490         _owner = _previousOwner;
491     }
492 }
493 
494 interface IUniswapV2Factory {
495     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
496 
497     function feeTo() external view returns (address);
498     function feeToSetter() external view returns (address);
499 
500     function getPair(address tokenA, address tokenB) external view returns (address pair);
501     function allPairs(uint) external view returns (address pair);
502     function allPairsLength() external view returns (uint);
503 
504     function createPair(address tokenA, address tokenB) external returns (address pair);
505 
506     function setFeeTo(address) external;
507     function setFeeToSetter(address) external;
508 }
509 
510 interface IUniswapV2Pair {
511     event Approval(address indexed owner, address indexed spender, uint value);
512     event Transfer(address indexed from, address indexed to, uint value);
513 
514     function name() external pure returns (string memory);
515     function symbol() external pure returns (string memory);
516     function decimals() external pure returns (uint8);
517     function totalSupply() external view returns (uint);
518     function balanceOf(address owner) external view returns (uint);
519     function allowance(address owner, address spender) external view returns (uint);
520 
521     function approve(address spender, uint value) external returns (bool);
522     function transfer(address to, uint value) external returns (bool);
523     function transferFrom(address from, address to, uint value) external returns (bool);
524 
525     function DOMAIN_SEPARATOR() external view returns (bytes32);
526     function PERMIT_TYPEHASH() external pure returns (bytes32);
527     function nonces(address owner) external view returns (uint);
528 
529     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
530 
531     event Mint(address indexed sender, uint amount0, uint amount1);
532     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
533     event Swap(
534         address indexed sender,
535         uint amount0In,
536         uint amount1In,
537         uint amount0Out,
538         uint amount1Out,
539         address indexed to
540     );
541     event Sync(uint112 reserve0, uint112 reserve1);
542 
543     function MINIMUM_LIQUIDITY() external pure returns (uint);
544     function factory() external view returns (address);
545     function token0() external view returns (address);
546     function token1() external view returns (address);
547     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
548     function price0CumulativeLast() external view returns (uint);
549     function price1CumulativeLast() external view returns (uint);
550     function kLast() external view returns (uint);
551 
552     function mint(address to) external returns (uint liquidity);
553     function burn(address to) external returns (uint amount0, uint amount1);
554     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
555     function skim(address to) external;
556     function sync() external;
557 
558     function initialize(address, address) external;
559 }
560 
561 interface IUniswapV2Router01 {
562     function factory() external pure returns (address);
563     function WETH() external pure returns (address);
564 
565     function addLiquidity(
566         address tokenA,
567         address tokenB,
568         uint amountADesired,
569         uint amountBDesired,
570         uint amountAMin,
571         uint amountBMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountA, uint amountB, uint liquidity);
575     function addLiquidityETH(
576         address token,
577         uint amountTokenDesired,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline
582     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
583     function removeLiquidity(
584         address tokenA,
585         address tokenB,
586         uint liquidity,
587         uint amountAMin,
588         uint amountBMin,
589         address to,
590         uint deadline
591     ) external returns (uint amountA, uint amountB);
592     function removeLiquidityETH(
593         address token,
594         uint liquidity,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline
599     ) external returns (uint amountToken, uint amountETH);
600     function removeLiquidityWithPermit(
601         address tokenA,
602         address tokenB,
603         uint liquidity,
604         uint amountAMin,
605         uint amountBMin,
606         address to,
607         uint deadline,
608         bool approveMax, uint8 v, bytes32 r, bytes32 s
609     ) external returns (uint amountA, uint amountB);
610     function removeLiquidityETHWithPermit(
611         address token,
612         uint liquidity,
613         uint amountTokenMin,
614         uint amountETHMin,
615         address to,
616         uint deadline,
617         bool approveMax, uint8 v, bytes32 r, bytes32 s
618     ) external returns (uint amountToken, uint amountETH);
619     function swapExactTokensForTokens(
620         uint amountIn,
621         uint amountOutMin,
622         address[] calldata path,
623         address to,
624         uint deadline
625     ) external returns (uint[] memory amounts);
626     function swapTokensForExactTokens(
627         uint amountOut,
628         uint amountInMax,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external returns (uint[] memory amounts);
633     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
634         external
635         payable
636         returns (uint[] memory amounts);
637     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
638         external
639         returns (uint[] memory amounts);
640     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
641         external
642         returns (uint[] memory amounts);
643     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
644         external
645         payable
646         returns (uint[] memory amounts);
647 
648     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
649     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
650     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
651     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
652     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
653 }
654 
655 interface IUniswapV2Router02 is IUniswapV2Router01 {
656     function removeLiquidityETHSupportingFeeOnTransferTokens(
657         address token,
658         uint liquidity,
659         uint amountTokenMin,
660         uint amountETHMin,
661         address to,
662         uint deadline
663     ) external returns (uint amountETH);
664     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline,
671         bool approveMax, uint8 v, bytes32 r, bytes32 s
672     ) external returns (uint amountETH);
673 
674     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681     function swapExactETHForTokensSupportingFeeOnTransferTokens(
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external payable;
687     function swapExactTokensForETHSupportingFeeOnTransferTokens(
688         uint amountIn,
689         uint amountOutMin,
690         address[] calldata path,
691         address to,
692         uint deadline
693     ) external;
694 }
695 
696 enum PairType {Common, LiquidityLocked, SweepableToken0, SweepableToken1}
697 
698 interface IEmpirePair {
699     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
700     event Burn(
701         address indexed sender,
702         uint256 amount0,
703         uint256 amount1,
704         address indexed to
705     );
706     event Swap(
707         address indexed sender,
708         uint256 amount0In,
709         uint256 amount1In,
710         uint256 amount0Out,
711         uint256 amount1Out,
712         address indexed to
713     );
714     event Sync(uint112 reserve0, uint112 reserve1);
715 
716     function factory() external view returns (address);
717 
718     function token0() external view returns (address);
719 
720     function token1() external view returns (address);
721 
722     function getReserves()
723         external
724         view
725         returns (
726             uint112 reserve0,
727             uint112 reserve1,
728             uint32 blockTimestampLast
729         );
730 
731     function price0CumulativeLast() external view returns (uint256);
732 
733     function price1CumulativeLast() external view returns (uint256);
734 
735     function kLast() external view returns (uint256);
736 
737     function sweptAmount() external view returns (uint256);
738 
739     function sweepableToken() external view returns (address);
740 
741     function liquidityLocked() external view returns (uint256);
742 
743     function mint(address to) external returns (uint256 liquidity);
744 
745     function burn(address to)
746         external
747         returns (uint256 amount0, uint256 amount1);
748 
749     function swap(
750         uint256 amount0Out,
751         uint256 amount1Out,
752         address to,
753         bytes calldata data
754     ) external;
755 
756     function skim(address to) external;
757 
758     function sync() external;
759 
760     function initialize(
761         address,
762         address,
763         PairType,
764         uint256
765     ) external;
766 
767     function sweep(uint256 amount, bytes calldata data) external;
768 
769     function unsweep(uint256 amount) external;
770 
771     function getMaxSweepable() external view returns (uint256);
772 }
773 
774 interface IEmpireFactory {
775     event PairCreated(
776         address indexed token0,
777         address indexed token1,
778         address pair,
779         uint256
780     );
781 
782     function feeTo() external view returns (address);
783 
784     function feeToSetter() external view returns (address);
785 
786     function getPair(address tokenA, address tokenB)
787         external
788         view
789         returns (address pair);
790 
791     function allPairs(uint256) external view returns (address pair);
792 
793     function allPairsLength() external view returns (uint256);
794 
795     function createPair(address tokenA, address tokenB)
796         external
797         returns (address pair);
798 
799     function createPair(
800         address tokenA,
801         address tokenB,
802         PairType pairType,
803         uint256 unlockTime
804     ) external returns (address pair);
805 
806     function createEmpirePair(
807         address tokenA,
808         address tokenB,
809         PairType pairType,
810         uint256 unlockTime
811     ) external returns (address pair);
812 
813     function setFeeTo(address) external;
814 
815     function setFeeToSetter(address) external;
816 }
817 
818 interface IEmpireRouter {
819     function factory() external pure returns (address);
820 
821     function WETH() external pure returns (address);
822 
823     function addLiquidity(
824         address tokenA,
825         address tokenB,
826         uint256 amountADesired,
827         uint256 amountBDesired,
828         uint256 amountAMin,
829         uint256 amountBMin,
830         address to,
831         uint256 deadline
832     )
833         external
834         returns (
835             uint256 amountA,
836             uint256 amountB,
837             uint256 liquidity
838         );
839 
840     function addLiquidityETH(
841         address token,
842         uint256 amountTokenDesired,
843         uint256 amountTokenMin,
844         uint256 amountETHMin,
845         address to,
846         uint256 deadline
847     )
848         external
849         payable
850         returns (
851             uint256 amountToken,
852             uint256 amountETH,
853             uint256 liquidity
854         );
855 
856     function removeLiquidity(
857         address tokenA,
858         address tokenB,
859         uint256 liquidity,
860         uint256 amountAMin,
861         uint256 amountBMin,
862         address to,
863         uint256 deadline
864     ) external returns (uint256 amountA, uint256 amountB);
865 
866     function removeLiquidityETH(
867         address token,
868         uint256 liquidity,
869         uint256 amountTokenMin,
870         uint256 amountETHMin,
871         address to,
872         uint256 deadline
873     ) external returns (uint256 amountToken, uint256 amountETH);
874 
875     function removeLiquidityWithPermit(
876         address tokenA,
877         address tokenB,
878         uint256 liquidity,
879         uint256 amountAMin,
880         uint256 amountBMin,
881         address to,
882         uint256 deadline,
883         bool approveMax,
884         uint8 v,
885         bytes32 r,
886         bytes32 s
887     ) external returns (uint256 amountA, uint256 amountB);
888 
889     function removeLiquidityETHWithPermit(
890         address token,
891         uint256 liquidity,
892         uint256 amountTokenMin,
893         uint256 amountETHMin,
894         address to,
895         uint256 deadline,
896         bool approveMax,
897         uint8 v,
898         bytes32 r,
899         bytes32 s
900     ) external returns (uint256 amountToken, uint256 amountETH);
901 
902     function swapExactTokensForTokens(
903         uint256 amountIn,
904         uint256 amountOutMin,
905         address[] calldata path,
906         address to,
907         uint256 deadline
908     ) external returns (uint256[] memory amounts);
909 
910     function swapTokensForExactTokens(
911         uint256 amountOut,
912         uint256 amountInMax,
913         address[] calldata path,
914         address to,
915         uint256 deadline
916     ) external returns (uint256[] memory amounts);
917 
918     function swapExactETHForTokens(
919         uint256 amountOutMin,
920         address[] calldata path,
921         address to,
922         uint256 deadline
923     ) external payable returns (uint256[] memory amounts);
924 
925     function swapTokensForExactETH(
926         uint256 amountOut,
927         uint256 amountInMax,
928         address[] calldata path,
929         address to,
930         uint256 deadline
931     ) external returns (uint256[] memory amounts);
932 
933     function swapExactTokensForETH(
934         uint256 amountIn,
935         uint256 amountOutMin,
936         address[] calldata path,
937         address to,
938         uint256 deadline
939     ) external returns (uint256[] memory amounts);
940 
941     function swapETHForExactTokens(
942         uint256 amountOut,
943         address[] calldata path,
944         address to,
945         uint256 deadline
946     ) external payable returns (uint256[] memory amounts);
947 
948     function quote(
949         uint256 amountA,
950         uint256 reserveA,
951         uint256 reserveB
952     ) external pure returns (uint256 amountB);
953 
954     function getAmountOut(
955         uint256 amountIn,
956         uint256 reserveIn,
957         uint256 reserveOut
958     ) external pure returns (uint256 amountOut);
959 
960     function getAmountIn(
961         uint256 amountOut,
962         uint256 reserveIn,
963         uint256 reserveOut
964     ) external pure returns (uint256 amountIn);
965 
966     function getAmountsOut(uint256 amountIn, address[] calldata path)
967         external
968         view
969         returns (uint256[] memory amounts);
970 
971     function getAmountsIn(uint256 amountOut, address[] calldata path)
972         external
973         view
974         returns (uint256[] memory amounts);
975 
976     function removeLiquidityETHSupportingFeeOnTransferTokens(
977         address token,
978         uint256 liquidity,
979         uint256 amountTokenMin,
980         uint256 amountETHMin,
981         address to,
982         uint256 deadline
983     ) external returns (uint256 amountETH);
984 
985     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
986         address token,
987         uint256 liquidity,
988         uint256 amountTokenMin,
989         uint256 amountETHMin,
990         address to,
991         uint256 deadline,
992         bool approveMax,
993         uint8 v,
994         bytes32 r,
995         bytes32 s
996     ) external returns (uint256 amountETH);
997 
998     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
999         uint256 amountIn,
1000         uint256 amountOutMin,
1001         address[] calldata path,
1002         address to,
1003         uint256 deadline
1004     ) external;
1005 
1006     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external payable;
1012 
1013     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1014         uint256 amountIn,
1015         uint256 amountOutMin,
1016         address[] calldata path,
1017         address to,
1018         uint256 deadline
1019     ) external;
1020 }
1021 
1022 contract CAT is Context, IERC20, Ownable {
1023     using SafeMath for uint256;
1024     using Address for address;
1025 
1026     mapping (address => uint256) private _rOwned;
1027     mapping (address => uint256) private _tOwned;
1028     mapping (address => mapping (address => uint256)) private _allowances;
1029 
1030     mapping (address => bool) private _isExcludedFromFee;
1031 
1032     mapping (address => bool) private _isExcluded;
1033     address[] private _excluded;
1034    
1035     uint256 private constant MAX = ~uint256(0);
1036     uint256 private _tTotal = 1000000000000 * 10**9; //1T
1037     uint256 private _rTotal = (MAX - (MAX % _tTotal));
1038     uint256 private _tFeeTotal;
1039 
1040     string private _name = "Capital Aggregator Token";
1041     string private _symbol = "CAT";
1042     uint8 private _decimals = 9;
1043     
1044     uint256 public _taxFee = 2;
1045     uint256 private _previousTaxFee = _taxFee;
1046     
1047     uint256 public _liquidityFee = 8;
1048     uint256 private _previousLiquidityFee = _liquidityFee;
1049 
1050     uint256 public _liquidityFeeOnBuy = 0;
1051     uint256 public _taxFeeOnBuy = 10;
1052 
1053     uint256 public _liquidityFeeOnSell = 8;
1054     uint256 public _taxFeeOnSell = 2;
1055 
1056     IUniswapV2Router02 public uniswapV2Router;
1057     address public uniswapV2Pair;
1058     address payable public _CATWalletAddress = 0x62B44f4Be6ad2d5Cf3250178217cC1c1FE443E56;
1059     address payable public _marketingWalletAddress = 0xa609dCA9010513C686Fd4574b0E241D1B35C1b4D;
1060     
1061     bool inSwapAndLiquify;
1062     bool public swapAndLiquifyEnabled = true;
1063 
1064     uint256 public _maxTxAmount = 5000000000 * 10**9; //5B
1065     uint256 public numTokensSellToAddToLiquidity = 5000000 * 10**9; //5M
1066 
1067     mapping (address => bool) private _liquidityHolders;
1068     mapping (address => bool) private _isSniper;
1069     bool public _hasLiqBeenAdded = false;
1070     uint256 private _liqAddBlock = 0;
1071     uint256 private snipeBlockAmt;
1072     uint256 public snipersCaught = 0;
1073     
1074     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
1075     event SwapAndLiquifyEnabledUpdated(bool enabled);
1076     event SwapAndLiquify(
1077         uint256 tokensSwapped,
1078         uint256 ethReceived,
1079         uint256 tokensIntoLiqudity
1080     );
1081     event SniperCaught(address sniperAddress);
1082     
1083     modifier lockTheSwap {
1084         inSwapAndLiquify = true;
1085         _;
1086         inSwapAndLiquify = false;
1087     }
1088 
1089     modifier onlyPair() {
1090         require(
1091             msg.sender == uniswapV2Pair,
1092             "Empire::onlyPair: Insufficient Privileges"
1093         );
1094         _;
1095     }
1096     
1097     constructor (uint256 _snipeBlockAmt) public {
1098         _rOwned[_msgSender()] = _rTotal;
1099         
1100         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1101          // Create a uniswap pair for this new token
1102         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1103             .createPair(address(this), _uniswapV2Router.WETH());
1104 
1105         // set the rest of the contract variables
1106         uniswapV2Router = _uniswapV2Router;
1107         
1108         //exclude owner and this contract from fee
1109         _isExcludedFromFee[owner()] = true;
1110         _isExcludedFromFee[address(this)] = true;
1111 
1112         _isExcluded[uniswapV2Pair] = true;
1113         _excluded.push(uniswapV2Pair);
1114 
1115         snipeBlockAmt = _snipeBlockAmt;
1116         
1117         addLiquidityHolder(msg.sender);
1118         
1119         emit Transfer(address(0), _msgSender(), _tTotal);
1120     }
1121 
1122     function name() public view returns (string memory) {
1123         return _name;
1124     }
1125 
1126     function symbol() public view returns (string memory) {
1127         return _symbol;
1128     }
1129 
1130     function decimals() public view returns (uint8) {
1131         return _decimals;
1132     }
1133 
1134     function totalSupply() public view override returns (uint256) {
1135         return _tTotal;
1136     }
1137 
1138     function balanceOf(address account) public view override returns (uint256) {
1139         if (_isExcluded[account]) return _tOwned[account];
1140         return tokenFromReflection(_rOwned[account]);
1141     }
1142 
1143     function transfer(address recipient, uint256 amount) public override returns (bool) {
1144         _transfer(_msgSender(), recipient, amount);
1145         return true;
1146     }
1147 
1148     function allowance(address owner, address spender) public view override returns (uint256) {
1149         return _allowances[owner][spender];
1150     }
1151 
1152     function approve(address spender, uint256 amount) public override returns (bool) {
1153         _approve(_msgSender(), spender, amount);
1154         return true;
1155     }
1156 
1157     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1158         _transfer(sender, recipient, amount);
1159         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1160         return true;
1161     }
1162 
1163     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1164         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1165         return true;
1166     }
1167 
1168     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1169         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1170         return true;
1171     }
1172 
1173     function isExcludedFromReward(address account) public view returns (bool) {
1174         return _isExcluded[account];
1175     }
1176 
1177     function totalFees() public view returns (uint256) {
1178         return _tFeeTotal;
1179     }
1180 
1181     function getCirculatingSupply() public view returns (uint256) {
1182         return totalSupply().sub(balanceOf(address(0x000000000000000000000000000000000000dEaD)).sub(balanceOf(address(0x0000000000000000000000000000000000000000))));
1183     }
1184 
1185     function deliver(uint256 tAmount) public {
1186         address sender = _msgSender();
1187         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1188         (uint256 rAmount,,,,,) = _getValues(tAmount);
1189         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1190         _rTotal = _rTotal.sub(rAmount);
1191         _tFeeTotal = _tFeeTotal.add(tAmount);
1192     }
1193 
1194     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1195         require(tAmount <= _tTotal, "Amount must be less than supply");
1196         if (!deductTransferFee) {
1197             (uint256 rAmount,,,,,) = _getValues(tAmount);
1198             return rAmount;
1199         } else {
1200             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
1201             return rTransferAmount;
1202         }
1203     }
1204 
1205     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1206         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1207         uint256 currentRate =  _getRate();
1208         return rAmount.div(currentRate);
1209     }
1210 
1211     function excludeFromReward(address account) public onlyOwner() {
1212         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1213         require(!_isExcluded[account], "Account is already excluded");
1214         if(_rOwned[account] > 0) {
1215             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1216         }
1217         _isExcluded[account] = true;
1218         _excluded.push(account);
1219     }
1220 
1221     function includeInReward(address account) external onlyOwner() {
1222         require(_isExcluded[account], "Account is already excluded");
1223         for (uint256 i = 0; i < _excluded.length; i++) {
1224             if (_excluded[i] == account) {
1225                 _excluded[i] = _excluded[_excluded.length - 1];
1226                 _tOwned[account] = 0;
1227                 _isExcluded[account] = false;
1228                 _excluded.pop();
1229                 break;
1230             }
1231         }
1232     }
1233 
1234     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1235         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1236         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1237         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1238         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1239         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1240         _takeLiquidity(tLiquidity);
1241         _reflectFee(rFee, tFee);
1242         emit Transfer(sender, recipient, tTransferAmount);
1243     }
1244     
1245     function excludeFromFee(address account) public onlyOwner {
1246         _isExcludedFromFee[account] = true;
1247     }
1248     
1249     function includeInFee(address account) public onlyOwner {
1250         _isExcludedFromFee[account] = false;
1251     }
1252        
1253     function setMaxTx(uint256 maxTx) external onlyOwner() {
1254         _maxTxAmount = maxTx;
1255     }
1256 
1257     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1258         swapAndLiquifyEnabled = _enabled;
1259         emit SwapAndLiquifyEnabledUpdated(_enabled);
1260     }
1261     
1262     //to recieve ETH from uniswapV2Router when swaping
1263     receive() external payable {}
1264 
1265     function _reflectFee(uint256 rFee, uint256 tFee) private {
1266         _rTotal = _rTotal.sub(rFee);
1267         _tFeeTotal = _tFeeTotal.add(tFee);
1268     }
1269 
1270     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1271         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1272         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1273         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1274     }
1275 
1276     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1277         uint256 tFee = calculateTaxFee(tAmount);
1278         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1279         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1280         return (tTransferAmount, tFee, tLiquidity);
1281     }
1282 
1283     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1284         uint256 rAmount = tAmount.mul(currentRate);
1285         uint256 rFee = tFee.mul(currentRate);
1286         uint256 rLiquidity = tLiquidity.mul(currentRate);
1287         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1288         return (rAmount, rTransferAmount, rFee);
1289     }
1290 
1291     function _getRate() private view returns(uint256) {
1292         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1293         return rSupply.div(tSupply);
1294     }
1295 
1296     function _getCurrentSupply() private view returns(uint256, uint256) {
1297         uint256 rSupply = _rTotal;
1298         uint256 tSupply = _tTotal;      
1299         for (uint256 i = 0; i < _excluded.length; i++) {
1300             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1301             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1302             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1303         }
1304         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1305         return (rSupply, tSupply);
1306     }
1307     
1308     function _takeLiquidity(uint256 tLiquidity) private {
1309         uint256 currentRate =  _getRate();
1310         uint256 rLiquidity = tLiquidity.mul(currentRate);
1311         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1312         if(_isExcluded[address(this)])
1313             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1314     }
1315     
1316     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1317         return _amount.mul(_taxFee).div(
1318             10**2
1319         );
1320     }
1321 
1322     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1323         return _amount.mul(_liquidityFee).div(
1324             10**2
1325         );
1326     }
1327     
1328     function removeAllFee() private {
1329         if(_taxFee == 0 && _liquidityFee == 0) return;
1330         
1331         _previousTaxFee = _taxFee;
1332         _previousLiquidityFee = _liquidityFee;
1333         
1334         _taxFee = 0;
1335         _liquidityFee = 0;
1336     }
1337     
1338     function restoreAllFee() private {
1339         _taxFee = _previousTaxFee;
1340         _liquidityFee = _previousLiquidityFee;
1341     }
1342     
1343     function isExcludedFromFee(address account) public view returns(bool) {
1344         return _isExcludedFromFee[account];
1345     }
1346     
1347     function sendETHToCapitalFund(uint256 amount) private { 
1348         swapTokensForEth(amount); 
1349         _marketingWalletAddress.transfer(address(this).balance.div(2)); 
1350         _CATWalletAddress.transfer(address(this).balance); 
1351     }
1352     
1353     function _setMWallet(address payable mAddress) external onlyOwner() {
1354         _marketingWalletAddress = mAddress;
1355     }
1356 
1357     function _setCWallet(address payable cAddress) external onlyOwner() {
1358         _CATWalletAddress = cAddress;
1359     }
1360 
1361     function _approve(address owner, address spender, uint256 amount) private {
1362         require(owner != address(0), "ERC20: approve from the zero address");
1363         require(spender != address(0), "ERC20: approve to the zero address");
1364 
1365         _allowances[owner][spender] = amount;
1366         emit Approval(owner, spender, amount);
1367     }
1368 
1369     function _transfer(
1370         address from,
1371         address to,
1372         uint256 amount
1373     ) private {
1374         require(from != address(0), "ERC20: transfer from the zero address");
1375         require(to != address(0), "ERC20: transfer to the zero address");
1376         require(amount > 0, "Transfer amount must be greater than zero");
1377         require(!_isSniper[from], "ERC20: snipers can not transfer");
1378         require(!_isSniper[to], "ERC20: snipers can not transfer");
1379         require(!_isSniper[msg.sender], "ERC20: snipers can not transfer");
1380 
1381         if (!_hasLiqBeenAdded) {
1382             _checkLiquidityAdd(from, to);
1383         } else {
1384             if (_liqAddBlock > 0 
1385                 && from == uniswapV2Pair 
1386                 && !_liquidityHolders[from]
1387                 && !_liquidityHolders[to]
1388             ) {
1389                 if (block.number - _liqAddBlock < snipeBlockAmt) {
1390                     _isSniper[to] = true;
1391                     snipersCaught ++;
1392                     emit SniperCaught(to); //pow
1393                 }
1394             }
1395         }
1396 
1397         if(from != owner() && to != owner())
1398             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1399 
1400         // is the token balance of this contract address over the min number of
1401         // tokens that we need to initiate a swap + liquidity lock?
1402         // also, don't get caught in a circular liquidity event.
1403         // also, don't swap & liquify if sender is uniswap pair.
1404         uint256 contractTokenBalance = balanceOf(address(this));
1405         
1406         if(contractTokenBalance >= _maxTxAmount)
1407         {
1408             contractTokenBalance = _maxTxAmount;
1409         }
1410         
1411         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1412         if (
1413             overMinTokenBalance &&
1414             !inSwapAndLiquify &&
1415             from != uniswapV2Pair &&
1416             swapAndLiquifyEnabled
1417         ) {
1418             contractTokenBalance = numTokensSellToAddToLiquidity;
1419             //add liquidity
1420             swapAndLiquify(contractTokenBalance);
1421         }
1422         
1423         //indicates if fee should be deducted from transfer
1424         bool takeFee = true;
1425         
1426         //if any account belongs to _isExcludedFromFee account then remove the fee
1427         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1428             takeFee = false;
1429         }
1430 
1431         //if buy order
1432         if(from == uniswapV2Pair) {
1433             _liquidityFee = _liquidityFeeOnBuy;
1434             _taxFee = _taxFeeOnBuy;
1435         }
1436 
1437         //if not buy
1438         if(from != uniswapV2Pair) {
1439             _liquidityFee = _liquidityFeeOnSell;
1440             _taxFee = _taxFeeOnSell;
1441         }
1442        
1443         //transfer amount, it will take tax, burn, liquidity fee
1444         _tokenTransfer(from,to,amount,takeFee);
1445 
1446     }
1447 
1448     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1449         // split the contract balance into thirds
1450         uint256 halfOfLiquify = contractTokenBalance.div(4);
1451         uint256 otherHalfOfLiquify = contractTokenBalance.div(4);
1452         uint256 portionForFees = contractTokenBalance.sub(halfOfLiquify).sub(otherHalfOfLiquify);
1453 
1454         // capture the contract's current ETH balance.
1455         // this is so that we can capture exactly the amount of ETH that the
1456         // swap creates, and not make the liquidity event include any ETH that
1457         // has been manually sent to the contract
1458         uint256 initialBalance = address(this).balance;
1459 
1460         // swap tokens for ETH
1461         swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1462 
1463         // how much ETH did we just swap into?
1464         uint256 newBalance = address(this).balance.sub(initialBalance);
1465 
1466         // add liquidity to uniswap
1467         addLiquidity(otherHalfOfLiquify, newBalance);
1468         sendETHToCapitalFund(portionForFees);
1469         
1470         emit SwapAndLiquify(halfOfLiquify, newBalance, otherHalfOfLiquify);
1471     }
1472 
1473     function swapTokensForEth(uint256 tokenAmount) private {
1474         // generate the uniswap pair path of token -> weth
1475         address[] memory path = new address[](2);
1476         path[0] = address(this);
1477         path[1] = uniswapV2Router.WETH();
1478 
1479         _approve(address(this), address(uniswapV2Router), tokenAmount);
1480 
1481         // make the swap
1482         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1483             tokenAmount,
1484             0, // accept any amount of ETH
1485             path,
1486             address(this),
1487             block.timestamp
1488         );
1489     }
1490 
1491     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1492         // approve token transfer to cover all possible scenarios
1493         _approve(address(this), address(uniswapV2Router), tokenAmount);
1494 
1495         // add the liquidity
1496         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1497             address(this),
1498             tokenAmount,
1499             0, // slippage is unavoidable
1500             0, // slippage is unavoidable
1501             owner(),
1502             block.timestamp
1503         );
1504     }
1505 
1506     //this method is responsible for taking all fee, if takeFee is true
1507     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1508         if(!takeFee)
1509             removeAllFee();
1510         
1511         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1512             _transferFromExcluded(sender, recipient, amount);
1513         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1514             _transferToExcluded(sender, recipient, amount);
1515         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1516             _transferStandard(sender, recipient, amount);
1517         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1518             _transferBothExcluded(sender, recipient, amount);
1519         } else {
1520             _transferStandard(sender, recipient, amount);
1521         }
1522         
1523         if(!takeFee)
1524             restoreAllFee();
1525     }
1526 
1527     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1528         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1529         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1530         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1531         _takeLiquidity(tLiquidity);
1532         _reflectFee(rFee, tFee);
1533         emit Transfer(sender, recipient, tTransferAmount);
1534     }
1535 
1536     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1537         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1538         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1539         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1540         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1541         _takeLiquidity(tLiquidity);
1542         _reflectFee(rFee, tFee);
1543         emit Transfer(sender, recipient, tTransferAmount);
1544     }
1545 
1546     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1547         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1548         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1549         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1550         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1551         _takeLiquidity(tLiquidity);
1552         _reflectFee(rFee, tFee);
1553         emit Transfer(sender, recipient, tTransferAmount);
1554     }
1555 
1556     function _checkLiquidityAdd(address from, address to) private {
1557         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
1558         if (_liquidityHolders[from] && to == uniswapV2Pair) {
1559             _hasLiqBeenAdded = true;
1560             _liqAddBlock = block.number;
1561         }
1562     }
1563     
1564     function isSniperCheck(address account) public view returns (bool) {
1565         return _isSniper[account];
1566     }
1567     
1568     function isLiquidityHolderCheck(address account) public view returns (bool) {
1569         return _liquidityHolders[account];
1570     }
1571     
1572     function addSniper(address sniperAddress) public onlyOwner() {
1573         require(sniperAddress != uniswapV2Pair, "ERC20: Can not add uniswapV2Pair to sniper list");
1574         require(sniperAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), "ERC20: Can not add uniswapV2Router to sniper list");
1575 
1576         _isSniper[sniperAddress] = true;
1577         
1578         _isExcluded[sniperAddress] = true;
1579         _excluded.push(sniperAddress);
1580     }
1581     
1582     function removeSniper(address sniperAddress) public onlyOwner() {
1583         require(_isSniper[sniperAddress], "ERC20: Is not sniper");
1584 
1585         _isSniper[sniperAddress] = false;
1586     }
1587     
1588     function addLiquidityHolder(address liquidityHolder) public onlyOwner() {
1589         _liquidityHolders[liquidityHolder] = true;
1590     }
1591     
1592     function removeLiquidityHolder(address liquidityHolder) public onlyOwner() {
1593         _liquidityHolders[liquidityHolder] = false;
1594     }
1595 
1596     // We are exposing these functions to be able to manual swap and send
1597     // in case the token is highly valued and 5M becomes too much
1598     function manualSwap() external onlyOwner() {
1599         uint256 contractBalance = balanceOf(address(this));
1600         swapTokensForEth(contractBalance);
1601     }
1602 
1603     function manualSend() external onlyOwner() {
1604         uint256 contractETHBalance = address(this).balance;
1605         sendETHToTeam(contractETHBalance);
1606     }
1607 
1608     function setTaxFee(uint256 taxFee) external onlyOwner() {
1609         require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1610         _taxFee = taxFee;
1611     }
1612 
1613     function setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1614         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1615         _liquidityFee = liquidityFee;
1616     }
1617 
1618     function setLiquidityFeeOnBuy(uint256 liquidityFee) external onlyOwner() {
1619         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1620         _liquidityFeeOnBuy = liquidityFee;
1621     }
1622 
1623     function setLiquidityFeeOnSell(uint256 liquidityFee) external onlyOwner() {
1624         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1625         _liquidityFeeOnSell = liquidityFee;
1626     }
1627 
1628     function setTaxFeeOnBuy(uint256 liquidityFee) external onlyOwner() {
1629         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1630         _taxFeeOnBuy = liquidityFee;
1631     }
1632 
1633     function setTaxFeeOnSell(uint256 liquidityFee) external onlyOwner() {
1634         require(liquidityFee >= 1 && liquidityFee <= 25, 'liquidityFee should be in 1 - 25');
1635         _taxFeeOnSell = liquidityFee;
1636     }
1637 
1638     function sendETHToTeam(uint256 amount) private {
1639         _CATWalletAddress.transfer(amount.div(2));
1640         _marketingWalletAddress.transfer(amount.div(2));
1641     }
1642 
1643     function changeLiquidityPair(address _pair) public onlyOwner() {
1644         uniswapV2Pair = _pair;
1645     }
1646 
1647     function changeRouter(address _router) public onlyOwner() {
1648         uniswapV2Router = IUniswapV2Router02(_router);
1649     }
1650 
1651     function changeMinSell(uint256 _minSell) public onlyOwner() {
1652         numTokensSellToAddToLiquidity = _minSell;
1653     }
1654 
1655     function upgradePair(IEmpireFactory _factory) external onlyOwner() {
1656         PairType pairType =
1657             address(this) < uniswapV2Router.WETH()
1658                 ? PairType.SweepableToken1
1659                 : PairType.SweepableToken0;
1660         uniswapV2Pair = _factory.createPair(uniswapV2Router.WETH(), address(this), pairType, 0);
1661     }
1662 
1663     function sweep(uint256 amount, bytes calldata data) external onlyOwner() {
1664         IEmpirePair(uniswapV2Pair).sweep(amount, data);
1665     }
1666 
1667     function empireSweepCall(uint256 amount, bytes calldata) external onlyPair() {
1668         IERC20(uniswapV2Router.WETH()).transfer(owner(), amount);
1669     }
1670 
1671     function unsweep(uint256 amount) external onlyOwner() {
1672         IERC20(uniswapV2Router.WETH()).approve(uniswapV2Pair, amount);
1673         IEmpirePair(uniswapV2Pair).unsweep(amount);
1674     }
1675 
1676 }