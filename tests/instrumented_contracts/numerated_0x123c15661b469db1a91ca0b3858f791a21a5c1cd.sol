1 /*
2 $DOGMA 
3 
4 https://t.me/DogmaETH
5 */
6 
7 // SPDX-License-Identifier: UNLICENSED
8 
9 pragma solidity =0.8.17;
10 
11 interface IERC20 {
12   function totalSupply() external view returns (uint256);
13   function decimals() external view returns (uint8);
14   function symbol() external view returns (string memory);
15   function name() external view returns (string memory);
16   function getOwner() external view returns (address);
17   function balanceOf(address account) external view returns (uint256);
18   function transfer(address recipient, uint256 amount) external returns (bool);
19   function allowance(address _owner, address spender) external view returns (uint256);
20   function approve(address spender, uint256 amount) external returns (bool);
21   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 interface IDexPair {
27     event Sync(uint112 reserve0, uint112 reserve1);
28     function sync() external;
29 }
30 
31 interface IdexFactory {
32     function createPair(address tokenA, address tokenB) external returns (address pair);
33 }
34 
35 interface IdexRouter {
36     function addLiquidityETH(
37         address token,
38         uint amountTokenDesired,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
44     function swapExactTokensForETHSupportingFeeOnTransferTokens(
45         uint amountIn,
46         uint amountOutMin,
47         address[] calldata path,
48         address to,
49         uint deadline
50     ) external;
51     function factory() external pure returns (address);
52     function WETH() external pure returns (address);
53 
54 }
55 
56 abstract contract Ownable {
57     address private _owner;
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59     constructor () {
60         address msgSender = msg.sender;
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64     function owner() public view returns (address) {
65         return _owner;
66     }
67     modifier onlyOwner() {
68         require(owner() == msg.sender, "Ownable: caller is not the owner");
69         _;
70     }
71     function renounceOwnership() public onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75     function transferOwnership(address newOwner) public onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 }
81 contract DOGMA is IERC20, Ownable
82 {
83     //mapping
84     mapping (address => uint) private _balances;
85     mapping (address => mapping (address => uint)) private _allowances;
86     mapping(address => bool) private excludedFromLimits;
87     mapping(address => bool) public excludedFromFees;
88     mapping(address=>bool) public isPair;
89     //strings
90     string private constant _name = 'DOGMA';
91     string private constant _symbol = 'DOGMA';
92     //uints
93     uint public constant InitialSupply= 1000000 * 10**_decimals;
94     uint public buyTax = 60;
95     uint public sellTax = 60;
96     uint public transferTax = 80;
97     uint public liquidityTax=0;
98     uint public projectTax=1000;
99     uint constant TAX_DENOMINATOR=1000;
100     uint constant MAXTAXDENOMINATOR=10;
101     uint public swapTreshold=6;
102     uint public overLiquifyTreshold=600;
103     uint private LaunchTimestamp = 0;
104     uint8 private constant _decimals = 9;
105 
106     uint256 public maxTransactionAmount;
107     uint256 public maxWalletBalance;
108     uint256 public percentForLPBurn = 100; // 25 = .25%
109     uint256 public lpBurnFrequency = 2400 seconds;
110     uint256 public lastLpBurnTime;
111     uint256 public manualBurnFrequency = 20 minutes;
112     uint256 public lastManualLpBurnTime;
113 
114     IdexRouter private  _dexRouter;
115     
116     //addresses
117     address private dexRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
118     address private _dexPairAddress;
119     address constant deadWallet=address(0xdead);
120     address private projectWallet=0x51FCFDbBDfB42A2599f88db2e75EfB77b2E4cd2e;
121     address private lpReceiver;
122     //modifiers
123 
124     modifier lockTheSwap {
125         _isSwappingContractModifier = true;
126         _;
127         _isSwappingContractModifier = false;
128     }
129 
130     //bools
131     bool private _isSwappingContractModifier;
132     bool public blacklistMode = true;
133     bool public lpBurnEnabled = true;
134     bool public manualSwap;
135 
136     
137     constructor () {
138         uint deployerBalance= InitialSupply;
139         _balances[owner()] = deployerBalance;
140         emit Transfer(address(0), owner(), deployerBalance);
141         
142         lpReceiver=msg.sender;
143 
144         _dexRouter = IdexRouter(dexRouter);
145         _dexPairAddress = IdexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
146         isPair[_dexPairAddress]=true;
147 
148         excludedFromFees[owner()]=true;
149         excludedFromFees[dexRouter]=true;
150         excludedFromFees[address(this)]=true;
151 
152         excludedFromLimits[owner()] = true;
153         excludedFromLimits[deadWallet] = true;
154         excludedFromLimits[address(this)] = true;
155     }
156     function _transfer(address sender, address recipient, uint amount) private{
157         require(sender != address(0), "Transfer from zero");
158         require(recipient != address(0), "Transfer to zero");
159         if(excludedFromFees[sender] || excludedFromFees[recipient])
160             _feelessTransfer(sender, recipient, amount);
161         
162         else{
163             require(LaunchTimestamp>0,"trading not yet enabled");
164             _taxedTransfer(sender,recipient,amount);
165         }              
166     }
167     function _taxedTransfer(address sender, address recipient, uint amount) private{
168         uint senderBalance = _balances[sender];
169         require(senderBalance >= amount, "Transfer exceeds balance");
170         bool excludedAccount = excludedFromLimits[sender] || excludedFromLimits[recipient];
171         if (
172             isPair[sender] &&
173             !excludedAccount
174         ) {
175             require(
176                 amount <= maxTransactionAmount,
177                 "Transfer amount exceeds the maxTxAmount."
178             );
179             uint256 contractBalanceRecepient = balanceOf(recipient);
180             require(
181                 contractBalanceRecepient + amount <= maxWalletBalance,
182                 "Exceeds maximum wallet token amount."
183             );
184         } else if (
185             isPair[recipient] &&
186             !excludedAccount
187         ) {
188             require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
189         }
190 
191         bool isBuy=isPair[sender];
192         bool isSell=isPair[recipient];
193         uint tax;
194         if(isSell){  
195             uint SellTaxDuration=5 minutes;
196             if(block.timestamp<LaunchTimestamp+SellTaxDuration){
197                 tax=200;
198                 }else tax=sellTax;
199             }
200         else if(isBuy){
201             uint BuyTaxDuration=1 minutes;
202             if(block.timestamp<LaunchTimestamp+BuyTaxDuration){
203                 tax=60;
204             }else tax=buyTax;
205         } else{
206             uint256 contractBalanceRecepient = balanceOf(recipient);
207             require(
208                 contractBalanceRecepient + amount <= maxWalletBalance,
209                 "Exceeds maximum wallet token amount."
210             ); 
211             tax=transferTax;
212         }
213 
214         if((sender!=_dexPairAddress)&&(!manualSwap)&&(!_isSwappingContractModifier))
215             _swapContractToken(false);
216 
217         if(!_isSwappingContractModifier && isPair[recipient] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency){
218             autoBurnLPTokens();
219         }
220         
221         uint contractToken=_calculateFee(amount, tax, projectTax+liquidityTax);
222         uint taxedAmount=amount-contractToken;
223 
224         _balances[sender]-=amount;
225         _balances[address(this)] += contractToken;
226         _balances[recipient]+=taxedAmount;
227         
228         emit Transfer(sender,recipient,taxedAmount);
229     }
230     function _calculateFee(uint amount, uint tax, uint taxPercent) private pure returns (uint) {
231         return (amount*tax*taxPercent) / (TAX_DENOMINATOR*TAX_DENOMINATOR);
232     }
233     function _feelessTransfer(address sender, address recipient, uint amount) private{
234         uint senderBalance = _balances[sender];
235         require(senderBalance >= amount, "Transfer exceeds balance");
236         _balances[sender]-=amount;
237         _balances[recipient]+=amount;      
238         emit Transfer(sender,recipient,amount);
239     }
240     function setSwapTreshold(uint newSwapTresholdPermille) external onlyOwner{
241         require(newSwapTresholdPermille<=10);//MaxTreshold= 1%
242         swapTreshold=newSwapTresholdPermille;
243         emit SwapThresholdChange(newSwapTresholdPermille);
244     }
245     function SetOverLiquifiedTreshold(uint newOverLiquifyTresholdPermille) external onlyOwner{
246         require(newOverLiquifyTresholdPermille<=1000);
247         overLiquifyTreshold=newOverLiquifyTresholdPermille;
248         emit OverLiquifiedThresholdChange(newOverLiquifyTresholdPermille);
249     }
250     function SetTaxes(uint buy, uint sell, uint transfer_, uint project,uint liquidity) external onlyOwner{
251         uint maxTax=150;
252         require(buy<=maxTax&&sell<=maxTax&&transfer_<=maxTax,"Tax exceeds maxTax");
253         require(project+liquidity==TAX_DENOMINATOR,"Taxes don't add up to denominator");
254         buyTax=buy;
255         sellTax=sell;
256         transferTax=transfer_;
257         projectTax=project;
258         liquidityTax=liquidity;
259         emit OnSetTaxes(buy, sell, transfer_, project,liquidity);
260     }
261     
262     function isOverLiquified() public view returns(bool){
263         return _balances[_dexPairAddress]>getCirculatingSupply()*overLiquifyTreshold/1000;
264     }
265     function _swapContractToken(bool ignoreLimits) private lockTheSwap{
266         uint contractBalance=_balances[address(this)];
267         uint totalTax=liquidityTax+projectTax;
268         uint tokenToSwap=_balances[_dexPairAddress]*swapTreshold/1000;
269         if(totalTax==0)return;
270         if(ignoreLimits)
271             tokenToSwap=_balances[address(this)];
272         else if(contractBalance<tokenToSwap)
273             return;
274         uint tokenForLiquidity=isOverLiquified()?0:(tokenToSwap*liquidityTax)/totalTax;
275 
276         uint tokenForProject= tokenToSwap-tokenForLiquidity;
277 
278         uint LiqHalf=tokenForLiquidity/2;
279         uint swapToken=LiqHalf+tokenForProject;
280         uint initialETHBalance = address(this).balance;
281         _swapTokenForETH(swapToken);
282         uint newETH=(address(this).balance - initialETHBalance);
283         if(tokenForLiquidity>0){
284             uint liqETH = (newETH*LiqHalf)/swapToken;
285             _addLiquidity(LiqHalf, liqETH);
286         }
287         (bool sent,)=projectWallet.call{value:address(this).balance}("");
288         sent=true;
289     }
290     function _swapTokenForETH(uint amount) private {
291         _approve(address(this), address(_dexRouter), amount);
292         address[] memory path = new address[](2);
293         path[0] = address(this);
294         path[1] = _dexRouter.WETH();
295 
296         try _dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
297             amount,
298             0,
299             path,
300             address(this),
301             block.timestamp
302         ){}
303         catch{}
304     }
305     function _addLiquidity(uint tokenamount, uint ETHamount) private {
306         _approve(address(this), address(_dexRouter), tokenamount);
307         _dexRouter.addLiquidityETH{value: ETHamount}(
308             address(this),
309             tokenamount,
310             0,
311             0,
312             lpReceiver,
313             block.timestamp
314         );
315     }
316     function getBurnedTokens() public view returns(uint){
317         return _balances[address(0xdead)];
318     }
319     function getCirculatingSupply() public view returns(uint){
320         return InitialSupply-_balances[address(0xdead)];
321     }
322     function SetPair(address Pair, bool Add) external onlyOwner{
323         require(Pair!=_dexPairAddress,"can't change uniswap pair");
324         require(Pair != address(0),"Address should not be 0");
325         isPair[Pair]=Add;
326         emit NewPairSet(Pair,Add);
327     }
328     function SwitchManualSwap(bool manual) external onlyOwner{
329         manualSwap=manual;
330         emit ManualSwapChange(manual);
331     }
332     function SwapContractToken() external onlyOwner{
333         _swapContractToken(false);
334         emit OwnerSwap();
335     }
336 
337     function SetNewRouter(address _newdex) external onlyOwner{
338         require(_newdex != address(0),"Address should not be 0");
339         require(_newdex != dexRouter,"Address is same");
340         dexRouter = _newdex;
341         emit NewRouterSet(_newdex);
342     }
343 
344     function SetProjectWallet(address _address) external onlyOwner{
345         require(_address != address(0),"Address should not be 0");
346         require(_address != projectWallet,"Address is same");
347         projectWallet = _address;
348         emit NewProjectWalletSet(_address);
349     }
350 
351     function SetLPreceiver(address _address) external onlyOwner{
352         require(_address != projectWallet,"Address is same");
353         lpReceiver = _address;
354     }
355 
356     function SetMaxWalletBalancePercent(uint256 percent) external onlyOwner {
357         require(percent >= 10, "min 1%");
358         require(percent <= 1000, "max 100%");
359         maxWalletBalance = InitialSupply * percent / 1000;
360         emit MaxWalletBalanceUpdated(percent);
361     }
362     
363     function SetMaxTransactionAmount(uint256 percent) external onlyOwner {
364         require(percent >= 25, "min 0.25%");
365         require(percent <= 10000, "max 100%");
366         maxTransactionAmount = InitialSupply * percent / 10000;
367         emit MaxTransactionAmountUpdated(percent);
368     }
369     
370     function ExcludeAccountFromFees(address account, bool exclude) external onlyOwner{
371         require(account!=address(this),"can't Include the contract");
372         require(account != address(0),"Address should not be 0");
373         excludedFromFees[account]=exclude;
374         emit ExcludeAccount(account,exclude);
375     }
376     
377     function SetExcludedAccountFromLimits(address account, bool exclude) external onlyOwner{
378         require(account != address(0),"Address should not be 0");
379         excludedFromLimits[account]=exclude;
380         emit ExcludeFromLimits(account,exclude);
381     }
382     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
383         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
384         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
385         lpBurnFrequency = _frequencyInSeconds;
386         percentForLPBurn = _percent;
387         lpBurnEnabled = _Enabled;
388     }
389     function autoBurnLPTokens() internal returns (bool){
390         lastLpBurnTime = block.timestamp;
391         uint256 liquidityPairBalance = this.balanceOf(_dexPairAddress);
392         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn/10000;
393         if (amountToBurn > 0){
394             _balances[_dexPairAddress]-=amountToBurn;
395             _balances[deadWallet]+=amountToBurn;
396             emit Transfer(_dexPairAddress,deadWallet,amountToBurn);
397         }
398         IDexPair pair = IDexPair(_dexPairAddress);
399         pair.sync();
400         emit AutoNukeLP();
401         return true;
402     }
403 
404     function manualBurnLPTokens(uint256 percent) external onlyOwner returns (bool){
405         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
406         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
407         lastManualLpBurnTime = block.timestamp;
408         uint256 liquidityPairBalance = this.balanceOf(_dexPairAddress);
409         uint256 amountToBurn = liquidityPairBalance * percent/10000;
410         if (amountToBurn > 0){
411             _balances[_dexPairAddress]-=amountToBurn;
412             _balances[deadWallet]+=amountToBurn;
413             emit Transfer(_dexPairAddress,deadWallet,amountToBurn);
414         }
415         IDexPair pair = IDexPair(_dexPairAddress);
416         pair.sync();
417         emit ManualNukeLP();
418         return true;
419     }
420     
421     function SetupEnableTrading() external onlyOwner{
422         require(LaunchTimestamp==0,"AlreadyLaunched");
423         LaunchTimestamp=block.timestamp;
424         maxWalletBalance = InitialSupply * 20 / 1000;
425         maxTransactionAmount = InitialSupply * 200 / 10000;
426         emit OnEnableTrading();
427     }
428     receive() external payable {}
429 
430     function getOwner() external view override returns (address) {return owner();}
431     function name() external pure override returns (string memory) {return _name;}
432     function symbol() external pure override returns (string memory) {return _symbol;}
433     function decimals() external pure override returns (uint8) {return _decimals;}
434     function totalSupply() external pure override returns (uint) {return InitialSupply;}
435     function balanceOf(address account) public view override returns (uint) {return _balances[account];}
436     function isExcludedFromLimits(address account) public view returns(bool) {return excludedFromLimits[account];}
437     function transfer(address recipient, uint amount) external override returns (bool) {
438         _transfer(msg.sender, recipient, amount);
439         return true;
440     }
441     function allowance(address _owner, address spender) external view override returns (uint) {
442         return _allowances[_owner][spender];
443     }
444     function approve(address spender, uint amount) external override returns (bool) {
445         _approve(msg.sender, spender, amount);
446         return true;
447     }
448     function _approve(address owner, address spender, uint amount) private {
449         require(owner != address(0), "Approve from zero");
450         require(spender != address(0), "Approve to zero");
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454     function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
455         _transfer(sender, recipient, amount);
456         uint currentAllowance = _allowances[sender][msg.sender];
457         require(currentAllowance >= amount, "Transfer > allowance");
458         _approve(sender, msg.sender, currentAllowance - amount);
459         return true;
460     }
461     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
462         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
463         return true;
464     }
465     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
466         uint currentAllowance = _allowances[msg.sender][spender];
467         require(currentAllowance >= subtractedValue, "<0 allowance");
468         _approve(msg.sender, spender, currentAllowance - subtractedValue);
469         return true;
470     }
471     function emergencyETHrecovery(uint256 amountPercentage) external onlyOwner {
472         uint256 amountETH = address(this).balance;
473         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
474         emit RecoverETH();
475     }
476     function emergencyTokenrecovery(address tokenAddress, uint256 amountPercentage) external onlyOwner {
477         require(tokenAddress!=address(0)&&tokenAddress!=address(_dexPairAddress)&&tokenAddress!=address(this));
478         IERC20 token = IERC20(tokenAddress);
479         uint256 tokenAmount = token.balanceOf(address(this));
480         token.transfer(msg.sender, tokenAmount * amountPercentage / 100);
481         emit RecoverTokens(tokenAmount);
482     }
483     //events
484     event ManualNukeLP();
485     event AutoNukeLP();
486     event BlacklistStatusChange(bool status);
487     event SwapThresholdChange(uint threshold);
488     event OverLiquifiedThresholdChange(uint threshold);
489     event OnSetTaxes(uint buy, uint sell, uint transfer_, uint project,uint liquidity);
490     event ManualSwapChange(bool status);
491     event MaxWalletBalanceUpdated(uint256 percent);
492     event MaxTransactionAmountUpdated(uint256 percent);
493     event ExcludeAccount(address account, bool exclude);
494     event ExcludeFromLimits(address account, bool exclude);
495     event OwnerSwap();
496     event OnEnableTrading();
497     event RecoverETH();
498     event BlacklistUpdated();
499     event NewPairSet(address Pair, bool Add);
500     event NewRouterSet(address _newdex);
501     event NewProjectWalletSet(address _address);
502     event RecoverTokens(uint256 amount);
503 
504 }