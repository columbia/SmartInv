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
177 contract ClaimsData is Iupgradable {
178     using SafeMath for uint;
179 
180     struct Claim {
181         uint coverId;
182         uint dateUpd;
183     }
184 
185     struct Vote {
186         address voter;
187         uint tokens;
188         uint claimId;
189         int8 verdict;
190         bool rewardClaimed;
191     }
192 
193     struct ClaimsPause {
194         uint coverid;
195         uint dateUpd;
196         bool submit;
197     }
198 
199     struct ClaimPauseVoting {
200         uint claimid;
201         uint pendingTime;
202         bool voting;
203     }
204 
205     struct RewardDistributed {
206         uint lastCAvoteIndex;
207         uint lastMVvoteIndex;
208 
209     }
210 
211     struct ClaimRewardDetails {
212         uint percCA;
213         uint percMV;
214         uint tokenToBeDist;
215 
216     }
217 
218     struct ClaimTotalTokens {
219         uint accept;
220         uint deny;
221     }
222 
223     struct ClaimRewardStatus {
224         uint percCA;
225         uint percMV;
226     }
227 
228     ClaimRewardStatus[] internal rewardStatus;
229 
230     Claim[] internal allClaims;
231     Vote[] internal allvotes;
232     ClaimsPause[] internal claimPause;
233     ClaimPauseVoting[] internal claimPauseVotingEP;
234 
235     mapping(address => RewardDistributed) internal voterVoteRewardReceived;
236     mapping(uint => ClaimRewardDetails) internal claimRewardDetail;
237     mapping(uint => ClaimTotalTokens) internal claimTokensCA;
238     mapping(uint => ClaimTotalTokens) internal claimTokensMV;
239     mapping(uint => int8) internal claimVote;
240     mapping(uint => uint) internal claimsStatus;
241     mapping(uint => uint) internal claimState12Count;
242     mapping(uint => uint[]) internal claimVoteCA;
243     mapping(uint => uint[]) internal claimVoteMember;
244     mapping(address => uint[]) internal voteAddressCA;
245     mapping(address => uint[]) internal voteAddressMember;
246     mapping(address => uint[]) internal allClaimsByAddress;
247     mapping(address => mapping(uint => uint)) internal userClaimVoteCA;
248     mapping(address => mapping(uint => uint)) internal userClaimVoteMember;
249     mapping(address => uint) public userClaimVotePausedOn;
250 
251     uint internal claimPauseLastsubmit;
252     uint internal claimStartVotingFirstIndex;
253     uint public pendingClaimStart;
254     uint public claimDepositTime;
255     uint public maxVotingTime;
256     uint public minVotingTime;
257     uint public payoutRetryTime;
258     uint public claimRewardPerc;
259     uint public minVoteThreshold;
260     uint public maxVoteThreshold;
261     uint public majorityConsensus;
262     uint public pauseDaysCA;
263    
264     event ClaimRaise(
265         uint indexed coverId,
266         address indexed userAddress,
267         uint claimId,
268         uint dateSubmit
269     );
270 
271     event VoteCast(
272         address indexed userAddress,
273         uint indexed claimId,
274         bytes4 indexed typeOf,
275         uint tokens,
276         uint submitDate,
277         int8 verdict
278     );
279 
280     constructor() public {
281         pendingClaimStart = 1;
282         maxVotingTime = 48 * 1 hours;
283         minVotingTime = 12 * 1 hours;
284         payoutRetryTime = 24 * 1 hours;
285         allvotes.push(Vote(address(0), 0, 0, 0, false));
286         allClaims.push(Claim(0, 0));
287         claimDepositTime = 7 days;
288         claimRewardPerc = 20;
289         minVoteThreshold = 5;
290         maxVoteThreshold = 10;
291         majorityConsensus = 70;
292         pauseDaysCA = 3 days;
293         _addRewardIncentive();
294     }
295 
296     /**
297      * @dev Updates the pending claim start variable, 
298      * the lowest claim id with a pending decision/payout.
299      */ 
300     function setpendingClaimStart(uint _start) external onlyInternal {
301         require(pendingClaimStart <= _start);
302         pendingClaimStart = _start;
303     }
304 
305     /** 
306      * @dev Updates the max vote index for which claim assessor has received reward 
307      * @param _voter address of the voter.
308      * @param caIndex last index till which reward was distributed for CA
309      */ 
310     function setRewardDistributedIndexCA(address _voter, uint caIndex) external onlyInternal {
311         voterVoteRewardReceived[_voter].lastCAvoteIndex = caIndex;
312 
313     }
314 
315     /** 
316      * @dev Used to pause claim assessor activity for 3 days 
317      * @param user Member address whose claim voting ability needs to be paused
318      */ 
319     function setUserClaimVotePausedOn(address user) external {
320         require(ms.checkIsAuthToGoverned(msg.sender));
321         userClaimVotePausedOn[user] = now;
322     }
323 
324     /**
325      * @dev Updates the max vote index for which member has received reward 
326      * @param _voter address of the voter.
327      * @param mvIndex last index till which reward was distributed for member 
328      */ 
329     function setRewardDistributedIndexMV(address _voter, uint mvIndex) external onlyInternal {
330 
331         voterVoteRewardReceived[_voter].lastMVvoteIndex = mvIndex;
332     }
333 
334     /**
335      * @param claimid claim id.
336      * @param percCA reward Percentage reward for claim assessor
337      * @param percMV reward Percentage reward for members
338      * @param tokens total tokens to be rewarded
339      */ 
340     function setClaimRewardDetail(
341         uint claimid,
342         uint percCA,
343         uint percMV,
344         uint tokens
345     )
346         external
347         onlyInternal
348     {
349         claimRewardDetail[claimid].percCA = percCA;
350         claimRewardDetail[claimid].percMV = percMV;
351         claimRewardDetail[claimid].tokenToBeDist = tokens;
352     }
353 
354     /**
355      * @dev Sets the reward claim status against a vote id.
356      * @param _voteid vote Id.
357      * @param claimed true if reward for vote is claimed, else false.
358      */ 
359     function setRewardClaimed(uint _voteid, bool claimed) external onlyInternal {
360         allvotes[_voteid].rewardClaimed = claimed;
361     }
362 
363     /**
364      * @dev Sets the final vote's result(either accepted or declined)of a claim.
365      * @param _claimId Claim Id.
366      * @param _verdict 1 if claim is accepted,-1 if declined.
367      */ 
368     function changeFinalVerdict(uint _claimId, int8 _verdict) external onlyInternal {
369         claimVote[_claimId] = _verdict;
370     }
371     
372     /**
373      * @dev Creates a new claim.
374      */ 
375     function addClaim(
376         uint _claimId,
377         uint _coverId,
378         address _from,
379         uint _nowtime
380     )
381         external
382         onlyInternal
383     {
384         allClaims.push(Claim(_coverId, _nowtime));
385         allClaimsByAddress[_from].push(_claimId);
386     }
387 
388     /**
389      * @dev Add Vote's details of a given claim.
390      */ 
391     function addVote(
392         address _voter,
393         uint _tokens,
394         uint claimId,
395         int8 _verdict
396     ) 
397         external
398         onlyInternal
399     {
400         allvotes.push(Vote(_voter, _tokens, claimId, _verdict, false));
401     }
402 
403     /** 
404      * @dev Stores the id of the claim assessor vote given to a claim.
405      * Maintains record of all votes given by all the CA to a claim.
406      * @param _claimId Claim Id to which vote has given by the CA.
407      * @param _voteid Vote Id.
408      */
409     function addClaimVoteCA(uint _claimId, uint _voteid) external onlyInternal {
410         claimVoteCA[_claimId].push(_voteid);
411     }
412 
413     /** 
414      * @dev Sets the id of the vote.
415      * @param _from Claim assessor's address who has given the vote.
416      * @param _claimId Claim Id for which vote has been given by the CA.
417      * @param _voteid Vote Id which will be stored against the given _from and claimid.
418      */ 
419     function setUserClaimVoteCA(
420         address _from,
421         uint _claimId,
422         uint _voteid
423     )
424         external
425         onlyInternal
426     {
427         userClaimVoteCA[_from][_claimId] = _voteid;
428         voteAddressCA[_from].push(_voteid);
429     }
430 
431     /**
432      * @dev Stores the tokens locked by the Claim Assessors during voting of a given claim.
433      * @param _claimId Claim Id.
434      * @param _vote 1 for accept and increases the tokens of claim as accept,
435      * -1 for deny and increases the tokens of claim as deny.
436      * @param _tokens Number of tokens.
437      */ 
438     function setClaimTokensCA(uint _claimId, int8 _vote, uint _tokens) external onlyInternal {
439         if (_vote == 1)
440             claimTokensCA[_claimId].accept = claimTokensCA[_claimId].accept.add(_tokens);
441         if (_vote == -1)
442             claimTokensCA[_claimId].deny = claimTokensCA[_claimId].deny.add(_tokens);
443     }
444 
445     /** 
446      * @dev Stores the tokens locked by the Members during voting of a given claim.
447      * @param _claimId Claim Id.
448      * @param _vote 1 for accept and increases the tokens of claim as accept,
449      * -1 for deny and increases the tokens of claim as deny.
450      * @param _tokens Number of tokens.
451      */ 
452     function setClaimTokensMV(uint _claimId, int8 _vote, uint _tokens) external onlyInternal {
453         if (_vote == 1)
454             claimTokensMV[_claimId].accept = claimTokensMV[_claimId].accept.add(_tokens);
455         if (_vote == -1)
456             claimTokensMV[_claimId].deny = claimTokensMV[_claimId].deny.add(_tokens);
457     }
458 
459     /** 
460      * @dev Stores the id of the member vote given to a claim.
461      * Maintains record of all votes given by all the Members to a claim.
462      * @param _claimId Claim Id to which vote has been given by the Member.
463      * @param _voteid Vote Id.
464      */ 
465     function addClaimVotemember(uint _claimId, uint _voteid) external onlyInternal {
466         claimVoteMember[_claimId].push(_voteid);
467     }
468 
469     /** 
470      * @dev Sets the id of the vote.
471      * @param _from Member's address who has given the vote.
472      * @param _claimId Claim Id for which vote has been given by the Member.
473      * @param _voteid Vote Id which will be stored against the given _from and claimid.
474      */ 
475     function setUserClaimVoteMember(
476         address _from,
477         uint _claimId,
478         uint _voteid
479     )
480         external
481         onlyInternal
482     {
483         userClaimVoteMember[_from][_claimId] = _voteid;
484         voteAddressMember[_from].push(_voteid);
485 
486     }
487 
488     /** 
489      * @dev Increases the count of failure until payout of a claim is successful.
490      */ 
491     function updateState12Count(uint _claimId, uint _cnt) external onlyInternal {
492         claimState12Count[_claimId] = claimState12Count[_claimId].add(_cnt);
493     }
494 
495     /** 
496      * @dev Sets status of a claim.
497      * @param _claimId Claim Id.
498      * @param _stat Status number.
499      */
500     function setClaimStatus(uint _claimId, uint _stat) external onlyInternal {
501         claimsStatus[_claimId] = _stat;
502     }
503 
504     /** 
505      * @dev Sets the timestamp of a given claim at which the Claim's details has been updated.
506      * @param _claimId Claim Id of claim which has been changed.
507      * @param _dateUpd timestamp at which claim is updated.
508      */ 
509     function setClaimdateUpd(uint _claimId, uint _dateUpd) external onlyInternal {
510         allClaims[_claimId].dateUpd = _dateUpd;
511     }
512 
513     /** 
514      @dev Queues Claims during Emergency Pause.
515      */ 
516     function setClaimAtEmergencyPause(
517         uint _coverId,
518         uint _dateUpd,
519         bool _submit
520     )
521         external
522         onlyInternal
523     {
524         claimPause.push(ClaimsPause(_coverId, _dateUpd, _submit));
525     }
526 
527     /** 
528      * @dev Set submission flag for Claims queued during emergency pause.
529      * Set to true after EP is turned off and the claim is submitted .
530      */ 
531     function setClaimSubmittedAtEPTrue(uint _index, bool _submit) external onlyInternal {
532         claimPause[_index].submit = _submit;
533     }
534 
535     /** 
536      * @dev Sets the index from which claim needs to be 
537      * submitted when emergency pause is swithched off.
538      */ 
539     function setFirstClaimIndexToSubmitAfterEP(
540         uint _firstClaimIndexToSubmit
541     )
542         external
543         onlyInternal
544     {
545         claimPauseLastsubmit = _firstClaimIndexToSubmit;
546     }
547 
548     /** 
549      * @dev Sets the pending vote duration for a claim in case of emergency pause.
550      */ 
551     function setPendingClaimDetails(
552         uint _claimId,
553         uint _pendingTime,
554         bool _voting
555     )
556         external
557         onlyInternal
558     {
559         claimPauseVotingEP.push(ClaimPauseVoting(_claimId, _pendingTime, _voting));
560     }
561 
562     /** 
563      * @dev Sets voting flag true after claim is reopened for voting after emergency pause.
564      */ 
565     function setPendingClaimVoteStatus(uint _claimId, bool _vote) external onlyInternal {
566         claimPauseVotingEP[_claimId].voting = _vote;
567     }
568     
569     /** 
570      * @dev Sets the index from which claim needs to be 
571      * reopened when emergency pause is swithched off. 
572      */ 
573     function setFirstClaimIndexToStartVotingAfterEP(
574         uint _claimStartVotingFirstIndex
575     )
576         external
577         onlyInternal
578     {
579         claimStartVotingFirstIndex = _claimStartVotingFirstIndex;
580     }
581 
582     /** 
583      * @dev Calls Vote Event.
584      */ 
585     function callVoteEvent(
586         address _userAddress,
587         uint _claimId,
588         bytes4 _typeOf,
589         uint _tokens,
590         uint _submitDate,
591         int8 _verdict
592     )
593         external
594         onlyInternal
595     {
596         emit VoteCast(
597             _userAddress,
598             _claimId,
599             _typeOf,
600             _tokens,
601             _submitDate,
602             _verdict
603         );
604     }
605 
606     /** 
607      * @dev Calls Claim Event. 
608      */ 
609     function callClaimEvent(
610         uint _coverId,
611         address _userAddress,
612         uint _claimId,
613         uint _datesubmit
614     ) 
615         external
616         onlyInternal
617     {
618         emit ClaimRaise(_coverId, _userAddress, _claimId, _datesubmit);
619     }
620 
621     /**
622      * @dev Gets Uint Parameters by parameter code
623      * @param code whose details we want
624      * @return string value of the parameter
625      * @return associated amount (time or perc or value) to the code
626      */
627     function getUintParameters(bytes8 code) external view returns (bytes8 codeVal, uint val) {
628         codeVal = code;
629         if (code == "CAMAXVT") {
630             val = maxVotingTime / (1 hours);
631 
632         } else if (code == "CAMINVT") {
633 
634             val = minVotingTime / (1 hours);
635 
636         } else if (code == "CAPRETRY") {
637 
638             val = payoutRetryTime / (1 hours);
639 
640         } else if (code == "CADEPT") {
641 
642             val = claimDepositTime / (1 days);
643 
644         } else if (code == "CAREWPER") {
645 
646             val = claimRewardPerc;
647 
648         } else if (code == "CAMINTH") {
649 
650             val = minVoteThreshold;
651 
652         } else if (code == "CAMAXTH") {
653 
654             val = maxVoteThreshold;
655 
656         } else if (code == "CACONPER") {
657 
658             val = majorityConsensus;
659 
660         } else if (code == "CAPAUSET") {
661             val = pauseDaysCA / (1 days);
662         }
663     
664     }
665 
666     /**
667      * @dev Get claim queued during emergency pause by index.
668      */ 
669     function getClaimOfEmergencyPauseByIndex(
670         uint _index
671     ) 
672         external
673         view
674         returns(
675             uint coverId,
676             uint dateUpd,
677             bool submit
678         )
679     {
680         coverId = claimPause[_index].coverid;
681         dateUpd = claimPause[_index].dateUpd;
682         submit = claimPause[_index].submit;
683     }
684 
685     /**
686      * @dev Gets the Claim's details of given claimid.   
687      */ 
688     function getAllClaimsByIndex(
689         uint _claimId
690     )
691         external
692         view
693         returns(
694             uint coverId,
695             int8 vote,
696             uint status,
697             uint dateUpd,
698             uint state12Count
699         )
700     {
701         return(
702             allClaims[_claimId].coverId,
703             claimVote[_claimId],
704             claimsStatus[_claimId],
705             allClaims[_claimId].dateUpd,
706             claimState12Count[_claimId]
707         );
708     }
709 
710     /** 
711      * @dev Gets the vote id of a given claim of a given Claim Assessor.
712      */ 
713     function getUserClaimVoteCA(
714         address _add,
715         uint _claimId
716     )
717         external
718         view
719         returns(uint idVote)
720     {
721         return userClaimVoteCA[_add][_claimId];
722     }
723 
724     /** 
725      * @dev Gets the vote id of a given claim of a given member.
726      */
727     function getUserClaimVoteMember(
728         address _add,
729         uint _claimId
730     )
731         external
732         view
733         returns(uint idVote)
734     {
735         return userClaimVoteMember[_add][_claimId];
736     }
737 
738     /** 
739      * @dev Gets the count of all votes.
740      */ 
741     function getAllVoteLength() external view returns(uint voteCount) {
742         return allvotes.length.sub(1); //Start Index always from 1.
743     }
744 
745     /**
746      * @dev Gets the status number of a given claim.
747      * @param _claimId Claim id.
748      * @return statno Status Number. 
749      */ 
750     function getClaimStatusNumber(uint _claimId) external view returns(uint claimId, uint statno) {
751         return (_claimId, claimsStatus[_claimId]);
752     }
753 
754     /**
755      * @dev Gets the reward percentage to be distributed for a given status id
756      * @param statusNumber the number of type of status
757      * @return percCA reward Percentage for claim assessor
758      * @return percMV reward Percentage for members
759      */
760     function getRewardStatus(uint statusNumber) external view returns(uint percCA, uint percMV) {
761         return (rewardStatus[statusNumber].percCA, rewardStatus[statusNumber].percMV);
762     }
763 
764     /** 
765      * @dev Gets the number of tries that have been made for a successful payout of a Claim.
766      */ 
767     function getClaimState12Count(uint _claimId) external view returns(uint num) {
768         num = claimState12Count[_claimId];
769     }
770 
771     /** 
772      * @dev Gets the last update date of a claim.
773      */ 
774     function getClaimDateUpd(uint _claimId) external view returns(uint dateupd) {
775         dateupd = allClaims[_claimId].dateUpd;
776     }
777 
778     /**
779      * @dev Gets all Claims created by a user till date.
780      * @param _member user's address.
781      * @return claimarr List of Claims id.
782      */ 
783     function getAllClaimsByAddress(address _member) external view returns(uint[] memory claimarr) {
784         return allClaimsByAddress[_member];
785     }
786 
787     /**
788      * @dev Gets the number of tokens that has been locked 
789      * while giving vote to a claim by  Claim Assessors.
790      * @param _claimId Claim Id.
791      * @return accept Total number of tokens when CA accepts the claim.
792      * @return deny Total number of tokens when CA declines the claim.
793      */ 
794     function getClaimsTokenCA(
795         uint _claimId
796     )
797         external
798         view
799         returns(
800             uint claimId,
801             uint accept,
802             uint deny
803         )
804     {
805         return (
806             _claimId,
807             claimTokensCA[_claimId].accept,
808             claimTokensCA[_claimId].deny
809         );
810     }
811 
812     /** 
813      * @dev Gets the number of tokens that have been
814      * locked while assessing a claim as a member.
815      * @param _claimId Claim Id.
816      * @return accept Total number of tokens in acceptance of the claim.
817      * @return deny Total number of tokens against the claim.
818      */ 
819     function getClaimsTokenMV(
820         uint _claimId
821     )
822         external
823         view
824         returns(
825             uint claimId,
826             uint accept,
827             uint deny
828         )
829     {
830         return (
831             _claimId,
832             claimTokensMV[_claimId].accept,
833             claimTokensMV[_claimId].deny
834         );
835     }
836 
837     /**
838      * @dev Gets the total number of votes cast as Claims assessor for/against a given claim
839      */ 
840     function getCaClaimVotesToken(uint _claimId) external view returns(uint claimId, uint cnt) {
841         claimId = _claimId;
842         cnt = 0;
843         for (uint i = 0; i < claimVoteCA[_claimId].length; i++) {
844             cnt = cnt.add(allvotes[claimVoteCA[_claimId][i]].tokens);
845         }
846     }
847 
848     /**
849      * @dev Gets the total number of tokens cast as a member for/against a given claim  
850      */ 
851     function getMemberClaimVotesToken(
852         uint _claimId
853     )   
854         external
855         view
856         returns(uint claimId, uint cnt)
857     {
858         claimId = _claimId;
859         cnt = 0;
860         for (uint i = 0; i < claimVoteMember[_claimId].length; i++) {
861             cnt = cnt.add(allvotes[claimVoteMember[_claimId][i]].tokens);
862         }
863     }
864 
865     /**
866      * @dev Provides information of a vote when given its vote id.
867      * @param _voteid Vote Id.
868      */
869     function getVoteDetails(uint _voteid)
870     external view
871     returns(
872         uint tokens,
873         uint claimId,
874         int8 verdict,
875         bool rewardClaimed
876         )
877     {
878         return (
879             allvotes[_voteid].tokens,
880             allvotes[_voteid].claimId,
881             allvotes[_voteid].verdict,
882             allvotes[_voteid].rewardClaimed
883         );
884     }
885 
886     /**
887      * @dev Gets the voter's address of a given vote id.
888      */ 
889     function getVoterVote(uint _voteid) external view returns(address voter) {
890         return allvotes[_voteid].voter;
891     }
892 
893     /**
894      * @dev Provides information of a Claim when given its claim id.
895      * @param _claimId Claim Id.
896      */ 
897     function getClaim(
898         uint _claimId
899     )
900         external
901         view
902         returns(
903             uint claimId,
904             uint coverId,
905             int8 vote,
906             uint status,
907             uint dateUpd,
908             uint state12Count
909         )
910     {
911         return (
912             _claimId,
913             allClaims[_claimId].coverId,
914             claimVote[_claimId],
915             claimsStatus[_claimId],
916             allClaims[_claimId].dateUpd,
917             claimState12Count[_claimId]
918             );
919     }
920 
921     /**
922      * @dev Gets the total number of votes of a given claim.
923      * @param _claimId Claim Id.
924      * @param _ca if 1: votes given by Claim Assessors to a claim,
925      * else returns the number of votes of given by Members to a claim.
926      * @return len total number of votes for/against a given claim.
927      */ 
928     function getClaimVoteLength(
929         uint _claimId,
930         uint8 _ca
931     )
932         external
933         view
934         returns(uint claimId, uint len)
935     {
936         claimId = _claimId;
937         if (_ca == 1)
938             len = claimVoteCA[_claimId].length;
939         else
940             len = claimVoteMember[_claimId].length;
941     }
942 
943     /**
944      * @dev Gets the verdict of a vote using claim id and index.
945      * @param _ca 1 for vote given as a CA, else for vote given as a member.
946      * @return ver 1 if vote was given in favour,-1 if given in against.
947      */ 
948     function getVoteVerdict(
949         uint _claimId,
950         uint _index,
951         uint8 _ca
952     )
953         external
954         view
955         returns(int8 ver)
956     {
957         if (_ca == 1)
958             ver = allvotes[claimVoteCA[_claimId][_index]].verdict;
959         else
960             ver = allvotes[claimVoteMember[_claimId][_index]].verdict;
961     }
962 
963     /**
964      * @dev Gets the Number of tokens of a vote using claim id and index.
965      * @param _ca 1 for vote given as a CA, else for vote given as a member.
966      * @return tok Number of tokens.
967      */ 
968     function getVoteToken(
969         uint _claimId,
970         uint _index,
971         uint8 _ca
972     )   
973         external
974         view
975         returns(uint tok)
976     {
977         if (_ca == 1)
978             tok = allvotes[claimVoteCA[_claimId][_index]].tokens;
979         else
980             tok = allvotes[claimVoteMember[_claimId][_index]].tokens;
981     }
982 
983     /**
984      * @dev Gets the Voter's address of a vote using claim id and index.
985      * @param _ca 1 for vote given as a CA, else for vote given as a member.
986      * @return voter Voter's address.
987      */ 
988     function getVoteVoter(
989         uint _claimId,
990         uint _index,
991         uint8 _ca
992     )
993         external
994         view
995         returns(address voter)
996     {
997         if (_ca == 1)
998             voter = allvotes[claimVoteCA[_claimId][_index]].voter;
999         else
1000             voter = allvotes[claimVoteMember[_claimId][_index]].voter;
1001     }
1002 
1003     /** 
1004      * @dev Gets total number of Claims created by a user till date.
1005      * @param _add User's address.
1006      */ 
1007     function getUserClaimCount(address _add) external view returns(uint len) {
1008         len = allClaimsByAddress[_add].length;
1009     }
1010 
1011     /**
1012      * @dev Calculates number of Claims that are in pending state.
1013      */ 
1014     function getClaimLength() external view returns(uint len) {
1015         len = allClaims.length.sub(pendingClaimStart);
1016     }
1017 
1018     /**
1019      * @dev Gets the Number of all the Claims created till date.
1020      */ 
1021     function actualClaimLength() external view returns(uint len) {
1022         len = allClaims.length;
1023     }
1024 
1025     /** 
1026      * @dev Gets details of a claim.
1027      * @param _index claim id = pending claim start + given index
1028      * @param _add User's address.
1029      * @return coverid cover against which claim has been submitted.
1030      * @return claimId Claim  Id.
1031      * @return voteCA verdict of vote given as a Claim Assessor.  
1032      * @return voteMV verdict of vote given as a Member.
1033      * @return statusnumber Status of claim.
1034      */ 
1035     function getClaimFromNewStart(
1036         uint _index,
1037         address _add
1038     )
1039         external
1040         view
1041         returns(
1042             uint coverid,
1043             uint claimId,
1044             int8 voteCA,
1045             int8 voteMV,
1046             uint statusnumber
1047         )
1048     {
1049         uint i = pendingClaimStart.add(_index);
1050         coverid = allClaims[i].coverId;
1051         claimId = i;
1052         if (userClaimVoteCA[_add][i] > 0)
1053             voteCA = allvotes[userClaimVoteCA[_add][i]].verdict;
1054         else
1055             voteCA = 0;
1056 
1057         if (userClaimVoteMember[_add][i] > 0)
1058             voteMV = allvotes[userClaimVoteMember[_add][i]].verdict;
1059         else
1060             voteMV = 0;
1061 
1062         statusnumber = claimsStatus[i];
1063     }
1064 
1065     /**
1066      * @dev Gets details of a claim of a user at a given index.  
1067      */ 
1068     function getUserClaimByIndex(
1069         uint _index,
1070         address _add
1071     )
1072         external
1073         view
1074         returns(
1075             uint status,
1076             uint coverid,
1077             uint claimId
1078         )
1079     {
1080         claimId = allClaimsByAddress[_add][_index];
1081         status = claimsStatus[claimId];
1082         coverid = allClaims[claimId].coverId;
1083     }
1084 
1085     /**
1086      * @dev Gets Id of all the votes given to a claim.
1087      * @param _claimId Claim Id.
1088      * @return ca id of all the votes given by Claim assessors to a claim.
1089      * @return mv id of all the votes given by members to a claim.
1090      */ 
1091     function getAllVotesForClaim(
1092         uint _claimId
1093     )
1094         external
1095         view
1096         returns(
1097             uint claimId,
1098             uint[] memory ca,
1099             uint[] memory mv
1100         )
1101     {
1102         return (_claimId, claimVoteCA[_claimId], claimVoteMember[_claimId]);
1103     }
1104 
1105     /** 
1106      * @dev Gets Number of tokens deposit in a vote using
1107      * Claim assessor's address and claim id.
1108      * @return tokens Number of deposited tokens.
1109      */ 
1110     function getTokensClaim(
1111         address _of,
1112         uint _claimId
1113     )
1114         external
1115         view
1116         returns(
1117             uint claimId,
1118             uint tokens
1119         )
1120     {
1121         return (_claimId, allvotes[userClaimVoteCA[_of][_claimId]].tokens);
1122     }
1123 
1124     /**
1125      * @param _voter address of the voter.
1126      * @return lastCAvoteIndex last index till which reward was distributed for CA
1127      * @return lastMVvoteIndex last index till which reward was distributed for member
1128      */ 
1129     function getRewardDistributedIndex(
1130         address _voter
1131     ) 
1132         external
1133         view
1134         returns(
1135             uint lastCAvoteIndex,
1136             uint lastMVvoteIndex
1137         )
1138     {
1139         return (
1140             voterVoteRewardReceived[_voter].lastCAvoteIndex,
1141             voterVoteRewardReceived[_voter].lastMVvoteIndex
1142         );
1143     }
1144 
1145     /**
1146      * @param claimid claim id.
1147      * @return perc_CA reward Percentage for claim assessor
1148      * @return perc_MV reward Percentage for members
1149      * @return tokens total tokens to be rewarded 
1150      */ 
1151     function getClaimRewardDetail(
1152         uint claimid
1153     ) 
1154         external
1155         view
1156         returns(
1157             uint percCA,
1158             uint percMV,
1159             uint tokens
1160         )
1161     {
1162         return (
1163             claimRewardDetail[claimid].percCA,
1164             claimRewardDetail[claimid].percMV,
1165             claimRewardDetail[claimid].tokenToBeDist
1166         );
1167     }
1168 
1169     /**
1170      * @dev Gets cover id of a claim.
1171      */ 
1172     function getClaimCoverId(uint _claimId) external view returns(uint claimId, uint coverid) {
1173         return (_claimId, allClaims[_claimId].coverId);
1174     }
1175 
1176     /**
1177      * @dev Gets total number of tokens staked during voting by Claim Assessors.
1178      * @param _claimId Claim Id.
1179      * @param _verdict 1 to get total number of accept tokens, -1 to get total number of deny tokens.
1180      * @return token token Number of tokens(either accept or deny on the basis of verdict given as parameter).
1181      */ 
1182     function getClaimVote(uint _claimId, int8 _verdict) external view returns(uint claimId, uint token) {
1183         claimId = _claimId;
1184         token = 0;
1185         for (uint i = 0; i < claimVoteCA[_claimId].length; i++) {
1186             if (allvotes[claimVoteCA[_claimId][i]].verdict == _verdict)
1187                 token = token.add(allvotes[claimVoteCA[_claimId][i]].tokens);
1188         }
1189     }
1190 
1191     /**
1192      * @dev Gets total number of tokens staked during voting by Members.
1193      * @param _claimId Claim Id.
1194      * @param _verdict 1 to get total number of accept tokens,
1195      *  -1 to get total number of deny tokens.
1196      * @return token token Number of tokens(either accept or 
1197      * deny on the basis of verdict given as parameter).
1198      */ 
1199     function getClaimMVote(uint _claimId, int8 _verdict) external view returns(uint claimId, uint token) {
1200         claimId = _claimId;
1201         token = 0;
1202         for (uint i = 0; i < claimVoteMember[_claimId].length; i++) {
1203             if (allvotes[claimVoteMember[_claimId][i]].verdict == _verdict)
1204                 token = token.add(allvotes[claimVoteMember[_claimId][i]].tokens);
1205         }
1206     }
1207 
1208     /**
1209      * @param _voter address  of voteid
1210      * @param index index to get voteid in CA
1211      */ 
1212     function getVoteAddressCA(address _voter, uint index) external view returns(uint) {
1213         return voteAddressCA[_voter][index];
1214     }
1215 
1216     /**
1217      * @param _voter address  of voter
1218      * @param index index to get voteid in member vote
1219      */ 
1220     function getVoteAddressMember(address _voter, uint index) external view returns(uint) {
1221         return voteAddressMember[_voter][index];
1222     }
1223 
1224     /**
1225      * @param _voter address  of voter   
1226      */ 
1227     function getVoteAddressCALength(address _voter) external view returns(uint) {
1228         return voteAddressCA[_voter].length;
1229     }
1230 
1231     /**
1232      * @param _voter address  of voter   
1233      */ 
1234     function getVoteAddressMemberLength(address _voter) external view returns(uint) {
1235         return voteAddressMember[_voter].length;
1236     }
1237 
1238     /**
1239      * @dev Gets the Final result of voting of a claim.
1240      * @param _claimId Claim id.
1241      * @return verdict 1 if claim is accepted, -1 if declined.
1242      */ 
1243     function getFinalVerdict(uint _claimId) external view returns(int8 verdict) {
1244         return claimVote[_claimId];
1245     }
1246 
1247     /**
1248      * @dev Get number of Claims queued for submission during emergency pause.
1249      */ 
1250     function getLengthOfClaimSubmittedAtEP() external view returns(uint len) {
1251         len = claimPause.length;
1252     }
1253 
1254     /**
1255      * @dev Gets the index from which claim needs to be 
1256      * submitted when emergency pause is swithched off.
1257      */ 
1258     function getFirstClaimIndexToSubmitAfterEP() external view returns(uint indexToSubmit) {
1259         indexToSubmit = claimPauseLastsubmit;
1260     }
1261     
1262     /**
1263      * @dev Gets number of Claims to be reopened for voting post emergency pause period.
1264      */ 
1265     function getLengthOfClaimVotingPause() external view returns(uint len) {
1266         len = claimPauseVotingEP.length;
1267     }
1268 
1269     /**
1270      * @dev Gets claim details to be reopened for voting after emergency pause.
1271      */ 
1272     function getPendingClaimDetailsByIndex(
1273         uint _index
1274     )
1275         external
1276         view
1277         returns(
1278             uint claimId,
1279             uint pendingTime,
1280             bool voting
1281         )
1282     {
1283         claimId = claimPauseVotingEP[_index].claimid;
1284         pendingTime = claimPauseVotingEP[_index].pendingTime;
1285         voting = claimPauseVotingEP[_index].voting;
1286     }
1287 
1288     /** 
1289      * @dev Gets the index from which claim needs to be reopened when emergency pause is swithched off.
1290      */ 
1291     function getFirstClaimIndexToStartVotingAfterEP() external view returns(uint firstindex) {
1292         firstindex = claimStartVotingFirstIndex;
1293     }
1294 
1295     /**
1296      * @dev Updates Uint Parameters of a code
1297      * @param code whose details we want to update
1298      * @param val value to set
1299      */
1300     function updateUintParameters(bytes8 code, uint val) public {
1301         require(ms.checkIsAuthToGoverned(msg.sender));
1302         if (code == "CAMAXVT") {
1303             _setMaxVotingTime(val * 1 hours);
1304 
1305         } else if (code == "CAMINVT") {
1306 
1307             _setMinVotingTime(val * 1 hours);
1308 
1309         } else if (code == "CAPRETRY") {
1310 
1311             _setPayoutRetryTime(val * 1 hours);
1312 
1313         } else if (code == "CADEPT") {
1314 
1315             _setClaimDepositTime(val * 1 days);
1316 
1317         } else if (code == "CAREWPER") {
1318 
1319             _setClaimRewardPerc(val);
1320 
1321         } else if (code == "CAMINTH") {
1322 
1323             _setMinVoteThreshold(val);
1324 
1325         } else if (code == "CAMAXTH") {
1326 
1327             _setMaxVoteThreshold(val);
1328 
1329         } else if (code == "CACONPER") {
1330 
1331             _setMajorityConsensus(val);
1332 
1333         } else if (code == "CAPAUSET") {
1334             _setPauseDaysCA(val * 1 days);
1335         } else {
1336 
1337             revert("Invalid param code");
1338         }
1339     
1340     }
1341 
1342     /**
1343      * @dev Iupgradable Interface to update dependent contract address
1344      */
1345     function changeDependentContractAddress() public onlyInternal {}
1346 
1347     /**
1348      * @dev Adds status under which a claim can lie.
1349      * @param percCA reward percentage for claim assessor
1350      * @param percMV reward percentage for members
1351      */
1352     function _pushStatus(uint percCA, uint percMV) internal {
1353         rewardStatus.push(ClaimRewardStatus(percCA, percMV));
1354     }
1355 
1356     /**
1357      * @dev adds reward incentive for all possible claim status for Claim assessors and members
1358      */
1359     function _addRewardIncentive() internal {
1360         _pushStatus(0, 0); //0  Pending-Claim Assessor Vote
1361         _pushStatus(0, 0); //1 Pending-Claim Assessor Vote Denied, Pending Member Vote
1362         _pushStatus(0, 0); //2 Pending-CA Vote Threshold not Reached Accept, Pending Member Vote
1363         _pushStatus(0, 0); //3 Pending-CA Vote Threshold not Reached Deny, Pending Member Vote
1364         _pushStatus(0, 0); //4 Pending-CA Consensus not reached Accept, Pending Member Vote
1365         _pushStatus(0, 0); //5 Pending-CA Consensus not reached Deny, Pending Member Vote
1366         _pushStatus(100, 0); //6 Final-Claim Assessor Vote Denied
1367         _pushStatus(100, 0); //7 Final-Claim Assessor Vote Accepted
1368         _pushStatus(0, 100); //8 Final-Claim Assessor Vote Denied, MV Accepted
1369         _pushStatus(0, 100); //9 Final-Claim Assessor Vote Denied, MV Denied
1370         _pushStatus(0, 0); //10 Final-Claim Assessor Vote Accept, MV Nodecision
1371         _pushStatus(0, 0); //11 Final-Claim Assessor Vote Denied, MV Nodecision
1372         _pushStatus(0, 0); //12 Claim Accepted Payout Pending
1373         _pushStatus(0, 0); //13 Claim Accepted No Payout 
1374         _pushStatus(0, 0); //14 Claim Accepted Payout Done
1375     }
1376 
1377     /**
1378      * @dev Sets Maximum time(in seconds) for which claim assessment voting is open
1379      */ 
1380     function _setMaxVotingTime(uint _time) internal {
1381         maxVotingTime = _time;
1382     }
1383 
1384     /**
1385      *  @dev Sets Minimum time(in seconds) for which claim assessment voting is open
1386      */ 
1387     function _setMinVotingTime(uint _time) internal {
1388         minVotingTime = _time;
1389     }
1390 
1391     /**
1392      *  @dev Sets Minimum vote threshold required
1393      */ 
1394     function _setMinVoteThreshold(uint val) internal {
1395         minVoteThreshold = val;
1396     }
1397 
1398     /**
1399      *  @dev Sets Maximum vote threshold required
1400      */ 
1401     function _setMaxVoteThreshold(uint val) internal {
1402         maxVoteThreshold = val;
1403     }
1404     
1405     /**
1406      *  @dev Sets the value considered as Majority Consenus in voting
1407      */ 
1408     function _setMajorityConsensus(uint val) internal {
1409         majorityConsensus = val;
1410     }
1411 
1412     /**
1413      * @dev Sets the payout retry time
1414      */ 
1415     function _setPayoutRetryTime(uint _time) internal {
1416         payoutRetryTime = _time;
1417     }
1418 
1419     /**
1420      *  @dev Sets percentage of reward given for claim assessment
1421      */ 
1422     function _setClaimRewardPerc(uint _val) internal {
1423 
1424         claimRewardPerc = _val;
1425     }
1426   
1427     /** 
1428      * @dev Sets the time for which claim is deposited.
1429      */ 
1430     function _setClaimDepositTime(uint _time) internal {
1431 
1432         claimDepositTime = _time;
1433     }
1434 
1435     /**
1436      *  @dev Sets number of days claim assessment will be paused
1437      */ 
1438     function _setPauseDaysCA(uint val) internal {
1439         pauseDaysCA = val;
1440     }
1441 }
1442 
1443 /* Copyright (C) 2017 GovBlocks.io
1444   This program is free software: you can redistribute it and/or modify
1445     it under the terms of the GNU General Public License as published by
1446     the Free Software Foundation, either version 3 of the License, or
1447     (at your option) any later version.
1448   This program is distributed in the hope that it will be useful,
1449     but WITHOUT ANY WARRANTY; without even the implied warranty of
1450     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1451     GNU General Public License for more details.
1452   You should have received a copy of the GNU General Public License
1453     along with this program.  If not, see http://www.gnu.org/licenses/ */
1454 contract IProposalCategory {
1455 
1456     event Category(
1457         uint indexed categoryId,
1458         string categoryName,
1459         string actionHash
1460     );
1461 
1462     /// @dev Adds new category
1463     /// @param _name Category name
1464     /// @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
1465     /// @param _allowedToCreateProposal Member roles allowed to create the proposal
1466     /// @param _majorityVotePerc Majority Vote threshold for Each voting layer
1467     /// @param _quorumPerc minimum threshold percentage required in voting to calculate result
1468     /// @param _closingTime Vote closing time for Each voting layer
1469     /// @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
1470     /// @param _contractAddress address of contract to call after proposal is accepted
1471     /// @param _contractName name of contract to be called after proposal is accepted
1472     /// @param _incentives rewards to distributed after proposal is accepted
1473     function addCategory(
1474         string calldata _name, 
1475         uint _memberRoleToVote,
1476         uint _majorityVotePerc, 
1477         uint _quorumPerc, 
1478         uint[] calldata _allowedToCreateProposal,
1479         uint _closingTime,
1480         string calldata _actionHash,
1481         address _contractAddress,
1482         bytes2 _contractName,
1483         uint[] calldata _incentives
1484     ) 
1485         external;
1486 
1487     /// @dev gets category details
1488     function category(uint _categoryId)
1489         external
1490         view
1491         returns(
1492             uint categoryId,
1493             uint memberRoleToVote,
1494             uint majorityVotePerc,
1495             uint quorumPerc,
1496             uint[] memory allowedToCreateProposal,
1497             uint closingTime,
1498             uint minStake
1499         );
1500     
1501     ///@dev gets category action details
1502     function categoryAction(uint _categoryId)
1503         external
1504         view
1505         returns(
1506             uint categoryId,
1507             address contractAddress,
1508             bytes2 contractName,
1509             uint defaultIncentive
1510         );
1511     
1512     /// @dev Gets Total number of categories added till now
1513     function totalCategories() external view returns(uint numberOfCategories);
1514 
1515     /// @dev Updates category details
1516     /// @param _categoryId Category id that needs to be updated
1517     /// @param _name Category name
1518     /// @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
1519     /// @param _allowedToCreateProposal Member roles allowed to create the proposal
1520     /// @param _majorityVotePerc Majority Vote threshold for Each voting layer
1521     /// @param _quorumPerc minimum threshold percentage required in voting to calculate result
1522     /// @param _closingTime Vote closing time for Each voting layer
1523     /// @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
1524     /// @param _contractAddress address of contract to call after proposal is accepted
1525     /// @param _contractName name of contract to be called after proposal is accepted
1526     /// @param _incentives rewards to distributed after proposal is accepted
1527     function updateCategory(
1528         uint _categoryId, 
1529         string memory _name, 
1530         uint _memberRoleToVote, 
1531         uint _majorityVotePerc, 
1532         uint _quorumPerc,
1533         uint[] memory _allowedToCreateProposal,
1534         uint _closingTime,
1535         string memory _actionHash,
1536         address _contractAddress,
1537         bytes2 _contractName,
1538         uint[] memory _incentives
1539     )
1540         public;
1541 
1542 }
1543 
1544 /* Copyright (C) 2017 GovBlocks.io
1545   This program is free software: you can redistribute it and/or modify
1546     it under the terms of the GNU General Public License as published by
1547     the Free Software Foundation, either version 3 of the License, or
1548     (at your option) any later version.
1549   This program is distributed in the hope that it will be useful,
1550     but WITHOUT ANY WARRANTY; without even the implied warranty of
1551     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1552     GNU General Public License for more details.
1553   You should have received a copy of the GNU General Public License
1554     along with this program.  If not, see http://www.gnu.org/licenses/ */
1555 contract IMaster {
1556     function getLatestAddress(bytes2 _module) public view returns(address);
1557 }
1558 
1559 contract Governed {
1560 
1561     address public masterAddress; // Name of the dApp, needs to be set by contracts inheriting this contract
1562 
1563     /// @dev modifier that allows only the authorized addresses to execute the function
1564     modifier onlyAuthorizedToGovern() {
1565         IMaster ms = IMaster(masterAddress);
1566         require(ms.getLatestAddress("GV") == msg.sender, "Not authorized");
1567         _;
1568     }
1569 
1570     /// @dev checks if an address is authorized to govern
1571     function isAuthorizedToGovern(address _toCheck) public view returns(bool) {
1572         IMaster ms = IMaster(masterAddress);
1573         return (ms.getLatestAddress("GV") == _toCheck);
1574     } 
1575 
1576 }
1577 
1578 /**
1579  * @title ERC20 interface
1580  * @dev see https://github.com/ethereum/EIPs/issues/20
1581  */
1582 interface IERC20 {
1583     function transfer(address to, uint256 value) external returns (bool);
1584 
1585     function approve(address spender, uint256 value)
1586         external returns (bool);
1587 
1588     function transferFrom(address from, address to, uint256 value)
1589         external returns (bool);
1590 
1591     function totalSupply() external view returns (uint256);
1592 
1593     function balanceOf(address who) external view returns (uint256);
1594 
1595     function allowance(address owner, address spender)
1596         external view returns (uint256);
1597 
1598     event Transfer(
1599         address indexed from,
1600         address indexed to,
1601         uint256 value
1602     );
1603 
1604     event Approval(
1605         address indexed owner,
1606         address indexed spender,
1607         uint256 value
1608     );
1609 }
1610 
1611 /* Copyright (C) 2017 NexusMutual.io
1612 
1613   This program is free software: you can redistribute it and/or modify
1614     it under the terms of the GNU General Public License as published by
1615     the Free Software Foundation, either version 3 of the License, or
1616     (at your option) any later version.
1617 
1618   This program is distributed in the hope that it will be useful,
1619     but WITHOUT ANY WARRANTY; without even the implied warranty of
1620     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1621     GNU General Public License for more details.
1622 
1623   You should have received a copy of the GNU General Public License
1624     along with this program.  If not, see http://www.gnu.org/licenses/ */
1625 contract NXMToken is IERC20 {
1626     using SafeMath for uint256;
1627 
1628     event WhiteListed(address indexed member);
1629 
1630     event BlackListed(address indexed member);
1631 
1632     mapping (address => uint256) private _balances;
1633 
1634     mapping (address => mapping (address => uint256)) private _allowed;
1635 
1636     mapping (address => bool) public whiteListed;
1637 
1638     mapping(address => uint) public isLockedForMV;
1639 
1640     uint256 private _totalSupply;
1641 
1642     string public name = "NXM";
1643     string public symbol = "NXM";
1644     uint8 public decimals = 18;
1645     address public operator;
1646 
1647     modifier canTransfer(address _to) {
1648         require(whiteListed[_to]);
1649         _;
1650     }
1651 
1652     modifier onlyOperator() {
1653         if (operator != address(0))
1654             require(msg.sender == operator);
1655         _;
1656     }
1657 
1658     constructor(address _founderAddress, uint _initialSupply) public {
1659         _mint(_founderAddress, _initialSupply);
1660     }
1661 
1662     /**
1663     * @dev Total number of tokens in existence
1664     */
1665     function totalSupply() public view returns (uint256) {
1666         return _totalSupply;
1667     }
1668 
1669     /**
1670     * @dev Gets the balance of the specified address.
1671     * @param owner The address to query the balance of.
1672     * @return An uint256 representing the amount owned by the passed address.
1673     */
1674     function balanceOf(address owner) public view returns (uint256) {
1675         return _balances[owner];
1676     }
1677 
1678     /**
1679     * @dev Function to check the amount of tokens that an owner allowed to a spender.
1680     * @param owner address The address which owns the funds.
1681     * @param spender address The address which will spend the funds.
1682     * @return A uint256 specifying the amount of tokens still available for the spender.
1683     */
1684     function allowance(
1685         address owner,
1686         address spender
1687     )
1688         public
1689         view
1690         returns (uint256)
1691     {
1692         return _allowed[owner][spender];
1693     }
1694 
1695     /**
1696     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1697     * Beware that changing an allowance with this method brings the risk that someone may use both the old
1698     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1699     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1700     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1701     * @param spender The address which will spend the funds.
1702     * @param value The amount of tokens to be spent.
1703     */
1704     function approve(address spender, uint256 value) public returns (bool) {
1705         require(spender != address(0));
1706 
1707         _allowed[msg.sender][spender] = value;
1708         emit Approval(msg.sender, spender, value);
1709         return true;
1710     }
1711 
1712     /**
1713     * @dev Increase the amount of tokens that an owner allowed to a spender.
1714     * approve should be called when allowed_[_spender] == 0. To increment
1715     * allowed value is better to use this function to avoid 2 calls (and wait until
1716     * the first transaction is mined)
1717     * From MonolithDAO Token.sol
1718     * @param spender The address which will spend the funds.
1719     * @param addedValue The amount of tokens to increase the allowance by.
1720     */
1721     function increaseAllowance(
1722         address spender,
1723         uint256 addedValue
1724     )
1725         public
1726         returns (bool)
1727     {
1728         require(spender != address(0));
1729 
1730         _allowed[msg.sender][spender] = (
1731         _allowed[msg.sender][spender].add(addedValue));
1732         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1733         return true;
1734     }
1735 
1736     /**
1737     * @dev Decrease the amount of tokens that an owner allowed to a spender.
1738     * approve should be called when allowed_[_spender] == 0. To decrement
1739     * allowed value is better to use this function to avoid 2 calls (and wait until
1740     * the first transaction is mined)
1741     * From MonolithDAO Token.sol
1742     * @param spender The address which will spend the funds.
1743     * @param subtractedValue The amount of tokens to decrease the allowance by.
1744     */
1745     function decreaseAllowance(
1746         address spender,
1747         uint256 subtractedValue
1748     )
1749         public
1750         returns (bool)
1751     {
1752         require(spender != address(0));
1753 
1754         _allowed[msg.sender][spender] = (
1755         _allowed[msg.sender][spender].sub(subtractedValue));
1756         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1757         return true;
1758     }
1759 
1760     /**
1761     * @dev Adds a user to whitelist
1762     * @param _member address to add to whitelist
1763     */
1764     function addToWhiteList(address _member) public onlyOperator returns (bool) {
1765         whiteListed[_member] = true;
1766         emit WhiteListed(_member);
1767         return true;
1768     }
1769 
1770     /**
1771     * @dev removes a user from whitelist
1772     * @param _member address to remove from whitelist
1773     */
1774     function removeFromWhiteList(address _member) public onlyOperator returns (bool) {
1775         whiteListed[_member] = false;
1776         emit BlackListed(_member);
1777         return true;
1778     }
1779 
1780     /**
1781     * @dev change operator address 
1782     * @param _newOperator address of new operator
1783     */
1784     function changeOperator(address _newOperator) public onlyOperator returns (bool) {
1785         operator = _newOperator;
1786         return true;
1787     }
1788 
1789     /**
1790     * @dev burns an amount of the tokens of the message sender
1791     * account.
1792     * @param amount The amount that will be burnt.
1793     */
1794     function burn(uint256 amount) public returns (bool) {
1795         _burn(msg.sender, amount);
1796         return true;
1797     }
1798 
1799     /**
1800     * @dev Burns a specific amount of tokens from the target address and decrements allowance
1801     * @param from address The address which you want to send tokens from
1802     * @param value uint256 The amount of token to be burned
1803     */
1804     function burnFrom(address from, uint256 value) public returns (bool) {
1805         _burnFrom(from, value);
1806         return true;
1807     }
1808 
1809     /**
1810     * @dev function that mints an amount of the token and assigns it to
1811     * an account.
1812     * @param account The account that will receive the created tokens.
1813     * @param amount The amount that will be created.
1814     */
1815     function mint(address account, uint256 amount) public onlyOperator {
1816         _mint(account, amount);
1817     }
1818 
1819     /**
1820     * @dev Transfer token for a specified address
1821     * @param to The address to transfer to.
1822     * @param value The amount to be transferred.
1823     */
1824     function transfer(address to, uint256 value) public canTransfer(to) returns (bool) {
1825 
1826         require(isLockedForMV[msg.sender] < now); // if not voted under governance
1827         require(value <= _balances[msg.sender]);
1828         _transfer(to, value); 
1829         return true;
1830     }
1831 
1832     /**
1833     * @dev Transfer tokens to the operator from the specified address
1834     * @param from The address to transfer from.
1835     * @param value The amount to be transferred.
1836     */
1837     function operatorTransfer(address from, uint256 value) public onlyOperator returns (bool) {
1838         require(value <= _balances[from]);
1839         _transferFrom(from, operator, value);
1840         return true;
1841     }
1842 
1843     /**
1844     * @dev Transfer tokens from one address to another
1845     * @param from address The address which you want to send tokens from
1846     * @param to address The address which you want to transfer to
1847     * @param value uint256 the amount of tokens to be transferred
1848     */
1849     function transferFrom(
1850         address from,
1851         address to,
1852         uint256 value
1853     )
1854         public
1855         canTransfer(to)
1856         returns (bool)
1857     {
1858         require(isLockedForMV[from] < now); // if not voted under governance
1859         require(value <= _balances[from]);
1860         require(value <= _allowed[from][msg.sender]);
1861         _transferFrom(from, to, value);
1862         return true;
1863     }
1864 
1865     /**
1866      * @dev Lock the user's tokens 
1867      * @param _of user's address.
1868      */
1869     function lockForMemberVote(address _of, uint _days) public onlyOperator {
1870         if (_days.add(now) > isLockedForMV[_of])
1871             isLockedForMV[_of] = _days.add(now);
1872     }
1873 
1874     /**
1875     * @dev Transfer token for a specified address
1876     * @param to The address to transfer to.
1877     * @param value The amount to be transferred.
1878     */
1879     function _transfer(address to, uint256 value) internal {
1880         _balances[msg.sender] = _balances[msg.sender].sub(value);
1881         _balances[to] = _balances[to].add(value);
1882         emit Transfer(msg.sender, to, value);
1883     }
1884 
1885     /**
1886     * @dev Transfer tokens from one address to another
1887     * @param from address The address which you want to send tokens from
1888     * @param to address The address which you want to transfer to
1889     * @param value uint256 the amount of tokens to be transferred
1890     */
1891     function _transferFrom(
1892         address from,
1893         address to,
1894         uint256 value
1895     )
1896         internal
1897     {
1898         _balances[from] = _balances[from].sub(value);
1899         _balances[to] = _balances[to].add(value);
1900         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1901         emit Transfer(from, to, value);
1902     }
1903 
1904     /**
1905     * @dev Internal function that mints an amount of the token and assigns it to
1906     * an account. This encapsulates the modification of balances such that the
1907     * proper events are emitted.
1908     * @param account The account that will receive the created tokens.
1909     * @param amount The amount that will be created.
1910     */
1911     function _mint(address account, uint256 amount) internal {
1912         require(account != address(0));
1913         _totalSupply = _totalSupply.add(amount);
1914         _balances[account] = _balances[account].add(amount);
1915         emit Transfer(address(0), account, amount);
1916     }
1917 
1918     /**
1919     * @dev Internal function that burns an amount of the token of a given
1920     * account.
1921     * @param account The account whose tokens will be burnt.
1922     * @param amount The amount that will be burnt.
1923     */
1924     function _burn(address account, uint256 amount) internal {
1925         require(amount <= _balances[account]);
1926 
1927         _totalSupply = _totalSupply.sub(amount);
1928         _balances[account] = _balances[account].sub(amount);
1929         emit Transfer(account, address(0), amount);
1930     }
1931 
1932     /**
1933     * @dev Internal function that burns an amount of the token of a given
1934     * account, deducting from the sender's allowance for said account. Uses the
1935     * internal burn function.
1936     * @param account The account whose tokens will be burnt.
1937     * @param value The amount that will be burnt.
1938     */
1939     function _burnFrom(address account, uint256 value) internal {
1940         require(value <= _allowed[account][msg.sender]);
1941 
1942         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
1943         // this function needs to emit an event with the updated approval.
1944         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
1945         value);
1946         _burn(account, value);
1947     }
1948 }
1949 
1950 interface IPooledStaking {
1951 
1952     function pushReward(address contractAddress, uint amount) external;
1953     function pushBurn(address contractAddress, uint amount) external;
1954     function hasPendingActions() external view returns (bool);
1955 
1956     function contractStake(address contractAddress) external view returns (uint);
1957     function stakerReward(address staker) external view returns (uint);
1958     function stakerDeposit(address staker) external view returns (uint);
1959     function stakerContractStake(address staker, address contractAddress) external view returns (uint);
1960 
1961     function withdraw(uint amount) external;
1962     function stakerMaxWithdrawable(address stakerAddress) external view returns (uint);
1963     function withdrawReward(address stakerAddress) external;
1964 }
1965 
1966 /* Copyright (C) 2020 NexusMutual.io
1967 
1968   This program is free software: you can redistribute it and/or modify
1969     it under the terms of the GNU General Public License as published by
1970     the Free Software Foundation, either version 3 of the License, or
1971     (at your option) any later version.
1972 
1973   This program is distributed in the hope that it will be useful,
1974     but WITHOUT ANY WARRANTY; without even the implied warranty of
1975     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1976     GNU General Public License for more details.
1977 
1978   You should have received a copy of the GNU General Public License
1979     along with this program.  If not, see http://www.gnu.org/licenses/ */
1980 contract TokenFunctions is Iupgradable {
1981     using SafeMath for uint;
1982 
1983     MCR internal m1;
1984     MemberRoles internal mr;
1985     NXMToken public tk;
1986     TokenController internal tc;
1987     TokenData internal td;
1988     QuotationData internal qd;
1989     ClaimsReward internal cr;
1990     Governance internal gv;
1991     PoolData internal pd;
1992     IPooledStaking pooledStaking;
1993 
1994     event BurnCATokens(uint claimId, address addr, uint amount);
1995 
1996     /**
1997      * @dev Rewards stakers on purchase of cover on smart contract.
1998      * @param _contractAddress smart contract address.
1999      * @param _coverPriceNXM cover price in NXM.
2000      */
2001     function pushStakerRewards(address _contractAddress, uint _coverPriceNXM) external onlyInternal {
2002         uint rewardValue = _coverPriceNXM.mul(td.stakerCommissionPer()).div(100);
2003         pooledStaking.pushReward(_contractAddress, rewardValue);
2004     }
2005 
2006     /**
2007     * @dev Deprecated in favor of burnStakedTokens
2008     */
2009     function burnStakerLockedToken(uint, bytes4, uint) external {
2010         // noop
2011     }
2012 
2013     /**
2014     * @dev Burns tokens staked on smart contract covered by coverId. Called when a payout is succesfully executed.
2015     * @param coverId cover id
2016     * @param coverCurrency cover currency
2017     * @param sumAssured amount of $curr to burn
2018     */
2019     function burnStakedTokens(uint coverId, bytes4 coverCurrency, uint sumAssured) external onlyInternal {
2020         (, address scAddress) = qd.getscAddressOfCover(coverId);
2021         uint tokenPrice = m1.calculateTokenPrice(coverCurrency);
2022         uint burnNXMAmount = sumAssured.mul(1e18).div(tokenPrice);
2023         pooledStaking.pushBurn(scAddress, burnNXMAmount);
2024     }
2025 
2026     /**
2027      * @dev Gets the total staked NXM tokens against
2028      * Smart contract by all stakers
2029      * @param _stakedContractAddress smart contract address.
2030      * @return amount total staked NXM tokens.
2031      */
2032     function deprecated_getTotalStakedTokensOnSmartContract(
2033         address _stakedContractAddress
2034     )
2035         external
2036         view
2037         returns(uint)
2038     {
2039         uint stakedAmount = 0;
2040         address stakerAddress;
2041         uint staketLen = td.getStakedContractStakersLength(_stakedContractAddress);
2042 
2043         for (uint i = 0; i < staketLen; i++) {
2044             stakerAddress = td.getStakedContractStakerByIndex(_stakedContractAddress, i);
2045             uint stakerIndex = td.getStakedContractStakerIndex(
2046                 _stakedContractAddress, i);
2047             uint currentlyStaked;
2048             (, currentlyStaked) = _deprecated_unlockableBeforeBurningAndCanBurn(stakerAddress,
2049                 _stakedContractAddress, stakerIndex);
2050             stakedAmount = stakedAmount.add(currentlyStaked);
2051         }
2052 
2053         return stakedAmount;
2054     }
2055 
2056     /**
2057      * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
2058      * @param _of address of the coverHolder.
2059      * @param _coverId coverId of the cover.
2060      */
2061     function getUserLockedCNTokens(address _of, uint _coverId) external view returns(uint) {
2062         return _getUserLockedCNTokens(_of, _coverId);
2063     } 
2064 
2065     /**
2066      * @dev to get the all the cover locked tokens of a user 
2067      * @param _of is the user address in concern
2068      * @return amount locked
2069      */
2070     function getUserAllLockedCNTokens(address _of) external view returns(uint amount) {
2071         for (uint i = 0; i < qd.getUserCoverLength(_of); i++) {
2072             amount = amount.add(_getUserLockedCNTokens(_of, qd.getAllCoversOfUser(_of)[i]));
2073         }
2074     }
2075 
2076     /**
2077      * @dev Returns amount of NXM Tokens locked as Cover Note against given coverId.
2078      * @param _coverId coverId of the cover.
2079      */
2080     function getLockedCNAgainstCover(uint _coverId) external view returns(uint) {
2081         return _getLockedCNAgainstCover(_coverId);
2082     }
2083 
2084     /**
2085      * @dev Returns total amount of staked NXM Tokens on all smart contracts.
2086      * @param _stakerAddress address of the Staker.
2087      */ 
2088     function deprecated_getStakerAllLockedTokens(address _stakerAddress) external view returns (uint amount) {
2089         uint stakedAmount = 0;
2090         address scAddress;
2091         uint scIndex;
2092         for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
2093             scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
2094             scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
2095             uint currentlyStaked;
2096             (, currentlyStaked) = _deprecated_unlockableBeforeBurningAndCanBurn(_stakerAddress, scAddress, i);
2097             stakedAmount = stakedAmount.add(currentlyStaked);
2098         }
2099         amount = stakedAmount;
2100     }
2101 
2102     /**
2103      * @dev Returns total unlockable amount of staked NXM Tokens on all smart contract .
2104      * @param _stakerAddress address of the Staker.
2105      */
2106     function deprecated_getStakerAllUnlockableStakedTokens(
2107         address _stakerAddress
2108     )
2109     external
2110     view
2111     returns (uint amount)
2112     {
2113         uint unlockableAmount = 0;
2114         address scAddress;
2115         uint scIndex;
2116         for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
2117             scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
2118             scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
2119             unlockableAmount = unlockableAmount.add(
2120                 _deprecated_getStakerUnlockableTokensOnSmartContract(_stakerAddress, scAddress,
2121                 scIndex));
2122         }
2123         amount = unlockableAmount;
2124     }
2125 
2126     /**
2127      * @dev Change Dependent Contract Address
2128      */
2129     function changeDependentContractAddress() public {
2130         tk = NXMToken(ms.tokenAddress());
2131         td = TokenData(ms.getLatestAddress("TD"));
2132         tc = TokenController(ms.getLatestAddress("TC"));
2133         cr = ClaimsReward(ms.getLatestAddress("CR"));
2134         qd = QuotationData(ms.getLatestAddress("QD"));
2135         m1 = MCR(ms.getLatestAddress("MC"));
2136         gv = Governance(ms.getLatestAddress("GV"));
2137         mr = MemberRoles(ms.getLatestAddress("MR"));
2138         pd = PoolData(ms.getLatestAddress("PD"));
2139         pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
2140     }
2141 
2142     /**
2143      * @dev Gets the Token price in a given currency
2144      * @param curr Currency name.
2145      * @return price Token Price.
2146      */
2147     function getTokenPrice(bytes4 curr) public view returns(uint price) {
2148         price = m1.calculateTokenPrice(curr);
2149     }
2150 
2151     /**
2152      * @dev Set the flag to check if cover note is deposited against the cover id
2153      * @param coverId Cover Id.
2154      */ 
2155     function depositCN(uint coverId) public onlyInternal returns (bool success) {
2156         require(_getLockedCNAgainstCover(coverId) > 0, "No cover note available");
2157         td.setDepositCN(coverId, true);
2158         success = true;    
2159     }
2160 
2161     /**
2162      * @param _of address of Member
2163      * @param _coverId Cover Id
2164      * @param _lockTime Pending Time + Cover Period 7*1 days
2165      */ 
2166     function extendCNEPOff(address _of, uint _coverId, uint _lockTime) public onlyInternal {
2167         uint timeStamp = now.add(_lockTime);
2168         uint coverValidUntil = qd.getValidityOfCover(_coverId);
2169         if (timeStamp >= coverValidUntil) {
2170             bytes32 reason = keccak256(abi.encodePacked("CN", _of, _coverId));
2171             tc.extendLockOf(_of, reason, timeStamp);
2172         } 
2173     }
2174 
2175     /**
2176      * @dev to burn the deposited cover tokens 
2177      * @param coverId is id of cover whose tokens have to be burned
2178      * @return the status of the successful burning
2179      */
2180     function burnDepositCN(uint coverId) public onlyInternal returns (bool success) {
2181         address _of = qd.getCoverMemberAddress(coverId);
2182         uint amount;
2183         (amount, ) = td.depositedCN(coverId);
2184         amount = (amount.mul(50)).div(100);
2185         bytes32 reason = keccak256(abi.encodePacked("CN", _of, coverId));
2186         tc.burnLockedTokens(_of, reason, amount);
2187         success = true;
2188     }
2189 
2190     /**
2191      * @dev Unlocks covernote locked against a given cover 
2192      * @param coverId id of cover
2193      */ 
2194     function unlockCN(uint coverId) public onlyInternal {
2195         (, bool isDeposited) = td.depositedCN(coverId);
2196         require(!isDeposited,"Cover note is deposited and can not be released");
2197         uint lockedCN = _getLockedCNAgainstCover(coverId);
2198         if (lockedCN != 0) {
2199             address coverHolder = qd.getCoverMemberAddress(coverId);
2200             bytes32 reason = keccak256(abi.encodePacked("CN", coverHolder, coverId));
2201             tc.releaseLockedTokens(coverHolder, reason, lockedCN);
2202         }
2203     }
2204 
2205     /** 
2206      * @dev Burns tokens used for fraudulent voting against a claim
2207      * @param claimid Claim Id.
2208      * @param _value number of tokens to be burned
2209      * @param _of Claim Assessor's address.
2210      */     
2211     function burnCAToken(uint claimid, uint _value, address _of) public {
2212 
2213         require(ms.checkIsAuthToGoverned(msg.sender));
2214         tc.burnLockedTokens(_of, "CLA", _value);
2215         emit BurnCATokens(claimid, _of, _value);
2216     }
2217 
2218     /**
2219      * @dev to lock cover note tokens
2220      * @param coverNoteAmount is number of tokens to be locked
2221      * @param coverPeriod is cover period in concern
2222      * @param coverId is the cover id of cover in concern
2223      * @param _of address whose tokens are to be locked
2224      */
2225     function lockCN(
2226         uint coverNoteAmount,
2227         uint coverPeriod,
2228         uint coverId,
2229         address _of
2230     )
2231         public
2232         onlyInternal
2233     {
2234         uint validity = (coverPeriod * 1 days).add(td.lockTokenTimeAfterCoverExp());
2235         bytes32 reason = keccak256(abi.encodePacked("CN", _of, coverId));
2236         td.setDepositCNAmount(coverId, coverNoteAmount);
2237         tc.lockOf(_of, reason, coverNoteAmount, validity);
2238     }
2239 
2240     /**
2241      * @dev to check if a  member is locked for member vote 
2242      * @param _of is the member address in concern
2243      * @return the boolean status
2244      */
2245     function isLockedForMemberVote(address _of) public view returns(bool) {
2246         return now < tk.isLockedForMV(_of);
2247     }
2248 
2249     /**
2250      * @dev Internal function to gets amount of locked NXM tokens,
2251      * staked against smartcontract by index
2252      * @param _stakerAddress address of user
2253      * @param _stakedContractAddress staked contract address
2254      * @param _stakedContractIndex index of staking
2255      */
2256     function deprecated_getStakerLockedTokensOnSmartContract (
2257         address _stakerAddress,
2258         address _stakedContractAddress,
2259         uint _stakedContractIndex
2260     )
2261         public
2262         view
2263         returns
2264         (uint amount)
2265     {
2266         amount = _deprecated_getStakerLockedTokensOnSmartContract(_stakerAddress,
2267             _stakedContractAddress, _stakedContractIndex);
2268     }
2269 
2270     /**
2271      * @dev Function to gets unlockable amount of locked NXM
2272      * tokens, staked against smartcontract by index
2273      * @param stakerAddress address of staker
2274      * @param stakedContractAddress staked contract address
2275      * @param stakerIndex index of staking
2276      */
2277     function deprecated_getStakerUnlockableTokensOnSmartContract (
2278         address stakerAddress,
2279         address stakedContractAddress,
2280         uint stakerIndex
2281     )
2282         public
2283         view
2284         returns (uint)
2285     {
2286         return _deprecated_getStakerUnlockableTokensOnSmartContract(stakerAddress, stakedContractAddress,
2287         td.getStakerStakedContractIndex(stakerAddress, stakerIndex));
2288     }
2289 
2290     /**
2291      * @dev releases unlockable staked tokens to staker 
2292      */
2293     function deprecated_unlockStakerUnlockableTokens(address _stakerAddress) public checkPause {
2294         uint unlockableAmount;
2295         address scAddress;
2296         bytes32 reason;
2297         uint scIndex;
2298         for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
2299             scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
2300             scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
2301             unlockableAmount = _deprecated_getStakerUnlockableTokensOnSmartContract(
2302             _stakerAddress, scAddress,
2303             scIndex);
2304             td.setUnlockableBeforeLastBurnTokens(_stakerAddress, i, 0);
2305             td.pushUnlockedStakedTokens(_stakerAddress, i, unlockableAmount);
2306             reason = keccak256(abi.encodePacked("UW", _stakerAddress, scAddress, scIndex));
2307             tc.releaseLockedTokens(_stakerAddress, reason, unlockableAmount);
2308         }
2309     }
2310 
2311     /**
2312      * @dev to get tokens of staker locked before burning that are allowed to burn 
2313      * @param stakerAdd is the address of the staker 
2314      * @param stakedAdd is the address of staked contract in concern 
2315      * @param stakerIndex is the staker index in concern
2316      * @return amount of unlockable tokens
2317      * @return amount of tokens that can burn
2318      */
2319     function _deprecated_unlockableBeforeBurningAndCanBurn(
2320         address stakerAdd, 
2321         address stakedAdd, 
2322         uint stakerIndex
2323     )
2324     public
2325     view
2326     returns
2327     (uint amount, uint canBurn) {
2328 
2329         uint dateAdd;
2330         uint initialStake;
2331         uint totalBurnt;
2332         uint ub;
2333         (, , dateAdd, initialStake, , totalBurnt, ub) = td.stakerStakedContracts(stakerAdd, stakerIndex);
2334         canBurn = _deprecated_calculateStakedTokens(initialStake, now.sub(dateAdd).div(1 days), td.scValidDays());
2335         // Can't use SafeMaths for int.
2336         int v = int(initialStake - (canBurn) - (totalBurnt) - (
2337             td.getStakerUnlockedStakedTokens(stakerAdd, stakerIndex)) - (ub));
2338         uint currentLockedTokens = _deprecated_getStakerLockedTokensOnSmartContract(
2339             stakerAdd, stakedAdd, td.getStakerStakedContractIndex(stakerAdd, stakerIndex));
2340         if (v < 0) {
2341             v = 0;
2342         }
2343         amount = uint(v);
2344         if (canBurn > currentLockedTokens.sub(amount).sub(ub)) {
2345             canBurn = currentLockedTokens.sub(amount).sub(ub);
2346         }
2347     }
2348 
2349     /**
2350      * @dev to get tokens of staker that are unlockable
2351      * @param _stakerAddress is the address of the staker 
2352      * @param _stakedContractAddress is the address of staked contract in concern 
2353      * @param _stakedContractIndex is the staked contract index in concern
2354      * @return amount of unlockable tokens
2355      */
2356     function _deprecated_getStakerUnlockableTokensOnSmartContract (
2357         address _stakerAddress,
2358         address _stakedContractAddress,
2359         uint _stakedContractIndex
2360     ) 
2361         public
2362         view
2363         returns
2364         (uint amount)
2365     {   
2366         uint initialStake;
2367         uint stakerIndex = td.getStakedContractStakerIndex(
2368             _stakedContractAddress, _stakedContractIndex);
2369         uint burnt;
2370         (, , , initialStake, , burnt,) = td.stakerStakedContracts(_stakerAddress, stakerIndex);
2371         uint alreadyUnlocked = td.getStakerUnlockedStakedTokens(_stakerAddress, stakerIndex);
2372         uint currentStakedTokens;
2373         (, currentStakedTokens) = _deprecated_unlockableBeforeBurningAndCanBurn(_stakerAddress,
2374             _stakedContractAddress, stakerIndex);
2375         amount = initialStake.sub(currentStakedTokens).sub(alreadyUnlocked).sub(burnt);
2376     }
2377 
2378     /**
2379      * @dev Internal function to get the amount of locked NXM tokens,
2380      * staked against smartcontract by index
2381      * @param _stakerAddress address of user
2382      * @param _stakedContractAddress staked contract address
2383      * @param _stakedContractIndex index of staking
2384      */
2385     function _deprecated_getStakerLockedTokensOnSmartContract (
2386         address _stakerAddress,
2387         address _stakedContractAddress,
2388         uint _stakedContractIndex
2389     )
2390         internal
2391         view
2392         returns
2393         (uint amount)
2394     {   
2395         bytes32 reason = keccak256(abi.encodePacked("UW", _stakerAddress,
2396             _stakedContractAddress, _stakedContractIndex));
2397         amount = tc.tokensLocked(_stakerAddress, reason);
2398     }
2399 
2400     /**
2401      * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
2402      * @param _coverId coverId of the cover.
2403      */
2404     function _getLockedCNAgainstCover(uint _coverId) internal view returns(uint) {
2405         address coverHolder = qd.getCoverMemberAddress(_coverId);
2406         bytes32 reason = keccak256(abi.encodePacked("CN", coverHolder, _coverId));
2407         return tc.tokensLockedAtTime(coverHolder, reason, now); 
2408     }
2409 
2410     /**
2411      * @dev Returns amount of NXM Tokens locked as Cover Note for given coverId.
2412      * @param _of address of the coverHolder.
2413      * @param _coverId coverId of the cover.
2414      */
2415     function _getUserLockedCNTokens(address _of, uint _coverId) internal view returns(uint) {
2416         bytes32 reason = keccak256(abi.encodePacked("CN", _of, _coverId));
2417         return tc.tokensLockedAtTime(_of, reason, now); 
2418     }
2419 
2420     /**
2421      * @dev Internal function to gets remaining amount of staked NXM tokens,
2422      * against smartcontract by index
2423      * @param _stakeAmount address of user
2424      * @param _stakeDays staked contract address
2425      * @param _validDays index of staking
2426      */
2427     function _deprecated_calculateStakedTokens(
2428         uint _stakeAmount,
2429         uint _stakeDays,
2430         uint _validDays
2431     ) 
2432         internal
2433         pure 
2434         returns (uint amount)
2435     {
2436         if (_validDays > _stakeDays) {
2437             uint rf = ((_validDays.sub(_stakeDays)).mul(100000)).div(_validDays);
2438             amount = (rf.mul(_stakeAmount)).div(100000);
2439         } else {
2440             amount = 0;
2441         }
2442     }
2443 
2444     /**
2445      * @dev Gets the total staked NXM tokens against Smart contract 
2446      * by all stakers
2447      * @param _stakedContractAddress smart contract address.
2448      * @return amount total staked NXM tokens.
2449      */
2450     function _deprecated_burnStakerTokenLockedAgainstSmartContract(
2451         address _stakerAddress,
2452         address _stakedContractAddress,
2453         uint _stakedContractIndex,
2454         uint _amount
2455     ) 
2456         internal
2457     {
2458         uint stakerIndex = td.getStakedContractStakerIndex(
2459             _stakedContractAddress, _stakedContractIndex);
2460         td.pushBurnedTokens(_stakerAddress, stakerIndex, _amount);
2461         bytes32 reason = keccak256(abi.encodePacked("UW", _stakerAddress,
2462             _stakedContractAddress, _stakedContractIndex));
2463         tc.burnLockedTokens(_stakerAddress, reason, _amount);
2464     }
2465 }
2466 
2467 /* Copyright (C) 2017 GovBlocks.io
2468   This program is free software: you can redistribute it and/or modify
2469     it under the terms of the GNU General Public License as published by
2470     the Free Software Foundation, either version 3 of the License, or
2471     (at your option) any later version.
2472   This program is distributed in the hope that it will be useful,
2473     but WITHOUT ANY WARRANTY; without even the implied warranty of
2474     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2475     GNU General Public License for more details.
2476   You should have received a copy of the GNU General Public License
2477     along with this program.  If not, see http://www.gnu.org/licenses/ */
2478 contract IMemberRoles {
2479 
2480     event MemberRole(uint256 indexed roleId, bytes32 roleName, string roleDescription);
2481     
2482     /// @dev Adds new member role
2483     /// @param _roleName New role name
2484     /// @param _roleDescription New description hash
2485     /// @param _authorized Authorized member against every role id
2486     function addRole(bytes32 _roleName, string memory _roleDescription, address _authorized) public;
2487 
2488     /// @dev Assign or Delete a member from specific role.
2489     /// @param _memberAddress Address of Member
2490     /// @param _roleId RoleId to update
2491     /// @param _active active is set to be True if we want to assign this role to member, False otherwise!
2492     function updateRole(address _memberAddress, uint _roleId, bool _active) public;
2493 
2494     /// @dev Change Member Address who holds the authority to Add/Delete any member from specific role.
2495     /// @param _roleId roleId to update its Authorized Address
2496     /// @param _authorized New authorized address against role id
2497     function changeAuthorized(uint _roleId, address _authorized) public;
2498 
2499     /// @dev Return number of member roles
2500     function totalRoles() public view returns(uint256);
2501 
2502     /// @dev Gets the member addresses assigned by a specific role
2503     /// @param _memberRoleId Member role id
2504     /// @return roleId Role id
2505     /// @return allMemberAddress Member addresses of specified role id
2506     function members(uint _memberRoleId) public view returns(uint, address[] memory allMemberAddress);
2507 
2508     /// @dev Gets all members' length
2509     /// @param _memberRoleId Member role id
2510     /// @return memberRoleData[_memberRoleId].memberAddress.length Member length
2511     function numberOfMembers(uint _memberRoleId) public view returns(uint);
2512     
2513     /// @dev Return member address who holds the right to add/remove any member from specific role.
2514     function authorized(uint _memberRoleId) public view returns(address);
2515 
2516     /// @dev Get All role ids array that has been assigned to a member so far.
2517     function roles(address _memberAddress) public view returns(uint[] memory assignedRoles);
2518 
2519     /// @dev Returns true if the given role id is assigned to a member.
2520     /// @param _memberAddress Address of member
2521     /// @param _roleId Checks member's authenticity with the roleId.
2522     /// i.e. Returns true if this roleId is assigned to member
2523     function checkRole(address _memberAddress, uint _roleId) public view returns(bool);   
2524 }
2525 
2526 /**
2527  * @title ERC1132 interface
2528  * @dev see https://github.com/ethereum/EIPs/issues/1132
2529  */
2530 contract IERC1132 {
2531     /**
2532      * @dev Reasons why a user's tokens have been locked
2533      */
2534     mapping(address => bytes32[]) public lockReason;
2535 
2536     /**
2537      * @dev locked token structure
2538      */
2539     struct LockToken {
2540         uint256 amount;
2541         uint256 validity;
2542         bool claimed;
2543     }
2544 
2545     /**
2546      * @dev Holds number & validity of tokens locked for a given reason for
2547      *      a specified address
2548      */
2549     mapping(address => mapping(bytes32 => LockToken)) public locked;
2550 
2551     /**
2552      * @dev Records data of all the tokens Locked
2553      */
2554     event Locked(
2555         address indexed _of,
2556         bytes32 indexed _reason,
2557         uint256 _amount,
2558         uint256 _validity
2559     );
2560 
2561     /**
2562      * @dev Records data of all the tokens unlocked
2563      */
2564     event Unlocked(
2565         address indexed _of,
2566         bytes32 indexed _reason,
2567         uint256 _amount
2568     );
2569     
2570     /**
2571      * @dev Locks a specified amount of tokens against an address,
2572      *      for a specified reason and time
2573      * @param _reason The reason to lock tokens
2574      * @param _amount Number of tokens to be locked
2575      * @param _time Lock time in seconds
2576      */
2577     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
2578         public returns (bool);
2579   
2580     /**
2581      * @dev Returns tokens locked for a specified address for a
2582      *      specified reason
2583      *
2584      * @param _of The address whose tokens are locked
2585      * @param _reason The reason to query the lock tokens for
2586      */
2587     function tokensLocked(address _of, bytes32 _reason)
2588         public view returns (uint256 amount);
2589     
2590     /**
2591      * @dev Returns tokens locked for a specified address for a
2592      *      specified reason at a specific time
2593      *
2594      * @param _of The address whose tokens are locked
2595      * @param _reason The reason to query the lock tokens for
2596      * @param _time The timestamp to query the lock tokens for
2597      */
2598     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
2599         public view returns (uint256 amount);
2600     
2601     /**
2602      * @dev Returns total tokens held by an address (locked + transferable)
2603      * @param _of The address to query the total balance of
2604      */
2605     function totalBalanceOf(address _of)
2606         public view returns (uint256 amount);
2607     
2608     /**
2609      * @dev Extends lock for a specified reason and time
2610      * @param _reason The reason to lock tokens
2611      * @param _time Lock extension time in seconds
2612      */
2613     function extendLock(bytes32 _reason, uint256 _time)
2614         public returns (bool);
2615     
2616     /**
2617      * @dev Increase number of tokens locked for a specified reason
2618      * @param _reason The reason to lock tokens
2619      * @param _amount Number of tokens to be increased
2620      */
2621     function increaseLockAmount(bytes32 _reason, uint256 _amount)
2622         public returns (bool);
2623 
2624     /**
2625      * @dev Returns unlockable tokens for a specified address for a specified reason
2626      * @param _of The address to query the the unlockable token count of
2627      * @param _reason The reason to query the unlockable tokens for
2628      */
2629     function tokensUnlockable(address _of, bytes32 _reason)
2630         public view returns (uint256 amount);
2631  
2632     /**
2633      * @dev Unlocks the unlockable tokens of a specified address
2634      * @param _of Address of user, claiming back unlockable tokens
2635      */
2636     function unlock(address _of)
2637         public returns (uint256 unlockableTokens);
2638 
2639     /**
2640      * @dev Gets the unlockable tokens of a specified address
2641      * @param _of The address to query the the unlockable token count of
2642      */
2643     function getUnlockableTokens(address _of)
2644         public view returns (uint256 unlockableTokens);
2645 
2646 }
2647 
2648 /* Copyright (C) 2020 NexusMutual.io
2649 
2650   This program is free software: you can redistribute it and/or modify
2651   it under the terms of the GNU General Public License as published by
2652   the Free Software Foundation, either version 3 of the License, or
2653   (at your option) any later version.
2654 
2655   This program is distributed in the hope that it will be useful,
2656   but WITHOUT ANY WARRANTY; without even the implied warranty of
2657   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2658   GNU General Public License for more details.
2659 
2660   You should have received a copy of the GNU General Public License
2661   along with this program.  If not, see http://www.gnu.org/licenses/ */
2662 contract TokenController is IERC1132, Iupgradable {
2663     using SafeMath for uint256;
2664 
2665     event Burned(address indexed member, bytes32 lockedUnder, uint256 amount);
2666 
2667     NXMToken public token;
2668     IPooledStaking public pooledStaking;
2669     uint public minCALockTime = uint(30).mul(1 days);
2670     bytes32 private constant CLA = bytes32("CLA");
2671 
2672     /**
2673     * @dev Just for interface
2674     */
2675     function changeDependentContractAddress() public {
2676         token = NXMToken(ms.tokenAddress());
2677         pooledStaking = IPooledStaking(ms.getLatestAddress('PS'));
2678     }
2679 
2680     /**
2681      * @dev to change the operator address
2682      * @param _newOperator is the new address of operator
2683      */
2684     function changeOperator(address _newOperator) public onlyInternal {
2685         token.changeOperator(_newOperator);
2686     }
2687 
2688     /**
2689     * @dev Locks a specified amount of tokens,
2690     *    for CLA reason and for a specified time
2691     * @param _reason The reason to lock tokens, currently restricted to CLA
2692     * @param _amount Number of tokens to be locked
2693     * @param _time Lock time in seconds
2694     */
2695     function lock(bytes32 _reason, uint256 _amount, uint256 _time) public checkPause returns (bool)
2696     {
2697         require(_reason == CLA,"Restricted to reason CLA");
2698         require(minCALockTime <= _time,"Should lock for minimum time");
2699         // If tokens are already locked, then functions extendLock or
2700         // increaseLockAmount should be used to make any changes
2701         _lock(msg.sender, _reason, _amount, _time);
2702         return true;
2703     }
2704 
2705     /**
2706     * @dev Locks a specified amount of tokens against an address,
2707     *    for a specified reason and time
2708     * @param _reason The reason to lock tokens
2709     * @param _amount Number of tokens to be locked
2710     * @param _time Lock time in seconds
2711     * @param _of address whose tokens are to be locked
2712     */
2713     function lockOf(address _of, bytes32 _reason, uint256 _amount, uint256 _time)
2714         public
2715         onlyInternal
2716         returns (bool)
2717     {
2718         // If tokens are already locked, then functions extendLock or
2719         // increaseLockAmount should be used to make any changes
2720         _lock(_of, _reason, _amount, _time);
2721         return true;
2722     }
2723 
2724     /**
2725     * @dev Extends lock for reason CLA for a specified time
2726     * @param _reason The reason to lock tokens, currently restricted to CLA
2727     * @param _time Lock extension time in seconds
2728     */
2729     function extendLock(bytes32 _reason, uint256 _time)
2730         public
2731         checkPause
2732         returns (bool)
2733     {
2734         require(_reason == CLA,"Restricted to reason CLA");
2735         _extendLock(msg.sender, _reason, _time);
2736         return true;
2737     }
2738 
2739     /**
2740     * @dev Extends lock for a specified reason and time
2741     * @param _reason The reason to lock tokens
2742     * @param _time Lock extension time in seconds
2743     */
2744     function extendLockOf(address _of, bytes32 _reason, uint256 _time)
2745         public
2746         onlyInternal
2747         returns (bool)
2748     {
2749         _extendLock(_of, _reason, _time);
2750         return true;
2751     }
2752 
2753     /**
2754     * @dev Increase number of tokens locked for a CLA reason
2755     * @param _reason The reason to lock tokens, currently restricted to CLA
2756     * @param _amount Number of tokens to be increased
2757     */
2758     function increaseLockAmount(bytes32 _reason, uint256 _amount)
2759         public
2760         checkPause
2761         returns (bool)
2762     {    
2763         require(_reason == CLA,"Restricted to reason CLA");
2764         require(_tokensLocked(msg.sender, _reason) > 0);
2765         token.operatorTransfer(msg.sender, _amount);
2766 
2767         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
2768         emit Locked(msg.sender, _reason, _amount, locked[msg.sender][_reason].validity);
2769         return true;
2770     }
2771 
2772     /**
2773      * @dev burns tokens of an address
2774      * @param _of is the address to burn tokens of
2775      * @param amount is the amount to burn
2776      * @return the boolean status of the burning process
2777      */
2778     function burnFrom (address _of, uint amount) public onlyInternal returns (bool) {
2779         return token.burnFrom(_of, amount);
2780     }
2781 
2782     /**
2783     * @dev Burns locked tokens of a user
2784     * @param _of address whose tokens are to be burned
2785     * @param _reason lock reason for which tokens are to be burned
2786     * @param _amount amount of tokens to burn
2787     */
2788     function burnLockedTokens(address _of, bytes32 _reason, uint256 _amount) public onlyInternal {
2789         _burnLockedTokens(_of, _reason, _amount);
2790     }
2791 
2792     /**
2793     * @dev reduce lock duration for a specified reason and time
2794     * @param _of The address whose tokens are locked
2795     * @param _reason The reason to lock tokens
2796     * @param _time Lock reduction time in seconds
2797     */
2798     function reduceLock(address _of, bytes32 _reason, uint256 _time) public onlyInternal {
2799         _reduceLock(_of, _reason, _time);
2800     }
2801 
2802     /**
2803     * @dev Released locked tokens of an address locked for a specific reason
2804     * @param _of address whose tokens are to be released from lock
2805     * @param _reason reason of the lock
2806     * @param _amount amount of tokens to release
2807     */
2808     function releaseLockedTokens(address _of, bytes32 _reason, uint256 _amount)
2809         public
2810         onlyInternal
2811     {
2812         _releaseLockedTokens(_of, _reason, _amount);
2813     }
2814 
2815     /**
2816     * @dev Adds an address to whitelist maintained in the contract
2817     * @param _member address to add to whitelist
2818     */
2819     function addToWhitelist(address _member) public onlyInternal {
2820         token.addToWhiteList(_member);
2821     }
2822 
2823     /**
2824     * @dev Removes an address from the whitelist in the token
2825     * @param _member address to remove
2826     */
2827     function removeFromWhitelist(address _member) public onlyInternal {
2828         token.removeFromWhiteList(_member);
2829     }
2830 
2831     /**
2832     * @dev Mints new token for an address
2833     * @param _member address to reward the minted tokens
2834     * @param _amount number of tokens to mint
2835     */
2836     function mint(address _member, uint _amount) public onlyInternal {
2837         token.mint(_member, _amount);
2838     }
2839 
2840     /**
2841      * @dev Lock the user's tokens
2842      * @param _of user's address.
2843      */
2844     function lockForMemberVote(address _of, uint _days) public onlyInternal {
2845         token.lockForMemberVote(_of, _days);
2846     }
2847 
2848     /**
2849     * @dev Unlocks the unlockable tokens against CLA of a specified address
2850     * @param _of Address of user, claiming back unlockable tokens against CLA
2851     */
2852     function unlock(address _of)
2853         public
2854         checkPause
2855         returns (uint256 unlockableTokens)
2856     {
2857         unlockableTokens = _tokensUnlockable(_of, CLA);
2858         if (unlockableTokens > 0) {
2859             locked[_of][CLA].claimed = true;
2860             emit Unlocked(_of, CLA, unlockableTokens);
2861             require(token.transfer(_of, unlockableTokens));
2862         }
2863     }
2864 
2865     /**
2866      * @dev Updates Uint Parameters of a code
2867      * @param code whose details we want to update
2868      * @param val value to set
2869      */
2870     function updateUintParameters(bytes8 code, uint val) public {
2871         require(ms.checkIsAuthToGoverned(msg.sender));
2872         if (code == "MNCLT") {
2873             minCALockTime = val.mul(1 days);
2874         } else {
2875             revert("Invalid param code");
2876         }
2877     }
2878 
2879     /**
2880     * @dev Gets the validity of locked tokens of a specified address
2881     * @param _of The address to query the validity
2882     * @param reason reason for which tokens were locked
2883     */
2884     function getLockedTokensValidity(address _of, bytes32 reason)
2885         public
2886         view
2887         returns (uint256 validity)
2888     {
2889         validity = locked[_of][reason].validity;
2890     }
2891 
2892     /**
2893     * @dev Gets the unlockable tokens of a specified address
2894     * @param _of The address to query the the unlockable token count of
2895     */
2896     function getUnlockableTokens(address _of)
2897         public
2898         view
2899         returns (uint256 unlockableTokens)
2900     {
2901         for (uint256 i = 0; i < lockReason[_of].length; i++) {
2902             unlockableTokens = unlockableTokens.add(_tokensUnlockable(_of, lockReason[_of][i]));
2903         }
2904     }
2905 
2906     /**
2907     * @dev Returns tokens locked for a specified address for a
2908     *    specified reason
2909     *
2910     * @param _of The address whose tokens are locked
2911     * @param _reason The reason to query the lock tokens for
2912     */
2913     function tokensLocked(address _of, bytes32 _reason)
2914         public
2915         view
2916         returns (uint256 amount)
2917     {
2918         return _tokensLocked(_of, _reason);
2919     }
2920 
2921     /**
2922     * @dev Returns unlockable tokens for a specified address for a specified reason
2923     * @param _of The address to query the the unlockable token count of
2924     * @param _reason The reason to query the unlockable tokens for
2925     */
2926     function tokensUnlockable(address _of, bytes32 _reason)
2927         public
2928         view
2929         returns (uint256 amount)
2930     {
2931         return _tokensUnlockable(_of, _reason);
2932     }
2933 
2934     function totalSupply() public view returns (uint256)
2935     {
2936         return token.totalSupply();
2937     }
2938 
2939     /**
2940     * @dev Returns tokens locked for a specified address for a
2941     *    specified reason at a specific time
2942     *
2943     * @param _of The address whose tokens are locked
2944     * @param _reason The reason to query the lock tokens for
2945     * @param _time The timestamp to query the lock tokens for
2946     */
2947     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
2948         public
2949         view
2950         returns (uint256 amount)
2951     {
2952         return _tokensLockedAtTime(_of, _reason, _time);
2953     }
2954 
2955     /**
2956     * @dev Returns the total amount of tokens held by an address:
2957     *   transferable + locked + staked for pooled staking - pending burns.
2958     *   Used by Claims and Governance in member voting to calculate the user's vote weight.
2959     *
2960     * @param _of The address to query the total balance of
2961     * @param _of The address to query the total balance of
2962     */
2963     function totalBalanceOf(address _of) public view returns (uint256 amount) {
2964 
2965         amount = token.balanceOf(_of);
2966 
2967         for (uint256 i = 0; i < lockReason[_of].length; i++) {
2968             amount = amount.add(_tokensLocked(_of, lockReason[_of][i]));
2969         }
2970 
2971         uint stakerReward = pooledStaking.stakerReward(_of);
2972         uint stakerDeposit = pooledStaking.stakerDeposit(_of);
2973 
2974         amount = amount.add(stakerDeposit).add(stakerReward);
2975     }
2976 
2977     /**
2978     * @dev Returns the total locked tokens at time
2979     *   Returns the total amount of locked and staked tokens at a given time. Used by MemberRoles to check eligibility
2980     *   for withdraw / switch membership. Includes tokens locked for Claim Assessment and staked for Risk Assessment.
2981     *   Does not take into account pending burns.
2982     *
2983     * @param _of member whose locked tokens are to be calculate
2984     * @param _time timestamp when the tokens should be locked
2985     */
2986     function totalLockedBalance(address _of, uint256 _time) public view returns (uint256 amount) {
2987 
2988         for (uint256 i = 0; i < lockReason[_of].length; i++) {
2989             amount = amount.add(_tokensLockedAtTime(_of, lockReason[_of][i], _time));
2990         }
2991 
2992         amount = amount.add(pooledStaking.stakerDeposit(_of));
2993     }
2994 
2995     /**
2996     * @dev Locks a specified amount of tokens against an address,
2997     *    for a specified reason and time
2998     * @param _of address whose tokens are to be locked
2999     * @param _reason The reason to lock tokens
3000     * @param _amount Number of tokens to be locked
3001     * @param _time Lock time in seconds
3002     */
3003     function _lock(address _of, bytes32 _reason, uint256 _amount, uint256 _time) internal {
3004         require(_tokensLocked(_of, _reason) == 0);
3005         require(_amount != 0);
3006 
3007         if (locked[_of][_reason].amount == 0) {
3008             lockReason[_of].push(_reason);
3009         }
3010 
3011         require(token.operatorTransfer(_of, _amount));
3012 
3013         uint256 validUntil = now.add(_time); //solhint-disable-line
3014         locked[_of][_reason] = LockToken(_amount, validUntil, false);
3015         emit Locked(_of, _reason, _amount, validUntil);
3016     }
3017 
3018     /**
3019     * @dev Returns tokens locked for a specified address for a
3020     *    specified reason
3021     *
3022     * @param _of The address whose tokens are locked
3023     * @param _reason The reason to query the lock tokens for
3024     */
3025     function _tokensLocked(address _of, bytes32 _reason)
3026         internal
3027         view
3028         returns (uint256 amount)
3029     {
3030         if (!locked[_of][_reason].claimed) {
3031             amount = locked[_of][_reason].amount;
3032         }
3033     }
3034 
3035     /**
3036     * @dev Returns tokens locked for a specified address for a
3037     *    specified reason at a specific time
3038     *
3039     * @param _of The address whose tokens are locked
3040     * @param _reason The reason to query the lock tokens for
3041     * @param _time The timestamp to query the lock tokens for
3042     */
3043     function _tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
3044         internal
3045         view
3046         returns (uint256 amount)
3047     {
3048         if (locked[_of][_reason].validity > _time) {
3049             amount = locked[_of][_reason].amount;
3050         }
3051     }
3052 
3053     /**
3054     * @dev Extends lock for a specified reason and time
3055     * @param _of The address whose tokens are locked
3056     * @param _reason The reason to lock tokens
3057     * @param _time Lock extension time in seconds
3058     */
3059     function _extendLock(address _of, bytes32 _reason, uint256 _time) internal {
3060         require(_tokensLocked(_of, _reason) > 0);
3061         emit Unlocked(_of, _reason, locked[_of][_reason].amount);
3062         locked[_of][_reason].validity = locked[_of][_reason].validity.add(_time);
3063         emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
3064     }
3065 
3066     /**
3067     * @dev reduce lock duration for a specified reason and time
3068     * @param _of The address whose tokens are locked
3069     * @param _reason The reason to lock tokens
3070     * @param _time Lock reduction time in seconds
3071     */
3072     function _reduceLock(address _of, bytes32 _reason, uint256 _time) internal {
3073         require(_tokensLocked(_of, _reason) > 0);
3074         emit Unlocked(_of, _reason, locked[_of][_reason].amount);
3075         locked[_of][_reason].validity = locked[_of][_reason].validity.sub(_time);
3076         emit Locked(_of, _reason, locked[_of][_reason].amount, locked[_of][_reason].validity);
3077     }
3078 
3079     /**
3080     * @dev Returns unlockable tokens for a specified address for a specified reason
3081     * @param _of The address to query the the unlockable token count of
3082     * @param _reason The reason to query the unlockable tokens for
3083     */
3084     function _tokensUnlockable(address _of, bytes32 _reason) internal view returns (uint256 amount)
3085     {
3086         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) {
3087             amount = locked[_of][_reason].amount;
3088         }
3089     }
3090 
3091     /**
3092     * @dev Burns locked tokens of a user
3093     * @param _of address whose tokens are to be burned
3094     * @param _reason lock reason for which tokens are to be burned
3095     * @param _amount amount of tokens to burn
3096     */
3097     function _burnLockedTokens(address _of, bytes32 _reason, uint256 _amount) internal {
3098         uint256 amount = _tokensLocked(_of, _reason);
3099         require(amount >= _amount);
3100 
3101         if (amount == _amount) {
3102             locked[_of][_reason].claimed = true;
3103         }
3104 
3105         locked[_of][_reason].amount = locked[_of][_reason].amount.sub(_amount);
3106         if (locked[_of][_reason].amount == 0) {
3107             _removeReason(_of, _reason);
3108         }
3109         token.burn(_amount);
3110         emit Burned(_of, _reason, _amount);
3111     }
3112 
3113     /**
3114     * @dev Released locked tokens of an address locked for a specific reason
3115     * @param _of address whose tokens are to be released from lock
3116     * @param _reason reason of the lock
3117     * @param _amount amount of tokens to release
3118     */
3119     function _releaseLockedTokens(address _of, bytes32 _reason, uint256 _amount) internal
3120     {
3121         uint256 amount = _tokensLocked(_of, _reason);
3122         require(amount >= _amount);
3123 
3124         if (amount == _amount) {
3125             locked[_of][_reason].claimed = true;
3126         }
3127 
3128         locked[_of][_reason].amount = locked[_of][_reason].amount.sub(_amount);
3129         if (locked[_of][_reason].amount == 0) {
3130             _removeReason(_of, _reason);
3131         }
3132         require(token.transfer(_of, _amount));
3133         emit Unlocked(_of, _reason, _amount);
3134     }
3135 
3136     function _removeReason(address _of, bytes32 _reason) internal {
3137         uint len = lockReason[_of].length;
3138         for (uint i = 0; i < len; i++) {
3139             if (lockReason[_of][i] == _reason) {
3140                 lockReason[_of][i] = lockReason[_of][len.sub(1)];
3141                 lockReason[_of].pop();
3142                 break;
3143             }
3144         }   
3145     }
3146 }
3147 
3148 /* Copyright (C) 2017 NexusMutual.io
3149 
3150   This program is free software: you can redistribute it and/or modify
3151     it under the terms of the GNU General Public License as published by
3152     the Free Software Foundation, either version 3 of the License, or
3153     (at your option) any later version.
3154 
3155   This program is distributed in the hope that it will be useful,
3156     but WITHOUT ANY WARRANTY; without even the implied warranty of
3157     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
3158     GNU General Public License for more details.
3159 
3160   You should have received a copy of the GNU General Public License
3161     along with this program.  If not, see http://www.gnu.org/licenses/ */
3162 contract DSValue {
3163     function peek() public view returns (bytes32, bool);
3164     function read() public view returns (bytes32);
3165 }
3166 
3167 contract PoolData is Iupgradable {
3168     using SafeMath for uint;
3169 
3170     struct ApiId {
3171         bytes4 typeOf;
3172         bytes4 currency;
3173         uint id;
3174         uint64 dateAdd;
3175         uint64 dateUpd;
3176     }
3177 
3178     struct CurrencyAssets {
3179         address currAddress;
3180         uint baseMin;
3181         uint varMin;
3182     }
3183 
3184     struct InvestmentAssets {
3185         address currAddress;
3186         bool status;
3187         uint64 minHoldingPercX100;
3188         uint64 maxHoldingPercX100;
3189         uint8 decimals;
3190     }
3191 
3192     struct IARankDetails {
3193         bytes4 maxIACurr;
3194         uint64 maxRate;
3195         bytes4 minIACurr;
3196         uint64 minRate;
3197     }
3198 
3199     struct McrData {
3200         uint mcrPercx100;
3201         uint mcrEther;
3202         uint vFull; //Pool funds
3203         uint64 date;
3204     }
3205 
3206     IARankDetails[] internal allIARankDetails;
3207     McrData[] public allMCRData;
3208 
3209     bytes4[] internal allInvestmentCurrencies;
3210     bytes4[] internal allCurrencies;
3211     bytes32[] public allAPIcall;
3212     mapping(bytes32 => ApiId) public allAPIid;
3213     mapping(uint64 => uint) internal datewiseId;
3214     mapping(bytes16 => uint) internal currencyLastIndex;
3215     mapping(bytes4 => CurrencyAssets) internal allCurrencyAssets;
3216     mapping(bytes4 => InvestmentAssets) internal allInvestmentAssets;
3217     mapping(bytes4 => uint) internal caAvgRate;
3218     mapping(bytes4 => uint) internal iaAvgRate;
3219 
3220     address public notariseMCR;
3221     address public daiFeedAddress;
3222     uint private constant DECIMAL1E18 = uint(10) ** 18;
3223     uint public uniswapDeadline;
3224     uint public liquidityTradeCallbackTime;
3225     uint public lastLiquidityTradeTrigger;
3226     uint64 internal lastDate;
3227     uint public variationPercX100;
3228     uint public iaRatesTime;
3229     uint public minCap;
3230     uint public mcrTime;
3231     uint public a;
3232     uint public shockParameter;
3233     uint public c;
3234     uint public mcrFailTime; 
3235     uint public ethVolumeLimit;
3236     uint public capReached;
3237     uint public capacityLimit;
3238     
3239     constructor(address _notariseAdd, address _daiFeedAdd, address _daiAdd) public {
3240         notariseMCR = _notariseAdd;
3241         daiFeedAddress = _daiFeedAdd;
3242         c = 5800000;
3243         a = 1028;
3244         mcrTime = 24 hours;
3245         mcrFailTime = 6 hours;
3246         allMCRData.push(McrData(0, 0, 0, 0));
3247         minCap = 12000 * DECIMAL1E18;
3248         shockParameter = 50;
3249         variationPercX100 = 100; //1%
3250         iaRatesTime = 24 hours; //24 hours in seconds
3251         uniswapDeadline = 20 minutes;
3252         liquidityTradeCallbackTime = 4 hours;
3253         ethVolumeLimit = 4;
3254         capacityLimit = 10;
3255         allCurrencies.push("ETH");
3256         allCurrencyAssets["ETH"] = CurrencyAssets(address(0), 1000 * DECIMAL1E18, 0);
3257         allCurrencies.push("DAI");
3258         allCurrencyAssets["DAI"] = CurrencyAssets(_daiAdd, 50000 * DECIMAL1E18, 0);
3259         allInvestmentCurrencies.push("ETH");
3260         allInvestmentAssets["ETH"] = InvestmentAssets(address(0), true, 2500, 10000, 18);
3261         allInvestmentCurrencies.push("DAI");
3262         allInvestmentAssets["DAI"] = InvestmentAssets(_daiAdd, true, 250, 1500, 18);
3263     }
3264 
3265     /**
3266      * @dev to set the maximum cap allowed 
3267      * @param val is the new value
3268      */
3269     function setCapReached(uint val) external onlyInternal {
3270         capReached = val;
3271     }
3272     
3273     /// @dev Updates the 3 day average rate of a IA currency.
3274     /// To be replaced by MakerDao's on chain rates
3275     /// @param curr IA Currency Name.
3276     /// @param rate Average exchange rate X 100 (of last 3 days).
3277     function updateIAAvgRate(bytes4 curr, uint rate) external onlyInternal {
3278         iaAvgRate[curr] = rate;
3279     }
3280 
3281     /// @dev Updates the 3 day average rate of a CA currency.
3282     /// To be replaced by MakerDao's on chain rates
3283     /// @param curr Currency Name.
3284     /// @param rate Average exchange rate X 100 (of last 3 days).
3285     function updateCAAvgRate(bytes4 curr, uint rate) external onlyInternal {
3286         caAvgRate[curr] = rate;
3287     }
3288 
3289     /// @dev Adds details of (Minimum Capital Requirement)MCR.
3290     /// @param mcrp Minimum Capital Requirement percentage (MCR% * 100 ,Ex:for 54.56% ,given 5456)
3291     /// @param vf Pool fund value in Ether used in the last full daily calculation from the Capital model.
3292     function pushMCRData(uint mcrp, uint mcre, uint vf, uint64 time) external onlyInternal {
3293         allMCRData.push(McrData(mcrp, mcre, vf, time));
3294     }
3295 
3296     /** 
3297      * @dev Updates the Timestamp at which result of oracalize call is received.
3298      */  
3299     function updateDateUpdOfAPI(bytes32 myid) external onlyInternal {
3300         allAPIid[myid].dateUpd = uint64(now);
3301     }
3302 
3303     /** 
3304      * @dev Saves the details of the Oraclize API.
3305      * @param myid Id return by the oraclize query.
3306      * @param _typeof type of the query for which oraclize call is made.
3307      * @param id ID of the proposal,quote,cover etc. for which oraclize call is made 
3308      */  
3309     function saveApiDetails(bytes32 myid, bytes4 _typeof, uint id) external onlyInternal {
3310         allAPIid[myid] = ApiId(_typeof, "", id, uint64(now), uint64(now));
3311     }
3312 
3313     /** 
3314      * @dev Stores the id return by the oraclize query. 
3315      * Maintains record of all the Ids return by oraclize query.
3316      * @param myid Id return by the oraclize query.
3317      */  
3318     function addInAllApiCall(bytes32 myid) external onlyInternal {
3319         allAPIcall.push(myid);
3320     }
3321     
3322     /**
3323      * @dev Saves investment asset rank details.
3324      * @param maxIACurr Maximum ranked investment asset currency.
3325      * @param maxRate Maximum ranked investment asset rate.
3326      * @param minIACurr Minimum ranked investment asset currency.
3327      * @param minRate Minimum ranked investment asset rate.
3328      * @param date in yyyymmdd.
3329      */  
3330     function saveIARankDetails(
3331         bytes4 maxIACurr,
3332         uint64 maxRate,
3333         bytes4 minIACurr,
3334         uint64 minRate,
3335         uint64 date
3336     )
3337         external
3338         onlyInternal
3339     {
3340         allIARankDetails.push(IARankDetails(maxIACurr, maxRate, minIACurr, minRate));
3341         datewiseId[date] = allIARankDetails.length.sub(1);
3342     }
3343 
3344     /**
3345      * @dev to get the time for the laste liquidity trade trigger
3346      */
3347     function setLastLiquidityTradeTrigger() external onlyInternal {
3348         lastLiquidityTradeTrigger = now;
3349     }
3350 
3351     /** 
3352      * @dev Updates Last Date.
3353      */  
3354     function updatelastDate(uint64 newDate) external onlyInternal {
3355         lastDate = newDate;
3356     }
3357 
3358     /**
3359      * @dev Adds currency asset currency. 
3360      * @param curr currency of the asset
3361      * @param currAddress address of the currency
3362      * @param baseMin base minimum in 10^18. 
3363      */  
3364     function addCurrencyAssetCurrency(
3365         bytes4 curr,
3366         address currAddress,
3367         uint baseMin
3368     ) 
3369         external
3370     {
3371         require(ms.checkIsAuthToGoverned(msg.sender));
3372         allCurrencies.push(curr);
3373         allCurrencyAssets[curr] = CurrencyAssets(currAddress, baseMin, 0);
3374     }
3375     
3376     /**
3377      * @dev Adds investment asset. 
3378      */  
3379     function addInvestmentAssetCurrency(
3380         bytes4 curr,
3381         address currAddress,
3382         bool status,
3383         uint64 minHoldingPercX100,
3384         uint64 maxHoldingPercX100,
3385         uint8 decimals
3386     ) 
3387         external
3388     {
3389         require(ms.checkIsAuthToGoverned(msg.sender));
3390         allInvestmentCurrencies.push(curr);
3391         allInvestmentAssets[curr] = InvestmentAssets(currAddress, status,
3392             minHoldingPercX100, maxHoldingPercX100, decimals);
3393     }
3394 
3395     /**
3396      * @dev Changes base minimum of a given currency asset.
3397      */ 
3398     function changeCurrencyAssetBaseMin(bytes4 curr, uint baseMin) external {
3399         require(ms.checkIsAuthToGoverned(msg.sender));
3400         allCurrencyAssets[curr].baseMin = baseMin;
3401     }
3402 
3403     /**
3404      * @dev changes variable minimum of a given currency asset.
3405      */  
3406     function changeCurrencyAssetVarMin(bytes4 curr, uint varMin) external onlyInternal {
3407         allCurrencyAssets[curr].varMin = varMin;
3408     }
3409 
3410     /** 
3411      * @dev Changes the investment asset status.
3412      */ 
3413     function changeInvestmentAssetStatus(bytes4 curr, bool status) external {
3414         require(ms.checkIsAuthToGoverned(msg.sender));
3415         allInvestmentAssets[curr].status = status;
3416     }
3417 
3418     /** 
3419      * @dev Changes the investment asset Holding percentage of a given currency.
3420      */
3421     function changeInvestmentAssetHoldingPerc(
3422         bytes4 curr,
3423         uint64 minPercX100,
3424         uint64 maxPercX100
3425     )
3426         external
3427     {
3428         require(ms.checkIsAuthToGoverned(msg.sender));
3429         allInvestmentAssets[curr].minHoldingPercX100 = minPercX100;
3430         allInvestmentAssets[curr].maxHoldingPercX100 = maxPercX100;
3431     }
3432 
3433     /**
3434      * @dev Gets Currency asset token address. 
3435      */  
3436     function changeCurrencyAssetAddress(bytes4 curr, address currAdd) external {
3437         require(ms.checkIsAuthToGoverned(msg.sender));
3438         allCurrencyAssets[curr].currAddress = currAdd;
3439     }
3440 
3441     /**
3442      * @dev Changes Investment asset token address.
3443      */ 
3444     function changeInvestmentAssetAddressAndDecimal(
3445         bytes4 curr,
3446         address currAdd,
3447         uint8 newDecimal
3448     )
3449         external
3450     {
3451         require(ms.checkIsAuthToGoverned(msg.sender));
3452         allInvestmentAssets[curr].currAddress = currAdd;
3453         allInvestmentAssets[curr].decimals = newDecimal;
3454     }
3455 
3456     /// @dev Changes address allowed to post MCR.
3457     function changeNotariseAddress(address _add) external onlyInternal {
3458         notariseMCR = _add;
3459     }
3460 
3461     /// @dev updates daiFeedAddress address.
3462     /// @param _add address of DAI feed.
3463     function changeDAIfeedAddress(address _add) external onlyInternal {
3464         daiFeedAddress = _add;
3465     }
3466 
3467     /**
3468      * @dev Gets Uint Parameters of a code
3469      * @param code whose details we want
3470      * @return string value of the code
3471      * @return associated amount (time or perc or value) to the code
3472      */
3473     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
3474         codeVal = code;
3475         if (code == "MCRTIM") {
3476             val = mcrTime / (1 hours);
3477 
3478         } else if (code == "MCRFTIM") {
3479 
3480             val = mcrFailTime / (1 hours);
3481 
3482         } else if (code == "MCRMIN") {
3483 
3484             val = minCap;
3485 
3486         } else if (code == "MCRSHOCK") {
3487 
3488             val = shockParameter;
3489 
3490         } else if (code == "MCRCAPL") {
3491 
3492             val = capacityLimit;
3493 
3494         } else if (code == "IMZ") {
3495 
3496             val = variationPercX100;
3497 
3498         } else if (code == "IMRATET") {
3499 
3500             val = iaRatesTime / (1 hours);
3501 
3502         } else if (code == "IMUNIDL") {
3503 
3504             val = uniswapDeadline / (1 minutes);
3505 
3506         } else if (code == "IMLIQT") {
3507 
3508             val = liquidityTradeCallbackTime / (1 hours);
3509 
3510         } else if (code == "IMETHVL") {
3511 
3512             val = ethVolumeLimit;
3513 
3514         } else if (code == "C") {
3515             val = c;
3516 
3517         } else if (code == "A") {
3518 
3519             val = a;
3520 
3521         }
3522             
3523     }
3524  
3525     /// @dev Checks whether a given address can notaise MCR data or not.
3526     /// @param _add Address.
3527     /// @return res Returns 0 if address is not authorized, else 1.
3528     function isnotarise(address _add) external view returns(bool res) {
3529         res = false;
3530         if (_add == notariseMCR)
3531             res = true;
3532     }
3533 
3534     /// @dev Gets the details of last added MCR.
3535     /// @return mcrPercx100 Total Minimum Capital Requirement percentage of that month of year(multiplied by 100).
3536     /// @return vFull Total Pool fund value in Ether used in the last full daily calculation.
3537     function getLastMCR() external view returns(uint mcrPercx100, uint mcrEtherx1E18, uint vFull, uint64 date) {
3538         uint index = allMCRData.length.sub(1);
3539         return (
3540             allMCRData[index].mcrPercx100,
3541             allMCRData[index].mcrEther,
3542             allMCRData[index].vFull,
3543             allMCRData[index].date
3544         );
3545     }
3546 
3547     /// @dev Gets last Minimum Capital Requirement percentage of Capital Model
3548     /// @return val MCR% value,multiplied by 100.
3549     function getLastMCRPerc() external view returns(uint) {
3550         return allMCRData[allMCRData.length.sub(1)].mcrPercx100;
3551     }
3552 
3553     /// @dev Gets last Ether price of Capital Model
3554     /// @return val ether value,multiplied by 100.
3555     function getLastMCREther() external view returns(uint) {
3556         return allMCRData[allMCRData.length.sub(1)].mcrEther;
3557     }
3558 
3559     /// @dev Gets Pool fund value in Ether used in the last full daily calculation from the Capital model.
3560     function getLastVfull() external view returns(uint) {
3561         return allMCRData[allMCRData.length.sub(1)].vFull;
3562     }
3563 
3564     /// @dev Gets last Minimum Capital Requirement in Ether.
3565     /// @return date of MCR.
3566     function getLastMCRDate() external view returns(uint64 date) {
3567         date = allMCRData[allMCRData.length.sub(1)].date;
3568     }
3569 
3570     /// @dev Gets details for token price calculation.
3571     function getTokenPriceDetails(bytes4 curr) external view returns(uint _a, uint _c, uint rate) {
3572         _a = a;
3573         _c = c;
3574         rate = _getAvgRate(curr, false);
3575     }
3576     
3577     /// @dev Gets the total number of times MCR calculation has been made.
3578     function getMCRDataLength() external view returns(uint len) {
3579         len = allMCRData.length;
3580     }
3581  
3582     /**
3583      * @dev Gets investment asset rank details by given date.
3584      */  
3585     function getIARankDetailsByDate(
3586         uint64 date
3587     )
3588         external
3589         view
3590         returns(
3591             bytes4 maxIACurr,
3592             uint64 maxRate,
3593             bytes4 minIACurr,
3594             uint64 minRate
3595         )
3596     {
3597         uint index = datewiseId[date];
3598         return (
3599             allIARankDetails[index].maxIACurr,
3600             allIARankDetails[index].maxRate,
3601             allIARankDetails[index].minIACurr,
3602             allIARankDetails[index].minRate
3603         );
3604     }
3605 
3606     /** 
3607      * @dev Gets Last Date.
3608      */ 
3609     function getLastDate() external view returns(uint64 date) {
3610         return lastDate;
3611     }
3612 
3613     /**
3614      * @dev Gets investment currency for a given index.
3615      */  
3616     function getInvestmentCurrencyByIndex(uint index) external view returns(bytes4 currName) {
3617         return allInvestmentCurrencies[index];
3618     }
3619 
3620     /**
3621      * @dev Gets count of investment currency.
3622      */  
3623     function getInvestmentCurrencyLen() external view returns(uint len) {
3624         return allInvestmentCurrencies.length;
3625     }
3626 
3627     /**
3628      * @dev Gets all the investment currencies.
3629      */ 
3630     function getAllInvestmentCurrencies() external view returns(bytes4[] memory currencies) {
3631         return allInvestmentCurrencies;
3632     }
3633 
3634     /**
3635      * @dev Gets All currency for a given index.
3636      */  
3637     function getCurrenciesByIndex(uint index) external view returns(bytes4 currName) {
3638         return allCurrencies[index];
3639     }
3640 
3641     /** 
3642      * @dev Gets count of All currency.
3643      */  
3644     function getAllCurrenciesLen() external view returns(uint len) {
3645         return allCurrencies.length;
3646     }
3647 
3648     /**
3649      * @dev Gets all currencies 
3650      */  
3651     function getAllCurrencies() external view returns(bytes4[] memory currencies) {
3652         return allCurrencies;
3653     }
3654 
3655     /**
3656      * @dev Gets currency asset details for a given currency.
3657      */  
3658     function getCurrencyAssetVarBase(
3659         bytes4 curr
3660     )
3661         external
3662         view
3663         returns(
3664             bytes4 currency,
3665             uint baseMin,
3666             uint varMin
3667         )
3668     {
3669         return (
3670             curr,
3671             allCurrencyAssets[curr].baseMin,
3672             allCurrencyAssets[curr].varMin
3673         );
3674     }
3675 
3676     /**
3677      * @dev Gets minimum variable value for currency asset.
3678      */  
3679     function getCurrencyAssetVarMin(bytes4 curr) external view returns(uint varMin) {
3680         return allCurrencyAssets[curr].varMin;
3681     }
3682 
3683     /** 
3684      * @dev Gets base minimum of  a given currency asset.
3685      */  
3686     function getCurrencyAssetBaseMin(bytes4 curr) external view returns(uint baseMin) {
3687         return allCurrencyAssets[curr].baseMin;
3688     }
3689 
3690     /** 
3691      * @dev Gets investment asset maximum and minimum holding percentage of a given currency.
3692      */  
3693     function getInvestmentAssetHoldingPerc(
3694         bytes4 curr
3695     )
3696         external
3697         view
3698         returns(
3699             uint64 minHoldingPercX100,
3700             uint64 maxHoldingPercX100
3701         )
3702     {
3703         return (
3704             allInvestmentAssets[curr].minHoldingPercX100,
3705             allInvestmentAssets[curr].maxHoldingPercX100
3706         );
3707     }
3708 
3709     /** 
3710      * @dev Gets investment asset decimals.
3711      */  
3712     function getInvestmentAssetDecimals(bytes4 curr) external view returns(uint8 decimal) {
3713         return allInvestmentAssets[curr].decimals;
3714     }
3715 
3716     /**
3717      * @dev Gets investment asset maximum holding percentage of a given currency.
3718      */  
3719     function getInvestmentAssetMaxHoldingPerc(bytes4 curr) external view returns(uint64 maxHoldingPercX100) {
3720         return allInvestmentAssets[curr].maxHoldingPercX100;
3721     }
3722 
3723     /**
3724      * @dev Gets investment asset minimum holding percentage of a given currency.
3725      */  
3726     function getInvestmentAssetMinHoldingPerc(bytes4 curr) external view returns(uint64 minHoldingPercX100) {
3727         return allInvestmentAssets[curr].minHoldingPercX100;
3728     }
3729 
3730     /** 
3731      * @dev Gets investment asset details of a given currency
3732      */  
3733     function getInvestmentAssetDetails(
3734         bytes4 curr
3735     )
3736         external
3737         view
3738         returns(
3739             bytes4 currency,
3740             address currAddress,
3741             bool status,
3742             uint64 minHoldingPerc,
3743             uint64 maxHoldingPerc,
3744             uint8 decimals
3745         )
3746     {
3747         return (
3748             curr,
3749             allInvestmentAssets[curr].currAddress,
3750             allInvestmentAssets[curr].status,
3751             allInvestmentAssets[curr].minHoldingPercX100,
3752             allInvestmentAssets[curr].maxHoldingPercX100,
3753             allInvestmentAssets[curr].decimals
3754         );
3755     }
3756 
3757     /**
3758      * @dev Gets Currency asset token address.
3759      */  
3760     function getCurrencyAssetAddress(bytes4 curr) external view returns(address) {
3761         return allCurrencyAssets[curr].currAddress;
3762     }
3763 
3764     /**
3765      * @dev Gets investment asset token address.
3766      */  
3767     function getInvestmentAssetAddress(bytes4 curr) external view returns(address) {
3768         return allInvestmentAssets[curr].currAddress;
3769     }
3770 
3771     /**
3772      * @dev Gets investment asset active Status of a given currency.
3773      */  
3774     function getInvestmentAssetStatus(bytes4 curr) external view returns(bool status) {
3775         return allInvestmentAssets[curr].status;
3776     }
3777 
3778     /** 
3779      * @dev Gets type of oraclize query for a given Oraclize Query ID.
3780      * @param myid Oraclize Query ID identifying the query for which the result is being received.
3781      * @return _typeof It could be of type "quote","quotation","cover","claim" etc.
3782      */  
3783     function getApiIdTypeOf(bytes32 myid) external view returns(bytes4) {
3784         return allAPIid[myid].typeOf;
3785     }
3786 
3787     /** 
3788      * @dev Gets ID associated to oraclize query for a given Oraclize Query ID.
3789      * @param myid Oraclize Query ID identifying the query for which the result is being received.
3790      * @return id1 It could be the ID of "proposal","quotation","cover","claim" etc.
3791      */  
3792     function getIdOfApiId(bytes32 myid) external view returns(uint) {
3793         return allAPIid[myid].id;
3794     }
3795 
3796     /** 
3797      * @dev Gets the Timestamp of a oracalize call.
3798      */  
3799     function getDateAddOfAPI(bytes32 myid) external view returns(uint64) {
3800         return allAPIid[myid].dateAdd;
3801     }
3802 
3803     /**
3804      * @dev Gets the Timestamp at which result of oracalize call is received.
3805      */  
3806     function getDateUpdOfAPI(bytes32 myid) external view returns(uint64) {
3807         return allAPIid[myid].dateUpd;
3808     }
3809 
3810     /** 
3811      * @dev Gets currency by oracalize id. 
3812      */  
3813     function getCurrOfApiId(bytes32 myid) external view returns(bytes4) {
3814         return allAPIid[myid].currency;
3815     }
3816 
3817     /**
3818      * @dev Gets ID return by the oraclize query of a given index.
3819      * @param index Index.
3820      * @return myid ID return by the oraclize query.
3821      */  
3822     function getApiCallIndex(uint index) external view returns(bytes32 myid) {
3823         myid = allAPIcall[index];
3824     }
3825 
3826     /**
3827      * @dev Gets Length of API call. 
3828      */  
3829     function getApilCallLength() external view returns(uint) {
3830         return allAPIcall.length;
3831     }
3832     
3833     /**
3834      * @dev Get Details of Oraclize API when given Oraclize Id.
3835      * @param myid ID return by the oraclize query.
3836      * @return _typeof ype of the query for which oraclize 
3837      * call is made.("proposal","quote","quotation" etc.) 
3838      */  
3839     function getApiCallDetails(
3840         bytes32 myid
3841     )
3842         external
3843         view
3844         returns(
3845             bytes4 _typeof,
3846             bytes4 curr,
3847             uint id,
3848             uint64 dateAdd,
3849             uint64 dateUpd
3850         )
3851     {
3852         return (
3853             allAPIid[myid].typeOf,
3854             allAPIid[myid].currency,
3855             allAPIid[myid].id,
3856             allAPIid[myid].dateAdd,
3857             allAPIid[myid].dateUpd
3858         );
3859     }
3860 
3861     /**
3862      * @dev Updates Uint Parameters of a code
3863      * @param code whose details we want to update
3864      * @param val value to set
3865      */
3866     function updateUintParameters(bytes8 code, uint val) public {
3867         require(ms.checkIsAuthToGoverned(msg.sender));
3868         if (code == "MCRTIM") {
3869             _changeMCRTime(val * 1 hours);
3870 
3871         } else if (code == "MCRFTIM") {
3872 
3873             _changeMCRFailTime(val * 1 hours);
3874 
3875         } else if (code == "MCRMIN") {
3876 
3877             _changeMinCap(val);
3878 
3879         } else if (code == "MCRSHOCK") {
3880 
3881             _changeShockParameter(val);
3882 
3883         } else if (code == "MCRCAPL") {
3884 
3885             _changeCapacityLimit(val);
3886 
3887         } else if (code == "IMZ") {
3888 
3889             _changeVariationPercX100(val);
3890 
3891         } else if (code == "IMRATET") {
3892 
3893             _changeIARatesTime(val * 1 hours);
3894 
3895         } else if (code == "IMUNIDL") {
3896 
3897             _changeUniswapDeadlineTime(val * 1 minutes);
3898 
3899         } else if (code == "IMLIQT") {
3900 
3901             _changeliquidityTradeCallbackTime(val * 1 hours);
3902 
3903         } else if (code == "IMETHVL") {
3904 
3905             _setEthVolumeLimit(val);
3906 
3907         } else if (code == "C") {
3908             _changeC(val);
3909 
3910         } else if (code == "A") {
3911 
3912             _changeA(val);
3913 
3914         } else {
3915             revert("Invalid param code");
3916         }
3917             
3918     }
3919 
3920     /**
3921      * @dev to get the average rate of currency rate 
3922      * @param curr is the currency in concern
3923      * @return required rate
3924      */
3925     function getCAAvgRate(bytes4 curr) public view returns(uint rate) {
3926         return _getAvgRate(curr, false);
3927     }
3928 
3929     /**
3930      * @dev to get the average rate of investment rate 
3931      * @param curr is the investment in concern
3932      * @return required rate
3933      */
3934     function getIAAvgRate(bytes4 curr) public view returns(uint rate) {
3935         return _getAvgRate(curr, true);
3936     }
3937 
3938     function changeDependentContractAddress() public onlyInternal {}
3939 
3940     /// @dev Gets the average rate of a CA currency.
3941     /// @param curr Currency Name.
3942     /// @return rate Average rate X 100(of last 3 days).
3943     function _getAvgRate(bytes4 curr, bool isIA) internal view returns(uint rate) {
3944         if (curr == "DAI") {
3945             DSValue ds = DSValue(daiFeedAddress);
3946             rate = uint(ds.read()).div(uint(10) ** 16);
3947         } else if (isIA) {
3948             rate = iaAvgRate[curr];
3949         } else {
3950             rate = caAvgRate[curr];
3951         }
3952     }
3953 
3954     /**
3955      * @dev to set the ethereum volume limit 
3956      * @param val is the new limit value
3957      */
3958     function _setEthVolumeLimit(uint val) internal {
3959         ethVolumeLimit = val;
3960     }
3961 
3962     /// @dev Sets minimum Cap.
3963     function _changeMinCap(uint newCap) internal {
3964         minCap = newCap;
3965     }
3966 
3967     /// @dev Sets Shock Parameter.
3968     function _changeShockParameter(uint newParam) internal {
3969         shockParameter = newParam;
3970     }
3971     
3972     /// @dev Changes time period for obtaining new MCR data from external oracle query.
3973     function _changeMCRTime(uint _time) internal {
3974         mcrTime = _time;
3975     }
3976 
3977     /// @dev Sets MCR Fail time.
3978     function _changeMCRFailTime(uint _time) internal {
3979         mcrFailTime = _time;
3980     }
3981 
3982     /**
3983      * @dev to change the uniswap deadline time 
3984      * @param newDeadline is the value
3985      */
3986     function _changeUniswapDeadlineTime(uint newDeadline) internal {
3987         uniswapDeadline = newDeadline;
3988     }
3989 
3990     /**
3991      * @dev to change the liquidity trade call back time 
3992      * @param newTime is the new value to be set
3993      */
3994     function _changeliquidityTradeCallbackTime(uint newTime) internal {
3995         liquidityTradeCallbackTime = newTime;
3996     }
3997 
3998     /**
3999      * @dev Changes time after which investment asset rates need to be fed.
4000      */  
4001     function _changeIARatesTime(uint _newTime) internal {
4002         iaRatesTime = _newTime;
4003     }
4004     
4005     /**
4006      * @dev Changes the variation range percentage.
4007      */  
4008     function _changeVariationPercX100(uint newPercX100) internal {
4009         variationPercX100 = newPercX100;
4010     }
4011 
4012     /// @dev Changes Growth Step
4013     function _changeC(uint newC) internal {
4014         c = newC;
4015     }
4016 
4017     /// @dev Changes scaling factor.
4018     function _changeA(uint val) internal {
4019         a = val;
4020     }
4021     
4022     /**
4023      * @dev to change the capacity limit 
4024      * @param val is the new value
4025      */
4026     function _changeCapacityLimit(uint val) internal {
4027         capacityLimit = val;
4028     }    
4029 }
4030 
4031 /* Copyright (C) 2017 NexusMutual.io
4032 
4033   This program is free software: you can redistribute it and/or modify
4034     it under the terms of the GNU General Public License as published by
4035     the Free Software Foundation, either version 3 of the License, or
4036     (at your option) any later version.
4037 
4038   This program is distributed in the hope that it will be useful,
4039     but WITHOUT ANY WARRANTY; without even the implied warranty of
4040     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
4041     GNU General Public License for more details.
4042 
4043   You should have received a copy of the GNU General Public License
4044     along with this program.  If not, see http://www.gnu.org/licenses/ */
4045 contract QuotationData is Iupgradable {
4046     using SafeMath for uint;
4047 
4048     enum HCIDStatus { NA, kycPending, kycPass, kycFailedOrRefunded, kycPassNoCover }
4049 
4050     enum CoverStatus { Active, ClaimAccepted, ClaimDenied, CoverExpired, ClaimSubmitted, Requested }
4051 
4052     struct Cover {
4053         address payable memberAddress;
4054         bytes4 currencyCode;
4055         uint sumAssured;
4056         uint16 coverPeriod;
4057         uint validUntil;
4058         address scAddress;
4059         uint premiumNXM;
4060     }
4061 
4062     struct HoldCover {
4063         uint holdCoverId;
4064         address payable userAddress;
4065         address scAddress;
4066         bytes4 coverCurr;
4067         uint[] coverDetails;
4068         uint16 coverPeriod;
4069     }
4070 
4071     address public authQuoteEngine;
4072   
4073     mapping(bytes4 => uint) internal currencyCSA;
4074     mapping(address => uint[]) internal userCover;
4075     mapping(address => uint[]) public userHoldedCover;
4076     mapping(address => bool) public refundEligible;
4077     mapping(address => mapping(bytes4 => uint)) internal currencyCSAOfSCAdd;
4078     mapping(uint => uint8) public coverStatus;
4079     mapping(uint => uint) public holdedCoverIDStatus;
4080     mapping(uint => bool) public timestampRepeated; 
4081     
4082 
4083     Cover[] internal allCovers;
4084     HoldCover[] internal allCoverHolded;
4085 
4086     uint public stlp;
4087     uint public stl;
4088     uint public pm;
4089     uint public minDays;
4090     uint public tokensRetained;
4091     address public kycAuthAddress;
4092 
4093     event CoverDetailsEvent(
4094         uint indexed cid,
4095         address scAdd,
4096         uint sumAssured,
4097         uint expiry,
4098         uint premium,
4099         uint premiumNXM,
4100         bytes4 curr
4101     );
4102 
4103     event CoverStatusEvent(uint indexed cid, uint8 statusNum);
4104 
4105     constructor(address _authQuoteAdd, address _kycAuthAdd) public {
4106         authQuoteEngine = _authQuoteAdd;
4107         kycAuthAddress = _kycAuthAdd;
4108         stlp = 90;
4109         stl = 100;
4110         pm = 30;
4111         minDays = 30;
4112         tokensRetained = 10;
4113         allCovers.push(Cover(address(0), "0x00", 0, 0, 0, address(0), 0));
4114         uint[] memory arr = new uint[](1);
4115         allCoverHolded.push(HoldCover(0, address(0), address(0), 0x00, arr, 0));
4116 
4117     }
4118     
4119     /// @dev Adds the amount in Total Sum Assured of a given currency of a given smart contract address.
4120     /// @param _add Smart Contract Address.
4121     /// @param _amount Amount to be added.
4122     function addInTotalSumAssuredSC(address _add, bytes4 _curr, uint _amount) external onlyInternal {
4123         currencyCSAOfSCAdd[_add][_curr] = currencyCSAOfSCAdd[_add][_curr].add(_amount);
4124     }
4125 
4126     /// @dev Subtracts the amount from Total Sum Assured of a given currency and smart contract address.
4127     /// @param _add Smart Contract Address.
4128     /// @param _amount Amount to be subtracted.
4129     function subFromTotalSumAssuredSC(address _add, bytes4 _curr, uint _amount) external onlyInternal {
4130         currencyCSAOfSCAdd[_add][_curr] = currencyCSAOfSCAdd[_add][_curr].sub(_amount);
4131     }
4132     
4133     /// @dev Subtracts the amount from Total Sum Assured of a given currency.
4134     /// @param _curr Currency Name.
4135     /// @param _amount Amount to be subtracted.
4136     function subFromTotalSumAssured(bytes4 _curr, uint _amount) external onlyInternal {
4137         currencyCSA[_curr] = currencyCSA[_curr].sub(_amount);
4138     }
4139 
4140     /// @dev Adds the amount in Total Sum Assured of a given currency.
4141     /// @param _curr Currency Name.
4142     /// @param _amount Amount to be added.
4143     function addInTotalSumAssured(bytes4 _curr, uint _amount) external onlyInternal {
4144         currencyCSA[_curr] = currencyCSA[_curr].add(_amount);
4145     }
4146 
4147     /// @dev sets bit for timestamp to avoid replay attacks.
4148     function setTimestampRepeated(uint _timestamp) external onlyInternal {
4149         timestampRepeated[_timestamp] = true;
4150     }
4151     
4152     /// @dev Creates a blank new cover.
4153     function addCover(
4154         uint16 _coverPeriod,
4155         uint _sumAssured,
4156         address payable _userAddress,
4157         bytes4 _currencyCode,
4158         address _scAddress,
4159         uint premium,
4160         uint premiumNXM
4161     )   
4162         external
4163         onlyInternal
4164     {
4165         uint expiryDate = now.add(uint(_coverPeriod).mul(1 days));
4166         allCovers.push(Cover(_userAddress, _currencyCode,
4167                 _sumAssured, _coverPeriod, expiryDate, _scAddress, premiumNXM));
4168         uint cid = allCovers.length.sub(1);
4169         userCover[_userAddress].push(cid);
4170         emit CoverDetailsEvent(cid, _scAddress, _sumAssured, expiryDate, premium, premiumNXM, _currencyCode);
4171     }
4172 
4173     /// @dev create holded cover which will process after verdict of KYC.
4174     function addHoldCover(
4175         address payable from,
4176         address scAddress,
4177         bytes4 coverCurr, 
4178         uint[] calldata coverDetails,
4179         uint16 coverPeriod
4180     )   
4181         external
4182         onlyInternal
4183     {
4184         uint holdedCoverLen = allCoverHolded.length;
4185         holdedCoverIDStatus[holdedCoverLen] = uint(HCIDStatus.kycPending);             
4186         allCoverHolded.push(HoldCover(holdedCoverLen, from, scAddress, 
4187             coverCurr, coverDetails, coverPeriod));
4188         userHoldedCover[from].push(allCoverHolded.length.sub(1));
4189     
4190     }
4191 
4192     ///@dev sets refund eligible bit.
4193     ///@param _add user address.
4194     ///@param status indicates if user have pending kyc.
4195     function setRefundEligible(address _add, bool status) external onlyInternal {
4196         refundEligible[_add] = status;
4197     }
4198 
4199     /// @dev to set current status of particular holded coverID (1 for not completed KYC,
4200     /// 2 for KYC passed, 3 for failed KYC or full refunded,
4201     /// 4 for KYC completed but cover not processed)
4202     function setHoldedCoverIDStatus(uint holdedCoverID, uint status) external onlyInternal {
4203         holdedCoverIDStatus[holdedCoverID] = status;
4204     }
4205 
4206     /**
4207      * @dev to set address of kyc authentication 
4208      * @param _add is the new address
4209      */
4210     function setKycAuthAddress(address _add) external onlyInternal {
4211         kycAuthAddress = _add;
4212     }
4213 
4214     /// @dev Changes authorised address for generating quote off chain.
4215     function changeAuthQuoteEngine(address _add) external onlyInternal {
4216         authQuoteEngine = _add;
4217     }
4218 
4219     /**
4220      * @dev Gets Uint Parameters of a code
4221      * @param code whose details we want
4222      * @return string value of the code
4223      * @return associated amount (time or perc or value) to the code
4224      */
4225     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
4226         codeVal = code;
4227 
4228         if (code == "STLP") {
4229             val = stlp;
4230 
4231         } else if (code == "STL") {
4232             
4233             val = stl;
4234 
4235         } else if (code == "PM") {
4236 
4237             val = pm;
4238 
4239         } else if (code == "QUOMIND") {
4240 
4241             val = minDays;
4242 
4243         } else if (code == "QUOTOK") {
4244 
4245             val = tokensRetained;
4246 
4247         }
4248         
4249     }
4250 
4251     /// @dev Gets Product details.
4252     /// @return  _minDays minimum cover period.
4253     /// @return  _PM Profit margin.
4254     /// @return  _STL short term Load.
4255     /// @return  _STLP short term load period.
4256     function getProductDetails()
4257         external
4258         view
4259         returns (
4260             uint _minDays,
4261             uint _pm,
4262             uint _stl,
4263             uint _stlp
4264         )
4265     {
4266 
4267         _minDays = minDays;
4268         _pm = pm;
4269         _stl = stl;
4270         _stlp = stlp;
4271     }
4272 
4273     /// @dev Gets total number covers created till date.
4274     function getCoverLength() external view returns(uint len) {
4275         return (allCovers.length);
4276     }
4277 
4278     /// @dev Gets Authorised Engine address.
4279     function getAuthQuoteEngine() external view returns(address _add) {
4280         _add = authQuoteEngine;
4281     }
4282 
4283     /// @dev Gets the Total Sum Assured amount of a given currency.
4284     function getTotalSumAssured(bytes4 _curr) external view returns(uint amount) {
4285         amount = currencyCSA[_curr];
4286     }
4287 
4288     /// @dev Gets all the Cover ids generated by a given address.
4289     /// @param _add User's address.
4290     /// @return allCover array of covers.
4291     function getAllCoversOfUser(address _add) external view returns(uint[] memory allCover) {
4292         return (userCover[_add]);
4293     }
4294 
4295     /// @dev Gets total number of covers generated by a given address
4296     function getUserCoverLength(address _add) external view returns(uint len) {
4297         len = userCover[_add].length;
4298     }
4299 
4300     /// @dev Gets the status of a given cover.
4301     function getCoverStatusNo(uint _cid) external view returns(uint8) {
4302         return coverStatus[_cid];
4303     }
4304 
4305     /// @dev Gets the Cover Period (in days) of a given cover.
4306     function getCoverPeriod(uint _cid) external view returns(uint32 cp) {
4307         cp = allCovers[_cid].coverPeriod;
4308     }
4309 
4310     /// @dev Gets the Sum Assured Amount of a given cover.
4311     function getCoverSumAssured(uint _cid) external view returns(uint sa) {
4312         sa = allCovers[_cid].sumAssured;
4313     }
4314 
4315     /// @dev Gets the Currency Name in which a given cover is assured.
4316     function getCurrencyOfCover(uint _cid) external view returns(bytes4 curr) {
4317         curr = allCovers[_cid].currencyCode;
4318     }
4319 
4320     /// @dev Gets the validity date (timestamp) of a given cover.
4321     function getValidityOfCover(uint _cid) external view returns(uint date) {
4322         date = allCovers[_cid].validUntil;
4323     }
4324 
4325     /// @dev Gets Smart contract address of cover.
4326     function getscAddressOfCover(uint _cid) external view returns(uint, address) {
4327         return (_cid, allCovers[_cid].scAddress);
4328     }
4329 
4330     /// @dev Gets the owner address of a given cover.
4331     function getCoverMemberAddress(uint _cid) external view returns(address payable _add) {
4332         _add = allCovers[_cid].memberAddress;
4333     }
4334 
4335     /// @dev Gets the premium amount of a given cover in NXM.
4336     function getCoverPremiumNXM(uint _cid) external view returns(uint _premiumNXM) {
4337         _premiumNXM = allCovers[_cid].premiumNXM;
4338     }
4339 
4340     /// @dev Provides the details of a cover Id
4341     /// @param _cid cover Id
4342     /// @return memberAddress cover user address.
4343     /// @return scAddress smart contract Address 
4344     /// @return currencyCode currency of cover
4345     /// @return sumAssured sum assured of cover
4346     /// @return premiumNXM premium in NXM
4347     function getCoverDetailsByCoverID1(
4348         uint _cid
4349     ) 
4350         external
4351         view
4352         returns (
4353             uint cid,
4354             address _memberAddress,
4355             address _scAddress,
4356             bytes4 _currencyCode,
4357             uint _sumAssured,  
4358             uint premiumNXM 
4359         ) 
4360     {
4361         return (
4362             _cid,
4363             allCovers[_cid].memberAddress,
4364             allCovers[_cid].scAddress,
4365             allCovers[_cid].currencyCode,
4366             allCovers[_cid].sumAssured,
4367             allCovers[_cid].premiumNXM
4368         );
4369     }
4370 
4371     /// @dev Provides details of a cover Id
4372     /// @param _cid cover Id
4373     /// @return status status of cover.
4374     /// @return sumAssured Sum assurance of cover.
4375     /// @return coverPeriod Cover Period of cover (in days).
4376     /// @return validUntil is validity of cover.
4377     function getCoverDetailsByCoverID2(
4378         uint _cid
4379     )
4380         external
4381         view
4382         returns (
4383             uint cid,
4384             uint8 status,
4385             uint sumAssured,
4386             uint16 coverPeriod,
4387             uint validUntil
4388         ) 
4389     {
4390 
4391         return (
4392             _cid,
4393             coverStatus[_cid],
4394             allCovers[_cid].sumAssured,
4395             allCovers[_cid].coverPeriod,
4396             allCovers[_cid].validUntil
4397         );
4398     }
4399 
4400     /// @dev Provides details of a holded cover Id
4401     /// @param _hcid holded cover Id
4402     /// @return scAddress SmartCover address of cover.
4403     /// @return coverCurr currency of cover.
4404     /// @return coverPeriod Cover Period of cover (in days).
4405     function getHoldedCoverDetailsByID1(
4406         uint _hcid
4407     )
4408         external 
4409         view
4410         returns (
4411             uint hcid,
4412             address scAddress,
4413             bytes4 coverCurr,
4414             uint16 coverPeriod
4415         )
4416     {
4417         return (
4418             _hcid,
4419             allCoverHolded[_hcid].scAddress,
4420             allCoverHolded[_hcid].coverCurr, 
4421             allCoverHolded[_hcid].coverPeriod
4422         );
4423     }
4424 
4425     /// @dev Gets total number holded covers created till date.
4426     function getUserHoldedCoverLength(address _add) external view returns (uint) {
4427         return userHoldedCover[_add].length;
4428     }
4429 
4430     /// @dev Gets holded cover index by index of user holded covers.
4431     function getUserHoldedCoverByIndex(address _add, uint index) external view returns (uint) {
4432         return userHoldedCover[_add][index];
4433     }
4434 
4435     /// @dev Provides the details of a holded cover Id
4436     /// @param _hcid holded cover Id
4437     /// @return memberAddress holded cover user address.
4438     /// @return coverDetails array contains SA, Cover Currency Price,Price in NXM, Expiration time of Qoute.    
4439     function getHoldedCoverDetailsByID2(
4440         uint _hcid
4441     ) 
4442         external
4443         view
4444         returns (
4445             uint hcid,
4446             address payable memberAddress, 
4447             uint[] memory coverDetails
4448         )
4449     {
4450         return (
4451             _hcid,
4452             allCoverHolded[_hcid].userAddress,
4453             allCoverHolded[_hcid].coverDetails
4454         );
4455     }
4456 
4457     /// @dev Gets the Total Sum Assured amount of a given currency and smart contract address.
4458     function getTotalSumAssuredSC(address _add, bytes4 _curr) external view returns(uint amount) {
4459         amount = currencyCSAOfSCAdd[_add][_curr];
4460     }
4461 
4462     //solhint-disable-next-line
4463     function changeDependentContractAddress() public {}
4464 
4465     /// @dev Changes the status of a given cover.
4466     /// @param _cid cover Id.
4467     /// @param _stat New status.
4468     function changeCoverStatusNo(uint _cid, uint8 _stat) public onlyInternal {
4469         coverStatus[_cid] = _stat;
4470         emit CoverStatusEvent(_cid, _stat);
4471     }
4472 
4473     /**
4474      * @dev Updates Uint Parameters of a code
4475      * @param code whose details we want to update
4476      * @param val value to set
4477      */
4478     function updateUintParameters(bytes8 code, uint val) public {
4479 
4480         require(ms.checkIsAuthToGoverned(msg.sender));
4481         if (code == "STLP") {
4482             _changeSTLP(val);
4483 
4484         } else if (code == "STL") {
4485             
4486             _changeSTL(val);
4487 
4488         } else if (code == "PM") {
4489 
4490             _changePM(val);
4491 
4492         } else if (code == "QUOMIND") {
4493 
4494             _changeMinDays(val);
4495 
4496         } else if (code == "QUOTOK") {
4497 
4498             _setTokensRetained(val);
4499 
4500         } else {
4501 
4502             revert("Invalid param code");
4503         }
4504         
4505     }
4506     
4507     /// @dev Changes the existing Profit Margin value
4508     function _changePM(uint _pm) internal {
4509         pm = _pm;
4510     }
4511 
4512     /// @dev Changes the existing Short Term Load Period (STLP) value.
4513     function _changeSTLP(uint _stlp) internal {
4514         stlp = _stlp;
4515     }
4516 
4517     /// @dev Changes the existing Short Term Load (STL) value.
4518     function _changeSTL(uint _stl) internal {
4519         stl = _stl;
4520     }
4521 
4522     /// @dev Changes the existing Minimum cover period (in days)
4523     function _changeMinDays(uint _days) internal {
4524         minDays = _days;
4525     }
4526     
4527     /**
4528      * @dev to set the the amount of tokens retained 
4529      * @param val is the amount retained
4530      */
4531     function _setTokensRetained(uint val) internal {
4532         tokensRetained = val;
4533     }
4534 }
4535 
4536 /* Copyright (C) 2017 NexusMutual.io
4537 
4538   This program is free software: you can redistribute it and/or modify
4539     it under the terms of the GNU General Public License as published by
4540     the Free Software Foundation, either version 3 of the License, or
4541     (at your option) any later version.
4542 
4543   This program is distributed in the hope that it will be useful,
4544     but WITHOUT ANY WARRANTY; without even the implied warranty of
4545     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
4546     GNU General Public License for more details.
4547 
4548   You should have received a copy of the GNU General Public License
4549     along with this program.  If not, see http://www.gnu.org/licenses/ */
4550 contract TokenData is Iupgradable {
4551     using SafeMath for uint;
4552 
4553     address payable public walletAddress;
4554     uint public lockTokenTimeAfterCoverExp;
4555     uint public bookTime;
4556     uint public lockCADays;
4557     uint public lockMVDays;
4558     uint public scValidDays;
4559     uint public joiningFee;
4560     uint public stakerCommissionPer;
4561     uint public stakerMaxCommissionPer;
4562     uint public tokenExponent;
4563     uint public priceStep;
4564 
4565     struct StakeCommission {
4566         uint commissionEarned;
4567         uint commissionRedeemed;
4568     }
4569 
4570     struct Stake {
4571         address stakedContractAddress;
4572         uint stakedContractIndex;
4573         uint dateAdd;
4574         uint stakeAmount;
4575         uint unlockedAmount;
4576         uint burnedAmount;
4577         uint unLockableBeforeLastBurn;
4578     }
4579 
4580     struct Staker {
4581         address stakerAddress;
4582         uint stakerIndex;
4583     }
4584 
4585     struct CoverNote {
4586         uint amount;
4587         bool isDeposited;
4588     }
4589 
4590     /**
4591      * @dev mapping of uw address to array of sc address to fetch 
4592      * all staked contract address of underwriter, pushing
4593      * data into this array of Stake returns stakerIndex 
4594      */ 
4595     mapping(address => Stake[]) public stakerStakedContracts; 
4596 
4597     /** 
4598      * @dev mapping of sc address to array of UW address to fetch
4599      * all underwritters of the staked smart contract
4600      * pushing data into this mapped array returns scIndex 
4601      */
4602     mapping(address => Staker[]) public stakedContractStakers;
4603 
4604     /**
4605      * @dev mapping of staked contract Address to the array of StakeCommission
4606      * here index of this array is stakedContractIndex
4607      */ 
4608     mapping(address => mapping(uint => StakeCommission)) public stakedContractStakeCommission;
4609 
4610     mapping(address => uint) public lastCompletedStakeCommission;
4611 
4612     /** 
4613      * @dev mapping of the staked contract address to the current 
4614      * staker index who will receive commission.
4615      */ 
4616     mapping(address => uint) public stakedContractCurrentCommissionIndex;
4617 
4618     /** 
4619      * @dev mapping of the staked contract address to the 
4620      * current staker index to burn token from.
4621      */ 
4622     mapping(address => uint) public stakedContractCurrentBurnIndex;
4623 
4624     /** 
4625      * @dev mapping to return true if Cover Note deposited against coverId
4626      */ 
4627     mapping(uint => CoverNote) public depositedCN;
4628 
4629     mapping(address => uint) internal isBookedTokens;
4630 
4631     event Commission(
4632         address indexed stakedContractAddress,
4633         address indexed stakerAddress,
4634         uint indexed scIndex,
4635         uint commissionAmount
4636     );
4637 
4638     constructor(address payable _walletAdd) public {
4639         walletAddress = _walletAdd;
4640         bookTime = 12 hours;
4641         joiningFee = 2000000000000000; // 0.002 Ether
4642         lockTokenTimeAfterCoverExp = 35 days;
4643         scValidDays = 250;
4644         lockCADays = 7 days;
4645         lockMVDays = 2 days;
4646         stakerCommissionPer = 20;
4647         stakerMaxCommissionPer = 50;
4648         tokenExponent = 4;
4649         priceStep = 1000;
4650 
4651     }
4652 
4653     /**
4654      * @dev Change the wallet address which receive Joining Fee
4655      */
4656     function changeWalletAddress(address payable _address) external onlyInternal {
4657         walletAddress = _address;
4658     }
4659 
4660     /**
4661      * @dev Gets Uint Parameters of a code
4662      * @param code whose details we want
4663      * @return string value of the code
4664      * @return associated amount (time or perc or value) to the code
4665      */
4666     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
4667         codeVal = code;
4668         if (code == "TOKEXP") {
4669 
4670             val = tokenExponent; 
4671 
4672         } else if (code == "TOKSTEP") {
4673 
4674             val = priceStep;
4675 
4676         } else if (code == "RALOCKT") {
4677 
4678             val = scValidDays;
4679 
4680         } else if (code == "RACOMM") {
4681 
4682             val = stakerCommissionPer;
4683 
4684         } else if (code == "RAMAXC") {
4685 
4686             val = stakerMaxCommissionPer;
4687 
4688         } else if (code == "CABOOKT") {
4689 
4690             val = bookTime / (1 hours);
4691 
4692         } else if (code == "CALOCKT") {
4693 
4694             val = lockCADays / (1 days);
4695 
4696         } else if (code == "MVLOCKT") {
4697 
4698             val = lockMVDays / (1 days);
4699 
4700         } else if (code == "QUOLOCKT") {
4701 
4702             val = lockTokenTimeAfterCoverExp / (1 days);
4703 
4704         } else if (code == "JOINFEE") {
4705 
4706             val = joiningFee;
4707 
4708         } 
4709     }
4710 
4711     /**
4712     * @dev Just for interface
4713     */
4714     function changeDependentContractAddress() public { //solhint-disable-line
4715     }
4716     
4717     /**
4718      * @dev to get the contract staked by a staker 
4719      * @param _stakerAddress is the address of the staker
4720      * @param _stakerIndex is the index of staker
4721      * @return the address of staked contract
4722      */
4723     function getStakerStakedContractByIndex(
4724         address _stakerAddress,
4725         uint _stakerIndex
4726     ) 
4727         public
4728         view
4729         returns (address stakedContractAddress) 
4730     {
4731         stakedContractAddress = stakerStakedContracts[
4732             _stakerAddress][_stakerIndex].stakedContractAddress;
4733     }
4734 
4735     /**
4736      * @dev to get the staker's staked burned 
4737      * @param _stakerAddress is the address of the staker
4738      * @param _stakerIndex is the index of staker
4739      * @return amount burned
4740      */
4741     function getStakerStakedBurnedByIndex(
4742         address _stakerAddress,
4743         uint _stakerIndex
4744     ) 
4745         public
4746         view
4747         returns (uint burnedAmount) 
4748     {
4749         burnedAmount = stakerStakedContracts[
4750             _stakerAddress][_stakerIndex].burnedAmount;
4751     }
4752 
4753     /**
4754      * @dev to get the staker's staked unlockable before the last burn 
4755      * @param _stakerAddress is the address of the staker
4756      * @param _stakerIndex is the index of staker
4757      * @return unlockable staked tokens
4758      */
4759     function getStakerStakedUnlockableBeforeLastBurnByIndex(
4760         address _stakerAddress,
4761         uint _stakerIndex
4762     ) 
4763         public
4764         view
4765         returns (uint unlockable) 
4766     {
4767         unlockable = stakerStakedContracts[
4768             _stakerAddress][_stakerIndex].unLockableBeforeLastBurn;
4769     }
4770 
4771     /**
4772      * @dev to get the staker's staked contract index 
4773      * @param _stakerAddress is the address of the staker
4774      * @param _stakerIndex is the index of staker
4775      * @return is the index of the smart contract address
4776      */
4777     function getStakerStakedContractIndex(
4778         address _stakerAddress,
4779         uint _stakerIndex
4780     ) 
4781         public
4782         view
4783         returns (uint scIndex) 
4784     {
4785         scIndex = stakerStakedContracts[
4786             _stakerAddress][_stakerIndex].stakedContractIndex;
4787     }
4788 
4789     /**
4790      * @dev to get the staker index of the staked contract
4791      * @param _stakedContractAddress is the address of the staked contract
4792      * @param _stakedContractIndex is the index of staked contract
4793      * @return is the index of the staker
4794      */
4795     function getStakedContractStakerIndex(
4796         address _stakedContractAddress,
4797         uint _stakedContractIndex
4798     ) 
4799         public
4800         view
4801         returns (uint sIndex) 
4802     {
4803         sIndex = stakedContractStakers[
4804             _stakedContractAddress][_stakedContractIndex].stakerIndex;
4805     }
4806 
4807     /**
4808      * @dev to get the staker's initial staked amount on the contract 
4809      * @param _stakerAddress is the address of the staker
4810      * @param _stakerIndex is the index of staker
4811      * @return staked amount
4812      */
4813     function getStakerInitialStakedAmountOnContract(
4814         address _stakerAddress,
4815         uint _stakerIndex
4816     )
4817         public 
4818         view
4819         returns (uint amount)
4820     {
4821         amount = stakerStakedContracts[
4822             _stakerAddress][_stakerIndex].stakeAmount;
4823     }
4824 
4825     /**
4826      * @dev to get the staker's staked contract length 
4827      * @param _stakerAddress is the address of the staker
4828      * @return length of staked contract
4829      */
4830     function getStakerStakedContractLength(
4831         address _stakerAddress
4832     ) 
4833         public
4834         view
4835         returns (uint length)
4836     {
4837         length = stakerStakedContracts[_stakerAddress].length;
4838     }
4839 
4840     /**
4841      * @dev to get the staker's unlocked tokens which were staked 
4842      * @param _stakerAddress is the address of the staker
4843      * @param _stakerIndex is the index of staker
4844      * @return amount
4845      */
4846     function getStakerUnlockedStakedTokens(
4847         address _stakerAddress,
4848         uint _stakerIndex
4849     )
4850         public 
4851         view
4852         returns (uint amount)
4853     {
4854         amount = stakerStakedContracts[
4855             _stakerAddress][_stakerIndex].unlockedAmount;
4856     }
4857 
4858     /**
4859      * @dev pushes the unlocked staked tokens by a staker.
4860      * @param _stakerAddress address of staker.
4861      * @param _stakerIndex index of the staker to distribute commission.
4862      * @param _amount amount to be given as commission.
4863      */ 
4864     function pushUnlockedStakedTokens(
4865         address _stakerAddress,
4866         uint _stakerIndex,
4867         uint _amount
4868     )   
4869         public
4870         onlyInternal
4871     {   
4872         stakerStakedContracts[_stakerAddress][
4873             _stakerIndex].unlockedAmount = stakerStakedContracts[_stakerAddress][
4874                 _stakerIndex].unlockedAmount.add(_amount);
4875     }
4876 
4877     /**
4878      * @dev pushes the Burned tokens for a staker.
4879      * @param _stakerAddress address of staker.
4880      * @param _stakerIndex index of the staker.
4881      * @param _amount amount to be burned.
4882      */ 
4883     function pushBurnedTokens(
4884         address _stakerAddress,
4885         uint _stakerIndex,
4886         uint _amount
4887     )   
4888         public
4889         onlyInternal
4890     {   
4891         stakerStakedContracts[_stakerAddress][
4892             _stakerIndex].burnedAmount = stakerStakedContracts[_stakerAddress][
4893                 _stakerIndex].burnedAmount.add(_amount);
4894     }
4895 
4896     /**
4897      * @dev pushes the unLockable tokens for a staker before last burn.
4898      * @param _stakerAddress address of staker.
4899      * @param _stakerIndex index of the staker.
4900      * @param _amount amount to be added to unlockable.
4901      */ 
4902     function pushUnlockableBeforeLastBurnTokens(
4903         address _stakerAddress,
4904         uint _stakerIndex,
4905         uint _amount
4906     )   
4907         public
4908         onlyInternal
4909     {   
4910         stakerStakedContracts[_stakerAddress][
4911             _stakerIndex].unLockableBeforeLastBurn = stakerStakedContracts[_stakerAddress][
4912                 _stakerIndex].unLockableBeforeLastBurn.add(_amount);
4913     }
4914 
4915     /**
4916      * @dev sets the unLockable tokens for a staker before last burn.
4917      * @param _stakerAddress address of staker.
4918      * @param _stakerIndex index of the staker.
4919      * @param _amount amount to be added to unlockable.
4920      */ 
4921     function setUnlockableBeforeLastBurnTokens(
4922         address _stakerAddress,
4923         uint _stakerIndex,
4924         uint _amount
4925     )   
4926         public
4927         onlyInternal
4928     {   
4929         stakerStakedContracts[_stakerAddress][
4930             _stakerIndex].unLockableBeforeLastBurn = _amount;
4931     }
4932 
4933     /**
4934      * @dev pushes the earned commission earned by a staker.
4935      * @param _stakerAddress address of staker.
4936      * @param _stakedContractAddress address of smart contract.
4937      * @param _stakedContractIndex index of the staker to distribute commission.
4938      * @param _commissionAmount amount to be given as commission.
4939      */ 
4940     function pushEarnedStakeCommissions(
4941         address _stakerAddress,
4942         address _stakedContractAddress,
4943         uint _stakedContractIndex,
4944         uint _commissionAmount
4945     )   
4946         public
4947         onlyInternal
4948     {
4949         stakedContractStakeCommission[_stakedContractAddress][_stakedContractIndex].
4950             commissionEarned = stakedContractStakeCommission[_stakedContractAddress][
4951                 _stakedContractIndex].commissionEarned.add(_commissionAmount);
4952                 
4953         emit Commission(
4954             _stakerAddress,
4955             _stakedContractAddress,
4956             _stakedContractIndex,
4957             _commissionAmount
4958         );
4959     }
4960 
4961     /**
4962      * @dev pushes the redeemed commission redeemed by a staker.
4963      * @param _stakerAddress address of staker.
4964      * @param _stakerIndex index of the staker to distribute commission.
4965      * @param _amount amount to be given as commission.
4966      */ 
4967     function pushRedeemedStakeCommissions(
4968         address _stakerAddress,
4969         uint _stakerIndex,
4970         uint _amount
4971     )   
4972         public
4973         onlyInternal
4974     {   
4975         uint stakedContractIndex = stakerStakedContracts[
4976             _stakerAddress][_stakerIndex].stakedContractIndex;
4977         address stakedContractAddress = stakerStakedContracts[
4978             _stakerAddress][_stakerIndex].stakedContractAddress;
4979         stakedContractStakeCommission[stakedContractAddress][stakedContractIndex].
4980             commissionRedeemed = stakedContractStakeCommission[
4981                 stakedContractAddress][stakedContractIndex].commissionRedeemed.add(_amount);
4982     }
4983 
4984     /**
4985      * @dev Gets stake commission given to an underwriter
4986      * for particular stakedcontract on given index.
4987      * @param _stakerAddress address of staker.
4988      * @param _stakerIndex index of the staker commission.
4989      */ 
4990     function getStakerEarnedStakeCommission(
4991         address _stakerAddress,
4992         uint _stakerIndex
4993     )
4994         public 
4995         view
4996         returns (uint) 
4997     {
4998         return _getStakerEarnedStakeCommission(_stakerAddress, _stakerIndex);
4999     }
5000 
5001     /**
5002      * @dev Gets stake commission redeemed by an underwriter
5003      * for particular staked contract on given index.
5004      * @param _stakerAddress address of staker.
5005      * @param _stakerIndex index of the staker commission.
5006      * @return commissionEarned total amount given to staker.
5007      */ 
5008     function getStakerRedeemedStakeCommission(
5009         address _stakerAddress,
5010         uint _stakerIndex
5011     )
5012         public 
5013         view
5014         returns (uint) 
5015     {
5016         return _getStakerRedeemedStakeCommission(_stakerAddress, _stakerIndex);
5017     }
5018 
5019     /**
5020      * @dev Gets total stake commission given to an underwriter
5021      * @param _stakerAddress address of staker.
5022      * @return totalCommissionEarned total commission earned by staker.
5023      */ 
5024     function getStakerTotalEarnedStakeCommission(
5025         address _stakerAddress
5026     )
5027         public 
5028         view
5029         returns (uint totalCommissionEarned) 
5030     {
5031         totalCommissionEarned = 0;
5032         for (uint i = 0; i < stakerStakedContracts[_stakerAddress].length; i++) {
5033             totalCommissionEarned = totalCommissionEarned.
5034                 add(_getStakerEarnedStakeCommission(_stakerAddress, i));
5035         }
5036     }
5037 
5038     /**
5039      * @dev Gets total stake commission given to an underwriter
5040      * @param _stakerAddress address of staker.
5041      * @return totalCommissionEarned total commission earned by staker.
5042      */ 
5043     function getStakerTotalReedmedStakeCommission(
5044         address _stakerAddress
5045     )
5046         public 
5047         view
5048         returns(uint totalCommissionRedeemed) 
5049     {
5050         totalCommissionRedeemed = 0;
5051         for (uint i = 0; i < stakerStakedContracts[_stakerAddress].length; i++) {
5052             totalCommissionRedeemed = totalCommissionRedeemed.add(
5053                 _getStakerRedeemedStakeCommission(_stakerAddress, i));
5054         }
5055     }
5056 
5057     /**
5058      * @dev set flag to deposit/ undeposit cover note 
5059      * against a cover Id
5060      * @param coverId coverId of Cover
5061      * @param flag true/false for deposit/undeposit
5062      */
5063     function setDepositCN(uint coverId, bool flag) public onlyInternal {
5064 
5065         if (flag == true) {
5066             require(!depositedCN[coverId].isDeposited, "Cover note already deposited");    
5067         }
5068 
5069         depositedCN[coverId].isDeposited = flag;
5070     }
5071 
5072     /**
5073      * @dev set locked cover note amount
5074      * against a cover Id
5075      * @param coverId coverId of Cover
5076      * @param amount amount of nxm to be locked
5077      */
5078     function setDepositCNAmount(uint coverId, uint amount) public onlyInternal {
5079 
5080         depositedCN[coverId].amount = amount;
5081     }
5082 
5083     /**
5084      * @dev to get the staker address on a staked contract 
5085      * @param _stakedContractAddress is the address of the staked contract in concern
5086      * @param _stakedContractIndex is the index of staked contract's index
5087      * @return address of staker
5088      */
5089     function getStakedContractStakerByIndex(
5090         address _stakedContractAddress,
5091         uint _stakedContractIndex
5092     )
5093         public
5094         view
5095         returns (address stakerAddress)
5096     {
5097         stakerAddress = stakedContractStakers[
5098             _stakedContractAddress][_stakedContractIndex].stakerAddress;
5099     }
5100 
5101     /**
5102      * @dev to get the length of stakers on a staked contract 
5103      * @param _stakedContractAddress is the address of the staked contract in concern
5104      * @return length in concern
5105      */
5106     function getStakedContractStakersLength(
5107         address _stakedContractAddress
5108     ) 
5109         public
5110         view
5111         returns (uint length)
5112     {
5113         length = stakedContractStakers[_stakedContractAddress].length;
5114     } 
5115     
5116     /**
5117      * @dev Adds a new stake record.
5118      * @param _stakerAddress staker address.
5119      * @param _stakedContractAddress smart contract address.
5120      * @param _amount amountof NXM to be staked.
5121      */
5122     function addStake(
5123         address _stakerAddress,
5124         address _stakedContractAddress,
5125         uint _amount
5126     ) 
5127         public
5128         onlyInternal
5129         returns(uint scIndex) 
5130     {
5131         scIndex = (stakedContractStakers[_stakedContractAddress].push(
5132             Staker(_stakerAddress, stakerStakedContracts[_stakerAddress].length))).sub(1);
5133         stakerStakedContracts[_stakerAddress].push(
5134             Stake(_stakedContractAddress, scIndex, now, _amount, 0, 0, 0));
5135     }
5136 
5137     /**
5138      * @dev books the user's tokens for maintaining Assessor Velocity, 
5139      * i.e. once a token is used to cast a vote as a Claims assessor,
5140      * @param _of user's address.
5141      */
5142     function bookCATokens(address _of) public onlyInternal {
5143         require(!isCATokensBooked(_of), "Tokens already booked");
5144         isBookedTokens[_of] = now.add(bookTime);
5145     }
5146 
5147     /**
5148      * @dev to know if claim assessor's tokens are booked or not 
5149      * @param _of is the claim assessor's address in concern
5150      * @return boolean representing the status of tokens booked
5151      */
5152     function isCATokensBooked(address _of) public view returns(bool res) {
5153         if (now < isBookedTokens[_of])
5154             res = true;
5155     }
5156 
5157     /**
5158      * @dev Sets the index which will receive commission.
5159      * @param _stakedContractAddress smart contract address.
5160      * @param _index current index.
5161      */
5162     function setStakedContractCurrentCommissionIndex(
5163         address _stakedContractAddress,
5164         uint _index
5165     )
5166         public
5167         onlyInternal
5168     {
5169         stakedContractCurrentCommissionIndex[_stakedContractAddress] = _index;
5170     }
5171 
5172     /**
5173      * @dev Sets the last complete commission index
5174      * @param _stakerAddress smart contract address.
5175      * @param _index current index.
5176      */
5177     function setLastCompletedStakeCommissionIndex(
5178         address _stakerAddress,
5179         uint _index
5180     )
5181         public
5182         onlyInternal
5183     {
5184         lastCompletedStakeCommission[_stakerAddress] = _index;
5185     }
5186 
5187     /**
5188      * @dev Sets the index till which commission is distrubuted.
5189      * @param _stakedContractAddress smart contract address.
5190      * @param _index current index.
5191      */
5192     function setStakedContractCurrentBurnIndex(
5193         address _stakedContractAddress,
5194         uint _index
5195     )
5196         public
5197         onlyInternal
5198     {
5199         stakedContractCurrentBurnIndex[_stakedContractAddress] = _index;
5200     }
5201 
5202     /**
5203      * @dev Updates Uint Parameters of a code
5204      * @param code whose details we want to update
5205      * @param val value to set
5206      */
5207     function updateUintParameters(bytes8 code, uint val) public {
5208         require(ms.checkIsAuthToGoverned(msg.sender));
5209         if (code == "TOKEXP") {
5210 
5211             _setTokenExponent(val); 
5212 
5213         } else if (code == "TOKSTEP") {
5214 
5215             _setPriceStep(val);
5216 
5217         } else if (code == "RALOCKT") {
5218 
5219             _changeSCValidDays(val);
5220 
5221         } else if (code == "RACOMM") {
5222 
5223             _setStakerCommissionPer(val);
5224 
5225         } else if (code == "RAMAXC") {
5226 
5227             _setStakerMaxCommissionPer(val);
5228 
5229         } else if (code == "CABOOKT") {
5230 
5231             _changeBookTime(val * 1 hours);
5232 
5233         } else if (code == "CALOCKT") {
5234 
5235             _changelockCADays(val * 1 days);
5236 
5237         } else if (code == "MVLOCKT") {
5238 
5239             _changelockMVDays(val * 1 days);
5240 
5241         } else if (code == "QUOLOCKT") {
5242 
5243             _setLockTokenTimeAfterCoverExp(val * 1 days);
5244 
5245         } else if (code == "JOINFEE") {
5246 
5247             _setJoiningFee(val);
5248 
5249         } else {
5250             revert("Invalid param code");
5251         } 
5252     }
5253 
5254     /**
5255      * @dev Internal function to get stake commission given to an 
5256      * underwriter for particular stakedcontract on given index.
5257      * @param _stakerAddress address of staker.
5258      * @param _stakerIndex index of the staker commission.
5259      */ 
5260     function _getStakerEarnedStakeCommission(
5261         address _stakerAddress,
5262         uint _stakerIndex
5263     )
5264         internal
5265         view 
5266         returns (uint amount) 
5267     {
5268         uint _stakedContractIndex;
5269         address _stakedContractAddress;
5270         _stakedContractAddress = stakerStakedContracts[
5271             _stakerAddress][_stakerIndex].stakedContractAddress;
5272         _stakedContractIndex = stakerStakedContracts[
5273             _stakerAddress][_stakerIndex].stakedContractIndex;
5274         amount = stakedContractStakeCommission[
5275             _stakedContractAddress][_stakedContractIndex].commissionEarned;
5276     }
5277 
5278     /**
5279      * @dev Internal function to get stake commission redeemed by an 
5280      * underwriter for particular stakedcontract on given index.
5281      * @param _stakerAddress address of staker.
5282      * @param _stakerIndex index of the staker commission.
5283      */ 
5284     function _getStakerRedeemedStakeCommission(
5285         address _stakerAddress,
5286         uint _stakerIndex
5287     )
5288         internal
5289         view 
5290         returns (uint amount) 
5291     {
5292         uint _stakedContractIndex;
5293         address _stakedContractAddress;
5294         _stakedContractAddress = stakerStakedContracts[
5295             _stakerAddress][_stakerIndex].stakedContractAddress;
5296         _stakedContractIndex = stakerStakedContracts[
5297             _stakerAddress][_stakerIndex].stakedContractIndex;
5298         amount = stakedContractStakeCommission[
5299             _stakedContractAddress][_stakedContractIndex].commissionRedeemed;
5300     }
5301 
5302     /**
5303      * @dev to set the percentage of staker commission 
5304      * @param _val is new percentage value
5305      */
5306     function _setStakerCommissionPer(uint _val) internal {
5307         stakerCommissionPer = _val;
5308     }
5309 
5310     /**
5311      * @dev to set the max percentage of staker commission 
5312      * @param _val is new percentage value
5313      */
5314     function _setStakerMaxCommissionPer(uint _val) internal {
5315         stakerMaxCommissionPer = _val;
5316     }
5317 
5318     /**
5319      * @dev to set the token exponent value 
5320      * @param _val is new value
5321      */
5322     function _setTokenExponent(uint _val) internal {
5323         tokenExponent = _val;
5324     }
5325 
5326     /**
5327      * @dev to set the price step 
5328      * @param _val is new value
5329      */
5330     function _setPriceStep(uint _val) internal {
5331         priceStep = _val;
5332     }
5333 
5334     /**
5335      * @dev Changes number of days for which NXM needs to staked in case of underwriting
5336      */ 
5337     function _changeSCValidDays(uint _days) internal {
5338         scValidDays = _days;
5339     }
5340 
5341     /**
5342      * @dev Changes the time period up to which tokens will be locked.
5343      *      Used to generate the validity period of tokens booked by
5344      *      a user for participating in claim's assessment/claim's voting.
5345      */ 
5346     function _changeBookTime(uint _time) internal {
5347         bookTime = _time;
5348     }
5349 
5350     /**
5351      * @dev Changes lock CA days - number of days for which tokens 
5352      * are locked while submitting a vote.
5353      */ 
5354     function _changelockCADays(uint _val) internal {
5355         lockCADays = _val;
5356     }
5357     
5358     /**
5359      * @dev Changes lock MV days - number of days for which tokens are locked
5360      * while submitting a vote.
5361      */ 
5362     function _changelockMVDays(uint _val) internal {
5363         lockMVDays = _val;
5364     }
5365 
5366     /**
5367      * @dev Changes extra lock period for a cover, post its expiry.
5368      */ 
5369     function _setLockTokenTimeAfterCoverExp(uint time) internal {
5370         lockTokenTimeAfterCoverExp = time;
5371     }
5372 
5373     /**
5374      * @dev Set the joining fee for membership
5375      */
5376     function _setJoiningFee(uint _amount) internal {
5377         joiningFee = _amount;
5378     }
5379 }
5380 
5381 /*
5382 
5383 ORACLIZE_API
5384 
5385 Copyright (c) 2015-2016 Oraclize SRL
5386 Copyright (c) 2016 Oraclize LTD
5387 
5388 Permission is hereby granted, free of charge, to any person obtaining a copy
5389 of this software and associated documentation files (the "Software"), to deal
5390 in the Software without restriction, including without limitation the rights
5391 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
5392 copies of the Software, and to permit persons to whom the Software is
5393 furnished to do so, subject to the following conditions:
5394 
5395 The above copyright notice and this permission notice shall be included in
5396 all copies or substantial portions of the Software.
5397 
5398 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
5399 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
5400 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
5401 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
5402 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
5403 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
5404 THE SOFTWARE.
5405 
5406 */
5407 // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
5408 // Dummy contract only used to emit to end-user they are using wrong solc
5409 contract solcChecker {
5410 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
5411 }
5412 
5413 contract OraclizeI {
5414 
5415     address public cbAddress;
5416 
5417     function setProofType(byte _proofType) external;
5418     function setCustomGasPrice(uint _gasPrice) external;
5419     function getPrice(string memory _datasource) public returns (uint _dsprice);
5420     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
5421     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
5422     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
5423     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
5424     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
5425     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
5426     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
5427     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
5428 }
5429 
5430 contract OraclizeAddrResolverI {
5431     function getAddress() public returns (address _address);
5432 }
5433 
5434 /*
5435 
5436 Begin solidity-cborutils
5437 
5438 https://github.com/smartcontractkit/solidity-cborutils
5439 
5440 MIT License
5441 
5442 Copyright (c) 2018 SmartContract ChainLink, Ltd.
5443 
5444 Permission is hereby granted, free of charge, to any person obtaining a copy
5445 of this software and associated documentation files (the "Software"), to deal
5446 in the Software without restriction, including without limitation the rights
5447 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
5448 copies of the Software, and to permit persons to whom the Software is
5449 furnished to do so, subject to the following conditions:
5450 
5451 The above copyright notice and this permission notice shall be included in all
5452 copies or substantial portions of the Software.
5453 
5454 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
5455 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
5456 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
5457 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
5458 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
5459 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
5460 SOFTWARE.
5461 
5462 */
5463 library Buffer {
5464 
5465     struct buffer {
5466         bytes buf;
5467         uint capacity;
5468     }
5469 
5470     function init(buffer memory _buf, uint _capacity) internal pure {
5471         uint capacity = _capacity;
5472         if (capacity % 32 != 0) {
5473             capacity += 32 - (capacity % 32);
5474         }
5475         _buf.capacity = capacity; // Allocate space for the buffer data
5476         assembly {
5477             let ptr := mload(0x40)
5478             mstore(_buf, ptr)
5479             mstore(ptr, 0)
5480             mstore(0x40, add(ptr, capacity))
5481         }
5482     }
5483 
5484     function resize(buffer memory _buf, uint _capacity) private pure {
5485         bytes memory oldbuf = _buf.buf;
5486         init(_buf, _capacity);
5487         append(_buf, oldbuf);
5488     }
5489 
5490     function max(uint _a, uint _b) private pure returns (uint _max) {
5491         if (_a > _b) {
5492             return _a;
5493         }
5494         return _b;
5495     }
5496     /**
5497       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
5498       *      would exceed the capacity of the buffer.
5499       * @param _buf The buffer to append to.
5500       * @param _data The data to append.
5501       * @return The original buffer.
5502       *
5503       */
5504     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
5505         if (_data.length + _buf.buf.length > _buf.capacity) {
5506             resize(_buf, max(_buf.capacity, _data.length) * 2);
5507         }
5508         uint dest;
5509         uint src;
5510         uint len = _data.length;
5511         assembly {
5512             let bufptr := mload(_buf) // Memory address of the buffer data
5513             let buflen := mload(bufptr) // Length of existing buffer data
5514             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
5515             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
5516             src := add(_data, 32)
5517         }
5518         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
5519             assembly {
5520                 mstore(dest, mload(src))
5521             }
5522             dest += 32;
5523             src += 32;
5524         }
5525         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
5526         assembly {
5527             let srcpart := and(mload(src), not(mask))
5528             let destpart := and(mload(dest), mask)
5529             mstore(dest, or(destpart, srcpart))
5530         }
5531         return _buf;
5532     }
5533     /**
5534       *
5535       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
5536       * exceed the capacity of the buffer.
5537       * @param _buf The buffer to append to.
5538       * @param _data The data to append.
5539       * @return The original buffer.
5540       *
5541       */
5542     function append(buffer memory _buf, uint8 _data) internal pure {
5543         if (_buf.buf.length + 1 > _buf.capacity) {
5544             resize(_buf, _buf.capacity * 2);
5545         }
5546         assembly {
5547             let bufptr := mload(_buf) // Memory address of the buffer data
5548             let buflen := mload(bufptr) // Length of existing buffer data
5549             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
5550             mstore8(dest, _data)
5551             mstore(bufptr, add(buflen, 1)) // Update buffer length
5552         }
5553     }
5554     /**
5555       *
5556       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
5557       * exceed the capacity of the buffer.
5558       * @param _buf The buffer to append to.
5559       * @param _data The data to append.
5560       * @return The original buffer.
5561       *
5562       */
5563     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
5564         if (_len + _buf.buf.length > _buf.capacity) {
5565             resize(_buf, max(_buf.capacity, _len) * 2);
5566         }
5567         uint mask = 256 ** _len - 1;
5568         assembly {
5569             let bufptr := mload(_buf) // Memory address of the buffer data
5570             let buflen := mload(bufptr) // Length of existing buffer data
5571             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
5572             mstore(dest, or(and(mload(dest), not(mask)), _data))
5573             mstore(bufptr, add(buflen, _len)) // Update buffer length
5574         }
5575         return _buf;
5576     }
5577 }
5578 
5579 library CBOR {
5580 
5581     using Buffer for Buffer.buffer;
5582 
5583     uint8 private constant MAJOR_TYPE_INT = 0;
5584     uint8 private constant MAJOR_TYPE_MAP = 5;
5585     uint8 private constant MAJOR_TYPE_BYTES = 2;
5586     uint8 private constant MAJOR_TYPE_ARRAY = 4;
5587     uint8 private constant MAJOR_TYPE_STRING = 3;
5588     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
5589     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
5590 
5591     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
5592         if (_value <= 23) {
5593             _buf.append(uint8((_major << 5) | _value));
5594         } else if (_value <= 0xFF) {
5595             _buf.append(uint8((_major << 5) | 24));
5596             _buf.appendInt(_value, 1);
5597         } else if (_value <= 0xFFFF) {
5598             _buf.append(uint8((_major << 5) | 25));
5599             _buf.appendInt(_value, 2);
5600         } else if (_value <= 0xFFFFFFFF) {
5601             _buf.append(uint8((_major << 5) | 26));
5602             _buf.appendInt(_value, 4);
5603         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
5604             _buf.append(uint8((_major << 5) | 27));
5605             _buf.appendInt(_value, 8);
5606         }
5607     }
5608 
5609     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
5610         _buf.append(uint8((_major << 5) | 31));
5611     }
5612 
5613     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
5614         encodeType(_buf, MAJOR_TYPE_INT, _value);
5615     }
5616 
5617     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
5618         if (_value >= 0) {
5619             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
5620         } else {
5621             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
5622         }
5623     }
5624 
5625     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
5626         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
5627         _buf.append(_value);
5628     }
5629 
5630     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
5631         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
5632         _buf.append(bytes(_value));
5633     }
5634 
5635     function startArray(Buffer.buffer memory _buf) internal pure {
5636         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
5637     }
5638 
5639     function startMap(Buffer.buffer memory _buf) internal pure {
5640         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
5641     }
5642 
5643     function endSequence(Buffer.buffer memory _buf) internal pure {
5644         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
5645     }
5646 }
5647 
5648 /*
5649 
5650 End solidity-cborutils
5651 
5652 */
5653 contract usingOraclize {
5654 
5655     using CBOR for Buffer.buffer;
5656 
5657     OraclizeI oraclize;
5658     OraclizeAddrResolverI OAR;
5659 
5660     uint constant day = 60 * 60 * 24;
5661     uint constant week = 60 * 60 * 24 * 7;
5662     uint constant month = 60 * 60 * 24 * 30;
5663 
5664     byte constant proofType_NONE = 0x00;
5665     byte constant proofType_Ledger = 0x30;
5666     byte constant proofType_Native = 0xF0;
5667     byte constant proofStorage_IPFS = 0x01;
5668     byte constant proofType_Android = 0x40;
5669     byte constant proofType_TLSNotary = 0x10;
5670 
5671     string oraclize_network_name;
5672     uint8 constant networkID_auto = 0;
5673     uint8 constant networkID_morden = 2;
5674     uint8 constant networkID_mainnet = 1;
5675     uint8 constant networkID_testnet = 2;
5676     uint8 constant networkID_consensys = 161;
5677 
5678     mapping(bytes32 => bytes32) oraclize_randomDS_args;
5679     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
5680 
5681     modifier oraclizeAPI {
5682         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
5683             oraclize_setNetwork(networkID_auto);
5684         }
5685         if (address(oraclize) != OAR.getAddress()) {
5686             oraclize = OraclizeI(OAR.getAddress());
5687         }
5688         _;
5689     }
5690 
5691     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
5692         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
5693         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
5694         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
5695         require(proofVerified);
5696         _;
5697     }
5698 
5699     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
5700       return oraclize_setNetwork();
5701       _networkID; // silence the warning and remain backwards compatible
5702     }
5703 
5704     function oraclize_setNetworkName(string memory _network_name) internal {
5705         oraclize_network_name = _network_name;
5706     }
5707 
5708     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
5709         return oraclize_network_name;
5710     }
5711 
5712     function oraclize_setNetwork() internal returns (bool _networkSet) {
5713         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
5714             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
5715             oraclize_setNetworkName("eth_mainnet");
5716             return true;
5717         }
5718         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
5719             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
5720             oraclize_setNetworkName("eth_ropsten3");
5721             return true;
5722         }
5723         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
5724             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
5725             oraclize_setNetworkName("eth_kovan");
5726             return true;
5727         }
5728         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
5729             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
5730             oraclize_setNetworkName("eth_rinkeby");
5731             return true;
5732         }
5733         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
5734             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
5735             oraclize_setNetworkName("eth_goerli");
5736             return true;
5737         }
5738         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
5739             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
5740             return true;
5741         }
5742         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
5743             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
5744             return true;
5745         }
5746         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
5747             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
5748             return true;
5749         }
5750         return false;
5751     }
5752 
5753     function __callback(bytes32 _myid, string memory _result) public {
5754         __callback(_myid, _result, new bytes(0));
5755     }
5756 
5757     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
5758       return;
5759       _myid; _result; _proof; // Silence compiler warnings
5760     }
5761 
5762     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
5763         return oraclize.getPrice(_datasource);
5764     }
5765 
5766     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
5767         return oraclize.getPrice(_datasource, _gasLimit);
5768     }
5769 
5770     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
5771         uint price = oraclize.getPrice(_datasource);
5772         if (price > 1 ether + tx.gasprice * 200000) {
5773             return 0; // Unexpectedly high price
5774         }
5775         return oraclize.query.value(price)(0, _datasource, _arg);
5776     }
5777 
5778     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
5779         uint price = oraclize.getPrice(_datasource);
5780         if (price > 1 ether + tx.gasprice * 200000) {
5781             return 0; // Unexpectedly high price
5782         }
5783         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
5784     }
5785 
5786     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5787         uint price = oraclize.getPrice(_datasource,_gasLimit);
5788         if (price > 1 ether + tx.gasprice * _gasLimit) {
5789             return 0; // Unexpectedly high price
5790         }
5791         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
5792     }
5793 
5794     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5795         uint price = oraclize.getPrice(_datasource, _gasLimit);
5796         if (price > 1 ether + tx.gasprice * _gasLimit) {
5797            return 0; // Unexpectedly high price
5798         }
5799         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
5800     }
5801 
5802     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
5803         uint price = oraclize.getPrice(_datasource);
5804         if (price > 1 ether + tx.gasprice * 200000) {
5805             return 0; // Unexpectedly high price
5806         }
5807         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
5808     }
5809 
5810     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
5811         uint price = oraclize.getPrice(_datasource);
5812         if (price > 1 ether + tx.gasprice * 200000) {
5813             return 0; // Unexpectedly high price
5814         }
5815         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
5816     }
5817 
5818     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5819         uint price = oraclize.getPrice(_datasource, _gasLimit);
5820         if (price > 1 ether + tx.gasprice * _gasLimit) {
5821             return 0; // Unexpectedly high price
5822         }
5823         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
5824     }
5825 
5826     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5827         uint price = oraclize.getPrice(_datasource, _gasLimit);
5828         if (price > 1 ether + tx.gasprice * _gasLimit) {
5829             return 0; // Unexpectedly high price
5830         }
5831         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
5832     }
5833 
5834     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
5835         uint price = oraclize.getPrice(_datasource);
5836         if (price > 1 ether + tx.gasprice * 200000) {
5837             return 0; // Unexpectedly high price
5838         }
5839         bytes memory args = stra2cbor(_argN);
5840         return oraclize.queryN.value(price)(0, _datasource, args);
5841     }
5842 
5843     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
5844         uint price = oraclize.getPrice(_datasource);
5845         if (price > 1 ether + tx.gasprice * 200000) {
5846             return 0; // Unexpectedly high price
5847         }
5848         bytes memory args = stra2cbor(_argN);
5849         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
5850     }
5851 
5852     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5853         uint price = oraclize.getPrice(_datasource, _gasLimit);
5854         if (price > 1 ether + tx.gasprice * _gasLimit) {
5855             return 0; // Unexpectedly high price
5856         }
5857         bytes memory args = stra2cbor(_argN);
5858         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
5859     }
5860 
5861     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5862         uint price = oraclize.getPrice(_datasource, _gasLimit);
5863         if (price > 1 ether + tx.gasprice * _gasLimit) {
5864             return 0; // Unexpectedly high price
5865         }
5866         bytes memory args = stra2cbor(_argN);
5867         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
5868     }
5869 
5870     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5871         string[] memory dynargs = new string[](1);
5872         dynargs[0] = _args[0];
5873         return oraclize_query(_datasource, dynargs);
5874     }
5875 
5876     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5877         string[] memory dynargs = new string[](1);
5878         dynargs[0] = _args[0];
5879         return oraclize_query(_timestamp, _datasource, dynargs);
5880     }
5881 
5882     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5883         string[] memory dynargs = new string[](1);
5884         dynargs[0] = _args[0];
5885         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5886     }
5887 
5888     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5889         string[] memory dynargs = new string[](1);
5890         dynargs[0] = _args[0];
5891         return oraclize_query(_datasource, dynargs, _gasLimit);
5892     }
5893 
5894     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5895         string[] memory dynargs = new string[](2);
5896         dynargs[0] = _args[0];
5897         dynargs[1] = _args[1];
5898         return oraclize_query(_datasource, dynargs);
5899     }
5900 
5901     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5902         string[] memory dynargs = new string[](2);
5903         dynargs[0] = _args[0];
5904         dynargs[1] = _args[1];
5905         return oraclize_query(_timestamp, _datasource, dynargs);
5906     }
5907 
5908     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5909         string[] memory dynargs = new string[](2);
5910         dynargs[0] = _args[0];
5911         dynargs[1] = _args[1];
5912         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5913     }
5914 
5915     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5916         string[] memory dynargs = new string[](2);
5917         dynargs[0] = _args[0];
5918         dynargs[1] = _args[1];
5919         return oraclize_query(_datasource, dynargs, _gasLimit);
5920     }
5921 
5922     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5923         string[] memory dynargs = new string[](3);
5924         dynargs[0] = _args[0];
5925         dynargs[1] = _args[1];
5926         dynargs[2] = _args[2];
5927         return oraclize_query(_datasource, dynargs);
5928     }
5929 
5930     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5931         string[] memory dynargs = new string[](3);
5932         dynargs[0] = _args[0];
5933         dynargs[1] = _args[1];
5934         dynargs[2] = _args[2];
5935         return oraclize_query(_timestamp, _datasource, dynargs);
5936     }
5937 
5938     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5939         string[] memory dynargs = new string[](3);
5940         dynargs[0] = _args[0];
5941         dynargs[1] = _args[1];
5942         dynargs[2] = _args[2];
5943         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5944     }
5945 
5946     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5947         string[] memory dynargs = new string[](3);
5948         dynargs[0] = _args[0];
5949         dynargs[1] = _args[1];
5950         dynargs[2] = _args[2];
5951         return oraclize_query(_datasource, dynargs, _gasLimit);
5952     }
5953 
5954     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5955         string[] memory dynargs = new string[](4);
5956         dynargs[0] = _args[0];
5957         dynargs[1] = _args[1];
5958         dynargs[2] = _args[2];
5959         dynargs[3] = _args[3];
5960         return oraclize_query(_datasource, dynargs);
5961     }
5962 
5963     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5964         string[] memory dynargs = new string[](4);
5965         dynargs[0] = _args[0];
5966         dynargs[1] = _args[1];
5967         dynargs[2] = _args[2];
5968         dynargs[3] = _args[3];
5969         return oraclize_query(_timestamp, _datasource, dynargs);
5970     }
5971 
5972     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5973         string[] memory dynargs = new string[](4);
5974         dynargs[0] = _args[0];
5975         dynargs[1] = _args[1];
5976         dynargs[2] = _args[2];
5977         dynargs[3] = _args[3];
5978         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
5979     }
5980 
5981     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
5982         string[] memory dynargs = new string[](4);
5983         dynargs[0] = _args[0];
5984         dynargs[1] = _args[1];
5985         dynargs[2] = _args[2];
5986         dynargs[3] = _args[3];
5987         return oraclize_query(_datasource, dynargs, _gasLimit);
5988     }
5989 
5990     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
5991         string[] memory dynargs = new string[](5);
5992         dynargs[0] = _args[0];
5993         dynargs[1] = _args[1];
5994         dynargs[2] = _args[2];
5995         dynargs[3] = _args[3];
5996         dynargs[4] = _args[4];
5997         return oraclize_query(_datasource, dynargs);
5998     }
5999 
6000     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6001         string[] memory dynargs = new string[](5);
6002         dynargs[0] = _args[0];
6003         dynargs[1] = _args[1];
6004         dynargs[2] = _args[2];
6005         dynargs[3] = _args[3];
6006         dynargs[4] = _args[4];
6007         return oraclize_query(_timestamp, _datasource, dynargs);
6008     }
6009 
6010     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6011         string[] memory dynargs = new string[](5);
6012         dynargs[0] = _args[0];
6013         dynargs[1] = _args[1];
6014         dynargs[2] = _args[2];
6015         dynargs[3] = _args[3];
6016         dynargs[4] = _args[4];
6017         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
6018     }
6019 
6020     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6021         string[] memory dynargs = new string[](5);
6022         dynargs[0] = _args[0];
6023         dynargs[1] = _args[1];
6024         dynargs[2] = _args[2];
6025         dynargs[3] = _args[3];
6026         dynargs[4] = _args[4];
6027         return oraclize_query(_datasource, dynargs, _gasLimit);
6028     }
6029 
6030     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
6031         uint price = oraclize.getPrice(_datasource);
6032         if (price > 1 ether + tx.gasprice * 200000) {
6033             return 0; // Unexpectedly high price
6034         }
6035         bytes memory args = ba2cbor(_argN);
6036         return oraclize.queryN.value(price)(0, _datasource, args);
6037     }
6038 
6039     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
6040         uint price = oraclize.getPrice(_datasource);
6041         if (price > 1 ether + tx.gasprice * 200000) {
6042             return 0; // Unexpectedly high price
6043         }
6044         bytes memory args = ba2cbor(_argN);
6045         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
6046     }
6047 
6048     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6049         uint price = oraclize.getPrice(_datasource, _gasLimit);
6050         if (price > 1 ether + tx.gasprice * _gasLimit) {
6051             return 0; // Unexpectedly high price
6052         }
6053         bytes memory args = ba2cbor(_argN);
6054         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
6055     }
6056 
6057     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6058         uint price = oraclize.getPrice(_datasource, _gasLimit);
6059         if (price > 1 ether + tx.gasprice * _gasLimit) {
6060             return 0; // Unexpectedly high price
6061         }
6062         bytes memory args = ba2cbor(_argN);
6063         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
6064     }
6065 
6066     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6067         bytes[] memory dynargs = new bytes[](1);
6068         dynargs[0] = _args[0];
6069         return oraclize_query(_datasource, dynargs);
6070     }
6071 
6072     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6073         bytes[] memory dynargs = new bytes[](1);
6074         dynargs[0] = _args[0];
6075         return oraclize_query(_timestamp, _datasource, dynargs);
6076     }
6077 
6078     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6079         bytes[] memory dynargs = new bytes[](1);
6080         dynargs[0] = _args[0];
6081         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
6082     }
6083 
6084     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6085         bytes[] memory dynargs = new bytes[](1);
6086         dynargs[0] = _args[0];
6087         return oraclize_query(_datasource, dynargs, _gasLimit);
6088     }
6089 
6090     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6091         bytes[] memory dynargs = new bytes[](2);
6092         dynargs[0] = _args[0];
6093         dynargs[1] = _args[1];
6094         return oraclize_query(_datasource, dynargs);
6095     }
6096 
6097     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6098         bytes[] memory dynargs = new bytes[](2);
6099         dynargs[0] = _args[0];
6100         dynargs[1] = _args[1];
6101         return oraclize_query(_timestamp, _datasource, dynargs);
6102     }
6103 
6104     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6105         bytes[] memory dynargs = new bytes[](2);
6106         dynargs[0] = _args[0];
6107         dynargs[1] = _args[1];
6108         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
6109     }
6110 
6111     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6112         bytes[] memory dynargs = new bytes[](2);
6113         dynargs[0] = _args[0];
6114         dynargs[1] = _args[1];
6115         return oraclize_query(_datasource, dynargs, _gasLimit);
6116     }
6117 
6118     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6119         bytes[] memory dynargs = new bytes[](3);
6120         dynargs[0] = _args[0];
6121         dynargs[1] = _args[1];
6122         dynargs[2] = _args[2];
6123         return oraclize_query(_datasource, dynargs);
6124     }
6125 
6126     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6127         bytes[] memory dynargs = new bytes[](3);
6128         dynargs[0] = _args[0];
6129         dynargs[1] = _args[1];
6130         dynargs[2] = _args[2];
6131         return oraclize_query(_timestamp, _datasource, dynargs);
6132     }
6133 
6134     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6135         bytes[] memory dynargs = new bytes[](3);
6136         dynargs[0] = _args[0];
6137         dynargs[1] = _args[1];
6138         dynargs[2] = _args[2];
6139         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
6140     }
6141 
6142     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6143         bytes[] memory dynargs = new bytes[](3);
6144         dynargs[0] = _args[0];
6145         dynargs[1] = _args[1];
6146         dynargs[2] = _args[2];
6147         return oraclize_query(_datasource, dynargs, _gasLimit);
6148     }
6149 
6150     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6151         bytes[] memory dynargs = new bytes[](4);
6152         dynargs[0] = _args[0];
6153         dynargs[1] = _args[1];
6154         dynargs[2] = _args[2];
6155         dynargs[3] = _args[3];
6156         return oraclize_query(_datasource, dynargs);
6157     }
6158 
6159     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6160         bytes[] memory dynargs = new bytes[](4);
6161         dynargs[0] = _args[0];
6162         dynargs[1] = _args[1];
6163         dynargs[2] = _args[2];
6164         dynargs[3] = _args[3];
6165         return oraclize_query(_timestamp, _datasource, dynargs);
6166     }
6167 
6168     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6169         bytes[] memory dynargs = new bytes[](4);
6170         dynargs[0] = _args[0];
6171         dynargs[1] = _args[1];
6172         dynargs[2] = _args[2];
6173         dynargs[3] = _args[3];
6174         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
6175     }
6176 
6177     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6178         bytes[] memory dynargs = new bytes[](4);
6179         dynargs[0] = _args[0];
6180         dynargs[1] = _args[1];
6181         dynargs[2] = _args[2];
6182         dynargs[3] = _args[3];
6183         return oraclize_query(_datasource, dynargs, _gasLimit);
6184     }
6185 
6186     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6187         bytes[] memory dynargs = new bytes[](5);
6188         dynargs[0] = _args[0];
6189         dynargs[1] = _args[1];
6190         dynargs[2] = _args[2];
6191         dynargs[3] = _args[3];
6192         dynargs[4] = _args[4];
6193         return oraclize_query(_datasource, dynargs);
6194     }
6195 
6196     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
6197         bytes[] memory dynargs = new bytes[](5);
6198         dynargs[0] = _args[0];
6199         dynargs[1] = _args[1];
6200         dynargs[2] = _args[2];
6201         dynargs[3] = _args[3];
6202         dynargs[4] = _args[4];
6203         return oraclize_query(_timestamp, _datasource, dynargs);
6204     }
6205 
6206     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6207         bytes[] memory dynargs = new bytes[](5);
6208         dynargs[0] = _args[0];
6209         dynargs[1] = _args[1];
6210         dynargs[2] = _args[2];
6211         dynargs[3] = _args[3];
6212         dynargs[4] = _args[4];
6213         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
6214     }
6215 
6216     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
6217         bytes[] memory dynargs = new bytes[](5);
6218         dynargs[0] = _args[0];
6219         dynargs[1] = _args[1];
6220         dynargs[2] = _args[2];
6221         dynargs[3] = _args[3];
6222         dynargs[4] = _args[4];
6223         return oraclize_query(_datasource, dynargs, _gasLimit);
6224     }
6225 
6226     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
6227         return oraclize.setProofType(_proofP);
6228     }
6229 
6230 
6231     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
6232         return oraclize.cbAddress();
6233     }
6234 
6235     function getCodeSize(address _addr) view internal returns (uint _size) {
6236         assembly {
6237             _size := extcodesize(_addr)
6238         }
6239     }
6240 
6241     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
6242         return oraclize.setCustomGasPrice(_gasPrice);
6243     }
6244 
6245     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
6246         return oraclize.randomDS_getSessionPubKeyHash();
6247     }
6248 
6249     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
6250         bytes memory tmp = bytes(_a);
6251         uint160 iaddr = 0;
6252         uint160 b1;
6253         uint160 b2;
6254         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
6255             iaddr *= 256;
6256             b1 = uint160(uint8(tmp[i]));
6257             b2 = uint160(uint8(tmp[i + 1]));
6258             if ((b1 >= 97) && (b1 <= 102)) {
6259                 b1 -= 87;
6260             } else if ((b1 >= 65) && (b1 <= 70)) {
6261                 b1 -= 55;
6262             } else if ((b1 >= 48) && (b1 <= 57)) {
6263                 b1 -= 48;
6264             }
6265             if ((b2 >= 97) && (b2 <= 102)) {
6266                 b2 -= 87;
6267             } else if ((b2 >= 65) && (b2 <= 70)) {
6268                 b2 -= 55;
6269             } else if ((b2 >= 48) && (b2 <= 57)) {
6270                 b2 -= 48;
6271             }
6272             iaddr += (b1 * 16 + b2);
6273         }
6274         return address(iaddr);
6275     }
6276 
6277     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
6278         bytes memory a = bytes(_a);
6279         bytes memory b = bytes(_b);
6280         uint minLength = a.length;
6281         if (b.length < minLength) {
6282             minLength = b.length;
6283         }
6284         for (uint i = 0; i < minLength; i ++) {
6285             if (a[i] < b[i]) {
6286                 return -1;
6287             } else if (a[i] > b[i]) {
6288                 return 1;
6289             }
6290         }
6291         if (a.length < b.length) {
6292             return -1;
6293         } else if (a.length > b.length) {
6294             return 1;
6295         } else {
6296             return 0;
6297         }
6298     }
6299 
6300     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
6301         bytes memory h = bytes(_haystack);
6302         bytes memory n = bytes(_needle);
6303         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
6304             return -1;
6305         } else if (h.length > (2 ** 128 - 1)) {
6306             return -1;
6307         } else {
6308             uint subindex = 0;
6309             for (uint i = 0; i < h.length; i++) {
6310                 if (h[i] == n[0]) {
6311                     subindex = 1;
6312                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
6313                         subindex++;
6314                     }
6315                     if (subindex == n.length) {
6316                         return int(i);
6317                     }
6318                 }
6319             }
6320             return -1;
6321         }
6322     }
6323 
6324     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
6325         return strConcat(_a, _b, "", "", "");
6326     }
6327 
6328     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
6329         return strConcat(_a, _b, _c, "", "");
6330     }
6331 
6332     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
6333         return strConcat(_a, _b, _c, _d, "");
6334     }
6335 
6336     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
6337         bytes memory _ba = bytes(_a);
6338         bytes memory _bb = bytes(_b);
6339         bytes memory _bc = bytes(_c);
6340         bytes memory _bd = bytes(_d);
6341         bytes memory _be = bytes(_e);
6342         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
6343         bytes memory babcde = bytes(abcde);
6344         uint k = 0;
6345         uint i = 0;
6346         for (i = 0; i < _ba.length; i++) {
6347             babcde[k++] = _ba[i];
6348         }
6349         for (i = 0; i < _bb.length; i++) {
6350             babcde[k++] = _bb[i];
6351         }
6352         for (i = 0; i < _bc.length; i++) {
6353             babcde[k++] = _bc[i];
6354         }
6355         for (i = 0; i < _bd.length; i++) {
6356             babcde[k++] = _bd[i];
6357         }
6358         for (i = 0; i < _be.length; i++) {
6359             babcde[k++] = _be[i];
6360         }
6361         return string(babcde);
6362     }
6363 
6364     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
6365         return safeParseInt(_a, 0);
6366     }
6367 
6368     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
6369         bytes memory bresult = bytes(_a);
6370         uint mint = 0;
6371         bool decimals = false;
6372         for (uint i = 0; i < bresult.length; i++) {
6373             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
6374                 if (decimals) {
6375                    if (_b == 0) break;
6376                     else _b--;
6377                 }
6378                 mint *= 10;
6379                 mint += uint(uint8(bresult[i])) - 48;
6380             } else if (uint(uint8(bresult[i])) == 46) {
6381                 require(!decimals, 'More than one decimal encountered in string!');
6382                 decimals = true;
6383             } else {
6384                 revert("Non-numeral character encountered in string!");
6385             }
6386         }
6387         if (_b > 0) {
6388             mint *= 10 ** _b;
6389         }
6390         return mint;
6391     }
6392 
6393     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
6394         return parseInt(_a, 0);
6395     }
6396 
6397     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
6398         bytes memory bresult = bytes(_a);
6399         uint mint = 0;
6400         bool decimals = false;
6401         for (uint i = 0; i < bresult.length; i++) {
6402             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
6403                 if (decimals) {
6404                    if (_b == 0) {
6405                        break;
6406                    } else {
6407                        _b--;
6408                    }
6409                 }
6410                 mint *= 10;
6411                 mint += uint(uint8(bresult[i])) - 48;
6412             } else if (uint(uint8(bresult[i])) == 46) {
6413                 decimals = true;
6414             }
6415         }
6416         if (_b > 0) {
6417             mint *= 10 ** _b;
6418         }
6419         return mint;
6420     }
6421 
6422     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
6423         if (_i == 0) {
6424             return "0";
6425         }
6426         uint j = _i;
6427         uint len;
6428         while (j != 0) {
6429             len++;
6430             j /= 10;
6431         }
6432         bytes memory bstr = new bytes(len);
6433         uint k = len - 1;
6434         while (_i != 0) {
6435             bstr[k--] = byte(uint8(48 + _i % 10));
6436             _i /= 10;
6437         }
6438         return string(bstr);
6439     }
6440 
6441     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
6442         safeMemoryCleaner();
6443         Buffer.buffer memory buf;
6444         Buffer.init(buf, 1024);
6445         buf.startArray();
6446         for (uint i = 0; i < _arr.length; i++) {
6447             buf.encodeString(_arr[i]);
6448         }
6449         buf.endSequence();
6450         return buf.buf;
6451     }
6452 
6453     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
6454         safeMemoryCleaner();
6455         Buffer.buffer memory buf;
6456         Buffer.init(buf, 1024);
6457         buf.startArray();
6458         for (uint i = 0; i < _arr.length; i++) {
6459             buf.encodeBytes(_arr[i]);
6460         }
6461         buf.endSequence();
6462         return buf.buf;
6463     }
6464 
6465     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
6466         require((_nbytes > 0) && (_nbytes <= 32));
6467         _delay *= 10; // Convert from seconds to ledger timer ticks
6468         bytes memory nbytes = new bytes(1);
6469         nbytes[0] = byte(uint8(_nbytes));
6470         bytes memory unonce = new bytes(32);
6471         bytes memory sessionKeyHash = new bytes(32);
6472         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
6473         assembly {
6474             mstore(unonce, 0x20)
6475             /*
6476              The following variables can be relaxed.
6477              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
6478              for an idea on how to override and replace commit hash variables.
6479             */
6480             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
6481             mstore(sessionKeyHash, 0x20)
6482             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
6483         }
6484         bytes memory delay = new bytes(32);
6485         assembly {
6486             mstore(add(delay, 0x20), _delay)
6487         }
6488         bytes memory delay_bytes8 = new bytes(8);
6489         copyBytes(delay, 24, 8, delay_bytes8, 0);
6490         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
6491         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
6492         bytes memory delay_bytes8_left = new bytes(8);
6493         assembly {
6494             let x := mload(add(delay_bytes8, 0x20))
6495             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
6496             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
6497             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
6498             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
6499             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
6500             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
6501             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
6502             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
6503         }
6504         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
6505         return queryId;
6506     }
6507 
6508     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
6509         oraclize_randomDS_args[_queryId] = _commitment;
6510     }
6511 
6512     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
6513         bool sigok;
6514         address signer;
6515         bytes32 sigr;
6516         bytes32 sigs;
6517         bytes memory sigr_ = new bytes(32);
6518         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
6519         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
6520         bytes memory sigs_ = new bytes(32);
6521         offset += 32 + 2;
6522         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
6523         assembly {
6524             sigr := mload(add(sigr_, 32))
6525             sigs := mload(add(sigs_, 32))
6526         }
6527         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
6528         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
6529             return true;
6530         } else {
6531             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
6532             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
6533         }
6534     }
6535 
6536     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
6537         bool sigok;
6538         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
6539         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
6540         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
6541         bytes memory appkey1_pubkey = new bytes(64);
6542         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
6543         bytes memory tosign2 = new bytes(1 + 65 + 32);
6544         tosign2[0] = byte(uint8(1)); //role
6545         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
6546         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
6547         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
6548         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
6549         if (!sigok) {
6550             return false;
6551         }
6552         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
6553         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
6554         bytes memory tosign3 = new bytes(1 + 65);
6555         tosign3[0] = 0xFE;
6556         copyBytes(_proof, 3, 65, tosign3, 1);
6557         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
6558         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
6559         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
6560         return sigok;
6561     }
6562 
6563     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
6564         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
6565         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
6566             return 1;
6567         }
6568         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
6569         if (!proofVerified) {
6570             return 2;
6571         }
6572         return 0;
6573     }
6574 
6575     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
6576         bool match_ = true;
6577         require(_prefix.length == _nRandomBytes);
6578         for (uint256 i = 0; i< _nRandomBytes; i++) {
6579             if (_content[i] != _prefix[i]) {
6580                 match_ = false;
6581             }
6582         }
6583         return match_;
6584     }
6585 
6586     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
6587         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
6588         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
6589         bytes memory keyhash = new bytes(32);
6590         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
6591         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
6592             return false;
6593         }
6594         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
6595         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
6596         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
6597         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
6598             return false;
6599         }
6600         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
6601         // This is to verify that the computed args match with the ones specified in the query.
6602         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
6603         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
6604         bytes memory sessionPubkey = new bytes(64);
6605         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
6606         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
6607         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
6608         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
6609             delete oraclize_randomDS_args[_queryId];
6610         } else return false;
6611         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
6612         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
6613         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
6614         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
6615             return false;
6616         }
6617         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
6618         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
6619             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
6620         }
6621         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
6622     }
6623     /*
6624      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
6625     */
6626     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
6627         uint minLength = _length + _toOffset;
6628         require(_to.length >= minLength); // Buffer too small. Should be a better way?
6629         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
6630         uint j = 32 + _toOffset;
6631         while (i < (32 + _fromOffset + _length)) {
6632             assembly {
6633                 let tmp := mload(add(_from, i))
6634                 mstore(add(_to, j), tmp)
6635             }
6636             i += 32;
6637             j += 32;
6638         }
6639         return _to;
6640     }
6641     /*
6642      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
6643      Duplicate Solidity's ecrecover, but catching the CALL return value
6644     */
6645     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
6646         /*
6647          We do our own memory management here. Solidity uses memory offset
6648          0x40 to store the current end of memory. We write past it (as
6649          writes are memory extensions), but don't update the offset so
6650          Solidity will reuse it. The memory used here is only needed for
6651          this context.
6652          FIXME: inline assembly can't access return values
6653         */
6654         bool ret;
6655         address addr;
6656         assembly {
6657             let size := mload(0x40)
6658             mstore(size, _hash)
6659             mstore(add(size, 32), _v)
6660             mstore(add(size, 64), _r)
6661             mstore(add(size, 96), _s)
6662             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
6663             addr := mload(size)
6664         }
6665         return (ret, addr);
6666     }
6667     /*
6668      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
6669     */
6670     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
6671         bytes32 r;
6672         bytes32 s;
6673         uint8 v;
6674         if (_sig.length != 65) {
6675             return (false, address(0));
6676         }
6677         /*
6678          The signature format is a compact form of:
6679            {bytes32 r}{bytes32 s}{uint8 v}
6680          Compact means, uint8 is not padded to 32 bytes.
6681         */
6682         assembly {
6683             r := mload(add(_sig, 32))
6684             s := mload(add(_sig, 64))
6685             /*
6686              Here we are loading the last 32 bytes. We exploit the fact that
6687              'mload' will pad with zeroes if we overread.
6688              There is no 'mload8' to do this, but that would be nicer.
6689             */
6690             v := byte(0, mload(add(_sig, 96)))
6691             /*
6692               Alternative solution:
6693               'byte' is not working due to the Solidity parser, so lets
6694               use the second best option, 'and'
6695               v := and(mload(add(_sig, 65)), 255)
6696             */
6697         }
6698         /*
6699          albeit non-transactional signatures are not specified by the YP, one would expect it
6700          to match the YP range of [27, 28]
6701          geth uses [0, 1] and some clients have followed. This might change, see:
6702          https://github.com/ethereum/go-ethereum/issues/2053
6703         */
6704         if (v < 27) {
6705             v += 27;
6706         }
6707         if (v != 27 && v != 28) {
6708             return (false, address(0));
6709         }
6710         return safer_ecrecover(_hash, v, r, s);
6711     }
6712 
6713     function safeMemoryCleaner() internal pure {
6714         assembly {
6715             let fmem := mload(0x40)
6716             codecopy(fmem, codesize, sub(msize, fmem))
6717         }
6718     }
6719 }
6720 
6721 /*
6722 
6723 END ORACLIZE_API
6724 
6725 */
6726 
6727 /* Copyright (C) 2017 NexusMutual.io
6728 
6729   This program is free software: you can redistribute it and/or modify
6730     it under the terms of the GNU General Public License as published by
6731     the Free Software Foundation, either version 3 of the License, or
6732     (at your option) any later version.
6733 
6734   This program is distributed in the hope that it will be useful,
6735     but WITHOUT ANY WARRANTY; without even the implied warranty of
6736     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
6737     GNU General Public License for more details.
6738 
6739   You should have received a copy of the GNU General Public License
6740     along with this program.  If not, see http://www.gnu.org/licenses/ */
6741 contract Quotation is Iupgradable {
6742     using SafeMath for uint;
6743 
6744     TokenFunctions internal tf;
6745     TokenController internal tc;
6746     TokenData internal td;
6747     Pool1 internal p1;
6748     PoolData internal pd;
6749     QuotationData internal qd;
6750     MCR internal m1;
6751     MemberRoles internal mr;
6752     bool internal locked;
6753 
6754     event RefundEvent(address indexed user, bool indexed status, uint holdedCoverID, bytes32 reason);
6755 
6756     modifier noReentrancy() {
6757         require(!locked, "Reentrant call.");
6758         locked = true;
6759         _;
6760         locked = false;
6761     }
6762     
6763     /**
6764      * @dev Iupgradable Interface to update dependent contract address
6765      */
6766     function changeDependentContractAddress() public onlyInternal {
6767         m1 = MCR(ms.getLatestAddress("MC"));
6768         tf = TokenFunctions(ms.getLatestAddress("TF"));
6769         tc = TokenController(ms.getLatestAddress("TC"));
6770         td = TokenData(ms.getLatestAddress("TD"));
6771         qd = QuotationData(ms.getLatestAddress("QD"));
6772         p1 = Pool1(ms.getLatestAddress("P1"));
6773         pd = PoolData(ms.getLatestAddress("PD"));
6774         mr = MemberRoles(ms.getLatestAddress("MR"));
6775     }
6776 
6777     function sendEther() public payable {
6778         
6779     }
6780 
6781     /**
6782      * @dev Expires a cover after a set period of time.
6783      * Changes the status of the Cover and reduces the current
6784      * sum assured of all areas in which the quotation lies
6785      * Unlocks the CN tokens of the cover. Updates the Total Sum Assured value.
6786      * @param _cid Cover Id.
6787      */ 
6788     function expireCover(uint _cid) public {
6789         require(checkCoverExpired(_cid) && qd.getCoverStatusNo(_cid) != uint(QuotationData.CoverStatus.CoverExpired));
6790         
6791         tf.unlockCN(_cid);
6792         bytes4 curr;
6793         address scAddress;
6794         uint sumAssured;
6795         (, , scAddress, curr, sumAssured, ) = qd.getCoverDetailsByCoverID1(_cid);
6796         if (qd.getCoverStatusNo(_cid) != uint(QuotationData.CoverStatus.ClaimAccepted))
6797             _removeSAFromCSA(_cid, sumAssured);
6798         qd.changeCoverStatusNo(_cid, uint8(QuotationData.CoverStatus.CoverExpired));       
6799     }
6800 
6801     /**
6802      * @dev Checks if a cover should get expired/closed or not.
6803      * @param _cid Cover Index.
6804      * @return expire true if the Cover's time has expired, false otherwise.
6805      */ 
6806     function checkCoverExpired(uint _cid) public view returns(bool expire) {
6807 
6808         expire = qd.getValidityOfCover(_cid) < uint64(now);
6809 
6810     }
6811 
6812     /**
6813      * @dev Updates the Sum Assured Amount of all the quotation.
6814      * @param _cid Cover id
6815      * @param _amount that will get subtracted Current Sum Assured 
6816      * amount that comes under a quotation.
6817      */ 
6818     function removeSAFromCSA(uint _cid, uint _amount) public onlyInternal {
6819         _removeSAFromCSA(_cid, _amount);        
6820     }
6821 
6822     /**
6823      * @dev Makes Cover funded via NXM tokens.
6824      * @param smartCAdd Smart Contract Address
6825      */ 
6826     function makeCoverUsingNXMTokens(
6827         uint[] memory coverDetails,
6828         uint16 coverPeriod,
6829         bytes4 coverCurr,
6830         address smartCAdd,
6831         uint8 _v,
6832         bytes32 _r,
6833         bytes32 _s
6834     )
6835         public
6836         isMemberAndcheckPause
6837     {
6838         
6839         tc.burnFrom(msg.sender, coverDetails[2]); //need burn allowance
6840         _verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
6841     }
6842 
6843     /**
6844      * @dev Verifies cover details signed off chain.
6845      * @param from address of funder.
6846      * @param scAddress Smart Contract Address
6847      */
6848     function verifyCoverDetails(
6849         address payable from,
6850         address scAddress,
6851         bytes4 coverCurr,
6852         uint[] memory coverDetails,
6853         uint16 coverPeriod,
6854         uint8 _v,
6855         bytes32 _r,
6856         bytes32 _s
6857     )
6858         public
6859         onlyInternal
6860     {
6861         _verifyCoverDetails(
6862             from,
6863             scAddress,
6864             coverCurr,
6865             coverDetails,
6866             coverPeriod,
6867             _v,
6868             _r,
6869             _s
6870         );
6871     }
6872 
6873     /** 
6874      * @dev Verifies signature.
6875      * @param coverDetails details related to cover.
6876      * @param coverPeriod validity of cover.
6877      * @param smaratCA smarat contract address.
6878      * @param _v argument from vrs hash.
6879      * @param _r argument from vrs hash.
6880      * @param _s argument from vrs hash.
6881      */ 
6882     function verifySign(
6883         uint[] memory coverDetails,
6884         uint16 coverPeriod,
6885         bytes4 curr,
6886         address smaratCA,
6887         uint8 _v,
6888         bytes32 _r,
6889         bytes32 _s
6890     ) 
6891         public
6892         view
6893         returns(bool)
6894     {
6895         require(smaratCA != address(0));
6896         require(pd.capReached() == 1, "Can not buy cover until cap reached for 1st time");
6897         bytes32 hash = getOrderHash(coverDetails, coverPeriod, curr, smaratCA);
6898         return isValidSignature(hash, _v, _r, _s);
6899     }
6900 
6901     /**
6902      * @dev Gets order hash for given cover details.
6903      * @param coverDetails details realted to cover.
6904      * @param coverPeriod validity of cover.
6905      * @param smaratCA smarat contract address.
6906      */ 
6907     function getOrderHash(
6908         uint[] memory coverDetails,
6909         uint16 coverPeriod,
6910         bytes4 curr,
6911         address smaratCA
6912     ) 
6913         public
6914         view
6915         returns(bytes32)
6916     {
6917         return keccak256(
6918             abi.encodePacked(
6919                 coverDetails[0],
6920                 curr, coverPeriod,
6921                 smaratCA,
6922                 coverDetails[1],
6923                 coverDetails[2],
6924                 coverDetails[3],
6925                 coverDetails[4],
6926                 address(this)
6927             )
6928         );
6929     }
6930 
6931     /**
6932      * @dev Verifies signature.
6933      * @param hash order hash
6934      * @param v argument from vrs hash.
6935      * @param r argument from vrs hash.
6936      * @param s argument from vrs hash.
6937      */  
6938     function isValidSignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public view returns(bool) {
6939         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
6940         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
6941         address a = ecrecover(prefixedHash, v, r, s);
6942         return (a == qd.getAuthQuoteEngine());
6943     }
6944 
6945     /**
6946      * @dev to get the status of recently holded coverID 
6947      * @param userAdd is the user address in concern
6948      * @return the status of the concerned coverId
6949      */
6950     function getRecentHoldedCoverIdStatus(address userAdd) public view returns(int) {
6951 
6952         uint holdedCoverLen = qd.getUserHoldedCoverLength(userAdd);
6953         if (holdedCoverLen == 0) {
6954             return -1;
6955         } else {
6956             uint holdedCoverID = qd.getUserHoldedCoverByIndex(userAdd, holdedCoverLen.sub(1));
6957             return int(qd.holdedCoverIDStatus(holdedCoverID));
6958         }
6959     }
6960     
6961     /**
6962      * @dev to initiate the membership and the cover 
6963      * @param smartCAdd is the smart contract address to make cover on
6964      * @param coverCurr is the currency used to make cover
6965      * @param coverDetails list of details related to cover like cover amount, expire time, coverCurrPrice and priceNXM
6966      * @param coverPeriod is cover period for which cover is being bought
6967      * @param _v argument from vrs hash 
6968      * @param _r argument from vrs hash 
6969      * @param _s argument from vrs hash 
6970      */
6971     function initiateMembershipAndCover(
6972         address smartCAdd,
6973         bytes4 coverCurr,
6974         uint[] memory coverDetails,
6975         uint16 coverPeriod,
6976         uint8 _v,
6977         bytes32 _r,
6978         bytes32 _s
6979     ) 
6980         public
6981         payable
6982         checkPause
6983     {
6984         require(coverDetails[3] > now);
6985         require(!qd.timestampRepeated(coverDetails[4]));
6986         qd.setTimestampRepeated(coverDetails[4]);
6987         require(!ms.isMember(msg.sender));
6988         require(qd.refundEligible(msg.sender) == false);
6989         uint joinFee = td.joiningFee();
6990         uint totalFee = joinFee;
6991         if (coverCurr == "ETH") {
6992             totalFee = joinFee.add(coverDetails[1]);
6993         } else {
6994             IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
6995             require(erc20.transferFrom(msg.sender, address(this), coverDetails[1]));
6996         }
6997         require(msg.value == totalFee);
6998         require(verifySign(coverDetails, coverPeriod, coverCurr, smartCAdd, _v, _r, _s));
6999         qd.addHoldCover(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod);
7000         qd.setRefundEligible(msg.sender, true);
7001     }
7002 
7003     /**
7004      * @dev to get the verdict of kyc process 
7005      * @param status is the kyc status
7006      * @param _add is the address of member
7007      */
7008     function kycVerdict(address _add, bool status) public checkPause noReentrancy {
7009         require(msg.sender == qd.kycAuthAddress());
7010         _kycTrigger(status, _add);
7011     }
7012 
7013     /**
7014      * @dev transfering Ethers to newly created quotation contract.
7015      */  
7016     function transferAssetsToNewContract(address newAdd) public onlyInternal noReentrancy {
7017         uint amount = address(this).balance;
7018         IERC20 erc20;
7019         if (amount > 0) {
7020             // newAdd.transfer(amount);   
7021             Quotation newQT = Quotation(newAdd);
7022             newQT.sendEther.value(amount)();
7023         }
7024         uint currAssetLen = pd.getAllCurrenciesLen();
7025         for (uint64 i = 1; i < currAssetLen; i++) {
7026             bytes4 currName = pd.getCurrenciesByIndex(i);
7027             address currAddr = pd.getCurrencyAssetAddress(currName);
7028             erc20 = IERC20(currAddr); //solhint-disable-line
7029             if (erc20.balanceOf(address(this)) > 0) {
7030                 require(erc20.transfer(newAdd, erc20.balanceOf(address(this))));
7031             }
7032         }
7033     }
7034 
7035 
7036     /**
7037      * @dev Creates cover of the quotation, changes the status of the quotation ,
7038      * updates the total sum assured and locks the tokens of the cover against a quote.
7039      * @param from Quote member Ethereum address.
7040      */  
7041 
7042     function _makeCover ( //solhint-disable-line
7043         address payable from,
7044         address scAddress,
7045         bytes4 coverCurr,
7046         uint[] memory coverDetails,
7047         uint16 coverPeriod
7048     )
7049         internal
7050     {
7051         uint cid = qd.getCoverLength();
7052         qd.addCover(coverPeriod, coverDetails[0],
7053             from, coverCurr, scAddress, coverDetails[1], coverDetails[2]);
7054         // if cover period of quote is less than 60 days.
7055         if (coverPeriod <= 60) {
7056             p1.closeCoverOraclise(cid, uint64(uint(coverPeriod).mul(1 days)));
7057         }
7058         uint coverNoteAmount = (coverDetails[2].mul(qd.tokensRetained())).div(100);
7059         tc.mint(from, coverNoteAmount);
7060         tf.lockCN(coverNoteAmount, coverPeriod, cid, from);
7061         qd.addInTotalSumAssured(coverCurr, coverDetails[0]);
7062         qd.addInTotalSumAssuredSC(scAddress, coverCurr, coverDetails[0]);
7063 
7064 
7065         tf.pushStakerRewards(scAddress, coverDetails[2]);
7066     }
7067 
7068     /**
7069      * @dev Makes a vover.
7070      * @param from address of funder.
7071      * @param scAddress Smart Contract Address
7072      */  
7073     function _verifyCoverDetails(
7074         address payable from,
7075         address scAddress,
7076         bytes4 coverCurr,
7077         uint[] memory coverDetails,
7078         uint16 coverPeriod,
7079         uint8 _v,
7080         bytes32 _r,
7081         bytes32 _s
7082     )
7083         internal
7084     {
7085         require(coverDetails[3] > now);
7086         require(!qd.timestampRepeated(coverDetails[4]));
7087         qd.setTimestampRepeated(coverDetails[4]);
7088         require(verifySign(coverDetails, coverPeriod, coverCurr, scAddress, _v, _r, _s));
7089         _makeCover(from, scAddress, coverCurr, coverDetails, coverPeriod);
7090 
7091     }
7092 
7093     /**
7094      * @dev Updates the Sum Assured Amount of all the quotation.
7095      * @param _cid Cover id
7096      * @param _amount that will get subtracted Current Sum Assured 
7097      * amount that comes under a quotation.
7098      */ 
7099     function _removeSAFromCSA(uint _cid, uint _amount) internal checkPause {
7100         address _add;
7101         bytes4 coverCurr;
7102         (, , _add, coverCurr, , ) = qd.getCoverDetailsByCoverID1(_cid);
7103         qd.subFromTotalSumAssured(coverCurr, _amount);        
7104         qd.subFromTotalSumAssuredSC(_add, coverCurr, _amount);
7105     }
7106 
7107     /**
7108      * @dev to trigger the kyc process 
7109      * @param status is the kyc status
7110      * @param _add is the address of member
7111      */
7112     function _kycTrigger(bool status, address _add) internal {
7113 
7114         uint holdedCoverLen = qd.getUserHoldedCoverLength(_add).sub(1);
7115         uint holdedCoverID = qd.getUserHoldedCoverByIndex(_add, holdedCoverLen);
7116         address payable userAdd;
7117         address scAddress;
7118         bytes4 coverCurr;
7119         uint16 coverPeriod;
7120         uint[]  memory coverDetails = new uint[](4);
7121         IERC20 erc20;
7122 
7123         (, userAdd, coverDetails) = qd.getHoldedCoverDetailsByID2(holdedCoverID);
7124         (, scAddress, coverCurr, coverPeriod) = qd.getHoldedCoverDetailsByID1(holdedCoverID);
7125         require(qd.refundEligible(userAdd));
7126         qd.setRefundEligible(userAdd, false);
7127         require(qd.holdedCoverIDStatus(holdedCoverID) == uint(QuotationData.HCIDStatus.kycPending));
7128         uint joinFee = td.joiningFee();
7129         if (status) {
7130             mr.payJoiningFee.value(joinFee)(userAdd);
7131             if (coverDetails[3] > now) { 
7132                 qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycPass));
7133                 address poolAdd = ms.getLatestAddress("P1");
7134                 if (coverCurr == "ETH") {
7135                     p1.sendEther.value(coverDetails[1])();
7136                 } else {
7137                     erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
7138                     require(erc20.transfer(poolAdd, coverDetails[1]));
7139                 }
7140                 emit RefundEvent(userAdd, status, holdedCoverID, "KYC Passed");               
7141                 _makeCover(userAdd, scAddress, coverCurr, coverDetails, coverPeriod);
7142 
7143             } else {
7144                 qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycPassNoCover));
7145                 if (coverCurr == "ETH") {
7146                     userAdd.transfer(coverDetails[1]);
7147                 } else {
7148                     erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
7149                     require(erc20.transfer(userAdd, coverDetails[1]));
7150                 }
7151                 emit RefundEvent(userAdd, status, holdedCoverID, "Cover Failed");
7152             }
7153         } else {
7154             qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycFailedOrRefunded));
7155             uint totalRefund = joinFee;
7156             if (coverCurr == "ETH") {
7157                 totalRefund = coverDetails[1].add(joinFee);
7158             } else {
7159                 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
7160                 require(erc20.transfer(userAdd, coverDetails[1]));
7161             }
7162             userAdd.transfer(totalRefund);
7163             emit RefundEvent(userAdd, status, holdedCoverID, "KYC Failed");
7164         }
7165               
7166     }
7167 }
7168 
7169 contract Factory {
7170     function getExchange(address token) public view returns (address);
7171     function getToken(address exchange) public view returns (address);
7172 }
7173 
7174 contract Exchange { 
7175     function getEthToTokenInputPrice(uint256 ethSold) public view returns(uint256);
7176 
7177     function getTokenToEthInputPrice(uint256 tokensSold) public view returns(uint256);
7178 
7179     function ethToTokenSwapInput(uint256 minTokens, uint256 deadline) public payable returns (uint256);
7180 
7181     function ethToTokenTransferInput(uint256 minTokens, uint256 deadline, address recipient)
7182         public payable returns (uint256);
7183 
7184     function tokenToEthSwapInput(uint256 tokensSold, uint256 minEth, uint256 deadline)
7185         public payable returns (uint256);
7186 
7187     function tokenToEthTransferInput(uint256 tokensSold, uint256 minEth, uint256 deadline, address recipient) 
7188         public payable returns (uint256);
7189 
7190     function tokenToTokenSwapInput(
7191         uint256 tokensSold,
7192         uint256 minTokensBought,
7193         uint256 minEthBought,
7194         uint256 deadline,
7195         address tokenAddress
7196     ) 
7197         public returns (uint256);
7198 
7199     function tokenToTokenTransferInput(
7200         uint256 tokensSold,
7201         uint256 minTokensBought,
7202         uint256 minEthBought,
7203         uint256 deadline,
7204         address recipient,
7205         address tokenAddress
7206     )
7207         public returns (uint256);
7208 }
7209 
7210 /* Copyright (C) 2017 NexusMutual.io
7211 
7212   This program is free software: you can redistribute it and/or modify
7213     it under the terms of the GNU General Public License as published by
7214     the Free Software Foundation, either version 3 of the License, or
7215     (at your option) any later version.
7216 
7217   This program is distributed in the hope that it will be useful,
7218     but WITHOUT ANY WARRANTY; without even the implied warranty of
7219     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
7220     GNU General Public License for more details.
7221 
7222   You should have received a copy of the GNU General Public License
7223     along with this program.  If not, see http://www.gnu.org/licenses/ */
7224 contract Pool2 is Iupgradable {
7225     using SafeMath for uint;
7226 
7227     MCR internal m1;
7228     Pool1 internal p1;
7229     PoolData internal pd;
7230     Factory internal factory;
7231     address public uniswapFactoryAddress;
7232     uint internal constant DECIMAL1E18 = uint(10) ** 18;
7233     bool internal locked;
7234 
7235     constructor(address _uniswapFactoryAdd) public {
7236        
7237         uniswapFactoryAddress = _uniswapFactoryAdd;
7238         factory = Factory(_uniswapFactoryAdd);
7239     }
7240 
7241     function() external payable {}
7242 
7243     event Liquidity(bytes16 typeOf, bytes16 functionName);
7244 
7245     event Rebalancing(bytes4 iaCurr, uint tokenAmount);
7246 
7247     modifier noReentrancy() {
7248         require(!locked, "Reentrant call.");
7249         locked = true;
7250         _;
7251         locked = false;
7252     }
7253 
7254     /**
7255      * @dev to change the uniswap factory address 
7256      * @param newFactoryAddress is the new factory address in concern
7257      * @return the status of the concerned coverId
7258      */
7259     function changeUniswapFactoryAddress(address newFactoryAddress) external onlyInternal {
7260         // require(ms.isOwner(msg.sender) || ms.checkIsAuthToGoverned(msg.sender));
7261         uniswapFactoryAddress = newFactoryAddress;
7262         factory = Factory(uniswapFactoryAddress);
7263     }
7264 
7265     /**
7266      * @dev On upgrade transfer all investment assets and ether to new Investment Pool
7267      * @param newPoolAddress New Investment Assest Pool address
7268      */
7269     function upgradeInvestmentPool(address payable newPoolAddress) external onlyInternal noReentrancy {
7270         uint len = pd.getInvestmentCurrencyLen();
7271         for (uint64 i = 1; i < len; i++) {
7272             bytes4 iaName = pd.getInvestmentCurrencyByIndex(i);
7273             _upgradeInvestmentPool(iaName, newPoolAddress);
7274         }
7275 
7276         if (address(this).balance > 0) {
7277             Pool2 newP2 = Pool2(newPoolAddress);
7278             newP2.sendEther.value(address(this).balance)();
7279         }
7280     }
7281 
7282     /**
7283      * @dev Internal Swap of assets between Capital 
7284      * and Investment Sub pool for excess or insufficient  
7285      * liquidity conditions of a given currency.
7286      */ 
7287     function internalLiquiditySwap(bytes4 curr) external onlyInternal noReentrancy {
7288         uint caBalance;
7289         uint baseMin;
7290         uint varMin;
7291         (, baseMin, varMin) = pd.getCurrencyAssetVarBase(curr);
7292         caBalance = _getCurrencyAssetsBalance(curr);
7293 
7294         if (caBalance > uint(baseMin).add(varMin).mul(2)) {
7295             _internalExcessLiquiditySwap(curr, baseMin, varMin, caBalance);
7296         } else if (caBalance < uint(baseMin).add(varMin)) {
7297             _internalInsufficientLiquiditySwap(curr, baseMin, varMin, caBalance);
7298             
7299         }
7300     }
7301 
7302     /**
7303      * @dev Saves a given investment asset details. To be called daily.
7304      * @param curr array of Investment asset name.
7305      * @param rate array of investment asset exchange rate.
7306      * @param date current date in yyyymmdd.
7307      */ 
7308     function saveIADetails(bytes4[] calldata curr, uint64[] calldata rate, uint64 date, bool bit) 
7309     external checkPause noReentrancy {
7310         bytes4 maxCurr;
7311         bytes4 minCurr;
7312         uint64 maxRate;
7313         uint64 minRate;
7314         //ONLY NOTARZIE ADDRESS CAN POST
7315         require(pd.isnotarise(msg.sender));
7316         (maxCurr, maxRate, minCurr, minRate) = _calculateIARank(curr, rate);
7317         pd.saveIARankDetails(maxCurr, maxRate, minCurr, minRate, date);
7318         pd.updatelastDate(date);
7319         uint len = curr.length;
7320         for (uint i = 0; i < len; i++) {
7321             pd.updateIAAvgRate(curr[i], rate[i]);
7322         }
7323         if (bit)   //for testing purpose
7324             _rebalancingLiquidityTrading(maxCurr, maxRate);
7325         p1.saveIADetailsOracalise(pd.iaRatesTime());
7326     }
7327 
7328     /**
7329      * @dev External Trade for excess or insufficient  
7330      * liquidity conditions of a given currency.
7331      */ 
7332     function externalLiquidityTrade() external onlyInternal {
7333         
7334         bool triggerTrade;
7335         bytes4 curr;
7336         bytes4 minIACurr;
7337         bytes4 maxIACurr;
7338         uint amount;
7339         uint minIARate;
7340         uint maxIARate;
7341         uint baseMin;
7342         uint varMin;
7343         uint caBalance;
7344 
7345 
7346         (maxIACurr, maxIARate, minIACurr, minIARate) = pd.getIARankDetailsByDate(pd.getLastDate());
7347         uint len = pd.getAllCurrenciesLen();
7348         for (uint64 i = 0; i < len; i++) {
7349             curr = pd.getCurrenciesByIndex(i);
7350             (, baseMin, varMin) = pd.getCurrencyAssetVarBase(curr);
7351             caBalance = _getCurrencyAssetsBalance(curr);
7352 
7353             if (caBalance > uint(baseMin).add(varMin).mul(2)) { //excess
7354                 amount = caBalance.sub(((uint(baseMin).add(varMin)).mul(3)).div(2)); //*10**18;
7355                 triggerTrade = _externalExcessLiquiditySwap(curr, minIACurr, amount);
7356             } else if (caBalance < uint(baseMin).add(varMin)) { // insufficient
7357                 amount = (((uint(baseMin).add(varMin)).mul(3)).div(2)).sub(caBalance);
7358                 triggerTrade = _externalInsufficientLiquiditySwap(curr, maxIACurr, amount);
7359             }
7360 
7361             if (triggerTrade) {
7362                 p1.triggerExternalLiquidityTrade();
7363             }
7364         }
7365     }
7366 
7367     /**
7368      * Iupgradable Interface to update dependent contract address
7369      */
7370     function changeDependentContractAddress() public onlyInternal {
7371         m1 = MCR(ms.getLatestAddress("MC"));
7372         pd = PoolData(ms.getLatestAddress("PD"));
7373         p1 = Pool1(ms.getLatestAddress("P1"));
7374     }
7375 
7376     function sendEther() public payable {
7377         
7378     }
7379 
7380     /** 
7381      * @dev Gets currency asset balance for a given currency name.
7382      */   
7383     function _getCurrencyAssetsBalance(bytes4 _curr) public view returns(uint caBalance) {
7384         if (_curr == "ETH") {
7385             caBalance = address(p1).balance;
7386         } else {
7387             IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr));
7388             caBalance = erc20.balanceOf(address(p1));
7389         }
7390     }
7391 
7392     /** 
7393      * @dev Transfers ERC20 investment asset from this Pool to another Pool.
7394      */ 
7395     function _transferInvestmentAsset(
7396         bytes4 _curr,
7397         address _transferTo,
7398         uint _amount
7399     ) 
7400         internal
7401     {
7402         if (_curr == "ETH") {
7403             if (_amount > address(this).balance)
7404                 _amount = address(this).balance;
7405             p1.sendEther.value(_amount)();
7406         } else {
7407             IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
7408             if (_amount > erc20.balanceOf(address(this)))
7409                 _amount = erc20.balanceOf(address(this));
7410             require(erc20.transfer(_transferTo, _amount));
7411         }
7412     }
7413 
7414     /**
7415      * @dev to perform rebalancing 
7416      * @param iaCurr is the investment asset currency
7417      * @param iaRate is the investment asset rate
7418      */
7419     function _rebalancingLiquidityTrading(
7420         bytes4 iaCurr,
7421         uint64 iaRate
7422     ) 
7423         internal
7424         checkPause
7425     {
7426         uint amountToSell;
7427         uint totalRiskBal = pd.getLastVfull();
7428         uint intermediaryEth;
7429         uint ethVol = pd.ethVolumeLimit();
7430 
7431         totalRiskBal = (totalRiskBal.mul(100000)).div(DECIMAL1E18);
7432         Exchange exchange;
7433         if (totalRiskBal > 0) {
7434             amountToSell = ((totalRiskBal.mul(2).mul(
7435                 iaRate)).mul(pd.variationPercX100())).div(100 * 100 * 100000);
7436             amountToSell = (amountToSell.mul(
7437                 10**uint(pd.getInvestmentAssetDecimals(iaCurr)))).div(100); // amount of asset to sell
7438 
7439             if (iaCurr != "ETH" && _checkTradeConditions(iaCurr, iaRate, totalRiskBal)) { 
7440                 exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(iaCurr)));
7441                 intermediaryEth = exchange.getTokenToEthInputPrice(amountToSell);
7442                 if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
7443                     intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
7444                     amountToSell = (exchange.getEthToTokenInputPrice(intermediaryEth).mul(995)).div(1000);
7445                 }
7446                 IERC20 erc20;
7447                 erc20 = IERC20(pd.getCurrencyAssetAddress(iaCurr));
7448                 erc20.approve(address(exchange), amountToSell);
7449                 exchange.tokenToEthSwapInput(amountToSell, (exchange.getTokenToEthInputPrice(
7450                     amountToSell).mul(995)).div(1000), pd.uniswapDeadline().add(now));
7451             } else if (iaCurr == "ETH" && _checkTradeConditions(iaCurr, iaRate, totalRiskBal)) {
7452 
7453                 _transferInvestmentAsset(iaCurr, ms.getLatestAddress("P1"), amountToSell);
7454             }
7455             emit Rebalancing(iaCurr, amountToSell); 
7456         }
7457     }
7458 
7459     /**
7460      * @dev Checks whether trading is required for a  
7461      * given investment asset at a given exchange rate.
7462      */ 
7463     function _checkTradeConditions(
7464         bytes4 curr,
7465         uint64 iaRate,
7466         uint totalRiskBal
7467     )
7468         internal
7469         view
7470         returns(bool check)
7471     {
7472         if (iaRate > 0) {
7473             uint iaBalance =  _getInvestmentAssetBalance(curr).div(DECIMAL1E18);
7474             if (iaBalance > 0 && totalRiskBal > 0) {
7475                 uint iaMax;
7476                 uint iaMin;
7477                 uint checkNumber;
7478                 uint z;
7479                 (iaMin, iaMax) = pd.getInvestmentAssetHoldingPerc(curr);
7480                 z = pd.variationPercX100();
7481                 checkNumber = (iaBalance.mul(100 * 100000)).div(totalRiskBal.mul(iaRate));
7482                 if ((checkNumber > ((totalRiskBal.mul(iaMax.add(z))).mul(100000)).div(100)) ||
7483                     (checkNumber < ((totalRiskBal.mul(iaMin.sub(z))).mul(100000)).div(100)))
7484                     check = true; //eligibleIA
7485             }
7486         }
7487     }    
7488 
7489     /** 
7490      * @dev Gets the investment asset rank.
7491      */ 
7492     function _getIARank(
7493         bytes4 curr,
7494         uint64 rateX100,
7495         uint totalRiskPoolBalance
7496     ) 
7497         internal
7498         view
7499         returns (int rhsh, int rhsl) //internal function
7500     {
7501 
7502         uint currentIAmaxHolding;
7503         uint currentIAminHolding;
7504         uint iaBalance = _getInvestmentAssetBalance(curr);
7505         (currentIAminHolding, currentIAmaxHolding) = pd.getInvestmentAssetHoldingPerc(curr);
7506         
7507         if (rateX100 > 0) {
7508             uint rhsf;
7509             rhsf = (iaBalance.mul(1000000)).div(totalRiskPoolBalance.mul(rateX100));
7510             rhsh = int(rhsf - currentIAmaxHolding);
7511             rhsl = int(rhsf - currentIAminHolding);
7512         }
7513     }
7514 
7515     /** 
7516      * @dev Calculates the investment asset rank.
7517      */  
7518     function _calculateIARank(
7519         bytes4[] memory curr,
7520         uint64[] memory rate
7521     )
7522         internal
7523         view
7524         returns(
7525             bytes4 maxCurr,
7526             uint64 maxRate,
7527             bytes4 minCurr,
7528             uint64 minRate
7529         )  
7530     {
7531         int max = 0;
7532         int min = -1;
7533         int rhsh;
7534         int rhsl;
7535         uint totalRiskPoolBalance;
7536         (totalRiskPoolBalance, ) = m1.calVtpAndMCRtp();
7537         uint len = curr.length;
7538         for (uint i = 0; i < len; i++) {
7539             rhsl = 0;
7540             rhsh = 0;
7541             if (pd.getInvestmentAssetStatus(curr[i])) {
7542                 (rhsh, rhsl) = _getIARank(curr[i], rate[i], totalRiskPoolBalance);
7543                 if (rhsh > max || i == 0) {
7544                     max = rhsh;
7545                     maxCurr = curr[i];
7546                     maxRate = rate[i];
7547                 }
7548                 if (rhsl < min || rhsl == 0 || i == 0) {
7549                     min = rhsl;
7550                     minCurr = curr[i];
7551                     minRate = rate[i];
7552                 }
7553             }
7554         }
7555     }
7556 
7557     /**
7558      * @dev to get balance of an investment asset 
7559      * @param _curr is the investment asset in concern
7560      * @return the balance
7561      */
7562     function _getInvestmentAssetBalance(bytes4 _curr) internal view returns (uint balance) {
7563         if (_curr == "ETH") {
7564             balance = address(this).balance;
7565         } else {
7566             IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
7567             balance = erc20.balanceOf(address(this));
7568         }
7569     }
7570 
7571     /**
7572      * @dev Creates Excess liquidity trading order for a given currency and a given balance.
7573      */  
7574     function _internalExcessLiquiditySwap(bytes4 _curr, uint _baseMin, uint _varMin, uint _caBalance) internal {
7575         // require(ms.isInternal(msg.sender) || md.isnotarise(msg.sender));
7576         bytes4 minIACurr;
7577         // uint amount;
7578         
7579         (, , minIACurr, ) = pd.getIARankDetailsByDate(pd.getLastDate());
7580         if (_curr == minIACurr) {
7581             // amount = _caBalance.sub(((_baseMin.add(_varMin)).mul(3)).div(2)); //*10**18;
7582             p1.transferCurrencyAsset(_curr, _caBalance.sub(((_baseMin.add(_varMin)).mul(3)).div(2)));
7583         } else {
7584             p1.triggerExternalLiquidityTrade();
7585         }
7586     }
7587 
7588     /** 
7589      * @dev insufficient liquidity swap  
7590      * for a given currency and a given balance.
7591      */ 
7592     function _internalInsufficientLiquiditySwap(bytes4 _curr, uint _baseMin, uint _varMin, uint _caBalance) internal {
7593         
7594         bytes4 maxIACurr;
7595         uint amount;
7596         
7597         (maxIACurr, , , ) = pd.getIARankDetailsByDate(pd.getLastDate());
7598         
7599         if (_curr == maxIACurr) {
7600             amount = (((_baseMin.add(_varMin)).mul(3)).div(2)).sub(_caBalance);
7601             _transferInvestmentAsset(_curr, ms.getLatestAddress("P1"), amount);
7602         } else {
7603             IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(maxIACurr));
7604             if ((maxIACurr == "ETH" && address(this).balance > 0) || 
7605             (maxIACurr != "ETH" && erc20.balanceOf(address(this)) > 0))
7606                 p1.triggerExternalLiquidityTrade();
7607             
7608         }
7609     }
7610 
7611     /**
7612      * @dev Creates External excess liquidity trading  
7613      * order for a given currency and a given balance.
7614      * @param curr Currency Asset to Sell
7615      * @param minIACurr Investment Asset to Buy  
7616      * @param amount Amount of Currency Asset to Sell
7617      */  
7618     function _externalExcessLiquiditySwap(
7619         bytes4 curr,
7620         bytes4 minIACurr,
7621         uint256 amount
7622     )
7623         internal
7624         returns (bool trigger)
7625     {
7626         uint intermediaryEth;
7627         Exchange exchange;
7628         IERC20 erc20;
7629         uint ethVol = pd.ethVolumeLimit();
7630         if (curr == minIACurr) {
7631             p1.transferCurrencyAsset(curr, amount);
7632         } else if (curr == "ETH" && minIACurr != "ETH") {
7633             
7634             exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(minIACurr)));
7635             if (amount > (address(exchange).balance.mul(ethVol)).div(100)) { // 4% ETH volume limit 
7636                 amount = (address(exchange).balance.mul(ethVol)).div(100);
7637                 trigger = true;
7638             }
7639             p1.transferCurrencyAsset(curr, amount);
7640             exchange.ethToTokenSwapInput.value(amount)
7641             (exchange.getEthToTokenInputPrice(amount).mul(995).div(1000), pd.uniswapDeadline().add(now));    
7642         } else if (curr != "ETH" && minIACurr == "ETH") {
7643             exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7644             erc20 = IERC20(pd.getCurrencyAssetAddress(curr));
7645             intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7646 
7647             if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
7648                 intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
7649                 amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7650                 intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7651                 trigger = true;
7652             }
7653             p1.transferCurrencyAsset(curr, amount);
7654             // erc20.decreaseAllowance(address(exchange), erc20.allowance(address(this), address(exchange)));
7655             erc20.approve(address(exchange), amount);
7656             
7657             exchange.tokenToEthSwapInput(amount, (
7658                 intermediaryEth.mul(995)).div(1000), pd.uniswapDeadline().add(now));   
7659         } else {
7660             
7661             exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7662             intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7663 
7664             if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
7665                 intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
7666                 amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7667                 trigger = true;
7668             }
7669             
7670             Exchange tmp = Exchange(factory.getExchange(
7671                 pd.getInvestmentAssetAddress(minIACurr))); // minIACurr exchange
7672 
7673             if (intermediaryEth > address(tmp).balance.mul(ethVol).div(100)) { 
7674                 intermediaryEth = address(tmp).balance.mul(ethVol).div(100);
7675                 amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7676                 trigger = true;   
7677             }
7678             p1.transferCurrencyAsset(curr, amount);
7679             erc20 = IERC20(pd.getCurrencyAssetAddress(curr));
7680             erc20.approve(address(exchange), amount);
7681             
7682             exchange.tokenToTokenSwapInput(amount, (tmp.getEthToTokenInputPrice(
7683                 intermediaryEth).mul(995)).div(1000), (intermediaryEth.mul(995)).div(1000), 
7684                     pd.uniswapDeadline().add(now), pd.getInvestmentAssetAddress(minIACurr));
7685         }
7686     }
7687 
7688     /** 
7689      * @dev insufficient liquidity swap  
7690      * for a given currency and a given balance.
7691      * @param curr Currency Asset to buy
7692      * @param maxIACurr Investment Asset to sell
7693      * @param amount Amount of Investment Asset to sell
7694      */ 
7695     function _externalInsufficientLiquiditySwap(
7696         bytes4 curr,
7697         bytes4 maxIACurr,
7698         uint256 amount
7699     ) 
7700         internal
7701         returns (bool trigger)
7702     {   
7703 
7704         Exchange exchange;
7705         IERC20 erc20;
7706         uint intermediaryEth;
7707         // uint ethVol = pd.ethVolumeLimit();
7708         if (curr == maxIACurr) {
7709             _transferInvestmentAsset(curr, ms.getLatestAddress("P1"), amount);
7710         } else if (curr == "ETH" && maxIACurr != "ETH") { 
7711             exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(maxIACurr)));
7712             intermediaryEth = exchange.getEthToTokenInputPrice(amount);
7713 
7714 
7715             if (amount > (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100)) { 
7716                 amount = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7717                 // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7718                 intermediaryEth = exchange.getEthToTokenInputPrice(amount);
7719                 trigger = true;
7720             }
7721             
7722             erc20 = IERC20(pd.getCurrencyAssetAddress(maxIACurr));
7723             if (intermediaryEth > erc20.balanceOf(address(this))) {
7724                 intermediaryEth = erc20.balanceOf(address(this));
7725             }
7726             // erc20.decreaseAllowance(address(exchange), erc20.allowance(address(this), address(exchange)));
7727             erc20.approve(address(exchange), intermediaryEth);
7728             exchange.tokenToEthTransferInput(intermediaryEth, (
7729                 exchange.getTokenToEthInputPrice(intermediaryEth).mul(995)).div(1000), 
7730                 pd.uniswapDeadline().add(now), address(p1)); 
7731 
7732         } else if (curr != "ETH" && maxIACurr == "ETH") {
7733             exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
7734             intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7735             if (intermediaryEth > address(this).balance)
7736                 intermediaryEth = address(this).balance;
7737             if (intermediaryEth > (address(exchange).balance.mul
7738             (pd.ethVolumeLimit())).div(100)) { // 4% ETH volume limit 
7739                 intermediaryEth = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7740                 trigger = true;
7741             }
7742             exchange.ethToTokenTransferInput.value(intermediaryEth)((exchange.getEthToTokenInputPrice(
7743                 intermediaryEth).mul(995)).div(1000), pd.uniswapDeadline().add(now), address(p1));   
7744         } else {
7745             address currAdd = pd.getCurrencyAssetAddress(curr);
7746             exchange = Exchange(factory.getExchange(currAdd));
7747             intermediaryEth = exchange.getTokenToEthInputPrice(amount);
7748             if (intermediaryEth > (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100)) { 
7749                 intermediaryEth = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
7750                 trigger = true;
7751             }
7752             Exchange tmp = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(maxIACurr)));
7753 
7754             if (intermediaryEth > address(tmp).balance.mul(pd.ethVolumeLimit()).div(100)) { 
7755                 intermediaryEth = address(tmp).balance.mul(pd.ethVolumeLimit()).div(100);
7756                 // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7757                 trigger = true;
7758             }
7759 
7760             uint maxIAToSell = tmp.getEthToTokenInputPrice(intermediaryEth);
7761 
7762             erc20 = IERC20(pd.getInvestmentAssetAddress(maxIACurr));
7763             uint maxIABal = erc20.balanceOf(address(this));
7764             if (maxIAToSell > maxIABal) {
7765                 maxIAToSell = maxIABal;
7766                 intermediaryEth = tmp.getTokenToEthInputPrice(maxIAToSell);
7767                 // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7768             }
7769             amount = exchange.getEthToTokenInputPrice(intermediaryEth);
7770             erc20.approve(address(tmp), maxIAToSell);
7771             tmp.tokenToTokenTransferInput(maxIAToSell, (
7772                 amount.mul(995)).div(1000), (
7773                     intermediaryEth), pd.uniswapDeadline().add(now), address(p1), currAdd);
7774         }
7775     }
7776 
7777     /** 
7778      * @dev Transfers ERC20 investment asset from this Pool to another Pool.
7779      */ 
7780     function _upgradeInvestmentPool(
7781         bytes4 _curr,
7782         address _newPoolAddress
7783     ) 
7784         internal
7785     {
7786         IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
7787         if (erc20.balanceOf(address(this)) > 0)
7788             require(erc20.transfer(_newPoolAddress, erc20.balanceOf(address(this))));
7789     }
7790 }
7791 
7792 /* Copyright (C) 2017 NexusMutual.io
7793 
7794   This program is free software: you can redistribute it and/or modify
7795     it under the terms of the GNU General Public License as published by
7796     the Free Software Foundation, either version 3 of the License, or
7797     (at your option) any later version.
7798 
7799   This program is distributed in the hope that it will be useful,
7800     but WITHOUT ANY WARRANTY; without even the implied warranty of
7801     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
7802     GNU General Public License for more details.
7803 
7804   You should have received a copy of the GNU General Public License
7805     along with this program.  If not, see http://www.gnu.org/licenses/ */
7806 contract Pool1 is usingOraclize, Iupgradable {
7807     using SafeMath for uint;
7808 
7809     Quotation internal q2;
7810     NXMToken internal tk;
7811     TokenController internal tc;
7812     TokenFunctions internal tf;
7813     Pool2 internal p2;
7814     PoolData internal pd;
7815     MCR internal m1;
7816     Claims public c1;
7817     TokenData internal td;
7818     bool internal locked;
7819 
7820     uint internal constant DECIMAL1E18 = uint(10) ** 18;
7821     // uint internal constant PRICE_STEP = uint(1000) * DECIMAL1E18;
7822 
7823     event Apiresult(address indexed sender, string msg, bytes32 myid);
7824     event Payout(address indexed to, uint coverId, uint tokens);
7825 
7826     modifier noReentrancy() {
7827         require(!locked, "Reentrant call.");
7828         locked = true;
7829         _;
7830         locked = false;
7831     }
7832 
7833     function () external payable {} //solhint-disable-line
7834 
7835     /**
7836      * @dev Pays out the sum assured in case a claim is accepted
7837      * @param coverid Cover Id.
7838      * @param claimid Claim Id.
7839      * @return succ true if payout is successful, false otherwise. 
7840      */ 
7841     function sendClaimPayout(
7842         uint coverid,
7843         uint claimid,
7844         uint sumAssured,
7845         address payable coverHolder,
7846         bytes4 coverCurr
7847     )
7848         external
7849         onlyInternal
7850         noReentrancy
7851         returns(bool succ)
7852     {
7853         
7854         uint sa = sumAssured.div(DECIMAL1E18);
7855         bool check;
7856         IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
7857 
7858         //Payout
7859         if (coverCurr == "ETH" && address(this).balance >= sumAssured) {
7860             // check = _transferCurrencyAsset(coverCurr, coverHolder, sumAssured);
7861             coverHolder.transfer(sumAssured);
7862             check = true;
7863         } else if (coverCurr == "DAI" && erc20.balanceOf(address(this)) >= sumAssured) {
7864             erc20.transfer(coverHolder, sumAssured);
7865             check = true;
7866         }
7867         
7868         if (check == true) {
7869             q2.removeSAFromCSA(coverid, sa);
7870             pd.changeCurrencyAssetVarMin(coverCurr, 
7871                 pd.getCurrencyAssetVarMin(coverCurr).sub(sumAssured));
7872             emit Payout(coverHolder, coverid, sumAssured);
7873             succ = true;
7874         } else {
7875             c1.setClaimStatus(claimid, 12);
7876         }
7877         _triggerExternalLiquidityTrade();
7878         // p2.internalLiquiditySwap(coverCurr);
7879 
7880         tf.burnStakerLockedToken(coverid, coverCurr, sumAssured);
7881     }
7882 
7883     /**
7884      * @dev to trigger external liquidity trade
7885      */
7886     function triggerExternalLiquidityTrade() external onlyInternal {
7887         _triggerExternalLiquidityTrade();
7888     }
7889 
7890     ///@dev Oraclize call to close emergency pause.
7891     function closeEmergencyPause(uint time) external onlyInternal {
7892         bytes32 myid = _oraclizeQuery(4, time, "URL", "", 300000);
7893         _saveApiDetails(myid, "EP", 0);
7894     }
7895 
7896     /// @dev Calls the Oraclize Query to close a given Claim after a given period of time.
7897     /// @param id Claim Id to be closed
7898     /// @param time Time (in seconds) after which Claims assessment voting needs to be closed
7899     function closeClaimsOraclise(uint id, uint time) external onlyInternal {
7900         bytes32 myid = _oraclizeQuery(4, time, "URL", "", 3000000);
7901         _saveApiDetails(myid, "CLA", id);
7902     }
7903 
7904     /// @dev Calls Oraclize Query to expire a given Cover after a given period of time.
7905     /// @param id Quote Id to be expired
7906     /// @param time Time (in seconds) after which the cover should be expired
7907     function closeCoverOraclise(uint id, uint64 time) external onlyInternal {
7908         bytes32 myid = _oraclizeQuery(4, time, "URL", strConcat(
7909             "http://a1.nexusmutual.io/api/Claims/closeClaim_hash/", uint2str(id)), 1000000);
7910         _saveApiDetails(myid, "COV", id);
7911     }
7912 
7913     /// @dev Calls the Oraclize Query to initiate MCR calculation.
7914     /// @param time Time (in milliseconds) after which the next MCR calculation should be initiated
7915     function mcrOraclise(uint time) external onlyInternal {
7916         bytes32 myid = _oraclizeQuery(3, time, "URL", "https://api.nexusmutual.io/postMCR/M1", 0);
7917         _saveApiDetails(myid, "MCR", 0);
7918     }
7919 
7920     /// @dev Calls the Oraclize Query in case MCR calculation fails.
7921     /// @param time Time (in seconds) after which the next MCR calculation should be initiated
7922     function mcrOracliseFail(uint id, uint time) external onlyInternal {
7923         bytes32 myid = _oraclizeQuery(4, time, "URL", "", 1000000);
7924         _saveApiDetails(myid, "MCRF", id);
7925     }
7926 
7927     /// @dev Oraclize call to update investment asset rates.
7928     function saveIADetailsOracalise(uint time) external onlyInternal {
7929         bytes32 myid = _oraclizeQuery(3, time, "URL", "https://api.nexusmutual.io/saveIADetails/M1", 0);
7930         _saveApiDetails(myid, "IARB", 0);
7931     }
7932     
7933     /**
7934      * @dev Transfers all assest (i.e ETH balance, Currency Assest) from old Pool to new Pool
7935      * @param newPoolAddress Address of the new Pool
7936      */
7937     function upgradeCapitalPool(address payable newPoolAddress) external noReentrancy onlyInternal {
7938         for (uint64 i = 1; i < pd.getAllCurrenciesLen(); i++) {
7939             bytes4 caName = pd.getCurrenciesByIndex(i);
7940             _upgradeCapitalPool(caName, newPoolAddress);
7941         }
7942         if (address(this).balance > 0) {
7943             Pool1 newP1 = Pool1(newPoolAddress);
7944             newP1.sendEther.value(address(this).balance)();
7945         }
7946     }
7947 
7948     /**
7949      * @dev Iupgradable Interface to update dependent contract address
7950      */
7951     function changeDependentContractAddress() public {
7952         m1 = MCR(ms.getLatestAddress("MC"));
7953         tk = NXMToken(ms.tokenAddress());
7954         tf = TokenFunctions(ms.getLatestAddress("TF"));
7955         tc = TokenController(ms.getLatestAddress("TC"));
7956         pd = PoolData(ms.getLatestAddress("PD"));
7957         q2 = Quotation(ms.getLatestAddress("QT"));
7958         p2 = Pool2(ms.getLatestAddress("P2"));
7959         c1 = Claims(ms.getLatestAddress("CL"));
7960         td = TokenData(ms.getLatestAddress("TD"));
7961     }
7962 
7963     function sendEther() public payable {
7964         
7965     }
7966 
7967     /**
7968      * @dev transfers currency asset to an address
7969      * @param curr is the currency of currency asset to transfer
7970      * @param amount is amount of currency asset to transfer
7971      * @return boolean to represent success or failure
7972      */
7973     function transferCurrencyAsset(
7974         bytes4 curr,
7975         uint amount
7976     )
7977         public
7978         onlyInternal
7979         noReentrancy
7980         returns(bool)
7981     {
7982     
7983         return _transferCurrencyAsset(curr, amount);
7984     } 
7985 
7986     /// @dev Handles callback of external oracle query.
7987     function __callback(bytes32 myid, string memory result) public {
7988         result; //silence compiler warning
7989         // owner will be removed from production build
7990         ms.delegateCallBack(myid);
7991     }
7992 
7993     /// @dev Enables user to purchase cover with funding in ETH.
7994     /// @param smartCAdd Smart Contract Address
7995     function makeCoverBegin(
7996         address smartCAdd,
7997         bytes4 coverCurr,
7998         uint[] memory coverDetails,
7999         uint16 coverPeriod,
8000         uint8 _v,
8001         bytes32 _r,
8002         bytes32 _s
8003     )
8004         public
8005         isMember
8006         checkPause
8007         payable
8008     {
8009         require(msg.value == coverDetails[1]);
8010         q2.verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
8011     }
8012 
8013     /**
8014      * @dev Enables user to purchase cover via currency asset eg DAI
8015      */ 
8016     function makeCoverUsingCA(
8017         address smartCAdd,
8018         bytes4 coverCurr,
8019         uint[] memory coverDetails,
8020         uint16 coverPeriod,
8021         uint8 _v,
8022         bytes32 _r,
8023         bytes32 _s
8024     ) 
8025         public
8026         isMember
8027         checkPause
8028     {
8029         IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
8030         require(erc20.transferFrom(msg.sender, address(this), coverDetails[1]), "Transfer failed");
8031         q2.verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
8032     }
8033 
8034     /// @dev Enables user to purchase NXM at the current token price.
8035     function buyToken() public payable isMember checkPause returns(bool success) {
8036         require(msg.value > 0);
8037         uint tokenPurchased = _getToken(address(this).balance, msg.value);
8038         tc.mint(msg.sender, tokenPurchased);
8039         success = true;
8040     }
8041 
8042     /// @dev Sends a given amount of Ether to a given address.
8043     /// @param amount amount (in wei) to send.
8044     /// @param _add Receiver's address.
8045     /// @return succ True if transfer is a success, otherwise False.
8046     function transferEther(uint amount, address payable _add) public noReentrancy checkPause returns(bool succ) {
8047         require(ms.checkIsAuthToGoverned(msg.sender), "Not authorized to Govern");
8048         succ = _add.send(amount);
8049     }
8050 
8051     /**
8052      * @dev Allows selling of NXM for ether.
8053      * Seller first needs to give this contract allowance to
8054      * transfer/burn tokens in the NXMToken contract
8055      * @param  _amount Amount of NXM to sell
8056      * @return success returns true on successfull sale
8057      */
8058     function sellNXMTokens(uint _amount) public isMember noReentrancy checkPause returns(bool success) {
8059         require(tk.balanceOf(msg.sender) >= _amount, "Not enough balance");
8060         require(!tf.isLockedForMemberVote(msg.sender), "Member voted");
8061         require(_amount <= m1.getMaxSellTokens(), "exceeds maximum token sell limit");
8062         uint sellingPrice = _getWei(_amount);
8063         tc.burnFrom(msg.sender, _amount);
8064         msg.sender.transfer(sellingPrice);
8065         success = true;
8066     }
8067 
8068     /**
8069      * @dev gives the investment asset balance
8070      * @return investment asset balance
8071      */
8072     function getInvestmentAssetBalance() public view returns (uint balance) {
8073         IERC20 erc20;
8074         uint currTokens;
8075         for (uint i = 1; i < pd.getInvestmentCurrencyLen(); i++) {
8076             bytes4 currency = pd.getInvestmentCurrencyByIndex(i);
8077             erc20 = IERC20(pd.getInvestmentAssetAddress(currency));
8078             currTokens = erc20.balanceOf(address(p2));
8079             if (pd.getIAAvgRate(currency) > 0)
8080                 balance = balance.add((currTokens.mul(100)).div(pd.getIAAvgRate(currency)));
8081         }
8082 
8083         balance = balance.add(address(p2).balance);
8084     }
8085 
8086     /**
8087      * @dev Returns the amount of wei a seller will get for selling NXM
8088      * @param amount Amount of NXM to sell
8089      * @return weiToPay Amount of wei the seller will get
8090      */
8091     function getWei(uint amount) public view returns(uint weiToPay) {
8092         return _getWei(amount);
8093     }
8094 
8095     /**
8096      * @dev Returns the amount of token a buyer will get for corresponding wei
8097      * @param weiPaid Amount of wei 
8098      * @return tokenToGet Amount of tokens the buyer will get
8099      */
8100     function getToken(uint weiPaid) public view returns(uint tokenToGet) {
8101         return _getToken((address(this).balance).add(weiPaid), weiPaid);
8102     }
8103 
8104     /**
8105      * @dev to trigger external liquidity trade
8106      */
8107     function _triggerExternalLiquidityTrade() internal {
8108         if (now > pd.lastLiquidityTradeTrigger().add(pd.liquidityTradeCallbackTime())) {
8109             pd.setLastLiquidityTradeTrigger();
8110             bytes32 myid = _oraclizeQuery(4, pd.liquidityTradeCallbackTime(), "URL", "", 300000);
8111             _saveApiDetails(myid, "ULT", 0);
8112         }
8113     }
8114 
8115     /**
8116      * @dev Returns the amount of wei a seller will get for selling NXM
8117      * @param _amount Amount of NXM to sell
8118      * @return weiToPay Amount of wei the seller will get
8119      */
8120     function _getWei(uint _amount) internal view returns(uint weiToPay) {
8121         uint tokenPrice;
8122         uint weiPaid;
8123         uint tokenSupply = tk.totalSupply();
8124         uint vtp;
8125         uint mcrFullperc;
8126         uint vFull;
8127         uint mcrtp;
8128         (mcrFullperc, , vFull, ) = pd.getLastMCR();
8129         (vtp, ) = m1.calVtpAndMCRtp();
8130 
8131         while (_amount > 0) {
8132             mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
8133             tokenPrice = m1.calculateStepTokenPrice("ETH", mcrtp);
8134             tokenPrice = (tokenPrice.mul(975)).div(1000); //97.5%
8135             if (_amount <= td.priceStep().mul(DECIMAL1E18)) {
8136                 weiToPay = weiToPay.add((tokenPrice.mul(_amount)).div(DECIMAL1E18));
8137                 break;
8138             } else {
8139                 _amount = _amount.sub(td.priceStep().mul(DECIMAL1E18));
8140                 tokenSupply = tokenSupply.sub(td.priceStep().mul(DECIMAL1E18));
8141                 weiPaid = (tokenPrice.mul(td.priceStep().mul(DECIMAL1E18))).div(DECIMAL1E18);
8142                 vtp = vtp.sub(weiPaid);
8143                 weiToPay = weiToPay.add(weiPaid);
8144             }
8145         }
8146     }
8147 
8148     /**
8149      * @dev gives the token
8150      * @param _poolBalance is the pool balance
8151      * @param _weiPaid is the amount paid in wei
8152      * @return the token to get
8153      */
8154     function _getToken(uint _poolBalance, uint _weiPaid) internal view returns(uint tokenToGet) {
8155         uint tokenPrice;
8156         uint superWeiLeft = (_weiPaid).mul(DECIMAL1E18);
8157         uint tempTokens;
8158         uint superWeiSpent;
8159         uint tokenSupply = tk.totalSupply();
8160         uint vtp;
8161         uint mcrFullperc;   
8162         uint vFull;
8163         uint mcrtp;
8164         (mcrFullperc, , vFull, ) = pd.getLastMCR();
8165         (vtp, ) = m1.calculateVtpAndMCRtp((_poolBalance).sub(_weiPaid));
8166 
8167         require(m1.calculateTokenPrice("ETH") > 0, "Token price can not be zero");
8168         while (superWeiLeft > 0) {
8169             mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
8170             tokenPrice = m1.calculateStepTokenPrice("ETH", mcrtp);            
8171             tempTokens = superWeiLeft.div(tokenPrice);
8172             if (tempTokens <= td.priceStep().mul(DECIMAL1E18)) {
8173                 tokenToGet = tokenToGet.add(tempTokens);
8174                 break;
8175             } else {
8176                 tokenToGet = tokenToGet.add(td.priceStep().mul(DECIMAL1E18));
8177                 tokenSupply = tokenSupply.add(td.priceStep().mul(DECIMAL1E18));
8178                 superWeiSpent = td.priceStep().mul(DECIMAL1E18).mul(tokenPrice);
8179                 superWeiLeft = superWeiLeft.sub(superWeiSpent);
8180                 vtp = vtp.add((td.priceStep().mul(DECIMAL1E18).mul(tokenPrice)).div(DECIMAL1E18));
8181             }
8182         }
8183     }
8184 
8185     /** 
8186      * @dev Save the details of the Oraclize API.
8187      * @param myid Id return by the oraclize query.
8188      * @param _typeof type of the query for which oraclize call is made.
8189      * @param id ID of the proposal, quote, cover etc. for which oraclize call is made.
8190      */ 
8191     function _saveApiDetails(bytes32 myid, bytes4 _typeof, uint id) internal {
8192         pd.saveApiDetails(myid, _typeof, id);
8193         pd.addInAllApiCall(myid);
8194     }
8195 
8196     /**
8197      * @dev transfers currency asset
8198      * @param _curr is currency of asset to transfer
8199      * @param _amount is the amount to be transferred
8200      * @return boolean representing the success of transfer
8201      */
8202     function _transferCurrencyAsset(bytes4 _curr, uint _amount) internal returns(bool succ) {
8203         if (_curr == "ETH") {
8204             if (address(this).balance < _amount)
8205                 _amount = address(this).balance;
8206             p2.sendEther.value(_amount)();
8207             succ = true;
8208         } else {
8209             IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr)); //solhint-disable-line
8210             if (erc20.balanceOf(address(this)) < _amount) 
8211                 _amount = erc20.balanceOf(address(this));
8212             require(erc20.transfer(address(p2), _amount)); 
8213             succ = true;
8214             
8215         }
8216     } 
8217 
8218     /** 
8219      * @dev Transfers ERC20 Currency asset from this Pool to another Pool on upgrade.
8220      */ 
8221     function _upgradeCapitalPool(
8222         bytes4 _curr,
8223         address _newPoolAddress
8224     ) 
8225         internal
8226     {
8227         IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr));
8228         if (erc20.balanceOf(address(this)) > 0)
8229             require(erc20.transfer(_newPoolAddress, erc20.balanceOf(address(this))));
8230     }
8231 
8232     /**
8233      * @dev oraclize query
8234      * @param paramCount is number of paramters passed
8235      * @param timestamp is the current timestamp
8236      * @param datasource in concern
8237      * @param arg in concern
8238      * @param gasLimit required for query
8239      * @return id of oraclize query
8240      */
8241     function _oraclizeQuery(
8242         uint paramCount,
8243         uint timestamp,
8244         string memory datasource,
8245         string memory arg,
8246         uint gasLimit
8247     ) 
8248         internal
8249         returns (bytes32 id)
8250     {
8251         if (paramCount == 4) {
8252             id = oraclize_query(timestamp, datasource, arg, gasLimit);   
8253         } else if (paramCount == 3) {
8254             id = oraclize_query(timestamp, datasource, arg);   
8255         } else {
8256             id = oraclize_query(datasource, arg);
8257         }
8258     }
8259 }
8260 
8261 /* Copyright (C) 2017 NexusMutual.io
8262 
8263   This program is free software: you can redistribute it and/or modify
8264     it under the terms of the GNU General Public License as published by
8265     the Free Software Foundation, either version 3 of the License, or
8266     (at your option) any later version.
8267 
8268   This program is distributed in the hope that it will be useful,
8269     but WITHOUT ANY WARRANTY; without even the implied warranty of
8270     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
8271     GNU General Public License for more details.
8272 
8273   You should have received a copy of the GNU General Public License
8274     along with this program.  If not, see http://www.gnu.org/licenses/ */
8275 contract MCR is Iupgradable {
8276     using SafeMath for uint;
8277 
8278     Pool1 internal p1;
8279     PoolData internal pd;
8280     NXMToken internal tk;
8281     QuotationData internal qd;
8282     MemberRoles internal mr;
8283     TokenData internal td;
8284     ProposalCategory internal proposalCategory;
8285 
8286     uint private constant DECIMAL1E18 = uint(10) ** 18;
8287     uint private constant DECIMAL1E05 = uint(10) ** 5;
8288     uint private constant DECIMAL1E19 = uint(10) ** 19;
8289     uint private constant minCapFactor = uint(10) ** 21;
8290 
8291     uint public variableMincap;
8292     uint public dynamicMincapThresholdx100 = 13000;
8293     uint public dynamicMincapIncrementx100 = 100;
8294 
8295     event MCREvent(
8296         uint indexed date,
8297         uint blockNumber,
8298         bytes4[] allCurr,
8299         uint[] allCurrRates,
8300         uint mcrEtherx100,
8301         uint mcrPercx100,
8302         uint vFull
8303     );
8304 
8305     /** 
8306      * @dev Adds new MCR data.
8307      * @param mcrP  Minimum Capital Requirement in percentage.
8308      * @param vF Pool1 fund value in Ether used in the last full daily calculation of the Capital model.
8309      * @param onlyDate  Date(yyyymmdd) at which MCR details are getting added.
8310      */ 
8311     function addMCRData(
8312         uint mcrP,
8313         uint mcrE,
8314         uint vF,
8315         bytes4[] calldata curr,
8316         uint[] calldata _threeDayAvg,
8317         uint64 onlyDate
8318     )
8319         external
8320         checkPause
8321     {
8322         require(proposalCategory.constructorCheck());
8323         require(pd.isnotarise(msg.sender));
8324         if (mr.launched() && pd.capReached() != 1) {
8325             
8326             if (mcrP >= 10000)
8327                 pd.setCapReached(1);  
8328 
8329         }
8330         uint len = pd.getMCRDataLength();
8331         _addMCRData(len, onlyDate, curr, mcrE, mcrP, vF, _threeDayAvg);
8332     }
8333 
8334     /**
8335      * @dev Adds MCR Data for last failed attempt.
8336      */  
8337     function addLastMCRData(uint64 date) external checkPause  onlyInternal {
8338         uint64 lastdate = uint64(pd.getLastMCRDate());
8339         uint64 failedDate = uint64(date);
8340         if (failedDate >= lastdate) {
8341             uint mcrP;
8342             uint mcrE;
8343             uint vF;
8344             (mcrP, mcrE, vF, ) = pd.getLastMCR();
8345             uint len = pd.getAllCurrenciesLen();
8346             pd.pushMCRData(mcrP, mcrE, vF, date);
8347             for (uint j = 0; j < len; j++) {
8348                 bytes4 currName = pd.getCurrenciesByIndex(j);
8349                 pd.updateCAAvgRate(currName, pd.getCAAvgRate(currName));
8350             }
8351 
8352             emit MCREvent(date, block.number, new bytes4[](0), new uint[](0), mcrE, mcrP, vF);
8353             // Oraclize call for next MCR calculation
8354             _callOracliseForMCR();
8355         }
8356     }
8357 
8358     /**
8359      * @dev Iupgradable Interface to update dependent contract address
8360      */
8361     function changeDependentContractAddress() public onlyInternal {
8362         qd = QuotationData(ms.getLatestAddress("QD"));
8363         p1 = Pool1(ms.getLatestAddress("P1"));
8364         pd = PoolData(ms.getLatestAddress("PD"));
8365         tk = NXMToken(ms.tokenAddress());
8366         mr = MemberRoles(ms.getLatestAddress("MR"));
8367         td = TokenData(ms.getLatestAddress("TD"));
8368         proposalCategory = ProposalCategory(ms.getLatestAddress("PC"));
8369     }
8370 
8371     /** 
8372      * @dev Gets total sum assured(in ETH).
8373      * @return amount of sum assured
8374      */  
8375     function getAllSumAssurance() public view returns(uint amount) {
8376         uint len = pd.getAllCurrenciesLen();
8377         for (uint i = 0; i < len; i++) {
8378             bytes4 currName = pd.getCurrenciesByIndex(i);
8379             if (currName == "ETH") {
8380                 amount = amount.add(qd.getTotalSumAssured(currName));
8381             } else {
8382                 if (pd.getCAAvgRate(currName) > 0)
8383                     amount = amount.add((qd.getTotalSumAssured(currName).mul(100)).div(pd.getCAAvgRate(currName)));
8384             }
8385         }
8386     }
8387 
8388     /**
8389      * @dev Calculates V(Tp) and MCR%(Tp), i.e, Pool Fund Value in Ether 
8390      * and MCR% used in the Token Price Calculation.
8391      * @return vtp  Pool Fund Value in Ether used for the Token Price Model
8392      * @return mcrtp MCR% used in the Token Price Model. 
8393      */ 
8394     function _calVtpAndMCRtp(uint poolBalance) public view returns(uint vtp, uint mcrtp) {
8395         vtp = 0;
8396         IERC20 erc20;
8397         uint currTokens = 0;
8398         uint i;
8399         for (i = 1; i < pd.getAllCurrenciesLen(); i++) {
8400             bytes4 currency = pd.getCurrenciesByIndex(i);
8401             erc20 = IERC20(pd.getCurrencyAssetAddress(currency));
8402             currTokens = erc20.balanceOf(address(p1));
8403             if (pd.getCAAvgRate(currency) > 0)
8404                 vtp = vtp.add((currTokens.mul(100)).div(pd.getCAAvgRate(currency)));
8405         }
8406 
8407         vtp = vtp.add(poolBalance).add(p1.getInvestmentAssetBalance());
8408         uint mcrFullperc;
8409         uint vFull;
8410         (mcrFullperc, , vFull, ) = pd.getLastMCR();
8411         if (vFull > 0) {
8412             mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
8413         }
8414     }
8415 
8416     /**
8417      * @dev Calculates the Token Price of NXM in a given currency.
8418      * @param curr Currency name.
8419      
8420      */
8421     function calculateStepTokenPrice(
8422         bytes4 curr,
8423         uint mcrtp
8424     ) 
8425         public
8426         view
8427         onlyInternal
8428         returns(uint tokenPrice)
8429     {
8430         return _calculateTokenPrice(curr, mcrtp);
8431     }
8432 
8433     /**
8434      * @dev Calculates the Token Price of NXM in a given currency 
8435      * with provided token supply for dynamic token price calculation
8436      * @param curr Currency name.
8437      */ 
8438     function calculateTokenPrice (bytes4 curr) public view returns(uint tokenPrice) {
8439         uint mcrtp;
8440         (, mcrtp) = _calVtpAndMCRtp(address(p1).balance); 
8441         return _calculateTokenPrice(curr, mcrtp);
8442     }
8443     
8444     function calVtpAndMCRtp() public view returns(uint vtp, uint mcrtp) {
8445         return _calVtpAndMCRtp(address(p1).balance);
8446     }
8447 
8448     function calculateVtpAndMCRtp(uint poolBalance) public view returns(uint vtp, uint mcrtp) {
8449         return _calVtpAndMCRtp(poolBalance);
8450     }
8451 
8452     function getThresholdValues(uint vtp, uint vF, uint totalSA, uint minCap) public view returns(uint lowerThreshold, uint upperThreshold)
8453     {
8454         minCap = (minCap.mul(minCapFactor)).add(variableMincap);
8455         uint lower = 0;
8456         if (vtp >= vF) {
8457                 upperThreshold = vtp.mul(120).mul(100).div((minCap));     //Max Threshold = [MAX(Vtp, Vfull) x 120] / mcrMinCap
8458             } else {
8459                 upperThreshold = vF.mul(120).mul(100).div((minCap));
8460             }
8461 
8462             if (vtp > 0) {
8463                 lower = totalSA.mul(DECIMAL1E18).mul(pd.shockParameter()).div(100);
8464                 if(lower < minCap.mul(11).div(10))
8465                     lower = minCap.mul(11).div(10);
8466             }
8467             if (lower > 0) {                                       //Min Threshold = [Vtp / MAX(TotalActiveSA x ShockParameter, mcrMinCap x 1.1)] x 100
8468                 lowerThreshold = vtp.mul(100).mul(100).div(lower);
8469             }
8470     }
8471 
8472     /**
8473      * @dev Gets max numbers of tokens that can be sold at the moment.
8474      */ 
8475     function getMaxSellTokens() public view returns(uint maxTokens) {
8476         uint baseMin = pd.getCurrencyAssetBaseMin("ETH");
8477         uint maxTokensAccPoolBal;
8478         if (address(p1).balance > baseMin.mul(50).div(100)) {
8479             maxTokensAccPoolBal = address(p1).balance.sub(
8480             (baseMin.mul(50)).div(100));        
8481         }
8482         maxTokensAccPoolBal = (maxTokensAccPoolBal.mul(DECIMAL1E18)).div(
8483             (calculateTokenPrice("ETH").mul(975)).div(1000));
8484         uint lastMCRPerc = pd.getLastMCRPerc();
8485         if (lastMCRPerc > 10000)
8486             maxTokens = (((uint(lastMCRPerc).sub(10000)).mul(2000)).mul(DECIMAL1E18)).div(10000);
8487         if (maxTokens > maxTokensAccPoolBal)
8488             maxTokens = maxTokensAccPoolBal;     
8489     }
8490 
8491     /**
8492      * @dev Gets Uint Parameters of a code
8493      * @param code whose details we want
8494      * @return string value of the code
8495      * @return associated amount (time or perc or value) to the code
8496      */
8497     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
8498         codeVal = code;
8499         if (code == "DMCT") {
8500             val = dynamicMincapThresholdx100;
8501 
8502         } else if (code == "DMCI") {
8503 
8504             val = dynamicMincapIncrementx100;
8505 
8506         }
8507             
8508     }
8509 
8510     /**
8511      * @dev Updates Uint Parameters of a code
8512      * @param code whose details we want to update
8513      * @param val value to set
8514      */
8515     function updateUintParameters(bytes8 code, uint val) public {
8516         require(ms.checkIsAuthToGoverned(msg.sender));
8517         if (code == "DMCT") {
8518            dynamicMincapThresholdx100 = val;
8519 
8520         } else if (code == "DMCI") {
8521 
8522             dynamicMincapIncrementx100 = val;
8523 
8524         }
8525          else {
8526             revert("Invalid param code");
8527         }
8528             
8529     }
8530 
8531     /** 
8532      * @dev Calls oraclize query to calculate MCR details after 24 hours.
8533      */ 
8534     function _callOracliseForMCR() internal {
8535         p1.mcrOraclise(pd.mcrTime());
8536     }
8537 
8538     /**
8539      * @dev Calculates the Token Price of NXM in a given currency 
8540      * with provided token supply for dynamic token price calculation
8541      * @param _curr Currency name.  
8542      * @return tokenPrice Token price.
8543      */ 
8544     function _calculateTokenPrice(
8545         bytes4 _curr,
8546         uint mcrtp
8547     )
8548         internal
8549         view
8550         returns(uint tokenPrice)
8551     {
8552         uint getA;
8553         uint getC;
8554         uint getCAAvgRate;
8555         uint tokenExponentValue = td.tokenExponent();
8556         // uint max = (mcrtp.mul(mcrtp).mul(mcrtp).mul(mcrtp));
8557         uint max = mcrtp ** tokenExponentValue;
8558         uint dividingFactor = tokenExponentValue.mul(4); 
8559         (getA, getC, getCAAvgRate) = pd.getTokenPriceDetails(_curr);
8560         uint mcrEth = pd.getLastMCREther();
8561         getC = getC.mul(DECIMAL1E18);
8562         tokenPrice = (mcrEth.mul(DECIMAL1E18).mul(max).div(getC)).div(10 ** dividingFactor);
8563         tokenPrice = tokenPrice.add(getA.mul(DECIMAL1E18).div(DECIMAL1E05));
8564         tokenPrice = tokenPrice.mul(getCAAvgRate * 10); 
8565         tokenPrice = (tokenPrice).div(10**3);
8566     } 
8567     
8568     /**
8569      * @dev Adds MCR Data. Checks if MCR is within valid 
8570      * thresholds in order to rule out any incorrect calculations 
8571      */  
8572     function _addMCRData(
8573         uint len,
8574         uint64 newMCRDate,
8575         bytes4[] memory curr,
8576         uint mcrE,
8577         uint mcrP,
8578         uint vF,
8579         uint[] memory _threeDayAvg
8580     ) 
8581         internal
8582     {
8583         uint vtp = 0;
8584         uint lowerThreshold = 0;
8585         uint upperThreshold = 0;
8586         if (len > 1) {
8587             (vtp, ) = _calVtpAndMCRtp(address(p1).balance);
8588             (lowerThreshold, upperThreshold) = getThresholdValues(vtp, vF, getAllSumAssurance(), pd.minCap());
8589 
8590         }
8591         if(mcrP > dynamicMincapThresholdx100)
8592             variableMincap =  (variableMincap.mul(dynamicMincapIncrementx100.add(10000)).add(minCapFactor.mul(pd.minCap().mul(dynamicMincapIncrementx100)))).div(10000);
8593 
8594 
8595         // Explanation for above formula :- 
8596         // actual formula -> variableMinCap =  variableMinCap + (variableMinCap+minCap)*dynamicMincapIncrement/100
8597         // Implemented formula is simplified form of actual formula.
8598         // Let consider above formula as b = b + (a+b)*c/100
8599         // here, dynamicMincapIncrement is in x100 format. 
8600         // so b+(a+b)*cx100/10000 can be written as => (10000.b + b.cx100 + a.cx100)/10000.
8601         // It can further simplify to (b.(10000+cx100) + a.cx100)/10000.
8602         if (len == 1 || (mcrP) >= lowerThreshold 
8603             && (mcrP) <= upperThreshold) {
8604             vtp = pd.getLastMCRDate(); // due to stack to deep error,we are reusing already declared variable
8605             pd.pushMCRData(mcrP, mcrE, vF, newMCRDate);
8606             for (uint i = 0; i < curr.length; i++) {
8607                 pd.updateCAAvgRate(curr[i], _threeDayAvg[i]);
8608             }
8609             emit MCREvent(newMCRDate, block.number, curr, _threeDayAvg, mcrE, mcrP, vF);
8610             // Oraclize call for next MCR calculation
8611             if (vtp < newMCRDate) {
8612                 _callOracliseForMCR();
8613             }
8614         } else {
8615             p1.mcrOracliseFail(newMCRDate, pd.mcrFailTime());
8616         }
8617     }
8618 
8619 }
8620 
8621 /* Copyright (C) 2017 NexusMutual.io
8622 
8623   This program is free software: you can redistribute it and/or modify
8624     it under the terms of the GNU General Public License as published by
8625     the Free Software Foundation, either version 3 of the License, or
8626     (at your option) any later version.
8627 
8628   This program is distributed in the hope that it will be useful,
8629     but WITHOUT ANY WARRANTY; without even the implied warranty of
8630     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
8631     GNU General Public License for more details.
8632 
8633   You should have received a copy of the GNU General Public License
8634     along with this program.  If not, see http://www.gnu.org/licenses/ */
8635 contract Claims is Iupgradable {
8636     using SafeMath for uint;
8637 
8638     
8639     TokenFunctions internal tf;
8640     NXMToken internal tk;
8641     TokenController internal tc;
8642     ClaimsReward internal cr;
8643     Pool1 internal p1;
8644     ClaimsData internal cd;
8645     TokenData internal td;
8646     PoolData internal pd;
8647     Pool2 internal p2;
8648     QuotationData internal qd;
8649     MCR internal m1;
8650 
8651     uint private constant DECIMAL1E18 = uint(10) ** 18;
8652     
8653     /**
8654      * @dev Sets the status of claim using claim id.
8655      * @param claimId claim id.
8656      * @param stat status to be set.
8657      */ 
8658     function setClaimStatus(uint claimId, uint stat) external onlyInternal {
8659         _setClaimStatus(claimId, stat);
8660     }
8661 
8662     /**
8663      * @dev Gets claim details of claim id = pending claim start + given index
8664      */ 
8665     function getClaimFromNewStart(
8666         uint index
8667     )
8668         external 
8669         view 
8670         returns (
8671             uint coverId,
8672             uint claimId,
8673             int8 voteCA,
8674             int8 voteMV,
8675             uint statusnumber
8676         ) 
8677     {
8678         (coverId, claimId, voteCA, voteMV, statusnumber) = cd.getClaimFromNewStart(index, msg.sender);
8679         // status = rewardStatus[statusnumber].claimStatusDesc;
8680     }
8681 
8682     /**
8683      * @dev Gets details of a claim submitted by the calling user, at a given index
8684      */
8685     function getUserClaimByIndex(
8686         uint index
8687     )
8688         external
8689         view 
8690         returns(
8691             uint status,
8692             uint coverId,
8693             uint claimId
8694         )
8695     {
8696         uint statusno;
8697         (statusno, coverId, claimId) = cd.getUserClaimByIndex(index, msg.sender);
8698         status = statusno;
8699     }
8700 
8701     /**
8702      * @dev Gets details of a given claim id.
8703      * @param _claimId Claim Id.
8704      * @return status Current status of claim id
8705      * @return finalVerdict Decision made on the claim, 1 -> acceptance, -1 -> denial
8706      * @return claimOwner Address through which claim is submitted
8707      * @return coverId Coverid associated with the claim id
8708      */
8709     function getClaimbyIndex(uint _claimId) external view returns (
8710         uint claimId,
8711         uint status,
8712         int8 finalVerdict,
8713         address claimOwner,
8714         uint coverId
8715     )
8716     {
8717         uint stat;
8718         claimId = _claimId;
8719         (, coverId, finalVerdict, stat, , ) = cd.getClaim(_claimId);
8720         claimOwner = qd.getCoverMemberAddress(coverId);
8721         status = stat;
8722     }
8723 
8724     /**
8725      * @dev Calculates total amount that has been used to assess a claim.
8726      * Computaion:Adds acceptCA(tokens used for voting in favor of a claim)
8727      * denyCA(tokens used for voting against a claim) *  current token price.
8728      * @param claimId Claim Id.
8729      * @param member Member type 0 -> Claim Assessors, else members.
8730      * @return tokens Total Amount used in Claims assessment.
8731      */ 
8732     function getCATokens(uint claimId, uint member) external view returns(uint tokens) {
8733         uint coverId;
8734         (, coverId) = cd.getClaimCoverId(claimId);
8735         bytes4 curr = qd.getCurrencyOfCover(coverId);
8736         uint tokenx1e18 = m1.calculateTokenPrice(curr);
8737         uint accept;
8738         uint deny;
8739         if (member == 0) {
8740             (, accept, deny) = cd.getClaimsTokenCA(claimId);
8741         } else {
8742             (, accept, deny) = cd.getClaimsTokenMV(claimId);
8743         }
8744         tokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18); // amount (not in tokens)
8745     }
8746 
8747     /**
8748      * Iupgradable Interface to update dependent contract address
8749      */
8750     function changeDependentContractAddress() public onlyInternal {
8751         tk = NXMToken(ms.tokenAddress());
8752         td = TokenData(ms.getLatestAddress("TD"));
8753         tf = TokenFunctions(ms.getLatestAddress("TF"));
8754         tc = TokenController(ms.getLatestAddress("TC"));
8755         p1 = Pool1(ms.getLatestAddress("P1"));
8756         p2 = Pool2(ms.getLatestAddress("P2"));
8757         pd = PoolData(ms.getLatestAddress("PD"));
8758         cr = ClaimsReward(ms.getLatestAddress("CR"));
8759         cd = ClaimsData(ms.getLatestAddress("CD"));
8760         qd = QuotationData(ms.getLatestAddress("QD"));
8761         m1 = MCR(ms.getLatestAddress("MC"));
8762     }
8763 
8764     /**
8765      * @dev Updates the pending claim start variable,
8766      * the lowest claim id with a pending decision/payout.
8767      */ 
8768     function changePendingClaimStart() public onlyInternal {
8769 
8770         uint origstat;
8771         uint state12Count;
8772         uint pendingClaimStart = cd.pendingClaimStart();
8773         uint actualClaimLength = cd.actualClaimLength();
8774         for (uint i = pendingClaimStart; i < actualClaimLength; i++) {
8775             (, , , origstat, , state12Count) = cd.getClaim(i);
8776 
8777             if (origstat > 5 && ((origstat != 12) || (origstat == 12 && state12Count >= 60)))
8778                 cd.setpendingClaimStart(i);
8779             else
8780                 break;
8781         }
8782     }
8783 
8784     /**
8785      * @dev Submits a claim for a given cover note.
8786      * Adds claim to queue incase of emergency pause else directly submits the claim.
8787      * @param coverId Cover Id.
8788      */ 
8789     function submitClaim(uint coverId) public {
8790         address qadd = qd.getCoverMemberAddress(coverId);
8791         require(qadd == msg.sender);
8792         uint8 cStatus;
8793         (, cStatus, , , ) = qd.getCoverDetailsByCoverID2(coverId);
8794         require(cStatus != uint8(QuotationData.CoverStatus.ClaimSubmitted), "Claim already submitted");
8795         require(cStatus != uint8(QuotationData.CoverStatus.CoverExpired), "Cover already expired");
8796         if (ms.isPause() == false) {
8797             _addClaim(coverId, now, qadd);
8798         } else {
8799             cd.setClaimAtEmergencyPause(coverId, now, false);
8800             qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.Requested));
8801         }
8802     }
8803 
8804     /**
8805      * @dev Submits the Claims queued once the emergency pause is switched off.
8806      */
8807     function submitClaimAfterEPOff() public onlyInternal {
8808         uint lengthOfClaimSubmittedAtEP = cd.getLengthOfClaimSubmittedAtEP();
8809         uint firstClaimIndexToSubmitAfterEP = cd.getFirstClaimIndexToSubmitAfterEP();
8810         uint coverId;
8811         uint dateUpd;
8812         bool submit;
8813         address qadd;
8814         for (uint i = firstClaimIndexToSubmitAfterEP; i < lengthOfClaimSubmittedAtEP; i++) {
8815             (coverId, dateUpd, submit) = cd.getClaimOfEmergencyPauseByIndex(i);
8816             require(submit == false);
8817             qadd = qd.getCoverMemberAddress(coverId);
8818             _addClaim(coverId, dateUpd, qadd);
8819             cd.setClaimSubmittedAtEPTrue(i, true);
8820         }
8821         cd.setFirstClaimIndexToSubmitAfterEP(lengthOfClaimSubmittedAtEP);
8822     }
8823 
8824     /**
8825      * @dev Castes vote for members who have tokens locked under Claims Assessment
8826      * @param claimId  claim id.
8827      * @param verdict 1 for Accept,-1 for Deny.
8828      */ 
8829     function submitCAVote(uint claimId, int8 verdict) public isMemberAndcheckPause {
8830         require(checkVoteClosing(claimId) != 1); 
8831         require(cd.userClaimVotePausedOn(msg.sender).add(cd.pauseDaysCA()) < now);  
8832         uint tokens = tc.tokensLockedAtTime(msg.sender, "CLA", now.add(cd.claimDepositTime()));
8833         require(tokens > 0);
8834         uint stat;
8835         (, stat) = cd.getClaimStatusNumber(claimId);
8836         require(stat == 0);
8837         require(cd.getUserClaimVoteCA(msg.sender, claimId) == 0);
8838         td.bookCATokens(msg.sender);
8839         cd.addVote(msg.sender, tokens, claimId, verdict);
8840         cd.callVoteEvent(msg.sender, claimId, "CAV", tokens, now, verdict);
8841         uint voteLength = cd.getAllVoteLength();
8842         cd.addClaimVoteCA(claimId, voteLength);
8843         cd.setUserClaimVoteCA(msg.sender, claimId, voteLength);
8844         cd.setClaimTokensCA(claimId, verdict, tokens);
8845         tc.extendLockOf(msg.sender, "CLA", td.lockCADays());
8846         int close = checkVoteClosing(claimId);
8847         if (close == 1) {
8848             cr.changeClaimStatus(claimId);
8849         }
8850     }
8851 
8852     /**
8853      * @dev Submits a member vote for assessing a claim.
8854      * Tokens other than those locked under Claims
8855      * Assessment can be used to cast a vote for a given claim id.
8856      * @param claimId Selected claim id.
8857      * @param verdict 1 for Accept,-1 for Deny.
8858      */ 
8859     function submitMemberVote(uint claimId, int8 verdict) public isMemberAndcheckPause {
8860         require(checkVoteClosing(claimId) != 1);
8861         uint stat;
8862         uint tokens = tc.totalBalanceOf(msg.sender);
8863         (, stat) = cd.getClaimStatusNumber(claimId);
8864         require(stat >= 1 && stat <= 5);
8865         require(cd.getUserClaimVoteMember(msg.sender, claimId) == 0);
8866         cd.addVote(msg.sender, tokens, claimId, verdict);
8867         cd.callVoteEvent(msg.sender, claimId, "MV", tokens, now, verdict);
8868         tc.lockForMemberVote(msg.sender, td.lockMVDays());
8869         uint voteLength = cd.getAllVoteLength();
8870         cd.addClaimVotemember(claimId, voteLength);
8871         cd.setUserClaimVoteMember(msg.sender, claimId, voteLength);
8872         cd.setClaimTokensMV(claimId, verdict, tokens);
8873         int close = checkVoteClosing(claimId);
8874         if (close == 1) {
8875             cr.changeClaimStatus(claimId);
8876         }
8877     }
8878 
8879     /**
8880     * @dev Pause Voting of All Pending Claims when Emergency Pause Start.
8881     */ 
8882     function pauseAllPendingClaimsVoting() public onlyInternal {
8883         uint firstIndex = cd.pendingClaimStart();
8884         uint actualClaimLength = cd.actualClaimLength();
8885         for (uint i = firstIndex; i < actualClaimLength; i++) {
8886             if (checkVoteClosing(i) == 0) {
8887                 uint dateUpd = cd.getClaimDateUpd(i);
8888                 cd.setPendingClaimDetails(i, (dateUpd.add(cd.maxVotingTime())).sub(now), false);
8889             }
8890         }
8891     }
8892 
8893     /**
8894      * @dev Resume the voting phase of all Claims paused due to an emergency pause.
8895      */
8896     function startAllPendingClaimsVoting() public onlyInternal {
8897         uint firstIndx = cd.getFirstClaimIndexToStartVotingAfterEP();
8898         uint i;
8899         uint lengthOfClaimVotingPause = cd.getLengthOfClaimVotingPause();
8900         for (i = firstIndx; i < lengthOfClaimVotingPause; i++) {
8901             uint pendingTime;
8902             uint claimID;
8903             (claimID, pendingTime, ) = cd.getPendingClaimDetailsByIndex(i);
8904             uint pTime = (now.sub(cd.maxVotingTime())).add(pendingTime);
8905             cd.setClaimdateUpd(claimID, pTime);
8906             cd.setPendingClaimVoteStatus(i, true);
8907             uint coverid;
8908             (, coverid) = cd.getClaimCoverId(claimID);
8909             address qadd = qd.getCoverMemberAddress(coverid);
8910             tf.extendCNEPOff(qadd, coverid, pendingTime.add(cd.claimDepositTime()));
8911             p1.closeClaimsOraclise(claimID, uint64(pTime));
8912         }
8913         cd.setFirstClaimIndexToStartVotingAfterEP(i);
8914     }
8915 
8916     /**
8917      * @dev Checks if voting of a claim should be closed or not.
8918      * @param claimId Claim Id.
8919      * @return close 1 -> voting should be closed, 0 -> if voting should not be closed,
8920      * -1 -> voting has already been closed.
8921      */ 
8922     function checkVoteClosing(uint claimId) public view returns(int8 close) {
8923         close = 0;
8924         uint status;
8925         (, status) = cd.getClaimStatusNumber(claimId);
8926         uint dateUpd = cd.getClaimDateUpd(claimId);
8927         if (status == 12 && dateUpd.add(cd.payoutRetryTime()) < now) {
8928             if (cd.getClaimState12Count(claimId) < 60)
8929                 close = 1;
8930         } 
8931         
8932         if (status > 5 && status != 12) {
8933             close = -1;
8934         }  else if (status != 12 && dateUpd.add(cd.maxVotingTime()) <= now) {
8935             close = 1;
8936         } else if (status != 12 && dateUpd.add(cd.minVotingTime()) >= now) {
8937             close = 0;
8938         } else if (status == 0 || (status >= 1 && status <= 5)) {
8939             close = _checkVoteClosingFinal(claimId, status);
8940         }
8941         
8942     }
8943 
8944     /**
8945      * @dev Checks if voting of a claim should be closed or not.
8946      * Internally called by checkVoteClosing method
8947      * for Claims whose status number is 0 or status number lie between 2 and 6.
8948      * @param claimId Claim Id.
8949      * @param status Current status of claim.
8950      * @return close 1 if voting should be closed,0 in case voting should not be closed,
8951      * -1 if voting has already been closed.
8952      */
8953     function _checkVoteClosingFinal(uint claimId, uint status) internal view returns(int8 close) {
8954         close = 0;
8955         uint coverId;
8956         (, coverId) = cd.getClaimCoverId(claimId);
8957         bytes4 curr = qd.getCurrencyOfCover(coverId);
8958         uint tokenx1e18 = m1.calculateTokenPrice(curr);
8959         uint accept;
8960         uint deny;
8961         (, accept, deny) = cd.getClaimsTokenCA(claimId);
8962         uint caTokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18);
8963         (, accept, deny) = cd.getClaimsTokenMV(claimId);
8964         uint mvTokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18);
8965         uint sumassured = qd.getCoverSumAssured(coverId).mul(DECIMAL1E18);
8966         if (status == 0 && caTokens >= sumassured.mul(10)) {
8967             close = 1;
8968         } else if (status >= 1 && status <= 5 && mvTokens >= sumassured.mul(10)) {
8969             close = 1;
8970         }
8971     }
8972 
8973     /**
8974      * @dev Changes the status of an existing claim id, based on current 
8975      * status and current conditions of the system
8976      * @param claimId Claim Id.
8977      * @param stat status number.  
8978      */
8979     function _setClaimStatus(uint claimId, uint stat) internal {
8980 
8981         uint origstat;
8982         uint state12Count;
8983         uint dateUpd;
8984         uint coverId;
8985         (, coverId, , origstat, dateUpd, state12Count) = cd.getClaim(claimId);
8986         (, origstat) = cd.getClaimStatusNumber(claimId);
8987 
8988         if (stat == 12 && origstat == 12) {
8989             cd.updateState12Count(claimId, 1);
8990         }
8991         cd.setClaimStatus(claimId, stat);
8992 
8993         if (state12Count >= 60 && stat == 12) {
8994             cd.setClaimStatus(claimId, 13);
8995             qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.ClaimDenied));
8996         }
8997         uint time = now;
8998         cd.setClaimdateUpd(claimId, time);
8999 
9000         if (stat >= 2 && stat <= 5) {
9001             p1.closeClaimsOraclise(claimId, cd.maxVotingTime());
9002         }
9003 
9004         if (stat == 12 && (dateUpd.add(cd.payoutRetryTime()) <= now) && (state12Count < 60)) {
9005             p1.closeClaimsOraclise(claimId, cd.payoutRetryTime());
9006         } else if (stat == 12 && (dateUpd.add(cd.payoutRetryTime()) > now) && (state12Count < 60)) {
9007             uint64 timeLeft = uint64((dateUpd.add(cd.payoutRetryTime())).sub(now));
9008             p1.closeClaimsOraclise(claimId, timeLeft);
9009         }
9010     }
9011 
9012     /**
9013      * @dev Submits a claim for a given cover note.
9014      * Set deposits flag against cover.
9015      */
9016     function _addClaim(uint coverId, uint time, address add) internal {
9017         tf.depositCN(coverId);
9018         uint len = cd.actualClaimLength();
9019         cd.addClaim(len, coverId, add, now);
9020         cd.callClaimEvent(coverId, add, len, time);
9021         qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.ClaimSubmitted));
9022         bytes4 curr = qd.getCurrencyOfCover(coverId);
9023         uint sumAssured = qd.getCoverSumAssured(coverId).mul(DECIMAL1E18);
9024         pd.changeCurrencyAssetVarMin(curr, pd.getCurrencyAssetVarMin(curr).add(sumAssured));
9025         p2.internalLiquiditySwap(curr);
9026         p1.closeClaimsOraclise(len, cd.maxVotingTime());
9027     }
9028 }
9029 
9030 /* Copyright (C) 2020 NexusMutual.io
9031 
9032   This program is free software: you can redistribute it and/or modify
9033     it under the terms of the GNU General Public License as published by
9034     the Free Software Foundation, either version 3 of the License, or
9035     (at your option) any later version.
9036 
9037   This program is distributed in the hope that it will be useful,
9038     but WITHOUT ANY WARRANTY; without even the implied warranty of
9039     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9040     GNU General Public License for more details.
9041 
9042   You should have received a copy of the GNU General Public License
9043     along with this program.  If not, see http://www.gnu.org/licenses/ */
9044 //Claims Reward Contract contains the functions for calculating number of tokens
9045 // that will get rewarded, unlocked or burned depending upon the status of claim.
9046 contract ClaimsReward is Iupgradable {
9047      using SafeMath for uint;
9048 
9049     NXMToken internal tk;
9050     TokenController internal tc;
9051     TokenFunctions internal tf;
9052     TokenData internal td;
9053     QuotationData internal qd;
9054     Claims internal c1;
9055     ClaimsData internal cd;
9056     Pool1 internal p1;
9057     Pool2 internal p2;
9058     PoolData internal pd;
9059     Governance internal gv;
9060     IPooledStaking internal pooledStaking;
9061 
9062     uint private constant DECIMAL1E18 = uint(10) ** 18;
9063 
9064     function changeDependentContractAddress() public onlyInternal {
9065         c1 = Claims(ms.getLatestAddress("CL"));
9066         cd = ClaimsData(ms.getLatestAddress("CD"));
9067         tk = NXMToken(ms.tokenAddress());
9068         tc = TokenController(ms.getLatestAddress("TC"));
9069         td = TokenData(ms.getLatestAddress("TD"));
9070         tf = TokenFunctions(ms.getLatestAddress("TF"));
9071         p1 = Pool1(ms.getLatestAddress("P1"));
9072         p2 = Pool2(ms.getLatestAddress("P2"));
9073         pd = PoolData(ms.getLatestAddress("PD"));
9074         qd = QuotationData(ms.getLatestAddress("QD"));
9075         gv = Governance(ms.getLatestAddress("GV"));
9076         pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
9077     }
9078 
9079     /// @dev Decides the next course of action for a given claim.
9080     function changeClaimStatus(uint claimid) public checkPause onlyInternal {
9081 
9082         uint coverid;
9083         (, coverid) = cd.getClaimCoverId(claimid);
9084 
9085         uint status;
9086         (, status) = cd.getClaimStatusNumber(claimid);
9087 
9088         // when current status is "Pending-Claim Assessor Vote"
9089         if (status == 0) {
9090             _changeClaimStatusCA(claimid, coverid, status);
9091         } else if (status >= 1 && status <= 5) {
9092             _changeClaimStatusMV(claimid, coverid, status);
9093         } else if (status == 12) { // when current status is "Claim Accepted Payout Pending"
9094 
9095             uint sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
9096             address payable coverHolder = qd.getCoverMemberAddress(coverid);
9097             bytes4 coverCurrency = qd.getCurrencyOfCover(coverid);
9098             bool success = p1.sendClaimPayout(coverid, claimid, sumAssured, coverHolder, coverCurrency);
9099 
9100             if (success) {
9101                 tf.burnStakedTokens(coverid, coverCurrency, sumAssured);
9102                 c1.setClaimStatus(claimid, 14);
9103             }
9104         }
9105 
9106         c1.changePendingClaimStart();
9107     }
9108 
9109     /// @dev Amount of tokens to be rewarded to a user for a particular vote id.
9110     /// @param check 1 -> CA vote, else member vote
9111     /// @param voteid vote id for which reward has to be Calculated
9112     /// @param flag if 1 calculate even if claimed,else don't calculate if already claimed
9113     /// @return tokenCalculated reward to be given for vote id
9114     /// @return lastClaimedCheck true if final verdict is still pending for that voteid
9115     /// @return tokens number of tokens locked under that voteid
9116     /// @return perc percentage of reward to be given.
9117     function getRewardToBeGiven(
9118         uint check,
9119         uint voteid,
9120         uint flag
9121     )
9122         public
9123         view
9124         returns (
9125             uint tokenCalculated,
9126             bool lastClaimedCheck,
9127             uint tokens,
9128             uint perc
9129         )
9130 
9131     {
9132         uint claimId;
9133         int8 verdict;
9134         bool claimed;
9135         uint tokensToBeDist;
9136         uint totalTokens;
9137         (tokens, claimId, verdict, claimed) = cd.getVoteDetails(voteid);
9138         lastClaimedCheck = false;
9139         int8 claimVerdict = cd.getFinalVerdict(claimId);
9140         if (claimVerdict == 0) {
9141             lastClaimedCheck = true;
9142         }
9143 
9144         if (claimVerdict == verdict && (claimed == false || flag == 1)) {
9145 
9146             if (check == 1) {
9147                 (perc, , tokensToBeDist) = cd.getClaimRewardDetail(claimId);
9148             } else {
9149                 (, perc, tokensToBeDist) = cd.getClaimRewardDetail(claimId);
9150             }
9151 
9152             if (perc > 0) {
9153                 if (check == 1) {
9154                     if (verdict == 1) {
9155                         (, totalTokens, ) = cd.getClaimsTokenCA(claimId);
9156                     } else {
9157                         (, , totalTokens) = cd.getClaimsTokenCA(claimId);
9158                     }
9159                 } else {
9160                     if (verdict == 1) {
9161                         (, totalTokens, ) = cd.getClaimsTokenMV(claimId);
9162                     }else {
9163                         (, , totalTokens) = cd.getClaimsTokenMV(claimId);
9164                     }
9165                 }
9166                 tokenCalculated = (perc.mul(tokens).mul(tokensToBeDist)).div(totalTokens.mul(100));
9167 
9168 
9169             }
9170         }
9171     }
9172 
9173     /// @dev Transfers all tokens held by contract to a new contract in case of upgrade.
9174     function upgrade(address _newAdd) public onlyInternal {
9175         uint amount = tk.balanceOf(address(this));
9176         if (amount > 0) {
9177             require(tk.transfer(_newAdd, amount));
9178         }
9179 
9180     }
9181 
9182     /// @dev Total reward in token due for claim by a user.
9183     /// @return total total number of tokens
9184     function getRewardToBeDistributedByUser(address _add) public view returns(uint total) {
9185         uint lengthVote = cd.getVoteAddressCALength(_add);
9186         uint lastIndexCA;
9187         uint lastIndexMV;
9188         uint tokenForVoteId;
9189         uint voteId;
9190         (lastIndexCA, lastIndexMV) = cd.getRewardDistributedIndex(_add);
9191 
9192         for (uint i = lastIndexCA; i < lengthVote; i++) {
9193             voteId = cd.getVoteAddressCA(_add, i);
9194             (tokenForVoteId, , , ) = getRewardToBeGiven(1, voteId, 0);
9195             total = total.add(tokenForVoteId);
9196         }
9197 
9198         lengthVote = cd.getVoteAddressMemberLength(_add);
9199 
9200         for (uint j = lastIndexMV; j < lengthVote; j++) {
9201             voteId = cd.getVoteAddressMember(_add, j);
9202             (tokenForVoteId, , , ) = getRewardToBeGiven(0, voteId, 0);
9203             total = total.add(tokenForVoteId);
9204         }
9205         return (total);
9206     }
9207 
9208     /// @dev Gets reward amount and claiming status for a given claim id.
9209     /// @return reward amount of tokens to user.
9210     /// @return claimed true if already claimed false if yet to be claimed.
9211     function getRewardAndClaimedStatus(uint check, uint claimId) public view returns(uint reward, bool claimed) {
9212         uint voteId;
9213         uint claimid;
9214         uint lengthVote;
9215 
9216         if (check == 1) {
9217             lengthVote = cd.getVoteAddressCALength(msg.sender);
9218             for (uint i = 0; i < lengthVote; i++) {
9219                 voteId = cd.getVoteAddressCA(msg.sender, i);
9220                 (, claimid, , claimed) = cd.getVoteDetails(voteId);
9221                 if (claimid == claimId) { break; }
9222             }
9223         } else {
9224             lengthVote = cd.getVoteAddressMemberLength(msg.sender);
9225             for (uint j = 0; j < lengthVote; j++) {
9226                 voteId = cd.getVoteAddressMember(msg.sender, j);
9227                 (, claimid, , claimed) = cd.getVoteDetails(voteId);
9228                 if (claimid == claimId) { break; }
9229             }
9230         }
9231         (reward, , , ) = getRewardToBeGiven(check, voteId, 1);
9232 
9233     }
9234 
9235     /**
9236      * @dev Function used to claim all pending rewards : Claims Assessment + Risk Assessment + Governance
9237      * Claim assesment, Risk assesment, Governance rewards
9238      */
9239     function claimAllPendingReward(uint records) public isMemberAndcheckPause {
9240         _claimRewardToBeDistributed(records);
9241         pooledStaking.withdrawReward(msg.sender);
9242         uint governanceRewards = gv.claimReward(msg.sender, records);
9243         if (governanceRewards > 0) {
9244             require(tk.transfer(msg.sender, governanceRewards));
9245         }
9246     }
9247 
9248     /**
9249      * @dev Function used to get pending rewards of a particular user address.
9250      * @param _add user address.
9251      * @return total reward amount of the user
9252      */
9253     function getAllPendingRewardOfUser(address _add) public view returns(uint) {
9254         uint caReward = getRewardToBeDistributedByUser(_add);
9255         uint pooledStakingReward = pooledStaking.stakerReward(_add);
9256         uint governanceReward = gv.getPendingReward(_add);
9257         return caReward.add(pooledStakingReward).add(governanceReward);
9258     }
9259 
9260     /// @dev Rewards/Punishes users who  participated in Claims assessment.
9261     //    Unlocking and burning of the tokens will also depend upon the status of claim.
9262     /// @param claimid Claim Id.
9263     function _rewardAgainstClaim(uint claimid, uint coverid, uint sumAssured, uint status) internal {
9264         uint premiumNXM = qd.getCoverPremiumNXM(coverid);
9265         bytes4 curr = qd.getCurrencyOfCover(coverid);
9266         uint distributableTokens = premiumNXM.mul(cd.claimRewardPerc()).div(100);//  20% of premium
9267 
9268         uint percCA;
9269         uint percMV;
9270 
9271         (percCA, percMV) = cd.getRewardStatus(status);
9272         cd.setClaimRewardDetail(claimid, percCA, percMV, distributableTokens);
9273         if (percCA > 0 || percMV > 0) {
9274             tc.mint(address(this), distributableTokens);
9275         }
9276 
9277         if (status == 6 || status == 9 || status == 11) {
9278             cd.changeFinalVerdict(claimid, -1);
9279             td.setDepositCN(coverid, false); // Unset flag
9280             tf.burnDepositCN(coverid); // burn Deposited CN
9281 
9282             pd.changeCurrencyAssetVarMin(curr, pd.getCurrencyAssetVarMin(curr).sub(sumAssured));
9283             p2.internalLiquiditySwap(curr);
9284 
9285         } else if (status == 7 || status == 8 || status == 10) {
9286             cd.changeFinalVerdict(claimid, 1);
9287             td.setDepositCN(coverid, false); // Unset flag
9288             tf.unlockCN(coverid);
9289             bool success = p1.sendClaimPayout(coverid, claimid, sumAssured, qd.getCoverMemberAddress(coverid), curr);
9290             if (success) {
9291                 tf.burnStakedTokens(coverid, curr, sumAssured);
9292             }
9293         }
9294     }
9295 
9296     /// @dev Computes the result of Claim Assessors Voting for a given claim id.
9297     function _changeClaimStatusCA(uint claimid, uint coverid, uint status) internal {
9298         // Check if voting should be closed or not
9299         if (c1.checkVoteClosing(claimid) == 1) {
9300             uint caTokens = c1.getCATokens(claimid, 0); // converted in cover currency.
9301             uint accept;
9302             uint deny;
9303             uint acceptAndDeny;
9304             bool rewardOrPunish;
9305             uint sumAssured;
9306             (, accept) = cd.getClaimVote(claimid, 1);
9307             (, deny) = cd.getClaimVote(claimid, -1);
9308             acceptAndDeny = accept.add(deny);
9309             accept = accept.mul(100);
9310             deny = deny.mul(100);
9311 
9312             if (caTokens == 0) {
9313                 status = 3;
9314             } else {
9315                 sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
9316                 // Min threshold reached tokens used for voting > 5* sum assured
9317                 if (caTokens > sumAssured.mul(5)) {
9318 
9319                     if (accept.div(acceptAndDeny) > 70) {
9320                         status = 7;
9321                         qd.changeCoverStatusNo(coverid, uint8(QuotationData.CoverStatus.ClaimAccepted));
9322                         rewardOrPunish = true;
9323                     } else if (deny.div(acceptAndDeny) > 70) {
9324                         status = 6;
9325                         qd.changeCoverStatusNo(coverid, uint8(QuotationData.CoverStatus.ClaimDenied));
9326                         rewardOrPunish = true;
9327                     } else if (accept.div(acceptAndDeny) > deny.div(acceptAndDeny)) {
9328                         status = 4;
9329                     } else {
9330                         status = 5;
9331                     }
9332 
9333                 } else {
9334 
9335                     if (accept.div(acceptAndDeny) > deny.div(acceptAndDeny)) {
9336                         status = 2;
9337                     } else {
9338                         status = 3;
9339                     }
9340                 }
9341             }
9342 
9343             c1.setClaimStatus(claimid, status);
9344 
9345             if (rewardOrPunish) {
9346                 _rewardAgainstClaim(claimid, coverid, sumAssured, status);
9347             }
9348         }
9349     }
9350 
9351     /// @dev Computes the result of Member Voting for a given claim id.
9352     function _changeClaimStatusMV(uint claimid, uint coverid, uint status) internal {
9353 
9354         // Check if voting should be closed or not
9355         if (c1.checkVoteClosing(claimid) == 1) {
9356             uint8 coverStatus;
9357             uint statusOrig = status;
9358             uint mvTokens = c1.getCATokens(claimid, 1); // converted in cover currency.
9359 
9360             // If tokens used for acceptance >50%, claim is accepted
9361             uint sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
9362             uint thresholdUnreached = 0;
9363             // Minimum threshold for member voting is reached only when
9364             // value of tokens used for voting > 5* sum assured of claim id
9365             if (mvTokens < sumAssured.mul(5)) {
9366                 thresholdUnreached = 1;
9367             }
9368 
9369             uint accept;
9370             (, accept) = cd.getClaimMVote(claimid, 1);
9371             uint deny;
9372             (, deny) = cd.getClaimMVote(claimid, -1);
9373 
9374             if (accept.add(deny) > 0) {
9375                 if (accept.mul(100).div(accept.add(deny)) >= 50 && statusOrig > 1 &&
9376                     statusOrig <= 5 && thresholdUnreached == 0) {
9377                     status = 8;
9378                     coverStatus = uint8(QuotationData.CoverStatus.ClaimAccepted);
9379                 } else if (deny.mul(100).div(accept.add(deny)) >= 50 && statusOrig > 1 &&
9380                     statusOrig <= 5 && thresholdUnreached == 0) {
9381                     status = 9;
9382                     coverStatus = uint8(QuotationData.CoverStatus.ClaimDenied);
9383                 }
9384             }
9385 
9386             if (thresholdUnreached == 1 && (statusOrig == 2 || statusOrig == 4)) {
9387                 status = 10;
9388                 coverStatus = uint8(QuotationData.CoverStatus.ClaimAccepted);
9389             } else if (thresholdUnreached == 1 && (statusOrig == 5 || statusOrig == 3 || statusOrig == 1)) {
9390                 status = 11;
9391                 coverStatus = uint8(QuotationData.CoverStatus.ClaimDenied);
9392             }
9393 
9394             c1.setClaimStatus(claimid, status);
9395             qd.changeCoverStatusNo(coverid, uint8(coverStatus));
9396             // Reward/Punish Claim Assessors and Members who participated in Claims assessment
9397             _rewardAgainstClaim(claimid, coverid, sumAssured, status);
9398         }
9399     }
9400 
9401     /// @dev Allows a user to claim all pending  Claims assessment rewards.
9402     function _claimRewardToBeDistributed(uint _records) internal {
9403         uint lengthVote = cd.getVoteAddressCALength(msg.sender);
9404         uint voteid;
9405         uint lastIndex;
9406         (lastIndex, ) = cd.getRewardDistributedIndex(msg.sender);
9407         uint total = 0;
9408         uint tokenForVoteId = 0;
9409         bool lastClaimedCheck;
9410         uint _days = td.lockCADays();
9411         bool claimed;
9412         uint counter = 0;
9413         uint claimId;
9414         uint perc;
9415         uint i;
9416         uint lastClaimed = lengthVote;
9417 
9418         for (i = lastIndex; i < lengthVote && counter < _records; i++) {
9419             voteid = cd.getVoteAddressCA(msg.sender, i);
9420             (tokenForVoteId, lastClaimedCheck, , perc) = getRewardToBeGiven(1, voteid, 0);
9421             if (lastClaimed == lengthVote && lastClaimedCheck == true) {
9422                 lastClaimed = i;
9423             }
9424             (, claimId, , claimed) = cd.getVoteDetails(voteid);
9425 
9426             if (perc > 0 && !claimed) {
9427                 counter++;
9428                 cd.setRewardClaimed(voteid, true);
9429             } else if (perc == 0 && cd.getFinalVerdict(claimId) != 0 && !claimed) {
9430                 (perc, , ) = cd.getClaimRewardDetail(claimId);
9431                 if (perc == 0) {
9432                     counter++;
9433                 }
9434                 cd.setRewardClaimed(voteid, true);
9435             }
9436             if (tokenForVoteId > 0) {
9437                 total = tokenForVoteId.add(total);
9438             }
9439         }
9440         if (lastClaimed == lengthVote) {
9441             cd.setRewardDistributedIndexCA(msg.sender, i);
9442         }
9443         else {
9444             cd.setRewardDistributedIndexCA(msg.sender, lastClaimed);
9445         }
9446         lengthVote = cd.getVoteAddressMemberLength(msg.sender);
9447         lastClaimed = lengthVote;
9448         _days = _days.mul(counter);
9449         if (tc.tokensLockedAtTime(msg.sender, "CLA", now) > 0) {
9450             tc.reduceLock(msg.sender, "CLA", _days);
9451         }
9452         (, lastIndex) = cd.getRewardDistributedIndex(msg.sender);
9453         lastClaimed = lengthVote;
9454         counter = 0;
9455         for (i = lastIndex; i < lengthVote && counter < _records; i++) {
9456             voteid = cd.getVoteAddressMember(msg.sender, i);
9457             (tokenForVoteId, lastClaimedCheck, , ) = getRewardToBeGiven(0, voteid, 0);
9458             if (lastClaimed == lengthVote && lastClaimedCheck == true) {
9459                 lastClaimed = i;
9460             }
9461             (, claimId, , claimed) = cd.getVoteDetails(voteid);
9462             if (claimed == false && cd.getFinalVerdict(claimId) != 0) {
9463                 cd.setRewardClaimed(voteid, true);
9464                 counter++;
9465             }
9466             if (tokenForVoteId > 0) {
9467                 total = tokenForVoteId.add(total);
9468             }
9469         }
9470         if (total > 0) {
9471             require(tk.transfer(msg.sender, total));
9472         }
9473         if (lastClaimed == lengthVote) {
9474             cd.setRewardDistributedIndexMV(msg.sender, i);
9475         }
9476         else {
9477             cd.setRewardDistributedIndexMV(msg.sender, lastClaimed);
9478         }
9479     }
9480 
9481     /**
9482      * @dev Function used to claim the commission earned by the staker.
9483      */
9484     function _claimStakeCommission(uint _records, address _user) external onlyInternal {
9485         uint total=0;
9486         uint len = td.getStakerStakedContractLength(_user);
9487         uint lastCompletedStakeCommission = td.lastCompletedStakeCommission(_user);
9488         uint commissionEarned;
9489         uint commissionRedeemed;
9490         uint maxCommission;
9491         uint lastCommisionRedeemed = len;
9492         uint counter;
9493         uint i;
9494 
9495         for (i = lastCompletedStakeCommission; i < len && counter < _records; i++) {
9496             commissionRedeemed = td.getStakerRedeemedStakeCommission(_user, i);
9497             commissionEarned = td.getStakerEarnedStakeCommission(_user, i);
9498             maxCommission = td.getStakerInitialStakedAmountOnContract(
9499                 _user, i).mul(td.stakerMaxCommissionPer()).div(100);
9500             if (lastCommisionRedeemed == len && maxCommission != commissionEarned)
9501                 lastCommisionRedeemed = i;
9502             td.pushRedeemedStakeCommissions(_user, i, commissionEarned.sub(commissionRedeemed));
9503             total = total.add(commissionEarned.sub(commissionRedeemed));
9504             counter++;
9505         }
9506         if (lastCommisionRedeemed == len) {
9507             td.setLastCompletedStakeCommissionIndex(_user, i);
9508         } else {
9509             td.setLastCompletedStakeCommissionIndex(_user, lastCommisionRedeemed);
9510         }
9511 
9512         if (total > 0)
9513             require(tk.transfer(_user, total)); //solhint-disable-line
9514     }
9515 }
9516 
9517 /* Copyright (C) 2017 GovBlocks.io
9518   This program is free software: you can redistribute it and/or modify
9519     it under the terms of the GNU General Public License as published by
9520     the Free Software Foundation, either version 3 of the License, or
9521     (at your option) any later version.
9522   This program is distributed in the hope that it will be useful,
9523     but WITHOUT ANY WARRANTY; without even the implied warranty of
9524     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9525     GNU General Public License for more details.
9526   You should have received a copy of the GNU General Public License
9527     along with this program.  If not, see http://www.gnu.org/licenses/ */
9528 contract MemberRoles is IMemberRoles, Governed, Iupgradable {
9529 
9530     TokenController public dAppToken;
9531     TokenData internal td;
9532     QuotationData internal qd;
9533     ClaimsReward internal cr;
9534     Governance internal gv;
9535     TokenFunctions internal tf;
9536     NXMToken public tk;
9537 
9538     struct MemberRoleDetails {
9539         uint memberCounter;
9540         mapping(address => bool) memberActive;
9541         address[] memberAddress;
9542         address authorized;
9543     }
9544 
9545     enum Role {UnAssigned, AdvisoryBoard, Member, Owner}
9546 
9547     event switchedMembership(address indexed previousMember, address indexed newMember, uint timeStamp);
9548 
9549     MemberRoleDetails[] internal memberRoleData;
9550     bool internal constructorCheck;
9551     uint public maxABCount;
9552     bool public launched;
9553     uint public launchedOn;
9554     modifier checkRoleAuthority(uint _memberRoleId) {
9555         if (memberRoleData[_memberRoleId].authorized != address(0))
9556             require(msg.sender == memberRoleData[_memberRoleId].authorized);
9557         else
9558             require(isAuthorizedToGovern(msg.sender), "Not Authorized");
9559         _;
9560     }
9561 
9562     /**
9563      * @dev to swap advisory board member
9564      * @param _newABAddress is address of new AB member
9565      * @param _removeAB is advisory board member to be removed
9566      */
9567     function swapABMember (
9568         address _newABAddress,
9569         address _removeAB
9570     )
9571     external
9572     checkRoleAuthority(uint(Role.AdvisoryBoard)) {
9573 
9574         _updateRole(_newABAddress, uint(Role.AdvisoryBoard), true);
9575         _updateRole(_removeAB, uint(Role.AdvisoryBoard), false);
9576 
9577     }
9578 
9579     /**
9580      * @dev to swap the owner address
9581      * @param _newOwnerAddress is the new owner address
9582      */
9583     function swapOwner (
9584         address _newOwnerAddress
9585     )
9586     external {
9587         require(msg.sender == address(ms));
9588         _updateRole(ms.owner(), uint(Role.Owner), false);
9589         _updateRole(_newOwnerAddress, uint(Role.Owner), true);
9590     }
9591 
9592     /**
9593      * @dev is used to add initital advisory board members
9594      * @param abArray is the list of initial advisory board members
9595      */
9596     function addInitialABMembers(address[] calldata abArray) external onlyOwner {
9597 
9598         //Ensure that NXMaster has initialized.
9599         require(ms.masterInitialized());
9600 
9601         require(maxABCount >= 
9602             SafeMath.add(numberOfMembers(uint(Role.AdvisoryBoard)), abArray.length)
9603         );
9604         //AB count can't exceed maxABCount
9605         for (uint i = 0; i < abArray.length; i++) {
9606             require(checkRole(abArray[i], uint(MemberRoles.Role.Member)));
9607             _updateRole(abArray[i], uint(Role.AdvisoryBoard), true);   
9608         }
9609     }
9610 
9611     /**
9612      * @dev to change max number of AB members allowed
9613      * @param _val is the new value to be set
9614      */
9615     function changeMaxABCount(uint _val) external onlyInternal {
9616         maxABCount = _val;
9617     }
9618 
9619     /**
9620      * @dev Iupgradable Interface to update dependent contract address
9621      */
9622     function changeDependentContractAddress() public {
9623         td = TokenData(ms.getLatestAddress("TD"));
9624         cr = ClaimsReward(ms.getLatestAddress("CR"));
9625         qd = QuotationData(ms.getLatestAddress("QD"));
9626         gv = Governance(ms.getLatestAddress("GV"));
9627         tf = TokenFunctions(ms.getLatestAddress("TF"));
9628         tk = NXMToken(ms.tokenAddress());
9629         dAppToken = TokenController(ms.getLatestAddress("TC"));
9630     }
9631 
9632     /**
9633      * @dev to change the master address
9634      * @param _masterAddress is the new master address
9635      */
9636     function changeMasterAddress(address _masterAddress) public {
9637         if (masterAddress != address(0))
9638             require(masterAddress == msg.sender);
9639         masterAddress = _masterAddress;
9640         ms = INXMMaster(_masterAddress);
9641         nxMasterAddress = _masterAddress;
9642         
9643     }
9644     
9645     /**
9646      * @dev to initiate the member roles
9647      * @param _firstAB is the address of the first AB member
9648      * @param memberAuthority is the authority (role) of the member
9649      */
9650     function memberRolesInitiate (address _firstAB, address memberAuthority) public {
9651         require(!constructorCheck);
9652         _addInitialMemberRoles(_firstAB, memberAuthority);
9653         constructorCheck = true;
9654     }
9655 
9656     /// @dev Adds new member role
9657     /// @param _roleName New role name
9658     /// @param _roleDescription New description hash
9659     /// @param _authorized Authorized member against every role id
9660     function addRole( //solhint-disable-line
9661         bytes32 _roleName,
9662         string memory _roleDescription,
9663         address _authorized
9664     )
9665     public
9666     onlyAuthorizedToGovern {
9667         _addRole(_roleName, _roleDescription, _authorized);
9668     }
9669 
9670     /// @dev Assign or Delete a member from specific role.
9671     /// @param _memberAddress Address of Member
9672     /// @param _roleId RoleId to update
9673     /// @param _active active is set to be True if we want to assign this role to member, False otherwise!
9674     function updateRole( //solhint-disable-line
9675         address _memberAddress,
9676         uint _roleId,
9677         bool _active
9678     )
9679     public
9680     checkRoleAuthority(_roleId) {
9681         _updateRole(_memberAddress, _roleId, _active);
9682     }
9683 
9684     /**
9685      * @dev to add members before launch
9686      * @param userArray is list of addresses of members
9687      * @param tokens is list of tokens minted for each array element
9688      */
9689     function addMembersBeforeLaunch(address[] memory userArray, uint[] memory tokens) public onlyOwner {
9690         require(!launched);
9691 
9692         for (uint i=0; i < userArray.length; i++) {
9693             require(!ms.isMember(userArray[i]));
9694             dAppToken.addToWhitelist(userArray[i]);
9695             _updateRole(userArray[i], uint(Role.Member), true);
9696             dAppToken.mint(userArray[i], tokens[i]);
9697         }
9698         launched = true;
9699         launchedOn = now;
9700 
9701     }
9702 
9703    /** 
9704      * @dev Called by user to pay joining membership fee
9705      */ 
9706     function payJoiningFee(address _userAddress) public payable {
9707         require(_userAddress != address(0));
9708         require(!ms.isPause(), "Emergency Pause Applied");
9709         if (msg.sender == address(ms.getLatestAddress("QT"))) {
9710             require(td.walletAddress() != address(0), "No walletAddress present");
9711             dAppToken.addToWhitelist(_userAddress);
9712             _updateRole(_userAddress, uint(Role.Member), true);            
9713             td.walletAddress().transfer(msg.value); 
9714         } else {
9715             require(!qd.refundEligible(_userAddress));
9716             require(!ms.isMember(_userAddress));
9717             require(msg.value == td.joiningFee());
9718             qd.setRefundEligible(_userAddress, true);
9719         }
9720     }
9721 
9722     /**
9723      * @dev to perform kyc verdict
9724      * @param _userAddress whose kyc is being performed
9725      * @param verdict of kyc process
9726      */
9727     function kycVerdict(address payable _userAddress, bool verdict) public {
9728 
9729         require(msg.sender == qd.kycAuthAddress());
9730         require(!ms.isPause());
9731         require(_userAddress != address(0));
9732         require(!ms.isMember(_userAddress));
9733         require(qd.refundEligible(_userAddress));
9734         if (verdict) {
9735             qd.setRefundEligible(_userAddress, false);
9736             uint fee = td.joiningFee();
9737             dAppToken.addToWhitelist(_userAddress);
9738             _updateRole(_userAddress, uint(Role.Member), true);
9739             td.walletAddress().transfer(fee); //solhint-disable-line
9740             
9741         } else {
9742             qd.setRefundEligible(_userAddress, false);
9743             _userAddress.transfer(td.joiningFee()); //solhint-disable-line
9744         }
9745     }
9746 
9747     /**
9748      * @dev Called by existed member if wish to Withdraw membership.
9749      */
9750     function withdrawMembership() public {
9751         require(!ms.isPause() && ms.isMember(msg.sender));
9752         require(dAppToken.totalLockedBalance(msg.sender, now) == 0); //solhint-disable-line
9753         require(!tf.isLockedForMemberVote(msg.sender)); // No locked tokens for Member/Governance voting
9754         require(cr.getAllPendingRewardOfUser(msg.sender) == 0); // No pending reward to be claimed(claim assesment).
9755         require(dAppToken.tokensUnlockable(msg.sender, "CLA") == 0, "Member should have no CLA unlockable tokens");
9756         gv.removeDelegation(msg.sender);
9757         dAppToken.burnFrom(msg.sender, tk.balanceOf(msg.sender));
9758         _updateRole(msg.sender, uint(Role.Member), false);
9759         dAppToken.removeFromWhitelist(msg.sender); // need clarification on whitelist        
9760     }
9761 
9762 
9763     /**
9764      * @dev Called by existed member if wish to switch membership to other address.
9765      * @param _add address of user to forward membership.
9766      */
9767     function switchMembership(address _add) external {
9768         require(!ms.isPause() && ms.isMember(msg.sender) && !ms.isMember(_add));
9769         require(dAppToken.totalLockedBalance(msg.sender, now) == 0); //solhint-disable-line
9770         require(!tf.isLockedForMemberVote(msg.sender)); // No locked tokens for Member/Governance voting
9771         require(cr.getAllPendingRewardOfUser(msg.sender) == 0); // No pending reward to be claimed(claim assesment).
9772         require(dAppToken.tokensUnlockable(msg.sender, "CLA") == 0, "Member should have no CLA unlockable tokens");
9773         gv.removeDelegation(msg.sender);
9774         dAppToken.addToWhitelist(_add);
9775         _updateRole(_add, uint(Role.Member), true);
9776         tk.transferFrom(msg.sender, _add, tk.balanceOf(msg.sender));
9777         _updateRole(msg.sender, uint(Role.Member), false);
9778         dAppToken.removeFromWhitelist(msg.sender);
9779         emit switchedMembership(msg.sender, _add, now);
9780     }
9781 
9782     /// @dev Return number of member roles
9783     function totalRoles() public view returns(uint256) { //solhint-disable-line
9784         return memberRoleData.length;
9785     }
9786 
9787     /// @dev Change Member Address who holds the authority to Add/Delete any member from specific role.
9788     /// @param _roleId roleId to update its Authorized Address
9789     /// @param _newAuthorized New authorized address against role id
9790     function changeAuthorized(uint _roleId, address _newAuthorized) public checkRoleAuthority(_roleId) { //solhint-disable-line
9791         memberRoleData[_roleId].authorized = _newAuthorized;
9792     }
9793 
9794     /// @dev Gets the member addresses assigned by a specific role
9795     /// @param _memberRoleId Member role id
9796     /// @return roleId Role id
9797     /// @return allMemberAddress Member addresses of specified role id
9798     function members(uint _memberRoleId) public view returns(uint, address[] memory memberArray) { //solhint-disable-line
9799         uint length = memberRoleData[_memberRoleId].memberAddress.length;
9800         uint i;
9801         uint j = 0;
9802         memberArray = new address[](memberRoleData[_memberRoleId].memberCounter);
9803         for (i = 0; i < length; i++) {
9804             address member = memberRoleData[_memberRoleId].memberAddress[i];
9805             if (memberRoleData[_memberRoleId].memberActive[member] && !_checkMemberInArray(member, memberArray)) { //solhint-disable-line
9806                 memberArray[j] = member;
9807                 j++;
9808             }
9809         }
9810 
9811         return (_memberRoleId, memberArray);
9812     }
9813 
9814     /// @dev Gets all members' length
9815     /// @param _memberRoleId Member role id
9816     /// @return memberRoleData[_memberRoleId].memberCounter Member length
9817     function numberOfMembers(uint _memberRoleId) public view returns(uint) { //solhint-disable-line
9818         return memberRoleData[_memberRoleId].memberCounter;
9819     }
9820 
9821     /// @dev Return member address who holds the right to add/remove any member from specific role.
9822     function authorized(uint _memberRoleId) public view returns(address) { //solhint-disable-line
9823         return memberRoleData[_memberRoleId].authorized;
9824     }
9825 
9826     /// @dev Get All role ids array that has been assigned to a member so far.
9827     function roles(address _memberAddress) public view returns(uint[] memory) { //solhint-disable-line
9828         uint length = memberRoleData.length;
9829         uint[] memory assignedRoles = new uint[](length);
9830         uint counter = 0; 
9831         for (uint i = 1; i < length; i++) {
9832             if (memberRoleData[i].memberActive[_memberAddress]) {
9833                 assignedRoles[counter] = i;
9834                 counter++;
9835             }
9836         }
9837         return assignedRoles;
9838     }
9839 
9840     /// @dev Returns true if the given role id is assigned to a member.
9841     /// @param _memberAddress Address of member
9842     /// @param _roleId Checks member's authenticity with the roleId.
9843     /// i.e. Returns true if this roleId is assigned to member
9844     function checkRole(address _memberAddress, uint _roleId) public view returns(bool) { //solhint-disable-line
9845         if (_roleId == uint(Role.UnAssigned))
9846             return true;
9847         else
9848             if (memberRoleData[_roleId].memberActive[_memberAddress]) //solhint-disable-line
9849                 return true;
9850             else
9851                 return false;
9852     }
9853 
9854     /// @dev Return total number of members assigned against each role id.
9855     /// @return totalMembers Total members in particular role id
9856     function getMemberLengthForAllRoles() public view returns(uint[] memory totalMembers) { //solhint-disable-line
9857         totalMembers = new uint[](memberRoleData.length);
9858         for (uint i = 0; i < memberRoleData.length; i++) {
9859             totalMembers[i] = numberOfMembers(i);
9860         }
9861     }
9862 
9863     /**
9864      * @dev to update the member roles
9865      * @param _memberAddress in concern
9866      * @param _roleId the id of role
9867      * @param _active if active is true, add the member, else remove it 
9868      */
9869     function _updateRole(address _memberAddress,
9870         uint _roleId,
9871         bool _active) internal {
9872         // require(_roleId != uint(Role.TokenHolder), "Membership to Token holder is detected automatically");
9873         if (_active) {
9874             require(!memberRoleData[_roleId].memberActive[_memberAddress]);
9875             memberRoleData[_roleId].memberCounter = SafeMath.add(memberRoleData[_roleId].memberCounter, 1);
9876             memberRoleData[_roleId].memberActive[_memberAddress] = true;
9877             memberRoleData[_roleId].memberAddress.push(_memberAddress);
9878         } else {
9879             require(memberRoleData[_roleId].memberActive[_memberAddress]);
9880             memberRoleData[_roleId].memberCounter = SafeMath.sub(memberRoleData[_roleId].memberCounter, 1);
9881             delete memberRoleData[_roleId].memberActive[_memberAddress];
9882         }
9883     }
9884 
9885     /// @dev Adds new member role
9886     /// @param _roleName New role name
9887     /// @param _roleDescription New description hash
9888     /// @param _authorized Authorized member against every role id
9889     function _addRole(
9890         bytes32 _roleName,
9891         string memory _roleDescription,
9892         address _authorized
9893     ) internal {
9894         emit MemberRole(memberRoleData.length, _roleName, _roleDescription);
9895         memberRoleData.push(MemberRoleDetails(0, new address[](0), _authorized));
9896     }
9897 
9898     /**
9899      * @dev to check if member is in the given member array
9900      * @param _memberAddress in concern
9901      * @param memberArray in concern
9902      * @return boolean to represent the presence
9903      */
9904     function _checkMemberInArray(
9905         address _memberAddress,
9906         address[] memory memberArray
9907     )
9908         internal
9909         pure
9910         returns(bool memberExists)
9911     {
9912         uint i;
9913         for (i = 0; i < memberArray.length; i++) {
9914             if (memberArray[i] == _memberAddress) {
9915                 memberExists = true;
9916                 break;
9917             }
9918         }
9919     }
9920 
9921     /**
9922      * @dev to add initial member roles
9923      * @param _firstAB is the member address to be added
9924      * @param memberAuthority is the member authority(role) to be added for
9925      */
9926     function _addInitialMemberRoles(address _firstAB, address memberAuthority) internal {
9927         maxABCount = 5;
9928         _addRole("Unassigned", "Unassigned", address(0));
9929         _addRole(
9930             "Advisory Board",
9931             "Selected few members that are deeply entrusted by the dApp. An ideal advisory board should be a mix of skills of domain, governance, research, technology, consulting etc to improve the performance of the dApp.", //solhint-disable-line
9932             address(0)
9933         );
9934         _addRole(
9935             "Member",
9936             "Represents all users of Mutual.", //solhint-disable-line
9937             memberAuthority
9938         );
9939         _addRole(
9940             "Owner",
9941             "Represents Owner of Mutual.", //solhint-disable-line
9942             address(0)
9943         );
9944         // _updateRole(_firstAB, uint(Role.AdvisoryBoard), true);
9945         _updateRole(_firstAB, uint(Role.Owner), true);
9946         // _updateRole(_firstAB, uint(Role.Member), true);
9947         launchedOn = 0;
9948     }
9949 
9950     function memberAtIndex(uint _memberRoleId, uint index) external view returns (address, bool) {
9951         address memberAddress = memberRoleData[_memberRoleId].memberAddress[index];
9952         return (memberAddress, memberRoleData[_memberRoleId].memberActive[memberAddress]);
9953     }
9954 
9955     function membersLength(uint _memberRoleId) external view returns (uint) {
9956         return memberRoleData[_memberRoleId].memberAddress.length;
9957     }
9958 }
9959 
9960 /* Copyright (C) 2017 GovBlocks.io
9961   This program is free software: you can redistribute it and/or modify
9962     it under the terms of the GNU General Public License as published by
9963     the Free Software Foundation, either version 3 of the License, or
9964     (at your option) any later version.
9965   This program is distributed in the hope that it will be useful,
9966     but WITHOUT ANY WARRANTY; without even the implied warranty of
9967     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9968     GNU General Public License for more details.
9969   You should have received a copy of the GNU General Public License
9970     along with this program.  If not, see http://www.gnu.org/licenses/ */
9971 contract ProposalCategory is  Governed, IProposalCategory, Iupgradable {
9972 
9973     bool public constructorCheck;
9974     MemberRoles internal mr;
9975 
9976     struct CategoryStruct {
9977         uint memberRoleToVote;
9978         uint majorityVotePerc;
9979         uint quorumPerc;
9980         uint[] allowedToCreateProposal;
9981         uint closingTime;
9982         uint minStake;
9983     }
9984 
9985     struct CategoryAction {
9986         uint defaultIncentive;
9987         address contractAddress;
9988         bytes2 contractName;
9989     }
9990     
9991     CategoryStruct[] internal allCategory;
9992     mapping (uint => CategoryAction) internal categoryActionData;
9993     mapping (uint => uint) public categoryABReq;
9994     mapping (uint => uint) public isSpecialResolution;
9995     mapping (uint => bytes) public categoryActionHashes;
9996 
9997     bool public categoryActionHashUpdated;
9998 
9999     /**
10000     * @dev Restricts calls to deprecated functions
10001     */
10002     modifier deprecated() {
10003         revert("Function deprecated");
10004         _;
10005     }
10006 
10007     /**
10008     * @dev Adds new category (Discontinued, moved functionality to newCategory)
10009     * @param _name Category name
10010     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
10011     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
10012     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
10013     * @param _allowedToCreateProposal Member roles allowed to create the proposal
10014     * @param _closingTime Vote closing time for Each voting layer
10015     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
10016     * @param _contractAddress address of contract to call after proposal is accepted
10017     * @param _contractName name of contract to be called after proposal is accepted
10018     * @param _incentives rewards to distributed after proposal is accepted
10019     */
10020     function addCategory(
10021         string calldata _name, 
10022         uint _memberRoleToVote,
10023         uint _majorityVotePerc, 
10024         uint _quorumPerc,
10025         uint[] calldata _allowedToCreateProposal,
10026         uint _closingTime,
10027         string calldata _actionHash,
10028         address _contractAddress,
10029         bytes2 _contractName,
10030         uint[] calldata _incentives
10031     ) 
10032         external
10033         deprecated 
10034     {
10035     }
10036 
10037     /**
10038     * @dev Initiates Default settings for Proposal Category contract (Adding default categories)
10039     */
10040     function proposalCategoryInitiate() external deprecated { //solhint-disable-line
10041     }
10042 
10043     /**
10044     * @dev Initiates Default action function hashes for existing categories
10045     * To be called after the contract has been upgraded by governance
10046     */
10047     function updateCategoryActionHashes() external onlyOwner {
10048 
10049         require(!categoryActionHashUpdated, "Category action hashes already updated");
10050         categoryActionHashUpdated = true;
10051         categoryActionHashes[1] = abi.encodeWithSignature("addRole(bytes32,string,address)");
10052         categoryActionHashes[2] = abi.encodeWithSignature("updateRole(address,uint256,bool)");
10053         categoryActionHashes[3] = abi.encodeWithSignature("newCategory(string,uint256,uint256,uint256,uint256[],uint256,string,address,bytes2,uint256[],string)");//solhint-disable-line
10054         categoryActionHashes[4] = abi.encodeWithSignature("editCategory(uint256,string,uint256,uint256,uint256,uint256[],uint256,string,address,bytes2,uint256[],string)");//solhint-disable-line
10055         categoryActionHashes[5] = abi.encodeWithSignature("upgradeContractImplementation(bytes2,address)");
10056         categoryActionHashes[6] = abi.encodeWithSignature("startEmergencyPause()");
10057         categoryActionHashes[7] = abi.encodeWithSignature("addEmergencyPause(bool,bytes4)");
10058         categoryActionHashes[8] = abi.encodeWithSignature("burnCAToken(uint256,uint256,address)");
10059         categoryActionHashes[9] = abi.encodeWithSignature("setUserClaimVotePausedOn(address)");
10060         categoryActionHashes[12] = abi.encodeWithSignature("transferEther(uint256,address)");
10061         categoryActionHashes[13] = abi.encodeWithSignature("addInvestmentAssetCurrency(bytes4,address,bool,uint64,uint64,uint8)");//solhint-disable-line
10062         categoryActionHashes[14] = abi.encodeWithSignature("changeInvestmentAssetHoldingPerc(bytes4,uint64,uint64)");
10063         categoryActionHashes[15] = abi.encodeWithSignature("changeInvestmentAssetStatus(bytes4,bool)");
10064         categoryActionHashes[16] = abi.encodeWithSignature("swapABMember(address,address)");
10065         categoryActionHashes[17] = abi.encodeWithSignature("addCurrencyAssetCurrency(bytes4,address,uint256)");
10066         categoryActionHashes[20] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
10067         categoryActionHashes[21] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
10068         categoryActionHashes[22] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
10069         categoryActionHashes[23] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
10070         categoryActionHashes[24] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
10071         categoryActionHashes[25] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
10072         categoryActionHashes[26] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
10073         categoryActionHashes[27] = abi.encodeWithSignature("updateAddressParameters(bytes8,address)");
10074         categoryActionHashes[28] = abi.encodeWithSignature("updateOwnerParameters(bytes8,address)");
10075         categoryActionHashes[29] = abi.encodeWithSignature("upgradeContract(bytes2,address)");
10076         categoryActionHashes[30] = abi.encodeWithSignature("changeCurrencyAssetAddress(bytes4,address)");
10077         categoryActionHashes[31] = abi.encodeWithSignature("changeCurrencyAssetBaseMin(bytes4,uint256)");
10078         categoryActionHashes[32] = abi.encodeWithSignature("changeInvestmentAssetAddressAndDecimal(bytes4,address,uint8)");//solhint-disable-line
10079         categoryActionHashes[33] = abi.encodeWithSignature("externalLiquidityTrade()");
10080     }
10081 
10082     /**
10083     * @dev Gets Total number of categories added till now
10084     */
10085     function totalCategories() external view returns(uint) {
10086         return allCategory.length;
10087     }
10088 
10089     /**
10090     * @dev Gets category details
10091     */
10092     function category(uint _categoryId) external view returns(uint, uint, uint, uint, uint[] memory, uint, uint) {
10093         return(
10094             _categoryId,
10095             allCategory[_categoryId].memberRoleToVote,
10096             allCategory[_categoryId].majorityVotePerc,
10097             allCategory[_categoryId].quorumPerc,
10098             allCategory[_categoryId].allowedToCreateProposal,
10099             allCategory[_categoryId].closingTime,
10100             allCategory[_categoryId].minStake
10101         );
10102     }
10103 
10104     /**
10105     * @dev Gets category ab required and isSpecialResolution
10106     * @return the category id
10107     * @return if AB voting is required
10108     * @return is category a special resolution
10109     */
10110     function categoryExtendedData(uint _categoryId) external view returns(uint, uint, uint) {
10111         return(
10112             _categoryId,
10113             categoryABReq[_categoryId],
10114             isSpecialResolution[_categoryId]
10115         );
10116     }
10117 
10118     /**
10119      * @dev Gets the category acion details
10120      * @param _categoryId is the category id in concern
10121      * @return the category id
10122      * @return the contract address
10123      * @return the contract name
10124      * @return the default incentive
10125      */
10126     function categoryAction(uint _categoryId) external view returns(uint, address, bytes2, uint) {
10127 
10128         return(
10129             _categoryId,
10130             categoryActionData[_categoryId].contractAddress,
10131             categoryActionData[_categoryId].contractName,
10132             categoryActionData[_categoryId].defaultIncentive
10133         );
10134     }
10135 
10136     /**
10137      * @dev Gets the category acion details of a category id 
10138      * @param _categoryId is the category id in concern
10139      * @return the category id
10140      * @return the contract address
10141      * @return the contract name
10142      * @return the default incentive
10143      * @return action function hash
10144      */
10145     function categoryActionDetails(uint _categoryId) external view returns(uint, address, bytes2, uint, bytes memory) {
10146         return(
10147             _categoryId,
10148             categoryActionData[_categoryId].contractAddress,
10149             categoryActionData[_categoryId].contractName,
10150             categoryActionData[_categoryId].defaultIncentive,
10151             categoryActionHashes[_categoryId]
10152         );
10153     }
10154 
10155     /**
10156     * @dev Updates dependant contract addresses
10157     */
10158     function changeDependentContractAddress() public {
10159         mr = MemberRoles(ms.getLatestAddress("MR"));
10160     }
10161 
10162     /**
10163     * @dev Adds new category
10164     * @param _name Category name
10165     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
10166     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
10167     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
10168     * @param _allowedToCreateProposal Member roles allowed to create the proposal
10169     * @param _closingTime Vote closing time for Each voting layer
10170     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
10171     * @param _contractAddress address of contract to call after proposal is accepted
10172     * @param _contractName name of contract to be called after proposal is accepted
10173     * @param _incentives rewards to distributed after proposal is accepted
10174     * @param _functionHash function signature to be executed
10175     */
10176     function newCategory(
10177         string memory _name, 
10178         uint _memberRoleToVote,
10179         uint _majorityVotePerc, 
10180         uint _quorumPerc,
10181         uint[] memory _allowedToCreateProposal,
10182         uint _closingTime,
10183         string memory _actionHash,
10184         address _contractAddress,
10185         bytes2 _contractName,
10186         uint[] memory _incentives,
10187         string memory _functionHash
10188     ) 
10189         public
10190         onlyAuthorizedToGovern 
10191     {
10192 
10193         require(_quorumPerc <= 100 && _majorityVotePerc <= 100, "Invalid percentage");
10194 
10195         require((_contractName == "EX" && _contractAddress == address(0)) || bytes(_functionHash).length > 0);
10196         
10197         require(_incentives[3] <= 1, "Invalid special resolution flag");
10198         
10199         //If category is special resolution role authorized should be member
10200         if (_incentives[3] == 1) {
10201             require(_memberRoleToVote == uint(MemberRoles.Role.Member));
10202             _majorityVotePerc = 0;
10203             _quorumPerc = 0;
10204         }
10205 
10206         _addCategory(
10207             _name, 
10208             _memberRoleToVote,
10209             _majorityVotePerc, 
10210             _quorumPerc,
10211             _allowedToCreateProposal,
10212             _closingTime,
10213             _actionHash,
10214             _contractAddress,
10215             _contractName,
10216             _incentives
10217         );
10218 
10219 
10220         if (bytes(_functionHash).length > 0 && abi.encodeWithSignature(_functionHash).length == 4) {
10221             categoryActionHashes[allCategory.length - 1] = abi.encodeWithSignature(_functionHash);
10222         }
10223     }
10224 
10225     /**
10226      * @dev Changes the master address and update it's instance
10227      * @param _masterAddress is the new master address
10228      */
10229     function changeMasterAddress(address _masterAddress) public {
10230         if (masterAddress != address(0))
10231             require(masterAddress == msg.sender);
10232         masterAddress = _masterAddress;
10233         ms = INXMMaster(_masterAddress);
10234         nxMasterAddress = _masterAddress;
10235         
10236     }
10237 
10238     /**
10239     * @dev Updates category details (Discontinued, moved functionality to editCategory)
10240     * @param _categoryId Category id that needs to be updated
10241     * @param _name Category name
10242     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
10243     * @param _allowedToCreateProposal Member roles allowed to create the proposal
10244     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
10245     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
10246     * @param _closingTime Vote closing time for Each voting layer
10247     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
10248     * @param _contractAddress address of contract to call after proposal is accepted
10249     * @param _contractName name of contract to be called after proposal is accepted
10250     * @param _incentives rewards to distributed after proposal is accepted
10251     */
10252     function updateCategory(
10253         uint _categoryId, 
10254         string memory _name, 
10255         uint _memberRoleToVote, 
10256         uint _majorityVotePerc, 
10257         uint _quorumPerc,
10258         uint[] memory _allowedToCreateProposal,
10259         uint _closingTime,
10260         string memory _actionHash,
10261         address _contractAddress,
10262         bytes2 _contractName,
10263         uint[] memory _incentives
10264     )
10265         public
10266         deprecated
10267     {
10268     }
10269 
10270     /**
10271     * @dev Updates category details
10272     * @param _categoryId Category id that needs to be updated
10273     * @param _name Category name
10274     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
10275     * @param _allowedToCreateProposal Member roles allowed to create the proposal
10276     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
10277     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
10278     * @param _closingTime Vote closing time for Each voting layer
10279     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
10280     * @param _contractAddress address of contract to call after proposal is accepted
10281     * @param _contractName name of contract to be called after proposal is accepted
10282     * @param _incentives rewards to distributed after proposal is accepted
10283     * @param _functionHash function signature to be executed
10284     */
10285     function editCategory(
10286         uint _categoryId, 
10287         string memory _name, 
10288         uint _memberRoleToVote, 
10289         uint _majorityVotePerc, 
10290         uint _quorumPerc,
10291         uint[] memory _allowedToCreateProposal,
10292         uint _closingTime,
10293         string memory _actionHash,
10294         address _contractAddress,
10295         bytes2 _contractName,
10296         uint[] memory _incentives,
10297         string memory _functionHash
10298     )
10299         public
10300         onlyAuthorizedToGovern
10301     {
10302         require(_verifyMemberRoles(_memberRoleToVote, _allowedToCreateProposal) == 1, "Invalid Role");
10303 
10304         require(_quorumPerc <= 100 && _majorityVotePerc <= 100, "Invalid percentage");
10305 
10306         require((_contractName == "EX" && _contractAddress == address(0)) || bytes(_functionHash).length > 0);
10307 
10308         require(_incentives[3] <= 1, "Invalid special resolution flag");
10309         
10310         //If category is special resolution role authorized should be member
10311         if (_incentives[3] == 1) {
10312             require(_memberRoleToVote == uint(MemberRoles.Role.Member));
10313             _majorityVotePerc = 0;
10314             _quorumPerc = 0;
10315         }
10316 
10317         delete categoryActionHashes[_categoryId];
10318         if (bytes(_functionHash).length > 0 && abi.encodeWithSignature(_functionHash).length == 4) {
10319             categoryActionHashes[_categoryId] = abi.encodeWithSignature(_functionHash);
10320         }
10321         allCategory[_categoryId].memberRoleToVote = _memberRoleToVote;
10322         allCategory[_categoryId].majorityVotePerc = _majorityVotePerc;
10323         allCategory[_categoryId].closingTime = _closingTime;
10324         allCategory[_categoryId].allowedToCreateProposal = _allowedToCreateProposal;
10325         allCategory[_categoryId].minStake = _incentives[0];
10326         allCategory[_categoryId].quorumPerc = _quorumPerc;
10327         categoryActionData[_categoryId].defaultIncentive = _incentives[1];
10328         categoryActionData[_categoryId].contractName = _contractName;
10329         categoryActionData[_categoryId].contractAddress = _contractAddress;
10330         categoryABReq[_categoryId] = _incentives[2];
10331         isSpecialResolution[_categoryId] = _incentives[3];
10332         emit Category(_categoryId, _name, _actionHash);
10333     }
10334 
10335     /**
10336     * @dev Internal call to add new category
10337     * @param _name Category name
10338     * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
10339     * @param _majorityVotePerc Majority Vote threshold for Each voting layer
10340     * @param _quorumPerc minimum threshold percentage required in voting to calculate result
10341     * @param _allowedToCreateProposal Member roles allowed to create the proposal
10342     * @param _closingTime Vote closing time for Each voting layer
10343     * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
10344     * @param _contractAddress address of contract to call after proposal is accepted
10345     * @param _contractName name of contract to be called after proposal is accepted
10346     * @param _incentives rewards to distributed after proposal is accepted
10347     */
10348     function _addCategory(
10349         string memory _name, 
10350         uint _memberRoleToVote,
10351         uint _majorityVotePerc, 
10352         uint _quorumPerc,
10353         uint[] memory _allowedToCreateProposal,
10354         uint _closingTime,
10355         string memory _actionHash,
10356         address _contractAddress,
10357         bytes2 _contractName,
10358         uint[] memory _incentives
10359     ) 
10360         internal
10361     {
10362         require(_verifyMemberRoles(_memberRoleToVote, _allowedToCreateProposal) == 1, "Invalid Role");
10363         allCategory.push(
10364             CategoryStruct(
10365                 _memberRoleToVote,
10366                 _majorityVotePerc,
10367                 _quorumPerc,
10368                 _allowedToCreateProposal,
10369                 _closingTime,
10370                 _incentives[0]
10371             )
10372         );
10373         uint categoryId = allCategory.length - 1;
10374         categoryActionData[categoryId] = CategoryAction(_incentives[1], _contractAddress, _contractName);
10375         categoryABReq[categoryId] = _incentives[2];
10376         isSpecialResolution[categoryId] = _incentives[3];
10377         emit Category(categoryId, _name, _actionHash);
10378     }
10379 
10380     /**
10381     * @dev Internal call to check if given roles are valid or not
10382     */
10383     function _verifyMemberRoles(uint _memberRoleToVote, uint[] memory _allowedToCreateProposal) 
10384     internal view returns(uint) { 
10385         uint totalRoles = mr.totalRoles();
10386         if (_memberRoleToVote >= totalRoles) {
10387             return 0;
10388         }
10389         for (uint i = 0; i < _allowedToCreateProposal.length; i++) {
10390             if (_allowedToCreateProposal[i] >= totalRoles) {
10391                 return 0;
10392             }
10393         }
10394         return 1;
10395     }
10396 
10397 }
10398 
10399 /* Copyright (C) 2017 GovBlocks.io
10400 
10401   This program is free software: you can redistribute it and/or modify
10402     it under the terms of the GNU General Public License as published by
10403     the Free Software Foundation, either version 3 of the License, or
10404     (at your option) any later version.
10405 
10406   This program is distributed in the hope that it will be useful,
10407     but WITHOUT ANY WARRANTY; without even the implied warranty of
10408     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10409     GNU General Public License for more details.
10410 
10411   You should have received a copy of the GNU General Public License
10412     along with this program.  If not, see http://www.gnu.org/licenses/ */
10413 contract IGovernance { 
10414 
10415     event Proposal(
10416         address indexed proposalOwner,
10417         uint256 indexed proposalId,
10418         uint256 dateAdd,
10419         string proposalTitle,
10420         string proposalSD,
10421         string proposalDescHash
10422     );
10423 
10424     event Solution(
10425         uint256 indexed proposalId,
10426         address indexed solutionOwner,
10427         uint256 indexed solutionId,
10428         string solutionDescHash,
10429         uint256 dateAdd
10430     );
10431 
10432     event Vote(
10433         address indexed from,
10434         uint256 indexed proposalId,
10435         uint256 indexed voteId,
10436         uint256 dateAdd,
10437         uint256 solutionChosen
10438     );
10439 
10440     event RewardClaimed(
10441         address indexed member,
10442         uint gbtReward
10443     );
10444 
10445     /// @dev VoteCast event is called whenever a vote is cast that can potentially close the proposal. 
10446     event VoteCast (uint256 proposalId);
10447 
10448     /// @dev ProposalAccepted event is called when a proposal is accepted so that a server can listen that can 
10449     ///      call any offchain actions
10450     event ProposalAccepted (uint256 proposalId);
10451 
10452     /// @dev CloseProposalOnTime event is called whenever a proposal is created or updated to close it on time.
10453     event CloseProposalOnTime (
10454         uint256 indexed proposalId,
10455         uint256 time
10456     );
10457 
10458     /// @dev ActionSuccess event is called whenever an onchain action is executed.
10459     event ActionSuccess (
10460         uint256 proposalId
10461     );
10462 
10463     /// @dev Creates a new proposal
10464     /// @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
10465     /// @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
10466     function createProposal(
10467         string calldata _proposalTitle,
10468         string calldata _proposalSD,
10469         string calldata _proposalDescHash,
10470         uint _categoryId
10471     ) 
10472         external;
10473 
10474     /// @dev Edits the details of an existing proposal and creates new version
10475     /// @param _proposalId Proposal id that details needs to be updated
10476     /// @param _proposalDescHash Proposal description hash having long and short description of proposal.
10477     function updateProposal(
10478         uint _proposalId, 
10479         string calldata _proposalTitle, 
10480         string calldata _proposalSD, 
10481         string calldata _proposalDescHash
10482     ) 
10483         external;
10484 
10485     /// @dev Categorizes proposal to proceed further. Categories shows the proposal objective.
10486     function categorizeProposal(
10487         uint _proposalId, 
10488         uint _categoryId,
10489         uint _incentives
10490     ) 
10491         external;
10492 
10493     /// @dev Initiates add solution 
10494     /// @param _solutionHash Solution hash having required data against adding solution
10495     function addSolution(
10496         uint _proposalId,
10497         string calldata _solutionHash, 
10498         bytes calldata _action
10499     ) 
10500         external; 
10501 
10502     /// @dev Opens proposal for voting
10503     function openProposalForVoting(uint _proposalId) external;
10504 
10505     /// @dev Submit proposal with solution
10506     /// @param _proposalId Proposal id
10507     /// @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
10508     function submitProposalWithSolution(
10509         uint _proposalId, 
10510         string calldata _solutionHash, 
10511         bytes calldata _action
10512     ) 
10513         external;
10514 
10515     /// @dev Creates a new proposal with solution and votes for the solution
10516     /// @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
10517     /// @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
10518     /// @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
10519     function createProposalwithSolution(
10520         string calldata _proposalTitle, 
10521         string calldata _proposalSD, 
10522         string calldata _proposalDescHash,
10523         uint _categoryId, 
10524         string calldata _solutionHash, 
10525         bytes calldata _action
10526     ) 
10527         external;
10528 
10529     /// @dev Casts vote
10530     /// @param _proposalId Proposal id
10531     /// @param _solutionChosen solution chosen while voting. _solutionChosen[0] is the chosen solution
10532     function submitVote(uint _proposalId, uint _solutionChosen) external;
10533 
10534     function closeProposal(uint _proposalId) external;
10535 
10536     function claimReward(address _memberAddress, uint _maxRecords) external returns(uint pendingDAppReward); 
10537 
10538     function proposal(uint _proposalId)
10539         external
10540         view
10541         returns(
10542             uint proposalId,
10543             uint category,
10544             uint status,
10545             uint finalVerdict,
10546             uint totalReward
10547         );
10548 
10549     function canCloseProposal(uint _proposalId) public view returns(uint closeValue);
10550 
10551     function pauseProposal(uint _proposalId) public;
10552     
10553     function resumeProposal(uint _proposalId) public;
10554     
10555     function allowedToCatgorize() public view returns(uint roleId);
10556 
10557 }
10558 
10559 // /* Copyright (C) 2017 GovBlocks.io
10560 //   This program is free software: you can redistribute it and/or modify
10561 //     it under the terms of the GNU General Public License as published by
10562 //     the Free Software Foundation, either version 3 of the License, or
10563 //     (at your option) any later version.
10564 //   This program is distributed in the hope that it will be useful,
10565 //     but WITHOUT ANY WARRANTY; without even the implied warranty of
10566 //     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10567 //     GNU General Public License for more details.
10568 //   You should have received a copy of the GNU General Public License
10569 //     along with this program.  If not, see http://www.gnu.org/licenses/ */
10570 contract Governance is IGovernance, Iupgradable {
10571 
10572     using SafeMath for uint;
10573 
10574     enum ProposalStatus { 
10575         Draft,
10576         AwaitingSolution,
10577         VotingStarted,
10578         Accepted,
10579         Rejected,
10580         Majority_Not_Reached_But_Accepted,
10581         Denied
10582     }
10583 
10584     struct ProposalData {
10585         uint propStatus;
10586         uint finalVerdict;
10587         uint category;
10588         uint commonIncentive;
10589         uint dateUpd;
10590         address owner;
10591     }
10592 
10593     struct ProposalVote {
10594         address voter;
10595         uint proposalId;
10596         uint dateAdd;
10597     }
10598 
10599     struct VoteTally {
10600         mapping(uint=>uint) memberVoteValue;
10601         mapping(uint=>uint) abVoteValue;
10602         uint voters;
10603     }
10604 
10605     struct DelegateVote {
10606         address follower;
10607         address leader;
10608         uint lastUpd;
10609     }
10610 
10611     ProposalVote[] internal allVotes;
10612     DelegateVote[] public allDelegation;
10613 
10614     mapping(uint => ProposalData) internal allProposalData;
10615     mapping(uint => bytes[]) internal allProposalSolutions;
10616     mapping(address => uint[]) internal allVotesByMember;
10617     mapping(uint => mapping(address => bool)) public rewardClaimed;
10618     mapping (address => mapping(uint => uint)) public memberProposalVote;
10619     mapping (address => uint) public followerDelegation;
10620     mapping (address => uint) internal followerCount;
10621     mapping (address => uint[]) internal leaderDelegation;
10622     mapping (uint => VoteTally) public proposalVoteTally;
10623     mapping (address => bool) public isOpenForDelegation;
10624     mapping (address => uint) public lastRewardClaimed;
10625 
10626     bool internal constructorCheck;
10627     uint public tokenHoldingTime;
10628     uint internal roleIdAllowedToCatgorize;
10629     uint internal maxVoteWeigthPer;
10630     uint internal specialResolutionMajPerc;
10631     uint internal maxFollowers;
10632     uint internal totalProposals;
10633     uint internal maxDraftTime;
10634 
10635     MemberRoles internal memberRole;
10636     ProposalCategory internal proposalCategory;
10637     TokenController internal tokenInstance;
10638 
10639     mapping(uint => uint) public proposalActionStatus;
10640     mapping(uint => uint) internal proposalExecutionTime;
10641     mapping(uint => mapping(address => bool)) public proposalRejectedByAB;
10642     mapping(uint => uint) internal actionRejectedCount;
10643 
10644     bool internal actionParamsInitialised;
10645     uint internal actionWaitingTime;
10646     uint constant internal AB_MAJ_TO_REJECT_ACTION = 3;
10647 
10648     enum ActionStatus {
10649         Pending,
10650         Accepted,
10651         Rejected,
10652         Executed,
10653         NoAction
10654     }
10655 
10656     /**
10657     * @dev Called whenever an action execution is failed.
10658     */
10659     event ActionFailed (
10660         uint256 proposalId
10661     );
10662 
10663     /**
10664     * @dev Called whenever an AB member rejects the action execution.
10665     */
10666     event ActionRejected (
10667         uint256 indexed proposalId,
10668         address rejectedBy
10669     );
10670 
10671     /**
10672     * @dev Checks if msg.sender is proposal owner
10673     */
10674     modifier onlyProposalOwner(uint _proposalId) {
10675         require(msg.sender == allProposalData[_proposalId].owner, "Not allowed");
10676         _;
10677     }
10678 
10679     /**
10680     * @dev Checks if proposal is opened for voting
10681     */
10682     modifier voteNotStarted(uint _proposalId) {
10683         require(allProposalData[_proposalId].propStatus < uint(ProposalStatus.VotingStarted));
10684         _;
10685     }
10686 
10687     /**
10688     * @dev Checks if msg.sender is allowed to create proposal under given category
10689     */
10690     modifier isAllowed(uint _categoryId) {
10691         require(allowedToCreateProposal(_categoryId), "Not allowed");
10692         _;
10693     }
10694 
10695     /**
10696     * @dev Checks if msg.sender is allowed categorize proposal under given category
10697     */
10698     modifier isAllowedToCategorize() {
10699         require(memberRole.checkRole(msg.sender, roleIdAllowedToCatgorize), "Not allowed");
10700         _;
10701     }
10702 
10703     /**
10704     * @dev Checks if msg.sender had any pending rewards to be claimed
10705     */
10706     modifier checkPendingRewards {
10707         require(getPendingReward(msg.sender) == 0, "Claim reward");
10708         _;
10709     }
10710 
10711     /**
10712     * @dev Event emitted whenever a proposal is categorized
10713     */
10714     event ProposalCategorized(
10715         uint indexed proposalId,
10716         address indexed categorizedBy,
10717         uint categoryId
10718     );
10719     
10720     /**
10721      * @dev Removes delegation of an address.
10722      * @param _add address to undelegate.
10723      */
10724     function removeDelegation(address _add) external onlyInternal {
10725         _unDelegate(_add);
10726     }
10727 
10728     /**
10729     * @dev Creates a new proposal
10730     * @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
10731     * @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
10732     */
10733     function createProposal(
10734         string calldata _proposalTitle, 
10735         string calldata _proposalSD, 
10736         string calldata _proposalDescHash, 
10737         uint _categoryId
10738     ) 
10739         external isAllowed(_categoryId)
10740     {
10741         require(ms.isMember(msg.sender), "Not Member");
10742 
10743         _createProposal(_proposalTitle, _proposalSD, _proposalDescHash, _categoryId);
10744     }
10745 
10746     /**
10747     * @dev Edits the details of an existing proposal
10748     * @param _proposalId Proposal id that details needs to be updated
10749     * @param _proposalDescHash Proposal description hash having long and short description of proposal.
10750     */
10751     function updateProposal(
10752         uint _proposalId, 
10753         string calldata _proposalTitle, 
10754         string calldata _proposalSD, 
10755         string calldata _proposalDescHash
10756     ) 
10757         external onlyProposalOwner(_proposalId)
10758     {
10759         require(
10760             allProposalSolutions[_proposalId].length < 2,
10761             "Not allowed"
10762         );
10763         allProposalData[_proposalId].propStatus = uint(ProposalStatus.Draft);
10764         allProposalData[_proposalId].category = 0;
10765         allProposalData[_proposalId].commonIncentive = 0;
10766         emit Proposal(
10767             allProposalData[_proposalId].owner,
10768             _proposalId,
10769             now,
10770             _proposalTitle, 
10771             _proposalSD, 
10772             _proposalDescHash
10773         );
10774     }
10775 
10776     /**
10777     * @dev Categorizes proposal to proceed further. Categories shows the proposal objective.
10778     */
10779     function categorizeProposal(
10780         uint _proposalId,
10781         uint _categoryId,
10782         uint _incentive
10783     )
10784         external
10785         voteNotStarted(_proposalId) isAllowedToCategorize
10786     {
10787         _categorizeProposal(_proposalId, _categoryId, _incentive);
10788     }
10789 
10790     /**
10791     * @dev Initiates add solution
10792     * To implement the governance interface
10793     */
10794     function addSolution(uint, string calldata, bytes calldata) external {
10795     }
10796 
10797     /**
10798     * @dev Opens proposal for voting
10799     * To implement the governance interface
10800     */
10801     function openProposalForVoting(uint) external {
10802     }
10803 
10804     /**
10805     * @dev Submit proposal with solution
10806     * @param _proposalId Proposal id
10807     * @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
10808     */
10809     function submitProposalWithSolution(
10810         uint _proposalId, 
10811         string calldata _solutionHash, 
10812         bytes calldata _action
10813     ) 
10814         external
10815         onlyProposalOwner(_proposalId)
10816     {
10817 
10818         require(allProposalData[_proposalId].propStatus == uint(ProposalStatus.AwaitingSolution));
10819         
10820         _proposalSubmission(_proposalId, _solutionHash, _action);
10821     }
10822 
10823     /**
10824     * @dev Creates a new proposal with solution
10825     * @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
10826     * @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
10827     * @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
10828     */
10829     function createProposalwithSolution(
10830         string calldata _proposalTitle, 
10831         string calldata _proposalSD, 
10832         string calldata _proposalDescHash,
10833         uint _categoryId, 
10834         string calldata _solutionHash, 
10835         bytes calldata _action
10836     ) 
10837         external isAllowed(_categoryId)
10838     {
10839 
10840 
10841         uint proposalId = totalProposals;
10842 
10843         _createProposal(_proposalTitle, _proposalSD, _proposalDescHash, _categoryId);
10844         
10845         require(_categoryId > 0);
10846 
10847         _proposalSubmission(
10848             proposalId,
10849             _solutionHash,
10850             _action
10851         );
10852     }
10853 
10854     /**
10855      * @dev Submit a vote on the proposal.
10856      * @param _proposalId to vote upon.
10857      * @param _solutionChosen is the chosen vote.
10858      */
10859     function submitVote(uint _proposalId, uint _solutionChosen) external {
10860         
10861         require(allProposalData[_proposalId].propStatus == 
10862         uint(Governance.ProposalStatus.VotingStarted), "Not allowed");
10863 
10864         require(_solutionChosen < allProposalSolutions[_proposalId].length);
10865 
10866 
10867         _submitVote(_proposalId, _solutionChosen);
10868     }
10869 
10870     /**
10871      * @dev Closes the proposal.
10872      * @param _proposalId of proposal to be closed.
10873      */
10874     function closeProposal(uint _proposalId) external {
10875         uint category = allProposalData[_proposalId].category;
10876         
10877         
10878         uint _memberRole;
10879         if (allProposalData[_proposalId].dateUpd.add(maxDraftTime) <= now && 
10880             allProposalData[_proposalId].propStatus < uint(ProposalStatus.VotingStarted)) {
10881             _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
10882         } else {
10883             require(canCloseProposal(_proposalId) == 1);
10884             (, _memberRole, , , , , ) = proposalCategory.category(allProposalData[_proposalId].category);
10885             if (_memberRole == uint(MemberRoles.Role.AdvisoryBoard)) {
10886                 _closeAdvisoryBoardVote(_proposalId, category);
10887             } else {
10888                 _closeMemberVote(_proposalId, category);
10889             }
10890         }
10891         
10892     }
10893 
10894     /**
10895      * @dev Claims reward for member.
10896      * @param _memberAddress to claim reward of.
10897      * @param _maxRecords maximum number of records to claim reward for.
10898      _proposals list of proposals of which reward will be claimed.
10899      * @return amount of pending reward.
10900      */
10901     function claimReward(address _memberAddress, uint _maxRecords) 
10902         external returns(uint pendingDAppReward) 
10903     {
10904         
10905         uint voteId;
10906         address leader;
10907         uint lastUpd;
10908 
10909         require(msg.sender == ms.getLatestAddress("CR"));
10910 
10911         uint delegationId = followerDelegation[_memberAddress];
10912         DelegateVote memory delegationData = allDelegation[delegationId];
10913         if (delegationId > 0 && delegationData.leader != address(0)) {
10914             leader = delegationData.leader;
10915             lastUpd = delegationData.lastUpd;
10916         } else
10917             leader = _memberAddress;
10918 
10919         uint proposalId;
10920         uint totalVotes = allVotesByMember[leader].length;
10921         uint lastClaimed = totalVotes;
10922         uint j;
10923         uint i;
10924         for (i = lastRewardClaimed[_memberAddress]; i < totalVotes && j < _maxRecords; i++) {
10925             voteId = allVotesByMember[leader][i];
10926             proposalId = allVotes[voteId].proposalId;
10927             if (proposalVoteTally[proposalId].voters > 0 && (allVotes[voteId].dateAdd > (
10928                 lastUpd.add(tokenHoldingTime)) || leader == _memberAddress)) {
10929                 if (allProposalData[proposalId].propStatus > uint(ProposalStatus.VotingStarted)) {
10930                     if (!rewardClaimed[voteId][_memberAddress]) {
10931                         pendingDAppReward = pendingDAppReward.add(
10932                                 allProposalData[proposalId].commonIncentive.div(
10933                                     proposalVoteTally[proposalId].voters
10934                                 )
10935                             );
10936                         rewardClaimed[voteId][_memberAddress] = true;
10937                         j++;
10938                     }
10939                 } else {
10940                     if (lastClaimed == totalVotes) {
10941                         lastClaimed = i;
10942                     }
10943                 }
10944             }
10945         }
10946 
10947         if (lastClaimed == totalVotes) {
10948             lastRewardClaimed[_memberAddress] = i;
10949         } else {
10950             lastRewardClaimed[_memberAddress] = lastClaimed;
10951         }
10952 
10953         if (j > 0) {
10954             emit RewardClaimed(
10955                 _memberAddress,
10956                 pendingDAppReward
10957             );
10958         }
10959     }
10960 
10961     /**
10962      * @dev Sets delegation acceptance status of individual user
10963      * @param _status delegation acceptance status
10964      */
10965     function setDelegationStatus(bool _status) external isMemberAndcheckPause checkPendingRewards {
10966         isOpenForDelegation[msg.sender] = _status;
10967     }
10968 
10969     /**
10970      * @dev Delegates vote to an address.
10971      * @param _add is the address to delegate vote to.
10972      */
10973     function delegateVote(address _add) external isMemberAndcheckPause checkPendingRewards {
10974 
10975         require(ms.masterInitialized());
10976 
10977         require(allDelegation[followerDelegation[_add]].leader == address(0));
10978 
10979         if (followerDelegation[msg.sender] > 0) {
10980             require((allDelegation[followerDelegation[msg.sender]].lastUpd).add(tokenHoldingTime) < now);
10981         }
10982 
10983         require(!alreadyDelegated(msg.sender));
10984         require(!memberRole.checkRole(msg.sender, uint(MemberRoles.Role.Owner)));
10985         require(!memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)));
10986 
10987 
10988         require(followerCount[_add] < maxFollowers);
10989         
10990         if (allVotesByMember[msg.sender].length > 0) {
10991             require((allVotes[allVotesByMember[msg.sender][allVotesByMember[msg.sender].length - 1]].dateAdd).add(tokenHoldingTime)
10992             < now);
10993         }
10994 
10995         require(ms.isMember(_add));
10996 
10997         require(isOpenForDelegation[_add]);
10998 
10999         allDelegation.push(DelegateVote(msg.sender, _add, now));
11000         followerDelegation[msg.sender] = allDelegation.length - 1;
11001         leaderDelegation[_add].push(allDelegation.length - 1);
11002         followerCount[_add]++;
11003         lastRewardClaimed[msg.sender] = allVotesByMember[_add].length;
11004     }
11005 
11006     /**
11007      * @dev Undelegates the sender
11008      */
11009     function unDelegate() external isMemberAndcheckPause checkPendingRewards {
11010         _unDelegate(msg.sender);
11011     }
11012 
11013     /**
11014      * @dev Triggers action of accepted proposal after waiting time is finished
11015      */
11016     function triggerAction(uint _proposalId) external {
11017         require(proposalActionStatus[_proposalId] == uint(ActionStatus.Accepted) && proposalExecutionTime[_proposalId] <= now, "Cannot trigger");
11018         _triggerAction(_proposalId, allProposalData[_proposalId].category);
11019     }
11020 
11021     /**
11022      * @dev Provides option to Advisory board member to reject proposal action execution within actionWaitingTime, if found suspicious
11023      */
11024     function rejectAction(uint _proposalId) external {
11025         require(memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)) && proposalExecutionTime[_proposalId] > now);
11026 
11027         require(proposalActionStatus[_proposalId] == uint(ActionStatus.Accepted));
11028 
11029         require(!proposalRejectedByAB[_proposalId][msg.sender]);
11030 
11031         require(
11032             keccak256(proposalCategory.categoryActionHashes(allProposalData[_proposalId].category))
11033             != keccak256(abi.encodeWithSignature("swapABMember(address,address)"))
11034         );
11035 
11036         proposalRejectedByAB[_proposalId][msg.sender] = true;
11037         actionRejectedCount[_proposalId]++;
11038         emit ActionRejected(_proposalId, msg.sender);
11039         if (actionRejectedCount[_proposalId] == AB_MAJ_TO_REJECT_ACTION) {
11040             proposalActionStatus[_proposalId] = uint(ActionStatus.Rejected);
11041         }
11042     }
11043 
11044     /**
11045      * @dev Sets intial actionWaitingTime value
11046      * To be called after governance implementation has been updated
11047      */
11048     function setInitialActionParameters() external onlyOwner {
11049         require(!actionParamsInitialised);
11050         actionParamsInitialised = true;
11051         actionWaitingTime = 24 * 1 hours;
11052     }
11053 
11054     /**
11055      * @dev Gets Uint Parameters of a code
11056      * @param code whose details we want
11057      * @return string value of the code
11058      * @return associated amount (time or perc or value) to the code
11059      */
11060     function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
11061 
11062         codeVal = code;
11063 
11064         if (code == "GOVHOLD") {
11065 
11066             val = tokenHoldingTime / (1 days);
11067 
11068         } else if (code == "MAXFOL") {
11069 
11070             val = maxFollowers;
11071 
11072         } else if (code == "MAXDRFT") {
11073 
11074             val = maxDraftTime / (1 days);
11075 
11076         } else if (code == "EPTIME") {
11077 
11078             val = ms.pauseTime() / (1 days);
11079 
11080         } else if (code == "ACWT") {
11081 
11082             val = actionWaitingTime / (1 hours);
11083 
11084         }
11085     }
11086 
11087     /**
11088      * @dev Gets all details of a propsal
11089      * @param _proposalId whose details we want
11090      * @return proposalId
11091      * @return category
11092      * @return status
11093      * @return finalVerdict
11094      * @return totalReward
11095      */
11096     function proposal(uint _proposalId)
11097         external
11098         view
11099         returns(
11100             uint proposalId,
11101             uint category,
11102             uint status,
11103             uint finalVerdict,
11104             uint totalRewar
11105         )
11106     {
11107         return(
11108             _proposalId,
11109             allProposalData[_proposalId].category,
11110             allProposalData[_proposalId].propStatus,
11111             allProposalData[_proposalId].finalVerdict,
11112             allProposalData[_proposalId].commonIncentive
11113         );
11114     }
11115 
11116     /**
11117      * @dev Gets some details of a propsal
11118      * @param _proposalId whose details we want
11119      * @return proposalId
11120      * @return number of all proposal solutions
11121      * @return amount of votes 
11122      */
11123     function proposalDetails(uint _proposalId) external view returns(uint, uint, uint) {
11124         return(
11125             _proposalId,
11126             allProposalSolutions[_proposalId].length,
11127             proposalVoteTally[_proposalId].voters
11128         );
11129     }
11130 
11131     /**
11132      * @dev Gets solution action on a proposal
11133      * @param _proposalId whose details we want
11134      * @param _solution whose details we want
11135      * @return action of a solution on a proposal
11136      */
11137     function getSolutionAction(uint _proposalId, uint _solution) external view returns(uint, bytes memory) {
11138         return (
11139             _solution,
11140             allProposalSolutions[_proposalId][_solution]
11141         );
11142     }
11143    
11144     /**
11145      * @dev Gets length of propsal
11146      * @return length of propsal
11147      */
11148     function getProposalLength() external view returns(uint) {
11149         return totalProposals;
11150     }
11151 
11152     /**
11153      * @dev Get followers of an address
11154      * @return get followers of an address
11155      */
11156     function getFollowers(address _add) external view returns(uint[] memory) {
11157         return leaderDelegation[_add];
11158     }
11159 
11160     /**
11161      * @dev Gets pending rewards of a member
11162      * @param _memberAddress in concern
11163      * @return amount of pending reward
11164      */
11165     function getPendingReward(address _memberAddress)
11166         public view returns(uint pendingDAppReward)
11167     {
11168         uint delegationId = followerDelegation[_memberAddress];
11169         address leader;
11170         uint lastUpd;
11171         DelegateVote memory delegationData = allDelegation[delegationId];
11172 
11173         if (delegationId > 0 && delegationData.leader != address(0)) {
11174             leader = delegationData.leader;
11175             lastUpd = delegationData.lastUpd;
11176         } else
11177             leader = _memberAddress;
11178 
11179         uint proposalId;
11180         for (uint i = lastRewardClaimed[_memberAddress]; i < allVotesByMember[leader].length; i++) {
11181             if (allVotes[allVotesByMember[leader][i]].dateAdd > (
11182                 lastUpd.add(tokenHoldingTime)) || leader == _memberAddress) {
11183                 if (!rewardClaimed[allVotesByMember[leader][i]][_memberAddress]) {
11184                     proposalId = allVotes[allVotesByMember[leader][i]].proposalId;
11185                     if (proposalVoteTally[proposalId].voters > 0 && allProposalData[proposalId].propStatus
11186                     > uint(ProposalStatus.VotingStarted)) {
11187                         pendingDAppReward = pendingDAppReward.add(
11188                             allProposalData[proposalId].commonIncentive.div(
11189                                 proposalVoteTally[proposalId].voters
11190                             )
11191                         );
11192                     }
11193                 }
11194             }
11195         }
11196     }
11197 
11198     /**
11199      * @dev Updates Uint Parameters of a code
11200      * @param code whose details we want to update
11201      * @param val value to set
11202      */
11203     function updateUintParameters(bytes8 code, uint val) public {
11204 
11205         require(ms.checkIsAuthToGoverned(msg.sender));
11206         if (code == "GOVHOLD") {
11207 
11208             tokenHoldingTime = val * 1 days;
11209 
11210         } else if (code == "MAXFOL") {
11211 
11212             maxFollowers = val;
11213 
11214         } else if (code == "MAXDRFT") {
11215 
11216             maxDraftTime = val * 1 days;
11217 
11218         } else if (code == "EPTIME") {
11219 
11220             ms.updatePauseTime(val * 1 days);
11221 
11222         } else if (code == "ACWT") {
11223 
11224             actionWaitingTime = val * 1 hours;
11225 
11226         } else {
11227 
11228             revert("Invalid code");
11229 
11230         }
11231     }
11232 
11233     /**
11234     * @dev Updates all dependency addresses to latest ones from Master
11235     */
11236     function changeDependentContractAddress() public {
11237         tokenInstance = TokenController(ms.dAppLocker());
11238         memberRole = MemberRoles(ms.getLatestAddress("MR"));
11239         proposalCategory = ProposalCategory(ms.getLatestAddress("PC"));
11240     }
11241 
11242     /**
11243     * @dev Checks if msg.sender is allowed to create a proposal under given category
11244     */
11245     function allowedToCreateProposal(uint category) public view returns(bool check) {
11246         if (category == 0)
11247             return true;
11248         uint[] memory mrAllowed;
11249         (, , , , mrAllowed, , ) = proposalCategory.category(category);
11250         for (uint i = 0; i < mrAllowed.length; i++) {
11251             if (mrAllowed[i] == 0 || memberRole.checkRole(msg.sender, mrAllowed[i]))
11252                 return true;
11253         }
11254     }
11255 
11256     /**
11257      * @dev Checks if an address is already delegated
11258      * @param _add in concern
11259      * @return bool value if the address is delegated or not
11260      */
11261     function alreadyDelegated(address _add) public view returns(bool delegated) {
11262         for (uint i=0; i < leaderDelegation[_add].length; i++) {
11263             if (allDelegation[leaderDelegation[_add][i]].leader == _add) {
11264                 return true;
11265             }
11266         }
11267     }
11268 
11269     /**
11270     * @dev Pauses a proposal
11271     * To implement govblocks interface
11272     */
11273     function pauseProposal(uint) public {
11274     }
11275 
11276     /**
11277     * @dev Resumes a proposal
11278     * To implement govblocks interface
11279     */
11280     function resumeProposal(uint) public {
11281     }
11282 
11283     /**
11284     * @dev Checks If the proposal voting time is up and it's ready to close 
11285     *      i.e. Closevalue is 1 if proposal is ready to be closed, 2 if already closed, 0 otherwise!
11286     * @param _proposalId Proposal id to which closing value is being checked
11287     */
11288     function canCloseProposal(uint _proposalId) 
11289         public 
11290         view 
11291         returns(uint)
11292     {
11293         uint dateUpdate;
11294         uint pStatus;
11295         uint _closingTime;
11296         uint _roleId;
11297         uint majority;
11298         pStatus = allProposalData[_proposalId].propStatus;
11299         dateUpdate = allProposalData[_proposalId].dateUpd;
11300         (, _roleId, majority, , , _closingTime, ) = proposalCategory.category(allProposalData[_proposalId].category);
11301         if (
11302             pStatus == uint(ProposalStatus.VotingStarted)
11303         ) {
11304             uint numberOfMembers = memberRole.numberOfMembers(_roleId);
11305             if (_roleId == uint(MemberRoles.Role.AdvisoryBoard)) {
11306                 if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100).div(numberOfMembers) >= majority  
11307                 || proposalVoteTally[_proposalId].abVoteValue[1].add(proposalVoteTally[_proposalId].abVoteValue[0]) == numberOfMembers
11308                 || dateUpdate.add(_closingTime) <= now) {
11309 
11310                     return 1;
11311                 }
11312             } else {
11313                 if (numberOfMembers == proposalVoteTally[_proposalId].voters 
11314                 || dateUpdate.add(_closingTime) <= now)
11315                     return  1;
11316             }
11317         } else if (pStatus > uint(ProposalStatus.VotingStarted)) {
11318             return  2;
11319         } else {
11320             return  0;
11321         }
11322     }
11323 
11324     /**
11325      * @dev Gets Id of member role allowed to categorize the proposal
11326      * @return roleId allowed to categorize the proposal
11327      */
11328     function allowedToCatgorize() public view returns(uint roleId) {
11329         return roleIdAllowedToCatgorize;
11330     }
11331 
11332     /**
11333      * @dev Gets vote tally data
11334      * @param _proposalId in concern
11335      * @param _solution of a proposal id
11336      * @return member vote value
11337      * @return advisory board vote value
11338      * @return amount of votes
11339      */
11340     function voteTallyData(uint _proposalId, uint _solution) public view returns(uint, uint, uint) {
11341         return (proposalVoteTally[_proposalId].memberVoteValue[_solution],
11342             proposalVoteTally[_proposalId].abVoteValue[_solution], proposalVoteTally[_proposalId].voters);
11343     }
11344 
11345     /**
11346      * @dev Internal call to create proposal
11347      * @param _proposalTitle of proposal
11348      * @param _proposalSD is short description of proposal
11349      * @param _proposalDescHash IPFS hash value of propsal
11350      * @param _categoryId of proposal
11351      */
11352     function _createProposal(
11353         string memory _proposalTitle,
11354         string memory _proposalSD,
11355         string memory _proposalDescHash,
11356         uint _categoryId
11357     )
11358         internal
11359     {
11360         require(proposalCategory.categoryABReq(_categoryId) == 0 || _categoryId == 0);
11361         uint _proposalId = totalProposals;
11362         allProposalData[_proposalId].owner = msg.sender;
11363         allProposalData[_proposalId].dateUpd = now;
11364         allProposalSolutions[_proposalId].push("");
11365         totalProposals++;
11366 
11367         emit Proposal(
11368             msg.sender,
11369             _proposalId,
11370             now,
11371             _proposalTitle,
11372             _proposalSD,
11373             _proposalDescHash
11374         );
11375 
11376         if (_categoryId > 0)
11377             _categorizeProposal(_proposalId, _categoryId, 0);
11378     }
11379 
11380     /**
11381      * @dev Internal call to categorize a proposal
11382      * @param _proposalId of proposal
11383      * @param _categoryId of proposal
11384      * @param _incentive is commonIncentive
11385      */
11386     function _categorizeProposal(
11387         uint _proposalId,
11388         uint _categoryId,
11389         uint _incentive
11390     )
11391         internal
11392     {
11393         require(
11394             _categoryId > 0 && _categoryId < proposalCategory.totalCategories(),
11395             "Invalid category"
11396         );
11397         allProposalData[_proposalId].category = _categoryId;
11398         allProposalData[_proposalId].commonIncentive = _incentive;
11399         allProposalData[_proposalId].propStatus = uint(ProposalStatus.AwaitingSolution);
11400 
11401         emit ProposalCategorized(_proposalId, msg.sender, _categoryId);
11402     }
11403 
11404     /**
11405      * @dev Internal call to add solution to a proposal
11406      * @param _proposalId in concern
11407      * @param _action on that solution
11408      * @param _solutionHash string value
11409      */
11410     function _addSolution(uint _proposalId, bytes memory _action, string memory _solutionHash)
11411         internal
11412     {
11413         allProposalSolutions[_proposalId].push(_action);
11414         emit Solution(_proposalId, msg.sender, allProposalSolutions[_proposalId].length - 1, _solutionHash, now);
11415     }
11416 
11417     /**
11418     * @dev Internal call to add solution and open proposal for voting
11419     */
11420     function _proposalSubmission(
11421         uint _proposalId,
11422         string memory _solutionHash,
11423         bytes memory _action
11424     )
11425         internal
11426     {
11427 
11428         uint _categoryId = allProposalData[_proposalId].category;
11429         if (proposalCategory.categoryActionHashes(_categoryId).length == 0) {
11430             require(keccak256(_action) == keccak256(""));
11431             proposalActionStatus[_proposalId] = uint(ActionStatus.NoAction);
11432         }
11433         
11434         _addSolution(
11435             _proposalId,
11436             _action,
11437             _solutionHash
11438         );
11439 
11440         _updateProposalStatus(_proposalId, uint(ProposalStatus.VotingStarted));
11441         (, , , , , uint closingTime, ) = proposalCategory.category(_categoryId);
11442         emit CloseProposalOnTime(_proposalId, closingTime.add(now));
11443 
11444     }
11445 
11446     /**
11447      * @dev Internal call to submit vote
11448      * @param _proposalId of proposal in concern
11449      * @param _solution for that proposal
11450      */
11451     function _submitVote(uint _proposalId, uint _solution) internal {
11452 
11453         uint delegationId = followerDelegation[msg.sender];
11454         uint mrSequence;
11455         uint majority;
11456         uint closingTime;
11457         (, mrSequence, majority, , , closingTime, ) = proposalCategory.category(allProposalData[_proposalId].category);
11458 
11459         require(allProposalData[_proposalId].dateUpd.add(closingTime) > now, "Closed");
11460 
11461         require(memberProposalVote[msg.sender][_proposalId] == 0, "Not allowed");
11462         require((delegationId == 0) || (delegationId > 0 && allDelegation[delegationId].leader == address(0) && 
11463         _checkLastUpd(allDelegation[delegationId].lastUpd)));
11464 
11465         require(memberRole.checkRole(msg.sender, mrSequence), "Not Authorized");
11466         uint totalVotes = allVotes.length;
11467 
11468         allVotesByMember[msg.sender].push(totalVotes);
11469         memberProposalVote[msg.sender][_proposalId] = totalVotes;
11470 
11471         allVotes.push(ProposalVote(msg.sender, _proposalId, now));
11472 
11473         emit Vote(msg.sender, _proposalId, totalVotes, now, _solution);
11474         if (mrSequence == uint(MemberRoles.Role.Owner)) {
11475             if (_solution == 1)
11476                 _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), allProposalData[_proposalId].category, 1, MemberRoles.Role.Owner);
11477             else
11478                 _updateProposalStatus(_proposalId, uint(ProposalStatus.Rejected));
11479         
11480         } else {
11481             uint numberOfMembers = memberRole.numberOfMembers(mrSequence);
11482             _setVoteTally(_proposalId, _solution, mrSequence);
11483 
11484             if (mrSequence == uint(MemberRoles.Role.AdvisoryBoard)) {
11485                 if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100).div(numberOfMembers) 
11486                 >= majority 
11487                 || (proposalVoteTally[_proposalId].abVoteValue[1].add(proposalVoteTally[_proposalId].abVoteValue[0])) == numberOfMembers) {
11488                     emit VoteCast(_proposalId);
11489                 }
11490             } else {
11491                 if (numberOfMembers == proposalVoteTally[_proposalId].voters)
11492                     emit VoteCast(_proposalId);
11493             }
11494         }
11495 
11496     }
11497 
11498     /**
11499      * @dev Internal call to set vote tally of a proposal
11500      * @param _proposalId of proposal in concern
11501      * @param _solution of proposal in concern
11502      * @param mrSequence number of members for a role
11503      */
11504     function _setVoteTally(uint _proposalId, uint _solution, uint mrSequence) internal
11505     {
11506         uint categoryABReq;
11507         uint isSpecialResolution;
11508         (, categoryABReq, isSpecialResolution) = proposalCategory.categoryExtendedData(allProposalData[_proposalId].category);
11509         if (memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)) && (categoryABReq > 0) || 
11510             mrSequence == uint(MemberRoles.Role.AdvisoryBoard)) {
11511             proposalVoteTally[_proposalId].abVoteValue[_solution]++;
11512         }
11513         tokenInstance.lockForMemberVote(msg.sender, tokenHoldingTime);
11514         if (mrSequence != uint(MemberRoles.Role.AdvisoryBoard)) {
11515             uint voteWeight;
11516             uint voters = 1;
11517             uint tokenBalance = tokenInstance.totalBalanceOf(msg.sender);
11518             uint totalSupply = tokenInstance.totalSupply();
11519             if (isSpecialResolution == 1) {
11520                 voteWeight = tokenBalance.add(10**18);
11521             } else {
11522                 voteWeight = (_minOf(tokenBalance, maxVoteWeigthPer.mul(totalSupply).div(100))).add(10**18);
11523             }
11524             DelegateVote memory delegationData;
11525             for (uint i = 0; i < leaderDelegation[msg.sender].length; i++) {
11526                 delegationData = allDelegation[leaderDelegation[msg.sender][i]];
11527                 if (delegationData.leader == msg.sender && 
11528                 _checkLastUpd(delegationData.lastUpd)) {
11529                     if (memberRole.checkRole(delegationData.follower, mrSequence)) {
11530                         tokenBalance = tokenInstance.totalBalanceOf(delegationData.follower);
11531                         tokenInstance.lockForMemberVote(delegationData.follower, tokenHoldingTime);
11532                         voters++;
11533                         if (isSpecialResolution == 1) {
11534                             voteWeight = voteWeight.add(tokenBalance.add(10**18));
11535                         } else {
11536                             voteWeight = voteWeight.add((_minOf(tokenBalance, maxVoteWeigthPer.mul(totalSupply).div(100))).add(10**18));
11537                         }
11538                     }
11539                 }
11540             }
11541             proposalVoteTally[_proposalId].memberVoteValue[_solution] = proposalVoteTally[_proposalId].memberVoteValue[_solution].add(voteWeight);
11542             proposalVoteTally[_proposalId].voters = proposalVoteTally[_proposalId].voters + voters;
11543         }
11544     }
11545 
11546     /**
11547      * @dev Gets minimum of two numbers
11548      * @param a one of the two numbers
11549      * @param b one of the two numbers
11550      * @return minimum number out of the two
11551      */
11552     function _minOf(uint a, uint b) internal pure returns(uint res) {
11553         res = a;
11554         if (res > b)
11555             res = b;
11556     }
11557     
11558     /**
11559      * @dev Check the time since last update has exceeded token holding time or not
11560      * @param _lastUpd is last update time
11561      * @return the bool which tells if the time since last update has exceeded token holding time or not
11562      */
11563     function _checkLastUpd(uint _lastUpd) internal view returns(bool) {
11564         return (now - _lastUpd) > tokenHoldingTime;
11565     }
11566 
11567     /**
11568     * @dev Checks if the vote count against any solution passes the threshold value or not.
11569     */
11570     function _checkForThreshold(uint _proposalId, uint _category) internal view returns(bool check) {
11571         uint categoryQuorumPerc;
11572         uint roleAuthorized;
11573         (, roleAuthorized, , categoryQuorumPerc, , , ) = proposalCategory.category(_category);
11574         check = ((proposalVoteTally[_proposalId].memberVoteValue[0]
11575                             .add(proposalVoteTally[_proposalId].memberVoteValue[1]))
11576                         .mul(100))
11577                 .div(
11578                     tokenInstance.totalSupply().add(
11579                         memberRole.numberOfMembers(roleAuthorized).mul(10 ** 18)
11580                     )
11581                 ) >= categoryQuorumPerc;
11582     }
11583     
11584     /**
11585      * @dev Called when vote majority is reached
11586      * @param _proposalId of proposal in concern
11587      * @param _status of proposal in concern
11588      * @param category of proposal in concern
11589      * @param max vote value of proposal in concern
11590      */
11591     function _callIfMajReached(uint _proposalId, uint _status, uint category, uint max, MemberRoles.Role role) internal {
11592         
11593         allProposalData[_proposalId].finalVerdict = max;
11594         _updateProposalStatus(_proposalId, _status);
11595         emit ProposalAccepted(_proposalId);
11596         if (proposalActionStatus[_proposalId] != uint(ActionStatus.NoAction)) {
11597             if (role == MemberRoles.Role.AdvisoryBoard) {
11598                 _triggerAction(_proposalId, category);
11599             } else {
11600                 proposalActionStatus[_proposalId] = uint(ActionStatus.Accepted);
11601                 proposalExecutionTime[_proposalId] = actionWaitingTime.add(now);
11602             }
11603         }
11604     }
11605 
11606     /**
11607      * @dev Internal function to trigger action of accepted proposal
11608      */
11609     function _triggerAction(uint _proposalId, uint _categoryId) internal {
11610         proposalActionStatus[_proposalId] = uint(ActionStatus.Executed);
11611         bytes2 contractName;
11612         address actionAddress;
11613         bytes memory _functionHash;
11614         (, actionAddress, contractName, , _functionHash) = proposalCategory.categoryActionDetails(_categoryId);
11615         if (contractName == "MS") {
11616             actionAddress = address(ms);
11617         } else if (contractName != "EX") {
11618             actionAddress = ms.getLatestAddress(contractName);
11619         }
11620         (bool actionStatus, ) = actionAddress.call(abi.encodePacked(_functionHash, allProposalSolutions[_proposalId][1]));
11621         if (actionStatus) {
11622             emit ActionSuccess(_proposalId);
11623         } else {
11624             proposalActionStatus[_proposalId] = uint(ActionStatus.Accepted);
11625             emit ActionFailed(_proposalId);
11626         }
11627     }
11628 
11629     /**
11630      * @dev Internal call to update proposal status
11631      * @param _proposalId of proposal in concern
11632      * @param _status of proposal to set
11633      */
11634     function _updateProposalStatus(uint _proposalId, uint _status) internal {
11635         if (_status == uint(ProposalStatus.Rejected) || _status == uint(ProposalStatus.Denied)) {
11636             proposalActionStatus[_proposalId] = uint(ActionStatus.NoAction);   
11637         }
11638         allProposalData[_proposalId].dateUpd = now;
11639         allProposalData[_proposalId].propStatus = _status;
11640     }
11641 
11642     /**
11643      * @dev Internal call to undelegate a follower
11644      * @param _follower is address of follower to undelegate
11645      */
11646     function _unDelegate(address _follower) internal {
11647         uint followerId = followerDelegation[_follower];
11648         if (followerId > 0) {
11649 
11650             followerCount[allDelegation[followerId].leader] = followerCount[allDelegation[followerId].leader].sub(1);
11651             allDelegation[followerId].leader = address(0);
11652             allDelegation[followerId].lastUpd = now;
11653 
11654             lastRewardClaimed[_follower] = allVotesByMember[_follower].length;
11655         }
11656     }
11657 
11658     /**
11659      * @dev Internal call to close member voting
11660      * @param _proposalId of proposal in concern
11661      * @param category of proposal in concern
11662      */
11663     function _closeMemberVote(uint _proposalId, uint category) internal {
11664         uint isSpecialResolution;
11665         uint abMaj;
11666         (, abMaj, isSpecialResolution) = proposalCategory.categoryExtendedData(category);
11667         if (isSpecialResolution == 1) {
11668             uint acceptedVotePerc = proposalVoteTally[_proposalId].memberVoteValue[1].mul(100)
11669             .div(
11670                 tokenInstance.totalSupply().add(
11671                         memberRole.numberOfMembers(uint(MemberRoles.Role.Member)).mul(10**18)
11672                     ));
11673             if (acceptedVotePerc >= specialResolutionMajPerc) {
11674                 _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
11675             } else {
11676                 _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
11677             }
11678         } else {
11679             if (_checkForThreshold(_proposalId, category)) {
11680                 uint majorityVote;
11681                 (, , majorityVote, , , , ) = proposalCategory.category(category);
11682                 if (
11683                     ((proposalVoteTally[_proposalId].memberVoteValue[1].mul(100))
11684                                         .div(proposalVoteTally[_proposalId].memberVoteValue[0]
11685                                                 .add(proposalVoteTally[_proposalId].memberVoteValue[1])
11686                                         ))
11687                     >= majorityVote
11688                     ) {
11689                         _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
11690                     } else {
11691                         _updateProposalStatus(_proposalId, uint(ProposalStatus.Rejected));
11692                     }
11693             } else {
11694                 if (abMaj > 0 && proposalVoteTally[_proposalId].abVoteValue[1].mul(100)
11695                 .div(memberRole.numberOfMembers(uint(MemberRoles.Role.AdvisoryBoard))) >= abMaj) {
11696                     _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
11697                 } else {
11698                     _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
11699                 }
11700             }
11701         }
11702 
11703         if (proposalVoteTally[_proposalId].voters > 0) {
11704             tokenInstance.mint(ms.getLatestAddress("CR"), allProposalData[_proposalId].commonIncentive);
11705         }
11706     }
11707 
11708     /**
11709      * @dev Internal call to close advisory board voting
11710      * @param _proposalId of proposal in concern
11711      * @param category of proposal in concern
11712      */
11713     function _closeAdvisoryBoardVote(uint _proposalId, uint category) internal {
11714         uint _majorityVote;
11715         MemberRoles.Role _roleId = MemberRoles.Role.AdvisoryBoard;
11716         (, , _majorityVote, , , , ) = proposalCategory.category(category);
11717         if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100)
11718         .div(memberRole.numberOfMembers(uint(_roleId))) >= _majorityVote) {
11719             _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, _roleId);
11720         } else {
11721             _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
11722         }
11723 
11724     }
11725 
11726 }