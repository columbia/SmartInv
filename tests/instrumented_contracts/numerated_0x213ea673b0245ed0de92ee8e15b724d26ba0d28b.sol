1 /*
2 GPT-IV is a new language model being created by OpenAI that can generate text that is similar to human speech. It will advance the technology used by ChatGPT, which is based on GPT-3.5. GPT is the acronym for Generative Pre-trained Transformer, a deep learning technology that uses artificial neural networks to write like a human.
3 
4 GPT-IV is significantly larger and more powerful than GPT-3, with 170 trillion parameters compared to GPT-3's 175 billion parameters. This allows GPT-IV to process and generate text with greater accuracy and fluency
5 
6 FAQs:
7 
8 What is GPT-IV?
9 GPT-IV is the next generation of OpenAI's large language model that could offer multimodal abilities, such as AI-generated videos, and faster responses to user queries.
10 
11 What is ChatGPT?
12 ChatGPT is a popular language model developed by OpenAI that is restricted to answering user queries with text.
13 
14 
15 Telegram: https://t.me/GPT4ERC
16 Website: https://gpt-iv.io/
17 Twitter: https://twitter.com/GPT4ERC
18 
19 */
20 // SPDX-License-Identifier: MIT                                                                               
21                                                     
22 pragma solidity = 0.8.17;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 interface IUniswapV2Pair {
36     function factory() external view returns (address);
37 }
38 
39 interface IUniswapV2Factory {
40     function createPair(address tokenA, address tokenB) external returns (address pair);
41 }
42 
43 interface IERC20 {
44     function totalSupply() external view returns (uint256);
45     function balanceOf(address account) external view returns (uint256);
46     function transfer(address recipient, uint256 amount) external returns (bool);
47     function allowance(address owner, address spender) external view returns (uint256);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function transferFrom(
50         address sender,
51         address recipient,
52         uint256 amount
53     ) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 interface IERC20Metadata is IERC20 {
59     function name() external view returns (string memory);
60     function symbol() external view returns (string memory);
61     function decimals() external view returns (uint8);
62 }
63 
64 
65 contract ERC20 is Context, IERC20, IERC20Metadata {
66     using SafeMath for uint256;
67     mapping(address => uint256) private _balances;
68     mapping(address => mapping(address => uint256)) private _allowances;
69     uint256 private _totalSupply;
70     string private _name;
71     string private _symbol;
72     constructor(string memory name_, string memory symbol_) {
73         _name = name_;
74         _symbol = symbol_;
75     }
76     function name() public view virtual override returns (string memory) {return _name;}
77     function symbol() public view virtual override returns (string memory) {return _symbol;}
78     function decimals() public view virtual override returns (uint8) {return 18;}
79     function totalSupply() public view virtual override returns (uint256) {return _totalSupply;}
80     function balanceOf(address account) public view virtual override returns (uint256) {return _balances[account];}
81     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
82         _transfer(_msgSender(), recipient, amount);
83         return true;
84     }
85     function allowance(address owner, address spender) public view virtual override returns (uint256) {
86         return _allowances[owner][spender];
87     }
88     function approve(address spender, uint256 amount) public virtual override returns (bool) {
89         _approve(_msgSender(), spender, amount);
90         return true;
91     }
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) public virtual override returns (bool) {
97         _transfer(sender, recipient, amount);
98         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
99         return true;
100     }
101     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
102         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
103         return true;
104     }
105     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
106         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
107         return true;
108     }
109     function _transfer(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) internal virtual {
114         require(sender != address(0), "ERC20: transfer from the zero address");
115         require(recipient != address(0), "ERC20: transfer to the zero address");
116         _beforeTokenTransfer(sender, recipient, amount);
117         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
118         _balances[recipient] = _balances[recipient].add(amount);
119         emit Transfer(sender, recipient, amount);
120     }
121     function _mint(address account, uint256 amount) internal virtual {
122         require(account != address(0), "ERC20: mint to the zero address");
123         _beforeTokenTransfer(address(0), account, amount);
124         _totalSupply = _totalSupply.add(amount);
125         _balances[account] = _balances[account].add(amount);
126         emit Transfer(address(0), account, amount);
127     }
128     function _burn(address account, uint256 amount) internal virtual {
129         require(account != address(0), "ERC20: burn from the zero address");
130         _beforeTokenTransfer(account, address(0), amount);
131         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
132         _totalSupply = _totalSupply.sub(amount);
133         emit Transfer(account, address(0), amount);
134     }
135     function _approve(
136         address owner,
137         address spender,
138         uint256 amount
139     ) internal virtual {
140         require(owner != address(0), "ERC20: approve from the zero address");
141         require(spender != address(0), "ERC20: approve to the zero address");
142         _allowances[owner][spender] = amount;
143         emit Approval(owner, spender, amount);
144     }
145     function _beforeTokenTransfer(
146         address from,
147         address to,
148         uint256 amount
149     ) internal virtual {}
150 }
151 
152 library SafeMath {
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "SafeMath: addition overflow");
156         return c;
157     }
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164         return c;
165     }
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         if (a == 0) {
168             return 0;
169         }
170         uint256 c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172         return c;
173     }
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b > 0, errorMessage);
179         uint256 c = a / b;
180         return c;
181     }
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         return mod(a, b, "SafeMath: modulo by zero");
184     }
185     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b != 0, errorMessage);
187         return a % b;
188     }
189 }
190 
191 contract Ownable is Context {
192     address private _owner;
193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194     constructor () {
195         address msgSender = _msgSender();
196         _owner = msgSender;
197         emit OwnershipTransferred(address(0), msgSender);
198     }
199     function owner() public view returns (address) {return _owner;}
200     modifier onlyOwner() {
201         require(_owner == _msgSender(), "Ownable: caller is not the owner");
202         _;
203     }
204     function renounceOwnership() public virtual onlyOwner {
205         emit OwnershipTransferred(_owner, address(0));
206         _owner = address(0);
207     }
208     function transferOwnership(address newOwner) public virtual onlyOwner {
209         require(newOwner != address(0), "Ownable: new owner is the zero address");
210         emit OwnershipTransferred(_owner, newOwner);
211         _owner = newOwner;
212     }
213 }
214 
215 
216 
217 library SafeMathInt {
218     int256 private constant MIN_INT256 = int256(1) << 255;
219     int256 private constant MAX_INT256 = ~(int256(1) << 255);
220     function mul(int256 a, int256 b) internal pure returns (int256) {
221         int256 c = a * b;
222         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
223         require((b == 0) || (c / b == a));
224         return c;
225     }
226     function div(int256 a, int256 b) internal pure returns (int256) {
227         require(b != -1 || a != MIN_INT256);
228         return a / b;
229     }
230     function sub(int256 a, int256 b) internal pure returns (int256) {
231         int256 c = a - b;
232         require((b >= 0 && c <= a) || (b < 0 && c > a));
233         return c;
234     }
235     function add(int256 a, int256 b) internal pure returns (int256) {
236         int256 c = a + b;
237         require((b >= 0 && c >= a) || (b < 0 && c < a));
238         return c;
239     }
240     function abs(int256 a) internal pure returns (int256) {
241         require(a != MIN_INT256);
242         return a < 0 ? -a : a;
243     }
244     function toUint256Safe(int256 a) internal pure returns (uint256) {
245         require(a >= 0);
246         return uint256(a);
247     }
248 }
249 
250 library SafeMathUint {
251   function toInt256Safe(uint256 a) internal pure returns (int256) {
252     int256 b = int256(a);
253     require(b >= 0);
254     return b;
255   }
256 }
257 
258 
259 interface IUniswapV2Router01 {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262 
263     function addLiquidityETH(
264         address token,
265         uint amountTokenDesired,
266         uint amountTokenMin,
267         uint amountETHMin,
268         address to,
269         uint deadline
270     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
271 }
272 
273 interface IUniswapV2Router02 is IUniswapV2Router01 {
274     function swapExactTokensForETHSupportingFeeOnTransferTokens(
275         uint amountIn,
276         uint amountOutMin,
277         address[] calldata path,
278         address to,
279         uint deadline
280     ) external;
281 }
282 
283 contract GPTIV is ERC20, Ownable {
284 
285     IUniswapV2Router02 public immutable uniswapV2Router;
286     address public immutable uniswapV2Pair;
287     address public constant deadAddress = address(0xdead);
288 
289     bool private swapping;
290 
291     address public marketingWallet;
292     address public devWallet;
293     
294     uint256 public maxTransactionAmount;
295     uint256 public swapTokensAtAmount;
296     uint256 public maxWallet;
297 
298     bool public limitsInEffect = true;
299     bool public tradingActive = false;
300     bool public swapEnabled = false;
301     
302      // Anti-bot and anti-whale mappings and variables
303     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
304     mapping (address => bool) public isBlacklisted;
305     bool public transferDelayEnabled = true;
306 
307     uint256 public buyTotalFees;
308     uint256 public buyMarketingFee;
309     uint256 public buyLiquidityFee;
310     uint256 public buyDevFee;
311     
312     uint256 public sellTotalFees;
313     uint256 public sellMarketingFee;
314     uint256 public sellLiquidityFee;
315     uint256 public sellDevFee;
316     
317     uint256 public tokensForMarketing;
318     uint256 public tokensForLiquidity;
319     uint256 public tokensForDev;
320     
321     /******************/
322 
323     // exlcude from fees and max transaction amount
324     mapping (address => bool) private _isExcludedFromFees;
325     mapping (address => bool) public _isExcludedMaxTransactionAmount;
326 
327     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
328     // could be subject to a maximum transfer amount
329     mapping (address => bool) public automatedMarketMakerPairs;
330 
331     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
332     event ExcludeFromFees(address indexed account, bool isExcluded);
333     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
334     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
335     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
336     event SwapAndLiquify(
337         uint256 tokensSwapped,
338         uint256 ethReceived,
339         uint256 tokensIntoLiquidity
340     );
341 
342     constructor() ERC20("GPT-IV", "GPT-IV") {
343         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
344         
345         excludeFromMaxTransaction(address(_uniswapV2Router), true);
346         uniswapV2Router = _uniswapV2Router;
347         
348         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
349         excludeFromMaxTransaction(address(uniswapV2Pair), true);
350         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
351         
352         uint256 _buyMarketingFee = 39;
353         uint256 _buyLiquidityFee = 1;
354         uint256 _buyDevFee = 0;
355 
356         uint256 _sellMarketingFee = 39;
357         uint256 _sellLiquidityFee = 1;
358         uint256 _sellDevFee = 0;
359         
360         uint256 totalSupply = 100000000 * 1e18; 
361         
362         maxTransactionAmount = totalSupply * 25 / 1000; // 2.5% maxTransactionAmountTxn
363         maxWallet = totalSupply * 25 / 1000; // 2.5% maxWallet
364         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
365 
366         buyMarketingFee = _buyMarketingFee;
367         buyLiquidityFee = _buyLiquidityFee;
368         buyDevFee = _buyDevFee;
369         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
370         
371         sellMarketingFee = _sellMarketingFee;
372         sellLiquidityFee = _sellLiquidityFee;
373         sellDevFee = _sellDevFee;
374         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
375         
376         marketingWallet = address(owner());
377         devWallet = address(owner()); 
378 
379         // exclude from paying fees or having max transaction amount
380         excludeFromFees(owner(), true);
381         excludeFromFees(address(this), true);
382         excludeFromFees(address(0xdead), true);
383         
384         excludeFromMaxTransaction(owner(), true);
385         excludeFromMaxTransaction(address(this), true);
386         excludeFromMaxTransaction(address(0xdead), true);
387         
388         /*
389             _mint is an internal function in ERC20.sol that is only called here,
390             and CANNOT be called ever again
391         */
392         _mint(msg.sender, totalSupply);
393     }
394 
395     receive() external payable {
396 
397   	}
398 
399     // once enabled, can never be turned off
400     function enableTrading() external onlyOwner {
401         tradingActive = true;
402         swapEnabled = true;
403     }
404     
405     // remove limits after token is stable
406     function removeLimits() external onlyOwner returns (bool){
407         limitsInEffect = false;
408         return true;
409     }
410     
411     // disable Transfer delay - cannot be reenabled
412     function disableTransferDelay() external onlyOwner returns (bool){
413         transferDelayEnabled = false;
414         return true;
415     }
416     
417      // change the minimum amount of tokens to sell from fees
418     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
419   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
420   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
421   	    swapTokensAtAmount = newAmount;
422   	    return true;
423   	}
424     
425     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
426         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
427         maxTransactionAmount = newNum * (10**18);
428     }
429 
430     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
431         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
432         maxWallet = newNum * (10**18);
433     }
434     
435     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
436         _isExcludedMaxTransactionAmount[updAds] = isEx;
437     }
438     
439     // only use to disable contract sales if absolutely necessary (emergency use only)
440     function updateSwapEnabled(bool enabled) external onlyOwner(){
441         swapEnabled = enabled;
442     }
443     
444     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
445         buyMarketingFee = _marketingFee;
446         buyLiquidityFee = _liquidityFee;
447         buyDevFee = _devFee;
448         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
449         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
450     }
451     
452     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
453         sellMarketingFee = _marketingFee;
454         sellLiquidityFee = _liquidityFee;
455         sellDevFee = _devFee;
456         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
457         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
458     }
459 
460     function excludeFromFees(address account, bool excluded) public onlyOwner {
461         _isExcludedFromFees[account] = excluded;
462         emit ExcludeFromFees(account, excluded);
463     }
464 
465     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
466         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
467 
468         _setAutomatedMarketMakerPair(pair, value);
469     }
470 
471     function _setAutomatedMarketMakerPair(address pair, bool value) private {
472         automatedMarketMakerPairs[pair] = value;
473 
474         emit SetAutomatedMarketMakerPair(pair, value);
475     }
476 
477     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
478         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
479         marketingWallet = newMarketingWallet;
480     }
481     
482     function updateDevWallet(address newWallet) external onlyOwner {
483         emit devWalletUpdated(newWallet, devWallet);
484         devWallet = newWallet;
485     }
486     
487 
488     function isExcludedFromFees(address account) public view returns(bool) {
489         return _isExcludedFromFees[account];
490     }
491 
492     function manage_blacklist(address _address, bool status) external onlyOwner {
493         require(_address != address(0),"Address should not be 0");
494         isBlacklisted[_address] = status;
495     }
496 
497     function _transfer(
498         address from,
499         address to,
500         uint256 amount
501     ) internal override {
502         require(from != address(0), "ERC20: transfer from the zero address");
503         require(to != address(0), "ERC20: transfer to the zero address");
504         require(!isBlacklisted[from] && !isBlacklisted[to],"Blacklisted");
505         
506          if(amount == 0) {
507             super._transfer(from, to, 0);
508             return;
509         }
510         
511         if(limitsInEffect){
512             if (
513                 from != owner() &&
514                 to != owner() &&
515                 to != address(0) &&
516                 to != address(0xdead) &&
517                 !swapping
518             ){
519                 if(!tradingActive){
520                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
521                 }
522 
523                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
524                 if (transferDelayEnabled){
525                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
526                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
527                         _holderLastTransferTimestamp[tx.origin] = block.number;
528                     }
529                 }
530                  
531                 //when buy
532                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
533                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
534                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
535                 }
536                 
537                 //when sell
538                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
539                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
540                 }
541                 else if(!_isExcludedMaxTransactionAmount[to]){
542                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
543                 }
544             }
545         }
546         
547 		uint256 contractTokenBalance = balanceOf(address(this));
548         
549         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
550 
551         if( 
552             canSwap &&
553             swapEnabled &&
554             !swapping &&
555             !automatedMarketMakerPairs[from] &&
556             !_isExcludedFromFees[from] &&
557             !_isExcludedFromFees[to]
558         ) {
559             swapping = true;
560             
561             swapBack();
562 
563             swapping = false;
564         }
565 
566         bool takeFee = !swapping;
567 
568         // if any account belongs to _isExcludedFromFee account then remove the fee
569         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
570             takeFee = false;
571         }
572         
573         uint256 fees = 0;
574         // only take fees on buys/sells, do not take on wallet transfers
575         if(takeFee){
576             // on sell
577             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
578                 fees = amount * sellTotalFees/100;
579                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
580                 tokensForDev += fees * sellDevFee / sellTotalFees;
581                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
582             }
583             // on buy
584             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
585         	    fees = amount * buyTotalFees/100;
586         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
587                 tokensForDev += fees * buyDevFee / buyTotalFees;
588                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
589             }
590             
591             if(fees > 0){    
592                 super._transfer(from, address(this), fees);
593             }
594         	
595         	amount -= fees;
596         }
597 
598         super._transfer(from, to, amount);
599     }
600 
601     function swapTokensForEth(uint256 tokenAmount) private {
602 
603         // generate the uniswap pair path of token -> weth
604         address[] memory path = new address[](2);
605         path[0] = address(this);
606         path[1] = uniswapV2Router.WETH();
607 
608         _approve(address(this), address(uniswapV2Router), tokenAmount);
609 
610         // make the swap
611         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
612             tokenAmount,
613             0, // accept any amount of ETH
614             path,
615             address(this),
616             block.timestamp
617         );
618         
619     }
620     
621     
622     
623     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
624         // approve token transfer to cover all possible scenarios
625         _approve(address(this), address(uniswapV2Router), tokenAmount);
626 
627         // add the liquidity
628         uniswapV2Router.addLiquidityETH{value: ethAmount}(
629             address(this),
630             tokenAmount,
631             0, // slippage is unavoidable
632             0, // slippage is unavoidable
633             deadAddress,
634             block.timestamp
635         );
636     }
637 
638     function swapBack() private {
639         uint256 contractBalance = balanceOf(address(this));
640         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
641         bool success;
642 
643         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
644         if(contractBalance > swapTokensAtAmount * 20){
645           contractBalance = swapTokensAtAmount * 20;
646         }
647         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
648         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
649         uint256 initialETHBalance = address(this).balance;
650         swapTokensForEth(amountToSwapForETH); 
651         uint256 ethBalance = address(this).balance - initialETHBalance;
652         uint256 ethForMarketing = ethBalance * tokensForMarketing/totalTokensToSwap;
653         uint256 ethForDev = ethBalance * tokensForDev/totalTokensToSwap;
654         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
655         tokensForLiquidity = 0;
656         tokensForMarketing = 0;
657         tokensForDev = 0;
658         (success,) = address(devWallet).call{value: ethForDev}("");
659         if(liquidityTokens > 0 && ethForLiquidity > 0){
660             addLiquidity(liquidityTokens, ethForLiquidity);
661             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
662         }
663         (success,) = address(marketingWallet).call{value: address(this).balance}("");
664     }
665     
666 
667 }