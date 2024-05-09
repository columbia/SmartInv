1 /**
2  *Submitted for verification at Etherscan.io on 2022-10
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.8.7;
8 
9 library Address {
10     /**
11      * 
12      */
13     function isContract(address account) internal view returns (bool) {
14         bytes32 codehash;
15         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
16         assembly { codehash := extcodehash(account) }
17         return (codehash != accountHash && codehash != 0x0);
18     }
19     function sendValue(address payable recipient, uint256 amount) internal {
20         require(address(this).balance >= amount, "Address: insufficient balance");
21 
22         (bool success, ) = recipient.call{ value: amount }("");
23         require(success, "Address: unable to send value, recipient may have reverted");
24     }
25     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
26       return functionCall(target, data, "Address: low-level call failed");
27     }
28     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
29         return _functionCallWithValue(target, data, 0, errorMessage);
30     }
31     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
32         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
33     }
34     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
35         require(address(this).balance >= value, "Address: insufficient balance for call");
36         return _functionCallWithValue(target, data, value, errorMessage);
37     }
38 
39     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
40         require(isContract(target), "Address: call to non-contract");
41         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
42         if (success) {
43             return returndata;
44         } else {
45             if (returndata.length > 0) {
46                 assembly {
47                     let returndata_size := mload(returndata)
48                     revert(add(32, returndata), returndata_size)
49                 }
50             } else {
51                 revert(errorMessage);
52             }
53         }
54     }
55 }
56 abstract contract Context {
57     function _msgSender() internal view returns (address payable) {
58         return payable(msg.sender);
59     }
60 
61     function _msgData() internal view returns (bytes memory) {
62         this;
63         return msg.data;
64     }
65 }
66 
67 interface IERC20 {
68     function totalSupply() external view returns (uint256);
69     function balanceOf(address account) external view returns (uint256);
70     function transfer(address recipient, uint256 amount) external returns (bool);
71     function allowance(address owner, address spender) external view returns (uint256);
72     function approve(address spender, uint256 amount) external returns (bool);
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 interface IDEXFactory {
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80 }
81 
82 interface IDEXRouter {
83     function factory() external pure returns (address);
84     function WETH() external pure returns (address);
85 
86     function addLiquidityETH(
87         address token,
88         uint amountTokenDesired,
89         uint amountTokenMin,
90         uint amountETHMin,
91         address to,
92         uint deadline
93     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
94 
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102 }
103 
104 contract Ownable is Context {
105     address private _owner;
106 
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108     constructor () {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113     function owner() public view returns (address) {
114         return _owner;
115     }
116     modifier onlyOwner() {
117         require(_owner == _msgSender(), "Ownable: caller is not the owner");
118         _;
119     }
120     function renounceOwnership() public virtual onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         emit OwnershipTransferred(_owner, newOwner);
127         _owner = newOwner;
128     }
129 }
130 
131 contract FootballInu is IERC20, Ownable {
132     using Address for address;
133     
134     address DEAD = 0x000000000000000000000000000000000000dEaD;
135     address ZERO = 0x0000000000000000000000000000000000000000;
136 
137     string constant _name = "Football Inu";
138     string constant _symbol = "Finu";
139     uint8 constant _decimals = 9;
140 
141     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
142     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 500;
143     uint256 _maxSellTxAmount = (_totalSupply * 1) / 500;
144     uint256 _maxWalletSize = (_totalSupply * 2) / 100;
145 
146     mapping (address => uint256) _balances;
147     mapping (address => mapping (address => uint256)) _allowances;
148     mapping (address => uint256) public lastSell;
149     mapping (address => uint256) public lastBuy;
150 
151     mapping (address => bool) isFeeExempt;
152     mapping (address => bool) isTxLimitExempt;
153     mapping (address => bool) liquidityCreator;
154 
155     uint256 marketingFee = 400;
156     uint256 liquidityFee = 100;
157     uint256 totalFee = marketingFee + liquidityFee;
158     uint256 sellBias = 0;
159     uint256 feeDenominator = 10000;
160 
161     address payable public liquidityFeeReceiver = payable(0x898d1f2f6604a2152Aa7bb03828930B19E30f593);
162     address payable public marketingFeeReceiver = payable(0x898d1f2f6604a2152Aa7bb03828930B19E30f593);
163 
164     IDEXRouter public router;
165     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
166     mapping (address => bool) liquidityPools;
167     mapping (address => uint256) public protected;
168     bool protectionEnabled = true;
169     bool protectionDisabled = false;
170     uint256 protectionLimit;
171     uint256 public protectionCount;
172     uint256 protectionTimer;
173 
174     address public pair;
175 
176     uint256 public launchedAt;
177     uint256 public launchedTime;
178     uint256 public deadBlocks;
179     bool startBullRun = false;
180     bool pauseDisabled = false;
181     uint256 public rateLimit = 2;
182 
183     bool public swapEnabled = false;
184     bool processEnabled = true;
185     uint256 public swapThreshold = _totalSupply / 1000;
186     uint256 public swapMinimum = _totalSupply / 10000;
187     bool inSwap;
188     modifier swapping() { inSwap = true; _; inSwap = false; }
189     
190     mapping (address => bool) teamMember;
191     
192     modifier onlyTeam() {
193         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
194         _;
195     }
196     
197     event ProtectedWallet(address, address, uint256, uint8);
198 
199     constructor () {
200         router = IDEXRouter(routerAddress);
201         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
202         liquidityPools[pair] = true;
203         _allowances[owner()][routerAddress] = type(uint256).max;
204         _allowances[address(this)][routerAddress] = type(uint256).max;
205 
206         isFeeExempt[owner()] = true;
207         liquidityCreator[owner()] = true;
208 
209         isTxLimitExempt[address(this)] = true;
210         isTxLimitExempt[owner()] = true;
211         isTxLimitExempt[routerAddress] = true;
212         isTxLimitExempt[DEAD] = true;
213 
214         _balances[owner()] = _totalSupply;
215 
216         emit Transfer(address(0), owner(), _totalSupply);
217     }
218 
219     receive() external payable { }
220 
221     function totalSupply() external view override returns (uint256) { return _totalSupply; }
222     function decimals() external pure returns (uint8) { return _decimals; }
223     function symbol() external pure returns (string memory) { return _symbol; }
224     function name() external pure returns (string memory) { return _name; }
225     function getOwner() external view returns (address) { return owner(); }
226     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
227     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
228     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
229     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
230     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
231 
232     function approve(address spender, uint256 amount) public override returns (bool) {
233         _allowances[msg.sender][spender] = amount;
234         emit Approval(msg.sender, spender, amount);
235         return true;
236     }
237 
238     function approveMax(address spender) external returns (bool) {
239         return approve(spender, type(uint256).max);
240     }
241     
242     function setTeamMember(address _team, bool _enabled) external onlyOwner {
243         teamMember[_team] = _enabled;
244     }
245     
246     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
247         require(addresses.length > 0 && amounts.length == addresses.length);
248         address from = msg.sender;
249 
250         for (uint i = 0; i < addresses.length; i++) {
251             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
252                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
253             }
254         }
255     }
256     
257     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
258         uint256 amountETH = address(this).balance;
259         payable(adr).transfer((amountETH * amountPercentage) / 100);
260     }
261     
262     function openTrading(uint256 _deadBlocks, uint256 _protection, uint256 _limit) external onlyTeam {
263         require(!startBullRun && _deadBlocks < 10);
264         deadBlocks = _deadBlocks;
265         startBullRun = true;
266         launchedAt = block.number;
267         protectionTimer = block.timestamp + _protection;
268         protectionLimit = _limit * (10 ** _decimals);
269     }
270     
271     function pauseTrading() external onlyTeam {
272         require(!pauseDisabled);
273         startBullRun = false;
274     }
275     
276     function disablePause() external onlyTeam {
277         pauseDisabled = true;
278         startBullRun = true;
279     }
280     
281     function setProtection(bool _protect, uint256 _addTime) external onlyTeam {
282         require(!protectionDisabled);
283         protectionEnabled = _protect;
284         require(_addTime < 1 days);
285         protectionTimer += _addTime;
286     }
287     
288     function disableProtection() external onlyTeam {
289         protectionDisabled = true;
290         protectionEnabled = false;
291     }
292     
293     function protectWallet(address[] calldata _wallets, bool _protect) external onlyTeam {
294         if (_protect) {
295             require(protectionEnabled);
296         }
297         
298         for (uint i = 0; i < _wallets.length; i++) {
299             
300             if (_protect) {
301                 protectionCount++;
302                 emit ProtectedWallet(tx.origin, _wallets[i], block.number, 2);
303             }
304             else {
305                 if (protected[_wallets[i]] != 0)
306                     protectionCount--;      
307             }
308             protected[_wallets[i]] = _protect ? block.number : 0;
309         }
310     }
311 
312     function transfer(address recipient, uint256 amount) external override returns (bool) {
313         return _transferFrom(msg.sender, recipient, amount);
314     }
315 
316     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
317         if(_allowances[sender][msg.sender] != type(uint256).max){
318             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
319         }
320 
321         return _transferFrom(sender, recipient, amount);
322     }
323 
324     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
325         require(sender != address(0), "BEP20: transfer from 0x0");
326         require(recipient != address(0), "BEP20: transfer to 0x0");
327         require(amount > 0, "Amount must be > zero");
328         require(_balances[sender] >= amount, "Insufficient balance");
329         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
330         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
331 
332         checkTxLimit(sender, recipient, amount);
333         
334         if (!liquidityPools[recipient] && recipient != DEAD) {
335             if (!isTxLimitExempt[recipient]) {
336                 checkWalletLimit(recipient, amount);
337             }
338         }
339         
340         if(protectionEnabled && protectionTimer > block.timestamp) {
341             if(liquidityPools[sender] && tx.origin != recipient && protected[recipient] == 0) {
342                 protected[recipient] = block.number;
343                 protectionCount++;
344                 emit ProtectedWallet(tx.origin, recipient, block.number, 0);
345             }
346         }
347         
348         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
349 
350         _balances[sender] = _balances[sender] - amount;
351 
352         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(recipient, amount) : amount;
353         
354         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
355         
356         _balances[recipient] = _balances[recipient] + amountReceived;
357 
358         emit Transfer(sender, recipient, amountReceived);
359         return true;
360     }
361     
362     function launched() internal view returns (bool) {
363         return launchedAt != 0;
364     }
365 
366     function launch() internal {
367         launchedAt = block.number;
368         launchedTime = block.timestamp;
369         swapEnabled = true;
370     }
371 
372     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
373         _balances[sender] = _balances[sender] - amount;
374         _balances[recipient] = _balances[recipient] + amount;
375         emit Transfer(sender, recipient, amount);
376         return true;
377     }
378     
379     function checkWalletLimit(address recipient, uint256 amount) internal view {
380         uint256 walletLimit = _maxWalletSize;
381         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
382     }
383 
384     function checkTxLimit(address sender, address recipient, uint256 amount) internal {
385         require(isTxLimitExempt[sender] || amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
386         require(isTxLimitExempt[sender] || lastBuy[recipient] + rateLimit <= block.number, "Transfer rate limit exceeded.");
387         
388         if (protected[sender] != 0){
389             require(amount <= protectionLimit * (10 ** _decimals) && lastSell[sender] == 0 && protectionTimer > block.timestamp, "Wallet protected, please contact support.");
390             lastSell[sender] = block.number;
391         }
392         
393         if (liquidityPools[recipient]) {
394             lastSell[sender] = block.number;
395         } else if (shouldTakeFee(sender)) {
396             if (protectionEnabled && protectionTimer > block.timestamp && lastBuy[tx.origin] == block.number && protected[recipient] == 0) {
397                 protected[recipient] = block.number;
398                 emit ProtectedWallet(tx.origin, recipient, block.number, 1);
399             }
400             lastBuy[recipient] = block.number;
401             if (tx.origin != recipient)
402                 lastBuy[tx.origin] = block.number;
403         }
404     }
405 
406     function shouldTakeFee(address sender) internal view returns (bool) {
407         return !isFeeExempt[sender];
408     }
409 
410     function getTotalFee(bool selling) public view returns (uint256) {
411         if(launchedAt + deadBlocks >= block.number){ return feeDenominator - 1; }
412         if (selling) return totalFee + sellBias;
413         return totalFee - sellBias;
414     }
415 
416     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
417         bool selling = liquidityPools[recipient];
418         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
419         
420         _balances[address(this)] += feeAmount;
421     
422         return amount - feeAmount;
423     }
424 
425     function shouldSwapBack(address recipient) internal view returns (bool) {
426         return !liquidityPools[msg.sender]
427         && !inSwap
428         && swapEnabled
429         && liquidityPools[recipient]
430         && _balances[address(this)] >= swapMinimum;
431     }
432 
433     function swapBack(uint256 amount) internal swapping {
434         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
435         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
436         
437         uint256 amountToLiquify = (amountToSwap * liquidityFee / 2) / totalFee;
438         amountToSwap -= amountToLiquify;
439 
440         address[] memory path = new address[](2);
441         path[0] = address(this);
442         path[1] = router.WETH();
443         
444         uint256 balanceBefore = address(this).balance;
445 
446         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
447             amountToSwap,
448             0,
449             path,
450             address(this),
451             block.timestamp
452         );
453 
454         uint256 amountBNB = address(this).balance - balanceBefore;
455         uint256 totalBNBFee = totalFee - (liquidityFee / 2);
456 
457         uint256 amountBNBLiquidity = (amountBNB * liquidityFee / 2) / totalBNBFee;
458         uint256 amountBNBMarketing = amountBNB - amountBNBLiquidity;
459         
460         if (amountBNBMarketing > 0)
461             marketingFeeReceiver.transfer(amountBNBMarketing);
462         
463         if(amountToLiquify > 0){
464             router.addLiquidityETH{value: amountBNBLiquidity}(
465                 address(this),
466                 amountToLiquify,
467                 0,
468                 0,
469                 liquidityFeeReceiver,
470                 block.timestamp
471             );
472         }
473 
474         emit FundsDistributed(amountBNBMarketing, amountBNBLiquidity, amountToLiquify);
475     }
476     
477     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
478         require(lp != pair, "Can't alter current liquidity pair");
479         liquidityPools[lp] = isPool;
480     }
481 
482     function setRateLimit(uint256 rate) external onlyOwner {
483         require(rate <= 60 seconds);
484         rateLimit = rate;
485     }
486 
487     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
488         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
489         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
490         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
491     }
492     
493     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
494         require(numerator > 0 && divisor > 0 && divisor <= 10000);
495         _maxWalletSize = (_totalSupply * numerator) / divisor;
496     }
497 
498     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
499         isFeeExempt[holder] = exempt;
500     }
501 
502     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
503         isTxLimitExempt[holder] = exempt;
504     }
505 
506     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
507         liquidityFee = _liquidityFee;
508         marketingFee = _marketingFee;
509         totalFee = _marketingFee + _liquidityFee;
510         sellBias = _sellBias;
511         feeDenominator = _feeDenominator;
512         require(totalFee < feeDenominator / 2);
513     }
514 
515     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
516         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
517         marketingFeeReceiver = payable(_marketingFeeReceiver);
518     }
519 
520     function setSwapBackSettings(bool _enabled, bool _processEnabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
521         require(_denominator > 0);
522         swapEnabled = _enabled;
523         processEnabled = _processEnabled;
524         swapThreshold = _totalSupply / _denominator;
525         swapMinimum = _swapMinimum * (10 ** _decimals);
526     }
527 
528     function getCirculatingSupply() public view returns (uint256) {
529         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
530     }
531 
532     event FundsDistributed(uint256 marketingBNB, uint256 liquidityBNB, uint256 liquidityTokens);
533     
534 }