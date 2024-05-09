1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-24
3 */
4 
5 // Super Inu
6 // t.me/superinutoken
7 
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity ^0.6.12;
12 
13 interface IUniswapV2Factory {
14     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
15 
16     function feeTo() external view returns (address);
17     function feeToSetter() external view returns (address);
18 
19     function getPair(address tokenA, address tokenB) external view returns (address pair);
20     function allPairs(uint) external view returns (address pair);
21     function allPairsLength() external view returns (uint);
22 
23     function createPair(address tokenA, address tokenB) external returns (address pair);
24 
25     function setFeeTo(address) external;
26     function setFeeToSetter(address) external;
27 }
28 
29 interface IUniswapV2Pair {
30     event Approval(address indexed owner, address indexed spender, uint value);
31     event Transfer(address indexed from, address indexed to, uint value);
32 
33     function name() external pure returns (string memory);
34     function symbol() external pure returns (string memory);
35     function decimals() external pure returns (uint8);
36     function totalSupply() external view returns (uint);
37     function balanceOf(address owner) external view returns (uint);
38     function allowance(address owner, address spender) external view returns (uint);
39 
40     function approve(address spender, uint value) external returns (bool);
41     function transfer(address to, uint value) external returns (bool);
42     function transferFrom(address from, address to, uint value) external returns (bool);
43 
44     function DOMAIN_SEPARATOR() external view returns (bytes32);
45     function PERMIT_TYPEHASH() external pure returns (bytes32);
46     function nonces(address owner) external view returns (uint);
47 
48     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
49 
50     event Mint(address indexed sender, uint amount0, uint amount1);
51     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
52     event Swap(
53         address indexed sender,
54         uint amount0In,
55         uint amount1In,
56         uint amount0Out,
57         uint amount1Out,
58         address indexed to
59     );
60     event Sync(uint112 reserve0, uint112 reserve1);
61 
62     function MINIMUM_LIQUIDITY() external pure returns (uint);
63     function factory() external view returns (address);
64     function token0() external view returns (address);
65     function token1() external view returns (address);
66     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
67     function price0CumulativeLast() external view returns (uint);
68     function price1CumulativeLast() external view returns (uint);
69     function kLast() external view returns (uint);
70 
71     function mint(address to) external returns (uint liquidity);
72     function burn(address to) external returns (uint amount0, uint amount1);
73     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
74     function skim(address to) external;
75     function sync() external;
76 
77     function initialize(address, address) external;
78 }
79 
80 interface IUniswapV2Router01 {
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83 
84     function addLiquidity(
85         address tokenA,
86         address tokenB,
87         uint amountADesired,
88         uint amountBDesired,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB, uint liquidity);
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102     function removeLiquidity(
103         address tokenA,
104         address tokenB,
105         uint liquidity,
106         uint amountAMin,
107         uint amountBMin,
108         address to,
109         uint deadline
110     ) external returns (uint amountA, uint amountB);
111     function removeLiquidityETH(
112         address token,
113         uint liquidity,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external returns (uint amountToken, uint amountETH);
119     function removeLiquidityWithPermit(
120         address tokenA,
121         address tokenB,
122         uint liquidity,
123         uint amountAMin,
124         uint amountBMin,
125         address to,
126         uint deadline,
127         bool approveMax, uint8 v, bytes32 r, bytes32 s
128     ) external returns (uint amountA, uint amountB);
129     function removeLiquidityETHWithPermit(
130         address token,
131         uint liquidity,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline,
136         bool approveMax, uint8 v, bytes32 r, bytes32 s
137     ) external returns (uint amountToken, uint amountETH);
138     function swapExactTokensForTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external returns (uint[] memory amounts);
145     function swapTokensForExactTokens(
146         uint amountOut,
147         uint amountInMax,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external returns (uint[] memory amounts);
152     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
153     external
154     payable
155     returns (uint[] memory amounts);
156     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
157     external
158     returns (uint[] memory amounts);
159     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
160     external
161     returns (uint[] memory amounts);
162     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
163     external
164     payable
165     returns (uint[] memory amounts);
166 
167     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
168     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
169     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
170     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
171     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
172 }
173 
174 interface IUniswapV2Router02 is IUniswapV2Router01 {
175     function removeLiquidityETHSupportingFeeOnTransferTokens(
176         address token,
177         uint liquidity,
178         uint amountTokenMin,
179         uint amountETHMin,
180         address to,
181         uint deadline
182     ) external returns (uint amountETH);
183     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
184         address token,
185         uint liquidity,
186         uint amountTokenMin,
187         uint amountETHMin,
188         address to,
189         uint deadline,
190         bool approveMax, uint8 v, bytes32 r, bytes32 s
191     ) external returns (uint amountETH);
192 
193     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
194         uint amountIn,
195         uint amountOutMin,
196         address[] calldata path,
197         address to,
198         uint deadline
199     ) external;
200     function swapExactETHForTokensSupportingFeeOnTransferTokens(
201         uint amountOutMin,
202         address[] calldata path,
203         address to,
204         uint deadline
205     ) external payable;
206     function swapExactTokensForETHSupportingFeeOnTransferTokens(
207         uint amountIn,
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external;
213 }
214 
215 /*
216  * @dev Provides information about the current execution context, including the
217  * sender of the transaction and its data. While these are generally available
218  * via msg.sender and msg.data, they should not be accessed in such a direct
219  * manner, since when dealing with GSN meta-transactions the account sending and
220  * paying for execution may not be the actual sender (as far as an application
221  * is concerned).
222  *
223  * This contract is only required for intermediate, library-like contracts.
224  */
225 abstract contract Context {
226     function _msgSender() internal view virtual returns (address payable) {
227         return msg.sender;
228     }
229 
230     function _msgData() internal view virtual returns (bytes memory) {
231         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
232         return msg.data;
233     }
234 }
235 
236 /**
237  * @dev Contract module which provides a basic access control mechanism, where
238  * there is an account (an owner) that can be granted exclusive access to
239  * specific functions.
240  *
241  * By default, the owner account will be the one that deploys the contract. This
242  * can later be changed with {transferOwnership}.
243  *
244  * This module is used through inheritance. It will make available the modifier
245  * `onlyOwner`, which can be applied to your functions to restrict their use to
246  * the owner.
247  */
248 abstract contract Ownable is Context {
249     address private _owner;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     /**
254      * @dev Initializes the contract setting the deployer as the initial owner.
255      */
256     constructor () internal {
257         address msgSender = _msgSender();
258         _owner = msgSender;
259         emit OwnershipTransferred(address(0), msgSender);
260     }
261 
262     /**
263      * @dev Returns the address of the current owner.
264      */
265     function owner() public view virtual returns (address) {
266         return _owner;
267     }
268 
269     /**
270      * @dev Throws if called by any account other than the owner.
271      */
272     modifier onlyOwner() {
273         require(owner() == _msgSender(), "Ownable: caller is not the owner");
274         _;
275     }
276 
277     /**
278      * @dev Leaves the contract without owner. It will not be possible to call
279      * `onlyOwner` functions anymore. Can only be called by the current owner.
280      *
281      * NOTE: Renouncing ownership will leave the contract without an owner,
282      * thereby removing any functionality that is only available to the owner.
283      */
284     function renounceOwnership() public virtual onlyOwner {
285         emit OwnershipTransferred(_owner, address(0));
286         _owner = address(0);
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      * Can only be called by the current owner.
292      */
293     function transferOwnership(address newOwner) public virtual onlyOwner {
294         require(newOwner != address(0), "Ownable: new owner is the zero address");
295         emit OwnershipTransferred(_owner, newOwner);
296         _owner = newOwner;
297     }
298 }
299 
300 /**
301  * @dev Wrappers over Solidity's arithmetic operations with added overflow
302  * checks.
303  *
304  * Arithmetic operations in Solidity wrap on overflow. This can easily result
305  * in bugs, because programmers usually assume that an overflow raises an
306  * error, which is the standard behavior in high level programming languages.
307  * `SafeMath` restores this intuition by reverting the transaction when an
308  * operation overflows.
309  *
310  * Using this library instead of the unchecked operations eliminates an entire
311  * class of bugs, so it's recommended to use it always.
312  */
313 library SafeMath {
314     /**
315      * @dev Returns the addition of two unsigned integers, with an overflow flag.
316      *
317      * _Available since v3.4._
318      */
319     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
320         uint256 c = a + b;
321         if (c < a) return (false, 0);
322         return (true, c);
323     }
324 
325     /**
326      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
327      *
328      * _Available since v3.4._
329      */
330     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
331         if (b > a) return (false, 0);
332         return (true, a - b);
333     }
334 
335     /**
336      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
342         // benefit is lost if 'b' is also tested.
343         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
344         if (a == 0) return (true, 0);
345         uint256 c = a * b;
346         if (c / a != b) return (false, 0);
347         return (true, c);
348     }
349 
350     /**
351      * @dev Returns the division of two unsigned integers, with a division by zero flag.
352      *
353      * _Available since v3.4._
354      */
355     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
356         if (b == 0) return (false, 0);
357         return (true, a / b);
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
362      *
363      * _Available since v3.4._
364      */
365     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
366         if (b == 0) return (false, 0);
367         return (true, a % b);
368     }
369 
370     /**
371      * @dev Returns the addition of two unsigned integers, reverting on
372      * overflow.
373      *
374      * Counterpart to Solidity's `+` operator.
375      *
376      * Requirements:
377      *
378      * - Addition cannot overflow.
379      */
380     function add(uint256 a, uint256 b) internal pure returns (uint256) {
381         uint256 c = a + b;
382         require(c >= a, "SafeMath: addition overflow");
383         return c;
384     }
385 
386     /**
387      * @dev Returns the subtraction of two unsigned integers, reverting on
388      * overflow (when the result is negative).
389      *
390      * Counterpart to Solidity's `-` operator.
391      *
392      * Requirements:
393      *
394      * - Subtraction cannot overflow.
395      */
396     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
397         require(b <= a, "SafeMath: subtraction overflow");
398         return a - b;
399     }
400 
401     /**
402      * @dev Returns the multiplication of two unsigned integers, reverting on
403      * overflow.
404      *
405      * Counterpart to Solidity's `*` operator.
406      *
407      * Requirements:
408      *
409      * - Multiplication cannot overflow.
410      */
411     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
412         if (a == 0) return 0;
413         uint256 c = a * b;
414         require(c / a == b, "SafeMath: multiplication overflow");
415         return c;
416     }
417 
418     /**
419      * @dev Returns the integer division of two unsigned integers, reverting on
420      * division by zero. The result is rounded towards zero.
421      *
422      * Counterpart to Solidity's `/` operator. Note: this function uses a
423      * `revert` opcode (which leaves remaining gas untouched) while Solidity
424      * uses an invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      *
428      * - The divisor cannot be zero.
429      */
430     function div(uint256 a, uint256 b) internal pure returns (uint256) {
431         require(b > 0, "SafeMath: division by zero");
432         return a / b;
433     }
434 
435     /**
436      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
437      * reverting when dividing by zero.
438      *
439      * Counterpart to Solidity's `%` operator. This function uses a `revert`
440      * opcode (which leaves remaining gas untouched) while Solidity uses an
441      * invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
448         require(b > 0, "SafeMath: modulo by zero");
449         return a % b;
450     }
451 
452     /**
453      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
454      * overflow (when the result is negative).
455      *
456      * CAUTION: This function is deprecated because it requires allocating memory for the error
457      * message unnecessarily. For custom revert reasons use {trySub}.
458      *
459      * Counterpart to Solidity's `-` operator.
460      *
461      * Requirements:
462      *
463      * - Subtraction cannot overflow.
464      */
465     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
466         require(b <= a, errorMessage);
467         return a - b;
468     }
469 
470     /**
471      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
472      * division by zero. The result is rounded towards zero.
473      *
474      * CAUTION: This function is deprecated because it requires allocating memory for the error
475      * message unnecessarily. For custom revert reasons use {tryDiv}.
476      *
477      * Counterpart to Solidity's `/` operator. Note: this function uses a
478      * `revert` opcode (which leaves remaining gas untouched) while Solidity
479      * uses an invalid opcode to revert (consuming all remaining gas).
480      *
481      * Requirements:
482      *
483      * - The divisor cannot be zero.
484      */
485     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         require(b > 0, errorMessage);
487         return a / b;
488     }
489 
490     /**
491      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
492      * reverting with custom message when dividing by zero.
493      *
494      * CAUTION: This function is deprecated because it requires allocating memory for the error
495      * message unnecessarily. For custom revert reasons use {tryMod}.
496      *
497      * Counterpart to Solidity's `%` operator. This function uses a `revert`
498      * opcode (which leaves remaining gas untouched) while Solidity uses an
499      * invalid opcode to revert (consuming all remaining gas).
500      *
501      * Requirements:
502      *
503      * - The divisor cannot be zero.
504      */
505     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b > 0, errorMessage);
507         return a % b;
508     }
509 }
510 
511 /**
512  * @dev Interface of the ERC20 standard as defined in the EIP.
513  */
514 interface IERC20 {
515     /**
516      * @dev Returns the amount of tokens in existence.
517      */
518     function totalSupply() external view returns (uint256);
519 
520     /**
521      * @dev Returns the amount of tokens owned by `account`.
522      */
523     function balanceOf(address account) external view returns (uint256);
524 
525     /**
526      * @dev Moves `amount` tokens from the caller's account to `recipient`.
527      *
528      * Returns a boolean value indicating whether the operation succeeded.
529      *
530      * Emits a {Transfer} event.
531      */
532     function transfer(address recipient, uint256 amount) external returns (bool);
533 
534     /**
535      * @dev Returns the remaining number of tokens that `spender` will be
536      * allowed to spend on behalf of `owner` through {transferFrom}. This is
537      * zero by default.
538      *
539      * This value changes when {approve} or {transferFrom} are called.
540      */
541     function allowance(address owner, address spender) external view returns (uint256);
542 
543     /**
544      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
545      *
546      * Returns a boolean value indicating whether the operation succeeded.
547      *
548      * IMPORTANT: Beware that changing an allowance with this method brings the risk
549      * that someone may use both the old and the new allowance by unfortunate
550      * transaction ordering. One possible solution to mitigate this race
551      * condition is to first reduce the spender's allowance to 0 and set the
552      * desired value afterwards:
553      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
554      *
555      * Emits an {Approval} event.
556      */
557     function approve(address spender, uint256 amount) external returns (bool);
558 
559     /**
560      * @dev Moves `amount` tokens from `sender` to `recipient` using the
561      * allowance mechanism. `amount` is then deducted from the caller's
562      * allowance.
563      *
564      * Returns a boolean value indicating whether the operation succeeded.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
569 
570     /**
571      * @dev Emitted when `value` tokens are moved from one account (`from`) to
572      * another (`to`).
573      *
574      * Note that `value` may be zero.
575      */
576     event Transfer(address indexed from, address indexed to, uint256 value);
577 
578     /**
579      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
580      * a call to {approve}. `value` is the new allowance.
581      */
582     event Approval(address indexed owner, address indexed spender, uint256 value);
583 }
584 
585 /**
586  * @dev Collection of functions related to the address type
587  */
588 library Address {
589     /**
590      * @dev Returns true if `account` is a contract.
591      *
592      * [IMPORTANT]
593      * ====
594      * It is unsafe to assume that an address for which this function returns
595      * false is an externally-owned account (EOA) and not a contract.
596      *
597      * Among others, `isContract` will return false for the following
598      * types of addresses:
599      *
600      *  - an externally-owned account
601      *  - a contract in construction
602      *  - an address where a contract will be created
603      *  - an address where a contract lived, but was destroyed
604      * ====
605      */
606     function isContract(address account) internal view returns (bool) {
607         // This method relies on extcodesize, which returns 0 for contracts in
608         // construction, since the code is only stored at the end of the
609         // constructor execution.
610 
611         uint256 size;
612         // solhint-disable-next-line no-inline-assembly
613         assembly { size := extcodesize(account) }
614         return size > 0;
615     }
616 
617     /**
618      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
619      * `recipient`, forwarding all available gas and reverting on errors.
620      *
621      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
622      * of certain opcodes, possibly making contracts go over the 2300 gas limit
623      * imposed by `transfer`, making them unable to receive funds via
624      * `transfer`. {sendValue} removes this limitation.
625      *
626      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
627      *
628      * IMPORTANT: because control is transferred to `recipient`, care must be
629      * taken to not create reentrancy vulnerabilities. Consider using
630      * {ReentrancyGuard} or the
631      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
632      */
633     function sendValue(address payable recipient, uint256 amount) internal {
634         require(address(this).balance >= amount, "Address: insufficient balance");
635 
636         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
637         (bool success, ) = recipient.call{ value: amount }("");
638         require(success, "Address: unable to send value, recipient may have reverted");
639     }
640 
641     /**
642      * @dev Performs a Solidity function call using a low level `call`. A
643      * plain`call` is an unsafe replacement for a function call: use this
644      * function instead.
645      *
646      * If `target` reverts with a revert reason, it is bubbled up by this
647      * function (like regular Solidity function calls).
648      *
649      * Returns the raw returned data. To convert to the expected return value,
650      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
651      *
652      * Requirements:
653      *
654      * - `target` must be a contract.
655      * - calling `target` with `data` must not revert.
656      *
657      * _Available since v3.1._
658      */
659     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
660       return functionCall(target, data, "Address: low-level call failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
665      * `errorMessage` as a fallback revert reason when `target` reverts.
666      *
667      * _Available since v3.1._
668      */
669     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
670         return functionCallWithValue(target, data, 0, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but also transferring `value` wei to `target`.
676      *
677      * Requirements:
678      *
679      * - the calling contract must have an ETH balance of at least `value`.
680      * - the called Solidity function must be `payable`.
681      *
682      * _Available since v3.1._
683      */
684     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
685         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
690      * with `errorMessage` as a fallback revert reason when `target` reverts.
691      *
692      * _Available since v3.1._
693      */
694     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
695         require(address(this).balance >= value, "Address: insufficient balance for call");
696         require(isContract(target), "Address: call to non-contract");
697 
698         // solhint-disable-next-line avoid-low-level-calls
699         (bool success, bytes memory returndata) = target.call{ value: value }(data);
700         return _verifyCallResult(success, returndata, errorMessage);
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
705      * but performing a static call.
706      *
707      * _Available since v3.3._
708      */
709     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
710         return functionStaticCall(target, data, "Address: low-level static call failed");
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
715      * but performing a static call.
716      *
717      * _Available since v3.3._
718      */
719     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
720         require(isContract(target), "Address: static call to non-contract");
721 
722         // solhint-disable-next-line avoid-low-level-calls
723         (bool success, bytes memory returndata) = target.staticcall(data);
724         return _verifyCallResult(success, returndata, errorMessage);
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
729      * but performing a delegate call.
730      *
731      * _Available since v3.4._
732      */
733     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
734         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
739      * but performing a delegate call.
740      *
741      * _Available since v3.4._
742      */
743     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
744         require(isContract(target), "Address: delegate call to non-contract");
745 
746         // solhint-disable-next-line avoid-low-level-calls
747         (bool success, bytes memory returndata) = target.delegatecall(data);
748         return _verifyCallResult(success, returndata, errorMessage);
749     }
750 
751     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
752         if (success) {
753             return returndata;
754         } else {
755             // Look for revert reason and bubble it up if present
756             if (returndata.length > 0) {
757                 // The easiest way to bubble the revert reason is using memory via assembly
758 
759                 // solhint-disable-next-line no-inline-assembly
760                 assembly {
761                     let returndata_size := mload(returndata)
762                     revert(add(32, returndata), returndata_size)
763                 }
764             } else {
765                 revert(errorMessage);
766             }
767         }
768     }
769 }
770 
771 contract SuperInu is Context, IERC20, Ownable {
772     using SafeMath for uint256;
773     using Address for address;
774 
775     mapping (address => uint256) private _rOwned;
776     mapping (address => uint256) private _tOwned;
777     mapping (address => mapping (address => uint256)) private _allowances;
778 
779     mapping (address => bool) private _isExcludedFromFee;
780 
781     mapping (address => bool) private _isExcluded;
782     address[] private _excluded;
783 
784     uint256 private constant MAX = ~uint256(0);
785     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
786     uint256 private _rTotal = (MAX - (MAX % _tTotal));
787     uint256 private _tFeeTotal;
788 
789     string private _name = "SuperInu";
790     string private _symbol = "SupInu";
791     uint8 private _decimals = 9;
792 
793     uint256 public _taxFee = 1;
794     uint256 private _previousTaxFee = _taxFee;
795 
796     uint256 public _liquidityFee = 3;
797     uint256 private _previousLiquidityFee = _liquidityFee;
798 
799     IUniswapV2Router02 public immutable uniswapV2Router;
800     address public immutable uniswapV2Pair;
801     address payable public fundAddress = 0xDeC527FB923316E171Ee9569A97c68831E639d12;
802 
803     bool inSwapAndLiquify;
804     bool public swapAndLiquifyEnabled = true;
805     bool public tradingEnabled = false;
806 
807     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
808     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
809 
810     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
811     event SwapAndLiquifyEnabledUpdated(bool enabled);
812     event SwapAndLiquify(
813         uint256 tokensSwapped,
814         uint256 ethReceived,
815         uint256 tokensIntoLiqudity
816     );
817 
818     modifier lockTheSwap {
819         inSwapAndLiquify = true;
820         _;
821         inSwapAndLiquify = false;
822     }
823 
824     constructor () public {
825         _rOwned[_msgSender()] = _rTotal;
826 
827         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
828 
829         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
830 
831         uniswapV2Router = _uniswapV2Router;
832 
833         _isExcludedFromFee[owner()] = true;
834         _isExcludedFromFee[address(this)] = true;
835 
836         emit Transfer(address(0), _msgSender(), _tTotal);
837     }
838 
839     function name() public view returns (string memory) {
840         return _name;
841     }
842 
843     function symbol() public view returns (string memory) {
844         return _symbol;
845     }
846 
847     function decimals() public view returns (uint8) {
848         return _decimals;
849     }
850 
851     function totalSupply() public view override returns (uint256) {
852         return _tTotal;
853     }
854 
855     function balanceOf(address account) public view override returns (uint256) {
856         if (_isExcluded[account]) return _tOwned[account];
857         return tokenFromReflection(_rOwned[account]);
858     }
859 
860     function transfer(address recipient, uint256 amount) public override returns (bool) {
861         _transfer(_msgSender(), recipient, amount);
862         return true;
863     }
864 
865     function allowance(address owner, address spender) public view override returns (uint256) {
866         return _allowances[owner][spender];
867     }
868 
869     function approve(address spender, uint256 amount) public override returns (bool) {
870         _approve(_msgSender(), spender, amount);
871         return true;
872     }
873 
874     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
875         _transfer(sender, recipient, amount);
876         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
877         return true;
878     }
879 
880     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
881         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
882         return true;
883     }
884 
885     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
886         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
887         return true;
888     }
889 
890     function isExcludedFromReward(address account) public view returns (bool) {
891         return _isExcluded[account];
892     }
893 
894     function totalFees() public view returns (uint256) {
895         return _tFeeTotal;
896     }
897 
898     function deliver(uint256 tAmount) public {
899         address sender = _msgSender();
900         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
901         (uint256 rAmount,,,,,) = _getValues(tAmount);
902         _rOwned[sender] = _rOwned[sender].sub(rAmount);
903         _rTotal = _rTotal.sub(rAmount);
904         _tFeeTotal = _tFeeTotal.add(tAmount);
905     }
906 
907     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
908         require(tAmount <= _tTotal, "Amount must be less than supply");
909         if (!deductTransferFee) {
910             (uint256 rAmount,,,,,) = _getValues(tAmount);
911             return rAmount;
912         } else {
913             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
914             return rTransferAmount;
915         }
916     }
917 
918     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
919         require(rAmount <= _rTotal, "Amount must be less than total reflections");
920         uint256 currentRate =  _getRate();
921         return rAmount.div(currentRate);
922     }
923 
924     function excludeFromReward(address account) public onlyOwner() {
925         require(!_isExcluded[account], "Account is already excluded");
926         if(_rOwned[account] > 0) {
927             _tOwned[account] = tokenFromReflection(_rOwned[account]);
928         }
929         _isExcluded[account] = true;
930         _excluded.push(account);
931     }
932 
933     function includeInReward(address account) external onlyOwner() {
934         require(_isExcluded[account], "Account is already excluded");
935         for (uint256 i = 0; i < _excluded.length; i++) {
936             if (_excluded[i] == account) {
937                 _excluded[i] = _excluded[_excluded.length - 1];
938                 _tOwned[account] = 0;
939                 _isExcluded[account] = false;
940                 _excluded.pop();
941                 break;
942             }
943         }
944     }
945     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
946         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
947         _tOwned[sender] = _tOwned[sender].sub(tAmount);
948         _rOwned[sender] = _rOwned[sender].sub(rAmount);
949         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
950         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
951         _takeLiquidity(tLiquidity);
952         _reflectFee(rFee, tFee);
953         emit Transfer(sender, recipient, tTransferAmount);
954     }
955 
956     function excludeFromFee(address account) public onlyOwner {
957         _isExcludedFromFee[account] = true;
958     }
959 
960     function includeInFee(address account) public onlyOwner {
961         _isExcludedFromFee[account] = false;
962     }
963 
964     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
965         _taxFee = taxFee;
966     }
967 
968     function setNumTokensSellToAddToLiquidity(uint256 newNumTokensSellToAddToLiquidity) external onlyOwner() {
969         numTokensSellToAddToLiquidity = newNumTokensSellToAddToLiquidity;
970     }
971 
972     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
973         _liquidityFee = liquidityFee;
974     }
975 
976     function setFundAddress(address payable newFundAddress) external onlyOwner() {
977         fundAddress = newFundAddress;
978     }
979 
980     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
981         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
982             10**2
983         );
984     }
985 
986     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
987         swapAndLiquifyEnabled = _enabled;
988         emit SwapAndLiquifyEnabledUpdated(_enabled);
989     }
990 
991     function enableTrading() external onlyOwner() {
992         tradingEnabled = true;
993     }
994 
995     receive() external payable {}
996 
997     function _reflectFee(uint256 rFee, uint256 tFee) private {
998         _rTotal = _rTotal.sub(rFee);
999         _tFeeTotal = _tFeeTotal.add(tFee);
1000     }
1001 
1002     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1003         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1004         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1005         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1006     }
1007 
1008     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1009         uint256 tFee = calculateTaxFee(tAmount);
1010         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1011         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1012         return (tTransferAmount, tFee, tLiquidity);
1013     }
1014 
1015     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1016         uint256 rAmount = tAmount.mul(currentRate);
1017         uint256 rFee = tFee.mul(currentRate);
1018         uint256 rLiquidity = tLiquidity.mul(currentRate);
1019         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1020         return (rAmount, rTransferAmount, rFee);
1021     }
1022 
1023     function _getRate() private view returns(uint256) {
1024         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1025         return rSupply.div(tSupply);
1026     }
1027 
1028     function _getCurrentSupply() private view returns(uint256, uint256) {
1029         uint256 rSupply = _rTotal;
1030         uint256 tSupply = _tTotal;
1031         for (uint256 i = 0; i < _excluded.length; i++) {
1032             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1033             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1034             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1035         }
1036         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1037         return (rSupply, tSupply);
1038     }
1039 
1040     function _takeLiquidity(uint256 tLiquidity) private {
1041         uint256 currentRate =  _getRate();
1042         uint256 rLiquidity = tLiquidity.mul(currentRate);
1043         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1044         if(_isExcluded[address(this)])
1045             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1046     }
1047 
1048     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1049         return _amount.mul(_taxFee).div(
1050             10**2
1051         );
1052     }
1053 
1054     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1055         return _amount.mul(_liquidityFee).div(
1056             10**2
1057         );
1058     }
1059 
1060     function removeAllFee() private {
1061         if(_taxFee == 0 && _liquidityFee == 0) return;
1062 
1063         _previousTaxFee = _taxFee;
1064         _previousLiquidityFee = _liquidityFee;
1065 
1066         _taxFee = 0;
1067         _liquidityFee = 0;
1068     }
1069 
1070     function restoreAllFee() private {
1071         _taxFee = _previousTaxFee;
1072         _liquidityFee = _previousLiquidityFee;
1073     }
1074 
1075     function isExcludedFromFee(address account) public view returns(bool) {
1076         return _isExcludedFromFee[account];
1077     }
1078 
1079     function _approve(address owner, address spender, uint256 amount) private {
1080         require(owner != address(0), "ERC20: approve from the zero address");
1081         require(spender != address(0), "ERC20: approve to the zero address");
1082 
1083         _allowances[owner][spender] = amount;
1084         emit Approval(owner, spender, amount);
1085     }
1086 
1087     function _transfer(
1088         address from,
1089         address to,
1090         uint256 amount
1091     ) private {
1092         require(from != address(0), "ERC20: transfer from the zero address");
1093         require(to != address(0), "ERC20: transfer to the zero address");
1094         require(amount > 0, "Transfer amount must be greater than zero");
1095 
1096         if(from != owner() && to != owner())
1097             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1098 
1099         if (from != owner() && !tradingEnabled) {
1100             require(tradingEnabled, "Trading is not enabled yet");
1101         }
1102 
1103         uint256 contractTokenBalance = balanceOf(address(this));
1104 
1105         if(contractTokenBalance >= _maxTxAmount)
1106         {
1107             contractTokenBalance = _maxTxAmount;
1108         }
1109 
1110         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1111         if (overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
1112             contractTokenBalance = numTokensSellToAddToLiquidity;
1113             swapAndLiquify(contractTokenBalance);
1114         }
1115 
1116         bool takeFee = true;
1117 
1118         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1119             takeFee = false;
1120         }
1121 
1122         _tokenTransfer(from,to,amount,takeFee);
1123     }
1124 
1125     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1126         uint256 oneSixth = contractTokenBalance.div(6);
1127         uint256 fiveSixths = oneSixth.mul(5);
1128         uint256 remainingSixth = contractTokenBalance.sub(fiveSixths);
1129 
1130         uint256 initialBalance = address(this).balance;
1131 
1132         swapTokensForEth(fiveSixths);
1133 
1134         uint256 newBalance = address(this).balance.sub(initialBalance);
1135         uint256 liquidityToAdd = newBalance.div(5);
1136 
1137         addLiquidity(remainingSixth, liquidityToAdd);
1138 
1139         fundAddress.transfer(address(this).balance);
1140 
1141         emit SwapAndLiquify(fiveSixths, newBalance, remainingSixth);
1142     }
1143 
1144     function swapTokensForEth(uint256 tokenAmount) private {
1145         address[] memory path = new address[](2);
1146         path[0] = address(this);
1147         path[1] = uniswapV2Router.WETH();
1148 
1149         _approve(address(this), address(uniswapV2Router), tokenAmount);
1150 
1151         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1152             tokenAmount,
1153             0,
1154             path,
1155             address(this),
1156             block.timestamp
1157         );
1158     }
1159 
1160     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1161         _approve(address(this), address(uniswapV2Router), tokenAmount);
1162 
1163         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1164             address(this),
1165             tokenAmount,
1166             0,
1167             0,
1168             owner(),
1169             block.timestamp
1170         );
1171     }
1172 
1173     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1174         if(!takeFee)
1175             removeAllFee();
1176 
1177         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1178             _transferFromExcluded(sender, recipient, amount);
1179         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1180             _transferToExcluded(sender, recipient, amount);
1181         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1182             _transferStandard(sender, recipient, amount);
1183         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1184             _transferBothExcluded(sender, recipient, amount);
1185         } else {
1186             _transferStandard(sender, recipient, amount);
1187         }
1188 
1189         if(!takeFee)
1190             restoreAllFee();
1191     }
1192 
1193     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1194         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1195         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1196         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1197         _takeLiquidity(tLiquidity);
1198         _reflectFee(rFee, tFee);
1199         emit Transfer(sender, recipient, tTransferAmount);
1200     }
1201 
1202     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1203         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1204         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1205         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1206         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1207         _takeLiquidity(tLiquidity);
1208         _reflectFee(rFee, tFee);
1209         emit Transfer(sender, recipient, tTransferAmount);
1210     }
1211 
1212     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1213         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1214         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1215         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1216         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1217         _takeLiquidity(tLiquidity);
1218         _reflectFee(rFee, tFee);
1219         emit Transfer(sender, recipient, tTransferAmount);
1220     }
1221 }