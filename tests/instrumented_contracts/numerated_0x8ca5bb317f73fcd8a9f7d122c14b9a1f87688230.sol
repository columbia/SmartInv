1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.18;
3 
4 /*
5 
6 SocialAI
7 https://www.socialai.finance/
8 
9 Just with a token address, SocialAI instantly finds the associated social media. 
10 It uses the revolutionary power of AI to scan the wealth of text in the crypto space. 
11 From comments on tweets to the source codes of websites. 
12 
13 */
14 
15 // Just the basic IERC20 interface
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function decimals() external view returns (uint8);
19     function symbol() external view returns (string memory);
20     function name() external view returns (string memory);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address _owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // We use the Auth contract mainly to have two devs able to interacet with the contract
31 abstract contract Auth {
32     address internal owner;
33     mapping (address => bool) internal authorizations;
34 
35     constructor(address _owner) {
36         owner = _owner;
37         authorizations[_owner] = true;
38     }
39 
40     modifier onlyOwner() {
41         require(isOwner(msg.sender), "!OWNER"); _;
42     }
43 
44     modifier authorized() {
45         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
46     }
47 
48     function authorize(address adr) public onlyOwner {
49         authorizations[adr] = true;
50     }
51 
52     function unauthorize(address adr) public onlyOwner {
53         authorizations[adr] = false;
54     }
55 
56     function isOwner(address account) public view returns (bool) {
57         return account == owner;
58     }
59 
60     function isAuthorized(address adr) public view returns (bool) {
61         return authorizations[adr];
62     }
63 
64     function transferOwnership(address payable adr) public onlyOwner {
65         owner = adr;
66         authorizations[adr] = true;
67         emit OwnershipTransferred(adr);
68     }
69 
70     event OwnershipTransferred(address owner);
71 }
72 
73 interface IDEXFactory {
74     function createPair(address tokenA, address tokenB) external returns (address pair);
75 }
76 
77 interface IDEXRouter {
78     function factory() external pure returns (address);
79     function WETH() external pure returns (address);
80 
81     function addLiquidityETH(
82         address token,
83         uint amountTokenDesired,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline
88     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
89 
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external;
97 }
98 
99 contract SocialAI is IERC20, Auth {
100    
101     // Constant addresses 
102     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
103     address constant ZERO = 0x0000000000000000000000000000000000000000;
104     IDEXRouter public constant router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
105 
106     // Immutable vars
107     address public immutable pair; // After we set the pair we don't have to change it again
108 
109     // Token info is constant
110     string constant _name = "SocialAI";
111     string constant _symbol = "sAI";
112     uint8 constant _decimals = 18;
113 
114     // Total supply is 1 billion
115     uint256 _totalSupply = 1 * (10**9) * (10 ** _decimals);
116 
117     // The tax divisor is also constant (and hence immutable)
118     // 1000 so we can also use halves, like 2.5%
119     uint256 constant taxDivisor = 1_000;
120     
121     // 10 / 1000 = 0.01 = 1%
122     uint256 public _maxTxAmount = _totalSupply * 10 / taxDivisor; 
123     uint256 public _maxWalletToken =  _totalSupply * 10 / taxDivisor; 
124 
125     // Keep track of wallet balances and approvals (allowance)
126     mapping (address => uint256) _balances;
127     mapping (address => mapping (address => uint256)) _allowances;
128 
129     // Mapping to keep track of what wallets/contracts are exempt
130     // from fees
131     mapping (address => bool) isFeeExempt;
132     mapping (address => bool) isTxLimitExempt; // Both wallet + max TX
133 
134     // Also, to keep it organized, a seperate mapping to exclude the presale
135     // and locker from limits
136     mapping (address => bool) presaleOrlock;
137 
138     //fees are mulitplied by 10 to allow decimals, and therefore dividied by 1000 (see takefee)
139     uint256 marketingBuyFee = 20;
140     uint256 liquidityBuyFee = 20;
141     uint256 developmentBuyFee = 20;
142     uint256 public totalBuyFee = marketingBuyFee + liquidityBuyFee + developmentBuyFee;
143 
144     uint256 marketingSellFee = 30;
145     uint256 liquiditySellFee = 30;
146     uint256 developmentSellFee = 20;
147     uint256 public totalSellFee = marketingSellFee + liquiditySellFee + developmentSellFee;
148 
149     // For the sniper friends
150     uint256 private sniperTaxTill; 
151 
152     // In case anything would go wrong with fees we can just disable them
153     bool feesEnabled = true;
154 
155     // Whether tx limits should apply or not 
156     bool limits = true;
157 
158     // To keep track of the tokens collected to swap
159     uint256 private tokensForMarketing;
160     uint256 private tokensForLiquidity;
161     uint256 private tokensForDev;
162 
163     // Wallets used to send the fees to
164     address public liquidityWallet;
165     address public marketingWallet;
166     address public developmentWallet;
167 
168     // One time trade lock
169     bool tradeBlock = true;
170     bool lockUsed = false;
171 
172     // Contract cant be tricked into spam selling exploit
173     uint256 lastSellTime;
174     
175     // When to swap contract tokens, and how many to swap
176     bool public swapEnabled = true;
177     uint256 public swapThreshold = _totalSupply * 10 / 100_000; // 0.01%
178     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
179 
180     // This will just check if the transferf is called from within 
181     // the token -> ETH swap when processing the fees (and adding LP)
182     bool inSwap;
183     modifier swapping() { inSwap = true; _; inSwap = false; }
184 
185 
186     constructor () Auth(msg.sender) {
187         // Create the lp pair
188         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
189 
190         // Exclude the contract
191         isFeeExempt[address(this)] = true;
192         isTxLimitExempt[address(this)] = true;
193 
194         // Exclude the owner
195         isFeeExempt[msg.sender] = true;
196         isTxLimitExempt[msg.sender] = true;
197         
198         // Exclude the pair
199         isTxLimitExempt[address(pair)] = true; 
200 
201         // Exclude the router 
202         isTxLimitExempt[address(router)] = true;
203 
204         // Set fee receivers
205         liquidityWallet = 0xC2c5dCdC771835325aE0eE5EAdBEb18B952CAfDe;
206         marketingWallet = 0xb657DafDb4fB36aEb466c04940eC04FBf7c2D5e3;
207         developmentWallet = 0x2b47097ae32639025d205cB866972F70deCB5a15;
208 
209         // Approve this contract & owner to interact with the 
210         // router and pair contract (for swapping)
211         _approve(address(this), address(router), _totalSupply);
212         _approve(msg.sender, address(pair), _totalSupply);
213 
214         // Mint the tokens
215         _balances[msg.sender] = _totalSupply;
216         emit Transfer(address(0), msg.sender, _totalSupply);
217     }
218 
219     receive() external payable { }
220 
221     function totalSupply() external view override returns (uint256) { return _totalSupply; }
222     function decimals() external pure override returns (uint8) { return _decimals; }
223     function symbol() external pure override returns (string memory) { return _symbol; }
224     function name() external pure override returns (string memory) { return _name; }
225     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
226     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
227     function getPair() external view returns (address){return pair;}
228 
229     // Internal approve 
230     function _approve(address owner, address spender, uint256 amount) internal virtual {
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235     // Regular approve the contract
236     function approve(address spender, uint256 amount) public override returns (bool) {
237         _allowances[msg.sender][spender] = amount;
238         emit Approval(msg.sender, spender, amount);
239         return true;
240     }
241 
242     function approveMax(address spender) external returns (bool) {
243         return approve(spender, _totalSupply);
244     }
245 
246     // We actually only need to exempt any locks or presale addresses
247     // we could use a feeexempt or authorize it, but this is a bit cleaner
248     function excludeLockorPresale(address add) external authorized {
249         // Exclude from fees
250         isFeeExempt[add] = true;
251         isTxLimitExempt[add] = true;
252         // We want to allow transfers to locks and from the presale
253         // address when trading is not yet enabled. 
254         presaleOrlock[add] = true;
255     }
256     
257     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
258         uint256 senderBalance = _balances[sender];
259         // Check if the sender has sufficient balance
260         require(senderBalance >= amount, "Insufficient Balance");
261         // Update balances
262         _balances[sender] = _balances[sender] - amount; 
263         _balances[recipient] = _balances[recipient] + amount;
264         emit Transfer(sender, recipient, amount);
265         return true;
266     }
267 
268     // Set the buy fees, this can not exceed 15%, 150 / 1000 = 0.15 = 15%
269     function setBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _developFee) external authorized{
270         require(_marketingFee + _liquidityFee + _developFee <= 150); // max 15%
271         marketingBuyFee = _marketingFee;
272         liquidityBuyFee = _liquidityFee;
273         developmentBuyFee = _developFee;
274         totalBuyFee = _marketingFee + _liquidityFee + _developFee;
275     }
276     
277     // Set the sell fees, this can not exceed 15%, 150 / 1000 = 0.15 = 15%
278     function setSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _developFee) external authorized{
279         require(_marketingFee + _liquidityFee + _developFee <= 150); // max 15%
280         marketingSellFee = _marketingFee;
281         liquiditySellFee = _liquidityFee;
282         developmentSellFee = _developFee;
283         totalSellFee = _marketingFee + _liquidityFee + _developFee;
284     }
285 
286     // To change the tax receiving wallets
287     function setWallets(address _marketingWallet, address _liquidityWallet, address _developWallet) external authorized {
288         marketingWallet = _marketingWallet;
289         liquidityWallet = _liquidityWallet;
290         developmentWallet = _developWallet;
291     }
292 
293     // To limit the number of tokens a wallet can buy, especially relevant at launch
294     function setMaxWallet(uint256 percent) external authorized {
295         require(percent >= 10); //should be at least 1% of the total supply (note divisor is 1000)
296         _maxWalletToken = ( _totalSupply * percent ) / taxDivisor;
297     }
298 
299     // To limit the number of tokens per transactions
300     function setTxLimit(uint256 percent) external authorized {
301         require(percent >= 10); //should be at least 1% of the total supply (note divisor is 1000)
302         _maxTxAmount = ( _totalSupply * percent ) / taxDivisor;
303     }
304     
305     function checkLimits(address sender,address recipient, uint256 amount) internal view {
306         // If both sender and recipient are excluded we don't have to limit 
307         if (isTxLimitExempt[sender] && isTxLimitExempt[recipient]){return;}
308 
309         // In any other case we will check whether this is a buy or sell
310         // to determine the tx limit
311         
312         // buy
313         if (sender == pair && !isTxLimitExempt[recipient]) {  
314             require(amount <= _maxTxAmount, "Max tx limit");
315 
316         // sell
317         } else if(recipient == pair && !isTxLimitExempt[sender] ) { 
318             require(amount <= _maxTxAmount, "Max tx limit");
319         }
320 
321         // Also check max wallet 
322         if (!isTxLimitExempt[recipient]) {
323             require(amount + balanceOf(recipient) <= _maxWalletToken, "Max wallet");
324         }
325 
326     }
327 
328     // We will lift the transaction limits just after launch
329     function liftLimits() external authorized {
330         limits = false;
331     }
332 
333     // This would make the token fee-less in case taking fees
334     // would at any point block transfers. This is reversible
335     function setFeeTaking(bool takeFees) external authorized {
336         feesEnabled = takeFees;
337     }
338 
339     // Enable trading - this can only be called once (by just the owner)
340     function startTrading() external onlyOwner {
341         require(lockUsed == false);
342         tradeBlock = false;
343         sniperTaxTill = block.number + 2; // (<sniperTaxTill, so first block)
344         lockUsed = true;
345     }
346     
347     // When and if to swap the tokens in the contract
348     function setTokenSwapSettings(bool _enabled, uint256 _threshold) external authorized {
349         swapEnabled = _enabled;
350         swapThreshold = _threshold * (10 ** _decimals); 
351     }
352     
353     // Check if the contract should swap tokens
354     function shouldTokenSwap(address recipient) internal view returns (bool) {
355         return recipient == pair // i.e. is sell
356         && lastSellTime + 1 < block.timestamp // block contract spam sells
357         && !inSwap
358         && swapEnabled
359         && _balances[address(this)] >= swapThreshold;
360     }
361 
362     function takeFee(address from, address to, uint256 amount) internal returns (uint256) {
363 
364         // If the sender or receiver is exempt from fees, skip fees
365         if (isFeeExempt[from] || isFeeExempt[to]) {
366             return amount;
367         }
368 
369         // This does not charge for wallet-wallet transfers
370         uint256 fees;
371 
372         // Sniper tax
373         if (block.number < sniperTaxTill) {
374             fees = amount * 98 / 100; // 98% tax
375             tokensForLiquidity += (fees * 50) / 98;
376             tokensForMarketing += (fees * 48) / 98;
377         }
378 
379         // On sell
380         else if (to == pair && totalSellFee > 0) {
381             fees = amount * totalSellFee / taxDivisor;
382             tokensForLiquidity += (fees * liquiditySellFee)   / totalSellFee;
383             tokensForDev       += (fees * developmentSellFee) / totalSellFee;
384             tokensForMarketing += (fees * marketingSellFee)   / totalSellFee;
385         }
386 
387         // On buy
388         else if (from == pair && totalBuyFee > 0) {
389             fees = amount * totalBuyFee / taxDivisor;
390             tokensForLiquidity += (fees * liquidityBuyFee)   / totalBuyFee ;
391             tokensForDev       += (fees * developmentBuyFee) / totalBuyFee;
392             tokensForMarketing += (fees * marketingBuyFee)   / totalBuyFee;
393         }
394 
395         // If we collected fees, send them to the contract
396         if (fees > 0) {
397             _basicTransfer(from, address(this), fees);
398             emit Transfer(from, address(this), fees);
399         }
400 
401         // Return the taxed amount
402         return amount -= fees;
403     }
404 
405     
406     function swapTokensForEth(uint256 tokenAmount) private {
407         // Swap path token -> weth
408         address[] memory path = new address[](2);
409         path[0] = address(this);
410         path[1] = router.WETH();
411 
412         // Make the swap
413         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
414             tokenAmount,
415             0, 
416             path,
417             address(this),
418             block.timestamp
419         );
420     }
421 
422     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
423         // Add liquidity from the contract. Now the LP tokens get send to the lP
424         // wallet, but we could also change the LP receiver to the burn address leter
425         router.addLiquidityETH{value: ethAmount}(
426             address(this),
427             tokenAmount,
428             0, 
429             0, 
430             liquidityWallet,
431             block.timestamp
432         );
433     }
434 
435     function swapBack() internal swapping {
436         uint256 contractBalance = balanceOf(address(this));
437         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
438         bool success;
439 
440         if (contractBalance == 0 || totalTokensToSwap == 0) {return;}
441   
442         // Halve the amount of liquidity tokens
443         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
444         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
445 
446         uint256 initialETHBalance = address(this).balance;
447 
448         // Swap the tokens for ETH
449         swapTokensForEth(amountToSwapForETH);
450 
451         uint256 ethBalance = address(this).balance - initialETHBalance;
452         uint256 ethForMarketing = (ethBalance * tokensForMarketing) / totalTokensToSwap;
453         uint256 ethForDev       = (ethBalance * tokensForDev)       / totalTokensToSwap;
454         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
455 
456         // Reset token fee counts
457         tokensForLiquidity = 0;
458         tokensForMarketing = 0;
459         tokensForDev = 0;
460 
461         // Send Dev fees
462         (success, ) = address(developmentWallet).call{value: ethForDev}("");
463 
464         // Add liquidty
465         if (liquidityTokens > 0 && ethForLiquidity > 0) {
466             addLiquidity(liquidityTokens, ethForLiquidity);
467             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
468         }
469 
470         // Whatever remains (this should be ~ethForMarketing) send to the marketing wallet
471         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
472 
473         lastSellTime = block.timestamp;
474     }
475 
476     function transfer(address recipient, uint256 amount) external override returns (bool) {
477         if (owner == msg.sender){
478             return _basicTransfer(msg.sender, recipient, amount);
479         }
480         else {
481             return _transferFrom(msg.sender, recipient, amount);
482         }
483     }
484 
485     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
486         require(sender != address(0), "ERC20: transfer from the zero address");
487         require(recipient != address(0), "ERC20: transfer to the zero address");
488         if(_allowances[sender][msg.sender] != _totalSupply){
489             // Get the current allowance
490             uint256 curAllowance =  _allowances[sender][msg.sender];
491             require(curAllowance >= amount, "Insufficient Allowance");
492             _allowances[sender][msg.sender] -= amount;
493         }
494         return _transferFrom(sender, recipient, amount);
495     }
496 
497 
498     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
499 
500         require(sender != address(0), "ERC20: transfer from the zero address");
501         require(recipient != address(0), "ERC20: transfer to the zero address");
502 
503         // These transfers are always feeless and limitless
504         if ( authorizations[sender] || authorizations[recipient] || presaleOrlock[sender] || inSwap) {
505             return _basicTransfer(sender, recipient, amount);
506         }
507 
508         // In any other case, check if trading is open already
509         require(tradeBlock == false,"Trading not open yet");
510             
511         // If limits are enabled we check the max wallet and max tx.
512         if (limits){checkLimits(sender, recipient, amount);}
513 
514         // Check how much fees are accumulated in the contract, if > threshold, swap
515         if(shouldTokenSwap(recipient)){ swapBack();}
516 
517         // Charge transaction fees (only swaps) when enabled
518         if(feesEnabled){
519              amount = (recipient == pair || sender == pair) ? takeFee(sender, recipient, amount) : amount;
520         } 
521 
522         // Send the remaining tokens, after fee
523         _basicTransfer(sender, recipient, amount);
524 
525         emit Transfer(sender, recipient, amount);
526         return true;
527     }
528 
529     // In case anyone would send ETH to the contract directly
530     // or when, for some reason, autoswap would fail. We 
531     // send the contact ETH to the marketing wallet
532     function clearStuckWETH(uint256 perc) external authorized {
533         uint256 amountWETH = address(this).balance;
534         payable(marketingWallet).transfer(amountWETH * perc / 100);
535     }
536 
537 }