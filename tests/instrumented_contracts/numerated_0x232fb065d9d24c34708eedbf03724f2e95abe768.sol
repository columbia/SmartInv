1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
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
77 }
78 
79 // File: @uniswap\v2-core\contracts\interfaces\IUniswapV2Pair.sol
80 
81 pragma solidity >=0.5.0;
82 
83 interface IUniswapV2Pair {
84     event Approval(address indexed owner, address indexed spender, uint value);
85     event Transfer(address indexed from, address indexed to, uint value);
86 
87     function name() external pure returns (string memory);
88     function symbol() external pure returns (string memory);
89     function decimals() external pure returns (uint8);
90     function totalSupply() external view returns (uint);
91     function balanceOf(address owner) external view returns (uint);
92     function allowance(address owner, address spender) external view returns (uint);
93 
94     function approve(address spender, uint value) external returns (bool);
95     function transfer(address to, uint value) external returns (bool);
96     function transferFrom(address from, address to, uint value) external returns (bool);
97 
98     function DOMAIN_SEPARATOR() external view returns (bytes32);
99     function PERMIT_TYPEHASH() external pure returns (bytes32);
100     function nonces(address owner) external view returns (uint);
101 
102     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
103 
104     event Mint(address indexed sender, uint amount0, uint amount1);
105     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
106     event Swap(
107         address indexed sender,
108         uint amount0In,
109         uint amount1In,
110         uint amount0Out,
111         uint amount1Out,
112         address indexed to
113     );
114     event Sync(uint112 reserve0, uint112 reserve1);
115 
116     function MINIMUM_LIQUIDITY() external pure returns (uint);
117     function factory() external view returns (address);
118     function token0() external view returns (address);
119     function token1() external view returns (address);
120     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
121     function price0CumulativeLast() external view returns (uint);
122     function price1CumulativeLast() external view returns (uint);
123     function kLast() external view returns (uint);
124 
125     function mint(address to) external returns (uint liquidity);
126     function burn(address to) external returns (uint amount0, uint amount1);
127     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
128     function skim(address to) external;
129     function sync() external;
130 
131     function initialize(address, address) external;
132 }
133 
134 // File: @uniswap\v2-core\contracts\interfaces\IUniswapV2Factory.sol
135 
136 pragma solidity >=0.5.0;
137 
138 interface IUniswapV2Factory {
139     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
140 
141     function feeTo() external view returns (address);
142     function feeToSetter() external view returns (address);
143 
144     function getPair(address tokenA, address tokenB) external view returns (address pair);
145     function allPairs(uint) external view returns (address pair);
146     function allPairsLength() external view returns (uint);
147 
148     function createPair(address tokenA, address tokenB) external returns (address pair);
149 
150     function setFeeTo(address) external;
151     function setFeeToSetter(address) external;
152 }
153 
154 // File: node_modules\@uniswap\v2-periphery\contracts\interfaces\IUniswapV2Router01.sol
155 
156 pragma solidity >=0.6.2;
157 
158 interface IUniswapV2Router01 {
159     function factory() external pure returns (address);
160     function WETH() external pure returns (address);
161 
162     function addLiquidity(
163         address tokenA,
164         address tokenB,
165         uint amountADesired,
166         uint amountBDesired,
167         uint amountAMin,
168         uint amountBMin,
169         address to,
170         uint deadline
171     ) external returns (uint amountA, uint amountB, uint liquidity);
172     function addLiquidityETH(
173         address token,
174         uint amountTokenDesired,
175         uint amountTokenMin,
176         uint amountETHMin,
177         address to,
178         uint deadline
179     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
180     function removeLiquidity(
181         address tokenA,
182         address tokenB,
183         uint liquidity,
184         uint amountAMin,
185         uint amountBMin,
186         address to,
187         uint deadline
188     ) external returns (uint amountA, uint amountB);
189     function removeLiquidityETH(
190         address token,
191         uint liquidity,
192         uint amountTokenMin,
193         uint amountETHMin,
194         address to,
195         uint deadline
196     ) external returns (uint amountToken, uint amountETH);
197     function removeLiquidityWithPermit(
198         address tokenA,
199         address tokenB,
200         uint liquidity,
201         uint amountAMin,
202         uint amountBMin,
203         address to,
204         uint deadline,
205         bool approveMax, uint8 v, bytes32 r, bytes32 s
206     ) external returns (uint amountA, uint amountB);
207     function removeLiquidityETHWithPermit(
208         address token,
209         uint liquidity,
210         uint amountTokenMin,
211         uint amountETHMin,
212         address to,
213         uint deadline,
214         bool approveMax, uint8 v, bytes32 r, bytes32 s
215     ) external returns (uint amountToken, uint amountETH);
216     function swapExactTokensForTokens(
217         uint amountIn,
218         uint amountOutMin,
219         address[] calldata path,
220         address to,
221         uint deadline
222     ) external returns (uint[] memory amounts);
223     function swapTokensForExactTokens(
224         uint amountOut,
225         uint amountInMax,
226         address[] calldata path,
227         address to,
228         uint deadline
229     ) external returns (uint[] memory amounts);
230     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
231         external
232         payable
233         returns (uint[] memory amounts);
234     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
235         external
236         returns (uint[] memory amounts);
237     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
238         external
239         returns (uint[] memory amounts);
240     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
241         external
242         payable
243         returns (uint[] memory amounts);
244 
245     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
246     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
247     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
248     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
249     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
250 }
251 
252 // File: @uniswap\v2-periphery\contracts\interfaces\IUniswapV2Router02.sol
253 
254 pragma solidity >=0.6.2;
255 
256 
257 interface IUniswapV2Router02 is IUniswapV2Router01 {
258     function removeLiquidityETHSupportingFeeOnTransferTokens(
259         address token,
260         uint liquidity,
261         uint amountTokenMin,
262         uint amountETHMin,
263         address to,
264         uint deadline
265     ) external returns (uint amountETH);
266     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
267         address token,
268         uint liquidity,
269         uint amountTokenMin,
270         uint amountETHMin,
271         address to,
272         uint deadline,
273         bool approveMax, uint8 v, bytes32 r, bytes32 s
274     ) external returns (uint amountETH);
275 
276     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
277         uint amountIn,
278         uint amountOutMin,
279         address[] calldata path,
280         address to,
281         uint deadline
282     ) external;
283     function swapExactETHForTokensSupportingFeeOnTransferTokens(
284         uint amountOutMin,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external payable;
289     function swapExactTokensForETHSupportingFeeOnTransferTokens(
290         uint amountIn,
291         uint amountOutMin,
292         address[] calldata path,
293         address to,
294         uint deadline
295     ) external;
296 }
297 
298 // File: @uniswap\v2-periphery\contracts\interfaces\IWETH.sol
299 
300 pragma solidity >=0.5.0;
301 
302 interface IWETH {
303     function deposit() external payable;
304     function transfer(address to, uint value) external returns (bool);
305     function withdraw(uint) external;
306 }
307 
308 // File: @openzeppelin\contracts\utils\Address.sol
309 
310 pragma solidity >=0.6.2 <0.8.0;
311 
312 /**
313  * @dev Collection of functions related to the address type
314  */
315 library Address {
316     /**
317      * @dev Returns true if `account` is a contract.
318      *
319      * [IMPORTANT]
320      * ====
321      * It is unsafe to assume that an address for which this function returns
322      * false is an externally-owned account (EOA) and not a contract.
323      *
324      * Among others, `isContract` will return false for the following
325      * types of addresses:
326      *
327      *  - an externally-owned account
328      *  - a contract in construction
329      *  - an address where a contract will be created
330      *  - an address where a contract lived, but was destroyed
331      * ====
332      */
333     function isContract(address account) internal view returns (bool) {
334         // This method relies on extcodesize, which returns 0 for contracts in
335         // construction, since the code is only stored at the end of the
336         // constructor execution.
337 
338         uint256 size;
339         // solhint-disable-next-line no-inline-assembly
340         assembly { size := extcodesize(account) }
341         return size > 0;
342     }
343 
344     /**
345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346      * `recipient`, forwarding all available gas and reverting on errors.
347      *
348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
350      * imposed by `transfer`, making them unable to receive funds via
351      * `transfer`. {sendValue} removes this limitation.
352      *
353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354      *
355      * IMPORTANT: because control is transferred to `recipient`, care must be
356      * taken to not create reentrancy vulnerabilities. Consider using
357      * {ReentrancyGuard} or the
358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
364         (bool success, ) = recipient.call{ value: amount }("");
365         require(success, "Address: unable to send value, recipient may have reverted");
366     }
367 
368     /**
369      * @dev Performs a Solidity function call using a low level `call`. A
370      * plain`call` is an unsafe replacement for a function call: use this
371      * function instead.
372      *
373      * If `target` reverts with a revert reason, it is bubbled up by this
374      * function (like regular Solidity function calls).
375      *
376      * Returns the raw returned data. To convert to the expected return value,
377      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378      *
379      * Requirements:
380      *
381      * - `target` must be a contract.
382      * - calling `target` with `data` must not revert.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
387       return functionCall(target, data, "Address: low-level call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
392      * `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, 0, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but also transferring `value` wei to `target`.
403      *
404      * Requirements:
405      *
406      * - the calling contract must have an ETH balance of at least `value`.
407      * - the called Solidity function must be `payable`.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
417      * with `errorMessage` as a fallback revert reason when `target` reverts.
418      *
419      * _Available since v3.1._
420      */
421     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
422         require(address(this).balance >= value, "Address: insufficient balance for call");
423         require(isContract(target), "Address: call to non-contract");
424 
425         // solhint-disable-next-line avoid-low-level-calls
426         (bool success, bytes memory returndata) = target.call{ value: value }(data);
427         return _verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
437         return functionStaticCall(target, data, "Address: low-level static call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
447         require(isContract(target), "Address: static call to non-contract");
448 
449         // solhint-disable-next-line avoid-low-level-calls
450         (bool success, bytes memory returndata) = target.staticcall(data);
451         return _verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 // solhint-disable-next-line no-inline-assembly
463                 assembly {
464                     let returndata_size := mload(returndata)
465                     revert(add(32, returndata), returndata_size)
466                 }
467             } else {
468                 revert(errorMessage);
469             }
470         }
471     }
472 }
473 
474 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
475 
476 pragma solidity >=0.6.0 <0.8.0;
477 
478 /*
479  * @dev Provides information about the current execution context, including the
480  * sender of the transaction and its data. While these are generally available
481  * via msg.sender and msg.data, they should not be accessed in such a direct
482  * manner, since when dealing with GSN meta-transactions the account sending and
483  * paying for execution may not be the actual sender (as far as an application
484  * is concerned).
485  *
486  * This contract is only required for intermediate, library-like contracts.
487  */
488 abstract contract Context {
489     function _msgSender() internal view virtual returns (address payable) {
490         return msg.sender;
491     }
492 
493     function _msgData() internal view virtual returns (bytes memory) {
494         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
495         return msg.data;
496     }
497 }
498 
499 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
500 
501 pragma solidity >=0.6.0 <0.8.0;
502 
503 /**
504  * @dev Wrappers over Solidity's arithmetic operations with added overflow
505  * checks.
506  *
507  * Arithmetic operations in Solidity wrap on overflow. This can easily result
508  * in bugs, because programmers usually assume that an overflow raises an
509  * error, which is the standard behavior in high level programming languages.
510  * `SafeMath` restores this intuition by reverting the transaction when an
511  * operation overflows.
512  *
513  * Using this library instead of the unchecked operations eliminates an entire
514  * class of bugs, so it's recommended to use it always.
515  */
516 library SafeMath {
517     /**
518      * @dev Returns the addition of two unsigned integers, reverting on
519      * overflow.
520      *
521      * Counterpart to Solidity's `+` operator.
522      *
523      * Requirements:
524      *
525      * - Addition cannot overflow.
526      */
527     function add(uint256 a, uint256 b) internal pure returns (uint256) {
528         uint256 c = a + b;
529         require(c >= a, "SafeMath: addition overflow");
530 
531         return c;
532     }
533 
534     /**
535      * @dev Returns the subtraction of two unsigned integers, reverting on
536      * overflow (when the result is negative).
537      *
538      * Counterpart to Solidity's `-` operator.
539      *
540      * Requirements:
541      *
542      * - Subtraction cannot overflow.
543      */
544     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
545         return sub(a, b, "SafeMath: subtraction overflow");
546     }
547 
548     /**
549      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
550      * overflow (when the result is negative).
551      *
552      * Counterpart to Solidity's `-` operator.
553      *
554      * Requirements:
555      *
556      * - Subtraction cannot overflow.
557      */
558     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
559         require(b <= a, errorMessage);
560         uint256 c = a - b;
561 
562         return c;
563     }
564 
565     /**
566      * @dev Returns the multiplication of two unsigned integers, reverting on
567      * overflow.
568      *
569      * Counterpart to Solidity's `*` operator.
570      *
571      * Requirements:
572      *
573      * - Multiplication cannot overflow.
574      */
575     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
576         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
577         // benefit is lost if 'b' is also tested.
578         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
579         if (a == 0) {
580             return 0;
581         }
582 
583         uint256 c = a * b;
584         require(c / a == b, "SafeMath: multiplication overflow");
585 
586         return c;
587     }
588 
589     /**
590      * @dev Returns the integer division of two unsigned integers. Reverts on
591      * division by zero. The result is rounded towards zero.
592      *
593      * Counterpart to Solidity's `/` operator. Note: this function uses a
594      * `revert` opcode (which leaves remaining gas untouched) while Solidity
595      * uses an invalid opcode to revert (consuming all remaining gas).
596      *
597      * Requirements:
598      *
599      * - The divisor cannot be zero.
600      */
601     function div(uint256 a, uint256 b) internal pure returns (uint256) {
602         return div(a, b, "SafeMath: division by zero");
603     }
604 
605     /**
606      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
607      * division by zero. The result is rounded towards zero.
608      *
609      * Counterpart to Solidity's `/` operator. Note: this function uses a
610      * `revert` opcode (which leaves remaining gas untouched) while Solidity
611      * uses an invalid opcode to revert (consuming all remaining gas).
612      *
613      * Requirements:
614      *
615      * - The divisor cannot be zero.
616      */
617     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
618         require(b > 0, errorMessage);
619         uint256 c = a / b;
620         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
621 
622         return c;
623     }
624 
625     /**
626      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
627      * Reverts when dividing by zero.
628      *
629      * Counterpart to Solidity's `%` operator. This function uses a `revert`
630      * opcode (which leaves remaining gas untouched) while Solidity uses an
631      * invalid opcode to revert (consuming all remaining gas).
632      *
633      * Requirements:
634      *
635      * - The divisor cannot be zero.
636      */
637     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
638         return mod(a, b, "SafeMath: modulo by zero");
639     }
640 
641     /**
642      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
643      * Reverts with custom message when dividing by zero.
644      *
645      * Counterpart to Solidity's `%` operator. This function uses a `revert`
646      * opcode (which leaves remaining gas untouched) while Solidity uses an
647      * invalid opcode to revert (consuming all remaining gas).
648      *
649      * Requirements:
650      *
651      * - The divisor cannot be zero.
652      */
653     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
654         require(b != 0, errorMessage);
655         return a % b;
656     }
657 }
658 
659 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
660 
661 pragma solidity >=0.6.0 <0.8.0;
662 
663 
664 
665 
666 /**
667  * @dev Implementation of the {IERC20} interface.
668  *
669  * This implementation is agnostic to the way tokens are created. This means
670  * that a supply mechanism has to be added in a derived contract using {_mint}.
671  * For a generic mechanism see {ERC20PresetMinterPauser}.
672  *
673  * TIP: For a detailed writeup see our guide
674  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
675  * to implement supply mechanisms].
676  *
677  * We have followed general OpenZeppelin guidelines: functions revert instead
678  * of returning `false` on failure. This behavior is nonetheless conventional
679  * and does not conflict with the expectations of ERC20 applications.
680  *
681  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
682  * This allows applications to reconstruct the allowance for all accounts just
683  * by listening to said events. Other implementations of the EIP may not emit
684  * these events, as it isn't required by the specification.
685  *
686  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
687  * functions have been added to mitigate the well-known issues around setting
688  * allowances. See {IERC20-approve}.
689  */
690 contract ERC20 is Context, IERC20 {
691     using SafeMath for uint256;
692 
693     mapping (address => uint256) private _balances;
694 
695     mapping (address => mapping (address => uint256)) private _allowances;
696 
697     uint256 private _totalSupply;
698 
699     string private _name;
700     string private _symbol;
701     uint8 private _decimals;
702 
703     /**
704      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
705      * a default value of 18.
706      *
707      * To select a different value for {decimals}, use {_setupDecimals}.
708      *
709      * All three of these values are immutable: they can only be set once during
710      * construction.
711      */
712     constructor (string memory name_, string memory symbol_) public {
713         _name = name_;
714         _symbol = symbol_;
715         _decimals = 18;
716     }
717 
718     /**
719      * @dev Returns the name of the token.
720      */
721     function name() public view returns (string memory) {
722         return _name;
723     }
724 
725     /**
726      * @dev Returns the symbol of the token, usually a shorter version of the
727      * name.
728      */
729     function symbol() public view returns (string memory) {
730         return _symbol;
731     }
732 
733     /**
734      * @dev Returns the number of decimals used to get its user representation.
735      * For example, if `decimals` equals `2`, a balance of `505` tokens should
736      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
737      *
738      * Tokens usually opt for a value of 18, imitating the relationship between
739      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
740      * called.
741      *
742      * NOTE: This information is only used for _display_ purposes: it in
743      * no way affects any of the arithmetic of the contract, including
744      * {IERC20-balanceOf} and {IERC20-transfer}.
745      */
746     function decimals() public view returns (uint8) {
747         return _decimals;
748     }
749 
750     /**
751      * @dev See {IERC20-totalSupply}.
752      */
753     function totalSupply() public view override returns (uint256) {
754         return _totalSupply;
755     }
756 
757     /**
758      * @dev See {IERC20-balanceOf}.
759      */
760     function balanceOf(address account) public view override returns (uint256) {
761         return _balances[account];
762     }
763 
764     /**
765      * @dev See {IERC20-transfer}.
766      *
767      * Requirements:
768      *
769      * - `recipient` cannot be the zero address.
770      * - the caller must have a balance of at least `amount`.
771      */
772     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
773         _transfer(_msgSender(), recipient, amount);
774         return true;
775     }
776 
777     /**
778      * @dev See {IERC20-allowance}.
779      */
780     function allowance(address owner, address spender) public view virtual override returns (uint256) {
781         return _allowances[owner][spender];
782     }
783 
784     /**
785      * @dev See {IERC20-approve}.
786      *
787      * Requirements:
788      *
789      * - `spender` cannot be the zero address.
790      */
791     function approve(address spender, uint256 amount) public virtual override returns (bool) {
792         _approve(_msgSender(), spender, amount);
793         return true;
794     }
795 
796     /**
797      * @dev See {IERC20-transferFrom}.
798      *
799      * Emits an {Approval} event indicating the updated allowance. This is not
800      * required by the EIP. See the note at the beginning of {ERC20}.
801      *
802      * Requirements:
803      *
804      * - `sender` and `recipient` cannot be the zero address.
805      * - `sender` must have a balance of at least `amount`.
806      * - the caller must have allowance for ``sender``'s tokens of at least
807      * `amount`.
808      */
809     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
810         _transfer(sender, recipient, amount);
811         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
812         return true;
813     }
814 
815     /**
816      * @dev Atomically increases the allowance granted to `spender` by the caller.
817      *
818      * This is an alternative to {approve} that can be used as a mitigation for
819      * problems described in {IERC20-approve}.
820      *
821      * Emits an {Approval} event indicating the updated allowance.
822      *
823      * Requirements:
824      *
825      * - `spender` cannot be the zero address.
826      */
827     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
828         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
829         return true;
830     }
831 
832     /**
833      * @dev Atomically decreases the allowance granted to `spender` by the caller.
834      *
835      * This is an alternative to {approve} that can be used as a mitigation for
836      * problems described in {IERC20-approve}.
837      *
838      * Emits an {Approval} event indicating the updated allowance.
839      *
840      * Requirements:
841      *
842      * - `spender` cannot be the zero address.
843      * - `spender` must have allowance for the caller of at least
844      * `subtractedValue`.
845      */
846     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
847         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
848         return true;
849     }
850 
851     /**
852      * @dev Moves tokens `amount` from `sender` to `recipient`.
853      *
854      * This is internal function is equivalent to {transfer}, and can be used to
855      * e.g. implement automatic token fees, slashing mechanisms, etc.
856      *
857      * Emits a {Transfer} event.
858      *
859      * Requirements:
860      *
861      * - `sender` cannot be the zero address.
862      * - `recipient` cannot be the zero address.
863      * - `sender` must have a balance of at least `amount`.
864      */
865     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
866         require(sender != address(0), "ERC20: transfer from the zero address");
867         require(recipient != address(0), "ERC20: transfer to the zero address");
868 
869         _beforeTokenTransfer(sender, recipient, amount);
870 
871         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
872         _balances[recipient] = _balances[recipient].add(amount);
873         emit Transfer(sender, recipient, amount);
874     }
875 
876     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
877      * the total supply.
878      *
879      * Emits a {Transfer} event with `from` set to the zero address.
880      *
881      * Requirements:
882      *
883      * - `to` cannot be the zero address.
884      */
885     function _mint(address account, uint256 amount) internal virtual {
886         require(account != address(0), "ERC20: mint to the zero address");
887 
888         _beforeTokenTransfer(address(0), account, amount);
889 
890         _totalSupply = _totalSupply.add(amount);
891         _balances[account] = _balances[account].add(amount);
892         emit Transfer(address(0), account, amount);
893     }
894 
895     /**
896      * @dev Destroys `amount` tokens from `account`, reducing the
897      * total supply.
898      *
899      * Emits a {Transfer} event with `to` set to the zero address.
900      *
901      * Requirements:
902      *
903      * - `account` cannot be the zero address.
904      * - `account` must have at least `amount` tokens.
905      */
906     function _burn(address account, uint256 amount) internal virtual {
907         require(account != address(0), "ERC20: burn from the zero address");
908 
909         _beforeTokenTransfer(account, address(0), amount);
910 
911         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
912         _totalSupply = _totalSupply.sub(amount);
913         emit Transfer(account, address(0), amount);
914     }
915 
916     /**
917      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
918      *
919      * This internal function is equivalent to `approve`, and can be used to
920      * e.g. set automatic allowances for certain subsystems, etc.
921      *
922      * Emits an {Approval} event.
923      *
924      * Requirements:
925      *
926      * - `owner` cannot be the zero address.
927      * - `spender` cannot be the zero address.
928      */
929     function _approve(address owner, address spender, uint256 amount) internal virtual {
930         require(owner != address(0), "ERC20: approve from the zero address");
931         require(spender != address(0), "ERC20: approve to the zero address");
932 
933         _allowances[owner][spender] = amount;
934         emit Approval(owner, spender, amount);
935     }
936 
937     /**
938      * @dev Sets {decimals} to a value other than the default one of 18.
939      *
940      * WARNING: This function should only be called from the constructor. Most
941      * applications that interact with token contracts will not expect
942      * {decimals} to ever change, and may work incorrectly if it does.
943      */
944     function _setupDecimals(uint8 decimals_) internal {
945         _decimals = decimals_;
946     }
947 
948     /**
949      * @dev Hook that is called before any transfer of tokens. This includes
950      * minting and burning.
951      *
952      * Calling conditions:
953      *
954      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
955      * will be to transferred to `to`.
956      * - when `from` is zero, `amount` tokens will be minted for `to`.
957      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
958      * - `from` and `to` are never both zero.
959      *
960      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
961      */
962     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
963 }
964 
965 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
966 
967 pragma solidity >=0.6.0 <0.8.0;
968 
969 
970 
971 /**
972  * @dev Extension of {ERC20} that allows token holders to destroy both their own
973  * tokens and those that they have an allowance for, in a way that can be
974  * recognized off-chain (via event analysis).
975  */
976 abstract contract ERC20Burnable is Context, ERC20 {
977     using SafeMath for uint256;
978 
979     /**
980      * @dev Destroys `amount` tokens from the caller.
981      *
982      * See {ERC20-_burn}.
983      */
984     function burn(uint256 amount) public virtual {
985         _burn(_msgSender(), amount);
986     }
987 
988     /**
989      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
990      * allowance.
991      *
992      * See {ERC20-_burn} and {ERC20-allowance}.
993      *
994      * Requirements:
995      *
996      * - the caller must have allowance for ``accounts``'s tokens of at least
997      * `amount`.
998      */
999     function burnFrom(address account, uint256 amount) public virtual {
1000         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1001 
1002         _approve(account, _msgSender(), decreasedAllowance);
1003         _burn(account, amount);
1004     }
1005 }
1006 
1007 // File: @openzeppelin\contracts\access\Ownable.sol
1008 
1009 pragma solidity >=0.6.0 <0.8.0;
1010 
1011 /**
1012  * @dev Contract module which provides a basic access control mechanism, where
1013  * there is an account (an owner) that can be granted exclusive access to
1014  * specific functions.
1015  *
1016  * By default, the owner account will be the one that deploys the contract. This
1017  * can later be changed with {transferOwnership}.
1018  *
1019  * This module is used through inheritance. It will make available the modifier
1020  * `onlyOwner`, which can be applied to your functions to restrict their use to
1021  * the owner.
1022  */
1023 abstract contract Ownable is Context {
1024     address private _owner;
1025 
1026     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1027 
1028     /**
1029      * @dev Initializes the contract setting the deployer as the initial owner.
1030      */
1031     constructor () internal {
1032         address msgSender = _msgSender();
1033         _owner = msgSender;
1034         emit OwnershipTransferred(address(0), msgSender);
1035     }
1036 
1037     /**
1038      * @dev Returns the address of the current owner.
1039      */
1040     function owner() public view returns (address) {
1041         return _owner;
1042     }
1043 
1044     /**
1045      * @dev Throws if called by any account other than the owner.
1046      */
1047     modifier onlyOwner() {
1048         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1049         _;
1050     }
1051 
1052     /**
1053      * @dev Leaves the contract without owner. It will not be possible to call
1054      * `onlyOwner` functions anymore. Can only be called by the current owner.
1055      *
1056      * NOTE: Renouncing ownership will leave the contract without an owner,
1057      * thereby removing any functionality that is only available to the owner.
1058      */
1059     function renounceOwnership() public virtual onlyOwner {
1060         emit OwnershipTransferred(_owner, address(0));
1061         _owner = address(0);
1062     }
1063 
1064     /**
1065      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1066      * Can only be called by the current owner.
1067      */
1068     function transferOwnership(address newOwner) public virtual onlyOwner {
1069         require(newOwner != address(0), "Ownable: new owner is the zero address");
1070         emit OwnershipTransferred(_owner, newOwner);
1071         _owner = newOwner;
1072     }
1073 }
1074 
1075 // File: contracts\SHEESHA.sol
1076 
1077 pragma solidity 0.7.6;
1078 
1079 
1080 
1081 
1082 contract SHEESHA is ERC20Burnable, Ownable {
1083     using SafeMath for uint256;
1084 
1085     //100,000 tokens
1086     uint256 public constant initialSupply = 100000e18;
1087     address public devAddress;
1088     address public teamAddress;
1089     address public marketingAddress;
1090     address public reserveAddress;
1091     bool public vaultTransferDone;
1092     bool public vaultLPTransferDone;
1093 
1094     // 15% team (4% monthly unlock over 25 months)
1095     // 10% dev
1096     // 10% marketing
1097     // 15% liquidity provision
1098     // 10% SHEESHA staking rewards
1099     // 20% LP rewards
1100     // 20% Reserve
1101 
1102     constructor(address _devAddress, address _marketingAddress, address _teamAddress, address _reserveAddress) ERC20("Sheesha Finance", "SHEESHA") {
1103         devAddress = _devAddress;
1104         marketingAddress = _marketingAddress;
1105         teamAddress = _teamAddress;
1106         reserveAddress = _reserveAddress;
1107         _mint(address(this), initialSupply);
1108         _transfer(address(this), devAddress, initialSupply.mul(10).div(100));
1109         _transfer(address(this), teamAddress, initialSupply.mul(15).div(100));
1110         _transfer(address(this), marketingAddress, initialSupply.mul(10).div(100));
1111         _transfer(address(this), reserveAddress, initialSupply.mul(20).div(100));
1112     }
1113 
1114     //one time only
1115     function transferVaultRewards(address _vaultAddress) public onlyOwner {
1116         require(!vaultTransferDone, "Already transferred");
1117         _transfer(address(this), _vaultAddress, initialSupply.mul(10).div(100));
1118         vaultTransferDone = true;
1119     }
1120 
1121     //one time only
1122     function transferVaultLPRewards(address _vaultLPAddress) public onlyOwner {
1123         require(!vaultLPTransferDone, "Already transferred");
1124         _transfer(address(this), _vaultLPAddress, initialSupply.mul(20).div(100));
1125         vaultLPTransferDone = true;
1126     }
1127 }
1128 
1129 // File: contracts\ISHEESHAGlobals.sol
1130 pragma solidity 0.7.6;
1131 
1132 interface ISHEESHAGlobals {
1133     function SHEESHATokenAddress() external view returns (address);
1134     function SHEESHAGlobalsAddress() external view returns (address);
1135     function SHEESHAVaultAddress() external view returns (address);
1136     function SHEESHAVaultLPAddress() external returns (address);
1137     function SHEESHAWETHUniPair() external view returns (address);
1138     function UniswapFactory() external view returns (address);
1139 }   
1140 
1141 // File: contracts\LGE.sol
1142 
1143 pragma solidity 0.7.6;
1144 
1145 
1146 
1147 
1148 
1149 
1150 
1151 
1152 interface ISHEESHAVaultLP {
1153     function depositFor(
1154         address,
1155         uint256,
1156         uint256
1157     ) external;
1158 }
1159 
1160 contract LGE is SHEESHA {
1161     using SafeMath for uint256;
1162     address public SHEESHAxWETHPair;
1163     IUniswapV2Router02 public uniswapRouterV2;
1164     IUniswapV2Factory public uniswapFactory;
1165     uint256 public totalLPTokensMinted;
1166     uint256 public totalETHContributed;
1167     uint256 public LPperETHUnit;
1168     bool public LPGenerationCompleted;
1169     uint256 public contractStartTimestamp;
1170     uint256 public constant lgeSupply = 15000e18; // 15k
1171     //user count
1172     uint256 public userCount;
1173     ISHEESHAGlobals public sheeshaGlobals;
1174 
1175     mapping(address => uint256) public ethContributed;
1176     mapping(address => bool) public claimed;
1177     mapping(uint256 => address) public userList;
1178     mapping(address => bool) internal isExisting;
1179 
1180     event LiquidityAddition(address indexed dst, uint256 value);
1181     event LPTokenClaimed(address dst, uint256 value);
1182 
1183     constructor(
1184         address router,
1185         address factory,
1186         ISHEESHAGlobals _sheeshaGlobals,
1187         address _devAddress,
1188         address _marketingAddress,
1189         address _teamAddress,
1190         address _reserveAddress
1191     ) SHEESHA(_devAddress, _marketingAddress, _teamAddress, _reserveAddress) {
1192         uniswapRouterV2 = IUniswapV2Router02(
1193             router != address(0)
1194                 ? router
1195                 : 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1196         ); // For testing
1197         uniswapFactory = IUniswapV2Factory(
1198             factory != address(0)
1199                 ? factory
1200                 : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
1201         ); // For testing
1202         createUniswapPairMainnet();
1203         contractStartTimestamp = block.timestamp;
1204         sheeshaGlobals = _sheeshaGlobals;
1205     }
1206 
1207     function getSecondsLeftInLiquidityGenerationEvent()
1208         public
1209         view
1210         returns (uint256)
1211     {
1212         require(liquidityGenerationOngoing(), "Event over");
1213         return contractStartTimestamp.add(14 days).sub(block.timestamp);
1214     }
1215 
1216     function liquidityGenerationOngoing() public view returns (bool) {
1217         //lge only for 2 weeks
1218         return contractStartTimestamp.add(14 days) > block.timestamp;
1219     }
1220 
1221     function createUniswapPairMainnet() internal returns (address) {
1222         require(SHEESHAxWETHPair == address(0), "Token: pool already created");
1223         SHEESHAxWETHPair = uniswapFactory.createPair(
1224             address(uniswapRouterV2.WETH()),
1225             address(this)
1226         );
1227         return SHEESHAxWETHPair;
1228     }
1229 
1230     //anyone/admin will call this function after 2 weeks to mint LGE
1231     // Sends all available balances and mints LP tokens
1232     // Possible ways this could break addressed
1233     // 1) Multiple calls and resetting amounts - addressed with boolean
1234     // 2) Failed WETH wrapping/unwrapping addressed with checks
1235     // 3) Failure to create LP tokens, addressed with checks
1236     // 4) Unacceptable division errors . Addressed with multiplications by 1e18
1237     // 5) Pair not set - impossible since its set in constructor
1238     function addLiquidityToUniswapSHEESHAxWETHPair() public {
1239         require(
1240             liquidityGenerationOngoing() == false,
1241             "Liquidity generation ongoing"
1242         );
1243         require(
1244             LPGenerationCompleted == false,
1245             "Liquidity generation already finished"
1246         );
1247         totalETHContributed = address(this).balance;
1248         IUniswapV2Pair pair = IUniswapV2Pair(SHEESHAxWETHPair);
1249         //Wrap eth
1250         address WETH = uniswapRouterV2.WETH();
1251         IWETH(WETH).deposit{value: totalETHContributed}();
1252         require(address(this).balance == 0, "Transfer Failed");
1253         IWETH(WETH).transfer(address(pair), totalETHContributed);
1254         transfer(address(pair), lgeSupply); // 15% in LGE
1255         pair.mint(address(this));
1256         totalLPTokensMinted = pair.balanceOf(address(this));
1257         require(totalLPTokensMinted != 0, "LP creation failed");
1258         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
1259         require(LPperETHUnit != 0, "LP creation failed");
1260         LPGenerationCompleted = true;
1261     }
1262 
1263     //people will send ETH to this function for LGE
1264     // Possible ways this could break addressed
1265     // 1) Adding liquidity after generaion is over - added require
1266     // 2) Overflow from uint - impossible there isnt that much ETH available
1267     // 3) Depositing 0 - not an issue it will just add 0 to tally
1268     function addLiquidity() public payable {
1269         require(
1270             liquidityGenerationOngoing() == true,
1271             "Liquidity Generation Event over"
1272         );
1273         ethContributed[msg.sender] += msg.value; // Overflow protection from safemath is not neded here
1274         totalETHContributed = totalETHContributed.add(msg.value); // for front end display during LGE. This resets with definitely correct balance while calling pair.
1275         if(!isUserExisting(msg.sender)) {
1276             userList[userCount] = msg.sender;
1277             userCount++;
1278             isExisting[msg.sender] = true;
1279         }
1280         emit LiquidityAddition(msg.sender, msg.value);
1281     }
1282 
1283     // Possible ways this could break addressed
1284     // 1) Accessing before event is over and resetting eth contributed -- added require
1285     // 2) No uniswap pair - impossible at this moment because of the LPGenerationCompleted bool
1286     // 3) LP per unit is 0 - impossible checked at generation function
1287     function _claimLPTokens() internal returns (uint256 amountLPToTransfer) {
1288         amountLPToTransfer = ethContributed[msg.sender].mul(LPperETHUnit).div(
1289             1e18
1290         );
1291         ethContributed[msg.sender] = 0;
1292         claimed[msg.sender] = true;
1293     }
1294 
1295     //pool id must be pool id of SHEESHAXWETH LP vault
1296     function claimAndStakeLP(uint256 _pid) public {
1297         require(
1298             LPGenerationCompleted == true,
1299             "LGE : Liquidity generation not finished yet"
1300         );
1301         require(ethContributed[msg.sender] > 0, "Nothing to claim, move along");
1302         require(claimed[msg.sender] == false, "LGE : Already claimed");
1303         address vault = sheeshaGlobals.SHEESHAVaultLPAddress();
1304         IUniswapV2Pair(SHEESHAxWETHPair).approve(vault, uint256(-1));
1305         ISHEESHAVaultLP(vault).depositFor(msg.sender, _pid, _claimLPTokens());
1306     }
1307 
1308     function getLPTokens(address _who)
1309         public
1310         view
1311         returns (uint256 amountLPToTransfer)
1312     {
1313         return ethContributed[_who].mul(LPperETHUnit).div(1e18);
1314     }
1315 
1316     function isUserExisting(address _who)
1317         public
1318         view
1319         returns (bool)
1320     {
1321         return isExisting[_who];
1322     }
1323 }