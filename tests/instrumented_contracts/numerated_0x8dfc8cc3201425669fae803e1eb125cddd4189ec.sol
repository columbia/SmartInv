1 /*
2 
3 An Old Warrior Returns To Guide Okage Inu To The Grand Temple. 
4 
5 Website: https://www.OkageInu.com
6 Telegram: T.me/OkageInu
7 
8 */
9 // SPDX-License-Identifier: MIT                                                                               
10                                                     
11 pragma solidity = 0.8.17;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IUniswapV2Pair {
25     function factory() external view returns (address);
26 }
27 
28 interface IUniswapV2Factory {
29     function createPair(address tokenA, address tokenB) external returns (address pair);
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface IERC20Metadata is IERC20 {
48     function name() external view returns (string memory);
49     function symbol() external view returns (string memory);
50     function decimals() external view returns (uint8);
51 }
52 
53 
54 contract ERC20 is Context, IERC20, IERC20Metadata {
55     using SafeMath for uint256;
56     mapping(address => uint256) private _balances;
57     mapping(address => mapping(address => uint256)) private _allowances;
58     uint256 private _totalSupply;
59     string private _name;
60     string private _symbol;
61     constructor(string memory name_, string memory symbol_) {
62         _name = name_;
63         _symbol = symbol_;
64     }
65     function name() public view virtual override returns (string memory) {return _name;}
66     function symbol() public view virtual override returns (string memory) {return _symbol;}
67     function decimals() public view virtual override returns (uint8) {return 18;}
68     function totalSupply() public view virtual override returns (uint256) {return _totalSupply;}
69     function balanceOf(address account) public view virtual override returns (uint256) {return _balances[account];}
70     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
71         _transfer(_msgSender(), recipient, amount);
72         return true;
73     }
74     function allowance(address owner, address spender) public view virtual override returns (uint256) {
75         return _allowances[owner][spender];
76     }
77     function approve(address spender, uint256 amount) public virtual override returns (bool) {
78         _approve(_msgSender(), spender, amount);
79         return true;
80     }
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) public virtual override returns (bool) {
86         _transfer(sender, recipient, amount);
87         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
88         return true;
89     }
90     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
91         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
92         return true;
93     }
94     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
95         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
96         return true;
97     }
98     function _transfer(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) internal virtual {
103         require(sender != address(0), "ERC20: transfer from the zero address");
104         require(recipient != address(0), "ERC20: transfer to the zero address");
105         _beforeTokenTransfer(sender, recipient, amount);
106         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
107         _balances[recipient] = _balances[recipient].add(amount);
108         emit Transfer(sender, recipient, amount);
109     }
110     function _mint(address account, uint256 amount) internal virtual {
111         require(account != address(0), "ERC20: mint to the zero address");
112         _beforeTokenTransfer(address(0), account, amount);
113         _totalSupply = _totalSupply.add(amount);
114         _balances[account] = _balances[account].add(amount);
115         emit Transfer(address(0), account, amount);
116     }
117     function _burn(address account, uint256 amount) internal virtual {
118         require(account != address(0), "ERC20: burn from the zero address");
119         _beforeTokenTransfer(account, address(0), amount);
120         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
121         _totalSupply = _totalSupply.sub(amount);
122         emit Transfer(account, address(0), amount);
123     }
124     function _approve(
125         address owner,
126         address spender,
127         uint256 amount
128     ) internal virtual {
129         require(owner != address(0), "ERC20: approve from the zero address");
130         require(spender != address(0), "ERC20: approve to the zero address");
131         _allowances[owner][spender] = amount;
132         emit Approval(owner, spender, amount);
133     }
134     function _beforeTokenTransfer(
135         address from,
136         address to,
137         uint256 amount
138     ) internal virtual {}
139 }
140 
141 library SafeMath {
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145         return c;
146     }
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b <= a, errorMessage);
152         uint256 c = a - b;
153         return c;
154     }
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         if (a == 0) {
157             return 0;
158         }
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161         return c;
162     }
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         return div(a, b, "SafeMath: division by zero");
165     }
166     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b > 0, errorMessage);
168         uint256 c = a / b;
169         return c;
170     }
171     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
172         return mod(a, b, "SafeMath: modulo by zero");
173     }
174     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b != 0, errorMessage);
176         return a % b;
177     }
178 }
179 
180 contract Ownable is Context {
181     address private _owner;
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183     constructor () {
184         address msgSender = _msgSender();
185         _owner = msgSender;
186         emit OwnershipTransferred(address(0), msgSender);
187     }
188     function owner() public view returns (address) {return _owner;}
189     modifier onlyOwner() {
190         require(_owner == _msgSender(), "Ownable: caller is not the owner");
191         _;
192     }
193     function renounceOwnership() public virtual onlyOwner {
194         emit OwnershipTransferred(_owner, address(0));
195         _owner = address(0);
196     }
197     function transferOwnership(address newOwner) public virtual onlyOwner {
198         require(newOwner != address(0), "Ownable: new owner is the zero address");
199         emit OwnershipTransferred(_owner, newOwner);
200         _owner = newOwner;
201     }
202 }
203 
204 
205 
206 library SafeMathInt {
207     int256 private constant MIN_INT256 = int256(1) << 255;
208     int256 private constant MAX_INT256 = ~(int256(1) << 255);
209     function mul(int256 a, int256 b) internal pure returns (int256) {
210         int256 c = a * b;
211         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
212         require((b == 0) || (c / b == a));
213         return c;
214     }
215     function div(int256 a, int256 b) internal pure returns (int256) {
216         require(b != -1 || a != MIN_INT256);
217         return a / b;
218     }
219     function sub(int256 a, int256 b) internal pure returns (int256) {
220         int256 c = a - b;
221         require((b >= 0 && c <= a) || (b < 0 && c > a));
222         return c;
223     }
224     function add(int256 a, int256 b) internal pure returns (int256) {
225         int256 c = a + b;
226         require((b >= 0 && c >= a) || (b < 0 && c < a));
227         return c;
228     }
229     function abs(int256 a) internal pure returns (int256) {
230         require(a != MIN_INT256);
231         return a < 0 ? -a : a;
232     }
233     function toUint256Safe(int256 a) internal pure returns (uint256) {
234         require(a >= 0);
235         return uint256(a);
236     }
237 }
238 
239 library SafeMathUint {
240   function toInt256Safe(uint256 a) internal pure returns (int256) {
241     int256 b = int256(a);
242     require(b >= 0);
243     return b;
244   }
245 }
246 
247 
248 interface IUniswapV2Router01 {
249     function factory() external pure returns (address);
250     function WETH() external pure returns (address);
251 
252     function addLiquidityETH(
253         address token,
254         uint amountTokenDesired,
255         uint amountTokenMin,
256         uint amountETHMin,
257         address to,
258         uint deadline
259     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
260 }
261 
262 interface IUniswapV2Router02 is IUniswapV2Router01 {
263     function swapExactTokensForETHSupportingFeeOnTransferTokens(
264         uint amountIn,
265         uint amountOutMin,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external;
270 }
271 
272 contract OKAGE is ERC20, Ownable {
273 
274     IUniswapV2Router02 public immutable uniswapV2Router;
275     address public immutable uniswapV2Pair;
276     address public constant deadAddress = address(0xdead);
277 
278     bool private swapping;
279 
280     address public marketingWallet;
281     address public devWallet;
282     
283     uint256 public maxTransactionAmount;
284     uint256 public swapTokensAtAmount;
285     uint256 public maxWallet;
286 
287     bool public limitsInEffect = true;
288     bool public tradingActive = false;
289     bool public swapEnabled = false;
290     
291      // Anti-bot and anti-whale mappings and variables
292     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
293     mapping (address => bool) public isBlacklisted;
294     bool public transferDelayEnabled = true;
295 
296     uint256 public buyTotalFees;
297     uint256 public buyMarketingFee;
298     uint256 public buyLiquidityFee;
299     uint256 public buyDevFee;
300     
301     uint256 public sellTotalFees;
302     uint256 public sellMarketingFee;
303     uint256 public sellLiquidityFee;
304     uint256 public sellDevFee;
305     
306     uint256 public tokensForMarketing;
307     uint256 public tokensForLiquidity;
308     uint256 public tokensForDev;
309     
310     /******************/
311 
312     // exlcude from fees and max transaction amount
313     mapping (address => bool) private _isExcludedFromFees;
314     mapping (address => bool) public _isExcludedMaxTransactionAmount;
315 
316     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
317     // could be subject to a maximum transfer amount
318     mapping (address => bool) public automatedMarketMakerPairs;
319 
320     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
321     event ExcludeFromFees(address indexed account, bool isExcluded);
322     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
323     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
324     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
325     event SwapAndLiquify(
326         uint256 tokensSwapped,
327         uint256 ethReceived,
328         uint256 tokensIntoLiquidity
329     );
330 
331     constructor() ERC20("Okage Inu", "OKAGE") {
332         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
333         
334         excludeFromMaxTransaction(address(_uniswapV2Router), true);
335         uniswapV2Router = _uniswapV2Router;
336         
337         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
338         excludeFromMaxTransaction(address(uniswapV2Pair), true);
339         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
340         
341         uint256 _buyMarketingFee = 0;
342         uint256 _buyLiquidityFee = 0;
343         uint256 _buyDevFee = 25;
344 
345         uint256 _sellMarketingFee = 0;
346         uint256 _sellLiquidityFee = 0;
347         uint256 _sellDevFee = 25;
348         
349         uint256 totalSupply = 1000000000000 * 1e18; 
350         
351         maxTransactionAmount = totalSupply * 20 / 1000; // 2.5% maxTransactionAmountTxn
352         maxWallet = totalSupply * 20 / 1000; // 2.5% maxWallet
353         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
354 
355         buyMarketingFee = _buyMarketingFee;
356         buyLiquidityFee = _buyLiquidityFee;
357         buyDevFee = _buyDevFee;
358         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
359         
360         sellMarketingFee = _sellMarketingFee;
361         sellLiquidityFee = _sellLiquidityFee;
362         sellDevFee = _sellDevFee;
363         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
364         
365         marketingWallet = address(owner());
366         devWallet = address(owner()); 
367 
368         // exclude from paying fees or having max transaction amount
369         excludeFromFees(owner(), true);
370         excludeFromFees(address(this), true);
371         excludeFromFees(address(0xdead), true);
372         
373         excludeFromMaxTransaction(owner(), true);
374         excludeFromMaxTransaction(address(this), true);
375         excludeFromMaxTransaction(address(0xdead), true);
376         
377         /*
378             _mint is an internal function in ERC20.sol that is only called here,
379             and CANNOT be called ever again
380         */
381         _mint(msg.sender, totalSupply);
382     }
383 
384     receive() external payable {
385 
386   	}
387 
388     // once enabled, can never be turned off
389     function enableTrading() external onlyOwner {
390         tradingActive = true;
391         swapEnabled = true;
392     }
393     
394     // remove limits after token is stable
395     function removeLimits() external onlyOwner returns (bool){
396         limitsInEffect = false;
397         return true;
398     }
399     
400     // disable Transfer delay - cannot be reenabled
401     function disableTransferDelay() external onlyOwner returns (bool){
402         transferDelayEnabled = false;
403         return true;
404     }
405     
406      // change the minimum amount of tokens to sell from fees
407     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
408   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
409   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
410   	    swapTokensAtAmount = newAmount;
411   	    return true;
412   	}
413     
414     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
415         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
416         maxTransactionAmount = newNum * (10**18);
417     }
418 
419     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
420         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
421         maxWallet = newNum * (10**18);
422     }
423     
424     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
425         _isExcludedMaxTransactionAmount[updAds] = isEx;
426     }
427     
428     // only use to disable contract sales if absolutely necessary (emergency use only)
429     function updateSwapEnabled(bool enabled) external onlyOwner(){
430         swapEnabled = enabled;
431     }
432     
433     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
434         buyMarketingFee = _marketingFee;
435         buyLiquidityFee = _liquidityFee;
436         buyDevFee = _devFee;
437         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
438         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
439     }
440     
441     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
442         sellMarketingFee = _marketingFee;
443         sellLiquidityFee = _liquidityFee;
444         sellDevFee = _devFee;
445         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
446         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
447     }
448 
449     function excludeFromFees(address account, bool excluded) public onlyOwner {
450         _isExcludedFromFees[account] = excluded;
451         emit ExcludeFromFees(account, excluded);
452     }
453 
454     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
455         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
456 
457         _setAutomatedMarketMakerPair(pair, value);
458     }
459 
460     function _setAutomatedMarketMakerPair(address pair, bool value) private {
461         automatedMarketMakerPairs[pair] = value;
462 
463         emit SetAutomatedMarketMakerPair(pair, value);
464     }
465 
466     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
467         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
468         marketingWallet = newMarketingWallet;
469     }
470     
471     function updateDevWallet(address newWallet) external onlyOwner {
472         emit devWalletUpdated(newWallet, devWallet);
473         devWallet = newWallet;
474     }
475     
476 
477     function isExcludedFromFees(address account) public view returns(bool) {
478         return _isExcludedFromFees[account];
479     }
480 
481     function manage_blacklist(address _address, bool status) external onlyOwner {
482         require(_address != address(0),"Address should not be 0");
483         isBlacklisted[_address] = status;
484     }
485 
486     function _transfer(
487         address from,
488         address to,
489         uint256 amount
490     ) internal override {
491         require(from != address(0), "ERC20: transfer from the zero address");
492         require(to != address(0), "ERC20: transfer to the zero address");
493         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
494         
495          if(amount == 0) {
496             super._transfer(from, to, 0);
497             return;
498         }
499         
500         if(limitsInEffect){
501             if (
502                 from != owner() &&
503                 to != owner() &&
504                 to != address(0) &&
505                 to != address(0xdead) &&
506                 !swapping
507             ){
508                 if(!tradingActive){
509                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
510                 }
511 
512                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
513                 if (transferDelayEnabled){
514                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
515                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
516                         _holderLastTransferTimestamp[tx.origin] = block.number;
517                     }
518                 }
519                  
520                 //when buy
521                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
522                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
523                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
524                 }
525                 
526                 //when sell
527                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
528                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
529                 }
530                 else if(!_isExcludedMaxTransactionAmount[to]){
531                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
532                 }
533             }
534         }
535         
536 		uint256 contractTokenBalance = balanceOf(address(this));
537         
538         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
539 
540         if( 
541             canSwap &&
542             swapEnabled &&
543             !swapping &&
544             !automatedMarketMakerPairs[from] &&
545             !_isExcludedFromFees[from] &&
546             !_isExcludedFromFees[to]
547         ) {
548             swapping = true;
549             
550             swapBack();
551 
552             swapping = false;
553         }
554 
555         bool takeFee = !swapping;
556 
557         // if any account belongs to _isExcludedFromFee account then remove the fee
558         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
559             takeFee = false;
560         }
561         
562         uint256 fees = 0;
563         // only take fees on buys/sells, do not take on wallet transfers
564         if(takeFee){
565             // on sell
566             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
567                 fees = amount * sellTotalFees/100;
568                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
569                 tokensForDev += fees * sellDevFee / sellTotalFees;
570                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
571             }
572             // on buy
573             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
574         	    fees = amount * buyTotalFees/100;
575         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
576                 tokensForDev += fees * buyDevFee / buyTotalFees;
577                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
578             }
579             
580             if(fees > 0){    
581                 super._transfer(from, address(this), fees);
582             }
583         	
584         	amount -= fees;
585         }
586 
587         super._transfer(from, to, amount);
588     }
589 
590     function swapTokensForEth(uint256 tokenAmount) private {
591 
592         // generate the uniswap pair path of token -> weth
593         address[] memory path = new address[](2);
594         path[0] = address(this);
595         path[1] = uniswapV2Router.WETH();
596 
597         _approve(address(this), address(uniswapV2Router), tokenAmount);
598 
599         // make the swap
600         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
601             tokenAmount,
602             0, // accept any amount of ETH
603             path,
604             address(this),
605             block.timestamp
606         );
607         
608     }
609     
610     
611     
612     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
613         // approve token transfer to cover all possible scenarios
614         _approve(address(this), address(uniswapV2Router), tokenAmount);
615 
616         // add the liquidity
617         uniswapV2Router.addLiquidityETH{value: ethAmount}(
618             address(this),
619             tokenAmount,
620             0, // slippage is unavoidable
621             0, // slippage is unavoidable
622             deadAddress,
623             block.timestamp
624         );
625     }
626 
627     function swapBack() private {
628         uint256 contractBalance = balanceOf(address(this));
629         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
630         bool success;
631 
632         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
633         if(contractBalance > swapTokensAtAmount * 20){
634           contractBalance = swapTokensAtAmount * 20;
635         }
636         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
637         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
638         uint256 initialETHBalance = address(this).balance;
639         swapTokensForEth(amountToSwapForETH); 
640         uint256 ethBalance = address(this).balance - initialETHBalance;
641         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
642         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
643         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
644         tokensForLiquidity = 0;
645         tokensForMarketing = 0;
646         tokensForDev = 0;
647         (success,) = address(devWallet).call{value: ethForDev}("");
648         if(liquidityTokens > 0 && ethForLiquidity > 0){
649             addLiquidity(liquidityTokens, ethForLiquidity);
650             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
651         }
652         (success,) = address(marketingWallet).call{value: address(this).balance}("");
653     }
654     
655 
656 }