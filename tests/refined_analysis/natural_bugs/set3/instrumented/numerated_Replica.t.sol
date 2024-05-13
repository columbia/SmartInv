1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import {ReplicaHarness} from "./harnesses/ReplicaHarness.sol";
5 import {Replica} from "../Replica.sol";
6 import {ReplicaHandlers} from "./utils/NomadTest.sol";
7 import {Message} from "../libs/Message.sol";
8 
9 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
10 
11 contract ReplicaTest is ReplicaHandlers {
12     // Read about memview: https://github.com/summa-tx/memview-sol
13     using TypedMemView for bytes;
14     using TypedMemView for bytes29;
15     using Message for bytes29;
16 
17     ReplicaHarness replica;
18 
19     uint256 optimisticTimeout;
20     bytes32 committedRoot;
21 
22     bytes32 exampleRoot;
23     bytes32 exampleLeaf;
24     uint256 exampleLeafIndex;
25     bytes32[32] exampleProof;
26 
27     function setUp() public virtual override {
28         super.setUp();
29         committedRoot = "commited root";
30 
31         replica = new ReplicaHarness(homeDomain);
32 
33         setUpExampleProof();
34         initializeReplica();
35     }
36 
37     function setUpExampleProof() public {
38         exampleRoot = hex"18f2f1646fee335a1eaf5191a8ce58ea772080057d0fda687df59c45e47e6f68";
39         exampleLeaf = hex"f0fe7c99ef23ace1835385e83dd61c9ecb6192d6514fcc13356ef912788eaa8a";
40         exampleLeafIndex = 0;
41         exampleProof[
42             0
43         ] = hex"65ad6b7c39c687dad3edc05bec09300b742363f5c1f42db586bdce40c9fc5eef";
44         exampleProof[
45             1
46         ] = hex"e9884debea0619a2ce25ba3bbe6a4438a42bc11b2308f62c65ed43be0b43d445";
47         exampleProof[
48             2
49         ] = hex"b4c11951957c6f8f642c4af61cd6b24640fec6dc7fc607ee8206a99e92410d30";
50         exampleProof[
51             3
52         ] = hex"21ddb9a356815c3fac1026b6dec5df3124afbadb485c9ba5a3e3398a04b7ba85";
53         exampleProof[
54             4
55         ] = hex"e58769b32a1beaf1ea27375a44095a0d1fb664ce2dd358e7fcbfb78c26a19344";
56         exampleProof[
57             5
58         ] = hex"0eb01ebfc9ed27500cd4dfc979272d1f0913cc9f66540d7e8005811109e1cf2d";
59         exampleProof[
60             6
61         ] = hex"887c22bd8750d34016ac3c66b5ff102dacdd73f6b014e710b51e8022af9a1968";
62         exampleProof[
63             7
64         ] = hex"ffd70157e48063fc33c97a050f7f640233bf646cc98d9524c6b92bcf3ab56f83";
65         exampleProof[
66             8
67         ] = hex"9867cc5f7f196b93bae1e27e6320742445d290f2263827498b54fec539f756af";
68         exampleProof[
69             9
70         ] = hex"cefad4e508c098b9a7e1d8feb19955fb02ba9675585078710969d3440f5054e0";
71         exampleProof[
72             10
73         ] = hex"f9dc3e7fe016e050eff260334f18a5d4fe391d82092319f5964f2e2eb7c1c3a5";
74         exampleProof[
75             11
76         ] = hex"f8b13a49e282f609c317a833fb8d976d11517c571d1221a265d25af778ecf892";
77         exampleProof[
78             12
79         ] = hex"3490c6ceeb450aecdc82e28293031d10c7d73bf85e57bf041a97360aa2c5d99c";
80         exampleProof[
81             13
82         ] = hex"c1df82d9c4b87413eae2ef048f94b4d3554cea73d92b0f7af96e0271c691e2bb";
83         exampleProof[
84             14
85         ] = hex"5c67add7c6caf302256adedf7ab114da0acfe870d449a3a489f781d659e8becc";
86         exampleProof[
87             15
88         ] = hex"da7bce9f4e8618b6bd2f4132ce798cdc7a60e7e1460a7299e3c6342a579626d2";
89         exampleProof[
90             16
91         ] = hex"2733e50f526ec2fa19a22b31e8ed50f23cd1fdf94c9154ed3a7609a2f1ff981f";
92         exampleProof[
93             17
94         ] = hex"e1d3b5c807b281e4683cc6d6315cf95b9ade8641defcb32372f1c126e398ef7a";
95         exampleProof[
96             18
97         ] = hex"5a2dce0a8a7f68bb74560f8f71837c2c2ebbcbf7fffb42ae1896f13f7c7479a0";
98         exampleProof[
99             19
100         ] = hex"b46a28b6f55540f89444f63de0378e3d121be09e06cc9ded1c20e65876d36aa0";
101         exampleProof[
102             20
103         ] = hex"c65e9645644786b620e2dd2ad648ddfcbf4a7e5b1a3a4ecfe7f64667a3f0b7e2";
104         exampleProof[
105             21
106         ] = hex"f4418588ed35a2458cffeb39b93d26f18d2ab13bdce6aee58e7b99359ec2dfd9";
107         exampleProof[
108             22
109         ] = hex"5a9c16dc00d6ef18b7933a6f8dc65ccb55667138776f7dea101070dc8796e377";
110         exampleProof[
111             23
112         ] = hex"4df84f40ae0c8229d0d6069e5c8f39a7c299677a09d367fc7b05e3bc380ee652";
113         exampleProof[
114             24
115         ] = hex"cdc72595f74c7b1043d0e1ffbab734648c838dfb0527d971b602bc216c9619ef";
116         exampleProof[
117             25
118         ] = hex"0abf5ac974a1ed57f4050aa510dd9c74f508277b39d7973bb2dfccc5eeb0618d";
119         exampleProof[
120             26
121         ] = hex"b8cd74046ff337f0a7bf2c8e03e10f642c1886798d71806ab1e888d9e5ee87d0";
122         exampleProof[
123             27
124         ] = hex"838c5655cb21c6cb83313b5a631175dff4963772cce9108188b34ac87c81c41e";
125         exampleProof[
126             28
127         ] = hex"662ee4dd2dd7b2bc707961b1e646c4047669dcb6584f0d8d770daf5d7e7deb2e";
128         exampleProof[
129             29
130         ] = hex"388ab20e2573d171a88108e79d820e98f26c0b84aa8b2f4aa4968dbb818ea322";
131         exampleProof[
132             30
133         ] = hex"93237c50ba75ee485f4c22adf2f741400bdf8d6a9cc7df7ecae576221665d735";
134         exampleProof[
135             31
136         ] = hex"8448818bb4ae4562849e949e17ac16e0be16688e156b5cf15e098c627c0056a9";
137     }
138 
139     function initializeReplica() public {
140         optimisticTimeout = 10;
141 
142         replica.initialize(
143             remoteDomain,
144             updaterAddr,
145             committedRoot,
146             optimisticTimeout
147         );
148         assertEq(uint256(replica.remoteDomain()), uint256(remoteDomain));
149         assertEq(replica.committedRoot(), committedRoot);
150         assertEq(replica.optimisticSeconds(), optimisticTimeout);
151         assertEq(replica.confirmAt(committedRoot), 1);
152     }
153 
154     function test_acceptReplicaUpdate() public {
155         bytes32 oldRoot = committedRoot;
156         bytes32 newRoot = "newRoot";
157         bytes memory sig = signRemoteUpdate(updaterPK, oldRoot, newRoot);
158         vm.expectEmit(true, true, true, true);
159         emit Update(remoteDomain, oldRoot, newRoot, sig);
160         replica.update(oldRoot, newRoot, sig);
161 
162         assertEq(
163             replica.confirmAt(newRoot),
164             block.timestamp + optimisticTimeout
165         );
166         assertEq(replica.committedRoot(), newRoot);
167     }
168 
169     function test_rejectReplicaNonCurrentUpdate() public {
170         bytes32 oldRoot = "non commited root";
171         bytes32 newRoot = "newRoot";
172         bytes memory sig = signRemoteUpdate(updaterPK, oldRoot, newRoot);
173         vm.expectRevert("not current update");
174         replica.update(oldRoot, newRoot, sig);
175     }
176 
177     function test_rejectReplicaUpdateInvalidSig() public {
178         bytes32 oldRoot = committedRoot;
179         bytes32 newRoot = "newRoot";
180         bytes memory sig = signRemoteUpdate(fakeUpdaterPK, oldRoot, newRoot);
181         vm.expectRevert("!updater sig");
182         replica.update(oldRoot, newRoot, sig);
183     }
184 
185     // Pre-computed values come from the nomad-xyz/rust test fixtures
186     // https://github.com/nomad-xyz/rust/blob/main/fixtures/merkle.json
187     function test_acceptLeafCorrectProof() public virtual {
188         replica.setCommittedRoot(exampleRoot);
189         assertTrue(replica.prove(exampleLeaf, exampleProof, exampleLeafIndex));
190     }
191 
192     function test_rejectLeafWrongProof() public {
193         replica.setCommittedRoot(exampleRoot);
194         // We change a small part of the proof to invalidate it
195         exampleProof[31] = "lol wrong proof m8";
196         assertFalse(replica.prove(exampleLeaf, exampleProof, exampleLeafIndex));
197     }
198 
199     event Process(
200         bytes32 indexed messageHash,
201         bool indexed success,
202         bytes indexed returnData
203     );
204 
205     function test_proveAndProcess() public {
206         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
207         bytes32 receiver = bytes32(uint256(uint160(address(goodXappSimple))));
208         uint32 nonce = 0;
209         bytes memory messageBody = "0x";
210         bytes memory message = Message.formatMessage(
211             remoteDomain,
212             sender,
213             nonce,
214             homeDomain,
215             receiver,
216             messageBody
217         );
218         (bytes32 root, , uint256 index, bytes32[32] memory proof) = merkleTest
219             .getProof(message);
220         replica.setCommittedRoot(root);
221         vm.expectEmit(true, true, true, true);
222         bytes memory returnData = hex"";
223         emit Process(message.ref(0).keccak(), true, returnData);
224         replica.proveAndProcess(message, proof, index);
225     }
226 
227     function test_processProvenMessage() public {
228         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
229         bytes32 receiver = bytes32(uint256(uint160(address(goodXappSimple))));
230         uint32 nonce = 0;
231         bytes memory messageBody = "0x";
232         bytes memory message = Message.formatMessage(
233             remoteDomain,
234             sender,
235             nonce,
236             homeDomain,
237             receiver,
238             messageBody
239         );
240         (
241             bytes32 root,
242             bytes32 leaf,
243             uint256 index,
244             bytes32[32] memory proof
245         ) = merkleTest.getProof(message);
246         replica.setCommittedRoot(root);
247         assertTrue(replica.prove(leaf, proof, index));
248         assertTrue(replica.process(message));
249     }
250 
251     function test_updateProveAndProcessMessage() public {
252         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
253         bytes32 receiver = bytes32(uint256(uint160(address(goodXappSimple))));
254         uint32 nonce = 0;
255         bytes memory messageBody = "0x";
256         bytes memory message = Message.formatMessage(
257             remoteDomain,
258             sender,
259             nonce,
260             homeDomain,
261             receiver,
262             messageBody
263         );
264         (
265             bytes32 newRoot,
266             bytes32 leaf,
267             uint256 index,
268             bytes32[32] memory proof
269         ) = merkleTest.getProof(message);
270         bytes32 oldRoot = committedRoot;
271         bytes memory sig = signRemoteUpdate(updaterPK, oldRoot, newRoot);
272         replica.update(oldRoot, newRoot, sig);
273         vm.warp(block.timestamp + replica.optimisticSeconds());
274         assertTrue(replica.prove(leaf, proof, index));
275         assertTrue(replica.process(message));
276     }
277 
278     /// @notice It should revert because process will call handle() in an empty address
279     function test_notProcessLegacyProvenMessageEmptyAddress() public {
280         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
281         bytes32 receiver = bytes32(uint256(uint160(vm.addr(431))));
282         uint32 nonce = 0;
283         bytes memory messageBody = "0x";
284         bytes memory message = Message.formatMessage(
285             remoteDomain,
286             sender,
287             nonce,
288             homeDomain,
289             receiver,
290             messageBody
291         );
292         replica.setMessageStatus(message, replica.LEGACY_STATUS_PROVEN());
293         vm.expectRevert();
294         replica.process(message);
295     }
296 
297     /// @notice It should not revert because process will call handle() and handle will simply return 0
298     function test_processLegacyProvenMessageReturnZeroHandler() public {
299         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
300         bytes32 receiver = bytes32(
301             uint256(uint160(address(badXappAssemblyReturnZero)))
302         );
303         uint32 nonce = 0;
304         bytes memory messageBody = hex"";
305         bytes memory message = Message.formatMessage(
306             remoteDomain,
307             sender,
308             nonce,
309             homeDomain,
310             receiver,
311             messageBody
312         );
313         replica.setMessageStatus(message, replica.LEGACY_STATUS_PROVEN());
314         vm.expectEmit(true, true, true, true);
315         emit Process(message.ref(0).keccak(), true, "");
316         assertTrue(replica.process(message));
317     }
318 
319     /// @notice It should revert because it calls a handle() function that has a require() that is not satisfied
320     function test_notProcessLegacyProvenMessageRevertingHandlers1() public {
321         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
322         bytes32 receiver = bytes32(
323             uint256(uint160(address(badXappRevertRequire)))
324         );
325         uint32 nonce = 0;
326         bytes memory messageBody = "0x";
327         bytes memory message = Message.formatMessage(
328             remoteDomain,
329             sender,
330             nonce,
331             homeDomain,
332             receiver,
333             messageBody
334         );
335         replica.setMessageStatus(message, replica.LEGACY_STATUS_PROVEN());
336         vm.expectRevert();
337         replica.process(message);
338     }
339 
340     /// @notice It revert because it calls a handle() function that has a require() that isn't satisfied. That require
341     //also returns a revert reason string
342     function test_notProcessLegacyProvenMessageRevertingHandlers2() public {
343         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
344         bytes32 receiver = bytes32(
345             uint256(uint160(address(badXappRevertRequireString)))
346         );
347         uint32 nonce = 0;
348         bytes memory messageBody = "0x";
349         bytes memory message = Message.formatMessage(
350             remoteDomain,
351             sender,
352             nonce,
353             homeDomain,
354             receiver,
355             messageBody
356         );
357         replica.setMessageStatus(message, replica.LEGACY_STATUS_PROVEN());
358         vm.expectRevert("no can do");
359         replica.process(message);
360     }
361 
362     /// @notice It should revert because it calls a handle() function that has a revert() call in the assembly{} block
363     function test_notProcessLegacyProvenMessageRevertingHandlers3() public {
364         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
365         bytes32 receiver = bytes32(
366             uint256(uint160(address(badXappRevertData)))
367         );
368         uint32 nonce = 0;
369         bytes memory messageBody = "0x";
370         bytes memory message = Message.formatMessage(
371             remoteDomain,
372             sender,
373             nonce,
374             homeDomain,
375             receiver,
376             messageBody
377         );
378         replica.setMessageStatus(message, replica.LEGACY_STATUS_PROVEN());
379         vm.expectRevert(
380             hex"0000000000000000000000000000000000000000000000000000000000abcdef"
381         );
382         replica.process(message);
383     }
384 
385     /// @notice It should revert because it calls a handle() function that has a revert() call in the assembly{} block
386     function test_notProcessLegacyProvenMessageRevertingHandlers4() public {
387         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
388         bytes32 receiver = bytes32(
389             uint256(uint160(address(badXappAssemblyRevert)))
390         );
391         uint32 nonce = 0;
392         bytes memory messageBody = "0x";
393         bytes memory message = Message.formatMessage(
394             remoteDomain,
395             sender,
396             nonce,
397             homeDomain,
398             receiver,
399             messageBody
400         );
401         replica.setMessageStatus(message, replica.LEGACY_STATUS_PROVEN());
402         vm.expectRevert();
403         replica.process(message);
404     }
405 
406     /// @notice It should revert because the message's destination is not this Replica's domain
407     function test_notProcessLegacyWrongDestination() public {
408         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
409         bytes32 receiver = bytes32(uint256(uint160(vm.addr(431))));
410         uint32 nonce = 0;
411         bytes memory messageBody = "0x";
412         bytes memory message = Message.formatMessage(
413             homeDomain,
414             sender,
415             nonce,
416             remoteDomain,
417             receiver,
418             messageBody
419         );
420         replica.setMessageStatus(message, replica.LEGACY_STATUS_PROVEN());
421         vm.expectRevert("!destination");
422         replica.process(message);
423     }
424 
425     /// @notice It should revert because the message is not proven, i.e is not included in the committed Root
426     function test_notProcessUnprovenMessage() public {
427         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
428         bytes32 receiver = bytes32(uint256(uint160(vm.addr(431))));
429         uint32 nonce = 0;
430         bytes memory messageBody = "0x";
431         bytes memory message = Message.formatMessage(
432             remoteDomain,
433             sender,
434             nonce,
435             homeDomain,
436             receiver,
437             messageBody
438         );
439         vm.expectRevert("!proven");
440         replica.process(message);
441     }
442 
443     event SetOptimisticTimeout(uint256 optimisticSeconds);
444 
445     function test_setOptimisticTimeoutOnlyOwner() public {
446         vm.expectEmit(false, false, false, true);
447         emit SetOptimisticTimeout(30000);
448         vm.prank(replica.owner());
449         replica.setOptimisticTimeout(30000);
450         vm.prank(vm.addr(1453));
451         vm.expectRevert("Ownable: caller is not the owner");
452         replica.setOptimisticTimeout(10);
453     }
454 
455     function test_setUpdaterOnlyOwner() public {
456         vm.expectEmit(false, false, false, true);
457         emit NewUpdater(updaterAddr, vm.addr(10));
458         vm.prank(replica.owner());
459         replica.setUpdater(vm.addr(10));
460         vm.prank(vm.addr(1453));
461         vm.expectRevert("Ownable: caller is not the owner");
462         replica.setUpdater(vm.addr(10));
463     }
464 
465     event SetConfirmation(
466         bytes32 indexed root,
467         uint256 previousConfirmAt,
468         uint256 newConfirmAt
469     );
470 
471     function test_setConfirmationOnlyOwnerNotZeroRoot() public {
472         bytes32 newRoot = "new root";
473         uint256 newConfirmAt = 100;
474         uint256 previousConfirmAt = 0;
475         vm.expectEmit(true, false, false, true);
476         emit SetConfirmation(newRoot, previousConfirmAt, newConfirmAt);
477         vm.prank(replica.owner());
478         replica.setConfirmation(newRoot, newConfirmAt);
479         assertEq(replica.confirmAt(newRoot), newConfirmAt);
480         vm.prank(vm.addr(1453));
481         vm.expectRevert("Ownable: caller is not the owner");
482         replica.setConfirmation(newRoot, newConfirmAt);
483     }
484 
485     function test_setConfirmationZeroRootOnlyRemove() public {
486         bytes32 newRoot = bytes32(0);
487         uint256 newConfirmAt = 0;
488         uint256 previousConfirmAt = replica.confirmAt(newRoot);
489         vm.expectEmit(true, false, false, true);
490         emit SetConfirmation(newRoot, previousConfirmAt, newConfirmAt);
491         vm.prank(replica.owner());
492         replica.setConfirmation(newRoot, newConfirmAt);
493         assertEq(replica.confirmAt(newRoot), newConfirmAt);
494         vm.prank(replica.owner());
495         newConfirmAt = 100;
496         vm.expectRevert("can't set zero root");
497         replica.setConfirmation(newRoot, newConfirmAt);
498     }
499 
500     function test_acceptableRootSuccess() public {
501         assertTrue(replica.acceptableRoot(committedRoot));
502     }
503 
504     function test_acceptableRootLegacySuccess() public {
505         assertTrue(replica.acceptableRoot(replica.LEGACY_STATUS_PROVEN()));
506     }
507 
508     function test_acceptableRootLegacyRejectStatus() public {
509         assertFalse(replica.acceptableRoot(replica.LEGACY_STATUS_PROCESSED()));
510         assertFalse(replica.acceptableRoot(replica.LEGACY_STATUS_NONE()));
511     }
512 
513     function test_acceptableRootRejectNotCommited() public {
514         bytes32 notSubmittedRoot = "no";
515         assertFalse(replica.acceptableRoot(notSubmittedRoot));
516     }
517 
518     function test_acceptableRootRejectNotTimedOut() public {
519         bytes32 sender = bytes32(uint256(uint160(vm.addr(134))));
520         bytes32 receiver = bytes32(uint256(uint160(address(goodXappSimple))));
521         uint32 nonce = 0;
522         bytes memory messageBody = "0x";
523         bytes memory message = Message.formatMessage(
524             remoteDomain,
525             sender,
526             nonce,
527             homeDomain,
528             receiver,
529             messageBody
530         );
531         (bytes32 newRoot, , , ) = merkleTest.getProof(message);
532         bytes32 oldRoot = committedRoot;
533         bytes memory sig = signRemoteUpdate(updaterPK, oldRoot, newRoot);
534         replica.update(oldRoot, newRoot, sig);
535         assertFalse(replica.acceptableRoot(newRoot));
536     }
537 }
