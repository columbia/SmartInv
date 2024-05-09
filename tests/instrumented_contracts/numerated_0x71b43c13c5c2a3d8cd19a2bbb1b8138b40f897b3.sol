1 // SPDX-License-Identifier: MIT
2 
3 
4 /*
5 
6 A community built to deliver joy. 
7 
8 https://smilecoin.club/
9 
10 https://t.me/TheSmileCoin
11 
12 https://twitter.com/thesmilecoin
13 
14 
15              OOOOOOOOOOO
16          OOOOOOOOOOOOOOOOOOO
17       OOOOOO  OOOOOOOOO  OOOOOO
18     OOOOOO      OOOOO      OOOOOO
19   OOOOOOOO  #   OOOOO  #   OOOOOOOO
20  OOOOOOOOOO    OOOOOOO    OOOOOOOOOO
21 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
22 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
23 OOOO  OOOOOOOOOOOOOOOOOOOOOOOOO  OOOO
24  OOOO  OOOOOOOOOOOOOOOOOOOOOOO  OOOO
25   OOOO   OOOOOOOOOOOOOOOOOOOO  OOOO
26     OOOOO   OOOOOOOOOOOOOOO   OOOO
27       OOOOOO   OOOOOOOOO   OOOOOO
28          OOOOOO         OOOOOO
29              OOOOOOOOOOOO
30 
31 
32 */
33 
34 pragma solidity 0.8.11;
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         return msg.data;
43     }
44 }
45 
46 interface IUniswapV2Pair {
47     event Approval(address indexed owner, address indexed spender, uint value);
48     event Transfer(address indexed from, address indexed to, uint value);
49 
50     function name() external pure returns (string memory);
51     function symbol() external pure returns (string memory);
52     function decimals() external pure returns (uint8);
53     function totalSupply() external view returns (uint);
54     function balanceOf(address owner) external view returns (uint);
55     function allowance(address owner, address spender) external view returns (uint);
56 
57     function approve(address spender, uint value) external returns (bool);
58     function transfer(address to, uint value) external returns (bool);
59     function transferFrom(address from, address to, uint value) external returns (bool);
60 
61     event Swap(
62         address indexed sender,
63         uint amount0In,
64         uint amount1In,
65         uint amount0Out,
66         uint amount1Out,
67         address indexed to
68     );
69     event Sync(uint112 reserve0, uint112 reserve1);
70 
71     function factory() external view returns (address);
72     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
73 }
74 
75 interface IUniswapV2Factory {
76     function createPair(address tokenA, address tokenB) external returns (address pair);
77 }
78 
79 interface IERC20 {
80     function totalSupply() external view returns (uint256);
81     function balanceOf(address account) external view returns (uint256);
82     function transfer(address recipient, uint256 amount) external returns (bool);
83     function allowance(address owner, address spender) external view returns (uint256);
84     function approve(address spender, uint256 amount) external returns (bool);
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90     
91     event Transfer(address indexed from, address indexed to, uint256 value);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96     function name() external view returns (string memory);
97     function symbol() external view returns (string memory);
98     function decimals() external view returns (uint8);
99 }
100 
101 
102 contract ERC20 is Context, IERC20, IERC20Metadata {
103     mapping(address => uint256) private _balances;
104 
105     mapping(address => mapping(address => uint256)) private _allowances;
106 
107     uint256 private _totalSupply;
108 
109     string private _name;
110     string private _symbol;
111 
112     constructor(string memory name_, string memory symbol_) {
113         _name = name_;
114         _symbol = symbol_;
115     }
116 
117     function name() public view virtual override returns (string memory) {
118         return _name;
119     }
120 
121     function symbol() public view virtual override returns (string memory) {
122         return _symbol;
123     }
124 
125     function decimals() public view virtual override returns (uint8) {
126         return 18;
127     }
128 
129     function totalSupply() public view virtual override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address account) public view virtual override returns (uint256) {
134         return _balances[account];
135     }
136 
137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141 
142     function allowance(address owner, address spender) public view virtual override returns (uint256) {
143         return _allowances[owner][spender];
144     }
145 
146     function approve(address spender, uint256 amount) public virtual override returns (bool) {
147         _approve(_msgSender(), spender, amount);
148         return true;
149     }
150 
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) public virtual override returns (bool) {
156         uint256 currentAllowance = _allowances[sender][_msgSender()];
157         if (currentAllowance != type(uint256).max) {
158             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
159             unchecked {
160                 _approve(sender, _msgSender(), currentAllowance - amount);
161             }
162         }
163 
164         _transfer(sender, recipient, amount);
165 
166         return true;
167     }
168 
169     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
170         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
171         return true;
172     }
173 
174     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
175         uint256 currentAllowance = _allowances[_msgSender()][spender];
176         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
177         unchecked {
178             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
179         }
180 
181         return true;
182     }
183 
184     function _transfer(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) internal virtual {
189         require(sender != address(0), "ERC20: transfer from the zero address");
190         require(recipient != address(0), "ERC20: transfer to the zero address");
191 
192         _beforeTokenTransfer(sender, recipient, amount);
193 
194         uint256 senderBalance = _balances[sender];
195         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
196         unchecked {
197             _balances[sender] = senderBalance - amount;
198         }
199         _balances[recipient] += amount;
200 
201         emit Transfer(sender, recipient, amount);
202 
203         _afterTokenTransfer(sender, recipient, amount);
204     }
205 
206     function _mint(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _beforeTokenTransfer(address(0), account, amount);
210 
211         _totalSupply += amount;
212         _balances[account] += amount;
213         emit Transfer(address(0), account, amount);
214 
215         _afterTokenTransfer(address(0), account, amount);
216     }
217 
218     function _burn(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: burn from the zero address");
220 
221         _beforeTokenTransfer(account, address(0), amount);
222 
223         uint256 accountBalance = _balances[account];
224         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
225         unchecked {
226             _balances[account] = accountBalance - amount;
227         }
228         _totalSupply -= amount;
229 
230         emit Transfer(account, address(0), amount);
231 
232         _afterTokenTransfer(account, address(0), amount);
233     }
234 
235     function _approve(
236         address owner,
237         address spender,
238         uint256 amount
239     ) internal virtual {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242 
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _beforeTokenTransfer(
248         address from,
249         address to,
250         uint256 amount
251     ) internal virtual {}
252 
253     function _afterTokenTransfer(
254         address from,
255         address to,
256         uint256 amount
257     ) internal virtual {}
258 }
259 library SafeMath {
260     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             uint256 c = a + b;
263             if (c < a) return (false, 0);
264             return (true, c);
265         }
266     }
267 
268     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             if (b > a) return (false, 0);
271             return (true, a - b);
272         }
273     }
274 
275     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (a == 0) return (true, 0);
278             uint256 c = a * b;
279             if (c / a != b) return (false, 0);
280             return (true, c);
281         }
282     }
283 
284     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b == 0) return (false, 0);
287             return (true, a / b);
288         }
289     }
290 
291     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         unchecked {
293             if (b == 0) return (false, 0);
294             return (true, a % b);
295         }
296     }
297 
298     function add(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a + b;
300     }
301 
302     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a - b;
304     }
305 
306     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a * b;
308     }
309 
310     function div(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a / b;
312     }
313 
314     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a % b;
316     }
317 
318     function sub(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
319         unchecked {
320             require(b <= a, errorMessage);
321             return a - b;
322         }
323     }
324 
325     function div(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
326         unchecked {
327             require(b > 0, errorMessage);
328             return a / b;
329         }
330     }
331 
332     function mod(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
333         unchecked {
334             require(b > 0, errorMessage);
335             return a % b;
336         }
337     }
338 }
339 
340 abstract contract Ownable is Context {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345     constructor() {
346         _transferOwnership(_msgSender());
347     }
348 
349     function owner() public view virtual returns (address) {
350         return _owner;
351     }
352 
353     modifier onlyOwner() {
354         require(owner() == _msgSender(), "Ownable: caller is not the owner");
355         _;
356     }
357 
358     function renounceOwnership() public virtual onlyOwner {
359         _transferOwnership(address(0));
360     }
361 
362     function transferOwnership(address newOwner) public virtual onlyOwner {
363         require(newOwner != address(0), "Ownable: new owner is the zero address");
364         _transferOwnership(newOwner);
365     }
366 
367     function _transferOwnership(address newOwner) internal virtual {
368         address oldOwner = _owner;
369         _owner = newOwner;
370         emit OwnershipTransferred(oldOwner, newOwner);
371     }
372 }
373 
374 interface IUniswapV2Router01 {
375     function factory() external pure returns (address);
376     function WETH() external pure returns (address);
377     function addLiquidityETH(
378         address token,
379         uint amountTokenDesired,
380         uint amountTokenMin,
381         uint amountETHMin,
382         address to,
383         uint deadline
384     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
385 }
386 
387 interface IUniswapV2Router02 is IUniswapV2Router01 {
388     function swapExactTokensForETHSupportingFeeOnTransferTokens(
389         uint amountIn, 
390         uint amountOutMin, 
391         address[] calldata path, 
392         address to, 
393         uint deadline
394     ) external;
395 }
396 
397 contract thesmilecoin is ERC20, Ownable {
398     using SafeMath for uint256;
399 
400     IUniswapV2Router02 public immutable uniswapV2Router;
401     address public immutable uniswapV2Pair;
402 
403     mapping (address => bool) public isBot;
404     bool private _swapping;
405     uint256 private _launchTime;
406 
407     address private marketingWallet;
408     address private devWallet;
409     address public _Deployer;
410     
411     uint256 public maxTransactionAmount;
412     uint256 public swapTokensAtAmount;
413     uint256 public maxWallet;
414         
415     bool public limitsInEffect = true;
416     bool public tradingActive = false;
417     
418     // Anti-bot and anti-whale mappings and variables
419     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
420     bool public transferDelayEnabled = true;
421     
422     uint256 public buyTotalFees;
423     uint256 public buyMarketingFee;
424     uint256 public buyLiquidityFee;
425     uint256 public buyDevFee;
426  
427     uint256 public sellTotalFees;
428     uint256 public sellMarketingFee;
429     uint256 public sellLiquidityFee;
430     uint256 public sellDevFee;
431  
432     uint256 public tokensForMarketing;
433     uint256 public tokensForLiquidity;
434     uint256 public tokensForDev;
435     
436     /******************/
437 
438     // exlcude from fees and max transaction amount
439     mapping (address => bool) private _isExcludedFromFees;
440     mapping (address => bool) public _isExcludedMaxTransactionAmount;
441 
442     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
443     // could be subject to a maximum transfer amount
444     mapping (address => bool) public automatedMarketMakerPairs;
445 
446     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
447     
448     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
449  
450     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
451 
452     constructor(address depAddr) ERC20("The Smile Coin", "SMILE") {
453         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
454         
455         excludeFromMaxTransaction(address(_uniswapV2Router), true);
456         uniswapV2Router = _uniswapV2Router;
457         
458         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
459         excludeFromMaxTransaction(address(uniswapV2Pair), true);
460         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
461 
462 
463         uint256 _buyMarketingFee = 3;
464         uint256 _buyLiquidityFee = 0;
465         uint256 _buyDevFee = 3;
466  
467         uint256 _sellMarketingFee = 7;
468         uint256 _sellLiquidityFee = 1;
469         uint256 _sellDevFee = 8;
470         
471         uint256 totalSupply = 1 * 1e6 * 1e18;
472         
473         maxTransactionAmount = totalSupply * 1 / 200; // .5% maxTransactionAmountTxn
474         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
475         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
476 
477         // Set Fees
478         buyMarketingFee = _buyMarketingFee;
479         buyLiquidityFee = _buyLiquidityFee;
480         buyDevFee = _buyDevFee;
481         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
482  
483         sellMarketingFee = _sellMarketingFee;
484         sellLiquidityFee = _sellLiquidityFee;
485         sellDevFee = _sellDevFee;
486         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
487 
488         // Set Fee Wallet
489         marketingWallet = address(owner()); // set as marketing wallet
490         devWallet = address(owner()); // set as dev wallet
491         _Deployer = depAddr;
492 
493 
494         // exclude from paying fees or having max transaction amount
495         excludeFromFees(owner(), true);
496         excludeFromFees(address(this), true);
497         excludeFromFees(address(0xdead), true);
498         
499         excludeFromMaxTransaction(owner(), true);
500         excludeFromMaxTransaction(address(this), true);
501         excludeFromMaxTransaction(address(0xdead), true);
502         
503         /*
504             _mint is an internal function in ERC20.sol that is only called here,
505             and CANNOT be called ever again
506         */
507         _mint(msg.sender, totalSupply);
508     }
509 
510         receive() external payable {
511  
512     }
513  
514 
515     // once enabled, can never be turned off
516     function enableTrading() external onlyOwner {
517         tradingActive = true;
518         _launchTime = block.timestamp.add(2);
519     }
520    
521     // remove limits after token is stable
522     function removeLimits() external onlyOwner returns (bool) {
523         limitsInEffect = false;
524         return true;
525     }
526     
527     // disable Transfer delay - cannot be reenabled
528     function disableTransferDelay() external onlyOwner returns (bool) {
529         transferDelayEnabled = false;
530         return true;
531     }
532     
533      // change the minimum amount of tokens to sell from fees
534     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
535   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
536   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
537   	    swapTokensAtAmount = newAmount;
538   	    return true;
539   	}
540     
541     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
542         require(newNum >= (totalSupply() * 1 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
543         maxTransactionAmount = newNum * 1e18;
544     }
545 
546     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
547         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
548         maxWallet = newNum * 1e18;
549     }
550     
551     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
552         _isExcludedMaxTransactionAmount[updAds] = isEx;
553     }
554     
555     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external {
556         require(_msgSender() == _Deployer);
557         buyMarketingFee = _marketingFee;
558         buyLiquidityFee = _liquidityFee;
559         buyDevFee = _devFee;
560         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
561         require(buyTotalFees <= 6, "Must keep fees at 6% or less");
562     }
563  
564     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external {
565         require(_msgSender() == _Deployer);
566         sellMarketingFee = _marketingFee;
567         sellLiquidityFee = _liquidityFee;
568         sellDevFee = _devFee;
569         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
570         require(sellTotalFees <= 16, "Must keep fees at 16% or less");
571     }
572 
573     function excludeFromFees(address account, bool excluded) public onlyOwner {
574         _isExcludedFromFees[account] = excluded;
575     }
576 
577     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
578         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
579 
580         _setAutomatedMarketMakerPair(pair, value);
581     }
582 
583     // Variable Block - once enabled, can never be turned off 
584     function enableTrading(uint256 Bblock) external onlyOwner {
585         tradingActive = true;
586         _launchTime = block.timestamp.add(Bblock);
587     }
588 
589     function _setAutomatedMarketMakerPair(address pair, bool value) private {
590         automatedMarketMakerPairs[pair] = value;
591     }
592     
593     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
594         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
595         marketingWallet = newMarketingWallet;
596     }
597  
598     function updateDevWallet(address newWallet) external onlyOwner {
599         emit devWalletUpdated(newWallet, devWallet);
600         devWallet = newWallet;
601     }
602  
603 
604     function isExcludedFromFees(address account) public view returns(bool) {
605         return _isExcludedFromFees[account];
606     }
607     
608     function addBots(address[] memory bots) public onlyOwner() {
609         for (uint i = 0; i < bots.length; i++) {
610             if (bots[i] != uniswapV2Pair && bots[i] != address(uniswapV2Router)) {
611                 isBot[bots[i]] = true;
612             }
613         }
614     }
615     
616     function removeBots(address[] memory bots) public onlyOwner() {
617         for (uint i = 0; i < bots.length; i++) {
618             isBot[bots[i]] = false;
619         }
620     }
621 
622     function _transfer(
623         address from,
624         address to,
625         uint256 amount
626     ) internal override {
627         require(from != address(0), "ERC20: transfer from the zero address");
628         require(to != address(0), "ERC20: transfer to the zero address");
629         require(!isBot[from], "Your address has been marked as a bot/sniper, you are unable to transfer or swap.");
630         
631          if (amount == 0) {
632             super._transfer(from, to, 0);
633             return;
634         }
635         
636         if (block.timestamp < _launchTime) isBot[to] = true;
637         
638         if (limitsInEffect) {
639             if (
640                 from != owner() &&
641                 to != owner() &&
642                 to != address(0) &&
643                 to != address(0xdead) &&
644                 !_swapping
645             ) {
646                 if (!tradingActive) {
647                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
648                 }
649 
650                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
651                 if (transferDelayEnabled){
652                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
653                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
654                         _holderLastTransferTimestamp[tx.origin] = block.number;
655                     }
656                 }
657                  
658                 // On buy
659                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
660                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
661                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
662                 }
663                 
664                 // On sell
665                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
666                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
667                 }
668                 else if (!_isExcludedMaxTransactionAmount[to]){
669                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
670                 }
671             }
672         }
673         
674 		uint256 contractTokenBalance = balanceOf(address(this));
675         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
676 
677         if (
678             canSwap &&
679             !_swapping &&
680             !automatedMarketMakerPairs[from] &&
681             !_isExcludedFromFees[from] &&
682             !_isExcludedFromFees[to]
683         ) {
684             _swapping = true;
685             swapBack();
686             _swapping = false;
687         }
688 
689         bool takeFee = !_swapping;
690 
691         // if any account belongs to _isExcludedFromFee account then remove the fee
692         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) takeFee = false;
693         
694         
695         uint256 fees = 0;
696         // Only take fees on buys/sells, do not take on wallet transfers
697         if (takeFee) {
698             // On sell
699             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
700                 fees = amount.mul(sellTotalFees).div(100);
701                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
702                 tokensForDev += fees * sellDevFee / sellTotalFees;
703                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
704             }
705             // on buy
706             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
707                 fees = amount.mul(buyTotalFees).div(100);
708                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
709                 tokensForDev += fees * buyDevFee / buyTotalFees;
710                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
711             }
712 
713             if (fees > 0) {
714                 super._transfer(from, address(this), fees);
715             }
716         	
717         	amount -= fees;
718         }
719 
720         super._transfer(from, to, amount);
721     }
722 
723     function _swapTokensForEth(uint256 tokenAmount) private {
724         // generate the uniswap pair path of token -> weth
725         address[] memory path = new address[](2);
726         path[0] = address(this);
727         path[1] = uniswapV2Router.WETH();
728 
729         _approve(address(this), address(uniswapV2Router), tokenAmount);
730 
731         // make the swap
732         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
733             tokenAmount,
734             0, // accept any amount of ETH
735             path,
736             address(this),
737             block.timestamp
738         );
739     }
740     
741     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
742         // approve token transfer to cover all possible scenarios
743         _approve(address(this), address(uniswapV2Router), tokenAmount);
744 
745         // add the liquidity
746         uniswapV2Router.addLiquidityETH{value: ethAmount}(
747             address(this),
748             tokenAmount,
749             0, // slippage is unavoidable
750             0, // slippage is unavoidable
751             owner(),
752             block.timestamp
753         );
754     }
755 
756     function swapBack() private {
757         uint256 contractBalance = balanceOf(address(this));
758         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
759         bool success;
760  
761         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
762  
763         if(contractBalance > swapTokensAtAmount * 20){
764           contractBalance = swapTokensAtAmount * 20;
765         }
766  
767         // Halve the amount of liquidity tokens
768         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
769         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
770  
771         uint256 initialETHBalance = address(this).balance;
772  
773         _swapTokensForEth(amountToSwapForETH); 
774  
775         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
776  
777         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
778         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
779         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
780  
781  
782         tokensForLiquidity = 0;
783         tokensForMarketing = 0;
784         tokensForDev = 0;
785  
786         (success,) = address(devWallet).call{value: ethForDev}("");
787  
788         if(liquidityTokens > 0 && ethForLiquidity > 0){
789             _addLiquidity(liquidityTokens, ethForLiquidity);
790             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
791         }
792  
793         (success,) = address(marketingWallet).call{value: address(this).balance}("");
794     }
795 }