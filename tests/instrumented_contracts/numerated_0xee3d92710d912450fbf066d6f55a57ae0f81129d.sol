1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.10;
4 
5 interface IBEP20 {
6   function totalSupply() external view returns (uint256);
7   function decimals() external view returns (uint8);
8   function symbol() external view returns (string memory);
9   function name() external view returns (string memory);
10   function getOwner() external view returns (address);
11   function balanceOf(address account) external view returns (uint256);
12   function transfer(address recipient, uint256 amount) external returns (bool);
13   function allowance(address _owner, address spender) external view returns (uint256);
14   function approve(address spender, uint256 amount) external returns (bool);
15   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 interface IdexFactory {
21     function createPair(address tokenA, address tokenB) external returns (address pair);
22 }
23 
24 interface IdexRouter {
25     function addLiquidityETH(
26         address token,
27         uint amountTokenDesired,
28         uint amountTokenMin,
29         uint amountETHMin,
30         address to,
31         uint deadline
32     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
33     function swapExactTokensForETHSupportingFeeOnTransferTokens(
34         uint amountIn,
35         uint amountOutMin,
36         address[] calldata path,
37         address to,
38         uint deadline
39     ) external;
40     function factory() external pure returns (address);
41     function WETH() external pure returns (address);
42 
43 }
44 
45 interface ITaxSplitter {
46     function taxReceive() external payable;    
47 }
48 
49 abstract contract Ownable {
50     address private _owner;
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52     constructor () {
53         address msgSender = msg.sender;
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57     function owner() public view returns (address) {
58         return _owner;
59     }
60     modifier onlyOwner() {
61         require(owner() == msg.sender, "Ownable: caller is not the owner");
62         _;
63     }
64     function renounceOwnership() public onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68     function transferOwnership(address newOwner) public onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 contract Kyuubi is IBEP20, Ownable
75 {
76     //TresFlames
77     //mapping
78     mapping (address => uint) private _balances;
79     mapping (address => mapping (address => uint)) private _allowances;
80     mapping(address => bool) private excludedFromLimits;
81     mapping(address => bool) public excludedFromFees;
82     mapping(address=>bool) public isPair;
83     mapping (address => bool) public isBlacklisted;
84     //strings
85     string private constant _name = 'Kyuubi';
86     string private constant _symbol = '$KYUB';
87     //uints
88     uint private constant DefaultLiquidityLockTime=7 days;
89     uint public constant InitialSupply= 10**12 * 10**_decimals;
90     uint public _circulatingSupply =InitialSupply;
91     uint public buyTax = 90;
92     uint public sellTax = 90;
93     uint public transferTax = 90;
94     uint public liquidityTax=200;
95     uint public splitterTax=800;
96     uint constant TAX_DENOMINATOR=1000;
97     uint constant MAXTAXDENOMINATOR=10;
98     uint public swapTreshold=1;
99     uint public overLiquifyTreshold=100;
100     uint private LaunchTimestamp;
101     uint _liquidityUnlockTime;
102     uint8 private constant _decimals = 18;
103     uint256 public maxTransactionAmount;
104     uint256 public maxWalletBalance;
105 
106     IdexRouter private  _dexRouter;
107     
108     //addresses
109     address private dexRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
110     address private _dexPairAddress;
111     address constant deadWallet = 0x000000000000000000000000000000000000dEaD;
112     address payable public taxSplitter;
113     address public multisig;
114     //modifiers
115     modifier onlyMultisig() {
116         require(msg.sender == multisig);
117         _;
118     }
119 
120     modifier lockTheSwap {
121         _isSwappingContractModifier = true;
122         _;
123         _isSwappingContractModifier = false;
124     }
125 
126     //bools
127     bool private _isSwappingContractModifier;
128     bool public blacklistMode = true;
129     bool public manualSwap;
130     bool public LPReleaseLimitedTo20Percent;
131     
132     //events
133     event MultisigUpdate(address multisig);
134     event BlacklistStatusChange(bool status);
135     event UpdateTaxSplitter(address _contract);
136     event SwapThresholdChange(uint threshold);
137     event OverLiquifiedThresholdChange(uint threshold);
138     event OnSetTaxes(uint buy, uint sell, uint transfer_, uint splitter,uint liquidity);
139     event ManualSwapChange(bool status);
140     event MaxWalletBalanceUpdated(uint256 percent);
141     event MaxTransactionAmountUpdated(uint256 percent);
142     event ExcludeAccount(address account, bool exclude);
143     event ExcludeFromLimits(address account, bool exclude);
144     event OwnerSwap();
145     event OnEnableTrading();
146     event OnProlongLPLock(uint UnlockTimestamp);
147     event OnReleaseLP();
148     event RecoverBNB();
149     event BlacklistUpdated();
150     event NewPairSet(address Pair, bool Add);
151     event Release20PercentLP();
152     event NewRouterSet(address _newdex);
153     
154     constructor () {
155         uint deployerBalance=_circulatingSupply;
156         _balances[msg.sender] = deployerBalance;
157         emit Transfer(address(0), msg.sender, deployerBalance);
158         _dexRouter = IdexRouter(dexRouter);
159         _dexPairAddress = IdexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
160         isPair[_dexPairAddress]=true;
161         
162         taxSplitter = payable(0xbF2d9657BdF428AFd4F7f1B7f51279E99cc51A82);
163         multisig = 0x686cEd60f145fB062BDc82DDecd4FCef26A643D2;
164 
165         excludedFromFees[msg.sender]=true;
166         excludedFromFees[dexRouter]=true;
167         excludedFromFees[address(this)]=true;
168         excludedFromFees[taxSplitter]=true;
169         excludedFromFees[multisig]=true;
170         excludedFromFees[0x505610adB4D5DE12E1586f93355F40a412984132]=true;
171         excludedFromLimits[multisig] = true;
172         excludedFromLimits[taxSplitter] = true;
173         excludedFromLimits[0x505610adB4D5DE12E1586f93355F40a412984132] = true;
174         excludedFromLimits[msg.sender] = true;
175         excludedFromLimits[deadWallet] = true;
176         excludedFromLimits[address(this)] = true;
177     }
178     
179     function enable_blacklist(bool _status) public onlyMultisig {
180         blacklistMode = _status;
181         emit BlacklistStatusChange (_status);
182     }
183     function manage_blacklist(address[] calldata addresses, bool status) public onlyMultisig {
184         for (uint256 i; i < addresses.length; ++i) {
185             isBlacklisted[addresses[i]] = status;
186         }
187         emit BlacklistUpdated();
188     }
189     function setMultisig(address _multisig) external onlyMultisig {
190         multisig = _multisig;
191         excludedFromFees[_multisig] = true;
192         excludedFromLimits[_multisig] = true;
193         emit MultisigUpdate(_multisig);
194     }
195     function ChangeTaxSplitter(address newContract) public onlyMultisig{
196         taxSplitter=payable(newContract);
197         excludedFromFees[newContract] = true;
198         excludedFromLimits[newContract] = true;
199         emit UpdateTaxSplitter(newContract);
200     }
201     function _transfer(address sender, address recipient, uint amount) private{
202         require(sender != address(0), "Transfer from zero");
203         require(recipient != address(0), "Transfer to zero");
204         if(blacklistMode){
205             require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");    
206         }
207         if(excludedFromFees[sender] || excludedFromFees[recipient])
208             _feelessTransfer(sender, recipient, amount);
209         
210         else { 
211             require(LaunchTimestamp>0,"trading not yet enabled");
212             _taxedTransfer(sender,recipient,amount);                  
213         }
214     }
215     function _taxedTransfer(address sender, address recipient, uint amount) private{
216         uint senderBalance = _balances[sender];
217         require(senderBalance >= amount, "Transfer exceeds balance");
218         bool excludedAccount = excludedFromLimits[sender] || excludedFromLimits[recipient];
219         if (
220             isPair[sender] &&
221             !excludedAccount
222         ) {
223             require(
224                 amount <= maxTransactionAmount,
225                 "Transfer amount exceeds the maxTxAmount."
226             );
227             uint256 contractBalanceRecepient = balanceOf(recipient);
228             require(
229                 contractBalanceRecepient + amount <= maxWalletBalance,
230                 "Exceeds maximum wallet token amount."
231             );
232         } else if (
233             isPair[recipient] &&
234             !excludedAccount
235         ) {
236             require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
237         }
238 
239         bool isBuy=isPair[sender];
240         bool isSell=isPair[recipient];
241         uint tax;
242         if(isSell){  
243             uint SellTaxDuration=48 hours;          
244             if(block.timestamp<LaunchTimestamp+SellTaxDuration){
245                 tax=_getStartTax(SellTaxDuration,200);
246                 }else tax=sellTax;
247             }
248         else if(isBuy){
249             uint BuyTaxDuration=10 minutes;
250             if(block.timestamp<LaunchTimestamp+BuyTaxDuration){
251                 tax=_getStartTax(BuyTaxDuration,200);
252             }else tax=buyTax;
253         } else tax=transferTax;
254 
255         if((sender!=_dexPairAddress)&&(!manualSwap)&&(!_isSwappingContractModifier))
256             _swapContractToken(false);
257         uint contractToken=_calculateFee(amount, tax, splitterTax+liquidityTax);
258         uint taxedAmount=amount-contractToken;
259 
260         _balances[sender]-=amount;
261         _balances[address(this)] += contractToken;
262         _balances[recipient]+=taxedAmount;
263         
264         emit Transfer(sender,recipient,taxedAmount);
265     }
266     function _getStartTax(uint duration, uint maxTax) private view returns (uint){
267         uint timeSinceLaunch=block.timestamp-LaunchTimestamp;
268         return maxTax-((maxTax-50)*timeSinceLaunch/duration);
269     }
270     function _calculateFee(uint amount, uint tax, uint taxPercent) private pure returns (uint) {
271         return (amount*tax*taxPercent) / (TAX_DENOMINATOR*TAX_DENOMINATOR);
272     }
273     function _feelessTransfer(address sender, address recipient, uint amount) private{
274         uint senderBalance = _balances[sender];
275         require(senderBalance >= amount, "Transfer exceeds balance");
276         _balances[sender]-=amount;
277         _balances[recipient]+=amount;      
278         emit Transfer(sender,recipient,amount);
279     }
280     function setSwapTreshold(uint newSwapTresholdPermille) public onlyMultisig{
281         require(newSwapTresholdPermille<=10);//MaxTreshold= 1%
282         swapTreshold=newSwapTresholdPermille;
283         emit SwapThresholdChange(newSwapTresholdPermille);
284     }
285     function SetOverLiquifiedTreshold(uint newOverLiquifyTresholdPermille) public onlyMultisig{
286         require(newOverLiquifyTresholdPermille<=1000);
287         overLiquifyTreshold=newOverLiquifyTresholdPermille;
288         emit OverLiquifiedThresholdChange(newOverLiquifyTresholdPermille);
289     }
290     function SetTaxes(uint buy, uint sell, uint transfer_, uint splitter,uint liquidity) public onlyMultisig{
291         uint maxTax=TAX_DENOMINATOR/MAXTAXDENOMINATOR;
292         require(buy<=maxTax&&sell<=maxTax&&transfer_<=maxTax,"Tax exceeds maxTax");
293         require(splitter+liquidity==TAX_DENOMINATOR,"Taxes don't add up to denominator");
294         
295         buyTax=buy;
296         sellTax=sell;
297         transferTax=transfer_;
298         splitterTax=splitter;
299         liquidityTax=liquidity;
300         emit OnSetTaxes(buy, sell, transfer_, splitter,liquidity);
301     }
302     
303     function isOverLiquified() public view returns(bool){
304         return _balances[_dexPairAddress]>_circulatingSupply*overLiquifyTreshold/1000;
305     }
306     function _swapContractToken(bool ignoreLimits) private lockTheSwap{
307         uint contractBalance=_balances[address(this)];
308         uint totalTax=liquidityTax+splitterTax;
309         uint tokenToSwap=_balances[_dexPairAddress]*swapTreshold/1000;
310         if(totalTax==0)return;
311         if(ignoreLimits)
312             tokenToSwap=_balances[address(this)];
313         else if(contractBalance<tokenToSwap)
314             return;
315         uint tokenForLiquidity=isOverLiquified()?0:(tokenToSwap*liquidityTax)/totalTax;
316 
317         uint tokenForSplitter= tokenToSwap-tokenForLiquidity;
318 
319         uint LiqHalf=tokenForLiquidity/2;
320         uint swapToken=LiqHalf+tokenForSplitter;
321         uint initialBNBBalance = address(this).balance;
322         _swapTokenForBNB(swapToken);
323         uint newBNB=(address(this).balance - initialBNBBalance);
324         if(tokenForLiquidity>0){
325             uint liqBNB = (newBNB*LiqHalf)/swapToken;
326             _addLiquidity(LiqHalf, liqBNB);
327         }
328         ITaxSplitter(taxSplitter).taxReceive{value: address(this).balance}();
329     }
330     function _swapTokenForBNB(uint amount) private {
331         _approve(address(this), address(_dexRouter), amount);
332         address[] memory path = new address[](2);
333         path[0] = address(this);
334         path[1] = _dexRouter.WETH();
335 
336         try _dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
337             amount,
338             0,
339             path,
340             address(this),
341             block.timestamp
342         ){}
343         catch{}
344     }
345     function _addLiquidity(uint tokenamount, uint bnbamount) private {
346         _approve(address(this), address(_dexRouter), tokenamount);
347         _dexRouter.addLiquidityETH{value: bnbamount}(
348             address(this),
349             tokenamount,
350             0,
351             0,
352             address(this),
353             block.timestamp
354         );
355     }
356     function getLiquidityReleaseTimeInSeconds() public view returns (uint){
357         if(block.timestamp<_liquidityUnlockTime)
358             return _liquidityUnlockTime-block.timestamp;
359         return 0;
360     }
361     function getBurnedTokens() public view returns(uint){
362         return (InitialSupply-_circulatingSupply)+_balances[address(0xdead)];
363     }
364     function SetPair(address Pair, bool Add) public onlyMultisig{
365         require(Pair!=_dexPairAddress,"can't change pancake");
366         isPair[Pair]=Add;
367         emit NewPairSet(Pair,Add);
368     }
369     function SwitchManualSwap(bool manual) public onlyMultisig{
370         manualSwap=manual;
371         emit ManualSwapChange(manual);
372     }
373     function SwapContractToken() public onlyMultisig{
374         _swapContractToken(true);
375         emit OwnerSwap();
376     }
377 
378     function SetNewRouter(address _newdex) public onlyMultisig{
379         dexRouter = _newdex;
380         emit NewRouterSet(_newdex);
381     }
382 
383     function setMaxWalletBalancePercent(uint256 percent) external onlyMultisig {
384         require(percent >= 10, "min 1%");
385         require(percent <= 1000, "max 100%");
386         maxWalletBalance = InitialSupply * percent / 1000;
387         emit MaxWalletBalanceUpdated(percent);
388     }
389     
390     function setMaxTransactionAmount(uint256 percent) public onlyMultisig {
391         require(percent >= 25, "min 0.25%");
392         require(percent <= 10000, "max 100%");
393         maxTransactionAmount = InitialSupply * percent / 10000;
394         emit MaxTransactionAmountUpdated(percent);
395     }
396     
397     function ExcludeAccountFromFees(address account, bool exclude) public onlyMultisig{
398         require(account!=address(this),"can't Include the contract");
399         excludedFromFees[account]=exclude;
400         emit ExcludeAccount(account,exclude);
401     }
402     
403     function setExcludedAccountFromLimits(address account, bool exclude) public onlyMultisig{
404         excludedFromLimits[account]=exclude;
405         emit ExcludeFromLimits(account,exclude);
406     }
407     function isExcludedFromLimits(address account) public view returns(bool) {
408         return excludedFromLimits[account];
409     }
410     
411     function SetupEnableTrading() public onlyOwner{
412         require(LaunchTimestamp==0,"AlreadyLaunched");
413         LaunchTimestamp=block.timestamp;
414         maxWalletBalance = InitialSupply * 30 / 1000;
415         maxTransactionAmount = InitialSupply * 100 / 10000;
416         emit OnEnableTrading();
417     }
418     
419     function limitLiquidityReleaseTo20Percent() public onlyMultisig{
420         LPReleaseLimitedTo20Percent=true;
421         emit Release20PercentLP();
422     }
423     function LockLiquidityForSeconds(uint secondsUntilUnlock) public onlyMultisig{
424         _prolongLiquidityLock(secondsUntilUnlock+block.timestamp);
425     }
426     function _prolongLiquidityLock(uint newUnlockTime) private{
427         require(newUnlockTime>_liquidityUnlockTime);
428         _liquidityUnlockTime=newUnlockTime;
429         emit OnProlongLPLock(_liquidityUnlockTime);
430     }
431     
432     function LiquidityRelease() public onlyMultisig {
433         require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
434 
435         IBEP20 liquidityToken = IBEP20(_dexPairAddress);
436         uint amount = liquidityToken.balanceOf(address(this));
437         if(LPReleaseLimitedTo20Percent)
438         {
439             _liquidityUnlockTime=block.timestamp+DefaultLiquidityLockTime;
440             amount=amount*2/10;
441         }
442         liquidityToken.transfer(msg.sender, amount);
443         emit OnReleaseLP();
444     }
445 
446     receive() external payable {}
447 
448     function getOwner() external view override returns (address) {
449         return owner();
450     }
451     function name() external pure override returns (string memory) {
452         return _name;
453     }
454     function symbol() external pure override returns (string memory) {
455         return _symbol;
456     }
457     function decimals() external pure override returns (uint8) {
458         return _decimals;
459     }
460     function totalSupply() external view override returns (uint) {
461         return _circulatingSupply;
462     }
463     function balanceOf(address account) public view override returns (uint) {
464         return _balances[account];
465     }
466     function transfer(address recipient, uint amount) external override returns (bool) {
467         _transfer(msg.sender, recipient, amount);
468         return true;
469     }
470     function allowance(address _owner, address spender) external view override returns (uint) {
471         return _allowances[_owner][spender];
472     }
473     function approve(address spender, uint amount) external override returns (bool) {
474         _approve(msg.sender, spender, amount);
475         return true;
476     }
477     function _approve(address owner, address spender, uint amount) private {
478         require(owner != address(0), "Approve from zero");
479         require(spender != address(0), "Approve to zero");
480         _allowances[owner][spender] = amount;
481         emit Approval(owner, spender, amount);
482     }
483     function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
484         _transfer(sender, recipient, amount);
485         uint currentAllowance = _allowances[sender][msg.sender];
486         require(currentAllowance >= amount, "Transfer > allowance");
487         _approve(sender, msg.sender, currentAllowance - amount);
488         return true;
489     }
490     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
491         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
492         return true;
493     }
494     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
495         uint currentAllowance = _allowances[msg.sender][spender];
496         require(currentAllowance >= subtractedValue, "<0 allowance");
497         _approve(msg.sender, spender, currentAllowance - subtractedValue);
498         return true;
499     }
500     function emergencyBNBrecovery(uint256 amountPercentage) external onlyMultisig {
501         uint256 amountBNB = address(this).balance;
502         payable(msg.sender).transfer(amountBNB * amountPercentage / 100);
503         emit RecoverBNB();
504     }
505 
506 }