1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      *
13      * - Addition cannot overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, reverting on
24      * overflow (when the result is negative).
25      *
26      * Counterpart to Solidity's `-` operator.
27      *
28      * Requirements:
29      *
30      * - Subtraction cannot overflow.
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      *
61      * - Multiplication cannot overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the integer division of two unsigned integers. Reverts on
79      * division by zero. The result is rounded towards zero.
80      *
81      * Counterpart to Solidity's `/` operator. Note: this function uses a
82      * `revert` opcode (which leaves remaining gas untouched) while Solidity
83      * uses an invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      *
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * Reverts when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         return mod(a, b, "SafeMath: modulo by zero");
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts with custom message when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b != 0, errorMessage);
143         return a % b;
144     }
145 }
146 
147 abstract contract Context {
148     function _msgSender() internal view virtual returns (address payable) {
149         return msg.sender;
150     }
151 
152     function _msgData() internal view virtual returns (bytes memory) {
153         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
154         return msg.data;
155     }
156 }
157 
158 /**
159  * @dev Contract module which provides a basic access control mechanism, where
160  * there is an account (an owner) that can be granted exclusive access to
161  * specific functions.
162  *
163  * By default, the owner account will be the one that deploys the contract. This
164  * can later be changed with {transferOwnership}.
165  *
166  * This module is used through inheritance. It will make available the modifier
167  * `onlyOwner`, which can be applied to your functions to restrict their use to
168  * the owner.
169  */
170 contract Ownable is Context {
171     address private _owner;
172     address private _previousOwner;
173     uint256 private _lockTime;
174 
175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177     /**
178      * @dev Initializes the contract setting the deployer as the initial owner.
179      */
180     constructor () internal {
181         address msgSender = _msgSender();
182         _owner = msgSender;
183         emit OwnershipTransferred(address(0), msgSender);
184     }
185 
186     /**
187      * @dev Returns the address of the current owner.
188      */
189     function owner() public view returns (address) {
190         return _owner;
191     }
192 
193     /**
194      * @dev Throws if called by any account other than the owner.
195      */
196     modifier onlyOwner() {
197         require(_owner == _msgSender(), "Ownable: caller is not the owner");
198         _;
199     }
200 
201      /**
202      * @dev Leaves the contract without owner. It will not be possible to call
203      * `onlyOwner` functions anymore. Can only be called by the current owner.
204      *
205      * NOTE: Renouncing ownership will leave the contract without an owner,
206      * thereby removing any functionality that is only available to the owner.
207      */
208     function renounceOwnership() public virtual onlyOwner {
209         emit OwnershipTransferred(_owner, address(0));
210         _owner = address(0);
211     }
212 
213     /**
214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
215      * Can only be called by the current owner.
216      */
217     function transferOwnership(address newOwner) public virtual onlyOwner {
218         require(newOwner != address(0), "Ownable: new owner is the zero address");
219         emit OwnershipTransferred(_owner, newOwner);
220         _owner = newOwner;
221     }
222 
223     function geUnlockTime() public view returns (uint256) {
224         return _lockTime;
225     }
226 
227     //Locks the contract for owner for the amount of time provided
228     function lock(uint256 time) public virtual onlyOwner {
229         _previousOwner = _owner;
230         _owner = address(0);
231         _lockTime = now + time;
232         emit OwnershipTransferred(_owner, address(0));
233     }
234 
235     //Unlocks the contract for owner when _lockTime is exceeds
236     function unlock() public virtual {
237         require(_previousOwner == msg.sender, "You don't have permission to unlock");
238         require(now > _lockTime , "Contract is locked until 7 days");
239         emit OwnershipTransferred(_owner, _previousOwner);
240         _owner = _previousOwner;
241     }
242 }
243 
244 interface IUniswapV2Factory {
245     function createPair(address tokenA, address tokenB) external returns (address pair);
246 }
247 
248 interface IUniswapV2Router02 {
249     function swapExactTokensForETHSupportingFeeOnTransferTokens(
250         uint amountIn,
251         uint amountOutMin,
252         address[] calldata path,
253         address to,
254         uint deadline
255     ) external;
256     function WETH() external pure returns (address);
257     function factory() external pure returns (address);
258     function addLiquidityETH(
259         address token,
260         uint amountTokenDesired,
261         uint amountTokenMin,
262         uint amountETHMin,
263         address to,
264         uint deadline
265     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
266 }
267 
268 contract Grifters is Ownable {
269     using SafeMath for uint256;
270 
271     mapping (address => uint256) private _rOwned;
272     mapping (address => uint256) private _tOwned;
273     mapping (address => mapping (address => uint256)) private _allowances;
274 
275     mapping (address => bool) private _isSniper;
276     mapping (address => bool) private _isExcludedFromFee;
277     mapping (address => bool) private _isExcluded;
278 
279     address[] private _excluded;
280 
281     address payable public dev;
282     address payable public marketing;
283     address payable public redemption;
284     address public _burnPool = 0x0000000000000000000000000000000000000000;
285 
286     uint256 private constant MAX = ~uint256(0);
287     uint256 private _tTotal = 1 * 10**15 * 10**9;
288     uint256 private _rTotal = (MAX - (MAX % _tTotal));
289     uint256 private _tFeeTotal;
290 
291     string private _name = "Grifters";
292     string private _symbol = "DELC";
293     uint8 private _decimals = 9;
294 
295     uint256 public _taxFee = 300;
296     uint256 public _marketingFee = 300;
297     uint256 public _redemptionFee = 300;
298     uint256 public _developmentFee = 100;
299     bool public transfersEnabled; //once enabled, transfers cannot be disabled
300 
301     uint256 private launchBlock;
302     uint256 private launchTime;
303     uint256 private blocksLimit;
304 
305     uint256 public _pendingDevelopmentFees;
306     uint256 public _pendingMarketingFees;
307 
308     address[] public pairs;
309     IUniswapV2Router02 uniswapV2Router;
310 
311     bool inSwapAndLiquify;
312     bool public swapAndLiquifyEnabled = true;
313 
314     uint256 public _maxWalletHolding = 50 * 10**12 * 10**9;
315     uint256 private numTokensSellToAddToLiquidity = 5 * 10**10 * 10**9;
316 
317     uint256 public _marketingAllocation = 1725 * 10**10 * 10**9;
318     uint256 public _exchangeAllocation = 600 * 10**12 * 10**9;
319 
320     event SwapAndLiquifyEnabledUpdated(bool enabled);
321 
322     event Transfer(address indexed from, address indexed to, uint256 value);
323     event Approval(address indexed owner, address indexed spender, uint256 value);
324 
325     modifier lockTheSwap {
326         inSwapAndLiquify = true;
327         _;
328         inSwapAndLiquify = false;
329     }
330 
331     constructor (address payable _devWallet, address payable _marketingWallet, address payable _redemptionWallet, address _exchangeWallet) public {
332       dev = _devWallet;
333       marketing = _marketingWallet;
334       redemption = _redemptionWallet;
335 
336       uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
337       address uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
338       pairs.push(uniswapV2Pair);
339 
340       _isExcludedFromFee[owner()] = true;
341       _isExcludedFromFee[address(this)] = true;
342       _isExcludedFromFee[_marketingWallet] = true;
343       _isExcludedFromFee[_exchangeWallet] = true;
344 
345       _isExcluded[_burnPool] = true;
346       _excluded.push(_burnPool);
347 
348       _isExcluded[uniswapV2Pair] = true;
349       _excluded.push(uniswapV2Pair);
350 
351       _isExcluded[address(this)] = true;
352       _excluded.push(address(this));
353 
354       uint256 currentRate =  _getRate();
355       _rOwned[_marketingWallet] = _marketingAllocation.mul(currentRate);
356 
357       currentRate = _getRate();
358       _rOwned[_exchangeWallet] = _exchangeAllocation.mul(currentRate);
359 
360       _rOwned[_msgSender()] = _rTotal - _rOwned[_marketingWallet] - _rOwned[_exchangeWallet];
361 
362       emit Transfer(address(0), _msgSender(), _tTotal);
363       emit Transfer(_msgSender(), _marketingWallet, _marketingAllocation);
364       emit Transfer(_msgSender(), _exchangeWallet, _exchangeAllocation);
365     }
366 
367     function name() public view returns (string memory) {
368         return _name;
369     }
370 
371     function symbol() public view returns (string memory) {
372         return _symbol;
373     }
374 
375     function decimals() public view returns (uint8) {
376         return _decimals;
377     }
378 
379     function totalSupply() public view returns (uint256) {
380         return _tTotal;
381     }
382 
383     function balanceOf(address account) public view returns (uint256) {
384         if (_isExcluded[account]) return _tOwned[account];
385         else return tokenFromReflection(_rOwned[account]);
386     }
387 
388     function transfer(address recipient, uint256 amount) public returns (bool) {
389         _transfer(_msgSender(), recipient, amount);
390         return true;
391     }
392 
393     function allowance(address owner, address spender) public view returns (uint256) {
394         return _allowances[owner][spender];
395     }
396 
397     function approve(address spender, uint256 amount) public returns (bool) {
398         _approve(_msgSender(), spender, amount);
399         return true;
400     }
401 
402     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
403         _transfer(sender, recipient, amount);
404         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
405         return true;
406     }
407 
408     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
409         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
410         return true;
411     }
412 
413     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
414         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
415         return true;
416     }
417 
418     function isExcludedFromReward(address account) public view returns (bool) {
419         return _isExcluded[account];
420     }
421 
422     function totalFees() public view returns (uint256) {
423         return _tFeeTotal;
424     }
425 
426     function airdrop(address payable [] memory holders, uint256 [] memory balances) public onlyOwner() {
427       require(holders.length == balances.length, "Incorrect input");
428       uint256 deployer_balance = _rOwned[_msgSender()];
429       uint256 currentRate =  _getRate();
430 
431       for (uint8 i = 0; i < holders.length; i++) {
432         uint256 balance = balances[i] * 10 ** 18;
433         uint256 new_r_owned = currentRate.mul(balance);
434         _rOwned[holders[i]] = _rOwned[holders[i]] + new_r_owned;
435         emit Transfer(_msgSender(), holders[i], balance);
436         deployer_balance = deployer_balance.sub(new_r_owned);
437       }
438       _rOwned[_msgSender()] = deployer_balance;
439     }
440 
441     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
442         require(rAmount <= _rTotal, "Amount must be less than total reflections");
443         uint256 currentRate =  _getRate();
444         return rAmount.div(currentRate);
445     }
446 
447     function manualSwapAndLiquify() public onlyOwner() {
448         uint256 contractTokenBalance = balanceOf(address(this));
449         swapAndLiquify(contractTokenBalance);
450     }
451 
452     function excludeFromReward(address account) public onlyOwner() {
453         require(!_isExcluded[account], "Account is already excluded");
454         if(_rOwned[account] > 0) {
455             _tOwned[account] = tokenFromReflection(_rOwned[account]);
456         }
457         _isExcluded[account] = true;
458         _excluded.push(account);
459     }
460 
461     function includeInReward(address account) external onlyOwner() {
462         require(_isExcluded[account], "Account is not excluded");
463         for (uint256 i = 0; i < _excluded.length; i++) {
464             if (_excluded[i] == account) {
465                 _excluded[i] = _excluded[_excluded.length - 1];
466                 _tOwned[account] = 0;
467                 _isExcluded[account] = false;
468                 _excluded.pop();
469                 break;
470             }
471         }
472     }
473 
474     function excludeFromFee(address account) public onlyOwner {
475         _isExcludedFromFee[account] = true;
476     }
477 
478     function includeInFee(address account) public onlyOwner {
479         _isExcludedFromFee[account] = false;
480     }
481 
482     function setTax(uint256 _taxType, uint _taxSize) external onlyOwner() {
483       if (_taxType == 1) {
484         _taxFee = _taxSize;
485       }
486       else if (_taxType == 2) {
487         _developmentFee = _taxSize;
488       }
489       else if (_taxType == 3) {
490         _marketingFee = _taxSize;
491       }
492       else if (_taxType == 4) {
493         _redemptionFee = _taxSize;
494       }
495     }
496 
497     function setSwapAndLiquifyEnabled(bool _enabled, uint256 _numTokensMin) public onlyOwner() {
498         swapAndLiquifyEnabled = _enabled;
499         numTokensSellToAddToLiquidity = _numTokensMin;
500         emit SwapAndLiquifyEnabledUpdated(_enabled);
501     }
502 
503     function enableTransfers(uint256 _blocksLimit) public onlyOwner() {
504         transfersEnabled = true;
505         launchBlock = block.number;
506         launchTime = block.timestamp;
507         blocksLimit = _blocksLimit;
508     }
509 
510     function setSniperEnabled(bool _enabled, address sniper) public onlyOwner() {
511         _isSniper[sniper] = _enabled;
512     }
513 
514     receive() external payable {}
515 
516     function _reflectFee(uint256 rFee, uint256 tFee) private {
517         _rTotal = _rTotal.sub(rFee);
518         _tFeeTotal = _tFeeTotal.add(tFee);
519     }
520 
521     function _getRate() private view returns(uint256) {
522         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
523         return rSupply.div(tSupply);
524     }
525 
526     function _getCurrentSupply() private view returns(uint256, uint256) {
527         uint256 rSupply = _rTotal;
528         uint256 tSupply = _tTotal;
529         for (uint256 i = 0; i < _excluded.length; i++) {
530             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
531             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
532             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
533         }
534         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
535         return (rSupply, tSupply);
536     }
537 
538     function _takeOperations(uint256 tAmount) private returns (uint256) {
539         uint256 currentRate =  _getRate();
540         uint256 tTransferAmount = tAmount;
541 
542         uint256 tFee = calculateFee(tAmount, _taxFee);
543         uint256 tMarketing = calculateFee(tAmount, _marketingFee);
544         uint256 tDevelopment = calculateFee(tAmount, _developmentFee);
545         uint256 tRedemptions = calculateFee(tAmount, _redemptionFee);
546 
547         _pendingDevelopmentFees = _pendingDevelopmentFees.add(tDevelopment);
548         _pendingMarketingFees = _pendingMarketingFees.add(tMarketing);
549 
550         tTransferAmount = tAmount - tFee - tMarketing - tDevelopment - tRedemptions;
551         uint256 tTaxes = tMarketing.add(tDevelopment).add(tRedemptions);
552 
553         _reflectFee(tFee.mul(currentRate), tFee);
554 
555         _rOwned[address(this)] = _rOwned[address(this)].add(tTaxes.mul(currentRate));
556         _tOwned[address(this)] = _tOwned[address(this)].add(tTaxes);
557 
558         return tTransferAmount;
559     }
560 
561     function calculateFee(uint256 _amount, uint256 _taxRate) private pure returns (uint256) {
562         return _amount.mul(_taxRate).div(10**4);
563     }
564 
565     function isExcludedFromFee(address account) public view returns (bool) {
566         return _isExcludedFromFee[account];
567     }
568 
569     function _approve(address owner, address spender, uint256 amount) private {
570         require(owner != address(0), "ERC20: approve from the zero address");
571         require(spender != address(0), "ERC20: approve to the zero address");
572 
573         _allowances[owner][spender] = amount;
574         emit Approval(owner, spender, amount);
575     }
576 
577     function _transfer( address from, address to, uint256 amount ) private {
578         require(from != address(0), "ERC20: transfer from the zero address");
579         require(amount > 0, "Transfer amount must be greater than zero");
580 
581         uint256 contractTokenBalance = balanceOf(address(this));
582         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
583 
584         if (
585             overMinTokenBalance &&
586             !inSwapAndLiquify &&
587             !isDEXPair(from) &&
588             swapAndLiquifyEnabled
589         ) {
590             swapAndLiquify(contractTokenBalance);
591         }
592 
593         //indicates if fee should be deducted from transfer
594         uint256 feeType = 1;
595 
596         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
597             feeType = 0;
598         }
599         else {
600           require(transfersEnabled, "Transfers are not enabled now");
601           if (isDEXPair(to) || (!isDEXPair(to) && !isDEXPair(from))) {
602             require(!_isSniper[from], "SNIPER!");
603             if (!isDEXPair(to) && !isDEXPair(from)) {
604               feeType = 0;
605             }
606           }
607           if (isDEXPair(from)) {
608             if (block.number <= (launchBlock + blocksLimit)) _isSniper[to] = true;
609           }
610         }
611 
612         _tokenTransfer(from, to, amount, feeType);
613 
614         if (!_isExcludedFromFee[to] && !isDEXPair(to)) require(balanceOf(to) < _maxWalletHolding, "Max Wallet holding limit exceeded");
615     }
616 
617     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
618         uint256 initialBalance = address(this).balance;
619         swapTokensForEth(contractTokenBalance);
620         uint256 newBalance = address(this).balance.sub(initialBalance);
621         uint256 payDevelopment = _pendingDevelopmentFees.mul(newBalance).div(contractTokenBalance);
622         uint256 payMarketing = _pendingMarketingFees.mul(newBalance).div(contractTokenBalance);
623         if (payDevelopment <= address(this).balance) dev.call{ value: payDevelopment }("");
624         if (payMarketing <= address(this).balance) marketing.call{ value: payMarketing }("");
625         if (address(this).balance > 0) redemption.call{ value: address(this).balance }("");
626         _pendingDevelopmentFees = 0;
627         _pendingMarketingFees = 0;
628     }
629 
630     function swapTokensForEth(uint256 tokenAmount) private {
631         // generate the uniswap pair path of token -> weth
632         address[] memory path = new address[](2);
633         path[0] = address(this);
634         path[1] = uniswapV2Router.WETH();
635 
636         _approve(address(this), address(uniswapV2Router), tokenAmount);
637 
638         // make the swap
639         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
640             tokenAmount,
641             0, // accept any amount of ETH
642             path,
643             address(this),
644             block.timestamp
645         );
646     }
647 
648     //this method is responsible for taking all fee, if takeFee is true
649     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 feeType) private {
650         uint256 currentRate =  _getRate();
651         uint256 tTransferAmount = amount;
652         if (feeType != 0) {
653           tTransferAmount = _takeOperations(amount);
654         }
655         uint256 rTransferAmount = tTransferAmount.mul(currentRate);
656         uint256 rAmount = amount.mul(currentRate);
657         if (_isExcluded[sender] && !_isExcluded[recipient]) {
658             _transferFromExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
659         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
660             _transferToExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
661         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
662             _transferStandard(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
663         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
664             _transferBothExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
665         } else {
666             _transferStandard(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
667         }
668         emit Transfer(sender, recipient, tTransferAmount);
669     }
670 
671     function _transferStandard(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
672         _rOwned[sender] = _rOwned[sender].sub(rAmount);
673         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
674     }
675 
676     function _transferToExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
677         _rOwned[sender] = _rOwned[sender].sub(rAmount);
678         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
679         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
680     }
681 
682     function _transferFromExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
683         _tOwned[sender] = _tOwned[sender].sub(tAmount);
684         _rOwned[sender] = _rOwned[sender].sub(rAmount);
685         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
686     }
687 
688     function _transferBothExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
689         _tOwned[sender] = _tOwned[sender].sub(tAmount);
690         _rOwned[sender] = _rOwned[sender].sub(rAmount);
691         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
692         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
693     }
694 
695     function setPairs(address[] memory _pairs) external onlyOwner() {
696         pairs = _pairs;
697         for (uint i = 0; i < pairs.length; i++) {
698           _excluded.push(pairs[i]);
699         }
700     }
701 
702     function isDEXPair(address pair) private view returns (bool) {
703       for (uint i = 0; i < pairs.length; i++) {
704         if (pairs[i] == pair) return true;
705       }
706       return false;
707     }
708 
709 }