1 pragma solidity 0.8.10;
2 pragma experimental ABIEncoderV2;
3 
4 // SPDX-License-Identifier: MIT
5 // ORIGINAL RISU CODE
6 // VISIT US https://risublockchain.com/
7 // TELEGRAM @Risuchain
8 
9 interface IBEP20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address _account) external view returns (uint256);
13 
14     function transfer(address recipient, uint256 amount)
15         external
16         returns (bool);
17 
18     function allowance(address owner, address spender)
19         external
20         view
21         returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     /**
32      * @dev Emitted when `value` tokens are moved from one _account (`from`) to
33      * another (`to`).
34      *
35      * Note that `value` may be zero.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     /**
40      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
41      * a call to {approve}. `value` is the new allowance.
42      */
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49 
50 // Dex Factory contract interface
51 interface IDexFactory {
52     function createPair(address tokenA, address tokenB)
53         external
54         returns (address pair);
55 }
56 
57 // Dex Router02 contract interface
58 interface IDexRouter {
59     function factory() external pure returns (address);
60 
61     function WETH() external pure returns (address);
62 
63     function addLiquidityETH(
64         address token,
65         uint256 amountTokenDesired,
66         uint256 amountTokenMin,
67         uint256 amountETHMin,
68         address to,
69         uint256 deadline
70     )
71         external
72         payable
73         returns (
74             uint256 amountToken,
75             uint256 amountETH,
76             uint256 liquidity
77         );
78 
79     function swapExactTokensForETHSupportingFeeOnTransferTokens(
80         uint256 amountIn,
81         uint256 amountOutMin,
82         address[] calldata path,
83         address to,
84         uint256 deadline
85     ) external;
86 }
87 
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 abstract contract Ownable is Context {
99     address private _owner;
100 
101     event OwnershipTransferred(
102         address indexed previousOwner,
103         address indexed newOwner
104     );
105 
106     /**
107      * @dev Initializes the contract setting the deployer as the initial owner.
108      */
109     constructor() {
110         _setOwner(_msgSender());
111     }
112 
113     /**
114      * @dev Returns the address of the current owner.
115      */
116     function owner() public view virtual returns (address) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any _account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     function renounceOwnership() public virtual onlyOwner {
129         _setOwner(address(0));
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new _account (`newOwner`).
134      * Can only be called by the current owner.
135      */
136     function transferOwnership(address newOwner) public virtual onlyOwner {
137         require(
138             newOwner != address(0),
139             "Ownable: new owner is the zero address"
140         );
141         _setOwner(newOwner);
142     }
143 
144     /**
145      * @dev set the owner for the first time.
146      * Can only be called by the contract or deployer.
147      */
148     function _setOwner(address newOwner) private {
149         address oldOwner = _owner;
150         _owner = newOwner;
151         emit OwnershipTransferred(oldOwner, newOwner);
152     }
153 }
154 
155 
156 library SafeMath {
157     function add(uint256 a, uint256 b) internal pure returns (uint256) {
158         uint256 c = a + b;
159         require(c >= a, "SafeMath: addition overflow");
160 
161         return c;
162     }
163 
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         return div(a, b, "SafeMath: division by zero");
195     }
196 
197     function div(
198         uint256 a,
199         uint256 b,
200         string memory errorMessage
201     ) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     function mod(
214         uint256 a,
215         uint256 b,
216         string memory errorMessage
217     ) internal pure returns (uint256) {
218         require(b != 0, errorMessage);
219         return a % b;
220     }
221 }
222 
223 contract RISU is Context, IBEP20, Ownable {
224     using SafeMath for uint256;
225 
226     // all private variables and functions are only for contract use
227     mapping(address => uint256) private _rOwned;
228     mapping(address => uint256) private _tOwned;
229     mapping(address => mapping(address => uint256)) private _allowances;
230     mapping(address => bool) private _isExcludedFromFee;
231     mapping(address => bool) private _isExcludedFromReward;
232     mapping(address => bool) private _isExcludedFromMaxHoldLimit;
233     mapping(address => bool) private _isExcludedFromMinBuyLimit;
234     mapping(address => bool) public isSniper;
235 
236     uint256 private constant MAX = ~uint256(0);
237     uint256 private _tTotal = 1000000000 * 1e9;
238     uint256 private _rTotal = (MAX - (MAX % _tTotal));
239     uint256 private _tFeeTotal;
240 
241     string private _name = "Risu"; // token name
242     string private _symbol = "RISU"; // token ticker
243     uint8 private _decimals = 9; // token decimals
244 
245     IDexRouter public dexRouter; // Dex router address
246     address public dexPair; // LP token address
247     address payable public marketWallet; // market wallet address
248     address public burnAddress = (0x000000000000000000000000000000000000dEaD);
249 
250     uint256 public minTokenToSwap = 1000000 * 1e9; // 100k amount will trigger the swap and add liquidity
251     uint256 public maxHoldingAmount = 20000000 * 1e9;
252     uint256 public minBuyLimit = 20000000 * 1e9;
253 
254     uint256 private excludedTSupply; // for contract use
255     uint256 private excludedRSupply; // for contract use
256 
257     bool public swapAndLiquifyEnabled = true; // should be true to turn on to liquidate the pool
258     bool public Fees = true;
259     bool public antiBotStopEnabled = false;
260     bool public isMaxHoldLimitValid = true; // max Holding Limit is valid if it's true
261 
262     // buy tax fee
263     uint256 public reflectionFeeOnBuying = 10;
264     uint256 public liquidityFeeOnBuying = 10;
265     uint256 public marketWalletFeeOnBuying = 50;
266     uint256 public burnFeeOnBuying = 15;
267 
268     // sell tax fee
269     uint256 public reflectionFeeOnSelling = 10;
270     uint256 public liquidityFeeOnSelling = 10;
271     uint256 public marketWalletFeeOnSelling = 50;
272     uint256 public burnFeeOnSelling = 15;
273 
274     // for smart contract use
275     uint256 private _currentReflectionFee;
276     uint256 private _currentLiquidityFee;
277     uint256 private _currentmarketWalletFee;
278     uint256 private _currentBurnFee;
279 
280     uint256 private _accumulatedLiquidity;
281     uint256 private _accumulatedMarketWallet;
282 
283     //Events for blockchain
284     event SwapAndLiquifyEnabledUpdated(bool enabled);
285     event AntiBotStopEnableUpdated(bool enabled);
286 
287     event SwapAndLiquify(
288         uint256 tokensSwapped,
289         uint256 bnbReceived,
290         uint256 tokensIntoLiqudity
291     );
292 
293     // constructor for initializing the contract
294     constructor(address payable _marketWallet) {
295         _rOwned[owner()] = _rTotal;
296         marketWallet = _marketWallet;
297 
298         IDexRouter _dexRouter = IDexRouter(
299             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
300             // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //testnet
301         );
302         // Create a Dex pair for this new token
303         dexPair = IDexFactory(_dexRouter.factory()).createPair(
304             address(this),
305             _dexRouter.WETH()
306         );
307 
308         // set the rest of the contract variables
309         dexRouter = _dexRouter;
310 
311         //exclude owner and this contract from fee
312         _isExcludedFromFee[owner()] = true;
313         _isExcludedFromFee[address(this)] = true;
314 
315        // exclude addresses from max holding limit
316         _isExcludedFromMaxHoldLimit[owner()] = true;
317         _isExcludedFromMaxHoldLimit[address(this)] = true;
318         _isExcludedFromMaxHoldLimit[dexPair] = true;
319         _isExcludedFromMaxHoldLimit[burnAddress] = true;
320 
321         _isExcludedFromMinBuyLimit[owner()] = true;
322         _isExcludedFromMinBuyLimit[dexPair] = true;
323 
324         emit Transfer(address(0), owner(), _tTotal);
325     }
326 
327     // token standards by Blockchain
328 
329     function name() public view returns (string memory) {
330         return _name;
331     }
332 
333     function symbol() public view returns (string memory) {
334         return _symbol;
335     }
336 
337     function decimals() public view returns (uint8) {
338         return _decimals;
339     }
340 
341     function totalSupply() public view override returns (uint256) {
342         return _tTotal;
343     }
344 
345     function balanceOf(address _account)
346         public
347         view
348         override
349         returns (uint256)
350     {
351         if (_isExcludedFromReward[_account]) return _tOwned[_account];
352         return tokenFromReflection(_rOwned[_account]);
353     }
354 
355     function allowance(address owner, address spender)
356         public
357         view
358         override
359         returns (uint256)
360     {
361         return _allowances[owner][spender];
362     }
363 
364     function transfer(address recipient, uint256 amount)
365         public
366         override
367         returns (bool)
368     {
369         _transfer(_msgSender(), recipient, amount);
370         return true;
371     }
372 
373 
374     function approve(address spender, uint256 amount)
375         public
376         override
377         returns (bool)
378     {
379         _approve(_msgSender(), spender, amount);
380         return true;
381     }
382 
383     function transferFrom(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) public override returns (bool) {
388         require(!isSniper[sender], "Sniper detected");
389         require(!isSniper[recipient], "Sniper detected");
390         require(!antiBotStopEnabled, "Trading shifted for bot deletion.");
391 
392         _transfer(sender, recipient, amount);
393         _approve(
394             sender,
395             _msgSender(),
396             _allowances[sender][_msgSender()].sub(
397                 amount,
398                 "Token: transfer amount exceeds allowance"
399             )
400         );
401         return true;
402     }
403 
404     function increaseAllowance(address spender, uint256 addedValue)
405         public
406         virtual
407         returns (bool)
408     {
409         _approve(
410             _msgSender(),
411             spender,
412             _allowances[_msgSender()][spender].add(addedValue)
413         );
414         return true;
415     }
416 
417     function decreaseAllowance(address spender, uint256 subtractedValue)
418         public
419         virtual
420         returns (bool)
421     {
422         _approve(
423             _msgSender(),
424             spender,
425             _allowances[_msgSender()][spender].sub(
426                 subtractedValue,
427                 "Token: decreased allowance below zero"
428             )
429         );
430         return true;
431     }
432 
433     // public view able functions
434 
435     // to check wether the address is excluded from reward or not
436     function isExcludedFromReward(address _account) public view returns (bool) {
437         return _isExcludedFromReward[_account];
438     }
439 
440     // to check how much tokens get redistributed among holders till now
441     function totalHolderDistribution() public view returns (uint256) {
442         return _tFeeTotal;
443     }
444 
445     // to check wether the address is excluded from fee or not
446     function isExcludedFromFee(address _account) public view returns (bool) {
447         return _isExcludedFromFee[_account];
448     }
449     // to check wether the address is excluded from max Holding or not
450     function isExcludedFromMaxHoldLimit(address _account)
451         public
452         view
453         returns (bool)
454     {
455         return _isExcludedFromMaxHoldLimit[_account];
456     }
457 
458     // to check wether the address is excluded from max txn or not
459     function isExcludedFromMaxTxnLimit(address _account)
460         public
461         view
462         returns (bool)
463     {
464         return _isExcludedFromMinBuyLimit[_account];
465     }
466 
467     // For manual distribution to the holders
468     function deliver(uint256 tAmount) public {
469         address sender = _msgSender();
470         require(
471             !_isExcludedFromReward[sender],
472             "Token: Excluded addresses cannot call this function"
473         );
474         uint256 rAmount = tAmount.mul(_getRate());
475         _rOwned[sender] = _rOwned[sender].sub(rAmount);
476         _rTotal = _rTotal.sub(rAmount);
477         _tFeeTotal = _tFeeTotal.add(tAmount);
478     }
479 
480     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
481         public
482         view
483         returns (uint256)
484     {
485         require(tAmount <= _tTotal, "BEP20: Amount must be less than supply");
486         if (!deductTransferFee) {
487             uint256 rAmount = tAmount.mul(_getRate());
488             return rAmount;
489         } else {
490             uint256 rAmount = tAmount.mul(_getRate());
491             uint256 rTransferAmount = rAmount.sub(
492                 totalFeePerTx(tAmount).mul(_getRate())
493             );
494             return rTransferAmount;
495         }
496     }
497 
498     function tokenFromReflection(uint256 rAmount)
499         public
500         view
501         returns (uint256)
502     {
503         require(
504             rAmount <= _rTotal,
505             "Token: Amount must be less than total reflections"
506         );
507         uint256 currentRate = _getRate();
508         return rAmount.div(currentRate);
509     }
510 
511     //to include or exludde  any address from max hold limit
512     function includeOrExcludeFromMaxHoldLimit(address _address, bool value)
513         public
514         onlyOwner
515     {
516         _isExcludedFromMaxHoldLimit[_address] = value;
517     }
518 
519     //to include or exludde  any address from max hold limit
520     function includeOrExcludeFromMaxTxnLimit(address _address, bool value)
521         public
522         onlyOwner
523     {
524         _isExcludedFromMinBuyLimit[_address] = value;
525     }
526 
527     //only owner can change sniper shift
528     function setAntiBotStopEnabled(bool _state) public onlyOwner {
529         antiBotStopEnabled = _state;
530         emit AntiBotStopEnableUpdated(_state);
531     }
532 
533     //only owner can change MaxHoldingAmount
534     function setMaxHoldingAmount(uint256 _amount) public onlyOwner {
535         maxHoldingAmount = _amount;
536     }
537 
538     //only owner can change MaxHoldingAmount
539     function setMinBuyLimit(uint256 _amount) public onlyOwner {
540         minBuyLimit = _amount;
541     }
542 
543     // owner can remove stuck tokens in case of any issue
544     function removeStuckToken(address _token, uint256 _amount)
545         external
546         onlyOwner
547     {
548         IBEP20(_token).transfer(owner(), _amount);
549     }
550     
551     //only owner can change SellFeePercentages any time after deployment
552     function setSellFeePercent(
553         uint256 _redistributionFee,
554         uint256 _liquidityFee,
555         uint256 _marketWalletFee,
556         uint256 _burnFee
557     ) external onlyOwner {
558         reflectionFeeOnSelling = _redistributionFee;
559         liquidityFeeOnSelling = _liquidityFee;
560         marketWalletFeeOnSelling = _marketWalletFee;
561         burnFeeOnSelling = _burnFee;
562     }
563 
564     //to include or exludde  any address from fee
565     function includeOrExcludeFromFee(address _account, bool _value)
566         public
567         onlyOwner
568     {
569         _isExcludedFromFee[_account] = _value;
570     }
571 
572     //only owner can change MinTokenToSwap
573     function setMinTokenToSwap(uint256 _amount) public onlyOwner {
574         minTokenToSwap = _amount;
575     }
576 
577     //only owner can change BuyFeePercentages any time after deployment
578     function setBuyFeePercent(
579         uint256 _redistributionFee,
580         uint256 _liquidityFee,
581         uint256 _marketWalletFee,
582         uint256 _burnFee
583     ) external onlyOwner {
584         reflectionFeeOnBuying = _redistributionFee;
585         liquidityFeeOnBuying = _liquidityFee;
586         marketWalletFeeOnBuying = _marketWalletFee;
587         burnFeeOnBuying = _burnFee;
588     }
589 
590     
591     //only owner can change state of swapping, he can turn it in to true or false any time after deployment
592     function enableOrDisableSwapAndLiquify(bool _state) public onlyOwner {
593         swapAndLiquifyEnabled = _state;
594         emit SwapAndLiquifyEnabledUpdated(_state);
595     }
596 
597     //To enable or disable all fees when set it to true fees will be disabled
598     function enableOrDisableFees(bool _state) external onlyOwner {
599         Fees = _state;
600     }
601 
602     // owner can change market address
603     function setmarketWalletAddress(address payable _newAddress)
604         external
605         onlyOwner
606     {
607         marketWallet = _newAddress;
608     }
609 
610     //to receive BNB from dexRouter when swapping
611     receive() external payable {}
612 
613     // internal functions for contract use
614 
615     function totalFeePerTx(uint256 tAmount) internal view returns (uint256) {
616         uint256 percentage = tAmount
617             .mul(
618                 _currentReflectionFee.add(_currentLiquidityFee).add(
619                     _currentmarketWalletFee.add(_currentBurnFee)
620                 )
621             )
622             .div(1e3);
623         return percentage;
624     }
625 
626     function _checkMaxWalletAmount(address to, uint256 amount) private view{
627         if (
628             !_isExcludedFromMaxHoldLimit[to] // by default false
629         ) {
630             if (isMaxHoldLimitValid) {
631                 require(
632                     balanceOf(to).add(amount) <= maxHoldingAmount,
633                     "BEP20: amount exceed max holding limit"
634                 );
635             }
636         }
637     }
638 
639 
640     function _getRate() private view returns (uint256) {
641         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
642         return rSupply.div(tSupply);
643     }
644 
645     function setBuyFee() private {
646         _currentReflectionFee = reflectionFeeOnBuying;
647         _currentLiquidityFee = liquidityFeeOnBuying;
648         _currentmarketWalletFee = marketWalletFeeOnBuying;
649         _currentBurnFee = burnFeeOnBuying; 
650     }
651 
652     function _getCurrentSupply() private view returns (uint256, uint256) {
653         uint256 rSupply = _rTotal;
654         uint256 tSupply = _tTotal;
655         rSupply = rSupply.sub(excludedRSupply);
656         tSupply = tSupply.sub(excludedTSupply);
657         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
658         return (rSupply, tSupply);
659     }
660 
661     function removeAllFee() private {
662         _currentReflectionFee = 0;
663         _currentLiquidityFee = 0;
664         _currentmarketWalletFee = 0;
665         _currentBurnFee = 0;
666     }
667 
668     function setSellFee() private {
669         _currentReflectionFee = reflectionFeeOnSelling;
670         _currentLiquidityFee = liquidityFeeOnSelling;
671         _currentmarketWalletFee = marketWalletFeeOnSelling;
672         _currentBurnFee = burnFeeOnSelling;
673     }
674 
675      function addSniperInList(address _account) external onlyOwner {
676         require(_account != address(dexRouter), "We can not blacklist router");
677         require(!isSniper[_account], "Sniper already exist");
678         isSniper[_account] = true;
679     }
680 
681     function removeSniperFromList(address _account) external onlyOwner {
682         require(isSniper[_account], "Not a sniper");
683         isSniper[_account] = false;
684     }
685 
686     function _approve(
687         address owner,
688         address spender,
689         uint256 amount
690     ) private {
691         require(owner != address(0), "Token: approve from the zero address");
692         require(spender != address(0), "Token: approve to the zero address");
693 
694         _allowances[owner][spender] = amount;
695         emit Approval(owner, spender, amount);
696     }
697 
698     // base function to transfer tokens
699     function _transfer(
700         address from,
701         address to,
702         uint256 amount
703     ) private {
704         require(from != address(0), "Token: transfer from the zero address");
705         require(to != address(0), "Token: transfer to the zero address");
706         require(amount > 0, "Token: transfer amount must be greater than zero");
707         
708         // swap and liquify
709         swapAndLiquify(from, to);
710 
711         //indicates if fee should be deducted from transfer
712         bool takeFee = true;
713 
714         //if any _account belongs to _isExcludedFromFee _account then remove the fee
715         if (_isExcludedFromFee[from] || _isExcludedFromFee[to] || !Fees) {
716             takeFee = false;
717         }
718 
719         //transfer amount, it will take tax, burn, liquidity fee
720         _tokenTransfer(from, to, amount, takeFee);
721     }
722 
723     //this method is responsible for taking all fee, if takeFee is true
724     function _tokenTransfer(
725         address sender,
726         address recipient,
727         uint256 amount,
728         bool takeFee
729     ) private {
730         // buying handler
731         require(!isSniper[sender], "Sniper detected");
732         require(!isSniper[recipient], "Sniper detected");
733         require(!antiBotStopEnabled, "Trading shifted for bot deletion.");
734 
735         if(!_isExcludedFromMinBuyLimit[recipient]){
736             require(amount <= minBuyLimit,"Amount must be greater than minimum buy Limit" );
737         }
738         if (sender == dexPair && takeFee) {
739             setBuyFee();
740         }
741         // selling handler
742         else if (recipient == dexPair && takeFee) {
743             setSellFee();
744         }
745         // normal transaction handler
746         else {
747             removeAllFee();
748         }
749 
750         // check if sender or reciver excluded from reward then do transfer accordingly
751         if (
752             _isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]
753         ) {
754             _transferFromExcluded(sender, recipient, amount);
755         } else if (
756             !_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]
757         ) {
758             _transferToExcluded(sender, recipient, amount);
759         } else if (
760             _isExcludedFromReward[sender] && _isExcludedFromReward[recipient]
761         ) {
762             _transferBothExcluded(sender, recipient, amount);
763         } else {
764             _transferStandard(sender, recipient, amount);
765         }
766     }
767 
768     // if both sender and receiver are not excluded from reward
769     function _transferStandard(
770         address sender,
771         address recipient,
772         uint256 tAmount
773     ) private {
774         uint256 currentRate = _getRate();
775         uint256 tTransferAmount = tAmount.sub(totalFeePerTx(tAmount));
776         uint256 rAmount = tAmount.mul(currentRate);
777         uint256 rTransferAmount = rAmount.sub(
778             totalFeePerTx(tAmount).mul(currentRate)
779         );
780         _checkMaxWalletAmount(recipient, tTransferAmount);
781         _rOwned[sender] = _rOwned[sender].sub(rAmount);
782         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
783         _takeAllFee(sender,tAmount, currentRate);
784         _takeBurnFee(sender,tAmount, currentRate);
785         _reflectFee(tAmount);
786         emit Transfer(sender, recipient, tTransferAmount);
787     }
788 
789     // if sender is excluded from reward
790     function _transferFromExcluded(
791         address sender,
792         address recipient,
793         uint256 tAmount
794     ) private {
795         uint256 currentRate = _getRate();
796         uint256 tTransferAmount = tAmount.sub(totalFeePerTx(tAmount));
797         uint256 rAmount = tAmount.mul(currentRate);
798         uint256 rTransferAmount = rAmount.sub(
799             totalFeePerTx(tAmount).mul(currentRate)
800         );
801         _checkMaxWalletAmount(recipient, tTransferAmount);
802         _tOwned[sender] = _tOwned[sender].sub(tAmount);
803         excludedTSupply = excludedTSupply.sub(tAmount);
804         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
805         _takeAllFee(sender,tAmount, currentRate);
806         _takeBurnFee(sender,tAmount, currentRate);
807         _reflectFee(tAmount);
808 
809         emit Transfer(sender, recipient, tTransferAmount);
810     }
811 
812     // if both sender and receiver are excluded from reward
813     function _transferBothExcluded(
814         address sender,
815         address recipient,
816         uint256 tAmount
817     ) private {
818         uint256 currentRate = _getRate();
819         uint256 tTransferAmount = tAmount.sub(totalFeePerTx(tAmount));
820         _checkMaxWalletAmount(recipient, tTransferAmount);
821         _tOwned[sender] = _tOwned[sender].sub(tAmount);
822         excludedTSupply = excludedTSupply.sub(tAmount);
823         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
824         excludedTSupply = excludedTSupply.add(tAmount);
825         _takeAllFee(sender,tAmount, currentRate);
826         _takeBurnFee(sender,tAmount, currentRate);
827         _reflectFee(tAmount);
828 
829         emit Transfer(sender, recipient, tTransferAmount);
830     }
831 
832     // if receiver is excluded from reward
833     function _transferToExcluded(
834         address sender,
835         address recipient,
836         uint256 tAmount
837     ) private {
838         uint256 currentRate = _getRate();
839         uint256 tTransferAmount = tAmount.sub(totalFeePerTx(tAmount));
840         uint256 rAmount = tAmount.mul(currentRate);
841         _checkMaxWalletAmount(recipient, tTransferAmount);
842         _rOwned[sender] = _rOwned[sender].sub(rAmount);
843         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
844         excludedTSupply = excludedTSupply.add(tAmount);
845         _takeAllFee(sender,tAmount, currentRate);
846         _takeBurnFee(sender,tAmount, currentRate);
847         _reflectFee(tAmount);
848 
849         emit Transfer(sender, recipient, tTransferAmount);
850     }
851 
852     // for automatic redistribution among all holders on each tx
853     function _reflectFee(uint256 tAmount) private {
854         uint256 tFee = tAmount.mul(_currentReflectionFee).div(1e3);
855         uint256 rFee = tFee.mul(_getRate());
856         _rTotal = _rTotal.sub(rFee);
857         _tFeeTotal = _tFeeTotal.add(tFee);
858     }
859 
860      // take fees for liquidity, market/dev
861     function _takeAllFee(address sender,uint256 tAmount, uint256 currentRate) internal {
862         uint256 tFee = tAmount
863             .mul(_currentLiquidityFee.add(_currentmarketWalletFee))
864             .div(1e3);
865 
866         if (tFee > 0) {
867             _accumulatedLiquidity = _accumulatedLiquidity.add(
868                 tAmount.mul(_currentLiquidityFee).div(1e3)
869             );
870             _accumulatedMarketWallet = _accumulatedMarketWallet.add(
871                 tAmount.mul(_currentmarketWalletFee).div(1e3)
872             );
873 
874             uint256 rFee = tFee.mul(currentRate);
875             if (_isExcludedFromReward[address(this)])
876                 _tOwned[address(this)] = _tOwned[address(this)].add(tFee);
877             else _rOwned[address(this)] = _rOwned[address(this)].add(rFee);
878 
879             emit Transfer(sender, address(this), tFee);
880         }
881     }
882    function _takeBurnFee(address sender,uint256 tAmount, uint256 currentRate) internal {
883         uint256 burnFee = tAmount.mul(_currentBurnFee).div(1e3);
884         uint256 rBurnFee = burnFee.mul(currentRate);
885         _rOwned[burnAddress] = _rOwned[burnAddress].add(rBurnFee);
886 
887         emit Transfer(sender, burnAddress, burnFee);
888     }
889 
890     
891     function swapAndLiquify(address from, address to) private {
892         // is the token balance of this contract address over the min number of
893         // tokens that we need to initiate a swap + liquidity lock?
894         // also, don't get caught in a circular liquidity event.
895         // also, don't swap & liquify if sender is Dex pair.
896         uint256 contractTokenBalance = balanceOf(address(this));
897 
898         bool shouldSell = contractTokenBalance >= minTokenToSwap;
899 
900         if (
901             shouldSell &&
902             from != dexPair &&
903             swapAndLiquifyEnabled &&
904             !(from == address(this) && to == address(dexPair)) // swap 1 time
905         ) {
906             // approve contract
907             _approve(address(this), address(dexRouter), contractTokenBalance);
908 
909             uint256 halfLiquid = _accumulatedLiquidity.div(2);
910             uint256 otherHalfLiquid = _accumulatedLiquidity.sub(halfLiquid);
911 
912             uint256 tokenAmountToBeSwapped = contractTokenBalance.sub(
913                 otherHalfLiquid
914             );
915 
916             // now is to lock into liquidty pool
917             Utils.swapTokensForEth(address(dexRouter), tokenAmountToBeSwapped);
918 
919             uint256 deltaBalance = address(this).balance;
920             uint256 bnbToBeAddedToLiquidity = deltaBalance.mul(halfLiquid).div(tokenAmountToBeSwapped);
921             uint256 bnbFormarketWallet = deltaBalance.sub(bnbToBeAddedToLiquidity);  
922 
923             // sending bnb to award pool wallet
924             if(bnbFormarketWallet > 0)
925                 marketWallet.transfer(bnbFormarketWallet); 
926 
927             // add liquidity to Dex
928             if(bnbToBeAddedToLiquidity > 0){
929                 Utils.addLiquidity(
930                     address(dexRouter),
931                     owner(),
932                     otherHalfLiquid,
933                     bnbToBeAddedToLiquidity
934                 );
935 
936                 emit SwapAndLiquify(
937                     halfLiquid,
938                     bnbToBeAddedToLiquidity,
939                     otherHalfLiquid
940                 );
941             }
942 
943             // Reset current accumulated amount
944             _accumulatedLiquidity = 0; 
945             _accumulatedMarketWallet = 0;
946         }
947     }
948 }
949 
950 // Library for doing a swap on Dex
951 library Utils {
952     using SafeMath for uint256;
953 
954     function swapTokensForEth(address routerAddress, uint256 tokenAmount)
955         internal
956     {
957         IDexRouter dexRouter = IDexRouter(routerAddress);
958 
959         // generate the Dex pair path of token -> weth
960         address[] memory path = new address[](2);
961         path[0] = address(this);
962         path[1] = dexRouter.WETH();
963 
964         // make the swap
965         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
966             tokenAmount,
967             0, // accept any amount of BNB
968             path,
969             address(this),
970             block.timestamp + 300
971         );
972     }
973 
974     function addLiquidity(
975         address routerAddress,
976         address owner,
977         uint256 tokenAmount,
978         uint256 ethAmount
979     ) internal {
980         IDexRouter dexRouter = IDexRouter(routerAddress);
981 
982         // add the liquidity
983         dexRouter.addLiquidityETH{value: ethAmount}(
984             address(this),
985             tokenAmount,
986             0, // slippage is unavoidable
987             0, // slippage is unavoidable
988             owner,
989             block.timestamp + 300
990         );
991     }
992 }