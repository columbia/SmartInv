1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7         return account.code.length > 0;
8     }
9 
10     function sendValue(address payable recipient, uint256 amount) internal {
11         require(address(this).balance >= amount, "Address: insufficient balance");
12 
13         (bool success, ) = recipient.call{value: amount}("");
14         require(success, "Address: unable to send value, recipient may have reverted");
15     }
16 
17     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
18         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
19     }
20 
21     function functionCall(
22         address target,
23         bytes memory data,
24         string memory errorMessage
25     ) internal returns (bytes memory) {
26         return functionCallWithValue(target, data, 0, errorMessage);
27     }
28 
29     function functionCallWithValue(
30         address target,
31         bytes memory data,
32         uint256 value
33     ) internal returns (bytes memory) {
34         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
35     }
36 
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
47 
48     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
49         return functionStaticCall(target, data, "Address: low-level static call failed");
50     }
51 
52     function functionStaticCall(
53         address target,
54         bytes memory data,
55         string memory errorMessage
56     ) internal view returns (bytes memory) {
57         (bool success, bytes memory returndata) = target.staticcall(data);
58         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
59     }
60 
61     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
62         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
63     }
64 
65     function functionDelegateCall(
66         address target,
67         bytes memory data,
68         string memory errorMessage
69     ) internal returns (bytes memory) {
70         (bool success, bytes memory returndata) = target.delegatecall(data);
71         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
72     }
73 
74     function verifyCallResultFromTarget(
75         address target,
76         bool success,
77         bytes memory returndata,
78         string memory errorMessage
79     ) internal view returns (bytes memory) {
80         if (success) {
81             if (returndata.length == 0) {
82                 // only check isContract if the call was successful and the return data is empty
83                 // otherwise we already know that it was a contract
84                 require(isContract(target), "Address: call to non-contract");
85             }
86             return returndata;
87         } else {
88             _revert(returndata, errorMessage);
89         }
90     }
91 
92     function verifyCallResult(
93         bool success,
94         bytes memory returndata,
95         string memory errorMessage
96     ) internal pure returns (bytes memory) {
97         if (success) {
98             return returndata;
99         } else {
100             _revert(returndata, errorMessage);
101         }
102     }
103 
104     function _revert(bytes memory returndata, string memory errorMessage) private pure {
105         // Look for revert reason and bubble it up if present
106         if (returndata.length > 0) {
107             // The easiest way to bubble the revert reason is using memory via assembly
108             /// @solidity memory-safe-assembly
109             assembly {
110                 let returndata_size := mload(returndata)
111                 revert(add(32, returndata), returndata_size)
112             }
113         } else {
114             revert(errorMessage);
115         }
116     }
117 }
118 
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         return msg.data;
126     }
127 }
128 
129 interface IERC20 {
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 
134     function totalSupply() external view returns (uint256);
135 
136     function balanceOf(address account) external view returns (uint256);
137 
138     function transfer(address to, uint256 amount) external returns (bool);
139 
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     function approve(address spender, uint256 amount) external returns (bool);
143 
144     function transferFrom(
145         address from,
146         address to,
147         uint256 amount
148     ) external returns (bool);
149 }
150 
151 interface IDEXPair {
152     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
153 }
154 
155 interface IDEXFactory {
156     function createPair(address tokenA, address tokenB) external returns (address pair);
157     function getPair(address tokenA, address tokenB) external view returns (address pair);
158 }
159 
160 interface IDEXRouter {
161     function factory() external pure returns (address);
162     function WETH() external pure returns (address);
163 
164     function addLiquidityETH(
165         address token,
166         uint amountTokenDesired,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline
171     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
172 
173     function swapExactETHForTokensSupportingFeeOnTransferTokens(
174         uint amountOutMin,
175         address[] calldata path,
176         address to,
177         uint deadline
178     ) external payable;
179 
180     function swapExactTokensForETHSupportingFeeOnTransferTokens(
181         uint amountIn,
182         uint amountOutMin,
183         address[] calldata path,
184         address to,
185         uint deadline
186     ) external;
187 }
188 
189 abstract contract Ownable is Context {
190     address private _owner;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     modifier onlyOwner() {
199         _checkOwner();
200         _;
201     }
202 
203     function owner() public view virtual returns (address) {
204         return _owner;
205     }
206 
207     function _checkOwner() internal view virtual {
208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
209     }
210 
211     function renounceOwnership() public virtual onlyOwner {
212         _transferOwnership(address(0));
213     }
214 
215     function transferOwnership(address newOwner) public virtual onlyOwner {
216         require(newOwner != address(0), "Ownable: new owner is the zero address");
217         _transferOwnership(newOwner);
218     }
219 
220     function _transferOwnership(address newOwner) internal virtual {
221         address oldOwner = _owner;
222         _owner = newOwner;
223         emit OwnershipTransferred(oldOwner, newOwner);
224     }
225 }
226 
227 interface IAntiSnipe {
228   function setTokenOwner(address owner, address pair) external;
229 
230   function onPreTransferCheck(
231     address sender,
232     address from,
233     address to,
234     uint256 amount
235   ) external returns (bool checked);
236 }
237 
238 contract Kaeri is IERC20, Ownable {
239     using Address for address;
240     
241     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
242 
243     string constant _name = "Kaeri";
244     string constant _symbol = "KAERI";
245     uint8 constant _decimals = 9;
246 
247     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
248 
249     //For ease to the end-user these checks do not adjust for burnt tokens and should be set accordingly.
250     uint256 _maxTxAmount = 5; //0.5%
251     uint256 _maxWalletSize = 10; //1%
252 
253     mapping (address => uint256) _balances;
254     mapping (address => mapping (address => uint256)) _allowances;
255     mapping (address => uint256) lastSell;
256     mapping (address => uint256) lastSellAmount;
257 
258     mapping (address => bool) isFeeExempt;
259     mapping (address => bool) isTxLimitExempt;
260 
261     uint256 marketingFee = 40;
262     uint256 marketingSellFee = 40;
263     uint256 liquidityFee = 20;
264     uint256 liquiditySellFee = 20;
265     uint256 totalBuyFee = marketingFee + liquidityFee;
266     uint256 totalSellFee = marketingSellFee + liquiditySellFee;
267     uint256 feeDenominator = 1000;
268 
269     uint256 antiDumpTax = 200;
270     uint256 antiDumpPeriod = 30 minutes;
271     uint256 antiDumpThreshold = 21;
272     bool antiDumpReserve0 = true;
273 
274     address public constant liquidityReceiver = DEAD;
275     address payable public immutable marketingReceiver;
276 
277     uint256 targetLiquidity = 10;
278     uint256 targetLiquidityDenominator = 100;
279 
280     IDEXRouter public immutable router;
281     
282     address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
283 
284     mapping (address => bool) liquidityPools;
285     mapping (address => bool) liquidityProviders;
286 
287     address public pair;
288 
289     uint256 public launchedAt;
290     uint256 public launchedTime;
291     uint256 public deadBlocks;
292  
293     IAntiSnipe public antisnipe;
294     bool public protectionEnabled = false;
295     bool public protectionDisabled = false;
296 
297     bool public swapEnabled = true;
298     uint256 public swapThreshold = _totalSupply / 400; //0.25%
299     uint256 public swapMinimum = _totalSupply / 10000; //0.01%
300     uint256 public maxSwapPercent = 75;
301 
302     uint256 public unlocksAt;
303     address public locker;
304 
305     mapping (address => bool) public whitelist;
306     bool public whitelistEnabled = true;
307 
308     bool inSwap;
309     modifier swapping() { inSwap = true; _; inSwap = false; }
310 
311     constructor (address _liquidityProvider, address _marketingWallet) {
312         marketingReceiver = payable(_marketingWallet);
313 
314         router = IDEXRouter(routerAddress);
315         _allowances[_liquidityProvider][routerAddress] = type(uint256).max;
316         _allowances[address(this)][routerAddress] = type(uint256).max;
317         
318         isFeeExempt[_liquidityProvider] = true;
319         liquidityProviders[_liquidityProvider] = true;
320 
321         isTxLimitExempt[address(this)] = true;
322         isTxLimitExempt[_liquidityProvider] = true;
323         isTxLimitExempt[routerAddress] = true;
324 
325         _balances[_liquidityProvider] = _totalSupply;
326         emit Transfer(address(0), _liquidityProvider, _totalSupply);
327     }
328 
329     receive() external payable { }
330 
331     function totalSupply() external view override returns (uint256) { return _totalSupply; }
332     function decimals() external pure returns (uint8) { return _decimals; }
333     function symbol() external pure returns (string memory) { return _symbol; }
334     function name() external pure returns (string memory) { return _name; }
335     function getOwner() external view returns (address) { return owner(); }
336     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
337     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
338 
339     function approve(address spender, uint256 amount) public override returns (bool) {
340         _approve(msg.sender, spender, amount);
341         return true;
342     }
343 
344     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
345         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
346         return true;
347     }
348 
349     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
350         uint256 currentAllowance = _allowances[msg.sender][spender];
351         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below address(0)");
352         unchecked {
353             _approve(msg.sender, spender, currentAllowance - subtractedValue);
354         }
355 
356         return true;
357     }
358 
359     function _approve(address owner, address spender, uint256 amount) internal virtual {
360         require(owner != address(0), "ERC20: approve from the address(0) address");
361         require(spender != address(0), "ERC20: approve to the address(0) address");
362 
363         _allowances[owner][spender] = amount;
364         emit Approval(owner, spender, amount);
365     }
366 
367     function approveMax(address spender) external returns (bool) {
368         return approve(spender, type(uint256).max);
369     }
370 
371     function transfer(address recipient, uint256 amount) external override returns (bool) {
372         return _transferFrom(msg.sender, recipient, amount);
373     }
374 
375     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
376         if(_allowances[sender][msg.sender] != type(uint256).max){
377             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
378         }
379 
380         return _transferFrom(sender, recipient, amount);
381     }
382 
383     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
384         require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
385         require(amount > 0, "No tokens transferred");
386         require(sender != address(0), "ERC20: transfer from the zero address");
387         require(recipient != address(0), "ERC20: transfer to the zero address");
388 
389         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
390 
391         checkTxLimit(sender, amount);
392         
393         if (!liquidityPools[recipient] && recipient != DEAD) {
394             if (!isTxLimitExempt[recipient]) checkWalletLimit(recipient, amount);
395         }
396 
397         if(!launched()){ require(liquidityProviders[sender] || liquidityProviders[recipient] || (whitelistEnabled && whitelist[recipient]), "Contract not launched yet."); }
398 
399         if(!liquidityPools[sender] && shouldTakeFee(sender) && _balances[sender] - amount == 0) {
400             amount -= 1;
401         }
402 
403         _balances[sender] -= amount;
404 
405         uint256 amountReceived = shouldTakeFee(sender) && shouldTakeFee(recipient) ? takeFee(sender, recipient, amount) : amount;
406         
407         if(shouldSwapBack(sender, recipient)){ if (amount > 0) swapBack(amount); }
408         
409         if(recipient != DEAD)
410             _balances[recipient] += amountReceived;
411         else
412             _totalSupply -= amountReceived;
413             
414         if (launched() && protectionEnabled && shouldTakeFee(sender))
415             antisnipe.onPreTransferCheck(msg.sender, sender, recipient, amount);
416 
417         emit Transfer(sender, (recipient != DEAD ? recipient : address(0)), amountReceived);
418         return true;
419     }
420 
421     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
422         _balances[sender] -= amount;
423         _balances[recipient] += amount;
424         emit Transfer(sender, recipient, amount);
425         return true;
426     }
427     
428     function checkWalletLimit(address recipient, uint256 amount) internal view {
429         require(_balances[recipient] + amount <= getMaximumWallet(), "Transfer amount exceeds the bag size.");
430     }
431 
432     function checkTxLimit(address sender, uint256 amount) internal view {
433         require(amount <= getTransactionLimit() || isTxLimitExempt[sender], "TX Limit Exceeded");
434     }
435 
436     function shouldTakeFee(address sender) internal view returns (bool) {
437         return !isFeeExempt[sender];
438     }
439 
440     function getTotalFee(bool selling) public view returns (uint256) {
441         if(launchedAt + deadBlocks > block.number){ return feeDenominator - 1; }
442         return (selling ? totalSellFee : totalBuyFee);
443     }
444 
445     function checkImpactEstimate(uint256 amount) public view returns (uint256) {
446         (uint112 reserve0, uint112 reserve1,) = IDEXPair(pair).getReserves();
447         return amount * 1000 / ((antiDumpReserve0 ? reserve0 : reserve1) + amount);
448     }
449 
450     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
451         uint256 feeAmount = 0;
452         if(liquidityPools[recipient] && antiDumpTax > 0) {
453             uint256 impactEstimate = checkImpactEstimate(amount);
454             
455             if (block.timestamp > lastSell[sender] + antiDumpPeriod) {
456                 lastSell[sender] = block.timestamp;
457                 lastSellAmount[sender] = 0;
458             }
459             
460             lastSellAmount[sender] += impactEstimate;
461             
462             if (lastSellAmount[sender] >= antiDumpThreshold) {
463                 feeAmount = ((amount * totalSellFee * antiDumpTax) / 100) / feeDenominator;
464             }
465         }
466 
467         if (feeAmount == 0)
468             feeAmount = (amount * getTotalFee(liquidityPools[recipient])) / feeDenominator;
469 
470         _balances[address(this)] += feeAmount;
471         emit Transfer(sender, address(this), feeAmount);
472 
473         return amount - feeAmount;
474     }
475 
476     function shouldSwapBack(address sender, address recipient) internal view returns (bool) {
477         return !liquidityPools[sender]
478         && !isFeeExempt[sender]
479         && !inSwap
480         && swapEnabled
481         && liquidityPools[recipient]
482         && _balances[address(this)] >= swapMinimum &&
483         totalBuyFee + totalSellFee > 0;
484     }
485 
486     function swapBack(uint256 amount) internal swapping {
487         uint256 totalFee = totalBuyFee + totalSellFee;
488         uint256 amountToSwap = amount - (amount * maxSwapPercent / 100) < swapThreshold ? amount * maxSwapPercent / 100 : swapThreshold;
489         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
490         
491         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee + liquiditySellFee;
492         uint256 amountToLiquify = ((amountToSwap * dynamicLiquidityFee) / totalFee) / 2;
493         amountToSwap -= amountToLiquify;
494 
495         address[] memory path = new address[](2);
496         path[0] = address(this);
497         path[1] = router.WETH();
498         
499         //Guaranteed swap desired to prevent trade blockages
500         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
501             amountToSwap,
502             0,
503             path,
504             address(this),
505             block.timestamp
506         );
507 
508         uint256 contractBalance = address(this).balance;
509         uint256 totalETHFee = totalFee - dynamicLiquidityFee / 2;
510 
511         uint256 amountLiquidity = (contractBalance * dynamicLiquidityFee) / totalETHFee / 2;
512         uint256 amountMarketing = contractBalance - amountLiquidity;
513 
514         if(amountToLiquify > 0) {
515             //Guaranteed swap desired to prevent trade blockages, return values ignored
516             router.addLiquidityETH{value: amountLiquidity}(
517                 address(this),
518                 amountToLiquify,
519                 0,
520                 0,
521                 liquidityReceiver,
522                 block.timestamp
523             );
524             emit AutoLiquify(amountLiquidity, amountToLiquify);
525         }
526         
527         if (amountMarketing > 0) {
528             (bool sentMarketing, ) = marketingReceiver.call{value: amountMarketing}("");
529             if(!sentMarketing) {
530                 //Failed to transfer to marketing wallet
531             }
532         }
533     }
534 
535     function launched() internal view returns (bool) {
536         return launchedAt != 0;
537     }
538 
539     function getCirculatingSupply() public view returns (uint256) {
540         return _totalSupply - (balanceOf(DEAD) + balanceOf(address(0)));
541     }
542 
543     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
544         return (accuracy * balanceOf(pair)) / getCirculatingSupply();
545     }
546 
547     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
548         return getLiquidityBacking(accuracy) > target;
549     }
550 
551     function transferOwnership(address newOwner) public virtual override onlyOwner {
552         require(owner() == _msgSender(), "Caller is not authorized");
553         isFeeExempt[owner()] = false;
554         isTxLimitExempt[owner()] = false;
555         liquidityProviders[owner()] = false;
556         _allowances[owner()][routerAddress] = 0;
557         super.transferOwnership(newOwner);
558     }
559 
560     function lockContract(uint256 _weeks) external onlyOwner {
561         require(locker == address(0), "Contract already locked");
562         require(_weeks > 0, "No lock period specified");
563         unlocksAt = block.timestamp + (_weeks * 1 weeks);
564         locker = owner();
565         super.renounceOwnership();
566     }
567 
568     function unlockContract() external {
569         require(locker != address(0) && (msg.sender == locker || liquidityProviders[msg.sender]), "Caller is not authorized");
570         require(unlocksAt <= block.timestamp, "Contract still locked");
571         super.transferOwnership(locker);
572         locker = address(0);
573         unlocksAt = 0;
574     }
575 
576     function renounceOwnership() public virtual override onlyOwner {
577         isFeeExempt[owner()] = false;
578         isTxLimitExempt[owner()] = false;
579         liquidityProviders[owner()] = false;
580         _allowances[owner()][routerAddress] = 0;
581         super.renounceOwnership();
582     }
583 
584     function _checkOwner() internal view virtual override {
585         require(owner() != address(0) && (owner() == _msgSender() || liquidityProviders[_msgSender()]), "Ownable: caller is not authorized");
586     }
587 
588     function setProtectionEnabled(bool _protect) external onlyOwner {
589         if (_protect)
590             require(!protectionDisabled, "Protection disabled");
591         protectionEnabled = _protect;
592         emit ProtectionToggle(_protect);
593     }
594     
595     function setProtection(address _protection, bool _call) external onlyOwner {
596         if (_protection != address(antisnipe)){
597             require(!protectionDisabled, "Protection disabled");
598             antisnipe = IAntiSnipe(_protection);
599         }
600         if (_call)
601             antisnipe.setTokenOwner(address(this), pair);
602         
603         emit ProtectionSet(_protection);
604     }
605     
606     function disableProtection() external onlyOwner {
607         protectionDisabled = true;
608         emit ProtectionDisabled();
609     }
610     
611     function setLiquidityProvider(address _provider, bool _set) external onlyOwner {
612         require(_provider != pair && _provider != routerAddress, "Can't alter trading contracts in this manner.");
613         isFeeExempt[_provider] = _set;
614         liquidityProviders[_provider] = _set;
615         isTxLimitExempt[_provider] = _set;
616         emit LiquidityProviderSet(_provider, _set);
617     }
618 
619     function extractETH() external onlyOwner {
620         uint256 bal = balanceOf(address(this));
621             if(bal > 0) {
622             (bool sent, ) = msg.sender.call{value: bal}("");
623                 require(sent,"Failed to transfer funds");
624         }
625     }
626 
627     function setAntiDumpTax(uint256 _tax, uint256 _period, uint256 _threshold, bool _reserve0) external onlyOwner {
628         require(_threshold >= 10 && _tax <= 300 && (_tax == 0 || _tax >= 100) && _period <= 1 hours, "Parameters out of bounds");
629         antiDumpTax = _tax;
630         antiDumpPeriod = _period;
631         antiDumpThreshold = _threshold;
632         antiDumpReserve0 = _reserve0;
633         emit AntiDumpTaxSet(_tax, _period, _threshold);
634     }
635 
636     function launch(uint256 _deadBlocks, bool _whitelistMode) external payable onlyOwner {
637         require(launchedAt == 0 && _deadBlocks < 7);
638         require(msg.value > 0, "Insufficient funds");
639         uint256 toLP = msg.value;
640 
641         IDEXFactory factory = IDEXFactory(router.factory());
642         address ETH = router.WETH();
643 
644         pair = factory.getPair(ETH, address(this));
645         if(pair == address(0))
646             pair = factory.createPair(ETH, address(this));
647 
648         liquidityPools[pair] = true;
649         isFeeExempt[address(this)] = true;
650         liquidityProviders[address(this)] = true;
651 
652         router.addLiquidityETH{value: toLP}(address(this),balanceOf(address(this)),0,0,msg.sender,block.timestamp);
653 
654         whitelistEnabled = _whitelistMode;
655 
656         if (!_whitelistMode) {
657             deadBlocks = _deadBlocks;
658             launchedAt = block.number;
659             launchedTime = block.timestamp;
660             emit TradingLaunched();
661         }
662     }
663 
664     function endWhitelist(uint256 _deadBlocks) external onlyOwner {
665         require(!launched() && _deadBlocks < 7);
666         deadBlocks = _deadBlocks;
667         whitelistEnabled = false;
668         launchedAt = block.number;
669         launchedTime = block.timestamp;
670         emit TradingLaunched();
671     }
672 
673     function updateWhitelist(address[] calldata _addresses, bool _enabled) external onlyOwner {
674         require(whitelistEnabled, "Whitelist disabled");
675         for (uint256 i = 0; i < _addresses.length; i++) {
676             whitelist[_addresses[i]] = _enabled;
677         }
678     }
679 
680     function setTxLimit(uint256 thousandths) external onlyOwner {
681         require(thousandths > 0 , "Transaction limits too low");
682         _maxTxAmount = thousandths;
683         emit TransactionLimitSet(getTransactionLimit());
684     }
685 
686     function getTransactionLimit() public view returns (uint256) {
687         if(!launched()) return 0;
688         return getCirculatingSupply() * _maxTxAmount / 1000;
689     }
690     
691     function setMaxWallet(uint256 thousandths) external onlyOwner() {
692         require(thousandths > 1, "Wallet limits too low");
693         _maxWalletSize = thousandths;
694         emit MaxWalletSet(getMaximumWallet());
695     }
696 
697     function getMaximumWallet() public view returns (uint256) {
698         if(!launched()) return 0;
699         return getCirculatingSupply() * _maxWalletSize / 1000;
700     }
701 
702     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
703         require(holder != address(0), "Invalid address");
704         isFeeExempt[holder] = exempt;
705         emit FeeExemptSet(holder, exempt);
706     }
707 
708     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
709         require(holder != address(0), "Invalid address");
710         isTxLimitExempt[holder] = exempt;
711         emit TrasactionLimitExemptSet(holder, exempt);
712     }
713 
714     function setFees(uint256 _liquidityFee, uint256 _liquiditySellFee, uint256 _marketingFee, uint256 _marketingSellFee, uint256 _feeDenominator) external onlyOwner {
715         require((_liquidityFee / 2) * 2 == _liquidityFee, "Liquidity fee must be an even number due to rounding");
716         require((_liquiditySellFee / 2) * 2 == _liquiditySellFee, "Liquidity fee must be an even number due to rounding");
717         liquidityFee = _liquidityFee;
718         liquiditySellFee = _liquiditySellFee;
719         marketingFee = _marketingFee;
720         marketingSellFee = _marketingSellFee;
721         totalBuyFee = _liquidityFee + _marketingFee;
722         totalSellFee = _liquiditySellFee + _marketingSellFee;
723         feeDenominator = _feeDenominator;
724         require(totalBuyFee + totalSellFee <= feeDenominator / 5, "Fees too high");
725         emit FeesSet(totalBuyFee, totalSellFee, feeDenominator);
726     }
727 
728     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _denominatorMin) external onlyOwner {
729         require(_denominator > 0 && _denominatorMin > 0, "Denominators must be greater than 0");
730         swapEnabled = _enabled;
731         swapMinimum = _totalSupply / _denominatorMin;
732         swapThreshold = _totalSupply / _denominator;
733         emit SwapSettingsSet(swapMinimum, swapThreshold, swapEnabled);
734     }
735 
736     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
737         targetLiquidity = _target;
738         targetLiquidityDenominator = _denominator;
739         emit TargetLiquiditySet(_target * 100 / _denominator);
740     }
741 
742     function addLiquidityPool(address _pool, bool _enabled) external onlyOwner {
743         require(_pool != address(0), "Invalid address");
744         liquidityPools[_pool] = _enabled;
745         emit LiquidityPoolSet(_pool, _enabled);
746     }
747 
748 	function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
749     {
750         require(_addresses.length == _amount.length, "Array lengths don't match");
751         bool previousSwap = swapEnabled;
752         swapEnabled = false;
753         //This function may run out of gas intentionally to prevent partial airdrops
754         for (uint256 i = 0; i < _addresses.length; i++) {
755             require(!liquidityPools[_addresses[i]] && _addresses[i] != address(0), "Can't airdrop the liquidity pool or address 0");
756             _transferFrom(msg.sender, _addresses[i], _amount[i] * (10 ** _decimals));
757         }
758         swapEnabled = previousSwap;
759         emit AirdropSent(msg.sender);
760     }
761 
762     event AutoLiquify(uint256 amount, uint256 amountToken);
763     event ProtectionSet(address indexed protection);
764     event ProtectionDisabled();
765     event LiquidityProviderSet(address indexed provider, bool isSet);
766     event TradingLaunched();
767     event TransactionLimitSet(uint256 limit);
768     event MaxWalletSet(uint256 limit);
769     event FeeExemptSet(address indexed wallet, bool isExempt);
770     event TrasactionLimitExemptSet(address indexed wallet, bool isExempt);
771     event FeesSet(uint256 totalBuyFees, uint256 totalSellFees, uint256 denominator);
772     event SwapSettingsSet(uint256 minimum, uint256 maximum, bool enabled);
773     event LiquidityPoolSet(address indexed pool, bool enabled);
774     event AirdropSent(address indexed from);
775     event AntiDumpTaxSet(uint256 rate, uint256 period, uint256 threshold);
776     event TargetLiquiditySet(uint256 percent);
777     event ProtectionToggle(bool isEnabled);
778 }