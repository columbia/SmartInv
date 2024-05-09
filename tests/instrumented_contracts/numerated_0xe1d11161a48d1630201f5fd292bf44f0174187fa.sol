1 /**
2  Hurricane Ian - $IAN - ERC20
3 
4  https://t.me/HurricaneIanErc20
5  https://twitter.com/HurricaneIanErc20
6 
7  Disaster relief for HURRICANE IAN! 
8  Teh wind blows... Teh eth flows...
9 
10 Buy Tax - 4%
11 
12 3% Relief 
13 1% Marketing
14 
15 Sell Tax - 5%
16 
17 3% Relief 
18 1% Marketing
19 1% Liquidity
20 
21 */
22 
23 // Contract Developer: @RyoshiResearch
24 
25 
26 // SPDX-License-Identifier: MIT
27 pragma solidity ^0.8.10;
28 
29 /**
30  * ERC20 standard interface
31  */
32 
33 interface ERC20 {
34     function totalSupply() external view returns (uint256);
35     function decimals() external view returns (uint8);
36     function symbol() external view returns (string memory);
37     function name() external view returns (string memory);
38     function getOwner() external view returns (address);
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external returns (bool);
41     function allowance(address _owner, address spender) external view returns (uint256);
42     function approve(address spender, uint256 amount) external returns (bool);
43     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 /**
49  * Basic access control mechanism
50  */
51 
52 abstract contract Ownable {
53     address internal owner;
54     address private _previousOwner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     constructor(address _owner) {
59         owner = _owner;
60     }
61 
62     modifier onlyOwner() {
63         require(isOwner(msg.sender), "!YOU ARE NOT THE OWNER"); _;
64     }
65 
66     function isOwner(address account) public view returns (bool) {
67         return account == owner;
68     }
69 
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(owner, address(0));
78         owner = address(0);
79     }
80 }
81 
82 /**
83  * Router Interfaces
84  */
85 
86 interface IDEXFactory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IDEXRouter {
91     function factory() external pure returns (address);
92     function WETH() external pure returns (address);
93 
94     function addLiquidity(
95         address tokenA,
96         address tokenB,
97         uint amountADesired,
98         uint amountBDesired,
99         uint amountAMin,
100         uint amountBMin,
101         address to,
102         uint deadline
103     ) external returns (uint amountA, uint amountB, uint liquidity);
104 
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 
114     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121 
122     function swapExactETHForTokensSupportingFeeOnTransferTokens(
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external payable;
128 
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136 }
137 
138 /**
139  * Token Contract Code
140  */
141 
142 contract IAN is ERC20, Ownable {
143     // -- Mappings --
144     mapping(address => bool) public _blacklisted;
145     mapping(address => bool) private _whitelisted;
146     mapping(address => bool) public _automatedMarketMakers;
147     mapping(address => bool) private _isLimitless;
148     mapping(address => uint256) private _balances;
149     mapping(address => mapping(address => uint256)) private _allowances;
150 
151     // -- Basic Token Information --
152     string constant _name = "Hurricane Ian";
153     string constant _symbol = "IAN";
154     uint8 constant _decimals = 18;
155     uint256 private _totalSupply = 100_000_000 * 10 ** _decimals;
156 
157 
158     // -- Transaction & Wallet Limits --
159     uint256 public maxBuyPercentage;
160     uint256 public maxSellPercentage;
161     uint256 public maxWalletPercentage;
162 
163     uint256 private maxBuyAmount;
164     uint256 private maxSellAmount;
165     uint256 private maxWalletAmount;
166 
167     // -- Contract Variables --
168     address[] private sniperList;
169     uint256 tokenTax;
170     uint256 transferFee;
171     uint256 private targetLiquidity = 50;
172 
173     // -- Fee Structs --
174     struct BuyFee {
175         uint256 liquidityFee;
176         uint256 reliefFee;
177         uint256 marketingFee;
178         uint256 total;
179     }
180 
181     struct SellFee {
182         uint256 liquidityFee;
183         uint256 reliefFee;
184         uint256 marketingFee;
185         uint256 total;
186     }
187 
188     BuyFee public buyFee;
189     SellFee public sellFee;
190 
191     // -- Addresses --
192     address public _exchangeRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
193     
194     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
195     address private constant ZERO = 0x0000000000000000000000000000000000000000;
196 
197     address public reliefReceiver = 0x50D87140e8A04051591E62fF0135704d56D820Cc;
198     address public marketingReceiver = 0xf610E9B4Da81351fb46FA65bD4A1FB27451adF3f;
199 
200     IDEXRouter public router;
201     address public pair;
202 
203     // -- Misc Variables --
204     bool public antiSniperMode = true;  // AntiSniper active at launch by default
205     bool private _addingLP;
206     bool private inSwap;
207     bool private _initialDistributionFinished;
208 
209     // -- Swap Variables --
210     bool public swapEnabled = true;
211     uint256 private swapThreshold = _totalSupply / 1000;
212     
213     modifier swapping() {
214         inSwap = true;
215         _;
216         inSwap = false;
217     }
218 
219     constructor () Ownable(msg.sender) {
220 
221         // Initialize Pancake Pair
222         router = IDEXRouter(_exchangeRouterAddress);
223         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
224         _allowances[address(this)][address(router)] = type(uint256).max;
225         _automatedMarketMakers[pair]=true;
226         
227         // Set Initial Buy Fees -- Base 1000 Set 10 for 1%
228         buyFee.liquidityFee = 0; buyFee.reliefFee = 30; buyFee.marketingFee = 10;
229         buyFee.total = buyFee.liquidityFee + buyFee.reliefFee + buyFee.marketingFee;
230 
231         // Set Initial Sell Fees -- Base 1000 Set 10 for 1%
232         sellFee.liquidityFee = 10; sellFee.reliefFee = 30; sellFee.marketingFee = 10;
233         sellFee.total = sellFee.liquidityFee + sellFee.reliefFee + sellFee.marketingFee;
234 
235         // Set Initial Buy, Sell & Wallet Limits -- Base 1000 Set 10 for 1%
236         maxBuyPercentage = 10; maxBuyAmount = _totalSupply /1000 * maxBuyPercentage;
237         maxSellPercentage = 10; maxSellAmount = _totalSupply /1000 * maxSellPercentage;
238         maxWalletPercentage = 15; maxWalletAmount = _totalSupply /1000 * maxWalletPercentage;
239 
240         // Exclude from fees & limits
241         _isLimitless[owner] = _isLimitless[address(this)] = true;
242 
243         // Mint _totalSupply to owner address
244         _balances[owner] = _totalSupply;
245         emit Transfer(address(0x0), owner, _totalSupply);
246     }
247 
248 
249     ///////////////////////////////////////// -- Setter Functions -- /////////////////////////////////////////
250 
251         // Use 10 to set 1% -- Base 1000 for easier fine adjust
252     function ownerSetLimits(uint256 _maxBuyPercentage, uint256 _maxSellPercentage, uint256 _maxWalletPercentage) external onlyOwner {
253         maxBuyAmount = _totalSupply /1000 * _maxBuyPercentage;
254         maxSellAmount = _totalSupply /1000 * _maxSellPercentage;
255         maxWalletAmount = _totalSupply /1000 * _maxWalletPercentage;
256     }
257 
258     function ownerSetInitialDistributionFinished() external onlyOwner {
259         _initialDistributionFinished = true;
260     }
261 
262     function ownerSetLimitlessAddress(address _addr, bool _status) external onlyOwner {
263         _isLimitless[_addr] = _status;
264     }
265 
266     function ownerSetSwapBackSettings(bool _enabled, uint256 _percentageBase1000) external onlyOwner {
267         swapEnabled = _enabled;
268         swapThreshold = _totalSupply / 1000 * _percentageBase1000;
269     }
270 
271     function ownerSetTargetLiquidity(uint256 target) external onlyOwner {
272         targetLiquidity = target;
273     }
274        // Use 10 to set 1% -- Base 1000 for easier fine adjust
275     function ownerUpdateBuyFees (uint256 _liquidityFee, uint256 _reliefFee, uint256 _marketingFee) external onlyOwner {
276         buyFee.liquidityFee = _liquidityFee;
277         buyFee.reliefFee = _reliefFee;
278         buyFee.marketingFee = _marketingFee;
279         buyFee.total = buyFee.liquidityFee + buyFee.reliefFee + buyFee.marketingFee;
280     }
281         // Use 10 to set 1% -- Base 1000 for easier fine adjust
282     function ownerUpdateSellFees (uint256 _liquidityFee, uint256 _reliefFee, uint256 _marketingFee) external onlyOwner {
283         sellFee.liquidityFee = _liquidityFee;
284         sellFee.reliefFee = _reliefFee;
285         sellFee.marketingFee = _marketingFee;
286         sellFee.total = sellFee.liquidityFee + sellFee.reliefFee + sellFee.marketingFee;
287     }
288         // Use 10 to set 1% -- Base 1000 for easier fine adjust
289     function ownerUpdateTransferFee (uint256 _transferFee) external onlyOwner {
290         transferFee = _transferFee;
291     }
292 
293     function ownerSetReceivers (address _relief, address _marketing) external onlyOwner {
294         reliefReceiver = _relief;
295         marketingReceiver = _marketing;
296     }
297 
298     function ownerAirDropWallets(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner{
299         require(airdropWallets.length < 100, "Can only airdrop 100 wallets per txn due to gas limits");
300         for(uint256 i = 0; i < airdropWallets.length; i++){
301             address wallet = airdropWallets[i];
302             uint256 amount = (amounts[i] * 10**_decimals);
303             _transfer(msg.sender, wallet, amount);
304         }
305     }
306 
307     function reverseSniper(address sniper) external onlyOwner {
308         _blacklisted[sniper] = false;
309     }
310 
311     function addNewMarketMaker(address newAMM) external onlyOwner {
312         _automatedMarketMakers[newAMM]=true;
313         _isLimitless[newAMM]=true;
314     }
315 
316     function controlAntiSniperMode(bool value) external onlyOwner {
317         antiSniperMode = value;
318     }
319 
320     function clearStuckBalance() external onlyOwner {
321         uint256 contractETHBalance = address(this).balance;
322         payable(owner).transfer(contractETHBalance);
323     }
324 
325     function clearStuckToken(address _token) public onlyOwner {
326         uint256 _contractBalance = ERC20(_token).balanceOf(address(this));
327         payable(reliefReceiver).transfer(_contractBalance);
328     }
329     ///////////////////////////////////////// -- Getter Functions -- /////////////////////////////////////////
330 
331     function getCirculatingSupply() public view returns (uint256) {
332         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
333     }
334 
335     function showSniperList() public view returns(address[] memory){
336         return sniperList;
337     }
338 
339     function showSniperListLength() public view returns(uint256){
340         return sniperList.length;
341     }
342 
343     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
344         return accuracy * (balanceOf(pair) * (2)) / (getCirculatingSupply());
345     }
346 
347     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
348         return getLiquidityBacking(accuracy) > target;
349     }
350 
351     ///////////////////////////////////////// -- Internal Functions -- /////////////////////////////////////////
352 
353     function _transfer(address sender,address recipient,uint256 amount) private {
354         require(sender!=address(0)&&recipient!=address(0),"Cannot be address(0).");
355         bool isBuy=_automatedMarketMakers[sender];
356         bool isSell=_automatedMarketMakers[recipient];
357         bool isExcluded=_isLimitless[sender]||_isLimitless[recipient]||_addingLP;
358 
359         if(isExcluded)_transferExcluded(sender,recipient,amount);
360         else { require(_initialDistributionFinished);
361             // Punish for Snipers
362             if(antiSniperMode)_punishSnipers(sender,recipient,amount);
363             // Buy Tokens
364             else if(isBuy)_buyTokens(sender,recipient,amount);
365             // Sell Tokens
366             else if(isSell) {
367                 // Swap & Liquify
368                 if (shouldSwapBack()) {swapBack();}
369                 _sellTokens(sender,recipient,amount);
370             } else {
371                 // P2P Transfer
372                 require(!_blacklisted[sender]&&!_blacklisted[recipient]);
373                 require(balanceOf(recipient)+amount<=maxWalletAmount);
374                 _P2PTransfer(sender,recipient,amount);
375             }
376         }
377     }
378 
379     function _punishSnipers(address sender,address recipient,uint256 amount) private {
380         require(!_blacklisted[recipient]);
381         require(amount <= maxBuyAmount, "Buy exceeds limit");
382         tokenTax = amount*90/100;
383         _blacklisted[recipient]=true;
384         sniperList.push(address(recipient));
385         _transferIncluded(sender,recipient,amount,tokenTax);
386     }
387 
388     function _buyTokens(address sender,address recipient,uint256 amount) private {
389         require(!_blacklisted[recipient]);
390         require(amount <= maxBuyAmount, "Buy exceeds limit");
391         if(!_whitelisted[recipient]){
392         tokenTax = amount*buyFee.total/1000;}
393         else tokenTax = 0;
394         _transferIncluded(sender,recipient,amount,tokenTax);
395     }
396     function _sellTokens(address sender,address recipient,uint256 amount) private {
397         require(!_blacklisted[sender]);
398         require(amount <= maxSellAmount);
399         if(!_whitelisted[sender]){
400         tokenTax = amount*sellFee.total/1000;}
401         else tokenTax = 0;
402         _transferIncluded(sender,recipient,amount,tokenTax);
403     }
404 
405     function _P2PTransfer(address sender,address recipient,uint256 amount) private {
406         tokenTax = amount * transferFee/1000;
407         if( tokenTax > 0) {_transferIncluded(sender,recipient,amount,tokenTax);}
408         else {_transferExcluded(sender,recipient,amount);}
409     }
410 
411     function _transferExcluded(address sender,address recipient,uint256 amount) private {
412         _updateBalance(sender,_balances[sender]-amount);
413         _updateBalance(recipient,_balances[recipient]+amount);
414         emit Transfer(sender,recipient,amount);
415     }
416 
417     function _transferIncluded(address sender,address recipient,uint256 amount,uint256 taxAmount) private {
418         uint256 newAmount = amount-tokenTax;
419         _updateBalance(sender,_balances[sender]-amount);
420         _updateBalance(address(this),_balances[address(this)]+taxAmount);
421         _updateBalance(recipient,_balances[recipient]+newAmount);
422         emit Transfer(sender,recipient,newAmount);
423         emit Transfer(sender,address(this),taxAmount);
424     }
425 
426     function _updateBalance(address account,uint256 newBalance) private {
427         _balances[account] = newBalance;
428     }
429 
430     function shouldSwapBack() private view returns (bool) {
431         return
432             !inSwap &&
433             swapEnabled &&
434             _balances[address(this)] >= swapThreshold;
435     }   
436 
437     function swapBack() private swapping {
438         uint256 toSwap = balanceOf(address(this));
439 
440         uint256 totalLPTokens=toSwap*(sellFee.liquidityFee + buyFee.liquidityFee)/(sellFee.total + buyFee.total);
441         uint256 tokensLeft=toSwap-totalLPTokens;
442         uint256 LPTokens=totalLPTokens/2;
443         uint256 LPBNBTokens=totalLPTokens-LPTokens;
444         toSwap=tokensLeft+LPBNBTokens;
445         uint256 oldBNB=address(this).balance;
446         _swapTokensForBNB(toSwap);
447         uint256 newBNB=address(this).balance-oldBNB;
448         uint256 LPBNB=(newBNB*LPBNBTokens)/toSwap;
449         _addLiquidity(LPTokens,LPBNB);
450         uint256 remainingBNB=address(this).balance-oldBNB;
451         _distributeBNB(remainingBNB);
452     }
453 
454     function _distributeBNB(uint256 remainingBNB) private {
455         uint256 marketingFee = (buyFee.marketingFee + sellFee.marketingFee);
456         uint256 reliefFee = (buyFee.reliefFee + sellFee.reliefFee);
457         uint256 totalFee = (marketingFee + reliefFee);
458 
459         uint256 amountBNBmarketing = remainingBNB * (marketingFee) / (totalFee);
460         uint256 amountBNBrelief = remainingBNB * (reliefFee) / (totalFee);
461 
462         if(amountBNBrelief > 0){
463         (bool reliefSuccess, /* bytes memory data */) = payable(reliefReceiver).call{value: amountBNBrelief, gas: 30000}("");
464         require(reliefSuccess, "receiver rejected ETH transfer"); }
465         
466         if(amountBNBmarketing > 0){
467         (bool marketingSuccess, /* bytes memory data */) = payable(marketingReceiver).call{value: amountBNBmarketing, gas: 30000}("");
468         require(marketingSuccess, "receiver rejected ETH transfer"); }
469     }
470 
471     function _swapTokensForBNB(uint256 amount) private {
472         address[] memory path=new address[](2);
473         path[0] = address(this);
474         path[1] = router.WETH();
475         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
476             amount,
477             0,
478             path,
479             address(this),
480             block.timestamp
481         );
482     }
483 
484     function _addLiquidity(uint256 amountTokens,uint256 amountBNB) private {
485         _addingLP=true;
486         router.addLiquidityETH{value: amountBNB}(
487             address(this),
488             amountTokens,
489             0,
490             0,
491             reliefReceiver,
492             block.timestamp
493         );
494         _addingLP=false;
495     }
496 
497 /**
498  * IERC20
499  */
500 
501     receive() external payable { }
502 
503     function totalSupply() external view override returns (uint256) { return _totalSupply; }
504     function decimals() external pure override returns (uint8) { return _decimals; }
505     function symbol() external pure override returns (string memory) { return _symbol; }
506     function name() external pure override returns (string memory) { return _name; }
507     function getOwner() external view override returns (address) { return owner; }
508     function balanceOf(address account) public view override returns (uint256) { return _balances[account];}
509     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender];}
510 
511     function approve(address spender, uint256 amount) public override returns (bool) {
512         _allowances[msg.sender][spender] = amount;
513         emit Approval(msg.sender, spender, amount);
514         return true;
515     }
516 
517     function transfer(address recipient, uint256 amount) public override returns (bool) {
518         _transfer(msg.sender, recipient, amount);
519         return true;
520     }
521 
522     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
523         uint256 allowance_ = _allowances[sender][msg.sender];
524         require(allowance_ >= amount);
525         
526         if (_allowances[sender][msg.sender] != type(uint256).max) {
527             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
528         }
529         _transfer(sender, recipient, amount);
530         return true;
531     }
532 }