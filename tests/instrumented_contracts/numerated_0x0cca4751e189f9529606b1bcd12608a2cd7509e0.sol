1 /**
2 
3 Sergar Momma - $MAM
4 
5 https://t.me/SergarMommaChat
6 */
7 
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.10;
11 
12 /**
13  * ERC20 standard interface
14  */
15 
16 interface ERC20 {
17     function totalSupply() external view returns (uint256);
18     function decimals() external view returns (uint8);
19     function symbol() external view returns (string memory);
20     function name() external view returns (string memory);
21     function getOwner() external view returns (address);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address _owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32  * Basic access control mechanism
33  */
34 
35 abstract contract Ownable {
36     address internal owner;
37     address private _previousOwner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     constructor(address _owner) {
42         owner = _owner;
43     }
44 
45     modifier onlyOwner() {
46         require(isOwner(msg.sender), "!YOU ARE NOT THE OWNER"); _;
47     }
48 
49     function isOwner(address account) public view returns (bool) {
50         return account == owner;
51     }
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(owner, address(0));
61         owner = address(0);
62     }
63 }
64 
65 /**
66  * Router Interfaces
67  */
68 
69 interface IDEXFactory {
70     function createPair(address tokenA, address tokenB) external returns (address pair);
71 }
72 
73 interface IDEXRouter {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76 
77     function addLiquidity(
78         address tokenA,
79         address tokenB,
80         uint amountADesired,
81         uint amountBDesired,
82         uint amountAMin,
83         uint amountBMin,
84         address to,
85         uint deadline
86     ) external returns (uint amountA, uint amountB, uint liquidity);
87 
88     function addLiquidityETH(
89         address token,
90         uint amountTokenDesired,
91         uint amountTokenMin,
92         uint amountETHMin,
93         address to,
94         uint deadline
95     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
96 
97     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104 
105     function swapExactETHForTokensSupportingFeeOnTransferTokens(
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external payable;
111 
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119 }
120 
121 /**
122  * Token Contract Code
123  */
124 
125 contract MAM is ERC20, Ownable {
126     // -- Mappings --
127     mapping(address => bool) public _blacklisted;
128     mapping(address => bool) private _whitelisted;
129     mapping(address => bool) public _automatedMarketMakers;
130     mapping(address => bool) private _isLimitless;
131     mapping(address => uint256) private _balances;
132     mapping(address => mapping(address => uint256)) private _allowances;
133 
134     // -- Basic Token Information --
135     string constant _name = "Sergar Momma";
136     string constant _symbol = "MAM";
137     uint8 constant _decimals = 18;
138     uint256 private _totalSupply = 100_000_000 * 10 ** _decimals;
139 
140 
141     // -- Transaction & Wallet Limits --
142     uint256 public maxBuyPercentage;
143     uint256 public maxSellPercentage;
144     uint256 public maxWalletPercentage;
145 
146     uint256 private maxBuyAmount;
147     uint256 private maxSellAmount;
148     uint256 private maxWalletAmount;
149 
150     // -- Contract Variables --
151     address[] private sniperList;
152     uint256 tokenTax;
153     uint256 transferFee;
154     uint256 private targetLiquidity = 50;
155 
156     // -- Fee Structs --
157     struct BuyFee {
158         uint256 liquidityFee;
159         uint256 SERFee;
160         uint256 marketingFee;
161         uint256 total;
162     }
163 
164     struct SellFee {
165         uint256 liquidityFee;
166         uint256 SERFee;
167         uint256 marketingFee;
168         uint256 total;
169     }
170 
171     BuyFee public buyFee;
172     SellFee public sellFee;
173 
174     // -- Addresses --
175     address public _exchangeRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
176     
177     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
178     address private constant ZERO = 0x0000000000000000000000000000000000000000;
179 
180     address public SERReceiver = 0xc1ecD500D321b576a6A0d296EA8d5ceB28bA1b42;
181     address public marketingReceiver = 0xb7ed0727E114d64035e4f3C869414C1589BFc98a;
182 
183     IDEXRouter public router;
184     address public pair;
185 
186     // -- Misc Variables --
187     bool public antiSniperMode = true;  // AntiSniper active at launch by default
188     bool private _addingLP;
189     bool private inSwap;
190     bool private _initialDistributionFinished;
191 
192     // -- Swap Variables --
193     bool public swapEnabled = true;
194     uint256 private swapThreshold = _totalSupply / 1000;
195     
196     modifier swapping() {
197         inSwap = true;
198         _;
199         inSwap = false;
200     }
201 
202     constructor () Ownable(msg.sender) {
203 
204         // Initialize Pancake Pair
205         router = IDEXRouter(_exchangeRouterAddress);
206         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
207         _allowances[address(this)][address(router)] = type(uint256).max;
208         _automatedMarketMakers[pair]=true;
209         
210         // Set Initial Buy Fees -- Base 1000 Set 10 for 1%
211         buyFee.liquidityFee = 0; buyFee.SERFee = 20; buyFee.marketingFee = 10;
212         buyFee.total = buyFee.liquidityFee + buyFee.SERFee + buyFee.marketingFee;
213 
214         // Set Initial Sell Fees -- Base 1000 Set 10 for 1%
215         sellFee.liquidityFee = 20; sellFee.SERFee = 20; sellFee.marketingFee = 10;
216         sellFee.total = sellFee.liquidityFee + sellFee.SERFee + sellFee.marketingFee;
217 
218         // Set Initial Buy, Sell & Wallet Limits -- Base 1000 Set 10 for 1%
219         maxBuyPercentage = 20; maxBuyAmount = _totalSupply /1000 * maxBuyPercentage;
220         maxSellPercentage = 20; maxSellAmount = _totalSupply /1000 * maxSellPercentage;
221         maxWalletPercentage = 20; maxWalletAmount = _totalSupply /1000 * maxWalletPercentage;
222 
223         // Exclude from fees & limits
224         _isLimitless[owner] = _isLimitless[address(this)] = true;
225 
226         // Mint _totalSupply to owner address
227         _balances[owner] = _totalSupply;
228         emit Transfer(address(0x0), owner, _totalSupply);
229     }
230 
231 
232     ///////////////////////////////////////// -- Setter Functions -- /////////////////////////////////////////
233 
234         // Use 10 to set 1% -- Base 1000 for easier fine adjust
235     function ownerSetLimits(uint256 _maxBuyPercentage, uint256 _maxSellPercentage, uint256 _maxWalletPercentage) external onlyOwner {
236         maxBuyAmount = _totalSupply /1000 * _maxBuyPercentage;
237         maxSellAmount = _totalSupply /1000 * _maxSellPercentage;
238         maxWalletAmount = _totalSupply /1000 * _maxWalletPercentage;
239     }
240 
241     function ownerSetInitialDistributionFinished() external onlyOwner {
242         _initialDistributionFinished = true;
243     }
244 
245     function ownerSetLimitlessAddress(address _addr, bool _status) external onlyOwner {
246         _isLimitless[_addr] = _status;
247     }
248 
249     function ownerSetSwapBackSettings(bool _enabled, uint256 _percentageBase1000) external onlyOwner {
250         swapEnabled = _enabled;
251         swapThreshold = _totalSupply / 1000 * _percentageBase1000;
252     }
253 
254     function ownerSetTargetLiquidity(uint256 target) external onlyOwner {
255         targetLiquidity = target;
256     }
257        // Use 10 to set 1% -- Base 1000 for easier fine adjust
258     function ownerUpdateBuyFees (uint256 _liquidityFee, uint256 _SERFee, uint256 _marketingFee) external onlyOwner {
259         buyFee.liquidityFee = _liquidityFee;
260         buyFee.SERFee = _SERFee;
261         buyFee.marketingFee = _marketingFee;
262         buyFee.total = buyFee.liquidityFee + buyFee.SERFee + buyFee.marketingFee;
263     }
264         // Use 10 to set 1% -- Base 1000 for easier fine adjust
265     function ownerUpdateSellFees (uint256 _liquidityFee, uint256 _SERFee, uint256 _marketingFee) external onlyOwner {
266         sellFee.liquidityFee = _liquidityFee;
267         sellFee.SERFee = _SERFee;
268         sellFee.marketingFee = _marketingFee;
269         sellFee.total = sellFee.liquidityFee + sellFee.SERFee + sellFee.marketingFee;
270     }
271         // Use 10 to set 1% -- Base 1000 for easier fine adjust
272     function ownerUpdateTransferFee (uint256 _transferFee) external onlyOwner {
273         transferFee = _transferFee;
274     }
275 
276     function ownerSetReceivers (address _SER, address _marketing) external onlyOwner {
277         SERReceiver = _SER;
278         marketingReceiver = _marketing;
279     }
280 
281     function ownerAirDropWallets(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner{
282         require(airdropWallets.length < 100, "Can only airdrop 100 wallets per txn due to gas limits");
283         for(uint256 i = 0; i < airdropWallets.length; i++){
284             address wallet = airdropWallets[i];
285             uint256 amount = (amounts[i] * 10**_decimals);
286             _transfer(msg.sender, wallet, amount);
287         }
288     }
289 
290     function reverseSniper(address sniper) external onlyOwner {
291         _blacklisted[sniper] = false;
292     }
293 
294     function addNewMarketMaker(address newAMM) external onlyOwner {
295         _automatedMarketMakers[newAMM]=true;
296         _isLimitless[newAMM]=true;
297     }
298 
299     function controlAntiSniperMode(bool value) external onlyOwner {
300         antiSniperMode = value;
301     }
302 
303     function clearStuckBalance() external onlyOwner {
304         uint256 contractETHBalance = address(this).balance;
305         payable(owner).transfer(contractETHBalance);
306     }
307 
308     function clearStuckToken(address _token) public onlyOwner {
309         uint256 _contractBalance = ERC20(_token).balanceOf(address(this));
310         payable(SERReceiver).transfer(_contractBalance);
311     }
312     ///////////////////////////////////////// -- Getter Functions -- /////////////////////////////////////////
313 
314     function getCirculatingSupply() public view returns (uint256) {
315         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
316     }
317 
318     function showSniperList() public view returns(address[] memory){
319         return sniperList;
320     }
321 
322     function showSniperListLength() public view returns(uint256){
323         return sniperList.length;
324     }
325 
326     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
327         return accuracy * (balanceOf(pair) * (2)) / (getCirculatingSupply());
328     }
329 
330     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
331         return getLiquidityBacking(accuracy) > target;
332     }
333 
334     ///////////////////////////////////////// -- Internal Functions -- /////////////////////////////////////////
335 
336     function _transfer(address sender,address recipient,uint256 amount) private {
337         require(sender!=address(0)&&recipient!=address(0),"Cannot be address(0).");
338         bool isBuy=_automatedMarketMakers[sender];
339         bool isSell=_automatedMarketMakers[recipient];
340         bool isExcluded=_isLimitless[sender]||_isLimitless[recipient]||_addingLP;
341 
342         if(isExcluded)_transferExcluded(sender,recipient,amount);
343         else { require(_initialDistributionFinished);
344             // Punish for Snipers
345             if(antiSniperMode)_punishSnipers(sender,recipient,amount);
346             // Buy Tokens
347             else if(isBuy)_buyTokens(sender,recipient,amount);
348             // Sell Tokens
349             else if(isSell) {
350                 // Swap & Liquify
351                 if (shouldSwapBack()) {swapBack();}
352                 _sellTokens(sender,recipient,amount);
353             } else {
354                 // P2P Transfer
355                 require(!_blacklisted[sender]&&!_blacklisted[recipient]);
356                 require(balanceOf(recipient)+amount<=maxWalletAmount);
357                 _P2PTransfer(sender,recipient,amount);
358             }
359         }
360     }
361 
362     function _punishSnipers(address sender,address recipient,uint256 amount) private {
363         require(!_blacklisted[recipient]);
364         require(amount <= maxBuyAmount, "Buy exceeds limit");
365         tokenTax = amount*90/100;
366         _blacklisted[recipient]=true;
367         sniperList.push(address(recipient));
368         _transferIncluded(sender,recipient,amount,tokenTax);
369     }
370 
371     function _buyTokens(address sender,address recipient,uint256 amount) private {
372         require(!_blacklisted[recipient]);
373         require(amount <= maxBuyAmount, "Buy exceeds limit");
374         if(!_whitelisted[recipient]){
375         tokenTax = amount*buyFee.total/1000;}
376         else tokenTax = 0;
377         _transferIncluded(sender,recipient,amount,tokenTax);
378     }
379     function _sellTokens(address sender,address recipient,uint256 amount) private {
380         require(!_blacklisted[sender]);
381         require(amount <= maxSellAmount);
382         if(!_whitelisted[sender]){
383         tokenTax = amount*sellFee.total/1000;}
384         else tokenTax = 0;
385         _transferIncluded(sender,recipient,amount,tokenTax);
386     }
387 
388     function _P2PTransfer(address sender,address recipient,uint256 amount) private {
389         tokenTax = amount * transferFee/1000;
390         if( tokenTax > 0) {_transferIncluded(sender,recipient,amount,tokenTax);}
391         else {_transferExcluded(sender,recipient,amount);}
392     }
393 
394     function _transferExcluded(address sender,address recipient,uint256 amount) private {
395         _updateBalance(sender,_balances[sender]-amount);
396         _updateBalance(recipient,_balances[recipient]+amount);
397         emit Transfer(sender,recipient,amount);
398     }
399 
400     function _transferIncluded(address sender,address recipient,uint256 amount,uint256 taxAmount) private {
401         uint256 newAmount = amount-tokenTax;
402         _updateBalance(sender,_balances[sender]-amount);
403         _updateBalance(address(this),_balances[address(this)]+taxAmount);
404         _updateBalance(recipient,_balances[recipient]+newAmount);
405         emit Transfer(sender,recipient,newAmount);
406         emit Transfer(sender,address(this),taxAmount);
407     }
408 
409     function _updateBalance(address account,uint256 newBalance) private {
410         _balances[account] = newBalance;
411     }
412 
413     function shouldSwapBack() private view returns (bool) {
414         return
415             !inSwap &&
416             swapEnabled &&
417             _balances[address(this)] >= swapThreshold;
418     }   
419 
420     function swapBack() private swapping {
421         uint256 toSwap = balanceOf(address(this));
422 
423         uint256 totalLPTokens=toSwap*(sellFee.liquidityFee + buyFee.liquidityFee)/(sellFee.total + buyFee.total);
424         uint256 tokensLeft=toSwap-totalLPTokens;
425         uint256 LPTokens=totalLPTokens/2;
426         uint256 LPBNBTokens=totalLPTokens-LPTokens;
427         toSwap=tokensLeft+LPBNBTokens;
428         uint256 oldBNB=address(this).balance;
429         _swapTokensForBNB(toSwap);
430         uint256 newBNB=address(this).balance-oldBNB;
431         uint256 LPBNB=(newBNB*LPBNBTokens)/toSwap;
432         _addLiquidity(LPTokens,LPBNB);
433         uint256 remainingBNB=address(this).balance-oldBNB;
434         _distributeBNB(remainingBNB);
435     }
436 
437     function _distributeBNB(uint256 remainingBNB) private {
438         uint256 marketingFee = (buyFee.marketingFee + sellFee.marketingFee);
439         uint256 SERFee = (buyFee.SERFee + sellFee.SERFee);
440         uint256 totalFee = (marketingFee + SERFee);
441 
442         uint256 amountBNBmarketing = remainingBNB * (marketingFee) / (totalFee);
443         uint256 amountBNBSER = remainingBNB * (SERFee) / (totalFee);
444 
445         if(amountBNBSER > 0){
446         (bool SERSuccess, /* bytes memory data */) = payable(SERReceiver).call{value: amountBNBSER, gas: 30000}("");
447         require(SERSuccess, "receiver rejected ETH transfer"); }
448         
449         if(amountBNBmarketing > 0){
450         (bool marketingSuccess, /* bytes memory data */) = payable(marketingReceiver).call{value: amountBNBmarketing, gas: 30000}("");
451         require(marketingSuccess, "receiver rejected ETH transfer"); }
452     }
453 
454     function _swapTokensForBNB(uint256 amount) private {
455         address[] memory path=new address[](2);
456         path[0] = address(this);
457         path[1] = router.WETH();
458         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
459             amount,
460             0,
461             path,
462             address(this),
463             block.timestamp
464         );
465     }
466 
467     function _addLiquidity(uint256 amountTokens,uint256 amountBNB) private {
468         _addingLP=true;
469         router.addLiquidityETH{value: amountBNB}(
470             address(this),
471             amountTokens,
472             0,
473             0,
474             SERReceiver,
475             block.timestamp
476         );
477         _addingLP=false;
478     }
479 
480 /**
481  * IERC20
482  */
483 
484     receive() external payable { }
485 
486     function totalSupply() external view override returns (uint256) { return _totalSupply; }
487     function decimals() external pure override returns (uint8) { return _decimals; }
488     function symbol() external pure override returns (string memory) { return _symbol; }
489     function name() external pure override returns (string memory) { return _name; }
490     function getOwner() external view override returns (address) { return owner; }
491     function balanceOf(address account) public view override returns (uint256) { return _balances[account];}
492     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender];}
493 
494     function approve(address spender, uint256 amount) public override returns (bool) {
495         _allowances[msg.sender][spender] = amount;
496         emit Approval(msg.sender, spender, amount);
497         return true;
498     }
499 
500     function transfer(address recipient, uint256 amount) public override returns (bool) {
501         _transfer(msg.sender, recipient, amount);
502         return true;
503     }
504 
505     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
506         uint256 allowance_ = _allowances[sender][msg.sender];
507         require(allowance_ >= amount);
508         
509         if (_allowances[sender][msg.sender] != type(uint256).max) {
510             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
511         }
512         _transfer(sender, recipient, amount);
513         return true;
514     }
515 }