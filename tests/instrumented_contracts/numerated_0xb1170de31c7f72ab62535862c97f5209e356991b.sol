1 /*
2   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
3   Licensed under the Apache License, Version 2.0 (the "License");
4   you may not use this file except in compliance with the License.
5   You may obtain a copy of the License at
6   http://www.apache.org/licenses/LICENSE-2.0
7   Unless required by applicable law or agreed to in writing, software
8   distributed under the License is distributed on an "AS IS" BASIS,
9   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
10   See the License for the specific language governing permissions and
11   limitations under the License.
12 */
13 pragma solidity 0.4.21;
14 /// @title Utility Functions for uint
15 /// @author Daniel Wang - <daniel@loopring.org>
16 library MathUint {
17     function mul(
18         uint a,
19         uint b
20         )
21         internal
22         pure
23         returns (uint c)
24     {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function sub(
29         uint a,
30         uint b
31         )
32         internal
33         pure
34         returns (uint)
35     {
36         require(b <= a);
37         return a - b;
38     }
39     function add(
40         uint a,
41         uint b
42         )
43         internal
44         pure
45         returns (uint c)
46     {
47         c = a + b;
48         require(c >= a);
49     }
50     function tolerantSub(
51         uint a,
52         uint b
53         )
54         internal
55         pure
56         returns (uint c)
57     {
58         return (a >= b) ? a - b : 0;
59     }
60     /// @dev calculate the square of Coefficient of Variation (CV)
61     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
62     function cvsquare(
63         uint[] arr,
64         uint scale
65         )
66         internal
67         pure
68         returns (uint)
69     {
70         uint len = arr.length;
71         require(len > 1);
72         require(scale > 0);
73         uint avg = 0;
74         for (uint i = 0; i < len; i++) {
75             avg += arr[i];
76         }
77         avg = avg / len;
78         if (avg == 0) {
79             return 0;
80         }
81         uint cvs = 0;
82         uint s;
83         uint item;
84         for (i = 0; i < len; i++) {
85             item = arr[i];
86             s = item > avg ? item - avg : avg - item;
87             cvs += mul(s, s);
88         }
89         return ((mul(mul(cvs, scale), scale) / avg) / avg) / (len - 1);
90     }
91 }
92 /*
93   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
94   Licensed under the Apache License, Version 2.0 (the "License");
95   you may not use this file except in compliance with the License.
96   You may obtain a copy of the License at
97   http://www.apache.org/licenses/LICENSE-2.0
98   Unless required by applicable law or agreed to in writing, software
99   distributed under the License is distributed on an "AS IS" BASIS,
100   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
101   See the License for the specific language governing permissions and
102   limitations under the License.
103 */
104 /// @title Utility Functions for address
105 /// @author Daniel Wang - <daniel@loopring.org>
106 library AddressUtil {
107     function isContract(
108         address addr
109         )
110         internal
111         view
112         returns (bool)
113     {
114         if (addr == 0x0) {
115             return false;
116         } else {
117             uint size;
118             assembly { size := extcodesize(addr) }
119             return size > 0;
120         }
121     }
122 }
123 /*
124   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
125   Licensed under the Apache License, Version 2.0 (the "License");
126   you may not use this file except in compliance with the License.
127   You may obtain a copy of the License at
128   http://www.apache.org/licenses/LICENSE-2.0
129   Unless required by applicable law or agreed to in writing, software
130   distributed under the License is distributed on an "AS IS" BASIS,
131   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
132   See the License for the specific language governing permissions and
133   limitations under the License.
134 */
135 /*
136   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
137   Licensed under the Apache License, Version 2.0 (the "License");
138   you may not use this file except in compliance with the License.
139   You may obtain a copy of the License at
140   http://www.apache.org/licenses/LICENSE-2.0
141   Unless required by applicable law or agreed to in writing, software
142   distributed under the License is distributed on an "AS IS" BASIS,
143   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
144   See the License for the specific language governing permissions and
145   limitations under the License.
146 */
147 /// @title ERC20 Token Interface
148 /// @dev see https://github.com/ethereum/EIPs/issues/20
149 /// @author Daniel Wang - <daniel@loopring.org>
150 contract ERC20 {
151     function balanceOf(
152         address who
153         )
154         view
155         public
156         returns (uint256);
157     function allowance(
158         address owner,
159         address spender
160         )
161         view
162         public
163         returns (uint256);
164     function transfer(
165         address to,
166         uint256 value
167         )
168         public
169         returns (bool);
170     function transferFrom(
171         address from,
172         address to,
173         uint256 value
174         )
175         public
176         returns (bool);
177     function approve(
178         address spender,
179         uint256 value
180         )
181         public
182         returns (bool);
183 }
184 /*
185   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
186   Licensed under the Apache License, Version 2.0 (the "License");
187   you may not use this file except in compliance with the License.
188   You may obtain a copy of the License at
189   http://www.apache.org/licenses/LICENSE-2.0
190   Unless required by applicable law or agreed to in writing, software
191   distributed under the License is distributed on an "AS IS" BASIS,
192   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
193   See the License for the specific language governing permissions and
194   limitations under the License.
195 */
196 /// @title Loopring Token Exchange Protocol Contract Interface
197 /// @author Daniel Wang - <daniel@loopring.org>
198 /// @author Kongliang Zhong - <kongliang@loopring.org>
199 contract LoopringProtocol {
200     uint8   public constant MARGIN_SPLIT_PERCENTAGE_BASE = 100;
201     /// @dev Event to emit if a ring is successfully mined.
202     /// _amountsList is an array of:
203     /// [_amountS, _amountB, _lrcReward, _lrcFee, splitS, splitB].
204     event RingMined(
205         uint                _ringIndex,
206         bytes32     indexed _ringHash,
207         address             _feeRecipient,
208         bytes32[]           _orderHashList,
209         uint[6][]           _amountsList
210     );
211     event OrderCancelled(
212         bytes32     indexed _orderHash,
213         uint                _amountCancelled
214     );
215     event AllOrdersCancelled(
216         address     indexed _address,
217         uint                _cutoff
218     );
219     event OrdersCancelled(
220         address     indexed _address,
221         address             _token1,
222         address             _token2,
223         uint                _cutoff
224     );
225     /// @dev Cancel a order. cancel amount(amountS or amountB) can be specified
226     ///      in orderValues.
227     /// @param addresses          owner, tokenS, tokenB, wallet, authAddr
228     /// @param orderValues        amountS, amountB, validSince (second),
229     ///                           validUntil (second), lrcFee, and cancelAmount.
230     /// @param buyNoMoreThanAmountB -
231     ///                           This indicates when a order should be considered
232     ///                           as 'completely filled'.
233     /// @param marginSplitPercentage -
234     ///                           Percentage of margin split to share with miner.
235     /// @param v                  Order ECDSA signature parameter v.
236     /// @param r                  Order ECDSA signature parameters r.
237     /// @param s                  Order ECDSA signature parameters s.
238     function cancelOrder(
239         address[5] addresses,
240         uint[6]    orderValues,
241         bool       buyNoMoreThanAmountB,
242         uint8      marginSplitPercentage,
243         uint8      v,
244         bytes32    r,
245         bytes32    s
246         )
247         external;
248     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
249     ///        is smaller than or equal to the new value of the address's cutoff
250     ///        timestamp, for a specific trading pair.
251     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
252     ///        if it is 0.
253     function cancelAllOrdersByTradingPair(
254         address token1,
255         address token2,
256         uint cutoff
257         )
258         external;
259     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
260     ///        is smaller than or equal to the new value of the address's cutoff
261     ///        timestamp.
262     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
263     ///        if it is 0.
264     function cancelAllOrders(
265         uint cutoff
266         )
267         external;
268     /// @dev Submit a order-ring for validation and settlement.
269     /// @param addressList  List of each order's owner, tokenS, wallet, authAddr.
270     ///                     Note that next order's `tokenS` equals this order's
271     ///                     `tokenB`.
272     /// @param uintArgsList List of uint-type arguments in this order:
273     ///                     amountS, amountB, validSince (second),
274     ///                     validUntil (second), lrcFee, and rateAmountS.
275     /// @param uint8ArgsList -
276     ///                     List of unit8-type arguments, in this order:
277     ///                     marginSplitPercentageList.
278     /// @param buyNoMoreThanAmountBList -
279     ///                     This indicates when a order should be considered
280     /// @param vList        List of v for each order. This list is 1-larger than
281     ///                     the previous lists, with the last element being the
282     ///                     v value of the ring signature.
283     /// @param rList        List of r for each order. This list is 1-larger than
284     ///                     the previous lists, with the last element being the
285     ///                     r value of the ring signature.
286     /// @param sList        List of s for each order. This list is 1-larger than
287     ///                     the previous lists, with the last element being the
288     ///                     s value of the ring signature.
289     /// @param miner        Miner address.
290     /// @param feeSelections -
291     ///                     Bits to indicate fee selections. `1` represents margin
292     ///                     split and `0` represents LRC as fee.
293     function submitRing(
294         address[4][]    addressList,
295         uint[6][]       uintArgsList,
296         uint8[1][]      uint8ArgsList,
297         bool[]          buyNoMoreThanAmountBList,
298         uint8[]         vList,
299         bytes32[]       rList,
300         bytes32[]       sList,
301         address         miner,
302         uint16          feeSelections
303         )
304         public;
305 }
306 /*
307   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
308   Licensed under the Apache License, Version 2.0 (the "License");
309   you may not use this file except in compliance with the License.
310   You may obtain a copy of the License at
311   http://www.apache.org/licenses/LICENSE-2.0
312   Unless required by applicable law or agreed to in writing, software
313   distributed under the License is distributed on an "AS IS" BASIS,
314   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
315   See the License for the specific language governing permissions and
316   limitations under the License.
317 */
318 /// @title Token Register Contract
319 /// @dev This contract maintains a list of tokens the Protocol supports.
320 /// @author Kongliang Zhong - <kongliang@loopring.org>,
321 /// @author Daniel Wang - <daniel@loopring.org>.
322 contract TokenRegistry {
323     event TokenRegistered(address addr, string symbol);
324     event TokenUnregistered(address addr, string symbol);
325     function registerToken(
326         address addr,
327         string  symbol
328         )
329         external;
330     function registerMintedToken(
331         address addr,
332         string  symbol
333         )
334         external;
335     function unregisterToken(
336         address addr,
337         string  symbol
338         )
339         external;
340     function areAllTokensRegistered(
341         address[] addressList
342         )
343         external
344         view
345         returns (bool);
346     function getAddressBySymbol(
347         string symbol
348         )
349         external
350         view
351         returns (address);
352     function isTokenRegisteredBySymbol(
353         string symbol
354         )
355         public
356         view
357         returns (bool);
358     function isTokenRegistered(
359         address addr
360         )
361         public
362         view
363         returns (bool);
364     function getTokens(
365         uint start,
366         uint count
367         )
368         public
369         view
370         returns (address[] addressList);
371 }
372 /*
373   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
374   Licensed under the Apache License, Version 2.0 (the "License");
375   you may not use this file except in compliance with the License.
376   You may obtain a copy of the License at
377   http://www.apache.org/licenses/LICENSE-2.0
378   Unless required by applicable law or agreed to in writing, software
379   distributed under the License is distributed on an "AS IS" BASIS,
380   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
381   See the License for the specific language governing permissions and
382   limitations under the License.
383 */
384 /// @title TokenTransferDelegate
385 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
386 /// versions of Loopring protocol to avoid ERC20 re-authorization.
387 /// @author Daniel Wang - <daniel@loopring.org>.
388 contract TokenTransferDelegate {
389     event AddressAuthorized(address indexed addr, uint32 number);
390     event AddressDeauthorized(address indexed addr, uint32 number);
391     // The following map is used to keep trace of order fill and cancellation
392     // history.
393     mapping (bytes32 => uint) public cancelledOrFilled;
394     // This map is used to keep trace of order's cancellation history.
395     mapping (bytes32 => uint) public cancelled;
396     // A map from address to its cutoff timestamp.
397     mapping (address => uint) public cutoffs;
398     // A map from address to its trading-pair cutoff timestamp.
399     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
400     /// @dev Add a Loopring protocol address.
401     /// @param addr A loopring protocol address.
402     function authorizeAddress(
403         address addr
404         )
405         external;
406     /// @dev Remove a Loopring protocol address.
407     /// @param addr A loopring protocol address.
408     function deauthorizeAddress(
409         address addr
410         )
411         external;
412     function getLatestAuthorizedAddresses(
413         uint max
414         )
415         external
416         view
417         returns (address[] addresses);
418     /// @dev Invoke ERC20 transferFrom method.
419     /// @param token Address of token to transfer.
420     /// @param from Address to transfer token from.
421     /// @param to Address to transfer token to.
422     /// @param value Amount of token to transfer.
423     function transferToken(
424         address token,
425         address from,
426         address to,
427         uint    value
428         )
429         external;
430     function batchTransferToken(
431         address lrcTokenAddress,
432         address minerFeeRecipient,
433         uint8 walletSplitPercentage,
434         bytes32[] batch
435         )
436         external;
437     function isAddressAuthorized(
438         address addr
439         )
440         public
441         view
442         returns (bool);
443     function addCancelled(bytes32 orderHash, uint cancelAmount)
444         external;
445     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
446         external;
447     function setCutoffs(uint t)
448         external;
449     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
450         external;
451     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
452         external
453         view;
454 }
455 /// @title An Implementation of LoopringProtocol.
456 /// @author Daniel Wang - <daniel@loopring.org>,
457 /// @author Kongliang Zhong - <kongliang@loopring.org>
458 ///
459 /// Recognized contributing developers from the community:
460 ///     https://github.com/Brechtpd
461 ///     https://github.com/rainydio
462 ///     https://github.com/BenjaminPrice
463 ///     https://github.com/jonasshen
464 ///     https://github.com/Hephyrius
465 contract LoopringProtocolImpl is LoopringProtocol {
466     using AddressUtil   for address;
467     using MathUint      for uint;
468     address public constant  lrcTokenAddress             = 0xEF68e7C694F40c8202821eDF525dE3782458639f;
469     address public constant  tokenRegistryAddress        = 0x004DeF62C71992615CF22786d0b7Efb22850Df4a;
470     address public constant  delegateAddress             = 0x5567ee920f7E62274284985D793344351A00142B;
471     uint64  public  ringIndex                   = 0;
472     uint8   public  walletSplitPercentage       = 20;
473     // Exchange rate (rate) is the amount to sell or sold divided by the amount
474     // to buy or bought.
475     //
476     // Rate ratio is the ratio between executed rate and an order's original
477     // rate.
478     //
479     // To require all orders' rate ratios to have coefficient ofvariation (CV)
480     // smaller than 2.5%, for an example , rateRatioCVSThreshold should be:
481     //     `(0.025 * RATE_RATIO_SCALE)^2` or 62500.
482     uint    public rateRatioCVSThreshold        = 62500;
483     uint    public constant MAX_RING_SIZE       = 8;
484     uint    public constant RATE_RATIO_SCALE    = 10000;
485     /// @param orderHash    The order's hash
486     /// @param feeSelection -
487     ///                     A miner-supplied value indicating if LRC (value = 0)
488     ///                     or margin split is choosen by the miner (value = 1).
489     ///                     We may support more fee model in the future.
490     /// @param rateS        Sell Exchange rate provided by miner.
491     /// @param rateB        Buy Exchange rate provided by miner.
492     /// @param fillAmountS  Amount of tokenS to sell, calculated by protocol.
493     /// @param lrcReward    The amount of LRC paid by miner to order owner in
494     ///                     exchange for margin split.
495     /// @param lrcFeeState  The amount of LR paid by order owner to miner.
496     /// @param splitS      TokenS paid to miner.
497     /// @param splitB      TokenB paid to miner.
498     struct OrderState {
499         address owner;
500         address tokenS;
501         address tokenB;
502         address wallet;
503         address authAddr;
504         uint    validSince;
505         uint    validUntil;
506         uint    amountS;
507         uint    amountB;
508         uint    lrcFee;
509         bool    buyNoMoreThanAmountB;
510         bool    marginSplitAsFee;
511         bytes32 orderHash;
512         uint8   marginSplitPercentage;
513         uint    rateS;
514         uint    rateB;
515         uint    fillAmountS;
516         uint    lrcReward;
517         uint    lrcFeeState;
518         uint    splitS;
519         uint    splitB;
520     }
521     /// @dev A struct to capture parameters passed to submitRing method and
522     ///      various of other variables used across the submitRing core logics.
523     struct RingParams {
524         uint8[]       vList;
525         bytes32[]     rList;
526         bytes32[]     sList;
527         address       miner;
528         uint16        feeSelections;
529         uint          ringSize;         // computed
530         bytes32       ringHash;         // computed
531     }
532     /// @dev Disable default function.
533     function ()
534         payable
535         public
536     {
537         revert();
538     }
539     function cancelOrder(
540         address[5] addresses,
541         uint[6]    orderValues,
542         bool       buyNoMoreThanAmountB,
543         uint8      marginSplitPercentage,
544         uint8      v,
545         bytes32    r,
546         bytes32    s
547         )
548         external
549     {
550         uint cancelAmount = orderValues[5];
551         require(cancelAmount > 0); // "amount to cancel is zero");
552         OrderState memory order = OrderState(
553             addresses[0],
554             addresses[1],
555             addresses[2],
556             addresses[3],
557             addresses[4],
558             orderValues[2],
559             orderValues[3],
560             orderValues[0],
561             orderValues[1],
562             orderValues[4],
563             buyNoMoreThanAmountB,
564             false,
565             0x0,
566             marginSplitPercentage,
567             0,
568             0,
569             0,
570             0,
571             0,
572             0,
573             0
574         );
575         require(msg.sender == order.owner); // "cancelOrder not submitted by order owner");
576         bytes32 orderHash = calculateOrderHash(order);
577         verifySignature(
578             order.owner,
579             orderHash,
580             v,
581             r,
582             s
583         );
584         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
585         delegate.addCancelled(orderHash, cancelAmount);
586         delegate.addCancelledOrFilled(orderHash, cancelAmount);
587         emit OrderCancelled(orderHash, cancelAmount);
588     }
589     function cancelAllOrdersByTradingPair(
590         address token1,
591         address token2,
592         uint    cutoff
593         )
594         external
595     {
596         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
597         bytes20 tokenPair = bytes20(token1) ^ bytes20(token2);
598         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
599         require(delegate.tradingPairCutoffs(msg.sender, tokenPair) < t);
600         // "attempted to set cutoff to a smaller value"
601         delegate.setTradingPairCutoffs(tokenPair, t);
602         emit OrdersCancelled(
603             msg.sender,
604             token1,
605             token2,
606             t
607         );
608     }
609     function cancelAllOrders(
610         uint cutoff
611         )
612         external
613     {
614         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
615         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
616         require(delegate.cutoffs(msg.sender) < t); // "attempted to set cutoff to a smaller value"
617         delegate.setCutoffs(t);
618         emit AllOrdersCancelled(msg.sender, t);
619     }
620     function submitRing(
621         address[4][]  addressList,
622         uint[6][]     uintArgsList,
623         uint8[1][]    uint8ArgsList,
624         bool[]        buyNoMoreThanAmountBList,
625         uint8[]       vList,
626         bytes32[]     rList,
627         bytes32[]     sList,
628         address       miner,
629         uint16        feeSelections
630         )
631         public
632     {
633         // Check if the highest bit of ringIndex is '1'.
634         require((ringIndex >> 63) == 0); // "attempted to re-ent submitRing function");
635         // Set the highest bit of ringIndex to '1'.
636         uint64 _ringIndex = ringIndex;
637         ringIndex |= (1 << 63);
638         RingParams memory params = RingParams(
639             vList,
640             rList,
641             sList,
642             miner,
643             feeSelections,
644             addressList.length,
645             0x0 // ringHash
646         );
647         verifyInputDataIntegrity(
648             params,
649             addressList,
650             uintArgsList,
651             uint8ArgsList,
652             buyNoMoreThanAmountBList
653         );
654         // Assemble input data into structs so we can pass them to other functions.
655         // This method also calculates ringHash, therefore it must be called before
656         // calling `verifyRingSignatures`.
657         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
658         OrderState[] memory orders = assembleOrders(
659             params,
660             delegate,
661             addressList,
662             uintArgsList,
663             uint8ArgsList,
664             buyNoMoreThanAmountBList
665         );
666         verifyRingSignatures(params, orders);
667         verifyTokensRegistered(params, orders);
668         handleRing(_ringIndex, params, orders, delegate);
669         ringIndex = _ringIndex + 1;
670     }
671     /// @dev Validate a ring.
672     function verifyRingHasNoSubRing(
673         uint          ringSize,
674         OrderState[]  orders
675         )
676         private
677         pure
678     {
679         // Check the ring has no sub-ring.
680         for (uint i = 0; i < ringSize - 1; i++) {
681             address tokenS = orders[i].tokenS;
682             for (uint j = i + 1; j < ringSize; j++) {
683                 require(tokenS != orders[j].tokenS); // "found sub-ring");
684             }
685         }
686     }
687     /// @dev Verify the ringHash has been signed with each order's auth private
688     ///      keys as well as the miner's private key.
689     function verifyRingSignatures(
690         RingParams params,
691         OrderState[] orders
692         )
693         private
694         pure
695     {
696         uint j;
697         for (uint i = 0; i < params.ringSize; i++) {
698             j = i + params.ringSize;
699             verifySignature(
700                 orders[i].authAddr,
701                 params.ringHash,
702                 params.vList[j],
703                 params.rList[j],
704                 params.sList[j]
705             );
706         }
707     }
708     function verifyTokensRegistered(
709         RingParams params,
710         OrderState[] orders
711         )
712         private
713         view
714     {
715         // Extract the token addresses
716         address[] memory tokens = new address[](params.ringSize);
717         for (uint i = 0; i < params.ringSize; i++) {
718             tokens[i] = orders[i].tokenS;
719         }
720         // Test all token addresses at once
721         require(
722             TokenRegistry(tokenRegistryAddress).areAllTokensRegistered(tokens)
723         ); // "token not registered");
724     }
725     function handleRing(
726         uint64       _ringIndex,
727         RingParams   params,
728         OrderState[] orders,
729         TokenTransferDelegate delegate
730         )
731         private
732     {
733         address _lrcTokenAddress = lrcTokenAddress;
734         // Do the hard work.
735         verifyRingHasNoSubRing(params.ringSize, orders);
736         // Exchange rates calculation are performed by ring-miners as solidity
737         // cannot get power-of-1/n operation, therefore we have to verify
738         // these rates are correct.
739         verifyMinerSuppliedFillRates(params.ringSize, orders);
740         // Scale down each order independently by substracting amount-filled and
741         // amount-cancelled. Order owner's current balance and allowance are
742         // not taken into consideration in these operations.
743         scaleRingBasedOnHistoricalRecords(delegate, params.ringSize, orders);
744         // Based on the already verified exchange rate provided by ring-miners,
745         // we can furthur scale down orders based on token balance and allowance,
746         // then find the smallest order of the ring, then calculate each order's
747         // `fillAmountS`.
748         calculateRingFillAmount(params.ringSize, orders);
749         // Calculate each order's `lrcFee` and `lrcRewrard` and splict how much
750         // of `fillAmountS` shall be paid to matching order or miner as margin
751         // split.
752         calculateRingFees(
753             delegate,
754             params.ringSize,
755             orders,
756             params.miner,
757             _lrcTokenAddress
758         );
759         /// Make transfers.
760         bytes32[] memory orderHashList;
761         uint[6][] memory amountsList;
762         (orderHashList, amountsList) = settleRing(
763             delegate,
764             params.ringSize,
765             orders,
766             params.miner,
767             _lrcTokenAddress
768         );
769         emit RingMined(
770             _ringIndex,
771             params.ringHash,
772             params.miner,
773             orderHashList,
774             amountsList
775         );
776     }
777     function settleRing(
778         TokenTransferDelegate delegate,
779         uint          ringSize,
780         OrderState[]  orders,
781         address       miner,
782         address       _lrcTokenAddress
783         )
784         private
785         returns (
786         bytes32[] memory orderHashList,
787         uint[6][] memory amountsList)
788     {
789         bytes32[] memory batch = new bytes32[](ringSize * 7); // ringSize * (owner + tokenS + 4 amounts + wallet)
790         orderHashList = new bytes32[](ringSize);
791         amountsList = new uint[6][](ringSize);
792         uint p = 0;
793         for (uint i = 0; i < ringSize; i++) {
794             OrderState memory state = orders[i];
795             uint prevSplitB = orders[(i + ringSize - 1) % ringSize].splitB;
796             uint nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
797             // Store owner and tokenS of every order
798             batch[p] = bytes32(state.owner);
799             batch[p + 1] = bytes32(state.tokenS);
800             // Store all amounts
801             batch[p + 2] = bytes32(state.fillAmountS - prevSplitB);
802             batch[p + 3] = bytes32(prevSplitB + state.splitS);
803             batch[p + 4] = bytes32(state.lrcReward);
804             batch[p + 5] = bytes32(state.lrcFeeState);
805             batch[p + 6] = bytes32(state.wallet);
806             p += 7;
807             // Update fill records
808             if (state.buyNoMoreThanAmountB) {
809                 delegate.addCancelledOrFilled(state.orderHash, nextFillAmountS);
810             } else {
811                 delegate.addCancelledOrFilled(state.orderHash, state.fillAmountS);
812             }
813             orderHashList[i] = state.orderHash;
814             amountsList[i][0] = state.fillAmountS + state.splitS;
815             amountsList[i][1] = nextFillAmountS - state.splitB;
816             amountsList[i][2] = state.lrcReward;
817             amountsList[i][3] = state.lrcFeeState;
818             amountsList[i][4] = state.splitS;
819             amountsList[i][5] = state.splitB;
820         }
821         // Do all transactions
822         delegate.batchTransferToken(
823             _lrcTokenAddress,
824             miner,
825             walletSplitPercentage,
826             batch
827         );
828     }
829     /// @dev Verify miner has calculte the rates correctly.
830     function verifyMinerSuppliedFillRates(
831         uint         ringSize,
832         OrderState[] orders
833         )
834         private
835         view
836     {
837         uint[] memory rateRatios = new uint[](ringSize);
838         uint _rateRatioScale = RATE_RATIO_SCALE;
839         for (uint i = 0; i < ringSize; i++) {
840             uint s1b0 = orders[i].rateS.mul(orders[i].amountB);
841             uint s0b1 = orders[i].amountS.mul(orders[i].rateB);
842             require(s1b0 <= s0b1); // "miner supplied exchange rate provides invalid discount");
843             rateRatios[i] = _rateRatioScale.mul(s1b0) / s0b1;
844         }
845         uint cvs = MathUint.cvsquare(rateRatios, _rateRatioScale);
846         require(cvs <= rateRatioCVSThreshold);
847         // "miner supplied exchange rate is not evenly discounted");
848     }
849     /// @dev Calculate each order's fee or LRC reward.
850     function calculateRingFees(
851         TokenTransferDelegate delegate,
852         uint            ringSize,
853         OrderState[]    orders,
854         address         miner,
855         address         _lrcTokenAddress
856         )
857         private
858         view
859     {
860         bool checkedMinerLrcSpendable = false;
861         uint minerLrcSpendable = 0;
862         uint8 _marginSplitPercentageBase = MARGIN_SPLIT_PERCENTAGE_BASE;
863         uint nextFillAmountS;
864         for (uint i = 0; i < ringSize; i++) {
865             OrderState memory state = orders[i];
866             uint lrcReceiable = 0;
867             if (state.lrcFeeState == 0) {
868                 // When an order's LRC fee is 0 or smaller than the specified fee,
869                 // we help miner automatically select margin-split.
870                 state.marginSplitAsFee = true;
871                 state.marginSplitPercentage = _marginSplitPercentageBase;
872             } else {
873                 uint lrcSpendable = getSpendable(
874                     delegate,
875                     _lrcTokenAddress,
876                     state.owner
877                 );
878                 // If the order is selling LRC, we need to calculate how much LRC
879                 // is left that can be used as fee.
880                 if (state.tokenS == _lrcTokenAddress) {
881                     lrcSpendable -= state.fillAmountS;
882                 }
883                 // If the order is buyign LRC, it will has more to pay as fee.
884                 if (state.tokenB == _lrcTokenAddress) {
885                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
886                     lrcReceiable = nextFillAmountS;
887                 }
888                 uint lrcTotal = lrcSpendable + lrcReceiable;
889                 // If order doesn't have enough LRC, set margin split to 100%.
890                 if (lrcTotal < state.lrcFeeState) {
891                     state.lrcFeeState = lrcTotal;
892                     state.marginSplitPercentage = _marginSplitPercentageBase;
893                 }
894                 if (state.lrcFeeState == 0) {
895                     state.marginSplitAsFee = true;
896                 }
897             }
898             if (!state.marginSplitAsFee) {
899                 if (lrcReceiable > 0) {
900                     if (lrcReceiable >= state.lrcFeeState) {
901                         state.splitB = state.lrcFeeState;
902                         state.lrcFeeState = 0;
903                     } else {
904                         state.splitB = lrcReceiable;
905                         state.lrcFeeState -= lrcReceiable;
906                     }
907                 }
908             } else {
909                 // Only check the available miner balance when absolutely needed
910                 if (!checkedMinerLrcSpendable && minerLrcSpendable < state.lrcFeeState) {
911                     checkedMinerLrcSpendable = true;
912                     minerLrcSpendable = getSpendable(delegate, _lrcTokenAddress, miner);
913                 }
914                 // Only calculate split when miner has enough LRC;
915                 // otherwise all splits are 0.
916                 if (minerLrcSpendable >= state.lrcFeeState) {
917                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
918                     uint split;
919                     if (state.buyNoMoreThanAmountB) {
920                         split = (nextFillAmountS.mul(
921                             state.amountS
922                         ) / state.amountB).sub(
923                             state.fillAmountS
924                         );
925                     } else {
926                         split = nextFillAmountS.sub(
927                             state.fillAmountS.mul(
928                                 state.amountB
929                             ) / state.amountS
930                         );
931                     }
932                     if (state.marginSplitPercentage != _marginSplitPercentageBase) {
933                         split = split.mul(
934                             state.marginSplitPercentage
935                         ) / _marginSplitPercentageBase;
936                     }
937                     if (state.buyNoMoreThanAmountB) {
938                         state.splitS = split;
939                     } else {
940                         state.splitB = split;
941                     }
942                     // This implicits order with smaller index in the ring will
943                     // be paid LRC reward first, so the orders in the ring does
944                     // mater.
945                     if (split > 0) {
946                         minerLrcSpendable -= state.lrcFeeState;
947                         state.lrcReward = state.lrcFeeState;
948                     }
949                 }
950                 state.lrcFeeState = 0;
951             }
952         }
953     }
954     /// @dev Calculate each order's fill amount.
955     function calculateRingFillAmount(
956         uint          ringSize,
957         OrderState[]  orders
958         )
959         private
960         pure
961     {
962         uint smallestIdx = 0;
963         uint i;
964         uint j;
965         for (i = 0; i < ringSize; i++) {
966             j = (i + 1) % ringSize;
967             smallestIdx = calculateOrderFillAmount(
968                 orders[i],
969                 orders[j],
970                 i,
971                 j,
972                 smallestIdx
973             );
974         }
975         for (i = 0; i < smallestIdx; i++) {
976             calculateOrderFillAmount(
977                 orders[i],
978                 orders[(i + 1) % ringSize],
979                 0,               // Not needed
980                 0,               // Not needed
981                 0                // Not needed
982             );
983         }
984     }
985     /// @return The smallest order's index.
986     function calculateOrderFillAmount(
987         OrderState state,
988         OrderState next,
989         uint       i,
990         uint       j,
991         uint       smallestIdx
992         )
993         private
994         pure
995         returns (uint newSmallestIdx)
996     {
997         // Default to the same smallest index
998         newSmallestIdx = smallestIdx;
999         uint fillAmountB = state.fillAmountS.mul(
1000             state.rateB
1001         ) / state.rateS;
1002         if (state.buyNoMoreThanAmountB) {
1003             if (fillAmountB > state.amountB) {
1004                 fillAmountB = state.amountB;
1005                 state.fillAmountS = fillAmountB.mul(
1006                     state.rateS
1007                 ) / state.rateB;
1008                 newSmallestIdx = i;
1009             }
1010             state.lrcFeeState = state.lrcFee.mul(
1011                 fillAmountB
1012             ) / state.amountB;
1013         } else {
1014             state.lrcFeeState = state.lrcFee.mul(
1015                 state.fillAmountS
1016             ) / state.amountS;
1017         }
1018         if (fillAmountB <= next.fillAmountS) {
1019             next.fillAmountS = fillAmountB;
1020         } else {
1021             newSmallestIdx = j;
1022         }
1023     }
1024     /// @dev Scale down all orders based on historical fill or cancellation
1025     ///      stats but key the order's original exchange rate.
1026     function scaleRingBasedOnHistoricalRecords(
1027         TokenTransferDelegate delegate,
1028         uint ringSize,
1029         OrderState[] orders
1030         )
1031         private
1032         view
1033     {
1034         for (uint i = 0; i < ringSize; i++) {
1035             OrderState memory state = orders[i];
1036             uint amount;
1037             if (state.buyNoMoreThanAmountB) {
1038                 amount = state.amountB.tolerantSub(
1039                     delegate.cancelledOrFilled(state.orderHash)
1040                 );
1041                 state.amountS = amount.mul(state.amountS) / state.amountB;
1042                 state.lrcFee = amount.mul(state.lrcFee) / state.amountB;
1043                 state.amountB = amount;
1044             } else {
1045                 amount = state.amountS.tolerantSub(
1046                     delegate.cancelledOrFilled(state.orderHash)
1047                 );
1048                 state.amountB = amount.mul(state.amountB) / state.amountS;
1049                 state.lrcFee = amount.mul(state.lrcFee) / state.amountS;
1050                 state.amountS = amount;
1051             }
1052             require(state.amountS > 0); // "amountS is zero");
1053             require(state.amountB > 0); // "amountB is zero");
1054             uint availableAmountS = getSpendable(delegate, state.tokenS, state.owner);
1055             require(availableAmountS > 0); // "order spendable amountS is zero");
1056             state.fillAmountS = (
1057                 state.amountS < availableAmountS ?
1058                 state.amountS : availableAmountS
1059             );
1060         }
1061     }
1062     /// @return Amount of ERC20 token that can be spent by this contract.
1063     function getSpendable(
1064         TokenTransferDelegate delegate,
1065         address tokenAddress,
1066         address tokenOwner
1067         )
1068         private
1069         view
1070         returns (uint)
1071     {
1072         ERC20 token = ERC20(tokenAddress);
1073         uint allowance = token.allowance(
1074             tokenOwner,
1075             address(delegate)
1076         );
1077         uint balance = token.balanceOf(tokenOwner);
1078         return (allowance < balance ? allowance : balance);
1079     }
1080     /// @dev verify input data's basic integrity.
1081     function verifyInputDataIntegrity(
1082         RingParams params,
1083         address[4][]  addressList,
1084         uint[6][]     uintArgsList,
1085         uint8[1][]    uint8ArgsList,
1086         bool[]        buyNoMoreThanAmountBList
1087         )
1088         private
1089         pure
1090     {
1091         require(params.miner != 0x0);
1092         require(params.ringSize == addressList.length);
1093         require(params.ringSize == uintArgsList.length);
1094         require(params.ringSize == uint8ArgsList.length);
1095         require(params.ringSize == buyNoMoreThanAmountBList.length);
1096         // Validate ring-mining related arguments.
1097         for (uint i = 0; i < params.ringSize; i++) {
1098             require(uintArgsList[i][5] > 0); // "order rateAmountS is zero");
1099         }
1100         //Check ring size
1101         require(params.ringSize > 1 && params.ringSize <= MAX_RING_SIZE); // "invalid ring size");
1102         uint sigSize = params.ringSize << 1;
1103         require(sigSize == params.vList.length);
1104         require(sigSize == params.rList.length);
1105         require(sigSize == params.sList.length);
1106     }
1107     /// @dev        assmble order parameters into Order struct.
1108     /// @return     A list of orders.
1109     function assembleOrders(
1110         RingParams params,
1111         TokenTransferDelegate delegate,
1112         address[4][]  addressList,
1113         uint[6][]     uintArgsList,
1114         uint8[1][]    uint8ArgsList,
1115         bool[]        buyNoMoreThanAmountBList
1116         )
1117         private
1118         view
1119         returns (OrderState[] memory orders)
1120     {
1121         orders = new OrderState[](params.ringSize);
1122         for (uint i = 0; i < params.ringSize; i++) {
1123             bool marginSplitAsFee = (params.feeSelections & (uint16(1) << i)) > 0;
1124             orders[i] = OrderState(
1125                 addressList[i][0],
1126                 addressList[i][1],
1127                 addressList[(i + 1) % params.ringSize][1],
1128                 addressList[i][2],
1129                 addressList[i][3],
1130                 uintArgsList[i][2],
1131                 uintArgsList[i][3],
1132                 uintArgsList[i][0],
1133                 uintArgsList[i][1],
1134                 uintArgsList[i][4],
1135                 buyNoMoreThanAmountBList[i],
1136                 marginSplitAsFee,
1137                 bytes32(0),
1138                 uint8ArgsList[i][0],
1139                 uintArgsList[i][5],
1140                 uintArgsList[i][1],
1141                 0,   // fillAmountS
1142                 0,   // lrcReward
1143                 0,   // lrcFee
1144                 0,   // splitS
1145                 0    // splitB
1146             );
1147             validateOrder(orders[i]);
1148             bytes32 orderHash = calculateOrderHash(orders[i]);
1149             orders[i].orderHash = orderHash;
1150             verifySignature(
1151                 orders[i].owner,
1152                 orderHash,
1153                 params.vList[i],
1154                 params.rList[i],
1155                 params.sList[i]
1156             );
1157             params.ringHash ^= orderHash;
1158         }
1159         validateOrdersCutoffs(orders, delegate);
1160         params.ringHash = keccak256(
1161             params.ringHash,
1162             params.miner,
1163             params.feeSelections
1164         );
1165     }
1166     /// @dev validate order's parameters are OK.
1167     function validateOrder(
1168         OrderState order
1169         )
1170         private
1171         view
1172     {
1173         require(order.owner != 0x0); // invalid order owner
1174         require(order.tokenS != 0x0); // invalid order tokenS
1175         require(order.tokenB != 0x0); // invalid order tokenB
1176         require(order.amountS != 0); // invalid order amountS
1177         require(order.amountB != 0); // invalid order amountB
1178         require(order.marginSplitPercentage <= MARGIN_SPLIT_PERCENTAGE_BASE);
1179         // invalid order marginSplitPercentage
1180         require(order.validSince <= block.timestamp); // order is too early to match
1181         require(order.validUntil > block.timestamp); // order is expired
1182     }
1183     function validateOrdersCutoffs(OrderState[] orders, TokenTransferDelegate delegate)
1184         private
1185         view
1186     {
1187         address[] memory owners = new address[](orders.length);
1188         bytes20[] memory tradingPairs = new bytes20[](orders.length);
1189         uint[] memory validSinceTimes = new uint[](orders.length);
1190         for (uint i = 0; i < orders.length; i++) {
1191             owners[i] = orders[i].owner;
1192             tradingPairs[i] = bytes20(orders[i].tokenS) ^ bytes20(orders[i].tokenB);
1193             validSinceTimes[i] = orders[i].validSince;
1194         }
1195         delegate.checkCutoffsBatch(owners, tradingPairs, validSinceTimes);
1196     }
1197     /// @dev Get the Keccak-256 hash of order with specified parameters.
1198     function calculateOrderHash(
1199         OrderState order
1200         )
1201         private
1202         pure
1203         returns (bytes32)
1204     {
1205         return keccak256(
1206             delegateAddress,
1207             order.owner,
1208             order.tokenS,
1209             order.tokenB,
1210             order.wallet,
1211             order.authAddr,
1212             order.amountS,
1213             order.amountB,
1214             order.validSince,
1215             order.validUntil,
1216             order.lrcFee,
1217             order.buyNoMoreThanAmountB,
1218             order.marginSplitPercentage
1219         );
1220     }
1221     /// @dev Verify signer's signature.
1222     function verifySignature(
1223         address signer,
1224         bytes32 hash,
1225         uint8   v,
1226         bytes32 r,
1227         bytes32 s
1228         )
1229         private
1230         pure
1231     {
1232         require(
1233             signer == ecrecover(
1234                 keccak256("\x19Ethereum Signed Message:\n32", hash),
1235                 v,
1236                 r,
1237                 s
1238             )
1239         ); // "invalid signature");
1240     }
1241     function getTradingPairCutoffs(
1242         address orderOwner,
1243         address token1,
1244         address token2
1245         )
1246         public
1247         view
1248         returns (uint)
1249     {
1250         bytes20 tokenPair = bytes20(token1) ^ bytes20(token2);
1251         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
1252         return delegate.tradingPairCutoffs(orderOwner, tokenPair);
1253     }
1254 }