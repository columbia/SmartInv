1 pragma solidity ^0.8.7;
2 //SPDX-License-Identifier: UNLICENCED
3 /*
4     DogeTV
5     8% tax on buy and sell, 8% tax on transfers
6     starting taxes: 20/25%
7     contract dev: @CryptoBatmanBSC
8     Telegram:
9     https://t.me/dogetvofficial
10     Website: 
11     https://Dogetv.app 
12 */
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27 
28         return c;
29     }
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51 }
52 
53 interface INFTREWARDS {
54     function Deposit(uint256 amount) external returns (bool success);
55 }
56 
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59     function decimals() external view returns (uint8);
60     function symbol() external view returns (string memory);
61     function name() external view returns (string memory);
62     function getOwner() external view returns (address);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address _owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 abstract contract Auth {
73     address internal owner;
74     mapping (address => bool) internal authorizations;
75 
76     constructor(address _owner) {
77         owner = _owner;
78         authorizations[_owner] = true;
79     }
80 
81     /**
82      * Function modifier to require caller to be contract owner
83      */
84     modifier onlyOwner() {
85         require(isOwner(msg.sender), "!OWNER"); _;
86     }
87 
88     /**
89      * Function modifier to require caller to be authorized
90      */
91     modifier authorized() {
92         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
93     }
94 
95     /**
96      * Authorize address. Owner only
97      */
98     function authorize(address adr) public onlyOwner {
99         authorizations[adr] = true;
100     }
101 
102     /**
103      * Remove address' authorization. Owner only
104      */
105     function unauthorize(address adr) public onlyOwner {
106         authorizations[adr] = false;
107     }
108 
109     /**
110      * Check if address is owner
111      */
112     function isOwner(address account) public view returns (bool) {
113         return account == owner;
114     }
115 
116     /**
117      * Return address' authorization status
118      */
119     function isAuthorized(address adr) public view returns (bool) {
120         return authorizations[adr];
121     }
122 
123     /**
124      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
125      */
126     function transferOwnership(address payable adr) public onlyOwner {
127         owner = adr;
128         authorizations[adr] = true;
129         emit OwnershipTransferred(adr);
130     }
131 
132     event OwnershipTransferred(address owner);
133 }
134 
135 interface IDEXFactory {
136     function createPair(address tokenA, address tokenB) external returns (address pair);
137 }
138 
139 interface IDEXRouter {
140     function factory() external pure returns (address);
141     function WETH() external pure returns (address);
142 
143     function addLiquidity(
144         address tokenA,
145         address tokenB,
146         uint amountADesired,
147         uint amountBDesired,
148         uint amountAMin,
149         uint amountBMin,
150         address to,
151         uint deadline
152     ) external returns (uint amountA, uint amountB, uint liquidity);
153 
154     function addLiquidityETH(
155         address token,
156         uint amountTokenDesired,
157         uint amountTokenMin,
158         uint amountETHMin,
159         address to,
160         uint deadline
161     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
162 
163     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
164         uint amountIn,
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external;
170 
171     function swapExactETHForTokensSupportingFeeOnTransferTokens(
172         uint amountOutMin,
173         address[] calldata path,
174         address to,
175         uint deadline
176     ) external payable;
177 
178     function swapExactTokensForETHSupportingFeeOnTransferTokens(
179         uint amountIn,
180         uint amountOutMin,
181         address[] calldata path,
182         address to,
183         uint deadline
184     ) external;
185     
186     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
187     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
188     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
189     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
190     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
191 }
192 
193 
194 contract DogeTV is IERC20, Auth {
195 
196     struct DogeTvPackage{
197         uint256 price;
198         uint256 durationDays;
199         uint256 packageID;
200         string name;
201         bool isOnlySpecial;
202     }
203 
204     struct SubbedTvPackage{
205         uint256 subbedTime;
206         uint256 expiration_time;
207         uint256 packageID;
208         uint256 packageVariant;
209         bool wasDiscounted;
210         bool isSpecial;
211     }
212 
213     using SafeMath for uint256;
214     // fees. all uint8 for gas efficiency and storage.
215     /* @dev   
216         all fees are set with 1 decimal places added, please remember this when setting fees.
217     */
218     uint8 public liquidityFee = 20;
219     uint8 public marketingFee = 60;
220     uint8 public totalFee = 80;
221 
222     uint8 public initialSellFee = 250;
223     uint8 public initialBuyFee = 200;
224 
225     /*
226     @dev:
227         these are multipled by 10 so that you can have fractional percents
228     */
229     uint8 public specialPercentHigh = 20;
230     uint8 public specialPercentLow = 16;
231 
232     uint8 public discountPercentHigh = 15;
233     uint8 public discountPercentLow = 10;
234 
235 
236     // denominator. uint 16 for storage efficiency - makes the above fees all to 1 dp.
237     uint16 public AllfeeDenominator = 1000;
238     
239     // trading control;
240     bool public canTrade = false;
241     uint256 public launchedAt;
242     
243     
244     // tokenomics - uint256 BN but located here fro storage efficiency
245     uint256 _totalSupply = 1 * 10**7 * (10 **_decimals); //10 mil
246     uint256 public _maxTxAmount = _totalSupply / 100; // 1%
247     uint256 public _maxHoldAmount = _totalSupply / 50; // 2%
248     uint256 public swapThreshold = _totalSupply / 500; // 0.2%
249 
250     //Important addresses    
251     address USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // mainnet tether, used to get price;
252     //address USDT = 0xF99a0CbEa2799f8d4b51709024454F74eD63a86D;
253     address DEAD = 0x000000000000000000000000000000000000dEaD;
254     address ZERO = 0x0000000000000000000000000000000000000000;
255 
256     address public autoLiquidityReceiver;
257     address public marketingFeeReceiver;
258 
259     address public pair;
260 
261     mapping (address => uint256) _balances;
262     mapping (address => mapping (address => uint256)) _allowances;
263 
264     mapping (address => bool) public pairs;
265 
266     mapping (address => bool) isFeeExempt;
267     mapping (address => bool) isTxLimitExempt;
268     mapping (address => bool) isMaxHoldExempt;
269     mapping (address => bool) isBlacklisted;
270 
271     mapping (address => SubbedTvPackage) public userSubs;
272 
273     IDEXRouter public router;
274     INFTREWARDS public NftStakingContract;
275 
276 
277     bool public swapEnabled = true;
278     bool inSwap;
279     mapping(uint =>  DogeTvPackage) public DtvPackages;
280     //DogeTvPackage[] public DtvPackages;
281     address[] public subbedUsers;
282     uint public totalSubs;
283     modifier swapping() { inSwap = true; _; inSwap = false; }
284 
285     string constant _name = "Doge-TV";
286     string constant _symbol = "$DGTV";
287     uint8 constant _decimals = 18;
288 
289     bool public initialTaxesEnabled = true;
290 
291     constructor (address tokenOwner) Auth(tokenOwner) {
292         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet Uniswap
293         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this)); // ETH pair
294         pairs[pair] = true;
295         _allowances[address(this)][address(router)] = _totalSupply;
296         isMaxHoldExempt[pair] = true;
297         isMaxHoldExempt[DEAD] = true;
298         isMaxHoldExempt[ZERO] = true;
299         
300         owner = tokenOwner;
301         DummyNFT nftctrct = new DummyNFT(address(this), owner);
302         NftStakingContract = INFTREWARDS(nftctrct);
303         isTxLimitExempt[owner] = true;
304         isFeeExempt[owner] = true;
305         authorizations[owner] = true;
306         isMaxHoldExempt[owner] = true;
307         autoLiquidityReceiver = owner;
308         marketingFeeReceiver = owner;
309 
310         _balances[owner] = _totalSupply;
311 
312         emit Transfer(address(0), owner, _totalSupply);
313     }
314 
315     receive() external payable { }
316 
317     function totalSupply() external view override returns (uint256) { return _totalSupply; }
318     function decimals() external pure override returns (uint8) { return _decimals; }
319     function symbol() external pure override returns (string memory) { return _symbol; }
320     function name() external pure override returns (string memory) { return _name; }
321     function getOwner() external view override returns (address) { return owner; }
322     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
323     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender];} 
324 
325     
326     function getEstimatedTokenForUSDT(uint USDTAmount) public view returns (uint) {
327             address[] memory path = new address[](3);
328                 path[0] = USDT;
329                 path[1] = router.WETH();
330                 path[2] = address(this);
331             return router.getAmountsOut(USDTAmount, path)[2];
332     }
333     
334     function setBlacklistedStatus(address walletToBlacklist, bool isBlacklistedBool)external authorized{
335         isBlacklisted[walletToBlacklist] = isBlacklistedBool;
336     }
337 
338     function setBlacklistArray(address[] calldata walletToBlacklistArray)external authorized{
339         for(uint i = 0; i < walletToBlacklistArray.length; i++){
340             isBlacklisted[walletToBlacklistArray[i]] = true;
341         }
342     }
343 
344     function getPackageWithId(uint ID) internal view returns (DogeTvPackage memory package){
345                 return DtvPackages[ID];
346     }
347 
348     function subToPackage(uint _packageID, uint durationVariant)external returns(bool success){
349             /*
350              struct SubbedTvPackage{
351                 uint256 expiration_time;
352                 uint256 packageID;
353                 bool wasDiscounted;
354                 bool isSpecial;
355             }
356             */
357             DogeTvPackage memory pack = getPackageWithId(_packageID);
358             // get the price in token
359             uint256 tokenPrice = getEstimatedTokenForUSDT(pack.price);
360             
361             require(_balances[msg.sender] >= tokenPrice, "DogeTV, You dont have enough token for this");
362             uint divisor = 1;
363             bool isfree = false;
364             bool isDiscounted = false;
365             uint256 percentageHeld = ((_balances[msg.sender]*10) / _totalSupply) * 100;
366             if(percentageHeld >= discountPercentLow && percentageHeld <= discountPercentHigh){
367                 divisor = 2;
368                 isDiscounted = true;
369             }
370             if(percentageHeld > specialPercentLow){
371                 isfree = true;
372             }
373             if(pack.isOnlySpecial){
374                 require(isfree, "DogeTV: this package is not available to anyone not holding the requirements");
375             }
376             tokenPrice = tokenPrice / divisor;
377             SubbedTvPackage memory packageSubbed;
378             if(!isfree){
379                 require(!pack.isOnlySpecial, "DTV, only high percentage holders can have this package");
380                 _balances[msg.sender] -= tokenPrice;
381                 _balances[DEAD] += tokenPrice /2;
382                 emit Transfer(msg.sender, DEAD, tokenPrice/2);
383                 _balances[address(NftStakingContract)]+= tokenPrice/2;
384                 NftStakingContract.Deposit(tokenPrice/2);
385                 emit Transfer(msg.sender, address(NftStakingContract), tokenPrice/2);
386             }
387             
388             packageSubbed.packageID =  pack.packageID;
389             packageSubbed.wasDiscounted = isDiscounted;
390             packageSubbed.isSpecial = isfree;
391             packageSubbed.subbedTime = block.timestamp;
392             packageSubbed.packageVariant = durationVariant;
393             packageSubbed.expiration_time = block.timestamp + pack.durationDays * 86400;
394             emit PackageSubbed(msg.sender, pack.name);
395             userSubs[msg.sender] = packageSubbed;
396             subbedUsers.push(msg.sender);
397             return true;
398     }
399 
400     function checkSubs(address user)internal view returns (bool wasdiscounted, bool isSpecial){
401         return (userSubs[user].wasDiscounted,userSubs[user].isSpecial );
402     }
403 
404     function getSubbedUsersLength()external view returns (uint SubbedUsersLength){
405         return subbedUsers.length;
406     }
407 
408     function setNFTContract(INFTREWARDS ctrct)external authorized{
409         NftStakingContract = ctrct;
410     }
411 
412     function approve(address spender, uint256 amount) public override returns (bool) {
413         _allowances[msg.sender][spender] = amount;
414         emit Approval(msg.sender, spender, amount);
415         return true;
416     }
417 
418     function setSwapThresholdDivisor(uint divisor)external authorized {
419         require(divisor >= 100, "DogeTV: max sell percent is 1%");
420         swapThreshold = _totalSupply / divisor;
421     }
422     
423     function approveMax(address spender) external returns (bool) {
424         return approve(spender, _totalSupply);
425     }
426     
427     function setmaxholdpercentage(uint256 percentageMul10) external authorized {
428         require(percentageMul10 >= 5, "DogeTV, max hold cannot be less than 0.5%"); // cant change percentage below 0.5%, so everyone can hold the percentage
429         _maxHoldAmount = _totalSupply * percentageMul10 / 1000; // percentage based on amount
430     }
431     
432     function allowtrading()external authorized {
433         canTrade = true;
434     }
435     
436     function addNewPair(address newPair)external authorized{
437         pairs[newPair] = true;
438         isMaxHoldExempt[newPair] = true;
439     }
440     
441     function removePair(address pairToRemove)external authorized{
442         pairs[pairToRemove] = false;
443         isMaxHoldExempt[pairToRemove] = false;
444     }
445 
446     function addTVPackage( uint256 ppvID, uint256 _USDTPriceNoDecimals, uint256 _durationDays, string calldata packName, bool onlyTopHolders) external authorized {
447         DogeTvPackage memory packageToAdd;
448         packageToAdd.durationDays = _durationDays;
449         packageToAdd.packageID = ppvID;
450         packageToAdd.name = packName;
451         packageToAdd.price = _USDTPriceNoDecimals * 10 ** 18;
452         packageToAdd.isOnlySpecial = onlyTopHolders;
453         DtvPackages[ppvID] = packageToAdd;
454     }
455 
456     function changeTvPackagePrice(uint256 _ID, uint256 newPrice) external authorized returns(bool success){
457                 DtvPackages[_ID].price = newPrice * 10 ** 18;
458                 return true;
459     }
460 
461     function removeTvPackage(uint256 _ID) external authorized returns(bool success){
462                 delete DtvPackages[_ID];
463                 return true;
464     }
465     
466     function transfer(address recipient, uint256 amount) external override returns (bool) {
467         return _transferFrom(msg.sender, recipient, amount);
468     }
469 
470     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
471         if(_allowances[sender][msg.sender] != uint256(_totalSupply)){
472             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
473         }
474 
475         return _transferFrom(sender, recipient, amount);
476     }
477 
478     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
479 
480         if(!canTrade){
481             require(sender == owner, "DogeTV, Only owner or presale Contract allowed to add LP"); // only owner allowed to trade or add liquidity
482         }
483         if(sender != owner && recipient != owner){
484             if(!pairs[recipient] && !isMaxHoldExempt[recipient]){
485                 require (balanceOf(recipient) + amount <= _maxHoldAmount, "DogeTV, cant hold more than max hold dude, sorry");
486             }
487         }
488         
489         checkTxLimit(sender, recipient, amount);
490         require(!isBlacklisted[sender] && !isBlacklisted[recipient], "DogeTV, Sorry bro, youre blacklisted");
491         if(!launched() && pairs[recipient]){ require(_balances[sender] > 0); launch(); }
492         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
493         
494         _balances[sender] = _balances[sender].sub(amount, "DogeTV, Insufficient Balance");
495 
496         if(pairs[recipient]){
497             // its a sell
498             /*
499                 struct SubbedTvPackage{
500                     uint256 subbedTime;
501                     uint256 expiration_time;
502                     uint256 packageID;
503                     uint256 packageVariant;
504                     bool wasDiscounted;
505                     bool isSpecial;
506                 }
507             */
508             (bool discounted, bool special) = checkSubs(sender);
509             if(special){
510                 if((_balances[sender] * 10 /100) < specialPercentLow){ // theyve crossed the threshold
511                     delete userSubs[sender];
512                     emit SubWithdrawn(sender);
513                 }
514             }
515             if(discounted){
516                  if((_balances[sender] * 10 /100) < discountPercentLow){ // theyve crossed the threshold
517                      userSubs[sender].expiration_time = userSubs[sender].subbedTime + ((userSubs[sender].expiration_time - userSubs[sender].subbedTime) / 2);
518                      if(userSubs[sender].expiration_time >= block.timestamp){
519                         delete userSubs[sender];
520                         emit SubWithdrawn(sender);
521                      }
522                 }
523             }
524         }
525 
526         uint256 amountReceived = 0;
527         if(!shouldTakeFee(sender) || !shouldTakeFee(recipient)){
528             amountReceived = amount;
529         }else{
530             bool isbuy = pairs[sender];
531             amountReceived = takeFee(sender, isbuy, amount);
532         }
533 
534         if(shouldSwapBack(recipient)){ swapBack(); }
535 
536         _balances[recipient] = _balances[recipient].add(amountReceived);
537 
538         emit Transfer(sender, recipient, amountReceived);
539         return true;
540 
541     }
542     
543     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
544         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
545         _balances[recipient] = _balances[recipient].add(amount);
546         emit Transfer(sender, recipient, amount);
547         return true;
548     }
549 
550     function checkTxLimit(address sender, address reciever, uint256 amount) internal view {
551         if(sender != owner && reciever != owner){
552             require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
553         }
554     }
555 
556     function shouldTakeFee(address endpt) internal view returns (bool) {
557         
558         return !isFeeExempt[endpt];
559     }
560 
561     function takeFee(address sender, bool isBuy, uint256 amount) internal returns (uint256) {
562         uint fee = totalFee;
563         if(initialTaxesEnabled){
564             fee = initialSellFee;
565             if(isBuy){
566                 fee = initialBuyFee;
567             }
568         }
569 
570         uint256 feeAmount = amount.mul(fee).div(AllfeeDenominator);
571         
572         _balances[address(this)] = _balances[address(this)].add(feeAmount);
573         emit Transfer(sender, address(this), feeAmount);
574 
575         return amount.sub(feeAmount);
576     }
577 
578     function setInitialfees(uint8 _initialBuyFeePercentMul10, uint8 _initialSellFeePercentMul10) external authorized {
579         if(initialBuyFee >= _initialBuyFeePercentMul10){initialBuyFee = _initialBuyFeePercentMul10;}else{initialTaxesEnabled = false;}
580         if(initialSellFee >= _initialSellFeePercentMul10){initialSellFee = _initialSellFeePercentMul10;}else{initialTaxesEnabled = false;}
581     }
582 
583     // returns any mis-sent tokens to the marketing wallet
584     function claimtokensback(IERC20 tokenAddress) external authorized {
585         payable(marketingFeeReceiver).transfer(address(this).balance);
586         tokenAddress.transfer(marketingFeeReceiver, tokenAddress.balanceOf(address(this)));
587     }
588 
589     function launched() internal view returns (bool) {
590         return launchedAt != 0;
591     }
592 
593     function launch() internal {
594         launchedAt = block.timestamp;
595     }
596 
597     function stopInitialTax()external authorized{
598         // this can only ever be called once
599         initialTaxesEnabled = false;
600     }
601 
602     function setTxLimit(uint256 amount) external authorized {
603         require(amount >= _totalSupply / 200, "DogeTV, must be higher than 0.5%");
604         require(amount > _maxTxAmount, "DogeTV, can only ever increase the tx limit");
605         _maxTxAmount = amount;
606     }
607 
608     function setIsFeeExempt(address holder, bool exempt) external authorized {
609         isFeeExempt[holder] = exempt;
610     }
611 
612 
613     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
614         isTxLimitExempt[holder] = exempt;
615     }
616     /*
617     Dev sets the individual buy fees
618     */
619     function setFees(uint8 _liquidityFeeMul10, uint8 _marketingFeeMul10) external authorized {
620         require(_liquidityFeeMul10 + _marketingFeeMul10 <= 80, "DogeTV taxes can never exceed 8%");
621         require(_liquidityFeeMul10 + _marketingFeeMul10 <= totalFee, "Dogetv, taxes can only ever change ratio");
622         liquidityFee = _liquidityFeeMul10;
623         marketingFee = _marketingFeeMul10;
624        
625         totalFee = _liquidityFeeMul10 + (_marketingFeeMul10) ;
626     }
627 
628     function setSpecialPackPercentages(uint8 percentLowerMul10, uint8 percentHigherMul10) external authorized {
629         
630         specialPercentHigh = percentHigherMul10;
631         specialPercentLow = percentLowerMul10;
632        
633     }
634 
635     function setDiscountPackPercentages(uint8 percentLowerMul10, uint8 percentHigherMul10) external authorized {
636         
637         discountPercentHigh = percentHigherMul10;
638         discountPercentLow = percentLowerMul10;
639        
640     }
641     
642     function swapBack() internal swapping {
643         uint256 amountToLiquify = 0;
644         if(liquidityFee > 0){
645             amountToLiquify = swapThreshold.mul(liquidityFee).div(totalFee).div(2); // leave some tokens for liquidity addition
646         }
647         
648         uint256 amountToSwap = swapThreshold.sub(amountToLiquify); // swap everything bar the liquidity tokens. we need to add a pair
649 
650         address[] memory path = new address[](2);
651         path[0] = address(this);
652         path[1] = router.WETH();
653         uint256 balanceBefore = address(this).balance;
654         
655         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
656             amountToSwap,
657             0,
658             path,
659             address(this),
660             block.timestamp + 100
661         );
662 
663         uint256 amountETH = address(this).balance.sub(balanceBefore);
664         
665         uint256 totalETHFee = totalFee - (liquidityFee /2);
666         if(totalETHFee > 0){
667             uint256 amountETHMarketing = 0;
668             if(marketingFee > 0){
669                 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
670                 payable(marketingFeeReceiver).transfer(amountETHMarketing);
671             }
672             if(amountToLiquify > 0){
673                 
674                 uint256 amountETHLiquidity = amountETH - amountETHMarketing;
675                 router.addLiquidityETH{value: amountETHLiquidity}(
676                     address(this),
677                     amountToLiquify,
678                     0,
679                     0,
680                     autoLiquidityReceiver,
681                     block.timestamp
682                 );
683                 emit AutoLiquify(amountETHLiquidity, amountToLiquify);
684             }
685         }
686     }
687 
688     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver) external authorized {
689         autoLiquidityReceiver = _autoLiquidityReceiver;
690         marketingFeeReceiver = _marketingFeeReceiver;
691     }
692 
693     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
694         swapEnabled = _enabled;
695         swapThreshold = _amount;
696     }
697     
698     function shouldSwapBack(address recipient) internal view returns (bool) {
699         return !inSwap
700         && swapEnabled
701         && pairs[recipient]
702         && _balances[address(this)] >= swapThreshold;
703     }
704     
705     function getCirculatingSupply() public view returns (uint256) {
706         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
707     }
708 
709     event AutoLiquify(uint256 amountPairToken, uint256 amountToken);
710     event PackageSubbed(address user,string packName);
711     event SubWithdrawn(address user);
712 
713 }
714 
715 contract DummyNFT is INFTREWARDS {
716 
717     address public owner;
718     IERC20 public rewardToken;
719     uint256 oldBalance;
720 
721     function Deposit(uint amount) external override returns (bool success) {
722         require(oldBalance + amount == rewardToken.balanceOf(address(this)));
723         // reflect the amount here
724         oldBalance = rewardToken.balanceOf(address(this));
725         return true;
726 
727     }
728 
729     function claimTokensBack()external {
730         require(msg.sender == owner);
731         rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
732         oldBalance = rewardToken.balanceOf(address(this));
733     }
734 
735      constructor (address rewardsToken, address _owner){
736          owner = _owner;
737          rewardToken = IERC20(rewardsToken);
738      }
739 
740 }