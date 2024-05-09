1 // SPDX-License-Identifier: MIT
2 
3 /*
4 AIOps - a payment processing tool
5 */
6 pragma solidity 0.8.17;
7 
8 library Address {
9     function isContract(address account) internal view returns (bool) {
10         return account.code.length > 0;
11     }
12     function sendValue(address payable recipient, uint256 amount) internal {
13         require(address(this).balance >= amount, "Address: insufficient balance");
14 
15         (bool success, ) = recipient.call{value: amount}("");
16         require(success, "Address: unable to send value, recipient may have reverted");
17     }
18     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
19         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
20     }
21     function functionCall(
22         address target,
23         bytes memory data,
24         string memory errorMessage
25     ) internal returns (bytes memory) {
26         return functionCallWithValue(target, data, 0, errorMessage);
27     }
28     function functionCallWithValue(
29         address target,
30         bytes memory data,
31         uint256 value
32     ) internal returns (bytes memory) {
33         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
34     }
35     function functionCallWithValue(
36         address target,
37         bytes memory data,
38         uint256 value,
39         string memory errorMessage
40     ) internal returns (bytes memory) {
41         require(address(this).balance >= value, "Address: insufficient balance for call");
42         (bool success, bytes memory returndata) = target.call{value: value}(data);
43         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
44     }
45     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
46         return functionStaticCall(target, data, "Address: low-level static call failed");
47     }
48     function functionStaticCall(
49         address target,
50         bytes memory data,
51         string memory errorMessage
52     ) internal view returns (bytes memory) {
53         (bool success, bytes memory returndata) = target.staticcall(data);
54         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
55     }
56     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
57         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
58     }
59     function functionDelegateCall(
60         address target,
61         bytes memory data,
62         string memory errorMessage
63     ) internal returns (bytes memory) {
64         (bool success, bytes memory returndata) = target.delegatecall(data);
65         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
66     }
67     function verifyCallResultFromTarget(
68         address target,
69         bool success,
70         bytes memory returndata,
71         string memory errorMessage
72     ) internal view returns (bytes memory) {
73         if (success) {
74             if (returndata.length == 0) {
75                 // only check isContract if the call was successful and the return data is empty
76                 // otherwise we already know that it was a contract
77                 require(isContract(target), "Address: call to non-contract");
78             }
79             return returndata;
80         } else {
81             _revert(returndata, errorMessage);
82         }
83     }
84     function verifyCallResult(
85         bool success,
86         bytes memory returndata,
87         string memory errorMessage
88     ) internal pure returns (bytes memory) {
89         if (success) {
90             return returndata;
91         } else {
92             _revert(returndata, errorMessage);
93         }
94     }
95     function _revert(bytes memory returndata, string memory errorMessage) private pure {
96         // Look for revert reason and bubble it up if present
97         if (returndata.length > 0) {
98             // The easiest way to bubble the revert reason is using memory via assembly
99             /// @solidity memory-safe-assembly
100             assembly {
101                 let returndata_size := mload(returndata)
102                 revert(add(32, returndata), returndata_size)
103             }
104         } else {
105             revert(errorMessage);
106         }
107     }
108 }
109 
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114     function _msgData() internal view virtual returns (bytes calldata) {
115         return msg.data;
116     }
117 }
118 
119 interface IERC20 {
120     function totalSupply() external view returns (uint256);
121     function balanceOf(address account) external view returns (uint256);
122     function transfer(address recipient, uint256 amount) external returns (bool);
123     function allowance(address owner, address spender) external view returns (uint256);
124     function approve(address spender, uint256 amount) external returns (bool);
125     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
126     event Transfer(address indexed from, address indexed to, uint256 value);
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 interface IDEXFactory {
131     function createPair(address tokenA, address tokenB) external returns (address pair);
132 }
133 
134 interface IDEXRouter {
135     function factory() external pure returns (address);
136     function WETH() external pure returns (address);
137 
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146 
147     function swapExactTokensForETHSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external;
154 }
155 
156 abstract contract Ownable is Context {
157     address private _owner;
158 
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161     constructor() {
162         _transferOwnership(_msgSender());
163     }
164     modifier onlyOwner() {
165         _checkOwner();
166         _;
167     }
168     function owner() public view virtual returns (address) {
169         return _owner;
170     }
171     function _checkOwner() internal view virtual {
172         require(owner() == _msgSender(), "Ownable: caller is not the owner");
173     }
174     function renounceOwnership() public virtual onlyOwner {
175         _transferOwnership(address(0));
176     }
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _transferOwnership(newOwner);
180     }
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 contract AIOps is IERC20, Ownable {
189     using Address for address;
190     
191     address DEAD = 0x000000000000000000000000000000000000dEaD;
192     address ZERO = 0x0000000000000000000000000000000000000000;
193 
194     string constant _name = "AIOps";
195     string constant _symbol = "AIOps";
196     uint8 constant _decimals = 9;
197 
198     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
199     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 100;
200     uint256 _maxSellTxAmount = (_totalSupply * 1) / 100;
201     uint256 _maxWalletSize = (_totalSupply * 1) / 100;
202 
203     mapping (address => uint256) _balances;
204     mapping (address => mapping (address => uint256)) _allowances;
205     mapping (address => uint256) public lastSell;
206     mapping (address => uint256) public lastBuy;
207 
208     mapping (address => bool) public isFeeExempt;
209     mapping (address => bool) public isTxLimitExempt;
210     mapping (address => bool) public liquidityCreator;
211 
212     uint256 marketingFee = 1800;
213     uint256 marketingSellFee = 6500;
214     uint256 liquidityFee = 200;
215     uint256 liquiditySellFee = 500;
216     uint256 totalBuyFee = marketingFee + liquidityFee;
217     uint256 totalSellFee = marketingSellFee + liquiditySellFee;
218     uint256 feeDenominator = 10000;
219     bool public transferTax = false;
220 
221     address payable public liquidityFeeReceiver = payable(0xF9B5296BC4a0033B5D10774E022ba76eB50C9967);
222     address payable public marketingFeeReceiver = payable(0xF9B5296BC4a0033B5D10774E022ba76eB50C9967);
223 
224     IDEXRouter public router;
225     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
226     mapping (address => bool) liquidityPools;
227     mapping (address => uint256) public protected;
228     bool protectionEnabled = true;
229     bool protectionDisabled = false;
230     uint256 protectionLimit;
231     uint256 public protectionCount;
232     uint256 protectionTimer;
233 
234     address public pair;
235 
236     uint256 public launchedAt;
237     uint256 public launchedTime;
238     uint256 public deadBlocks;
239     bool startBullRun = false;
240     bool pauseDisabled = false;
241     uint256 public rateLimit = 2;
242 
243     bool public swapEnabled = false;
244     uint256 public swapThreshold = _totalSupply / 1000;
245     uint256 public swapMinimum = _totalSupply / 10000;
246     bool inSwap;
247     modifier swapping() { inSwap = true; _; inSwap = false; }
248     
249     mapping (address => bool) teamMember;
250     
251     modifier onlyTeam() {
252         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
253         _;
254     }
255     
256     event ProtectedWallet(address, address, uint256, uint8);
257 
258     constructor () {
259         router = IDEXRouter(routerAddress);
260         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
261         liquidityPools[pair] = true;
262         _allowances[owner()][routerAddress] = type(uint256).max;
263         _allowances[address(this)][routerAddress] = type(uint256).max;
264 
265         isFeeExempt[owner()] = true;
266         liquidityCreator[owner()] = true;
267 
268         isTxLimitExempt[address(this)] = true;
269         isTxLimitExempt[owner()] = true;
270         isTxLimitExempt[routerAddress] = true;
271         isTxLimitExempt[DEAD] = true;
272 
273         _balances[owner()] = _totalSupply;
274 
275         emit Transfer(address(0), owner(), _totalSupply);
276     }
277 
278     receive() external payable { }
279 
280     function totalSupply() external view override returns (uint256) { return _totalSupply; }
281     function decimals() external pure returns (uint8) { return _decimals; }
282     function symbol() external pure returns (string memory) { return _symbol; }
283     function name() external pure returns (string memory) { return _name; }
284     function getOwner() external view returns (address) { return owner(); }
285     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
286     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
287     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
288     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
289     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
290 
291     function approve(address spender, uint256 amount) public override returns (bool) {
292         _allowances[msg.sender][spender] = amount;
293         emit Approval(msg.sender, spender, amount);
294         return true;
295     }
296 
297     function approveMax(address spender) external returns (bool) {
298         return approve(spender, type(uint256).max);
299     }
300     
301     function setTeamMember(address _team, bool _enabled) external onlyOwner {
302         teamMember[_team] = _enabled;
303     }
304     
305     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
306         require(addresses.length > 0 && amounts.length == addresses.length);
307         address from = msg.sender;
308 
309         for (uint i = 0; i < addresses.length; i++) {
310             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
311                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
312             }
313         }
314     }
315     
316     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
317         uint256 amountETH = address(this).balance;
318 
319         if(amountETH > 0) {
320             (bool sent, ) = adr.call{value: (amountETH * amountPercentage) / 100}("");
321             require(sent,"Failed to transfer funds");
322         }
323     }
324     
325     function openTrading(uint256 _deadBlocks, uint256 _protection, uint256 _limit) external onlyTeam {
326         require(!startBullRun && _deadBlocks < 10);
327         deadBlocks = _deadBlocks;
328         startBullRun = true;
329         launchedAt = block.number;
330         protectionTimer = block.timestamp + _protection;
331         protectionLimit = _limit * (10 ** _decimals);
332     }
333     
334     
335     function setProtection(bool _protect, uint256 _addTime) external onlyTeam {
336         require(!protectionDisabled);
337         protectionEnabled = _protect;
338         require(_addTime < 1 days);
339         protectionTimer += _addTime;
340     }
341     
342     function disableProtection() external onlyTeam {
343         protectionDisabled = true;
344         protectionEnabled = false;
345     }
346     
347     function protectWallet(address[] calldata _wallets, bool _protect) external onlyTeam {
348         if (_protect) {
349             require(protectionEnabled);
350         }
351         
352         for (uint i = 0; i < _wallets.length; i++) {
353             
354             if (_protect) {
355                 protectionCount++;
356                 emit ProtectedWallet(tx.origin, _wallets[i], block.number, 2);
357             }
358             else {
359                 if (protected[_wallets[i]] != 0)
360                     protectionCount--;      
361             }
362             protected[_wallets[i]] = _protect ? block.number : 0;
363         }
364     }
365 
366     function transfer(address recipient, uint256 amount) external override returns (bool) {
367         return _transferFrom(msg.sender, recipient, amount);
368     }
369 
370     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
371         if(_allowances[sender][msg.sender] != type(uint256).max){
372             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
373         }
374 
375         return _transferFrom(sender, recipient, amount);
376     }
377 
378     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
379         require(sender != address(0), "BEP20: transfer from 0x0");
380         require(recipient != address(0), "BEP20: transfer to 0x0");
381         require(amount > 0, "Amount must be > zero");
382         require(_balances[sender] >= amount, "Insufficient balance");
383         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
384         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
385 
386         checkTxLimit(sender, recipient, amount);
387         
388         if (!liquidityPools[recipient] && recipient != DEAD) {
389             if (!isTxLimitExempt[recipient]) {
390                 checkWalletLimit(recipient, amount);
391             }
392         }
393         
394         if(protectionEnabled && protectionTimer > block.timestamp) {
395             if(liquidityPools[sender] && tx.origin != recipient && protected[recipient] == 0) {
396                 protected[recipient] = block.number;
397                 protectionCount++;
398                 emit ProtectedWallet(tx.origin, recipient, block.number, 0);
399             }
400         }
401         
402         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
403 
404         _balances[sender] = _balances[sender] - amount;
405 
406         uint256 amountReceived = amount;
407 
408         if(shouldTakeFee(sender, recipient)) {
409             amountReceived = takeFee(recipient, amount);
410             if(shouldSwapBack(recipient) && amount > 0) swapBack(amount);
411         }
412         
413         _balances[recipient] = _balances[recipient] + amountReceived;
414 
415         emit Transfer(sender, recipient, amountReceived);
416         return true;
417     }
418     
419     function launched() internal view returns (bool) {
420         return launchedAt != 0;
421     }
422 
423     function launch() internal {
424         launchedAt = block.number;
425         launchedTime = block.timestamp;
426         swapEnabled = true;
427     }
428 
429     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
430         _balances[sender] = _balances[sender] - amount;
431         _balances[recipient] = _balances[recipient] + amount;
432         emit Transfer(sender, recipient, amount);
433         return true;
434     }
435     
436     function checkWalletLimit(address recipient, uint256 amount) internal view {
437         uint256 walletLimit = _maxWalletSize;
438         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
439     }
440 
441     function checkTxLimit(address sender, address recipient, uint256 amount) internal {
442         if (isTxLimitExempt[sender] || isTxLimitExempt[recipient]) return;
443         require(amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
444         require(lastBuy[recipient] + rateLimit <= block.number, "Transfer rate limit exceeded.");
445         
446         if (protected[sender] != 0){
447             require(amount <= protectionLimit * (10 ** _decimals) && lastSell[sender] == 0 && protectionTimer > block.timestamp, "Wallet protected, please contact support.");
448             lastSell[sender] = block.number;
449         }
450         
451         if (liquidityPools[recipient]) {
452             lastSell[sender] = block.number;
453         } else if (shouldTakeFee(sender, recipient)) {
454             if (protectionEnabled && protectionTimer > block.timestamp && lastBuy[tx.origin] == block.number && protected[recipient] == 0) {
455                 protected[recipient] = block.number;
456                 emit ProtectedWallet(tx.origin, recipient, block.number, 1);
457             }
458             lastBuy[recipient] = block.number;
459             if (tx.origin != recipient)
460                 lastBuy[tx.origin] = block.number;
461         }
462     }
463 
464     function shouldTakeFee(address sender, address recipient) public view returns (bool) {
465         if(!transferTax && !liquidityPools[recipient] && !liquidityPools[sender]) return false;
466         return !isFeeExempt[sender] && !isFeeExempt[recipient];
467     }
468 
469     function getTotalFee(bool selling) public view returns (uint256) {
470         if(launchedAt + deadBlocks >= block.number){ return feeDenominator - 1; }
471         if (selling) return totalSellFee;
472         return totalBuyFee;
473     }
474 
475     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
476         bool selling = liquidityPools[recipient];
477         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
478         
479         _balances[address(this)] += feeAmount;
480     
481         return amount - feeAmount;
482     }
483 
484     function shouldSwapBack(address recipient) internal view returns (bool) {
485         return !liquidityPools[msg.sender]
486         && !inSwap
487         && swapEnabled
488         && liquidityPools[recipient]
489         && _balances[address(this)] >= swapMinimum 
490         && totalBuyFee + totalSellFee > 0;
491     }
492 
493     function swapBack(uint256 amount) internal swapping {
494         uint256 totalFee = totalBuyFee + totalSellFee;
495         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
496         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
497         
498         uint256 totalLiquidityFee = liquidityFee + liquiditySellFee;
499         uint256 amountToLiquify = (amountToSwap * totalLiquidityFee / 2) / totalFee;
500         amountToSwap -= amountToLiquify;
501 
502         address[] memory path = new address[](2);
503         path[0] = address(this);
504         path[1] = router.WETH();
505         
506         uint256 balanceBefore = address(this).balance;
507 
508         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
509             amountToSwap,
510             0,
511             path,
512             address(this),
513             block.timestamp
514         );
515 
516         uint256 amountETH = address(this).balance - balanceBefore;
517         uint256 totalETHFee = totalFee - (totalLiquidityFee / 2);
518 
519         uint256 amountETHLiquidity = (amountETH * totalLiquidityFee / 2) / totalETHFee;
520         uint256 amountETHMarketing = amountETH - amountETHLiquidity;
521         
522         if (amountETHMarketing > 0) {
523             (bool sentMarketing, ) = marketingFeeReceiver.call{value: amountETHMarketing}("");
524             if(!sentMarketing) {
525                 //Failed to transfer to marketing wallet
526             }
527         }
528         
529         if(amountToLiquify > 0){
530             router.addLiquidityETH{value: amountETHLiquidity}(
531                 address(this),
532                 amountToLiquify,
533                 0,
534                 0,
535                 liquidityFeeReceiver,
536                 block.timestamp
537             );
538         }
539 
540         emit FundsDistributed(amountETHMarketing, amountETHLiquidity, amountToLiquify);
541     }
542     
543     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
544         require(lp != pair, "Can't alter current liquidity pair");
545         liquidityPools[lp] = isPool;
546     }
547 
548     function setRateLimit(uint256 rate) external onlyOwner {
549         require(rate <= 60 seconds);
550         rateLimit = rate;
551     }
552 
553     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
554         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 1000);
555         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
556         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
557     }
558     
559     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
560         require(numerator > 0 && divisor > 0 && divisor <= 1000);
561         _maxWalletSize = (_totalSupply * numerator) / divisor;
562     }
563 
564     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
565         isFeeExempt[holder] = exempt;
566     }
567 
568     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
569         isTxLimitExempt[holder] = exempt;
570     }
571 
572     function setFees(uint256 _liquidityFee, uint256 _liquiditySellFee, uint256 _marketingFee, uint256 _marketingSellFee, uint256 _feeDenominator) external onlyOwner {
573         require(((_liquidityFee + _liquiditySellFee) / 2) * 2 == (_liquidityFee + _liquiditySellFee), "Liquidity fee must be an even number due to rounding");
574         liquidityFee = _liquidityFee;
575         liquiditySellFee = _liquiditySellFee;
576         marketingFee = _marketingFee;
577         marketingSellFee = _marketingSellFee;
578         totalBuyFee = _liquidityFee + _marketingFee;
579         totalSellFee = _liquiditySellFee + _marketingSellFee;
580         feeDenominator = _feeDenominator;
581         require(totalBuyFee + totalSellFee <= feeDenominator, "Fees too high");
582         emit FeesSet(totalBuyFee, totalSellFee, feeDenominator);
583     }
584 
585     function toggleTransferTax() external onlyOwner {
586         transferTax = !transferTax;
587     }
588 
589     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
590         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
591         marketingFeeReceiver = payable(_marketingFeeReceiver);
592     }
593 
594     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
595         require(_denominator > 0);
596         swapEnabled = _enabled;
597         swapThreshold = _totalSupply / _denominator;
598         swapMinimum = _swapMinimum * (10 ** _decimals);
599     }
600 
601     function getCirculatingSupply() public view returns (uint256) {
602         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
603     }
604 
605     event FundsDistributed(uint256 marketingETH, uint256 liquidityETH, uint256 liquidityTokens);
606     event FeesSet(uint256 totalBuyFees, uint256 totalSellFees, uint256 denominator);
607 }