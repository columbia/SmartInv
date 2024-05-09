1 // SPDX-License-Identifier: UNLICENSED
2 // ALL RIGHTS RESERVED
3 
4 pragma solidity =0.8.17;
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
83 pragma solidity =0.8.17;
84 contract OM is IERC20, Ownable  
85 {
86     mapping (address => uint) private _balances;
87     mapping (address => mapping (address => uint)) private _allowances;
88     mapping(address => bool) private excludedFromLimits;
89     mapping(address => bool) public excludedFromFees;
90     mapping(address=>bool) public isAMM;
91     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
92     bool public transferDelayEnabled = true;
93     
94     string private constant _name = 'OnlyMemes';// 
95     string private constant _symbol = 'OM';// 
96 
97     uint8 private constant _decimals=18;
98 
99     uint private constant InitialSupply=10**9 * 10**_decimals;
100     uint public buyTax = 50; //10=1%  
101     uint public sellTax = 250;
102     uint public transferTax = 0;
103     uint public liquidityTax= 0;
104     uint public Tax= 1000; // lp+tax must equal 1000 // 1000=100%
105     uint public swapTreshold=10; //Dynamic Swap Threshold based on price impact. 1=0.1% max 10
106     uint public overLiquifyTreshold=100;
107     uint public LaunchTimestamp;
108     uint private devFee=100; //devfee+marketingfee must = 100 
109     uint private marketingFee= 0;
110     uint constant TAX_DENOMINATOR=1000;
111     uint constant MAXTAXDENOMINATOR=10;
112 
113     uint256 public maxWalletBalance;
114     uint256 public maxTransactionAmount;
115     uint256 public percentForLPBurn = 25; // 25 = .25%
116     uint256 public lpBurnFrequency = 3600 seconds;
117     uint256 public lastLpBurnTime;
118     uint256 public manualBurnFrequency = 30 minutes;
119     uint256 public lastManualLpBurnTime;
120 
121     bool private _isSwappingContractModifier;
122     bool public manualSwap;
123     bool public lpBurnEnabled = true;
124 
125     IDexRouter private  _DexRouter;
126 
127     address private _PairAddress; 
128     address public marketingWallet;
129     address public devWallet; 
130     address public constant burnWallet=address(0xdead);
131     address private constant DexRouter= 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
132     
133     event ManualNukeLP();
134     event AutoNukeLP();
135     event MaxWalletBalanceUpdated(uint256 percent);
136     event OnSetTaxes(uint buy, uint sell, uint transfer_, uint project,uint liquidity);
137     event ExcludeAccount(address account, bool exclude);
138     event OnEnableTrading();
139     event OnReleaseLP();
140     event ExcludeFromLimits(address account, bool exclude);
141     event MarketingWalletChange(address newWallet);
142     event DevWalletChange(address newWallet);
143     event SharesUpdated(uint _devShare, uint _marketingShare);
144     event AMMadded(address AMM);
145     event ManualSwapOn(bool manual);
146     event ManualSwapPerformed();
147     event MaxTransactionAmountUpdated(uint256 percent);
148     event SwapThresholdChange(uint newSwapTresholdPermille);
149     event OverLiquifiedThresholdChange(uint newOverLiquifyTresholdPermille);
150     modifier lockTheSwap {
151         _isSwappingContractModifier = true;
152         _;
153         _isSwappingContractModifier = false;
154     }
155 
156     constructor () {
157         uint ownerBalance=InitialSupply;
158         _balances[msg.sender] = ownerBalance;
159         emit Transfer(address(0), msg.sender, ownerBalance);
160 
161         _DexRouter = IDexRouter(DexRouter);
162         _PairAddress = IDexFactory(_DexRouter.factory()).createPair(address(this), _DexRouter.WETH());
163         isAMM[_PairAddress]=true;
164         
165         marketingWallet= msg.sender; // address(0xdead)
166         devWallet= msg.sender; // msg.sendger
167 
168         excludedFromFees[msg.sender]=true;
169         excludedFromFees[DexRouter]=true;
170         excludedFromFees[address(this)]=true;
171         excludedFromLimits[burnWallet] = true;
172         excludedFromLimits[address(this)] = true;
173     }
174     function ChangeMarketingWallet(address newWallet) external onlyOwner{
175         marketingWallet=newWallet;
176         emit MarketingWalletChange(newWallet);
177     }
178     function ChangeDevWallet(address newWallet) external onlyOwner{
179         devWallet=newWallet;
180         emit DevWalletChange(newWallet);
181     }
182     function SetFeeShares(uint _devFee, uint _marketingFee) external onlyOwner{
183         require(_devFee+_marketingFee<=100);
184         devFee=_devFee;
185         marketingFee=_marketingFee;
186         emit SharesUpdated(_devFee, _marketingFee);
187     }
188     function setRestrictionPercents(uint256 WALpercent, uint256 TXNpercent) external onlyOwner {
189         require(WALpercent >= 10, "min 1%"); // 10=1%
190         require(WALpercent <= 1000, "max 100%");
191         maxWalletBalance = InitialSupply * WALpercent / 1000;
192         require(TXNpercent >= 25, "min 0.25%");
193         require(TXNpercent <= 10000, "max 100%"); // 100=1%
194         maxTransactionAmount = InitialSupply * TXNpercent / 10000;
195         emit MaxWalletBalanceUpdated(WALpercent);
196         emit MaxTransactionAmountUpdated(TXNpercent);
197     }
198 
199     function removeAllRestrictions() external onlyOwner {
200         maxWalletBalance = InitialSupply;
201         maxTransactionAmount = InitialSupply;
202         transferDelayEnabled = false;
203     }
204     function removetransferdelay() external onlyOwner {
205         transferDelayEnabled = false;
206     }    
207     function _transfer(address sender, address recipient, uint amount) private{
208         require(sender != address(0), "Transfer from zero");
209         require(recipient != address(0), "Transfer to zero");
210          if (transferDelayEnabled){
211                     if (recipient != owner() && recipient != DexRouter && recipient != _PairAddress){
212                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
213                         _holderLastTransferTimestamp[tx.origin] = block.number;
214                     }
215                 }
216         if(excludedFromFees[sender] || excludedFromFees[recipient])
217             _feelessTransfer(sender, recipient, amount);
218         else { 
219             require(LaunchTimestamp>0,"trading not yet enabled");
220             _taxedTransfer(sender,recipient,amount);                  
221         }
222     }
223     
224     function _taxedTransfer(address sender, address recipient, uint amount) private{
225         uint senderBalance = _balances[sender];
226         require(senderBalance >= amount, "Transfer exceeds balance");
227         bool excludedAccount = excludedFromLimits[sender] || excludedFromLimits[recipient];
228         if (isAMM[sender] &&
229             !excludedAccount) {
230             require(
231                 amount <= maxTransactionAmount,
232                 "Transfer amount exceeds the maxTxAmount."
233             );
234             uint256 contractBalanceRecepient = balanceOf(recipient);
235             require(
236                 contractBalanceRecepient + amount <= maxWalletBalance,
237                 "Exceeds maximum wallet token amount."
238             );
239         } else if (
240             isAMM[recipient] &&
241             !excludedAccount
242         ) {
243             require(amount <= maxTransactionAmount, "Transfer amount exceeds the maxTxAmount.");
244         }
245 
246         bool isBuy=isAMM[sender];
247         bool isSell=isAMM[recipient];
248         uint tax;
249         if(isSell){
250             tax=sellTax;
251         }else if(isBuy){
252             tax=buyTax;
253         }else{
254             tax=transferTax;
255         }
256 
257         if((sender!=_PairAddress)&&(!manualSwap)&&(!_isSwappingContractModifier))
258             _swapContractToken(false);
259 
260         if(!_isSwappingContractModifier && isAMM[recipient] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency){
261             autoBurnLPTokens();
262         }
263 
264         uint contractToken=_calculateFee(amount, tax, Tax+liquidityTax);
265         uint taxedAmount=amount-contractToken;
266 
267         _balances[sender]-=amount;
268         _balances[address(this)] += contractToken;
269         _balances[recipient]+=taxedAmount;
270         emit Transfer(sender,recipient,taxedAmount);
271     }
272     function _calculateFee(uint amount, uint tax, uint taxPercent) private pure returns (uint) {
273         return (amount*tax*taxPercent) / (TAX_DENOMINATOR*TAX_DENOMINATOR);
274     }
275     function _feelessTransfer(address sender, address recipient, uint amount) private{
276         uint senderBalance = _balances[sender];
277         require(senderBalance >= amount, "Transfer exceeds balance");
278         _balances[sender]-=amount;
279         _balances[recipient]+=amount;      
280         emit Transfer(sender,recipient,amount);
281     }
282     function setSwapTreshold(uint newSwapTresholdPermille) external onlyOwner{
283         require(newSwapTresholdPermille<=10);//MaxTreshold= 1%
284         swapTreshold=newSwapTresholdPermille;
285         emit SwapThresholdChange(newSwapTresholdPermille);
286     }
287     function SetOverLiquifiedTreshold(uint newOverLiquifyTresholdPermille) external onlyOwner{
288         require(newOverLiquifyTresholdPermille<=1000);
289         overLiquifyTreshold=newOverLiquifyTresholdPermille;
290         emit OverLiquifiedThresholdChange(newOverLiquifyTresholdPermille);
291     }
292     function SetTaxes(uint buy, uint sell, uint transfer_, uint tax,uint liquidity) external onlyOwner{
293         uint maxTax=450; // 10= 1%
294         require(buy<=maxTax&&sell<=maxTax&&transfer_<=maxTax,"Tax exceeds maxTax");
295         require(tax+liquidity==TAX_DENOMINATOR,"Taxes don't add up to denominator");
296         buyTax=buy;
297         sellTax=sell;
298         transferTax=transfer_;
299         Tax=tax;
300         liquidityTax=liquidity;
301         emit OnSetTaxes(buy, sell, transfer_, tax, liquidity);
302     }
303     function isOverLiquified() public view returns(bool){
304         return _balances[_PairAddress]>getCirculatingSupply()*overLiquifyTreshold/1000;
305     }
306     function _swapContractToken(bool ignoreLimits) private lockTheSwap{
307         uint contractBalance=_balances[address(this)];
308         uint totalTax=liquidityTax+Tax;
309         uint tokenToSwap=_balances[_PairAddress]*swapTreshold/1000;
310         if(totalTax==0)return;
311         if(ignoreLimits)
312             tokenToSwap=_balances[address(this)];
313         else if(contractBalance<tokenToSwap)
314             return;
315 
316         uint tokenForLiquidity=
317         isOverLiquified()?0
318         :(tokenToSwap*liquidityTax)/totalTax;
319 
320         uint tokenForProject= tokenToSwap-tokenForLiquidity;
321 
322         uint LiqHalf=tokenForLiquidity/2;
323         uint swapToken=LiqHalf+tokenForProject;
324         uint initialETHBalance=address(this).balance;
325         _swapTokenForETH(swapToken);
326         uint newETH=(address(this).balance - initialETHBalance);
327 
328         if(tokenForLiquidity>0){
329             uint liqETH = (newETH*LiqHalf)/swapToken;
330             _addLiquidity(LiqHalf, liqETH);
331         }
332         uint marketbalance=address(this).balance * marketingFee/100;
333         uint devbalance=address(this).balance * devFee/100;
334         if(marketbalance>0){
335         (bool marketing,)=marketingWallet.call{value:marketbalance}("");
336         marketing=true;
337         }
338         if(devbalance>0){
339         (bool dev,)=devWallet.call{value:devbalance}("");
340         dev=true;
341         }
342     }
343     function _swapTokenForETH(uint amount) private {
344         _approve(address(this), address(_DexRouter), amount);
345         address[] memory path = new address[](2);
346         path[0] = address(this);
347         path[1] = _DexRouter.WETH();
348 
349         try _DexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
350             amount,
351             0,
352             path,
353             address(this),
354             block.timestamp
355         ){}
356         catch{}
357     }
358     function _addLiquidity(uint tokenamount, uint ethamount) private {
359         _approve(address(this), address(_DexRouter), tokenamount);
360         _DexRouter.addLiquidityETH{value: ethamount}(
361             address(this),
362             tokenamount,
363             0,
364             0,
365             address(this),
366             block.timestamp
367         );
368     }
369     function getBurnedTokens() external view returns(uint){
370         return _balances[address(0xdead)];
371     }
372     function getCirculatingSupply() public view returns(uint){
373         return InitialSupply-_balances[address(0xdead)];
374     }
375     function SetAMM(address AMM, bool Add) external onlyOwner{
376         require(AMM!=_PairAddress,"can't change uniswap");
377         isAMM[AMM]=Add;
378         emit AMMadded(AMM);
379     }
380     function SwitchManualSwap(bool manual) external onlyOwner{
381         manualSwap=manual;
382         emit ManualSwapOn(manual);
383     }
384     function SwapContractToken() external onlyOwner{
385         _swapContractToken(true);
386         emit ManualSwapPerformed();
387     }
388     function ExcludeAccountFromFees(address account, bool exclude) external onlyOwner{
389         require(account!=address(this),"can't Include the contract");
390         excludedFromFees[account]=exclude;
391         emit ExcludeAccount(account,exclude);
392     }
393     function setExcludedAccountFromLimits(address account, bool exclude) external onlyOwner{
394         excludedFromLimits[account]=exclude;
395         emit ExcludeFromLimits(account,exclude);
396     }
397     function isExcludedFromLimits(address account) external view returns(bool) {
398         return excludedFromLimits[account];
399     }
400     function EnableTrading() external onlyOwner{
401         require(LaunchTimestamp==0,"AlreadyLaunched");
402         LaunchTimestamp=block.timestamp;
403         maxWalletBalance = InitialSupply * 25 / 1000;// 10=1%  
404         maxTransactionAmount = InitialSupply * 250 / 10000;// 100=1%  
405         emit OnEnableTrading();
406     }
407     function ReleaseLP() external onlyOwner {
408         IERC20 liquidityToken = IERC20(_PairAddress);
409         uint amount = liquidityToken.balanceOf(address(this));
410         liquidityToken.transfer(msg.sender, amount);
411         emit OnReleaseLP();
412     }
413     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
414         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
415         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
416         lpBurnFrequency = _frequencyInSeconds;
417         percentForLPBurn = _percent;
418         lpBurnEnabled = _Enabled;
419     }
420     function autoBurnLPTokens() internal returns (bool){
421         lastLpBurnTime = block.timestamp;
422         uint256 liquidityPairBalance = this.balanceOf(_PairAddress);
423         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn/10000;
424         if (amountToBurn > 0){
425             _balances[_PairAddress]-=amountToBurn;
426             _balances[burnWallet]+=amountToBurn;
427             emit Transfer(_PairAddress,burnWallet,amountToBurn);
428         }
429         IDexPair pair = IDexPair(_PairAddress);
430         pair.sync();
431         emit AutoNukeLP();
432         return true;
433     }
434 
435     function manualBurnLPTokens(uint256 percent) external onlyOwner returns (bool){
436         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
437         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
438         lastManualLpBurnTime = block.timestamp;
439         uint256 liquidityPairBalance = this.balanceOf(_PairAddress);
440         uint256 amountToBurn = liquidityPairBalance * percent/10000;
441         if (amountToBurn > 0){
442             _balances[_PairAddress]-=amountToBurn;
443             _balances[burnWallet]+=amountToBurn;
444             emit Transfer(_PairAddress,burnWallet,amountToBurn);
445         }
446         IDexPair pair = IDexPair(_PairAddress);
447         pair.sync();
448         emit ManualNukeLP();
449         return true;
450     }
451     //https://5thweb.io 
452     function getOwner() external view override returns (address) {return owner();}
453     function name() external pure override returns (string memory) {return _name;}
454     function symbol() external pure override returns (string memory) {return _symbol;}
455     function decimals() external pure override returns (uint8) {return _decimals;}
456     function totalSupply() external pure override returns (uint) {return InitialSupply;}
457     function balanceOf(address account) public view override returns (uint) {return _balances[account];}
458     function allowance(address _owner, address spender) external view override returns (uint) {return _allowances[_owner][spender];}
459     function transfer(address recipient, uint amount) external override returns (bool) {
460         _transfer(msg.sender, recipient, amount);
461         return true;
462     }
463     function approve(address spender, uint amount) external override returns (bool) {
464         _approve(msg.sender, spender, amount);
465         return true;
466     }
467     function _approve(address owner, address spender, uint amount) private {
468         require(owner != address(0), "Approve from zero");
469         require(spender != address(0), "Approve to zero");
470         _allowances[owner][spender] = amount;
471         emit Approval(owner, spender, amount);
472     }
473     function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
474         _transfer(sender, recipient, amount);
475         uint currentAllowance = _allowances[sender][msg.sender];
476         require(currentAllowance >= amount, "Transfer > allowance");
477         _approve(sender, msg.sender, currentAllowance - amount);
478         return true;
479     }
480     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
481         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
482         return true;
483     }
484     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
485         uint currentAllowance = _allowances[msg.sender][spender];
486         require(currentAllowance >= subtractedValue, "<0 allowance");
487         _approve(msg.sender, spender, currentAllowance - subtractedValue);
488         return true;
489     }
490     receive() external payable {}
491 }