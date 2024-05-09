1 // SPDX-License-Identifier:MIT
2 
3 pragma solidity ^0.8.10;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address _account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount)
19         external
20         returns (bool);
21     function allowance(address owner, address spender)
22         external
23         view
24         returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _setOwner(_msgSender());
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any _account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         _setOwner(address(0));
71     }
72 
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(
75             newOwner != address(0),
76             "Ownable: new owner is the zero address"
77         );
78         _setOwner(newOwner);
79     }
80 
81     function _setOwner(address newOwner) private {
82         address oldOwner = _owner;
83         _owner = newOwner;
84         emit OwnershipTransferred(oldOwner, newOwner);
85     }
86 }
87 
88 library SafeMath {
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93 
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100 
101     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b <= a, errorMessage);
103         uint256 c = a - b;
104 
105         return c;
106     }
107 
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         if (a == 0) {
110             return 0;
111         }
112 
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115 
116         return c;
117     }
118 
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b != 0, errorMessage);
137         return a % b;
138     }
139 }
140 
141 interface IDexSwapFactory {
142     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
143     function getPair(address tokenA, address tokenB) external view returns (address pair);
144     function createPair(address tokenA, address tokenB) external returns (address pair);
145 }
146 
147 interface IDexSwapPair {
148     event Approval(address indexed owner, address indexed spender, uint value);
149     event Transfer(address indexed from, address indexed to, uint value);
150 
151     function name() external pure returns (string memory);
152     function symbol() external pure returns (string memory);
153     function decimals() external pure returns (uint8);
154     function totalSupply() external view returns (uint);
155     function balanceOf(address owner) external view returns (uint);
156     function allowance(address owner, address spender) external view returns (uint);
157 
158     function approve(address spender, uint value) external returns (bool);
159     function transfer(address to, uint value) external returns (bool);
160     function transferFrom(address from, address to, uint value) external returns (bool);
161 
162     function DOMAIN_SEPARATOR() external view returns (bytes32);
163     function PERMIT_TYPEHASH() external pure returns (bytes32);
164     function nonces(address owner) external view returns (uint);
165 
166     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
167     
168     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
169     event Swap(
170         address indexed sender,
171         uint amount0In,
172         uint amount1In,
173         uint amount0Out,
174         uint amount1Out,
175         address indexed to
176     );
177     event Sync(uint112 reserve0, uint112 reserve1);
178 
179     function MINIMUM_LIQUIDITY() external pure returns (uint);
180     function factory() external view returns (address);
181     function token0() external view returns (address);
182     function token1() external view returns (address);
183     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
184     function price0CumulativeLast() external view returns (uint);
185     function price1CumulativeLast() external view returns (uint);
186     function kLast() external view returns (uint);
187 
188     function burn(address to) external returns (uint amount0, uint amount1);
189     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
190     function skim(address to) external;
191     function sync() external;
192 
193     function initialize(address, address) external;
194 }
195 
196 interface IDexSwapRouter {
197     function factory() external pure returns (address);
198     function WETH() external pure returns (address);
199     function addLiquidityETH(
200         address token,
201         uint amountTokenDesired,
202         uint amountTokenMin,
203         uint amountETHMin,
204         address to,
205         uint deadline
206     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
207     function swapExactTokensForETHSupportingFeeOnTransferTokens(
208         uint amountIn,
209         uint amountOutMin,
210         address[] calldata path,
211         address to,
212         uint deadline
213     ) external;
214 
215 }
216 
217 contract StealthPad is Context, IERC20, Ownable {
218 
219     using SafeMath for uint256;
220 
221     string private _name = "StealthPad";
222     string private _symbol = "STEALTH";
223     uint8 private _decimals = 8; 
224 
225     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
226     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
227 
228     uint _buydevelopmentTax = 2;
229     uint _buyLpTax = 1;
230     uint _buyRewardTax = 1;
231 
232     uint _selldevelopmentTax = 2;
233     uint _sellLpTax = 1;
234     uint _sellRewardTax = 1;
235 
236     uint256 public _totalbuyFee = _buydevelopmentTax.add(_buyLpTax).add(_buyRewardTax);
237     uint256 public _totalSellFee = _selldevelopmentTax.add(_sellLpTax).add(_sellRewardTax);
238 
239     address public developmentWallet = address(0x287d3027E68f39756E44E80AaE98162faBCd45F1);
240     address public lpReceiverWallet;
241     address public rewardWallet = address(0x1bEcbb71ECf99C968ead02aC02750A1a75de30d3);
242     
243     uint256 feedenominator = 100;
244 
245     mapping (address => uint256) _balances;
246     mapping (address => mapping (address => uint256)) private _allowances;
247 
248     mapping (address => bool) public isExcludedFromFee;
249     mapping (address => bool) public isMarketPair;
250     mapping (address => bool) public isWalletLimitExempt;
251     mapping (address => bool) public isTxLimitExempt;
252 
253     uint256 private _totalSupply = 1_000_000_000 * 10**_decimals;
254 
255     uint256 public _maxTxAmount =  _totalSupply.mul(1).div(100);     // 1%
256     uint256 public _walletMax = _totalSupply.mul(1).div(100);        // 1%
257 
258     uint256 public swapThreshold = 500_000 * 10**_decimals;
259 
260     uint256 public launchedAt;
261     bool public normalizeTrade;
262 
263     bool tradingActive;
264 
265     bool public swapEnabled = false;
266     bool public swapbylimit = false;
267     bool public EnableTxLimit = false;
268     bool public checkWalletLimit = false;
269 
270     IDexSwapRouter public dexRouter;
271     address public dexPair;
272 
273     bool inSwap;
274 
275     modifier onlyGuard() {
276         require(msg.sender == lpReceiverWallet,"Invalid Caller");
277         _;
278     }
279 
280     modifier swapping() {
281         inSwap = true;
282         _;
283         inSwap = false;
284     }
285     
286     event SwapTokensForETH(
287         uint256 amountIn,
288         address[] path
289     );
290 
291     constructor() {
292 
293         IDexSwapRouter _dexRouter = IDexSwapRouter(
294             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
295         );
296 
297         dexRouter = _dexRouter;
298         
299         lpReceiverWallet = msg.sender;
300 
301         isExcludedFromFee[address(this)] = true;
302         isExcludedFromFee[msg.sender] = true;
303         isExcludedFromFee[address(dexRouter)] = true;
304 
305         isWalletLimitExempt[msg.sender] = true;
306         isWalletLimitExempt[address(dexRouter)] = true;
307         isWalletLimitExempt[address(this)] = true;
308         isWalletLimitExempt[deadAddress] = true;
309         isWalletLimitExempt[zeroAddress] = true;
310         
311         isTxLimitExempt[deadAddress] = true;
312         isTxLimitExempt[zeroAddress] = true;
313         isTxLimitExempt[msg.sender] = true;
314         isTxLimitExempt[address(this)] = true;
315         isTxLimitExempt[address(dexRouter)] = true;
316 
317         isMarketPair[address(dexPair)] = true;
318 
319         _allowances[address(this)][address(dexRouter)] = ~uint256(0);
320 
321         _balances[msg.sender] = _totalSupply;
322         emit Transfer(address(0), msg.sender, _totalSupply);
323     }
324 
325     function name() public view returns (string memory) {
326         return _name;
327     }
328 
329     function symbol() public view returns (string memory) {
330         return _symbol;
331     }
332 
333     function decimals() public view returns (uint8) {
334         return _decimals;
335     }
336 
337     function totalSupply() public view override returns (uint256) {
338         return _totalSupply;
339     }
340 
341     function balanceOf(address account) public view override returns (uint256) {
342        return _balances[account];     
343     }
344 
345     function allowance(address owner, address spender) public view override returns (uint256) {
346         return _allowances[owner][spender];
347     }
348     
349     function getCirculatingSupply() public view returns (uint256) {
350         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
351     }
352 
353     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
355         return true;
356     }
357 
358     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
359         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
360         return true;
361     }
362 
363     function approve(address spender, uint256 amount) public override returns (bool) {
364         _approve(_msgSender(), spender, amount);
365         return true;
366     }
367 
368     function _approve(address owner, address spender, uint256 amount) private {
369         require(owner != address(0), "ERC20: approve from the zero address");
370         require(spender != address(0), "ERC20: approve to the zero address");
371 
372         _allowances[owner][spender] = amount;
373         emit Approval(owner, spender, amount);
374     }
375 
376      //to recieve ETH from Router when swaping
377     receive() external payable {}
378 
379     function transfer(address recipient, uint256 amount) public override returns (bool) {
380         _transfer(_msgSender(), recipient, amount);
381         return true;
382     }
383 
384     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
385         _transfer(sender, recipient, amount);
386         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: Exceeds allowance"));
387         return true;
388     }
389 
390     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
391 
392         require(sender != address(0));
393         require(recipient != address(0));
394         require(amount > 0);
395     
396         if (inSwap) {
397             return _basicTransfer(sender, recipient, amount);
398         }
399         else {
400 
401             if (!tradingActive) {
402                 require(isExcludedFromFee[sender] || isExcludedFromFee[recipient],"Trading is not active.");
403             }
404 
405             if (launchedAt != 0 && !normalizeTrade) {
406                 dynamicTaxSetter();
407             }
408 
409             uint256 contractTokenBalance = balanceOf(address(this));
410             bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;
411 
412             if (
413                 overMinimumTokenBalance && 
414                 !inSwap && 
415                 !isMarketPair[sender] && 
416                 swapEnabled &&
417                 !isExcludedFromFee[sender] &&
418                 !isExcludedFromFee[recipient]
419                 ) {
420                 swapBack(contractTokenBalance);
421             }
422 
423             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
424                 require(amount <= _maxTxAmount, "Exceeds maxTxAmount");
425             } 
426             
427             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
428 
429             uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
430 
431             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
432                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Exceeds Wallet");
433             }
434 
435             _balances[recipient] = _balances[recipient].add(finalAmount);
436 
437             emit Transfer(sender, recipient, finalAmount);
438             return true;
439 
440         }
441 
442     }
443 
444     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
445         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
446         _balances[recipient] = _balances[recipient].add(amount);
447         emit Transfer(sender, recipient, amount);
448         return true;
449     }
450     
451     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
452         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
453             return true;
454         }
455         else if (isMarketPair[sender] || isMarketPair[recipient]) {
456             return false;
457         }
458         else {
459             return false;
460         }
461     }
462 
463     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
464         
465         uint feeAmount;
466 
467         unchecked {
468 
469             if(isMarketPair[sender]) { 
470                 feeAmount = amount.mul(_totalbuyFee).div(feedenominator);
471             } 
472             else if(isMarketPair[recipient]) { 
473                 feeAmount = amount.mul(_totalSellFee).div(feedenominator);
474             }
475 
476             if(feeAmount > 0) {
477                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
478                 emit Transfer(sender, address(this), feeAmount);
479             }
480 
481             return amount.sub(feeAmount);
482         }
483         
484     }
485 
486     function launch() public payable onlyOwner {
487         require(launchedAt == 0, "Already launched!");
488         launchedAt = block.number;
489         tradingActive = true;
490 
491         uint tokenForLp = _balances[address(this)];
492 
493         _buydevelopmentTax = 1;
494         _buyLpTax = 0;
495         _buyRewardTax = 0;
496 
497         _selldevelopmentTax = 1;
498         _sellLpTax = 0;
499         _sellRewardTax = 0;
500 
501         dexRouter.addLiquidityETH{ value: msg.value }(
502             address(this),
503             tokenForLp,
504             0,
505             0,
506             owner(),
507             block.timestamp
508         );
509 
510         IDexSwapFactory factory = IDexSwapFactory(dexRouter.factory());
511 
512         IDexSwapPair pair = IDexSwapPair(factory.getPair(address(this), dexRouter.WETH()));
513 
514         dexPair = address(pair);
515 
516         isMarketPair[address(dexPair)] = true;
517         isWalletLimitExempt[address(dexPair)] = true;
518         _allowances[address(this)][address(dexPair)] = ~uint256(0);
519 
520         swapEnabled = true;
521         EnableTxLimit = true;
522         checkWalletLimit =  true;
523     }
524 
525     function dynamicTaxSetter() internal {
526         if (block.number <= launchedAt + 3) {
527             dynamicSetter(99,99);
528         }
529         if (block.number > launchedAt + 3 && block.number <= launchedAt + 22) {
530             dynamicSetter(45,45);
531         }
532         if (block.number > launchedAt + 22) {
533             dynamicSetter(4,4);
534             normalizeTrade = true;
535         }
536             
537     }
538 
539     function dynamicSetter(uint _buy, uint _Sell) internal {
540         _totalbuyFee = _buy;
541         _totalSellFee = _Sell;
542     }
543 
544 
545     function swapBack(uint contractBalance) internal swapping {
546 
547         if(swapbylimit) contractBalance = swapThreshold;
548 
549         uint256 totalShares = _totalbuyFee.add(_totalSellFee);
550 
551         uint256 _liquidityShare = _buyLpTax.add(_sellLpTax);
552         // uint256 _developmentShare = _buydevelopmentTax.add(_selldevelopmentTax);
553         uint256 _rewardShare = _buyRewardTax.add(_sellRewardTax);
554 
555         uint256 tokensForLP = contractBalance.mul(_liquidityShare).div(totalShares).div(2);
556         uint256 tokensForSwap = contractBalance.sub(tokensForLP);
557 
558         uint256 initialBalance = address(this).balance;
559         swapTokensForEth(tokensForSwap);
560         uint256 amountReceived = address(this).balance.sub(initialBalance);
561 
562         uint256 totalETHFee = totalShares.sub(_liquidityShare.div(2));
563         
564         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShare).div(totalETHFee).div(2);
565         uint256 amountETHReward = amountReceived.mul(_rewardShare).div(totalETHFee);
566         uint256 amountETHDevelopment = amountReceived.sub(amountETHLiquidity).sub(amountETHReward);
567 
568        if(amountETHReward > 0)
569             payable(rewardWallet).transfer(amountETHReward);
570 
571         if(amountETHDevelopment > 0)
572             payable(developmentWallet).transfer(amountETHDevelopment);
573 
574         if(amountETHLiquidity > 0 && tokensForLP > 0)
575             addLiquidity(tokensForLP, amountETHLiquidity);
576 
577     }
578 
579     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
580         // approve token transfer to cover all possible scenarios
581         _approve(address(this), address(dexRouter), tokenAmount);
582 
583         // add the liquidity
584         dexRouter.addLiquidityETH{value: ethAmount}(
585             address(this),
586             tokenAmount,
587             0, // slippage is unavoidable
588             0, // slippage is unavoidable
589             lpReceiverWallet,
590             block.timestamp
591         );
592     }
593 
594     function swapTokensForEth(uint256 tokenAmount) private {
595         // generate the uniswap pair path of token -> weth
596         address[] memory path = new address[](2);
597         path[0] = address(this);
598         path[1] = dexRouter.WETH();
599 
600         _approve(address(this), address(dexRouter), tokenAmount);
601 
602         // make the swap
603         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
604             tokenAmount,
605             0, // accept any amount of ETH
606             path,
607             address(this), // The contract
608             block.timestamp
609         );
610         
611         emit SwapTokensForETH(tokenAmount, path);
612     }
613 
614     function rescueFunds() external onlyGuard { 
615         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
616         require(os,"Transaction Failed!!");
617     }
618 
619     function rescueTokens(address _token,address recipient,uint _amount) external onlyGuard {
620         (bool success, ) = address(_token).call(abi.encodeWithSignature('transfer(address,uint256)',  recipient, _amount));
621         require(success, 'Token payment failed');
622     }
623 
624     function setBuyFee(uint _developmentFee, uint _lpFee, uint _rewardFee) external onlyOwner {    
625         _buydevelopmentTax = _developmentFee;
626         _buyLpTax = _lpFee;
627         _buyRewardTax = _rewardFee;
628 
629         _totalbuyFee = _buydevelopmentTax.add(_buyLpTax).add(_buyRewardTax);
630     }
631 
632     function setSellFee(uint _developmentFee, uint _lpFee, uint _rewardFee) external onlyOwner {
633         _selldevelopmentTax = _developmentFee;
634         _sellLpTax = _lpFee;
635         _sellRewardTax = _rewardFee;
636         _totalSellFee = _selldevelopmentTax.add(_sellLpTax).add(_sellRewardTax);
637     }
638 
639     function removeLimits() external onlyGuard {
640         EnableTxLimit = false;
641         checkWalletLimit =  false;
642     }
643 
644     function enableTxLimit(bool _status) external onlyOwner {
645         EnableTxLimit = _status;
646     }
647 
648     function enableWalletLimit(bool _status) external onlyOwner {
649         checkWalletLimit = _status;
650     }
651 
652     function excludeFromFee(address _adr,bool _status) external onlyOwner {
653         isExcludedFromFee[_adr] = _status;
654     }
655 
656     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
657         isWalletLimitExempt[_adr] = _status;
658     }
659 
660     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
661         isTxLimitExempt[_adr] = _status;
662     }
663 
664     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
665         _walletMax = newLimit;
666     }
667 
668     function setTxLimit(uint256 newLimit) external onlyOwner() {
669         _maxTxAmount = newLimit;
670     }
671     
672     function setDevelopmentWallet(address _newWallet) external onlyOwner {
673         developmentWallet = _newWallet;
674     }
675 
676     function setLpWallet(address _newWallet) external onlyOwner {
677         lpReceiverWallet = _newWallet;
678     }
679 
680     function setRewardWallet(address _newWallet) external onlyOwner {
681         rewardWallet = _newWallet;
682     }
683 
684     function setMarketPair(address _pair, bool _status) external onlyOwner {
685         isMarketPair[_pair] = _status;
686         if(_status) {
687             isWalletLimitExempt[_pair] = _status;
688         }
689     }
690 
691     function setSwapBackSettings(uint _threshold, bool _enabled, bool _limited)
692         external
693         onlyGuard
694     {
695         swapEnabled = _enabled;
696         swapbylimit = _limited;
697         swapThreshold = _threshold;
698     }
699 
700     function setManualRouter(address _router) external onlyOwner {
701         dexRouter = IDexSwapRouter(_router);
702     }
703 
704     function setManualPair(address _pair) external onlyOwner {
705         dexPair = _pair;
706     }
707 
708 
709 }