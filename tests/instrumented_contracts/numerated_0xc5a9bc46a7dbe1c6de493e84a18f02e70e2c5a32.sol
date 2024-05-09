1 /**
2  * 
3 WORLD CUP INU- Experience the thrill and excitement of betting on your favourite players and win with them
4 
5 */
6 // SPDX-License-Identifier: Unlicensed
7 
8 pragma solidity ^0.8.7;
9 
10 library Address {
11     /**
12      * 
13      */
14     function isContract(address account) internal view returns (bool) {
15         bytes32 codehash;
16         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
17         assembly { codehash := extcodehash(account) }
18         return (codehash != accountHash && codehash != 0x0);
19     }
20     function sendValue(address payable recipient, uint256 amount) internal {
21         require(address(this).balance >= amount, "Address: insufficient balance");
22 
23         (bool success, ) = recipient.call{ value: amount }("");
24         require(success, "Address: unable to send value, recipient may have reverted");
25     }
26     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
27       return functionCall(target, data, "Address: low-level call failed");
28     }
29     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
30         return _functionCallWithValue(target, data, 0, errorMessage);
31     }
32     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
33         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
34     }
35     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
36         require(address(this).balance >= value, "Address: insufficient balance for call");
37         return _functionCallWithValue(target, data, value, errorMessage);
38     }
39 
40     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
41         require(isContract(target), "Address: call to non-contract");
42         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
43         if (success) {
44             return returndata;
45         } else {
46             if (returndata.length > 0) {
47                 assembly {
48                     let returndata_size := mload(returndata)
49                     revert(add(32, returndata), returndata_size)
50                 }
51             } else {
52                 revert(errorMessage);
53             }
54         }
55     }
56 }
57 abstract contract Context {
58     function _msgSender() internal view returns (address payable) {
59         return payable(msg.sender);
60     }
61 
62     function _msgData() internal view returns (bytes memory) {
63         this;
64         return msg.data;
65     }
66 }
67 
68 interface IERC20 {
69     function totalSupply() external view returns (uint256);
70     function balanceOf(address account) external view returns (uint256);
71     function transfer(address recipient, uint256 amount) external returns (bool);
72     function allowance(address owner, address spender) external view returns (uint256);
73     function approve(address spender, uint256 amount) external returns (bool);
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 interface IDEXFactory {
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81 }
82 
83 interface IDEXRouter {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86 
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95 
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103 }
104 
105 contract Ownable is Context {
106     address private _owner;
107 
108     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109     constructor () {
110         address msgSender = _msgSender();
111         _owner = msgSender;
112         emit OwnershipTransferred(address(0), msgSender);
113     }
114     function owner() public view returns (address) {
115         return _owner;
116     }
117     modifier onlyOwner() {
118         require(_owner == _msgSender(), "Ownable: caller is not the owner");
119         _;
120     }
121     function renounceOwnership() public virtual onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         emit OwnershipTransferred(_owner, newOwner);
128         _owner = newOwner;
129     }
130 }
131 
132 contract WORLDCUPINU is IERC20, Ownable {
133     using Address for address;
134     
135     address DEAD = 0x000000000000000000000000000000000000dEaD;
136     address ZERO = 0x0000000000000000000000000000000000000000;
137 
138     string constant _name = "WORLD CUP INU";
139     string constant _symbol = "WCI";
140     uint8 constant _decimals = 9;
141 
142     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
143     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 500;
144     uint256 _maxSellTxAmount = (_totalSupply * 1) / 500;
145     uint256 _maxWalletSize = (_totalSupply * 2) / 100;
146 
147     mapping (address => uint256) _balances;
148     mapping (address => mapping (address => uint256)) _allowances;
149     mapping (address => uint256) public lastSell;
150     mapping (address => uint256) public lastBuy;
151 
152     mapping (address => bool) isFeeExempt;
153     mapping (address => bool) isTxLimitExempt;
154     mapping (address => bool) liquidityCreator;
155 
156     uint256 marketingFee = 400;
157     uint256 liquidityFee = 200;
158     uint256 totalFee = marketingFee + liquidityFee;
159     uint256 sellBias = 0;
160     uint256 feeDenominator = 10000;
161 
162     address payable public liquidityFeeReceiver = payable(0x6FB8Efee44784af8a0d1fb32811ef417471A5416);
163     address payable public marketingFeeReceiver = payable(0x6FB8Efee44784af8a0d1fb32811ef417471A5416);
164 
165     IDEXRouter public router;
166     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
167     mapping (address => bool) liquidityPools;
168     mapping (address => uint256) public protected;
169     bool protectionEnabled = true;
170     bool protectionDisabled = false;
171     uint256 protectionLimit;
172     uint256 public protectionCount;
173     uint256 protectionTimer;
174 
175     address public pair;
176 
177     uint256 public launchedAt;
178     uint256 public launchedTime;
179     uint256 public deadBlocks;
180     bool startBullRun = false;
181     bool pauseDisabled = false;
182     uint256 public rateLimit = 2;
183 
184     bool public swapEnabled = false;
185     bool processEnabled = true;
186     uint256 public swapThreshold = _totalSupply / 1000;
187     uint256 public swapMinimum = _totalSupply / 10000;
188     bool inSwap;
189     modifier swapping() { inSwap = true; _; inSwap = false; }
190     
191     mapping (address => bool) teamMember;
192     
193     modifier onlyTeam() {
194         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
195         _;
196     }
197     
198     event ProtectedWallet(address, address, uint256, uint8);
199 
200     constructor () {
201         router = IDEXRouter(routerAddress);
202         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
203         liquidityPools[pair] = true;
204         _allowances[owner()][routerAddress] = type(uint256).max;
205         _allowances[address(this)][routerAddress] = type(uint256).max;
206 
207         isFeeExempt[owner()] = true;
208         liquidityCreator[owner()] = true;
209 
210         isTxLimitExempt[address(this)] = true;
211         isTxLimitExempt[owner()] = true;
212         isTxLimitExempt[routerAddress] = true;
213         isTxLimitExempt[DEAD] = true;
214 
215         _balances[owner()] = _totalSupply;
216 
217         emit Transfer(address(0), owner(), _totalSupply);
218     }
219 
220     receive() external payable { }
221 
222     function totalSupply() external view override returns (uint256) { return _totalSupply; }
223     function decimals() external pure returns (uint8) { return _decimals; }
224     function symbol() external pure returns (string memory) { return _symbol; }
225     function name() external pure returns (string memory) { return _name; }
226     function getOwner() external view returns (address) { return owner(); }
227     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
228     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
229     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
230     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
231     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
232 
233     function approve(address spender, uint256 amount) public override returns (bool) {
234         _allowances[msg.sender][spender] = amount;
235         emit Approval(msg.sender, spender, amount);
236         return true;
237     }
238 
239     function approveMax(address spender) external returns (bool) {
240         return approve(spender, type(uint256).max);
241     }
242     
243     function setTeamMember(address _team, bool _enabled) external onlyOwner {
244         teamMember[_team] = _enabled;
245     }
246     
247     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
248         require(addresses.length > 0 && amounts.length == addresses.length);
249         address from = msg.sender;
250 
251         for (uint i = 0; i < addresses.length; i++) {
252             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
253                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
254             }
255         }
256     }
257     
258     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
259         uint256 amountETH = address(this).balance;
260         payable(adr).transfer((amountETH * amountPercentage) / 100);
261     }
262     
263     function openTrading(uint256 _deadBlocks, uint256 _protection, uint256 _limit) external onlyTeam {
264         require(!startBullRun && _deadBlocks < 10);
265         deadBlocks = _deadBlocks;
266         startBullRun = true;
267         launchedAt = block.number;
268         protectionTimer = block.timestamp + _protection;
269         protectionLimit = _limit * (10 ** _decimals);
270     }
271     
272     function pauseTrading() external onlyTeam {
273         require(!pauseDisabled);
274         startBullRun = false;
275     }
276     
277     function disablePause() external onlyTeam {
278         pauseDisabled = true;
279         startBullRun = true;
280     }
281     
282     function setProtection(bool _protect, uint256 _addTime) external onlyTeam {
283         require(!protectionDisabled);
284         protectionEnabled = _protect;
285         require(_addTime < 1 days);
286         protectionTimer += _addTime;
287     }
288     
289     function disableProtection() external onlyTeam {
290         protectionDisabled = true;
291         protectionEnabled = false;
292     }
293     
294     function protectWallet(address[] calldata _wallets, bool _protect) external onlyTeam {
295         if (_protect) {
296             require(protectionEnabled);
297         }
298         
299         for (uint i = 0; i < _wallets.length; i++) {
300             
301             if (_protect) {
302                 protectionCount++;
303                 emit ProtectedWallet(tx.origin, _wallets[i], block.number, 2);
304             }
305             else {
306                 if (protected[_wallets[i]] != 0)
307                     protectionCount--;      
308             }
309             protected[_wallets[i]] = _protect ? block.number : 0;
310         }
311     }
312 
313     function transfer(address recipient, uint256 amount) external override returns (bool) {
314         return _transferFrom(msg.sender, recipient, amount);
315     }
316 
317     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
318         if(_allowances[sender][msg.sender] != type(uint256).max){
319             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
320         }
321 
322         return _transferFrom(sender, recipient, amount);
323     }
324 
325     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
326         require(sender != address(0), "BEP20: transfer from 0x0");
327         require(recipient != address(0), "BEP20: transfer to 0x0");
328         require(amount > 0, "Amount must be > zero");
329         require(_balances[sender] >= amount, "Insufficient balance");
330         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
331         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
332 
333         checkTxLimit(sender, recipient, amount);
334         
335         if (!liquidityPools[recipient] && recipient != DEAD) {
336             if (!isTxLimitExempt[recipient]) {
337                 checkWalletLimit(recipient, amount);
338             }
339         }
340         
341         if(protectionEnabled && protectionTimer > block.timestamp) {
342             if(liquidityPools[sender] && tx.origin != recipient && protected[recipient] == 0) {
343                 protected[recipient] = block.number;
344                 protectionCount++;
345                 emit ProtectedWallet(tx.origin, recipient, block.number, 0);
346             }
347         }
348         
349         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
350 
351         _balances[sender] = _balances[sender] - amount;
352 
353         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(recipient, amount) : amount;
354         
355         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
356         
357         _balances[recipient] = _balances[recipient] + amountReceived;
358 
359         emit Transfer(sender, recipient, amountReceived);
360         return true;
361     }
362     
363     function launched() internal view returns (bool) {
364         return launchedAt != 0;
365     }
366 
367     function launch() internal {
368         launchedAt = block.number;
369         launchedTime = block.timestamp;
370         swapEnabled = true;
371     }
372 
373     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
374         _balances[sender] = _balances[sender] - amount;
375         _balances[recipient] = _balances[recipient] + amount;
376         emit Transfer(sender, recipient, amount);
377         return true;
378     }
379     
380     function checkWalletLimit(address recipient, uint256 amount) internal view {
381         uint256 walletLimit = _maxWalletSize;
382         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
383     }
384 
385     function checkTxLimit(address sender, address recipient, uint256 amount) internal {
386         require(isTxLimitExempt[sender] || amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
387         require(isTxLimitExempt[sender] || lastBuy[recipient] + rateLimit <= block.number, "Transfer rate limit exceeded.");
388         
389         if (protected[sender] != 0){
390             require(amount <= protectionLimit * (10 ** _decimals) && lastSell[sender] == 0 && protectionTimer > block.timestamp, "Wallet protected, please contact support.");
391             lastSell[sender] = block.number;
392         }
393         
394         if (liquidityPools[recipient]) {
395             lastSell[sender] = block.number;
396         } else if (shouldTakeFee(sender)) {
397             if (protectionEnabled && protectionTimer > block.timestamp && lastBuy[tx.origin] == block.number && protected[recipient] == 0) {
398                 protected[recipient] = block.number;
399                 emit ProtectedWallet(tx.origin, recipient, block.number, 1);
400             }
401             lastBuy[recipient] = block.number;
402             if (tx.origin != recipient)
403                 lastBuy[tx.origin] = block.number;
404         }
405     }
406 
407     function shouldTakeFee(address sender) internal view returns (bool) {
408         return !isFeeExempt[sender];
409     }
410 
411     function getTotalFee(bool selling) public view returns (uint256) {
412         if(launchedAt + deadBlocks >= block.number){ return feeDenominator - 1; }
413         if (selling) return totalFee + sellBias;
414         return totalFee - sellBias;
415     }
416 
417     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
418         bool selling = liquidityPools[recipient];
419         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
420         
421         _balances[address(this)] += feeAmount;
422     
423         return amount - feeAmount;
424     }
425 
426     function shouldSwapBack(address recipient) internal view returns (bool) {
427         return !liquidityPools[msg.sender]
428         && !inSwap
429         && swapEnabled
430         && liquidityPools[recipient]
431         && _balances[address(this)] >= swapMinimum;
432     }
433 
434     function swapBack(uint256 amount) internal swapping {
435         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
436         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
437         
438         uint256 amountToLiquify = (amountToSwap * liquidityFee / 2) / totalFee;
439         amountToSwap -= amountToLiquify;
440 
441         address[] memory path = new address[](2);
442         path[0] = address(this);
443         path[1] = router.WETH();
444         
445         uint256 balanceBefore = address(this).balance;
446 
447         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
448             amountToSwap,
449             0,
450             path,
451             address(this),
452             block.timestamp
453         );
454 
455         uint256 amountBNB = address(this).balance - balanceBefore;
456         uint256 totalBNBFee = totalFee - (liquidityFee / 2);
457 
458         uint256 amountBNBLiquidity = (amountBNB * liquidityFee / 2) / totalBNBFee;
459         uint256 amountBNBMarketing = amountBNB - amountBNBLiquidity;
460         
461         if (amountBNBMarketing > 0)
462             marketingFeeReceiver.transfer(amountBNBMarketing);
463         
464         if(amountToLiquify > 0){
465             router.addLiquidityETH{value: amountBNBLiquidity}(
466                 address(this),
467                 amountToLiquify,
468                 0,
469                 0,
470                 liquidityFeeReceiver,
471                 block.timestamp
472             );
473         }
474 
475         emit FundsDistributed(amountBNBMarketing, amountBNBLiquidity, amountToLiquify);
476     }
477     
478     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
479         require(lp != pair, "Can't alter current liquidity pair");
480         liquidityPools[lp] = isPool;
481     }
482 
483     function setRateLimit(uint256 rate) external onlyOwner {
484         require(rate <= 60 seconds);
485         rateLimit = rate;
486     }
487 
488     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
489         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
490         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
491         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
492     }
493     
494     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
495         require(numerator > 0 && divisor > 0 && divisor <= 10000);
496         _maxWalletSize = (_totalSupply * numerator) / divisor;
497     }
498 
499     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
500         isFeeExempt[holder] = exempt;
501     }
502 
503     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
504         isTxLimitExempt[holder] = exempt;
505     }
506 
507     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
508         liquidityFee = _liquidityFee;
509         marketingFee = _marketingFee;
510         totalFee = _marketingFee + _liquidityFee;
511         sellBias = _sellBias;
512         feeDenominator = _feeDenominator;
513         require(totalFee < feeDenominator / 2);
514     }
515 
516     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
517         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
518         marketingFeeReceiver = payable(_marketingFeeReceiver);
519     }
520 
521     function setSwapBackSettings(bool _enabled, bool _processEnabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
522         require(_denominator > 0);
523         swapEnabled = _enabled;
524         processEnabled = _processEnabled;
525         swapThreshold = _totalSupply / _denominator;
526         swapMinimum = _swapMinimum * (10 ** _decimals);
527     }
528 
529     function getCirculatingSupply() public view returns (uint256) {
530         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
531     }
532 
533     event FundsDistributed(uint256 marketingBNB, uint256 liquidityBNB, uint256 liquidityTokens);
534     
535 }