1 /**
2  *Submitted for verification at BscScan.com on 2022-08-26
3 */
4 
5 // File: ShadowFiToken.sol
6 
7 /**
8                                                                                                                                                                                               
9 Don't Know Your Customer (DKYC) is the first anonymous cryptocurrency credit card built for Decentralized Finance (DeFi). 
10 Seamlessly connecting Smart Chain investing with real-world spending. 
11 | Website: https://dontkyc.com
12 | Telegram: https://t.me/DontKYC
13 | Twitter: https://twitter.com/DontKYC
14 */
15 
16 //SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.8.4;
19 
20 /**
21  * Standard SafeMath, stripped down to just add/sub/mul/div
22  */
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27 
28         return c;
29     }
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36 
37         return c;
38     }
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46 
47         return c;
48     }
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 }
61 
62 /**
63  * BEP20 standard interface.
64  */
65 interface IBEP20 {
66     function totalSupply() external view returns (uint256);
67     function decimals() external view returns (uint8);
68     function symbol() external view returns (string memory);
69     function name() external view returns (string memory);
70     function getOwner() external view returns (address);
71     function balanceOf(address account) external view returns (uint256);
72     function transfer(address recipient, uint256 amount) external returns (bool);
73     function allowance(address _owner, address spender) external view returns (uint256);
74     function approve(address spender, uint256 amount) external returns (bool);
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IDEXFactory {
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 }
83 
84 interface IDEXRouter {
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87 
88     function addLiquidity(
89         address tokenA,
90         address tokenB,
91         uint amountADesired,
92         uint amountBDesired,
93         uint amountAMin,
94         uint amountBMin,
95         address to,
96         uint deadline
97     ) external returns (uint amountA, uint amountB, uint liquidity);
98 
99     function addLiquidityETH(
100         address token,
101         uint amountTokenDesired,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
107 
108     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115 
116     function swapExactETHForTokensSupportingFeeOnTransferTokens(
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external payable;
122 
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130 }
131 
132 enum Permission {
133     ChangeFees,
134     Buyback,
135     AdjustContractVariables,
136     Authorize,
137     Unauthorize,
138     LockPermissions,
139     ExcludeInclude
140 }
141 
142 /**
143  * Allows for contract ownership along with multi-address authorization for different permissions
144  */
145 abstract contract ShadowAuth {
146     struct PermissionLock {
147         bool isLocked;
148         uint64 expiryTime;
149     }
150 
151     address public owner;
152     mapping(address => mapping(uint256 => bool)) private authorizations; // uint256 is permission index
153     
154     uint256 constant NUM_PERMISSIONS = 10; // always has to be adjusted when Permission element is added or removed
155     mapping(string => uint256) permissionNameToIndex;
156     mapping(uint256 => string) permissionIndexToName;
157 
158     mapping(uint256 => PermissionLock) lockedPermissions;
159 
160     constructor(address owner_) {
161         owner = owner_;
162         for (uint256 i; i < NUM_PERMISSIONS; i++) {
163             authorizations[owner_][i] = true;
164         }
165 
166         permissionNameToIndex["ChangeFees"] = uint256(Permission.ChangeFees);
167         permissionNameToIndex["Buyback"] = uint256(Permission.Buyback);
168         permissionNameToIndex["AdjustContractVariables"] = uint256(Permission.AdjustContractVariables);
169         permissionNameToIndex["Authorize"] = uint256(Permission.Authorize);
170         permissionNameToIndex["Unauthorize"] = uint256(Permission.Unauthorize);
171         permissionNameToIndex["LockPermissions"] = uint256(Permission.LockPermissions);
172         permissionNameToIndex["ExcludeInclude"] = uint256(Permission.ExcludeInclude);
173 
174         permissionIndexToName[uint256(Permission.ChangeFees)] = "ChangeFees";
175         permissionIndexToName[uint256(Permission.Buyback)] = "Buyback";
176         permissionIndexToName[uint256(Permission.AdjustContractVariables)] = "AdjustContractVariables";
177         permissionIndexToName[uint256(Permission.Authorize)] = "Authorize";
178         permissionIndexToName[uint256(Permission.Unauthorize)] = "Unauthorize";
179         permissionIndexToName[uint256(Permission.LockPermissions)] = "LockPermissions";
180         permissionIndexToName[uint256(Permission.ExcludeInclude)] = "ExcludeInclude";
181     }
182 
183     /**
184      * Function modifier to require caller to be contract owner
185      */
186     modifier onlyOwner() {
187         require(isOwner(msg.sender), "Ownership required."); _;
188     }
189 
190     /**
191      * Function modifier to require caller to be authorized
192      */
193     modifier authorizedFor(Permission permission) {
194         require(!lockedPermissions[uint256(permission)].isLocked, "Permission is locked.");
195         require(isAuthorizedFor(msg.sender, permission), string(abi.encodePacked("Not authorized. You need the permission ", permissionIndexToName[uint256(permission)]))); _;
196     }
197 
198     /**
199      * Authorize address for one permission
200      */
201     function authorizeFor(address adr, string memory permissionName) public authorizedFor(Permission.Authorize) {
202         uint256 permIndex = permissionNameToIndex[permissionName];
203         authorizations[adr][permIndex] = true;
204         emit AuthorizedFor(adr, permissionName, permIndex);
205     }
206 
207     /**
208      * Authorize address for multiple permissions
209      */
210     function authorizeForMultiplePermissions(address adr, string[] calldata permissionNames) public authorizedFor(Permission.Authorize) {
211         for (uint256 i; i < permissionNames.length; i++) {
212             uint256 permIndex = permissionNameToIndex[permissionNames[i]];
213             authorizations[adr][permIndex] = true;
214             emit AuthorizedFor(adr, permissionNames[i], permIndex);
215         }
216     }
217 
218     /**
219      * Remove address' authorization
220      */
221     function unauthorizeFor(address adr, string memory permissionName) public authorizedFor(Permission.Unauthorize) {
222         require(adr != owner, "Can't unauthorize owner");
223 
224         uint256 permIndex = permissionNameToIndex[permissionName];
225         authorizations[adr][permIndex] = false;
226         emit UnauthorizedFor(adr, permissionName, permIndex);
227     }
228 
229     /**
230      * Unauthorize address for multiple permissions
231      */
232     function unauthorizeForMultiplePermissions(address adr, string[] calldata permissionNames) public authorizedFor(Permission.Unauthorize) {
233         require(adr != owner, "Can't unauthorize owner");
234 
235         for (uint256 i; i < permissionNames.length; i++) {
236             uint256 permIndex = permissionNameToIndex[permissionNames[i]];
237             authorizations[adr][permIndex] = false;
238             emit UnauthorizedFor(adr, permissionNames[i], permIndex);
239         }
240     }
241 
242     /**
243      * Check if address is owner
244      */
245     function isOwner(address account) public view returns (bool) {
246         return account == owner;
247     }
248 
249     /**
250      * Return address' authorization status
251      */
252     function isAuthorizedFor(address adr, string memory permissionName) public view returns (bool) {
253         return authorizations[adr][permissionNameToIndex[permissionName]];
254     }
255 
256     /**
257      * Return address' authorization status
258      */
259     function isAuthorizedFor(address adr, Permission permission) public view returns (bool) {
260         return authorizations[adr][uint256(permission)];
261     }
262 
263     /**
264      * Transfer ownership to new address. Caller must be owner.
265      */
266     function transferOwnership(address payable adr) public onlyOwner {
267         address oldOwner = owner;
268         owner = adr;
269         for (uint256 i; i < NUM_PERMISSIONS; i++) {
270             authorizations[oldOwner][i] = false;
271             authorizations[owner][i] = true;
272         }
273         emit OwnershipTransferred(oldOwner, owner);
274     }
275 
276     /**
277      * Get the index of the permission by its name
278      */
279     function getPermissionNameToIndex(string memory permissionName) public view returns (uint256) {
280         return permissionNameToIndex[permissionName];
281     }
282     
283     /**
284      * Get the time the timelock expires
285      */
286     function getPermissionUnlockTime(string memory permissionName) public view returns (uint256) {
287         return lockedPermissions[permissionNameToIndex[permissionName]].expiryTime;
288     }
289 
290     /**
291      * Check if the permission is locked
292      */
293     function isLocked(string memory permissionName) public view returns (bool) {
294         return lockedPermissions[permissionNameToIndex[permissionName]].isLocked;
295     }
296 
297     /*
298      *Locks the permission from being used for the amount of time provided
299      */
300     function lockPermission(string memory permissionName, uint64 time) public virtual authorizedFor(Permission.LockPermissions) {
301         uint256 permIndex = permissionNameToIndex[permissionName];
302         uint64 expiryTime = uint64(block.timestamp) + time;
303         lockedPermissions[permIndex] = PermissionLock(true, expiryTime);
304         emit PermissionLocked(permissionName, permIndex, expiryTime);
305     }
306     
307     /*
308      * Unlocks the permission if the lock has expired 
309      */
310     function unlockPermission(string memory permissionName) public virtual {
311         require(block.timestamp > getPermissionUnlockTime(permissionName) , "Permission is locked until the expiry time.");
312         uint256 permIndex = permissionNameToIndex[permissionName];
313         lockedPermissions[permIndex].isLocked = false;
314         emit PermissionUnlocked(permissionName, permIndex);
315     }
316 
317     event PermissionLocked(string permissionName, uint256 permissionIndex, uint64 expiryTime);
318     event PermissionUnlocked(string permissionName, uint256 permissionIndex);
319     event OwnershipTransferred(address from, address to);
320     event AuthorizedFor(address adr, string permissionName, uint256 permissionIndex);
321     event UnauthorizedFor(address adr, string permissionName, uint256 permissionIndex);
322 }
323 
324 interface IDividendDistributor {
325     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
326     function setShare(address shareholder, uint256 amount) external;
327     function deposit() external payable;
328     function process(uint256 gas) external;
329     function claimDividend() external;
330 }
331 
332 contract DividendDistributor is IDividendDistributor {
333     using SafeMath for uint256;
334 
335     address _token;
336 
337     struct Share {
338         uint256 amount;
339         uint256 totalExcluded;
340         uint256 totalRealised;
341     }
342 
343     IBEP20 BUSD = IBEP20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
344     address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
345     IDEXRouter router;
346 
347     address[] shareholders;
348     mapping (address => uint256) shareholderIndexes;
349     mapping (address => uint256) shareholderClaims;
350 
351     mapping (address => Share) public shares;
352 
353     uint256 public totalShares;
354     uint256 public totalDividends;
355     uint256 public totalDistributed;
356     uint256 public dividendsPerShare;
357     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
358 
359     uint256 public minPeriod = 1 hours; // min 1 hour delay
360     uint256 public minDistribution = 1 * (10 ** 18); // 1 BUSD minimum auto send
361 
362     uint256 currentIndex;
363 
364     bool initialized;
365     modifier initialization() {
366         require(!initialized);
367         _;
368         initialized = true;
369     }
370 
371     modifier onlyToken() {
372         require(msg.sender == _token); _;
373     }
374 
375     constructor (address _router) {
376         router = _router != address(0)
377             ? IDEXRouter(_router)
378             : IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
379         _token = msg.sender;
380     }
381 
382     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {
383         minPeriod = _minPeriod;
384         minDistribution = _minDistribution;
385     }
386 
387     function setShare(address shareholder, uint256 amount) external override onlyToken {
388         if(shares[shareholder].amount > 0){
389             distributeDividend(shareholder);
390         }
391 
392         if(amount > 0 && shares[shareholder].amount == 0){
393             addShareholder(shareholder);
394         }else if(amount == 0 && shares[shareholder].amount > 0){
395             removeShareholder(shareholder);
396         }
397 
398         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
399         shares[shareholder].amount = amount;
400         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
401     }
402 
403     function deposit() external payable override onlyToken {
404         uint256 balanceBefore = BUSD.balanceOf(address(this));
405 
406         address[] memory path = new address[](2);
407         path[0] = WBNB;
408         path[1] = address(BUSD);
409 
410         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
411             0,
412             path,
413             address(this),
414             block.timestamp
415         );
416 
417         uint256 amount = BUSD.balanceOf(address(this)).sub(balanceBefore);
418 
419         totalDividends = totalDividends.add(amount);
420         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
421     }
422 
423     function process(uint256 gas) external override onlyToken {
424         uint256 shareholderCount = shareholders.length;
425 
426         if(shareholderCount == 0) { return; }
427 
428         uint256 gasUsed = 0;
429         uint256 gasLeft = gasleft();
430 
431         uint256 iterations = 0;
432 
433         while(gasUsed < gas && iterations < shareholderCount) {
434             if(currentIndex >= shareholderCount){
435                 currentIndex = 0;
436             }
437 
438             if(shouldDistribute(shareholders[currentIndex])){
439                 distributeDividend(shareholders[currentIndex]);
440             }
441 
442             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
443             gasLeft = gasleft();
444             currentIndex++;
445             iterations++;
446         }
447     }
448     
449     function shouldDistribute(address shareholder) internal view returns (bool) {
450         return shareholderClaims[shareholder] + minPeriod < block.timestamp
451                 && getUnpaidEarnings(shareholder) > minDistribution;
452     }
453 
454     function distributeDividend(address shareholder) internal {
455         if(shares[shareholder].amount == 0){ return; }
456 
457         uint256 amount = getUnpaidEarnings(shareholder);
458         if(amount > 0){
459             totalDistributed = totalDistributed.add(amount);
460             BUSD.transfer(shareholder, amount);
461             shareholderClaims[shareholder] = block.timestamp;
462             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
463             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
464         }
465     }
466     
467     function claimDividend() external override {
468         distributeDividend(msg.sender);
469     }
470 
471     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
472         if(shares[shareholder].amount == 0){ return 0; }
473 
474         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
475         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
476 
477         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
478 
479         return shareholderTotalDividends.sub(shareholderTotalExcluded);
480     }
481 
482     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
483         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
484     }
485 
486     function addShareholder(address shareholder) internal {
487         shareholderIndexes[shareholder] = shareholders.length;
488         shareholders.push(shareholder);
489     }
490 
491     function removeShareholder(address shareholder) internal {
492         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
493         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
494         shareholders.pop();
495     }
496 }
497 
498 contract ShadowFi is IBEP20, ShadowAuth {
499     using SafeMath for uint256;
500 
501     address BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
502     address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
503     address DEAD = 0x000000000000000000000000000000000000dEaD;
504     address ZERO = 0x0000000000000000000000000000000000000000;
505 
506     string constant _name = "ShadowFi";
507     string constant _symbol = "SDF";
508     uint8 constant _decimals = 9;
509 
510     uint256 _totalSupply = 10 ** 8 * (10 ** _decimals);
511     uint256 _maxSupply = 10 ** 8 * (10 ** _decimals);
512     uint256 public _maxTxAmount = _maxSupply / 1000; // 0.1%
513 
514     mapping (address => uint256) _balances;
515     mapping (address => mapping (address => uint256)) _allowances;
516 
517     mapping (address => bool) isFeeExempt;
518     mapping (address => bool) isTxLimitExempt;
519     mapping (address => bool) isDividendExempt;
520     mapping (address => bool) allowedAddresses;
521     mapping(address => bool) private airdropped; // airdropped addresses
522     mapping(address => bool) private blackList;
523 
524     uint256 liquidityFee = 200;
525     uint256 buybackFee = 0;
526     uint256 reflectionFee = 200;
527     uint256 marketingFee = 200;
528     uint256 totalBuyFee = 600;
529     uint256 totalSellFee = 600;
530     uint256 feeDenominator = 10000;
531 
532     address public autoLiquidityReceiver;
533     address public marketingFeeReceiver;
534 
535     uint256 targetLiquidity = 20;
536     uint256 targetLiquidityDenominator = 100;
537 
538     IDEXRouter public router;
539     address pancakeV2BNBPair;
540     address[] public pairs;
541 
542     uint256 public launchedAt;
543 
544     uint256 buybackMultiplierNumerator = 150;
545     uint256 buybackMultiplierDenominator = 100;
546     uint256 buybackMultiplierTriggeredAt;
547     uint256 buybackMultiplierLength = 30 minutes;
548 
549     bool public feesOnNormalTransfers = false;
550 
551     DividendDistributor distributor;
552     uint256 distributorGas = 500000;
553 
554     bool public swapEnabled = true;
555     uint256 public swapThreshold = _totalSupply / 5000; // 0.02%
556     bool inSwap;
557     modifier swapping() { inSwap = true; _; inSwap = false; }
558 
559     uint256 transferBlockTime;
560 
561     constructor (uint256 _transferBlockTime) ShadowAuth(msg.sender) {
562         router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
563         pancakeV2BNBPair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
564         _allowances[address(this)][address(router)] = ~uint256(0);
565 
566         pairs.push(pancakeV2BNBPair);
567         distributor = new DividendDistributor(address(router));
568 
569         address owner_ = msg.sender;
570         allowedAddresses[owner_] = true;
571 
572         isFeeExempt[owner_] = true;
573         isTxLimitExempt[owner_] = true;
574         isDividendExempt[pancakeV2BNBPair] = true;
575         isDividendExempt[address(this)] = true;
576         isFeeExempt[address(this)] = true;
577         isTxLimitExempt[address(this)] = true;
578         isDividendExempt[DEAD] = true;
579 
580         autoLiquidityReceiver = owner_;
581         marketingFeeReceiver = owner_;
582 
583         transferBlockTime = _transferBlockTime;
584 
585         _balances[owner_] = _totalSupply;
586         emit Transfer(address(0), owner_, _totalSupply);
587     }
588 
589     receive() external payable { }
590 
591     function totalSupply() external view override returns (uint256) { return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO)); }
592     function decimals() external pure override returns (uint8) { return _decimals; }
593     function symbol() external pure override returns (string memory) { return _symbol; }
594     function name() external pure override returns (string memory) { return _name; }
595     function getOwner() external view override returns (address) { return owner; }
596     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
597     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
598 
599     function approve(address spender, uint256 amount) public override returns (bool) {
600         if (!allowedAddresses[msg.sender]) {
601             require(block.timestamp > transferBlockTime, "Transfers have not been enabled yet.");
602         }
603 
604         require(!blackList[msg.sender], "You are a bad boy!");
605 
606         _allowances[msg.sender][spender] = amount;
607         emit Approval(msg.sender, spender, amount);
608         return true;
609     }
610 
611     function approveMax(address spender) external returns (bool) {
612         return approve(spender, ~uint256(0));
613     }
614 
615     function transfer(address recipient, uint256 amount) external override returns (bool) {
616         return _transferFrom(msg.sender, recipient, amount);
617     }
618 
619     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
620         if(_allowances[sender][msg.sender] != ~uint256(0)){
621             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
622         }
623 
624         return _transferFrom(sender, recipient, amount);
625     }
626 
627     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
628         if (!allowedAddresses[msg.sender] && !allowedAddresses[recipient]) {
629             require(block.timestamp > transferBlockTime, "Transfers have not been enabled yet.");
630         }
631        
632        require(!blackList[sender] && !blackList[recipient], "Either the spender or recipient is blacklisted.");
633 
634         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
635         
636         checkTxLimit(sender, amount);
637 
638         if(shouldSwapBack()){ swapBack(); }
639 
640         if(!launched() && recipient == pancakeV2BNBPair){ require(_balances[sender] > 0); launch(); }
641 
642         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
643 
644         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
645         _balances[recipient] = _balances[recipient].add(amountReceived);
646 
647         if(!isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
648         if(!isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
649 
650         try distributor.process(distributorGas) {} catch {}
651 
652         emit Transfer(sender, recipient, amountReceived);
653         return true;
654     }
655     
656     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
657         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
658         _balances[recipient] = _balances[recipient].add(amount);
659         emit Transfer(sender, recipient, amount);
660         return true;
661     }
662 
663     function checkTxLimit(address sender, uint256 amount) internal view {
664         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
665     }
666 
667     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
668         if (isFeeExempt[sender] || isFeeExempt[recipient] || !launched()) return false;
669 
670         address[] memory liqPairs = pairs;
671 
672         for (uint256 i = 0; i < liqPairs.length; i++) {
673             if (sender == liqPairs[i] || recipient == liqPairs[i]) return true;
674         }
675 
676         return feesOnNormalTransfers;
677     }
678 
679     function getTotalFee(bool selling) public view returns (uint256) {
680         if(launchedAt + 1 >= block.number){ return feeDenominator.sub(1); }
681         if(selling && buybackMultiplierTriggeredAt.add(buybackMultiplierLength) > block.timestamp){ return getMultipliedFee(); }
682         return selling ? totalSellFee : totalBuyFee;
683     }
684 
685     function getMultipliedFee() public view returns (uint256) {
686         uint totalFee = totalSellFee;
687         uint256 remainingTime = buybackMultiplierTriggeredAt.add(buybackMultiplierLength).sub(block.timestamp);
688         uint256 feeIncrease = totalFee.mul(buybackMultiplierNumerator).div(buybackMultiplierDenominator).sub(totalFee);
689         return totalFee.add(feeIncrease.mul(remainingTime).div(buybackMultiplierLength));
690     }
691 
692     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
693         uint256 feeAmount = amount.mul(getTotalFee(isSell(recipient))).div(feeDenominator);
694 
695         _balances[address(this)] = _balances[address(this)].add(feeAmount);
696         emit Transfer(sender, address(this), feeAmount);
697 
698         return amount.sub(feeAmount);
699     }
700         
701     function isSell(address recipient) internal view returns (bool) {
702         address[] memory liqPairs = pairs;
703         for (uint256 i = 0; i < liqPairs.length; i++) {
704             if (recipient == liqPairs[i]) return true;
705         }
706         return false;
707     }
708 
709     function shouldSwapBack() internal view returns (bool) {
710         return msg.sender != pancakeV2BNBPair
711         && !inSwap
712         && swapEnabled
713         && _balances[address(this)] >= swapThreshold;
714     }
715 
716     function swapBack() internal swapping {
717         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
718         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalBuyFee).div(2);
719         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
720 
721         address[] memory path = new address[](2);
722         path[0] = address(this);
723         path[1] = WBNB;
724 
725         uint256 balanceBefore = address(this).balance;
726 
727         try router.swapExactTokensForETHSupportingFeeOnTransferTokens(
728             amountToSwap,
729             0,
730             path,
731             address(this),
732             block.timestamp
733         ) {
734 
735             uint256 amountBNB = address(this).balance.sub(balanceBefore);
736 
737             uint256 totalBNBFee = totalBuyFee.sub(dynamicLiquidityFee.div(2));
738 
739             uint256 amountBNBLiquidity = amountBNB.mul(dynamicLiquidityFee).div(totalBNBFee).div(2);
740             uint256 amountBNBReflection = amountBNB.mul(reflectionFee).div(totalBNBFee);
741             uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div(totalBNBFee);
742 
743             try distributor.deposit{value: amountBNBReflection}() {} catch {}
744             payable(marketingFeeReceiver).call{value: amountBNBMarketing, gas: 30000}("");
745 
746             if(amountToLiquify > 0){
747                 try router.addLiquidityETH{ value: amountBNBLiquidity }(
748                     address(this),
749                     amountToLiquify,
750                     0,
751                     0,
752                     autoLiquidityReceiver,
753                     block.timestamp
754                 ) {
755                     emit AutoLiquify(amountToLiquify, amountBNBLiquidity);
756                 } catch {
757                     emit AutoLiquify(0, 0);
758                 }
759             }
760 
761             emit SwapBackSuccess(amountToSwap);
762         } catch Error(string memory e) {
763             emit SwapBackFailed(string(abi.encodePacked("SwapBack failed with error ", e)));
764         } catch {
765             emit SwapBackFailed("SwapBack failed without an error message from pancakeSwap");
766         }
767     }
768 
769     function triggerBuyback(uint256 amount, bool triggerBuybackMultiplier) external authorizedFor(Permission.Buyback) {
770         // buyTokens(amount, DEAD);
771         burn(msg.sender, amount);
772         if(triggerBuybackMultiplier){
773             buybackMultiplierTriggeredAt = block.timestamp;
774             emit BuybackMultiplierActive(buybackMultiplierLength);
775         }
776     }
777     
778     function clearBuybackMultiplier() external authorizedFor(Permission.Buyback) {
779         buybackMultiplierTriggeredAt = 0;
780     }
781 
782     function buyTokens(uint256 amount, address to) internal swapping {
783         address[] memory path = new address[](2);
784         path[0] = WBNB;
785         path[1] = address(this);
786 
787         try router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: amount }(
788             0,
789             path,
790             to,
791             block.timestamp
792         ) {
793             emit BoughtBack(amount, to);
794         } catch Error(string memory reason) {
795             revert(string(abi.encodePacked("Buyback failed with error ", reason)));
796         } catch {
797             revert("Buyback failed without an error message from pancakeSwap");
798         }
799     }
800 
801     function setBuybackMultiplierSettings(uint256 numerator, uint256 denominator, uint256 length) external authorizedFor(Permission.AdjustContractVariables) {
802         require(numerator / denominator <= 3 && numerator > denominator);
803         buybackMultiplierNumerator = numerator;
804         buybackMultiplierDenominator = denominator;
805         buybackMultiplierLength = length;
806     }
807 
808     function launched() internal view returns (bool) {
809         return launchedAt != 0;
810     }
811 
812     function launch() internal {
813         launchedAt = block.number;
814         emit Launched(block.number, block.timestamp);
815     }
816 
817     function setTxLimit(uint256 amount) external authorizedFor(Permission.AdjustContractVariables) {
818         require(amount >= _totalSupply / 2000);
819         _maxTxAmount = amount;
820     }
821 
822     function setIsDividendExempt(address holder, bool exempt) external authorizedFor(Permission.ExcludeInclude) {
823         require(holder != address(this) && holder != pancakeV2BNBPair);
824         
825         isDividendExempt[holder] = exempt;
826         if(exempt){
827             distributor.setShare(holder, 0);
828         }else{
829             distributor.setShare(holder, _balances[holder]);
830         }
831     }
832 
833     function setIsFeeExempt(address holder, bool exempt) external authorizedFor(Permission.ExcludeInclude) {
834         isFeeExempt[holder] = exempt;
835     }
836 
837     function setIsTxLimitExempt(address holder, bool exempt) external authorizedFor(Permission.ExcludeInclude) {
838         isTxLimitExempt[holder] = exempt;
839     }
840 
841     function setFees(uint256 _liquidityFee, uint256 _buybackFee, uint256 _reflectionFee, uint256 _marketingFee, uint256 _feeDenominator, uint256 _totalSellFee) external authorizedFor(Permission.AdjustContractVariables) {
842         liquidityFee = _liquidityFee;
843         buybackFee = _buybackFee;
844         reflectionFee = _reflectionFee;
845         marketingFee = _marketingFee;
846         totalBuyFee = _liquidityFee.add(_buybackFee).add(_reflectionFee).add(_marketingFee);
847         feeDenominator = _feeDenominator;
848         totalSellFee = _totalSellFee;
849         require(totalBuyFee <= feeDenominator / 10, "Buy fee too high");
850         require(totalSellFee <= feeDenominator / 5, "Sell fee too high");
851     }
852 
853     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver) external authorizedFor(Permission.AdjustContractVariables) {
854         autoLiquidityReceiver = _autoLiquidityReceiver;
855         marketingFeeReceiver = _marketingFeeReceiver;
856     }
857 
858     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorizedFor(Permission.AdjustContractVariables) {
859         swapEnabled = _enabled;
860         swapThreshold = _amount;
861     }
862 
863     function setTargetLiquidity(uint256 _target, uint256 _denominator) external authorizedFor(Permission.AdjustContractVariables) {
864         targetLiquidity = _target;
865         targetLiquidityDenominator = _denominator;
866     }
867 
868     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorizedFor(Permission.AdjustContractVariables) {
869         distributor.setDistributionCriteria(_minPeriod, _minDistribution);
870     }
871 
872     function setDistributorSettings(uint256 gas) external authorizedFor(Permission.AdjustContractVariables) {
873         require(gas <= 1000000);
874         distributorGas = gas;
875     }
876     
877     function getCirculatingSupply() public view returns (uint256) {
878         return _maxSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
879     }
880 
881     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
882         return accuracy.mul(balanceOf(pancakeV2BNBPair).mul(2)).div(getCirculatingSupply());
883     }
884 
885     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
886         return getLiquidityBacking(accuracy) > target;
887     }
888 
889     function claimDividend() external {
890         distributor.claimDividend();
891     }
892     
893     function addPair(address pair) external authorizedFor(Permission.AdjustContractVariables) {
894         pairs.push(pair);
895     }
896     
897     function removeLastPair() external authorizedFor(Permission.AdjustContractVariables) {
898         pairs.pop();
899     }
900     
901     function setFeesOnNormalTransfers(bool _enabled) external authorizedFor(Permission.AdjustContractVariables) {
902         feesOnNormalTransfers = _enabled;
903     }
904 
905     function setLaunchedAt(uint256 launched_) external authorizedFor(Permission.AdjustContractVariables) {
906         launchedAt = launched_;
907     }
908 
909     /*******************************************************************************************************/
910     /************************************* Added Functions *************************************************/
911     /*******************************************************************************************************/
912     function setAllowedAddress(address user, bool flag) external onlyOwner {
913         allowedAddresses[user] = flag;
914     }
915 
916     function burn(address account, uint256 _amount) public {
917         _transferFrom(account, DEAD, _amount);
918 
919         emit burnTokens(account, _amount);
920     }
921 
922     function airdrop(address _user, uint256 _amount) external onlyOwner {
923         _transferFrom(msg.sender, _user, _amount);
924         airdropped[_user] = true;
925 
926         emit airdropTokens(_user, _amount);
927     }
928 
929     function isAirdropped(address account) external view returns (bool) {
930         return airdropped[account];
931     }
932 
933     function setBlackListed(address user, bool flag) external onlyOwner {
934         blackList[user] = flag;
935     }
936 
937     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
938     event BuybackMultiplierActive(uint256 duration);
939     event BoughtBack(uint256 amount, address to);
940     event Launched(uint256 blockNumber, uint256 timestamp);
941     event SwapBackSuccess(uint256 amount);
942     event SwapBackFailed(string message);
943     event burnTokens(address account, uint256 amount);
944     event airdropTokens(address user, uint256 amount);
945 }