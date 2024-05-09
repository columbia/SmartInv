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
471 contract Selena is Context, IERC20, Ownable {
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
494     mapping (address => bool) private allowAirDrops;
495 
496     uint256 private constant MAX = ~uint256(0);
497     uint256 private _tTotal = 1000000000000 * 10 ** 6 * 10 ** 9;
498     uint256 private _rTotal = (MAX - (MAX % _tTotal));
499     uint256 private _tFeeTotal;
500 
501     string private _name = "SELENA";
502     string private _symbol = "SEL";
503     uint8 private _decimals = 9;
504 
505     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
506     address public uniswapV2Pair;
507     bool inSwapAndLiquify;
508     bool public swapAndLiquifyEnabled = true;
509     uint256 public _maxBuyAmount = 1000000000000000 * 10**9;
510     uint256 public numTokensSellToAddToLiquidity = 200000000000000 * 10**9;
511     uint256 private _largeSellNumOfTokens = 2000000000000000 * 10**9;
512     address public marketingWallet = 0x72B75111d243Cba98C8746cE261E390366616aA9;
513     address public investmentWallet = 0x800C3C9b2b132543917cbB5a54A6E99d47e39A7B;
514     address public devWallet = 0x16ce829696166C382e1Dbbb5A1E23e4203Bd06D1;
515     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
516 
517     struct Distribution {
518         uint256 sharePercentage;
519         uint256 marketingFeePercentage;
520         uint256 investmentFeePercentage;
521         uint256 devFeePercentage;
522     }
523 
524     struct TaxFees {
525         uint256 reflectionFee;
526         uint256 liquidityFee;
527         uint256 sellReflectionFee;
528         uint256 sellLiquidityFee;
529         uint256 superSellOffFee;
530     }
531     bool private doTakeFees;
532     bool private isSellTxn;
533     TaxFees public taxFees;
534     Distribution public distribution;
535 
536     constructor () {
537         _rOwned[_msgSender()] = _rTotal;
538         _isExcludedFromFee[owner()] = true;
539         _isExcludedFromFee[_msgSender()] = true;
540         _isExcludedFromFee[marketingWallet] = true;
541         _isExcludedFromFee[investmentWallet] = true;
542         _isExcludedFromFee[devWallet] = true;
543         taxFees = TaxFees(1,7,1,3,21);
544         distribution = Distribution(75, 33, 34, 33);
545         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
546         emit Transfer(address(0), _msgSender(), _tTotal);
547     }
548 
549     function name() public view returns (string memory) {
550         return _name;
551     }
552 
553     function symbol() public view returns (string memory) {
554         return _symbol;
555     }
556 
557     function decimals() public view returns (uint8) {
558         return _decimals;
559     }
560 
561     function totalSupply() public view override returns (uint256) {
562         return _tTotal;
563     }
564 
565     function balanceOf(address account) public view override returns (uint256) {
566         return tokenFromReflection(_rOwned[account]);
567     }
568 
569     function transfer(address recipient, uint256 amount) public override returns (bool) {
570         _transfer(_msgSender(), recipient, amount);
571         return true;
572     }
573 
574     function allowance(address owner, address spender) public view override returns (uint256) {
575         return _allowances[owner][spender];
576     }
577 
578     function approve(address spender, uint256 amount) public override returns (bool) {
579         _approve(_msgSender(), spender, amount);
580         return true;
581     }
582 
583     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
584         _transfer(sender, recipient, amount);
585         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
586         return true;
587     }
588 
589     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
590         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
591         return true;
592     }
593 
594     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
595         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
596         return true;
597     }
598 
599     function totalFees() public view returns (uint256) {
600         return _tFeeTotal;
601     }
602 
603     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
604         uint256 iterator = 0;
605         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by Saja team");
606         require(newholders.length == amounts.length, "Holders and amount length must be the same");
607         while(iterator < newholders.length){
608             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false);
609             iterator += 1;
610         }
611     }
612 
613     function deliver(uint256 tAmount) public {
614         address sender = _msgSender();
615         (uint256 rAmount,,,,,) = _getValues(tAmount);
616         _rOwned[sender] = _rOwned[sender].sub(rAmount);
617         _rTotal = _rTotal.sub(rAmount);
618         _tFeeTotal = _tFeeTotal.add(tAmount);
619     }
620 
621     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
622         require(tAmount <= _tTotal, "Amount must be less than supply");
623         if (!deductTransferFee) {
624             (uint256 rAmount,,,,,) = _getValues(tAmount);
625             return rAmount;
626         } else {
627             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
628             return rTransferAmount;
629         }
630     }
631 
632     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
633         require(rAmount <= _rTotal, "Amount must be less than total reflections");
634         uint256 currentRate =  _getRate();
635         return rAmount.div(currentRate);
636     }
637 
638     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
639         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
640         _tOwned[sender] = _tOwned[sender].sub(tAmount);
641         _rOwned[sender] = _rOwned[sender].sub(rAmount);
642         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
643         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
644         _takeLiquidity(tLiquidity);
645         _reflectFee(rFee, tFee);
646         emit Transfer(sender, recipient, tTransferAmount);
647     }
648 
649     function excludeFromFee(address[] calldata addresses) public onlyOwner {
650         addRemoveFee(addresses, true);
651     }
652 
653     function includeInFee(address[] calldata addresses) public onlyOwner {
654         addRemoveFee(addresses, false);
655     }
656 
657     function addExchange(address[] calldata addresses) public onlyOwner {
658         addRemoveExchange(addresses, true);
659     }
660 
661     function removeExchange(address[] calldata addresses) public onlyOwner {
662         addRemoveExchange(addresses, false);
663     }
664 
665     function addRemoveExchange(address[] calldata addresses, bool flag) private {
666         for (uint256 i = 0; i < addresses.length; i++) {
667             address addr = addresses[i];
668             isExchangeWallet[addr] = flag;
669         }
670     }
671     
672     function addRemoveFee(address[] calldata addresses, bool flag) private {
673         for (uint256 i = 0; i < addresses.length; i++) {
674             address addr = addresses[i];
675             _isExcludedFromFee[addr] = flag;
676         }
677     }
678     
679     function setSellNumOfTokens(uint256 largeSellNumOfTokens) external onlyOwner {
680         _largeSellNumOfTokens = largeSellNumOfTokens * 10**9;
681     }
682 
683     function setTaxFees(uint256 reflectionFee, uint256 liquidityFee, uint256 sellReflectionFee, uint256 sellLiquidityFee, uint256 superSellOffFee) external onlyOwner {
684         taxFees.reflectionFee = reflectionFee;
685         taxFees.liquidityFee = liquidityFee;
686         taxFees.sellLiquidityFee = sellLiquidityFee;
687         taxFees.sellReflectionFee = sellReflectionFee;
688         taxFees.superSellOffFee = superSellOffFee;
689     }
690 
691     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
692         _maxBuyAmount = maxBuyAmount * 10**9;
693     }
694 
695     function setDistribution(uint256 marketingFeePercentage, uint256 investmentFeePercentage, uint256 devFeePercentage,
696         uint256 sharePercentage) external onlyOwner {
697         require(marketingFeePercentage.add(investmentFeePercentage).add(devFeePercentage) == 100, "Fee percentage must equal 100");
698         distribution.marketingFeePercentage = marketingFeePercentage;
699         distribution.investmentFeePercentage = investmentFeePercentage;
700         distribution.devFeePercentage = devFeePercentage;
701         distribution.sharePercentage = sharePercentage;
702     }
703 
704     function setNumTokensToSell(uint256 numTokensSellToAddToLiquidity_) external onlyOwner {
705         numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity_ * 10**9;
706     }
707 
708     function setWallets(address _marketingWallet, address _investmentWallet, address _devWallet) external onlyOwner {
709         marketingWallet = _marketingWallet;
710         investmentWallet = _investmentWallet;
711         devWallet = _devWallet;
712     }
713 
714     function isAddressBlocked(address addr) public view returns (bool) {
715         return botWallets[addr];
716     }
717 
718     function claimTokens() external onlyOwner() {
719         uint256 numberOfTokensToSell = balanceOf(address(this));
720         distributeShares(numberOfTokensToSell);
721     }
722 
723     function blockAddresses(address[] memory addresses) external onlyOwner() {
724         blockUnblockAddress(addresses, true);
725     }
726 
727     function unblockAddresses(address[] memory addresses) external onlyOwner() {
728         blockUnblockAddress(addresses, false);
729     }
730 
731     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
732         for (uint256 i = 0; i < addresses.length; i++) {
733             address addr = addresses[i];
734             if(doBlock) {
735                 botWallets[addr] = true;
736             } else {
737                 delete botWallets[addr];
738             }
739         }
740     }
741 
742     function getContractTokenBalance() public view returns (uint256) {
743         return balanceOf(address(this));
744     }
745 
746     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
747         swapAndLiquifyEnabled = _enabled;
748         emit SwapAndLiquifyEnabledUpdated(_enabled);
749     }
750 
751     receive() external payable {}
752 
753     function _reflectFee(uint256 rFee, uint256 tFee) private {
754         _rTotal = _rTotal.sub(rFee);
755         _tFeeTotal = _tFeeTotal.add(tFee);
756     }
757 
758     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
759         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
760         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
761         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
762     }
763 
764     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
765         uint256 tFee = calculateTaxFee(tAmount);
766         uint256 tLiquidity = calculateLiquidityFee(tAmount);
767         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
768         return (tTransferAmount, tFee, tLiquidity);
769     }
770 
771     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
772         uint256 rAmount = tAmount.mul(currentRate);
773         uint256 rFee = tFee.mul(currentRate);
774         uint256 rLiquidity = tLiquidity.mul(currentRate);
775         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
776         return (rAmount, rTransferAmount, rFee);
777     }
778 
779     function _getRate() private view returns(uint256) {
780         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
781         return rSupply.div(tSupply);
782     }
783 
784     function _getCurrentSupply() private view returns(uint256, uint256) {
785         uint256 rSupply = _rTotal;
786         uint256 tSupply = _tTotal;
787         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
788         return (rSupply, tSupply);
789     }
790 
791     function _takeLiquidity(uint256 tLiquidity) private {
792         uint256 currentRate =  _getRate();
793         uint256 rLiquidity = tLiquidity.mul(currentRate);
794         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
795     }
796 
797     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
798         uint256 reflectionFee = 0;
799         if(doTakeFees) {
800             reflectionFee = taxFees.reflectionFee;
801             if(isSellTxn) {
802                 reflectionFee = reflectionFee.add(taxFees.sellReflectionFee);
803             }
804         }
805         return _amount.mul(reflectionFee).div(10**2);
806     }
807 
808     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
809         uint256 totalLiquidityFee = 0;
810         if(doTakeFees) {
811             totalLiquidityFee = taxFees.liquidityFee;
812             if(isSellTxn) {
813                 totalLiquidityFee = totalLiquidityFee.add(taxFees.sellLiquidityFee);
814                 if(_amount >= _largeSellNumOfTokens) {
815                     totalLiquidityFee = totalLiquidityFee.add(taxFees.superSellOffFee);
816                 }
817             }
818         }
819         return _amount.mul(totalLiquidityFee).div(10**2);
820     }
821 
822     function isExcludedFromFee(address account) public view returns(bool) {
823         return _isExcludedFromFee[account];
824     }
825 
826     function _approve(address owner, address spender, uint256 amount) private {
827         require(owner != address(0), "ERC20: approve from the zero address");
828         require(spender != address(0), "ERC20: approve to the zero address");
829 
830         _allowances[owner][spender] = amount;
831         emit Approval(owner, spender, amount);
832     }
833 
834     function _transfer(address from, address to, uint256 amount) private {
835         require(from != address(0), "ERC20: transfer from the zero address");
836         require(to != address(0), "ERC20: transfer to the zero address");
837         require(amount > 0, "Transfer amount must be greater than zero");
838         bool isSell = false;
839         
840         //block the bots, but allow them to transfer to dead wallet if they are blocked    
841         if(from != owner() && to != owner() && to != deadWallet) {            
842             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");        
843         }
844         if(from == uniswapV2Pair || isExchangeWallet[from]) {
845             require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxTxAmount.");
846         }
847         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
848        
849         if(from != uniswapV2Pair && to == uniswapV2Pair || (!isExchangeWallet[from] && isExchangeWallet[to])) { //if sell
850             //only tax if tokens are going back to Uniswap
851             isSell = true;
852             sellTaxTokens();
853         }
854         if(from != uniswapV2Pair && to != uniswapV2Pair && !isExchangeWallet[from] && !isExchangeWallet[to]) {
855             takeFees = false;
856         }
857         _tokenTransfer(from, to, amount, takeFees, isSell);
858     }
859 
860     function sellTaxTokens() private {
861         uint256 contractTokenBalance = balanceOf(address(this));
862         if (contractTokenBalance >= numTokensSellToAddToLiquidity && !inSwapAndLiquify && swapAndLiquifyEnabled) {
863             //distribution shares is the percentage to be shared between marketing, investment, and dev wallets
864             //remainder will be for the liquidity pool
865             uint256 balanceToShareTokens = contractTokenBalance.mul(distribution.sharePercentage).div(100);
866             uint256 liquidityPoolTokens = contractTokenBalance.sub(balanceToShareTokens);
867 
868             //just in case distribution Share Percentage is set to 100%, there will be no tokens to be swapped for liquidity pool
869             if(liquidityPoolTokens > 0) {
870                 //add liquidity
871                 swapAndLiquify(liquidityPoolTokens);
872             }
873             //send eth to wallets (marketing, investment, dev)
874             distributeShares(balanceToShareTokens);
875         }
876     }
877 
878     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
879         uint256 half = contractTokenBalance.div(2);
880         uint256 otherHalf = contractTokenBalance.sub(half);
881         uint256 initialBalance = address(this).balance;
882         swapTokensForEth(half);
883         uint256 newBalance = address(this).balance.sub(initialBalance);
884         addLiquidity(otherHalf, newBalance);
885         emit SwapAndLiquify(half, newBalance, otherHalf);
886     }
887 
888     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
889         // approve token transfer to cover all possible scenarios
890         _approve(address(this), address(uniswapV2Router), tokenAmount);
891 
892         // add the liquidity
893         uniswapV2Router.addLiquidityETH{value: ethAmount}(
894             address(this),
895             tokenAmount,
896             0, // slippage is unavoidable
897             0, // slippage is unavoidable
898             owner(),
899             block.timestamp
900         );
901     }
902     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
903         swapTokensForEth(balanceToShareTokens);
904         uint256 balanceToShare = address(this).balance;
905         uint256 marketingShare = balanceToShare.mul(distribution.marketingFeePercentage).div(100);
906         uint256 investmentShare = balanceToShare.mul(distribution.investmentFeePercentage).div(100);
907         uint256 devShare = balanceToShare.mul(distribution.devFeePercentage).div(100);
908         payable(marketingWallet).transfer(marketingShare);
909         payable(investmentWallet).transfer(investmentShare);
910         payable(devWallet).transfer(devShare);
911 
912     }
913 
914     function swapTokensForEth(uint256 tokenAmount) private {
915         // generate the uniswap pair path of token -> weth
916         address[] memory path = new address[](2);
917         path[0] = address(this);
918         path[1] = uniswapV2Router.WETH();
919         _approve(address(this), address(uniswapV2Router), tokenAmount);
920         // make the swap
921         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
922             tokenAmount,
923             0, // accept any amount of ETH
924             path,
925             address(this),
926             block.timestamp
927         );
928     }
929 
930     //this method is responsible for taking all fee, if takeFee is true
931     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFees, bool isSell) private {
932         doTakeFees = takeFees;
933         isSellTxn = isSell;
934         _transferStandard(sender, recipient, amount);
935     }
936 
937     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
938         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
939         _rOwned[sender] = _rOwned[sender].sub(rAmount);
940         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
941         _takeLiquidity(tLiquidity);
942         _reflectFee(rFee, tFee);
943         emit Transfer(sender, recipient, tTransferAmount);
944     }
945 }