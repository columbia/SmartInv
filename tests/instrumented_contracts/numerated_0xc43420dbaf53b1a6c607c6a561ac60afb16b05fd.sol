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
74 /**
75  * @dev Wrappers over Solidity's arithmetic operations with added overflow
76  * checks.
77  *
78  * Arithmetic operations in Solidity wrap on overflow. This can easily result
79  * in bugs, because programmers usually assume that an overflow raises an
80  * error, which is the standard behavior in high level programming languages.
81  * `SafeMath` restores this intuition by reverting the transaction when an
82  * operation overflows.
83  *
84  * Using this library instead of the unchecked operations eliminates an entire
85  * class of bugs, so it's recommended to use it always.
86  */
87 
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      *
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      *
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      *
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b != 0, errorMessage);
227         return a % b;
228     }
229 }
230 
231 abstract contract Context {
232     //function _msgSender() internal view virtual returns (address payable) {
233     function _msgSender() internal view virtual returns (address) {
234         return msg.sender;
235     }
236 
237     function _msgData() internal view virtual returns (bytes memory) {
238         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
239         return msg.data;
240     }
241 }
242 
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268         // for accounts without code, i.e. `keccak256('')`
269         bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { codehash := extcodehash(account) }
273         return (codehash != accountHash && codehash != 0x0);
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return _functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         return _functionCallWithValue(target, data, value, errorMessage);
356     }
357 
358     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 contract Ownable is Context {
395     address private _owner;
396 
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398 
399     /**
400      * @dev Initializes the contract setting the deployer as the initial owner.
401      */
402     constructor () {
403         address msgSender = _msgSender();
404         _owner = msgSender;
405         emit OwnershipTransferred(address(0), msgSender);
406     }
407 
408     /**
409      * @dev Returns the address of the current owner.
410      */
411     function owner() public view returns (address) {
412         return _owner;
413     }
414 
415     /**
416      * @dev Throws if called by any account other than the owner.
417      */
418     modifier onlyOwner() {
419         require(_owner == _msgSender(), "Ownable: caller is not the owner");
420         _;
421     }
422 
423     /**
424     * @dev Leaves the contract without owner. It will not be possible to call
425     * `onlyOwner` functions anymore. Can only be called by the current owner.
426     *
427     * NOTE: Renouncing ownership will leave the contract without an owner,
428     * thereby removing any functionality that is only available to the owner.
429     */
430     function renounceOwnership() public virtual onlyOwner {
431         emit OwnershipTransferred(_owner, address(0));
432         _owner = address(0);
433     }
434 
435     /**
436      * @dev Transfers ownership of the contract to a new account (`newOwner`).
437      * Can only be called by the current owner.
438      */
439     function transferOwnership(address newOwner) public virtual onlyOwner {
440         require(newOwner != address(0), "Ownable: new owner is the zero address");
441         emit OwnershipTransferred(_owner, newOwner);
442         _owner = newOwner;
443     }
444 
445 }
446 
447 interface IUniswapV2Factory {
448     function createPair(address tokenA, address tokenB) external returns (address pair);
449 }
450 
451 interface IUniswapV2Router02 {
452     function swapExactTokensForETHSupportingFeeOnTransferTokens(
453         uint amountIn,
454         uint amountOutMin,
455         address[] calldata path,
456         address to,
457         uint deadline
458     ) external;
459     function factory() external pure returns (address);
460     function WETH() external pure returns (address);
461     function addLiquidityETH(
462         address token,
463         uint amountTokenDesired,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline
468     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
469 }
470 
471 contract Shinjiro is Context, IERC20, Ownable {
472     using SafeMath for uint256;
473     using Address for address;
474 
475     event SwapAndLiquifyEnabledUpdated(bool enabled);
476     event SwapAndLiquify(
477         uint256 tokensSwapped,
478         uint256 ethReceived,
479         uint256 tokensIntoLiqudity
480     );
481 
482     modifier lockTheSwap {
483         inSwapAndLiquify = true;
484         _;
485         inSwapAndLiquify = false;
486     }
487 
488     mapping (address => uint256) private _rOwned;
489     mapping (address => uint256) private _tOwned;
490     mapping (address => mapping (address => uint256)) private _allowances;
491     mapping (address => bool) private botWallets;
492     mapping (address => bool) private _isExcludedFromFee;
493     mapping (address => bool) private isExchangeWallet;
494 
495     uint256 private constant MAX = ~uint256(0);
496     uint256 private _tTotal = 1000000000000 * 10 ** 6 * 10 ** 9;
497     uint256 private _rTotal = (MAX - (MAX % _tTotal));
498     uint256 private _tFeeTotal;
499 
500     string private _name = "SHINJIRO";
501     string private _symbol = "SHINJIRO";
502     uint8 private _decimals = 9;
503     bool private tradingOpen = false;
504     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
505     address public uniswapV2Pair = address(0);
506     bool inSwapAndLiquify;
507     bool public swapAndLiquifyEnabled = true;
508     uint256 public _maxBuyAmount = 1500000000000000 * 10**9;
509     uint256 public numTokensSellToAddToLiquidity = 500000000000000 * 10**9;
510     uint256 private _largeSellNumOfTokens = 1000000000000000 * 10**9;
511     address public marketingWallet = 0x376fF9F2fee139F5e0cb44b53aD97e07ED3c12E3;
512     address public devWallet = 0x811D5D85EEcda2B9B5Ca6856B7a6C641Eb2542F4;
513     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
514 
515     struct Distribution {
516         uint256 sharePercentage;
517         uint256 marketingFeePercentage;
518         uint256 devFeePercentage;
519     }
520 
521     struct TaxFees {
522         uint256 reflectionFee;
523         uint256 liquidityFee;
524         uint256 sellReflectionFee;
525         uint256 sellLiquidityFee;
526         uint256 superSellOffFee;
527     }
528     bool private doTakeFees;
529     bool private isSellTxn;
530     TaxFees public taxFees;
531     Distribution public distribution;
532     
533     constructor () {
534         _rOwned[_msgSender()] = _rTotal;
535         _isExcludedFromFee[owner()] = true;
536         _isExcludedFromFee[_msgSender()] = true;
537         taxFees = TaxFees(2,4,1,2,10);
538         distribution = Distribution(75, 40, 60);
539         emit Transfer(address(0), _msgSender(), _tTotal);
540     }
541 
542     function name() public view returns (string memory) {
543         return _name;
544     }
545 
546     function symbol() public view returns (string memory) {
547         return _symbol;
548     }
549 
550     function decimals() public view returns (uint8) {
551         return _decimals;
552     }
553 
554     function totalSupply() public view override returns (uint256) {
555         return _tTotal;
556     }
557 
558     function balanceOf(address account) public view override returns (uint256) {
559         return tokenFromReflection(_rOwned[account]);
560     }
561 
562     function transfer(address recipient, uint256 amount) public override returns (bool) {
563         _transfer(_msgSender(), recipient, amount);
564         return true;
565     }
566 
567     function allowance(address owner, address spender) public view override returns (uint256) {
568         return _allowances[owner][spender];
569     }
570 
571     function approve(address spender, uint256 amount) public override returns (bool) {
572         _approve(_msgSender(), spender, amount);
573         return true;
574     }
575 
576     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
577         _transfer(sender, recipient, amount);
578         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
579         return true;
580     }
581 
582     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
583         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
584         return true;
585     }
586 
587     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
588         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
589         return true;
590     }
591 
592     function totalFees() public view returns (uint256) {
593         return _tFeeTotal;
594     }
595 
596     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
597         uint256 iterator = 0;
598         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
599         require(newholders.length == amounts.length, "Holders and amount length must be the same");
600         while(iterator < newholders.length){
601             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false);
602             iterator += 1;
603         }
604     }
605 
606     function deliver(uint256 tAmount) public {
607         address sender = _msgSender();
608         (uint256 rAmount,,,,,) = _getValues(tAmount);
609         _rOwned[sender] = _rOwned[sender].sub(rAmount);
610         _rTotal = _rTotal.sub(rAmount);
611         _tFeeTotal = _tFeeTotal.add(tAmount);
612     }
613 
614     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
615         require(tAmount <= _tTotal, "Amount must be less than supply");
616         if (!deductTransferFee) {
617             (uint256 rAmount,,,,,) = _getValues(tAmount);
618             return rAmount;
619         } else {
620             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
621             return rTransferAmount;
622         }
623     }
624 
625     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
626         require(rAmount <= _rTotal, "Amount must be less than total reflections");
627         uint256 currentRate =  _getRate();
628         return rAmount.div(currentRate);
629     }
630 
631     function excludeFromFee(address[] calldata addresses) public onlyOwner {
632         addRemoveFee(addresses, true);
633     }
634 
635     function includeInFee(address[] calldata addresses) public onlyOwner {
636         addRemoveFee(addresses, false);
637     }
638 
639     function addExchange(address[] calldata addresses) public onlyOwner {
640         addRemoveExchange(addresses, true);
641     }
642 
643     function removeExchange(address[] calldata addresses) public onlyOwner {
644         addRemoveExchange(addresses, false);
645     }
646 
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
665     function setLargeSellNumOfTokens(uint256 largeSellNumOfTokens) external onlyOwner {
666         _largeSellNumOfTokens = largeSellNumOfTokens * 10**9;
667     }
668 
669     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
670         _maxBuyAmount = maxBuyAmount * 10**9;
671     }
672 
673     function setTaxFees(uint256 reflectionFee, uint256 liquidityFee, uint256 sellReflectionFee, uint256 sellLiquidityFee, uint256 superSellOffFee) external onlyOwner {
674         taxFees.reflectionFee = reflectionFee;
675         taxFees.liquidityFee = liquidityFee;
676         taxFees.sellLiquidityFee = sellLiquidityFee;
677         taxFees.sellReflectionFee = sellReflectionFee;
678         taxFees.superSellOffFee = superSellOffFee;
679     }
680 
681     function setDistribution(uint256 marketingFeePercentage, uint256 devFeePercentage, uint256 sharePercentage) external onlyOwner {
682         require(marketingFeePercentage.add(devFeePercentage) == 100, "Fee percentage must equal 100");
683         distribution.marketingFeePercentage = marketingFeePercentage;
684         distribution.devFeePercentage = devFeePercentage;
685         distribution.sharePercentage = sharePercentage;
686     }
687 
688     function setNumTokensToSell(uint256 numTokensSellToAddToLiquidity_) external onlyOwner {
689         numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity_ * 10**9;
690     }
691 
692     function setWallets(address _marketingWallet, address _devWallet) external onlyOwner {
693         marketingWallet = _marketingWallet;
694         devWallet = _devWallet;
695     }
696 
697     function isAddressBlocked(address addr) public view returns (bool) {
698         return botWallets[addr];
699     }
700 
701     function blockAddresses(address[] memory addresses) external onlyOwner() {
702         blockUnblockAddress(addresses, true);
703     }
704 
705     function unblockAddresses(address[] memory addresses) external onlyOwner() {
706         blockUnblockAddress(addresses, false);
707     }
708 
709     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
710         for (uint256 i = 0; i < addresses.length; i++) {
711             address addr = addresses[i];
712             if(doBlock) {
713                 botWallets[addr] = true;
714             } else {
715                 delete botWallets[addr];
716             }
717         }
718     }
719 
720     function getContractTokenBalance() public view returns (uint256) {
721         return balanceOf(address(this));
722     }
723 
724     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
725         swapAndLiquifyEnabled = _enabled;
726         emit SwapAndLiquifyEnabledUpdated(_enabled);
727     }
728 
729     receive() external payable {}
730 
731     function _reflectFee(uint256 rFee, uint256 tFee) private {
732         _rTotal = _rTotal.sub(rFee);
733         _tFeeTotal = _tFeeTotal.add(tFee);
734     }
735 
736     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
737         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
738         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
739         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
740     }
741 
742     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
743         uint256 tFee = calculateTaxFee(tAmount);
744         uint256 tLiquidity = calculateLiquidityFee(tAmount);
745         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
746         return (tTransferAmount, tFee, tLiquidity);
747     }
748 
749     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
750         uint256 rAmount = tAmount.mul(currentRate);
751         uint256 rFee = tFee.mul(currentRate);
752         uint256 rLiquidity = tLiquidity.mul(currentRate);
753         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
754         return (rAmount, rTransferAmount, rFee);
755     }
756 
757     function _getRate() private view returns(uint256) {
758         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
759         return rSupply.div(tSupply);
760     }
761 
762     function _getCurrentSupply() private view returns(uint256, uint256) {
763         uint256 rSupply = _rTotal;
764         uint256 tSupply = _tTotal;
765         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
766         return (rSupply, tSupply);
767     }
768 
769     function _takeLiquidity(uint256 tLiquidity) private {
770         uint256 currentRate =  _getRate();
771         uint256 rLiquidity = tLiquidity.mul(currentRate);
772         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
773     }
774 
775     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
776         uint256 reflectionFee = 0;
777         if(doTakeFees) {
778             reflectionFee = taxFees.reflectionFee;
779             if(isSellTxn) {
780                 reflectionFee = reflectionFee.add(taxFees.sellReflectionFee);
781             }
782         }
783         return _amount.mul(reflectionFee).div(10**2);
784     }
785 
786     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
787         uint256 totalLiquidityFee = 0;
788         if(doTakeFees) {
789             totalLiquidityFee = taxFees.liquidityFee;
790             if(isSellTxn) {
791                 totalLiquidityFee = totalLiquidityFee.add(taxFees.sellLiquidityFee);
792                 if(_amount >= _largeSellNumOfTokens) {
793                     totalLiquidityFee = totalLiquidityFee.add(taxFees.superSellOffFee);
794                 }
795             }
796         }
797         return _amount.mul(totalLiquidityFee).div(10**2);
798     }
799 
800     function isExcludedFromFee(address account) public view returns(bool) {
801         return _isExcludedFromFee[account];
802     }
803 
804     function _approve(address owner, address spender, uint256 amount) private {
805         require(owner != address(0), "ERC20: approve from the zero address");
806         require(spender != address(0), "ERC20: approve to the zero address");
807 
808         _allowances[owner][spender] = amount;
809         emit Approval(owner, spender, amount);
810     }
811 
812     function _transfer(address from, address to, uint256 amount) private {
813         require(from != address(0), "ERC20: transfer from the zero address");
814         require(to != address(0), "ERC20: transfer to the zero address");
815         require(amount > 0, "Transfer amount must be greater than zero");
816         require(uniswapV2Pair != address(0),"UniswapV2Pair has not been set");
817         bool isSell = false;
818         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
819         //block the bots, but allow them to transfer to dead wallet if they are blocked
820         if(from != owner() && to != owner() && to != deadWallet) {
821             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
822         }
823         if(from == uniswapV2Pair || isExchangeWallet[from]) {
824             require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxTxAmount.");
825         }
826         if(from != uniswapV2Pair && to == uniswapV2Pair || (!isExchangeWallet[from] && isExchangeWallet[to])) { //if sell
827             //only tax if tokens are going back to Uniswap
828             isSell = true;
829             sellTaxTokens();
830         }
831         if(from != uniswapV2Pair && to != uniswapV2Pair && !isExchangeWallet[from] && !isExchangeWallet[to]) {
832             takeFees = false;
833         }
834         _tokenTransfer(from, to, amount, takeFees, isSell);
835     }
836 
837     function sellTaxTokens() private {
838         uint256 contractTokenBalance = balanceOf(address(this));
839         if (contractTokenBalance >= numTokensSellToAddToLiquidity && !inSwapAndLiquify && swapAndLiquifyEnabled) {
840             //distribution shares is the percentage to be shared between marketing, charity, and dev wallets
841             //remainder will be for the liquidity pool
842             uint256 balanceToShareTokens = contractTokenBalance.mul(distribution.sharePercentage).div(100);
843             uint256 liquidityPoolTokens = contractTokenBalance.sub(balanceToShareTokens);
844 
845             //just in case distribution Share Percentage is set to 100%, there will be no tokens to be swapped for liquidity pool
846             if(liquidityPoolTokens > 0) {
847                 //add liquidity
848                 swapAndLiquify(liquidityPoolTokens);
849             }
850             //send eth to wallets (marketing, charity, dev)
851             distributeShares(balanceToShareTokens);
852         }
853     }
854 
855     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
856         uint256 half = contractTokenBalance.div(2);
857         uint256 otherHalf = contractTokenBalance.sub(half);
858         uint256 initialBalance = address(this).balance;
859         swapTokensForEth(half);
860         uint256 newBalance = address(this).balance.sub(initialBalance);
861         addLiquidity(otherHalf, newBalance);
862         emit SwapAndLiquify(half, newBalance, otherHalf);
863     }
864 
865     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
866         // approve token transfer to cover all possible scenarios
867         _approve(address(this), address(uniswapV2Router), tokenAmount);
868 
869         // add the liquidity
870         uniswapV2Router.addLiquidityETH{value: ethAmount}(
871             address(this),
872             tokenAmount,
873             0, // slippage is unavoidable
874             0, // slippage is unavoidable
875             owner(),
876             block.timestamp
877         );
878     }
879     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
880         swapTokensForEth(balanceToShareTokens);
881         uint256 balanceToShare = address(this).balance;
882         uint256 marketingShare = balanceToShare.mul(distribution.marketingFeePercentage).div(100);
883         uint256 devShare = balanceToShare.mul(distribution.devFeePercentage).div(100);
884         payable(marketingWallet).transfer(marketingShare);
885         payable(devWallet).transfer(devShare);
886 
887     }
888 
889     function swapTokensForEth(uint256 tokenAmount) private {
890         // generate the uniswap pair path of token -> weth
891         address[] memory path = new address[](2);
892         path[0] = address(this);
893         path[1] = uniswapV2Router.WETH();
894         _approve(address(this), address(uniswapV2Router), tokenAmount);
895         // make the swap
896         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
897             tokenAmount,
898             0, // accept any amount of ETH
899             path,
900             address(this),
901             block.timestamp
902         );
903     }
904 
905     //this method is responsible for taking all fee, if takeFee is true
906     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFees, bool isSell) private {
907         doTakeFees = takeFees;
908         isSellTxn = isSell;
909         _transferStandard(sender, recipient, amount);
910     }
911 
912     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
913         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
914         _rOwned[sender] = _rOwned[sender].sub(rAmount);
915         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
916         _takeLiquidity(tLiquidity);
917         _reflectFee(rFee, tFee);
918         emit Transfer(sender, recipient, tTransferAmount);
919     }
920 }