1 // Kabosu 2.0 (Japanese: かぼす) is a female Shiba Inu most famously known as the face of Doge.
2 // ██████  ███████ ██    ██  ██████  ██      ██    ██ 
3 // COPYRIGHT © 2023 ALL RIGHTS RESERVED BY KABOSU 2.0
4 // ██████  ███████ ██    ██  ██████  ██      ██    ██ 
5 // Website: https://kabosu2.fun/
6 // Telegram:https://t.me/Kabosu2ERC
7 // Twitter: https://twitter.com/Kabuso2ERC
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.18;
11 
12 /********************************************************************************************
13   INTERFACE
14 ********************************************************************************************/
15 
16 interface IERC20 {
17     
18     // EVENT 
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24     // FUNCTION
25 
26     function name() external view returns (string memory);
27     
28     function symbol() external view returns (string memory);
29     
30     function decimals() external view returns (uint8);
31     
32     function totalSupply() external view returns (uint256);
33     
34     function balanceOf(address account) external view returns (uint256);
35     
36     function transfer(address to, uint256 amount) external returns (bool);
37     
38     function allowance(address owner, address spender) external view returns (uint256);
39     
40     function approve(address spender, uint256 amount) external returns (bool);
41     
42     function transferFrom(address from, address to, uint256 amount) external returns (bool);
43 }
44 
45 interface IFactory {
46 
47     // FUNCTION
48 
49     function createPair(address tokenA, address tokenB) external returns (address pair);
50 }
51 
52 interface IRouter {
53 
54     // FUNCTION
55 
56     function WETH() external pure returns (address);
57         
58     function factory() external pure returns (address);
59 
60     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
61     
62     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
63 }
64 
65 interface IAuthError {
66 
67     // ERROR
68 
69     error InvalidOwner(address account);
70 
71     error UnauthorizedAccount(address account);
72 
73     error InvalidAuthorizedAccount(address account);
74 
75     error CurrentAuthorizedState(address account, bool state);
76 }
77 
78 interface ICommonError {
79 
80     // ERROR
81 
82     error CannotUseCurrentAddress(address current);
83 
84     error CannotUseCurrentValue(uint256 current);
85 
86     error CannotUseCurrentState(bool current);
87 
88     error InvalidAddress(address invalid);
89 
90     error InvalidValue(uint256 invalid);
91 }
92 
93 /********************************************************************************************
94   ACCESS
95 ********************************************************************************************/
96 
97 abstract contract Auth is IAuthError {
98     
99     // DATA
100 
101     address private _owner;
102 
103     // MAPPING
104 
105     mapping(address => bool) public authorization;
106 
107     // MODIFIER
108 
109     modifier onlyOwner() {
110         _checkOwner();
111         _;
112     }
113 
114     modifier authorized() {
115         _checkAuthorized();
116         _;
117     }
118 
119     // CONSTRUCCTOR
120 
121     constructor(address initialOwner) {
122         _transferOwnership(initialOwner);
123         authorize(initialOwner);
124         if (initialOwner != msg.sender) {
125             authorize(msg.sender);
126         }
127     }
128 
129     // EVENT
130     
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     event UpdateAuthorizedAccount(address authorizedAccount, address caller, bool state, uint256 timestamp);
134 
135     // FUNCTION
136     
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     function _checkOwner() internal view virtual {
142         if (owner() != msg.sender) {
143             revert UnauthorizedAccount(msg.sender);
144         }
145     }
146 
147     function _checkAuthorized() internal view virtual {
148         if (!authorization[msg.sender]) {
149             revert UnauthorizedAccount(msg.sender);
150         }
151     }
152 
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         if (newOwner == address(0)) {
159             revert InvalidOwner(address(0));
160         }
161         _transferOwnership(newOwner);
162     }
163 
164     function authorize(address account) public virtual onlyOwner {
165         if (account == address(0) || account == address(0xdead)) {
166             revert InvalidAuthorizedAccount(account);
167         }
168         _authorization(account, msg.sender, true);
169     }
170 
171     function unauthorize(address account) public virtual onlyOwner {
172         if (account == address(0) || account == address(0xdead)) {
173             revert InvalidAuthorizedAccount(account);
174         }
175         _authorization(account, msg.sender, false);
176     }
177 
178     function _transferOwnership(address newOwner) internal virtual {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 
184     function _authorization(address account, address caller, bool state) internal virtual {
185         if (authorization[account] == state) {
186             revert CurrentAuthorizedState(account, state);
187         }
188         authorization[account] = state;
189         emit UpdateAuthorizedAccount(account, caller, state, block.timestamp);
190     }
191 }
192 
193 /********************************************************************************************
194   SECURITY
195 ********************************************************************************************/
196 
197 abstract contract Pausable {
198 
199     // DATA
200 
201     bool private _paused;
202 
203     // ERROR
204 
205     error EnforcedPause();
206 
207     error ExpectedPause();
208 
209     // MODIFIER
210 
211     modifier whenNotPaused() {
212         _requireNotPaused();
213         _;
214     }
215 
216     modifier whenPaused() {
217         _requirePaused();
218         _;
219     }
220 
221     // CONSTRUCTOR
222 
223     constructor() {
224         _paused = false;
225     }
226 
227     // EVENT
228     
229     event Paused(address account);
230 
231     event Unpaused(address account);
232 
233     // FUNCTION
234 
235     function paused() public view virtual returns (bool) {
236         return _paused;
237     }
238 
239     function pause() external virtual whenNotPaused {
240         _pause();
241     }
242 
243     function unpause() external virtual whenPaused {
244         _unpause();
245     }
246 
247     function _requireNotPaused() internal view virtual {
248         if (paused()) {
249             revert EnforcedPause();
250         }
251     }
252 
253     function _requirePaused() internal view virtual {
254         if (!paused()) {
255             revert ExpectedPause();
256         }
257     }
258 
259     function _pause() internal virtual whenNotPaused {
260         _paused = true;
261         emit Paused(msg.sender);
262     }
263 
264     function _unpause() internal virtual whenPaused {
265         _paused = false;
266         emit Unpaused(msg.sender);
267     }
268 }
269 
270 /********************************************************************************************
271   TOKEN
272 ********************************************************************************************/
273 
274 contract Kabosu2 is Auth, ICommonError, IERC20 {
275 
276     // DATA
277 
278     IRouter public router;
279 
280     string private constant NAME = "Kabosu 2.0";
281     string private constant SYMBOL = "Kabosu2.0";
282 
283     uint8 private constant DECIMALS = 18;
284 
285     uint256 private _totalSupply;
286     
287     uint256 public constant FEEDENOMINATOR = 10_000;
288 
289     uint256 public buyDevelopmentFee = 200;
290     uint256 public sellDevelopmentFee = 200;
291     uint256 public transferDevelopmentFee = 0;
292     uint256 public developmentFeeCollected = 0;
293     uint256 public totalFeeCollected = 0;
294     uint256 public developmentFeeRedeemed = 0;
295     uint256 public totalFeeRedeemed = 0;
296     uint256 public minSwap = 100 ether;
297 
298     bool private constant ISKABOSU2 = true;
299 
300     bool public isFeeActive = false;
301     bool public isFeeLocked = false;
302     bool public isSwapEnabled = false;
303     bool public inSwap = false;
304     
305     address public constant ZERO = address(0);
306     address public constant DEAD = address(0xdead);
307 
308     address public developmentReceiver = 0xA828314168403eFd76E65209938cEfF1a431b0F5;
309     
310     address public pair;
311     
312     // MAPPING
313 
314     mapping(address => uint256) private _balances;
315     mapping(address => mapping(address => uint256)) private _allowances;
316     mapping(address => bool) public isExcludeFromFees;
317 
318     // MODIFIER
319 
320     modifier swapping() {
321         inSwap = true;
322         _;
323         inSwap = false;
324     }
325 
326     // ERROR
327 
328     error InvalidTotalFee(uint256 current, uint256 max);
329 
330     error InvalidFeeActiveState(bool current);
331 
332     error InvalidSwapEnabledState(bool current);
333 
334     error FeeLocked();
335 
336     // CONSTRUCTOR
337 
338     constructor(
339         address routerAddress,
340         address projectOwnerAddress
341     ) Auth (msg.sender) {
342         _mint(msg.sender, 420_690_000_000_000 * 10**DECIMALS);
343         if (projectOwnerAddress == ZERO) { revert InvalidAddress(projectOwnerAddress); }
344 
345         router = IRouter(routerAddress);
346         pair = IFactory(router.factory()).createPair(address(this), router.WETH());
347 
348         isExcludeFromFees[msg.sender] = true;
349         isExcludeFromFees[address(router)] = true;
350     }
351 
352     // EVENT
353 
354     event UpdateRouter(address oldRouter, address newRouter, address caller, uint256 timestamp);
355 
356     event UpdateMinSwap(uint256 oldMinSwap, uint256 newMinSwap, address caller, uint256 timestamp);
357 
358     event UpdateFeeActive(bool oldStatus, bool newStatus, address caller, uint256 timestamp);
359 
360     event UpdateBuyFee(uint256 oldBuyDevelopmentFee, uint256 newBuyDevelopmentFee, address caller, uint256 timestamp);
361 
362     event UpdateSellFee(uint256 oldSellDevelopmentFee, uint256 newSellDevelopmentFee, address caller, uint256 timestamp);
363 
364     event UpdateTransferFee(uint256 oldTransferDevelopmentFee, uint256 newTransferDevelopmentFee, address caller, uint256 timestamp);
365 
366     event UpdateSwapEnabled(bool oldStatus, bool newStatus, address caller, uint256 timestamp);
367 
368     event UpdateDevelopmentReceiver(address oldDevelopmentReceiver, address newDevelopmentReceiver, address caller, uint256 timestamp);
369         
370     event AutoRedeem(uint256 developmentFeeDistribution, uint256 amountToRedeem, address caller, uint256 timestamp);
371 
372     // FUNCTION
373 
374     /* General */
375 
376     receive() external payable {}
377 
378     function finalizePresale() external authorized {
379         if (isFeeActive) { revert InvalidFeeActiveState(isFeeActive); }
380         if (isSwapEnabled) { revert InvalidSwapEnabledState(isSwapEnabled); }
381         isFeeActive = true;
382         isSwapEnabled = true;
383     }
384 
385     function lockFees() external onlyOwner {
386         if (isFeeLocked) { revert FeeLocked(); }
387         isFeeLocked = true;
388     }
389 
390     /* Redeem */
391 
392     function redeemAllDevelopmentFee() external {
393         uint256 amountToRedeem = developmentFeeCollected - developmentFeeRedeemed;
394         
395         _redeemDevelopmentFee(amountToRedeem);
396     }
397 
398     function redeemPartialDevelopmentFee(uint256 amountToRedeem) external {
399         require(amountToRedeem <= developmentFeeCollected - developmentFeeRedeemed, "Redeem Partial Development Fee: Insufficient development fee collected.");
400         
401         _redeemDevelopmentFee(amountToRedeem);
402     }
403 
404     function _redeemDevelopmentFee(uint256 amountToRedeem) internal swapping { 
405         developmentFeeRedeemed += amountToRedeem;
406         totalFeeRedeemed += amountToRedeem;
407  
408         address[] memory path = new address[](2);
409         path[0] = address(this);
410         path[1] = router.WETH();
411 
412         _approve(address(this), address(router), amountToRedeem);
413 
414         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
415             amountToRedeem,
416             0,
417             path,
418             developmentReceiver,
419             block.timestamp
420         );
421     }
422 
423     function autoRedeem(uint256 amountToRedeem) public swapping {  
424         uint256 developmentToRedeem = developmentFeeCollected - developmentFeeRedeemed;
425         uint256 totalToRedeem = totalFeeCollected - totalFeeRedeemed;
426 
427         uint256 developmentFeeDistribution = amountToRedeem * developmentToRedeem / totalToRedeem;
428         
429         developmentFeeRedeemed += developmentFeeDistribution;
430         totalFeeRedeemed += amountToRedeem;
431 
432         address[] memory path = new address[](2);
433         path[0] = address(this);
434         path[1] = router.WETH();
435 
436         _approve(address(this), address(router), amountToRedeem);
437     
438         emit AutoRedeem(developmentFeeDistribution, amountToRedeem, msg.sender, block.timestamp);
439 
440         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
441             developmentFeeDistribution,
442             0,
443             path,
444             developmentReceiver,
445             block.timestamp
446         );
447     }
448 
449     /* Check */
450 
451     function isKabosu2() external pure returns (bool) {
452         return ISKABOSU2;
453     }
454 
455     function circulatingSupply() external view returns (uint256) {
456         return totalSupply() - balanceOf(DEAD) - balanceOf(ZERO);
457     }
458 
459     /* Update */
460 
461     function updateRouter(address newRouter) external onlyOwner {
462         if (address(router) == newRouter) { revert CannotUseCurrentAddress(newRouter); }
463         address oldRouter = address(router);
464         router = IRouter(newRouter);
465         
466         isExcludeFromFees[newRouter] = true;
467 
468         emit UpdateRouter(oldRouter, newRouter, msg.sender, block.timestamp);
469         pair = IFactory(router.factory()).createPair(address(this), router.WETH());
470     }
471 
472     function updateMinSwap(uint256 newMinSwap) external onlyOwner {
473         if (minSwap == newMinSwap) { revert CannotUseCurrentValue(newMinSwap); }
474         uint256 oldMinSwap = minSwap;
475         minSwap = newMinSwap;
476         emit UpdateMinSwap(oldMinSwap, newMinSwap, msg.sender, block.timestamp);
477     }
478 
479     function updateBuyFee(uint256 newDevelopmentFee) external onlyOwner {
480         if (isFeeLocked) { revert FeeLocked(); }
481         if (newDevelopmentFee > 210) { revert InvalidTotalFee(newDevelopmentFee, 210); }
482         uint256 oldDevelopmentFee = buyDevelopmentFee;
483         buyDevelopmentFee = newDevelopmentFee;
484         emit UpdateBuyFee(oldDevelopmentFee, newDevelopmentFee, msg.sender, block.timestamp);
485     }
486 
487     function updateSellFee(uint256 newDevelopmentFee) external onlyOwner {
488         if (isFeeLocked) { revert FeeLocked(); }
489         if (newDevelopmentFee > 210) { revert InvalidTotalFee(newDevelopmentFee, 210); }
490         uint256 oldDevelopmentFee = sellDevelopmentFee;
491         sellDevelopmentFee = newDevelopmentFee;
492         emit UpdateSellFee(oldDevelopmentFee, newDevelopmentFee, msg.sender, block.timestamp);
493     }
494 
495     function updateTransferFee(uint256 newDevelopmentFee) external onlyOwner {
496         if (isFeeLocked) { revert FeeLocked(); }
497         if (newDevelopmentFee > 210) { revert InvalidTotalFee(newDevelopmentFee, 210); }
498         uint256 oldDevelopmentFee = transferDevelopmentFee;
499         transferDevelopmentFee = newDevelopmentFee;
500         emit UpdateTransferFee(oldDevelopmentFee, newDevelopmentFee, msg.sender, block.timestamp);
501     }
502 
503     function updateFeeActive(bool newStatus) external authorized {
504         if (isFeeActive == newStatus) { revert CannotUseCurrentState(newStatus); }
505         bool oldStatus = isFeeActive;
506         isFeeActive = newStatus;
507         emit UpdateFeeActive(oldStatus, newStatus, msg.sender, block.timestamp);
508     }
509 
510     function updateSwapEnabled(bool newStatus) external authorized {
511         if (isSwapEnabled == newStatus) { revert CannotUseCurrentState(newStatus); }
512         bool oldStatus = isSwapEnabled;
513         isSwapEnabled = newStatus;
514         emit UpdateSwapEnabled(oldStatus, newStatus, msg.sender, block.timestamp);
515     }
516 
517     function updateDevelopmentReceiver(address newDevelopmentReceiver) external onlyOwner {
518         if (developmentReceiver == newDevelopmentReceiver) { revert CannotUseCurrentAddress(newDevelopmentReceiver); }
519         address oldDevelopmentReceiver = developmentReceiver;
520         developmentReceiver = newDevelopmentReceiver;
521         emit UpdateDevelopmentReceiver(oldDevelopmentReceiver, newDevelopmentReceiver, msg.sender, block.timestamp);
522     }
523 
524     function setExcludeFromFees(address user, bool status) external authorized {
525         if (isExcludeFromFees[user] == status) { revert CannotUseCurrentState(status); }
526         isExcludeFromFees[user] = status;
527     }
528 
529     /* Fee */
530 
531     function takeBuyFee(address from, uint256 amount) internal swapping returns (uint256) {
532         uint256 feeAmount = amount * buyDevelopmentFee / FEEDENOMINATOR;
533         uint256 newAmount = amount - feeAmount;
534         tallyBuyFee(from, feeAmount, buyDevelopmentFee);
535         return newAmount;
536     }
537 
538     function takeSellFee(address from, uint256 amount) internal swapping returns (uint256) {
539         uint256 feeAmount = amount * sellDevelopmentFee / FEEDENOMINATOR;
540         uint256 newAmount = amount - feeAmount;
541         tallySellFee(from, feeAmount, sellDevelopmentFee);
542         return newAmount;
543     }
544 
545     function takeTransferFee(address from, uint256 amount) internal swapping returns (uint256) {
546         uint256 feeAmount = amount * transferDevelopmentFee / FEEDENOMINATOR;
547         uint256 newAmount = amount - feeAmount;
548         tallyTransferFee(from, feeAmount, transferDevelopmentFee);
549         return newAmount;
550     }
551 
552     function tallyBuyFee(address from, uint256 amount, uint256 fee) internal swapping {
553         uint256 collectDevelopment = amount * buyDevelopmentFee / fee;
554         tallyCollection(collectDevelopment, amount);
555         
556         _balances[from] -= amount;
557         _balances[address(this)] += amount;
558     }
559 
560     function tallySellFee(address from, uint256 amount, uint256 fee) internal swapping {
561         uint256 collectDevelopment = amount * sellDevelopmentFee / fee;
562         tallyCollection(collectDevelopment, amount);
563         
564         _balances[from] -= amount;
565         _balances[address(this)] += amount;
566     }
567 
568     function tallyTransferFee(address from, uint256 amount, uint256 fee) internal swapping {
569         uint256 collectDevelopment = amount * transferDevelopmentFee / fee;
570         tallyCollection(collectDevelopment, amount);
571 
572         _balances[from] -= amount;
573         _balances[address(this)] += amount;
574     }
575 
576     function tallyCollection(uint256 collectDevelopment, uint256 amount) internal swapping {
577         developmentFeeCollected += collectDevelopment;
578         totalFeeCollected += amount;
579     }
580 
581     /* Buyback */
582 
583     function triggerZeusBuyback(uint256 amount) external authorized {
584         buyTokens(amount, DEAD);
585     }
586 
587     function buyTokens(uint256 amount, address to) internal swapping {
588         if (msg.sender == DEAD) { revert InvalidAddress(DEAD); }
589         address[] memory path = new address[](2);
590         path[0] = router.WETH();
591         path[1] = address(this);
592 
593         router.swapExactETHForTokensSupportingFeeOnTransferTokens{
594             value: amount
595         }(0, path, to, block.timestamp);
596     }
597 
598     /* ERC20 Standard */
599 
600     function name() external view virtual override returns (string memory) {
601         return NAME;
602     }
603     
604     function symbol() external view virtual override returns (string memory) {
605         return SYMBOL;
606     }
607     
608     function decimals() external view virtual override returns (uint8) {
609         return DECIMALS;
610     }
611     
612     function totalSupply() public view virtual override returns (uint256) {
613         return _totalSupply;
614     }
615     
616     function balanceOf(address account) public view virtual override returns (uint256) {
617         return _balances[account];
618     }
619     
620     function transfer(address to, uint256 amount) external virtual override returns (bool) {
621         address provider = msg.sender;
622         return _transfer(provider, to, amount);
623     }
624     
625     function allowance(address provider, address spender) public view virtual override returns (uint256) {
626         return _allowances[provider][spender];
627     }
628     
629     function approve(address spender, uint256 amount) public virtual override returns (bool) {
630         address provider = msg.sender;
631         _approve(provider, spender, amount);
632         return true;
633     }
634     
635     function transferFrom(address from, address to, uint256 amount) external virtual override returns (bool) {
636         address spender = msg.sender;
637         _spendAllowance(from, spender, amount);
638         return _transfer(from, to, amount);
639     }
640     
641     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
642         address provider = msg.sender;
643         _approve(provider, spender, allowance(provider, spender) + addedValue);
644         return true;
645     }
646     
647     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
648         address provider = msg.sender;
649         uint256 currentAllowance = allowance(provider, spender);
650         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
651         unchecked {
652             _approve(provider, spender, currentAllowance - subtractedValue);
653         }
654 
655         return true;
656     }
657     
658     function _mint(address account, uint256 amount) internal virtual {
659         if (account == ZERO) { revert InvalidAddress(account); }
660 
661         _totalSupply += amount;
662         unchecked {
663             _balances[account] += amount;
664         }
665         emit Transfer(address(0), account, amount);
666     }
667 
668     function _approve(address provider, address spender, uint256 amount) internal virtual {
669         if (provider == ZERO) { revert InvalidAddress(provider); }
670         if (spender == ZERO) { revert InvalidAddress(spender); }
671 
672         _allowances[provider][spender] = amount;
673         emit Approval(provider, spender, amount);
674     }
675     
676     function _spendAllowance(address provider, address spender, uint256 amount) internal virtual {
677         uint256 currentAllowance = allowance(provider, spender);
678         if (currentAllowance != type(uint256).max) {
679             require(currentAllowance >= amount, "ERC20: insufficient allowance");
680             unchecked {
681                 _approve(provider, spender, currentAllowance - amount);
682             }
683         }
684     }
685 
686     /* Additional */
687 
688     function _basicTransfer(address from, address to, uint256 amount ) internal returns (bool) {
689         uint256 fromBalance = _balances[from];
690         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
691         unchecked {
692             _balances[from] = fromBalance - amount;
693             _balances[to] += amount;
694         }
695 
696         emit Transfer(from, to, amount);
697         return true;
698     }
699     
700     /* Overrides */
701  
702     function _transfer(address from, address to, uint256 amount) internal virtual returns (bool) {
703         if (from == ZERO) { revert InvalidAddress(from); }
704         if (to == ZERO) { revert InvalidAddress(to); }
705 
706         if (inSwap || isExcludeFromFees[from]) {
707             return _basicTransfer(from, to, amount);
708         }
709 
710         if (from != pair && isSwapEnabled && totalFeeCollected - totalFeeRedeemed >= minSwap) {
711             autoRedeem(minSwap);
712         }
713 
714         uint256 newAmount = amount;
715 
716         if (isFeeActive && !isExcludeFromFees[from]) {
717             newAmount = _beforeTokenTransfer(from, to, amount);
718         }
719 
720         require(_balances[from] >= newAmount, "ERC20: transfer amount exceeds balance");
721         unchecked {
722             _balances[from] = _balances[from] - newAmount;
723             _balances[to] += newAmount;
724         }
725 
726         emit Transfer(from, to, newAmount);
727 
728         return true;
729     }
730 
731     function _beforeTokenTransfer(address from, address to, uint256 amount) internal swapping virtual returns (uint256) {
732         if (from == pair && (buyDevelopmentFee > 0)) {
733             return takeBuyFee(from, amount);
734         }
735         if (to == pair && (sellDevelopmentFee > 0)) {
736             return takeSellFee(from, amount);
737         }
738         if (from != pair && to != pair && (transferDevelopmentFee > 0)) {
739             return takeTransferFee(from, amount);
740         }
741         return amount;
742     }
743 }