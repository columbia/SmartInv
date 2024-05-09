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
172 
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     /**
176      * @dev Initializes the contract setting the deployer as the initial owner.
177      */
178     constructor () internal {
179         address msgSender = _msgSender();
180         _owner = msgSender;
181         emit OwnershipTransferred(address(0), msgSender);
182     }
183 
184     /**
185      * @dev Returns the address of the current owner.
186      */
187     function owner() public view returns (address) {
188         return _owner;
189     }
190 
191     /**
192      * @dev Throws if called by any account other than the owner.
193      */
194     modifier onlyOwner() {
195         require(_owner == _msgSender(), "Ownable: caller is not the owner");
196         _;
197     }
198 
199      /**
200      * @dev Leaves the contract without owner. It will not be possible to call
201      * `onlyOwner` functions anymore. Can only be called by the current owner.
202      *
203      * NOTE: Renouncing ownership will leave the contract without an owner,
204      * thereby removing any functionality that is only available to the owner.
205      */
206     function renounceOwnership() public virtual onlyOwner {
207         emit OwnershipTransferred(_owner, address(0));
208         _owner = address(0);
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Can only be called by the current owner.
214      */
215     function transferOwnership(address newOwner) public virtual onlyOwner {
216         require(newOwner != address(0), "Ownable: new owner is the zero address");
217         emit OwnershipTransferred(_owner, newOwner);
218         _owner = newOwner;
219     }
220 
221 }
222 
223 interface IUniswapV2Factory {
224     function createPair(address tokenA, address tokenB) external returns (address pair);
225 }
226 
227 interface IUniswapV2Router02 {
228     function swapExactTokensForETHSupportingFeeOnTransferTokens(
229         uint amountIn,
230         uint amountOutMin,
231         address[] calldata path,
232         address to,
233         uint deadline
234     ) external;
235     function WETH() external pure returns (address);
236     function factory() external pure returns (address);
237     function addLiquidityETH(
238         address token,
239         uint amountTokenDesired,
240         uint amountTokenMin,
241         uint amountETHMin,
242         address to,
243         uint deadline
244     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
245 }
246 
247 contract HerosV2 is Ownable {
248     using SafeMath for uint256;
249 
250     mapping (address => uint256) private _rOwned;
251     mapping (address => uint256) private _tOwned;
252     mapping (address => mapping (address => uint256)) private _allowances;
253 
254     mapping (address => uint256) public _lastBuyTime;
255     mapping (address => uint256) public _firstBuyTime;
256     mapping (address => uint256) public _accountedRewardsPeriods;
257     mapping (address => uint256) public _rewardsBasis;
258 
259     mapping (address => bool) private _isExcludedFromFee;
260     mapping (address => bool) private _isExcluded;
261 
262     address[] private _excluded;
263 
264     address payable public dev;
265     address payable public charity;
266     address payable public marketing;
267     address public rewards;
268     address public _burnPool = 0x000000000000000000000000000000000000dEaD;
269 
270     uint256 private constant MAX = ~uint256(0);
271     uint256 private _tTotal = 100 * 10**15 * 10**9;
272     uint256 private _rTotal = (MAX - (MAX % _tTotal));
273     uint256 private _tFeeTotal;
274 
275     string private _name = "Heros Token";
276     string private _symbol = "HEROS";
277     uint8 private _decimals = 9;
278 
279     uint256 public _taxFee = 1;
280     uint256 public _liquidityFee = 1;
281     uint256 public _marketingBuyFee = 3;
282     uint256 public _marketingSellFee = 4;
283     uint256 public _developmentBuyFee = 3;
284     uint256 public _developmentSellFee = 4;
285     uint256 public _charityFee = 2;
286     uint256 public _dayTraderMultiplicator = 20; // div by 10
287     uint256 public _rewardRate = 1200; // 12%
288     uint256 public _rewardPeriod = 7776000; // in unix seconds
289     bool public transfersEnabled; //once enabled, transfers cannot be disabled
290 
291     uint256 public _pendingLiquidityFees;
292     uint256 public _pendingCharityFees;
293     uint256 public _pendingMarketingFees;
294     uint256 public _pendingDevelopmentFees;
295 
296     IUniswapV2Router02 public immutable uniswapV2Router;
297     address public uniswapV2Pair;
298 
299     bool inSwapAndLiquify;
300     bool public swapAndLiquifyEnabled = true;
301 
302     uint256 public _maxWalletHolding = 3 * 10**15 * 10**9;
303     uint256 private numTokensSellToAddToLiquidity = 5 * 10**12 * 10**9;
304 
305     event SwapAndLiquifyEnabledUpdated(bool enabled);
306     event SwapAndLiquify(
307         uint256 tokensSwapped,
308         uint256 ethReceived,
309         uint256 tokensIntoLiquidity
310     );
311 
312     event Transfer(address indexed from, address indexed to, uint256 value);
313     event Approval(address indexed owner, address indexed spender, uint256 value);
314 
315     modifier lockTheSwap {
316         inSwapAndLiquify = true;
317         _;
318         inSwapAndLiquify = false;
319     }
320 
321     constructor (address payable _devWallet, address payable _marketingWallet, address payable _charityWallet, address _rewardsWallet) public {
322       dev = _devWallet;
323       marketing = _marketingWallet;
324       charity = _charityWallet;
325       rewards = _rewardsWallet;
326 
327       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
328       uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
329             .createPair(address(this), _uniswapV2Router.WETH());
330       uniswapV2Router = _uniswapV2Router;
331 
332       _isExcludedFromFee[owner()] = true;
333       _isExcludedFromFee[address(this)] = true;
334       _isExcludedFromFee[_burnPool] = true;
335       _isExcludedFromFee[_rewardsWallet] = true;
336 
337       _isExcluded[_burnPool] = true;
338       _excluded.push(_burnPool);
339 
340       _isExcluded[uniswapV2Pair] = true;
341       _excluded.push(uniswapV2Pair);
342 
343       _isExcluded[address(this)] = true;
344       _excluded.push(address(this));
345 
346       uint256 currentRate =  _getRate();
347       uint256 burnPoolAllocation = _tTotal.div(10);
348       _rOwned[_burnPool] = burnPoolAllocation.mul(currentRate);
349       _tOwned[_burnPool] = burnPoolAllocation;
350 
351       currentRate = _getRate();
352       uint256 rewardsAllocation = _tTotal.mul(30).div(100);
353       _rOwned[_rewardsWallet] = rewardsAllocation.mul(currentRate);
354 
355       _rOwned[_msgSender()] = _rTotal - _rOwned[_rewardsWallet] - _rOwned[_burnPool];
356 
357       emit Transfer(address(0), _msgSender(), _tTotal);
358       emit Transfer(_msgSender(), _rewardsWallet, rewardsAllocation);
359       emit Transfer(_msgSender(), _burnPool, burnPoolAllocation);
360     }
361 
362     function name() public view returns (string memory) {
363         return _name;
364     }
365 
366     function symbol() public view returns (string memory) {
367         return _symbol;
368     }
369 
370     function decimals() public view returns (uint8) {
371         return _decimals;
372     }
373 
374     function totalSupply() public view returns (uint256) {
375         return _tTotal;
376     }
377 
378     function balanceOf(address account) public view returns (uint256) {
379         (uint256 totalBalance,) = pendingRewards(account);
380         if (_isExcluded[account]) totalBalance = totalBalance + _tOwned[account];
381         else totalBalance = totalBalance + tokenFromReflection(_rOwned[account]);
382         return totalBalance;
383     }
384 
385     function transfer(address recipient, uint256 amount) public returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     function allowance(address owner, address spender) public view returns (uint256) {
391         return _allowances[owner][spender];
392     }
393 
394     function approve(address spender, uint256 amount) public returns (bool) {
395         _approve(_msgSender(), spender, amount);
396         return true;
397     }
398 
399     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
400         _transfer(sender, recipient, amount);
401         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
402         return true;
403     }
404 
405     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
407         return true;
408     }
409 
410     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
411         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
412         return true;
413     }
414 
415     function isExcludedFromReward(address account) public view returns (bool) {
416         return _isExcluded[account];
417     }
418 
419     function totalFees() public view returns (uint256) {
420         return _tFeeTotal;
421     }
422 
423     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
424         require(rAmount <= _rTotal, "Amount must be less than total reflections");
425         uint256 currentRate =  _getRate();
426         return rAmount.div(currentRate);
427     }
428 
429     function manualSwapAndLiquify() public onlyOwner() {
430         uint256 contractTokenBalance = balanceOf(address(this));
431         swapAndLiquify(contractTokenBalance);
432     }
433 
434     function excludeFromReward(address account) public onlyOwner() {
435         require(!_isExcluded[account], "Account is already excluded");
436         if(_rOwned[account] > 0) {
437             _tOwned[account] = tokenFromReflection(_rOwned[account]);
438         }
439         _isExcluded[account] = true;
440         _excluded.push(account);
441     }
442 
443     function includeInReward(address account) external onlyOwner() {
444         require(_isExcluded[account], "Account is not excluded");
445         for (uint256 i = 0; i < _excluded.length; i++) {
446             if (_excluded[i] == account) {
447                 _excluded[i] = _excluded[_excluded.length - 1];
448                 _tOwned[account] = 0;
449                 _isExcluded[account] = false;
450                 _excluded.pop();
451                 break;
452             }
453         }
454     }
455 
456     function excludeFromFee(address account) public onlyOwner {
457         _isExcludedFromFee[account] = true;
458     }
459 
460     function includeInFee(address account) public onlyOwner {
461         _isExcludedFromFee[account] = false;
462     }
463 
464     function setTax(uint256 _taxType, uint _taxSize) external onlyOwner() {
465       if (_taxType == 1) {
466         _taxFee = _taxSize;
467       }
468       else if (_taxType == 2) {
469         _liquidityFee = _taxSize;
470       }
471       else if (_taxType == 3) {
472         _developmentBuyFee = _taxSize;
473       }
474       else if (_taxType == 4) {
475         _developmentSellFee = _taxSize;
476       }
477       else if (_taxType == 5) {
478         _charityFee = _taxSize;
479       }
480       else if (_taxType == 6) {
481         _marketingBuyFee = _taxSize;
482       }
483       else if (_taxType == 7) {
484         _marketingSellFee = _taxSize;
485       }
486       else if (_taxType == 8) {
487         _dayTraderMultiplicator = _taxSize;
488       }
489       else if (_taxType == 9) {
490         _rewardRate = _taxSize;
491       }
492       else if (_taxType == 10) {
493         _rewardPeriod = _taxSize;
494       }
495     }
496 
497     function setSwapAndLiquifyEnabled(bool _enabled, uint256 _numTokensMin) public onlyOwner() {
498         swapAndLiquifyEnabled = _enabled;
499         numTokensSellToAddToLiquidity = _numTokensMin;
500         emit SwapAndLiquifyEnabledUpdated(_enabled);
501     }
502 
503     function enableTransfers() public onlyOwner() {
504         transfersEnabled = true;
505     }
506 
507     receive() external payable {}
508 
509     function _reflectFee(uint256 rFee, uint256 tFee) private {
510         _rTotal = _rTotal.sub(rFee);
511         _tFeeTotal = _tFeeTotal.add(tFee);
512     }
513 
514     function deliverReflections(uint256 tAmount) external {
515         require(!_isExcluded[msg.sender], "Only holders that are not excluded from rewards can call this");
516         uint256 currentRate =  _getRate();
517         uint256 rAmount = tAmount.mul(currentRate);
518         _rOwned[msg.sender] = _rOwned[msg.sender].sub(rAmount);
519         _reflectFee(rAmount, tAmount);
520     }
521 
522     function _getRate() private view returns(uint256) {
523         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
524         return rSupply.div(tSupply);
525     }
526 
527     function _getCurrentSupply() private view returns(uint256, uint256) {
528         uint256 rSupply = _rTotal;
529         uint256 tSupply = _tTotal;
530         for (uint256 i = 0; i < _excluded.length; i++) {
531             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
532             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
533             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
534         }
535         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
536         return (rSupply, tSupply);
537     }
538 
539     function _takeOperations(uint256 tAmount, uint256 feeType, bool isBuy) private returns (uint256) {
540         uint256 currentRate =  _getRate();
541         uint256 tTransferAmount = tAmount;
542         uint256 taxMultiplicator = 10;
543 
544         if (feeType == 2) taxMultiplicator = _dayTraderMultiplicator;
545 
546         uint256 tFee = calculateFee(tAmount, _taxFee, taxMultiplicator);
547         uint256 tLiquidity = calculateFee(tAmount, _liquidityFee, taxMultiplicator);
548         uint256 tMarketing = calculateFee(tAmount, isBuy ? _marketingBuyFee : _marketingSellFee, taxMultiplicator);
549         uint256 tCharity = calculateFee(tAmount, _charityFee, taxMultiplicator);
550         uint256 tDevelopment = calculateFee(tAmount, isBuy ? _developmentBuyFee : _developmentSellFee, taxMultiplicator);
551 
552         _pendingLiquidityFees = _pendingLiquidityFees.add(tLiquidity);
553         _pendingCharityFees = _pendingCharityFees.add(tCharity);
554         _pendingMarketingFees = _pendingMarketingFees.add(tMarketing);
555         _pendingDevelopmentFees = _pendingDevelopmentFees.add(tDevelopment);
556 
557         tTransferAmount = tAmount - tFee - tLiquidity;
558         tTransferAmount = tTransferAmount - tMarketing - tCharity - tDevelopment;
559         uint256 tTaxes = tLiquidity.add(tMarketing).add(tCharity).add(tDevelopment);
560 
561         _reflectFee(tFee.mul(currentRate), tFee);
562 
563         _rOwned[address(this)] = _rOwned[address(this)].add(tTaxes.mul(currentRate));
564         _tOwned[address(this)] = _tOwned[address(this)].add(tTaxes);
565         return tTransferAmount;
566     }
567 
568     function calculateFee(uint256 _amount, uint256 _taxRate, uint256 _taxMultiplicator) private pure returns (uint256) {
569         return _amount.mul(_taxRate).div(10**2).mul(_taxMultiplicator).div(10);
570     }
571 
572     function isExcludedFromFee(address account) public view returns (bool) {
573         return _isExcludedFromFee[account];
574     }
575 
576     function pendingRewards(address account) public view returns (uint256, uint256) {
577         if (!_isExcluded[account]) {
578           uint256 rewardTimespan = block.timestamp.sub(_firstBuyTime[account]);
579           if (_firstBuyTime[account] == 0) rewardTimespan = 0;
580           uint256 rewardPeriods = rewardTimespan.div(_rewardPeriod);
581           if (rewardPeriods >= _accountedRewardsPeriods[account]) rewardPeriods = rewardPeriods - _accountedRewardsPeriods[account];
582           else rewardPeriods = 0;
583           uint256 _pendingRewards = rewardPeriods.mul(_rewardRate).mul(_rewardsBasis[account]).div(10**4);
584           return (_pendingRewards, rewardPeriods);
585         }
586         return (0, 0);
587     }
588 
589     function _approve(address owner, address spender, uint256 amount) private {
590         require(owner != address(0), "ERC20: approve from the zero address");
591         require(spender != address(0), "ERC20: approve to the zero address");
592 
593         _allowances[owner][spender] = amount;
594         emit Approval(owner, spender, amount);
595     }
596 
597     function _transfer( address from, address to, uint256 amount ) private {
598         require(from != address(0), "ERC20: transfer from the zero address");
599         require(amount > 0, "Transfer amount must be greater than zero");
600 
601         uint256 contractTokenBalance = balanceOf(address(this));
602         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
603 
604         if (
605             overMinTokenBalance &&
606             !inSwapAndLiquify &&
607             from != uniswapV2Pair &&
608             swapAndLiquifyEnabled
609         ) {
610             swapAndLiquify(contractTokenBalance);
611         }
612 
613         _lastBuyTime[to] = block.timestamp;
614         if (_firstBuyTime[to] == 0) _firstBuyTime[to] = block.timestamp;
615 
616         bool distributedFrom = distributeRewards(from);
617         bool distributedTo = distributeRewards(to);
618 
619         //indicates if fee should be deducted from transfer
620         uint256 feeType = 1;
621         bool isBuy = from == uniswapV2Pair;
622 
623         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
624             feeType = 0;
625         }
626         else {
627           require(transfersEnabled, "Transfers are not enabled now");
628           if (to != uniswapV2Pair && from != uniswapV2Pair) {
629             feeType = 0;
630           }
631           if (to == uniswapV2Pair || (to != uniswapV2Pair && from != uniswapV2Pair)) {
632             if (_lastBuyTime[from] != 0 && (_lastBuyTime[from] + (24 hours) > block.timestamp) ) {
633               feeType = 2;
634             }
635           }
636         }
637 
638         _tokenTransfer(from, to, amount, feeType, isBuy);
639 
640         syncRewards(from, distributedFrom);
641         syncRewards(to, distributedTo);
642 
643         if (!_isExcludedFromFee[to] && (to != uniswapV2Pair)) require(balanceOf(to) < _maxWalletHolding, "Max Wallet holding limit exceeded");
644     }
645 
646     function distributeRewards(address account) private returns (bool) {
647         (uint256 _rewards, uint256 _periods) = pendingRewards(account);
648         if (_rewards > 0) {
649           _accountedRewardsPeriods[account] = _accountedRewardsPeriods[account] + _periods;
650           uint256 currentRate =  _getRate();
651           uint256 rRewards = _rewards.mul(currentRate);
652           if (_rOwned[rewards] > rRewards) {
653             _rOwned[account] = _rOwned[account].add(rRewards);
654             _rOwned[rewards] = _rOwned[rewards].sub(rRewards);
655           }
656           return true;
657         }
658         return false;
659     }
660 
661     function syncRewards(address account, bool rewardsDistributed) private {
662         uint256 accountBalance = balanceOf(account);
663         if (_rewardsBasis[account] == 0 || accountBalance < _rewardsBasis[account] || rewardsDistributed ) _rewardsBasis[account] = accountBalance;
664     }
665 
666     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
667         uint256 liquidityPart = 0;
668         if (_pendingLiquidityFees < contractTokenBalance) liquidityPart = _pendingLiquidityFees;
669         uint256 distributionPart = contractTokenBalance.sub(liquidityPart);
670         uint256 totalPendingFees = _pendingLiquidityFees + _pendingCharityFees + _pendingMarketingFees + _pendingDevelopmentFees;
671         uint256 liquidityHalfPart = liquidityPart.div(2);
672         uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart);
673 
674         //now swapping half of the liquidity part + all of the distribution part into ETH
675         uint256 totalETHSwap = liquidityHalfPart.add(distributionPart);
676 
677         uint256 initialBalance = address(this).balance;
678 
679         // swap tokens for ETH
680         swapTokensForEth(totalETHSwap);
681 
682         uint256 newBalance = address(this).balance.sub(initialBalance);
683         uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap);
684 
685         // add liquidity to uniswap
686         if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance);
687         emit SwapAndLiquify(liquidityHalfPart, liquidityBalance, liquidityHalfPart);
688 
689         newBalance = address(this).balance;
690 
691         uint256 payMarketing = _pendingMarketingFees.mul(newBalance).div(totalPendingFees);
692         uint256 payDevelopment = _pendingDevelopmentFees.mul(newBalance).div(totalPendingFees);
693 
694         if (payMarketing <= address(this).balance) marketing.call{ value: payMarketing }("");
695         if (payDevelopment <= address(this).balance) dev.call{ value: payDevelopment }("");
696         if (address(this).balance > 0) charity.call{ value: address(this).balance }("");
697 
698         _pendingLiquidityFees = 0;
699         _pendingCharityFees = 0;
700         _pendingMarketingFees = 0;
701         _pendingDevelopmentFees = 0;
702     }
703 
704     function swapTokensForEth(uint256 tokenAmount) private {
705         // generate the uniswap pair path of token -> weth
706         address[] memory path = new address[](2);
707         path[0] = address(this);
708         path[1] = uniswapV2Router.WETH();
709 
710         _approve(address(this), address(uniswapV2Router), tokenAmount);
711 
712         // make the swap
713         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
714             tokenAmount,
715             0, // accept any amount of ETH
716             path,
717             address(this),
718             block.timestamp
719         );
720     }
721 
722     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
723         // approve token transfer to cover all possible scenarios
724         _approve(address(this), address(uniswapV2Router), tokenAmount);
725 
726         // add the liquidity
727         uniswapV2Router.addLiquidityETH{value: ethAmount}(
728             address(this),
729             tokenAmount,
730             0, // slippage is unavoidable
731             0, // slippage is unavoidable
732             owner(),
733             block.timestamp
734         );
735     }
736 
737     //this method is responsible for taking all fee, if takeFee is true
738     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 feeType, bool isBuy) private {
739         uint256 currentRate =  _getRate();
740         uint256 tTransferAmount = amount;
741         if (feeType != 0) {
742           tTransferAmount = _takeOperations(amount, feeType, isBuy);
743         }
744         uint256 rTransferAmount = tTransferAmount.mul(currentRate);
745         uint256 rAmount = amount.mul(currentRate);
746         if (_isExcluded[sender] && !_isExcluded[recipient]) {
747             _transferFromExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
748         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
749             _transferToExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
750         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
751             _transferStandard(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
752         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
753             _transferBothExcluded(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
754         } else {
755             _transferStandard(sender, recipient, rAmount, amount, tTransferAmount, rTransferAmount);
756         }
757         emit Transfer(sender, recipient, tTransferAmount);
758     }
759 
760     function _transferStandard(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
761         _rOwned[sender] = _rOwned[sender].sub(rAmount);
762         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
763     }
764 
765     function _transferToExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
766         _rOwned[sender] = _rOwned[sender].sub(rAmount);
767         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
768         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
769     }
770 
771     function _transferFromExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
772         _tOwned[sender] = _tOwned[sender].sub(tAmount);
773         _rOwned[sender] = _rOwned[sender].sub(rAmount);
774         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
775     }
776 
777     function _transferBothExcluded(address sender, address recipient, uint256 rAmount, uint256 tAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
778         _tOwned[sender] = _tOwned[sender].sub(tAmount);
779         _rOwned[sender] = _rOwned[sender].sub(rAmount);
780         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
781         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
782     }
783 
784 }