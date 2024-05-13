1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 // test imports
6 import {GovernanceRouterHarness} from "./harnesses/GovernanceRouterHarness.sol";
7 import {GovernanceRouter} from "../governance/GovernanceRouter.sol";
8 import {Home} from "../Home.sol";
9 import {GoodXappSimple} from "./utils/GoodXapps.sol";
10 import "forge-std/Test.sol";
11 
12 // external imports
13 import {XAppConnectionManager} from "../XAppConnectionManager.sol";
14 import {GovernanceMessage} from "../governance/GovernanceMessage.sol";
15 import {MockXAppConnectionManager} from "./utils/MockXAppConnectionManager.sol";
16 import {MockHome} from "@nomad-xyz/contracts-bridge/contracts/test/utils/MockHome.sol";
17 import {NomadTest} from "./utils/NomadTest.sol";
18 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
19 import {TypeCasts} from "../libs/TypeCasts.sol";
20 
21 contract GovernanceRouterTest is NomadTest {
22     using GovernanceMessage for bytes29;
23     using TypedMemView for bytes;
24     using TypedMemView for bytes29;
25     using TypeCasts for address;
26     using TypeCasts for bytes32;
27 
28     GovernanceRouterHarness governanceRouter;
29     MockHome home;
30     XAppConnectionManager xAppConnectionManager;
31     MockXAppConnectionManager mockXCM;
32     GoodXappSimple goodXapp;
33 
34     uint256 timelock = 24 * 60 * 60;
35     address recoveryManager;
36 
37     GovernanceMessage.Call[] calls;
38     bytes32 callsBatchHash;
39 
40     bytes32 remoteGovernanceRouter;
41     address replica;
42 
43     event TransferGovernor(
44         uint32 previousGovernorDomain,
45         uint32 newGovernorDomain,
46         address indexed previousGovernor,
47         address indexed newGovernor
48     );
49 
50     function setUp() public virtual override {
51         setUp_mockState();
52         setUp_testFixtures();
53     }
54 
55     function setUp_testFixtures() public {
56         // deploy fake xapp
57         goodXapp = new GoodXappSimple();
58         replica = xAppConnectionManager.domainToReplica(remoteDomain);
59     }
60 
61     function setUp_mockState() public {
62         remoteGovernanceRouter = vm.addr(420809).addressToBytes32();
63         // setup home and xApp connection manager
64         home = new MockHome(homeDomain);
65         mockXCM = new MockXAppConnectionManager(address(home), replica);
66         xAppConnectionManager = XAppConnectionManager(address(mockXCM));
67         // setup governance router
68         governanceRouter = new GovernanceRouterHarness(homeDomain, timelock);
69         governanceRouter.initialize(
70             address(xAppConnectionManager),
71             recoveryManager
72         );
73         governanceRouter.setRouterLocal(remoteDomain, remoteGovernanceRouter);
74     }
75 
76     function test_initializeCorrectSet() public {
77         governanceRouter = new GovernanceRouterHarness(homeDomain, timelock);
78         // Test Initialize function
79         vm.expectEmit(true, true, false, true);
80         emit TransferGovernor(0, homeDomain, address(0), address(this));
81         governanceRouter.initialize(
82             address(xAppConnectionManager),
83             recoveryManager
84         );
85         assertEq(governanceRouter.recoveryManager(), recoveryManager);
86         assertEq(
87             address(governanceRouter.xAppConnectionManager()),
88             address(xAppConnectionManager)
89         );
90         assertEq(governanceRouter.governor(), address(this));
91         assertEq(uint256(governanceRouter.governorDomain()), homeDomain);
92     }
93 
94     function test_initializeRevertBadDomain() public {
95         //  XAppConnectionManager has been setup with domain = homeDomain
96         governanceRouter = new GovernanceRouterHarness(remoteDomain, timelock);
97         vm.expectRevert("XAppConnectionManager bad domain");
98         governanceRouter.initialize(
99             address(xAppConnectionManager),
100             recoveryManager
101         );
102     }
103 
104     function test_handleOnlyReplicaNotInRecovery() public runNotInRecovery {
105         // if currently governor domain, transfer to remote governor
106         // else the router will not accept incoming messages
107         if (governanceRouter.governorDomain() == homeDomain) {
108             prankGovernor();
109             governanceRouter.transferGovernor(remoteDomain, vm.addr(412));
110         }
111         // calling handle from non-replica reverts
112         vm.prank(vm.addr(789));
113         vm.expectRevert("!replica");
114         governanceRouter.handle(
115             remoteDomain,
116             0,
117             remoteGovernanceRouter,
118             "mock"
119         );
120         // calling handle from replica passes the onlyReplica test
121         // (it will still revert because rubbish message, but with
122         // a diff error message because it passed the onlyReplica modifier)
123         prankReplica();
124         vm.expectRevert("!valid message type");
125         governanceRouter.handle(
126             remoteDomain,
127             0,
128             remoteGovernanceRouter,
129             "mock"
130         );
131     }
132 
133     function test_handleOnlyReplicaRecovery()
134         public
135         runNonGoverning
136         runInRecovery
137     {
138         // calling handle from non-replica reverts
139         vm.prank(vm.addr(789));
140         vm.expectRevert("!replica");
141         governanceRouter.handle(
142             remoteDomain,
143             0,
144             remoteGovernanceRouter,
145             "mock"
146         );
147         // calling handle from replica passes the onlyReplica test
148         // (it will still revert because rubbish message, but with
149         // a diff error message because it passed the onlyReplica modifier)
150         prankReplica();
151         vm.expectRevert("!valid message type");
152         governanceRouter.handle(
153             remoteDomain,
154             0,
155             remoteGovernanceRouter,
156             "mock"
157         );
158     }
159 
160     function test_handleOnlyGovernorRouterNotInRecovery()
161         public
162         runNotInRecovery
163     {
164         // if currently governor domain, transfer to remote governor
165         // else the router will not accept incoming messages
166         if (governanceRouter.governorDomain() == homeDomain) {
167             prankGovernor();
168             governanceRouter.transferGovernor(remoteDomain, vm.addr(412));
169         }
170         // sender is wrong
171         prankReplica();
172         vm.expectRevert("!governorRouter");
173         governanceRouter.handle(
174             remoteDomain,
175             0,
176             TypeCasts.addressToBytes32(vm.addr(412)),
177             "data"
178         );
179         // domain is wrong
180         prankReplica();
181         vm.expectRevert("!governorRouter");
182         governanceRouter.handle(
183             (remoteDomain + 1),
184             0,
185             remoteGovernanceRouter,
186             "data"
187         );
188         // domain and sender are wrong
189         prankReplica();
190         vm.expectRevert("!governorRouter");
191         governanceRouter.handle(
192             (remoteDomain + 1),
193             0,
194             remoteGovernanceRouter,
195             "data"
196         );
197         // with correct domain and sender, passes onlyGovernorRouter test
198         // (it will still revert because rubbish message, but with
199         // a diff error message because it passed the onlyReplica modifier)
200         prankReplica();
201         vm.expectRevert("!valid message type");
202         governanceRouter.handle(
203             remoteDomain,
204             0,
205             remoteGovernanceRouter,
206             "data"
207         );
208     }
209 
210     function test_handleOnlyGovernorRouterRecovery()
211         public
212         runNonGoverning
213         runInRecovery
214     {
215         // sender is wrong
216         prankReplica();
217         vm.expectRevert("!governorRouter");
218         governanceRouter.handle(
219             remoteDomain,
220             0,
221             TypeCasts.addressToBytes32(vm.addr(412)),
222             "data"
223         );
224         // domain is wrong
225         prankReplica();
226         vm.expectRevert("!governorRouter");
227         governanceRouter.handle(
228             (remoteDomain + 1),
229             0,
230             remoteGovernanceRouter,
231             "data"
232         );
233         // domain and sender are wrong
234         prankReplica();
235         vm.expectRevert("!governorRouter");
236         governanceRouter.handle(
237             (remoteDomain + 1),
238             0,
239             remoteGovernanceRouter,
240             "data"
241         );
242         // with correct domain and sender, passes onlyGovernorRouter test
243         // (it will still revert because rubbish message, but with
244         // a diff error message because it passed the onlyReplica modifier)
245         prankReplica();
246         vm.expectRevert("!valid message type");
247         governanceRouter.handle(
248             remoteDomain,
249             0,
250             remoteGovernanceRouter,
251             "data"
252         );
253     }
254 
255     event BatchReceived(bytes32 indexed batchHash);
256 
257     function test_handleBatchCorrectForm() public runNonGoverning {
258         // Create test batch for tests
259         address to = address(0xBEEF);
260         bytes memory data = "";
261         calls.push(GovernanceMessage.Call(to.addressToBytes32(), data));
262         bytes32 batchHash = GovernanceMessage.getBatchHash(calls);
263         // handle should emit BatchReceived event
264         bytes memory message = GovernanceMessage.formatBatch(calls);
265         vm.expectEmit(true, false, false, false);
266         emit BatchReceived(batchHash);
267         vm.startPrank(replica);
268         governanceRouter.handle(
269             remoteDomain,
270             0,
271             remoteGovernanceRouter,
272             message
273         );
274         // batch is pending
275         assertEq(
276             uint256(governanceRouter.inboundCallBatches(batchHash)),
277             uint256(GovernanceRouter.BatchStatus.Pending)
278         );
279         // same batch can't be delivered while still pending
280         vm.expectRevert("BatchStatus is Pending");
281         governanceRouter.handle(
282             remoteDomain,
283             0,
284             remoteGovernanceRouter,
285             message
286         );
287     }
288 
289     function test_handleTransferGovernor_toLocalGovernor_notRecovery_success()
290         public
291     {
292         // if currently governor domain, transfer to remote governor
293         // else the router will not accept incoming messages
294         if (governanceRouter.governorDomain() == homeDomain) {
295             if (governanceRouter.inRecovery()) exitRecovery();
296             prankGovernor();
297             governanceRouter.transferGovernor(remoteDomain, vm.addr(412));
298         }
299         // Create test transfer gov message
300         address newGov = vm.addr(812);
301         bytes memory handleMessage = GovernanceMessage.formatTransferGovernor(
302             homeDomain,
303             newGov.addressToBytes32()
304         );
305         // handle should emit transfer governor event
306         vm.expectEmit(true, false, false, false);
307         emit TransferGovernor(
308             governanceRouter.governorDomain(),
309             homeDomain,
310             address(0),
311             newGov
312         );
313         prankReplica();
314         governanceRouter.handle(
315             remoteDomain,
316             0,
317             remoteGovernanceRouter,
318             handleMessage
319         );
320         // governor should be transferred in storage
321         assertEq(
322             uint256(governanceRouter.governorDomain()),
323             uint256(homeDomain)
324         );
325         assertEq(governanceRouter.governor(), newGov);
326     }
327 
328     function test_handleTransferGovernor_toRemoteGovernor_notRecovery_success()
329         public
330         runNotInRecovery
331     {
332         // if currently governor domain, transfer to remote governor
333         // else the router will not accept incoming messages
334         if (governanceRouter.governorDomain() == homeDomain) {
335             prankGovernor();
336             governanceRouter.transferGovernor(remoteDomain, vm.addr(412));
337         }
338         uint32 newGovDomain = remoteDomain + 69;
339         // set router for remote domain so gov can be transferred to it
340         prankGovernor();
341         governanceRouter.setRouterLocal(
342             newGovDomain,
343             TypeCasts.addressToBytes32(vm.addr(9999988888))
344         );
345         // Create test transfer gov message
346         address newGov = vm.addr(812);
347         bytes memory handleMessage = GovernanceMessage.formatTransferGovernor(
348             newGovDomain,
349             newGov.addressToBytes32()
350         );
351         // handle should emit transfer governor event
352         vm.expectEmit(true, false, false, false);
353         emit TransferGovernor(
354             governanceRouter.governorDomain(),
355             newGovDomain,
356             address(0),
357             address(0)
358         );
359         prankReplica();
360         governanceRouter.handle(
361             remoteDomain,
362             0,
363             remoteGovernanceRouter,
364             handleMessage
365         );
366         // governor should be transferred in storage
367         assertEq(
368             uint256(governanceRouter.governorDomain()),
369             uint256(newGovDomain)
370         );
371         assertEq(governanceRouter.governor(), address(0));
372     }
373 
374     function test_executeGovernanceActionsNotRecoveryOnlyGovernor()
375         public
376         runNotInRecovery
377     {
378         GovernanceMessage.Call[]
379             memory localCalls = new GovernanceMessage.Call[](1);
380         GovernanceMessage.Call[][]
381             memory remoteCalls = new GovernanceMessage.Call[][](1);
382         uint32[] memory domains = new uint32[](1);
383         vm.prank(address(0xBEEF));
384         vm.expectRevert("! called by governor");
385         governanceRouter.executeGovernanceActions(
386             localCalls,
387             domains,
388             remoteCalls
389         );
390         prankRecoveryManager();
391         vm.expectRevert("! called by governor");
392         governanceRouter.executeGovernanceActions(
393             localCalls,
394             domains,
395             remoteCalls
396         );
397     }
398 
399     function test_executeGovernanceActionsIncorrectLength() public {
400         if (governanceRouter.inRecovery()) {
401             prankRecoveryManager();
402         } else {
403             prankGovernor();
404         }
405         GovernanceMessage.Call[]
406             memory localCalls = new GovernanceMessage.Call[](1);
407         GovernanceMessage.Call[][]
408             memory remoteCalls = new GovernanceMessage.Call[][](1);
409         uint32[] memory domains = new uint32[](2);
410         vm.expectRevert("!domains length matches calls length");
411         governanceRouter.executeGovernanceActions(
412             localCalls,
413             domains,
414             remoteCalls
415         );
416     }
417 
418     function test_executeLocalGovernanceActionsRecoveryOnlyRecoveryManager()
419         public
420         runInRecovery
421     {
422         // construct calls
423         GovernanceMessage.Call[]
424             memory localCalls = new GovernanceMessage.Call[](1);
425         GovernanceMessage.Call[][]
426             memory remoteCalls = new GovernanceMessage.Call[][](0);
427         uint32[] memory domains = new uint32[](0);
428         // fails when not called by recoveryManager
429         vm.prank(address(0xBEEF));
430         vm.expectRevert("! called by recovery manager");
431         governanceRouter.executeGovernanceActions(
432             localCalls,
433             domains,
434             remoteCalls
435         );
436         // succeeds when called by recovery manager
437         prankRecoveryManager();
438         governanceRouter.executeGovernanceActions(
439             localCalls,
440             domains,
441             remoteCalls
442         );
443     }
444 
445     function test_executeGovernanceActionsRecoveryNotRemoteCalls()
446         public
447         runInRecovery
448     {
449         GovernanceMessage.Call[]
450             memory localCalls = new GovernanceMessage.Call[](1);
451         GovernanceMessage.Call[][]
452             memory remoteCalls = new GovernanceMessage.Call[][](1);
453         uint32[] memory domains = new uint32[](1);
454         prankRecoveryManager();
455         vm.expectRevert("!remote calls in recovery mode");
456         governanceRouter.executeGovernanceActions(
457             localCalls,
458             domains,
459             remoteCalls
460         );
461     }
462 
463     function test_executeGovernanceActionsOnlyLocal() public runNotInRecovery {
464         GovernanceMessage.Call[]
465             memory localCalls = new GovernanceMessage.Call[](1);
466         GovernanceMessage.Call[][]
467             memory remoteCalls = new GovernanceMessage.Call[][](0);
468         uint32[] memory domains = new uint32[](0);
469         bytes32 to = address(goodXapp).addressToBytes32();
470         bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 55);
471         localCalls[0] = GovernanceMessage.Call(to, data);
472         prankGovernor();
473         vm.expectCall(
474             address(goodXapp),
475             abi.encodeWithSelector(GoodXappSimple.setNumber.selector, 55)
476         );
477         governanceRouter.executeGovernanceActions(
478             localCalls,
479             domains,
480             remoteCalls
481         );
482         assertEq(goodXapp.number(), 55);
483     }
484 
485     function test_executeGovernanceActionsRecoveryOnlyLocal()
486         public
487         runInRecovery
488     {
489         GovernanceMessage.Call[]
490             memory localCalls = new GovernanceMessage.Call[](1);
491         GovernanceMessage.Call[][]
492             memory remoteCalls = new GovernanceMessage.Call[][](0);
493         uint32[] memory domains = new uint32[](0);
494         bytes32 to = address(goodXapp).addressToBytes32();
495         bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 55);
496         localCalls[0] = GovernanceMessage.Call(to, data);
497         prankRecoveryManager();
498         vm.expectCall(
499             address(goodXapp),
500             abi.encodeWithSelector(GoodXappSimple.setNumber.selector, 55)
501         );
502         governanceRouter.executeGovernanceActions(
503             localCalls,
504             domains,
505             remoteCalls
506         );
507         assertEq(goodXapp.number(), 55);
508     }
509 
510     function test_executeGovernanceActionsOnlyRemote() public runNotInRecovery {
511         // construct remote calls
512         GovernanceMessage.Call[]
513             memory localCalls = new GovernanceMessage.Call[](0);
514         uint32[] memory remoteDomains = new uint32[](1);
515         remoteDomains[0] = remoteDomain;
516         GovernanceMessage.Call[][]
517             memory remoteCalls = new GovernanceMessage.Call[][](1);
518         remoteCalls[0] = new GovernanceMessage.Call[](1);
519         bytes32 to = TypeCasts.addressToBytes32(vm.addr(645));
520         bytes memory data = hex"BEEF";
521         remoteCalls[0][0] = GovernanceMessage.Call(to, data);
522         // expect that Home dispatch is called
523         vm.expectCall(
524             address(home),
525             abi.encodeWithSelector(
526                 Home.dispatch.selector,
527                 remoteDomains[0],
528                 remoteGovernanceRouter,
529                 GovernanceMessage.formatBatch(remoteCalls[0])
530             )
531         );
532         // execute actions
533         prankGovernor();
534         governanceRouter.executeGovernanceActions(
535             localCalls,
536             remoteDomains,
537             remoteCalls
538         );
539     }
540 
541     function test_executeGovernanceActionsLocalAndRemote()
542         public
543         runNotInRecovery
544     {
545         GovernanceMessage.Call[]
546             memory localCalls = new GovernanceMessage.Call[](1);
547         bytes32 to = address(goodXapp).addressToBytes32();
548         bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 55);
549         localCalls[0] = GovernanceMessage.Call(to, data);
550         uint32[] memory remoteDomains = new uint32[](1);
551         remoteDomains[0] = remoteDomain;
552         GovernanceMessage.Call[][]
553             memory remoteCalls = new GovernanceMessage.Call[][](1);
554         remoteCalls[0] = new GovernanceMessage.Call[](1);
555         bytes32 remoteTo = TypeCasts.addressToBytes32(vm.addr(907));
556         bytes memory remoteData = hex"BEEF";
557         remoteCalls[0][0] = GovernanceMessage.Call(remoteTo, remoteData);
558         vm.expectCall(
559             address(goodXapp),
560             abi.encodeWithSelector(GoodXappSimple.setNumber.selector, 55)
561         );
562         vm.expectCall(
563             address(home),
564             abi.encodeWithSelector(
565                 Home.dispatch.selector,
566                 remoteDomains[0],
567                 remoteGovernanceRouter,
568                 GovernanceMessage.formatBatch(remoteCalls[0])
569             )
570         );
571         prankGovernor();
572         governanceRouter.executeGovernanceActions(
573             localCalls,
574             remoteDomains,
575             remoteCalls
576         );
577         assertEq(goodXapp.number(), 55);
578     }
579 
580     function test_executeGovernanceActionsLocalAndRemoteFuzzed(
581         bytes32[8] memory fuzzTo,
582         bytes[8] memory fuzzData,
583         uint32[8] memory fuzzDomains,
584         bytes32[8] memory fuzzRouter
585     ) public runNotInRecovery {
586         // construct empty parameter arrays
587         GovernanceMessage.Call[]
588             memory localCalls = new GovernanceMessage.Call[](8);
589         GovernanceMessage.Call[][]
590             memory remoteCalls = new GovernanceMessage.Call[][](8);
591         uint32[] memory domains = new uint32[](8);
592         // loop through fuzzed values
593         for (uint256 i; i < 8; i++) {
594             // set domain
595             if (fuzzDomains[i] == homeDomain) {
596                 fuzzDomains[i] = fuzzDomains[i] + 1;
597             }
598             domains[i] = fuzzDomains[i];
599             // setup remote router IFF it does not already exist
600             if (fuzzRouter[i] == bytes32(0)) {
601                 fuzzRouter[i] = "non empty address";
602             }
603             if (governanceRouter.routers(fuzzDomains[i]) == bytes32(0)) {
604                 prankGovernor();
605                 governanceRouter.setRouterLocal(fuzzDomains[i], fuzzRouter[i]);
606             }
607             // add remote call
608             remoteCalls[i] = new GovernanceMessage.Call[](i + 1);
609             for (uint256 j; j < i + 1; j++) {
610                 remoteCalls[i][j] = GovernanceMessage.Call(
611                     fuzzTo[i],
612                     fuzzData[i]
613                 );
614             }
615             vm.expectCall(
616                 address(home),
617                 abi.encodeWithSelector(
618                     Home.dispatch.selector,
619                     fuzzDomains[i],
620                     governanceRouter.routers(fuzzDomains[i]),
621                     GovernanceMessage.formatBatch(remoteCalls[i])
622                 )
623             );
624             // add local call
625             localCalls[i] = GovernanceMessage.Call(
626                 address(goodXapp).addressToBytes32(),
627                 abi.encodeWithSignature("setNumber(uint256)", i)
628             );
629             vm.expectCall(
630                 address(goodXapp),
631                 abi.encodeWithSelector(GoodXappSimple.setNumber.selector, i)
632             );
633         }
634         prankGovernor();
635         governanceRouter.executeGovernanceActions(
636             localCalls,
637             domains,
638             remoteCalls
639         );
640     }
641 
642     function test_callRemoteOnlyGovernor() public runNotInRecovery {
643         GovernanceMessage.Call[]
644             memory localCalls = new GovernanceMessage.Call[](0);
645         uint32[] memory remoteDomains = new uint32[](1);
646         remoteDomains[0] = remoteDomain;
647         GovernanceMessage.Call[][]
648             memory remoteCalls = new GovernanceMessage.Call[][](1);
649         remoteCalls[0] = new GovernanceMessage.Call[](1);
650         bytes32 to = remoteGovernanceRouter;
651         bytes memory data = hex"BEEF";
652         remoteCalls[0][0] = GovernanceMessage.Call(to, data);
653         vm.prank(vm.addr(123));
654         vm.expectRevert("! called by governor");
655         governanceRouter.executeGovernanceActions(
656             localCalls,
657             remoteDomains,
658             remoteCalls
659         );
660         prankRecoveryManager();
661         vm.expectRevert("! called by governor");
662         governanceRouter.executeGovernanceActions(
663             localCalls,
664             remoteDomains,
665             remoteCalls
666         );
667     }
668 
669     function test_executeGovernanceActionsNotGovernanceRouter()
670         public
671         runNotInRecovery
672     {
673         GovernanceMessage.Call[]
674             memory localCalls = new GovernanceMessage.Call[](1);
675         uint32[] memory remoteDomains = new uint32[](0);
676         GovernanceMessage.Call[][]
677             memory remoteCalls = new GovernanceMessage.Call[][](0);
678         vm.prank(address(governanceRouter));
679         vm.expectRevert("!sender is an external address");
680         governanceRouter.executeGovernanceActions(
681             localCalls,
682             remoteDomains,
683             remoteCalls
684         );
685     }
686 
687     function test_callRemoteOnlyGovernorFuzzed(address nonGovernor)
688         public
689         runNotInRecovery
690     {
691         vm.assume(
692             nonGovernor != governanceRouter.governor() &&
693                 nonGovernor != address(governanceRouter)
694         );
695         GovernanceMessage.Call[]
696             memory localCalls = new GovernanceMessage.Call[](0);
697         uint32[] memory remoteDomains = new uint32[](1);
698         remoteDomains[0] = remoteDomain;
699         GovernanceMessage.Call[][]
700             memory remoteCalls = new GovernanceMessage.Call[][](1);
701         remoteCalls[0] = new GovernanceMessage.Call[](1);
702         bytes32 to = remoteGovernanceRouter;
703         bytes memory data = hex"BEEF";
704         remoteCalls[0][0] = GovernanceMessage.Call(to, data);
705         vm.prank(nonGovernor);
706         vm.expectRevert("! called by governor");
707         governanceRouter.executeGovernanceActions(
708             localCalls,
709             remoteDomains,
710             remoteCalls
711         );
712     }
713 
714     function test_callRemoteSuccess() public runNotInRecovery {
715         prankGovernor();
716         GovernanceMessage.Call[]
717             memory localCalls = new GovernanceMessage.Call[](0);
718         uint32[] memory remoteDomains = new uint32[](1);
719         remoteDomains[0] = remoteDomain;
720         GovernanceMessage.Call[][]
721             memory remoteCalls = new GovernanceMessage.Call[][](1);
722         remoteCalls[0] = new GovernanceMessage.Call[](1);
723         bytes32 to = remoteGovernanceRouter;
724         bytes memory data = hex"BEEF";
725         remoteCalls[0][0] = GovernanceMessage.Call(to, data);
726         governanceRouter.executeGovernanceActions(
727             localCalls,
728             remoteDomains,
729             remoteCalls
730         );
731     }
732 
733     function test_transferGovernorOnlyGovernor() public {
734         address newGovernor = vm.addr(9998888999);
735         // local
736         vm.prank(address(0xBEEFBEEF));
737         vm.expectRevert("! called by governor");
738         governanceRouter.transferGovernor(homeDomain, newGovernor);
739         // remote
740         vm.prank(address(0xBEEFBEEF));
741         vm.expectRevert("! called by governor");
742         governanceRouter.transferGovernor(remoteDomain, newGovernor);
743     }
744 
745     function test_transferGovernorOnlyNotInRecovery() public runInRecovery {
746         address newGovernor = vm.addr(9998888999);
747         // local
748         prankGovernor();
749         vm.expectRevert("in recovery");
750         governanceRouter.transferGovernor(homeDomain, newGovernor);
751         // remote
752         prankGovernor();
753         vm.expectRevert("in recovery");
754         governanceRouter.transferGovernor(remoteDomain, newGovernor);
755     }
756 
757     function test_transferGovernorRemoteGovernor() public runNotInRecovery {
758         uint32 newGovernorDomain = remoteDomain;
759         address newGovernor = vm.addr(9998888999);
760         for (uint256 i = 0; i < governanceRouter.hack_domainsLength(); i++) {
761             uint32 _domain = governanceRouter.domains(i);
762             if (_domain != uint32(0)) {
763                 vm.expectCall(
764                     address(home),
765                     abi.encodeWithSelector(
766                         Home.dispatch.selector,
767                         _domain,
768                         governanceRouter.routers(_domain),
769                         GovernanceMessage.formatTransferGovernor(
770                             newGovernorDomain,
771                             TypeCasts.addressToBytes32(newGovernor)
772                         )
773                     )
774                 );
775             }
776         }
777         vm.expectEmit(true, true, true, true);
778         emit TransferGovernor(
779             governanceRouter.governorDomain(),
780             newGovernorDomain,
781             governanceRouter.governor(),
782             address(0)
783         );
784         prankGovernor();
785         governanceRouter.transferGovernor(newGovernorDomain, newGovernor);
786         assertEq(governanceRouter.governor(), address(0));
787         assertEq(uint256(governanceRouter.governorDomain()), newGovernorDomain);
788     }
789 
790     function test_transferGovernorRemoteGovernorMustHaveRouter()
791         public
792         runNotInRecovery
793     {
794         uint32 newDomain = 123;
795         address newGovernor = vm.addr(9998888999);
796         prankGovernor();
797         vm.expectRevert("!router");
798         governanceRouter.transferGovernor(newDomain, newGovernor);
799     }
800 
801     function test_transferGovernorRemoteGovernorFuzzed(
802         uint32 newDomain,
803         address newGovernor,
804         bytes32 router
805     ) public runNotInRecovery {
806         vm.assume(
807             newDomain != 0 &&
808                 newDomain != homeDomain &&
809                 newDomain != remoteDomain &&
810                 router != bytes32(0)
811         );
812         prankGovernor();
813         governanceRouter.setRouterLocal(newDomain, router);
814         if (newGovernor == address(0)) {
815             prankGovernor();
816             vm.expectRevert("cannot renounce governor");
817             governanceRouter.transferGovernor(newDomain, newGovernor);
818             return;
819         }
820         for (uint256 i = 0; i < governanceRouter.hack_domainsLength(); i++) {
821             uint32 _domain = governanceRouter.domains(i);
822             if (_domain != uint32(0)) {
823                 vm.expectCall(
824                     address(home),
825                     abi.encodeWithSelector(
826                         Home.dispatch.selector,
827                         _domain,
828                         governanceRouter.routers(_domain),
829                         GovernanceMessage.formatTransferGovernor(
830                             newDomain,
831                             TypeCasts.addressToBytes32(newGovernor)
832                         )
833                     )
834                 );
835             }
836         }
837         vm.expectEmit(true, true, true, true);
838         emit TransferGovernor(
839             governanceRouter.governorDomain(),
840             newDomain,
841             governanceRouter.governor(),
842             address(0)
843         );
844         prankGovernor();
845         governanceRouter.transferGovernor(newDomain, newGovernor);
846         assertEq(governanceRouter.governor(), address(0));
847         assertEq(uint256(governanceRouter.governorDomain()), newDomain);
848     }
849 
850     function test_transferGovernorLocalGovernor() public runNotInRecovery {
851         uint32 newDomain = homeDomain;
852         address newGovernor = vm.addr(9998888999);
853         // todo: expectNoCall Home.Dispatch
854         vm.expectEmit(true, true, true, true);
855         emit TransferGovernor(
856             governanceRouter.governorDomain(),
857             newDomain,
858             governanceRouter.governor(),
859             newGovernor
860         );
861         prankGovernor();
862         governanceRouter.transferGovernor(newDomain, newGovernor);
863         assertEq(governanceRouter.governor(), newGovernor);
864         assertEq(uint256(governanceRouter.governorDomain()), newDomain);
865     }
866 
867     function test_transferGovernorLocalGovernorCANNOTRENOUNCE()
868         public
869         runNotInRecovery
870     {
871         uint32 newDomain = homeDomain;
872         address newGovernor = address(0);
873         prankGovernor();
874         vm.expectRevert("cannot renounce governor");
875         governanceRouter.transferGovernor(newDomain, newGovernor);
876     }
877 
878     function test_transferGovernorLocalGovernorFuzzed(address newGovernor)
879         public
880         runNotInRecovery
881     {
882         uint32 newDomain = homeDomain;
883         if (newGovernor == address(0)) {
884             prankGovernor();
885             vm.expectRevert("cannot renounce governor");
886             governanceRouter.transferGovernor(newDomain, newGovernor);
887             return;
888         }
889         // todo: expectNoCall Home.Dispatch
890         vm.expectEmit(true, true, true, true);
891         emit TransferGovernor(
892             governanceRouter.governorDomain(),
893             newDomain,
894             governanceRouter.governor(),
895             newGovernor
896         );
897         prankGovernor();
898         governanceRouter.transferGovernor(newDomain, newGovernor);
899         assertEq(governanceRouter.governor(), newGovernor);
900         assertEq(uint256(governanceRouter.governorDomain()), newDomain);
901     }
902 
903     function test_transferRecoveryManagerOnlyRecoveryManager() public {
904         address newRecoveryManager = address(0xBEEF);
905         vm.expectRevert("! called by recovery manager");
906         governanceRouter.transferRecoveryManager(newRecoveryManager);
907         vm.startPrank(recoveryManager);
908         vm.expectEmit(true, true, false, false);
909         emit TransferRecoveryManager(recoveryManager, newRecoveryManager);
910         governanceRouter.transferRecoveryManager(newRecoveryManager);
911         assertEq(governanceRouter.recoveryManager(), newRecoveryManager);
912     }
913 
914     event TransferRecoveryManager(
915         address indexed previousRecoveryManager,
916         address indexed newRecoveryManager
917     );
918 
919     function test_transferRecoveryManagerFuzzed(address newRecoveryManager)
920         public
921     {
922         vm.startPrank(recoveryManager);
923         vm.expectEmit(true, true, false, false);
924         emit TransferRecoveryManager(
925             governanceRouter.recoveryManager(),
926             newRecoveryManager
927         );
928         governanceRouter.transferRecoveryManager(newRecoveryManager);
929         assertEq(governanceRouter.recoveryManager(), newRecoveryManager);
930     }
931 
932     function test_setRouterGlobalOnlyGovernor() public {
933         vm.prank(address(0xBEEF));
934         vm.expectRevert("! called by governor");
935         uint32 domain = 123;
936         bytes32 router = "router";
937         governanceRouter.setRouterGlobal(domain, router);
938     }
939 
940     function test_setRouterGlobalNotInRecovery() public runInRecovery {
941         uint32 domain = 123;
942         bytes32 router = "router";
943         prankGovernor();
944         vm.expectRevert("in recovery");
945         governanceRouter.setRouterGlobal(domain, router);
946     }
947 
948     event SetRouter(
949         uint32 indexed domain,
950         bytes32 previousRouter,
951         bytes32 newRouter
952     );
953 
954     function test_setRouterGlobalNewDomain() public runNotInRecovery {
955         uint32 newDomain = 123;
956         bytes32 newRouter = "router";
957         bytes32 previousRouter = governanceRouter.routers(newDomain);
958         GovernanceMessage.Call[]
959             memory remoteCalls = new GovernanceMessage.Call[](1);
960         remoteCalls[0].data = abi.encodeWithSignature(
961             "setRouterLocal(uint32,bytes32)",
962             newDomain,
963             newRouter
964         );
965         for (uint256 i; i < governanceRouter.hack_domainsLength(); i++) {
966             uint32 _remoteDomain = governanceRouter.domains(i);
967             bytes32 _remoteRouter = governanceRouter.routers(_remoteDomain);
968             remoteCalls[0].to = _remoteRouter;
969             vm.expectCall(
970                 address(home),
971                 abi.encodeWithSelector(
972                     Home.dispatch.selector,
973                     _remoteDomain,
974                     _remoteRouter,
975                     GovernanceMessage.formatBatch(remoteCalls)
976                 )
977             );
978         }
979         vm.expectEmit(true, false, false, true);
980         emit SetRouter(newDomain, previousRouter, newRouter);
981         prankGovernor();
982         governanceRouter.setRouterGlobal(newDomain, newRouter);
983     }
984 
985     function test_setRouterGlobalNewDomainFuzzed(
986         uint32 newDomain,
987         bytes32 newRouter
988     ) public runNotInRecovery {
989         vm.assume(newDomain != homeDomain && newDomain != 0);
990         bytes32 previousRouter = governanceRouter.routers(newDomain);
991         GovernanceMessage.Call[]
992             memory remoteCalls = new GovernanceMessage.Call[](1);
993         remoteCalls[0].data = abi.encodeWithSignature(
994             "setRouterLocal(uint32,bytes32)",
995             newDomain,
996             newRouter
997         );
998         for (uint256 i; i < governanceRouter.hack_domainsLength(); i++) {
999             uint32 _remoteDomain = governanceRouter.domains(i);
1000             bytes32 _remoteRouter = governanceRouter.routers(_remoteDomain);
1001             remoteCalls[0].to = _remoteRouter;
1002             vm.expectCall(
1003                 address(home),
1004                 abi.encodeWithSelector(
1005                     Home.dispatch.selector,
1006                     _remoteDomain,
1007                     _remoteRouter,
1008                     GovernanceMessage.formatBatch(remoteCalls)
1009                 )
1010             );
1011         }
1012         vm.expectEmit(true, false, false, true);
1013         emit SetRouter(newDomain, previousRouter, newRouter);
1014         prankGovernor();
1015         governanceRouter.setRouterGlobal(newDomain, newRouter);
1016     }
1017 
1018     function test_setRouterGlobaExistinglDomainHome() public runNotInRecovery {
1019         prankGovernor();
1020         bytes32 newRouter = "new router";
1021         vm.expectRevert("can't set local router");
1022         governanceRouter.setRouterGlobal(homeDomain, newRouter);
1023     }
1024 
1025     function test_setRouterGlobaExistinglDomainRemote()
1026         public
1027         runNotInRecovery
1028     {
1029         uint32 domain = remoteDomain;
1030         bytes32 newRouter = "new router";
1031         bytes32 previousRouter = governanceRouter.routers(domain);
1032         GovernanceMessage.Call[]
1033             memory remoteCalls = new GovernanceMessage.Call[](1);
1034         remoteCalls[0].data = abi.encodeWithSignature(
1035             "setRouterLocal(uint32,bytes32)",
1036             domain,
1037             newRouter
1038         );
1039         uint256 length = governanceRouter.hack_domainsLength();
1040         for (uint256 i; i < length; i++) {
1041             uint32 dest = governanceRouter.domains(i);
1042             assert(dest != 0);
1043             bytes32 recipient = governanceRouter.routers(dest);
1044             remoteCalls[0].to = recipient;
1045             bytes memory message = GovernanceMessage.formatBatch(remoteCalls);
1046             vm.expectCall(
1047                 address(home),
1048                 abi.encodeWithSelector(
1049                     Home.dispatch.selector,
1050                     dest,
1051                     recipient,
1052                     message
1053                 )
1054             );
1055         }
1056         vm.expectEmit(true, false, false, true);
1057         emit SetRouter(domain, previousRouter, newRouter);
1058         prankGovernor();
1059         governanceRouter.setRouterGlobal(domain, newRouter);
1060     }
1061 
1062     function test_setXAppConnectionManagerOnlyGovernor()
1063         public
1064         runNotInRecovery
1065     {
1066         MockHome newHome = new MockHome(homeDomain);
1067         MockXAppConnectionManager newMngr = new MockXAppConnectionManager(
1068             address(newHome),
1069             replica
1070         );
1071         // fails when not governor
1072         vm.prank(address(0xBEEEEEEEEEEEF));
1073         vm.expectRevert("! called by governor");
1074         governanceRouter.setXAppConnectionManager(address(newMngr));
1075         // succeeds when governor
1076         prankGovernor();
1077         governanceRouter.setXAppConnectionManager(address(newMngr));
1078         assertEq(
1079             address(governanceRouter.xAppConnectionManager()),
1080             address(newMngr)
1081         );
1082     }
1083 
1084     function test_setXAppConnectionManagerOnlyRecoveryManager()
1085         public
1086         runInRecovery
1087     {
1088         MockHome newHome = new MockHome(homeDomain);
1089         MockXAppConnectionManager newMngr = new MockXAppConnectionManager(
1090             address(newHome),
1091             replica
1092         );
1093         // fail from random address
1094         vm.prank(address(0xBEEEEEEEEEEEF));
1095         vm.expectRevert("! called by recovery manager");
1096         governanceRouter.setXAppConnectionManager(address(newMngr));
1097         // succeed from recovery manager
1098         vm.prank(governanceRouter.recoveryManager());
1099         governanceRouter.setXAppConnectionManager(address(newMngr));
1100         assertEq(
1101             address(governanceRouter.xAppConnectionManager()),
1102             address(newMngr)
1103         );
1104     }
1105 
1106     function test_initiateRecoveryTimeLockOnlyNotInRecovery()
1107         public
1108         runInRecovery
1109     {
1110         prankRecoveryManager();
1111         vm.expectRevert("in recovery");
1112         governanceRouter.initiateRecoveryTimelock();
1113     }
1114 
1115     event InitiateRecovery(
1116         address indexed recoveryManager,
1117         uint256 recoveryActiveAt
1118     );
1119 
1120     function test_initiateRecoveryTimeLockOnlyRecoveryManager()
1121         public
1122         runNotInRecovery
1123     {
1124         vm.expectRevert("! called by recovery manager");
1125         governanceRouter.initiateRecoveryTimelock();
1126     }
1127 
1128     event ExitRecovery(address recoveryManager);
1129 
1130     function test_exitRecoveryOnlyRecoveryManager() public runInRecovery {
1131         // fails when not called by recovery manager
1132         vm.expectRevert("! called by recovery manager");
1133         governanceRouter.exitRecovery();
1134         // succeeds when called by recovery manager
1135         prankRecoveryManager();
1136         vm.expectEmit(false, false, false, true);
1137         emit ExitRecovery(recoveryManager);
1138         governanceRouter.exitRecovery();
1139         // successfully exits recovery
1140         assertFalse(governanceRouter.inRecovery());
1141     }
1142 
1143     function test_exitRecoveryNotInitiatedRevert() public runNotInRecovery {
1144         prankRecoveryManager();
1145         vm.expectRevert("recovery not initiated");
1146         governanceRouter.exitRecovery();
1147     }
1148 
1149     function test_handleBatchNotBatchTypeRevert() public {
1150         bytes memory batch = bytes("something");
1151         vm.expectRevert(
1152             "Type assertion failed. Got 0x0000000002. Expected 0x0000000001"
1153         );
1154         governanceRouter.exposed_handleBatch(batch, 2);
1155     }
1156 
1157     function test_handleBatchMalformedBatch() public {
1158         // The view is of correct type, but the underlying bytes array
1159         // is not correctly formatted
1160         bytes memory batch = bytes("something");
1161         vm.expectRevert(
1162             "TypedMemView/index - Overran the view. Slice is at 0x0000a0 with length 0x000009. Attempted to index at offset 0x000001 with length 0x000020."
1163         );
1164         governanceRouter.exposed_handleBatch(batch, 1);
1165     }
1166 
1167     function test_handleBatchSuccess() public {
1168         address to = address(0xBEEF);
1169         bytes memory data = "";
1170         calls.push(GovernanceMessage.Call(to.addressToBytes32(), data));
1171         bytes memory message = GovernanceMessage.formatBatch(calls);
1172         bytes32 hash = GovernanceMessage.getBatchHash(calls);
1173         vm.expectEmit(true, false, false, false);
1174         emit BatchReceived(hash);
1175         governanceRouter.exposed_handleBatch(message, 1);
1176         assertEq(
1177             uint256(governanceRouter.inboundCallBatches(hash)),
1178             uint256(GovernanceRouter.BatchStatus.Pending)
1179         );
1180     }
1181 
1182     function test_handleBatchSuccessFuzzed(address to, bytes memory data)
1183         public
1184     {
1185         calls.push(GovernanceMessage.Call(to.addressToBytes32(), data));
1186         bytes memory message = GovernanceMessage.formatBatch(calls);
1187         bytes32 hash = GovernanceMessage.getBatchHash(calls);
1188         vm.expectEmit(true, false, false, false);
1189         emit BatchReceived(hash);
1190         governanceRouter.exposed_handleBatch(message, 1);
1191         assertEq(
1192             uint256(governanceRouter.inboundCallBatches(hash)),
1193             uint256(GovernanceRouter.BatchStatus.Pending)
1194         );
1195     }
1196 
1197     function test_executeCallBatchRevertNotPending() public {
1198         address to = address(0xBEEF);
1199         bytes memory data = "";
1200         calls.push(GovernanceMessage.Call(to.addressToBytes32(), data));
1201         bytes32 hash = GovernanceMessage.getBatchHash(calls);
1202         assertEq(
1203             uint256(governanceRouter.inboundCallBatches(hash)),
1204             uint256(GovernanceRouter.BatchStatus.Unknown)
1205         );
1206         vm.expectRevert("!batch pending");
1207         governanceRouter.executeCallBatch(calls);
1208     }
1209 
1210     function test_executeCallBatchRevertNotPendingFuzzed(
1211         address to,
1212         bytes memory data
1213     ) public {
1214         calls.push(GovernanceMessage.Call(to.addressToBytes32(), data));
1215         bytes32 hash = GovernanceMessage.getBatchHash(calls);
1216         assertEq(
1217             uint256(governanceRouter.inboundCallBatches(hash)),
1218             uint256(GovernanceRouter.BatchStatus.Unknown)
1219         );
1220         vm.expectRevert("!batch pending");
1221         governanceRouter.executeCallBatch(calls);
1222     }
1223 
1224     event BatchExecuted(bytes32 indexed batchHash);
1225 
1226     function test_executeCallBatchRandomTargetAndCalldataSuccess() public {
1227         address to = vm.addr(9042332);
1228         bytes memory data = "";
1229         calls.push(GovernanceMessage.Call(to.addressToBytes32(), data));
1230         bytes memory message = GovernanceMessage.formatBatch(calls);
1231         bytes32 hash = GovernanceMessage.getBatchHash(calls);
1232         // set batch to pending
1233         assertEq(
1234             uint256(governanceRouter.inboundCallBatches(hash)),
1235             uint256(GovernanceRouter.BatchStatus.Unknown)
1236         );
1237         governanceRouter.exposed_handleBatch(message, 1);
1238         assertEq(
1239             uint256(governanceRouter.inboundCallBatches(hash)),
1240             uint256(GovernanceRouter.BatchStatus.Pending)
1241         );
1242         vm.expectEmit(true, false, false, false);
1243         emit BatchExecuted(hash);
1244         governanceRouter.executeCallBatch(calls);
1245         assertEq(
1246             uint256(governanceRouter.inboundCallBatches(hash)),
1247             uint256(GovernanceRouter.BatchStatus.Complete)
1248         );
1249     }
1250 
1251     /// @notice It reverts because there is a very low propability that the target
1252     /// will be a contract that exists in the testing suite AND that the calldata
1253     /// will concern a function that eventually reverts.
1254     function test_executeCallBatchSuccessRandomTargetAndCalldataFuzzed(
1255         bytes memory data
1256     ) public {
1257         address to = address(0xBEEF);
1258         calls.push(GovernanceMessage.Call(to.addressToBytes32(), data));
1259         bytes memory message = GovernanceMessage.formatBatch(calls);
1260         bytes32 hash = GovernanceMessage.getBatchHash(calls);
1261         // set batch to pending
1262         assertEq(
1263             uint256(governanceRouter.inboundCallBatches(hash)),
1264             uint256(GovernanceRouter.BatchStatus.Unknown)
1265         );
1266         governanceRouter.exposed_handleBatch(message, 1);
1267         assertEq(
1268             uint256(governanceRouter.inboundCallBatches(hash)),
1269             uint256(GovernanceRouter.BatchStatus.Pending)
1270         );
1271         vm.expectEmit(true, false, false, false);
1272         emit BatchExecuted(hash);
1273         governanceRouter.executeCallBatch(calls);
1274         assertEq(
1275             uint256(governanceRouter.inboundCallBatches(hash)),
1276             uint256(GovernanceRouter.BatchStatus.Complete)
1277         );
1278     }
1279 
1280     function test_executeCallBatchSuccessTargetReverts() public {
1281         address to = address(goodXapp);
1282         bytes memory data = abi.encodeWithSignature("itReverts()");
1283         calls.push(GovernanceMessage.Call(to.addressToBytes32(), data));
1284         bytes memory message = GovernanceMessage.formatBatch(calls);
1285         bytes32 hash = GovernanceMessage.getBatchHash(calls);
1286         // at first, batch does not exist
1287         assertEq(
1288             uint256(governanceRouter.inboundCallBatches(hash)),
1289             uint256(GovernanceRouter.BatchStatus.Unknown)
1290         );
1291         // after handling the message, batch is pending
1292         governanceRouter.exposed_handleBatch(message, 1);
1293         assertEq(
1294             uint256(governanceRouter.inboundCallBatches(hash)),
1295             uint256(GovernanceRouter.BatchStatus.Pending)
1296         );
1297         // batch cannot be executed because it will revert
1298         vm.expectRevert("call failed");
1299         governanceRouter.executeCallBatch(calls);
1300         // since the call failed, the batch is still pending
1301         assertEq(
1302             uint256(governanceRouter.inboundCallBatches(hash)),
1303             uint256(GovernanceRouter.BatchStatus.Pending)
1304         );
1305     }
1306 
1307     function test_setRouterRevertLocalDomain() public {
1308         vm.expectRevert("can't set local router");
1309         governanceRouter.exposed_setRouter(homeDomain, bytes32("sfd"));
1310     }
1311 
1312     function test_setRouterNewDomain() public {
1313         uint32 newDomain = 13;
1314         bytes32 newRouter = "AFDDF";
1315         bytes32 previousRouter = governanceRouter.routers(newDomain);
1316         uint256 previousDomainsLength = governanceRouter.hack_domainsLength();
1317         vm.expectEmit(true, true, true, false);
1318         emit SetRouter(newDomain, previousRouter, newRouter);
1319         governanceRouter.exposed_setRouter(newDomain, newRouter);
1320         assertEq(governanceRouter.routers(newDomain), newRouter);
1321         assertEq(
1322             governanceRouter.hack_domainsLength(),
1323             previousDomainsLength + 1
1324         );
1325         assertEq(
1326             uint256(governanceRouter.domains(previousDomainsLength)),
1327             newDomain
1328         );
1329     }
1330 
1331     function test_setRouterExistingDomain() public {
1332         uint32 newDomain = remoteDomain;
1333         bytes32 newRouter = "AFDDF";
1334         bytes32 previousRouter = governanceRouter.routers(newDomain);
1335         uint256 previousDomainsLength = governanceRouter.hack_domainsLength();
1336         vm.expectEmit(true, true, true, false);
1337         emit SetRouter(newDomain, previousRouter, newRouter);
1338         governanceRouter.exposed_setRouter(newDomain, newRouter);
1339         assertEq(governanceRouter.routers(newDomain), newRouter);
1340         // we shouldn't add a new domain, since we set the router of
1341         // an existing domain
1342         assertEq(governanceRouter.hack_domainsLength(), previousDomainsLength);
1343     }
1344 
1345     // TODO: telemetry into domains array in fork mode?
1346     function test_setRouterRemoveDomain() public runNotInRecovery {
1347         uint32 newDomain = remoteDomain;
1348         bytes32 newRouter = bytes32(0);
1349         bytes32 previousRouter = governanceRouter.routers(newDomain);
1350         vm.expectEmit(true, true, true, false);
1351         emit SetRouter(newDomain, previousRouter, newRouter);
1352         prankGovernor();
1353         governanceRouter.setRouterLocal(newDomain, newRouter);
1354         assertEq(governanceRouter.routers(newDomain), newRouter);
1355     }
1356 
1357     // TODO: telemetry into domains array in fork mode?
1358     function test_setRouterRemoveDomainRecovery() public runInRecovery {
1359         uint32 newDomain = remoteDomain;
1360         bytes32 newRouter = bytes32(0);
1361         bytes32 previousRouter = governanceRouter.routers(newDomain);
1362         vm.expectEmit(true, true, true, false);
1363         emit SetRouter(newDomain, previousRouter, newRouter);
1364         prankRecoveryManager();
1365         governanceRouter.setRouterLocal(newDomain, newRouter);
1366         assertEq(governanceRouter.routers(newDomain), newRouter);
1367     }
1368 
1369     function test_isGovernorDomain() public runNotInRecovery {
1370         prankGovernor();
1371         governanceRouter.transferGovernor(
1372             remoteDomain,
1373             remoteGovernanceRouter.bytes32ToAddress()
1374         );
1375         assert(
1376             governanceRouter.exposed_isGovernorRouter(
1377                 remoteDomain,
1378                 remoteGovernanceRouter
1379             )
1380         );
1381         assertFalse(
1382             governanceRouter.exposed_isGovernorRouter(
1383                 remoteDomain,
1384                 address(governanceRouter).addressToBytes32()
1385             )
1386         );
1387         assertFalse(
1388             governanceRouter.exposed_isGovernorRouter(
1389                 homeDomain,
1390                 address(governanceRouter).addressToBytes32()
1391             )
1392         );
1393         assertFalse(
1394             governanceRouter.exposed_isGovernorRouter(
1395                 homeDomain,
1396                 remoteGovernanceRouter
1397             )
1398         );
1399     }
1400 
1401     function test_mustHaveRouter() public {
1402         assertEq(
1403             governanceRouter.exposed_mustHaveRouter(remoteDomain),
1404             remoteGovernanceRouter
1405         );
1406         vm.expectRevert("!router");
1407         governanceRouter.exposed_mustHaveRouter(homeDomain);
1408     }
1409 
1410     /*//////////////////////////////////////////////////////////////
1411                                 UTILITIES
1412     //////////////////////////////////////////////////////////////*/
1413 
1414     function enterRecovery() public {
1415         prankRecoveryManager();
1416         vm.expectEmit(true, false, false, true);
1417         emit InitiateRecovery(recoveryManager, block.timestamp + timelock);
1418         governanceRouter.initiateRecoveryTimelock();
1419         vm.warp(block.timestamp + timelock);
1420         assert(governanceRouter.inRecovery());
1421         assertEq(governanceRouter.recoveryActiveAt(), block.timestamp);
1422     }
1423 
1424     function exitRecovery() public {
1425         prankRecoveryManager();
1426         vm.expectEmit(true, false, false, true);
1427         emit ExitRecovery(recoveryManager);
1428         governanceRouter.exitRecovery();
1429         assert(!governanceRouter.inRecovery());
1430         assertEq(governanceRouter.recoveryActiveAt(), 0);
1431     }
1432 
1433     modifier runNotInRecovery() {
1434         if (governanceRouter.inRecovery()) exitRecovery();
1435         _;
1436     }
1437 
1438     modifier runInRecovery() {
1439         if (!governanceRouter.inRecovery()) enterRecovery();
1440         _;
1441     }
1442 
1443     modifier runNonGoverning() {
1444         // if currently governor domain, transfer to remote governor
1445         // else the router will not accept incoming messages
1446         if (governanceRouter.governorDomain() == homeDomain) {
1447             if (governanceRouter.inRecovery()) exitRecovery();
1448             prankGovernor();
1449             governanceRouter.transferGovernor(remoteDomain, vm.addr(412));
1450         }
1451         _;
1452     }
1453 
1454     function prankReplica(uint32 _d) internal {
1455         vm.prank(xAppConnectionManager.domainToReplica(_d));
1456     }
1457 
1458     function prankReplica() internal {
1459         prankReplica(remoteDomain);
1460     }
1461 
1462     function prankGovernor() internal {
1463         vm.prank(governanceRouter.governor());
1464     }
1465 
1466     function prankRecoveryManager() internal {
1467         vm.prank(governanceRouter.recoveryManager());
1468     }
1469 }
