1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-12
3 */
4 
5 /**
6  HOPE - $333 - Charity Token 
7  https://t.me/HopeEntryPortal
8  https://twitter.com/hope_erc20
9  https://hopeerc20.medium.com/
10  https://www.reddit.com/r/HopeERC20/
11  http://hope-333.com/
12 
13  A project for the world and for Families suffering from addiction!
14 */
15 
16 // Contract Developer: @TropTerps
17 
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity ^0.8.10;
21 
22 /**
23  * ERC20 standard interface
24  */
25 
26 interface ERC20 {
27     function totalSupply() external view returns (uint256);
28     function decimals() external view returns (uint8);
29     function symbol() external view returns (string memory);
30     function name() external view returns (string memory);
31     function getOwner() external view returns (address);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address _owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 /**
42  * Basic access control mechanism
43  */
44 
45 abstract contract Ownable {
46     address internal owner;
47     address private _previousOwner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     constructor(address _owner) {
52         owner = _owner;
53     }
54 
55     modifier onlyOwner() {
56         require(isOwner(msg.sender), "!YOU ARE NOT THE OWNER"); _;
57     }
58 
59     function isOwner(address account) public view returns (bool) {
60         return account == owner;
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         emit OwnershipTransferred(owner, address(0));
71         owner = address(0);
72     }
73 }
74 
75 /**
76  * Router Interfaces
77  */
78 
79 interface IDEXFactory {
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81 }
82 
83 interface IDEXRouter {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86 
87     function addLiquidity(
88         address tokenA,
89         address tokenB,
90         uint amountADesired,
91         uint amountBDesired,
92         uint amountAMin,
93         uint amountBMin,
94         address to,
95         uint deadline
96     ) external returns (uint amountA, uint amountB, uint liquidity);
97 
98     function addLiquidityETH(
99         address token,
100         uint amountTokenDesired,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline
105     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
106 
107     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114 
115     function swapExactETHForTokensSupportingFeeOnTransferTokens(
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external payable;
121 
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external;
129 }
130 
131 /**
132  * Token Contract Code
133  */
134 
135 contract HOPE is ERC20, Ownable {
136     // -- Mappings --
137     mapping(address => bool) public _blacklisted;
138     mapping(address => bool) private _whitelisted;
139     mapping(address => bool) public _automatedMarketMakers;
140     mapping(address => bool) private _isLimitless;
141     mapping(address => uint256) private _balances;
142     mapping(address => mapping(address => uint256)) private _allowances;
143 
144     // -- Basic Token Information --
145     string constant _name = "Hope Protocol";
146     string constant _symbol = "$333";
147     uint8 constant _decimals = 18;
148     uint256 private _totalSupply = 100_000_000 * 10 ** _decimals;
149 
150 
151     // -- Transaction & Wallet Limits --
152     uint256 public maxBuyPercentage;
153     uint256 public maxSellPercentage;
154     uint256 public maxWalletPercentage;
155 
156     uint256 private maxBuyAmount;
157     uint256 private maxSellAmount;
158     uint256 private maxWalletAmount;
159 
160     // -- Contract Variables --
161     address[] private sniperList;
162     uint256 tokenTax;
163     uint256 transferFee;
164     uint256 private targetLiquidity = 50;
165 
166     // -- Fee Structs --
167     struct BuyFee {
168         uint256 liquidityFee;
169         uint256 charityfee;
170         uint256 marketingfee;
171         uint256 total;
172     }
173 
174     struct SellFee {
175         uint256 liquidityFee;
176         uint256 charityfee;
177         uint256 marketingfee;
178         uint256 total;
179     }
180 
181     BuyFee public buyFee;
182     SellFee public sellFee;
183 
184     // -- Addresses --
185     address public _exchangeRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
186     
187     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
188     address private constant ZERO = 0x0000000000000000000000000000000000000000;
189 
190     address public charityReciever = 0xbc690598d58ccD9662f67B8e3e7f4BBBe28A876E;
191     address public marketingReceiver = 0x54239ee6EE31ed26fEf4f4749b9f2d6A7B5a8239;
192 
193     IDEXRouter public router;
194     address public pair;
195 
196     // -- Misc Variables --
197     bool public antiSniperMode = true;  // AntiSniper active at launch by default
198     bool private _addingLP;
199     bool private inSwap;
200     bool private _initialDistributionFinished;
201 
202     // -- Swap Variables --
203     bool public swapEnabled = true;
204     uint256 private swapThreshold = _totalSupply / 1000;
205     
206     modifier swapping() {
207         inSwap = true;
208         _;
209         inSwap = false;
210     }
211 
212     constructor () Ownable(msg.sender) {
213 
214         // Initialize Pancake Pair
215         router = IDEXRouter(_exchangeRouterAddress);
216         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
217         _allowances[address(this)][address(router)] = type(uint256).max;
218         _automatedMarketMakers[pair]=true;
219         
220         // Set Initial Buy Fees -- Base 1000 Set 10 for 1%
221         buyFee.liquidityFee = 0; buyFee.charityfee = 30; buyFee.marketingfee = 20;
222         buyFee.total = buyFee.liquidityFee + buyFee.charityfee + buyFee.marketingfee;
223 
224         // Set Initial Sell Fees -- Base 1000 Set 10 for 1%
225         sellFee.liquidityFee = 30; sellFee.charityfee = 30; sellFee.marketingfee = 20;
226         sellFee.total = sellFee.liquidityFee + sellFee.charityfee + sellFee.marketingfee;
227 
228         // Set Initial Buy, Sell & Wallet Limits -- Base 1000 Set 10 for 1%
229         maxBuyPercentage = 20; maxBuyAmount = _totalSupply /1000 * maxBuyPercentage;
230         maxSellPercentage = 10; maxSellAmount = _totalSupply /1000 * maxSellPercentage;
231         maxWalletPercentage = 20; maxWalletAmount = _totalSupply /1000 * maxWalletPercentage;
232 
233         // Exclude from fees & limits
234         _isLimitless[owner] = _isLimitless[address(this)] = true;
235 
236         // Mint _totalSupply to owner address
237         _balances[owner] = _totalSupply;
238         emit Transfer(address(0x0), owner, _totalSupply);
239     }
240 
241 
242     ///////////////////////////////////////// -- Setter Functions -- /////////////////////////////////////////
243 
244         // Use 10 to set 1% -- Base 1000 for easier fine adjust
245     function ownerSetLimits(uint256 _maxBuyPercentage, uint256 _maxSellPercentage, uint256 _maxWalletPercentage) external onlyOwner {
246         maxBuyAmount = _totalSupply /1000 * _maxBuyPercentage;
247         maxSellAmount = _totalSupply /1000 * _maxSellPercentage;
248         maxWalletAmount = _totalSupply /1000 * _maxWalletPercentage;
249     }
250 
251     function ownerSetInitialDistributionFinished() external onlyOwner {
252         _initialDistributionFinished = true;
253     }
254 
255     function ownerSetLimitlessAddress(address _addr, bool _status) external onlyOwner {
256         _isLimitless[_addr] = _status;
257     }
258 
259     function ownerSetSwapBackSettings(bool _enabled, uint256 _percentageBase1000) external onlyOwner {
260         swapEnabled = _enabled;
261         swapThreshold = _totalSupply / 1000 * _percentageBase1000;
262     }
263 
264     function ownerSetTargetLiquidity(uint256 target) external onlyOwner {
265         targetLiquidity = target;
266     }
267        // Use 10 to set 1% -- Base 1000 for easier fine adjust
268     function ownerUpdateBuyFees (uint256 _liquidityFee, uint256 _charityfee, uint256 _marketingfee) external onlyOwner {
269         buyFee.liquidityFee = _liquidityFee;
270         buyFee.charityfee = _charityfee;
271         buyFee.marketingfee = _marketingfee;
272         buyFee.total = buyFee.liquidityFee + buyFee.charityfee + buyFee.marketingfee;
273     }
274         // Use 10 to set 1% -- Base 1000 for easier fine adjust
275     function ownerUpdateSellFees (uint256 _liquidityFee, uint256 _charityfee, uint256 _marketingfee) external onlyOwner {
276         sellFee.liquidityFee = _liquidityFee;
277         sellFee.charityfee = _charityfee;
278         sellFee.marketingfee = _marketingfee;
279         sellFee.total = sellFee.liquidityFee + sellFee.charityfee + sellFee.marketingfee;
280     }
281         // Use 10 to set 1% -- Base 1000 for easier fine adjust
282     function ownerUpdateTransferFee (uint256 _transferFee) external onlyOwner {
283         transferFee = _transferFee;
284     }
285 
286     function ownerSetReceivers (address _charity, address _marketing) external onlyOwner {
287         charityReciever = _charity;
288         marketingReceiver = _marketing;
289     }
290 
291     function ownerAirDropWallets(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner{
292         require(airdropWallets.length < 100, "Can only airdrop 100 wallets per txn due to gas limits");
293         for(uint256 i = 0; i < airdropWallets.length; i++){
294             address wallet = airdropWallets[i];
295             uint256 amount = (amounts[i] * 10**_decimals);
296             _transfer(msg.sender, wallet, amount);
297         }
298     }
299 
300     function reverseSniper(address sniper) external onlyOwner {
301         _blacklisted[sniper] = false;
302     }
303 
304     function addNewMarketMaker(address newAMM) external onlyOwner {
305         _automatedMarketMakers[newAMM]=true;
306         _isLimitless[newAMM]=true;
307     }
308 
309     function controlAntiSniperMode(bool value) external onlyOwner {
310         antiSniperMode = value;
311     }
312 
313     function clearStuckBalance() external onlyOwner {
314         uint256 contractETHBalance = address(this).balance;
315         payable(owner).transfer(contractETHBalance);
316     }
317 
318     function clearStuckToken(address _token) public onlyOwner {
319         uint256 _contractBalance = ERC20(_token).balanceOf(address(this));
320         payable(charityReciever).transfer(_contractBalance);
321     }
322     ///////////////////////////////////////// -- Getter Functions -- /////////////////////////////////////////
323 
324     function getCirculatingSupply() public view returns (uint256) {
325         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
326     }
327 
328     function showSniperList() public view returns(address[] memory){
329         return sniperList;
330     }
331 
332     function showSniperListLength() public view returns(uint256){
333         return sniperList.length;
334     }
335 
336     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
337         return accuracy * (balanceOf(pair) * (2)) / (getCirculatingSupply());
338     }
339 
340     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
341         return getLiquidityBacking(accuracy) > target;
342     }
343 
344     ///////////////////////////////////////// -- Internal Functions -- /////////////////////////////////////////
345 
346     function _transfer(address sender,address recipient,uint256 amount) private {
347         require(sender!=address(0)&&recipient!=address(0),"Cannot be address(0).");
348         bool isBuy=_automatedMarketMakers[sender];
349         bool isSell=_automatedMarketMakers[recipient];
350         bool isExcluded=_isLimitless[sender]||_isLimitless[recipient]||_addingLP;
351 
352         if(isExcluded)_transferExcluded(sender,recipient,amount);
353         else { require(_initialDistributionFinished);
354             // Punish for Snipers
355             if(antiSniperMode)_punishSnipers(sender,recipient,amount);
356             // Buy Tokens
357             else if(isBuy)_buyTokens(sender,recipient,amount);
358             // Sell Tokens
359             else if(isSell) {
360                 // Swap & Liquify
361                 if (shouldSwapBack()) {swapBack();}
362                 _sellTokens(sender,recipient,amount);
363             } else {
364                 // P2P Transfer
365                 require(!_blacklisted[sender]&&!_blacklisted[recipient]);
366                 require(balanceOf(recipient)+amount<=maxWalletAmount);
367                 _P2PTransfer(sender,recipient,amount);
368             }
369         }
370     }
371 
372     function _punishSnipers(address sender,address recipient,uint256 amount) private {
373         require(!_blacklisted[recipient]);
374         require(amount <= maxBuyAmount, "Buy exceeds limit");
375         tokenTax = amount*90/100;
376         _blacklisted[recipient]=true;
377         sniperList.push(address(recipient));
378         _transferIncluded(sender,recipient,amount,tokenTax);
379     }
380 
381     function _buyTokens(address sender,address recipient,uint256 amount) private {
382         require(!_blacklisted[recipient]);
383         require(amount <= maxBuyAmount, "Buy exceeds limit");
384         if(!_whitelisted[recipient]){
385         tokenTax = amount*buyFee.total/1000;}
386         else tokenTax = 0;
387         _transferIncluded(sender,recipient,amount,tokenTax);
388     }
389     function _sellTokens(address sender,address recipient,uint256 amount) private {
390         require(!_blacklisted[sender]);
391         require(amount <= maxSellAmount);
392         if(!_whitelisted[sender]){
393         tokenTax = amount*sellFee.total/1000;}
394         else tokenTax = 0;
395         _transferIncluded(sender,recipient,amount,tokenTax);
396     }
397 
398     function _P2PTransfer(address sender,address recipient,uint256 amount) private {
399         tokenTax = amount * transferFee/1000;
400         if( tokenTax > 0) {_transferIncluded(sender,recipient,amount,tokenTax);}
401         else {_transferExcluded(sender,recipient,amount);}
402     }
403 
404     function _transferExcluded(address sender,address recipient,uint256 amount) private {
405         _updateBalance(sender,_balances[sender]-amount);
406         _updateBalance(recipient,_balances[recipient]+amount);
407         emit Transfer(sender,recipient,amount);
408     }
409 
410     function _transferIncluded(address sender,address recipient,uint256 amount,uint256 taxAmount) private {
411         uint256 newAmount = amount-tokenTax;
412         _updateBalance(sender,_balances[sender]-amount);
413         _updateBalance(address(this),_balances[address(this)]+taxAmount);
414         _updateBalance(recipient,_balances[recipient]+newAmount);
415         emit Transfer(sender,recipient,newAmount);
416         emit Transfer(sender,address(this),taxAmount);
417     }
418 
419     function _updateBalance(address account,uint256 newBalance) private {
420         _balances[account] = newBalance;
421     }
422 
423     function shouldSwapBack() private view returns (bool) {
424         return
425             !inSwap &&
426             swapEnabled &&
427             _balances[address(this)] >= swapThreshold;
428     }   
429 
430     function swapBack() private swapping {
431         uint256 toSwap = balanceOf(address(this));
432 
433         uint256 totalLPTokens=toSwap*(sellFee.liquidityFee + buyFee.liquidityFee)/(sellFee.total + buyFee.total);
434         uint256 tokensLeft=toSwap-totalLPTokens;
435         uint256 LPTokens=totalLPTokens/2;
436         uint256 LPBNBTokens=totalLPTokens-LPTokens;
437         toSwap=tokensLeft+LPBNBTokens;
438         uint256 oldBNB=address(this).balance;
439         _swapTokensForBNB(toSwap);
440         uint256 newBNB=address(this).balance-oldBNB;
441         uint256 LPBNB=(newBNB*LPBNBTokens)/toSwap;
442         _addLiquidity(LPTokens,LPBNB);
443         uint256 remainingBNB=address(this).balance-oldBNB;
444         _distributeBNB(remainingBNB);
445     }
446 
447     function _distributeBNB(uint256 remainingBNB) private {
448         uint256 marketingfee = (buyFee.marketingfee + sellFee.marketingfee);
449         uint256 charityfee = (buyFee.charityfee + sellFee.charityfee);
450         uint256 totalFee = (marketingfee + charityfee);
451 
452         uint256 amountBNBmarketing = remainingBNB * (marketingfee) / (totalFee);
453         uint256 amountBNBcharity = remainingBNB * (charityfee) / (totalFee);
454 
455         if(amountBNBcharity > 0){
456         (bool charitySuccess, /* bytes memory data */) = payable(charityReciever).call{value: amountBNBcharity, gas: 30000}("");
457         require(charitySuccess, "receiver rejected ETH transfer"); }
458         
459         if(amountBNBmarketing > 0){
460         (bool marketingSuccess, /* bytes memory data */) = payable(marketingReceiver).call{value: amountBNBmarketing, gas: 30000}("");
461         require(marketingSuccess, "receiver rejected ETH transfer"); }
462     }
463 
464     function _swapTokensForBNB(uint256 amount) private {
465         address[] memory path=new address[](2);
466         path[0] = address(this);
467         path[1] = router.WETH();
468         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
469             amount,
470             0,
471             path,
472             address(this),
473             block.timestamp
474         );
475     }
476 
477     function _addLiquidity(uint256 amountTokens,uint256 amountBNB) private {
478         _addingLP=true;
479         router.addLiquidityETH{value: amountBNB}(
480             address(this),
481             amountTokens,
482             0,
483             0,
484             marketingReceiver,
485             block.timestamp
486         );
487         _addingLP=false;
488     }
489 
490 /**
491  * IERC20
492  */
493 
494     receive() external payable { }
495 
496     function totalSupply() external view override returns (uint256) { return _totalSupply; }
497     function decimals() external pure override returns (uint8) { return _decimals; }
498     function symbol() external pure override returns (string memory) { return _symbol; }
499     function name() external pure override returns (string memory) { return _name; }
500     function getOwner() external view override returns (address) { return owner; }
501     function balanceOf(address account) public view override returns (uint256) { return _balances[account];}
502     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender];}
503 
504     function approve(address spender, uint256 amount) public override returns (bool) {
505         _allowances[msg.sender][spender] = amount;
506         emit Approval(msg.sender, spender, amount);
507         return true;
508     }
509 
510     function transfer(address recipient, uint256 amount) public override returns (bool) {
511         _transfer(msg.sender, recipient, amount);
512         return true;
513     }
514 
515     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
516         uint256 allowance_ = _allowances[sender][msg.sender];
517         require(allowance_ >= amount);
518         
519         if (_allowances[sender][msg.sender] != type(uint256).max) {
520             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
521         }
522         _transfer(sender, recipient, amount);
523         return true;
524     }
525 }