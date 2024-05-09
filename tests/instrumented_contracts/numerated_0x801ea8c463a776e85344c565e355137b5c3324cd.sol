1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the BEP20 standard as defined in the EIP.
28  */
29 interface IBEP20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
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
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
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
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
279         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
280         // for accounts without code, i.e. `keccak256('')`
281         bytes32 codehash;
282         bytes32 accountHash = 0;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { codehash := extcodehash(account) }
285         return (codehash != accountHash && codehash != 0x0);
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain`call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331       return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
341         return _functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         return _functionCallWithValue(target, data, value, errorMessage);
368     }
369 
370     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
371         require(isContract(target), "Address: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 /**
395  * @dev Contract module which provides a basic access control mechanism, where
396  * there is an account (an owner) that can be granted exclusive access to
397  * specific functions.
398  *
399  * By default, the owner account will be the one that deploys the contract. This
400  * can later be changed with {transferOwnership}.
401  *
402  * This module is used through inheritance. It will make available the modifier
403  * `onlyOwner`, which can be applied to your functions to restrict their use to
404  * the owner.
405  */
406 contract Ownable is Context {
407     address private _owner;
408 
409     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411     /**
412      * @dev Initializes the contract setting the deployer as the initial owner.
413      */
414     constructor () {
415         address msgSender = _msgSender();
416         _owner = msgSender;
417         emit OwnershipTransferred(address(0), msgSender);
418     }
419 
420     /**
421      * @dev Returns the address of the current owner.
422      */
423     function owner() public view returns (address) {
424         return _owner;
425     }
426 
427     /**
428      * @dev Throws if called by any account other than the owner.
429      */
430     modifier onlyOwner() {
431         require(_owner == _msgSender(), "Ownable: caller is not the owner");
432         _;
433     }
434 
435     /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         emit OwnershipTransferred(_owner, address(0));
444         _owner = address(0);
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Can only be called by the current owner.
450      */
451     function transferOwnership(address newOwner) public virtual onlyOwner {
452         require(newOwner != address(0), "Ownable: new owner is the zero address");
453         emit OwnershipTransferred(_owner, newOwner);
454         _owner = newOwner;
455     }
456 }
457 
458 interface IUniswapV2Factory {
459     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
460 
461     function feeTo() external view returns (address);
462     function feeToSetter() external view returns (address);
463 
464     function getPair(address tokenA, address tokenB) external view returns (address pair);
465     function allPairs(uint) external view returns (address pair);
466     function allPairsLength() external view returns (uint);
467 
468     function createPair(address tokenA, address tokenB) external returns (address pair);
469 
470     function setFeeTo(address) external;
471     function setFeeToSetter(address) external;
472 }
473 
474 
475 interface IUniswapV2ERC20 {
476     event Approval(address indexed owner, address indexed spender, uint value);
477     event Transfer(address indexed from, address indexed to, uint value);
478 
479     function name() external pure returns (string memory);
480     function symbol() external pure returns (string memory);
481     function decimals() external pure returns (uint8);
482     function totalSupply() external view returns (uint);
483     function balanceOf(address owner) external view returns (uint);
484     function allowance(address owner, address spender) external view returns (uint);
485 
486     function approve(address spender, uint value) external returns (bool);
487     function transfer(address to, uint value) external returns (bool);
488     function transferFrom(address from, address to, uint value) external returns (bool);
489 
490     function DOMAIN_SEPARATOR() external view returns (bytes32);
491     function PERMIT_TYPEHASH() external pure returns (bytes32);
492     function nonces(address owner) external view returns (uint);
493 
494     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
495 }
496 
497 interface IUniswapV2Router01 {
498     function factory() external pure returns (address);
499     function WETH() external pure returns (address);
500 
501     function addLiquidity(
502         address tokenA,
503         address tokenB,
504         uint amountADesired,
505         uint amountBDesired,
506         uint amountAMin,
507         uint amountBMin,
508         address to,
509         uint deadline
510     ) external returns (uint amountA, uint amountB, uint liquidity);
511     function addLiquidityETH(
512         address token,
513         uint amountTokenDesired,
514         uint amountTokenMin,
515         uint amountETHMin,
516         address to,
517         uint deadline
518     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
519     function removeLiquidity(
520         address tokenA,
521         address tokenB,
522         uint liquidity,
523         uint amountAMin,
524         uint amountBMin,
525         address to,
526         uint deadline
527     ) external returns (uint amountA, uint amountB);
528     function removeLiquidityETH(
529         address token,
530         uint liquidity,
531         uint amountTokenMin,
532         uint amountETHMin,
533         address to,
534         uint deadline
535     ) external returns (uint amountToken, uint amountETH);
536     function removeLiquidityWithPermit(
537         address tokenA,
538         address tokenB,
539         uint liquidity,
540         uint amountAMin,
541         uint amountBMin,
542         address to,
543         uint deadline,
544         bool approveMax, uint8 v, bytes32 r, bytes32 s
545     ) external returns (uint amountA, uint amountB);
546     function removeLiquidityETHWithPermit(
547         address token,
548         uint liquidity,
549         uint amountTokenMin,
550         uint amountETHMin,
551         address to,
552         uint deadline,
553         bool approveMax, uint8 v, bytes32 r, bytes32 s
554     ) external returns (uint amountToken, uint amountETH);
555     function swapExactTokensForTokens(
556         uint amountIn,
557         uint amountOutMin,
558         address[] calldata path,
559         address to,
560         uint deadline
561     ) external returns (uint[] memory amounts);
562     function swapTokensForExactTokens(
563         uint amountOut,
564         uint amountInMax,
565         address[] calldata path,
566         address to,
567         uint deadline
568     ) external returns (uint[] memory amounts);
569     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
570         external
571         payable
572         returns (uint[] memory amounts);
573     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
574         external
575         returns (uint[] memory amounts);
576     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
577         external
578         returns (uint[] memory amounts);
579     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
580         external
581         payable
582         returns (uint[] memory amounts);
583 
584     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
585     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
586     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
587     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
588     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
589 }
590 
591 interface IUniswapV2Router02 is IUniswapV2Router01 {
592     function removeLiquidityETHSupportingFeeOnTransferTokens(
593         address token,
594         uint liquidity,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline
599     ) external returns (uint amountETH);
600     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
601         address token,
602         uint liquidity,
603         uint amountTokenMin,
604         uint amountETHMin,
605         address to,
606         uint deadline,
607         bool approveMax, uint8 v, bytes32 r, bytes32 s
608     ) external returns (uint amountETH);
609 
610     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
611         uint amountIn,
612         uint amountOutMin,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external;
617     function swapExactETHForTokensSupportingFeeOnTransferTokens(
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external payable;
623     function swapExactTokensForETHSupportingFeeOnTransferTokens(
624         uint amountIn,
625         uint amountOutMin,
626         address[] calldata path,
627         address to,
628         uint deadline
629     ) external;
630 }
631 
632 
633 contract StarBound is Context, IBEP20, Ownable {
634     using SafeMath for uint256;
635     using Address for address;
636 
637 
638     IUniswapV2Router02 public uniswapV2Router;
639     mapping (address => uint256) private _rOwned;
640     mapping (address => uint256) private _tOwned;
641     mapping (address => mapping (address => uint256)) private _allowances;
642     mapping (address => uint) public lastTimeSold;
643 
644     mapping (address => bool) private _isExcluded;
645     address[] private _excluded;
646     
647     address public uniswapV2Pair;
648     address payable growthFuel;
649    
650     uint256 private constant MAX = ~uint256(0);
651     uint256 private _tTotal = 3333333333 * 10**18;
652     uint256 private _rTotal = (MAX - (MAX % _tTotal));
653     uint256 private _tFeeTotal;
654 
655     string private _name = 'StarBound';
656     string private _symbol =  unicode"🌌";
657     uint8 private _decimals = 18;
658     uint private DecimalFactor = 10 ** _decimals;
659     
660     uint private _tokensAmountToLiquify;
661     bool inSwapAndLiquify;
662     bool swapInProgress;
663     bool public _swapAndLiquifyEnabled;
664 
665     uint public burnRate;
666     uint public liquidFuelRate;
667     uint public totalBurned;
668 
669     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiqudity);
670     
671     modifier lockTheSwap {
672         inSwapAndLiquify = true;
673         _;
674         inSwapAndLiquify = false;
675     }
676     
677 
678     constructor (address payable _growthFuel)  {
679         _rOwned[msg.sender] = _rTotal;    
680         emit Transfer(address(0), _msgSender(), _tTotal);
681         
682         _swapAndLiquifyEnabled = false;
683         swapInProgress = false;
684         burnRate = 1;
685         liquidFuelRate = 8;
686         growthFuel = _growthFuel; 
687         
688         // eth router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
689         // viperswap harmony 0xf012702a5f0e54015362cBCA26a26fc90AA832a3
690         // pancakeswap BSC 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F
691          
692         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // eth router
693         
694         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
695         uniswapV2Router = _uniswapV2Router;
696         
697         _tokensAmountToLiquify = 3333000 * DecimalFactor ;
698     }
699     
700     function setBurnRate(uint amount) public onlyOwner() {
701         require (amount <= 3, "Burn rate !> 3%");
702         burnRate = amount;
703     }
704 
705     function setLiquidFuelRate(uint amount) public onlyOwner() {
706         require (amount <= 8, "LiquidFuelRate !> 8%");
707         liquidFuelRate = amount;
708     }
709 
710     function setSwapAndLiquifyEnabled(bool enable) public onlyOwner() {
711         _swapAndLiquifyEnabled = enable;
712     }    
713     
714     function setTokensAmountToLiquify(uint amount) public onlyOwner() {
715         _tokensAmountToLiquify = amount.mul(DecimalFactor);
716     }
717     
718     function viewTokensAmountToLiquify() public view returns(uint) {
719         return _tokensAmountToLiquify;
720     }
721 
722     function name() public view returns (string memory) {
723         return _name;
724     }
725 
726     function symbol() public view returns (string memory) {
727         return _symbol;
728     }
729 
730     function decimals() public view returns (uint8) {
731         return _decimals;
732     }
733 
734     function totalSupply() public view override returns (uint256) {
735         return _tTotal;
736     }
737 
738     function balanceOf(address account) public view override returns (uint256) {
739         if (_isExcluded[account]) return _tOwned[account];
740         return tokenFromReflection(_rOwned[account]);
741     }
742 
743     function transfer(address recipient, uint256 amount) public override returns (bool) {
744         _transfer(_msgSender(), recipient, amount);
745         return true;
746     }
747 
748     function allowance(address owner, address spender) public view override returns (uint256) {
749         return _allowances[owner][spender];
750     }
751 
752     function approve(address spender, uint256 amount) public override returns (bool) {
753         _approve(_msgSender(), spender, amount);
754         return true;
755     }
756 
757     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
758         _transfer(sender, recipient, amount);
759         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
760         return true;
761     }
762 
763     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
764         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
765         return true;
766     }
767 
768     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
769         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
770         return true;
771     }
772 
773     function isExcluded(address account) public view returns (bool) {
774         return _isExcluded[account];
775     }
776 
777     function totalFees() public view returns (uint256) {
778         return _tFeeTotal;
779     }
780     
781     function achievementReward(uint256 tAmount) public {
782         address sender = _msgSender();
783         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
784         (uint256 rAmount,,,,) = _getValues(tAmount);
785         _rOwned[sender] = _rOwned[sender].sub(rAmount);
786         _rTotal = _rTotal.sub(rAmount);
787         _tFeeTotal = _tFeeTotal.add(tAmount);
788     }
789 
790     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
791         require(tAmount <= _tTotal, "Amount must be less than supply");
792         if (!deductTransferFee) {
793             (uint256 rAmount,,,,) = _getValues(tAmount);
794             return rAmount;
795         } else {
796             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
797             return rTransferAmount;
798         }
799     }
800 
801     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
802         require(rAmount <= _rTotal, "Amount must be less than total reflections");
803         uint256 currentRate =  _getRate();
804         return rAmount.div(currentRate);
805     }
806 
807     function excludeAccount(address account) external onlyOwner() {
808         require(!_isExcluded[account], "Account is already excluded");
809         if(_rOwned[account] > 0) {
810             _tOwned[account] = tokenFromReflection(_rOwned[account]);
811         }
812         _isExcluded[account] = true;
813         _excluded.push(account);
814     }
815 
816     function includeAccount(address account) external onlyOwner() {
817         require(_isExcluded[account], "Account is already excluded");
818         for (uint256 i = 0; i < _excluded.length; i++) {
819             if (_excluded[i] == account) {
820                 _excluded[i] = _excluded[_excluded.length - 1];
821                 _tOwned[account] = 0;
822                 _isExcluded[account] = false;
823                 _excluded.pop();
824                 break;
825             }
826         }
827     }
828 
829     function _approve(address owner, address spender, uint256 amount) private {
830         require(owner != address(0), "BEP20: approve from the zero address");
831         require(spender != address(0), "BEP20: approve to the zero address");
832 
833         _allowances[owner][spender] = amount;
834         emit Approval(owner, spender, amount);
835     }
836 
837     function _transfer(address sender, address recipient, uint256 amount) private {
838         require(sender != address(0), "BEP20: transfer from the zero address");
839         require(recipient != address(0), "BEP20: transfer to the zero address");
840         require(amount > 0, "Transfer amount must be greater than zero");
841         
842         
843         uint contractTokenBalance = balanceOf(address(this));
844         bool overMinTokenBalance = (contractTokenBalance >= _tokensAmountToLiquify);
845             
846         if (overMinTokenBalance && !inSwapAndLiquify && msg.sender != uniswapV2Pair && _swapAndLiquifyEnabled) {
847             contractTokenBalance = _tokensAmountToLiquify;
848             swapInProgress = true;
849             swapAndLiquify(contractTokenBalance);
850             swapInProgress = false;
851         }
852         
853         if(swapInProgress){
854         _transferStandard(sender, recipient, amount);
855         } else {
856             
857         bool feeOnTransfer;
858         uint feeFactor = 1;
859 
860         if(sender == address(this) || sender == owner() ) {
861             feeOnTransfer = false;
862         } else {
863             feeOnTransfer = true;
864         }
865 
866         if(recipient == address(uniswapV2Pair) || recipient == address(uniswapV2Router) ) {                    
867             if (feeOnTransfer) {                        
868                 uint oneThirdSenderBalance = balanceOf(sender).div(3);
869                 require (amount <= oneThirdSenderBalance);                        
870                 uint _lastTimeSold = lastTimeSold[sender];
871                 uint _now = block.timestamp;
872                 if (_now.sub(_lastTimeSold) < 1 days) {
873                         feeFactor = 2;
874                 }
875             }
876         }
877 
878         if (feeOnTransfer) {
879             uint liquidityAndFuel = amount.div(100).mul(liquidFuelRate).mul(feeFactor);
880             (uint tBurnAmount, uint rBurnAmount) = _getBurnAmounts(amount);
881             amount = amount.sub(tBurnAmount).sub(liquidityAndFuel);
882             _transferToExcluded(sender, address(this), liquidityAndFuel);
883         
884             if (_isExcluded[sender] && !_isExcluded[recipient]) {
885                 _transferFromExcluded(sender, recipient, amount);
886             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
887                 _transferToExcluded(sender, recipient, amount);
888             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
889                 _transferStandard(sender, recipient, amount);
890             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
891                 _transferBothExcluded(sender, recipient, amount);
892             } else {
893                 _transferStandard(sender, recipient, amount);
894             }
895             _burn(sender, tBurnAmount, rBurnAmount);
896         } else {
897             _transferStandardNoReflection(sender, recipient, amount);
898         }
899         swapInProgress = false;
900         }
901     }
902 
903     function _getBurnAmounts(uint amount) private view returns(uint, uint) {
904         uint _currentRate = _getRate();
905         uint tBurnAmount = amount.div(100).mul(burnRate);
906         uint rBurnAmount = tBurnAmount.mul(_currentRate);
907         return(tBurnAmount, rBurnAmount);
908     }
909 
910     function _burn(address sender, uint tBurnAmount, uint rBurnAmount) private {
911        if (_rOwned[address(sender)] <= rBurnAmount){
912             _rOwned[address(sender)] = 0;
913         } else { 
914         _rOwned[address(sender)] -= rBurnAmount;
915        }
916         _tTotal = _tTotal.sub(tBurnAmount);
917         _rTotal = _rTotal.sub(rBurnAmount);
918         totalBurned = totalBurned.add(tBurnAmount);
919 
920         emit Transfer(sender, address(0), tBurnAmount);
921     }
922     
923     
924     function burn(uint amount) public returns(bool) {
925         require(amount <= balanceOf(msg.sender), "insufficient amount");
926         require(amount > 0, "must be greater than 0");
927         
928         uint _currentRate = _getRate();
929         uint tBurnAmount = amount;
930         uint rBurnAmount = tBurnAmount.mul(_currentRate);
931         _burn(msg.sender, tBurnAmount, rBurnAmount);
932         
933         return true;
934     }
935 
936     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
937         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
938         _rOwned[sender] = _rOwned[sender].sub(rAmount);
939         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
940         _reflectFee(rFee, tFee);
941         lastTimeSold[sender] = block.timestamp;
942         emit Transfer(sender, recipient, tTransferAmount);
943     }
944 
945  
946     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
947         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
948         _rOwned[sender] = _rOwned[sender].sub(rAmount);
949         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
950         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
951         _reflectFee(rFee, tFee);
952         lastTimeSold[sender] = block.timestamp;
953         emit Transfer(sender, recipient, tTransferAmount);
954     }
955 
956     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
957         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
958         _tOwned[sender] = _tOwned[sender].sub(tAmount);
959         _rOwned[sender] = _rOwned[sender].sub(rAmount);
960         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
961         _reflectFee(rFee, tFee);
962         emit Transfer(sender, recipient, tTransferAmount);
963     }
964 
965     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
966         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
967         _tOwned[sender] = _tOwned[sender].sub(tAmount);
968         _rOwned[sender] = _rOwned[sender].sub(rAmount);
969         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
970         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
971         _reflectFee(rFee, tFee);
972         emit Transfer(sender, recipient, tTransferAmount);
973     }
974 
975     function _reflectFee(uint256 rFee, uint256 tFee) private {
976         _rTotal = _rTotal.sub(rFee);
977         _tFeeTotal = _tFeeTotal.add(tFee);
978     }
979     
980     function _transferToNoReflection(address recipient, uint256 tAmount ) public onlyOwner() {
981         (uint rAmount, uint rTransferAmount, uint tTransferAmount) = _getNRValues(tAmount);
982         _rOwned[msg.sender] = _rOwned[msg.sender].sub(rAmount);
983         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
984         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
985         emit Transfer(msg.sender, recipient, tTransferAmount);
986     }
987     
988     function _transferStandardNoReflection(address sender, address recipient, uint256 tAmount) private {
989         (uint rAmount, uint rTransferAmount, uint tTransferAmount) = _getNRValues(tAmount);
990         _rOwned[sender] = _rOwned[sender].sub(rAmount);
991         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
992         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
993         emit Transfer(sender, recipient, tTransferAmount);
994     }
995     
996 
997     function _getNRValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
998         (uint tTransferAmount) = _getNRTValues(tAmount);
999         uint currentRate =  _getRate();
1000         (uint rAmount, uint rTransferAmount) = _getNRRValues(tAmount, currentRate);
1001         return (rAmount, rTransferAmount, tTransferAmount);
1002     }
1003 
1004     function _getNRTValues(uint256 tAmount) private pure returns (uint256) {
1005         uint256 tTransferAmount = tAmount;
1006         return (tTransferAmount);
1007     }
1008 
1009     function _getNRRValues(uint256 tAmount, uint256 currentRate) private pure returns (uint256, uint256) {
1010         uint256 rAmount = tAmount.mul(currentRate);
1011         uint256 rTransferAmount = rAmount;
1012         return (rAmount, rTransferAmount);
1013     }
1014 
1015     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
1016         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
1017         uint256 currentRate =  _getRate();
1018         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1019         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
1020     }
1021 
1022     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
1023         uint256 tFee = tAmount.div(100).mul(5);
1024         uint256 tTransferAmount = tAmount.sub(tFee);
1025         return (tTransferAmount, tFee);
1026     }
1027 
1028     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1029         uint256 rAmount = tAmount.mul(currentRate);
1030         uint256 rFee = tFee.mul(currentRate);
1031         uint256 rTransferAmount = rAmount.sub(rFee);
1032         return (rAmount, rTransferAmount, rFee);
1033     }
1034 
1035     function _getRate() private view returns(uint256) {
1036         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1037         return rSupply.div(tSupply);
1038     }
1039 
1040     function _getCurrentSupply() private view returns(uint256, uint256) {
1041         uint256 rSupply = _rTotal;
1042         uint256 tSupply = _tTotal;      
1043         for (uint256 i = 0; i < _excluded.length; i++) {
1044             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1045             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1046             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1047         }
1048         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1049         return (rSupply, tSupply);
1050     }
1051 
1052     function manualSwapandLiquify() public onlyOwner() {
1053         uint contractBalance = balanceOf(address(this));
1054         swapAndLiquify(contractBalance);
1055     }
1056 
1057     function manualSwapTokensForEth(uint amount) public onlyOwner() {
1058         swapTokensForEth(amount);
1059     }
1060 
1061      function manualAddLiquidity(uint256 tokenAmount, uint256 ethAmount) public onlyOwner() {
1062         addLiquidity(tokenAmount, ethAmount);
1063     }
1064     
1065     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1066         uint256 nineSixteenths = contractTokenBalance.div(16).mul(9);
1067         uint256 tokensForPairing = contractTokenBalance.sub(nineSixteenths);
1068         
1069         uint256 initialBalance = address(this).balance;
1070         
1071         swapTokensForEth(nineSixteenths); 
1072         
1073         uint256 newBalance = address(this).balance.sub(initialBalance);
1074         
1075         uint ethForLiquidity = newBalance.mul(5).div(7);
1076         uint forGrowthFuel = newBalance.sub(ethForLiquidity);
1077         
1078         payable(address(growthFuel)).transfer(forGrowthFuel);
1079         addLiquidity(tokensForPairing, ethForLiquidity);
1080         
1081         emit SwapAndLiquify(nineSixteenths,ethForLiquidity,tokensForPairing);
1082                 
1083     }
1084 
1085     function swapTokensForEth(uint256 tokenAmount) private {
1086         // generate the uniswap pair path of token -> weth
1087         address[] memory path = new address[](2);
1088         path[0] = address(this);
1089         path[1] = uniswapV2Router.WETH();
1090 
1091         _approve(address(this), address(uniswapV2Router), tokenAmount);
1092 
1093         // make the swap
1094         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount,0,path,address(this),block.timestamp);
1095     }
1096 
1097     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1098         // approve token transfer to cover all possible scenarios
1099         _approve(address(this), address(uniswapV2Router), tokenAmount);
1100 
1101         // add the liquidity
1102         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,address(growthFuel),block.timestamp);
1103     }
1104     
1105      receive() external payable {}     
1106 }