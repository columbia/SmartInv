1 // // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { IHopBridge, IL2AmmWrapper, ISwap } from "../Interfaces/IHopBridge.sol";
5 import { ILiFi } from "../Interfaces/ILiFi.sol";
6 import { ERC20, SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
7 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
8 import { TransferrableOwnership } from "../Helpers/TransferrableOwnership.sol";
9 import { HopFacetOptimized } from "lifi/Facets/HopFacetOptimized.sol";
10 import { WETH } from "solmate/tokens/WETH.sol";
11 
12 /// @title Hop Facet (Optimized for Rollups)
13 /// @author LI.FI (https://li.fi)
14 /// @notice Provides functionality for bridging through Hop
15 /// @custom:version 1.0.6
16 contract HopFacetPacked is ILiFi, TransferrableOwnership {
17     using SafeTransferLib for ERC20;
18 
19     /// Storage ///
20 
21     address public immutable nativeBridge;
22     address public immutable nativeL2CanonicalToken;
23     address public immutable nativeHToken;
24     address public immutable nativeExchangeAddress;
25 
26     /// Errors ///
27 
28     error Invalid();
29 
30     /// Events ///
31 
32     event LiFiHopTransfer(bytes8 _transactionId);
33 
34     /// Constructor ///
35 
36     /// @notice Initialize the contract.
37     /// @param _owner The contract owner to approve tokens.
38     /// @param _wrapper The address of Hop L2_AmmWrapper for native asset.
39     constructor(
40         address _owner,
41         address _wrapper
42     ) TransferrableOwnership(_owner) {
43         bool wrapperIsSet = _wrapper != address(0);
44 
45         if (block.chainid == 1 && wrapperIsSet) {
46             revert Invalid();
47         }
48 
49         nativeL2CanonicalToken = wrapperIsSet
50             ? IL2AmmWrapper(_wrapper).l2CanonicalToken()
51             : address(0);
52         nativeHToken = wrapperIsSet
53             ? IL2AmmWrapper(_wrapper).hToken()
54             : address(0);
55         nativeExchangeAddress = wrapperIsSet
56             ? IL2AmmWrapper(_wrapper).exchangeAddress()
57             : address(0);
58         nativeBridge = wrapperIsSet
59             ? IL2AmmWrapper(_wrapper).bridge()
60             : address(0);
61     }
62 
63     /// External Methods ///
64 
65     /// @dev Only meant to be called outside of the context of the diamond
66     /// @notice Sets approval for the Hop Bridge to spend the specified token
67     /// @param bridges The Hop Bridges to approve
68     /// @param tokensToApprove The tokens to approve to approve to the Hop Bridges
69     function setApprovalForHopBridges(
70         address[] calldata bridges,
71         address[] calldata tokensToApprove
72     ) external onlyOwner {
73         uint256 numBridges = bridges.length;
74 
75         for (uint256 i; i < numBridges; i++) {
76             // Give Hop approval to bridge tokens
77             LibAsset.maxApproveERC20(
78                 IERC20(tokensToApprove[i]),
79                 address(bridges[i]),
80                 type(uint256).max
81             );
82         }
83     }
84 
85     /// @notice Bridges Native tokens via Hop Protocol from L2
86     /// No params, all data will be extracted from manually encoded callData
87     function startBridgeTokensViaHopL2NativePacked() external payable {
88         // first 4 bytes are function signature
89         // transactionId: bytes8(msg.data[4:12]),
90         // receiver: address(bytes20(msg.data[12:32])),
91         // destinationChainId: uint256(uint32(bytes4(msg.data[32:36]))),
92         // bonderFee: uint256(uint128(bytes16(msg.data[36:52]))),
93         // amountOutMin: uint256(uint128(bytes16(msg.data[52:68])))
94         // => total calldata length required: 68
95 
96         uint256 destinationChainId = uint256(uint32(bytes4(msg.data[32:36])));
97         uint256 amountOutMin = uint256(uint128(bytes16(msg.data[52:68])));
98         bool toL1 = destinationChainId == 1;
99 
100         // Wrap ETH
101         WETH(payable(nativeL2CanonicalToken)).deposit{ value: msg.value }();
102 
103         // Exchange WETH for hToken
104         uint256 swapAmount = ISwap(nativeExchangeAddress).swap(
105             0,
106             1,
107             msg.value,
108             amountOutMin,
109             block.timestamp
110         );
111 
112         // Bridge assets
113         // solhint-disable-next-line check-send-result
114         IHopBridge(nativeBridge).send(
115             destinationChainId,
116             address(bytes20(msg.data[12:32])), // receiver
117             swapAmount,
118             uint256(uint128(bytes16(msg.data[36:52]))), // bonderFee
119             toL1 ? 0 : amountOutMin,
120             toL1 ? 0 : block.timestamp + 7 * 24 * 60 * 60
121         );
122 
123         emit LiFiHopTransfer(
124             bytes8(msg.data[4:12]) // transactionId
125         );
126     }
127 
128     /// @notice Bridges Native tokens via Hop Protocol from L2
129     /// @param transactionId Custom transaction ID for tracking
130     /// @param receiver Receiving wallet address
131     /// @param destinationChainId Receiving chain
132     /// @param bonderFee Fees payed to hop bonder
133     /// @param amountOutMin Source swap minimal accepted amount
134     /// @param destinationAmountOutMin Destination swap minimal accepted amount
135     /// @param destinationDeadline Destination swap maximal time
136     /// @param hopBridge Address of the Hop L2_AmmWrapper
137     function startBridgeTokensViaHopL2NativeMin(
138         bytes8 transactionId,
139         address receiver,
140         uint256 destinationChainId,
141         uint256 bonderFee,
142         uint256 amountOutMin,
143         uint256 destinationAmountOutMin,
144         uint256 destinationDeadline,
145         address hopBridge
146     ) external payable {
147         // Bridge assets
148         IHopBridge(hopBridge).swapAndSend{ value: msg.value }(
149             destinationChainId,
150             receiver,
151             msg.value,
152             bonderFee,
153             amountOutMin,
154             block.timestamp,
155             destinationAmountOutMin,
156             destinationDeadline
157         );
158 
159         emit LiFiHopTransfer(transactionId);
160     }
161 
162     /// @notice Bridges Native tokens via Hop Protocol from L2
163     /// @param transactionId Custom transaction ID for tracking
164     /// @param receiver Receiving wallet address
165     /// @param destinationChainId Receiving chain
166     /// @param bonderFee Fees payed to hop bonder
167     /// @param amountOutMin Source swap minimal accepted amount
168     function encode_startBridgeTokensViaHopL2NativePacked(
169         bytes8 transactionId,
170         address receiver,
171         uint256 destinationChainId,
172         uint256 bonderFee,
173         uint256 amountOutMin
174     ) external pure returns (bytes memory) {
175         require(
176             destinationChainId <= type(uint32).max,
177             "destinationChainId value passed too big to fit in uint32"
178         );
179         require(
180             bonderFee <= type(uint128).max,
181             "bonderFee value passed too big to fit in uint128"
182         );
183         require(
184             amountOutMin <= type(uint128).max,
185             "amountOutMin value passed too big to fit in uint128"
186         );
187 
188         return
189             bytes.concat(
190                 HopFacetPacked.startBridgeTokensViaHopL2NativePacked.selector,
191                 bytes8(transactionId),
192                 bytes20(receiver),
193                 bytes4(uint32(destinationChainId)),
194                 bytes16(uint128(bonderFee)),
195                 bytes16(uint128(amountOutMin))
196             );
197     }
198 
199     /// @notice Decodes calldata for startBridgeTokensViaHopL2NativePacked
200     /// @param _data the calldata to decode
201     function decode_startBridgeTokensViaHopL2NativePacked(
202         bytes calldata _data
203     )
204         external
205         pure
206         returns (BridgeData memory, HopFacetOptimized.HopData memory)
207     {
208         require(
209             _data.length >= 68,
210             "data passed in is not the correct length"
211         );
212 
213         BridgeData memory bridgeData;
214         HopFacetOptimized.HopData memory hopData;
215 
216         bridgeData.transactionId = bytes32(bytes8(_data[4:12]));
217         bridgeData.receiver = address(bytes20(_data[12:32]));
218         bridgeData.destinationChainId = uint256(uint32(bytes4(_data[32:36])));
219         hopData.bonderFee = uint256(uint128(bytes16(_data[36:52])));
220         hopData.amountOutMin = uint256(uint128(bytes16(_data[52:68])));
221 
222         return (bridgeData, hopData);
223     }
224 
225     /// @notice Bridges ERC20 tokens via Hop Protocol from L2
226     /// No params, all data will be extracted from manually encoded callData
227     function startBridgeTokensViaHopL2ERC20Packed() external {
228         // first 4 bytes are function signature
229         // transactionId: bytes8(msg.data[4:12]),
230         // receiver: address(bytes20(msg.data[12:32])),
231         // destinationChainId: uint256(uint32(bytes4(msg.data[32:36]))),
232         // sendingAssetId: address(bytes20(msg.data[36:56])),
233         // amount: uint256(uint128(bytes16(msg.data[56:72]))),
234         // bonderFee: uint256(uint128(bytes16(msg.data[72:88]))),
235         // amountOutMin: uint256(uint128(bytes16(msg.data[88:104]))),
236         // destinationAmountOutMin: uint256(uint128(bytes16(msg.data[104:120]))),
237         // destinationDeadline: uint256(uint32(bytes4(msg.data[120:124]))),
238         // wrapper: address(bytes20(msg.data[124:144]))
239         // => total calldata length required: 144
240 
241         uint256 destinationChainId = uint256(uint32(bytes4(msg.data[32:36])));
242         uint256 amount = uint256(uint128(bytes16(msg.data[56:72])));
243         uint256 amountOutMin = uint256(uint128(bytes16(msg.data[88:104])));
244         bool toL1 = destinationChainId == 1;
245 
246         IL2AmmWrapper wrapper = IL2AmmWrapper(
247             address(bytes20(msg.data[124:144]))
248         );
249 
250         // Deposit assets
251         ERC20(address(bytes20(msg.data[36:56]))).safeTransferFrom(
252             msg.sender,
253             address(this),
254             amount
255         );
256 
257         // Exchange sending asset to hToken
258         uint256 swapAmount = ISwap(wrapper.exchangeAddress()).swap(
259             0,
260             1,
261             amount,
262             amountOutMin,
263             block.timestamp
264         );
265 
266         // Bridge assets
267         // solhint-disable-next-line check-send-result
268         IHopBridge(wrapper.bridge()).send(
269             destinationChainId,
270             address(bytes20(msg.data[12:32])),
271             swapAmount,
272             uint256(uint128(bytes16(msg.data[72:88]))),
273             toL1 ? 0 : uint256(uint128(bytes16(msg.data[104:120]))),
274             toL1 ? 0 : uint256(uint32(bytes4(msg.data[120:124])))
275         );
276 
277         emit LiFiHopTransfer(bytes8(msg.data[4:12]));
278     }
279 
280     /// @notice Bridges ERC20 tokens via Hop Protocol from L2
281     /// @param transactionId Custom transaction ID for tracking
282     /// @param receiver Receiving wallet address
283     /// @param destinationChainId Receiving chain
284     /// @param sendingAssetId Address of the source asset to bridge
285     /// @param minAmount Amount of the source asset to bridge
286     /// @param bonderFee Fees payed to hop bonder
287     /// @param amountOutMin Source swap minimal accepted amount
288     /// @param destinationAmountOutMin Destination swap minimal accepted amount
289     /// @param destinationDeadline Destination swap maximal time
290     /// @param hopBridge Address of the Hop L2_AmmWrapper
291     function startBridgeTokensViaHopL2ERC20Min(
292         bytes8 transactionId,
293         address receiver,
294         uint256 destinationChainId,
295         address sendingAssetId,
296         uint256 minAmount,
297         uint256 bonderFee,
298         uint256 amountOutMin,
299         uint256 destinationAmountOutMin,
300         uint256 destinationDeadline,
301         address hopBridge
302     ) external {
303         // Deposit assets
304         ERC20(sendingAssetId).safeTransferFrom(
305             msg.sender,
306             address(this),
307             minAmount
308         );
309 
310         // Bridge assets
311         IHopBridge(hopBridge).swapAndSend(
312             destinationChainId,
313             receiver,
314             minAmount,
315             bonderFee,
316             amountOutMin,
317             block.timestamp,
318             destinationAmountOutMin,
319             destinationDeadline
320         );
321 
322         emit LiFiHopTransfer(transactionId);
323     }
324 
325     /// @notice Bridges ERC20 tokens via Hop Protocol from L2
326     /// @param transactionId Custom transaction ID for tracking
327     /// @param receiver Receiving wallet address
328     /// @param destinationChainId Receiving chain
329     /// @param sendingAssetId Address of the source asset to bridge
330     /// @param minAmount Amount of the source asset to bridge
331     /// @param bonderFee Fees payed to hop bonder
332     /// @param amountOutMin Source swap minimal accepted amount
333     /// @param destinationAmountOutMin Destination swap minimal accepted amount
334     /// @param destinationDeadline Destination swap maximal time
335     /// @param wrapper Address of the Hop L2_AmmWrapper
336     function encode_startBridgeTokensViaHopL2ERC20Packed(
337         bytes32 transactionId,
338         address receiver,
339         uint256 destinationChainId,
340         address sendingAssetId,
341         uint256 minAmount,
342         uint256 bonderFee,
343         uint256 amountOutMin,
344         uint256 destinationAmountOutMin,
345         uint256 destinationDeadline,
346         address wrapper
347     ) external pure returns (bytes memory) {
348         require(
349             destinationChainId <= type(uint32).max,
350             "destinationChainId value passed too big to fit in uint32"
351         );
352         require(
353             minAmount <= type(uint128).max,
354             "amount value passed too big to fit in uint128"
355         );
356         require(
357             bonderFee <= type(uint128).max,
358             "bonderFee value passed too big to fit in uint128"
359         );
360         require(
361             amountOutMin <= type(uint128).max,
362             "amountOutMin value passed too big to fit in uint128"
363         );
364         require(
365             destinationAmountOutMin <= type(uint128).max,
366             "destinationAmountOutMin value passed too big to fit in uint128"
367         );
368         require(
369             destinationDeadline <= type(uint32).max,
370             "destinationDeadline value passed too big to fit in uint32"
371         );
372 
373         return
374             bytes.concat(
375                 HopFacetPacked.startBridgeTokensViaHopL2ERC20Packed.selector,
376                 bytes8(transactionId),
377                 bytes20(receiver),
378                 bytes4(uint32(destinationChainId)),
379                 bytes20(sendingAssetId),
380                 bytes16(uint128(minAmount)),
381                 bytes16(uint128(bonderFee)),
382                 bytes16(uint128(amountOutMin)),
383                 bytes16(uint128(destinationAmountOutMin)),
384                 bytes4(uint32(destinationDeadline)),
385                 bytes20(wrapper)
386             );
387     }
388 
389     /// @notice Decodes calldata for startBridgeTokensViaHopL2ERC20Packed
390     /// @param _data the calldata to decode
391     function decode_startBridgeTokensViaHopL2ERC20Packed(
392         bytes calldata _data
393     )
394         external
395         pure
396         returns (BridgeData memory, HopFacetOptimized.HopData memory)
397     {
398         require(
399             _data.length >= 144,
400             "data passed in is not the correct length"
401         );
402 
403         BridgeData memory bridgeData;
404         HopFacetOptimized.HopData memory hopData;
405 
406         bridgeData.transactionId = bytes32(bytes8(_data[4:12]));
407         bridgeData.receiver = address(bytes20(_data[12:32]));
408         bridgeData.destinationChainId = uint256(uint32(bytes4(_data[32:36])));
409         bridgeData.sendingAssetId = address(bytes20(_data[36:56]));
410         bridgeData.minAmount = uint256(uint128(bytes16(_data[56:72])));
411         hopData.bonderFee = uint256(uint128(bytes16(_data[72:88])));
412         hopData.amountOutMin = uint256(uint128(bytes16(_data[88:104])));
413         hopData.destinationAmountOutMin = uint256(
414             uint128(bytes16(_data[104:120]))
415         );
416         hopData.destinationDeadline = uint256(uint32(bytes4(_data[120:124])));
417         hopData.hopBridge = IHopBridge(address(bytes20(_data[124:144])));
418 
419         return (bridgeData, hopData);
420     }
421 
422     /// @notice Bridges Native tokens via Hop Protocol from L1
423     /// No params, all data will be extracted from manually encoded callData
424     function startBridgeTokensViaHopL1NativePacked() external payable {
425         // first 4 bytes are function signature
426         // transactionId: bytes8(msg.data[4:12]),
427         // receiver: address(bytes20(msg.data[12:32])),
428         // destinationChainId: uint256(uint32(bytes4(msg.data[32:36]))),
429         // destinationAmountOutMin: uint256(uint128(bytes16(msg.data[36:52]))),
430         // relayer: address(bytes20(msg.data[52:72])),
431         // relayerFee: uint256(uint128(bytes16(msg.data[72:88]))),
432         // hopBridge: address(bytes20(msg.data[88:108]))
433         // => total calldata length required: 108
434 
435         // Bridge assets
436         IHopBridge(address(bytes20(msg.data[88:108]))).sendToL2{
437             value: msg.value
438         }(
439             uint256(uint32(bytes4(msg.data[32:36]))),
440             address(bytes20(msg.data[12:32])),
441             msg.value,
442             uint256(uint128(bytes16(msg.data[36:52]))),
443             block.timestamp + 7 * 24 * 60 * 60,
444             address(bytes20(msg.data[52:72])),
445             uint256(uint128(bytes16(msg.data[72:88])))
446         );
447 
448         emit LiFiHopTransfer(bytes8(msg.data[4:12]));
449     }
450 
451     /// @notice Bridges Native tokens via Hop Protocol from L1
452     /// @param transactionId Custom transaction ID for tracking
453     /// @param receiver Receiving wallet address
454     /// @param destinationChainId Receiving chain
455     /// @param destinationAmountOutMin Destination swap minimal accepted amount
456     /// @param relayer needed for gas spikes
457     /// @param relayerFee needed for gas spikes
458     /// @param hopBridge Address of the Hop Bridge
459     function startBridgeTokensViaHopL1NativeMin(
460         bytes8 transactionId,
461         address receiver,
462         uint256 destinationChainId,
463         uint256 destinationAmountOutMin,
464         address relayer,
465         uint256 relayerFee,
466         address hopBridge
467     ) external payable {
468         // Bridge assets
469         IHopBridge(hopBridge).sendToL2{ value: msg.value }(
470             destinationChainId,
471             receiver,
472             msg.value,
473             destinationAmountOutMin,
474             block.timestamp + 7 * 24 * 60 * 60,
475             relayer,
476             relayerFee
477         );
478 
479         emit LiFiHopTransfer(transactionId);
480     }
481 
482     /// @notice Bridges Native tokens via Hop Protocol from L1
483     /// @param transactionId Custom transaction ID for tracking
484     /// @param receiver Receiving wallet address
485     /// @param destinationChainId Receiving chain
486     /// @param destinationAmountOutMin Destination swap minimal accepted amount
487     /// @param relayer needed for gas spikes
488     /// @param relayerFee needed for gas spikes
489     /// @param hopBridge Address of the Hop Bridge
490     function encode_startBridgeTokensViaHopL1NativePacked(
491         bytes8 transactionId,
492         address receiver,
493         uint256 destinationChainId,
494         uint256 destinationAmountOutMin,
495         address relayer,
496         uint256 relayerFee,
497         address hopBridge
498     ) external pure returns (bytes memory) {
499         require(
500             destinationChainId <= type(uint32).max,
501             "destinationChainId value passed too big to fit in uint32"
502         );
503         require(
504             destinationAmountOutMin <= type(uint128).max,
505             "destinationAmountOutMin value passed too big to fit in uint128"
506         );
507         require(
508             relayerFee <= type(uint128).max,
509             "relayerFee value passed too big to fit in uint128"
510         );
511 
512         return
513             bytes.concat(
514                 HopFacetPacked.startBridgeTokensViaHopL1NativePacked.selector,
515                 bytes8(transactionId),
516                 bytes20(receiver),
517                 bytes4(uint32(destinationChainId)),
518                 bytes16(uint128(destinationAmountOutMin)),
519                 bytes20(relayer),
520                 bytes16(uint128(relayerFee)),
521                 bytes20(hopBridge)
522             );
523     }
524 
525     /// @notice Decodes calldata for startBridgeTokensViaHopL1NativePacked
526     /// @param _data the calldata to decode
527     function decode_startBridgeTokensViaHopL1NativePacked(
528         bytes calldata _data
529     )
530         external
531         pure
532         returns (BridgeData memory, HopFacetOptimized.HopData memory)
533     {
534         require(
535             _data.length >= 108,
536             "data passed in is not the correct length"
537         );
538 
539         BridgeData memory bridgeData;
540         HopFacetOptimized.HopData memory hopData;
541 
542         bridgeData.transactionId = bytes32(bytes8(_data[4:12]));
543         bridgeData.receiver = address(bytes20(_data[12:32]));
544         bridgeData.destinationChainId = uint256(uint32(bytes4(_data[32:36])));
545         hopData.destinationAmountOutMin = uint256(
546             uint128(bytes16(_data[36:52]))
547         );
548         // relayer = address(bytes20(_data[52:72]));
549         // relayerFee = uint256(uint128(bytes16(_data[72:88])));
550         hopData.hopBridge = IHopBridge(address(bytes20(_data[88:108])));
551 
552         return (bridgeData, hopData);
553     }
554 
555     /// @notice Bridges Native tokens via Hop Protocol from L1
556     /// No params, all data will be extracted from manually encoded callData
557     function startBridgeTokensViaHopL1ERC20Packed() external payable {
558         // first 4 bytes are function signature
559         // transactionId: bytes8(msg.data[4:12]),
560         // receiver: address(bytes20(msg.data[12:32])),
561         // destinationChainId: uint256(uint32(bytes4(msg.data[32:36]))),
562         // sendingAssetId: address(bytes20(msg.data[36:56])),
563         // amount: uint256(uint128(bytes16(msg.data[56:72]))),
564         // destinationAmountOutMin: uint256(uint128(bytes16(msg.data[72:88]))),
565         // relayer: address(bytes20(msg.data[88:108])),
566         // relayerFee: uint256(uint128(bytes16(msg.data[108:124]))),
567         // hopBridge: address(bytes20(msg.data[124:144]))
568         // => total calldata length required: 144
569 
570         uint256 amount = uint256(uint128(bytes16(msg.data[56:72])));
571 
572         // Deposit assets
573         ERC20(address(bytes20(msg.data[36:56]))).safeTransferFrom(
574             msg.sender,
575             address(this),
576             amount
577         );
578 
579         // Bridge assets
580         IHopBridge(address(bytes20(msg.data[124:144]))).sendToL2(
581             uint256(uint32(bytes4(msg.data[32:36]))),
582             address(bytes20(msg.data[12:32])),
583             amount,
584             uint256(uint128(bytes16(msg.data[72:88]))),
585             block.timestamp + 7 * 24 * 60 * 60,
586             address(bytes20(msg.data[88:108])),
587             uint256(uint128(bytes16(msg.data[108:124])))
588         );
589 
590         emit LiFiHopTransfer(bytes8(msg.data[4:12]));
591     }
592 
593     /// @notice Bridges ERC20 tokens via Hop Protocol from L1
594     /// @param transactionId Custom transaction ID for tracking
595     /// @param receiver Receiving wallet address
596     /// @param destinationChainId Receiving chain
597     /// @param sendingAssetId Address of the source asset to bridge
598     /// @param minAmount Amount of the source asset to bridge
599     /// @param destinationAmountOutMin Destination swap minimal accepted amount
600     /// @param relayer needed for gas spikes
601     /// @param relayerFee needed for gas spikes
602     /// @param hopBridge Address of the Hop Bridge
603     function startBridgeTokensViaHopL1ERC20Min(
604         bytes8 transactionId,
605         address receiver,
606         uint256 destinationChainId,
607         address sendingAssetId,
608         uint256 minAmount,
609         uint256 destinationAmountOutMin,
610         address relayer,
611         uint256 relayerFee,
612         address hopBridge
613     ) external {
614         // Deposit assets
615         ERC20(sendingAssetId).safeTransferFrom(
616             msg.sender,
617             address(this),
618             minAmount
619         );
620 
621         // Bridge assets
622         IHopBridge(hopBridge).sendToL2(
623             destinationChainId,
624             receiver,
625             minAmount,
626             destinationAmountOutMin,
627             block.timestamp + 7 * 24 * 60 * 60,
628             relayer,
629             relayerFee
630         );
631 
632         emit LiFiHopTransfer(transactionId);
633     }
634 
635     /// @notice Bridges ERC20 tokens via Hop Protocol from L1
636     /// @param transactionId Custom transaction ID for tracking
637     /// @param receiver Receiving wallet address
638     /// @param destinationChainId Receiving chain
639     /// @param sendingAssetId Address of the source asset to bridge
640     /// @param minAmount Amount of the source asset to bridge
641     /// @param destinationAmountOutMin Destination swap minimal accepted amount
642     /// @param relayer needed for gas spikes
643     /// @param relayerFee needed for gas spikes
644     /// @param hopBridge Address of the Hop Bridge
645     function encode_startBridgeTokensViaHopL1ERC20Packed(
646         bytes8 transactionId,
647         address receiver,
648         uint256 destinationChainId,
649         address sendingAssetId,
650         uint256 minAmount,
651         uint256 destinationAmountOutMin,
652         address relayer,
653         uint256 relayerFee,
654         address hopBridge
655     ) external pure returns (bytes memory) {
656         require(
657             destinationChainId <= type(uint32).max,
658             "destinationChainId value passed too big to fit in uint32"
659         );
660         require(
661             minAmount <= type(uint128).max,
662             "amount value passed too big to fit in uint128"
663         );
664         require(
665             destinationAmountOutMin <= type(uint128).max,
666             "destinationAmountOutMin value passed too big to fit in uint128"
667         );
668         require(
669             relayerFee <= type(uint128).max,
670             "relayerFee value passed too big to fit in uint128"
671         );
672 
673         return
674             bytes.concat(
675                 HopFacetPacked.startBridgeTokensViaHopL1ERC20Packed.selector,
676                 bytes8(transactionId),
677                 bytes20(receiver),
678                 bytes4(uint32(destinationChainId)),
679                 bytes20(sendingAssetId),
680                 bytes16(uint128(minAmount)),
681                 bytes16(uint128(destinationAmountOutMin)),
682                 bytes20(relayer),
683                 bytes16(uint128(relayerFee)),
684                 bytes20(hopBridge)
685             );
686     }
687 
688     /// @notice Decodes calldata for startBridgeTokensViaHopL1ERC20Packed
689     /// @param _data the calldata to decode
690     function decode_startBridgeTokensViaHopL1ERC20Packed(
691         bytes calldata _data
692     )
693         external
694         pure
695         returns (BridgeData memory, HopFacetOptimized.HopData memory)
696     {
697         require(
698             _data.length >= 144,
699             "data passed in is not the correct length"
700         );
701 
702         BridgeData memory bridgeData;
703         HopFacetOptimized.HopData memory hopData;
704 
705         bridgeData.transactionId = bytes32(bytes8(_data[4:12]));
706         bridgeData.receiver = address(bytes20(_data[12:32]));
707         bridgeData.destinationChainId = uint256(uint32(bytes4(_data[32:36])));
708         bridgeData.sendingAssetId = address(bytes20(_data[36:56]));
709         bridgeData.minAmount = uint256(uint128(bytes16(_data[56:72])));
710         hopData.destinationAmountOutMin = uint256(
711             uint128(bytes16(_data[72:88]))
712         );
713         // relayer = address(bytes20(_data[88:108]));
714         // relayerFee = uint256(uint128(bytes16(_data[108:124])));
715         hopData.hopBridge = IHopBridge(address(bytes20(_data[124:144])));
716 
717         return (bridgeData, hopData);
718     }
719 }
