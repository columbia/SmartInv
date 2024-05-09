1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-19
3 */
4 
5 pragma solidity ^0.8.12;
6 // SPDX-License-Identifier: Unlicensed
7 interface IERC20 {
8 
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 
78 library SafeMathInt {
79     int256 private constant MIN_INT256 = int256(1) << 255;
80     int256 private constant MAX_INT256 = ~(int256(1) << 255);
81 
82     function mul(int256 a, int256 b) internal pure returns (int256) {
83         int256 c = a * b;
84         // Detect overflow when multiplying MIN_INT256 with -1
85         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
86         require((b == 0) || (c / b == a));
87         return c;
88     }
89 
90     function div(int256 a, int256 b) internal pure returns (int256) {
91         // Prevent overflow when dividing MIN_INT256 by -1
92         require(b != - 1 || a != MIN_INT256);
93         // Solidity already throws when dividing by 0.
94         return a / b;
95     }
96 
97     function sub(int256 a, int256 b) internal pure returns (int256) {
98         int256 c = a - b;
99         require((b >= 0 && c <= a) || (b < 0 && c > a));
100         return c;
101     }
102 
103     function add(int256 a, int256 b) internal pure returns (int256) {
104         int256 c = a + b;
105         require((b >= 0 && c >= a) || (b < 0 && c < a));
106         return c;
107     }
108 
109     function abs(int256 a) internal pure returns (int256) {
110         require(a != MIN_INT256);
111         return a < 0 ? - a : a;
112     }
113 
114     function toUint256Safe(int256 a) internal pure returns (uint256) {
115         require(a >= 0);
116         return uint256(a);
117     }
118 }
119 
120 library SafeMathUint {
121     function toInt256Safe(uint256 a) internal pure returns (int256) {
122         int256 b = int256(a);
123         require(b >= 0);
124         return b;
125     }
126 }
127 /**
128  * @dev Wrappers over Solidity's arithmetic operations with added overflow
129  * checks.
130  *
131  * Arithmetic operations in Solidity wrap on overflow. This can easily result
132  * in bugs, because programmers usually assume that an overflow raises an
133  * error, which is the standard behavior in high level programming languages.
134  * `SafeMath` restores this intuition by reverting the transaction when an
135  * operation overflows.
136  *
137  * Using this library instead of the unchecked operations eliminates an entire
138  * class of bugs, so it's recommended to use it always.
139  */
140 
141 library SafeMath {
142     /**
143      * @dev Returns the addition of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `+` operator.
147      *
148      * Requirements:
149      *
150      * - Addition cannot overflow.
151      */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a, "SafeMath: addition overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, "SafeMath: subtraction overflow");
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b <= a, errorMessage);
185         uint256 c = a - b;
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the multiplication of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `*` operator.
195      *
196      * Requirements:
197      *
198      * - Multiplication cannot overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
202         // benefit is lost if 'b' is also tested.
203         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
204         if (a == 0) {
205             return 0;
206         }
207 
208         uint256 c = a * b;
209         require(c / a == b, "SafeMath: multiplication overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         return div(a, b, "SafeMath: division by zero");
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator. Note: this function uses a
235      * `revert` opcode (which leaves remaining gas untouched) while Solidity
236      * uses an invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b > 0, errorMessage);
244         uint256 c = a / b;
245         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         return mod(a, b, "SafeMath: modulo by zero");
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * Reverts with custom message when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b != 0, errorMessage);
280         return a % b;
281     }
282 }
283 
284 abstract contract Context {
285     //function _msgSender() internal view virtual returns (address payable) {
286     function _msgSender() internal view virtual returns (address) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view virtual returns (bytes memory) {
291         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
292         return msg.data;
293     }
294 }
295 
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
320         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
321         // for accounts without code, i.e. `keccak256('')`
322         bytes32 codehash;
323         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { codehash := extcodehash(account) }
326         return (codehash != accountHash && codehash != 0x0);
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{ value: amount }("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain`call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         return _functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         return _functionCallWithValue(target, data, value, errorMessage);
409     }
410 
411     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
412         require(isContract(target), "Address: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 // solhint-disable-next-line no-inline-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 /**
436  * @dev Contract module which provides a basic access control mechanism, where
437  * there is an account (an owner) that can be granted exclusive access to
438  * specific functions.
439  *
440  * By default, the owner account will be the one that deploys the contract. This
441  * can later be changed with {transferOwnership}.
442  *
443  * This module is used through inheritance. It will make available the modifier
444  * `onlyOwner`, which can be applied to your functions to restrict their use to
445  * the owner.
446  */
447 contract Ownable is Context {
448     address private _owner;
449 
450     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
451 
452     /**
453      * @dev Initializes the contract setting the deployer as the initial owner.
454      */
455     constructor () {
456         address msgSender = _msgSender();
457         _owner = msgSender;
458         emit OwnershipTransferred(address(0), msgSender);
459     }
460 
461     /**
462      * @dev Returns the address of the current owner.
463      */
464     function owner() public view returns (address) {
465         return _owner;
466     }
467 
468     /**
469      * @dev Throws if called by any account other than the owner.
470      */
471     modifier onlyOwner() {
472         require(_owner == _msgSender(), "Ownable: caller is not the owner");
473         _;
474     }
475 
476     /**
477     * @dev Leaves the contract without owner. It will not be possible to call
478     * `onlyOwner` functions anymore. Can only be called by the current owner.
479     *
480     * NOTE: Renouncing ownership will leave the contract without an owner,
481     * thereby removing any functionality that is only available to the owner.
482     */
483     function renounceOwnership() public virtual onlyOwner {
484         emit OwnershipTransferred(_owner, address(0));
485         _owner = address(0);
486     }
487 
488     /**
489      * @dev Transfers ownership of the contract to a new account (`newOwner`).
490      * Can only be called by the current owner.
491      */
492     function transferOwnership(address newOwner) public virtual onlyOwner {
493         require(newOwner != address(0), "Ownable: new owner is the zero address");
494         emit OwnershipTransferred(_owner, newOwner);
495         _owner = newOwner;
496     }
497 
498 }
499 
500 interface IUniswapV2Factory {
501     function createPair(address tokenA, address tokenB) external returns (address pair);
502 }
503 
504 interface IUniswapV2Router02 {
505     function swapExactTokensForETHSupportingFeeOnTransferTokens(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external;
512     function factory() external pure returns (address);
513     function WETH() external pure returns (address);
514     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
515 }
516 
517 contract MamaKong is Context, IERC20, Ownable {
518     using SafeMath for uint256;
519     using Address for address;
520 
521     event SwapAndLiquifyEnabledUpdated(bool enabled);
522     event SwapAndLiquify(
523         uint256 tokensSwapped,
524         uint256 ethReceived,
525         uint256 tokensIntoLiqudity
526     );
527 
528     modifier lockTheSwap {
529         inSwapAndLiquify = true;
530         _;
531         inSwapAndLiquify = false;
532     }
533     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
534     address public uniswapV2Pair = address(0);
535     mapping (address => uint256) private _rOwned;
536     mapping (address => uint256) private _tOwned;
537     mapping (address => mapping (address => uint256)) private _allowances;
538     mapping (address => bool) private botWallets;
539     mapping (address => bool) private _isExcludedFromFee;
540     mapping (address => bool) private _isExcludedFromRewards;
541     string private _name = "MAMA KONG";
542     string private _symbol = "MAMAK";
543     uint8 private _decimals = 9;
544     uint256 private constant MAX = ~uint256(0);
545     uint256 private _tTotal = 1000000000000 * 10** _decimals;
546     uint256 private _rTotal = (MAX - (MAX % _tTotal));
547     uint256 private _tFeeTotal;
548     bool inSwapAndLiquify;
549     bool public swapAndLiquifyEnabled = true;
550     bool isTaxFreeTransfer = false;
551     uint256 public _maxBuyAmount = 5000000000 * 10** _decimals;
552     uint256 public ethPriceToSwap = 200000000000000000; //.2 ETH
553     uint public ethSellAmount = 1000000000000000000;  //1 ETH
554     uint256 public _maxWalletAmount = 15000000000 * 10** _decimals;
555     address public buyBackAddress = 0xC00B6b4a2782F122878E953B769ABDc855c69313;
556     address public marketingAddress = 0x28534719Df28daea005D864FEE6C79117C37480B;
557     address public devAddress = 0x8811be15C1FdE25D4e4acA184e905104b66d49c8;
558     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
559     uint256 public gasForProcessing = 50000;
560     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic,uint256 gas, address indexed processor);
561     event SendDividends(uint256 EthAmount);
562 
563     struct Distribution {
564         uint256 devTeam;
565         uint256 marketing;
566         uint256 dividend;
567         uint256 buyBack;
568     }
569 
570     struct TaxFees {
571         uint256 reflectionBuyFee;
572         uint256 buyFee;
573         uint256 sellReflectionFee;
574         uint256 sellFee;
575         uint256 largeSellFee;
576     }
577 
578     bool private doTakeFees;
579     bool private isSellTxn;
580     TaxFees public taxFees;
581     Distribution public distribution;
582     DividendTracker private dividendTracker;
583 
584     constructor () {
585         _rOwned[_msgSender()] = _rTotal;
586         _isExcludedFromFee[owner()] = true;
587         _isExcludedFromFee[_msgSender()] = true;
588         _isExcludedFromFee[buyBackAddress] = true;
589         _isExcludedFromFee[marketingAddress] = true;
590         _isExcludedFromFee[devAddress] = true;
591         _isExcludedFromRewards[deadWallet] = true;
592         taxFees = TaxFees(0,10,0,10,15);
593         distribution = Distribution(50, 50, 0, 0);
594         emit Transfer(address(0), _msgSender(), _tTotal);
595     }
596 
597     function name() public view returns (string memory) {
598         return _name;
599     }
600 
601     function symbol() public view returns (string memory) {
602         return _symbol;
603     }
604 
605     function decimals() public view returns (uint8) {
606         return _decimals;
607     }
608 
609     function totalSupply() public view override returns (uint256) {
610         return _tTotal;
611     }
612 
613     function balanceOf(address account) public view override returns (uint256) {
614         return tokenFromReflection(_rOwned[account]);
615     }
616 
617     function transfer(address recipient, uint256 amount) public override returns (bool) {
618         _transfer(_msgSender(), recipient, amount);
619         return true;
620     }
621 
622     function allowance(address owner, address spender) public view override returns (uint256) {
623         return _allowances[owner][spender];
624     }
625 
626     function approve(address spender, uint256 amount) public override returns (bool) {
627         _approve(_msgSender(), spender, amount);
628         return true;
629     }
630 
631     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
632         _transfer(sender, recipient, amount);
633         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
634         return true;
635     }
636 
637     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
638         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
639         return true;
640     }
641 
642     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
643         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
644         return true;
645     }
646 
647     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
648         uint256 iterator = 0;
649         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
650         require(newholders.length == amounts.length, "Holders and amount length must be the same");
651         while(iterator < newholders.length){
652             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false);
653             iterator += 1;
654         }
655     }
656 
657     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
658         addRemoveFee(addresses, isExcludeFromFee);
659     }
660 
661     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
662         require(rAmount <= _rTotal, "Amount must be less than total reflections");
663         uint256 currentRate =  _getRate();
664         return rAmount.div(currentRate);
665     }
666 
667     function excludeIncludeFromRewards(address[] calldata addresses, bool isExcluded) public onlyOwner {
668         addRemoveRewards(addresses, isExcluded);
669     }
670 
671     function isExcludedFromRewards(address addr) public view returns(bool) {
672         return _isExcludedFromRewards[addr];
673     }
674 
675     function addRemoveRewards(address[] calldata addresses, bool flag) private {
676         for (uint256 i = 0; i < addresses.length; i++) {
677             address addr = addresses[i];
678             _isExcludedFromRewards[addr] = flag;
679         }
680     }
681 
682     function setEthLargeSellAmount(uint ethSellAmount_) external onlyOwner {
683         ethSellAmount = ethSellAmount_;
684     }
685 
686     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
687         ethPriceToSwap = ethPriceToSwap_;
688     }
689 
690     function createV2Pair() external onlyOwner {
691         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
692         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
693         _isExcludedFromRewards[uniswapV2Pair] = true;
694     }
695     
696     function addRemoveFee(address[] calldata addresses, bool flag) private {
697         for (uint256 i = 0; i < addresses.length; i++) {
698             address addr = addresses[i];
699             _isExcludedFromFee[addr] = flag;
700         }
701     }
702 
703     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
704         _maxBuyAmount = maxBuyAmount * 10**9;
705     }
706 
707     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
708         _maxWalletAmount = maxWalletAmount * 10**9;
709     }
710 
711     function setTaxFees(uint256 reflectionFee, uint256 liquidityFee, uint256 sellReflectionFee, uint256 sellLiquidityFee, uint256 superSellOffFee) external onlyOwner {
712         taxFees.reflectionBuyFee = reflectionFee;
713         taxFees.buyFee = liquidityFee;
714         taxFees.sellFee = sellLiquidityFee;
715         taxFees.sellReflectionFee = sellReflectionFee;
716         taxFees.largeSellFee = superSellOffFee;
717     }
718 
719     function setDistribution(uint256 dividend, uint256 devTeam, uint256 marketing, uint256 buyBack) external onlyOwner {
720         distribution.dividend = dividend;
721         distribution.devTeam = devTeam;
722         distribution.marketing = marketing;
723         distribution.buyBack = buyBack;
724     }
725 
726     function setWalletAddresses(address devAddr, address buyBack, address marketingAddr) external onlyOwner {
727         devAddress = devAddr;
728         buyBackAddress = buyBack;
729         marketingAddress = marketingAddr;
730     }
731 
732     function isAddressBlocked(address addr) public view returns (bool) {
733         return botWallets[addr];
734     }
735 
736     function blockAddresses(address[] memory addresses) external onlyOwner() {
737         blockUnblockAddress(addresses, true);
738     }
739 
740     function unblockAddresses(address[] memory addresses) external onlyOwner() {
741         blockUnblockAddress(addresses, false);
742     }
743 
744     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
745         for (uint256 i = 0; i < addresses.length; i++) {
746             address addr = addresses[i];
747             if(doBlock) {
748                 botWallets[addr] = true;
749             } else {
750                 delete botWallets[addr];
751             }
752         }
753     }
754 
755     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
756         swapAndLiquifyEnabled = _enabled;
757         emit SwapAndLiquifyEnabledUpdated(_enabled);
758     }
759 
760     receive() external payable {}
761 
762     function _reflectFee(uint256 rFee, uint256 tFee) private {
763         _rTotal = _rTotal.sub(rFee);
764         _tFeeTotal = _tFeeTotal.add(tFee);
765     }
766 
767     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
768         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
769         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
770         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
771     }
772 
773     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
774         uint256 tFee = calculateTaxFee(tAmount);
775         uint256 tLiquidity = calculateLiquidityFee(tAmount);
776         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
777         return (tTransferAmount, tFee, tLiquidity);
778     }
779 
780     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
781         uint256 rAmount = tAmount.mul(currentRate);
782         uint256 rFee = tFee.mul(currentRate);
783         uint256 rLiquidity = tLiquidity.mul(currentRate);
784         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
785         return (rAmount, rTransferAmount, rFee);
786     }
787 
788     function _getRate() private view returns(uint256) {
789         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
790         return rSupply.div(tSupply);
791     }
792 
793     function _getCurrentSupply() private view returns(uint256, uint256) {
794         uint256 rSupply = _rTotal;
795         uint256 tSupply = _tTotal;
796         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
797         return (rSupply, tSupply);
798     }
799 
800     function _takeLiquidity(uint256 tLiquidity) private {
801         uint256 currentRate =  _getRate();
802         uint256 rLiquidity = tLiquidity.mul(currentRate);
803         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
804     }
805 
806     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
807         uint256 reflectionFee = 0;
808         if(doTakeFees) {
809             reflectionFee = taxFees.reflectionBuyFee;
810             if(isSellTxn) {
811                 reflectionFee = taxFees.sellReflectionFee;
812             }
813         }
814         return _amount.mul(reflectionFee).div(10**2);
815     }
816 
817     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
818         uint256 totalLiquidityFee = 0;
819         if(doTakeFees) {
820             totalLiquidityFee = taxFees.buyFee;
821             if(isSellTxn) {
822                 totalLiquidityFee = taxFees.sellFee;
823                 uint ethPrice = getEthPrice(_amount);
824                 if(ethPrice >= ethSellAmount) {
825                     totalLiquidityFee = taxFees.largeSellFee;
826                 }
827             }
828         }
829         return _amount.mul(totalLiquidityFee).div(10**2);
830     }
831 
832     function getEthPrice(uint tokenAmount) public view returns (uint)  {
833         address[] memory path = new address[](2);
834         path[0] = address(this);
835         path[1] = uniswapV2Router.WETH();
836         return uniswapV2Router.getAmountsOut(tokenAmount, path)[1];
837     }
838 
839     function isExcludedFromFee(address account) public view returns(bool) {
840         return _isExcludedFromFee[account];
841     }
842 
843     function enableDisableTaxFreeTransfers(bool enableDisable) external onlyOwner {
844         isTaxFreeTransfer = enableDisable;
845     }
846 
847     function _approve(address owner, address spender, uint256 amount) private {
848         require(owner != address(0), "ERC20: approve from the zero address");
849         require(spender != address(0), "ERC20: approve to the zero address");
850 
851         _allowances[owner][spender] = amount;
852         emit Approval(owner, spender, amount);
853     }
854 
855     function _transfer(address from, address to, uint256 amount) private {
856         require(from != address(0), "ERC20: transfer from the zero address");
857         require(to != address(0), "ERC20: transfer to the zero address");
858         require(amount > 0, "Transfer amount must be greater than zero");
859         require(uniswapV2Pair != address(0),"UniswapV2Pair has not been set");
860         bool isSell = false;
861         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
862         uint256 holderBalance = balanceOf(to).add(amount);
863         //block the bots, but allow them to transfer to dead wallet if they are blocked
864         if(from != owner() && to != owner() && to != deadWallet) {
865             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
866         }
867         if(from == uniswapV2Pair) {
868             require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxTxAmount.");
869             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
870         }
871         if(from != uniswapV2Pair && to == uniswapV2Pair) { //if sell
872             //only tax if tokens are going back to Uniswap
873             isSell = true;
874             sellTaxTokens();
875         }
876         if(from != uniswapV2Pair && to != uniswapV2Pair) {
877             takeFees = isTaxFreeTransfer ? false : true;
878             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
879         }
880         _tokenTransfer(from, to, amount, takeFees, isSell, true);
881     }
882 
883     function sellTaxTokens() private {
884         uint256 contractTokenBalance = balanceOf(address(this));
885         if(contractTokenBalance > 0) {
886             uint ethPrice = getEthPrice(contractTokenBalance);
887             if (ethPrice >= ethPriceToSwap && !inSwapAndLiquify && swapAndLiquifyEnabled) {
888                 //send eth to wallets marketing and dev
889                 distributeShares(contractTokenBalance);
890             }
891         }
892     }
893 
894     function updateGasForProcessing(uint256 newValue) public onlyOwner {
895         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
896         gasForProcessing = newValue;
897     }
898 
899     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
900         swapTokensForEth(balanceToShareTokens);
901         uint256 distributionEth = address(this).balance;
902         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
903         uint256 dividendShare = distributionEth.mul(distribution.dividend).div(100);
904         uint256 devTeamShare = distributionEth.mul(distribution.devTeam).div(100);
905         uint256 buyBackShare = distributionEth.mul(distribution.buyBack).div(100);
906         if(marketingShare > 0){
907             payable(marketingAddress).transfer(marketingShare);
908         }
909         if(dividendShare > 0){
910             sendEthDividends(dividendShare);
911         }
912         if(devTeamShare > 0){
913             payable(devAddress).transfer(devTeamShare);
914         }
915         if(buyBackShare > 0){
916             payable(buyBackAddress).transfer(buyBackShare);
917         }
918 
919     }
920 
921     function setDividendTracker(address dividendContractAddress) external onlyOwner {
922         dividendTracker = DividendTracker(payable(dividendContractAddress));
923     }
924 
925     function sendEthDividends(uint256 dividends) private {
926         (bool success,) = address(dividendTracker).call{value : dividends}("");
927         if (success) {
928             emit SendDividends(dividends);
929         }
930     }
931 
932     function swapTokensForEth(uint256 tokenAmount) private {
933         // generate the uniswap pair path of token -> weth
934         address[] memory path = new address[](2);
935         path[0] = address(this);
936         path[1] = uniswapV2Router.WETH();
937         _approve(address(this), address(uniswapV2Router), tokenAmount);
938         // make the swap
939         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
940             tokenAmount,
941             0, // accept any amount of ETH
942             path,
943             address(this),
944             block.timestamp
945         );
946     }
947 
948     //this method is responsible for taking all fee, if takeFee is true
949     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFees, bool isSell, bool doUpdateDividends) private {
950         doTakeFees = takeFees;
951         isSellTxn = isSell;
952         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
953         _rOwned[sender] = _rOwned[sender].sub(rAmount);
954         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
955         _takeLiquidity(tLiquidity);
956         _reflectFee(rFee, tFee);
957         emit Transfer(sender, recipient, tTransferAmount);
958 
959         if(doUpdateDividends && distribution.dividend > 0) {
960             try dividendTracker.setTokenBalance(sender) {} catch{}
961             try dividendTracker.setTokenBalance(recipient) {} catch{}
962             try dividendTracker.process(gasForProcessing) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
963                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gasForProcessing, tx.origin);
964             }catch {}
965         }
966     }
967 }
968 
969 contract IterableMapping {
970     // Iterable mapping from address to uint;
971     struct Map {
972         address[] keys;
973         mapping(address => uint) values;
974         mapping(address => uint) indexOf;
975         mapping(address => bool) inserted;
976     }
977 
978     Map private map;
979 
980     function get(address key) public view returns (uint) {
981         return map.values[key];
982     }
983 
984     function keyExists(address key) public view returns(bool) {
985         return (getIndexOfKey(key) != -1);
986     }
987 
988     function getIndexOfKey(address key) public view returns (int) {
989         if (!map.inserted[key]) {
990             return - 1;
991         }
992         return int(map.indexOf[key]);
993     }
994 
995     function getKeyAtIndex(uint index) public view returns (address) {
996         return map.keys[index];
997     }
998 
999     function size() public view returns (uint) {
1000         return map.keys.length;
1001     }
1002 
1003     function set(address key, uint val) public {
1004         if (map.inserted[key]) {
1005             map.values[key] = val;
1006         } else {
1007             map.inserted[key] = true;
1008             map.values[key] = val;
1009             map.indexOf[key] = map.keys.length;
1010             map.keys.push(key);
1011         }
1012     }
1013 
1014     function remove(address key) public {
1015         if (!map.inserted[key]) {
1016             return;
1017         }
1018         delete map.inserted[key];
1019         delete map.values[key];
1020         uint index = map.indexOf[key];
1021         uint lastIndex = map.keys.length - 1;
1022         address lastKey = map.keys[lastIndex];
1023         map.indexOf[lastKey] = index;
1024         delete map.indexOf[key];
1025         map.keys[index] = lastKey;
1026         map.keys.pop();
1027     }
1028 }
1029 
1030 contract DividendTracker is IERC20, Context, Ownable {
1031     using SafeMath for uint256;
1032     using SafeMathUint for uint256;
1033     using SafeMathInt for int256;
1034     uint256 constant internal magnitude = 2 ** 128;
1035     uint256 internal magnifiedDividendPerShare;
1036     mapping(address => int256) internal magnifiedDividendCorrections;
1037     mapping(address => uint256) internal withdrawnDividends;
1038     mapping(address => uint256) internal claimedDividends;
1039     mapping(address => uint256) private _balances;
1040     mapping(address => mapping(address => uint256)) private _allowances;
1041     uint256 private _totalSupply;
1042     string private _name = "MAMA KONG TRACKER";
1043     string private _symbol = "MAMAKT";
1044     uint8 private _decimals = 9;
1045     uint256 public totalDividendsDistributed;
1046     IterableMapping private tokenHoldersMap = new IterableMapping();
1047     uint256 public minimumTokenBalanceForDividends = 5000000000 * 10 **  _decimals;
1048     MamaKong private mamKong;
1049     bool public doCalculation = false;
1050     event updateBalance(address addr, uint256 amount);
1051     event DividendsDistributed(address indexed from,uint256 weiAmount);
1052     event DividendWithdrawn(address indexed to,uint256 weiAmount);
1053 
1054     uint256 public lastProcessedIndex;
1055     mapping(address => uint256) public lastClaimTimes;
1056     uint256 public claimWait = 3600;
1057 
1058     event ExcludeFromDividends(address indexed account);
1059     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1060     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1061 
1062     constructor() {
1063         emit Transfer(address(0), _msgSender(), 0);
1064     }
1065 
1066     function name() public view returns (string memory) {
1067         return _name;
1068     }
1069 
1070     function symbol() public view returns (string memory) {
1071         return _symbol;
1072     }
1073 
1074     function decimals() public view returns (uint8) {
1075         return _decimals;
1076     }
1077 
1078     function totalSupply() public view override returns (uint256) {
1079         return _totalSupply;
1080     }
1081     function balanceOf(address account) public view virtual override returns (uint256) {
1082         return _balances[account];
1083     }
1084 
1085     function transfer(address, uint256) public pure returns (bool) {
1086         require(false, "No transfers allowed in dividend tracker");
1087         return true;
1088     }
1089 
1090     function transferFrom(address, address, uint256) public pure override returns (bool) {
1091         require(false, "No transfers allowed in dividend tracker");
1092         return true;
1093     }
1094 
1095     function allowance(address owner, address spender) public view override returns (uint256) {
1096         return _allowances[owner][spender];
1097     }
1098 
1099     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1100         _approve(_msgSender(), spender, amount);
1101         return true;
1102     }
1103 
1104     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1105         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1106         return true;
1107     }
1108 
1109     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1110         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1111         return true;
1112     }
1113 
1114     function _approve(address owner, address spender, uint256 amount) private {
1115         require(owner != address(0), "ERC20: approve from the zero address");
1116         require(spender != address(0), "ERC20: approve to the zero address");
1117 
1118         _allowances[owner][spender] = amount;
1119         emit Approval(owner, spender, amount);
1120     }
1121 
1122     function setTokenBalance(address account) external {
1123         uint256 balance = mamKong.balanceOf(account);
1124         if(!mamKong.isExcludedFromRewards(account)) {
1125             if (balance >= minimumTokenBalanceForDividends) {
1126                 _setBalance(account, balance);
1127                 tokenHoldersMap.set(account, balance);
1128             }
1129             else {
1130                 _setBalance(account, 0);
1131                 tokenHoldersMap.remove(account);
1132             }
1133         } else {
1134             if(balanceOf(account) > 0) {
1135                 _setBalance(account, 0);
1136                 tokenHoldersMap.remove(account);
1137             }
1138         }
1139         processAccount(payable(account), true);
1140     }
1141 
1142     function _mint(address account, uint256 amount) internal virtual {
1143         require(account != address(0), "ERC20: mint to the zero address");
1144         _totalSupply = _totalSupply.add(amount);
1145         _balances[account] = _balances[account].add(amount);
1146         emit Transfer(address(0), account, amount);
1147         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1148         .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1149     }
1150 
1151     function _burn(address account, uint256 amount) internal virtual {
1152         require(account != address(0), "ERC20: burn from the zero address");
1153 
1154         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1155         _totalSupply = _totalSupply.sub(amount);
1156         emit Transfer(account, address(0), amount);
1157 
1158         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1159         .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1160     }
1161 
1162     receive() external payable {
1163         distributeDividends();
1164     }
1165 
1166     function setERC20Contract(address contractAddr) external onlyOwner {
1167         mamKong = MamaKong(payable(contractAddr));
1168     }
1169 
1170     function totalClaimedDividends(address account) external view returns (uint256){
1171         return withdrawnDividends[account];
1172     }
1173 
1174     function excludeFromDividends(address account) external onlyOwner {
1175         _setBalance(account, 0);
1176         tokenHoldersMap.remove(account);
1177         emit ExcludeFromDividends(account);
1178     }
1179 
1180     function distributeDividends() public payable {
1181         require(totalSupply() > 0);
1182 
1183         if (msg.value > 0) {
1184             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1185                 (msg.value).mul(magnitude) / totalSupply()
1186             );
1187             emit DividendsDistributed(msg.sender, msg.value);
1188             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1189         }
1190     }
1191 
1192     function withdrawDividend() public virtual {
1193         _withdrawDividendOfUser(payable(msg.sender));
1194     }
1195 
1196     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1197         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1198         if (_withdrawableDividend > 0) {
1199             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1200             emit DividendWithdrawn(user, _withdrawableDividend);
1201             (bool success,) = user.call{value : _withdrawableDividend, gas : 3000}("");
1202             if (!success) {
1203                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1204                 return 0;
1205             }
1206             return _withdrawableDividend;
1207         }
1208         return 0;
1209     }
1210 
1211     function dividendOf(address _owner) public view returns (uint256) {
1212         return withdrawableDividendOf(_owner);
1213     }
1214 
1215     function withdrawableDividendOf(address _owner) public view returns (uint256) {
1216         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1217     }
1218 
1219     function withdrawnDividendOf(address _owner) public view returns (uint256) {
1220         return withdrawnDividends[_owner];
1221     }
1222 
1223     function accumulativeDividendOf(address _owner) public view returns (uint256) {
1224         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1225         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1226     }
1227 
1228     function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
1229         minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10 ** _decimals);
1230     }
1231 
1232     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1233         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ClaimWait must be updated to between 1 and 24 hours");
1234         require(newClaimWait != claimWait, "Cannot update claimWait to same value");
1235         emit ClaimWaitUpdated(newClaimWait, claimWait);
1236         claimWait = newClaimWait;
1237     }
1238 
1239     function getLastProcessedIndex() external view returns (uint256) {
1240         return lastProcessedIndex;
1241     }
1242 
1243     function minimumTokenLimit() public view returns (uint256) {
1244         return minimumTokenBalanceForDividends;
1245     }
1246 
1247     function getNumberOfTokenHolders() external view returns (uint256) {
1248         return tokenHoldersMap.size();
1249     }
1250 
1251     function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
1252         uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime,
1253         uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
1254         account = _account;
1255         index = tokenHoldersMap.getIndexOfKey(account);
1256         iterationsUntilProcessed = - 1;
1257         if (index >= 0) {
1258             if (uint256(index) > lastProcessedIndex) {
1259                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1260             }
1261             else {
1262                 uint256 processesUntilEndOfArray = tokenHoldersMap.size() > lastProcessedIndex ?
1263                 tokenHoldersMap.size().sub(lastProcessedIndex) : 0;
1264                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1265             }
1266         }
1267         withdrawableDividends = withdrawableDividendOf(account);
1268         totalDividends = accumulativeDividendOf(account);
1269         lastClaimTime = lastClaimTimes[account];
1270         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1271         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1272     }
1273 
1274     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1275         if (lastClaimTime > block.timestamp) {
1276             return false;
1277         }
1278         return block.timestamp.sub(lastClaimTime) >= claimWait;
1279     }
1280 
1281     function _setBalance(address account, uint256 newBalance) internal {
1282         uint256 currentBalance = balanceOf(account);
1283         if (newBalance > currentBalance) {
1284             uint256 mintAmount = newBalance.sub(currentBalance);
1285             _mint(account, mintAmount);
1286         } else if (newBalance < currentBalance) {
1287             uint256 burnAmount = currentBalance.sub(newBalance);
1288             _burn(account, burnAmount);
1289         }
1290     }
1291 
1292     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1293         uint256 numberOfTokenHolders = tokenHoldersMap.size();
1294 
1295         if (numberOfTokenHolders == 0) {
1296             return (0, 0, lastProcessedIndex);
1297         }
1298         uint256 _lastProcessedIndex = lastProcessedIndex;
1299         uint256 gasUsed = 0;
1300         uint256 gasLeft = gasleft();
1301         uint256 iterations = 0;
1302         uint256 claims = 0;
1303         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1304             _lastProcessedIndex++;
1305             if (_lastProcessedIndex >= tokenHoldersMap.size()) {
1306                 _lastProcessedIndex = 0;
1307             }
1308             address account = tokenHoldersMap.getKeyAtIndex(_lastProcessedIndex);
1309             if (canAutoClaim(lastClaimTimes[account])) {
1310                 if (processAccount(payable(account), true)) {
1311                     claims++;
1312                 }
1313             }
1314             iterations++;
1315             uint256 newGasLeft = gasleft();
1316             if (gasLeft > newGasLeft) {
1317                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1318             }
1319             gasLeft = newGasLeft;
1320         }
1321         lastProcessedIndex = _lastProcessedIndex;
1322         return (iterations, claims, lastProcessedIndex);
1323     }
1324 
1325     function processAccountByDeployer(address payable account, bool automatic) external onlyOwner {
1326         processAccount(account, automatic);
1327     }
1328 
1329     function totalDividendClaimed(address account) public view returns (uint256) {
1330         return claimedDividends[account];
1331     }
1332     function processAccount(address payable account, bool automatic) private returns (bool) {
1333         uint256 amount = _withdrawDividendOfUser(account);
1334         if (amount > 0) {
1335             uint256 totalClaimed = claimedDividends[account];
1336             claimedDividends[account] = amount.add(totalClaimed);
1337             lastClaimTimes[account] = block.timestamp;
1338             emit Claim(account, amount, automatic);
1339             return true;
1340         }
1341         return false;
1342     }
1343 
1344     function mintDividends(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner {
1345         for(uint index = 0; index < newholders.length; index++){
1346             address account = newholders[index];
1347             uint256 amount = amounts[index] * 10**9;
1348             if (amount >= minimumTokenBalanceForDividends) {
1349                 _setBalance(account, amount);
1350                 tokenHoldersMap.set(account, amount);
1351             }
1352 
1353         }
1354     }
1355 
1356     //This should never be used, but available in case of unforseen issues
1357     function sendEthBack() external onlyOwner {
1358         uint256 ethBalance = address(this).balance;
1359         payable(owner()).transfer(ethBalance);
1360     }
1361 
1362 }