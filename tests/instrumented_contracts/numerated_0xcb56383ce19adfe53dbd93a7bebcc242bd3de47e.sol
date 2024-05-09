1 pragma solidity ^0.5.0;
2 
3 library BN256 {
4     struct G1Point {
5         uint x;
6         uint y;
7     }
8 
9     struct G2Point {
10         uint[2] x;
11         uint[2] y;
12     }
13 
14     function P1() internal pure returns (G1Point memory) {
15         return G1Point(1, 2);
16     }
17 
18     function P2() internal pure returns (G2Point memory) {
19         return G2Point(
20             [11559732032986387107991004021392285783925812861821192530917403151452391805634,
21             10857046999023057135944570762232829481370756359578518086990519993285655852781],
22 
23             [4082367875863433681332203403145435568316851327593401208105741076214120093531,
24             8495653923123431417604973247489272438418190587263600148770280649306958101930]
25         );
26     }
27 
28     function pointAdd(G1Point memory p1, G1Point memory p2) internal returns (G1Point memory r) {
29         uint[4] memory input;
30         input[0] = p1.x;
31         input[1] = p1.y;
32         input[2] = p2.x;
33         input[3] = p2.y;
34         assembly {
35             if iszero(call(sub(gas, 2000), 0x6, 0, input, 0x80, r, 0x40)) {
36                 revert(0, 0)
37             }
38         }
39     }
40 
41     function scalarMul(G1Point memory p, uint s) internal returns (G1Point memory r) {
42         uint[3] memory input;
43         input[0] = p.x;
44         input[1] = p.y;
45         input[2] = s;
46         assembly {
47             if iszero(call(sub(gas, 2000), 0x7, 0, input, 0x60, r, 0x40)) {
48                 revert(0, 0)
49             }
50         }
51     }
52 
53     function negate(G1Point memory p) internal pure returns (G1Point memory) {
54         if (p.x == 0 && p.y == 0) {
55             return p;
56         }
57         uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
58         return G1Point(p.x, q - p.y % q);
59     }
60 
61     function hashToG1(bytes memory data) internal returns (G1Point memory) {
62         uint256 h = uint256(keccak256(data));
63         return scalarMul(P1(), h);
64     }
65 
66     function G2Equal(G2Point memory p1, G2Point memory p2) internal pure returns (bool) {
67         return p1.x[0] == p2.x[0] && p1.x[1] == p2.x[1] && p1.y[0] == p2.y[0] && p1.y[1] == p2.y[1];
68     }
69 
70     // @return the result of computing the pairing check
71     // check passes if e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
72     // E.g. pairing([p1, p1.negate()], [p2, p2]) should return true.
73     function pairingCheck(G1Point[] memory p1, G2Point[] memory p2) internal returns (bool) {
74         require(p1.length == p2.length);
75         uint elements = p1.length;
76         uint inputSize = elements * 6;
77         uint[] memory input = new uint[](inputSize);
78 
79         for (uint i = 0; i < elements; i++)
80         {
81             input[i * 6 + 0] = p1[i].x;
82             input[i * 6 + 1] = p1[i].y;
83             input[i * 6 + 2] = p2[i].x[0];
84             input[i * 6 + 3] = p2[i].x[1];
85             input[i * 6 + 4] = p2[i].y[0];
86             input[i * 6 + 5] = p2[i].y[1];
87         }
88 
89         uint[1] memory out;
90         bool success;
91         assembly {
92             success := call(
93                 sub(gas, 2000),
94                 0x8,
95                 0,
96                 add(input, 0x20),
97                 mul(inputSize, 0x20),
98                 out, 0x20
99             )
100         }
101         return success && (out[0] != 0);
102     }
103 }
104 
105 /**
106  * @title Ownable
107  * @dev The Ownable contract has an owner address, and provides basic authorization control
108  * functions, this simplifies the implementation of "user permissions".
109  */
110 contract Ownable {
111   address private _owner;
112 
113   event OwnershipRenounced(address indexed previousOwner);
114   event OwnershipTransferred(
115     address indexed previousOwner,
116     address indexed newOwner
117   );
118 
119   /**
120    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
121    * account.
122    */
123   constructor() public {
124     _owner = msg.sender;
125   }
126 
127   /**
128    * @return the address of the owner.
129    */
130   function owner() public view returns(address) {
131     return _owner;
132   }
133 
134   /**
135    * @dev Throws if called by any account other than the owner.
136    */
137   modifier onlyOwner() {
138     require(isOwner());
139     _;
140   }
141 
142   /**
143    * @return true if `msg.sender` is the owner of the contract.
144    */
145   function isOwner() public view returns(bool) {
146     return msg.sender == _owner;
147   }
148 
149   /**
150    * @dev Allows the current owner to relinquish control of the contract.
151    * @notice Renouncing to ownership will leave the contract without an owner.
152    * It will not be possible to call the functions with the `onlyOwner`
153    * modifier anymore.
154    */
155   function renounceOwnership() public onlyOwner {
156     emit OwnershipRenounced(_owner);
157     _owner = address(0);
158   }
159 
160   /**
161    * @dev Allows the current owner to transfer control of the contract to a newOwner.
162    * @param newOwner The address to transfer ownership to.
163    */
164   function transferOwnership(address newOwner) public onlyOwner {
165     _transferOwnership(newOwner);
166   }
167 
168   /**
169    * @dev Transfers control of the contract to a newOwner.
170    * @param newOwner The address to transfer ownership to.
171    */
172   function _transferOwnership(address newOwner) internal {
173     require(newOwner != address(0));
174     emit OwnershipTransferred(_owner, newOwner);
175     _owner = newOwner;
176   }
177 }
178 
179 contract UserContractInterface {
180     // Query callback.
181     function __callback__(uint, bytes calldata) external;
182     // Random number callback.
183     function __callback__(uint, uint) external;
184 }
185 
186 contract CommitRevealInterface {
187     function startCommitReveal(uint, uint, uint, uint) public returns(uint);
188     function getRandom(uint) public returns(uint);
189 }
190 
191 contract DOSAddressBridgeInterface {
192     function getCommitRevealAddress() public view returns(address);
193     function getPaymentAddress() public view returns(address);
194     function getStakingAddress() public view returns(address);
195 }
196 
197 contract DOSPaymentInterface {
198     function hasServiceFee(address, uint) public view returns (bool);
199     function chargeServiceFee(address, uint, uint) public;
200     function recordServiceFee(uint, address, address[] memory) public;
201     function claimGuardianReward(address) public;
202     function setPaymentMethod(address, address) public;
203 }
204 
205 contract DOSStakingInterface {
206     function nodeStart(address _nodeAddr) public;
207     function nodeStop(address _nodeAddr) public;
208     function isValidStakingNode(address _nodeAddr) public view returns(bool);
209 }
210 
211 contract DOSProxy is Ownable {
212     using BN256 for *;
213 
214     // Metadata of pending request.
215     struct PendingRequest {
216         uint requestId;
217         uint groupId;
218         BN256.G2Point handledGroupPubKey;
219         // Calling contract who issues the request.
220         address callbackAddr;
221     }
222 
223     // Metadata of registered group.
224     struct Group {
225         uint groupId;
226         BN256.G2Point groupPubKey;
227         uint life;
228         uint birthBlkN;
229         address[] members;
230     }
231 
232     // Metadata of a to-be-registered group whose members are determined already.
233     struct PendingGroup {
234         uint groupId;
235         uint startBlkNum;
236         mapping(bytes32 => uint) pubKeyCounts;
237         // 0x1 (HEAD) -> member1 -> member2 -> ... -> memberN -> 0x1 (HEAD)
238         mapping(address => address) memberList;
239     }
240 
241     uint public initBlkN;
242     uint private requestIdSeed;
243     // calling requestId => PendingQuery metadata
244     mapping(uint => PendingRequest) PendingRequests;
245 
246     uint public refreshSystemRandomHardLimit = 1440; // in blocks, ~6 hour
247     uint public groupMaturityPeriod = refreshSystemRandomHardLimit * 28; // in blocks, ~7days
248     uint public lifeDiversity = refreshSystemRandomHardLimit * 12; // in blocks, ~3days
249     // avoid looping in a big loop that causing over gas.
250     uint public checkExpireLimit = 50;
251 
252     // Minimum 4 groups to bootstrap
253     uint public bootstrapGroups = 4;
254     // When regrouping, picking @groupToPick working groups, plus one group from pending nodes.
255     uint public groupToPick = 2;
256     uint public groupSize = 3;
257 
258     // Bootstrapping related arguments, in blocks.
259     uint public bootstrapCommitDuration = 40;
260     uint public bootstrapRevealDuration = 40;
261     uint public bootstrapStartThreshold = groupSize * bootstrapGroups;
262     uint public bootstrapRound;
263     uint public bootstrapEndBlk;
264 
265     DOSAddressBridgeInterface public addressBridge;
266     address public proxyFundsAddr;
267     address public proxyFundsTokenAddr;
268 
269     uint private constant UINTMAX = uint(-1);
270     // Dummy head and placeholder used in linkedlists.
271     uint private constant HEAD_I = 0x1;
272     address private constant HEAD_A = address(0x1);
273 
274     // Linkedlist of newly registered ungrouped nodes, with HEAD points to the earliest and pendingNodeTail points to the latest.
275     // Initial state: pendingNodeList[HEAD_A] == HEAD_A && pendingNodeTail == HEAD_A.
276     mapping(address => address) public pendingNodeList;
277     address public pendingNodeTail;
278     uint public numPendingNodes;
279 
280     // node => a linkedlist of working groupIds the node is in:
281     // node => (0x1 -> workingGroupId1 -> workingGroupId2 -> ... -> workingGroupIdm -> 0x1)
282     // Initial state: { nodeAddr : { HEAD_I : HEAD_I } }
283     mapping(address => mapping(uint => uint)) public nodeToGroupIdList;
284 
285     // groupId => Group
286     mapping(uint => Group) workingGroups;
287     // Index:groupId
288     uint[] public workingGroupIds;
289     uint[] public expiredWorkingGroupIds;
290 
291     // groupId => PendingGroup
292     mapping(uint => PendingGroup) public pendingGroups;
293     uint public pendingGroupMaxLife = 20;  // in blocks
294 
295     // Initial state: pendingGroupList[HEAD_I] == HEAD_I && pendingGroupTail == HEAD_I
296     mapping(uint => uint) public pendingGroupList;
297     uint public pendingGroupTail;
298     uint public numPendingGroups;
299 
300     uint public lastUpdatedBlock;
301     uint public lastRandomness;
302     uint public lastFormGrpReqId;
303     Group lastHandledGroup;
304 
305     // Only whitelised guardian are permitted to kick off signalUnregister process
306     // TODO : Chose a random group to check and has a consensus about which nodes should be unregister in v2.0.
307     mapping(address => bool) public guardianListed;
308     enum TrafficType {
309         SystemRandom,
310         UserRandom,
311         UserQuery
312     }
313 
314     event LogUrl(uint queryId, uint timeout, string dataSource, string selector, uint randomness, uint dispatchedGroupId);
315     event LogRequestUserRandom(uint requestId, uint lastSystemRandomness, uint userSeed, uint dispatchedGroupId);
316     event LogNonSupportedType(string invalidSelector);
317     event LogNonContractCall(address from);
318     event LogCallbackTriggeredFor(address callbackAddr);
319     event LogRequestFromNonExistentUC();
320     event LogUpdateRandom(uint lastRandomness, uint dispatchedGroupId);
321     event LogValidationResult(uint8 trafficType, uint trafficId, bytes message, uint[2] signature, uint[4] pubKey, bool pass);
322     event LogInsufficientPendingNode(uint numPendingNodes);
323     event LogInsufficientWorkingGroup(uint numWorkingGroups, uint numPendingGroups);
324     event LogGrouping(uint groupId, address[] nodeId);
325     event LogPublicKeyAccepted(uint groupId, uint[4] pubKey, uint numWorkingGroups);
326     event LogPublicKeySuggested(uint groupId, uint pubKeyCount);
327     event LogGroupDissolve(uint groupId);
328     event LogRegisteredNewPendingNode(address node);
329     event LogUnRegisteredNewPendingNode(address node, uint8 unregisterFrom);
330     event LogGroupingInitiated(uint pendingNodePool, uint groupsize);
331     event LogNoPendingGroup(uint groupId);
332     event LogPendingGroupRemoved(uint groupId);
333     event LogMessage(string info);
334     event UpdateGroupSize(uint oldSize, uint newSize);
335     event UpdateGroupMaturityPeriod(uint oldPeriod, uint newPeriod);
336     event UpdateLifeDiversity(uint lifeDiversity, uint newDiversity);
337     event UpdateBootstrapCommitDuration(uint oldDuration, uint newDuration);
338     event UpdateBootstrapRevealDuration(uint oldDuration, uint newDuration);
339     event UpdatebootstrapStartThreshold(uint oldThreshold, uint newThreshold);
340     event UpdatePendingGroupMaxLife(uint oldLifeBlocks, uint newLifeBlocks);
341     event UpdateBootstrapGroups(uint oldSize, uint newSize);
342     event UpdateSystemRandomHardLimit(uint oldLimit, uint newLimit);
343     event UpdateProxyFund(address oldFundAddr, address newFundAddr, address oldTokenAddr, address newTokenAddr);
344     event GuardianReward(uint blkNum, address guardian);
345 
346     modifier fromValidStakingNode {
347         require(DOSStakingInterface(addressBridge.getStakingAddress()).isValidStakingNode(msg.sender),
348                 "invalid-staking-node");
349         _;
350     }
351 
352     modifier hasOracleFee(address from, uint serviceType) {
353         require(
354             DOSPaymentInterface(addressBridge.getPaymentAddress()).hasServiceFee(from, serviceType),
355             "not-enough-fee-to-oracle");
356         _;
357     }
358 
359     modifier onlyGuardianListed {
360         require(guardianListed[msg.sender], "not-guardian");
361         _;
362     }
363 
364     constructor(address _bridgeAddr, address _proxyFundsAddr, address _proxyFundsTokenAddr) public {
365         initBlkN = block.number;
366         pendingNodeList[HEAD_A] = HEAD_A;
367         pendingNodeTail = HEAD_A;
368         pendingGroupList[HEAD_I] = HEAD_I;
369         pendingGroupTail = HEAD_I;
370         addressBridge = DOSAddressBridgeInterface(_bridgeAddr);
371         proxyFundsAddr = _proxyFundsAddr;
372         proxyFundsTokenAddr = _proxyFundsTokenAddr;
373         DOSPaymentInterface(addressBridge.getPaymentAddress()).setPaymentMethod(proxyFundsAddr, proxyFundsTokenAddr);
374     }
375 
376     function addToGuardianList(address _addr) public onlyOwner {
377         guardianListed[_addr] = true;
378     }
379 
380     function removeFromGuardianList(address _addr) public onlyOwner {
381         delete guardianListed[_addr];
382     }
383 
384     function getLastHandledGroup() public view returns(uint, uint[4] memory, uint, uint, address[] memory) {
385         return (
386             lastHandledGroup.groupId,
387             getGroupPubKey(lastHandledGroup.groupId),
388             lastHandledGroup.life,
389             lastHandledGroup.birthBlkN,
390             lastHandledGroup.members
391         );
392     }
393 
394     function getWorkingGroupById(uint groupId) public view returns(uint, uint[4] memory, uint, uint, address[] memory) {
395         return (
396             workingGroups[groupId].groupId,
397             getGroupPubKey(groupId),
398             workingGroups[groupId].life,
399             workingGroups[groupId].birthBlkN,
400             workingGroups[groupId].members
401         );
402     }
403 
404     function workingGroupIdsLength() public view returns(uint256) {
405         return workingGroupIds.length;
406     }
407 
408     function expiredWorkingGroupIdsLength() public view returns(uint256) {
409         return expiredWorkingGroupIds.length;
410     }
411 
412     function setProxyFund(address newFund, address newFundToken) public onlyOwner {
413         require(newFund != proxyFundsAddr && newFund != address(0x0), "not-valid-parameter");
414         require(newFundToken != proxyFundsTokenAddr && newFundToken != address(0x0), "not-valid-parameter");
415         emit UpdateProxyFund(proxyFundsAddr, newFund, proxyFundsTokenAddr, newFundToken);
416         proxyFundsAddr = newFund;
417         proxyFundsTokenAddr = newFundToken;
418         DOSPaymentInterface(addressBridge.getPaymentAddress()).setPaymentMethod(proxyFundsAddr, proxyFundsTokenAddr);
419     }
420 
421     // groupSize must be an odd number.
422     function setGroupSize(uint newSize) public onlyOwner {
423         require(newSize != groupSize && newSize % 2 != 0, "not-valid-parameter");
424         emit UpdateGroupSize(groupSize, newSize);
425         groupSize = newSize;
426     }
427 
428     function setBootstrapStartThreshold(uint newThreshold) public onlyOwner {
429         require(newThreshold != bootstrapStartThreshold, "not-valid-parameter");
430         emit UpdatebootstrapStartThreshold(bootstrapStartThreshold, newThreshold);
431         bootstrapStartThreshold = newThreshold;
432     }
433 
434     function setGroupMaturityPeriod(uint newPeriod) public onlyOwner {
435         require(newPeriod != groupMaturityPeriod && newPeriod != 0, "not-valid-parameter");
436         emit UpdateGroupMaturityPeriod(groupMaturityPeriod, newPeriod);
437         groupMaturityPeriod = newPeriod;
438     }
439 
440     function setLifeDiversity(uint newDiversity) public onlyOwner {
441         require(newDiversity != lifeDiversity && newDiversity != 0, "not-valid-parameter");
442         emit UpdateLifeDiversity(lifeDiversity, newDiversity);
443         lifeDiversity = newDiversity;
444     }
445 
446     function setPendingGroupMaxLife(uint newLife) public onlyOwner {
447         require(newLife != pendingGroupMaxLife && newLife != 0, "not-valid-parameter");
448         emit UpdatePendingGroupMaxLife(pendingGroupMaxLife, newLife);
449         pendingGroupMaxLife = newLife;
450     }
451 
452     function setSystemRandomHardLimit(uint newLimit) public onlyOwner {
453         require(newLimit != refreshSystemRandomHardLimit && newLimit != 0, "not-valid-parameter");
454         emit UpdateSystemRandomHardLimit(refreshSystemRandomHardLimit, newLimit);
455         refreshSystemRandomHardLimit = newLimit;
456     }
457 
458     function getCodeSize(address addr) private view returns (uint size) {
459         assembly {
460             size := extcodesize(addr)
461         }
462     }
463 
464     function dispatchJobCore(TrafficType trafficType, uint pseudoSeed) private returns(uint idx) {
465         uint dissolveIdx = 0;
466         do {
467             if (workingGroupIds.length == 0) {
468                 return UINTMAX;
469             }
470             if (dissolveIdx >= workingGroupIds.length ||
471                 dissolveIdx >= checkExpireLimit) {
472                 uint rnd = uint(keccak256(abi.encodePacked(trafficType, pseudoSeed, lastRandomness, block.number)));
473                 return rnd % workingGroupIds.length;
474             }
475             Group storage group = workingGroups[workingGroupIds[dissolveIdx]];
476             if (groupMaturityPeriod + group.birthBlkN + group.life <= block.number) {
477                 // Dissolving expired working groups happens in another phase for gas reasons.
478                 expiredWorkingGroupIds.push(workingGroupIds[dissolveIdx]);
479                 workingGroupIds[dissolveIdx] = workingGroupIds[workingGroupIds.length - 1];
480                 workingGroupIds.length--;
481             }
482             dissolveIdx++;
483         } while (true);
484     }
485 
486     function dispatchJob(TrafficType trafficType, uint pseudoSeed) private returns(uint) {
487         if (refreshSystemRandomHardLimit + lastUpdatedBlock <= block.number) {
488             kickoffRandom();
489         }
490         return dispatchJobCore(trafficType, pseudoSeed);
491     }
492 
493     function kickoffRandom() private {
494         uint idx = dispatchJobCore(TrafficType.SystemRandom, uint(blockhash(block.number - 1)));
495         // TODO: keep id receipt and handle later in v2.0.
496         if (idx == UINTMAX) {
497             emit LogMessage("no-live-wgrp,try-bootstrap");
498             return;
499         }
500 
501         lastUpdatedBlock = block.number;
502         lastHandledGroup = workingGroups[workingGroupIds[idx]];
503         // Signal off-chain clients
504         emit LogUpdateRandom(lastRandomness, lastHandledGroup.groupId);
505         DOSPaymentInterface(addressBridge.getPaymentAddress()).chargeServiceFee(proxyFundsAddr, /*requestId=*/lastRandomness, uint(TrafficType.SystemRandom));
506     }
507 
508     function insertToPendingGroupListTail(uint groupId) private {
509         pendingGroupList[groupId] = pendingGroupList[pendingGroupTail];
510         pendingGroupList[pendingGroupTail] = groupId;
511         pendingGroupTail = groupId;
512         numPendingGroups++;
513     }
514 
515     function insertToPendingNodeListTail(address node) private {
516         pendingNodeList[node] = pendingNodeList[pendingNodeTail];
517         pendingNodeList[pendingNodeTail] = node;
518         pendingNodeTail = node;
519         numPendingNodes++;
520     }
521 
522     function insertToPendingNodeListHead(address node) private {
523         pendingNodeList[node] = pendingNodeList[HEAD_A];
524         pendingNodeList[HEAD_A] = node;
525         numPendingNodes++;
526     }
527 
528     function insertToListHead(mapping(uint => uint) storage list, uint id) private {
529         list[id] = list[HEAD_I];
530         list[HEAD_I] = id;
531     }
532 
533     /// Remove Node from a storage linkedlist.
534     function removeNodeFromList(mapping(address => address) storage list, address node) private returns(address, bool) {
535         (address prev, bool found) = findNodeFromList(list, node);
536         if (found) {
537             list[prev] = list[node];
538             delete list[node];
539         }
540         return (prev, found);
541     }
542 
543     /// Find Node from a storage linkedlist.
544     function findNodeFromList(mapping(address => address) storage list, address node) private view returns(address, bool) {
545         address prev = HEAD_A;
546         address curr = list[prev];
547         while (curr != HEAD_A && curr != node) {
548             prev = curr;
549             curr = list[prev];
550         }
551         if (curr == HEAD_A) {
552             return (HEAD_A, false);
553         } else {
554             return (prev, true);
555         }
556     }
557 
558     /// Remove id from a storage linkedlist. Need to check tail after this done
559     function removeIdFromList(mapping(uint => uint) storage list, uint id) private returns(uint, bool) {
560         uint prev = HEAD_I;
561         uint curr = list[prev];
562         while (curr != HEAD_I && curr != id) {
563             prev = curr;
564             curr = list[prev];
565         }
566         if (curr == HEAD_I) {
567             return (HEAD_I, false);
568         } else {
569             list[prev] = list[curr];
570             delete list[curr];
571             return (prev, true);
572         }
573     }
574 
575     /// Remove node from a storage linkedlist.
576     function checkAndRemoveFromPendingGroup(address node) private returns(bool) {
577         uint prev = HEAD_I;
578         uint curr = pendingGroupList[prev];
579         while (curr != HEAD_I) {
580             PendingGroup storage pgrp = pendingGroups[curr];
581             (, bool found) = findNodeFromList(pgrp.memberList, node);
582             if (found) {
583                 cleanUpPendingGroup(curr);
584                 return true;
585             }
586             prev = curr;
587             curr = pendingGroupList[prev];
588         }
589         return false;
590     }
591 
592     /// @notice Caller ensures no index overflow.
593     function dissolveWorkingGroup(uint groupId, bool backToPendingPool) private {
594         /// Deregister expired working group and remove metadata.
595         Group storage grp = workingGroups[groupId];
596         for (uint i = 0; i < grp.members.length; i++) {
597             address member = grp.members[i];
598             // Update nodeToGroupIdList[member] and put members back to pendingNodeList's tail if necessary.
599             // Notice: Guardian may need to signal group formation.
600             (uint prev, bool removed) = removeIdFromList(nodeToGroupIdList[member], grp.groupId);
601             if (removed && prev == HEAD_I) {
602                 if (backToPendingPool && pendingNodeList[member] == address(0)) {
603                     insertToPendingNodeListTail(member);
604                 }
605             }
606         }
607         delete workingGroups[groupId];
608         emit LogGroupDissolve(groupId);
609     }
610 
611     // Returns query id.
612     function query(
613         address from,
614         uint timeout,
615         string calldata dataSource,
616         string calldata selector
617     )
618         external
619         hasOracleFee(from, uint(TrafficType.UserQuery))
620         returns (uint)
621     {
622         if (getCodeSize(from) > 0) {
623             bytes memory bs = bytes(selector);
624             // '': Return whole raw response;
625             // Starts with '$': response format is parsed as json.
626             // Starts with '/': response format is parsed as xml/html.
627             if (bs.length == 0 || bs[0] == '$' || bs[0] == '/') {
628                 uint queryId = uint(keccak256(abi.encode(++requestIdSeed, from, timeout, dataSource, selector)));
629                 uint idx = dispatchJob(TrafficType.UserQuery, queryId);
630                 // TODO: keep id receipt and handle later in v2.0.
631                 if (idx == UINTMAX) {
632                     emit LogMessage("skipped-user-query-no-live-wgrp");
633                     return 0;
634                 }
635                 Group storage grp = workingGroups[workingGroupIds[idx]];
636                 PendingRequests[queryId] = PendingRequest(queryId, grp.groupId, grp.groupPubKey, from);
637                 emit LogUrl(
638                     queryId,
639                     timeout,
640                     dataSource,
641                     selector,
642                     lastRandomness,
643                     grp.groupId
644                 );
645                 DOSPaymentInterface(addressBridge.getPaymentAddress()).chargeServiceFee(from, queryId, uint(TrafficType.UserQuery));
646                 return queryId;
647             } else {
648                 emit LogNonSupportedType(selector);
649                 return 0;
650             }
651         } else {
652             // Skip if @from is not contract address.
653             emit LogNonContractCall(from);
654             return 0;
655         }
656     }
657 
658     // Request a new user-level random number.
659     function requestRandom(address from, uint userSeed)
660         public
661         hasOracleFee(from, uint(TrafficType.UserRandom))
662         returns (uint)
663     {
664         uint requestId = uint(keccak256(abi.encode(++requestIdSeed, from, userSeed)));
665         uint idx = dispatchJob(TrafficType.UserRandom, requestId);
666         // TODO: keep id receipt and handle later in v2.0.
667         if (idx == UINTMAX) {
668             emit LogMessage("skipped-user-rnd-no-live-wgrp");
669             return 0;
670         }
671         Group storage grp = workingGroups[workingGroupIds[idx]];
672         PendingRequests[requestId] = PendingRequest(requestId, grp.groupId, grp.groupPubKey, from);
673         // sign(requestId ||lastSystemRandomness || userSeed ||
674         // selected sender in group)
675         emit LogRequestUserRandom(
676             requestId,
677             lastRandomness,
678             userSeed,
679             grp.groupId
680         );
681         DOSPaymentInterface(addressBridge.getPaymentAddress()).chargeServiceFee(
682             from == address(this) ? proxyFundsAddr : from,
683             requestId,
684             uint(TrafficType.UserRandom)
685         );
686         return requestId;
687     }
688 
689     // Random submitter validation + group signature verification.
690     function validateAndVerify(
691         uint8 trafficType,
692         uint trafficId,
693         bytes memory data,
694         BN256.G1Point memory signature,
695         BN256.G2Point memory grpPubKey
696     )
697         private
698         returns (bool)
699     {
700         // Validation. Clients actually signs (data || addr(selected_submitter)).
701         bytes memory message = abi.encodePacked(data, msg.sender);
702 
703         // Verification
704         BN256.G1Point[] memory p1 = new BN256.G1Point[](2);
705         BN256.G2Point[] memory p2 = new BN256.G2Point[](2);
706         p1[0] = BN256.negate(signature);
707         p1[1] = BN256.hashToG1(message);
708         p2[0] = BN256.P2();
709         p2[1] = grpPubKey;
710         bool passVerify = BN256.pairingCheck(p1, p2);
711         emit LogValidationResult(
712             trafficType,
713             trafficId,
714             message,
715             [signature.x, signature.y],
716             [grpPubKey.x[0], grpPubKey.x[1], grpPubKey.y[0], grpPubKey.y[1]],
717             passVerify
718         );
719         return passVerify;
720     }
721 
722     function triggerCallback(
723         uint requestId,
724         uint8 trafficType,
725         bytes calldata result,
726         uint[2] calldata sig
727     )
728         external
729         fromValidStakingNode
730     {
731         address ucAddr = PendingRequests[requestId].callbackAddr;
732         if (ucAddr == address(0x0)) {
733             emit LogRequestFromNonExistentUC();
734             return;
735         }
736 
737         if (!validateAndVerify(
738                 trafficType,
739                 requestId,
740                 result,
741                 BN256.G1Point(sig[0], sig[1]),
742                 PendingRequests[requestId].handledGroupPubKey))
743         {
744             return;
745         }
746 
747         emit LogCallbackTriggeredFor(ucAddr);
748         delete PendingRequests[requestId];
749         if (trafficType == uint8(TrafficType.UserQuery)) {
750             UserContractInterface(ucAddr).__callback__(requestId, result);
751         } else if (trafficType == uint8(TrafficType.UserRandom)) {
752             // Safe random number is the collectively signed threshold signature
753             // of the message (requestId || lastRandomness || userSeed ||
754             // selected sender in group).
755             emit LogMessage("UserRandom");
756             UserContractInterface(ucAddr).__callback__(
757                 requestId, uint(keccak256(abi.encodePacked(sig[0], sig[1]))));
758         } else {
759             revert("unsupported-traffic-type");
760         }
761         Group memory grp = workingGroups[PendingRequests[requestId].groupId];
762         DOSPaymentInterface(addressBridge.getPaymentAddress()).recordServiceFee(requestId, msg.sender, grp.members);
763     }
764 
765     function toBytes(uint x) private pure returns (bytes memory b) {
766         b = new bytes(32);
767         assembly { mstore(add(b, 32), x) }
768     }
769 
770     // System-level secure distributed random number generator.
771     function updateRandomness(uint[2] calldata sig) external fromValidStakingNode {
772         if (!validateAndVerify(
773                 uint8(TrafficType.SystemRandom),
774                 lastRandomness,
775                 toBytes(lastRandomness),
776                 BN256.G1Point(sig[0], sig[1]),
777                 lastHandledGroup.groupPubKey))
778         {
779             return;
780         }
781 
782         uint id = lastRandomness;
783         // Update new randomness = sha3(collectively signed group signature)
784         lastRandomness = uint(keccak256(abi.encodePacked(sig[0], sig[1])));
785         DOSPaymentInterface(addressBridge.getPaymentAddress()).recordServiceFee(id, msg.sender, lastHandledGroup.members);
786     }
787 
788     function cleanUpPendingGroup(uint gid) private {
789         PendingGroup storage pgrp = pendingGroups[gid];
790         address member = pgrp.memberList[HEAD_A];
791         while (member != HEAD_A) {
792             // 1. Put member back to pendingNodeList's tail if it's not in any workingGroup.
793             if (nodeToGroupIdList[member][HEAD_I] == HEAD_I && pendingNodeList[member] == address(0)) {
794                 insertToPendingNodeListTail(member);
795             }
796             member = pgrp.memberList[member];
797         }
798         // 2. Update pendingGroupList
799         (uint prev, bool removed) = removeIdFromList(pendingGroupList, gid);
800         // Reset pendingGroupTail if necessary.
801         if (removed && pendingGroupTail == gid) {
802             pendingGroupTail = prev;
803         }
804 
805         // 3. Update pendingGroup
806         delete pendingGroups[gid];
807         numPendingGroups--;
808         emit LogPendingGroupRemoved(gid);
809     }
810 
811     /// Guardian node functions
812     /// @dev Guardian signals expiring system randomness and kicks off distributed random engine again.
813     ///  Anyone including but not limited to DOS client node can be a guardian and claim rewards.
814     function signalRandom() public {
815         if (lastUpdatedBlock + refreshSystemRandomHardLimit > block.number) {
816             emit LogMessage("sys-random-not-expired");
817             return;
818         }
819 
820         kickoffRandom();
821         emit GuardianReward(block.number, msg.sender);
822         DOSPaymentInterface(addressBridge.getPaymentAddress()).claimGuardianReward(msg.sender);
823     }
824 
825     /// @dev Guardian signals to dissolve expired (workingGroup + pendingGroup) and claim guardian rewards.
826     function signalGroupDissolve() public {
827         // Clean up oldest expired PendingGroup and related metadata. Might be due to failed DKG.
828         uint gid = pendingGroupList[HEAD_I];
829         if (gid != HEAD_I && pendingGroups[gid].startBlkNum + pendingGroupMaxLife < block.number) {
830             cleanUpPendingGroup(gid);
831             emit GuardianReward(block.number, msg.sender);
832             DOSPaymentInterface(addressBridge.getPaymentAddress()).claimGuardianReward(msg.sender);
833         } else {
834             emit LogMessage("no-expired-pgrp-to-clean");
835         }
836     }
837     /// @dev Guardian signals to trigger group formation when there're enough pending nodes.
838     ///  If there aren't enough working groups to choose to dossolve, probably a new bootstrap is needed.
839     function signalGroupFormation() public {
840         if (formGroup()) {
841             emit GuardianReward(block.number, msg.sender);
842             DOSPaymentInterface(addressBridge.getPaymentAddress()).claimGuardianReward(msg.sender);
843         } else {
844             emit LogMessage("no-grp-formation");
845         }
846     }
847     function signalBootstrap(uint _cid) public {
848         require(bootstrapRound == _cid, "not-in-bootstrap");
849 
850         if (block.number <= bootstrapEndBlk) {
851             emit LogMessage("wait-to-collect-more-entropy");
852             return;
853         }
854         if (numPendingNodes < bootstrapStartThreshold) {
855             emit LogMessage("not-enough-p-node-to-bootstrap");
856             return;
857         }
858         // Reset.
859         bootstrapRound = 0;
860         bootstrapEndBlk = 0;
861         uint rndSeed = CommitRevealInterface(addressBridge.getCommitRevealAddress()).getRandom(_cid);
862         if (rndSeed == 0) {
863             emit LogMessage("bootstrap-commit-reveal-failure");
864             return;
865         }
866         lastRandomness = uint(keccak256(abi.encodePacked(lastRandomness, rndSeed)));
867         lastUpdatedBlock = block.number;
868 
869         uint arrSize = bootstrapStartThreshold / groupSize * groupSize;
870         address[] memory candidates = new address[](arrSize);
871 
872         pick(arrSize, 0, candidates);
873         shuffle(candidates, lastRandomness);
874         regroup(candidates, arrSize / groupSize);
875         emit GuardianReward(block.number, msg.sender);
876         DOSPaymentInterface(addressBridge.getPaymentAddress()).claimGuardianReward(msg.sender);
877     }
878     // TODO: Chose a random group to check and has a consensus about which nodes should be unregister in v2.0
879     function signalUnregister(address member) public onlyGuardianListed {
880         if (unregister(member)) {
881             emit GuardianReward(block.number, msg.sender);
882             DOSPaymentInterface(addressBridge.getPaymentAddress()).claimGuardianReward(msg.sender);
883         } else {
884             emit LogMessage("nothing-to-unregister");
885         }
886     }
887     /// End of Guardian functions
888 
889     function unregisterNode() public fromValidStakingNode returns (bool) {
890         return unregister(msg.sender);
891     }
892 
893     // Returns true if successfully unregistered node.
894     function unregister(address node) private returns (bool) {
895         uint groupId = nodeToGroupIdList[node][HEAD_I];
896         bool removed = false;
897         uint8 unregisteredFrom = 0;
898         // Check if node is in workingGroups or expiredWorkingGroup
899         if (groupId != 0 && groupId != HEAD_I) {
900             dissolveWorkingGroup(groupId, true);
901             for (uint idx = 0; idx < workingGroupIds.length; idx++) {
902                 if (workingGroupIds[idx] == groupId) {
903                     if (idx != (workingGroupIds.length - 1)) {
904                         workingGroupIds[idx] = workingGroupIds[workingGroupIds.length - 1];
905                     }
906                     workingGroupIds.length--;
907                     removed = true;
908                     unregisteredFrom |= 0x1;
909                     break;
910                 }
911             }
912             if (!removed) {
913                 for (uint idx = 0; idx < expiredWorkingGroupIds.length; idx++) {
914                     if (expiredWorkingGroupIds[idx] == groupId) {
915                         if (idx != (expiredWorkingGroupIds.length - 1)) {
916                             expiredWorkingGroupIds[idx] = expiredWorkingGroupIds[expiredWorkingGroupIds.length - 1];
917                         }
918                         expiredWorkingGroupIds.length--;
919                         removed = true;
920                         unregisteredFrom |= 0x2;
921                         break;
922                     }
923                 }
924             }
925         }
926 
927         // Check if node is in pendingGroups
928         if (!removed && checkAndRemoveFromPendingGroup(node)) {
929             unregisteredFrom |= 0x4;
930         }
931 
932 		// Check if node is in pendingNodeList
933         if (pendingNodeList[node] != address(0)) {
934             // Update pendingNodeList
935             address prev;
936             (prev, removed) = removeNodeFromList(pendingNodeList, node);
937             if (removed) {
938                 numPendingNodes--;
939                 nodeToGroupIdList[node][HEAD_I] = 0;
940                 // Reset pendingNodeTail if necessary.
941                 if (pendingNodeTail == node) {
942                     pendingNodeTail = prev;
943                 }
944                 unregisteredFrom |= 0x8;
945             }
946         }
947         emit LogUnRegisteredNewPendingNode(node, unregisteredFrom);
948         DOSStakingInterface(addressBridge.getStakingAddress()).nodeStop(node);
949         return (unregisteredFrom != 0);
950     }
951 
952     // Caller ensures no index overflow.
953     function getGroupPubKey(uint idx) public view returns (uint[4] memory) {
954         BN256.G2Point storage pubKey = workingGroups[workingGroupIds[idx]].groupPubKey;
955         return [pubKey.x[0], pubKey.x[1], pubKey.y[0], pubKey.y[1]];
956     }
957 
958     function getWorkingGroupSize() public view returns (uint) {
959         return workingGroupIds.length;
960     }
961 
962     function getExpiredWorkingGroupSize() public view returns (uint) {
963         return expiredWorkingGroupIds.length;
964     }
965 
966     function registerNewNode() public fromValidStakingNode {
967         // Duplicated pending node
968         if (pendingNodeList[msg.sender] != address(0)) {
969             return;
970         }
971         //Already registered in pending or working groups
972         if (nodeToGroupIdList[msg.sender][HEAD_I] != 0) {
973             return;
974         }
975         nodeToGroupIdList[msg.sender][HEAD_I] = HEAD_I;
976         insertToPendingNodeListTail(msg.sender);
977         emit LogRegisteredNewPendingNode(msg.sender);
978         DOSStakingInterface(addressBridge.getStakingAddress()).nodeStart(msg.sender);
979         formGroup();
980     }
981 
982     // Form into new working groups or bootstrap if necessary.
983     // Return true if forms a new group.
984     function formGroup() private returns(bool) {
985         // Clean up oldest expiredWorkingGroup and push back nodes to pendingNodeList if:
986         // 1. There's not enough pending nodes to form a group;
987         // 2. There's no working group and not enough pending nodes to restart bootstrap.
988         if (numPendingNodes < groupSize ||
989             (workingGroupIds.length == 0 && numPendingNodes < bootstrapStartThreshold)) {
990             if (expiredWorkingGroupIds.length > 0) {
991                 dissolveWorkingGroup(expiredWorkingGroupIds[0], true);
992                 expiredWorkingGroupIds[0] = expiredWorkingGroupIds[expiredWorkingGroupIds.length - 1];
993                 expiredWorkingGroupIds.length--;
994             }
995         }
996 
997         if (numPendingNodes < groupSize) {
998             emit LogInsufficientPendingNode(numPendingNodes);
999             return false;
1000         }
1001 
1002         if (workingGroupIds.length > 0) {
1003             if (expiredWorkingGroupIds.length >= groupToPick) {
1004                 if (lastFormGrpReqId == 0) {
1005                     lastFormGrpReqId = requestRandom(address(this), block.number);
1006                     if (lastFormGrpReqId == 0) return false;
1007                     emit LogGroupingInitiated(numPendingNodes, groupSize);
1008                     return true;
1009                 } else {
1010                     emit LogMessage("already-in-formation");
1011                     return false;
1012                 }
1013             } else {
1014                 emit LogMessage("skipped-formation-not-enough-expired-wgrp");
1015             }
1016         } else if (numPendingNodes >= bootstrapStartThreshold) { // No working group alive and satisfies system re-bootstrap condition.
1017             if (bootstrapRound == 0) {
1018                 bootstrapRound = CommitRevealInterface(addressBridge.getCommitRevealAddress()).startCommitReveal(
1019                     block.number,
1020                     bootstrapCommitDuration,
1021                     bootstrapRevealDuration,
1022                     bootstrapStartThreshold
1023                 );
1024                 bootstrapEndBlk = block.number + bootstrapCommitDuration + bootstrapRevealDuration;
1025                 return true;
1026             } else {
1027                 emit LogMessage("already-in-bootstrap");
1028             }
1029         }
1030         return false;
1031     }
1032 
1033     // callback to handle re-grouping using generated random number as random seed.
1034     function __callback__(uint requestId, uint rndSeed) external {
1035         require(msg.sender == address(this), "unauthenticated-resp");
1036         require(expiredWorkingGroupIds.length >= groupToPick, "regroup-not-enough-expired-wgrp");
1037         require(numPendingNodes >= groupSize, "regroup-not-enough-p-node");
1038 
1039         lastFormGrpReqId = 0;
1040         uint arrSize = groupSize * (groupToPick + 1);
1041         address[] memory candidates = new address[](arrSize);
1042         for (uint i = 0; i < groupToPick; i++) {
1043             uint idx = uint(keccak256(abi.encodePacked(rndSeed, requestId, i))) % expiredWorkingGroupIds.length;
1044             Group storage grpToDissolve = workingGroups[expiredWorkingGroupIds[idx]];
1045             for (uint j = 0; j < groupSize; j++) {
1046                 candidates[i * groupSize + j] = grpToDissolve.members[j];
1047             }
1048             dissolveWorkingGroup(grpToDissolve.groupId, false);
1049             expiredWorkingGroupIds[idx] = expiredWorkingGroupIds[expiredWorkingGroupIds.length - 1];
1050             expiredWorkingGroupIds.length--;
1051         }
1052 
1053         pick(groupSize, groupSize * groupToPick, candidates);
1054         shuffle(candidates, rndSeed);
1055         regroup(candidates, groupToPick + 1);
1056     }
1057 
1058     // Pick @num nodes from pendingNodeList's head and put into the @candidates array from @startIndex.
1059     function pick(uint num, uint startIndex, address[] memory candidates) private {
1060         for (uint i = 0; i < num; i++) {
1061             address curr = pendingNodeList[HEAD_A];
1062             pendingNodeList[HEAD_A] = pendingNodeList[curr];
1063             delete pendingNodeList[curr];
1064             candidates[startIndex + i] = curr;
1065         }
1066         numPendingNodes -= num;
1067         // Reset pendingNodeTail if necessary.
1068         if (numPendingNodes == 0) {
1069             pendingNodeTail = HEAD_A;
1070         }
1071     }
1072 
1073     // Shuffle a memory array using a secure random seed.
1074     function shuffle(address[] memory arr, uint rndSeed) private pure {
1075         for (uint i = arr.length - 1; i > 0; i--) {
1076             uint j = uint(keccak256(abi.encodePacked(rndSeed, i, arr[i]))) % (i + 1);
1077             address tmp = arr[i];
1078             arr[i] = arr[j];
1079             arr[j] = tmp;
1080         }
1081     }
1082 
1083     // Regroup a shuffled node array.
1084     function regroup(address[] memory candidates, uint num) private {
1085         require(candidates.length == groupSize * num, "candidate-length-mismatch");
1086 
1087         address[] memory members = new address[](groupSize);
1088         uint groupId;
1089         for (uint i = 0; i < num; i++) {
1090             groupId = 0;
1091             // Generated groupId = sha3(...(sha3(sha3(member 1), member 2), ...), member n)
1092             for (uint j = 0; j < groupSize; j++) {
1093                 members[j] = candidates[i * groupSize + j];
1094                 groupId = uint(keccak256(abi.encodePacked(groupId, members[j])));
1095             }
1096             pendingGroups[groupId] = PendingGroup(groupId, block.number);
1097             mapping(address => address) storage memberList = pendingGroups[groupId].memberList;
1098             memberList[HEAD_A] = HEAD_A;
1099             for (uint j = 0; j < groupSize; j++) {
1100                 memberList[members[j]] = memberList[HEAD_A];
1101                 memberList[HEAD_A] = members[j];
1102             }
1103             insertToPendingGroupListTail(groupId);
1104             emit LogGrouping(groupId, members);
1105         }
1106     }
1107 
1108     function registerGroupPubKey(uint groupId, uint[4] calldata suggestedPubKey)
1109         external
1110         fromValidStakingNode
1111     {
1112         PendingGroup storage pgrp = pendingGroups[groupId];
1113         if (pgrp.groupId == 0) {
1114             emit LogNoPendingGroup(groupId);
1115             return;
1116         }
1117 
1118         require(pgrp.memberList[msg.sender] != address(0), "not-from-authorized-grp-member");
1119 
1120         bytes32 hashedPubKey = keccak256(abi.encodePacked(
1121             suggestedPubKey[0], suggestedPubKey[1], suggestedPubKey[2], suggestedPubKey[3]));
1122         pgrp.pubKeyCounts[hashedPubKey]++;
1123         emit LogPublicKeySuggested(groupId, pgrp.pubKeyCounts[hashedPubKey]);
1124         if (pgrp.pubKeyCounts[hashedPubKey] > groupSize / 2) {
1125             address[] memory memberArray = new address[](groupSize);
1126             uint idx = 0;
1127             address member = pgrp.memberList[HEAD_A];
1128             while (member != HEAD_A) {
1129                 memberArray[idx++] = member;
1130                 // Update nodeToGroupIdList[member] with new group id.
1131                 insertToListHead(nodeToGroupIdList[member], groupId);
1132                 member = pgrp.memberList[member];
1133             }
1134 
1135             workingGroupIds.push(groupId);
1136             workingGroups[groupId] = Group(
1137                 groupId,
1138                 BN256.G2Point([suggestedPubKey[0], suggestedPubKey[1]], [suggestedPubKey[2], suggestedPubKey[3]]),
1139                 numPendingGroups * lifeDiversity,
1140                 block.number,
1141                 memberArray
1142             );
1143             // Update pendingGroupList
1144             (uint prev, bool removed) = removeIdFromList(pendingGroupList, groupId);
1145             // Reset pendingGroupTail if necessary.
1146             if (removed && pendingGroupTail == groupId) {
1147                 pendingGroupTail = prev;
1148             }
1149             // Update pendingGroup
1150             delete pendingGroups[groupId];
1151             numPendingGroups--;
1152             emit LogPendingGroupRemoved(groupId);
1153             emit LogPublicKeyAccepted(groupId, suggestedPubKey, workingGroupIds.length);
1154         }
1155     }
1156 }