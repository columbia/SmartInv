1 /**
2 
3 "What happens today will effect your tomorrow."
4 
5 https://butterflyeffect-erc.vip/
6 https://t.me/ButterflyEffectCoin
7 https://twitter.com/Effect_ERC
8 
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.19;
15 
16 
17 library SafeMath {
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
22     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
23 
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         unchecked{require(b <= a, errorMessage); return a - b;}}
26 
27     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         unchecked{require(b > 0, errorMessage); return a / b;}}
29 
30     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         unchecked{require(b > 0, errorMessage); return a % b;}}}
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35     function circulatingSupply() external view returns (uint256);
36     function decimals() external view returns (uint8);
37     function symbol() external view returns (string memory);
38     function name() external view returns (string memory);
39     function getOwner() external view returns (address);
40     function balanceOf(address account) external view returns (uint256);
41     function transfer(address recipient, uint256 amount) external returns (bool);
42     function allowance(address _owner, address spender) external view returns (uint256);
43     function approve(address spender, uint256 amount) external returns (bool);
44     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);}
47 
48 abstract contract Ownable {
49     address internal owner;
50     constructor(address _owner) {owner = _owner;}
51     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
52     function isOwner(address account) public view returns (bool) {return account == owner;}
53     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
54     event OwnershipTransferred(address owner);
55 }
56 
57 interface stakeIntegration {
58     function stakingWithdraw(address depositor, uint256 _amount) external;
59     function stakingDeposit(address depositor, uint256 _amount) external;
60     function stakingClaimToCompound(address sender, address recipient) external;
61     function internalClaimRewards(address sender) external;
62 }
63 
64 interface tokenStaking {
65     function deposit(uint256 amount) external;
66     function withdraw(uint256 amount) external;
67     function compound() external;
68 }
69 
70 interface IFactory{
71         function createPair(address tokenA, address tokenB) external returns (address pair);
72         function getPair(address tokenA, address tokenB) external view returns (address pair);
73 }
74 
75 interface IRouter {
76     function factory() external pure returns (address);
77     function WETH() external pure returns (address);
78     function addLiquidityETH(
79         address token,
80         uint amountTokenDesired,
81         uint amountTokenMin,
82         uint amountETHMin,
83         address to,
84         uint deadline
85     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
86 
87     function removeLiquidityWithPermit(
88         address tokenA,
89         address tokenB,
90         uint liquidity,
91         uint amountAMin,
92         uint amountBMin,
93         address to,
94         uint deadline,
95         bool approveMax, uint8 v, bytes32 r, bytes32 s
96     ) external returns (uint amountA, uint amountB);
97 
98     function swapExactETHForTokensSupportingFeeOnTransferTokens(
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external payable;
104 
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline) external;
111 }
112 
113 contract ButterflyEffect is IERC20, tokenStaking, Ownable {
114     using SafeMath for uint256;
115     string private constant _name = 'Butterfly Effect';
116     string private constant _symbol = 'EFFECT';
117     uint8 private constant _decimals = 9;
118     uint256 private _totalSupply = 1000000 * (10 ** _decimals);
119     uint256 public _maxTxAmount = ( _totalSupply * 100 ) / 10000;
120     uint256 public _maxWalletToken = ( _totalSupply * 100 ) / 10000;
121     mapping (address => uint256) _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) public isFeeExempt;
124     mapping (address => bool) public isDividendExempt;
125     IRouter router;
126     address public pair;
127     bool private swapEnabled = true;
128     bool private tradingAllowed = false;
129     bool public reflectionsEnabled = true;
130     uint256 private liquidityFee = 0;
131     uint256 private marketingFee = 900;
132     uint256 private reflectionFee = 100;
133     uint256 private developmentFee = 1000;
134     uint256 private burnFee = 0;
135     uint256 private tokenFee = 0;
136     uint256 private totalFee = 2000;
137     uint256 private sellFee = 4000;
138     uint256 private transferFee = 4000;
139     uint256 private denominator = 10000;
140     uint256 private swapTimes;
141     bool private swapping;
142     bool private feeless;
143     uint256 private swapAmount = 1;
144     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
145     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
146     modifier feelessTransaction {feeless = true; _; feeless = false;}
147     modifier lockTheSwap {swapping = true; _; swapping = false;}
148     mapping(address => uint256) public amountStaked;
149     uint256 public totalStaked;
150     uint256 private staking = 0;
151     stakeIntegration internal stakingContract;
152     address internal token_receiver;
153     uint256 public totalShares;
154     uint256 public totalDividends;
155     uint256 public totalDistributed;
156     uint256 public currentDividends;
157     uint256 public dividendsBeingDistributed;
158     uint256 internal dividendsPerShare;
159     uint256 internal dividendsPerShareAccuracyFactor = 10 ** 36;
160     address[] shareholders; mapping (address => Share) public shares; 
161     mapping (address => uint256) shareholderIndexes;
162     mapping (address => uint256) shareholderClaims;
163     struct Share {uint256 amount; uint256 totalExcluded; uint256 totalRealised; }
164     uint256 public excessDividends;
165     uint256 public eventFeesCollected;
166     uint256 public reflectionEvent;
167     bool public distributingReflections;
168     uint256 internal disbursements;
169     bool internal releaseDistributing;
170     mapping (address => uint256) public buyMultiplier;
171     uint256 internal currentIndex;
172     uint256 public gasAmount = 500000;
173     uint256 public distributionInterval = 12 hours;
174     uint256 public distributionTime;
175     uint256 private minBuyAmount = ( _totalSupply * 10 ) / 100000;
176     uint256 private maxDropAmount = ( _totalSupply * 500 ) / 10000;
177     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
178     address internal utility_receiver = 0x6F623E84da9880138DF9362cB596e13291C3C4ae;
179     address internal staking_receiver = 0x6F623E84da9880138DF9362cB596e13291C3C4ae; 
180     address internal marketing_receiver = 0x3f20cB334FFd23D0Ec8eeFaFAe485728774Ea1b0;
181     address internal liquidity_receiver = 0x6F623E84da9880138DF9362cB596e13291C3C4ae;
182     mapping (uint256 => mapping (address => uint256)) internal userEventData;
183     struct eventData {
184         uint256 reflectionAmount;
185         uint256 reflectionsDisbursed;
186         uint256 eventTimestamp;
187         uint256 totalFees;
188         uint256 totalExcess;}
189     mapping(uint256 => eventData) public eventStats;
190 
191     constructor() Ownable(msg.sender) {
192         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
193         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
194         router = _router;
195         pair = _pair;
196         token_receiver = msg.sender;
197         isFeeExempt[address(this)] = true;
198         isFeeExempt[liquidity_receiver] = true;
199         isFeeExempt[marketing_receiver] = true;
200         isFeeExempt[token_receiver] = true;
201         isFeeExempt[msg.sender] = true;
202         isFeeExempt[address(stakingContract)] = true;
203         isDividendExempt[address(this)] = true;
204         isDividendExempt[address(pair)] = true;
205         isDividendExempt[address(DEAD)] = true;
206         isDividendExempt[address(0)] = true;
207         _balances[msg.sender] = _totalSupply;
208         emit Transfer(address(0), msg.sender, _totalSupply);
209     }
210 
211     receive() external payable {}
212     function name() public pure returns (string memory) {return _name;}
213     function symbol() public pure returns (string memory) {return _symbol;}
214     function decimals() public pure returns (uint8) {return _decimals;}
215     function getOwner() external view override returns (address) { return owner; }
216     function totalSupply() public view override returns (uint256) {return _totalSupply;}
217     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
218     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
219     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
220     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
221     function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
222     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
223 
224     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
225         require(sender != address(0), "ERC20: transfer from the zero address");
226         require(recipient != address(0), "ERC20: transfer to the zero address");
227         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
228     }
229 
230     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
231         _transfer(sender, recipient, amount);
232         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
233         return true;
234     }
235 
236     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
237         _balances[sender] = _balances[sender].sub(amount);
238         _balances[recipient] = _balances[recipient].add(amount);
239         return true;
240     }
241 
242     function _approve(address owner, address spender, uint256 amount) private {
243         require(owner != address(0), "ERC20: approve from the zero address");
244         require(spender != address(0), "ERC20: approve to the zero address");
245         _allowances[owner][spender] = amount;
246         emit Approval(owner, spender, amount);
247     }
248 
249     function _transfer(address sender, address recipient, uint256 amount) private {
250         preTxCheck(sender, recipient, amount);
251         checkTradingAllowed(sender, recipient);
252         checkMaxWallet(sender, recipient, amount); 
253         checkTxLimit(sender, recipient, amount);
254         transactionCounters(sender, recipient);
255         setBuyMultiplier(sender, recipient, amount);
256         swapBack(sender, recipient, amount);
257         _balances[sender] = _balances[sender].sub(amount);
258         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
259         _balances[recipient] = _balances[recipient].add(amountReceived);
260         emit Transfer(sender, recipient, amountReceived);
261         processRewards(sender, recipient);
262     }
263 
264     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _reflections, uint256 _burn, 
265         uint256 _token, uint256 _staking, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
266         liquidityFee = _liquidity; marketingFee = _marketing; reflectionFee = _reflections; staking = _staking; developmentFee = _development;
267         burnFee = _burn; totalFee = _total; sellFee = _sell; transferFee = _trans; tokenFee = _token;
268         require(totalFee <= denominator && sellFee <= denominator && burnFee <= denominator && tokenFee <= denominator 
269             && transferFee <= denominator, "totalFee and sellFee cannot be more than 20%");
270     }
271 
272     function setParameters(uint256 _buy, uint256 _wallet) external onlyOwner {
273         uint256 newTx = totalSupply().mul(_buy).div(uint256(10000));
274         uint256 newWallet = totalSupply().mul(_wallet).div(uint256(10000)); uint256 limit = totalSupply().mul(5).div(1000);
275         require(newTx >= limit && newWallet >= limit, "ERC20: max TXs and max Wallet cannot be less than .5%");
276         _maxTxAmount = newTx; _maxWalletToken = newWallet;
277     }
278 
279     function internalDeposit(address sender, uint256 amount) internal {
280         require(amount <= _balances[sender].sub(amountStaked[sender]), "ERC20: Cannot stake more than available balance");
281         stakingContract.stakingDeposit(sender, amount);
282         amountStaked[sender] = amountStaked[sender].add(amount);
283         totalStaked = totalStaked.add(amount);
284     }
285 
286     function deposit(uint256 amount) override external {
287         internalDeposit(msg.sender, amount);
288     }
289 
290     function withdraw(uint256 amount) override external {
291         require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
292         stakingContract.stakingWithdraw(msg.sender, amount);
293         amountStaked[msg.sender] = amountStaked[msg.sender].sub(amount);
294         totalStaked = totalStaked.sub(amount);
295     }
296 
297     function compound() override external feelessTransaction {
298         uint256 initialToken = balanceOf(msg.sender);
299         stakingContract.stakingClaimToCompound(msg.sender, msg.sender);
300         uint256 afterToken = balanceOf(msg.sender).sub(initialToken);
301         internalDeposit(msg.sender, afterToken);
302     }
303 
304     function setStakingAddress(address _staking) external onlyOwner {
305         stakingContract = stakeIntegration(_staking); isFeeExempt[_staking] = true;
306     }
307 
308     function checkTradingAllowed(address sender, address recipient) internal view {
309         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
310     }
311     
312     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
313         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
314             require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
315     }
316 
317     function transactionCounters(address sender, address recipient) internal {
318         if(recipient == pair && !isFeeExempt[sender] && !swapping){swapTimes += uint256(1);}
319     }
320 
321     function setBuyMultiplier(address sender, address recipient, uint256 amount) internal {
322         if(sender == pair && amount >= minBuyAmount){buyMultiplier[recipient] = buyMultiplier[recipient].add(uint256(1));}
323         if(sender == pair && amount < minBuyAmount){buyMultiplier[recipient] = uint256(1);}
324         if(recipient == pair){buyMultiplier[sender] = uint256(0);}
325     }
326 
327     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
328         if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= balanceOf(sender), "ERC20: Exceeds maximum allowed not currently staked.");}
329         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
330     }
331 
332     function startTrading() external onlyOwner {
333         tradingAllowed = true;
334         distributionTime = block.timestamp;
335     }
336 
337     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
338         swapAmount = _swapAmount; swapThreshold = totalSupply().mul(_swapThreshold).div(uint256(100000)); minTokenAmount = totalSupply().mul(_minTokenAmount).div(uint256(100000));
339     }
340 
341     function setUserMultiplier(address user, uint256 multiplier) external onlyOwner {
342         buyMultiplier[user] = multiplier;
343     }
344 
345     function setInternalAddresses(address _marketing, address _liquidity, address _utility, address _token, address _staking) external onlyOwner {
346         marketing_receiver = _marketing; liquidity_receiver = _liquidity; utility_receiver = _utility; token_receiver = _token; staking_receiver = _staking;
347         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_utility] = true; isFeeExempt[_token] = true; isFeeExempt[_staking] = true;
348     }
349 
350     function setisExempt(address _address, bool _enabled) external onlyOwner {
351         isFeeExempt[_address] = _enabled;
352     }
353 
354     function setDividendInfo(uint256 excess, uint256 current, uint256 distributing) external onlyOwner {
355         excessDividends = excess; currentDividends = current; dividendsBeingDistributed = distributing;
356     }
357 
358     function setMinBuyAmount(uint256 amount) external onlyOwner {
359         minBuyAmount = _totalSupply.mul(amount).div(100000);
360     }
361 
362     function swapAndLiquify(uint256 tokens) private lockTheSwap {
363         uint256 _denominator = totalFee.add(1).mul(2);
364         if(totalFee == uint256(0)){_denominator = liquidityFee.add(
365             marketingFee).add(staking).add(developmentFee).add(1).mul(2);}
366         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
367         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
368         uint256 initialBalance = address(this).balance;
369         swapTokensForETH(toSwap);
370         uint256 deltaBalance = address(this).balance.sub(initialBalance);
371         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
372         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
373         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(
374             tokensToAddLiquidityWith, ETHToAddLiquidityWith, liquidity_receiver); }
375         uint256 stakingAmount = unitBalance.mul(2).mul(staking);
376         if(stakingAmount > 0){payable(staking_receiver).transfer(stakingAmount);}
377         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
378         if(marketingAmount > 0){payable(marketing_receiver).transfer(marketingAmount);}
379         uint256 excessAmount = address(this).balance;
380         if(excessAmount > uint256(0)){payable(utility_receiver).transfer(excessAmount);}
381     }
382 
383     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount, address receiver) private {
384         _approve(address(this), address(router), tokenAmount);
385         router.addLiquidityETH{value: ETHAmount}(
386             address(this),
387             tokenAmount,
388             0,
389             0,
390             address(receiver),
391             block.timestamp);
392     }
393 
394     function swapTokensForETH(uint256 tokenAmount) private {
395         address[] memory path = new address[](2);
396         path[0] = address(this);
397         path[1] = router.WETH();
398         _approve(address(this), address(router), tokenAmount);
399         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
400             tokenAmount,
401             0,
402             path,
403             address(this),
404             block.timestamp);
405     }
406 
407     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
408         bool aboveMin = amount >= minTokenAmount;
409         bool aboveThreshold = viewAvailableBalance() >= swapThreshold;
410         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] 
411             && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
412     }
413 
414     function swapBack(address sender, address recipient, uint256 amount) internal {
415         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
416     }
417 
418     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
419         return !isFeeExempt[sender] && !isFeeExempt[recipient];
420     }
421 
422     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
423         if(recipient == pair && sellFee > uint256(0)){return sellFee;}
424         if(sender == pair && totalFee > uint256(0)){return totalFee;}
425         return transferFee;
426     }
427 
428     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
429         if(getTotalFee(sender, recipient) > 0 && !swapping){
430         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
431         _balances[address(this)] = _balances[address(this)].add(feeAmount);
432         emit Transfer(sender, address(this), feeAmount);
433         if(reflectionFee > uint256(0) && reflectionFee <= getTotalFee(sender, recipient)){
434             currentDividends = currentDividends.add((amount.div(denominator).mul(reflectionFee)));
435             eventFeesCollected = eventFeesCollected.add((amount.div(denominator).mul(reflectionFee)));}
436         if(burnFee > uint256(0) && burnFee <= getTotalFee(sender, recipient)){
437             _transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
438         if(tokenFee > uint256(0) && tokenFee <= getTotalFee(sender, recipient)){
439             _transfer(address(this), address(token_receiver), amount.div(denominator).mul(tokenFee));}
440         return amount.sub(feeAmount);} return amount;
441     }
442 
443     function setisDividendExempt(address holder, bool exempt) external onlyOwner {
444         isDividendExempt[holder] = exempt;
445         if(exempt){setShare(holder, 0);}
446         if(buyMultiplier[holder] > 0){setShare(holder, balanceOf(holder).mul(buyMultiplier[holder]));}
447         else{setShare(holder, balanceOf(holder));}
448     }
449 
450     function processRewards(address sender, address recipient) internal {
451         if(releaseDistributing){dividendsBeingDistributed = uint256(0);}
452         if(shares[recipient].amount > uint256(0)){distributeDividend(recipient);}
453         if(shares[sender].amount > uint256(0) && recipient != pair){distributeDividend(sender);}
454         if(recipient == pair && shares[sender].amount > uint256(0)){excessDividends = excessDividends.add(getUnpaidEarnings(sender));}
455         if(!isDividendExempt[sender]){setShare(sender, balanceOf(sender));}
456         if(!isDividendExempt[recipient]){setShare(recipient, balanceOf(recipient));}
457         if(!isDividendExempt[recipient] && sender == pair && buyMultiplier[recipient] >= uint256(1)){
458             setShare(recipient, balanceOf(recipient).mul(buyMultiplier[recipient]));}
459         if(distributionTime.add(distributionInterval) <= block.timestamp && tradingAllowed && 
460             currentDividends > uint256(0) && !swapping && reflectionsEnabled){
461             createReflectionEvent();}
462         processReflections(gasAmount);
463         if(shares[recipient].amount > uint256(0)){distributeDividend(recipient);}
464     }
465 
466     function createReflectionEvent() internal {
467             distributingReflections = true;
468             eventStats[reflectionEvent].totalExcess = excessDividends;
469             excessDividends = uint256(0);
470             reflectionEvent = reflectionEvent.add(uint256(1));
471             eventStats[reflectionEvent].totalFees = eventFeesCollected;
472             eventStats[reflectionEvent].reflectionAmount = currentDividends;
473             eventStats[reflectionEvent].eventTimestamp = block.timestamp;
474             if(currentDividends > maxDropAmount){currentDividends = maxDropAmount;}
475             depositRewards(currentDividends);
476             currentDividends = uint256(0);
477             eventFeesCollected = uint256(0);
478             distributionTime = block.timestamp;
479             processReflections(gasAmount);
480     }
481 
482     function manualReflectionEvent() external onlyOwner {
483         createReflectionEvent();
484     }
485 
486     function rescueERC20(address _address) external onlyOwner {
487         uint256 _amount = IERC20(_address).balanceOf(address(this));
488         IERC20(_address).transfer(utility_receiver, _amount);
489     }
490 
491     function setMaxDropAmount(uint256 amount) external onlyOwner {
492         maxDropAmount = _totalSupply.mul(amount).div(100000);
493     }
494 
495     function setDistributionInterval(uint256 interval) external onlyOwner {
496         distributionInterval = interval;
497     }
498 
499     function setReleaseDistributing(bool enable) external onlyOwner {
500         releaseDistributing = enable;
501     }
502 
503     function enableReflections(bool enable) external onlyOwner {
504         reflectionsEnabled = enable;
505     }
506 
507     function setGasAmount(uint256 gas) external onlyOwner {
508         gasAmount = gas;
509     }
510 
511     function closeReflectionEvent() external onlyOwner {
512         dividendsBeingDistributed = uint256(0);
513     }
514 
515     function setShare(address shareholder, uint256 amount) internal {
516         if(amount > 0 && shares[shareholder].amount == 0){addShareholder(shareholder);}
517         else if(amount == 0 && shares[shareholder].amount > 0){removeShareholder(shareholder); }
518         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
519         shares[shareholder].amount = amount;
520         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
521     }
522 
523     function depositRewards(uint256 amount) internal {
524         totalDividends = totalDividends.add(amount);
525         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
526         dividendsBeingDistributed = amount;
527     }
528 
529     function rescueETH(uint256 _amount) external {
530         payable(utility_receiver).transfer(_amount);
531     }
532 
533     function setTokenAddress(address _address) external onlyOwner {
534         token_receiver = _address;
535     }
536 
537     function totalReflectionsDistributed(address _wallet) external view returns (uint256) {
538         address shareholder = _wallet;
539         return uint256(shares[shareholder].totalRealised);
540     }
541 
542     function claimReflections() external {
543         distributeDividend(msg.sender);
544     }
545 
546     function viewRemainingBeingDisbursed() external view returns (uint256 distributing, uint256 distributed) {
547         return(dividendsBeingDistributed, eventStats[reflectionEvent].reflectionsDisbursed);
548     }
549 
550     function viewDisbursementShareholders() external view returns (uint256 disbursementsAmt, uint256 shareholdersAmt) {
551         return(disbursements, shareholders.length);
552     }
553 
554     function manualProcessReflections(uint256 gas) external onlyOwner {
555         processReflections(gas);
556     }
557 
558     function processReflections(uint256 gas) internal {
559         uint256 currentAmount = totalDistributed;
560         uint256 shareholderCount = shareholders.length;
561         if(shareholderCount == uint256(0)) { return; }
562         uint256 gasUsed = uint256(0);
563         uint256 gasLeft = gasleft();
564         uint256 iterations = uint256(0);
565         while(gasUsed < gas && iterations < shareholderCount) {
566             if(currentIndex >= shareholderCount){
567                 currentIndex = uint256(0);}
568                 distributeDividend(shareholders[currentIndex]);
569             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
570             gasLeft = gasleft();
571             currentIndex++;
572             iterations++;
573             disbursements++;}
574         if(disbursements >= shareholderCount && totalDistributed > currentAmount){
575             distributingReflections = false;
576             dividendsBeingDistributed = uint256(0);
577             disbursements = uint256(0);}
578     }
579 
580     function distributeDividend(address shareholder) internal {
581         uint256 amount = getUnpaidEarnings(shareholder);
582         if(shares[shareholder].amount == 0 || amount > balanceOf(address(this))){ return; }
583         if(amount > uint256(0)){
584             totalDistributed = totalDistributed.add(amount);
585             eventStats[reflectionEvent].reflectionsDisbursed = eventStats[reflectionEvent].reflectionsDisbursed.add(amount);
586             _basicTransfer(address(this), shareholder, amount);
587             userEventData[reflectionEvent][shareholder] = amount;
588             shareholderClaims[shareholder] = block.timestamp;
589             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
590             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
591             buyMultiplier[shareholder] = uint256(0);
592             setShare(shareholder, balanceOf(shareholder));}
593     }
594 
595     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
596         if(shares[shareholder].amount == 0){ return 0; }
597         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
598         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
599         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
600         return shareholderTotalDividends.sub(shareholderTotalExcluded);
601     }
602 
603     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
604         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
605     }
606 
607     function addShareholder(address shareholder) internal {
608         shareholderIndexes[shareholder] = shareholders.length;
609         shareholders.push(shareholder);
610     }
611 
612     function removeShareholder(address shareholder) internal {
613         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
614         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
615         shareholders.pop();
616     }
617 
618     function balanceInformation() external view returns (uint256 balance, uint256 available, uint256 current, uint256 distributing, uint256 excess) {
619         return(balanceOf(address(this)), balanceOf(address(this)).sub(currentDividends).sub(dividendsBeingDistributed), currentDividends, dividendsBeingDistributed, excessDividends);
620     }
621 
622     function viewAvailableBalance() public view returns (uint256 contractBalance) {
623         return balanceOf(address(this)).sub(currentDividends).sub(dividendsBeingDistributed);
624     }
625 
626     function viewLastFiveReflectionEvents() external view returns (uint256, uint256, uint256, uint256, uint256) {
627         return(eventStats[reflectionEvent].reflectionAmount, eventStats[reflectionEvent.sub(1)].reflectionAmount, eventStats[reflectionEvent.sub(2)].reflectionAmount,
628             eventStats[reflectionEvent.sub(3)].reflectionAmount, eventStats[reflectionEvent.sub(4)].reflectionAmount);
629     }
630 
631     function viewUserReflectionStats(uint256 eventNumber, address wallet) external view returns (uint256) {
632         return userEventData[eventNumber][wallet];
633     }
634 
635     function viewMyReflectionStats(uint256 eventNumber) external view returns (uint256) {
636         return userEventData[eventNumber][msg.sender];
637     }
638 }