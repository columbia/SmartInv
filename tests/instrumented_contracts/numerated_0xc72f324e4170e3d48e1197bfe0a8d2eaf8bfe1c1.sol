1 /*
2 
3     TWEETY - Tweety Inu
4 
5     Website: https://tweetyinu.com
6 
7     Telegram: https://t.me/TweetyInuToken
8 
9     Twitter: https://twitter.com/TweetyInuToken
10 
11     Reddit: https://www.reddit.com/r/TweetyInu
12 
13     Instagram: https://www.instagram.com/p/CXyIrcirWxg
14 
15 */
16 
17 
18 
19 // SPDX-License-Identifier: Unlicensed
20 
21 pragma solidity ^0.8.9;
22 interface IERC20 {
23 
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
106  
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `*` operator.
161      *
162      * Requirements:
163      *
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return div(a, b, "SafeMath: division by zero");
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b > 0, errorMessage);
210         uint256 c = a / b;
211         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229         return mod(a, b, "SafeMath: modulo by zero");
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts with custom message when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b != 0, errorMessage);
246         return a % b;
247     }
248 }
249 
250 abstract contract Context {
251     //function _msgSender() internal view virtual returns (address payable) {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes memory) {
257         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
258         return msg.data;
259     }
260 }
261 
262 
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
286         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
287         // for accounts without code, i.e. `keccak256('')`
288         bytes32 codehash;
289         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { codehash := extcodehash(account) }
292         return (codehash != accountHash && codehash != 0x0);
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain`call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338       return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
348         return _functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         return _functionCallWithValue(target, data, value, errorMessage);
375     }
376 
377     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
378         require(isContract(target), "Address: call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 /**
402  * @dev Contract module which provides a basic access control mechanism, where
403  * there is an account (an owner) that can be granted exclusive access to
404  * specific functions.
405  *
406  * By default, the owner account will be the one that deploys the contract. This
407  * can later be changed with {transferOwnership}.
408  *
409  * This module is used through inheritance. It will make available the modifier
410  * `onlyOwner`, which can be applied to your functions to restrict their use to
411  * the owner.
412  */
413 contract Ownable is Context {
414     address private _owner;
415     address private _previousOwner;
416     uint256 private _lockTime;
417 
418     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
419 
420     /**
421      * @dev Initializes the contract setting the deployer as the initial owner.
422      */
423     constructor () {
424         address msgSender = _msgSender();
425         _owner = msgSender;
426         emit OwnershipTransferred(address(0), msgSender);
427     }
428 
429     /**
430      * @dev Returns the address of the current owner.
431      */
432     function owner() public view returns (address) {
433         return _owner;
434     }
435 
436     /**
437      * @dev Throws if called by any account other than the owner.
438      */
439     modifier onlyOwner() {
440         require(_owner == _msgSender(), "Ownable: caller is not the owner");
441         _;
442     }
443 
444      /**
445      * @dev Leaves the contract without owner. It will not be possible to call
446      * `onlyOwner` functions anymore. Can only be called by the current owner.
447      *
448      * NOTE: Renouncing ownership will leave the contract without an owner,
449      * thereby removing any functionality that is only available to the owner.
450      */
451     function renounceOwnership() public virtual onlyOwner {
452         emit OwnershipTransferred(_owner, address(0));
453         _owner = address(0);
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Can only be called by the current owner.
459      */
460     function transferOwnership(address newOwner) public virtual onlyOwner {
461         require(newOwner != address(0), "Ownable: new owner is the zero address");
462         emit OwnershipTransferred(_owner, newOwner);
463         _owner = newOwner;
464     }
465 
466     function geUnlockTime() public view returns (uint256) {
467         return _lockTime;
468     }
469 
470     //Locks the contract for owner for the amount of time provided
471     function lock(uint256 time) public virtual onlyOwner {
472         _previousOwner = _owner;
473         _owner = address(0);
474         _lockTime = block.timestamp + time;
475         emit OwnershipTransferred(_owner, address(0));
476     }
477     
478     //Unlocks the contract for owner when _lockTime is exceeds
479     function unlock() public virtual {
480         require(_previousOwner == msg.sender, "You don't have permission to unlock");
481         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
482         emit OwnershipTransferred(_owner, _previousOwner);
483         _owner = _previousOwner;
484     }
485 }
486 
487 
488 interface IUniswapV2Factory {
489     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
490 
491     function feeTo() external view returns (address);
492     function feeToSetter() external view returns (address);
493 
494     function getPair(address tokenA, address tokenB) external view returns (address pair);
495     function allPairs(uint) external view returns (address pair);
496     function allPairsLength() external view returns (uint);
497 
498     function createPair(address tokenA, address tokenB) external returns (address pair);
499 
500     function setFeeTo(address) external;
501     function setFeeToSetter(address) external;
502 }
503 
504 
505 
506 interface IUniswapV2Pair {
507     event Approval(address indexed owner, address indexed spender, uint value);
508     event Transfer(address indexed from, address indexed to, uint value);
509 
510     function name() external pure returns (string memory);
511     function symbol() external pure returns (string memory);
512     function decimals() external pure returns (uint8);
513     function totalSupply() external view returns (uint);
514     function balanceOf(address owner) external view returns (uint);
515     function allowance(address owner, address spender) external view returns (uint);
516 
517     function approve(address spender, uint value) external returns (bool);
518     function transfer(address to, uint value) external returns (bool);
519     function transferFrom(address from, address to, uint value) external returns (bool);
520 
521     function DOMAIN_SEPARATOR() external view returns (bytes32);
522     function PERMIT_TYPEHASH() external pure returns (bytes32);
523     function nonces(address owner) external view returns (uint);
524 
525     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
526 
527     event Mint(address indexed sender, uint amount0, uint amount1);
528     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
529     event Swap(
530         address indexed sender,
531         uint amount0In,
532         uint amount1In,
533         uint amount0Out,
534         uint amount1Out,
535         address indexed to
536     );
537     event Sync(uint112 reserve0, uint112 reserve1);
538 
539     function MINIMUM_LIQUIDITY() external pure returns (uint);
540     function factory() external view returns (address);
541     function token0() external view returns (address);
542     function token1() external view returns (address);
543     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
544     function price0CumulativeLast() external view returns (uint);
545     function price1CumulativeLast() external view returns (uint);
546     function kLast() external view returns (uint);
547 
548     function mint(address to) external returns (uint liquidity);
549     function burn(address to) external returns (uint amount0, uint amount1);
550     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
551     function skim(address to) external;
552     function sync() external;
553 
554     function initialize(address, address) external;
555 }
556 
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
696 contract TWEETY is Context, IERC20, Ownable {
697     using SafeMath for uint256;
698     using Address for address;
699 
700     mapping (address => uint256) private _rOwned;
701     mapping (address => uint256) private _tOwned;
702     mapping (address => mapping (address => uint256)) private _allowances;
703 
704     mapping (address => bool) private _isExcludedFromFee;
705 
706     mapping (address => bool) private _isExcluded;
707     address[] private _excluded;
708     
709     mapping (address => bool) private botWallets;
710     bool botscantrade = false;
711     
712     bool public canTrade = false;
713    
714     uint256 private constant MAX = ~uint256(0);
715     uint256 private _tTotal = 69000000000000000000000 * 10**9;
716     uint256 private _rTotal = (MAX - (MAX % _tTotal));
717     uint256 private _tFeeTotal;
718     address public marketingWallet;
719 
720     string private _name = "Tweety Inu";
721     string private _symbol = "TWEETY";
722     uint8 private _decimals = 9;
723     
724     uint256 public _taxFee = 1;
725     uint256 private _previousTaxFee = _taxFee;
726     
727     uint256 public _liquidityFee = 12;
728     uint256 private _previousLiquidityFee = _liquidityFee;
729 
730     IUniswapV2Router02 public immutable uniswapV2Router;
731     address public immutable uniswapV2Pair;
732     
733     bool inSwapAndLiquify;
734     bool public swapAndLiquifyEnabled = true;
735     
736     uint256 public _maxTxAmount = 990000000000000000000 * 10**9;
737     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
738     
739     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
740     event SwapAndLiquifyEnabledUpdated(bool enabled);
741     event SwapAndLiquify(
742         uint256 tokensSwapped,
743         uint256 ethReceived,
744         uint256 tokensIntoLiqudity
745     );
746     
747     modifier lockTheSwap {
748         inSwapAndLiquify = true;
749         _;
750         inSwapAndLiquify = false;
751     }
752     
753     constructor () {
754         _rOwned[_msgSender()] = _rTotal;
755         
756         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
757          // Create a uniswap pair for this new token
758         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
759             .createPair(address(this), _uniswapV2Router.WETH());
760 
761         // set the rest of the contract variables
762         uniswapV2Router = _uniswapV2Router;
763         
764         //exclude owner and this contract from fee
765         _isExcludedFromFee[owner()] = true;
766         _isExcludedFromFee[address(this)] = true;
767         
768         emit Transfer(address(0), _msgSender(), _tTotal);
769     }
770 
771     function name() public view returns (string memory) {
772         return _name;
773     }
774 
775     function symbol() public view returns (string memory) {
776         return _symbol;
777     }
778 
779     function decimals() public view returns (uint8) {
780         return _decimals;
781     }
782 
783     function totalSupply() public view override returns (uint256) {
784         return _tTotal;
785     }
786 
787     function balanceOf(address account) public view override returns (uint256) {
788         if (_isExcluded[account]) return _tOwned[account];
789         return tokenFromReflection(_rOwned[account]);
790     }
791 
792     function transfer(address recipient, uint256 amount) public override returns (bool) {
793         _transfer(_msgSender(), recipient, amount);
794         return true;
795     }
796 
797     function allowance(address owner, address spender) public view override returns (uint256) {
798         return _allowances[owner][spender];
799     }
800 
801     function approve(address spender, uint256 amount) public override returns (bool) {
802         _approve(_msgSender(), spender, amount);
803         return true;
804     }
805 
806     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
807         _transfer(sender, recipient, amount);
808         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
809         return true;
810     }
811 
812     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
814         return true;
815     }
816 
817     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
818         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
819         return true;
820     }
821 
822     function isExcludedFromReward(address account) public view returns (bool) {
823         return _isExcluded[account];
824     }
825 
826     function totalFees() public view returns (uint256) {
827         return _tFeeTotal;
828     }
829     
830     function airdrop(address recipient, uint256 amount) external onlyOwner() {
831         removeAllFee();
832         _transfer(_msgSender(), recipient, amount * 10**9);
833         restoreAllFee();
834     }
835     
836     function airdropInternal(address recipient, uint256 amount) internal {
837         removeAllFee();
838         _transfer(_msgSender(), recipient, amount);
839         restoreAllFee();
840     }
841     
842     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
843         uint256 iterator = 0;
844         require(newholders.length == amounts.length, "must be the same length");
845         while(iterator < newholders.length){
846             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
847             iterator += 1;
848         }
849     }
850 
851     function deliver(uint256 tAmount) public {
852         address sender = _msgSender();
853         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
854         (uint256 rAmount,,,,,) = _getValues(tAmount);
855         _rOwned[sender] = _rOwned[sender].sub(rAmount);
856         _rTotal = _rTotal.sub(rAmount);
857         _tFeeTotal = _tFeeTotal.add(tAmount);
858     }
859 
860     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
861         require(tAmount <= _tTotal, "Amount must be less than supply");
862         if (!deductTransferFee) {
863             (uint256 rAmount,,,,,) = _getValues(tAmount);
864             return rAmount;
865         } else {
866             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
867             return rTransferAmount;
868         }
869     }
870 
871     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
872         require(rAmount <= _rTotal, "Amount must be less than total reflections");
873         uint256 currentRate =  _getRate();
874         return rAmount.div(currentRate);
875     }
876 
877     function excludeFromReward(address account) public onlyOwner() {
878         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
879         require(!_isExcluded[account], "Account is already excluded");
880         if(_rOwned[account] > 0) {
881             _tOwned[account] = tokenFromReflection(_rOwned[account]);
882         }
883         _isExcluded[account] = true;
884         _excluded.push(account);
885     }
886 
887     function includeInReward(address account) external onlyOwner() {
888         require(_isExcluded[account], "Account is already excluded");
889         for (uint256 i = 0; i < _excluded.length; i++) {
890             if (_excluded[i] == account) {
891                 _excluded[i] = _excluded[_excluded.length - 1];
892                 _tOwned[account] = 0;
893                 _isExcluded[account] = false;
894                 _excluded.pop();
895                 break;
896             }
897         }
898     }
899         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
900         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
901         _tOwned[sender] = _tOwned[sender].sub(tAmount);
902         _rOwned[sender] = _rOwned[sender].sub(rAmount);
903         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
904         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
905         _takeLiquidity(tLiquidity);
906         _reflectFee(rFee, tFee);
907         emit Transfer(sender, recipient, tTransferAmount);
908     }
909     
910     function excludeFromFee(address account) public onlyOwner {
911         _isExcludedFromFee[account] = true;
912     }
913     
914     function includeInFee(address account) public onlyOwner {
915         _isExcludedFromFee[account] = false;
916     }
917 
918     function setMarketingWallet(address walletAddress) public onlyOwner {
919         marketingWallet = walletAddress;
920     }
921 
922     function upliftTxAmount() external onlyOwner() {
923         _maxTxAmount = 69000000000000000000000 * 10**9;
924     }
925     
926     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
927         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
928         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
929     }
930     
931     function claimTokens () public onlyOwner {
932         // make sure we capture all BNB that may or may not be sent to this contract
933         payable(marketingWallet).transfer(address(this).balance);
934     }
935     
936     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
937         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
938     }
939     
940     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
941         walletaddress.transfer(address(this).balance);
942     }
943     
944     function addBotWallet(address botwallet) external onlyOwner() {
945         botWallets[botwallet] = true;
946     }
947     
948     function removeBotWallet(address botwallet) external onlyOwner() {
949         botWallets[botwallet] = false;
950     }
951     
952     function getBotWalletStatus(address botwallet) public view returns (bool) {
953         return botWallets[botwallet];
954     }
955     
956     function allowtrading()external onlyOwner() {
957         canTrade = true;
958     }
959 
960     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
961         swapAndLiquifyEnabled = _enabled;
962         emit SwapAndLiquifyEnabledUpdated(_enabled);
963     }
964     
965      //to recieve ETH from uniswapV2Router when swaping
966     receive() external payable {}
967 
968     function _reflectFee(uint256 rFee, uint256 tFee) private {
969         _rTotal = _rTotal.sub(rFee);
970         _tFeeTotal = _tFeeTotal.add(tFee);
971     }
972 
973     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
974         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
975         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
976         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
977     }
978 
979     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
980         uint256 tFee = calculateTaxFee(tAmount);
981         uint256 tLiquidity = calculateLiquidityFee(tAmount);
982         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
983         return (tTransferAmount, tFee, tLiquidity);
984     }
985 
986     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
987         uint256 rAmount = tAmount.mul(currentRate);
988         uint256 rFee = tFee.mul(currentRate);
989         uint256 rLiquidity = tLiquidity.mul(currentRate);
990         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
991         return (rAmount, rTransferAmount, rFee);
992     }
993 
994     function _getRate() private view returns(uint256) {
995         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
996         return rSupply.div(tSupply);
997     }
998 
999     function _getCurrentSupply() private view returns(uint256, uint256) {
1000         uint256 rSupply = _rTotal;
1001         uint256 tSupply = _tTotal;      
1002         for (uint256 i = 0; i < _excluded.length; i++) {
1003             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1004             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1005             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1006         }
1007         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1008         return (rSupply, tSupply);
1009     }
1010     
1011     function _takeLiquidity(uint256 tLiquidity) private {
1012         uint256 currentRate =  _getRate();
1013         uint256 rLiquidity = tLiquidity.mul(currentRate);
1014         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1015         if(_isExcluded[address(this)])
1016             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1017     }
1018     
1019     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1020         return _amount.mul(_taxFee).div(
1021             10**2
1022         );
1023     }
1024 
1025     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1026         return _amount.mul(_liquidityFee).div(
1027             10**2
1028         );
1029     }
1030     
1031     function removeAllFee() private {
1032         if(_taxFee == 0 && _liquidityFee == 0) return;
1033         
1034         _previousTaxFee = _taxFee;
1035         _previousLiquidityFee = _liquidityFee;
1036         
1037         _taxFee = 0;
1038         _liquidityFee = 0;
1039     }
1040     
1041     function restoreAllFee() private {
1042         _taxFee = _previousTaxFee;
1043         _liquidityFee = _previousLiquidityFee;
1044     }
1045     
1046     function isExcludedFromFee(address account) public view returns(bool) {
1047         return _isExcludedFromFee[account];
1048     }
1049 
1050     function _approve(address owner, address spender, uint256 amount) private {
1051         require(owner != address(0), "ERC20: approve from the zero address");
1052         require(spender != address(0), "ERC20: approve to the zero address");
1053 
1054         _allowances[owner][spender] = amount;
1055         emit Approval(owner, spender, amount);
1056     }
1057 
1058     function _transfer(
1059         address from,
1060         address to,
1061         uint256 amount
1062     ) private {
1063         require(from != address(0), "ERC20: transfer from the zero address");
1064         require(to != address(0), "ERC20: transfer to the zero address");
1065         require(amount > 0, "Transfer amount must be greater than zero");
1066         if(from != owner() && to != owner())
1067             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1068 
1069         // is the token balance of this contract address over the min number of
1070         // tokens that we need to initiate a swap + liquidity lock?
1071         // also, don't get caught in a circular liquidity event.
1072         // also, don't swap & liquify if sender is uniswap pair.
1073         uint256 contractTokenBalance = balanceOf(address(this));
1074         
1075         if(contractTokenBalance >= _maxTxAmount)
1076         {
1077             contractTokenBalance = _maxTxAmount;
1078         }
1079         
1080         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1081         if (
1082             overMinTokenBalance &&
1083             !inSwapAndLiquify &&
1084             from != uniswapV2Pair &&
1085             swapAndLiquifyEnabled
1086         ) {
1087             contractTokenBalance = numTokensSellToAddToLiquidity;
1088             //add liquidity
1089             swapAndLiquify(contractTokenBalance);
1090         }
1091         
1092         //indicates if fee should be deducted from transfer
1093         bool takeFee = true;
1094         
1095         //if any account belongs to _isExcludedFromFee account then remove the fee
1096         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1097             takeFee = false;
1098         }
1099         
1100         //transfer amount, it will take tax, burn, liquidity fee
1101         _tokenTransfer(from,to,amount,takeFee);
1102     }
1103 
1104     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1105         // split the contract balance into halves
1106         // add the marketing wallet
1107         uint256 half = contractTokenBalance.div(2);
1108         uint256 otherHalf = contractTokenBalance.sub(half);
1109 
1110         // capture the contract's current ETH balance.
1111         // this is so that we can capture exactly the amount of ETH that the
1112         // swap creates, and not make the liquidity event include any ETH that
1113         // has been manually sent to the contract
1114         uint256 initialBalance = address(this).balance;
1115 
1116         // swap tokens for ETH
1117         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1118 
1119         // how much ETH did we just swap into?
1120         uint256 newBalance = address(this).balance.sub(initialBalance);
1121         uint256 marketingshare = newBalance.mul(75).div(100);
1122         payable(marketingWallet).transfer(marketingshare);
1123         newBalance -= marketingshare;
1124         // add liquidity to uniswap
1125         addLiquidity(otherHalf, newBalance);
1126         
1127         emit SwapAndLiquify(half, newBalance, otherHalf);
1128     }
1129 
1130     function swapTokensForEth(uint256 tokenAmount) private {
1131         // generate the uniswap pair path of token -> weth
1132         address[] memory path = new address[](2);
1133         path[0] = address(this);
1134         path[1] = uniswapV2Router.WETH();
1135 
1136         _approve(address(this), address(uniswapV2Router), tokenAmount);
1137 
1138         // make the swap
1139         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1140             tokenAmount,
1141             0, // accept any amount of ETH
1142             path,
1143             address(this),
1144             block.timestamp
1145         );
1146     }
1147 
1148     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1149         // approve token transfer to cover all possible scenarios
1150         _approve(address(this), address(uniswapV2Router), tokenAmount);
1151 
1152         // add the liquidity
1153         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1154             address(this),
1155             tokenAmount,
1156             0, // slippage is unavoidable
1157             0, // slippage is unavoidable
1158             owner(),
1159             block.timestamp
1160         );
1161     }
1162 
1163     //this method is responsible for taking all fee, if takeFee is true
1164     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1165         if(!canTrade){
1166             require(sender == owner()); // only owner allowed to trade or add liquidity
1167         }
1168         
1169         if(botWallets[sender] || botWallets[recipient]){
1170             require(botscantrade, "bots arent allowed to trade");
1171         }
1172         
1173         if(!takeFee)
1174             removeAllFee();
1175         
1176         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1177             _transferFromExcluded(sender, recipient, amount);
1178         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1179             _transferToExcluded(sender, recipient, amount);
1180         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1181             _transferStandard(sender, recipient, amount);
1182         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1183             _transferBothExcluded(sender, recipient, amount);
1184         } else {
1185             _transferStandard(sender, recipient, amount);
1186         }
1187         
1188         if(!takeFee)
1189             restoreAllFee();
1190     }
1191 
1192     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1193         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1194         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1195         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1196         _takeLiquidity(tLiquidity);
1197         _reflectFee(rFee, tFee);
1198         emit Transfer(sender, recipient, tTransferAmount);
1199     }
1200 
1201     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1202         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1203         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1204         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1205         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1206         _takeLiquidity(tLiquidity);
1207         _reflectFee(rFee, tFee);
1208         emit Transfer(sender, recipient, tTransferAmount);
1209     }
1210 
1211     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1212         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1213         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1214         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1215         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1216         _takeLiquidity(tLiquidity);
1217         _reflectFee(rFee, tFee);
1218         emit Transfer(sender, recipient, tTransferAmount);
1219     }
1220 
1221 }