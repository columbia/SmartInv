1 /*
2 
3 YEAH even $IS is pumping hard, I still can beat it with my X1000 because $QSM launched with 2 ETH liquidity.
4 Small liquidity? Good because that's how I can participate in Crypto, I am not a whale, I am just somebody ordinary person, degen play is my life.
5 * Telegram: https://t.me/QinsMoonETH
6 
7 */
8 // SPDX-License-Identifier: MIT                                                                               
9                                                     
10 pragma solidity = 0.8.17;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IUniswapV2Pair {
24     function factory() external view returns (address);
25 }
26 
27 interface IUniswapV2Factory {
28     function createPair(address tokenA, address tokenB) external returns (address pair);
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint256 amount
41     ) external returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 interface IERC20Metadata is IERC20 {
47     function name() external view returns (string memory);
48     function symbol() external view returns (string memory);
49     function decimals() external view returns (uint8);
50 }
51 
52 
53 contract ERC20 is Context, IERC20, IERC20Metadata {
54     using SafeMath for uint256;
55     mapping(address => uint256) private _balances;
56     mapping(address => mapping(address => uint256)) private _allowances;
57     uint256 private _totalSupply;
58     string private _name;
59     string private _symbol;
60     constructor(string memory name_, string memory symbol_) {
61         _name = name_;
62         _symbol = symbol_;
63     }
64     function name() public view virtual override returns (string memory) {return _name;}
65     function symbol() public view virtual override returns (string memory) {return _symbol;}
66     function decimals() public view virtual override returns (uint8) {return 18;}
67     function totalSupply() public view virtual override returns (uint256) {return _totalSupply;}
68     function balanceOf(address account) public view virtual override returns (uint256) {return _balances[account];}
69     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
70         _transfer(_msgSender(), recipient, amount);
71         return true;
72     }
73     function allowance(address owner, address spender) public view virtual override returns (uint256) {
74         return _allowances[owner][spender];
75     }
76     function approve(address spender, uint256 amount) public virtual override returns (bool) {
77         _approve(_msgSender(), spender, amount);
78         return true;
79     }
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) public virtual override returns (bool) {
85         _transfer(sender, recipient, amount);
86         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
87         return true;
88     }
89     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
90         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
91         return true;
92     }
93     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
94         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
95         return true;
96     }
97     function _transfer(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) internal virtual {
102         require(sender != address(0), "ERC20: transfer from the zero address");
103         require(recipient != address(0), "ERC20: transfer to the zero address");
104         _beforeTokenTransfer(sender, recipient, amount);
105         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
106         _balances[recipient] = _balances[recipient].add(amount);
107         emit Transfer(sender, recipient, amount);
108     }
109     function _mint(address account, uint256 amount) internal virtual {
110         require(account != address(0), "ERC20: mint to the zero address");
111         _beforeTokenTransfer(address(0), account, amount);
112         _totalSupply = _totalSupply.add(amount);
113         _balances[account] = _balances[account].add(amount);
114         emit Transfer(address(0), account, amount);
115     }
116     function _burn(address account, uint256 amount) internal virtual {
117         require(account != address(0), "ERC20: burn from the zero address");
118         _beforeTokenTransfer(account, address(0), amount);
119         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
120         _totalSupply = _totalSupply.sub(amount);
121         emit Transfer(account, address(0), amount);
122     }
123     function _approve(
124         address owner,
125         address spender,
126         uint256 amount
127     ) internal virtual {
128         require(owner != address(0), "ERC20: approve from the zero address");
129         require(spender != address(0), "ERC20: approve to the zero address");
130         _allowances[owner][spender] = amount;
131         emit Approval(owner, spender, amount);
132     }
133     function _beforeTokenTransfer(
134         address from,
135         address to,
136         uint256 amount
137     ) internal virtual {}
138 }
139 
140 library SafeMath {
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144         return c;
145     }
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152         return c;
153     }
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         if (a == 0) {
156             return 0;
157         }
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160         return c;
161     }
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b > 0, errorMessage);
167         uint256 c = a / b;
168         return c;
169     }
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b != 0, errorMessage);
175         return a % b;
176     }
177 }
178 
179 contract Ownable is Context {
180     address private _owner;
181     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182     constructor () {
183         address msgSender = _msgSender();
184         _owner = msgSender;
185         emit OwnershipTransferred(address(0), msgSender);
186     }
187     function owner() public view returns (address) {return _owner;}
188     modifier onlyOwner() {
189         require(_owner == _msgSender(), "Ownable: caller is not the owner");
190         _;
191     }
192     function renounceOwnership() public virtual onlyOwner {
193         emit OwnershipTransferred(_owner, address(0));
194         _owner = address(0);
195     }
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         require(newOwner != address(0), "Ownable: new owner is the zero address");
198         emit OwnershipTransferred(_owner, newOwner);
199         _owner = newOwner;
200     }
201 }
202 
203 
204 
205 library SafeMathInt {
206     int256 private constant MIN_INT256 = int256(1) << 255;
207     int256 private constant MAX_INT256 = ~(int256(1) << 255);
208     function mul(int256 a, int256 b) internal pure returns (int256) {
209         int256 c = a * b;
210         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
211         require((b == 0) || (c / b == a));
212         return c;
213     }
214     function div(int256 a, int256 b) internal pure returns (int256) {
215         require(b != -1 || a != MIN_INT256);
216         return a / b;
217     }
218     function sub(int256 a, int256 b) internal pure returns (int256) {
219         int256 c = a - b;
220         require((b >= 0 && c <= a) || (b < 0 && c > a));
221         return c;
222     }
223     function add(int256 a, int256 b) internal pure returns (int256) {
224         int256 c = a + b;
225         require((b >= 0 && c >= a) || (b < 0 && c < a));
226         return c;
227     }
228     function abs(int256 a) internal pure returns (int256) {
229         require(a != MIN_INT256);
230         return a < 0 ? -a : a;
231     }
232     function toUint256Safe(int256 a) internal pure returns (uint256) {
233         require(a >= 0);
234         return uint256(a);
235     }
236 }
237 
238 library SafeMathUint {
239   function toInt256Safe(uint256 a) internal pure returns (int256) {
240     int256 b = int256(a);
241     require(b >= 0);
242     return b;
243   }
244 }
245 
246 
247 interface IUniswapV2Router01 {
248     function factory() external pure returns (address);
249     function WETH() external pure returns (address);
250 
251     function addLiquidityETH(
252         address token,
253         uint amountTokenDesired,
254         uint amountTokenMin,
255         uint amountETHMin,
256         address to,
257         uint deadline
258     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
259 }
260 
261 interface IUniswapV2Router02 is IUniswapV2Router01 {
262     function swapExactTokensForETHSupportingFeeOnTransferTokens(
263         uint amountIn,
264         uint amountOutMin,
265         address[] calldata path,
266         address to,
267         uint deadline
268     ) external;
269 }
270 
271 contract QinsMoon is ERC20, Ownable {
272 
273     IUniswapV2Router02 public immutable uniswapV2Router;
274     address public immutable uniswapV2Pair;
275     address public constant deadAddress = address(0xdead);
276 
277     bool private swapping;
278 
279     address public marketingWallet;
280     address public devWallet;
281     
282     uint256 public maxTransactionAmount;
283     uint256 public swapTokensAtAmount;
284     uint256 public maxWallet;
285 
286     bool public limitsInEffect = true;
287     bool public tradingActive = false;
288     bool public swapEnabled = false;
289     
290      // Anti-bot and anti-whale mappings and variables
291     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
292     mapping (address => bool) public isBlacklisted;
293     bool public transferDelayEnabled = true;
294 
295     uint256 public buyTotalFees;
296     uint256 public buyMarketingFee;
297     uint256 public buyLiquidityFee;
298     uint256 public buyDevFee;
299     
300     uint256 public sellTotalFees;
301     uint256 public sellMarketingFee;
302     uint256 public sellLiquidityFee;
303     uint256 public sellDevFee;
304     
305     uint256 public tokensForMarketing;
306     uint256 public tokensForLiquidity;
307     uint256 public tokensForDev;
308     
309     /******************/
310 
311     // exlcude from fees and max transaction amount
312     mapping (address => bool) private _isExcludedFromFees;
313     mapping (address => bool) public _isExcludedMaxTransactionAmount;
314 
315     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
316     // could be subject to a maximum transfer amount
317     mapping (address => bool) public automatedMarketMakerPairs;
318 
319     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
320     event ExcludeFromFees(address indexed account, bool isExcluded);
321     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
322     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
323     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
324     event SwapAndLiquify(
325         uint256 tokensSwapped,
326         uint256 ethReceived,
327         uint256 tokensIntoLiquidity
328     );
329 
330     constructor() ERC20("QinsMoon", "QSM") {
331         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
332         
333         excludeFromMaxTransaction(address(_uniswapV2Router), true);
334         uniswapV2Router = _uniswapV2Router;
335         
336         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
337         excludeFromMaxTransaction(address(uniswapV2Pair), true);
338         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
339         
340         uint256 _buyMarketingFee = 0;
341         uint256 _buyLiquidityFee = 0;
342         uint256 _buyDevFee = 25;
343 
344         uint256 _sellMarketingFee = 0;
345         uint256 _sellLiquidityFee = 0;
346         uint256 _sellDevFee = 40;
347         
348         uint256 totalSupply = 1000000000000 * 1e18; 
349         
350         maxTransactionAmount = totalSupply * 20 / 100; // 20% maxTransactionAmountTxn
351         maxWallet = totalSupply * 20 / 100; // 20% maxWallet
352         swapTokensAtAmount = totalSupply * 5 / 100; // 5% swap wallet
353 
354         buyMarketingFee = _buyMarketingFee;
355         buyLiquidityFee = _buyLiquidityFee;
356         buyDevFee = _buyDevFee;
357         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
358         
359         sellMarketingFee = _sellMarketingFee;
360         sellLiquidityFee = _sellLiquidityFee;
361         sellDevFee = _sellDevFee;
362         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
363         
364         marketingWallet = address(owner());
365         devWallet = address(owner()); 
366 
367         // exclude from paying fees or having max transaction amount
368         excludeFromFees(owner(), true);
369         excludeFromFees(address(this), true);
370         excludeFromFees(address(0xdead), true);
371         
372         excludeFromMaxTransaction(owner(), true);
373         excludeFromMaxTransaction(address(this), true);
374         excludeFromMaxTransaction(address(0xdead), true);
375         
376         /*
377             _mint is an internal function in ERC20.sol that is only called here,
378             and CANNOT be called ever again
379         */
380         _mint(msg.sender, totalSupply);
381     }
382 
383     receive() external payable {
384 
385   	}
386 
387     // once enabled, can never be turned off
388     function enableTrading() external onlyOwner {
389         tradingActive = true;
390         swapEnabled = true;
391     }
392     
393     // remove limits after token is stable
394     function removeLimits() external onlyOwner returns (bool){
395         limitsInEffect = false;
396         return true;
397     }
398     
399     // disable Transfer delay - cannot be reenabled
400     function disableTransferDelay() external onlyOwner returns (bool){
401         transferDelayEnabled = false;
402         return true;
403     }
404     
405      // change the minimum amount of tokens to sell from fees
406     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
407   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
408   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
409   	    swapTokensAtAmount = newAmount;
410   	    return true;
411   	}
412     
413     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
414         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
415         maxTransactionAmount = newNum * (10**18);
416     }
417 
418     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
419         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
420         maxWallet = newNum * (10**18);
421     }
422     
423     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
424         _isExcludedMaxTransactionAmount[updAds] = isEx;
425     }
426     
427     // only use to disable contract sales if absolutely necessary (emergency use only)
428     function updateSwapEnabled(bool enabled) external onlyOwner(){
429         swapEnabled = enabled;
430     }
431     
432     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
433         buyMarketingFee = _marketingFee;
434         buyLiquidityFee = _liquidityFee;
435         buyDevFee = _devFee;
436         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
437         require(buyTotalFees <= 45, "Must keep fees at 45% or less");
438     }
439     
440     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
441         sellMarketingFee = _marketingFee;
442         sellLiquidityFee = _liquidityFee;
443         sellDevFee = _devFee;
444         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
445         require(sellTotalFees <= 45, "Must keep fees at 45% or less");
446     }
447 
448     function excludeFromFees(address account, bool excluded) public onlyOwner {
449         _isExcludedFromFees[account] = excluded;
450         emit ExcludeFromFees(account, excluded);
451     }
452 
453     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
454         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
455 
456         _setAutomatedMarketMakerPair(pair, value);
457     }
458 
459     function _setAutomatedMarketMakerPair(address pair, bool value) private {
460         automatedMarketMakerPairs[pair] = value;
461 
462         emit SetAutomatedMarketMakerPair(pair, value);
463     }
464 
465     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
466         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
467         marketingWallet = newMarketingWallet;
468     }
469     
470     function updateDevWallet(address newWallet) external onlyOwner {
471         emit devWalletUpdated(newWallet, devWallet);
472         devWallet = newWallet;
473     }
474     
475 
476     function isExcludedFromFees(address account) public view returns(bool) {
477         return _isExcludedFromFees[account];
478     }
479 
480     function manage_blacklist(address _address, bool status) external onlyOwner {
481         require(_address != address(0),"Address should not be 0");
482         isBlacklisted[_address] = status;
483     }
484 
485     function _transfer(
486         address from,
487         address to,
488         uint256 amount
489     ) internal override {
490         require(from != address(0), "ERC20: transfer from the zero address");
491         require(to != address(0), "ERC20: transfer to the zero address");
492         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
493         
494          if(amount == 0) {
495             super._transfer(from, to, 0);
496             return;
497         }
498         
499         if(limitsInEffect){
500             if (
501                 from != owner() &&
502                 to != owner() &&
503                 to != address(0) &&
504                 to != address(0xdead) &&
505                 !swapping
506             ){
507                 if(!tradingActive){
508                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
509                 }
510 
511                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
512                 if (transferDelayEnabled){
513                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
514                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
515                         _holderLastTransferTimestamp[tx.origin] = block.number;
516                     }
517                 }
518                  
519                 //when buy
520                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
521                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
522                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
523                 }
524                 
525                 //when sell
526                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
527                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
528                 }
529                 else if(!_isExcludedMaxTransactionAmount[to]){
530                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
531                 }
532             }
533         }
534         
535 		uint256 contractTokenBalance = balanceOf(address(this));
536         
537         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
538 
539         if( 
540             canSwap &&
541             swapEnabled &&
542             !swapping &&
543             !automatedMarketMakerPairs[from] &&
544             !_isExcludedFromFees[from] &&
545             !_isExcludedFromFees[to]
546         ) {
547             swapping = true;
548             
549             swapBack();
550 
551             swapping = false;
552         }
553 
554         bool takeFee = !swapping;
555 
556         // if any account belongs to _isExcludedFromFee account then remove the fee
557         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
558             takeFee = false;
559         }
560         
561         uint256 fees = 0;
562         // only take fees on buys/sells, do not take on wallet transfers
563         if(takeFee){
564             // on sell
565             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
566                 fees = amount * sellTotalFees/100;
567                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
568                 tokensForDev += fees * sellDevFee / sellTotalFees;
569                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
570             }
571             // on buy
572             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
573         	    fees = amount * buyTotalFees/100;
574         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
575                 tokensForDev += fees * buyDevFee / buyTotalFees;
576                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
577             }
578             
579             if(fees > 0){    
580                 super._transfer(from, address(this), fees);
581             }
582         	
583         	amount -= fees;
584         }
585 
586         super._transfer(from, to, amount);
587     }
588 
589     function swapTokensForEth(uint256 tokenAmount) private {
590 
591         // generate the uniswap pair path of token -> weth
592         address[] memory path = new address[](2);
593         path[0] = address(this);
594         path[1] = uniswapV2Router.WETH();
595 
596         _approve(address(this), address(uniswapV2Router), tokenAmount);
597 
598         // make the swap
599         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
600             tokenAmount,
601             0, // accept any amount of ETH
602             path,
603             address(this),
604             block.timestamp
605         );
606         
607     }
608     
609     
610     
611     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
612         // approve token transfer to cover all possible scenarios
613         _approve(address(this), address(uniswapV2Router), tokenAmount);
614 
615         // add the liquidity
616         uniswapV2Router.addLiquidityETH{value: ethAmount}(
617             address(this),
618             tokenAmount,
619             0, // slippage is unavoidable
620             0, // slippage is unavoidable
621             deadAddress,
622             block.timestamp
623         );
624     }
625 
626     function swapBack() private {
627         uint256 contractBalance = balanceOf(address(this));
628         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
629         bool success;
630 
631         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
632         if(contractBalance > swapTokensAtAmount * 20){
633           contractBalance = swapTokensAtAmount * 20;
634         }
635         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
636         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
637         uint256 initialETHBalance = address(this).balance;
638         swapTokensForEth(amountToSwapForETH); 
639         uint256 ethBalance = address(this).balance - initialETHBalance;
640         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
641         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
642         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
643         tokensForLiquidity = 0;
644         tokensForMarketing = 0;
645         tokensForDev = 0;
646         (success,) = address(devWallet).call{value: ethForDev}("");
647         if(liquidityTokens > 0 && ethForLiquidity > 0){
648             addLiquidity(liquidityTokens, ethForLiquidity);
649             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
650         }
651         (success,) = address(marketingWallet).call{value: address(this).balance}("");
652     }
653     
654 
655 }