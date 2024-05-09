1 // File: contracts/ComptrollerInterface.sol
2 
3 pragma solidity ^0.5.16;
4 
5 
6 contract ComptrollerInterface {
7     /// @notice Indicator that this is a Comptroller contract (for inspection)
8     bool public constant isComptroller = true;
9 
10     /*** Assets You Are In ***/
11 
12     function enterMarkets(address[] calldata oTokens) external returns (uint[] memory);
13     function exitMarket(address oToken) external returns (uint);
14 
15     /*** Policy Hooks ***/
16 
17     function mintAllowed(address oToken, address minter, uint mintAmount) external returns (uint);
18     function mintVerify(address oToken, address minter, uint mintAmount, uint mintTokens) external;
19 
20     function redeemAllowed(address oToken, address redeemer, uint redeemTokens) external returns (uint);
21     function redeemVerify(address oToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
22 
23     function borrowAllowed(address oToken, address borrower, uint borrowAmount) external returns (uint);
24     function borrowVerify(address oToken, address borrower, uint borrowAmount) external;
25 
26     function repayBorrowAllowed(
27         address oToken,
28         address payer,
29         address borrower,
30         uint repayAmount) external returns (uint);
31     function repayBorrowVerify(
32         address oToken,
33         address payer,
34         address borrower,
35         uint repayAmount,
36         uint borrowerIndex) external;
37 
38     function liquidateBorrowAllowed(
39         address oTokenBorrowed,
40         address oTokenCollateral,
41         address liquidator,
42         address borrower,
43         uint repayAmount) external returns (uint);
44     function liquidateBorrowVerify(
45         address oTokenBorrowed,
46         address oTokenCollateral,
47         address liquidator,
48         address borrower,
49         uint repayAmount,
50         uint seizeTokens) external;
51 
52     function seizeAllowed(
53         address oTokenCollateral,
54         address oTokenBorrowed,
55         address liquidator,
56         address borrower,
57         uint seizeTokens) external returns (uint);
58     function seizeVerify(
59         address oTokenCollateral,
60         address oTokenBorrowed,
61         address liquidator,
62         address borrower,
63         uint seizeTokens) external;
64 
65     function transferAllowed(address oToken, address src, address dst, uint transferTokens) external returns (uint);
66     function transferVerify(address oToken, address src, address dst, uint transferTokens) external;
67 
68     /*** Liquidity/Liquidation Calculations ***/
69 
70     function liquidateCalculateSeizeTokens(
71         address oTokenBorrowed,
72         address oTokenCollateral,
73         uint repayAmount) external view returns (uint, uint);
74 
75 }
76 
77 // File: contracts/InterestRateModel.sol
78 
79 pragma solidity ^0.5.16;
80 
81 /**
82   * @title Onyx's InterestRateModel Interface
83   * @author Onyx
84   */
85 contract InterestRateModel {
86     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
87     bool public constant isInterestRateModel = true;
88 
89     /**
90       * @notice Calculates the current borrow interest rate per block
91       * @param cash The total amount of cash the market has
92       * @param borrows The total amount of borrows the market has outstanding
93       * @param reserves The total amount of reserves the market has
94       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
95       */
96     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);
97 
98     /**
99       * @notice Calculates the current supply interest rate per block
100       * @param cash The total amount of cash the market has
101       * @param borrows The total amount of borrows the market has outstanding
102       * @param reserves The total amount of reserves the market has
103       * @param reserveFactorMantissa The current reserve factor the market has
104       * @return The supply rate per block (as a percentage, and scaled by 1e18)
105       */
106     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
107 
108 }
109 
110 // File: contracts/EIP20NonStandardInterface.sol
111 
112 pragma solidity ^0.5.16;
113 
114 /**
115  * @title EIP20NonStandardInterface
116  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
117  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
118  */
119 interface EIP20NonStandardInterface {
120 
121     /**
122      * @notice Get the total number of tokens in circulation
123      * @return The supply of tokens
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @notice Gets the balance of the specified address
129      * @param owner The address from which the balance will be retrieved
130      * @return The balance
131      */
132     function balanceOf(address owner) external view returns (uint256 balance);
133 
134     ///
135     /// !!!!!!!!!!!!!!
136     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
137     /// !!!!!!!!!!!!!!
138     ///
139 
140     /**
141       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
142       * @param dst The address of the destination account
143       * @param amount The number of tokens to transfer
144       */
145     function transfer(address dst, uint256 amount) external;
146 
147     ///
148     /// !!!!!!!!!!!!!!
149     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
150     /// !!!!!!!!!!!!!!
151     ///
152 
153     /**
154       * @notice Transfer `amount` tokens from `src` to `dst`
155       * @param src The address of the source account
156       * @param dst The address of the destination account
157       * @param amount The number of tokens to transfer
158       */
159     function transferFrom(address src, address dst, uint256 amount) external;
160 
161     /**
162       * @notice Approve `spender` to transfer up to `amount` from `src`
163       * @dev This will overwrite the approval amount for `spender`
164       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
165       * @param spender The address of the account which may transfer tokens
166       * @param amount The number of tokens that are approved
167       * @return Whether or not the approval succeeded
168       */
169     function approve(address spender, uint256 amount) external returns (bool success);
170 
171     /**
172       * @notice Get the current allowance from `owner` for `spender`
173       * @param owner The address of the account which owns the tokens to be spent
174       * @param spender The address of the account which may transfer tokens
175       * @return The number of tokens allowed to be spent
176       */
177     function allowance(address owner, address spender) external view returns (uint256 remaining);
178 
179     event Transfer(address indexed from, address indexed to, uint256 amount);
180     event Approval(address indexed owner, address indexed spender, uint256 amount);
181 }
182 
183 // File: contracts/OTokenInterfaces.sol
184 
185 pragma solidity ^0.5.16;
186 
187 
188 
189 contract OTokenStorage {
190     /**
191      * @dev Guard variable for re-entrancy checks
192      */
193     bool internal _notEntered;
194 
195     /**
196      * @notice EIP-20 token name for this token
197      */
198     string public name;
199 
200     /**
201      * @notice EIP-20 token symbol for this token
202      */
203     string public symbol;
204 
205     /**
206      * @notice EIP-20 token decimals for this token
207      */
208     uint8 public decimals;
209 
210     /**
211      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
212      */
213 
214     uint internal constant borrowRateMaxMantissa = 0.0005e16;
215 
216     /**
217      * @notice Maximum fraction of interest that can be set aside for reserves
218      */
219     uint internal constant reserveFactorMaxMantissa = 1e18;
220 
221     /**
222      * @notice Administrator for this contract
223      */
224     address payable public admin;
225 
226     /**
227      * @notice Pending administrator for this contract
228      */
229     address payable public pendingAdmin;
230 
231     /**
232      * @notice Contract which oversees inter-oToken operations
233      */
234     ComptrollerInterface public comptroller;
235 
236     /**
237      * @notice Model which tells what the current interest rate should be
238      */
239     InterestRateModel public interestRateModel;
240 
241     /**
242      * @notice Initial exchange rate used when minting the first OTokens (used when totalSupply = 0)
243      */
244     uint internal initialExchangeRateMantissa;
245 
246     /**
247      * @notice Fraction of interest currently set aside for reserves
248      */
249     uint public reserveFactorMantissa;
250 
251     /**
252      * @notice Block number that interest was last accrued at
253      */
254     uint public accrualBlockNumber;
255 
256     /**
257      * @notice Accumulator of the total earned interest rate since the opening of the market
258      */
259     uint public borrowIndex;
260 
261     /**
262      * @notice Total amount of outstanding borrows of the underlying in this market
263      */
264     uint public totalBorrows;
265 
266     /**
267      * @notice Total amount of reserves of the underlying held in this market
268      */
269     uint public totalReserves;
270 
271     /**
272      * @notice Total number of tokens in circulation
273      */
274     uint public totalSupply;
275 
276     /**
277      * @notice Official record of token balances for each account
278      */
279     mapping (address => uint) internal accountTokens;
280 
281     /**
282      * @notice Approved token transfer amounts on behalf of others
283      */
284     mapping (address => mapping (address => uint)) internal transferAllowances;
285 
286     /**
287      * @notice Container for borrow balance information
288      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
289      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
290      */
291     struct BorrowSnapshot {
292         uint principal;
293         uint interestIndex;
294     }
295 
296     /**
297      * @notice Mapping of account addresses to outstanding borrow balances
298      */
299     mapping(address => BorrowSnapshot) internal accountBorrows;
300 
301     /**
302      * @notice Share of seized collateral that is added to reserves
303      */
304     uint public constant protocolSeizeShareMantissa = 2.8e16; //2.8%
305 
306 }
307 
308 contract OTokenInterface is OTokenStorage {
309     /**
310      * @notice Indicator that this is a OToken contract (for inspection)
311      */
312     bool public constant isOToken = true;
313 
314 
315     /*** Market Events ***/
316 
317     /**
318      * @notice Event emitted when interest is accrued
319      */
320     event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
321 
322     /**
323      * @notice Event emitted when tokens are minted
324      */
325     event Mint(address minter, uint mintAmount, uint mintTokens);
326 
327     /**
328      * @notice Event emitted when tokens are redeemed
329      */
330     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
331 
332     /**
333      * @notice Event emitted when underlying is borrowed
334      */
335     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
336 
337     /**
338      * @notice Event emitted when a borrow is repaid
339      */
340     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
341 
342     /**
343      * @notice Event emitted when a borrow is liquidated
344      */
345     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address oTokenCollateral, uint seizeTokens);
346 
347 
348     /*** Admin Events ***/
349 
350     /**
351      * @notice Event emitted when pendingAdmin is changed
352      */
353     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
354 
355     /**
356      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
357      */
358     event NewAdmin(address oldAdmin, address newAdmin);
359 
360     /**
361      * @notice Event emitted when comptroller is changed
362      */
363     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
364 
365     /**
366      * @notice Event emitted when interestRateModel is changed
367      */
368     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
369 
370     /**
371      * @notice Event emitted when the reserve factor is changed
372      */
373     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
374 
375     /**
376      * @notice Event emitted when the reserves are added
377      */
378     event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);
379 
380     /**
381      * @notice Event emitted when the reserves are reduced
382      */
383     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
384 
385     /**
386      * @notice EIP20 Transfer event
387      */
388     event Transfer(address indexed from, address indexed to, uint amount);
389 
390     /**
391      * @notice EIP20 Approval event
392      */
393     event Approval(address indexed owner, address indexed spender, uint amount);
394 
395     /**
396      * @notice Failure event
397      */
398     event Failure(uint error, uint info, uint detail);
399 
400 
401     /*** User Interface ***/
402 
403     function transfer(address dst, uint amount) external returns (bool);
404     function transferFrom(address src, address dst, uint amount) external returns (bool);
405     function approve(address spender, uint amount) external returns (bool);
406     function allowance(address owner, address spender) external view returns (uint);
407     function balanceOf(address owner) external view returns (uint);
408     function balanceOfUnderlying(address owner) external returns (uint);
409     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
410     function borrowRatePerBlock() external view returns (uint);
411     function supplyRatePerBlock() external view returns (uint);
412     function totalBorrowsCurrent() external returns (uint);
413     function borrowBalanceCurrent(address account) external returns (uint);
414     function borrowBalanceStored(address account) public view returns (uint);
415     function exchangeRateCurrent() public returns (uint);
416     function exchangeRateStored() public view returns (uint);
417     function getCash() external view returns (uint);
418     function accrueInterest() public returns (uint);
419     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
420 
421 
422     /*** Admin Functions ***/
423 
424     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);
425     function _acceptAdmin() external returns (uint);
426     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint);
427     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
428     function _reduceReserves(uint reduceAmount) external returns (uint);
429     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);
430 }
431 
432 contract OErc20Storage {
433     /**
434      * @notice Underlying asset for this OToken
435      */
436     address public underlying;
437 }
438 
439 contract OErc20Interface is OErc20Storage {
440 
441     /*** User Interface ***/
442 
443     function mint(uint mintAmount) external returns (uint);
444     function redeem(uint redeemTokens) external returns (uint);
445     function redeemUnderlying(uint redeemAmount) external returns (uint);
446     function borrow(uint borrowAmount) external returns (uint);
447     function repayBorrow(uint repayAmount) external returns (uint);
448     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
449     function liquidateBorrow(address borrower, uint repayAmount, OTokenInterface oTokenCollateral) external returns (uint);
450     function sweepToken(EIP20NonStandardInterface token) external;
451 
452 
453     /*** Admin Functions ***/
454 
455     function _addReserves(uint addAmount) external returns (uint);
456 }
457 
458 contract OErc721Storage {
459     /**
460      * @notice Underlying asset for this OToken
461      */
462     address public underlying;
463 
464     /**
465      * @dev User deposit tokens map
466      */
467     mapping (address => uint256[]) public userTokens;
468 }
469 
470 contract OErc721Interface is OErc721Storage {
471 
472     /*** User Interface ***/
473 
474     function mint(uint tokenId) external returns (uint);
475     function redeem(uint redeemTokens) external returns (uint);
476     function mints(uint[] calldata tokenIds) external returns (uint[] memory);
477     function redeems(uint[] calldata redeemTokenIds) external returns (uint[] memory);
478     function redeemUnderlying(uint redeemAmount) external returns (uint);
479     function borrow(uint borrowAmount) external returns (uint);
480     function repayBorrow(uint repayAmount) external returns (uint);
481     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
482     function liquidateBorrow(address borrower, uint repayAmount, OTokenInterface oTokenCollateral) external returns (uint);
483     function sweepToken(EIP20NonStandardInterface token) external;
484 }
485 
486 contract ODelegationStorage {
487     /**
488      * @notice Implementation address for this contract
489      */
490     address public implementation;
491 }
492 
493 contract ODelegatorInterface is ODelegationStorage {
494     /**
495      * @notice Emitted when implementation is changed
496      */
497     event NewImplementation(address oldImplementation, address newImplementation);
498 
499     /**
500      * @notice Called by the admin to update the implementation of the delegator
501      * @param implementation_ The address of the new implementation for delegation
502      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
503      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
504      */
505     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
506 }
507 
508 contract ODelegateInterface is ODelegationStorage {
509     /**
510      * @notice Called by the delegator on a delegate to initialize it for duty
511      * @dev Should revert if any issues arise which make it unfit for delegation
512      * @param data The encoded bytes data for any initialization
513      */
514     function _becomeImplementation(bytes memory data) public;
515 
516     /**
517      * @notice Called by the delegator on a delegate to forfeit its responsibility
518      */
519     function _resignImplementation() public;
520 }
521 
522 // File: contracts/OErc20Delegator.sol
523 
524 pragma solidity ^0.5.16;
525 
526 /**
527  * @title Onyx's OErc20Delegator Contract
528  * @notice OTokens which wrap an EIP-20 underlying and delegate to an implementation
529  * @author Onyx
530  */
531 contract OErc20Delegator is OTokenInterface, OErc20Interface, ODelegatorInterface {
532     /**
533      * @notice Construct a new money market
534      * @param underlying_ The address of the underlying asset
535      * @param comptroller_ The address of the Comptroller
536      * @param interestRateModel_ The address of the interest rate model
537      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
538      * @param name_ ERC-20 name of this token
539      * @param symbol_ ERC-20 symbol of this token
540      * @param decimals_ ERC-20 decimal precision of this token
541      * @param admin_ Address of the administrator of this token
542      * @param implementation_ The address of the implementation the contract delegates to
543      * @param becomeImplementationData The encoded args for becomeImplementation
544      */
545     constructor(address underlying_,
546                 ComptrollerInterface comptroller_,
547                 InterestRateModel interestRateModel_,
548                 uint initialExchangeRateMantissa_,
549                 string memory name_,
550                 string memory symbol_,
551                 uint8 decimals_,
552                 address payable admin_,
553                 address implementation_,
554                 bytes memory becomeImplementationData) public {
555         require(admin_ != address(0), "invalid admin address");
556         require(implementation_ != address(0), "invalid implementation address");
557 
558         // Creator of the contract is admin during initialization
559         admin = msg.sender;
560 
561         // First delegate gets to initialize the delegator (i.e. storage contract)
562         delegateTo(implementation_, abi.encodeWithSignature("initialize(address,address,address,uint256,string,string,uint8)",
563                                                             underlying_,
564                                                             comptroller_,
565                                                             interestRateModel_,
566                                                             initialExchangeRateMantissa_,
567                                                             name_,
568                                                             symbol_,
569                                                             decimals_));
570 
571         // New implementations always get set via the settor (post-initialize)
572         _setImplementation(implementation_, false, becomeImplementationData);
573 
574         // Set the proper admin now that initialization is done
575         admin = admin_;
576     }
577 
578     /**
579      * @notice Called by the admin to update the implementation of the delegator
580      * @param implementation_ The address of the new implementation for delegation
581      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
582      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
583      */
584     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
585         require(implementation_ != address(0), "invalid implementation address");
586 
587         require(msg.sender == admin, "OErc20Delegator::_setImplementation: Caller must be admin");
588 
589         if (allowResign) {
590             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
591         }
592 
593         address oldImplementation = implementation;
594         implementation = implementation_;
595 
596         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
597 
598         emit NewImplementation(oldImplementation, implementation);
599     }
600 
601     /**
602      * @notice Sender supplies assets into the market and receives oTokens in exchange
603      * @dev Accrues interest whether or not the operation succeeds, unless reverted
604      * @param mintAmount The amount of the underlying asset to supply
605      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
606      */
607     function mint(uint mintAmount) external returns (uint) {
608         bytes memory data = delegateToImplementation(abi.encodeWithSignature("mint(uint256)", mintAmount));
609         return abi.decode(data, (uint));
610     }
611 
612     /**
613      * @notice Sender redeems oTokens in exchange for the underlying asset
614      * @dev Accrues interest whether or not the operation succeeds, unless reverted
615      * @param redeemTokens The number of oTokens to redeem into underlying
616      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
617      */
618     function redeem(uint redeemTokens) external returns (uint) {
619         bytes memory data = delegateToImplementation(abi.encodeWithSignature("redeem(uint256)", redeemTokens));
620         return abi.decode(data, (uint));
621     }
622 
623     /**
624      * @notice Sender redeems oTokens in exchange for a specified amount of underlying asset
625      * @dev Accrues interest whether or not the operation succeeds, unless reverted
626      * @param redeemAmount The amount of underlying to redeem
627      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
628      */
629     function redeemUnderlying(uint redeemAmount) external returns (uint) {
630         bytes memory data = delegateToImplementation(abi.encodeWithSignature("redeemUnderlying(uint256)", redeemAmount));
631         return abi.decode(data, (uint));
632     }
633 
634     /**
635       * @notice Sender borrows assets from the protocol to their own address
636       * @param borrowAmount The amount of the underlying asset to borrow
637       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
638       */
639     function borrow(uint borrowAmount) external returns (uint) {
640         bytes memory data = delegateToImplementation(abi.encodeWithSignature("borrow(uint256)", borrowAmount));
641         return abi.decode(data, (uint));
642     }
643 
644     /**
645      * @notice Sender repays their own borrow
646      * @param repayAmount The amount to repay
647      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
648      */
649     function repayBorrow(uint repayAmount) external returns (uint) {
650         bytes memory data = delegateToImplementation(abi.encodeWithSignature("repayBorrow(uint256)", repayAmount));
651         return abi.decode(data, (uint));
652     }
653 
654     /**
655      * @notice Sender repays a borrow belonging to borrower
656      * @param borrower the account with the debt being payed off
657      * @param repayAmount The amount to repay
658      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
659      */
660     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
661         bytes memory data = delegateToImplementation(abi.encodeWithSignature("repayBorrowBehalf(address,uint256)", borrower, repayAmount));
662         return abi.decode(data, (uint));
663     }
664 
665     /**
666      * @notice The sender liquidates the borrowers collateral.
667      *  The collateral seized is transferred to the liquidator.
668      * @param borrower The borrower of this oToken to be liquidated
669      * @param oTokenCollateral The market in which to seize collateral from the borrower
670      * @param repayAmount The amount of the underlying borrowed asset to repay
671      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
672      */
673     function liquidateBorrow(address borrower, uint repayAmount, OTokenInterface oTokenCollateral) external returns (uint) {
674         bytes memory data = delegateToImplementation(abi.encodeWithSignature("liquidateBorrow(address,uint256,address)", borrower, repayAmount, oTokenCollateral));
675         return abi.decode(data, (uint));
676     }
677 
678     /**
679      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
680      * @param dst The address of the destination account
681      * @param amount The number of tokens to transfer
682      * @return Whether or not the transfer succeeded
683      */
684     function transfer(address dst, uint amount) external returns (bool) {
685         bytes memory data = delegateToImplementation(abi.encodeWithSignature("transfer(address,uint256)", dst, amount));
686         return abi.decode(data, (bool));
687     }
688 
689     /**
690      * @notice Transfer `amount` tokens from `src` to `dst`
691      * @param src The address of the source account
692      * @param dst The address of the destination account
693      * @param amount The number of tokens to transfer
694      * @return Whether or not the transfer succeeded
695      */
696     function transferFrom(address src, address dst, uint256 amount) external returns (bool) {
697         bytes memory data = delegateToImplementation(abi.encodeWithSignature("transferFrom(address,address,uint256)", src, dst, amount));
698         return abi.decode(data, (bool));
699     }
700 
701     /**
702      * @notice Approve `spender` to transfer up to `amount` from `src`
703      * @dev This will overwrite the approval amount for `spender`
704      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
705      * @param spender The address of the account which may transfer tokens
706      * @param amount The number of tokens that are approved (-1 means infinite)
707      * @return Whether or not the approval succeeded
708      */
709     function approve(address spender, uint256 amount) external returns (bool) {
710         bytes memory data = delegateToImplementation(abi.encodeWithSignature("approve(address,uint256)", spender, amount));
711         return abi.decode(data, (bool));
712     }
713 
714     /**
715      * @notice Get the current allowance from `owner` for `spender`
716      * @param owner The address of the account which owns the tokens to be spent
717      * @param spender The address of the account which may transfer tokens
718      * @return The number of tokens allowed to be spent (-1 means infinite)
719      */
720     function allowance(address owner, address spender) external view returns (uint) {
721         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("allowance(address,address)", owner, spender));
722         return abi.decode(data, (uint));
723     }
724 
725     /**
726      * @notice Get the token balance of the `owner`
727      * @param owner The address of the account to query
728      * @return The number of tokens owned by `owner`
729      */
730     function balanceOf(address owner) external view returns (uint) {
731         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("balanceOf(address)", owner));
732         return abi.decode(data, (uint));
733     }
734 
735     /**
736      * @notice Get the underlying balance of the `owner`
737      * @dev This also accrues interest in a transaction
738      * @param owner The address of the account to query
739      * @return The amount of underlying owned by `owner`
740      */
741     function balanceOfUnderlying(address owner) external returns (uint) {
742         bytes memory data = delegateToImplementation(abi.encodeWithSignature("balanceOfUnderlying(address)", owner));
743         return abi.decode(data, (uint));
744     }
745 
746     /**
747      * @notice Get a snapshot of the account's balances, and the cached exchange rate
748      * @dev This is used by comptroller to more efficiently perform liquidity checks.
749      * @param account Address of the account to snapshot
750      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
751      */
752     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
753         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("getAccountSnapshot(address)", account));
754         return abi.decode(data, (uint, uint, uint, uint));
755     }
756 
757     /**
758      * @notice Returns the current per-block borrow interest rate for this oToken
759      * @return The borrow interest rate per block, scaled by 1e18
760      */
761     function borrowRatePerBlock() external view returns (uint) {
762         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("borrowRatePerBlock()"));
763         return abi.decode(data, (uint));
764     }
765 
766     /**
767      * @notice Returns the current per-block supply interest rate for this oToken
768      * @return The supply interest rate per block, scaled by 1e18
769      */
770     function supplyRatePerBlock() external view returns (uint) {
771         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("supplyRatePerBlock()"));
772         return abi.decode(data, (uint));
773     }
774 
775     /**
776      * @notice Returns the current total borrows plus accrued interest
777      * @return The total borrows with interest
778      */
779     function totalBorrowsCurrent() external returns (uint) {
780         bytes memory data = delegateToImplementation(abi.encodeWithSignature("totalBorrowsCurrent()"));
781         return abi.decode(data, (uint));
782     }
783 
784     /**
785      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
786      * @param account The address whose balance should be calculated after updating borrowIndex
787      * @return The calculated balance
788      */
789     function borrowBalanceCurrent(address account) external returns (uint) {
790         bytes memory data = delegateToImplementation(abi.encodeWithSignature("borrowBalanceCurrent(address)", account));
791         return abi.decode(data, (uint));
792     }
793 
794     /**
795      * @notice Return the borrow balance of account based on stored data
796      * @param account The address whose balance should be calculated
797      * @return The calculated balance
798      */
799     function borrowBalanceStored(address account) public view returns (uint) {
800         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("borrowBalanceStored(address)", account));
801         return abi.decode(data, (uint));
802     }
803 
804    /**
805      * @notice Accrue interest then return the up-to-date exchange rate
806      * @return Calculated exchange rate scaled by 1e18
807      */
808     function exchangeRateCurrent() public returns (uint) {
809         bytes memory data = delegateToImplementation(abi.encodeWithSignature("exchangeRateCurrent()"));
810         return abi.decode(data, (uint));
811     }
812 
813     /**
814      * @notice Calculates the exchange rate from the underlying to the OToken
815      * @dev This function does not accrue interest before calculating the exchange rate
816      * @return Calculated exchange rate scaled by 1e18
817      */
818     function exchangeRateStored() public view returns (uint) {
819         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("exchangeRateStored()"));
820         return abi.decode(data, (uint));
821     }
822 
823     /**
824      * @notice Get cash balance of this oToken in the underlying asset
825      * @return The quantity of underlying asset owned by this contract
826      */
827     function getCash() external view returns (uint) {
828         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("getCash()"));
829         return abi.decode(data, (uint));
830     }
831 
832     /**
833       * @notice Applies accrued interest to total borrows and reserves.
834       * @dev This calculates interest accrued from the last checkpointed block
835       *      up to the current block and writes new checkpoint to storage.
836       */
837     function accrueInterest() public returns (uint) {
838         bytes memory data = delegateToImplementation(abi.encodeWithSignature("accrueInterest()"));
839         return abi.decode(data, (uint));
840     }
841 
842     /**
843      * @notice Transfers collateral tokens (this market) to the liquidator.
844      * @dev Will fail unless called by another oToken during the process of liquidation.
845      *  Its absolutely critical to use msg.sender as the borrowed oToken and not a parameter.
846      * @param liquidator The account receiving seized collateral
847      * @param borrower The account having collateral seized
848      * @param seizeTokens The number of oTokens to seize
849      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
850      */
851     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint) {
852         bytes memory data = delegateToImplementation(abi.encodeWithSignature("seize(address,address,uint256)", liquidator, borrower, seizeTokens));
853         return abi.decode(data, (uint));
854     }
855 
856     /**
857      * @notice A public function to sweep accidental ERC-20 transfers to this contract. Tokens are sent to admin (timelock)
858      * @param token The address of the ERC-20 token to sweep
859      */
860     function sweepToken(EIP20NonStandardInterface token) external {
861         delegateToImplementation(abi.encodeWithSignature("sweepToken(address)", token));
862     }
863 
864 
865     /*** Admin Functions ***/
866 
867     /**
868       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
869       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
870       * @param newPendingAdmin New pending admin.
871       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
872       */
873     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
874         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_setPendingAdmin(address)", newPendingAdmin));
875         return abi.decode(data, (uint));
876     }
877 
878     /**
879       * @notice Sets a new comptroller for the market
880       * @dev Admin function to set a new comptroller
881       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
882       */
883     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
884         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_setComptroller(address)", newComptroller));
885         return abi.decode(data, (uint));
886     }
887 
888     /**
889       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
890       * @dev Admin function to accrue interest and set a new reserve factor
891       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
892       */
893     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint) {
894         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_setReserveFactor(uint256)", newReserveFactorMantissa));
895         return abi.decode(data, (uint));
896     }
897 
898     /**
899       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
900       * @dev Admin function for pending admin to accept role and update admin
901       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
902       */
903     function _acceptAdmin() external returns (uint) {
904         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_acceptAdmin()"));
905         return abi.decode(data, (uint));
906     }
907 
908     /**
909      * @notice Accrues interest and adds reserves by transferring from admin
910      * @param addAmount Amount of reserves to add
911      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
912      */
913     function _addReserves(uint addAmount) external returns (uint) {
914         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_addReserves(uint256)", addAmount));
915         return abi.decode(data, (uint));
916     }
917 
918     /**
919      * @notice Accrues interest and reduces reserves by transferring to admin
920      * @param reduceAmount Amount of reduction to reserves
921      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
922      */
923     function _reduceReserves(uint reduceAmount) external returns (uint) {
924         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_reduceReserves(uint256)", reduceAmount));
925         return abi.decode(data, (uint));
926     }
927 
928     /**
929      * @notice Accrues interest and updates the interest rate model using _setInterestRateModelFresh
930      * @dev Admin function to accrue interest and update the interest rate model
931      * @param newInterestRateModel the new interest rate model to use
932      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
933      */
934     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
935         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_setInterestRateModel(address)", newInterestRateModel));
936         return abi.decode(data, (uint));
937     }
938 
939     /**
940      * @notice Internal method to delegate execution to another contract
941      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
942      * @param callee The contract to delegatecall
943      * @param data The raw data to delegatecall
944      * @return The returned bytes from the delegatecall
945      */
946     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
947         (bool success, bytes memory returnData) = callee.delegatecall(data);
948         assembly {
949             if eq(success, 0) {
950                 revert(add(returnData, 0x20), returndatasize)
951             }
952         }
953         return returnData;
954     }
955 
956     /**
957      * @notice Delegates execution to the implementation contract
958      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
959      * @param data The raw data to delegatecall
960      * @return The returned bytes from the delegatecall
961      */
962     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
963         return delegateTo(implementation, data);
964     }
965 
966     /**
967      * @notice Delegates execution to an implementation contract
968      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
969      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
970      * @param data The raw data to delegatecall
971      * @return The returned bytes from the delegatecall
972      */
973     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
974         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
975         assembly {
976             if eq(success, 0) {
977                 revert(add(returnData, 0x20), returndatasize)
978             }
979         }
980         return abi.decode(returnData, (bytes));
981     }
982 
983     /**
984      * @notice Delegates execution to an implementation contract
985      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
986      */
987     function () external payable {
988         require(msg.value == 0,"OErc20Delegator:fallback: cannot send value to fallback");
989 
990         // delegate all other functions to current implementation
991         (bool success, ) = implementation.delegatecall(msg.data);
992 
993         assembly {
994             let free_mem_ptr := mload(0x40)
995             returndatacopy(free_mem_ptr, 0, returndatasize)
996 
997             switch success
998             case 0 { revert(free_mem_ptr, returndatasize) }
999             default { return(free_mem_ptr, returndatasize) }
1000         }
1001     }
1002 }