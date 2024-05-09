1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.13;
3 
4 // Caution. We assume all failed transfers cause reverts and ignore the returned bool.
5 interface IERC20 {
6     function transfer(address,uint) external returns (bool);
7     function transferFrom(address,address,uint) external returns (bool);
8     function balanceOf(address) external view returns (uint);
9 }
10 
11 interface IOracle {
12     function getPrice(address,uint) external returns (uint);
13     function viewPrice(address,uint) external view returns (uint);
14 }
15 
16 interface IEscrow {
17     function initialize(IERC20 _token, address beneficiary) external;
18     function onDeposit() external;
19     function pay(address recipient, uint amount) external;
20     function balance() external view returns (uint);
21 }
22 
23 interface IDolaBorrowingRights {
24     function onBorrow(address user, uint additionalDebt) external;
25     function onRepay(address user, uint repaidDebt) external;
26     function onForceReplenish(address user, address replenisher, uint amount, uint replenisherReward) external;
27     function balanceOf(address user) external view returns (uint);
28     function deficitOf(address user) external view returns (uint);
29     function replenishmentPriceBps() external view returns (uint);
30 }
31 
32 interface IBorrowController {
33     function borrowAllowed(address msgSender, address borrower, uint amount) external returns (bool);
34     function onRepay(uint amount) external;
35 }
36 
37 contract Market {
38 
39     address public gov;
40     address public lender;
41     address public pauseGuardian;
42     address public immutable escrowImplementation;
43     IDolaBorrowingRights public immutable dbr;
44     IBorrowController public borrowController;
45     IERC20 public immutable dola = IERC20(0x865377367054516e17014CcdED1e7d814EDC9ce4);
46     IERC20 public immutable collateral;
47     IOracle public oracle;
48     uint public collateralFactorBps;
49     uint public replenishmentIncentiveBps;
50     uint public liquidationIncentiveBps;
51     uint public liquidationFeeBps;
52     uint public liquidationFactorBps = 5000; // 50% by default
53     bool immutable callOnDepositCallback;
54     bool public borrowPaused;
55     uint public totalDebt;
56     uint256 internal immutable INITIAL_CHAIN_ID;
57     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
58     mapping (address => IEscrow) public escrows; // user => escrow
59     mapping (address => uint) public debts; // user => debt
60     mapping(address => uint256) public nonces; // user => nonce
61 
62     constructor (
63         address _gov,
64         address _lender,
65         address _pauseGuardian,
66         address _escrowImplementation,
67         IDolaBorrowingRights _dbr,
68         IERC20 _collateral,
69         IOracle _oracle,
70         uint _collateralFactorBps,
71         uint _replenishmentIncentiveBps,
72         uint _liquidationIncentiveBps,
73         bool _callOnDepositCallback
74     ) {
75         require(_collateralFactorBps < 10000, "Invalid collateral factor");
76         require(_liquidationIncentiveBps > 0 && _liquidationIncentiveBps < 10000, "Invalid liquidation incentive");
77         require(_replenishmentIncentiveBps < 10000, "Replenishment incentive must be less than 100%");
78         gov = _gov;
79         lender = _lender;
80         pauseGuardian = _pauseGuardian;
81         escrowImplementation = _escrowImplementation;
82         dbr = _dbr;
83         collateral = _collateral;
84         oracle = _oracle;
85         collateralFactorBps = _collateralFactorBps;
86         replenishmentIncentiveBps = _replenishmentIncentiveBps;
87         liquidationIncentiveBps = _liquidationIncentiveBps;
88         callOnDepositCallback = _callOnDepositCallback;
89         INITIAL_CHAIN_ID = block.chainid;
90         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
91         if(collateralFactorBps > 0){
92             uint unsafeLiquidationIncentive = (10000 - collateralFactorBps) * (liquidationFeeBps + 10000) / collateralFactorBps;
93             require(liquidationIncentiveBps < unsafeLiquidationIncentive,  "Liquidation param allow profitable self liquidation");
94         }
95     }
96     
97     modifier onlyGov {
98         require(msg.sender == gov, "Only gov can call this function");
99         _;
100     }
101 
102     modifier liquidationParamChecker {
103         _;
104         if(collateralFactorBps > 0){
105             uint unsafeLiquidationIncentive = (10000 - collateralFactorBps) * (liquidationFeeBps + 10000) / collateralFactorBps;
106             require(liquidationIncentiveBps < unsafeLiquidationIncentive,  "New liquidation param allow profitable self liquidation");
107         }
108     }
109 
110     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
111         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
112     }
113 
114     function computeDomainSeparator() internal view virtual returns (bytes32) {
115         return
116             keccak256(
117                 abi.encode(
118                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
119                     keccak256(bytes("DBR MARKET")),
120                     keccak256("1"),
121                     block.chainid,
122                     address(this)
123                 )
124             );
125     }
126 
127     /**
128     @notice sets the oracle to a new oracle. Only callable by governance.
129     @param _oracle The new oracle conforming to the IOracle interface.
130     */
131     function setOracle(IOracle _oracle) public onlyGov { oracle = _oracle; }
132 
133     /**
134     @notice sets the borrow controller to a new borrow controller. Only callable by governance.
135     @param _borrowController The new borrow controller conforming to the IBorrowController interface.
136     */
137     function setBorrowController(IBorrowController _borrowController) public onlyGov { borrowController = _borrowController; }
138 
139     /**
140     @notice sets the address of governance. Only callable by governance.
141     @param _gov Address of the new governance.
142     */
143     function setGov(address _gov) public onlyGov { gov = _gov; }
144 
145     /**
146     @notice sets the lender to a new lender. The lender is allowed to recall dola from the contract. Only callable by governance.
147     @param _lender Address of the new lender.
148     */
149     function setLender(address _lender) public onlyGov { lender = _lender; }
150 
151     /**
152     @notice sets the pause guardian. The pause guardian can pause borrowing. Only callable by governance.
153     @param _pauseGuardian Address of the new pauseGuardian.
154     */
155     function setPauseGuardian(address _pauseGuardian) public onlyGov { pauseGuardian = _pauseGuardian; }
156     
157     /**
158     @notice sets the Collateral Factor requirement of the market as measured in basis points. 1 = 0.01%. Only callable by governance.
159     @dev Collateral factor mus be set below 100%
160     @param _collateralFactorBps The new collateral factor as measured in basis points. 
161     */
162     function setCollateralFactorBps(uint _collateralFactorBps) public onlyGov liquidationParamChecker {
163         require(_collateralFactorBps < 10000, "Invalid collateral factor");
164         collateralFactorBps = _collateralFactorBps;
165     }
166     
167     /**
168     @notice sets the Liquidation Factor of the market as denoted in basis points.
169      The liquidation Factor denotes the maximum amount of debt that can be liquidated in basis points.
170      At 5000, 50% of of a borrower's underwater debt can be liquidated. Only callable by governance.
171     @dev Must be set between 1 and 10000.
172     @param _liquidationFactorBps The new liquidation factor in basis points. 1 = 0.01%/
173     */
174     function setLiquidationFactorBps(uint _liquidationFactorBps) public onlyGov {
175         require(_liquidationFactorBps > 0 && _liquidationFactorBps <= 10000, "Invalid liquidation factor");
176         liquidationFactorBps = _liquidationFactorBps;
177     }
178 
179     /**
180     @notice sets the Replenishment Incentive of the market as denoted in basis points.
181      The Replenishment Incentive is the percentage paid out to replenishers on a successful forceReplenish call, denoted in basis points.
182     @dev Must be set between 1 and 10000.
183     @param _replenishmentIncentiveBps The new replenishment incentive set in basis points. 1 = 0.01%
184     */
185     function setReplenismentIncentiveBps(uint _replenishmentIncentiveBps) public onlyGov {
186         require(_replenishmentIncentiveBps > 0 && _replenishmentIncentiveBps < 10000, "Invalid replenishment incentive");
187         replenishmentIncentiveBps = _replenishmentIncentiveBps;
188     }
189 
190     /**
191     @notice sets the Liquidation Incentive of the market as denoted in basis points.
192      The Liquidation Incentive is the percentage paid out to liquidators of a borrower's debt when successfully liquidated.
193     @dev Must be set between 0 and 10000 - liquidation fee.
194     @param _liquidationIncentiveBps The new liqudation incentive set in basis points. 1 = 0.01% 
195     */
196     function setLiquidationIncentiveBps(uint _liquidationIncentiveBps) public onlyGov liquidationParamChecker {
197         require(_liquidationIncentiveBps > 0 && _liquidationIncentiveBps + liquidationFeeBps < 10000, "Invalid liquidation incentive");
198         liquidationIncentiveBps = _liquidationIncentiveBps;
199     }
200 
201     /**
202     @notice sets the Liquidation Fee of the market as denoted in basis points.
203      The Liquidation Fee is the percentage paid out to governance of a borrower's debt when successfully liquidated.
204     @dev Must be set between 0 and 10000 - liquidation factor.
205     @param _liquidationFeeBps The new liquidation fee set in basis points. 1 = 0.01%
206     */
207     function setLiquidationFeeBps(uint _liquidationFeeBps) public onlyGov liquidationParamChecker {
208         require(_liquidationFeeBps > 0 && _liquidationFeeBps + liquidationIncentiveBps < 10000, "Invalid liquidation fee");
209         liquidationFeeBps = _liquidationFeeBps;
210     }
211 
212     /**
213     @notice Recalls amount of DOLA to the lender.
214     @param amount The amount od DOLA to recall to the the lender.
215     */
216     function recall(uint amount) public {
217         require(msg.sender == lender, "Only lender can recall");
218         dola.transfer(msg.sender, amount);
219     }
220 
221     /**
222     @notice Pauses or unpauses borrowing for the market. Only gov can unpause a market, while gov and pauseGuardian can pause it.
223     @param _value Boolean representing the state pause state of borrows. true = paused, false = unpaused.
224     */
225     function pauseBorrows(bool _value) public {
226         if(_value) {
227             require(msg.sender == pauseGuardian || msg.sender == gov, "Only pause guardian or governance can pause");
228         } else {
229             require(msg.sender == gov, "Only governance can unpause");
230         }
231         borrowPaused = _value;
232     }
233 
234     /**
235     @notice Internal function for creating an escrow for users to deposit collateral in.
236     @dev Uses create2 and minimal proxies to create the escrow at a deterministic address
237     @param user The address of the user to create an escrow for.
238     */
239     function createEscrow(address user) internal returns (IEscrow instance) {
240         address implementation = escrowImplementation;
241         /// @solidity memory-safe-assembly
242         assembly {
243             let ptr := mload(0x40)
244             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
245             mstore(add(ptr, 0x14), shl(0x60, implementation))
246             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
247             instance := create2(0, ptr, 0x37, user)
248         }
249         require(instance != IEscrow(address(0)), "ERC1167: create2 failed");
250         emit CreateEscrow(user, address(instance));
251     }
252 
253     /**
254     @notice Internal function for getting the escrow of a user.
255     @dev If the escrow doesn't exist, an escrow contract is deployed.
256     @param user The address of the user owning the escrow.
257     */
258     function getEscrow(address user) internal returns (IEscrow) {
259         if(escrows[user] != IEscrow(address(0))) return escrows[user];
260         IEscrow escrow = createEscrow(user);
261         escrow.initialize(collateral, user);
262         escrows[user] = escrow;
263         return escrow;
264     }
265 
266     /**
267     @notice Deposit amount of collateral into escrow
268     @dev Will deposit the amount into the escrow contract.
269     @param amount Amount of collateral token to deposit.
270     */
271     function deposit(uint amount) public {
272         deposit(msg.sender, amount);
273     }
274 
275     /**
276     @notice Deposit and borrow in a single transaction.
277     @param amountDeposit Amount of collateral token to deposit into escrow.
278     @param amountBorrow Amount of DOLA to borrow.
279     */
280     function depositAndBorrow(uint amountDeposit, uint amountBorrow) public {
281         deposit(amountDeposit);
282         borrow(amountBorrow);
283     }
284 
285     /**
286     @notice Deposit amount of collateral into escrow on behalf of msg.sender
287     @dev Will deposit the amount into the escrow contract.
288     @param user User to deposit on behalf of.
289     @param amount Amount of collateral token to deposit.
290     */
291     function deposit(address user, uint amount) public {
292         IEscrow escrow = getEscrow(user);
293         collateral.transferFrom(msg.sender, address(escrow), amount);
294         if(callOnDepositCallback) {
295             escrow.onDeposit();
296         }
297         emit Deposit(user, amount);
298     }
299 
300     /**
301     @notice View function for predicting the deterministic escrow address of a user.
302     @dev Only use deposit() function for deposits and NOT the predicted escrow address unless you know what you're doing
303     @param user Address of the user owning the escrow.
304     */
305     function predictEscrow(address user) public view returns (IEscrow predicted) {
306         address implementation = escrowImplementation;
307         address deployer = address(this);
308         /// @solidity memory-safe-assembly
309         assembly {
310             let ptr := mload(0x40)
311             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
312             mstore(add(ptr, 0x14), shl(0x60, implementation))
313             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
314             mstore(add(ptr, 0x38), shl(0x60, deployer))
315             mstore(add(ptr, 0x4c), user)
316             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
317             predicted := keccak256(add(ptr, 0x37), 0x55)
318         }
319     }
320 
321     /**
322     @notice View function for getting the dollar value of the user's collateral in escrow for the market.
323     @param user Address of the user.
324     */
325     function getCollateralValue(address user) public view returns (uint) {
326         IEscrow escrow = predictEscrow(user);
327         uint collateralBalance = escrow.balance();
328         return collateralBalance * oracle.viewPrice(address(collateral), collateralFactorBps) / 1 ether;
329     }
330 
331     /**
332     @notice Internal function for getting the dollar value of the user's collateral in escrow for the market.
333     @dev Updates the lowest price comparisons of the pessimistic oracle
334     @param user Address of the user.
335     */
336     function getCollateralValueInternal(address user) internal returns (uint) {
337         IEscrow escrow = predictEscrow(user);
338         uint collateralBalance = escrow.balance();
339         return collateralBalance * oracle.getPrice(address(collateral), collateralFactorBps) / 1 ether;
340     }
341 
342     /**
343     @notice View function for getting the credit limit of a user.
344     @dev To calculate the available credit, subtract user debt from credit limit.
345     @param user Address of the user.
346     */
347     function getCreditLimit(address user) public view returns (uint) {
348         uint collateralValue = getCollateralValue(user);
349         return collateralValue * collateralFactorBps / 10000;
350     }
351 
352     /**
353     @notice Internal function for getting the credit limit of a user.
354     @dev To calculate the available credit, subtract user debt from credit limit. Updates the pessimistic oracle.
355     @param user Address of the user.
356     */
357     function getCreditLimitInternal(address user) internal returns (uint) {
358         uint collateralValue = getCollateralValueInternal(user);
359         return collateralValue * collateralFactorBps / 10000;
360     }
361     /**
362     @notice Internal function for getting the withdrawal limit of a user.
363      The withdrawal limit is how much collateral a user can withdraw before their loan would be underwater. Updates the pessimistic oracle.
364     @param user Address of the user.
365     */
366     function getWithdrawalLimitInternal(address user) internal returns (uint) {
367         IEscrow escrow = predictEscrow(user);
368         uint collateralBalance = escrow.balance();
369         if(collateralBalance == 0) return 0;
370         uint debt = debts[user];
371         if(debt == 0) return collateralBalance;
372         if(collateralFactorBps == 0) return 0;
373         uint minimumCollateral = debt * 1 ether / oracle.getPrice(address(collateral), collateralFactorBps) * 10000 / collateralFactorBps;
374         if(collateralBalance <= minimumCollateral) return 0;
375         return collateralBalance - minimumCollateral;
376     }
377 
378     /**
379     @notice View function for getting the withdrawal limit of a user.
380      The withdrawal limit is how much collateral a user can withdraw before their loan would be underwater.
381     @param user Address of the user.
382     */
383     function getWithdrawalLimit(address user) public view returns (uint) {
384         IEscrow escrow = predictEscrow(user);
385         uint collateralBalance = escrow.balance();
386         if(collateralBalance == 0) return 0;
387         uint debt = debts[user];
388         if(debt == 0) return collateralBalance;
389         if(collateralFactorBps == 0) return 0;
390         uint minimumCollateral = debt * 1 ether / oracle.viewPrice(address(collateral), collateralFactorBps) * 10000 / collateralFactorBps;
391         if(collateralBalance <= minimumCollateral) return 0;
392         return collateralBalance - minimumCollateral;
393     }
394 
395     /**
396     @notice Internal function for borrowing DOLA against collateral.
397     @dev This internal function is shared between the borrow and borrowOnBehalf function
398     @param borrower The address of the borrower that debt will be accrued to.
399     @param to The address that will receive the borrowed DOLA
400     @param amount The amount of DOLA to be borrowed
401     */
402     function borrowInternal(address borrower, address to, uint amount) internal {
403         require(!borrowPaused, "Borrowing is paused");
404         if(borrowController != IBorrowController(address(0))) {
405             require(borrowController.borrowAllowed(msg.sender, borrower, amount), "Denied by borrow controller");
406         }
407         uint credit = getCreditLimitInternal(borrower);
408         debts[borrower] += amount;
409         require(credit >= debts[borrower], "Exceeded credit limit");
410         totalDebt += amount;
411         dbr.onBorrow(borrower, amount);
412         dola.transfer(to, amount);
413         emit Borrow(borrower, amount);
414     }
415 
416     /**
417     @notice Function for borrowing DOLA.
418     @dev Will borrow to msg.sender
419     @param amount The amount of DOLA to be borrowed.
420     */
421     function borrow(uint amount) public {
422         borrowInternal(msg.sender, msg.sender, amount);
423     }
424 
425     /**
426     @notice Function for using a signed message to borrow on behalf of an address owning an escrow with collateral.
427     @dev Signed messaged can be invalidated by incrementing the nonce. Will always borrow to the msg.sender.
428     @param from The address of the user being borrowed from
429     @param amount The amount to be borrowed
430     @param deadline Timestamp after which the signed message will be invalid
431     @param v The v param of the ECDSA signature
432     @param r The r param of the ECDSA signature
433     @param s The s param of the ECDSA signature
434     */
435     function borrowOnBehalf(address from, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
436         require(deadline >= block.timestamp, "DEADLINE_EXPIRED");
437         unchecked {
438             address recoveredAddress = ecrecover(
439                 keccak256(
440                     abi.encodePacked(
441                         "\x19\x01",
442                         DOMAIN_SEPARATOR(),
443                         keccak256(
444                             abi.encode(
445                                 keccak256(
446                                     "BorrowOnBehalf(address caller,address from,uint256 amount,uint256 nonce,uint256 deadline)"
447                                 ),
448                                 msg.sender,
449                                 from,
450                                 amount,
451                                 nonces[from]++,
452                                 deadline
453                             )
454                         )
455                     )
456                 ),
457                 v,
458                 r,
459                 s
460             );
461             require(recoveredAddress != address(0) && recoveredAddress == from, "INVALID_SIGNER");
462             borrowInternal(from, msg.sender, amount);
463         }
464     }
465 
466     /**
467     @notice Internal function for withdrawing from the escrow
468     @dev The internal function is shared by the withdraw function and withdrawOnBehalf function
469     @param from The address owning the escrow to withdraw from.
470     @param to The address receiving the tokens
471     @param amount The amount being withdrawn.
472     */
473     function withdrawInternal(address from, address to, uint amount) internal {
474         uint limit = getWithdrawalLimitInternal(from);
475         require(limit >= amount, "Insufficient withdrawal limit");
476         require(dbr.deficitOf(from) == 0, "Can't withdraw with DBR deficit");
477         IEscrow escrow = getEscrow(from);
478         escrow.pay(to, amount);
479         emit Withdraw(from, to, amount);
480     }
481 
482     /**
483     @notice Function for withdrawing to msg.sender.
484     @param amount Amount to withdraw.
485     */
486     function withdraw(uint amount) public {
487         withdrawInternal(msg.sender, msg.sender, amount);
488     }
489 
490     /**
491     @notice Function for using a signed message to withdraw on behalf of an address owning an escrow with collateral.
492     @dev Signed messaged can be invalidated by incrementing the nonce. Will always withdraw to the msg.sender.
493     @param from The address of the user owning the escrow being withdrawn from
494     @param amount The amount to be withdrawn
495     @param deadline Timestamp after which the signed message will be invalid
496     @param v The v param of the ECDSA signature
497     @param r The r param of the ECDSA signature
498     @param s The s param of the ECDSA signature
499     */
500     function withdrawOnBehalf(address from, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
501         require(deadline >= block.timestamp, "DEADLINE_EXPIRED");
502         unchecked {
503             address recoveredAddress = ecrecover(
504                 keccak256(
505                     abi.encodePacked(
506                         "\x19\x01",
507                         DOMAIN_SEPARATOR(),
508                         keccak256(
509                             abi.encode(
510                                 keccak256(
511                                     "WithdrawOnBehalf(address caller,address from,uint256 amount,uint256 nonce,uint256 deadline)"
512                                 ),
513                                 msg.sender,
514                                 from,
515                                 amount,
516                                 nonces[from]++,
517                                 deadline
518                             )
519                         )
520                     )
521                 ),
522                 v,
523                 r,
524                 s
525             );
526             require(recoveredAddress != address(0) && recoveredAddress == from, "INVALID_SIGNER");
527             withdrawInternal(from, msg.sender, amount);
528         }
529     }
530 
531     /**
532     @notice Function for incrementing the nonce of the msg.sender, making their latest signed message unusable.
533     */
534     function invalidateNonce() public {
535         nonces[msg.sender]++;
536     }
537     
538     /**
539     @notice Function for repaying debt on behalf of user. Debt must be repaid in DOLA.
540     @dev If the user has a DBR deficit, they risk initial debt being accrued by forced replenishments.
541     @param user Address of the user whose debt is being repaid
542     @param amount DOLA amount to be repaid. If set to max uint debt will be repaid in full.
543     */
544     function repay(address user, uint amount) public {
545         uint debt = debts[user];
546         if(amount == type(uint).max){
547             amount = debt;
548         }
549         require(debt >= amount, "Repayment greater than debt");
550         debts[user] -= amount;
551         totalDebt -= amount;
552         dbr.onRepay(user, amount);
553         if(address(borrowController) != address(0)){
554             borrowController.onRepay(amount);
555         }
556         dola.transferFrom(msg.sender, address(this), amount);
557         emit Repay(user, msg.sender, amount);
558     }
559 
560     /**
561     @notice Bundles repayment and withdrawal into a single function call.
562     @param repayAmount Amount of DOLA to be repaid
563     @param withdrawAmount Amount of underlying to be withdrawn from the escrow
564     */
565     function repayAndWithdraw(uint repayAmount, uint withdrawAmount) public {
566         repay(msg.sender, repayAmount);
567         withdraw(withdrawAmount);
568     }
569 
570     /**
571     @notice Function for forcing a user to replenish their DBR deficit at a pre-determined price.
572      The replenishment will accrue additional DOLA debt.
573      On a successful call, the caller will be paid a replenishment incentive.
574     @dev The function will only top the user back up to 0, meaning that the user will have a DBR deficit again in the next block.
575     @param user The address of the user being forced to replenish DBR
576     @param amount The amount of DBR the user will be replenished.
577     */
578     function forceReplenish(address user, uint amount) public {
579         uint deficit = dbr.deficitOf(user);
580         require(deficit > 0, "No DBR deficit");
581         require(deficit >= amount, "Amount > deficit");
582         uint replenishmentCost = amount * dbr.replenishmentPriceBps() / 10000;
583         uint replenisherReward = replenishmentCost * replenishmentIncentiveBps / 10000;
584         debts[user] += replenishmentCost;
585         uint collateralValue = getCollateralValueInternal(user) * (10000 - liquidationIncentiveBps - liquidationFeeBps) / 10000;
586         require(collateralValue >= debts[user], "Exceeded collateral value");
587         totalDebt += replenishmentCost;
588         dbr.onForceReplenish(user, msg.sender, amount, replenisherReward);
589         dola.transfer(msg.sender, replenisherReward);
590     }
591     /**
592     @notice Function for forcing a user to replenish all of their DBR deficit at a pre-determined price.
593      The replenishment will accrue additional DOLA debt.
594      On a successful call, the caller will be paid a replenishment incentive.
595     @dev The function will only top the user back up to 0, meaning that the user will have a DBR deficit again in the next block.
596     @param user The address of the user being forced to replenish DBR
597     */
598     function forceReplenishAll(address user) public {
599         uint deficit = dbr.deficitOf(user);
600         forceReplenish(user, deficit);
601     }
602 
603     /**
604     @notice Function for liquidating a user's under water debt. Debt is under water when the value of a user's debt is above their collateral factor.
605     @param user The user to be liquidated
606     @param repaidDebt Th amount of user user debt to liquidate.
607     */
608     function liquidate(address user, uint repaidDebt) public {
609         require(repaidDebt > 0, "Must repay positive debt");
610         uint debt = debts[user];
611         require(getCreditLimitInternal(user) < debt, "User debt is healthy");
612         require(repaidDebt <= debt * liquidationFactorBps / 10000, "Exceeded liquidation factor");
613         uint price = oracle.getPrice(address(collateral), collateralFactorBps);
614         uint liquidatorReward = repaidDebt * 1 ether / price;
615         liquidatorReward += liquidatorReward * liquidationIncentiveBps / 10000;
616         debts[user] -= repaidDebt;
617         totalDebt -= repaidDebt;
618         dbr.onRepay(user, repaidDebt);
619         dola.transferFrom(msg.sender, address(this), repaidDebt);
620         IEscrow escrow = predictEscrow(user);
621         escrow.pay(msg.sender, liquidatorReward);
622         if(liquidationFeeBps > 0) {
623             uint liquidationFee = repaidDebt * 1 ether / price * liquidationFeeBps / 10000;
624             uint balance = escrow.balance();
625             if(balance >= liquidationFee) {
626                 escrow.pay(gov, liquidationFee);
627             } else if(balance > 0) {
628                 escrow.pay(gov, balance);
629             }
630         }
631         emit Liquidate(user, msg.sender, repaidDebt, liquidatorReward);
632     }
633     
634     event Deposit(address indexed account, uint amount);
635     event Borrow(address indexed account, uint amount);
636     event Withdraw(address indexed account, address indexed to, uint amount);
637     event Repay(address indexed account, address indexed repayer, uint amount);
638     event Liquidate(address indexed account, address indexed liquidator, uint repaidDebt, uint liquidatorReward);
639     event CreateEscrow(address indexed user, address escrow);
640 }