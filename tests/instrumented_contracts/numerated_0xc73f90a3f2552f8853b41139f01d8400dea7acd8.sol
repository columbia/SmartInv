1 /**
2 */
3 //SPDX-License-Identifier: MIT
4 pragma solidity 0.8.18;
5 //
6 // Website V1: https://www.zkpixel.com/
7 // Documentation: https://www.zkpixel.com/docs
8 // Hide behind the pixels
9 // 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function decimals() external view returns (uint8);
13     function symbol() external view returns (string memory);
14     function name() external view returns (string memory);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address _owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 // We use the Auth contract mainly to have two devs able to interacet with the contract
25 abstract contract Auth {
26     address internal owner;
27     mapping (address => bool) internal authorizations;
28 
29     constructor(address _owner) {
30         owner = _owner;
31         authorizations[_owner] = true;
32     }
33 
34     modifier onlyOwner() {
35         require(isOwner(msg.sender), "!OWNER"); _;
36     }
37 
38     modifier authorized() {
39         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
40     }
41 
42     function authorize(address adr) public onlyOwner {
43         authorizations[adr] = true;
44     }
45 
46     function unauthorize(address adr) public onlyOwner {
47         authorizations[adr] = false;
48     }
49 
50     function isOwner(address account) public view returns (bool) {
51         return account == owner;
52     }
53 
54     function isAuthorized(address adr) public view returns (bool) {
55         return authorizations[adr];
56     }
57 
58     function transferOwnership(address payable adr) public onlyOwner {
59         owner = adr;
60         authorizations[adr] = true;
61         emit OwnershipTransferred(adr);
62     }
63 
64     event OwnershipTransferred(address owner);
65 }
66 
67 interface IDEXFactory {
68     function createPair(address tokenA, address tokenB) external returns (address pair);
69 }
70 
71 interface IDEXRouter {
72     function factory() external pure returns (address);
73     function WETH() external pure returns (address);
74 
75     function addLiquidityETH(
76         address token,
77         uint amountTokenDesired,
78         uint amountTokenMin,
79         uint amountETHMin,
80         address to,
81         uint deadline
82     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
83 
84     function swapExactTokensForETHSupportingFeeOnTransferTokens(
85         uint amountIn,
86         uint amountOutMin,
87         address[] calldata path,
88         address to,
89         uint deadline
90     ) external;
91 }
92 
93 contract ZKPixel is IERC20, Auth {
94    
95     // Constant addresses 
96     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
97     address constant ZERO = 0x0000000000000000000000000000000000000000;
98     IDEXRouter public constant router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
99 
100     // Immutable vars
101     address public immutable pair; // After we set the pair we don't have to change it again
102 
103     // Token info is constant
104     string constant _name = "ZKPixel";
105     string constant _symbol = "ZKP";
106     uint8 constant _decimals = 18;
107 
108     // Total supply is 1 billion
109     uint256 _totalSupply = 1 * (10**9) * (10 ** _decimals);
110 
111     // The tax divisor is also constant (and hence immutable)
112     // 1000 so we can also use halves, like 2.5%
113     uint256 constant taxDivisor = 1_000;
114     
115     // 10 / 1000 = 0.01 = 1%
116     uint256 public _maxTxAmount = _totalSupply * 20 / taxDivisor; 
117     uint256 public _maxWalletToken =  _totalSupply * 20 / taxDivisor; 
118 
119     // Keep track of wallet balances and approvals (allowance)
120     mapping (address => uint256) _balances;
121     mapping (address => mapping (address => uint256)) _allowances;
122 
123     // Mapping to keep track of what wallets/contracts are exempt
124     // from fees
125     mapping (address => bool) isFeeExempt;
126     mapping (address => bool) isTxLimitExempt; // Both wallet + max TX
127 
128     // Also, to keep it organized, a seperate mapping to exclude the presale
129     // and locker from limits
130     mapping (address => bool) presaleOrlock;
131 
132     //fees are mulitplied by 10 to allow decimals, and therefore dividied by 1000 (see takefee)
133     uint256 marketingBuyFee = 70;
134     uint256 liquidityBuyFee = 0;
135     uint256 developmentBuyFee = 70;
136     uint256 public totalBuyFee = marketingBuyFee + liquidityBuyFee + developmentBuyFee;
137 
138     uint256 marketingSellFee = 100;
139     uint256 liquiditySellFee = 0;
140     uint256 developmentSellFee = 100;
141     uint256 public totalSellFee = marketingSellFee + liquiditySellFee + developmentSellFee;
142 
143     // For the sniper friends
144     uint256 private sniperTaxTill; 
145 
146     // In case anything would go wrong with fees we can just disable them
147     bool feesEnabled = true;
148 
149     // Whether tx limits should apply or not 
150     bool limits = true;
151 
152     // To keep track of the tokens collected to swap
153     uint256 private tokensForMarketing;
154     uint256 private tokensForLiquidity;
155     uint256 private tokensForDev;
156 
157     // Wallets used to send the fees to
158     address public liquidityWallet;
159     address public marketingWallet;
160     address public developmentWallet;
161 
162     // One time trade lock
163     bool tradeBlock = true;
164     bool lockUsed = false;
165 
166     // Contract cant be tricked into spam selling exploit
167     uint256 lastSellTime;
168     
169     // When to swap contract tokens, and how many to swap
170     bool public swapEnabled = true;
171     uint256 public swapThreshold = _totalSupply * 10 / 1000; // 0.5%
172     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
173 
174     // This will just check if the transferf is called from within 
175     // the token -> ETH swap when processing the fees (and adding LP)
176     bool inSwap;
177     modifier swapping() { inSwap = true; _; inSwap = false; }
178 
179 
180     constructor () Auth(msg.sender) {
181         // Create the lp pair
182         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
183 
184         // Exclude the contract
185         isFeeExempt[address(this)] = true;
186         isTxLimitExempt[address(this)] = true;
187 
188         // Exclude the owner
189         isFeeExempt[msg.sender] = true;
190         isTxLimitExempt[msg.sender] = true;
191         
192         // Exclude the pair
193         isTxLimitExempt[address(pair)] = true; 
194 
195         // Exclude the router 
196         isTxLimitExempt[address(router)] = true;
197 
198         // Set fee receivers
199         liquidityWallet = 0xEaC1a4dA395254ed2afEc4C3D10F4F52DD06dDA0;
200         marketingWallet = 0xEaC1a4dA395254ed2afEc4C3D10F4F52DD06dDA0;
201         developmentWallet = 0x44D225554D75E65cf74f50Aa73DA420a9A1550A1;
202 
203         // Approve this contract & owner to interact with the 
204         // router and pair contract (for swapping)
205         _approve(address(this), address(router), _totalSupply);
206         _approve(msg.sender, address(pair), _totalSupply);
207 
208         // Mint the tokens
209         _balances[msg.sender] = _totalSupply;
210         emit Transfer(address(0), msg.sender, _totalSupply);
211     }
212 
213     receive() external payable { }
214 
215     function totalSupply() external view override returns (uint256) { return _totalSupply; }
216     function decimals() external pure override returns (uint8) { return _decimals; }
217     function symbol() external pure override returns (string memory) { return _symbol; }
218     function name() external pure override returns (string memory) { return _name; }
219     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
220     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
221     function getPair() external view returns (address){return pair;}
222 
223     // Internal approve 
224     function _approve(address owner, address spender, uint256 amount) internal virtual {
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     // Regular approve the contract
230     function approve(address spender, uint256 amount) public override returns (bool) {
231         _allowances[msg.sender][spender] = amount;
232         emit Approval(msg.sender, spender, amount);
233         return true;
234     }
235 
236     function approveMax(address spender) external returns (bool) {
237         return approve(spender, _totalSupply);
238     }
239 
240     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
241         uint256 senderBalance = _balances[sender];
242         // Check if the sender has sufficient balance
243         require(senderBalance >= amount, "Insufficient Balance");
244         // Update balances
245         _balances[sender] = _balances[sender] - amount; 
246         _balances[recipient] = _balances[recipient] + amount;
247         emit Transfer(sender, recipient, amount);
248         return true;
249     }
250 
251     // Set the buy fees, this can not exceed 14%, 140 / 1000 = 0.14 = 14%
252     function setBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _developFee) external authorized{
253         require(_marketingFee + _liquidityFee + _developFee <= 140); // max 14%
254         marketingBuyFee = _marketingFee;
255         liquidityBuyFee = _liquidityFee;
256         developmentBuyFee = _developFee;
257         totalBuyFee = _marketingFee + _liquidityFee + _developFee;
258     }
259     
260     // Set the sell fees, this can not exceed 20%, 200 / 1000 = 0.20 = 20%
261     function setSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _developFee) external authorized{
262         require(_marketingFee + _liquidityFee + _developFee <= 200); // max 20%
263         marketingSellFee = _marketingFee;
264         liquiditySellFee = _liquidityFee;
265         developmentSellFee = _developFee;
266         totalSellFee = _marketingFee + _liquidityFee + _developFee;
267     }
268 
269     // To change the tax receiving wallets
270     function setWallets(address _marketingWallet, address _liquidityWallet, address _developWallet) external authorized {
271         marketingWallet = _marketingWallet;
272         liquidityWallet = _liquidityWallet;
273         developmentWallet = _developWallet;
274     }
275 
276     // To limit the number of tokens a wallet can buy, especially relevant at launch
277     function setMaxWallet(uint256 percent) external authorized {
278         require(percent >= 10); //should be at least 1% of the total supply (note divisor is 1000)
279         _maxWalletToken = ( _totalSupply * percent ) / taxDivisor;
280     }
281 
282     // To limit the number of tokens per transactions
283     function setTxLimit(uint256 percent) external authorized {
284         require(percent >= 10); //should be at least 1% of the total supply (note divisor is 1000)
285         _maxTxAmount = ( _totalSupply * percent ) / taxDivisor;
286     }
287     
288     function checkLimits(address sender,address recipient, uint256 amount) internal view {
289         // If both sender and recipient are excluded we don't have to limit 
290         if (isTxLimitExempt[sender] && isTxLimitExempt[recipient]){return;}
291 
292         // In any other case we will check whether this is a buy or sell
293         // to determine the tx limit
294         
295         // buy
296         if (sender == pair && !isTxLimitExempt[recipient]) {  
297             require(amount <= _maxTxAmount, "Max tx limit");
298 
299         // sell
300         } else if(recipient == pair && !isTxLimitExempt[sender] ) { 
301             require(amount <= _maxTxAmount, "Max tx limit");
302         }
303 
304         // Also check max wallet 
305         if (!isTxLimitExempt[recipient]) {
306             require(amount + balanceOf(recipient) <= _maxWalletToken, "Max wallet");
307         }
308 
309     }
310 
311     // We will lift the transaction limits just after launch
312     function liftLimits() external authorized {
313         limits = false;
314     }
315 
316     // This would make the token fee-less in case taking fees
317     // would at any point block transfers. This is reversible
318     function setFeeTaking(bool takeFees) external authorized {
319         feesEnabled = takeFees;
320     }
321 
322     // Enable trading - this can only be called once (by just the owner)
323     function startTrading() external onlyOwner {
324         require(lockUsed == false);
325         tradeBlock = false;
326         sniperTaxTill = block.number + 1; // (<sniperTaxTill, so first block)
327         lockUsed = true;
328     }
329     
330     // When and if to swap the tokens in the contract
331     function setTokenSwapSettings(bool _enabled, uint256 _threshold) external authorized {
332         swapEnabled = _enabled;
333         swapThreshold = _threshold * (10 ** _decimals); 
334     }
335     
336     // Check if the contract should swap tokens
337     function shouldTokenSwap(address recipient) internal view returns (bool) {
338         return recipient == pair // i.e. is sell
339         && lastSellTime + 1 < block.timestamp // block contract spam sells
340         && !inSwap
341         && swapEnabled
342         && _balances[address(this)] >= swapThreshold;
343     }
344 
345     function takeFee(address from, address to, uint256 amount) internal returns (uint256) {
346 
347         // If the sender or receiver is exempt from fees, skip fees
348         if (isFeeExempt[from] || isFeeExempt[to]) {
349             return amount;
350         }
351 
352         // This does not charge for wallet-wallet transfers
353         uint256 fees;
354 
355         // Sniper tax
356         if (block.number < sniperTaxTill) {
357             fees = amount * 98 / 100; // 98% tax
358             tokensForLiquidity += (fees * 50) / 98;
359             tokensForMarketing += (fees * 48) / 98;
360         }
361 
362         // On sell
363         else if (to == pair && totalSellFee > 0) {
364             fees = amount * totalSellFee / taxDivisor;
365             tokensForLiquidity += (fees * liquiditySellFee)   / totalSellFee;
366             tokensForDev       += (fees * developmentSellFee) / totalSellFee;
367             tokensForMarketing += (fees * marketingSellFee)   / totalSellFee;
368         }
369 
370         // On buy
371         else if (from == pair && totalBuyFee > 0) {
372             fees = amount * totalBuyFee / taxDivisor;
373             tokensForLiquidity += (fees * liquidityBuyFee)   / totalBuyFee ;
374             tokensForDev       += (fees * developmentBuyFee) / totalBuyFee;
375             tokensForMarketing += (fees * marketingBuyFee)   / totalBuyFee;
376         }
377 
378         // If we collected fees, send them to the contract
379         if (fees > 0) {
380             _basicTransfer(from, address(this), fees);
381             emit Transfer(from, address(this), fees);
382         }
383 
384         // Return the taxed amount
385         return amount -= fees;
386     }
387 
388     
389     function swapTokensForEth(uint256 tokenAmount) private {
390         // Swap path token -> weth
391         address[] memory path = new address[](2);
392         path[0] = address(this);
393         path[1] = router.WETH();
394 
395         // Make the swap
396         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
397             tokenAmount,
398             0, 
399             path,
400             address(this),
401             block.timestamp
402         );
403     }
404 
405     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
406         // Add liquidity from the contract. Now the LP tokens get send to the lP
407         // wallet, but we could also change the LP receiver to the burn address leter
408         router.addLiquidityETH{value: ethAmount}(
409             address(this),
410             tokenAmount,
411             0, 
412             0, 
413             liquidityWallet,
414             block.timestamp
415         );
416     }
417 
418     function swapBack() internal swapping {
419         uint256 contractBalance = balanceOf(address(this));
420         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
421         bool success;
422 
423         if (contractBalance == 0 || totalTokensToSwap == 0) {return;}
424   
425         // Halve the amount of liquidity tokens
426         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
427         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
428 
429         uint256 initialETHBalance = address(this).balance;
430 
431         // Swap the tokens for ETH
432         swapTokensForEth(amountToSwapForETH);
433 
434         uint256 ethBalance = address(this).balance - initialETHBalance;
435         uint256 ethForMarketing = (ethBalance * tokensForMarketing) / totalTokensToSwap;
436         uint256 ethForDev       = (ethBalance * tokensForDev)       / totalTokensToSwap;
437         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
438 
439         // Reset token fee counts
440         tokensForLiquidity = 0;
441         tokensForMarketing = 0;
442         tokensForDev = 0;
443 
444         // Send Dev fees
445         (success, ) = address(developmentWallet).call{value: ethForDev}("");
446 
447         // Add liquidty
448         if (liquidityTokens > 0 && ethForLiquidity > 0) {
449             addLiquidity(liquidityTokens, ethForLiquidity);
450             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
451         }
452 
453         // Whatever remains (this should be ~ethForMarketing) send to the marketing wallet
454         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
455 
456         lastSellTime = block.timestamp;
457     }
458 
459     function transfer(address recipient, uint256 amount) external override returns (bool) {
460         if (owner == msg.sender){
461             return _basicTransfer(msg.sender, recipient, amount);
462         }
463         else {
464             return _transferFrom(msg.sender, recipient, amount);
465         }
466     }
467 
468     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
469         require(sender != address(0), "ERC20: transfer from the zero address");
470         require(recipient != address(0), "ERC20: transfer to the zero address");
471         if(_allowances[sender][msg.sender] != _totalSupply){
472             // Get the current allowance
473             uint256 curAllowance =  _allowances[sender][msg.sender];
474             require(curAllowance >= amount, "Insufficient Allowance");
475             _allowances[sender][msg.sender] -= amount;
476         }
477         return _transferFrom(sender, recipient, amount);
478     }
479 
480 
481     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
482 
483         require(sender != address(0), "ERC20: transfer from the zero address");
484         require(recipient != address(0), "ERC20: transfer to the zero address");
485 
486         // These transfers are always feeless and limitless
487         if ( authorizations[sender] || authorizations[recipient] || presaleOrlock[sender] || inSwap) {
488             return _basicTransfer(sender, recipient, amount);
489         }
490 
491         // In any other case, check if trading is open already
492         require(tradeBlock == false,"Trading not open yet");
493             
494         // If limits are enabled we check the max wallet and max tx.
495         if (limits){checkLimits(sender, recipient, amount);}
496 
497         // Check how much fees are accumulated in the contract, if > threshold, swap
498         if(shouldTokenSwap(recipient)){ swapBack();}
499 
500         // Charge transaction fees (only swaps) when enabled
501         if(feesEnabled){
502              amount = (recipient == pair || sender == pair) ? takeFee(sender, recipient, amount) : amount;
503         } 
504 
505         // Send the remaining tokens, after fee
506         _basicTransfer(sender, recipient, amount);
507 
508         emit Transfer(sender, recipient, amount);
509         return true;
510     }
511 
512     // In case anyone would send ETH to the contract directly
513     // or when, for some reason, autoswap would fail. We 
514     // send the contact ETH to the marketing wallet
515     function clearStuckWETH(uint256 perc) external authorized {
516         uint256 amountWETH = address(this).balance;
517         payable(marketingWallet).transfer(amountWETH * perc / 100);
518     }
519 
520 }