1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.18;
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7         return account.code.length > 0;
8     }
9     function sendValue(address payable recipient, uint256 amount) internal {
10         require(address(this).balance >= amount, "Address: insufficient balance");
11 
12         (bool success, ) = recipient.call{value: amount}("");
13         require(success, "Address: unable to send value, recipient may have reverted");
14     }
15     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
16         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
17     }
18     function functionCall(
19         address target,
20         bytes memory data,
21         string memory errorMessage
22     ) internal returns (bytes memory) {
23         return functionCallWithValue(target, data, 0, errorMessage);
24     }
25     function functionCallWithValue(
26         address target,
27         bytes memory data,
28         uint256 value
29     ) internal returns (bytes memory) {
30         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
31     }
32     function functionCallWithValue(
33         address target,
34         bytes memory data,
35         uint256 value,
36         string memory errorMessage
37     ) internal returns (bytes memory) {
38         require(address(this).balance >= value, "Address: insufficient balance for call");
39         (bool success, bytes memory returndata) = target.call{value: value}(data);
40         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
41     }
42     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
43         return functionStaticCall(target, data, "Address: low-level static call failed");
44     }
45     function functionStaticCall(
46         address target,
47         bytes memory data,
48         string memory errorMessage
49     ) internal view returns (bytes memory) {
50         (bool success, bytes memory returndata) = target.staticcall(data);
51         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
52     }
53     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
54         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
55     }
56     function functionDelegateCall(
57         address target,
58         bytes memory data,
59         string memory errorMessage
60     ) internal returns (bytes memory) {
61         (bool success, bytes memory returndata) = target.delegatecall(data);
62         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
63     }
64     function verifyCallResultFromTarget(
65         address target,
66         bool success,
67         bytes memory returndata,
68         string memory errorMessage
69     ) internal view returns (bytes memory) {
70         if (success) {
71             if (returndata.length == 0) {
72                 // only check isContract if the call was successful and the return data is empty
73                 // otherwise we already know that it was a contract
74                 require(isContract(target), "Address: call to non-contract");
75             }
76             return returndata;
77         } else {
78             _revert(returndata, errorMessage);
79         }
80     }
81     function verifyCallResult(
82         bool success,
83         bytes memory returndata,
84         string memory errorMessage
85     ) internal pure returns (bytes memory) {
86         if (success) {
87             return returndata;
88         } else {
89             _revert(returndata, errorMessage);
90         }
91     }
92     function _revert(bytes memory returndata, string memory errorMessage) private pure {
93         // Look for revert reason and bubble it up if present
94         if (returndata.length > 0) {
95             // The easiest way to bubble the revert reason is using memory via assembly
96             /// @solidity memory-safe-assembly
97             assembly {
98                 let returndata_size := mload(returndata)
99                 revert(add(32, returndata), returndata_size)
100             }
101         } else {
102             revert(errorMessage);
103         }
104     }
105 }
106 
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111     function _msgData() internal view virtual returns (bytes calldata) {
112         return msg.data;
113     }
114 }
115 
116 interface IERC20 {
117     function totalSupply() external view returns (uint256);
118     function balanceOf(address account) external view returns (uint256);
119     function transfer(address recipient, uint256 amount) external returns (bool);
120     function allowance(address owner, address spender) external view returns (uint256);
121     function approve(address spender, uint256 amount) external returns (bool);
122     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 interface IDEXFactory {
128     function createPair(address tokenA, address tokenB) external returns (address pair);
129 }
130 
131 interface IDEXRouter {
132     function factory() external pure returns (address);
133     function WETH() external pure returns (address);
134 
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 }
152 
153 abstract contract Ownable is Context {
154     address private _owner;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     constructor() {
159         _transferOwnership(_msgSender());
160     }
161     modifier onlyOwner() {
162         _checkOwner();
163         _;
164     }
165     function owner() public view virtual returns (address) {
166         return _owner;
167     }
168     function _checkOwner() internal view virtual {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170     }
171     function renounceOwnership() public virtual onlyOwner {
172         _transferOwnership(address(0));
173     }
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178     function _transferOwnership(address newOwner) internal virtual {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 contract FIERY is IERC20, Ownable {
186     using Address for address;
187     
188     address DEAD = 0x000000000000000000000000000000000000dEaD;
189     address ZERO = 0x0000000000000000000000000000000000000000;
190 
191     string constant _name = "FIERY";
192     string constant _symbol = "FYR";
193     uint8 constant _decimals = 9;
194 
195     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
196     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 100;
197     uint256 _maxSellTxAmount = (_totalSupply * 1) / 100;
198     uint256 _maxWalletSize = (_totalSupply * 1) / 50;
199 
200     mapping (address => uint256) _balances;
201     mapping (address => mapping (address => uint256)) _allowances;
202     mapping (address => uint256) public lastSell;
203     mapping (address => uint256) public lastBuy;
204 
205     mapping (address => bool) public isFeeExempt;
206     mapping (address => bool) public isTxLimitExempt;
207     mapping (address => bool) public liquidityCreator;
208 
209     uint256 marketingFee = 900;
210     uint256 marketingSellFee = 3700;
211     uint256 liquidityFee = 100;
212     uint256 liquiditySellFee = 300;
213     uint256 totalBuyFee = marketingFee + liquidityFee;
214     uint256 totalSellFee = marketingSellFee + liquiditySellFee;
215     uint256 feeDenominator = 10000;
216     bool public transferTax = false;
217 
218     address payable public liquidityFeeReceiver = payable(0x0995ABe0E5Bc5f20E63602A356Bc8E1A63F37e5B);
219     address payable public marketingFeeReceiver = payable(0x0995ABe0E5Bc5f20E63602A356Bc8E1A63F37e5B);
220 
221     IDEXRouter public router;
222     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
223     mapping (address => bool) liquidityPools;
224     mapping (address => uint256) public protected;
225     bool protectionEnabled = true;
226     bool protectionDisabled = false;
227     uint256 protectionLimit;
228     uint256 public protectionCount;
229     uint256 protectionTimer;
230 
231     address public pair;
232 
233     uint256 public launchedAt;
234     uint256 public launchedTime;
235     uint256 public deadBlocks;
236     bool startBullRun = false;
237     bool pauseDisabled = false;
238     uint256 public rateLimit = 2;
239 
240     bool public swapEnabled = false;
241     uint256 public swapThreshold = _totalSupply / 1000;
242     uint256 public swapMinimum = _totalSupply / 10000;
243     bool inSwap;
244     modifier swapping() { inSwap = true; _; inSwap = false; }
245     
246     mapping (address => bool) teamMember;
247     
248     modifier onlyTeam() {
249         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
250         _;
251     }
252     
253     event ProtectedWallet(address, address, uint256, uint8);
254 
255     constructor () {
256         router = IDEXRouter(routerAddress);
257         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
258         liquidityPools[pair] = true;
259         _allowances[owner()][routerAddress] = type(uint256).max;
260         _allowances[address(this)][routerAddress] = type(uint256).max;
261 
262         isFeeExempt[owner()] = true;
263         liquidityCreator[owner()] = true;
264 
265         isTxLimitExempt[address(this)] = true;
266         isTxLimitExempt[owner()] = true;
267         isTxLimitExempt[routerAddress] = true;
268         isTxLimitExempt[DEAD] = true;
269 
270         _balances[owner()] = _totalSupply;
271 
272         emit Transfer(address(0), owner(), _totalSupply);
273     }
274 
275     receive() external payable { }
276 
277     function totalSupply() external view override returns (uint256) { return _totalSupply; }
278     function decimals() external pure returns (uint8) { return _decimals; }
279     function symbol() external pure returns (string memory) { return _symbol; }
280     function name() external pure returns (string memory) { return _name; }
281     function getOwner() external view returns (address) { return owner(); }
282     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
283     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
284     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
285     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
286     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
287 
288     function approve(address spender, uint256 amount) public override returns (bool) {
289         _allowances[msg.sender][spender] = amount;
290         emit Approval(msg.sender, spender, amount);
291         return true;
292     }
293 
294     function approveMax(address spender) external returns (bool) {
295         return approve(spender, type(uint256).max);
296     }
297     
298     function setTeamMember(address _team, bool _enabled) external onlyOwner {
299         teamMember[_team] = _enabled;
300     }
301     
302     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
303         require(addresses.length > 0 && amounts.length == addresses.length);
304         address from = msg.sender;
305 
306         for (uint i = 0; i < addresses.length; i++) {
307             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
308                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
309             }
310         }
311     }
312     
313     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
314         uint256 amountETH = address(this).balance;
315 
316         if(amountETH > 0) {
317             (bool sent, ) = adr.call{value: (amountETH * amountPercentage) / 100}("");
318             require(sent,"Failed to transfer funds");
319         }
320     }
321     
322     function openTrading(uint256 _deadBlocks, uint256 _protection, uint256 _limit) external onlyTeam {
323         require(!startBullRun && _deadBlocks < 10);
324         deadBlocks = _deadBlocks;
325         startBullRun = true;
326         launchedAt = block.number;
327         protectionTimer = block.timestamp + _protection;
328         protectionLimit = _limit * (10 ** _decimals);
329     }
330     
331     
332     function disablePause() external onlyTeam {
333         pauseDisabled = true;
334         startBullRun = true;
335     }
336     
337     function setProtection(bool _protect, uint256 _addTime) external onlyTeam {
338         require(!protectionDisabled);
339         protectionEnabled = _protect;
340         require(_addTime < 1 days);
341         protectionTimer += _addTime;
342     }
343     
344     function disableProtection() external onlyTeam {
345         protectionDisabled = true;
346         protectionEnabled = false;
347     }
348     
349     function protectWallet(address[] calldata _wallets, bool _protect) external onlyTeam {
350         if (_protect) {
351             require(protectionEnabled);
352         }
353         
354         for (uint i = 0; i < _wallets.length; i++) {
355             
356             if (_protect) {
357                 protectionCount++;
358                 emit ProtectedWallet(tx.origin, _wallets[i], block.number, 2);
359             }
360             else {
361                 if (protected[_wallets[i]] != 0)
362                     protectionCount--;      
363             }
364             protected[_wallets[i]] = _protect ? block.number : 0;
365         }
366     }
367 
368     function transfer(address recipient, uint256 amount) external override returns (bool) {
369         return _transferFrom(msg.sender, recipient, amount);
370     }
371 
372     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
373         if(_allowances[sender][msg.sender] != type(uint256).max){
374             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
375         }
376 
377         return _transferFrom(sender, recipient, amount);
378     }
379 
380     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
381         require(sender != address(0), "BEP20: transfer from 0x0");
382         require(recipient != address(0), "BEP20: transfer to 0x0");
383         require(amount > 0, "Amount must be > zero");
384         require(_balances[sender] >= amount, "Insufficient balance");
385         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
386         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
387 
388         checkTxLimit(sender, recipient, amount);
389         
390         if (!liquidityPools[recipient] && recipient != DEAD) {
391             if (!isTxLimitExempt[recipient]) {
392                 checkWalletLimit(recipient, amount);
393             }
394         }
395         
396         if(protectionEnabled && protectionTimer > block.timestamp) {
397             if(liquidityPools[sender] && tx.origin != recipient && protected[recipient] == 0) {
398                 protected[recipient] = block.number;
399                 protectionCount++;
400                 emit ProtectedWallet(tx.origin, recipient, block.number, 0);
401             }
402         }
403         
404         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
405 
406         _balances[sender] = _balances[sender] - amount;
407 
408         uint256 amountReceived = amount;
409 
410         if(shouldTakeFee(sender, recipient)) {
411             amountReceived = takeFee(recipient, amount);
412             if(shouldSwapBack(recipient) && amount > 0) swapBack(amount);
413         }
414         
415         _balances[recipient] = _balances[recipient] + amountReceived;
416 
417         emit Transfer(sender, recipient, amountReceived);
418         return true;
419     }
420     
421     function launched() internal view returns (bool) {
422         return launchedAt != 0;
423     }
424 
425     function launch() internal {
426         launchedAt = block.number;
427         launchedTime = block.timestamp;
428         swapEnabled = true;
429     }
430 
431     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
432         _balances[sender] = _balances[sender] - amount;
433         _balances[recipient] = _balances[recipient] + amount;
434         emit Transfer(sender, recipient, amount);
435         return true;
436     }
437     
438     function checkWalletLimit(address recipient, uint256 amount) internal view {
439         uint256 walletLimit = _maxWalletSize;
440         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
441     }
442 
443     function checkTxLimit(address sender, address recipient, uint256 amount) internal {
444         if (isTxLimitExempt[sender] || isTxLimitExempt[recipient]) return;
445         require(amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
446         require(lastBuy[recipient] + rateLimit <= block.number, "Transfer rate limit exceeded.");
447         
448         if (protected[sender] != 0){
449             require(amount <= protectionLimit * (10 ** _decimals) && lastSell[sender] == 0 && protectionTimer > block.timestamp, "Wallet protected, please contact support.");
450             lastSell[sender] = block.number;
451         }
452         
453         if (liquidityPools[recipient]) {
454             lastSell[sender] = block.number;
455         } else if (shouldTakeFee(sender, recipient)) {
456             if (protectionEnabled && protectionTimer > block.timestamp && lastBuy[tx.origin] == block.number && protected[recipient] == 0) {
457                 protected[recipient] = block.number;
458                 emit ProtectedWallet(tx.origin, recipient, block.number, 1);
459             }
460             lastBuy[recipient] = block.number;
461             if (tx.origin != recipient)
462                 lastBuy[tx.origin] = block.number;
463         }
464     }
465 
466     function shouldTakeFee(address sender, address recipient) public view returns (bool) {
467         if(!transferTax && !liquidityPools[recipient] && !liquidityPools[sender]) return false;
468         return !isFeeExempt[sender] && !isFeeExempt[recipient];
469     }
470 
471     function getTotalFee(bool selling) public view returns (uint256) {
472         if(launchedAt + deadBlocks >= block.number){ return feeDenominator - 1; }
473         if (selling) return totalSellFee;
474         return totalBuyFee;
475     }
476 
477     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
478         bool selling = liquidityPools[recipient];
479         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
480         
481         _balances[address(this)] += feeAmount;
482     
483         return amount - feeAmount;
484     }
485 
486     function shouldSwapBack(address recipient) internal view returns (bool) {
487         return !liquidityPools[msg.sender]
488         && !inSwap
489         && swapEnabled
490         && liquidityPools[recipient]
491         && _balances[address(this)] >= swapMinimum 
492         && totalBuyFee + totalSellFee > 0;
493     }
494 
495     function swapBack(uint256 amount) internal swapping {
496         uint256 totalFee = totalBuyFee + totalSellFee;
497         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
498         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
499         
500         uint256 totalLiquidityFee = liquidityFee + liquiditySellFee;
501         uint256 amountToLiquify = (amountToSwap * totalLiquidityFee / 2) / totalFee;
502         amountToSwap -= amountToLiquify;
503 
504         address[] memory path = new address[](2);
505         path[0] = address(this);
506         path[1] = router.WETH();
507         
508         uint256 balanceBefore = address(this).balance;
509 
510         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
511             amountToSwap,
512             0,
513             path,
514             address(this),
515             block.timestamp
516         );
517 
518         uint256 amountETH = address(this).balance - balanceBefore;
519         uint256 totalETHFee = totalFee - (totalLiquidityFee / 2);
520 
521         uint256 amountETHLiquidity = (amountETH * totalLiquidityFee / 2) / totalETHFee;
522         uint256 amountETHMarketing = amountETH - amountETHLiquidity;
523         
524         if (amountETHMarketing > 0) {
525             (bool sentMarketing, ) = marketingFeeReceiver.call{value: amountETHMarketing}("");
526             if(!sentMarketing) {
527                 //Failed to transfer to marketing wallet
528             }
529         }
530         
531         if(amountToLiquify > 0){
532             router.addLiquidityETH{value: amountETHLiquidity}(
533                 address(this),
534                 amountToLiquify,
535                 0,
536                 0,
537                 liquidityFeeReceiver,
538                 block.timestamp
539             );
540         }
541 
542         emit FundsDistributed(amountETHMarketing, amountETHLiquidity, amountToLiquify);
543     }
544     
545     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
546         require(lp != pair, "Can't alter current liquidity pair");
547         liquidityPools[lp] = isPool;
548     }
549 
550     function setRateLimit(uint256 rate) external onlyOwner {
551         require(rate <= 60 seconds);
552         rateLimit = rate;
553     }
554 
555     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
556         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
557         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
558         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
559     }
560     
561     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
562         require(numerator > 0 && divisor > 0 && divisor <= 10000);
563         _maxWalletSize = (_totalSupply * numerator) / divisor;
564     }
565 
566     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
567         isFeeExempt[holder] = exempt;
568     }
569 
570     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
571         isTxLimitExempt[holder] = exempt;
572     }
573 
574     function setFees(uint256 _liquidityFee, uint256 _liquiditySellFee, uint256 _marketingFee, uint256 _marketingSellFee, uint256 _feeDenominator) external onlyOwner {
575         require(((_liquidityFee + _liquiditySellFee) / 2) * 2 == (_liquidityFee + _liquiditySellFee), "Liquidity fee must be an even number due to rounding");
576         liquidityFee = _liquidityFee;
577         liquiditySellFee = _liquiditySellFee;
578         marketingFee = _marketingFee;
579         marketingSellFee = _marketingSellFee;
580         totalBuyFee = _liquidityFee + _marketingFee;
581         totalSellFee = _liquiditySellFee + _marketingSellFee;
582         feeDenominator = _feeDenominator;
583         require(totalBuyFee + totalSellFee <= feeDenominator / 2, "Fees too high");
584         emit FeesSet(totalBuyFee, totalSellFee, feeDenominator);
585     }
586 
587     function toggleTransferTax() external onlyOwner {
588         transferTax = !transferTax;
589     }
590 
591     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
592         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
593         marketingFeeReceiver = payable(_marketingFeeReceiver);
594     }
595 
596     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
597         require(_denominator > 0);
598         swapEnabled = _enabled;
599         swapThreshold = _totalSupply / _denominator;
600         swapMinimum = _swapMinimum * (10 ** _decimals);
601     }
602 
603     function getCirculatingSupply() public view returns (uint256) {
604         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
605     }
606 
607     event FundsDistributed(uint256 marketingETH, uint256 liquidityETH, uint256 liquidityTokens);
608     event FeesSet(uint256 totalBuyFees, uint256 totalSellFees, uint256 denominator);
609 }