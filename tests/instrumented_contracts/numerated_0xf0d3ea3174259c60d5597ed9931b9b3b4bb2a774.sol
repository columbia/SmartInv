1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 https://t.me/officialthorneth
6 
7 
8 */
9 
10 pragma solidity 0.8.11;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 interface IUniswapV2Pair {
23     event Approval(address indexed owner, address indexed spender, uint value);
24     event Transfer(address indexed from, address indexed to, uint value);
25 
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32 
33     function approve(address spender, uint value) external returns (bool);
34     function transfer(address to, uint value) external returns (bool);
35     function transferFrom(address from, address to, uint value) external returns (bool);
36 
37     event Swap(
38         address indexed sender,
39         uint amount0In,
40         uint amount1In,
41         uint amount0Out,
42         uint amount1Out,
43         address indexed to
44     );
45     event Sync(uint112 reserve0, uint112 reserve1);
46 
47     function factory() external view returns (address);
48     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
49 }
50 
51 interface IUniswapV2Factory {
52     function createPair(address tokenA, address tokenB) external returns (address pair);
53 }
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66     
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 interface IERC20Metadata is IERC20 {
72     function name() external view returns (string memory);
73     function symbol() external view returns (string memory);
74     function decimals() external view returns (uint8);
75 }
76 
77 
78 contract ERC20 is Context, IERC20, IERC20Metadata {
79     mapping(address => uint256) private _balances;
80 
81     mapping(address => mapping(address => uint256)) private _allowances;
82 
83     uint256 private _totalSupply;
84 
85     string private _name;
86     string private _symbol;
87 
88     constructor(string memory name_, string memory symbol_) {
89         _name = name_;
90         _symbol = symbol_;
91     }
92 
93     function name() public view virtual override returns (string memory) {
94         return _name;
95     }
96 
97     function symbol() public view virtual override returns (string memory) {
98         return _symbol;
99     }
100 
101     function decimals() public view virtual override returns (uint8) {
102         return 18;
103     }
104 
105     function totalSupply() public view virtual override returns (uint256) {
106         return _totalSupply;
107     }
108 
109     function balanceOf(address account) public view virtual override returns (uint256) {
110         return _balances[account];
111     }
112 
113     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
114         _transfer(_msgSender(), recipient, amount);
115         return true;
116     }
117 
118     function allowance(address owner, address spender) public view virtual override returns (uint256) {
119         return _allowances[owner][spender];
120     }
121 
122     function approve(address spender, uint256 amount) public virtual override returns (bool) {
123         _approve(_msgSender(), spender, amount);
124         return true;
125     }
126 
127     function transferFrom(
128         address sender,
129         address recipient,
130         uint256 amount
131     ) public virtual override returns (bool) {
132         uint256 currentAllowance = _allowances[sender][_msgSender()];
133         if (currentAllowance != type(uint256).max) {
134             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
135             unchecked {
136                 _approve(sender, _msgSender(), currentAllowance - amount);
137             }
138         }
139 
140         _transfer(sender, recipient, amount);
141 
142         return true;
143     }
144 
145     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
146         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
147         return true;
148     }
149 
150     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
151         uint256 currentAllowance = _allowances[_msgSender()][spender];
152         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
153         unchecked {
154             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
155         }
156 
157         return true;
158     }
159 
160     function _transfer(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) internal virtual {
165         require(sender != address(0), "ERC20: transfer from the zero address");
166         require(recipient != address(0), "ERC20: transfer to the zero address");
167 
168         _beforeTokenTransfer(sender, recipient, amount);
169 
170         uint256 senderBalance = _balances[sender];
171         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
172         unchecked {
173             _balances[sender] = senderBalance - amount;
174         }
175         _balances[recipient] += amount;
176 
177         emit Transfer(sender, recipient, amount);
178 
179         _afterTokenTransfer(sender, recipient, amount);
180     }
181 
182     function _mint(address account, uint256 amount) internal virtual {
183         require(account != address(0), "ERC20: mint to the zero address");
184 
185         _beforeTokenTransfer(address(0), account, amount);
186 
187         _totalSupply += amount;
188         _balances[account] += amount;
189         emit Transfer(address(0), account, amount);
190 
191         _afterTokenTransfer(address(0), account, amount);
192     }
193 
194     function _burn(address account, uint256 amount) internal virtual {
195         require(account != address(0), "ERC20: burn from the zero address");
196 
197         _beforeTokenTransfer(account, address(0), amount);
198 
199         uint256 accountBalance = _balances[account];
200         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
201         unchecked {
202             _balances[account] = accountBalance - amount;
203         }
204         _totalSupply -= amount;
205 
206         emit Transfer(account, address(0), amount);
207 
208         _afterTokenTransfer(account, address(0), amount);
209     }
210 
211     function _approve(
212         address owner,
213         address spender,
214         uint256 amount
215     ) internal virtual {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218 
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _beforeTokenTransfer(
224         address from,
225         address to,
226         uint256 amount
227     ) internal virtual {}
228 
229     function _afterTokenTransfer(
230         address from,
231         address to,
232         uint256 amount
233     ) internal virtual {}
234 }
235 library SafeMath {
236     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             uint256 c = a + b;
239             if (c < a) return (false, 0);
240             return (true, c);
241         }
242     }
243 
244     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
245         unchecked {
246             if (b > a) return (false, 0);
247             return (true, a - b);
248         }
249     }
250 
251     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             if (a == 0) return (true, 0);
254             uint256 c = a * b;
255             if (c / a != b) return (false, 0);
256             return (true, c);
257         }
258     }
259 
260     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b == 0) return (false, 0);
263             return (true, a / b);
264         }
265     }
266 
267     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (b == 0) return (false, 0);
270             return (true, a % b);
271         }
272     }
273 
274     function add(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a + b;
276     }
277 
278     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a - b;
280     }
281 
282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a * b;
284     }
285 
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         return a / b;
288     }
289 
290     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a % b;
292     }
293 
294     function sub(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
295         unchecked {
296             require(b <= a, errorMessage);
297             return a - b;
298         }
299     }
300 
301     function div(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a / b;
305         }
306     }
307 
308     function mod(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
309         unchecked {
310             require(b > 0, errorMessage);
311             return a % b;
312         }
313     }
314 }
315 
316 abstract contract Ownable is Context {
317     address private _owner;
318 
319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
320 
321     constructor() {
322         _transferOwnership(_msgSender());
323     }
324 
325     function owner() public view virtual returns (address) {
326         return _owner;
327     }
328 
329     modifier onlyOwner() {
330         require(owner() == _msgSender(), "Ownable: caller is not the owner");
331         _;
332     }
333 
334     function renounceOwnership() public virtual onlyOwner {
335         _transferOwnership(address(0));
336     }
337 
338     function transferOwnership(address newOwner) public virtual onlyOwner {
339         require(newOwner != address(0), "Ownable: new owner is the zero address");
340         _transferOwnership(newOwner);
341     }
342 
343     function _transferOwnership(address newOwner) internal virtual {
344         address oldOwner = _owner;
345         _owner = newOwner;
346         emit OwnershipTransferred(oldOwner, newOwner);
347     }
348 }
349 
350 interface IUniswapV2Router01 {
351     function factory() external pure returns (address);
352     function WETH() external pure returns (address);
353     function addLiquidityETH(
354         address token,
355         uint amountTokenDesired,
356         uint amountTokenMin,
357         uint amountETHMin,
358         address to,
359         uint deadline
360     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
361 }
362 
363 interface IUniswapV2Router02 is IUniswapV2Router01 {
364     function swapExactTokensForETHSupportingFeeOnTransferTokens(
365         uint amountIn, 
366         uint amountOutMin, 
367         address[] calldata path, 
368         address to, 
369         uint deadline
370     ) external;
371 }
372 
373 contract thorn is ERC20, Ownable {
374     using SafeMath for uint256;
375 
376     IUniswapV2Router02 public immutable uniswapV2Router;
377     address public immutable uniswapV2Pair;
378 
379     mapping (address => bool) public isBot;
380     bool private _swapping;
381     uint256 private _launchTime;
382 
383     address private devWallet;
384     
385     uint256 public maxTransactionAmount;
386     uint256 public swapTokensAtAmount;
387     uint256 public maxWallet;
388         
389     bool public limitsInEffect = true;
390     bool public tradingActive = false;
391     
392     // Anti-bot and anti-whale mappings and variables
393     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
394     bool public transferDelayEnabled = true;
395     
396     uint256 public buyTotalFees;
397     uint256 public buyLiquidityFee;
398     uint256 public buyDevFee;
399  
400     uint256 public sellTotalFees;
401     uint256 public sellLiquidityFee;
402     uint256 public sellDevFee;
403  
404     uint256 public tokensForLiquidity;
405     uint256 public tokensForDev;
406     
407     /******************/
408 
409     // exlcude from fees and max transaction amount
410     mapping (address => bool) private _isExcludedFromFees;
411     mapping (address => bool) public _isExcludedMaxTransactionAmount;
412 
413     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
414     // could be subject to a maximum transfer amount
415     mapping (address => bool) public automatedMarketMakerPairs;
416 
417     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
418     
419     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
420  
421     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
422 
423     constructor() ERC20("Thorn", "THORN") {
424         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
425         
426         excludeFromMaxTransaction(address(_uniswapV2Router), true);
427         uniswapV2Router = _uniswapV2Router;
428         
429         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
430         excludeFromMaxTransaction(address(uniswapV2Pair), true);
431         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
432 
433 
434         uint256 _buyLiquidityFee = 3;
435         uint256 _buyDevFee = 12;
436  
437         uint256 _sellLiquidityFee = 10;
438         uint256 _sellDevFee = 25;
439         
440         uint256 totalSupply = 1 * 1e7 * 1e18;
441         
442         maxTransactionAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
443         maxWallet = totalSupply * 2 / 100; // 1% maxWallet
444         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
445 
446         // Set Fees
447         buyLiquidityFee = _buyLiquidityFee;
448         buyDevFee = _buyDevFee;
449         buyTotalFees = buyLiquidityFee + buyDevFee;
450  
451         sellLiquidityFee = _sellLiquidityFee;
452         sellDevFee = _sellDevFee;
453         sellTotalFees = sellLiquidityFee + sellDevFee;
454 
455         // Set Fee Wallet
456         devWallet = address(owner()); // set as dev wallet
457 
458 
459         // exclude from paying fees or having max transaction amount
460         excludeFromFees(owner(), true);
461         excludeFromFees(address(this), true);
462         excludeFromFees(address(0xdead), true);
463         
464         excludeFromMaxTransaction(owner(), true);
465         excludeFromMaxTransaction(address(this), true);
466         excludeFromMaxTransaction(address(0xdead), true);
467         
468         /*
469             _mint is an internal function in ERC20.sol that is only called here,
470             and CANNOT be called ever again
471         */
472         _mint(msg.sender, totalSupply);
473     }
474 
475         receive() external payable {
476  
477     }
478  
479 
480     // once enabled, can never be turned off
481     function enableTrading() external onlyOwner {
482         tradingActive = true;
483         _launchTime = block.timestamp.add(2);
484     }
485    
486     // remove limits after token is stable
487     function removeLimits() external onlyOwner returns (bool) {
488         limitsInEffect = false;
489         return true;
490     }
491     
492     // disable Transfer delay - cannot be reenabled
493     function disableTransferDelay() external onlyOwner returns (bool) {
494         transferDelayEnabled = false;
495         return true;
496     }
497     
498      // change the minimum amount of tokens to sell from fees
499     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
500   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
501   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
502   	    swapTokensAtAmount = newAmount;
503   	    return true;
504   	}
505     
506     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
507         require(newNum >= (totalSupply() * 1 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
508         maxTransactionAmount = newNum * 1e18;
509     }
510 
511     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
512         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
513         maxWallet = newNum * 1e18;
514     }
515     
516     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
517         _isExcludedMaxTransactionAmount[updAds] = isEx;
518     }
519     
520     function updateBuyFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
521         buyLiquidityFee = _liquidityFee;
522         buyDevFee = _devFee;
523         buyTotalFees = buyLiquidityFee + buyDevFee;
524         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
525     }
526  
527     function updateSellFees(uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
528         sellLiquidityFee = _liquidityFee;
529         sellDevFee = _devFee;
530         sellTotalFees = sellLiquidityFee + sellDevFee;
531         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
532     }
533 
534     function excludeFromFees(address account, bool excluded) public onlyOwner {
535         _isExcludedFromFees[account] = excluded;
536     }
537 
538     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
539         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
540 
541         _setAutomatedMarketMakerPair(pair, value);
542     }
543 
544     // Variable Block - once enabled, can never be turned off 
545     function enableTrading(uint256 Bblock) external onlyOwner {
546         tradingActive = true;
547         _launchTime = block.timestamp.add(Bblock);
548     }
549 
550     function _setAutomatedMarketMakerPair(address pair, bool value) private {
551         automatedMarketMakerPairs[pair] = value;
552     }
553     
554 
555     function updateDevWallet(address newWallet) external onlyOwner {
556         emit devWalletUpdated(newWallet, devWallet);
557         devWallet = newWallet;
558     }
559  
560 
561     function isExcludedFromFees(address account) public view returns(bool) {
562         return _isExcludedFromFees[account];
563     }
564     
565     function addBots(address[] memory bots) public onlyOwner() {
566         for (uint i = 0; i < bots.length; i++) {
567             if (bots[i] != uniswapV2Pair && bots[i] != address(uniswapV2Router)) {
568                 isBot[bots[i]] = true;
569             }
570         }
571     }
572     
573     function removeBots(address[] memory bots) public onlyOwner() {
574         for (uint i = 0; i < bots.length; i++) {
575             isBot[bots[i]] = false;
576         }
577     }
578 
579     function _transfer(
580         address from,
581         address to,
582         uint256 amount
583     ) internal override {
584         require(from != address(0), "ERC20: transfer from the zero address");
585         require(to != address(0), "ERC20: transfer to the zero address");
586         require(!isBot[from], "Your address has been marked as a bot/sniper, you are unable to transfer or swap.");
587         
588          if (amount == 0) {
589             super._transfer(from, to, 0);
590             return;
591         }
592         
593         if (block.timestamp < _launchTime) isBot[to] = true;
594         
595         if (limitsInEffect) {
596             if (
597                 from != owner() &&
598                 to != owner() &&
599                 to != address(0) &&
600                 to != address(0xdead) &&
601                 !_swapping
602             ) {
603                 if (!tradingActive) {
604                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
605                 }
606 
607                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
608                 if (transferDelayEnabled){
609                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
610                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
611                         _holderLastTransferTimestamp[tx.origin] = block.number;
612                     }
613                 }
614                  
615                 // On buy
616                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
617                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
618                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
619                 }
620                 
621                 // On sell
622                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
623                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
624                 }
625                 else if (!_isExcludedMaxTransactionAmount[to]){
626                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
627                 }
628             }
629         }
630         
631 		uint256 contractTokenBalance = balanceOf(address(this));
632         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
633 
634         if (
635             canSwap &&
636             !_swapping &&
637             !automatedMarketMakerPairs[from] &&
638             !_isExcludedFromFees[from] &&
639             !_isExcludedFromFees[to]
640         ) {
641             _swapping = true;
642             swapBack();
643             _swapping = false;
644         }
645 
646         bool takeFee = !_swapping;
647 
648         // if any account belongs to _isExcludedFromFee account then remove the fee
649         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) takeFee = false;
650         
651         
652         uint256 fees = 0;
653         // Only take fees on buys/sells, do not take on wallet transfers
654         if (takeFee) {
655             // On sell
656             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
657                 fees = amount.mul(sellTotalFees).div(100);
658                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
659                 tokensForDev += fees * sellDevFee / sellTotalFees;
660             }
661             // on buy
662             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
663                 fees = amount.mul(buyTotalFees).div(100);
664                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
665                 tokensForDev += fees * buyDevFee / buyTotalFees;
666             }
667 
668             if (fees > 0) {
669                 super._transfer(from, address(this), fees);
670             }
671         	
672         	amount -= fees;
673         }
674 
675         super._transfer(from, to, amount);
676     }
677 
678     function _swapTokensForEth(uint256 tokenAmount) private {
679         // generate the uniswap pair path of token -> weth
680         address[] memory path = new address[](2);
681         path[0] = address(this);
682         path[1] = uniswapV2Router.WETH();
683 
684         _approve(address(this), address(uniswapV2Router), tokenAmount);
685 
686         // make the swap
687         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
688             tokenAmount,
689             0, // accept any amount of ETH
690             path,
691             address(this),
692             block.timestamp
693         );
694     }
695     
696     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
697         // approve token transfer to cover all possible scenarios
698         _approve(address(this), address(uniswapV2Router), tokenAmount);
699 
700         // add the liquidity
701         uniswapV2Router.addLiquidityETH{value: ethAmount}(
702             address(this),
703             tokenAmount,
704             0, // slippage is unavoidable
705             0, // slippage is unavoidable
706             owner(),
707             block.timestamp
708         );
709     }
710 
711     function swapBack() private {
712         uint256 contractBalance = balanceOf(address(this));
713         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
714         bool success;
715  
716         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
717  
718         if(contractBalance > swapTokensAtAmount * 20){
719           contractBalance = swapTokensAtAmount * 20;
720         }
721  
722         // Halve the amount of liquidity tokens
723         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
724         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
725  
726         uint256 initialETHBalance = address(this).balance;
727  
728         _swapTokensForEth(amountToSwapForETH); 
729  
730         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
731  
732         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
733         uint256 ethForLiquidity = ethBalance - ethForDev;
734  
735  
736         tokensForLiquidity = 0;
737         tokensForDev = 0;
738  
739         (success,) = address(devWallet).call{value: ethForDev}("");
740  
741         if(liquidityTokens > 0 && ethForLiquidity > 0){
742             _addLiquidity(liquidityTokens, ethForLiquidity);
743             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
744         }
745     }
746 }