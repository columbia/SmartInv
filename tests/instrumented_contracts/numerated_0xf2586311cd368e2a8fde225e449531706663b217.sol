1 pragma solidity ^0.8.13;
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
469     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
470 }
471 
472 contract DCNStudios is Context, IERC20, Ownable {
473     using SafeMath for uint256;
474     using Address for address;
475 
476     event SwapAndLiquifyEnabledUpdated(bool enabled);
477     event SwapAndLiquify(
478         uint256 tokensSwapped,
479         uint256 ethReceived,
480         uint256 tokensIntoLiqudity
481     );
482 
483     modifier lockTheSwap {
484         inSwapAndLiquify = true;
485         _;
486         inSwapAndLiquify = false;
487     }
488 
489     mapping (address => uint256) private _rOwned;
490     mapping (address => uint256) private _tOwned;
491     mapping (address => mapping (address => uint256)) private _allowances;
492     mapping (address => bool) private botWallets;
493     mapping (address => bool) private _isExcludedFromFee;
494     mapping (address => bool) private isExchangeWallet;
495 
496     uint256 private constant MAX = ~uint256(0);
497     uint256 private _tTotal = 100000000 * 10 ** 9;
498     uint256 private _rTotal = (MAX - (MAX % _tTotal));
499     uint256 private _tFeeTotal;
500 
501     string private _name = "DCN Studios";
502     string private _symbol = "DCNS";
503     uint8 private _decimals = 9;
504     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
505     address public uniswapV2Pair = address(0);
506     bool inSwapAndLiquify;
507     bool public swapAndLiquifyEnabled = true;
508     uint256 public _maxBuyAmount = 250000 * 10**9;
509     uint256 public numTokensSellToAddToLiquidity = 1000000 * 10**9;
510     uint public ethSellAmount = 1000000000000000000;  //1 ETH
511     address public devWallet = 0x3B0C70Ed03D3CF3571512b053f12Ad1f8f3E69FE;
512     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
513 
514     struct Distribution {
515         uint256 sharePercentage;
516         uint256 devFeePercentage;
517     }
518 
519     struct TaxFees {
520         uint256 reflectionFee;
521         uint256 liquidityFee;
522         uint256 sellReflectionFee;
523         uint256 sellLiquidityFee;
524         uint256 superSellOffFee;
525     }
526     bool private doTakeFees;
527     bool private isSellTxn;
528     TaxFees public taxFees;
529     Distribution public distribution;
530     
531     constructor () {
532         _rOwned[_msgSender()] = _rTotal;
533         _isExcludedFromFee[owner()] = true;
534         _isExcludedFromFee[_msgSender()] = true;
535         _isExcludedFromFee[devWallet] = true;
536         taxFees = TaxFees(2,2,1,3,8);
537         distribution = Distribution(60, 100);
538         emit Transfer(address(0), _msgSender(), _tTotal);
539     }
540 
541     function name() public view returns (string memory) {
542         return _name;
543     }
544 
545     function symbol() public view returns (string memory) {
546         return _symbol;
547     }
548 
549     function decimals() public view returns (uint8) {
550         return _decimals;
551     }
552 
553     function totalSupply() public view override returns (uint256) {
554         return _tTotal;
555     }
556 
557     function balanceOf(address account) public view override returns (uint256) {
558         return tokenFromReflection(_rOwned[account]);
559     }
560 
561     function transfer(address recipient, uint256 amount) public override returns (bool) {
562         _transfer(_msgSender(), recipient, amount);
563         return true;
564     }
565 
566     function allowance(address owner, address spender) public view override returns (uint256) {
567         return _allowances[owner][spender];
568     }
569 
570     function approve(address spender, uint256 amount) public override returns (bool) {
571         _approve(_msgSender(), spender, amount);
572         return true;
573     }
574 
575     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
576         _transfer(sender, recipient, amount);
577         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
578         return true;
579     }
580 
581     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
583         return true;
584     }
585 
586     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
588         return true;
589     }
590 
591     function totalFees() public view returns (uint256) {
592         return _tFeeTotal;
593     }
594 
595     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
596         uint256 iterator = 0;
597         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
598         require(newholders.length == amounts.length, "Holders and amount length must be the same");
599         while(iterator < newholders.length){
600             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false);
601             iterator += 1;
602         }
603     }
604 
605     function deliver(uint256 tAmount) public {
606         address sender = _msgSender();
607         (uint256 rAmount,,,,,) = _getValues(tAmount);
608         _rOwned[sender] = _rOwned[sender].sub(rAmount);
609         _rTotal = _rTotal.sub(rAmount);
610         _tFeeTotal = _tFeeTotal.add(tAmount);
611     }
612 
613     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
614         require(tAmount <= _tTotal, "Amount must be less than supply");
615         if (!deductTransferFee) {
616             (uint256 rAmount,,,,,) = _getValues(tAmount);
617             return rAmount;
618         } else {
619             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
620             return rTransferAmount;
621         }
622     }
623 
624     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
625         require(rAmount <= _rTotal, "Amount must be less than total reflections");
626         uint256 currentRate =  _getRate();
627         return rAmount.div(currentRate);
628     }
629 
630     function excludeFromFee(address[] calldata addresses) public onlyOwner {
631         addRemoveFee(addresses, true);
632     }
633 
634     function includeInFee(address[] calldata addresses) public onlyOwner {
635         addRemoveFee(addresses, false);
636     }
637 
638     function addExchange(address[] calldata addresses) public onlyOwner {
639         addRemoveExchange(addresses, true);
640     }
641 
642     function removeExchange(address[] calldata addresses) public onlyOwner {
643         addRemoveExchange(addresses, false);
644     }
645 
646     function createV2Pair() external onlyOwner {
647         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
648         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
649     }
650     function addRemoveExchange(address[] calldata addresses, bool flag) private {
651         for (uint256 i = 0; i < addresses.length; i++) {
652             address addr = addresses[i];
653             isExchangeWallet[addr] = flag;
654         }
655     }
656 
657     function addRemoveFee(address[] calldata addresses, bool flag) private {
658         for (uint256 i = 0; i < addresses.length; i++) {
659             address addr = addresses[i];
660             _isExcludedFromFee[addr] = flag;
661         }
662     }
663 
664     function setExtraSellEthAmount(uint ethPrice) external onlyOwner {
665         ethSellAmount = ethPrice;
666     }
667 
668     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
669         _maxBuyAmount = maxBuyAmount * 10**9;
670     }
671 
672     function setTaxFees(uint256 reflectionFee, uint256 liquidityFee, uint256 sellReflectionFee, uint256 sellLiquidityFee, uint256 superSellOffFee) external onlyOwner {
673         taxFees.reflectionFee = reflectionFee;
674         taxFees.liquidityFee = liquidityFee;
675         taxFees.sellLiquidityFee = sellLiquidityFee;
676         taxFees.sellReflectionFee = sellReflectionFee;
677         taxFees.superSellOffFee = superSellOffFee;
678     }
679 
680     function setDevSharePercentage(uint256 sharePercentage) external onlyOwner {
681         distribution.sharePercentage = sharePercentage;
682     }
683 
684     function setNumTokensToSell(uint256 numTokensSellToAddToLiquidity_) external onlyOwner {
685         numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity_ * 10**9;
686     }
687 
688     function setDevWallet(address _devWallet) external onlyOwner {
689         devWallet = _devWallet;
690     }
691 
692     function isAddressBlocked(address addr) public view returns (bool) {
693         return botWallets[addr];
694     }
695 
696     function blockAddresses(address[] memory addresses) external onlyOwner() {
697         blockUnblockAddress(addresses, true);
698     }
699 
700     function unblockAddresses(address[] memory addresses) external onlyOwner() {
701         blockUnblockAddress(addresses, false);
702     }
703 
704     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
705         for (uint256 i = 0; i < addresses.length; i++) {
706             address addr = addresses[i];
707             if(doBlock) {
708                 botWallets[addr] = true;
709             } else {
710                 delete botWallets[addr];
711             }
712         }
713     }
714 
715     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
716         swapAndLiquifyEnabled = _enabled;
717         emit SwapAndLiquifyEnabledUpdated(_enabled);
718     }
719 
720     receive() external payable {}
721 
722     function _reflectFee(uint256 rFee, uint256 tFee) private {
723         _rTotal = _rTotal.sub(rFee);
724         _tFeeTotal = _tFeeTotal.add(tFee);
725     }
726 
727     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
728         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
729         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
730         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
731     }
732 
733     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
734         uint256 tFee = calculateTaxFee(tAmount);
735         uint256 tLiquidity = calculateLiquidityFee(tAmount);
736         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
737         return (tTransferAmount, tFee, tLiquidity);
738     }
739 
740     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
741         uint256 rAmount = tAmount.mul(currentRate);
742         uint256 rFee = tFee.mul(currentRate);
743         uint256 rLiquidity = tLiquidity.mul(currentRate);
744         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
745         return (rAmount, rTransferAmount, rFee);
746     }
747 
748     function _getRate() private view returns(uint256) {
749         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
750         return rSupply.div(tSupply);
751     }
752 
753     function _getCurrentSupply() private view returns(uint256, uint256) {
754         uint256 rSupply = _rTotal;
755         uint256 tSupply = _tTotal;
756         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
757         return (rSupply, tSupply);
758     }
759 
760     function _takeLiquidity(uint256 tLiquidity) private {
761         uint256 currentRate =  _getRate();
762         uint256 rLiquidity = tLiquidity.mul(currentRate);
763         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
764     }
765 
766     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
767         uint256 reflectionFee = 0;
768         if(doTakeFees) {
769             reflectionFee = taxFees.reflectionFee;
770             if(isSellTxn) {
771                 reflectionFee = reflectionFee.add(taxFees.sellReflectionFee);
772             }
773         }
774         return _amount.mul(reflectionFee).div(10**2);
775     }
776 
777     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
778         uint256 totalLiquidityFee = 0;
779         if(doTakeFees) {
780             totalLiquidityFee = taxFees.liquidityFee;
781             if(isSellTxn) {
782                 totalLiquidityFee = totalLiquidityFee.add(taxFees.sellLiquidityFee);
783                 uint ethPrice = getEthPrice(_amount);
784                 if(ethPrice >= ethSellAmount) {
785                     totalLiquidityFee = totalLiquidityFee.add(taxFees.superSellOffFee);
786                 }
787             }
788         }
789         return _amount.mul(totalLiquidityFee).div(10**2);
790     }
791 
792     function isExcludedFromFee(address account) public view returns(bool) {
793         return _isExcludedFromFee[account];
794     }
795 
796     function _approve(address owner, address spender, uint256 amount) private {
797         require(owner != address(0), "ERC20: approve from the zero address");
798         require(spender != address(0), "ERC20: approve to the zero address");
799 
800         _allowances[owner][spender] = amount;
801         emit Approval(owner, spender, amount);
802     }
803 
804     function _transfer(address from, address to, uint256 amount) private {
805         require(from != address(0), "ERC20: transfer from the zero address");
806         require(to != address(0), "ERC20: transfer to the zero address");
807         require(amount > 0, "Transfer amount must be greater than zero");
808         require(uniswapV2Pair != address(0),"UniswapV2Pair has not been set");
809         bool isSell = false;
810         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
811         //block the bots, but allow them to transfer to dead wallet if they are blocked
812         if(from != owner() && to != owner() && to != deadWallet) {
813             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
814         }
815         if(from == uniswapV2Pair || isExchangeWallet[from]) {
816             require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxTxAmount.");
817         }
818         if(from != uniswapV2Pair && to == uniswapV2Pair || (!isExchangeWallet[from] && isExchangeWallet[to])) { //if sell
819             //only tax if tokens are going back to Uniswap
820             isSell = true;
821             sellTaxTokens();
822         }
823         if(from != uniswapV2Pair && to != uniswapV2Pair && !isExchangeWallet[from] && !isExchangeWallet[to]) {
824             takeFees = false;
825         }
826         _tokenTransfer(from, to, amount, takeFees, isSell);
827     }
828 
829     function sellTaxTokens() private {
830         uint256 contractTokenBalance = balanceOf(address(this));
831         if (contractTokenBalance >= numTokensSellToAddToLiquidity && !inSwapAndLiquify && swapAndLiquifyEnabled) {
832             //distribution shares is the percentage to be shared between marketing, charity, and dev wallets
833             //remainder will be for the liquidity pool
834             uint256 balanceToShareTokens = contractTokenBalance.mul(distribution.sharePercentage).div(100);
835             uint256 liquidityPoolTokens = contractTokenBalance.sub(balanceToShareTokens);
836 
837             //just in case distribution Share Percentage is set to 100%, there will be no tokens to be swapped for liquidity pool
838             if(liquidityPoolTokens > 0) {
839                 //add liquidity
840                 swapAndLiquify(liquidityPoolTokens);
841             }
842             //send eth to wallets (marketing, charity, dev)
843             distributeShares(balanceToShareTokens);
844         }
845     }
846 
847     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
848         uint256 half = contractTokenBalance.div(2);
849         uint256 otherHalf = contractTokenBalance.sub(half);
850         uint256 initialBalance = address(this).balance;
851         swapTokensForEth(half);
852         uint256 newBalance = address(this).balance.sub(initialBalance);
853         addLiquidity(otherHalf, newBalance);
854         emit SwapAndLiquify(half, newBalance, otherHalf);
855     }
856 
857     function getEthPrice(uint tokenAmount) public view returns (uint)  {
858         address[] memory path = new address[](2);
859         path[0] = address(this);
860         path[1] = uniswapV2Router.WETH();
861         return uniswapV2Router.getAmountsOut(tokenAmount, path)[1];
862     }
863     
864     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
865         // approve token transfer to cover all possible scenarios
866         _approve(address(this), address(uniswapV2Router), tokenAmount);
867 
868         // add the liquidity
869         uniswapV2Router.addLiquidityETH{value: ethAmount}(
870             address(this),
871             tokenAmount,
872             0, // slippage is unavoidable
873             0, // slippage is unavoidable
874             owner(),
875             block.timestamp
876         );
877     }
878     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
879         swapTokensForEth(balanceToShareTokens);
880         uint256 devFees = address(this).balance;
881         payable(devWallet).transfer(devFees);
882     }
883 
884     function swapTokensForEth(uint256 tokenAmount) private {
885         // generate the uniswap pair path of token -> weth
886         address[] memory path = new address[](2);
887         path[0] = address(this);
888         path[1] = uniswapV2Router.WETH();
889         _approve(address(this), address(uniswapV2Router), tokenAmount);
890         // make the swap
891         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
892             tokenAmount,
893             0, // accept any amount of ETH
894             path,
895             address(this),
896             block.timestamp
897         );
898     }
899 
900     //this method is responsible for taking all fee, if takeFee is true
901     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFees, bool isSell) private {
902         doTakeFees = takeFees;
903         isSellTxn = isSell;
904         _transferStandard(sender, recipient, amount);
905     }
906 
907     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
908         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
909         _rOwned[sender] = _rOwned[sender].sub(rAmount);
910         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
911         _takeLiquidity(tLiquidity);
912         _reflectFee(rFee, tFee);
913         emit Transfer(sender, recipient, tTransferAmount);
914     }
915 }