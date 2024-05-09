1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.2;
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
27         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
28         // for accounts without code, i.e. `keccak256('')`
29         bytes32 codehash;
30         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
31         // solhint-disable-next-line no-inline-assembly
32         assembly { codehash := extcodehash(account) }
33         return (codehash != accountHash && codehash != 0x0);
34     }
35 
36     /**
37      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
38      * `recipient`, forwarding all available gas and reverting on errors.
39      *
40      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
41      * of certain opcodes, possibly making contracts go over the 2300 gas limit
42      * imposed by `transfer`, making them unable to receive funds via
43      * `transfer`. {sendValue} removes this limitation.
44      *
45      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
46      *
47      * IMPORTANT: because control is transferred to `recipient`, care must be
48      * taken to not create reentrancy vulnerabilities. Consider using
49      * {ReentrancyGuard} or the
50      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
51      */
52     function sendValue(address payable recipient, uint256 amount) internal {
53         require(address(this).balance >= amount, "Address: insufficient balance");
54 
55         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
56         (bool success, ) = recipient.call{ value: amount }("");
57         require(success, "Address: unable to send value, recipient may have reverted");
58     }
59 
60     /**
61      * @dev Performs a Solidity function call using a low level `call`. A
62      * plain`call` is an unsafe replacement for a function call: use this
63      * function instead.
64      *
65      * If `target` reverts with a revert reason, it is bubbled up by this
66      * function (like regular Solidity function calls).
67      *
68      * Returns the raw returned data. To convert to the expected return value,
69      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
70      *
71      * Requirements:
72      *
73      * - `target` must be a contract.
74      * - calling `target` with `data` must not revert.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79       return functionCall(target, data, "Address: low-level call failed");
80     }
81 
82     /**
83      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
84      * `errorMessage` as a fallback revert reason when `target` reverts.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return _functionCallWithValue(target, data, 0, errorMessage);
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
94      * but also transferring `value` wei to `target`.
95      *
96      * Requirements:
97      *
98      * - the calling contract must have an ETH balance of at least `value`.
99      * - the called Solidity function must be `payable`.
100      *
101      * _Available since v3.1._
102      */
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
109      * with `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         return _functionCallWithValue(target, data, value, errorMessage);
116     }
117 
118     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
119         require(isContract(target), "Address: call to non-contract");
120 
121         // solhint-disable-next-line avoid-low-level-calls
122         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
123         if (success) {
124             return returndata;
125         } else {
126             // Look for revert reason and bubble it up if present
127             if (returndata.length > 0) {
128                 // The easiest way to bubble the revert reason is using memory via assembly
129 
130                 // solhint-disable-next-line no-inline-assembly
131                 assembly {
132                     let returndata_size := mload(returndata)
133                     revert(add(32, returndata), returndata_size)
134                 }
135             } else {
136                 revert(errorMessage);
137             }
138         }
139     }
140 }
141 
142 pragma solidity ^0.6.0;
143 
144 /*
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with GSN meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address payable) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes memory) {
160         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
161         return msg.data;
162     }
163 }
164 
165 pragma solidity ^0.6.0;
166 
167 /**
168  * @dev Interface of the ERC20 standard as defined in the EIP.
169  */
170 interface IERC20 {
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240 
241 pragma solidity ^0.6.0;
242 
243 /**
244  * @dev Wrappers over Solidity's arithmetic operations with added overflow
245  * checks.
246  *
247  * Arithmetic operations in Solidity wrap on overflow. This can easily result
248  * in bugs, because programmers usually assume that an overflow raises an
249  * error, which is the standard behavior in high level programming languages.
250  * `SafeMath` restores this intuition by reverting the transaction when an
251  * operation overflows.
252  *
253  * Using this library instead of the unchecked operations eliminates an entire
254  * class of bugs, so it's recommended to use it always.
255  */
256 library SafeMath {
257     /**
258      * @dev Returns the addition of two unsigned integers, reverting on
259      * overflow.
260      *
261      * Counterpart to Solidity's `+` operator.
262      *
263      * Requirements:
264      *
265      * - Addition cannot overflow.
266      */
267     function add(uint256 a, uint256 b) internal pure returns (uint256) {
268         uint256 c = a + b;
269         require(c >= a, "SafeMath: addition overflow");
270 
271         return c;
272     }
273 
274     /**
275      * @dev Returns the subtraction of two unsigned integers, reverting on
276      * overflow (when the result is negative).
277      *
278      * Counterpart to Solidity's `-` operator.
279      *
280      * Requirements:
281      *
282      * - Subtraction cannot overflow.
283      */
284     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
285         return sub(a, b, "SafeMath: subtraction overflow");
286     }
287 
288     /**
289      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
290      * overflow (when the result is negative).
291      *
292      * Counterpart to Solidity's `-` operator.
293      *
294      * Requirements:
295      *
296      * - Subtraction cannot overflow.
297      */
298     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b <= a, errorMessage);
300         uint256 c = a - b;
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the multiplication of two unsigned integers, reverting on
307      * overflow.
308      *
309      * Counterpart to Solidity's `*` operator.
310      *
311      * Requirements:
312      *
313      * - Multiplication cannot overflow.
314      */
315     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
316         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
317         // benefit is lost if 'b' is also tested.
318         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
319         if (a == 0) {
320             return 0;
321         }
322 
323         uint256 c = a * b;
324         require(c / a == b, "SafeMath: multiplication overflow");
325 
326         return c;
327     }
328 
329     /**
330      * @dev Returns the integer division of two unsigned integers. Reverts on
331      * division by zero. The result is rounded towards zero.
332      *
333      * Counterpart to Solidity's `/` operator. Note: this function uses a
334      * `revert` opcode (which leaves remaining gas untouched) while Solidity
335      * uses an invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      *
339      * - The divisor cannot be zero.
340      */
341     function div(uint256 a, uint256 b) internal pure returns (uint256) {
342         return div(a, b, "SafeMath: division by zero");
343     }
344 
345     /**
346      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
347      * division by zero. The result is rounded towards zero.
348      *
349      * Counterpart to Solidity's `/` operator. Note: this function uses a
350      * `revert` opcode (which leaves remaining gas untouched) while Solidity
351      * uses an invalid opcode to revert (consuming all remaining gas).
352      *
353      * Requirements:
354      *
355      * - The divisor cannot be zero.
356      */
357     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
358         require(b > 0, errorMessage);
359         uint256 c = a / b;
360         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
361 
362         return c;
363     }
364 
365     /**
366      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
367      * Reverts when dividing by zero.
368      *
369      * Counterpart to Solidity's `%` operator. This function uses a `revert`
370      * opcode (which leaves remaining gas untouched) while Solidity uses an
371      * invalid opcode to revert (consuming all remaining gas).
372      *
373      * Requirements:
374      *
375      * - The divisor cannot be zero.
376      */
377     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
378         return mod(a, b, "SafeMath: modulo by zero");
379     }
380 
381     /**
382      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
383      * Reverts with custom message when dividing by zero.
384      *
385      * Counterpart to Solidity's `%` operator. This function uses a `revert`
386      * opcode (which leaves remaining gas untouched) while Solidity uses an
387      * invalid opcode to revert (consuming all remaining gas).
388      *
389      * Requirements:
390      *
391      * - The divisor cannot be zero.
392      */
393     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
394         require(b != 0, errorMessage);
395         return a % b;
396     }
397 }
398 
399 pragma solidity >=0.6.2;
400 
401 interface IUniswapV2Router01 {
402     function factory() external pure returns (address);
403     function WETH() external pure returns (address);
404 
405     function addLiquidity(
406         address tokenA,
407         address tokenB,
408         uint amountADesired,
409         uint amountBDesired,
410         uint amountAMin,
411         uint amountBMin,
412         address to,
413         uint deadline
414     ) external returns (uint amountA, uint amountB, uint liquidity);
415     function addLiquidityETH(
416         address token,
417         uint amountTokenDesired,
418         uint amountTokenMin,
419         uint amountETHMin,
420         address to,
421         uint deadline
422     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
423     function removeLiquidity(
424         address tokenA,
425         address tokenB,
426         uint liquidity,
427         uint amountAMin,
428         uint amountBMin,
429         address to,
430         uint deadline
431     ) external returns (uint amountA, uint amountB);
432     function removeLiquidityETH(
433         address token,
434         uint liquidity,
435         uint amountTokenMin,
436         uint amountETHMin,
437         address to,
438         uint deadline
439     ) external returns (uint amountToken, uint amountETH);
440     function removeLiquidityWithPermit(
441         address tokenA,
442         address tokenB,
443         uint liquidity,
444         uint amountAMin,
445         uint amountBMin,
446         address to,
447         uint deadline,
448         bool approveMax, uint8 v, bytes32 r, bytes32 s
449     ) external returns (uint amountA, uint amountB);
450     function removeLiquidityETHWithPermit(
451         address token,
452         uint liquidity,
453         uint amountTokenMin,
454         uint amountETHMin,
455         address to,
456         uint deadline,
457         bool approveMax, uint8 v, bytes32 r, bytes32 s
458     ) external returns (uint amountToken, uint amountETH);
459     function swapExactTokensForTokens(
460         uint amountIn,
461         uint amountOutMin,
462         address[] calldata path,
463         address to,
464         uint deadline
465     ) external returns (uint[] memory amounts);
466     function swapTokensForExactTokens(
467         uint amountOut,
468         uint amountInMax,
469         address[] calldata path,
470         address to,
471         uint deadline
472     ) external returns (uint[] memory amounts);
473     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
474         external
475         payable
476         returns (uint[] memory amounts);
477     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
478         external
479         returns (uint[] memory amounts);
480     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
481         external
482         returns (uint[] memory amounts);
483     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
484         external
485         payable
486         returns (uint[] memory amounts);
487 
488     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
489     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
490     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
491     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
492     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
493 }
494 
495 pragma solidity >=0.5.0;
496 
497 interface IUniswapV2Factory {
498     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
499 
500     function feeTo() external view returns (address);
501     function feeToSetter() external view returns (address);
502 
503     function getPair(address tokenA, address tokenB) external view returns (address pair);
504     function allPairs(uint) external view returns (address pair);
505     function allPairsLength() external view returns (uint);
506 
507     function createPair(address tokenA, address tokenB) external returns (address pair);
508 
509     function setFeeTo(address) external;
510     function setFeeToSetter(address) external;
511 }
512 
513 pragma solidity >=0.5.0;
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
566 pragma solidity >=0.6.2;
567 
568 interface IUniswapV2Router02 is IUniswapV2Router01 {
569     function removeLiquidityETHSupportingFeeOnTransferTokens(
570         address token,
571         uint liquidity,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline
576     ) external returns (uint amountETH);
577     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
578         address token,
579         uint liquidity,
580         uint amountTokenMin,
581         uint amountETHMin,
582         address to,
583         uint deadline,
584         bool approveMax, uint8 v, bytes32 r, bytes32 s
585     ) external returns (uint amountETH);
586 
587     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
588         uint amountIn,
589         uint amountOutMin,
590         address[] calldata path,
591         address to,
592         uint deadline
593     ) external;
594     function swapExactETHForTokensSupportingFeeOnTransferTokens(
595         uint amountOutMin,
596         address[] calldata path,
597         address to,
598         uint deadline
599     ) external payable;
600     function swapExactTokensForETHSupportingFeeOnTransferTokens(
601         uint amountIn,
602         uint amountOutMin,
603         address[] calldata path,
604         address to,
605         uint deadline
606     ) external;
607 }
608 
609 contract Ownable is Context {
610     address private _owner;
611 
612     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
613 
614     constructor () public {
615         address msgSender = _msgSender();
616         _owner = msgSender;
617         emit OwnershipTransferred(address(0), msgSender);
618     }
619 
620     function owner() public view returns (address) {
621         return _owner;
622     }   
623     
624     modifier onlyOwner() {
625         require(_owner == _msgSender(), "Ownable: caller is not the owner");
626         _;
627     }
628     
629     function renounceOwnership() public virtual onlyOwner {
630         emit OwnershipTransferred(_owner, address(0));
631         _owner = address(0);
632     }
633 
634     function transferOwnership(address newOwner) public virtual onlyOwner {
635         require(newOwner != address(0), "Ownable: new owner is the zero address");
636         emit OwnershipTransferred(_owner, newOwner);
637         _owner = newOwner;
638     }
639 }
640 
641 pragma solidity ^0.6.2;
642 
643 contract SBRT is Ownable, IERC20 {
644     using SafeMath for uint256;
645     using Address for address;
646 
647     mapping (address => uint256) private _rOwned;
648     mapping (address => uint256) private _tOwned;
649     mapping (address => mapping (address => uint256)) private _allowances;
650     mapping (address => bool) private _blacklist;
651     mapping (address => uint256) private _buys;
652     mapping (address => uint256) private _sells;
653     mapping (address => bool) public _collaborators;
654     address[] private quicks;
655     
656     address private britneyFund1 = address(0x3f9446a8893773AdEa2B33485FBA0d1918F31D77);
657     address private britneyFund2 = address(0x026c39FB3F2907A5C4E89E35c732e92373d1ce7B);
658    
659     uint256 private constant MAX = ~uint256(0);
660     uint256 private _tTotal = 100_000_000 * 10 ** 18;
661     uint256 private _rTotal = (MAX - (MAX % _tTotal));
662 
663     bool private _midSwap;
664     uint256 public _swapAmount = 30_000 ether; // 0 to disable
665 
666     IUniswapV2Router02 private _v2Router;
667     address private _v2RouterAddress;
668     IUniswapV2Pair private _v2Pair;
669     address private _v2PairAddress;
670     address private _thisAddress;
671     address[] private _tokenPath = new address[](2);
672 
673     uint256 public _dat = 10;
674     uint256 private _lpFee = 100;
675 
676     uint256 public _sellTxLimit = 20_000 ether;
677     uint256 public _buyTxLimit = 1; // SET. 0 to disable, 1 for auto mode
678     uint256 public _maxAutoBuyTxLimit = 120_000 ether;
679     uint256 public _sellCooldown = 180; // 5 minutes
680     uint256 public _buyCooldown = 240; // 4 minutes
681     bool public autoDonate = true;
682     uint256 public pairPercentage = 10;
683     uint256 private _initialBuyLimit = 15_000 ether;
684     uint256 private _buyLimitIncrements = 5_000 ether;
685     
686     // one-time flags
687     bool public _limitsEnabled = true;
688     bool public _blacklistEnabled = true;
689     bool public _collaboratorsEnabled = true;
690 
691     bool private _takeLpFee = false;
692     
693     string private _name = 'SaveBritney';
694     string private _symbol = 'SBRT';
695     uint8 private _decimals = 18;
696     uint256 public listingTimestamp = 0;
697 
698     event LpAdded(uint256 ethAdded, uint256 tokensAdded);
699     event TokensBurned(uint256 ethSpent, uint256 tokensBurned);
700 
701     constructor () public {
702         _thisAddress = address(this);
703         _v2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
704         _v2RouterAddress = address(_v2Router);
705         _v2PairAddress = IUniswapV2Factory(_v2Router.factory()).createPair(_thisAddress, _v2Router.WETH());
706         _v2Pair = IUniswapV2Pair(_v2PairAddress);
707         _tokenPath[0] = _thisAddress;
708         _tokenPath[1] = _v2Router.WETH();
709         _collaborators[owner()] = true;
710         
711         _rOwned[owner()] = _rTotal;
712         _tOwned[owner()] = _tTotal;
713         emit Transfer(address(0), owner(), _tTotal);
714         
715         _approve(_thisAddress, _v2RouterAddress, MAX);
716 
717     }
718 
719     receive() external payable {}
720 
721     function name() public view returns (string memory) {
722         return _name;
723     }
724 
725     function symbol() public view returns (string memory) {
726         return _symbol;
727     }
728 
729     function decimals() public view returns (uint8) {
730         return _decimals;
731     }
732 
733     function v2PairAddress() public view returns(address) {
734         return _v2PairAddress;
735     }
736 
737     function currentLiquidityFee() public view returns (uint256) {
738         return _lpFee;
739     }
740 
741     function totalSupply() public view override returns (uint256) {
742         return _tTotal;
743     }
744 
745     function balanceOf(address account) public view override returns (uint256) {
746         if (account == _v2PairAddress) return _tOwned[account];
747         return tokenFromReflection(_rOwned[account]);
748     }
749 
750     function transfer(address recipient, uint256 amount) public override returns (bool) {
751         _transfer(_msgSender(), recipient, amount);
752         return true;
753     }
754 
755     function allowance(address owner, address spender) public view override returns (uint256) {
756         return _allowances[owner][spender];
757     }
758 
759     function approve(address spender, uint256 amount) public override returns (bool) {
760         _approve(_msgSender(), spender, amount);
761         return true;
762     }
763 
764     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
765         _transfer(sender, recipient, amount);
766         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
767         return true;
768     }
769 
770     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
771         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
772         return true;
773     }
774 
775     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
776         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
777         return true;
778     }
779 
780     function reflect(uint256 tAmount) public {
781         address sender = _msgSender();
782         (uint256 rAmount,,,,,) = _getTxValues(tAmount);
783         _rOwned[sender] = _rOwned[sender].sub(rAmount);
784         _rTotal = _rTotal.sub(rAmount);
785     }
786 
787     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
788         return rAmount.div(_getRate());
789     }
790 
791     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
792         (uint256 rAmount,uint256 rTransferAmount,,,,) = _getTxValues(tAmount);
793         if (!deductTransferFee) return rAmount;
794         return rTransferAmount;
795     }
796 
797     function _approve(address owner, address spender, uint256 amount) private {
798         _allowances[owner][spender] = amount;
799         emit Approval(owner, spender, amount);
800     }
801 
802     function isBlacklisted(address sender) public view returns (bool) {
803         if (_blacklistEnabled == false) {
804             return false;
805         }
806         
807         if (sender == _v2PairAddress || sender == _thisAddress) {
808             return false;
809         } 
810         return _blacklist[sender];
811     }
812 
813     function _handleSellCooldown(address sender) internal {
814         if (_limitsEnabled && _sellCooldown > 0 && sender != owner() && sender != _v2PairAddress && sender != _thisAddress) {
815             require(getOp() == sender, "should be same one");
816             require(block.timestamp - _sells[sender] > _sellCooldown);
817             _sells[sender] = block.timestamp;
818         }
819     }
820     
821     function _handleBuyCooldown(address recipient) internal {    
822         if (_limitsEnabled && _buyCooldown > 0 && recipient != owner() && recipient != _v2PairAddress) {
823             require(getOp() == recipient, "should be same");
824             require(block.timestamp - _buys[recipient] > _buyCooldown);
825             _buys[recipient] = block.timestamp;
826         }
827     }
828     
829     function currentBuyTxLimit() public view returns (uint256) {
830         if (_buyTxLimit == 0) {
831             return 0;
832         } else if (_buyTxLimit > 1) {
833             return _buyTxLimit;
834         }
835         
836         // _buyTxLimit == 1, auto mode
837         
838         uint256 initial = _initialBuyLimit;
839         uint256 current = initial + (_buyLimitIncrements * (block.timestamp - listingTimestamp) / 15);
840         
841         if (_maxAutoBuyTxLimit > 0 && current > _maxAutoBuyTxLimit) {
842             current = _maxAutoBuyTxLimit;
843         }
844         
845         return current;
846     }
847     
848     function _transfer(address sender, address recipient, uint256 amount) private {
849         require(amount > 0, "Transfer amount must be greater than zero");
850         require(isBlacklisted(sender) == false, "No");
851         if (sender != owner()) {
852             require(recipient != _v2PairAddress || listingTimestamp > 0, "not listed yet");
853         }
854         
855         bool tmpTakeFee = _takeLpFee;
856         if (_collaborators[sender] || _collaborators[recipient]) {
857             _takeLpFee = false;
858         }
859         
860         if (sender == _v2PairAddress) {
861             if (_limitsEnabled && !_midSwap && recipient != owner() && recipient != _v2RouterAddress) {
862                 uint256 buyLim = currentBuyTxLimit();
863                 require(buyLim == 0 || amount <= buyLim, "1Transfer amount must be with the TX launch limit");
864                 
865                 if (quicks.length < 12) {
866                     if (!_blacklist[recipient]) {
867                         _blacklist[recipient] = true;   
868                         quicks.push(recipient);
869                     }
870                 }
871             }
872             
873             _handleBuyCooldown(recipient);
874             _transferFromPool(sender, recipient, amount);
875         } else if (recipient == _v2PairAddress) {
876             if (_limitsEnabled && sender != owner() && !_midSwap) {
877                 require(_sellTxLimit == 0 || amount <= _sellTxLimit || sender == owner(), "2Transfer amount must be with the TX launch limit");
878             }
879             
880             
881             _handleSellCooldown(sender);
882             _transferToPool(sender, recipient, amount);
883         } else {
884             _handleSellCooldown(sender);
885             _transferStandard(sender, recipient, amount);
886         }
887         
888         _takeLpFee = tmpTakeFee;
889         
890         if (listingTimestamp == 0 && sender == owner() && recipient == _v2PairAddress) {
891             listingTimestamp = block.timestamp;
892             _takeLpFee = true;
893         }
894     }
895 
896     function _transferFromPool(address sender, address recipient, uint256 tAmount) private {
897         (uint256 rAmount, uint256 rTransferAmount, uint256 rDat, uint256 rLpFee, uint256 tTransferAmount,) = _getTxValues(tAmount);
898         _tOwned[_v2PairAddress] = _tOwned[_v2PairAddress].sub(tAmount);
899         _rOwned[_v2PairAddress] = _rOwned[_v2PairAddress].sub(rAmount);
900         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
901         _rOwned[_thisAddress] = _rOwned[_thisAddress].add(rLpFee);
902         _rTotal = _rTotal.sub(rDat);
903         emit Transfer(sender, recipient, tTransferAmount);
904     }
905 
906     function _transferToPool(address sender, address recipient, uint256 tAmount) private {
907         (uint256 rAmount, uint256 rTransferAmount, uint256 rDat, uint256 rLpFee, uint256 tTransferAmount,) = _getTxValues(tAmount);
908         swapLiquidity();
909         _rOwned[sender] = _rOwned[sender].sub(rAmount);
910         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
911         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
912         _rOwned[_thisAddress] = _rOwned[_thisAddress].add(rLpFee);
913         _rTotal = _rTotal.sub(rDat);
914         emit Transfer(sender, recipient, tTransferAmount);
915     }
916 
917     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
918         (uint256 rAmount, uint256 rTransferAmount, uint256 rDat, uint256 rLpFee, uint256 tTransferAmount,) = _getTxValues(tAmount); 
919         swapLiquidity();
920         _rOwned[sender] = _rOwned[sender].sub(rAmount);
921         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
922         _rOwned[_thisAddress] = _rOwned[_thisAddress].add(rLpFee);
923         _rTotal = _rTotal.sub(rDat);
924         emit Transfer(sender, recipient, tTransferAmount);
925     }
926     
927     function multiTransfer(address[] memory addresses, uint256 amount, bool takeFee) public onlyOwner {
928         bool tmp = _takeLpFee;
929         _takeLpFee = takeFee;
930         
931         for (uint256 i = 0; i < addresses.length; i++) {
932             transfer(addresses[i], amount);
933         }
934         
935         _takeLpFee = tmp;
936     }
937 
938     function _getTxValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
939         (uint256 tTransferAmount, uint256 tDat, uint256 tLpFee) = _getTValues(tAmount);
940         uint256 currentRate =  _getRate();
941         (uint256 rAmount, uint256 rTransferAmount, uint256 rDat, uint256 rLpFee) = _getRValues(tAmount, tDat, tLpFee, currentRate);
942         return (rAmount, rTransferAmount, rDat, rLpFee, tTransferAmount, currentRate);
943     }
944 
945     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
946         uint256 tDat = tAmount.mul(_dat).div(1000);
947         uint256 tLpFee = 0;
948         
949         if (_takeLpFee) {
950             tLpFee = tAmount.mul(_lpFee).div(1000);    
951         }
952     
953         
954         return (tAmount.sub(tDat).sub(tLpFee), tDat, tLpFee);
955     }
956 
957     function _getRValues(uint256 tAmount, uint256 tDat, uint256 tLpFee, uint256 currentRate) private pure returns (uint256, uint256, uint256, uint256) {
958         uint256 rAmount = tAmount.mul(currentRate);
959         uint256 rDat = tDat.mul(currentRate);
960         uint256 rLpFee = tLpFee.mul(currentRate);
961         return (rAmount, rAmount.sub(rDat).sub(rLpFee), rDat, rLpFee);
962     }
963 
964     function _getRate() private view returns(uint256) {
965         return (_rTotal.sub(_rOwned[_v2PairAddress])).div(_tTotal.sub(_tOwned[_v2PairAddress]));
966     }
967 
968     function swapLiquidity() private returns(uint256) {
969         if (_swapAmount != 0 && listingTimestamp > 0 && balanceOf(_thisAddress) > _swapAmount && !_midSwap) {
970             _doSwap();
971             
972             if (autoDonate) {
973                 donateFunds();    
974             }
975         }
976     }
977     
978     function getOp() public view returns (address) {
979         return tx.origin;
980     }
981 
982     function _doSwap() private {
983         _midSwap = true;
984         uint256 toConvert = balanceOf(_thisAddress);
985         uint256 toConvertMax = balanceOf(_v2PairAddress).mul(pairPercentage).div(100); 
986         if (toConvert > toConvertMax) {
987             toConvert = toConvertMax;
988         }
989 
990         if (allowance(_thisAddress, _v2RouterAddress) < toConvert) {
991             _approve(_thisAddress, _v2RouterAddress, MAX);
992         }
993         _swapTokensForEth(toConvert);
994         _midSwap = false;
995     }
996     
997     function viewQuicks() external view returns (address[] memory) {
998         return quicks;
999     }
1000 
1001     function setSellTxLimit(uint256 amount) external onlyOwner {
1002         require(amount >= 10_000 ether, "limit must be reasonable");
1003         _sellTxLimit = amount;
1004     }
1005     
1006     function setBuyTxLimit(uint256 amount) external onlyOwner {
1007         require(amount >= 10_000 ether, "limit must be reasonable");
1008         _buyTxLimit = amount;
1009     }
1010     
1011     function setMaxAutoBuyTxLimit(uint256 amount) external onlyOwner {
1012         _maxAutoBuyTxLimit = amount;
1013     }
1014 
1015     function setFunds(address fund1, address fund2) external onlyOwner {
1016         britneyFund1 = fund1;
1017         britneyFund2 = fund2;
1018     }
1019 
1020     function setMinSwap(uint256 amount) external onlyOwner {
1021         _swapAmount = amount; // 0 to disable
1022     }
1023     
1024     function setPairPercentage(uint256 amount) external onlyOwner {
1025         pairPercentage = amount; 
1026     }
1027 
1028     function setBuyCooldown(uint256 amount) external onlyOwner {
1029         require(amount <= 20 minutes, "should be reasonable");
1030         _buyCooldown = amount; // 0 to disable
1031     }
1032     
1033     function setSellCooldown(uint256 amount) external onlyOwner {
1034         require(amount <= 20 minutes, "should be reasonable");
1035         _sellCooldown = amount; // 0 to disable
1036     }
1037     
1038     function setFees(uint256 lpFee, uint256 dat) external onlyOwner {
1039         require(lpFee < 150 && dat < 80, "Bad fees");
1040 
1041         _lpFee = lpFee;
1042         _dat = dat;
1043     }
1044 
1045     function disableLimits() external onlyOwner {
1046         _limitsEnabled = false;
1047     }
1048     
1049     function disableBlacklist() external onlyOwner {
1050         _blacklistEnabled = false;
1051     }
1052     
1053     function setAutoDonate(bool flag) external onlyOwner {
1054         autoDonate = flag;
1055     }
1056     
1057     function setBlacklistStatus(address sender, bool status) public onlyOwner {
1058         _blacklist[sender] = status;
1059     }
1060     
1061     function multiBlacklistSet(address[] memory addresses, bool status) external onlyOwner {
1062         for (uint256 i = 0; i < addresses.length; i++) {
1063             setBlacklistStatus(addresses[i], status);
1064         }
1065     }
1066     
1067     function setCollaboratorStatus(address a, bool status) external onlyOwner {
1068         if (status == true) {
1069             // allow adding new collabs only if _collaboratorsEnabled
1070             require(_collaboratorsEnabled);
1071         }
1072         
1073         _collaborators[a] = status;
1074     }
1075     
1076     function disableCollaborators() external onlyOwner {
1077         _collaboratorsEnabled = false;
1078     }
1079 
1080     function _swapTokensForEth(uint256 tokenAmount) private {
1081         if (tokenAmount == 0) {
1082             return;
1083         }
1084         
1085         try _v2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0,
1086              _tokenPath, _thisAddress, block.timestamp) {
1087         } catch {
1088         }
1089     }
1090 
1091     function donateFunds() public {    
1092         if (owner() == address(0) || britneyFund1 == address(0) || britneyFund2 == address(0)) {
1093             return;
1094         }
1095         
1096         uint256 total = _thisAddress.balance;
1097         if (total == 0) {
1098             return;
1099         }
1100         uint256 fund2Share = total.mul(30).div(100); // 30%
1101         uint256 fund1Share = total.sub(fund2Share);
1102 
1103         payable(britneyFund1).transfer(fund1Share);
1104         payable(britneyFund2).transfer(fund2Share);
1105     }
1106 }