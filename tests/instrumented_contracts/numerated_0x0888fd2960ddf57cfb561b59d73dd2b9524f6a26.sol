1 pragma solidity 0.8.10;
2 pragma experimental ABIEncoderV2;
3 
4 // SPDX-License-Identifier: MIT
5 // Mikawa original code
6 
7 interface ERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address _account) external view returns (uint256);
11 
12     function transfer(address recipient, uint256 amount)
13         external
14         returns (bool);
15 
16     function allowance(address owner, address spender)
17         external
18         view
19         returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     /**
30      * @dev Emitted when `value` tokens are moved from one _account (`from`) to
31      * another (`to`).
32      *
33      * Note that `value` may be zero.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /**
38      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
39      * a call to {approve}. `value` is the new allowance.
40      */
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 // Dex Factory contract interface
49 interface IDexFactory {
50     function createPair(address tokenA, address tokenB)
51         external
52         returns (address pair);
53 }
54 
55 // Dex Router02 contract interface
56 interface IDexRouter {
57     function factory() external pure returns (address);
58 
59     function WETH() external pure returns (address);
60 
61     function addLiquidityETH(
62         address token,
63         uint256 amountTokenDesired,
64         uint256 amountTokenMin,
65         uint256 amountETHMin,
66         address to,
67         uint256 deadline
68     )
69         external
70         payable
71         returns (
72             uint256 amountToken,
73             uint256 amountETH,
74             uint256 liquidity
75         );
76 
77     function swapExactTokensForETHSupportingFeeOnTransferTokens(
78         uint256 amountIn,
79         uint256 amountOutMin,
80         address[] calldata path,
81         address to,
82         uint256 deadline
83     ) external;
84 }
85 
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 abstract contract Ownable is Context {
97     address private _owner;
98 
99     event OwnershipTransferred(
100         address indexed previousOwner,
101         address indexed newOwner
102     );
103 
104     /**
105      * @dev Initializes the contract setting the deployer as the initial owner.
106      */
107     constructor() {
108         _setOwner(_msgSender());
109     }
110 
111     /**
112      * @dev Returns the address of the current owner.
113      */
114     function owner() public view virtual returns (address) {
115         return _owner;
116     }
117 
118     /**
119      * @dev Throws if called by any _account other than the owner.
120      */
121     modifier onlyOwner() {
122         require(owner() == _msgSender(), "Ownable: caller is not the owner");
123         _;
124     }
125 
126     function renounceOwnership() public virtual onlyOwner {
127         _setOwner(address(0));
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new _account (`newOwner`).
132      * Can only be called by the current owner.
133      */
134     function transferOwnership(address newOwner) public virtual onlyOwner {
135         require(
136             newOwner != address(0),
137             "Ownable: new owner is the zero address"
138         );
139         _setOwner(newOwner);
140     }
141 
142     /**
143      * @dev set the owner for the first time.
144      * Can only be called by the contract or deployer.
145      */
146     function _setOwner(address newOwner) private {
147         address oldOwner = _owner;
148         _owner = newOwner;
149         emit OwnershipTransferred(oldOwner, newOwner);
150     }
151 }
152 
153 
154 library SafeMath {
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;
157         require(c >= a, "SafeMath: addition overflow");
158 
159         return c;
160     }
161 
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return sub(a, b, "SafeMath: subtraction overflow");
164     }
165 
166     function sub(
167         uint256 a,
168         uint256 b,
169         string memory errorMessage
170     ) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     function mod(
212         uint256 a,
213         uint256 b,
214         string memory errorMessage
215     ) internal pure returns (uint256) {
216         require(b != 0, errorMessage);
217         return a % b;
218     }
219 }
220 
221 contract Mikawa is ERC20, Ownable {
222     using SafeMath for uint256;
223 
224     // all private variables and functions are only for contract use
225     mapping(address => uint256) private _rOwned;
226     mapping(address => uint256) private _tOwned;
227     mapping(address => mapping(address => uint256)) private _allowances;
228     mapping(address => bool) private _isExcludedFromFee;
229     mapping(address => bool) private _isExcludedFromReward;
230     mapping(address => bool) private _isExcludedFromMaxHoldLimit;
231     mapping(address => bool) private _isExcludedFromMinBuyLimit;
232     mapping(address => bool) public isSniper;
233 
234     uint256 private constant MAX = ~uint256(0);
235     uint256 private _tTotal = 1000000000000 * 1e9;
236     uint256 private _rTotal = (MAX - (MAX % _tTotal));
237     uint256 private _tFeeTotal;
238 
239     string private _name = "Mikawa Inu"; // token name
240     string private _symbol = "MIKAWA"; // token ticker
241     uint8 private _decimals = 9; // token decimals
242 
243     IDexRouter public dexRouter; // Dex router address
244     address public dexPair; // LP token address
245     address payable public marketWallet; // market wallet address
246     address public burnAddress = (0x000000000000000000000000000000000000dEaD);
247 
248     uint256 public minTokenToSwap = 1000000000 * 1e9; // 100k amount will trigger the swap and add liquidity
249     uint256 public maxHoldingAmount = 20000000000 * 1e9;
250     uint256 public minBuyLimit = 20000000000 * 1e9;
251 
252     uint256 private excludedTSupply; // for contract use
253     uint256 private excludedRSupply; // for contract use
254 
255     bool public swapAndLiquifyEnabled = true; // should be true to turn on to liquidate the pool
256     bool public Fees = true;
257     bool public antiBotStopEnabled = false;
258     bool public isMaxHoldLimitValid = true; // max Holding Limit is valid if it's true
259 
260     // buy tax fee
261     uint256 public reflectionFeeOnBuying = 0;
262     uint256 public liquidityFeeOnBuying = 30;
263     uint256 public marketWalletFeeOnBuying = 100;
264     uint256 public burnFeeOnBuying = 20;
265 
266     // sell tax fee
267     uint256 public reflectionFeeOnSelling = 0;
268     uint256 public liquidityFeeOnSelling = 30;
269     uint256 public marketWalletFeeOnSelling = 100;
270     uint256 public burnFeeOnSelling = 20;
271 
272     // for smart contract use
273     uint256 private _currentReflectionFee;
274     uint256 private _currentLiquidityFee;
275     uint256 private _currentmarketWalletFee;
276     uint256 private _currentBurnFee;
277 
278     uint256 private _accumulatedLiquidity;
279     uint256 private _accumulatedMarketWallet;
280 
281     //Events for blockchain
282     event SwapAndLiquifyEnabledUpdated(bool enabled);
283     event AntiBotStopEnableUpdated(bool enabled);
284 
285     event SwapAndLiquify(
286         uint256 tokensSwapped,
287         uint256 ethReceived,
288         uint256 tokensIntoLiqudity
289     );
290 
291     // constructor for initializing the contract
292     constructor(address payable _marketWallet) {
293         _rOwned[owner()] = _rTotal;
294         marketWallet = _marketWallet;
295 
296         IDexRouter _dexRouter = IDexRouter(
297             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
298             // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //testnet
299         );
300         // Create a Dex pair for this new token
301         dexPair = IDexFactory(_dexRouter.factory()).createPair(
302             address(this),
303             _dexRouter.WETH()
304         );
305 
306         // set the rest of the contract variables
307         dexRouter = _dexRouter;
308 
309         //exclude owner and this contract from fee
310         _isExcludedFromFee[owner()] = true;
311         _isExcludedFromFee[address(this)] = true;
312 
313        // exclude addresses from max holding limit
314         _isExcludedFromMaxHoldLimit[owner()] = true;
315         _isExcludedFromMaxHoldLimit[address(this)] = true;
316         _isExcludedFromMaxHoldLimit[dexPair] = true;
317         _isExcludedFromMaxHoldLimit[burnAddress] = true;
318 
319         _isExcludedFromMinBuyLimit[owner()] = true;
320         _isExcludedFromMinBuyLimit[dexPair] = true;
321 
322         emit Transfer(address(0), owner(), _tTotal);
323     }
324 
325     // token standards by Blockchain
326 
327     function name() public view returns (string memory) {
328         return _name;
329     }
330 
331     function symbol() public view returns (string memory) {
332         return _symbol;
333     }
334 
335     function decimals() public view returns (uint8) {
336         return _decimals;
337     }
338 
339     function totalSupply() public view override returns (uint256) {
340         return _tTotal;
341     }
342 
343     function balanceOf(address _account)
344         public
345         view
346         override
347         returns (uint256)
348     {
349         if (_isExcludedFromReward[_account]) return _tOwned[_account];
350         return tokenFromReflection(_rOwned[_account]);
351     }
352 
353     function allowance(address owner, address spender)
354         public
355         view
356         override
357         returns (uint256)
358     {
359         return _allowances[owner][spender];
360     }
361 
362     function transfer(address recipient, uint256 amount)
363         public
364         override
365         returns (bool)
366     {
367         _transfer(_msgSender(), recipient, amount);
368         return true;
369     }
370 
371 
372     function approve(address spender, uint256 amount)
373         public
374         override
375         returns (bool)
376     {
377         _approve(_msgSender(), spender, amount);
378         return true;
379     }
380 
381     function transferFrom(
382         address sender,
383         address recipient,
384         uint256 amount
385     ) public override returns (bool) {
386         require(!isSniper[sender], "Sniper detected");
387         require(!isSniper[recipient], "Sniper detected");
388         require(!antiBotStopEnabled, "Trading shifted for bot deletion.");
389 
390         _transfer(sender, recipient, amount);
391         _approve(
392             sender,
393             _msgSender(),
394             _allowances[sender][_msgSender()].sub(
395                 amount,
396                 "Token: transfer amount exceeds allowance"
397             )
398         );
399         return true;
400     }
401 
402     function increaseAllowance(address spender, uint256 addedValue)
403         public
404         virtual
405         returns (bool)
406     {
407         _approve(
408             _msgSender(),
409             spender,
410             _allowances[_msgSender()][spender].add(addedValue)
411         );
412         return true;
413     }
414 
415     function decreaseAllowance(address spender, uint256 subtractedValue)
416         public
417         virtual
418         returns (bool)
419     {
420         _approve(
421             _msgSender(),
422             spender,
423             _allowances[_msgSender()][spender].sub(
424                 subtractedValue,
425                 "Token: decreased allowance below zero"
426             )
427         );
428         return true;
429     }
430 
431     // public view able functions
432 
433     // to check wether the address is excluded from reward or not
434     function isExcludedFromReward(address _account) public view returns (bool) {
435         return _isExcludedFromReward[_account];
436     }
437 
438     // to check how much tokens get redistributed among holders till now
439     function totalHolderDistribution() public view returns (uint256) {
440         return _tFeeTotal;
441     }
442 
443     // to check wether the address is excluded from fee or not
444     function isExcludedFromFee(address _account) public view returns (bool) {
445         return _isExcludedFromFee[_account];
446     }
447     // to check wether the address is excluded from max Holding or not
448     function isExcludedFromMaxHoldLimit(address _account)
449         public
450         view
451         returns (bool)
452     {
453         return _isExcludedFromMaxHoldLimit[_account];
454     }
455 
456     // to check wether the address is excluded from max txn or not
457     function isExcludedFromMaxTxnLimit(address _account)
458         public
459         view
460         returns (bool)
461     {
462         return _isExcludedFromMinBuyLimit[_account];
463     }
464 
465     // For manual distribution to the holders
466     function deliver(uint256 tAmount) public {
467         address sender = _msgSender();
468         require(
469             !_isExcludedFromReward[sender],
470             "Token: Excluded addresses cannot call this function"
471         );
472         uint256 rAmount = tAmount.mul(_getRate());
473         _rOwned[sender] = _rOwned[sender].sub(rAmount);
474         _rTotal = _rTotal.sub(rAmount);
475         _tFeeTotal = _tFeeTotal.add(tAmount);
476     }
477 
478     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
479         public
480         view
481         returns (uint256)
482     {
483         require(tAmount <= _tTotal, "BEP20: Amount must be less than supply");
484         if (!deductTransferFee) {
485             uint256 rAmount = tAmount.mul(_getRate());
486             return rAmount;
487         } else {
488             uint256 rAmount = tAmount.mul(_getRate());
489             uint256 rTransferAmount = rAmount.sub(
490                 totalFeePerTx(tAmount).mul(_getRate())
491             );
492             return rTransferAmount;
493         }
494     }
495 
496     function tokenFromReflection(uint256 rAmount)
497         public
498         view
499         returns (uint256)
500     {
501         require(
502             rAmount <= _rTotal,
503             "Token: Amount must be less than total reflections"
504         );
505         uint256 currentRate = _getRate();
506         return rAmount.div(currentRate);
507     }
508 
509     //to include or exludde  any address from max hold limit
510     function includeOrExcludeFromMaxHoldLimit(address _address, bool value)
511         public
512         onlyOwner
513     {
514         _isExcludedFromMaxHoldLimit[_address] = value;
515     }
516 
517     //to include or exludde  any address from max hold limit
518     function includeOrExcludeFromMaxTxnLimit(address _address, bool value)
519         public
520         onlyOwner
521     {
522         _isExcludedFromMinBuyLimit[_address] = value;
523     }
524 
525     //only owner can change MaxHoldingAmount
526     function setMaxHoldingAmount(uint256 _amount) public onlyOwner {
527         maxHoldingAmount = _amount;
528     }
529 
530     //only owner can change MaxHoldingAmount
531     function setMinBuyLimit(uint256 _amount) public onlyOwner {
532         minBuyLimit = _amount;
533     }
534 
535     // owner can remove stuck tokens in case of any issue
536     function removeStuckToken(address _token, uint256 _amount)
537         external
538         onlyOwner
539     {
540         ERC20(_token).transfer(owner(), _amount);
541     }
542     
543     //only owner can change SellFeePercentages any time after deployment
544     function setSellFeePercent(
545         uint256 _redistributionFee,
546         uint256 _liquidityFee,
547         uint256 _marketWalletFee,
548         uint256 _burnFee
549     ) external onlyOwner {
550         reflectionFeeOnSelling = _redistributionFee;
551         liquidityFeeOnSelling = _liquidityFee;
552         marketWalletFeeOnSelling = _marketWalletFee;
553         burnFeeOnSelling = _burnFee;
554     }
555 
556     //to include or exludde  any address from fee
557     function includeOrExcludeFromFee(address _account, bool _value)
558         public
559         onlyOwner
560     {
561         _isExcludedFromFee[_account] = _value;
562     }
563 
564     //only owner can change MinTokenToSwap
565     function setMinTokenToSwap(uint256 _amount) public onlyOwner {
566         minTokenToSwap = _amount;
567     }
568 
569     //only owner can change BuyFeePercentages any time after deployment
570     function setBuyFeePercent(
571         uint256 _redistributionFee,
572         uint256 _liquidityFee,
573         uint256 _marketWalletFee,
574         uint256 _burnFee
575     ) external onlyOwner {
576         reflectionFeeOnBuying = _redistributionFee;
577         liquidityFeeOnBuying = _liquidityFee;
578         marketWalletFeeOnBuying = _marketWalletFee;
579         burnFeeOnBuying = _burnFee;
580     }
581 
582     
583     //only owner can change state of swapping, he can turn it in to true or false any time after deployment
584     function enableOrDisableSwapAndLiquify(bool _state) public onlyOwner {
585         swapAndLiquifyEnabled = _state;
586         emit SwapAndLiquifyEnabledUpdated(_state);
587     }
588 
589     // owner can change market address
590     function setmarketWalletAddress(address payable _newAddress)
591         external
592         onlyOwner
593     {
594         marketWallet = _newAddress;
595     }
596 
597     //to receive eth from dexRouter when swapping
598     receive() external payable {}
599 
600     // internal functions for contract use
601 
602     function totalFeePerTx(uint256 tAmount) internal view returns (uint256) {
603         uint256 percentage = tAmount
604             .mul(
605                 _currentReflectionFee.add(_currentLiquidityFee).add(
606                     _currentmarketWalletFee.add(_currentBurnFee)
607                 )
608             )
609             .div(1e3);
610         return percentage;
611     }
612 
613     function _checkMaxWalletAmount(address to, uint256 amount) private view{
614         if (
615             !_isExcludedFromMaxHoldLimit[to] // by default false
616         ) {
617             if (isMaxHoldLimitValid) {
618                 require(
619                     balanceOf(to).add(amount) <= maxHoldingAmount,
620                     "BEP20: amount exceed max holding limit"
621                 );
622             }
623         }
624     }
625 
626 
627     function _getRate() private view returns (uint256) {
628         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
629         return rSupply.div(tSupply);
630     }
631 
632     function setBuyFee() private {
633         _currentReflectionFee = reflectionFeeOnBuying;
634         _currentLiquidityFee = liquidityFeeOnBuying;
635         _currentmarketWalletFee = marketWalletFeeOnBuying;
636         _currentBurnFee = burnFeeOnBuying; 
637     }
638 
639     function _getCurrentSupply() private view returns (uint256, uint256) {
640         uint256 rSupply = _rTotal;
641         uint256 tSupply = _tTotal;
642         rSupply = rSupply.sub(excludedRSupply);
643         tSupply = tSupply.sub(excludedTSupply);
644         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
645         return (rSupply, tSupply);
646     }
647 
648     function removeAllFee() private {
649         _currentReflectionFee = 0;
650         _currentLiquidityFee = 0;
651         _currentmarketWalletFee = 0;
652         _currentBurnFee = 0;
653     }
654 
655     function setSellFee() private {
656         _currentReflectionFee = reflectionFeeOnSelling;
657         _currentLiquidityFee = liquidityFeeOnSelling;
658         _currentmarketWalletFee = marketWalletFeeOnSelling;
659         _currentBurnFee = burnFeeOnSelling;
660     }
661 
662     function _approve(
663         address owner,
664         address spender,
665         uint256 amount
666     ) private {
667         require(owner != address(0), "Token: approve from the zero address");
668         require(spender != address(0), "Token: approve to the zero address");
669 
670         _allowances[owner][spender] = amount;
671         emit Approval(owner, spender, amount);
672     }
673 
674     // base function to transfer tokens
675     function _transfer(
676         address from,
677         address to,
678         uint256 amount
679     ) private {
680         require(from != address(0), "Token: transfer from the zero address");
681         require(to != address(0), "Token: transfer to the zero address");
682         require(amount > 0, "Token: transfer amount must be greater than zero");
683         
684         // swap and liquify
685         swapAndLiquify(from, to);
686 
687         //indicates if fee should be deducted from transfer
688         bool takeFee = true;
689 
690         //if any _account belongs to _isExcludedFromFee _account then remove the fee
691         if (_isExcludedFromFee[from] || _isExcludedFromFee[to] || !Fees) {
692             takeFee = false;
693         }
694 
695         //transfer amount, it will take tax, burn, liquidity fee
696         _tokenTransfer(from, to, amount, takeFee);
697     }
698 
699     //this method is responsible for taking all fee, if takeFee is true
700     function _tokenTransfer(
701         address sender,
702         address recipient,
703         uint256 amount,
704         bool takeFee
705     ) private {
706         // buying handler
707         require(!isSniper[sender], "Sniper detected");
708         require(!isSniper[recipient], "Sniper detected");
709         require(!antiBotStopEnabled, "Trading shifted for bot deletion.");
710 
711         if(!_isExcludedFromMinBuyLimit[recipient]){
712             require(amount <= minBuyLimit,"Amount must be greater than minimum buy Limit" );
713         }
714         if (sender == dexPair && takeFee) {
715             setBuyFee();
716         }
717         // selling handler
718         else if (recipient == dexPair && takeFee) {
719             setSellFee();
720         }
721         // normal transaction handler
722         else {
723             removeAllFee();
724         }
725 
726         // check if sender or reciver excluded from reward then do transfer accordingly
727         if (
728             _isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]
729         ) {
730             _transferFromExcluded(sender, recipient, amount);
731         } else if (
732             !_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]
733         ) {
734             _transferToExcluded(sender, recipient, amount);
735         } else if (
736             _isExcludedFromReward[sender] && _isExcludedFromReward[recipient]
737         ) {
738             _transferBothExcluded(sender, recipient, amount);
739         } else {
740             _transferStandard(sender, recipient, amount);
741         }
742     }
743 
744     // if both sender and receiver are not excluded from reward
745     function _transferStandard(
746         address sender,
747         address recipient,
748         uint256 tAmount
749     ) private {
750         uint256 currentRate = _getRate();
751         uint256 tTransferAmount = tAmount.sub(totalFeePerTx(tAmount));
752         uint256 rAmount = tAmount.mul(currentRate);
753         uint256 rTransferAmount = rAmount.sub(
754             totalFeePerTx(tAmount).mul(currentRate)
755         );
756         _checkMaxWalletAmount(recipient, tTransferAmount);
757         _rOwned[sender] = _rOwned[sender].sub(rAmount);
758         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
759         _takeAllFee(sender,tAmount, currentRate);
760         _takeBurnFee(sender,tAmount, currentRate);
761         _reflectFee(tAmount);
762         emit Transfer(sender, recipient, tTransferAmount);
763     }
764 
765     // if sender is excluded from reward
766     function _transferFromExcluded(
767         address sender,
768         address recipient,
769         uint256 tAmount
770     ) private {
771         uint256 currentRate = _getRate();
772         uint256 tTransferAmount = tAmount.sub(totalFeePerTx(tAmount));
773         uint256 rAmount = tAmount.mul(currentRate);
774         uint256 rTransferAmount = rAmount.sub(
775             totalFeePerTx(tAmount).mul(currentRate)
776         );
777         _checkMaxWalletAmount(recipient, tTransferAmount);
778         _tOwned[sender] = _tOwned[sender].sub(tAmount);
779         excludedTSupply = excludedTSupply.sub(tAmount);
780         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
781         _takeAllFee(sender,tAmount, currentRate);
782         _takeBurnFee(sender,tAmount, currentRate);
783         _reflectFee(tAmount);
784 
785         emit Transfer(sender, recipient, tTransferAmount);
786     }
787 
788     // if both sender and receiver are excluded from reward
789     function _transferBothExcluded(
790         address sender,
791         address recipient,
792         uint256 tAmount
793     ) private {
794         uint256 currentRate = _getRate();
795         uint256 tTransferAmount = tAmount.sub(totalFeePerTx(tAmount));
796         _checkMaxWalletAmount(recipient, tTransferAmount);
797         _tOwned[sender] = _tOwned[sender].sub(tAmount);
798         excludedTSupply = excludedTSupply.sub(tAmount);
799         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
800         excludedTSupply = excludedTSupply.add(tAmount);
801         _takeAllFee(sender,tAmount, currentRate);
802         _takeBurnFee(sender,tAmount, currentRate);
803         _reflectFee(tAmount);
804 
805         emit Transfer(sender, recipient, tTransferAmount);
806     }
807 
808     // if receiver is excluded from reward
809     function _transferToExcluded(
810         address sender,
811         address recipient,
812         uint256 tAmount
813     ) private {
814         uint256 currentRate = _getRate();
815         uint256 tTransferAmount = tAmount.sub(totalFeePerTx(tAmount));
816         uint256 rAmount = tAmount.mul(currentRate);
817         _checkMaxWalletAmount(recipient, tTransferAmount);
818         _rOwned[sender] = _rOwned[sender].sub(rAmount);
819         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
820         excludedTSupply = excludedTSupply.add(tAmount);
821         _takeAllFee(sender,tAmount, currentRate);
822         _takeBurnFee(sender,tAmount, currentRate);
823         _reflectFee(tAmount);
824 
825         emit Transfer(sender, recipient, tTransferAmount);
826     }
827 
828     // for automatic redistribution among all holders on each tx
829     function _reflectFee(uint256 tAmount) private {
830         uint256 tFee = tAmount.mul(_currentReflectionFee).div(1e3);
831         uint256 rFee = tFee.mul(_getRate());
832         _rTotal = _rTotal.sub(rFee);
833         _tFeeTotal = _tFeeTotal.add(tFee);
834     }
835 
836      // take fees for liquidity, market/dev
837     function _takeAllFee(address sender,uint256 tAmount, uint256 currentRate) internal {
838         uint256 tFee = tAmount
839             .mul(_currentLiquidityFee.add(_currentmarketWalletFee))
840             .div(1e3);
841 
842         if (tFee > 0) {
843             _accumulatedLiquidity = _accumulatedLiquidity.add(
844                 tAmount.mul(_currentLiquidityFee).div(1e3)
845             );
846             _accumulatedMarketWallet = _accumulatedMarketWallet.add(
847                 tAmount.mul(_currentmarketWalletFee).div(1e3)
848             );
849 
850             uint256 rFee = tFee.mul(currentRate);
851             if (_isExcludedFromReward[address(this)])
852                 _tOwned[address(this)] = _tOwned[address(this)].add(tFee);
853             else _rOwned[address(this)] = _rOwned[address(this)].add(rFee);
854 
855             emit Transfer(sender, address(this), tFee);
856         }
857     }
858    function _takeBurnFee(address sender,uint256 tAmount, uint256 currentRate) internal {
859         uint256 burnFee = tAmount.mul(_currentBurnFee).div(1e3);
860         uint256 rBurnFee = burnFee.mul(currentRate);
861         _rOwned[burnAddress] = _rOwned[burnAddress].add(rBurnFee);
862 
863         emit Transfer(sender, burnAddress, burnFee);
864     }
865 
866     
867     function swapAndLiquify(address from, address to) private {
868         // is the token balance of this contract address over the min number of
869         // tokens that we need to initiate a swap + liquidity lock?
870         // also, don't get caught in a circular liquidity event.
871         // also, don't swap & liquify if sender is Dex pair.
872         uint256 contractTokenBalance = balanceOf(address(this));
873 
874         bool shouldSell = contractTokenBalance >= minTokenToSwap;
875 
876         if (
877             shouldSell &&
878             from != dexPair &&
879             swapAndLiquifyEnabled &&
880             !(from == address(this) && to == address(dexPair)) // swap 1 time
881         ) {
882             // approve contract
883             _approve(address(this), address(dexRouter), contractTokenBalance);
884 
885             uint256 halfLiquid = _accumulatedLiquidity.div(2);
886             uint256 otherHalfLiquid = _accumulatedLiquidity.sub(halfLiquid);
887 
888             uint256 tokenAmountToBeSwapped = contractTokenBalance.sub(
889                 otherHalfLiquid
890             );
891 
892             // now is to lock into liquidty pool
893             Utils.swapTokensForEth(address(dexRouter), tokenAmountToBeSwapped);
894 
895             uint256 deltaBalance = address(this).balance;
896             uint256 ethToBeAddedToLiquidity = deltaBalance.mul(halfLiquid).div(tokenAmountToBeSwapped);
897             uint256 ethFormarketWallet = deltaBalance.sub(ethToBeAddedToLiquidity);  
898 
899             // sending eth to award pool wallet
900             if(ethFormarketWallet > 0)
901                 marketWallet.transfer(ethFormarketWallet); 
902 
903             // add liquidity to Dex
904             if(ethToBeAddedToLiquidity > 0){
905                 Utils.addLiquidity(
906                     address(dexRouter),
907                     owner(),
908                     otherHalfLiquid,
909                     ethToBeAddedToLiquidity
910                 );
911 
912                 emit SwapAndLiquify(
913                     halfLiquid,
914                     ethToBeAddedToLiquidity,
915                     otherHalfLiquid
916                 );
917             }
918 
919             // Reset current accumulated amount
920             _accumulatedLiquidity = 0; 
921             _accumulatedMarketWallet = 0;
922         }
923     }
924 }
925 
926 // Library for doing a swap on Dex
927 library Utils {
928     using SafeMath for uint256;
929 
930     function swapTokensForEth(address routerAddress, uint256 tokenAmount)
931         internal
932     {
933         IDexRouter dexRouter = IDexRouter(routerAddress);
934 
935         // generate the Dex pair path of token -> weth
936         address[] memory path = new address[](2);
937         path[0] = address(this);
938         path[1] = dexRouter.WETH();
939 
940         // make the swap
941         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
942             tokenAmount,
943             0, // accept any amount of eth
944             path,
945             address(this),
946             block.timestamp + 300
947         );
948     }
949 
950     function addLiquidity(
951         address routerAddress,
952         address owner,
953         uint256 tokenAmount,
954         uint256 ethAmount
955     ) internal {
956         IDexRouter dexRouter = IDexRouter(routerAddress);
957 
958         // add the liquidity
959         dexRouter.addLiquidityETH{value: ethAmount}(
960             address(this),
961             tokenAmount,
962             0, // slippage is unavoidable
963             0, // slippage is unavoidable
964             owner,
965             block.timestamp + 300
966         );
967     }
968 }