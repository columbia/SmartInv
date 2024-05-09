1 /*
2                            88          88            88  
3                            ""          88            ""  
4                                        88             
5     8b,dPPYba,  8b,dPPYba, 88  ,adPPYb,88  ,adPPYba, 88 8b,dPPYba, 88      88
6     88P'    "8a 88P'   "Y8 88 a8"    `Y88 a8P_____88 88 88P'   "Y8 88      88
7     88       d8 88         88 8b       88 8PP""""""" 88 88      88 88      88
8     88b,   ,a8" 88         88 "8a,   ,d88 "8b,   ,aa 88 88      88 88    .d88
9     88`YbbdP"'  88         88  `"8bbdP"Y8  `"Ybbd8"' 88 88      88 `"8bbdP"Y8
10     88                                                                                                
11     88                                                
12 
13 A safe, supportive and empowering home for the first crypto LGBTQ+ community!
14 
15 We Believe in a world where all people are free to express their gender identity and sexual orientation with pride.
16 
17 Website:  https://www.prideinu.com/
18 Twitter:  https://twitter.com/inu_pride
19 Telegram: http://t.me/prideinu
20 */
21 /**
22  *Submitted for verification at Etherscan.io on 2022-05-12
23 */
24 
25 // SPDX-License-Identifier: MIT
26 pragma solidity ^0.8.10;
27 
28 /**
29  * ERC20 standard interface
30  */
31 
32 interface ERC20 {
33     function totalSupply() external view returns (uint256);
34     function decimals() external view returns (uint8);
35     function symbol() external view returns (string memory);
36     function name() external view returns (string memory);
37     function getOwner() external view returns (address);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address _owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 /**
48  * Basic access control mechanism
49  */
50 
51 abstract contract Ownable {
52     address internal owner;
53     address private _previousOwner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor(address _owner) {
58         owner = _owner;
59     }
60 
61     modifier onlyOwner() {
62         require(isOwner(msg.sender), "!YOU ARE NOT THE OWNER"); _;
63     }
64 
65     function isOwner(address account) public view returns (bool) {
66         return account == owner;
67     }
68 
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(owner, address(0));
77         owner = address(0);
78     }
79 }
80 
81 /**
82  * Router Interfaces
83  */
84 
85 interface IDEXFactory {
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87 }
88 
89 interface IDEXRouter {
90     function factory() external pure returns (address);
91     function WETH() external pure returns (address);
92 
93     function addLiquidity(
94         address tokenA,
95         address tokenB,
96         uint amountADesired,
97         uint amountBDesired,
98         uint amountAMin,
99         uint amountBMin,
100         address to,
101         uint deadline
102     ) external returns (uint amountA, uint amountB, uint liquidity);
103 
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 
113     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120 
121     function swapExactETHForTokensSupportingFeeOnTransferTokens(
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external payable;
127 
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135 }
136 
137 /**
138  * Token Contract Code
139  */
140 
141 contract PRIDE is ERC20, Ownable {
142     // -- Mappings --
143     mapping(address => bool) public _blacklisted;
144     mapping(address => bool) private _whitelisted;
145     mapping(address => bool) public _automatedMarketMakers;
146     mapping(address => bool) private _isLimitless;
147     mapping(address => uint256) private _balances;
148     mapping(address => mapping(address => uint256)) private _allowances;
149 
150     // -- Basic Token Information --
151     string constant _name = "Pride Inu";
152     string constant _symbol = "$PRIDE";
153     uint8 constant _decimals = 18;
154     uint256 private _totalSupply = 1_000_000_000 * 10 ** _decimals;
155 
156 
157     // -- Transaction & Wallet Limits --
158     uint256 public maxBuyPercentage;
159     uint256 public maxSellPercentage;
160     uint256 public maxWalletPercentage;
161 
162     uint256 private maxBuyAmount;
163     uint256 private maxSellAmount;
164     uint256 private maxWalletAmount;
165 
166     // -- Contract Variables --
167     address[] private sniperList;
168     uint256 tokenTax;
169     uint256 transferFee;
170     uint256 private targetLiquidity = 50;
171 
172     // -- Fee Structs --
173     struct BuyFee {
174         uint256 liquidityFee;
175         uint256 treasuryFee;
176         uint256 marketingFee;
177         uint256 total;
178     }
179 
180     struct SellFee {
181         uint256 liquidityFee;
182         uint256 treasuryFee;
183         uint256 marketingFee;
184         uint256 total;
185     }
186 
187     BuyFee public buyFee;
188     SellFee public sellFee;
189 
190     // -- Addresses --
191     address public _exchangeRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
192     
193     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
194     address private constant ZERO = 0x0000000000000000000000000000000000000000;
195 
196     address public treasuryReceiver = 0x8fA3fF1A8f0E9B6cdd90995419E164e6DB08Bb2C;
197     address public marketingReceiver = 0x8fA3fF1A8f0E9B6cdd90995419E164e6DB08Bb2C;
198 
199     IDEXRouter public router;
200     address public pair;
201 
202     // -- Misc Variables --
203     bool public antiSniperMode = true;  // AntiSniper active at launch by default
204     bool private _addingLP;
205     bool private inSwap;
206     bool private _initialDistributionFinished;
207 
208     // -- Swap Variables --
209     bool public swapEnabled = true;
210     uint256 private swapThreshold = _totalSupply / 1000;
211     
212     modifier swapping() {
213         inSwap = true;
214         _;
215         inSwap = false;
216     }
217 
218     constructor () Ownable(msg.sender) {
219 
220         // Initialize Pancake Pair
221         router = IDEXRouter(_exchangeRouterAddress);
222         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
223         _allowances[address(this)][address(router)] = type(uint256).max;
224         _automatedMarketMakers[pair]=true;
225         
226         // Set Initial Buy Fees -- Base 1000 Set 10 for 1%
227         buyFee.liquidityFee = 0; buyFee.treasuryFee = 0; buyFee.marketingFee = 40;
228         buyFee.total = buyFee.liquidityFee + buyFee.treasuryFee + buyFee.marketingFee;
229 
230         // Set Initial Sell Fees -- Base 1000 Set 10 for 1%
231         sellFee.liquidityFee = 40; sellFee.treasuryFee = 0; sellFee.marketingFee = 160;
232         sellFee.total = sellFee.liquidityFee + sellFee.treasuryFee + sellFee.marketingFee;
233 
234         // Set Initial Buy, Sell & Wallet Limits -- Base 1000 Set 10 for 1%
235         maxBuyPercentage = 10; maxBuyAmount = _totalSupply /1000 * maxBuyPercentage;
236         maxSellPercentage = 10; maxSellAmount = _totalSupply /1000 * maxSellPercentage;
237         maxWalletPercentage = 20; maxWalletAmount = _totalSupply /1000 * maxWalletPercentage;
238 
239         // Exclude from fees & limits
240         _isLimitless[owner] = _isLimitless[address(this)] = true;
241 
242         // Mint _totalSupply to owner address
243         _balances[owner] = _totalSupply;
244         emit Transfer(address(0x0), owner, _totalSupply);
245     }
246 
247 
248     ///////////////////////////////////////// -- Setter Functions -- /////////////////////////////////////////
249 
250         // Use 10 to set 1% -- Base 1000 for easier fine adjust
251     function ownerSetLimits(uint256 _maxBuyPercentage, uint256 _maxSellPercentage, uint256 _maxWalletPercentage) external onlyOwner {
252         maxBuyAmount = _totalSupply /1000 * _maxBuyPercentage;
253         maxSellAmount = _totalSupply /1000 * _maxSellPercentage;
254         maxWalletAmount = _totalSupply /1000 * _maxWalletPercentage;
255     }
256 
257     function ownerSetInitialDistributionFinished() external onlyOwner {
258         _initialDistributionFinished = true;
259     }
260 
261     function ownerSetLimitlessAddress(address _addr, bool _status) external onlyOwner {
262         _isLimitless[_addr] = _status;
263     }
264 
265     function ownerSetSwapBackSettings(bool _enabled, uint256 _percentageBase1000) external onlyOwner {
266         swapEnabled = _enabled;
267         swapThreshold = _totalSupply / 1000 * _percentageBase1000;
268     }
269 
270     function ownerSetTargetLiquidity(uint256 target) external onlyOwner {
271         targetLiquidity = target;
272     }
273        // Use 10 to set 1% -- Base 1000 for easier fine adjust
274     function ownerUpdateBuyFees (uint256 _liquidityFee, uint256 _treasuryFee, uint256 _marketingFee) external onlyOwner {
275         buyFee.liquidityFee = _liquidityFee;
276         buyFee.treasuryFee = _treasuryFee;
277         buyFee.marketingFee = _marketingFee;
278         buyFee.total = buyFee.liquidityFee + buyFee.treasuryFee + buyFee.marketingFee;
279     }
280         // Use 10 to set 1% -- Base 1000 for easier fine adjust
281     function ownerUpdateSellFees (uint256 _liquidityFee, uint256 _treasuryFee, uint256 _marketingFee) external onlyOwner {
282         sellFee.liquidityFee = _liquidityFee;
283         sellFee.treasuryFee = _treasuryFee;
284         sellFee.marketingFee = _marketingFee;
285         sellFee.total = sellFee.liquidityFee + sellFee.treasuryFee + sellFee.marketingFee;
286     }
287         // Use 10 to set 1% -- Base 1000 for easier fine adjust
288     function ownerUpdateTransferFee (uint256 _transferFee) external onlyOwner {
289         transferFee = _transferFee;
290     }
291 
292     function ownerSetReceivers (address _treasury, address _marketing) external onlyOwner {
293         treasuryReceiver = _treasury;
294         marketingReceiver = _marketing;
295     }
296 
297     function ownerAirDropWallets(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner{
298         require(airdropWallets.length < 100, "Can only airdrop 100 wallets per txn due to gas limits");
299         for(uint256 i = 0; i < airdropWallets.length; i++){
300             address wallet = airdropWallets[i];
301             uint256 amount = (amounts[i] * 10**_decimals);
302             _transfer(msg.sender, wallet, amount);
303         }
304     }
305 
306     function reverseSniper(address sniper) external onlyOwner {
307         _blacklisted[sniper] = false;
308     }
309 
310     function addNewMarketMaker(address newAMM) external onlyOwner {
311         _automatedMarketMakers[newAMM]=true;
312         _isLimitless[newAMM]=true;
313     }
314 
315     function controlAntiSniperMode(bool value) external onlyOwner {
316         antiSniperMode = value;
317     }
318 
319     function clearStuckBalance() external onlyOwner {
320         uint256 contractETHBalance = address(this).balance;
321         payable(owner).transfer(contractETHBalance);
322     }
323 
324     function clearStuckToken(address _token) public onlyOwner {
325         uint256 _contractBalance = ERC20(_token).balanceOf(address(this));
326         payable(treasuryReceiver).transfer(_contractBalance);
327     }
328     ///////////////////////////////////////// -- Getter Functions -- /////////////////////////////////////////
329 
330     function getCirculatingSupply() public view returns (uint256) {
331         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
332     }
333 
334     function showSniperList() public view returns(address[] memory){
335         return sniperList;
336     }
337 
338     function showSniperListLength() public view returns(uint256){
339         return sniperList.length;
340     }
341 
342     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
343         return accuracy * (balanceOf(pair) * (2)) / (getCirculatingSupply());
344     }
345 
346     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
347         return getLiquidityBacking(accuracy) > target;
348     }
349 
350     ///////////////////////////////////////// -- Internal Functions -- /////////////////////////////////////////
351 
352     function _transfer(address sender,address recipient,uint256 amount) private {
353         require(sender!=address(0)&&recipient!=address(0),"Cannot be address(0).");
354         bool isBuy=_automatedMarketMakers[sender];
355         bool isSell=_automatedMarketMakers[recipient];
356         bool isExcluded=_isLimitless[sender]||_isLimitless[recipient]||_addingLP;
357 
358         if(isExcluded)_transferExcluded(sender,recipient,amount);
359         else { require(_initialDistributionFinished);
360             // Punish for Snipers
361             if(antiSniperMode)_punishSnipers(sender,recipient,amount);
362             // Buy Tokens
363             else if(isBuy)_buyTokens(sender,recipient,amount);
364             // Sell Tokens
365             else if(isSell) {
366                 // Swap & Liquify
367                 if (shouldSwapBack()) {swapBack();}
368                 _sellTokens(sender,recipient,amount);
369             } else {
370                 // P2P Transfer
371                 require(!_blacklisted[sender]&&!_blacklisted[recipient]);
372                 require(balanceOf(recipient)+amount<=maxWalletAmount);
373                 _P2PTransfer(sender,recipient,amount);
374             }
375         }
376     }
377 
378     function _punishSnipers(address sender,address recipient,uint256 amount) private {
379         require(!_blacklisted[recipient]);
380         require(amount <= maxBuyAmount, "Buy exceeds limit");
381         tokenTax = amount*90/100;
382         _blacklisted[recipient]=true;
383         sniperList.push(address(recipient));
384         _transferIncluded(sender,recipient,amount,tokenTax);
385     }
386 
387     function _buyTokens(address sender,address recipient,uint256 amount) private {
388         require(!_blacklisted[recipient]);
389         require(amount <= maxBuyAmount, "Buy exceeds limit");
390         if(!_whitelisted[recipient]){
391         tokenTax = amount*buyFee.total/1000;}
392         else tokenTax = 0;
393         _transferIncluded(sender,recipient,amount,tokenTax);
394     }
395     function _sellTokens(address sender,address recipient,uint256 amount) private {
396         require(!_blacklisted[sender]);
397         require(amount <= maxSellAmount);
398         if(!_whitelisted[sender]){
399         tokenTax = amount*sellFee.total/1000;}
400         else tokenTax = 0;
401         _transferIncluded(sender,recipient,amount,tokenTax);
402     }
403 
404     function _P2PTransfer(address sender,address recipient,uint256 amount) private {
405         tokenTax = amount * transferFee/1000;
406         if( tokenTax > 0) {_transferIncluded(sender,recipient,amount,tokenTax);}
407         else {_transferExcluded(sender,recipient,amount);}
408     }
409 
410     function _transferExcluded(address sender,address recipient,uint256 amount) private {
411         _updateBalance(sender,_balances[sender]-amount);
412         _updateBalance(recipient,_balances[recipient]+amount);
413         emit Transfer(sender,recipient,amount);
414     }
415 
416     function _transferIncluded(address sender,address recipient,uint256 amount,uint256 taxAmount) private {
417         uint256 newAmount = amount-tokenTax;
418         _updateBalance(sender,_balances[sender]-amount);
419         _updateBalance(address(this),_balances[address(this)]+taxAmount);
420         _updateBalance(recipient,_balances[recipient]+newAmount);
421         emit Transfer(sender,recipient,newAmount);
422         emit Transfer(sender,address(this),taxAmount);
423     }
424 
425     function _updateBalance(address account,uint256 newBalance) private {
426         _balances[account] = newBalance;
427     }
428 
429     function shouldSwapBack() private view returns (bool) {
430         return
431             !inSwap &&
432             swapEnabled &&
433             _balances[address(this)] >= swapThreshold;
434     }   
435 
436     function swapBack() private swapping {
437         uint256 toSwap = balanceOf(address(this));
438 
439         uint256 totalLPTokens=toSwap*(sellFee.liquidityFee + buyFee.liquidityFee)/(sellFee.total + buyFee.total);
440         uint256 tokensLeft=toSwap-totalLPTokens;
441         uint256 LPTokens=totalLPTokens/2;
442         uint256 LPBNBTokens=totalLPTokens-LPTokens;
443         toSwap=tokensLeft+LPBNBTokens;
444         uint256 oldBNB=address(this).balance;
445         _swapTokensForBNB(toSwap);
446         uint256 newBNB=address(this).balance-oldBNB;
447         uint256 LPBNB=(newBNB*LPBNBTokens)/toSwap;
448         _addLiquidity(LPTokens,LPBNB);
449         uint256 remainingBNB=address(this).balance-oldBNB;
450         _distributeBNB(remainingBNB);
451     }
452 
453     function _distributeBNB(uint256 remainingBNB) private {
454         uint256 marketingFee = (buyFee.marketingFee + sellFee.marketingFee);
455         uint256 treasuryFee = (buyFee.treasuryFee + sellFee.treasuryFee);
456         uint256 totalFee = (marketingFee + treasuryFee);
457 
458         uint256 amountBNBmarketing = remainingBNB * (marketingFee) / (totalFee);
459         uint256 amountBNBtreasury = remainingBNB * (treasuryFee) / (totalFee);
460 
461         if(amountBNBtreasury > 0){
462         (bool treasurySuccess, /* bytes memory data */) = payable(treasuryReceiver).call{value: amountBNBtreasury, gas: 30000}("");
463         require(treasurySuccess, "receiver rejected ETH transfer"); }
464         
465         if(amountBNBmarketing > 0){
466         (bool marketingSuccess, /* bytes memory data */) = payable(marketingReceiver).call{value: amountBNBmarketing, gas: 30000}("");
467         require(marketingSuccess, "receiver rejected ETH transfer"); }
468     }
469 
470     function _swapTokensForBNB(uint256 amount) private {
471         address[] memory path=new address[](2);
472         path[0] = address(this);
473         path[1] = router.WETH();
474         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
475             amount,
476             0,
477             path,
478             address(this),
479             block.timestamp
480         );
481     }
482 
483     function _addLiquidity(uint256 amountTokens,uint256 amountBNB) private {
484         _addingLP=true;
485         router.addLiquidityETH{value: amountBNB}(
486             address(this),
487             amountTokens,
488             0,
489             0,
490             treasuryReceiver,
491             block.timestamp
492         );
493         _addingLP=false;
494     }
495 
496 /**
497  * IERC20
498  */
499 
500     receive() external payable { }
501 
502     function totalSupply() external view override returns (uint256) { return _totalSupply; }
503     function decimals() external pure override returns (uint8) { return _decimals; }
504     function symbol() external pure override returns (string memory) { return _symbol; }
505     function name() external pure override returns (string memory) { return _name; }
506     function getOwner() external view override returns (address) { return owner; }
507     function balanceOf(address account) public view override returns (uint256) { return _balances[account];}
508     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender];}
509 
510     function approve(address spender, uint256 amount) public override returns (bool) {
511         _allowances[msg.sender][spender] = amount;
512         emit Approval(msg.sender, spender, amount);
513         return true;
514     }
515 
516     function transfer(address recipient, uint256 amount) public override returns (bool) {
517         _transfer(msg.sender, recipient, amount);
518         return true;
519     }
520 
521     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
522         uint256 allowance_ = _allowances[sender][msg.sender];
523         require(allowance_ >= amount);
524         
525         if (_allowances[sender][msg.sender] != type(uint256).max) {
526             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
527         }
528         _transfer(sender, recipient, amount);
529         return true;
530     }
531 }