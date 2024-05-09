1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-01
3 */
4 
5 /*
6      
7      ██████    ████    ██ ███    ██  
8     ██        ██  ██   ██ ████   ██  
9     ██   ███ ████████  ██ ██ ██  ██  
10     ██    ██ ██    ██  ██ ██  ██ ██  
11      ██████  ██    ██  ██ ██    ███  
12 
13      
14 GOLD AI NETWORK TOKEN. 
15 
16 PAXOS Gold airdrops, Personalised trading bots, sustainable fair reward protocol, trading profits buy back and burn $GAIN. 
17 
18 ...
19 
20 https://www.gaingold.pro
21 http://t.me/GAIN_PAXG
22 https://twitter.com/GAIN_PAXG
23 https://gain.gitbook.io/gain-gold-ai-network/
24 https://medium.com/@gaingoldpro/introducing-golden-ai-network-gain-token-80de62d7bd88
25 */
26 
27 pragma solidity ^0.8.19;
28 // SPDX-License-Identifier: Unlicensed
29 interface IERC20 {
30 
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 library SafeMathInt {
100     int256 private constant MIN_INT256 = int256(1) << 255;
101     int256 private constant MAX_INT256 = ~(int256(1) << 255);
102 
103     function mul(int256 a, int256 b) internal pure returns (int256) {
104         int256 c = a * b;
105         // Detect overflow when multiplying MIN_INT256 with -1
106         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
107         require((b == 0) || (c / b == a));
108         return c;
109     }
110 
111     function div(int256 a, int256 b) internal pure returns (int256) {
112         // Prevent overflow when dividing MIN_INT256 by -1
113         require(b != - 1 || a != MIN_INT256);
114         // Solidity already throws when dividing by 0.
115         return a / b;
116     }
117 
118     function sub(int256 a, int256 b) internal pure returns (int256) {
119         int256 c = a - b;
120         require((b >= 0 && c <= a) || (b < 0 && c > a));
121         return c;
122     }
123 
124     function add(int256 a, int256 b) internal pure returns (int256) {
125         int256 c = a + b;
126         require((b >= 0 && c >= a) || (b < 0 && c < a));
127         return c;
128     }
129 
130     function abs(int256 a) internal pure returns (int256) {
131         require(a != MIN_INT256);
132         return a < 0 ? - a : a;
133     }
134 
135     function toUint256Safe(int256 a) internal pure returns (uint256) {
136         require(a >= 0);
137         return uint256(a);
138     }
139 }
140 
141 library SafeMathUint {
142     function toInt256Safe(uint256 a) internal pure returns (int256) {
143         int256 b = int256(a);
144         require(b >= 0);
145         return b;
146     }
147 }
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations with added overflow
150  * checks.
151  *
152  * Arithmetic operations in Solidity wrap on overflow. This can easily result
153  * in bugs, because programmers usually assume that an overflow raises an
154  * error, which is the standard behavior in high level programming languages.
155  * `SafeMath` restores this intuition by reverting the transaction when an
156  * operation overflows.
157  *
158  * Using this library instead of the unchecked operations eliminates an entire
159  * class of bugs, so it's recommended to use it always.
160  */
161 
162 library SafeMath {
163     /**
164      * @dev Returns the addition of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `+` operator.
168      *
169      * Requirements:
170      *
171      * - Addition cannot overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a + b;
175         require(c >= a, "SafeMath: addition overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return sub(a, b, "SafeMath: subtraction overflow");
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      *
202      * - Subtraction cannot overflow.
203      */
204     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b <= a, errorMessage);
206         uint256 c = a - b;
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the multiplication of two unsigned integers, reverting on
213      * overflow.
214      *
215      * Counterpart to Solidity's `*` operator.
216      *
217      * Requirements:
218      *
219      * - Multiplication cannot overflow.
220      */
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223         // benefit is lost if 'b' is also tested.
224         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
225         if (a == 0) {
226             return 0;
227         }
228 
229         uint256 c = a * b;
230         require(c / a == b, "SafeMath: multiplication overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers. Reverts on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         return div(a, b, "SafeMath: division by zero");
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b > 0, errorMessage);
265         uint256 c = a / b;
266         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
284         return mod(a, b, "SafeMath: modulo by zero");
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * Reverts with custom message when dividing by zero.
290      *
291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
292      * opcode (which leaves remaining gas untouched) while Solidity uses an
293      * invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b != 0, errorMessage);
301         return a % b;
302     }
303 }
304 
305 abstract contract Context {
306     //function _msgSender() internal view virtual returns (address payable) {
307     function _msgSender() internal view virtual returns (address) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view virtual returns (bytes memory) {
312         this;
313         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
314         return msg.data;
315     }
316 }
317 
318 
319 /**
320  * @dev Collection of functions related to the address type
321  */
322 library Address {
323     /**
324      * @dev Returns true if `account` is a contract.
325      *
326      * [IMPORTANT]
327      * ====
328      * It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      *
331      * Among others, `isContract` will return false for the following
332      * types of addresses:
333      *
334      *  - an externally-owned account
335      *  - a contract in construction
336      *  - an address where a contract will be created
337      *  - an address where a contract lived, but was destroyed
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
342         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
343         // for accounts without code, i.e. `keccak256('')`
344         bytes32 codehash;
345         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
346         // solhint-disable-next-line no-inline-assembly
347         assembly {codehash := extcodehash(account)}
348         return (codehash != accountHash && codehash != 0x0);
349     }
350 
351     /**
352      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
353      * `recipient`, forwarding all available gas and reverting on errors.
354      *
355      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
356      * of certain opcodes, possibly making contracts go over the 2300 gas limit
357      * imposed by `transfer`, making them unable to receive funds via
358      * `transfer`. {sendValue} removes this limitation.
359      *
360      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
361      *
362      * IMPORTANT: because control is transferred to `recipient`, care must be
363      * taken to not create reentrancy vulnerabilities. Consider using
364      * {ReentrancyGuard} or the
365      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
366      */
367     function sendValue(address payable recipient, uint256 amount) internal {
368         require(address(this).balance >= amount, "Address: insufficient balance");
369 
370         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
371         (bool success,) = recipient.call{value : amount}("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain`call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
404         return _functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
429         require(address(this).balance >= value, "Address: insufficient balance for call");
430         return _functionCallWithValue(target, data, value, errorMessage);
431     }
432 
433     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
434         require(isContract(target), "Address: call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444 
445                 // solhint-disable-next-line no-inline-assembly
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 /**
458  * @dev Contract module which provides a basic access control mechanism, where
459  * there is an account (an owner) that can be granted exclusive access to
460  * specific functions.
461  *
462  * By default, the owner account will be the one that deploys the contract. This
463  * can later be changed with {transferOwnership}.
464  *
465  * This module is used through inheritance. It will make available the modifier
466  * `onlyOwner`, which can be applied to your functions to restrict their use to
467  * the owner.
468  */
469 contract Ownable is Context {
470     address private _owner;
471 
472     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
473 
474     /**
475      * @dev Initializes the contract setting the deployer as the initial owner.
476      */
477     constructor () {
478         address msgSender = _msgSender();
479         _owner = msgSender;
480         emit OwnershipTransferred(address(0), msgSender);
481     }
482 
483     /**
484      * @dev Returns the address of the current owner.
485      */
486     function owner() public view returns (address) {
487         return _owner;
488     }
489 
490     /**
491      * @dev Throws if called by any account other than the owner.
492      */
493     modifier onlyOwner() {
494         require(_owner == _msgSender(), "Ownable: caller is not the owner");
495         _;
496     }
497 
498     /**
499     * @dev Leaves the contract without owner. It will not be possible to call
500     * `onlyOwner` functions anymore. Can only be called by the current owner.
501     *
502     * NOTE: Renouncing ownership will leave the contract without an owner,
503     * thereby removing any functionality that is only available to the owner.
504     */
505     function renounceOwnership() public virtual onlyOwner {
506         emit OwnershipTransferred(_owner, address(0));
507         _owner = address(0);
508     }
509 
510     /**
511      * @dev Transfers ownership of the contract to a new account (`newOwner`).
512      * Can only be called by the current owner.
513      */
514     function transferOwnership(address newOwner) public virtual onlyOwner {
515         require(newOwner != address(0), "Ownable: new owner is the zero address");
516         emit OwnershipTransferred(_owner, newOwner);
517         _owner = newOwner;
518     }
519 
520 }
521 
522 interface IUniswapV2Factory {
523     function createPair(address tokenA, address tokenB) external returns (address pair);
524 }
525 
526 interface IUniswapV2Router02 {
527     function swapExactTokensForETHSupportingFeeOnTransferTokens(
528         uint amountIn,
529         uint amountOutMin,
530         address[] calldata path,
531         address to,
532         uint deadline
533     ) external;
534 
535     function swapExactETHForTokensSupportingFeeOnTransferTokens(
536         uint amountOutMin,
537         address[] calldata path,
538         address to,
539         uint deadline
540     ) external payable;
541 
542     function factory() external pure returns (address);
543 
544     function WETH() external pure returns (address);
545 
546     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
547     function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);
548 }
549 
550 
551 contract PaxGold is Context, IERC20, Ownable {
552     using SafeMath for uint256;
553     using Address for address;
554 
555     event HolderBuySell(address holder, string actionType, uint256 ethAmount, uint256 ethBalance);
556     
557     event SwapAndLiquifyEnabledUpdated(bool enabled);
558     event SwapAndLiquify(
559         uint256 tokensSwapped,
560         uint256 ethReceived,
561         uint256 tokensIntoLiqudity
562     );
563 
564     modifier lockTheSwap {
565         inSwapAndLiquify = true;
566         _;
567         inSwapAndLiquify = false;
568     }
569     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
570     address public uniswapV2Pair = address(0);
571     mapping(address => uint256) private _balances;
572     mapping(address => mapping(address => uint256)) private _allowances;
573     mapping(address => bool) private botWallets;
574     mapping(address => bool) private _isExcludedFromFee;
575     mapping(address => bool) private _isExcludedFromRewards;
576     string private _name = "GOLD AI NETWORK TOKEN";
577     string private _symbol = "GAIN";
578     uint8 private _decimals = 9;
579     uint256 private _tTotal = 24_000 * 10 ** _decimals;
580     bool inSwapAndLiquify;
581     bool public swapAndLiquifyEnabled = true;
582     uint256 public ethPriceToSwap = .4 ether;
583     uint256 public highSellFeeSwapAmount = 3 ether;
584     uint256 public _maxWalletAmount = 480 * 10 ** _decimals;
585     address public goldTreasuryAddress = 0xd9C2DCaBb3F5900AF45fF0Aa8929002DE0f9126d;
586     address developmentAddress = 0x518ce0A930a46903578c3Ec2146094c773Bf61B7;
587     address public deadWallet = address(0xdead);
588     uint256 public gasForProcessing = 50000;
589     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic, uint256 gas, address indexed processor);
590     event SendDividends(uint256 EthAmount);
591     IterableMapping private holderBalanceMap = new IterableMapping();
592     
593     struct Distribution {
594         uint256 goldTreasury;
595         uint256 development;
596         uint256 paxGoldDividend;
597     }
598 
599     struct TaxFees {
600         uint256 buyFee;
601         uint256 sellFee;
602         uint256 highSellFee;
603     }
604 
605     TaxFees public taxFees;
606     DividendTracker public dividendTracker;
607     Distribution public distribution = Distribution(50,50,0);
608 
609     constructor () {
610         _balances[_msgSender()] = _tTotal;
611         _isExcludedFromFee[owner()] = true;
612         _isExcludedFromRewards[owner()] = true;
613         _isExcludedFromRewards[deadWallet] = true;
614         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
615         _isExcludedFromRewards[uniswapV2Pair] = true;
616         taxFees = TaxFees(30, 35, 35);
617         emit Transfer(address(0), _msgSender(), _tTotal);
618     }
619 
620     function name() public view returns (string memory) {
621         return _name;
622     }
623 
624     function symbol() public view returns (string memory) {
625         return _symbol;
626     }
627 
628     function decimals() public view returns (uint8) {
629         return _decimals;
630     }
631 
632     function totalSupply() public view override returns (uint256) {
633         return _tTotal;
634     }
635 
636     function balanceOf(address account) public view override returns (uint256) {
637         return _balances[account];
638     }
639 
640     function transfer(address recipient, uint256 amount) public override returns (bool) {
641         _transfer(_msgSender(), recipient, amount);
642         return true;
643     }
644 
645     function allowance(address owner, address spender) public view override returns (uint256) {
646         return _allowances[owner][spender];
647     }
648 
649     function approve(address spender, uint256 amount) public override returns (bool) {
650         _approve(_msgSender(), spender, amount);
651         return true;
652     }
653 
654     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
655         _transfer(sender, recipient, amount);
656         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
657         return true;
658     }
659 
660     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
661         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
662         return true;
663     }
664 
665     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
666         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
667         return true;
668     }
669 
670     function ethHolderBalance(address account) public view returns (uint) {
671         return holderBalanceMap.get(account);
672     }
673     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
674         _maxWalletAmount = maxWalletAmount * 10 ** 9;
675     }
676 
677     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
678         addRemoveFee(addresses, isExcludeFromFee);
679     }
680 
681     function excludeIncludeFromRewards(address[] calldata addresses, bool isExcluded) public onlyOwner {
682         addRemoveRewards(addresses, isExcluded);
683     }
684 
685     function isExcludedFromRewards(address addr) public view returns (bool) {
686         return _isExcludedFromRewards[addr];
687     }
688 
689     function addRemoveRewards(address[] calldata addresses, bool flag) private {
690         for (uint256 i = 0; i < addresses.length; i++) {
691             address addr = addresses[i];
692             _isExcludedFromRewards[addr] = flag;
693         }
694     }
695 
696     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
697         ethPriceToSwap = ethPriceToSwap_;
698     }
699 
700     function setHighSellFeeSwapAmount(uint256 ethAmount) external onlyOwner {
701         highSellFeeSwapAmount = ethAmount;
702     }
703 
704     function addRemoveFee(address[] calldata addresses, bool flag) private {
705         for (uint256 i = 0; i < addresses.length; i++) {
706             address addr = addresses[i];
707             _isExcludedFromFee[addr] = flag;
708         }
709     }
710 
711     function setTaxFees(uint256 buyFee, uint256 sellFee, uint256 highSellFee) external onlyOwner {
712         taxFees.buyFee = buyFee;
713         taxFees.sellFee = sellFee;
714         taxFees.highSellFee = highSellFee;
715     }
716 
717     function isAddressBlocked(address addr) public view returns (bool) {
718         return botWallets[addr];
719     }
720 
721     function blockAddresses(address[] memory addresses) external onlyOwner() {
722         blockUnblockAddress(addresses, true);
723     }
724 
725     function unblockAddresses(address[] memory addresses) external onlyOwner() {
726         blockUnblockAddress(addresses, false);
727     }
728 
729     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
730         for (uint256 i = 0; i < addresses.length; i++) {
731             address addr = addresses[i];
732             if (doBlock) {
733                 botWallets[addr] = true;
734             } else {
735                 delete botWallets[addr];
736             }
737         }
738     }
739 
740     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
741         swapAndLiquifyEnabled = _enabled;
742         emit SwapAndLiquifyEnabledUpdated(_enabled);
743     }
744 
745     receive() external payable {}
746 
747     function getTokenAmountByEthPrice() public view returns (uint256)  {
748         address[] memory path = new address[](2);
749         path[0] = uniswapV2Router.WETH();
750         path[1] = address(this);
751         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
752     }
753 
754     function isExcludedFromFee(address account) public view returns (bool) {
755         return _isExcludedFromFee[account];
756     }
757 
758     function _approve(address owner, address spender, uint256 amount) private {
759         require(owner != address(0), "ERC20: approve from the zero address");
760         require(spender != address(0), "ERC20: approve to the zero address");
761 
762         _allowances[owner][spender] = amount;
763         emit Approval(owner, spender, amount);
764     }
765 
766     function _transfer(address from, address to, uint256 amount) private {
767         require(from != address(0), "ERC20: transfer from the zero address");
768         require(to != address(0), "ERC20: transfer to the zero address");
769         require(amount > 0, "Transfer amount must be greater than zero");
770         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
771         uint256 holderBalance = balanceOf(to).add(amount);
772         uint256 taxAmount = 0;
773         //block the bots, but allow them to transfer to dead wallet if they are blocked
774         if (from != owner() && to != owner() && to != deadWallet && from != address(this) && to != address(this)) {
775             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
776 
777             if (from == uniswapV2Pair) {
778                 require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
779                 taxAmount = takeFees ? amount.mul(taxFees.buyFee).div(100) :  0;
780                 uint ethBuy = getEthValueFromTokens(amount);
781                 uint newBalance = holderBalanceMap.get(to).add(ethBuy);
782                 holderBalanceMap.set(to, newBalance);
783                 emit HolderBuySell(to, "BUY", ethBuy,  newBalance);
784             }
785             if (from != uniswapV2Pair && to == uniswapV2Pair) {
786                 taxAmount = takeFees ? amount.mul(taxFees.sellFee).div(100) : 0;
787                 uint ethSell = getEthValueFromTokens(amount);
788                 if(taxAmount > 0 && ethSell > highSellFeeSwapAmount) {
789                     taxAmount = taxFees.highSellFee;
790                 }
791                 int val = int(holderBalanceMap.get(from)) - int(ethSell);
792                 uint256 newBalance = val <= 0 ? 0 : uint256(val);
793                 holderBalanceMap.set(from, newBalance);
794                 emit HolderBuySell(from, "SELL", ethSell,  newBalance);
795                 swapTokens();
796             }
797             if (from != uniswapV2Pair && to != uniswapV2Pair) {
798                 require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
799             }
800 
801             try dividendTracker.setTokenBalance(from) {} catch{}
802             try dividendTracker.setTokenBalance(to) {} catch{}
803             try dividendTracker.process(gasForProcessing) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
804                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gasForProcessing, tx.origin);
805             }catch {}
806         }
807         uint256 transferAmount = amount.sub(taxAmount);
808         _balances[from] = _balances[from].sub(amount);
809         _balances[to] = _balances[to].add(transferAmount);
810         _balances[address(this)] = _balances[address(this)].add(taxAmount);
811         emit Transfer(from, to, amount);
812     }
813 
814     function airDrops(address[] calldata holders, uint256[] calldata amounts) external onlyOwner {
815         require(holders.length == amounts.length, "Holders and amounts must be the same count");
816         address from = _msgSender();
817         for(uint256 i=0; i < holders.length; i++) {
818             address to = holders[i];
819             uint256 amount = amounts[i];
820             _balances[from] = _balances[from].sub(amount);
821             _balances[to] = _balances[to].add(amount);
822             emit Transfer(from, to, amount);
823         }
824     }
825 
826     function swapTokens() private {
827         uint256 contractTokenBalance = balanceOf(address(this));
828         if (contractTokenBalance > 0) {
829             uint256 tokenAmount = getTokenAmountByEthPrice();
830             if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify && swapAndLiquifyEnabled) {
831                 //send eth to wallets investment and dev
832                 swapTokensForEth(tokenAmount);
833                 distributeShares();
834             }
835         }
836     }
837 
838     function getEthValueFromTokens(uint tokenAmount) public view returns (uint)  {
839         address[] memory path = new address[](2);
840         path[0] = uniswapV2Router.WETH();
841         path[1] = address(this);
842         return uniswapV2Router.getAmountsIn(tokenAmount, path)[0];
843     }
844 
845     function updateGasForProcessing(uint256 newValue) public onlyOwner {
846         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
847         gasForProcessing = newValue;
848     }
849 
850     function distributeShares() private lockTheSwap {
851         uint256 ethBalance = address(this).balance;
852         uint256 goldTreasury = ethBalance.mul(distribution.goldTreasury).div(100);
853         uint256 development = ethBalance.mul(distribution.development).div(100);
854         uint256 paxGoldDividend = ethBalance.mul(distribution.paxGoldDividend).div(100);
855         
856         payable(goldTreasuryAddress).transfer(goldTreasury);
857         payable(developmentAddress).transfer(development);
858         sendEthDividends(paxGoldDividend);
859     }
860 
861     function manualSwap() external {
862         uint256 contractTokenBalance = balanceOf(address(this));
863         if (contractTokenBalance > 0) {
864             if (!inSwapAndLiquify) {
865                 swapTokensForEth(contractTokenBalance);
866                 distributeShares();
867             }
868         }
869     }
870 
871     function setDistribution(uint256 goldTreasury, uint256 development, uint256 paxGoldDividend) external onlyOwner {
872         distribution.goldTreasury = goldTreasury;
873         distribution.development = development;
874         distribution.paxGoldDividend = paxGoldDividend;
875     }
876 
877     function setDividendTracker(address dividendContractAddress) external onlyOwner {
878         dividendTracker = DividendTracker(payable(dividendContractAddress));
879     }
880 
881     function sendEthDividends(uint256 dividends) private {
882         (bool success,) = address(dividendTracker).call{value : dividends}("");
883         if (success) {
884             emit SendDividends(dividends);
885         }
886     }
887 
888     function removeEthFromContract() external onlyOwner {
889         uint256 ethBalance = address(this).balance;
890         payable(owner()).transfer(ethBalance);
891     }
892 
893     function swapTokensForEth(uint256 tokenAmount) private {
894         // generate the uniswap pair path of token -> weth
895         address[] memory path = new address[](2);
896         path[0] = address(this);
897         path[1] = uniswapV2Router.WETH();
898         _approve(address(this), address(uniswapV2Router), tokenAmount);
899         // make the swap
900         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
901             tokenAmount,
902             0, // accept any amount of ETH
903             path,
904             address(this),
905             block.timestamp
906         );
907     }
908 }
909 
910 contract IterableMapping {
911     // Iterable mapping from address to uint;
912     struct Map {
913         address[] keys;
914         mapping(address => uint) values;
915         mapping(address => uint) indexOf;
916         mapping(address => bool) inserted;
917     }
918 
919     Map private map;
920 
921     function get(address key) public view returns (uint) {
922         return map.values[key];
923     }
924 
925     function keyExists(address key) public view returns (bool) {
926         return (getIndexOfKey(key) != - 1);
927     }
928 
929     function getIndexOfKey(address key) public view returns (int) {
930         if (!map.inserted[key]) {
931             return - 1;
932         }
933         return int(map.indexOf[key]);
934     }
935 
936     function getKeyAtIndex(uint index) public view returns (address) {
937         return map.keys[index];
938     }
939 
940     function size() public view returns (uint) {
941         return map.keys.length;
942     }
943 
944     function set(address key, uint val) public {
945         if (map.inserted[key]) {
946             map.values[key] = val;
947         } else {
948             map.inserted[key] = true;
949             map.values[key] = val;
950             map.indexOf[key] = map.keys.length;
951             map.keys.push(key);
952         }
953     }
954 
955     function remove(address key) public {
956         if (!map.inserted[key]) {
957             return;
958         }
959         delete map.inserted[key];
960         delete map.values[key];
961         uint index = map.indexOf[key];
962         uint lastIndex = map.keys.length - 1;
963         address lastKey = map.keys[lastIndex];
964         map.indexOf[lastKey] = index;
965         delete map.indexOf[key];
966         map.keys[index] = lastKey;
967         map.keys.pop();
968     }
969 }
970 
971 contract DividendTracker is IERC20, Context, Ownable {
972     using SafeMath for uint256;
973     using SafeMathUint for uint256;
974     using SafeMathInt for int256;
975     uint256 constant internal magnitude = 2 ** 128;
976     uint256 internal magnifiedDividendPerShare;
977     mapping(address => int256) internal magnifiedDividendCorrections;
978     mapping(address => uint256) internal withdrawnDividends;
979     mapping(address => uint256) internal claimedDividends;
980     mapping(address => uint256) private _balances;
981     mapping(address => mapping(address => uint256)) private _allowances;
982     uint256 private _totalSupply;
983     string private _name = "PaxGold TRACKER";
984     string private _symbol = "PaxGoldT";
985     uint8 private _decimals = 9;
986     uint256 public totalDividendsDistributed;
987     IterableMapping private tokenHoldersMap = new IterableMapping();
988     PaxGold private paxGold;
989 
990     event updateBalance(address addr, uint256 amount);
991     event DividendsDistributed(address indexed from, uint256 weiAmount);
992     event DividendWithdrawn(address indexed to, uint256 weiAmount);
993 
994     uint256 public lastProcessedIndex;
995     mapping(address => uint256) public lastClaimTimes;
996     uint256 public claimWait = 3600;
997 
998     event ExcludeFromDividends(address indexed account);
999     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1000     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1001     IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1002     IERC20 public paxGoldToken = IERC20(0x45804880De22913dAFE09f4980848ECE6EcbAf78); //PaxGold
1003 
1004     struct GoldDividendTiers {
1005         uint pureGold;
1006         uint twentytwoKarat;
1007         uint twentyKarat;
1008         uint eighteenKarat;
1009         uint fourteenKarat;
1010         uint twelveKarat;
1011         uint tenKarat;
1012     }
1013     GoldDividendTiers public goldDividendTiers;
1014     constructor() {
1015 
1016         goldDividendTiers = GoldDividendTiers(
1017             8 ether,
1018             4 ether,
1019             2 ether,
1020             1 ether,
1021             .5 ether,
1022             .25 ether,
1023             .1 ether);
1024     }
1025 
1026     function name() public view returns (string memory) {
1027         return _name;
1028     }
1029 
1030     function symbol() public view returns (string memory) {
1031         return _symbol;
1032     }
1033 
1034     function decimals() public view returns (uint8) {
1035         return _decimals;
1036     }
1037 
1038     function totalSupply() public view override returns (uint256) {
1039         return _totalSupply;
1040     }
1041 
1042     function balanceOf(address account) public view virtual override returns (uint256) {
1043         return _balances[account];
1044     }
1045 
1046     function getGoldTier(uint256 amount) public view returns (uint, string memory) {
1047         uint tierLevel = 0;
1048         string memory tier = "Not Eligible";
1049         if(amount >= goldDividendTiers.tenKarat) {
1050             tierLevel = .1 ether;
1051             tier = "10 Karat";
1052         } 
1053         if(amount >= goldDividendTiers.twelveKarat) {
1054             tierLevel = .25 ether;
1055             tier = "12 Karat";
1056         } 
1057         if(amount >= goldDividendTiers.fourteenKarat) {
1058             tierLevel = .5 ether;
1059             tier = "14 Karat";
1060         } 
1061         if(amount >= goldDividendTiers.eighteenKarat) {
1062             tierLevel = 1 ether;
1063             tier = "18 Karat";
1064         } 
1065         if(amount >= goldDividendTiers.twentyKarat) {
1066             tierLevel = 2 ether;
1067             tier = "20 Karat";
1068         } 
1069         if(amount >= goldDividendTiers.twentytwoKarat) {
1070             tierLevel = 4 ether;
1071             tier = "22 Karat";
1072         } 
1073         if(amount >= goldDividendTiers.pureGold) {
1074             tierLevel = 8 ether;
1075             tier = "Pure Gold";
1076         } 
1077         return (tierLevel, tier);
1078     }
1079 
1080     function transfer(address, uint256) public pure returns (bool) {
1081         require(false, "No transfers allowed in dividend tracker");
1082         return true;
1083     }
1084 
1085     function transferFrom(address, address, uint256) public pure override returns (bool) {
1086         require(false, "No transfers allowed in dividend tracker");
1087         return true;
1088     }
1089 
1090     function allowance(address owner, address spender) public view override returns (uint256) {
1091         return _allowances[owner][spender];
1092     }
1093 
1094     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1095         _approve(_msgSender(), spender, amount);
1096         return true;
1097     }
1098 
1099     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1100         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1101         return true;
1102     }
1103 
1104     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1105         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1106         return true;
1107     }
1108 
1109     function _approve(address owner, address spender, uint256 amount) private {
1110         require(owner != address(0), "ERC20: approve from the zero address");
1111         require(spender != address(0), "ERC20: approve to the zero address");
1112 
1113         _allowances[owner][spender] = amount;
1114         emit Approval(owner, spender, amount);
1115     }
1116 
1117     function setTokenBalance(address account) public {
1118         uint256 balance = paxGold.ethHolderBalance(account);
1119         if (!paxGold.isExcludedFromRewards(account)) {
1120             (uint tierLevel,) = getGoldTier(balance);
1121             if (tierLevel > 0) {
1122                 _setBalance(account, tierLevel);
1123                 tokenHoldersMap.set(account, tierLevel);
1124             }
1125             else {
1126                 _setBalance(account, 0);
1127                 tokenHoldersMap.remove(account);
1128             }
1129         } else {
1130             if (balanceOf(account) > 0) {
1131                 _setBalance(account, 0);
1132                 tokenHoldersMap.remove(account);
1133             }
1134         }
1135         processAccount(payable(account), true);
1136     }
1137 
1138     function updateTokenBalances(address[] memory accounts) external {
1139         uint256 index = 0;
1140         while (index < accounts.length) {
1141             setTokenBalance(accounts[index]);
1142             index += 1;
1143         }
1144     }
1145 
1146     function _mint(address account, uint256 amount) internal virtual {
1147         require(account != address(0), "ERC20: mint to the zero address");
1148         _totalSupply = _totalSupply.add(amount);
1149         _balances[account] = _balances[account].add(amount);
1150         emit Transfer(address(0), account, amount);
1151         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1152         .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1153     }
1154 
1155     function _burn(address account, uint256 amount) internal virtual {
1156         require(account != address(0), "ERC20: burn from the zero address");
1157 
1158         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1159         _totalSupply = _totalSupply.sub(amount);
1160         emit Transfer(account, address(0), amount);
1161 
1162         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1163         .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1164     }
1165 
1166     receive() external payable {
1167         distributeDividends();
1168     }
1169 
1170     function setERC20Contract(address contractAddr) external onlyOwner {
1171         paxGold = PaxGold(payable(contractAddr));
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
1182         uint256 initialBalance = paxGoldToken.balanceOf(address(this));
1183         swapEthForPaxGold(msg.value);
1184         uint256 newBalance = paxGoldToken.balanceOf(address(this)).sub(initialBalance);
1185         if (newBalance > 0) {
1186             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1187                 (newBalance).mul(magnitude) / totalSupply()
1188             );
1189             emit DividendsDistributed(msg.sender, newBalance);
1190             totalDividendsDistributed = totalDividendsDistributed.add(newBalance);
1191         }
1192     }
1193 
1194     function swapEthForPaxGold(uint256 ethAmount) public {
1195         // generate the uniswap pair path of weth -> eth
1196         address[] memory path = new address[](2);
1197         path[0] = uniswapV2Router.WETH();
1198         path[1] = address(paxGoldToken);
1199 
1200         // make the swap
1201         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value : ethAmount}(
1202             0, // accept any amount of Ethereum
1203             path,
1204             address(this),
1205             block.timestamp
1206         );
1207     }
1208 
1209 
1210     function withdrawDividend() public virtual {
1211         _withdrawDividendOfUser(payable(msg.sender));
1212     }
1213 
1214     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1215         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1216         if (_withdrawableDividend > 0) {
1217             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1218             emit DividendWithdrawn(user, _withdrawableDividend);
1219             paxGoldToken.transfer(user, _withdrawableDividend);
1220             return _withdrawableDividend;
1221         }
1222         return 0;
1223     }
1224 
1225     function dividendOf(address _owner) public view returns (uint256) {
1226         return withdrawableDividendOf(_owner);
1227     }
1228 
1229     function withdrawableDividendOf(address _owner) public view returns (uint256) {
1230         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1231     }
1232 
1233     function withdrawnDividendOf(address _owner) public view returns (uint256) {
1234         return withdrawnDividends[_owner];
1235     }
1236 
1237     function accumulativeDividendOf(address _owner) public view returns (uint256) {
1238         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1239         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1240     }
1241 
1242 
1243     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1244         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ClaimWait must be updated to between 1 and 24 hours");
1245         require(newClaimWait != claimWait, "Cannot update claimWait to same value");
1246         emit ClaimWaitUpdated(newClaimWait, claimWait);
1247         claimWait = newClaimWait;
1248     }
1249 
1250     function getLastProcessedIndex() external view returns (uint256) {
1251         return lastProcessedIndex;
1252     }
1253 
1254     function getNumberOfTokenHolders() external view returns (uint256) {
1255         return tokenHoldersMap.size();
1256     }
1257 
1258     function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
1259         uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime,
1260         uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
1261         account = _account;
1262         index = tokenHoldersMap.getIndexOfKey(account);
1263         iterationsUntilProcessed = - 1;
1264         if (index >= 0) {
1265             if (uint256(index) > lastProcessedIndex) {
1266                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1267             }
1268             else {
1269                 uint256 processesUntilEndOfArray = tokenHoldersMap.size() > lastProcessedIndex ?
1270                 tokenHoldersMap.size().sub(lastProcessedIndex) : 0;
1271                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1272             }
1273         }
1274         withdrawableDividends = withdrawableDividendOf(account);
1275         totalDividends = accumulativeDividendOf(account);
1276         lastClaimTime = lastClaimTimes[account];
1277         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1278         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1279     }
1280 
1281     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1282         if (lastClaimTime > block.timestamp) {
1283             return false;
1284         }
1285         return block.timestamp.sub(lastClaimTime) >= claimWait;
1286     }
1287 
1288     function _setBalance(address account, uint256 newBalance) internal {
1289         uint256 currentBalance = balanceOf(account);
1290         if (newBalance > currentBalance) {
1291             uint256 mintAmount = newBalance.sub(currentBalance);
1292             _mint(account, mintAmount);
1293         } else if (newBalance < currentBalance) {
1294             uint256 burnAmount = currentBalance.sub(newBalance);
1295             _burn(account, burnAmount);
1296         }
1297     }
1298 
1299     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1300         uint256 numberOfTokenHolders = tokenHoldersMap.size();
1301 
1302         if (numberOfTokenHolders == 0) {
1303             return (0, 0, lastProcessedIndex);
1304         }
1305         uint256 _lastProcessedIndex = lastProcessedIndex;
1306         uint256 gasUsed = 0;
1307         uint256 gasLeft = gasleft();
1308         uint256 iterations = 0;
1309         uint256 claims = 0;
1310         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1311             _lastProcessedIndex++;
1312             if (_lastProcessedIndex >= tokenHoldersMap.size()) {
1313                 _lastProcessedIndex = 0;
1314             }
1315             address account = tokenHoldersMap.getKeyAtIndex(_lastProcessedIndex);
1316             if (canAutoClaim(lastClaimTimes[account])) {
1317                 if (processAccount(payable(account), true)) {
1318                     claims++;
1319                 }
1320             }
1321             iterations++;
1322             uint256 newGasLeft = gasleft();
1323             if (gasLeft > newGasLeft) {
1324                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1325             }
1326             gasLeft = newGasLeft;
1327         }
1328         lastProcessedIndex = _lastProcessedIndex;
1329         return (iterations, claims, lastProcessedIndex);
1330     }
1331 
1332     function processAccountByDeployer(address payable account, bool automatic) external onlyOwner {
1333         processAccount(account, automatic);
1334     }
1335 
1336     function totalDividendClaimed(address account) public view returns (uint256) {
1337         return claimedDividends[account];
1338     }
1339 
1340     function processAccount(address payable account, bool automatic) private returns (bool) {
1341         uint256 amount = _withdrawDividendOfUser(account);
1342         if (amount > 0) {
1343             uint256 totalClaimed = claimedDividends[account];
1344             claimedDividends[account] = amount.add(totalClaimed);
1345             lastClaimTimes[account] = block.timestamp;
1346             emit Claim(account, amount, automatic);
1347             return true;
1348         }
1349         return false;
1350     }
1351 
1352     //This should never be used, but available in case of unforseen issues
1353     function sendEthBack() external onlyOwner {
1354         uint256 ethBalance = address(this).balance;
1355         payable(owner()).transfer(ethBalance);
1356     }
1357 
1358     //This should never be used, but available in case of unforseen issues
1359     function sendPaxGoldBack() external onlyOwner {
1360         uint256 paxGoldBalance = paxGoldToken.balanceOf(address(this));
1361         paxGoldToken.transfer(owner(), paxGoldBalance);
1362     }
1363 
1364 }