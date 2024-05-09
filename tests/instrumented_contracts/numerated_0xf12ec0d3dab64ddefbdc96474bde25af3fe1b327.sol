1 pragma solidity 0.6.12;
2 
3 
4 // 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface INBUNIERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 
78 
79     event Log(string log);
80 
81 }
82 
83 // 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 // 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265         // for accounts without code, i.e. `keccak256('')`
266         bytes32 codehash;
267         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { codehash := extcodehash(account) }
270         return (codehash != accountHash && codehash != 0x0);
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
293         (bool success, ) = recipient.call{ value: amount }("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain`call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316       return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
326         return _functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         return _functionCallWithValue(target, data, value, errorMessage);
353     }
354 
355     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
356         require(isContract(target), "Address: call to non-contract");
357 
358         // solhint-disable-next-line avoid-low-level-calls
359         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366 
367                 // solhint-disable-next-line no-inline-assembly
368                 assembly {
369                     let returndata_size := mload(returndata)
370                     revert(add(32, returndata), returndata_size)
371                 }
372             } else {
373                 revert(errorMessage);
374             }
375         }
376     }
377 }
378 
379 // 
380 interface IFeeApprover {
381 
382     function check(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) external returns (bool);
387 
388     function setFeeMultiplier(uint _feeMultiplier) external;
389     function feePercentX100() external view returns (uint);
390 
391     function setTokenUniswapPair(address _tokenUniswapPair) external;
392    
393     function setCoreTokenAddress(address _coreTokenAddress) external;
394     function updateTxState() external;
395     function calculateAmountsAfterFee(        
396         address sender, 
397         address recipient, 
398         uint256 amount
399     ) external  returns (uint256 transferToAmount, uint256 transferToFeeBearerAmount);
400 
401     function setPaused() external;
402  
403 
404 }
405 
406 interface ICoreVault {
407     function addPendingRewards(uint _amount) external;
408 }
409 
410 // 
411 /**
412  * @dev Interface of the ERC20 standard as defined in the EIP.
413  */
414 interface IERC20 {
415     /**
416      * @dev Returns the amount of tokens in existence.
417      */
418     function totalSupply() external view returns (uint256);
419 
420     /**
421      * @dev Returns the amount of tokens owned by `account`.
422      */
423     function balanceOf(address account) external view returns (uint256);
424 
425     /**
426      * @dev Moves `amount` tokens from the caller's account to `recipient`.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * Emits a {Transfer} event.
431      */
432     function transfer(address recipient, uint256 amount) external returns (bool);
433 
434     /**
435      * @dev Returns the remaining number of tokens that `spender` will be
436      * allowed to spend on behalf of `owner` through {transferFrom}. This is
437      * zero by default.
438      *
439      * This value changes when {approve} or {transferFrom} are called.
440      */
441     function allowance(address owner, address spender) external view returns (uint256);
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
445      *
446      * Returns a boolean value indicating whether the operation succeeded.
447      *
448      * IMPORTANT: Beware that changing an allowance with this method brings the risk
449      * that someone may use both the old and the new allowance by unfortunate
450      * transaction ordering. One possible solution to mitigate this race
451      * condition is to first reduce the spender's allowance to 0 and set the
452      * desired value afterwards:
453      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
454      *
455      * Emits an {Approval} event.
456      */
457     function approve(address spender, uint256 amount) external returns (bool);
458 
459     /**
460      * @dev Moves `amount` tokens from `sender` to `recipient` using the
461      * allowance mechanism. `amount` is then deducted from the caller's
462      * allowance.
463      *
464      * Returns a boolean value indicating whether the operation succeeded.
465      *
466      * Emits a {Transfer} event.
467      */
468     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
469 
470     /**
471      * @dev Emitted when `value` tokens are moved from one account (`from`) to
472      * another (`to`).
473      *
474      * Note that `value` may be zero.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 value);
477 
478     /**
479      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
480      * a call to {approve}. `value` is the new allowance.
481      */
482     event Approval(address indexed owner, address indexed spender, uint256 value);
483 }
484 
485 interface IUniswapV2Factory {
486     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
487 
488     function feeTo() external view returns (address);
489     function feeToSetter() external view returns (address);
490     function migrator() external view returns (address);
491 
492     function getPair(address tokenA, address tokenB) external view returns (address pair);
493     function allPairs(uint) external view returns (address pair);
494     function allPairsLength() external view returns (uint);
495 
496     function createPair(address tokenA, address tokenB) external returns (address pair);
497 
498     function setFeeTo(address) external;
499     function setFeeToSetter(address) external;
500     function setMigrator(address) external;
501 }
502 
503 interface IUniswapV2Router01 {
504     function factory() external pure returns (address);
505     function WETH() external pure returns (address);
506 
507     function addLiquidity(
508         address tokenA,
509         address tokenB,
510         uint amountADesired,
511         uint amountBDesired,
512         uint amountAMin,
513         uint amountBMin,
514         address to,
515         uint deadline
516     ) external returns (uint amountA, uint amountB, uint liquidity);
517     function addLiquidityETH(
518         address token,
519         uint amountTokenDesired,
520         uint amountTokenMin,
521         uint amountETHMin,
522         address to,
523         uint deadline
524     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
525     function removeLiquidity(
526         address tokenA,
527         address tokenB,
528         uint liquidity,
529         uint amountAMin,
530         uint amountBMin,
531         address to,
532         uint deadline
533     ) external returns (uint amountA, uint amountB);
534     function removeLiquidityETH(
535         address token,
536         uint liquidity,
537         uint amountTokenMin,
538         uint amountETHMin,
539         address to,
540         uint deadline
541     ) external returns (uint amountToken, uint amountETH);
542     function removeLiquidityWithPermit(
543         address tokenA,
544         address tokenB,
545         uint liquidity,
546         uint amountAMin,
547         uint amountBMin,
548         address to,
549         uint deadline,
550         bool approveMax, uint8 v, bytes32 r, bytes32 s
551     ) external returns (uint amountA, uint amountB);
552     function removeLiquidityETHWithPermit(
553         address token,
554         uint liquidity,
555         uint amountTokenMin,
556         uint amountETHMin,
557         address to,
558         uint deadline,
559         bool approveMax, uint8 v, bytes32 r, bytes32 s
560     ) external returns (uint amountToken, uint amountETH);
561     function swapExactTokensForTokens(
562         uint amountIn,
563         uint amountOutMin,
564         address[] calldata path,
565         address to,
566         uint deadline
567     ) external returns (uint[] memory amounts);
568     function swapTokensForExactTokens(
569         uint amountOut,
570         uint amountInMax,
571         address[] calldata path,
572         address to,
573         uint deadline
574     ) external returns (uint[] memory amounts);
575     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
576         external
577         payable
578         returns (uint[] memory amounts);
579     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
580         external
581         returns (uint[] memory amounts);
582     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
583         external
584         returns (uint[] memory amounts);
585     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
586         external
587         payable
588         returns (uint[] memory amounts);
589 
590     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
591     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
592     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
593     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
594     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
595 }
596 
597 interface IUniswapV2Router02 is IUniswapV2Router01 {
598     function removeLiquidityETHSupportingFeeOnTransferTokens(
599         address token,
600         uint liquidity,
601         uint amountTokenMin,
602         uint amountETHMin,
603         address to,
604         uint deadline
605     ) external returns (uint amountETH);
606     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
607         address token,
608         uint liquidity,
609         uint amountTokenMin,
610         uint amountETHMin,
611         address to,
612         uint deadline,
613         bool approveMax, uint8 v, bytes32 r, bytes32 s
614     ) external returns (uint amountETH);
615 
616     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
617         uint amountIn,
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external;
623     function swapExactETHForTokensSupportingFeeOnTransferTokens(
624         uint amountOutMin,
625         address[] calldata path,
626         address to,
627         uint deadline
628     ) external payable;
629     function swapExactTokensForETHSupportingFeeOnTransferTokens(
630         uint amountIn,
631         uint amountOutMin,
632         address[] calldata path,
633         address to,
634         uint deadline
635     ) external;
636 }
637 
638 interface IUniswapV2Pair {
639     event Approval(address indexed owner, address indexed spender, uint value);
640     event Transfer(address indexed from, address indexed to, uint value);
641 
642     function name() external pure returns (string memory);
643     function symbol() external pure returns (string memory);
644     function decimals() external pure returns (uint8);
645     function totalSupply() external view returns (uint);
646     function balanceOf(address owner) external view returns (uint);
647     function allowance(address owner, address spender) external view returns (uint);
648 
649     function approve(address spender, uint value) external returns (bool);
650     function transfer(address to, uint value) external returns (bool);
651     function transferFrom(address from, address to, uint value) external returns (bool);
652 
653     function DOMAIN_SEPARATOR() external view returns (bytes32);
654     function PERMIT_TYPEHASH() external pure returns (bytes32);
655     function nonces(address owner) external view returns (uint);
656 
657     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
658 
659     event Mint(address indexed sender, uint amount0, uint amount1);
660     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
661     event Swap(
662         address indexed sender,
663         uint amount0In,
664         uint amount1In,
665         uint amount0Out,
666         uint amount1Out,
667         address indexed to
668     );
669     event Sync(uint112 reserve0, uint112 reserve1);
670 
671     function MINIMUM_LIQUIDITY() external pure returns (uint);
672     function factory() external view returns (address);
673     function token0() external view returns (address);
674     function token1() external view returns (address);
675     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
676     function price0CumulativeLast() external view returns (uint);
677     function price1CumulativeLast() external view returns (uint);
678     function kLast() external view returns (uint);
679 
680     function mint(address to) external returns (uint liquidity);
681     function burn(address to) external returns (uint amount0, uint amount1);
682     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
683     function skim(address to) external;
684     function sync() external;
685 
686     function initialize(address, address) external;
687 }
688 
689 interface IWETH {
690     function deposit() external payable;
691     function transfer(address to, uint value) external returns (bool);
692     function withdraw(uint) external;
693 }
694 
695 // 
696 /*
697  * @dev Provides information about the current execution context, including the
698  * sender of the transaction and its data. While these are generally available
699  * via msg.sender and msg.data, they should not be accessed in such a direct
700  * manner, since when dealing with GSN meta-transactions the account sending and
701  * paying for execution may not be the actual sender (as far as an application
702  * is concerned).
703  *
704  * This contract is only required for intermediate, library-like contracts.
705  */
706 abstract contract Context {
707     function _msgSender() internal view virtual returns (address payable) {
708         return msg.sender;
709     }
710 
711     function _msgData() internal view virtual returns (bytes memory) {
712         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
713         return msg.data;
714     }
715 }
716 
717 // 
718 /**
719  * @dev Contract module which provides a basic access control mechanism, where
720  * there is an account (an owner) that can be granted exclusive access to
721  * specific functions.
722  *
723  * By default, the owner account will be the one that deploys the contract. This
724  * can later be changed with {transferOwnership}.
725  *
726  * This module is used through inheritance. It will make available the modifier
727  * `onlyOwner`, which can be applied to your functions to restrict their use to
728  * the owner.
729  */
730 contract Ownable is Context {
731     address private _owner;
732 
733     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
734 
735     /**
736      * @dev Initializes the contract setting the deployer as the initial owner.
737      */
738     constructor () internal {
739         address msgSender = _msgSender();
740         _owner = msgSender;
741         emit OwnershipTransferred(address(0), msgSender);
742     }
743 
744     /**
745      * @dev Returns the address of the current owner.
746      */
747     function owner() public view returns (address) {
748         return _owner;
749     }
750 
751     /**
752      * @dev Throws if called by any account other than the owner.
753      */
754     modifier onlyOwner() {
755         require(_owner == _msgSender(), "Ownable: caller is not the owner");
756         _;
757     }
758 
759     /**
760      * @dev Leaves the contract without owner. It will not be possible to call
761      * `onlyOwner` functions anymore. Can only be called by the current owner.
762      *
763      * NOTE: Renouncing ownership will leave the contract without an owner,
764      * thereby removing any functionality that is only available to the owner.
765      */
766     function renounceOwnership() public virtual onlyOwner {
767         emit OwnershipTransferred(_owner, address(0));
768         _owner = address(0);
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (`newOwner`).
773      * Can only be called by the current owner.
774      */
775     function transferOwnership(address newOwner) public virtual onlyOwner {
776         require(newOwner != address(0), "Ownable: new owner is the zero address");
777         emit OwnershipTransferred(_owner, newOwner);
778         _owner = newOwner;
779     }
780 }
781 
782 // 
783 // import "@nomiclabs/buidler/console.sol";
784 // for WETH
785 // interface factorys
786 // interface factorys
787 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
788 /**
789  * @dev Implementation of the {IERC20} interface.
790  */
791 contract NBUNIERC20 is INBUNIERC20, Ownable {
792     using SafeMath for uint256;
793     using Address for address;
794 
795     mapping(address => uint256) private _balances;
796 
797     mapping(address => mapping(address => uint256)) private _allowances;
798 
799     event LiquidityAddition(address indexed dst, uint value);
800     event LPTokenClaimed(address dst, uint value);
801 
802     uint256 private _totalSupply;
803 
804     string private _name;
805     string private _symbol;
806     uint8 private _decimals;
807     uint256 public constant initialSupply = 1_000_000_000 * 1e18; // 1 billion STACY
808 
809     function initialSetup(address router, address factory) internal {
810         _name = "Stacy";
811         _symbol = "STACY";
812         _decimals = 18;
813         _mint(address(this), initialSupply);
814         uniswapRouterV2 = IUniswapV2Router02(router != address(0) ? router : 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // For testing
815         uniswapFactory = IUniswapV2Factory(factory != address(0) ? factory : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // For testing
816         createUniswapPairMainnet();
817     }
818 
819     IUniswapV2Router02 public uniswapRouterV2;
820     IUniswapV2Factory public uniswapFactory;
821     address public tokenUniswapPair;
822 
823     uint256 public constant FCFS_START_TIME = 1604073600; // Fri Oct 30 2020 16:00:00 UTC
824     uint256 public constant FCFS_END_TIME = 1604073600 + 1 hours; // Fri Oct 30 2020 17:00:00 UTC
825 
826     function createUniswapPairMainnet() public returns (address) {
827         require(tokenUniswapPair == address(0), "Token: pool already created");
828         tokenUniswapPair = uniswapFactory.createPair(
829             address(uniswapRouterV2.WETH()),
830             address(this)
831         );
832         return tokenUniswapPair;
833     }
834 
835     function liquidityGenerationOngoing() public view returns (bool) {
836         return FCFS_END_TIME > block.timestamp && !hardCapReached();
837     }
838 
839     function hardCapReached() public view returns (bool) {
840         return totalETHContributed > HARDCAP;
841     }
842 
843     function isWithinCappedSaleWindow() public view returns (bool) {
844         return block.timestamp < FCFS_START_TIME; 
845     }
846 
847     // Emergency drain in case of a bug
848     // Adds all funds to owner to refund people
849     // Designed to be as simple as possible
850     function emergencyDrain24hAfterLiquidityGenerationEventIsDone() public onlyOwner {
851         require(block.timestamp > (FCFS_END_TIME + 24 hours), "Liquidity generation grace period still ongoing"); // About 24h after liquidity generation happens        
852         (bool success, ) = msg.sender.call.value(address(this).balance)("");
853         require(success, "Transfer failed.");
854         _balances[msg.sender] = _balances[address(this)];
855         _balances[address(this)] = 0;
856     }
857 
858     uint256 public totalLPTokensMinted;
859     uint256 public totalETHContributed;
860     uint256 public LPperETHUnit;
861 
862     bool public LPGenerationCompleted;
863     // Sends all avaibile balances and mints LP tokens
864     // Possible ways this could break addressed 
865     // 1) Multiple calls and resetting amounts - addressed with boolean
866     // 2) Failed WETH wrapping/unwrapping addressed with checks
867     // 3) Failure to create LP tokens, addressed with checks
868     // 4) Unacceptable division errors . Addressed with multiplications by 1e18
869     // 5) Pair not set - impossible since its set in constructor
870     function addLiquidityToUniswapSTACYxWETHPair() public onlyOwner {
871         require(liquidityGenerationOngoing() == false, "Liquidity generation onging");
872         require(LPGenerationCompleted == false, "Liquidity generation already finished");
873         totalETHContributed = address(this).balance;
874         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
875         // console.log("Balance of this", totalETHContributed / 1e18);
876         //Wrap eth
877         address WETH = uniswapRouterV2.WETH();
878         IWETH(WETH).deposit{value : totalETHContributed}();
879         require(address(this).balance == 0 , "Transfer Failed");
880         IWETH(WETH).transfer(address(pair),totalETHContributed);
881         _balances[address(pair)] = _balances[address(this)];
882         _balances[address(this)] = 0;
883         pair.mint(address(this));
884         totalLPTokensMinted = pair.balanceOf(address(this));
885         // console.log("Total tokens minted",totalLPTokensMinted);
886         require(totalLPTokensMinted != 0 , "LP creation failed");
887         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
888         // console.log("Total per LP token", LPperETHUnit);
889         require(LPperETHUnit != 0 , "LP creation failed");
890         LPGenerationCompleted = true;
891         lastPopTime = block.timestamp;
892     }
893 
894     mapping (address => uint) public whitelists;
895 
896     function addWhitelists(address[] calldata _addresses, uint[] calldata _caps) external onlyOwner {
897         require(_addresses.length == _caps.length, "diff arrays");
898         for (uint256 i = 0; i < _addresses.length; i++) {
899             addWhitelist(_addresses[i], _caps[i]);
900         }
901     }
902 
903     function addWhitelist(address _address, uint _cap) public onlyOwner {
904         whitelists[_address] = _cap;
905     }
906 
907     mapping (address => uint) public ethContributed;
908 
909     uint public constant HARDCAP = 690 ether;
910 
911     receive() payable external {
912         addLiquidity();
913     }
914 
915     // Possible ways this could break addressed
916     // 1) Adding liquidity after generaion is over - added require
917     // 2) Overflow from uint - impossible there isnt that much ETH aviable 
918     // 3) Depositing 0 - not an issue it will just add 0 to tally
919     function addLiquidity() public payable {
920         require(liquidityGenerationOngoing(), "Liquidity Generation Event over");
921         require(ethContributed[msg.sender].add(msg.value) <= HARDCAP, "harcap reached");
922         require(
923             !isWithinCappedSaleWindow() || (ethContributed[msg.sender].add(msg.value) <= whitelists[msg.sender]),
924             "individual cap exceeded or not whitelisted"
925         );
926 
927         ethContributed[msg.sender] += msg.value; // Overflow protection from safemath is not neded here 
928         totalETHContributed = totalETHContributed.add(msg.value); // for front end display during LGE. This resets with definietly correct balance while calling pair.
929         emit LiquidityAddition(msg.sender, msg.value);
930     }
931     
932     // Possible ways this could break addressed
933     // 1) Accessing before event is over and resetting eth contributed -- added require
934     // 2) No uniswap pair - impossible at this moment because of the LPGenerationCompleted bool
935     // 3) LP per unit is 0 - impossible checked at generation function
936     function claimLPTokens() public {
937         require(LPGenerationCompleted, "Event not over yet");
938         require(ethContributed[msg.sender] > 0 , "Nothing to claim, move along");
939         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
940         uint256 amountLPToTransfer = ethContributed[msg.sender].mul(LPperETHUnit).div(1e18);
941         pair.transfer(msg.sender, amountLPToTransfer); // stored as 1e18x value for change
942         ethContributed[msg.sender] = 0;
943         emit LPTokenClaimed(msg.sender, amountLPToTransfer);
944     }
945 
946     // POP THE CHERRY
947 
948     INBUNIERC20 internal constant CHADS = INBUNIERC20(0x69692D3345010a207b759a7D1af6fc7F38b35c5E);
949 
950     INBUNIERC20 internal constant EMTRG = INBUNIERC20(0xBd2949F67DcdC549c6Ebe98696449Fa79D988A9F);
951 
952     uint256 public lastPopTime;
953 
954     uint256 public totalPopped;
955 
956     bool public burnCherryPopRewards = false;
957 
958     uint256 public cherryPopBurnPct = 1;
959 
960     function setCherryPopBurnPct(uint _cherryPopBurnPct) external onlyOwner {
961         cherryPopBurnPct = _cherryPopBurnPct;
962     }
963 
964     uint256 public cherryPopBurnCallerRewardPct = 1;
965 
966     function setCherryPopBurnCallerRewardPct(uint _cherryPopBurnCallerRewardPct) external onlyOwner {
967         cherryPopBurnCallerRewardPct = _cherryPopBurnCallerRewardPct;
968     }
969 
970     function setBurnCherryPopRewards(bool _burnCherryPopRewards) external onlyOwner {
971         burnCherryPopRewards = _burnCherryPopRewards;
972     }
973 
974     event CherryPopped(address chad, uint256 cherryPopAmount);
975 
976     /*
977      * Every 24 hours, 1% of the STACY in the STACY/ETH liquidity pool is burnt and redistributed to LP token stakers.
978      */
979     function cherryPop() external {
980         require(LPGenerationCompleted, "Liquidity generation is not finished");
981         require(CHADS.balanceOf(msg.sender) >= 10000e18 || EMTRG.balanceOf(msg.sender) >= 1000e18, "must hold 10,000 CHADS or 1,000 EMTR");
982         uint256 cherryPopAmount = getCherryPopAmount();
983         require(cherryPopAmount >= 1e18, "min cherry pop amount not reached");
984 
985         lastPopTime = block.timestamp;
986 
987         uint256 userReward = cherryPopAmount.mul(cherryPopBurnCallerRewardPct).div(100);
988         _transfer(tokenUniswapPair, msg.sender, userReward);
989 
990         uint256 cherryPopFeeDistributionAmount = cherryPopAmount.sub(userReward);
991 
992         if (burnCherryPopRewards) {
993             _burn(tokenUniswapPair, cherryPopFeeDistributionAmount);        
994         } else if (cherryPopFeeDistributionAmount > 0 && feeDistributor != address(0)) {
995             _balances[feeDistributor] = _balances[feeDistributor].add(cherryPopFeeDistributionAmount);
996             emit Transfer(tokenUniswapPair, feeDistributor, cherryPopFeeDistributionAmount);
997             ICoreVault(feeDistributor).addPendingRewards(cherryPopFeeDistributionAmount);
998         }
999 
1000         totalPopped = totalPopped.add(cherryPopFeeDistributionAmount);
1001 
1002         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
1003         pair.sync();
1004 
1005         emit CherryPopped(msg.sender, cherryPopAmount);
1006     }
1007 
1008     function getCherryPopAmount() public view returns (uint256) {
1009         uint256 timeBetweenLastPop = block.timestamp - lastPopTime;
1010         uint256 tokensInUniswapPair = balanceOf(tokenUniswapPair);
1011         return (tokensInUniswapPair.mul(cherryPopBurnPct)
1012             .mul(timeBetweenLastPop))
1013             .div(1 days)
1014             .div(100);
1015     }
1016 
1017     // ERC20
1018 
1019     function name() public view returns (string memory) {
1020         return _name;
1021     }
1022 
1023     function symbol() public view returns (string memory) {
1024         return _symbol;
1025     }
1026 
1027     function decimals() public view returns (uint8) {
1028         return _decimals;
1029     }
1030 
1031     function totalSupply() public override view returns (uint256) {
1032         return _totalSupply;
1033     }
1034 
1035     function balanceOf(address _owner) public override view returns (uint256) {
1036         return _balances[_owner];
1037     }    
1038 
1039     /**
1040      * @dev See {IERC20-transfer}.
1041      *
1042      * Requirements:
1043      *
1044      * - `recipient` cannot be the zero address.
1045      * - the caller must have a balance of at least `amount`.
1046      */
1047     function transfer(address recipient, uint256 amount)
1048         public
1049         virtual
1050         override
1051         returns (bool)
1052     {
1053         _transfer(_msgSender(), recipient, amount);
1054         return true;
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-allowance}.
1059      */
1060     function allowance(address owner, address spender)
1061         public
1062         virtual
1063         override
1064         view
1065         returns (uint256)
1066     {
1067         return _allowances[owner][spender];
1068     }
1069 
1070     /**
1071      * @dev See {IERC20-approve}.
1072      *
1073      * Requirements:
1074      *
1075      * - `spender` cannot be the zero address.
1076      */
1077     function approve(address spender, uint256 amount)
1078         public
1079         virtual
1080         override
1081         returns (bool)
1082     {
1083         _approve(_msgSender(), spender, amount);
1084         return true;
1085     }
1086 
1087     /**
1088      * @dev See {IERC20-transferFrom}.
1089      *
1090      * Emits an {Approval} event indicating the updated allowance. This is not
1091      * required by the EIP. See the note at the beginning of {ERC20};
1092      *
1093      * Requirements:
1094      * - `sender` and `recipient` cannot be the zero address.
1095      * - `sender` must have a balance of at least `amount`.
1096      * - the caller must have allowance for ``sender``'s tokens of at least
1097      * `amount`.
1098      */
1099     function transferFrom(
1100         address sender,
1101         address recipient,
1102         uint256 amount
1103     ) public virtual override returns (bool) {
1104         _transfer(sender, recipient, amount);
1105         _approve(
1106             sender,
1107             _msgSender(),
1108             _allowances[sender][_msgSender()].sub(
1109                 amount,
1110                 "ERC20: transfer amount exceeds allowance"
1111             )
1112         );
1113         return true;
1114     }
1115 
1116     /**
1117      * @dev Atomically increases the allowance granted to `spender` by the caller.
1118      *
1119      * This is an alternative to {approve} that can be used as a mitigation for
1120      * problems described in {IERC20-approve}.
1121      *
1122      * Emits an {Approval} event indicating the updated allowance.
1123      *
1124      * Requirements:
1125      *
1126      * - `spender` cannot be the zero address.
1127      */
1128     function increaseAllowance(address spender, uint256 addedValue)
1129         public
1130         virtual
1131         returns (bool)
1132     {
1133         _approve(
1134             _msgSender(),
1135             spender,
1136             _allowances[_msgSender()][spender].add(addedValue)
1137         );
1138         return true;
1139     }
1140 
1141     /**
1142      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1143      *
1144      * This is an alternative to {approve} that can be used as a mitigation for
1145      * problems described in {IERC20-approve}.
1146      *
1147      * Emits an {Approval} event indicating the updated allowance.
1148      *
1149      * Requirements:
1150      *
1151      * - `spender` cannot be the zero address.
1152      * - `spender` must have allowance for the caller of at least
1153      * `subtractedValue`.
1154      */
1155     function decreaseAllowance(address spender, uint256 subtractedValue)
1156         public
1157         virtual
1158         returns (bool)
1159     {
1160         _approve(
1161             _msgSender(),
1162             spender,
1163             _allowances[_msgSender()][spender].sub(
1164                 subtractedValue,
1165                 "ERC20: decreased allowance below zero"
1166             )
1167         );
1168         return true;
1169     }
1170 
1171     function setShouldTransferChecker(address _transferCheckerAddress)
1172         public
1173         onlyOwner
1174     {
1175         transferCheckerAddress = _transferCheckerAddress;
1176     }
1177 
1178     address public transferCheckerAddress;
1179 
1180     function setFeeDistributor(address _feeDistributor)
1181         public
1182         onlyOwner
1183     {
1184         feeDistributor = _feeDistributor;
1185     }
1186 
1187     address public feeDistributor;
1188 
1189 
1190     /**
1191      * @dev Moves tokens `amount` from `sender` to `recipient`.
1192      *
1193      * This is internal function is equivalent to {transfer}, and can be used to
1194      * e.g. implement automatic token fees, slashing mechanisms, etc.
1195      *
1196      * Emits a {Transfer} event.
1197      *
1198      * Requirements:
1199      *
1200      * - `sender` cannot be the zero address.
1201      * - `recipient` cannot be the zero address.
1202      * - `sender` must have a balance of at least `amount`.
1203      */
1204     function _transfer(
1205         address sender,
1206         address recipient,
1207         uint256 amount
1208     ) internal virtual {
1209         require(sender != address(0), "ERC20: transfer from the zero address");
1210         require(recipient != address(0), "ERC20: transfer to the zero address");
1211         
1212         _beforeTokenTransfer(sender, recipient, amount);
1213 
1214         _balances[sender] = _balances[sender].sub(
1215             amount,
1216             "ERC20: transfer amount exceeds balance"
1217         );
1218         
1219         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) = IFeeApprover(transferCheckerAddress).calculateAmountsAfterFee(sender, recipient, amount);
1220         // console.log("Sender is :" , sender, "Recipent is :", recipient);
1221         // console.log("amount is ", amount);
1222 
1223         // Addressing a broken checker contract
1224         require(transferToAmount.add(transferToFeeDistributorAmount) == amount, "Math broke, does gravity still work?");
1225 
1226         _balances[recipient] = _balances[recipient].add(transferToAmount);
1227         emit Transfer(sender, recipient, transferToAmount);
1228 
1229         if (transferToFeeDistributorAmount > 0 && feeDistributor != address(0)) {
1230             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
1231             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
1232             ICoreVault(feeDistributor).addPendingRewards(transferToFeeDistributorAmount);
1233         }
1234     }
1235 
1236     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1237      * the total supply.
1238      *
1239      * Emits a {Transfer} event with `from` set to the zero address.
1240      *
1241      * Requirements
1242      *
1243      * - `to` cannot be the zero address.
1244      */
1245     function _mint(address account, uint256 amount) internal virtual {
1246         require(account != address(0), "ERC20: mint to the zero address");
1247 
1248         _beforeTokenTransfer(address(0), account, amount);
1249 
1250         _totalSupply = _totalSupply.add(amount);
1251         _balances[account] = _balances[account].add(amount);
1252         emit Transfer(address(0), account, amount);
1253     }
1254 
1255     /**
1256      * @dev Destroys `amount` tokens from `account`, reducing the
1257      * total supply.
1258      *
1259      * Emits a {Transfer} event with `to` set to the zero address.
1260      *
1261      * Requirements
1262      *
1263      * - `account` cannot be the zero address.
1264      * - `account` must have at least `amount` tokens.
1265      */
1266     function _burn(address account, uint256 amount) internal virtual {
1267         require(account != address(0), "ERC20: burn from the zero address");
1268 
1269         _beforeTokenTransfer(account, address(0), amount);
1270 
1271         _balances[account] = _balances[account].sub(
1272             amount,
1273             "ERC20: burn amount exceeds balance"
1274         );
1275         _totalSupply = _totalSupply.sub(amount);
1276         emit Transfer(account, address(0), amount);
1277     }
1278 
1279     /**
1280      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1281      *
1282      * This is internal function is equivalent to `approve`, and can be used to
1283      * e.g. set automatic allowances for certain subsystems, etc.
1284      *
1285      * Emits an {Approval} event.
1286      *
1287      * Requirements:
1288      *
1289      * - `owner` cannot be the zero address.
1290      * - `spender` cannot be the zero address.
1291      */
1292     function _approve(
1293         address owner,
1294         address spender,
1295         uint256 amount
1296     ) internal virtual {
1297         require(owner != address(0), "ERC20: approve from the zero address");
1298         require(spender != address(0), "ERC20: approve to the zero address");
1299 
1300         _allowances[owner][spender] = amount;
1301         emit Approval(owner, spender, amount);
1302     }
1303 
1304     /**
1305      * @dev Sets {decimals} to a value other than the default one of 18.
1306      *
1307      * WARNING: This function should only be called from the constructor. Most
1308      * applications that interact with token contracts will not expect
1309      * {decimals} to ever change, and may work incorrectly if it does.
1310      */
1311     function _setupDecimals(uint8 decimals_) internal {
1312         _decimals = decimals_;
1313     }
1314 
1315     /**
1316      * @dev Hook that is called before any transfer of tokens. This includes
1317      * minting and burning.
1318      *
1319      * Calling conditions:
1320      *
1321      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1322      * will be to transferred to `to`.
1323      * - when `from` is zero, `amount` tokens will be minted for `to`.
1324      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1325      * - `from` and `to` are never both zero.
1326      *
1327      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1328      */
1329     function _beforeTokenTransfer(
1330         address from,
1331         address to,
1332         uint256 amount
1333     ) internal virtual {}
1334 }
1335 
1336 contract Stacy is NBUNIERC20 {
1337 
1338     uint256 private _totalLock;
1339 
1340     uint256 public lockFromBlock;
1341     uint256 public lockToBlock;
1342     
1343     mapping(address => uint256) private _locks;
1344     mapping(address => uint256) private _lastUnlockBlock;
1345 
1346     event Lock(address indexed to, uint256 value);
1347 
1348     constructor(address router, address factory) public {
1349         initialSetup(router, factory);
1350     }
1351 
1352     function totalBalanceOf(address _holder) public view returns (uint256) {
1353         return _locks[_holder].add(balanceOf(_holder));
1354     }
1355 
1356     function lockOf(address _holder) public view returns (uint256) {
1357         return _locks[_holder];
1358     }
1359 
1360     function lastUnlockBlock(address _holder) public view returns (uint256) {
1361         return _lastUnlockBlock[_holder];
1362     }
1363 
1364     function setLockFromBlock(uint256 _lockFromBlock) public onlyOwner {
1365         require(_lockFromBlock > lockFromBlock);
1366         lockFromBlock = _lockFromBlock;
1367     }    
1368 
1369     function setLockToBlock(uint256 _lockToBlock) public onlyOwner {
1370         require(_lockToBlock > lockToBlock);
1371         lockToBlock = _lockToBlock;
1372     }
1373 
1374     function lock(address _holder, uint256 _amount) public onlyOwner {
1375         require(_holder != address(0), "ERC20: lock to the zero address");
1376         require(_amount <= balanceOf(_holder), "ERC20: lock amount over blance");
1377 
1378         _transfer(_holder, address(this), _amount);
1379 
1380         _locks[_holder] = _locks[_holder].add(_amount);
1381         _totalLock = _totalLock.add(_amount);
1382         if (_lastUnlockBlock[_holder] < lockFromBlock) {
1383             _lastUnlockBlock[_holder] = lockFromBlock;
1384         }
1385         emit Lock(_holder, _amount);
1386     }
1387 
1388     function canUnlockAmount(address _holder) public view returns (uint256) {
1389         if (block.number < lockFromBlock) {
1390             return 0;
1391         }
1392         else if (block.number >= lockToBlock) {
1393             return _locks[_holder];
1394         }
1395         else {
1396             uint256 releaseBlock = block.number.sub(_lastUnlockBlock[_holder]);
1397             uint256 numberLockBlock = lockToBlock.sub(_lastUnlockBlock[_holder]);
1398             return _locks[_holder].mul(releaseBlock).div(numberLockBlock);
1399         }
1400     }
1401 
1402     function unlock() public {
1403         require(_locks[msg.sender] > 0, "ERC20: cannot unlock");
1404         
1405         uint256 amount = canUnlockAmount(msg.sender);
1406         // just for sure
1407         if (amount > balanceOf(address(this))) {
1408             amount = balanceOf(address(this));
1409         }
1410         _transfer(address(this), msg.sender, amount);
1411         _locks[msg.sender] = _locks[msg.sender].sub(amount);
1412         _lastUnlockBlock[msg.sender] = block.number;
1413         _totalLock = _totalLock.sub(amount);
1414     }
1415 
1416     // This function is for dev address migrate all balance to a multi sig address
1417     function transferAll(address _to) public {
1418         _locks[_to] = _locks[_to].add(_locks[msg.sender]);
1419 
1420         if (_lastUnlockBlock[_to] < lockFromBlock) {
1421             _lastUnlockBlock[_to] = lockFromBlock;
1422         }
1423 
1424         if (_lastUnlockBlock[_to] < _lastUnlockBlock[msg.sender]) {
1425             _lastUnlockBlock[_to] = _lastUnlockBlock[msg.sender];
1426         }
1427 
1428         _locks[msg.sender] = 0;
1429         _lastUnlockBlock[msg.sender] = 0;
1430 
1431         _transfer(msg.sender, _to, balanceOf(msg.sender));
1432     }
1433 }