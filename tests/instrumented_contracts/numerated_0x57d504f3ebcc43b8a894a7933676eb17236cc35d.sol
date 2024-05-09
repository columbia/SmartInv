1 pragma solidity ^0.5.7;
2 
3 library Roles {
4     struct Role {
5         mapping (address => bool) bearer;
6     }
7 
8     function add(Role storage role, address account) internal {
9         require(!has(role, account));
10         role.bearer[account] = true;
11     }
12 
13     function remove(Role storage role, address account) internal {
14         require(has(role, account));
15         role.bearer[account] = false;
16     }
17 
18     function has(Role storage role, address account) internal view returns (bool) {
19         require(account != address(0));
20         return role.bearer[account];
21     }
22 }
23 
24 
25 interface SecondaryStorageInterface {
26     function addProject() external returns (uint256 projectId);
27     function setControllerStateToProject(
28         uint256 pid,
29         address payable latestProjectCtrl,
30         address payable latestRefundCtrl,
31         address payable latestDisputeCtrl,
32         address payable latestUtilityCtrl,
33         bytes32 cntrllrs
34     )
35     external;
36 }
37 
38 
39 /* Hybrid Storage A */
40 
41 contract PrimaryStorage {
42 
43     address payable private projectController;
44     address payable private refundController;
45     address payable private disputeController;
46     address payable private utilityController;
47     bytes32 private controllersHash;
48 
49     struct GlobalState {
50         address payable projectController;
51         address payable disputeController;
52         address payable refundController;
53         address payable utilityController;
54     }
55 
56     GlobalState private dAppState;
57 
58     mapping (bytes32 => GlobalState) private globalControllerStates;
59     mapping (address => address payable) private dAppContract;
60 
61     address payable private main;
62     address private secondaryStorage;
63     address payable private refundEtherToken;
64     address payable private refundPool;
65     address payable private affiliatesEscrow;
66     address payable private moderationResources;
67     address private eventLogger;
68 
69     using Roles for Roles.Role;
70     Roles.Role private CommunityModerators;
71     Roles.Role private PlatformModerators;
72     Roles.Role private Investors;
73     Roles.Role private ProjectOwners;
74     Roles.Role private Arbiters;
75 
76     bool private isNetworkDeployed;
77     uint256 private minProtectionPercentage = 75;
78     uint256 private maxProtectionPercentage = 95;
79     uint256 private policyDuration = 4505144;
80     uint256 private basePolicyDuration = 2252572;
81     uint256 private minOwnerContribution = 3 ether;
82     uint256 private minInvestorContribution = 180000000000000000;
83     uint256 private maxInvestorContribution = 42000000000000000000;
84     uint256 private regularContributionPercentage = 20;
85 
86     ProtectedInvestment[] private insurance;
87 
88     struct ProtectedInvestment {
89         uint256 investmentId;
90         bytes32 controllerState;
91         address investmentOwner;
92         uint256 projectId;
93         uint256 poolContribution;
94         uint256 insuranceRate;
95         uint256 etherSecured;
96         uint256 timeOfTheRequest;
97         bool votedForARefund;
98         bool votedAfterFailedVoting;
99         bool isRefunded;
100         bool isCanceled;
101     }
102 
103     ProjectDispute[] private dispute;
104 
105     struct ProjectDispute {
106         uint256 disputeId;
107         uint256 pid;
108         address payable creator;
109         uint256 disputeVotePeriod;
110         uint256 resultCountPeriod;
111         uint256 numberOfVotesForRefundState;
112         uint256 numberOfVotesAgainstRefundState;
113         uint256 votingPrize;
114         uint256 entryFee;
115         uint256[] numbers;
116         bytes publicDisputeUrl;
117         address disputeController;
118         address payable[] voters;
119         mapping (address => bytes32) hiddenVote;
120         mapping (address => bool) revealedVote;
121     }
122 
123     address[] private investors;
124     mapping (address => Investor) private investorData;
125     struct Investor {
126         uint256 investorId;
127         mapping (uint256 => uint256) withdrawable;
128         address referrer;
129     }
130 
131     mapping (address => mapping(uint256 => uint256)) private payment;
132     mapping (address => uint256) private validationToken;
133 
134     constructor() public {
135         PlatformModerators.add(msg.sender);
136     }
137 
138     modifier onlyNetworkContracts {
139         if (_onlyDappContracts(msg.sender)) {
140             _;
141         } else {
142             revert("Not allowed to modify storage");
143         }
144     }
145 
146     modifier onlyValidInsuranceControllers(uint256 ins) {
147         bytes32 ctrl = insurance[ins].controllerState;
148         if (_verifyInsuranceControllers(msg.sender, ins)) {
149             _;
150         } else {
151             revert("Controller is not valid");
152         }
153     }
154 
155     modifier onlyValidProjectControllers (uint256 disputeId) {
156         _verifyDisputeController(disputeId);
157         _;
158     }
159 
160     function setNetworkDeployed() external onlyNetworkContracts {
161         isNetworkDeployed = true;
162     }
163 
164     function addNewContract(address payable dAppContractAddress) public onlyNetworkContracts {
165         dAppContract[dAppContractAddress] = dAppContractAddress;
166     }
167 
168     function setProjectController(address payable controllerAddress)
169         external
170         onlyNetworkContracts
171     {
172         projectController = controllerAddress;
173         addNewContract(controllerAddress);
174         dAppState.projectController = controllerAddress;
175         globalControllerStates[_updateControllersHash()] = dAppState;
176     }
177 
178     function setRefundController(address payable controllerAddress)
179         external
180         onlyNetworkContracts
181     {
182         refundController = controllerAddress;
183         addNewContract(controllerAddress);
184         dAppState.refundController = controllerAddress;
185         globalControllerStates[_updateControllersHash()] = dAppState;
186     }
187 
188     function setDisputeController(address payable controllerAddress)
189         external
190         onlyNetworkContracts
191     {
192         disputeController = controllerAddress;
193         dAppState.disputeController = controllerAddress;
194         addNewContract(controllerAddress);
195         globalControllerStates[_updateControllersHash()] = dAppState;
196     }
197 
198     function setUtilityController(address payable controllerAddress)
199         external
200         onlyNetworkContracts
201     {
202         utilityController = controllerAddress;
203         dAppState.utilityController = controllerAddress;
204         addNewContract(controllerAddress);
205         globalControllerStates[_updateControllersHash()] = dAppState;
206     }
207 
208     function setMainContract(address payable mainContract)
209         external
210         onlyNetworkContracts
211     {
212         main = mainContract;
213         addNewContract(mainContract);
214     }
215 
216     function setSecondaryStorage(address payable secondaryStorageContract)
217         external
218         onlyNetworkContracts
219     {
220         require(secondaryStorage == address(0), "Secondary storage already set");
221         secondaryStorage = secondaryStorageContract;
222         addNewContract(secondaryStorageContract);
223     }
224 
225     function setRefundEtherContract(address payable refundEtherContract)
226         external
227         onlyNetworkContracts
228     {
229         require(refundEtherToken == address(0), "This address is already set");
230         refundEtherToken = refundEtherContract;
231         addNewContract(refundEtherContract);
232     }
233 
234     function setAffiliateEscrow(address payable affiliateEscrowAddress)
235         external
236         onlyNetworkContracts
237     {
238         require (affiliatesEscrow == address(0), "This address is already set");
239         affiliatesEscrow = affiliateEscrowAddress;
240         addNewContract(affiliateEscrowAddress);
241     }
242 
243     function setModerationResources(address payable modResourcesAddr)
244         external
245         onlyNetworkContracts
246     {
247         moderationResources = modResourcesAddr;
248         addNewContract(modResourcesAddr);
249     }
250 
251     function setRefundPool(address payable refundPoolAddress)
252         external
253         onlyNetworkContracts
254     {
255         require(refundPool == address(0), "Refund Pool address is already set");
256         refundPool = refundPoolAddress;
257         addNewContract(refundPoolAddress);
258     }
259 
260     function setEventLogger(address payable loggerAddress)
261         external
262         onlyNetworkContracts
263     {
264         eventLogger = loggerAddress;
265         addNewContract(loggerAddress);
266     }
267 
268     function setMinInvestorContribution(uint256 newMinInvestorContribution)
269         external
270         onlyNetworkContracts
271     {
272         minInvestorContribution = newMinInvestorContribution;
273     }
274 
275     function setMaxInvestorContribution(uint256 newMaxInvestorContribution)
276         external
277         onlyNetworkContracts
278     {
279         maxInvestorContribution = newMaxInvestorContribution;
280     }
281 
282     function setMinProtectionPercentage(uint256 newPercentage) external onlyNetworkContracts
283     {
284         minProtectionPercentage = newPercentage;
285     }
286 
287     function setMaxProtectionPercentage(uint256 newPercentage) external onlyNetworkContracts
288     {
289         maxProtectionPercentage = newPercentage;
290     }
291 
292     function setMinOwnerContribution(uint256 newMinOwnContrib) external onlyNetworkContracts
293     {
294         minOwnerContribution = newMinOwnContrib;
295     }
296 
297     function setDefaultBasePolicyDuration(uint256 newBasePolicyPeriod)
298         external
299         onlyNetworkContracts
300     {
301         basePolicyDuration = newBasePolicyPeriod;
302     }
303 
304     function setDefaultPolicyDuration(uint256 newPolicyPeriod)
305         external
306         onlyNetworkContracts
307     {
308         policyDuration = newPolicyPeriod;
309     }
310 
311     function setDefaultRateLimits(uint256 newMinLimit, uint256 newMaxLimit)
312         external
313         onlyNetworkContracts
314     {
315         (minProtectionPercentage, maxProtectionPercentage) = (newMinLimit, newMaxLimit);
316     }
317 
318     function setRegularContributionPercentage(uint256 newPercentage)
319         external
320         onlyNetworkContracts
321     {
322         regularContributionPercentage = newPercentage;
323     }
324 
325     function addProject() external onlyNetworkContracts returns (uint256 pid) {
326         SecondaryStorageInterface secondStorage = SecondaryStorageInterface(secondaryStorage);
327         return secondStorage.addProject();
328     }
329 
330     function setControllerStateToProject(uint256 pid) external onlyNetworkContracts {
331         SecondaryStorageInterface secondStorage = SecondaryStorageInterface(secondaryStorage);
332         secondStorage.setControllerStateToProject(
333             pid, projectController, refundController,
334             disputeController, utilityController, controllersHash
335         );
336     }
337 
338     function addInsurance()
339         external
340         onlyNetworkContracts
341         returns (uint256 insuranceId)
342     {
343         return insurance.length++;
344     }
345 
346     function setControllerStateToInsurance(uint256 insId, bytes32 cntrllrs)
347         external
348         onlyNetworkContracts
349     {
350         require(insurance[insId].controllerState == bytes32(0), "Controllers are already set");
351         insurance[insId].controllerState = cntrllrs;
352     }
353 
354     function setInsuranceId(uint256 insId)
355         external
356         onlyValidInsuranceControllers(insId)
357     {
358         insurance[insId].investmentId = insId;
359     }
360 
361     function setInsuranceProjectId(uint256 insId, uint256 pid)
362         external
363         onlyValidInsuranceControllers(insId)
364     {
365         insurance[insId].projectId = pid;
366     }
367 
368     function setInsuranceOwner(uint256 insId, address insOwner)
369         external
370         onlyValidInsuranceControllers(insId)
371     {
372         insurance[insId].investmentOwner = insOwner;
373     }
374 
375     function setEtherSecured(uint256 insId, uint256 amount)
376         external
377         onlyValidInsuranceControllers(insId)
378     {
379         insurance[insId].etherSecured = amount;
380     }
381 
382     function setTimeOfTheRequest(uint256 insId)
383         external
384         onlyValidInsuranceControllers(insId)
385     {
386         insurance[insId].timeOfTheRequest = block.number;
387     }
388 
389     function setInsuranceRate(
390         uint256 insId,
391         uint256 protectionPercentage
392     )
393         external
394         onlyValidInsuranceControllers(insId)
395     {
396         insurance[insId].insuranceRate = protectionPercentage;
397     }
398 
399     function setPoolContribution(
400         uint256 insId,
401         uint256 amount
402     )
403         external
404         onlyValidInsuranceControllers(insId)
405     {
406         insurance[insId].poolContribution = amount;
407     }
408 
409     function setVotedForARefund(uint256 insId)
410         external
411         onlyValidInsuranceControllers(insId)
412     {
413         insurance[insId].votedForARefund = true;
414     }
415 
416     function setVotedAfterFailedVoting(uint256 insId)
417         external
418         onlyValidInsuranceControllers(insId)
419     {
420         insurance[insId].votedAfterFailedVoting = true;
421     }
422 
423     function setIsRefunded(uint256 insId)
424         external
425         onlyValidInsuranceControllers(insId)
426     {
427         insurance[insId].isRefunded = true;
428     }
429 
430     function cancelInsurance(uint256 insId)
431         external
432         onlyValidInsuranceControllers(insId)
433     {
434         insurance[insId].isCanceled = true;
435     }
436 
437     function addNewInvestor(address newInvestorAddress)
438         external
439         onlyNetworkContracts
440         returns (uint256 numberOfInvestors)
441     {
442         return investors.push(newInvestorAddress);
443     }
444 
445     function setInvestorId(address newInvestor, uint256 investorId)
446         external
447         onlyNetworkContracts
448     {
449         investorData[newInvestor].investorId = investorId;
450     }
451 
452     function setInvestor(address newInvestor)
453         external
454         onlyNetworkContracts
455     {
456         Investors.add(newInvestor);
457     }
458 
459     function setAmountAvailableForWithdraw(address userAddr, uint256 pid, uint256 amount)
460         external
461         onlyNetworkContracts
462         returns (uint256)
463     {
464         investorData[userAddr].withdrawable[pid] = amount;
465     }
466 
467     function setReferrer(address newInvestor, address referrerAddress)
468         external
469         onlyNetworkContracts
470     {
471         investorData[newInvestor].referrer = referrerAddress;
472     }
473 
474     function setPlatformModerator(
475         address newPlModAddr
476     )
477         public
478         onlyNetworkContracts
479     {
480         PlatformModerators.add(newPlModAddr);
481     }
482 
483     function setCommunityModerator(
484         address newCommunityModAddr
485     )
486         external
487         onlyNetworkContracts
488     {
489         CommunityModerators.add(newCommunityModAddr);
490     }
491 
492     function setArbiter(
493         address newArbiterAddr
494     )
495         external
496         onlyNetworkContracts
497     {
498         Arbiters.add(newArbiterAddr);
499     }
500 
501     function setProjectOwner(
502         address newOwnerAddr
503     )
504         external
505         onlyNetworkContracts
506     {
507         ProjectOwners.add(newOwnerAddr);
508     }
509 
510     function setPayment(address payee, uint256 did, uint256 amount)
511         external
512         onlyNetworkContracts
513     {
514         payment[payee][did] = amount;
515     }
516 
517     function setValidationToken(address verificatedUser, uint256 validationNumber)
518         external
519         onlyNetworkContracts
520     {
521         require(validationToken[verificatedUser] == 0, "Validation token is already set");
522         validationToken[verificatedUser] = validationNumber;
523     }
524 
525     function addDispute() external onlyNetworkContracts returns (uint256 disputeId) {
526         return dispute.length++;
527     }
528 
529     function addDisputeIds(uint256 disputeId, uint256 pid)
530         external
531         onlyValidProjectControllers(disputeId)
532     {
533         dispute[disputeId].disputeId = disputeId;
534         dispute[disputeId].pid = pid;
535     }
536 
537     function setDisputeVotePeriod(uint256 disputeId, uint256 numberOfBlock)
538         external
539         onlyValidProjectControllers(disputeId)
540     {
541         dispute[disputeId].disputeVotePeriod = numberOfBlock;
542     }
543 
544     function setDisputeControllerOfProject(uint256 disputeId, address disputeCtrlAddr)
545         external
546         onlyNetworkContracts
547     {
548         require(dispute[disputeId].disputeController == address(0), "This address is already set");
549         dispute[disputeId].disputeController = disputeCtrlAddr;
550     }
551 
552     function setVotedForRefundState(uint256 disputeId, uint256 numberOfBlock)
553         external
554         onlyValidProjectControllers(disputeId)
555     {
556         dispute[disputeId].resultCountPeriod = numberOfBlock;
557     }
558 
559     function setResultCountPeriod(uint256 disputeId, uint256 numberOfBlock)
560         external
561         onlyValidProjectControllers(disputeId)
562     {
563         dispute[disputeId].resultCountPeriod = numberOfBlock;
564     }
565 
566     function setNumberOfVotesForRefundState(uint256 disputeId)
567         external
568         onlyValidProjectControllers(disputeId)
569     {
570         dispute[disputeId].numberOfVotesForRefundState++;
571     }
572 
573     function setNumberOfVotesAgainstRefundState(uint256 disputeId)
574         external
575         onlyValidProjectControllers(disputeId)
576     {
577         dispute[disputeId].numberOfVotesAgainstRefundState++;
578     }
579 
580     function setDisputeLotteryPrize(uint256 disputeId, uint256 amount)
581         external
582         onlyValidProjectControllers(disputeId)
583     {
584         dispute[disputeId].votingPrize = amount;
585     }
586 
587     function setEntryFee(uint256 disputeId, uint256 amount)
588         external
589         onlyValidProjectControllers(disputeId)
590     {
591         dispute[disputeId].entryFee = amount;
592     }
593 
594     function setDisputeCreator(uint256 disputeId, address payable creator)
595         external
596         onlyValidProjectControllers(disputeId)
597     {
598         dispute[disputeId].creator = creator;
599     }
600 
601     function addToRandomNumberBase(uint256 disputeId, uint256 number)
602         external
603         onlyValidProjectControllers(disputeId)
604     {
605         dispute[disputeId].numbers.push(number);
606     }
607 
608     function setPublicDisputeURL(uint256 disputeId, bytes calldata disputeUrl)
609         external
610         onlyValidProjectControllers(disputeId)
611     {
612         dispute[disputeId].publicDisputeUrl = disputeUrl;
613     }
614 
615     function addDisputeVoter(uint256 disputeId, address payable voterAddress)
616         external
617         onlyValidProjectControllers(disputeId)
618         returns (uint256 voterId)
619     {
620         return dispute[disputeId].voters.push(voterAddress);
621     }
622 
623     function removeDisputeVoter(uint256 disputeId, uint256 voterIndex)
624         external
625         onlyValidProjectControllers(disputeId)
626     {
627         uint256 lastVoter = dispute[disputeId].voters.length - 1;
628         dispute[disputeId].voters[voterIndex] = dispute[disputeId].voters[lastVoter];
629         dispute[disputeId].voters.length--;
630     }
631 
632     function addHiddenVote(uint256 disputeId, address voter, bytes32 voteHash)
633         external
634         onlyValidProjectControllers(disputeId)
635     {
636         dispute[disputeId].hiddenVote[voter] = voteHash;
637     }
638 
639     function addRevealedVote(uint256 disputeId, address voter, bool vote)
640         external
641         onlyValidProjectControllers(disputeId)
642     {
643         dispute[disputeId].revealedVote[voter] = vote;
644     }
645 
646     function randomNumberGenerator(uint256 disputeId)
647         external
648         view
649         onlyValidProjectControllers(disputeId)
650         returns (uint256 rng)
651     {
652         rng = dispute[disputeId].numbers[0];
653         for (uint256 i = 1; dispute[disputeId].numbers.length > i; i++) {
654             rng ^= dispute[disputeId].numbers[i];
655         }
656     }
657 
658     function getCurrentControllersHash() external view returns (bytes32) {
659         return controllersHash;
660     }
661 
662     function getProjectController() external view returns (address payable) {
663         return projectController;
664     }
665 
666     function getRefundController() external view returns (address payable) {
667         return refundController;
668     }
669 
670     function getDisputeController() external view returns (address payable) {
671         return disputeController;
672     }
673 
674     function getUtilityController() external view returns (address payable) {
675         return utilityController;
676     }
677 
678     function getRefundEtherTokenAddress() external view returns (address payable) {
679         return refundEtherToken;
680     }
681 
682     function getAffiliateEscrow() external view returns (address payable) {
683         return affiliatesEscrow;
684     }
685 
686     function getRefundPool() external view returns (address payable) {
687         return refundPool;
688     }
689 
690     function getEventLogger() external view returns (address) {
691         return eventLogger;
692     }
693 
694     function getModerationResources() external view returns (address payable) {
695         return moderationResources;
696     }
697 
698     function getMainContract() external view returns (address payable) {
699         return main;
700     }
701 
702     function getSecondaryStorage() external view returns (address) {
703         return secondaryStorage;
704     }
705 
706     function getPrimaryStorage() external view returns(address) {
707         return address(this);
708     }
709 
710     function getdAppState(bytes32 cntrllrs)
711         external
712         view
713         returns (
714             address payable projectCtrl,
715             address payable refundCtrl,
716             address payable disputeCtrl,
717             address payable utilityCtrl
718         )
719     {
720         return (globalControllerStates[cntrllrs].projectController,
721                 globalControllerStates[cntrllrs].refundController,
722                 globalControllerStates[cntrllrs].disputeController,
723                 globalControllerStates[cntrllrs].utilityController
724         );
725     }
726 
727     function oldProjectCtrl(bytes32 cntrllrs)
728         external
729         view
730         returns (address payable)
731     {
732         return globalControllerStates[cntrllrs].projectController;
733     }
734 
735     function oldRefundCtrl(bytes32 cntrllrs)
736         external
737         view
738         returns (address payable)
739     {
740         return globalControllerStates[cntrllrs].refundController;
741     }
742 
743     function oldDisputeCtrl(bytes32 cntrllrs)
744         external
745         view
746         returns (address payable)
747     {
748         return globalControllerStates[cntrllrs].disputeController;
749     }
750 
751     function oldUtilityCtrl(bytes32 cntrllrs)
752         external
753         view
754         returns (address payable)
755     {
756         return globalControllerStates[cntrllrs].utilityController;
757     }
758 
759     function getIsNetworkDeployed() external view returns (bool) {
760         return isNetworkDeployed;
761     }
762 
763     function getMinInvestorContribution() external view returns (uint256) {
764         return minInvestorContribution;
765     }
766 
767     function getMaxInvestorContribution() external view returns (uint256) {
768         return maxInvestorContribution;
769     }
770 
771     function getNumberOfInvestors() external view returns (uint256) {
772         return investors.length;
773     }
774 
775     function getNumberOfInvestments() external view returns (uint256) {
776         return insurance.length;
777     }
778 
779     function getMinProtectionPercentage() external view returns (uint256) {
780         return minProtectionPercentage;
781     }
782 
783     function getMaxProtectionPercentage() external view returns (uint256) {
784         return maxProtectionPercentage;
785     }
786 
787     function getMinOwnerContribution() external view returns (uint256)
788     {
789         return minOwnerContribution;
790     }
791 
792     function getDefaultPolicyDuration() external view returns (uint256) {
793         return policyDuration;
794     }
795 
796     function getDefaultBasePolicyDuration() external view returns (uint256) {
797         return basePolicyDuration;
798     }
799 
800     function getRegularContributionPercentage() external view returns (uint256) {
801         return regularContributionPercentage;
802     }
803 
804     function getInsuranceControllerState(uint256 insId) external view returns(bytes32) {
805         return insurance[insId].controllerState;
806     }
807 
808     function getPoolContribution(uint256 insId) external view returns (uint256) {
809         return insurance[insId].poolContribution;
810     }
811 
812     function getInsuranceRate(uint256 insId) external view returns (uint256) {
813         return insurance[insId].insuranceRate;
814     }
815 
816     function isCanceled(uint256 insId) external view returns (bool) {
817         return insurance[insId].isCanceled;
818     }
819 
820     function getProjectOfInvestment(uint256 insId)
821         external
822         view
823         returns (uint256 projectId)
824     {
825         return insurance[insId].projectId;
826     }
827 
828     function getEtherSecured(uint256 insId) external view returns (uint256) {
829         return insurance[insId].etherSecured;
830     }
831 
832     function getInsuranceOwner(uint256 insId) external view returns (address) {
833         return insurance[insId].investmentOwner;
834     }
835 
836     function getTimeOfTheRequest(uint256 insId) external view returns (uint256) {
837         return insurance[insId].timeOfTheRequest;
838     }
839 
840     function getVotedForARefund(uint256 insId) external view returns (bool) {
841         return insurance[insId].votedForARefund;
842     }
843 
844     function getVotedAfterFailedVoting(uint256 insId) external view returns (bool) {
845         return insurance[insId].votedAfterFailedVoting;
846     }
847 
848     function getIsRefunded(uint256 insId) external view returns (bool) {
849         return insurance[insId].isRefunded;
850     }
851 
852     function getDisputeProjectId(uint256 disputeId) external view returns (uint256) {
853         return dispute[disputeId].pid;
854     }
855 
856     function getDisputesOfProject(uint256 pid) external view returns (uint256[] memory disputeIds) {
857         for (uint256 i = 0; i < dispute.length; i++) {
858             uint256 ids;
859             if (dispute[i].pid == pid) {
860                 disputeIds[ids] = pid;
861                 ids++;
862             }
863         }
864         return disputeIds;
865     }
866 
867     function getDisputeControllerOfProject(uint256 disputeId) external view returns (address) {
868         return dispute[disputeId].disputeController;
869     }
870 
871     function getDisputeVotePeriod(uint256 disputeId) external view returns (uint256) {
872         return dispute[disputeId].disputeVotePeriod;
873     }
874 
875     function getResultCountPeriod(uint256 disputeId) external view returns (uint256) {
876         return dispute[disputeId].resultCountPeriod;
877     }
878 
879     function getDisputeLotteryPrize(uint256 disputeId) external view returns (uint256 votingPrize) {
880         return dispute[disputeId].votingPrize;
881     }
882 
883     function getNumberOfVotesForRefundState(uint256 disputeId)
884         external
885         view
886         onlyNetworkContracts
887         returns (uint256)
888     {
889         return dispute[disputeId].numberOfVotesForRefundState;
890     }
891 
892     function getNumberOfVotesAgainstRefundState(uint256 disputeId)
893 		external
894 		view
895 		onlyNetworkContracts
896 		returns (uint256)
897 	{
898         return dispute[disputeId].numberOfVotesAgainstRefundState;
899     }
900 
901     function getEntryFee(uint256 disputeId) external view returns (uint256) {
902         return dispute[disputeId].entryFee;
903     }
904 
905     function getDisputeCreator(uint256 disputeId) external view returns (address payable) {
906         return dispute[disputeId].creator;
907     }
908 
909     function getRandomNumberBaseLength(uint256 disputeId) external view returns (uint256) {
910         return dispute[disputeId].numbers.length;
911     }
912 
913     function getPublicDisputeURL(uint256 disputeId) external view returns (bytes memory) {
914         return dispute[disputeId].publicDisputeUrl;
915     }
916 
917     function getDisputeVoter(uint256 disputeId, uint256 voterId) external view returns (address payable) {
918         return dispute[disputeId].voters[voterId];
919     }
920 
921     function getDisputeNumberOfVoters(uint256 disputeId) external view returns (uint256) {
922         return dispute[disputeId].voters.length;
923     }
924 
925     function getHiddenVote(uint256 disputeId, address voter)
926         external
927         view
928         onlyNetworkContracts
929         returns (bytes32)
930     {
931         return dispute[disputeId].hiddenVote[voter];
932     }
933 
934     function getRevealedVote(uint256 disputeId, address voter)
935 		    external
936 				view
937 				onlyNetworkContracts
938 				returns (bool) {
939         return dispute[disputeId].revealedVote[voter];
940     }
941 
942     function isVoteRevealed(uint256 disputeId, address voter)
943         external
944         view
945         onlyNetworkContracts
946         returns (bool)
947     {
948         for (uint256 i = 0; i < dispute[disputeId].voters.length; i++) {
949             if (dispute[disputeId].voters[i] == voter) {
950                 return true;
951             }
952         }
953         return false;
954     }
955 
956     function getInvestorAddressByInsurance(uint256 insId) external view returns (address) {
957         return insurance[insId].investmentOwner;
958     }
959 
960     function getInvestorAddressById(uint256 investorId) external view returns (address) {
961         return investors[investorId];
962     }
963 
964     function getInvestorId(address investor) external view returns (uint256) {
965         return investorData[investor].investorId;
966     }
967 
968     function getAmountAvailableForWithdraw(address userAddr, uint256 pid) external view returns (uint256) {
969         return investorData[userAddr].withdrawable[pid];
970     }
971 
972     function getReferrer(address investor) external view returns (address) {
973         return investorData[investor].referrer;
974     }
975 
976     function isInvestor(address who) external view returns (bool) {
977         return Investors.has(who);
978     }
979 
980     function isPlatformModerator(address who) public view returns (bool) {
981         return PlatformModerators.has(who);
982     }
983 
984     function isCommunityModerator(address who) external view returns (bool) {
985         return CommunityModerators.has(who);
986     }
987 
988     function isProjectOwner(address who) external view returns (bool) {
989         return ProjectOwners.has(who);
990     }
991 
992     function isArbiter(address who) external view returns (bool) {
993         return Arbiters.has(who);
994     }
995 
996     function getPayment(address payee, uint256 did) external view returns (uint256) {
997         return payment[payee][did];
998     }
999 
1000     function onlyInsuranceControllers(address caller, uint256 ins) external view returns (bool) {
1001         return _verifyInsuranceControllers(caller, ins);
1002     }
1003 
1004     function getValidationToken(address verificatedUser) external view returns (uint256) {
1005         return validationToken[verificatedUser];
1006     }
1007 
1008     function _updateControllersHash() internal returns (bytes32) {
1009         return controllersHash = keccak256(
1010             abi.encodePacked(
1011                 projectController,
1012                 refundController,
1013                 disputeController,
1014                 utilityController
1015         ));
1016     }
1017 
1018     function _verifyInsuranceControllers(address caller, uint256 ins) internal view returns (bool) {
1019         bytes32 ctrl = insurance[ins].controllerState;
1020         if (caller != globalControllerStates[ctrl].projectController &&
1021             caller != globalControllerStates[ctrl].refundController  &&
1022             caller != globalControllerStates[ctrl].disputeController &&
1023             caller != globalControllerStates[ctrl].utilityController) {
1024             return false;
1025         } else {
1026             return true;
1027         }
1028     }
1029 
1030     function _verifyDisputeController(uint256 disputeId) internal view {
1031         if (msg.sender != dispute[disputeId].disputeController) {
1032             revert("Invalid dispute controller");
1033         }
1034     }
1035 
1036     function _onlyDappContracts(address caller) internal view returns (bool) {
1037         if (isPlatformModerator(caller)) {
1038             return (isNetworkDeployed == false);
1039         } else {
1040             return(dAppContract[caller] != address(0));
1041         }
1042     }
1043 
1044     function allowOnlyDappContracts(address caller) external view returns (bool) {
1045         return _onlyDappContracts(caller);
1046     }
1047 
1048 
1049    /**
1050     *
1051     * Additional Amenable to evolution, extensible, flat key-value pair storage.
1052     * To be used for major dApp upgrades requiring additional data structures.
1053     *
1054     */
1055 
1056     mapping(bytes32 => uint256)         private uintStorage;
1057     mapping(bytes32 => address)         private addressStorage;
1058     mapping(bytes32 => bytes)           private bytesStorage;
1059     mapping(bytes32 => bool)            private boolStorage;
1060     mapping(bytes32 => string)          private stringStorage;
1061     mapping(bytes32 => int256)          private intStorage;
1062     mapping(bytes32 => address payable) private payableAddressStorage;
1063 
1064     function getAddress(bytes32 key) external view returns (address) {
1065         return addressStorage[key];
1066     }
1067 
1068     function getUint(bytes32 key) external view returns (uint) {
1069         return uintStorage[key];
1070     }
1071 
1072     function getBytes(bytes32 key) external view returns (bytes memory) {
1073         return bytesStorage[key];
1074     }
1075 
1076     function getBool(bytes32 key) external view returns (bool) {
1077         return boolStorage[key];
1078     }
1079 
1080     function getString(bytes32 key) external view returns (string memory) {
1081         return stringStorage[key];
1082     }
1083 
1084     function getInt(bytes32 key) external view returns (int) {
1085         return intStorage[key];
1086     }
1087 
1088     function getPayableAddress(bytes32 key) external view returns (address payable) {
1089         return payableAddressStorage[key];
1090     }
1091 
1092     function setAddress(bytes32 key, address value) external onlyNetworkContracts {
1093         addressStorage[key] = value;
1094     }
1095 
1096     function setUint(bytes32 key, uint value) external onlyNetworkContracts {
1097         uintStorage[key] = value;
1098     }
1099 
1100     function setBytes(bytes32 key, bytes calldata value) external onlyNetworkContracts {
1101         bytesStorage[key] = value;
1102     }
1103 
1104     function setBool(bytes32 key, bool value) external onlyNetworkContracts {
1105         boolStorage[key] = value;
1106     }
1107 
1108     function setString(bytes32 key, string calldata value) external onlyNetworkContracts {
1109         stringStorage[key] = value;
1110     }
1111 
1112     function setInt(bytes32 key, int value) external onlyNetworkContracts {
1113         intStorage[key] = value;
1114     }
1115 
1116     function setPayableAddress(bytes32 key, address payable value) external onlyNetworkContracts {
1117         payableAddressStorage[key] = value;
1118     }
1119 
1120     function deleteAddress(bytes32 key) external onlyNetworkContracts {
1121         delete addressStorage[key];
1122     }
1123 
1124     function deleteUint(bytes32 key) external onlyNetworkContracts {
1125         delete uintStorage[key];
1126     }
1127 
1128     function deleteString(bytes32 key) external onlyNetworkContracts {
1129         delete stringStorage[key];
1130     }
1131 
1132     function deleteBytes(bytes32 key) external onlyNetworkContracts {
1133         delete bytesStorage[key];
1134     }
1135 
1136     function deleteBool(bytes32 key) external onlyNetworkContracts {
1137         delete boolStorage[key];
1138     }
1139 
1140     function deleteInt(bytes32 key) external onlyNetworkContracts {
1141         delete intStorage[key];
1142     }
1143 
1144     function deletePayableAddress(bytes32 key) external onlyNetworkContracts {
1145         delete payableAddressStorage[key];
1146     }
1147 }