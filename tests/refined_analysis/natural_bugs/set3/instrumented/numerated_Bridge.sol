1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
8 import "@openzeppelin/contracts/proxy/Clones.sol";
9 import "synthetix/contracts/interfaces/IAddressResolver.sol";
10 import "synthetix/contracts/interfaces/IExchanger.sol";
11 import "synthetix/contracts/interfaces/IExchangeRates.sol";
12 import "../interfaces/ISwap.sol";
13 import "./SynthSwapper.sol";
14 
15 contract Proxy {
16     address public target;
17 }
18 
19 contract Target {
20     address public proxy;
21 }
22 
23 /**
24  * @title Bridge
25  * @notice This contract is responsible for cross-asset swaps using the Synthetix protocol as the bridging exchange.
26  * There are three types of supported cross-asset swaps, tokenToSynth, synthToToken, and tokenToToken.
27  *
28  * 1) tokenToSynth
29  * Swaps a supported token in a saddle pool to any synthetic asset (e.g. tBTC -> sAAVE).
30  *
31  * 2) synthToToken
32  * Swaps any synthetic asset to a suported token in a saddle pool (e.g. sDEFI -> USDC).
33  *
34  * 3) tokenToToken
35  * Swaps a supported token in a saddle pool to one in another pool (e.g. renBTC -> DAI).
36  *
37  * Due to the settlement periods of synthetic assets, the users must wait until the trades can be completed.
38  * Users will receive an ERC721 token that represents pending cross-asset swap. Once the waiting period is over,
39  * the trades can be settled and completed by calling the `completeToSynth` or the `completeToToken` function.
40  * In the cases of pending `synthToToken` or `tokenToToken` swaps, the owners of the pending swaps can also choose
41  * to withdraw the bridging synthetic assets instead of completing the swap.
42  */
43 contract Bridge is ERC721 {
44     using SafeMath for uint256;
45     using SafeERC20 for IERC20;
46 
47     event SynthIndex(
48         address indexed swap,
49         uint8 synthIndex,
50         bytes32 currencyKey,
51         address synthAddress
52     );
53     event TokenToSynth(
54         address indexed requester,
55         uint256 indexed itemId,
56         ISwap swapPool,
57         uint8 tokenFromIndex,
58         uint256 tokenFromInAmount,
59         bytes32 synthToKey
60     );
61     event SynthToToken(
62         address indexed requester,
63         uint256 indexed itemId,
64         ISwap swapPool,
65         bytes32 synthFromKey,
66         uint256 synthFromInAmount,
67         uint8 tokenToIndex
68     );
69     event TokenToToken(
70         address indexed requester,
71         uint256 indexed itemId,
72         ISwap[2] swapPools,
73         uint8 tokenFromIndex,
74         uint256 tokenFromAmount,
75         uint8 tokenToIndex
76     );
77     event Settle(
78         address indexed requester,
79         uint256 indexed itemId,
80         IERC20 settleFrom,
81         uint256 settleFromAmount,
82         IERC20 settleTo,
83         uint256 settleToAmount,
84         bool isFinal
85     );
86     event Withdraw(
87         address indexed requester,
88         uint256 indexed itemId,
89         IERC20 synth,
90         uint256 synthAmount,
91         bool isFinal
92     );
93 
94     // The addresses for all Synthetix contracts can be found in the below URL.
95     // https://docs.synthetix.io/addresses/#mainnet-contracts
96     //
97     // Since the Synthetix protocol is upgradable, we must use the proxy pairs of each contract such that
98     // the composability is not broken after the protocol upgrade.
99     //
100     // SYNTHETIX_RESOLVER points to `ReadProxyAddressResolver` (0x4E3b31eB0E5CB73641EE1E65E7dCEFe520bA3ef2).
101     // This contract is a read proxy of `AddressResolver` which is responsible for storing the addresses of the contracts
102     // used by the Synthetix protocol.
103     IAddressResolver public constant SYNTHETIX_RESOLVER =
104         IAddressResolver(0x4E3b31eB0E5CB73641EE1E65E7dCEFe520bA3ef2);
105 
106     // EXCHANGER points to `Exchanger`. There is no proxy pair for this contract so we need to update this variable
107     // when the protocol is upgraded. This contract is used to settle synths held by SynthSwapper.
108     IExchanger public exchanger;
109 
110     // CONSTANTS
111 
112     // Available types of cross-asset swaps
113     enum PendingSwapType {
114         Null,
115         TokenToSynth,
116         SynthToToken,
117         TokenToToken
118     }
119 
120     uint256 public constant MAX_UINT256 = 2**256 - 1;
121     uint8 public constant MAX_UINT8 = 2**8 - 1;
122     bytes32 public constant EXCHANGE_RATES_NAME = "ExchangeRates";
123     bytes32 public constant EXCHANGER_NAME = "Exchanger";
124     address public immutable SYNTH_SWAPPER_MASTER;
125 
126     // MAPPINGS FOR STORING PENDING SETTLEMENTS
127     // The below two mappings never share the same key.
128     mapping(uint256 => PendingToSynthSwap) public pendingToSynthSwaps;
129     mapping(uint256 => PendingToTokenSwap) public pendingToTokenSwaps;
130     uint256 public pendingSwapsLength;
131     mapping(uint256 => PendingSwapType) private pendingSwapType;
132 
133     // MAPPINGS FOR STORING SYNTH INFO
134     mapping(address => SwapContractInfo) private swapContracts;
135 
136     // Structs holding information about pending settlements
137     struct PendingToSynthSwap {
138         SynthSwapper swapper;
139         bytes32 synthKey;
140     }
141 
142     struct PendingToTokenSwap {
143         SynthSwapper swapper;
144         bytes32 synthKey;
145         ISwap swap;
146         uint8 tokenToIndex;
147     }
148 
149     struct SwapContractInfo {
150         // index of the supported synth + 1
151         uint8 synthIndexPlusOne;
152         // address of the supported synth
153         address synthAddress;
154         // bytes32 key of the supported synth
155         bytes32 synthKey;
156         // array of tokens supported by the contract
157         IERC20[] tokens;
158     }
159 
160     /**
161      * @notice Deploys this contract and initializes the master version of the SynthSwapper contract. The address to
162      * the Synthetix protocol's Exchanger contract is also set on deployment.
163      */
164     constructor(address synthSwapperAddress)
165         public
166         ERC721("Saddle Cross-Asset Swap", "SaddleSynthSwap")
167     {
168         SYNTH_SWAPPER_MASTER = synthSwapperAddress;
169         updateExchangerCache();
170     }
171 
172     /**
173      * @notice Returns the address of the proxy contract targeting the synthetic asset with the given `synthKey`.
174      * @param synthKey the currency key of the synth
175      * @return address of the proxy contract
176      */
177     function getProxyAddressFromTargetSynthKey(bytes32 synthKey)
178         public
179         view
180         returns (IERC20)
181     {
182         return IERC20(Target(SYNTHETIX_RESOLVER.getSynth(synthKey)).proxy());
183     }
184 
185     /**
186      * @notice Returns various information of a pending swap represented by the given `itemId`. Information includes
187      * the type of the pending swap, the number of seconds left until it can be settled, the address and the balance
188      * of the synth this swap currently holds, and the address of the destination token.
189      * @param itemId ID of the pending swap
190      * @return swapType the type of the pending virtual swap,
191      * secsLeft number of seconds left until this swap can be settled,
192      * synth address of the synth this swap uses,
193      * synthBalance amount of the synth this swap holds,
194      * tokenTo the address of the destination token
195      */
196     function getPendingSwapInfo(uint256 itemId)
197         external
198         view
199         returns (
200             PendingSwapType swapType,
201             uint256 secsLeft,
202             address synth,
203             uint256 synthBalance,
204             address tokenTo
205         )
206     {
207         swapType = pendingSwapType[itemId];
208         require(swapType != PendingSwapType.Null, "invalid itemId");
209 
210         SynthSwapper synthSwapper;
211         bytes32 synthKey;
212 
213         if (swapType == PendingSwapType.TokenToSynth) {
214             synthSwapper = pendingToSynthSwaps[itemId].swapper;
215             synthKey = pendingToSynthSwaps[itemId].synthKey;
216             synth = address(getProxyAddressFromTargetSynthKey(synthKey));
217             tokenTo = synth;
218         } else {
219             PendingToTokenSwap memory pendingToTokenSwap = pendingToTokenSwaps[
220                 itemId
221             ];
222             synthSwapper = pendingToTokenSwap.swapper;
223             synthKey = pendingToTokenSwap.synthKey;
224             synth = address(getProxyAddressFromTargetSynthKey(synthKey));
225             tokenTo = address(
226                 swapContracts[address(pendingToTokenSwap.swap)].tokens[
227                     pendingToTokenSwap.tokenToIndex
228                 ]
229             );
230         }
231 
232         secsLeft = exchanger.maxSecsLeftInWaitingPeriod(
233             address(synthSwapper),
234             synthKey
235         );
236         synthBalance = IERC20(synth).balanceOf(address(synthSwapper));
237     }
238 
239     // Settles the synth only.
240     function _settle(address synthOwner, bytes32 synthKey) internal {
241         // Settle synth
242         exchanger.settle(synthOwner, synthKey);
243     }
244 
245     /**
246      * @notice Settles and withdraws the synthetic asset without swapping it to a token in a Saddle pool. Only the owner
247      * of the ERC721 token of `itemId` can call this function. Reverts if the given `itemId` does not represent a
248      * `synthToToken` or a `tokenToToken` swap.
249      * @param itemId ID of the pending swap
250      * @param amount the amount of the synth to withdraw
251      */
252     function withdraw(uint256 itemId, uint256 amount) external {
253         address nftOwner = ownerOf(itemId);
254         require(nftOwner == msg.sender, "not owner");
255         require(
256             pendingSwapType[itemId] > PendingSwapType.TokenToSynth,
257             "invalid itemId"
258         );
259         PendingToTokenSwap memory pendingToTokenSwap = pendingToTokenSwaps[
260             itemId
261         ];
262         _settle(
263             address(pendingToTokenSwap.swapper),
264             pendingToTokenSwap.synthKey
265         );
266 
267         IERC20 synth = getProxyAddressFromTargetSynthKey(
268             pendingToTokenSwap.synthKey
269         );
270         bool shouldDestroy;
271 
272         if (amount >= synth.balanceOf(address(pendingToTokenSwap.swapper))) {
273             _burn(itemId);
274             delete pendingToTokenSwaps[itemId];
275             delete pendingSwapType[itemId];
276             shouldDestroy = true;
277         }
278 
279         pendingToTokenSwap.swapper.withdraw(
280             synth,
281             nftOwner,
282             amount,
283             shouldDestroy
284         );
285         emit Withdraw(msg.sender, itemId, synth, amount, shouldDestroy);
286     }
287 
288     /**
289      * @notice Completes the pending `tokenToSynth` swap by settling and withdrawing the synthetic asset.
290      * Reverts if the given `itemId` does not represent a `tokenToSynth` swap.
291      * @param itemId ERC721 token ID representing a pending `tokenToSynth` swap
292      */
293     function completeToSynth(uint256 itemId) external {
294         address nftOwner = ownerOf(itemId);
295         require(nftOwner == msg.sender, "not owner");
296         require(
297             pendingSwapType[itemId] == PendingSwapType.TokenToSynth,
298             "invalid itemId"
299         );
300 
301         PendingToSynthSwap memory pendingToSynthSwap = pendingToSynthSwaps[
302             itemId
303         ];
304         _settle(
305             address(pendingToSynthSwap.swapper),
306             pendingToSynthSwap.synthKey
307         );
308 
309         IERC20 synth = getProxyAddressFromTargetSynthKey(
310             pendingToSynthSwap.synthKey
311         );
312 
313         // Burn the corresponding ERC721 token and delete storage for gas
314         _burn(itemId);
315         delete pendingToTokenSwaps[itemId];
316         delete pendingSwapType[itemId];
317 
318         // After settlement, withdraw the synth and send it to the recipient
319         uint256 synthBalance = synth.balanceOf(
320             address(pendingToSynthSwap.swapper)
321         );
322         pendingToSynthSwap.swapper.withdraw(
323             synth,
324             nftOwner,
325             synthBalance,
326             true
327         );
328 
329         emit Settle(
330             msg.sender,
331             itemId,
332             synth,
333             synthBalance,
334             synth,
335             synthBalance,
336             true
337         );
338     }
339 
340     /**
341      * @notice Calculates the expected amount of the token to receive on calling `completeToToken()` with
342      * the given `swapAmount`.
343      * @param itemId ERC721 token ID representing a pending `SynthToToken` or `TokenToToken` swap
344      * @param swapAmount the amount of bridging synth to swap from
345      * @return expected amount of the token the user will receive
346      */
347     function calcCompleteToToken(uint256 itemId, uint256 swapAmount)
348         external
349         view
350         returns (uint256)
351     {
352         require(
353             pendingSwapType[itemId] > PendingSwapType.TokenToSynth,
354             "invalid itemId"
355         );
356 
357         PendingToTokenSwap memory pendingToTokenSwap = pendingToTokenSwaps[
358             itemId
359         ];
360         return
361             pendingToTokenSwap.swap.calculateSwap(
362                 getSynthIndex(pendingToTokenSwap.swap),
363                 pendingToTokenSwap.tokenToIndex,
364                 swapAmount
365             );
366     }
367 
368     /**
369      * @notice Completes the pending `SynthToToken` or `TokenToToken` swap by settling the bridging synth and swapping
370      * it to the desired token. Only the owners of the pending swaps can call this function.
371      * @param itemId ERC721 token ID representing a pending `SynthToToken` or `TokenToToken` swap
372      * @param swapAmount the amount of bridging synth to swap from
373      * @param minAmount the minimum amount of the token to receive - reverts if this amount is not reached
374      * @param deadline the timestamp representing the deadline for this transaction - reverts if deadline is not met
375      */
376     function completeToToken(
377         uint256 itemId,
378         uint256 swapAmount,
379         uint256 minAmount,
380         uint256 deadline
381     ) external {
382         require(swapAmount != 0, "amount must be greater than 0");
383         address nftOwner = ownerOf(itemId);
384         require(msg.sender == nftOwner, "must own itemId");
385         require(
386             pendingSwapType[itemId] > PendingSwapType.TokenToSynth,
387             "invalid itemId"
388         );
389 
390         PendingToTokenSwap memory pendingToTokenSwap = pendingToTokenSwaps[
391             itemId
392         ];
393 
394         _settle(
395             address(pendingToTokenSwap.swapper),
396             pendingToTokenSwap.synthKey
397         );
398         IERC20 synth = getProxyAddressFromTargetSynthKey(
399             pendingToTokenSwap.synthKey
400         );
401         bool shouldDestroyClone;
402 
403         if (
404             swapAmount >= synth.balanceOf(address(pendingToTokenSwap.swapper))
405         ) {
406             _burn(itemId);
407             delete pendingToTokenSwaps[itemId];
408             delete pendingSwapType[itemId];
409             shouldDestroyClone = true;
410         }
411 
412         // Try swapping the synth to the desired token via the stored swap pool contract
413         // If the external call succeeds, send the token to the owner of token with itemId.
414         (IERC20 tokenTo, uint256 amountOut) = pendingToTokenSwap
415             .swapper
416             .swapSynthToToken(
417                 pendingToTokenSwap.swap,
418                 synth,
419                 getSynthIndex(pendingToTokenSwap.swap),
420                 pendingToTokenSwap.tokenToIndex,
421                 swapAmount,
422                 minAmount,
423                 deadline,
424                 nftOwner
425             );
426 
427         if (shouldDestroyClone) {
428             pendingToTokenSwap.swapper.destroy();
429         }
430 
431         emit Settle(
432             msg.sender,
433             itemId,
434             synth,
435             swapAmount,
436             tokenTo,
437             amountOut,
438             shouldDestroyClone
439         );
440     }
441 
442     // Add the given pending synth settlement struct to the list
443     function _addToPendingSynthSwapList(
444         PendingToSynthSwap memory pendingToSynthSwap
445     ) internal returns (uint256) {
446         require(
447             pendingSwapsLength < MAX_UINT256,
448             "pendingSwapsLength reached max size"
449         );
450         pendingToSynthSwaps[pendingSwapsLength] = pendingToSynthSwap;
451         return pendingSwapsLength++;
452     }
453 
454     // Add the given pending synth to token settlement struct to the list
455     function _addToPendingSynthToTokenSwapList(
456         PendingToTokenSwap memory pendingToTokenSwap
457     ) internal returns (uint256) {
458         require(
459             pendingSwapsLength < MAX_UINT256,
460             "pendingSwapsLength reached max size"
461         );
462         pendingToTokenSwaps[pendingSwapsLength] = pendingToTokenSwap;
463         return pendingSwapsLength++;
464     }
465 
466     /**
467      * @notice Calculates the expected amount of the desired synthetic asset the caller will receive after completing
468      * a `TokenToSynth` swap with the given parameters. This calculation does not consider the settlement periods.
469      * @param swap the address of a Saddle pool to use to swap the given token to a bridging synth
470      * @param tokenFromIndex the index of the token to swap from
471      * @param synthOutKey the currency key of the desired synthetic asset
472      * @param tokenInAmount the amount of the token to swap form
473      * @return the expected amount of the desired synth
474      */
475     function calcTokenToSynth(
476         ISwap swap,
477         uint8 tokenFromIndex,
478         bytes32 synthOutKey,
479         uint256 tokenInAmount
480     ) external view returns (uint256) {
481         uint8 mediumSynthIndex = getSynthIndex(swap);
482         uint256 expectedMediumSynthAmount = swap.calculateSwap(
483             tokenFromIndex,
484             mediumSynthIndex,
485             tokenInAmount
486         );
487         bytes32 mediumSynthKey = getSynthKey(swap);
488 
489         IExchangeRates exchangeRates = IExchangeRates(
490             SYNTHETIX_RESOLVER.getAddress(EXCHANGE_RATES_NAME)
491         );
492         return
493             exchangeRates.effectiveValue(
494                 mediumSynthKey,
495                 expectedMediumSynthAmount,
496                 synthOutKey
497             );
498     }
499 
500     /**
501      * @notice Initiates a cross-asset swap from a token supported in the `swap` pool to any synthetic asset.
502      * The caller will receive an ERC721 token representing their ownership of the pending cross-asset swap.
503      * @param swap the address of a Saddle pool to use to swap the given token to a bridging synth
504      * @param tokenFromIndex the index of the token to swap from
505      * @param synthOutKey the currency key of the desired synthetic asset
506      * @param tokenInAmount the amount of the token to swap form
507      * @param minAmount the amount of the token to swap form
508      * @return ID of the ERC721 token sent to the caller
509      */
510     function tokenToSynth(
511         ISwap swap,
512         uint8 tokenFromIndex,
513         bytes32 synthOutKey,
514         uint256 tokenInAmount,
515         uint256 minAmount
516     ) external returns (uint256) {
517         require(tokenInAmount != 0, "amount must be greater than 0");
518         // Create a SynthSwapper clone
519         SynthSwapper synthSwapper = SynthSwapper(
520             Clones.clone(SYNTH_SWAPPER_MASTER)
521         );
522         synthSwapper.initialize();
523 
524         // Add the synthswapper to the pending settlement list
525         uint256 itemId = _addToPendingSynthSwapList(
526             PendingToSynthSwap(synthSwapper, synthOutKey)
527         );
528         pendingSwapType[itemId] = PendingSwapType.TokenToSynth;
529 
530         // Mint an ERC721 token that represents ownership of the pending synth settlement to msg.sender
531         _mint(msg.sender, itemId);
532 
533         // Transfer token from msg.sender
534         IERC20 tokenFrom = swapContracts[address(swap)].tokens[tokenFromIndex]; // revert when token not found in swap pool
535         tokenFrom.safeTransferFrom(msg.sender, address(this), tokenInAmount);
536         tokenInAmount = tokenFrom.balanceOf(address(this));
537 
538         // Swap the synth to the medium synth
539         uint256 mediumSynthAmount = swap.swap(
540             tokenFromIndex,
541             getSynthIndex(swap),
542             tokenInAmount,
543             0,
544             block.timestamp
545         );
546 
547         // Swap synths via Synthetix network
548         IERC20(getSynthAddress(swap)).safeTransfer(
549             address(synthSwapper),
550             mediumSynthAmount
551         );
552         require(
553             synthSwapper.swapSynth(
554                 getSynthKey(swap),
555                 mediumSynthAmount,
556                 synthOutKey
557             ) >= minAmount,
558             "minAmount not reached"
559         );
560 
561         // Emit TokenToSynth event with relevant data
562         emit TokenToSynth(
563             msg.sender,
564             itemId,
565             swap,
566             tokenFromIndex,
567             tokenInAmount,
568             synthOutKey
569         );
570 
571         return (itemId);
572     }
573 
574     /**
575      * @notice Calculates the expected amount of the desired token the caller will receive after completing
576      * a `SynthToToken` swap with the given parameters. This calculation does not consider the settlement periods or
577      * any potential changes of the `swap` pool composition.
578      * @param swap the address of a Saddle pool to use to swap the given token to a bridging synth
579      * @param synthInKey the currency key of the synth to swap from
580      * @param tokenToIndex the index of the token to swap to
581      * @param synthInAmount the amount of the synth to swap form
582      * @return the expected amount of the bridging synth and the expected amount of the desired token
583      */
584     function calcSynthToToken(
585         ISwap swap,
586         bytes32 synthInKey,
587         uint8 tokenToIndex,
588         uint256 synthInAmount
589     ) external view returns (uint256, uint256) {
590         IExchangeRates exchangeRates = IExchangeRates(
591             SYNTHETIX_RESOLVER.getAddress(EXCHANGE_RATES_NAME)
592         );
593 
594         uint8 mediumSynthIndex = getSynthIndex(swap);
595         bytes32 mediumSynthKey = getSynthKey(swap);
596         require(synthInKey != mediumSynthKey, "use normal swap");
597 
598         uint256 expectedMediumSynthAmount = exchangeRates.effectiveValue(
599             synthInKey,
600             synthInAmount,
601             mediumSynthKey
602         );
603 
604         return (
605             expectedMediumSynthAmount,
606             swap.calculateSwap(
607                 mediumSynthIndex,
608                 tokenToIndex,
609                 expectedMediumSynthAmount
610             )
611         );
612     }
613 
614     /**
615      * @notice Initiates a cross-asset swap from a synthetic asset to a supported token. The caller will receive
616      * an ERC721 token representing their ownership of the pending cross-asset swap.
617      * @param swap the address of a Saddle pool to use to swap the given token to a bridging synth
618      * @param synthInKey the currency key of the synth to swap from
619      * @param tokenToIndex the index of the token to swap to
620      * @param synthInAmount the amount of the synth to swap form
621      * @param minMediumSynthAmount the minimum amount of the bridging synth at pre-settlement stage
622      * @return the ID of the ERC721 token sent to the caller
623      */
624     function synthToToken(
625         ISwap swap,
626         bytes32 synthInKey,
627         uint8 tokenToIndex,
628         uint256 synthInAmount,
629         uint256 minMediumSynthAmount
630     ) external returns (uint256) {
631         require(synthInAmount != 0, "amount must be greater than 0");
632         bytes32 mediumSynthKey = getSynthKey(swap);
633         require(
634             synthInKey != mediumSynthKey,
635             "synth is supported via normal swap"
636         );
637 
638         // Create a SynthSwapper clone
639         SynthSwapper synthSwapper = SynthSwapper(
640             Clones.clone(SYNTH_SWAPPER_MASTER)
641         );
642         synthSwapper.initialize();
643 
644         // Add the synthswapper to the pending synth to token settlement list
645         uint256 itemId = _addToPendingSynthToTokenSwapList(
646             PendingToTokenSwap(synthSwapper, mediumSynthKey, swap, tokenToIndex)
647         );
648         pendingSwapType[itemId] = PendingSwapType.SynthToToken;
649 
650         // Mint an ERC721 token that represents ownership of the pending synth to token settlement to msg.sender
651         _mint(msg.sender, itemId);
652 
653         // Receive synth from the user and swap it to another synth
654         IERC20 synthFrom = getProxyAddressFromTargetSynthKey(synthInKey);
655         synthFrom.safeTransferFrom(msg.sender, address(this), synthInAmount);
656         synthFrom.safeTransfer(address(synthSwapper), synthInAmount);
657         require(
658             synthSwapper.swapSynth(synthInKey, synthInAmount, mediumSynthKey) >=
659                 minMediumSynthAmount,
660             "minMediumSynthAmount not reached"
661         );
662 
663         // Emit SynthToToken event with relevant data
664         emit SynthToToken(
665             msg.sender,
666             itemId,
667             swap,
668             synthInKey,
669             synthInAmount,
670             tokenToIndex
671         );
672 
673         return (itemId);
674     }
675 
676     /**
677      * @notice Calculates the expected amount of the desired token the caller will receive after completing
678      * a `TokenToToken` swap with the given parameters. This calculation does not consider the settlement periods or
679      * any potential changes of the pool compositions.
680      * @param swaps the addresses of the two Saddle pools used to do the cross-asset swap
681      * @param tokenFromIndex the index of the token in the first `swaps` pool to swap from
682      * @param tokenToIndex the index of the token in the second `swaps` pool to swap to
683      * @param tokenFromAmount the amount of the token to swap from
684      * @return the expected amount of bridging synth at pre-settlement stage and the expected amount of the desired
685      * token
686      */
687     function calcTokenToToken(
688         ISwap[2] calldata swaps,
689         uint8 tokenFromIndex,
690         uint8 tokenToIndex,
691         uint256 tokenFromAmount
692     ) external view returns (uint256, uint256) {
693         IExchangeRates exchangeRates = IExchangeRates(
694             SYNTHETIX_RESOLVER.getAddress(EXCHANGE_RATES_NAME)
695         );
696 
697         uint256 firstSynthAmount = swaps[0].calculateSwap(
698             tokenFromIndex,
699             getSynthIndex(swaps[0]),
700             tokenFromAmount
701         );
702 
703         uint256 mediumSynthAmount = exchangeRates.effectiveValue(
704             getSynthKey(swaps[0]),
705             firstSynthAmount,
706             getSynthKey(swaps[1])
707         );
708 
709         return (
710             mediumSynthAmount,
711             swaps[1].calculateSwap(
712                 getSynthIndex(swaps[1]),
713                 tokenToIndex,
714                 mediumSynthAmount
715             )
716         );
717     }
718 
719     /**
720      * @notice Initiates a cross-asset swap from a token in one Saddle pool to one in another. The caller will receive
721      * an ERC721 token representing their ownership of the pending cross-asset swap.
722      * @param swaps the addresses of the two Saddle pools used to do the cross-asset swap
723      * @param tokenFromIndex the index of the token in the first `swaps` pool to swap from
724      * @param tokenToIndex the index of the token in the second `swaps` pool to swap to
725      * @param tokenFromAmount the amount of the token to swap from
726      * @param minMediumSynthAmount the minimum amount of the bridging synth at pre-settlement stage
727      * @return the ID of the ERC721 token sent to the caller
728      */
729     function tokenToToken(
730         ISwap[2] calldata swaps,
731         uint8 tokenFromIndex,
732         uint8 tokenToIndex,
733         uint256 tokenFromAmount,
734         uint256 minMediumSynthAmount
735     ) external returns (uint256) {
736         // Create a SynthSwapper clone
737         require(tokenFromAmount != 0, "amount must be greater than 0");
738         SynthSwapper synthSwapper = SynthSwapper(
739             Clones.clone(SYNTH_SWAPPER_MASTER)
740         );
741         synthSwapper.initialize();
742         bytes32 mediumSynthKey = getSynthKey(swaps[1]);
743 
744         // Add the synthswapper to the pending synth to token settlement list
745         uint256 itemId = _addToPendingSynthToTokenSwapList(
746             PendingToTokenSwap(
747                 synthSwapper,
748                 mediumSynthKey,
749                 swaps[1],
750                 tokenToIndex
751             )
752         );
753         pendingSwapType[itemId] = PendingSwapType.TokenToToken;
754 
755         // Mint an ERC721 token that represents ownership of the pending swap to msg.sender
756         _mint(msg.sender, itemId);
757 
758         // Receive token from the user
759         ISwap swap = swaps[0];
760         {
761             IERC20 tokenFrom = swapContracts[address(swap)].tokens[
762                 tokenFromIndex
763             ];
764             tokenFrom.safeTransferFrom(
765                 msg.sender,
766                 address(this),
767                 tokenFromAmount
768             );
769         }
770 
771         uint256 firstSynthAmount = swap.swap(
772             tokenFromIndex,
773             getSynthIndex(swap),
774             tokenFromAmount,
775             0,
776             block.timestamp
777         );
778 
779         // Swap the synth to another synth
780         IERC20(getSynthAddress(swap)).safeTransfer(
781             address(synthSwapper),
782             firstSynthAmount
783         );
784         require(
785             synthSwapper.swapSynth(
786                 getSynthKey(swap),
787                 firstSynthAmount,
788                 mediumSynthKey
789             ) >= minMediumSynthAmount,
790             "minMediumSynthAmount not reached"
791         );
792 
793         // Emit TokenToToken event with relevant data
794         emit TokenToToken(
795             msg.sender,
796             itemId,
797             swaps,
798             tokenFromIndex,
799             tokenFromAmount,
800             tokenToIndex
801         );
802 
803         return (itemId);
804     }
805 
806     /**
807      * @notice Registers the index and the address of the supported synth from the given `swap` pool. The matching currency key must
808      * be supplied for a successful registration.
809      * @param swap the address of the pool that contains the synth
810      * @param synthIndex the index of the supported synth in the given `swap` pool
811      * @param currencyKey the currency key of the synth in bytes32 form
812      */
813     function setSynthIndex(
814         ISwap swap,
815         uint8 synthIndex,
816         bytes32 currencyKey
817     ) external {
818         require(synthIndex < MAX_UINT8, "index is too large");
819         SwapContractInfo storage swapContractInfo = swapContracts[
820             address(swap)
821         ];
822         // Check if the pool has already been added
823         require(swapContractInfo.synthIndexPlusOne == 0, "Pool already added");
824         // Ensure the synth with the same currency key exists at the given `synthIndex`
825         IERC20 synth = swap.getToken(synthIndex);
826         require(
827             ISynth(Proxy(address(synth)).target()).currencyKey() == currencyKey,
828             "currencyKey does not match"
829         );
830         swapContractInfo.synthIndexPlusOne = synthIndex + 1;
831         swapContractInfo.synthAddress = address(synth);
832         swapContractInfo.synthKey = currencyKey;
833         swapContractInfo.tokens = new IERC20[](0);
834 
835         for (uint8 i = 0; i < MAX_UINT8; i++) {
836             IERC20 token;
837             if (i == synthIndex) {
838                 token = synth;
839             } else {
840                 try swap.getToken(i) returns (IERC20 token_) {
841                     token = token_;
842                 } catch {
843                     break;
844                 }
845             }
846             swapContractInfo.tokens.push(token);
847             token.safeApprove(address(swap), MAX_UINT256);
848         }
849 
850         emit SynthIndex(address(swap), synthIndex, currencyKey, address(synth));
851     }
852 
853     /**
854      * @notice Returns the index of the supported synth in the given `swap` pool. Reverts if the `swap` pool
855      * is not registered.
856      * @param swap the address of the pool that contains the synth
857      * @return the index of the supported synth
858      */
859     function getSynthIndex(ISwap swap) public view returns (uint8) {
860         uint8 synthIndexPlusOne = swapContracts[address(swap)]
861             .synthIndexPlusOne;
862         require(synthIndexPlusOne > 0, "synth index not found for given pool");
863         return synthIndexPlusOne - 1;
864     }
865 
866     /**
867      * @notice Returns the address of the supported synth in the given `swap` pool. Reverts if the `swap` pool
868      * is not registered.
869      * @param swap the address of the pool that contains the synth
870      * @return the address of the supported synth
871      */
872     function getSynthAddress(ISwap swap) public view returns (address) {
873         address synthAddress = swapContracts[address(swap)].synthAddress;
874         require(
875             synthAddress != address(0),
876             "synth addr not found for given pool"
877         );
878         return synthAddress;
879     }
880 
881     /**
882      * @notice Returns the currency key of the supported synth in the given `swap` pool. Reverts if the `swap` pool
883      * is not registered.
884      * @param swap the address of the pool that contains the synth
885      * @return the currency key of the supported synth
886      */
887     function getSynthKey(ISwap swap) public view returns (bytes32) {
888         bytes32 synthKey = swapContracts[address(swap)].synthKey;
889         require(synthKey != 0x0, "synth key not found for given pool");
890         return synthKey;
891     }
892 
893     /**
894      * @notice Updates the stored address of the `EXCHANGER` contract. When the Synthetix team upgrades their protocol,
895      * a new Exchanger contract is deployed. This function manually updates the stored address.
896      */
897     function updateExchangerCache() public {
898         exchanger = IExchanger(SYNTHETIX_RESOLVER.getAddress(EXCHANGER_NAME));
899     }
900 }
