1 pragma solidity 0.5.7;
2 
3 
4 /* Copyright (C) 2017 NexusMutual.io
5 
6   This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11   This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16   You should have received a copy of the GNU General Public License
17     along with this program.  If not, see http://www.gnu.org/licenses/ */
18 contract INXMMaster {
19 
20     address public tokenAddress;
21 
22     address public owner;
23 
24 
25     uint public pauseTime;
26 
27     function delegateCallBack(bytes32 myid) external;
28 
29     function masterInitialized() public view returns(bool);
30     
31     function isInternal(address _add) public view returns(bool);
32 
33     function isPause() public view returns(bool check);
34 
35     function isOwner(address _add) public view returns(bool);
36 
37     function isMember(address _add) public view returns(bool);
38     
39     function checkIsAuthToGoverned(address _add) public view returns(bool);
40 
41     function updatePauseTime(uint _time) public;
42 
43     function dAppLocker() public view returns(address _add);
44 
45     function dAppToken() public view returns(address _add);
46 
47     function getLatestAddress(bytes2 _contractName) public view returns(address payable contractAddress);
48 }
49 
50 contract Iupgradable {
51 
52     INXMMaster public ms;
53     address public nxMasterAddress;
54 
55     modifier onlyInternal {
56         require(ms.isInternal(msg.sender));
57         _;
58     }
59 
60     modifier isMemberAndcheckPause {
61         require(ms.isPause() == false && ms.isMember(msg.sender) == true);
62         _;
63     }
64 
65     modifier onlyOwner {
66         require(ms.isOwner(msg.sender));
67         _;
68     }
69 
70     modifier checkPause {
71         require(ms.isPause() == false);
72         _;
73     }
74 
75     modifier isMember {
76         require(ms.isMember(msg.sender), "Not member");
77         _;
78     }
79 
80     /**
81      * @dev Iupgradable Interface to update dependent contract address
82      */
83     function  changeDependentContractAddress() public;
84 
85     /**
86      * @dev change master address
87      * @param _masterAddress is the new address
88      */
89     function changeMasterAddress(address _masterAddress) public {
90         if (address(ms) != address(0)) {
91             require(address(ms) == msg.sender, "Not master");
92         }
93         ms = INXMMaster(_masterAddress);
94         nxMasterAddress = _masterAddress;
95     }
96 
97 }
98 
99 /**
100  * @title SafeMath
101  * @dev Math operations with safety checks that revert on error
102  */
103 library SafeMath {
104 
105     /**
106     * @dev Multiplies two numbers, reverts on overflow.
107     */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b);
118 
119         return c;
120     }
121 
122     /**
123     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
124     */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b > 0); // Solidity only automatically asserts when dividing by 0
127         uint256 c = a / b;
128         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129 
130         return c;
131     }
132 
133     /**
134     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
135     */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b <= a);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144     * @dev Adds two numbers, reverts on overflow.
145     */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         require(c >= a);
149 
150         return c;
151     }
152 
153     /**
154     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
155     * reverts when dividing by zero.
156     */
157     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158         require(b != 0);
159         return a % b;
160     }
161 }
162 
163 /* Copyright (C) 2017 NexusMutual.io
164 
165   This program is free software: you can redistribute it and/or modify
166     it under the terms of the GNU General Public License as published by
167     the Free Software Foundation, either version 3 of the License, or
168     (at your option) any later version.
169 
170   This program is distributed in the hope that it will be useful,
171     but WITHOUT ANY WARRANTY; without even the implied warranty of
172     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
173     GNU General Public License for more details.
174 
175   You should have received a copy of the GNU General Public License
176     along with this program.  If not, see http://www.gnu.org/licenses/ */
177 contract QuotationData is Iupgradable {
178     using SafeMath for uint;
179 
180     enum HCIDStatus { NA, kycPending, kycPass, kycFailedOrRefunded, kycPassNoCover }
181 
182     enum CoverStatus { Active, ClaimAccepted, ClaimDenied, CoverExpired, ClaimSubmitted, Requested }
183 
184     struct Cover {
185         address payable memberAddress;
186         bytes4 currencyCode;
187         uint sumAssured;
188         uint16 coverPeriod;
189         uint validUntil;
190         address scAddress;
191         uint premiumNXM;
192     }
193 
194     struct HoldCover {
195         uint holdCoverId;
196         address payable userAddress;
197         address scAddress;
198         bytes4 coverCurr;
199         uint[] coverDetails;
200         uint16 coverPeriod;
201     }
202 
203     address public authQuoteEngine;
204   
205     mapping(bytes4 => uint) internal currencyCSA;
206     mapping(address => uint[]) internal userCover;
207     mapping(address => uint[]) public userHoldedCover;
208     mapping(address => bool) public refundEligible;
209     mapping(address => mapping(bytes4 => uint)) internal currencyCSAOfSCAdd;
210     mapping(uint => uint8) public coverStatus;
211     mapping(uint => uint) public holdedCoverIDStatus;
212     mapping(uint => bool) public timestampRepeated; 
213     
214 
215     Cover[] internal allCovers;
216     HoldCover[] internal allCoverHolded;
217 
218     uint public stlp;
219     uint public stl;
220     uint public pm;
221     uint public minDays;
222     uint public tokensRetained;
223     address public kycAuthAddress;
224 
225     event CoverDetailsEvent(
226         uint indexed cid,
227         address scAdd,
228         uint sumAssured,
229         uint expiry,
230         uint premium,
231         uint premiumNXM,
232         bytes4 curr
233     );
234 
235     event CoverStatusEvent(uint indexed cid, uint8 statusNum);
236 
237     constructor(address _authQuoteAdd, address _kycAuthAdd) public {
238         authQuoteEngine = _authQuoteAdd;
239         kycAuthAddress = _kycAuthAdd;
240         stlp = 90;
241         stl = 100;
242         pm = 30;
243         minDays = 30;
244         tokensRetained = 10;
245         allCovers.push(Cover(address(0), "0x00", 0, 0, 0, address(0), 0));
246         uint[] memory arr = new uint[](1);
247         allCoverHolded.push(HoldCover(0, address(0), address(0), 0x00, arr, 0));
248 
249     }
250     
251     /// @dev Adds the amount in Total Sum Assured of a given currency of a given smart contract address.
252     /// @param _add Smart Contract Address.
253     /// @param _amount Amount to be added.
254     function addInTotalSumAssuredSC(address _add, bytes4 _curr, uint _amount) external onlyInternal {
255         currencyCSAOfSCAdd[_add][_curr] = currencyCSAOfSCAdd[_add][_curr].add(_amount);
256     }
257 
258     /// @dev Subtracts the amount from Total Sum Assured of a given currency and smart contract address.
259     /// @param _add Smart Contract Address.
260     /// @param _amount Amount to be subtracted.
261     function subFromTotalSumAssuredSC(address _add, bytes4 _curr, uint _amount) external onlyInternal {
262         currencyCSAOfSCAdd[_add][_curr] = currencyCSAOfSCAdd[_add][_curr].sub(_amount);
263     }
264     
265     /// @dev Subtracts the amount from Total Sum Assured of a given currency.
266     /// @param _curr Currency Name.
267     /// @param _amount Amount to be subtracted.
268     function subFromTotalSumAssured(bytes4 _curr, uint _amount) external onlyInternal {
269         currencyCSA[_curr] = currencyCSA[_curr].sub(_amount);
270     }
271 
272     /// @dev Adds the amount in Total Sum Assured of a given currency.
273     /// @param _curr Currency Name.
274     /// @param _amount Amount to be added.
275     function addInTotalSumAssured(bytes4 _curr, uint _amount) external onlyInternal {
276         currencyCSA[_curr] = currencyCSA[_curr].add(_amount);
277     }
278 
279     /// @dev sets bit for timestamp to avoid replay attacks.
280     function setTimestampRepeated(uint _timestamp) external onlyInternal {
281         timestampRepeated[_timestamp] = true;
282     }
283     
284     /// @dev Creates a blank new cover.
285     function addCover(
286         uint16 _coverPeriod,
287         uint _sumAssured,
288         address payable _userAddress,
289         bytes4 _currencyCode,
290         address _scAddress,
291         uint premium,
292         uint premiumNXM
293     )   
294         external
295         onlyInternal
296     {
297         uint expiryDate = now.add(uint(_coverPeriod).mul(1 days));
298         allCovers.push(Cover(_userAddress, _currencyCode,
299                 _sumAssured, _coverPeriod, expiryDate, _scAddress, premiumNXM));
300         uint cid = allCovers.length.sub(1);
301         userCover[_userAddress].push(cid);
302         emit CoverDetailsEvent(cid, _scAddress, _sumAssured, expiryDate, premium, premiumNXM, _currencyCode);
303     }
304 
305     /// @dev create holded cover which will process after verdict of KYC.
306     function addHoldCover(
307         address payable from,
308         address scAddress,
309         bytes4 coverCurr, 
310         uint[] calldata coverDetails,
311         uint16 coverPeriod
312     )   
313         external
314         onlyInternal
315     {
316         uint holdedCoverLen = allCoverHolded.length;
317         holdedCoverIDStatus[holdedCoverLen] = uint(HCIDStatus.kycPending);             
318         allCoverHolded.push(HoldCover(holdedCoverLen, from, scAddress, 
319             coverCurr, coverDetails, coverPeriod));
320         userHoldedCover[from].push(allCoverHolded.length.sub(1));
321     
322     }
323 
324     ///@dev sets refund eligible bit.
325     ///@param _add user address.
326     ///@param status indicates if user have pending kyc.
327     function setRefundEligible(address _add, bool status) external onlyInternal {
328         refundEligible[_add] = status;
329     }
330 
331     /// @dev to set current status of particular holded coverID (1 for not completed KYC,
332     /// 2 for KYC passed, 3 for failed KYC or full refunded,
333     /// 4 for KYC completed but cover not processed)
334     function setHoldedCoverIDStatus(uint holdedCoverID, uint status) external onlyInternal {
335         holdedCoverIDStatus[holdedCoverID] = status;
336     }
337 
338     /**
339      * @dev to set address of kyc authentication 
340      * @param _add is the new address
341      */
342     function setKycAuthAddress(address _add) external onlyInternal {
343         kycAuthAddress = _add;
344     }
345 
346     /// @dev Changes authorised address for generating quote off chain.
347     function changeAuthQuoteEngine(address _add) external onlyInternal {
348         authQuoteEngine = _add;
349     }
350 
351     /**
352      * @dev Gets Uint Parameters of a code
353      * @param code whose details we want
354      * @return string value of the code
355      * @return associated amount (time or perc or value) to the code
356      */
357     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
358         codeVal = code;
359 
360         if (code == "STLP") {
361             val = stlp;
362 
363         } else if (code == "STL") {
364             
365             val = stl;
366 
367         } else if (code == "PM") {
368 
369             val = pm;
370 
371         } else if (code == "QUOMIND") {
372 
373             val = minDays;
374 
375         } else if (code == "QUOTOK") {
376 
377             val = tokensRetained;
378 
379         }
380         
381     }
382 
383     /// @dev Gets Product details.
384     /// @return  _minDays minimum cover period.
385     /// @return  _PM Profit margin.
386     /// @return  _STL short term Load.
387     /// @return  _STLP short term load period.
388     function getProductDetails()
389         external
390         view
391         returns (
392             uint _minDays,
393             uint _pm,
394             uint _stl,
395             uint _stlp
396         )
397     {
398 
399         _minDays = minDays;
400         _pm = pm;
401         _stl = stl;
402         _stlp = stlp;
403     }
404 
405     /// @dev Gets total number covers created till date.
406     function getCoverLength() external view returns(uint len) {
407         return (allCovers.length);
408     }
409 
410     /// @dev Gets Authorised Engine address.
411     function getAuthQuoteEngine() external view returns(address _add) {
412         _add = authQuoteEngine;
413     }
414 
415     /// @dev Gets the Total Sum Assured amount of a given currency.
416     function getTotalSumAssured(bytes4 _curr) external view returns(uint amount) {
417         amount = currencyCSA[_curr];
418     }
419 
420     /// @dev Gets all the Cover ids generated by a given address.
421     /// @param _add User's address.
422     /// @return allCover array of covers.
423     function getAllCoversOfUser(address _add) external view returns(uint[] memory allCover) {
424         return (userCover[_add]);
425     }
426 
427     /// @dev Gets total number of covers generated by a given address
428     function getUserCoverLength(address _add) external view returns(uint len) {
429         len = userCover[_add].length;
430     }
431 
432     /// @dev Gets the status of a given cover.
433     function getCoverStatusNo(uint _cid) external view returns(uint8) {
434         return coverStatus[_cid];
435     }
436 
437     /// @dev Gets the Cover Period (in days) of a given cover.
438     function getCoverPeriod(uint _cid) external view returns(uint32 cp) {
439         cp = allCovers[_cid].coverPeriod;
440     }
441 
442     /// @dev Gets the Sum Assured Amount of a given cover.
443     function getCoverSumAssured(uint _cid) external view returns(uint sa) {
444         sa = allCovers[_cid].sumAssured;
445     }
446 
447     /// @dev Gets the Currency Name in which a given cover is assured.
448     function getCurrencyOfCover(uint _cid) external view returns(bytes4 curr) {
449         curr = allCovers[_cid].currencyCode;
450     }
451 
452     /// @dev Gets the validity date (timestamp) of a given cover.
453     function getValidityOfCover(uint _cid) external view returns(uint date) {
454         date = allCovers[_cid].validUntil;
455     }
456 
457     /// @dev Gets Smart contract address of cover.
458     function getscAddressOfCover(uint _cid) external view returns(uint, address) {
459         return (_cid, allCovers[_cid].scAddress);
460     }
461 
462     /// @dev Gets the owner address of a given cover.
463     function getCoverMemberAddress(uint _cid) external view returns(address payable _add) {
464         _add = allCovers[_cid].memberAddress;
465     }
466 
467     /// @dev Gets the premium amount of a given cover in NXM.
468     function getCoverPremiumNXM(uint _cid) external view returns(uint _premiumNXM) {
469         _premiumNXM = allCovers[_cid].premiumNXM;
470     }
471 
472     /// @dev Provides the details of a cover Id
473     /// @param _cid cover Id
474     /// @return memberAddress cover user address.
475     /// @return scAddress smart contract Address 
476     /// @return currencyCode currency of cover
477     /// @return sumAssured sum assured of cover
478     /// @return premiumNXM premium in NXM
479     function getCoverDetailsByCoverID1(
480         uint _cid
481     ) 
482         external
483         view
484         returns (
485             uint cid,
486             address _memberAddress,
487             address _scAddress,
488             bytes4 _currencyCode,
489             uint _sumAssured,  
490             uint premiumNXM 
491         ) 
492     {
493         return (
494             _cid,
495             allCovers[_cid].memberAddress,
496             allCovers[_cid].scAddress,
497             allCovers[_cid].currencyCode,
498             allCovers[_cid].sumAssured,
499             allCovers[_cid].premiumNXM
500         );
501     }
502 
503     /// @dev Provides details of a cover Id
504     /// @param _cid cover Id
505     /// @return status status of cover.
506     /// @return sumAssured Sum assurance of cover.
507     /// @return coverPeriod Cover Period of cover (in days).
508     /// @return validUntil is validity of cover.
509     function getCoverDetailsByCoverID2(
510         uint _cid
511     )
512         external
513         view
514         returns (
515             uint cid,
516             uint8 status,
517             uint sumAssured,
518             uint16 coverPeriod,
519             uint validUntil
520         ) 
521     {
522 
523         return (
524             _cid,
525             coverStatus[_cid],
526             allCovers[_cid].sumAssured,
527             allCovers[_cid].coverPeriod,
528             allCovers[_cid].validUntil
529         );
530     }
531 
532     /// @dev Provides details of a holded cover Id
533     /// @param _hcid holded cover Id
534     /// @return scAddress SmartCover address of cover.
535     /// @return coverCurr currency of cover.
536     /// @return coverPeriod Cover Period of cover (in days).
537     function getHoldedCoverDetailsByID1(
538         uint _hcid
539     )
540         external 
541         view
542         returns (
543             uint hcid,
544             address scAddress,
545             bytes4 coverCurr,
546             uint16 coverPeriod
547         )
548     {
549         return (
550             _hcid,
551             allCoverHolded[_hcid].scAddress,
552             allCoverHolded[_hcid].coverCurr, 
553             allCoverHolded[_hcid].coverPeriod
554         );
555     }
556 
557     /// @dev Gets total number holded covers created till date.
558     function getUserHoldedCoverLength(address _add) external view returns (uint) {
559         return userHoldedCover[_add].length;
560     }
561 
562     /// @dev Gets holded cover index by index of user holded covers.
563     function getUserHoldedCoverByIndex(address _add, uint index) external view returns (uint) {
564         return userHoldedCover[_add][index];
565     }
566 
567     /// @dev Provides the details of a holded cover Id
568     /// @param _hcid holded cover Id
569     /// @return memberAddress holded cover user address.
570     /// @return coverDetails array contains SA, Cover Currency Price,Price in NXM, Expiration time of Qoute.    
571     function getHoldedCoverDetailsByID2(
572         uint _hcid
573     ) 
574         external
575         view
576         returns (
577             uint hcid,
578             address payable memberAddress, 
579             uint[] memory coverDetails
580         )
581     {
582         return (
583             _hcid,
584             allCoverHolded[_hcid].userAddress,
585             allCoverHolded[_hcid].coverDetails
586         );
587     }
588 
589     /// @dev Gets the Total Sum Assured amount of a given currency and smart contract address.
590     function getTotalSumAssuredSC(address _add, bytes4 _curr) external view returns(uint amount) {
591         amount = currencyCSAOfSCAdd[_add][_curr];
592     }
593 
594     //solhint-disable-next-line
595     function changeDependentContractAddress() public {}
596 
597     /// @dev Changes the status of a given cover.
598     /// @param _cid cover Id.
599     /// @param _stat New status.
600     function changeCoverStatusNo(uint _cid, uint8 _stat) public onlyInternal {
601         coverStatus[_cid] = _stat;
602         emit CoverStatusEvent(_cid, _stat);
603     }
604 
605     /**
606      * @dev Updates Uint Parameters of a code
607      * @param code whose details we want to update
608      * @param val value to set
609      */
610     function updateUintParameters(bytes8 code, uint val) public {
611 
612         require(ms.checkIsAuthToGoverned(msg.sender));
613         if (code == "STLP") {
614             _changeSTLP(val);
615 
616         } else if (code == "STL") {
617             
618             _changeSTL(val);
619 
620         } else if (code == "PM") {
621 
622             _changePM(val);
623 
624         } else if (code == "QUOMIND") {
625 
626             _changeMinDays(val);
627 
628         } else if (code == "QUOTOK") {
629 
630             _setTokensRetained(val);
631 
632         } else {
633 
634             revert("Invalid param code");
635         }
636         
637     }
638     
639     /// @dev Changes the existing Profit Margin value
640     function _changePM(uint _pm) internal {
641         pm = _pm;
642     }
643 
644     /// @dev Changes the existing Short Term Load Period (STLP) value.
645     function _changeSTLP(uint _stlp) internal {
646         stlp = _stlp;
647     }
648 
649     /// @dev Changes the existing Short Term Load (STL) value.
650     function _changeSTL(uint _stl) internal {
651         stl = _stl;
652     }
653 
654     /// @dev Changes the existing Minimum cover period (in days)
655     function _changeMinDays(uint _days) internal {
656         minDays = _days;
657     }
658     
659     /**
660      * @dev to set the the amount of tokens retained 
661      * @param val is the amount retained
662      */
663     function _setTokensRetained(uint val) internal {
664         tokensRetained = val;
665     }
666 }
667 
668 /**
669  * @title ERC20 interface
670  * @dev see https://github.com/ethereum/EIPs/issues/20
671  */
672 interface IERC20 {
673     function transfer(address to, uint256 value) external returns (bool);
674 
675     function approve(address spender, uint256 value)
676         external returns (bool);
677 
678     function transferFrom(address from, address to, uint256 value)
679         external returns (bool);
680 
681     function totalSupply() external view returns (uint256);
682 
683     function balanceOf(address who) external view returns (uint256);
684 
685     function allowance(address owner, address spender)
686         external view returns (uint256);
687 
688     event Transfer(
689         address indexed from,
690         address indexed to,
691         uint256 value
692     );
693 
694     event Approval(
695         address indexed owner,
696         address indexed spender,
697         uint256 value
698     );
699 }
700 
701 /* Copyright (C) 2017 NexusMutual.io
702 
703   This program is free software: you can redistribute it and/or modify
704     it under the terms of the GNU General Public License as published by
705     the Free Software Foundation, either version 3 of the License, or
706     (at your option) any later version.
707 
708   This program is distributed in the hope that it will be useful,
709     but WITHOUT ANY WARRANTY; without even the implied warranty of
710     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
711     GNU General Public License for more details.
712 
713   You should have received a copy of the GNU General Public License
714     along with this program.  If not, see http://www.gnu.org/licenses/ */
715 contract NXMToken is IERC20 {
716     using SafeMath for uint256;
717 
718     event WhiteListed(address indexed member);
719 
720     event BlackListed(address indexed member);
721 
722     mapping (address => uint256) private _balances;
723 
724     mapping (address => mapping (address => uint256)) private _allowed;
725 
726     mapping (address => bool) public whiteListed;
727 
728     mapping(address => uint) public isLockedForMV;
729 
730     uint256 private _totalSupply;
731 
732     string public name = "NXM";
733     string public symbol = "NXM";
734     uint8 public decimals = 18;
735     address public operator;
736 
737     modifier canTransfer(address _to) {
738         require(whiteListed[_to]);
739         _;
740     }
741 
742     modifier onlyOperator() {
743         if (operator != address(0))
744             require(msg.sender == operator);
745         _;
746     }
747 
748     constructor(address _founderAddress, uint _initialSupply) public {
749         _mint(_founderAddress, _initialSupply);
750     }
751 
752     /**
753     * @dev Total number of tokens in existence
754     */
755     function totalSupply() public view returns (uint256) {
756         return _totalSupply;
757     }
758 
759     /**
760     * @dev Gets the balance of the specified address.
761     * @param owner The address to query the balance of.
762     * @return An uint256 representing the amount owned by the passed address.
763     */
764     function balanceOf(address owner) public view returns (uint256) {
765         return _balances[owner];
766     }
767 
768     /**
769     * @dev Function to check the amount of tokens that an owner allowed to a spender.
770     * @param owner address The address which owns the funds.
771     * @param spender address The address which will spend the funds.
772     * @return A uint256 specifying the amount of tokens still available for the spender.
773     */
774     function allowance(
775         address owner,
776         address spender
777     )
778         public
779         view
780         returns (uint256)
781     {
782         return _allowed[owner][spender];
783     }
784 
785     /**
786     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
787     * Beware that changing an allowance with this method brings the risk that someone may use both the old
788     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
789     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
790     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
791     * @param spender The address which will spend the funds.
792     * @param value The amount of tokens to be spent.
793     */
794     function approve(address spender, uint256 value) public returns (bool) {
795         require(spender != address(0));
796 
797         _allowed[msg.sender][spender] = value;
798         emit Approval(msg.sender, spender, value);
799         return true;
800     }
801 
802     /**
803     * @dev Increase the amount of tokens that an owner allowed to a spender.
804     * approve should be called when allowed_[_spender] == 0. To increment
805     * allowed value is better to use this function to avoid 2 calls (and wait until
806     * the first transaction is mined)
807     * From MonolithDAO Token.sol
808     * @param spender The address which will spend the funds.
809     * @param addedValue The amount of tokens to increase the allowance by.
810     */
811     function increaseAllowance(
812         address spender,
813         uint256 addedValue
814     )
815         public
816         returns (bool)
817     {
818         require(spender != address(0));
819 
820         _allowed[msg.sender][spender] = (
821         _allowed[msg.sender][spender].add(addedValue));
822         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
823         return true;
824     }
825 
826     /**
827     * @dev Decrease the amount of tokens that an owner allowed to a spender.
828     * approve should be called when allowed_[_spender] == 0. To decrement
829     * allowed value is better to use this function to avoid 2 calls (and wait until
830     * the first transaction is mined)
831     * From MonolithDAO Token.sol
832     * @param spender The address which will spend the funds.
833     * @param subtractedValue The amount of tokens to decrease the allowance by.
834     */
835     function decreaseAllowance(
836         address spender,
837         uint256 subtractedValue
838     )
839         public
840         returns (bool)
841     {
842         require(spender != address(0));
843 
844         _allowed[msg.sender][spender] = (
845         _allowed[msg.sender][spender].sub(subtractedValue));
846         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
847         return true;
848     }
849 
850     /**
851     * @dev Adds a user to whitelist
852     * @param _member address to add to whitelist
853     */
854     function addToWhiteList(address _member) public onlyOperator returns (bool) {
855         whiteListed[_member] = true;
856         emit WhiteListed(_member);
857         return true;
858     }
859 
860     /**
861     * @dev removes a user from whitelist
862     * @param _member address to remove from whitelist
863     */
864     function removeFromWhiteList(address _member) public onlyOperator returns (bool) {
865         whiteListed[_member] = false;
866         emit BlackListed(_member);
867         return true;
868     }
869 
870     /**
871     * @dev change operator address 
872     * @param _newOperator address of new operator
873     */
874     function changeOperator(address _newOperator) public onlyOperator returns (bool) {
875         operator = _newOperator;
876         return true;
877     }
878 
879     /**
880     * @dev burns an amount of the tokens of the message sender
881     * account.
882     * @param amount The amount that will be burnt.
883     */
884     function burn(uint256 amount) public returns (bool) {
885         _burn(msg.sender, amount);
886         return true;
887     }
888 
889     /**
890     * @dev Burns a specific amount of tokens from the target address and decrements allowance
891     * @param from address The address which you want to send tokens from
892     * @param value uint256 The amount of token to be burned
893     */
894     function burnFrom(address from, uint256 value) public returns (bool) {
895         _burnFrom(from, value);
896         return true;
897     }
898 
899     /**
900     * @dev function that mints an amount of the token and assigns it to
901     * an account.
902     * @param account The account that will receive the created tokens.
903     * @param amount The amount that will be created.
904     */
905     function mint(address account, uint256 amount) public onlyOperator {
906         _mint(account, amount);
907     }
908 
909     /**
910     * @dev Transfer token for a specified address
911     * @param to The address to transfer to.
912     * @param value The amount to be transferred.
913     */
914     function transfer(address to, uint256 value) public canTransfer(to) returns (bool) {
915 
916         require(isLockedForMV[msg.sender] < now); // if not voted under governance
917         require(value <= _balances[msg.sender]);
918         _transfer(to, value); 
919         return true;
920     }
921 
922     /**
923     * @dev Transfer tokens to the operator from the specified address
924     * @param from The address to transfer from.
925     * @param value The amount to be transferred.
926     */
927     function operatorTransfer(address from, uint256 value) public onlyOperator returns (bool) {
928         require(value <= _balances[from]);
929         _transferFrom(from, operator, value);
930         return true;
931     }
932 
933     /**
934     * @dev Transfer tokens from one address to another
935     * @param from address The address which you want to send tokens from
936     * @param to address The address which you want to transfer to
937     * @param value uint256 the amount of tokens to be transferred
938     */
939     function transferFrom(
940         address from,
941         address to,
942         uint256 value
943     )
944         public
945         canTransfer(to)
946         returns (bool)
947     {
948         require(isLockedForMV[from] < now); // if not voted under governance
949         require(value <= _balances[from]);
950         require(value <= _allowed[from][msg.sender]);
951         _transferFrom(from, to, value);
952         return true;
953     }
954 
955     /**
956      * @dev Lock the user's tokens 
957      * @param _of user's address.
958      */
959     function lockForMemberVote(address _of, uint _days) public onlyOperator {
960         if (_days.add(now) > isLockedForMV[_of])
961             isLockedForMV[_of] = _days.add(now);
962     }
963 
964     /**
965     * @dev Transfer token for a specified address
966     * @param to The address to transfer to.
967     * @param value The amount to be transferred.
968     */
969     function _transfer(address to, uint256 value) internal {
970         _balances[msg.sender] = _balances[msg.sender].sub(value);
971         _balances[to] = _balances[to].add(value);
972         emit Transfer(msg.sender, to, value);
973     }
974 
975     /**
976     * @dev Transfer tokens from one address to another
977     * @param from address The address which you want to send tokens from
978     * @param to address The address which you want to transfer to
979     * @param value uint256 the amount of tokens to be transferred
980     */
981     function _transferFrom(
982         address from,
983         address to,
984         uint256 value
985     )
986         internal
987     {
988         _balances[from] = _balances[from].sub(value);
989         _balances[to] = _balances[to].add(value);
990         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
991         emit Transfer(from, to, value);
992     }
993 
994     /**
995     * @dev Internal function that mints an amount of the token and assigns it to
996     * an account. This encapsulates the modification of balances such that the
997     * proper events are emitted.
998     * @param account The account that will receive the created tokens.
999     * @param amount The amount that will be created.
1000     */
1001     function _mint(address account, uint256 amount) internal {
1002         require(account != address(0));
1003         _totalSupply = _totalSupply.add(amount);
1004         _balances[account] = _balances[account].add(amount);
1005         emit Transfer(address(0), account, amount);
1006     }
1007 
1008     /**
1009     * @dev Internal function that burns an amount of the token of a given
1010     * account.
1011     * @param account The account whose tokens will be burnt.
1012     * @param amount The amount that will be burnt.
1013     */
1014     function _burn(address account, uint256 amount) internal {
1015         require(amount <= _balances[account]);
1016 
1017         _totalSupply = _totalSupply.sub(amount);
1018         _balances[account] = _balances[account].sub(amount);
1019         emit Transfer(account, address(0), amount);
1020     }
1021 
1022     /**
1023     * @dev Internal function that burns an amount of the token of a given
1024     * account, deducting from the sender's allowance for said account. Uses the
1025     * internal burn function.
1026     * @param account The account whose tokens will be burnt.
1027     * @param value The amount that will be burnt.
1028     */
1029     function _burnFrom(address account, uint256 value) internal {
1030         require(value <= _allowed[account][msg.sender]);
1031 
1032         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1033         // this function needs to emit an event with the updated approval.
1034         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
1035         value);
1036         _burn(account, value);
1037     }
1038 }
1039 
1040 /* Copyright (C) 2017 GovBlocks.io
1041   This program is free software: you can redistribute it and/or modify
1042     it under the terms of the GNU General Public License as published by
1043     the Free Software Foundation, either version 3 of the License, or
1044     (at your option) any later version.
1045   This program is distributed in the hope that it will be useful,
1046     but WITHOUT ANY WARRANTY; without even the implied warranty of
1047     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1048     GNU General Public License for more details.
1049   You should have received a copy of the GNU General Public License
1050     along with this program.  If not, see http://www.gnu.org/licenses/ */
1051 contract IProposalCategory {
1052 
1053     event Category(
1054         uint indexed categoryId,
1055         string categoryName,
1056         string actionHash
1057     );
1058 
1059     /// @dev Adds new category
1060     /// @param _name Category name
1061     /// @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
1062     /// @param _allowedToCreateProposal Member roles allowed to create the proposal
1063     /// @param _majorityVotePerc Majority Vote threshold for Each voting layer
1064     /// @param _quorumPerc minimum threshold percentage required in voting to calculate result
1065     /// @param _closingTime Vote closing time for Each voting layer
1066     /// @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
1067     /// @param _contractAddress address of contract to call after proposal is accepted
1068     /// @param _contractName name of contract to be called after proposal is accepted
1069     /// @param _incentives rewards to distributed after proposal is accepted
1070     function addCategory(
1071         string calldata _name, 
1072         uint _memberRoleToVote,
1073         uint _majorityVotePerc, 
1074         uint _quorumPerc, 
1075         uint[] calldata _allowedToCreateProposal,
1076         uint _closingTime,
1077         string calldata _actionHash,
1078         address _contractAddress,
1079         bytes2 _contractName,
1080         uint[] calldata _incentives
1081     ) 
1082         external;
1083 
1084     /// @dev gets category details
1085     function category(uint _categoryId)
1086         external
1087         view
1088         returns(
1089             uint categoryId,
1090             uint memberRoleToVote,
1091             uint majorityVotePerc,
1092             uint quorumPerc,
1093             uint[] memory allowedToCreateProposal,
1094             uint closingTime,
1095             uint minStake
1096         );
1097     
1098     ///@dev gets category action details
1099     function categoryAction(uint _categoryId)
1100         external
1101         view
1102         returns(
1103             uint categoryId,
1104             address contractAddress,
1105             bytes2 contractName,
1106             uint defaultIncentive
1107         );
1108     
1109     /// @dev Gets Total number of categories added till now
1110     function totalCategories() external view returns(uint numberOfCategories);
1111 
1112     /// @dev Updates category details
1113     /// @param _categoryId Category id that needs to be updated
1114     /// @param _name Category name
1115     /// @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
1116     /// @param _allowedToCreateProposal Member roles allowed to create the proposal
1117     /// @param _majorityVotePerc Majority Vote threshold for Each voting layer
1118     /// @param _quorumPerc minimum threshold percentage required in voting to calculate result
1119     /// @param _closingTime Vote closing time for Each voting layer
1120     /// @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
1121     /// @param _contractAddress address of contract to call after proposal is accepted
1122     /// @param _contractName name of contract to be called after proposal is accepted
1123     /// @param _incentives rewards to distributed after proposal is accepted
1124     function updateCategory(
1125         uint _categoryId, 
1126         string memory _name, 
1127         uint _memberRoleToVote, 
1128         uint _majorityVotePerc, 
1129         uint _quorumPerc,
1130         uint[] memory _allowedToCreateProposal,
1131         uint _closingTime,
1132         string memory _actionHash,
1133         address _contractAddress,
1134         bytes2 _contractName,
1135         uint[] memory _incentives
1136     )
1137         public;
1138 
1139 }
1140 
1141 /* Copyright (C) 2017 GovBlocks.io
1142   This program is free software: you can redistribute it and/or modify
1143     it under the terms of the GNU General Public License as published by
1144     the Free Software Foundation, either version 3 of the License, or
1145     (at your option) any later version.
1146   This program is distributed in the hope that it will be useful,
1147     but WITHOUT ANY WARRANTY; without even the implied warranty of
1148     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1149     GNU General Public License for more details.
1150   You should have received a copy of the GNU General Public License
1151     along with this program.  If not, see http://www.gnu.org/licenses/ */
1152 contract IMaster {
1153     function getLatestAddress(bytes2 _module) public view returns(address);
1154 }
1155 
1156 contract Governed {
1157 
1158     address public masterAddress; // Name of the dApp, needs to be set by contracts inheriting this contract
1159 
1160     /// @dev modifier that allows only the authorized addresses to execute the function
1161     modifier onlyAuthorizedToGovern() {
1162         IMaster ms = IMaster(masterAddress);
1163         require(ms.getLatestAddress("GV") == msg.sender, "Not authorized");
1164         _;
1165     }
1166 
1167     /// @dev checks if an address is authorized to govern
1168     function isAuthorizedToGovern(address _toCheck) public view returns(bool) {
1169         IMaster ms = IMaster(masterAddress);
1170         return (ms.getLatestAddress("GV") == _toCheck);
1171     } 
1172 
1173 }
1174 
1175 /* Copyright (C) 2017 GovBlocks.io
1176   This program is free software: you can redistribute it and/or modify
1177     it under the terms of the GNU General Public License as published by
1178     the Free Software Foundation, either version 3 of the License, or
1179     (at your option) any later version.
1180   This program is distributed in the hope that it will be useful,
1181     but WITHOUT ANY WARRANTY; without even the implied warranty of
1182     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1183     GNU General Public License for more details.
1184   You should have received a copy of the GNU General Public License
1185     along with this program.  If not, see http://www.gnu.org/licenses/ */
1186 contract IMemberRoles {
1187 
1188     event MemberRole(uint256 indexed roleId, bytes32 roleName, string roleDescription);
1189     
1190     /// @dev Adds new member role
1191     /// @param _roleName New role name
1192     /// @param _roleDescription New description hash
1193     /// @param _authorized Authorized member against every role id
1194     function addRole(bytes32 _roleName, string memory _roleDescription, address _authorized) public;
1195 
1196     /// @dev Assign or Delete a member from specific role.
1197     /// @param _memberAddress Address of Member
1198     /// @param _roleId RoleId to update
1199     /// @param _active active is set to be True if we want to assign this role to member, False otherwise!
1200     function updateRole(address _memberAddress, uint _roleId, bool _active) public;
1201 
1202     /// @dev Change Member Address who holds the authority to Add/Delete any member from specific role.
1203     /// @param _roleId roleId to update its Authorized Address
1204     /// @param _authorized New authorized address against role id
1205     function changeAuthorized(uint _roleId, address _authorized) public;
1206 
1207     /// @dev Return number of member roles
1208     function totalRoles() public view returns(uint256);
1209 
1210     /// @dev Gets the member addresses assigned by a specific role
1211     /// @param _memberRoleId Member role id
1212     /// @return roleId Role id
1213     /// @return allMemberAddress Member addresses of specified role id
1214     function members(uint _memberRoleId) public view returns(uint, address[] memory allMemberAddress);
1215 
1216     /// @dev Gets all members' length
1217     /// @param _memberRoleId Member role id
1218     /// @return memberRoleData[_memberRoleId].memberAddress.length Member length
1219     function numberOfMembers(uint _memberRoleId) public view returns(uint);
1220     
1221     /// @dev Return member address who holds the right to add/remove any member from specific role.
1222     function authorized(uint _memberRoleId) public view returns(address);
1223 
1224     /// @dev Get All role ids array that has been assigned to a member so far.
1225     function roles(address _memberAddress) public view returns(uint[] memory assignedRoles);
1226 
1227     /// @dev Returns true if the given role id is assigned to a member.
1228     /// @param _memberAddress Address of member
1229     /// @param _roleId Checks member's authenticity with the roleId.
1230     /// i.e. Returns true if this roleId is assigned to member
1231     function checkRole(address _memberAddress, uint _roleId) public view returns(bool);   
1232 }
1233 
1234 /**
1235  * @title ERC1132 interface
1236  * @dev see https://github.com/ethereum/EIPs/issues/1132
1237  */
1238 contract IERC1132 {
1239     /**
1240      * @dev Reasons why a user's tokens have been locked
1241      */
1242     mapping(address => bytes32[]) public lockReason;
1243 
1244     /**
1245      * @dev locked token structure
1246      */
1247     struct LockToken {
1248         uint256 amount;
1249         uint256 validity;
1250         bool claimed;
1251     }
1252 
1253     /**
1254      * @dev Holds number & validity of tokens locked for a given reason for
1255      *      a specified address
1256      */
1257     mapping(address => mapping(bytes32 => LockToken)) public locked;
1258 
1259     /**
1260      * @dev Records data of all the tokens Locked
1261      */
1262     event Locked(
1263         address indexed _of,
1264         bytes32 indexed _reason,
1265         uint256 _amount,
1266         uint256 _validity
1267     );
1268 
1269     /**
1270      * @dev Records data of all the tokens unlocked
1271      */
1272     event Unlocked(
1273         address indexed _of,
1274         bytes32 indexed _reason,
1275         uint256 _amount
1276     );
1277     
1278     /**
1279      * @dev Locks a specified amount of tokens against an address,
1280      *      for a specified reason and time
1281      * @param _reason The reason to lock tokens
1282      * @param _amount Number of tokens to be locked
1283      * @param _time Lock time in seconds
1284      */
1285     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
1286         public returns (bool);
1287   
1288     /**
1289      * @dev Returns tokens locked for a specified address for a
1290      *      specified reason
1291      *
1292      * @param _of The address whose tokens are locked
1293      * @param _reason The reason to query the lock tokens for
1294      */
1295     function tokensLocked(address _of, bytes32 _reason)
1296         public view returns (uint256 amount);
1297     
1298     /**
1299      * @dev Returns tokens locked for a specified address for a
1300      *      specified reason at a specific time
1301      *
1302      * @param _of The address whose tokens are locked
1303      * @param _reason The reason to query the lock tokens for
1304      * @param _time The timestamp to query the lock tokens for
1305      */
1306     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
1307         public view returns (uint256 amount);
1308     
1309     /**
1310      * @dev Returns total tokens held by an address (locked + transferable)
1311      * @param _of The address to query the total balance of
1312      */
1313     function totalBalanceOf(address _of)
1314         public view returns (uint256 amount);
1315     
1316     /**
1317      * @dev Extends lock for a specified reason and time
1318      * @param _reason The reason to lock tokens
1319      * @param _time Lock extension time in seconds
1320      */
1321     function extendLock(bytes32 _reason, uint256 _time)
1322         public returns (bool);
1323     
1324     /**
1325      * @dev Increase number of tokens locked for a specified reason
1326      * @param _reason The reason to lock tokens
1327      * @param _amount Number of tokens to be increased
1328      */
1329     function increaseLockAmount(bytes32 _reason, uint256 _amount)
1330         public returns (bool);
1331 
1332     /**
1333      * @dev Returns unlockable tokens for a specified address for a specified reason
1334      * @param _of The address to query the the unlockable token count of
1335      * @param _reason The reason to query the unlockable tokens for
1336      */
1337     function tokensUnlockable(address _of, bytes32 _reason)
1338         public view returns (uint256 amount);
1339  
1340     /**
1341      * @dev Unlocks the unlockable tokens of a specified address
1342      * @param _of Address of user, claiming back unlockable tokens
1343      */
1344     function unlock(address _of)
1345         public returns (uint256 unlockableTokens);
1346 
1347     /**
1348      * @dev Gets the unlockable tokens of a specified address
1349      * @param _of The address to query the the unlockable token count of
1350      */
1351     function getUnlockableTokens(address _of)
1352         public view returns (uint256 unlockableTokens);
1353 
1354 }
1355 
1356 interface IPooledStaking {
1357 
1358     function pushReward(address contractAddress, uint amount) external;
1359     function pushBurn(address contractAddress, uint amount) external;
1360     function hasPendingActions() external view returns (bool);
1361 
1362     function contractStake(address contractAddress) external view returns (uint);
1363     function stakerReward(address staker) external view returns (uint);
1364     function stakerDeposit(address staker) external view returns (uint);
1365     function stakerContractStake(address staker, address contractAddress) external view returns (uint);
1366 
1367     function withdraw(uint amount) external;
1368     function stakerMaxWithdrawable(address stakerAddress) external view returns (uint);
1369     function withdrawReward(address stakerAddress) external;
1370 }
1371 
1372 /* Copyright (C) 2020 NexusMutual.io
1373 
1374   This program is free software: you can redistribute it and/or modify
1375   it under the terms of the GNU General Public License as published by
1376   the Free Software Foundation, either version 3 of the License, or
1377   (at your option) any later version.
1378 
1379   This program is distributed in the hope that it will be useful,
1380   but WITHOUT ANY WARRANTY; without even the implied warranty of
1381   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1382   GNU General Public License for more details.
1383 
1384   You should have received a copy of the GNU General Public License
1385   along with this program.  If not, see http://www.gnu.org/licenses/ */
1386 contract TokenController is IERC1132, Iupgradable {
1387     using SafeMath for uint256;
1388 
1389     event Burned(address indexed member, bytes32 lockedUnder, uint256 amount);
1390 
1391     NXMToken public token;
1392     IPooledStaking public pooledStaking;
1393     uint public minCALockTime = uint(30).mul(1 days);
1394     bytes32 private constant CLA = bytes32("CLA");
1395 
1396     /**
1397     * @dev Just for interface
1398     */
1399     function changeDependentContractAddress() public {
1400         token = NXMToken(ms.tokenAddress());
1401         pooledStaking = IPooledStaking(ms.getLatestAddress('PS'));
1402     }
1403 
1404     /**
1405      * @dev to change the operator address
1406      * @param _newOperator is the new address of operator
1407      */
1408     function changeOperator(address _newOperator) public onlyInternal {
1409         token.changeOperator(_newOperator);
1410     }
1411 
1412     /**
1413     * @dev Locks a specified amount of tokens,
1414     *    for CLA reason and for a specified time
1415     * @param _reason The reason to lock tokens, currently restricted to CLA
1416     * @param _amount Number of tokens to be locked
1417     * @param _time Lock time in seconds
1418     */
1419     function lock(bytes32 _reason, uint256 _amount, uint256 _time) public checkPause returns (bool)
1420     {
1421         require(_reason == CLA,"Restricted to reason CLA");
1422         require(minCALockTime <= _time,"Should lock for minimum time");
1423         // If tokens are already locked, then functions extendLock or
1424         // increaseLockAmount should be used to make any changes
1425         _lock(msg.sender, _reason, _amount, _time);
1426         return true;
1427     }
1428 
1429     /**
1430     * @dev Locks a specified amount of tokens against an address,
1431     *    for a specified reason and time
1432     * @param _reason The reason to lock tokens
1433     * @param _amount Number of tokens to be locked
1434     * @param _time Lock time in seconds
1435     * @param _of address whose tokens are to be locked
1436     */
1437     function lockOf(address _of, bytes32 _reason, uint256 _amount, uint256 _time)
1438         public
1439         onlyInternal
1440         returns (bool)
1441     {
1442         // If tokens are already locked, then functions extendLock or
1443         // increaseLockAmount should be used to make any changes
1444         _lock(_of, _reason, _amount, _time);
1445         return true;
1446     }
1447 
1448     /**
1449     * @dev Extends lock for reason CLA for a specified time
1450     * @param _reason The reason to lock tokens, currently restricted to CLA
1451     * @param _time Lock extension time in seconds
1452     */
1453     function extendLock(bytes32 _reason, uint256 _time)
1454         public
1455         checkPause
1456         returns (bool)
1457     {
1458         require(_reason == CLA,"Restricted to reason CLA");
1459         _extendLock(msg.sender, _reason, _time);
1460         return true;
1461     }
1462 
1463     /**
1464     * @dev Extends lock for a specified reason and time
1465     * @param _reason The reason to lock tokens
1466     * @param _time Lock extension time in seconds
1467     */
1468     function extendLockOf(address _of, bytes32 _reason, uint256 _time)
1469         public
1470         onlyInternal
1471         returns (bool)
1472     {
1473         _extendLock(_of, _reason, _time);
1474         return true;
1475     }
1476 
1477     /**
1478     * @dev Increase number of tokens locked for a CLA reason
1479     * @param _reason The reason to lock tokens, currently restricted to CLA
1480     * @param _amount Number of tokens to be increased
1481     */
1482     function increaseLockAmount(bytes32 _reason, uint256 _amount)
1483         public
1484         checkPause
1485         returns (bool)
1486     {    
1487         require(_reason == CLA,"Restricted to reason CLA");
1488         require(_tokensLocked(msg.sender, _reason) > 0);
1489         token.operatorTransfer(msg.sender, _amount);
1490 
1491         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
1492         emit Locked(msg.sender, _reason, _amount, locked[msg.sender][_reason].validity);
1493         return true;
1494     }
1495 
1496     /**
1497      * @dev burns tokens of an address
1498      * @param _of is the address to burn tokens of
1499      * @param amount is the amount to burn
1500      * @return the boolean status of the burning process
1501      */
1502     function burnFrom (address _of, uint amount) public onlyInternal returns (bool) {
1503         return token.burnFrom(_of, amount);
1504     }
1505 
1506     /**
1507     * @dev Burns locked tokens of a user
1508     * @param _of address whose tokens are to be burned
1509     * @param _reason lock reason for which tokens are to be burned
1510     * @param _amount amount of tokens to burn
1511     */
1512     function burnLockedTokens(address _of, bytes32 _reason, uint256 _amount) public onlyInternal {
1513         _burnLockedTokens(_of, _reason, _amount);
1514     }
1515 
1516     /**
1517     * @dev reduce lock duration for a specified reason and time
1518     * @param _of The address whose tokens are locked
1519     * @param _reason The reason to lock tokens
1520     * @param _time Lock reduction time in seconds
1521     */
1522     function reduceLock(address _of, bytes32 _reason, uint256 _time) public onlyInternal {
1523         _reduceLock(_of, _reason, _time);
1524     }
1525 
1526     /**
1527     * @dev Released locked tokens of an address locked for a specific reason
1528     * @param _of address whose tokens are to be released from lock
1529     * @param _reason reason of the lock
1530     * @param _amount amount of tokens to release
1531     */
1532     function releaseLockedTokens(address _of, bytes32 _reason, uint256 _amount)
1533         public
1534         onlyInternal
1535     {
1536         _releaseLockedTokens(_of, _reason, _amount);
1537     }
1538 
1539     /**
1540     * @dev Adds an address to whitelist maintained in the contract
1541     * @param _member address to add to whitelist
1542     */
1543     function addToWhitelist(address _member) public onlyInternal {
1544         token.addToWhiteList(_member);
1545     }
1546 
1547     /**
1548     * @dev Removes an address from the whitelist in the token
1549     * @param _member address to remove
1550     */
1551     function removeFromWhitelist(address _member) public onlyInternal {
1552         token.removeFromWhiteList(_member);
1553     }
1554 
1555     /**
1556     * @dev Mints new token for an address
1557     * @param _member address to reward the minted tokens
1558     * @param _amount number of tokens to mint
1559     */
1560     function mint(address _member, uint _amount) public onlyInternal {
1561         token.mint(_member, _amount);
1562     }
1563 
1564     /**
1565      * @dev Lock the user's tokens
1566      * @param _of user's address.
1567      */
1568     function lockForMemberVote(address _of, uint _days) public onlyInternal {
1569         token.lockForMemberVote(_of, _days);
1570     }
1571 
1572     /**
1573     * @dev Unlocks the unlockable tokens against CLA of a specified address
1574     * @param _of Address of user, claiming back unlockable tokens against CLA
1575     */
1576     function unlock(address _of)
1577         public
1578         checkPause
1579         returns (uint256 unlockableTokens)
1580     {
1581         unlockableTokens = _tokensUnlockable(_of, CLA);
1582         if (unlockableTokens > 0) {
1583             locked[_of][CLA].claimed = true;
1584             emit Unlocked(_of, CLA, unlockableTokens);
1585             require(token.transfer(_of, unlockableTokens));
1586         }
1587     }
1588 
1589     /**
1590      * @dev Updates Uint Parameters of a code
1591      * @param code whose details we want to update
1592      * @param val value to set
1593      */
1594     function updateUintParameters(bytes8 code, uint val) public {
1595         require(ms.checkIsAuthToGoverned(msg.sender));
1596         if (code == "MNCLT") {
1597             minCALockTime = val.mul(1 days);
1598         } else {
1599             revert("Invalid param code");
1600         }
1601     }
1602 
1603     /**
1604     * @dev Gets the validity of locked tokens of a specified address
1605     * @param _of The address to query the validity
1606     * @param reason reason for which tokens were locked
1607     */
1608     function getLockedTokensValidity(address _of, bytes32 reason)
1609         public
1610         view
1611         returns (uint256 validity)
1612     {
1613         validity = locked[_of][reason].validity;
1614     }
1615 
1616     /**
1617     * @dev Gets the unlockable tokens of a specified address
1618     * @param _of The address to query the the unlockable token count of
1619     */
1620     function getUnlockableTokens(address _of)
1621         public
1622         view
1623         returns (uint256 unlockableTokens)
1624     {
1625         for (uint256 i = 0; i < lockReason[_of].length; i++) {
1626             unlockableTokens = unlockableTokens.add(_tokensUnlockable(_of, lockReason[_of][i]));
1627         }
1628     }
1629 
1630     /**
1631     * @dev Returns tokens locked for a specified address for a
1632     *    specified reason
1633     *
1634     * @param _of The address whose tokens are locked
1635     * @param _reason The reason to query the lock tokens for
1636     */
1637     function tokensLocked(address _of, bytes32 _reason)
1638         public
1639         view
1640         returns (uint256 amount)
1641     {
1642         return _tokensLocked(_of, _reason);
1643     }
1644 
1645     /**
1646     * @dev Returns unlockable tokens for a specified address for a specified reason
1647     * @param _of The address to query the the unlockable token count of
1648     * @param _reason The reason to query the unlockable tokens for
1649     */
1650     function tokensUnlockable(address _of, bytes32 _reason)
1651         public
1652         view
1653         returns (uint256 amount)
1654     {
1655         return _tokensUnlockable(_of, _reason);
1656     }
1657 
1658     function totalSupply() public view returns (uint256)
1659     {
1660         return token.totalSupply();
1661     }
1662 
1663     /**
1664     * @dev Returns tokens locked for a specified address for a
1665     *    specified reason at a specific time
1666     *
1667     * @param _of The address whose tokens are locked
1668     * @param _reason The reason to query the lock tokens for
1669     * @param _time The timestamp to query the lock tokens for
1670     */
1671     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
1672         public
1673         view
1674         returns (uint256 amount)
1675     {
1676         return _tokensLockedAtTime(_of, _reason, _time);
1677     }
1678 
1679     /**
1680     * @dev Returns the total amount of tokens held by an address:
1681     *   transferable + locked + staked for pooled staking - pending burns.
1682     *   Used by Claims and Governance in member voting to calculate the user's vote weight.
1683     *
1684     * @param _of The address to query the total balance of
1685     * @param _of The address to query the total balance of
1686     */
1687     function totalBalanceOf(address _of) public view returns (uint256 amount) {
1688 
1689         amount = token.balanceOf(_of);
1690 
1691         for (uint256 i = 0; i < lockReason[_of].length; i++) {
1692             amount = amount.add(_tokensLocked(_of, lockReason[_of][i]));
1693         }
1694 
1695         uint stakerReward = pooledStaking.stakerReward(_of);
1696         uint stakerDeposit = pooledStaking.stakerDeposit(_of);
1697 
1698         amount = amount.add(stakerDeposit).add(stakerReward);
1699     }
1700 
1701     /**
1702     * @dev Returns the total locked tokens at time
1703     *   Returns the total amount of locked and staked tokens at a given time. Used by MemberRoles to check eligibility
1704     *   for withdraw / switch membership. Includes tokens locked for Claim Assessment and staked for Risk Assessment.
1705     *   Does not take into account pending burns.
1706     *
1707     * @param _of member whose locked tokens are to be calculate
1708     * @param _time timestamp when the tokens should be locked
1709     */
1710     function totalLockedBalance(address _of, uint256 _time) public view returns (uint256 amount) {
1711 
1712         for (uint256 i = 0; i < lockReason[_of].length; i++) {
1713             amount = amount.add(_tokensLockedAtTime(_of, lockReason[_of][i], _time));
1714         }
1715 
1716         amount = amount.add(pooledStaking.stakerDeposit(_of));
1717     }
1718 
1719     /**
1720     * @dev Locks a specified amount of tokens against an address,
1721     *    for a specified reason and time
1722     * @param _of address whose tokens are to be locked
1723     * @param _reason The reason to lock tokens
1724     * @param _amount Number of tokens to be locked
1725     * @param _time Lock time in seconds
1726     */
1727     function _lock(address _of, bytes32 _reason, uint256 _amount, uint256 _time) internal {
1728         require(_tokensLocked(_of, _reason) == 0);
1729         require(_amount != 0);
1730 
1731         if (locked[_of][_reason].amount == 0) {
1732             lockReason[_of].push(_reason);
1733         }
1734 
1735         require(token.operatorTransfer(_of, _amount));
1736 
1737         uint256 validUntil = now.add(_time); //solhint-disable-line
1738         locked[_of][_reason] = LockToken(_amount, validUntil, false);
1739         emit Locked(_of, _reason, _amount, validUntil);
1740     }
1741 
1742     /**
1743     * @dev Returns tokens locked for a specified address for a
1744     *    specified reason
1745     *
1746     * @param _of The address whose tokens are locked
1747     * @param _reason The reason to query the lock tokens for
1748     */
1749     function _tokensLocked(address _of, bytes32 _reason)
1750         internal
1751         view
1752         returns (uint256 amount)
1753     {
1754         if (!locked[_of][_reason].claimed) {
1755             amount = locked[_of][_reason].amount;
1756         }
1757     }
1758 
1759     /**
1760     * @dev Returns tokens locked for a specified address for a
1761     *    specified reason at a specific time
1762     *
1763     * @param _of The address whose tokens are locked
1764     * @param _reason The reason to query the lock tokens for
1765     * @param _time The timestamp to query the lock tokens for
1766     */
1767     function _tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
1768         internal
1769         view
1770         returns (uint256 amount)
1771     {
1772         if (locked[_of][_reason].validity > _time) {
1773             amount = locked[_of][_reason].amount;
1774         }
1775     }
1776 
1777     /**
1778     * @dev Extends lock for a specified reason and time
1779     * @param _of The address whose tokens are locked
1780     * @param _reason The reason to lock tokens
1781     * @param _time Lock extension time in seconds
1782     */
1783     function _extendLock(address _of, bytes32 _reason, uint256 _time) internal {
1784         require(_tokensLocked(_of, _reason) > 0);
1785         emit Unlocked(_of, _reason, locked[_of][_reason].amount);
1786         locked[_of][_reason].validity = locked[_of][_reason].validity.add(_time);
1787         emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
1788     }
1789 
1790     /**
1791     * @dev reduce lock duration for a specified reason and time
1792     * @param _of The address whose tokens are locked
1793     * @param _reason The reason to lock tokens
1794     * @param _time Lock reduction time in seconds
1795     */
1796     function _reduceLock(address _of, bytes32 _reason, uint256 _time) internal {
1797         require(_tokensLocked(_of, _reason) > 0);
1798         emit Unlocked(_of, _reason, locked[_of][_reason].amount);
1799         locked[_of][_reason].validity = locked[_of][_reason].validity.sub(_time);
1800         emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
1801     }
1802 
1803     /**
1804     * @dev Returns unlockable tokens for a specified address for a specified reason
1805     * @param _of The address to query the the unlockable token count of
1806     * @param _reason The reason to query the unlockable tokens for
1807     */
1808     function _tokensUnlockable(address _of, bytes32 _reason) internal view returns (uint256 amount)
1809     {
1810         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) {
1811             amount = locked[_of][_reason].amount;
1812         }
1813     }
1814 
1815     /**
1816     * @dev Burns locked tokens of a user
1817     * @param _of address whose tokens are to be burned
1818     * @param _reason lock reason for which tokens are to be burned
1819     * @param _amount amount of tokens to burn
1820     */
1821     function _burnLockedTokens(address _of, bytes32 _reason, uint256 _amount) internal {
1822         uint256 amount = _tokensLocked(_of, _reason);
1823         require(amount >= _amount);
1824 
1825         if (amount == _amount) {
1826             locked[_of][_reason].claimed = true;
1827         }
1828 
1829         locked[_of][_reason].amount = locked[_of][_reason].amount.sub(_amount);
1830         if (locked[_of][_reason].amount == 0) {
1831             _removeReason(_of, _reason);
1832         }
1833         token.burn(_amount);
1834         emit Burned(_of, _reason, _amount);
1835     }
1836 
1837     /**
1838     * @dev Released locked tokens of an address locked for a specific reason
1839     * @param _of address whose tokens are to be released from lock
1840     * @param _reason reason of the lock
1841     * @param _amount amount of tokens to release
1842     */
1843     function _releaseLockedTokens(address _of, bytes32 _reason, uint256 _amount) internal
1844     {
1845         uint256 amount = _tokensLocked(_of, _reason);
1846         require(amount >= _amount);
1847 
1848         if (amount == _amount) {
1849             locked[_of][_reason].claimed = true;
1850         }
1851 
1852         locked[_of][_reason].amount = locked[_of][_reason].amount.sub(_amount);
1853         if (locked[_of][_reason].amount == 0) {
1854             _removeReason(_of, _reason);
1855         }
1856         require(token.transfer(_of, _amount));
1857         emit Unlocked(_of, _reason, _amount);
1858     }
1859 
1860     function _removeReason(address _of, bytes32 _reason) internal {
1861         uint len = lockReason[_of].length;
1862         for (uint i = 0; i < len; i++) {
1863             if (lockReason[_of][i] == _reason) {
1864                 lockReason[_of][i] = lockReason[_of][len.sub(1)];
1865                 lockReason[_of].pop();
1866                 break;
1867             }
1868         }   
1869     }
1870 }
1871 
1872 /* Copyright (C) 2017 NexusMutual.io
1873 
1874   This program is free software: you can redistribute it and/or modify
1875     it under the terms of the GNU General Public License as published by
1876     the Free Software Foundation, either version 3 of the License, or
1877     (at your option) any later version.
1878 
1879   This program is distributed in the hope that it will be useful,
1880     but WITHOUT ANY WARRANTY; without even the implied warranty of
1881     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1882     GNU General Public License for more details.
1883 
1884   You should have received a copy of the GNU General Public License
1885     along with this program.  If not, see http://www.gnu.org/licenses/ */
1886 contract ClaimsData is Iupgradable {
1887     using SafeMath for uint;
1888 
1889     struct Claim {
1890         uint coverId;
1891         uint dateUpd;
1892     }
1893 
1894     struct Vote {
1895         address voter;
1896         uint tokens;
1897         uint claimId;
1898         int8 verdict;
1899         bool rewardClaimed;
1900     }
1901 
1902     struct ClaimsPause {
1903         uint coverid;
1904         uint dateUpd;
1905         bool submit;
1906     }
1907 
1908     struct ClaimPauseVoting {
1909         uint claimid;
1910         uint pendingTime;
1911         bool voting;
1912     }
1913 
1914     struct RewardDistributed {
1915         uint lastCAvoteIndex;
1916         uint lastMVvoteIndex;
1917 
1918     }
1919 
1920     struct ClaimRewardDetails {
1921         uint percCA;
1922         uint percMV;
1923         uint tokenToBeDist;
1924 
1925     }
1926 
1927     struct ClaimTotalTokens {
1928         uint accept;
1929         uint deny;
1930     }
1931 
1932     struct ClaimRewardStatus {
1933         uint percCA;
1934         uint percMV;
1935     }
1936 
1937     ClaimRewardStatus[] internal rewardStatus;
1938 
1939     Claim[] internal allClaims;
1940     Vote[] internal allvotes;
1941     ClaimsPause[] internal claimPause;
1942     ClaimPauseVoting[] internal claimPauseVotingEP;
1943 
1944     mapping(address => RewardDistributed) internal voterVoteRewardReceived;
1945     mapping(uint => ClaimRewardDetails) internal claimRewardDetail;
1946     mapping(uint => ClaimTotalTokens) internal claimTokensCA;
1947     mapping(uint => ClaimTotalTokens) internal claimTokensMV;
1948     mapping(uint => int8) internal claimVote;
1949     mapping(uint => uint) internal claimsStatus;
1950     mapping(uint => uint) internal claimState12Count;
1951     mapping(uint => uint[]) internal claimVoteCA;
1952     mapping(uint => uint[]) internal claimVoteMember;
1953     mapping(address => uint[]) internal voteAddressCA;
1954     mapping(address => uint[]) internal voteAddressMember;
1955     mapping(address => uint[]) internal allClaimsByAddress;
1956     mapping(address => mapping(uint => uint)) internal userClaimVoteCA;
1957     mapping(address => mapping(uint => uint)) internal userClaimVoteMember;
1958     mapping(address => uint) public userClaimVotePausedOn;
1959 
1960     uint internal claimPauseLastsubmit;
1961     uint internal claimStartVotingFirstIndex;
1962     uint public pendingClaimStart;
1963     uint public claimDepositTime;
1964     uint public maxVotingTime;
1965     uint public minVotingTime;
1966     uint public payoutRetryTime;
1967     uint public claimRewardPerc;
1968     uint public minVoteThreshold;
1969     uint public maxVoteThreshold;
1970     uint public majorityConsensus;
1971     uint public pauseDaysCA;
1972    
1973     event ClaimRaise(
1974         uint indexed coverId,
1975         address indexed userAddress,
1976         uint claimId,
1977         uint dateSubmit
1978     );
1979 
1980     event VoteCast(
1981         address indexed userAddress,
1982         uint indexed claimId,
1983         bytes4 indexed typeOf,
1984         uint tokens,
1985         uint submitDate,
1986         int8 verdict
1987     );
1988 
1989     constructor() public {
1990         pendingClaimStart = 1;
1991         maxVotingTime = 48 * 1 hours;
1992         minVotingTime = 12 * 1 hours;
1993         payoutRetryTime = 24 * 1 hours;
1994         allvotes.push(Vote(address(0), 0, 0, 0, false));
1995         allClaims.push(Claim(0, 0));
1996         claimDepositTime = 7 days;
1997         claimRewardPerc = 20;
1998         minVoteThreshold = 5;
1999         maxVoteThreshold = 10;
2000         majorityConsensus = 70;
2001         pauseDaysCA = 3 days;
2002         _addRewardIncentive();
2003     }
2004 
2005     /**
2006      * @dev Updates the pending claim start variable, 
2007      * the lowest claim id with a pending decision/payout.
2008      */ 
2009     function setpendingClaimStart(uint _start) external onlyInternal {
2010         require(pendingClaimStart <= _start);
2011         pendingClaimStart = _start;
2012     }
2013 
2014     /** 
2015      * @dev Updates the max vote index for which claim assessor has received reward 
2016      * @param _voter address of the voter.
2017      * @param caIndex last index till which reward was distributed for CA
2018      */ 
2019     function setRewardDistributedIndexCA(address _voter, uint caIndex) external onlyInternal {
2020         voterVoteRewardReceived[_voter].lastCAvoteIndex = caIndex;
2021 
2022     }
2023 
2024     /** 
2025      * @dev Used to pause claim assessor activity for 3 days 
2026      * @param user Member address whose claim voting ability needs to be paused
2027      */ 
2028     function setUserClaimVotePausedOn(address user) external {
2029         require(ms.checkIsAuthToGoverned(msg.sender));
2030         userClaimVotePausedOn[user] = now;
2031     }
2032 
2033     /**
2034      * @dev Updates the max vote index for which member has received reward 
2035      * @param _voter address of the voter.
2036      * @param mvIndex last index till which reward was distributed for member 
2037      */ 
2038     function setRewardDistributedIndexMV(address _voter, uint mvIndex) external onlyInternal {
2039 
2040         voterVoteRewardReceived[_voter].lastMVvoteIndex = mvIndex;
2041     }
2042 
2043     /**
2044      * @param claimid claim id.
2045      * @param percCA reward Percentage reward for claim assessor
2046      * @param percMV reward Percentage reward for members
2047      * @param tokens total tokens to be rewarded
2048      */ 
2049     function setClaimRewardDetail(
2050         uint claimid,
2051         uint percCA,
2052         uint percMV,
2053         uint tokens
2054     )
2055         external
2056         onlyInternal
2057     {
2058         claimRewardDetail[claimid].percCA = percCA;
2059         claimRewardDetail[claimid].percMV = percMV;
2060         claimRewardDetail[claimid].tokenToBeDist = tokens;
2061     }
2062 
2063     /**
2064      * @dev Sets the reward claim status against a vote id.
2065      * @param _voteid vote Id.
2066      * @param claimed true if reward for vote is claimed, else false.
2067      */ 
2068     function setRewardClaimed(uint _voteid, bool claimed) external onlyInternal {
2069         allvotes[_voteid].rewardClaimed = claimed;
2070     }
2071 
2072     /**
2073      * @dev Sets the final vote's result(either accepted or declined)of a claim.
2074      * @param _claimId Claim Id.
2075      * @param _verdict 1 if claim is accepted,-1 if declined.
2076      */ 
2077     function changeFinalVerdict(uint _claimId, int8 _verdict) external onlyInternal {
2078         claimVote[_claimId] = _verdict;
2079     }
2080     
2081     /**
2082      * @dev Creates a new claim.
2083      */ 
2084     function addClaim(
2085         uint _claimId,
2086         uint _coverId,
2087         address _from,
2088         uint _nowtime
2089     )
2090         external
2091         onlyInternal
2092     {
2093         allClaims.push(Claim(_coverId, _nowtime));
2094         allClaimsByAddress[_from].push(_claimId);
2095     }
2096 
2097     /**
2098      * @dev Add Vote's details of a given claim.
2099      */ 
2100     function addVote(
2101         address _voter,
2102         uint _tokens,
2103         uint claimId,
2104         int8 _verdict
2105     ) 
2106         external
2107         onlyInternal
2108     {
2109         allvotes.push(Vote(_voter, _tokens, claimId, _verdict, false));
2110     }
2111 
2112     /** 
2113      * @dev Stores the id of the claim assessor vote given to a claim.
2114      * Maintains record of all votes given by all the CA to a claim.
2115      * @param _claimId Claim Id to which vote has given by the CA.
2116      * @param _voteid Vote Id.
2117      */
2118     function addClaimVoteCA(uint _claimId, uint _voteid) external onlyInternal {
2119         claimVoteCA[_claimId].push(_voteid);
2120     }
2121 
2122     /** 
2123      * @dev Sets the id of the vote.
2124      * @param _from Claim assessor's address who has given the vote.
2125      * @param _claimId Claim Id for which vote has been given by the CA.
2126      * @param _voteid Vote Id which will be stored against the given _from and claimid.
2127      */ 
2128     function setUserClaimVoteCA(
2129         address _from,
2130         uint _claimId,
2131         uint _voteid
2132     )
2133         external
2134         onlyInternal
2135     {
2136         userClaimVoteCA[_from][_claimId] = _voteid;
2137         voteAddressCA[_from].push(_voteid);
2138     }
2139 
2140     /**
2141      * @dev Stores the tokens locked by the Claim Assessors during voting of a given claim.
2142      * @param _claimId Claim Id.
2143      * @param _vote 1 for accept and increases the tokens of claim as accept,
2144      * -1 for deny and increases the tokens of claim as deny.
2145      * @param _tokens Number of tokens.
2146      */ 
2147     function setClaimTokensCA(uint _claimId, int8 _vote, uint _tokens) external onlyInternal {
2148         if (_vote == 1)
2149             claimTokensCA[_claimId].accept = claimTokensCA[_claimId].accept.add(_tokens);
2150         if (_vote == -1)
2151             claimTokensCA[_claimId].deny = claimTokensCA[_claimId].deny.add(_tokens);
2152     }
2153 
2154     /** 
2155      * @dev Stores the tokens locked by the Members during voting of a given claim.
2156      * @param _claimId Claim Id.
2157      * @param _vote 1 for accept and increases the tokens of claim as accept,
2158      * -1 for deny and increases the tokens of claim as deny.
2159      * @param _tokens Number of tokens.
2160      */ 
2161     function setClaimTokensMV(uint _claimId, int8 _vote, uint _tokens) external onlyInternal {
2162         if (_vote == 1)
2163             claimTokensMV[_claimId].accept = claimTokensMV[_claimId].accept.add(_tokens);
2164         if (_vote == -1)
2165             claimTokensMV[_claimId].deny = claimTokensMV[_claimId].deny.add(_tokens);
2166     }
2167 
2168     /** 
2169      * @dev Stores the id of the member vote given to a claim.
2170      * Maintains record of all votes given by all the Members to a claim.
2171      * @param _claimId Claim Id to which vote has been given by the Member.
2172      * @param _voteid Vote Id.
2173      */ 
2174     function addClaimVotemember(uint _claimId, uint _voteid) external onlyInternal {
2175         claimVoteMember[_claimId].push(_voteid);
2176     }
2177 
2178     /** 
2179      * @dev Sets the id of the vote.
2180      * @param _from Member's address who has given the vote.
2181      * @param _claimId Claim Id for which vote has been given by the Member.
2182      * @param _voteid Vote Id which will be stored against the given _from and claimid.
2183      */ 
2184     function setUserClaimVoteMember(
2185         address _from,
2186         uint _claimId,
2187         uint _voteid
2188     )
2189         external
2190         onlyInternal
2191     {
2192         userClaimVoteMember[_from][_claimId] = _voteid;
2193         voteAddressMember[_from].push(_voteid);
2194 
2195     }
2196 
2197     /** 
2198      * @dev Increases the count of failure until payout of a claim is successful.
2199      */ 
2200     function updateState12Count(uint _claimId, uint _cnt) external onlyInternal {
2201         claimState12Count[_claimId] = claimState12Count[_claimId].add(_cnt);
2202     }
2203 
2204     /** 
2205      * @dev Sets status of a claim.
2206      * @param _claimId Claim Id.
2207      * @param _stat Status number.
2208      */
2209     function setClaimStatus(uint _claimId, uint _stat) external onlyInternal {
2210         claimsStatus[_claimId] = _stat;
2211     }
2212 
2213     /** 
2214      * @dev Sets the timestamp of a given claim at which the Claim's details has been updated.
2215      * @param _claimId Claim Id of claim which has been changed.
2216      * @param _dateUpd timestamp at which claim is updated.
2217      */ 
2218     function setClaimdateUpd(uint _claimId, uint _dateUpd) external onlyInternal {
2219         allClaims[_claimId].dateUpd = _dateUpd;
2220     }
2221 
2222     /** 
2223      @dev Queues Claims during Emergency Pause.
2224      */ 
2225     function setClaimAtEmergencyPause(
2226         uint _coverId,
2227         uint _dateUpd,
2228         bool _submit
2229     )
2230         external
2231         onlyInternal
2232     {
2233         claimPause.push(ClaimsPause(_coverId, _dateUpd, _submit));
2234     }
2235 
2236     /** 
2237      * @dev Set submission flag for Claims queued during emergency pause.
2238      * Set to true after EP is turned off and the claim is submitted .
2239      */ 
2240     function setClaimSubmittedAtEPTrue(uint _index, bool _submit) external onlyInternal {
2241         claimPause[_index].submit = _submit;
2242     }
2243 
2244     /** 
2245      * @dev Sets the index from which claim needs to be 
2246      * submitted when emergency pause is swithched off.
2247      */ 
2248     function setFirstClaimIndexToSubmitAfterEP(
2249         uint _firstClaimIndexToSubmit
2250     )
2251         external
2252         onlyInternal
2253     {
2254         claimPauseLastsubmit = _firstClaimIndexToSubmit;
2255     }
2256 
2257     /** 
2258      * @dev Sets the pending vote duration for a claim in case of emergency pause.
2259      */ 
2260     function setPendingClaimDetails(
2261         uint _claimId,
2262         uint _pendingTime,
2263         bool _voting
2264     )
2265         external
2266         onlyInternal
2267     {
2268         claimPauseVotingEP.push(ClaimPauseVoting(_claimId, _pendingTime, _voting));
2269     }
2270 
2271     /** 
2272      * @dev Sets voting flag true after claim is reopened for voting after emergency pause.
2273      */ 
2274     function setPendingClaimVoteStatus(uint _claimId, bool _vote) external onlyInternal {
2275         claimPauseVotingEP[_claimId].voting = _vote;
2276     }
2277     
2278     /** 
2279      * @dev Sets the index from which claim needs to be 
2280      * reopened when emergency pause is swithched off. 
2281      */ 
2282     function setFirstClaimIndexToStartVotingAfterEP(
2283         uint _claimStartVotingFirstIndex
2284     )
2285         external
2286         onlyInternal
2287     {
2288         claimStartVotingFirstIndex = _claimStartVotingFirstIndex;
2289     }
2290 
2291     /** 
2292      * @dev Calls Vote Event.
2293      */ 
2294     function callVoteEvent(
2295         address _userAddress,
2296         uint _claimId,
2297         bytes4 _typeOf,
2298         uint _tokens,
2299         uint _submitDate,
2300         int8 _verdict
2301     )
2302         external
2303         onlyInternal
2304     {
2305         emit VoteCast(
2306             _userAddress,
2307             _claimId,
2308             _typeOf,
2309             _tokens,
2310             _submitDate,
2311             _verdict
2312         );
2313     }
2314 
2315     /** 
2316      * @dev Calls Claim Event. 
2317      */ 
2318     function callClaimEvent(
2319         uint _coverId,
2320         address _userAddress,
2321         uint _claimId,
2322         uint _datesubmit
2323     ) 
2324         external
2325         onlyInternal
2326     {
2327         emit ClaimRaise(_coverId, _userAddress, _claimId, _datesubmit);
2328     }
2329 
2330     /**
2331      * @dev Gets Uint Parameters by parameter code
2332      * @param code whose details we want
2333      * @return string value of the parameter
2334      * @return associated amount (time or perc or value) to the code
2335      */
2336     function getUintParameters(bytes8 code) external view returns (bytes8 codeVal, uint val) {
2337         codeVal = code;
2338         if (code == "CAMAXVT") {
2339             val = maxVotingTime / (1 hours);
2340 
2341         } else if (code == "CAMINVT") {
2342 
2343             val = minVotingTime / (1 hours);
2344 
2345         } else if (code == "CAPRETRY") {
2346 
2347             val = payoutRetryTime / (1 hours);
2348 
2349         } else if (code == "CADEPT") {
2350 
2351             val = claimDepositTime / (1 days);
2352 
2353         } else if (code == "CAREWPER") {
2354 
2355             val = claimRewardPerc;
2356 
2357         } else if (code == "CAMINTH") {
2358 
2359             val = minVoteThreshold;
2360 
2361         } else if (code == "CAMAXTH") {
2362 
2363             val = maxVoteThreshold;
2364 
2365         } else if (code == "CACONPER") {
2366 
2367             val = majorityConsensus;
2368 
2369         } else if (code == "CAPAUSET") {
2370             val = pauseDaysCA / (1 days);
2371         }
2372     
2373     }
2374 
2375     /**
2376      * @dev Get claim queued during emergency pause by index.
2377      */ 
2378     function getClaimOfEmergencyPauseByIndex(
2379         uint _index
2380     ) 
2381         external
2382         view
2383         returns(
2384             uint coverId,
2385             uint dateUpd,
2386             bool submit
2387         )
2388     {
2389         coverId = claimPause[_index].coverid;
2390         dateUpd = claimPause[_index].dateUpd;
2391         submit = claimPause[_index].submit;
2392     }
2393 
2394     /**
2395      * @dev Gets the Claim's details of given claimid.   
2396      */ 
2397     function getAllClaimsByIndex(
2398         uint _claimId
2399     )
2400         external
2401         view
2402         returns(
2403             uint coverId,
2404             int8 vote,
2405             uint status,
2406             uint dateUpd,
2407             uint state12Count
2408         )
2409     {
2410         return(
2411             allClaims[_claimId].coverId,
2412             claimVote[_claimId],
2413             claimsStatus[_claimId],
2414             allClaims[_claimId].dateUpd,
2415             claimState12Count[_claimId]
2416         );
2417     }
2418 
2419     /** 
2420      * @dev Gets the vote id of a given claim of a given Claim Assessor.
2421      */ 
2422     function getUserClaimVoteCA(
2423         address _add,
2424         uint _claimId
2425     )
2426         external
2427         view
2428         returns(uint idVote)
2429     {
2430         return userClaimVoteCA[_add][_claimId];
2431     }
2432 
2433     /** 
2434      * @dev Gets the vote id of a given claim of a given member.
2435      */
2436     function getUserClaimVoteMember(
2437         address _add,
2438         uint _claimId
2439     )
2440         external
2441         view
2442         returns(uint idVote)
2443     {
2444         return userClaimVoteMember[_add][_claimId];
2445     }
2446 
2447     /** 
2448      * @dev Gets the count of all votes.
2449      */ 
2450     function getAllVoteLength() external view returns(uint voteCount) {
2451         return allvotes.length.sub(1); //Start Index always from 1.
2452     }
2453 
2454     /**
2455      * @dev Gets the status number of a given claim.
2456      * @param _claimId Claim id.
2457      * @return statno Status Number. 
2458      */ 
2459     function getClaimStatusNumber(uint _claimId) external view returns(uint claimId, uint statno) {
2460         return (_claimId, claimsStatus[_claimId]);
2461     }
2462 
2463     /**
2464      * @dev Gets the reward percentage to be distributed for a given status id
2465      * @param statusNumber the number of type of status
2466      * @return percCA reward Percentage for claim assessor
2467      * @return percMV reward Percentage for members
2468      */
2469     function getRewardStatus(uint statusNumber) external view returns(uint percCA, uint percMV) {
2470         return (rewardStatus[statusNumber].percCA, rewardStatus[statusNumber].percMV);
2471     }
2472 
2473     /** 
2474      * @dev Gets the number of tries that have been made for a successful payout of a Claim.
2475      */ 
2476     function getClaimState12Count(uint _claimId) external view returns(uint num) {
2477         num = claimState12Count[_claimId];
2478     }
2479 
2480     /** 
2481      * @dev Gets the last update date of a claim.
2482      */ 
2483     function getClaimDateUpd(uint _claimId) external view returns(uint dateupd) {
2484         dateupd = allClaims[_claimId].dateUpd;
2485     }
2486 
2487     /**
2488      * @dev Gets all Claims created by a user till date.
2489      * @param _member user's address.
2490      * @return claimarr List of Claims id.
2491      */ 
2492     function getAllClaimsByAddress(address _member) external view returns(uint[] memory claimarr) {
2493         return allClaimsByAddress[_member];
2494     }
2495 
2496     /**
2497      * @dev Gets the number of tokens that has been locked 
2498      * while giving vote to a claim by  Claim Assessors.
2499      * @param _claimId Claim Id.
2500      * @return accept Total number of tokens when CA accepts the claim.
2501      * @return deny Total number of tokens when CA declines the claim.
2502      */ 
2503     function getClaimsTokenCA(
2504         uint _claimId
2505     )
2506         external
2507         view
2508         returns(
2509             uint claimId,
2510             uint accept,
2511             uint deny
2512         )
2513     {
2514         return (
2515             _claimId,
2516             claimTokensCA[_claimId].accept,
2517             claimTokensCA[_claimId].deny
2518         );
2519     }
2520 
2521     /** 
2522      * @dev Gets the number of tokens that have been
2523      * locked while assessing a claim as a member.
2524      * @param _claimId Claim Id.
2525      * @return accept Total number of tokens in acceptance of the claim.
2526      * @return deny Total number of tokens against the claim.
2527      */ 
2528     function getClaimsTokenMV(
2529         uint _claimId
2530     )
2531         external
2532         view
2533         returns(
2534             uint claimId,
2535             uint accept,
2536             uint deny
2537         )
2538     {
2539         return (
2540             _claimId,
2541             claimTokensMV[_claimId].accept,
2542             claimTokensMV[_claimId].deny
2543         );
2544     }
2545 
2546     /**
2547      * @dev Gets the total number of votes cast as Claims assessor for/against a given claim
2548      */ 
2549     function getCaClaimVotesToken(uint _claimId) external view returns(uint claimId, uint cnt) {
2550         claimId = _claimId;
2551         cnt = 0;
2552         for (uint i = 0; i < claimVoteCA[_claimId].length; i++) {
2553             cnt = cnt.add(allvotes[claimVoteCA[_claimId][i]].tokens);
2554         }
2555     }
2556 
2557     /**
2558      * @dev Gets the total number of tokens cast as a member for/against a given claim  
2559      */ 
2560     function getMemberClaimVotesToken(
2561         uint _claimId
2562     )   
2563         external
2564         view
2565         returns(uint claimId, uint cnt)
2566     {
2567         claimId = _claimId;
2568         cnt = 0;
2569         for (uint i = 0; i < claimVoteMember[_claimId].length; i++) {
2570             cnt = cnt.add(allvotes[claimVoteMember[_claimId][i]].tokens);
2571         }
2572     }
2573 
2574     /**
2575      * @dev Provides information of a vote when given its vote id.
2576      * @param _voteid Vote Id.
2577      */
2578     function getVoteDetails(uint _voteid)
2579     external view
2580     returns(
2581         uint tokens,
2582         uint claimId,
2583         int8 verdict,
2584         bool rewardClaimed
2585         )
2586     {
2587         return (
2588             allvotes[_voteid].tokens,
2589             allvotes[_voteid].claimId,
2590             allvotes[_voteid].verdict,
2591             allvotes[_voteid].rewardClaimed
2592         );
2593     }
2594 
2595     /**
2596      * @dev Gets the voter's address of a given vote id.
2597      */ 
2598     function getVoterVote(uint _voteid) external view returns(address voter) {
2599         return allvotes[_voteid].voter;
2600     }
2601 
2602     /**
2603      * @dev Provides information of a Claim when given its claim id.
2604      * @param _claimId Claim Id.
2605      */ 
2606     function getClaim(
2607         uint _claimId
2608     )
2609         external
2610         view
2611         returns(
2612             uint claimId,
2613             uint coverId,
2614             int8 vote,
2615             uint status,
2616             uint dateUpd,
2617             uint state12Count
2618         )
2619     {
2620         return (
2621             _claimId,
2622             allClaims[_claimId].coverId,
2623             claimVote[_claimId],
2624             claimsStatus[_claimId],
2625             allClaims[_claimId].dateUpd,
2626             claimState12Count[_claimId]
2627             );
2628     }
2629 
2630     /**
2631      * @dev Gets the total number of votes of a given claim.
2632      * @param _claimId Claim Id.
2633      * @param _ca if 1: votes given by Claim Assessors to a claim,
2634      * else returns the number of votes of given by Members to a claim.
2635      * @return len total number of votes for/against a given claim.
2636      */ 
2637     function getClaimVoteLength(
2638         uint _claimId,
2639         uint8 _ca
2640     )
2641         external
2642         view
2643         returns(uint claimId, uint len)
2644     {
2645         claimId = _claimId;
2646         if (_ca == 1)
2647             len = claimVoteCA[_claimId].length;
2648         else
2649             len = claimVoteMember[_claimId].length;
2650     }
2651 
2652     /**
2653      * @dev Gets the verdict of a vote using claim id and index.
2654      * @param _ca 1 for vote given as a CA, else for vote given as a member.
2655      * @return ver 1 if vote was given in favour,-1 if given in against.
2656      */ 
2657     function getVoteVerdict(
2658         uint _claimId,
2659         uint _index,
2660         uint8 _ca
2661     )
2662         external
2663         view
2664         returns(int8 ver)
2665     {
2666         if (_ca == 1)
2667             ver = allvotes[claimVoteCA[_claimId][_index]].verdict;
2668         else
2669             ver = allvotes[claimVoteMember[_claimId][_index]].verdict;
2670     }
2671 
2672     /**
2673      * @dev Gets the Number of tokens of a vote using claim id and index.
2674      * @param _ca 1 for vote given as a CA, else for vote given as a member.
2675      * @return tok Number of tokens.
2676      */ 
2677     function getVoteToken(
2678         uint _claimId,
2679         uint _index,
2680         uint8 _ca
2681     )   
2682         external
2683         view
2684         returns(uint tok)
2685     {
2686         if (_ca == 1)
2687             tok = allvotes[claimVoteCA[_claimId][_index]].tokens;
2688         else
2689             tok = allvotes[claimVoteMember[_claimId][_index]].tokens;
2690     }
2691 
2692     /**
2693      * @dev Gets the Voter's address of a vote using claim id and index.
2694      * @param _ca 1 for vote given as a CA, else for vote given as a member.
2695      * @return voter Voter's address.
2696      */ 
2697     function getVoteVoter(
2698         uint _claimId,
2699         uint _index,
2700         uint8 _ca
2701     )
2702         external
2703         view
2704         returns(address voter)
2705     {
2706         if (_ca == 1)
2707             voter = allvotes[claimVoteCA[_claimId][_index]].voter;
2708         else
2709             voter = allvotes[claimVoteMember[_claimId][_index]].voter;
2710     }
2711 
2712     /** 
2713      * @dev Gets total number of Claims created by a user till date.
2714      * @param _add User's address.
2715      */ 
2716     function getUserClaimCount(address _add) external view returns(uint len) {
2717         len = allClaimsByAddress[_add].length;
2718     }
2719 
2720     /**
2721      * @dev Calculates number of Claims that are in pending state.
2722      */ 
2723     function getClaimLength() external view returns(uint len) {
2724         len = allClaims.length.sub(pendingClaimStart);
2725     }
2726 
2727     /**
2728      * @dev Gets the Number of all the Claims created till date.
2729      */ 
2730     function actualClaimLength() external view returns(uint len) {
2731         len = allClaims.length;
2732     }
2733 
2734     /** 
2735      * @dev Gets details of a claim.
2736      * @param _index claim id = pending claim start + given index
2737      * @param _add User's address.
2738      * @return coverid cover against which claim has been submitted.
2739      * @return claimId Claim  Id.
2740      * @return voteCA verdict of vote given as a Claim Assessor.  
2741      * @return voteMV verdict of vote given as a Member.
2742      * @return statusnumber Status of claim.
2743      */ 
2744     function getClaimFromNewStart(
2745         uint _index,
2746         address _add
2747     )
2748         external
2749         view
2750         returns(
2751             uint coverid,
2752             uint claimId,
2753             int8 voteCA,
2754             int8 voteMV,
2755             uint statusnumber
2756         )
2757     {
2758         uint i = pendingClaimStart.add(_index);
2759         coverid = allClaims[i].coverId;
2760         claimId = i;
2761         if (userClaimVoteCA[_add][i] > 0)
2762             voteCA = allvotes[userClaimVoteCA[_add][i]].verdict;
2763         else
2764             voteCA = 0;
2765 
2766         if (userClaimVoteMember[_add][i] > 0)
2767             voteMV = allvotes[userClaimVoteMember[_add][i]].verdict;
2768         else
2769             voteMV = 0;
2770 
2771         statusnumber = claimsStatus[i];
2772     }
2773 
2774     /**
2775      * @dev Gets details of a claim of a user at a given index.  
2776      */ 
2777     function getUserClaimByIndex(
2778         uint _index,
2779         address _add
2780     )
2781         external
2782         view
2783         returns(
2784             uint status,
2785             uint coverid,
2786             uint claimId
2787         )
2788     {
2789         claimId = allClaimsByAddress[_add][_index];
2790         status = claimsStatus[claimId];
2791         coverid = allClaims[claimId].coverId;
2792     }
2793 
2794     /**
2795      * @dev Gets Id of all the votes given to a claim.
2796      * @param _claimId Claim Id.
2797      * @return ca id of all the votes given by Claim assessors to a claim.
2798      * @return mv id of all the votes given by members to a claim.
2799      */ 
2800     function getAllVotesForClaim(
2801         uint _claimId
2802     )
2803         external
2804         view
2805         returns(
2806             uint claimId,
2807             uint[] memory ca,
2808             uint[] memory mv
2809         )
2810     {
2811         return (_claimId, claimVoteCA[_claimId], claimVoteMember[_claimId]);
2812     }
2813 
2814     /** 
2815      * @dev Gets Number of tokens deposit in a vote using
2816      * Claim assessor's address and claim id.
2817      * @return tokens Number of deposited tokens.
2818      */ 
2819     function getTokensClaim(
2820         address _of,
2821         uint _claimId
2822     )
2823         external
2824         view
2825         returns(
2826             uint claimId,
2827             uint tokens
2828         )
2829     {
2830         return (_claimId, allvotes[userClaimVoteCA[_of][_claimId]].tokens);
2831     }
2832 
2833     /**
2834      * @param _voter address of the voter.
2835      * @return lastCAvoteIndex last index till which reward was distributed for CA
2836      * @return lastMVvoteIndex last index till which reward was distributed for member
2837      */ 
2838     function getRewardDistributedIndex(
2839         address _voter
2840     ) 
2841         external
2842         view
2843         returns(
2844             uint lastCAvoteIndex,
2845             uint lastMVvoteIndex
2846         )
2847     {
2848         return (
2849             voterVoteRewardReceived[_voter].lastCAvoteIndex,
2850             voterVoteRewardReceived[_voter].lastMVvoteIndex
2851         );
2852     }
2853 
2854     /**
2855      * @param claimid claim id.
2856      * @return perc_CA reward Percentage for claim assessor
2857      * @return perc_MV reward Percentage for members
2858      * @return tokens total tokens to be rewarded 
2859      */ 
2860     function getClaimRewardDetail(
2861         uint claimid
2862     ) 
2863         external
2864         view
2865         returns(
2866             uint percCA,
2867             uint percMV,
2868             uint tokens
2869         )
2870     {
2871         return (
2872             claimRewardDetail[claimid].percCA,
2873             claimRewardDetail[claimid].percMV,
2874             claimRewardDetail[claimid].tokenToBeDist
2875         );
2876     }
2877 
2878     /**
2879      * @dev Gets cover id of a claim.
2880      */ 
2881     function getClaimCoverId(uint _claimId) external view returns(uint claimId, uint coverid) {
2882         return (_claimId, allClaims[_claimId].coverId);
2883     }
2884 
2885     /**
2886      * @dev Gets total number of tokens staked during voting by Claim Assessors.
2887      * @param _claimId Claim Id.
2888      * @param _verdict 1 to get total number of accept tokens, -1 to get total number of deny tokens.
2889      * @return token token Number of tokens(either accept or deny on the basis of verdict given as parameter).
2890      */ 
2891     function getClaimVote(uint _claimId, int8 _verdict) external view returns(uint claimId, uint token) {
2892         claimId = _claimId;
2893         token = 0;
2894         for (uint i = 0; i < claimVoteCA[_claimId].length; i++) {
2895             if (allvotes[claimVoteCA[_claimId][i]].verdict == _verdict)
2896                 token = token.add(allvotes[claimVoteCA[_claimId][i]].tokens);
2897         }
2898     }
2899 
2900     /**
2901      * @dev Gets total number of tokens staked during voting by Members.
2902      * @param _claimId Claim Id.
2903      * @param _verdict 1 to get total number of accept tokens,
2904      *  -1 to get total number of deny tokens.
2905      * @return token token Number of tokens(either accept or 
2906      * deny on the basis of verdict given as parameter).
2907      */ 
2908     function getClaimMVote(uint _claimId, int8 _verdict) external view returns(uint claimId, uint token) {
2909         claimId = _claimId;
2910         token = 0;
2911         for (uint i = 0; i < claimVoteMember[_claimId].length; i++) {
2912             if (allvotes[claimVoteMember[_claimId][i]].verdict == _verdict)
2913                 token = token.add(allvotes[claimVoteMember[_claimId][i]].tokens);
2914         }
2915     }
2916 
2917     /**
2918      * @param _voter address  of voteid
2919      * @param index index to get voteid in CA
2920      */ 
2921     function getVoteAddressCA(address _voter, uint index) external view returns(uint) {
2922         return voteAddressCA[_voter][index];
2923     }
2924 
2925     /**
2926      * @param _voter address  of voter
2927      * @param index index to get voteid in member vote
2928      */ 
2929     function getVoteAddressMember(address _voter, uint index) external view returns(uint) {
2930         return voteAddressMember[_voter][index];
2931     }
2932 
2933     /**
2934      * @param _voter address  of voter   
2935      */ 
2936     function getVoteAddressCALength(address _voter) external view returns(uint) {
2937         return voteAddressCA[_voter].length;
2938     }
2939 
2940     /**
2941      * @param _voter address  of voter   
2942      */ 
2943     function getVoteAddressMemberLength(address _voter) external view returns(uint) {
2944         return voteAddressMember[_voter].length;
2945     }
2946 
2947     /**
2948      * @dev Gets the Final result of voting of a claim.
2949      * @param _claimId Claim id.
2950      * @return verdict 1 if claim is accepted, -1 if declined.
2951      */ 
2952     function getFinalVerdict(uint _claimId) external view returns(int8 verdict) {
2953         return claimVote[_claimId];
2954     }
2955 
2956     /**
2957      * @dev Get number of Claims queued for submission during emergency pause.
2958      */ 
2959     function getLengthOfClaimSubmittedAtEP() external view returns(uint len) {
2960         len = claimPause.length;
2961     }
2962 
2963     /**
2964      * @dev Gets the index from which claim needs to be 
2965      * submitted when emergency pause is swithched off.
2966      */ 
2967     function getFirstClaimIndexToSubmitAfterEP() external view returns(uint indexToSubmit) {
2968         indexToSubmit = claimPauseLastsubmit;
2969     }
2970     
2971     /**
2972      * @dev Gets number of Claims to be reopened for voting post emergency pause period.
2973      */ 
2974     function getLengthOfClaimVotingPause() external view returns(uint len) {
2975         len = claimPauseVotingEP.length;
2976     }
2977 
2978     /**
2979      * @dev Gets claim details to be reopened for voting after emergency pause.
2980      */ 
2981     function getPendingClaimDetailsByIndex(
2982         uint _index
2983     )
2984         external
2985         view
2986         returns(
2987             uint claimId,
2988             uint pendingTime,
2989             bool voting
2990         )
2991     {
2992         claimId = claimPauseVotingEP[_index].claimid;
2993         pendingTime = claimPauseVotingEP[_index].pendingTime;
2994         voting = claimPauseVotingEP[_index].voting;
2995     }
2996 
2997     /** 
2998      * @dev Gets the index from which claim needs to be reopened when emergency pause is swithched off.
2999      */ 
3000     function getFirstClaimIndexToStartVotingAfterEP() external view returns(uint firstindex) {
3001         firstindex = claimStartVotingFirstIndex;
3002     }
3003 
3004     /**
3005      * @dev Updates Uint Parameters of a code
3006      * @param code whose details we want to update
3007      * @param val value to set
3008      */
3009     function updateUintParameters(bytes8 code, uint val) public {
3010         require(ms.checkIsAuthToGoverned(msg.sender));
3011         if (code == "CAMAXVT") {
3012             _setMaxVotingTime(val * 1 hours);
3013 
3014         } else if (code == "CAMINVT") {
3015 
3016             _setMinVotingTime(val * 1 hours);
3017 
3018         } else if (code == "CAPRETRY") {
3019 
3020             _setPayoutRetryTime(val * 1 hours);
3021 
3022         } else if (code == "CADEPT") {
3023 
3024             _setClaimDepositTime(val * 1 days);
3025 
3026         } else if (code == "CAREWPER") {
3027 
3028             _setClaimRewardPerc(val);
3029 
3030         } else if (code == "CAMINTH") {
3031 
3032             _setMinVoteThreshold(val);
3033 
3034         } else if (code == "CAMAXTH") {
3035 
3036             _setMaxVoteThreshold(val);
3037 
3038         } else if (code == "CACONPER") {
3039 
3040             _setMajorityConsensus(val);
3041 
3042         } else if (code == "CAPAUSET") {
3043             _setPauseDaysCA(val * 1 days);
3044         } else {
3045 
3046             revert("Invalid param code");
3047         }
3048     
3049     }
3050 
3051     /**
3052      * @dev Iupgradable Interface to update dependent contract address
3053      */
3054     function changeDependentContractAddress() public onlyInternal {}
3055 
3056     /**
3057      * @dev Adds status under which a claim can lie.
3058      * @param percCA reward percentage for claim assessor
3059      * @param percMV reward percentage for members
3060      */
3061     function _pushStatus(uint percCA, uint percMV) internal {
3062         rewardStatus.push(ClaimRewardStatus(percCA, percMV));
3063     }
3064 
3065     /**
3066      * @dev adds reward incentive for all possible claim status for Claim assessors and members
3067      */
3068     function _addRewardIncentive() internal {
3069         _pushStatus(0, 0); //0  Pending-Claim Assessor Vote
3070         _pushStatus(0, 0); //1 Pending-Claim Assessor Vote Denied, Pending Member Vote
3071         _pushStatus(0, 0); //2 Pending-CA Vote Threshold not Reached Accept, Pending Member Vote
3072         _pushStatus(0, 0); //3 Pending-CA Vote Threshold not Reached Deny, Pending Member Vote
3073         _pushStatus(0, 0); //4 Pending-CA Consensus not reached Accept, Pending Member Vote
3074         _pushStatus(0, 0); //5 Pending-CA Consensus not reached Deny, Pending Member Vote
3075         _pushStatus(100, 0); //6 Final-Claim Assessor Vote Denied
3076         _pushStatus(100, 0); //7 Final-Claim Assessor Vote Accepted
3077         _pushStatus(0, 100); //8 Final-Claim Assessor Vote Denied, MV Accepted
3078         _pushStatus(0, 100); //9 Final-Claim Assessor Vote Denied, MV Denied
3079         _pushStatus(0, 0); //10 Final-Claim Assessor Vote Accept, MV Nodecision
3080         _pushStatus(0, 0); //11 Final-Claim Assessor Vote Denied, MV Nodecision
3081         _pushStatus(0, 0); //12 Claim Accepted Payout Pending
3082         _pushStatus(0, 0); //13 Claim Accepted No Payout 
3083         _pushStatus(0, 0); //14 Claim Accepted Payout Done
3084     }
3085 
3086     /**
3087      * @dev Sets Maximum time(in seconds) for which claim assessment voting is open
3088      */ 
3089     function _setMaxVotingTime(uint _time) internal {
3090         maxVotingTime = _time;
3091     }
3092 
3093     /**
3094      *  @dev Sets Minimum time(in seconds) for which claim assessment voting is open
3095      */ 
3096     function _setMinVotingTime(uint _time) internal {
3097         minVotingTime = _time;
3098     }
3099 
3100     /**
3101      *  @dev Sets Minimum vote threshold required
3102      */ 
3103     function _setMinVoteThreshold(uint val) internal {
3104         minVoteThreshold = val;
3105     }
3106 
3107     /**
3108      *  @dev Sets Maximum vote threshold required
3109      */ 
3110     function _setMaxVoteThreshold(uint val) internal {
3111         maxVoteThreshold = val;
3112     }
3113     
3114     /**
3115      *  @dev Sets the value considered as Majority Consenus in voting
3116      */ 
3117     function _setMajorityConsensus(uint val) internal {
3118         majorityConsensus = val;
3119     }
3120 
3121     /**
3122      * @dev Sets the payout retry time
3123      */ 
3124     function _setPayoutRetryTime(uint _time) internal {
3125         payoutRetryTime = _time;
3126     }
3127 
3128     /**
3129      *  @dev Sets percentage of reward given for claim assessment
3130      */ 
3131     function _setClaimRewardPerc(uint _val) internal {
3132 
3133         claimRewardPerc = _val;
3134     }
3135   
3136     /** 
3137      * @dev Sets the time for which claim is deposited.
3138      */ 
3139     function _setClaimDepositTime(uint _time) internal {
3140 
3141         claimDepositTime = _time;
3142     }
3143 
3144     /**
3145      *  @dev Sets number of days claim assessment will be paused
3146      */ 
3147     function _setPauseDaysCA(uint val) internal {
3148         pauseDaysCA = val;
3149     }
3150 }
3151 
3152 /* Copyright (C) 2017 NexusMutual.io
3153 
3154   This program is free software: you can redistribute it and/or modify
3155     it under the terms of the GNU General Public License as published by
3156     the Free Software Foundation, either version 3 of the License, or
3157     (at your option) any later version.
3158 
3159   This program is distributed in the hope that it will be useful,
3160     but WITHOUT ANY WARRANTY; without even the implied warranty of
3161     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3162     GNU General Public License for more details.
3163 
3164   You should have received a copy of the GNU General Public License
3165     along with this program.  If not, see http://www.gnu.org/licenses/ */
3166 contract DSValue {
3167     function peek() public view returns (bytes32, bool);
3168     function read() public view returns (bytes32);
3169 }
3170 
3171 contract PoolData is Iupgradable {
3172     using SafeMath for uint;
3173 
3174     struct ApiId {
3175         bytes4 typeOf;
3176         bytes4 currency;
3177         uint id;
3178         uint64 dateAdd;
3179         uint64 dateUpd;
3180     }
3181 
3182     struct CurrencyAssets {
3183         address currAddress;
3184         uint baseMin;
3185         uint varMin;
3186     }
3187 
3188     struct InvestmentAssets {
3189         address currAddress;
3190         bool status;
3191         uint64 minHoldingPercX100;
3192         uint64 maxHoldingPercX100;
3193         uint8 decimals;
3194     }
3195 
3196     struct IARankDetails {
3197         bytes4 maxIACurr;
3198         uint64 maxRate;
3199         bytes4 minIACurr;
3200         uint64 minRate;
3201     }
3202 
3203     struct McrData {
3204         uint mcrPercx100;
3205         uint mcrEther;
3206         uint vFull; //Pool funds
3207         uint64 date;
3208     }
3209 
3210     IARankDetails[] internal allIARankDetails;
3211     McrData[] public allMCRData;
3212 
3213     bytes4[] internal allInvestmentCurrencies;
3214     bytes4[] internal allCurrencies;
3215     bytes32[] public allAPIcall;
3216     mapping(bytes32 => ApiId) public allAPIid;
3217     mapping(uint64 => uint) internal datewiseId;
3218     mapping(bytes16 => uint) internal currencyLastIndex;
3219     mapping(bytes4 => CurrencyAssets) internal allCurrencyAssets;
3220     mapping(bytes4 => InvestmentAssets) internal allInvestmentAssets;
3221     mapping(bytes4 => uint) internal caAvgRate;
3222     mapping(bytes4 => uint) internal iaAvgRate;
3223 
3224     address public notariseMCR;
3225     address public daiFeedAddress;
3226     uint private constant DECIMAL1E18 = uint(10) ** 18;
3227     uint public uniswapDeadline;
3228     uint public liquidityTradeCallbackTime;
3229     uint public lastLiquidityTradeTrigger;
3230     uint64 internal lastDate;
3231     uint public variationPercX100;
3232     uint public iaRatesTime;
3233     uint public minCap;
3234     uint public mcrTime;
3235     uint public a;
3236     uint public shockParameter;
3237     uint public c;
3238     uint public mcrFailTime; 
3239     uint public ethVolumeLimit;
3240     uint public capReached;
3241     uint public capacityLimit;
3242     
3243     constructor(address _notariseAdd, address _daiFeedAdd, address _daiAdd) public {
3244         notariseMCR = _notariseAdd;
3245         daiFeedAddress = _daiFeedAdd;
3246         c = 5800000;
3247         a = 1028;
3248         mcrTime = 24 hours;
3249         mcrFailTime = 6 hours;
3250         allMCRData.push(McrData(0, 0, 0, 0));
3251         minCap = 12000 * DECIMAL1E18;
3252         shockParameter = 50;
3253         variationPercX100 = 100; //1%
3254         iaRatesTime = 24 hours; //24 hours in seconds
3255         uniswapDeadline = 20 minutes;
3256         liquidityTradeCallbackTime = 4 hours;
3257         ethVolumeLimit = 4;
3258         capacityLimit = 10;
3259         allCurrencies.push("ETH");
3260         allCurrencyAssets["ETH"] = CurrencyAssets(address(0), 1000 * DECIMAL1E18, 0);
3261         allCurrencies.push("DAI");
3262         allCurrencyAssets["DAI"] = CurrencyAssets(_daiAdd, 50000 * DECIMAL1E18, 0);
3263         allInvestmentCurrencies.push("ETH");
3264         allInvestmentAssets["ETH"] = InvestmentAssets(address(0), true, 2500, 10000, 18);
3265         allInvestmentCurrencies.push("DAI");
3266         allInvestmentAssets["DAI"] = InvestmentAssets(_daiAdd, true, 250, 1500, 18);
3267     }
3268 
3269     /**
3270      * @dev to set the maximum cap allowed 
3271      * @param val is the new value
3272      */
3273     function setCapReached(uint val) external onlyInternal {
3274         capReached = val;
3275     }
3276     
3277     /// @dev Updates the 3 day average rate of a IA currency.
3278     /// To be replaced by MakerDao's on chain rates
3279     /// @param curr IA Currency Name.
3280     /// @param rate Average exchange rate X 100 (of last 3 days).
3281     function updateIAAvgRate(bytes4 curr, uint rate) external onlyInternal {
3282         iaAvgRate[curr] = rate;
3283     }
3284 
3285     /// @dev Updates the 3 day average rate of a CA currency.
3286     /// To be replaced by MakerDao's on chain rates
3287     /// @param curr Currency Name.
3288     /// @param rate Average exchange rate X 100 (of last 3 days).
3289     function updateCAAvgRate(bytes4 curr, uint rate) external onlyInternal {
3290         caAvgRate[curr] = rate;
3291     }
3292 
3293     /// @dev Adds details of (Minimum Capital Requirement)MCR.
3294     /// @param mcrp Minimum Capital Requirement percentage (MCR% * 100 ,Ex:for 54.56% ,given 5456)
3295     /// @param vf Pool fund value in Ether used in the last full daily calculation from the Capital model.
3296     function pushMCRData(uint mcrp, uint mcre, uint vf, uint64 time) external onlyInternal {
3297         allMCRData.push(McrData(mcrp, mcre, vf, time));
3298     }
3299 
3300     /** 
3301      * @dev Updates the Timestamp at which result of oracalize call is received.
3302      */  
3303     function updateDateUpdOfAPI(bytes32 myid) external onlyInternal {
3304         allAPIid[myid].dateUpd = uint64(now);
3305     }
3306 
3307     /** 
3308      * @dev Saves the details of the Oraclize API.
3309      * @param myid Id return by the oraclize query.
3310      * @param _typeof type of the query for which oraclize call is made.
3311      * @param id ID of the proposal,quote,cover etc. for which oraclize call is made 
3312      */  
3313     function saveApiDetails(bytes32 myid, bytes4 _typeof, uint id) external onlyInternal {
3314         allAPIid[myid] = ApiId(_typeof, "", id, uint64(now), uint64(now));
3315     }
3316 
3317     /** 
3318      * @dev Stores the id return by the oraclize query. 
3319      * Maintains record of all the Ids return by oraclize query.
3320      * @param myid Id return by the oraclize query.
3321      */  
3322     function addInAllApiCall(bytes32 myid) external onlyInternal {
3323         allAPIcall.push(myid);
3324     }
3325     
3326     /**
3327      * @dev Saves investment asset rank details.
3328      * @param maxIACurr Maximum ranked investment asset currency.
3329      * @param maxRate Maximum ranked investment asset rate.
3330      * @param minIACurr Minimum ranked investment asset currency.
3331      * @param minRate Minimum ranked investment asset rate.
3332      * @param date in yyyymmdd.
3333      */  
3334     function saveIARankDetails(
3335         bytes4 maxIACurr,
3336         uint64 maxRate,
3337         bytes4 minIACurr,
3338         uint64 minRate,
3339         uint64 date
3340     )
3341         external
3342         onlyInternal
3343     {
3344         allIARankDetails.push(IARankDetails(maxIACurr, maxRate, minIACurr, minRate));
3345         datewiseId[date] = allIARankDetails.length.sub(1);
3346     }
3347 
3348     /**
3349      * @dev to get the time for the laste liquidity trade trigger
3350      */
3351     function setLastLiquidityTradeTrigger() external onlyInternal {
3352         lastLiquidityTradeTrigger = now;
3353     }
3354 
3355     /** 
3356      * @dev Updates Last Date.
3357      */  
3358     function updatelastDate(uint64 newDate) external onlyInternal {
3359         lastDate = newDate;
3360     }
3361 
3362     /**
3363      * @dev Adds currency asset currency. 
3364      * @param curr currency of the asset
3365      * @param currAddress address of the currency
3366      * @param baseMin base minimum in 10^18. 
3367      */  
3368     function addCurrencyAssetCurrency(
3369         bytes4 curr,
3370         address currAddress,
3371         uint baseMin
3372     ) 
3373         external
3374     {
3375         require(ms.checkIsAuthToGoverned(msg.sender));
3376         allCurrencies.push(curr);
3377         allCurrencyAssets[curr] = CurrencyAssets(currAddress, baseMin, 0);
3378     }
3379     
3380     /**
3381      * @dev Adds investment asset. 
3382      */  
3383     function addInvestmentAssetCurrency(
3384         bytes4 curr,
3385         address currAddress,
3386         bool status,
3387         uint64 minHoldingPercX100,
3388         uint64 maxHoldingPercX100,
3389         uint8 decimals
3390     ) 
3391         external
3392     {
3393         require(ms.checkIsAuthToGoverned(msg.sender));
3394         allInvestmentCurrencies.push(curr);
3395         allInvestmentAssets[curr] = InvestmentAssets(currAddress, status,
3396             minHoldingPercX100, maxHoldingPercX100, decimals);
3397     }
3398 
3399     /**
3400      * @dev Changes base minimum of a given currency asset.
3401      */ 
3402     function changeCurrencyAssetBaseMin(bytes4 curr, uint baseMin) external {
3403         require(ms.checkIsAuthToGoverned(msg.sender));
3404         allCurrencyAssets[curr].baseMin = baseMin;
3405     }
3406 
3407     /**
3408      * @dev changes variable minimum of a given currency asset.
3409      */  
3410     function changeCurrencyAssetVarMin(bytes4 curr, uint varMin) external onlyInternal {
3411         allCurrencyAssets[curr].varMin = varMin;
3412     }
3413 
3414     /** 
3415      * @dev Changes the investment asset status.
3416      */ 
3417     function changeInvestmentAssetStatus(bytes4 curr, bool status) external {
3418         require(ms.checkIsAuthToGoverned(msg.sender));
3419         allInvestmentAssets[curr].status = status;
3420     }
3421 
3422     /** 
3423      * @dev Changes the investment asset Holding percentage of a given currency.
3424      */
3425     function changeInvestmentAssetHoldingPerc(
3426         bytes4 curr,
3427         uint64 minPercX100,
3428         uint64 maxPercX100
3429     )
3430         external
3431     {
3432         require(ms.checkIsAuthToGoverned(msg.sender));
3433         allInvestmentAssets[curr].minHoldingPercX100 = minPercX100;
3434         allInvestmentAssets[curr].maxHoldingPercX100 = maxPercX100;
3435     }
3436 
3437     /**
3438      * @dev Gets Currency asset token address. 
3439      */  
3440     function changeCurrencyAssetAddress(bytes4 curr, address currAdd) external {
3441         require(ms.checkIsAuthToGoverned(msg.sender));
3442         allCurrencyAssets[curr].currAddress = currAdd;
3443     }
3444 
3445     /**
3446      * @dev Changes Investment asset token address.
3447      */ 
3448     function changeInvestmentAssetAddressAndDecimal(
3449         bytes4 curr,
3450         address currAdd,
3451         uint8 newDecimal
3452     )
3453         external
3454     {
3455         require(ms.checkIsAuthToGoverned(msg.sender));
3456         allInvestmentAssets[curr].currAddress = currAdd;
3457         allInvestmentAssets[curr].decimals = newDecimal;
3458     }
3459 
3460     /// @dev Changes address allowed to post MCR.
3461     function changeNotariseAddress(address _add) external onlyInternal {
3462         notariseMCR = _add;
3463     }
3464 
3465     /// @dev updates daiFeedAddress address.
3466     /// @param _add address of DAI feed.
3467     function changeDAIfeedAddress(address _add) external onlyInternal {
3468         daiFeedAddress = _add;
3469     }
3470 
3471     /**
3472      * @dev Gets Uint Parameters of a code
3473      * @param code whose details we want
3474      * @return string value of the code
3475      * @return associated amount (time or perc or value) to the code
3476      */
3477     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
3478         codeVal = code;
3479         if (code == "MCRTIM") {
3480             val = mcrTime / (1 hours);
3481 
3482         } else if (code == "MCRFTIM") {
3483 
3484             val = mcrFailTime / (1 hours);
3485 
3486         } else if (code == "MCRMIN") {
3487 
3488             val = minCap;
3489 
3490         } else if (code == "MCRSHOCK") {
3491 
3492             val = shockParameter;
3493 
3494         } else if (code == "MCRCAPL") {
3495 
3496             val = capacityLimit;
3497 
3498         } else if (code == "IMZ") {
3499 
3500             val = variationPercX100;
3501 
3502         } else if (code == "IMRATET") {
3503 
3504             val = iaRatesTime / (1 hours);
3505 
3506         } else if (code == "IMUNIDL") {
3507 
3508             val = uniswapDeadline / (1 minutes);
3509 
3510         } else if (code == "IMLIQT") {
3511 
3512             val = liquidityTradeCallbackTime / (1 hours);
3513 
3514         } else if (code == "IMETHVL") {
3515 
3516             val = ethVolumeLimit;
3517 
3518         } else if (code == "C") {
3519             val = c;
3520 
3521         } else if (code == "A") {
3522 
3523             val = a;
3524 
3525         }
3526             
3527     }
3528  
3529     /// @dev Checks whether a given address can notaise MCR data or not.
3530     /// @param _add Address.
3531     /// @return res Returns 0 if address is not authorized, else 1.
3532     function isnotarise(address _add) external view returns(bool res) {
3533         res = false;
3534         if (_add == notariseMCR)
3535             res = true;
3536     }
3537 
3538     /// @dev Gets the details of last added MCR.
3539     /// @return mcrPercx100 Total Minimum Capital Requirement percentage of that month of year(multiplied by 100).
3540     /// @return vFull Total Pool fund value in Ether used in the last full daily calculation.
3541     function getLastMCR() external view returns(uint mcrPercx100, uint mcrEtherx1E18, uint vFull, uint64 date) {
3542         uint index = allMCRData.length.sub(1);
3543         return (
3544             allMCRData[index].mcrPercx100,
3545             allMCRData[index].mcrEther,
3546             allMCRData[index].vFull,
3547             allMCRData[index].date
3548         );
3549     }
3550 
3551     /// @dev Gets last Minimum Capital Requirement percentage of Capital Model
3552     /// @return val MCR% value,multiplied by 100.
3553     function getLastMCRPerc() external view returns(uint) {
3554         return allMCRData[allMCRData.length.sub(1)].mcrPercx100;
3555     }
3556 
3557     /// @dev Gets last Ether price of Capital Model
3558     /// @return val ether value,multiplied by 100.
3559     function getLastMCREther() external view returns(uint) {
3560         return allMCRData[allMCRData.length.sub(1)].mcrEther;
3561     }
3562 
3563     /// @dev Gets Pool fund value in Ether used in the last full daily calculation from the Capital model.
3564     function getLastVfull() external view returns(uint) {
3565         return allMCRData[allMCRData.length.sub(1)].vFull;
3566     }
3567 
3568     /// @dev Gets last Minimum Capital Requirement in Ether.
3569     /// @return date of MCR.
3570     function getLastMCRDate() external view returns(uint64 date) {
3571         date = allMCRData[allMCRData.length.sub(1)].date;
3572     }
3573 
3574     /// @dev Gets details for token price calculation.
3575     function getTokenPriceDetails(bytes4 curr) external view returns(uint _a, uint _c, uint rate) {
3576         _a = a;
3577         _c = c;
3578         rate = _getAvgRate(curr, false);
3579     }
3580     
3581     /// @dev Gets the total number of times MCR calculation has been made.
3582     function getMCRDataLength() external view returns(uint len) {
3583         len = allMCRData.length;
3584     }
3585  
3586     /**
3587      * @dev Gets investment asset rank details by given date.
3588      */  
3589     function getIARankDetailsByDate(
3590         uint64 date
3591     )
3592         external
3593         view
3594         returns(
3595             bytes4 maxIACurr,
3596             uint64 maxRate,
3597             bytes4 minIACurr,
3598             uint64 minRate
3599         )
3600     {
3601         uint index = datewiseId[date];
3602         return (
3603             allIARankDetails[index].maxIACurr,
3604             allIARankDetails[index].maxRate,
3605             allIARankDetails[index].minIACurr,
3606             allIARankDetails[index].minRate
3607         );
3608     }
3609 
3610     /** 
3611      * @dev Gets Last Date.
3612      */ 
3613     function getLastDate() external view returns(uint64 date) {
3614         return lastDate;
3615     }
3616 
3617     /**
3618      * @dev Gets investment currency for a given index.
3619      */  
3620     function getInvestmentCurrencyByIndex(uint index) external view returns(bytes4 currName) {
3621         return allInvestmentCurrencies[index];
3622     }
3623 
3624     /**
3625      * @dev Gets count of investment currency.
3626      */  
3627     function getInvestmentCurrencyLen() external view returns(uint len) {
3628         return allInvestmentCurrencies.length;
3629     }
3630 
3631     /**
3632      * @dev Gets all the investment currencies.
3633      */ 
3634     function getAllInvestmentCurrencies() external view returns(bytes4[] memory currencies) {
3635         return allInvestmentCurrencies;
3636     }
3637 
3638     /**
3639      * @dev Gets All currency for a given index.
3640      */  
3641     function getCurrenciesByIndex(uint index) external view returns(bytes4 currName) {
3642         return allCurrencies[index];
3643     }
3644 
3645     /** 
3646      * @dev Gets count of All currency.
3647      */  
3648     function getAllCurrenciesLen() external view returns(uint len) {
3649         return allCurrencies.length;
3650     }
3651 
3652     /**
3653      * @dev Gets all currencies 
3654      */  
3655     function getAllCurrencies() external view returns(bytes4[] memory currencies) {
3656         return allCurrencies;
3657     }
3658 
3659     /**
3660      * @dev Gets currency asset details for a given currency.
3661      */  
3662     function getCurrencyAssetVarBase(
3663         bytes4 curr
3664     )
3665         external
3666         view
3667         returns(
3668             bytes4 currency,
3669             uint baseMin,
3670             uint varMin
3671         )
3672     {
3673         return (
3674             curr,
3675             allCurrencyAssets[curr].baseMin,
3676             allCurrencyAssets[curr].varMin
3677         );
3678     }
3679 
3680     /**
3681      * @dev Gets minimum variable value for currency asset.
3682      */  
3683     function getCurrencyAssetVarMin(bytes4 curr) external view returns(uint varMin) {
3684         return allCurrencyAssets[curr].varMin;
3685     }
3686 
3687     /** 
3688      * @dev Gets base minimum of  a given currency asset.
3689      */  
3690     function getCurrencyAssetBaseMin(bytes4 curr) external view returns(uint baseMin) {
3691         return allCurrencyAssets[curr].baseMin;
3692     }
3693 
3694     /** 
3695      * @dev Gets investment asset maximum and minimum holding percentage of a given currency.
3696      */  
3697     function getInvestmentAssetHoldingPerc(
3698         bytes4 curr
3699     )
3700         external
3701         view
3702         returns(
3703             uint64 minHoldingPercX100,
3704             uint64 maxHoldingPercX100
3705         )
3706     {
3707         return (
3708             allInvestmentAssets[curr].minHoldingPercX100,
3709             allInvestmentAssets[curr].maxHoldingPercX100
3710         );
3711     }
3712 
3713     /** 
3714      * @dev Gets investment asset decimals.
3715      */  
3716     function getInvestmentAssetDecimals(bytes4 curr) external view returns(uint8 decimal) {
3717         return allInvestmentAssets[curr].decimals;
3718     }
3719 
3720     /**
3721      * @dev Gets investment asset maximum holding percentage of a given currency.
3722      */  
3723     function getInvestmentAssetMaxHoldingPerc(bytes4 curr) external view returns(uint64 maxHoldingPercX100) {
3724         return allInvestmentAssets[curr].maxHoldingPercX100;
3725     }
3726 
3727     /**
3728      * @dev Gets investment asset minimum holding percentage of a given currency.
3729      */  
3730     function getInvestmentAssetMinHoldingPerc(bytes4 curr) external view returns(uint64 minHoldingPercX100) {
3731         return allInvestmentAssets[curr].minHoldingPercX100;
3732     }
3733 
3734     /** 
3735      * @dev Gets investment asset details of a given currency
3736      */  
3737     function getInvestmentAssetDetails(
3738         bytes4 curr
3739     )
3740         external
3741         view
3742         returns(
3743             bytes4 currency,
3744             address currAddress,
3745             bool status,
3746             uint64 minHoldingPerc,
3747             uint64 maxHoldingPerc,
3748             uint8 decimals
3749         )
3750     {
3751         return (
3752             curr,
3753             allInvestmentAssets[curr].currAddress,
3754             allInvestmentAssets[curr].status,
3755             allInvestmentAssets[curr].minHoldingPercX100,
3756             allInvestmentAssets[curr].maxHoldingPercX100,
3757             allInvestmentAssets[curr].decimals
3758         );
3759     }
3760 
3761     /**
3762      * @dev Gets Currency asset token address.
3763      */  
3764     function getCurrencyAssetAddress(bytes4 curr) external view returns(address) {
3765         return allCurrencyAssets[curr].currAddress;
3766     }
3767 
3768     /**
3769      * @dev Gets investment asset token address.
3770      */  
3771     function getInvestmentAssetAddress(bytes4 curr) external view returns(address) {
3772         return allInvestmentAssets[curr].currAddress;
3773     }
3774 
3775     /**
3776      * @dev Gets investment asset active Status of a given currency.
3777      */  
3778     function getInvestmentAssetStatus(bytes4 curr) external view returns(bool status) {
3779         return allInvestmentAssets[curr].status;
3780     }
3781 
3782     /** 
3783      * @dev Gets type of oraclize query for a given Oraclize Query ID.
3784      * @param myid Oraclize Query ID identifying the query for which the result is being received.
3785      * @return _typeof It could be of type "quote","quotation","cover","claim" etc.
3786      */  
3787     function getApiIdTypeOf(bytes32 myid) external view returns(bytes4) {
3788         return allAPIid[myid].typeOf;
3789     }
3790 
3791     /** 
3792      * @dev Gets ID associated to oraclize query for a given Oraclize Query ID.
3793      * @param myid Oraclize Query ID identifying the query for which the result is being received.
3794      * @return id1 It could be the ID of "proposal","quotation","cover","claim" etc.
3795      */  
3796     function getIdOfApiId(bytes32 myid) external view returns(uint) {
3797         return allAPIid[myid].id;
3798     }
3799 
3800     /** 
3801      * @dev Gets the Timestamp of a oracalize call.
3802      */  
3803     function getDateAddOfAPI(bytes32 myid) external view returns(uint64) {
3804         return allAPIid[myid].dateAdd;
3805     }
3806 
3807     /**
3808      * @dev Gets the Timestamp at which result of oracalize call is received.
3809      */  
3810     function getDateUpdOfAPI(bytes32 myid) external view returns(uint64) {
3811         return allAPIid[myid].dateUpd;
3812     }
3813 
3814     /** 
3815      * @dev Gets currency by oracalize id. 
3816      */  
3817     function getCurrOfApiId(bytes32 myid) external view returns(bytes4) {
3818         return allAPIid[myid].currency;
3819     }
3820 
3821     /**
3822      * @dev Gets ID return by the oraclize query of a given index.
3823      * @param index Index.
3824      * @return myid ID return by the oraclize query.
3825      */  
3826     function getApiCallIndex(uint index) external view returns(bytes32 myid) {
3827         myid = allAPIcall[index];
3828     }
3829 
3830     /**
3831      * @dev Gets Length of API call. 
3832      */  
3833     function getApilCallLength() external view returns(uint) {
3834         return allAPIcall.length;
3835     }
3836     
3837     /**
3838      * @dev Get Details of Oraclize API when given Oraclize Id.
3839      * @param myid ID return by the oraclize query.
3840      * @return _typeof ype of the query for which oraclize 
3841      * call is made.("proposal","quote","quotation" etc.) 
3842      */  
3843     function getApiCallDetails(
3844         bytes32 myid
3845     )
3846         external
3847         view
3848         returns(
3849             bytes4 _typeof,
3850             bytes4 curr,
3851             uint id,
3852             uint64 dateAdd,
3853             uint64 dateUpd
3854         )
3855     {
3856         return (
3857             allAPIid[myid].typeOf,
3858             allAPIid[myid].currency,
3859             allAPIid[myid].id,
3860             allAPIid[myid].dateAdd,
3861             allAPIid[myid].dateUpd
3862         );
3863     }
3864 
3865     /**
3866      * @dev Updates Uint Parameters of a code
3867      * @param code whose details we want to update
3868      * @param val value to set
3869      */
3870     function updateUintParameters(bytes8 code, uint val) public {
3871         require(ms.checkIsAuthToGoverned(msg.sender));
3872         if (code == "MCRTIM") {
3873             _changeMCRTime(val * 1 hours);
3874 
3875         } else if (code == "MCRFTIM") {
3876 
3877             _changeMCRFailTime(val * 1 hours);
3878 
3879         } else if (code == "MCRMIN") {
3880 
3881             _changeMinCap(val);
3882 
3883         } else if (code == "MCRSHOCK") {
3884 
3885             _changeShockParameter(val);
3886 
3887         } else if (code == "MCRCAPL") {
3888 
3889             _changeCapacityLimit(val);
3890 
3891         } else if (code == "IMZ") {
3892 
3893             _changeVariationPercX100(val);
3894 
3895         } else if (code == "IMRATET") {
3896 
3897             _changeIARatesTime(val * 1 hours);
3898 
3899         } else if (code == "IMUNIDL") {
3900 
3901             _changeUniswapDeadlineTime(val * 1 minutes);
3902 
3903         } else if (code == "IMLIQT") {
3904 
3905             _changeliquidityTradeCallbackTime(val * 1 hours);
3906 
3907         } else if (code == "IMETHVL") {
3908 
3909             _setEthVolumeLimit(val);
3910 
3911         } else if (code == "C") {
3912             _changeC(val);
3913 
3914         } else if (code == "A") {
3915 
3916             _changeA(val);
3917 
3918         } else {
3919             revert("Invalid param code");
3920         }
3921             
3922     }
3923 
3924     /**
3925      * @dev to get the average rate of currency rate 
3926      * @param curr is the currency in concern
3927      * @return required rate
3928      */
3929     function getCAAvgRate(bytes4 curr) public view returns(uint rate) {
3930         return _getAvgRate(curr, false);
3931     }
3932 
3933     /**
3934      * @dev to get the average rate of investment rate 
3935      * @param curr is the investment in concern
3936      * @return required rate
3937      */
3938     function getIAAvgRate(bytes4 curr) public view returns(uint rate) {
3939         return _getAvgRate(curr, true);
3940     }
3941 
3942     function changeDependentContractAddress() public onlyInternal {}
3943 
3944     /// @dev Gets the average rate of a CA currency.
3945     /// @param curr Currency Name.
3946     /// @return rate Average rate X 100(of last 3 days).
3947     function _getAvgRate(bytes4 curr, bool isIA) internal view returns(uint rate) {
3948         if (curr == "DAI") {
3949             DSValue ds = DSValue(daiFeedAddress);
3950             rate = uint(ds.read()).div(uint(10) ** 16);
3951         } else if (isIA) {
3952             rate = iaAvgRate[curr];
3953         } else {
3954             rate = caAvgRate[curr];
3955         }
3956     }
3957 
3958     /**
3959      * @dev to set the ethereum volume limit 
3960      * @param val is the new limit value
3961      */
3962     function _setEthVolumeLimit(uint val) internal {
3963         ethVolumeLimit = val;
3964     }
3965 
3966     /// @dev Sets minimum Cap.
3967     function _changeMinCap(uint newCap) internal {
3968         minCap = newCap;
3969     }
3970 
3971     /// @dev Sets Shock Parameter.
3972     function _changeShockParameter(uint newParam) internal {
3973         shockParameter = newParam;
3974     }
3975     
3976     /// @dev Changes time period for obtaining new MCR data from external oracle query.
3977     function _changeMCRTime(uint _time) internal {
3978         mcrTime = _time;
3979     }
3980 
3981     /// @dev Sets MCR Fail time.
3982     function _changeMCRFailTime(uint _time) internal {
3983         mcrFailTime = _time;
3984     }
3985 
3986     /**
3987      * @dev to change the uniswap deadline time 
3988      * @param newDeadline is the value
3989      */
3990     function _changeUniswapDeadlineTime(uint newDeadline) internal {
3991         uniswapDeadline = newDeadline;
3992     }
3993 
3994     /**
3995      * @dev to change the liquidity trade call back time 
3996      * @param newTime is the new value to be set
3997      */
3998     function _changeliquidityTradeCallbackTime(uint newTime) internal {
3999         liquidityTradeCallbackTime = newTime;
4000     }
4001 
4002     /**
4003      * @dev Changes time after which investment asset rates need to be fed.
4004      */  
4005     function _changeIARatesTime(uint _newTime) internal {
4006         iaRatesTime = _newTime;
4007     }
4008     
4009     /**
4010      * @dev Changes the variation range percentage.
4011      */  
4012     function _changeVariationPercX100(uint newPercX100) internal {
4013         variationPercX100 = newPercX100;
4014     }
4015 
4016     /// @dev Changes Growth Step
4017     function _changeC(uint newC) internal {
4018         c = newC;
4019     }
4020 
4021     /// @dev Changes scaling factor.
4022     function _changeA(uint val) internal {
4023         a = val;
4024     }
4025     
4026     /**
4027      * @dev to change the capacity limit 
4028      * @param val is the new value
4029      */
4030     function _changeCapacityLimit(uint val) internal {
4031         capacityLimit = val;
4032     }    
4033 }
4034 
4035 /* Copyright (C) 2017 NexusMutual.io
4036 
4037   This program is free software: you can redistribute it and/or modify
4038     it under the terms of the GNU General Public License as published by
4039     the Free Software Foundation, either version 3 of the License, or
4040     (at your option) any later version.
4041 
4042   This program is distributed in the hope that it will be useful,
4043     but WITHOUT ANY WARRANTY; without even the implied warranty of
4044     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
4045     GNU General Public License for more details.
4046 
4047   You should have received a copy of the GNU General Public License
4048     along with this program.  If not, see http://www.gnu.org/licenses/ */
4049 contract TokenData is Iupgradable {
4050     using SafeMath for uint;
4051 
4052     address payable public walletAddress;
4053     uint public lockTokenTimeAfterCoverExp;
4054     uint public bookTime;
4055     uint public lockCADays;
4056     uint public lockMVDays;
4057     uint public scValidDays;
4058     uint public joiningFee;
4059     uint public stakerCommissionPer;
4060     uint public stakerMaxCommissionPer;
4061     uint public tokenExponent;
4062     uint public priceStep;
4063 
4064     struct StakeCommission {
4065         uint commissionEarned;
4066         uint commissionRedeemed;
4067     }
4068 
4069     struct Stake {
4070         address stakedContractAddress;
4071         uint stakedContractIndex;
4072         uint dateAdd;
4073         uint stakeAmount;
4074         uint unlockedAmount;
4075         uint burnedAmount;
4076         uint unLockableBeforeLastBurn;
4077     }
4078 
4079     struct Staker {
4080         address stakerAddress;
4081         uint stakerIndex;
4082     }
4083 
4084     struct CoverNote {
4085         uint amount;
4086         bool isDeposited;
4087     }
4088 
4089     /**
4090      * @dev mapping of uw address to array of sc address to fetch 
4091      * all staked contract address of underwriter, pushing
4092      * data into this array of Stake returns stakerIndex 
4093      */ 
4094     mapping(address => Stake[]) public stakerStakedContracts; 
4095 
4096     /** 
4097      * @dev mapping of sc address to array of UW address to fetch
4098      * all underwritters of the staked smart contract
4099      * pushing data into this mapped array returns scIndex 
4100      */
4101     mapping(address => Staker[]) public stakedContractStakers;
4102 
4103     /**
4104      * @dev mapping of staked contract Address to the array of StakeCommission
4105      * here index of this array is stakedContractIndex
4106      */ 
4107     mapping(address => mapping(uint => StakeCommission)) public stakedContractStakeCommission;
4108 
4109     mapping(address => uint) public lastCompletedStakeCommission;
4110 
4111     /** 
4112      * @dev mapping of the staked contract address to the current 
4113      * staker index who will receive commission.
4114      */ 
4115     mapping(address => uint) public stakedContractCurrentCommissionIndex;
4116 
4117     /** 
4118      * @dev mapping of the staked contract address to the 
4119      * current staker index to burn token from.
4120      */ 
4121     mapping(address => uint) public stakedContractCurrentBurnIndex;
4122 
4123     /** 
4124      * @dev mapping to return true if Cover Note deposited against coverId
4125      */ 
4126     mapping(uint => CoverNote) public depositedCN;
4127 
4128     mapping(address => uint) internal isBookedTokens;
4129 
4130     event Commission(
4131         address indexed stakedContractAddress,
4132         address indexed stakerAddress,
4133         uint indexed scIndex,
4134         uint commissionAmount
4135     );
4136 
4137     constructor(address payable _walletAdd) public {
4138         walletAddress = _walletAdd;
4139         bookTime = 12 hours;
4140         joiningFee = 2000000000000000; // 0.002 Ether
4141         lockTokenTimeAfterCoverExp = 35 days;
4142         scValidDays = 250;
4143         lockCADays = 7 days;
4144         lockMVDays = 2 days;
4145         stakerCommissionPer = 20;
4146         stakerMaxCommissionPer = 50;
4147         tokenExponent = 4;
4148         priceStep = 1000;
4149 
4150     }
4151 
4152     /**
4153      * @dev Change the wallet address which receive Joining Fee
4154      */
4155     function changeWalletAddress(address payable _address) external onlyInternal {
4156         walletAddress = _address;
4157     }
4158 
4159     /**
4160      * @dev Gets Uint Parameters of a code
4161      * @param code whose details we want
4162      * @return string value of the code
4163      * @return associated amount (time or perc or value) to the code
4164      */
4165     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
4166         codeVal = code;
4167         if (code == "TOKEXP") {
4168 
4169             val = tokenExponent; 
4170 
4171         } else if (code == "TOKSTEP") {
4172 
4173             val = priceStep;
4174 
4175         } else if (code == "RALOCKT") {
4176 
4177             val = scValidDays;
4178 
4179         } else if (code == "RACOMM") {
4180 
4181             val = stakerCommissionPer;
4182 
4183         } else if (code == "RAMAXC") {
4184 
4185             val = stakerMaxCommissionPer;
4186 
4187         } else if (code == "CABOOKT") {
4188 
4189             val = bookTime / (1 hours);
4190 
4191         } else if (code == "CALOCKT") {
4192 
4193             val = lockCADays / (1 days);
4194 
4195         } else if (code == "MVLOCKT") {
4196 
4197             val = lockMVDays / (1 days);
4198 
4199         } else if (code == "QUOLOCKT") {
4200 
4201             val = lockTokenTimeAfterCoverExp / (1 days);
4202 
4203         } else if (code == "JOINFEE") {
4204 
4205             val = joiningFee;
4206 
4207         } 
4208     }
4209 
4210     /**
4211     * @dev Just for interface
4212     */
4213     function changeDependentContractAddress() public { //solhint-disable-line
4214     }
4215     
4216     /**
4217      * @dev to get the contract staked by a staker 
4218      * @param _stakerAddress is the address of the staker
4219      * @param _stakerIndex is the index of staker
4220      * @return the address of staked contract
4221      */
4222     function getStakerStakedContractByIndex(
4223         address _stakerAddress,
4224         uint _stakerIndex
4225     ) 
4226         public
4227         view
4228         returns (address stakedContractAddress) 
4229     {
4230         stakedContractAddress = stakerStakedContracts[
4231             _stakerAddress][_stakerIndex].stakedContractAddress;
4232     }
4233 
4234     /**
4235      * @dev to get the staker's staked burned 
4236      * @param _stakerAddress is the address of the staker
4237      * @param _stakerIndex is the index of staker
4238      * @return amount burned
4239      */
4240     function getStakerStakedBurnedByIndex(
4241         address _stakerAddress,
4242         uint _stakerIndex
4243     ) 
4244         public
4245         view
4246         returns (uint burnedAmount) 
4247     {
4248         burnedAmount = stakerStakedContracts[
4249             _stakerAddress][_stakerIndex].burnedAmount;
4250     }
4251 
4252     /**
4253      * @dev to get the staker's staked unlockable before the last burn 
4254      * @param _stakerAddress is the address of the staker
4255      * @param _stakerIndex is the index of staker
4256      * @return unlockable staked tokens
4257      */
4258     function getStakerStakedUnlockableBeforeLastBurnByIndex(
4259         address _stakerAddress,
4260         uint _stakerIndex
4261     ) 
4262         public
4263         view
4264         returns (uint unlockable) 
4265     {
4266         unlockable = stakerStakedContracts[
4267             _stakerAddress][_stakerIndex].unLockableBeforeLastBurn;
4268     }
4269 
4270     /**
4271      * @dev to get the staker's staked contract index 
4272      * @param _stakerAddress is the address of the staker
4273      * @param _stakerIndex is the index of staker
4274      * @return is the index of the smart contract address
4275      */
4276     function getStakerStakedContractIndex(
4277         address _stakerAddress,
4278         uint _stakerIndex
4279     ) 
4280         public
4281         view
4282         returns (uint scIndex) 
4283     {
4284         scIndex = stakerStakedContracts[
4285             _stakerAddress][_stakerIndex].stakedContractIndex;
4286     }
4287 
4288     /**
4289      * @dev to get the staker index of the staked contract
4290      * @param _stakedContractAddress is the address of the staked contract
4291      * @param _stakedContractIndex is the index of staked contract
4292      * @return is the index of the staker
4293      */
4294     function getStakedContractStakerIndex(
4295         address _stakedContractAddress,
4296         uint _stakedContractIndex
4297     ) 
4298         public
4299         view
4300         returns (uint sIndex) 
4301     {
4302         sIndex = stakedContractStakers[
4303             _stakedContractAddress][_stakedContractIndex].stakerIndex;
4304     }
4305 
4306     /**
4307      * @dev to get the staker's initial staked amount on the contract 
4308      * @param _stakerAddress is the address of the staker
4309      * @param _stakerIndex is the index of staker
4310      * @return staked amount
4311      */
4312     function getStakerInitialStakedAmountOnContract(
4313         address _stakerAddress,
4314         uint _stakerIndex
4315     )
4316         public 
4317         view
4318         returns (uint amount)
4319     {
4320         amount = stakerStakedContracts[
4321             _stakerAddress][_stakerIndex].stakeAmount;
4322     }
4323 
4324     /**
4325      * @dev to get the staker's staked contract length 
4326      * @param _stakerAddress is the address of the staker
4327      * @return length of staked contract
4328      */
4329     function getStakerStakedContractLength(
4330         address _stakerAddress
4331     ) 
4332         public
4333         view
4334         returns (uint length)
4335     {
4336         length = stakerStakedContracts[_stakerAddress].length;
4337     }
4338 
4339     /**
4340      * @dev to get the staker's unlocked tokens which were staked 
4341      * @param _stakerAddress is the address of the staker
4342      * @param _stakerIndex is the index of staker
4343      * @return amount
4344      */
4345     function getStakerUnlockedStakedTokens(
4346         address _stakerAddress,
4347         uint _stakerIndex
4348     )
4349         public 
4350         view
4351         returns (uint amount)
4352     {
4353         amount = stakerStakedContracts[
4354             _stakerAddress][_stakerIndex].unlockedAmount;
4355     }
4356 
4357     /**
4358      * @dev pushes the unlocked staked tokens by a staker.
4359      * @param _stakerAddress address of staker.
4360      * @param _stakerIndex index of the staker to distribute commission.
4361      * @param _amount amount to be given as commission.
4362      */ 
4363     function pushUnlockedStakedTokens(
4364         address _stakerAddress,
4365         uint _stakerIndex,
4366         uint _amount
4367     )   
4368         public
4369         onlyInternal
4370     {   
4371         stakerStakedContracts[_stakerAddress][
4372             _stakerIndex].unlockedAmount = stakerStakedContracts[_stakerAddress][
4373                 _stakerIndex].unlockedAmount.add(_amount);
4374     }
4375 
4376     /**
4377      * @dev pushes the Burned tokens for a staker.
4378      * @param _stakerAddress address of staker.
4379      * @param _stakerIndex index of the staker.
4380      * @param _amount amount to be burned.
4381      */ 
4382     function pushBurnedTokens(
4383         address _stakerAddress,
4384         uint _stakerIndex,
4385         uint _amount
4386     )   
4387         public
4388         onlyInternal
4389     {   
4390         stakerStakedContracts[_stakerAddress][
4391             _stakerIndex].burnedAmount = stakerStakedContracts[_stakerAddress][
4392                 _stakerIndex].burnedAmount.add(_amount);
4393     }
4394 
4395     /**
4396      * @dev pushes the unLockable tokens for a staker before last burn.
4397      * @param _stakerAddress address of staker.
4398      * @param _stakerIndex index of the staker.
4399      * @param _amount amount to be added to unlockable.
4400      */ 
4401     function pushUnlockableBeforeLastBurnTokens(
4402         address _stakerAddress,
4403         uint _stakerIndex,
4404         uint _amount
4405     )   
4406         public
4407         onlyInternal
4408     {   
4409         stakerStakedContracts[_stakerAddress][
4410             _stakerIndex].unLockableBeforeLastBurn = stakerStakedContracts[_stakerAddress][
4411                 _stakerIndex].unLockableBeforeLastBurn.add(_amount);
4412     }
4413 
4414     /**
4415      * @dev sets the unLockable tokens for a staker before last burn.
4416      * @param _stakerAddress address of staker.
4417      * @param _stakerIndex index of the staker.
4418      * @param _amount amount to be added to unlockable.
4419      */ 
4420     function setUnlockableBeforeLastBurnTokens(
4421         address _stakerAddress,
4422         uint _stakerIndex,
4423         uint _amount
4424     )   
4425         public
4426         onlyInternal
4427     {   
4428         stakerStakedContracts[_stakerAddress][
4429             _stakerIndex].unLockableBeforeLastBurn = _amount;
4430     }
4431 
4432     /**
4433      * @dev pushes the earned commission earned by a staker.
4434      * @param _stakerAddress address of staker.
4435      * @param _stakedContractAddress address of smart contract.
4436      * @param _stakedContractIndex index of the staker to distribute commission.
4437      * @param _commissionAmount amount to be given as commission.
4438      */ 
4439     function pushEarnedStakeCommissions(
4440         address _stakerAddress,
4441         address _stakedContractAddress,
4442         uint _stakedContractIndex,
4443         uint _commissionAmount
4444     )   
4445         public
4446         onlyInternal
4447     {
4448         stakedContractStakeCommission[_stakedContractAddress][_stakedContractIndex].
4449             commissionEarned = stakedContractStakeCommission[_stakedContractAddress][
4450                 _stakedContractIndex].commissionEarned.add(_commissionAmount);
4451                 
4452         emit Commission(
4453             _stakerAddress,
4454             _stakedContractAddress,
4455             _stakedContractIndex,
4456             _commissionAmount
4457         );
4458     }
4459 
4460     /**
4461      * @dev pushes the redeemed commission redeemed by a staker.
4462      * @param _stakerAddress address of staker.
4463      * @param _stakerIndex index of the staker to distribute commission.
4464      * @param _amount amount to be given as commission.
4465      */ 
4466     function pushRedeemedStakeCommissions(
4467         address _stakerAddress,
4468         uint _stakerIndex,
4469         uint _amount
4470     )   
4471         public
4472         onlyInternal
4473     {   
4474         uint stakedContractIndex = stakerStakedContracts[
4475             _stakerAddress][_stakerIndex].stakedContractIndex;
4476         address stakedContractAddress = stakerStakedContracts[
4477             _stakerAddress][_stakerIndex].stakedContractAddress;
4478         stakedContractStakeCommission[stakedContractAddress][stakedContractIndex].
4479             commissionRedeemed = stakedContractStakeCommission[
4480                 stakedContractAddress][stakedContractIndex].commissionRedeemed.add(_amount);
4481     }
4482 
4483     /**
4484      * @dev Gets stake commission given to an underwriter
4485      * for particular stakedcontract on given index.
4486      * @param _stakerAddress address of staker.
4487      * @param _stakerIndex index of the staker commission.
4488      */ 
4489     function getStakerEarnedStakeCommission(
4490         address _stakerAddress,
4491         uint _stakerIndex
4492     )
4493         public 
4494         view
4495         returns (uint) 
4496     {
4497         return _getStakerEarnedStakeCommission(_stakerAddress, _stakerIndex);
4498     }
4499 
4500     /**
4501      * @dev Gets stake commission redeemed by an underwriter
4502      * for particular staked contract on given index.
4503      * @param _stakerAddress address of staker.
4504      * @param _stakerIndex index of the staker commission.
4505      * @return commissionEarned total amount given to staker.
4506      */ 
4507     function getStakerRedeemedStakeCommission(
4508         address _stakerAddress,
4509         uint _stakerIndex
4510     )
4511         public 
4512         view
4513         returns (uint) 
4514     {
4515         return _getStakerRedeemedStakeCommission(_stakerAddress, _stakerIndex);
4516     }
4517 
4518     /**
4519      * @dev Gets total stake commission given to an underwriter
4520      * @param _stakerAddress address of staker.
4521      * @return totalCommissionEarned total commission earned by staker.
4522      */ 
4523     function getStakerTotalEarnedStakeCommission(
4524         address _stakerAddress
4525     )
4526         public 
4527         view
4528         returns (uint totalCommissionEarned) 
4529     {
4530         totalCommissionEarned = 0;
4531         for (uint i = 0; i < stakerStakedContracts[_stakerAddress].length; i++) {
4532             totalCommissionEarned = totalCommissionEarned.
4533                 add(_getStakerEarnedStakeCommission(_stakerAddress, i));
4534         }
4535     }
4536 
4537     /**
4538      * @dev Gets total stake commission given to an underwriter
4539      * @param _stakerAddress address of staker.
4540      * @return totalCommissionEarned total commission earned by staker.
4541      */ 
4542     function getStakerTotalReedmedStakeCommission(
4543         address _stakerAddress
4544     )
4545         public 
4546         view
4547         returns(uint totalCommissionRedeemed) 
4548     {
4549         totalCommissionRedeemed = 0;
4550         for (uint i = 0; i < stakerStakedContracts[_stakerAddress].length; i++) {
4551             totalCommissionRedeemed = totalCommissionRedeemed.add(
4552                 _getStakerRedeemedStakeCommission(_stakerAddress, i));
4553         }
4554     }
4555 
4556     /**
4557      * @dev set flag to deposit/ undeposit cover note 
4558      * against a cover Id
4559      * @param coverId coverId of Cover
4560      * @param flag true/false for deposit/undeposit
4561      */
4562     function setDepositCN(uint coverId, bool flag) public onlyInternal {
4563 
4564         if (flag == true) {
4565             require(!depositedCN[coverId].isDeposited, "Cover note already deposited");    
4566         }
4567 
4568         depositedCN[coverId].isDeposited = flag;
4569     }
4570 
4571     /**
4572      * @dev set locked cover note amount
4573      * against a cover Id
4574      * @param coverId coverId of Cover
4575      * @param amount amount of nxm to be locked
4576      */
4577     function setDepositCNAmount(uint coverId, uint amount) public onlyInternal {
4578 
4579         depositedCN[coverId].amount = amount;
4580     }
4581 
4582     /**
4583      * @dev to get the staker address on a staked contract 
4584      * @param _stakedContractAddress is the address of the staked contract in concern
4585      * @param _stakedContractIndex is the index of staked contract's index
4586      * @return address of staker
4587      */
4588     function getStakedContractStakerByIndex(
4589         address _stakedContractAddress,
4590         uint _stakedContractIndex
4591     )
4592         public
4593         view
4594         returns (address stakerAddress)
4595     {
4596         stakerAddress = stakedContractStakers[
4597             _stakedContractAddress][_stakedContractIndex].stakerAddress;
4598     }
4599 
4600     /**
4601      * @dev to get the length of stakers on a staked contract 
4602      * @param _stakedContractAddress is the address of the staked contract in concern
4603      * @return length in concern
4604      */
4605     function getStakedContractStakersLength(
4606         address _stakedContractAddress
4607     ) 
4608         public
4609         view
4610         returns (uint length)
4611     {
4612         length = stakedContractStakers[_stakedContractAddress].length;
4613     } 
4614     
4615     /**
4616      * @dev Adds a new stake record.
4617      * @param _stakerAddress staker address.
4618      * @param _stakedContractAddress smart contract address.
4619      * @param _amount amountof NXM to be staked.
4620      */
4621     function addStake(
4622         address _stakerAddress,
4623         address _stakedContractAddress,
4624         uint _amount
4625     ) 
4626         public
4627         onlyInternal
4628         returns(uint scIndex) 
4629     {
4630         scIndex = (stakedContractStakers[_stakedContractAddress].push(
4631             Staker(_stakerAddress, stakerStakedContracts[_stakerAddress].length))).sub(1);
4632         stakerStakedContracts[_stakerAddress].push(
4633             Stake(_stakedContractAddress, scIndex, now, _amount, 0, 0, 0));
4634     }
4635 
4636     /**
4637      * @dev books the user's tokens for maintaining Assessor Velocity, 
4638      * i.e. once a token is used to cast a vote as a Claims assessor,
4639      * @param _of user's address.
4640      */
4641     function bookCATokens(address _of) public onlyInternal {
4642         require(!isCATokensBooked(_of), "Tokens already booked");
4643         isBookedTokens[_of] = now.add(bookTime);
4644     }
4645 
4646     /**
4647      * @dev to know if claim assessor's tokens are booked or not 
4648      * @param _of is the claim assessor's address in concern
4649      * @return boolean representing the status of tokens booked
4650      */
4651     function isCATokensBooked(address _of) public view returns(bool res) {
4652         if (now < isBookedTokens[_of])
4653             res = true;
4654     }
4655 
4656     /**
4657      * @dev Sets the index which will receive commission.
4658      * @param _stakedContractAddress smart contract address.
4659      * @param _index current index.
4660      */
4661     function setStakedContractCurrentCommissionIndex(
4662         address _stakedContractAddress,
4663         uint _index
4664     )
4665         public
4666         onlyInternal
4667     {
4668         stakedContractCurrentCommissionIndex[_stakedContractAddress] = _index;
4669     }
4670 
4671     /**
4672      * @dev Sets the last complete commission index
4673      * @param _stakerAddress smart contract address.
4674      * @param _index current index.
4675      */
4676     function setLastCompletedStakeCommissionIndex(
4677         address _stakerAddress,
4678         uint _index
4679     )
4680         public
4681         onlyInternal
4682     {
4683         lastCompletedStakeCommission[_stakerAddress] = _index;
4684     }
4685 
4686     /**
4687      * @dev Sets the index till which commission is distrubuted.
4688      * @param _stakedContractAddress smart contract address.
4689      * @param _index current index.
4690      */
4691     function setStakedContractCurrentBurnIndex(
4692         address _stakedContractAddress,
4693         uint _index
4694     )
4695         public
4696         onlyInternal
4697     {
4698         stakedContractCurrentBurnIndex[_stakedContractAddress] = _index;
4699     }
4700 
4701     /**
4702      * @dev Updates Uint Parameters of a code
4703      * @param code whose details we want to update
4704      * @param val value to set
4705      */
4706     function updateUintParameters(bytes8 code, uint val) public {
4707         require(ms.checkIsAuthToGoverned(msg.sender));
4708         if (code == "TOKEXP") {
4709 
4710             _setTokenExponent(val); 
4711 
4712         } else if (code == "TOKSTEP") {
4713 
4714             _setPriceStep(val);
4715 
4716         } else if (code == "RALOCKT") {
4717 
4718             _changeSCValidDays(val);
4719 
4720         } else if (code == "RACOMM") {
4721 
4722             _setStakerCommissionPer(val);
4723 
4724         } else if (code == "RAMAXC") {
4725 
4726             _setStakerMaxCommissionPer(val);
4727 
4728         } else if (code == "CABOOKT") {
4729 
4730             _changeBookTime(val * 1 hours);
4731 
4732         } else if (code == "CALOCKT") {
4733 
4734             _changelockCADays(val * 1 days);
4735 
4736         } else if (code == "MVLOCKT") {
4737 
4738             _changelockMVDays(val * 1 days);
4739 
4740         } else if (code == "QUOLOCKT") {
4741 
4742             _setLockTokenTimeAfterCoverExp(val * 1 days);
4743 
4744         } else if (code == "JOINFEE") {
4745 
4746             _setJoiningFee(val);
4747 
4748         } else {
4749             revert("Invalid param code");
4750         } 
4751     }
4752 
4753     /**
4754      * @dev Internal function to get stake commission given to an 
4755      * underwriter for particular stakedcontract on given index.
4756      * @param _stakerAddress address of staker.
4757      * @param _stakerIndex index of the staker commission.
4758      */ 
4759     function _getStakerEarnedStakeCommission(
4760         address _stakerAddress,
4761         uint _stakerIndex
4762     )
4763         internal
4764         view 
4765         returns (uint amount) 
4766     {
4767         uint _stakedContractIndex;
4768         address _stakedContractAddress;
4769         _stakedContractAddress = stakerStakedContracts[
4770             _stakerAddress][_stakerIndex].stakedContractAddress;
4771         _stakedContractIndex = stakerStakedContracts[
4772             _stakerAddress][_stakerIndex].stakedContractIndex;
4773         amount = stakedContractStakeCommission[
4774             _stakedContractAddress][_stakedContractIndex].commissionEarned;
4775     }
4776 
4777     /**
4778      * @dev Internal function to get stake commission redeemed by an 
4779      * underwriter for particular stakedcontract on given index.
4780      * @param _stakerAddress address of staker.
4781      * @param _stakerIndex index of the staker commission.
4782      */ 
4783     function _getStakerRedeemedStakeCommission(
4784         address _stakerAddress,
4785         uint _stakerIndex
4786     )
4787         internal
4788         view 
4789         returns (uint amount) 
4790     {
4791         uint _stakedContractIndex;
4792         address _stakedContractAddress;
4793         _stakedContractAddress = stakerStakedContracts[
4794             _stakerAddress][_stakerIndex].stakedContractAddress;
4795         _stakedContractIndex = stakerStakedContracts[
4796             _stakerAddress][_stakerIndex].stakedContractIndex;
4797         amount = stakedContractStakeCommission[
4798             _stakedContractAddress][_stakedContractIndex].commissionRedeemed;
4799     }
4800 
4801     /**
4802      * @dev to set the percentage of staker commission 
4803      * @param _val is new percentage value
4804      */
4805     function _setStakerCommissionPer(uint _val) internal {
4806         stakerCommissionPer = _val;
4807     }
4808 
4809     /**
4810      * @dev to set the max percentage of staker commission 
4811      * @param _val is new percentage value
4812      */
4813     function _setStakerMaxCommissionPer(uint _val) internal {
4814         stakerMaxCommissionPer = _val;
4815     }
4816 
4817     /**
4818      * @dev to set the token exponent value 
4819      * @param _val is new value
4820      */
4821     function _setTokenExponent(uint _val) internal {
4822         tokenExponent = _val;
4823     }
4824 
4825     /**
4826      * @dev to set the price step 
4827      * @param _val is new value
4828      */
4829     function _setPriceStep(uint _val) internal {
4830         priceStep = _val;
4831     }
4832 
4833     /**
4834      * @dev Changes number of days for which NXM needs to staked in case of underwriting
4835      */ 
4836     function _changeSCValidDays(uint _days) internal {
4837         scValidDays = _days;
4838     }
4839 
4840     /**
4841      * @dev Changes the time period up to which tokens will be locked.
4842      *      Used to generate the validity period of tokens booked by
4843      *      a user for participating in claim's assessment/claim's voting.
4844      */ 
4845     function _changeBookTime(uint _time) internal {
4846         bookTime = _time;
4847     }
4848 
4849     /**
4850      * @dev Changes lock CA days - number of days for which tokens 
4851      * are locked while submitting a vote.
4852      */ 
4853     function _changelockCADays(uint _val) internal {
4854         lockCADays = _val;
4855     }
4856     
4857     /**
4858      * @dev Changes lock MV days - number of days for which tokens are locked
4859      * while submitting a vote.
4860      */ 
4861     function _changelockMVDays(uint _val) internal {
4862         lockMVDays = _val;
4863     }
4864 
4865     /**
4866      * @dev Changes extra lock period for a cover, post its expiry.
4867      */ 
4868     function _setLockTokenTimeAfterCoverExp(uint time) internal {
4869         lockTokenTimeAfterCoverExp = time;
4870     }
4871 
4872     /**
4873      * @dev Set the joining fee for membership
4874      */
4875     function _setJoiningFee(uint _amount) internal {
4876         joiningFee = _amount;
4877     }
4878 }
4879 
4880 /*
4881 
4882 ORACLIZE_API
4883 
4884 Copyright (c) 2015-2016 Oraclize SRL
4885 Copyright (c) 2016 Oraclize LTD
4886 
4887 Permission is hereby granted, free of charge, to any person obtaining a copy
4888 of this software and associated documentation files (the "Software"), to deal
4889 in the Software without restriction, including without limitation the rights
4890 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
4891 copies of the Software, and to permit persons to whom the Software is
4892 furnished to do so, subject to the following conditions:
4893 
4894 The above copyright notice and this permission notice shall be included in
4895 all copies or substantial portions of the Software.
4896 
4897 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
4898 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
4899 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
4900 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
4901 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
4902 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
4903 THE SOFTWARE.
4904 
4905 */
4906 // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
4907 // Dummy contract only used to emit to end-user they are using wrong solc
4908 contract solcChecker {
4909 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
4910 }
4911 
4912 contract OraclizeI {
4913 
4914     address public cbAddress;
4915 
4916     function setProofType(byte _proofType) external;
4917     function setCustomGasPrice(uint _gasPrice) external;
4918     function getPrice(string memory _datasource) public returns (uint _dsprice);
4919     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
4920     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
4921     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
4922     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
4923     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
4924     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
4925     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
4926     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
4927 }
4928 
4929 contract OraclizeAddrResolverI {
4930     function getAddress() public returns (address _address);
4931 }
4932 
4933 /*
4934 
4935 Begin solidity-cborutils
4936 
4937 https://github.com/smartcontractkit/solidity-cborutils
4938 
4939 MIT License
4940 
4941 Copyright (c) 2018 SmartContract ChainLink, Ltd.
4942 
4943 Permission is hereby granted, free of charge, to any person obtaining a copy
4944 of this software and associated documentation files (the "Software"), to deal
4945 in the Software without restriction, including without limitation the rights
4946 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
4947 copies of the Software, and to permit persons to whom the Software is
4948 furnished to do so, subject to the following conditions:
4949 
4950 The above copyright notice and this permission notice shall be included in all
4951 copies or substantial portions of the Software.
4952 
4953 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
4954 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
4955 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
4956 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
4957 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
4958 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
4959 SOFTWARE.
4960 
4961 */
4962 library Buffer {
4963 
4964     struct buffer {
4965         bytes buf;
4966         uint capacity;
4967     }
4968 
4969     function init(buffer memory _buf, uint _capacity) internal pure {
4970         uint capacity = _capacity;
4971         if (capacity % 32 != 0) {
4972             capacity += 32 - (capacity % 32);
4973         }
4974         _buf.capacity = capacity; // Allocate space for the buffer data
4975         assembly {
4976             let ptr := mload(0x40)
4977             mstore(_buf, ptr)
4978             mstore(ptr, 0)
4979             mstore(0x40, add(ptr, capacity))
4980         }
4981     }
4982 
4983     function resize(buffer memory _buf, uint _capacity) private pure {
4984         bytes memory oldbuf = _buf.buf;
4985         init(_buf, _capacity);
4986         append(_buf, oldbuf);
4987     }
4988 
4989     function max(uint _a, uint _b) private pure returns (uint _max) {
4990         if (_a > _b) {
4991             return _a;
4992         }
4993         return _b;
4994     }
4995     /**
4996       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
4997       *      would exceed the capacity of the buffer.
4998       * @param _buf The buffer to append to.
4999       * @param _data The data to append.
5000       * @return The original buffer.
5001       *
5002       */
5003     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
5004         if (_data.length + _buf.buf.length > _buf.capacity) {
5005             resize(_buf, max(_buf.capacity, _data.length) * 2);
5006         }
5007         uint dest;
5008         uint src;
5009         uint len = _data.length;
5010         assembly {
5011             let bufptr := mload(_buf) // Memory address of the buffer data
5012             let buflen := mload(bufptr) // Length of existing buffer data
5013             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
5014             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
5015             src := add(_data, 32)
5016         }
5017         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
5018             assembly {
5019                 mstore(dest, mload(src))
5020             }
5021             dest += 32;
5022             src += 32;
5023         }
5024         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
5025         assembly {
5026             let srcpart := and(mload(src), not(mask))
5027             let destpart := and(mload(dest), mask)
5028             mstore(dest, or(destpart, srcpart))
5029         }
5030         return _buf;
5031     }
5032     /**
5033       *
5034       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
5035       * exceed the capacity of the buffer.
5036       * @param _buf The buffer to append to.
5037       * @param _data The data to append.
5038       * @return The original buffer.
5039       *
5040       */
5041     function append(buffer memory _buf, uint8 _data) internal pure {
5042         if (_buf.buf.length + 1 > _buf.capacity) {
5043             resize(_buf, _buf.capacity * 2);
5044         }
5045         assembly {
5046             let bufptr := mload(_buf) // Memory address of the buffer data
5047             let buflen := mload(bufptr) // Length of existing buffer data
5048             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
5049             mstore8(dest, _data)
5050             mstore(bufptr, add(buflen, 1)) // Update buffer length
5051         }
5052     }
5053     /**
5054       *
5055       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
5056       * exceed the capacity of the buffer.
5057       * @param _buf The buffer to append to.
5058       * @param _data The data to append.
5059       * @return The original buffer.
5060       *
5061       */
5062     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
5063         if (_len + _buf.buf.length > _buf.capacity) {
5064             resize(_buf, max(_buf.capacity, _len) * 2);
5065         }
5066         uint mask = 256 ** _len - 1;
5067         assembly {
5068             let bufptr := mload(_buf) // Memory address of the buffer data
5069             let buflen := mload(bufptr) // Length of existing buffer data
5070             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
5071             mstore(dest, or(and(mload(dest), not(mask)), _data))
5072             mstore(bufptr, add(buflen, _len)) // Update buffer length
5073         }
5074         return _buf;
5075     }
5076 }
5077 
5078 library CBOR {
5079 
5080     using Buffer for Buffer.buffer;
5081 
5082     uint8 private constant MAJOR_TYPE_INT = 0;
5083     uint8 private constant MAJOR_TYPE_MAP = 5;
5084     uint8 private constant MAJOR_TYPE_BYTES = 2;
5085     uint8 private constant MAJOR_TYPE_ARRAY = 4;
5086     uint8 private constant MAJOR_TYPE_STRING = 3;
5087     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
5088     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
5089 
5090     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
5091         if (_value <= 23) {
5092             _buf.append(uint8((_major << 5) | _value));
5093         } else if (_value <= 0xFF) {
5094             _buf.append(uint8((_major << 5) | 24));
5095             _buf.appendInt(_value, 1);
5096         } else if (_value <= 0xFFFF) {
5097             _buf.append(uint8((_major << 5) | 25));
5098             _buf.appendInt(_value, 2);
5099         } else if (_value <= 0xFFFFFFFF) {
5100             _buf.append(uint8((_major << 5) | 26));
5101             _buf.appendInt(_value, 4);
5102         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
5103             _buf.append(uint8((_major << 5) | 27));
5104             _buf.appendInt(_value, 8);
5105         }
5106     }
5107 
5108     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
5109         _buf.append(uint8((_major << 5) | 31));
5110     }
5111 
5112     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
5113         encodeType(_buf, MAJOR_TYPE_INT, _value);
5114     }
5115 
5116     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
5117         if (_value >= 0) {
5118             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
5119         } else {
5120             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
5121         }
5122     }
5123 
5124     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
5125         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
5126         _buf.append(_value);
5127     }
5128 
5129     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
5130         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
5131         _buf.append(bytes(_value));
5132     }
5133 
5134     function startArray(Buffer.buffer memory _buf) internal pure {
5135         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
5136     }
5137 
5138     function startMap(Buffer.buffer memory _buf) internal pure {
5139         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
5140     }
5141 
5142     function endSequence(Buffer.buffer memory _buf) internal pure {
5143         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
5144     }
5145 }
5146 
5147 /*
5148 
5149 End solidity-cborutils
5150 
5151 */
5152 contract usingOraclize {
5153 
5154     using CBOR for Buffer.buffer;
5155 
5156     OraclizeI oraclize;
5157     OraclizeAddrResolverI OAR;
5158 
5159     uint constant day = 60 * 60 * 24;
5160     uint constant week = 60 * 60 * 24 * 7;
5161     uint constant month = 60 * 60 * 24 * 30;
5162 
5163     byte constant proofType_NONE = 0x00;
5164     byte constant proofType_Ledger = 0x30;
5165     byte constant proofType_Native = 0xF0;
5166     byte constant proofStorage_IPFS = 0x01;
5167     byte constant proofType_Android = 0x40;
5168     byte constant proofType_TLSNotary = 0x10;
5169 
5170     string oraclize_network_name;
5171     uint8 constant networkID_auto = 0;
5172     uint8 constant networkID_morden = 2;
5173     uint8 constant networkID_mainnet = 1;
5174     uint8 constant networkID_testnet = 2;
5175     uint8 constant networkID_consensys = 161;
5176 
5177     mapping(bytes32 => bytes32) oraclize_randomDS_args;
5178     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
5179 
5180     modifier oraclizeAPI {
5181         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
5182             oraclize_setNetwork(networkID_auto);
5183         }
5184         if (address(oraclize) != OAR.getAddress()) {
5185             oraclize = OraclizeI(OAR.getAddress());
5186         }
5187         _;
5188     }
5189 
5190     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
5191         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
5192         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
5193         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
5194         require(proofVerified);
5195         _;
5196     }
5197 
5198     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
5199       return oraclize_setNetwork();
5200       _networkID; // silence the warning and remain backwards compatible
5201     }
5202 
5203     function oraclize_setNetworkName(string memory _network_name) internal {
5204         oraclize_network_name = _network_name;
5205     }
5206 
5207     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
5208         return oraclize_network_name;
5209     }
5210 
5211     function oraclize_setNetwork() internal returns (bool _networkSet) {
5212         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
5213             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
5214             oraclize_setNetworkName("eth_mainnet");
5215             return true;
5216         }
5217         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
5218             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
5219             oraclize_setNetworkName("eth_ropsten3");
5220             return true;
5221         }
5222         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
5223             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
5224             oraclize_setNetworkName("eth_kovan");
5225             return true;
5226         }
5227         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
5228             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
5229             oraclize_setNetworkName("eth_rinkeby");
5230             return true;
5231         }
5232         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
5233             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
5234             oraclize_setNetworkName("eth_goerli");
5235             return true;
5236         }
5237         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
5238             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
5239             return true;
5240         }
5241         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
5242             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
5243             return true;
5244         }
5245         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
5246             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
5247             return true;
5248         }
5249         return false;
5250     }
5251 
5252     function __callback(bytes32 _myid, string memory _result) public {
5253         __callback(_myid, _result, new bytes(0));
5254     }
5255 
5256     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
5257       return;
5258       _myid; _result; _proof; // Silence compiler warnings
5259     }
5260 
5261     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
5262         return oraclize.getPrice(_datasource);
5263     }
5264 
5265     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
5266         return oraclize.getPrice(_datasource, _gasLimit);
5267     }
5268 
5269     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
5270         uint price = oraclize.getPrice(_datasource);
5271         if (price > 1 ether + tx.gasprice * 200000) {
5272             return 0; // Unexpectedly high price
5273         }
5274         return oraclize.query.value(price)(0, _datasource, _arg);
5275     }
5276 
5277     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
5278         uint price = oraclize.getPrice(_datasource);
5279         if (price > 1 ether + tx.gasprice * 200000) {
5280             return 0; // Unexpectedly high price
5281         }
5282         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
5283     }
5284 
5285     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5286         uint price = oraclize.getPrice(_datasource,_gasLimit);
5287         if (price > 1 ether + tx.gasprice * _gasLimit) {
5288             return 0; // Unexpectedly high price
5289         }
5290         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
5291     }
5292 
5293     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5294         uint price = oraclize.getPrice(_datasource, _gasLimit);
5295         if (price > 1 ether + tx.gasprice * _gasLimit) {
5296            return 0; // Unexpectedly high price
5297         }
5298         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
5299     }
5300 
5301     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
5302         uint price = oraclize.getPrice(_datasource);
5303         if (price > 1 ether + tx.gasprice * 200000) {
5304             return 0; // Unexpectedly high price
5305         }
5306         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
5307     }
5308 
5309     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
5310         uint price = oraclize.getPrice(_datasource);
5311         if (price > 1 ether + tx.gasprice * 200000) {
5312             return 0; // Unexpectedly high price
5313         }
5314         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
5315     }
5316 
5317     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5318         uint price = oraclize.getPrice(_datasource, _gasLimit);
5319         if (price > 1 ether + tx.gasprice * _gasLimit) {
5320             return 0; // Unexpectedly high price
5321         }
5322         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
5323     }
5324 
5325     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5326         uint price = oraclize.getPrice(_datasource, _gasLimit);
5327         if (price > 1 ether + tx.gasprice * _gasLimit) {
5328             return 0; // Unexpectedly high price
5329         }
5330         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
5331     }
5332 
5333     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
5334         uint price = oraclize.getPrice(_datasource);
5335         if (price > 1 ether + tx.gasprice * 200000) {
5336             return 0; // Unexpectedly high price
5337         }
5338         bytes memory args = stra2cbor(_argN);
5339         return oraclize.queryN.value(price)(0, _datasource, args);
5340     }
5341 
5342     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
5343         uint price = oraclize.getPrice(_datasource);
5344         if (price > 1 ether + tx.gasprice * 200000) {
5345             return 0; // Unexpectedly high price
5346         }
5347         bytes memory args = stra2cbor(_argN);
5348         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
5349     }
5350 
5351     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5352         uint price = oraclize.getPrice(_datasource, _gasLimit);
5353         if (price > 1 ether + tx.gasprice * _gasLimit) {
5354             return 0; // Unexpectedly high price
5355         }
5356         bytes memory args = stra2cbor(_argN);
5357         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
5358     }
5359 
5360     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5361         uint price = oraclize.getPrice(_datasource, _gasLimit);
5362         if (price > 1 ether + tx.gasprice * _gasLimit) {
5363             return 0; // Unexpectedly high price
5364         }
5365         bytes memory args = stra2cbor(_argN);
5366         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
5367     }
5368 
5369     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5370         string[] memory dynargs = new string[](1);
5371         dynargs[0] = _args[0];
5372         return oraclize_query(_datasource, dynargs);
5373     }
5374 
5375     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5376         string[] memory dynargs = new string[](1);
5377         dynargs[0] = _args[0];
5378         return oraclize_query(_timestamp, _datasource, dynargs);
5379     }
5380 
5381     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5382         string[] memory dynargs = new string[](1);
5383         dynargs[0] = _args[0];
5384         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5385     }
5386 
5387     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5388         string[] memory dynargs = new string[](1);
5389         dynargs[0] = _args[0];
5390         return oraclize_query(_datasource, dynargs, _gasLimit);
5391     }
5392 
5393     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5394         string[] memory dynargs = new string[](2);
5395         dynargs[0] = _args[0];
5396         dynargs[1] = _args[1];
5397         return oraclize_query(_datasource, dynargs);
5398     }
5399 
5400     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5401         string[] memory dynargs = new string[](2);
5402         dynargs[0] = _args[0];
5403         dynargs[1] = _args[1];
5404         return oraclize_query(_timestamp, _datasource, dynargs);
5405     }
5406 
5407     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5408         string[] memory dynargs = new string[](2);
5409         dynargs[0] = _args[0];
5410         dynargs[1] = _args[1];
5411         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5412     }
5413 
5414     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5415         string[] memory dynargs = new string[](2);
5416         dynargs[0] = _args[0];
5417         dynargs[1] = _args[1];
5418         return oraclize_query(_datasource, dynargs, _gasLimit);
5419     }
5420 
5421     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5422         string[] memory dynargs = new string[](3);
5423         dynargs[0] = _args[0];
5424         dynargs[1] = _args[1];
5425         dynargs[2] = _args[2];
5426         return oraclize_query(_datasource, dynargs);
5427     }
5428 
5429     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5430         string[] memory dynargs = new string[](3);
5431         dynargs[0] = _args[0];
5432         dynargs[1] = _args[1];
5433         dynargs[2] = _args[2];
5434         return oraclize_query(_timestamp, _datasource, dynargs);
5435     }
5436 
5437     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5438         string[] memory dynargs = new string[](3);
5439         dynargs[0] = _args[0];
5440         dynargs[1] = _args[1];
5441         dynargs[2] = _args[2];
5442         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5443     }
5444 
5445     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5446         string[] memory dynargs = new string[](3);
5447         dynargs[0] = _args[0];
5448         dynargs[1] = _args[1];
5449         dynargs[2] = _args[2];
5450         return oraclize_query(_datasource, dynargs, _gasLimit);
5451     }
5452 
5453     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5454         string[] memory dynargs = new string[](4);
5455         dynargs[0] = _args[0];
5456         dynargs[1] = _args[1];
5457         dynargs[2] = _args[2];
5458         dynargs[3] = _args[3];
5459         return oraclize_query(_datasource, dynargs);
5460     }
5461 
5462     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5463         string[] memory dynargs = new string[](4);
5464         dynargs[0] = _args[0];
5465         dynargs[1] = _args[1];
5466         dynargs[2] = _args[2];
5467         dynargs[3] = _args[3];
5468         return oraclize_query(_timestamp, _datasource, dynargs);
5469     }
5470 
5471     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5472         string[] memory dynargs = new string[](4);
5473         dynargs[0] = _args[0];
5474         dynargs[1] = _args[1];
5475         dynargs[2] = _args[2];
5476         dynargs[3] = _args[3];
5477         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5478     }
5479 
5480     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5481         string[] memory dynargs = new string[](4);
5482         dynargs[0] = _args[0];
5483         dynargs[1] = _args[1];
5484         dynargs[2] = _args[2];
5485         dynargs[3] = _args[3];
5486         return oraclize_query(_datasource, dynargs, _gasLimit);
5487     }
5488 
5489     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5490         string[] memory dynargs = new string[](5);
5491         dynargs[0] = _args[0];
5492         dynargs[1] = _args[1];
5493         dynargs[2] = _args[2];
5494         dynargs[3] = _args[3];
5495         dynargs[4] = _args[4];
5496         return oraclize_query(_datasource, dynargs);
5497     }
5498 
5499     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5500         string[] memory dynargs = new string[](5);
5501         dynargs[0] = _args[0];
5502         dynargs[1] = _args[1];
5503         dynargs[2] = _args[2];
5504         dynargs[3] = _args[3];
5505         dynargs[4] = _args[4];
5506         return oraclize_query(_timestamp, _datasource, dynargs);
5507     }
5508 
5509     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5510         string[] memory dynargs = new string[](5);
5511         dynargs[0] = _args[0];
5512         dynargs[1] = _args[1];
5513         dynargs[2] = _args[2];
5514         dynargs[3] = _args[3];
5515         dynargs[4] = _args[4];
5516         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5517     }
5518 
5519     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5520         string[] memory dynargs = new string[](5);
5521         dynargs[0] = _args[0];
5522         dynargs[1] = _args[1];
5523         dynargs[2] = _args[2];
5524         dynargs[3] = _args[3];
5525         dynargs[4] = _args[4];
5526         return oraclize_query(_datasource, dynargs, _gasLimit);
5527     }
5528 
5529     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
5530         uint price = oraclize.getPrice(_datasource);
5531         if (price > 1 ether + tx.gasprice * 200000) {
5532             return 0; // Unexpectedly high price
5533         }
5534         bytes memory args = ba2cbor(_argN);
5535         return oraclize.queryN.value(price)(0, _datasource, args);
5536     }
5537 
5538     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
5539         uint price = oraclize.getPrice(_datasource);
5540         if (price > 1 ether + tx.gasprice * 200000) {
5541             return 0; // Unexpectedly high price
5542         }
5543         bytes memory args = ba2cbor(_argN);
5544         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
5545     }
5546 
5547     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5548         uint price = oraclize.getPrice(_datasource, _gasLimit);
5549         if (price > 1 ether + tx.gasprice * _gasLimit) {
5550             return 0; // Unexpectedly high price
5551         }
5552         bytes memory args = ba2cbor(_argN);
5553         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
5554     }
5555 
5556     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5557         uint price = oraclize.getPrice(_datasource, _gasLimit);
5558         if (price > 1 ether + tx.gasprice * _gasLimit) {
5559             return 0; // Unexpectedly high price
5560         }
5561         bytes memory args = ba2cbor(_argN);
5562         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
5563     }
5564 
5565     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5566         bytes[] memory dynargs = new bytes[](1);
5567         dynargs[0] = _args[0];
5568         return oraclize_query(_datasource, dynargs);
5569     }
5570 
5571     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5572         bytes[] memory dynargs = new bytes[](1);
5573         dynargs[0] = _args[0];
5574         return oraclize_query(_timestamp, _datasource, dynargs);
5575     }
5576 
5577     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5578         bytes[] memory dynargs = new bytes[](1);
5579         dynargs[0] = _args[0];
5580         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5581     }
5582 
5583     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5584         bytes[] memory dynargs = new bytes[](1);
5585         dynargs[0] = _args[0];
5586         return oraclize_query(_datasource, dynargs, _gasLimit);
5587     }
5588 
5589     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5590         bytes[] memory dynargs = new bytes[](2);
5591         dynargs[0] = _args[0];
5592         dynargs[1] = _args[1];
5593         return oraclize_query(_datasource, dynargs);
5594     }
5595 
5596     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5597         bytes[] memory dynargs = new bytes[](2);
5598         dynargs[0] = _args[0];
5599         dynargs[1] = _args[1];
5600         return oraclize_query(_timestamp, _datasource, dynargs);
5601     }
5602 
5603     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5604         bytes[] memory dynargs = new bytes[](2);
5605         dynargs[0] = _args[0];
5606         dynargs[1] = _args[1];
5607         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5608     }
5609 
5610     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5611         bytes[] memory dynargs = new bytes[](2);
5612         dynargs[0] = _args[0];
5613         dynargs[1] = _args[1];
5614         return oraclize_query(_datasource, dynargs, _gasLimit);
5615     }
5616 
5617     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5618         bytes[] memory dynargs = new bytes[](3);
5619         dynargs[0] = _args[0];
5620         dynargs[1] = _args[1];
5621         dynargs[2] = _args[2];
5622         return oraclize_query(_datasource, dynargs);
5623     }
5624 
5625     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5626         bytes[] memory dynargs = new bytes[](3);
5627         dynargs[0] = _args[0];
5628         dynargs[1] = _args[1];
5629         dynargs[2] = _args[2];
5630         return oraclize_query(_timestamp, _datasource, dynargs);
5631     }
5632 
5633     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5634         bytes[] memory dynargs = new bytes[](3);
5635         dynargs[0] = _args[0];
5636         dynargs[1] = _args[1];
5637         dynargs[2] = _args[2];
5638         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5639     }
5640 
5641     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5642         bytes[] memory dynargs = new bytes[](3);
5643         dynargs[0] = _args[0];
5644         dynargs[1] = _args[1];
5645         dynargs[2] = _args[2];
5646         return oraclize_query(_datasource, dynargs, _gasLimit);
5647     }
5648 
5649     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5650         bytes[] memory dynargs = new bytes[](4);
5651         dynargs[0] = _args[0];
5652         dynargs[1] = _args[1];
5653         dynargs[2] = _args[2];
5654         dynargs[3] = _args[3];
5655         return oraclize_query(_datasource, dynargs);
5656     }
5657 
5658     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5659         bytes[] memory dynargs = new bytes[](4);
5660         dynargs[0] = _args[0];
5661         dynargs[1] = _args[1];
5662         dynargs[2] = _args[2];
5663         dynargs[3] = _args[3];
5664         return oraclize_query(_timestamp, _datasource, dynargs);
5665     }
5666 
5667     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5668         bytes[] memory dynargs = new bytes[](4);
5669         dynargs[0] = _args[0];
5670         dynargs[1] = _args[1];
5671         dynargs[2] = _args[2];
5672         dynargs[3] = _args[3];
5673         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5674     }
5675 
5676     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5677         bytes[] memory dynargs = new bytes[](4);
5678         dynargs[0] = _args[0];
5679         dynargs[1] = _args[1];
5680         dynargs[2] = _args[2];
5681         dynargs[3] = _args[3];
5682         return oraclize_query(_datasource, dynargs, _gasLimit);
5683     }
5684 
5685     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5686         bytes[] memory dynargs = new bytes[](5);
5687         dynargs[0] = _args[0];
5688         dynargs[1] = _args[1];
5689         dynargs[2] = _args[2];
5690         dynargs[3] = _args[3];
5691         dynargs[4] = _args[4];
5692         return oraclize_query(_datasource, dynargs);
5693     }
5694 
5695     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5696         bytes[] memory dynargs = new bytes[](5);
5697         dynargs[0] = _args[0];
5698         dynargs[1] = _args[1];
5699         dynargs[2] = _args[2];
5700         dynargs[3] = _args[3];
5701         dynargs[4] = _args[4];
5702         return oraclize_query(_timestamp, _datasource, dynargs);
5703     }
5704 
5705     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5706         bytes[] memory dynargs = new bytes[](5);
5707         dynargs[0] = _args[0];
5708         dynargs[1] = _args[1];
5709         dynargs[2] = _args[2];
5710         dynargs[3] = _args[3];
5711         dynargs[4] = _args[4];
5712         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5713     }
5714 
5715     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5716         bytes[] memory dynargs = new bytes[](5);
5717         dynargs[0] = _args[0];
5718         dynargs[1] = _args[1];
5719         dynargs[2] = _args[2];
5720         dynargs[3] = _args[3];
5721         dynargs[4] = _args[4];
5722         return oraclize_query(_datasource, dynargs, _gasLimit);
5723     }
5724 
5725     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
5726         return oraclize.setProofType(_proofP);
5727     }
5728 
5729 
5730     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
5731         return oraclize.cbAddress();
5732     }
5733 
5734     function getCodeSize(address _addr) view internal returns (uint _size) {
5735         assembly {
5736             _size := extcodesize(_addr)
5737         }
5738     }
5739 
5740     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
5741         return oraclize.setCustomGasPrice(_gasPrice);
5742     }
5743 
5744     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
5745         return oraclize.randomDS_getSessionPubKeyHash();
5746     }
5747 
5748     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
5749         bytes memory tmp = bytes(_a);
5750         uint160 iaddr = 0;
5751         uint160 b1;
5752         uint160 b2;
5753         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
5754             iaddr *= 256;
5755             b1 = uint160(uint8(tmp[i]));
5756             b2 = uint160(uint8(tmp[i + 1]));
5757             if ((b1 >= 97) && (b1 <= 102)) {
5758                 b1 -= 87;
5759             } else if ((b1 >= 65) && (b1 <= 70)) {
5760                 b1 -= 55;
5761             } else if ((b1 >= 48) && (b1 <= 57)) {
5762                 b1 -= 48;
5763             }
5764             if ((b2 >= 97) && (b2 <= 102)) {
5765                 b2 -= 87;
5766             } else if ((b2 >= 65) && (b2 <= 70)) {
5767                 b2 -= 55;
5768             } else if ((b2 >= 48) && (b2 <= 57)) {
5769                 b2 -= 48;
5770             }
5771             iaddr += (b1 * 16 + b2);
5772         }
5773         return address(iaddr);
5774     }
5775 
5776     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
5777         bytes memory a = bytes(_a);
5778         bytes memory b = bytes(_b);
5779         uint minLength = a.length;
5780         if (b.length < minLength) {
5781             minLength = b.length;
5782         }
5783         for (uint i = 0; i < minLength; i ++) {
5784             if (a[i] < b[i]) {
5785                 return -1;
5786             } else if (a[i] > b[i]) {
5787                 return 1;
5788             }
5789         }
5790         if (a.length < b.length) {
5791             return -1;
5792         } else if (a.length > b.length) {
5793             return 1;
5794         } else {
5795             return 0;
5796         }
5797     }
5798 
5799     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
5800         bytes memory h = bytes(_haystack);
5801         bytes memory n = bytes(_needle);
5802         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
5803             return -1;
5804         } else if (h.length > (2 ** 128 - 1)) {
5805             return -1;
5806         } else {
5807             uint subindex = 0;
5808             for (uint i = 0; i < h.length; i++) {
5809                 if (h[i] == n[0]) {
5810                     subindex = 1;
5811                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
5812                         subindex++;
5813                     }
5814                     if (subindex == n.length) {
5815                         return int(i);
5816                     }
5817                 }
5818             }
5819             return -1;
5820         }
5821     }
5822 
5823     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
5824         return strConcat(_a, _b, "", "", "");
5825     }
5826 
5827     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
5828         return strConcat(_a, _b, _c, "", "");
5829     }
5830 
5831     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
5832         return strConcat(_a, _b, _c, _d, "");
5833     }
5834 
5835     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
5836         bytes memory _ba = bytes(_a);
5837         bytes memory _bb = bytes(_b);
5838         bytes memory _bc = bytes(_c);
5839         bytes memory _bd = bytes(_d);
5840         bytes memory _be = bytes(_e);
5841         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
5842         bytes memory babcde = bytes(abcde);
5843         uint k = 0;
5844         uint i = 0;
5845         for (i = 0; i < _ba.length; i++) {
5846             babcde[k++] = _ba[i];
5847         }
5848         for (i = 0; i < _bb.length; i++) {
5849             babcde[k++] = _bb[i];
5850         }
5851         for (i = 0; i < _bc.length; i++) {
5852             babcde[k++] = _bc[i];
5853         }
5854         for (i = 0; i < _bd.length; i++) {
5855             babcde[k++] = _bd[i];
5856         }
5857         for (i = 0; i < _be.length; i++) {
5858             babcde[k++] = _be[i];
5859         }
5860         return string(babcde);
5861     }
5862 
5863     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
5864         return safeParseInt(_a, 0);
5865     }
5866 
5867     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
5868         bytes memory bresult = bytes(_a);
5869         uint mint = 0;
5870         bool decimals = false;
5871         for (uint i = 0; i < bresult.length; i++) {
5872             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
5873                 if (decimals) {
5874                    if (_b == 0) break;
5875                     else _b--;
5876                 }
5877                 mint *= 10;
5878                 mint += uint(uint8(bresult[i])) - 48;
5879             } else if (uint(uint8(bresult[i])) == 46) {
5880                 require(!decimals, 'More than one decimal encountered in string!');
5881                 decimals = true;
5882             } else {
5883                 revert("Non-numeral character encountered in string!");
5884             }
5885         }
5886         if (_b > 0) {
5887             mint *= 10 ** _b;
5888         }
5889         return mint;
5890     }
5891 
5892     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
5893         return parseInt(_a, 0);
5894     }
5895 
5896     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
5897         bytes memory bresult = bytes(_a);
5898         uint mint = 0;
5899         bool decimals = false;
5900         for (uint i = 0; i < bresult.length; i++) {
5901             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
5902                 if (decimals) {
5903                    if (_b == 0) {
5904                        break;
5905                    } else {
5906                        _b--;
5907                    }
5908                 }
5909                 mint *= 10;
5910                 mint += uint(uint8(bresult[i])) - 48;
5911             } else if (uint(uint8(bresult[i])) == 46) {
5912                 decimals = true;
5913             }
5914         }
5915         if (_b > 0) {
5916             mint *= 10 ** _b;
5917         }
5918         return mint;
5919     }
5920 
5921     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
5922         if (_i == 0) {
5923             return "0";
5924         }
5925         uint j = _i;
5926         uint len;
5927         while (j != 0) {
5928             len++;
5929             j /= 10;
5930         }
5931         bytes memory bstr = new bytes(len);
5932         uint k = len - 1;
5933         while (_i != 0) {
5934             bstr[k--] = byte(uint8(48 + _i % 10));
5935             _i /= 10;
5936         }
5937         return string(bstr);
5938     }
5939 
5940     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
5941         safeMemoryCleaner();
5942         Buffer.buffer memory buf;
5943         Buffer.init(buf, 1024);
5944         buf.startArray();
5945         for (uint i = 0; i < _arr.length; i++) {
5946             buf.encodeString(_arr[i]);
5947         }
5948         buf.endSequence();
5949         return buf.buf;
5950     }
5951 
5952     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
5953         safeMemoryCleaner();
5954         Buffer.buffer memory buf;
5955         Buffer.init(buf, 1024);
5956         buf.startArray();
5957         for (uint i = 0; i < _arr.length; i++) {
5958             buf.encodeBytes(_arr[i]);
5959         }
5960         buf.endSequence();
5961         return buf.buf;
5962     }
5963 
5964     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
5965         require((_nbytes > 0) && (_nbytes <= 32));
5966         _delay *= 10; // Convert from seconds to ledger timer ticks
5967         bytes memory nbytes = new bytes(1);
5968         nbytes[0] = byte(uint8(_nbytes));
5969         bytes memory unonce = new bytes(32);
5970         bytes memory sessionKeyHash = new bytes(32);
5971         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
5972         assembly {
5973             mstore(unonce, 0x20)
5974             /*
5975              The following variables can be relaxed.
5976              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
5977              for an idea on how to override and replace commit hash variables.
5978             */
5979             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
5980             mstore(sessionKeyHash, 0x20)
5981             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
5982         }
5983         bytes memory delay = new bytes(32);
5984         assembly {
5985             mstore(add(delay, 0x20), _delay)
5986         }
5987         bytes memory delay_bytes8 = new bytes(8);
5988         copyBytes(delay, 24, 8, delay_bytes8, 0);
5989         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
5990         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
5991         bytes memory delay_bytes8_left = new bytes(8);
5992         assembly {
5993             let x := mload(add(delay_bytes8, 0x20))
5994             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
5995             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
5996             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
5997             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
5998             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
5999             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
6000             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
6001             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
6002         }
6003         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
6004         return queryId;
6005     }
6006 
6007     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
6008         oraclize_randomDS_args[_queryId] = _commitment;
6009     }
6010 
6011     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
6012         bool sigok;
6013         address signer;
6014         bytes32 sigr;
6015         bytes32 sigs;
6016         bytes memory sigr_ = new bytes(32);
6017         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
6018         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
6019         bytes memory sigs_ = new bytes(32);
6020         offset += 32 + 2;
6021         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
6022         assembly {
6023             sigr := mload(add(sigr_, 32))
6024             sigs := mload(add(sigs_, 32))
6025         }
6026         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
6027         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
6028             return true;
6029         } else {
6030             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
6031             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
6032         }
6033     }
6034 
6035     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
6036         bool sigok;
6037         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
6038         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
6039         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
6040         bytes memory appkey1_pubkey = new bytes(64);
6041         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
6042         bytes memory tosign2 = new bytes(1 + 65 + 32);
6043         tosign2[0] = byte(uint8(1)); //role
6044         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
6045         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
6046         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
6047         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
6048         if (!sigok) {
6049             return false;
6050         }
6051         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
6052         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
6053         bytes memory tosign3 = new bytes(1 + 65);
6054         tosign3[0] = 0xFE;
6055         copyBytes(_proof, 3, 65, tosign3, 1);
6056         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
6057         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
6058         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
6059         return sigok;
6060     }
6061 
6062     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
6063         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
6064         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
6065             return 1;
6066         }
6067         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
6068         if (!proofVerified) {
6069             return 2;
6070         }
6071         return 0;
6072     }
6073 
6074     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
6075         bool match_ = true;
6076         require(_prefix.length == _nRandomBytes);
6077         for (uint256 i = 0; i< _nRandomBytes; i++) {
6078             if (_content[i] != _prefix[i]) {
6079                 match_ = false;
6080             }
6081         }
6082         return match_;
6083     }
6084 
6085     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
6086         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
6087         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
6088         bytes memory keyhash = new bytes(32);
6089         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
6090         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
6091             return false;
6092         }
6093         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
6094         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
6095         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
6096         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
6097             return false;
6098         }
6099         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
6100         // This is to verify that the computed args match with the ones specified in the query.
6101         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
6102         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
6103         bytes memory sessionPubkey = new bytes(64);
6104         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
6105         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
6106         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
6107         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
6108             delete oraclize_randomDS_args[_queryId];
6109         } else return false;
6110         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
6111         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
6112         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
6113         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
6114             return false;
6115         }
6116         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
6117         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
6118             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
6119         }
6120         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
6121     }
6122     /*
6123      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
6124     */
6125     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
6126         uint minLength = _length + _toOffset;
6127         require(_to.length >= minLength); // Buffer too small. Should be a better way?
6128         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
6129         uint j = 32 + _toOffset;
6130         while (i < (32 + _fromOffset + _length)) {
6131             assembly {
6132                 let tmp := mload(add(_from, i))
6133                 mstore(add(_to, j), tmp)
6134             }
6135             i += 32;
6136             j += 32;
6137         }
6138         return _to;
6139     }
6140     /*
6141      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
6142      Duplicate Solidity's ecrecover, but catching the CALL return value
6143     */
6144     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
6145         /*
6146          We do our own memory management here. Solidity uses memory offset
6147          0x40 to store the current end of memory. We write past it (as
6148          writes are memory extensions), but don't update the offset so
6149          Solidity will reuse it. The memory used here is only needed for
6150          this context.
6151          FIXME: inline assembly can't access return values
6152         */
6153         bool ret;
6154         address addr;
6155         assembly {
6156             let size := mload(0x40)
6157             mstore(size, _hash)
6158             mstore(add(size, 32), _v)
6159             mstore(add(size, 64), _r)
6160             mstore(add(size, 96), _s)
6161             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
6162             addr := mload(size)
6163         }
6164         return (ret, addr);
6165     }
6166     /*
6167      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
6168     */
6169     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
6170         bytes32 r;
6171         bytes32 s;
6172         uint8 v;
6173         if (_sig.length != 65) {
6174             return (false, address(0));
6175         }
6176         /*
6177          The signature format is a compact form of:
6178            {bytes32 r}{bytes32 s}{uint8 v}
6179          Compact means, uint8 is not padded to 32 bytes.
6180         */
6181         assembly {
6182             r := mload(add(_sig, 32))
6183             s := mload(add(_sig, 64))
6184             /*
6185              Here we are loading the last 32 bytes. We exploit the fact that
6186              'mload' will pad with zeroes if we overread.
6187              There is no 'mload8' to do this, but that would be nicer.
6188             */
6189             v := byte(0, mload(add(_sig, 96)))
6190             /*
6191               Alternative solution:
6192               'byte' is not working due to the Solidity parser, so lets
6193               use the second best option, 'and'
6194               v := and(mload(add(_sig, 65)), 255)
6195             */
6196         }
6197         /*
6198          albeit non-transactional signatures are not specified by the YP, one would expect it
6199          to match the YP range of [27, 28]
6200          geth uses [0, 1] and some clients have followed. This might change, see:
6201          https://github.com/ethereum/go-ethereum/issues/2053
6202         */
6203         if (v < 27) {
6204             v += 27;
6205         }
6206         if (v != 27 && v != 28) {
6207             return (false, address(0));
6208         }
6209         return safer_ecrecover(_hash, v, r, s);
6210     }
6211 
6212     function safeMemoryCleaner() internal pure {
6213         assembly {
6214             let fmem := mload(0x40)
6215             codecopy(fmem, codesize, sub(msize, fmem))
6216         }
6217     }
6218 }
6219 
6220 /*
6221 
6222 END ORACLIZE_API
6223 
6224 */
6225 
6226 /* Copyright (C) 2017 NexusMutual.io
6227 
6228   This program is free software: you can redistribute it and/or modify
6229     it under the terms of the GNU General Public License as published by
6230     the Free Software Foundation, either version 3 of the License, or
6231     (at your option) any later version.
6232 
6233   This program is distributed in the hope that it will be useful,
6234     but WITHOUT ANY WARRANTY; without even the implied warranty of
6235     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
6236     GNU General Public License for more details.
6237 
6238   You should have received a copy of the GNU General Public License
6239     along with this program.  If not, see http://www.gnu.org/licenses/ */
6240 contract Quotation is Iupgradable {
6241     using SafeMath for uint;
6242 
6243     TokenFunctions internal tf;
6244     TokenController internal tc;
6245     TokenData internal td;
6246     Pool1 internal p1;
6247     PoolData internal pd;
6248     QuotationData internal qd;
6249     MCR internal m1;
6250     MemberRoles internal mr;
6251     bool internal locked;
6252 
6253     event RefundEvent(address indexed user, bool indexed status, uint holdedCoverID, bytes32 reason);
6254 
6255     modifier noReentrancy() {
6256         require(!locked, "Reentrant call.");
6257         locked = true;
6258         _;
6259         locked = false;
6260     }
6261     
6262     /**
6263      * @dev Iupgradable Interface to update dependent contract address
6264      */
6265     function changeDependentContractAddress() public onlyInternal {
6266         m1 = MCR(ms.getLatestAddress("MC"));
6267         tf = TokenFunctions(ms.getLatestAddress("TF"));
6268         tc = TokenController(ms.getLatestAddress("TC"));
6269         td = TokenData(ms.getLatestAddress("TD"));
6270         qd = QuotationData(ms.getLatestAddress("QD"));
6271         p1 = Pool1(ms.getLatestAddress("P1"));
6272         pd = PoolData(ms.getLatestAddress("PD"));
6273         mr = MemberRoles(ms.getLatestAddress("MR"));
6274     }
6275 
6276     function sendEther() public payable {
6277         
6278     }
6279 
6280     /**
6281      * @dev Expires a cover after a set period of time.
6282      * Changes the status of the Cover and reduces the current
6283      * sum assured of all areas in which the quotation lies
6284      * Unlocks the CN tokens of the cover. Updates the Total Sum Assured value.
6285      * @param _cid Cover Id.
6286      */ 
6287     function expireCover(uint _cid) public {
6288         require(checkCoverExpired(_cid) && qd.getCoverStatusNo(_cid) != uint(QuotationData.CoverStatus.CoverExpired));
6289         
6290         tf.unlockCN(_cid);
6291         bytes4 curr;
6292         address scAddress;
6293         uint sumAssured;
6294         (, , scAddress, curr, sumAssured, ) = qd.getCoverDetailsByCoverID1(_cid);
6295         if (qd.getCoverStatusNo(_cid) != uint(QuotationData.CoverStatus.ClaimAccepted))
6296             _removeSAFromCSA(_cid, sumAssured);
6297         qd.changeCoverStatusNo(_cid, uint8(QuotationData.CoverStatus.CoverExpired));       
6298     }
6299 
6300     /**
6301      * @dev Checks if a cover should get expired/closed or not.
6302      * @param _cid Cover Index.
6303      * @return expire true if the Cover's time has expired, false otherwise.
6304      */ 
6305     function checkCoverExpired(uint _cid) public view returns(bool expire) {
6306 
6307         expire = qd.getValidityOfCover(_cid) < uint64(now);
6308 
6309     }
6310 
6311     /**
6312      * @dev Updates the Sum Assured Amount of all the quotation.
6313      * @param _cid Cover id
6314      * @param _amount that will get subtracted Current Sum Assured 
6315      * amount that comes under a quotation.
6316      */ 
6317     function removeSAFromCSA(uint _cid, uint _amount) public onlyInternal {
6318         _removeSAFromCSA(_cid, _amount);        
6319     }
6320 
6321     /**
6322      * @dev Makes Cover funded via NXM tokens.
6323      * @param smartCAdd Smart Contract Address
6324      */ 
6325     function makeCoverUsingNXMTokens(
6326         uint[] memory coverDetails,
6327         uint16 coverPeriod,
6328         bytes4 coverCurr,
6329         address smartCAdd,
6330         uint8 _v,
6331         bytes32 _r,
6332         bytes32 _s
6333     )
6334         public
6335         isMemberAndcheckPause
6336     {
6337         
6338         tc.burnFrom(msg.sender, coverDetails[2]); //need burn allowance
6339         _verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
6340     }
6341 
6342     /**
6343      * @dev Verifies cover details signed off chain.
6344      * @param from address of funder.
6345      * @param scAddress Smart Contract Address
6346      */
6347     function verifyCoverDetails(
6348         address payable from,
6349         address scAddress,
6350         bytes4 coverCurr,
6351         uint[] memory coverDetails,
6352         uint16 coverPeriod,
6353         uint8 _v,
6354         bytes32 _r,
6355         bytes32 _s
6356     )
6357         public
6358         onlyInternal
6359     {
6360         _verifyCoverDetails(
6361             from,
6362             scAddress,
6363             coverCurr,
6364             coverDetails,
6365             coverPeriod,
6366             _v,
6367             _r,
6368             _s
6369         );
6370     }
6371 
6372     /** 
6373      * @dev Verifies signature.
6374      * @param coverDetails details related to cover.
6375      * @param coverPeriod validity of cover.
6376      * @param smaratCA smarat contract address.
6377      * @param _v argument from vrs hash.
6378      * @param _r argument from vrs hash.
6379      * @param _s argument from vrs hash.
6380      */ 
6381     function verifySign(
6382         uint[] memory coverDetails,
6383         uint16 coverPeriod,
6384         bytes4 curr,
6385         address smaratCA,
6386         uint8 _v,
6387         bytes32 _r,
6388         bytes32 _s
6389     ) 
6390         public
6391         view
6392         returns(bool)
6393     {
6394         require(smaratCA != address(0));
6395         require(pd.capReached() == 1, "Can not buy cover until cap reached for 1st time");
6396         bytes32 hash = getOrderHash(coverDetails, coverPeriod, curr, smaratCA);
6397         return isValidSignature(hash, _v, _r, _s);
6398     }
6399 
6400     /**
6401      * @dev Gets order hash for given cover details.
6402      * @param coverDetails details realted to cover.
6403      * @param coverPeriod validity of cover.
6404      * @param smaratCA smarat contract address.
6405      */ 
6406     function getOrderHash(
6407         uint[] memory coverDetails,
6408         uint16 coverPeriod,
6409         bytes4 curr,
6410         address smaratCA
6411     ) 
6412         public
6413         view
6414         returns(bytes32)
6415     {
6416         return keccak256(
6417             abi.encodePacked(
6418                 coverDetails[0],
6419                 curr, coverPeriod,
6420                 smaratCA,
6421                 coverDetails[1],
6422                 coverDetails[2],
6423                 coverDetails[3],
6424                 coverDetails[4],
6425                 address(this)
6426             )
6427         );
6428     }
6429 
6430     /**
6431      * @dev Verifies signature.
6432      * @param hash order hash
6433      * @param v argument from vrs hash.
6434      * @param r argument from vrs hash.
6435      * @param s argument from vrs hash.
6436      */  
6437     function isValidSignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public view returns(bool) {
6438         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
6439         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
6440         address a = ecrecover(prefixedHash, v, r, s);
6441         return (a == qd.getAuthQuoteEngine());
6442     }
6443 
6444     /**
6445      * @dev to get the status of recently holded coverID 
6446      * @param userAdd is the user address in concern
6447      * @return the status of the concerned coverId
6448      */
6449     function getRecentHoldedCoverIdStatus(address userAdd) public view returns(int) {
6450 
6451         uint holdedCoverLen = qd.getUserHoldedCoverLength(userAdd);
6452         if (holdedCoverLen == 0) {
6453             return -1;
6454         } else {
6455             uint holdedCoverID = qd.getUserHoldedCoverByIndex(userAdd, holdedCoverLen.sub(1));
6456             return int(qd.holdedCoverIDStatus(holdedCoverID));
6457         }
6458     }
6459     
6460     /**
6461      * @dev to initiate the membership and the cover 
6462      * @param smartCAdd is the smart contract address to make cover on
6463      * @param coverCurr is the currency used to make cover
6464      * @param coverDetails list of details related to cover like cover amount, expire time, coverCurrPrice and priceNXM
6465      * @param coverPeriod is cover period for which cover is being bought
6466      * @param _v argument from vrs hash 
6467      * @param _r argument from vrs hash 
6468      * @param _s argument from vrs hash 
6469      */
6470     function initiateMembershipAndCover(
6471         address smartCAdd,
6472         bytes4 coverCurr,
6473         uint[] memory coverDetails,
6474         uint16 coverPeriod,
6475         uint8 _v,
6476         bytes32 _r,
6477         bytes32 _s
6478     ) 
6479         public
6480         payable
6481         checkPause
6482     {
6483         require(coverDetails[3] > now);
6484         require(!qd.timestampRepeated(coverDetails[4]));
6485         qd.setTimestampRepeated(coverDetails[4]);
6486         require(!ms.isMember(msg.sender));
6487         require(qd.refundEligible(msg.sender) == false);
6488         uint joinFee = td.joiningFee();
6489         uint totalFee = joinFee;
6490         if (coverCurr == "ETH") {
6491             totalFee = joinFee.add(coverDetails[1]);
6492         } else {
6493             IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
6494             require(erc20.transferFrom(msg.sender, address(this), coverDetails[1]));
6495         }
6496         require(msg.value == totalFee);
6497         require(verifySign(coverDetails, coverPeriod, coverCurr, smartCAdd, _v, _r, _s));
6498         qd.addHoldCover(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod);
6499         qd.setRefundEligible(msg.sender, true);
6500     }
6501 
6502     /**
6503      * @dev to get the verdict of kyc process 
6504      * @param status is the kyc status
6505      * @param _add is the address of member
6506      */
6507     function kycVerdict(address _add, bool status) public checkPause noReentrancy {
6508         require(msg.sender == qd.kycAuthAddress());
6509         _kycTrigger(status, _add);
6510     }
6511 
6512     /**
6513      * @dev transfering Ethers to newly created quotation contract.
6514      */  
6515     function transferAssetsToNewContract(address newAdd) public onlyInternal noReentrancy {
6516         uint amount = address(this).balance;
6517         IERC20 erc20;
6518         if (amount > 0) {
6519             // newAdd.transfer(amount);   
6520             Quotation newQT = Quotation(newAdd);
6521             newQT.sendEther.value(amount)();
6522         }
6523         uint currAssetLen = pd.getAllCurrenciesLen();
6524         for (uint64 i = 1; i < currAssetLen; i++) {
6525             bytes4 currName = pd.getCurrenciesByIndex(i);
6526             address currAddr = pd.getCurrencyAssetAddress(currName);
6527             erc20 = IERC20(currAddr); //solhint-disable-line
6528             if (erc20.balanceOf(address(this)) > 0) {
6529                 require(erc20.transfer(newAdd, erc20.balanceOf(address(this))));
6530             }
6531         }
6532     }
6533 
6534 
6535     /**
6536      * @dev Creates cover of the quotation, changes the status of the quotation ,
6537      * updates the total sum assured and locks the tokens of the cover against a quote.
6538      * @param from Quote member Ethereum address.
6539      */  
6540 
6541     function _makeCover ( //solhint-disable-line
6542         address payable from,
6543         address scAddress,
6544         bytes4 coverCurr,
6545         uint[] memory coverDetails,
6546         uint16 coverPeriod
6547     )
6548         internal
6549     {
6550         uint cid = qd.getCoverLength();
6551         qd.addCover(coverPeriod, coverDetails[0],
6552             from, coverCurr, scAddress, coverDetails[1], coverDetails[2]);
6553         // if cover period of quote is less than 60 days.
6554         if (coverPeriod <= 60) {
6555             p1.closeCoverOraclise(cid, uint64(uint(coverPeriod).mul(1 days)));
6556         }
6557         uint coverNoteAmount = (coverDetails[2].mul(qd.tokensRetained())).div(100);
6558         tc.mint(from, coverNoteAmount);
6559         tf.lockCN(coverNoteAmount, coverPeriod, cid, from);
6560         qd.addInTotalSumAssured(coverCurr, coverDetails[0]);
6561         qd.addInTotalSumAssuredSC(scAddress, coverCurr, coverDetails[0]);
6562 
6563 
6564         tf.pushStakerRewards(scAddress, coverDetails[2]);
6565     }
6566 
6567     /**
6568      * @dev Makes a vover.
6569      * @param from address of funder.
6570      * @param scAddress Smart Contract Address
6571      */  
6572     function _verifyCoverDetails(
6573         address payable from,
6574         address scAddress,
6575         bytes4 coverCurr,
6576         uint[] memory coverDetails,
6577         uint16 coverPeriod,
6578         uint8 _v,
6579         bytes32 _r,
6580         bytes32 _s
6581     )
6582         internal
6583     {
6584         require(coverDetails[3] > now);
6585         require(!qd.timestampRepeated(coverDetails[4]));
6586         qd.setTimestampRepeated(coverDetails[4]);
6587         require(verifySign(coverDetails, coverPeriod, coverCurr, scAddress, _v, _r, _s));
6588         _makeCover(from, scAddress, coverCurr, coverDetails, coverPeriod);
6589 
6590     }
6591 
6592     /**
6593      * @dev Updates the Sum Assured Amount of all the quotation.
6594      * @param _cid Cover id
6595      * @param _amount that will get subtracted Current Sum Assured 
6596      * amount that comes under a quotation.
6597      */ 
6598     function _removeSAFromCSA(uint _cid, uint _amount) internal checkPause {
6599         address _add;
6600         bytes4 coverCurr;
6601         (, , _add, coverCurr, , ) = qd.getCoverDetailsByCoverID1(_cid);
6602         qd.subFromTotalSumAssured(coverCurr, _amount);        
6603         qd.subFromTotalSumAssuredSC(_add, coverCurr, _amount);
6604     }
6605 
6606     /**
6607      * @dev to trigger the kyc process 
6608      * @param status is the kyc status
6609      * @param _add is the address of member
6610      */
6611     function _kycTrigger(bool status, address _add) internal {
6612 
6613         uint holdedCoverLen = qd.getUserHoldedCoverLength(_add).sub(1);
6614         uint holdedCoverID = qd.getUserHoldedCoverByIndex(_add, holdedCoverLen);
6615         address payable userAdd;
6616         address scAddress;
6617         bytes4 coverCurr;
6618         uint16 coverPeriod;
6619         uint[]  memory coverDetails = new uint[](4);
6620         IERC20 erc20;
6621 
6622         (, userAdd, coverDetails) = qd.getHoldedCoverDetailsByID2(holdedCoverID);
6623         (, scAddress, coverCurr, coverPeriod) = qd.getHoldedCoverDetailsByID1(holdedCoverID);
6624         require(qd.refundEligible(userAdd));
6625         qd.setRefundEligible(userAdd, false);
6626         require(qd.holdedCoverIDStatus(holdedCoverID) == uint(QuotationData.HCIDStatus.kycPending));
6627         uint joinFee = td.joiningFee();
6628         if (status) {
6629             mr.payJoiningFee.value(joinFee)(userAdd);
6630             if (coverDetails[3] > now) { 
6631                 qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycPass));
6632                 address poolAdd = ms.getLatestAddress("P1");
6633                 if (coverCurr == "ETH") {
6634                     p1.sendEther.value(coverDetails[1])();
6635                 } else {
6636                     erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
6637                     require(erc20.transfer(poolAdd, coverDetails[1]));
6638                 }
6639                 emit RefundEvent(userAdd, status, holdedCoverID, "KYC Passed");               
6640                 _makeCover(userAdd, scAddress, coverCurr, coverDetails, coverPeriod);
6641 
6642             } else {
6643                 qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycPassNoCover));
6644                 if (coverCurr == "ETH") {
6645                     userAdd.transfer(coverDetails[1]);
6646                 } else {
6647                     erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
6648                     require(erc20.transfer(userAdd, coverDetails[1]));
6649                 }
6650                 emit RefundEvent(userAdd, status, holdedCoverID, "Cover Failed");
6651             }
6652         } else {
6653             qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycFailedOrRefunded));
6654             uint totalRefund = joinFee;
6655             if (coverCurr == "ETH") {
6656                 totalRefund = coverDetails[1].add(joinFee);
6657             } else {
6658                 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
6659                 require(erc20.transfer(userAdd, coverDetails[1]));
6660             }
6661             userAdd.transfer(totalRefund);
6662             emit RefundEvent(userAdd, status, holdedCoverID, "KYC Failed");
6663         }
6664               
6665     }
6666 }
6667 
6668 contract Factory {
6669     function getExchange(address token) public view returns (address);
6670     function getToken(address exchange) public view returns (address);
6671 }
6672 
6673 contract Exchange { 
6674     function getEthToTokenInputPrice(uint256 ethSold) public view returns(uint256);
6675 
6676     function getTokenToEthInputPrice(uint256 tokensSold) public view returns(uint256);
6677 
6678     function ethToTokenSwapInput(uint256 minTokens, uint256 deadline) public payable returns (uint256);
6679 
6680     function ethToTokenTransferInput(uint256 minTokens, uint256 deadline, address recipient)
6681         public payable returns (uint256);
6682 
6683     function tokenToEthSwapInput(uint256 tokensSold, uint256 minEth, uint256 deadline)
6684         public payable returns (uint256);
6685 
6686     function tokenToEthTransferInput(uint256 tokensSold, uint256 minEth, uint256 deadline, address recipient) 
6687         public payable returns (uint256);
6688 
6689     function tokenToTokenSwapInput(
6690         uint256 tokensSold,
6691         uint256 minTokensBought,
6692         uint256 minEthBought,
6693         uint256 deadline,
6694         address tokenAddress
6695     ) 
6696         public returns (uint256);
6697 
6698     function tokenToTokenTransferInput(
6699         uint256 tokensSold,
6700         uint256 minTokensBought,
6701         uint256 minEthBought,
6702         uint256 deadline,
6703         address recipient,
6704         address tokenAddress
6705     )
6706         public returns (uint256);
6707 }
6708 
6709 /* Copyright (C) 2017 NexusMutual.io
6710 
6711   This program is free software: you can redistribute it and/or modify
6712     it under the terms of the GNU General Public License as published by
6713     the Free Software Foundation, either version 3 of the License, or
6714     (at your option) any later version.
6715 
6716   This program is distributed in the hope that it will be useful,
6717     but WITHOUT ANY WARRANTY; without even the implied warranty of
6718     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
6719     GNU General Public License for more details.
6720 
6721   You should have received a copy of the GNU General Public License
6722     along with this program.  If not, see http://www.gnu.org/licenses/ */
6723 contract Pool2 is Iupgradable {
6724     using SafeMath for uint;
6725 
6726     MCR internal m1;
6727     Pool1 internal p1;
6728     PoolData internal pd;
6729     Factory internal factory;
6730     address public uniswapFactoryAddress;
6731     uint internal constant DECIMAL1E18 = uint(10) ** 18;
6732     bool internal locked;
6733 
6734     constructor(address _uniswapFactoryAdd) public {
6735        
6736         uniswapFactoryAddress = _uniswapFactoryAdd;
6737         factory = Factory(_uniswapFactoryAdd);
6738     }
6739 
6740     function() external payable {}
6741 
6742     event Liquidity(bytes16 typeOf, bytes16 functionName);
6743 
6744     event Rebalancing(bytes4 iaCurr, uint tokenAmount);
6745 
6746     modifier noReentrancy() {
6747         require(!locked, "Reentrant call.");
6748         locked = true;
6749         _;
6750         locked = false;
6751     }
6752 
6753     /**
6754      * @dev to change the uniswap factory address 
6755      * @param newFactoryAddress is the new factory address in concern
6756      * @return the status of the concerned coverId
6757      */
6758     function changeUniswapFactoryAddress(address newFactoryAddress) external onlyInternal {
6759         // require(ms.isOwner(msg.sender) || ms.checkIsAuthToGoverned(msg.sender));
6760         uniswapFactoryAddress = newFactoryAddress;
6761         factory = Factory(uniswapFactoryAddress);
6762     }
6763 
6764     /**
6765      * @dev On upgrade transfer all investment assets and ether to new Investment Pool
6766      * @param newPoolAddress New Investment Assest Pool address
6767      */
6768     function upgradeInvestmentPool(address payable newPoolAddress) external onlyInternal noReentrancy {
6769         uint len = pd.getInvestmentCurrencyLen();
6770         for (uint64 i = 1; i < len; i++) {
6771             bytes4 iaName = pd.getInvestmentCurrencyByIndex(i);
6772             _upgradeInvestmentPool(iaName, newPoolAddress);
6773         }
6774 
6775         if (address(this).balance > 0) {
6776             Pool2 newP2 = Pool2(newPoolAddress);
6777             newP2.sendEther.value(address(this).balance)();
6778         }
6779     }
6780 
6781     /**
6782      * @dev Internal Swap of assets between Capital 
6783      * and Investment Sub pool for excess or insufficient  
6784      * liquidity conditions of a given currency.
6785      */ 
6786     function internalLiquiditySwap(bytes4 curr) external onlyInternal noReentrancy {
6787         uint caBalance;
6788         uint baseMin;
6789         uint varMin;
6790         (, baseMin, varMin) = pd.getCurrencyAssetVarBase(curr);
6791         caBalance = _getCurrencyAssetsBalance(curr);
6792 
6793         if (caBalance > uint(baseMin).add(varMin).mul(2)) {
6794             _internalExcessLiquiditySwap(curr, baseMin, varMin, caBalance);
6795         } else if (caBalance < uint(baseMin).add(varMin)) {
6796             _internalInsufficientLiquiditySwap(curr, baseMin, varMin, caBalance);
6797             
6798         }
6799     }
6800 
6801     /**
6802      * @dev Saves a given investment asset details. To be called daily.
6803      * @param curr array of Investment asset name.
6804      * @param rate array of investment asset exchange rate.
6805      * @param date current date in yyyymmdd.
6806      */ 
6807     function saveIADetails(bytes4[] calldata curr, uint64[] calldata rate, uint64 date, bool bit) 
6808     external checkPause noReentrancy {
6809         bytes4 maxCurr;
6810         bytes4 minCurr;
6811         uint64 maxRate;
6812         uint64 minRate;
6813         //ONLY NOTARZIE ADDRESS CAN POST
6814         require(pd.isnotarise(msg.sender));
6815         (maxCurr, maxRate, minCurr, minRate) = _calculateIARank(curr, rate);
6816         pd.saveIARankDetails(maxCurr, maxRate, minCurr, minRate, date);
6817         pd.updatelastDate(date);
6818         uint len = curr.length;
6819         for (uint i = 0; i < len; i++) {
6820             pd.updateIAAvgRate(curr[i], rate[i]);
6821         }
6822         if (bit)   //for testing purpose
6823             _rebalancingLiquidityTrading(maxCurr, maxRate);
6824         p1.saveIADetailsOracalise(pd.iaRatesTime());
6825     }
6826 
6827     /**
6828      * @dev External Trade for excess or insufficient  
6829      * liquidity conditions of a given currency.
6830      */ 
6831     function externalLiquidityTrade() external onlyInternal {
6832         
6833         bool triggerTrade;
6834         bytes4 curr;
6835         bytes4 minIACurr;
6836         bytes4 maxIACurr;
6837         uint amount;
6838         uint minIARate;
6839         uint maxIARate;
6840         uint baseMin;
6841         uint varMin;
6842         uint caBalance;
6843 
6844 
6845         (maxIACurr, maxIARate, minIACurr, minIARate) = pd.getIARankDetailsByDate(pd.getLastDate());
6846         uint len = pd.getAllCurrenciesLen();
6847         for (uint64 i = 0; i < len; i++) {
6848             curr = pd.getCurrenciesByIndex(i);
6849             (, baseMin, varMin) = pd.getCurrencyAssetVarBase(curr);
6850             caBalance = _getCurrencyAssetsBalance(curr);
6851 
6852             if (caBalance > uint(baseMin).add(varMin).mul(2)) { //excess
6853                 amount = caBalance.sub(((uint(baseMin).add(varMin)).mul(3)).div(2)); //*10**18;
6854                 triggerTrade = _externalExcessLiquiditySwap(curr, minIACurr, amount);
6855             } else if (caBalance < uint(baseMin).add(varMin)) { // insufficient
6856                 amount = (((uint(baseMin).add(varMin)).mul(3)).div(2)).sub(caBalance);
6857                 triggerTrade = _externalInsufficientLiquiditySwap(curr, maxIACurr, amount);
6858             }
6859 
6860             if (triggerTrade) {
6861                 p1.triggerExternalLiquidityTrade();
6862             }
6863         }
6864     }
6865 
6866     /**
6867      * Iupgradable Interface to update dependent contract address
6868      */
6869     function changeDependentContractAddress() public onlyInternal {
6870         m1 = MCR(ms.getLatestAddress("MC"));
6871         pd = PoolData(ms.getLatestAddress("PD"));
6872         p1 = Pool1(ms.getLatestAddress("P1"));
6873     }
6874 
6875     function sendEther() public payable {
6876         
6877     }
6878 
6879     /** 
6880      * @dev Gets currency asset balance for a given currency name.
6881      */   
6882     function _getCurrencyAssetsBalance(bytes4 _curr) public view returns(uint caBalance) {
6883         if (_curr == "ETH") {
6884             caBalance = address(p1).balance;
6885         } else {
6886             IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr));
6887             caBalance = erc20.balanceOf(address(p1));
6888         }
6889     }
6890 
6891     /** 
6892      * @dev Transfers ERC20 investment asset from this Pool to another Pool.
6893      */ 
6894     function _transferInvestmentAsset(
6895         bytes4 _curr,
6896         address _transferTo,
6897         uint _amount
6898     ) 
6899         internal
6900     {
6901         if (_curr == "ETH") {
6902             if (_amount > address(this).balance)
6903                 _amount = address(this).balance;
6904             p1.sendEther.value(_amount)();
6905         } else {
6906             IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
6907             if (_amount > erc20.balanceOf(address(this)))
6908                 _amount = erc20.balanceOf(address(this));
6909             require(erc20.transfer(_transferTo, _amount));
6910         }
6911     }
6912 
6913     /**
6914      * @dev to perform rebalancing 
6915      * @param iaCurr is the investment asset currency
6916      * @param iaRate is the investment asset rate
6917      */
6918     function _rebalancingLiquidityTrading(
6919         bytes4 iaCurr,
6920         uint64 iaRate
6921     ) 
6922         internal
6923         checkPause
6924     {
6925         uint amountToSell;
6926         uint totalRiskBal = pd.getLastVfull();
6927         uint intermediaryEth;
6928         uint ethVol = pd.ethVolumeLimit();
6929 
6930         totalRiskBal = (totalRiskBal.mul(100000)).div(DECIMAL1E18);
6931         Exchange exchange;
6932         if (totalRiskBal > 0) {
6933             amountToSell = ((totalRiskBal.mul(2).mul(
6934                 iaRate)).mul(pd.variationPercX100())).div(100 * 100 * 100000);
6935             amountToSell = (amountToSell.mul(
6936                 10**uint(pd.getInvestmentAssetDecimals(iaCurr)))).div(100); // amount of asset to sell
6937 
6938             if (iaCurr != "ETH" && _checkTradeConditions(iaCurr, iaRate, totalRiskBal)) { 
6939                 exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(iaCurr)));
6940                 intermediaryEth = exchange.getTokenToEthInputPrice(amountToSell);
6941                 if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
6942                     intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
6943                     amountToSell = (exchange.getEthToTokenInputPrice(intermediaryEth).mul(995)).div(1000);
6944                 }
6945                 IERC20 erc20;
6946                 erc20 = IERC20(pd.getCurrencyAssetAddress(iaCurr));
6947                 erc20.approve(address(exchange), amountToSell);
6948                 exchange.tokenToEthSwapInput(amountToSell, (exchange.getTokenToEthInputPrice(
6949                     amountToSell).mul(995)).div(1000), pd.uniswapDeadline().add(now));
6950             } else if (iaCurr == "ETH" && _checkTradeConditions(iaCurr, iaRate, totalRiskBal)) {
6951 
6952                 _transferInvestmentAsset(iaCurr, ms.getLatestAddress("P1"), amountToSell);
6953             }
6954             emit Rebalancing(iaCurr, amountToSell); 
6955         }
6956     }
6957 
6958     /**
6959      * @dev Checks whether trading is required for a  
6960      * given investment asset at a given exchange rate.
6961      */ 
6962     function _checkTradeConditions(
6963         bytes4 curr,
6964         uint64 iaRate,
6965         uint totalRiskBal
6966     )
6967         internal
6968         view
6969         returns(bool check)
6970     {
6971         if (iaRate > 0) {
6972             uint iaBalance =  _getInvestmentAssetBalance(curr).div(DECIMAL1E18);
6973             if (iaBalance > 0 && totalRiskBal > 0) {
6974                 uint iaMax;
6975                 uint iaMin;
6976                 uint checkNumber;
6977                 uint z;
6978                 (iaMin, iaMax) = pd.getInvestmentAssetHoldingPerc(curr);
6979                 z = pd.variationPercX100();
6980                 checkNumber = (iaBalance.mul(100 * 100000)).div(totalRiskBal.mul(iaRate));
6981                 if ((checkNumber > ((totalRiskBal.mul(iaMax.add(z))).mul(100000)).div(100)) ||
6982                     (checkNumber < ((totalRiskBal.mul(iaMin.sub(z))).mul(100000)).div(100)))
6983                     check = true; //eligibleIA
6984             }
6985         }
6986     }    
6987 
6988     /** 
6989      * @dev Gets the investment asset rank.
6990      */ 
6991     function _getIARank(
6992         bytes4 curr,
6993         uint64 rateX100,
6994         uint totalRiskPoolBalance
6995     ) 
6996         internal
6997         view
6998         returns (int rhsh, int rhsl) //internal function
6999     {
7000 
7001         uint currentIAmaxHolding;
7002         uint currentIAminHolding;
7003         uint iaBalance = _getInvestmentAssetBalance(curr);
7004         (currentIAminHolding, currentIAmaxHolding) = pd.getInvestmentAssetHoldingPerc(curr);
7005         
7006         if (rateX100 > 0) {
7007             uint rhsf;
7008             rhsf = (iaBalance.mul(1000000)).div(totalRiskPoolBalance.mul(rateX100));
7009             rhsh = int(rhsf - currentIAmaxHolding);
7010             rhsl = int(rhsf - currentIAminHolding);
7011         }
7012     }
7013 
7014     /** 
7015      * @dev Calculates the investment asset rank.
7016      */  
7017     function _calculateIARank(
7018         bytes4[] memory curr,
7019         uint64[] memory rate
7020     )
7021         internal
7022         view
7023         returns(
7024             bytes4 maxCurr,
7025             uint64 maxRate,
7026             bytes4 minCurr,
7027             uint64 minRate
7028         )  
7029     {
7030         int max = 0;
7031         int min = -1;
7032         int rhsh;
7033         int rhsl;
7034         uint totalRiskPoolBalance;
7035         (totalRiskPoolBalance, ) = m1.calVtpAndMCRtp();
7036         uint len = curr.length;
7037         for (uint i = 0; i < len; i++) {
7038             rhsl = 0;
7039             rhsh = 0;
7040             if (pd.getInvestmentAssetStatus(curr[i])) {
7041                 (rhsh, rhsl) = _getIARank(curr[i], rate[i], totalRiskPoolBalance);
7042                 if (rhsh > max || i == 0) {
7043                     max = rhsh;
7044                     maxCurr = curr[i];
7045                     maxRate = rate[i];
7046                 }
7047                 if (rhsl < min || rhsl == 0 || i == 0) {
7048                     min = rhsl;
7049                     minCurr = curr[i];
7050                     minRate = rate[i];
7051                 }
7052             }
7053         }
7054     }
7055 
7056     /**
7057      * @dev to get balance of an investment asset 
7058      * @param _curr is the investment asset in concern
7059      * @return the balance
7060      */
7061     function _getInvestmentAssetBalance(bytes4 _curr) internal view returns (uint balance) {
7062         if (_curr == "ETH") {
7063             balance = address(this).balance;
7064         } else {
7065             IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
7066             balance = erc20.balanceOf(address(this));
7067         }
7068     }
7069 
7070     /**
7071      * @dev Creates Excess liquidity trading order for a given currency and a given balance.
7072      */  
7073     function _internalExcessLiquiditySwap(bytes4 _curr, uint _baseMin, uint _varMin, uint _caBalance) internal {
7074         // require(ms.isInternal(msg.sender) || md.isnotarise(msg.sender));
7075         bytes4 minIACurr;
7076         // uint amount;
7077         
7078         (, , minIACurr, ) = pd.getIARankDetailsByDate(pd.getLastDate());
7079         if (_curr == minIACurr) {
7080             // amount = _caBalance.sub(((_baseMin.add(_varMin)).mul(3)).div(2)); //*10**18;
7081             p1.transferCurrencyAsset(_curr, _caBalance.sub(((_baseMin.add(_varMin)).mul(3)).div(2)));
7082         } else {
7083             p1.triggerExternalLiquidityTrade();
7084         }
7085     }
7086 
7087     /** 
7088      * @dev insufficient liquidity swap  
7089      * for a given currency and a given balance.
7090      */ 
7091     function _internalInsufficientLiquiditySwap(bytes4 _curr, uint _baseMin, uint _varMin, uint _caBalance) internal {
7092         
7093         bytes4 maxIACurr;
7094         uint amount;
7095         
7096         (maxIACurr, , , ) = pd.getIARankDetailsByDate(pd.getLastDate());
7097         
7098         if (_curr == maxIACurr) {
7099             amount = (((_baseMin.add(_varMin)).mul(3)).div(2)).sub(_caBalance);
7100             _transferInvestmentAsset(_curr, ms.getLatestAddress("P1"), amount);
7101         } else {
7102             IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(maxIACurr));
7103             if ((maxIACurr == "ETH" && address(this).balance > 0) || 
7104             (maxIACurr != "ETH" && erc20.balanceOf(address(this)) > 0))
7105                 p1.triggerExternalLiquidityTrade();
7106             
7107         }
7108     }
7109 
7110     /**
7111      * @dev Creates External excess liquidity trading  
7112      * order for a given currency and a given balance.
7113      * @param curr Currency Asset to Sell
7114      * @param minIACurr Investment Asset to Buy  
7115      * @param amount Amount of Currency Asset to Sell
7116      */  
7117     function _externalExcessLiquiditySwap(
7118         bytes4 curr,
7119         bytes4 minIACurr,
7120         uint256 amount
7121     )
7122         internal
7123         returns (bool trigger)
7124     {
7125         uint intermediaryEth;
7126         Exchange exchange;
7127         IERC20 erc20;
7128         uint ethVol = pd.ethVolumeLimit();
7129         if (curr == minIACurr) {
7130             p1.transferCurrencyAsset(curr, amount);
7131         } else if (curr == "ETH" && minIACurr != "ETH") {
7132             
7133             exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(minIACurr)));
7134             if (amount > (address(exchange).balance.mul(ethVol)).div(100)) { // 4% ETH volume limit 
7135                 amount = (address(exchange).balance.mul(ethVol)).div(100);
7136                 trigger = true;
7137             }
7138             p1.transferCurrencyAsset(curr, amount);
7139             exchange.ethToTokenSwapInput.value(amount)
7140             (exchange.getEthToTokenInputPrice(amount).mul(995).div(1000), pd.uniswapDeadline().add(now));    
7141         } else if (curr != "ETH" && minIACurr == "ETH") {
7142             exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7143             erc20 = IERC20(pd.getCurrencyAssetAddress(curr));
7144             intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7145 
7146             if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
7147                 intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
7148                 amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7149                 intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7150                 trigger = true;
7151             }
7152             p1.transferCurrencyAsset(curr, amount);
7153             // erc20.decreaseAllowance(address(exchange), erc20.allowance(address(this), address(exchange)));
7154             erc20.approve(address(exchange), amount);
7155             
7156             exchange.tokenToEthSwapInput(amount, (
7157                 intermediaryEth.mul(995)).div(1000), pd.uniswapDeadline().add(now));   
7158         } else {
7159             
7160             exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7161             intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7162 
7163             if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
7164                 intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
7165                 amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7166                 trigger = true;
7167             }
7168             
7169             Exchange tmp = Exchange(factory.getExchange(
7170                 pd.getInvestmentAssetAddress(minIACurr))); // minIACurr exchange
7171 
7172             if (intermediaryEth > address(tmp).balance.mul(ethVol).div(100)) { 
7173                 intermediaryEth = address(tmp).balance.mul(ethVol).div(100);
7174                 amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7175                 trigger = true;   
7176             }
7177             p1.transferCurrencyAsset(curr, amount);
7178             erc20 = IERC20(pd.getCurrencyAssetAddress(curr));
7179             erc20.approve(address(exchange), amount);
7180             
7181             exchange.tokenToTokenSwapInput(amount, (tmp.getEthToTokenInputPrice(
7182                 intermediaryEth).mul(995)).div(1000), (intermediaryEth.mul(995)).div(1000), 
7183                     pd.uniswapDeadline().add(now), pd.getInvestmentAssetAddress(minIACurr));
7184         }
7185     }
7186 
7187     /** 
7188      * @dev insufficient liquidity swap  
7189      * for a given currency and a given balance.
7190      * @param curr Currency Asset to buy
7191      * @param maxIACurr Investment Asset to sell
7192      * @param amount Amount of Investment Asset to sell
7193      */ 
7194     function _externalInsufficientLiquiditySwap(
7195         bytes4 curr,
7196         bytes4 maxIACurr,
7197         uint256 amount
7198     ) 
7199         internal
7200         returns (bool trigger)
7201     {   
7202 
7203         Exchange exchange;
7204         IERC20 erc20;
7205         uint intermediaryEth;
7206         // uint ethVol = pd.ethVolumeLimit();
7207         if (curr == maxIACurr) {
7208             _transferInvestmentAsset(curr, ms.getLatestAddress("P1"), amount);
7209         } else if (curr == "ETH" && maxIACurr != "ETH") { 
7210             exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(maxIACurr)));
7211             intermediaryEth = exchange.getEthToTokenInputPrice(amount);
7212 
7213 
7214             if (amount > (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100)) { 
7215                 amount = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7216                 // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7217                 intermediaryEth = exchange.getEthToTokenInputPrice(amount);
7218                 trigger = true;
7219             }
7220             
7221             erc20 = IERC20(pd.getCurrencyAssetAddress(maxIACurr));
7222             if (intermediaryEth > erc20.balanceOf(address(this))) {
7223                 intermediaryEth = erc20.balanceOf(address(this));
7224             }
7225             // erc20.decreaseAllowance(address(exchange), erc20.allowance(address(this), address(exchange)));
7226             erc20.approve(address(exchange), intermediaryEth);
7227             exchange.tokenToEthTransferInput(intermediaryEth, (
7228                 exchange.getTokenToEthInputPrice(intermediaryEth).mul(995)).div(1000), 
7229                 pd.uniswapDeadline().add(now), address(p1)); 
7230 
7231         } else if (curr != "ETH" && maxIACurr == "ETH") {
7232             exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7233             intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7234             if (intermediaryEth > address(this).balance)
7235                 intermediaryEth = address(this).balance;
7236             if (intermediaryEth > (address(exchange).balance.mul
7237             (pd.ethVolumeLimit())).div(100)) { // 4% ETH volume limit 
7238                 intermediaryEth = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7239                 trigger = true;
7240             }
7241             exchange.ethToTokenTransferInput.value(intermediaryEth)((exchange.getEthToTokenInputPrice(
7242                 intermediaryEth).mul(995)).div(1000), pd.uniswapDeadline().add(now), address(p1));   
7243         } else {
7244             address currAdd = pd.getCurrencyAssetAddress(curr);
7245             exchange = Exchange(factory.getExchange(currAdd));
7246             intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7247             if (intermediaryEth > (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100)) { 
7248                 intermediaryEth = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7249                 trigger = true;
7250             }
7251             Exchange tmp = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(maxIACurr)));
7252 
7253             if (intermediaryEth > address(tmp).balance.mul(pd.ethVolumeLimit()).div(100)) { 
7254                 intermediaryEth = address(tmp).balance.mul(pd.ethVolumeLimit()).div(100);
7255                 // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7256                 trigger = true;
7257             }
7258 
7259             uint maxIAToSell = tmp.getEthToTokenInputPrice(intermediaryEth);
7260 
7261             erc20 = IERC20(pd.getInvestmentAssetAddress(maxIACurr));
7262             uint maxIABal = erc20.balanceOf(address(this));
7263             if (maxIAToSell > maxIABal) {
7264                 maxIAToSell = maxIABal;
7265                 intermediaryEth = tmp.getTokenToEthInputPrice(maxIAToSell);
7266                 // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7267             }
7268             amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7269             erc20.approve(address(tmp), maxIAToSell);
7270             tmp.tokenToTokenTransferInput(maxIAToSell, (
7271                 amount.mul(995)).div(1000), (
7272                     intermediaryEth), pd.uniswapDeadline().add(now), address(p1), currAdd);
7273         }
7274     }
7275 
7276     /** 
7277      * @dev Transfers ERC20 investment asset from this Pool to another Pool.
7278      */ 
7279     function _upgradeInvestmentPool(
7280         bytes4 _curr,
7281         address _newPoolAddress
7282     ) 
7283         internal
7284     {
7285         IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
7286         if (erc20.balanceOf(address(this)) > 0)
7287             require(erc20.transfer(_newPoolAddress, erc20.balanceOf(address(this))));
7288     }
7289 }
7290 
7291 /* Copyright (C) 2017 NexusMutual.io
7292 
7293   This program is free software: you can redistribute it and/or modify
7294     it under the terms of the GNU General Public License as published by
7295     the Free Software Foundation, either version 3 of the License, or
7296     (at your option) any later version.
7297 
7298   This program is distributed in the hope that it will be useful,
7299     but WITHOUT ANY WARRANTY; without even the implied warranty of
7300     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
7301     GNU General Public License for more details.
7302 
7303   You should have received a copy of the GNU General Public License
7304     along with this program.  If not, see http://www.gnu.org/licenses/ */
7305 contract Pool1 is usingOraclize, Iupgradable {
7306     using SafeMath for uint;
7307 
7308     Quotation internal q2;
7309     NXMToken internal tk;
7310     TokenController internal tc;
7311     TokenFunctions internal tf;
7312     Pool2 internal p2;
7313     PoolData internal pd;
7314     MCR internal m1;
7315     Claims public c1;
7316     TokenData internal td;
7317     bool internal locked;
7318 
7319     uint internal constant DECIMAL1E18 = uint(10) ** 18;
7320     // uint internal constant PRICE_STEP = uint(1000) * DECIMAL1E18;
7321 
7322     event Apiresult(address indexed sender, string msg, bytes32 myid);
7323     event Payout(address indexed to, uint coverId, uint tokens);
7324 
7325     modifier noReentrancy() {
7326         require(!locked, "Reentrant call.");
7327         locked = true;
7328         _;
7329         locked = false;
7330     }
7331 
7332     function () external payable {} //solhint-disable-line
7333 
7334     /**
7335      * @dev Pays out the sum assured in case a claim is accepted
7336      * @param coverid Cover Id.
7337      * @param claimid Claim Id.
7338      * @return succ true if payout is successful, false otherwise. 
7339      */ 
7340     function sendClaimPayout(
7341         uint coverid,
7342         uint claimid,
7343         uint sumAssured,
7344         address payable coverHolder,
7345         bytes4 coverCurr
7346     )
7347         external
7348         onlyInternal
7349         noReentrancy
7350         returns(bool succ)
7351     {
7352         
7353         uint sa = sumAssured.div(DECIMAL1E18);
7354         bool check;
7355         IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
7356 
7357         //Payout
7358         if (coverCurr == "ETH" && address(this).balance >= sumAssured) {
7359             // check = _transferCurrencyAsset(coverCurr, coverHolder, sumAssured);
7360             coverHolder.transfer(sumAssured);
7361             check = true;
7362         } else if (coverCurr == "DAI" && erc20.balanceOf(address(this)) >= sumAssured) {
7363             erc20.transfer(coverHolder, sumAssured);
7364             check = true;
7365         }
7366         
7367         if (check == true) {
7368             q2.removeSAFromCSA(coverid, sa);
7369             pd.changeCurrencyAssetVarMin(coverCurr, 
7370                 pd.getCurrencyAssetVarMin(coverCurr).sub(sumAssured));
7371             emit Payout(coverHolder, coverid, sumAssured);
7372             succ = true;
7373         } else {
7374             c1.setClaimStatus(claimid, 12);
7375         }
7376         _triggerExternalLiquidityTrade();
7377         // p2.internalLiquiditySwap(coverCurr);
7378 
7379         tf.burnStakerLockedToken(coverid, coverCurr, sumAssured);
7380     }
7381 
7382     /**
7383      * @dev to trigger external liquidity trade
7384      */
7385     function triggerExternalLiquidityTrade() external onlyInternal {
7386         _triggerExternalLiquidityTrade();
7387     }
7388 
7389     ///@dev Oraclize call to close emergency pause.
7390     function closeEmergencyPause(uint time) external onlyInternal {
7391         bytes32 myid = _oraclizeQuery(4, time, "URL", "", 300000);
7392         _saveApiDetails(myid, "EP", 0);
7393     }
7394 
7395     /// @dev Calls the Oraclize Query to close a given Claim after a given period of time.
7396     /// @param id Claim Id to be closed
7397     /// @param time Time (in seconds) after which Claims assessment voting needs to be closed
7398     function closeClaimsOraclise(uint id, uint time) external onlyInternal {
7399         bytes32 myid = _oraclizeQuery(4, time, "URL", "", 3000000);
7400         _saveApiDetails(myid, "CLA", id);
7401     }
7402 
7403     /// @dev Calls Oraclize Query to expire a given Cover after a given period of time.
7404     /// @param id Quote Id to be expired
7405     /// @param time Time (in seconds) after which the cover should be expired
7406     function closeCoverOraclise(uint id, uint64 time) external onlyInternal {
7407         bytes32 myid = _oraclizeQuery(4, time, "URL", strConcat(
7408             "http://a1.nexusmutual.io/api/Claims/closeClaim_hash/", uint2str(id)), 1000000);
7409         _saveApiDetails(myid, "COV", id);
7410     }
7411 
7412     /// @dev Calls the Oraclize Query to initiate MCR calculation.
7413     /// @param time Time (in milliseconds) after which the next MCR calculation should be initiated
7414     function mcrOraclise(uint time) external onlyInternal {
7415         bytes32 myid = _oraclizeQuery(3, time, "URL", "https://api.nexusmutual.io/postMCR/M1", 0);
7416         _saveApiDetails(myid, "MCR", 0);
7417     }
7418 
7419     /// @dev Calls the Oraclize Query in case MCR calculation fails.
7420     /// @param time Time (in seconds) after which the next MCR calculation should be initiated
7421     function mcrOracliseFail(uint id, uint time) external onlyInternal {
7422         bytes32 myid = _oraclizeQuery(4, time, "URL", "", 1000000);
7423         _saveApiDetails(myid, "MCRF", id);
7424     }
7425 
7426     /// @dev Oraclize call to update investment asset rates.
7427     function saveIADetailsOracalise(uint time) external onlyInternal {
7428         bytes32 myid = _oraclizeQuery(3, time, "URL", "https://api.nexusmutual.io/saveIADetails/M1", 0);
7429         _saveApiDetails(myid, "IARB", 0);
7430     }
7431     
7432     /**
7433      * @dev Transfers all assest (i.e ETH balance, Currency Assest) from old Pool to new Pool
7434      * @param newPoolAddress Address of the new Pool
7435      */
7436     function upgradeCapitalPool(address payable newPoolAddress) external noReentrancy onlyInternal {
7437         for (uint64 i = 1; i < pd.getAllCurrenciesLen(); i++) {
7438             bytes4 caName = pd.getCurrenciesByIndex(i);
7439             _upgradeCapitalPool(caName, newPoolAddress);
7440         }
7441         if (address(this).balance > 0) {
7442             Pool1 newP1 = Pool1(newPoolAddress);
7443             newP1.sendEther.value(address(this).balance)();
7444         }
7445     }
7446 
7447     /**
7448      * @dev Iupgradable Interface to update dependent contract address
7449      */
7450     function changeDependentContractAddress() public {
7451         m1 = MCR(ms.getLatestAddress("MC"));
7452         tk = NXMToken(ms.tokenAddress());
7453         tf = TokenFunctions(ms.getLatestAddress("TF"));
7454         tc = TokenController(ms.getLatestAddress("TC"));
7455         pd = PoolData(ms.getLatestAddress("PD"));
7456         q2 = Quotation(ms.getLatestAddress("QT"));
7457         p2 = Pool2(ms.getLatestAddress("P2"));
7458         c1 = Claims(ms.getLatestAddress("CL"));
7459         td = TokenData(ms.getLatestAddress("TD"));
7460     }
7461 
7462     function sendEther() public payable {
7463         
7464     }
7465 
7466     /**
7467      * @dev transfers currency asset to an address
7468      * @param curr is the currency of currency asset to transfer
7469      * @param amount is amount of currency asset to transfer
7470      * @return boolean to represent success or failure
7471      */
7472     function transferCurrencyAsset(
7473         bytes4 curr,
7474         uint amount
7475     )
7476         public
7477         onlyInternal
7478         noReentrancy
7479         returns(bool)
7480     {
7481     
7482         return _transferCurrencyAsset(curr, amount);
7483     } 
7484 
7485     /// @dev Handles callback of external oracle query.
7486     function __callback(bytes32 myid, string memory result) public {
7487         result; //silence compiler warning
7488         // owner will be removed from production build
7489         ms.delegateCallBack(myid);
7490     }
7491 
7492     /// @dev Enables user to purchase cover with funding in ETH.
7493     /// @param smartCAdd Smart Contract Address
7494     function makeCoverBegin(
7495         address smartCAdd,
7496         bytes4 coverCurr,
7497         uint[] memory coverDetails,
7498         uint16 coverPeriod,
7499         uint8 _v,
7500         bytes32 _r,
7501         bytes32 _s
7502     )
7503         public
7504         isMember
7505         checkPause
7506         payable
7507     {
7508         require(msg.value == coverDetails[1]);
7509         q2.verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
7510     }
7511 
7512     /**
7513      * @dev Enables user to purchase cover via currency asset eg DAI
7514      */ 
7515     function makeCoverUsingCA(
7516         address smartCAdd,
7517         bytes4 coverCurr,
7518         uint[] memory coverDetails,
7519         uint16 coverPeriod,
7520         uint8 _v,
7521         bytes32 _r,
7522         bytes32 _s
7523     ) 
7524         public
7525         isMember
7526         checkPause
7527     {
7528         IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
7529         require(erc20.transferFrom(msg.sender, address(this), coverDetails[1]), "Transfer failed");
7530         q2.verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
7531     }
7532 
7533     /// @dev Enables user to purchase NXM at the current token price.
7534     function buyToken() public payable isMember checkPause returns(bool success) {
7535         require(msg.value > 0);
7536         uint tokenPurchased = _getToken(address(this).balance, msg.value);
7537         tc.mint(msg.sender, tokenPurchased);
7538         success = true;
7539     }
7540 
7541     /// @dev Sends a given amount of Ether to a given address.
7542     /// @param amount amount (in wei) to send.
7543     /// @param _add Receiver's address.
7544     /// @return succ True if transfer is a success, otherwise False.
7545     function transferEther(uint amount, address payable _add) public noReentrancy checkPause returns(bool succ) {
7546         require(ms.checkIsAuthToGoverned(msg.sender), "Not authorized to Govern");
7547         succ = _add.send(amount);
7548     }
7549 
7550     /**
7551      * @dev Allows selling of NXM for ether.
7552      * Seller first needs to give this contract allowance to
7553      * transfer/burn tokens in the NXMToken contract
7554      * @param  _amount Amount of NXM to sell
7555      * @return success returns true on successfull sale
7556      */
7557     function sellNXMTokens(uint _amount) public isMember noReentrancy checkPause returns(bool success) {
7558         require(tk.balanceOf(msg.sender) >= _amount, "Not enough balance");
7559         require(!tf.isLockedForMemberVote(msg.sender), "Member voted");
7560         require(_amount <= m1.getMaxSellTokens(), "exceeds maximum token sell limit");
7561         uint sellingPrice = _getWei(_amount);
7562         tc.burnFrom(msg.sender, _amount);
7563         msg.sender.transfer(sellingPrice);
7564         success = true;
7565     }
7566 
7567     /**
7568      * @dev gives the investment asset balance
7569      * @return investment asset balance
7570      */
7571     function getInvestmentAssetBalance() public view returns (uint balance) {
7572         IERC20 erc20;
7573         uint currTokens;
7574         for (uint i = 1; i < pd.getInvestmentCurrencyLen(); i++) {
7575             bytes4 currency = pd.getInvestmentCurrencyByIndex(i);
7576             erc20 = IERC20(pd.getInvestmentAssetAddress(currency));
7577             currTokens = erc20.balanceOf(address(p2));
7578             if (pd.getIAAvgRate(currency) > 0)
7579                 balance = balance.add((currTokens.mul(100)).div(pd.getIAAvgRate(currency)));
7580         }
7581 
7582         balance = balance.add(address(p2).balance);
7583     }
7584 
7585     /**
7586      * @dev Returns the amount of wei a seller will get for selling NXM
7587      * @param amount Amount of NXM to sell
7588      * @return weiToPay Amount of wei the seller will get
7589      */
7590     function getWei(uint amount) public view returns(uint weiToPay) {
7591         return _getWei(amount);
7592     }
7593 
7594     /**
7595      * @dev Returns the amount of token a buyer will get for corresponding wei
7596      * @param weiPaid Amount of wei 
7597      * @return tokenToGet Amount of tokens the buyer will get
7598      */
7599     function getToken(uint weiPaid) public view returns(uint tokenToGet) {
7600         return _getToken((address(this).balance).add(weiPaid), weiPaid);
7601     }
7602 
7603     /**
7604      * @dev to trigger external liquidity trade
7605      */
7606     function _triggerExternalLiquidityTrade() internal {
7607         if (now > pd.lastLiquidityTradeTrigger().add(pd.liquidityTradeCallbackTime())) {
7608             pd.setLastLiquidityTradeTrigger();
7609             bytes32 myid = _oraclizeQuery(4, pd.liquidityTradeCallbackTime(), "URL", "", 300000);
7610             _saveApiDetails(myid, "ULT", 0);
7611         }
7612     }
7613 
7614     /**
7615      * @dev Returns the amount of wei a seller will get for selling NXM
7616      * @param _amount Amount of NXM to sell
7617      * @return weiToPay Amount of wei the seller will get
7618      */
7619     function _getWei(uint _amount) internal view returns(uint weiToPay) {
7620         uint tokenPrice;
7621         uint weiPaid;
7622         uint tokenSupply = tk.totalSupply();
7623         uint vtp;
7624         uint mcrFullperc;
7625         uint vFull;
7626         uint mcrtp;
7627         (mcrFullperc, , vFull, ) = pd.getLastMCR();
7628         (vtp, ) = m1.calVtpAndMCRtp();
7629 
7630         while (_amount > 0) {
7631             mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
7632             tokenPrice = m1.calculateStepTokenPrice("ETH", mcrtp);
7633             tokenPrice = (tokenPrice.mul(975)).div(1000); //97.5%
7634             if (_amount <= td.priceStep().mul(DECIMAL1E18)) {
7635                 weiToPay = weiToPay.add((tokenPrice.mul(_amount)).div(DECIMAL1E18));
7636                 break;
7637             } else {
7638                 _amount = _amount.sub(td.priceStep().mul(DECIMAL1E18));
7639                 tokenSupply = tokenSupply.sub(td.priceStep().mul(DECIMAL1E18));
7640                 weiPaid = (tokenPrice.mul(td.priceStep().mul(DECIMAL1E18))).div(DECIMAL1E18);
7641                 vtp = vtp.sub(weiPaid);
7642                 weiToPay = weiToPay.add(weiPaid);
7643             }
7644         }
7645     }
7646 
7647     /**
7648      * @dev gives the token
7649      * @param _poolBalance is the pool balance
7650      * @param _weiPaid is the amount paid in wei
7651      * @return the token to get
7652      */
7653     function _getToken(uint _poolBalance, uint _weiPaid) internal view returns(uint tokenToGet) {
7654         uint tokenPrice;
7655         uint superWeiLeft = (_weiPaid).mul(DECIMAL1E18);
7656         uint tempTokens;
7657         uint superWeiSpent;
7658         uint tokenSupply = tk.totalSupply();
7659         uint vtp;
7660         uint mcrFullperc;   
7661         uint vFull;
7662         uint mcrtp;
7663         (mcrFullperc, , vFull, ) = pd.getLastMCR();
7664         (vtp, ) = m1.calculateVtpAndMCRtp((_poolBalance).sub(_weiPaid));
7665 
7666         require(m1.calculateTokenPrice("ETH") > 0, "Token price can not be zero");
7667         while (superWeiLeft > 0) {
7668             mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
7669             tokenPrice = m1.calculateStepTokenPrice("ETH", mcrtp);            
7670             tempTokens = superWeiLeft.div(tokenPrice);
7671             if (tempTokens <= td.priceStep().mul(DECIMAL1E18)) {
7672                 tokenToGet = tokenToGet.add(tempTokens);
7673                 break;
7674             } else {
7675                 tokenToGet = tokenToGet.add(td.priceStep().mul(DECIMAL1E18));
7676                 tokenSupply = tokenSupply.add(td.priceStep().mul(DECIMAL1E18));
7677                 superWeiSpent = td.priceStep().mul(DECIMAL1E18).mul(tokenPrice);
7678                 superWeiLeft = superWeiLeft.sub(superWeiSpent);
7679                 vtp = vtp.add((td.priceStep().mul(DECIMAL1E18).mul(tokenPrice)).div(DECIMAL1E18));
7680             }
7681         }
7682     }
7683 
7684     /** 
7685      * @dev Save the details of the Oraclize API.
7686      * @param myid Id return by the oraclize query.
7687      * @param _typeof type of the query for which oraclize call is made.
7688      * @param id ID of the proposal, quote, cover etc. for which oraclize call is made.
7689      */ 
7690     function _saveApiDetails(bytes32 myid, bytes4 _typeof, uint id) internal {
7691         pd.saveApiDetails(myid, _typeof, id);
7692         pd.addInAllApiCall(myid);
7693     }
7694 
7695     /**
7696      * @dev transfers currency asset
7697      * @param _curr is currency of asset to transfer
7698      * @param _amount is the amount to be transferred
7699      * @return boolean representing the success of transfer
7700      */
7701     function _transferCurrencyAsset(bytes4 _curr, uint _amount) internal returns(bool succ) {
7702         if (_curr == "ETH") {
7703             if (address(this).balance < _amount)
7704                 _amount = address(this).balance;
7705             p2.sendEther.value(_amount)();
7706             succ = true;
7707         } else {
7708             IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr)); //solhint-disable-line
7709             if (erc20.balanceOf(address(this)) < _amount) 
7710                 _amount = erc20.balanceOf(address(this));
7711             require(erc20.transfer(address(p2), _amount)); 
7712             succ = true;
7713             
7714         }
7715     } 
7716 
7717     /** 
7718      * @dev Transfers ERC20 Currency asset from this Pool to another Pool on upgrade.
7719      */ 
7720     function _upgradeCapitalPool(
7721         bytes4 _curr,
7722         address _newPoolAddress
7723     ) 
7724         internal
7725     {
7726         IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr));
7727         if (erc20.balanceOf(address(this)) > 0)
7728             require(erc20.transfer(_newPoolAddress, erc20.balanceOf(address(this))));
7729     }
7730 
7731     /**
7732      * @dev oraclize query
7733      * @param paramCount is number of paramters passed
7734      * @param timestamp is the current timestamp
7735      * @param datasource in concern
7736      * @param arg in concern
7737      * @param gasLimit required for query
7738      * @return id of oraclize query
7739      */
7740     function _oraclizeQuery(
7741         uint paramCount,
7742         uint timestamp,
7743         string memory datasource,
7744         string memory arg,
7745         uint gasLimit
7746     ) 
7747         internal
7748         returns (bytes32 id)
7749     {
7750         if (paramCount == 4) {
7751             id = oraclize_query(timestamp, datasource, arg, gasLimit);   
7752         } else if (paramCount == 3) {
7753             id = oraclize_query(timestamp, datasource, arg);   
7754         } else {
7755             id = oraclize_query(datasource, arg);
7756         }
7757     }
7758 }
7759 
7760 /* Copyright (C) 2017 NexusMutual.io
7761 
7762   This program is free software: you can redistribute it and/or modify
7763     it under the terms of the GNU General Public License as published by
7764     the Free Software Foundation, either version 3 of the License, or
7765     (at your option) any later version.
7766 
7767   This program is distributed in the hope that it will be useful,
7768     but WITHOUT ANY WARRANTY; without even the implied warranty of
7769     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
7770     GNU General Public License for more details.
7771 
7772   You should have received a copy of the GNU General Public License
7773     along with this program.  If not, see http://www.gnu.org/licenses/ */
7774 contract MCR is Iupgradable {
7775     using SafeMath for uint;
7776 
7777     Pool1 internal p1;
7778     PoolData internal pd;
7779     NXMToken internal tk;
7780     QuotationData internal qd;
7781     MemberRoles internal mr;
7782     TokenData internal td;
7783     ProposalCategory internal proposalCategory;
7784 
7785     uint private constant DECIMAL1E18 = uint(10) ** 18;
7786     uint private constant DECIMAL1E05 = uint(10) ** 5;
7787     uint private constant DECIMAL1E19 = uint(10) ** 19;
7788     uint private constant minCapFactor = uint(10) ** 21;
7789 
7790     uint public variableMincap;
7791     uint public dynamicMincapThresholdx100 = 13000;
7792     uint public dynamicMincapIncrementx100 = 100;
7793 
7794     event MCREvent(
7795         uint indexed date,
7796         uint blockNumber,
7797         bytes4[] allCurr,
7798         uint[] allCurrRates,
7799         uint mcrEtherx100,
7800         uint mcrPercx100,
7801         uint vFull
7802     );
7803 
7804     /** 
7805      * @dev Adds new MCR data.
7806      * @param mcrP  Minimum Capital Requirement in percentage.
7807      * @param vF Pool1 fund value in Ether used in the last full daily calculation of the Capital model.
7808      * @param onlyDate  Date(yyyymmdd) at which MCR details are getting added.
7809      */ 
7810     function addMCRData(
7811         uint mcrP,
7812         uint mcrE,
7813         uint vF,
7814         bytes4[] calldata curr,
7815         uint[] calldata _threeDayAvg,
7816         uint64 onlyDate
7817     )
7818         external
7819         checkPause
7820     {
7821         require(proposalCategory.constructorCheck());
7822         require(pd.isnotarise(msg.sender));
7823         if (mr.launched() && pd.capReached() != 1) {
7824             
7825             if (mcrP >= 10000)
7826                 pd.setCapReached(1);  
7827 
7828         }
7829         uint len = pd.getMCRDataLength();
7830         _addMCRData(len, onlyDate, curr, mcrE, mcrP, vF, _threeDayAvg);
7831     }
7832 
7833     /**
7834      * @dev Adds MCR Data for last failed attempt.
7835      */  
7836     function addLastMCRData(uint64 date) external checkPause  onlyInternal {
7837         uint64 lastdate = uint64(pd.getLastMCRDate());
7838         uint64 failedDate = uint64(date);
7839         if (failedDate >= lastdate) {
7840             uint mcrP;
7841             uint mcrE;
7842             uint vF;
7843             (mcrP, mcrE, vF, ) = pd.getLastMCR();
7844             uint len = pd.getAllCurrenciesLen();
7845             pd.pushMCRData(mcrP, mcrE, vF, date);
7846             for (uint j = 0; j < len; j++) {
7847                 bytes4 currName = pd.getCurrenciesByIndex(j);
7848                 pd.updateCAAvgRate(currName, pd.getCAAvgRate(currName));
7849             }
7850 
7851             emit MCREvent(date, block.number, new bytes4[](0), new uint[](0), mcrE, mcrP, vF);
7852             // Oraclize call for next MCR calculation
7853             _callOracliseForMCR();
7854         }
7855     }
7856 
7857     /**
7858      * @dev Iupgradable Interface to update dependent contract address
7859      */
7860     function changeDependentContractAddress() public onlyInternal {
7861         qd = QuotationData(ms.getLatestAddress("QD"));
7862         p1 = Pool1(ms.getLatestAddress("P1"));
7863         pd = PoolData(ms.getLatestAddress("PD"));
7864         tk = NXMToken(ms.tokenAddress());
7865         mr = MemberRoles(ms.getLatestAddress("MR"));
7866         td = TokenData(ms.getLatestAddress("TD"));
7867         proposalCategory = ProposalCategory(ms.getLatestAddress("PC"));
7868     }
7869 
7870     /** 
7871      * @dev Gets total sum assured(in ETH).
7872      * @return amount of sum assured
7873      */  
7874     function getAllSumAssurance() public view returns(uint amount) {
7875         uint len = pd.getAllCurrenciesLen();
7876         for (uint i = 0; i < len; i++) {
7877             bytes4 currName = pd.getCurrenciesByIndex(i);
7878             if (currName == "ETH") {
7879                 amount = amount.add(qd.getTotalSumAssured(currName));
7880             } else {
7881                 if (pd.getCAAvgRate(currName) > 0)
7882                     amount = amount.add((qd.getTotalSumAssured(currName).mul(100)).div(pd.getCAAvgRate(currName)));
7883             }
7884         }
7885     }
7886 
7887     /**
7888      * @dev Calculates V(Tp) and MCR%(Tp), i.e, Pool Fund Value in Ether 
7889      * and MCR% used in the Token Price Calculation.
7890      * @return vtp  Pool Fund Value in Ether used for the Token Price Model
7891      * @return mcrtp MCR% used in the Token Price Model. 
7892      */ 
7893     function _calVtpAndMCRtp(uint poolBalance) public view returns(uint vtp, uint mcrtp) {
7894         vtp = 0;
7895         IERC20 erc20;
7896         uint currTokens = 0;
7897         uint i;
7898         for (i = 1; i < pd.getAllCurrenciesLen(); i++) {
7899             bytes4 currency = pd.getCurrenciesByIndex(i);
7900             erc20 = IERC20(pd.getCurrencyAssetAddress(currency));
7901             currTokens = erc20.balanceOf(address(p1));
7902             if (pd.getCAAvgRate(currency) > 0)
7903                 vtp = vtp.add((currTokens.mul(100)).div(pd.getCAAvgRate(currency)));
7904         }
7905 
7906         vtp = vtp.add(poolBalance).add(p1.getInvestmentAssetBalance());
7907         uint mcrFullperc;
7908         uint vFull;
7909         (mcrFullperc, , vFull, ) = pd.getLastMCR();
7910         if (vFull > 0) {
7911             mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
7912         }
7913     }
7914 
7915     /**
7916      * @dev Calculates the Token Price of NXM in a given currency.
7917      * @param curr Currency name.
7918      
7919      */
7920     function calculateStepTokenPrice(
7921         bytes4 curr,
7922         uint mcrtp
7923     ) 
7924         public
7925         view
7926         onlyInternal
7927         returns(uint tokenPrice)
7928     {
7929         return _calculateTokenPrice(curr, mcrtp);
7930     }
7931 
7932     /**
7933      * @dev Calculates the Token Price of NXM in a given currency 
7934      * with provided token supply for dynamic token price calculation
7935      * @param curr Currency name.
7936      */ 
7937     function calculateTokenPrice (bytes4 curr) public view returns(uint tokenPrice) {
7938         uint mcrtp;
7939         (, mcrtp) = _calVtpAndMCRtp(address(p1).balance); 
7940         return _calculateTokenPrice(curr, mcrtp);
7941     }
7942     
7943     function calVtpAndMCRtp() public view returns(uint vtp, uint mcrtp) {
7944         return _calVtpAndMCRtp(address(p1).balance);
7945     }
7946 
7947     function calculateVtpAndMCRtp(uint poolBalance) public view returns(uint vtp, uint mcrtp) {
7948         return _calVtpAndMCRtp(poolBalance);
7949     }
7950 
7951     function getThresholdValues(uint vtp, uint vF, uint totalSA, uint minCap) public view returns(uint lowerThreshold, uint upperThreshold)
7952     {
7953         minCap = (minCap.mul(minCapFactor)).add(variableMincap);
7954         uint lower = 0;
7955         if (vtp >= vF) {
7956                 upperThreshold = vtp.mul(120).mul(100).div((minCap));     //Max Threshold = [MAX(Vtp, Vfull) x 120] / mcrMinCap
7957             } else {
7958                 upperThreshold = vF.mul(120).mul(100).div((minCap));
7959             }
7960 
7961             if (vtp > 0) {
7962                 lower = totalSA.mul(DECIMAL1E18).mul(pd.shockParameter()).div(100);
7963                 if(lower < minCap.mul(11).div(10))
7964                     lower = minCap.mul(11).div(10);
7965             }
7966             if (lower > 0) {                                       //Min Threshold = [Vtp / MAX(TotalActiveSA x ShockParameter, mcrMinCap x 1.1)] x 100
7967                 lowerThreshold = vtp.mul(100).mul(100).div(lower);
7968             }
7969     }
7970 
7971     /**
7972      * @dev Gets max numbers of tokens that can be sold at the moment.
7973      */ 
7974     function getMaxSellTokens() public view returns(uint maxTokens) {
7975         uint baseMin = pd.getCurrencyAssetBaseMin("ETH");
7976         uint maxTokensAccPoolBal;
7977         if (address(p1).balance > baseMin.mul(50).div(100)) {
7978             maxTokensAccPoolBal = address(p1).balance.sub(
7979             (baseMin.mul(50)).div(100));        
7980         }
7981         maxTokensAccPoolBal = (maxTokensAccPoolBal.mul(DECIMAL1E18)).div(
7982             (calculateTokenPrice("ETH").mul(975)).div(1000));
7983         uint lastMCRPerc = pd.getLastMCRPerc();
7984         if (lastMCRPerc > 10000)
7985             maxTokens = (((uint(lastMCRPerc).sub(10000)).mul(2000)).mul(DECIMAL1E18)).div(10000);
7986         if (maxTokens > maxTokensAccPoolBal)
7987             maxTokens = maxTokensAccPoolBal;     
7988     }
7989 
7990     /**
7991      * @dev Gets Uint Parameters of a code
7992      * @param code whose details we want
7993      * @return string value of the code
7994      * @return associated amount (time or perc or value) to the code
7995      */
7996     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
7997         codeVal = code;
7998         if (code == "DMCT") {
7999             val = dynamicMincapThresholdx100;
8000 
8001         } else if (code == "DMCI") {
8002 
8003             val = dynamicMincapIncrementx100;
8004 
8005         }
8006             
8007     }
8008 
8009     /**
8010      * @dev Updates Uint Parameters of a code
8011      * @param code whose details we want to update
8012      * @param val value to set
8013      */
8014     function updateUintParameters(bytes8 code, uint val) public {
8015         require(ms.checkIsAuthToGoverned(msg.sender));
8016         if (code == "DMCT") {
8017            dynamicMincapThresholdx100 = val;
8018 
8019         } else if (code == "DMCI") {
8020 
8021             dynamicMincapIncrementx100 = val;
8022 
8023         }
8024          else {
8025             revert("Invalid param code");
8026         }
8027             
8028     }
8029 
8030     /** 
8031      * @dev Calls oraclize query to calculate MCR details after 24 hours.
8032      */ 
8033     function _callOracliseForMCR() internal {
8034         p1.mcrOraclise(pd.mcrTime());
8035     }
8036 
8037     /**
8038      * @dev Calculates the Token Price of NXM in a given currency 
8039      * with provided token supply for dynamic token price calculation
8040      * @param _curr Currency name.  
8041      * @return tokenPrice Token price.
8042      */ 
8043     function _calculateTokenPrice(
8044         bytes4 _curr,
8045         uint mcrtp
8046     )
8047         internal
8048         view
8049         returns(uint tokenPrice)
8050     {
8051         uint getA;
8052         uint getC;
8053         uint getCAAvgRate;
8054         uint tokenExponentValue = td.tokenExponent();
8055         // uint max = (mcrtp.mul(mcrtp).mul(mcrtp).mul(mcrtp));
8056         uint max = mcrtp ** tokenExponentValue;
8057         uint dividingFactor = tokenExponentValue.mul(4); 
8058         (getA, getC, getCAAvgRate) = pd.getTokenPriceDetails(_curr);
8059         uint mcrEth = pd.getLastMCREther();
8060         getC = getC.mul(DECIMAL1E18);
8061         tokenPrice = (mcrEth.mul(DECIMAL1E18).mul(max).div(getC)).div(10 ** dividingFactor);
8062         tokenPrice = tokenPrice.add(getA.mul(DECIMAL1E18).div(DECIMAL1E05));
8063         tokenPrice = tokenPrice.mul(getCAAvgRate * 10); 
8064         tokenPrice = (tokenPrice).div(10**3);
8065     } 
8066     
8067     /**
8068      * @dev Adds MCR Data. Checks if MCR is within valid 
8069      * thresholds in order to rule out any incorrect calculations 
8070      */  
8071     function _addMCRData(
8072         uint len,
8073         uint64 newMCRDate,
8074         bytes4[] memory curr,
8075         uint mcrE,
8076         uint mcrP,
8077         uint vF,
8078         uint[] memory _threeDayAvg
8079     ) 
8080         internal
8081     {
8082         uint vtp = 0;
8083         uint lowerThreshold = 0;
8084         uint upperThreshold = 0;
8085         if (len > 1) {
8086             (vtp, ) = _calVtpAndMCRtp(address(p1).balance);
8087             (lowerThreshold, upperThreshold) = getThresholdValues(vtp, vF, getAllSumAssurance(), pd.minCap());
8088 
8089         }
8090         if(mcrP > dynamicMincapThresholdx100)
8091             variableMincap =  (variableMincap.mul(dynamicMincapIncrementx100.add(10000)).add(minCapFactor.mul(pd.minCap().mul(dynamicMincapIncrementx100)))).div(10000);
8092 
8093 
8094         // Explanation for above formula :- 
8095         // actual formula -> variableMinCap =  variableMinCap + (variableMinCap+minCap)*dynamicMincapIncrement/100
8096         // Implemented formula is simplified form of actual formula.
8097         // Let consider above formula as b = b + (a+b)*c/100
8098         // here, dynamicMincapIncrement is in x100 format. 
8099         // so b+(a+b)*cx100/10000 can be written as => (10000.b + b.cx100 + a.cx100)/10000.
8100         // It can further simplify to (b.(10000+cx100) + a.cx100)/10000.
8101         if (len == 1 || (mcrP) >= lowerThreshold 
8102             && (mcrP) <= upperThreshold) {
8103             vtp = pd.getLastMCRDate(); // due to stack to deep error,we are reusing already declared variable
8104             pd.pushMCRData(mcrP, mcrE, vF, newMCRDate);
8105             for (uint i = 0; i < curr.length; i++) {
8106                 pd.updateCAAvgRate(curr[i], _threeDayAvg[i]);
8107             }
8108             emit MCREvent(newMCRDate, block.number, curr, _threeDayAvg, mcrE, mcrP, vF);
8109             // Oraclize call for next MCR calculation
8110             if (vtp < newMCRDate) {
8111                 _callOracliseForMCR();
8112             }
8113         } else {
8114             p1.mcrOracliseFail(newMCRDate, pd.mcrFailTime());
8115         }
8116     }
8117 
8118 }
8119 
8120 /* Copyright (C) 2017 NexusMutual.io
8121 
8122   This program is free software: you can redistribute it and/or modify
8123     it under the terms of the GNU General Public License as published by
8124     the Free Software Foundation, either version 3 of the License, or
8125     (at your option) any later version.
8126 
8127   This program is distributed in the hope that it will be useful,
8128     but WITHOUT ANY WARRANTY; without even the implied warranty of
8129     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
8130     GNU General Public License for more details.
8131 
8132   You should have received a copy of the GNU General Public License
8133     along with this program.  If not, see http://www.gnu.org/licenses/ */
8134 contract Claims is Iupgradable {
8135     using SafeMath for uint;
8136 
8137     
8138     TokenFunctions internal tf;
8139     NXMToken internal tk;
8140     TokenController internal tc;
8141     ClaimsReward internal cr;
8142     Pool1 internal p1;
8143     ClaimsData internal cd;
8144     TokenData internal td;
8145     PoolData internal pd;
8146     Pool2 internal p2;
8147     QuotationData internal qd;
8148     MCR internal m1;
8149 
8150     uint private constant DECIMAL1E18 = uint(10) ** 18;
8151     
8152     /**
8153      * @dev Sets the status of claim using claim id.
8154      * @param claimId claim id.
8155      * @param stat status to be set.
8156      */ 
8157     function setClaimStatus(uint claimId, uint stat) external onlyInternal {
8158         _setClaimStatus(claimId, stat);
8159     }
8160 
8161     /**
8162      * @dev Gets claim details of claim id = pending claim start + given index
8163      */ 
8164     function getClaimFromNewStart(
8165         uint index
8166     )
8167         external 
8168         view 
8169         returns (
8170             uint coverId,
8171             uint claimId,
8172             int8 voteCA,
8173             int8 voteMV,
8174             uint statusnumber
8175         ) 
8176     {
8177         (coverId, claimId, voteCA, voteMV, statusnumber) = cd.getClaimFromNewStart(index, msg.sender);
8178         // status = rewardStatus[statusnumber].claimStatusDesc;
8179     }
8180 
8181     /**
8182      * @dev Gets details of a claim submitted by the calling user, at a given index
8183      */
8184     function getUserClaimByIndex(
8185         uint index
8186     )
8187         external
8188         view 
8189         returns(
8190             uint status,
8191             uint coverId,
8192             uint claimId
8193         )
8194     {
8195         uint statusno;
8196         (statusno, coverId, claimId) = cd.getUserClaimByIndex(index, msg.sender);
8197         status = statusno;
8198     }
8199 
8200     /**
8201      * @dev Gets details of a given claim id.
8202      * @param _claimId Claim Id.
8203      * @return status Current status of claim id
8204      * @return finalVerdict Decision made on the claim, 1 -> acceptance, -1 -> denial
8205      * @return claimOwner Address through which claim is submitted
8206      * @return coverId Coverid associated with the claim id
8207      */
8208     function getClaimbyIndex(uint _claimId) external view returns (
8209         uint claimId,
8210         uint status,
8211         int8 finalVerdict,
8212         address claimOwner,
8213         uint coverId
8214     )
8215     {
8216         uint stat;
8217         claimId = _claimId;
8218         (, coverId, finalVerdict, stat, , ) = cd.getClaim(_claimId);
8219         claimOwner = qd.getCoverMemberAddress(coverId);
8220         status = stat;
8221     }
8222 
8223     /**
8224      * @dev Calculates total amount that has been used to assess a claim.
8225      * Computaion:Adds acceptCA(tokens used for voting in favor of a claim)
8226      * denyCA(tokens used for voting against a claim) *  current token price.
8227      * @param claimId Claim Id.
8228      * @param member Member type 0 -> Claim Assessors, else members.
8229      * @return tokens Total Amount used in Claims assessment.
8230      */ 
8231     function getCATokens(uint claimId, uint member) external view returns(uint tokens) {
8232         uint coverId;
8233         (, coverId) = cd.getClaimCoverId(claimId);
8234         bytes4 curr = qd.getCurrencyOfCover(coverId);
8235         uint tokenx1e18 = m1.calculateTokenPrice(curr);
8236         uint accept;
8237         uint deny;
8238         if (member == 0) {
8239             (, accept, deny) = cd.getClaimsTokenCA(claimId);
8240         } else {
8241             (, accept, deny) = cd.getClaimsTokenMV(claimId);
8242         }
8243         tokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18); // amount (not in tokens)
8244     }
8245 
8246     /**
8247      * Iupgradable Interface to update dependent contract address
8248      */
8249     function changeDependentContractAddress() public onlyInternal {
8250         tk = NXMToken(ms.tokenAddress());
8251         td = TokenData(ms.getLatestAddress("TD"));
8252         tf = TokenFunctions(ms.getLatestAddress("TF"));
8253         tc = TokenController(ms.getLatestAddress("TC"));
8254         p1 = Pool1(ms.getLatestAddress("P1"));
8255         p2 = Pool2(ms.getLatestAddress("P2"));
8256         pd = PoolData(ms.getLatestAddress("PD"));
8257         cr = ClaimsReward(ms.getLatestAddress("CR"));
8258         cd = ClaimsData(ms.getLatestAddress("CD"));
8259         qd = QuotationData(ms.getLatestAddress("QD"));
8260         m1 = MCR(ms.getLatestAddress("MC"));
8261     }
8262 
8263     /**
8264      * @dev Updates the pending claim start variable,
8265      * the lowest claim id with a pending decision/payout.
8266      */ 
8267     function changePendingClaimStart() public onlyInternal {
8268 
8269         uint origstat;
8270         uint state12Count;
8271         uint pendingClaimStart = cd.pendingClaimStart();
8272         uint actualClaimLength = cd.actualClaimLength();
8273         for (uint i = pendingClaimStart; i < actualClaimLength; i++) {
8274             (, , , origstat, , state12Count) = cd.getClaim(i);
8275 
8276             if (origstat > 5 && ((origstat != 12) || (origstat == 12 && state12Count >= 60)))
8277                 cd.setpendingClaimStart(i);
8278             else
8279                 break;
8280         }
8281     }
8282 
8283     /**
8284      * @dev Submits a claim for a given cover note.
8285      * Adds claim to queue incase of emergency pause else directly submits the claim.
8286      * @param coverId Cover Id.
8287      */ 
8288     function submitClaim(uint coverId) public {
8289         address qadd = qd.getCoverMemberAddress(coverId);
8290         require(qadd == msg.sender);
8291         uint8 cStatus;
8292         (, cStatus, , , ) = qd.getCoverDetailsByCoverID2(coverId);
8293         require(cStatus != uint8(QuotationData.CoverStatus.ClaimSubmitted), "Claim already submitted");
8294         require(cStatus != uint8(QuotationData.CoverStatus.CoverExpired), "Cover already expired");
8295         if (ms.isPause() == false) {
8296             _addClaim(coverId, now, qadd);
8297         } else {
8298             cd.setClaimAtEmergencyPause(coverId, now, false);
8299             qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.Requested));
8300         }
8301     }
8302 
8303     /**
8304      * @dev Submits the Claims queued once the emergency pause is switched off.
8305      */
8306     function submitClaimAfterEPOff() public onlyInternal {
8307         uint lengthOfClaimSubmittedAtEP = cd.getLengthOfClaimSubmittedAtEP();
8308         uint firstClaimIndexToSubmitAfterEP = cd.getFirstClaimIndexToSubmitAfterEP();
8309         uint coverId;
8310         uint dateUpd;
8311         bool submit;
8312         address qadd;
8313         for (uint i = firstClaimIndexToSubmitAfterEP; i < lengthOfClaimSubmittedAtEP; i++) {
8314             (coverId, dateUpd, submit) = cd.getClaimOfEmergencyPauseByIndex(i);
8315             require(submit == false);
8316             qadd = qd.getCoverMemberAddress(coverId);
8317             _addClaim(coverId, dateUpd, qadd);
8318             cd.setClaimSubmittedAtEPTrue(i, true);
8319         }
8320         cd.setFirstClaimIndexToSubmitAfterEP(lengthOfClaimSubmittedAtEP);
8321     }
8322 
8323     /**
8324      * @dev Castes vote for members who have tokens locked under Claims Assessment
8325      * @param claimId  claim id.
8326      * @param verdict 1 for Accept,-1 for Deny.
8327      */ 
8328     function submitCAVote(uint claimId, int8 verdict) public isMemberAndcheckPause {
8329         require(checkVoteClosing(claimId) != 1); 
8330         require(cd.userClaimVotePausedOn(msg.sender).add(cd.pauseDaysCA()) < now);  
8331         uint tokens = tc.tokensLockedAtTime(msg.sender, "CLA", now.add(cd.claimDepositTime()));
8332         require(tokens > 0);
8333         uint stat;
8334         (, stat) = cd.getClaimStatusNumber(claimId);
8335         require(stat == 0);
8336         require(cd.getUserClaimVoteCA(msg.sender, claimId) == 0);
8337         td.bookCATokens(msg.sender);
8338         cd.addVote(msg.sender, tokens, claimId, verdict);
8339         cd.callVoteEvent(msg.sender, claimId, "CAV", tokens, now, verdict);
8340         uint voteLength = cd.getAllVoteLength();
8341         cd.addClaimVoteCA(claimId, voteLength);
8342         cd.setUserClaimVoteCA(msg.sender, claimId, voteLength);
8343         cd.setClaimTokensCA(claimId, verdict, tokens);
8344         tc.extendLockOf(msg.sender, "CLA", td.lockCADays());
8345         int close = checkVoteClosing(claimId);
8346         if (close == 1) {
8347             cr.changeClaimStatus(claimId);
8348         }
8349     }
8350 
8351     /**
8352      * @dev Submits a member vote for assessing a claim.
8353      * Tokens other than those locked under Claims
8354      * Assessment can be used to cast a vote for a given claim id.
8355      * @param claimId Selected claim id.
8356      * @param verdict 1 for Accept,-1 for Deny.
8357      */ 
8358     function submitMemberVote(uint claimId, int8 verdict) public isMemberAndcheckPause {
8359         require(checkVoteClosing(claimId) != 1);
8360         uint stat;
8361         uint tokens = tc.totalBalanceOf(msg.sender);
8362         (, stat) = cd.getClaimStatusNumber(claimId);
8363         require(stat >= 1 && stat <= 5);
8364         require(cd.getUserClaimVoteMember(msg.sender, claimId) == 0);
8365         cd.addVote(msg.sender, tokens, claimId, verdict);
8366         cd.callVoteEvent(msg.sender, claimId, "MV", tokens, now, verdict);
8367         tc.lockForMemberVote(msg.sender, td.lockMVDays());
8368         uint voteLength = cd.getAllVoteLength();
8369         cd.addClaimVotemember(claimId, voteLength);
8370         cd.setUserClaimVoteMember(msg.sender, claimId, voteLength);
8371         cd.setClaimTokensMV(claimId, verdict, tokens);
8372         int close = checkVoteClosing(claimId);
8373         if (close == 1) {
8374             cr.changeClaimStatus(claimId);
8375         }
8376     }
8377 
8378     /**
8379     * @dev Pause Voting of All Pending Claims when Emergency Pause Start.
8380     */ 
8381     function pauseAllPendingClaimsVoting() public onlyInternal {
8382         uint firstIndex = cd.pendingClaimStart();
8383         uint actualClaimLength = cd.actualClaimLength();
8384         for (uint i = firstIndex; i < actualClaimLength; i++) {
8385             if (checkVoteClosing(i) == 0) {
8386                 uint dateUpd = cd.getClaimDateUpd(i);
8387                 cd.setPendingClaimDetails(i, (dateUpd.add(cd.maxVotingTime())).sub(now), false);
8388             }
8389         }
8390     }
8391 
8392     /**
8393      * @dev Resume the voting phase of all Claims paused due to an emergency pause.
8394      */
8395     function startAllPendingClaimsVoting() public onlyInternal {
8396         uint firstIndx = cd.getFirstClaimIndexToStartVotingAfterEP();
8397         uint i;
8398         uint lengthOfClaimVotingPause = cd.getLengthOfClaimVotingPause();
8399         for (i = firstIndx; i < lengthOfClaimVotingPause; i++) {
8400             uint pendingTime;
8401             uint claimID;
8402             (claimID, pendingTime, ) = cd.getPendingClaimDetailsByIndex(i);
8403             uint pTime = (now.sub(cd.maxVotingTime())).add(pendingTime);
8404             cd.setClaimdateUpd(claimID, pTime);
8405             cd.setPendingClaimVoteStatus(i, true);
8406             uint coverid;
8407             (, coverid) = cd.getClaimCoverId(claimID);
8408             address qadd = qd.getCoverMemberAddress(coverid);
8409             tf.extendCNEPOff(qadd, coverid, pendingTime.add(cd.claimDepositTime()));
8410             p1.closeClaimsOraclise(claimID, uint64(pTime));
8411         }
8412         cd.setFirstClaimIndexToStartVotingAfterEP(i);
8413     }
8414 
8415     /**
8416      * @dev Checks if voting of a claim should be closed or not.
8417      * @param claimId Claim Id.
8418      * @return close 1 -> voting should be closed, 0 -> if voting should not be closed,
8419      * -1 -> voting has already been closed.
8420      */ 
8421     function checkVoteClosing(uint claimId) public view returns(int8 close) {
8422         close = 0;
8423         uint status;
8424         (, status) = cd.getClaimStatusNumber(claimId);
8425         uint dateUpd = cd.getClaimDateUpd(claimId);
8426         if (status == 12 && dateUpd.add(cd.payoutRetryTime()) < now) {
8427             if (cd.getClaimState12Count(claimId) < 60)
8428                 close = 1;
8429         } 
8430         
8431         if (status > 5 && status != 12) {
8432             close = -1;
8433         }  else if (status != 12 && dateUpd.add(cd.maxVotingTime()) <= now) {
8434             close = 1;
8435         } else if (status != 12 && dateUpd.add(cd.minVotingTime()) >= now) {
8436             close = 0;
8437         } else if (status == 0 || (status >= 1 && status <= 5)) {
8438             close = _checkVoteClosingFinal(claimId, status);
8439         }
8440         
8441     }
8442 
8443     /**
8444      * @dev Checks if voting of a claim should be closed or not.
8445      * Internally called by checkVoteClosing method
8446      * for Claims whose status number is 0 or status number lie between 2 and 6.
8447      * @param claimId Claim Id.
8448      * @param status Current status of claim.
8449      * @return close 1 if voting should be closed,0 in case voting should not be closed,
8450      * -1 if voting has already been closed.
8451      */
8452     function _checkVoteClosingFinal(uint claimId, uint status) internal view returns(int8 close) {
8453         close = 0;
8454         uint coverId;
8455         (, coverId) = cd.getClaimCoverId(claimId);
8456         bytes4 curr = qd.getCurrencyOfCover(coverId);
8457         uint tokenx1e18 = m1.calculateTokenPrice(curr);
8458         uint accept;
8459         uint deny;
8460         (, accept, deny) = cd.getClaimsTokenCA(claimId);
8461         uint caTokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18);
8462         (, accept, deny) = cd.getClaimsTokenMV(claimId);
8463         uint mvTokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18);
8464         uint sumassured = qd.getCoverSumAssured(coverId).mul(DECIMAL1E18);
8465         if (status == 0 && caTokens >= sumassured.mul(10)) {
8466             close = 1;
8467         } else if (status >= 1 && status <= 5 && mvTokens >= sumassured.mul(10)) {
8468             close = 1;
8469         }
8470     }
8471 
8472     /**
8473      * @dev Changes the status of an existing claim id, based on current 
8474      * status and current conditions of the system
8475      * @param claimId Claim Id.
8476      * @param stat status number.  
8477      */
8478     function _setClaimStatus(uint claimId, uint stat) internal {
8479 
8480         uint origstat;
8481         uint state12Count;
8482         uint dateUpd;
8483         uint coverId;
8484         (, coverId, , origstat, dateUpd, state12Count) = cd.getClaim(claimId);
8485         (, origstat) = cd.getClaimStatusNumber(claimId);
8486 
8487         if (stat == 12 && origstat == 12) {
8488             cd.updateState12Count(claimId, 1);
8489         }
8490         cd.setClaimStatus(claimId, stat);
8491 
8492         if (state12Count >= 60 && stat == 12) {
8493             cd.setClaimStatus(claimId, 13);
8494             qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.ClaimDenied));
8495         }
8496         uint time = now;
8497         cd.setClaimdateUpd(claimId, time);
8498 
8499         if (stat >= 2 && stat <= 5) {
8500             p1.closeClaimsOraclise(claimId, cd.maxVotingTime());
8501         }
8502 
8503         if (stat == 12 && (dateUpd.add(cd.payoutRetryTime()) <= now) && (state12Count < 60)) {
8504             p1.closeClaimsOraclise(claimId, cd.payoutRetryTime());
8505         } else if (stat == 12 && (dateUpd.add(cd.payoutRetryTime()) > now) && (state12Count < 60)) {
8506             uint64 timeLeft = uint64((dateUpd.add(cd.payoutRetryTime())).sub(now));
8507             p1.closeClaimsOraclise(claimId, timeLeft);
8508         }
8509     }
8510 
8511     /**
8512      * @dev Submits a claim for a given cover note.
8513      * Set deposits flag against cover.
8514      */
8515     function _addClaim(uint coverId, uint time, address add) internal {
8516         tf.depositCN(coverId);
8517         uint len = cd.actualClaimLength();
8518         cd.addClaim(len, coverId, add, now);
8519         cd.callClaimEvent(coverId, add, len, time);
8520         qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.ClaimSubmitted));
8521         bytes4 curr = qd.getCurrencyOfCover(coverId);
8522         uint sumAssured = qd.getCoverSumAssured(coverId).mul(DECIMAL1E18);
8523         pd.changeCurrencyAssetVarMin(curr, pd.getCurrencyAssetVarMin(curr).add(sumAssured));
8524         p2.internalLiquiditySwap(curr);
8525         p1.closeClaimsOraclise(len, cd.maxVotingTime());
8526     }
8527 }
8528 
8529 /* Copyright (C) 2020 NexusMutual.io
8530 
8531   This program is free software: you can redistribute it and/or modify
8532     it under the terms of the GNU General Public License as published by
8533     the Free Software Foundation, either version 3 of the License, or
8534     (at your option) any later version.
8535 
8536   This program is distributed in the hope that it will be useful,
8537     but WITHOUT ANY WARRANTY; without even the implied warranty of
8538     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
8539     GNU General Public License for more details.
8540 
8541   You should have received a copy of the GNU General Public License
8542     along with this program.  If not, see http://www.gnu.org/licenses/ */
8543 //Claims Reward Contract contains the functions for calculating number of tokens
8544 // that will get rewarded, unlocked or burned depending upon the status of claim.
8545 contract ClaimsReward is Iupgradable {
8546      using SafeMath for uint;
8547 
8548     NXMToken internal tk;
8549     TokenController internal tc;
8550     TokenFunctions internal tf;
8551     TokenData internal td;
8552     QuotationData internal qd;
8553     Claims internal c1;
8554     ClaimsData internal cd;
8555     Pool1 internal p1;
8556     Pool2 internal p2;
8557     PoolData internal pd;
8558     Governance internal gv;
8559     IPooledStaking internal pooledStaking;
8560 
8561     uint private constant DECIMAL1E18 = uint(10) ** 18;
8562 
8563     function changeDependentContractAddress() public onlyInternal {
8564         c1 = Claims(ms.getLatestAddress("CL"));
8565         cd = ClaimsData(ms.getLatestAddress("CD"));
8566         tk = NXMToken(ms.tokenAddress());
8567         tc = TokenController(ms.getLatestAddress("TC"));
8568         td = TokenData(ms.getLatestAddress("TD"));
8569         tf = TokenFunctions(ms.getLatestAddress("TF"));
8570         p1 = Pool1(ms.getLatestAddress("P1"));
8571         p2 = Pool2(ms.getLatestAddress("P2"));
8572         pd = PoolData(ms.getLatestAddress("PD"));
8573         qd = QuotationData(ms.getLatestAddress("QD"));
8574         gv = Governance(ms.getLatestAddress("GV"));
8575         pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
8576     }
8577 
8578     /// @dev Decides the next course of action for a given claim.
8579     function changeClaimStatus(uint claimid) public checkPause onlyInternal {
8580 
8581         uint coverid;
8582         (, coverid) = cd.getClaimCoverId(claimid);
8583 
8584         uint status;
8585         (, status) = cd.getClaimStatusNumber(claimid);
8586 
8587         // when current status is "Pending-Claim Assessor Vote"
8588         if (status == 0) {
8589             _changeClaimStatusCA(claimid, coverid, status);
8590         } else if (status >= 1 && status <= 5) {
8591             _changeClaimStatusMV(claimid, coverid, status);
8592         } else if (status == 12) { // when current status is "Claim Accepted Payout Pending"
8593 
8594             uint sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
8595             address payable coverHolder = qd.getCoverMemberAddress(coverid);
8596             bytes4 coverCurrency = qd.getCurrencyOfCover(coverid);
8597             bool success = p1.sendClaimPayout(coverid, claimid, sumAssured, coverHolder, coverCurrency);
8598 
8599             if (success) {
8600                 tf.burnStakedTokens(coverid, coverCurrency, sumAssured);
8601                 c1.setClaimStatus(claimid, 14);
8602             }
8603         }
8604 
8605         c1.changePendingClaimStart();
8606     }
8607 
8608     /// @dev Amount of tokens to be rewarded to a user for a particular vote id.
8609     /// @param check 1 -> CA vote, else member vote
8610     /// @param voteid vote id for which reward has to be Calculated
8611     /// @param flag if 1 calculate even if claimed,else don't calculate if already claimed
8612     /// @return tokenCalculated reward to be given for vote id
8613     /// @return lastClaimedCheck true if final verdict is still pending for that voteid
8614     /// @return tokens number of tokens locked under that voteid
8615     /// @return perc percentage of reward to be given.
8616     function getRewardToBeGiven(
8617         uint check,
8618         uint voteid,
8619         uint flag
8620     )
8621         public
8622         view
8623         returns (
8624             uint tokenCalculated,
8625             bool lastClaimedCheck,
8626             uint tokens,
8627             uint perc
8628         )
8629 
8630     {
8631         uint claimId;
8632         int8 verdict;
8633         bool claimed;
8634         uint tokensToBeDist;
8635         uint totalTokens;
8636         (tokens, claimId, verdict, claimed) = cd.getVoteDetails(voteid);
8637         lastClaimedCheck = false;
8638         int8 claimVerdict = cd.getFinalVerdict(claimId);
8639         if (claimVerdict == 0) {
8640             lastClaimedCheck = true;
8641         }
8642 
8643         if (claimVerdict == verdict && (claimed == false || flag == 1)) {
8644 
8645             if (check == 1) {
8646                 (perc, , tokensToBeDist) = cd.getClaimRewardDetail(claimId);
8647             } else {
8648                 (, perc, tokensToBeDist) = cd.getClaimRewardDetail(claimId);
8649             }
8650 
8651             if (perc > 0) {
8652                 if (check == 1) {
8653                     if (verdict == 1) {
8654                         (, totalTokens, ) = cd.getClaimsTokenCA(claimId);
8655                     } else {
8656                         (, , totalTokens) = cd.getClaimsTokenCA(claimId);
8657                     }
8658                 } else {
8659                     if (verdict == 1) {
8660                         (, totalTokens, ) = cd.getClaimsTokenMV(claimId);
8661                     }else {
8662                         (, , totalTokens) = cd.getClaimsTokenMV(claimId);
8663                     }
8664                 }
8665                 tokenCalculated = (perc.mul(tokens).mul(tokensToBeDist)).div(totalTokens.mul(100));
8666 
8667 
8668             }
8669         }
8670     }
8671 
8672     /// @dev Transfers all tokens held by contract to a new contract in case of upgrade.
8673     function upgrade(address _newAdd) public onlyInternal {
8674         uint amount = tk.balanceOf(address(this));
8675         if (amount > 0) {
8676             require(tk.transfer(_newAdd, amount));
8677         }
8678 
8679     }
8680 
8681     /// @dev Total reward in token due for claim by a user.
8682     /// @return total total number of tokens
8683     function getRewardToBeDistributedByUser(address _add) public view returns(uint total) {
8684         uint lengthVote = cd.getVoteAddressCALength(_add);
8685         uint lastIndexCA;
8686         uint lastIndexMV;
8687         uint tokenForVoteId;
8688         uint voteId;
8689         (lastIndexCA, lastIndexMV) = cd.getRewardDistributedIndex(_add);
8690 
8691         for (uint i = lastIndexCA; i < lengthVote; i++) {
8692             voteId = cd.getVoteAddressCA(_add, i);
8693             (tokenForVoteId, , , ) = getRewardToBeGiven(1, voteId, 0);
8694             total = total.add(tokenForVoteId);
8695         }
8696 
8697         lengthVote = cd.getVoteAddressMemberLength(_add);
8698 
8699         for (uint j = lastIndexMV; j < lengthVote; j++) {
8700             voteId = cd.getVoteAddressMember(_add, j);
8701             (tokenForVoteId, , , ) = getRewardToBeGiven(0, voteId, 0);
8702             total = total.add(tokenForVoteId);
8703         }
8704         return (total);
8705     }
8706 
8707     /// @dev Gets reward amount and claiming status for a given claim id.
8708     /// @return reward amount of tokens to user.
8709     /// @return claimed true if already claimed false if yet to be claimed.
8710     function getRewardAndClaimedStatus(uint check, uint claimId) public view returns(uint reward, bool claimed) {
8711         uint voteId;
8712         uint claimid;
8713         uint lengthVote;
8714 
8715         if (check == 1) {
8716             lengthVote = cd.getVoteAddressCALength(msg.sender);
8717             for (uint i = 0; i < lengthVote; i++) {
8718                 voteId = cd.getVoteAddressCA(msg.sender, i);
8719                 (, claimid, , claimed) = cd.getVoteDetails(voteId);
8720                 if (claimid == claimId) { break; }
8721             }
8722         } else {
8723             lengthVote = cd.getVoteAddressMemberLength(msg.sender);
8724             for (uint j = 0; j < lengthVote; j++) {
8725                 voteId = cd.getVoteAddressMember(msg.sender, j);
8726                 (, claimid, , claimed) = cd.getVoteDetails(voteId);
8727                 if (claimid == claimId) { break; }
8728             }
8729         }
8730         (reward, , , ) = getRewardToBeGiven(check, voteId, 1);
8731 
8732     }
8733 
8734     /**
8735      * @dev Function used to claim all pending rewards : Claims Assessment + Risk Assessment + Governance
8736      * Claim assesment, Risk assesment, Governance rewards
8737      */
8738     function claimAllPendingReward(uint records) public isMemberAndcheckPause {
8739         _claimRewardToBeDistributed(records);
8740         pooledStaking.withdrawReward(msg.sender);
8741         uint governanceRewards = gv.claimReward(msg.sender, records);
8742         if (governanceRewards > 0) {
8743             require(tk.transfer(msg.sender, governanceRewards));
8744         }
8745     }
8746 
8747     /**
8748      * @dev Function used to get pending rewards of a particular user address.
8749      * @param _add user address.
8750      * @return total reward amount of the user
8751      */
8752     function getAllPendingRewardOfUser(address _add) public view returns(uint) {
8753         uint caReward = getRewardToBeDistributedByUser(_add);
8754         uint pooledStakingReward = pooledStaking.stakerReward(_add);
8755         uint governanceReward = gv.getPendingReward(_add);
8756         return caReward.add(pooledStakingReward).add(governanceReward);
8757     }
8758 
8759     /// @dev Rewards/Punishes users who  participated in Claims assessment.
8760     //    Unlocking and burning of the tokens will also depend upon the status of claim.
8761     /// @param claimid Claim Id.
8762     function _rewardAgainstClaim(uint claimid, uint coverid, uint sumAssured, uint status) internal {
8763         uint premiumNXM = qd.getCoverPremiumNXM(coverid);
8764         bytes4 curr = qd.getCurrencyOfCover(coverid);
8765         uint distributableTokens = premiumNXM.mul(cd.claimRewardPerc()).div(100);//  20% of premium
8766 
8767         uint percCA;
8768         uint percMV;
8769 
8770         (percCA, percMV) = cd.getRewardStatus(status);
8771         cd.setClaimRewardDetail(claimid, percCA, percMV, distributableTokens);
8772         if (percCA > 0 || percMV > 0) {
8773             tc.mint(address(this), distributableTokens);
8774         }
8775 
8776         if (status == 6 || status == 9 || status == 11) {
8777             cd.changeFinalVerdict(claimid, -1);
8778             td.setDepositCN(coverid, false); // Unset flag
8779             tf.burnDepositCN(coverid); // burn Deposited CN
8780 
8781             pd.changeCurrencyAssetVarMin(curr, pd.getCurrencyAssetVarMin(curr).sub(sumAssured));
8782             p2.internalLiquiditySwap(curr);
8783 
8784         } else if (status == 7 || status == 8 || status == 10) {
8785             cd.changeFinalVerdict(claimid, 1);
8786             td.setDepositCN(coverid, false); // Unset flag
8787             tf.unlockCN(coverid);
8788             bool success = p1.sendClaimPayout(coverid, claimid, sumAssured, qd.getCoverMemberAddress(coverid), curr);
8789             if (success) {
8790                 tf.burnStakedTokens(coverid, curr, sumAssured);
8791             }
8792         }
8793     }
8794 
8795     /// @dev Computes the result of Claim Assessors Voting for a given claim id.
8796     function _changeClaimStatusCA(uint claimid, uint coverid, uint status) internal {
8797         // Check if voting should be closed or not
8798         if (c1.checkVoteClosing(claimid) == 1) {
8799             uint caTokens = c1.getCATokens(claimid, 0); // converted in cover currency.
8800             uint accept;
8801             uint deny;
8802             uint acceptAndDeny;
8803             bool rewardOrPunish;
8804             uint sumAssured;
8805             (, accept) = cd.getClaimVote(claimid, 1);
8806             (, deny) = cd.getClaimVote(claimid, -1);
8807             acceptAndDeny = accept.add(deny);
8808             accept = accept.mul(100);
8809             deny = deny.mul(100);
8810 
8811             if (caTokens == 0) {
8812                 status = 3;
8813             } else {
8814                 sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
8815                 // Min threshold reached tokens used for voting > 5* sum assured
8816                 if (caTokens > sumAssured.mul(5)) {
8817 
8818                     if (accept.div(acceptAndDeny) > 70) {
8819                         status = 7;
8820                         qd.changeCoverStatusNo(coverid, uint8(QuotationData.CoverStatus.ClaimAccepted));
8821                         rewardOrPunish = true;
8822                     } else if (deny.div(acceptAndDeny) > 70) {
8823                         status = 6;
8824                         qd.changeCoverStatusNo(coverid, uint8(QuotationData.CoverStatus.ClaimDenied));
8825                         rewardOrPunish = true;
8826                     } else if (accept.div(acceptAndDeny) > deny.div(acceptAndDeny)) {
8827                         status = 4;
8828                     } else {
8829                         status = 5;
8830                     }
8831 
8832                 } else {
8833 
8834                     if (accept.div(acceptAndDeny) > deny.div(acceptAndDeny)) {
8835                         status = 2;
8836                     } else {
8837                         status = 3;
8838                     }
8839                 }
8840             }
8841 
8842             c1.setClaimStatus(claimid, status);
8843 
8844             if (rewardOrPunish) {
8845                 _rewardAgainstClaim(claimid, coverid, sumAssured, status);
8846             }
8847         }
8848     }
8849 
8850     /// @dev Computes the result of Member Voting for a given claim id.
8851     function _changeClaimStatusMV(uint claimid, uint coverid, uint status) internal {
8852 
8853         // Check if voting should be closed or not
8854         if (c1.checkVoteClosing(claimid) == 1) {
8855             uint8 coverStatus;
8856             uint statusOrig = status;
8857             uint mvTokens = c1.getCATokens(claimid, 1); // converted in cover currency.
8858 
8859             // If tokens used for acceptance >50%, claim is accepted
8860             uint sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
8861             uint thresholdUnreached = 0;
8862             // Minimum threshold for member voting is reached only when
8863             // value of tokens used for voting > 5* sum assured of claim id
8864             if (mvTokens < sumAssured.mul(5)) {
8865                 thresholdUnreached = 1;
8866             }
8867 
8868             uint accept;
8869             (, accept) = cd.getClaimMVote(claimid, 1);
8870             uint deny;
8871             (, deny) = cd.getClaimMVote(claimid, -1);
8872 
8873             if (accept.add(deny) > 0) {
8874                 if (accept.mul(100).div(accept.add(deny)) >= 50 && statusOrig > 1 &&
8875                     statusOrig <= 5 && thresholdUnreached == 0) {
8876                     status = 8;
8877                     coverStatus = uint8(QuotationData.CoverStatus.ClaimAccepted);
8878                 } else if (deny.mul(100).div(accept.add(deny)) >= 50 && statusOrig > 1 &&
8879                     statusOrig <= 5 && thresholdUnreached == 0) {
8880                     status = 9;
8881                     coverStatus = uint8(QuotationData.CoverStatus.ClaimDenied);
8882                 }
8883             }
8884 
8885             if (thresholdUnreached == 1 && (statusOrig == 2 || statusOrig == 4)) {
8886                 status = 10;
8887                 coverStatus = uint8(QuotationData.CoverStatus.ClaimAccepted);
8888             } else if (thresholdUnreached == 1 && (statusOrig == 5 || statusOrig == 3 || statusOrig == 1)) {
8889                 status = 11;
8890                 coverStatus = uint8(QuotationData.CoverStatus.ClaimDenied);
8891             }
8892 
8893             c1.setClaimStatus(claimid, status);
8894             qd.changeCoverStatusNo(coverid, uint8(coverStatus));
8895             // Reward/Punish Claim Assessors and Members who participated in Claims assessment
8896             _rewardAgainstClaim(claimid, coverid, sumAssured, status);
8897         }
8898     }
8899 
8900     /// @dev Allows a user to claim all pending  Claims assessment rewards.
8901     function _claimRewardToBeDistributed(uint _records) internal {
8902         uint lengthVote = cd.getVoteAddressCALength(msg.sender);
8903         uint voteid;
8904         uint lastIndex;
8905         (lastIndex, ) = cd.getRewardDistributedIndex(msg.sender);
8906         uint total = 0;
8907         uint tokenForVoteId = 0;
8908         bool lastClaimedCheck;
8909         uint _days = td.lockCADays();
8910         bool claimed;
8911         uint counter = 0;
8912         uint claimId;
8913         uint perc;
8914         uint i;
8915         uint lastClaimed = lengthVote;
8916 
8917         for (i = lastIndex; i < lengthVote && counter < _records; i++) {
8918             voteid = cd.getVoteAddressCA(msg.sender, i);
8919             (tokenForVoteId, lastClaimedCheck, , perc) = getRewardToBeGiven(1, voteid, 0);
8920             if (lastClaimed == lengthVote && lastClaimedCheck == true) {
8921                 lastClaimed = i;
8922             }
8923             (, claimId, , claimed) = cd.getVoteDetails(voteid);
8924 
8925             if (perc > 0 && !claimed) {
8926                 counter++;
8927                 cd.setRewardClaimed(voteid, true);
8928             } else if (perc == 0 && cd.getFinalVerdict(claimId) != 0 && !claimed) {
8929                 (perc, , ) = cd.getClaimRewardDetail(claimId);
8930                 if (perc == 0) {
8931                     counter++;
8932                 }
8933                 cd.setRewardClaimed(voteid, true);
8934             }
8935             if (tokenForVoteId > 0) {
8936                 total = tokenForVoteId.add(total);
8937             }
8938         }
8939         if (lastClaimed == lengthVote) {
8940             cd.setRewardDistributedIndexCA(msg.sender, i);
8941         }
8942         else {
8943             cd.setRewardDistributedIndexCA(msg.sender, lastClaimed);
8944         }
8945         lengthVote = cd.getVoteAddressMemberLength(msg.sender);
8946         lastClaimed = lengthVote;
8947         _days = _days.mul(counter);
8948         if (tc.tokensLockedAtTime(msg.sender, "CLA", now) > 0) {
8949             tc.reduceLock(msg.sender, "CLA", _days);
8950         }
8951         (, lastIndex) = cd.getRewardDistributedIndex(msg.sender);
8952         lastClaimed = lengthVote;
8953         counter = 0;
8954         for (i = lastIndex; i < lengthVote && counter < _records; i++) {
8955             voteid = cd.getVoteAddressMember(msg.sender, i);
8956             (tokenForVoteId, lastClaimedCheck, , ) = getRewardToBeGiven(0, voteid, 0);
8957             if (lastClaimed == lengthVote && lastClaimedCheck == true) {
8958                 lastClaimed = i;
8959             }
8960             (, claimId, , claimed) = cd.getVoteDetails(voteid);
8961             if (claimed == false && cd.getFinalVerdict(claimId) != 0) {
8962                 cd.setRewardClaimed(voteid, true);
8963                 counter++;
8964             }
8965             if (tokenForVoteId > 0) {
8966                 total = tokenForVoteId.add(total);
8967             }
8968         }
8969         if (total > 0) {
8970             require(tk.transfer(msg.sender, total));
8971         }
8972         if (lastClaimed == lengthVote) {
8973             cd.setRewardDistributedIndexMV(msg.sender, i);
8974         }
8975         else {
8976             cd.setRewardDistributedIndexMV(msg.sender, lastClaimed);
8977         }
8978     }
8979 
8980     /**
8981      * @dev Function used to claim the commission earned by the staker.
8982      */
8983     function _claimStakeCommission(uint _records, address _user) external onlyInternal {
8984         uint total=0;
8985         uint len = td.getStakerStakedContractLength(_user);
8986         uint lastCompletedStakeCommission = td.lastCompletedStakeCommission(_user);
8987         uint commissionEarned;
8988         uint commissionRedeemed;
8989         uint maxCommission;
8990         uint lastCommisionRedeemed = len;
8991         uint counter;
8992         uint i;
8993 
8994         for (i = lastCompletedStakeCommission; i < len && counter < _records; i++) {
8995             commissionRedeemed = td.getStakerRedeemedStakeCommission(_user, i);
8996             commissionEarned = td.getStakerEarnedStakeCommission(_user, i);
8997             maxCommission = td.getStakerInitialStakedAmountOnContract(
8998                 _user, i).mul(td.stakerMaxCommissionPer()).div(100);
8999             if (lastCommisionRedeemed == len && maxCommission != commissionEarned)
9000                 lastCommisionRedeemed = i;
9001             td.pushRedeemedStakeCommissions(_user, i, commissionEarned.sub(commissionRedeemed));
9002             total = total.add(commissionEarned.sub(commissionRedeemed));
9003             counter++;
9004         }
9005         if (lastCommisionRedeemed == len) {
9006             td.setLastCompletedStakeCommissionIndex(_user, i);
9007         } else {
9008             td.setLastCompletedStakeCommissionIndex(_user, lastCommisionRedeemed);
9009         }
9010 
9011         if (total > 0)
9012             require(tk.transfer(_user, total)); //solhint-disable-line
9013     }
9014 }
9015 
9016 /* Copyright (C) 2017 GovBlocks.io
9017   This program is free software: you can redistribute it and/or modify
9018     it under the terms of the GNU General Public License as published by
9019     the Free Software Foundation, either version 3 of the License, or
9020     (at your option) any later version.
9021   This program is distributed in the hope that it will be useful,
9022     but WITHOUT ANY WARRANTY; without even the implied warranty of
9023     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9024     GNU General Public License for more details.
9025   You should have received a copy of the GNU General Public License
9026     along with this program.  If not, see http://www.gnu.org/licenses/ */
9027 contract MemberRoles is IMemberRoles, Governed, Iupgradable {
9028 
9029     TokenController public dAppToken;
9030     TokenData internal td;
9031     QuotationData internal qd;
9032     ClaimsReward internal cr;
9033     Governance internal gv;
9034     TokenFunctions internal tf;
9035     NXMToken public tk;
9036 
9037     struct MemberRoleDetails {
9038         uint memberCounter;
9039         mapping(address => bool) memberActive;
9040         address[] memberAddress;
9041         address authorized;
9042     }
9043 
9044     enum Role {UnAssigned, AdvisoryBoard, Member, Owner}
9045 
9046     event switchedMembership(address indexed previousMember, address indexed newMember, uint timeStamp);
9047 
9048     MemberRoleDetails[] internal memberRoleData;
9049     bool internal constructorCheck;
9050     uint public maxABCount;
9051     bool public launched;
9052     uint public launchedOn;
9053     modifier checkRoleAuthority(uint _memberRoleId) {
9054         if (memberRoleData[_memberRoleId].authorized != address(0))
9055             require(msg.sender == memberRoleData[_memberRoleId].authorized);
9056         else
9057             require(isAuthorizedToGovern(msg.sender), "Not Authorized");
9058         _;
9059     }
9060 
9061     /**
9062      * @dev to swap advisory board member
9063      * @param _newABAddress is address of new AB member
9064      * @param _removeAB is advisory board member to be removed
9065      */
9066     function swapABMember (
9067         address _newABAddress,
9068         address _removeAB
9069     )
9070     external
9071     checkRoleAuthority(uint(Role.AdvisoryBoard)) {
9072 
9073         _updateRole(_newABAddress, uint(Role.AdvisoryBoard), true);
9074         _updateRole(_removeAB, uint(Role.AdvisoryBoard), false);
9075 
9076     }
9077 
9078     /**
9079      * @dev to swap the owner address
9080      * @param _newOwnerAddress is the new owner address
9081      */
9082     function swapOwner (
9083         address _newOwnerAddress
9084     )
9085     external {
9086         require(msg.sender == address(ms));
9087         _updateRole(ms.owner(), uint(Role.Owner), false);
9088         _updateRole(_newOwnerAddress, uint(Role.Owner), true);
9089     }
9090 
9091     /**
9092      * @dev is used to add initital advisory board members
9093      * @param abArray is the list of initial advisory board members
9094      */
9095     function addInitialABMembers(address[] calldata abArray) external onlyOwner {
9096 
9097         //Ensure that NXMaster has initialized.
9098         require(ms.masterInitialized());
9099 
9100         require(maxABCount >= 
9101             SafeMath.add(numberOfMembers(uint(Role.AdvisoryBoard)), abArray.length)
9102         );
9103         //AB count can't exceed maxABCount
9104         for (uint i = 0; i < abArray.length; i++) {
9105             require(checkRole(abArray[i], uint(MemberRoles.Role.Member)));
9106             _updateRole(abArray[i], uint(Role.AdvisoryBoard), true);   
9107         }
9108     }
9109 
9110     /**
9111      * @dev to change max number of AB members allowed
9112      * @param _val is the new value to be set
9113      */
9114     function changeMaxABCount(uint _val) external onlyInternal {
9115         maxABCount = _val;
9116     }
9117 
9118     /**
9119      * @dev Iupgradable Interface to update dependent contract address
9120      */
9121     function changeDependentContractAddress() public {
9122         td = TokenData(ms.getLatestAddress("TD"));
9123         cr = ClaimsReward(ms.getLatestAddress("CR"));
9124         qd = QuotationData(ms.getLatestAddress("QD"));
9125         gv = Governance(ms.getLatestAddress("GV"));
9126         tf = TokenFunctions(ms.getLatestAddress("TF"));
9127         tk = NXMToken(ms.tokenAddress());
9128         dAppToken = TokenController(ms.getLatestAddress("TC"));
9129     }
9130 
9131     /**
9132      * @dev to change the master address
9133      * @param _masterAddress is the new master address
9134      */
9135     function changeMasterAddress(address _masterAddress) public {
9136         if (masterAddress != address(0))
9137             require(masterAddress == msg.sender);
9138         masterAddress = _masterAddress;
9139         ms = INXMMaster(_masterAddress);
9140         nxMasterAddress = _masterAddress;
9141         
9142     }
9143     
9144     /**
9145      * @dev to initiate the member roles
9146      * @param _firstAB is the address of the first AB member
9147      * @param memberAuthority is the authority (role) of the member
9148      */
9149     function memberRolesInitiate (address _firstAB, address memberAuthority) public {
9150         require(!constructorCheck);
9151         _addInitialMemberRoles(_firstAB, memberAuthority);
9152         constructorCheck = true;
9153     }
9154 
9155     /// @dev Adds new member role
9156     /// @param _roleName New role name
9157     /// @param _roleDescription New description hash
9158     /// @param _authorized Authorized member against every role id
9159     function addRole( //solhint-disable-line
9160         bytes32 _roleName,
9161         string memory _roleDescription,
9162         address _authorized
9163     )
9164     public
9165     onlyAuthorizedToGovern {
9166         _addRole(_roleName, _roleDescription, _authorized);
9167     }
9168 
9169     /// @dev Assign or Delete a member from specific role.
9170     /// @param _memberAddress Address of Member
9171     /// @param _roleId RoleId to update
9172     /// @param _active active is set to be True if we want to assign this role to member, False otherwise!
9173     function updateRole( //solhint-disable-line
9174         address _memberAddress,
9175         uint _roleId,
9176         bool _active
9177     )
9178     public
9179     checkRoleAuthority(_roleId) {
9180         _updateRole(_memberAddress, _roleId, _active);
9181     }
9182 
9183     /**
9184      * @dev to add members before launch
9185      * @param userArray is list of addresses of members
9186      * @param tokens is list of tokens minted for each array element
9187      */
9188     function addMembersBeforeLaunch(address[] memory userArray, uint[] memory tokens) public onlyOwner {
9189         require(!launched);
9190 
9191         for (uint i=0; i < userArray.length; i++) {
9192             require(!ms.isMember(userArray[i]));
9193             dAppToken.addToWhitelist(userArray[i]);
9194             _updateRole(userArray[i], uint(Role.Member), true);
9195             dAppToken.mint(userArray[i], tokens[i]);
9196         }
9197         launched = true;
9198         launchedOn = now;
9199 
9200     }
9201 
9202    /** 
9203      * @dev Called by user to pay joining membership fee
9204      */ 
9205     function payJoiningFee(address _userAddress) public payable {
9206         require(_userAddress != address(0));
9207         require(!ms.isPause(), "Emergency Pause Applied");
9208         if (msg.sender == address(ms.getLatestAddress("QT"))) {
9209             require(td.walletAddress() != address(0), "No walletAddress present");
9210             dAppToken.addToWhitelist(_userAddress);
9211             _updateRole(_userAddress, uint(Role.Member), true);            
9212             td.walletAddress().transfer(msg.value); 
9213         } else {
9214             require(!qd.refundEligible(_userAddress));
9215             require(!ms.isMember(_userAddress));
9216             require(msg.value == td.joiningFee());
9217             qd.setRefundEligible(_userAddress, true);
9218         }
9219     }
9220 
9221     /**
9222      * @dev to perform kyc verdict
9223      * @param _userAddress whose kyc is being performed
9224      * @param verdict of kyc process
9225      */
9226     function kycVerdict(address payable _userAddress, bool verdict) public {
9227 
9228         require(msg.sender == qd.kycAuthAddress());
9229         require(!ms.isPause());
9230         require(_userAddress != address(0));
9231         require(!ms.isMember(_userAddress));
9232         require(qd.refundEligible(_userAddress));
9233         if (verdict) {
9234             qd.setRefundEligible(_userAddress, false);
9235             uint fee = td.joiningFee();
9236             dAppToken.addToWhitelist(_userAddress);
9237             _updateRole(_userAddress, uint(Role.Member), true);
9238             td.walletAddress().transfer(fee); //solhint-disable-line
9239             
9240         } else {
9241             qd.setRefundEligible(_userAddress, false);
9242             _userAddress.transfer(td.joiningFee()); //solhint-disable-line
9243         }
9244     }
9245 
9246     /**
9247      * @dev Called by existed member if wish to Withdraw membership.
9248      */
9249     function withdrawMembership() public {
9250         require(!ms.isPause() && ms.isMember(msg.sender));
9251         require(dAppToken.totalLockedBalance(msg.sender, now) == 0); //solhint-disable-line
9252         require(!tf.isLockedForMemberVote(msg.sender)); // No locked tokens for Member/Governance voting
9253         require(cr.getAllPendingRewardOfUser(msg.sender) == 0); // No pending reward to be claimed(claim assesment).
9254         require(dAppToken.tokensUnlockable(msg.sender, "CLA") == 0, "Member should have no CLA unlockable tokens");
9255         gv.removeDelegation(msg.sender);
9256         dAppToken.burnFrom(msg.sender, tk.balanceOf(msg.sender));
9257         _updateRole(msg.sender, uint(Role.Member), false);
9258         dAppToken.removeFromWhitelist(msg.sender); // need clarification on whitelist        
9259     }
9260 
9261 
9262     /**
9263      * @dev Called by existed member if wish to switch membership to other address.
9264      * @param _add address of user to forward membership.
9265      */
9266     function switchMembership(address _add) external {
9267         require(!ms.isPause() && ms.isMember(msg.sender) && !ms.isMember(_add));
9268         require(dAppToken.totalLockedBalance(msg.sender, now) == 0); //solhint-disable-line
9269         require(!tf.isLockedForMemberVote(msg.sender)); // No locked tokens for Member/Governance voting
9270         require(cr.getAllPendingRewardOfUser(msg.sender) == 0); // No pending reward to be claimed(claim assesment).
9271         require(dAppToken.tokensUnlockable(msg.sender, "CLA") == 0, "Member should have no CLA unlockable tokens");
9272         gv.removeDelegation(msg.sender);
9273         dAppToken.addToWhitelist(_add);
9274         _updateRole(_add, uint(Role.Member), true);
9275         tk.transferFrom(msg.sender, _add, tk.balanceOf(msg.sender));
9276         _updateRole(msg.sender, uint(Role.Member), false);
9277         dAppToken.removeFromWhitelist(msg.sender);
9278         emit switchedMembership(msg.sender, _add, now);
9279     }
9280 
9281     /// @dev Return number of member roles
9282     function totalRoles() public view returns(uint256) { //solhint-disable-line
9283         return memberRoleData.length;
9284     }
9285 
9286     /// @dev Change Member Address who holds the authority to Add/Delete any member from specific role.
9287     /// @param _roleId roleId to update its Authorized Address
9288     /// @param _newAuthorized New authorized address against role id
9289     function changeAuthorized(uint _roleId, address _newAuthorized) public checkRoleAuthority(_roleId) { //solhint-disable-line
9290         memberRoleData[_roleId].authorized = _newAuthorized;
9291     }
9292 
9293     /// @dev Gets the member addresses assigned by a specific role
9294     /// @param _memberRoleId Member role id
9295     /// @return roleId Role id
9296     /// @return allMemberAddress Member addresses of specified role id
9297     function members(uint _memberRoleId) public view returns(uint, address[] memory memberArray) { //solhint-disable-line
9298         uint length = memberRoleData[_memberRoleId].memberAddress.length;
9299         uint i;
9300         uint j = 0;
9301         memberArray = new address[](memberRoleData[_memberRoleId].memberCounter);
9302         for (i = 0; i < length; i++) {
9303             address member = memberRoleData[_memberRoleId].memberAddress[i];
9304             if (memberRoleData[_memberRoleId].memberActive[member] && !_checkMemberInArray(member, memberArray)) { //solhint-disable-line
9305                 memberArray[j] = member;
9306                 j++;
9307             }
9308         }
9309 
9310         return (_memberRoleId, memberArray);
9311     }
9312 
9313     /// @dev Gets all members' length
9314     /// @param _memberRoleId Member role id
9315     /// @return memberRoleData[_memberRoleId].memberCounter Member length
9316     function numberOfMembers(uint _memberRoleId) public view returns(uint) { //solhint-disable-line
9317         return memberRoleData[_memberRoleId].memberCounter;
9318     }
9319 
9320     /// @dev Return member address who holds the right to add/remove any member from specific role.
9321     function authorized(uint _memberRoleId) public view returns(address) { //solhint-disable-line
9322         return memberRoleData[_memberRoleId].authorized;
9323     }
9324 
9325     /// @dev Get All role ids array that has been assigned to a member so far.
9326     function roles(address _memberAddress) public view returns(uint[] memory) { //solhint-disable-line
9327         uint length = memberRoleData.length;
9328         uint[] memory assignedRoles = new uint[](length);
9329         uint counter = 0; 
9330         for (uint i = 1; i < length; i++) {
9331             if (memberRoleData[i].memberActive[_memberAddress]) {
9332                 assignedRoles[counter] = i;
9333                 counter++;
9334             }
9335         }
9336         return assignedRoles;
9337     }
9338 
9339     /// @dev Returns true if the given role id is assigned to a member.
9340     /// @param _memberAddress Address of member
9341     /// @param _roleId Checks member's authenticity with the roleId.
9342     /// i.e. Returns true if this roleId is assigned to member
9343     function checkRole(address _memberAddress, uint _roleId) public view returns(bool) { //solhint-disable-line
9344         if (_roleId == uint(Role.UnAssigned))
9345             return true;
9346         else
9347             if (memberRoleData[_roleId].memberActive[_memberAddress]) //solhint-disable-line
9348                 return true;
9349             else
9350                 return false;
9351     }
9352 
9353     /// @dev Return total number of members assigned against each role id.
9354     /// @return totalMembers Total members in particular role id
9355     function getMemberLengthForAllRoles() public view returns(uint[] memory totalMembers) { //solhint-disable-line
9356         totalMembers = new uint[](memberRoleData.length);
9357         for (uint i = 0; i < memberRoleData.length; i++) {
9358             totalMembers[i] = numberOfMembers(i);
9359         }
9360     }
9361 
9362     /**
9363      * @dev to update the member roles
9364      * @param _memberAddress in concern
9365      * @param _roleId the id of role
9366      * @param _active if active is true, add the member, else remove it 
9367      */
9368     function _updateRole(address _memberAddress,
9369         uint _roleId,
9370         bool _active) internal {
9371         // require(_roleId != uint(Role.TokenHolder), "Membership to Token holder is detected automatically");
9372         if (_active) {
9373             require(!memberRoleData[_roleId].memberActive[_memberAddress]);
9374             memberRoleData[_roleId].memberCounter = SafeMath.add(memberRoleData[_roleId].memberCounter, 1);
9375             memberRoleData[_roleId].memberActive[_memberAddress] = true;
9376             memberRoleData[_roleId].memberAddress.push(_memberAddress);
9377         } else {
9378             require(memberRoleData[_roleId].memberActive[_memberAddress]);
9379             memberRoleData[_roleId].memberCounter = SafeMath.sub(memberRoleData[_roleId].memberCounter, 1);
9380             delete memberRoleData[_roleId].memberActive[_memberAddress];
9381         }
9382     }
9383 
9384     /// @dev Adds new member role
9385     /// @param _roleName New role name
9386     /// @param _roleDescription New description hash
9387     /// @param _authorized Authorized member against every role id
9388     function _addRole(
9389         bytes32 _roleName,
9390         string memory _roleDescription,
9391         address _authorized
9392     ) internal {
9393         emit MemberRole(memberRoleData.length, _roleName, _roleDescription);
9394         memberRoleData.push(MemberRoleDetails(0, new address[](0), _authorized));
9395     }
9396 
9397     /**
9398      * @dev to check if member is in the given member array
9399      * @param _memberAddress in concern
9400      * @param memberArray in concern
9401      * @return boolean to represent the presence
9402      */
9403     function _checkMemberInArray(
9404         address _memberAddress,
9405         address[] memory memberArray
9406     )
9407         internal
9408         pure
9409         returns(bool memberExists)
9410     {
9411         uint i;
9412         for (i = 0; i < memberArray.length; i++) {
9413             if (memberArray[i] == _memberAddress) {
9414                 memberExists = true;
9415                 break;
9416             }
9417         }
9418     }
9419 
9420     /**
9421      * @dev to add initial member roles
9422      * @param _firstAB is the member address to be added
9423      * @param memberAuthority is the member authority(role) to be added for
9424      */
9425     function _addInitialMemberRoles(address _firstAB, address memberAuthority) internal {
9426         maxABCount = 5;
9427         _addRole("Unassigned", "Unassigned", address(0));
9428         _addRole(
9429             "Advisory Board",
9430             "Selected few members that are deeply entrusted by the dApp. An ideal advisory board should be a mix of skills of domain, governance, research, technology, consulting etc to improve the performance of the dApp.", //solhint-disable-line
9431             address(0)
9432         );
9433         _addRole(
9434             "Member",
9435             "Represents all users of Mutual.", //solhint-disable-line
9436             memberAuthority
9437         );
9438         _addRole(
9439             "Owner",
9440             "Represents Owner of Mutual.", //solhint-disable-line
9441             address(0)
9442         );
9443         // _updateRole(_firstAB, uint(Role.AdvisoryBoard), true);
9444         _updateRole(_firstAB, uint(Role.Owner), true);
9445         // _updateRole(_firstAB, uint(Role.Member), true);
9446         launchedOn = 0;
9447     }
9448 
9449     function memberAtIndex(uint _memberRoleId, uint index) external view returns (address, bool) {
9450         address memberAddress = memberRoleData[_memberRoleId].memberAddress[index];
9451         return (memberAddress, memberRoleData[_memberRoleId].memberActive[memberAddress]);
9452     }
9453 
9454     function membersLength(uint _memberRoleId) external view returns (uint) {
9455         return memberRoleData[_memberRoleId].memberAddress.length;
9456     }
9457 }
9458 
9459 /* Copyright (C) 2017 GovBlocks.io
9460   This program is free software: you can redistribute it and/or modify
9461     it under the terms of the GNU General Public License as published by
9462     the Free Software Foundation, either version 3 of the License, or
9463     (at your option) any later version.
9464   This program is distributed in the hope that it will be useful,
9465     but WITHOUT ANY WARRANTY; without even the implied warranty of
9466     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9467     GNU General Public License for more details.
9468   You should have received a copy of the GNU General Public License
9469     along with this program.  If not, see http://www.gnu.org/licenses/ */
9470 contract ProposalCategory is  Governed, IProposalCategory, Iupgradable {
9471 
9472     bool public constructorCheck;
9473     MemberRoles internal mr;
9474 
9475     struct CategoryStruct {
9476         uint memberRoleToVote;
9477         uint majorityVotePerc;
9478         uint quorumPerc;
9479         uint[] allowedToCreateProposal;
9480         uint closingTime;
9481         uint minStake;
9482     }
9483 
9484     struct CategoryAction {
9485         uint defaultIncentive;
9486         address contractAddress;
9487         bytes2 contractName;
9488     }
9489     
9490     CategoryStruct[] internal allCategory;
9491     mapping (uint => CategoryAction) internal categoryActionData;
9492     mapping (uint => uint) public categoryABReq;
9493     mapping (uint => uint) public isSpecialResolution;
9494     mapping (uint => bytes) public categoryActionHashes;
9495 
9496     bool public categoryActionHashUpdated;
9497 
9498     /**
9499     * @dev Restricts calls to deprecated functions
9500     */
9501     modifier deprecated() {
9502         revert("Function deprecated");
9503         _;
9504     }
9505 
9506     /**
9507     * @dev Adds new category (Discontinued, moved functionality to newCategory)
9508     * @param _name Category name
9509     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
9510     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
9511     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
9512     * @param _allowedToCreateProposal Member roles allowed to create the proposal
9513     * @param _closingTime Vote closing time for Each voting layer
9514     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
9515     * @param _contractAddress address of contract to call after proposal is accepted
9516     * @param _contractName name of contract to be called after proposal is accepted
9517     * @param _incentives rewards to distributed after proposal is accepted
9518     */
9519     function addCategory(
9520         string calldata _name, 
9521         uint _memberRoleToVote,
9522         uint _majorityVotePerc, 
9523         uint _quorumPerc,
9524         uint[] calldata _allowedToCreateProposal,
9525         uint _closingTime,
9526         string calldata _actionHash,
9527         address _contractAddress,
9528         bytes2 _contractName,
9529         uint[] calldata _incentives
9530     ) 
9531         external
9532         deprecated 
9533     {
9534     }
9535 
9536     /**
9537     * @dev Initiates Default settings for Proposal Category contract (Adding default categories)
9538     */
9539     function proposalCategoryInitiate() external deprecated { //solhint-disable-line
9540     }
9541 
9542     /**
9543     * @dev Initiates Default action function hashes for existing categories
9544     * To be called after the contract has been upgraded by governance
9545     */
9546     function updateCategoryActionHashes() external onlyOwner {
9547 
9548         require(!categoryActionHashUpdated, "Category action hashes already updated");
9549         categoryActionHashUpdated = true;
9550         categoryActionHashes[1] = abi.encodeWithSignature("addRole(bytes32,string,address)");
9551         categoryActionHashes[2] = abi.encodeWithSignature("updateRole(address,uint256,bool)");
9552         categoryActionHashes[3] = abi.encodeWithSignature("newCategory(string,uint256,uint256,uint256,uint256[],uint256,string,address,bytes2,uint256[],string)");//solhint-disable-line
9553         categoryActionHashes[4] = abi.encodeWithSignature("editCategory(uint256,string,uint256,uint256,uint256,uint256[],uint256,string,address,bytes2,uint256[],string)");//solhint-disable-line
9554         categoryActionHashes[5] = abi.encodeWithSignature("upgradeContractImplementation(bytes2,address)");
9555         categoryActionHashes[6] = abi.encodeWithSignature("startEmergencyPause()");
9556         categoryActionHashes[7] = abi.encodeWithSignature("addEmergencyPause(bool,bytes4)");
9557         categoryActionHashes[8] = abi.encodeWithSignature("burnCAToken(uint256,uint256,address)");
9558         categoryActionHashes[9] = abi.encodeWithSignature("setUserClaimVotePausedOn(address)");
9559         categoryActionHashes[12] = abi.encodeWithSignature("transferEther(uint256,address)");
9560         categoryActionHashes[13] = abi.encodeWithSignature("addInvestmentAssetCurrency(bytes4,address,bool,uint64,uint64,uint8)");//solhint-disable-line
9561         categoryActionHashes[14] = abi.encodeWithSignature("changeInvestmentAssetHoldingPerc(bytes4,uint64,uint64)");
9562         categoryActionHashes[15] = abi.encodeWithSignature("changeInvestmentAssetStatus(bytes4,bool)");
9563         categoryActionHashes[16] = abi.encodeWithSignature("swapABMember(address,address)");
9564         categoryActionHashes[17] = abi.encodeWithSignature("addCurrencyAssetCurrency(bytes4,address,uint256)");
9565         categoryActionHashes[20] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
9566         categoryActionHashes[21] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
9567         categoryActionHashes[22] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
9568         categoryActionHashes[23] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
9569         categoryActionHashes[24] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
9570         categoryActionHashes[25] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
9571         categoryActionHashes[26] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
9572         categoryActionHashes[27] = abi.encodeWithSignature("updateAddressParameters(bytes8,address)");
9573         categoryActionHashes[28] = abi.encodeWithSignature("updateOwnerParameters(bytes8,address)");
9574         categoryActionHashes[29] = abi.encodeWithSignature("upgradeContract(bytes2,address)");
9575         categoryActionHashes[30] = abi.encodeWithSignature("changeCurrencyAssetAddress(bytes4,address)");
9576         categoryActionHashes[31] = abi.encodeWithSignature("changeCurrencyAssetBaseMin(bytes4,uint256)");
9577         categoryActionHashes[32] = abi.encodeWithSignature("changeInvestmentAssetAddressAndDecimal(bytes4,address,uint8)");//solhint-disable-line
9578         categoryActionHashes[33] = abi.encodeWithSignature("externalLiquidityTrade()");
9579     }
9580 
9581     /**
9582     * @dev Gets Total number of categories added till now
9583     */
9584     function totalCategories() external view returns(uint) {
9585         return allCategory.length;
9586     }
9587 
9588     /**
9589     * @dev Gets category details
9590     */
9591     function category(uint _categoryId) external view returns(uint, uint, uint, uint, uint[] memory, uint, uint) {
9592         return(
9593             _categoryId,
9594             allCategory[_categoryId].memberRoleToVote,
9595             allCategory[_categoryId].majorityVotePerc,
9596             allCategory[_categoryId].quorumPerc,
9597             allCategory[_categoryId].allowedToCreateProposal,
9598             allCategory[_categoryId].closingTime,
9599             allCategory[_categoryId].minStake
9600         );
9601     }
9602 
9603     /**
9604     * @dev Gets category ab required and isSpecialResolution
9605     * @return the category id
9606     * @return if AB voting is required
9607     * @return is category a special resolution
9608     */
9609     function categoryExtendedData(uint _categoryId) external view returns(uint, uint, uint) {
9610         return(
9611             _categoryId,
9612             categoryABReq[_categoryId],
9613             isSpecialResolution[_categoryId]
9614         );
9615     }
9616 
9617     /**
9618      * @dev Gets the category acion details
9619      * @param _categoryId is the category id in concern
9620      * @return the category id
9621      * @return the contract address
9622      * @return the contract name
9623      * @return the default incentive
9624      */
9625     function categoryAction(uint _categoryId) external view returns(uint, address, bytes2, uint) {
9626 
9627         return(
9628             _categoryId,
9629             categoryActionData[_categoryId].contractAddress,
9630             categoryActionData[_categoryId].contractName,
9631             categoryActionData[_categoryId].defaultIncentive
9632         );
9633     }
9634 
9635     /**
9636      * @dev Gets the category acion details of a category id 
9637      * @param _categoryId is the category id in concern
9638      * @return the category id
9639      * @return the contract address
9640      * @return the contract name
9641      * @return the default incentive
9642      * @return action function hash
9643      */
9644     function categoryActionDetails(uint _categoryId) external view returns(uint, address, bytes2, uint, bytes memory) {
9645         return(
9646             _categoryId,
9647             categoryActionData[_categoryId].contractAddress,
9648             categoryActionData[_categoryId].contractName,
9649             categoryActionData[_categoryId].defaultIncentive,
9650             categoryActionHashes[_categoryId]
9651         );
9652     }
9653 
9654     /**
9655     * @dev Updates dependant contract addresses
9656     */
9657     function changeDependentContractAddress() public {
9658         mr = MemberRoles(ms.getLatestAddress("MR"));
9659     }
9660 
9661     /**
9662     * @dev Adds new category
9663     * @param _name Category name
9664     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
9665     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
9666     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
9667     * @param _allowedToCreateProposal Member roles allowed to create the proposal
9668     * @param _closingTime Vote closing time for Each voting layer
9669     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
9670     * @param _contractAddress address of contract to call after proposal is accepted
9671     * @param _contractName name of contract to be called after proposal is accepted
9672     * @param _incentives rewards to distributed after proposal is accepted
9673     * @param _functionHash function signature to be executed
9674     */
9675     function newCategory(
9676         string memory _name, 
9677         uint _memberRoleToVote,
9678         uint _majorityVotePerc, 
9679         uint _quorumPerc,
9680         uint[] memory _allowedToCreateProposal,
9681         uint _closingTime,
9682         string memory _actionHash,
9683         address _contractAddress,
9684         bytes2 _contractName,
9685         uint[] memory _incentives,
9686         string memory _functionHash
9687     ) 
9688         public
9689         onlyAuthorizedToGovern 
9690     {
9691 
9692         require(_quorumPerc <= 100 && _majorityVotePerc <= 100, "Invalid percentage");
9693 
9694         require((_contractName == "EX" && _contractAddress == address(0)) || bytes(_functionHash).length > 0);
9695         
9696         require(_incentives[3] <= 1, "Invalid special resolution flag");
9697         
9698         //If category is special resolution role authorized should be member
9699         if (_incentives[3] == 1) {
9700             require(_memberRoleToVote == uint(MemberRoles.Role.Member));
9701             _majorityVotePerc = 0;
9702             _quorumPerc = 0;
9703         }
9704 
9705         _addCategory(
9706             _name, 
9707             _memberRoleToVote,
9708             _majorityVotePerc, 
9709             _quorumPerc,
9710             _allowedToCreateProposal,
9711             _closingTime,
9712             _actionHash,
9713             _contractAddress,
9714             _contractName,
9715             _incentives
9716         );
9717 
9718 
9719         if (bytes(_functionHash).length > 0 && abi.encodeWithSignature(_functionHash).length == 4) {
9720             categoryActionHashes[allCategory.length - 1] = abi.encodeWithSignature(_functionHash);
9721         }
9722     }
9723 
9724     /**
9725      * @dev Changes the master address and update it's instance
9726      * @param _masterAddress is the new master address
9727      */
9728     function changeMasterAddress(address _masterAddress) public {
9729         if (masterAddress != address(0))
9730             require(masterAddress == msg.sender);
9731         masterAddress = _masterAddress;
9732         ms = INXMMaster(_masterAddress);
9733         nxMasterAddress = _masterAddress;
9734         
9735     }
9736 
9737     /**
9738     * @dev Updates category details (Discontinued, moved functionality to editCategory)
9739     * @param _categoryId Category id that needs to be updated
9740     * @param _name Category name
9741     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
9742     * @param _allowedToCreateProposal Member roles allowed to create the proposal
9743     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
9744     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
9745     * @param _closingTime Vote closing time for Each voting layer
9746     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
9747     * @param _contractAddress address of contract to call after proposal is accepted
9748     * @param _contractName name of contract to be called after proposal is accepted
9749     * @param _incentives rewards to distributed after proposal is accepted
9750     */
9751     function updateCategory(
9752         uint _categoryId, 
9753         string memory _name, 
9754         uint _memberRoleToVote, 
9755         uint _majorityVotePerc, 
9756         uint _quorumPerc,
9757         uint[] memory _allowedToCreateProposal,
9758         uint _closingTime,
9759         string memory _actionHash,
9760         address _contractAddress,
9761         bytes2 _contractName,
9762         uint[] memory _incentives
9763     )
9764         public
9765         deprecated
9766     {
9767     }
9768 
9769     /**
9770     * @dev Updates category details
9771     * @param _categoryId Category id that needs to be updated
9772     * @param _name Category name
9773     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
9774     * @param _allowedToCreateProposal Member roles allowed to create the proposal
9775     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
9776     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
9777     * @param _closingTime Vote closing time for Each voting layer
9778     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
9779     * @param _contractAddress address of contract to call after proposal is accepted
9780     * @param _contractName name of contract to be called after proposal is accepted
9781     * @param _incentives rewards to distributed after proposal is accepted
9782     * @param _functionHash function signature to be executed
9783     */
9784     function editCategory(
9785         uint _categoryId, 
9786         string memory _name, 
9787         uint _memberRoleToVote, 
9788         uint _majorityVotePerc, 
9789         uint _quorumPerc,
9790         uint[] memory _allowedToCreateProposal,
9791         uint _closingTime,
9792         string memory _actionHash,
9793         address _contractAddress,
9794         bytes2 _contractName,
9795         uint[] memory _incentives,
9796         string memory _functionHash
9797     )
9798         public
9799         onlyAuthorizedToGovern
9800     {
9801         require(_verifyMemberRoles(_memberRoleToVote, _allowedToCreateProposal) == 1, "Invalid Role");
9802 
9803         require(_quorumPerc <= 100 && _majorityVotePerc <= 100, "Invalid percentage");
9804 
9805         require((_contractName == "EX" && _contractAddress == address(0)) || bytes(_functionHash).length > 0);
9806 
9807         require(_incentives[3] <= 1, "Invalid special resolution flag");
9808         
9809         //If category is special resolution role authorized should be member
9810         if (_incentives[3] == 1) {
9811             require(_memberRoleToVote == uint(MemberRoles.Role.Member));
9812             _majorityVotePerc = 0;
9813             _quorumPerc = 0;
9814         }
9815 
9816         delete categoryActionHashes[_categoryId];
9817         if (bytes(_functionHash).length > 0 && abi.encodeWithSignature(_functionHash).length == 4) {
9818             categoryActionHashes[_categoryId] = abi.encodeWithSignature(_functionHash);
9819         }
9820         allCategory[_categoryId].memberRoleToVote = _memberRoleToVote;
9821         allCategory[_categoryId].majorityVotePerc = _majorityVotePerc;
9822         allCategory[_categoryId].closingTime = _closingTime;
9823         allCategory[_categoryId].allowedToCreateProposal = _allowedToCreateProposal;
9824         allCategory[_categoryId].minStake = _incentives[0];
9825         allCategory[_categoryId].quorumPerc = _quorumPerc;
9826         categoryActionData[_categoryId].defaultIncentive = _incentives[1];
9827         categoryActionData[_categoryId].contractName = _contractName;
9828         categoryActionData[_categoryId].contractAddress = _contractAddress;
9829         categoryABReq[_categoryId] = _incentives[2];
9830         isSpecialResolution[_categoryId] = _incentives[3];
9831         emit Category(_categoryId, _name, _actionHash);
9832     }
9833 
9834     /**
9835     * @dev Internal call to add new category
9836     * @param _name Category name
9837     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
9838     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
9839     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
9840     * @param _allowedToCreateProposal Member roles allowed to create the proposal
9841     * @param _closingTime Vote closing time for Each voting layer
9842     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
9843     * @param _contractAddress address of contract to call after proposal is accepted
9844     * @param _contractName name of contract to be called after proposal is accepted
9845     * @param _incentives rewards to distributed after proposal is accepted
9846     */
9847     function _addCategory(
9848         string memory _name, 
9849         uint _memberRoleToVote,
9850         uint _majorityVotePerc, 
9851         uint _quorumPerc,
9852         uint[] memory _allowedToCreateProposal,
9853         uint _closingTime,
9854         string memory _actionHash,
9855         address _contractAddress,
9856         bytes2 _contractName,
9857         uint[] memory _incentives
9858     ) 
9859         internal
9860     {
9861         require(_verifyMemberRoles(_memberRoleToVote, _allowedToCreateProposal) == 1, "Invalid Role");
9862         allCategory.push(
9863             CategoryStruct(
9864                 _memberRoleToVote,
9865                 _majorityVotePerc,
9866                 _quorumPerc,
9867                 _allowedToCreateProposal,
9868                 _closingTime,
9869                 _incentives[0]
9870             )
9871         );
9872         uint categoryId = allCategory.length - 1;
9873         categoryActionData[categoryId] = CategoryAction(_incentives[1], _contractAddress, _contractName);
9874         categoryABReq[categoryId] = _incentives[2];
9875         isSpecialResolution[categoryId] = _incentives[3];
9876         emit Category(categoryId, _name, _actionHash);
9877     }
9878 
9879     /**
9880     * @dev Internal call to check if given roles are valid or not
9881     */
9882     function _verifyMemberRoles(uint _memberRoleToVote, uint[] memory _allowedToCreateProposal) 
9883     internal view returns(uint) { 
9884         uint totalRoles = mr.totalRoles();
9885         if (_memberRoleToVote >= totalRoles) {
9886             return 0;
9887         }
9888         for (uint i = 0; i < _allowedToCreateProposal.length; i++) {
9889             if (_allowedToCreateProposal[i] >= totalRoles) {
9890                 return 0;
9891             }
9892         }
9893         return 1;
9894     }
9895 
9896 }
9897 
9898 /* Copyright (C) 2017 GovBlocks.io
9899 
9900   This program is free software: you can redistribute it and/or modify
9901     it under the terms of the GNU General Public License as published by
9902     the Free Software Foundation, either version 3 of the License, or
9903     (at your option) any later version.
9904 
9905   This program is distributed in the hope that it will be useful,
9906     but WITHOUT ANY WARRANTY; without even the implied warranty of
9907     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9908     GNU General Public License for more details.
9909 
9910   You should have received a copy of the GNU General Public License
9911     along with this program.  If not, see http://www.gnu.org/licenses/ */
9912 contract IGovernance { 
9913 
9914     event Proposal(
9915         address indexed proposalOwner,
9916         uint256 indexed proposalId,
9917         uint256 dateAdd,
9918         string proposalTitle,
9919         string proposalSD,
9920         string proposalDescHash
9921     );
9922 
9923     event Solution(
9924         uint256 indexed proposalId,
9925         address indexed solutionOwner,
9926         uint256 indexed solutionId,
9927         string solutionDescHash,
9928         uint256 dateAdd
9929     );
9930 
9931     event Vote(
9932         address indexed from,
9933         uint256 indexed proposalId,
9934         uint256 indexed voteId,
9935         uint256 dateAdd,
9936         uint256 solutionChosen
9937     );
9938 
9939     event RewardClaimed(
9940         address indexed member,
9941         uint gbtReward
9942     );
9943 
9944     /// @dev VoteCast event is called whenever a vote is cast that can potentially close the proposal. 
9945     event VoteCast (uint256 proposalId);
9946 
9947     /// @dev ProposalAccepted event is called when a proposal is accepted so that a server can listen that can 
9948     ///      call any offchain actions
9949     event ProposalAccepted (uint256 proposalId);
9950 
9951     /// @dev CloseProposalOnTime event is called whenever a proposal is created or updated to close it on time.
9952     event CloseProposalOnTime (
9953         uint256 indexed proposalId,
9954         uint256 time
9955     );
9956 
9957     /// @dev ActionSuccess event is called whenever an onchain action is executed.
9958     event ActionSuccess (
9959         uint256 proposalId
9960     );
9961 
9962     /// @dev Creates a new proposal
9963     /// @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
9964     /// @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
9965     function createProposal(
9966         string calldata _proposalTitle,
9967         string calldata _proposalSD,
9968         string calldata _proposalDescHash,
9969         uint _categoryId
9970     ) 
9971         external;
9972 
9973     /// @dev Edits the details of an existing proposal and creates new version
9974     /// @param _proposalId Proposal id that details needs to be updated
9975     /// @param _proposalDescHash Proposal description hash having long and short description of proposal.
9976     function updateProposal(
9977         uint _proposalId, 
9978         string calldata _proposalTitle, 
9979         string calldata _proposalSD, 
9980         string calldata _proposalDescHash
9981     ) 
9982         external;
9983 
9984     /// @dev Categorizes proposal to proceed further. Categories shows the proposal objective.
9985     function categorizeProposal(
9986         uint _proposalId, 
9987         uint _categoryId,
9988         uint _incentives
9989     ) 
9990         external;
9991 
9992     /// @dev Initiates add solution 
9993     /// @param _solutionHash Solution hash having required data against adding solution
9994     function addSolution(
9995         uint _proposalId,
9996         string calldata _solutionHash, 
9997         bytes calldata _action
9998     ) 
9999         external; 
10000 
10001     /// @dev Opens proposal for voting
10002     function openProposalForVoting(uint _proposalId) external;
10003 
10004     /// @dev Submit proposal with solution
10005     /// @param _proposalId Proposal id
10006     /// @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
10007     function submitProposalWithSolution(
10008         uint _proposalId, 
10009         string calldata _solutionHash, 
10010         bytes calldata _action
10011     ) 
10012         external;
10013 
10014     /// @dev Creates a new proposal with solution and votes for the solution
10015     /// @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
10016     /// @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
10017     /// @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
10018     function createProposalwithSolution(
10019         string calldata _proposalTitle, 
10020         string calldata _proposalSD, 
10021         string calldata _proposalDescHash,
10022         uint _categoryId, 
10023         string calldata _solutionHash, 
10024         bytes calldata _action
10025     ) 
10026         external;
10027 
10028     /// @dev Casts vote
10029     /// @param _proposalId Proposal id
10030     /// @param _solutionChosen solution chosen while voting. _solutionChosen[0] is the chosen solution
10031     function submitVote(uint _proposalId, uint _solutionChosen) external;
10032 
10033     function closeProposal(uint _proposalId) external;
10034 
10035     function claimReward(address _memberAddress, uint _maxRecords) external returns(uint pendingDAppReward); 
10036 
10037     function proposal(uint _proposalId)
10038         external
10039         view
10040         returns(
10041             uint proposalId,
10042             uint category,
10043             uint status,
10044             uint finalVerdict,
10045             uint totalReward
10046         );
10047 
10048     function canCloseProposal(uint _proposalId) public view returns(uint closeValue);
10049 
10050     function pauseProposal(uint _proposalId) public;
10051     
10052     function resumeProposal(uint _proposalId) public;
10053     
10054     function allowedToCatgorize() public view returns(uint roleId);
10055 
10056 }
10057 
10058 // /* Copyright (C) 2017 GovBlocks.io
10059 //   This program is free software: you can redistribute it and/or modify
10060 //     it under the terms of the GNU General Public License as published by
10061 //     the Free Software Foundation, either version 3 of the License, or
10062 //     (at your option) any later version.
10063 //   This program is distributed in the hope that it will be useful,
10064 //     but WITHOUT ANY WARRANTY; without even the implied warranty of
10065 //     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10066 //     GNU General Public License for more details.
10067 //   You should have received a copy of the GNU General Public License
10068 //     along with this program.  If not, see http://www.gnu.org/licenses/ */
10069 contract Governance is IGovernance, Iupgradable {
10070 
10071     using SafeMath for uint;
10072 
10073     enum ProposalStatus { 
10074         Draft,
10075         AwaitingSolution,
10076         VotingStarted,
10077         Accepted,
10078         Rejected,
10079         Majority_Not_Reached_But_Accepted,
10080         Denied
10081     }
10082 
10083     struct ProposalData {
10084         uint propStatus;
10085         uint finalVerdict;
10086         uint category;
10087         uint commonIncentive;
10088         uint dateUpd;
10089         address owner;
10090     }
10091 
10092     struct ProposalVote {
10093         address voter;
10094         uint proposalId;
10095         uint dateAdd;
10096     }
10097 
10098     struct VoteTally {
10099         mapping(uint=>uint) memberVoteValue;
10100         mapping(uint=>uint) abVoteValue;
10101         uint voters;
10102     }
10103 
10104     struct DelegateVote {
10105         address follower;
10106         address leader;
10107         uint lastUpd;
10108     }
10109 
10110     ProposalVote[] internal allVotes;
10111     DelegateVote[] public allDelegation;
10112 
10113     mapping(uint => ProposalData) internal allProposalData;
10114     mapping(uint => bytes[]) internal allProposalSolutions;
10115     mapping(address => uint[]) internal allVotesByMember;
10116     mapping(uint => mapping(address => bool)) public rewardClaimed;
10117     mapping (address => mapping(uint => uint)) public memberProposalVote;
10118     mapping (address => uint) public followerDelegation;
10119     mapping (address => uint) internal followerCount;
10120     mapping (address => uint[]) internal leaderDelegation;
10121     mapping (uint => VoteTally) public proposalVoteTally;
10122     mapping (address => bool) public isOpenForDelegation;
10123     mapping (address => uint) public lastRewardClaimed;
10124 
10125     bool internal constructorCheck;
10126     uint public tokenHoldingTime;
10127     uint internal roleIdAllowedToCatgorize;
10128     uint internal maxVoteWeigthPer;
10129     uint internal specialResolutionMajPerc;
10130     uint internal maxFollowers;
10131     uint internal totalProposals;
10132     uint internal maxDraftTime;
10133 
10134     MemberRoles internal memberRole;
10135     ProposalCategory internal proposalCategory;
10136     TokenController internal tokenInstance;
10137 
10138     mapping(uint => uint) public proposalActionStatus;
10139     mapping(uint => uint) internal proposalExecutionTime;
10140     mapping(uint => mapping(address => bool)) public proposalRejectedByAB;
10141     mapping(uint => uint) internal actionRejectedCount;
10142 
10143     bool internal actionParamsInitialised;
10144     uint internal actionWaitingTime;
10145     uint constant internal AB_MAJ_TO_REJECT_ACTION = 3;
10146 
10147     enum ActionStatus {
10148         Pending,
10149         Accepted,
10150         Rejected,
10151         Executed,
10152         NoAction
10153     }
10154 
10155     /**
10156     * @dev Called whenever an action execution is failed.
10157     */
10158     event ActionFailed (
10159         uint256 proposalId
10160     );
10161 
10162     /**
10163     * @dev Called whenever an AB member rejects the action execution.
10164     */
10165     event ActionRejected (
10166         uint256 indexed proposalId,
10167         address rejectedBy
10168     );
10169 
10170     /**
10171     * @dev Checks if msg.sender is proposal owner
10172     */
10173     modifier onlyProposalOwner(uint _proposalId) {
10174         require(msg.sender == allProposalData[_proposalId].owner, "Not allowed");
10175         _;
10176     }
10177 
10178     /**
10179     * @dev Checks if proposal is opened for voting
10180     */
10181     modifier voteNotStarted(uint _proposalId) {
10182         require(allProposalData[_proposalId].propStatus < uint(ProposalStatus.VotingStarted));
10183         _;
10184     }
10185 
10186     /**
10187     * @dev Checks if msg.sender is allowed to create proposal under given category
10188     */
10189     modifier isAllowed(uint _categoryId) {
10190         require(allowedToCreateProposal(_categoryId), "Not allowed");
10191         _;
10192     }
10193 
10194     /**
10195     * @dev Checks if msg.sender is allowed categorize proposal under given category
10196     */
10197     modifier isAllowedToCategorize() {
10198         require(memberRole.checkRole(msg.sender, roleIdAllowedToCatgorize), "Not allowed");
10199         _;
10200     }
10201 
10202     /**
10203     * @dev Checks if msg.sender had any pending rewards to be claimed
10204     */
10205     modifier checkPendingRewards {
10206         require(getPendingReward(msg.sender) == 0, "Claim reward");
10207         _;
10208     }
10209 
10210     /**
10211     * @dev Event emitted whenever a proposal is categorized
10212     */
10213     event ProposalCategorized(
10214         uint indexed proposalId,
10215         address indexed categorizedBy,
10216         uint categoryId
10217     );
10218     
10219     /**
10220      * @dev Removes delegation of an address.
10221      * @param _add address to undelegate.
10222      */
10223     function removeDelegation(address _add) external onlyInternal {
10224         _unDelegate(_add);
10225     }
10226 
10227     /**
10228     * @dev Creates a new proposal
10229     * @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
10230     * @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
10231     */
10232     function createProposal(
10233         string calldata _proposalTitle, 
10234         string calldata _proposalSD, 
10235         string calldata _proposalDescHash, 
10236         uint _categoryId
10237     ) 
10238         external isAllowed(_categoryId)
10239     {
10240         require(ms.isMember(msg.sender), "Not Member");
10241 
10242         _createProposal(_proposalTitle, _proposalSD, _proposalDescHash, _categoryId);
10243     }
10244 
10245     /**
10246     * @dev Edits the details of an existing proposal
10247     * @param _proposalId Proposal id that details needs to be updated
10248     * @param _proposalDescHash Proposal description hash having long and short description of proposal.
10249     */
10250     function updateProposal(
10251         uint _proposalId, 
10252         string calldata _proposalTitle, 
10253         string calldata _proposalSD, 
10254         string calldata _proposalDescHash
10255     ) 
10256         external onlyProposalOwner(_proposalId)
10257     {
10258         require(
10259             allProposalSolutions[_proposalId].length < 2,
10260             "Not allowed"
10261         );
10262         allProposalData[_proposalId].propStatus = uint(ProposalStatus.Draft);
10263         allProposalData[_proposalId].category = 0;
10264         allProposalData[_proposalId].commonIncentive = 0;
10265         emit Proposal(
10266             allProposalData[_proposalId].owner,
10267             _proposalId,
10268             now,
10269             _proposalTitle, 
10270             _proposalSD, 
10271             _proposalDescHash
10272         );
10273     }
10274 
10275     /**
10276     * @dev Categorizes proposal to proceed further. Categories shows the proposal objective.
10277     */
10278     function categorizeProposal(
10279         uint _proposalId,
10280         uint _categoryId,
10281         uint _incentive
10282     )
10283         external
10284         voteNotStarted(_proposalId) isAllowedToCategorize
10285     {
10286         _categorizeProposal(_proposalId, _categoryId, _incentive);
10287     }
10288 
10289     /**
10290     * @dev Initiates add solution
10291     * To implement the governance interface
10292     */
10293     function addSolution(uint, string calldata, bytes calldata) external {
10294     }
10295 
10296     /**
10297     * @dev Opens proposal for voting
10298     * To implement the governance interface
10299     */
10300     function openProposalForVoting(uint) external {
10301     }
10302 
10303     /**
10304     * @dev Submit proposal with solution
10305     * @param _proposalId Proposal id
10306     * @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
10307     */
10308     function submitProposalWithSolution(
10309         uint _proposalId, 
10310         string calldata _solutionHash, 
10311         bytes calldata _action
10312     ) 
10313         external
10314         onlyProposalOwner(_proposalId)
10315     {
10316 
10317         require(allProposalData[_proposalId].propStatus == uint(ProposalStatus.AwaitingSolution));
10318         
10319         _proposalSubmission(_proposalId, _solutionHash, _action);
10320     }
10321 
10322     /**
10323     * @dev Creates a new proposal with solution
10324     * @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
10325     * @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
10326     * @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
10327     */
10328     function createProposalwithSolution(
10329         string calldata _proposalTitle, 
10330         string calldata _proposalSD, 
10331         string calldata _proposalDescHash,
10332         uint _categoryId, 
10333         string calldata _solutionHash, 
10334         bytes calldata _action
10335     ) 
10336         external isAllowed(_categoryId)
10337     {
10338 
10339 
10340         uint proposalId = totalProposals;
10341 
10342         _createProposal(_proposalTitle, _proposalSD, _proposalDescHash, _categoryId);
10343         
10344         require(_categoryId > 0);
10345 
10346         _proposalSubmission(
10347             proposalId,
10348             _solutionHash,
10349             _action
10350         );
10351     }
10352 
10353     /**
10354      * @dev Submit a vote on the proposal.
10355      * @param _proposalId to vote upon.
10356      * @param _solutionChosen is the chosen vote.
10357      */
10358     function submitVote(uint _proposalId, uint _solutionChosen) external {
10359         
10360         require(allProposalData[_proposalId].propStatus == 
10361         uint(Governance.ProposalStatus.VotingStarted), "Not allowed");
10362 
10363         require(_solutionChosen < allProposalSolutions[_proposalId].length);
10364 
10365 
10366         _submitVote(_proposalId, _solutionChosen);
10367     }
10368 
10369     /**
10370      * @dev Closes the proposal.
10371      * @param _proposalId of proposal to be closed.
10372      */
10373     function closeProposal(uint _proposalId) external {
10374         uint category = allProposalData[_proposalId].category;
10375         
10376         
10377         uint _memberRole;
10378         if (allProposalData[_proposalId].dateUpd.add(maxDraftTime) <= now && 
10379             allProposalData[_proposalId].propStatus < uint(ProposalStatus.VotingStarted)) {
10380             _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
10381         } else {
10382             require(canCloseProposal(_proposalId) == 1);
10383             (, _memberRole, , , , , ) = proposalCategory.category(allProposalData[_proposalId].category);
10384             if (_memberRole == uint(MemberRoles.Role.AdvisoryBoard)) {
10385                 _closeAdvisoryBoardVote(_proposalId, category);
10386             } else {
10387                 _closeMemberVote(_proposalId, category);
10388             }
10389         }
10390         
10391     }
10392 
10393     /**
10394      * @dev Claims reward for member.
10395      * @param _memberAddress to claim reward of.
10396      * @param _maxRecords maximum number of records to claim reward for.
10397      _proposals list of proposals of which reward will be claimed.
10398      * @return amount of pending reward.
10399      */
10400     function claimReward(address _memberAddress, uint _maxRecords) 
10401         external returns(uint pendingDAppReward) 
10402     {
10403         
10404         uint voteId;
10405         address leader;
10406         uint lastUpd;
10407 
10408         require(msg.sender == ms.getLatestAddress("CR"));
10409 
10410         uint delegationId = followerDelegation[_memberAddress];
10411         DelegateVote memory delegationData = allDelegation[delegationId];
10412         if (delegationId > 0 && delegationData.leader != address(0)) {
10413             leader = delegationData.leader;
10414             lastUpd = delegationData.lastUpd;
10415         } else
10416             leader = _memberAddress;
10417 
10418         uint proposalId;
10419         uint totalVotes = allVotesByMember[leader].length;
10420         uint lastClaimed = totalVotes;
10421         uint j;
10422         uint i;
10423         for (i = lastRewardClaimed[_memberAddress]; i < totalVotes && j < _maxRecords; i++) {
10424             voteId = allVotesByMember[leader][i];
10425             proposalId = allVotes[voteId].proposalId;
10426             if (proposalVoteTally[proposalId].voters > 0 && (allVotes[voteId].dateAdd > (
10427                 lastUpd.add(tokenHoldingTime)) || leader == _memberAddress)) {
10428                 if (allProposalData[proposalId].propStatus > uint(ProposalStatus.VotingStarted)) {
10429                     if (!rewardClaimed[voteId][_memberAddress]) {
10430                         pendingDAppReward = pendingDAppReward.add(
10431                                 allProposalData[proposalId].commonIncentive.div(
10432                                     proposalVoteTally[proposalId].voters
10433                                 )
10434                             );
10435                         rewardClaimed[voteId][_memberAddress] = true;
10436                         j++;
10437                     }
10438                 } else {
10439                     if (lastClaimed == totalVotes) {
10440                         lastClaimed = i;
10441                     }
10442                 }
10443             }
10444         }
10445 
10446         if (lastClaimed == totalVotes) {
10447             lastRewardClaimed[_memberAddress] = i;
10448         } else {
10449             lastRewardClaimed[_memberAddress] = lastClaimed;
10450         }
10451 
10452         if (j > 0) {
10453             emit RewardClaimed(
10454                 _memberAddress,
10455                 pendingDAppReward
10456             );
10457         }
10458     }
10459 
10460     /**
10461      * @dev Sets delegation acceptance status of individual user
10462      * @param _status delegation acceptance status
10463      */
10464     function setDelegationStatus(bool _status) external isMemberAndcheckPause checkPendingRewards {
10465         isOpenForDelegation[msg.sender] = _status;
10466     }
10467 
10468     /**
10469      * @dev Delegates vote to an address.
10470      * @param _add is the address to delegate vote to.
10471      */
10472     function delegateVote(address _add) external isMemberAndcheckPause checkPendingRewards {
10473 
10474         require(ms.masterInitialized());
10475 
10476         require(allDelegation[followerDelegation[_add]].leader == address(0));
10477 
10478         if (followerDelegation[msg.sender] > 0) {
10479             require((allDelegation[followerDelegation[msg.sender]].lastUpd).add(tokenHoldingTime) < now);
10480         }
10481 
10482         require(!alreadyDelegated(msg.sender));
10483         require(!memberRole.checkRole(msg.sender, uint(MemberRoles.Role.Owner)));
10484         require(!memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)));
10485 
10486 
10487         require(followerCount[_add] < maxFollowers);
10488         
10489         if (allVotesByMember[msg.sender].length > 0) {
10490             require((allVotes[allVotesByMember[msg.sender][allVotesByMember[msg.sender].length - 1]].dateAdd).add(tokenHoldingTime)
10491             < now);
10492         }
10493 
10494         require(ms.isMember(_add));
10495 
10496         require(isOpenForDelegation[_add]);
10497 
10498         allDelegation.push(DelegateVote(msg.sender, _add, now));
10499         followerDelegation[msg.sender] = allDelegation.length - 1;
10500         leaderDelegation[_add].push(allDelegation.length - 1);
10501         followerCount[_add]++;
10502         lastRewardClaimed[msg.sender] = allVotesByMember[_add].length;
10503     }
10504 
10505     /**
10506      * @dev Undelegates the sender
10507      */
10508     function unDelegate() external isMemberAndcheckPause checkPendingRewards {
10509         _unDelegate(msg.sender);
10510     }
10511 
10512     /**
10513      * @dev Triggers action of accepted proposal after waiting time is finished
10514      */
10515     function triggerAction(uint _proposalId) external {
10516         require(proposalActionStatus[_proposalId] == uint(ActionStatus.Accepted) && proposalExecutionTime[_proposalId] <= now, "Cannot trigger");
10517         _triggerAction(_proposalId, allProposalData[_proposalId].category);
10518     }
10519 
10520     /**
10521      * @dev Provides option to Advisory board member to reject proposal action execution within actionWaitingTime, if found suspicious
10522      */
10523     function rejectAction(uint _proposalId) external {
10524         require(memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)) && proposalExecutionTime[_proposalId] > now);
10525 
10526         require(proposalActionStatus[_proposalId] == uint(ActionStatus.Accepted));
10527 
10528         require(!proposalRejectedByAB[_proposalId][msg.sender]);
10529 
10530         require(
10531             keccak256(proposalCategory.categoryActionHashes(allProposalData[_proposalId].category))
10532             != keccak256(abi.encodeWithSignature("swapABMember(address,address)"))
10533         );
10534 
10535         proposalRejectedByAB[_proposalId][msg.sender] = true;
10536         actionRejectedCount[_proposalId]++;
10537         emit ActionRejected(_proposalId, msg.sender);
10538         if (actionRejectedCount[_proposalId] == AB_MAJ_TO_REJECT_ACTION) {
10539             proposalActionStatus[_proposalId] = uint(ActionStatus.Rejected);
10540         }
10541     }
10542 
10543     /**
10544      * @dev Sets intial actionWaitingTime value
10545      * To be called after governance implementation has been updated
10546      */
10547     function setInitialActionParameters() external onlyOwner {
10548         require(!actionParamsInitialised);
10549         actionParamsInitialised = true;
10550         actionWaitingTime = 24 * 1 hours;
10551     }
10552 
10553     /**
10554      * @dev Gets Uint Parameters of a code
10555      * @param code whose details we want
10556      * @return string value of the code
10557      * @return associated amount (time or perc or value) to the code
10558      */
10559     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
10560 
10561         codeVal = code;
10562 
10563         if (code == "GOVHOLD") {
10564 
10565             val = tokenHoldingTime / (1 days);
10566 
10567         } else if (code == "MAXFOL") {
10568 
10569             val = maxFollowers;
10570 
10571         } else if (code == "MAXDRFT") {
10572 
10573             val = maxDraftTime / (1 days);
10574 
10575         } else if (code == "EPTIME") {
10576 
10577             val = ms.pauseTime() / (1 days);
10578 
10579         } else if (code == "ACWT") {
10580 
10581             val = actionWaitingTime / (1 hours);
10582 
10583         }
10584     }
10585 
10586     /**
10587      * @dev Gets all details of a propsal
10588      * @param _proposalId whose details we want
10589      * @return proposalId
10590      * @return category
10591      * @return status
10592      * @return finalVerdict
10593      * @return totalReward
10594      */
10595     function proposal(uint _proposalId)
10596         external
10597         view
10598         returns(
10599             uint proposalId,
10600             uint category,
10601             uint status,
10602             uint finalVerdict,
10603             uint totalRewar
10604         )
10605     {
10606         return(
10607             _proposalId,
10608             allProposalData[_proposalId].category,
10609             allProposalData[_proposalId].propStatus,
10610             allProposalData[_proposalId].finalVerdict,
10611             allProposalData[_proposalId].commonIncentive
10612         );
10613     }
10614 
10615     /**
10616      * @dev Gets some details of a propsal
10617      * @param _proposalId whose details we want
10618      * @return proposalId
10619      * @return number of all proposal solutions
10620      * @return amount of votes 
10621      */
10622     function proposalDetails(uint _proposalId) external view returns(uint, uint, uint) {
10623         return(
10624             _proposalId,
10625             allProposalSolutions[_proposalId].length,
10626             proposalVoteTally[_proposalId].voters
10627         );
10628     }
10629 
10630     /**
10631      * @dev Gets solution action on a proposal
10632      * @param _proposalId whose details we want
10633      * @param _solution whose details we want
10634      * @return action of a solution on a proposal
10635      */
10636     function getSolutionAction(uint _proposalId, uint _solution) external view returns(uint, bytes memory) {
10637         return (
10638             _solution,
10639             allProposalSolutions[_proposalId][_solution]
10640         );
10641     }
10642    
10643     /**
10644      * @dev Gets length of propsal
10645      * @return length of propsal
10646      */
10647     function getProposalLength() external view returns(uint) {
10648         return totalProposals;
10649     }
10650 
10651     /**
10652      * @dev Get followers of an address
10653      * @return get followers of an address
10654      */
10655     function getFollowers(address _add) external view returns(uint[] memory) {
10656         return leaderDelegation[_add];
10657     }
10658 
10659     /**
10660      * @dev Gets pending rewards of a member
10661      * @param _memberAddress in concern
10662      * @return amount of pending reward
10663      */
10664     function getPendingReward(address _memberAddress)
10665         public view returns(uint pendingDAppReward)
10666     {
10667         uint delegationId = followerDelegation[_memberAddress];
10668         address leader;
10669         uint lastUpd;
10670         DelegateVote memory delegationData = allDelegation[delegationId];
10671 
10672         if (delegationId > 0 && delegationData.leader != address(0)) {
10673             leader = delegationData.leader;
10674             lastUpd = delegationData.lastUpd;
10675         } else
10676             leader = _memberAddress;
10677 
10678         uint proposalId;
10679         for (uint i = lastRewardClaimed[_memberAddress]; i < allVotesByMember[leader].length; i++) {
10680             if (allVotes[allVotesByMember[leader][i]].dateAdd > (
10681                 lastUpd.add(tokenHoldingTime)) || leader == _memberAddress) {
10682                 if (!rewardClaimed[allVotesByMember[leader][i]][_memberAddress]) {
10683                     proposalId = allVotes[allVotesByMember[leader][i]].proposalId;
10684                     if (proposalVoteTally[proposalId].voters > 0 && allProposalData[proposalId].propStatus
10685                     > uint(ProposalStatus.VotingStarted)) {
10686                         pendingDAppReward = pendingDAppReward.add(
10687                             allProposalData[proposalId].commonIncentive.div(
10688                                 proposalVoteTally[proposalId].voters
10689                             )
10690                         );
10691                     }
10692                 }
10693             }
10694         }
10695     }
10696 
10697     /**
10698      * @dev Updates Uint Parameters of a code
10699      * @param code whose details we want to update
10700      * @param val value to set
10701      */
10702     function updateUintParameters(bytes8 code, uint val) public {
10703 
10704         require(ms.checkIsAuthToGoverned(msg.sender));
10705         if (code == "GOVHOLD") {
10706 
10707             tokenHoldingTime = val * 1 days;
10708 
10709         } else if (code == "MAXFOL") {
10710 
10711             maxFollowers = val;
10712 
10713         } else if (code == "MAXDRFT") {
10714 
10715             maxDraftTime = val * 1 days;
10716 
10717         } else if (code == "EPTIME") {
10718 
10719             ms.updatePauseTime(val * 1 days);
10720 
10721         } else if (code == "ACWT") {
10722 
10723             actionWaitingTime = val * 1 hours;
10724 
10725         } else {
10726 
10727             revert("Invalid code");
10728 
10729         }
10730     }
10731 
10732     /**
10733     * @dev Updates all dependency addresses to latest ones from Master
10734     */
10735     function changeDependentContractAddress() public {
10736         tokenInstance = TokenController(ms.dAppLocker());
10737         memberRole = MemberRoles(ms.getLatestAddress("MR"));
10738         proposalCategory = ProposalCategory(ms.getLatestAddress("PC"));
10739     }
10740 
10741     /**
10742     * @dev Checks if msg.sender is allowed to create a proposal under given category
10743     */
10744     function allowedToCreateProposal(uint category) public view returns(bool check) {
10745         if (category == 0)
10746             return true;
10747         uint[] memory mrAllowed;
10748         (, , , , mrAllowed, , ) = proposalCategory.category(category);
10749         for (uint i = 0; i < mrAllowed.length; i++) {
10750             if (mrAllowed[i] == 0 || memberRole.checkRole(msg.sender, mrAllowed[i]))
10751                 return true;
10752         }
10753     }
10754 
10755     /**
10756      * @dev Checks if an address is already delegated
10757      * @param _add in concern
10758      * @return bool value if the address is delegated or not
10759      */
10760     function alreadyDelegated(address _add) public view returns(bool delegated) {
10761         for (uint i=0; i < leaderDelegation[_add].length; i++) {
10762             if (allDelegation[leaderDelegation[_add][i]].leader == _add) {
10763                 return true;
10764             }
10765         }
10766     }
10767 
10768     /**
10769     * @dev Pauses a proposal
10770     * To implement govblocks interface
10771     */
10772     function pauseProposal(uint) public {
10773     }
10774 
10775     /**
10776     * @dev Resumes a proposal
10777     * To implement govblocks interface
10778     */
10779     function resumeProposal(uint) public {
10780     }
10781 
10782     /**
10783     * @dev Checks If the proposal voting time is up and it's ready to close 
10784     *      i.e. Closevalue is 1 if proposal is ready to be closed, 2 if already closed, 0 otherwise!
10785     * @param _proposalId Proposal id to which closing value is being checked
10786     */
10787     function canCloseProposal(uint _proposalId) 
10788         public 
10789         view 
10790         returns(uint)
10791     {
10792         uint dateUpdate;
10793         uint pStatus;
10794         uint _closingTime;
10795         uint _roleId;
10796         uint majority;
10797         pStatus = allProposalData[_proposalId].propStatus;
10798         dateUpdate = allProposalData[_proposalId].dateUpd;
10799         (, _roleId, majority, , , _closingTime, ) = proposalCategory.category(allProposalData[_proposalId].category);
10800         if (
10801             pStatus == uint(ProposalStatus.VotingStarted)
10802         ) {
10803             uint numberOfMembers = memberRole.numberOfMembers(_roleId);
10804             if (_roleId == uint(MemberRoles.Role.AdvisoryBoard)) {
10805                 if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100).div(numberOfMembers) >= majority  
10806                 || proposalVoteTally[_proposalId].abVoteValue[1].add(proposalVoteTally[_proposalId].abVoteValue[0]) == numberOfMembers
10807                 || dateUpdate.add(_closingTime) <= now) {
10808 
10809                     return 1;
10810                 }
10811             } else {
10812                 if (numberOfMembers == proposalVoteTally[_proposalId].voters 
10813                 || dateUpdate.add(_closingTime) <= now)
10814                     return  1;
10815             }
10816         } else if (pStatus > uint(ProposalStatus.VotingStarted)) {
10817             return  2;
10818         } else {
10819             return  0;
10820         }
10821     }
10822 
10823     /**
10824      * @dev Gets Id of member role allowed to categorize the proposal
10825      * @return roleId allowed to categorize the proposal
10826      */
10827     function allowedToCatgorize() public view returns(uint roleId) {
10828         return roleIdAllowedToCatgorize;
10829     }
10830 
10831     /**
10832      * @dev Gets vote tally data
10833      * @param _proposalId in concern
10834      * @param _solution of a proposal id
10835      * @return member vote value
10836      * @return advisory board vote value
10837      * @return amount of votes
10838      */
10839     function voteTallyData(uint _proposalId, uint _solution) public view returns(uint, uint, uint) {
10840         return (proposalVoteTally[_proposalId].memberVoteValue[_solution],
10841             proposalVoteTally[_proposalId].abVoteValue[_solution], proposalVoteTally[_proposalId].voters);
10842     }
10843 
10844     /**
10845      * @dev Internal call to create proposal
10846      * @param _proposalTitle of proposal
10847      * @param _proposalSD is short description of proposal
10848      * @param _proposalDescHash IPFS hash value of propsal
10849      * @param _categoryId of proposal
10850      */
10851     function _createProposal(
10852         string memory _proposalTitle,
10853         string memory _proposalSD,
10854         string memory _proposalDescHash,
10855         uint _categoryId
10856     )
10857         internal
10858     {
10859         require(proposalCategory.categoryABReq(_categoryId) == 0 || _categoryId == 0);
10860         uint _proposalId = totalProposals;
10861         allProposalData[_proposalId].owner = msg.sender;
10862         allProposalData[_proposalId].dateUpd = now;
10863         allProposalSolutions[_proposalId].push("");
10864         totalProposals++;
10865 
10866         emit Proposal(
10867             msg.sender,
10868             _proposalId,
10869             now,
10870             _proposalTitle,
10871             _proposalSD,
10872             _proposalDescHash
10873         );
10874 
10875         if (_categoryId > 0)
10876             _categorizeProposal(_proposalId, _categoryId, 0);
10877     }
10878 
10879     /**
10880      * @dev Internal call to categorize a proposal
10881      * @param _proposalId of proposal
10882      * @param _categoryId of proposal
10883      * @param _incentive is commonIncentive
10884      */
10885     function _categorizeProposal(
10886         uint _proposalId,
10887         uint _categoryId,
10888         uint _incentive
10889     )
10890         internal
10891     {
10892         require(
10893             _categoryId > 0 && _categoryId < proposalCategory.totalCategories(),
10894             "Invalid category"
10895         );
10896         allProposalData[_proposalId].category = _categoryId;
10897         allProposalData[_proposalId].commonIncentive = _incentive;
10898         allProposalData[_proposalId].propStatus = uint(ProposalStatus.AwaitingSolution);
10899 
10900         emit ProposalCategorized(_proposalId, msg.sender, _categoryId);
10901     }
10902 
10903     /**
10904      * @dev Internal call to add solution to a proposal
10905      * @param _proposalId in concern
10906      * @param _action on that solution
10907      * @param _solutionHash string value
10908      */
10909     function _addSolution(uint _proposalId, bytes memory _action, string memory _solutionHash)
10910         internal
10911     {
10912         allProposalSolutions[_proposalId].push(_action);
10913         emit Solution(_proposalId, msg.sender, allProposalSolutions[_proposalId].length - 1, _solutionHash, now);
10914     }
10915 
10916     /**
10917     * @dev Internal call to add solution and open proposal for voting
10918     */
10919     function _proposalSubmission(
10920         uint _proposalId,
10921         string memory _solutionHash,
10922         bytes memory _action
10923     )
10924         internal
10925     {
10926 
10927         uint _categoryId = allProposalData[_proposalId].category;
10928         if (proposalCategory.categoryActionHashes(_categoryId).length == 0) {
10929             require(keccak256(_action) == keccak256(""));
10930             proposalActionStatus[_proposalId] = uint(ActionStatus.NoAction);
10931         }
10932         
10933         _addSolution(
10934             _proposalId,
10935             _action,
10936             _solutionHash
10937         );
10938 
10939         _updateProposalStatus(_proposalId, uint(ProposalStatus.VotingStarted));
10940         (, , , , , uint closingTime, ) = proposalCategory.category(_categoryId);
10941         emit CloseProposalOnTime(_proposalId, closingTime.add(now));
10942 
10943     }
10944 
10945     /**
10946      * @dev Internal call to submit vote
10947      * @param _proposalId of proposal in concern
10948      * @param _solution for that proposal
10949      */
10950     function _submitVote(uint _proposalId, uint _solution) internal {
10951 
10952         uint delegationId = followerDelegation[msg.sender];
10953         uint mrSequence;
10954         uint majority;
10955         uint closingTime;
10956         (, mrSequence, majority, , , closingTime, ) = proposalCategory.category(allProposalData[_proposalId].category);
10957 
10958         require(allProposalData[_proposalId].dateUpd.add(closingTime) > now, "Closed");
10959 
10960         require(memberProposalVote[msg.sender][_proposalId] == 0, "Not allowed");
10961         require((delegationId == 0) || (delegationId > 0 && allDelegation[delegationId].leader == address(0) && 
10962         _checkLastUpd(allDelegation[delegationId].lastUpd)));
10963 
10964         require(memberRole.checkRole(msg.sender, mrSequence), "Not Authorized");
10965         uint totalVotes = allVotes.length;
10966 
10967         allVotesByMember[msg.sender].push(totalVotes);
10968         memberProposalVote[msg.sender][_proposalId] = totalVotes;
10969 
10970         allVotes.push(ProposalVote(msg.sender, _proposalId, now));
10971 
10972         emit Vote(msg.sender, _proposalId, totalVotes, now, _solution);
10973         if (mrSequence == uint(MemberRoles.Role.Owner)) {
10974             if (_solution == 1)
10975                 _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), allProposalData[_proposalId].category, 1, MemberRoles.Role.Owner);
10976             else
10977                 _updateProposalStatus(_proposalId, uint(ProposalStatus.Rejected));
10978         
10979         } else {
10980             uint numberOfMembers = memberRole.numberOfMembers(mrSequence);
10981             _setVoteTally(_proposalId, _solution, mrSequence);
10982 
10983             if (mrSequence == uint(MemberRoles.Role.AdvisoryBoard)) {
10984                 if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100).div(numberOfMembers) 
10985                 >= majority 
10986                 || (proposalVoteTally[_proposalId].abVoteValue[1].add(proposalVoteTally[_proposalId].abVoteValue[0])) == numberOfMembers) {
10987                     emit VoteCast(_proposalId);
10988                 }
10989             } else {
10990                 if (numberOfMembers == proposalVoteTally[_proposalId].voters)
10991                     emit VoteCast(_proposalId);
10992             }
10993         }
10994 
10995     }
10996 
10997     /**
10998      * @dev Internal call to set vote tally of a proposal
10999      * @param _proposalId of proposal in concern
11000      * @param _solution of proposal in concern
11001      * @param mrSequence number of members for a role
11002      */
11003     function _setVoteTally(uint _proposalId, uint _solution, uint mrSequence) internal
11004     {
11005         uint categoryABReq;
11006         uint isSpecialResolution;
11007         (, categoryABReq, isSpecialResolution) = proposalCategory.categoryExtendedData(allProposalData[_proposalId].category);
11008         if (memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)) && (categoryABReq > 0) || 
11009             mrSequence == uint(MemberRoles.Role.AdvisoryBoard)) {
11010             proposalVoteTally[_proposalId].abVoteValue[_solution]++;
11011         }
11012         tokenInstance.lockForMemberVote(msg.sender, tokenHoldingTime);
11013         if (mrSequence != uint(MemberRoles.Role.AdvisoryBoard)) {
11014             uint voteWeight;
11015             uint voters = 1;
11016             uint tokenBalance = tokenInstance.totalBalanceOf(msg.sender);
11017             uint totalSupply = tokenInstance.totalSupply();
11018             if (isSpecialResolution == 1) {
11019                 voteWeight = tokenBalance.add(10**18);
11020             } else {
11021                 voteWeight = (_minOf(tokenBalance, maxVoteWeigthPer.mul(totalSupply).div(100))).add(10**18);
11022             }
11023             DelegateVote memory delegationData;
11024             for (uint i = 0; i < leaderDelegation[msg.sender].length; i++) {
11025                 delegationData = allDelegation[leaderDelegation[msg.sender][i]];
11026                 if (delegationData.leader == msg.sender && 
11027                 _checkLastUpd(delegationData.lastUpd)) {
11028                     if (memberRole.checkRole(delegationData.follower, mrSequence)) {
11029                         tokenBalance = tokenInstance.totalBalanceOf(delegationData.follower);
11030                         tokenInstance.lockForMemberVote(delegationData.follower, tokenHoldingTime);
11031                         voters++;
11032                         if (isSpecialResolution == 1) {
11033                             voteWeight = voteWeight.add(tokenBalance.add(10**18));
11034                         } else {
11035                             voteWeight = voteWeight.add((_minOf(tokenBalance, maxVoteWeigthPer.mul(totalSupply).div(100))).add(10**18));
11036                         }
11037                     }
11038                 }
11039             }
11040             proposalVoteTally[_proposalId].memberVoteValue[_solution] = proposalVoteTally[_proposalId].memberVoteValue[_solution].add(voteWeight);
11041             proposalVoteTally[_proposalId].voters = proposalVoteTally[_proposalId].voters + voters;
11042         }
11043     }
11044 
11045     /**
11046      * @dev Gets minimum of two numbers
11047      * @param a one of the two numbers
11048      * @param b one of the two numbers
11049      * @return minimum number out of the two
11050      */
11051     function _minOf(uint a, uint b) internal pure returns(uint res) {
11052         res = a;
11053         if (res > b)
11054             res = b;
11055     }
11056     
11057     /**
11058      * @dev Check the time since last update has exceeded token holding time or not
11059      * @param _lastUpd is last update time
11060      * @return the bool which tells if the time since last update has exceeded token holding time or not
11061      */
11062     function _checkLastUpd(uint _lastUpd) internal view returns(bool) {
11063         return (now - _lastUpd) > tokenHoldingTime;
11064     }
11065 
11066     /**
11067     * @dev Checks if the vote count against any solution passes the threshold value or not.
11068     */
11069     function _checkForThreshold(uint _proposalId, uint _category) internal view returns(bool check) {
11070         uint categoryQuorumPerc;
11071         uint roleAuthorized;
11072         (, roleAuthorized, , categoryQuorumPerc, , , ) = proposalCategory.category(_category);
11073         check = ((proposalVoteTally[_proposalId].memberVoteValue[0]
11074                             .add(proposalVoteTally[_proposalId].memberVoteValue[1]))
11075                         .mul(100))
11076                 .div(
11077                     tokenInstance.totalSupply().add(
11078                         memberRole.numberOfMembers(roleAuthorized).mul(10 ** 18)
11079                     )
11080                 ) >= categoryQuorumPerc;
11081     }
11082     
11083     /**
11084      * @dev Called when vote majority is reached
11085      * @param _proposalId of proposal in concern
11086      * @param _status of proposal in concern
11087      * @param category of proposal in concern
11088      * @param max vote value of proposal in concern
11089      */
11090     function _callIfMajReached(uint _proposalId, uint _status, uint category, uint max, MemberRoles.Role role) internal {
11091         
11092         allProposalData[_proposalId].finalVerdict = max;
11093         _updateProposalStatus(_proposalId, _status);
11094         emit ProposalAccepted(_proposalId);
11095         if (proposalActionStatus[_proposalId] != uint(ActionStatus.NoAction)) {
11096             if (role == MemberRoles.Role.AdvisoryBoard) {
11097                 _triggerAction(_proposalId, category);
11098             } else {
11099                 proposalActionStatus[_proposalId] = uint(ActionStatus.Accepted);
11100                 proposalExecutionTime[_proposalId] = actionWaitingTime.add(now);
11101             }
11102         }
11103     }
11104 
11105     /**
11106      * @dev Internal function to trigger action of accepted proposal
11107      */
11108     function _triggerAction(uint _proposalId, uint _categoryId) internal {
11109         proposalActionStatus[_proposalId] = uint(ActionStatus.Executed);
11110         bytes2 contractName;
11111         address actionAddress;
11112         bytes memory _functionHash;
11113         (, actionAddress, contractName, , _functionHash) = proposalCategory.categoryActionDetails(_categoryId);
11114         if (contractName == "MS") {
11115             actionAddress = address(ms);
11116         } else if (contractName != "EX") {
11117             actionAddress = ms.getLatestAddress(contractName);
11118         }
11119         (bool actionStatus, ) = actionAddress.call(abi.encodePacked(_functionHash, allProposalSolutions[_proposalId][1]));
11120         if (actionStatus) {
11121             emit ActionSuccess(_proposalId);
11122         } else {
11123             proposalActionStatus[_proposalId] = uint(ActionStatus.Accepted);
11124             emit ActionFailed(_proposalId);
11125         }
11126     }
11127 
11128     /**
11129      * @dev Internal call to update proposal status
11130      * @param _proposalId of proposal in concern
11131      * @param _status of proposal to set
11132      */
11133     function _updateProposalStatus(uint _proposalId, uint _status) internal {
11134         if (_status == uint(ProposalStatus.Rejected) || _status == uint(ProposalStatus.Denied)) {
11135             proposalActionStatus[_proposalId] = uint(ActionStatus.NoAction);   
11136         }
11137         allProposalData[_proposalId].dateUpd = now;
11138         allProposalData[_proposalId].propStatus = _status;
11139     }
11140 
11141     /**
11142      * @dev Internal call to undelegate a follower
11143      * @param _follower is address of follower to undelegate
11144      */
11145     function _unDelegate(address _follower) internal {
11146         uint followerId = followerDelegation[_follower];
11147         if (followerId > 0) {
11148 
11149             followerCount[allDelegation[followerId].leader] = followerCount[allDelegation[followerId].leader].sub(1);
11150             allDelegation[followerId].leader = address(0);
11151             allDelegation[followerId].lastUpd = now;
11152 
11153             lastRewardClaimed[_follower] = allVotesByMember[_follower].length;
11154         }
11155     }
11156 
11157     /**
11158      * @dev Internal call to close member voting
11159      * @param _proposalId of proposal in concern
11160      * @param category of proposal in concern
11161      */
11162     function _closeMemberVote(uint _proposalId, uint category) internal {
11163         uint isSpecialResolution;
11164         uint abMaj;
11165         (, abMaj, isSpecialResolution) = proposalCategory.categoryExtendedData(category);
11166         if (isSpecialResolution == 1) {
11167             uint acceptedVotePerc = proposalVoteTally[_proposalId].memberVoteValue[1].mul(100)
11168             .div(
11169                 tokenInstance.totalSupply().add(
11170                         memberRole.numberOfMembers(uint(MemberRoles.Role.Member)).mul(10**18)
11171                     ));
11172             if (acceptedVotePerc >= specialResolutionMajPerc) {
11173                 _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
11174             } else {
11175                 _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
11176             }
11177         } else {
11178             if (_checkForThreshold(_proposalId, category)) {
11179                 uint majorityVote;
11180                 (, , majorityVote, , , , ) = proposalCategory.category(category);
11181                 if (
11182                     ((proposalVoteTally[_proposalId].memberVoteValue[1].mul(100))
11183                                         .div(proposalVoteTally[_proposalId].memberVoteValue[0]
11184                                                 .add(proposalVoteTally[_proposalId].memberVoteValue[1])
11185                                         ))
11186                     >= majorityVote
11187                     ) {
11188                         _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
11189                     } else {
11190                         _updateProposalStatus(_proposalId, uint(ProposalStatus.Rejected));
11191                     }
11192             } else {
11193                 if (abMaj > 0 && proposalVoteTally[_proposalId].abVoteValue[1].mul(100)
11194                 .div(memberRole.numberOfMembers(uint(MemberRoles.Role.AdvisoryBoard))) >= abMaj) {
11195                     _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
11196                 } else {
11197                     _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
11198                 }
11199             }
11200         }
11201 
11202         if (proposalVoteTally[_proposalId].voters > 0) {
11203             tokenInstance.mint(ms.getLatestAddress("CR"), allProposalData[_proposalId].commonIncentive);
11204         }
11205     }
11206 
11207     /**
11208      * @dev Internal call to close advisory board voting
11209      * @param _proposalId of proposal in concern
11210      * @param category of proposal in concern
11211      */
11212     function _closeAdvisoryBoardVote(uint _proposalId, uint category) internal {
11213         uint _majorityVote;
11214         MemberRoles.Role _roleId = MemberRoles.Role.AdvisoryBoard;
11215         (, , _majorityVote, , , , ) = proposalCategory.category(category);
11216         if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100)
11217         .div(memberRole.numberOfMembers(uint(_roleId))) >= _majorityVote) {
11218             _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, _roleId);
11219         } else {
11220             _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
11221         }
11222 
11223     }
11224 
11225 }
11226 
11227 /* Copyright (C) 2020 NexusMutual.io
11228 
11229   This program is free software: you can redistribute it and/or modify
11230     it under the terms of the GNU General Public License as published by
11231     the Free Software Foundation, either version 3 of the License, or
11232     (at your option) any later version.
11233 
11234   This program is distributed in the hope that it will be useful,
11235     but WITHOUT ANY WARRANTY; without even the implied warranty of
11236     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11237     GNU General Public License for more details.
11238 
11239   You should have received a copy of the GNU General Public License
11240     along with this program.  If not, see http://www.gnu.org/licenses/ */
11241 contract TokenFunctions is Iupgradable {
11242     using SafeMath for uint;
11243 
11244     MCR internal m1;
11245     MemberRoles internal mr;
11246     NXMToken public tk;
11247     TokenController internal tc;
11248     TokenData internal td;
11249     QuotationData internal qd;
11250     ClaimsReward internal cr;
11251     Governance internal gv;
11252     PoolData internal pd;
11253     IPooledStaking pooledStaking;
11254 
11255     event BurnCATokens(uint claimId, address addr, uint amount);
11256 
11257     /**
11258      * @dev Rewards stakers on purchase of cover on smart contract.
11259      * @param _contractAddress smart contract address.
11260      * @param _coverPriceNXM cover price in NXM.
11261      */
11262     function pushStakerRewards(address _contractAddress, uint _coverPriceNXM) external onlyInternal {
11263         uint rewardValue = _coverPriceNXM.mul(td.stakerCommissionPer()).div(100);
11264         pooledStaking.pushReward(_contractAddress, rewardValue);
11265     }
11266 
11267     /**
11268     * @dev Deprecated in favor of burnStakedTokens
11269     */
11270     function burnStakerLockedToken(uint, bytes4, uint) external {
11271         // noop
11272     }
11273 
11274     /**
11275     * @dev Burns tokens staked on smart contract covered by coverId. Called when a payout is succesfully executed.
11276     * @param coverId cover id
11277     * @param coverCurrency cover currency
11278     * @param sumAssured amount of $curr to burn
11279     */
11280     function burnStakedTokens(uint coverId, bytes4 coverCurrency, uint sumAssured) external onlyInternal {
11281         (, address scAddress) = qd.getscAddressOfCover(coverId);
11282         uint tokenPrice = m1.calculateTokenPrice(coverCurrency);
11283         uint burnNXMAmount = sumAssured.mul(1e18).div(tokenPrice);
11284         pooledStaking.pushBurn(scAddress, burnNXMAmount);
11285     }
11286 
11287     /**
11288      * @dev Gets the total staked NXM tokens against
11289      * Smart contract by all stakers
11290      * @param _stakedContractAddress smart contract address.
11291      * @return amount total staked NXM tokens.
11292      */
11293     function deprecated_getTotalStakedTokensOnSmartContract(
11294         address _stakedContractAddress
11295     )
11296         external
11297         view
11298         returns(uint)
11299     {
11300         uint stakedAmount = 0;
11301         address stakerAddress;
11302         uint staketLen = td.getStakedContractStakersLength(_stakedContractAddress);
11303 
11304         for (uint i = 0; i < staketLen; i++) {
11305             stakerAddress = td.getStakedContractStakerByIndex(_stakedContractAddress, i);
11306             uint stakerIndex = td.getStakedContractStakerIndex(
11307                 _stakedContractAddress, i);
11308             uint currentlyStaked;
11309             (, currentlyStaked) = _deprecated_unlockableBeforeBurningAndCanBurn(stakerAddress,
11310                 _stakedContractAddress, stakerIndex);
11311             stakedAmount = stakedAmount.add(currentlyStaked);
11312         }
11313 
11314         return stakedAmount;
11315     }
11316 
11317     /**
11318      * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
11319      * @param _of address of the coverHolder.
11320      * @param _coverId coverId of the cover.
11321      */
11322     function getUserLockedCNTokens(address _of, uint _coverId) external view returns(uint) {
11323         return _getUserLockedCNTokens(_of, _coverId);
11324     } 
11325 
11326     /**
11327      * @dev to get the all the cover locked tokens of a user 
11328      * @param _of is the user address in concern
11329      * @return amount locked
11330      */
11331     function getUserAllLockedCNTokens(address _of) external view returns(uint amount) {
11332         for (uint i = 0; i < qd.getUserCoverLength(_of); i++) {
11333             amount = amount.add(_getUserLockedCNTokens(_of, qd.getAllCoversOfUser(_of)[i]));
11334         }
11335     }
11336 
11337     /**
11338      * @dev Returns amount of NXM Tokens locked as Cover Note against given coverId.
11339      * @param _coverId coverId of the cover.
11340      */
11341     function getLockedCNAgainstCover(uint _coverId) external view returns(uint) {
11342         return _getLockedCNAgainstCover(_coverId);
11343     }
11344 
11345     /**
11346      * @dev Returns total amount of staked NXM Tokens on all smart contracts.
11347      * @param _stakerAddress address of the Staker.
11348      */ 
11349     function deprecated_getStakerAllLockedTokens(address _stakerAddress) external view returns (uint amount) {
11350         uint stakedAmount = 0;
11351         address scAddress;
11352         uint scIndex;
11353         for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
11354             scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
11355             scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
11356             uint currentlyStaked;
11357             (, currentlyStaked) = _deprecated_unlockableBeforeBurningAndCanBurn(_stakerAddress, scAddress, i);
11358             stakedAmount = stakedAmount.add(currentlyStaked);
11359         }
11360         amount = stakedAmount;
11361     }
11362 
11363     /**
11364      * @dev Returns total unlockable amount of staked NXM Tokens on all smart contract .
11365      * @param _stakerAddress address of the Staker.
11366      */
11367     function deprecated_getStakerAllUnlockableStakedTokens(
11368         address _stakerAddress
11369     )
11370     external
11371     view
11372     returns (uint amount)
11373     {
11374         uint unlockableAmount = 0;
11375         address scAddress;
11376         uint scIndex;
11377         for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
11378             scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
11379             scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
11380             unlockableAmount = unlockableAmount.add(
11381                 _deprecated_getStakerUnlockableTokensOnSmartContract(_stakerAddress, scAddress,
11382                 scIndex));
11383         }
11384         amount = unlockableAmount;
11385     }
11386 
11387     /**
11388      * @dev Change Dependent Contract Address
11389      */
11390     function changeDependentContractAddress() public {
11391         tk = NXMToken(ms.tokenAddress());
11392         td = TokenData(ms.getLatestAddress("TD"));
11393         tc = TokenController(ms.getLatestAddress("TC"));
11394         cr = ClaimsReward(ms.getLatestAddress("CR"));
11395         qd = QuotationData(ms.getLatestAddress("QD"));
11396         m1 = MCR(ms.getLatestAddress("MC"));
11397         gv = Governance(ms.getLatestAddress("GV"));
11398         mr = MemberRoles(ms.getLatestAddress("MR"));
11399         pd = PoolData(ms.getLatestAddress("PD"));
11400         pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
11401     }
11402 
11403     /**
11404      * @dev Gets the Token price in a given currency
11405      * @param curr Currency name.
11406      * @return price Token Price.
11407      */
11408     function getTokenPrice(bytes4 curr) public view returns(uint price) {
11409         price = m1.calculateTokenPrice(curr);
11410     }
11411 
11412     /**
11413      * @dev Set the flag to check if cover note is deposited against the cover id
11414      * @param coverId Cover Id.
11415      */ 
11416     function depositCN(uint coverId) public onlyInternal returns (bool success) {
11417         require(_getLockedCNAgainstCover(coverId) > 0, "No cover note available");
11418         td.setDepositCN(coverId, true);
11419         success = true;    
11420     }
11421 
11422     /**
11423      * @param _of address of Member
11424      * @param _coverId Cover Id
11425      * @param _lockTime Pending Time + Cover Period 7*1 days
11426      */ 
11427     function extendCNEPOff(address _of, uint _coverId, uint _lockTime) public onlyInternal {
11428         uint timeStamp = now.add(_lockTime);
11429         uint coverValidUntil = qd.getValidityOfCover(_coverId);
11430         if (timeStamp >= coverValidUntil) {
11431             bytes32 reason = keccak256(abi.encodePacked("CN", _of, _coverId));
11432             tc.extendLockOf(_of, reason, timeStamp);
11433         } 
11434     }
11435 
11436     /**
11437      * @dev to burn the deposited cover tokens 
11438      * @param coverId is id of cover whose tokens have to be burned
11439      * @return the status of the successful burning
11440      */
11441     function burnDepositCN(uint coverId) public onlyInternal returns (bool success) {
11442         address _of = qd.getCoverMemberAddress(coverId);
11443         uint amount;
11444         (amount, ) = td.depositedCN(coverId);
11445         amount = (amount.mul(50)).div(100);
11446         bytes32 reason = keccak256(abi.encodePacked("CN", _of, coverId));
11447         tc.burnLockedTokens(_of, reason, amount);
11448         success = true;
11449     }
11450 
11451     /**
11452      * @dev Unlocks covernote locked against a given cover 
11453      * @param coverId id of cover
11454      */ 
11455     function unlockCN(uint coverId) public onlyInternal {
11456         (, bool isDeposited) = td.depositedCN(coverId);
11457         require(!isDeposited,"Cover note is deposited and can not be released");
11458         uint lockedCN = _getLockedCNAgainstCover(coverId);
11459         if (lockedCN != 0) {
11460             address coverHolder = qd.getCoverMemberAddress(coverId);
11461             bytes32 reason = keccak256(abi.encodePacked("CN", coverHolder, coverId));
11462             tc.releaseLockedTokens(coverHolder, reason, lockedCN);
11463         }
11464     }
11465 
11466     /** 
11467      * @dev Burns tokens used for fraudulent voting against a claim
11468      * @param claimid Claim Id.
11469      * @param _value number of tokens to be burned
11470      * @param _of Claim Assessor's address.
11471      */     
11472     function burnCAToken(uint claimid, uint _value, address _of) public {
11473 
11474         require(ms.checkIsAuthToGoverned(msg.sender));
11475         tc.burnLockedTokens(_of, "CLA", _value);
11476         emit BurnCATokens(claimid, _of, _value);
11477     }
11478 
11479     /**
11480      * @dev to lock cover note tokens
11481      * @param coverNoteAmount is number of tokens to be locked
11482      * @param coverPeriod is cover period in concern
11483      * @param coverId is the cover id of cover in concern
11484      * @param _of address whose tokens are to be locked
11485      */
11486     function lockCN(
11487         uint coverNoteAmount,
11488         uint coverPeriod,
11489         uint coverId,
11490         address _of
11491     )
11492         public
11493         onlyInternal
11494     {
11495         uint validity = (coverPeriod * 1 days).add(td.lockTokenTimeAfterCoverExp());
11496         bytes32 reason = keccak256(abi.encodePacked("CN", _of, coverId));
11497         td.setDepositCNAmount(coverId, coverNoteAmount);
11498         tc.lockOf(_of, reason, coverNoteAmount, validity);
11499     }
11500 
11501     /**
11502      * @dev to check if a  member is locked for member vote 
11503      * @param _of is the member address in concern
11504      * @return the boolean status
11505      */
11506     function isLockedForMemberVote(address _of) public view returns(bool) {
11507         return now < tk.isLockedForMV(_of);
11508     }
11509 
11510     /**
11511      * @dev Internal function to gets amount of locked NXM tokens,
11512      * staked against smartcontract by index
11513      * @param _stakerAddress address of user
11514      * @param _stakedContractAddress staked contract address
11515      * @param _stakedContractIndex index of staking
11516      */
11517     function deprecated_getStakerLockedTokensOnSmartContract (
11518         address _stakerAddress,
11519         address _stakedContractAddress,
11520         uint _stakedContractIndex
11521     )
11522         public
11523         view
11524         returns
11525         (uint amount)
11526     {
11527         amount = _deprecated_getStakerLockedTokensOnSmartContract(_stakerAddress,
11528             _stakedContractAddress, _stakedContractIndex);
11529     }
11530 
11531     /**
11532      * @dev Function to gets unlockable amount of locked NXM
11533      * tokens, staked against smartcontract by index
11534      * @param stakerAddress address of staker
11535      * @param stakedContractAddress staked contract address
11536      * @param stakerIndex index of staking
11537      */
11538     function deprecated_getStakerUnlockableTokensOnSmartContract (
11539         address stakerAddress,
11540         address stakedContractAddress,
11541         uint stakerIndex
11542     )
11543         public
11544         view
11545         returns (uint)
11546     {
11547         return _deprecated_getStakerUnlockableTokensOnSmartContract(stakerAddress, stakedContractAddress,
11548         td.getStakerStakedContractIndex(stakerAddress, stakerIndex));
11549     }
11550 
11551     /**
11552      * @dev releases unlockable staked tokens to staker 
11553      */
11554     function deprecated_unlockStakerUnlockableTokens(address _stakerAddress) public checkPause {
11555         uint unlockableAmount;
11556         address scAddress;
11557         bytes32 reason;
11558         uint scIndex;
11559         for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
11560             scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
11561             scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
11562             unlockableAmount = _deprecated_getStakerUnlockableTokensOnSmartContract(
11563             _stakerAddress, scAddress,
11564             scIndex);
11565             td.setUnlockableBeforeLastBurnTokens(_stakerAddress, i, 0);
11566             td.pushUnlockedStakedTokens(_stakerAddress, i, unlockableAmount);
11567             reason = keccak256(abi.encodePacked("UW", _stakerAddress, scAddress, scIndex));
11568             tc.releaseLockedTokens(_stakerAddress, reason, unlockableAmount);
11569         }
11570     }
11571 
11572     /**
11573      * @dev to get tokens of staker locked before burning that are allowed to burn 
11574      * @param stakerAdd is the address of the staker 
11575      * @param stakedAdd is the address of staked contract in concern 
11576      * @param stakerIndex is the staker index in concern
11577      * @return amount of unlockable tokens
11578      * @return amount of tokens that can burn
11579      */
11580     function _deprecated_unlockableBeforeBurningAndCanBurn(
11581         address stakerAdd, 
11582         address stakedAdd, 
11583         uint stakerIndex
11584     )
11585     public
11586     view
11587     returns
11588     (uint amount, uint canBurn) {
11589 
11590         uint dateAdd;
11591         uint initialStake;
11592         uint totalBurnt;
11593         uint ub;
11594         (, , dateAdd, initialStake, , totalBurnt, ub) = td.stakerStakedContracts(stakerAdd, stakerIndex);
11595         canBurn = _deprecated_calculateStakedTokens(initialStake, now.sub(dateAdd).div(1 days), td.scValidDays());
11596         // Can't use SafeMaths for int.
11597         int v = int(initialStake - (canBurn) - (totalBurnt) - (
11598             td.getStakerUnlockedStakedTokens(stakerAdd, stakerIndex)) - (ub));
11599         uint currentLockedTokens = _deprecated_getStakerLockedTokensOnSmartContract(
11600             stakerAdd, stakedAdd, td.getStakerStakedContractIndex(stakerAdd, stakerIndex));
11601         if (v < 0) {
11602             v = 0;
11603         }
11604         amount = uint(v);
11605         if (canBurn > currentLockedTokens.sub(amount).sub(ub)) {
11606             canBurn = currentLockedTokens.sub(amount).sub(ub);
11607         }
11608     }
11609 
11610     /**
11611      * @dev to get tokens of staker that are unlockable
11612      * @param _stakerAddress is the address of the staker 
11613      * @param _stakedContractAddress is the address of staked contract in concern 
11614      * @param _stakedContractIndex is the staked contract index in concern
11615      * @return amount of unlockable tokens
11616      */
11617     function _deprecated_getStakerUnlockableTokensOnSmartContract (
11618         address _stakerAddress,
11619         address _stakedContractAddress,
11620         uint _stakedContractIndex
11621     ) 
11622         public
11623         view
11624         returns
11625         (uint amount)
11626     {   
11627         uint initialStake;
11628         uint stakerIndex = td.getStakedContractStakerIndex(
11629             _stakedContractAddress, _stakedContractIndex);
11630         uint burnt;
11631         (, , , initialStake, , burnt,) = td.stakerStakedContracts(_stakerAddress, stakerIndex);
11632         uint alreadyUnlocked = td.getStakerUnlockedStakedTokens(_stakerAddress, stakerIndex);
11633         uint currentStakedTokens;
11634         (, currentStakedTokens) = _deprecated_unlockableBeforeBurningAndCanBurn(_stakerAddress,
11635             _stakedContractAddress, stakerIndex);
11636         amount = initialStake.sub(currentStakedTokens).sub(alreadyUnlocked).sub(burnt);
11637     }
11638 
11639     /**
11640      * @dev Internal function to get the amount of locked NXM tokens,
11641      * staked against smartcontract by index
11642      * @param _stakerAddress address of user
11643      * @param _stakedContractAddress staked contract address
11644      * @param _stakedContractIndex index of staking
11645      */
11646     function _deprecated_getStakerLockedTokensOnSmartContract (
11647         address _stakerAddress,
11648         address _stakedContractAddress,
11649         uint _stakedContractIndex
11650     )
11651         internal
11652         view
11653         returns
11654         (uint amount)
11655     {   
11656         bytes32 reason = keccak256(abi.encodePacked("UW", _stakerAddress,
11657             _stakedContractAddress, _stakedContractIndex));
11658         amount = tc.tokensLocked(_stakerAddress, reason);
11659     }
11660 
11661     /**
11662      * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
11663      * @param _coverId coverId of the cover.
11664      */
11665     function _getLockedCNAgainstCover(uint _coverId) internal view returns(uint) {
11666         address coverHolder = qd.getCoverMemberAddress(_coverId);
11667         bytes32 reason = keccak256(abi.encodePacked("CN", coverHolder, _coverId));
11668         return tc.tokensLockedAtTime(coverHolder, reason, now); 
11669     }
11670 
11671     /**
11672      * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
11673      * @param _of address of the coverHolder.
11674      * @param _coverId coverId of the cover.
11675      */
11676     function _getUserLockedCNTokens(address _of, uint _coverId) internal view returns(uint) {
11677         bytes32 reason = keccak256(abi.encodePacked("CN", _of, _coverId));
11678         return tc.tokensLockedAtTime(_of, reason, now); 
11679     }
11680 
11681     /**
11682      * @dev Internal function to gets remaining amount of staked NXM tokens,
11683      * against smartcontract by index
11684      * @param _stakeAmount address of user
11685      * @param _stakeDays staked contract address
11686      * @param _validDays index of staking
11687      */
11688     function _deprecated_calculateStakedTokens(
11689         uint _stakeAmount,
11690         uint _stakeDays,
11691         uint _validDays
11692     ) 
11693         internal
11694         pure 
11695         returns (uint amount)
11696     {
11697         if (_validDays > _stakeDays) {
11698             uint rf = ((_validDays.sub(_stakeDays)).mul(100000)).div(_validDays);
11699             amount = (rf.mul(_stakeAmount)).div(100000);
11700         } else {
11701             amount = 0;
11702         }
11703     }
11704 
11705     /**
11706      * @dev Gets the total staked NXM tokens against Smart contract 
11707      * by all stakers
11708      * @param _stakedContractAddress smart contract address.
11709      * @return amount total staked NXM tokens.
11710      */
11711     function _deprecated_burnStakerTokenLockedAgainstSmartContract(
11712         address _stakerAddress,
11713         address _stakedContractAddress,
11714         uint _stakedContractIndex,
11715         uint _amount
11716     ) 
11717         internal
11718     {
11719         uint stakerIndex = td.getStakedContractStakerIndex(
11720             _stakedContractAddress, _stakedContractIndex);
11721         td.pushBurnedTokens(_stakerAddress, stakerIndex, _amount);
11722         bytes32 reason = keccak256(abi.encodePacked("UW", _stakerAddress,
11723             _stakedContractAddress, _stakedContractIndex));
11724         tc.burnLockedTokens(_stakerAddress, reason, _amount);
11725     }
11726 }