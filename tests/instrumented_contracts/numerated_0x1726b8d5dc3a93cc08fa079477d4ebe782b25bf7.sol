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
517 contract Shinjiro is Context, IERC20, Ownable {
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
541     string private _name = "SHINJIRO";
542     string private _symbol = "SHOX";
543     uint8 private _decimals = 9;
544     uint256 private constant MAX = ~uint256(0);
545     uint256 private _tTotal = 1000000000000000000 * 10** _decimals;
546     uint256 private _rTotal = (MAX - (MAX % _tTotal));
547     uint256 private _tFeeTotal;
548     bool inSwapAndLiquify;
549     bool public swapAndLiquifyEnabled = true;
550     bool isTaxFreeTransfer = false;
551     uint256 public _maxBuyAmount = 1000000000000000000 * 10** _decimals;
552     uint256 public ethPriceToSwap = 200000000000000000; //.2 ETH
553     uint public ethSellAmount = 1000000000000000000;  //1 ETH
554     address public marketingAddress = 0x376fF9F2fee139F5e0cb44b53aD97e07ED3c12E3;
555     address public charityAddress = 0xB647dd7Bd8C2a18FF4a9c7497C185C8bb7b9c6F4;
556     address public devAddress = 0x811D5D85EEcda2B9B5Ca6856B7a6C641Eb2542F4;
557     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
558     uint256 public gasForProcessing = 50000;
559     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic,uint256 gas, address indexed processor);
560     event SendDividends(uint256 EthAmount);
561 
562     struct Distribution {
563         uint256 devTeam;
564         uint256 marketing;
565         uint256 dividend;
566         uint256 charity;
567     }
568 
569     struct TaxFees {
570         uint256 reflectionBuyFee;
571         uint256 buyFee;
572         uint256 sellReflectionFee;
573         uint256 sellFee;
574         uint256 largeSellFee;
575     }
576 
577     bool private doTakeFees;
578     bool private isSellTxn;
579     TaxFees public taxFees;
580     Distribution public distribution;
581     DividendTracker private dividendTracker;
582 
583     constructor () {
584         _rOwned[_msgSender()] = _rTotal;
585         _isExcludedFromFee[owner()] = true;
586         _isExcludedFromFee[_msgSender()] = true;
587         _isExcludedFromFee[charityAddress] = true;
588         _isExcludedFromFee[marketingAddress] = true;
589         _isExcludedFromFee[devAddress] = true;
590         _isExcludedFromRewards[deadWallet] = true;
591         taxFees = TaxFees(1,8,1,8,8);
592         distribution = Distribution(30, 30, 30, 10);
593         emit Transfer(address(0), _msgSender(), _tTotal);
594     }
595 
596     function name() public view returns (string memory) {
597         return _name;
598     }
599 
600     function symbol() public view returns (string memory) {
601         return _symbol;
602     }
603 
604     function decimals() public view returns (uint8) {
605         return _decimals;
606     }
607 
608     function totalSupply() public view override returns (uint256) {
609         return _tTotal;
610     }
611 
612     function balanceOf(address account) public view override returns (uint256) {
613         return tokenFromReflection(_rOwned[account]);
614     }
615 
616     function transfer(address recipient, uint256 amount) public override returns (bool) {
617         _transfer(_msgSender(), recipient, amount);
618         return true;
619     }
620 
621     function allowance(address owner, address spender) public view override returns (uint256) {
622         return _allowances[owner][spender];
623     }
624 
625     function approve(address spender, uint256 amount) public override returns (bool) {
626         _approve(_msgSender(), spender, amount);
627         return true;
628     }
629 
630     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
631         _transfer(sender, recipient, amount);
632         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
633         return true;
634     }
635 
636     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
637         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
638         return true;
639     }
640 
641     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
642         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
643         return true;
644     }
645 
646     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
647         uint256 iterator = 0;
648         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
649         require(newholders.length == amounts.length, "Holders and amount length must be the same");
650         while(iterator < newholders.length){
651             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false);
652             iterator += 1;
653         }
654     }
655 
656     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
657         addRemoveFee(addresses, isExcludeFromFee);
658     }
659 
660     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
661         require(rAmount <= _rTotal, "Amount must be less than total reflections");
662         uint256 currentRate =  _getRate();
663         return rAmount.div(currentRate);
664     }
665 
666     function excludeIncludeFromRewards(address[] calldata addresses, bool isExcluded) public onlyOwner {
667         addRemoveRewards(addresses, isExcluded);
668     }
669 
670     function isExcludedFromRewards(address addr) public view returns(bool) {
671         return _isExcludedFromRewards[addr];
672     }
673 
674     function addRemoveRewards(address[] calldata addresses, bool flag) private {
675         for (uint256 i = 0; i < addresses.length; i++) {
676             address addr = addresses[i];
677             _isExcludedFromRewards[addr] = flag;
678         }
679     }
680 
681     function setEthLargeSellAmount(uint ethSellAmount_) external onlyOwner {
682         ethSellAmount = ethSellAmount_;
683     }
684 
685     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
686         ethPriceToSwap = ethPriceToSwap_;
687     }
688 
689     function createV2Pair() external onlyOwner {
690         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
691         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
692         _isExcludedFromRewards[uniswapV2Pair] = true;
693     }
694 
695     function addRemoveFee(address[] calldata addresses, bool flag) private {
696         for (uint256 i = 0; i < addresses.length; i++) {
697             address addr = addresses[i];
698             _isExcludedFromFee[addr] = flag;
699         }
700     }
701 
702     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
703         _maxBuyAmount = maxBuyAmount * 10**9;
704     }
705 
706     function setTaxFees(uint256 reflectionBuyFee, uint256 buyFee, uint256 sellReflectionFee, uint256 sellFee, uint256 largeSellFee) external onlyOwner {
707         taxFees.reflectionBuyFee = reflectionBuyFee;
708         taxFees.buyFee = buyFee;
709         taxFees.sellReflectionFee = sellReflectionFee;
710         taxFees.sellFee = sellFee;
711         taxFees.largeSellFee = largeSellFee;
712     }
713 
714     function setDistribution(uint256 dividend, uint256 devTeam, uint256 marketing, uint256 charity) external onlyOwner {
715         distribution.dividend = dividend;
716         distribution.devTeam = devTeam;
717         distribution.marketing = marketing;
718         distribution.charity = charity;
719     }
720 
721     function setWalletAddresses(address devAddr, address charity, address marketingAddr) external onlyOwner {
722         devAddress = devAddr;
723         charityAddress = charity;
724         marketingAddress = marketingAddr;
725     }
726 
727     function isAddressBlocked(address addr) public view returns (bool) {
728         return botWallets[addr];
729     }
730 
731     function blockAddresses(address[] memory addresses) external onlyOwner() {
732         blockUnblockAddress(addresses, true);
733     }
734 
735     function unblockAddresses(address[] memory addresses) external onlyOwner() {
736         blockUnblockAddress(addresses, false);
737     }
738 
739     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
740         for (uint256 i = 0; i < addresses.length; i++) {
741             address addr = addresses[i];
742             if(doBlock) {
743                 botWallets[addr] = true;
744             } else {
745                 delete botWallets[addr];
746             }
747         }
748     }
749 
750     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
751         swapAndLiquifyEnabled = _enabled;
752         emit SwapAndLiquifyEnabledUpdated(_enabled);
753     }
754 
755     receive() external payable {}
756 
757     function _reflectFee(uint256 rFee, uint256 tFee) private {
758         _rTotal = _rTotal.sub(rFee);
759         _tFeeTotal = _tFeeTotal.add(tFee);
760     }
761 
762     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
763         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
764         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
765         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
766     }
767 
768     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
769         uint256 tFee = calculateTaxFee(tAmount);
770         uint256 tLiquidity = calculateLiquidityFee(tAmount);
771         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
772         return (tTransferAmount, tFee, tLiquidity);
773     }
774 
775     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
776         uint256 rAmount = tAmount.mul(currentRate);
777         uint256 rFee = tFee.mul(currentRate);
778         uint256 rLiquidity = tLiquidity.mul(currentRate);
779         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
780         return (rAmount, rTransferAmount, rFee);
781     }
782 
783     function _getRate() private view returns(uint256) {
784         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
785         return rSupply.div(tSupply);
786     }
787 
788     function _getCurrentSupply() private view returns(uint256, uint256) {
789         uint256 rSupply = _rTotal;
790         uint256 tSupply = _tTotal;
791         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
792         return (rSupply, tSupply);
793     }
794 
795     function _takeLiquidity(uint256 tLiquidity) private {
796         uint256 currentRate =  _getRate();
797         uint256 rLiquidity = tLiquidity.mul(currentRate);
798         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
799     }
800 
801     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
802         uint256 reflectionFee = 0;
803         if(doTakeFees) {
804             reflectionFee = taxFees.reflectionBuyFee;
805             if(isSellTxn) {
806                 reflectionFee = taxFees.sellReflectionFee;
807             }
808         }
809         return _amount.mul(reflectionFee).div(10**2);
810     }
811 
812     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
813         uint256 totalLiquidityFee = 0;
814         if(doTakeFees) {
815             totalLiquidityFee = taxFees.buyFee;
816             if(isSellTxn) {
817                 totalLiquidityFee = taxFees.sellFee;
818                 uint ethPrice = getEthPrice(_amount);
819                 if(ethPrice >= ethSellAmount) {
820                     totalLiquidityFee = taxFees.largeSellFee;
821                 }
822             }
823         }
824         return _amount.mul(totalLiquidityFee).div(10**2);
825     }
826 
827     function getEthPrice(uint tokenAmount) public view returns (uint)  {
828         address[] memory path = new address[](2);
829         path[0] = address(this);
830         path[1] = uniswapV2Router.WETH();
831         return uniswapV2Router.getAmountsOut(tokenAmount, path)[1];
832     }
833 
834     function isExcludedFromFee(address account) public view returns(bool) {
835         return _isExcludedFromFee[account];
836     }
837 
838     function enableDisableTaxFreeTransfers(bool enableDisable) external onlyOwner {
839         isTaxFreeTransfer = enableDisable;
840     }
841 
842     function _approve(address owner, address spender, uint256 amount) private {
843         require(owner != address(0), "ERC20: approve from the zero address");
844         require(spender != address(0), "ERC20: approve to the zero address");
845 
846         _allowances[owner][spender] = amount;
847         emit Approval(owner, spender, amount);
848     }
849 
850     function _transfer(address from, address to, uint256 amount) private {
851         require(from != address(0), "ERC20: transfer from the zero address");
852         require(to != address(0), "ERC20: transfer to the zero address");
853         require(amount > 0, "Transfer amount must be greater than zero");
854         require(uniswapV2Pair != address(0),"UniswapV2Pair has not been set");
855         bool isSell = false;
856         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
857         //block the bots, but allow them to transfer to dead wallet if they are blocked
858         if(from != owner() && to != owner() && to != deadWallet) {
859             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
860         }
861         if(from == uniswapV2Pair) {
862             require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxTxAmount.");
863         }
864         if(from != uniswapV2Pair && to == uniswapV2Pair) { //if sell
865             //only tax if tokens are going back to Uniswap
866             isSell = true;
867             swapTokensAndDistribute();
868         }
869         if(from != uniswapV2Pair && to != uniswapV2Pair) {
870             takeFees = isTaxFreeTransfer ? false : true;
871         }
872         
873         _tokenTransfer(from, to, amount, takeFees, isSell, true);
874     }
875 
876     function swapTokensAndDistribute() private {
877         uint256 contractTokenBalance = balanceOf(address(this));
878         if(contractTokenBalance > 0) {
879             uint ethPrice = getEthPrice(contractTokenBalance);
880             if (ethPrice >= ethPriceToSwap && !inSwapAndLiquify && swapAndLiquifyEnabled) {
881                 //send eth to wallets marketing and dev
882                 distributeShares(contractTokenBalance);
883             }
884         }
885     }
886 
887     function updateGasForProcessing(uint256 newValue) public onlyOwner {
888         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
889         gasForProcessing = newValue;
890     }
891 
892     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
893         swapTokensForEth(balanceToShareTokens);
894         uint256 distributionEth = address(this).balance;
895         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
896         uint256 dividendShare = distributionEth.mul(distribution.dividend).div(100);
897         uint256 devTeamShare = distributionEth.mul(distribution.devTeam).div(100);
898         uint256 charityShare = distributionEth.mul(distribution.charity).div(100);
899         if(marketingShare > 0){
900             payable(marketingAddress).transfer(marketingShare);
901         }
902         if(dividendShare > 0){
903             sendEthDividends(dividendShare);
904         }
905         if(devTeamShare > 0){
906             payable(devAddress).transfer(devTeamShare);
907         }
908         if(charityShare > 0){
909             payable(charityAddress).transfer(charityShare);
910         }
911     }
912 
913     function setDividendTracker(address dividendContractAddress) external onlyOwner {
914         dividendTracker = DividendTracker(payable(dividendContractAddress));
915     }
916 
917     function sendEthDividends(uint256 dividends) private {
918         (bool success,) = address(dividendTracker).call{value : dividends}("");
919         if (success) {
920             emit SendDividends(dividends);
921         }
922     }
923 
924     function swapTokensForEth(uint256 tokenAmount) private {
925         // generate the uniswap pair path of token -> weth
926         address[] memory path = new address[](2);
927         path[0] = address(this);
928         path[1] = uniswapV2Router.WETH();
929         _approve(address(this), address(uniswapV2Router), tokenAmount);
930         // make the swap
931         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
932             tokenAmount,
933             0, // accept any amount of ETH
934             path,
935             address(this),
936             block.timestamp
937         );
938     }
939 
940     //this method is responsible for taking all fee, if takeFee is true
941     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFees, bool isSell, bool doUpdateDividends) private {
942         doTakeFees = takeFees;
943         isSellTxn = isSell;
944         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
945         _rOwned[sender] = _rOwned[sender].sub(rAmount);
946         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
947         _takeLiquidity(tLiquidity);
948         _reflectFee(rFee, tFee);
949         emit Transfer(sender, recipient, tTransferAmount);
950 
951         if(doUpdateDividends && distribution.dividend > 0) {
952             try dividendTracker.setTokenBalance(sender) {} catch{}
953             try dividendTracker.setTokenBalance(recipient) {} catch{}
954             try dividendTracker.process(gasForProcessing) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
955                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gasForProcessing, tx.origin);
956             }catch {}
957         }
958     }
959 }
960 
961 contract IterableMapping {
962     // Iterable mapping from address to uint;
963     struct Map {
964         address[] keys;
965         mapping(address => uint) values;
966         mapping(address => uint) indexOf;
967         mapping(address => bool) inserted;
968     }
969 
970     Map private map;
971 
972     function get(address key) public view returns (uint) {
973         return map.values[key];
974     }
975 
976     function keyExists(address key) public view returns(bool) {
977         return (getIndexOfKey(key) != -1);
978     }
979 
980     function getIndexOfKey(address key) public view returns (int) {
981         if (!map.inserted[key]) {
982             return - 1;
983         }
984         return int(map.indexOf[key]);
985     }
986 
987     function getKeyAtIndex(uint index) public view returns (address) {
988         return map.keys[index];
989     }
990 
991     function size() public view returns (uint) {
992         return map.keys.length;
993     }
994 
995     function set(address key, uint val) public {
996         if (map.inserted[key]) {
997             map.values[key] = val;
998         } else {
999             map.inserted[key] = true;
1000             map.values[key] = val;
1001             map.indexOf[key] = map.keys.length;
1002             map.keys.push(key);
1003         }
1004     }
1005 
1006     function remove(address key) public {
1007         if (!map.inserted[key]) {
1008             return;
1009         }
1010         delete map.inserted[key];
1011         delete map.values[key];
1012         uint index = map.indexOf[key];
1013         uint lastIndex = map.keys.length - 1;
1014         address lastKey = map.keys[lastIndex];
1015         map.indexOf[lastKey] = index;
1016         delete map.indexOf[key];
1017         map.keys[index] = lastKey;
1018         map.keys.pop();
1019     }
1020 }
1021 
1022 contract DividendTracker is IERC20, Context, Ownable {
1023     using SafeMath for uint256;
1024     using SafeMathUint for uint256;
1025     using SafeMathInt for int256;
1026     uint256 constant internal magnitude = 2 ** 128;
1027     uint256 internal magnifiedDividendPerShare;
1028     mapping(address => int256) internal magnifiedDividendCorrections;
1029     mapping(address => uint256) internal withdrawnDividends;
1030     mapping(address => uint256) internal claimedDividends;
1031     mapping(address => uint256) private _balances;
1032     mapping(address => mapping(address => uint256)) private _allowances;
1033     uint256 private _totalSupply;
1034     string private _name = "SHINJIRO TRACKER";
1035     string private _symbol = "SHOXT";
1036     uint8 private _decimals = 9;
1037     uint256 public totalDividendsDistributed;
1038     IterableMapping private tokenHoldersMap = new IterableMapping();
1039     uint256 public minimumTokenBalanceForDividends = 250000000000000 * 10 **  _decimals;
1040     Shinjiro private shinjiro;
1041     bool public doCalculation = false;
1042     event updateBalance(address addr, uint256 amount);
1043     event DividendsDistributed(address indexed from,uint256 weiAmount);
1044     event DividendWithdrawn(address indexed to,uint256 weiAmount);
1045 
1046     uint256 public lastProcessedIndex;
1047     mapping(address => uint256) public lastClaimTimes;
1048     uint256 public claimWait = 3600;
1049 
1050     event ExcludeFromDividends(address indexed account);
1051     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1052     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1053 
1054     constructor() {
1055         emit Transfer(address(0), _msgSender(), 0);
1056     }
1057 
1058     function name() public view returns (string memory) {
1059         return _name;
1060     }
1061 
1062     function symbol() public view returns (string memory) {
1063         return _symbol;
1064     }
1065 
1066     function decimals() public view returns (uint8) {
1067         return _decimals;
1068     }
1069 
1070     function totalSupply() public view override returns (uint256) {
1071         return _totalSupply;
1072     }
1073     function balanceOf(address account) public view virtual override returns (uint256) {
1074         return _balances[account];
1075     }
1076 
1077     function transfer(address, uint256) public pure returns (bool) {
1078         require(false, "No transfers allowed in dividend tracker");
1079         return true;
1080     }
1081 
1082     function transferFrom(address, address, uint256) public pure override returns (bool) {
1083         require(false, "No transfers allowed in dividend tracker");
1084         return true;
1085     }
1086 
1087     function allowance(address owner, address spender) public view override returns (uint256) {
1088         return _allowances[owner][spender];
1089     }
1090 
1091     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1092         _approve(_msgSender(), spender, amount);
1093         return true;
1094     }
1095 
1096     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1097         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1098         return true;
1099     }
1100 
1101     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1102         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1103         return true;
1104     }
1105 
1106     function _approve(address owner, address spender, uint256 amount) private {
1107         require(owner != address(0), "ERC20: approve from the zero address");
1108         require(spender != address(0), "ERC20: approve to the zero address");
1109 
1110         _allowances[owner][spender] = amount;
1111         emit Approval(owner, spender, amount);
1112     }
1113 
1114     function setTokenBalance(address account) external {
1115         uint256 balance = shinjiro.balanceOf(account);
1116         if(!shinjiro.isExcludedFromRewards(account)) {
1117             if (balance >= minimumTokenBalanceForDividends) {
1118                 _setBalance(account, balance);
1119                 tokenHoldersMap.set(account, balance);
1120             }
1121             else {
1122                 _setBalance(account, 0);
1123                 tokenHoldersMap.remove(account);
1124             }
1125         } else {
1126             if(balanceOf(account) > 0) {
1127                 _setBalance(account, 0);
1128                 tokenHoldersMap.remove(account);
1129             }
1130         }
1131         processAccount(payable(account), true);
1132     }
1133 
1134     function _mint(address account, uint256 amount) internal virtual {
1135         require(account != address(0), "ERC20: mint to the zero address");
1136         _totalSupply = _totalSupply.add(amount);
1137         _balances[account] = _balances[account].add(amount);
1138         emit Transfer(address(0), account, amount);
1139         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1140         .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1141     }
1142 
1143     function _burn(address account, uint256 amount) internal virtual {
1144         require(account != address(0), "ERC20: burn from the zero address");
1145 
1146         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1147         _totalSupply = _totalSupply.sub(amount);
1148         emit Transfer(account, address(0), amount);
1149 
1150         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1151         .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1152     }
1153 
1154     receive() external payable {
1155         distributeDividends();
1156     }
1157 
1158     function setERC20Contract(address contractAddr) external onlyOwner {
1159         shinjiro = Shinjiro(payable(contractAddr));
1160     }
1161 
1162     function totalClaimedDividends(address account) external view returns (uint256){
1163         return withdrawnDividends[account];
1164     }
1165 
1166     function excludeFromDividends(address account) external onlyOwner {
1167         _setBalance(account, 0);
1168         tokenHoldersMap.remove(account);
1169         emit ExcludeFromDividends(account);
1170     }
1171 
1172     function distributeDividends() public payable {
1173         require(totalSupply() > 0);
1174 
1175         if (msg.value > 0) {
1176             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1177                 (msg.value).mul(magnitude) / totalSupply()
1178             );
1179             emit DividendsDistributed(msg.sender, msg.value);
1180             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1181         }
1182     }
1183 
1184     function withdrawDividend() public virtual {
1185         _withdrawDividendOfUser(payable(msg.sender));
1186     }
1187 
1188     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1189         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1190         if (_withdrawableDividend > 0) {
1191             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1192             emit DividendWithdrawn(user, _withdrawableDividend);
1193             (bool success,) = user.call{value : _withdrawableDividend, gas : 3000}("");
1194             if (!success) {
1195                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1196                 return 0;
1197             }
1198             return _withdrawableDividend;
1199         }
1200         return 0;
1201     }
1202 
1203     function dividendOf(address _owner) public view returns (uint256) {
1204         return withdrawableDividendOf(_owner);
1205     }
1206 
1207     function withdrawableDividendOf(address _owner) public view returns (uint256) {
1208         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1209     }
1210 
1211     function withdrawnDividendOf(address _owner) public view returns (uint256) {
1212         return withdrawnDividends[_owner];
1213     }
1214 
1215     function accumulativeDividendOf(address _owner) public view returns (uint256) {
1216         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1217         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1218     }
1219 
1220     function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
1221         minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10 ** _decimals);
1222     }
1223 
1224     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1225         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ClaimWait must be updated to between 1 and 24 hours");
1226         require(newClaimWait != claimWait, "Cannot update claimWait to same value");
1227         emit ClaimWaitUpdated(newClaimWait, claimWait);
1228         claimWait = newClaimWait;
1229     }
1230 
1231     function getLastProcessedIndex() external view returns (uint256) {
1232         return lastProcessedIndex;
1233     }
1234 
1235     function minimumTokenLimit() public view returns (uint256) {
1236         return minimumTokenBalanceForDividends;
1237     }
1238 
1239     function getNumberOfTokenHolders() external view returns (uint256) {
1240         return tokenHoldersMap.size();
1241     }
1242 
1243     function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
1244         uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime,
1245         uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
1246         account = _account;
1247         index = tokenHoldersMap.getIndexOfKey(account);
1248         iterationsUntilProcessed = - 1;
1249         if (index >= 0) {
1250             if (uint256(index) > lastProcessedIndex) {
1251                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1252             }
1253             else {
1254                 uint256 processesUntilEndOfArray = tokenHoldersMap.size() > lastProcessedIndex ?
1255                 tokenHoldersMap.size().sub(lastProcessedIndex) : 0;
1256                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1257             }
1258         }
1259         withdrawableDividends = withdrawableDividendOf(account);
1260         totalDividends = accumulativeDividendOf(account);
1261         lastClaimTime = lastClaimTimes[account];
1262         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1263         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1264     }
1265 
1266     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1267         if (lastClaimTime > block.timestamp) {
1268             return false;
1269         }
1270         return block.timestamp.sub(lastClaimTime) >= claimWait;
1271     }
1272 
1273     function _setBalance(address account, uint256 newBalance) internal {
1274         uint256 currentBalance = balanceOf(account);
1275         if (newBalance > currentBalance) {
1276             uint256 mintAmount = newBalance.sub(currentBalance);
1277             _mint(account, mintAmount);
1278         } else if (newBalance < currentBalance) {
1279             uint256 burnAmount = currentBalance.sub(newBalance);
1280             _burn(account, burnAmount);
1281         }
1282     }
1283 
1284     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1285         uint256 numberOfTokenHolders = tokenHoldersMap.size();
1286 
1287         if (numberOfTokenHolders == 0) {
1288             return (0, 0, lastProcessedIndex);
1289         }
1290         uint256 _lastProcessedIndex = lastProcessedIndex;
1291         uint256 gasUsed = 0;
1292         uint256 gasLeft = gasleft();
1293         uint256 iterations = 0;
1294         uint256 claims = 0;
1295         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1296             _lastProcessedIndex++;
1297             if (_lastProcessedIndex >= tokenHoldersMap.size()) {
1298                 _lastProcessedIndex = 0;
1299             }
1300             address account = tokenHoldersMap.getKeyAtIndex(_lastProcessedIndex);
1301             if (canAutoClaim(lastClaimTimes[account])) {
1302                 if (processAccount(payable(account), true)) {
1303                     claims++;
1304                 }
1305             }
1306             iterations++;
1307             uint256 newGasLeft = gasleft();
1308             if (gasLeft > newGasLeft) {
1309                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1310             }
1311             gasLeft = newGasLeft;
1312         }
1313         lastProcessedIndex = _lastProcessedIndex;
1314         return (iterations, claims, lastProcessedIndex);
1315     }
1316 
1317     function processAccountByDeployer(address payable account, bool automatic) external onlyOwner {
1318         processAccount(account, automatic);
1319     }
1320 
1321     function totalDividendClaimed(address account) public view returns (uint256) {
1322         return claimedDividends[account];
1323     }
1324     function processAccount(address payable account, bool automatic) private returns (bool) {
1325         uint256 amount = _withdrawDividendOfUser(account);
1326         if (amount > 0) {
1327             uint256 totalClaimed = claimedDividends[account];
1328             claimedDividends[account] = amount.add(totalClaimed);
1329             lastClaimTimes[account] = block.timestamp;
1330             emit Claim(account, amount, automatic);
1331             return true;
1332         }
1333         return false;
1334     }
1335 
1336     function mintDividends(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner {
1337         for(uint index = 0; index < newholders.length; index++){
1338             address account = newholders[index];
1339             uint256 amount = amounts[index] * 10**9;
1340             if (amount >= minimumTokenBalanceForDividends) {
1341                 _setBalance(account, amount);
1342                 tokenHoldersMap.set(account, amount);
1343             }
1344 
1345         }
1346     }
1347 
1348     //This should never be used, but available in case of unforseen issues
1349     function sendEthBack() external onlyOwner {
1350         uint256 ethBalance = address(this).balance;
1351         payable(owner()).transfer(ethBalance);
1352     }
1353 
1354 }