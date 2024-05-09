1 //─██████████████─██████──██████─████████████████───██████████████─
2 //─██░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─
3 //─██░░██████░░██─██░░██──██░░██─██░░████████░░██───██░░██████░░██─
4 //─██░░██──██░░██─██░░██──██░░██─██░░██────██░░██───██░░██──██░░██─
5 //─██░░██████░░██─██░░██──██░░██─██░░████████░░██───██░░██████░░██─
6 //─██░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─
7 //─██░░██████░░██─██░░██──██░░██─██░░██████░░████───██░░██████░░██─
8 //─██░░██──██░░██─██░░██──██░░██─██░░██──██░░██─────██░░██──██░░██─
9 //─██░░██──██░░██─██░░██████░░██─██░░██──██░░██████─██░░██──██░░██─
10 //─██░░██──██░░██─██░░░░░░░░░░██─██░░██──██░░░░░░██─██░░██──██░░██─
11 //─██████──██████─██████████████─██████──██████████─██████──██████─
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.6.0;
16 
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with GSN meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal virtual view returns (address payable) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal virtual view returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount)
60         external
61         returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender)
71         external
72         view
73         returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address sender,
102         address recipient,
103         uint256 amount
104     ) external returns (bool);
105 
106     /**
107      * @dev Emitted when `value` tokens are moved from one account (`from`) to
108      * another (`to`).
109      *
110      * Note that `value` may be zero.
111      */
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     /**
115      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
116      * a call to {approve}. `value` is the new allowance.
117      */
118     event Approval(
119         address indexed owner,
120         address indexed spender,
121         uint256 value
122     );
123 }
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      *
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, "SafeMath: subtraction overflow");
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         require(b <= a, errorMessage);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203         // benefit is lost if 'b' is also tested.
204         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
205         if (a == 0) {
206             return 0;
207         }
208 
209         uint256 c = a * b;
210         require(c / a == b, "SafeMath: multiplication overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b) internal pure returns (uint256) {
228         return div(a, b, "SafeMath: division by zero");
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         require(b > 0, errorMessage);
249         uint256 c = a / b;
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         return mod(a, b, "SafeMath: modulo by zero");
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts with custom message when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         require(b != 0, errorMessage);
289         return a % b;
290     }
291 }
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
316         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
317         // for accounts without code, i.e. `keccak256('')`
318         bytes32 codehash;
319 
320 
321             bytes32 accountHash
322          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
323         // solhint-disable-next-line no-inline-assembly
324         assembly {
325             codehash := extcodehash(account)
326         }
327         return (codehash != accountHash && codehash != 0x0);
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(
348             address(this).balance >= amount,
349             "Address: insufficient balance"
350         );
351 
352         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
353         (bool success, ) = recipient.call{value: amount}("");
354         require(
355             success,
356             "Address: unable to send value, recipient may have reverted"
357         );
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain`call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data)
379         internal
380         returns (bytes memory)
381     {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return _functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return
416             functionCallWithValue(
417                 target,
418                 data,
419                 value,
420                 "Address: low-level call with value failed"
421             );
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(
437             address(this).balance >= value,
438             "Address: insufficient balance for call"
439         );
440         return _functionCallWithValue(target, data, value, errorMessage);
441     }
442 
443     function _functionCallWithValue(
444         address target,
445         bytes memory data,
446         uint256 weiValue,
447         string memory errorMessage
448     ) private returns (bytes memory) {
449         require(isContract(target), "Address: call to non-contract");
450 
451         // solhint-disable-next-line avoid-low-level-calls
452         (bool success, bytes memory returndata) = target.call{value: weiValue}(
453             data
454         );
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
474 /**
475  * @dev Contract module which provides a basic access control mechanism, where
476  * there is an account (an owner) that can be granted exclusive access to
477  * specific functions.
478  *
479  * By default, the owner account will be the one that deploys the contract. This
480  * can later be changed with {transferOwnership}.
481  *
482  * This module is used through inheritance. It will make available the modifier
483  * `onlyOwner`, which can be applied to your functions to restrict their use to
484  * the owner.
485  */
486 contract Ownable is Context {
487     address private _owner;
488 
489     event OwnershipTransferred(
490         address indexed previousOwner,
491         address indexed newOwner
492     );
493 
494     /**
495      * @dev Initializes the contract setting the deployer as the initial owner.
496      */
497     constructor() internal {
498         address msgSender = _msgSender();
499         _owner = msgSender;
500         emit OwnershipTransferred(address(0), msgSender);
501     }
502 
503     /**
504      * @dev Returns the address of the current owner.
505      */
506     function owner() public view returns (address) {
507         return _owner;
508     }
509 
510     /**
511      * @dev Throws if called by any account other than the owner.
512      */
513     modifier onlyOwner() {
514         require(_owner == _msgSender(), "Ownable: caller is not the owner");
515         _;
516     }
517 
518     /**
519      * @dev Leaves the contract without owner. It will not be possible to call
520      * `onlyOwner` functions anymore. Can only be called by the current owner.
521      *
522      * NOTE: Renouncing ownership will leave the contract without an owner,
523      * thereby removing any functionality that is only available to the owner.
524      */
525     function renounceOwnership() public virtual onlyOwner {
526         emit OwnershipTransferred(_owner, address(0));
527         _owner = address(0);
528     }
529 
530     /**
531      * @dev Transfers ownership of the contract to a new account (`newOwner`).
532      * Can only be called by the current owner.
533      */
534     function transferOwnership(address newOwner) public virtual onlyOwner {
535         require(
536             newOwner != address(0),
537             "Ownable: new owner is the zero address"
538         );
539         emit OwnershipTransferred(_owner, newOwner);
540         _owner = newOwner;
541     }
542 }
543 
544 interface IUniswapV2Factory {
545     function createPair(address tokenA, address tokenB) external returns (address pair);
546 }
547 
548 interface IUniswapV2Pair {
549     function sync() external;
550 }
551 
552 interface IUniswapV2Router01 {
553     function factory() external pure returns (address);
554     function WETH() external pure returns (address);
555     function addLiquidity(
556         address tokenA,
557         address tokenB,
558         uint amountADesired,
559         uint amountBDesired,
560         uint amountAMin,
561         uint amountBMin,
562         address to,
563         uint deadline
564     ) external returns (uint amountA, uint amountB, uint liquidity);
565     function addLiquidityETH(
566         address token,
567         uint amountTokenDesired,
568         uint amountTokenMin,
569         uint amountETHMin,
570         address to,
571         uint deadline
572     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
573 }
574 
575 interface IUniswapV2Router02 is IUniswapV2Router01 {
576     function removeLiquidityETHSupportingFeeOnTransferTokens(
577       address token,
578       uint liquidity,
579       uint amountTokenMin,
580       uint amountETHMin,
581       address to,
582       uint deadline
583     ) external returns (uint amountETH);
584     function swapExactTokensForETHSupportingFeeOnTransferTokens(
585         uint amountIn,
586         uint amountOutMin,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external;
591     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
592         uint amountIn,
593         uint amountOutMin,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external;
598     function swapExactETHForTokensSupportingFeeOnTransferTokens(
599         uint amountOutMin,
600         address[] calldata path,
601         address to,
602         uint deadline
603     ) external payable;
604 }
605 
606 contract Balancer {
607     constructor() public {
608     }
609 }
610 
611 contract AURA is Context, IERC20, Ownable {
612     using SafeMath for uint256;
613     using Address for address;
614 
615     string private _name = "Aura Protocol";
616     string private _symbol = "AURA";
617     uint8 private _decimals = 9;
618 
619     mapping(address => uint256) internal _reflectionBalance;
620     mapping(address => uint256) internal _tokenBalance;
621     mapping(address => mapping(address => uint256)) internal _allowances;
622 
623     uint256 private constant MAX = ~uint256(0);
624     uint256 internal _tokenTotal = 20_000e9;
625     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
626 
627     mapping(address => bool) isExcludedFromFee;
628     mapping(address => bool) internal _isExcluded;
629     address[] internal _excluded;
630     
631     //@dev The tax fee contains two decimal places so 250 = 2.5%
632     uint256 public _feeDecimal = 2;
633     uint256 public _taxFee = 250;
634     uint256 public _liquidityFee = 250;
635 
636     uint256 public _rebalanceCallerFee = 500;
637 
638     uint256 public _taxFeeTotal;
639     uint256 public _burnFeeTotal;
640     uint256 public _liquidityFeeTotal;
641 
642     bool public tradingEnabled = false;
643     bool private inSwapAndLiquify;
644     bool public swapAndLiquifyEnabled = true;
645     bool public rebalanceEnalbed = true;
646     
647     uint256 public minTokensBeforeSwap = 100;
648     uint256 public minEthBeforeSwap = 100;
649     
650     uint256 public liquidityAddedAt;
651 
652     uint256 public lastRebalance = now ;
653     uint256 public rebalanceInterval = 30 minutes;
654     
655     IUniswapV2Router02 public  uniswapV2Router;
656     address public  uniswapV2Pair;
657     address public balancer;
658     
659     event TradingEnabled(bool enabled);
660     event RewardsDistributed(uint256 amount);
661     event SwapAndLiquifyEnabledUpdated(bool enabled);
662     event SwapedTokenForEth(uint256 EthAmount, uint256 TokenAmount);
663     event SwapedEthForTokens(uint256 EthAmount, uint256 TokenAmount, uint256 CallerReward, uint256 AmountBurned);
664 
665     modifier lockTheSwap {
666         inSwapAndLiquify = true;
667         _;
668         inSwapAndLiquify = false;
669     }
670 
671     constructor() public {
672         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
673          //@dev Create a uniswap pair for this new token
674         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
675             .createPair(address(this), _uniswapV2Router.WETH());
676             
677         uniswapV2Router = _uniswapV2Router;
678         
679         balancer = address(new Balancer());
680         
681         isExcludedFromFee[_msgSender()] = true;
682         isExcludedFromFee[address(this)] = true;
683         
684         //@dev Exclude uniswapV2Pair from taking rewards
685         _isExcluded[uniswapV2Pair] = true;
686         _excluded.push(uniswapV2Pair);
687         
688         _reflectionBalance[_msgSender()] = _reflectionTotal;
689         emit Transfer(address(0), _msgSender(), _tokenTotal);
690     }
691 
692     function name() public view returns (string memory) {
693         return _name;
694     }
695 
696     function symbol() public view returns (string memory) {
697         return _symbol;
698     }
699 
700     function decimals() public view returns (uint8) {
701         return _decimals;
702     }
703 
704     function totalSupply() public override view returns (uint256) {
705         return _tokenTotal;
706     }
707 
708     function balanceOf(address account) public override view returns (uint256) {
709         if (_isExcluded[account]) return _tokenBalance[account];
710         return tokenFromReflection(_reflectionBalance[account]);
711     }
712 
713     function transfer(address recipient, uint256 amount)
714         public
715         override
716         virtual
717         returns (bool)
718     {
719        _transfer(_msgSender(),recipient,amount);
720         return true;
721     }
722 
723     function allowance(address owner, address spender)
724         public
725         override
726         view
727         returns (uint256)
728     {
729         return _allowances[owner][spender];
730     }
731 
732     function approve(address spender, uint256 amount)
733         public
734         override
735         returns (bool)
736     {
737         _approve(_msgSender(), spender, amount);
738         return true;
739     }
740 
741     function transferFrom(
742         address sender,
743         address recipient,
744         uint256 amount
745     ) public override virtual returns (bool) {
746         _transfer(sender,recipient,amount);
747                
748         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub( amount,"ERC20: transfer amount exceeds allowance"));
749         return true;
750     }
751 
752     function increaseAllowance(address spender, uint256 addedValue)
753         public
754         virtual
755         returns (bool)
756     {
757         _approve(
758             _msgSender(),
759             spender,
760             _allowances[_msgSender()][spender].add(addedValue)
761         );
762         return true;
763     }
764 
765     function decreaseAllowance(address spender, uint256 subtractedValue)
766         public
767         virtual
768         returns (bool)
769     {
770         _approve(
771             _msgSender(),
772             spender,
773             _allowances[_msgSender()][spender].sub(
774                 subtractedValue,
775                 "ERC20: decreased allowance below zero"
776             )
777         );
778         return true;
779     }
780 
781     function isExcluded(address account) public view returns (bool) {
782         return _isExcluded[account];
783     }
784 
785     function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee)
786         public
787         view
788         returns (uint256)
789     {
790         require(tokenAmount <= _tokenTotal, "Amount must be less than supply");
791         if (!deductTransferFee) {
792             return tokenAmount.mul(_getReflectionRate());
793         } else {
794             return
795                 tokenAmount.sub(tokenAmount.mul(_taxFee).div(10** _feeDecimal + 2)).mul(
796                     _getReflectionRate()
797                 );
798         }
799     }
800 
801     function tokenFromReflection(uint256 reflectionAmount)
802         public
803         view
804         returns (uint256)
805     {
806         require(
807             reflectionAmount <= _reflectionTotal,
808             "Amount must be less than total reflections"
809         );
810         uint256 currentRate = _getReflectionRate();
811         return reflectionAmount.div(currentRate);
812     }
813 
814     function excludeAccount(address account) external onlyOwner() {
815         require(
816             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
817             "AURA: Uniswap router cannot be excluded."
818         );
819         require(account != address(this), 'AURA: The contract it self cannot be excluded');
820         require(!_isExcluded[account], "AURA: Account is already excluded");
821         if (_reflectionBalance[account] > 0) {
822             _tokenBalance[account] = tokenFromReflection(
823                 _reflectionBalance[account]
824             );
825         }
826         _isExcluded[account] = true;
827         _excluded.push(account);
828     }
829 
830     function includeAccount(address account) external onlyOwner() {
831         require(_isExcluded[account], "AURA: Account is already included");
832         for (uint256 i = 0; i < _excluded.length; i++) {
833             if (_excluded[i] == account) {
834                 _excluded[i] = _excluded[_excluded.length - 1];
835                 _tokenBalance[account] = 0;
836                 _isExcluded[account] = false;
837                 _excluded.pop();
838                 break;
839             }
840         }
841     }
842 
843     function _approve(
844         address owner,
845         address spender,
846         uint256 amount
847     ) private {
848         require(owner != address(0), "ERC20: approve from the zero address");
849         require(spender != address(0), "ERC20: approve to the zero address");
850 
851         _allowances[owner][spender] = amount;
852         emit Approval(owner, spender, amount);
853     }
854 
855     function _transfer(
856         address sender,
857         address recipient,
858         uint256 amount
859     ) private {
860         require(sender != address(0), "ERC20: transfer from the zero address");
861         require(recipient != address(0), "ERC20: transfer to the zero address");
862         require(amount > 0, "Transfer amount must be greater than zero");
863         require(tradingEnabled || sender == owner() || recipient == owner() ||
864                 isExcludedFromFee[sender] || isExcludedFromFee[recipient], "Trading is locked before presale.");
865         
866         //@dev Limit the transfer to 600 tokens for first 5 minutes
867         require(now > liquidityAddedAt + 6 minutes  || amount <= 600e9, "You cannot transfer more than 600 tokens.");
868         
869         //@dev Don't swap or buy tokens when uniswapV2Pair is sender, to avoid circular loop
870         if(!inSwapAndLiquify && sender != uniswapV2Pair) {
871             bool swap = true;
872             uint256 contractBalance = address(this).balance;
873             //@dev Buy tokens
874             if(now > lastRebalance + rebalanceInterval 
875                 && rebalanceEnalbed 
876                 && contractBalance >= minEthBeforeSwap){
877                 buyAndBurnToken(contractBalance);
878                 swap = false;
879             }
880             //@dev Buy eth
881             if(swap) {
882                 uint256 contractTokenBalance = balanceOf(address(this));
883                 bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
884                  if (overMinTokenBalance && swapAndLiquifyEnabled) {
885                     swapTokensForEth();    
886                 }
887            }
888         }
889         
890         uint256 transferAmount = amount;
891         uint256 rate = _getReflectionRate();
892 
893         if(!isExcludedFromFee[sender] && !isExcludedFromFee[recipient] && !inSwapAndLiquify){
894             transferAmount = collectFee(sender,amount,rate);
895         }
896 
897         //@dev Transfer reflection
898         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
899         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
900 
901         //@dev If any account belongs to the excludedAccount transfer token
902         if (_isExcluded[sender]) {
903             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
904         }
905         if (_isExcluded[recipient]) {
906             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
907         }
908 
909         emit Transfer(sender, recipient, transferAmount);
910     }
911     
912     function collectFee(address account, uint256 amount, uint256 rate) private returns (uint256) {
913         uint256 transferAmount = amount;
914         
915         //@dev Tax fee
916         if(_taxFee != 0){
917             uint256 taxFee = amount.mul(_taxFee).div(10**(_feeDecimal + 2));
918             transferAmount = transferAmount.sub(taxFee);
919             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
920             _taxFeeTotal = _taxFeeTotal.add(taxFee);
921             emit RewardsDistributed(taxFee);
922         }
923 
924         //@dev Take liquidity fee
925         if(_liquidityFee != 0){
926             uint256 liquidityFee = amount.mul(_liquidityFee).div(10**(_feeDecimal + 2));
927             transferAmount = transferAmount.sub(liquidityFee);
928             _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(liquidityFee.mul(rate));
929             _liquidityFeeTotal = _liquidityFeeTotal.add(liquidityFee);
930             emit Transfer(account,address(this),liquidityFee);
931         }
932         
933         return transferAmount;
934     }
935 
936     function _getReflectionRate() private view returns (uint256) {
937         uint256 reflectionSupply = _reflectionTotal;
938         uint256 tokenSupply = _tokenTotal;
939         for (uint256 i = 0; i < _excluded.length; i++) {
940             if (
941                 _reflectionBalance[_excluded[i]] > reflectionSupply ||
942                 _tokenBalance[_excluded[i]] > tokenSupply
943             ) return _reflectionTotal.div(_tokenTotal);
944             reflectionSupply = reflectionSupply.sub(
945                 _reflectionBalance[_excluded[i]]
946             );
947             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
948         }
949         if (reflectionSupply < _reflectionTotal.div(_tokenTotal))
950             return _reflectionTotal.div(_tokenTotal);
951         return reflectionSupply.div(tokenSupply);
952     }
953 
954     function swapTokensForEth() private lockTheSwap {
955         uint256 tokenAmount = balanceOf(address(this));
956         uint256 ethAmount = address(this).balance;
957         
958         //@dev Generate the uniswap pair path of token -> weth
959         address[] memory path = new address[](2);
960         path[0] = address(this);
961         path[1] = uniswapV2Router.WETH();
962 
963         _approve(address(this), address(uniswapV2Router), tokenAmount);
964 
965         //@dev Make the swap
966         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
967             tokenAmount,
968             0, // accept any amount of ETH
969             path,
970             address(this),
971             block.timestamp
972         );
973         
974         ethAmount = address(this).balance.sub(ethAmount);
975         emit SwapedTokenForEth(tokenAmount,ethAmount);
976     }
977     
978     function swapEthForTokens(uint256 EthAmount) private {
979         address[] memory path = new address[](2);
980         path[0] = uniswapV2Router.WETH();
981         path[1] = address(this);
982 
983         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
984                 0,
985                 path,
986                 address(balancer),
987                 block.timestamp
988             );
989     }
990    
991     function buyAndBurnToken(uint256 contractBalance) private lockTheSwap {
992         lastRebalance = now;
993         
994         //@dev Uniswap doesn't allow for a token to by itself, so we have to use an external account, which in this case is called the balancer
995         swapEthForTokens(contractBalance);
996 
997         //@dev How much tokens we swaped into
998         uint256 swapedTokens = balanceOf(address(balancer));
999         uint256 rewardForCaller = swapedTokens.mul(_rebalanceCallerFee).div(10**(_feeDecimal + 2));
1000         uint256 amountToBurn = swapedTokens.sub(rewardForCaller);
1001         
1002         uint256 rate =  _getReflectionRate();
1003 
1004         _reflectionBalance[tx.origin] = _reflectionBalance[tx.origin].add(rewardForCaller.mul(rate));
1005         _reflectionBalance[address(balancer)] = 0;
1006         
1007         _burnFeeTotal = _burnFeeTotal.add(amountToBurn);
1008         _tokenTotal = _tokenTotal.sub(amountToBurn);
1009         _reflectionTotal = _reflectionTotal.sub(amountToBurn.mul(rate));
1010 
1011         emit Transfer(address(balancer), tx.origin, rewardForCaller);
1012         emit Transfer(address(balancer), address(0), amountToBurn);
1013         emit SwapedEthForTokens(contractBalance, swapedTokens, rewardForCaller, amountToBurn);
1014     }
1015     
1016     function setExcludedFromFee(address account, bool excluded) public onlyOwner {
1017         isExcludedFromFee[account] = excluded;
1018     }
1019     
1020     function setSwapAndLiquifyEnabled(bool enabled) public onlyOwner {
1021         swapAndLiquifyEnabled = enabled;
1022         SwapAndLiquifyEnabledUpdated(enabled);
1023     }
1024     
1025     function setTaxFee(uint256 fee) public onlyOwner {
1026         _taxFee = fee;
1027     }
1028     
1029     function setLiquidityFee(uint256 fee) public onlyOwner {
1030         _liquidityFee = fee;
1031     }
1032     
1033     function setRebalanceCallerFee(uint256 fee) public onlyOwner {
1034         _rebalanceCallerFee = fee;
1035     }
1036     
1037     function setMinTokensBeforeSwap(uint256 amount) public onlyOwner {
1038         minTokensBeforeSwap = amount;
1039     }
1040     
1041     function setMinEthBeforeSwap(uint256 amount) public onlyOwner {
1042         minEthBeforeSwap = amount;
1043     }
1044     
1045     function setRebalanceInterval(uint256 interval) public onlyOwner {
1046         rebalanceInterval = interval;
1047     }
1048     
1049     function setRebalanceEnabled(bool enabled) public onlyOwner {
1050         rebalanceEnalbed = enabled;
1051     }
1052     
1053     function enableTrading() external onlyOwner() {
1054         tradingEnabled = true;
1055         TradingEnabled(true);
1056         liquidityAddedAt = now;
1057     }
1058     
1059     receive() external payable {}
1060 }