1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 /*//////////////////////////////////////////////////////////////
5                            CONTRACTS
6 //////////////////////////////////////////////////////////////*/
7 
8 import {BridgeMessage} from "../BridgeMessage.sol";
9 
10 /*//////////////////////////////////////////////////////////////
11                             LIBRARIES
12 //////////////////////////////////////////////////////////////*/
13 
14 import "forge-std/Test.sol";
15 import "forge-std/console2.sol";
16 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
17 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/libs/TypeCasts.sol";
18 
19 contract BridgeMessageTest is Test {
20     using TypedMemView for bytes;
21     using TypedMemView for bytes29;
22     using BridgeMessage for bytes29;
23 
24     bytes32 tokenAddress;
25     bytes32 tokenReceiver;
26     bytes32 tokenSender;
27     uint32 localDomain;
28     uint32 remoteDomain;
29 
30     string tokenName;
31     string tokenSymbol;
32     uint8 tokenDecimals;
33     bytes32 tokenDetailsHash;
34     uint256 tokenAmount;
35 
36     uint256 TOKEN_ID_LEN = 36; // 4 bytes domain + 32 bytes id
37     uint256 IDENTIFIER_LEN = 1;
38     uint256 TRANSFER_LEN = 97; // 1 byte identifier + 32 bytes recipient + 32 bytes amount + 32 bytes detailsHash
39 
40     function setUp() public {
41         tokenAddress = TypeCasts.addressToBytes32(
42             0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
43         );
44         tokenName = "Fake Token";
45         tokenSymbol = "FK";
46         tokenDecimals = 18;
47 
48         tokenReceiver = TypeCasts.addressToBytes32(
49             0xd6A56d9f45683cDBEb1A3fcAdaca1fd78A352cd0
50         );
51         tokenSender = TypeCasts.addressToBytes32(
52             0x74de5d4FCbf63E00296fd95d33236B9794016631
53         );
54         localDomain = 1500;
55         remoteDomain = 6000;
56         tokenDetailsHash = "FK TOKEN";
57         tokenAmount = 42069;
58     }
59 
60     /// @notice Verify that the enum for the memview types remains unchaged
61     function test_typeOrderUnchanged() public {
62         assertEq(uint256(BridgeMessage.Types.Invalid), 0);
63         assertEq(uint256(BridgeMessage.Types.TokenId), 1);
64         assertEq(uint256(BridgeMessage.Types.Message), 2);
65         assertEq(uint256(BridgeMessage.Types.Transfer), 3);
66         assertEq(uint256(BridgeMessage.Types.DeprecatedFastTransfer), 4);
67         assertEq(uint256(BridgeMessage.Types.TransferToHook), 5);
68         assertEq(uint256(BridgeMessage.Types.ExtraData), 6);
69     }
70 
71     function test_isValidActionSuccess() public pure {
72         bytes29 transferAction = abi
73             .encodePacked(BridgeMessage.Types.Transfer)
74             .ref(uint40(BridgeMessage.Types.Transfer));
75         bytes29 hookAction = abi
76             .encodePacked(BridgeMessage.Types.TransferToHook)
77             .ref(uint40(BridgeMessage.Types.TransferToHook));
78 
79         assert(BridgeMessage.isValidAction(transferAction));
80         assert(BridgeMessage.isValidAction(hookAction));
81     }
82 
83     function test_isValidActionRevertWrongViewType() public {
84         bytes29 hookAction = abi
85             .encodePacked(BridgeMessage.Types.TransferToHook)
86             .ref(uint40(BridgeMessage.Types.Invalid));
87         assertFalse(BridgeMessage.isValidAction(hookAction));
88     }
89 
90     function test_isValidActionRevertWrongActionType() public {
91         bytes29 hookAction = abi.encodePacked(BridgeMessage.Types.Invalid).ref(
92             uint40(BridgeMessage.Types.TransferToHook)
93         );
94         assertFalse(BridgeMessage.isValidAction(hookAction));
95     }
96 
97     function test_isValidActionRevertWrongActionTypeViewType() public {
98         bytes29 hookAction = abi.encodePacked(BridgeMessage.Types.Invalid).ref(
99             uint40(BridgeMessage.Types.Invalid)
100         );
101         assertFalse(BridgeMessage.isValidAction(hookAction));
102     }
103 
104     /// @notice A BridgeMessage must be at least TOKEN_ID_LEN + MIN_TRANSFER_LEN
105     /// so that it can contain all the required information needed by
106     /// the Bridge. Apart from that, the upper bound is set by the
107     /// Nomad Protocol itself.
108     function test_isValidMessageLength() public {
109         bytes memory longMessage = new bytes(9999999);
110         bytes memory shortMessage = new bytes(10);
111         bytes29 longView = longMessage.ref(0);
112         bytes29 shortView = shortMessage.ref(0);
113         assertFalse(BridgeMessage.isValidMessageLength(shortView));
114         assertTrue(BridgeMessage.isValidMessageLength(longView));
115     }
116 
117     function test_formatMessageFailNotAction() public {
118         // I encode the correct type inside the data structure
119         // but set the wrong type in the view
120         // formatMessage() accepts only views of type "Transfer"
121         bytes29 action = abi
122             .encodePacked(
123                 BridgeMessage.Types.Transfer,
124                 tokenReceiver,
125                 tokenAmount,
126                 tokenDetailsHash
127             )
128             .ref(uint40(BridgeMessage.Types.Invalid));
129         bytes29 tokenId = BridgeMessage.formatTokenId(
130             localDomain,
131             tokenAddress
132         );
133         vm.expectRevert("!action");
134         BridgeMessage.formatMessage(tokenId, action);
135     }
136 
137     function test_formatMessageNotTokenIdType() public {
138         // I encode the correct type inside the data structure
139         // but set the wrong type in the view
140         // formatMessage() accepts only tokenId views of the type "TokenId"
141         bytes29 action = abi
142             .encodePacked(
143                 BridgeMessage.Types.Transfer,
144                 tokenReceiver,
145                 tokenAmount,
146                 tokenDetailsHash
147             )
148             .ref(uint40(BridgeMessage.Types.Transfer));
149         bytes29 tokenId = abi.encodePacked(localDomain, tokenAddress).ref(
150             uint40(BridgeMessage.Types.Invalid)
151         );
152         vm.expectRevert(
153             "Type assertion failed. Got 0x0000000000. Expected 0x0000000001"
154         );
155         BridgeMessage.formatMessage(tokenId, action);
156     }
157 
158     function test_formatMessageTransfer() public {
159         bytes29 action = abi
160             .encodePacked(
161                 BridgeMessage.Types.Transfer,
162                 tokenReceiver,
163                 tokenAmount,
164                 tokenDetailsHash
165             )
166             .ref(uint40(BridgeMessage.Types.Transfer));
167         bytes29 tokenId = BridgeMessage.formatTokenId(
168             localDomain,
169             tokenAddress
170         );
171         bytes29 message = BridgeMessage.formatMessage(tokenId, action).ref(
172             uint40(BridgeMessage.Types.Message)
173         );
174         uint256 actionLen = message.len() - TOKEN_ID_LEN;
175         uint40 messageType = uint8(message.indexUint(TOKEN_ID_LEN, 1));
176         bytes29 parsedAction = message.slice(
177             TOKEN_ID_LEN,
178             actionLen,
179             messageType
180         );
181         bytes29 parsedTokenId = message.slice(
182             0,
183             TOKEN_ID_LEN,
184             uint40(BridgeMessage.Types.TokenId)
185         );
186         assertEq(parsedAction.keccak(), action.keccak());
187         assertEq(parsedTokenId.keccak(), tokenId.keccak());
188     }
189 
190     function test_messageTypeReturnsCorrectType() public {
191         bytes memory emptyMessage = new bytes(100);
192         bytes29 emptyView = emptyMessage.ref(0); // Type 0
193         bytes29 viewUnderTest;
194         viewUnderTest = emptyView.castTo(uint40(BridgeMessage.Types.Invalid));
195         assertEq(
196             uint256(BridgeMessage.messageType(viewUnderTest)),
197             uint256(BridgeMessage.Types.Invalid)
198         );
199         viewUnderTest = emptyView.castTo(uint40(BridgeMessage.Types.TokenId));
200         assertEq(
201             uint256(BridgeMessage.messageType(viewUnderTest)),
202             uint256(BridgeMessage.Types.TokenId)
203         );
204         viewUnderTest = emptyView.castTo(uint40(BridgeMessage.Types.Message));
205         assertEq(
206             uint256(BridgeMessage.messageType(viewUnderTest)),
207             uint256(BridgeMessage.Types.Message)
208         );
209     }
210 
211     function test_isTypeDetectsCorrectType() public view {
212         bytes29 action;
213         action = abi
214             .encodePacked(
215                 BridgeMessage.Types.Message,
216                 tokenReceiver,
217                 tokenAmount,
218                 tokenDetailsHash
219             )
220             .ref(uint40(BridgeMessage.Types.Message));
221         assert(BridgeMessage.isType(action, BridgeMessage.Types.Message));
222         action = abi
223             .encodePacked(
224                 BridgeMessage.Types.TransferToHook,
225                 tokenReceiver,
226                 tokenAmount,
227                 tokenDetailsHash,
228                 tokenSender
229             )
230             .ref(uint40(BridgeMessage.Types.TransferToHook));
231         assert(
232             BridgeMessage.isType(action, BridgeMessage.Types.TransferToHook)
233         );
234         action = abi
235             .encodePacked(
236                 BridgeMessage.Types.ExtraData,
237                 tokenReceiver,
238                 tokenAmount,
239                 tokenDetailsHash
240             )
241             .ref(uint40(BridgeMessage.Types.ExtraData));
242         assert(BridgeMessage.isType(action, BridgeMessage.Types.ExtraData));
243     }
244 
245     function test_isTransferSucceeds() public {
246         bytes29 action;
247         action = abi
248             .encodePacked(
249                 BridgeMessage.Types.Transfer,
250                 tokenReceiver,
251                 tokenAmount,
252                 tokenDetailsHash
253             )
254             .ref(uint40(BridgeMessage.Types.Transfer));
255         assert(BridgeMessage.isTransfer(action));
256         action = abi
257             .encodePacked(
258                 BridgeMessage.Types.DeprecatedFastTransfer,
259                 tokenReceiver,
260                 tokenAmount,
261                 tokenDetailsHash
262             )
263             .ref(uint40(BridgeMessage.Types.DeprecatedFastTransfer));
264         assertFalse(BridgeMessage.isTransfer(action));
265     }
266 
267     function test_isTransferToHookSucceeds() public {
268         bytes29 action;
269         action = abi
270             .encodePacked(
271                 BridgeMessage.Types.TransferToHook,
272                 tokenReceiver,
273                 tokenAmount,
274                 tokenDetailsHash,
275                 tokenSender
276             )
277             .ref(uint40(BridgeMessage.Types.TransferToHook));
278         assert(BridgeMessage.isTransferToHook(action));
279         action = abi
280             .encodePacked(
281                 BridgeMessage.Types.Transfer,
282                 tokenReceiver,
283                 tokenAmount,
284                 tokenDetailsHash
285             )
286             .ref(uint40(BridgeMessage.Types.Transfer));
287         assertFalse(BridgeMessage.isTransferToHook(action));
288     }
289 
290     function test_formatTransferSucceeds() public {
291         bytes29 manualTransfer = abi
292             .encodePacked(
293                 BridgeMessage.Types.Transfer,
294                 tokenReceiver,
295                 tokenAmount,
296                 tokenDetailsHash
297             )
298             .ref(uint40(BridgeMessage.Types.Transfer));
299         bytes29 transfer = BridgeMessage.formatTransfer(
300             tokenReceiver,
301             tokenAmount,
302             tokenDetailsHash
303         );
304         assertEq(transfer.keccak(), manualTransfer.keccak());
305     }
306 
307     function test_formatTransferToHookSucceeds() public {
308         bytes memory extraData = bytes("extra data");
309         bytes29 manualTransfer = abi
310             .encodePacked(
311                 BridgeMessage.Types.TransferToHook,
312                 tokenReceiver,
313                 tokenAmount,
314                 tokenDetailsHash,
315                 tokenSender,
316                 extraData
317             )
318             .ref(uint40(BridgeMessage.Types.TransferToHook));
319         bytes29 transfer = BridgeMessage.formatTransferToHook(
320             tokenReceiver,
321             tokenAmount,
322             tokenDetailsHash,
323             tokenSender,
324             extraData
325         );
326         assertEq(transfer.keccak(), manualTransfer.keccak());
327     }
328 
329     function test_formatTokenIdFromDetails() public {
330         bytes29 formated = abi.encodePacked(localDomain, tokenAddress).ref(
331             uint40(BridgeMessage.Types.TokenId)
332         );
333         assertEq(
334             BridgeMessage.formatTokenId(localDomain, tokenAddress).keccak(),
335             formated.keccak()
336         );
337     }
338 
339     function test_formatTokenIdFromStruct() public {
340         BridgeMessage.TokenId memory tokenId = BridgeMessage.TokenId(
341             remoteDomain,
342             tokenAddress
343         );
344         bytes29 formated = abi.encodePacked(remoteDomain, tokenAddress).ref(
345             uint40(BridgeMessage.Types.TokenId)
346         );
347         assertEq(
348             BridgeMessage.formatTokenId(tokenId).keccak(),
349             formated.keccak()
350         );
351     }
352 
353     function test_getDetailsHashFromComponents() public {
354         bytes32 details = keccak256(
355             abi.encodePacked(
356                 bytes(tokenName).length,
357                 tokenName,
358                 bytes(tokenSymbol).length,
359                 tokenSymbol,
360                 tokenDecimals
361             )
362         );
363         assertEq(
364             BridgeMessage.getDetailsHash(tokenName, tokenSymbol, tokenDecimals),
365             details
366         );
367     }
368 
369     function test_getDomainfromTokenId() public {
370         bytes29 tokenId = BridgeMessage.formatTokenId(
371             remoteDomain,
372             tokenAddress
373         );
374         assertEq(uint256(BridgeMessage.domain(tokenId)), uint256(remoteDomain));
375     }
376 
377     function test_getIDfromTokenId() public {
378         bytes29 tokenId = BridgeMessage.formatTokenId(
379             remoteDomain,
380             tokenAddress
381         );
382         assertEq(BridgeMessage.id(tokenId), tokenAddress);
383     }
384 
385     function test_getEvmIdfromTokenId() public {
386         bytes29 tokenId = BridgeMessage.formatTokenId(
387             remoteDomain,
388             tokenAddress
389         );
390         assertEq(
391             BridgeMessage.evmId(tokenId),
392             0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
393         );
394     }
395 
396     function test_msgTypeCorrectType() public {
397         // We need to set the correct memview type to action so that the
398         // formatMessage function accepts the action
399         bytes29 action = abi
400             .encodePacked(
401                 BridgeMessage.Types.Transfer,
402                 tokenReceiver,
403                 tokenAmount,
404                 tokenDetailsHash
405             )
406             .ref(uint40(BridgeMessage.Types.Transfer));
407         bytes29 tokenId = BridgeMessage.formatTokenId(
408             localDomain,
409             tokenAddress
410         );
411         // We explicitly set the wrong memview type to the message, that is '0'
412         // to illustrate the the function under test extracts the type
413         // of the action from the actual abi.enocePacked() payload and not the
414         // the type metadata that lives with the memview view.
415         bytes29 message = BridgeMessage.formatMessage(tokenId, action).ref(0);
416         assertEq(
417             uint256(BridgeMessage.msgType(message)),
418             uint256(BridgeMessage.Types.Transfer)
419         );
420     }
421 
422     function test_actionTypeReturnsCorrectType() public {
423         bytes29 action;
424         action = abi
425             .encodePacked(
426                 BridgeMessage.Types.Transfer,
427                 tokenReceiver,
428                 tokenAmount,
429                 tokenDetailsHash
430             )
431             .ref(0);
432         assertEq(
433             uint256(BridgeMessage.actionType(action)),
434             uint256(BridgeMessage.Types.Transfer)
435         );
436 
437         action = abi
438             .encodePacked(
439                 BridgeMessage.Types.DeprecatedFastTransfer,
440                 tokenReceiver,
441                 tokenAmount,
442                 tokenDetailsHash
443             )
444             .ref(0);
445         assertEq(
446             uint256(BridgeMessage.actionType(action)),
447             uint256(BridgeMessage.Types.DeprecatedFastTransfer)
448         );
449 
450         action = abi
451             .encodePacked(
452                 BridgeMessage.Types.TransferToHook,
453                 tokenReceiver,
454                 tokenAmount,
455                 tokenDetailsHash,
456                 tokenSender
457             )
458             .ref(0);
459         assertEq(
460             uint256(BridgeMessage.actionType(action)),
461             uint256(BridgeMessage.Types.TransferToHook)
462         );
463     }
464 
465     function test_recipientReturnsCorrectBytes32() public {
466         bytes29 action;
467         action = abi
468             .encodePacked(
469                 BridgeMessage.Types.Transfer,
470                 tokenReceiver,
471                 tokenAmount,
472                 tokenDetailsHash
473             )
474             .ref(uint40(BridgeMessage.Types.Transfer));
475         assertEq(BridgeMessage.recipient(action), tokenReceiver);
476     }
477 
478     function test_evmRecipientReturnsCorrectAddress() public {
479         bytes29 action;
480         action = abi
481             .encodePacked(
482                 BridgeMessage.Types.Transfer,
483                 tokenReceiver,
484                 tokenAmount,
485                 tokenDetailsHash
486             )
487             .ref(uint40(BridgeMessage.Types.Transfer));
488         assertEq(
489             BridgeMessage.evmRecipient(action),
490             TypeCasts.bytes32ToAddress(tokenReceiver)
491         );
492     }
493 
494     function test_amntReturnsCorrectAmount() public {
495         bytes29 action;
496         action = abi
497             .encodePacked(
498                 BridgeMessage.Types.Transfer,
499                 tokenReceiver,
500                 tokenAmount,
501                 tokenDetailsHash
502             )
503             .ref(uint40(BridgeMessage.Types.Transfer));
504         assertEq(BridgeMessage.amnt(action), tokenAmount);
505     }
506 
507     function test_detailsHashReturnsCorrectHash() public {
508         bytes29 action;
509         action = abi
510             .encodePacked(
511                 BridgeMessage.Types.Transfer,
512                 tokenReceiver,
513                 tokenAmount,
514                 tokenDetailsHash
515             )
516             .ref(uint40(BridgeMessage.Types.Transfer));
517         assertEq(BridgeMessage.detailsHash(action), tokenDetailsHash);
518     }
519 
520     function test_tokenIdReturnsCorrectId() public {
521         bytes29 action = abi
522             .encodePacked(
523                 BridgeMessage.Types.Transfer,
524                 tokenReceiver,
525                 tokenAmount,
526                 tokenDetailsHash
527             )
528             .ref(uint40(BridgeMessage.Types.Transfer));
529         bytes29 tokenId = BridgeMessage.formatTokenId(
530             localDomain,
531             tokenAddress
532         );
533         bytes29 message = BridgeMessage.formatMessage(tokenId, action).ref(
534             uint40(BridgeMessage.Types.Message)
535         );
536         assertEq(BridgeMessage.tokenId(message).keccak(), tokenId.keccak());
537     }
538 
539     function test_evmHookReturnsCorrectAddress() public {
540         bytes29 action = abi
541             .encodePacked(
542                 BridgeMessage.Types.TransferToHook,
543                 tokenReceiver,
544                 tokenAmount,
545                 tokenDetailsHash,
546                 tokenSender,
547                 new bytes(100)
548             )
549             .ref(uint40(BridgeMessage.Types.TransferToHook));
550         assertEq(
551             BridgeMessage.evmHook(action),
552             TypeCasts.bytes32ToAddress(tokenReceiver)
553         );
554     }
555 
556     function test_senderReturnsCorrectBytes32() public {
557         bytes29 action = abi
558             .encodePacked(
559                 BridgeMessage.Types.TransferToHook,
560                 tokenReceiver,
561                 tokenAmount,
562                 tokenDetailsHash,
563                 tokenSender,
564                 new bytes(100)
565             )
566             .ref(uint40(BridgeMessage.Types.TransferToHook));
567         assertEq(BridgeMessage.sender(action), tokenSender);
568     }
569 
570     function test_extraDataReturnsCorrectData() public {
571         bytes memory manExtraData = bytes("Extra Data");
572         bytes29 action = abi
573             .encodePacked(
574                 BridgeMessage.Types.TransferToHook,
575                 tokenReceiver,
576                 tokenAmount,
577                 tokenDetailsHash,
578                 tokenSender,
579                 manExtraData
580             )
581             .ref(uint40(BridgeMessage.Types.TransferToHook));
582         assertEq(
583             BridgeMessage.extraData(action).keccak(),
584             manExtraData.ref(0).keccak()
585         );
586     }
587 
588     function test_actionReturnsCorrectAction() public view {
589         bytes29 action = abi
590             .encodePacked(
591                 BridgeMessage.Types.TransferToHook,
592                 tokenReceiver,
593                 tokenAmount,
594                 tokenDetailsHash,
595                 tokenSender
596             )
597             .ref(uint40(BridgeMessage.Types.TransferToHook));
598         assert(action.isType(BridgeMessage.Types.TransferToHook));
599     }
600 
601     function test_tryAsMessageReturnsTypedMessage() public view {
602         bytes29 action = abi
603             .encodePacked(
604                 BridgeMessage.Types.Transfer,
605                 tokenReceiver,
606                 tokenAmount,
607                 tokenDetailsHash
608             )
609             .ref(uint40(BridgeMessage.Types.Transfer));
610         bytes29 tokenId = BridgeMessage.formatTokenId(
611             localDomain,
612             tokenAddress
613         );
614         bytes29 message = BridgeMessage.formatMessage(tokenId, action).ref(0);
615         bytes29 typedMessage = BridgeMessage.tryAsMessage(message);
616         assert(typedMessage.isType(uint40(BridgeMessage.Types.Message)));
617     }
618 
619     function test_tryAsMessageReturnsNullForInvalidMessage() public pure {
620         bytes29 message = bytes("very smol message").ref(0);
621         bytes29 typedMessage = BridgeMessage.tryAsMessage(message);
622         assert(typedMessage.isNull());
623     }
624 
625     function test_mustBeMessageRevertsForInvalidMsgSmall() public {
626         bytes29 message = bytes("very smol message").ref(
627             uint40(BridgeMessage.Types.Transfer)
628         );
629         vm.expectRevert("Validity assertion failed");
630         message.mustBeMessage();
631     }
632 
633     function test_mustBeMessageValidMessage() public view {
634         bytes29 action = abi
635             .encodePacked(
636                 BridgeMessage.Types.Transfer,
637                 tokenReceiver,
638                 tokenAmount,
639                 tokenDetailsHash
640             )
641             .ref(uint40(BridgeMessage.Types.Transfer));
642         bytes29 tokenId = BridgeMessage.formatTokenId(
643             localDomain,
644             tokenAddress
645         );
646         bytes29 message = BridgeMessage.formatMessage(tokenId, action).ref(0);
647         message.mustBeMessage();
648     }
649 }
