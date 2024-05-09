1 pragma solidity ^0.8.12;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     /**
8      * @dev Returns the amount of tokens owned by `account`.
9      */
10     function balanceOf(address account) external view returns (uint256);
11 
12     /**
13      * @dev Moves `amount` tokens from the caller's account to `recipient`.
14      *
15      * Returns a boolean value indicating whether the operation succeeded.
16      *
17      * Emits a {Transfer} event.
18      */
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     /**
22      * @dev Returns the remaining number of tokens that `spender` will be
23      * allowed to spend on behalf of `owner` through {transferFrom}. This is
24      * zero by default.
25      *
26      * This value changes when {approve} or {transferFrom} are called.
27      */
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     /**
31      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * IMPORTANT: Beware that changing an allowance with this method brings the risk
36      * that someone may use both the old and the new allowance by unfortunate
37      * transaction ordering. One possible solution to mitigate this race
38      * condition is to first reduce the spender's allowance to 0 and set the
39      * desired value afterwards:
40      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
41      *
42      * Emits an {Approval} event.
43      */
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Moves `amount` tokens from `sender` to `recipient` using the
48      * allowance mechanism. `amount` is then deducted from the caller's
49      * allowance.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Emitted when `value` tokens are moved from one account (`from`) to
59      * another (`to`).
60      *
61      * Note that `value` may be zero.
62      */
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     /**
66      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
67      * a call to {approve}. `value` is the new allowance.
68      */
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 
73 
74 library SafeMathInt {
75     int256 private constant MIN_INT256 = int256(1) << 255;
76     int256 private constant MAX_INT256 = ~(int256(1) << 255);
77 
78     function mul(int256 a, int256 b) internal pure returns (int256) {
79         int256 c = a * b;
80         // Detect overflow when multiplying MIN_INT256 with -1
81         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
82         require((b == 0) || (c / b == a));
83         return c;
84     }
85 
86     function div(int256 a, int256 b) internal pure returns (int256) {
87         // Prevent overflow when dividing MIN_INT256 by -1
88         require(b != - 1 || a != MIN_INT256);
89         // Solidity already throws when dividing by 0.
90         return a / b;
91     }
92 
93     function sub(int256 a, int256 b) internal pure returns (int256) {
94         int256 c = a - b;
95         require((b >= 0 && c <= a) || (b < 0 && c > a));
96         return c;
97     }
98 
99     function add(int256 a, int256 b) internal pure returns (int256) {
100         int256 c = a + b;
101         require((b >= 0 && c >= a) || (b < 0 && c < a));
102         return c;
103     }
104 
105     function abs(int256 a) internal pure returns (int256) {
106         require(a != MIN_INT256);
107         return a < 0 ? - a : a;
108     }
109 
110     function toUint256Safe(int256 a) internal pure returns (uint256) {
111         require(a >= 0);
112         return uint256(a);
113     }
114 }
115 
116 library SafeMathUint {
117     function toInt256Safe(uint256 a) internal pure returns (int256) {
118         int256 b = int256(a);
119         require(b >= 0);
120         return b;
121     }
122 }
123 /**
124  * @dev Wrappers over Solidity's arithmetic operations with added overflow
125  * checks.
126  *
127  * Arithmetic operations in Solidity wrap on overflow. This can easily result
128  * in bugs, because programmers usually assume that an overflow raises an
129  * error, which is the standard behavior in high level programming languages.
130  * `SafeMath` restores this intuition by reverting the transaction when an
131  * operation overflows.
132  *
133  * Using this library instead of the unchecked operations eliminates an entire
134  * class of bugs, so it's recommended to use it always.
135  */
136 
137 library SafeMath {
138     /**
139      * @dev Returns the addition of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `+` operator.
143      *
144      * Requirements:
145      *
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b <= a, errorMessage);
181         uint256 c = a - b;
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      *
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return div(a, b, "SafeMath: division by zero");
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b > 0, errorMessage);
240         uint256 c = a / b;
241         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts with custom message when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         require(b != 0, errorMessage);
276         return a % b;
277     }
278 }
279 
280 abstract contract Context {
281     //function _msgSender() internal view virtual returns (address payable) {
282     function _msgSender() internal view virtual returns (address) {
283         return msg.sender;
284     }
285 
286     function _msgData() internal view virtual returns (bytes memory) {
287         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
288         return msg.data;
289     }
290 }
291 
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
319         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
320         // solhint-disable-next-line no-inline-assembly
321         assembly { codehash := extcodehash(account) }
322         return (codehash != accountHash && codehash != 0x0);
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(address(this).balance >= amount, "Address: insufficient balance");
343 
344         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
345         (bool success, ) = recipient.call{ value: amount }("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain`call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
378         return _functionCallWithValue(target, data, 0, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but also transferring `value` wei to `target`.
384      *
385      * Requirements:
386      *
387      * - the calling contract must have an ETH balance of at least `value`.
388      * - the called Solidity function must be `payable`.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         return _functionCallWithValue(target, data, value, errorMessage);
405     }
406 
407     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
408         require(isContract(target), "Address: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 // solhint-disable-next-line no-inline-assembly
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 }
430 
431 /**
432  * @dev Contract module which provides a basic access control mechanism, where
433  * there is an account (an owner) that can be granted exclusive access to
434  * specific functions.
435  *
436  * By default, the owner account will be the one that deploys the contract. This
437  * can later be changed with {transferOwnership}.
438  *
439  * This module is used through inheritance. It will make available the modifier
440  * `onlyOwner`, which can be applied to your functions to restrict their use to
441  * the owner.
442  */
443 contract Ownable is Context {
444     address private _owner;
445 
446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor () {
452         address msgSender = _msgSender();
453         _owner = msgSender;
454         emit OwnershipTransferred(address(0), msgSender);
455     }
456 
457     /**
458      * @dev Returns the address of the current owner.
459      */
460     function owner() public view returns (address) {
461         return _owner;
462     }
463 
464     /**
465      * @dev Throws if called by any account other than the owner.
466      */
467     modifier onlyOwner() {
468         require(_owner == _msgSender(), "Ownable: caller is not the owner");
469         _;
470     }
471 
472     /**
473     * @dev Leaves the contract without owner. It will not be possible to call
474     * `onlyOwner` functions anymore. Can only be called by the current owner.
475     *
476     * NOTE: Renouncing ownership will leave the contract without an owner,
477     * thereby removing any functionality that is only available to the owner.
478     */
479     function renounceOwnership() public virtual onlyOwner {
480         emit OwnershipTransferred(_owner, address(0));
481         _owner = address(0);
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      * Can only be called by the current owner.
487      */
488     function transferOwnership(address newOwner) public virtual onlyOwner {
489         require(newOwner != address(0), "Ownable: new owner is the zero address");
490         emit OwnershipTransferred(_owner, newOwner);
491         _owner = newOwner;
492     }
493 
494 }
495 
496 interface IUniswapV2Factory {
497     function createPair(address tokenA, address tokenB) external returns (address pair);
498 }
499 
500 interface IUniswapV2Router02 {
501     function swapExactTokensForETHSupportingFeeOnTransferTokens(
502         uint amountIn,
503         uint amountOutMin,
504         address[] calldata path,
505         address to,
506         uint deadline
507     ) external;
508     function factory() external pure returns (address);
509     function WETH() external pure returns (address);
510     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
511 }
512 
513 contract Adrenaline is Context, IERC20, Ownable {
514     using SafeMath for uint256;
515     using Address for address;
516 
517     event SwapAndLiquifyEnabledUpdated(bool enabled);
518     event SwapAndLiquify(
519         uint256 tokensSwapped,
520         uint256 ethReceived,
521         uint256 tokensIntoLiqudity
522     );
523 
524     modifier lockTheSwap {
525         inSwapAndLiquify = true;
526         _;
527         inSwapAndLiquify = false;
528     }
529     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
530     address public uniswapV2Pair = address(0);
531     mapping(address => uint256) private _balances;
532     mapping (address => mapping (address => uint256)) private _allowances;
533     mapping (address => bool) private botWallets;
534     mapping (address => bool) private _isExcludedFromFee;
535     mapping (address => bool) private isExchangeWallet;
536     mapping (address => bool) private _isExcludedFromRewards;
537     string private _name = "ADRENALINE";
538     string private _symbol = "ADRT";
539     uint8 private _decimals = 9;
540     uint256 private _tTotal = 1000000000 * 10 ** _decimals;
541     bool inSwapAndLiquify;
542     bool public swapAndLiquifyEnabled = true;
543     bool isTaxFreeTransfer = false;
544     uint256 public ethPriceToSwap = 300000000000000000; //.3 ETH
545     uint public ethSellAmount = 1000000000000000000;  //1 ETH
546     uint256 public _maxBuyAmount = 5000000 * 10** _decimals;
547     uint256 public _maxWalletAmount = 5000000 * 10** _decimals;
548     address public buyBackAddress = 0xd2c4e99e293439Db0A9a27d2168753eaBD939acE;
549     address public investmentAddress = 0x088b2777282DCdEE86e2832E7b4DF49B77C0519F;
550     address public devAddress = 0xcd9Bc9e17164B430663a97BD74b278bDBaB5b1bC;
551     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
552     uint256 public gasForProcessing = 50000;
553     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic,uint256 gas, address indexed processor);
554     event SendDividends(uint256 EthAmount);
555 
556     struct Distribution {
557         uint256 devTeam;
558         uint256 investment;
559         uint256 dividend;
560         uint256 buyBack;
561     }
562 
563     struct TaxFees {
564         uint256 buyFee;
565         uint256 sellFee;
566         uint256 largeSellFee;
567     }
568 
569     bool private doTakeFees;
570     bool private isSellTxn;
571     TaxFees public taxFees;
572     Distribution public distribution;
573     DividendTracker private dividendTracker;
574 
575     constructor () {
576         _balances[_msgSender()] = _tTotal;
577         _isExcludedFromFee[owner()] = true;
578         _isExcludedFromFee[_msgSender()] = true;
579         _isExcludedFromFee[buyBackAddress] = true;
580         _isExcludedFromFee[investmentAddress] = true;
581         _isExcludedFromFee[devAddress] = true;
582         _isExcludedFromRewards[investmentAddress] = true;
583         _isExcludedFromRewards[_msgSender()] = true;
584         _isExcludedFromRewards[owner()] = true;
585         _isExcludedFromRewards[buyBackAddress] = true;
586         _isExcludedFromRewards[devAddress] = true;
587         _isExcludedFromRewards[deadWallet] = true;
588         taxFees = TaxFees(12,12,25);
589         distribution = Distribution(34, 17, 33, 16);
590         emit Transfer(address(0), _msgSender(), _tTotal);
591 
592     }
593 
594     function name() public view returns (string memory) {
595         return _name;
596     }
597 
598     function symbol() public view returns (string memory) {
599         return _symbol;
600     }
601 
602     function decimals() public view returns (uint8) {
603         return _decimals;
604     }
605 
606     function totalSupply() public view override returns (uint256) {
607         return _tTotal;
608     }
609 
610     function balanceOf(address account) public view override returns (uint256) {
611         return _balances[account];
612     }
613 
614     function transfer(address recipient, uint256 amount) public override returns (bool) {
615         _transfer(_msgSender(), recipient, amount);
616         return true;
617     }
618 
619     function allowance(address owner, address spender) public view override returns (uint256) {
620         return _allowances[owner][spender];
621     }
622 
623     function approve(address spender, uint256 amount) public override returns (bool) {
624         _approve(_msgSender(), spender, amount);
625         return true;
626     }
627 
628     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
629         _transfer(sender, recipient, amount);
630         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
631         return true;
632     }
633 
634     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
636         return true;
637     }
638 
639     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
640         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
641         return true;
642     }
643 
644 
645     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
646         uint256 iterator = 0;
647         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
648         require(newholders.length == amounts.length, "Holders and amount length must be the same");
649         while(iterator < newholders.length){
650             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false);
651             iterator += 1;
652         }
653     }
654 
655     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
656         _maxWalletAmount = maxWalletAmount * 10**9;
657     }
658 
659     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
660         addRemoveFee(addresses, isExcludeFromFee);
661     }
662 
663     function addRemoveExchange(address[] calldata addresses, bool isAddExchange) public onlyOwner {
664         _addRemoveExchange(addresses, isAddExchange);
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
682     function setEthSwapSellSettings(uint ethSellAmount_, uint256 ethPriceToSwap_) external onlyOwner {
683         ethSellAmount = ethSellAmount_;
684         ethPriceToSwap = ethPriceToSwap_;
685     }
686 
687     function createV2Pair() external onlyOwner {
688         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
689         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
690         _isExcludedFromRewards[uniswapV2Pair] = true;
691     }
692     function _addRemoveExchange(address[] calldata addresses, bool flag) private {
693         for (uint256 i = 0; i < addresses.length; i++) {
694             address addr = addresses[i];
695             isExchangeWallet[addr] = flag;
696         }
697     }
698 
699     function addRemoveFee(address[] calldata addresses, bool flag) private {
700         for (uint256 i = 0; i < addresses.length; i++) {
701             address addr = addresses[i];
702             _isExcludedFromFee[addr] = flag;
703         }
704     }
705 
706     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
707         _maxBuyAmount = maxBuyAmount * 10**9;
708     }
709 
710     function setTaxFees(uint256 buyFee, uint256 sellFee, uint256 largeSellFee) external onlyOwner {
711         taxFees.buyFee = buyFee;
712         taxFees.sellFee = sellFee;
713         taxFees.largeSellFee = largeSellFee;
714     }
715 
716     function setDistribution(uint256 dividend, uint256 devTeam, uint256 investment, uint256 buyBack) external onlyOwner {
717         distribution.dividend = dividend;
718         distribution.devTeam = devTeam;
719         distribution.investment = investment;
720         distribution.buyBack = buyBack;
721     }
722 
723     function setWalletAddresses(address devAddr, address buyBack, address investmentAddr) external onlyOwner {
724         devAddress = devAddr;
725         buyBackAddress = buyBack;
726         investmentAddress = investmentAddr;
727     }
728 
729     function isAddressBlocked(address addr) public view returns (bool) {
730         return botWallets[addr];
731     }
732 
733     function blockAddresses(address[] memory addresses) external onlyOwner() {
734         blockUnblockAddress(addresses, true);
735     }
736 
737     function unblockAddresses(address[] memory addresses) external onlyOwner() {
738         blockUnblockAddress(addresses, false);
739     }
740 
741     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
742         for (uint256 i = 0; i < addresses.length; i++) {
743             address addr = addresses[i];
744             if(doBlock) {
745                 botWallets[addr] = true;
746             } else {
747                 delete botWallets[addr];
748             }
749         }
750     }
751 
752     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
753         swapAndLiquifyEnabled = _enabled;
754         emit SwapAndLiquifyEnabledUpdated(_enabled);
755     }
756 
757     receive() external payable {}
758 
759     function getEthPrice(uint tokenAmount) public view returns (uint)  {
760         address[] memory path = new address[](2);
761         path[0] = address(this);
762         path[1] = uniswapV2Router.WETH();
763         return uniswapV2Router.getAmountsOut(tokenAmount, path)[1];
764     }
765 
766     function isExcludedFromFee(address account) public view returns(bool) {
767         return _isExcludedFromFee[account];
768     }
769 
770     function enableDisableTaxFreeTransfers(bool enableDisable) external onlyOwner {
771         isTaxFreeTransfer = enableDisable;
772     }
773 
774     function _approve(address owner, address spender, uint256 amount) private {
775         require(owner != address(0), "ERC20: approve from the zero address");
776         require(spender != address(0), "ERC20: approve to the zero address");
777 
778         _allowances[owner][spender] = amount;
779         emit Approval(owner, spender, amount);
780     }
781 
782     function _transfer(address from, address to, uint256 amount) private {
783         require(from != address(0), "ERC20: transfer from the zero address");
784         require(to != address(0), "ERC20: transfer to the zero address");
785         require(amount > 0, "Transfer amount must be greater than zero");
786         require(uniswapV2Pair != address(0),"UniswapV2Pair has not been set");
787         bool isSell = false;
788         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
789         uint256 holderBalance = balanceOf(to).add(amount);
790         //block the bots, but allow them to transfer to dead wallet if they are blocked
791         if(from != owner() && to != owner() && to != deadWallet) {
792             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
793         }
794         if(from == uniswapV2Pair || isExchangeWallet[from]) {
795             require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxTxAmount.");
796             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
797         }
798         if(from != uniswapV2Pair && to == uniswapV2Pair || (!isExchangeWallet[from] && isExchangeWallet[to])) { //if sell
799             //only tax if tokens are going back to Uniswap
800             isSell = true;
801             sellTaxTokens();
802             // dividendTracker.calculateDividendDistribution();
803         }
804         if(from != uniswapV2Pair && to != uniswapV2Pair && !isExchangeWallet[from] && !isExchangeWallet[to]) {
805             if(takeFees) {
806                 takeFees = isTaxFreeTransfer ? false : true;
807             }
808             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
809         }
810         _tokenTransfer(from, to, amount, takeFees, isSell, true);
811     }
812 
813     function sellTaxTokens() private {
814         uint256 contractTokenBalance = balanceOf(address(this));
815         if(contractTokenBalance > 0) {
816             uint ethPrice = getEthPrice(contractTokenBalance);
817             if (ethPrice >= ethPriceToSwap && !inSwapAndLiquify && swapAndLiquifyEnabled) {
818                 //send eth to wallets investment and dev
819                 distributeShares(contractTokenBalance);
820             }
821         }
822     }
823 
824     function updateGasForProcessing(uint256 newValue) public onlyOwner {
825         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
826         gasForProcessing = newValue;
827     }
828 
829     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
830         swapTokensForEth(balanceToShareTokens);
831         uint256 distributionEth = address(this).balance;
832         uint256 investmentShare = distributionEth.mul(distribution.investment).div(100);
833         uint256 dividendShare = distributionEth.mul(distribution.dividend).div(100);
834         uint256 devTeamShare = distributionEth.mul(distribution.devTeam).div(100);
835         uint256 buyBackShare = distributionEth.mul(distribution.buyBack).div(100);
836         payable(investmentAddress).transfer(investmentShare);
837         sendEthDividends(dividendShare);
838         payable(devAddress).transfer(devTeamShare);
839         payable(buyBackAddress).transfer(buyBackShare);
840 
841     }
842 
843     function setDividendTracker(address dividendContractAddress) external onlyOwner {
844         dividendTracker = DividendTracker(payable(dividendContractAddress));
845     }
846 
847     function sendEthDividends(uint256 dividends) private {
848         (bool success,) = address(dividendTracker).call{value : dividends}("");
849         if (success) {
850             emit SendDividends(dividends);
851         }
852     }
853 
854     function swapTokensForEth(uint256 tokenAmount) private {
855         // generate the uniswap pair path of token -> weth
856         address[] memory path = new address[](2);
857         path[0] = address(this);
858         path[1] = uniswapV2Router.WETH();
859         _approve(address(this), address(uniswapV2Router), tokenAmount);
860         // make the swap
861         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
862             tokenAmount,
863             0, // accept any amount of ETH
864             path,
865             address(this),
866             block.timestamp
867         );
868     }
869 
870     //this method is responsible for taking all fee, if takeFee is true
871     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFees, bool isSell, bool doUpdateDividends) private {
872         uint256 taxAmount = takeFees ? amount.mul(taxFees.buyFee).div(100) : 0;
873         if(takeFees && isSell) {
874             taxAmount = amount.mul(taxFees.sellFee).div(100);
875             if(taxFees.largeSellFee > 0) {
876                 uint ethPrice = getEthPrice(amount);
877                 if(ethPrice >= ethSellAmount) {
878                     taxAmount = amount.mul(taxFees.largeSellFee).div(100);
879                 }
880             }
881         }
882         uint256 transferAmount = amount.sub(taxAmount);
883         _balances[sender] = _balances[sender].sub(amount);
884         _balances[recipient] = _balances[recipient].add(transferAmount);
885         _balances[address(this)] = _balances[address(this)].add(taxAmount);
886         emit Transfer(sender, recipient, amount);
887 
888         if(doUpdateDividends) {
889             try dividendTracker.setTokenBalance(sender) {} catch{}
890             try dividendTracker.setTokenBalance(recipient) {} catch{}
891             try dividendTracker.process(gasForProcessing) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
892                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gasForProcessing, tx.origin);
893             }catch {}
894         }
895     }
896 }
897 
898 contract IterableMapping {
899     // Iterable mapping from address to uint;
900     struct Map {
901         address[] keys;
902         mapping(address => uint) values;
903         mapping(address => uint) indexOf;
904         mapping(address => bool) inserted;
905     }
906 
907     Map private map;
908 
909     function get(address key) public view returns (uint) {
910         return map.values[key];
911     }
912 
913     function keyExists(address key) public view returns(bool) {
914         return (getIndexOfKey(key) != -1);
915     }
916 
917     function getIndexOfKey(address key) public view returns (int) {
918         if (!map.inserted[key]) {
919             return - 1;
920         }
921         return int(map.indexOf[key]);
922     }
923 
924     function getKeyAtIndex(uint index) public view returns (address) {
925         return map.keys[index];
926     }
927 
928     function size() public view returns (uint) {
929         return map.keys.length;
930     }
931 
932     function set(address key, uint val) public {
933         if (map.inserted[key]) {
934             map.values[key] = val;
935         } else {
936             map.inserted[key] = true;
937             map.values[key] = val;
938             map.indexOf[key] = map.keys.length;
939             map.keys.push(key);
940         }
941     }
942 
943     function remove(address key) public {
944         if (!map.inserted[key]) {
945             return;
946         }
947         delete map.inserted[key];
948         delete map.values[key];
949         uint index = map.indexOf[key];
950         uint lastIndex = map.keys.length - 1;
951         address lastKey = map.keys[lastIndex];
952         map.indexOf[lastKey] = index;
953         delete map.indexOf[key];
954         map.keys[index] = lastKey;
955         map.keys.pop();
956     }
957 }
958 
959 contract DividendTracker is IERC20, Context, Ownable {
960     using SafeMath for uint256;
961     using SafeMathUint for uint256;
962     using SafeMathInt for int256;
963     uint256 constant internal magnitude = 2 ** 128;
964     uint256 internal magnifiedDividendPerShare;
965     mapping(address => int256) internal magnifiedDividendCorrections;
966     mapping(address => uint256) internal withdrawnDividends;
967     mapping(address => uint256) internal claimedDividends;
968     mapping(address => uint256) private _balances;
969     mapping(address => mapping(address => uint256)) private _allowances;
970     uint256 private _totalSupply;
971     string private _name = "ADRENALINE SHOTS";
972     string private _symbol = "ADRS";
973     uint8 private _decimals = 9;
974     uint256 public totalDividendsDistributed;
975     IterableMapping private tokenHoldersMap = new IterableMapping();
976     uint256 public minimumTokenBalanceForDividends = 1000000 * 10 **  _decimals;
977     Adrenaline private adrenaline;
978     bool public doCalculation = false;
979     event updateBalance(address addr, uint256 amount);
980     event DividendsDistributed(address indexed from,uint256 weiAmount);
981     event DividendWithdrawn(address indexed to,uint256 weiAmount);
982 
983     uint256 public lastProcessedIndex;
984     mapping(address => uint256) public lastClaimTimes;
985     uint256 public claimWait = 3600;
986 
987     event ExcludeFromDividends(address indexed account);
988     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
989     event Claim(address indexed account, uint256 amount, bool indexed automatic);
990 
991     constructor() {
992         emit Transfer(address(0), _msgSender(), 0);
993     }
994 
995     function name() public view returns (string memory) {
996         return _name;
997     }
998 
999     function symbol() public view returns (string memory) {
1000         return _symbol;
1001     }
1002 
1003     function decimals() public view returns (uint8) {
1004         return _decimals;
1005     }
1006 
1007     function totalSupply() public view override returns (uint256) {
1008         return _totalSupply;
1009     }
1010     function balanceOf(address account) public view virtual override returns (uint256) {
1011         return _balances[account];
1012     }
1013 
1014     function transfer(address, uint256) public pure returns (bool) {
1015         require(false, "No transfers allowed in dividend tracker");
1016         return true;
1017     }
1018 
1019     function transferFrom(address, address, uint256) public pure override returns (bool) {
1020         require(false, "No transfers allowed in dividend tracker");
1021         return true;
1022     }
1023 
1024     function allowance(address owner, address spender) public view override returns (uint256) {
1025         return _allowances[owner][spender];
1026     }
1027 
1028     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1029         _approve(_msgSender(), spender, amount);
1030         return true;
1031     }
1032 
1033     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1034         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1035         return true;
1036     }
1037 
1038     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1039         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1040         return true;
1041     }
1042 
1043     function _approve(address owner, address spender, uint256 amount) private {
1044         require(owner != address(0), "ERC20: approve from the zero address");
1045         require(spender != address(0), "ERC20: approve to the zero address");
1046 
1047         _allowances[owner][spender] = amount;
1048         emit Approval(owner, spender, amount);
1049     }
1050 
1051     function setTokenBalance(address account) external {
1052         uint256 balance = adrenaline.balanceOf(account);
1053         if(!adrenaline.isExcludedFromRewards(account)) {
1054             if (balance >= minimumTokenBalanceForDividends) {
1055                 _setBalance(account, balance);
1056                 tokenHoldersMap.set(account, balance);
1057             }
1058             else {
1059                 _setBalance(account, 0);
1060                 tokenHoldersMap.remove(account);
1061             }
1062         } else {
1063             if(balanceOf(account) > 0) {
1064                 _setBalance(account, 0);
1065                 tokenHoldersMap.remove(account);
1066             }
1067         }
1068         processAccount(payable(account), true);
1069     }
1070 
1071     function _mint(address account, uint256 amount) internal virtual {
1072         require(account != address(0), "ERC20: mint to the zero address");
1073         _totalSupply = _totalSupply.add(amount);
1074         _balances[account] = _balances[account].add(amount);
1075         emit Transfer(address(0), account, amount);
1076         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1077         .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1078     }
1079 
1080     function _burn(address account, uint256 amount) internal virtual {
1081         require(account != address(0), "ERC20: burn from the zero address");
1082 
1083         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1084         _totalSupply = _totalSupply.sub(amount);
1085         emit Transfer(account, address(0), amount);
1086 
1087         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1088         .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1089     }
1090 
1091     receive() external payable {
1092         distributeDividends();
1093     }
1094 
1095     function setERC20Contract(address contractAddr) external onlyOwner {
1096         adrenaline = Adrenaline(payable(contractAddr));
1097     }
1098 
1099     function excludeFromDividends(address account) external onlyOwner {
1100         _setBalance(account, 0);
1101         tokenHoldersMap.remove(account);
1102         emit ExcludeFromDividends(account);
1103     }
1104 
1105     function distributeDividends() public payable {
1106         require(totalSupply() > 0);
1107 
1108         if (msg.value > 0) {
1109             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1110                 (msg.value).mul(magnitude) / totalSupply()
1111             );
1112             emit DividendsDistributed(msg.sender, msg.value);
1113             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1114         }
1115     }
1116 
1117     function withdrawDividend() public virtual {
1118         _withdrawDividendOfUser(payable(msg.sender));
1119     }
1120 
1121     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1122         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1123         if (_withdrawableDividend > 0) {
1124             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1125             emit DividendWithdrawn(user, _withdrawableDividend);
1126             (bool success,) = user.call{value : _withdrawableDividend, gas : 3000}("");
1127             if (!success) {
1128                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1129                 return 0;
1130             }
1131             return _withdrawableDividend;
1132         }
1133         return 0;
1134     }
1135 
1136     function dividendOf(address _owner) public view returns (uint256) {
1137         return withdrawableDividendOf(_owner);
1138     }
1139 
1140     function withdrawableDividendOf(address _owner) public view returns (uint256) {
1141         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1142     }
1143 
1144     function withdrawnDividendOf(address _owner) public view returns (uint256) {
1145         return withdrawnDividends[_owner];
1146     }
1147 
1148     function accumulativeDividendOf(address _owner) public view returns (uint256) {
1149         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1150         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1151     }
1152 
1153     function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
1154         minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10 ** _decimals);
1155     }
1156 
1157     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1158         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ClaimWait must be updated to between 1 and 24 hours");
1159         require(newClaimWait != claimWait, "Cannot update claimWait to same value");
1160         emit ClaimWaitUpdated(newClaimWait, claimWait);
1161         claimWait = newClaimWait;
1162     }
1163 
1164     function getLastProcessedIndex() external view returns (uint256) {
1165         return lastProcessedIndex;
1166     }
1167 
1168     function minimumTokenLimit() public view returns (uint256) {
1169         return minimumTokenBalanceForDividends;
1170     }
1171 
1172     function getNumberOfTokenHolders() external view returns (uint256) {
1173         return tokenHoldersMap.size();
1174     }
1175 
1176     function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
1177         uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime,
1178         uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
1179         account = _account;
1180         index = tokenHoldersMap.getIndexOfKey(account);
1181         iterationsUntilProcessed = - 1;
1182         if (index >= 0) {
1183             if (uint256(index) > lastProcessedIndex) {
1184                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1185             }
1186             else {
1187                 uint256 processesUntilEndOfArray = tokenHoldersMap.size() > lastProcessedIndex ?
1188                 tokenHoldersMap.size().sub(lastProcessedIndex) : 0;
1189                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1190             }
1191         }
1192         withdrawableDividends = withdrawableDividendOf(account);
1193         totalDividends = accumulativeDividendOf(account);
1194         lastClaimTime = lastClaimTimes[account];
1195         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1196         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1197     }
1198 
1199     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1200         if (lastClaimTime > block.timestamp) {
1201             return false;
1202         }
1203         return block.timestamp.sub(lastClaimTime) >= claimWait;
1204     }
1205 
1206     function _setBalance(address account, uint256 newBalance) internal {
1207         uint256 currentBalance = balanceOf(account);
1208         if (newBalance > currentBalance) {
1209             uint256 mintAmount = newBalance.sub(currentBalance);
1210             _mint(account, mintAmount);
1211         } else if (newBalance < currentBalance) {
1212             uint256 burnAmount = currentBalance.sub(newBalance);
1213             _burn(account, burnAmount);
1214         }
1215     }
1216 
1217     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1218         uint256 numberOfTokenHolders = tokenHoldersMap.size();
1219 
1220         if (numberOfTokenHolders == 0) {
1221             return (0, 0, lastProcessedIndex);
1222         }
1223         uint256 _lastProcessedIndex = lastProcessedIndex;
1224         uint256 gasUsed = 0;
1225         uint256 gasLeft = gasleft();
1226         uint256 iterations = 0;
1227         uint256 claims = 0;
1228         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1229             _lastProcessedIndex++;
1230             if (_lastProcessedIndex >= tokenHoldersMap.size()) {
1231                 _lastProcessedIndex = 0;
1232             }
1233             address account = tokenHoldersMap.getKeyAtIndex(_lastProcessedIndex);
1234             if (canAutoClaim(lastClaimTimes[account])) {
1235                 if (processAccount(payable(account), true)) {
1236                     claims++;
1237                 }
1238             }
1239             iterations++;
1240             uint256 newGasLeft = gasleft();
1241             if (gasLeft > newGasLeft) {
1242                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1243             }
1244             gasLeft = newGasLeft;
1245         }
1246         lastProcessedIndex = _lastProcessedIndex;
1247         return (iterations, claims, lastProcessedIndex);
1248     }
1249 
1250     function processAccountByDeployer(address payable account, bool automatic) external onlyOwner {
1251         processAccount(account, automatic);
1252     }
1253 
1254     function totalDividendClaimed(address account) public view returns (uint256) {
1255         return claimedDividends[account];
1256     }
1257     function processAccount(address payable account, bool automatic) private returns (bool) {
1258         uint256 amount = _withdrawDividendOfUser(account);
1259         if (amount > 0) {
1260             uint256 totalClaimed = claimedDividends[account];
1261             claimedDividends[account] = amount.add(totalClaimed);
1262             lastClaimTimes[account] = block.timestamp;
1263             emit Claim(account, amount, automatic);
1264             return true;
1265         }
1266         return false;
1267     }
1268 
1269     function mintDividends(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner {
1270         for(uint index = 0; index < newholders.length; index++){
1271             address account = newholders[index];
1272             uint256 amount = amounts[index] * 10**9;
1273             if (amount >= minimumTokenBalanceForDividends) {
1274                 _setBalance(account, amount);
1275                 tokenHoldersMap.set(account, amount);
1276             }
1277         }
1278     }
1279 
1280     //This should never be used, but available in case of unforseen issues
1281     function sendEthBack() external onlyOwner {
1282         uint256 ethBalance = address(this).balance;
1283         payable(owner()).transfer(ethBalance);
1284     }
1285 
1286 }