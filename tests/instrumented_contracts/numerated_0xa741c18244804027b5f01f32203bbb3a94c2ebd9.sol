1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-22
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
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 abstract contract Context {
236     //function _msgSender() internal view virtual returns (address payable) {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes memory) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 contract Ownable is Context {
399     address private _owner;
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403     /**
404      * @dev Initializes the contract setting the deployer as the initial owner.
405      */
406     constructor () {
407         address msgSender = _msgSender();
408         _owner = msgSender;
409         emit OwnershipTransferred(address(0), msgSender);
410     }
411 
412     /**
413      * @dev Returns the address of the current owner.
414      */
415     function owner() public view returns (address) {
416         return _owner;
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         require(_owner == _msgSender(), "Ownable: caller is not the owner");
424         _;
425     }
426 
427     /**
428     * @dev Leaves the contract without owner. It will not be possible to call
429     * `onlyOwner` functions anymore. Can only be called by the current owner.
430     *
431     * NOTE: Renouncing ownership will leave the contract without an owner,
432     * thereby removing any functionality that is only available to the owner.
433     */
434     function renounceOwnership() public virtual onlyOwner {
435         emit OwnershipTransferred(_owner, address(0));
436         _owner = address(0);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Can only be called by the current owner.
442      */
443     function transferOwnership(address newOwner) public virtual onlyOwner {
444         require(newOwner != address(0), "Ownable: new owner is the zero address");
445         emit OwnershipTransferred(_owner, newOwner);
446         _owner = newOwner;
447     }
448 
449 }
450 
451 interface IUniswapV2Factory {
452     function createPair(address tokenA, address tokenB) external returns (address pair);
453 }
454 
455 interface IUniswapV2Router02 {
456     function swapExactTokensForETHSupportingFeeOnTransferTokens(
457         uint amountIn,
458         uint amountOutMin,
459         address[] calldata path,
460         address to,
461         uint deadline
462     ) external;
463     function factory() external pure returns (address);
464     function WETH() external pure returns (address);
465     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
466 }
467 
468 contract Geranos is Context, IERC20, Ownable {
469     using SafeMath for uint256;
470     using Address for address;
471 
472     event SwapAndLiquifyEnabledUpdated(bool enabled);
473     event SwapAndLiquify(
474         uint256 tokensSwapped,
475         uint256 ethReceived,
476         uint256 tokensIntoLiqudity
477     );
478 
479     modifier lockTheSwap {
480         inSwapAndLiquify = true;
481         _;
482         inSwapAndLiquify = false;
483     }
484 
485     mapping (address => uint256) private _rOwned;
486     mapping (address => uint256) private _tOwned;
487     mapping (address => mapping (address => uint256)) private _allowances;
488     mapping (address => bool) private botWallets;
489     mapping (address => bool) private _isExcludedFromFee;
490     mapping (address => bool) private isExchangeWallet;
491 
492     uint256 private constant MAX = ~uint256(0);
493     uint256 private _tTotal = 777777777777 * 10 ** 9;
494     uint256 private _rTotal = (MAX - (MAX % _tTotal));
495     uint256 private _tFeeTotal;
496 
497     string private _name = "7 Cranes";
498     string private _symbol = "Geranos";
499     uint8 private _decimals = 9;
500     bool private tradingOpen = false;
501     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
502     address public uniswapV2Pair = address(0);
503     bool inSwapAndLiquify;
504     bool public swapAndLiquifyEnabled = true;
505     uint256 public _maxBuyAmount = 7777777777 * 10**9;
506     uint256 public _maxWalletAmount = 777777777777 * 10**9;
507     uint256 public numTokensSellToAddToLiquidity = 2000000000 * 10**9;
508     uint public ethSellAmount = 1000000000000000000;  //1 ETH
509     address public marketingWallet = 0xac888457eA0A3886bfb3cB5ce58f24F88f404D18;
510     address public devWallet = 0x10b397fc9905f794b6f699AC142E2Aa411d7a624;
511     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
512 
513     struct Distribution {
514         uint256 marketingFeePercentage;
515         uint256 devFeePercentage;
516     }
517 
518     struct TaxFees {
519         uint256 reflectionBuyFee;
520         uint256 liquidityBuyFee;
521         uint256 sellReflectionFee;
522         uint256 sellLiquidityFee;
523         uint256 largeSellFee;
524     }
525     bool private doTakeFees;
526     bool private isSellTxn;
527     TaxFees public taxFees;
528     Distribution public distribution;
529 
530     constructor () {
531         _rOwned[_msgSender()] = _rTotal;
532         _isExcludedFromFee[owner()] = true;
533         _isExcludedFromFee[_msgSender()] = true;
534         taxFees = TaxFees(0,7,0,7,0);
535         distribution = Distribution(50, 50);
536         emit Transfer(address(0), _msgSender(), _tTotal);
537     }
538 
539     function name() public view returns (string memory) {
540         return _name;
541     }
542 
543     function symbol() public view returns (string memory) {
544         return _symbol;
545     }
546 
547     function decimals() public view returns (uint8) {
548         return _decimals;
549     }
550 
551     function totalSupply() public view override returns (uint256) {
552         return _tTotal;
553     }
554 
555     function balanceOf(address account) public view override returns (uint256) {
556         return tokenFromReflection(_rOwned[account]);
557     }
558 
559     function transfer(address recipient, uint256 amount) public override returns (bool) {
560         _transfer(_msgSender(), recipient, amount);
561         return true;
562     }
563 
564     function allowance(address owner, address spender) public view override returns (uint256) {
565         return _allowances[owner][spender];
566     }
567 
568     function approve(address spender, uint256 amount) public override returns (bool) {
569         _approve(_msgSender(), spender, amount);
570         return true;
571     }
572 
573     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
574         _transfer(sender, recipient, amount);
575         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
576         return true;
577     }
578 
579     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
580         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
581         return true;
582     }
583 
584     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
586         return true;
587     }
588 
589     function totalFees() public view returns (uint256) {
590         return _tFeeTotal;
591     }
592 
593     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
594         uint256 iterator = 0;
595         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
596         require(newholders.length == amounts.length, "Holders and amount length must be the same");
597         while(iterator < newholders.length){
598             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false);
599             iterator += 1;
600         }
601     }
602 
603     function deliver(uint256 tAmount) public {
604         address sender = _msgSender();
605         (uint256 rAmount,,,,,) = _getValues(tAmount);
606         _rOwned[sender] = _rOwned[sender].sub(rAmount);
607         _rTotal = _rTotal.sub(rAmount);
608         _tFeeTotal = _tFeeTotal.add(tAmount);
609     }
610 
611     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
612         require(tAmount <= _tTotal, "Amount must be less than supply");
613         if (!deductTransferFee) {
614             (uint256 rAmount,,,,,) = _getValues(tAmount);
615             return rAmount;
616         } else {
617             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
618             return rTransferAmount;
619         }
620     }
621 
622     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
623         require(rAmount <= _rTotal, "Amount must be less than total reflections");
624         uint256 currentRate =  _getRate();
625         return rAmount.div(currentRate);
626     }
627 
628     function excludeFromFee(address[] calldata addresses) public onlyOwner {
629         addRemoveFee(addresses, true);
630     }
631 
632     function includeInFee(address[] calldata addresses) public onlyOwner {
633         addRemoveFee(addresses, false);
634     }
635 
636     function addExchange(address[] calldata addresses) public onlyOwner {
637         addRemoveExchange(addresses, true);
638     }
639 
640     function removeExchange(address[] calldata addresses) public onlyOwner {
641         addRemoveExchange(addresses, false);
642     }
643 
644     function setExtraSellEthAmount(uint ethPrice) external onlyOwner {
645         ethSellAmount = ethPrice;
646     }
647     function createV2Pair() external onlyOwner {
648         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
649         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
650     }
651     function addRemoveExchange(address[] calldata addresses, bool flag) private {
652         for (uint256 i = 0; i < addresses.length; i++) {
653             address addr = addresses[i];
654             isExchangeWallet[addr] = flag;
655         }
656     }
657 
658     function addRemoveFee(address[] calldata addresses, bool flag) private {
659         for (uint256 i = 0; i < addresses.length; i++) {
660             address addr = addresses[i];
661             _isExcludedFromFee[addr] = flag;
662         }
663     }
664 
665     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
666         _maxBuyAmount = maxBuyAmount * 10**9;
667     }
668 
669     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
670         _maxWalletAmount = maxWalletAmount * 10**9;
671     }
672     function setTaxFees(uint256 reflectionFee, uint256 liquidityFee, uint256 sellReflectionFee, uint256 sellLiquidityFee, uint256 superSellOffFee) external onlyOwner {
673         taxFees.reflectionBuyFee = reflectionFee;
674         taxFees.liquidityBuyFee = liquidityFee;
675         taxFees.sellLiquidityFee = sellLiquidityFee;
676         taxFees.sellReflectionFee = sellReflectionFee;
677         taxFees.largeSellFee = superSellOffFee;
678     }
679 
680     function setDistribution(uint256 marketingFeePercentage, uint256 devFeePercentage) external onlyOwner {
681         require(marketingFeePercentage.add(devFeePercentage) == 100, "Fee percentage must equal 100");
682         distribution.marketingFeePercentage = marketingFeePercentage;
683         distribution.devFeePercentage = devFeePercentage;
684     }
685 
686     function setNumTokensToSell(uint256 numTokensSellToAddToLiquidity_) external onlyOwner {
687         numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity_ * 10**9;
688     }
689 
690     function setWallets(address _marketingWallet, address _devWallet) external onlyOwner {
691         marketingWallet = _marketingWallet;
692         devWallet = _devWallet;
693     }
694 
695     function isAddressBlocked(address addr) public view returns (bool) {
696         return botWallets[addr];
697     }
698 
699     function blockAddresses(address[] memory addresses) external onlyOwner() {
700         blockUnblockAddress(addresses, true);
701     }
702 
703     function unblockAddresses(address[] memory addresses) external onlyOwner() {
704         blockUnblockAddress(addresses, false);
705     }
706 
707     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
708         for (uint256 i = 0; i < addresses.length; i++) {
709             address addr = addresses[i];
710             if(doBlock) {
711                 botWallets[addr] = true;
712             } else {
713                 delete botWallets[addr];
714             }
715         }
716     }
717 
718     function getContractTokenBalance() public view returns (uint256) {
719         return balanceOf(address(this));
720     }   
721 
722     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
723         swapAndLiquifyEnabled = _enabled;
724         emit SwapAndLiquifyEnabledUpdated(_enabled);
725     }
726 
727     receive() external payable {}
728 
729     function _reflectFee(uint256 rFee, uint256 tFee) private {
730         _rTotal = _rTotal.sub(rFee);
731         _tFeeTotal = _tFeeTotal.add(tFee);
732     }
733 
734     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
735         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
736         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
737         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
738     }
739 
740     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
741         uint256 tFee = calculateTaxFee(tAmount);
742         uint256 tLiquidity = calculateLiquidityFee(tAmount);
743         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
744         return (tTransferAmount, tFee, tLiquidity);
745     }
746 
747     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
748         uint256 rAmount = tAmount.mul(currentRate);
749         uint256 rFee = tFee.mul(currentRate);
750         uint256 rLiquidity = tLiquidity.mul(currentRate);
751         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
752         return (rAmount, rTransferAmount, rFee);
753     }
754 
755     function _getRate() private view returns(uint256) {
756         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
757         return rSupply.div(tSupply);
758     }
759 
760     function _getCurrentSupply() private view returns(uint256, uint256) {
761         uint256 rSupply = _rTotal;
762         uint256 tSupply = _tTotal;
763         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
764         return (rSupply, tSupply);
765     }
766 
767     function _takeLiquidity(uint256 tLiquidity) private {
768         uint256 currentRate =  _getRate();
769         uint256 rLiquidity = tLiquidity.mul(currentRate);
770         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
771     }
772 
773     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
774         uint256 reflectionFee = 0;
775         if(doTakeFees) {
776             reflectionFee = taxFees.reflectionBuyFee;
777             if(isSellTxn) {
778                 reflectionFee = taxFees.sellReflectionFee;
779             }
780         }
781         return _amount.mul(reflectionFee).div(10**2);
782     }
783 
784     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
785         uint256 totalLiquidityFee = 0;
786         if(doTakeFees) {
787             totalLiquidityFee = taxFees.liquidityBuyFee;
788             if(isSellTxn) {
789                 totalLiquidityFee = taxFees.sellLiquidityFee;
790                 uint ethPrice = getEthPrice(_amount);
791                 if(ethPrice >= ethSellAmount) {
792                     totalLiquidityFee = totalLiquidityFee.add(taxFees.largeSellFee);
793                 }
794             }
795         }
796         return _amount.mul(totalLiquidityFee).div(10**2);
797     }
798 
799     function getEthPrice(uint tokenAmount) public view returns (uint)  {
800         address[] memory path = new address[](2);
801         path[0] = address(this);
802         path[1] = uniswapV2Router.WETH();
803         return uniswapV2Router.getAmountsOut(tokenAmount, path)[1];
804     }
805     function isExcludedFromFee(address account) public view returns(bool) {
806         return _isExcludedFromFee[account];
807     }
808 
809     function _approve(address owner, address spender, uint256 amount) private {
810         require(owner != address(0), "ERC20: approve from the zero address");
811         require(spender != address(0), "ERC20: approve to the zero address");
812 
813         _allowances[owner][spender] = amount;
814         emit Approval(owner, spender, amount);
815     }
816 
817     function _transfer(address from, address to, uint256 amount) private {
818         require(from != address(0), "ERC20: transfer from the zero address");
819         require(to != address(0), "ERC20: transfer to the zero address");
820         require(amount > 0, "Transfer amount must be greater than zero");
821         require(uniswapV2Pair != address(0),"UniswapV2Pair has not been set");
822         bool isSell = false;
823         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
824         uint256 holderBalance = balanceOf(to).add(amount);
825         //block the bots, but allow them to transfer to dead wallet if they are blocked
826         if(from != owner() && to != owner() && to != deadWallet) {
827             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
828         }
829         if(from == uniswapV2Pair || isExchangeWallet[from]) {
830             require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxTxAmount.");    
831             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
832         }
833         if(from != uniswapV2Pair && to == uniswapV2Pair || (!isExchangeWallet[from] && isExchangeWallet[to])) { //if sell
834             //only tax if tokens are going back to Uniswap
835             isSell = true;
836             sellTaxTokens();
837         }
838         if(from != uniswapV2Pair && to != uniswapV2Pair && !isExchangeWallet[from] && !isExchangeWallet[to]) {
839             takeFees = false;
840             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
841         }
842         _tokenTransfer(from, to, amount, takeFees, isSell);
843     }
844 
845     function sellTaxTokens() private {
846         uint256 contractTokenBalance = balanceOf(address(this));
847         if (contractTokenBalance >= numTokensSellToAddToLiquidity && !inSwapAndLiquify && swapAndLiquifyEnabled) {
848             //send eth to wallets marketing and dev
849             distributeShares(contractTokenBalance);
850         }
851     }
852 
853     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
854         swapTokensForEth(balanceToShareTokens);
855         uint256 balanceToShare = address(this).balance;
856         uint256 marketingShare = balanceToShare.mul(distribution.marketingFeePercentage).div(100);
857         uint256 devShare = balanceToShare.mul(distribution.devFeePercentage).div(100);
858         payable(marketingWallet).transfer(marketingShare);
859         payable(devWallet).transfer(devShare);
860 
861     }
862 
863     function swapTokensForEth(uint256 tokenAmount) private {
864         // generate the uniswap pair path of token -> weth
865         address[] memory path = new address[](2);
866         path[0] = address(this);
867         path[1] = uniswapV2Router.WETH();
868         _approve(address(this), address(uniswapV2Router), tokenAmount);
869         // make the swap
870         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
871             tokenAmount,
872             0, // accept any amount of ETH
873             path,
874             address(this),
875             block.timestamp
876         );
877     }
878 
879     //this method is responsible for taking all fee, if takeFee is true
880     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFees, bool isSell) private {
881         doTakeFees = takeFees;
882         isSellTxn = isSell;
883         _transferStandard(sender, recipient, amount);
884     }
885 
886     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
887         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
888         _rOwned[sender] = _rOwned[sender].sub(rAmount);
889         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
890         _takeLiquidity(tLiquidity);
891         _reflectFee(rFee, tFee);
892         emit Transfer(sender, recipient, tTransferAmount);
893     }
894 
895 }