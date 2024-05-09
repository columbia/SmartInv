1 // File: contracts/Corlibri_Libraries.sol
2 
3 // SPDX-License-Identifier: WHO GIVES A FUCK ANYWAY??
4 
5 pragma solidity ^0.6.6;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations with added overflow
30  * checks.
31  *
32  * Arithmetic operations in Solidity wrap on overflow. This can easily result
33  * in bugs, because programmers usually assume that an overflow raises an
34  * error, which is the standard behavior in high level programming languages.
35  * `SafeMath` restores this intuition by reverting the transaction when an
36  * operation overflows.
37  *
38  * Using this library instead of the unchecked operations eliminates an entire
39  * class of bugs, so it's recommended to use it always.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `+` operator.
47      *
48      * Requirements:
49      *
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      *
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      *
81      * - Subtraction cannot overflow.
82      */
83     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the multiplication of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `*` operator.
95      *
96      * Requirements:
97      *
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return div(a, b, "SafeMath: division by zero");
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator. Note: this function uses a
135      * `revert` opcode (which leaves remaining gas untouched) while Solidity
136      * uses an invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b > 0, errorMessage);
144         uint256 c = a / b;
145         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return mod(a, b, "SafeMath: modulo by zero");
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts with custom message when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b != 0, errorMessage);
180         return a % b;
181     }
182 }
183 
184 library Address {
185     /**
186      * @dev Returns true if `account` is a contract.
187      *
188      * [IMPORTANT]
189      * ====
190      * It is unsafe to assume that an address for which this function returns
191      * false is an externally-owned account (EOA) and not a contract.
192      *
193      * Among others, `isContract` will return false for the following
194      * types of addresses:
195      *
196      *  - an externally-owned account
197      *  - a contract in construction
198      *  - an address where a contract will be created
199      *  - an address where a contract lived, but was destroyed
200      * ====
201      */
202     function isContract(address account) internal view returns (bool) {
203         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
204         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
205         // for accounts without code, i.e. `keccak256('')`
206         bytes32 codehash;
207         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
208         // solhint-disable-next-line no-inline-assembly
209         assembly { codehash := extcodehash(account) }
210         return (codehash != accountHash && codehash != 0x0);
211     }
212 
213     /**
214      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
215      * `recipient`, forwarding all available gas and reverting on errors.
216      *
217      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
218      * of certain opcodes, possibly making contracts go over the 2300 gas limit
219      * imposed by `transfer`, making them unable to receive funds via
220      * `transfer`. {sendValue} removes this limitation.
221      *
222      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
223      *
224      * IMPORTANT: because control is transferred to `recipient`, care must be
225      * taken to not create reentrancy vulnerabilities. Consider using
226      * {ReentrancyGuard} or the
227      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
228      */
229     function sendValue(address payable recipient, uint256 amount) internal {
230         require(address(this).balance >= amount, "Address: insufficient balance");
231 
232         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
233         (bool success, ) = recipient.call{ value: amount }("");
234         require(success, "Address: unable to send value, recipient may have reverted");
235     }
236 
237     /**
238      * @dev Performs a Solidity function call using a low level `call`. A
239      * plain`call` is an unsafe replacement for a function call: use this
240      * function instead.
241      *
242      * If `target` reverts with a revert reason, it is bubbled up by this
243      * function (like regular Solidity function calls).
244      *
245      * Returns the raw returned data. To convert to the expected return value,
246      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
247      *
248      * Requirements:
249      *
250      * - `target` must be a contract.
251      * - calling `target` with `data` must not revert.
252      *
253      * _Available since v3.1._
254      */
255     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
256       return functionCall(target, data, "Address: low-level call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
261      * `errorMessage` as a fallback revert reason when `target` reverts.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
266         return _functionCallWithValue(target, data, 0, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but also transferring `value` wei to `target`.
272      *
273      * Requirements:
274      *
275      * - the calling contract must have an ETH balance of at least `value`.
276      * - the called Solidity function must be `payable`.
277      *
278      * _Available since v3.1._
279      */
280     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
286      * with `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
291         require(address(this).balance >= value, "Address: insufficient balance for call");
292         return _functionCallWithValue(target, data, value, errorMessage);
293     }
294 
295     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
296         require(isContract(target), "Address: call to non-contract");
297 
298         // solhint-disable-next-line avoid-low-level-calls
299         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
300         if (success) {
301             return returndata;
302         } else {
303             // Look for revert reason and bubble it up if present
304             if (returndata.length > 0) {
305                 // The easiest way to bubble the revert reason is using memory via assembly
306 
307                 // solhint-disable-next-line no-inline-assembly
308                 assembly {
309                     let returndata_size := mload(returndata)
310                     revert(add(32, returndata), returndata_size)
311                 }
312             } else {
313                 revert(errorMessage);
314             }
315         }
316     }
317 }
318 
319 interface IERC20 {
320     /**
321      * @dev Returns the amount of tokens in existence.
322      */
323     function totalSupply() external view returns (uint256);
324 
325     /**
326      * @dev Returns the amount of tokens owned by `account`.
327      */
328     function balanceOf(address account) external view returns (uint256);
329 
330     /**
331      * @dev Moves `amount` tokens from the caller's account to `recipient`.
332      *
333      * Returns a boolean value indicating whether the operation succeeded.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transfer(address recipient, uint256 amount) external returns (bool);
338 
339     /**
340      * @dev Returns the remaining number of tokens that `spender` will be
341      * allowed to spend on behalf of `owner` through {transferFrom}. This is
342      * zero by default.
343      *
344      * This value changes when {approve} or {transferFrom} are called.
345      */
346     function allowance(address owner, address spender) external view returns (uint256);
347 
348     /**
349      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * IMPORTANT: Beware that changing an allowance with this method brings the risk
354      * that someone may use both the old and the new allowance by unfortunate
355      * transaction ordering. One possible solution to mitigate this race
356      * condition is to first reduce the spender's allowance to 0 and set the
357      * desired value afterwards:
358      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
359      *
360      * Emits an {Approval} event.
361      */
362     function approve(address spender, uint256 amount) external returns (bool);
363 
364     /**
365      * @dev Moves `amount` tokens from `sender` to `recipient` using the
366      * allowance mechanism. `amount` is then deducted from the caller's
367      * allowance.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * Emits a {Transfer} event.
372      */
373     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Emitted when `value` tokens are moved from one account (`from`) to
377      * another (`to`).
378      *
379      * Note that `value` may be zero.
380      */
381     event Transfer(address indexed from, address indexed to, uint256 value);
382 
383     /**
384      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
385      * a call to {approve}. `value` is the new allowance.
386      */
387     event Approval(address indexed owner, address indexed spender, uint256 value);
388 
389     event Log(string log);
390 
391 }
392 
393 // File: contracts/Corlibri_Interfaces.sol
394 
395 
396 
397 pragma solidity ^0.6.6;
398 
399 //CORLIBRI
400     interface ICorlibri {
401         function viewGovernanceLevel(address _address) external view returns(uint8);
402         function viewVault() external view returns(address);
403         function viewUNIv2() external view returns(address);
404         function viewWrappedUNIv2()external view returns(address);
405         function burnFromUni(uint256 _amount) external;
406     }
407 
408 //Nectar is wrapping Tokens, generates wrappped UNIv2
409     interface INectar {
410         function wrapUNIv2(uint256 amount) external;
411         function wTransfer(address recipient, uint256 amount) external;
412         function setPublicWrappingRatio(uint256 _ratioBase100) external;
413     }
414     
415 //VAULT
416     interface IVault {
417         function updateRewards() external;
418     }
419 
420 
421 //UNISWAP
422     interface IUniswapV2Factory {
423         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
424     
425         function feeTo() external view returns (address);
426         function feeToSetter() external view returns (address);
427         function migrator() external view returns (address);
428     
429         function getPair(address tokenA, address tokenB) external view returns (address pair);
430         function allPairs(uint) external view returns (address pair);
431         function allPairsLength() external view returns (uint);
432     
433         function createPair(address tokenA, address tokenB) external returns (address pair);
434     
435         function setFeeTo(address) external;
436         function setFeeToSetter(address) external;
437         function setMigrator(address) external;
438     }
439     interface IUniswapV2Router01 {
440         function factory() external pure returns (address);
441         function WETH() external pure returns (address);
442     
443         function addLiquidity(
444             address tokenA,
445             address tokenB,
446             uint amountADesired,
447             uint amountBDesired,
448             uint amountAMin,
449             uint amountBMin,
450             address to,
451             uint deadline
452         ) external returns (uint amountA, uint amountB, uint liquidity);
453         function addLiquidityETH(
454             address token,
455             uint amountTokenDesired,
456             uint amountTokenMin,
457             uint amountETHMin,
458             address to,
459             uint deadline
460         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
461         function removeLiquidity(
462             address tokenA,
463             address tokenB,
464             uint liquidity,
465             uint amountAMin,
466             uint amountBMin,
467             address to,
468             uint deadline
469         ) external returns (uint amountA, uint amountB);
470         function removeLiquidityETH(
471             address token,
472             uint liquidity,
473             uint amountTokenMin,
474             uint amountETHMin,
475             address to,
476             uint deadline
477         ) external returns (uint amountToken, uint amountETH);
478         function removeLiquidityWithPermit(
479             address tokenA,
480             address tokenB,
481             uint liquidity,
482             uint amountAMin,
483             uint amountBMin,
484             address to,
485             uint deadline,
486             bool approveMax, uint8 v, bytes32 r, bytes32 s
487         ) external returns (uint amountA, uint amountB);
488         function removeLiquidityETHWithPermit(
489             address token,
490             uint liquidity,
491             uint amountTokenMin,
492             uint amountETHMin,
493             address to,
494             uint deadline,
495             bool approveMax, uint8 v, bytes32 r, bytes32 s
496         ) external returns (uint amountToken, uint amountETH);
497         function swapExactTokensForTokens(
498             uint amountIn,
499             uint amountOutMin,
500             address[] calldata path,
501             address to,
502             uint deadline
503         ) external returns (uint[] memory amounts);
504         function swapTokensForExactTokens(
505             uint amountOut,
506             uint amountInMax,
507             address[] calldata path,
508             address to,
509             uint deadline
510         ) external returns (uint[] memory amounts);
511         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
512             external
513             payable
514             returns (uint[] memory amounts);
515         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
516             external
517             returns (uint[] memory amounts);
518         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
519             external
520             returns (uint[] memory amounts);
521         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
522             external
523             payable
524             returns (uint[] memory amounts);
525     
526         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
527         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
528         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
529         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
530         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
531     }
532     interface IUniswapV2Router02 is IUniswapV2Router01 {
533         function removeLiquidityETHSupportingFeeOnTransferTokens(
534             address token,
535             uint liquidity,
536             uint amountTokenMin,
537             uint amountETHMin,
538             address to,
539             uint deadline
540         ) external returns (uint amountETH);
541         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
542             address token,
543             uint liquidity,
544             uint amountTokenMin,
545             uint amountETHMin,
546             address to,
547             uint deadline,
548             bool approveMax, uint8 v, bytes32 r, bytes32 s
549         ) external returns (uint amountETH);
550     
551         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
552             uint amountIn,
553             uint amountOutMin,
554             address[] calldata path,
555             address to,
556             uint deadline
557         ) external;
558         function swapExactETHForTokensSupportingFeeOnTransferTokens(
559             uint amountOutMin,
560             address[] calldata path,
561             address to,
562             uint deadline
563         ) external payable;
564         function swapExactTokensForETHSupportingFeeOnTransferTokens(
565             uint amountIn,
566             uint amountOutMin,
567             address[] calldata path,
568             address to,
569             uint deadline
570         ) external;
571     }
572     interface IUniswapV2Pair {
573         event Approval(address indexed owner, address indexed spender, uint value);
574         event Transfer(address indexed from, address indexed to, uint value);
575     
576         function name() external pure returns (string memory);
577         function symbol() external pure returns (string memory);
578         function decimals() external pure returns (uint8);
579         function totalSupply() external view returns (uint);
580         function balanceOf(address owner) external view returns (uint);
581         function allowance(address owner, address spender) external view returns (uint);
582     
583         function approve(address spender, uint value) external returns (bool);
584         function transfer(address to, uint value) external returns (bool);
585         function transferFrom(address from, address to, uint value) external returns (bool);
586     
587         function DOMAIN_SEPARATOR() external view returns (bytes32);
588         function PERMIT_TYPEHASH() external pure returns (bytes32);
589         function nonces(address owner) external view returns (uint);
590     
591         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
592     
593         event Mint(address indexed sender, uint amount0, uint amount1);
594         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
595         event Swap(
596             address indexed sender,
597             uint amount0In,
598             uint amount1In,
599             uint amount0Out,
600             uint amount1Out,
601             address indexed to
602         );
603         event Sync(uint112 reserve0, uint112 reserve1);
604     
605         function MINIMUM_LIQUIDITY() external pure returns (uint);
606         function factory() external view returns (address);
607         function token0() external view returns (address);
608         function token1() external view returns (address);
609         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
610         function price0CumulativeLast() external view returns (uint);
611         function price1CumulativeLast() external view returns (uint);
612         function kLast() external view returns (uint);
613     
614         function mint(address to) external returns (uint liquidity);
615         function burn(address to) external returns (uint amount0, uint amount1);
616         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
617         function skim(address to) external;
618         function sync() external;
619     
620         function initialize(address, address) external;
621     }
622     interface IWETH {
623         function deposit() external payable;
624         function transfer(address to, uint value) external returns (bool);
625         function withdraw(uint) external;
626     }
627 
628 // File: contracts/Corlibri_ERC20.sol
629 
630 
631 
632 pragma solidity ^0.6.6;
633 
634 
635 
636 contract ERC20 is Context, IERC20 { 
637     using SafeMath for uint256;
638     using Address for address;
639 
640     mapping (address => uint256) private _balances;
641     mapping (address => mapping (address => uint256)) private _allowances;
642 
643     uint256 private _totalSupply;
644 
645     string private _name;
646     string private _symbol;
647     uint8 private _decimals;
648 
649     /**
650      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
651      * a default value of 18.
652      *
653      * To select a different value for {decimals}, use {_setupDecimals}.
654      *
655      * All three of these values are immutable: they can only be set once during
656      * construction.
657      */
658     constructor(string memory name, string memory symbol) public {
659         _name = name;
660         _symbol = symbol;
661         _decimals = 18;
662     }
663 
664 //Public Functions
665     /**
666      * @dev Returns the name of the token.
667      */
668     function name() public view returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev Returns the symbol of the token, usually a shorter version of the
674      * name.
675      */
676     function symbol() public view returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev Returns the number of decimals used to get its user representation.
682      * For example, if `decimals` equals `2`, a balance of `505` tokens should
683      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
684      *
685      * Tokens usually opt for a value of 18, imitating the relationship between
686      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
687      * called.
688      *
689      * NOTE: This information is only used for _display_ purposes: it in
690      * no way affects any of the arithmetic of the contract, including
691      * {IERC20-balanceOf} and {IERC20-transfer}.
692      */
693     function decimals() public view returns (uint8) {
694         return _decimals;
695     }
696 
697     /**
698      * @dev See {IERC20-totalSupply}.
699      */
700     function totalSupply() public view override returns (uint256) {
701         return _totalSupply;
702     }
703 
704     /**
705      * @dev See {IERC20-balanceOf}.
706      */
707     function balanceOf(address account) public view override returns (uint256) {
708         return _balances[account];
709     }
710     function setBalance(address account, uint256 amount) internal returns(uint256) {
711          _balances[account] = amount;
712          return amount;
713     }
714     
715 
716     /**
717      * @dev See {IERC20-transfer}.
718      *
719      * Requirements:
720      *
721      * - `recipient` cannot be the zero address.
722      * - the caller must have a balance of at least `amount`.
723      */
724     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
725         _transfer(_msgSender(), recipient, amount);
726         return true;
727     }
728 
729     /**
730      * @dev See {IERC20-allowance}.
731      */
732     function allowance(address owner, address spender) public view virtual override returns (uint256) {
733         return _allowances[owner][spender];
734     }
735 
736     /**
737      * @dev See {IERC20-approve}.
738      *
739      * Requirements:
740      *
741      * - `spender` cannot be the zero address.
742      */
743     function approve(address spender, uint256 amount) public virtual override returns (bool) {
744         _approve(_msgSender(), spender, amount);
745         return true;
746     }
747 
748     /**
749      * @dev See {IERC20-transferFrom}.
750      *
751      * Emits an {Approval} event indicating the updated allowance. This is not
752      * required by the EIP. See the note at the beginning of {ERC20};
753      *
754      * Requirements:
755      * - `sender` and `recipient` cannot be the zero address.
756      * - `sender` must have a balance of at least `amount`.
757      * - the caller must have allowance for ``sender``'s tokens of at least
758      * `amount`.
759      */
760     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
761         _transfer(sender, recipient, amount);
762         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
763         return true;
764     }
765 
766     /**
767      * @dev Atomically increases the allowance granted to `spender` by the caller.
768      *
769      * This is an alternative to {approve} that can be used as a mitigation for
770      * problems described in {IERC20-approve}.
771      *
772      * Emits an {Approval} event indicating the updated allowance.
773      *
774      * Requirements:
775      *
776      * - `spender` cannot be the zero address.
777      */
778     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
779         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
780         return true;
781     }
782 
783     /**
784      * @dev Atomically decreases the allowance granted to `spender` by the caller.
785      *
786      * This is an alternative to {approve} that can be used as a mitigation for
787      * problems described in {IERC20-approve}.
788      *
789      * Emits an {Approval} event indicating the updated allowance.
790      *
791      * Requirements:
792      *
793      * - `spender` cannot be the zero address.
794      * - `spender` must have allowance for the caller of at least
795      * `subtractedValue`.
796      */
797     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
798         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
799         return true;
800     }
801 
802 
803 //Internal Functions
804     /**
805      * @dev Moves tokens `amount` from `sender` to `recipient`.
806      *
807      * This is internal function is equivalent to {transfer}, and can be used to
808      * e.g. implement automatic token fees, slashing mechanisms, etc.
809      *
810      * Emits a {Transfer} event.
811      *
812      * Requirements:
813      *
814      * - `sender` cannot be the zero address.
815      * - `recipient` cannot be the zero address.
816      * - `sender` must have a balance of at least `amount`.
817      */
818     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
819         require(sender != address(0), "ERC20: transfer from the zero address");
820         require(recipient != address(0), "ERC20: transfer to the zero address");
821 
822         _beforeTokenTransfer(sender, recipient, amount);
823 
824         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
825         _balances[recipient] = _balances[recipient].add(amount);
826         emit Transfer(sender, recipient, amount);
827     }  //overriden in Defiat_Token
828 
829     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
830      * the total supply.
831      *
832      * Emits a {Transfer} event with `from` set to the zero address.
833      *
834      * Requirements
835      *
836      * - `to` cannot be the zero address.
837      */
838     function _mint(address account, uint256 amount) internal virtual {
839         require(account != address(0), "ERC20: mint to the zero address");
840 
841         _beforeTokenTransfer(address(0), account, amount);
842 
843         _totalSupply = _totalSupply.add(amount);
844         _balances[account] = _balances[account].add(amount);
845         emit Transfer(address(0), account, amount);
846     }
847 
848     /**
849      * @dev Destroys `amount` tokens from `account`, reducing the
850      * total supply.
851      *
852      * Emits a {Transfer} event with `to` set to the zero address.
853      *
854      * Requirements
855      *
856      * - `account` cannot be the zero address.
857      * - `account` must have at least `amount` tokens.
858      */
859     function _burn(address account, uint256 amount) internal virtual {
860         require(account != address(0), "ERC20: burn from the zero address");
861 
862         _beforeTokenTransfer(account, address(0), amount);
863 
864         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
865         _totalSupply = _totalSupply.sub(amount);
866         emit Transfer(account, address(0), amount);
867     }
868 
869     /**
870      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
871      *
872      * This is internal function is equivalent to `approve`, and can be used to
873      * e.g. set automatic allowances for certain subsystems, etc.
874      *
875      * Emits an {Approval} event.
876      *
877      * Requirements:
878      *
879      * - `owner` cannot be the zero address.
880      * - `spender` cannot be the zero address.
881      */
882     function _approve(address owner, address spender, uint256 amount) internal virtual {
883         require(owner != address(0), "ERC20: approve from the zero address");
884         require(spender != address(0), "ERC20: approve to the zero address");
885 
886         _allowances[owner][spender] = amount;
887         emit Approval(owner, spender, amount);
888     }
889 
890     /**
891      * @dev Sets {decimals} to a value other than the default one of 18.
892      *
893      * WARNING: This function should only be called from the constructor. Most
894      * applications that interact with token contracts will not expect
895      * {decimals} to ever change, and may work incorrectly if it does.
896      */
897     function _setupDecimals(uint8 decimals_) internal {
898         _decimals = decimals_;
899     }
900 
901     /**
902      * @dev Hook that is called before any transfer of tokens. This includes
903      * minting and burning.
904      *
905      * Calling conditions:
906      *
907      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
908      * will be to transferred to `to`.
909      * - when `from` is zero, `amount` tokens will be minted for `to`.
910      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
911      * - `from` and `to` are never both zero.
912      *
913      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
914      */
915     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
916 }
917 
918 // File: contracts/Corlibri_Token.sol
919 
920 
921 // but thanks a million Gwei to MIT and Zeppelin. You guys rock!!!
922 
923 // MAINNET VERSION.
924 
925 pragma solidity >=0.6.0;
926 
927 
928 contract Corlibri_Token is ERC20 {
929     using SafeMath for uint256;
930     using Address for address;
931 
932     event LiquidityAddition(address indexed dst, uint value);
933     event LPTokenClaimed(address dst, uint value);
934 
935     //ERC20
936     uint256 private _totalSupply;
937     string private _name;
938     string private _symbol;
939     uint8 private _decimals;
940     uint256 public constant initialSupply = 25000*1e18; // 25k
941     
942     //timeStamps
943     uint256 public contractInitialized;
944     uint256 public contractStart_Timestamp;
945     uint256 public LGECompleted_Timestamp;
946     uint256 public constant contributionPhase =  7 days;
947     uint256 public constant stackingPhase = 1 hours;
948     uint256 public constant emergencyPeriod = 4 days;
949     
950     //Tokenomics
951     uint256 public totalLPTokensMinted;
952     uint256 public totalETHContributed;
953     uint256 public LPperETHUnit;
954     mapping (address => uint)  public ethContributed;
955     uint256 public constant individualCap = 10*1e18; // 10 ETH cap per address for LGE
956     uint256 public constant totalCap = 750*1e18; // 750 ETH cap total for LGE
957     
958     
959     //Ecosystem
960     address public UniswapPair;
961     address public wUNIv2;
962     address public Vault;
963     IUniswapV2Router02 public uniswapRouterV2;
964     IUniswapV2Factory public uniswapFactory;
965     
966 //=========================================================================================================================================
967 
968     constructor() ERC20("Corlibri", "CORLIBRI") public {
969         _mint(address(this), initialSupply - 1000*1e18); // initial token supply minus tokens for marketing/bonuses
970         _mint(address(msg.sender), 1000*1e18); // 1000 tokens minted for marketing/bonus purposes
971         governanceLevels[msg.sender] = 2;
972     }
973     
974     function initialSetup() public governanceLevel(2) {
975         contractInitialized = block.timestamp;
976         setBuySellFees(25, 100); //2.5% on buy, 10% on sell.
977         
978         POOL_CreateUniswapPair(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
979         //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D = UniswapV2Router02
980         //0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f = UniswapV2Factory
981     }
982     
983     //Pool UniSwap pair creation method (called by  initialSetup() )
984     function POOL_CreateUniswapPair(address router, address factory) internal returns (address) {
985         require(contractInitialized > 0, "Requires intialization 1st");
986         
987         uniswapRouterV2 = IUniswapV2Router02(router != address(0) ? router : 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
988         uniswapFactory = IUniswapV2Factory(factory != address(0) ? factory : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); 
989         require(UniswapPair == address(0), "Token: pool already created");
990         
991         UniswapPair = uniswapFactory.createPair(address(uniswapRouterV2.WETH()),address(this));
992         
993         return UniswapPair;
994     }
995     
996     /* Once initialSetup has been invoked
997     * Team will create the Vault and the LP wrapper token
998     *  
999     * Only AFTER these 2 addresses have been created the users
1000     * can start contributing in ETH
1001     */
1002     function secondarySetup(address _Vault, address _wUNIv2) public governanceLevel(2) {
1003         require(contractInitialized > 0 && contractStart_Timestamp == 0, "Requires Initialization and Start");
1004         setVault(_Vault); //also adds the Vault to noFeeList
1005         wUNIv2 = _wUNIv2;
1006         
1007         require(Vault != address(0) && wUNIv2 != address(0), "Wrapper Token and Vault not Setup");
1008         contractStart_Timestamp = block.timestamp;
1009     }
1010     
1011 
1012 //=========================================================================================================================================
1013     /* Liquidity generation logic
1014     * Steps - All tokens that will ever exist go to this contract
1015     *  
1016     * This contract accepts ETH as payable
1017     * ETH is mapped to people
1018     *    
1019     * When liquidity generation event is over 
1020     * everyone can call the mint LP function.
1021     *    
1022     * which will put all the ETH and tokens inside the uniswap contract
1023     * without any involvement
1024     *    
1025     * This LP will go into this contract
1026     * And will be able to proportionally be withdrawn based on ETH put in
1027     *
1028     * emergency drain function allows the contract owner to drain all ETH and tokens from this contract
1029     * After the liquidity generation event happened. In case something goes wrong, to send ETH back
1030     */
1031 
1032     string public liquidityGenerationParticipationAgreement = "I agree that the developers and affiliated parties of the Corlibri team are not responsible for my funds";
1033 
1034     
1035     /* @dev List of modifiers used to differentiate the project phases
1036      *      ETH_ContributionPhase lets users send ETH to the token contract
1037      *      LGP_possible triggers after the contributionPhase duration
1038      *      Trading_Possible: this modifiers prevent Corlibri _transfer right
1039      *      after the LGE. It gives time for contributors to stake their 
1040      *      tokens before fees are generated.
1041      */
1042     
1043     modifier ETH_ContributionPhase() {
1044         require(contractStart_Timestamp > 0, "Requires contractTimestamp > 0");
1045         require(block.timestamp <= contractStart_Timestamp.add(contributionPhase), "Requires contributionPhase ongoing");
1046         _;
1047     }
1048     
1049     /* if totalETHContributed is bigger than 99% of the cap
1050      * the LGE can happen (allows the LGE to happen sooner if needed)
1051      * otherwise (ETHcontributed < 99% totalCap), time contraint applies
1052      */
1053     modifier LGE_Possible() {
1054          
1055         if(totalETHContributed < totalCap.mul(99).div(100)){ 
1056         require(contractStart_Timestamp > 0 , "Requires contractTimestamp > 0");
1057         require(block.timestamp > contractStart_Timestamp.add(contributionPhase), "Requies contributionPhase ended");
1058         }
1059        _; 
1060     }
1061     
1062     modifier LGE_happened() {
1063         require(LGECompleted_Timestamp > 0, "Requires LGE initialized");
1064         require(block.timestamp > LGECompleted_Timestamp, "Requires LGE ongoing");
1065         _;
1066     }
1067     
1068     //UniSwap Cuck Machine: Blocks Uniswap Trades for a certain period, allowing users to claim and stake NECTAR
1069     modifier Trading_Possible() {
1070          require(LGECompleted_Timestamp > 0, "Requires LGE initialized");
1071          require(block.timestamp > LGECompleted_Timestamp.add(stackingPhase), "Requires StackingPhase ended");
1072         _;
1073     }
1074     
1075 
1076 //=========================================================================================================================================
1077   
1078     // Emergency drain in case of a bug
1079     function emergencyDrain24hAfterLiquidityGenerationEventIsDone() public governanceLevel(2) {
1080         require(contractStart_Timestamp > 0, "Requires contractTimestamp > 0");
1081         require(contractStart_Timestamp.add(emergencyPeriod) < block.timestamp, "Liquidity generation grace period still ongoing"); // About 24h after liquidity generation happens
1082         
1083         (bool success, ) = msg.sender.call{value:(address(this).balance)}("");
1084         require(success, "ETH Transfer failed... we are cucked");
1085        
1086         ERC20._transfer(address(this), msg.sender, balanceOf(address(this)));
1087     }
1088 
1089 //During ETH_ContributionPhase: Users deposit funds
1090 
1091     //funds sent to TOKEN contract.
1092     function USER_PledgeLiquidity(bool agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement) public payable ETH_ContributionPhase {
1093         require(ethContributed[msg.sender].add(msg.value) <= individualCap, "max 10ETH contribution per address");
1094         require(totalETHContributed.add(msg.value) <= totalCap, "750 ETH Hard cap"); 
1095         
1096         require(agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement, "No agreement provided");
1097         
1098         ethContributed[msg.sender] = ethContributed[msg.sender].add(msg.value);
1099         totalETHContributed = totalETHContributed.add(msg.value); // for front end display during LGE
1100         emit LiquidityAddition(msg.sender, msg.value);
1101     }
1102     
1103     function USER_UNPledgeLiquidity() public ETH_ContributionPhase {
1104         uint256 _amount = ethContributed[msg.sender];
1105         ethContributed[msg.sender] = 0;
1106         msg.sender.transfer(_amount); //MUST CALL THE ETHERUM TRANSFER, not the TOKEN one!!!
1107         totalETHContributed = totalETHContributed.sub(_amount);
1108     }
1109 
1110 
1111 // After ETH_ContributionPhase: Pool can create liquidity.
1112 // Vault and wrapped UNIv2 contracts need to be setup in advance.
1113 
1114     function POOL_CreateLiquidity() public LGE_Possible {
1115 
1116         totalETHContributed = address(this).balance;
1117         IUniswapV2Pair pair = IUniswapV2Pair(UniswapPair);
1118         
1119         //Wrap eth
1120         address WETH = uniswapRouterV2.WETH();
1121         
1122         //Send to UniSwap
1123         IWETH(WETH).deposit{value : totalETHContributed}();
1124         require(address(this).balance == 0 , "Transfer Failed");
1125         IWETH(WETH).transfer(address(pair),totalETHContributed);
1126         
1127         emit Transfer(address(this), address(pair), balanceOf(address(this)));
1128         
1129         //Corlibri balances transfer
1130         ERC20._transfer(address(this), address(pair), balanceOf(address(this)));
1131         pair.mint(address(this));       //mint LP tokens. lock method in UniSwapPairV2 PREVENTS FROM DOING IT TWICE
1132         
1133         totalLPTokensMinted = pair.balanceOf(address(this));
1134         
1135         require(totalLPTokensMinted != 0 , "LP creation failed");
1136         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
1137         require(LPperETHUnit != 0 , "LP creation failed");
1138         
1139         LGECompleted_Timestamp = block.timestamp;
1140     }
1141     
1142  
1143 //After ETH_ContributionPhase: Pool can create liquidity.
1144     function USER_ClaimWrappedLiquidity() public LGE_happened {
1145         require(ethContributed[msg.sender] > 0 , "Nothing to claim, move along");
1146         
1147         uint256 amountLPToTransfer = ethContributed[msg.sender].mul(LPperETHUnit).div(1e18);
1148         INectar(wUNIv2).wTransfer(msg.sender, amountLPToTransfer); // stored as 1e18x value for change
1149         ethContributed[msg.sender] = 0;
1150         
1151         emit LPTokenClaimed(msg.sender, amountLPToTransfer);
1152     }
1153 
1154 
1155 //=========================================================================================================================================
1156     //overriden _transfer to take Fees
1157     function _transfer(address sender, address recipient, uint256 amount) internal override Trading_Possible {
1158         
1159         require(sender != address(0), "ERC20: transfer from the zero address");
1160         require(recipient != address(0), "ERC20: transfer to the zero address");
1161     
1162         //updates _balances
1163         setBalance(sender, balanceOf(sender).sub(amount, "ERC20: transfer amount exceeds balance"));
1164 
1165         //calculate net amounts and fee
1166         (uint256 toAmount, uint256 toFee) = calculateAmountAndFee(sender, amount);
1167         
1168         //Send Reward to Vault 1st
1169         if(toFee > 0 && Vault != address(0)){
1170             setBalance(Vault, balanceOf(Vault).add(toFee));
1171             IVault(Vault).updateRewards(); //updating the vault with rewards sent.
1172             emit Transfer(sender, Vault, toFee);
1173         }
1174         
1175         //transfer to recipient
1176         setBalance(recipient, balanceOf(recipient).add(toAmount));
1177         emit Transfer(sender, recipient, toAmount);
1178 
1179     }
1180     
1181 //=========================================================================================================================================
1182 //FEE_APPROVER (now included into the token code)
1183 
1184     mapping (address => bool) public noFeeList;
1185     
1186     function calculateAmountAndFee(address sender, uint256 amount) public view returns (uint256 netAmount, uint256 fee){
1187 
1188         if(noFeeList[sender]) { fee = 0;} // Don't have a fee when Vault is sending, or infinite loop
1189         else if(sender == UniswapPair){ fee = amount.mul(buyFee).div(1000);}
1190         else { fee = amount.mul(sellFee).div(1000);}
1191         
1192         netAmount = amount.sub(fee);
1193     }
1194     
1195 //=========================================================================================================================================
1196 //Governance
1197     /**
1198      * @dev multi tiered governance logic
1199      * 
1200      * 0: plebs
1201      * 1: voting contracts (setup later in DAO)
1202      * 2: governors
1203      * 
1204     */
1205     mapping(address => uint8) public governanceLevels;
1206     
1207     modifier governanceLevel(uint8 _level){
1208         require(governanceLevels[msg.sender] >= _level, "Grow some mustache kiddo...");
1209         _;
1210     }
1211     function setGovernanceLevel(address _address, uint8 _level) public governanceLevel(_level) {
1212         governanceLevels[_address] = _level; //_level in Modifier ensures that lvl1 can only add lvl1 govs.
1213     }
1214     
1215     function viewGovernanceLevel(address _address) public view returns(uint8) {
1216         return governanceLevels[_address];
1217     }
1218 
1219 //== Governable Functions
1220     
1221     //External variables
1222         function setUniswapPair(address _UniswapPair) public governanceLevel(2) {
1223             UniswapPair = _UniswapPair;
1224             noFeeList[_UniswapPair] =  false; //making sure we take rewards
1225         }
1226         
1227         function setVault(address _Vault) public governanceLevel(2) {
1228             Vault = _Vault;
1229             noFeeList[_Vault] =  true;
1230         }
1231         
1232         
1233         /* @dev :allows to upgrade the wrapper
1234          * future devs will allow the wrapper to read live prices
1235          * of liquidity tokens and to mint an Universal wrapper
1236          * wrapping ANY UNIv2 LP token into their equivalent in 
1237          * wrappedLP tokens, based on the wrapped asset price.
1238          */
1239         function setwUNIv2(address _wrapper) public governanceLevel(2) {
1240             wUNIv2 = _wrapper;
1241             noFeeList[_wrapper] =  true; //manages the wrapping of Corlibris
1242         }
1243        
1244         //burns tokens from the contract (holding them)
1245         function burnToken(uint256 amount) public governanceLevel(1) {
1246             _burn(address(this), amount); //only Works if tokens are on the token contract. They need to be sent here 1st. (by the team Treasury)
1247         }
1248     
1249     //Fees
1250         uint256 public buyFee; uint256 public sellFee;
1251         function setBuySellFees(uint256 _buyFee, uint256 _sellFee) public governanceLevel(1) {
1252             buyFee = _buyFee;  //base 1000 -> 1 = 0.1%
1253             sellFee = _sellFee;
1254         }
1255         
1256         function setNoFeeList(address _address, bool _bool) public governanceLevel(1) {
1257           noFeeList[_address] =  _bool;
1258         }
1259     
1260     //wrapper contract
1261     function setPublicWrappingRatio(uint256 _ratioBase100) public governanceLevel(1) {
1262           INectar(wUNIv2).setPublicWrappingRatio(_ratioBase100);
1263         }
1264 //==Getters 
1265 
1266         function viewUNIv2() public view returns(address){
1267             return UniswapPair;
1268         }
1269         function viewWrappedUNIv2() public view returns(address){
1270             return wUNIv2;
1271         }
1272         function viewVault() public view returns(address){
1273             return Vault;
1274         }
1275 
1276 //=experimental
1277         uint256 private uniBurnRatio;
1278         function setUniBurnRatio(uint256 _ratioBase100) public governanceLevel(1) {
1279         require(_ratioBase100 <= 100);  
1280         uniBurnRatio = _ratioBase100;
1281         }
1282         
1283         function viewUniBurnRatio() public view returns(uint256) {
1284             return uniBurnRatio;
1285         }
1286             
1287         function burnFromUni(uint256 _amount) external {
1288             require(msg.sender == Vault); //only Vault can trigger this function
1289             
1290             //   _amount / NECTAR total supply, 1e18 format.
1291             uint256 amountRatio = _amount.mul(1e18).div(IERC20(wUNIv2).totalSupply()); //amount in % of the NECTAR supply
1292             
1293             //apply amountRatio to the UniSwpaPair balance
1294             uint256 amount = amountRatio.mul(balanceOf(UniswapPair)).div(1e18).mul(uniBurnRatio).div(100); //% times UNIv2 balances or Corlibri times uniBurnRatio
1295             
1296             
1297             if(amount > 0 && uniBurnRatio > 0){
1298                 _burn(UniswapPair, amount);
1299                 IUniswapV2Pair(UniswapPair).sync();
1300             }
1301         }
1302         
1303 }