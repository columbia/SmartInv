1 /**
2  * Copyright 2017-2019, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5  
6 pragma solidity 0.5.8;
7 pragma experimental ABIEncoderV2;
8 
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * See https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16   function totalSupply() public view returns (uint256);
17   function balanceOf(address _who) public view returns (uint256);
18   function transfer(address _to, uint256 _value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 /**
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27   function allowance(address _owner, address _spender)
28     public view returns (uint256);
29 
30   function transferFrom(address _from, address _to, uint256 _value)
31     public returns (bool);
32 
33   function approve(address _spender, uint256 _value) public returns (bool);
34   event Approval(
35     address indexed owner,
36     address indexed spender,
37     uint256 value
38   );
39 }
40 
41 /**
42  * @title EIP20/ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/20
44  */
45 contract EIP20 is ERC20 {
46     string public name;
47     uint8 public decimals;
48     string public symbol;
49 }
50 
51 contract WETHInterface is EIP20 {
52     function deposit() external payable;
53     function withdraw(uint256 wad) external;
54 }
55 
56 /**
57  * @title SafeMath
58  * @dev Math operations with safety checks that throw on error
59  */
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
66     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
67     // benefit is lost if 'b' is also tested.
68     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69     if (_a == 0) {
70       return 0;
71     }
72 
73     c = _a * _b;
74     assert(c / _a == _b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
82     // assert(_b > 0); // Solidity automatically throws when dividing by 0
83     // uint256 c = _a / _b;
84     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
85     return _a / _b;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, rounding up and truncating the quotient
90   */
91   function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     if (_a == 0) {
93       return 0;
94     }
95 
96     return ((_a - 1) / _b) + 1;
97   }
98 
99   /**
100   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
103     assert(_b <= _a);
104     return _a - _b;
105   }
106 
107   /**
108   * @dev Adds two numbers, throws on overflow.
109   */
110   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
111     c = _a + _b;
112     assert(c >= _a);
113     return c;
114   }
115 }
116 
117 /**
118  * @title Ownable
119  * @dev The Ownable contract has an owner address, and provides basic authorization control
120  * functions, this simplifies the implementation of "user permissions".
121  */
122 contract Ownable {
123   address public owner;
124 
125 
126   event OwnershipTransferred(
127     address indexed previousOwner,
128     address indexed newOwner
129   );
130 
131 
132   /**
133    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
134    * account.
135    */
136   constructor() public {
137     owner = msg.sender;
138   }
139 
140   /**
141    * @dev Throws if called by any account other than the owner.
142    */
143   modifier onlyOwner() {
144     require(msg.sender == owner);
145     _;
146   }
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param _newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address _newOwner) public onlyOwner {
153     _transferOwnership(_newOwner);
154   }
155 
156   /**
157    * @dev Transfers control of the contract to a newOwner.
158    * @param _newOwner The address to transfer ownership to.
159    */
160   function _transferOwnership(address _newOwner) internal {
161     require(_newOwner != address(0));
162     emit OwnershipTransferred(owner, _newOwner);
163     owner = _newOwner;
164   }
165 }
166 
167 /**
168  * @title Helps contracts guard against reentrancy attacks.
169  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
170  * @dev If you mark a function `nonReentrant`, you should also
171  * mark it `external`.
172  */
173 contract ReentrancyGuard {
174 
175   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
176   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
177   uint256 internal constant REENTRANCY_GUARD_FREE = 1;
178 
179   /// @dev Constant for locked guard state
180   uint256 internal constant REENTRANCY_GUARD_LOCKED = 2;
181 
182   /**
183    * @dev We use a single lock for the whole contract.
184    */
185   uint256 internal reentrancyLock = REENTRANCY_GUARD_FREE;
186 
187   /**
188    * @dev Prevents a contract from calling itself, directly or indirectly.
189    * If you mark a function `nonReentrant`, you should also
190    * mark it `external`. Calling one `nonReentrant` function from
191    * another is not supported. Instead, you can implement a
192    * `private` function doing the actual work, and an `external`
193    * wrapper marked as `nonReentrant`.
194    */
195   modifier nonReentrant() {
196     require(reentrancyLock == REENTRANCY_GUARD_FREE, "nonReentrant");
197     reentrancyLock = REENTRANCY_GUARD_LOCKED;
198     _;
199     reentrancyLock = REENTRANCY_GUARD_FREE;
200   }
201 
202 }
203 
204 contract LoanTokenization is ReentrancyGuard, Ownable {
205 
206     uint256 internal constant MAX_UINT = 2**256 - 1;
207 
208     string public name;
209     string public symbol;
210     uint8 public decimals;
211 
212     address public bZxContract;
213     address public bZxVault;
214     address public bZxOracle;
215     address public wethContract;
216 
217     address public loanTokenAddress;
218 
219     // price of token at last user checkpoint
220     mapping (address => uint256) internal checkpointPrices_;
221 }
222 
223 contract LoanTokenStorage is LoanTokenization {
224 
225     struct ListIndex {
226         uint256 index;
227         bool isSet;
228     }
229 
230     struct LoanData {
231         bytes32 loanOrderHash;
232         uint256 leverageAmount;
233         uint256 initialMarginAmount;
234         uint256 maintenanceMarginAmount;
235         uint256 maxDurationUnixTimestampSec;
236         uint256 index;
237     }
238 
239     struct TokenReserves {
240         address lender;
241         uint256 amount;
242     }
243 
244     event Borrow(
245         address indexed borrower,
246         uint256 borrowAmount,
247         uint256 interestRate,
248         address collateralTokenAddress,
249         address tradeTokenToFillAddress,
250         bool withdrawOnOpen
251     );
252 
253     event Claim(
254         address indexed claimant,
255         uint256 tokenAmount,
256         uint256 assetAmount,
257         uint256 remainingTokenAmount,
258         uint256 price
259     );
260 
261     bool internal isInitialized_ = false;
262 
263     address public tokenizedRegistry;
264 
265     uint256 public baseRate = 1000000000000000000; // 1.0%
266     uint256 public rateMultiplier = 39000000000000000000; // 39%
267 
268     // "fee percentage retained by the oracle" = SafeMath.sub(10**20, spreadMultiplier);
269     uint256 public spreadMultiplier;
270 
271     mapping (uint256 => bytes32) public loanOrderHashes; // mapping of levergeAmount to loanOrderHash
272     mapping (bytes32 => LoanData) public loanOrderData; // mapping of loanOrderHash to LoanOrder
273     uint256[] public leverageList;
274 
275     TokenReserves[] public burntTokenReserveList; // array of TokenReserves
276     mapping (address => ListIndex) public burntTokenReserveListIndex; // mapping of lender address to ListIndex objects
277     uint256 public burntTokenReserved; // total outstanding burnt token amount
278     address internal nextOwedLender_;
279 
280     uint256 public totalAssetBorrow = 0; // current amount of loan token amount tied up in loans
281 
282     uint256 internal checkpointSupply_;
283 
284     uint256 internal lastSettleTime_;
285 
286     uint256 public initialPrice;
287 }
288 
289 contract AdvancedTokenStorage is LoanTokenStorage {
290     using SafeMath for uint256;
291 
292     event Transfer(
293         address indexed from,
294         address indexed to,
295         uint256 value
296     );
297     event Approval(
298         address indexed owner,
299         address indexed spender,
300         uint256 value
301     );
302     event Mint(
303         address indexed minter,
304         uint256 tokenAmount,
305         uint256 assetAmount,
306         uint256 price
307     );
308     event Burn(
309         address indexed burner,
310         uint256 tokenAmount,
311         uint256 assetAmount,
312         uint256 price
313     );
314 
315     mapping(address => uint256) internal balances;
316     mapping (address => mapping (address => uint256)) internal allowed;
317     uint256 internal totalSupply_;
318 
319     function totalSupply()
320         public
321         view
322         returns (uint256)
323     {
324         return totalSupply_;
325     }
326 
327     function balanceOf(
328         address _owner)
329         public
330         view
331         returns (uint256)
332     {
333         return balances[_owner];
334     }
335 
336     function allowance(
337         address _owner,
338         address _spender)
339         public
340         view
341         returns (uint256)
342     {
343         return allowed[_owner][_spender];
344     }
345 }
346 
347 contract AdvancedToken is AdvancedTokenStorage {
348     using SafeMath for uint256;
349 
350     function approve(
351         address _spender,
352         uint256 _value)
353         public
354         returns (bool)
355     {
356         allowed[msg.sender][_spender] = _value;
357         emit Approval(msg.sender, _spender, _value);
358         return true;
359     }
360 
361     function increaseApproval(
362         address _spender,
363         uint256 _addedValue)
364         public
365         returns (bool)
366     {
367         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
368         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
369         return true;
370     }
371 
372     function decreaseApproval(
373         address _spender,
374         uint256 _subtractedValue)
375         public
376         returns (bool)
377     {
378         uint256 oldValue = allowed[msg.sender][_spender];
379         if (_subtractedValue >= oldValue) {
380             allowed[msg.sender][_spender] = 0;
381         } else {
382             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
383         }
384         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
385         return true;
386     }
387 
388     function _mint(
389         address _to,
390         uint256 _tokenAmount,
391         uint256 _assetAmount,
392         uint256 _price)
393         internal
394     {
395         require(_to != address(0), "invalid address");
396         totalSupply_ = totalSupply_.add(_tokenAmount);
397         balances[_to] = balances[_to].add(_tokenAmount);
398 
399         emit Mint(_to, _tokenAmount, _assetAmount, _price);
400         emit Transfer(address(0), _to, _tokenAmount);
401     }
402 
403     function _burn(
404         address _who,
405         uint256 _tokenAmount,
406         uint256 _assetAmount,
407         uint256 _price)
408         internal
409     {
410         require(_tokenAmount <= balances[_who], "burn value exceeds balance");
411         // no need to require value <= totalSupply, since that would imply the
412         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
413 
414         balances[_who] = balances[_who].sub(_tokenAmount);
415         if (balances[_who] <= 10) { // we can't leave such small balance quantities
416             _tokenAmount = _tokenAmount.add(balances[_who]);
417             balances[_who] = 0;
418         }
419 
420         totalSupply_ = totalSupply_.sub(_tokenAmount);
421 
422         emit Burn(_who, _tokenAmount, _assetAmount, _price);
423         emit Transfer(_who, address(0), _tokenAmount);
424     }
425 }
426 
427 contract BZxObjects {
428 
429     struct LoanOrder {
430         address loanTokenAddress;
431         address interestTokenAddress;
432         address collateralTokenAddress;
433         address oracleAddress;
434         uint256 loanTokenAmount;
435         uint256 interestAmount;
436         uint256 initialMarginAmount;
437         uint256 maintenanceMarginAmount;
438         uint256 maxDurationUnixTimestampSec;
439         bytes32 loanOrderHash;
440     }
441 
442     struct LoanPosition {
443         address trader;
444         address collateralTokenAddressFilled;
445         address positionTokenAddressFilled;
446         uint256 loanTokenAmountFilled;
447         uint256 loanTokenAmountUsed;
448         uint256 collateralTokenAmountFilled;
449         uint256 positionTokenAmountFilled;
450         uint256 loanStartUnixTimestampSec;
451         uint256 loanEndUnixTimestampSec;
452         bool active;
453         uint256 positionId;
454     }
455 }
456 
457 contract OracleNotifierInterface {
458 
459     function closeLoanNotifier(
460         BZxObjects.LoanOrder memory loanOrder,
461         BZxObjects.LoanPosition memory loanPosition,
462         address loanCloser,
463         uint256 closeAmount,
464         bool isLiquidation)
465         public
466         returns (bool);
467 }
468 
469 interface IBZx {
470     function pushLoanOrderOnChain(
471         address[8] calldata orderAddresses,
472         uint256[11] calldata orderValues,
473         bytes calldata oracleData,
474         bytes calldata signature)
475         external
476         returns (bytes32); // loanOrderHash
477 
478     function setLoanOrderDesc(
479         bytes32 loanOrderHash,
480         string calldata desc)
481         external
482         returns (bool);
483 
484     function updateLoanAsLender(
485         bytes32 loanOrderHash,
486         uint256 increaseAmountForLoan,
487         uint256 newInterestRate,
488         uint256 newExpirationTimestamp)
489         external
490         returns (bool);
491 
492     function takeLoanOrderOnChainAsTraderByDelegate(
493         address trader,
494         bytes32 loanOrderHash,
495         address collateralTokenFilled,
496         uint256 loanTokenAmountFilled,
497         address tradeTokenToFillAddress,
498         bool withdrawOnOpen)
499         external
500         returns (uint256);
501 
502     function getLenderInterestForOracle(
503         address lender,
504         address oracleAddress,
505         address interestTokenAddress)
506         external
507         view
508         returns (
509             uint256,    // interestPaid
510             uint256,    // interestPaidDate
511             uint256,    // interestOwedPerDay
512             uint256);   // interestUnPaid
513 
514     function oracleAddresses(
515         address oracleAddress)
516         external
517         view
518         returns (address);
519 }
520 
521 interface IBZxOracle {
522     function tradeUserAsset(
523         address sourceTokenAddress,
524         address destTokenAddress,
525         address receiverAddress,
526         address returnToSenderAddress,
527         uint256 sourceTokenAmount,
528         uint256 maxDestTokenAmount,
529         uint256 minConversionRate)
530         external
531         returns (uint256 destTokenAmountReceived, uint256 sourceTokenAmountUsed);
532 
533     function interestFeePercent()
534         external
535         view
536         returns (uint256);
537 }
538 
539 interface iTokenizedRegistry {
540     function getTokenAsset(
541         address _token,
542         uint256 _tokenType)
543         external
544         view
545         returns (address);
546 }
547 
548 contract LoanTokenLogic is AdvancedToken, OracleNotifierInterface {
549     using SafeMath for uint256;
550 
551     modifier onlyOracle() {
552         require(msg.sender == IBZx(bZxContract).oracleAddresses(bZxOracle), "unauthorized");
553         _;
554     }
555 
556 
557     function()
558         external
559         payable
560     {}
561 
562 
563     /* Public functions */
564 
565     function mintWithEther(
566         address receiver)
567         external
568         payable
569         nonReentrant
570         returns (uint256 mintAmount)
571     {
572         require(loanTokenAddress == wethContract, "no ether");
573         return _mintToken(
574             receiver,
575             msg.value
576         );
577     }
578 
579     function mint(
580         address receiver,
581         uint256 depositAmount)
582         external
583         nonReentrant
584         returns (uint256 mintAmount)
585     {
586         return _mintToken(
587             receiver,
588             depositAmount
589         );
590     }
591 
592     function burnToEther(
593         address payable receiver,
594         uint256 burnAmount)
595         external
596         nonReentrant
597         returns (uint256 loanAmountPaid)
598     {
599         require(loanTokenAddress == wethContract, "no ether");
600         loanAmountPaid = _burnToken(
601             receiver,
602             burnAmount
603         );
604 
605         if (loanAmountPaid > 0) {
606             WETHInterface(wethContract).withdraw(loanAmountPaid);
607             require(receiver.send(loanAmountPaid), "transfer failed");
608         }
609     }
610 
611     function burn(
612         address receiver,
613         uint256 burnAmount)
614         external
615         nonReentrant
616         returns (uint256 loanAmountPaid)
617     {
618         loanAmountPaid = _burnToken(
619             receiver,
620             burnAmount
621         );
622 
623         if (loanAmountPaid > 0) {
624             require(ERC20(loanTokenAddress).transfer(
625                 receiver,
626                 loanAmountPaid
627             ), "transfer failed");
628         }
629     }
630 
631     // called by a borrower to open a loan
632     // loan can be collateralized using any supported token (collateralTokenAddress)
633     // interest collected is denominated the same as loanToken
634     // returns borrowAmount
635     function borrowToken(
636         uint256 borrowAmount,
637         uint256 leverageAmount,
638         address collateralTokenAddress,
639         address tradeTokenToFillAddress,
640         bool withdrawOnOpen)
641         external
642         nonReentrant
643         returns (uint256)
644     {
645         uint256 amount = _borrowToken(
646             msg.sender,
647             borrowAmount,
648             leverageAmount,
649             collateralTokenAddress,
650             tradeTokenToFillAddress,
651             withdrawOnOpen,
652             false // calcBorrow
653         );
654         require(amount > 0, "can't borrow");
655         return amount;
656     }
657 
658     // called by a borrower to open a loan
659     // escrowAmount == total collateral + interest available to back the loan
660     // escrowAmount is denominated the same as loanToken
661     // returns borrowAmount
662     function borrowTokenFromEscrow(
663         uint256 escrowAmount,
664         uint256 leverageAmount,
665         address tradeTokenToFillAddress,
666         bool withdrawOnOpen)
667         external
668         nonReentrant
669         returns (uint256)
670     {
671         uint256 amount = _borrowToken(
672             msg.sender,
673             escrowAmount,
674             leverageAmount,
675             loanTokenAddress, // collateralTokenAddress
676             tradeTokenToFillAddress,
677             withdrawOnOpen,
678             true // calcBorrow
679         );
680         require(amount > 0, "can't borrow");
681         return amount;
682     }
683 
684     function rolloverPosition(
685         address borrower,
686         uint256 leverageAmount,
687         uint256 escrowAmount,
688         address tradeTokenToFillAddress)
689         external
690         returns (uint256)
691     {
692         require(msg.sender == address(this), "unauthorized");
693 
694         return _borrowToken(
695             borrower,
696             escrowAmount,
697             leverageAmount,
698             loanTokenAddress, // collateralTokenAddress
699             tradeTokenToFillAddress,
700             false, // withdrawOnOpen
701             true // calcBorrow
702         );
703     }
704 
705     // Claims owned loan token for the caller
706     // Also claims for user with the longest reserves
707     // returns amount claimed for the caller
708     function claimLoanToken()
709         external
710         nonReentrant
711         returns (uint256 claimedAmount)
712     {
713         claimedAmount = _claimLoanToken(msg.sender);
714 
715         if (burntTokenReserveList.length > 0) {
716             _claimLoanToken(_getNextOwed());
717 
718             if (burntTokenReserveListIndex[msg.sender].isSet && nextOwedLender_ != msg.sender) {
719                 // ensure lender is paid next
720                 nextOwedLender_ = msg.sender;
721             }
722         }
723     }
724 
725     function settleInterest()
726         external
727         nonReentrant
728     {
729         _settleInterest();
730     }
731 
732     function wrapEther()
733         public
734     {
735         if (address(this).balance > 0) {
736             WETHInterface(wethContract).deposit.value(address(this).balance)();
737         }
738     }
739 
740     // Sends non-LoanToken assets to the Oracle fund
741     // These are assets that would otherwise be "stuck" due to a user accidently sending them to the contract
742     function donateAsset(
743         address tokenAddress)
744         public
745         returns (bool)
746     {
747         if (tokenAddress == loanTokenAddress)
748             return false;
749 
750         uint256 balance = ERC20(tokenAddress).balanceOf(address(this));
751         if (balance == 0)
752             return false;
753 
754         require(ERC20(tokenAddress).transfer(
755             IBZx(bZxContract).oracleAddresses(bZxOracle),
756             balance
757         ), "transfer failed");
758 
759         return true;
760     }
761 
762     function transfer(
763         address _to,
764         uint256 _value)
765         public
766         returns (bool)
767     {
768         require(_value <= balances[msg.sender], "insufficient balance");
769         require(_to != address(0), "token burn not allowed");
770 
771         balances[msg.sender] = balances[msg.sender].sub(_value);
772         balances[_to] = balances[_to].add(_value);
773 
774         // handle checkpoint update
775         uint256 currentPrice = tokenPrice();
776         if (burntTokenReserveListIndex[msg.sender].isSet || balances[msg.sender] > 0) {
777             checkpointPrices_[msg.sender] = currentPrice;
778         } else {
779             checkpointPrices_[msg.sender] = 0;
780         }
781         if (burntTokenReserveListIndex[_to].isSet || balances[_to] > 0) {
782             checkpointPrices_[_to] = currentPrice;
783         } else {
784             checkpointPrices_[_to] = 0;
785         }
786 
787         emit Transfer(msg.sender, _to, _value);
788         return true;
789     }
790 
791     function transferFrom(
792         address _from,
793         address _to,
794         uint256 _value)
795         public
796         returns (bool)
797     {
798         uint256 allowanceAmount = allowed[_from][msg.sender];
799         require(_value <= balances[_from], "insufficient balance");
800         require(_value <= allowanceAmount, "insufficient allowance");
801         require(_to != address(0), "token burn not allowed");
802 
803         balances[_from] = balances[_from].sub(_value);
804         balances[_to] = balances[_to].add(_value);
805         if (allowanceAmount < MAX_UINT) {
806             allowed[_from][msg.sender] = allowanceAmount.sub(_value);
807         }
808 
809         // handle checkpoint update
810         uint256 currentPrice = tokenPrice();
811         if (burntTokenReserveListIndex[_from].isSet || balances[_from] > 0) {
812             checkpointPrices_[_from] = currentPrice;
813         } else {
814             checkpointPrices_[_from] = 0;
815         }
816         if (burntTokenReserveListIndex[_to].isSet || balances[_to] > 0) {
817             checkpointPrices_[_to] = currentPrice;
818         } else {
819             checkpointPrices_[_to] = 0;
820         }
821 
822         emit Transfer(_from, _to, _value);
823         return true;
824     }
825 
826 
827     /* Public View functions */
828 
829     function tokenPrice()
830         public
831         view
832         returns (uint256 price)
833     {
834         uint256 interestUnPaid = 0;
835         if (lastSettleTime_ != block.timestamp) {
836             (,,interestUnPaid) = _getAllInterest();
837 
838             interestUnPaid = interestUnPaid
839                 .mul(spreadMultiplier)
840                 .div(10**20);
841         }
842 
843         return _tokenPrice(_totalAssetSupply(interestUnPaid));
844     }
845 
846     function checkpointPrice(
847         address _user)
848         public
849         view
850         returns (uint256 price)
851     {
852         return checkpointPrices_[_user];
853     }
854 
855     function totalReservedSupply()
856         public
857         view
858         returns (uint256)
859     {
860         return burntTokenReserved.mul(tokenPrice()).div(10**18);
861     }
862 
863     function marketLiquidity()
864         public
865         view
866         returns (uint256)
867     {
868         uint256 totalSupply = totalAssetSupply();
869         uint256 reservedSupply = totalReservedSupply();
870         if (totalSupply > reservedSupply) {
871             totalSupply = totalSupply.sub(reservedSupply);
872         } else {
873             return 0;
874         }
875 
876         if (totalSupply > totalAssetBorrow) {
877             return totalSupply.sub(totalAssetBorrow);
878         } else {
879             return 0;
880         }
881     }
882 
883     // interest that borrowers are currently paying for open loans, prior to any fees
884     function borrowInterestRate()
885         public
886         view
887         returns (uint256)
888     {
889         if (totalAssetBorrow > 0) {
890             return _protocolInterestRate(totalAssetSupply());
891         } else {
892             return baseRate;
893         }
894     }
895 
896     // interest that lenders are currently receiving for open loans, prior to any fees
897     function supplyInterestRate()
898         public
899         view
900         returns (uint256)
901     {
902         uint256 assetSupply = totalAssetSupply();
903         if (totalAssetBorrow > 0) {
904             return _protocolInterestRate(assetSupply)
905                 .mul(_getUtilizationRate(assetSupply))
906                 .div(10**40);
907         } else {
908             return 0;
909         }
910     }
911 
912     // the rate the next base protocol borrower will receive based on the amount being borrowed
913     function nextLoanInterestRate(
914         uint256 borrowAmount)
915         public
916         view
917         returns (uint256)
918     {
919         if (borrowAmount > 0) {
920             uint256 interestUnPaid = 0;
921             if (lastSettleTime_ != block.timestamp) {
922                 (,,interestUnPaid) = _getAllInterest();
923 
924                 interestUnPaid = interestUnPaid
925                     .mul(spreadMultiplier)
926                     .div(10**20);
927             }
928 
929             uint256 balance = ERC20(loanTokenAddress).balanceOf(address(this)).add(interestUnPaid);
930             if (borrowAmount > balance) {
931                 borrowAmount = balance;
932             }
933         }
934 
935         return _nextLoanInterestRate(borrowAmount);
936     }
937 
938     // returns the total amount of interest earned for all active loans
939     function interestReceived()
940         public
941         view
942         returns (uint256 interestTotalAccrued)
943     {
944         (uint256 interestPaidSoFar,,uint256 interestUnPaid) = _getAllInterest();
945 
946         return interestPaidSoFar
947             .add(interestUnPaid)
948             .mul(spreadMultiplier)
949             .div(10**20);
950     }
951 
952     function totalAssetSupply()
953         public
954         view
955         returns (uint256)
956     {
957         uint256 interestUnPaid = 0;
958         if (lastSettleTime_ != block.timestamp) {
959             (,,interestUnPaid) = _getAllInterest();
960 
961             interestUnPaid = interestUnPaid
962                 .mul(spreadMultiplier)
963                 .div(10**20);
964         }
965 
966         return _totalAssetSupply(interestUnPaid);
967     }
968 
969     function getMaxEscrowAmount(
970         uint256 leverageAmount)
971         public
972         view
973         returns (uint256)
974     {
975         LoanData memory loanData = loanOrderData[loanOrderHashes[leverageAmount]];
976         if (loanData.initialMarginAmount == 0)
977             return 0;
978 
979         return marketLiquidity()
980             .mul(loanData.initialMarginAmount)
981             .div(_adjustValue(
982                 10**20, // maximum possible interest (100%)
983                 loanData.maxDurationUnixTimestampSec,
984                 loanData.initialMarginAmount));
985     }
986 
987     function getBorrowAmount(
988         uint256 escrowAmount,
989         uint256 leverageAmount,
990         bool withdrawOnOpen)
991         public
992         view
993         returns (uint256)
994     {
995         if (escrowAmount == 0)
996             return 0;
997 
998         LoanData memory loanData = loanOrderData[loanOrderHashes[leverageAmount]];
999         if (loanData.initialMarginAmount == 0)
1000             return 0;
1001 
1002         return _getBorrowAmount(
1003             loanData.initialMarginAmount,
1004             escrowAmount,
1005             nextLoanInterestRate(
1006                 escrowAmount
1007                     .mul(10**20)
1008                     .div(loanData.initialMarginAmount)
1009             ),
1010             loanData.maxDurationUnixTimestampSec,
1011             withdrawOnOpen
1012         );
1013     }
1014 
1015     function getLoanData(
1016         uint256 levergeAmount)
1017         public
1018         view
1019         returns (LoanData memory)
1020     {
1021         return loanOrderData[loanOrderHashes[levergeAmount]];
1022     }
1023 
1024     function getLeverageList()
1025         public
1026         view
1027         returns (uint256[] memory)
1028     {
1029         return leverageList;
1030     }
1031 
1032     // returns the user's balance of underlying token
1033     function assetBalanceOf(
1034         address _owner)
1035         public
1036         view
1037         returns (uint256)
1038     {
1039         return balanceOf(_owner)
1040             .mul(tokenPrice())
1041             .div(10**18);
1042     }
1043 
1044 
1045     /* Internal functions */
1046 
1047     function _mintToken(
1048         address receiver,
1049         uint256 depositAmount)
1050         internal
1051         returns (uint256 mintAmount)
1052     {
1053         require (depositAmount > 0, "amount == 0");
1054 
1055         if (burntTokenReserveList.length > 0) {
1056             _claimLoanToken(_getNextOwed());
1057             _claimLoanToken(receiver);
1058             if (msg.sender != receiver)
1059                 _claimLoanToken(msg.sender);
1060         } else {
1061             _settleInterest();
1062         }
1063 
1064         uint256 currentPrice = _tokenPrice(_totalAssetSupply(0));
1065         mintAmount = depositAmount.mul(10**18).div(currentPrice);
1066 
1067         if (msg.value == 0) {
1068             require(ERC20(loanTokenAddress).transferFrom(
1069                 msg.sender,
1070                 address(this),
1071                 depositAmount
1072             ), "transfer failed");
1073         } else {
1074             WETHInterface(wethContract).deposit.value(depositAmount)();
1075         }
1076 
1077         _mint(receiver, mintAmount, depositAmount, currentPrice);
1078 
1079         checkpointPrices_[receiver] = currentPrice;
1080     }
1081 
1082     function _burnToken(
1083         address receiver,
1084         uint256 burnAmount)
1085         internal
1086         returns (uint256 loanAmountPaid)
1087     {
1088         require(burnAmount > 0, "amount == 0");
1089 
1090         if (burnAmount > balanceOf(msg.sender)) {
1091             burnAmount = balanceOf(msg.sender);
1092         }
1093 
1094         if (burntTokenReserveList.length > 0) {
1095             _claimLoanToken(_getNextOwed());
1096             _claimLoanToken(receiver);
1097             if (msg.sender != receiver)
1098                 _claimLoanToken(msg.sender);
1099         } else {
1100             _settleInterest();
1101         }
1102 
1103         uint256 currentPrice = _tokenPrice(_totalAssetSupply(0));
1104 
1105         uint256 loanAmountOwed = burnAmount.mul(currentPrice).div(10**18);
1106         uint256 loanAmountAvailableInContract = ERC20(loanTokenAddress).balanceOf(address(this));
1107 
1108         loanAmountPaid = loanAmountOwed;
1109         if (loanAmountPaid > loanAmountAvailableInContract) {
1110             uint256 reserveAmount = loanAmountPaid.sub(loanAmountAvailableInContract);
1111             uint256 reserveTokenAmount = reserveAmount.mul(10**18).div(currentPrice);
1112 
1113             burntTokenReserved = burntTokenReserved.add(reserveTokenAmount);
1114             if (burntTokenReserveListIndex[receiver].isSet) {
1115                 uint256 index = burntTokenReserveListIndex[receiver].index;
1116                 burntTokenReserveList[index].amount = burntTokenReserveList[index].amount.add(reserveTokenAmount);
1117             } else {
1118                 burntTokenReserveList.push(TokenReserves({
1119                     lender: receiver,
1120                     amount: reserveTokenAmount
1121                 }));
1122                 burntTokenReserveListIndex[receiver] = ListIndex({
1123                     index: burntTokenReserveList.length-1,
1124                     isSet: true
1125                 });
1126             }
1127 
1128             loanAmountPaid = loanAmountAvailableInContract;
1129         }
1130 
1131         _burn(msg.sender, burnAmount, loanAmountPaid, currentPrice);
1132 
1133         if (burntTokenReserveListIndex[msg.sender].isSet || balances[msg.sender] > 0) {
1134             checkpointPrices_[msg.sender] = currentPrice;
1135         } else {
1136             checkpointPrices_[msg.sender] = 0;
1137         }
1138     }
1139 
1140     function _settleInterest()
1141         internal
1142     {
1143         if (lastSettleTime_ != block.timestamp) {
1144             (bool success,) = bZxContract.call.gas(gasleft())(
1145                 abi.encodeWithSignature(
1146                     "payInterestForOracle(address,address)",
1147                     bZxOracle, // (leave as original value)
1148                     loanTokenAddress // same as interestTokenAddress
1149                 )
1150             );
1151             success;
1152             lastSettleTime_ = block.timestamp;
1153         }
1154     }
1155 
1156     function _getNextOwed()
1157         internal
1158         view
1159         returns (address)
1160     {
1161         if (nextOwedLender_ != address(0))
1162             return nextOwedLender_;
1163         else if (burntTokenReserveList.length > 0)
1164             return burntTokenReserveList[0].lender;
1165         else
1166             return address(0);
1167     }
1168 
1169     function _claimLoanToken(
1170         address lender)
1171         internal
1172         returns (uint256)
1173     {
1174         _settleInterest();
1175 
1176         if (!burntTokenReserveListIndex[lender].isSet)
1177             return 0;
1178 
1179         uint256 index = burntTokenReserveListIndex[lender].index;
1180         uint256 currentPrice = _tokenPrice(_totalAssetSupply(0));
1181 
1182         uint256 claimAmount = burntTokenReserveList[index].amount.mul(currentPrice).div(10**18);
1183         if (claimAmount == 0)
1184             return 0;
1185 
1186         uint256 availableAmount = ERC20(loanTokenAddress).balanceOf(address(this));
1187         if (availableAmount == 0) {
1188             return 0;
1189         }
1190 
1191         uint256 claimTokenAmount;
1192         if (claimAmount <= availableAmount) {
1193             claimTokenAmount = burntTokenReserveList[index].amount;
1194             _removeFromList(lender, index);
1195         } else {
1196             claimAmount = availableAmount;
1197             claimTokenAmount = claimAmount.mul(10**18).div(currentPrice);
1198 
1199             // prevents less than 10 being left in burntTokenReserveList[index].amount
1200             if (claimTokenAmount.add(10) < burntTokenReserveList[index].amount) {
1201                 burntTokenReserveList[index].amount = burntTokenReserveList[index].amount.sub(claimTokenAmount);
1202             } else {
1203                 _removeFromList(lender, index);
1204             }
1205         }
1206 
1207         require(ERC20(loanTokenAddress).transfer(
1208             lender,
1209             claimAmount
1210         ), "transfer failed");
1211 
1212         if (burntTokenReserveListIndex[lender].isSet || balances[lender] > 0) {
1213             checkpointPrices_[lender] = currentPrice;
1214         } else {
1215             checkpointPrices_[lender] = 0;
1216         }
1217 
1218         burntTokenReserved = burntTokenReserved > claimTokenAmount ?
1219             burntTokenReserved.sub(claimTokenAmount) :
1220             0;
1221 
1222         emit Claim(
1223             lender,
1224             claimTokenAmount,
1225             claimAmount,
1226             burntTokenReserveListIndex[lender].isSet ?
1227                 burntTokenReserveList[burntTokenReserveListIndex[lender].index].amount :
1228                 0,
1229             currentPrice
1230         );
1231 
1232         return claimAmount;
1233     }
1234 
1235     function _borrowToken(
1236         address msgsender,
1237         uint256 borrowAmount,
1238         uint256 leverageAmount,
1239         address collateralTokenAddress,
1240         address tradeTokenToFillAddress,
1241         bool withdrawOnOpen,
1242         bool calcBorrow)
1243         internal
1244         returns (uint256)
1245     {
1246         if (borrowAmount == 0) {
1247             return 0;
1248         }
1249 
1250         bytes32 loanOrderHash = loanOrderHashes[leverageAmount];
1251         LoanData memory loanData = loanOrderData[loanOrderHash];
1252         require(loanData.initialMarginAmount != 0, "invalid leverage");
1253 
1254         _settleInterest();
1255 
1256         uint256 interestRate;
1257         if (calcBorrow) {
1258             interestRate = _nextLoanInterestRate(
1259                 borrowAmount // escrowAmount
1260                     .mul(10**20)
1261                     .div(loanData.initialMarginAmount)
1262             );
1263 
1264             borrowAmount = _getBorrowAmount(
1265                 loanData.initialMarginAmount,
1266                 borrowAmount, // escrowAmount,
1267                 interestRate,
1268                 loanData.maxDurationUnixTimestampSec,
1269                 withdrawOnOpen
1270             );
1271         } else {
1272             interestRate = _nextLoanInterestRate(borrowAmount);
1273         }
1274 
1275         return _borrowTokenFinal(
1276             msgsender,
1277             loanOrderHash,
1278             borrowAmount,
1279             interestRate,
1280             collateralTokenAddress,
1281             tradeTokenToFillAddress,
1282             withdrawOnOpen
1283         );
1284     }
1285 
1286     // returns borrowAmount
1287     function _borrowTokenFinal(
1288         address msgsender,
1289         bytes32 loanOrderHash,
1290         uint256 borrowAmount,
1291         uint256 interestRate,
1292         address collateralTokenAddress,
1293         address tradeTokenToFillAddress,
1294         bool withdrawOnOpen)
1295         internal
1296         returns (uint256)
1297     {
1298         //require(ERC20(loanTokenAddress).balanceOf(address(this)) >= borrowAmount, "insufficient loan supply");
1299         uint256 availableToBorrow = ERC20(loanTokenAddress).balanceOf(address(this));
1300         if (availableToBorrow == 0)
1301             return 0;
1302 
1303         uint256 reservedSupply = totalReservedSupply();
1304         if (availableToBorrow > reservedSupply) {
1305             availableToBorrow = availableToBorrow.sub(reservedSupply);
1306         } else {
1307             return 0;
1308         }
1309 
1310         if (borrowAmount > availableToBorrow) {
1311             borrowAmount = availableToBorrow;
1312         }
1313 
1314         // re-up the BZxVault spend approval if needed
1315         uint256 tempAllowance = ERC20(loanTokenAddress).allowance(address(this), bZxVault);
1316         if (tempAllowance < borrowAmount) {
1317             if (tempAllowance > 0) {
1318                 // reset approval to 0
1319                 require(ERC20(loanTokenAddress).approve(bZxVault, 0), "approval failed");
1320             }
1321 
1322             require(ERC20(loanTokenAddress).approve(bZxVault, MAX_UINT), "approval failed");
1323         }
1324 
1325         require(IBZx(bZxContract).updateLoanAsLender(
1326             loanOrderHash,
1327             borrowAmount,
1328             interestRate.div(365),
1329             block.timestamp+1),
1330             "updateLoan failed"
1331         );
1332 
1333         require (IBZx(bZxContract).takeLoanOrderOnChainAsTraderByDelegate(
1334             msgsender,
1335             loanOrderHash,
1336             collateralTokenAddress,
1337             borrowAmount,
1338             tradeTokenToFillAddress,
1339             withdrawOnOpen) == borrowAmount,
1340             "takeLoan failed"
1341         );
1342 
1343         // update total borrowed amount outstanding in loans
1344         totalAssetBorrow = totalAssetBorrow.add(borrowAmount);
1345 
1346         // checkpoint supply since the base protocol borrow stats have changed
1347         checkpointSupply_ = _totalAssetSupply(0);
1348 
1349         if (burntTokenReserveList.length > 0) {
1350             _claimLoanToken(_getNextOwed());
1351             _claimLoanToken(msgsender);
1352         }
1353 
1354         emit Borrow(
1355             msgsender,
1356             borrowAmount,
1357             interestRate,
1358             collateralTokenAddress,
1359             tradeTokenToFillAddress,
1360             withdrawOnOpen
1361         );
1362 
1363         return borrowAmount;
1364     }
1365 
1366     function _removeFromList(
1367         address lender,
1368         uint256 index)
1369         internal
1370     {
1371         // remove lender from burntToken list
1372         if (burntTokenReserveList.length > 1) {
1373             // replace item in list with last item in array
1374             burntTokenReserveList[index] = burntTokenReserveList[burntTokenReserveList.length - 1];
1375 
1376             // update the position of this replacement
1377             burntTokenReserveListIndex[burntTokenReserveList[index].lender].index = index;
1378         }
1379 
1380         // trim array and clear storage
1381         burntTokenReserveList.length--;
1382         burntTokenReserveListIndex[lender].index = 0;
1383         burntTokenReserveListIndex[lender].isSet = false;
1384 
1385         if (lender == nextOwedLender_) {
1386             nextOwedLender_ = address(0);
1387         }
1388     }
1389 
1390 
1391     /* Internal View functions */
1392 
1393     function _tokenPrice(
1394         uint256 assetSupply)
1395         internal
1396         view
1397         returns (uint256)
1398     {
1399         uint256 totalTokenSupply = totalSupply_.add(burntTokenReserved);
1400 
1401         return totalTokenSupply > 0 ?
1402             assetSupply
1403                 .mul(10**18)
1404                 .div(totalTokenSupply) : initialPrice;
1405     }
1406 
1407     function _protocolInterestRate(
1408         uint256 assetSupply)
1409         internal
1410         view
1411         returns (uint256)
1412     {
1413         uint256 interestRate;
1414         if (totalAssetBorrow > 0) {
1415             (,uint256 interestOwedPerDay,) = _getAllInterest();
1416             interestRate = interestOwedPerDay
1417                 .mul(10**20)
1418                 .div(totalAssetBorrow)
1419                 .mul(365)
1420                 .mul(checkpointSupply_)
1421                 .div(assetSupply);
1422         } else {
1423             interestRate = baseRate;
1424         }
1425 
1426         return interestRate;
1427     }
1428 
1429     // next loan interest adjustment
1430     function _nextLoanInterestRate(
1431         uint256 newBorrowAmount)
1432         internal
1433         view
1434         returns (uint256 nextRate)
1435     {
1436         uint256 assetSupply = totalAssetSupply();
1437 
1438         uint256 utilizationRate = _getUtilizationRate(assetSupply)
1439             .add(newBorrowAmount > 0 ?
1440                 newBorrowAmount
1441                 .mul(10**20)
1442                 .div(assetSupply) : 0);
1443 
1444         uint256 minRate = baseRate;
1445         uint256 maxRate = rateMultiplier.add(baseRate);
1446 
1447         if (utilizationRate > 90 ether) {
1448             // scale rate proportionally up to 100%
1449 
1450             utilizationRate = utilizationRate.sub(90 ether);
1451             if (utilizationRate > 10 ether)
1452                 utilizationRate = 10 ether;
1453 
1454             maxRate = maxRate
1455                 .mul(90)
1456                 .div(100);
1457 
1458             nextRate = utilizationRate
1459                 .mul(SafeMath.sub(100 ether, maxRate))
1460                 .div(10 ether)
1461                 .add(maxRate);
1462         } else {
1463             nextRate = utilizationRate
1464                 .mul(rateMultiplier)
1465                 .div(10**20)
1466                 .add(baseRate);
1467 
1468             if (nextRate < minRate)
1469                 nextRate = minRate;
1470             else if (nextRate > maxRate)
1471                 nextRate = maxRate;
1472         }
1473 
1474         return nextRate;
1475     }
1476 
1477     function _getAllInterest()
1478         internal
1479         view
1480         returns (
1481             uint256 interestPaidSoFar,
1482             uint256 interestOwedPerDay,
1483             uint256 interestUnPaid)
1484     {
1485         // these values don't account for any fees retained by the oracle, so we account for it elsewhere with spreadMultiplier
1486         (interestPaidSoFar,,interestOwedPerDay,interestUnPaid) = IBZx(bZxContract).getLenderInterestForOracle(
1487             address(this),
1488             bZxOracle, // (leave as original value)
1489             loanTokenAddress // same as interestTokenAddress
1490         );
1491     }
1492 
1493     function _getBorrowAmount(
1494         uint256 marginAmount,
1495         uint256 escrowAmount,
1496         uint256 interestRate,
1497         uint256 maxDuration,
1498         bool withdrawOnOpen)
1499         internal
1500         pure
1501         returns (uint256)
1502     {
1503         if (withdrawOnOpen) {
1504             // adjust for over-collateralized loan (initial margin + 100% margin)
1505             marginAmount = marginAmount.add(10**20);
1506         }
1507 
1508         // assumes that loan, collateral, and interest token are the same
1509         return escrowAmount
1510             .mul(10**40)
1511             .div(_adjustValue(
1512                 interestRate,
1513                 maxDuration,
1514                 marginAmount))
1515             .div(marginAmount);
1516     }
1517 
1518     function _adjustValue(
1519         uint256 interestRate,
1520         uint256 maxDuration,
1521         uint256 marginAmount)
1522         internal
1523         pure
1524         returns (uint256)
1525     {
1526         return maxDuration > 0 ?
1527             interestRate
1528                 .mul(10**20)
1529                 .div(31536000) // 86400 * 365
1530                 .mul(maxDuration)
1531                 .div(marginAmount)
1532                 .add(10**20) :
1533             10**20;
1534     }
1535 
1536     function _getUtilizationRate(
1537         uint256 assetSupply)
1538         internal
1539         view
1540         returns (uint256)
1541     {
1542         if (totalAssetBorrow > 0 && assetSupply > 0) {
1543             // U = total_borrow / total_supply
1544             return totalAssetBorrow
1545                 .mul(10**20)
1546                 .div(assetSupply);
1547         } else {
1548             return 0;
1549         }
1550     }
1551 
1552     function _totalAssetSupply(
1553         uint256 interestUnPaid)
1554         internal
1555         view
1556         returns (uint256)
1557     {
1558         return totalSupply_.add(burntTokenReserved) > 0 ?
1559             ERC20(loanTokenAddress).balanceOf(address(this))
1560                 .add(totalAssetBorrow)
1561                 .add(interestUnPaid) : 0;
1562     }
1563 
1564 
1565     /* Oracle-Only functions */
1566 
1567     // called only by BZxOracle when a loan is partially or fully closed
1568     function closeLoanNotifier(
1569         BZxObjects.LoanOrder memory loanOrder,
1570         BZxObjects.LoanPosition memory loanPosition,
1571         address loanCloser,
1572         uint256 closeAmount,
1573         bool /* isLiquidation */)
1574         public
1575         onlyOracle
1576         returns (bool)
1577     {
1578         LoanData memory loanData = loanOrderData[loanOrder.loanOrderHash];
1579         if (loanData.loanOrderHash == loanOrder.loanOrderHash) {
1580 
1581             totalAssetBorrow = totalAssetBorrow > closeAmount ?
1582                 totalAssetBorrow.sub(closeAmount) : 0;
1583 
1584             if (burntTokenReserveList.length > 0) {
1585                 _claimLoanToken(_getNextOwed());
1586             } else {
1587                 _settleInterest();
1588             }
1589 
1590             if (closeAmount == 0)
1591                 return true;
1592 
1593             // checkpoint supply since the base protocol borrow stats have changed
1594             checkpointSupply_ = _totalAssetSupply(0);
1595 
1596             if (loanCloser != loanPosition.trader) {
1597 
1598                 address tradeTokenAddress = iTokenizedRegistry(tokenizedRegistry).getTokenAsset(
1599                     loanPosition.trader,
1600                     2 // tokenType=pToken
1601                 );
1602 
1603                 if (tradeTokenAddress != address(0)) {
1604 
1605                     uint256 escrowAmount = ERC20(loanTokenAddress).balanceOf(loanPosition.trader);
1606 
1607                     if (escrowAmount > 0) {
1608                         (bool success,) = address(this).call.gas(gasleft())(
1609                             abi.encodeWithSignature(
1610                                 "rolloverPosition(address,uint256,uint256,address)",
1611                                 loanPosition.trader,
1612                                 loanData.leverageAmount,
1613                                 escrowAmount,
1614                                 tradeTokenAddress
1615                             )
1616                         );
1617                         success;
1618                     }
1619                 }
1620             }
1621 
1622             return true;
1623         } else {
1624             return false;
1625         }
1626     }
1627 
1628 
1629     /* Owner-Only functions */
1630 
1631     function initLeverage(
1632         uint256[4] memory orderParams) // leverageAmount, initialMarginAmount, maintenanceMarginAmount, maxDurationUnixTimestampSec
1633         public
1634         onlyOwner
1635     {
1636         require(loanOrderHashes[orderParams[0]] == 0);
1637 
1638         address[8] memory orderAddresses = [
1639             address(this), // makerAddress
1640             loanTokenAddress, // loanTokenAddress
1641             loanTokenAddress, // interestTokenAddress (same as loanToken)
1642             address(0), // collateralTokenAddress
1643             address(0), // feeRecipientAddress
1644             bZxOracle, // (leave as original value)
1645             address(0), // takerAddress
1646             address(0) // tradeTokenToFillAddress
1647         ];
1648 
1649         uint256[11] memory orderValues = [
1650             0, // loanTokenAmount
1651             0, // interestAmountPerDay
1652             orderParams[1], // initialMarginAmount,
1653             orderParams[2], // maintenanceMarginAmount,
1654             0, // lenderRelayFee
1655             0, // traderRelayFee
1656             orderParams[3], // maxDurationUnixTimestampSec,
1657             0, // expirationUnixTimestampSec
1658             0, // makerRole (0 = lender)
1659             0, // withdrawOnOpen
1660             uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) // salt
1661         ];
1662 
1663         bytes32 loanOrderHash = IBZx(bZxContract).pushLoanOrderOnChain(
1664             orderAddresses,
1665             orderValues,
1666             abi.encodePacked(address(this)), // oracleData -> closeLoanNotifier
1667             ""
1668         );
1669         IBZx(bZxContract).setLoanOrderDesc(
1670             loanOrderHash,
1671             name
1672         );
1673         loanOrderData[loanOrderHash] = LoanData({
1674             loanOrderHash: loanOrderHash,
1675             leverageAmount: orderParams[0],
1676             initialMarginAmount: orderParams[1],
1677             maintenanceMarginAmount: orderParams[2],
1678             maxDurationUnixTimestampSec: orderParams[3],
1679             index: leverageList.length
1680         });
1681         loanOrderHashes[orderParams[0]] = loanOrderHash;
1682         leverageList.push(orderParams[0]);
1683     }
1684 
1685     function removeLeverage(
1686         uint256 leverageAmount)
1687         public
1688         onlyOwner
1689     {
1690         bytes32 loanOrderHash = loanOrderHashes[leverageAmount];
1691         require(loanOrderHash != 0);
1692 
1693         if (leverageList.length > 1) {
1694             uint256 index = loanOrderData[loanOrderHash].index;
1695             leverageList[index] = leverageList[leverageList.length - 1];
1696             loanOrderData[loanOrderHashes[leverageList[index]]].index = index;
1697         }
1698         leverageList.length--;
1699 
1700         delete loanOrderHashes[leverageAmount];
1701         delete loanOrderData[loanOrderHash];
1702     }
1703 
1704     // These params should be percentages represented like so: 5% = 5000000000000000000
1705     // rateMultiplier + baseRate can't exceed 100%
1706     function setDemandCurve(
1707         uint256 _baseRate,
1708         uint256 _rateMultiplier)
1709         public
1710         onlyOwner
1711     {
1712         require(rateMultiplier.add(baseRate) <= 10**20);
1713         baseRate = _baseRate;
1714         rateMultiplier = _rateMultiplier;
1715     }
1716 
1717     function setInterestFeePercent(
1718         uint256 _newRate)
1719         public
1720         onlyOwner
1721     {
1722         require(_newRate <= 10**20);
1723         spreadMultiplier = SafeMath.sub(10**20, _newRate);
1724     }
1725 
1726     function setBZxContract(
1727         address _addr)
1728         public
1729         onlyOwner
1730     {
1731         bZxContract = _addr;
1732     }
1733 
1734     function setBZxVault(
1735         address _addr)
1736         public
1737         onlyOwner
1738     {
1739         bZxVault = _addr;
1740     }
1741 
1742     function setBZxOracle(
1743         address _addr)
1744         public
1745         onlyOwner
1746     {
1747         bZxOracle = _addr;
1748     }
1749 
1750     function setTokenizedRegistry(
1751         address _addr)
1752         public
1753         onlyOwner
1754     {
1755         tokenizedRegistry = _addr;
1756     }
1757 
1758     function setWETHContract(
1759         address _addr)
1760         public
1761         onlyOwner
1762     {
1763         wethContract = _addr;
1764     }
1765 
1766     function setInitialPrice(
1767         uint256 _value)
1768         public
1769         onlyOwner
1770     {
1771         require(_value > 0);
1772         initialPrice = _value;
1773     }
1774 
1775     function initialize(
1776         address _bZxContract,
1777         address _bZxVault,
1778         address _bZxOracle,
1779         address _wethContract,
1780         address _loanTokenAddress,
1781         address _tokenizedRegistry,
1782         string memory _name,
1783         string memory _symbol)
1784         public
1785         onlyOwner
1786     {
1787         require (!isInitialized_);
1788 
1789         bZxContract = _bZxContract;
1790         bZxVault = _bZxVault;
1791         bZxOracle = _bZxOracle;
1792         wethContract = _wethContract;
1793         loanTokenAddress = _loanTokenAddress;
1794         tokenizedRegistry = _tokenizedRegistry;
1795 
1796         name = _name;
1797         symbol = _symbol;
1798         decimals = EIP20(loanTokenAddress).decimals();
1799 
1800         spreadMultiplier = SafeMath.sub(10**20, IBZxOracle(_bZxOracle).interestFeePercent());
1801 
1802         initialPrice = 10**18; // starting price of 1
1803 
1804         isInitialized_ = true;
1805     }
1806 }