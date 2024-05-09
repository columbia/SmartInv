1 
2 // File: contracts/interfaces/IPooledStaking.sol
3 
4 pragma solidity ^0.5.0;
5 
6 
7 interface IPooledStaking {
8 
9   function accumulateReward(address contractAddress, uint amount) external;
10 
11   function pushBurn(address contractAddress, uint amount) external;
12 
13   function hasPendingActions() external view returns (bool);
14 
15   function contractStake(address contractAddress) external view returns (uint);
16 
17   function stakerReward(address staker) external view returns (uint);
18 
19   function stakerDeposit(address staker) external view returns (uint);
20 
21   function stakerContractStake(address staker, address contractAddress) external view returns (uint);
22 
23   function withdraw(uint amount) external;
24 
25   function stakerMaxWithdrawable(address stakerAddress) external view returns (uint);
26 
27   function withdrawReward(address stakerAddress) external;
28 }
29 
30 // File: @openzeppelin/contracts/math/SafeMath.sol
31 
32 pragma solidity ^0.5.0;
33 
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations with added overflow
36  * checks.
37  *
38  * Arithmetic operations in Solidity wrap on overflow. This can easily result
39  * in bugs, because programmers usually assume that an overflow raises an
40  * error, which is the standard behavior in high level programming languages.
41  * `SafeMath` restores this intuition by reverting the transaction when an
42  * operation overflows.
43  *
44  * Using this library instead of the unchecked operations eliminates an entire
45  * class of bugs, so it's recommended to use it always.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `+` operator.
53      *
54      * Requirements:
55      * - Addition cannot overflow.
56      */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      * - Subtraction cannot overflow.
85      *
86      * _Available since v2.4.0._
87      */
88     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the multiplication of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `*` operator.
100      *
101      * Requirements:
102      * - Multiplication cannot overflow.
103      */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      * - The divisor cannot be zero.
143      *
144      * _Available since v2.4.0._
145      */
146     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return mod(a, b, "SafeMath: modulo by zero");
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts with custom message when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      *
181      * _Available since v2.4.0._
182      */
183     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
195  * the optional functions; to access them see {ERC20Detailed}.
196  */
197 interface IERC20 {
198     /**
199      * @dev Returns the amount of tokens in existence.
200      */
201     function totalSupply() external view returns (uint256);
202 
203     /**
204      * @dev Returns the amount of tokens owned by `account`.
205      */
206     function balanceOf(address account) external view returns (uint256);
207 
208     /**
209      * @dev Moves `amount` tokens from the caller's account to `recipient`.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transfer(address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Returns the remaining number of tokens that `spender` will be
219      * allowed to spend on behalf of `owner` through {transferFrom}. This is
220      * zero by default.
221      *
222      * This value changes when {approve} or {transferFrom} are called.
223      */
224     function allowance(address owner, address spender) external view returns (uint256);
225 
226     /**
227      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * IMPORTANT: Beware that changing an allowance with this method brings the risk
232      * that someone may use both the old and the new allowance by unfortunate
233      * transaction ordering. One possible solution to mitigate this race
234      * condition is to first reduce the spender's allowance to 0 and set the
235      * desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      *
238      * Emits an {Approval} event.
239      */
240     function approve(address spender, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Moves `amount` tokens from `sender` to `recipient` using the
244      * allowance mechanism. `amount` is then deducted from the caller's
245      * allowance.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * Emits a {Transfer} event.
250      */
251     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Emitted when `value` tokens are moved from one account (`from`) to
255      * another (`to`).
256      *
257      * Note that `value` may be zero.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     /**
262      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
263      * a call to {approve}. `value` is the new allowance.
264      */
265     event Approval(address indexed owner, address indexed spender, uint256 value);
266 }
267 
268 // File: contracts/abstract/INXMMaster.sol
269 
270 /* Copyright (C) 2020 NexusMutual.io
271 
272   This program is free software: you can redistribute it and/or modify
273     it under the terms of the GNU General Public License as published by
274     the Free Software Foundation, either version 3 of the License, or
275     (at your option) any later version.
276 
277   This program is distributed in the hope that it will be useful,
278     but WITHOUT ANY WARRANTY; without even the implied warranty of
279     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
280     GNU General Public License for more details.
281 
282   You should have received a copy of the GNU General Public License
283     along with this program.  If not, see http://www.gnu.org/licenses/ */
284 
285 pragma solidity ^0.5.0;
286 
287 contract INXMMaster {
288 
289   address public tokenAddress;
290 
291   address public owner;
292 
293   uint public pauseTime;
294 
295   function delegateCallBack(bytes32 myid) external;
296 
297   function masterInitialized() public view returns (bool);
298 
299   function isInternal(address _add) public view returns (bool);
300 
301   function isPause() public view returns (bool check);
302 
303   function isOwner(address _add) public view returns (bool);
304 
305   function isMember(address _add) public view returns (bool);
306 
307   function checkIsAuthToGoverned(address _add) public view returns (bool);
308 
309   function updatePauseTime(uint _time) public;
310 
311   function dAppLocker() public view returns (address _add);
312 
313   function dAppToken() public view returns (address _add);
314 
315   function getLatestAddress(bytes2 _contractName) public view returns (address payable contractAddress);
316 }
317 
318 // File: contracts/abstract/Iupgradable.sol
319 
320 pragma solidity ^0.5.0;
321 
322 
323 contract Iupgradable {
324 
325   INXMMaster public ms;
326   address public nxMasterAddress;
327 
328   modifier onlyInternal {
329     require(ms.isInternal(msg.sender));
330     _;
331   }
332 
333   modifier isMemberAndcheckPause {
334     require(ms.isPause() == false && ms.isMember(msg.sender) == true);
335     _;
336   }
337 
338   modifier onlyOwner {
339     require(ms.isOwner(msg.sender));
340     _;
341   }
342 
343   modifier checkPause {
344     require(ms.isPause() == false);
345     _;
346   }
347 
348   modifier isMember {
349     require(ms.isMember(msg.sender), "Not member");
350     _;
351   }
352 
353   /**
354    * @dev Iupgradable Interface to update dependent contract address
355    */
356   function changeDependentContractAddress() public;
357 
358   /**
359    * @dev change master address
360    * @param _masterAddress is the new address
361    */
362   function changeMasterAddress(address _masterAddress) public {
363     if (address(ms) != address(0)) {
364       require(address(ms) == msg.sender, "Not master");
365     }
366 
367     ms = INXMMaster(_masterAddress);
368     nxMasterAddress = _masterAddress;
369   }
370 
371 }
372 
373 // File: contracts/modules/cover/QuotationData.sol
374 
375 /* Copyright (C) 2020 NexusMutual.io
376 
377   This program is free software: you can redistribute it and/or modify
378     it under the terms of the GNU General Public License as published by
379     the Free Software Foundation, either version 3 of the License, or
380     (at your option) any later version.
381 
382   This program is distributed in the hope that it will be useful,
383     but WITHOUT ANY WARRANTY; without even the implied warranty of
384     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
385     GNU General Public License for more details.
386 
387   You should have received a copy of the GNU General Public License
388     along with this program.  If not, see http://www.gnu.org/licenses/ */
389 
390 pragma solidity ^0.5.0;
391 
392 
393 
394 contract QuotationData is Iupgradable {
395   using SafeMath for uint;
396 
397   enum HCIDStatus {NA, kycPending, kycPass, kycFailedOrRefunded, kycPassNoCover}
398 
399   enum CoverStatus {Active, ClaimAccepted, ClaimDenied, CoverExpired, ClaimSubmitted, Requested}
400 
401   struct Cover {
402     address payable memberAddress;
403     bytes4 currencyCode;
404     uint sumAssured;
405     uint16 coverPeriod;
406     uint validUntil;
407     address scAddress;
408     uint premiumNXM;
409   }
410 
411   struct HoldCover {
412     uint holdCoverId;
413     address payable userAddress;
414     address scAddress;
415     bytes4 coverCurr;
416     uint[] coverDetails;
417     uint16 coverPeriod;
418   }
419 
420   address public authQuoteEngine;
421 
422   mapping(bytes4 => uint) internal currencyCSA;
423   mapping(address => uint[]) internal userCover;
424   mapping(address => uint[]) public userHoldedCover;
425   mapping(address => bool) public refundEligible;
426   mapping(address => mapping(bytes4 => uint)) internal currencyCSAOfSCAdd;
427   mapping(uint => uint8) public coverStatus;
428   mapping(uint => uint) public holdedCoverIDStatus;
429   mapping(uint => bool) public timestampRepeated;
430 
431 
432   Cover[] internal allCovers;
433   HoldCover[] internal allCoverHolded;
434 
435   uint public stlp;
436   uint public stl;
437   uint public pm;
438   uint public minDays;
439   uint public tokensRetained;
440   address public kycAuthAddress;
441 
442   event CoverDetailsEvent(
443     uint indexed cid,
444     address scAdd,
445     uint sumAssured,
446     uint expiry,
447     uint premium,
448     uint premiumNXM,
449     bytes4 curr
450   );
451 
452   event CoverStatusEvent(uint indexed cid, uint8 statusNum);
453 
454   constructor(address _authQuoteAdd, address _kycAuthAdd) public {
455     authQuoteEngine = _authQuoteAdd;
456     kycAuthAddress = _kycAuthAdd;
457     stlp = 90;
458     stl = 100;
459     pm = 30;
460     minDays = 30;
461     tokensRetained = 10;
462     allCovers.push(Cover(address(0), "0x00", 0, 0, 0, address(0), 0));
463     uint[] memory arr = new uint[](1);
464     allCoverHolded.push(HoldCover(0, address(0), address(0), 0x00, arr, 0));
465 
466   }
467 
468   /// @dev Adds the amount in Total Sum Assured of a given currency of a given smart contract address.
469   /// @param _add Smart Contract Address.
470   /// @param _amount Amount to be added.
471   function addInTotalSumAssuredSC(address _add, bytes4 _curr, uint _amount) external onlyInternal {
472     currencyCSAOfSCAdd[_add][_curr] = currencyCSAOfSCAdd[_add][_curr].add(_amount);
473   }
474 
475   /// @dev Subtracts the amount from Total Sum Assured of a given currency and smart contract address.
476   /// @param _add Smart Contract Address.
477   /// @param _amount Amount to be subtracted.
478   function subFromTotalSumAssuredSC(address _add, bytes4 _curr, uint _amount) external onlyInternal {
479     currencyCSAOfSCAdd[_add][_curr] = currencyCSAOfSCAdd[_add][_curr].sub(_amount);
480   }
481 
482   /// @dev Subtracts the amount from Total Sum Assured of a given currency.
483   /// @param _curr Currency Name.
484   /// @param _amount Amount to be subtracted.
485   function subFromTotalSumAssured(bytes4 _curr, uint _amount) external onlyInternal {
486     currencyCSA[_curr] = currencyCSA[_curr].sub(_amount);
487   }
488 
489   /// @dev Adds the amount in Total Sum Assured of a given currency.
490   /// @param _curr Currency Name.
491   /// @param _amount Amount to be added.
492   function addInTotalSumAssured(bytes4 _curr, uint _amount) external onlyInternal {
493     currencyCSA[_curr] = currencyCSA[_curr].add(_amount);
494   }
495 
496   /// @dev sets bit for timestamp to avoid replay attacks.
497   function setTimestampRepeated(uint _timestamp) external onlyInternal {
498     timestampRepeated[_timestamp] = true;
499   }
500 
501   /// @dev Creates a blank new cover.
502   function addCover(
503     uint16 _coverPeriod,
504     uint _sumAssured,
505     address payable _userAddress,
506     bytes4 _currencyCode,
507     address _scAddress,
508     uint premium,
509     uint premiumNXM
510   )
511   external
512   onlyInternal
513   {
514     uint expiryDate = now.add(uint(_coverPeriod).mul(1 days));
515     allCovers.push(Cover(_userAddress, _currencyCode,
516       _sumAssured, _coverPeriod, expiryDate, _scAddress, premiumNXM));
517     uint cid = allCovers.length.sub(1);
518     userCover[_userAddress].push(cid);
519     emit CoverDetailsEvent(cid, _scAddress, _sumAssured, expiryDate, premium, premiumNXM, _currencyCode);
520   }
521 
522   /// @dev create holded cover which will process after verdict of KYC.
523   function addHoldCover(
524     address payable from,
525     address scAddress,
526     bytes4 coverCurr,
527     uint[] calldata coverDetails,
528     uint16 coverPeriod
529   )
530   external
531   onlyInternal
532   {
533     uint holdedCoverLen = allCoverHolded.length;
534     holdedCoverIDStatus[holdedCoverLen] = uint(HCIDStatus.kycPending);
535     allCoverHolded.push(HoldCover(holdedCoverLen, from, scAddress,
536       coverCurr, coverDetails, coverPeriod));
537     userHoldedCover[from].push(allCoverHolded.length.sub(1));
538 
539   }
540 
541   ///@dev sets refund eligible bit.
542   ///@param _add user address.
543   ///@param status indicates if user have pending kyc.
544   function setRefundEligible(address _add, bool status) external onlyInternal {
545     refundEligible[_add] = status;
546   }
547 
548   /// @dev to set current status of particular holded coverID (1 for not completed KYC,
549   /// 2 for KYC passed, 3 for failed KYC or full refunded,
550   /// 4 for KYC completed but cover not processed)
551   function setHoldedCoverIDStatus(uint holdedCoverID, uint status) external onlyInternal {
552     holdedCoverIDStatus[holdedCoverID] = status;
553   }
554 
555   /**
556    * @dev to set address of kyc authentication
557    * @param _add is the new address
558    */
559   function setKycAuthAddress(address _add) external onlyInternal {
560     kycAuthAddress = _add;
561   }
562 
563   /// @dev Changes authorised address for generating quote off chain.
564   function changeAuthQuoteEngine(address _add) external onlyInternal {
565     authQuoteEngine = _add;
566   }
567 
568   /**
569    * @dev Gets Uint Parameters of a code
570    * @param code whose details we want
571    * @return string value of the code
572    * @return associated amount (time or perc or value) to the code
573    */
574   function getUintParameters(bytes8 code) external view returns (bytes8 codeVal, uint val) {
575     codeVal = code;
576 
577     if (code == "STLP") {
578       val = stlp;
579 
580     } else if (code == "STL") {
581 
582       val = stl;
583 
584     } else if (code == "PM") {
585 
586       val = pm;
587 
588     } else if (code == "QUOMIND") {
589 
590       val = minDays;
591 
592     } else if (code == "QUOTOK") {
593 
594       val = tokensRetained;
595 
596     }
597 
598   }
599 
600   /// @dev Gets Product details.
601   /// @return  _minDays minimum cover period.
602   /// @return  _PM Profit margin.
603   /// @return  _STL short term Load.
604   /// @return  _STLP short term load period.
605   function getProductDetails()
606   external
607   view
608   returns (
609     uint _minDays,
610     uint _pm,
611     uint _stl,
612     uint _stlp
613   )
614   {
615 
616     _minDays = minDays;
617     _pm = pm;
618     _stl = stl;
619     _stlp = stlp;
620   }
621 
622   /// @dev Gets total number covers created till date.
623   function getCoverLength() external view returns (uint len) {
624     return (allCovers.length);
625   }
626 
627   /// @dev Gets Authorised Engine address.
628   function getAuthQuoteEngine() external view returns (address _add) {
629     _add = authQuoteEngine;
630   }
631 
632   /// @dev Gets the Total Sum Assured amount of a given currency.
633   function getTotalSumAssured(bytes4 _curr) external view returns (uint amount) {
634     amount = currencyCSA[_curr];
635   }
636 
637   /// @dev Gets all the Cover ids generated by a given address.
638   /// @param _add User's address.
639   /// @return allCover array of covers.
640   function getAllCoversOfUser(address _add) external view returns (uint[] memory allCover) {
641     return (userCover[_add]);
642   }
643 
644   /// @dev Gets total number of covers generated by a given address
645   function getUserCoverLength(address _add) external view returns (uint len) {
646     len = userCover[_add].length;
647   }
648 
649   /// @dev Gets the status of a given cover.
650   function getCoverStatusNo(uint _cid) external view returns (uint8) {
651     return coverStatus[_cid];
652   }
653 
654   /// @dev Gets the Cover Period (in days) of a given cover.
655   function getCoverPeriod(uint _cid) external view returns (uint32 cp) {
656     cp = allCovers[_cid].coverPeriod;
657   }
658 
659   /// @dev Gets the Sum Assured Amount of a given cover.
660   function getCoverSumAssured(uint _cid) external view returns (uint sa) {
661     sa = allCovers[_cid].sumAssured;
662   }
663 
664   /// @dev Gets the Currency Name in which a given cover is assured.
665   function getCurrencyOfCover(uint _cid) external view returns (bytes4 curr) {
666     curr = allCovers[_cid].currencyCode;
667   }
668 
669   /// @dev Gets the validity date (timestamp) of a given cover.
670   function getValidityOfCover(uint _cid) external view returns (uint date) {
671     date = allCovers[_cid].validUntil;
672   }
673 
674   /// @dev Gets Smart contract address of cover.
675   function getscAddressOfCover(uint _cid) external view returns (uint, address) {
676     return (_cid, allCovers[_cid].scAddress);
677   }
678 
679   /// @dev Gets the owner address of a given cover.
680   function getCoverMemberAddress(uint _cid) external view returns (address payable _add) {
681     _add = allCovers[_cid].memberAddress;
682   }
683 
684   /// @dev Gets the premium amount of a given cover in NXM.
685   function getCoverPremiumNXM(uint _cid) external view returns (uint _premiumNXM) {
686     _premiumNXM = allCovers[_cid].premiumNXM;
687   }
688 
689   /// @dev Provides the details of a cover Id
690   /// @param _cid cover Id
691   /// @return memberAddress cover user address.
692   /// @return scAddress smart contract Address
693   /// @return currencyCode currency of cover
694   /// @return sumAssured sum assured of cover
695   /// @return premiumNXM premium in NXM
696   function getCoverDetailsByCoverID1(
697     uint _cid
698   )
699   external
700   view
701   returns (
702     uint cid,
703     address _memberAddress,
704     address _scAddress,
705     bytes4 _currencyCode,
706     uint _sumAssured,
707     uint premiumNXM
708   )
709   {
710     return (
711     _cid,
712     allCovers[_cid].memberAddress,
713     allCovers[_cid].scAddress,
714     allCovers[_cid].currencyCode,
715     allCovers[_cid].sumAssured,
716     allCovers[_cid].premiumNXM
717     );
718   }
719 
720   /// @dev Provides details of a cover Id
721   /// @param _cid cover Id
722   /// @return status status of cover.
723   /// @return sumAssured Sum assurance of cover.
724   /// @return coverPeriod Cover Period of cover (in days).
725   /// @return validUntil is validity of cover.
726   function getCoverDetailsByCoverID2(
727     uint _cid
728   )
729   external
730   view
731   returns (
732     uint cid,
733     uint8 status,
734     uint sumAssured,
735     uint16 coverPeriod,
736     uint validUntil
737   )
738   {
739 
740     return (
741     _cid,
742     coverStatus[_cid],
743     allCovers[_cid].sumAssured,
744     allCovers[_cid].coverPeriod,
745     allCovers[_cid].validUntil
746     );
747   }
748 
749   /// @dev Provides details of a holded cover Id
750   /// @param _hcid holded cover Id
751   /// @return scAddress SmartCover address of cover.
752   /// @return coverCurr currency of cover.
753   /// @return coverPeriod Cover Period of cover (in days).
754   function getHoldedCoverDetailsByID1(
755     uint _hcid
756   )
757   external
758   view
759   returns (
760     uint hcid,
761     address scAddress,
762     bytes4 coverCurr,
763     uint16 coverPeriod
764   )
765   {
766     return (
767     _hcid,
768     allCoverHolded[_hcid].scAddress,
769     allCoverHolded[_hcid].coverCurr,
770     allCoverHolded[_hcid].coverPeriod
771     );
772   }
773 
774   /// @dev Gets total number holded covers created till date.
775   function getUserHoldedCoverLength(address _add) external view returns (uint) {
776     return userHoldedCover[_add].length;
777   }
778 
779   /// @dev Gets holded cover index by index of user holded covers.
780   function getUserHoldedCoverByIndex(address _add, uint index) external view returns (uint) {
781     return userHoldedCover[_add][index];
782   }
783 
784   /// @dev Provides the details of a holded cover Id
785   /// @param _hcid holded cover Id
786   /// @return memberAddress holded cover user address.
787   /// @return coverDetails array contains SA, Cover Currency Price,Price in NXM, Expiration time of Qoute.
788   function getHoldedCoverDetailsByID2(
789     uint _hcid
790   )
791   external
792   view
793   returns (
794     uint hcid,
795     address payable memberAddress,
796     uint[] memory coverDetails
797   )
798   {
799     return (
800     _hcid,
801     allCoverHolded[_hcid].userAddress,
802     allCoverHolded[_hcid].coverDetails
803     );
804   }
805 
806   /// @dev Gets the Total Sum Assured amount of a given currency and smart contract address.
807   function getTotalSumAssuredSC(address _add, bytes4 _curr) external view returns (uint amount) {
808     amount = currencyCSAOfSCAdd[_add][_curr];
809   }
810 
811   //solhint-disable-next-line
812   function changeDependentContractAddress() public {}
813 
814   /// @dev Changes the status of a given cover.
815   /// @param _cid cover Id.
816   /// @param _stat New status.
817   function changeCoverStatusNo(uint _cid, uint8 _stat) public onlyInternal {
818     coverStatus[_cid] = _stat;
819     emit CoverStatusEvent(_cid, _stat);
820   }
821 
822   /**
823    * @dev Updates Uint Parameters of a code
824    * @param code whose details we want to update
825    * @param val value to set
826    */
827   function updateUintParameters(bytes8 code, uint val) public {
828 
829     require(ms.checkIsAuthToGoverned(msg.sender));
830     if (code == "STLP") {
831       _changeSTLP(val);
832 
833     } else if (code == "STL") {
834 
835       _changeSTL(val);
836 
837     } else if (code == "PM") {
838 
839       _changePM(val);
840 
841     } else if (code == "QUOMIND") {
842 
843       _changeMinDays(val);
844 
845     } else if (code == "QUOTOK") {
846 
847       _setTokensRetained(val);
848 
849     } else {
850 
851       revert("Invalid param code");
852     }
853 
854   }
855 
856   /// @dev Changes the existing Profit Margin value
857   function _changePM(uint _pm) internal {
858     pm = _pm;
859   }
860 
861   /// @dev Changes the existing Short Term Load Period (STLP) value.
862   function _changeSTLP(uint _stlp) internal {
863     stlp = _stlp;
864   }
865 
866   /// @dev Changes the existing Short Term Load (STL) value.
867   function _changeSTL(uint _stl) internal {
868     stl = _stl;
869   }
870 
871   /// @dev Changes the existing Minimum cover period (in days)
872   function _changeMinDays(uint _days) internal {
873     minDays = _days;
874   }
875 
876   /**
877    * @dev to set the the amount of tokens retained
878    * @param val is the amount retained
879    */
880   function _setTokensRetained(uint val) internal {
881     tokensRetained = val;
882   }
883 }
884 
885 // File: contracts/interfaces/Exchange.sol
886 
887 pragma solidity ^0.5.0;
888 
889 
890 interface Factory {
891   function getExchange(address token) external view returns (address);
892 
893   function getToken(address exchange) external view returns (address);
894 }
895 
896 
897 interface Exchange {
898 
899   function getEthToTokenInputPrice(uint256 ethSold) external view returns (uint256);
900 
901   function getTokenToEthInputPrice(uint256 tokensSold) external view returns (uint256);
902 
903   function ethToTokenSwapInput(uint256 minTokens, uint256 deadline) external payable returns (uint256);
904 
905   function ethToTokenTransferInput(uint256 minTokens, uint256 deadline, address recipient) external payable returns (uint256);
906 
907   function tokenToEthSwapInput(uint256 tokensSold, uint256 minEth, uint256 deadline) external payable returns (uint256);
908 
909   function tokenToEthTransferInput(uint256 tokensSold, uint256 minEth, uint256 deadline, address recipient) external payable returns (uint256);
910 
911   function tokenToTokenSwapInput(
912     uint256 tokensSold,
913     uint256 minTokensBought,
914     uint256 minEthBought,
915     uint256 deadline,
916     address tokenAddress
917   ) external returns (uint256);
918 
919   function tokenToTokenTransferInput(
920     uint256 tokensSold,
921     uint256 minTokensBought,
922     uint256 minEthBought,
923     uint256 deadline,
924     address recipient,
925     address tokenAddress
926   ) external returns (uint256);
927 }
928 
929 // File: contracts/modules/capital/PoolData.sol
930 
931 /* Copyright (C) 2020 NexusMutual.io
932 
933   This program is free software: you can redistribute it and/or modify
934     it under the terms of the GNU General Public License as published by
935     the Free Software Foundation, either version 3 of the License, or
936     (at your option) any later version.
937 
938   This program is distributed in the hope that it will be useful,
939     but WITHOUT ANY WARRANTY; without even the implied warranty of
940     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
941     GNU General Public License for more details.
942 
943   You should have received a copy of the GNU General Public License
944     along with this program.  If not, see http://www.gnu.org/licenses/ */
945 
946 pragma solidity ^0.5.0;
947 
948 
949 
950 contract DSValue {
951   function peek() public view returns (bytes32, bool);
952 
953   function read() public view returns (bytes32);
954 }
955 
956 contract PoolData is Iupgradable {
957   using SafeMath for uint;
958 
959   struct ApiId {
960     bytes4 typeOf;
961     bytes4 currency;
962     uint id;
963     uint64 dateAdd;
964     uint64 dateUpd;
965   }
966 
967   struct CurrencyAssets {
968     address currAddress;
969     uint baseMin;
970     uint varMin;
971   }
972 
973   struct InvestmentAssets {
974     address currAddress;
975     bool status;
976     uint64 minHoldingPercX100;
977     uint64 maxHoldingPercX100;
978     uint8 decimals;
979   }
980 
981   struct IARankDetails {
982     bytes4 maxIACurr;
983     uint64 maxRate;
984     bytes4 minIACurr;
985     uint64 minRate;
986   }
987 
988   struct McrData {
989     uint mcrPercx100;
990     uint mcrEther;
991     uint vFull; //Pool funds
992     uint64 date;
993   }
994 
995   IARankDetails[] internal allIARankDetails;
996   McrData[] public allMCRData;
997 
998   bytes4[] internal allInvestmentCurrencies;
999   bytes4[] internal allCurrencies;
1000   bytes32[] public allAPIcall;
1001   mapping(bytes32 => ApiId) public allAPIid;
1002   mapping(uint64 => uint) internal datewiseId;
1003   mapping(bytes16 => uint) internal currencyLastIndex;
1004   mapping(bytes4 => CurrencyAssets) internal allCurrencyAssets;
1005   mapping(bytes4 => InvestmentAssets) internal allInvestmentAssets;
1006   mapping(bytes4 => uint) internal caAvgRate;
1007   mapping(bytes4 => uint) internal iaAvgRate;
1008 
1009   address public notariseMCR;
1010   address public daiFeedAddress;
1011   uint private constant DECIMAL1E18 = uint(10) ** 18;
1012   uint public uniswapDeadline;
1013   uint public liquidityTradeCallbackTime;
1014   uint public lastLiquidityTradeTrigger;
1015   uint64 internal lastDate;
1016   uint public variationPercX100;
1017   uint public iaRatesTime;
1018   uint public minCap;
1019   uint public mcrTime;
1020   uint public a;
1021   uint public shockParameter;
1022   uint public c;
1023   uint public mcrFailTime;
1024   uint public ethVolumeLimit;
1025   uint public capReached;
1026   uint public capacityLimit;
1027 
1028   constructor(address _notariseAdd, address _daiFeedAdd, address _daiAdd) public {
1029     notariseMCR = _notariseAdd;
1030     daiFeedAddress = _daiFeedAdd;
1031     c = 5800000;
1032     a = 1028;
1033     mcrTime = 24 hours;
1034     mcrFailTime = 6 hours;
1035     allMCRData.push(McrData(0, 0, 0, 0));
1036     minCap = 12000 * DECIMAL1E18;
1037     shockParameter = 50;
1038     variationPercX100 = 100; // 1%
1039     iaRatesTime = 24 hours; // 24 hours in seconds
1040     uniswapDeadline = 20 minutes;
1041     liquidityTradeCallbackTime = 4 hours;
1042     ethVolumeLimit = 4;
1043     capacityLimit = 10;
1044     allCurrencies.push("ETH");
1045     allCurrencyAssets["ETH"] = CurrencyAssets(address(0), 1000 * DECIMAL1E18, 0);
1046     allCurrencies.push("DAI");
1047     allCurrencyAssets["DAI"] = CurrencyAssets(_daiAdd, 50000 * DECIMAL1E18, 0);
1048     allInvestmentCurrencies.push("ETH");
1049     allInvestmentAssets["ETH"] = InvestmentAssets(address(0), true, 2500, 10000, 18);
1050     allInvestmentCurrencies.push("DAI");
1051     allInvestmentAssets["DAI"] = InvestmentAssets(_daiAdd, true, 250, 1500, 18);
1052   }
1053 
1054   /**
1055    * @dev to set the maximum cap allowed
1056    * @param val is the new value
1057    */
1058   function setCapReached(uint val) external onlyInternal {
1059     capReached = val;
1060   }
1061 
1062   /// @dev Updates the 3 day average rate of a IA currency.
1063   /// To be replaced by MakerDao's on chain rates
1064   /// @param curr IA Currency Name.
1065   /// @param rate Average exchange rate X 100 (of last 3 days).
1066   function updateIAAvgRate(bytes4 curr, uint rate) external onlyInternal {
1067     iaAvgRate[curr] = rate;
1068   }
1069 
1070   /// @dev Updates the 3 day average rate of a CA currency.
1071   /// To be replaced by MakerDao's on chain rates
1072   /// @param curr Currency Name.
1073   /// @param rate Average exchange rate X 100 (of last 3 days).
1074   function updateCAAvgRate(bytes4 curr, uint rate) external onlyInternal {
1075     caAvgRate[curr] = rate;
1076   }
1077 
1078   /// @dev Adds details of (Minimum Capital Requirement)MCR.
1079   /// @param mcrp Minimum Capital Requirement percentage (MCR% * 100 ,Ex:for 54.56% ,given 5456)
1080   /// @param vf Pool fund value in Ether used in the last full daily calculation from the Capital model.
1081   function pushMCRData(uint mcrp, uint mcre, uint vf, uint64 time) external onlyInternal {
1082     allMCRData.push(McrData(mcrp, mcre, vf, time));
1083   }
1084 
1085   /**
1086    * @dev Updates the Timestamp at which result of oracalize call is received.
1087    */
1088   function updateDateUpdOfAPI(bytes32 myid) external onlyInternal {
1089     allAPIid[myid].dateUpd = uint64(now);
1090   }
1091 
1092   /**
1093    * @dev Saves the details of the Oraclize API.
1094    * @param myid Id return by the oraclize query.
1095    * @param _typeof type of the query for which oraclize call is made.
1096    * @param id ID of the proposal,quote,cover etc. for which oraclize call is made
1097    */
1098   function saveApiDetails(bytes32 myid, bytes4 _typeof, uint id) external onlyInternal {
1099     allAPIid[myid] = ApiId(_typeof, "", id, uint64(now), uint64(now));
1100   }
1101 
1102   /**
1103    * @dev Stores the id return by the oraclize query.
1104    * Maintains record of all the Ids return by oraclize query.
1105    * @param myid Id return by the oraclize query.
1106    */
1107   function addInAllApiCall(bytes32 myid) external onlyInternal {
1108     allAPIcall.push(myid);
1109   }
1110 
1111   /**
1112    * @dev Saves investment asset rank details.
1113    * @param maxIACurr Maximum ranked investment asset currency.
1114    * @param maxRate Maximum ranked investment asset rate.
1115    * @param minIACurr Minimum ranked investment asset currency.
1116    * @param minRate Minimum ranked investment asset rate.
1117    * @param date in yyyymmdd.
1118    */
1119   function saveIARankDetails(
1120     bytes4 maxIACurr,
1121     uint64 maxRate,
1122     bytes4 minIACurr,
1123     uint64 minRate,
1124     uint64 date
1125   )
1126   external
1127   onlyInternal
1128   {
1129     allIARankDetails.push(IARankDetails(maxIACurr, maxRate, minIACurr, minRate));
1130     datewiseId[date] = allIARankDetails.length.sub(1);
1131   }
1132 
1133   /**
1134    * @dev to get the time for the laste liquidity trade trigger
1135    */
1136   function setLastLiquidityTradeTrigger() external onlyInternal {
1137     lastLiquidityTradeTrigger = now;
1138   }
1139 
1140   /**
1141    * @dev Updates Last Date.
1142    */
1143   function updatelastDate(uint64 newDate) external onlyInternal {
1144     lastDate = newDate;
1145   }
1146 
1147   /**
1148    * @dev Adds currency asset currency.
1149    * @param curr currency of the asset
1150    * @param currAddress address of the currency
1151    * @param baseMin base minimum in 10^18.
1152    */
1153   function addCurrencyAssetCurrency(
1154     bytes4 curr,
1155     address currAddress,
1156     uint baseMin
1157   )
1158   external
1159   {
1160     require(ms.checkIsAuthToGoverned(msg.sender));
1161     allCurrencies.push(curr);
1162     allCurrencyAssets[curr] = CurrencyAssets(currAddress, baseMin, 0);
1163   }
1164 
1165   /**
1166    * @dev Adds investment asset.
1167    */
1168   function addInvestmentAssetCurrency(
1169     bytes4 curr,
1170     address currAddress,
1171     bool status,
1172     uint64 minHoldingPercX100,
1173     uint64 maxHoldingPercX100,
1174     uint8 decimals
1175   )
1176   external
1177   {
1178     require(ms.checkIsAuthToGoverned(msg.sender));
1179     allInvestmentCurrencies.push(curr);
1180     allInvestmentAssets[curr] = InvestmentAssets(currAddress, status,
1181       minHoldingPercX100, maxHoldingPercX100, decimals);
1182   }
1183 
1184   /**
1185    * @dev Changes base minimum of a given currency asset.
1186    */
1187   function changeCurrencyAssetBaseMin(bytes4 curr, uint baseMin) external {
1188     require(ms.checkIsAuthToGoverned(msg.sender));
1189     allCurrencyAssets[curr].baseMin = baseMin;
1190   }
1191 
1192   /**
1193    * @dev changes variable minimum of a given currency asset.
1194    */
1195   function changeCurrencyAssetVarMin(bytes4 curr, uint varMin) external onlyInternal {
1196     allCurrencyAssets[curr].varMin = varMin;
1197   }
1198 
1199   /**
1200    * @dev Changes the investment asset status.
1201    */
1202   function changeInvestmentAssetStatus(bytes4 curr, bool status) external {
1203     require(ms.checkIsAuthToGoverned(msg.sender));
1204     allInvestmentAssets[curr].status = status;
1205   }
1206 
1207   /**
1208    * @dev Changes the investment asset Holding percentage of a given currency.
1209    */
1210   function changeInvestmentAssetHoldingPerc(
1211     bytes4 curr,
1212     uint64 minPercX100,
1213     uint64 maxPercX100
1214   )
1215   external
1216   {
1217     require(ms.checkIsAuthToGoverned(msg.sender));
1218     allInvestmentAssets[curr].minHoldingPercX100 = minPercX100;
1219     allInvestmentAssets[curr].maxHoldingPercX100 = maxPercX100;
1220   }
1221 
1222   /**
1223    * @dev Gets Currency asset token address.
1224    */
1225   function changeCurrencyAssetAddress(bytes4 curr, address currAdd) external {
1226     require(ms.checkIsAuthToGoverned(msg.sender));
1227     allCurrencyAssets[curr].currAddress = currAdd;
1228   }
1229 
1230   /**
1231    * @dev Changes Investment asset token address.
1232    */
1233   function changeInvestmentAssetAddressAndDecimal(
1234     bytes4 curr,
1235     address currAdd,
1236     uint8 newDecimal
1237   )
1238   external
1239   {
1240     require(ms.checkIsAuthToGoverned(msg.sender));
1241     allInvestmentAssets[curr].currAddress = currAdd;
1242     allInvestmentAssets[curr].decimals = newDecimal;
1243   }
1244 
1245   /// @dev Changes address allowed to post MCR.
1246   function changeNotariseAddress(address _add) external onlyInternal {
1247     notariseMCR = _add;
1248   }
1249 
1250   /// @dev updates daiFeedAddress address.
1251   /// @param _add address of DAI feed.
1252   function changeDAIfeedAddress(address _add) external onlyInternal {
1253     daiFeedAddress = _add;
1254   }
1255 
1256   /**
1257    * @dev Gets Uint Parameters of a code
1258    * @param code whose details we want
1259    * @return string value of the code
1260    * @return associated amount (time or perc or value) to the code
1261    */
1262   function getUintParameters(bytes8 code) external view returns (bytes8 codeVal, uint val) {
1263     codeVal = code;
1264     if (code == "MCRTIM") {
1265       val = mcrTime / (1 hours);
1266 
1267     } else if (code == "MCRFTIM") {
1268 
1269       val = mcrFailTime / (1 hours);
1270 
1271     } else if (code == "MCRMIN") {
1272 
1273       val = minCap;
1274 
1275     } else if (code == "MCRSHOCK") {
1276 
1277       val = shockParameter;
1278 
1279     } else if (code == "MCRCAPL") {
1280 
1281       val = capacityLimit;
1282 
1283     } else if (code == "IMZ") {
1284 
1285       val = variationPercX100;
1286 
1287     } else if (code == "IMRATET") {
1288 
1289       val = iaRatesTime / (1 hours);
1290 
1291     } else if (code == "IMUNIDL") {
1292 
1293       val = uniswapDeadline / (1 minutes);
1294 
1295     } else if (code == "IMLIQT") {
1296 
1297       val = liquidityTradeCallbackTime / (1 hours);
1298 
1299     } else if (code == "IMETHVL") {
1300 
1301       val = ethVolumeLimit;
1302 
1303     } else if (code == "C") {
1304       val = c;
1305 
1306     } else if (code == "A") {
1307 
1308       val = a;
1309 
1310     }
1311 
1312   }
1313 
1314   /// @dev Checks whether a given address can notaise MCR data or not.
1315   /// @param _add Address.
1316   /// @return res Returns 0 if address is not authorized, else 1.
1317   function isnotarise(address _add) external view returns (bool res) {
1318     res = false;
1319     if (_add == notariseMCR)
1320       res = true;
1321   }
1322 
1323   /// @dev Gets the details of last added MCR.
1324   /// @return mcrPercx100 Total Minimum Capital Requirement percentage of that month of year(multiplied by 100).
1325   /// @return vFull Total Pool fund value in Ether used in the last full daily calculation.
1326   function getLastMCR() external view returns (uint mcrPercx100, uint mcrEtherx1E18, uint vFull, uint64 date) {
1327     uint index = allMCRData.length.sub(1);
1328     return (
1329     allMCRData[index].mcrPercx100,
1330     allMCRData[index].mcrEther,
1331     allMCRData[index].vFull,
1332     allMCRData[index].date
1333     );
1334   }
1335 
1336   /// @dev Gets last Minimum Capital Requirement percentage of Capital Model
1337   /// @return val MCR% value,multiplied by 100.
1338   function getLastMCRPerc() external view returns (uint) {
1339     return allMCRData[allMCRData.length.sub(1)].mcrPercx100;
1340   }
1341 
1342   /// @dev Gets last Ether price of Capital Model
1343   /// @return val ether value,multiplied by 100.
1344   function getLastMCREther() external view returns (uint) {
1345     return allMCRData[allMCRData.length.sub(1)].mcrEther;
1346   }
1347 
1348   /// @dev Gets Pool fund value in Ether used in the last full daily calculation from the Capital model.
1349   function getLastVfull() external view returns (uint) {
1350     return allMCRData[allMCRData.length.sub(1)].vFull;
1351   }
1352 
1353   /// @dev Gets last Minimum Capital Requirement in Ether.
1354   /// @return date of MCR.
1355   function getLastMCRDate() external view returns (uint64 date) {
1356     date = allMCRData[allMCRData.length.sub(1)].date;
1357   }
1358 
1359   /// @dev Gets details for token price calculation.
1360   function getTokenPriceDetails(bytes4 curr) external view returns (uint _a, uint _c, uint rate) {
1361     _a = a;
1362     _c = c;
1363     rate = _getAvgRate(curr, false);
1364   }
1365 
1366   /// @dev Gets the total number of times MCR calculation has been made.
1367   function getMCRDataLength() external view returns (uint len) {
1368     len = allMCRData.length;
1369   }
1370 
1371   /**
1372    * @dev Gets investment asset rank details by given date.
1373    */
1374   function getIARankDetailsByDate(
1375     uint64 date
1376   )
1377   external
1378   view
1379   returns (
1380     bytes4 maxIACurr,
1381     uint64 maxRate,
1382     bytes4 minIACurr,
1383     uint64 minRate
1384   )
1385   {
1386     uint index = datewiseId[date];
1387     return (
1388     allIARankDetails[index].maxIACurr,
1389     allIARankDetails[index].maxRate,
1390     allIARankDetails[index].minIACurr,
1391     allIARankDetails[index].minRate
1392     );
1393   }
1394 
1395   /**
1396    * @dev Gets Last Date.
1397    */
1398   function getLastDate() external view returns (uint64 date) {
1399     return lastDate;
1400   }
1401 
1402   /**
1403    * @dev Gets investment currency for a given index.
1404    */
1405   function getInvestmentCurrencyByIndex(uint index) external view returns (bytes4 currName) {
1406     return allInvestmentCurrencies[index];
1407   }
1408 
1409   /**
1410    * @dev Gets count of investment currency.
1411    */
1412   function getInvestmentCurrencyLen() external view returns (uint len) {
1413     return allInvestmentCurrencies.length;
1414   }
1415 
1416   /**
1417    * @dev Gets all the investment currencies.
1418    */
1419   function getAllInvestmentCurrencies() external view returns (bytes4[] memory currencies) {
1420     return allInvestmentCurrencies;
1421   }
1422 
1423   /**
1424    * @dev Gets All currency for a given index.
1425    */
1426   function getCurrenciesByIndex(uint index) external view returns (bytes4 currName) {
1427     return allCurrencies[index];
1428   }
1429 
1430   /**
1431    * @dev Gets count of All currency.
1432    */
1433   function getAllCurrenciesLen() external view returns (uint len) {
1434     return allCurrencies.length;
1435   }
1436 
1437   /**
1438    * @dev Gets all currencies
1439    */
1440   function getAllCurrencies() external view returns (bytes4[] memory currencies) {
1441     return allCurrencies;
1442   }
1443 
1444   /**
1445    * @dev Gets currency asset details for a given currency.
1446    */
1447   function getCurrencyAssetVarBase(
1448     bytes4 curr
1449   )
1450   external
1451   view
1452   returns (
1453     bytes4 currency,
1454     uint baseMin,
1455     uint varMin
1456   )
1457   {
1458     return (
1459     curr,
1460     allCurrencyAssets[curr].baseMin,
1461     allCurrencyAssets[curr].varMin
1462     );
1463   }
1464 
1465   /**
1466    * @dev Gets minimum variable value for currency asset.
1467    */
1468   function getCurrencyAssetVarMin(bytes4 curr) external view returns (uint varMin) {
1469     return allCurrencyAssets[curr].varMin;
1470   }
1471 
1472   /**
1473    * @dev Gets base minimum of  a given currency asset.
1474    */
1475   function getCurrencyAssetBaseMin(bytes4 curr) external view returns (uint baseMin) {
1476     return allCurrencyAssets[curr].baseMin;
1477   }
1478 
1479   /**
1480    * @dev Gets investment asset maximum and minimum holding percentage of a given currency.
1481    */
1482   function getInvestmentAssetHoldingPerc(
1483     bytes4 curr
1484   )
1485   external
1486   view
1487   returns (
1488     uint64 minHoldingPercX100,
1489     uint64 maxHoldingPercX100
1490   )
1491   {
1492     return (
1493     allInvestmentAssets[curr].minHoldingPercX100,
1494     allInvestmentAssets[curr].maxHoldingPercX100
1495     );
1496   }
1497 
1498   /**
1499    * @dev Gets investment asset decimals.
1500    */
1501   function getInvestmentAssetDecimals(bytes4 curr) external view returns (uint8 decimal) {
1502     return allInvestmentAssets[curr].decimals;
1503   }
1504 
1505   /**
1506    * @dev Gets investment asset maximum holding percentage of a given currency.
1507    */
1508   function getInvestmentAssetMaxHoldingPerc(bytes4 curr) external view returns (uint64 maxHoldingPercX100) {
1509     return allInvestmentAssets[curr].maxHoldingPercX100;
1510   }
1511 
1512   /**
1513    * @dev Gets investment asset minimum holding percentage of a given currency.
1514    */
1515   function getInvestmentAssetMinHoldingPerc(bytes4 curr) external view returns (uint64 minHoldingPercX100) {
1516     return allInvestmentAssets[curr].minHoldingPercX100;
1517   }
1518 
1519   /**
1520    * @dev Gets investment asset details of a given currency
1521    */
1522   function getInvestmentAssetDetails(
1523     bytes4 curr
1524   )
1525   external
1526   view
1527   returns (
1528     bytes4 currency,
1529     address currAddress,
1530     bool status,
1531     uint64 minHoldingPerc,
1532     uint64 maxHoldingPerc,
1533     uint8 decimals
1534   )
1535   {
1536     return (
1537     curr,
1538     allInvestmentAssets[curr].currAddress,
1539     allInvestmentAssets[curr].status,
1540     allInvestmentAssets[curr].minHoldingPercX100,
1541     allInvestmentAssets[curr].maxHoldingPercX100,
1542     allInvestmentAssets[curr].decimals
1543     );
1544   }
1545 
1546   /**
1547    * @dev Gets Currency asset token address.
1548    */
1549   function getCurrencyAssetAddress(bytes4 curr) external view returns (address) {
1550     return allCurrencyAssets[curr].currAddress;
1551   }
1552 
1553   /**
1554    * @dev Gets investment asset token address.
1555    */
1556   function getInvestmentAssetAddress(bytes4 curr) external view returns (address) {
1557     return allInvestmentAssets[curr].currAddress;
1558   }
1559 
1560   /**
1561    * @dev Gets investment asset active Status of a given currency.
1562    */
1563   function getInvestmentAssetStatus(bytes4 curr) external view returns (bool status) {
1564     return allInvestmentAssets[curr].status;
1565   }
1566 
1567   /**
1568    * @dev Gets type of oraclize query for a given Oraclize Query ID.
1569    * @param myid Oraclize Query ID identifying the query for which the result is being received.
1570    * @return _typeof It could be of type "quote","quotation","cover","claim" etc.
1571    */
1572   function getApiIdTypeOf(bytes32 myid) external view returns (bytes4) {
1573     return allAPIid[myid].typeOf;
1574   }
1575 
1576   /**
1577    * @dev Gets ID associated to oraclize query for a given Oraclize Query ID.
1578    * @param myid Oraclize Query ID identifying the query for which the result is being received.
1579    * @return id1 It could be the ID of "proposal","quotation","cover","claim" etc.
1580    */
1581   function getIdOfApiId(bytes32 myid) external view returns (uint) {
1582     return allAPIid[myid].id;
1583   }
1584 
1585   /**
1586    * @dev Gets the Timestamp of a oracalize call.
1587    */
1588   function getDateAddOfAPI(bytes32 myid) external view returns (uint64) {
1589     return allAPIid[myid].dateAdd;
1590   }
1591 
1592   /**
1593    * @dev Gets the Timestamp at which result of oracalize call is received.
1594    */
1595   function getDateUpdOfAPI(bytes32 myid) external view returns (uint64) {
1596     return allAPIid[myid].dateUpd;
1597   }
1598 
1599   /**
1600    * @dev Gets currency by oracalize id.
1601    */
1602   function getCurrOfApiId(bytes32 myid) external view returns (bytes4) {
1603     return allAPIid[myid].currency;
1604   }
1605 
1606   /**
1607    * @dev Gets ID return by the oraclize query of a given index.
1608    * @param index Index.
1609    * @return myid ID return by the oraclize query.
1610    */
1611   function getApiCallIndex(uint index) external view returns (bytes32 myid) {
1612     myid = allAPIcall[index];
1613   }
1614 
1615   /**
1616    * @dev Gets Length of API call.
1617    */
1618   function getApilCallLength() external view returns (uint) {
1619     return allAPIcall.length;
1620   }
1621 
1622   /**
1623    * @dev Get Details of Oraclize API when given Oraclize Id.
1624    * @param myid ID return by the oraclize query.
1625    * @return _typeof ype of the query for which oraclize
1626    * call is made.("proposal","quote","quotation" etc.)
1627    */
1628   function getApiCallDetails(
1629     bytes32 myid
1630   )
1631   external
1632   view
1633   returns (
1634     bytes4 _typeof,
1635     bytes4 curr,
1636     uint id,
1637     uint64 dateAdd,
1638     uint64 dateUpd
1639   )
1640   {
1641     return (
1642     allAPIid[myid].typeOf,
1643     allAPIid[myid].currency,
1644     allAPIid[myid].id,
1645     allAPIid[myid].dateAdd,
1646     allAPIid[myid].dateUpd
1647     );
1648   }
1649 
1650   /**
1651    * @dev Updates Uint Parameters of a code
1652    * @param code whose details we want to update
1653    * @param val value to set
1654    */
1655   function updateUintParameters(bytes8 code, uint val) public {
1656     require(ms.checkIsAuthToGoverned(msg.sender));
1657     if (code == "MCRTIM") {
1658       _changeMCRTime(val * 1 hours);
1659 
1660     } else if (code == "MCRFTIM") {
1661 
1662       _changeMCRFailTime(val * 1 hours);
1663 
1664     } else if (code == "MCRMIN") {
1665 
1666       _changeMinCap(val);
1667 
1668     } else if (code == "MCRSHOCK") {
1669 
1670       _changeShockParameter(val);
1671 
1672     } else if (code == "MCRCAPL") {
1673 
1674       _changeCapacityLimit(val);
1675 
1676     } else if (code == "IMZ") {
1677 
1678       _changeVariationPercX100(val);
1679 
1680     } else if (code == "IMRATET") {
1681 
1682       _changeIARatesTime(val * 1 hours);
1683 
1684     } else if (code == "IMUNIDL") {
1685 
1686       _changeUniswapDeadlineTime(val * 1 minutes);
1687 
1688     } else if (code == "IMLIQT") {
1689 
1690       _changeliquidityTradeCallbackTime(val * 1 hours);
1691 
1692     } else if (code == "IMETHVL") {
1693 
1694       _setEthVolumeLimit(val);
1695 
1696     } else if (code == "C") {
1697       _changeC(val);
1698 
1699     } else if (code == "A") {
1700 
1701       _changeA(val);
1702 
1703     } else {
1704       revert("Invalid param code");
1705     }
1706 
1707   }
1708 
1709   /**
1710    * @dev to get the average rate of currency rate
1711    * @param curr is the currency in concern
1712    * @return required rate
1713    */
1714   function getCAAvgRate(bytes4 curr) public view returns (uint rate) {
1715     return _getAvgRate(curr, false);
1716   }
1717 
1718   /**
1719    * @dev to get the average rate of investment rate
1720    * @param curr is the investment in concern
1721    * @return required rate
1722    */
1723   function getIAAvgRate(bytes4 curr) public view returns (uint rate) {
1724     return _getAvgRate(curr, true);
1725   }
1726 
1727   function changeDependentContractAddress() public onlyInternal {}
1728 
1729   /// @dev Gets the average rate of a CA currency.
1730   /// @param curr Currency Name.
1731   /// @return rate Average rate X 100(of last 3 days).
1732   function _getAvgRate(bytes4 curr, bool isIA) internal view returns (uint rate) {
1733     if (curr == "DAI") {
1734       DSValue ds = DSValue(daiFeedAddress);
1735       rate = uint(ds.read()).div(uint(10) ** 16);
1736     } else if (isIA) {
1737       rate = iaAvgRate[curr];
1738     } else {
1739       rate = caAvgRate[curr];
1740     }
1741   }
1742 
1743   /**
1744    * @dev to set the ethereum volume limit
1745    * @param val is the new limit value
1746    */
1747   function _setEthVolumeLimit(uint val) internal {
1748     ethVolumeLimit = val;
1749   }
1750 
1751   /// @dev Sets minimum Cap.
1752   function _changeMinCap(uint newCap) internal {
1753     minCap = newCap;
1754   }
1755 
1756   /// @dev Sets Shock Parameter.
1757   function _changeShockParameter(uint newParam) internal {
1758     shockParameter = newParam;
1759   }
1760 
1761   /// @dev Changes time period for obtaining new MCR data from external oracle query.
1762   function _changeMCRTime(uint _time) internal {
1763     mcrTime = _time;
1764   }
1765 
1766   /// @dev Sets MCR Fail time.
1767   function _changeMCRFailTime(uint _time) internal {
1768     mcrFailTime = _time;
1769   }
1770 
1771   /**
1772    * @dev to change the uniswap deadline time
1773    * @param newDeadline is the value
1774    */
1775   function _changeUniswapDeadlineTime(uint newDeadline) internal {
1776     uniswapDeadline = newDeadline;
1777   }
1778 
1779   /**
1780    * @dev to change the liquidity trade call back time
1781    * @param newTime is the new value to be set
1782    */
1783   function _changeliquidityTradeCallbackTime(uint newTime) internal {
1784     liquidityTradeCallbackTime = newTime;
1785   }
1786 
1787   /**
1788    * @dev Changes time after which investment asset rates need to be fed.
1789    */
1790   function _changeIARatesTime(uint _newTime) internal {
1791     iaRatesTime = _newTime;
1792   }
1793 
1794   /**
1795    * @dev Changes the variation range percentage.
1796    */
1797   function _changeVariationPercX100(uint newPercX100) internal {
1798     variationPercX100 = newPercX100;
1799   }
1800 
1801   /// @dev Changes Growth Step
1802   function _changeC(uint newC) internal {
1803     c = newC;
1804   }
1805 
1806   /// @dev Changes scaling factor.
1807   function _changeA(uint val) internal {
1808     a = val;
1809   }
1810 
1811   /**
1812    * @dev to change the capacity limit
1813    * @param val is the new value
1814    */
1815   function _changeCapacityLimit(uint val) internal {
1816     capacityLimit = val;
1817   }
1818 }
1819 
1820 // File: contracts/modules/token/external/OZIERC20.sol
1821 
1822 pragma solidity ^0.5.0;
1823 
1824 
1825 /**
1826  * @title ERC20 interface
1827  * @dev see https://github.com/ethereum/EIPs/issues/20
1828  */
1829 interface OZIERC20 {
1830   function transfer(address to, uint256 value) external returns (bool);
1831 
1832   function approve(address spender, uint256 value)
1833   external returns (bool);
1834 
1835   function transferFrom(address from, address to, uint256 value)
1836   external returns (bool);
1837 
1838   function totalSupply() external view returns (uint256);
1839 
1840   function balanceOf(address who) external view returns (uint256);
1841 
1842   function allowance(address owner, address spender)
1843   external view returns (uint256);
1844 
1845   event Transfer(
1846     address indexed from,
1847     address indexed to,
1848     uint256 value
1849   );
1850 
1851   event Approval(
1852     address indexed owner,
1853     address indexed spender,
1854     uint256 value
1855   );
1856 }
1857 
1858 // File: contracts/modules/token/external/OZSafeMath.sol
1859 
1860 pragma solidity ^0.5.0;
1861 
1862 
1863 /**
1864  * @title SafeMath
1865  * @dev Math operations with safety checks that revert on error
1866  */
1867 library OZSafeMath {
1868 
1869   /**
1870   * @dev Multiplies two numbers, reverts on overflow.
1871   */
1872   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1873     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1874     // benefit is lost if 'b' is also tested.
1875     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1876     if (a == 0) {
1877       return 0;
1878     }
1879 
1880     uint256 c = a * b;
1881     require(c / a == b);
1882 
1883     return c;
1884   }
1885 
1886   /**
1887   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1888   */
1889   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1890     require(b > 0); // Solidity only automatically asserts when dividing by 0
1891     uint256 c = a / b;
1892     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1893 
1894     return c;
1895   }
1896 
1897   /**
1898   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1899   */
1900   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1901     require(b <= a);
1902     uint256 c = a - b;
1903 
1904     return c;
1905   }
1906 
1907   /**
1908   * @dev Adds two numbers, reverts on overflow.
1909   */
1910   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1911     uint256 c = a + b;
1912     require(c >= a);
1913 
1914     return c;
1915   }
1916 
1917   /**
1918   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1919   * reverts when dividing by zero.
1920   */
1921   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1922     require(b != 0);
1923     return a % b;
1924   }
1925 }
1926 
1927 // File: contracts/modules/token/NXMToken.sol
1928 
1929 /* Copyright (C) 2020 NexusMutual.io
1930 
1931   This program is free software: you can redistribute it and/or modify
1932     it under the terms of the GNU General Public License as published by
1933     the Free Software Foundation, either version 3 of the License, or
1934     (at your option) any later version.
1935 
1936   This program is distributed in the hope that it will be useful,
1937     but WITHOUT ANY WARRANTY; without even the implied warranty of
1938     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1939     GNU General Public License for more details.
1940 
1941   You should have received a copy of the GNU General Public License
1942     along with this program.  If not, see http://www.gnu.org/licenses/ */
1943 
1944 pragma solidity ^0.5.0;
1945 
1946 
1947 
1948 contract NXMToken is OZIERC20 {
1949   using OZSafeMath for uint256;
1950 
1951   event WhiteListed(address indexed member);
1952 
1953   event BlackListed(address indexed member);
1954 
1955   mapping(address => uint256) private _balances;
1956 
1957   mapping(address => mapping(address => uint256)) private _allowed;
1958 
1959   mapping(address => bool) public whiteListed;
1960 
1961   mapping(address => uint) public isLockedForMV;
1962 
1963   uint256 private _totalSupply;
1964 
1965   string public name = "NXM";
1966   string public symbol = "NXM";
1967   uint8 public decimals = 18;
1968   address public operator;
1969 
1970   modifier canTransfer(address _to) {
1971     require(whiteListed[_to]);
1972     _;
1973   }
1974 
1975   modifier onlyOperator() {
1976     if (operator != address(0))
1977       require(msg.sender == operator);
1978     _;
1979   }
1980 
1981   constructor(address _founderAddress, uint _initialSupply) public {
1982     _mint(_founderAddress, _initialSupply);
1983   }
1984 
1985   /**
1986   * @dev Total number of tokens in existence
1987   */
1988   function totalSupply() public view returns (uint256) {
1989     return _totalSupply;
1990   }
1991 
1992   /**
1993   * @dev Gets the balance of the specified address.
1994   * @param owner The address to query the balance of.
1995   * @return An uint256 representing the amount owned by the passed address.
1996   */
1997   function balanceOf(address owner) public view returns (uint256) {
1998     return _balances[owner];
1999   }
2000 
2001   /**
2002   * @dev Function to check the amount of tokens that an owner allowed to a spender.
2003   * @param owner address The address which owns the funds.
2004   * @param spender address The address which will spend the funds.
2005   * @return A uint256 specifying the amount of tokens still available for the spender.
2006   */
2007   function allowance(
2008     address owner,
2009     address spender
2010   )
2011   public
2012   view
2013   returns (uint256)
2014   {
2015     return _allowed[owner][spender];
2016   }
2017 
2018   /**
2019   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
2020   * Beware that changing an allowance with this method brings the risk that someone may use both the old
2021   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
2022   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
2023   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2024   * @param spender The address which will spend the funds.
2025   * @param value The amount of tokens to be spent.
2026   */
2027   function approve(address spender, uint256 value) public returns (bool) {
2028     require(spender != address(0));
2029 
2030     _allowed[msg.sender][spender] = value;
2031     emit Approval(msg.sender, spender, value);
2032     return true;
2033   }
2034 
2035   /**
2036   * @dev Increase the amount of tokens that an owner allowed to a spender.
2037   * approve should be called when allowed_[_spender] == 0. To increment
2038   * allowed value is better to use this function to avoid 2 calls (and wait until
2039   * the first transaction is mined)
2040   * From MonolithDAO Token.sol
2041   * @param spender The address which will spend the funds.
2042   * @param addedValue The amount of tokens to increase the allowance by.
2043   */
2044   function increaseAllowance(
2045     address spender,
2046     uint256 addedValue
2047   )
2048   public
2049   returns (bool)
2050   {
2051     require(spender != address(0));
2052 
2053     _allowed[msg.sender][spender] = (
2054     _allowed[msg.sender][spender].add(addedValue));
2055     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
2056     return true;
2057   }
2058 
2059   /**
2060   * @dev Decrease the amount of tokens that an owner allowed to a spender.
2061   * approve should be called when allowed_[_spender] == 0. To decrement
2062   * allowed value is better to use this function to avoid 2 calls (and wait until
2063   * the first transaction is mined)
2064   * From MonolithDAO Token.sol
2065   * @param spender The address which will spend the funds.
2066   * @param subtractedValue The amount of tokens to decrease the allowance by.
2067   */
2068   function decreaseAllowance(
2069     address spender,
2070     uint256 subtractedValue
2071   )
2072   public
2073   returns (bool)
2074   {
2075     require(spender != address(0));
2076 
2077     _allowed[msg.sender][spender] = (
2078     _allowed[msg.sender][spender].sub(subtractedValue));
2079     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
2080     return true;
2081   }
2082 
2083   /**
2084   * @dev Adds a user to whitelist
2085   * @param _member address to add to whitelist
2086   */
2087   function addToWhiteList(address _member) public onlyOperator returns (bool) {
2088     whiteListed[_member] = true;
2089     emit WhiteListed(_member);
2090     return true;
2091   }
2092 
2093   /**
2094   * @dev removes a user from whitelist
2095   * @param _member address to remove from whitelist
2096   */
2097   function removeFromWhiteList(address _member) public onlyOperator returns (bool) {
2098     whiteListed[_member] = false;
2099     emit BlackListed(_member);
2100     return true;
2101   }
2102 
2103   /**
2104   * @dev change operator address
2105   * @param _newOperator address of new operator
2106   */
2107   function changeOperator(address _newOperator) public onlyOperator returns (bool) {
2108     operator = _newOperator;
2109     return true;
2110   }
2111 
2112   /**
2113   * @dev burns an amount of the tokens of the message sender
2114   * account.
2115   * @param amount The amount that will be burnt.
2116   */
2117   function burn(uint256 amount) public returns (bool) {
2118     _burn(msg.sender, amount);
2119     return true;
2120   }
2121 
2122   /**
2123   * @dev Burns a specific amount of tokens from the target address and decrements allowance
2124   * @param from address The address which you want to send tokens from
2125   * @param value uint256 The amount of token to be burned
2126   */
2127   function burnFrom(address from, uint256 value) public returns (bool) {
2128     _burnFrom(from, value);
2129     return true;
2130   }
2131 
2132   /**
2133   * @dev function that mints an amount of the token and assigns it to
2134   * an account.
2135   * @param account The account that will receive the created tokens.
2136   * @param amount The amount that will be created.
2137   */
2138   function mint(address account, uint256 amount) public onlyOperator {
2139     _mint(account, amount);
2140   }
2141 
2142   /**
2143   * @dev Transfer token for a specified address
2144   * @param to The address to transfer to.
2145   * @param value The amount to be transferred.
2146   */
2147   function transfer(address to, uint256 value) public canTransfer(to) returns (bool) {
2148 
2149     require(isLockedForMV[msg.sender] < now); // if not voted under governance
2150     require(value <= _balances[msg.sender]);
2151     _transfer(to, value);
2152     return true;
2153   }
2154 
2155   /**
2156   * @dev Transfer tokens to the operator from the specified address
2157   * @param from The address to transfer from.
2158   * @param value The amount to be transferred.
2159   */
2160   function operatorTransfer(address from, uint256 value) public onlyOperator returns (bool) {
2161     require(value <= _balances[from]);
2162     _transferFrom(from, operator, value);
2163     return true;
2164   }
2165 
2166   /**
2167   * @dev Transfer tokens from one address to another
2168   * @param from address The address which you want to send tokens from
2169   * @param to address The address which you want to transfer to
2170   * @param value uint256 the amount of tokens to be transferred
2171   */
2172   function transferFrom(
2173     address from,
2174     address to,
2175     uint256 value
2176   )
2177   public
2178   canTransfer(to)
2179   returns (bool)
2180   {
2181     require(isLockedForMV[from] < now); // if not voted under governance
2182     require(value <= _balances[from]);
2183     require(value <= _allowed[from][msg.sender]);
2184     _transferFrom(from, to, value);
2185     return true;
2186   }
2187 
2188   /**
2189    * @dev Lock the user's tokens
2190    * @param _of user's address.
2191    */
2192   function lockForMemberVote(address _of, uint _days) public onlyOperator {
2193     if (_days.add(now) > isLockedForMV[_of])
2194       isLockedForMV[_of] = _days.add(now);
2195   }
2196 
2197   /**
2198   * @dev Transfer token for a specified address
2199   * @param to The address to transfer to.
2200   * @param value The amount to be transferred.
2201   */
2202   function _transfer(address to, uint256 value) internal {
2203     _balances[msg.sender] = _balances[msg.sender].sub(value);
2204     _balances[to] = _balances[to].add(value);
2205     emit Transfer(msg.sender, to, value);
2206   }
2207 
2208   /**
2209   * @dev Transfer tokens from one address to another
2210   * @param from address The address which you want to send tokens from
2211   * @param to address The address which you want to transfer to
2212   * @param value uint256 the amount of tokens to be transferred
2213   */
2214   function _transferFrom(
2215     address from,
2216     address to,
2217     uint256 value
2218   )
2219   internal
2220   {
2221     _balances[from] = _balances[from].sub(value);
2222     _balances[to] = _balances[to].add(value);
2223     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
2224     emit Transfer(from, to, value);
2225   }
2226 
2227   /**
2228   * @dev Internal function that mints an amount of the token and assigns it to
2229   * an account. This encapsulates the modification of balances such that the
2230   * proper events are emitted.
2231   * @param account The account that will receive the created tokens.
2232   * @param amount The amount that will be created.
2233   */
2234   function _mint(address account, uint256 amount) internal {
2235     require(account != address(0));
2236     _totalSupply = _totalSupply.add(amount);
2237     _balances[account] = _balances[account].add(amount);
2238     emit Transfer(address(0), account, amount);
2239   }
2240 
2241   /**
2242   * @dev Internal function that burns an amount of the token of a given
2243   * account.
2244   * @param account The account whose tokens will be burnt.
2245   * @param amount The amount that will be burnt.
2246   */
2247   function _burn(address account, uint256 amount) internal {
2248     require(amount <= _balances[account]);
2249 
2250     _totalSupply = _totalSupply.sub(amount);
2251     _balances[account] = _balances[account].sub(amount);
2252     emit Transfer(account, address(0), amount);
2253   }
2254 
2255   /**
2256   * @dev Internal function that burns an amount of the token of a given
2257   * account, deducting from the sender's allowance for said account. Uses the
2258   * internal burn function.
2259   * @param account The account whose tokens will be burnt.
2260   * @param value The amount that will be burnt.
2261   */
2262   function _burnFrom(address account, uint256 value) internal {
2263     require(value <= _allowed[account][msg.sender]);
2264 
2265     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
2266     // this function needs to emit an event with the updated approval.
2267     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
2268       value);
2269     _burn(account, value);
2270   }
2271 }
2272 
2273 // File: contracts/modules/token/external/IERC1132.sol
2274 
2275 pragma solidity ^0.5.0;
2276 
2277 /**
2278  * @title ERC1132 interface
2279  * @dev see https://github.com/ethereum/EIPs/issues/1132
2280  */
2281 
2282 contract IERC1132 {
2283   /**
2284    * @dev Reasons why a user's tokens have been locked
2285    */
2286   mapping(address => bytes32[]) public lockReason;
2287 
2288   /**
2289    * @dev locked token structure
2290    */
2291   struct LockToken {
2292     uint256 amount;
2293     uint256 validity;
2294     bool claimed;
2295   }
2296 
2297   /**
2298    * @dev Holds number & validity of tokens locked for a given reason for
2299    *      a specified address
2300    */
2301   mapping(address => mapping(bytes32 => LockToken)) public locked;
2302 
2303   /**
2304    * @dev Records data of all the tokens Locked
2305    */
2306   event Locked(
2307     address indexed _of,
2308     bytes32 indexed _reason,
2309     uint256 _amount,
2310     uint256 _validity
2311   );
2312 
2313   /**
2314    * @dev Records data of all the tokens unlocked
2315    */
2316   event Unlocked(
2317     address indexed _of,
2318     bytes32 indexed _reason,
2319     uint256 _amount
2320   );
2321 
2322   /**
2323    * @dev Locks a specified amount of tokens against an address,
2324    *      for a specified reason and time
2325    * @param _reason The reason to lock tokens
2326    * @param _amount Number of tokens to be locked
2327    * @param _time Lock time in seconds
2328    */
2329   function lock(bytes32 _reason, uint256 _amount, uint256 _time)
2330   public returns (bool);
2331 
2332   /**
2333    * @dev Returns tokens locked for a specified address for a
2334    *      specified reason
2335    *
2336    * @param _of The address whose tokens are locked
2337    * @param _reason The reason to query the lock tokens for
2338    */
2339   function tokensLocked(address _of, bytes32 _reason)
2340   public view returns (uint256 amount);
2341 
2342   /**
2343    * @dev Returns tokens locked for a specified address for a
2344    *      specified reason at a specific time
2345    *
2346    * @param _of The address whose tokens are locked
2347    * @param _reason The reason to query the lock tokens for
2348    * @param _time The timestamp to query the lock tokens for
2349    */
2350   function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
2351   public view returns (uint256 amount);
2352 
2353   /**
2354    * @dev Returns total tokens held by an address (locked + transferable)
2355    * @param _of The address to query the total balance of
2356    */
2357   function totalBalanceOf(address _of)
2358   public view returns (uint256 amount);
2359 
2360   /**
2361    * @dev Extends lock for a specified reason and time
2362    * @param _reason The reason to lock tokens
2363    * @param _time Lock extension time in seconds
2364    */
2365   function extendLock(bytes32 _reason, uint256 _time)
2366   public returns (bool);
2367 
2368   /**
2369    * @dev Increase number of tokens locked for a specified reason
2370    * @param _reason The reason to lock tokens
2371    * @param _amount Number of tokens to be increased
2372    */
2373   function increaseLockAmount(bytes32 _reason, uint256 _amount)
2374   public returns (bool);
2375 
2376   /**
2377    * @dev Returns unlockable tokens for a specified address for a specified reason
2378    * @param _of The address to query the the unlockable token count of
2379    * @param _reason The reason to query the unlockable tokens for
2380    */
2381   function tokensUnlockable(address _of, bytes32 _reason)
2382   public view returns (uint256 amount);
2383 
2384   /**
2385    * @dev Unlocks the unlockable tokens of a specified address
2386    * @param _of Address of user, claiming back unlockable tokens
2387    */
2388   function unlock(address _of)
2389   public returns (uint256 unlockableTokens);
2390 
2391   /**
2392    * @dev Gets the unlockable tokens of a specified address
2393    * @param _of The address to query the the unlockable token count of
2394    */
2395   function getUnlockableTokens(address _of)
2396   public view returns (uint256 unlockableTokens);
2397 
2398 }
2399 
2400 // File: contracts/modules/token/TokenController.sol
2401 
2402 /* Copyright (C) 2020 NexusMutual.io
2403 
2404   This program is free software: you can redistribute it and/or modify
2405   it under the terms of the GNU General Public License as published by
2406   the Free Software Foundation, either version 3 of the License, or
2407   (at your option) any later version.
2408 
2409   This program is distributed in the hope that it will be useful,
2410   but WITHOUT ANY WARRANTY; without even the implied warranty of
2411   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2412   GNU General Public License for more details.
2413 
2414   You should have received a copy of the GNU General Public License
2415   along with this program.  If not, see http://www.gnu.org/licenses/ */
2416 
2417 pragma solidity ^0.5.0;
2418 
2419 
2420 
2421 
2422 
2423 
2424 contract TokenController is IERC1132, Iupgradable {
2425   using SafeMath for uint256;
2426 
2427   event Burned(address indexed member, bytes32 lockedUnder, uint256 amount);
2428 
2429   NXMToken public token;
2430   IPooledStaking public pooledStaking;
2431   uint public minCALockTime = uint(30).mul(1 days);
2432   bytes32 private constant CLA = bytes32("CLA");
2433 
2434   /**
2435   * @dev Just for interface
2436   */
2437   function changeDependentContractAddress() public {
2438     token = NXMToken(ms.tokenAddress());
2439     pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
2440   }
2441 
2442   /**
2443    * @dev to change the operator address
2444    * @param _newOperator is the new address of operator
2445    */
2446   function changeOperator(address _newOperator) public onlyInternal {
2447     token.changeOperator(_newOperator);
2448   }
2449 
2450   /**
2451    * @dev Proxies token transfer through this contract to allow staking when members are locked for voting
2452    * @param _from   Source address
2453    * @param _to     Destination address
2454    * @param _value  Amount to transfer
2455    */
2456   function operatorTransfer(address _from, address _to, uint _value) onlyInternal external returns (bool) {
2457     require(msg.sender == address(pooledStaking), "Call is only allowed from PooledStaking address");
2458     require(token.operatorTransfer(_from, _value), "Operator transfer failed");
2459     require(token.transfer(_to, _value), "Internal transfer failed");
2460     return true;
2461   }
2462 
2463   /**
2464   * @dev Locks a specified amount of tokens,
2465   *    for CLA reason and for a specified time
2466   * @param _reason The reason to lock tokens, currently restricted to CLA
2467   * @param _amount Number of tokens to be locked
2468   * @param _time Lock time in seconds
2469   */
2470   function lock(bytes32 _reason, uint256 _amount, uint256 _time) public checkPause returns (bool)
2471   {
2472     require(_reason == CLA, "Restricted to reason CLA");
2473     require(minCALockTime <= _time, "Should lock for minimum time");
2474     // If tokens are already locked, then functions extendLock or
2475     // increaseLockAmount should be used to make any changes
2476     _lock(msg.sender, _reason, _amount, _time);
2477     return true;
2478   }
2479 
2480   /**
2481   * @dev Locks a specified amount of tokens against an address,
2482   *    for a specified reason and time
2483   * @param _reason The reason to lock tokens
2484   * @param _amount Number of tokens to be locked
2485   * @param _time Lock time in seconds
2486   * @param _of address whose tokens are to be locked
2487   */
2488   function lockOf(address _of, bytes32 _reason, uint256 _amount, uint256 _time)
2489   public
2490   onlyInternal
2491   returns (bool)
2492   {
2493     // If tokens are already locked, then functions extendLock or
2494     // increaseLockAmount should be used to make any changes
2495     _lock(_of, _reason, _amount, _time);
2496     return true;
2497   }
2498 
2499   /**
2500   * @dev Extends lock for reason CLA for a specified time
2501   * @param _reason The reason to lock tokens, currently restricted to CLA
2502   * @param _time Lock extension time in seconds
2503   */
2504   function extendLock(bytes32 _reason, uint256 _time)
2505   public
2506   checkPause
2507   returns (bool)
2508   {
2509     require(_reason == CLA, "Restricted to reason CLA");
2510     _extendLock(msg.sender, _reason, _time);
2511     return true;
2512   }
2513 
2514   /**
2515   * @dev Extends lock for a specified reason and time
2516   * @param _reason The reason to lock tokens
2517   * @param _time Lock extension time in seconds
2518   */
2519   function extendLockOf(address _of, bytes32 _reason, uint256 _time)
2520   public
2521   onlyInternal
2522   returns (bool)
2523   {
2524     _extendLock(_of, _reason, _time);
2525     return true;
2526   }
2527 
2528   /**
2529   * @dev Increase number of tokens locked for a CLA reason
2530   * @param _reason The reason to lock tokens, currently restricted to CLA
2531   * @param _amount Number of tokens to be increased
2532   */
2533   function increaseLockAmount(bytes32 _reason, uint256 _amount)
2534   public
2535   checkPause
2536   returns (bool)
2537   {
2538     require(_reason == CLA, "Restricted to reason CLA");
2539     require(_tokensLocked(msg.sender, _reason) > 0);
2540     token.operatorTransfer(msg.sender, _amount);
2541 
2542     locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
2543     emit Locked(msg.sender, _reason, _amount, locked[msg.sender][_reason].validity);
2544     return true;
2545   }
2546 
2547   /**
2548    * @dev burns tokens of an address
2549    * @param _of is the address to burn tokens of
2550    * @param amount is the amount to burn
2551    * @return the boolean status of the burning process
2552    */
2553   function burnFrom(address _of, uint amount) public onlyInternal returns (bool) {
2554     return token.burnFrom(_of, amount);
2555   }
2556 
2557   /**
2558   * @dev Burns locked tokens of a user
2559   * @param _of address whose tokens are to be burned
2560   * @param _reason lock reason for which tokens are to be burned
2561   * @param _amount amount of tokens to burn
2562   */
2563   function burnLockedTokens(address _of, bytes32 _reason, uint256 _amount) public onlyInternal {
2564     _burnLockedTokens(_of, _reason, _amount);
2565   }
2566 
2567   /**
2568   * @dev reduce lock duration for a specified reason and time
2569   * @param _of The address whose tokens are locked
2570   * @param _reason The reason to lock tokens
2571   * @param _time Lock reduction time in seconds
2572   */
2573   function reduceLock(address _of, bytes32 _reason, uint256 _time) public onlyInternal {
2574     _reduceLock(_of, _reason, _time);
2575   }
2576 
2577   /**
2578   * @dev Released locked tokens of an address locked for a specific reason
2579   * @param _of address whose tokens are to be released from lock
2580   * @param _reason reason of the lock
2581   * @param _amount amount of tokens to release
2582   */
2583   function releaseLockedTokens(address _of, bytes32 _reason, uint256 _amount)
2584   public
2585   onlyInternal
2586   {
2587     _releaseLockedTokens(_of, _reason, _amount);
2588   }
2589 
2590   /**
2591   * @dev Adds an address to whitelist maintained in the contract
2592   * @param _member address to add to whitelist
2593   */
2594   function addToWhitelist(address _member) public onlyInternal {
2595     token.addToWhiteList(_member);
2596   }
2597 
2598   /**
2599   * @dev Removes an address from the whitelist in the token
2600   * @param _member address to remove
2601   */
2602   function removeFromWhitelist(address _member) public onlyInternal {
2603     token.removeFromWhiteList(_member);
2604   }
2605 
2606   /**
2607   * @dev Mints new token for an address
2608   * @param _member address to reward the minted tokens
2609   * @param _amount number of tokens to mint
2610   */
2611   function mint(address _member, uint _amount) public onlyInternal {
2612     token.mint(_member, _amount);
2613   }
2614 
2615   /**
2616    * @dev Lock the user's tokens
2617    * @param _of user's address.
2618    */
2619   function lockForMemberVote(address _of, uint _days) public onlyInternal {
2620     token.lockForMemberVote(_of, _days);
2621   }
2622 
2623   /**
2624   * @dev Unlocks the unlockable tokens against CLA of a specified address
2625   * @param _of Address of user, claiming back unlockable tokens against CLA
2626   */
2627   function unlock(address _of)
2628   public
2629   checkPause
2630   returns (uint256 unlockableTokens)
2631   {
2632     unlockableTokens = _tokensUnlockable(_of, CLA);
2633     if (unlockableTokens > 0) {
2634       locked[_of][CLA].claimed = true;
2635       emit Unlocked(_of, CLA, unlockableTokens);
2636       require(token.transfer(_of, unlockableTokens));
2637     }
2638   }
2639 
2640   /**
2641    * @dev Updates Uint Parameters of a code
2642    * @param code whose details we want to update
2643    * @param val value to set
2644    */
2645   function updateUintParameters(bytes8 code, uint val) public {
2646     require(ms.checkIsAuthToGoverned(msg.sender));
2647     if (code == "MNCLT") {
2648       minCALockTime = val.mul(1 days);
2649     } else {
2650       revert("Invalid param code");
2651     }
2652   }
2653 
2654   /**
2655   * @dev Gets the validity of locked tokens of a specified address
2656   * @param _of The address to query the validity
2657   * @param reason reason for which tokens were locked
2658   */
2659   function getLockedTokensValidity(address _of, bytes32 reason)
2660   public
2661   view
2662   returns (uint256 validity)
2663   {
2664     validity = locked[_of][reason].validity;
2665   }
2666 
2667   /**
2668   * @dev Gets the unlockable tokens of a specified address
2669   * @param _of The address to query the the unlockable token count of
2670   */
2671   function getUnlockableTokens(address _of)
2672   public
2673   view
2674   returns (uint256 unlockableTokens)
2675   {
2676     for (uint256 i = 0; i < lockReason[_of].length; i++) {
2677       unlockableTokens = unlockableTokens.add(_tokensUnlockable(_of, lockReason[_of][i]));
2678     }
2679   }
2680 
2681   /**
2682   * @dev Returns tokens locked for a specified address for a
2683   *    specified reason
2684   *
2685   * @param _of The address whose tokens are locked
2686   * @param _reason The reason to query the lock tokens for
2687   */
2688   function tokensLocked(address _of, bytes32 _reason)
2689   public
2690   view
2691   returns (uint256 amount)
2692   {
2693     return _tokensLocked(_of, _reason);
2694   }
2695 
2696   /**
2697   * @dev Returns unlockable tokens for a specified address for a specified reason
2698   * @param _of The address to query the the unlockable token count of
2699   * @param _reason The reason to query the unlockable tokens for
2700   */
2701   function tokensUnlockable(address _of, bytes32 _reason)
2702   public
2703   view
2704   returns (uint256 amount)
2705   {
2706     return _tokensUnlockable(_of, _reason);
2707   }
2708 
2709   function totalSupply() public view returns (uint256)
2710   {
2711     return token.totalSupply();
2712   }
2713 
2714   /**
2715   * @dev Returns tokens locked for a specified address for a
2716   *    specified reason at a specific time
2717   *
2718   * @param _of The address whose tokens are locked
2719   * @param _reason The reason to query the lock tokens for
2720   * @param _time The timestamp to query the lock tokens for
2721   */
2722   function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
2723   public
2724   view
2725   returns (uint256 amount)
2726   {
2727     return _tokensLockedAtTime(_of, _reason, _time);
2728   }
2729 
2730   /**
2731   * @dev Returns the total amount of tokens held by an address:
2732   *   transferable + locked + staked for pooled staking - pending burns.
2733   *   Used by Claims and Governance in member voting to calculate the user's vote weight.
2734   *
2735   * @param _of The address to query the total balance of
2736   * @param _of The address to query the total balance of
2737   */
2738   function totalBalanceOf(address _of) public view returns (uint256 amount) {
2739 
2740     amount = token.balanceOf(_of);
2741 
2742     for (uint256 i = 0; i < lockReason[_of].length; i++) {
2743       amount = amount.add(_tokensLocked(_of, lockReason[_of][i]));
2744     }
2745 
2746     uint stakerReward = pooledStaking.stakerReward(_of);
2747     uint stakerDeposit = pooledStaking.stakerDeposit(_of);
2748 
2749     amount = amount.add(stakerDeposit).add(stakerReward);
2750   }
2751 
2752   /**
2753   * @dev Returns the total locked tokens at time
2754   *   Returns the total amount of locked and staked tokens at a given time. Used by MemberRoles to check eligibility
2755   *   for withdraw / switch membership. Includes tokens locked for Claim Assessment and staked for Risk Assessment.
2756   *   Does not take into account pending burns.
2757   *
2758   * @param _of member whose locked tokens are to be calculate
2759   * @param _time timestamp when the tokens should be locked
2760   */
2761   function totalLockedBalance(address _of, uint256 _time) public view returns (uint256 amount) {
2762 
2763     for (uint256 i = 0; i < lockReason[_of].length; i++) {
2764       amount = amount.add(_tokensLockedAtTime(_of, lockReason[_of][i], _time));
2765     }
2766 
2767     amount = amount.add(pooledStaking.stakerDeposit(_of));
2768   }
2769 
2770   /**
2771   * @dev Locks a specified amount of tokens against an address,
2772   *    for a specified reason and time
2773   * @param _of address whose tokens are to be locked
2774   * @param _reason The reason to lock tokens
2775   * @param _amount Number of tokens to be locked
2776   * @param _time Lock time in seconds
2777   */
2778   function _lock(address _of, bytes32 _reason, uint256 _amount, uint256 _time) internal {
2779     require(_tokensLocked(_of, _reason) == 0);
2780     require(_amount != 0);
2781 
2782     if (locked[_of][_reason].amount == 0) {
2783       lockReason[_of].push(_reason);
2784     }
2785 
2786     require(token.operatorTransfer(_of, _amount));
2787 
2788     uint256 validUntil = now.add(_time); // solhint-disable-line
2789     locked[_of][_reason] = LockToken(_amount, validUntil, false);
2790     emit Locked(_of, _reason, _amount, validUntil);
2791   }
2792 
2793   /**
2794   * @dev Returns tokens locked for a specified address for a
2795   *    specified reason
2796   *
2797   * @param _of The address whose tokens are locked
2798   * @param _reason The reason to query the lock tokens for
2799   */
2800   function _tokensLocked(address _of, bytes32 _reason)
2801   internal
2802   view
2803   returns (uint256 amount)
2804   {
2805     if (!locked[_of][_reason].claimed) {
2806       amount = locked[_of][_reason].amount;
2807     }
2808   }
2809 
2810   /**
2811   * @dev Returns tokens locked for a specified address for a
2812   *    specified reason at a specific time
2813   *
2814   * @param _of The address whose tokens are locked
2815   * @param _reason The reason to query the lock tokens for
2816   * @param _time The timestamp to query the lock tokens for
2817   */
2818   function _tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
2819   internal
2820   view
2821   returns (uint256 amount)
2822   {
2823     if (locked[_of][_reason].validity > _time) {
2824       amount = locked[_of][_reason].amount;
2825     }
2826   }
2827 
2828   /**
2829   * @dev Extends lock for a specified reason and time
2830   * @param _of The address whose tokens are locked
2831   * @param _reason The reason to lock tokens
2832   * @param _time Lock extension time in seconds
2833   */
2834   function _extendLock(address _of, bytes32 _reason, uint256 _time) internal {
2835     require(_tokensLocked(_of, _reason) > 0);
2836     emit Unlocked(_of, _reason, locked[_of][_reason].amount);
2837     locked[_of][_reason].validity = locked[_of][_reason].validity.add(_time);
2838     emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
2839   }
2840 
2841   /**
2842   * @dev reduce lock duration for a specified reason and time
2843   * @param _of The address whose tokens are locked
2844   * @param _reason The reason to lock tokens
2845   * @param _time Lock reduction time in seconds
2846   */
2847   function _reduceLock(address _of, bytes32 _reason, uint256 _time) internal {
2848     require(_tokensLocked(_of, _reason) > 0);
2849     emit Unlocked(_of, _reason, locked[_of][_reason].amount);
2850     locked[_of][_reason].validity = locked[_of][_reason].validity.sub(_time);
2851     emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
2852   }
2853 
2854   /**
2855   * @dev Returns unlockable tokens for a specified address for a specified reason
2856   * @param _of The address to query the the unlockable token count of
2857   * @param _reason The reason to query the unlockable tokens for
2858   */
2859   function _tokensUnlockable(address _of, bytes32 _reason) internal view returns (uint256 amount)
2860   {
2861     if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) {
2862       amount = locked[_of][_reason].amount;
2863     }
2864   }
2865 
2866   /**
2867   * @dev Burns locked tokens of a user
2868   * @param _of address whose tokens are to be burned
2869   * @param _reason lock reason for which tokens are to be burned
2870   * @param _amount amount of tokens to burn
2871   */
2872   function _burnLockedTokens(address _of, bytes32 _reason, uint256 _amount) internal {
2873     uint256 amount = _tokensLocked(_of, _reason);
2874     require(amount >= _amount);
2875 
2876     if (amount == _amount) {
2877       locked[_of][_reason].claimed = true;
2878     }
2879 
2880     locked[_of][_reason].amount = locked[_of][_reason].amount.sub(_amount);
2881     if (locked[_of][_reason].amount == 0) {
2882       _removeReason(_of, _reason);
2883     }
2884     token.burn(_amount);
2885     emit Burned(_of, _reason, _amount);
2886   }
2887 
2888   /**
2889   * @dev Released locked tokens of an address locked for a specific reason
2890   * @param _of address whose tokens are to be released from lock
2891   * @param _reason reason of the lock
2892   * @param _amount amount of tokens to release
2893   */
2894   function _releaseLockedTokens(address _of, bytes32 _reason, uint256 _amount) internal
2895   {
2896     uint256 amount = _tokensLocked(_of, _reason);
2897     require(amount >= _amount);
2898 
2899     if (amount == _amount) {
2900       locked[_of][_reason].claimed = true;
2901     }
2902 
2903     locked[_of][_reason].amount = locked[_of][_reason].amount.sub(_amount);
2904     if (locked[_of][_reason].amount == 0) {
2905       _removeReason(_of, _reason);
2906     }
2907     require(token.transfer(_of, _amount));
2908     emit Unlocked(_of, _reason, _amount);
2909   }
2910 
2911   function _removeReason(address _of, bytes32 _reason) internal {
2912     uint len = lockReason[_of].length;
2913     for (uint i = 0; i < len; i++) {
2914       if (lockReason[_of][i] == _reason) {
2915         lockReason[_of][i] = lockReason[_of][len.sub(1)];
2916         lockReason[_of].pop();
2917         break;
2918       }
2919     }
2920   }
2921 }
2922 
2923 // File: contracts/modules/token/TokenData.sol
2924 
2925 /* Copyright (C) 2020 NexusMutual.io
2926 
2927   This program is free software: you can redistribute it and/or modify
2928     it under the terms of the GNU General Public License as published by
2929     the Free Software Foundation, either version 3 of the License, or
2930     (at your option) any later version.
2931 
2932   This program is distributed in the hope that it will be useful,
2933     but WITHOUT ANY WARRANTY; without even the implied warranty of
2934     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2935     GNU General Public License for more details.
2936 
2937   You should have received a copy of the GNU General Public License
2938     along with this program.  If not, see http://www.gnu.org/licenses/ */
2939 
2940 pragma solidity ^0.5.0;
2941 
2942 
2943 
2944 contract TokenData is Iupgradable {
2945   using SafeMath for uint;
2946 
2947   address payable public walletAddress;
2948   uint public lockTokenTimeAfterCoverExp;
2949   uint public bookTime;
2950   uint public lockCADays;
2951   uint public lockMVDays;
2952   uint public scValidDays;
2953   uint public joiningFee;
2954   uint public stakerCommissionPer;
2955   uint public stakerMaxCommissionPer;
2956   uint public tokenExponent;
2957   uint public priceStep;
2958 
2959   struct StakeCommission {
2960     uint commissionEarned;
2961     uint commissionRedeemed;
2962   }
2963 
2964   struct Stake {
2965     address stakedContractAddress;
2966     uint stakedContractIndex;
2967     uint dateAdd;
2968     uint stakeAmount;
2969     uint unlockedAmount;
2970     uint burnedAmount;
2971     uint unLockableBeforeLastBurn;
2972   }
2973 
2974   struct Staker {
2975     address stakerAddress;
2976     uint stakerIndex;
2977   }
2978 
2979   struct CoverNote {
2980     uint amount;
2981     bool isDeposited;
2982   }
2983 
2984   /**
2985    * @dev mapping of uw address to array of sc address to fetch
2986    * all staked contract address of underwriter, pushing
2987    * data into this array of Stake returns stakerIndex
2988    */
2989   mapping(address => Stake[]) public stakerStakedContracts;
2990 
2991   /**
2992    * @dev mapping of sc address to array of UW address to fetch
2993    * all underwritters of the staked smart contract
2994    * pushing data into this mapped array returns scIndex
2995    */
2996   mapping(address => Staker[]) public stakedContractStakers;
2997 
2998   /**
2999    * @dev mapping of staked contract Address to the array of StakeCommission
3000    * here index of this array is stakedContractIndex
3001    */
3002   mapping(address => mapping(uint => StakeCommission)) public stakedContractStakeCommission;
3003 
3004   mapping(address => uint) public lastCompletedStakeCommission;
3005 
3006   /**
3007    * @dev mapping of the staked contract address to the current
3008    * staker index who will receive commission.
3009    */
3010   mapping(address => uint) public stakedContractCurrentCommissionIndex;
3011 
3012   /**
3013    * @dev mapping of the staked contract address to the
3014    * current staker index to burn token from.
3015    */
3016   mapping(address => uint) public stakedContractCurrentBurnIndex;
3017 
3018   /**
3019    * @dev mapping to return true if Cover Note deposited against coverId
3020    */
3021   mapping(uint => CoverNote) public depositedCN;
3022 
3023   mapping(address => uint) internal isBookedTokens;
3024 
3025   event Commission(
3026     address indexed stakedContractAddress,
3027     address indexed stakerAddress,
3028     uint indexed scIndex,
3029     uint commissionAmount
3030   );
3031 
3032   constructor(address payable _walletAdd) public {
3033     walletAddress = _walletAdd;
3034     bookTime = 12 hours;
3035     joiningFee = 2000000000000000; // 0.002 Ether
3036     lockTokenTimeAfterCoverExp = 35 days;
3037     scValidDays = 250;
3038     lockCADays = 7 days;
3039     lockMVDays = 2 days;
3040     stakerCommissionPer = 20;
3041     stakerMaxCommissionPer = 50;
3042     tokenExponent = 4;
3043     priceStep = 1000;
3044   }
3045 
3046   /**
3047    * @dev Change the wallet address which receive Joining Fee
3048    */
3049   function changeWalletAddress(address payable _address) external onlyInternal {
3050     walletAddress = _address;
3051   }
3052 
3053   /**
3054    * @dev Gets Uint Parameters of a code
3055    * @param code whose details we want
3056    * @return string value of the code
3057    * @return associated amount (time or perc or value) to the code
3058    */
3059   function getUintParameters(bytes8 code) external view returns (bytes8 codeVal, uint val) {
3060     codeVal = code;
3061     if (code == "TOKEXP") {
3062 
3063       val = tokenExponent;
3064 
3065     } else if (code == "TOKSTEP") {
3066 
3067       val = priceStep;
3068 
3069     } else if (code == "RALOCKT") {
3070 
3071       val = scValidDays;
3072 
3073     } else if (code == "RACOMM") {
3074 
3075       val = stakerCommissionPer;
3076 
3077     } else if (code == "RAMAXC") {
3078 
3079       val = stakerMaxCommissionPer;
3080 
3081     } else if (code == "CABOOKT") {
3082 
3083       val = bookTime / (1 hours);
3084 
3085     } else if (code == "CALOCKT") {
3086 
3087       val = lockCADays / (1 days);
3088 
3089     } else if (code == "MVLOCKT") {
3090 
3091       val = lockMVDays / (1 days);
3092 
3093     } else if (code == "QUOLOCKT") {
3094 
3095       val = lockTokenTimeAfterCoverExp / (1 days);
3096 
3097     } else if (code == "JOINFEE") {
3098 
3099       val = joiningFee;
3100 
3101     }
3102   }
3103 
3104   /**
3105   * @dev Just for interface
3106   */
3107   function changeDependentContractAddress() public {//solhint-disable-line
3108   }
3109 
3110   /**
3111    * @dev to get the contract staked by a staker
3112    * @param _stakerAddress is the address of the staker
3113    * @param _stakerIndex is the index of staker
3114    * @return the address of staked contract
3115    */
3116   function getStakerStakedContractByIndex(
3117     address _stakerAddress,
3118     uint _stakerIndex
3119   )
3120   public
3121   view
3122   returns (address stakedContractAddress)
3123   {
3124     stakedContractAddress = stakerStakedContracts[
3125     _stakerAddress][_stakerIndex].stakedContractAddress;
3126   }
3127 
3128   /**
3129    * @dev to get the staker's staked burned
3130    * @param _stakerAddress is the address of the staker
3131    * @param _stakerIndex is the index of staker
3132    * @return amount burned
3133    */
3134   function getStakerStakedBurnedByIndex(
3135     address _stakerAddress,
3136     uint _stakerIndex
3137   )
3138   public
3139   view
3140   returns (uint burnedAmount)
3141   {
3142     burnedAmount = stakerStakedContracts[
3143     _stakerAddress][_stakerIndex].burnedAmount;
3144   }
3145 
3146   /**
3147    * @dev to get the staker's staked unlockable before the last burn
3148    * @param _stakerAddress is the address of the staker
3149    * @param _stakerIndex is the index of staker
3150    * @return unlockable staked tokens
3151    */
3152   function getStakerStakedUnlockableBeforeLastBurnByIndex(
3153     address _stakerAddress,
3154     uint _stakerIndex
3155   )
3156   public
3157   view
3158   returns (uint unlockable)
3159   {
3160     unlockable = stakerStakedContracts[
3161     _stakerAddress][_stakerIndex].unLockableBeforeLastBurn;
3162   }
3163 
3164   /**
3165    * @dev to get the staker's staked contract index
3166    * @param _stakerAddress is the address of the staker
3167    * @param _stakerIndex is the index of staker
3168    * @return is the index of the smart contract address
3169    */
3170   function getStakerStakedContractIndex(
3171     address _stakerAddress,
3172     uint _stakerIndex
3173   )
3174   public
3175   view
3176   returns (uint scIndex)
3177   {
3178     scIndex = stakerStakedContracts[
3179     _stakerAddress][_stakerIndex].stakedContractIndex;
3180   }
3181 
3182   /**
3183    * @dev to get the staker index of the staked contract
3184    * @param _stakedContractAddress is the address of the staked contract
3185    * @param _stakedContractIndex is the index of staked contract
3186    * @return is the index of the staker
3187    */
3188   function getStakedContractStakerIndex(
3189     address _stakedContractAddress,
3190     uint _stakedContractIndex
3191   )
3192   public
3193   view
3194   returns (uint sIndex)
3195   {
3196     sIndex = stakedContractStakers[
3197     _stakedContractAddress][_stakedContractIndex].stakerIndex;
3198   }
3199 
3200   /**
3201    * @dev to get the staker's initial staked amount on the contract
3202    * @param _stakerAddress is the address of the staker
3203    * @param _stakerIndex is the index of staker
3204    * @return staked amount
3205    */
3206   function getStakerInitialStakedAmountOnContract(
3207     address _stakerAddress,
3208     uint _stakerIndex
3209   )
3210   public
3211   view
3212   returns (uint amount)
3213   {
3214     amount = stakerStakedContracts[
3215     _stakerAddress][_stakerIndex].stakeAmount;
3216   }
3217 
3218   /**
3219    * @dev to get the staker's staked contract length
3220    * @param _stakerAddress is the address of the staker
3221    * @return length of staked contract
3222    */
3223   function getStakerStakedContractLength(
3224     address _stakerAddress
3225   )
3226   public
3227   view
3228   returns (uint length)
3229   {
3230     length = stakerStakedContracts[_stakerAddress].length;
3231   }
3232 
3233   /**
3234    * @dev to get the staker's unlocked tokens which were staked
3235    * @param _stakerAddress is the address of the staker
3236    * @param _stakerIndex is the index of staker
3237    * @return amount
3238    */
3239   function getStakerUnlockedStakedTokens(
3240     address _stakerAddress,
3241     uint _stakerIndex
3242   )
3243   public
3244   view
3245   returns (uint amount)
3246   {
3247     amount = stakerStakedContracts[
3248     _stakerAddress][_stakerIndex].unlockedAmount;
3249   }
3250 
3251   /**
3252    * @dev pushes the unlocked staked tokens by a staker.
3253    * @param _stakerAddress address of staker.
3254    * @param _stakerIndex index of the staker to distribute commission.
3255    * @param _amount amount to be given as commission.
3256    */
3257   function pushUnlockedStakedTokens(
3258     address _stakerAddress,
3259     uint _stakerIndex,
3260     uint _amount
3261   )
3262   public
3263   onlyInternal
3264   {
3265     stakerStakedContracts[_stakerAddress][
3266     _stakerIndex].unlockedAmount = stakerStakedContracts[_stakerAddress][
3267     _stakerIndex].unlockedAmount.add(_amount);
3268   }
3269 
3270   /**
3271    * @dev pushes the Burned tokens for a staker.
3272    * @param _stakerAddress address of staker.
3273    * @param _stakerIndex index of the staker.
3274    * @param _amount amount to be burned.
3275    */
3276   function pushBurnedTokens(
3277     address _stakerAddress,
3278     uint _stakerIndex,
3279     uint _amount
3280   )
3281   public
3282   onlyInternal
3283   {
3284     stakerStakedContracts[_stakerAddress][
3285     _stakerIndex].burnedAmount = stakerStakedContracts[_stakerAddress][
3286     _stakerIndex].burnedAmount.add(_amount);
3287   }
3288 
3289   /**
3290    * @dev pushes the unLockable tokens for a staker before last burn.
3291    * @param _stakerAddress address of staker.
3292    * @param _stakerIndex index of the staker.
3293    * @param _amount amount to be added to unlockable.
3294    */
3295   function pushUnlockableBeforeLastBurnTokens(
3296     address _stakerAddress,
3297     uint _stakerIndex,
3298     uint _amount
3299   )
3300   public
3301   onlyInternal
3302   {
3303     stakerStakedContracts[_stakerAddress][
3304     _stakerIndex].unLockableBeforeLastBurn = stakerStakedContracts[_stakerAddress][
3305     _stakerIndex].unLockableBeforeLastBurn.add(_amount);
3306   }
3307 
3308   /**
3309    * @dev sets the unLockable tokens for a staker before last burn.
3310    * @param _stakerAddress address of staker.
3311    * @param _stakerIndex index of the staker.
3312    * @param _amount amount to be added to unlockable.
3313    */
3314   function setUnlockableBeforeLastBurnTokens(
3315     address _stakerAddress,
3316     uint _stakerIndex,
3317     uint _amount
3318   )
3319   public
3320   onlyInternal
3321   {
3322     stakerStakedContracts[_stakerAddress][
3323     _stakerIndex].unLockableBeforeLastBurn = _amount;
3324   }
3325 
3326   /**
3327    * @dev pushes the earned commission earned by a staker.
3328    * @param _stakerAddress address of staker.
3329    * @param _stakedContractAddress address of smart contract.
3330    * @param _stakedContractIndex index of the staker to distribute commission.
3331    * @param _commissionAmount amount to be given as commission.
3332    */
3333   function pushEarnedStakeCommissions(
3334     address _stakerAddress,
3335     address _stakedContractAddress,
3336     uint _stakedContractIndex,
3337     uint _commissionAmount
3338   )
3339   public
3340   onlyInternal
3341   {
3342     stakedContractStakeCommission[_stakedContractAddress][_stakedContractIndex].
3343     commissionEarned = stakedContractStakeCommission[_stakedContractAddress][
3344     _stakedContractIndex].commissionEarned.add(_commissionAmount);
3345 
3346     emit Commission(
3347       _stakerAddress,
3348       _stakedContractAddress,
3349       _stakedContractIndex,
3350       _commissionAmount
3351     );
3352   }
3353 
3354   /**
3355    * @dev pushes the redeemed commission redeemed by a staker.
3356    * @param _stakerAddress address of staker.
3357    * @param _stakerIndex index of the staker to distribute commission.
3358    * @param _amount amount to be given as commission.
3359    */
3360   function pushRedeemedStakeCommissions(
3361     address _stakerAddress,
3362     uint _stakerIndex,
3363     uint _amount
3364   )
3365   public
3366   onlyInternal
3367   {
3368     uint stakedContractIndex = stakerStakedContracts[
3369     _stakerAddress][_stakerIndex].stakedContractIndex;
3370     address stakedContractAddress = stakerStakedContracts[
3371     _stakerAddress][_stakerIndex].stakedContractAddress;
3372     stakedContractStakeCommission[stakedContractAddress][stakedContractIndex].
3373     commissionRedeemed = stakedContractStakeCommission[
3374     stakedContractAddress][stakedContractIndex].commissionRedeemed.add(_amount);
3375   }
3376 
3377   /**
3378    * @dev Gets stake commission given to an underwriter
3379    * for particular stakedcontract on given index.
3380    * @param _stakerAddress address of staker.
3381    * @param _stakerIndex index of the staker commission.
3382    */
3383   function getStakerEarnedStakeCommission(
3384     address _stakerAddress,
3385     uint _stakerIndex
3386   )
3387   public
3388   view
3389   returns (uint)
3390   {
3391     return _getStakerEarnedStakeCommission(_stakerAddress, _stakerIndex);
3392   }
3393 
3394   /**
3395    * @dev Gets stake commission redeemed by an underwriter
3396    * for particular staked contract on given index.
3397    * @param _stakerAddress address of staker.
3398    * @param _stakerIndex index of the staker commission.
3399    * @return commissionEarned total amount given to staker.
3400    */
3401   function getStakerRedeemedStakeCommission(
3402     address _stakerAddress,
3403     uint _stakerIndex
3404   )
3405   public
3406   view
3407   returns (uint)
3408   {
3409     return _getStakerRedeemedStakeCommission(_stakerAddress, _stakerIndex);
3410   }
3411 
3412   /**
3413    * @dev Gets total stake commission given to an underwriter
3414    * @param _stakerAddress address of staker.
3415    * @return totalCommissionEarned total commission earned by staker.
3416    */
3417   function getStakerTotalEarnedStakeCommission(
3418     address _stakerAddress
3419   )
3420   public
3421   view
3422   returns (uint totalCommissionEarned)
3423   {
3424     totalCommissionEarned = 0;
3425     for (uint i = 0; i < stakerStakedContracts[_stakerAddress].length; i++) {
3426       totalCommissionEarned = totalCommissionEarned.
3427       add(_getStakerEarnedStakeCommission(_stakerAddress, i));
3428     }
3429   }
3430 
3431   /**
3432    * @dev Gets total stake commission given to an underwriter
3433    * @param _stakerAddress address of staker.
3434    * @return totalCommissionEarned total commission earned by staker.
3435    */
3436   function getStakerTotalReedmedStakeCommission(
3437     address _stakerAddress
3438   )
3439   public
3440   view
3441   returns (uint totalCommissionRedeemed)
3442   {
3443     totalCommissionRedeemed = 0;
3444     for (uint i = 0; i < stakerStakedContracts[_stakerAddress].length; i++) {
3445       totalCommissionRedeemed = totalCommissionRedeemed.add(
3446         _getStakerRedeemedStakeCommission(_stakerAddress, i));
3447     }
3448   }
3449 
3450   /**
3451    * @dev set flag to deposit/ undeposit cover note
3452    * against a cover Id
3453    * @param coverId coverId of Cover
3454    * @param flag true/false for deposit/undeposit
3455    */
3456   function setDepositCN(uint coverId, bool flag) public onlyInternal {
3457 
3458     if (flag == true) {
3459       require(!depositedCN[coverId].isDeposited, "Cover note already deposited");
3460     }
3461 
3462     depositedCN[coverId].isDeposited = flag;
3463   }
3464 
3465   /**
3466    * @dev set locked cover note amount
3467    * against a cover Id
3468    * @param coverId coverId of Cover
3469    * @param amount amount of nxm to be locked
3470    */
3471   function setDepositCNAmount(uint coverId, uint amount) public onlyInternal {
3472 
3473     depositedCN[coverId].amount = amount;
3474   }
3475 
3476   /**
3477    * @dev to get the staker address on a staked contract
3478    * @param _stakedContractAddress is the address of the staked contract in concern
3479    * @param _stakedContractIndex is the index of staked contract's index
3480    * @return address of staker
3481    */
3482   function getStakedContractStakerByIndex(
3483     address _stakedContractAddress,
3484     uint _stakedContractIndex
3485   )
3486   public
3487   view
3488   returns (address stakerAddress)
3489   {
3490     stakerAddress = stakedContractStakers[
3491     _stakedContractAddress][_stakedContractIndex].stakerAddress;
3492   }
3493 
3494   /**
3495    * @dev to get the length of stakers on a staked contract
3496    * @param _stakedContractAddress is the address of the staked contract in concern
3497    * @return length in concern
3498    */
3499   function getStakedContractStakersLength(
3500     address _stakedContractAddress
3501   )
3502   public
3503   view
3504   returns (uint length)
3505   {
3506     length = stakedContractStakers[_stakedContractAddress].length;
3507   }
3508 
3509   /**
3510    * @dev Adds a new stake record.
3511    * @param _stakerAddress staker address.
3512    * @param _stakedContractAddress smart contract address.
3513    * @param _amount amountof NXM to be staked.
3514    */
3515   function addStake(
3516     address _stakerAddress,
3517     address _stakedContractAddress,
3518     uint _amount
3519   )
3520   public
3521   onlyInternal
3522   returns (uint scIndex)
3523   {
3524     scIndex = (stakedContractStakers[_stakedContractAddress].push(
3525       Staker(_stakerAddress, stakerStakedContracts[_stakerAddress].length))).sub(1);
3526     stakerStakedContracts[_stakerAddress].push(
3527       Stake(_stakedContractAddress, scIndex, now, _amount, 0, 0, 0));
3528   }
3529 
3530   /**
3531    * @dev books the user's tokens for maintaining Assessor Velocity,
3532    * i.e. once a token is used to cast a vote as a Claims assessor,
3533    * @param _of user's address.
3534    */
3535   function bookCATokens(address _of) public onlyInternal {
3536     require(!isCATokensBooked(_of), "Tokens already booked");
3537     isBookedTokens[_of] = now.add(bookTime);
3538   }
3539 
3540   /**
3541    * @dev to know if claim assessor's tokens are booked or not
3542    * @param _of is the claim assessor's address in concern
3543    * @return boolean representing the status of tokens booked
3544    */
3545   function isCATokensBooked(address _of) public view returns (bool res) {
3546     if (now < isBookedTokens[_of])
3547       res = true;
3548   }
3549 
3550   /**
3551    * @dev Sets the index which will receive commission.
3552    * @param _stakedContractAddress smart contract address.
3553    * @param _index current index.
3554    */
3555   function setStakedContractCurrentCommissionIndex(
3556     address _stakedContractAddress,
3557     uint _index
3558   )
3559   public
3560   onlyInternal
3561   {
3562     stakedContractCurrentCommissionIndex[_stakedContractAddress] = _index;
3563   }
3564 
3565   /**
3566    * @dev Sets the last complete commission index
3567    * @param _stakerAddress smart contract address.
3568    * @param _index current index.
3569    */
3570   function setLastCompletedStakeCommissionIndex(
3571     address _stakerAddress,
3572     uint _index
3573   )
3574   public
3575   onlyInternal
3576   {
3577     lastCompletedStakeCommission[_stakerAddress] = _index;
3578   }
3579 
3580   /**
3581    * @dev Sets the index till which commission is distrubuted.
3582    * @param _stakedContractAddress smart contract address.
3583    * @param _index current index.
3584    */
3585   function setStakedContractCurrentBurnIndex(
3586     address _stakedContractAddress,
3587     uint _index
3588   )
3589   public
3590   onlyInternal
3591   {
3592     stakedContractCurrentBurnIndex[_stakedContractAddress] = _index;
3593   }
3594 
3595   /**
3596    * @dev Updates Uint Parameters of a code
3597    * @param code whose details we want to update
3598    * @param val value to set
3599    */
3600   function updateUintParameters(bytes8 code, uint val) public {
3601     require(ms.checkIsAuthToGoverned(msg.sender));
3602     if (code == "TOKEXP") {
3603 
3604       _setTokenExponent(val);
3605 
3606     } else if (code == "TOKSTEP") {
3607 
3608       _setPriceStep(val);
3609 
3610     } else if (code == "RALOCKT") {
3611 
3612       _changeSCValidDays(val);
3613 
3614     } else if (code == "RACOMM") {
3615 
3616       _setStakerCommissionPer(val);
3617 
3618     } else if (code == "RAMAXC") {
3619 
3620       _setStakerMaxCommissionPer(val);
3621 
3622     } else if (code == "CABOOKT") {
3623 
3624       _changeBookTime(val * 1 hours);
3625 
3626     } else if (code == "CALOCKT") {
3627 
3628       _changelockCADays(val * 1 days);
3629 
3630     } else if (code == "MVLOCKT") {
3631 
3632       _changelockMVDays(val * 1 days);
3633 
3634     } else if (code == "QUOLOCKT") {
3635 
3636       _setLockTokenTimeAfterCoverExp(val * 1 days);
3637 
3638     } else if (code == "JOINFEE") {
3639 
3640       _setJoiningFee(val);
3641 
3642     } else {
3643       revert("Invalid param code");
3644     }
3645   }
3646 
3647   /**
3648    * @dev Internal function to get stake commission given to an
3649    * underwriter for particular stakedcontract on given index.
3650    * @param _stakerAddress address of staker.
3651    * @param _stakerIndex index of the staker commission.
3652    */
3653   function _getStakerEarnedStakeCommission(
3654     address _stakerAddress,
3655     uint _stakerIndex
3656   )
3657   internal
3658   view
3659   returns (uint amount)
3660   {
3661     uint _stakedContractIndex;
3662     address _stakedContractAddress;
3663     _stakedContractAddress = stakerStakedContracts[
3664     _stakerAddress][_stakerIndex].stakedContractAddress;
3665     _stakedContractIndex = stakerStakedContracts[
3666     _stakerAddress][_stakerIndex].stakedContractIndex;
3667     amount = stakedContractStakeCommission[
3668     _stakedContractAddress][_stakedContractIndex].commissionEarned;
3669   }
3670 
3671   /**
3672    * @dev Internal function to get stake commission redeemed by an
3673    * underwriter for particular stakedcontract on given index.
3674    * @param _stakerAddress address of staker.
3675    * @param _stakerIndex index of the staker commission.
3676    */
3677   function _getStakerRedeemedStakeCommission(
3678     address _stakerAddress,
3679     uint _stakerIndex
3680   )
3681   internal
3682   view
3683   returns (uint amount)
3684   {
3685     uint _stakedContractIndex;
3686     address _stakedContractAddress;
3687     _stakedContractAddress = stakerStakedContracts[
3688     _stakerAddress][_stakerIndex].stakedContractAddress;
3689     _stakedContractIndex = stakerStakedContracts[
3690     _stakerAddress][_stakerIndex].stakedContractIndex;
3691     amount = stakedContractStakeCommission[
3692     _stakedContractAddress][_stakedContractIndex].commissionRedeemed;
3693   }
3694 
3695   /**
3696    * @dev to set the percentage of staker commission
3697    * @param _val is new percentage value
3698    */
3699   function _setStakerCommissionPer(uint _val) internal {
3700     stakerCommissionPer = _val;
3701   }
3702 
3703   /**
3704    * @dev to set the max percentage of staker commission
3705    * @param _val is new percentage value
3706    */
3707   function _setStakerMaxCommissionPer(uint _val) internal {
3708     stakerMaxCommissionPer = _val;
3709   }
3710 
3711   /**
3712    * @dev to set the token exponent value
3713    * @param _val is new value
3714    */
3715   function _setTokenExponent(uint _val) internal {
3716     tokenExponent = _val;
3717   }
3718 
3719   /**
3720    * @dev to set the price step
3721    * @param _val is new value
3722    */
3723   function _setPriceStep(uint _val) internal {
3724     priceStep = _val;
3725   }
3726 
3727   /**
3728    * @dev Changes number of days for which NXM needs to staked in case of underwriting
3729    */
3730   function _changeSCValidDays(uint _days) internal {
3731     scValidDays = _days;
3732   }
3733 
3734   /**
3735    * @dev Changes the time period up to which tokens will be locked.
3736    *      Used to generate the validity period of tokens booked by
3737    *      a user for participating in claim's assessment/claim's voting.
3738    */
3739   function _changeBookTime(uint _time) internal {
3740     bookTime = _time;
3741   }
3742 
3743   /**
3744    * @dev Changes lock CA days - number of days for which tokens
3745    * are locked while submitting a vote.
3746    */
3747   function _changelockCADays(uint _val) internal {
3748     lockCADays = _val;
3749   }
3750 
3751   /**
3752    * @dev Changes lock MV days - number of days for which tokens are locked
3753    * while submitting a vote.
3754    */
3755   function _changelockMVDays(uint _val) internal {
3756     lockMVDays = _val;
3757   }
3758 
3759   /**
3760    * @dev Changes extra lock period for a cover, post its expiry.
3761    */
3762   function _setLockTokenTimeAfterCoverExp(uint time) internal {
3763     lockTokenTimeAfterCoverExp = time;
3764   }
3765 
3766   /**
3767    * @dev Set the joining fee for membership
3768    */
3769   function _setJoiningFee(uint _amount) internal {
3770     joiningFee = _amount;
3771   }
3772 }
3773 
3774 // File: contracts/modules/governance/external/Governed.sol
3775 
3776 /* Copyright (C) 2017 GovBlocks.io
3777   This program is free software: you can redistribute it and/or modify
3778     it under the terms of the GNU General Public License as published by
3779     the Free Software Foundation, either version 3 of the License, or
3780     (at your option) any later version.
3781   This program is distributed in the hope that it will be useful,
3782     but WITHOUT ANY WARRANTY; without even the implied warranty of
3783     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3784     GNU General Public License for more details.
3785   You should have received a copy of the GNU General Public License
3786     along with this program.  If not, see http://www.gnu.org/licenses/ */
3787 
3788 pragma solidity ^0.5.0;
3789 
3790 
3791 interface IMaster {
3792   function getLatestAddress(bytes2 _module) external view returns (address);
3793 }
3794 
3795 contract Governed {
3796 
3797   address public masterAddress; // Name of the dApp, needs to be set by contracts inheriting this contract
3798 
3799   /// @dev modifier that allows only the authorized addresses to execute the function
3800   modifier onlyAuthorizedToGovern() {
3801     IMaster ms = IMaster(masterAddress);
3802     require(ms.getLatestAddress("GV") == msg.sender, "Not authorized");
3803     _;
3804   }
3805 
3806   /// @dev checks if an address is authorized to govern
3807   function isAuthorizedToGovern(address _toCheck) public view returns (bool) {
3808     IMaster ms = IMaster(masterAddress);
3809     return (ms.getLatestAddress("GV") == _toCheck);
3810   }
3811 
3812 }
3813 
3814 // File: contracts/modules/governance/external/IProposalCategory.sol
3815 
3816 /* Copyright (C) 2017 GovBlocks.io
3817   This program is free software: you can redistribute it and/or modify
3818     it under the terms of the GNU General Public License as published by
3819     the Free Software Foundation, either version 3 of the License, or
3820     (at your option) any later version.
3821   This program is distributed in the hope that it will be useful,
3822     but WITHOUT ANY WARRANTY; without even the implied warranty of
3823     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3824     GNU General Public License for more details.
3825   You should have received a copy of the GNU General Public License
3826     along with this program.  If not, see http://www.gnu.org/licenses/ */
3827 
3828 pragma solidity ^0.5.0;
3829 
3830 contract IProposalCategory {
3831 
3832   event Category(
3833     uint indexed categoryId,
3834     string categoryName,
3835     string actionHash
3836   );
3837 
3838   /// @dev Adds new category
3839   /// @param _name Category name
3840   /// @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
3841   /// @param _allowedToCreateProposal Member roles allowed to create the proposal
3842   /// @param _majorityVotePerc Majority Vote threshold for Each voting layer
3843   /// @param _quorumPerc minimum threshold percentage required in voting to calculate result
3844   /// @param _closingTime Vote closing time for Each voting layer
3845   /// @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
3846   /// @param _contractAddress address of contract to call after proposal is accepted
3847   /// @param _contractName name of contract to be called after proposal is accepted
3848   /// @param _incentives rewards to distributed after proposal is accepted
3849   function addCategory(
3850     string calldata _name,
3851     uint _memberRoleToVote,
3852     uint _majorityVotePerc,
3853     uint _quorumPerc,
3854     uint[] calldata _allowedToCreateProposal,
3855     uint _closingTime,
3856     string calldata _actionHash,
3857     address _contractAddress,
3858     bytes2 _contractName,
3859     uint[] calldata _incentives
3860   )
3861   external;
3862 
3863   /// @dev gets category details
3864   function category(uint _categoryId)
3865   external
3866   view
3867   returns (
3868     uint categoryId,
3869     uint memberRoleToVote,
3870     uint majorityVotePerc,
3871     uint quorumPerc,
3872     uint[] memory allowedToCreateProposal,
3873     uint closingTime,
3874     uint minStake
3875   );
3876 
3877   ///@dev gets category action details
3878   function categoryAction(uint _categoryId)
3879   external
3880   view
3881   returns (
3882     uint categoryId,
3883     address contractAddress,
3884     bytes2 contractName,
3885     uint defaultIncentive
3886   );
3887 
3888   /// @dev Gets Total number of categories added till now
3889   function totalCategories() external view returns (uint numberOfCategories);
3890 
3891   /// @dev Updates category details
3892   /// @param _categoryId Category id that needs to be updated
3893   /// @param _name Category name
3894   /// @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
3895   /// @param _allowedToCreateProposal Member roles allowed to create the proposal
3896   /// @param _majorityVotePerc Majority Vote threshold for Each voting layer
3897   /// @param _quorumPerc minimum threshold percentage required in voting to calculate result
3898   /// @param _closingTime Vote closing time for Each voting layer
3899   /// @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
3900   /// @param _contractAddress address of contract to call after proposal is accepted
3901   /// @param _contractName name of contract to be called after proposal is accepted
3902   /// @param _incentives rewards to distributed after proposal is accepted
3903   function updateCategory(
3904     uint _categoryId,
3905     string memory _name,
3906     uint _memberRoleToVote,
3907     uint _majorityVotePerc,
3908     uint _quorumPerc,
3909     uint[] memory _allowedToCreateProposal,
3910     uint _closingTime,
3911     string memory _actionHash,
3912     address _contractAddress,
3913     bytes2 _contractName,
3914     uint[] memory _incentives
3915   )
3916   public;
3917 
3918 }
3919 
3920 // File: contracts/modules/governance/ProposalCategory.sol
3921 
3922 /* Copyright (C) 2017 GovBlocks.io
3923   This program is free software: you can redistribute it and/or modify
3924     it under the terms of the GNU General Public License as published by
3925     the Free Software Foundation, either version 3 of the License, or
3926     (at your option) any later version.
3927   This program is distributed in the hope that it will be useful,
3928     but WITHOUT ANY WARRANTY; without even the implied warranty of
3929     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3930     GNU General Public License for more details.
3931   You should have received a copy of the GNU General Public License
3932     along with this program.  If not, see http://www.gnu.org/licenses/ */
3933 pragma solidity ^0.5.0;
3934 
3935 
3936 
3937 
3938 
3939 contract ProposalCategory is Governed, IProposalCategory, Iupgradable {
3940 
3941   bool public constructorCheck;
3942   MemberRoles internal mr;
3943 
3944   struct CategoryStruct {
3945     uint memberRoleToVote;
3946     uint majorityVotePerc;
3947     uint quorumPerc;
3948     uint[] allowedToCreateProposal;
3949     uint closingTime;
3950     uint minStake;
3951   }
3952 
3953   struct CategoryAction {
3954     uint defaultIncentive;
3955     address contractAddress;
3956     bytes2 contractName;
3957   }
3958 
3959   CategoryStruct[] internal allCategory;
3960   mapping(uint => CategoryAction) internal categoryActionData;
3961   mapping(uint => uint) public categoryABReq;
3962   mapping(uint => uint) public isSpecialResolution;
3963   mapping(uint => bytes) public categoryActionHashes;
3964 
3965   bool public categoryActionHashUpdated;
3966 
3967   /**
3968   * @dev Adds new category (Discontinued, moved functionality to newCategory)
3969   * @param _name Category name
3970   * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
3971   * @param _majorityVotePerc Majority Vote threshold for Each voting layer
3972   * @param _quorumPerc minimum threshold percentage required in voting to calculate result
3973   * @param _allowedToCreateProposal Member roles allowed to create the proposal
3974   * @param _closingTime Vote closing time for Each voting layer
3975   * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
3976   * @param _contractAddress address of contract to call after proposal is accepted
3977   * @param _contractName name of contract to be called after proposal is accepted
3978   * @param _incentives rewards to distributed after proposal is accepted
3979   */
3980   function addCategory(
3981     string calldata _name,
3982     uint _memberRoleToVote,
3983     uint _majorityVotePerc,
3984     uint _quorumPerc,
3985     uint[] calldata _allowedToCreateProposal,
3986     uint _closingTime,
3987     string calldata _actionHash,
3988     address _contractAddress,
3989     bytes2 _contractName,
3990     uint[] calldata _incentives
3991   ) external {}
3992 
3993   /**
3994   * @dev Initiates Default settings for Proposal Category contract (Adding default categories)
3995   */
3996   function proposalCategoryInitiate() external {}
3997 
3998   /**
3999   * @dev Initiates Default action function hashes for existing categories
4000   * To be called after the contract has been upgraded by governance
4001   */
4002   function updateCategoryActionHashes() external onlyOwner {
4003 
4004     require(!categoryActionHashUpdated, "Category action hashes already updated");
4005     categoryActionHashUpdated = true;
4006     categoryActionHashes[1] = abi.encodeWithSignature("addRole(bytes32,string,address)");
4007     categoryActionHashes[2] = abi.encodeWithSignature("updateRole(address,uint256,bool)");
4008     categoryActionHashes[3] = abi.encodeWithSignature("newCategory(string,uint256,uint256,uint256,uint256[],uint256,string,address,bytes2,uint256[],string)"); // solhint-disable-line
4009     categoryActionHashes[4] = abi.encodeWithSignature("editCategory(uint256,string,uint256,uint256,uint256,uint256[],uint256,string,address,bytes2,uint256[],string)"); // solhint-disable-line
4010     categoryActionHashes[5] = abi.encodeWithSignature("upgradeContractImplementation(bytes2,address)");
4011     categoryActionHashes[6] = abi.encodeWithSignature("startEmergencyPause()");
4012     categoryActionHashes[7] = abi.encodeWithSignature("addEmergencyPause(bool,bytes4)");
4013     categoryActionHashes[8] = abi.encodeWithSignature("burnCAToken(uint256,uint256,address)");
4014     categoryActionHashes[9] = abi.encodeWithSignature("setUserClaimVotePausedOn(address)");
4015     categoryActionHashes[12] = abi.encodeWithSignature("transferEther(uint256,address)");
4016     categoryActionHashes[13] = abi.encodeWithSignature("addInvestmentAssetCurrency(bytes4,address,bool,uint64,uint64,uint8)"); // solhint-disable-line
4017     categoryActionHashes[14] = abi.encodeWithSignature("changeInvestmentAssetHoldingPerc(bytes4,uint64,uint64)");
4018     categoryActionHashes[15] = abi.encodeWithSignature("changeInvestmentAssetStatus(bytes4,bool)");
4019     categoryActionHashes[16] = abi.encodeWithSignature("swapABMember(address,address)");
4020     categoryActionHashes[17] = abi.encodeWithSignature("addCurrencyAssetCurrency(bytes4,address,uint256)");
4021     categoryActionHashes[20] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
4022     categoryActionHashes[21] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
4023     categoryActionHashes[22] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
4024     categoryActionHashes[23] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
4025     categoryActionHashes[24] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
4026     categoryActionHashes[25] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
4027     categoryActionHashes[26] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
4028     categoryActionHashes[27] = abi.encodeWithSignature("updateAddressParameters(bytes8,address)");
4029     categoryActionHashes[28] = abi.encodeWithSignature("updateOwnerParameters(bytes8,address)");
4030     categoryActionHashes[29] = abi.encodeWithSignature("upgradeContract(bytes2,address)");
4031     categoryActionHashes[30] = abi.encodeWithSignature("changeCurrencyAssetAddress(bytes4,address)");
4032     categoryActionHashes[31] = abi.encodeWithSignature("changeCurrencyAssetBaseMin(bytes4,uint256)");
4033     categoryActionHashes[32] = abi.encodeWithSignature("changeInvestmentAssetAddressAndDecimal(bytes4,address,uint8)"); // solhint-disable-line
4034     categoryActionHashes[33] = abi.encodeWithSignature("externalLiquidityTrade()");
4035   }
4036 
4037   /**
4038   * @dev Gets Total number of categories added till now
4039   */
4040   function totalCategories() external view returns (uint) {
4041     return allCategory.length;
4042   }
4043 
4044   /**
4045   * @dev Gets category details
4046   */
4047   function category(uint _categoryId) external view returns (uint, uint, uint, uint, uint[] memory, uint, uint) {
4048     return (
4049     _categoryId,
4050     allCategory[_categoryId].memberRoleToVote,
4051     allCategory[_categoryId].majorityVotePerc,
4052     allCategory[_categoryId].quorumPerc,
4053     allCategory[_categoryId].allowedToCreateProposal,
4054     allCategory[_categoryId].closingTime,
4055     allCategory[_categoryId].minStake
4056     );
4057   }
4058 
4059   /**
4060   * @dev Gets category ab required and isSpecialResolution
4061   * @return the category id
4062   * @return if AB voting is required
4063   * @return is category a special resolution
4064   */
4065   function categoryExtendedData(uint _categoryId) external view returns (uint, uint, uint) {
4066     return (
4067     _categoryId,
4068     categoryABReq[_categoryId],
4069     isSpecialResolution[_categoryId]
4070     );
4071   }
4072 
4073   /**
4074    * @dev Gets the category acion details
4075    * @param _categoryId is the category id in concern
4076    * @return the category id
4077    * @return the contract address
4078    * @return the contract name
4079    * @return the default incentive
4080    */
4081   function categoryAction(uint _categoryId) external view returns (uint, address, bytes2, uint) {
4082 
4083     return (
4084     _categoryId,
4085     categoryActionData[_categoryId].contractAddress,
4086     categoryActionData[_categoryId].contractName,
4087     categoryActionData[_categoryId].defaultIncentive
4088     );
4089   }
4090 
4091   /**
4092    * @dev Gets the category acion details of a category id
4093    * @param _categoryId is the category id in concern
4094    * @return the category id
4095    * @return the contract address
4096    * @return the contract name
4097    * @return the default incentive
4098    * @return action function hash
4099    */
4100   function categoryActionDetails(uint _categoryId) external view returns (uint, address, bytes2, uint, bytes memory) {
4101     return (
4102     _categoryId,
4103     categoryActionData[_categoryId].contractAddress,
4104     categoryActionData[_categoryId].contractName,
4105     categoryActionData[_categoryId].defaultIncentive,
4106     categoryActionHashes[_categoryId]
4107     );
4108   }
4109 
4110   /**
4111   * @dev Updates dependant contract addresses
4112   */
4113   function changeDependentContractAddress() public {
4114     mr = MemberRoles(ms.getLatestAddress("MR"));
4115   }
4116 
4117   /**
4118   * @dev Adds new category
4119   * @param _name Category name
4120   * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
4121   * @param _majorityVotePerc Majority Vote threshold for Each voting layer
4122   * @param _quorumPerc minimum threshold percentage required in voting to calculate result
4123   * @param _allowedToCreateProposal Member roles allowed to create the proposal
4124   * @param _closingTime Vote closing time for Each voting layer
4125   * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
4126   * @param _contractAddress address of contract to call after proposal is accepted
4127   * @param _contractName name of contract to be called after proposal is accepted
4128   * @param _incentives rewards to distributed after proposal is accepted
4129   * @param _functionHash function signature to be executed
4130   */
4131   function newCategory(
4132     string memory _name,
4133     uint _memberRoleToVote,
4134     uint _majorityVotePerc,
4135     uint _quorumPerc,
4136     uint[] memory _allowedToCreateProposal,
4137     uint _closingTime,
4138     string memory _actionHash,
4139     address _contractAddress,
4140     bytes2 _contractName,
4141     uint[] memory _incentives,
4142     string memory _functionHash
4143   )
4144   public
4145   onlyAuthorizedToGovern
4146   {
4147 
4148     require(_quorumPerc <= 100 && _majorityVotePerc <= 100, "Invalid percentage");
4149 
4150     require((_contractName == "EX" && _contractAddress == address(0)) || bytes(_functionHash).length > 0);
4151 
4152     require(_incentives[3] <= 1, "Invalid special resolution flag");
4153 
4154     //If category is special resolution role authorized should be member
4155     if (_incentives[3] == 1) {
4156       require(_memberRoleToVote == uint(MemberRoles.Role.Member));
4157       _majorityVotePerc = 0;
4158       _quorumPerc = 0;
4159     }
4160 
4161     _addCategory(
4162       _name,
4163       _memberRoleToVote,
4164       _majorityVotePerc,
4165       _quorumPerc,
4166       _allowedToCreateProposal,
4167       _closingTime,
4168       _actionHash,
4169       _contractAddress,
4170       _contractName,
4171       _incentives
4172     );
4173 
4174 
4175     if (bytes(_functionHash).length > 0 && abi.encodeWithSignature(_functionHash).length == 4) {
4176       categoryActionHashes[allCategory.length - 1] = abi.encodeWithSignature(_functionHash);
4177     }
4178   }
4179 
4180   /**
4181    * @dev Changes the master address and update it's instance
4182    * @param _masterAddress is the new master address
4183    */
4184   function changeMasterAddress(address _masterAddress) public {
4185     if (masterAddress != address(0))
4186       require(masterAddress == msg.sender);
4187     masterAddress = _masterAddress;
4188     ms = INXMMaster(_masterAddress);
4189     nxMasterAddress = _masterAddress;
4190 
4191   }
4192 
4193   /**
4194   * @dev Updates category details (Discontinued, moved functionality to editCategory)
4195   * @param _categoryId Category id that needs to be updated
4196   * @param _name Category name
4197   * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
4198   * @param _allowedToCreateProposal Member roles allowed to create the proposal
4199   * @param _majorityVotePerc Majority Vote threshold for Each voting layer
4200   * @param _quorumPerc minimum threshold percentage required in voting to calculate result
4201   * @param _closingTime Vote closing time for Each voting layer
4202   * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
4203   * @param _contractAddress address of contract to call after proposal is accepted
4204   * @param _contractName name of contract to be called after proposal is accepted
4205   * @param _incentives rewards to distributed after proposal is accepted
4206   */
4207   function updateCategory(
4208     uint _categoryId,
4209     string memory _name,
4210     uint _memberRoleToVote,
4211     uint _majorityVotePerc,
4212     uint _quorumPerc,
4213     uint[] memory _allowedToCreateProposal,
4214     uint _closingTime,
4215     string memory _actionHash,
4216     address _contractAddress,
4217     bytes2 _contractName,
4218     uint[] memory _incentives
4219   ) public {}
4220 
4221   /**
4222   * @dev Updates category details
4223   * @param _categoryId Category id that needs to be updated
4224   * @param _name Category name
4225   * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
4226   * @param _allowedToCreateProposal Member roles allowed to create the proposal
4227   * @param _majorityVotePerc Majority Vote threshold for Each voting layer
4228   * @param _quorumPerc minimum threshold percentage required in voting to calculate result
4229   * @param _closingTime Vote closing time for Each voting layer
4230   * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
4231   * @param _contractAddress address of contract to call after proposal is accepted
4232   * @param _contractName name of contract to be called after proposal is accepted
4233   * @param _incentives rewards to distributed after proposal is accepted
4234   * @param _functionHash function signature to be executed
4235   */
4236   function editCategory(
4237     uint _categoryId,
4238     string memory _name,
4239     uint _memberRoleToVote,
4240     uint _majorityVotePerc,
4241     uint _quorumPerc,
4242     uint[] memory _allowedToCreateProposal,
4243     uint _closingTime,
4244     string memory _actionHash,
4245     address _contractAddress,
4246     bytes2 _contractName,
4247     uint[] memory _incentives,
4248     string memory _functionHash
4249   )
4250   public
4251   onlyAuthorizedToGovern
4252   {
4253     require(_verifyMemberRoles(_memberRoleToVote, _allowedToCreateProposal) == 1, "Invalid Role");
4254 
4255     require(_quorumPerc <= 100 && _majorityVotePerc <= 100, "Invalid percentage");
4256 
4257     require((_contractName == "EX" && _contractAddress == address(0)) || bytes(_functionHash).length > 0);
4258 
4259     require(_incentives[3] <= 1, "Invalid special resolution flag");
4260 
4261     //If category is special resolution role authorized should be member
4262     if (_incentives[3] == 1) {
4263       require(_memberRoleToVote == uint(MemberRoles.Role.Member));
4264       _majorityVotePerc = 0;
4265       _quorumPerc = 0;
4266     }
4267 
4268     delete categoryActionHashes[_categoryId];
4269     if (bytes(_functionHash).length > 0 && abi.encodeWithSignature(_functionHash).length == 4) {
4270       categoryActionHashes[_categoryId] = abi.encodeWithSignature(_functionHash);
4271     }
4272     allCategory[_categoryId].memberRoleToVote = _memberRoleToVote;
4273     allCategory[_categoryId].majorityVotePerc = _majorityVotePerc;
4274     allCategory[_categoryId].closingTime = _closingTime;
4275     allCategory[_categoryId].allowedToCreateProposal = _allowedToCreateProposal;
4276     allCategory[_categoryId].minStake = _incentives[0];
4277     allCategory[_categoryId].quorumPerc = _quorumPerc;
4278     categoryActionData[_categoryId].defaultIncentive = _incentives[1];
4279     categoryActionData[_categoryId].contractName = _contractName;
4280     categoryActionData[_categoryId].contractAddress = _contractAddress;
4281     categoryABReq[_categoryId] = _incentives[2];
4282     isSpecialResolution[_categoryId] = _incentives[3];
4283     emit Category(_categoryId, _name, _actionHash);
4284   }
4285 
4286   /**
4287   * @dev Internal call to add new category
4288   * @param _name Category name
4289   * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
4290   * @param _majorityVotePerc Majority Vote threshold for Each voting layer
4291   * @param _quorumPerc minimum threshold percentage required in voting to calculate result
4292   * @param _allowedToCreateProposal Member roles allowed to create the proposal
4293   * @param _closingTime Vote closing time for Each voting layer
4294   * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
4295   * @param _contractAddress address of contract to call after proposal is accepted
4296   * @param _contractName name of contract to be called after proposal is accepted
4297   * @param _incentives rewards to distributed after proposal is accepted
4298   */
4299   function _addCategory(
4300     string memory _name,
4301     uint _memberRoleToVote,
4302     uint _majorityVotePerc,
4303     uint _quorumPerc,
4304     uint[] memory _allowedToCreateProposal,
4305     uint _closingTime,
4306     string memory _actionHash,
4307     address _contractAddress,
4308     bytes2 _contractName,
4309     uint[] memory _incentives
4310   )
4311   internal
4312   {
4313     require(_verifyMemberRoles(_memberRoleToVote, _allowedToCreateProposal) == 1, "Invalid Role");
4314     allCategory.push(
4315       CategoryStruct(
4316         _memberRoleToVote,
4317         _majorityVotePerc,
4318         _quorumPerc,
4319         _allowedToCreateProposal,
4320         _closingTime,
4321         _incentives[0]
4322       )
4323     );
4324     uint categoryId = allCategory.length - 1;
4325     categoryActionData[categoryId] = CategoryAction(_incentives[1], _contractAddress, _contractName);
4326     categoryABReq[categoryId] = _incentives[2];
4327     isSpecialResolution[categoryId] = _incentives[3];
4328     emit Category(categoryId, _name, _actionHash);
4329   }
4330 
4331   /**
4332   * @dev Internal call to check if given roles are valid or not
4333   */
4334   function _verifyMemberRoles(uint _memberRoleToVote, uint[] memory _allowedToCreateProposal)
4335   internal view returns (uint) {
4336     uint totalRoles = mr.totalRoles();
4337     if (_memberRoleToVote >= totalRoles) {
4338       return 0;
4339     }
4340     for (uint i = 0; i < _allowedToCreateProposal.length; i++) {
4341       if (_allowedToCreateProposal[i] >= totalRoles) {
4342         return 0;
4343       }
4344     }
4345     return 1;
4346   }
4347 
4348 }
4349 
4350 // File: contracts/modules/governance/external/IGovernance.sol
4351 
4352 /* Copyright (C) 2017 GovBlocks.io
4353 
4354   This program is free software: you can redistribute it and/or modify
4355     it under the terms of the GNU General Public License as published by
4356     the Free Software Foundation, either version 3 of the License, or
4357     (at your option) any later version.
4358 
4359   This program is distributed in the hope that it will be useful,
4360     but WITHOUT ANY WARRANTY; without even the implied warranty of
4361     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
4362     GNU General Public License for more details.
4363 
4364   You should have received a copy of the GNU General Public License
4365     along with this program.  If not, see http://www.gnu.org/licenses/ */
4366 
4367 pragma solidity ^0.5.0;
4368 
4369 contract IGovernance {
4370 
4371   event Proposal(
4372     address indexed proposalOwner,
4373     uint256 indexed proposalId,
4374     uint256 dateAdd,
4375     string proposalTitle,
4376     string proposalSD,
4377     string proposalDescHash
4378   );
4379 
4380   event Solution(
4381     uint256 indexed proposalId,
4382     address indexed solutionOwner,
4383     uint256 indexed solutionId,
4384     string solutionDescHash,
4385     uint256 dateAdd
4386   );
4387 
4388   event Vote(
4389     address indexed from,
4390     uint256 indexed proposalId,
4391     uint256 indexed voteId,
4392     uint256 dateAdd,
4393     uint256 solutionChosen
4394   );
4395 
4396   event RewardClaimed(
4397     address indexed member,
4398     uint gbtReward
4399   );
4400 
4401   /// @dev VoteCast event is called whenever a vote is cast that can potentially close the proposal.
4402   event VoteCast (uint256 proposalId);
4403 
4404   /// @dev ProposalAccepted event is called when a proposal is accepted so that a server can listen that can
4405   ///      call any offchain actions
4406   event ProposalAccepted (uint256 proposalId);
4407 
4408   /// @dev CloseProposalOnTime event is called whenever a proposal is created or updated to close it on time.
4409   event CloseProposalOnTime (
4410     uint256 indexed proposalId,
4411     uint256 time
4412   );
4413 
4414   /// @dev ActionSuccess event is called whenever an onchain action is executed.
4415   event ActionSuccess (
4416     uint256 proposalId
4417   );
4418 
4419   /// @dev Creates a new proposal
4420   /// @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
4421   /// @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
4422   function createProposal(
4423     string calldata _proposalTitle,
4424     string calldata _proposalSD,
4425     string calldata _proposalDescHash,
4426     uint _categoryId
4427   )
4428   external;
4429 
4430   /// @dev Edits the details of an existing proposal and creates new version
4431   /// @param _proposalId Proposal id that details needs to be updated
4432   /// @param _proposalDescHash Proposal description hash having long and short description of proposal.
4433   function updateProposal(
4434     uint _proposalId,
4435     string calldata _proposalTitle,
4436     string calldata _proposalSD,
4437     string calldata _proposalDescHash
4438   )
4439   external;
4440 
4441   /// @dev Categorizes proposal to proceed further. Categories shows the proposal objective.
4442   function categorizeProposal(
4443     uint _proposalId,
4444     uint _categoryId,
4445     uint _incentives
4446   )
4447   external;
4448 
4449   /// @dev Submit proposal with solution
4450   /// @param _proposalId Proposal id
4451   /// @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
4452   function submitProposalWithSolution(
4453     uint _proposalId,
4454     string calldata _solutionHash,
4455     bytes calldata _action
4456   )
4457   external;
4458 
4459   /// @dev Creates a new proposal with solution and votes for the solution
4460   /// @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
4461   /// @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
4462   /// @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
4463   function createProposalwithSolution(
4464     string calldata _proposalTitle,
4465     string calldata _proposalSD,
4466     string calldata _proposalDescHash,
4467     uint _categoryId,
4468     string calldata _solutionHash,
4469     bytes calldata _action
4470   )
4471   external;
4472 
4473   /// @dev Casts vote
4474   /// @param _proposalId Proposal id
4475   /// @param _solutionChosen solution chosen while voting. _solutionChosen[0] is the chosen solution
4476   function submitVote(uint _proposalId, uint _solutionChosen) external;
4477 
4478   function closeProposal(uint _proposalId) external;
4479 
4480   function claimReward(address _memberAddress, uint _maxRecords) external returns (uint pendingDAppReward);
4481 
4482   function proposal(uint _proposalId)
4483   external
4484   view
4485   returns (
4486     uint proposalId,
4487     uint category,
4488     uint status,
4489     uint finalVerdict,
4490     uint totalReward
4491   );
4492 
4493   function canCloseProposal(uint _proposalId) public view returns (uint closeValue);
4494 
4495   function allowedToCatgorize() public view returns (uint roleId);
4496 
4497 }
4498 
4499 // File: contracts/modules/governance/Governance.sol
4500 
4501 // /* Copyright (C) 2017 GovBlocks.io
4502 
4503 //   This program is free software: you can redistribute it and/or modify
4504 //     it under the terms of the GNU General Public License as published by
4505 //     the Free Software Foundation, either version 3 of the License, or
4506 //     (at your option) any later version.
4507 
4508 //   This program is distributed in the hope that it will be useful,
4509 //     but WITHOUT ANY WARRANTY; without even the implied warranty of
4510 //     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
4511 //     GNU General Public License for more details.
4512 
4513 //   You should have received a copy of the GNU General Public License
4514 //     along with this program.  If not, see http://www.gnu.org/licenses/ */
4515 
4516 pragma solidity ^0.5.0;
4517 
4518 
4519 
4520 
4521 
4522 
4523 contract Governance is IGovernance, Iupgradable {
4524 
4525   using SafeMath for uint;
4526 
4527   enum ProposalStatus {
4528     Draft,
4529     AwaitingSolution,
4530     VotingStarted,
4531     Accepted,
4532     Rejected,
4533     Majority_Not_Reached_But_Accepted,
4534     Denied
4535   }
4536 
4537   struct ProposalData {
4538     uint propStatus;
4539     uint finalVerdict;
4540     uint category;
4541     uint commonIncentive;
4542     uint dateUpd;
4543     address owner;
4544   }
4545 
4546   struct ProposalVote {
4547     address voter;
4548     uint proposalId;
4549     uint dateAdd;
4550   }
4551 
4552   struct VoteTally {
4553     mapping(uint => uint) memberVoteValue;
4554     mapping(uint => uint) abVoteValue;
4555     uint voters;
4556   }
4557 
4558   struct DelegateVote {
4559     address follower;
4560     address leader;
4561     uint lastUpd;
4562   }
4563 
4564   ProposalVote[] internal allVotes;
4565   DelegateVote[] public allDelegation;
4566 
4567   mapping(uint => ProposalData) internal allProposalData;
4568   mapping(uint => bytes[]) internal allProposalSolutions;
4569   mapping(address => uint[]) internal allVotesByMember;
4570   mapping(uint => mapping(address => bool)) public rewardClaimed;
4571   mapping(address => mapping(uint => uint)) public memberProposalVote;
4572   mapping(address => uint) public followerDelegation;
4573   mapping(address => uint) internal followerCount;
4574   mapping(address => uint[]) internal leaderDelegation;
4575   mapping(uint => VoteTally) public proposalVoteTally;
4576   mapping(address => bool) public isOpenForDelegation;
4577   mapping(address => uint) public lastRewardClaimed;
4578 
4579   bool internal constructorCheck;
4580   uint public tokenHoldingTime;
4581   uint internal roleIdAllowedToCatgorize;
4582   uint internal maxVoteWeigthPer;
4583   uint internal specialResolutionMajPerc;
4584   uint internal maxFollowers;
4585   uint internal totalProposals;
4586   uint internal maxDraftTime;
4587 
4588   MemberRoles internal memberRole;
4589   ProposalCategory internal proposalCategory;
4590   TokenController internal tokenInstance;
4591 
4592   mapping(uint => uint) public proposalActionStatus;
4593   mapping(uint => uint) internal proposalExecutionTime;
4594   mapping(uint => mapping(address => bool)) public proposalRejectedByAB;
4595   mapping(uint => uint) internal actionRejectedCount;
4596 
4597   bool internal actionParamsInitialised;
4598   uint internal actionWaitingTime;
4599   uint constant internal AB_MAJ_TO_REJECT_ACTION = 3;
4600 
4601   enum ActionStatus {
4602     Pending,
4603     Accepted,
4604     Rejected,
4605     Executed,
4606     NoAction
4607   }
4608 
4609   /**
4610   * @dev Called whenever an action execution is failed.
4611   */
4612   event ActionFailed (
4613     uint256 proposalId
4614   );
4615 
4616   /**
4617   * @dev Called whenever an AB member rejects the action execution.
4618   */
4619   event ActionRejected (
4620     uint256 indexed proposalId,
4621     address rejectedBy
4622   );
4623 
4624   /**
4625   * @dev Checks if msg.sender is proposal owner
4626   */
4627   modifier onlyProposalOwner(uint _proposalId) {
4628     require(msg.sender == allProposalData[_proposalId].owner, "Not allowed");
4629     _;
4630   }
4631 
4632   /**
4633   * @dev Checks if proposal is opened for voting
4634   */
4635   modifier voteNotStarted(uint _proposalId) {
4636     require(allProposalData[_proposalId].propStatus < uint(ProposalStatus.VotingStarted));
4637     _;
4638   }
4639 
4640   /**
4641   * @dev Checks if msg.sender is allowed to create proposal under given category
4642   */
4643   modifier isAllowed(uint _categoryId) {
4644     require(allowedToCreateProposal(_categoryId), "Not allowed");
4645     _;
4646   }
4647 
4648   /**
4649   * @dev Checks if msg.sender is allowed categorize proposal under given category
4650   */
4651   modifier isAllowedToCategorize() {
4652     require(memberRole.checkRole(msg.sender, roleIdAllowedToCatgorize), "Not allowed");
4653     _;
4654   }
4655 
4656   /**
4657   * @dev Checks if msg.sender had any pending rewards to be claimed
4658   */
4659   modifier checkPendingRewards {
4660     require(getPendingReward(msg.sender) == 0, "Claim reward");
4661     _;
4662   }
4663 
4664   /**
4665   * @dev Event emitted whenever a proposal is categorized
4666   */
4667   event ProposalCategorized(
4668     uint indexed proposalId,
4669     address indexed categorizedBy,
4670     uint categoryId
4671   );
4672 
4673   /**
4674    * @dev Removes delegation of an address.
4675    * @param _add address to undelegate.
4676    */
4677   function removeDelegation(address _add) external onlyInternal {
4678     _unDelegate(_add);
4679   }
4680 
4681   /**
4682   * @dev Creates a new proposal
4683   * @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
4684   * @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
4685   */
4686   function createProposal(
4687     string calldata _proposalTitle,
4688     string calldata _proposalSD,
4689     string calldata _proposalDescHash,
4690     uint _categoryId
4691   )
4692   external isAllowed(_categoryId)
4693   {
4694     require(ms.isMember(msg.sender), "Not Member");
4695 
4696     _createProposal(_proposalTitle, _proposalSD, _proposalDescHash, _categoryId);
4697   }
4698 
4699   /**
4700   * @dev Edits the details of an existing proposal
4701   * @param _proposalId Proposal id that details needs to be updated
4702   * @param _proposalDescHash Proposal description hash having long and short description of proposal.
4703   */
4704   function updateProposal(
4705     uint _proposalId,
4706     string calldata _proposalTitle,
4707     string calldata _proposalSD,
4708     string calldata _proposalDescHash
4709   )
4710   external onlyProposalOwner(_proposalId)
4711   {
4712     require(
4713       allProposalSolutions[_proposalId].length < 2,
4714       "Not allowed"
4715     );
4716     allProposalData[_proposalId].propStatus = uint(ProposalStatus.Draft);
4717     allProposalData[_proposalId].category = 0;
4718     allProposalData[_proposalId].commonIncentive = 0;
4719     emit Proposal(
4720       allProposalData[_proposalId].owner,
4721       _proposalId,
4722       now,
4723       _proposalTitle,
4724       _proposalSD,
4725       _proposalDescHash
4726     );
4727   }
4728 
4729   /**
4730   * @dev Categorizes proposal to proceed further. Categories shows the proposal objective.
4731   */
4732   function categorizeProposal(
4733     uint _proposalId,
4734     uint _categoryId,
4735     uint _incentive
4736   )
4737   external
4738   voteNotStarted(_proposalId) isAllowedToCategorize
4739   {
4740     _categorizeProposal(_proposalId, _categoryId, _incentive);
4741   }
4742 
4743   /**
4744   * @dev Submit proposal with solution
4745   * @param _proposalId Proposal id
4746   * @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
4747   */
4748   function submitProposalWithSolution(
4749     uint _proposalId,
4750     string calldata _solutionHash,
4751     bytes calldata _action
4752   )
4753   external
4754   onlyProposalOwner(_proposalId)
4755   {
4756 
4757     require(allProposalData[_proposalId].propStatus == uint(ProposalStatus.AwaitingSolution));
4758 
4759     _proposalSubmission(_proposalId, _solutionHash, _action);
4760   }
4761 
4762   /**
4763   * @dev Creates a new proposal with solution
4764   * @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
4765   * @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
4766   * @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
4767   */
4768   function createProposalwithSolution(
4769     string calldata _proposalTitle,
4770     string calldata _proposalSD,
4771     string calldata _proposalDescHash,
4772     uint _categoryId,
4773     string calldata _solutionHash,
4774     bytes calldata _action
4775   )
4776   external isAllowed(_categoryId)
4777   {
4778 
4779 
4780     uint proposalId = totalProposals;
4781 
4782     _createProposal(_proposalTitle, _proposalSD, _proposalDescHash, _categoryId);
4783 
4784     require(_categoryId > 0);
4785 
4786     _proposalSubmission(
4787       proposalId,
4788       _solutionHash,
4789       _action
4790     );
4791   }
4792 
4793   /**
4794    * @dev Submit a vote on the proposal.
4795    * @param _proposalId to vote upon.
4796    * @param _solutionChosen is the chosen vote.
4797    */
4798   function submitVote(uint _proposalId, uint _solutionChosen) external {
4799 
4800     require(allProposalData[_proposalId].propStatus ==
4801       uint(Governance.ProposalStatus.VotingStarted), "Not allowed");
4802 
4803     require(_solutionChosen < allProposalSolutions[_proposalId].length);
4804 
4805 
4806     _submitVote(_proposalId, _solutionChosen);
4807   }
4808 
4809   /**
4810    * @dev Closes the proposal.
4811    * @param _proposalId of proposal to be closed.
4812    */
4813   function closeProposal(uint _proposalId) external {
4814     uint category = allProposalData[_proposalId].category;
4815 
4816 
4817     uint _memberRole;
4818     if (allProposalData[_proposalId].dateUpd.add(maxDraftTime) <= now &&
4819       allProposalData[_proposalId].propStatus < uint(ProposalStatus.VotingStarted)) {
4820       _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
4821     } else {
4822       require(canCloseProposal(_proposalId) == 1);
4823       (, _memberRole,,,,,) = proposalCategory.category(allProposalData[_proposalId].category);
4824       if (_memberRole == uint(MemberRoles.Role.AdvisoryBoard)) {
4825         _closeAdvisoryBoardVote(_proposalId, category);
4826       } else {
4827         _closeMemberVote(_proposalId, category);
4828       }
4829     }
4830 
4831   }
4832 
4833   /**
4834    * @dev Claims reward for member.
4835    * @param _memberAddress to claim reward of.
4836    * @param _maxRecords maximum number of records to claim reward for.
4837    _proposals list of proposals of which reward will be claimed.
4838    * @return amount of pending reward.
4839    */
4840   function claimReward(address _memberAddress, uint _maxRecords)
4841   external returns (uint pendingDAppReward)
4842   {
4843 
4844     uint voteId;
4845     address leader;
4846     uint lastUpd;
4847 
4848     require(msg.sender == ms.getLatestAddress("CR"));
4849 
4850     uint delegationId = followerDelegation[_memberAddress];
4851     DelegateVote memory delegationData = allDelegation[delegationId];
4852     if (delegationId > 0 && delegationData.leader != address(0)) {
4853       leader = delegationData.leader;
4854       lastUpd = delegationData.lastUpd;
4855     } else
4856       leader = _memberAddress;
4857 
4858     uint proposalId;
4859     uint totalVotes = allVotesByMember[leader].length;
4860     uint lastClaimed = totalVotes;
4861     uint j;
4862     uint i;
4863     for (i = lastRewardClaimed[_memberAddress]; i < totalVotes && j < _maxRecords; i++) {
4864       voteId = allVotesByMember[leader][i];
4865       proposalId = allVotes[voteId].proposalId;
4866       if (proposalVoteTally[proposalId].voters > 0 && (allVotes[voteId].dateAdd > (
4867       lastUpd.add(tokenHoldingTime)) || leader == _memberAddress)) {
4868         if (allProposalData[proposalId].propStatus > uint(ProposalStatus.VotingStarted)) {
4869           if (!rewardClaimed[voteId][_memberAddress]) {
4870             pendingDAppReward = pendingDAppReward.add(
4871               allProposalData[proposalId].commonIncentive.div(
4872                 proposalVoteTally[proposalId].voters
4873               )
4874             );
4875             rewardClaimed[voteId][_memberAddress] = true;
4876             j++;
4877           }
4878         } else {
4879           if (lastClaimed == totalVotes) {
4880             lastClaimed = i;
4881           }
4882         }
4883       }
4884     }
4885 
4886     if (lastClaimed == totalVotes) {
4887       lastRewardClaimed[_memberAddress] = i;
4888     } else {
4889       lastRewardClaimed[_memberAddress] = lastClaimed;
4890     }
4891 
4892     if (j > 0) {
4893       emit RewardClaimed(
4894         _memberAddress,
4895         pendingDAppReward
4896       );
4897     }
4898   }
4899 
4900   /**
4901    * @dev Sets delegation acceptance status of individual user
4902    * @param _status delegation acceptance status
4903    */
4904   function setDelegationStatus(bool _status) external isMemberAndcheckPause checkPendingRewards {
4905     isOpenForDelegation[msg.sender] = _status;
4906   }
4907 
4908   /**
4909    * @dev Delegates vote to an address.
4910    * @param _add is the address to delegate vote to.
4911    */
4912   function delegateVote(address _add) external isMemberAndcheckPause checkPendingRewards {
4913 
4914     require(ms.masterInitialized());
4915 
4916     require(allDelegation[followerDelegation[_add]].leader == address(0));
4917 
4918     if (followerDelegation[msg.sender] > 0) {
4919       require((allDelegation[followerDelegation[msg.sender]].lastUpd).add(tokenHoldingTime) < now);
4920     }
4921 
4922     require(!alreadyDelegated(msg.sender));
4923     require(!memberRole.checkRole(msg.sender, uint(MemberRoles.Role.Owner)));
4924     require(!memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)));
4925 
4926 
4927     require(followerCount[_add] < maxFollowers);
4928 
4929     if (allVotesByMember[msg.sender].length > 0) {
4930       require((allVotes[allVotesByMember[msg.sender][allVotesByMember[msg.sender].length - 1]].dateAdd).add(tokenHoldingTime)
4931         < now);
4932     }
4933 
4934     require(ms.isMember(_add));
4935 
4936     require(isOpenForDelegation[_add]);
4937 
4938     allDelegation.push(DelegateVote(msg.sender, _add, now));
4939     followerDelegation[msg.sender] = allDelegation.length - 1;
4940     leaderDelegation[_add].push(allDelegation.length - 1);
4941     followerCount[_add]++;
4942     lastRewardClaimed[msg.sender] = allVotesByMember[_add].length;
4943   }
4944 
4945   /**
4946    * @dev Undelegates the sender
4947    */
4948   function unDelegate() external isMemberAndcheckPause checkPendingRewards {
4949     _unDelegate(msg.sender);
4950   }
4951 
4952   /**
4953    * @dev Triggers action of accepted proposal after waiting time is finished
4954    */
4955   function triggerAction(uint _proposalId) external {
4956     require(proposalActionStatus[_proposalId] == uint(ActionStatus.Accepted) && proposalExecutionTime[_proposalId] <= now, "Cannot trigger");
4957     _triggerAction(_proposalId, allProposalData[_proposalId].category);
4958   }
4959 
4960   /**
4961    * @dev Provides option to Advisory board member to reject proposal action execution within actionWaitingTime, if found suspicious
4962    */
4963   function rejectAction(uint _proposalId) external {
4964     require(memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)) && proposalExecutionTime[_proposalId] > now);
4965 
4966     require(proposalActionStatus[_proposalId] == uint(ActionStatus.Accepted));
4967 
4968     require(!proposalRejectedByAB[_proposalId][msg.sender]);
4969 
4970     require(
4971       keccak256(proposalCategory.categoryActionHashes(allProposalData[_proposalId].category))
4972       != keccak256(abi.encodeWithSignature("swapABMember(address,address)"))
4973     );
4974 
4975     proposalRejectedByAB[_proposalId][msg.sender] = true;
4976     actionRejectedCount[_proposalId]++;
4977     emit ActionRejected(_proposalId, msg.sender);
4978     if (actionRejectedCount[_proposalId] == AB_MAJ_TO_REJECT_ACTION) {
4979       proposalActionStatus[_proposalId] = uint(ActionStatus.Rejected);
4980     }
4981   }
4982 
4983   /**
4984    * @dev Sets intial actionWaitingTime value
4985    * To be called after governance implementation has been updated
4986    */
4987   function setInitialActionParameters() external onlyOwner {
4988     require(!actionParamsInitialised);
4989     actionParamsInitialised = true;
4990     actionWaitingTime = 24 * 1 hours;
4991   }
4992 
4993   /**
4994    * @dev Gets Uint Parameters of a code
4995    * @param code whose details we want
4996    * @return string value of the code
4997    * @return associated amount (time or perc or value) to the code
4998    */
4999   function getUintParameters(bytes8 code) external view returns (bytes8 codeVal, uint val) {
5000 
5001     codeVal = code;
5002 
5003     if (code == "GOVHOLD") {
5004 
5005       val = tokenHoldingTime / (1 days);
5006 
5007     } else if (code == "MAXFOL") {
5008 
5009       val = maxFollowers;
5010 
5011     } else if (code == "MAXDRFT") {
5012 
5013       val = maxDraftTime / (1 days);
5014 
5015     } else if (code == "EPTIME") {
5016 
5017       val = ms.pauseTime() / (1 days);
5018 
5019     } else if (code == "ACWT") {
5020 
5021       val = actionWaitingTime / (1 hours);
5022 
5023     }
5024   }
5025 
5026   /**
5027    * @dev Gets all details of a propsal
5028    * @param _proposalId whose details we want
5029    * @return proposalId
5030    * @return category
5031    * @return status
5032    * @return finalVerdict
5033    * @return totalReward
5034    */
5035   function proposal(uint _proposalId)
5036   external
5037   view
5038   returns (
5039     uint proposalId,
5040     uint category,
5041     uint status,
5042     uint finalVerdict,
5043     uint totalRewar
5044   )
5045   {
5046     return (
5047     _proposalId,
5048     allProposalData[_proposalId].category,
5049     allProposalData[_proposalId].propStatus,
5050     allProposalData[_proposalId].finalVerdict,
5051     allProposalData[_proposalId].commonIncentive
5052     );
5053   }
5054 
5055   /**
5056    * @dev Gets some details of a propsal
5057    * @param _proposalId whose details we want
5058    * @return proposalId
5059    * @return number of all proposal solutions
5060    * @return amount of votes
5061    */
5062   function proposalDetails(uint _proposalId) external view returns (uint, uint, uint) {
5063     return (
5064     _proposalId,
5065     allProposalSolutions[_proposalId].length,
5066     proposalVoteTally[_proposalId].voters
5067     );
5068   }
5069 
5070   /**
5071    * @dev Gets solution action on a proposal
5072    * @param _proposalId whose details we want
5073    * @param _solution whose details we want
5074    * @return action of a solution on a proposal
5075    */
5076   function getSolutionAction(uint _proposalId, uint _solution) external view returns (uint, bytes memory) {
5077     return (
5078     _solution,
5079     allProposalSolutions[_proposalId][_solution]
5080     );
5081   }
5082 
5083   /**
5084    * @dev Gets length of propsal
5085    * @return length of propsal
5086    */
5087   function getProposalLength() external view returns (uint) {
5088     return totalProposals;
5089   }
5090 
5091   /**
5092    * @dev Get followers of an address
5093    * @return get followers of an address
5094    */
5095   function getFollowers(address _add) external view returns (uint[] memory) {
5096     return leaderDelegation[_add];
5097   }
5098 
5099   /**
5100    * @dev Gets pending rewards of a member
5101    * @param _memberAddress in concern
5102    * @return amount of pending reward
5103    */
5104   function getPendingReward(address _memberAddress)
5105   public view returns (uint pendingDAppReward)
5106   {
5107     uint delegationId = followerDelegation[_memberAddress];
5108     address leader;
5109     uint lastUpd;
5110     DelegateVote memory delegationData = allDelegation[delegationId];
5111 
5112     if (delegationId > 0 && delegationData.leader != address(0)) {
5113       leader = delegationData.leader;
5114       lastUpd = delegationData.lastUpd;
5115     } else
5116       leader = _memberAddress;
5117 
5118     uint proposalId;
5119     for (uint i = lastRewardClaimed[_memberAddress]; i < allVotesByMember[leader].length; i++) {
5120       if (allVotes[allVotesByMember[leader][i]].dateAdd > (
5121       lastUpd.add(tokenHoldingTime)) || leader == _memberAddress) {
5122         if (!rewardClaimed[allVotesByMember[leader][i]][_memberAddress]) {
5123           proposalId = allVotes[allVotesByMember[leader][i]].proposalId;
5124           if (proposalVoteTally[proposalId].voters > 0 && allProposalData[proposalId].propStatus
5125           > uint(ProposalStatus.VotingStarted)) {
5126             pendingDAppReward = pendingDAppReward.add(
5127               allProposalData[proposalId].commonIncentive.div(
5128                 proposalVoteTally[proposalId].voters
5129               )
5130             );
5131           }
5132         }
5133       }
5134     }
5135   }
5136 
5137   /**
5138    * @dev Updates Uint Parameters of a code
5139    * @param code whose details we want to update
5140    * @param val value to set
5141    */
5142   function updateUintParameters(bytes8 code, uint val) public {
5143 
5144     require(ms.checkIsAuthToGoverned(msg.sender));
5145     if (code == "GOVHOLD") {
5146 
5147       tokenHoldingTime = val * 1 days;
5148 
5149     } else if (code == "MAXFOL") {
5150 
5151       maxFollowers = val;
5152 
5153     } else if (code == "MAXDRFT") {
5154 
5155       maxDraftTime = val * 1 days;
5156 
5157     } else if (code == "EPTIME") {
5158 
5159       ms.updatePauseTime(val * 1 days);
5160 
5161     } else if (code == "ACWT") {
5162 
5163       actionWaitingTime = val * 1 hours;
5164 
5165     } else {
5166 
5167       revert("Invalid code");
5168 
5169     }
5170   }
5171 
5172   /**
5173   * @dev Updates all dependency addresses to latest ones from Master
5174   */
5175   function changeDependentContractAddress() public {
5176     tokenInstance = TokenController(ms.dAppLocker());
5177     memberRole = MemberRoles(ms.getLatestAddress("MR"));
5178     proposalCategory = ProposalCategory(ms.getLatestAddress("PC"));
5179   }
5180 
5181   /**
5182   * @dev Checks if msg.sender is allowed to create a proposal under given category
5183   */
5184   function allowedToCreateProposal(uint category) public view returns (bool check) {
5185     if (category == 0)
5186       return true;
5187     uint[] memory mrAllowed;
5188     (,,,, mrAllowed,,) = proposalCategory.category(category);
5189     for (uint i = 0; i < mrAllowed.length; i++) {
5190       if (mrAllowed[i] == 0 || memberRole.checkRole(msg.sender, mrAllowed[i]))
5191         return true;
5192     }
5193   }
5194 
5195   /**
5196    * @dev Checks if an address is already delegated
5197    * @param _add in concern
5198    * @return bool value if the address is delegated or not
5199    */
5200   function alreadyDelegated(address _add) public view returns (bool delegated) {
5201     for (uint i = 0; i < leaderDelegation[_add].length; i++) {
5202       if (allDelegation[leaderDelegation[_add][i]].leader == _add) {
5203         return true;
5204       }
5205     }
5206   }
5207 
5208   /**
5209   * @dev Checks If the proposal voting time is up and it's ready to close
5210   *      i.e. Closevalue is 1 if proposal is ready to be closed, 2 if already closed, 0 otherwise!
5211   * @param _proposalId Proposal id to which closing value is being checked
5212   */
5213   function canCloseProposal(uint _proposalId)
5214   public
5215   view
5216   returns (uint)
5217   {
5218     uint dateUpdate;
5219     uint pStatus;
5220     uint _closingTime;
5221     uint _roleId;
5222     uint majority;
5223     pStatus = allProposalData[_proposalId].propStatus;
5224     dateUpdate = allProposalData[_proposalId].dateUpd;
5225     (, _roleId, majority, , , _closingTime,) = proposalCategory.category(allProposalData[_proposalId].category);
5226     if (
5227       pStatus == uint(ProposalStatus.VotingStarted)
5228     ) {
5229       uint numberOfMembers = memberRole.numberOfMembers(_roleId);
5230       if (_roleId == uint(MemberRoles.Role.AdvisoryBoard)) {
5231         if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100).div(numberOfMembers) >= majority
5232         || proposalVoteTally[_proposalId].abVoteValue[1].add(proposalVoteTally[_proposalId].abVoteValue[0]) == numberOfMembers
5233           || dateUpdate.add(_closingTime) <= now) {
5234 
5235           return 1;
5236         }
5237       } else {
5238         if (numberOfMembers == proposalVoteTally[_proposalId].voters
5239           || dateUpdate.add(_closingTime) <= now)
5240           return 1;
5241       }
5242     } else if (pStatus > uint(ProposalStatus.VotingStarted)) {
5243       return 2;
5244     } else {
5245       return 0;
5246     }
5247   }
5248 
5249   /**
5250    * @dev Gets Id of member role allowed to categorize the proposal
5251    * @return roleId allowed to categorize the proposal
5252    */
5253   function allowedToCatgorize() public view returns (uint roleId) {
5254     return roleIdAllowedToCatgorize;
5255   }
5256 
5257   /**
5258    * @dev Gets vote tally data
5259    * @param _proposalId in concern
5260    * @param _solution of a proposal id
5261    * @return member vote value
5262    * @return advisory board vote value
5263    * @return amount of votes
5264    */
5265   function voteTallyData(uint _proposalId, uint _solution) public view returns (uint, uint, uint) {
5266     return (proposalVoteTally[_proposalId].memberVoteValue[_solution],
5267     proposalVoteTally[_proposalId].abVoteValue[_solution], proposalVoteTally[_proposalId].voters);
5268   }
5269 
5270   /**
5271    * @dev Internal call to create proposal
5272    * @param _proposalTitle of proposal
5273    * @param _proposalSD is short description of proposal
5274    * @param _proposalDescHash IPFS hash value of propsal
5275    * @param _categoryId of proposal
5276    */
5277   function _createProposal(
5278     string memory _proposalTitle,
5279     string memory _proposalSD,
5280     string memory _proposalDescHash,
5281     uint _categoryId
5282   )
5283   internal
5284   {
5285     require(proposalCategory.categoryABReq(_categoryId) == 0 || _categoryId == 0);
5286     uint _proposalId = totalProposals;
5287     allProposalData[_proposalId].owner = msg.sender;
5288     allProposalData[_proposalId].dateUpd = now;
5289     allProposalSolutions[_proposalId].push("");
5290     totalProposals++;
5291 
5292     emit Proposal(
5293       msg.sender,
5294       _proposalId,
5295       now,
5296       _proposalTitle,
5297       _proposalSD,
5298       _proposalDescHash
5299     );
5300 
5301     if (_categoryId > 0)
5302       _categorizeProposal(_proposalId, _categoryId, 0);
5303   }
5304 
5305   /**
5306    * @dev Internal call to categorize a proposal
5307    * @param _proposalId of proposal
5308    * @param _categoryId of proposal
5309    * @param _incentive is commonIncentive
5310    */
5311   function _categorizeProposal(
5312     uint _proposalId,
5313     uint _categoryId,
5314     uint _incentive
5315   )
5316   internal
5317   {
5318     require(
5319       _categoryId > 0 && _categoryId < proposalCategory.totalCategories(),
5320       "Invalid category"
5321     );
5322     allProposalData[_proposalId].category = _categoryId;
5323     allProposalData[_proposalId].commonIncentive = _incentive;
5324     allProposalData[_proposalId].propStatus = uint(ProposalStatus.AwaitingSolution);
5325 
5326     emit ProposalCategorized(_proposalId, msg.sender, _categoryId);
5327   }
5328 
5329   /**
5330    * @dev Internal call to add solution to a proposal
5331    * @param _proposalId in concern
5332    * @param _action on that solution
5333    * @param _solutionHash string value
5334    */
5335   function _addSolution(uint _proposalId, bytes memory _action, string memory _solutionHash)
5336   internal
5337   {
5338     allProposalSolutions[_proposalId].push(_action);
5339     emit Solution(_proposalId, msg.sender, allProposalSolutions[_proposalId].length - 1, _solutionHash, now);
5340   }
5341 
5342   /**
5343   * @dev Internal call to add solution and open proposal for voting
5344   */
5345   function _proposalSubmission(
5346     uint _proposalId,
5347     string memory _solutionHash,
5348     bytes memory _action
5349   )
5350   internal
5351   {
5352 
5353     uint _categoryId = allProposalData[_proposalId].category;
5354     if (proposalCategory.categoryActionHashes(_categoryId).length == 0) {
5355       require(keccak256(_action) == keccak256(""));
5356       proposalActionStatus[_proposalId] = uint(ActionStatus.NoAction);
5357     }
5358 
5359     _addSolution(
5360       _proposalId,
5361       _action,
5362       _solutionHash
5363     );
5364 
5365     _updateProposalStatus(_proposalId, uint(ProposalStatus.VotingStarted));
5366     (, , , , , uint closingTime,) = proposalCategory.category(_categoryId);
5367     emit CloseProposalOnTime(_proposalId, closingTime.add(now));
5368 
5369   }
5370 
5371   /**
5372    * @dev Internal call to submit vote
5373    * @param _proposalId of proposal in concern
5374    * @param _solution for that proposal
5375    */
5376   function _submitVote(uint _proposalId, uint _solution) internal {
5377 
5378     uint delegationId = followerDelegation[msg.sender];
5379     uint mrSequence;
5380     uint majority;
5381     uint closingTime;
5382     (, mrSequence, majority, , , closingTime,) = proposalCategory.category(allProposalData[_proposalId].category);
5383 
5384     require(allProposalData[_proposalId].dateUpd.add(closingTime) > now, "Closed");
5385 
5386     require(memberProposalVote[msg.sender][_proposalId] == 0, "Not allowed");
5387     require((delegationId == 0) || (delegationId > 0 && allDelegation[delegationId].leader == address(0) &&
5388     _checkLastUpd(allDelegation[delegationId].lastUpd)));
5389 
5390     require(memberRole.checkRole(msg.sender, mrSequence), "Not Authorized");
5391     uint totalVotes = allVotes.length;
5392 
5393     allVotesByMember[msg.sender].push(totalVotes);
5394     memberProposalVote[msg.sender][_proposalId] = totalVotes;
5395 
5396     allVotes.push(ProposalVote(msg.sender, _proposalId, now));
5397 
5398     emit Vote(msg.sender, _proposalId, totalVotes, now, _solution);
5399     if (mrSequence == uint(MemberRoles.Role.Owner)) {
5400       if (_solution == 1)
5401         _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), allProposalData[_proposalId].category, 1, MemberRoles.Role.Owner);
5402       else
5403         _updateProposalStatus(_proposalId, uint(ProposalStatus.Rejected));
5404 
5405     } else {
5406       uint numberOfMembers = memberRole.numberOfMembers(mrSequence);
5407       _setVoteTally(_proposalId, _solution, mrSequence);
5408 
5409       if (mrSequence == uint(MemberRoles.Role.AdvisoryBoard)) {
5410         if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100).div(numberOfMembers)
5411         >= majority
5412           || (proposalVoteTally[_proposalId].abVoteValue[1].add(proposalVoteTally[_proposalId].abVoteValue[0])) == numberOfMembers) {
5413           emit VoteCast(_proposalId);
5414         }
5415       } else {
5416         if (numberOfMembers == proposalVoteTally[_proposalId].voters)
5417           emit VoteCast(_proposalId);
5418       }
5419     }
5420 
5421   }
5422 
5423   /**
5424    * @dev Internal call to set vote tally of a proposal
5425    * @param _proposalId of proposal in concern
5426    * @param _solution of proposal in concern
5427    * @param mrSequence number of members for a role
5428    */
5429   function _setVoteTally(uint _proposalId, uint _solution, uint mrSequence) internal
5430   {
5431     uint categoryABReq;
5432     uint isSpecialResolution;
5433     (, categoryABReq, isSpecialResolution) = proposalCategory.categoryExtendedData(allProposalData[_proposalId].category);
5434     if (memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)) && (categoryABReq > 0) ||
5435       mrSequence == uint(MemberRoles.Role.AdvisoryBoard)) {
5436       proposalVoteTally[_proposalId].abVoteValue[_solution]++;
5437     }
5438     tokenInstance.lockForMemberVote(msg.sender, tokenHoldingTime);
5439     if (mrSequence != uint(MemberRoles.Role.AdvisoryBoard)) {
5440       uint voteWeight;
5441       uint voters = 1;
5442       uint tokenBalance = tokenInstance.totalBalanceOf(msg.sender);
5443       uint totalSupply = tokenInstance.totalSupply();
5444       if (isSpecialResolution == 1) {
5445         voteWeight = tokenBalance.add(10 ** 18);
5446       } else {
5447         voteWeight = (_minOf(tokenBalance, maxVoteWeigthPer.mul(totalSupply).div(100))).add(10 ** 18);
5448       }
5449       DelegateVote memory delegationData;
5450       for (uint i = 0; i < leaderDelegation[msg.sender].length; i++) {
5451         delegationData = allDelegation[leaderDelegation[msg.sender][i]];
5452         if (delegationData.leader == msg.sender &&
5453           _checkLastUpd(delegationData.lastUpd)) {
5454           if (memberRole.checkRole(delegationData.follower, mrSequence)) {
5455             tokenBalance = tokenInstance.totalBalanceOf(delegationData.follower);
5456             tokenInstance.lockForMemberVote(delegationData.follower, tokenHoldingTime);
5457             voters++;
5458             if (isSpecialResolution == 1) {
5459               voteWeight = voteWeight.add(tokenBalance.add(10 ** 18));
5460             } else {
5461               voteWeight = voteWeight.add((_minOf(tokenBalance, maxVoteWeigthPer.mul(totalSupply).div(100))).add(10 ** 18));
5462             }
5463           }
5464         }
5465       }
5466       proposalVoteTally[_proposalId].memberVoteValue[_solution] = proposalVoteTally[_proposalId].memberVoteValue[_solution].add(voteWeight);
5467       proposalVoteTally[_proposalId].voters = proposalVoteTally[_proposalId].voters + voters;
5468     }
5469   }
5470 
5471   /**
5472    * @dev Gets minimum of two numbers
5473    * @param a one of the two numbers
5474    * @param b one of the two numbers
5475    * @return minimum number out of the two
5476    */
5477   function _minOf(uint a, uint b) internal pure returns (uint res) {
5478     res = a;
5479     if (res > b)
5480       res = b;
5481   }
5482 
5483   /**
5484    * @dev Check the time since last update has exceeded token holding time or not
5485    * @param _lastUpd is last update time
5486    * @return the bool which tells if the time since last update has exceeded token holding time or not
5487    */
5488   function _checkLastUpd(uint _lastUpd) internal view returns (bool) {
5489     return (now - _lastUpd) > tokenHoldingTime;
5490   }
5491 
5492   /**
5493   * @dev Checks if the vote count against any solution passes the threshold value or not.
5494   */
5495   function _checkForThreshold(uint _proposalId, uint _category) internal view returns (bool check) {
5496     uint categoryQuorumPerc;
5497     uint roleAuthorized;
5498     (, roleAuthorized, , categoryQuorumPerc, , ,) = proposalCategory.category(_category);
5499     check = ((proposalVoteTally[_proposalId].memberVoteValue[0]
5500     .add(proposalVoteTally[_proposalId].memberVoteValue[1]))
5501     .mul(100))
5502     .div(
5503       tokenInstance.totalSupply().add(
5504         memberRole.numberOfMembers(roleAuthorized).mul(10 ** 18)
5505       )
5506     ) >= categoryQuorumPerc;
5507   }
5508 
5509   /**
5510    * @dev Called when vote majority is reached
5511    * @param _proposalId of proposal in concern
5512    * @param _status of proposal in concern
5513    * @param category of proposal in concern
5514    * @param max vote value of proposal in concern
5515    */
5516   function _callIfMajReached(uint _proposalId, uint _status, uint category, uint max, MemberRoles.Role role) internal {
5517 
5518     allProposalData[_proposalId].finalVerdict = max;
5519     _updateProposalStatus(_proposalId, _status);
5520     emit ProposalAccepted(_proposalId);
5521     if (proposalActionStatus[_proposalId] != uint(ActionStatus.NoAction)) {
5522       if (role == MemberRoles.Role.AdvisoryBoard) {
5523         _triggerAction(_proposalId, category);
5524       } else {
5525         proposalActionStatus[_proposalId] = uint(ActionStatus.Accepted);
5526         proposalExecutionTime[_proposalId] = actionWaitingTime.add(now);
5527       }
5528     }
5529   }
5530 
5531   /**
5532    * @dev Internal function to trigger action of accepted proposal
5533    */
5534   function _triggerAction(uint _proposalId, uint _categoryId) internal {
5535     proposalActionStatus[_proposalId] = uint(ActionStatus.Executed);
5536     bytes2 contractName;
5537     address actionAddress;
5538     bytes memory _functionHash;
5539     (, actionAddress, contractName, , _functionHash) = proposalCategory.categoryActionDetails(_categoryId);
5540     if (contractName == "MS") {
5541       actionAddress = address(ms);
5542     } else if (contractName != "EX") {
5543       actionAddress = ms.getLatestAddress(contractName);
5544     }
5545     // solhint-disable-next-line avoid-low-level-calls
5546     (bool actionStatus,) = actionAddress.call(abi.encodePacked(_functionHash, allProposalSolutions[_proposalId][1]));
5547     if (actionStatus) {
5548       emit ActionSuccess(_proposalId);
5549     } else {
5550       proposalActionStatus[_proposalId] = uint(ActionStatus.Accepted);
5551       emit ActionFailed(_proposalId);
5552     }
5553   }
5554 
5555   /**
5556    * @dev Internal call to update proposal status
5557    * @param _proposalId of proposal in concern
5558    * @param _status of proposal to set
5559    */
5560   function _updateProposalStatus(uint _proposalId, uint _status) internal {
5561     if (_status == uint(ProposalStatus.Rejected) || _status == uint(ProposalStatus.Denied)) {
5562       proposalActionStatus[_proposalId] = uint(ActionStatus.NoAction);
5563     }
5564     allProposalData[_proposalId].dateUpd = now;
5565     allProposalData[_proposalId].propStatus = _status;
5566   }
5567 
5568   /**
5569    * @dev Internal call to undelegate a follower
5570    * @param _follower is address of follower to undelegate
5571    */
5572   function _unDelegate(address _follower) internal {
5573     uint followerId = followerDelegation[_follower];
5574     if (followerId > 0) {
5575 
5576       followerCount[allDelegation[followerId].leader] = followerCount[allDelegation[followerId].leader].sub(1);
5577       allDelegation[followerId].leader = address(0);
5578       allDelegation[followerId].lastUpd = now;
5579 
5580       lastRewardClaimed[_follower] = allVotesByMember[_follower].length;
5581     }
5582   }
5583 
5584   /**
5585    * @dev Internal call to close member voting
5586    * @param _proposalId of proposal in concern
5587    * @param category of proposal in concern
5588    */
5589   function _closeMemberVote(uint _proposalId, uint category) internal {
5590     uint isSpecialResolution;
5591     uint abMaj;
5592     (, abMaj, isSpecialResolution) = proposalCategory.categoryExtendedData(category);
5593     if (isSpecialResolution == 1) {
5594       uint acceptedVotePerc = proposalVoteTally[_proposalId].memberVoteValue[1].mul(100)
5595       .div(
5596         tokenInstance.totalSupply().add(
5597           memberRole.numberOfMembers(uint(MemberRoles.Role.Member)).mul(10 ** 18)
5598         ));
5599       if (acceptedVotePerc >= specialResolutionMajPerc) {
5600         _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
5601       } else {
5602         _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
5603       }
5604     } else {
5605       if (_checkForThreshold(_proposalId, category)) {
5606         uint majorityVote;
5607         (,, majorityVote,,,,) = proposalCategory.category(category);
5608         if (
5609           ((proposalVoteTally[_proposalId].memberVoteValue[1].mul(100))
5610           .div(proposalVoteTally[_proposalId].memberVoteValue[0]
5611           .add(proposalVoteTally[_proposalId].memberVoteValue[1])
5612           ))
5613           >= majorityVote
5614         ) {
5615           _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
5616         } else {
5617           _updateProposalStatus(_proposalId, uint(ProposalStatus.Rejected));
5618         }
5619       } else {
5620         if (abMaj > 0 && proposalVoteTally[_proposalId].abVoteValue[1].mul(100)
5621         .div(memberRole.numberOfMembers(uint(MemberRoles.Role.AdvisoryBoard))) >= abMaj) {
5622           _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
5623         } else {
5624           _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
5625         }
5626       }
5627     }
5628 
5629     if (proposalVoteTally[_proposalId].voters > 0) {
5630       tokenInstance.mint(ms.getLatestAddress("CR"), allProposalData[_proposalId].commonIncentive);
5631     }
5632   }
5633 
5634   /**
5635    * @dev Internal call to close advisory board voting
5636    * @param _proposalId of proposal in concern
5637    * @param category of proposal in concern
5638    */
5639   function _closeAdvisoryBoardVote(uint _proposalId, uint category) internal {
5640     uint _majorityVote;
5641     MemberRoles.Role _roleId = MemberRoles.Role.AdvisoryBoard;
5642     (,, _majorityVote,,,,) = proposalCategory.category(category);
5643     if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100)
5644     .div(memberRole.numberOfMembers(uint(_roleId))) >= _majorityVote) {
5645       _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, _roleId);
5646     } else {
5647       _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
5648     }
5649 
5650   }
5651 
5652 }
5653 
5654 // File: contracts/modules/token/TokenFunctions.sol
5655 
5656 /* Copyright (C) 2020 NexusMutual.io
5657 
5658   This program is free software: you can redistribute it and/or modify
5659     it under the terms of the GNU General Public License as published by
5660     the Free Software Foundation, either version 3 of the License, or
5661     (at your option) any later version.
5662 
5663   This program is distributed in the hope that it will be useful,
5664     but WITHOUT ANY WARRANTY; without even the implied warranty of
5665     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
5666     GNU General Public License for more details.
5667 
5668   You should have received a copy of the GNU General Public License
5669     along with this program.  If not, see http://www.gnu.org/licenses/ */
5670 
5671 pragma solidity ^0.5.0;
5672 
5673 
5674 
5675 
5676 
5677 
5678 
5679 
5680 
5681 
5682 
5683 contract TokenFunctions is Iupgradable {
5684   using SafeMath for uint;
5685 
5686   MCR internal m1;
5687   MemberRoles internal mr;
5688   NXMToken public tk;
5689   TokenController internal tc;
5690   TokenData internal td;
5691   QuotationData internal qd;
5692   ClaimsReward internal cr;
5693   Governance internal gv;
5694   PoolData internal pd;
5695   IPooledStaking pooledStaking;
5696 
5697   event BurnCATokens(uint claimId, address addr, uint amount);
5698 
5699   /**
5700    * @dev Rewards stakers on purchase of cover on smart contract.
5701    * @param _contractAddress smart contract address.
5702    * @param _coverPriceNXM cover price in NXM.
5703    */
5704   function pushStakerRewards(address _contractAddress, uint _coverPriceNXM) external onlyInternal {
5705     uint rewardValue = _coverPriceNXM.mul(td.stakerCommissionPer()).div(100);
5706     pooledStaking.accumulateReward(_contractAddress, rewardValue);
5707   }
5708 
5709   /**
5710   * @dev Deprecated in favor of burnStakedTokens
5711   */
5712   function burnStakerLockedToken(uint, bytes4, uint) external {
5713     // noop
5714   }
5715 
5716   /**
5717   * @dev Burns tokens staked on smart contract covered by coverId. Called when a payout is succesfully executed.
5718   * @param coverId cover id
5719   * @param coverCurrency cover currency
5720   * @param sumAssured amount of $curr to burn
5721   */
5722   function burnStakedTokens(uint coverId, bytes4 coverCurrency, uint sumAssured) external onlyInternal {
5723     (, address scAddress) = qd.getscAddressOfCover(coverId);
5724     uint tokenPrice = m1.calculateTokenPrice(coverCurrency);
5725     uint burnNXMAmount = sumAssured.mul(1e18).div(tokenPrice);
5726     pooledStaking.pushBurn(scAddress, burnNXMAmount);
5727   }
5728 
5729   /**
5730    * @dev Gets the total staked NXM tokens against
5731    * Smart contract by all stakers
5732    * @param _stakedContractAddress smart contract address.
5733    * @return amount total staked NXM tokens.
5734    */
5735   function deprecated_getTotalStakedTokensOnSmartContract(
5736     address _stakedContractAddress
5737   )
5738   external
5739   view
5740   returns (uint)
5741   {
5742     uint stakedAmount = 0;
5743     address stakerAddress;
5744     uint staketLen = td.getStakedContractStakersLength(_stakedContractAddress);
5745 
5746     for (uint i = 0; i < staketLen; i++) {
5747       stakerAddress = td.getStakedContractStakerByIndex(_stakedContractAddress, i);
5748       uint stakerIndex = td.getStakedContractStakerIndex(
5749         _stakedContractAddress, i);
5750       uint currentlyStaked;
5751       (, currentlyStaked) = _deprecated_unlockableBeforeBurningAndCanBurn(stakerAddress,
5752         _stakedContractAddress, stakerIndex);
5753       stakedAmount = stakedAmount.add(currentlyStaked);
5754     }
5755 
5756     return stakedAmount;
5757   }
5758 
5759   /**
5760    * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
5761    * @param _of address of the coverHolder.
5762    * @param _coverId coverId of the cover.
5763    */
5764   function getUserLockedCNTokens(address _of, uint _coverId) external view returns (uint) {
5765     return _getUserLockedCNTokens(_of, _coverId);
5766   }
5767 
5768   /**
5769    * @dev to get the all the cover locked tokens of a user
5770    * @param _of is the user address in concern
5771    * @return amount locked
5772    */
5773   function getUserAllLockedCNTokens(address _of) external view returns (uint amount) {
5774     for (uint i = 0; i < qd.getUserCoverLength(_of); i++) {
5775       amount = amount.add(_getUserLockedCNTokens(_of, qd.getAllCoversOfUser(_of)[i]));
5776     }
5777   }
5778 
5779   /**
5780    * @dev Returns amount of NXM Tokens locked as Cover Note against given coverId.
5781    * @param _coverId coverId of the cover.
5782    */
5783   function getLockedCNAgainstCover(uint _coverId) external view returns (uint) {
5784     return _getLockedCNAgainstCover(_coverId);
5785   }
5786 
5787   /**
5788    * @dev Returns total amount of staked NXM Tokens on all smart contracts.
5789    * @param _stakerAddress address of the Staker.
5790    */
5791   function deprecated_getStakerAllLockedTokens(address _stakerAddress) external view returns (uint amount) {
5792     uint stakedAmount = 0;
5793     address scAddress;
5794     uint scIndex;
5795     for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
5796       scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
5797       scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
5798       uint currentlyStaked;
5799       (, currentlyStaked) = _deprecated_unlockableBeforeBurningAndCanBurn(_stakerAddress, scAddress, i);
5800       stakedAmount = stakedAmount.add(currentlyStaked);
5801     }
5802     amount = stakedAmount;
5803   }
5804 
5805   /**
5806    * @dev Returns total unlockable amount of staked NXM Tokens on all smart contract .
5807    * @param _stakerAddress address of the Staker.
5808    */
5809   function deprecated_getStakerAllUnlockableStakedTokens(
5810     address _stakerAddress
5811   )
5812   external
5813   view
5814   returns (uint amount)
5815   {
5816     uint unlockableAmount = 0;
5817     address scAddress;
5818     uint scIndex;
5819     for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
5820       scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
5821       scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
5822       unlockableAmount = unlockableAmount.add(
5823         _deprecated_getStakerUnlockableTokensOnSmartContract(_stakerAddress, scAddress,
5824         scIndex));
5825     }
5826     amount = unlockableAmount;
5827   }
5828 
5829   /**
5830    * @dev Change Dependent Contract Address
5831    */
5832   function changeDependentContractAddress() public {
5833     tk = NXMToken(ms.tokenAddress());
5834     td = TokenData(ms.getLatestAddress("TD"));
5835     tc = TokenController(ms.getLatestAddress("TC"));
5836     cr = ClaimsReward(ms.getLatestAddress("CR"));
5837     qd = QuotationData(ms.getLatestAddress("QD"));
5838     m1 = MCR(ms.getLatestAddress("MC"));
5839     gv = Governance(ms.getLatestAddress("GV"));
5840     mr = MemberRoles(ms.getLatestAddress("MR"));
5841     pd = PoolData(ms.getLatestAddress("PD"));
5842     pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
5843   }
5844 
5845   /**
5846    * @dev Gets the Token price in a given currency
5847    * @param curr Currency name.
5848    * @return price Token Price.
5849    */
5850   function getTokenPrice(bytes4 curr) public view returns (uint price) {
5851     price = m1.calculateTokenPrice(curr);
5852   }
5853 
5854   /**
5855    * @dev Set the flag to check if cover note is deposited against the cover id
5856    * @param coverId Cover Id.
5857    */
5858   function depositCN(uint coverId) public onlyInternal returns (bool success) {
5859     require(_getLockedCNAgainstCover(coverId) > 0, "No cover note available");
5860     td.setDepositCN(coverId, true);
5861     success = true;
5862   }
5863 
5864   /**
5865    * @param _of address of Member
5866    * @param _coverId Cover Id
5867    * @param _lockTime Pending Time + Cover Period 7*1 days
5868    */
5869   function extendCNEPOff(address _of, uint _coverId, uint _lockTime) public onlyInternal {
5870     uint timeStamp = now.add(_lockTime);
5871     uint coverValidUntil = qd.getValidityOfCover(_coverId);
5872     if (timeStamp >= coverValidUntil) {
5873       bytes32 reason = keccak256(abi.encodePacked("CN", _of, _coverId));
5874       tc.extendLockOf(_of, reason, timeStamp);
5875     }
5876   }
5877 
5878   /**
5879    * @dev to burn the deposited cover tokens
5880    * @param coverId is id of cover whose tokens have to be burned
5881    * @return the status of the successful burning
5882    */
5883   function burnDepositCN(uint coverId) public onlyInternal returns (bool success) {
5884     address _of = qd.getCoverMemberAddress(coverId);
5885     uint amount;
5886     (amount,) = td.depositedCN(coverId);
5887     amount = (amount.mul(50)).div(100);
5888     bytes32 reason = keccak256(abi.encodePacked("CN", _of, coverId));
5889     tc.burnLockedTokens(_of, reason, amount);
5890     success = true;
5891   }
5892 
5893   /**
5894    * @dev Unlocks covernote locked against a given cover
5895    * @param coverId id of cover
5896    */
5897   function unlockCN(uint coverId) public onlyInternal {
5898     (, bool isDeposited) = td.depositedCN(coverId);
5899     require(!isDeposited, "Cover note is deposited and can not be released");
5900     uint lockedCN = _getLockedCNAgainstCover(coverId);
5901     if (lockedCN != 0) {
5902       address coverHolder = qd.getCoverMemberAddress(coverId);
5903       bytes32 reason = keccak256(abi.encodePacked("CN", coverHolder, coverId));
5904       tc.releaseLockedTokens(coverHolder, reason, lockedCN);
5905     }
5906   }
5907 
5908   /**
5909    * @dev Burns tokens used for fraudulent voting against a claim
5910    * @param claimid Claim Id.
5911    * @param _value number of tokens to be burned
5912    * @param _of Claim Assessor's address.
5913    */
5914   function burnCAToken(uint claimid, uint _value, address _of) public {
5915 
5916     require(ms.checkIsAuthToGoverned(msg.sender));
5917     tc.burnLockedTokens(_of, "CLA", _value);
5918     emit BurnCATokens(claimid, _of, _value);
5919   }
5920 
5921   /**
5922    * @dev to lock cover note tokens
5923    * @param coverNoteAmount is number of tokens to be locked
5924    * @param coverPeriod is cover period in concern
5925    * @param coverId is the cover id of cover in concern
5926    * @param _of address whose tokens are to be locked
5927    */
5928   function lockCN(
5929     uint coverNoteAmount,
5930     uint coverPeriod,
5931     uint coverId,
5932     address _of
5933   )
5934   public
5935   onlyInternal
5936   {
5937     uint validity = (coverPeriod * 1 days).add(td.lockTokenTimeAfterCoverExp());
5938     bytes32 reason = keccak256(abi.encodePacked("CN", _of, coverId));
5939     td.setDepositCNAmount(coverId, coverNoteAmount);
5940     tc.lockOf(_of, reason, coverNoteAmount, validity);
5941   }
5942 
5943   /**
5944    * @dev to check if a  member is locked for member vote
5945    * @param _of is the member address in concern
5946    * @return the boolean status
5947    */
5948   function isLockedForMemberVote(address _of) public view returns (bool) {
5949     return now < tk.isLockedForMV(_of);
5950   }
5951 
5952   /**
5953    * @dev Internal function to gets amount of locked NXM tokens,
5954    * staked against smartcontract by index
5955    * @param _stakerAddress address of user
5956    * @param _stakedContractAddress staked contract address
5957    * @param _stakedContractIndex index of staking
5958    */
5959   function deprecated_getStakerLockedTokensOnSmartContract(
5960     address _stakerAddress,
5961     address _stakedContractAddress,
5962     uint _stakedContractIndex
5963   )
5964   public
5965   view
5966   returns
5967   (uint amount)
5968   {
5969     amount = _deprecated_getStakerLockedTokensOnSmartContract(_stakerAddress,
5970       _stakedContractAddress, _stakedContractIndex);
5971   }
5972 
5973   /**
5974    * @dev Function to gets unlockable amount of locked NXM
5975    * tokens, staked against smartcontract by index
5976    * @param stakerAddress address of staker
5977    * @param stakedContractAddress staked contract address
5978    * @param stakerIndex index of staking
5979    */
5980   function deprecated_getStakerUnlockableTokensOnSmartContract(
5981     address stakerAddress,
5982     address stakedContractAddress,
5983     uint stakerIndex
5984   )
5985   public
5986   view
5987   returns (uint)
5988   {
5989     return _deprecated_getStakerUnlockableTokensOnSmartContract(stakerAddress, stakedContractAddress,
5990       td.getStakerStakedContractIndex(stakerAddress, stakerIndex));
5991   }
5992 
5993   /**
5994    * @dev releases unlockable staked tokens to staker
5995    */
5996   function deprecated_unlockStakerUnlockableTokens(address _stakerAddress) public checkPause {
5997     uint unlockableAmount;
5998     address scAddress;
5999     bytes32 reason;
6000     uint scIndex;
6001     for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
6002       scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
6003       scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
6004       unlockableAmount = _deprecated_getStakerUnlockableTokensOnSmartContract(
6005         _stakerAddress, scAddress,
6006         scIndex);
6007       td.setUnlockableBeforeLastBurnTokens(_stakerAddress, i, 0);
6008       td.pushUnlockedStakedTokens(_stakerAddress, i, unlockableAmount);
6009       reason = keccak256(abi.encodePacked("UW", _stakerAddress, scAddress, scIndex));
6010       tc.releaseLockedTokens(_stakerAddress, reason, unlockableAmount);
6011     }
6012   }
6013 
6014   /**
6015    * @dev to get tokens of staker locked before burning that are allowed to burn
6016    * @param stakerAdd is the address of the staker
6017    * @param stakedAdd is the address of staked contract in concern
6018    * @param stakerIndex is the staker index in concern
6019    * @return amount of unlockable tokens
6020    * @return amount of tokens that can burn
6021    */
6022   function _deprecated_unlockableBeforeBurningAndCanBurn(
6023     address stakerAdd,
6024     address stakedAdd,
6025     uint stakerIndex
6026   )
6027   public
6028   view
6029   returns
6030   (uint amount, uint canBurn) {
6031 
6032     uint dateAdd;
6033     uint initialStake;
6034     uint totalBurnt;
6035     uint ub;
6036     (, , dateAdd, initialStake, , totalBurnt, ub) = td.stakerStakedContracts(stakerAdd, stakerIndex);
6037     canBurn = _deprecated_calculateStakedTokens(initialStake, now.sub(dateAdd).div(1 days), td.scValidDays());
6038     // Can't use SafeMaths for int.
6039     int v = int(initialStake - (canBurn) - (totalBurnt) - (
6040     td.getStakerUnlockedStakedTokens(stakerAdd, stakerIndex)) - (ub));
6041     uint currentLockedTokens = _deprecated_getStakerLockedTokensOnSmartContract(
6042       stakerAdd, stakedAdd, td.getStakerStakedContractIndex(stakerAdd, stakerIndex));
6043     if (v < 0) {
6044       v = 0;
6045     }
6046     amount = uint(v);
6047     if (canBurn > currentLockedTokens.sub(amount).sub(ub)) {
6048       canBurn = currentLockedTokens.sub(amount).sub(ub);
6049     }
6050   }
6051 
6052   /**
6053    * @dev to get tokens of staker that are unlockable
6054    * @param _stakerAddress is the address of the staker
6055    * @param _stakedContractAddress is the address of staked contract in concern
6056    * @param _stakedContractIndex is the staked contract index in concern
6057    * @return amount of unlockable tokens
6058    */
6059   function _deprecated_getStakerUnlockableTokensOnSmartContract(
6060     address _stakerAddress,
6061     address _stakedContractAddress,
6062     uint _stakedContractIndex
6063   )
6064   public
6065   view
6066   returns
6067   (uint amount)
6068   {
6069     uint initialStake;
6070     uint stakerIndex = td.getStakedContractStakerIndex(
6071       _stakedContractAddress, _stakedContractIndex);
6072     uint burnt;
6073     (, , , initialStake, , burnt,) = td.stakerStakedContracts(_stakerAddress, stakerIndex);
6074     uint alreadyUnlocked = td.getStakerUnlockedStakedTokens(_stakerAddress, stakerIndex);
6075     uint currentStakedTokens;
6076     (, currentStakedTokens) = _deprecated_unlockableBeforeBurningAndCanBurn(_stakerAddress,
6077       _stakedContractAddress, stakerIndex);
6078     amount = initialStake.sub(currentStakedTokens).sub(alreadyUnlocked).sub(burnt);
6079   }
6080 
6081   /**
6082    * @dev Internal function to get the amount of locked NXM tokens,
6083    * staked against smartcontract by index
6084    * @param _stakerAddress address of user
6085    * @param _stakedContractAddress staked contract address
6086    * @param _stakedContractIndex index of staking
6087    */
6088   function _deprecated_getStakerLockedTokensOnSmartContract(
6089     address _stakerAddress,
6090     address _stakedContractAddress,
6091     uint _stakedContractIndex
6092   )
6093   internal
6094   view
6095   returns
6096   (uint amount)
6097   {
6098     bytes32 reason = keccak256(abi.encodePacked("UW", _stakerAddress,
6099       _stakedContractAddress, _stakedContractIndex));
6100     amount = tc.tokensLocked(_stakerAddress, reason);
6101   }
6102 
6103   /**
6104    * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
6105    * @param _coverId coverId of the cover.
6106    */
6107   function _getLockedCNAgainstCover(uint _coverId) internal view returns (uint) {
6108     address coverHolder = qd.getCoverMemberAddress(_coverId);
6109     bytes32 reason = keccak256(abi.encodePacked("CN", coverHolder, _coverId));
6110     return tc.tokensLockedAtTime(coverHolder, reason, now);
6111   }
6112 
6113   /**
6114    * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
6115    * @param _of address of the coverHolder.
6116    * @param _coverId coverId of the cover.
6117    */
6118   function _getUserLockedCNTokens(address _of, uint _coverId) internal view returns (uint) {
6119     bytes32 reason = keccak256(abi.encodePacked("CN", _of, _coverId));
6120     return tc.tokensLockedAtTime(_of, reason, now);
6121   }
6122 
6123   /**
6124    * @dev Internal function to gets remaining amount of staked NXM tokens,
6125    * against smartcontract by index
6126    * @param _stakeAmount address of user
6127    * @param _stakeDays staked contract address
6128    * @param _validDays index of staking
6129    */
6130   function _deprecated_calculateStakedTokens(
6131     uint _stakeAmount,
6132     uint _stakeDays,
6133     uint _validDays
6134   )
6135   internal
6136   pure
6137   returns (uint amount)
6138   {
6139     if (_validDays > _stakeDays) {
6140       uint rf = ((_validDays.sub(_stakeDays)).mul(100000)).div(_validDays);
6141       amount = (rf.mul(_stakeAmount)).div(100000);
6142     } else {
6143       amount = 0;
6144     }
6145   }
6146 
6147   /**
6148    * @dev Gets the total staked NXM tokens against Smart contract
6149    * by all stakers
6150    * @param _stakedContractAddress smart contract address.
6151    * @return amount total staked NXM tokens.
6152    */
6153   function _deprecated_burnStakerTokenLockedAgainstSmartContract(
6154     address _stakerAddress,
6155     address _stakedContractAddress,
6156     uint _stakedContractIndex,
6157     uint _amount
6158   )
6159   internal
6160   {
6161     uint stakerIndex = td.getStakedContractStakerIndex(
6162       _stakedContractAddress, _stakedContractIndex);
6163     td.pushBurnedTokens(_stakerAddress, stakerIndex, _amount);
6164     bytes32 reason = keccak256(abi.encodePacked("UW", _stakerAddress,
6165       _stakedContractAddress, _stakedContractIndex));
6166     tc.burnLockedTokens(_stakerAddress, reason, _amount);
6167   }
6168 }
6169 
6170 // File: contracts/modules/cover/Quotation.sol
6171 
6172 /* Copyright (C) 2020 NexusMutual.io
6173 
6174   This program is free software: you can redistribute it and/or modify
6175     it under the terms of the GNU General Public License as published by
6176     the Free Software Foundation, either version 3 of the License, or
6177     (at your option) any later version.
6178 
6179   This program is distributed in the hope that it will be useful,
6180     but WITHOUT ANY WARRANTY; without even the implied warranty of
6181     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
6182     GNU General Public License for more details.
6183 
6184   You should have received a copy of the GNU General Public License
6185     along with this program.  If not, see http://www.gnu.org/licenses/ */
6186 
6187 pragma solidity ^0.5.0;
6188 
6189 
6190 
6191 
6192 
6193 
6194 
6195 
6196 
6197 
6198 contract Quotation is Iupgradable {
6199   using SafeMath for uint;
6200 
6201   TokenFunctions internal tf;
6202   TokenController internal tc;
6203   TokenData internal td;
6204   Pool1 internal p1;
6205   PoolData internal pd;
6206   QuotationData internal qd;
6207   MCR internal m1;
6208   MemberRoles internal mr;
6209   bool internal locked;
6210 
6211   event RefundEvent(address indexed user, bool indexed status, uint holdedCoverID, bytes32 reason);
6212 
6213   modifier noReentrancy() {
6214     require(!locked, "Reentrant call.");
6215     locked = true;
6216     _;
6217     locked = false;
6218   }
6219 
6220   /**
6221    * @dev Iupgradable Interface to update dependent contract address
6222    */
6223   function changeDependentContractAddress() public onlyInternal {
6224     m1 = MCR(ms.getLatestAddress("MC"));
6225     tf = TokenFunctions(ms.getLatestAddress("TF"));
6226     tc = TokenController(ms.getLatestAddress("TC"));
6227     td = TokenData(ms.getLatestAddress("TD"));
6228     qd = QuotationData(ms.getLatestAddress("QD"));
6229     p1 = Pool1(ms.getLatestAddress("P1"));
6230     pd = PoolData(ms.getLatestAddress("PD"));
6231     mr = MemberRoles(ms.getLatestAddress("MR"));
6232   }
6233 
6234   function sendEther() public payable {
6235 
6236   }
6237 
6238   /**
6239    * @dev Expires a cover after a set period of time.
6240    * Changes the status of the Cover and reduces the current
6241    * sum assured of all areas in which the quotation lies
6242    * Unlocks the CN tokens of the cover. Updates the Total Sum Assured value.
6243    * @param _cid Cover Id.
6244    */
6245   function expireCover(uint _cid) public {
6246     require(checkCoverExpired(_cid) && qd.getCoverStatusNo(_cid) != uint(QuotationData.CoverStatus.CoverExpired));
6247 
6248     tf.unlockCN(_cid);
6249     bytes4 curr;
6250     address scAddress;
6251     uint sumAssured;
6252     (,, scAddress, curr, sumAssured,) = qd.getCoverDetailsByCoverID1(_cid);
6253     if (qd.getCoverStatusNo(_cid) != uint(QuotationData.CoverStatus.ClaimAccepted))
6254       _removeSAFromCSA(_cid, sumAssured);
6255     qd.changeCoverStatusNo(_cid, uint8(QuotationData.CoverStatus.CoverExpired));
6256   }
6257 
6258   /**
6259    * @dev Checks if a cover should get expired/closed or not.
6260    * @param _cid Cover Index.
6261    * @return expire true if the Cover's time has expired, false otherwise.
6262    */
6263   function checkCoverExpired(uint _cid) public view returns (bool expire) {
6264 
6265     expire = qd.getValidityOfCover(_cid) < uint64(now);
6266 
6267   }
6268 
6269   /**
6270    * @dev Updates the Sum Assured Amount of all the quotation.
6271    * @param _cid Cover id
6272    * @param _amount that will get subtracted Current Sum Assured
6273    * amount that comes under a quotation.
6274    */
6275   function removeSAFromCSA(uint _cid, uint _amount) public onlyInternal {
6276     _removeSAFromCSA(_cid, _amount);
6277   }
6278 
6279   /**
6280    * @dev Makes Cover funded via NXM tokens.
6281    * @param smartCAdd Smart Contract Address
6282    */
6283   function makeCoverUsingNXMTokens(
6284     uint[] memory coverDetails,
6285     uint16 coverPeriod,
6286     bytes4 coverCurr,
6287     address smartCAdd,
6288     uint8 _v,
6289     bytes32 _r,
6290     bytes32 _s
6291   )
6292   public
6293   isMemberAndcheckPause
6294   {
6295 
6296     tc.burnFrom(msg.sender, coverDetails[2]); // need burn allowance
6297     _verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
6298   }
6299 
6300   /**
6301    * @dev Verifies cover details signed off chain.
6302    * @param from address of funder.
6303    * @param scAddress Smart Contract Address
6304    */
6305   function verifyCoverDetails(
6306     address payable from,
6307     address scAddress,
6308     bytes4 coverCurr,
6309     uint[] memory coverDetails,
6310     uint16 coverPeriod,
6311     uint8 _v,
6312     bytes32 _r,
6313     bytes32 _s
6314   )
6315   public
6316   onlyInternal
6317   {
6318     _verifyCoverDetails(
6319       from,
6320       scAddress,
6321       coverCurr,
6322       coverDetails,
6323       coverPeriod,
6324       _v,
6325       _r,
6326       _s
6327     );
6328   }
6329 
6330   /**
6331    * @dev Verifies signature.
6332    * @param coverDetails details related to cover.
6333    * @param coverPeriod validity of cover.
6334    * @param smaratCA smarat contract address.
6335    * @param _v argument from vrs hash.
6336    * @param _r argument from vrs hash.
6337    * @param _s argument from vrs hash.
6338    */
6339   function verifySign(
6340     uint[] memory coverDetails,
6341     uint16 coverPeriod,
6342     bytes4 curr,
6343     address smaratCA,
6344     uint8 _v,
6345     bytes32 _r,
6346     bytes32 _s
6347   )
6348   public
6349   view
6350   returns (bool)
6351   {
6352     require(smaratCA != address(0));
6353     require(pd.capReached() == 1, "Can not buy cover until cap reached for 1st time");
6354     bytes32 hash = getOrderHash(coverDetails, coverPeriod, curr, smaratCA);
6355     return isValidSignature(hash, _v, _r, _s);
6356   }
6357 
6358   /**
6359    * @dev Gets order hash for given cover details.
6360    * @param coverDetails details realted to cover.
6361    * @param coverPeriod validity of cover.
6362    * @param smaratCA smarat contract address.
6363    */
6364   function getOrderHash(
6365     uint[] memory coverDetails,
6366     uint16 coverPeriod,
6367     bytes4 curr,
6368     address smaratCA
6369   )
6370   public
6371   view
6372   returns (bytes32)
6373   {
6374     return keccak256(
6375       abi.encodePacked(
6376         coverDetails[0],
6377         curr, coverPeriod,
6378         smaratCA,
6379         coverDetails[1],
6380         coverDetails[2],
6381         coverDetails[3],
6382         coverDetails[4],
6383         address(this)
6384       )
6385     );
6386   }
6387 
6388   /**
6389    * @dev Verifies signature.
6390    * @param hash order hash
6391    * @param v argument from vrs hash.
6392    * @param r argument from vrs hash.
6393    * @param s argument from vrs hash.
6394    */
6395   function isValidSignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public view returns (bool) {
6396     bytes memory prefix = "\x19Ethereum Signed Message:\n32";
6397     bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
6398     address a = ecrecover(prefixedHash, v, r, s);
6399     return (a == qd.getAuthQuoteEngine());
6400   }
6401 
6402   /**
6403    * @dev to get the status of recently holded coverID
6404    * @param userAdd is the user address in concern
6405    * @return the status of the concerned coverId
6406    */
6407   function getRecentHoldedCoverIdStatus(address userAdd) public view returns (int) {
6408 
6409     uint holdedCoverLen = qd.getUserHoldedCoverLength(userAdd);
6410     if (holdedCoverLen == 0) {
6411       return - 1;
6412     } else {
6413       uint holdedCoverID = qd.getUserHoldedCoverByIndex(userAdd, holdedCoverLen.sub(1));
6414       return int(qd.holdedCoverIDStatus(holdedCoverID));
6415     }
6416   }
6417 
6418   /**
6419    * @dev to initiate the membership and the cover
6420    * @param smartCAdd is the smart contract address to make cover on
6421    * @param coverCurr is the currency used to make cover
6422    * @param coverDetails list of details related to cover like cover amount, expire time, coverCurrPrice and priceNXM
6423    * @param coverPeriod is cover period for which cover is being bought
6424    * @param _v argument from vrs hash
6425    * @param _r argument from vrs hash
6426    * @param _s argument from vrs hash
6427    */
6428   function initiateMembershipAndCover(
6429     address smartCAdd,
6430     bytes4 coverCurr,
6431     uint[] memory coverDetails,
6432     uint16 coverPeriod,
6433     uint8 _v,
6434     bytes32 _r,
6435     bytes32 _s
6436   )
6437   public
6438   payable
6439   checkPause
6440   {
6441     require(coverDetails[3] > now);
6442     require(!qd.timestampRepeated(coverDetails[4]));
6443     qd.setTimestampRepeated(coverDetails[4]);
6444     require(!ms.isMember(msg.sender));
6445     require(qd.refundEligible(msg.sender) == false);
6446     uint joinFee = td.joiningFee();
6447     uint totalFee = joinFee;
6448     if (coverCurr == "ETH") {
6449       totalFee = joinFee.add(coverDetails[1]);
6450     } else {
6451       IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
6452       require(erc20.transferFrom(msg.sender, address(this), coverDetails[1]));
6453     }
6454     require(msg.value == totalFee);
6455     require(verifySign(coverDetails, coverPeriod, coverCurr, smartCAdd, _v, _r, _s));
6456     qd.addHoldCover(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod);
6457     qd.setRefundEligible(msg.sender, true);
6458   }
6459 
6460   /**
6461    * @dev to get the verdict of kyc process
6462    * @param status is the kyc status
6463    * @param _add is the address of member
6464    */
6465   function kycVerdict(address _add, bool status) public checkPause noReentrancy {
6466     require(msg.sender == qd.kycAuthAddress());
6467     _kycTrigger(status, _add);
6468   }
6469 
6470   /**
6471    * @dev transfering Ethers to newly created quotation contract.
6472    */
6473   function transferAssetsToNewContract(address newAdd) public onlyInternal noReentrancy {
6474     uint amount = address(this).balance;
6475     IERC20 erc20;
6476     if (amount > 0) {
6477       // newAdd.transfer(amount);
6478       Quotation newQT = Quotation(newAdd);
6479       newQT.sendEther.value(amount)();
6480     }
6481     uint currAssetLen = pd.getAllCurrenciesLen();
6482     for (uint64 i = 1; i < currAssetLen; i++) {
6483       bytes4 currName = pd.getCurrenciesByIndex(i);
6484       address currAddr = pd.getCurrencyAssetAddress(currName);
6485       erc20 = IERC20(currAddr); // solhint-disable-line
6486       if (erc20.balanceOf(address(this)) > 0) {
6487         require(erc20.transfer(newAdd, erc20.balanceOf(address(this))));
6488       }
6489     }
6490   }
6491 
6492 
6493   /**
6494    * @dev Creates cover of the quotation, changes the status of the quotation ,
6495    * updates the total sum assured and locks the tokens of the cover against a quote.
6496    * @param from Quote member Ethereum address.
6497    */
6498 
6499   function _makeCover(//solhint-disable-line
6500     address payable from,
6501     address scAddress,
6502     bytes4 coverCurr,
6503     uint[] memory coverDetails,
6504     uint16 coverPeriod
6505   )
6506   internal
6507   {
6508     uint cid = qd.getCoverLength();
6509     qd.addCover(coverPeriod, coverDetails[0],
6510       from, coverCurr, scAddress, coverDetails[1], coverDetails[2]);
6511     // if cover period of quote is less than 60 days.
6512     if (coverPeriod <= 60) {
6513       p1.closeCoverOraclise(cid, uint64(uint(coverPeriod).mul(1 days)));
6514     }
6515     uint coverNoteAmount = (coverDetails[2].mul(qd.tokensRetained())).div(100);
6516     tc.mint(from, coverNoteAmount);
6517     tf.lockCN(coverNoteAmount, coverPeriod, cid, from);
6518     qd.addInTotalSumAssured(coverCurr, coverDetails[0]);
6519     qd.addInTotalSumAssuredSC(scAddress, coverCurr, coverDetails[0]);
6520 
6521 
6522     tf.pushStakerRewards(scAddress, coverDetails[2]);
6523   }
6524 
6525   /**
6526    * @dev Makes a vover.
6527    * @param from address of funder.
6528    * @param scAddress Smart Contract Address
6529    */
6530   function _verifyCoverDetails(
6531     address payable from,
6532     address scAddress,
6533     bytes4 coverCurr,
6534     uint[] memory coverDetails,
6535     uint16 coverPeriod,
6536     uint8 _v,
6537     bytes32 _r,
6538     bytes32 _s
6539   )
6540   internal
6541   {
6542     require(coverDetails[3] > now);
6543     require(!qd.timestampRepeated(coverDetails[4]));
6544     qd.setTimestampRepeated(coverDetails[4]);
6545     require(verifySign(coverDetails, coverPeriod, coverCurr, scAddress, _v, _r, _s));
6546     _makeCover(from, scAddress, coverCurr, coverDetails, coverPeriod);
6547 
6548   }
6549 
6550   /**
6551    * @dev Updates the Sum Assured Amount of all the quotation.
6552    * @param _cid Cover id
6553    * @param _amount that will get subtracted Current Sum Assured
6554    * amount that comes under a quotation.
6555    */
6556   function _removeSAFromCSA(uint _cid, uint _amount) internal checkPause {
6557     address _add;
6558     bytes4 coverCurr;
6559     (,, _add, coverCurr,,) = qd.getCoverDetailsByCoverID1(_cid);
6560     qd.subFromTotalSumAssured(coverCurr, _amount);
6561     qd.subFromTotalSumAssuredSC(_add, coverCurr, _amount);
6562   }
6563 
6564   /**
6565    * @dev to trigger the kyc process
6566    * @param status is the kyc status
6567    * @param _add is the address of member
6568    */
6569   function _kycTrigger(bool status, address _add) internal {
6570 
6571     uint holdedCoverLen = qd.getUserHoldedCoverLength(_add).sub(1);
6572     uint holdedCoverID = qd.getUserHoldedCoverByIndex(_add, holdedCoverLen);
6573     address payable userAdd;
6574     address scAddress;
6575     bytes4 coverCurr;
6576     uint16 coverPeriod;
6577     uint[]  memory coverDetails = new uint[](4);
6578     IERC20 erc20;
6579 
6580     (, userAdd, coverDetails) = qd.getHoldedCoverDetailsByID2(holdedCoverID);
6581     (, scAddress, coverCurr, coverPeriod) = qd.getHoldedCoverDetailsByID1(holdedCoverID);
6582     require(qd.refundEligible(userAdd));
6583     qd.setRefundEligible(userAdd, false);
6584     require(qd.holdedCoverIDStatus(holdedCoverID) == uint(QuotationData.HCIDStatus.kycPending));
6585     uint joinFee = td.joiningFee();
6586     if (status) {
6587       mr.payJoiningFee.value(joinFee)(userAdd);
6588       if (coverDetails[3] > now) {
6589         qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycPass));
6590         address poolAdd = ms.getLatestAddress("P1");
6591         if (coverCurr == "ETH") {
6592           p1.sendEther.value(coverDetails[1])();
6593         } else {
6594           erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); // solhint-disable-line
6595           require(erc20.transfer(poolAdd, coverDetails[1]));
6596         }
6597         emit RefundEvent(userAdd, status, holdedCoverID, "KYC Passed");
6598         _makeCover(userAdd, scAddress, coverCurr, coverDetails, coverPeriod);
6599 
6600       } else {
6601         qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycPassNoCover));
6602         if (coverCurr == "ETH") {
6603           userAdd.transfer(coverDetails[1]);
6604         } else {
6605           erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); // solhint-disable-line
6606           require(erc20.transfer(userAdd, coverDetails[1]));
6607         }
6608         emit RefundEvent(userAdd, status, holdedCoverID, "Cover Failed");
6609       }
6610     } else {
6611       qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycFailedOrRefunded));
6612       uint totalRefund = joinFee;
6613       if (coverCurr == "ETH") {
6614         totalRefund = coverDetails[1].add(joinFee);
6615       } else {
6616         erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); // solhint-disable-line
6617         require(erc20.transfer(userAdd, coverDetails[1]));
6618       }
6619       userAdd.transfer(totalRefund);
6620       emit RefundEvent(userAdd, status, holdedCoverID, "KYC Failed");
6621     }
6622 
6623   }
6624 }
6625 
6626 // File: contracts/modules/capital/Pool2.sol
6627 
6628 /* Copyright (C) 2020 NexusMutual.io
6629 
6630   This program is free software: you can redistribute it and/or modify
6631     it under the terms of the GNU General Public License as published by
6632     the Free Software Foundation, either version 3 of the License, or
6633     (at your option) any later version.
6634 
6635   This program is distributed in the hope that it will be useful,
6636     but WITHOUT ANY WARRANTY; without even the implied warranty of
6637     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
6638     GNU General Public License for more details.
6639 
6640   You should have received a copy of the GNU General Public License
6641     along with this program.  If not, see http://www.gnu.org/licenses/ */
6642 
6643 pragma solidity ^0.5.0;
6644 
6645 
6646 
6647 
6648 
6649 contract Pool2 is Iupgradable {
6650   using SafeMath for uint;
6651 
6652   MCR internal m1;
6653   Pool1 internal p1;
6654   PoolData internal pd;
6655   Factory internal factory;
6656   address public uniswapFactoryAddress;
6657   uint internal constant DECIMAL1E18 = uint(10) ** 18;
6658   bool internal locked;
6659 
6660   constructor(address _uniswapFactoryAdd) public {
6661 
6662     uniswapFactoryAddress = _uniswapFactoryAdd;
6663     factory = Factory(_uniswapFactoryAdd);
6664   }
6665 
6666   function() external payable {}
6667 
6668   event Liquidity(bytes16 typeOf, bytes16 functionName);
6669 
6670   event Rebalancing(bytes4 iaCurr, uint tokenAmount);
6671 
6672   modifier noReentrancy() {
6673     require(!locked, "Reentrant call.");
6674     locked = true;
6675     _;
6676     locked = false;
6677   }
6678 
6679   /**
6680    * @dev to change the uniswap factory address
6681    * @param newFactoryAddress is the new factory address in concern
6682    * @return the status of the concerned coverId
6683    */
6684   function changeUniswapFactoryAddress(address newFactoryAddress) external onlyInternal {
6685     // require(ms.isOwner(msg.sender) || ms.checkIsAuthToGoverned(msg.sender));
6686     uniswapFactoryAddress = newFactoryAddress;
6687     factory = Factory(uniswapFactoryAddress);
6688   }
6689 
6690   /**
6691    * @dev On upgrade transfer all investment assets and ether to new Investment Pool
6692    * @param newPoolAddress New Investment Assest Pool address
6693    */
6694   function upgradeInvestmentPool(address payable newPoolAddress) external onlyInternal noReentrancy {
6695     uint len = pd.getInvestmentCurrencyLen();
6696     for (uint64 i = 1; i < len; i++) {
6697       bytes4 iaName = pd.getInvestmentCurrencyByIndex(i);
6698       _upgradeInvestmentPool(iaName, newPoolAddress);
6699     }
6700 
6701     if (address(this).balance > 0) {
6702       Pool2 newP2 = Pool2(newPoolAddress);
6703       newP2.sendEther.value(address(this).balance)();
6704     }
6705   }
6706 
6707   /**
6708    * @dev Internal Swap of assets between Capital
6709    * and Investment Sub pool for excess or insufficient
6710    * liquidity conditions of a given currency.
6711    */
6712   function internalLiquiditySwap(bytes4 curr) external onlyInternal noReentrancy {
6713     uint caBalance;
6714     uint baseMin;
6715     uint varMin;
6716     (, baseMin, varMin) = pd.getCurrencyAssetVarBase(curr);
6717     caBalance = _getCurrencyAssetsBalance(curr);
6718 
6719     if (caBalance > uint(baseMin).add(varMin).mul(2)) {
6720       _internalExcessLiquiditySwap(curr, baseMin, varMin, caBalance);
6721     } else if (caBalance < uint(baseMin).add(varMin)) {
6722       _internalInsufficientLiquiditySwap(curr, baseMin, varMin, caBalance);
6723 
6724     }
6725   }
6726 
6727   /**
6728    * @dev Saves a given investment asset details. To be called daily.
6729    * @param curr array of Investment asset name.
6730    * @param rate array of investment asset exchange rate.
6731    * @param date current date in yyyymmdd.
6732    */
6733   function saveIADetails(bytes4[] calldata curr, uint64[] calldata rate, uint64 date, bool bit)
6734   external checkPause noReentrancy {
6735     bytes4 maxCurr;
6736     bytes4 minCurr;
6737     uint64 maxRate;
6738     uint64 minRate;
6739     //ONLY NOTARZIE ADDRESS CAN POST
6740     require(pd.isnotarise(msg.sender));
6741     (maxCurr, maxRate, minCurr, minRate) = _calculateIARank(curr, rate);
6742     pd.saveIARankDetails(maxCurr, maxRate, minCurr, minRate, date);
6743     pd.updatelastDate(date);
6744     uint len = curr.length;
6745     for (uint i = 0; i < len; i++) {
6746       pd.updateIAAvgRate(curr[i], rate[i]);
6747     }
6748     if (bit)   //for testing purpose
6749       _rebalancingLiquidityTrading(maxCurr, maxRate);
6750     p1.saveIADetailsOracalise(pd.iaRatesTime());
6751   }
6752 
6753   /**
6754    * @dev External Trade for excess or insufficient
6755    * liquidity conditions of a given currency.
6756    */
6757   function externalLiquidityTrade() external onlyInternal {
6758 
6759     bool triggerTrade;
6760     bytes4 curr;
6761     bytes4 minIACurr;
6762     bytes4 maxIACurr;
6763     uint amount;
6764     uint minIARate;
6765     uint maxIARate;
6766     uint baseMin;
6767     uint varMin;
6768     uint caBalance;
6769 
6770 
6771     (maxIACurr, maxIARate, minIACurr, minIARate) = pd.getIARankDetailsByDate(pd.getLastDate());
6772     uint len = pd.getAllCurrenciesLen();
6773     for (uint64 i = 0; i < len; i++) {
6774       curr = pd.getCurrenciesByIndex(i);
6775       (, baseMin, varMin) = pd.getCurrencyAssetVarBase(curr);
6776       caBalance = _getCurrencyAssetsBalance(curr);
6777 
6778       if (caBalance > uint(baseMin).add(varMin).mul(2)) {// excess
6779         amount = caBalance.sub(((uint(baseMin).add(varMin)).mul(3)).div(2)); // *10**18;
6780         triggerTrade = _externalExcessLiquiditySwap(curr, minIACurr, amount);
6781       } else if (caBalance < uint(baseMin).add(varMin)) {// insufficient
6782         amount = (((uint(baseMin).add(varMin)).mul(3)).div(2)).sub(caBalance);
6783         triggerTrade = _externalInsufficientLiquiditySwap(curr, maxIACurr, amount);
6784       }
6785 
6786       if (triggerTrade) {
6787         p1.triggerExternalLiquidityTrade();
6788       }
6789     }
6790   }
6791 
6792   /**
6793    * Iupgradable Interface to update dependent contract address
6794    */
6795   function changeDependentContractAddress() public onlyInternal {
6796     m1 = MCR(ms.getLatestAddress("MC"));
6797     pd = PoolData(ms.getLatestAddress("PD"));
6798     p1 = Pool1(ms.getLatestAddress("P1"));
6799   }
6800 
6801   function sendEther() public payable {
6802 
6803   }
6804 
6805   /**
6806    * @dev Gets currency asset balance for a given currency name.
6807    */
6808   function _getCurrencyAssetsBalance(bytes4 _curr) public view returns (uint caBalance) {
6809     if (_curr == "ETH") {
6810       caBalance = address(p1).balance;
6811     } else {
6812       IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr));
6813       caBalance = erc20.balanceOf(address(p1));
6814     }
6815   }
6816 
6817   /**
6818    * @dev Transfers ERC20 investment asset from this Pool to another Pool.
6819    */
6820   function _transferInvestmentAsset(
6821     bytes4 _curr,
6822     address _transferTo,
6823     uint _amount
6824   )
6825   internal
6826   {
6827     if (_curr == "ETH") {
6828       if (_amount > address(this).balance)
6829         _amount = address(this).balance;
6830       p1.sendEther.value(_amount)();
6831     } else {
6832       IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
6833       if (_amount > erc20.balanceOf(address(this)))
6834         _amount = erc20.balanceOf(address(this));
6835       require(erc20.transfer(_transferTo, _amount));
6836     }
6837   }
6838 
6839   /**
6840    * @dev to perform rebalancing
6841    * @param iaCurr is the investment asset currency
6842    * @param iaRate is the investment asset rate
6843    */
6844   function _rebalancingLiquidityTrading(
6845     bytes4 iaCurr,
6846     uint64 iaRate
6847   )
6848   internal
6849   checkPause
6850   {
6851     uint amountToSell;
6852     uint totalRiskBal = pd.getLastVfull();
6853     uint intermediaryEth;
6854     uint ethVol = pd.ethVolumeLimit();
6855 
6856     totalRiskBal = (totalRiskBal.mul(100000)).div(DECIMAL1E18);
6857     Exchange exchange;
6858     if (totalRiskBal > 0) {
6859       amountToSell = ((totalRiskBal.mul(2).mul(
6860         iaRate)).mul(pd.variationPercX100())).div(100 * 100 * 100000);
6861       amountToSell = (amountToSell.mul(
6862         10 ** uint(pd.getInvestmentAssetDecimals(iaCurr)))).div(100); // amount of asset to sell
6863 
6864       if (iaCurr != "ETH" && _checkTradeConditions(iaCurr, iaRate, totalRiskBal)) {
6865         exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(iaCurr)));
6866         intermediaryEth = exchange.getTokenToEthInputPrice(amountToSell);
6867         if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) {
6868           intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
6869           amountToSell = (exchange.getEthToTokenInputPrice(intermediaryEth).mul(995)).div(1000);
6870         }
6871         IERC20 erc20;
6872         erc20 = IERC20(pd.getCurrencyAssetAddress(iaCurr));
6873         erc20.approve(address(exchange), amountToSell);
6874         exchange.tokenToEthSwapInput(amountToSell, (exchange.getTokenToEthInputPrice(
6875           amountToSell).mul(995)).div(1000), pd.uniswapDeadline().add(now));
6876       } else if (iaCurr == "ETH" && _checkTradeConditions(iaCurr, iaRate, totalRiskBal)) {
6877 
6878         _transferInvestmentAsset(iaCurr, ms.getLatestAddress("P1"), amountToSell);
6879       }
6880       emit Rebalancing(iaCurr, amountToSell);
6881     }
6882   }
6883 
6884   /**
6885    * @dev Checks whether trading is required for a
6886    * given investment asset at a given exchange rate.
6887    */
6888   function _checkTradeConditions(
6889     bytes4 curr,
6890     uint64 iaRate,
6891     uint totalRiskBal
6892   )
6893   internal
6894   view
6895   returns (bool check)
6896   {
6897     if (iaRate > 0) {
6898       uint iaBalance = _getInvestmentAssetBalance(curr).div(DECIMAL1E18);
6899       if (iaBalance > 0 && totalRiskBal > 0) {
6900         uint iaMax;
6901         uint iaMin;
6902         uint checkNumber;
6903         uint z;
6904         (iaMin, iaMax) = pd.getInvestmentAssetHoldingPerc(curr);
6905         z = pd.variationPercX100();
6906         checkNumber = (iaBalance.mul(100 * 100000)).div(totalRiskBal.mul(iaRate));
6907         if ((checkNumber > ((totalRiskBal.mul(iaMax.add(z))).mul(100000)).div(100)) ||
6908           (checkNumber < ((totalRiskBal.mul(iaMin.sub(z))).mul(100000)).div(100)))
6909           check = true; // eligibleIA
6910       }
6911     }
6912   }
6913 
6914   /**
6915    * @dev Gets the investment asset rank.
6916    */
6917   function _getIARank(
6918     bytes4 curr,
6919     uint64 rateX100,
6920     uint totalRiskPoolBalance
6921   )
6922   internal
6923   view
6924   returns (int rhsh, int rhsl) //internal function
6925   {
6926 
6927     uint currentIAmaxHolding;
6928     uint currentIAminHolding;
6929     uint iaBalance = _getInvestmentAssetBalance(curr);
6930     (currentIAminHolding, currentIAmaxHolding) = pd.getInvestmentAssetHoldingPerc(curr);
6931 
6932     if (rateX100 > 0) {
6933       uint rhsf;
6934       rhsf = (iaBalance.mul(1000000)).div(totalRiskPoolBalance.mul(rateX100));
6935       rhsh = int(rhsf - currentIAmaxHolding);
6936       rhsl = int(rhsf - currentIAminHolding);
6937     }
6938   }
6939 
6940   /**
6941    * @dev Calculates the investment asset rank.
6942    */
6943   function _calculateIARank(
6944     bytes4[] memory curr,
6945     uint64[] memory rate
6946   )
6947   internal
6948   view
6949   returns (
6950     bytes4 maxCurr,
6951     uint64 maxRate,
6952     bytes4 minCurr,
6953     uint64 minRate
6954   )
6955   {
6956     int max = 0;
6957     int min = - 1;
6958     int rhsh;
6959     int rhsl;
6960     uint totalRiskPoolBalance;
6961     (totalRiskPoolBalance,) = m1.calVtpAndMCRtp();
6962     uint len = curr.length;
6963     for (uint i = 0; i < len; i++) {
6964       rhsl = 0;
6965       rhsh = 0;
6966       if (pd.getInvestmentAssetStatus(curr[i])) {
6967         (rhsh, rhsl) = _getIARank(curr[i], rate[i], totalRiskPoolBalance);
6968         if (rhsh > max || i == 0) {
6969           max = rhsh;
6970           maxCurr = curr[i];
6971           maxRate = rate[i];
6972         }
6973         if (rhsl < min || rhsl == 0 || i == 0) {
6974           min = rhsl;
6975           minCurr = curr[i];
6976           minRate = rate[i];
6977         }
6978       }
6979     }
6980   }
6981 
6982   /**
6983    * @dev to get balance of an investment asset
6984    * @param _curr is the investment asset in concern
6985    * @return the balance
6986    */
6987   function _getInvestmentAssetBalance(bytes4 _curr) internal view returns (uint balance) {
6988     if (_curr == "ETH") {
6989       balance = address(this).balance;
6990     } else {
6991       IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
6992       balance = erc20.balanceOf(address(this));
6993     }
6994   }
6995 
6996   /**
6997    * @dev Creates Excess liquidity trading order for a given currency and a given balance.
6998    */
6999   function _internalExcessLiquiditySwap(bytes4 _curr, uint _baseMin, uint _varMin, uint _caBalance) internal {
7000     // require(ms.isInternal(msg.sender) || md.isnotarise(msg.sender));
7001     bytes4 minIACurr;
7002     // uint amount;
7003 
7004     (,, minIACurr,) = pd.getIARankDetailsByDate(pd.getLastDate());
7005     if (_curr == minIACurr) {
7006       // amount = _caBalance.sub(((_baseMin.add(_varMin)).mul(3)).div(2)); //*10**18;
7007       p1.transferCurrencyAsset(_curr, _caBalance.sub(((_baseMin.add(_varMin)).mul(3)).div(2)));
7008     } else {
7009       p1.triggerExternalLiquidityTrade();
7010     }
7011   }
7012 
7013   /**
7014    * @dev insufficient liquidity swap
7015    * for a given currency and a given balance.
7016    */
7017   function _internalInsufficientLiquiditySwap(bytes4 _curr, uint _baseMin, uint _varMin, uint _caBalance) internal {
7018 
7019     bytes4 maxIACurr;
7020     uint amount;
7021 
7022     (maxIACurr,,,) = pd.getIARankDetailsByDate(pd.getLastDate());
7023 
7024     if (_curr == maxIACurr) {
7025       amount = (((_baseMin.add(_varMin)).mul(3)).div(2)).sub(_caBalance);
7026       _transferInvestmentAsset(_curr, ms.getLatestAddress("P1"), amount);
7027     } else {
7028       IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(maxIACurr));
7029       if ((maxIACurr == "ETH" && address(this).balance > 0) ||
7030         (maxIACurr != "ETH" && erc20.balanceOf(address(this)) > 0))
7031         p1.triggerExternalLiquidityTrade();
7032 
7033     }
7034   }
7035 
7036   /**
7037    * @dev Creates External excess liquidity trading
7038    * order for a given currency and a given balance.
7039    * @param curr Currency Asset to Sell
7040    * @param minIACurr Investment Asset to Buy
7041    * @param amount Amount of Currency Asset to Sell
7042    */
7043   function _externalExcessLiquiditySwap(
7044     bytes4 curr,
7045     bytes4 minIACurr,
7046     uint256 amount
7047   )
7048   internal
7049   returns (bool trigger)
7050   {
7051     uint intermediaryEth;
7052     Exchange exchange;
7053     IERC20 erc20;
7054     uint ethVol = pd.ethVolumeLimit();
7055     if (curr == minIACurr) {
7056       p1.transferCurrencyAsset(curr, amount);
7057     } else if (curr == "ETH" && minIACurr != "ETH") {
7058 
7059       exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(minIACurr)));
7060       if (amount > (address(exchange).balance.mul(ethVol)).div(100)) {// 4% ETH volume limit
7061         amount = (address(exchange).balance.mul(ethVol)).div(100);
7062         trigger = true;
7063       }
7064       p1.transferCurrencyAsset(curr, amount);
7065       exchange.ethToTokenSwapInput.value(amount)
7066       (exchange.getEthToTokenInputPrice(amount).mul(995).div(1000), pd.uniswapDeadline().add(now));
7067     } else if (curr != "ETH" && minIACurr == "ETH") {
7068       exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7069       erc20 = IERC20(pd.getCurrencyAssetAddress(curr));
7070       intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7071 
7072       if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) {
7073         intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
7074         amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7075         intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7076         trigger = true;
7077       }
7078       p1.transferCurrencyAsset(curr, amount);
7079       // erc20.decreaseAllowance(address(exchange), erc20.allowance(address(this), address(exchange)));
7080       erc20.approve(address(exchange), amount);
7081 
7082       exchange.tokenToEthSwapInput(amount, (
7083       intermediaryEth.mul(995)).div(1000), pd.uniswapDeadline().add(now));
7084     } else {
7085 
7086       exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7087       intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7088 
7089       if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) {
7090         intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
7091         amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7092         trigger = true;
7093       }
7094 
7095       Exchange tmp = Exchange(factory.getExchange(
7096           pd.getInvestmentAssetAddress(minIACurr))); // minIACurr exchange
7097 
7098       if (intermediaryEth > address(tmp).balance.mul(ethVol).div(100)) {
7099         intermediaryEth = address(tmp).balance.mul(ethVol).div(100);
7100         amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7101         trigger = true;
7102       }
7103       p1.transferCurrencyAsset(curr, amount);
7104       erc20 = IERC20(pd.getCurrencyAssetAddress(curr));
7105       erc20.approve(address(exchange), amount);
7106 
7107       exchange.tokenToTokenSwapInput(amount, (tmp.getEthToTokenInputPrice(
7108         intermediaryEth).mul(995)).div(1000), (intermediaryEth.mul(995)).div(1000),
7109         pd.uniswapDeadline().add(now), pd.getInvestmentAssetAddress(minIACurr));
7110     }
7111   }
7112 
7113   /**
7114    * @dev insufficient liquidity swap
7115    * for a given currency and a given balance.
7116    * @param curr Currency Asset to buy
7117    * @param maxIACurr Investment Asset to sell
7118    * @param amount Amount of Investment Asset to sell
7119    */
7120   function _externalInsufficientLiquiditySwap(
7121     bytes4 curr,
7122     bytes4 maxIACurr,
7123     uint256 amount
7124   )
7125   internal
7126   returns (bool trigger)
7127   {
7128 
7129     Exchange exchange;
7130     IERC20 erc20;
7131     uint intermediaryEth;
7132     // uint ethVol = pd.ethVolumeLimit();
7133     if (curr == maxIACurr) {
7134       _transferInvestmentAsset(curr, ms.getLatestAddress("P1"), amount);
7135     } else if (curr == "ETH" && maxIACurr != "ETH") {
7136       exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(maxIACurr)));
7137       intermediaryEth = exchange.getEthToTokenInputPrice(amount);
7138 
7139 
7140       if (amount > (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100)) {
7141         amount = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7142         // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7143         intermediaryEth = exchange.getEthToTokenInputPrice(amount);
7144         trigger = true;
7145       }
7146 
7147       erc20 = IERC20(pd.getCurrencyAssetAddress(maxIACurr));
7148       if (intermediaryEth > erc20.balanceOf(address(this))) {
7149         intermediaryEth = erc20.balanceOf(address(this));
7150       }
7151       // erc20.decreaseAllowance(address(exchange), erc20.allowance(address(this), address(exchange)));
7152       erc20.approve(address(exchange), intermediaryEth);
7153       exchange.tokenToEthTransferInput(intermediaryEth, (
7154       exchange.getTokenToEthInputPrice(intermediaryEth).mul(995)).div(1000),
7155         pd.uniswapDeadline().add(now), address(p1));
7156 
7157     } else if (curr != "ETH" && maxIACurr == "ETH") {
7158       exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7159       intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7160       if (intermediaryEth > address(this).balance)
7161         intermediaryEth = address(this).balance;
7162       if (intermediaryEth > (address(exchange).balance.mul
7163       (pd.ethVolumeLimit())).div(100)) {// 4% ETH volume limit
7164         intermediaryEth = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7165         trigger = true;
7166       }
7167       exchange.ethToTokenTransferInput.value(intermediaryEth)((exchange.getEthToTokenInputPrice(
7168         intermediaryEth).mul(995)).div(1000), pd.uniswapDeadline().add(now), address(p1));
7169     } else {
7170       address currAdd = pd.getCurrencyAssetAddress(curr);
7171       exchange = Exchange(factory.getExchange(currAdd));
7172       intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7173       if (intermediaryEth > (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100)) {
7174         intermediaryEth = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7175         trigger = true;
7176       }
7177       Exchange tmp = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(maxIACurr)));
7178 
7179       if (intermediaryEth > address(tmp).balance.mul(pd.ethVolumeLimit()).div(100)) {
7180         intermediaryEth = address(tmp).balance.mul(pd.ethVolumeLimit()).div(100);
7181         // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7182         trigger = true;
7183       }
7184 
7185       uint maxIAToSell = tmp.getEthToTokenInputPrice(intermediaryEth);
7186 
7187       erc20 = IERC20(pd.getInvestmentAssetAddress(maxIACurr));
7188       uint maxIABal = erc20.balanceOf(address(this));
7189       if (maxIAToSell > maxIABal) {
7190         maxIAToSell = maxIABal;
7191         intermediaryEth = tmp.getTokenToEthInputPrice(maxIAToSell);
7192         // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7193       }
7194       amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7195       erc20.approve(address(tmp), maxIAToSell);
7196       tmp.tokenToTokenTransferInput(maxIAToSell, (
7197       amount.mul(995)).div(1000), (
7198         intermediaryEth), pd.uniswapDeadline().add(now), address(p1), currAdd);
7199     }
7200   }
7201 
7202   /**
7203    * @dev Transfers ERC20 investment asset from this Pool to another Pool.
7204    */
7205   function _upgradeInvestmentPool(
7206     bytes4 _curr,
7207     address _newPoolAddress
7208   )
7209   internal
7210   {
7211     IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
7212     if (erc20.balanceOf(address(this)) > 0)
7213       require(erc20.transfer(_newPoolAddress, erc20.balanceOf(address(this))));
7214   }
7215 }
7216 
7217 // File: contracts/modules/claims/ClaimsData.sol
7218 
7219 /* Copyright (C) 2020 NexusMutual.io
7220 
7221   This program is free software: you can redistribute it and/or modify
7222     it under the terms of the GNU General Public License as published by
7223     the Free Software Foundation, either version 3 of the License, or
7224     (at your option) any later version.
7225 
7226   This program is distributed in the hope that it will be useful,
7227     but WITHOUT ANY WARRANTY; without even the implied warranty of
7228     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
7229     GNU General Public License for more details.
7230 
7231   You should have received a copy of the GNU General Public License
7232     along with this program.  If not, see http://www.gnu.org/licenses/ */
7233 
7234 pragma solidity ^0.5.0;
7235 
7236 
7237 
7238 contract ClaimsData is Iupgradable {
7239   using SafeMath for uint;
7240 
7241   struct Claim {
7242     uint coverId;
7243     uint dateUpd;
7244   }
7245 
7246   struct Vote {
7247     address voter;
7248     uint tokens;
7249     uint claimId;
7250     int8 verdict;
7251     bool rewardClaimed;
7252   }
7253 
7254   struct ClaimsPause {
7255     uint coverid;
7256     uint dateUpd;
7257     bool submit;
7258   }
7259 
7260   struct ClaimPauseVoting {
7261     uint claimid;
7262     uint pendingTime;
7263     bool voting;
7264   }
7265 
7266   struct RewardDistributed {
7267     uint lastCAvoteIndex;
7268     uint lastMVvoteIndex;
7269 
7270   }
7271 
7272   struct ClaimRewardDetails {
7273     uint percCA;
7274     uint percMV;
7275     uint tokenToBeDist;
7276 
7277   }
7278 
7279   struct ClaimTotalTokens {
7280     uint accept;
7281     uint deny;
7282   }
7283 
7284   struct ClaimRewardStatus {
7285     uint percCA;
7286     uint percMV;
7287   }
7288 
7289   ClaimRewardStatus[] internal rewardStatus;
7290 
7291   Claim[] internal allClaims;
7292   Vote[] internal allvotes;
7293   ClaimsPause[] internal claimPause;
7294   ClaimPauseVoting[] internal claimPauseVotingEP;
7295 
7296   mapping(address => RewardDistributed) internal voterVoteRewardReceived;
7297   mapping(uint => ClaimRewardDetails) internal claimRewardDetail;
7298   mapping(uint => ClaimTotalTokens) internal claimTokensCA;
7299   mapping(uint => ClaimTotalTokens) internal claimTokensMV;
7300   mapping(uint => int8) internal claimVote;
7301   mapping(uint => uint) internal claimsStatus;
7302   mapping(uint => uint) internal claimState12Count;
7303   mapping(uint => uint[]) internal claimVoteCA;
7304   mapping(uint => uint[]) internal claimVoteMember;
7305   mapping(address => uint[]) internal voteAddressCA;
7306   mapping(address => uint[]) internal voteAddressMember;
7307   mapping(address => uint[]) internal allClaimsByAddress;
7308   mapping(address => mapping(uint => uint)) internal userClaimVoteCA;
7309   mapping(address => mapping(uint => uint)) internal userClaimVoteMember;
7310   mapping(address => uint) public userClaimVotePausedOn;
7311 
7312   uint internal claimPauseLastsubmit;
7313   uint internal claimStartVotingFirstIndex;
7314   uint public pendingClaimStart;
7315   uint public claimDepositTime;
7316   uint public maxVotingTime;
7317   uint public minVotingTime;
7318   uint public payoutRetryTime;
7319   uint public claimRewardPerc;
7320   uint public minVoteThreshold;
7321   uint public maxVoteThreshold;
7322   uint public majorityConsensus;
7323   uint public pauseDaysCA;
7324 
7325   event ClaimRaise(
7326     uint indexed coverId,
7327     address indexed userAddress,
7328     uint claimId,
7329     uint dateSubmit
7330   );
7331 
7332   event VoteCast(
7333     address indexed userAddress,
7334     uint indexed claimId,
7335     bytes4 indexed typeOf,
7336     uint tokens,
7337     uint submitDate,
7338     int8 verdict
7339   );
7340 
7341   constructor() public {
7342     pendingClaimStart = 1;
7343     maxVotingTime = 48 * 1 hours;
7344     minVotingTime = 12 * 1 hours;
7345     payoutRetryTime = 24 * 1 hours;
7346     allvotes.push(Vote(address(0), 0, 0, 0, false));
7347     allClaims.push(Claim(0, 0));
7348     claimDepositTime = 7 days;
7349     claimRewardPerc = 20;
7350     minVoteThreshold = 5;
7351     maxVoteThreshold = 10;
7352     majorityConsensus = 70;
7353     pauseDaysCA = 3 days;
7354     _addRewardIncentive();
7355   }
7356 
7357   /**
7358    * @dev Updates the pending claim start variable,
7359    * the lowest claim id with a pending decision/payout.
7360    */
7361   function setpendingClaimStart(uint _start) external onlyInternal {
7362     require(pendingClaimStart <= _start);
7363     pendingClaimStart = _start;
7364   }
7365 
7366   /**
7367    * @dev Updates the max vote index for which claim assessor has received reward
7368    * @param _voter address of the voter.
7369    * @param caIndex last index till which reward was distributed for CA
7370    */
7371   function setRewardDistributedIndexCA(address _voter, uint caIndex) external onlyInternal {
7372     voterVoteRewardReceived[_voter].lastCAvoteIndex = caIndex;
7373 
7374   }
7375 
7376   /**
7377    * @dev Used to pause claim assessor activity for 3 days
7378    * @param user Member address whose claim voting ability needs to be paused
7379    */
7380   function setUserClaimVotePausedOn(address user) external {
7381     require(ms.checkIsAuthToGoverned(msg.sender));
7382     userClaimVotePausedOn[user] = now;
7383   }
7384 
7385   /**
7386    * @dev Updates the max vote index for which member has received reward
7387    * @param _voter address of the voter.
7388    * @param mvIndex last index till which reward was distributed for member
7389    */
7390   function setRewardDistributedIndexMV(address _voter, uint mvIndex) external onlyInternal {
7391 
7392     voterVoteRewardReceived[_voter].lastMVvoteIndex = mvIndex;
7393   }
7394 
7395   /**
7396    * @param claimid claim id.
7397    * @param percCA reward Percentage reward for claim assessor
7398    * @param percMV reward Percentage reward for members
7399    * @param tokens total tokens to be rewarded
7400    */
7401   function setClaimRewardDetail(
7402     uint claimid,
7403     uint percCA,
7404     uint percMV,
7405     uint tokens
7406   )
7407   external
7408   onlyInternal
7409   {
7410     claimRewardDetail[claimid].percCA = percCA;
7411     claimRewardDetail[claimid].percMV = percMV;
7412     claimRewardDetail[claimid].tokenToBeDist = tokens;
7413   }
7414 
7415   /**
7416    * @dev Sets the reward claim status against a vote id.
7417    * @param _voteid vote Id.
7418    * @param claimed true if reward for vote is claimed, else false.
7419    */
7420   function setRewardClaimed(uint _voteid, bool claimed) external onlyInternal {
7421     allvotes[_voteid].rewardClaimed = claimed;
7422   }
7423 
7424   /**
7425    * @dev Sets the final vote's result(either accepted or declined)of a claim.
7426    * @param _claimId Claim Id.
7427    * @param _verdict 1 if claim is accepted,-1 if declined.
7428    */
7429   function changeFinalVerdict(uint _claimId, int8 _verdict) external onlyInternal {
7430     claimVote[_claimId] = _verdict;
7431   }
7432 
7433   /**
7434    * @dev Creates a new claim.
7435    */
7436   function addClaim(
7437     uint _claimId,
7438     uint _coverId,
7439     address _from,
7440     uint _nowtime
7441   )
7442   external
7443   onlyInternal
7444   {
7445     allClaims.push(Claim(_coverId, _nowtime));
7446     allClaimsByAddress[_from].push(_claimId);
7447   }
7448 
7449   /**
7450    * @dev Add Vote's details of a given claim.
7451    */
7452   function addVote(
7453     address _voter,
7454     uint _tokens,
7455     uint claimId,
7456     int8 _verdict
7457   )
7458   external
7459   onlyInternal
7460   {
7461     allvotes.push(Vote(_voter, _tokens, claimId, _verdict, false));
7462   }
7463 
7464   /**
7465    * @dev Stores the id of the claim assessor vote given to a claim.
7466    * Maintains record of all votes given by all the CA to a claim.
7467    * @param _claimId Claim Id to which vote has given by the CA.
7468    * @param _voteid Vote Id.
7469    */
7470   function addClaimVoteCA(uint _claimId, uint _voteid) external onlyInternal {
7471     claimVoteCA[_claimId].push(_voteid);
7472   }
7473 
7474   /**
7475    * @dev Sets the id of the vote.
7476    * @param _from Claim assessor's address who has given the vote.
7477    * @param _claimId Claim Id for which vote has been given by the CA.
7478    * @param _voteid Vote Id which will be stored against the given _from and claimid.
7479    */
7480   function setUserClaimVoteCA(
7481     address _from,
7482     uint _claimId,
7483     uint _voteid
7484   )
7485   external
7486   onlyInternal
7487   {
7488     userClaimVoteCA[_from][_claimId] = _voteid;
7489     voteAddressCA[_from].push(_voteid);
7490   }
7491 
7492   /**
7493    * @dev Stores the tokens locked by the Claim Assessors during voting of a given claim.
7494    * @param _claimId Claim Id.
7495    * @param _vote 1 for accept and increases the tokens of claim as accept,
7496    * -1 for deny and increases the tokens of claim as deny.
7497    * @param _tokens Number of tokens.
7498    */
7499   function setClaimTokensCA(uint _claimId, int8 _vote, uint _tokens) external onlyInternal {
7500     if (_vote == 1)
7501       claimTokensCA[_claimId].accept = claimTokensCA[_claimId].accept.add(_tokens);
7502     if (_vote == - 1)
7503       claimTokensCA[_claimId].deny = claimTokensCA[_claimId].deny.add(_tokens);
7504   }
7505 
7506   /**
7507    * @dev Stores the tokens locked by the Members during voting of a given claim.
7508    * @param _claimId Claim Id.
7509    * @param _vote 1 for accept and increases the tokens of claim as accept,
7510    * -1 for deny and increases the tokens of claim as deny.
7511    * @param _tokens Number of tokens.
7512    */
7513   function setClaimTokensMV(uint _claimId, int8 _vote, uint _tokens) external onlyInternal {
7514     if (_vote == 1)
7515       claimTokensMV[_claimId].accept = claimTokensMV[_claimId].accept.add(_tokens);
7516     if (_vote == - 1)
7517       claimTokensMV[_claimId].deny = claimTokensMV[_claimId].deny.add(_tokens);
7518   }
7519 
7520   /**
7521    * @dev Stores the id of the member vote given to a claim.
7522    * Maintains record of all votes given by all the Members to a claim.
7523    * @param _claimId Claim Id to which vote has been given by the Member.
7524    * @param _voteid Vote Id.
7525    */
7526   function addClaimVotemember(uint _claimId, uint _voteid) external onlyInternal {
7527     claimVoteMember[_claimId].push(_voteid);
7528   }
7529 
7530   /**
7531    * @dev Sets the id of the vote.
7532    * @param _from Member's address who has given the vote.
7533    * @param _claimId Claim Id for which vote has been given by the Member.
7534    * @param _voteid Vote Id which will be stored against the given _from and claimid.
7535    */
7536   function setUserClaimVoteMember(
7537     address _from,
7538     uint _claimId,
7539     uint _voteid
7540   )
7541   external
7542   onlyInternal
7543   {
7544     userClaimVoteMember[_from][_claimId] = _voteid;
7545     voteAddressMember[_from].push(_voteid);
7546 
7547   }
7548 
7549   /**
7550    * @dev Increases the count of failure until payout of a claim is successful.
7551    */
7552   function updateState12Count(uint _claimId, uint _cnt) external onlyInternal {
7553     claimState12Count[_claimId] = claimState12Count[_claimId].add(_cnt);
7554   }
7555 
7556   /**
7557    * @dev Sets status of a claim.
7558    * @param _claimId Claim Id.
7559    * @param _stat Status number.
7560    */
7561   function setClaimStatus(uint _claimId, uint _stat) external onlyInternal {
7562     claimsStatus[_claimId] = _stat;
7563   }
7564 
7565   /**
7566    * @dev Sets the timestamp of a given claim at which the Claim's details has been updated.
7567    * @param _claimId Claim Id of claim which has been changed.
7568    * @param _dateUpd timestamp at which claim is updated.
7569    */
7570   function setClaimdateUpd(uint _claimId, uint _dateUpd) external onlyInternal {
7571     allClaims[_claimId].dateUpd = _dateUpd;
7572   }
7573 
7574   /**
7575    @dev Queues Claims during Emergency Pause.
7576    */
7577   function setClaimAtEmergencyPause(
7578     uint _coverId,
7579     uint _dateUpd,
7580     bool _submit
7581   )
7582   external
7583   onlyInternal
7584   {
7585     claimPause.push(ClaimsPause(_coverId, _dateUpd, _submit));
7586   }
7587 
7588   /**
7589    * @dev Set submission flag for Claims queued during emergency pause.
7590    * Set to true after EP is turned off and the claim is submitted .
7591    */
7592   function setClaimSubmittedAtEPTrue(uint _index, bool _submit) external onlyInternal {
7593     claimPause[_index].submit = _submit;
7594   }
7595 
7596   /**
7597    * @dev Sets the index from which claim needs to be
7598    * submitted when emergency pause is swithched off.
7599    */
7600   function setFirstClaimIndexToSubmitAfterEP(
7601     uint _firstClaimIndexToSubmit
7602   )
7603   external
7604   onlyInternal
7605   {
7606     claimPauseLastsubmit = _firstClaimIndexToSubmit;
7607   }
7608 
7609   /**
7610    * @dev Sets the pending vote duration for a claim in case of emergency pause.
7611    */
7612   function setPendingClaimDetails(
7613     uint _claimId,
7614     uint _pendingTime,
7615     bool _voting
7616   )
7617   external
7618   onlyInternal
7619   {
7620     claimPauseVotingEP.push(ClaimPauseVoting(_claimId, _pendingTime, _voting));
7621   }
7622 
7623   /**
7624    * @dev Sets voting flag true after claim is reopened for voting after emergency pause.
7625    */
7626   function setPendingClaimVoteStatus(uint _claimId, bool _vote) external onlyInternal {
7627     claimPauseVotingEP[_claimId].voting = _vote;
7628   }
7629 
7630   /**
7631    * @dev Sets the index from which claim needs to be
7632    * reopened when emergency pause is swithched off.
7633    */
7634   function setFirstClaimIndexToStartVotingAfterEP(
7635     uint _claimStartVotingFirstIndex
7636   )
7637   external
7638   onlyInternal
7639   {
7640     claimStartVotingFirstIndex = _claimStartVotingFirstIndex;
7641   }
7642 
7643   /**
7644    * @dev Calls Vote Event.
7645    */
7646   function callVoteEvent(
7647     address _userAddress,
7648     uint _claimId,
7649     bytes4 _typeOf,
7650     uint _tokens,
7651     uint _submitDate,
7652     int8 _verdict
7653   )
7654   external
7655   onlyInternal
7656   {
7657     emit VoteCast(
7658       _userAddress,
7659       _claimId,
7660       _typeOf,
7661       _tokens,
7662       _submitDate,
7663       _verdict
7664     );
7665   }
7666 
7667   /**
7668    * @dev Calls Claim Event.
7669    */
7670   function callClaimEvent(
7671     uint _coverId,
7672     address _userAddress,
7673     uint _claimId,
7674     uint _datesubmit
7675   )
7676   external
7677   onlyInternal
7678   {
7679     emit ClaimRaise(_coverId, _userAddress, _claimId, _datesubmit);
7680   }
7681 
7682   /**
7683    * @dev Gets Uint Parameters by parameter code
7684    * @param code whose details we want
7685    * @return string value of the parameter
7686    * @return associated amount (time or perc or value) to the code
7687    */
7688   function getUintParameters(bytes8 code) external view returns (bytes8 codeVal, uint val) {
7689     codeVal = code;
7690     if (code == "CAMAXVT") {
7691       val = maxVotingTime / (1 hours);
7692 
7693     } else if (code == "CAMINVT") {
7694 
7695       val = minVotingTime / (1 hours);
7696 
7697     } else if (code == "CAPRETRY") {
7698 
7699       val = payoutRetryTime / (1 hours);
7700 
7701     } else if (code == "CADEPT") {
7702 
7703       val = claimDepositTime / (1 days);
7704 
7705     } else if (code == "CAREWPER") {
7706 
7707       val = claimRewardPerc;
7708 
7709     } else if (code == "CAMINTH") {
7710 
7711       val = minVoteThreshold;
7712 
7713     } else if (code == "CAMAXTH") {
7714 
7715       val = maxVoteThreshold;
7716 
7717     } else if (code == "CACONPER") {
7718 
7719       val = majorityConsensus;
7720 
7721     } else if (code == "CAPAUSET") {
7722       val = pauseDaysCA / (1 days);
7723     }
7724 
7725   }
7726 
7727   /**
7728    * @dev Get claim queued during emergency pause by index.
7729    */
7730   function getClaimOfEmergencyPauseByIndex(
7731     uint _index
7732   )
7733   external
7734   view
7735   returns (
7736     uint coverId,
7737     uint dateUpd,
7738     bool submit
7739   )
7740   {
7741     coverId = claimPause[_index].coverid;
7742     dateUpd = claimPause[_index].dateUpd;
7743     submit = claimPause[_index].submit;
7744   }
7745 
7746   /**
7747    * @dev Gets the Claim's details of given claimid.
7748    */
7749   function getAllClaimsByIndex(
7750     uint _claimId
7751   )
7752   external
7753   view
7754   returns (
7755     uint coverId,
7756     int8 vote,
7757     uint status,
7758     uint dateUpd,
7759     uint state12Count
7760   )
7761   {
7762     return (
7763     allClaims[_claimId].coverId,
7764     claimVote[_claimId],
7765     claimsStatus[_claimId],
7766     allClaims[_claimId].dateUpd,
7767     claimState12Count[_claimId]
7768     );
7769   }
7770 
7771   /**
7772    * @dev Gets the vote id of a given claim of a given Claim Assessor.
7773    */
7774   function getUserClaimVoteCA(
7775     address _add,
7776     uint _claimId
7777   )
7778   external
7779   view
7780   returns (uint idVote)
7781   {
7782     return userClaimVoteCA[_add][_claimId];
7783   }
7784 
7785   /**
7786    * @dev Gets the vote id of a given claim of a given member.
7787    */
7788   function getUserClaimVoteMember(
7789     address _add,
7790     uint _claimId
7791   )
7792   external
7793   view
7794   returns (uint idVote)
7795   {
7796     return userClaimVoteMember[_add][_claimId];
7797   }
7798 
7799   /**
7800    * @dev Gets the count of all votes.
7801    */
7802   function getAllVoteLength() external view returns (uint voteCount) {
7803     return allvotes.length.sub(1); // Start Index always from 1.
7804   }
7805 
7806   /**
7807    * @dev Gets the status number of a given claim.
7808    * @param _claimId Claim id.
7809    * @return statno Status Number.
7810    */
7811   function getClaimStatusNumber(uint _claimId) external view returns (uint claimId, uint statno) {
7812     return (_claimId, claimsStatus[_claimId]);
7813   }
7814 
7815   /**
7816    * @dev Gets the reward percentage to be distributed for a given status id
7817    * @param statusNumber the number of type of status
7818    * @return percCA reward Percentage for claim assessor
7819    * @return percMV reward Percentage for members
7820    */
7821   function getRewardStatus(uint statusNumber) external view returns (uint percCA, uint percMV) {
7822     return (rewardStatus[statusNumber].percCA, rewardStatus[statusNumber].percMV);
7823   }
7824 
7825   /**
7826    * @dev Gets the number of tries that have been made for a successful payout of a Claim.
7827    */
7828   function getClaimState12Count(uint _claimId) external view returns (uint num) {
7829     num = claimState12Count[_claimId];
7830   }
7831 
7832   /**
7833    * @dev Gets the last update date of a claim.
7834    */
7835   function getClaimDateUpd(uint _claimId) external view returns (uint dateupd) {
7836     dateupd = allClaims[_claimId].dateUpd;
7837   }
7838 
7839   /**
7840    * @dev Gets all Claims created by a user till date.
7841    * @param _member user's address.
7842    * @return claimarr List of Claims id.
7843    */
7844   function getAllClaimsByAddress(address _member) external view returns (uint[] memory claimarr) {
7845     return allClaimsByAddress[_member];
7846   }
7847 
7848   /**
7849    * @dev Gets the number of tokens that has been locked
7850    * while giving vote to a claim by  Claim Assessors.
7851    * @param _claimId Claim Id.
7852    * @return accept Total number of tokens when CA accepts the claim.
7853    * @return deny Total number of tokens when CA declines the claim.
7854    */
7855   function getClaimsTokenCA(
7856     uint _claimId
7857   )
7858   external
7859   view
7860   returns (
7861     uint claimId,
7862     uint accept,
7863     uint deny
7864   )
7865   {
7866     return (
7867     _claimId,
7868     claimTokensCA[_claimId].accept,
7869     claimTokensCA[_claimId].deny
7870     );
7871   }
7872 
7873   /**
7874    * @dev Gets the number of tokens that have been
7875    * locked while assessing a claim as a member.
7876    * @param _claimId Claim Id.
7877    * @return accept Total number of tokens in acceptance of the claim.
7878    * @return deny Total number of tokens against the claim.
7879    */
7880   function getClaimsTokenMV(
7881     uint _claimId
7882   )
7883   external
7884   view
7885   returns (
7886     uint claimId,
7887     uint accept,
7888     uint deny
7889   )
7890   {
7891     return (
7892     _claimId,
7893     claimTokensMV[_claimId].accept,
7894     claimTokensMV[_claimId].deny
7895     );
7896   }
7897 
7898   /**
7899    * @dev Gets the total number of votes cast as Claims assessor for/against a given claim
7900    */
7901   function getCaClaimVotesToken(uint _claimId) external view returns (uint claimId, uint cnt) {
7902     claimId = _claimId;
7903     cnt = 0;
7904     for (uint i = 0; i < claimVoteCA[_claimId].length; i++) {
7905       cnt = cnt.add(allvotes[claimVoteCA[_claimId][i]].tokens);
7906     }
7907   }
7908 
7909   /**
7910    * @dev Gets the total number of tokens cast as a member for/against a given claim
7911    */
7912   function getMemberClaimVotesToken(
7913     uint _claimId
7914   )
7915   external
7916   view
7917   returns (uint claimId, uint cnt)
7918   {
7919     claimId = _claimId;
7920     cnt = 0;
7921     for (uint i = 0; i < claimVoteMember[_claimId].length; i++) {
7922       cnt = cnt.add(allvotes[claimVoteMember[_claimId][i]].tokens);
7923     }
7924   }
7925 
7926   /**
7927    * @dev Provides information of a vote when given its vote id.
7928    * @param _voteid Vote Id.
7929    */
7930   function getVoteDetails(uint _voteid)
7931   external view
7932   returns (
7933     uint tokens,
7934     uint claimId,
7935     int8 verdict,
7936     bool rewardClaimed
7937   )
7938   {
7939     return (
7940     allvotes[_voteid].tokens,
7941     allvotes[_voteid].claimId,
7942     allvotes[_voteid].verdict,
7943     allvotes[_voteid].rewardClaimed
7944     );
7945   }
7946 
7947   /**
7948    * @dev Gets the voter's address of a given vote id.
7949    */
7950   function getVoterVote(uint _voteid) external view returns (address voter) {
7951     return allvotes[_voteid].voter;
7952   }
7953 
7954   /**
7955    * @dev Provides information of a Claim when given its claim id.
7956    * @param _claimId Claim Id.
7957    */
7958   function getClaim(
7959     uint _claimId
7960   )
7961   external
7962   view
7963   returns (
7964     uint claimId,
7965     uint coverId,
7966     int8 vote,
7967     uint status,
7968     uint dateUpd,
7969     uint state12Count
7970   )
7971   {
7972     return (
7973     _claimId,
7974     allClaims[_claimId].coverId,
7975     claimVote[_claimId],
7976     claimsStatus[_claimId],
7977     allClaims[_claimId].dateUpd,
7978     claimState12Count[_claimId]
7979     );
7980   }
7981 
7982   /**
7983    * @dev Gets the total number of votes of a given claim.
7984    * @param _claimId Claim Id.
7985    * @param _ca if 1: votes given by Claim Assessors to a claim,
7986    * else returns the number of votes of given by Members to a claim.
7987    * @return len total number of votes for/against a given claim.
7988    */
7989   function getClaimVoteLength(
7990     uint _claimId,
7991     uint8 _ca
7992   )
7993   external
7994   view
7995   returns (uint claimId, uint len)
7996   {
7997     claimId = _claimId;
7998     if (_ca == 1)
7999       len = claimVoteCA[_claimId].length;
8000     else
8001       len = claimVoteMember[_claimId].length;
8002   }
8003 
8004   /**
8005    * @dev Gets the verdict of a vote using claim id and index.
8006    * @param _ca 1 for vote given as a CA, else for vote given as a member.
8007    * @return ver 1 if vote was given in favour,-1 if given in against.
8008    */
8009   function getVoteVerdict(
8010     uint _claimId,
8011     uint _index,
8012     uint8 _ca
8013   )
8014   external
8015   view
8016   returns (int8 ver)
8017   {
8018     if (_ca == 1)
8019       ver = allvotes[claimVoteCA[_claimId][_index]].verdict;
8020     else
8021       ver = allvotes[claimVoteMember[_claimId][_index]].verdict;
8022   }
8023 
8024   /**
8025    * @dev Gets the Number of tokens of a vote using claim id and index.
8026    * @param _ca 1 for vote given as a CA, else for vote given as a member.
8027    * @return tok Number of tokens.
8028    */
8029   function getVoteToken(
8030     uint _claimId,
8031     uint _index,
8032     uint8 _ca
8033   )
8034   external
8035   view
8036   returns (uint tok)
8037   {
8038     if (_ca == 1)
8039       tok = allvotes[claimVoteCA[_claimId][_index]].tokens;
8040     else
8041       tok = allvotes[claimVoteMember[_claimId][_index]].tokens;
8042   }
8043 
8044   /**
8045    * @dev Gets the Voter's address of a vote using claim id and index.
8046    * @param _ca 1 for vote given as a CA, else for vote given as a member.
8047    * @return voter Voter's address.
8048    */
8049   function getVoteVoter(
8050     uint _claimId,
8051     uint _index,
8052     uint8 _ca
8053   )
8054   external
8055   view
8056   returns (address voter)
8057   {
8058     if (_ca == 1)
8059       voter = allvotes[claimVoteCA[_claimId][_index]].voter;
8060     else
8061       voter = allvotes[claimVoteMember[_claimId][_index]].voter;
8062   }
8063 
8064   /**
8065    * @dev Gets total number of Claims created by a user till date.
8066    * @param _add User's address.
8067    */
8068   function getUserClaimCount(address _add) external view returns (uint len) {
8069     len = allClaimsByAddress[_add].length;
8070   }
8071 
8072   /**
8073    * @dev Calculates number of Claims that are in pending state.
8074    */
8075   function getClaimLength() external view returns (uint len) {
8076     len = allClaims.length.sub(pendingClaimStart);
8077   }
8078 
8079   /**
8080    * @dev Gets the Number of all the Claims created till date.
8081    */
8082   function actualClaimLength() external view returns (uint len) {
8083     len = allClaims.length;
8084   }
8085 
8086   /**
8087    * @dev Gets details of a claim.
8088    * @param _index claim id = pending claim start + given index
8089    * @param _add User's address.
8090    * @return coverid cover against which claim has been submitted.
8091    * @return claimId Claim  Id.
8092    * @return voteCA verdict of vote given as a Claim Assessor.
8093    * @return voteMV verdict of vote given as a Member.
8094    * @return statusnumber Status of claim.
8095    */
8096   function getClaimFromNewStart(
8097     uint _index,
8098     address _add
8099   )
8100   external
8101   view
8102   returns (
8103     uint coverid,
8104     uint claimId,
8105     int8 voteCA,
8106     int8 voteMV,
8107     uint statusnumber
8108   )
8109   {
8110     uint i = pendingClaimStart.add(_index);
8111     coverid = allClaims[i].coverId;
8112     claimId = i;
8113     if (userClaimVoteCA[_add][i] > 0)
8114       voteCA = allvotes[userClaimVoteCA[_add][i]].verdict;
8115     else
8116       voteCA = 0;
8117 
8118     if (userClaimVoteMember[_add][i] > 0)
8119       voteMV = allvotes[userClaimVoteMember[_add][i]].verdict;
8120     else
8121       voteMV = 0;
8122 
8123     statusnumber = claimsStatus[i];
8124   }
8125 
8126   /**
8127    * @dev Gets details of a claim of a user at a given index.
8128    */
8129   function getUserClaimByIndex(
8130     uint _index,
8131     address _add
8132   )
8133   external
8134   view
8135   returns (
8136     uint status,
8137     uint coverid,
8138     uint claimId
8139   )
8140   {
8141     claimId = allClaimsByAddress[_add][_index];
8142     status = claimsStatus[claimId];
8143     coverid = allClaims[claimId].coverId;
8144   }
8145 
8146   /**
8147    * @dev Gets Id of all the votes given to a claim.
8148    * @param _claimId Claim Id.
8149    * @return ca id of all the votes given by Claim assessors to a claim.
8150    * @return mv id of all the votes given by members to a claim.
8151    */
8152   function getAllVotesForClaim(
8153     uint _claimId
8154   )
8155   external
8156   view
8157   returns (
8158     uint claimId,
8159     uint[] memory ca,
8160     uint[] memory mv
8161   )
8162   {
8163     return (_claimId, claimVoteCA[_claimId], claimVoteMember[_claimId]);
8164   }
8165 
8166   /**
8167    * @dev Gets Number of tokens deposit in a vote using
8168    * Claim assessor's address and claim id.
8169    * @return tokens Number of deposited tokens.
8170    */
8171   function getTokensClaim(
8172     address _of,
8173     uint _claimId
8174   )
8175   external
8176   view
8177   returns (
8178     uint claimId,
8179     uint tokens
8180   )
8181   {
8182     return (_claimId, allvotes[userClaimVoteCA[_of][_claimId]].tokens);
8183   }
8184 
8185   /**
8186    * @param _voter address of the voter.
8187    * @return lastCAvoteIndex last index till which reward was distributed for CA
8188    * @return lastMVvoteIndex last index till which reward was distributed for member
8189    */
8190   function getRewardDistributedIndex(
8191     address _voter
8192   )
8193   external
8194   view
8195   returns (
8196     uint lastCAvoteIndex,
8197     uint lastMVvoteIndex
8198   )
8199   {
8200     return (
8201     voterVoteRewardReceived[_voter].lastCAvoteIndex,
8202     voterVoteRewardReceived[_voter].lastMVvoteIndex
8203     );
8204   }
8205 
8206   /**
8207    * @param claimid claim id.
8208    * @return perc_CA reward Percentage for claim assessor
8209    * @return perc_MV reward Percentage for members
8210    * @return tokens total tokens to be rewarded
8211    */
8212   function getClaimRewardDetail(
8213     uint claimid
8214   )
8215   external
8216   view
8217   returns (
8218     uint percCA,
8219     uint percMV,
8220     uint tokens
8221   )
8222   {
8223     return (
8224     claimRewardDetail[claimid].percCA,
8225     claimRewardDetail[claimid].percMV,
8226     claimRewardDetail[claimid].tokenToBeDist
8227     );
8228   }
8229 
8230   /**
8231    * @dev Gets cover id of a claim.
8232    */
8233   function getClaimCoverId(uint _claimId) external view returns (uint claimId, uint coverid) {
8234     return (_claimId, allClaims[_claimId].coverId);
8235   }
8236 
8237   /**
8238    * @dev Gets total number of tokens staked during voting by Claim Assessors.
8239    * @param _claimId Claim Id.
8240    * @param _verdict 1 to get total number of accept tokens, -1 to get total number of deny tokens.
8241    * @return token token Number of tokens(either accept or deny on the basis of verdict given as parameter).
8242    */
8243   function getClaimVote(uint _claimId, int8 _verdict) external view returns (uint claimId, uint token) {
8244     claimId = _claimId;
8245     token = 0;
8246     for (uint i = 0; i < claimVoteCA[_claimId].length; i++) {
8247       if (allvotes[claimVoteCA[_claimId][i]].verdict == _verdict)
8248         token = token.add(allvotes[claimVoteCA[_claimId][i]].tokens);
8249     }
8250   }
8251 
8252   /**
8253    * @dev Gets total number of tokens staked during voting by Members.
8254    * @param _claimId Claim Id.
8255    * @param _verdict 1 to get total number of accept tokens,
8256    *  -1 to get total number of deny tokens.
8257    * @return token token Number of tokens(either accept or
8258    * deny on the basis of verdict given as parameter).
8259    */
8260   function getClaimMVote(uint _claimId, int8 _verdict) external view returns (uint claimId, uint token) {
8261     claimId = _claimId;
8262     token = 0;
8263     for (uint i = 0; i < claimVoteMember[_claimId].length; i++) {
8264       if (allvotes[claimVoteMember[_claimId][i]].verdict == _verdict)
8265         token = token.add(allvotes[claimVoteMember[_claimId][i]].tokens);
8266     }
8267   }
8268 
8269   /**
8270    * @param _voter address  of voteid
8271    * @param index index to get voteid in CA
8272    */
8273   function getVoteAddressCA(address _voter, uint index) external view returns (uint) {
8274     return voteAddressCA[_voter][index];
8275   }
8276 
8277   /**
8278    * @param _voter address  of voter
8279    * @param index index to get voteid in member vote
8280    */
8281   function getVoteAddressMember(address _voter, uint index) external view returns (uint) {
8282     return voteAddressMember[_voter][index];
8283   }
8284 
8285   /**
8286    * @param _voter address  of voter
8287    */
8288   function getVoteAddressCALength(address _voter) external view returns (uint) {
8289     return voteAddressCA[_voter].length;
8290   }
8291 
8292   /**
8293    * @param _voter address  of voter
8294    */
8295   function getVoteAddressMemberLength(address _voter) external view returns (uint) {
8296     return voteAddressMember[_voter].length;
8297   }
8298 
8299   /**
8300    * @dev Gets the Final result of voting of a claim.
8301    * @param _claimId Claim id.
8302    * @return verdict 1 if claim is accepted, -1 if declined.
8303    */
8304   function getFinalVerdict(uint _claimId) external view returns (int8 verdict) {
8305     return claimVote[_claimId];
8306   }
8307 
8308   /**
8309    * @dev Get number of Claims queued for submission during emergency pause.
8310    */
8311   function getLengthOfClaimSubmittedAtEP() external view returns (uint len) {
8312     len = claimPause.length;
8313   }
8314 
8315   /**
8316    * @dev Gets the index from which claim needs to be
8317    * submitted when emergency pause is swithched off.
8318    */
8319   function getFirstClaimIndexToSubmitAfterEP() external view returns (uint indexToSubmit) {
8320     indexToSubmit = claimPauseLastsubmit;
8321   }
8322 
8323   /**
8324    * @dev Gets number of Claims to be reopened for voting post emergency pause period.
8325    */
8326   function getLengthOfClaimVotingPause() external view returns (uint len) {
8327     len = claimPauseVotingEP.length;
8328   }
8329 
8330   /**
8331    * @dev Gets claim details to be reopened for voting after emergency pause.
8332    */
8333   function getPendingClaimDetailsByIndex(
8334     uint _index
8335   )
8336   external
8337   view
8338   returns (
8339     uint claimId,
8340     uint pendingTime,
8341     bool voting
8342   )
8343   {
8344     claimId = claimPauseVotingEP[_index].claimid;
8345     pendingTime = claimPauseVotingEP[_index].pendingTime;
8346     voting = claimPauseVotingEP[_index].voting;
8347   }
8348 
8349   /**
8350    * @dev Gets the index from which claim needs to be reopened when emergency pause is swithched off.
8351    */
8352   function getFirstClaimIndexToStartVotingAfterEP() external view returns (uint firstindex) {
8353     firstindex = claimStartVotingFirstIndex;
8354   }
8355 
8356   /**
8357    * @dev Updates Uint Parameters of a code
8358    * @param code whose details we want to update
8359    * @param val value to set
8360    */
8361   function updateUintParameters(bytes8 code, uint val) public {
8362     require(ms.checkIsAuthToGoverned(msg.sender));
8363     if (code == "CAMAXVT") {
8364       _setMaxVotingTime(val * 1 hours);
8365 
8366     } else if (code == "CAMINVT") {
8367 
8368       _setMinVotingTime(val * 1 hours);
8369 
8370     } else if (code == "CAPRETRY") {
8371 
8372       _setPayoutRetryTime(val * 1 hours);
8373 
8374     } else if (code == "CADEPT") {
8375 
8376       _setClaimDepositTime(val * 1 days);
8377 
8378     } else if (code == "CAREWPER") {
8379 
8380       _setClaimRewardPerc(val);
8381 
8382     } else if (code == "CAMINTH") {
8383 
8384       _setMinVoteThreshold(val);
8385 
8386     } else if (code == "CAMAXTH") {
8387 
8388       _setMaxVoteThreshold(val);
8389 
8390     } else if (code == "CACONPER") {
8391 
8392       _setMajorityConsensus(val);
8393 
8394     } else if (code == "CAPAUSET") {
8395       _setPauseDaysCA(val * 1 days);
8396     } else {
8397 
8398       revert("Invalid param code");
8399     }
8400 
8401   }
8402 
8403   /**
8404    * @dev Iupgradable Interface to update dependent contract address
8405    */
8406   function changeDependentContractAddress() public onlyInternal {}
8407 
8408   /**
8409    * @dev Adds status under which a claim can lie.
8410    * @param percCA reward percentage for claim assessor
8411    * @param percMV reward percentage for members
8412    */
8413   function _pushStatus(uint percCA, uint percMV) internal {
8414     rewardStatus.push(ClaimRewardStatus(percCA, percMV));
8415   }
8416 
8417   /**
8418    * @dev adds reward incentive for all possible claim status for Claim assessors and members
8419    */
8420   function _addRewardIncentive() internal {
8421     _pushStatus(0, 0); // 0  Pending-Claim Assessor Vote
8422     _pushStatus(0, 0); // 1 Pending-Claim Assessor Vote Denied, Pending Member Vote
8423     _pushStatus(0, 0); // 2 Pending-CA Vote Threshold not Reached Accept, Pending Member Vote
8424     _pushStatus(0, 0); // 3 Pending-CA Vote Threshold not Reached Deny, Pending Member Vote
8425     _pushStatus(0, 0); // 4 Pending-CA Consensus not reached Accept, Pending Member Vote
8426     _pushStatus(0, 0); // 5 Pending-CA Consensus not reached Deny, Pending Member Vote
8427     _pushStatus(100, 0); // 6 Final-Claim Assessor Vote Denied
8428     _pushStatus(100, 0); // 7 Final-Claim Assessor Vote Accepted
8429     _pushStatus(0, 100); // 8 Final-Claim Assessor Vote Denied, MV Accepted
8430     _pushStatus(0, 100); // 9 Final-Claim Assessor Vote Denied, MV Denied
8431     _pushStatus(0, 0); // 10 Final-Claim Assessor Vote Accept, MV Nodecision
8432     _pushStatus(0, 0); // 11 Final-Claim Assessor Vote Denied, MV Nodecision
8433     _pushStatus(0, 0); // 12 Claim Accepted Payout Pending
8434     _pushStatus(0, 0); // 13 Claim Accepted No Payout
8435     _pushStatus(0, 0); // 14 Claim Accepted Payout Done
8436   }
8437 
8438   /**
8439    * @dev Sets Maximum time(in seconds) for which claim assessment voting is open
8440    */
8441   function _setMaxVotingTime(uint _time) internal {
8442     maxVotingTime = _time;
8443   }
8444 
8445   /**
8446    *  @dev Sets Minimum time(in seconds) for which claim assessment voting is open
8447    */
8448   function _setMinVotingTime(uint _time) internal {
8449     minVotingTime = _time;
8450   }
8451 
8452   /**
8453    *  @dev Sets Minimum vote threshold required
8454    */
8455   function _setMinVoteThreshold(uint val) internal {
8456     minVoteThreshold = val;
8457   }
8458 
8459   /**
8460    *  @dev Sets Maximum vote threshold required
8461    */
8462   function _setMaxVoteThreshold(uint val) internal {
8463     maxVoteThreshold = val;
8464   }
8465 
8466   /**
8467    *  @dev Sets the value considered as Majority Consenus in voting
8468    */
8469   function _setMajorityConsensus(uint val) internal {
8470     majorityConsensus = val;
8471   }
8472 
8473   /**
8474    * @dev Sets the payout retry time
8475    */
8476   function _setPayoutRetryTime(uint _time) internal {
8477     payoutRetryTime = _time;
8478   }
8479 
8480   /**
8481    *  @dev Sets percentage of reward given for claim assessment
8482    */
8483   function _setClaimRewardPerc(uint _val) internal {
8484 
8485     claimRewardPerc = _val;
8486   }
8487 
8488   /**
8489    * @dev Sets the time for which claim is deposited.
8490    */
8491   function _setClaimDepositTime(uint _time) internal {
8492 
8493     claimDepositTime = _time;
8494   }
8495 
8496   /**
8497    *  @dev Sets number of days claim assessment will be paused
8498    */
8499   function _setPauseDaysCA(uint val) internal {
8500     pauseDaysCA = val;
8501   }
8502 }
8503 
8504 // File: contracts/modules/claims/ClaimsReward.sol
8505 
8506 /* Copyright (C) 2020 NexusMutual.io
8507 
8508   This program is free software: you can redistribute it and/or modify
8509     it under the terms of the GNU General Public License as published by
8510     the Free Software Foundation, either version 3 of the License, or
8511     (at your option) any later version.
8512 
8513   This program is distributed in the hope that it will be useful,
8514     but WITHOUT ANY WARRANTY; without even the implied warranty of
8515     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
8516     GNU General Public License for more details.
8517 
8518   You should have received a copy of the GNU General Public License
8519     along with this program.  If not, see http://www.gnu.org/licenses/ */
8520 
8521 //Claims Reward Contract contains the functions for calculating number of tokens
8522 // that will get rewarded, unlocked or burned depending upon the status of claim.
8523 
8524 pragma solidity ^0.5.0;
8525 
8526 
8527 
8528 
8529 
8530 
8531 
8532 
8533 
8534 
8535 
8536 contract ClaimsReward is Iupgradable {
8537   using SafeMath for uint;
8538 
8539   NXMToken internal tk;
8540   TokenController internal tc;
8541   TokenFunctions internal tf;
8542   TokenData internal td;
8543   QuotationData internal qd;
8544   Claims internal c1;
8545   ClaimsData internal cd;
8546   Pool1 internal p1;
8547   Pool2 internal p2;
8548   PoolData internal pd;
8549   Governance internal gv;
8550   IPooledStaking internal pooledStaking;
8551   MemberRoles internal memberRoles;
8552 
8553   uint private constant DECIMAL1E18 = uint(10) ** 18;
8554 
8555   function changeDependentContractAddress() public onlyInternal {
8556     c1 = Claims(ms.getLatestAddress("CL"));
8557     cd = ClaimsData(ms.getLatestAddress("CD"));
8558     tk = NXMToken(ms.tokenAddress());
8559     tc = TokenController(ms.getLatestAddress("TC"));
8560     td = TokenData(ms.getLatestAddress("TD"));
8561     tf = TokenFunctions(ms.getLatestAddress("TF"));
8562     p1 = Pool1(ms.getLatestAddress("P1"));
8563     p2 = Pool2(ms.getLatestAddress("P2"));
8564     pd = PoolData(ms.getLatestAddress("PD"));
8565     qd = QuotationData(ms.getLatestAddress("QD"));
8566     gv = Governance(ms.getLatestAddress("GV"));
8567     pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
8568     memberRoles = MemberRoles(ms.getLatestAddress("MR"));
8569   }
8570 
8571   /// @dev Decides the next course of action for a given claim.
8572   function changeClaimStatus(uint claimid) public checkPause onlyInternal {
8573 
8574     uint coverid;
8575     (, coverid) = cd.getClaimCoverId(claimid);
8576 
8577     uint status;
8578     (, status) = cd.getClaimStatusNumber(claimid);
8579 
8580     // when current status is "Pending-Claim Assessor Vote"
8581     if (status == 0) {
8582       _changeClaimStatusCA(claimid, coverid, status);
8583     } else if (status >= 1 && status <= 5) {
8584       _changeClaimStatusMV(claimid, coverid, status);
8585     } else if (status == 12) {// when current status is "Claim Accepted Payout Pending"
8586 
8587       uint sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
8588       address payable coverHolder = qd.getCoverMemberAddress(coverid);
8589       bytes4 coverCurrency = qd.getCurrencyOfCover(coverid);
8590 
8591       address payable payoutAddress = memberRoles.getClaimPayoutAddress(coverHolder);
8592       bool success = p1.sendClaimPayout(coverid, claimid, sumAssured, payoutAddress, coverCurrency);
8593 
8594       if (success) {
8595         tf.burnStakedTokens(coverid, coverCurrency, sumAssured);
8596         c1.setClaimStatus(claimid, 14);
8597       }
8598     }
8599 
8600     c1.changePendingClaimStart();
8601   }
8602 
8603   /// @dev Amount of tokens to be rewarded to a user for a particular vote id.
8604   /// @param check 1 -> CA vote, else member vote
8605   /// @param voteid vote id for which reward has to be Calculated
8606   /// @param flag if 1 calculate even if claimed,else don't calculate if already claimed
8607   /// @return tokenCalculated reward to be given for vote id
8608   /// @return lastClaimedCheck true if final verdict is still pending for that voteid
8609   /// @return tokens number of tokens locked under that voteid
8610   /// @return perc percentage of reward to be given.
8611   function getRewardToBeGiven(
8612     uint check,
8613     uint voteid,
8614     uint flag
8615   )
8616   public
8617   view
8618   returns (
8619     uint tokenCalculated,
8620     bool lastClaimedCheck,
8621     uint tokens,
8622     uint perc
8623   )
8624 
8625   {
8626     uint claimId;
8627     int8 verdict;
8628     bool claimed;
8629     uint tokensToBeDist;
8630     uint totalTokens;
8631     (tokens, claimId, verdict, claimed) = cd.getVoteDetails(voteid);
8632     lastClaimedCheck = false;
8633     int8 claimVerdict = cd.getFinalVerdict(claimId);
8634     if (claimVerdict == 0) {
8635       lastClaimedCheck = true;
8636     }
8637 
8638     if (claimVerdict == verdict && (claimed == false || flag == 1)) {
8639 
8640       if (check == 1) {
8641         (perc, , tokensToBeDist) = cd.getClaimRewardDetail(claimId);
8642       } else {
8643         (, perc, tokensToBeDist) = cd.getClaimRewardDetail(claimId);
8644       }
8645 
8646       if (perc > 0) {
8647         if (check == 1) {
8648           if (verdict == 1) {
8649             (, totalTokens,) = cd.getClaimsTokenCA(claimId);
8650           } else {
8651             (,, totalTokens) = cd.getClaimsTokenCA(claimId);
8652           }
8653         } else {
8654           if (verdict == 1) {
8655             (, totalTokens,) = cd.getClaimsTokenMV(claimId);
8656           } else {
8657             (,, totalTokens) = cd.getClaimsTokenMV(claimId);
8658           }
8659         }
8660         tokenCalculated = (perc.mul(tokens).mul(tokensToBeDist)).div(totalTokens.mul(100));
8661 
8662 
8663       }
8664     }
8665   }
8666 
8667   /// @dev Transfers all tokens held by contract to a new contract in case of upgrade.
8668   function upgrade(address _newAdd) public onlyInternal {
8669     uint amount = tk.balanceOf(address(this));
8670     if (amount > 0) {
8671       require(tk.transfer(_newAdd, amount));
8672     }
8673 
8674   }
8675 
8676   /// @dev Total reward in token due for claim by a user.
8677   /// @return total total number of tokens
8678   function getRewardToBeDistributedByUser(address _add) public view returns (uint total) {
8679     uint lengthVote = cd.getVoteAddressCALength(_add);
8680     uint lastIndexCA;
8681     uint lastIndexMV;
8682     uint tokenForVoteId;
8683     uint voteId;
8684     (lastIndexCA, lastIndexMV) = cd.getRewardDistributedIndex(_add);
8685 
8686     for (uint i = lastIndexCA; i < lengthVote; i++) {
8687       voteId = cd.getVoteAddressCA(_add, i);
8688       (tokenForVoteId,,,) = getRewardToBeGiven(1, voteId, 0);
8689       total = total.add(tokenForVoteId);
8690     }
8691 
8692     lengthVote = cd.getVoteAddressMemberLength(_add);
8693 
8694     for (uint j = lastIndexMV; j < lengthVote; j++) {
8695       voteId = cd.getVoteAddressMember(_add, j);
8696       (tokenForVoteId,,,) = getRewardToBeGiven(0, voteId, 0);
8697       total = total.add(tokenForVoteId);
8698     }
8699     return (total);
8700   }
8701 
8702   /// @dev Gets reward amount and claiming status for a given claim id.
8703   /// @return reward amount of tokens to user.
8704   /// @return claimed true if already claimed false if yet to be claimed.
8705   function getRewardAndClaimedStatus(uint check, uint claimId) public view returns (uint reward, bool claimed) {
8706     uint voteId;
8707     uint claimid;
8708     uint lengthVote;
8709 
8710     if (check == 1) {
8711       lengthVote = cd.getVoteAddressCALength(msg.sender);
8712       for (uint i = 0; i < lengthVote; i++) {
8713         voteId = cd.getVoteAddressCA(msg.sender, i);
8714         (, claimid, , claimed) = cd.getVoteDetails(voteId);
8715         if (claimid == claimId) {break;}
8716       }
8717     } else {
8718       lengthVote = cd.getVoteAddressMemberLength(msg.sender);
8719       for (uint j = 0; j < lengthVote; j++) {
8720         voteId = cd.getVoteAddressMember(msg.sender, j);
8721         (, claimid, , claimed) = cd.getVoteDetails(voteId);
8722         if (claimid == claimId) {break;}
8723       }
8724     }
8725     (reward,,,) = getRewardToBeGiven(check, voteId, 1);
8726 
8727   }
8728 
8729   /**
8730    * @dev Function used to claim all pending rewards : Claims Assessment + Risk Assessment + Governance
8731    * Claim assesment, Risk assesment, Governance rewards
8732    */
8733   function claimAllPendingReward(uint records) public isMemberAndcheckPause {
8734     _claimRewardToBeDistributed(records);
8735     pooledStaking.withdrawReward(msg.sender);
8736     uint governanceRewards = gv.claimReward(msg.sender, records);
8737     if (governanceRewards > 0) {
8738       require(tk.transfer(msg.sender, governanceRewards));
8739     }
8740   }
8741 
8742   /**
8743    * @dev Function used to get pending rewards of a particular user address.
8744    * @param _add user address.
8745    * @return total reward amount of the user
8746    */
8747   function getAllPendingRewardOfUser(address _add) public view returns (uint) {
8748     uint caReward = getRewardToBeDistributedByUser(_add);
8749     uint pooledStakingReward = pooledStaking.stakerReward(_add);
8750     uint governanceReward = gv.getPendingReward(_add);
8751     return caReward.add(pooledStakingReward).add(governanceReward);
8752   }
8753 
8754   /// @dev Rewards/Punishes users who  participated in Claims assessment.
8755   //    Unlocking and burning of the tokens will also depend upon the status of claim.
8756   /// @param claimid Claim Id.
8757   function _rewardAgainstClaim(uint claimid, uint coverid, uint sumAssured, uint status) internal {
8758     uint premiumNXM = qd.getCoverPremiumNXM(coverid);
8759     bytes4 curr = qd.getCurrencyOfCover(coverid);
8760     uint distributableTokens = premiumNXM.mul(cd.claimRewardPerc()).div(100); // 20% of premium
8761 
8762     uint percCA;
8763     uint percMV;
8764 
8765     (percCA, percMV) = cd.getRewardStatus(status);
8766     cd.setClaimRewardDetail(claimid, percCA, percMV, distributableTokens);
8767     if (percCA > 0 || percMV > 0) {
8768       tc.mint(address(this), distributableTokens);
8769     }
8770 
8771     if (status == 6 || status == 9 || status == 11) {
8772       cd.changeFinalVerdict(claimid, - 1);
8773       td.setDepositCN(coverid, false); // Unset flag
8774       tf.burnDepositCN(coverid); // burn Deposited CN
8775 
8776       pd.changeCurrencyAssetVarMin(curr, pd.getCurrencyAssetVarMin(curr).sub(sumAssured));
8777       p2.internalLiquiditySwap(curr);
8778 
8779     } else if (status == 7 || status == 8 || status == 10) {
8780 
8781       cd.changeFinalVerdict(claimid, 1);
8782       td.setDepositCN(coverid, false); // Unset flag
8783       tf.unlockCN(coverid);
8784 
8785       address payable coverHolder = qd.getCoverMemberAddress(coverid);
8786       address payable payoutAddress = memberRoles.getClaimPayoutAddress(coverHolder);
8787       bool success = p1.sendClaimPayout(coverid, claimid, sumAssured, payoutAddress, curr);
8788 
8789       if (success) {
8790         tf.burnStakedTokens(coverid, curr, sumAssured);
8791         c1.setClaimStatus(claimid, 14);
8792       }
8793     }
8794   }
8795 
8796   /// @dev Computes the result of Claim Assessors Voting for a given claim id.
8797   function _changeClaimStatusCA(uint claimid, uint coverid, uint status) internal {
8798     // Check if voting should be closed or not
8799     if (c1.checkVoteClosing(claimid) == 1) {
8800       uint caTokens = c1.getCATokens(claimid, 0); // converted in cover currency.
8801       uint accept;
8802       uint deny;
8803       uint acceptAndDeny;
8804       bool rewardOrPunish;
8805       uint sumAssured;
8806       (, accept) = cd.getClaimVote(claimid, 1);
8807       (, deny) = cd.getClaimVote(claimid, - 1);
8808       acceptAndDeny = accept.add(deny);
8809       accept = accept.mul(100);
8810       deny = deny.mul(100);
8811 
8812       if (caTokens == 0) {
8813         status = 3;
8814       } else {
8815         sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
8816         // Min threshold reached tokens used for voting > 5* sum assured
8817         if (caTokens > sumAssured.mul(5)) {
8818 
8819           if (accept.div(acceptAndDeny) > 70) {
8820             status = 7;
8821             qd.changeCoverStatusNo(coverid, uint8(QuotationData.CoverStatus.ClaimAccepted));
8822             rewardOrPunish = true;
8823           } else if (deny.div(acceptAndDeny) > 70) {
8824             status = 6;
8825             qd.changeCoverStatusNo(coverid, uint8(QuotationData.CoverStatus.ClaimDenied));
8826             rewardOrPunish = true;
8827           } else if (accept.div(acceptAndDeny) > deny.div(acceptAndDeny)) {
8828             status = 4;
8829           } else {
8830             status = 5;
8831           }
8832 
8833         } else {
8834 
8835           if (accept.div(acceptAndDeny) > deny.div(acceptAndDeny)) {
8836             status = 2;
8837           } else {
8838             status = 3;
8839           }
8840         }
8841       }
8842 
8843       c1.setClaimStatus(claimid, status);
8844 
8845       if (rewardOrPunish) {
8846         _rewardAgainstClaim(claimid, coverid, sumAssured, status);
8847       }
8848     }
8849   }
8850 
8851   /// @dev Computes the result of Member Voting for a given claim id.
8852   function _changeClaimStatusMV(uint claimid, uint coverid, uint status) internal {
8853 
8854     // Check if voting should be closed or not
8855     if (c1.checkVoteClosing(claimid) == 1) {
8856       uint8 coverStatus;
8857       uint statusOrig = status;
8858       uint mvTokens = c1.getCATokens(claimid, 1); // converted in cover currency.
8859 
8860       // If tokens used for acceptance >50%, claim is accepted
8861       uint sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
8862       uint thresholdUnreached = 0;
8863       // Minimum threshold for member voting is reached only when
8864       // value of tokens used for voting > 5* sum assured of claim id
8865       if (mvTokens < sumAssured.mul(5)) {
8866         thresholdUnreached = 1;
8867       }
8868 
8869       uint accept;
8870       (, accept) = cd.getClaimMVote(claimid, 1);
8871       uint deny;
8872       (, deny) = cd.getClaimMVote(claimid, - 1);
8873 
8874       if (accept.add(deny) > 0) {
8875         if (accept.mul(100).div(accept.add(deny)) >= 50 && statusOrig > 1 &&
8876         statusOrig <= 5 && thresholdUnreached == 0) {
8877           status = 8;
8878           coverStatus = uint8(QuotationData.CoverStatus.ClaimAccepted);
8879         } else if (deny.mul(100).div(accept.add(deny)) >= 50 && statusOrig > 1 &&
8880         statusOrig <= 5 && thresholdUnreached == 0) {
8881           status = 9;
8882           coverStatus = uint8(QuotationData.CoverStatus.ClaimDenied);
8883         }
8884       }
8885 
8886       if (thresholdUnreached == 1 && (statusOrig == 2 || statusOrig == 4)) {
8887         status = 10;
8888         coverStatus = uint8(QuotationData.CoverStatus.ClaimAccepted);
8889       } else if (thresholdUnreached == 1 && (statusOrig == 5 || statusOrig == 3 || statusOrig == 1)) {
8890         status = 11;
8891         coverStatus = uint8(QuotationData.CoverStatus.ClaimDenied);
8892       }
8893 
8894       c1.setClaimStatus(claimid, status);
8895       qd.changeCoverStatusNo(coverid, uint8(coverStatus));
8896       // Reward/Punish Claim Assessors and Members who participated in Claims assessment
8897       _rewardAgainstClaim(claimid, coverid, sumAssured, status);
8898     }
8899   }
8900 
8901   /// @dev Allows a user to claim all pending  Claims assessment rewards.
8902   function _claimRewardToBeDistributed(uint _records) internal {
8903     uint lengthVote = cd.getVoteAddressCALength(msg.sender);
8904     uint voteid;
8905     uint lastIndex;
8906     (lastIndex,) = cd.getRewardDistributedIndex(msg.sender);
8907     uint total = 0;
8908     uint tokenForVoteId = 0;
8909     bool lastClaimedCheck;
8910     uint _days = td.lockCADays();
8911     bool claimed;
8912     uint counter = 0;
8913     uint claimId;
8914     uint perc;
8915     uint i;
8916     uint lastClaimed = lengthVote;
8917 
8918     for (i = lastIndex; i < lengthVote && counter < _records; i++) {
8919       voteid = cd.getVoteAddressCA(msg.sender, i);
8920       (tokenForVoteId, lastClaimedCheck, , perc) = getRewardToBeGiven(1, voteid, 0);
8921       if (lastClaimed == lengthVote && lastClaimedCheck == true) {
8922         lastClaimed = i;
8923       }
8924       (, claimId, , claimed) = cd.getVoteDetails(voteid);
8925 
8926       if (perc > 0 && !claimed) {
8927         counter++;
8928         cd.setRewardClaimed(voteid, true);
8929       } else if (perc == 0 && cd.getFinalVerdict(claimId) != 0 && !claimed) {
8930         (perc,,) = cd.getClaimRewardDetail(claimId);
8931         if (perc == 0) {
8932           counter++;
8933         }
8934         cd.setRewardClaimed(voteid, true);
8935       }
8936       if (tokenForVoteId > 0) {
8937         total = tokenForVoteId.add(total);
8938       }
8939     }
8940     if (lastClaimed == lengthVote) {
8941       cd.setRewardDistributedIndexCA(msg.sender, i);
8942     }
8943     else {
8944       cd.setRewardDistributedIndexCA(msg.sender, lastClaimed);
8945     }
8946     lengthVote = cd.getVoteAddressMemberLength(msg.sender);
8947     lastClaimed = lengthVote;
8948     _days = _days.mul(counter);
8949     if (tc.tokensLockedAtTime(msg.sender, "CLA", now) > 0) {
8950       tc.reduceLock(msg.sender, "CLA", _days);
8951     }
8952     (, lastIndex) = cd.getRewardDistributedIndex(msg.sender);
8953     lastClaimed = lengthVote;
8954     counter = 0;
8955     for (i = lastIndex; i < lengthVote && counter < _records; i++) {
8956       voteid = cd.getVoteAddressMember(msg.sender, i);
8957       (tokenForVoteId, lastClaimedCheck,,) = getRewardToBeGiven(0, voteid, 0);
8958       if (lastClaimed == lengthVote && lastClaimedCheck == true) {
8959         lastClaimed = i;
8960       }
8961       (, claimId, , claimed) = cd.getVoteDetails(voteid);
8962       if (claimed == false && cd.getFinalVerdict(claimId) != 0) {
8963         cd.setRewardClaimed(voteid, true);
8964         counter++;
8965       }
8966       if (tokenForVoteId > 0) {
8967         total = tokenForVoteId.add(total);
8968       }
8969     }
8970     if (total > 0) {
8971       require(tk.transfer(msg.sender, total));
8972     }
8973     if (lastClaimed == lengthVote) {
8974       cd.setRewardDistributedIndexMV(msg.sender, i);
8975     }
8976     else {
8977       cd.setRewardDistributedIndexMV(msg.sender, lastClaimed);
8978     }
8979   }
8980 
8981   /**
8982    * @dev Function used to claim the commission earned by the staker.
8983    */
8984   function _claimStakeCommission(uint _records, address _user) external onlyInternal {
8985     uint total = 0;
8986     uint len = td.getStakerStakedContractLength(_user);
8987     uint lastCompletedStakeCommission = td.lastCompletedStakeCommission(_user);
8988     uint commissionEarned;
8989     uint commissionRedeemed;
8990     uint maxCommission;
8991     uint lastCommisionRedeemed = len;
8992     uint counter;
8993     uint i;
8994 
8995     for (i = lastCompletedStakeCommission; i < len && counter < _records; i++) {
8996       commissionRedeemed = td.getStakerRedeemedStakeCommission(_user, i);
8997       commissionEarned = td.getStakerEarnedStakeCommission(_user, i);
8998       maxCommission = td.getStakerInitialStakedAmountOnContract(
8999         _user, i).mul(td.stakerMaxCommissionPer()).div(100);
9000       if (lastCommisionRedeemed == len && maxCommission != commissionEarned)
9001         lastCommisionRedeemed = i;
9002       td.pushRedeemedStakeCommissions(_user, i, commissionEarned.sub(commissionRedeemed));
9003       total = total.add(commissionEarned.sub(commissionRedeemed));
9004       counter++;
9005     }
9006     if (lastCommisionRedeemed == len) {
9007       td.setLastCompletedStakeCommissionIndex(_user, i);
9008     } else {
9009       td.setLastCompletedStakeCommissionIndex(_user, lastCommisionRedeemed);
9010     }
9011 
9012     if (total > 0)
9013       require(tk.transfer(_user, total)); // solhint-disable-line
9014   }
9015 
9016   function fixStuckStatuses() external {
9017     cd.setClaimStatus(2, 14);
9018     cd.setClaimStatus(3, 14);
9019     cd.setClaimStatus(5, 14);
9020   }
9021 
9022 }
9023 
9024 // File: contracts/modules/governance/MemberRoles.sol
9025 
9026 /* Copyright (C) 2017 GovBlocks.io
9027   This program is free software: you can redistribute it and/or modify
9028     it under the terms of the GNU General Public License as published by
9029     the Free Software Foundation, either version 3 of the License, or
9030     (at your option) any later version.
9031   This program is distributed in the hope that it will be useful,
9032     but WITHOUT ANY WARRANTY; without even the implied warranty of
9033     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9034     GNU General Public License for more details.
9035   You should have received a copy of the GNU General Public License
9036     along with this program.  If not, see http://www.gnu.org/licenses/ */
9037 
9038 pragma solidity ^0.5.0;
9039 
9040 
9041 
9042 
9043 
9044 
9045 
9046 
9047 contract MemberRoles is Governed, Iupgradable {
9048 
9049   TokenController public dAppToken;
9050   TokenData internal td;
9051   QuotationData internal qd;
9052   ClaimsReward internal cr;
9053   Governance internal gv;
9054   TokenFunctions internal tf;
9055   NXMToken public tk;
9056 
9057   struct MemberRoleDetails {
9058     uint memberCounter;
9059     mapping(address => bool) memberActive;
9060     address[] memberAddress;
9061     address authorized;
9062   }
9063 
9064   enum Role {UnAssigned, AdvisoryBoard, Member, Owner}
9065 
9066   event MemberRole(uint256 indexed roleId, bytes32 roleName, string roleDescription);
9067 
9068   event switchedMembership(address indexed previousMember, address indexed newMember, uint timeStamp);
9069 
9070   event ClaimPayoutAddressSet(address indexed member, address indexed payoutAddress);
9071 
9072   MemberRoleDetails[] internal memberRoleData;
9073   bool internal constructorCheck;
9074   uint public maxABCount;
9075   bool public launched;
9076   uint public launchedOn;
9077 
9078   mapping (address => address payable) internal claimPayoutAddress;
9079 
9080   modifier checkRoleAuthority(uint _memberRoleId) {
9081     if (memberRoleData[_memberRoleId].authorized != address(0))
9082       require(msg.sender == memberRoleData[_memberRoleId].authorized);
9083     else
9084       require(isAuthorizedToGovern(msg.sender), "Not Authorized");
9085     _;
9086   }
9087 
9088   /**
9089    * @dev to swap advisory board member
9090    * @param _newABAddress is address of new AB member
9091    * @param _removeAB is advisory board member to be removed
9092    */
9093   function swapABMember(
9094     address _newABAddress,
9095     address _removeAB
9096   )
9097   external
9098   checkRoleAuthority(uint(Role.AdvisoryBoard)) {
9099 
9100     _updateRole(_newABAddress, uint(Role.AdvisoryBoard), true);
9101     _updateRole(_removeAB, uint(Role.AdvisoryBoard), false);
9102 
9103   }
9104 
9105   /**
9106    * @dev to swap the owner address
9107    * @param _newOwnerAddress is the new owner address
9108    */
9109   function swapOwner(
9110     address _newOwnerAddress
9111   )
9112   external {
9113     require(msg.sender == address(ms));
9114     _updateRole(ms.owner(), uint(Role.Owner), false);
9115     _updateRole(_newOwnerAddress, uint(Role.Owner), true);
9116   }
9117 
9118   /**
9119    * @dev is used to add initital advisory board members
9120    * @param abArray is the list of initial advisory board members
9121    */
9122   function addInitialABMembers(address[] calldata abArray) external onlyOwner {
9123 
9124     //Ensure that NXMaster has initialized.
9125     require(ms.masterInitialized());
9126 
9127     require(maxABCount >=
9128       SafeMath.add(numberOfMembers(uint(Role.AdvisoryBoard)), abArray.length)
9129     );
9130     //AB count can't exceed maxABCount
9131     for (uint i = 0; i < abArray.length; i++) {
9132       require(checkRole(abArray[i], uint(MemberRoles.Role.Member)));
9133       _updateRole(abArray[i], uint(Role.AdvisoryBoard), true);
9134     }
9135   }
9136 
9137   /**
9138    * @dev to change max number of AB members allowed
9139    * @param _val is the new value to be set
9140    */
9141   function changeMaxABCount(uint _val) external onlyInternal {
9142     maxABCount = _val;
9143   }
9144 
9145   /**
9146    * @dev Iupgradable Interface to update dependent contract address
9147    */
9148   function changeDependentContractAddress() public {
9149     td = TokenData(ms.getLatestAddress("TD"));
9150     cr = ClaimsReward(ms.getLatestAddress("CR"));
9151     qd = QuotationData(ms.getLatestAddress("QD"));
9152     gv = Governance(ms.getLatestAddress("GV"));
9153     tf = TokenFunctions(ms.getLatestAddress("TF"));
9154     tk = NXMToken(ms.tokenAddress());
9155     dAppToken = TokenController(ms.getLatestAddress("TC"));
9156 
9157     // rescue future yNFT claim payouts as per gov proposal #113
9158     address payable yNFT = 0x181Aea6936B407514ebFC0754A37704eB8d98F91;
9159     address payable arNFT = 0x1337DEF1e9c7645352D93baf0b789D04562b4185;
9160 
9161     if (claimPayoutAddress[yNFT] == address(0)) {
9162       claimPayoutAddress[yNFT] = arNFT;
9163       emit ClaimPayoutAddressSet(yNFT, arNFT);
9164     }
9165   }
9166 
9167   /**
9168    * @dev to change the master address
9169    * @param _masterAddress is the new master address
9170    */
9171   function changeMasterAddress(address _masterAddress) public {
9172 
9173     if (masterAddress != address(0)) {
9174       require(masterAddress == msg.sender);
9175     }
9176 
9177     masterAddress = _masterAddress;
9178     ms = INXMMaster(_masterAddress);
9179     nxMasterAddress = _masterAddress;
9180   }
9181 
9182   /**
9183    * @dev to initiate the member roles
9184    * @param _firstAB is the address of the first AB member
9185    * @param memberAuthority is the authority (role) of the member
9186    */
9187   function memberRolesInitiate(address _firstAB, address memberAuthority) public {
9188     require(!constructorCheck);
9189     _addInitialMemberRoles(_firstAB, memberAuthority);
9190     constructorCheck = true;
9191   }
9192 
9193   /// @dev Adds new member role
9194   /// @param _roleName New role name
9195   /// @param _roleDescription New description hash
9196   /// @param _authorized Authorized member against every role id
9197   function addRole(//solhint-disable-line
9198     bytes32 _roleName,
9199     string memory _roleDescription,
9200     address _authorized
9201   )
9202   public
9203   onlyAuthorizedToGovern {
9204     _addRole(_roleName, _roleDescription, _authorized);
9205   }
9206 
9207   /// @dev Assign or Delete a member from specific role.
9208   /// @param _memberAddress Address of Member
9209   /// @param _roleId RoleId to update
9210   /// @param _active active is set to be True if we want to assign this role to member, False otherwise!
9211   function updateRole(//solhint-disable-line
9212     address _memberAddress,
9213     uint _roleId,
9214     bool _active
9215   )
9216   public
9217   checkRoleAuthority(_roleId) {
9218     _updateRole(_memberAddress, _roleId, _active);
9219   }
9220 
9221   /**
9222    * @dev to add members before launch
9223    * @param userArray is list of addresses of members
9224    * @param tokens is list of tokens minted for each array element
9225    */
9226   function addMembersBeforeLaunch(address[] memory userArray, uint[] memory tokens) public onlyOwner {
9227     require(!launched);
9228 
9229     for (uint i = 0; i < userArray.length; i++) {
9230       require(!ms.isMember(userArray[i]));
9231       dAppToken.addToWhitelist(userArray[i]);
9232       _updateRole(userArray[i], uint(Role.Member), true);
9233       dAppToken.mint(userArray[i], tokens[i]);
9234     }
9235     launched = true;
9236     launchedOn = now;
9237 
9238   }
9239 
9240   /**
9241     * @dev Called by user to pay joining membership fee
9242     */
9243   function payJoiningFee(address _userAddress) public payable {
9244     require(_userAddress != address(0));
9245     require(!ms.isPause(), "Emergency Pause Applied");
9246     if (msg.sender == address(ms.getLatestAddress("QT"))) {
9247       require(td.walletAddress() != address(0), "No walletAddress present");
9248       dAppToken.addToWhitelist(_userAddress);
9249       _updateRole(_userAddress, uint(Role.Member), true);
9250       td.walletAddress().transfer(msg.value);
9251     } else {
9252       require(!qd.refundEligible(_userAddress));
9253       require(!ms.isMember(_userAddress));
9254       require(msg.value == td.joiningFee());
9255       qd.setRefundEligible(_userAddress, true);
9256     }
9257   }
9258 
9259   /**
9260    * @dev to perform kyc verdict
9261    * @param _userAddress whose kyc is being performed
9262    * @param verdict of kyc process
9263    */
9264   function kycVerdict(address payable _userAddress, bool verdict) public {
9265 
9266     require(msg.sender == qd.kycAuthAddress());
9267     require(!ms.isPause());
9268     require(_userAddress != address(0));
9269     require(!ms.isMember(_userAddress));
9270     require(qd.refundEligible(_userAddress));
9271     if (verdict) {
9272       qd.setRefundEligible(_userAddress, false);
9273       uint fee = td.joiningFee();
9274       dAppToken.addToWhitelist(_userAddress);
9275       _updateRole(_userAddress, uint(Role.Member), true);
9276       td.walletAddress().transfer(fee); // solhint-disable-line
9277 
9278     } else {
9279       qd.setRefundEligible(_userAddress, false);
9280       _userAddress.transfer(td.joiningFee()); // solhint-disable-line
9281     }
9282   }
9283 
9284   /**
9285    * @dev Called by existed member if wish to Withdraw membership.
9286    */
9287   function withdrawMembership() public {
9288 
9289     require(!ms.isPause() && ms.isMember(msg.sender));
9290     require(dAppToken.totalLockedBalance(msg.sender, now) == 0); // solhint-disable-line
9291     require(!tf.isLockedForMemberVote(msg.sender)); // No locked tokens for Member/Governance voting
9292     require(cr.getAllPendingRewardOfUser(msg.sender) == 0); // No pending reward to be claimed(claim assesment).
9293     require(dAppToken.tokensUnlockable(msg.sender, "CLA") == 0, "Member should have no CLA unlockable tokens");
9294 
9295     gv.removeDelegation(msg.sender);
9296     dAppToken.burnFrom(msg.sender, tk.balanceOf(msg.sender));
9297     _updateRole(msg.sender, uint(Role.Member), false);
9298     dAppToken.removeFromWhitelist(msg.sender); // need clarification on whitelist
9299 
9300     if (claimPayoutAddress[msg.sender] != address(0)) {
9301       claimPayoutAddress[msg.sender] = address(0);
9302       emit ClaimPayoutAddressSet(msg.sender, address(0));
9303     }
9304   }
9305 
9306   /**
9307    * @dev Called by existed member if wish to switch membership to other address.
9308    * @param _add address of user to forward membership.
9309    */
9310   function switchMembership(address _add) external {
9311 
9312     require(!ms.isPause() && ms.isMember(msg.sender) && !ms.isMember(_add));
9313     require(dAppToken.totalLockedBalance(msg.sender, now) == 0); // solhint-disable-line
9314     require(!tf.isLockedForMemberVote(msg.sender)); // No locked tokens for Member/Governance voting
9315     require(cr.getAllPendingRewardOfUser(msg.sender) == 0); // No pending reward to be claimed(claim assesment).
9316     require(dAppToken.tokensUnlockable(msg.sender, "CLA") == 0, "Member should have no CLA unlockable tokens");
9317 
9318     gv.removeDelegation(msg.sender);
9319     dAppToken.addToWhitelist(_add);
9320     _updateRole(_add, uint(Role.Member), true);
9321     tk.transferFrom(msg.sender, _add, tk.balanceOf(msg.sender));
9322     _updateRole(msg.sender, uint(Role.Member), false);
9323     dAppToken.removeFromWhitelist(msg.sender);
9324 
9325     address payable previousPayoutAddress = claimPayoutAddress[msg.sender];
9326 
9327     if (previousPayoutAddress != address(0)) {
9328 
9329       address payable storedAddress = previousPayoutAddress == _add ? address(0) : previousPayoutAddress;
9330 
9331       claimPayoutAddress[msg.sender] = address(0);
9332       claimPayoutAddress[_add] = storedAddress;
9333 
9334       // emit event for old address reset
9335       emit ClaimPayoutAddressSet(msg.sender, address(0));
9336 
9337       if (storedAddress != address(0)) {
9338         // emit event for setting the payout address on the new member address if it's non zero
9339         emit ClaimPayoutAddressSet(_add, storedAddress);
9340       }
9341     }
9342 
9343     emit switchedMembership(msg.sender, _add, now);
9344   }
9345 
9346   function getClaimPayoutAddress(address payable _member) external view returns (address payable) {
9347     address payable payoutAddress = claimPayoutAddress[_member];
9348     return payoutAddress != address(0) ? payoutAddress : _member;
9349   }
9350 
9351   function setClaimPayoutAddress(address payable _address) external {
9352 
9353     require(!ms.isPause(), "system is paused");
9354     require(ms.isMember(msg.sender), "sender is not a member");
9355     require(_address != msg.sender, "should be different than the member address");
9356 
9357     claimPayoutAddress[msg.sender] = _address;
9358     emit ClaimPayoutAddressSet(msg.sender, _address);
9359   }
9360 
9361   /// @dev Return number of member roles
9362   function totalRoles() public view returns (uint256) {//solhint-disable-line
9363     return memberRoleData.length;
9364   }
9365 
9366   /// @dev Change Member Address who holds the authority to Add/Delete any member from specific role.
9367   /// @param _roleId roleId to update its Authorized Address
9368   /// @param _newAuthorized New authorized address against role id
9369   function changeAuthorized(uint _roleId, address _newAuthorized) public checkRoleAuthority(_roleId) {//solhint-disable-line
9370     memberRoleData[_roleId].authorized = _newAuthorized;
9371   }
9372 
9373   /// @dev Gets the member addresses assigned by a specific role
9374   /// @param _memberRoleId Member role id
9375   /// @return roleId Role id
9376   /// @return allMemberAddress Member addresses of specified role id
9377   function members(uint _memberRoleId) public view returns (uint, address[] memory memberArray) {//solhint-disable-line
9378     uint length = memberRoleData[_memberRoleId].memberAddress.length;
9379     uint i;
9380     uint j = 0;
9381     memberArray = new address[](memberRoleData[_memberRoleId].memberCounter);
9382     for (i = 0; i < length; i++) {
9383       address member = memberRoleData[_memberRoleId].memberAddress[i];
9384       if (memberRoleData[_memberRoleId].memberActive[member] && !_checkMemberInArray(member, memberArray)) {//solhint-disable-line
9385         memberArray[j] = member;
9386         j++;
9387       }
9388     }
9389 
9390     return (_memberRoleId, memberArray);
9391   }
9392 
9393   /// @dev Gets all members' length
9394   /// @param _memberRoleId Member role id
9395   /// @return memberRoleData[_memberRoleId].memberCounter Member length
9396   function numberOfMembers(uint _memberRoleId) public view returns (uint) {//solhint-disable-line
9397     return memberRoleData[_memberRoleId].memberCounter;
9398   }
9399 
9400   /// @dev Return member address who holds the right to add/remove any member from specific role.
9401   function authorized(uint _memberRoleId) public view returns (address) {//solhint-disable-line
9402     return memberRoleData[_memberRoleId].authorized;
9403   }
9404 
9405   /// @dev Get All role ids array that has been assigned to a member so far.
9406   function roles(address _memberAddress) public view returns (uint[] memory) {//solhint-disable-line
9407     uint length = memberRoleData.length;
9408     uint[] memory assignedRoles = new uint[](length);
9409     uint counter = 0;
9410     for (uint i = 1; i < length; i++) {
9411       if (memberRoleData[i].memberActive[_memberAddress]) {
9412         assignedRoles[counter] = i;
9413         counter++;
9414       }
9415     }
9416     return assignedRoles;
9417   }
9418 
9419   /// @dev Returns true if the given role id is assigned to a member.
9420   /// @param _memberAddress Address of member
9421   /// @param _roleId Checks member's authenticity with the roleId.
9422   /// i.e. Returns true if this roleId is assigned to member
9423   function checkRole(address _memberAddress, uint _roleId) public view returns (bool) {//solhint-disable-line
9424     if (_roleId == uint(Role.UnAssigned))
9425       return true;
9426     else
9427       if (memberRoleData[_roleId].memberActive[_memberAddress]) //solhint-disable-line
9428         return true;
9429       else
9430         return false;
9431   }
9432 
9433   /// @dev Return total number of members assigned against each role id.
9434   /// @return totalMembers Total members in particular role id
9435   function getMemberLengthForAllRoles() public view returns (uint[] memory totalMembers) {//solhint-disable-line
9436     totalMembers = new uint[](memberRoleData.length);
9437     for (uint i = 0; i < memberRoleData.length; i++) {
9438       totalMembers[i] = numberOfMembers(i);
9439     }
9440   }
9441 
9442   /**
9443    * @dev to update the member roles
9444    * @param _memberAddress in concern
9445    * @param _roleId the id of role
9446    * @param _active if active is true, add the member, else remove it
9447    */
9448   function _updateRole(address _memberAddress,
9449     uint _roleId,
9450     bool _active) internal {
9451     // require(_roleId != uint(Role.TokenHolder), "Membership to Token holder is detected automatically");
9452     if (_active) {
9453       require(!memberRoleData[_roleId].memberActive[_memberAddress]);
9454       memberRoleData[_roleId].memberCounter = SafeMath.add(memberRoleData[_roleId].memberCounter, 1);
9455       memberRoleData[_roleId].memberActive[_memberAddress] = true;
9456       memberRoleData[_roleId].memberAddress.push(_memberAddress);
9457     } else {
9458       require(memberRoleData[_roleId].memberActive[_memberAddress]);
9459       memberRoleData[_roleId].memberCounter = SafeMath.sub(memberRoleData[_roleId].memberCounter, 1);
9460       delete memberRoleData[_roleId].memberActive[_memberAddress];
9461     }
9462   }
9463 
9464   /// @dev Adds new member role
9465   /// @param _roleName New role name
9466   /// @param _roleDescription New description hash
9467   /// @param _authorized Authorized member against every role id
9468   function _addRole(
9469     bytes32 _roleName,
9470     string memory _roleDescription,
9471     address _authorized
9472   ) internal {
9473     emit MemberRole(memberRoleData.length, _roleName, _roleDescription);
9474     memberRoleData.push(MemberRoleDetails(0, new address[](0), _authorized));
9475   }
9476 
9477   /**
9478    * @dev to check if member is in the given member array
9479    * @param _memberAddress in concern
9480    * @param memberArray in concern
9481    * @return boolean to represent the presence
9482    */
9483   function _checkMemberInArray(
9484     address _memberAddress,
9485     address[] memory memberArray
9486   )
9487   internal
9488   pure
9489   returns (bool memberExists)
9490   {
9491     uint i;
9492     for (i = 0; i < memberArray.length; i++) {
9493       if (memberArray[i] == _memberAddress) {
9494         memberExists = true;
9495         break;
9496       }
9497     }
9498   }
9499 
9500   /**
9501    * @dev to add initial member roles
9502    * @param _firstAB is the member address to be added
9503    * @param memberAuthority is the member authority(role) to be added for
9504    */
9505   function _addInitialMemberRoles(address _firstAB, address memberAuthority) internal {
9506     maxABCount = 5;
9507     _addRole("Unassigned", "Unassigned", address(0));
9508     _addRole(
9509       "Advisory Board",
9510       "Selected few members that are deeply entrusted by the dApp. An ideal advisory board should be a mix of skills of domain, governance, research, technology, consulting etc to improve the performance of the dApp.", //solhint-disable-line
9511       address(0)
9512     );
9513     _addRole(
9514       "Member",
9515       "Represents all users of Mutual.", //solhint-disable-line
9516       memberAuthority
9517     );
9518     _addRole(
9519       "Owner",
9520       "Represents Owner of Mutual.", //solhint-disable-line
9521       address(0)
9522     );
9523     // _updateRole(_firstAB, uint(Role.AdvisoryBoard), true);
9524     _updateRole(_firstAB, uint(Role.Owner), true);
9525     // _updateRole(_firstAB, uint(Role.Member), true);
9526     launchedOn = 0;
9527   }
9528 
9529   function memberAtIndex(uint _memberRoleId, uint index) external view returns (address, bool) {
9530     address memberAddress = memberRoleData[_memberRoleId].memberAddress[index];
9531     return (memberAddress, memberRoleData[_memberRoleId].memberActive[memberAddress]);
9532   }
9533 
9534   function membersLength(uint _memberRoleId) external view returns (uint) {
9535     return memberRoleData[_memberRoleId].memberAddress.length;
9536   }
9537 }
9538 
9539 // File: contracts/modules/capital/MCR.sol
9540 
9541 /* Copyright (C) 2020 NexusMutual.io
9542 
9543   This program is free software: you can redistribute it and/or modify
9544     it under the terms of the GNU General Public License as published by
9545     the Free Software Foundation, either version 3 of the License, or
9546     (at your option) any later version.
9547 
9548   This program is distributed in the hope that it will be useful,
9549     but WITHOUT ANY WARRANTY; without even the implied warranty of
9550     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9551     GNU General Public License for more details.
9552 
9553   You should have received a copy of the GNU General Public License
9554     along with this program.  If not, see http://www.gnu.org/licenses/ */
9555 
9556 pragma solidity ^0.5.0;
9557 
9558 
9559 
9560 
9561 
9562 
9563 
9564 
9565 
9566 
9567 contract MCR is Iupgradable {
9568   using SafeMath for uint;
9569 
9570   Pool1 internal p1;
9571   PoolData internal pd;
9572   NXMToken internal tk;
9573   QuotationData internal qd;
9574   MemberRoles internal mr;
9575   TokenData internal td;
9576   ProposalCategory internal proposalCategory;
9577 
9578   uint private constant DECIMAL1E18 = uint(10) ** 18;
9579   uint private constant DECIMAL1E05 = uint(10) ** 5;
9580   uint private constant DECIMAL1E19 = uint(10) ** 19;
9581   uint private constant minCapFactor = uint(10) ** 21;
9582 
9583   uint public variableMincap;
9584   uint public dynamicMincapThresholdx100 = 13000;
9585   uint public dynamicMincapIncrementx100 = 100;
9586 
9587   event MCREvent(
9588     uint indexed date,
9589     uint blockNumber,
9590     bytes4[] allCurr,
9591     uint[] allCurrRates,
9592     uint mcrEtherx100,
9593     uint mcrPercx100,
9594     uint vFull
9595   );
9596 
9597   /**
9598    * @dev Adds new MCR data.
9599    * @param mcrP  Minimum Capital Requirement in percentage.
9600    * @param vF Pool1 fund value in Ether used in the last full daily calculation of the Capital model.
9601    * @param onlyDate  Date(yyyymmdd) at which MCR details are getting added.
9602    */
9603   function addMCRData(
9604     uint mcrP,
9605     uint mcrE,
9606     uint vF,
9607     bytes4[] calldata curr,
9608     uint[] calldata _threeDayAvg,
9609     uint64 onlyDate
9610   )
9611   external
9612   checkPause
9613   {
9614     require(proposalCategory.constructorCheck());
9615     require(pd.isnotarise(msg.sender));
9616     if (mr.launched() && pd.capReached() != 1) {
9617 
9618       if (mcrP >= 10000)
9619         pd.setCapReached(1);
9620 
9621     }
9622     uint len = pd.getMCRDataLength();
9623     _addMCRData(len, onlyDate, curr, mcrE, mcrP, vF, _threeDayAvg);
9624   }
9625 
9626   /**
9627    * @dev Adds MCR Data for last failed attempt.
9628    */
9629   function addLastMCRData(uint64 date) external checkPause onlyInternal {
9630     uint64 lastdate = uint64(pd.getLastMCRDate());
9631     uint64 failedDate = uint64(date);
9632     if (failedDate >= lastdate) {
9633       uint mcrP;
9634       uint mcrE;
9635       uint vF;
9636       (mcrP, mcrE, vF,) = pd.getLastMCR();
9637       uint len = pd.getAllCurrenciesLen();
9638       pd.pushMCRData(mcrP, mcrE, vF, date);
9639       for (uint j = 0; j < len; j++) {
9640         bytes4 currName = pd.getCurrenciesByIndex(j);
9641         pd.updateCAAvgRate(currName, pd.getCAAvgRate(currName));
9642       }
9643 
9644       emit MCREvent(date, block.number, new bytes4[](0), new uint[](0), mcrE, mcrP, vF);
9645       // Oraclize call for next MCR calculation
9646       _callOracliseForMCR();
9647     }
9648   }
9649 
9650   /**
9651    * @dev Iupgradable Interface to update dependent contract address
9652    */
9653   function changeDependentContractAddress() public onlyInternal {
9654     qd = QuotationData(ms.getLatestAddress("QD"));
9655     p1 = Pool1(ms.getLatestAddress("P1"));
9656     pd = PoolData(ms.getLatestAddress("PD"));
9657     tk = NXMToken(ms.tokenAddress());
9658     mr = MemberRoles(ms.getLatestAddress("MR"));
9659     td = TokenData(ms.getLatestAddress("TD"));
9660     proposalCategory = ProposalCategory(ms.getLatestAddress("PC"));
9661   }
9662 
9663   /**
9664    * @dev Gets total sum assured(in ETH).
9665    * @return amount of sum assured
9666    */
9667   function getAllSumAssurance() public view returns (uint amount) {
9668     uint len = pd.getAllCurrenciesLen();
9669     for (uint i = 0; i < len; i++) {
9670       bytes4 currName = pd.getCurrenciesByIndex(i);
9671       if (currName == "ETH") {
9672         amount = amount.add(qd.getTotalSumAssured(currName));
9673       } else {
9674         if (pd.getCAAvgRate(currName) > 0)
9675           amount = amount.add((qd.getTotalSumAssured(currName).mul(100)).div(pd.getCAAvgRate(currName)));
9676       }
9677     }
9678   }
9679 
9680   /**
9681    * @dev Calculates V(Tp) and MCR%(Tp), i.e, Pool Fund Value in Ether
9682    * and MCR% used in the Token Price Calculation.
9683    * @return vtp  Pool Fund Value in Ether used for the Token Price Model
9684    * @return mcrtp MCR% used in the Token Price Model.
9685    */
9686   function _calVtpAndMCRtp(uint poolBalance) public view returns (uint vtp, uint mcrtp) {
9687     vtp = 0;
9688     IERC20 erc20;
9689     uint currTokens = 0;
9690     uint i;
9691     for (i = 1; i < pd.getAllCurrenciesLen(); i++) {
9692       bytes4 currency = pd.getCurrenciesByIndex(i);
9693       erc20 = IERC20(pd.getCurrencyAssetAddress(currency));
9694       currTokens = erc20.balanceOf(address(p1));
9695       if (pd.getCAAvgRate(currency) > 0)
9696         vtp = vtp.add((currTokens.mul(100)).div(pd.getCAAvgRate(currency)));
9697     }
9698 
9699     vtp = vtp.add(poolBalance).add(p1.getInvestmentAssetBalance());
9700     uint mcrFullperc;
9701     uint vFull;
9702     (mcrFullperc, , vFull,) = pd.getLastMCR();
9703     if (vFull > 0) {
9704       mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
9705     }
9706   }
9707 
9708   /**
9709    * @dev Calculates the Token Price of NXM in a given currency.
9710    * @param curr Currency name.
9711 
9712    */
9713   function calculateStepTokenPrice(
9714     bytes4 curr,
9715     uint mcrtp
9716   )
9717   public
9718   view
9719   onlyInternal
9720   returns (uint tokenPrice)
9721   {
9722     return _calculateTokenPrice(curr, mcrtp);
9723   }
9724 
9725   /**
9726    * @dev Calculates the Token Price of NXM in a given currency
9727    * with provided token supply for dynamic token price calculation
9728    * @param curr Currency name.
9729    */
9730   function calculateTokenPrice(bytes4 curr) public view returns (uint tokenPrice) {
9731     uint mcrtp;
9732     (, mcrtp) = _calVtpAndMCRtp(address(p1).balance);
9733     return _calculateTokenPrice(curr, mcrtp);
9734   }
9735 
9736   function calVtpAndMCRtp() public view returns (uint vtp, uint mcrtp) {
9737     return _calVtpAndMCRtp(address(p1).balance);
9738   }
9739 
9740   function calculateVtpAndMCRtp(uint poolBalance) public view returns (uint vtp, uint mcrtp) {
9741     return _calVtpAndMCRtp(poolBalance);
9742   }
9743 
9744   function getThresholdValues(uint vtp, uint vF, uint totalSA, uint minCap) public view returns (uint lowerThreshold, uint upperThreshold)
9745   {
9746     minCap = (minCap.mul(minCapFactor)).add(variableMincap);
9747     uint lower = 0;
9748     if (vtp >= vF) {
9749       // Max Threshold = [MAX(Vtp, Vfull) x 120] / mcrMinCap
9750       upperThreshold = vtp.mul(120).mul(100).div((minCap));
9751     } else {
9752       upperThreshold = vF.mul(120).mul(100).div((minCap));
9753     }
9754 
9755     if (vtp > 0) {
9756       lower = totalSA.mul(DECIMAL1E18).mul(pd.shockParameter()).div(100);
9757       if (lower < minCap.mul(11).div(10))
9758         lower = minCap.mul(11).div(10);
9759     }
9760     if (lower > 0) {
9761       // Min Threshold = [Vtp / MAX(TotalActiveSA x ShockParameter, mcrMinCap x 1.1)] x 100
9762       lowerThreshold = vtp.mul(100).mul(100).div(lower);
9763     }
9764   }
9765 
9766   /**
9767    * @dev Gets max numbers of tokens that can be sold at the moment.
9768    */
9769   function getMaxSellTokens() public view returns (uint maxTokens) {
9770     uint baseMin = pd.getCurrencyAssetBaseMin("ETH");
9771     uint maxTokensAccPoolBal;
9772     if (address(p1).balance > baseMin.mul(50).div(100)) {
9773       maxTokensAccPoolBal = address(p1).balance.sub(
9774         (baseMin.mul(50)).div(100));
9775     }
9776     maxTokensAccPoolBal = (maxTokensAccPoolBal.mul(DECIMAL1E18)).div(
9777       (calculateTokenPrice("ETH").mul(975)).div(1000));
9778     uint lastMCRPerc = pd.getLastMCRPerc();
9779     if (lastMCRPerc > 10000)
9780       maxTokens = (((uint(lastMCRPerc).sub(10000)).mul(2000)).mul(DECIMAL1E18)).div(10000);
9781     if (maxTokens > maxTokensAccPoolBal)
9782       maxTokens = maxTokensAccPoolBal;
9783   }
9784 
9785   /**
9786    * @dev Gets Uint Parameters of a code
9787    * @param code whose details we want
9788    * @return string value of the code
9789    * @return associated amount (time or perc or value) to the code
9790    */
9791   function getUintParameters(bytes8 code) external view returns (bytes8 codeVal, uint val) {
9792     codeVal = code;
9793     if (code == "DMCT") {
9794       val = dynamicMincapThresholdx100;
9795 
9796     } else if (code == "DMCI") {
9797 
9798       val = dynamicMincapIncrementx100;
9799 
9800     }
9801 
9802   }
9803 
9804   /**
9805    * @dev Updates Uint Parameters of a code
9806    * @param code whose details we want to update
9807    * @param val value to set
9808    */
9809   function updateUintParameters(bytes8 code, uint val) public {
9810     require(ms.checkIsAuthToGoverned(msg.sender));
9811     if (code == "DMCT") {
9812       dynamicMincapThresholdx100 = val;
9813 
9814     } else if (code == "DMCI") {
9815 
9816       dynamicMincapIncrementx100 = val;
9817 
9818     }
9819     else {
9820       revert("Invalid param code");
9821     }
9822 
9823   }
9824 
9825   /**
9826    * @dev Calls oraclize query to calculate MCR details after 24 hours.
9827    */
9828   function _callOracliseForMCR() internal {
9829     p1.mcrOraclise(pd.mcrTime());
9830   }
9831 
9832   /**
9833    * @dev Calculates the Token Price of NXM in a given currency
9834    * with provided token supply for dynamic token price calculation
9835    * @param _curr Currency name.
9836    * @return tokenPrice Token price.
9837    */
9838   function _calculateTokenPrice(
9839     bytes4 _curr,
9840     uint mcrtp
9841   )
9842   internal
9843   view
9844   returns (uint tokenPrice)
9845   {
9846     uint getA;
9847     uint getC;
9848     uint getCAAvgRate;
9849     uint tokenExponentValue = td.tokenExponent();
9850     // uint max = (mcrtp.mul(mcrtp).mul(mcrtp).mul(mcrtp));
9851     uint max = mcrtp ** tokenExponentValue;
9852     uint dividingFactor = tokenExponentValue.mul(4);
9853     (getA, getC, getCAAvgRate) = pd.getTokenPriceDetails(_curr);
9854     uint mcrEth = pd.getLastMCREther();
9855     getC = getC.mul(DECIMAL1E18);
9856     tokenPrice = (mcrEth.mul(DECIMAL1E18).mul(max).div(getC)).div(10 ** dividingFactor);
9857     tokenPrice = tokenPrice.add(getA.mul(DECIMAL1E18).div(DECIMAL1E05));
9858     tokenPrice = tokenPrice.mul(getCAAvgRate * 10);
9859     tokenPrice = (tokenPrice).div(10 ** 3);
9860   }
9861 
9862   /**
9863    * @dev Adds MCR Data. Checks if MCR is within valid
9864    * thresholds in order to rule out any incorrect calculations
9865    */
9866   function _addMCRData(
9867     uint len,
9868     uint64 newMCRDate,
9869     bytes4[] memory curr,
9870     uint mcrE,
9871     uint mcrP,
9872     uint vF,
9873     uint[] memory _threeDayAvg
9874   )
9875   internal
9876   {
9877     uint vtp = 0;
9878     uint lowerThreshold = 0;
9879     uint upperThreshold = 0;
9880     if (len > 1) {
9881       (vtp,) = _calVtpAndMCRtp(address(p1).balance);
9882       (lowerThreshold, upperThreshold) = getThresholdValues(vtp, vF, getAllSumAssurance(), pd.minCap());
9883 
9884     }
9885     if (mcrP > dynamicMincapThresholdx100)
9886       variableMincap = (variableMincap.mul(dynamicMincapIncrementx100.add(10000)).add(minCapFactor.mul(pd.minCap().mul(dynamicMincapIncrementx100)))).div(10000);
9887 
9888 
9889     // Explanation for above formula :-
9890     // actual formula -> variableMinCap =  variableMinCap + (variableMinCap+minCap)*dynamicMincapIncrement/100
9891     // Implemented formula is simplified form of actual formula.
9892     // Let consider above formula as b = b + (a+b)*c/100
9893     // here, dynamicMincapIncrement is in x100 format.
9894     // so b+(a+b)*cx100/10000 can be written as => (10000.b + b.cx100 + a.cx100)/10000.
9895     // It can further simplify to (b.(10000+cx100) + a.cx100)/10000.
9896     if (len == 1 || (mcrP) >= lowerThreshold
9897     && (mcrP) <= upperThreshold) {
9898       // due to stack to deep error,we are reusing already declared variable
9899       vtp = pd.getLastMCRDate();
9900       pd.pushMCRData(mcrP, mcrE, vF, newMCRDate);
9901       for (uint i = 0; i < curr.length; i++) {
9902         pd.updateCAAvgRate(curr[i], _threeDayAvg[i]);
9903       }
9904       emit MCREvent(newMCRDate, block.number, curr, _threeDayAvg, mcrE, mcrP, vF);
9905       // Oraclize call for next MCR calculation
9906       if (vtp < newMCRDate) {
9907         _callOracliseForMCR();
9908       }
9909     } else {
9910       p1.mcrOracliseFail(newMCRDate, pd.mcrFailTime());
9911     }
9912   }
9913 
9914 }
9915 
9916 // File: contracts/modules/claims/Claims.sol
9917 
9918 /* Copyright (C) 2020 NexusMutual.io
9919 
9920   This program is free software: you can redistribute it and/or modify
9921     it under the terms of the GNU General Public License as published by
9922     the Free Software Foundation, either version 3 of the License, or
9923     (at your option) any later version.
9924 
9925   This program is distributed in the hope that it will be useful,
9926     but WITHOUT ANY WARRANTY; without even the implied warranty of
9927     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9928     GNU General Public License for more details.
9929 
9930   You should have received a copy of the GNU General Public License
9931     along with this program.  If not, see http://www.gnu.org/licenses/ */
9932 
9933 pragma solidity ^0.5.0;
9934 
9935 
9936 
9937 
9938 
9939 
9940 
9941 
9942 contract Claims is Iupgradable {
9943   using SafeMath for uint;
9944 
9945 
9946   TokenFunctions internal tf;
9947   NXMToken internal tk;
9948   TokenController internal tc;
9949   ClaimsReward internal cr;
9950   Pool1 internal p1;
9951   ClaimsData internal cd;
9952   TokenData internal td;
9953   PoolData internal pd;
9954   Pool2 internal p2;
9955   QuotationData internal qd;
9956   MCR internal m1;
9957 
9958   uint private constant DECIMAL1E18 = uint(10) ** 18;
9959 
9960   /**
9961    * @dev Sets the status of claim using claim id.
9962    * @param claimId claim id.
9963    * @param stat status to be set.
9964    */
9965   function setClaimStatus(uint claimId, uint stat) external onlyInternal {
9966     _setClaimStatus(claimId, stat);
9967   }
9968 
9969   /**
9970    * @dev Gets claim details of claim id = pending claim start + given index
9971    */
9972   function getClaimFromNewStart(
9973     uint index
9974   )
9975   external
9976   view
9977   returns (
9978     uint coverId,
9979     uint claimId,
9980     int8 voteCA,
9981     int8 voteMV,
9982     uint statusnumber
9983   )
9984   {
9985     (coverId, claimId, voteCA, voteMV, statusnumber) = cd.getClaimFromNewStart(index, msg.sender);
9986     // status = rewardStatus[statusnumber].claimStatusDesc;
9987   }
9988 
9989   /**
9990    * @dev Gets details of a claim submitted by the calling user, at a given index
9991    */
9992   function getUserClaimByIndex(
9993     uint index
9994   )
9995   external
9996   view
9997   returns (
9998     uint status,
9999     uint coverId,
10000     uint claimId
10001   )
10002   {
10003     uint statusno;
10004     (statusno, coverId, claimId) = cd.getUserClaimByIndex(index, msg.sender);
10005     status = statusno;
10006   }
10007 
10008   /**
10009    * @dev Gets details of a given claim id.
10010    * @param _claimId Claim Id.
10011    * @return status Current status of claim id
10012    * @return finalVerdict Decision made on the claim, 1 -> acceptance, -1 -> denial
10013    * @return claimOwner Address through which claim is submitted
10014    * @return coverId Coverid associated with the claim id
10015    */
10016   function getClaimbyIndex(uint _claimId) external view returns (
10017     uint claimId,
10018     uint status,
10019     int8 finalVerdict,
10020     address claimOwner,
10021     uint coverId
10022   )
10023   {
10024     uint stat;
10025     claimId = _claimId;
10026     (, coverId, finalVerdict, stat,,) = cd.getClaim(_claimId);
10027     claimOwner = qd.getCoverMemberAddress(coverId);
10028     status = stat;
10029   }
10030 
10031   /**
10032    * @dev Calculates total amount that has been used to assess a claim.
10033    * Computaion:Adds acceptCA(tokens used for voting in favor of a claim)
10034    * denyCA(tokens used for voting against a claim) *  current token price.
10035    * @param claimId Claim Id.
10036    * @param member Member type 0 -> Claim Assessors, else members.
10037    * @return tokens Total Amount used in Claims assessment.
10038    */
10039   function getCATokens(uint claimId, uint member) external view returns (uint tokens) {
10040     uint coverId;
10041     (, coverId) = cd.getClaimCoverId(claimId);
10042     bytes4 curr = qd.getCurrencyOfCover(coverId);
10043     uint tokenx1e18 = m1.calculateTokenPrice(curr);
10044     uint accept;
10045     uint deny;
10046     if (member == 0) {
10047       (, accept, deny) = cd.getClaimsTokenCA(claimId);
10048     } else {
10049       (, accept, deny) = cd.getClaimsTokenMV(claimId);
10050     }
10051     tokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18); // amount (not in tokens)
10052   }
10053 
10054   /**
10055    * Iupgradable Interface to update dependent contract address
10056    */
10057   function changeDependentContractAddress() public onlyInternal {
10058     tk = NXMToken(ms.tokenAddress());
10059     td = TokenData(ms.getLatestAddress("TD"));
10060     tf = TokenFunctions(ms.getLatestAddress("TF"));
10061     tc = TokenController(ms.getLatestAddress("TC"));
10062     p1 = Pool1(ms.getLatestAddress("P1"));
10063     p2 = Pool2(ms.getLatestAddress("P2"));
10064     pd = PoolData(ms.getLatestAddress("PD"));
10065     cr = ClaimsReward(ms.getLatestAddress("CR"));
10066     cd = ClaimsData(ms.getLatestAddress("CD"));
10067     qd = QuotationData(ms.getLatestAddress("QD"));
10068     m1 = MCR(ms.getLatestAddress("MC"));
10069   }
10070 
10071   /**
10072    * @dev Updates the pending claim start variable,
10073    * the lowest claim id with a pending decision/payout.
10074    */
10075   function changePendingClaimStart() public onlyInternal {
10076 
10077     uint origstat;
10078     uint state12Count;
10079     uint pendingClaimStart = cd.pendingClaimStart();
10080     uint actualClaimLength = cd.actualClaimLength();
10081     for (uint i = pendingClaimStart; i < actualClaimLength; i++) {
10082       (, , , origstat, , state12Count) = cd.getClaim(i);
10083 
10084       if (origstat > 5 && ((origstat != 12) || (origstat == 12 && state12Count >= 60)))
10085         cd.setpendingClaimStart(i);
10086       else
10087         break;
10088     }
10089   }
10090 
10091   /**
10092    * @dev Submits a claim for a given cover note.
10093    * Adds claim to queue incase of emergency pause else directly submits the claim.
10094    * @param coverId Cover Id.
10095    */
10096   function submitClaim(uint coverId) public {
10097     address qadd = qd.getCoverMemberAddress(coverId);
10098     require(qadd == msg.sender);
10099     uint8 cStatus;
10100     (, cStatus,,,) = qd.getCoverDetailsByCoverID2(coverId);
10101     require(cStatus != uint8(QuotationData.CoverStatus.ClaimSubmitted), "Claim already submitted");
10102     require(cStatus != uint8(QuotationData.CoverStatus.CoverExpired), "Cover already expired");
10103     if (ms.isPause() == false) {
10104       _addClaim(coverId, now, qadd);
10105     } else {
10106       cd.setClaimAtEmergencyPause(coverId, now, false);
10107       qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.Requested));
10108     }
10109   }
10110 
10111   /**
10112    * @dev Submits the Claims queued once the emergency pause is switched off.
10113    */
10114   function submitClaimAfterEPOff() public onlyInternal {
10115     uint lengthOfClaimSubmittedAtEP = cd.getLengthOfClaimSubmittedAtEP();
10116     uint firstClaimIndexToSubmitAfterEP = cd.getFirstClaimIndexToSubmitAfterEP();
10117     uint coverId;
10118     uint dateUpd;
10119     bool submit;
10120     address qadd;
10121     for (uint i = firstClaimIndexToSubmitAfterEP; i < lengthOfClaimSubmittedAtEP; i++) {
10122       (coverId, dateUpd, submit) = cd.getClaimOfEmergencyPauseByIndex(i);
10123       require(submit == false);
10124       qadd = qd.getCoverMemberAddress(coverId);
10125       _addClaim(coverId, dateUpd, qadd);
10126       cd.setClaimSubmittedAtEPTrue(i, true);
10127     }
10128     cd.setFirstClaimIndexToSubmitAfterEP(lengthOfClaimSubmittedAtEP);
10129   }
10130 
10131   /**
10132    * @dev Castes vote for members who have tokens locked under Claims Assessment
10133    * @param claimId  claim id.
10134    * @param verdict 1 for Accept,-1 for Deny.
10135    */
10136   function submitCAVote(uint claimId, int8 verdict) public isMemberAndcheckPause {
10137     require(checkVoteClosing(claimId) != 1);
10138     require(cd.userClaimVotePausedOn(msg.sender).add(cd.pauseDaysCA()) < now);
10139     uint tokens = tc.tokensLockedAtTime(msg.sender, "CLA", now.add(cd.claimDepositTime()));
10140     require(tokens > 0);
10141     uint stat;
10142     (, stat) = cd.getClaimStatusNumber(claimId);
10143     require(stat == 0);
10144     require(cd.getUserClaimVoteCA(msg.sender, claimId) == 0);
10145     td.bookCATokens(msg.sender);
10146     cd.addVote(msg.sender, tokens, claimId, verdict);
10147     cd.callVoteEvent(msg.sender, claimId, "CAV", tokens, now, verdict);
10148     uint voteLength = cd.getAllVoteLength();
10149     cd.addClaimVoteCA(claimId, voteLength);
10150     cd.setUserClaimVoteCA(msg.sender, claimId, voteLength);
10151     cd.setClaimTokensCA(claimId, verdict, tokens);
10152     tc.extendLockOf(msg.sender, "CLA", td.lockCADays());
10153     int close = checkVoteClosing(claimId);
10154     if (close == 1) {
10155       cr.changeClaimStatus(claimId);
10156     }
10157   }
10158 
10159   /**
10160    * @dev Submits a member vote for assessing a claim.
10161    * Tokens other than those locked under Claims
10162    * Assessment can be used to cast a vote for a given claim id.
10163    * @param claimId Selected claim id.
10164    * @param verdict 1 for Accept,-1 for Deny.
10165    */
10166   function submitMemberVote(uint claimId, int8 verdict) public isMemberAndcheckPause {
10167     require(checkVoteClosing(claimId) != 1);
10168     uint stat;
10169     uint tokens = tc.totalBalanceOf(msg.sender);
10170     (, stat) = cd.getClaimStatusNumber(claimId);
10171     require(stat >= 1 && stat <= 5);
10172     require(cd.getUserClaimVoteMember(msg.sender, claimId) == 0);
10173     cd.addVote(msg.sender, tokens, claimId, verdict);
10174     cd.callVoteEvent(msg.sender, claimId, "MV", tokens, now, verdict);
10175     tc.lockForMemberVote(msg.sender, td.lockMVDays());
10176     uint voteLength = cd.getAllVoteLength();
10177     cd.addClaimVotemember(claimId, voteLength);
10178     cd.setUserClaimVoteMember(msg.sender, claimId, voteLength);
10179     cd.setClaimTokensMV(claimId, verdict, tokens);
10180     int close = checkVoteClosing(claimId);
10181     if (close == 1) {
10182       cr.changeClaimStatus(claimId);
10183     }
10184   }
10185 
10186   /**
10187   * @dev Pause Voting of All Pending Claims when Emergency Pause Start.
10188   */
10189   function pauseAllPendingClaimsVoting() public onlyInternal {
10190     uint firstIndex = cd.pendingClaimStart();
10191     uint actualClaimLength = cd.actualClaimLength();
10192     for (uint i = firstIndex; i < actualClaimLength; i++) {
10193       if (checkVoteClosing(i) == 0) {
10194         uint dateUpd = cd.getClaimDateUpd(i);
10195         cd.setPendingClaimDetails(i, (dateUpd.add(cd.maxVotingTime())).sub(now), false);
10196       }
10197     }
10198   }
10199 
10200   /**
10201    * @dev Resume the voting phase of all Claims paused due to an emergency pause.
10202    */
10203   function startAllPendingClaimsVoting() public onlyInternal {
10204     uint firstIndx = cd.getFirstClaimIndexToStartVotingAfterEP();
10205     uint i;
10206     uint lengthOfClaimVotingPause = cd.getLengthOfClaimVotingPause();
10207     for (i = firstIndx; i < lengthOfClaimVotingPause; i++) {
10208       uint pendingTime;
10209       uint claimID;
10210       (claimID, pendingTime,) = cd.getPendingClaimDetailsByIndex(i);
10211       uint pTime = (now.sub(cd.maxVotingTime())).add(pendingTime);
10212       cd.setClaimdateUpd(claimID, pTime);
10213       cd.setPendingClaimVoteStatus(i, true);
10214       uint coverid;
10215       (, coverid) = cd.getClaimCoverId(claimID);
10216       address qadd = qd.getCoverMemberAddress(coverid);
10217       tf.extendCNEPOff(qadd, coverid, pendingTime.add(cd.claimDepositTime()));
10218       p1.closeClaimsOraclise(claimID, uint64(pTime));
10219     }
10220     cd.setFirstClaimIndexToStartVotingAfterEP(i);
10221   }
10222 
10223   /**
10224    * @dev Checks if voting of a claim should be closed or not.
10225    * @param claimId Claim Id.
10226    * @return close 1 -> voting should be closed, 0 -> if voting should not be closed,
10227    * -1 -> voting has already been closed.
10228    */
10229   function checkVoteClosing(uint claimId) public view returns (int8 close) {
10230     close = 0;
10231     uint status;
10232     (, status) = cd.getClaimStatusNumber(claimId);
10233     uint dateUpd = cd.getClaimDateUpd(claimId);
10234     if (status == 12 && dateUpd.add(cd.payoutRetryTime()) < now) {
10235       if (cd.getClaimState12Count(claimId) < 60)
10236         close = 1;
10237     }
10238 
10239     if (status > 5 && status != 12) {
10240       close = - 1;
10241     } else if (status != 12 && dateUpd.add(cd.maxVotingTime()) <= now) {
10242       close = 1;
10243     } else if (status != 12 && dateUpd.add(cd.minVotingTime()) >= now) {
10244       close = 0;
10245     } else if (status == 0 || (status >= 1 && status <= 5)) {
10246       close = _checkVoteClosingFinal(claimId, status);
10247     }
10248 
10249   }
10250 
10251   /**
10252    * @dev Checks if voting of a claim should be closed or not.
10253    * Internally called by checkVoteClosing method
10254    * for Claims whose status number is 0 or status number lie between 2 and 6.
10255    * @param claimId Claim Id.
10256    * @param status Current status of claim.
10257    * @return close 1 if voting should be closed,0 in case voting should not be closed,
10258    * -1 if voting has already been closed.
10259    */
10260   function _checkVoteClosingFinal(uint claimId, uint status) internal view returns (int8 close) {
10261     close = 0;
10262     uint coverId;
10263     (, coverId) = cd.getClaimCoverId(claimId);
10264     bytes4 curr = qd.getCurrencyOfCover(coverId);
10265     uint tokenx1e18 = m1.calculateTokenPrice(curr);
10266     uint accept;
10267     uint deny;
10268     (, accept, deny) = cd.getClaimsTokenCA(claimId);
10269     uint caTokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18);
10270     (, accept, deny) = cd.getClaimsTokenMV(claimId);
10271     uint mvTokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18);
10272     uint sumassured = qd.getCoverSumAssured(coverId).mul(DECIMAL1E18);
10273     if (status == 0 && caTokens >= sumassured.mul(10)) {
10274       close = 1;
10275     } else if (status >= 1 && status <= 5 && mvTokens >= sumassured.mul(10)) {
10276       close = 1;
10277     }
10278   }
10279 
10280   /**
10281    * @dev Changes the status of an existing claim id, based on current
10282    * status and current conditions of the system
10283    * @param claimId Claim Id.
10284    * @param stat status number.
10285    */
10286   function _setClaimStatus(uint claimId, uint stat) internal {
10287 
10288     uint origstat;
10289     uint state12Count;
10290     uint dateUpd;
10291     uint coverId;
10292     (, coverId, , origstat, dateUpd, state12Count) = cd.getClaim(claimId);
10293     (, origstat) = cd.getClaimStatusNumber(claimId);
10294 
10295     if (stat == 12 && origstat == 12) {
10296       cd.updateState12Count(claimId, 1);
10297     }
10298     cd.setClaimStatus(claimId, stat);
10299 
10300     if (state12Count >= 60 && stat == 12) {
10301       cd.setClaimStatus(claimId, 13);
10302       qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.ClaimDenied));
10303     }
10304     uint time = now;
10305     cd.setClaimdateUpd(claimId, time);
10306 
10307     if (stat >= 2 && stat <= 5) {
10308       p1.closeClaimsOraclise(claimId, cd.maxVotingTime());
10309     }
10310 
10311     if (stat == 12 && (dateUpd.add(cd.payoutRetryTime()) <= now) && (state12Count < 60)) {
10312       p1.closeClaimsOraclise(claimId, cd.payoutRetryTime());
10313     } else if (stat == 12 && (dateUpd.add(cd.payoutRetryTime()) > now) && (state12Count < 60)) {
10314       uint64 timeLeft = uint64((dateUpd.add(cd.payoutRetryTime())).sub(now));
10315       p1.closeClaimsOraclise(claimId, timeLeft);
10316     }
10317   }
10318 
10319   /**
10320    * @dev Submits a claim for a given cover note.
10321    * Set deposits flag against cover.
10322    */
10323   function _addClaim(uint coverId, uint time, address add) internal {
10324     tf.depositCN(coverId);
10325     uint len = cd.actualClaimLength();
10326     cd.addClaim(len, coverId, add, now);
10327     cd.callClaimEvent(coverId, add, len, time);
10328     qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.ClaimSubmitted));
10329     bytes4 curr = qd.getCurrencyOfCover(coverId);
10330     uint sumAssured = qd.getCoverSumAssured(coverId).mul(DECIMAL1E18);
10331     pd.changeCurrencyAssetVarMin(curr, pd.getCurrencyAssetVarMin(curr).add(sumAssured));
10332     p2.internalLiquiditySwap(curr);
10333     p1.closeClaimsOraclise(len, cd.maxVotingTime());
10334   }
10335 }
10336 
10337 // File: contracts/modules/capital/Pool1.sol
10338 
10339 /* Copyright (C) 2020 NexusMutual.io
10340 
10341   This program is free software: you can redistribute it and/or modify
10342     it under the terms of the GNU General Public License as published by
10343     the Free Software Foundation, either version 3 of the License, or
10344     (at your option) any later version.
10345 
10346   This program is distributed in the hope that it will be useful,
10347     but WITHOUT ANY WARRANTY; without even the implied warranty of
10348     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10349     GNU General Public License for more details.
10350 
10351   You should have received a copy of the GNU General Public License
10352     along with this program.  If not, see http://www.gnu.org/licenses/ */
10353 
10354 pragma solidity ^0.5.0;
10355 
10356 
10357 
10358 
10359 
10360 
10361 
10362 
10363 contract Pool1 is Iupgradable {
10364   using SafeMath for uint;
10365 
10366   Quotation internal q2;
10367   NXMToken internal tk;
10368   TokenController internal tc;
10369   TokenFunctions internal tf;
10370   Pool2 internal p2;
10371   PoolData internal pd;
10372   MCR internal m1;
10373   Claims public c1;
10374   TokenData internal td;
10375   bool internal locked;
10376 
10377   uint internal constant DECIMAL1E18 = uint(10) ** 18;
10378 
10379   event Apiresult(address indexed sender, string msg, bytes32 myid);
10380   event Payout(address indexed to, uint coverId, uint tokens);
10381 
10382   modifier noReentrancy() {
10383     require(!locked, "Reentrant call.");
10384     locked = true;
10385     _;
10386     locked = false;
10387   }
10388 
10389   function() external payable {} // solhint-disable-line
10390 
10391   /**
10392    * @dev Pays out the sum assured in case a claim is accepted
10393    * @param coverid Cover Id.
10394    * @param claimid Claim Id.
10395    * @return succ true if payout is successful, false otherwise.
10396    */
10397   function sendClaimPayout(
10398     uint coverid,
10399     uint claimid,
10400     uint sumAssured,
10401     address payable coverHolder,
10402     bytes4 coverCurr
10403   )
10404   external
10405   onlyInternal
10406   noReentrancy
10407   returns (bool succ)
10408   {
10409 
10410     uint sa = sumAssured.div(DECIMAL1E18);
10411     bool check;
10412     IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
10413 
10414     //Payout
10415     if (coverCurr == "ETH" && address(this).balance >= sumAssured) {
10416       // check = _transferCurrencyAsset(coverCurr, coverHolder, sumAssured);
10417       coverHolder.transfer(sumAssured);
10418       check = true;
10419     } else if (coverCurr == "DAI" && erc20.balanceOf(address(this)) >= sumAssured) {
10420       erc20.transfer(coverHolder, sumAssured);
10421       check = true;
10422     }
10423 
10424     if (check == true) {
10425       q2.removeSAFromCSA(coverid, sa);
10426       pd.changeCurrencyAssetVarMin(coverCurr,
10427         pd.getCurrencyAssetVarMin(coverCurr).sub(sumAssured));
10428       emit Payout(coverHolder, coverid, sumAssured);
10429       succ = true;
10430     } else {
10431       c1.setClaimStatus(claimid, 12);
10432     }
10433 
10434     // _triggerExternalLiquidityTrade();
10435     // p2.internalLiquiditySwap(coverCurr);
10436 
10437     tf.burnStakerLockedToken(coverid, coverCurr, sumAssured);
10438   }
10439 
10440   function triggerExternalLiquidityTrade() external onlyInternal {
10441     // deprecated
10442   }
10443 
10444   ///@dev Oraclize call to close emergency pause.
10445   function closeEmergencyPause(uint) external onlyInternal {
10446     _saveQueryId("EP", 0);
10447   }
10448 
10449   function closeClaimsOraclise(uint, uint) external onlyInternal {
10450     // deprecated
10451   }
10452 
10453   function closeCoverOraclise(uint, uint64) external onlyInternal {
10454     // deprecated
10455   }
10456 
10457   function mcrOraclise(uint) external onlyInternal {
10458     // deprecated
10459   }
10460 
10461   function mcrOracliseFail(uint, uint) external onlyInternal {
10462     // deprecated
10463   }
10464 
10465   function saveIADetailsOracalise(uint) external onlyInternal {
10466     // deprecated
10467   }
10468 
10469   /**
10470    * @dev Save the details of the current request for a future call
10471    * @param _typeof type of the query
10472    * @param id ID of the proposal, quote, cover etc. for which call is made
10473    */
10474   function _saveQueryId(bytes4 _typeof, uint id) internal {
10475 
10476     uint queryId = block.timestamp;
10477     bytes32 myid = bytes32(queryId);
10478 
10479     while (pd.getDateAddOfAPI(myid) != 0) {
10480       myid = bytes32(++queryId);
10481     }
10482 
10483     pd.saveApiDetails(myid, _typeof, id);
10484     pd.addInAllApiCall(myid);
10485   }
10486 
10487   /**
10488    * @dev Transfers all assest (i.e ETH balance, Currency Assest) from old Pool to new Pool
10489    * @param newPoolAddress Address of the new Pool
10490    */
10491   function upgradeCapitalPool(address payable newPoolAddress) external noReentrancy onlyInternal {
10492     for (uint64 i = 1; i < pd.getAllCurrenciesLen(); i++) {
10493       bytes4 caName = pd.getCurrenciesByIndex(i);
10494       _upgradeCapitalPool(caName, newPoolAddress);
10495     }
10496     if (address(this).balance > 0) {
10497       Pool1 newP1 = Pool1(newPoolAddress);
10498       newP1.sendEther.value(address(this).balance)();
10499     }
10500   }
10501 
10502   /**
10503    * @dev Iupgradable Interface to update dependent contract address
10504    */
10505   function changeDependentContractAddress() public {
10506     m1 = MCR(ms.getLatestAddress("MC"));
10507     tk = NXMToken(ms.tokenAddress());
10508     tf = TokenFunctions(ms.getLatestAddress("TF"));
10509     tc = TokenController(ms.getLatestAddress("TC"));
10510     pd = PoolData(ms.getLatestAddress("PD"));
10511     q2 = Quotation(ms.getLatestAddress("QT"));
10512     p2 = Pool2(ms.getLatestAddress("P2"));
10513     c1 = Claims(ms.getLatestAddress("CL"));
10514     td = TokenData(ms.getLatestAddress("TD"));
10515   }
10516 
10517   function sendEther() public payable {
10518 
10519   }
10520 
10521   /**
10522    * @dev transfers currency asset to an address
10523    * @param curr is the currency of currency asset to transfer
10524    * @param amount is amount of currency asset to transfer
10525    * @return boolean to represent success or failure
10526    */
10527   function transferCurrencyAsset(
10528     bytes4 curr,
10529     uint amount
10530   )
10531   public
10532   onlyInternal
10533   noReentrancy
10534   returns (bool)
10535   {
10536 
10537     return _transferCurrencyAsset(curr, amount);
10538   }
10539 
10540   /// @dev Handles callback of external oracle query.
10541   function __callback(bytes32 myid, string memory result) public {
10542     result; // silence compiler warning
10543     ms.delegateCallBack(myid);
10544   }
10545 
10546   /// @dev Enables user to purchase cover with funding in ETH.
10547   /// @param smartCAdd Smart Contract Address
10548   function makeCoverBegin(
10549     address smartCAdd,
10550     bytes4 coverCurr,
10551     uint[] memory coverDetails,
10552     uint16 coverPeriod,
10553     uint8 _v,
10554     bytes32 _r,
10555     bytes32 _s
10556   ) public isMember checkPause payable {
10557     require(msg.value == coverDetails[1]);
10558     q2.verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
10559   }
10560 
10561   /**
10562    * @dev Enables user to purchase cover via currency asset eg DAI
10563    */
10564   function makeCoverUsingCA(
10565     address smartCAdd,
10566     bytes4 coverCurr,
10567     uint[] memory coverDetails,
10568     uint16 coverPeriod,
10569     uint8 _v,
10570     bytes32 _r,
10571     bytes32 _s
10572   ) public isMember checkPause {
10573     IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
10574     require(erc20.transferFrom(msg.sender, address(this), coverDetails[1]), "Transfer failed");
10575     q2.verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
10576   }
10577 
10578   /// @dev Enables user to purchase NXM at the current token price.
10579   function buyToken() public payable isMember checkPause returns (bool success) {
10580     require(msg.value > 0);
10581     uint tokenPurchased = _getToken(address(this).balance, msg.value);
10582     tc.mint(msg.sender, tokenPurchased);
10583     success = true;
10584   }
10585 
10586   /// @dev Sends a given amount of Ether to a given address.
10587   /// @param amount amount (in wei) to send.
10588   /// @param _add Receiver's address.
10589   /// @return succ True if transfer is a success, otherwise False.
10590   function transferEther(uint amount, address payable _add) public noReentrancy checkPause returns (bool succ) {
10591     require(ms.checkIsAuthToGoverned(msg.sender), "Not authorized to Govern");
10592     succ = _add.send(amount);
10593   }
10594 
10595   /**
10596    * @dev Allows selling of NXM for ether.
10597    * Seller first needs to give this contract allowance to
10598    * transfer/burn tokens in the NXMToken contract
10599    * @param  _amount Amount of NXM to sell
10600    * @return success returns true on successfull sale
10601    */
10602   function sellNXMTokens(uint _amount) public isMember noReentrancy checkPause returns (bool success) {
10603     require(tk.balanceOf(msg.sender) >= _amount, "Not enough balance");
10604     require(!tf.isLockedForMemberVote(msg.sender), "Member voted");
10605     require(_amount <= m1.getMaxSellTokens(), "exceeds maximum token sell limit");
10606     uint sellingPrice = _getWei(_amount);
10607     tc.burnFrom(msg.sender, _amount);
10608     msg.sender.transfer(sellingPrice);
10609     success = true;
10610   }
10611 
10612   /**
10613    * @dev gives the investment asset balance
10614    * @return investment asset balance
10615    */
10616   function getInvestmentAssetBalance() public view returns (uint balance) {
10617     IERC20 erc20;
10618     uint currTokens;
10619     for (uint i = 1; i < pd.getInvestmentCurrencyLen(); i++) {
10620       bytes4 currency = pd.getInvestmentCurrencyByIndex(i);
10621       erc20 = IERC20(pd.getInvestmentAssetAddress(currency));
10622       currTokens = erc20.balanceOf(address(p2));
10623       if (pd.getIAAvgRate(currency) > 0)
10624         balance = balance.add((currTokens.mul(100)).div(pd.getIAAvgRate(currency)));
10625     }
10626 
10627     balance = balance.add(address(p2).balance);
10628   }
10629 
10630   /**
10631    * @dev Returns the amount of wei a seller will get for selling NXM
10632    * @param amount Amount of NXM to sell
10633    * @return weiToPay Amount of wei the seller will get
10634    */
10635   function getWei(uint amount) public view returns (uint weiToPay) {
10636     return _getWei(amount);
10637   }
10638 
10639   /**
10640    * @dev Returns the amount of token a buyer will get for corresponding wei
10641    * @param weiPaid Amount of wei
10642    * @return tokenToGet Amount of tokens the buyer will get
10643    */
10644   function getToken(uint weiPaid) public view returns (uint tokenToGet) {
10645     return _getToken((address(this).balance).add(weiPaid), weiPaid);
10646   }
10647 
10648   /**
10649    * @dev Returns the amount of wei a seller will get for selling NXM
10650    * @param _amount Amount of NXM to sell
10651    * @return weiToPay Amount of wei the seller will get
10652    */
10653   function _getWei(uint _amount) internal view returns (uint weiToPay) {
10654     uint tokenPrice;
10655     uint weiPaid;
10656     uint tokenSupply = tk.totalSupply();
10657     uint vtp;
10658     uint mcrFullperc;
10659     uint vFull;
10660     uint mcrtp;
10661     (mcrFullperc, , vFull,) = pd.getLastMCR();
10662     (vtp,) = m1.calVtpAndMCRtp();
10663 
10664     while (_amount > 0) {
10665       mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
10666       tokenPrice = m1.calculateStepTokenPrice("ETH", mcrtp);
10667       tokenPrice = (tokenPrice.mul(975)).div(1000); // 97.5%
10668       if (_amount <= td.priceStep().mul(DECIMAL1E18)) {
10669         weiToPay = weiToPay.add((tokenPrice.mul(_amount)).div(DECIMAL1E18));
10670         break;
10671       } else {
10672         _amount = _amount.sub(td.priceStep().mul(DECIMAL1E18));
10673         tokenSupply = tokenSupply.sub(td.priceStep().mul(DECIMAL1E18));
10674         weiPaid = (tokenPrice.mul(td.priceStep().mul(DECIMAL1E18))).div(DECIMAL1E18);
10675         vtp = vtp.sub(weiPaid);
10676         weiToPay = weiToPay.add(weiPaid);
10677       }
10678     }
10679   }
10680 
10681   /**
10682    * @dev gives the token
10683    * @param _poolBalance is the pool balance
10684    * @param _weiPaid is the amount paid in wei
10685    * @return the token to get
10686    */
10687   function _getToken(uint _poolBalance, uint _weiPaid) internal view returns (uint tokenToGet) {
10688     uint tokenPrice;
10689     uint superWeiLeft = (_weiPaid).mul(DECIMAL1E18);
10690     uint tempTokens;
10691     uint superWeiSpent;
10692     uint tokenSupply = tk.totalSupply();
10693     uint vtp;
10694     uint mcrFullperc;
10695     uint vFull;
10696     uint mcrtp;
10697     (mcrFullperc, , vFull,) = pd.getLastMCR();
10698     (vtp,) = m1.calculateVtpAndMCRtp((_poolBalance).sub(_weiPaid));
10699 
10700     require(m1.calculateTokenPrice("ETH") > 0, "Token price can not be zero");
10701     while (superWeiLeft > 0) {
10702       mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
10703       tokenPrice = m1.calculateStepTokenPrice("ETH", mcrtp);
10704       tempTokens = superWeiLeft.div(tokenPrice);
10705       if (tempTokens <= td.priceStep().mul(DECIMAL1E18)) {
10706         tokenToGet = tokenToGet.add(tempTokens);
10707         break;
10708       } else {
10709         tokenToGet = tokenToGet.add(td.priceStep().mul(DECIMAL1E18));
10710         tokenSupply = tokenSupply.add(td.priceStep().mul(DECIMAL1E18));
10711         superWeiSpent = td.priceStep().mul(DECIMAL1E18).mul(tokenPrice);
10712         superWeiLeft = superWeiLeft.sub(superWeiSpent);
10713         vtp = vtp.add((td.priceStep().mul(DECIMAL1E18).mul(tokenPrice)).div(DECIMAL1E18));
10714       }
10715     }
10716   }
10717 
10718   /**
10719    * @dev transfers currency asset
10720    * @param _curr is currency of asset to transfer
10721    * @param _amount is the amount to be transferred
10722    * @return boolean representing the success of transfer
10723    */
10724   function _transferCurrencyAsset(bytes4 _curr, uint _amount) internal returns (bool succ) {
10725     if (_curr == "ETH") {
10726       if (address(this).balance < _amount)
10727         _amount = address(this).balance;
10728       p2.sendEther.value(_amount)();
10729       succ = true;
10730     } else {
10731       IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr)); // solhint-disable-line
10732       if (erc20.balanceOf(address(this)) < _amount)
10733         _amount = erc20.balanceOf(address(this));
10734       require(erc20.transfer(address(p2), _amount));
10735       succ = true;
10736 
10737     }
10738   }
10739 
10740   /**
10741    * @dev Transfers ERC20 Currency asset from this Pool to another Pool on upgrade.
10742    */
10743   function _upgradeCapitalPool(
10744     bytes4 _curr,
10745     address _newPoolAddress
10746   )
10747   internal
10748   {
10749     IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr));
10750     if (erc20.balanceOf(address(this)) > 0)
10751       require(erc20.transfer(_newPoolAddress, erc20.balanceOf(address(this))));
10752   }
10753 
10754 }
