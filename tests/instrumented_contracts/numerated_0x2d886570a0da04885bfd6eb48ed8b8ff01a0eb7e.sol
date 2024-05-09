1 /**
2  * 
3 Blockchain Bets - the biggest defi betting platform. Bet on your favourite teams, players and leagues from all around the world on our sports betting platform.
4 
5 */
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.17;
9 
10 library Address {
11     function isContract(address account) internal view returns (bool) {
12         return account.code.length > 0;
13     }
14     function sendValue(address payable recipient, uint256 amount) internal {
15         require(address(this).balance >= amount, "Address: insufficient balance");
16 
17         (bool success, ) = recipient.call{value: amount}("");
18         require(success, "Address: unable to send value, recipient may have reverted");
19     }
20     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
21         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
22     }
23     function functionCall(
24         address target,
25         bytes memory data,
26         string memory errorMessage
27     ) internal returns (bytes memory) {
28         return functionCallWithValue(target, data, 0, errorMessage);
29     }
30     function functionCallWithValue(
31         address target,
32         bytes memory data,
33         uint256 value
34     ) internal returns (bytes memory) {
35         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
36     }
37     function functionCallWithValue(
38         address target,
39         bytes memory data,
40         uint256 value,
41         string memory errorMessage
42     ) internal returns (bytes memory) {
43         require(address(this).balance >= value, "Address: insufficient balance for call");
44         (bool success, bytes memory returndata) = target.call{value: value}(data);
45         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
46     }
47     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
48         return functionStaticCall(target, data, "Address: low-level static call failed");
49     }
50     function functionStaticCall(
51         address target,
52         bytes memory data,
53         string memory errorMessage
54     ) internal view returns (bytes memory) {
55         (bool success, bytes memory returndata) = target.staticcall(data);
56         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
57     }
58     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
59         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
60     }
61     function functionDelegateCall(
62         address target,
63         bytes memory data,
64         string memory errorMessage
65     ) internal returns (bytes memory) {
66         (bool success, bytes memory returndata) = target.delegatecall(data);
67         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
68     }
69     function verifyCallResultFromTarget(
70         address target,
71         bool success,
72         bytes memory returndata,
73         string memory errorMessage
74     ) internal view returns (bytes memory) {
75         if (success) {
76             if (returndata.length == 0) {
77                 // only check isContract if the call was successful and the return data is empty
78                 // otherwise we already know that it was a contract
79                 require(isContract(target), "Address: call to non-contract");
80             }
81             return returndata;
82         } else {
83             _revert(returndata, errorMessage);
84         }
85     }
86     function verifyCallResult(
87         bool success,
88         bytes memory returndata,
89         string memory errorMessage
90     ) internal pure returns (bytes memory) {
91         if (success) {
92             return returndata;
93         } else {
94             _revert(returndata, errorMessage);
95         }
96     }
97     function _revert(bytes memory returndata, string memory errorMessage) private pure {
98         // Look for revert reason and bubble it up if present
99         if (returndata.length > 0) {
100             // The easiest way to bubble the revert reason is using memory via assembly
101             /// @solidity memory-safe-assembly
102             assembly {
103                 let returndata_size := mload(returndata)
104                 revert(add(32, returndata), returndata_size)
105             }
106         } else {
107             revert(errorMessage);
108         }
109     }
110 }
111 
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 interface IERC20 {
122     function totalSupply() external view returns (uint256);
123     function balanceOf(address account) external view returns (uint256);
124     function transfer(address recipient, uint256 amount) external returns (bool);
125     function allowance(address owner, address spender) external view returns (uint256);
126     function approve(address spender, uint256 amount) external returns (bool);
127     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
128     event Transfer(address indexed from, address indexed to, uint256 value);
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 interface IDEXFactory {
133     function createPair(address tokenA, address tokenB) external returns (address pair);
134 }
135 
136 interface IDEXRouter {
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139 
140     function addLiquidityETH(
141         address token,
142         uint amountTokenDesired,
143         uint amountTokenMin,
144         uint amountETHMin,
145         address to,
146         uint deadline
147     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
148 
149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
150         uint amountIn,
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external;
156 }
157 
158 abstract contract Ownable is Context {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     constructor() {
164         _transferOwnership(_msgSender());
165     }
166     modifier onlyOwner() {
167         _checkOwner();
168         _;
169     }
170     function owner() public view virtual returns (address) {
171         return _owner;
172     }
173     function _checkOwner() internal view virtual {
174         require(owner() == _msgSender(), "Ownable: caller is not the owner");
175     }
176     function renounceOwnership() public virtual onlyOwner {
177         _transferOwnership(address(0));
178     }
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _transferOwnership(newOwner);
182     }
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 contract BlockchainBets is IERC20, Ownable {
191     using Address for address;
192     
193     address DEAD = 0x000000000000000000000000000000000000dEaD;
194     address ZERO = 0x0000000000000000000000000000000000000000;
195 
196     string constant _name = "Blockchain Bets";
197     string constant _symbol = "BCB";
198     uint8 constant _decimals = 9;
199 
200     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
201     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 200;
202     uint256 _maxSellTxAmount = (_totalSupply * 1) / 200;
203     uint256 _maxWalletSize = (_totalSupply * 1) / 100;
204 
205     mapping (address => uint256) _balances;
206     mapping (address => mapping (address => uint256)) _allowances;
207     mapping (address => uint256) public lastSell;
208     mapping (address => uint256) public lastBuy;
209 
210     mapping (address => bool) public isFeeExempt;
211     mapping (address => bool) public isTxLimitExempt;
212     mapping (address => bool) public liquidityCreator;
213 
214     uint256 marketingFee = 400;
215     uint256 marketingSellFee = 400;
216     uint256 liquidityFee = 100;
217     uint256 liquiditySellFee = 100;
218     uint256 totalBuyFee = marketingFee + liquidityFee;
219     uint256 totalSellFee = marketingSellFee + liquiditySellFee;
220     uint256 feeDenominator = 10000;
221     bool public transferTax = false;
222 
223     address payable public liquidityFeeReceiver = payable(0x456ce64B4EC0643Fa0b02312B32B9bd364f175c2);
224     address payable public marketingFeeReceiver = payable(0x456ce64B4EC0643Fa0b02312B32B9bd364f175c2);
225 
226     IDEXRouter public router;
227     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
228     mapping (address => bool) liquidityPools;
229     mapping (address => uint256) public protected;
230     bool protectionEnabled = true;
231     bool protectionDisabled = false;
232     uint256 protectionLimit;
233     uint256 public protectionCount;
234     uint256 protectionTimer;
235 
236     address public pair;
237 
238     uint256 public launchedAt;
239     uint256 public launchedTime;
240     uint256 public deadBlocks;
241     bool startBullRun = false;
242     bool pauseDisabled = false;
243     uint256 public rateLimit = 2;
244 
245     bool public swapEnabled = false;
246     uint256 public swapThreshold = _totalSupply / 1000;
247     uint256 public swapMinimum = _totalSupply / 10000;
248     bool inSwap;
249     modifier swapping() { inSwap = true; _; inSwap = false; }
250     
251     mapping (address => bool) teamMember;
252     
253     modifier onlyTeam() {
254         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
255         _;
256     }
257     
258     event ProtectedWallet(address, address, uint256, uint8);
259 
260     constructor () {
261         router = IDEXRouter(routerAddress);
262         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
263         liquidityPools[pair] = true;
264         _allowances[owner()][routerAddress] = type(uint256).max;
265         _allowances[address(this)][routerAddress] = type(uint256).max;
266 
267         isFeeExempt[owner()] = true;
268         liquidityCreator[owner()] = true;
269 
270         isTxLimitExempt[address(this)] = true;
271         isTxLimitExempt[owner()] = true;
272         isTxLimitExempt[routerAddress] = true;
273         isTxLimitExempt[DEAD] = true;
274 
275         _balances[owner()] = _totalSupply;
276 
277         emit Transfer(address(0), owner(), _totalSupply);
278     }
279 
280     receive() external payable { }
281 
282     function totalSupply() external view override returns (uint256) { return _totalSupply; }
283     function decimals() external pure returns (uint8) { return _decimals; }
284     function symbol() external pure returns (string memory) { return _symbol; }
285     function name() external pure returns (string memory) { return _name; }
286     function getOwner() external view returns (address) { return owner(); }
287     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
288     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
289     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
290     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
291     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
292 
293     function approve(address spender, uint256 amount) public override returns (bool) {
294         _allowances[msg.sender][spender] = amount;
295         emit Approval(msg.sender, spender, amount);
296         return true;
297     }
298 
299     function approveMax(address spender) external returns (bool) {
300         return approve(spender, type(uint256).max);
301     }
302     
303     function setTeamMember(address _team, bool _enabled) external onlyOwner {
304         teamMember[_team] = _enabled;
305     }
306     
307     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
308         require(addresses.length > 0 && amounts.length == addresses.length);
309         address from = msg.sender;
310 
311         for (uint i = 0; i < addresses.length; i++) {
312             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
313                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
314             }
315         }
316     }
317     
318     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
319         uint256 amountETH = address(this).balance;
320 
321         if(amountETH > 0) {
322             (bool sent, ) = adr.call{value: (amountETH * amountPercentage) / 100}("");
323             require(sent,"Failed to transfer funds");
324         }
325     }
326     
327     function openTrading(uint256 _deadBlocks, uint256 _protection, uint256 _limit) external onlyTeam {
328         require(!startBullRun && _deadBlocks < 10);
329         deadBlocks = _deadBlocks;
330         startBullRun = true;
331         launchedAt = block.number;
332         protectionTimer = block.timestamp + _protection;
333         protectionLimit = _limit * (10 ** _decimals);
334     }
335     
336     function pauseTrading() external onlyTeam {
337         require(!pauseDisabled);
338         startBullRun = false;
339     }
340     
341     function disablePause() external onlyTeam {
342         pauseDisabled = true;
343         startBullRun = true;
344     }
345     
346     function setProtection(bool _protect, uint256 _addTime) external onlyTeam {
347         require(!protectionDisabled);
348         protectionEnabled = _protect;
349         require(_addTime < 1 days);
350         protectionTimer += _addTime;
351     }
352     
353     function disableProtection() external onlyTeam {
354         protectionDisabled = true;
355         protectionEnabled = false;
356     }
357     
358     function protectWallet(address[] calldata _wallets, bool _protect) external onlyTeam {
359         if (_protect) {
360             require(protectionEnabled);
361         }
362         
363         for (uint i = 0; i < _wallets.length; i++) {
364             
365             if (_protect) {
366                 protectionCount++;
367                 emit ProtectedWallet(tx.origin, _wallets[i], block.number, 2);
368             }
369             else {
370                 if (protected[_wallets[i]] != 0)
371                     protectionCount--;      
372             }
373             protected[_wallets[i]] = _protect ? block.number : 0;
374         }
375     }
376 
377     function transfer(address recipient, uint256 amount) external override returns (bool) {
378         return _transferFrom(msg.sender, recipient, amount);
379     }
380 
381     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
382         if(_allowances[sender][msg.sender] != type(uint256).max){
383             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
384         }
385 
386         return _transferFrom(sender, recipient, amount);
387     }
388 
389     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
390         require(sender != address(0), "BEP20: transfer from 0x0");
391         require(recipient != address(0), "BEP20: transfer to 0x0");
392         require(amount > 0, "Amount must be > zero");
393         require(_balances[sender] >= amount, "Insufficient balance");
394         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
395         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
396 
397         checkTxLimit(sender, recipient, amount);
398         
399         if (!liquidityPools[recipient] && recipient != DEAD) {
400             if (!isTxLimitExempt[recipient]) {
401                 checkWalletLimit(recipient, amount);
402             }
403         }
404         
405         if(protectionEnabled && protectionTimer > block.timestamp) {
406             if(liquidityPools[sender] && tx.origin != recipient && protected[recipient] == 0) {
407                 protected[recipient] = block.number;
408                 protectionCount++;
409                 emit ProtectedWallet(tx.origin, recipient, block.number, 0);
410             }
411         }
412         
413         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
414 
415         _balances[sender] = _balances[sender] - amount;
416 
417         uint256 amountReceived = amount;
418 
419         if(shouldTakeFee(sender, recipient)) {
420             amountReceived = takeFee(recipient, amount);
421             if(shouldSwapBack(recipient) && amount > 0) swapBack(amount);
422         }
423         
424         _balances[recipient] = _balances[recipient] + amountReceived;
425 
426         emit Transfer(sender, recipient, amountReceived);
427         return true;
428     }
429     
430     function launched() internal view returns (bool) {
431         return launchedAt != 0;
432     }
433 
434     function launch() internal {
435         launchedAt = block.number;
436         launchedTime = block.timestamp;
437         swapEnabled = true;
438     }
439 
440     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
441         _balances[sender] = _balances[sender] - amount;
442         _balances[recipient] = _balances[recipient] + amount;
443         emit Transfer(sender, recipient, amount);
444         return true;
445     }
446     
447     function checkWalletLimit(address recipient, uint256 amount) internal view {
448         uint256 walletLimit = _maxWalletSize;
449         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
450     }
451 
452     function checkTxLimit(address sender, address recipient, uint256 amount) internal {
453         if (isTxLimitExempt[sender] || isTxLimitExempt[recipient]) return;
454         require(amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
455         require(lastBuy[recipient] + rateLimit <= block.number, "Transfer rate limit exceeded.");
456         
457         if (protected[sender] != 0){
458             require(amount <= protectionLimit * (10 ** _decimals) && lastSell[sender] == 0 && protectionTimer > block.timestamp, "Wallet protected, please contact support.");
459             lastSell[sender] = block.number;
460         }
461         
462         if (liquidityPools[recipient]) {
463             lastSell[sender] = block.number;
464         } else if (shouldTakeFee(sender, recipient)) {
465             if (protectionEnabled && protectionTimer > block.timestamp && lastBuy[tx.origin] == block.number && protected[recipient] == 0) {
466                 protected[recipient] = block.number;
467                 emit ProtectedWallet(tx.origin, recipient, block.number, 1);
468             }
469             lastBuy[recipient] = block.number;
470             if (tx.origin != recipient)
471                 lastBuy[tx.origin] = block.number;
472         }
473     }
474 
475     function shouldTakeFee(address sender, address recipient) public view returns (bool) {
476         if(!transferTax && !liquidityPools[recipient] && !liquidityPools[sender]) return false;
477         return !isFeeExempt[sender] && !isFeeExempt[recipient];
478     }
479 
480     function getTotalFee(bool selling) public view returns (uint256) {
481         if(launchedAt + deadBlocks >= block.number){ return feeDenominator - 1; }
482         if (selling) return totalSellFee;
483         return totalBuyFee;
484     }
485 
486     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
487         bool selling = liquidityPools[recipient];
488         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
489         
490         _balances[address(this)] += feeAmount;
491     
492         return amount - feeAmount;
493     }
494 
495     function shouldSwapBack(address recipient) internal view returns (bool) {
496         return !liquidityPools[msg.sender]
497         && !inSwap
498         && swapEnabled
499         && liquidityPools[recipient]
500         && _balances[address(this)] >= swapMinimum 
501         && totalBuyFee + totalSellFee > 0;
502     }
503 
504     function swapBack(uint256 amount) internal swapping {
505         uint256 totalFee = totalBuyFee + totalSellFee;
506         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
507         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
508         
509         uint256 totalLiquidityFee = liquidityFee + liquiditySellFee;
510         uint256 amountToLiquify = (amountToSwap * totalLiquidityFee / 2) / totalFee;
511         amountToSwap -= amountToLiquify;
512 
513         address[] memory path = new address[](2);
514         path[0] = address(this);
515         path[1] = router.WETH();
516         
517         uint256 balanceBefore = address(this).balance;
518 
519         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
520             amountToSwap,
521             0,
522             path,
523             address(this),
524             block.timestamp
525         );
526 
527         uint256 amountETH = address(this).balance - balanceBefore;
528         uint256 totalETHFee = totalFee - (totalLiquidityFee / 2);
529 
530         uint256 amountETHLiquidity = (amountETH * totalLiquidityFee / 2) / totalETHFee;
531         uint256 amountETHMarketing = amountETH - amountETHLiquidity;
532         
533         if (amountETHMarketing > 0) {
534             (bool sentMarketing, ) = marketingFeeReceiver.call{value: amountETHMarketing}("");
535             if(!sentMarketing) {
536                 //Failed to transfer to marketing wallet
537             }
538         }
539         
540         if(amountToLiquify > 0){
541             router.addLiquidityETH{value: amountETHLiquidity}(
542                 address(this),
543                 amountToLiquify,
544                 0,
545                 0,
546                 liquidityFeeReceiver,
547                 block.timestamp
548             );
549         }
550 
551         emit FundsDistributed(amountETHMarketing, amountETHLiquidity, amountToLiquify);
552     }
553     
554     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
555         require(lp != pair, "Can't alter current liquidity pair");
556         liquidityPools[lp] = isPool;
557     }
558 
559     function setRateLimit(uint256 rate) external onlyOwner {
560         require(rate <= 60 seconds);
561         rateLimit = rate;
562     }
563 
564     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
565         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
566         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
567         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
568     }
569     
570     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
571         require(numerator > 0 && divisor > 0 && divisor <= 10000);
572         _maxWalletSize = (_totalSupply * numerator) / divisor;
573     }
574 
575     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
576         isFeeExempt[holder] = exempt;
577     }
578 
579     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
580         isTxLimitExempt[holder] = exempt;
581     }
582 
583     function setFees(uint256 _liquidityFee, uint256 _liquiditySellFee, uint256 _marketingFee, uint256 _marketingSellFee, uint256 _feeDenominator) external onlyOwner {
584         require(((_liquidityFee + _liquiditySellFee) / 2) * 2 == (_liquidityFee + _liquiditySellFee), "Liquidity fee must be an even number due to rounding");
585         liquidityFee = _liquidityFee;
586         liquiditySellFee = _liquiditySellFee;
587         marketingFee = _marketingFee;
588         marketingSellFee = _marketingSellFee;
589         totalBuyFee = _liquidityFee + _marketingFee;
590         totalSellFee = _liquiditySellFee + _marketingSellFee;
591         feeDenominator = _feeDenominator;
592         require(totalBuyFee + totalSellFee <= feeDenominator / 2, "Fees too high");
593         emit FeesSet(totalBuyFee, totalSellFee, feeDenominator);
594     }
595 
596     function toggleTransferTax() external onlyOwner {
597         transferTax = !transferTax;
598     }
599 
600     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
601         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
602         marketingFeeReceiver = payable(_marketingFeeReceiver);
603     }
604 
605     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
606         require(_denominator > 0);
607         swapEnabled = _enabled;
608         swapThreshold = _totalSupply / _denominator;
609         swapMinimum = _swapMinimum * (10 ** _decimals);
610     }
611 
612     function getCirculatingSupply() public view returns (uint256) {
613         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
614     }
615 
616     event FundsDistributed(uint256 marketingETH, uint256 liquidityETH, uint256 liquidityTokens);
617     event FeesSet(uint256 totalBuyFees, uint256 totalSellFees, uint256 denominator);
618 }