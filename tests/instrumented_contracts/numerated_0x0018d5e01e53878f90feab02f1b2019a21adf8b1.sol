1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 pragma solidity 0.8.11;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 interface IUniswapV2Pair {
18     event Approval(address indexed owner, address indexed spender, uint value);
19     event Transfer(address indexed from, address indexed to, uint value);
20 
21     function name() external pure returns (string memory);
22     function symbol() external pure returns (string memory);
23     function decimals() external pure returns (uint8);
24     function totalSupply() external view returns (uint);
25     function balanceOf(address owner) external view returns (uint);
26     function allowance(address owner, address spender) external view returns (uint);
27 
28     function approve(address spender, uint value) external returns (bool);
29     function transfer(address to, uint value) external returns (bool);
30     function transferFrom(address from, address to, uint value) external returns (bool);
31 
32     event Swap(
33         address indexed sender,
34         uint amount0In,
35         uint amount1In,
36         uint amount0Out,
37         uint amount1Out,
38         address indexed to
39     );
40     event Sync(uint112 reserve0, uint112 reserve1);
41 
42     function factory() external view returns (address);
43     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
44 }
45 
46 interface IUniswapV2Factory {
47     function createPair(address tokenA, address tokenB) external returns (address pair);
48 }
49 
50 interface IERC20 {
51     function totalSupply() external view returns (uint256);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(
57         address sender,
58         address recipient,
59         uint256 amount
60     ) external returns (bool);
61     
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 interface IERC20Metadata is IERC20 {
67     function name() external view returns (string memory);
68     function symbol() external view returns (string memory);
69     function decimals() external view returns (uint8);
70 }
71 
72 
73 contract ERC20 is Context, IERC20, IERC20Metadata {
74     mapping(address => uint256) private _balances;
75 
76     mapping(address => mapping(address => uint256)) private _allowances;
77 
78     uint256 private _totalSupply;
79 
80     string private _name;
81     string private _symbol;
82 
83     constructor(string memory name_, string memory symbol_) {
84         _name = name_;
85         _symbol = symbol_;
86     }
87 
88     function name() public view virtual override returns (string memory) {
89         return _name;
90     }
91 
92     function symbol() public view virtual override returns (string memory) {
93         return _symbol;
94     }
95 
96     function decimals() public view virtual override returns (uint8) {
97         return 18;
98     }
99 
100     function totalSupply() public view virtual override returns (uint256) {
101         return _totalSupply;
102     }
103 
104     function balanceOf(address account) public view virtual override returns (uint256) {
105         return _balances[account];
106     }
107 
108     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
109         _transfer(_msgSender(), recipient, amount);
110         return true;
111     }
112 
113     function allowance(address owner, address spender) public view virtual override returns (uint256) {
114         return _allowances[owner][spender];
115     }
116 
117     function approve(address spender, uint256 amount) public virtual override returns (bool) {
118         _approve(_msgSender(), spender, amount);
119         return true;
120     }
121 
122     function transferFrom(
123         address sender,
124         address recipient,
125         uint256 amount
126     ) public virtual override returns (bool) {
127         uint256 currentAllowance = _allowances[sender][_msgSender()];
128         if (currentAllowance != type(uint256).max) {
129             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
130             unchecked {
131                 _approve(sender, _msgSender(), currentAllowance - amount);
132             }
133         }
134 
135         _transfer(sender, recipient, amount);
136 
137         return true;
138     }
139 
140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
142         return true;
143     }
144 
145     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
146         uint256 currentAllowance = _allowances[_msgSender()][spender];
147         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
148         unchecked {
149             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
150         }
151 
152         return true;
153     }
154 
155     function _transfer(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) internal virtual {
160         require(sender != address(0), "ERC20: transfer from the zero address");
161         require(recipient != address(0), "ERC20: transfer to the zero address");
162 
163         _beforeTokenTransfer(sender, recipient, amount);
164 
165         uint256 senderBalance = _balances[sender];
166         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
167         unchecked {
168             _balances[sender] = senderBalance - amount;
169         }
170         _balances[recipient] += amount;
171 
172         emit Transfer(sender, recipient, amount);
173 
174         _afterTokenTransfer(sender, recipient, amount);
175     }
176 
177     function _mint(address account, uint256 amount) internal virtual {
178         require(account != address(0), "ERC20: mint to the zero address");
179 
180         _beforeTokenTransfer(address(0), account, amount);
181 
182         _totalSupply += amount;
183         _balances[account] += amount;
184         emit Transfer(address(0), account, amount);
185 
186         _afterTokenTransfer(address(0), account, amount);
187     }
188 
189     function _burn(address account, uint256 amount) internal virtual {
190         require(account != address(0), "ERC20: burn from the zero address");
191 
192         _beforeTokenTransfer(account, address(0), amount);
193 
194         uint256 accountBalance = _balances[account];
195         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
196         unchecked {
197             _balances[account] = accountBalance - amount;
198         }
199         _totalSupply -= amount;
200 
201         emit Transfer(account, address(0), amount);
202 
203         _afterTokenTransfer(account, address(0), amount);
204     }
205 
206     function _approve(
207         address owner,
208         address spender,
209         uint256 amount
210     ) internal virtual {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213 
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _beforeTokenTransfer(
219         address from,
220         address to,
221         uint256 amount
222     ) internal virtual {}
223 
224     function _afterTokenTransfer(
225         address from,
226         address to,
227         uint256 amount
228     ) internal virtual {}
229 }
230 library SafeMath {
231     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         unchecked {
233             uint256 c = a + b;
234             if (c < a) return (false, 0);
235             return (true, c);
236         }
237     }
238 
239     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             if (b > a) return (false, 0);
242             return (true, a - b);
243         }
244     }
245 
246     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         unchecked {
248             if (a == 0) return (true, 0);
249             uint256 c = a * b;
250             if (c / a != b) return (false, 0);
251             return (true, c);
252         }
253     }
254 
255     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b == 0) return (false, 0);
258             return (true, a / b);
259         }
260     }
261 
262     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             if (b == 0) return (false, 0);
265             return (true, a % b);
266         }
267     }
268 
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a + b;
271     }
272 
273     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
274         return a - b;
275     }
276 
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         return a * b;
279     }
280 
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a / b;
283     }
284 
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a % b;
287     }
288 
289     function sub(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
290         unchecked {
291             require(b <= a, errorMessage);
292             return a - b;
293         }
294     }
295 
296     function div(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
297         unchecked {
298             require(b > 0, errorMessage);
299             return a / b;
300         }
301     }
302 
303     function mod(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
304         unchecked {
305             require(b > 0, errorMessage);
306             return a % b;
307         }
308     }
309 }
310 
311 abstract contract Ownable is Context {
312     address private _owner;
313 
314     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
315 
316     constructor() {
317         _transferOwnership(_msgSender());
318     }
319 
320     function owner() public view virtual returns (address) {
321         return _owner;
322     }
323 
324     modifier onlyOwner() {
325         require(owner() == _msgSender(), "Ownable: caller is not the owner");
326         _;
327     }
328 
329     function renounceOwnership() public virtual onlyOwner {
330         _transferOwnership(address(0));
331     }
332 
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         _transferOwnership(newOwner);
336     }
337 
338     function _transferOwnership(address newOwner) internal virtual {
339         address oldOwner = _owner;
340         _owner = newOwner;
341         emit OwnershipTransferred(oldOwner, newOwner);
342     }
343 }
344 
345 interface IUniswapV2Router01 {
346     function factory() external pure returns (address);
347     function WETH() external pure returns (address);
348     function addLiquidityETH(
349         address token,
350         uint amountTokenDesired,
351         uint amountTokenMin,
352         uint amountETHMin,
353         address to,
354         uint deadline
355     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
356 }
357 
358 interface IUniswapV2Router02 is IUniswapV2Router01 {
359     function swapExactTokensForETHSupportingFeeOnTransferTokens(
360         uint amountIn, 
361         uint amountOutMin, 
362         address[] calldata path, 
363         address to, 
364         uint deadline
365     ) external;
366 }
367 
368 contract shadowcats is ERC20, Ownable {
369     using SafeMath for uint256;
370 
371     IUniswapV2Router02 public immutable uniswapV2Router;
372     address public immutable uniswapV2Pair;
373 
374     mapping (address => bool) public isBot;
375     bool private _swapping;
376     uint256 private _launchTime;
377 
378     address private devWallet;
379     
380     uint256 public maxTransactionAmount;
381     uint256 public swapTokensAtAmount;
382     uint256 public maxWallet;
383         
384     bool public limitsInEffect = true;
385     bool public tradingActive = false;
386     
387     // Anti-bot and anti-whale mappings and variables
388     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
389     bool public transferDelayEnabled = true;
390     
391     uint256 public buyTotalFees;
392     uint256 public buyDevFee;
393  
394     uint256 public sellTotalFees;
395     uint256 public sellDevFee;
396  
397     uint256 public tokensForDev;
398     
399     /******************/
400 
401     // exlcude from fees and max transaction amount
402     mapping (address => bool) private _isExcludedFromFees;
403     mapping (address => bool) public _isExcludedMaxTransactionAmount;
404 
405     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
406     // could be subject to a maximum transfer amount
407     mapping (address => bool) public automatedMarketMakerPairs;
408 
409     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
410     
411     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
412  
413     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
414 
415     constructor() ERC20("Shadowcats", "SHADOWCATS") {
416         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
417         
418         excludeFromMaxTransaction(address(_uniswapV2Router), true);
419         uniswapV2Router = _uniswapV2Router;
420         
421         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
422         excludeFromMaxTransaction(address(uniswapV2Pair), true);
423         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
424 
425 
426 
427         uint256 _buyDevFee = 5;
428  
429         uint256 _sellDevFee = 25;
430         
431         uint256 totalSupply = 1 * 1e6 * 1e18;
432         
433         maxTransactionAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
434         maxWallet = totalSupply * 2 / 100; // 1% maxWallet
435         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
436 
437         // Set Fees
438         buyDevFee = _buyDevFee;
439         buyTotalFees =  buyDevFee;
440 
441         sellDevFee = _sellDevFee;
442         sellTotalFees = sellDevFee;
443 
444         // Set Fee Wallet
445         devWallet = address(owner()); // set as dev wallet
446 
447 
448         // exclude from paying fees or having max transaction amount
449         excludeFromFees(owner(), true);
450         excludeFromFees(address(this), true);
451         excludeFromFees(address(0xdead), true);
452         
453         excludeFromMaxTransaction(owner(), true);
454         excludeFromMaxTransaction(address(this), true);
455         excludeFromMaxTransaction(address(0xdead), true);
456         
457         /*
458             _mint is an internal function in ERC20.sol that is only called here,
459             and CANNOT be called ever again
460         */
461         _mint(msg.sender, totalSupply);
462     }
463 
464         receive() external payable {
465  
466     }
467  
468 
469     // once enabled, can never be turned off
470     function enableTrading() external onlyOwner {
471         tradingActive = true;
472         _launchTime = block.timestamp.add(2);
473     }
474    
475     // remove limits after token is stable
476     function removeLimits() external onlyOwner returns (bool) {
477         limitsInEffect = false;
478         return true;
479     }
480     
481     // disable Transfer delay - cannot be reenabled
482     function disableTransferDelay() external onlyOwner returns (bool) {
483         transferDelayEnabled = false;
484         return true;
485     }
486     
487      // change the minimum amount of tokens to sell from fees
488     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
489   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
490   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
491   	    swapTokensAtAmount = newAmount;
492   	    return true;
493   	}
494     
495     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
496         require(newNum >= (totalSupply() * 1 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
497         maxTransactionAmount = newNum * 1e18;
498     }
499 
500     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
501         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
502         maxWallet = newNum * 1e18;
503     }
504     
505     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
506         _isExcludedMaxTransactionAmount[updAds] = isEx;
507     }
508     
509     function updateBuyFees(uint256 _devFee) external onlyOwner {
510         buyDevFee = _devFee;
511         buyTotalFees = buyDevFee;
512         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
513     }
514  
515     function updateSellFees(uint256 _devFee) external onlyOwner {
516         sellDevFee = _devFee;
517         sellTotalFees = sellDevFee;
518         require(sellTotalFees <= 25, "Must keep fees at 15% or less");
519     }
520 
521     function excludeFromFees(address account, bool excluded) public onlyOwner {
522         _isExcludedFromFees[account] = excluded;
523     }
524 
525     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
526         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
527 
528         _setAutomatedMarketMakerPair(pair, value);
529     }
530 
531     // Variable Block - once enabled, can never be turned off 
532     function enableTrading(uint256 Bblock) external onlyOwner {
533         tradingActive = true;
534         _launchTime = block.timestamp.add(Bblock);
535     }
536 
537     function _setAutomatedMarketMakerPair(address pair, bool value) private {
538         automatedMarketMakerPairs[pair] = value;
539     }
540     
541 
542     function updateDevWallet(address newWallet) external onlyOwner {
543         emit devWalletUpdated(newWallet, devWallet);
544         devWallet = newWallet;
545     }
546  
547 
548     function isExcludedFromFees(address account) public view returns(bool) {
549         return _isExcludedFromFees[account];
550     }
551     
552     function addBots(address[] memory bots) public onlyOwner() {
553         for (uint i = 0; i < bots.length; i++) {
554             if (bots[i] != uniswapV2Pair && bots[i] != address(uniswapV2Router)) {
555                 isBot[bots[i]] = true;
556             }
557         }
558     }
559     
560     function removeBots(address[] memory bots) public onlyOwner() {
561         for (uint i = 0; i < bots.length; i++) {
562             isBot[bots[i]] = false;
563         }
564     }
565 
566     function _transfer(
567         address from,
568         address to,
569         uint256 amount
570     ) internal override {
571         require(from != address(0), "ERC20: transfer from the zero address");
572         require(to != address(0), "ERC20: transfer to the zero address");
573         require(!isBot[from], "Your address has been marked as a bot/sniper, you are unable to transfer or swap.");
574         
575          if (amount == 0) {
576             super._transfer(from, to, 0);
577             return;
578         }
579         
580         if (block.timestamp < _launchTime) isBot[to] = true;
581         
582         if (limitsInEffect) {
583             if (
584                 from != owner() &&
585                 to != owner() &&
586                 to != address(0) &&
587                 to != address(0xdead) &&
588                 !_swapping
589             ) {
590                 if (!tradingActive) {
591                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
592                 }
593 
594                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
595                 if (transferDelayEnabled){
596                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
597                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
598                         _holderLastTransferTimestamp[tx.origin] = block.number;
599                     }
600                 }
601                  
602                 // On buy
603                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
604                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
605                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
606                 }
607                 
608                 // On sell
609                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
610                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
611                 }
612                 else if (!_isExcludedMaxTransactionAmount[to]){
613                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
614                 }
615             }
616         }
617         
618 		uint256 contractTokenBalance = balanceOf(address(this));
619         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
620 
621         if (
622             canSwap &&
623             !_swapping &&
624             !automatedMarketMakerPairs[from] &&
625             !_isExcludedFromFees[from] &&
626             !_isExcludedFromFees[to]
627         ) {
628             _swapping = true;
629             swapBack();
630             _swapping = false;
631         }
632 
633         bool takeFee = !_swapping;
634 
635         // if any account belongs to _isExcludedFromFee account then remove the fee
636         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) takeFee = false;
637         
638         
639         uint256 fees = 0;
640         // Only take fees on buys/sells, do not take on wallet transfers
641         if (takeFee) {
642             // On sell
643             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
644                 fees = amount.mul(sellTotalFees).div(100);
645                 tokensForDev += fees * sellDevFee / sellTotalFees;
646             }
647             // on buy
648             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
649                 fees = amount.mul(buyTotalFees).div(100);
650                 tokensForDev += fees * buyDevFee / buyTotalFees;
651             }
652 
653             if (fees > 0) {
654                 super._transfer(from, address(this), fees);
655             }
656         	
657         	amount -= fees;
658         }
659 
660         super._transfer(from, to, amount);
661     }
662 
663     function _swapTokensForEth(uint256 tokenAmount) private {
664         // generate the uniswap pair path of token -> weth
665         address[] memory path = new address[](2);
666         path[0] = address(this);
667         path[1] = uniswapV2Router.WETH();
668 
669         _approve(address(this), address(uniswapV2Router), tokenAmount);
670 
671         // make the swap
672         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
673             tokenAmount,
674             0, // accept any amount of ETH
675             path,
676             address(this),
677             block.timestamp
678         );
679     }
680     
681     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
682         // approve token transfer to cover all possible scenarios
683         _approve(address(this), address(uniswapV2Router), tokenAmount);
684 
685         // add the liquidity
686         uniswapV2Router.addLiquidityETH{value: ethAmount}(
687             address(this),
688             tokenAmount,
689             0, // slippage is unavoidable
690             0, // slippage is unavoidable
691             owner(),
692             block.timestamp
693         );
694     }
695 
696     function swapBack() private {
697         uint256 contractBalance = balanceOf(address(this));
698         uint256 totalTokensToSwap = tokensForDev;
699         bool success;
700  
701         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
702  
703         if(contractBalance > swapTokensAtAmount * 20){
704           contractBalance = swapTokensAtAmount * 20;
705         }
706  
707  
708         _swapTokensForEth(totalTokensToSwap); 
709  
710         uint256 ethBalance = address(this).balance;
711  
712  
713         tokensForDev = 0;
714  
715         (success,) = address(devWallet).call{value: ethBalance}("");
716  
717 
718     }
719 }