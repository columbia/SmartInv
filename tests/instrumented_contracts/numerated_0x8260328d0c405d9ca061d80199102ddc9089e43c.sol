1 /**
2  * SPDX-License-Identifier: UNLICENSED 
3  * 
4 */
5 
6 pragma solidity ^0.8.7;
7 
8 interface IERC20 {
9 
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90  
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address) {
236         return msg.sender;
237     }
238 }
239 
240 /**
241  * @dev Contract module which provides a basic access control mechanism, where
242  * there is an account (an owner) that can be granted exclusive access to
243  * specific functions.
244  *
245  * By default, the owner account will be the one that deploys the contract. This
246  * can later be changed with {transferOwnership}.
247  *
248  * This module is used through inheritance. It will make available the modifier
249  * `onlyOwner`, which can be applied to your functions to restrict their use to
250  * the owner.
251  */
252 contract Ownable is Context {
253     address private _owner;
254     address private _previousOwner;
255     uint256 private _lockTime;
256 
257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
258 
259     /**
260      * @dev Initializes the contract setting the deployer as the initial owner.
261      */
262     constructor () {
263         address msgSender = _msgSender();
264         _owner = msgSender;
265         emit OwnershipTransferred(address(0), msgSender);
266     }
267 
268     /**
269      * @dev Returns the address of the current owner.
270      */
271     function owner() public view returns (address) {
272         return _owner;
273     }
274 
275     /**
276      * @dev Throws if called by any account other than the owner.
277      */
278     modifier onlyOwner() {
279         require(_owner == _msgSender(), "Ownable: caller is not the owner");
280         _;
281     }
282 
283      /**
284      * @dev Leaves the contract without owner. It will not be possible to call
285      * `onlyOwner` functions anymore. Can only be called by the current owner.
286      *
287      * NOTE: Renouncing ownership will leave the contract without an owner,
288      * thereby removing any functionality that is only available to the owner.
289      */
290     function renounceOwnership() public virtual onlyOwner {
291         emit OwnershipTransferred(_owner, address(0));
292         _owner = address(0);
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Can only be called by the current owner.
298      */
299     function transferOwnership(address newOwner) public virtual onlyOwner {
300         require(newOwner != address(0), "Ownable: new owner is the zero address");
301         emit OwnershipTransferred(_owner, newOwner);
302         _owner = newOwner;
303     }
304 
305     function geUnlockTime() public view returns (uint256) {
306         return _lockTime;
307     }
308 
309     //Locks the contract for owner for the amount of time provided
310     function lock(uint256 time) public virtual onlyOwner {
311         _previousOwner = _owner;
312         _owner = address(0);
313         _lockTime = block.timestamp + time;
314         emit OwnershipTransferred(_owner, address(0));
315     }
316     
317     //Unlocks the contract for owner when _lockTime is exceeds
318     function unlock() public virtual {
319         require(_previousOwner == msg.sender, "You don't have permission to unlock");
320         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
321         emit OwnershipTransferred(_owner, _previousOwner);
322         _owner = _previousOwner;
323     }
324 }
325 
326 interface IUniswapV2Factory {
327     function createPair(address tokenA, address tokenB) external returns (address pair);
328 }
329 
330 interface IUniswapV2Router02 {
331     function swapExactTokensForETHSupportingFeeOnTransferTokens(
332         uint amountIn,
333         uint amountOutMin,
334         address[] calldata path,
335         address to,
336         uint deadline
337     ) external;
338     function factory() external pure returns (address);
339     function WETH() external pure returns (address);
340     function addLiquidityETH(
341         address token,
342         uint amountTokenDesired,
343         uint amountTokenMin,
344         uint amountETHMin,
345         address to,
346         uint deadline
347     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
348 }
349 
350 contract DOJO is Context, IERC20, Ownable {
351     using SafeMath for uint256;
352 
353     string private constant _name = "Dojo Supercomputer";
354     string private constant _symbol = "DOJO";
355     uint8 private constant _decimals = 9;
356     uint256 private constant MAX = ~uint256(0);
357     uint256 private constant _tTotal = 1e15 * 10**9;
358     uint256 private _rTotal = (MAX - (MAX % _tTotal));
359     uint256 private _tFeeTotal;
360     uint256 private minContractTokensToSwap = 1e12 * 10**9;
361     mapping (address => uint256) private _rOwned;
362     mapping (address => uint256) private _tOwned;
363     mapping (address => mapping (address => uint256)) private _allowances;
364     mapping (address => bool) private _isExcludedFromFee;
365     mapping (address => bool) private _isExcludedFromMaxWallet;
366     mapping (address => bool) private _bots;
367     uint256 private _taxFee = 0;
368     uint256 private _teamFee = 25;
369     uint256 private _maxWalletSize = 2e13 * 10**9;
370     uint256 private _buyFee = 25;
371     uint256 private _sellFee = 25;
372     uint256 private _previousTaxFee = _taxFee;
373     uint256 private _previousteamFee = _teamFee;
374     address payable private _treasury;
375     address payable private _marketingWallet;
376     IUniswapV2Router02 private uniswapV2Router;
377     address private uniswapV2Pair;
378     bool private tradingOpen = false;
379     bool private _swapAll = false;
380     bool private inSwap = false;
381     mapping(address => bool) private automatedMarketMakerPairs;
382 
383     event SwapAndLiquify(
384         uint256 tokensSwapped,
385         uint256 ethReceived,
386         uint256 tokensIntoLiqudity
387     );
388     event Response(bool treasury, bool marketing);
389 
390     modifier lockTheSwap {
391         inSwap = true;
392         _;
393         inSwap = false;
394     }
395         constructor () {
396 
397         _treasury = payable(0x9c3bdf69858A7Bee4bD2a8082c3A6B98fE147eF4);
398         _marketingWallet = payable(0x9eF2555736feee8C88485fa17b4533Aa9649A9C7);
399         
400         _rOwned[_msgSender()] = _rTotal;
401         _isExcludedFromFee[owner()] = true;
402         _isExcludedFromFee[address(this)] = true;
403 
404         _isExcludedFromFee[_treasury] = true;
405         _isExcludedFromFee[_marketingWallet] = true;
406 
407         _isExcludedFromMaxWallet[owner()] = true;
408         _isExcludedFromMaxWallet[address(this)] = true;
409         _isExcludedFromMaxWallet[_treasury] = true;
410         _isExcludedFromMaxWallet[_marketingWallet] = true;
411 
412         emit Transfer(address(0), _msgSender(), _tTotal);
413     }
414 
415     function name() public pure returns (string memory) {
416         return _name;
417     }
418     
419     function _transfer(address from, address to, uint256 amount) private {
420         require(from != address(0), "ERC20: transfer from the zero address");
421         require(to != address(0), "ERC20: transfer to the zero address");
422         require(amount > 0, "Transfer amount must be greater than zero");
423 
424         if(from != owner() && to != owner()) {
425             
426             require(!_bots[from] && !_bots[to]);
427 
428             if(to != uniswapV2Pair && !_isExcludedFromMaxWallet[to]) {
429                 require(balanceOf(address(to)) + amount <= _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
430             }
431             
432             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
433                 require(tradingOpen, "Trading not yet enabled.");
434                 _teamFee = _buyFee;
435             }
436             uint256 contractTokenBalance = balanceOf(address(this));
437 
438             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
439                 _teamFee = _sellFee;
440 
441                 if (automatedMarketMakerPairs[to]) {
442                     if(contractTokenBalance > minContractTokensToSwap) {
443                         if(!_swapAll) {
444                             contractTokenBalance = minContractTokensToSwap;
445                         }
446                         swapAndSend(contractTokenBalance);
447                     }
448                 }
449 
450             }
451         }
452         bool takeFee = true;
453 
454         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
455             takeFee = false;
456         }
457 
458         if(!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) {
459             takeFee = false;
460         }
461         
462         _tokenTransfer(from,to,amount,takeFee);
463     }
464 
465     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
466         // approve token transfer to cover all possible scenarios
467         _approve(address(this), address(uniswapV2Router), tokenAmount);
468 
469         // add the liquidity
470         uniswapV2Router.addLiquidityETH{value: ethAmount}(
471             address(this),
472             tokenAmount,
473             0, // slippage is unavoidable
474             0, // slippage is unavoidable
475             owner(),
476             block.timestamp
477         );
478     }
479 
480     function swapAndSend(uint256 contractTokenBalance) private {
481         
482         swapTokensForEth(contractTokenBalance);
483 
484         uint256 contractETHBalance = address(this).balance;
485         if(contractETHBalance > 0) {
486             sendETHToFee(address(this).balance);
487         }
488     }
489 
490     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
491         address[] memory path = new address[](2);
492         path[0] = address(this);
493         path[1] = uniswapV2Router.WETH();
494         _approve(address(this), address(uniswapV2Router), tokenAmount);
495         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
496             tokenAmount,
497             0,
498             path,
499             address(this),
500             block.timestamp
501         );
502     }
503         
504     function sendETHToFee(uint256 amount) private {
505         (bool treasury, ) = _treasury.call{value: amount.div(2)}("");
506         (bool marketing, ) = _marketingWallet.call{value: amount.div(2)}("");
507 
508         emit Response(treasury, marketing);
509     }
510     
511     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
512         if(!takeFee)
513             removeAllFee();
514         _transferStandard(sender, recipient, amount);
515         if(!takeFee)
516             restoreAllFee();
517     }
518 
519     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
520         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
521         _rOwned[sender] = _rOwned[sender].sub(rAmount);
522         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
523 
524         _takeTeam(tTeam);
525         _reflectFee(rFee, tFee);
526         emit Transfer(sender, recipient, tTransferAmount);
527     }
528 
529     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
530         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
531         uint256 currentRate =  _getRate();
532         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
533         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
534     }
535 
536     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
537         uint256 tFee = tAmount.mul(taxFee).div(100);
538         uint256 tTeam = tAmount.mul(TeamFee).div(100);
539         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
540         return (tTransferAmount, tFee, tTeam);
541     }
542 
543     function _getRate() private view returns(uint256) {
544         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
545         return rSupply.div(tSupply);
546     }
547 
548     function _getCurrentSupply() private view returns(uint256, uint256) {
549         uint256 rSupply = _rTotal;
550         uint256 tSupply = _tTotal;
551         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
552         return (rSupply, tSupply);
553     }
554 
555     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
556         uint256 rAmount = tAmount.mul(currentRate);
557         uint256 rFee = tFee.mul(currentRate);
558         uint256 rTeam = tTeam.mul(currentRate);
559         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
560         return (rAmount, rTransferAmount, rFee);
561     }
562 
563     function _takeTeam(uint256 tTeam) private {
564         uint256 currentRate =  _getRate();
565         uint256 rTeam = tTeam.mul(currentRate);
566 
567         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
568     }
569 
570     function _reflectFee(uint256 rFee, uint256 tFee) private {
571         _rTotal = _rTotal.sub(rFee);
572         _tFeeTotal = _tFeeTotal.add(tFee);
573     }
574 
575     receive() external payable {}
576     
577     function launch() external onlyOwner() {
578         require(!tradingOpen,"trading is already open");
579         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
580         uniswapV2Router = _uniswapV2Router;
581         _approve(address(this), address(uniswapV2Router), _tTotal);
582         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
583         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
584         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
585         tradingOpen = true;
586         automatedMarketMakerPairs[uniswapV2Pair] = true;
587     }
588     
589     function setMarketingWallet (address payable marketing) external onlyOwner {
590         _isExcludedFromFee[_marketingWallet] = false;
591         _marketingWallet = marketing;
592         _isExcludedFromFee[marketing] = true;
593     }
594 
595     function setTreasury (address payable treasury) external onlyOwner() {
596         _isExcludedFromFee[_treasury] = false;
597         _treasury = treasury;
598         _isExcludedFromFee[treasury] = true;
599     }
600 
601     function excludeFromFee(address[] calldata ads, bool onoff) public onlyOwner {
602         for (uint i = 0; i < ads.length; i++) {
603             _isExcludedFromFee[ads[i]] = onoff;
604         }
605     }
606 
607     function isExcludedFromFee(address ad) public view returns (bool) {
608         return _isExcludedFromFee[ad];
609     }
610 
611     function excludeFromMaxWallet(address[] calldata ads, bool onoff) public onlyOwner {
612         for (uint i = 0; i < ads.length; i++) {
613             _isExcludedFromMaxWallet[ads[i]] = onoff;
614         }
615     }
616     
617     function isExcludedMaxWallet(address ad) public view returns (bool) {
618         return _isExcludedFromMaxWallet[ad];
619     }
620 
621     function setBuyFee(uint256 buy) external onlyOwner {
622         require(buy <= 25);
623         _buyFee = buy;
624     }
625 
626     function setSellFee(uint256 sell) external onlyOwner {
627         require(sell <= 25);
628         _sellFee = sell;
629     }
630 
631     function setTaxFee(uint256 tax) external onlyOwner {
632         require(tax <= 25);
633         _taxFee = tax;
634     }
635     
636     function setMinContractTokensToSwap(uint256 numToken) external onlyOwner {
637         minContractTokensToSwap = numToken * 10**9;
638     }
639 
640     function setMaxWallet(uint256 amt) external onlyOwner {
641         _maxWalletSize = amt * 10**9;
642     }
643 
644     function setSwapAll(bool onoff) external onlyOwner {
645         _swapAll = onoff;
646     }
647 
648     function setBots(address[] calldata bots_) public onlyOwner {
649         for (uint i = 0; i < bots_.length; i++) {
650             if (bots_[i] != uniswapV2Pair && bots_[i] != address(uniswapV2Router)) {
651                 _bots[bots_[i]] = true;
652             }
653         }
654     }
655     
656     function delBot(address notbot) public onlyOwner {
657         _bots[notbot] = false;
658     }
659     
660     function isBot(address ad) public view returns (bool) {
661         return _bots[ad];
662     }
663     
664     function manualswap() external onlyOwner {
665         uint256 contractBalance = balanceOf(address(this));
666         swapTokensForEth(contractBalance);
667     }
668     
669     function manualsend() external onlyOwner {
670         uint256 contractETHBalance = address(this).balance;
671         sendETHToFee(contractETHBalance);
672     }
673 
674     function thisBalance() public view returns (uint) {
675         return balanceOf(address(this));
676     }
677 
678     function amountInPool() public view returns (uint) {
679         return balanceOf(uniswapV2Pair);
680     }
681 
682     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
683         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
684         _setAutomatedMarketMakerPair(pair, value);
685     }
686 
687     function _setAutomatedMarketMakerPair(address pair, bool value) private {
688         automatedMarketMakerPairs[pair] = value;
689     }
690 
691     function balanceOf(address account) public view override returns (uint256) {
692         return tokenFromReflection(_rOwned[account]);
693     }
694 
695     function allowance(address owner, address spender) public view override returns (uint256) {
696         return _allowances[owner][spender];
697     }
698 
699     function approve(address spender, uint256 amount) public override returns (bool) {
700         _approve(_msgSender(), spender, amount);
701         return true;
702     }
703 
704     function removeAllFee() private {
705         if(_taxFee == 0 && _teamFee == 0) return;
706         _previousTaxFee = _taxFee;
707         _previousteamFee = _teamFee;
708         _taxFee = 0;
709         _teamFee = 0;
710     }
711     
712     function restoreAllFee() private {
713         _taxFee = _previousTaxFee;
714         _teamFee = _previousteamFee;
715     }
716 
717     function transfer(address recipient, uint256 amount) public override returns (bool) {
718         _transfer(_msgSender(), recipient, amount);
719         return true;
720     }
721 
722     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
723         _transfer(sender, recipient, amount);
724         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
725         return true;
726     }
727 
728     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
729         require(rAmount <= _rTotal, "Amount must be less than total reflections");
730         uint256 currentRate =  _getRate();
731         return rAmount.div(currentRate);
732     }
733 
734     function symbol() public pure returns (string memory) {
735         return _symbol;
736     }
737 
738     function decimals() public pure returns (uint8) {
739         return _decimals;
740     }
741 
742     function totalSupply() public pure override returns (uint256) {
743         return _tTotal;
744     }
745 
746     function _approve(address owner, address spender, uint256 amount) private {
747         require(owner != address(0), "ERC20: approve from the zero address");
748         require(spender != address(0), "ERC20: approve to the zero address");
749         _allowances[owner][spender] = amount;
750         emit Approval(owner, spender, amount);
751     }
752 }