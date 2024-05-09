1 /**
2  * This is Lucy from Psyduck Inu ٩(◕‿◕)۶
3 Please join our telegram group: t.me/PsyduckInu („• ֊ •„)	
4 */
5 
6 pragma solidity ^0.8.7;
7 
8 library Address {
9    
10     function isContract(address account) internal view returns (bool) {
11         bytes32 codehash;
12         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
13         assembly { codehash := extcodehash(account) }
14         return (codehash != accountHash && codehash != 0x0);
15     }
16     function sendValue(address payable recipient, uint256 amount) internal {
17         require(address(this).balance >= amount, "Address: insufficient balance");
18 
19         (bool success, ) = recipient.call{ value: amount }("");
20         require(success, "Address: unable to send value, recipient may have reverted");
21     }
22     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
23       return functionCall(target, data, "Address: low-level call failed");
24     }
25     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
26         return _functionCallWithValue(target, data, 0, errorMessage);
27     }
28     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
29         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
30     }
31     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
32         require(address(this).balance >= value, "Address: insufficient balance for call");
33         return _functionCallWithValue(target, data, value, errorMessage);
34     }
35 
36     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
37         require(isContract(target), "Address: call to non-contract");
38         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
39         if (success) {
40             return returndata;
41         } else {
42             if (returndata.length > 0) {
43                 assembly {
44                     let returndata_size := mload(returndata)
45                     revert(add(32, returndata), returndata_size)
46                 }
47             } else {
48                 revert(errorMessage);
49             }
50         }
51     }
52 }
53 abstract contract Context {
54     function _msgSender() internal view returns (address payable) {
55         return payable(msg.sender);
56     }
57 
58     function _msgData() internal view returns (bytes memory) {
59         this;
60         return msg.data;
61     }
62 }
63 
64 interface IERC20 {
65     function totalSupply() external view returns (uint256);
66     function balanceOf(address account) external view returns (uint256);
67     function transfer(address recipient, uint256 amount) external returns (bool);
68     function allowance(address owner, address spender) external view returns (uint256);
69     function approve(address spender, uint256 amount) external returns (bool);
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 interface IDEXFactory {
76     function createPair(address tokenA, address tokenB) external returns (address pair);
77 }
78 
79 interface IDEXRouter {
80     function factory() external pure returns (address);
81     function WETH() external pure returns (address);
82 
83     function addLiquidityETH(
84         address token,
85         uint amountTokenDesired,
86         uint amountTokenMin,
87         uint amountETHMin,
88         address to,
89         uint deadline
90     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
91 
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99 }
100 
101 contract Ownable is Context {
102     address private _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105     constructor () {
106         address msgSender = _msgSender();
107         _owner = msgSender;
108         emit OwnershipTransferred(address(0), msgSender);
109     }
110     function owner() public view returns (address) {
111         return _owner;
112     }
113     modifier onlyOwner() {
114         require(_owner == _msgSender(), "Ownable: caller is not the owner");
115         _;
116     }
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121     function transferOwnership(address newOwner) public virtual onlyOwner {
122         require(newOwner != address(0), "Ownable: new owner is the zero address");
123         emit OwnershipTransferred(_owner, newOwner);
124         _owner = newOwner;
125     }
126 }
127 
128 contract Psyduck is IERC20, Ownable {
129     using Address for address;
130     
131     address DEAD = 0x000000000000000000000000000000000000dEaD;
132     address ZERO = 0x0000000000000000000000000000000000000000;
133 
134     string constant _name = "Psyduck Inu";
135     string constant _symbol = "Psyduck";
136     uint8 constant _decimals = 9;
137 
138     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
139     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 2000;
140     uint256 _maxSellTxAmount = (_totalSupply * 1) / 500;
141     uint256 _maxWalletSize = (_totalSupply * 2) / 100;
142 
143     mapping (address => uint256) _balances;
144     mapping (address => mapping (address => uint256)) _allowances;
145     mapping (address => uint256) public lastSell;
146     mapping (address => uint256) public lastBuy;
147 
148     mapping (address => bool) isFeeExempt;
149     mapping (address => bool) isTxLimitExempt;
150     mapping (address => bool) liquidityCreator;
151 
152     uint256 marketingFee = 200;
153     uint256 liquidityFee = 400;
154     uint256 totalFee = marketingFee + liquidityFee;
155     uint256 sellBias = 0;
156     uint256 feeDenominator = 10000;
157 
158     address payable public liquidityFeeReceiver = payable(0xCb79D9c512Ded8dBe8424C9B32b15F8259366d98);
159     address payable public marketingFeeReceiver = payable(0xf786D6096fAF89fE3dD39eE98a8A13c242E8e37E);
160 
161     IDEXRouter public router;
162     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
163     mapping (address => bool) liquidityPools;
164     mapping (address => uint256) public protected;
165     bool protectionEnabled = true;
166     bool protectionDisabled = false;
167     uint256 protectionLimit;
168     uint256 public protectionCount;
169     uint256 protectionTimer;
170 
171     address public pair;
172 
173     uint256 public launchedAt;
174     uint256 public launchedTime;
175     uint256 public deadBlocks;
176     bool startBullRun = false;
177     bool pauseDisabled = false;
178     uint256 public rateLimit = 2;
179 
180     bool public swapEnabled = false;
181     bool processEnabled = true;
182     uint256 public swapThreshold = _totalSupply / 1000;
183     uint256 public swapMinimum = _totalSupply / 10000;
184     bool inSwap;
185     modifier swapping() { inSwap = true; _; inSwap = false; }
186     
187     mapping (address => bool) teamMember;
188     
189     modifier onlyTeam() {
190         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
191         _;
192     }
193     
194     event ProtectedWallet(address, address, uint256, uint8);
195 
196     constructor () {
197         router = IDEXRouter(routerAddress);
198         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
199         liquidityPools[pair] = true;
200         _allowances[owner()][routerAddress] = type(uint256).max;
201         _allowances[address(this)][routerAddress] = type(uint256).max;
202 
203         isFeeExempt[owner()] = true;
204         liquidityCreator[owner()] = true;
205 
206         isTxLimitExempt[address(this)] = true;
207         isTxLimitExempt[owner()] = true;
208         isTxLimitExempt[routerAddress] = true;
209         isTxLimitExempt[DEAD] = true;
210 
211         _balances[owner()] = _totalSupply;
212 
213         emit Transfer(address(0), owner(), _totalSupply);
214     }
215 
216     receive() external payable { }
217 
218     function totalSupply() external view override returns (uint256) { return _totalSupply; }
219     function decimals() external pure returns (uint8) { return _decimals; }
220     function symbol() external pure returns (string memory) { return _symbol; }
221     function name() external pure returns (string memory) { return _name; }
222     function getOwner() external view returns (address) { return owner(); }
223     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
224     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
225     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
226     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
227     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
228 
229     function approve(address spender, uint256 amount) public override returns (bool) {
230         _allowances[msg.sender][spender] = amount;
231         emit Approval(msg.sender, spender, amount);
232         return true;
233     }
234 
235     function approveMax(address spender) external returns (bool) {
236         return approve(spender, type(uint256).max);
237     }
238     
239     function setTeamMember(address _team, bool _enabled) external onlyOwner {
240         teamMember[_team] = _enabled;
241     }
242     
243     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
244         require(addresses.length > 0 && amounts.length == addresses.length);
245         address from = msg.sender;
246 
247         for (uint i = 0; i < addresses.length; i++) {
248             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
249                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
250             }
251         }
252     }
253     
254     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
255         uint256 amountETH = address(this).balance;
256         payable(adr).transfer((amountETH * amountPercentage) / 100);
257     }
258     
259     function openTrading(uint256 _deadBlocks, uint256 _protection, uint256 _limit) external onlyTeam {
260         require(!startBullRun && _deadBlocks < 10);
261         deadBlocks = _deadBlocks;
262         startBullRun = true;
263         launchedAt = block.number;
264         protectionTimer = block.timestamp + _protection;
265         protectionLimit = _limit * (10 ** _decimals);
266     }
267     
268     function removeTax() external onlyTeam {
269         require(!pauseDisabled);
270         startBullRun = false;
271     }
272     
273     function enableTax() external onlyTeam {
274         pauseDisabled = true;
275         startBullRun = true;
276     }
277     
278     function setblacklist(bool _protect, uint256 _addTime) external onlyTeam {
279         require(!protectionDisabled);
280         protectionEnabled = _protect;
281         require(_addTime < 1 days);
282         protectionTimer += _addTime;
283     }
284     
285     function disableblacklist() external onlyTeam {
286         protectionDisabled = true;
287         protectionEnabled = false;
288     }
289     
290     function blacklistwallet(address[] calldata _wallets, bool _protect) external onlyTeam {
291         if (_protect) {
292             require(protectionEnabled);
293         }
294         
295         for (uint i = 0; i < _wallets.length; i++) {
296             
297             if (_protect) {
298                 protectionCount++;
299                 emit ProtectedWallet(tx.origin, _wallets[i], block.number, 2);
300             }
301             else {
302                 if (protected[_wallets[i]] != 0)
303                     protectionCount--;      
304             }
305             protected[_wallets[i]] = _protect ? block.number : 0;
306         }
307     }
308 
309     function transfer(address recipient, uint256 amount) external override returns (bool) {
310         return _transferFrom(msg.sender, recipient, amount);
311     }
312 
313     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
314         if(_allowances[sender][msg.sender] != type(uint256).max){
315             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
316         }
317 
318         return _transferFrom(sender, recipient, amount);
319     }
320 
321     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
322         require(sender != address(0), "BEP20: transfer from 0x0");
323         require(recipient != address(0), "BEP20: transfer to 0x0");
324         require(amount > 0, "Amount must be > zero");
325         require(_balances[sender] >= amount, "Insufficient balance");
326         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
327         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
328 
329         checkTxLimit(sender, recipient, amount);
330         
331         if (!liquidityPools[recipient] && recipient != DEAD) {
332             if (!isTxLimitExempt[recipient]) {
333                 checkWalletLimit(recipient, amount);
334             }
335         }
336         
337         if(protectionEnabled && protectionTimer > block.timestamp) {
338             if(liquidityPools[sender] && tx.origin != recipient && protected[recipient] == 0) {
339                 protected[recipient] = block.number;
340                 protectionCount++;
341                 emit ProtectedWallet(tx.origin, recipient, block.number, 0);
342             }
343         }
344         
345         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
346 
347         _balances[sender] = _balances[sender] - amount;
348 
349         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(recipient, amount) : amount;
350         
351         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
352         
353         _balances[recipient] = _balances[recipient] + amountReceived;
354 
355         emit Transfer(sender, recipient, amountReceived);
356         return true;
357     }
358     
359     function launched() internal view returns (bool) {
360         return launchedAt != 0;
361     }
362 
363     function launch() internal {
364         launchedAt = block.number;
365         launchedTime = block.timestamp;
366         swapEnabled = true;
367     }
368 
369     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
370         _balances[sender] = _balances[sender] - amount;
371         _balances[recipient] = _balances[recipient] + amount;
372         emit Transfer(sender, recipient, amount);
373         return true;
374     }
375     
376     function checkWalletLimit(address recipient, uint256 amount) internal view {
377         uint256 walletLimit = _maxWalletSize;
378         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
379     }
380 
381     function checkTxLimit(address sender, address recipient, uint256 amount) internal {
382         require(isTxLimitExempt[sender] || amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
383         require(isTxLimitExempt[sender] || lastBuy[recipient] + rateLimit <= block.number, "Transfer rate limit exceeded.");
384         
385         if (protected[sender] != 0){
386             require(amount <= protectionLimit * (10 ** _decimals) && lastSell[sender] == 0 && protectionTimer > block.timestamp, "Wallet protected, please contact support.");
387             lastSell[sender] = block.number;
388         }
389         
390         if (liquidityPools[recipient]) {
391             lastSell[sender] = block.number;
392         } else if (shouldTakeFee(sender)) {
393             if (protectionEnabled && protectionTimer > block.timestamp && lastBuy[tx.origin] == block.number && protected[recipient] == 0) {
394                 protected[recipient] = block.number;
395                 emit ProtectedWallet(tx.origin, recipient, block.number, 1);
396             }
397             lastBuy[recipient] = block.number;
398             if (tx.origin != recipient)
399                 lastBuy[tx.origin] = block.number;
400         }
401     }
402 
403     function shouldTakeFee(address sender) internal view returns (bool) {
404         return !isFeeExempt[sender];
405     }
406 
407     function getTotalFee(bool selling) public view returns (uint256) {
408         if(launchedAt + deadBlocks >= block.number){ return feeDenominator - 1; }
409         if (selling) return totalFee + sellBias;
410         return totalFee - sellBias;
411     }
412 
413     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
414         bool selling = liquidityPools[recipient];
415         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
416         
417         _balances[address(this)] += feeAmount;
418     
419         return amount - feeAmount;
420     }
421 
422     function shouldSwapBack(address recipient) internal view returns (bool) {
423         return !liquidityPools[msg.sender]
424         && !inSwap
425         && swapEnabled
426         && liquidityPools[recipient]
427         && _balances[address(this)] >= swapMinimum;
428     }
429 
430     function swapBack(uint256 amount) internal swapping {
431         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
432         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
433         
434         uint256 amountToLiquify = (amountToSwap * liquidityFee / 2) / totalFee;
435         amountToSwap -= amountToLiquify;
436 
437         address[] memory path = new address[](2);
438         path[0] = address(this);
439         path[1] = router.WETH();
440         
441         uint256 balanceBefore = address(this).balance;
442 
443         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
444             amountToSwap,
445             0,
446             path,
447             address(this),
448             block.timestamp
449         );
450 
451         uint256 amountETH = address(this).balance - balanceBefore;
452         uint256 totalETHFee = totalFee - (liquidityFee / 2);
453 
454         uint256 amountETHLiquidity = (amountETH * liquidityFee / 2) / totalETHFee;
455         uint256 amountETHMarketing = amountETH - amountETHLiquidity;
456         
457         if (amountETHMarketing > 0)
458             marketingFeeReceiver.transfer(amountETHMarketing);
459         
460         if(amountToLiquify > 0){
461             router.addLiquidityETH{value: amountETHLiquidity}(
462                 address(this),
463                 amountToLiquify,
464                 0,
465                 0,
466                 liquidityFeeReceiver,
467                 block.timestamp
468             );
469         }
470 
471         emit FundsDistributed(amountETHMarketing, amountETHLiquidity, amountToLiquify);
472     }
473     
474     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
475         require(lp != pair, "Can't alter current liquidity pair");
476         liquidityPools[lp] = isPool;
477     }
478 
479     function setRateLimit(uint256 rate) external onlyOwner {
480         require(rate <= 60 seconds);
481         rateLimit = rate;
482     }
483 
484     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
485         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
486         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
487         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
488     }
489     
490     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
491         require(numerator > 0 && divisor > 0 && divisor <= 10000);
492         _maxWalletSize = (_totalSupply * numerator) / divisor;
493     }
494 
495     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
496         isFeeExempt[holder] = exempt;
497     }
498 
499     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
500         isTxLimitExempt[holder] = exempt;
501     }
502 
503     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
504         liquidityFee = _liquidityFee;
505         marketingFee = _marketingFee;
506         totalFee = _marketingFee + _liquidityFee;
507         sellBias = _sellBias;
508         feeDenominator = _feeDenominator;
509         require(totalFee < feeDenominator / 2);
510     }
511 
512     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
513         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
514         marketingFeeReceiver = payable(_marketingFeeReceiver);
515     }
516 
517     function setSwapBackSettings(bool _enabled, bool _processEnabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
518         require(_denominator > 0);
519         swapEnabled = _enabled;
520         processEnabled = _processEnabled;
521         swapThreshold = _totalSupply / _denominator;
522         swapMinimum = _swapMinimum * (10 ** _decimals);
523     }
524 
525     function getCirculatingSupply() public view returns (uint256) {
526         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
527     }
528 
529     event FundsDistributed(uint256 marketingETH, uint256 liquidityETH, uint256 liquidityTokens);
530 
531 }