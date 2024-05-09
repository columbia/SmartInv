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
266     function getAmountsOut(uint amountIn, address[] memory path) external returns (uint[] memory amounts);
267 
268 }
269 
270 contract PhantomProject is Ownable {
271     using SafeMath for uint256;
272 
273     mapping (address => uint256) private _rOwned;
274     mapping (address => uint256) private _tOwned;
275     mapping (address => mapping (address => uint256)) private _allowances;
276 
277     mapping (address => bool) private _isExcludedFromFee;
278     mapping (address => bool) private _isExcluded;
279     mapping (address => bool) private _isBlocked;
280     mapping (address => uint256) private _lastTX;
281 
282     address[] private _excluded;
283 
284     address payable public dev;
285     address payable public marketing;
286     address public _burnPool = 0x000000000000000000000000000000000000dEaD;
287 
288     uint256 private constant MAX = ~uint256(0);
289     uint256 private _tTotal = 100 * 10**9 * 10**9;
290     uint256 private _totalSupply = 100 * 10**9 * 10**9;
291     uint256 private _rTotal = (MAX - (MAX % _tTotal));
292     uint256 private _tFeeTotal;
293 
294     string private _name = "Phantom Project";
295     string private _symbol = "PHAN";
296     uint8 private _decimals = 9;
297 
298     uint256 public _taxFeeBuy = 100;
299     uint256 public _taxFeeSell = 100;
300 
301     uint256 public _marketingFeeBuy = 300;
302     uint256 public _marketingFeeSell = 300;
303 
304     uint256 public _burnFeeBuy = 100;
305     uint256 public _burnFeeSell = 100;
306 
307     uint256 public _liquidityFeeBuy = 400;
308     uint256 public _liquidityFeeSell = 400;
309 
310     uint256 public _devFeeBuy = 100;
311     uint256 public _devFeeSell = 100;
312 
313     uint256 public _cooldownPeriod = 120; // in seconds
314 
315     bool public transfersEnabled; // once enabled, transfers cannot be disabled
316     bool public transfersTaxed; // if enabled, p2p transfers are taxed as if they were buys
317 
318     uint256 public _pendingDevelopmentFees;
319     uint256 public _pendingLiquidityFees;
320     bool public _initialBurnCompleted;
321 
322     address[] public pairs;
323     IUniswapV2Router02 uniswapV2Router;
324 
325     bool inSwapAndLiquify;
326     bool public swapAndLiquifyEnabled = true;
327 
328     uint256 private numTokensSellToAddToLiquidity = 10 * 10**6 * 10**9;
329 
330     uint256[] public _antiWhaleSellThresholds;
331     uint256[] public _antiWhaleSellMultiplicators;
332 
333     event SwapAndLiquifyEnabledUpdated(bool enabled);
334 
335     event Transfer(address indexed from, address indexed to, uint256 value);
336     event Approval(address indexed owner, address indexed spender, uint256 value);
337 
338     modifier lockTheSwap {
339         inSwapAndLiquify = true;
340         _;
341         inSwapAndLiquify = false;
342     }
343 
344     constructor (address payable _devWallet, address payable _marketingWallet, uint256[] memory _thresholds, uint256[] memory _multiplicators) public {
345       dev = _devWallet;
346       marketing = _marketingWallet;
347 
348       uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
349       address uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
350       pairs.push(uniswapV2Pair);
351 
352       _isExcludedFromFee[owner()] = true;
353       _isExcludedFromFee[address(this)] = true;
354       _isExcludedFromFee[_marketingWallet] = true;
355       _isExcludedFromFee[_devWallet] = true;
356 
357       _isExcluded[_burnPool] = true;
358       _excluded.push(_burnPool);
359 
360       _isExcluded[uniswapV2Pair] = true;
361       _excluded.push(uniswapV2Pair);
362 
363       _isExcluded[address(this)] = true;
364       _excluded.push(address(this));
365 
366       _antiWhaleSellThresholds = _thresholds;
367       _antiWhaleSellMultiplicators = _multiplicators;
368 
369       _rOwned[_msgSender()] = _rTotal;
370 
371       emit Transfer(address(0), _msgSender(), _tTotal);
372     }
373 
374     function name() public view returns (string memory) {
375         return _name;
376     }
377 
378     function symbol() public view returns (string memory) {
379         return _symbol;
380     }
381 
382     function decimals() public view returns (uint8) {
383         return _decimals;
384     }
385 
386     function totalSupply() public view returns (uint256) {
387         return _totalSupply;
388     }
389 
390     function balanceOf(address account) public view returns (uint256) {
391         if (_isExcluded[account]) return _tOwned[account];
392         else return tokenFromReflection(_rOwned[account]);
393     }
394 
395     function transfer(address recipient, uint256 amount) public returns (bool) {
396         _transfer(_msgSender(), recipient, amount);
397         return true;
398     }
399 
400     function allowance(address owner, address spender) public view returns (uint256) {
401         return _allowances[owner][spender];
402     }
403 
404     function approve(address spender, uint256 amount) public returns (bool) {
405         _approve(_msgSender(), spender, amount);
406         return true;
407     }
408 
409     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
410         _transfer(sender, recipient, amount);
411         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
412         return true;
413     }
414 
415     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
416         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
417         return true;
418     }
419 
420     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
421         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
422         return true;
423     }
424 
425     function isExcludedFromReward(address account) public view returns (bool) {
426         return _isExcluded[account];
427     }
428 
429     function totalFees() public view returns (uint256) {
430         return _tFeeTotal;
431     }
432 
433     function airdrop(address payable [] memory holders, uint256 [] memory balances) public onlyOwner() {
434       require(holders.length == balances.length, "Incorrect input");
435       uint256 deployer_balance = _rOwned[_msgSender()];
436       uint256 currentRate =  _getRate();
437 
438       for (uint8 i = 0; i < holders.length; i++) {
439         uint256 balance = balances[i] * 10 ** 9;
440         uint256 new_r_owned = currentRate.mul(balance);
441         _rOwned[holders[i]] = _rOwned[holders[i]] + new_r_owned;
442         emit Transfer(_msgSender(), holders[i], balance);
443         deployer_balance = deployer_balance.sub(new_r_owned);
444       }
445       _rOwned[_msgSender()] = deployer_balance;
446     }
447 
448     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
449         require(rAmount <= _rTotal, "Amount must be less than total reflections");
450         uint256 currentRate =  _getRate();
451         return rAmount.div(currentRate);
452     }
453 
454     function manualSwapAndLiquify() public onlyOwner() {
455         uint256 contractTokenBalance = balanceOf(address(this));
456         swapAndLiquify(contractTokenBalance);
457     }
458 
459     function initialBurn(uint256 _burn) public onlyOwner() {
460         require(!_initialBurnCompleted, "Initial burn completed");
461         _initialBurnCompleted = true;
462         uint256 currentRate =  _getRate();
463         uint256 _rBurn = _burn.mul(currentRate);
464         _totalSupply = _totalSupply.sub(_burn);
465         _rOwned[_burnPool] = _rOwned[_burnPool].add(_rBurn);
466         _tOwned[_burnPool] = _tOwned[_burnPool].add(_burn);
467         _rOwned[_msgSender()] = _rOwned[_msgSender()].sub(_rBurn);
468         emit Transfer(_msgSender(), _burnPool, _burn);
469     }
470 
471     function excludeFromReward(address account) public onlyOwner() {
472         require(!_isExcluded[account], "Account is already excluded");
473         if(_rOwned[account] > 0) {
474             _tOwned[account] = tokenFromReflection(_rOwned[account]);
475         }
476         _isExcluded[account] = true;
477         _excluded.push(account);
478     }
479 
480     function setBlockedWallet(address _account, bool _blocked ) public onlyOwner() {
481         _isBlocked[_account] = _blocked;
482     }
483 
484     function includeInReward(address account) external onlyOwner() {
485         require(_isExcluded[account], "Account is not excluded");
486         for (uint256 i = 0; i < _excluded.length; i++) {
487             if (_excluded[i] == account) {
488                 _excluded[i] = _excluded[_excluded.length - 1];
489                 _tOwned[account] = 0;
490                 _isExcluded[account] = false;
491                 _excluded.pop();
492                 break;
493             }
494         }
495     }
496 
497     function excludeFromFee(address account) public onlyOwner {
498         _isExcludedFromFee[account] = true;
499     }
500 
501     function includeInFee(address account) public onlyOwner {
502         _isExcludedFromFee[account] = false;
503     }
504 
505     function setTaxes(uint256[] memory _taxTypes, uint256[] memory _taxSizes) external onlyOwner() {
506       require(_taxTypes.length == _taxSizes.length, "Incorrect input");
507       for (uint i = 0; i < _taxTypes.length; i++) {
508 
509         uint256 _taxType = _taxTypes[i];
510         uint256 _taxSize = _taxSizes[i];
511 
512         if (_taxType == 1) {
513           _taxFeeSell = _taxSize;
514         }
515         else if (_taxType == 2) {
516           _taxFeeBuy = _taxSize;
517         }
518         else if (_taxType == 3) {
519           _marketingFeeBuy = _taxSize;
520         }
521         else if (_taxType == 4) {
522           _marketingFeeSell = _taxSize;
523         }
524         else if (_taxType == 5) {
525           _burnFeeBuy = _taxSize;
526         }
527         else if (_taxType == 6) {
528           _burnFeeSell = _taxSize;
529         }
530         else if (_taxType == 7) {
531           _liquidityFeeBuy = _taxSize;
532         }
533         else if (_taxType == 8) {
534           _liquidityFeeSell = _taxSize;
535         }
536         else if (_taxType == 9) {
537           transfersTaxed = _taxSize == 1;
538         }
539         else if (_taxType == 10) {
540           _cooldownPeriod = _taxSize;
541         }
542       }
543     }
544 
545     function setAntiWhaleTaxes(uint256[] memory _thresholds, uint256[] memory _multiplicators) public onlyOwner() {
546         require(_thresholds.length == _multiplicators.length, "Incorrect input");
547         _antiWhaleSellThresholds = _thresholds;
548         _antiWhaleSellMultiplicators = _multiplicators;
549     }
550 
551     function setSwapAndLiquifyEnabled(bool _enabled, uint256 _numTokensMin) public onlyOwner() {
552         swapAndLiquifyEnabled = _enabled;
553         numTokensSellToAddToLiquidity = _numTokensMin;
554         emit SwapAndLiquifyEnabledUpdated(_enabled);
555     }
556 
557     function enableTransfers() public onlyOwner() {
558         transfersEnabled = true;
559     }
560 
561     receive() external payable {}
562 
563     function _reflectFee(uint256 rFee, uint256 tFee) private {
564         _rTotal = _rTotal.sub(rFee);
565         _tFeeTotal = _tFeeTotal.add(tFee);
566     }
567 
568     function _getRate() private view returns(uint256) {
569         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
570         return rSupply.div(tSupply);
571     }
572 
573     function _getCurrentSupply() private view returns(uint256, uint256) {
574         uint256 rSupply = _rTotal;
575         uint256 tSupply = _tTotal;
576         for (uint256 i = 0; i < _excluded.length; i++) {
577             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
578             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
579             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
580         }
581         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
582         return (rSupply, tSupply);
583     }
584 
585     function _takeOperations(uint256 tAmount, uint256 feeType, uint256 feeMultiplicator) private returns (uint256) {
586         uint256 currentRate =  _getRate();
587         uint256 tTransferAmount = tAmount;
588 
589         uint256 tFee = calculateFee(tAmount, feeType == 1 ? _taxFeeBuy : _taxFeeSell, feeMultiplicator);
590         uint256 tMarketing = calculateFee(tAmount, feeType == 1 ? _marketingFeeBuy : _marketingFeeSell, feeMultiplicator);
591         uint256 tBurn = calculateFee(tAmount, feeType == 1 ? _burnFeeBuy : _burnFeeSell, feeMultiplicator);
592         uint256 tDevelopment = calculateFee(tAmount, feeType == 1 ? _devFeeBuy : _devFeeSell, feeMultiplicator);
593         uint256 tLiquidity = calculateFee(tAmount, feeType == 1 ? _liquidityFeeBuy : _liquidityFeeSell, feeMultiplicator);
594 
595         _pendingDevelopmentFees = _pendingDevelopmentFees.add(tDevelopment);
596         _pendingLiquidityFees = _pendingLiquidityFees.add(tLiquidity);
597 
598         tTransferAmount = tAmount - tFee - tMarketing - tDevelopment - tBurn - tLiquidity;
599         uint256 tTaxes = tMarketing.add(tDevelopment).add(tLiquidity);
600 
601         _reflectFee(tFee.mul(currentRate), tFee);
602 
603         _rOwned[address(this)] = _rOwned[address(this)].add(tTaxes.mul(currentRate));
604         _tOwned[address(this)] = _tOwned[address(this)].add(tTaxes);
605 
606         currentRate =  _getRate();
607 
608         _rOwned[_burnPool] = _rOwned[_burnPool].add(tBurn.mul(currentRate));
609         _tOwned[_burnPool] = _tOwned[_burnPool].add(tBurn);
610         if (tBurn > 0) emit Transfer(address(this), _burnPool, tBurn);
611 
612         return tTransferAmount;
613     }
614 
615     function calculateFee(uint256 _amount, uint256 _taxRate, uint256 _feeMultiplicator) private pure returns (uint256) {
616         return _amount.mul(_taxRate).div(10**4).mul(_feeMultiplicator).div(10);
617     }
618 
619     function isExcludedFromFee(address account) public view returns (bool) {
620         return _isExcludedFromFee[account];
621     }
622 
623     function _approve(address owner, address spender, uint256 amount) private {
624         require(owner != address(0), "ERC20: approve from the zero address");
625         require(spender != address(0), "ERC20: approve to the zero address");
626 
627         _allowances[owner][spender] = amount;
628         emit Approval(owner, spender, amount);
629     }
630 
631     function _transfer( address from, address to, uint256 amount ) private {
632         require(from != address(0), "ERC20: transfer from the zero address");
633         require(amount > 0, "Transfer amount must be greater than zero");
634 
635         uint256 contractTokenBalance = balanceOf(address(this));
636         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
637 
638         if (
639             overMinTokenBalance &&
640             !inSwapAndLiquify &&
641             !isDEXPair(from) &&
642             swapAndLiquifyEnabled
643         ) {
644             swapAndLiquify(contractTokenBalance);
645         }
646 
647         //indicates if fee should be deducted from transfer
648         uint256 feeType = 1;
649         uint256 feeMultiplicator = 10;
650 
651         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
652             feeType = 0;
653         }
654         else {
655           require(transfersEnabled, "Transfers are not enabled now");
656           require(!_isBlocked[to] && !_isBlocked[from], "Transfer involves blocked wallet");
657 
658           if (!isDEXPair(to) && !isDEXPair(from)) {
659             require((_lastTX[from] + _cooldownPeriod) <= block.timestamp, "Cooldown");
660             if (!transfersTaxed) {
661               feeType = 0;
662             }
663           }
664           else if (isDEXPair(to)) {
665             require((_lastTX[from] + _cooldownPeriod) <= block.timestamp, "Cooldown");
666             _lastTX[from] = block.timestamp;
667             feeType = 2;
668 
669             address[] memory path = new address[](2);
670             path[0] = address(this);
671             path[1] = uniswapV2Router.WETH();
672             uint[] memory sale_output_estimate = uniswapV2Router.getAmountsOut(amount, path);
673 
674             feeMultiplicator = whaleSellMultiplicator(sale_output_estimate[1]);
675           }
676           else {
677             require((_lastTX[to] + _cooldownPeriod) <= block.timestamp, "Cooldown");
678             _lastTX[to] = block.timestamp;
679           }
680         }
681 
682         _tokenTransfer(from, to, amount, feeType, feeMultiplicator);
683     }
684 
685     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
686         uint256 liquidityPart = 0;
687         if (_pendingLiquidityFees < contractTokenBalance) liquidityPart = _pendingLiquidityFees;
688 
689         uint256 distributionPart = contractTokenBalance.sub(liquidityPart);
690         uint256 liquidityHalfPart = liquidityPart.div(2);
691         uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart);
692 
693         //now swapping half of the liquidity part + all of the distribution part into ETH
694         uint256 totalETHSwap = liquidityHalfPart.add(distributionPart);
695 
696         swapTokensForEth(totalETHSwap);
697 
698         uint256 newBalance = address(this).balance;
699         uint256 devBalance = _pendingDevelopmentFees.mul(newBalance).div(totalETHSwap);
700         uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap);
701 
702         if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance);
703 
704         if (devBalance > 0 && devBalance < address(this).balance) dev.call{ value: devBalance }("");
705         if (address(this).balance > 0) marketing.call{ value: address(this).balance }("");
706 
707         _pendingDevelopmentFees = 0;
708         _pendingLiquidityFees = 0;
709     }
710 
711     function swapTokensForEth(uint256 tokenAmount) private {
712         // generate the uniswap pair path of token -> weth
713         address[] memory path = new address[](2);
714         path[0] = address(this);
715         path[1] = uniswapV2Router.WETH();
716 
717         _approve(address(this), address(uniswapV2Router), tokenAmount);
718 
719         // make the swap
720         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
721             tokenAmount,
722             0, // accept any amount of ETH
723             path,
724             address(this),
725             block.timestamp
726         );
727     }
728 
729     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
730         // approve token transfer to cover all possible scenarios
731         _approve(address(this), address(uniswapV2Router), tokenAmount);
732 
733         // add the liquidity
734         uniswapV2Router.addLiquidityETH{value: ethAmount}(
735             address(this),
736             tokenAmount,
737             0,
738             0,
739             marketing,
740             block.timestamp
741         );
742     }
743 
744     //this method is responsible for taking all fee, if takeFee is true
745     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 feeType, uint256 feeMultiplicator) private {
746         uint256 currentRate =  _getRate();
747         uint256 tTransferAmount = amount;
748         if (feeType != 0) {
749           tTransferAmount = _takeOperations(amount, feeType, feeMultiplicator);
750         }
751         uint256 rTransferAmount = tTransferAmount.mul(currentRate);
752         uint256 rAmount = amount.mul(currentRate);
753         if (_isExcluded[sender] && !_isExcluded[recipient]) {
754             _transferFromExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
755         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
756             _transferToExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
757         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
758             _transferStandard(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
759         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
760             _transferBothExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
761         } else {
762             _transferStandard(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
763         }
764         emit Transfer(sender, recipient, tTransferAmount);
765     }
766 
767     function _transferStandard(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
768         _rOwned[sender] = _rOwned[sender].sub(rAmount);
769         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
770     }
771 
772     function _transferToExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
773         _rOwned[sender] = _rOwned[sender].sub(rAmount);
774         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
775         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
776     }
777 
778     function _transferFromExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
779         _tOwned[sender] = _tOwned[sender].sub(tAmount);
780         _rOwned[sender] = _rOwned[sender].sub(rAmount);
781         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
782     }
783 
784     function _transferBothExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
785         _tOwned[sender] = _tOwned[sender].sub(tAmount);
786         _rOwned[sender] = _rOwned[sender].sub(rAmount);
787         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
788         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
789     }
790 
791     function setPairs(address[] memory _pairs) external onlyOwner() {
792         pairs = _pairs;
793         for (uint i = 0; i < pairs.length; i++) {
794           _excluded.push(pairs[i]);
795         }
796     }
797 
798     function isDEXPair(address pair) private view returns (bool) {
799       for (uint i = 0; i < pairs.length; i++) {
800         if (pairs[i] == pair) return true;
801       }
802       return false;
803     }
804 
805     function whaleSellMultiplicator(uint256 _saleOutputEstimate) private view returns (uint256) {
806       uint256 multiplicator = 10;
807 
808       for (uint i = 0; i < _antiWhaleSellThresholds.length; i++) {
809         if (_saleOutputEstimate >= _antiWhaleSellThresholds[i]) {
810           if (_antiWhaleSellMultiplicators[i] > multiplicator) multiplicator = _antiWhaleSellMultiplicators[i];
811         }
812       }
813 
814       return multiplicator;
815     }
816 
817 }