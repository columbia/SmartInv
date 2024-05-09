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
75             avg = add(avg, arr[i]);
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
87             cvs = add(cvs, mul(s, s));
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
205         uint            _ringIndex,
206         bytes32 indexed _ringHash,
207         address         _miner,
208         address         _feeRecipient,
209         bytes32[]       _orderInfoList
210     );
211     event OrderCancelled(
212         bytes32 indexed _orderHash,
213         uint            _amountCancelled
214     );
215     event AllOrdersCancelled(
216         address indexed _address,
217         uint            _cutoff
218     );
219     event OrdersCancelled(
220         address indexed _address,
221         address         _token1,
222         address         _token2,
223         uint            _cutoff
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
289     /// @param feeRecipient Miner address.
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
301         address         feeRecipient,
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
323     event TokenRegistered(
324         address indexed addr,
325         string          symbol
326     );
327     event TokenUnregistered(
328         address indexed addr,
329         string          symbol
330     );
331     function registerToken(
332         address addr,
333         string  symbol
334         )
335         external;
336     function unregisterToken(
337         address addr,
338         string  symbol
339         )
340         external;
341     function areAllTokensRegistered(
342         address[] addressList
343         )
344         external
345         view
346         returns (bool);
347     function getAddressBySymbol(
348         string symbol
349         )
350         external
351         view
352         returns (address);
353     function isTokenRegisteredBySymbol(
354         string symbol
355         )
356         public
357         view
358         returns (bool);
359     function isTokenRegistered(
360         address addr
361         )
362         public
363         view
364         returns (bool);
365     function getTokens(
366         uint start,
367         uint count
368         )
369         public
370         view
371         returns (address[] addressList);
372 }
373 /*
374   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
375   Licensed under the Apache License, Version 2.0 (the "License");
376   you may not use this file except in compliance with the License.
377   You may obtain a copy of the License at
378   http://www.apache.org/licenses/LICENSE-2.0
379   Unless required by applicable law or agreed to in writing, software
380   distributed under the License is distributed on an "AS IS" BASIS,
381   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
382   See the License for the specific language governing permissions and
383   limitations under the License.
384 */
385 /// @title TokenTransferDelegate
386 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
387 /// versions of Loopring protocol to avoid ERC20 re-authorization.
388 /// @author Daniel Wang - <daniel@loopring.org>.
389 contract TokenTransferDelegate {
390     event AddressAuthorized(
391         address indexed addr,
392         uint32          number
393     );
394     event AddressDeauthorized(
395         address indexed addr,
396         uint32          number
397     );
398     // The following map is used to keep trace of order fill and cancellation
399     // history.
400     mapping (bytes32 => uint) public cancelledOrFilled;
401     // This map is used to keep trace of order's cancellation history.
402     mapping (bytes32 => uint) public cancelled;
403     // A map from address to its cutoff timestamp.
404     mapping (address => uint) public cutoffs;
405     // A map from address to its trading-pair cutoff timestamp.
406     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
407     /// @dev Add a Loopring protocol address.
408     /// @param addr A loopring protocol address.
409     function authorizeAddress(
410         address addr
411         )
412         external;
413     /// @dev Remove a Loopring protocol address.
414     /// @param addr A loopring protocol address.
415     function deauthorizeAddress(
416         address addr
417         )
418         external;
419     function getLatestAuthorizedAddresses(
420         uint max
421         )
422         external
423         view
424         returns (address[] addresses);
425     /// @dev Invoke ERC20 transferFrom method.
426     /// @param token Address of token to transfer.
427     /// @param from Address to transfer token from.
428     /// @param to Address to transfer token to.
429     /// @param value Amount of token to transfer.
430     function transferToken(
431         address token,
432         address from,
433         address to,
434         uint    value
435         )
436         external;
437     function batchTransferToken(
438         address lrcTokenAddress,
439         address miner,
440         address minerFeeRecipient,
441         uint8 walletSplitPercentage,
442         bytes32[] batch
443         )
444         external;
445     function isAddressAuthorized(
446         address addr
447         )
448         public
449         view
450         returns (bool);
451     function addCancelled(bytes32 orderHash, uint cancelAmount)
452         external;
453     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
454         public;
455     function batchAddCancelledOrFilled(bytes32[] batch)
456         public;
457     function setCutoffs(uint t)
458         external;
459     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
460         external;
461     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
462         external
463         view;
464     function suspend() external;
465     function resume() external;
466     function kill() external;
467 }
468 /// @title An Implementation of LoopringProtocol.
469 /// @author Daniel Wang - <daniel@loopring.org>,
470 /// @author Kongliang Zhong - <kongliang@loopring.org>
471 ///
472 /// Recognized contributing developers from the community:
473 ///     https://github.com/Brechtpd
474 ///     https://github.com/rainydio
475 ///     https://github.com/BenjaminPrice
476 ///     https://github.com/jonasshen
477 ///     https://github.com/Hephyrius
478 contract LoopringProtocolImpl is LoopringProtocol {
479     using AddressUtil   for address;
480     using MathUint      for uint;
481     address public constant lrcTokenAddress             = 0xEF68e7C694F40c8202821eDF525dE3782458639f;
482     address public constant tokenRegistryAddress        = 0xAbe12e3548fDb334D11fcc962c413d91Ef12233F;
483     address public constant delegateAddress             = 0x17233e07c67d086464fD408148c3ABB56245FA64;
484     uint64  public  ringIndex                   = 0;
485     uint8   public constant walletSplitPercentage       = 20;
486     // Exchange rate (rate) is the amount to sell or sold divided by the amount
487     // to buy or bought.
488     //
489     // Rate ratio is the ratio between executed rate and an order's original
490     // rate.
491     //
492     // To require all orders' rate ratios to have coefficient ofvariation (CV)
493     // smaller than 2.5%, for an example , rateRatioCVSThreshold should be:
494     //     `(0.025 * RATE_RATIO_SCALE)^2` or 62500.
495     uint    public constant rateRatioCVSThreshold        = 62500;
496     uint    public constant MAX_RING_SIZE       = 16;
497     uint    public constant RATE_RATIO_SCALE    = 10000;
498     /// @param orderHash    The order's hash
499     /// @param feeSelection -
500     ///                     A miner-supplied value indicating if LRC (value = 0)
501     ///                     or margin split is choosen by the miner (value = 1).
502     ///                     We may support more fee model in the future.
503     /// @param rateS        Sell Exchange rate provided by miner.
504     /// @param rateB        Buy Exchange rate provided by miner.
505     /// @param fillAmountS  Amount of tokenS to sell, calculated by protocol.
506     /// @param lrcReward    The amount of LRC paid by miner to order owner in
507     ///                     exchange for margin split.
508     /// @param lrcFeeState  The amount of LR paid by order owner to miner.
509     /// @param splitS      TokenS paid to miner.
510     /// @param splitB      TokenB paid to miner.
511     struct OrderState {
512         address owner;
513         address tokenS;
514         address tokenB;
515         address wallet;
516         address authAddr;
517         uint    validSince;
518         uint    validUntil;
519         uint    amountS;
520         uint    amountB;
521         uint    lrcFee;
522         bool    buyNoMoreThanAmountB;
523         bool    marginSplitAsFee;
524         bytes32 orderHash;
525         uint8   marginSplitPercentage;
526         uint    rateS;
527         uint    rateB;
528         uint    fillAmountS;
529         uint    lrcReward;
530         uint    lrcFeeState;
531         uint    splitS;
532         uint    splitB;
533     }
534     /// @dev A struct to capture parameters passed to submitRing method and
535     ///      various of other variables used across the submitRing core logics.
536     struct RingParams {
537         uint8[]       vList;
538         bytes32[]     rList;
539         bytes32[]     sList;
540         address       feeRecipient;
541         uint16        feeSelections;
542         uint          ringSize;         // computed
543         bytes32       ringHash;         // computed
544     }
545     /// @dev Disable default function.
546     function ()
547         payable
548         public
549     {
550         revert();
551     }
552     function cancelOrder(
553         address[5] addresses,
554         uint[6]    orderValues,
555         bool       buyNoMoreThanAmountB,
556         uint8      marginSplitPercentage,
557         uint8      v,
558         bytes32    r,
559         bytes32    s
560         )
561         external
562     {
563         uint cancelAmount = orderValues[5];
564         require(cancelAmount > 0); // "amount to cancel is zero");
565         OrderState memory order = OrderState(
566             addresses[0],
567             addresses[1],
568             addresses[2],
569             addresses[3],
570             addresses[4],
571             orderValues[2],
572             orderValues[3],
573             orderValues[0],
574             orderValues[1],
575             orderValues[4],
576             buyNoMoreThanAmountB,
577             false,
578             0x0,
579             marginSplitPercentage,
580             0,
581             0,
582             0,
583             0,
584             0,
585             0,
586             0
587         );
588         require(msg.sender == order.owner); // "cancelOrder not submitted by order owner");
589         bytes32 orderHash = calculateOrderHash(order);
590         verifySignature(
591             order.owner,
592             orderHash,
593             v,
594             r,
595             s
596         );
597         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
598         delegate.addCancelled(orderHash, cancelAmount);
599         delegate.addCancelledOrFilled(orderHash, cancelAmount);
600         emit OrderCancelled(orderHash, cancelAmount);
601     }
602     function cancelAllOrdersByTradingPair(
603         address token1,
604         address token2,
605         uint    cutoff
606         )
607         external
608     {
609         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
610         bytes20 tokenPair = bytes20(token1) ^ bytes20(token2);
611         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
612         require(delegate.tradingPairCutoffs(msg.sender, tokenPair) < t);
613         // "attempted to set cutoff to a smaller value"
614         delegate.setTradingPairCutoffs(tokenPair, t);
615         emit OrdersCancelled(
616             msg.sender,
617             token1,
618             token2,
619             t
620         );
621     }
622     function cancelAllOrders(
623         uint cutoff
624         )
625         external
626     {
627         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
628         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
629         require(delegate.cutoffs(msg.sender) < t); // "attempted to set cutoff to a smaller value"
630         delegate.setCutoffs(t);
631         emit AllOrdersCancelled(msg.sender, t);
632     }
633     function submitRing(
634         address[4][]  addressList,
635         uint[6][]     uintArgsList,
636         uint8[1][]    uint8ArgsList,
637         bool[]        buyNoMoreThanAmountBList,
638         uint8[]       vList,
639         bytes32[]     rList,
640         bytes32[]     sList,
641         address       feeRecipient,
642         uint16        feeSelections
643         )
644         public
645     {
646         // Check if the highest bit of ringIndex is '1'.
647         require((ringIndex >> 63) == 0); // "attempted to re-ent submitRing function");
648         // Set the highest bit of ringIndex to '1'.
649         uint64 _ringIndex = ringIndex;
650         ringIndex |= (1 << 63);
651         RingParams memory params = RingParams(
652             vList,
653             rList,
654             sList,
655             feeRecipient,
656             feeSelections,
657             addressList.length,
658             0x0 // ringHash
659         );
660         verifyInputDataIntegrity(
661             params,
662             addressList,
663             uintArgsList,
664             uint8ArgsList,
665             buyNoMoreThanAmountBList
666         );
667         // Assemble input data into structs so we can pass them to other functions.
668         // This method also calculates ringHash, therefore it must be called before
669         // calling `verifyRingSignatures`.
670         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
671         OrderState[] memory orders = assembleOrders(
672             params,
673             delegate,
674             addressList,
675             uintArgsList,
676             uint8ArgsList,
677             buyNoMoreThanAmountBList
678         );
679         verifyRingSignatures(params, orders);
680         verifyTokensRegistered(params, orders);
681         handleRing(_ringIndex, params, orders, delegate);
682         ringIndex = _ringIndex + 1;
683     }
684     /// @dev Validate a ring.
685     function verifyRingHasNoSubRing(
686         uint          ringSize,
687         OrderState[]  orders
688         )
689         private
690         pure
691     {
692         // Check the ring has no sub-ring.
693         for (uint i = 0; i < ringSize - 1; i++) {
694             address tokenS = orders[i].tokenS;
695             for (uint j = i + 1; j < ringSize; j++) {
696                 require(tokenS != orders[j].tokenS); // "found sub-ring");
697             }
698         }
699     }
700     /// @dev Verify the ringHash has been signed with each order's auth private
701     ///      keys as well as the miner's private key.
702     function verifyRingSignatures(
703         RingParams params,
704         OrderState[] orders
705         )
706         private
707         pure
708     {
709         uint j;
710         for (uint i = 0; i < params.ringSize; i++) {
711             j = i + params.ringSize;
712             verifySignature(
713                 orders[i].authAddr,
714                 params.ringHash,
715                 params.vList[j],
716                 params.rList[j],
717                 params.sList[j]
718             );
719         }
720     }
721     function verifyTokensRegistered(
722         RingParams params,
723         OrderState[] orders
724         )
725         private
726         view
727     {
728         // Extract the token addresses
729         address[] memory tokens = new address[](params.ringSize);
730         for (uint i = 0; i < params.ringSize; i++) {
731             tokens[i] = orders[i].tokenS;
732         }
733         // Test all token addresses at once
734         require(
735             TokenRegistry(tokenRegistryAddress).areAllTokensRegistered(tokens)
736         ); // "token not registered");
737     }
738     function handleRing(
739         uint64       _ringIndex,
740         RingParams   params,
741         OrderState[] orders,
742         TokenTransferDelegate delegate
743         )
744         private
745     {
746         address _lrcTokenAddress = lrcTokenAddress;
747         // Do the hard work.
748         verifyRingHasNoSubRing(params.ringSize, orders);
749         // Exchange rates calculation are performed by ring-miners as solidity
750         // cannot get power-of-1/n operation, therefore we have to verify
751         // these rates are correct.
752         verifyMinerSuppliedFillRates(params.ringSize, orders);
753         // Scale down each order independently by substracting amount-filled and
754         // amount-cancelled. Order owner's current balance and allowance are
755         // not taken into consideration in these operations.
756         scaleRingBasedOnHistoricalRecords(delegate, params.ringSize, orders);
757         // Based on the already verified exchange rate provided by ring-miners,
758         // we can furthur scale down orders based on token balance and allowance,
759         // then find the smallest order of the ring, then calculate each order's
760         // `fillAmountS`.
761         calculateRingFillAmount(params.ringSize, orders);
762         // Calculate each order's `lrcFee` and `lrcRewrard` and splict how much
763         // of `fillAmountS` shall be paid to matching order or miner as margin
764         // split.
765         calculateRingFees(
766             delegate,
767             params.ringSize,
768             orders,
769             _lrcTokenAddress
770         );
771         /// Make transfers.
772         bytes32[] memory orderInfoList = settleRing(
773             delegate,
774             params.ringSize,
775             orders,
776             params.feeRecipient,
777             _lrcTokenAddress
778         );
779         emit RingMined(
780             _ringIndex,
781             params.ringHash,
782             tx.origin,
783             params.feeRecipient,
784             orderInfoList
785         );
786     }
787     function settleRing(
788         TokenTransferDelegate delegate,
789         uint          ringSize,
790         OrderState[]  orders,
791         address       feeRecipient,
792         address       _lrcTokenAddress
793         )
794         private
795         returns (bytes32[] memory orderInfoList)
796     {
797         bytes32[] memory batch = new bytes32[](ringSize * 7); // ringSize * (owner + tokenS + 4 amounts + wallet)
798         bytes32[] memory historyBatch = new bytes32[](ringSize * 2); // ringSize * (orderhash, fillAmount)
799         orderInfoList = new bytes32[](ringSize * 7);
800         uint p = 0;
801         uint q = 0;
802         uint r = 0;
803         uint prevSplitB = orders[ringSize - 1].splitB;
804         for (uint i = 0; i < ringSize; i++) {
805             OrderState memory state = orders[i];
806             uint nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
807             // Store owner and tokenS of every order
808             batch[p++] = bytes32(state.owner);
809             batch[p++] = bytes32(state.tokenS);
810             // Store all amounts
811             batch[p++] = bytes32(state.fillAmountS.sub(prevSplitB));
812             batch[p++] = bytes32(prevSplitB.add(state.splitS));
813             batch[p++] = bytes32(state.lrcReward);
814             batch[p++] = bytes32(state.lrcFeeState);
815             batch[p++] = bytes32(state.wallet);
816             historyBatch[r++] = state.orderHash;
817             historyBatch[r++] = bytes32(
818                 state.buyNoMoreThanAmountB ? nextFillAmountS : state.fillAmountS);
819             orderInfoList[q++] = bytes32(state.orderHash);
820             orderInfoList[q++] = bytes32(state.owner);
821             orderInfoList[q++] = bytes32(state.tokenS);
822             orderInfoList[q++] = bytes32(state.fillAmountS);
823             orderInfoList[q++] = bytes32(state.lrcReward);
824             orderInfoList[q++] = bytes32(
825                 state.lrcFeeState > 0 ? int(state.lrcFeeState) : -int(state.lrcReward)
826             );
827             orderInfoList[q++] = bytes32(
828                 state.splitS > 0 ? int(state.splitS) : -int(state.splitB)
829             );
830             prevSplitB = state.splitB;
831         }
832         // Update fill records
833         delegate.batchAddCancelledOrFilled(historyBatch);
834         // Do all transactions
835         delegate.batchTransferToken(
836             _lrcTokenAddress,
837             tx.origin,
838             feeRecipient,
839             walletSplitPercentage,
840             batch
841         );
842     }
843     /// @dev Verify miner has calculte the rates correctly.
844     function verifyMinerSuppliedFillRates(
845         uint         ringSize,
846         OrderState[] orders
847         )
848         private
849         pure
850     {
851         uint[] memory rateRatios = new uint[](ringSize);
852         uint _rateRatioScale = RATE_RATIO_SCALE;
853         for (uint i = 0; i < ringSize; i++) {
854             uint s1b0 = orders[i].rateS.mul(orders[i].amountB);
855             uint s0b1 = orders[i].amountS.mul(orders[i].rateB);
856             require(s1b0 <= s0b1); // "miner supplied exchange rate provides invalid discount");
857             rateRatios[i] = _rateRatioScale.mul(s1b0) / s0b1;
858         }
859         uint cvs = MathUint.cvsquare(rateRatios, _rateRatioScale);
860         require(cvs <= rateRatioCVSThreshold);
861         // "miner supplied exchange rate is not evenly discounted");
862     }
863     /// @dev Calculate each order's fee or LRC reward.
864     function calculateRingFees(
865         TokenTransferDelegate delegate,
866         uint            ringSize,
867         OrderState[]    orders,
868         address         _lrcTokenAddress
869         )
870         private
871         view
872     {
873         bool checkedMinerLrcSpendable = false;
874         uint minerLrcSpendable = 0;
875         uint8 _marginSplitPercentageBase = MARGIN_SPLIT_PERCENTAGE_BASE;
876         uint nextFillAmountS;
877         for (uint i = 0; i < ringSize; i++) {
878             OrderState memory state = orders[i];
879             uint lrcReceiable = 0;
880             if (state.lrcFeeState == 0) {
881                 // When an order's LRC fee is 0 or smaller than the specified fee,
882                 // we help miner automatically select margin-split.
883                 state.marginSplitAsFee = true;
884                 state.marginSplitPercentage = _marginSplitPercentageBase;
885             } else {
886                 uint lrcSpendable = getSpendable(
887                     delegate,
888                     _lrcTokenAddress,
889                     state.owner
890                 );
891                 // If the order is selling LRC, we need to calculate how much LRC
892                 // is left that can be used as fee.
893                 if (state.tokenS == _lrcTokenAddress) {
894                     lrcSpendable = lrcSpendable.sub(state.fillAmountS);
895                 }
896                 // If the order is buyign LRC, it will has more to pay as fee.
897                 if (state.tokenB == _lrcTokenAddress) {
898                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
899                     lrcReceiable = nextFillAmountS;
900                 }
901                 uint lrcTotal = lrcSpendable.add(lrcReceiable);
902                 // If order doesn't have enough LRC, set margin split to 100%.
903                 if (lrcTotal < state.lrcFeeState) {
904                     state.lrcFeeState = lrcTotal;
905                     state.marginSplitPercentage = _marginSplitPercentageBase;
906                 }
907                 if (state.lrcFeeState == 0) {
908                     state.marginSplitAsFee = true;
909                 }
910             }
911             if (!state.marginSplitAsFee) {
912                 if (lrcReceiable > 0) {
913                     if (lrcReceiable >= state.lrcFeeState) {
914                         state.splitB = state.lrcFeeState;
915                         state.lrcFeeState = 0;
916                     } else {
917                         state.splitB = lrcReceiable;
918                         state.lrcFeeState = state.lrcFeeState.sub(lrcReceiable);
919                     }
920                 }
921             } else {
922                 // Only check the available miner balance when absolutely needed
923                 if (!checkedMinerLrcSpendable && minerLrcSpendable < state.lrcFeeState) {
924                     checkedMinerLrcSpendable = true;
925                     minerLrcSpendable = getSpendable(delegate, _lrcTokenAddress, tx.origin);
926                 }
927                 // Only calculate split when miner has enough LRC;
928                 // otherwise all splits are 0.
929                 if (minerLrcSpendable >= state.lrcFeeState) {
930                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
931                     uint split;
932                     if (state.buyNoMoreThanAmountB) {
933                         split = (nextFillAmountS.mul(
934                             state.amountS
935                         ) / state.amountB).sub(
936                             state.fillAmountS
937                         );
938                     } else {
939                         split = nextFillAmountS.sub(
940                             state.fillAmountS.mul(
941                                 state.amountB
942                             ) / state.amountS
943                         );
944                     }
945                     if (state.marginSplitPercentage != _marginSplitPercentageBase) {
946                         split = split.mul(
947                             state.marginSplitPercentage
948                         ) / _marginSplitPercentageBase;
949                     }
950                     if (state.buyNoMoreThanAmountB) {
951                         state.splitS = split;
952                     } else {
953                         state.splitB = split;
954                     }
955                     // This implicits order with smaller index in the ring will
956                     // be paid LRC reward first, so the orders in the ring does
957                     // mater.
958                     if (split > 0) {
959                         minerLrcSpendable = minerLrcSpendable.sub(state.lrcFeeState);
960                         state.lrcReward = state.lrcFeeState;
961                     }
962                 }
963                 state.lrcFeeState = 0;
964             }
965         }
966     }
967     /// @dev Calculate each order's fill amount.
968     function calculateRingFillAmount(
969         uint          ringSize,
970         OrderState[]  orders
971         )
972         private
973         pure
974     {
975         uint smallestIdx = 0;
976         uint i;
977         uint j;
978         for (i = 0; i < ringSize; i++) {
979             j = (i + 1) % ringSize;
980             smallestIdx = calculateOrderFillAmount(
981                 orders[i],
982                 orders[j],
983                 i,
984                 j,
985                 smallestIdx
986             );
987         }
988         for (i = 0; i < smallestIdx; i++) {
989             calculateOrderFillAmount(
990                 orders[i],
991                 orders[(i + 1) % ringSize],
992                 0,               // Not needed
993                 0,               // Not needed
994                 0                // Not needed
995             );
996         }
997     }
998     /// @return The smallest order's index.
999     function calculateOrderFillAmount(
1000         OrderState state,
1001         OrderState next,
1002         uint       i,
1003         uint       j,
1004         uint       smallestIdx
1005         )
1006         private
1007         pure
1008         returns (uint newSmallestIdx)
1009     {
1010         // Default to the same smallest index
1011         newSmallestIdx = smallestIdx;
1012         uint fillAmountB = state.fillAmountS.mul(
1013             state.rateB
1014         ) / state.rateS;
1015         if (state.buyNoMoreThanAmountB) {
1016             if (fillAmountB > state.amountB) {
1017                 fillAmountB = state.amountB;
1018                 state.fillAmountS = fillAmountB.mul(
1019                     state.rateS
1020                 ) / state.rateB;
1021                 require(state.fillAmountS > 0);
1022                 newSmallestIdx = i;
1023             }
1024             state.lrcFeeState = state.lrcFee.mul(
1025                 fillAmountB
1026             ) / state.amountB;
1027         } else {
1028             state.lrcFeeState = state.lrcFee.mul(
1029                 state.fillAmountS
1030             ) / state.amountS;
1031         }
1032         if (fillAmountB <= next.fillAmountS) {
1033             next.fillAmountS = fillAmountB;
1034         } else {
1035             newSmallestIdx = j;
1036         }
1037     }
1038     /// @dev Scale down all orders based on historical fill or cancellation
1039     ///      stats but key the order's original exchange rate.
1040     function scaleRingBasedOnHistoricalRecords(
1041         TokenTransferDelegate delegate,
1042         uint ringSize,
1043         OrderState[] orders
1044         )
1045         private
1046         view
1047     {
1048         for (uint i = 0; i < ringSize; i++) {
1049             OrderState memory state = orders[i];
1050             uint amount;
1051             if (state.buyNoMoreThanAmountB) {
1052                 amount = state.amountB.tolerantSub(
1053                     delegate.cancelledOrFilled(state.orderHash)
1054                 );
1055                 state.amountS = amount.mul(state.amountS) / state.amountB;
1056                 state.lrcFee = amount.mul(state.lrcFee) / state.amountB;
1057                 state.amountB = amount;
1058             } else {
1059                 amount = state.amountS.tolerantSub(
1060                     delegate.cancelledOrFilled(state.orderHash)
1061                 );
1062                 state.amountB = amount.mul(state.amountB) / state.amountS;
1063                 state.lrcFee = amount.mul(state.lrcFee) / state.amountS;
1064                 state.amountS = amount;
1065             }
1066             require(state.amountS > 0); // "amountS is zero");
1067             require(state.amountB > 0); // "amountB is zero");
1068             uint availableAmountS = getSpendable(delegate, state.tokenS, state.owner);
1069             require(availableAmountS > 0); // "order spendable amountS is zero");
1070             state.fillAmountS = (
1071                 state.amountS < availableAmountS ?
1072                 state.amountS : availableAmountS
1073             );
1074             require(state.fillAmountS > 0);
1075         }
1076     }
1077     /// @return Amount of ERC20 token that can be spent by this contract.
1078     function getSpendable(
1079         TokenTransferDelegate delegate,
1080         address tokenAddress,
1081         address tokenOwner
1082         )
1083         private
1084         view
1085         returns (uint)
1086     {
1087         ERC20 token = ERC20(tokenAddress);
1088         uint allowance = token.allowance(
1089             tokenOwner,
1090             address(delegate)
1091         );
1092         uint balance = token.balanceOf(tokenOwner);
1093         return (allowance < balance ? allowance : balance);
1094     }
1095     /// @dev verify input data's basic integrity.
1096     function verifyInputDataIntegrity(
1097         RingParams params,
1098         address[4][]  addressList,
1099         uint[6][]     uintArgsList,
1100         uint8[1][]    uint8ArgsList,
1101         bool[]        buyNoMoreThanAmountBList
1102         )
1103         private
1104         pure
1105     {
1106         require(params.feeRecipient != 0x0);
1107         require(params.ringSize == addressList.length);
1108         require(params.ringSize == uintArgsList.length);
1109         require(params.ringSize == uint8ArgsList.length);
1110         require(params.ringSize == buyNoMoreThanAmountBList.length);
1111         // Validate ring-mining related arguments.
1112         for (uint i = 0; i < params.ringSize; i++) {
1113             require(uintArgsList[i][5] > 0); // "order rateAmountS is zero");
1114         }
1115         //Check ring size
1116         require(params.ringSize > 1 && params.ringSize <= MAX_RING_SIZE); // "invalid ring size");
1117         uint sigSize = params.ringSize << 1;
1118         require(sigSize == params.vList.length);
1119         require(sigSize == params.rList.length);
1120         require(sigSize == params.sList.length);
1121     }
1122     /// @dev        assmble order parameters into Order struct.
1123     /// @return     A list of orders.
1124     function assembleOrders(
1125         RingParams params,
1126         TokenTransferDelegate delegate,
1127         address[4][]  addressList,
1128         uint[6][]     uintArgsList,
1129         uint8[1][]    uint8ArgsList,
1130         bool[]        buyNoMoreThanAmountBList
1131         )
1132         private
1133         view
1134         returns (OrderState[] memory orders)
1135     {
1136         orders = new OrderState[](params.ringSize);
1137         for (uint i = 0; i < params.ringSize; i++) {
1138             uint[6] memory uintArgs = uintArgsList[i];
1139             bool marginSplitAsFee = (params.feeSelections & (uint16(1) << i)) > 0;
1140             orders[i] = OrderState(
1141                 addressList[i][0],
1142                 addressList[i][1],
1143                 addressList[(i + 1) % params.ringSize][1],
1144                 addressList[i][2],
1145                 addressList[i][3],
1146                 uintArgs[2],
1147                 uintArgs[3],
1148                 uintArgs[0],
1149                 uintArgs[1],
1150                 uintArgs[4],
1151                 buyNoMoreThanAmountBList[i],
1152                 marginSplitAsFee,
1153                 bytes32(0),
1154                 uint8ArgsList[i][0],
1155                 uintArgs[5],
1156                 uintArgs[1],
1157                 0,   // fillAmountS
1158                 0,   // lrcReward
1159                 0,   // lrcFee
1160                 0,   // splitS
1161                 0    // splitB
1162             );
1163             validateOrder(orders[i]);
1164             bytes32 orderHash = calculateOrderHash(orders[i]);
1165             orders[i].orderHash = orderHash;
1166             verifySignature(
1167                 orders[i].owner,
1168                 orderHash,
1169                 params.vList[i],
1170                 params.rList[i],
1171                 params.sList[i]
1172             );
1173             params.ringHash ^= orderHash;
1174         }
1175         validateOrdersCutoffs(orders, delegate);
1176         params.ringHash = keccak256(
1177             params.ringHash,
1178             params.feeRecipient,
1179             params.feeSelections
1180         );
1181     }
1182     /// @dev validate order's parameters are OK.
1183     function validateOrder(
1184         OrderState order
1185         )
1186         private
1187         view
1188     {
1189         require(order.owner != 0x0); // invalid order owner
1190         require(order.tokenS != 0x0); // invalid order tokenS
1191         require(order.tokenB != 0x0); // invalid order tokenB
1192         require(order.amountS != 0); // invalid order amountS
1193         require(order.amountB != 0); // invalid order amountB
1194         require(order.marginSplitPercentage <= MARGIN_SPLIT_PERCENTAGE_BASE);
1195         // invalid order marginSplitPercentage
1196         require(order.validSince <= block.timestamp); // order is too early to match
1197         require(order.validUntil > block.timestamp); // order is expired
1198     }
1199     function validateOrdersCutoffs(OrderState[] orders, TokenTransferDelegate delegate)
1200         private
1201         view
1202     {
1203         address[] memory owners = new address[](orders.length);
1204         bytes20[] memory tradingPairs = new bytes20[](orders.length);
1205         uint[] memory validSinceTimes = new uint[](orders.length);
1206         for (uint i = 0; i < orders.length; i++) {
1207             owners[i] = orders[i].owner;
1208             tradingPairs[i] = bytes20(orders[i].tokenS) ^ bytes20(orders[i].tokenB);
1209             validSinceTimes[i] = orders[i].validSince;
1210         }
1211         delegate.checkCutoffsBatch(owners, tradingPairs, validSinceTimes);
1212     }
1213     /// @dev Get the Keccak-256 hash of order with specified parameters.
1214     function calculateOrderHash(
1215         OrderState order
1216         )
1217         private
1218         pure
1219         returns (bytes32)
1220     {
1221         return keccak256(
1222             delegateAddress,
1223             order.owner,
1224             order.tokenS,
1225             order.tokenB,
1226             order.wallet,
1227             order.authAddr,
1228             order.amountS,
1229             order.amountB,
1230             order.validSince,
1231             order.validUntil,
1232             order.lrcFee,
1233             order.buyNoMoreThanAmountB,
1234             order.marginSplitPercentage
1235         );
1236     }
1237     /// @dev Verify signer's signature.
1238     function verifySignature(
1239         address signer,
1240         bytes32 hash,
1241         uint8   v,
1242         bytes32 r,
1243         bytes32 s
1244         )
1245         private
1246         pure
1247     {
1248         require(
1249             signer == ecrecover(
1250                 keccak256("\x19Ethereum Signed Message:\n32", hash),
1251                 v,
1252                 r,
1253                 s
1254             )
1255         ); // "invalid signature");
1256     }
1257     function getTradingPairCutoffs(
1258         address orderOwner,
1259         address token1,
1260         address token2
1261         )
1262         public
1263         view
1264         returns (uint)
1265     {
1266         bytes20 tokenPair = bytes20(token1) ^ bytes20(token2);
1267         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
1268         return delegate.tradingPairCutoffs(orderOwner, tokenPair);
1269     }
1270 }