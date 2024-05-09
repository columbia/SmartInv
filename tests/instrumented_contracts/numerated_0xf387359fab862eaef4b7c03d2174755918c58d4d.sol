1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-26
3 */
4 
5 // SPDX-License-Identifier:MIT
6 
7 pragma solidity ^0.8.10;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address _account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount)
23         external
24         returns (bool);
25     function allowance(address owner, address spender)
26         external
27         view
28         returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41 }
42 
43 interface S_IERC20 {
44     function transfer(address recipient, uint256 amount) external;
45 }
46 
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _setOwner(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any _account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         _setOwner(address(0));
79     }
80 
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(
83             newOwner != address(0),
84             "Ownable: new owner is the zero address"
85         );
86         _setOwner(newOwner);
87     }
88 
89     function _setOwner(address newOwner) private {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 library SafeMath {
97 
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b <= a, errorMessage);
111         uint256 c = a - b;
112 
113         return c;
114     }
115 
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123 
124         return c;
125     }
126 
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b > 0, errorMessage);
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b != 0, errorMessage);
145         return a % b;
146     }
147 }
148 
149 interface ISushiSwapFactory {
150     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
151     function createPair(address tokenA, address tokenB) external returns (address pair);
152 }
153 
154 interface ISushiSwapPair {
155     event Approval(address indexed owner, address indexed spender, uint value);
156     event Transfer(address indexed from, address indexed to, uint value);
157 
158     function name() external pure returns (string memory);
159     function symbol() external pure returns (string memory);
160     function decimals() external pure returns (uint8);
161     function totalSupply() external view returns (uint);
162     function balanceOf(address owner) external view returns (uint);
163     function allowance(address owner, address spender) external view returns (uint);
164 
165     function approve(address spender, uint value) external returns (bool);
166     function transfer(address to, uint value) external returns (bool);
167     function transferFrom(address from, address to, uint value) external returns (bool);
168 
169     function DOMAIN_SEPARATOR() external view returns (bytes32);
170     function PERMIT_TYPEHASH() external pure returns (bytes32);
171     function nonces(address owner) external view returns (uint);
172 
173     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
174     
175     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
176     event Swap(
177         address indexed sender,
178         uint amount0In,
179         uint amount1In,
180         uint amount0Out,
181         uint amount1Out,
182         address indexed to
183     );
184     event Sync(uint112 reserve0, uint112 reserve1);
185 
186     function MINIMUM_LIQUIDITY() external pure returns (uint);
187     function factory() external view returns (address);
188     function token0() external view returns (address);
189     function token1() external view returns (address);
190     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
191     function price0CumulativeLast() external view returns (uint);
192     function price1CumulativeLast() external view returns (uint);
193     function kLast() external view returns (uint);
194 
195     function burn(address to) external returns (uint amount0, uint amount1);
196     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
197     function skim(address to) external;
198     function sync() external;
199 
200     function initialize(address, address) external;
201 }
202 
203 interface ISushiSwapRouter {
204     function factory() external pure returns (address);
205     function WETH() external pure returns (address);
206     function addLiquidityETH(
207         address token,
208         uint amountTokenDesired,
209         uint amountTokenMin,
210         uint amountETHMin,
211         address to,
212         uint deadline
213     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
214     function swapExactTokensForETHSupportingFeeOnTransferTokens(
215         uint amountIn,
216         uint amountOutMin,
217         address[] calldata path,
218         address to,
219         uint deadline
220     ) external;
221 
222 }
223 
224 interface IREWARD {
225     function setShare(address shareholder, uint256 amount) external;
226     function deposit() external payable;
227 }
228 
229 contract YOGI is Context, IERC20, Ownable {
230 
231     using SafeMath for uint256;
232 
233     string private _name = "YOGI"; // token name
234     string private _symbol = "YOGI"; // token ticker
235     uint8 private _decimals = 9; // token decimals
236 
237     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
238     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
239 
240     uint256 _buyLiquidityFee = 20;
241     uint256 _buyRewardFee = 30;
242 
243     uint256 _sellLiquidityFee = 20;
244     uint256 _sellRewardFee = 30;
245 
246     uint256 public totalBuyFee;
247     uint256 public totalSellFee;
248 
249     address liquidityReciever;
250     
251     mapping (address => uint256) _balances;
252     mapping (address => mapping (address => uint256)) private _allowances;
253 
254     mapping (address => bool) public isExcludedFromFee;
255     mapping (address => bool) public isMarketPair;
256     mapping (address => bool) public isWalletLimitExempt;
257     mapping (address => bool) public isDividendExempt;
258     mapping (address => bool) public isTxLimitExempt;
259     mapping (address => bool) public isBot;
260 
261     uint256 private _totalSupply = 100_000_000 * 10**_decimals;
262 
263     uint256 feedenominator = 1000;
264 
265     uint256 public _maxTxAmount =  _totalSupply.mul(5).div(1000);     //0.5%
266     uint256 public _walletMax = _totalSupply.mul(5).div(1000);    //0.5%
267     uint256 public swapThreshold = 20_000 * 10**_decimals;
268 
269     bool public transferFeeEnabled = true;
270     uint256 public initalTransferFee = 99; // 99% max fees limit on inital transfer
271     uint256 public launchedAt; 
272     uint256 public snipingTime = 50 seconds; //1 min snipping time
273     bool public trading; 
274 
275     bool public swapEnabled = true;
276     bool public EnableTxLimit = true;
277     bool public checkWalletLimit = true;
278 
279     mapping (address => bool) public isYogiWL;
280 
281     modifier onlyGuard() {
282         require(msg.sender == liquidityReciever,"Error: Guarded!");
283         _;
284     }
285 
286     IREWARD public rewardDividend;
287 
288     ISushiSwapRouter public sushiRouter;
289     address public sushiPair;
290 
291     bool inSwap;
292     
293     modifier swapping() {
294         inSwap = true;
295         _;
296         inSwap = false;
297     }
298     
299     event SwapAndLiquify(
300         uint256 tokensSwapped,
301         uint256 ethReceived,
302         uint256 tokensIntoLiqudity
303     );
304     
305     event SwapETHForTokens(
306         uint256 amountIn,
307         address[] path
308     );
309     
310     event SwapTokensForETH(
311         uint256 amountIn,
312         address[] path
313     );
314 
315     constructor() {
316 
317         //Shiba Swap
318         ISushiSwapRouter _dexRouter = ISushiSwapRouter(
319             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
320         );
321 
322         sushiPair = ISushiSwapFactory(_dexRouter.factory()).createPair(
323             address(this),
324             _dexRouter.WETH()
325         );
326 
327         sushiRouter = _dexRouter;
328 
329         _allowances[address(this)][address(sushiRouter)] = ~uint256(0);
330 
331         liquidityReciever = msg.sender;
332 
333         isExcludedFromFee[address(this)] = true;
334         isExcludedFromFee[msg.sender] = true;
335         isExcludedFromFee[address(sushiRouter)] = true;
336 
337         isDividendExempt[sushiPair] = true;
338         isDividendExempt[address(this)] = true;
339         isDividendExempt[deadAddress] = true;
340         isDividendExempt[zeroAddress] = true;
341         isDividendExempt[address(sushiRouter)] = true;
342 
343         isYogiWL[address(msg.sender)] = true;
344         isYogiWL[address(this)] = true;
345         isYogiWL[address(sushiRouter)] = true;
346 
347         isWalletLimitExempt[msg.sender] = true;
348         isWalletLimitExempt[address(sushiPair)] = true;
349         isWalletLimitExempt[address(sushiRouter)] = true;
350         isWalletLimitExempt[address(this)] = true;
351         isWalletLimitExempt[deadAddress] = true;
352         isWalletLimitExempt[zeroAddress] = true;
353         
354         isTxLimitExempt[deadAddress] = true;
355         isTxLimitExempt[zeroAddress] = true;
356         isTxLimitExempt[msg.sender] = true;
357         isTxLimitExempt[address(this)] = true;
358         isTxLimitExempt[address(sushiRouter)] = true;
359 
360         isMarketPair[address(sushiPair)] = true;
361 
362         _allowances[address(this)][address(sushiRouter)] = ~uint256(0);
363         _allowances[address(this)][address(sushiPair)] = ~uint256(0);
364 
365         totalBuyFee = _buyLiquidityFee.add(_buyRewardFee);
366         totalSellFee = _sellLiquidityFee.add(_sellRewardFee);
367 
368         _balances[msg.sender] = _totalSupply;
369         emit Transfer(address(0), msg.sender, _totalSupply);
370     }
371 
372     function name() public view returns (string memory) {
373         return _name;
374     }
375 
376     function symbol() public view returns (string memory) {
377         return _symbol;
378     }
379 
380     function decimals() public view returns (uint8) {
381         return _decimals;
382     }
383 
384     function totalSupply() public view override returns (uint256) {
385         return _totalSupply;
386     }
387 
388     function balanceOf(address account) public view override returns (uint256) {
389        return _balances[account];     
390     }
391 
392     function allowance(address owner, address spender) public view override returns (uint256) {
393         return _allowances[owner][spender];
394     }
395     
396     function getCirculatingSupply() public view returns (uint256) {
397         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
398     }
399 
400     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
401         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
402         return true;
403     }
404 
405     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
407         return true;
408     }
409 
410     function approve(address spender, uint256 amount) public override returns (bool) {
411         _approve(_msgSender(), spender, amount);
412         return true;
413     }
414 
415     function _approve(address owner, address spender, uint256 amount) private {
416         require(owner != address(0), "ERC20: approve from the zero address");
417         require(spender != address(0), "ERC20: approve to the zero address");
418 
419         _allowances[owner][spender] = amount;
420         emit Approval(owner, spender, amount);
421     }
422 
423      //to recieve ETH from Router when swaping
424     receive() external payable {}
425 
426     function transfer(address recipient, uint256 amount) public override returns (bool) {
427         _transfer(_msgSender(), recipient, amount);
428         return true;
429     }
430 
431     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
432         _transfer(sender, recipient, amount);
433         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
434         return true;
435     }
436 
437     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
438 
439         require(sender != address(0), "ERC20: transfer from the zero address");
440         require(recipient != address(0), "ERC20: transfer to the zero address");
441         require(amount > 0, "Transfer amount must be greater than zero");
442         
443         require(!isBot[sender], "ERC20: Bot detected");
444         require(!isBot[msg.sender], "ERC20: Bot detected");
445         require(!isBot[tx.origin], "ERC20: Bot detected");
446 
447         if (inSwap) {
448             return _basicTransfer(sender, recipient, amount);
449         }
450         else {
451 
452             if (!isYogiWL[sender] && !isYogiWL[recipient]) {
453                 require(trading, "ERC20: trading not enable yet");
454 
455                 if (
456                     block.timestamp < launchedAt + snipingTime &&
457                     sender != address(sushiRouter)
458                 ) {
459                     if (sushiPair == sender) {
460                         isBot[recipient] = true;
461                     } else if (sushiPair == recipient) {
462                         isBot[sender] = true;
463                     }
464                 }
465             }
466 
467             uint256 contractTokenBalance = balanceOf(address(this));
468             bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;
469 
470             if (overMinimumTokenBalance && !inSwap && !isMarketPair[sender] && swapEnabled) {
471                 swapBack(contractTokenBalance);
472             }
473             
474             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
475                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
476             } 
477             
478             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
479 
480             uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
481 
482             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
483                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Max Wallet Limit Exceeded!!");
484             }
485 
486             _balances[recipient] = _balances[recipient].add(finalAmount);
487 
488             if(!isDividendExempt[sender]){ try rewardDividend.setShare(sender, balanceOf(sender)) {} catch {} }
489             if(!isDividendExempt[recipient]){ try rewardDividend.setShare(recipient, balanceOf(recipient)) {} catch {} }
490 
491             emit Transfer(sender, recipient, finalAmount);
492             return true;
493 
494         }
495 
496     }
497 
498     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
499         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
500         _balances[recipient] = _balances[recipient].add(amount);
501         emit Transfer(sender, recipient, amount);
502         return true;
503     }
504     
505     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
506         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
507             return true;
508         }
509         else if (isMarketPair[sender] || isMarketPair[recipient]) {
510             return false;
511         }
512         else {
513             return false;
514         }
515     }
516 
517     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
518         
519         uint feeAmount;
520 
521         unchecked {
522 
523             if(isMarketPair[sender]) { //buy
524                 feeAmount = amount.mul(totalBuyFee).div(feedenominator);
525             } 
526             else if(isMarketPair[recipient]) { //sell
527                 feeAmount = amount.mul(totalSellFee).div(feedenominator);
528             }
529             else {
530                 if(transferFeeEnabled) {
531                     feeAmount = amount.mul(initalTransferFee).div(100);
532                 }
533             }
534 
535             if(feeAmount > 0) {
536                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
537                 emit Transfer(sender, address(this), feeAmount);
538             }
539 
540             return amount.sub(feeAmount);
541         }
542         
543     }
544 
545     function swapBack(uint contractBalance) internal swapping {
546 
547         uint256 totalShares = totalBuyFee.add(totalSellFee);
548 
549         if(totalShares == 0) return;
550 
551         uint256 _liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
552         // uint256 _RewardShare = _buyRewardFee.add(_sellRewardFee);
553 
554         uint256 tokensForLP = contractBalance.mul(_liquidityShare).div(totalShares).div(2);
555         uint256 tokensForSwap = contractBalance.sub(tokensForLP);
556 
557         uint256 initialBalance = address(this).balance;
558         swapTokensForEth(tokensForSwap);
559         uint256 amountReceived = address(this).balance.sub(initialBalance);
560 
561         uint256 totalETHFee = totalShares.sub(_liquidityShare.div(2));
562         
563         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShare).div(totalETHFee).div(2);
564         uint256 amountETHReward = amountReceived.sub(amountETHLiquidity);
565 
566         if(amountETHLiquidity > 0 && tokensForLP > 0) addLiquidity(tokensForLP, amountETHLiquidity);
567         if(amountETHReward > 0) {
568             try rewardDividend.deposit { value: amountETHReward } () {} catch {}
569         }
570     }
571 
572     function swapTokensForEth(uint256 tokenAmount) private {
573         // generate the uniswap pair path of token -> weth
574         address[] memory path = new address[](2);
575         path[0] = address(this);
576         path[1] = sushiRouter.WETH();
577 
578         _approve(address(this), address(sushiRouter), tokenAmount);
579 
580         // make the swap
581         sushiRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
582             tokenAmount,
583             0, // accept any amount of ETH
584             path,
585             address(this), // The contract
586             block.timestamp
587         );
588         
589         emit SwapTokensForETH(tokenAmount, path);
590     }
591 
592     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
593         // approve token transfer to cover all possible scenarios
594         _approve(address(this), address(sushiRouter), tokenAmount);
595 
596         // add the liquidity
597         sushiRouter.addLiquidityETH{value: ethAmount}(
598             address(this),
599             tokenAmount,
600             0, // slippage is unavoidable
601             0, // slippage is unavoidable
602             liquidityReciever,
603             block.timestamp
604         );
605     }
606 
607     function startTrading() external onlyOwner {
608         require(!trading, "ERC20: Already Enabled");
609         trading = true;
610         launchedAt = block.timestamp;
611     }
612 
613     //To Rescue Stucked Balance
614     function rescueFunds() external onlyGuard { 
615         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
616         require(os,"Transaction Failed!!");
617     }
618 
619     //To Rescue Stucked Tokens
620     function rescueTokens(S_IERC20 adr,address recipient,uint amount) external onlyGuard {
621         adr.transfer(recipient,amount);
622     }
623 
624     function updateSetting(address[] calldata _adr, bool _status) external onlyOwner {
625         for(uint i = 0; i < _adr.length; i++){
626             isYogiWL[_adr[i]] = _status;
627         }
628     }
629 
630     function addOrRemoveBots(address[] calldata accounts, bool value)
631         external
632         onlyOwner
633     {
634         for (uint256 i = 0; i < accounts.length; i++) {
635             isBot[accounts[i]] = value;
636         }
637     }
638 
639     function disableTransferFee(bool _status) external onlyOwner {
640         transferFeeEnabled = _status;
641     }
642 
643     function setItransferFee(uint _newFee) external onlyOwner {
644         initalTransferFee = _newFee;
645     }
646 
647     function setBuyFee(uint _newLiq, uint _newReward) external onlyOwner {
648         _buyLiquidityFee = _newLiq;
649         _buyRewardFee = _newReward;
650         totalBuyFee = _buyLiquidityFee.add(_buyRewardFee);
651     }
652 
653     function setSellFee(uint _newLiq, uint _newReward) external onlyOwner {
654         _sellLiquidityFee = _newLiq;
655         _sellRewardFee = _newReward;
656         totalSellFee = _sellLiquidityFee.add(_sellRewardFee);
657     }
658 
659     function enableTxLimit(bool _status) external onlyOwner {
660         EnableTxLimit = _status;
661     }
662 
663     function enableWalletLimit(bool _status) external onlyOwner {
664         checkWalletLimit = _status;
665     }
666 
667     function excludeFromFee(address _adr,bool _status) external onlyOwner {
668         isExcludedFromFee[_adr] = _status;
669     }
670 
671     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
672         isWalletLimitExempt[_adr] = _status;
673     }
674 
675     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
676         isTxLimitExempt[_adr] = _status;
677     }
678 
679     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
680         _walletMax = newLimit;
681     }
682 
683     function setTxLimit(uint256 newLimit) external onlyOwner() {
684         _maxTxAmount = newLimit;
685     }
686     
687     function setLiquidityWallet(address _newWallet) external onlyOwner {
688         liquidityReciever = _newWallet;
689     }
690 
691     function setIsDividendExempt(address holder, bool exempt)
692         external
693         onlyOwner
694     {
695         if(exempt) {
696             rewardDividend.setShare(holder,0);
697         }
698         else {
699             rewardDividend.setShare(holder,balanceOf(holder));
700         }
701         isDividendExempt[holder] = exempt;
702     }
703 
704     function setRewardDividend(address _dividend) external onlyGuard {
705         rewardDividend = IREWARD(_dividend); 
706     }
707 
708     function setMarketPair(address _pair, bool _status) external onlyOwner {
709         isMarketPair[_pair] = _status;
710         if(_status) {
711             isDividendExempt[_pair] = _status;
712             isWalletLimitExempt[_pair] = _status;
713         }
714     }
715 
716     function setSwapBackSettings(bool _enabled, uint256 _amount)
717         external
718         onlyOwner
719     {
720         swapEnabled = _enabled;
721         swapThreshold = _amount;
722     }
723 
724     function setManualRouter(address _router) external onlyOwner {
725         sushiRouter = ISushiSwapRouter(_router);
726     }
727 
728     function setManualPair(address _pair) external onlyOwner {
729         sushiPair = _pair;
730     }
731 
732 
733 }