1 pragma solidity ^0.5.7;
2 
3 
4 contract ReentrancyGuard {
5     uint256 private _guardCounter;
6 
7     constructor () internal {
8         _guardCounter = 1;
9     }
10 
11     modifier nonReentrant() {
12         _guardCounter += 1;
13         uint256 localCounter = _guardCounter;
14         _;
15         require(localCounter == _guardCounter);
16     }
17 }
18 
19 
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25         uint256 c = a * b;
26         require(c / a == b);
27 
28         return c;
29     }
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0);
32         uint256 c = a / b;
33 
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b <= a);
39         uint256 c = a - b;
40 
41         return c;
42     }
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a);
46 
47         return c;
48     }
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b != 0);
51         return a % b;
52     }
53 }
54 
55 
56 interface PrimaryStorage {
57     function isPlatformModerator(address who) external view returns (bool);
58     function isCommunityModerator(address who) external view returns (bool);
59     function getProjectController() external view returns (address);
60     function getRefundController() external view returns (address);
61     function getDisputeController() external view returns (address);
62     function getUtilityController() external view returns (address);
63     function getAffiliateEscrow() external view returns (address payable);
64     function getRefundPool() external view returns (address payable);
65     function getdAppState(bytes32 controllersHash) external view returns (address projectController, address refundController, address disputeController, address maintenanceController);
66     function getInsuranceControllerState(uint256 insId) external view returns (bytes32);
67     function oldProjectCtrl(bytes32 controllersHash) external view returns (address payable);
68     function oldRefundCtrl(bytes32 controllersHash) external view returns (address payable);
69     function oldDisputeCtrl(bytes32 cntrllrs) external view  returns (address payable);
70     function oldUtilityCtrl(bytes32 cntrllrs) external view  returns (address payable);
71     function getIsNetworkDeployed() external view returns (bool);
72     function getCurrentControllersHash() external view returns (bytes32 controllerState);
73     function getProjectCurrentState(uint256) external view returns (uint8);
74     function setEventLogger(address loggerAddress) external;
75     function setModerationResources(address payable modResourcesAddr) external;
76     function setMainContract(address mainContract) external;
77     function setProjectController(address payable controllerAddress) external;
78     function setRefundController(address payable controllerAddress) external;
79     function setDisputeController(address payable controllerAddress) external;
80     function setUtilityController(address payable controllerAddress) external;
81     function addNewContract(address payable dAppContractAddress) external;
82     function setPlatformModerator(address newPlModAddr) external;
83     function setMinInvestorContribution(uint256 newMinInvestorContribution) external;
84     function setMaxInvestorContribution(uint256 newMaxInvestorContribution) external;
85     function setMinProtectionPercentage(uint256 newPercentage) external;
86     function setMaxProtectionPercentage(uint256 newPercentage) external;
87     function setMinOwnerContribution(uint256 newMinOwnContrib) external;
88     function setDefaultBasePolicyDuration(uint256 newBasePolicyPeriod) external;
89     function setDefaultPolicyDuration(uint256 newPolicyPeriod) external;
90     function setRegularContributionPercentage(uint256 newPercentage) external;
91     function getDisputeProjectId(uint256 disputeId) external view returns (uint256);
92     function setValidationToken(address verificatedUser, uint256 validationNumber) external;
93     function getDisputeControllerOfProject(uint256 disputeId) external view returns (address);
94 }
95 
96 
97 interface SecondaryStorage {
98     function getRefundControllerOfProject(uint256 pid) external view returns (address);
99     function getDisputeControllerOfProject(uint256 pid) external view returns (address);
100     function getUitilityControllerOfProject(uint256 pid) external view returns (address);
101     function getProjectControllerOfProject(uint256 pid) external view returns (address);
102     function getProjectCurrentState(uint256 pid) external view returns (uint8);
103     function getVoteEnd(uint256 pid) external view returns (uint256);
104     function getProjectControllerState(uint256 pid) external view returns (bytes32);
105     function getUtilityControllerOfProject(uint256 pid) external view returns (address);
106 }
107 
108 
109 interface ProjectController {
110     function newProject(
111 				bytes calldata projectName,
112 				address tokenAddress,
113 				uint256 crowdsaleEnd,
114 				uint256 highestCrowdsalePrice,
115 				uint8 tokenDecimals
116 		)
117 				external
118 				payable;
119     function newInsurance(
120 				address payable insOwner,
121 				uint256 pid,
122 				address referrer
123 		)
124 				external
125 				payable
126 				returns (bool success);
127     function newOwnerContribution(uint256 pid, address ownerAddr) external payable;
128     function close(uint256 pid) external;
129     function setNewProjectTokenPrice(
130 				uint256 pid,
131 				uint256 newPrice,
132 				uint256 insuranceId
133 		)
134 				external
135 				returns (uint256 numberOfChanges);
136     function isOpen(uint256 projectId) external returns (bool);
137     function upgrade(uint256 insId) external;
138 }
139 
140 
141 interface RefundController {
142      function cancel(uint256 ins, uint256 pid, address insOwner) external returns (bool);
143      function voteForRefundState(address owner, uint256 ins, uint256 pid) external returns (bool);
144      function withdraw(address owner, uint256 ins, uint256 pid) external returns (bool);
145      function forceRefundState(address moderator, uint256 pid) external;
146      function finalizeVote(uint256 pid) external;
147 }
148 
149 
150 interface DisputeController {
151     function createNewDispute(
152 				address caller,
153 				uint256 pid,
154 				bytes calldata publicDisputeUrl
155 		)
156 				external
157 				payable
158 				returns (bool);
159     function addPublicVote(address voter, uint256 did, bytes32 hiddenVote) external payable returns (bool);
160     function decryptVote(address voter, uint256 did, bool isProjectFailed, uint64 pin) external returns (bool);
161     function finalizeDispute(uint256 did) external returns (bool);
162 }
163 
164 
165 interface UtilityController {
166     function withdraw(uint256 pid, address payable owner, uint256 insuranceId) external;
167     function withdrawInsuranceFee(uint256 pid, address payable owner, uint256 insuranceId) external;
168     function ownerWithdraw(address owner, address sendTo, uint256 pid) external returns (bool);
169     function withdrawDisputePayment(address payable caller, uint256 did) external;
170     function cancelInvalid(uint256 pid, uint256[8] calldata invalidInsuranceId) external;
171     function cancelProjectCovarage(uint256 pid) external;
172     function managePolicies(uint256 startFromn, uint256 umberOfProjects) external;
173     function voteMaintenance(uint256 startFrom, uint256 numberOfProjects) external;
174     function affiliatePayment(address owner) external;
175     function removeCanceled(uint256 pid, uint256[8] calldata canceledInsIdx) external;
176 }
177 
178 
179 interface AffiliateEscrow {
180     function deposit(address affiliate) external payable;
181     function getAffiliatePayment (address affiliate) external view returns (uint256);
182     function withdraw(address to) external;
183     function updateControllerState(
184 				address payable projectCtrl,
185 				address payable refundCtrl,
186 				address payable disputeCtrl,
187 				address payable utilityCtrl
188 		)
189 				external;
190 }
191 
192 
193 interface RefundPool {
194     function cleanIfNoProjects() external;
195 }
196 
197 
198 /**
199   *
200   *  Refundable Token Offerings - RTO
201   *  DAO platform for insurance of investments
202   *  in token offerings with a refund option.
203   *
204   *  Autonomous, open source and completely transparent
205   *  dApp for decentralized investment insurances in blockchain
206   *  projects (ICOs, STOs, IEOs, etc) managed entirely by smart
207   *  contracts and governed by the participants in it.
208   *
209   */
210 
211 
212 contract RefundableTokenOffering is ReentrancyGuard {
213     using SafeMath for uint256;
214 
215     PrimaryStorage    private masterStorage;
216     SecondaryStorage  private secondStorage;
217     RefundPool        private pool;
218 
219     ProjectController private projectController;
220     RefundController  private refundController;
221     DisputeController private disputeController;
222     UtilityController private utilityController;
223 
224     AffiliateEscrow private affiliate;
225 
226     bytes32 private controllersHash;
227     address payable private refundPool;
228 
229 
230     event CommunityAidReceived(address sender, uint256 value);
231     event ControllerUpgrade(address newController);
232 
233     constructor(
234         address primaryStorage,
235         address secondaryStorage,
236         address payable refundPoolAddress,
237         address payable affiliateEscrow
238     )
239         public
240     {
241         masterStorage = PrimaryStorage(primaryStorage);
242         secondStorage = SecondaryStorage(secondaryStorage);
243         refundPool = refundPoolAddress;
244         affiliate = AffiliateEscrow(affiliateEscrow);
245     }
246 
247     function() external payable {
248         emit CommunityAidReceived(msg.sender, msg.value);
249     }
250 
251     ///////////////////////////////////////////////////
252     //  Access modifiers
253     //////////////////////////////////////////////////
254 
255     modifier onlyModerators {
256         if (!masterStorage.isPlatformModerator(msg.sender)) {
257             revert("Not allowed");
258         }
259         _;
260     }
261 
262     modifier onlyOpen(uint256 pid) {
263         if (secondStorage.getProjectCurrentState(pid) == 0) {
264             _;
265         } else {
266             revert("The project is not open");
267         }
268     }
269 
270     modifier onlyExternalAccounts(address sender) {
271         if (_isContract(sender)) {
272             revert("Not allowed");
273         } else {
274             _;
275         }
276 
277     }
278 
279     ///////////////////////////////////////////////////
280     //  Main View
281     //////////////////////////////////////////////////
282 
283     function addCoveredProject(
284         bytes   memory projectName,
285         address tokenAddress,
286         uint256 crowdsaleEnd,
287         uint256 highestCrowdsalePrice,
288         uint8   tokenDecimals
289     )
290         public
291         payable
292         onlyModerators
293     {
294         projectController.newProject.value(msg.value)(
295             projectName,
296             tokenAddress,
297             crowdsaleEnd,
298             highestCrowdsalePrice,
299             tokenDecimals
300         );
301     }
302 
303     function newInvestmentProtection(uint256 pid, address referrer)
304         external
305         payable
306         nonReentrant
307         onlyOpen(pid)
308         onlyExternalAccounts(msg.sender)
309     {
310         ProjectController project = _projectControllerOfProject(pid);
311         project.newInsurance.value(msg.value)(msg.sender, pid, referrer);
312     }
313 
314     function projectOwnerContribution(uint256 pid)
315         external
316         payable
317         nonReentrant
318         onlyOpen(pid)
319     {
320         ProjectController project = _projectControllerOfProject(pid);
321         project.newOwnerContribution.value(msg.value)(pid, msg.sender);
322     }
323 
324     function closeProject(uint256 pid)
325         public
326         payable
327         onlyModerators
328     {
329         ProjectController project = _projectControllerOfProject(pid);
330         project.close(pid);
331     }
332 
333     function setProjectTokenPrice(uint256 pid, uint256 newPrice, uint256 insuranceId)
334         public
335         payable
336         onlyModerators
337     {
338         ProjectController project = _projectControllerOfProject(pid);
339         project.setNewProjectTokenPrice(pid, newPrice, insuranceId);
340     }
341 
342     function cancelInsurance(uint256 ins, uint256 pid) external nonReentrant {
343         RefundController refund = _refundControllerOfInsurance(ins);
344         refund.cancel(ins, pid, msg.sender);
345     }
346 
347     function voteForRefundState(uint256 ins, uint256 pid) external nonReentrant {
348         RefundController refund = _refundControllerOfInsurance(ins);
349         refund.voteForRefundState(msg.sender, ins, pid);
350     }
351 
352     function requestRefundWithdraw(uint256 ins, uint256 pid) external nonReentrant {
353         RefundController refund = _refundControllerOfInsurance(ins);
354         refund.withdraw(msg.sender, ins, pid);
355     }
356 
357     function finishInternalVote(uint256 pid) public {
358         uint8 pcs = secondStorage.getProjectCurrentState(pid);
359         uint256 voteEndDate = secondStorage.getVoteEnd(pid);
360         require(pcs == 2 && block.number > voteEndDate, "The project is not in a internal vote period, or it is not finished");
361         RefundController refund = _refundControllerOfProject(pid);
362         refund.finalizeVote(pid);
363     }
364 
365     function forceRefundState(uint256 pid) public onlyModerators {
366         RefundController refund = _refundControllerOfProject(pid);
367         refund.forceRefundState(msg.sender, pid);
368     }
369 
370     function createPublicDispute(uint256 pid, bytes calldata publicDisputeUrl)
371         external
372         payable
373         nonReentrant
374         onlyExternalAccounts(msg.sender)
375     {
376         DisputeController dispute = _disputeControllerOfProject(pid);
377         dispute.createNewDispute.value(msg.value)(msg.sender, pid, publicDisputeUrl);
378     }
379 
380     function newPublicVote(uint256 did, bytes32 encryptedVote)
381         external
382         payable
383         nonReentrant
384         onlyExternalAccounts(msg.sender)
385     {
386         DisputeController dispute = _disputeControllerOfDispute(did);
387         dispute.addPublicVote.value(msg.value)(msg.sender, did, encryptedVote);
388     }
389 
390     function revealPublicVote(
391         uint256 did,
392         bool isProjectFailed,
393         uint64 pin
394     )
395         external
396         returns (bool)
397     {
398         DisputeController dispute = _disputeControllerOfDispute(did);
399         dispute.decryptVote(msg.sender, did, isProjectFailed, pin);
400     }
401 
402     function finishPublicDispute(uint256 did)
403         external
404         nonReentrant
405     {
406         DisputeController dispute = _disputeControllerOfDispute(did);
407         dispute.finalizeDispute(did);
408     }
409 
410     function withdrawDisputePayment(uint256 did) external nonReentrant {
411         uint256 pid = masterStorage.getDisputeProjectId(did);
412         UtilityController utility = _utilityControllerOfProject(pid);
413         utility.withdrawDisputePayment(msg.sender, did);
414     }
415 
416     function setValidationToken(address verificatedUser, uint256 validationNumber) public onlyModerators {
417         masterStorage.setValidationToken(verificatedUser, validationNumber);
418     }
419 
420     function withdraw(uint256 pid, uint256 insuranceId) external nonReentrant {
421         UtilityController utility = _utilityControllerOfInsurance(insuranceId);
422         utility.withdraw(pid, msg.sender, insuranceId);
423     }
424 
425     function withdrawFee(uint256 pid, uint256 insuranceId) external nonReentrant {
426         UtilityController utility = _utilityControllerOfInsurance(insuranceId);
427         utility.withdrawInsuranceFee(pid, msg.sender, insuranceId);
428     }
429 
430     function affiliatePayment() external nonReentrant {
431         affiliate.withdraw(msg.sender);
432     }
433 
434     function cancelInvalidInsurances(uint256 projectId, uint256[8] memory invalidInsuranceId) public
435     {
436         UtilityController utility = _utilityControllerOfProject(projectId);
437         utility.cancelInvalid(projectId, invalidInsuranceId);
438     }
439 
440     function removeCanceledInsurances(
441         uint256 pid,
442         uint256[8] memory invalidInsuranceId
443     )
444         public
445     {
446         UtilityController utility = _utilityControllerOfProject(pid);
447         utility.removeCanceled(pid, invalidInsuranceId);
448     }
449 
450     function withdrawOwnerFunds(uint256 pid, address sendTo) external nonReentrant returns (bool) {
451         UtilityController utility = _utilityControllerOfProject(pid);
452         return utility.ownerWithdraw(msg.sender, sendTo, pid);
453     }
454 
455     function cancelProjectCovarage(uint256 pid) public {
456         UtilityController utility = _utilityControllerOfProject(pid);
457         return utility.cancelProjectCovarage(pid);
458     }
459 
460     function policyMaintenance(uint256 startFrom, uint256 numberOfProjects) external nonReentrant {
461         return utilityController.managePolicies(startFrom, numberOfProjects);
462     }
463 
464     function voteMaintenance(uint256 startFrom, uint256 endBefore) external {
465         return utilityController.voteMaintenance(startFrom, endBefore);
466     }
467 
468     ///////////////////////////////////////////////////
469     //  State & Contracts
470     //////////////////////////////////////////////////
471 
472     function updateControllerState() public onlyModerators {
473         projectController = ProjectController(masterStorage.getProjectController());
474         refundController  = RefundController(masterStorage.getRefundController());
475         disputeController = DisputeController(masterStorage.getDisputeController());
476         utilityController = UtilityController(masterStorage.getUtilityController());
477         controllersHash   = masterStorage.getCurrentControllersHash();
478     }
479 
480     function transferAidToRefundPool() public onlyModerators {
481         address(refundPool).transfer(address(this).balance);
482     }
483 
484     function changeModerationResourcesAddress(address payable newModRsrcAddr)
485         public
486         onlyModerators
487     {
488         masterStorage.setModerationResources(newModRsrcAddr);
489     }
490 
491     function upgradeEventLogger(address newLogger) public onlyModerators {
492         masterStorage.setEventLogger(newLogger);
493     }
494 
495     function upgradeMain(address payable newMainContract) public onlyModerators {
496         masterStorage.setMainContract(newMainContract);
497     }
498 
499     function upgradeUtilityController(address payable newUtilityController)
500         public
501         onlyModerators
502     {
503         masterStorage.setUtilityController(newUtilityController);
504         emit ControllerUpgrade(newUtilityController);
505     }
506 
507     function upgradeDisputeController(address payable newDisputeController)
508         public
509         onlyModerators
510     {
511         masterStorage.setDisputeController(newDisputeController);
512         emit ControllerUpgrade(newDisputeController);
513 
514     }
515 
516     function upgradeRefundController(address payable newRefundController)
517         public
518         onlyModerators
519     {
520         masterStorage.setRefundController(newRefundController);
521         emit ControllerUpgrade(newRefundController);
522 
523     }
524 
525     function upgradeProjectController(address payable newProjectController)
526         public
527         onlyModerators
528     {
529         masterStorage.setProjectController(newProjectController);
530         emit ControllerUpgrade(newProjectController);
531     }
532 
533     function addNetworkContract(address payable newNetworkContract)
534         public
535         onlyModerators
536     {
537         masterStorage.addNewContract(newNetworkContract);
538     }
539 
540     function setPlatformModerator(address newMod) public onlyModerators {
541         masterStorage.setPlatformModerator(newMod);
542     }
543 
544     function setMinInvestorContribution(uint256 newMinInvestorContr) public onlyModerators {
545         masterStorage.setMinInvestorContribution(newMinInvestorContr);
546     }
547 
548     function setMaxInvestorContribution(uint256 newMaxInvestorContr) public onlyModerators {
549         masterStorage.setMaxInvestorContribution(newMaxInvestorContr);
550     }
551 
552     function setMinProtectionPercentage(uint256 newPercentage) public onlyModerators {
553         masterStorage.setMinProtectionPercentage(newPercentage);
554     }
555 
556     function setMaxProtectionPercentage(uint256 newPercentage) public onlyModerators
557     {
558         masterStorage.setMaxProtectionPercentage(newPercentage);
559     }
560 
561     function setMinOwnerContribution(uint256 newMinOwnContrib) public onlyModerators {
562         masterStorage.setMinOwnerContribution(newMinOwnContrib);
563     }
564 
565     function setDefaultBasePolicy(uint256 newBasePolicy) public onlyModerators {
566         masterStorage.setDefaultBasePolicyDuration(newBasePolicy);
567     }
568 
569     function setDefaultPolicy(uint256 newPolicy) public onlyModerators {
570         masterStorage.setDefaultPolicyDuration(newPolicy);
571     }
572 
573     function setRegularContributionPercentage(uint256 newPercentage) public onlyModerators {
574         masterStorage.setRegularContributionPercentage(newPercentage);
575     }
576 
577     function cleanIfNoProjects() public onlyModerators {
578         pool.cleanIfNoProjects();
579     }
580 
581     function _projectControllerOfProject(uint256 pid)
582         internal
583         view
584         returns (ProjectController)
585     {
586         return ProjectController(secondStorage.getProjectControllerOfProject(pid));
587     }
588 
589     function _refundControllerOfProject(uint256 pid)
590         internal
591         view
592         returns (RefundController)
593     {
594         return RefundController(secondStorage.getRefundControllerOfProject(pid));
595     }
596 
597     function _disputeControllerOfProject(uint256 pid)
598         internal
599         view
600         returns (DisputeController)
601     {
602         return DisputeController(secondStorage.getDisputeControllerOfProject(pid));
603     }
604 
605     function _disputeControllerOfDispute(uint256 did)
606         internal
607         view
608         returns (DisputeController)
609     {
610         return DisputeController(masterStorage.getDisputeControllerOfProject(did));
611     }
612 
613     function _utilityControllerOfProject(uint256 pid)
614         internal
615         view
616         returns (UtilityController)
617     {
618         return UtilityController(secondStorage.getUtilityControllerOfProject(pid));
619     }
620 
621     function _refundControllerOfInsurance(uint256 ins)
622         internal
623         view
624         returns (RefundController) {
625         bytes32 insCtrlState = masterStorage.getInsuranceControllerState(ins);
626 
627         if (controllersHash != insCtrlState) {
628             return RefundController(masterStorage.oldRefundCtrl(insCtrlState));
629         } else {
630             return refundController;
631         }
632     }
633 
634     function _utilityControllerOfInsurance(uint256 ins)
635         internal
636         view
637         returns (UtilityController) {
638         bytes32 insCtrlState = masterStorage.getInsuranceControllerState(ins);
639 
640         if (controllersHash != insCtrlState) {
641             return UtilityController(masterStorage.oldUtilityCtrl(insCtrlState));
642         } else {
643             return utilityController;
644         }
645     }
646 
647     function _isContract(address sender) internal view returns (bool) {
648         uint codeSize;
649         assembly {
650             codeSize := extcodesize(sender)
651         }
652         return(codeSize != 0);
653     }
654 }