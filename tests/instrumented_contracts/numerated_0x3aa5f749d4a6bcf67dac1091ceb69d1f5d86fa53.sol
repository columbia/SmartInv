1 /*
2                                       .-.
3                                      ()I()
4                                 "==.__:-:__.=="
5                                "==.__/~|~\__.=="
6                                "==._(  Y  )_.=="
7                     .-'~~""~=--...,__\/|\/__,...--=~""~~'-.
8                    (               ..=\=/=..               )
9                     `'-.        ,.-"`;/=\ ;"-.,_        .-'`
10                         `~"-=-~` .-~` |=| `~-. `~-=-"~`
11                              .-~`    /|=|\    `~-.
12                           .~`       / |=| \       `~.
13                       .-~`        .'  |=|  `.        `~-.
14                     (`     _,.-="`    |=|    `"=-.,_     `)
15                      `~"~"`           |=|           `"~"~`
16                                       |=|
17                                       |=|
18                                       |=|
19                                       /=\
20                                       \=/
21                                        ^
22 
23        dragonflyprotocol code is henceforth copyrighted by Deflect Protocol
24                      ©,®,™ and ALL RIGHTS RESERVED RIGHTFULLY
25 */
26 
27 pragma solidity ^0.6.2;
28 
29 // File @openzeppelin/contracts/GSN/Context.sol
30 
31 /*
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with GSN meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address payable) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes memory) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51 
52 
53 // File @openzeppelin/contracts/token/ERC20/IERC20.sol
54 
55 
56 pragma solidity ^0.6.0;
57 
58 /**
59  * @dev Interface of the ERC20 standard as defined in the EIP.
60  */
61 interface IERC20 {
62     /**
63      * @dev Returns the amount of tokens in existence.
64      */
65     function totalSupply() external view returns (uint256);
66 
67     /**
68      * @dev Returns the amount of tokens owned by `account`.
69      */
70     function balanceOf(address account) external view returns (uint256);
71 
72     /**
73      * @dev Moves `amount` tokens from the caller's account to `recipient`.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transfer(address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Returns the remaining number of tokens that `spender` will be
83      * allowed to spend on behalf of `owner` through {transferFrom}. This is
84      * zero by default.
85      *
86      * This value changes when {approve} or {transferFrom} are called.
87      */
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     /**
91      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * IMPORTANT: Beware that changing an allowance with this method brings the risk
96      * that someone may use both the old and the new allowance by unfortunate
97      * transaction ordering. One possible solution to mitigate this race
98      * condition is to first reduce the spender's allowance to 0 and set the
99      * desired value afterwards:
100      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101      *
102      * Emits an {Approval} event.
103      */
104     function approve(address spender, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Moves `amount` tokens from `sender` to `recipient` using the
108      * allowance mechanism. `amount` is then deducted from the caller's
109      * allowance.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 // File @openzeppelin/contracts/math/SafeMath.sol
134 
135 
136 pragma solidity ^0.6.0;
137 
138 /**
139  * @dev Wrappers over Solidity's arithmetic operations with added overflow
140  * checks.
141  *
142  * Arithmetic operations in Solidity wrap on overflow. This can easily result
143  * in bugs, because programmers usually assume that an overflow raises an
144  * error, which is the standard behavior in high level programming languages.
145  * `SafeMath` restores this intuition by reverting the transaction when an
146  * operation overflows.
147  *
148  * Using this library instead of the unchecked operations eliminates an entire
149  * class of bugs, so it's recommended to use it always.
150  */
151 library SafeMath {
152     /**
153      * @dev Returns the addition of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `+` operator.
157      *
158      * Requirements:
159      *
160      * - Addition cannot overflow.
161      */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         uint256 c = a + b;
164         require(c >= a, "SafeMath: addition overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         return sub(a, b, "SafeMath: subtraction overflow");
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
185      * overflow (when the result is negative).
186      *
187      * Counterpart to Solidity's `-` operator.
188      *
189      * Requirements:
190      *
191      * - Subtraction cannot overflow.
192      */
193     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b <= a, errorMessage);
195         uint256 c = a - b;
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the multiplication of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `*` operator.
205      *
206      * Requirements:
207      *
208      * - Multiplication cannot overflow.
209      */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212         // benefit is lost if 'b' is also tested.
213         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
214         if (a == 0) {
215             return 0;
216         }
217 
218         uint256 c = a * b;
219         require(c / a == b, "SafeMath: multiplication overflow");
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         return div(a, b, "SafeMath: division by zero");
238     }
239 
240     /**
241      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
242      * division by zero. The result is rounded towards zero.
243      *
244      * Counterpart to Solidity's `/` operator. Note: this function uses a
245      * `revert` opcode (which leaves remaining gas untouched) while Solidity
246      * uses an invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b > 0, errorMessage);
254         uint256 c = a / b;
255         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
273         return mod(a, b, "SafeMath: modulo by zero");
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * Reverts with custom message when dividing by zero.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         require(b != 0, errorMessage);
290         return a % b;
291     }
292 }
293 
294 
295 // File @openzeppelin/contracts/utils/Address.sol
296 
297 
298 pragma solidity ^0.6.2;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies in extcodesize, which returns 0 for contracts in
323         // construction, since the code is only stored at the end of the
324         // constructor execution.
325 
326         uint256 size;
327         // solhint-disable-next-line no-inline-assembly
328         assembly { size := extcodesize(account) }
329         return size > 0;
330     }
331 
332     /**
333      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
334      * `recipient`, forwarding all available gas and reverting on errors.
335      *
336      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
337      * of certain opcodes, possibly making contracts go over the 2300 gas limit
338      * imposed by `transfer`, making them unable to receive funds via
339      * `transfer`. {sendValue} removes this limitation.
340      *
341      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
342      *
343      * IMPORTANT: because control is transferred to `recipient`, care must be
344      * taken to not create reentrancy vulnerabilities. Consider using
345      * {ReentrancyGuard} or the
346      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
347      */
348     function sendValue(address payable recipient, uint256 amount) internal {
349         require(address(this).balance >= amount, "Address: insufficient balance");
350 
351         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
352         (bool success, ) = recipient.call{ value: amount }("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain`call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375       return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
385         return _functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
405      * with `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
410         require(address(this).balance >= value, "Address: insufficient balance for call");
411         return _functionCallWithValue(target, data, value, errorMessage);
412     }
413 
414     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
415         require(isContract(target), "Address: call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 // solhint-disable-next-line no-inline-assembly
427                 assembly {
428                     let returndata_size := mload(returndata)
429                     revert(add(32, returndata), returndata_size)
430                 }
431             } else {
432                 revert(errorMessage);
433             }
434         }
435     }
436 }
437 
438 
439 // File @openzeppelin/contracts/access/Ownable.sol
440 
441 
442 pragma solidity ^0.6.0;
443 
444 /**
445  * @dev Contract module which provides a basic access control mechanism, where
446  * there is an account (an owner) that can be granted exclusive access to
447  * specific functions.
448  *
449  * By default, the owner account will be the one that deploys the contract. This
450  * can later be changed with {transferOwnership}.
451  *
452  * This module is used through inheritance. It will make available the modifier
453  * `onlyOwner`, which can be applied to your functions to restrict their use to
454  * the owner.
455  */
456 contract Ownable is Context {
457     address private _owner;
458 
459     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
460 
461     /**
462      * @dev Initializes the contract setting the deployer as the initial owner.
463      */
464     constructor () internal {
465         address msgSender = _msgSender();
466         _owner = msgSender;
467         emit OwnershipTransferred(address(0), msgSender);
468     }
469 
470     /**
471      * @dev Returns the address of the current owner.
472      */
473     function owner() public view returns (address) {
474         return _owner;
475     }
476 
477     /**
478      * @dev Throws if called by any account other than the owner.
479      */
480     modifier onlyOwner() {
481         require(_owner == _msgSender(), "Ownable: caller is not the owner");
482         _;
483     }
484 
485     /**
486      * @dev Leaves the contract without owner. It will not be possible to call
487      * `onlyOwner` functions anymore. Can only be called by the current owner.
488      *
489      * NOTE: Renouncing ownership will leave the contract without an owner,
490      * thereby removing any functionality that is only available to the owner.
491      */
492     function renounceOwnership() public virtual onlyOwner {
493         emit OwnershipTransferred(_owner, address(0));
494         _owner = address(0);
495     }
496 
497     /**
498      * @dev Transfers ownership of the contract to a new account (`newOwner`).
499      * Can only be called by the current owner.
500      */
501     function transferOwnership(address newOwner) public virtual onlyOwner {
502         require(newOwner != address(0), "Ownable: new owner is the zero address");
503         emit OwnershipTransferred(_owner, newOwner);
504         _owner = newOwner;
505     }
506 }
507 
508 
509 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1
510 
511 pragma solidity >=0.5.0;
512 
513 interface IUniswapV2Pair {
514     event Approval(address indexed owner, address indexed spender, uint value);
515     event Transfer(address indexed from, address indexed to, uint value);
516 
517     function name() external pure returns (string memory);
518     function symbol() external pure returns (string memory);
519     function decimals() external pure returns (uint8);
520     function totalSupply() external view returns (uint);
521     function balanceOf(address owner) external view returns (uint);
522     function allowance(address owner, address spender) external view returns (uint);
523 
524     function approve(address spender, uint value) external returns (bool);
525     function transfer(address to, uint value) external returns (bool);
526     function transferFrom(address from, address to, uint value) external returns (bool);
527 
528     function DOMAIN_SEPARATOR() external view returns (bytes32);
529     function PERMIT_TYPEHASH() external pure returns (bytes32);
530     function nonces(address owner) external view returns (uint);
531 
532     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
533 
534     event Mint(address indexed sender, uint amount0, uint amount1);
535     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
536     event Swap(
537         address indexed sender,
538         uint amount0In,
539         uint amount1In,
540         uint amount0Out,
541         uint amount1Out,
542         address indexed to
543     );
544     event Sync(uint112 reserve0, uint112 reserve1);
545 
546     function MINIMUM_LIQUIDITY() external pure returns (uint);
547     function factory() external view returns (address);
548     function token0() external view returns (address);
549     function token1() external view returns (address);
550     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
551     function price0CumulativeLast() external view returns (uint);
552     function price1CumulativeLast() external view returns (uint);
553     function kLast() external view returns (uint);
554 
555     function mint(address to) external returns (uint liquidity);
556     function burn(address to) external returns (uint amount0, uint amount1);
557     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
558     function skim(address to) external;
559     function sync() external;
560 
561     function initialize(address, address) external;
562 }
563 
564 
565 // File contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
566 
567 pragma solidity >=0.5.0;
568 
569 interface IUniswapV2Factory {
570     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
571 
572     function feeTo() external view returns (address);
573     function feeToSetter() external view returns (address);
574     function migrator() external view returns (address);
575 
576     function getPair(address tokenA, address tokenB) external view returns (address pair);
577     function allPairs(uint) external view returns (address pair);
578     function allPairsLength() external view returns (uint);
579 
580     function createPair(address tokenA, address tokenB) external returns (address pair);
581 
582     function setFeeTo(address) external;
583     function setFeeToSetter(address) external;
584     function setMigrator(address) external;
585 }
586 
587 
588 // File contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
589 
590 pragma solidity >=0.6.2;
591 
592 interface IUniswapV2Router01 {
593     function factory() external pure returns (address);
594     function WETH() external pure returns (address);
595 
596     function addLiquidity(
597         address tokenA,
598         address tokenB,
599         uint amountADesired,
600         uint amountBDesired,
601         uint amountAMin,
602         uint amountBMin,
603         address to,
604         uint deadline
605     ) external returns (uint amountA, uint amountB, uint liquidity);
606     function addLiquidityETH(
607         address token,
608         uint amountTokenDesired,
609         uint amountTokenMin,
610         uint amountETHMin,
611         address to,
612         uint deadline
613     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
614     function removeLiquidity(
615         address tokenA,
616         address tokenB,
617         uint liquidity,
618         uint amountAMin,
619         uint amountBMin,
620         address to,
621         uint deadline
622     ) external returns (uint amountA, uint amountB);
623     function removeLiquidityETH(
624         address token,
625         uint liquidity,
626         uint amountTokenMin,
627         uint amountETHMin,
628         address to,
629         uint deadline
630     ) external returns (uint amountToken, uint amountETH);
631     function removeLiquidityWithPermit(
632         address tokenA,
633         address tokenB,
634         uint liquidity,
635         uint amountAMin,
636         uint amountBMin,
637         address to,
638         uint deadline,
639         bool approveMax, uint8 v, bytes32 r, bytes32 s
640     ) external returns (uint amountA, uint amountB);
641     function removeLiquidityETHWithPermit(
642         address token,
643         uint liquidity,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline,
648         bool approveMax, uint8 v, bytes32 r, bytes32 s
649     ) external returns (uint amountToken, uint amountETH);
650     function swapExactTokensForTokens(
651         uint amountIn,
652         uint amountOutMin,
653         address[] calldata path,
654         address to,
655         uint deadline
656     ) external returns (uint[] memory amounts);
657     function swapTokensForExactTokens(
658         uint amountOut,
659         uint amountInMax,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external returns (uint[] memory amounts);
664     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
665         external
666         payable
667         returns (uint[] memory amounts);
668     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
669         external
670         returns (uint[] memory amounts);
671     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
672         external
673         returns (uint[] memory amounts);
674     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
675         external
676         payable
677         returns (uint[] memory amounts);
678 
679     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
680     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
681     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
682     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
683     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
684 }
685 
686 
687 // File contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
688 
689 pragma solidity >=0.6.2;
690 
691 interface IUniswapV2Router02 is IUniswapV2Router01 {
692     function removeLiquidityETHSupportingFeeOnTransferTokens(
693         address token,
694         uint liquidity,
695         uint amountTokenMin,
696         uint amountETHMin,
697         address to,
698         uint deadline
699     ) external returns (uint amountETH);
700     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
701         address token,
702         uint liquidity,
703         uint amountTokenMin,
704         uint amountETHMin,
705         address to,
706         uint deadline,
707         bool approveMax, uint8 v, bytes32 r, bytes32 s
708     ) external returns (uint amountETH);
709 
710     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
711         uint amountIn,
712         uint amountOutMin,
713         address[] calldata path,
714         address to,
715         uint deadline
716     ) external;
717     function swapExactETHForTokensSupportingFeeOnTransferTokens(
718         uint amountOutMin,
719         address[] calldata path,
720         address to,
721         uint deadline
722     ) external payable;
723     function swapExactTokensForETHSupportingFeeOnTransferTokens(
724         uint amountIn,
725         uint amountOutMin,
726         address[] calldata path,
727         address to,
728         uint deadline
729     ) external;
730 }
731 
732 // File contracts/uniswapv2/interfaces/IWETH.sol
733 
734 pragma solidity >=0.5.0;
735 
736 interface IWETH {
737     function deposit() external payable;
738     function transfer(address to, uint value) external returns (bool);
739     function withdraw(uint) external;
740 }
741 
742 
743 contract DeflectProtocol is Context, IERC20, Ownable {
744     using SafeMath for uint256;
745     using Address for address;
746 
747     mapping (address => uint256) private _rOwned;
748     mapping (address => uint256) private _tOwned;
749     mapping (address => mapping (address => uint256)) private _allowances;
750 
751     mapping (address => bool) private _isExcluded;
752     address[] private _excluded;
753 
754     uint256 private constant MAX = ~uint256(0);
755     uint256 private _tTotal = 5 * 10**5 * 10**9;
756     uint256 private _rTotal = (MAX - (MAX % _tTotal));
757     uint256 private _tFeeTotal;
758     uint256 private _tBurnTotal;
759     uint256 public lastTotalSupplyOfLPTokens;
760 
761     string private _name = 'Deflect Protocol';
762     string private _symbol = 'DEFLCT';
763     uint8 private _decimals = 9;
764 
765     uint256 private _taxFee = 175;
766     uint256 private _burnFee = 75;
767     uint256 private _devFee = 25;
768 
769     // Liquidity Generation Event
770     IUniswapV2Factory public uniswapFactory;
771     IUniswapV2Router02 public uniswapRouterV2;
772     address public tokenUniswapPair;
773 
774     mapping (address => uint)  public ethContributedForLPTokens;
775     uint256 public LPperETHUnit;
776     uint256 public totalETHContributed;
777     uint256 public totalLPTokensMinted;
778 
779     bool public paused;
780     bool public LPGenerationCompleted;
781     uint256 public lgeEndTime;
782     uint256 public lpUnlockTime;
783 
784     // Token Claim
785     mapping (address => uint)  public ethContributedForTokens;
786     uint256 public TokenPerETHUnit;
787     uint256 public bonusTokens = 50000 * 10**9;
788 
789     address public devAddr;
790 
791     event LiquidityAddition(address indexed dst, uint value);
792     event LPTokenClaimed(address dst, uint value);
793     event TokenClaimed(address dst, uint value);
794 
795     constructor () public {
796         _rOwned[_msgSender()] = _rTotal.div(100).mul(30); // pools and treasury
797         _rOwned[address(this)] = _rTotal.sub(_rOwned[_msgSender()]);
798 
799         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
800         address factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
801 
802         uniswapRouterV2 = IUniswapV2Router02(router);
803         uniswapFactory = IUniswapV2Factory(factory);
804 
805         lgeEndTime = now.add(24 hours);
806         lpUnlockTime = now.add(25 hours);
807 
808         devAddr = _msgSender();
809         paused = false;
810 
811         emit Transfer(address(0), _msgSender(), _tTotal);
812     }
813 
814     function name() public view returns (string memory) {
815         return _name;
816     }
817 
818     function symbol() public view returns (string memory) {
819         return _symbol;
820     }
821 
822     function decimals() public view returns (uint8) {
823         return _decimals;
824     }
825 
826     function totalSupply() public view override returns (uint256) {
827         return _tTotal;
828     }
829 
830     function balanceOf(address account) public view override returns (uint256) {
831         if (_isExcluded[account]) return _tOwned[account];
832         return tokenFromReflection(_rOwned[account]);
833     }
834 
835     function transfer(address recipient, uint256 amount) public override returns (bool) {
836         _transfer(_msgSender(), recipient, amount);
837         return true;
838     }
839 
840     function allowance(address owner, address spender) public view override returns (uint256) {
841         return _allowances[owner][spender];
842     }
843 
844     function approve(address spender, uint256 amount) public override returns (bool) {
845         _approve(_msgSender(), spender, amount);
846         return true;
847     }
848 
849     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
850         _transfer(sender, recipient, amount);
851         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
852         return true;
853     }
854 
855     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
856         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
857         return true;
858     }
859 
860     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
861         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
862         return true;
863     }
864 
865     function isExcluded(address account) public view returns (bool) {
866         return _isExcluded[account];
867     }
868 
869     function totalFees() public view returns (uint256) {
870         return _tFeeTotal;
871     }
872 
873     function totalBurn() public view returns (uint256) {
874         return _tBurnTotal;
875     }
876 
877     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
878         require(tAmount <= _tTotal, "Amount must be less than supply");
879         if (!deductTransferFee) {
880             (uint256 rAmount,,,,,) = _getValues(tAmount);
881             return rAmount;
882         } else {
883             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
884             return rTransferAmount;
885         }
886     }
887 
888     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
889         require(rAmount <= _rTotal, "Amount must be less than total reflections");
890         uint256 currentRate =  _getRate();
891         return rAmount.div(currentRate);
892     }
893 
894     function excludeAccount(address account) external onlyOwner() {
895         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
896         require(!_isExcluded[account], "Account is already excluded");
897         if(_rOwned[account] > 0) {
898             _tOwned[account] = tokenFromReflection(_rOwned[account]);
899         }
900         _isExcluded[account] = true;
901         _excluded.push(account);
902     }
903 
904     function includeAccount(address account) external onlyOwner() {
905         require(_isExcluded[account], "Account is already excluded");
906         for (uint256 i = 0; i < _excluded.length; i++) {
907             if (_excluded[i] == account) {
908                 _excluded[i] = _excluded[_excluded.length - 1];
909                 _tOwned[account] = 0;
910                 _isExcluded[account] = false;
911                 _excluded.pop();
912                 break;
913             }
914         }
915     }
916 
917     function _approve(address owner, address spender, uint256 amount) private {
918         require(owner != address(0), "ERC20: approve from the zero address");
919         require(spender != address(0), "ERC20: approve to the zero address");
920 
921         _allowances[owner][spender] = amount;
922         emit Approval(owner, spender, amount);
923     }
924 
925     function _transfer(address sender, address recipient, uint256 amount) private {
926         require(sender != address(0), "ERC20: transfer from the zero address");
927         require(recipient != address(0), "ERC20: transfer to the zero address");
928         require(amount > 0, "Transfer amount must be greater than zero");
929 
930         if(sender != address(this)) {
931             require(paused == false, "Transfers are paused");
932         }
933 
934         uint256 _LPSupplyOfPairTotal = IERC20(tokenUniswapPair).totalSupply();
935 
936         if(sender == tokenUniswapPair) {
937             require(lastTotalSupplyOfLPTokens <= _LPSupplyOfPairTotal, "Liquidity withdrawals forbidden");
938         }
939 
940         if (_isExcluded[sender] && !_isExcluded[recipient]) {
941             _transferFromExcluded(sender, recipient, amount);
942         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
943             _transferToExcluded(sender, recipient, amount);
944         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
945             _transferStandard(sender, recipient, amount);
946         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
947             _transferBothExcluded(sender, recipient, amount);
948         } else {
949             _transferStandard(sender, recipient, amount);
950         }
951 
952          lastTotalSupplyOfLPTokens = _LPSupplyOfPairTotal;
953     }
954 
955     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
956         uint256 currentRate =  _getRate();
957         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
958         uint256 rBurn =  tBurn.mul(currentRate);
959         _rOwned[sender] = _rOwned[sender].sub(rAmount);
960         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
961         _reflectFee(rFee, rBurn, tFee, tBurn);
962         emit Transfer(sender, recipient, tTransferAmount);
963     }
964 
965     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
966         uint256 currentRate =  _getRate();
967         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
968         uint256 rBurn =  tBurn.mul(currentRate);
969         _rOwned[sender] = _rOwned[sender].sub(rAmount);
970         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
971         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
972         _reflectFee(rFee, rBurn, tFee, tBurn);
973         emit Transfer(sender, recipient, tTransferAmount);
974     }
975 
976     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
977         uint256 currentRate =  _getRate();
978         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
979         uint256 rBurn =  tBurn.mul(currentRate);
980         _tOwned[sender] = _tOwned[sender].sub(tAmount);
981         _rOwned[sender] = _rOwned[sender].sub(rAmount);
982         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
983         _reflectFee(rFee, rBurn, tFee, tBurn);
984         emit Transfer(sender, recipient, tTransferAmount);
985     }
986 
987     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
988         uint256 currentRate =  _getRate();
989         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
990         uint256 rBurn =  tBurn.mul(currentRate);
991         _tOwned[sender] = _tOwned[sender].sub(tAmount);
992         _rOwned[sender] = _rOwned[sender].sub(rAmount);
993         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
994         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
995         _reflectFee(rFee, rBurn, tFee, tBurn);
996         emit Transfer(sender, recipient, tTransferAmount);
997     }
998 
999     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
1000         uint256 rDev = rFee.mul(_devFee).div(_taxFee);
1001         uint256 tDev = tFee.mul(_devFee).div(_taxFee);
1002         _rOwned[devAddr] = _rOwned[devAddr].add(rDev);
1003         _rTotal = _rTotal.sub(rFee).sub(rBurn).add(rDev);
1004         _tFeeTotal = _tFeeTotal.add(tFee).sub(tDev);
1005         _tBurnTotal = _tBurnTotal.add(tBurn);
1006         _tTotal = _tTotal.sub(tBurn);
1007     }
1008 
1009     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1010         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
1011         uint256 currentRate =  _getRate();
1012         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
1013         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
1014     }
1015 
1016     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
1017         uint256 tFee = tAmount.mul(taxFee).div(10000);
1018         uint256 tBurn = tAmount.mul(burnFee).div(10000);
1019         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
1020         return (tTransferAmount, tFee, tBurn);
1021     }
1022 
1023     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1024         uint256 rAmount = tAmount.mul(currentRate);
1025         uint256 rFee = tFee.mul(currentRate);
1026         uint256 rBurn = tBurn.mul(currentRate);
1027         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
1028         return (rAmount, rTransferAmount, rFee);
1029     }
1030 
1031     function _getRate() private view returns(uint256) {
1032         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1033         return rSupply.div(tSupply);
1034     }
1035 
1036     function _getCurrentSupply() private view returns(uint256, uint256) {
1037         uint256 rSupply = _rTotal;
1038         uint256 tSupply = _tTotal;
1039         for (uint256 i = 0; i < _excluded.length; i++) {
1040             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1041             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1042             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1043         }
1044         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1045         return (rSupply, tSupply);
1046     }
1047 
1048     function _getTaxFee() private view returns(uint256) {
1049         return _taxFee;
1050     }
1051 
1052     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1053         require(taxFee >= 100 && taxFee <= 1000, 'taxFee should be in 1% - 10%');
1054         _taxFee = taxFee;
1055     }
1056 
1057     function _getBurnFee() private view returns(uint256) {
1058         return _burnFee;
1059     }
1060 
1061     function _setBurnFee(uint256 burnFee) external onlyOwner() {
1062         require(burnFee < _taxFee, 'burnFee should be less than taxFee');
1063         _burnFee = burnFee;
1064     }
1065 
1066     function _getDevFee() private view returns(uint256) {
1067         return _devFee;
1068     }
1069 
1070     function _setDevFee(uint256 devFee) external onlyOwner() {
1071         require(devFee < _taxFee, 'devFee should be less than taxFee');
1072         _devFee = devFee;
1073     }
1074 
1075     // Pausing transfers of the token
1076     function setPaused(bool _pause) public onlyOwner {
1077         paused = _pause;
1078     }
1079 
1080     // Liquidity Generation Event
1081     function createUniswapPair() public returns (address) {
1082         require(tokenUniswapPair == address(0), "Token: pool already created");
1083         tokenUniswapPair = uniswapFactory.createPair(
1084             address(uniswapRouterV2.WETH()),
1085             address(this)
1086         );
1087         return tokenUniswapPair;
1088     }
1089 
1090     function addLiquidity() public payable {
1091         require(now < lgeEndTime, "Liquidity Generation Event over");
1092         ethContributedForLPTokens[msg.sender] += msg.value; // Overflow protection from safemath is not neded here
1093         ethContributedForTokens[msg.sender] = ethContributedForLPTokens[msg.sender];
1094         totalETHContributed = totalETHContributed.add(msg.value); // for front end display during LGE. This resets with definietly correct balance while calling pair.
1095         emit LiquidityAddition(msg.sender, msg.value);
1096     }
1097 
1098     function addLiquidityToUniswapPair() public {
1099         require(now >= lgeEndTime, "Liquidity generation ongoing");
1100         require(LPGenerationCompleted == false, "Liquidity generation already finished");
1101         if(_msgSender() != owner()) {
1102             require(now > (lgeEndTime + 2 hours), "Please wait for dev grace period");
1103         }
1104         uint256 initialTokenLiquidity = this.balanceOf(address(this)).sub(bonusTokens);
1105         totalETHContributed = address(this).balance;
1106         uint256 devETHFee = totalETHContributed.div(10);
1107         uint256 initialETHLiquidity = totalETHContributed.sub(devETHFee);
1108 
1109         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
1110         address WETH = uniswapRouterV2.WETH();
1111 
1112         IWETH(WETH).deposit{value : initialETHLiquidity}();
1113         (bool success, ) = devAddr.call{value:devETHFee}("");
1114         require(success, "Transfer failed.");
1115         require(address(this).balance == 0 , "Transfer Failed");
1116 
1117         IWETH(WETH).transfer(address(pair), initialETHLiquidity);
1118         this.transfer(address(pair), initialTokenLiquidity);
1119         pair.mint(address(this));
1120         totalLPTokensMinted = pair.balanceOf(address(this));
1121         require(totalLPTokensMinted != 0 , "LP creation failed");
1122 
1123         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
1124         require(LPperETHUnit != 0 , "LP creation failed");
1125 
1126         // Token Claim
1127         TokenPerETHUnit = bonusTokens.mul(1e18).div(totalETHContributed);
1128         require(TokenPerETHUnit != 0 , "Token calculation failed");
1129 
1130         LPGenerationCompleted = true;
1131     }
1132 
1133 
1134     function sync() public {
1135         uint256 _LPSupplyOfPairTotal = IERC20(tokenUniswapPair).totalSupply();
1136         lastTotalSupplyOfLPTokens = _LPSupplyOfPairTotal;
1137     }
1138 
1139     function claimLPTokens() public {
1140         require(now >= lpUnlockTime, "LP not unlocked yet");
1141         require(LPGenerationCompleted, "Event not over yet");
1142         require(ethContributedForLPTokens[msg.sender] > 0 , "Nothing to claim, move along");
1143         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
1144         uint256 amountLPToTransfer = ethContributedForLPTokens[msg.sender].mul(LPperETHUnit).div(1e18);
1145         pair.transfer(msg.sender, amountLPToTransfer); // stored as 1e18x value for change
1146         ethContributedForLPTokens[msg.sender] = 0;
1147         emit LPTokenClaimed(msg.sender, amountLPToTransfer);
1148     }
1149 
1150     function claimTokens() public {
1151         require(now >= lpUnlockTime, "LP not unlocked yet");
1152         require(LPGenerationCompleted, "Event not over yet");
1153         require(ethContributedForTokens[msg.sender] > 0 , "Nothing to claim, move along");
1154         uint256 amountTokenToTransfer = ethContributedForTokens[msg.sender].mul(TokenPerETHUnit).div(1e18);
1155         this.transfer(msg.sender, amountTokenToTransfer); // stored as 1e18x value for change
1156         ethContributedForTokens[msg.sender] = 0;
1157         emit TokenClaimed(msg.sender, amountTokenToTransfer);
1158     }
1159 
1160     function emergencyRecoveryIfLiquidityGenerationEventFails() public onlyOwner {
1161         require(lgeEndTime.add(1 days) < now, "Liquidity generation grace period still ongoing");
1162         (bool success, ) = msg.sender.call{value:address(this).balance}("");
1163         require(success, "Transfer failed.");
1164     }
1165 
1166     function setDev(address _devAddr) public {
1167         require(_msgSender() == devAddr, '!dev');
1168         devAddr = _devAddr;
1169     }
1170 }
