1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a {Transfer} event.
19      */
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     /**
23      * @dev Returns the remaining number of tokens that `spender` will be
24      * allowed to spend on behalf of `owner` through {transferFrom}. This is
25      * zero by default.
26      *
27      * This value changes when {approve} or {transferFrom} are called.
28      */
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     /**
32      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * IMPORTANT: Beware that changing an allowance with this method brings the risk
37      * that someone may use both the old and the new allowance by unfortunate
38      * transaction ordering. One possible solution to mitigate this race
39      * condition is to first reduce the spender's allowance to 0 and set the
40      * desired value afterwards:
41      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
42      *
43      * Emits an {Approval} event.
44      */
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Moves `amount` tokens from `sender` to `recipient` using the
49      * allowance mechanism. `amount` is then deducted from the caller's
50      * allowance.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
68      * a call to {approve}. `value` is the new allowance.
69      */
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations with added overflow
77  * checks.
78  *
79  * Arithmetic operations in Solidity wrap on overflow. This can easily result
80  * in bugs, because programmers usually assume that an overflow raises an
81  * error, which is the standard behavior in high level programming languages.
82  * `SafeMath` restores this intuition by reverting the transaction when an
83  * operation overflows.
84  *
85  * Using this library instead of the unchecked operations eliminates an entire
86  * class of bugs, so it's recommended to use it always.
87  */
88 
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      *
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      *
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 abstract contract Context {
233     function _msgSender() internal view virtual returns (address payable) {
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
319       return functionCall(target, data, "Address: low-level call failed");
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
402     constructor () internal {
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
423      /**
424      * @dev Leaves the contract without owner. It will not be possible to call
425      * `onlyOwner` functions anymore. Can only be called by the current owner.
426      *
427      * NOTE: Renouncing ownership will leave the contract without an owner,
428      * thereby removing any functionality that is only available to the owner.
429      */
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
452     function factory() external pure returns (address);
453     function WETH() external pure returns (address);
454 
455     function swapExactTokensForETHSupportingFeeOnTransferTokens(
456         uint amountIn,
457         uint amountOutMin,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external;
462 
463     function addLiquidityETH(
464         address token,
465         uint amountTokenDesired,
466         uint amountTokenMin,
467         uint amountETHMin,
468         address to,
469         uint deadline
470     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
471 }
472 
473 contract DecanectCoin is Context, IERC20, Ownable {
474 
475     using SafeMath for uint256;
476     using Address for address payable;
477 
478     mapping (address => uint256) private _balances;
479     mapping (address => uint256) private _airdropBalance;
480     mapping (address => uint256) private _totalSales;
481     mapping (address => uint256) private _totalPurchases;
482     mapping (address => mapping (address => uint256)) private _allowances;
483     mapping (address => bool) private _isExcludedFromFee;
484     mapping (address => bool) private _isSniper;
485 
486     uint256[] public _airdropVestingTime = [
487       block.timestamp,
488       block.timestamp + 14 days,
489       block.timestamp + 28 days,
490       block.timestamp + 42 days,
491       block.timestamp + 56 days
492     ];
493 
494     uint256[] public _airdropVestingSchedule = [
495       20,
496       40,
497       60,
498       80,
499       100
500     ];
501 
502     address payable public marketingRewards;
503     address payable public team;
504 
505     uint256 private _tTotal = 10 * 10**6 * 10**9;
506 
507     string private _name = "Decanect";
508     string private _symbol = "DCNT";
509     uint8 private _decimals = 9;
510 
511     uint256 public _marketingFeeBuy = 50;
512     uint256 public _marketingFeeSell = 50;
513 
514     uint256 public _liquidityFeeBuy = 20;
515     uint256 public _liquidityFeeSell = 20;
516 
517     uint256 public _rewardsFeeBuy = 30;
518     uint256 public _rewardsFeeSell = 30;
519 
520     uint256 public _teamFeeBuy = 20;
521     uint256 public _teamFeeSell = 20;
522 
523     uint256 private _teamFees;
524     uint256 private _liquidityFees;
525 
526     uint256 private launchBlock;
527     uint256 private launchTime;
528     uint256 private blocksLimit;
529 
530     IUniswapV2Router02 public immutable uniswapV2Router;
531     address public immutable uniswapV2Pair;
532 
533     bool inSwapAndLiquify;
534     bool public swapAndLiquifyEnabled = true;
535 
536     uint256 public _maxWalletHolding = 200 * 10**3 * 10**9;
537     uint256 private numTokensSellToAddToLiquidity = 25 * 10**3 * 10**9;
538 
539     modifier lockTheSwap {
540         inSwapAndLiquify = true;
541         _;
542         inSwapAndLiquify = false;
543     }
544 
545     constructor (address payable _teamWallet, address payable _marketingRewardsWallet) public {
546       team = _teamWallet;
547       marketingRewards = _marketingRewardsWallet;
548 
549       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
550       uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
551       uniswapV2Router = _uniswapV2Router;
552 
553       _isExcludedFromFee[owner()] = true;
554       _isExcludedFromFee[address(this)] = true;
555       _isExcludedFromFee[_marketingRewardsWallet] = true;
556       _isExcludedFromFee[_teamWallet] = true;
557 
558       _balances[_msgSender()] = _tTotal;
559 
560       emit Transfer(address(0), _msgSender(), _tTotal);
561     }
562 
563     function name() public view returns (string memory) {
564         return _name;
565     }
566 
567     function symbol() public view returns (string memory) {
568         return _symbol;
569     }
570 
571     function decimals() public view returns (uint8) {
572         return _decimals;
573     }
574 
575     function totalSupply() public view override returns (uint256) {
576         return _tTotal;
577     }
578 
579     function balanceOf(address account) public view override returns (uint256) {
580         return _balances[account];
581     }
582 
583     function transfer(address recipient, uint256 amount) public override returns (bool) {
584         _transfer(_msgSender(), recipient, amount);
585         return true;
586     }
587 
588     function allowance(address owner, address spender) public view override returns (uint256) {
589         return _allowances[owner][spender];
590     }
591 
592     function approve(address spender, uint256 amount) public override returns (bool) {
593         _approve(_msgSender(), spender, amount);
594         return true;
595     }
596 
597     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
598         _transfer(sender, recipient, amount);
599         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
600         return true;
601     }
602 
603     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
604         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
605         return true;
606     }
607 
608     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
609         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
610         return true;
611     }
612 
613     function manualSwapAndLiquify() public onlyOwner() {
614         uint256 contractTokenBalance = balanceOf(address(this));
615         swapAndLiquify(contractTokenBalance);
616     }
617 
618     function excludeFromFee(address account) public onlyOwner {
619         _isExcludedFromFee[account] = true;
620     }
621 
622     function includeInFee(address account) public onlyOwner {
623         _isExcludedFromFee[account] = false;
624     }
625 
626     function setTaxes(uint256[] memory _taxTypes, uint256[] memory _taxSizes) external onlyOwner() {
627       require(_taxTypes.length == _taxSizes.length, "Incorrect input");
628       for (uint i = 0; i < _taxTypes.length; i++) {
629 
630         uint256 _taxType = _taxTypes[i];
631         uint256 _taxSize = _taxSizes[i];
632 
633         if (_taxType == 1) {
634           _marketingFeeBuy = _taxSize;
635         }
636         else if (_taxType == 2) {
637           _marketingFeeSell = _taxSize;
638         }
639         else if (_taxType == 3) {
640           _liquidityFeeBuy = _taxSize;
641         }
642         else if (_taxType == 4) {
643           _liquidityFeeSell = _taxSize;
644         }
645         else if (_taxType == 5) {
646           _rewardsFeeBuy = _taxSize;
647         }
648         else if (_taxType == 6) {
649           _rewardsFeeSell = _taxSize;
650         }
651         else if (_taxType == 7) {
652           _teamFeeBuy = _taxSize;
653         }
654         else if (_taxType == 8) {
655           _teamFeeSell = _taxSize;
656         }
657       }
658       uint totalSellFee = _marketingFeeSell + _liquidityFeeSell + _rewardsFeeSell + _teamFeeSell;
659       uint totalBuyFee = _marketingFeeBuy + _liquidityFeeBuy + _rewardsFeeBuy + _teamFeeBuy;
660       require(totalSellFee <= 240);
661       require(totalBuyFee <= 240);
662     }
663 
664     function setSwapAndLiquifyEnabled(bool _enabled, uint256 _numTokensMin) public onlyOwner() {
665         swapAndLiquifyEnabled = _enabled;
666         numTokensSellToAddToLiquidity = _numTokensMin;
667     }
668 
669     function airdrop(address payable [] memory holders, uint256 [] memory balances, bool vest) public onlyOwner() {
670       require(holders.length == balances.length, "Incorrect input");
671       uint256 deployer_balance = _balances[_msgSender()];
672 
673       for (uint8 i = 0; i < holders.length; i++) {
674         uint256 balance = balances[i] * 10 ** 9;
675         _balances[holders[i]] = _balances[holders[i]].add(balance);
676         if (vest) _airdropBalance[holders[i]] = _airdropBalance[holders[i]].add(balance);
677         emit Transfer(_msgSender(), holders[i], balance);
678         deployer_balance = deployer_balance.sub(balance);
679       }
680       _balances[_msgSender()] = deployer_balance;
681     }
682 
683     function enableTrading(uint256 _blocksLimit) public onlyOwner() {
684         require(launchTime == 0, "Already enabled");
685         launchBlock = block.number;
686         launchTime = block.timestamp;
687         blocksLimit = _blocksLimit;
688     }
689 
690     receive() external payable {}
691 
692     function isExcludedFromFee(address account) public view returns(bool) {
693         return _isExcludedFromFee[account];
694     }
695 
696     function _approve(address owner, address spender, uint256 amount) private {
697         require(owner != address(0), "ERC20: approve from the zero address");
698         require(spender != address(0), "ERC20: approve to the zero address");
699 
700         _allowances[owner][spender] = amount;
701         emit Approval(owner, spender, amount);
702     }
703 
704     function _transfer(
705         address from,
706         address to,
707         uint256 amount
708     ) private {
709         require(from != address(0), "ERC20: transfer from the zero address");
710         require(amount > 0, "Transfer amount must be greater than zero");
711         uint256 contractTokenBalance = balanceOf(address(this));
712 
713         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
714         if (
715             overMinTokenBalance &&
716             !inSwapAndLiquify &&
717             from != uniswapV2Pair &&
718             swapAndLiquifyEnabled
719         ) {
720             swapAndLiquify(contractTokenBalance);
721         }
722 
723         //indicates if fee should be deducted from transfer
724         bool takeFee = true;
725 
726         //if any account belongs to _isExcludedFromFee account then remove the fee
727         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
728             takeFee = false;
729         }
730         else {
731           require(launchTime > 0, "Trading not enabled yet");
732         }
733 
734         //depending on type of transfer (buy, sell, or p2p tokens transfer) different taxes & fees are applied
735         bool isTransferBuy = from == uniswapV2Pair;
736         bool isTransferSell = to == uniswapV2Pair;
737 
738         if (!isTransferBuy && !isTransferSell) {
739           takeFee = false;
740         }
741 
742         _transferStandard(from,to,amount,takeFee,isTransferBuy,isTransferSell);
743 
744         if (!_isExcludedFromFee[to] && (to != uniswapV2Pair)) require(balanceOf(to) < _maxWalletHolding, "Max Wallet holding limit exceeded");
745         if (!_isExcludedFromFee[from]) {
746           if (_airdropBalance[from] > 0) {
747             uint256 minRequiredBalance = this.minRequiredBalance(from);
748             require(balanceOf(from) >= minRequiredBalance, "Vesting violation");
749           }
750         }
751     }
752 
753     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
754         uint256 liquidityPart = 0;
755         if (_liquidityFees < contractTokenBalance) liquidityPart = _liquidityFees;
756 
757         uint256 distributionPart = contractTokenBalance.sub(liquidityPart);
758         uint256 liquidityHalfPart = liquidityPart.div(2);
759         uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart);
760 
761         uint256 totalETHSwap = liquidityHalfPart.add(distributionPart);
762 
763         swapTokensForEth(totalETHSwap);
764 
765         uint256 newBalance = address(this).balance;
766         uint256 teamBalance = _teamFees.mul(newBalance).div(totalETHSwap);
767         uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap);
768 
769         if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance);
770 
771         if (teamBalance > 0 && teamBalance < address(this).balance) team.call{ value: teamBalance }("");
772         if (address(this).balance > 0) marketingRewards.call{ value: address(this).balance }("");
773 
774         _liquidityFees = 0;
775         _teamFees = 0;
776     }
777 
778     function setBlockedWallet(address _account, bool _blocked ) public onlyOwner() {
779         _isSniper[_account] = _blocked;
780     }
781 
782     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
783         // approve token transfer to cover all possible scenarios
784         _approve(address(this), address(uniswapV2Router), tokenAmount);
785 
786         // add the liquidity
787         uniswapV2Router.addLiquidityETH{value: ethAmount}(
788             address(this),
789             tokenAmount,
790             0,
791             0,
792             marketingRewards,
793             block.timestamp
794         );
795     }
796 
797     function swapTokensForEth(uint256 tokenAmount) private {
798         // generate the uniswap pair path of token -> weth
799         address[] memory path = new address[](2);
800         path[0] = address(this);
801         path[1] = uniswapV2Router.WETH();
802 
803         _approve(address(this), address(uniswapV2Router), tokenAmount);
804 
805         // make the swap
806         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
807             tokenAmount,
808             0,
809             path,
810             address(this),
811             block.timestamp
812         );
813     }
814 
815     function _transferStandard(address sender, address recipient, uint256 tAmount, bool takeFee, bool isTransferBuy, bool isTransferSell) private {
816         uint256 tTransferAmount = tAmount;
817         if (takeFee) {
818           uint256 marketingRewardsTax;
819           uint256 teamTax;
820           uint256 liquidityTax;
821           if (isTransferBuy) {
822             if (block.number <= (launchBlock + blocksLimit)) _isSniper[recipient] = true;
823             marketingRewardsTax = tAmount.mul(_marketingFeeBuy).div(1000);
824             teamTax = tAmount.mul(_teamFeeBuy).div(1000);
825             marketingRewardsTax = marketingRewardsTax.add(tAmount.mul(_rewardsFeeBuy).div(1000));
826             liquidityTax = tAmount.mul(_liquidityFeeBuy).div(1000);
827           }
828           if (isTransferSell) {
829             require(!_isSniper[sender], "SNIPER!");
830             marketingRewardsTax = tAmount.mul(_marketingFeeSell).div(1000);
831             teamTax = tAmount.mul(_teamFeeSell).div(1000);
832             marketingRewardsTax = marketingRewardsTax.add(tAmount.mul(_rewardsFeeSell).div(1000));
833             liquidityTax = tAmount.mul(_liquidityFeeSell).div(1000);
834           }
835           tTransferAmount = tTransferAmount.sub(marketingRewardsTax).sub(teamTax).sub(liquidityTax);
836           _liquidityFees = _liquidityFees.add(liquidityTax);
837           _teamFees = _teamFees.add(teamTax);
838 
839         }
840         else if (!isTransferBuy && !isTransferSell) {
841           require(!_isSniper[sender], "SNIPER!");
842         }
843         _balances[sender] = _balances[sender].sub(tAmount);
844         _balances[recipient] = _balances[recipient].add(tTransferAmount);
845         _balances[address(this)] = _balances[address(this)].add(tAmount.sub(tTransferAmount));
846         emit Transfer(sender, recipient, tTransferAmount);
847     }
848 
849     function minRequiredBalance(address wallet) public view returns (uint256 minBal_) {
850         uint256 deduction;
851         for (uint i = _airdropVestingTime.length - 1; i >= 0; i--) {
852           if (block.timestamp >= _airdropVestingTime[i]) {
853             deduction = _airdropVestingSchedule[i];
854             break;
855           }
856         }
857         minBal_ = _airdropBalance[wallet].mul(100 - deduction).div(100);
858     }
859 
860 }