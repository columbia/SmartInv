1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.11;
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
15 interface IUniswapV2Pair {
16     event Approval(address indexed owner, address indexed spender, uint value);
17     event Transfer(address indexed from, address indexed to, uint value);
18 
19     function name() external pure returns (string memory);
20     function symbol() external pure returns (string memory);
21     function decimals() external pure returns (uint8);
22     function totalSupply() external view returns (uint);
23     function balanceOf(address owner) external view returns (uint);
24     function allowance(address owner, address spender) external view returns (uint);
25 
26     function approve(address spender, uint value) external returns (bool);
27     function transfer(address to, uint value) external returns (bool);
28     function transferFrom(address from, address to, uint value) external returns (bool);
29 
30     event Swap(
31         address indexed sender,
32         uint amount0In,
33         uint amount1In,
34         uint amount0Out,
35         uint amount1Out,
36         address indexed to
37     );
38     event Sync(uint112 reserve0, uint112 reserve1);
39 
40     function factory() external view returns (address);
41     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
42 }
43 
44 interface IUniswapV2Factory {
45     function createPair(address tokenA, address tokenB) external returns (address pair);
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(
55         address sender,
56         address recipient,
57         uint256 amount
58     ) external returns (bool);
59     
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 interface IERC20Metadata is IERC20 {
65     function name() external view returns (string memory);
66     function symbol() external view returns (string memory);
67     function decimals() external view returns (uint8);
68 }
69 
70 
71 contract ERC20 is Context, IERC20, IERC20Metadata {
72     mapping(address => uint256) private _balances;
73 
74     mapping(address => mapping(address => uint256)) private _allowances;
75 
76     uint256 private _totalSupply;
77 
78     string private _name;
79     string private _symbol;
80 
81     constructor(string memory name_, string memory symbol_) {
82         _name = name_;
83         _symbol = symbol_;
84     }
85 
86     function name() public view virtual override returns (string memory) {
87         return _name;
88     }
89 
90     function symbol() public view virtual override returns (string memory) {
91         return _symbol;
92     }
93 
94     function decimals() public view virtual override returns (uint8) {
95         return 18;
96     }
97 
98     function totalSupply() public view virtual override returns (uint256) {
99         return _totalSupply;
100     }
101 
102     function balanceOf(address account) public view virtual override returns (uint256) {
103         return _balances[account];
104     }
105 
106     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
107         _transfer(_msgSender(), recipient, amount);
108         return true;
109     }
110 
111     function allowance(address owner, address spender) public view virtual override returns (uint256) {
112         return _allowances[owner][spender];
113     }
114 
115     function approve(address spender, uint256 amount) public virtual override returns (bool) {
116         _approve(_msgSender(), spender, amount);
117         return true;
118     }
119 
120     function transferFrom(
121         address sender,
122         address recipient,
123         uint256 amount
124     ) public virtual override returns (bool) {
125         uint256 currentAllowance = _allowances[sender][_msgSender()];
126         if (currentAllowance != type(uint256).max) {
127             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
128             unchecked {
129                 _approve(sender, _msgSender(), currentAllowance - amount);
130             }
131         }
132 
133         _transfer(sender, recipient, amount);
134 
135         return true;
136     }
137 
138     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
139         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
140         return true;
141     }
142 
143     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
144         uint256 currentAllowance = _allowances[_msgSender()][spender];
145         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
146         unchecked {
147             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
148         }
149 
150         return true;
151     }
152 
153     function _transfer(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) internal virtual {
158         require(sender != address(0), "ERC20: transfer from the zero address");
159         require(recipient != address(0), "ERC20: transfer to the zero address");
160 
161         _beforeTokenTransfer(sender, recipient, amount);
162 
163         uint256 senderBalance = _balances[sender];
164         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
165         unchecked {
166             _balances[sender] = senderBalance - amount;
167         }
168         _balances[recipient] += amount;
169 
170         emit Transfer(sender, recipient, amount);
171 
172         _afterTokenTransfer(sender, recipient, amount);
173     }
174 
175     function _mint(address account, uint256 amount) internal virtual {
176         require(account != address(0), "ERC20: mint to the zero address");
177 
178         _beforeTokenTransfer(address(0), account, amount);
179 
180         _totalSupply += amount;
181         _balances[account] += amount;
182         emit Transfer(address(0), account, amount);
183 
184         _afterTokenTransfer(address(0), account, amount);
185     }
186 
187     function _burn(address account, uint256 amount) internal virtual {
188         require(account != address(0), "ERC20: burn from the zero address");
189 
190         _beforeTokenTransfer(account, address(0), amount);
191 
192         uint256 accountBalance = _balances[account];
193         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
194         unchecked {
195             _balances[account] = accountBalance - amount;
196         }
197         _totalSupply -= amount;
198         emit Transfer(account, address(0), amount);
199     }
200 
201     function _approve(
202         address owner,
203         address spender,
204         uint256 amount
205     ) internal virtual {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208 
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _beforeTokenTransfer(
214         address from,
215         address to,
216         uint256 amount
217     ) internal virtual {}
218 
219     function _afterTokenTransfer(
220         address from,
221         address to,
222         uint256 amount
223     ) internal virtual {}
224 }
225 library SafeMath {
226     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             uint256 c = a + b;
229             if (c < a) return (false, 0);
230             return (true, c);
231         }
232     }
233 
234     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
235         unchecked {
236             if (b > a) return (false, 0);
237             return (true, a - b);
238         }
239     }
240 
241     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         unchecked {
243             if (a == 0) return (true, 0);
244             uint256 c = a * b;
245             if (c / a != b) return (false, 0);
246             return (true, c);
247         }
248     }
249 
250     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
251         unchecked {
252             if (b == 0) return (false, 0);
253             return (true, a / b);
254         }
255     }
256 
257     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
258         unchecked {
259             if (b == 0) return (false, 0);
260             return (true, a % b);
261         }
262     }
263 
264     function add(uint256 a, uint256 b) internal pure returns (uint256) {
265         return a + b;
266     }
267 
268     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a - b;
270     }
271 
272     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a * b;
274     }
275 
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a / b;
278     }
279 
280     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a % b;
282     }
283 
284     function sub(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
285         unchecked {
286             require(b <= a, errorMessage);
287             return a - b;
288         }
289     }
290 
291     function div(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
292         unchecked {
293             require(b > 0, errorMessage);
294             return a / b;
295         }
296     }
297 
298     function mod(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
299         unchecked {
300             require(b > 0, errorMessage);
301             return a % b;
302         }
303     }
304 }
305 
306 abstract contract Ownable is Context {
307     address private _owner;
308 
309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
310 
311     constructor() {
312         _transferOwnership(_msgSender());
313     }
314 
315     function owner() public view virtual returns (address) {
316         return _owner;
317     }
318 
319     modifier onlyOwner() {
320         require(owner() == _msgSender(), "Ownable: caller is not the owner");
321         _;
322     }
323 
324     function renounceOwnership() public virtual onlyOwner {
325         _transferOwnership(address(0));
326     }
327 
328     function transferOwnership(address newOwner) public virtual onlyOwner {
329         require(newOwner != address(0), "Ownable: new owner is the zero address");
330         _transferOwnership(newOwner);
331     }
332 
333     function _transferOwnership(address newOwner) internal virtual {
334         address oldOwner = _owner;
335         _owner = newOwner;
336         emit OwnershipTransferred(oldOwner, newOwner);
337     }
338 }
339 
340 interface IUniswapV2Router01 {
341     function factory() external pure returns (address);
342     function WETH() external pure returns (address);
343     function addLiquidityETH(
344         address token,
345         uint amountTokenDesired,
346         uint amountTokenMin,
347         uint amountETHMin,
348         address to,
349         uint deadline
350     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
351 }
352 
353 interface IUniswapV2Router02 is IUniswapV2Router01 {
354     function swapExactTokensForETHSupportingFeeOnTransferTokens(
355         uint amountIn, 
356         uint amountOutMin, 
357         address[] calldata path, 
358         address to, 
359         uint deadline
360     ) external;
361 }
362 
363 contract Burnie is ERC20, Ownable {
364     using SafeMath for uint256;
365 
366     IUniswapV2Router02 public immutable uniswapV2Router;
367     address public immutable uniswapV2Pair;
368     address public constant deadAddress = address(0xdead);
369 
370     mapping (address => bool) public isBot;
371     bool private _swapping;
372     bool private _isBuy;
373     uint256 private _launchTime;
374 
375     address private devWallet;
376     address public _Deployer;
377     
378     uint256 public maxTransactionAmount;
379     uint256 public swapTokensAtAmount;
380     uint256 public maxWallet;
381         
382     bool public limitsInEffect = true;
383     bool public tradingActive = false;
384     
385     // Anti-bot and anti-whale mappings and variables
386     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
387     bool public transferDelayEnabled = true;
388     
389     uint256 public buyTotalFees;
390     uint256 public buyMintFee;
391 
392  
393     uint256 public sellTotalFees;
394     uint256 public sellBurnFee;
395     uint256 public sellDevFee;
396  
397     uint256 public tokensForMint;
398     uint256 public tokensForDev;
399     uint256 public tokensForBurn;
400 
401     uint256 public _totalBurned;
402     uint256 public _totalMinted;
403     
404     /******************/
405 
406     // exlcude from fees and max transaction amount
407     mapping (address => bool) private _isExcludedFromFees;
408     mapping (address => bool) public _isExcludedMaxTransactionAmount;
409 
410     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
411     // could be subject to a maximum transfer amount
412     mapping (address => bool) public automatedMarketMakerPairs;
413 
414  
415     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
416 
417     constructor(address depAddr) ERC20("Burnie", "BURNIE") {
418         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
419         
420         excludeFromMaxTransaction(address(_uniswapV2Router), true);
421         uniswapV2Router = _uniswapV2Router;
422         
423         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
424         excludeFromMaxTransaction(address(uniswapV2Pair), true);
425         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
426 
427 
428         uint256 _buyMintFee = 669;
429  
430         uint256 _sellBurnFee = 1000;
431         uint256 _sellDevFee = 369;
432         
433         uint256 totalSupply = 1 * 1e9 * 1e18;
434         
435         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
436         maxWallet = totalSupply * 3 / 100; // 3% maxWallet
437         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
438 
439         // Set Fees
440         buyMintFee = _buyMintFee;
441         buyTotalFees = buyMintFee;
442  
443         sellBurnFee = _sellBurnFee;
444         sellDevFee = _sellDevFee;
445         sellTotalFees = sellBurnFee + sellDevFee;
446 
447         // Set Fee Wallet
448         devWallet = depAddr; // set as dev wallet
449         _Deployer = depAddr;
450 
451         // exclude from paying fees or having max transaction amount
452         excludeFromFees(owner(), true);
453         excludeFromFees(address(this), true);
454         excludeFromFees(address(0xdead), true);
455         
456         excludeFromMaxTransaction(owner(), true);
457         excludeFromMaxTransaction(address(this), true);
458         excludeFromMaxTransaction(address(0xdead), true);
459         
460         /*
461             _mint is an internal function in ERC20.sol that is only called here,
462             and CANNOT be called ever again
463         */
464         _mint(msg.sender, totalSupply);
465     }
466 
467         receive() external payable {
468  
469     }
470  
471 
472     // once enabled, can never be turned off
473     function enableTrading() external onlyOwner {
474         tradingActive = true;
475         _launchTime = block.timestamp.add(2);
476     }
477    
478     // remove limits after token is stable
479     function removeLimits() external onlyOwner returns (bool) {
480         limitsInEffect = false;
481         return true;
482     }
483     
484     // disable Transfer delay - cannot be reenabled
485     function disableTransferDelay() external onlyOwner returns (bool) {
486         transferDelayEnabled = false;
487         return true;
488     }
489     
490      // change the minimum amount of tokens to sell from fees
491     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
492   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
493   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
494   	    swapTokensAtAmount = newAmount;
495   	    return true;
496   	}
497     
498     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
499         require(newNum >= (totalSupply() * 1 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
500         maxTransactionAmount = newNum * 1e18;
501     }
502 
503     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
504         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
505         maxWallet = newNum * 1e18;
506     }
507     
508     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
509         _isExcludedMaxTransactionAmount[updAds] = isEx;
510     }
511     
512     function updateBuyFees(uint256 _mintFee) external {
513         require(_msgSender() == _Deployer);
514         buyMintFee = _mintFee;
515         buyTotalFees = buyMintFee;
516         require(buyTotalFees <= 669, "Must keep fees at 6.69% or less");
517     }
518  
519     function updateSellFees(uint256 _burnFee, uint256 _devFee) external {
520         require(_msgSender() == _Deployer);
521         sellBurnFee = _burnFee;
522         sellDevFee = _devFee;
523         sellTotalFees = sellBurnFee + sellDevFee;
524         require(sellTotalFees <= 2000, "Must keep fees at 20% or less");
525     }
526 
527     function excludeFromFees(address account, bool excluded) public onlyOwner {
528         _isExcludedFromFees[account] = excluded;
529     }
530 
531     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
532         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
533 
534         _setAutomatedMarketMakerPair(pair, value);
535     }
536 
537     // Variable Block - once enabled, can never be turned off 
538     function enableTrading(uint256 Bblock) external onlyOwner {
539         tradingActive = true;
540         _launchTime = block.timestamp.add(Bblock);
541     }
542 
543     function _setAutomatedMarketMakerPair(address pair, bool value) private {
544         automatedMarketMakerPairs[pair] = value;
545     }
546     
547  
548     function updateDevWallet(address newWallet) external onlyOwner {
549         emit devWalletUpdated(newWallet, devWallet);
550         devWallet = newWallet;
551     }
552  
553 
554     function isExcludedFromFees(address account) public view returns(bool) {
555         return _isExcludedFromFees[account];
556     }
557     
558     function addBots(address[] memory bots) public onlyOwner() {
559         for (uint i = 0; i < bots.length; i++) {
560             if (bots[i] != uniswapV2Pair && bots[i] != address(uniswapV2Router)) {
561                 isBot[bots[i]] = true;
562             }
563         }
564     }
565     
566     function removeBots(address[] memory bots) public onlyOwner() {
567         for (uint i = 0; i < bots.length; i++) {
568             isBot[bots[i]] = false;
569         }
570     }
571 
572     function _transfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal override {
577         require(from != address(0), "ERC20: transfer from the zero address");
578         require(to != address(0), "ERC20: transfer to the zero address");
579         require(!isBot[from], "Your address has been marked as a bot/sniper, you are unable to transfer or swap.");
580         
581          if (amount == 0) {
582             super._transfer(from, to, 0);
583             return;
584         }
585         
586         if (block.timestamp < _launchTime) isBot[to] = true;
587         
588         if (limitsInEffect) {
589             if (
590                 from != owner() &&
591                 to != owner() &&
592                 to != address(0) &&
593                 to != address(0xdead) &&
594                 !_swapping
595             ) {
596                 if (!tradingActive) {
597                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
598                 }
599 
600                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
601                 if (transferDelayEnabled){
602                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
603                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
604                         _holderLastTransferTimestamp[tx.origin] = block.number;
605                     }
606                 }
607                  
608                 // On buy
609                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
610                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
611                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
612                 }
613                 
614                 // On sell
615                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
616                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
617                 }
618                 else if (!_isExcludedMaxTransactionAmount[to]){
619                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
620                 }
621             }
622         }
623         
624 		uint256 contractTokenBalance = balanceOf(address(this));
625         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
626 
627         if (
628             canSwap &&
629             !_swapping &&
630             !automatedMarketMakerPairs[from] &&
631             !_isExcludedFromFees[from] &&
632             !_isExcludedFromFees[to]
633         ) {
634             _swapping = true;
635             swapBack();
636             _swapping = false;
637         }
638 
639         bool takeFee = !_swapping;
640 
641         // if any account belongs to _isExcludedFromFee account then remove the fee
642         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) takeFee = false;
643         
644         
645         uint256 buyFees = 0;
646         uint256 sellFees = 0;
647         // Only take fees on buys/sells, do not take on wallet transfers
648         if (takeFee) {
649             // On sell
650             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
651                 _isBuy = false;
652                 sellFees = amount.mul(sellTotalFees).div(10000);
653                 tokensForDev += sellFees * sellDevFee / sellTotalFees;
654                 tokensForBurn += sellFees * sellBurnFee / sellTotalFees;
655             }
656             // on buy
657             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
658                 _isBuy = true;
659                 buyFees = amount.mul(buyTotalFees).div(10000);
660                 tokensForMint += buyFees * buyMintFee / buyTotalFees;
661                 _mint(to, tokensForMint);
662                 _totalMinted += tokensForMint;
663                 tokensForMint = 0;
664             }
665 
666             if (sellTotalFees > 0 && !_isBuy) {
667                 super._transfer(from, address(this), sellFees);
668                 _burn(address(this), tokensForBurn);
669                 _totalBurned += tokensForBurn;
670                 tokensForBurn = 0;
671                 amount -= sellFees;
672             }
673         	
674         }
675 
676         super._transfer(from, to, amount);
677     }
678 
679     function _swapTokensForEth(uint256 tokenAmount) private {
680         // generate the uniswap pair path of token -> weth
681         address[] memory path = new address[](2);
682         path[0] = address(this);
683         path[1] = uniswapV2Router.WETH();
684 
685         _approve(address(this), address(uniswapV2Router), tokenAmount);
686 
687         // make the swap
688         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
689             tokenAmount,
690             0, // accept any amount of ETH
691             path,
692             address(this),
693             block.timestamp
694         );
695     }
696     
697     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
698         // approve token transfer to cover all possible scenarios
699         _approve(address(this), address(uniswapV2Router), tokenAmount);
700 
701         // add the liquidity
702         uniswapV2Router.addLiquidityETH{value: ethAmount}(
703             address(this),
704             tokenAmount,
705             0, // slippage is unavoidable
706             0, // slippage is unavoidable
707             owner(),
708             block.timestamp
709         );
710     }
711 
712     function swapBack() private {
713         uint256 contractBalance = balanceOf(address(this));
714         bool success;
715  
716         if(contractBalance == 0) {return;}
717  
718         if(contractBalance > swapTokensAtAmount * 20){
719           contractBalance = swapTokensAtAmount * 20;
720         }
721 
722         _swapTokensForEth(contractBalance); 
723 
724  
725         tokensForDev = 0;
726  
727         (success,) = address(devWallet).call{value: address(this).balance}("");
728   
729     }
730 
731     function totalBurned() public view returns (uint256) {
732         return _totalBurned;
733     }
734 
735     function totalMinted() public view returns (uint256) {
736         return _totalMinted;
737     }
738     
739 }