1 // SPDX-License-Identifier: UNLICENSED
2 
3 
4 pragma solidity =0.8.15;
5 
6 interface IERC20 {
7   function totalSupply() external view returns (uint256);
8   function decimals() external view returns (uint8);
9   function symbol() external view returns (string memory);
10   function name() external view returns (string memory);
11   function getOwner() external view returns (address);
12   function balanceOf(address account) external view returns (uint256);
13   function transfer(address recipient, uint256 amount) external returns (bool);
14   function allowance(address _owner, address spender) external view returns (uint256);
15   function approve(address spender, uint256 amount) external returns (bool);
16   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 interface IDexFactory {
22     function createPair(address tokenA, address tokenB) external returns (address pair);
23 }
24 
25 interface IDexRouter {
26     function addLiquidityETH(
27         address token,
28         uint amountTokenDesired,
29         uint amountTokenMin,
30         uint amountETHMin,
31         address to,
32         uint deadline
33     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
34     function swapExactETHForTokensSupportingFeeOnTransferTokens(
35         uint amountOutMin,
36         address[] calldata path,
37         address to,
38         uint deadline
39     ) external payable;
40     function swapExactTokensForETHSupportingFeeOnTransferTokens(
41         uint amountIn,
42         uint amountOutMin,
43         address[] calldata path,
44         address to,
45         uint deadline
46     ) external;
47     function factory() external pure returns (address);
48     function WETH() external pure returns (address);
49 
50 }
51 
52 interface IDexPair {
53     event Sync(uint112 reserve0, uint112 reserve1);
54     function sync() external;
55 }
56 
57 abstract contract Ownable {
58     address private _owner;
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60     constructor () {
61         address msgSender = msg.sender;
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65     function owner() public view returns (address) {
66         return _owner;
67     }
68     modifier onlyOwner() {
69         require(owner() == msg.sender, "Ownable: caller is not the owner");
70         _;
71     }
72     function renounceOwnership() external onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76     function transferOwnership(address newOwner) public onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 }
82 
83 pragma solidity =0.8.15;
84 contract Third_Degree_Burn is IERC20, Ownable //clientchange
85 {
86     mapping (address => uint) private _balances;
87     mapping (address => mapping (address => uint)) private _allowances;
88     mapping(address => bool) private excludedFromLimits;
89     mapping(address => bool) public excludedFromFees;
90     mapping(address=>bool) public isAMM;
91     mapping (address => bool) public isBlacklisted;
92     mapping(address => User) user;
93     mapping(address =>bool) public floorHolder;
94 
95     struct User {
96         uint256 sold;
97         uint256 sellStamp;
98         uint256 dailyLimit;
99     }
100     string private constant _name = 'Third Degree Burn';
101     string private constant _symbol = '3DB';
102     uint8 private constant _decimals=18;
103 
104       uint private constant InitialSupply=333333333333* 10**_decimals;
105    uint public buyTax = 40; //10=1% 
106     uint public sellTax = 50;
107     uint public floorSellerTax = 99;
108     uint public transferTax = 0;
109     uint public burnTax=249; //burn+liquidity+project must = 1000
110     uint public liquidityTax=1;
111     uint public projectTax=750;
112     uint public swapTreshold=2; //Dynamic Swap Threshold based on price impact. 1=0.1% max 10
113     uint public overLiquifyTreshold=100;
114     uint public LaunchTimestamp;
115     uint public devShare=15; //devShare+buybackShare+marketingShare must = 100
116     uint public buybackShare=65;
117     uint public marketingShare=20;
118     uint constant TAX_DENOMINATOR=1000;
119     uint constant MAXTAXDENOMINATOR=10;
120 
121     uint256 public maxWalletBalance;
122     uint256 public maxTransactionAmount;
123     uint256 public percentForLPBurn = 50; // 25 = .25%
124     uint256 public lpBurnFrequency = 1 seconds;
125     uint256 public lastLpBurnTime;
126     uint256 public manualBurnFrequency = 30 minutes;
127     uint256 public lastManualLpBurnTime;
128     uint256 public dailySellPercent = 1000;
129     uint256 public dailySellCooldown = 24 hours;
130 
131 
132     bool private _isSwappingContractModifier;
133     bool public manualSwap;
134     bool public blacklistMode = true;
135     bool public lpBurnEnabled = true;
136     bool public floorMode = true;
137     bool public floorBuyerRound = true;
138 
139     IDexRouter private  _DexRouter;
140 
141     address private _PairAddress;
142     address public marketingWallet;
143     address public devWallet;
144     address public constant burnWallet = address(0xdead);
145     address private constant DexRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ; //
146 
147     event ManualNukeLP();
148     event AutoNukeLP();
149     event BlacklistStatusChange(bool status);
150     event MaxWalletBalanceUpdated(uint256 percent);
151     event OnSetTaxes(uint buy, uint sell, uint transfer_, uint burn, uint project,uint liquidity,uint FloorSellTax);
152     event ExcludeAccount(address account, bool exclude);
153     event OnEnableTrading();
154     event OnReleaseLP();
155     event ExcludeFromLimits(address account, bool exclude);
156     event MarketingWalletChange(address newWallet);
157     event DevWalletChange(address newWallet);
158     event SharesUpdated(uint _devShare, uint _marketingShare, uint _buybackShare);
159     event AMMadded(address AMM);
160     event ManualSwapOn(bool manual);
161     event ManualSwapPerformed();
162     event MaxTransactionAmountUpdated(uint256 percent);
163     event SwapThresholdChange(uint newSwapTresholdPermille);
164     event BlacklistUpdated();
165     event OverLiquifiedThresholdChange(uint newOverLiquifyTresholdPermille);
166 
167 
168     modifier lockTheSwap {
169         _isSwappingContractModifier = true;
170         _;
171         _isSwappingContractModifier = false;
172     }
173 
174     constructor () {
175         uint ownerBalance=InitialSupply;
176         _balances[msg.sender] = ownerBalance;
177         emit Transfer(address(0), msg.sender, ownerBalance);
178 
179         _DexRouter = IDexRouter(DexRouter);
180         _PairAddress = IDexFactory(_DexRouter.factory()).createPair(address(this), _DexRouter.WETH());
181         isAMM[_PairAddress]=true;
182         
183         marketingWallet=0x36385DAA46Aa351E6Cc2533bb76e9cFcC1F40132; //
184         devWallet=0x36385DAA46Aa351E6Cc2533bb76e9cFcC1F40132; //
185 
186         excludedFromFees[msg.sender]=true;
187         excludedFromFees[DexRouter]=true;
188         excludedFromFees[address(this)]=true;
189         excludedFromLimits[burnWallet] = true;
190         excludedFromLimits[address(this)] = true;
191     }
192      function BlacklistStatus(bool _status) external onlyOwner {
193         blacklistMode = _status;
194         emit BlacklistStatusChange (_status);
195     }
196     function ManageBlacklist(address[] calldata addresses, bool status) external onlyOwner {
197         for (uint256 i; i < addresses.length; ++i) {
198             isBlacklisted[addresses[i]] = status;
199         }
200         emit BlacklistUpdated();
201     }
202     function ManageFloorHolders(address[] calldata addresses, bool status) external onlyOwner {
203         for (uint256 i; i < addresses.length; ++i) {
204             floorHolder[addresses[i]] = status;
205         }
206     }
207     function ChangeMarketingWallet(address newWallet) external onlyOwner{
208         marketingWallet=newWallet;
209         emit MarketingWalletChange(newWallet);
210     }
211     function ChangeDevWallet(address newWallet) external onlyOwner{
212         devWallet=newWallet;
213         emit DevWalletChange(newWallet);
214     }
215     function SetFeeShares(uint _devShare, uint _marketingShare, uint _buybackShare, uint _charityShare) external onlyOwner{
216         require(_devShare+_marketingShare+_buybackShare+_charityShare<=100);
217         devShare=_devShare;
218         marketingShare=_marketingShare;
219         buybackShare=_buybackShare;
220         emit SharesUpdated(_devShare, _marketingShare, _buybackShare);
221     }
222     function setMaxWalletBalancePercent(uint256 percent) external onlyOwner {
223         require(percent >= 10, "min 1%");
224         require(percent <= 1000, "max 100%");
225         maxWalletBalance = InitialSupply * percent / 1000;
226         emit MaxWalletBalanceUpdated(percent);
227     }
228     function setMaxTransactionAmount(uint256 percent) external onlyOwner {
229         require(percent >= 25, "min 0.25%");
230         require(percent <= 10000, "max 100%");
231         maxTransactionAmount = InitialSupply * percent / 10000;
232         emit MaxTransactionAmountUpdated(percent);
233     }
234     function ToggleFloorMode(bool onOff) external onlyOwner {
235         floorMode=onOff;
236     }
237     function ToggleFloorBuyerPeriod(bool onOff) external onlyOwner {
238         floorBuyerRound=onOff;
239     }
240     function setDailySellPercent(uint256 percentInHundreds) external onlyOwner {
241         require(percentInHundreds >= 100, "Cannot set below 1%.");
242         dailySellPercent = percentInHundreds;
243     }
244     function setDailySellCooldown(uint256 timeInSeconds) external onlyOwner {
245         require(timeInSeconds <= 24 hours, "Cannot set above 24 hours.");
246         dailySellCooldown = timeInSeconds;
247     }
248     function getUserInfo(address account) external view returns(uint256, uint256, uint256) {
249         User memory _user = user[account];
250         return(_user.sold, _user.dailyLimit, _user.sellStamp);
251     }
252     function getSecondsToNextSellReset(address account) external view returns(uint256) {
253         uint256 time = user[account].sellStamp + dailySellCooldown;
254         if (time > block.timestamp) {
255             return(time - block.timestamp);
256         } else {
257             return 0;
258         }
259     }
260     function _transfer(address sender, address recipient, uint amount) private{
261         require(sender != address(0), "Transfer from zero");
262         require(recipient != address(0), "Transfer to zero");
263         if(blacklistMode){
264             require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");    
265         }
266         if(excludedFromFees[sender] || excludedFromFees[recipient])
267             _feelessTransfer(sender, recipient, amount);
268         else { 
269             require(LaunchTimestamp>0,"trading not yet enabled");
270             _taxedTransfer(sender,recipient,amount);                  
271         }
272     }
273     
274     function _taxedTransfer(address sender, address recipient, uint amount) private{
275         uint senderBalance = _balances[sender];
276         require(senderBalance >= amount, "Transfer exceeds balance");
277         bool excludedAccount = excludedFromLimits[sender] || excludedFromLimits[recipient];
278         if (isAMM[sender] &&
279             !excludedAccount) {
280             require(
281                 amount <= maxTransactionAmount,
282                 "Transfer amount exceeds the maxTxAmount."
283             );
284             uint256 contractBalanceRecepient = balanceOf(recipient);
285             require(
286                 contractBalanceRecepient + amount <= maxWalletBalance,
287                 "Exceeds maximum wallet token amount."
288             );
289         } else if (
290             isAMM[recipient] &&
291             !excludedAccount
292         ) {
293             require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTxAmount.");
294         }
295 
296         bool isBuy=isAMM[sender];
297         bool isSell=isAMM[recipient];
298         uint tax;
299         if(isSell){  
300             uint SellTaxDuration=1 seconds;      
301             if(block.timestamp<LaunchTimestamp+SellTaxDuration){
302                 tax=_getStartTax(SellTaxDuration,200);
303                 }
304             if(floorMode && floorHolder[sender]){
305                         tax=floorSellerTax;
306                         if(user[sender].sellStamp + dailySellCooldown > block.timestamp) {
307                             uint256 addition = user[sender].sold + amount;
308                             require(addition <= user[sender].dailyLimit, "Sell amount exceeds daily limit.");
309                             user[sender].sold = addition;
310                         } else {
311                             user[sender].dailyLimit = (balanceOf(sender) * dailySellPercent) / 10000;
312                             require(amount <= user[sender].dailyLimit, "Sell amount exceeds daily limit.");
313                             user[sender].sold = amount;
314                             user[sender].sellStamp = block.timestamp;
315                         }
316             }else tax=sellTax;}
317         else if(isBuy){
318             if(floorBuyerRound){
319                 require(floorHolder[recipient]);
320             }
321             uint BuyTaxDuration=1 seconds;
322             if(block.timestamp<LaunchTimestamp+BuyTaxDuration){
323                 tax=_getStartTax(BuyTaxDuration,999);
324             }else tax=buyTax;
325         }else{ 
326             require(!floorMode || !floorHolder[recipient] && !floorHolder[sender], "Cannot send tokens to a floor holder"); 
327             tax=transferTax;
328         }
329 
330         if((sender!=_PairAddress)&&(!manualSwap)&&(!_isSwappingContractModifier))
331             _swapContractToken(false);
332 
333         if(!_isSwappingContractModifier && isAMM[recipient] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency){
334             autoBurnLPTokens();
335         }
336 
337         uint tokensToBeSentToBurn=_calculateFee(amount, tax, burnTax);
338         uint contractToken=_calculateFee(amount, tax, projectTax+liquidityTax);
339         uint taxedAmount=amount-(tokensToBeSentToBurn + contractToken);
340 
341         _balances[sender]-=amount;
342         _balances[address(this)] += contractToken;
343         _balances[burnWallet]+=tokensToBeSentToBurn;
344         _balances[recipient]+=taxedAmount;
345         emit Transfer(sender,burnWallet,tokensToBeSentToBurn);
346         emit Transfer(sender,recipient,taxedAmount);
347     }
348     function _getStartTax(uint duration, uint maxTax) private view returns (uint){
349         uint timeSinceLaunch=block.timestamp-LaunchTimestamp;
350         return maxTax-((maxTax-50)*timeSinceLaunch/duration);
351     }
352     function _calculateFee(uint amount, uint tax, uint taxPercent) private pure returns (uint) {
353         return (amount*tax*taxPercent) / (TAX_DENOMINATOR*TAX_DENOMINATOR);
354     }
355     function _feelessTransfer(address sender, address recipient, uint amount) private{
356         uint senderBalance = _balances[sender];
357         require(senderBalance >= amount, "Transfer exceeds balance");
358         _balances[sender]-=amount;
359         _balances[recipient]+=amount;      
360         emit Transfer(sender,recipient,amount);
361     }
362     function setSwapTreshold(uint newSwapTresholdPermille) external onlyOwner{
363         require(newSwapTresholdPermille<=10);//MaxTreshold= 1%
364         swapTreshold=newSwapTresholdPermille;
365         emit SwapThresholdChange(newSwapTresholdPermille);
366     }
367     function SetOverLiquifiedTreshold(uint newOverLiquifyTresholdPermille) external onlyOwner{
368         require(newOverLiquifyTresholdPermille<=1000);
369         overLiquifyTreshold=newOverLiquifyTresholdPermille;
370         emit OverLiquifiedThresholdChange(newOverLiquifyTresholdPermille);
371     }
372     function SetTaxes(uint buy, uint sell, uint transfer_, uint burn, uint project,uint liquidity, uint FloorSellTax) external onlyOwner{
373         uint maxTax=TAX_DENOMINATOR/MAXTAXDENOMINATOR;
374         require(buy<=maxTax&&sell<=maxTax&&transfer_<=maxTax&&FloorSellTax<=maxTax,"Tax exceeds maxTax");
375         require(burn+project+liquidity==TAX_DENOMINATOR,"Taxes don't add up to denominator");
376         buyTax=buy;
377         sellTax=sell;
378         floorSellerTax=FloorSellTax;
379         transferTax=transfer_;
380         projectTax=project;
381         liquidityTax=liquidity;
382         burnTax=burn;
383         emit OnSetTaxes(buy, sell, transfer_, burn, project, liquidity, FloorSellTax);
384     }
385     function isOverLiquified() public view returns(bool){
386         return _balances[_PairAddress]>getCirculatingSupply()*overLiquifyTreshold/1000;
387     }
388     function _swapContractToken(bool ignoreLimits) private lockTheSwap{
389         uint contractBalance=_balances[address(this)];
390         uint totalTax=liquidityTax+projectTax;
391         uint tokenToSwap=_balances[_PairAddress]*swapTreshold/1000;
392         if(totalTax==0)return;
393         if(ignoreLimits)
394             tokenToSwap=_balances[address(this)];
395         else if(contractBalance<tokenToSwap)
396             return;
397 
398         uint tokenForLiquidity=
399         isOverLiquified()?0
400         :(tokenToSwap*liquidityTax)/totalTax;
401 
402         uint tokenForProject= tokenToSwap-tokenForLiquidity;
403 
404         uint LiqHalf=tokenForLiquidity/2;
405         uint swapToken=LiqHalf+tokenForProject;
406         uint initialETHBalance=address(this).balance;
407         _swapTokenForETH(swapToken);
408         uint newETH=(address(this).balance - initialETHBalance);
409 
410         if(tokenForLiquidity>0){
411             uint liqETH = (newETH*LiqHalf)/swapToken;
412             _addLiquidity(LiqHalf, liqETH);
413         }
414         uint marketbalance=address(this).balance * marketingShare/100;
415         uint devbalance=address(this).balance * devShare/100;
416         uint buybackbalance=address(this).balance * buybackShare/100;
417         if(marketbalance>0){
418         (bool marketing,)=marketingWallet.call{value:marketbalance}("");
419         marketing=true;
420         }
421         if(devbalance>0){
422         (bool dev,)=devWallet.call{value:devbalance}("");
423         dev=true;
424         }
425         if(buybackbalance>0){
426             _buybackBurn(buybackbalance);
427         }
428     }
429     function _buybackBurn(uint amount) private {
430         address[] memory path = new address[](2);
431         path[0] = _DexRouter.WETH();
432         path[1] = address(this);
433         
434         try _DexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
435             0,
436             path,
437             burnWallet,
438             block.timestamp
439         ){}
440         catch{}
441     }
442     function _swapTokenForETH(uint amount) private {
443         _approve(address(this), address(_DexRouter), amount);
444         address[] memory path = new address[](2);
445         path[0] = address(this);
446         path[1] = _DexRouter.WETH();
447 
448         try _DexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
449             amount,
450             0,
451             path,
452             address(this),
453             block.timestamp
454         ){}
455         catch{}
456     }
457     function _addLiquidity(uint tokenamount, uint ethamount) private {
458         _approve(address(this), address(_DexRouter), tokenamount);
459         _DexRouter.addLiquidityETH{value: ethamount}(
460             address(this),
461             tokenamount,
462             0,
463             0,
464             address(this),
465             block.timestamp
466         );
467     }
468     function getBurnedTokens() external view returns(uint){
469         return _balances[address(0xdead)];
470     }
471     function getCirculatingSupply() public view returns(uint){
472         return InitialSupply-_balances[address(0xdead)];
473     }
474     function SetAMM(address AMM, bool Add) external onlyOwner{
475         require(AMM!=_PairAddress,"can't change pancake");
476         isAMM[AMM]=Add;
477         emit AMMadded(AMM);
478     }
479     function SwitchManualSwap(bool manual) external onlyOwner{
480         manualSwap=manual;
481         emit ManualSwapOn(manual);
482     }
483     function SwapContractToken() external onlyOwner{
484         _swapContractToken(true);
485         emit ManualSwapPerformed();
486     }
487     function ExcludeAccountFromFees(address account, bool exclude) external onlyOwner{
488         require(account!=address(this),"can't Include the contract");
489         excludedFromFees[account]=exclude;
490         emit ExcludeAccount(account,exclude);
491     }
492     function setExcludedAccountFromLimits(address account, bool exclude) external onlyOwner{
493         excludedFromLimits[account]=exclude;
494         emit ExcludeFromLimits(account,exclude);
495     }
496     function isExcludedFromLimits(address account) external view returns(bool) {
497         return excludedFromLimits[account];
498     }
499     function EnableTrading() external onlyOwner{
500         require(LaunchTimestamp==0,"AlreadyLaunched");
501         LaunchTimestamp=block.timestamp;
502         maxWalletBalance = InitialSupply * 10 / 1000;
503         maxTransactionAmount = InitialSupply * 100 / 10000;
504         emit OnEnableTrading();
505     }
506     function ReleaseLP() external onlyOwner {
507         IERC20 liquidityToken = IERC20(_PairAddress);
508         uint amount = liquidityToken.balanceOf(address(this));
509         liquidityToken.transfer(msg.sender, amount);
510         emit OnReleaseLP();
511     }
512     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
513         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
514         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
515         lpBurnFrequency = _frequencyInSeconds;
516         percentForLPBurn = _percent;
517         lpBurnEnabled = _Enabled;
518     }
519     
520     function autoBurnLPTokens() internal returns (bool){
521         lastLpBurnTime = block.timestamp;
522         uint256 liquidityPairBalance = this.balanceOf(_PairAddress);
523         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn/10000;
524         if (amountToBurn > 0){
525             _balances[burnWallet]+=amountToBurn;
526             emit Transfer(_PairAddress,burnWallet,amountToBurn);
527         }
528         IDexPair pair = IDexPair(_PairAddress);
529         pair.sync();
530         emit AutoNukeLP();
531         return true;
532     }
533 
534     function manualBurnLPTokens(uint256 percent) external onlyOwner returns (bool){
535         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
536         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
537         lastManualLpBurnTime = block.timestamp;
538         uint256 liquidityPairBalance = this.balanceOf(_PairAddress);
539         uint256 amountToBurn = liquidityPairBalance * percent/10000;
540         if (amountToBurn > 0){
541             _balances[burnWallet]+=amountToBurn;
542             emit Transfer(_PairAddress,burnWallet,amountToBurn);
543         }
544         IDexPair pair = IDexPair(_PairAddress);
545         pair.sync();
546         emit ManualNukeLP();
547         return true;
548     }
549 
550     function getOwner() external view override returns (address) {return owner();}
551     function name() external pure override returns (string memory) {return _name;}
552     function symbol() external pure override returns (string memory) {return _symbol;}
553     function decimals() external pure override returns (uint8) {return _decimals;}
554     function totalSupply() external pure override returns (uint) {return InitialSupply;}
555     function balanceOf(address account) public view override returns (uint) {return _balances[account];}
556     function allowance(address _owner, address spender) external view override returns (uint) {return _allowances[_owner][spender];}
557     function transfer(address recipient, uint amount) external override returns (bool) {
558         _transfer(msg.sender, recipient, amount);
559         return true;
560     }
561     function approve(address spender, uint amount) external override returns (bool) {
562         _approve(msg.sender, spender, amount);
563         return true;
564     }
565     function _approve(address owner, address spender, uint amount) private {
566         require(owner != address(0), "Approve from zero");
567         require(spender != address(0), "Approve to zero");
568         _allowances[owner][spender] = amount;
569         emit Approval(owner, spender, amount);
570     }
571     function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
572         _transfer(sender, recipient, amount);
573         uint currentAllowance = _allowances[sender][msg.sender];
574         require(currentAllowance >= amount, "Transfer > allowance");
575         _approve(sender, msg.sender, currentAllowance - amount);
576         return true;
577     }
578     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
579         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
580         return true;
581     }
582     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
583         uint currentAllowance = _allowances[msg.sender][spender];
584         require(currentAllowance >= subtractedValue, "<0 allowance");
585         _approve(msg.sender, spender, currentAllowance - subtractedValue);
586         return true;
587     }
588     receive() external payable {}
589 
590 }