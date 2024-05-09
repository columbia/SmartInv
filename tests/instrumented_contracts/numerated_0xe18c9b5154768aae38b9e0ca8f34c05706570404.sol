1 pragma solidity ^0.8.7;
2 //SPDX-License-Identifier: UNLICENCED
3 /*
4     PEPETV
5     The Best meme, deserves the best utility!
6     4% tax on buy and sell, 4% tax on transfers
7     starting taxes: 20% tax on buy and 60% sell
8     Telegram:
9     https://t.me/pepetvofficial
10     Website: 
11     https://pepetv.live/
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
53 
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57     function decimals() external view returns (uint8);
58     function symbol() external view returns (string memory);
59     function name() external view returns (string memory);
60     function getOwner() external view returns (address);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address _owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 abstract contract Auth {
71     address internal owner;
72     mapping (address => bool) internal authorizations;
73 
74     constructor(address _owner) {
75         owner = _owner;
76         authorizations[_owner] = true;
77     }
78 
79     /**
80      * Function modifier to require caller to be contract owner
81      */
82     modifier onlyOwner() {
83         require(isOwner(msg.sender), "!OWNER"); _;
84     }
85 
86     /**
87      * Function modifier to require caller to be authorized
88      */
89     modifier authorized() {
90         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
91     }
92 
93     /**
94      * Authorize address. Owner only
95      */
96     function authorize(address adr) public onlyOwner {
97         authorizations[adr] = true;
98     }
99 
100     /**
101      * Remove address' authorization. Owner only
102      */
103     function unauthorize(address adr) public onlyOwner {
104         authorizations[adr] = false;
105     }
106 
107     /**
108      * Check if address is owner
109      */
110     function isOwner(address account) public view returns (bool) {
111         return account == owner;
112     }
113 
114     /**
115      * Return address' authorization status
116      */
117     function isAuthorized(address adr) public view returns (bool) {
118         return authorizations[adr];
119     }
120 
121     /**
122      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
123      */
124     function transferOwnership(address payable adr) public onlyOwner {
125         owner = adr;
126         authorizations[adr] = true;
127         emit OwnershipTransferred(adr);
128     }
129 
130     event OwnershipTransferred(address owner);
131 }
132 
133 interface IDEXFactory {
134     function createPair(address tokenA, address tokenB) external returns (address pair);
135 }
136 
137 interface IDEXRouter {
138     function factory() external pure returns (address);
139     function WETH() external pure returns (address);
140 
141     function addLiquidity(
142         address tokenA,
143         address tokenB,
144         uint amountADesired,
145         uint amountBDesired,
146         uint amountAMin,
147         uint amountBMin,
148         address to,
149         uint deadline
150     ) external returns (uint amountA, uint amountB, uint liquidity);
151 
152     function addLiquidityETH(
153         address token,
154         uint amountTokenDesired,
155         uint amountTokenMin,
156         uint amountETHMin,
157         address to,
158         uint deadline
159     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
160 
161     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
162         uint amountIn,
163         uint amountOutMin,
164         address[] calldata path,
165         address to,
166         uint deadline
167     ) external;
168 
169     function swapExactETHForTokensSupportingFeeOnTransferTokens(
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external payable;
175 
176     function swapExactTokensForETHSupportingFeeOnTransferTokens(
177         uint amountIn,
178         uint amountOutMin,
179         address[] calldata path,
180         address to,
181         uint deadline
182     ) external;
183     
184     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
185     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
186     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
187     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
188     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
189 }
190 
191 
192 contract PepeTV is IERC20, Auth {
193 
194     struct PepeTVPackage{
195         uint256 price;
196         uint256 durationDays;
197         uint256 packageID;
198         string name;
199         bool isOnlySpecial;
200     }
201 
202     struct SubbedTvPackage{
203         uint256 subbedTime;
204         uint256 expiration_time;
205         uint256 packageID;
206         uint256 packageVariant;
207         bool wasDiscounted;
208         bool isSpecial;
209     }
210 
211     using SafeMath for uint256;
212     // fees. all uint8 for gas efficiency and storage.
213     /* @dev   
214         all fees are set with 1 decimal places added, please remember this when setting fees.
215     */
216     uint8 public liquidityFee = 10;
217     uint8 public marketingFee = 30;
218     uint8 public totalFee = 40;
219 
220     uint16 public initialSellFee = 600; //60%
221     uint8 public initialBuyFee = 200; //20%
222 
223 
224     // denominator. uint 16 for storage efficiency - makes the above fees all to 1 dp.
225     uint16 public AllfeeDenominator = 1000;
226     
227     // trading control;
228     bool public canTrade = false;
229     uint256 public launchedAt;
230     
231     
232     // tokenomics - uint256 BN but located here fro storage efficiency
233     uint256 _totalSupply = 4 * 10**14 * (10 **_decimals); //400 tril
234     uint256 public _maxTxAmount = _totalSupply / 50; // 2%
235     uint256 public _maxHoldAmount = _totalSupply / 50; // 2%
236     uint256 public swapThreshold = _totalSupply / 500; // 0.2%
237 
238     //Important addresses    
239     address DEAD = 0x000000000000000000000000000000000000dEaD;
240     address ZERO = 0x0000000000000000000000000000000000000000;
241 
242     address public autoLiquidityReceiver;
243     address public marketingFeeReceiver;
244 
245     address public pair;
246 
247     mapping (address => uint256) _balances;
248     mapping (address => mapping (address => uint256)) _allowances;
249 
250     mapping (address => bool) public pairs;
251 
252     mapping (address => bool) isFeeExempt;
253     mapping (address => bool) isTxLimitExempt;
254     mapping (address => bool) isMaxHoldExempt;
255     mapping (address => bool) isBlacklisted;
256 
257 
258     IDEXRouter public router;
259 
260 
261     bool public swapEnabled = true;
262     bool inSwap;
263 
264     modifier swapping() { inSwap = true; _; inSwap = false; }
265 
266     string constant _name = "PepeTV";
267     string constant _symbol = "$PEPETV";
268     uint8 constant _decimals = 18;
269 
270     bool public initialTaxesEnabled = true;
271 
272     constructor (address tokenOwner) Auth(tokenOwner) {
273         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet Uniswap
274         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this)); // ETH pair
275         pairs[pair] = true;
276         _allowances[address(this)][address(router)] = _totalSupply;
277         isMaxHoldExempt[pair] = true;
278         isMaxHoldExempt[DEAD] = true;
279         isMaxHoldExempt[ZERO] = true;
280         
281         owner = tokenOwner;
282         isTxLimitExempt[owner] = true;
283         isFeeExempt[owner] = true;
284         authorizations[owner] = true;
285         isMaxHoldExempt[owner] = true;
286         autoLiquidityReceiver = owner;
287         marketingFeeReceiver = owner;
288 
289         _balances[owner] = _totalSupply;
290 
291         emit Transfer(address(0), owner, _totalSupply);
292     }
293 
294     receive() external payable { }
295 
296     function totalSupply() external view override returns (uint256) { return _totalSupply; }
297     function decimals() external pure override returns (uint8) { return _decimals; }
298     function symbol() external pure override returns (string memory) { return _symbol; }
299     function name() external pure override returns (string memory) { return _name; }
300     function getOwner() external view override returns (address) { return owner; }
301     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
302     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender];} 
303     
304     function setBlacklistedStatus(address walletToBlacklist, bool isBlacklistedBool)external authorized{
305         isBlacklisted[walletToBlacklist] = isBlacklistedBool;
306     }
307 
308     function setBlacklistArray(address[] calldata walletToBlacklistArray)external authorized{
309         for(uint i = 0; i < walletToBlacklistArray.length; i++){
310             isBlacklisted[walletToBlacklistArray[i]] = true;
311         }
312     }
313 
314     function approve(address spender, uint256 amount) public override returns (bool) {
315         _allowances[msg.sender][spender] = amount;
316         emit Approval(msg.sender, spender, amount);
317         return true;
318     }
319 
320     function setSwapThresholdDivisor(uint divisor)external authorized {
321         require(divisor >= 100, "PepeTV: max sell percent is 1%");
322         swapThreshold = _totalSupply / divisor;
323     }
324     
325     function approveMax(address spender) external returns (bool) {
326         return approve(spender, _totalSupply);
327     }
328     
329     function setmaxholdpercentage(uint256 percentageMul10) external authorized {
330         require(percentageMul10 >= 5, "PepeTV, max hold cannot be less than 0.5%"); // cant change percentage below 0.5%, so everyone can hold the percentage
331         _maxHoldAmount = _totalSupply * percentageMul10 / 1000; // percentage based on amount
332     }
333     
334     function allowtrading()external authorized {
335         canTrade = true;
336     }
337     
338     function addNewPair(address newPair)external authorized{
339         pairs[newPair] = true;
340         isMaxHoldExempt[newPair] = true;
341     }
342     
343     function removePair(address pairToRemove)external authorized{
344         pairs[pairToRemove] = false;
345         isMaxHoldExempt[pairToRemove] = false;
346     }
347     
348     function transfer(address recipient, uint256 amount) external override returns (bool) {
349         return _transferFrom(msg.sender, recipient, amount);
350     }
351 
352     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
353         if(_allowances[sender][msg.sender] != uint256(_totalSupply)){
354             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
355         }
356 
357         return _transferFrom(sender, recipient, amount);
358     }
359 
360     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
361 
362         if(!canTrade){
363             require(sender == owner, "PepeTV, Only owner or presale Contract allowed to add LP"); // only owner allowed to trade or add liquidity
364         }
365         if(sender != owner && recipient != owner){
366             if(!pairs[recipient] && !isMaxHoldExempt[recipient]){
367                 require (balanceOf(recipient) + amount <= _maxHoldAmount, "PepeTV, cant hold more than max hold dude, sorry");
368             }
369         }
370         
371         checkTxLimit(sender, recipient, amount);
372         require(!isBlacklisted[sender] && !isBlacklisted[recipient], "PepeTV, Sorry bro, youre blacklisted");
373         if(!launched() && pairs[recipient]){ require(_balances[sender] > 0); launch(); }
374         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
375         
376         _balances[sender] = _balances[sender].sub(amount, "PepeTV, Insufficient Balance");
377 
378 
379         uint256 amountReceived = 0;
380         if(!shouldTakeFee(sender) || !shouldTakeFee(recipient)){
381             amountReceived = amount;
382         }else{
383             bool isbuy = pairs[sender];
384             amountReceived = takeFee(sender, isbuy, amount);
385         }
386 
387         if(shouldSwapBack(recipient)){ swapBack(); }
388 
389         _balances[recipient] = _balances[recipient].add(amountReceived);
390 
391         emit Transfer(sender, recipient, amountReceived);
392         return true;
393 
394     }
395     
396     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
397         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
398         _balances[recipient] = _balances[recipient].add(amount);
399         emit Transfer(sender, recipient, amount);
400         return true;
401     }
402 
403     function checkTxLimit(address sender, address reciever, uint256 amount) internal view {
404         if(sender != owner && reciever != owner){
405             require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
406         }
407     }
408 
409     function shouldTakeFee(address endpt) internal view returns (bool) {
410         
411         return !isFeeExempt[endpt];
412     }
413 
414     function takeFee(address sender, bool isBuy, uint256 amount) internal returns (uint256) {
415         uint fee = totalFee;
416         if(initialTaxesEnabled){
417             fee = initialSellFee;
418             if(isBuy){
419                 fee = initialBuyFee;
420             }
421         }
422 
423         uint256 feeAmount = amount.mul(fee).div(AllfeeDenominator);
424         
425         _balances[address(this)] = _balances[address(this)].add(feeAmount);
426         emit Transfer(sender, address(this), feeAmount);
427 
428         return amount.sub(feeAmount);
429     }
430 
431     function setInitialfees(uint8 _initialBuyFeePercentMul10, uint8 _initialSellFeePercentMul10) external authorized {
432         if(initialBuyFee >= _initialBuyFeePercentMul10){initialBuyFee = _initialBuyFeePercentMul10;}else{initialTaxesEnabled = false;}
433         if(initialSellFee >= _initialSellFeePercentMul10){initialSellFee = _initialSellFeePercentMul10;}else{initialTaxesEnabled = false;}
434     }
435 
436     // returns any mis-sent tokens to the marketing wallet
437     function claimtokensback(IERC20 tokenAddress) external authorized {
438         payable(marketingFeeReceiver).transfer(address(this).balance);
439         tokenAddress.transfer(marketingFeeReceiver, tokenAddress.balanceOf(address(this)));
440     }
441 
442     function launched() internal view returns (bool) {
443         return launchedAt != 0;
444     }
445 
446     function launch() internal {
447         launchedAt = block.timestamp;
448     }
449 
450     function stopInitialTax()external authorized{
451         // this can only ever be called once
452         initialTaxesEnabled = false;
453     }
454 
455     function setTxLimit(uint256 amount) external authorized {
456         require(amount >= _totalSupply / 200, "PepeTV, must be higher than 0.5%");
457         require(amount > _maxTxAmount, "PepeTV, can only ever increase the tx limit");
458         _maxTxAmount = amount;
459     }
460 
461     function setIsFeeExempt(address holder, bool exempt) external authorized {
462         isFeeExempt[holder] = exempt;
463     }
464 
465 
466     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
467         isTxLimitExempt[holder] = exempt;
468     }
469     /*
470     Dev sets the individual buy fees
471     */
472     function setFees(uint8 _liquidityFeeMul10, uint8 _marketingFeeMul10) external authorized {
473         require(_liquidityFeeMul10 + _marketingFeeMul10 <= 50, "PepeTV taxes can never exceed 5%");
474         require(_liquidityFeeMul10 + _marketingFeeMul10 <= totalFee, "PepeTV, taxes can only ever change ratio");
475         liquidityFee = _liquidityFeeMul10;
476         marketingFee = _marketingFeeMul10;
477        
478         totalFee = _liquidityFeeMul10 + (_marketingFeeMul10) ;
479     }
480     
481     function swapBack() internal swapping {
482         uint256 amountToLiquify = 0;
483         if(liquidityFee > 0){
484             amountToLiquify = swapThreshold.mul(liquidityFee).div(totalFee).div(2); // leave some tokens for liquidity addition
485         }
486         
487         uint256 amountToSwap = swapThreshold.sub(amountToLiquify); // swap everything bar the liquidity tokens. we need to add a pair
488 
489         address[] memory path = new address[](2);
490         path[0] = address(this);
491         path[1] = router.WETH();
492         uint256 balanceBefore = address(this).balance;
493         
494         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
495             amountToSwap,
496             0,
497             path,
498             address(this),
499             block.timestamp + 100
500         );
501 
502         uint256 amountETH = address(this).balance.sub(balanceBefore);
503         
504         uint256 totalETHFee = totalFee - (liquidityFee /2);
505         if(totalETHFee > 0){
506             uint256 amountETHMarketing = 0;
507             if(marketingFee > 0){
508                 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
509                 payable(marketingFeeReceiver).transfer(amountETHMarketing);
510             }
511             if(amountToLiquify > 0){
512                 
513                 uint256 amountETHLiquidity = amountETH - amountETHMarketing;
514                 router.addLiquidityETH{value: amountETHLiquidity}(
515                     address(this),
516                     amountToLiquify,
517                     0,
518                     0,
519                     autoLiquidityReceiver,
520                     block.timestamp
521                 );
522                 emit AutoLiquify(amountETHLiquidity, amountToLiquify);
523             }
524         }
525     }
526 
527     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver) external authorized {
528         autoLiquidityReceiver = _autoLiquidityReceiver;
529         marketingFeeReceiver = _marketingFeeReceiver;
530     }
531 
532     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
533         swapEnabled = _enabled;
534         swapThreshold = _amount;
535     }
536     
537     function shouldSwapBack(address recipient) internal view returns (bool) {
538         return !inSwap
539         && swapEnabled
540         && pairs[recipient]
541         && _balances[address(this)] >= swapThreshold;
542     }
543     
544     function getCirculatingSupply() public view returns (uint256) {
545         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
546     }
547 
548     event AutoLiquify(uint256 amountPairToken, uint256 amountToken);
549 
550 }