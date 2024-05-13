1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // Bridge Imports
5 import {BridgeMessage} from "../BridgeMessage.sol";
6 import {BridgeTestFixture} from "./utils/BridgeTest.sol";
7 import {BridgeToken} from "../BridgeToken.sol";
8 import {EthereumBridgeRouterHarness} from "./harness/BridgeRouterHarness.sol";
9 import {RevertingToHook} from "./utils/RevertingToHook.sol";
10 import {MockHome} from "./utils/MockHome.sol";
11 // Core Imports
12 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/libs/TypeCasts.sol";
13 // External Imports
14 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
15 import {Test, console2} from "forge-std/Test.sol";
16 
17 /// @notice The default bridgeRouter is BridgeRouter (BaseBridgeRouter)
18 /// @dev It should implement common functionality between nonEthereumBridgeRouter and
19 /// EthereumBridgeRouter
20 abstract contract BridgeRouterBaseTest is BridgeTestFixture {
21     address tokenSender;
22     bytes32 tokenReceiver;
23 
24     uint32 receiverDomain;
25     uint32 senderDomain;
26 
27     bool fastLiquidityEnabled;
28 
29     RevertingToHook revertingToHook;
30 
31     uint256 internal constant A_LOT = 0xffff_ffff_ffff_ffff_ffff_ffff_ffff;
32 
33     using TypeCasts for bytes32;
34     using TypeCasts for address payable;
35     using TypeCasts for address;
36     using TypedMemView for bytes;
37     using TypedMemView for bytes29;
38     using BridgeMessage for bytes29;
39 
40     function setUp() public virtual override {
41         super.setUp();
42         setUp_testFixtures();
43     }
44 
45     function setUp_testFixtures() public virtual override(BridgeTestFixture) {
46         super.setUp_testFixtures();
47         tokenSender = bridgeUser;
48         tokenReceiver = vm.addr(3040).addressToBytes32();
49         senderDomain = homeDomain;
50         receiverDomain = remoteDomain;
51         revertingToHook = new RevertingToHook();
52     }
53 
54     function test_dustAmmountIs006() public {
55         assertEq(bridgeRouter.DUST_AMOUNT(), 0.06 ether);
56     }
57 
58     function test_handleRevertsIfNotCalledByReplica() public {
59         uint32 nonce = 23;
60         bytes memory message = "lol";
61         bytes32 sender = remoteRouter();
62         vm.expectRevert("!replica");
63         bridgeRouter.handle(remoteDomain, nonce, sender, message);
64     }
65 
66     function test_handleRevertsIfSenderNotRegisteredRouter() public {
67         uint32 nonce = 23;
68         bytes memory message = "lol";
69         bytes32 sender = address(0xBEEF).addressToBytes32();
70         prankReplica();
71         vm.expectRevert("!remote router");
72         bridgeRouter.handle(remoteDomain, nonce, sender, message);
73     }
74 
75     // The only registured remote router is for domain = remoteDomain and sender = remoteBridgeRouter
76     function testFuzz_handleRevertsIfSenderNotRegisteredRouter(
77         bytes32 sender,
78         uint32 domain
79     ) public {
80         vm.assume(domain != remoteDomain && sender != remoteBridgeRouter);
81         uint32 nonce = 23;
82         bytes memory message = "lol";
83         prankReplica();
84         vm.expectRevert("!remote router");
85         bridgeRouter.handle(domain, nonce, sender, message);
86     }
87 
88     function test_handleRevertsIfSenderNotCorrectDomain() public {
89         uint32 nonce = 23;
90         bytes memory message = "lol";
91         bytes32 sender = remoteRouter();
92         prankReplica();
93         vm.expectRevert("!remote router");
94         bridgeRouter.handle(123, nonce, sender, message);
95     }
96 
97     function test_handleRevertsIfMalformedMessage() public {
98         uint32 nonce = 23;
99         bytes memory message = "lol";
100         bytes32 sender = remoteRouter();
101         prankReplica();
102         vm.expectRevert("Validity assertion failed");
103         bridgeRouter.handle(remoteDomain, nonce, sender, message);
104     }
105 
106     function test_handleRevertsIfInvalidAction() public {
107         uint32 nonce = 23;
108         uint256 tokenAmount = 100;
109         bytes32 tokenDetailsHash = "sdf";
110         // Invalid
111         bytes memory action = abi.encodePacked(
112             BridgeMessage.Types.Invalid,
113             tokenReceiver,
114             tokenAmount,
115             tokenDetailsHash
116         );
117         bytes32 id = address(localToken).addressToBytes32();
118         bytes memory tokenId = abi.encodePacked(remoteDomain, id);
119         bytes memory message = abi.encodePacked(tokenId, action);
120         bytes32 sender = remoteRouter();
121         prankReplica();
122         vm.expectRevert("!valid action");
123         bridgeRouter.handle(remoteDomain, nonce, sender, message);
124     }
125 
126     /// @notice Test that the only valid actions are the enums Message.Types.TransferToHook
127     /// and Message.Types.Message, which in numbers are 5 and 3 respectively.
128     /// If the enumAction was a larger number, we get the Validity assertion failed error,
129     /// as the message is not of the correct form
130     function test_handleRevertsIfInvalidAction(uint8 enumAction) public {
131         vm.assume(enumAction != 3 && enumAction != 5);
132         uint32 nonce = 23;
133         uint256 tokenAmount = 100;
134         bytes32 tokenDetailsHash = "sdf";
135         // Invalid
136         bytes memory action = abi.encodePacked(
137             enumAction,
138             tokenReceiver,
139             tokenAmount,
140             tokenDetailsHash
141         );
142         bytes32 id = address(localToken).addressToBytes32();
143         bytes memory tokenId = abi.encodePacked(remoteDomain, id);
144         bytes32 sender = remoteRouter();
145         bytes memory message = abi.encodePacked(tokenId, action);
146         prankReplica();
147         vm.expectRevert("!valid action");
148         bridgeRouter.handle(remoteDomain, nonce, sender, message);
149     }
150 
151     function test_handleRevertsIfMalformedAction() public {
152         uint32 nonce = 23;
153         uint256 tokenAmount = 100;
154         // it should be bytes32
155         string memory tokenDetailsHash = "sdf";
156         bytes memory action = abi.encodePacked(
157             BridgeMessage.Types.Transfer,
158             tokenReceiver,
159             tokenAmount,
160             tokenDetailsHash
161         );
162         bytes32 id = address(localToken).addressToBytes32();
163         bytes memory tokenId = abi.encodePacked(remoteDomain, id);
164         bytes32 sender = remoteRouter();
165         bytes memory message = abi.encodePacked(tokenId, action);
166         prankReplica();
167         vm.expectRevert("Validity assertion failed");
168         bridgeRouter.handle(remoteDomain, nonce, sender, message);
169     }
170 
171     function test_handleRevertsIfMalformedTokenId() public {
172         uint32 nonce = 23;
173         uint256 tokenAmount = 100;
174         bytes32 tokenDetailsHash = "sdf";
175         // Invalid
176         bytes memory action = abi.encodePacked(
177             BridgeMessage.Types.Transfer,
178             tokenReceiver,
179             tokenAmount,
180             tokenDetailsHash
181         );
182         // it should be bytes32
183         address id = address(localToken);
184         bytes memory tokenId = abi.encodePacked(remoteDomain, id);
185         bytes32 sender = remoteRouter();
186         bytes memory message = abi.encodePacked(tokenId, action);
187         prankReplica();
188         vm.expectRevert("Validity assertion failed");
189         bridgeRouter.handle(remoteDomain, nonce, sender, message);
190     }
191 
192     function test_handleSuccessTransfer() public {
193         uint32 nonce = 23;
194         uint256 tokenAmount = 100;
195         bytes32 tokenDetailsHash = "sdf";
196         // Invalid
197         bytes memory action = abi.encodePacked(
198             BridgeMessage.Types.Transfer,
199             tokenReceiver,
200             tokenAmount,
201             tokenDetailsHash
202         );
203         bytes32 id = address(localToken).addressToBytes32();
204         bytes memory tokenId = abi.encodePacked(homeDomain, id);
205         bytes32 sender = remoteRouter();
206         bytes memory message = abi.encodePacked(tokenId, action);
207         localToken.mint(address(bridgeRouter), 100);
208         prankReplica();
209         bridgeRouter.handle(remoteDomain, nonce, sender, message);
210         assertEq(localToken.balanceOf(tokenReceiver.bytes32ToAddress()), 100);
211     }
212 
213     function testFuzz_handleSuccessTransfer(
214         uint32 nonce,
215         uint256 tokenAmount,
216         bytes32 tokenDetailsHash
217     ) public {
218         // We have already minted bridgeUserTokenAmount of tokens during
219         // setUp(). We bound that so we don't revert because of math overflow
220         tokenAmount = bound(tokenAmount, 0, A_LOT);
221         localToken.mint(address(bridgeRouter), tokenAmount);
222         bytes memory action = abi.encodePacked(
223             BridgeMessage.Types.Transfer,
224             tokenReceiver,
225             tokenAmount,
226             tokenDetailsHash
227         );
228         bytes32 id = address(localToken).addressToBytes32();
229         bytes memory tokenId = abi.encodePacked(homeDomain, id);
230         bytes32 sender = remoteRouter();
231         bytes memory message = abi.encodePacked(tokenId, action);
232         prankReplica();
233         bridgeRouter.handle(remoteDomain, nonce, sender, message);
234         assertEq(
235             localToken.balanceOf(tokenReceiver.bytes32ToAddress()),
236             tokenAmount
237         );
238     }
239 
240     function test_handleSuccessTransferToHook() public {
241         bytes32 hook = address(revertingToHook).addressToBytes32();
242         uint256 tokenAmount = 100;
243         bytes32 tokenDetailsHash = "sdf";
244         bytes32 sender = remoteRouter();
245         bytes memory extraData = "sdfdsf";
246         bytes memory action = abi.encodePacked(
247             BridgeMessage.Types.TransferToHook,
248             hook,
249             tokenAmount,
250             tokenDetailsHash,
251             sender,
252             extraData
253         );
254         uint32 nonce = 10;
255         uint32 origin = 1;
256         localToken.mint(address(bridgeRouter), tokenAmount);
257         // Enroll a router for the domain = 1
258         prankOwner(address(bridgeRouter));
259         bridgeRouter.enrollRemoteRouter(origin, sender);
260         bytes memory tokenId = abi.encodePacked(
261             homeDomain,
262             address(localToken).addressToBytes32()
263         );
264         bytes memory message = abi.encodePacked(tokenId, action);
265         prankReplica();
266         bridgeRouter.handle(origin, nonce, sender, message);
267         assertEq(revertingToHook.test(), 123);
268     }
269 
270     function testFuzz_handleSuccessTransferToHook(
271         uint256 tokenAmount,
272         bytes32 tokenDetailsHash,
273         bytes memory extraData
274     ) public {
275         // We have already minted bridgeUserTokenAmount of tokens during
276         // setUp(). We bound that so we don't revert because of math overflow
277         tokenAmount = bound(
278             tokenAmount,
279             0,
280             type(uint256).max - bridgeUserTokenAmount
281         );
282         // test state
283         uint32 nonce = 10;
284         uint32 origin = 1;
285         bytes32 hook = address(revertingToHook).addressToBytes32();
286         bytes32 sender = remoteRouter();
287         bytes memory action = abi.encodePacked(
288             BridgeMessage.Types.TransferToHook,
289             hook,
290             tokenAmount,
291             tokenDetailsHash,
292             sender,
293             extraData
294         );
295         // Enroll a router for the domain = 1
296         localToken.mint(address(bridgeRouter), tokenAmount);
297         prankOwner(address(bridgeRouter));
298         bridgeRouter.enrollRemoteRouter(origin, sender);
299         bytes memory tokenId = abi.encodePacked(
300             homeDomain,
301             address(localToken).addressToBytes32()
302         );
303         bytes memory message = abi.encodePacked(tokenId, action);
304         prankReplica();
305         bridgeRouter.handle(origin, nonce, sender, message);
306         assertEq(revertingToHook.test(), 123);
307         assertEq(localToken.balanceOf(address(revertingToHook)), tokenAmount);
308     }
309 
310     function test_sendRevertsIfRecipientIsZero() public {
311         address token = address(localToken);
312         uint256 amount = 100;
313         bytes32 recipient = bytes32(0);
314         vm.expectRevert("!recip");
315         bridgeRouter.send(token, amount, receiverDomain, recipient, true);
316     }
317 
318     function test_sendLocalRevertsTokenDisabled() public {
319         uint256 amount = 100;
320         vm.startPrank(tokenSender);
321         localToken.approve(address(bridgeRouter), amount);
322         vm.expectRevert("sends temporarily disabled");
323         bridgeRouter.send(
324             address(localToken),
325             amount,
326             receiverDomain,
327             tokenReceiver,
328             fastLiquidityEnabled
329         );
330         vm.expectRevert("sends temporarily disabled");
331         bridgeRouter.sendToHook(
332             address(localToken),
333             amount,
334             receiverDomain,
335             tokenReceiver,
336             "0x1234"
337         );
338     }
339 
340     event Send(
341         address indexed token,
342         address indexed from,
343         uint32 indexed toDomain,
344         bytes32 toId,
345         uint256 amount,
346         bool fastLiquidityEnabled
347     );
348 
349     function test_sendLocalTokenRevertsIfNotApprove() public {
350         uint256 amount = 100;
351         vm.startPrank(tokenSender);
352         vm.expectRevert("ERC20: transfer amount exceeds allowance");
353         bridgeRouter.send(
354             address(localToken),
355             amount,
356             homeDomain,
357             tokenReceiver,
358             fastLiquidityEnabled
359         );
360         vm.stopPrank();
361     }
362 
363     function test_sendRemoteSuccess() public {
364         uint256 amount = 100;
365         vm.startPrank(tokenSender);
366         // Expect that the ERC20 will emit an event with the approval
367         remoteToken.approve(address(bridgeRouter), amount);
368         // Expect the Bridge Router to emit the correct event
369         vm.expectEmit(true, true, true, true, address(bridgeRouter));
370         emit Send(
371             address(remoteToken),
372             tokenSender,
373             receiverDomain,
374             tokenReceiver,
375             amount,
376             fastLiquidityEnabled
377         );
378         bridgeRouter.send(
379             address(remoteToken),
380             amount,
381             receiverDomain,
382             tokenReceiver,
383             fastLiquidityEnabled
384         );
385         vm.stopPrank();
386     }
387 
388     function test_enrollCustomRevertsIfNotOwner() public {
389         vm.prank(address(0xBEEF));
390         uint32 domain = remoteDomain;
391         bytes32 id = "sf";
392         address custom = address(this);
393         vm.expectRevert("Ownable: caller is not the owner");
394         bridgeRouter.enrollCustom(domain, id, custom);
395     }
396 
397     function test_enrollCustomRevertsIfBridgeNotOwner() public {
398         // Let's assume that newToken (BrigeToken) is a custom
399         // token deployed by some DAO and that it's the representation
400         // of the token with id = "remoteAddress"
401         uint32 domain = remoteDomain;
402         bytes32 id = "remoteAddress";
403         address custom = address(new BridgeToken());
404         BridgeToken(custom).initialize();
405         vm.expectRevert("Ownable: caller is not the owner");
406         bridgeRouter.enrollCustom(domain, id, custom);
407     }
408 
409     function test_enrollCustomSuccess() public {
410         // Let's assume that newToken (BrigeToken) is a custom
411         // token deployed by some DAO and that it's the representation
412         // of the token with id = "remoteAddress"
413         uint32 domain = remoteDomain;
414         bytes32 id = "remoteAddress";
415         address custom = address(new BridgeToken());
416         BridgeToken(custom).initialize();
417         BridgeToken(custom).transferOwnership(address(bridgeRouter));
418         uint256 supply = localToken.totalSupply();
419         prankOwner(address(bridgeRouter));
420         bridgeRouter.enrollCustom(domain, id, custom);
421         // We mint a token to make sure we have the appropriate ownership set
422         // We want to make sure we burn it afterwards
423         assertEq(localToken.totalSupply(), supply);
424         bytes29 tokenId = BridgeMessage.formatTokenId(domain, id);
425         assertEq(
426             tokenRegistry.canonicalToRepresentation(tokenId.keccak()),
427             custom
428         );
429         (uint32 returnedDomain, bytes32 returnedId) = tokenRegistry
430             .representationToCanonical(custom);
431         assertEq(returnedDomain, uint256(domain));
432         assertEq(returnedId, id);
433     }
434 
435     function testFuzz_enrollCustomSuccess(uint32 domain, bytes32 id) public {
436         address custom = address(new BridgeToken());
437         BridgeToken(custom).initialize();
438         BridgeToken(custom).transferOwnership(address(bridgeRouter));
439         uint256 supply = localToken.totalSupply();
440         prankOwner(address(bridgeRouter));
441         if (domain == 0) {
442             vm.expectRevert("!null domain");
443         }
444         bridgeRouter.enrollCustom(domain, id, custom);
445         vm.stopPrank();
446         // if domain = 0, the transaction will revert (as caught above) and thus
447         // we shouldn't perform an assertions
448         if (domain == 0) {
449             return;
450         }
451         // We mint a token to make sure we have the appropriate ownership set
452         // We want to make sure we burn it afterwards
453         assertEq(localToken.totalSupply(), supply);
454         bytes29 tokenId = BridgeMessage.formatTokenId(domain, id);
455         assertEq(
456             tokenRegistry.canonicalToRepresentation(tokenId.keccak()),
457             custom
458         );
459         (uint32 returnedDomain, bytes32 returnedId) = tokenRegistry
460             .representationToCanonical(custom);
461         assertEq(returnedDomain, uint256(domain));
462         assertEq(returnedId, id);
463     }
464 
465     function test_migrateRevertsIfSameRepr() public {
466         vm.expectRevert("!different");
467         bridgeRouter.migrate(remoteTokenLocalAddress);
468     }
469 
470     function test_migrateSuccess() public {
471         uint32 domain = remoteDomain;
472         bytes32 id = "remoteAddress";
473         address user = address(0xBEEEF);
474         address custom = address(new BridgeToken());
475         BridgeToken(custom).initialize();
476         BridgeToken(custom).transferOwnership(address(bridgeRouter));
477         prankOwner(address(bridgeRouter));
478         bridgeRouter.enrollCustom(domain, id, custom);
479         vm.prank(address(bridgeRouter));
480         BridgeToken(custom).mint(user, 1000);
481         address newCustom = address(new BridgeToken());
482         BridgeToken(newCustom).initialize();
483         BridgeToken(newCustom).transferOwnership(address(bridgeRouter));
484         // Enroll a new representation of the same remote token
485         prankOwner(address(bridgeRouter));
486         bridgeRouter.enrollCustom(domain, id, newCustom);
487         // Execute as the user who wants to migrate their tokens
488         vm.prank(user);
489         bridgeRouter.migrate(custom);
490         // old tokens have been burned
491         assertEq(BridgeToken(custom).balanceOf(user), 0);
492         // new tokens have been minted
493         assertEq(BridgeToken(newCustom).balanceOf(user), 1000);
494     }
495 
496     event Transfer(address indexed from, address indexed to, uint256 value);
497     event Approval(
498         address indexed owner,
499         address indexed spender,
500         uint256 value
501     );
502 
503     function test_takeTokensLocalSuccess() public {
504         uint256 amount = 100;
505         uint256 startingBalance = localToken.balanceOf(address(bridgeRouter));
506         uint256 startingSupply = localToken.totalSupply();
507         vm.expectEmit(true, true, false, true, address(localToken));
508         emit Approval(tokenSender, address(bridgeRouter), amount);
509         // Expect that the ERC20 will emit an event with the approval
510         vm.startPrank(tokenSender);
511         localToken.approve(address(bridgeRouter), amount);
512         vm.expectEmit(true, true, false, true, address(localToken));
513         emit Transfer(tokenSender, address(bridgeRouter), amount);
514         bridgeRouter.exposed_takeTokens(address(localToken), amount);
515         uint256 afterBalance = localToken.balanceOf(address(bridgeRouter));
516         assertEq(afterBalance, startingBalance + amount);
517         assertEq(localToken.totalSupply(), startingSupply);
518         vm.stopPrank();
519     }
520 
521     function test_takeTokensLocalFailZeroAmount() public {
522         uint256 amount = 0;
523         vm.expectRevert("!amnt");
524         bridgeRouter.exposed_takeTokens(address(localToken), amount);
525     }
526 
527     function test_takeTokensRepresentationSuccess() public {
528         uint256 amount = 100;
529         uint256 startingBalance = remoteToken.balanceOf(tokenSender);
530         uint256 startingSupply = remoteToken.totalSupply();
531         vm.startPrank(tokenSender);
532         vm.expectEmit(true, true, false, true, address(remoteToken));
533         emit Approval(tokenSender, address(bridgeRouter), amount);
534         // Expect that the ERC20 will emit an event with the approval
535         remoteToken.approve(address(bridgeRouter), amount);
536         vm.expectEmit(true, true, false, true, address(remoteToken));
537         emit Transfer(tokenSender, address(0), amount);
538         bridgeRouter.exposed_takeTokens(address(remoteToken), amount);
539         uint256 afterBalance = remoteToken.balanceOf(tokenSender);
540         assertEq(afterBalance, startingBalance - amount);
541         assertEq(remoteToken.totalSupply(), startingSupply - amount);
542         vm.stopPrank();
543     }
544 
545     // We test the correct returned data in the send() tests.
546     // It returnes a bytes29 pointed that is invalid, since it refers to
547     // the memory of the contract, not the test contract. It doesn't
548     // make sense outside the memoroy context of the BridgeRouter
549 
550     function test_sendTransferMessage() public {
551         uint32 destination = remoteDomain;
552         bytes32 _tokenReceiver = address(0xBEEF).addressToBytes32();
553         uint256 tokenAmount = 1000;
554         bytes32 tokenDetailsHash = "details";
555         bytes memory action = abi.encodePacked(
556             BridgeMessage.Types.Transfer,
557             _tokenReceiver,
558             tokenAmount,
559             tokenDetailsHash
560         );
561         // let's assume we send a representation of a remote token
562         bytes32 tokenAddress = remoteTokenLocalAddress.addressToBytes32();
563         bytes memory tokenId = abi.encodePacked(homeDomain, tokenAddress);
564         bytes memory message = abi.encodePacked(tokenId, action);
565         vm.expectCall(
566             address(home),
567             0,
568             abi.encodeWithSelector(
569                 mockHome.dispatch.selector,
570                 destination,
571                 remoteRouter(),
572                 message
573             )
574         );
575         bridgeRouter.exposed_sendTransferMessage(destination, tokenId, action);
576     }
577 
578     function test_handleTransferSucceedsIfRecipientNotEvmAddress() public {
579         uint256 tokenAmount = 100;
580         bytes32 tokenDetailsHash = "sdf";
581         bytes32 recipient = "not an address";
582         bytes memory action = abi.encodePacked(
583             BridgeMessage.Types.Transfer,
584             recipient,
585             tokenAmount,
586             tokenDetailsHash
587         );
588         uint32 origin = remoteDomain;
589         uint32 nonce = 10;
590         bytes memory tokenId = abi.encodePacked(
591             homeDomain,
592             address(localToken).addressToBytes32()
593         );
594         localToken.mint(address(bridgeRouter), tokenAmount);
595         vm.deal(address(bridgeRouter), bridgeRouter.DUST_AMOUNT());
596         bridgeRouter.exposed_handleTransfer(origin, nonce, tokenId, action);
597         assertEq(
598             localToken.balanceOf(recipient.bytes32ToAddress()),
599             tokenAmount
600         );
601         assertEq(
602             recipient.bytes32ToAddress().balance,
603             bridgeRouter.DUST_AMOUNT()
604         );
605     }
606 
607     function testFuzz_handleTransferSucceedsIfRecipienttNotRevert(
608         uint256 tokenAmount,
609         bytes32 tokenDetailsHash,
610         uint32 nonce,
611         uint32 origin
612     ) public {
613         // We have already minted bridgeUserTokenAmount of tokens during
614         // setUp(). We bound that so we don't revert because of math overflow
615         bytes32 recipient = "asdfasfasdf";
616         tokenAmount = bound(
617             tokenAmount,
618             0,
619             type(uint256).max - bridgeUserTokenAmount
620         );
621         bytes memory action = abi.encodePacked(
622             BridgeMessage.Types.Transfer,
623             recipient,
624             tokenAmount,
625             tokenDetailsHash
626         );
627         bytes memory tokenId = abi.encodePacked(
628             homeDomain,
629             address(localToken).addressToBytes32()
630         );
631         localToken.mint(address(bridgeRouter), tokenAmount);
632         vm.deal(address(bridgeRouter), bridgeRouter.DUST_AMOUNT());
633         bool dusted;
634         if (nonce % 2 == 1) {
635             dusted = true;
636             vm.deal(recipient.bytes32ToAddress(), bridgeRouter.DUST_AMOUNT());
637         }
638         if (recipient.bytes32ToAddress() == address(0)) {
639             vm.expectRevert("ERC20: transfer to the zero address");
640             bridgeRouter.exposed_handleTransfer(origin, nonce, tokenId, action);
641             // so we don't run the assertions
642             return;
643         }
644         bridgeRouter.exposed_handleTransfer(origin, nonce, tokenId, action);
645         assertEq(
646             localToken.balanceOf(recipient.bytes32ToAddress()),
647             tokenAmount
648         );
649         if (dusted) {
650             assertEq(
651                 recipient.bytes32ToAddress().balance,
652                 bridgeRouter.DUST_AMOUNT()
653             );
654             assertEq(address(bridgeRouter).balance, bridgeRouter.DUST_AMOUNT());
655             return;
656         }
657         assertEq(
658             recipient.bytes32ToAddress().balance,
659             bridgeRouter.DUST_AMOUNT()
660         );
661     }
662 
663     function test_handleHookTransferRevertsIfCallFailsMessage() public {
664         bytes32 hook = address(revertingToHook).addressToBytes32();
665         uint256 tokenAmount = 100;
666         bytes32 tokenDetailsHash = "sdf";
667         bytes32 sender = address(0xBEEF).addressToBytes32();
668         localToken.mint(address(bridgeRouter), tokenAmount);
669         bytes memory extraData = "sdfdsf";
670         bytes memory action = abi.encodePacked(
671             BridgeMessage.Types.TransferToHook,
672             hook,
673             tokenAmount,
674             tokenDetailsHash,
675             sender,
676             extraData
677         );
678         uint32 origin = 123;
679         uint32 nonce = 10;
680         bytes memory tokenId = abi.encodePacked(
681             homeDomain,
682             address(localToken).addressToBytes32()
683         );
684         vm.expectRevert("nope!");
685         bridgeRouter.exposed_handleTransferToHook(
686             origin,
687             nonce,
688             tokenId,
689             action
690         );
691     }
692 
693     function test_handleHookTransferRevertsIfCallFailsNoMessage() public {
694         bytes32 hook = address(revertingToHook).addressToBytes32();
695         uint256 tokenAmount = 100;
696         bytes32 tokenDetailsHash = "sdf";
697         bytes32 sender = address(0xBEEF).addressToBytes32();
698         localToken.mint(address(bridgeRouter), tokenAmount);
699         bytes memory extraData = "sdfdsf";
700         bytes memory action = abi.encodePacked(
701             BridgeMessage.Types.TransferToHook,
702             hook,
703             tokenAmount,
704             tokenDetailsHash,
705             sender,
706             extraData
707         );
708         uint32 origin = 600;
709         uint32 nonce = 10;
710         bytes memory tokenId = abi.encodePacked(
711             homeDomain,
712             address(localToken).addressToBytes32()
713         );
714         vm.expectRevert();
715         bridgeRouter.exposed_handleTransferToHook(
716             origin,
717             nonce,
718             tokenId,
719             action
720         );
721     }
722 
723     function test_handleHookTransferSucceeds() public {
724         bytes32 hook = address(revertingToHook).addressToBytes32();
725         uint256 tokenAmount = 100;
726         bytes32 tokenDetailsHash = "sdf";
727         bytes32 sender = address(0xBEEF).addressToBytes32();
728         localToken.mint(address(bridgeRouter), tokenAmount);
729         bytes memory extraData = "sdfdsf";
730         bytes memory action = abi.encodePacked(
731             BridgeMessage.Types.TransferToHook,
732             hook,
733             tokenAmount,
734             tokenDetailsHash,
735             sender,
736             extraData
737         );
738         uint32 origin = 9;
739         uint32 nonce = 10;
740         bytes memory tokenId = abi.encodePacked(
741             homeDomain,
742             address(localToken).addressToBytes32()
743         );
744         // The hook succeeds
745         bridgeRouter.exposed_handleTransferToHook(
746             origin,
747             nonce,
748             tokenId,
749             action
750         );
751         assertEq(revertingToHook.test(), 123);
752     }
753 
754     function testFuzz_handleHookTransferSucceeds(
755         uint256 tokenAmount,
756         bytes32 tokenDetailsHash,
757         bytes memory extraData,
758         bytes32 sender,
759         uint32 nonce
760     ) public {
761         tokenAmount = bound(
762             tokenAmount,
763             0,
764             type(uint256).max - bridgeUserTokenAmount
765         );
766         bytes32 hook = address(revertingToHook).addressToBytes32();
767         // The hook will succed only if origin < 10. This has nothing
768         // to do with how transferToHook works, but rather how the mock works.
769         // We created a mock that will have different behaviour depending on the origin,
770         // so that we can test different scenarios easily.
771         uint32 origin = 1;
772         localToken.mint(address(bridgeRouter), tokenAmount);
773         bytes memory action = abi.encodePacked(
774             BridgeMessage.Types.TransferToHook,
775             hook,
776             tokenAmount,
777             tokenDetailsHash,
778             sender,
779             extraData
780         );
781         bytes memory tokenId = abi.encodePacked(
782             homeDomain,
783             address(localToken).addressToBytes32()
784         );
785         // The hook succeeds
786         bridgeRouter.exposed_handleTransferToHook(
787             origin,
788             nonce,
789             tokenId,
790             action
791         );
792         assertEq(revertingToHook.test(), 123);
793     }
794 
795     function test_dust() public {
796         address alice = address(0xBEEEEF);
797         address bob = address(0xBEEEEEEEEEF);
798         vm.deal(alice, 10 ether);
799         vm.deal(address(bridgeRouter), 20 ether);
800 
801         bridgeRouter.exposed_dust(alice);
802         bridgeRouter.exposed_dust(bob);
803 
804         assertEq(alice.balance, 10 ether);
805         assertEq(bob.balance, bridgeRouter.DUST_AMOUNT());
806         assertEq(
807             address(bridgeRouter).balance,
808             20 ether - bridgeRouter.DUST_AMOUNT()
809         );
810     }
811 
812     function testFuzz_originAndNonce(uint32 origin, uint32 nonce) public {
813         assertEq(
814             bridgeRouter.exposed_originAndNonce(origin, nonce),
815             uint256((uint64(origin) << 32) | nonce)
816         );
817     }
818 
819     function test_renounceOwnership() public {
820         address owner = bridgeRouter.owner();
821         prankOwner(address(bridgeRouter));
822         bridgeRouter.renounceOwnership();
823         assertEq(bridgeRouter.owner(), owner);
824     }
825 }
