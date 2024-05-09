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
208         bytes32[]       _orderInfoList
209     );
210     event OrderCancelled(
211         bytes32 indexed _orderHash,
212         uint            _amountCancelled
213     );
214     event AllOrdersCancelled(
215         address indexed _address,
216         uint            _cutoff
217     );
218     event OrdersCancelled(
219         address indexed _address,
220         address         _token1,
221         address         _token2,
222         uint            _cutoff
223     );
224     /// @dev Cancel a order. cancel amount(amountS or amountB) can be specified
225     ///      in orderValues.
226     /// @param addresses          owner, tokenS, tokenB, wallet, authAddr
227     /// @param orderValues        amountS, amountB, validSince (second),
228     ///                           validUntil (second), lrcFee, and cancelAmount.
229     /// @param buyNoMoreThanAmountB -
230     ///                           This indicates when a order should be considered
231     ///                           as 'completely filled'.
232     /// @param marginSplitPercentage -
233     ///                           Percentage of margin split to share with miner.
234     /// @param v                  Order ECDSA signature parameter v.
235     /// @param r                  Order ECDSA signature parameters r.
236     /// @param s                  Order ECDSA signature parameters s.
237     function cancelOrder(
238         address[5] addresses,
239         uint[6]    orderValues,
240         bool       buyNoMoreThanAmountB,
241         uint8      marginSplitPercentage,
242         uint8      v,
243         bytes32    r,
244         bytes32    s
245         )
246         external;
247     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
248     ///        is smaller than or equal to the new value of the address's cutoff
249     ///        timestamp, for a specific trading pair.
250     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
251     ///        if it is 0.
252     function cancelAllOrdersByTradingPair(
253         address token1,
254         address token2,
255         uint cutoff
256         )
257         external;
258     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
259     ///        is smaller than or equal to the new value of the address's cutoff
260     ///        timestamp.
261     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
262     ///        if it is 0.
263     function cancelAllOrders(
264         uint cutoff
265         )
266         external;
267     /// @dev Submit a order-ring for validation and settlement.
268     /// @param addressList  List of each order's owner, tokenS, wallet, authAddr.
269     ///                     Note that next order's `tokenS` equals this order's
270     ///                     `tokenB`.
271     /// @param uintArgsList List of uint-type arguments in this order:
272     ///                     amountS, amountB, validSince (second),
273     ///                     validUntil (second), lrcFee, and rateAmountS.
274     /// @param uint8ArgsList -
275     ///                     List of unit8-type arguments, in this order:
276     ///                     marginSplitPercentageList.
277     /// @param buyNoMoreThanAmountBList -
278     ///                     This indicates when a order should be considered
279     /// @param vList        List of v for each order. This list is 1-larger than
280     ///                     the previous lists, with the last element being the
281     ///                     v value of the ring signature.
282     /// @param rList        List of r for each order. This list is 1-larger than
283     ///                     the previous lists, with the last element being the
284     ///                     r value of the ring signature.
285     /// @param sList        List of s for each order. This list is 1-larger than
286     ///                     the previous lists, with the last element being the
287     ///                     s value of the ring signature.
288     /// @param miner        Miner address.
289     /// @param feeSelections -
290     ///                     Bits to indicate fee selections. `1` represents margin
291     ///                     split and `0` represents LRC as fee.
292     function submitRing(
293         address[4][]    addressList,
294         uint[6][]       uintArgsList,
295         uint8[1][]      uint8ArgsList,
296         bool[]          buyNoMoreThanAmountBList,
297         uint8[]         vList,
298         bytes32[]       rList,
299         bytes32[]       sList,
300         address         miner,
301         uint16          feeSelections
302         )
303         public;
304 }
305 /*
306   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
307   Licensed under the Apache License, Version 2.0 (the "License");
308   you may not use this file except in compliance with the License.
309   You may obtain a copy of the License at
310   http://www.apache.org/licenses/LICENSE-2.0
311   Unless required by applicable law or agreed to in writing, software
312   distributed under the License is distributed on an "AS IS" BASIS,
313   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
314   See the License for the specific language governing permissions and
315   limitations under the License.
316 */
317 /// @title Token Register Contract
318 /// @dev This contract maintains a list of tokens the Protocol supports.
319 /// @author Kongliang Zhong - <kongliang@loopring.org>,
320 /// @author Daniel Wang - <daniel@loopring.org>.
321 contract TokenRegistry {
322     event TokenRegistered(
323         address indexed addr,
324         string          symbol
325     );
326     event TokenUnregistered(
327         address indexed addr,
328         string          symbol
329     );
330     function registerToken(
331         address addr,
332         string  symbol
333         )
334         external;
335     function registerMintedToken(
336         address addr,
337         string  symbol
338         )
339         external;
340     function unregisterToken(
341         address addr,
342         string  symbol
343         )
344         external;
345     function areAllTokensRegistered(
346         address[] addressList
347         )
348         external
349         view
350         returns (bool);
351     function getAddressBySymbol(
352         string symbol
353         )
354         external
355         view
356         returns (address);
357     function isTokenRegisteredBySymbol(
358         string symbol
359         )
360         public
361         view
362         returns (bool);
363     function isTokenRegistered(
364         address addr
365         )
366         public
367         view
368         returns (bool);
369     function getTokens(
370         uint start,
371         uint count
372         )
373         public
374         view
375         returns (address[] addressList);
376 }
377 /*
378   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
379   Licensed under the Apache License, Version 2.0 (the "License");
380   you may not use this file except in compliance with the License.
381   You may obtain a copy of the License at
382   http://www.apache.org/licenses/LICENSE-2.0
383   Unless required by applicable law or agreed to in writing, software
384   distributed under the License is distributed on an "AS IS" BASIS,
385   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
386   See the License for the specific language governing permissions and
387   limitations under the License.
388 */
389 /// @title TokenTransferDelegate
390 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
391 /// versions of Loopring protocol to avoid ERC20 re-authorization.
392 /// @author Daniel Wang - <daniel@loopring.org>.
393 contract TokenTransferDelegate {
394     event AddressAuthorized(
395         address indexed addr,
396         uint32          number
397     );
398     event AddressDeauthorized(
399         address indexed addr,
400         uint32          number
401     );
402     // The following map is used to keep trace of order fill and cancellation
403     // history.
404     mapping (bytes32 => uint) public cancelledOrFilled;
405     // This map is used to keep trace of order's cancellation history.
406     mapping (bytes32 => uint) public cancelled;
407     // A map from address to its cutoff timestamp.
408     mapping (address => uint) public cutoffs;
409     // A map from address to its trading-pair cutoff timestamp.
410     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
411     /// @dev Add a Loopring protocol address.
412     /// @param addr A loopring protocol address.
413     function authorizeAddress(
414         address addr
415         )
416         external;
417     /// @dev Remove a Loopring protocol address.
418     /// @param addr A loopring protocol address.
419     function deauthorizeAddress(
420         address addr
421         )
422         external;
423     function getLatestAuthorizedAddresses(
424         uint max
425         )
426         external
427         view
428         returns (address[] addresses);
429     /// @dev Invoke ERC20 transferFrom method.
430     /// @param token Address of token to transfer.
431     /// @param from Address to transfer token from.
432     /// @param to Address to transfer token to.
433     /// @param value Amount of token to transfer.
434     function transferToken(
435         address token,
436         address from,
437         address to,
438         uint    value
439         )
440         external;
441     function batchTransferToken(
442         address lrcTokenAddress,
443         address minerFeeRecipient,
444         uint8 walletSplitPercentage,
445         bytes32[] batch
446         )
447         external;
448     function isAddressAuthorized(
449         address addr
450         )
451         public
452         view
453         returns (bool);
454     function addCancelled(bytes32 orderHash, uint cancelAmount)
455         external;
456     function addCancelledOrFilled(bytes32 orderHash, uint cancelOrFillAmount)
457         public;
458     function batchAddCancelledOrFilled(bytes32[] batch)
459         public;
460     function setCutoffs(uint t)
461         external;
462     function setTradingPairCutoffs(bytes20 tokenPair, uint t)
463         external;
464     function checkCutoffsBatch(address[] owners, bytes20[] tradingPairs, uint[] validSince)
465         external
466         view;
467     function suspend() external;
468     function resume() external;
469     function kill() external;
470 }
471 /// @title An Implementation of LoopringProtocol.
472 /// @author Daniel Wang - <daniel@loopring.org>,
473 /// @author Kongliang Zhong - <kongliang@loopring.org>
474 ///
475 /// Recognized contributing developers from the community:
476 ///     https://github.com/Brechtpd
477 ///     https://github.com/rainydio
478 ///     https://github.com/BenjaminPrice
479 ///     https://github.com/jonasshen
480 ///     https://github.com/Hephyrius
481 contract LoopringProtocolImpl is LoopringProtocol {
482     using AddressUtil   for address;
483     using MathUint      for uint;
484     address public constant lrcTokenAddress             = 0xEF68e7C694F40c8202821eDF525dE3782458639f;
485     address public constant tokenRegistryAddress        = 0x004DeF62C71992615CF22786d0b7Efb22850Df4a;
486     address public constant delegateAddress             = 0xD22f97BCEc8E029e109412763b889fC16C4bca8B;
487     uint64  public  ringIndex                   = 0;
488     uint8   public constant walletSplitPercentage       = 20;
489     // Exchange rate (rate) is the amount to sell or sold divided by the amount
490     // to buy or bought.
491     //
492     // Rate ratio is the ratio between executed rate and an order's original
493     // rate.
494     //
495     // To require all orders' rate ratios to have coefficient ofvariation (CV)
496     // smaller than 2.5%, for an example , rateRatioCVSThreshold should be:
497     //     `(0.025 * RATE_RATIO_SCALE)^2` or 62500.
498     uint    public constant rateRatioCVSThreshold        = 62500;
499     uint    public constant MAX_RING_SIZE       = 16;
500     uint    public constant RATE_RATIO_SCALE    = 10000;
501     /// @param orderHash    The order's hash
502     /// @param feeSelection -
503     ///                     A miner-supplied value indicating if LRC (value = 0)
504     ///                     or margin split is choosen by the miner (value = 1).
505     ///                     We may support more fee model in the future.
506     /// @param rateS        Sell Exchange rate provided by miner.
507     /// @param rateB        Buy Exchange rate provided by miner.
508     /// @param fillAmountS  Amount of tokenS to sell, calculated by protocol.
509     /// @param lrcReward    The amount of LRC paid by miner to order owner in
510     ///                     exchange for margin split.
511     /// @param lrcFeeState  The amount of LR paid by order owner to miner.
512     /// @param splitS      TokenS paid to miner.
513     /// @param splitB      TokenB paid to miner.
514     struct OrderState {
515         address owner;
516         address tokenS;
517         address tokenB;
518         address wallet;
519         address authAddr;
520         uint    validSince;
521         uint    validUntil;
522         uint    amountS;
523         uint    amountB;
524         uint    lrcFee;
525         bool    buyNoMoreThanAmountB;
526         bool    marginSplitAsFee;
527         bytes32 orderHash;
528         uint8   marginSplitPercentage;
529         uint    rateS;
530         uint    rateB;
531         uint    fillAmountS;
532         uint    lrcReward;
533         uint    lrcFeeState;
534         uint    splitS;
535         uint    splitB;
536     }
537     /// @dev A struct to capture parameters passed to submitRing method and
538     ///      various of other variables used across the submitRing core logics.
539     struct RingParams {
540         uint8[]       vList;
541         bytes32[]     rList;
542         bytes32[]     sList;
543         address       miner;
544         uint16        feeSelections;
545         uint          ringSize;         // computed
546         bytes32       ringHash;         // computed
547     }
548     /// @dev Disable default function.
549     function ()
550         payable
551         public
552     {
553         revert();
554     }
555     function cancelOrder(
556         address[5] addresses,
557         uint[6]    orderValues,
558         bool       buyNoMoreThanAmountB,
559         uint8      marginSplitPercentage,
560         uint8      v,
561         bytes32    r,
562         bytes32    s
563         )
564         external
565     {
566         uint cancelAmount = orderValues[5];
567         require(cancelAmount > 0); // "amount to cancel is zero");
568         OrderState memory order = OrderState(
569             addresses[0],
570             addresses[1],
571             addresses[2],
572             addresses[3],
573             addresses[4],
574             orderValues[2],
575             orderValues[3],
576             orderValues[0],
577             orderValues[1],
578             orderValues[4],
579             buyNoMoreThanAmountB,
580             false,
581             0x0,
582             marginSplitPercentage,
583             0,
584             0,
585             0,
586             0,
587             0,
588             0,
589             0
590         );
591         require(msg.sender == order.owner); // "cancelOrder not submitted by order owner");
592         bytes32 orderHash = calculateOrderHash(order);
593         verifySignature(
594             order.owner,
595             orderHash,
596             v,
597             r,
598             s
599         );
600         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
601         delegate.addCancelled(orderHash, cancelAmount);
602         delegate.addCancelledOrFilled(orderHash, cancelAmount);
603         emit OrderCancelled(orderHash, cancelAmount);
604     }
605     function cancelAllOrdersByTradingPair(
606         address token1,
607         address token2,
608         uint    cutoff
609         )
610         external
611     {
612         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
613         bytes20 tokenPair = bytes20(token1) ^ bytes20(token2);
614         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
615         require(delegate.tradingPairCutoffs(msg.sender, tokenPair) < t);
616         // "attempted to set cutoff to a smaller value"
617         delegate.setTradingPairCutoffs(tokenPair, t);
618         emit OrdersCancelled(
619             msg.sender,
620             token1,
621             token2,
622             t
623         );
624     }
625     function cancelAllOrders(
626         uint cutoff
627         )
628         external
629     {
630         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
631         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
632         require(delegate.cutoffs(msg.sender) < t); // "attempted to set cutoff to a smaller value"
633         delegate.setCutoffs(t);
634         emit AllOrdersCancelled(msg.sender, t);
635     }
636     function submitRing(
637         address[4][]  addressList,
638         uint[6][]     uintArgsList,
639         uint8[1][]    uint8ArgsList,
640         bool[]        buyNoMoreThanAmountBList,
641         uint8[]       vList,
642         bytes32[]     rList,
643         bytes32[]     sList,
644         address       miner,
645         uint16        feeSelections
646         )
647         public
648     {
649         // Check if the highest bit of ringIndex is '1'.
650         require((ringIndex >> 63) == 0); // "attempted to re-ent submitRing function");
651         // Set the highest bit of ringIndex to '1'.
652         uint64 _ringIndex = ringIndex;
653         ringIndex |= (1 << 63);
654         RingParams memory params = RingParams(
655             vList,
656             rList,
657             sList,
658             miner,
659             feeSelections,
660             addressList.length,
661             0x0 // ringHash
662         );
663         verifyInputDataIntegrity(
664             params,
665             addressList,
666             uintArgsList,
667             uint8ArgsList,
668             buyNoMoreThanAmountBList
669         );
670         // Assemble input data into structs so we can pass them to other functions.
671         // This method also calculates ringHash, therefore it must be called before
672         // calling `verifyRingSignatures`.
673         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
674         OrderState[] memory orders = assembleOrders(
675             params,
676             delegate,
677             addressList,
678             uintArgsList,
679             uint8ArgsList,
680             buyNoMoreThanAmountBList
681         );
682         verifyRingSignatures(params, orders);
683         verifyTokensRegistered(params, orders);
684         handleRing(_ringIndex, params, orders, delegate);
685         ringIndex = _ringIndex + 1;
686     }
687     /// @dev Validate a ring.
688     function verifyRingHasNoSubRing(
689         uint          ringSize,
690         OrderState[]  orders
691         )
692         private
693         pure
694     {
695         // Check the ring has no sub-ring.
696         for (uint i = 0; i < ringSize - 1; i++) {
697             address tokenS = orders[i].tokenS;
698             for (uint j = i + 1; j < ringSize; j++) {
699                 require(tokenS != orders[j].tokenS); // "found sub-ring");
700             }
701         }
702     }
703     /// @dev Verify the ringHash has been signed with each order's auth private
704     ///      keys as well as the miner's private key.
705     function verifyRingSignatures(
706         RingParams params,
707         OrderState[] orders
708         )
709         private
710         pure
711     {
712         uint j;
713         for (uint i = 0; i < params.ringSize; i++) {
714             j = i + params.ringSize;
715             verifySignature(
716                 orders[i].authAddr,
717                 params.ringHash,
718                 params.vList[j],
719                 params.rList[j],
720                 params.sList[j]
721             );
722         }
723     }
724     function verifyTokensRegistered(
725         RingParams params,
726         OrderState[] orders
727         )
728         private
729         view
730     {
731         // Extract the token addresses
732         address[] memory tokens = new address[](params.ringSize);
733         for (uint i = 0; i < params.ringSize; i++) {
734             tokens[i] = orders[i].tokenS;
735         }
736         // Test all token addresses at once
737         require(
738             TokenRegistry(tokenRegistryAddress).areAllTokensRegistered(tokens)
739         ); // "token not registered");
740     }
741     function handleRing(
742         uint64       _ringIndex,
743         RingParams   params,
744         OrderState[] orders,
745         TokenTransferDelegate delegate
746         )
747         private
748     {
749         address _lrcTokenAddress = lrcTokenAddress;
750         // Do the hard work.
751         verifyRingHasNoSubRing(params.ringSize, orders);
752         // Exchange rates calculation are performed by ring-miners as solidity
753         // cannot get power-of-1/n operation, therefore we have to verify
754         // these rates are correct.
755         verifyMinerSuppliedFillRates(params.ringSize, orders);
756         // Scale down each order independently by substracting amount-filled and
757         // amount-cancelled. Order owner's current balance and allowance are
758         // not taken into consideration in these operations.
759         scaleRingBasedOnHistoricalRecords(delegate, params.ringSize, orders);
760         // Based on the already verified exchange rate provided by ring-miners,
761         // we can furthur scale down orders based on token balance and allowance,
762         // then find the smallest order of the ring, then calculate each order's
763         // `fillAmountS`.
764         calculateRingFillAmount(params.ringSize, orders);
765         // Calculate each order's `lrcFee` and `lrcRewrard` and splict how much
766         // of `fillAmountS` shall be paid to matching order or miner as margin
767         // split.
768         calculateRingFees(
769             delegate,
770             params.ringSize,
771             orders,
772             params.miner,
773             _lrcTokenAddress
774         );
775         /// Make transfers.
776         bytes32[] memory orderInfoList = settleRing(
777             delegate,
778             params.ringSize,
779             orders,
780             params.miner,
781             _lrcTokenAddress
782         );
783         emit RingMined(
784             _ringIndex,
785             params.ringHash,
786             params.miner,
787             orderInfoList
788         );
789     }
790     function settleRing(
791         TokenTransferDelegate delegate,
792         uint          ringSize,
793         OrderState[]  orders,
794         address       miner,
795         address       _lrcTokenAddress
796         )
797         private
798         returns (bytes32[] memory orderInfoList)
799     {
800         bytes32[] memory batch = new bytes32[](ringSize * 7); // ringSize * (owner + tokenS + 4 amounts + wallet)
801         bytes32[] memory historyBatch = new bytes32[](ringSize * 2); // ringSize * (orderhash, fillAmount)
802         orderInfoList = new bytes32[](ringSize * 7);
803         uint p = 0;
804         uint q = 0;
805         uint r = 0;
806         uint prevSplitB = orders[ringSize - 1].splitB;
807         for (uint i = 0; i < ringSize; i++) {
808             OrderState memory state = orders[i];
809             uint nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
810             // Store owner and tokenS of every order
811             batch[p++] = bytes32(state.owner);
812             batch[p++] = bytes32(state.tokenS);
813             // Store all amounts
814             batch[p++] = bytes32(state.fillAmountS.sub(prevSplitB));
815             batch[p++] = bytes32(prevSplitB.add(state.splitS));
816             batch[p++] = bytes32(state.lrcReward);
817             batch[p++] = bytes32(state.lrcFeeState);
818             batch[p++] = bytes32(state.wallet);
819             historyBatch[r++] = state.orderHash;
820             historyBatch[r++] = bytes32(
821                 state.buyNoMoreThanAmountB ? nextFillAmountS : state.fillAmountS);
822             orderInfoList[q++] = bytes32(state.orderHash);
823             orderInfoList[q++] = bytes32(state.owner);
824             orderInfoList[q++] = bytes32(state.tokenS);
825             orderInfoList[q++] = bytes32(state.fillAmountS);
826             orderInfoList[q++] = bytes32(state.lrcReward);
827             orderInfoList[q++] = bytes32(
828                 state.lrcFeeState > 0 ? int(state.lrcFeeState) : -int(state.lrcReward)
829             );
830             orderInfoList[q++] = bytes32(
831                 state.splitS > 0 ? int(state.splitS) : -int(state.splitB)
832             );
833             prevSplitB = state.splitB;
834         }
835         // Update fill records
836         delegate.batchAddCancelledOrFilled(historyBatch);
837         // Do all transactions
838         delegate.batchTransferToken(
839             _lrcTokenAddress,
840             miner,
841             walletSplitPercentage,
842             batch
843         );
844     }
845     /// @dev Verify miner has calculte the rates correctly.
846     function verifyMinerSuppliedFillRates(
847         uint         ringSize,
848         OrderState[] orders
849         )
850         private
851         pure
852     {
853         uint[] memory rateRatios = new uint[](ringSize);
854         uint _rateRatioScale = RATE_RATIO_SCALE;
855         for (uint i = 0; i < ringSize; i++) {
856             uint s1b0 = orders[i].rateS.mul(orders[i].amountB);
857             uint s0b1 = orders[i].amountS.mul(orders[i].rateB);
858             require(s1b0 <= s0b1); // "miner supplied exchange rate provides invalid discount");
859             rateRatios[i] = _rateRatioScale.mul(s1b0) / s0b1;
860         }
861         uint cvs = MathUint.cvsquare(rateRatios, _rateRatioScale);
862         require(cvs <= rateRatioCVSThreshold);
863         // "miner supplied exchange rate is not evenly discounted");
864     }
865     /// @dev Calculate each order's fee or LRC reward.
866     function calculateRingFees(
867         TokenTransferDelegate delegate,
868         uint            ringSize,
869         OrderState[]    orders,
870         address         miner,
871         address         _lrcTokenAddress
872         )
873         private
874         view
875     {
876         bool checkedMinerLrcSpendable = false;
877         uint minerLrcSpendable = 0;
878         uint8 _marginSplitPercentageBase = MARGIN_SPLIT_PERCENTAGE_BASE;
879         uint nextFillAmountS;
880         for (uint i = 0; i < ringSize; i++) {
881             OrderState memory state = orders[i];
882             uint lrcReceiable = 0;
883             if (state.lrcFeeState == 0) {
884                 // When an order's LRC fee is 0 or smaller than the specified fee,
885                 // we help miner automatically select margin-split.
886                 state.marginSplitAsFee = true;
887                 state.marginSplitPercentage = _marginSplitPercentageBase;
888             } else {
889                 uint lrcSpendable = getSpendable(
890                     delegate,
891                     _lrcTokenAddress,
892                     state.owner
893                 );
894                 // If the order is selling LRC, we need to calculate how much LRC
895                 // is left that can be used as fee.
896                 if (state.tokenS == _lrcTokenAddress) {
897                     lrcSpendable = lrcSpendable.sub(state.fillAmountS);
898                 }
899                 // If the order is buyign LRC, it will has more to pay as fee.
900                 if (state.tokenB == _lrcTokenAddress) {
901                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
902                     lrcReceiable = nextFillAmountS;
903                 }
904                 uint lrcTotal = lrcSpendable.add(lrcReceiable);
905                 // If order doesn't have enough LRC, set margin split to 100%.
906                 if (lrcTotal < state.lrcFeeState) {
907                     state.lrcFeeState = lrcTotal;
908                     state.marginSplitPercentage = _marginSplitPercentageBase;
909                 }
910                 if (state.lrcFeeState == 0) {
911                     state.marginSplitAsFee = true;
912                 }
913             }
914             if (!state.marginSplitAsFee) {
915                 if (lrcReceiable > 0) {
916                     if (lrcReceiable >= state.lrcFeeState) {
917                         state.splitB = state.lrcFeeState;
918                         state.lrcFeeState = 0;
919                     } else {
920                         state.splitB = lrcReceiable;
921                         state.lrcFeeState = state.lrcFeeState.sub(lrcReceiable);
922                     }
923                 }
924             } else {
925                 // Only check the available miner balance when absolutely needed
926                 if (!checkedMinerLrcSpendable && minerLrcSpendable < state.lrcFeeState) {
927                     checkedMinerLrcSpendable = true;
928                     minerLrcSpendable = getSpendable(delegate, _lrcTokenAddress, miner);
929                 }
930                 // Only calculate split when miner has enough LRC;
931                 // otherwise all splits are 0.
932                 if (minerLrcSpendable >= state.lrcFeeState) {
933                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
934                     uint split;
935                     if (state.buyNoMoreThanAmountB) {
936                         split = (nextFillAmountS.mul(
937                             state.amountS
938                         ) / state.amountB).sub(
939                             state.fillAmountS
940                         );
941                     } else {
942                         split = nextFillAmountS.sub(
943                             state.fillAmountS.mul(
944                                 state.amountB
945                             ) / state.amountS
946                         );
947                     }
948                     if (state.marginSplitPercentage != _marginSplitPercentageBase) {
949                         split = split.mul(
950                             state.marginSplitPercentage
951                         ) / _marginSplitPercentageBase;
952                     }
953                     if (state.buyNoMoreThanAmountB) {
954                         state.splitS = split;
955                     } else {
956                         state.splitB = split;
957                     }
958                     // This implicits order with smaller index in the ring will
959                     // be paid LRC reward first, so the orders in the ring does
960                     // mater.
961                     if (split > 0) {
962                         minerLrcSpendable = minerLrcSpendable.sub(state.lrcFeeState);
963                         state.lrcReward = state.lrcFeeState;
964                     }
965                 }
966                 state.lrcFeeState = 0;
967             }
968         }
969     }
970     /// @dev Calculate each order's fill amount.
971     function calculateRingFillAmount(
972         uint          ringSize,
973         OrderState[]  orders
974         )
975         private
976         pure
977     {
978         uint smallestIdx = 0;
979         uint i;
980         uint j;
981         for (i = 0; i < ringSize; i++) {
982             j = (i + 1) % ringSize;
983             smallestIdx = calculateOrderFillAmount(
984                 orders[i],
985                 orders[j],
986                 i,
987                 j,
988                 smallestIdx
989             );
990         }
991         for (i = 0; i < smallestIdx; i++) {
992             calculateOrderFillAmount(
993                 orders[i],
994                 orders[(i + 1) % ringSize],
995                 0,               // Not needed
996                 0,               // Not needed
997                 0                // Not needed
998             );
999         }
1000     }
1001     /// @return The smallest order's index.
1002     function calculateOrderFillAmount(
1003         OrderState state,
1004         OrderState next,
1005         uint       i,
1006         uint       j,
1007         uint       smallestIdx
1008         )
1009         private
1010         pure
1011         returns (uint newSmallestIdx)
1012     {
1013         // Default to the same smallest index
1014         newSmallestIdx = smallestIdx;
1015         uint fillAmountB = state.fillAmountS.mul(
1016             state.rateB
1017         ) / state.rateS;
1018         if (state.buyNoMoreThanAmountB) {
1019             if (fillAmountB > state.amountB) {
1020                 fillAmountB = state.amountB;
1021                 state.fillAmountS = fillAmountB.mul(
1022                     state.rateS
1023                 ) / state.rateB;
1024                 require(state.fillAmountS > 0);
1025                 newSmallestIdx = i;
1026             }
1027             state.lrcFeeState = state.lrcFee.mul(
1028                 fillAmountB
1029             ) / state.amountB;
1030         } else {
1031             state.lrcFeeState = state.lrcFee.mul(
1032                 state.fillAmountS
1033             ) / state.amountS;
1034         }
1035         if (fillAmountB <= next.fillAmountS) {
1036             next.fillAmountS = fillAmountB;
1037         } else {
1038             newSmallestIdx = j;
1039         }
1040     }
1041     /// @dev Scale down all orders based on historical fill or cancellation
1042     ///      stats but key the order's original exchange rate.
1043     function scaleRingBasedOnHistoricalRecords(
1044         TokenTransferDelegate delegate,
1045         uint ringSize,
1046         OrderState[] orders
1047         )
1048         private
1049         view
1050     {
1051         for (uint i = 0; i < ringSize; i++) {
1052             OrderState memory state = orders[i];
1053             uint amount;
1054             if (state.buyNoMoreThanAmountB) {
1055                 amount = state.amountB.tolerantSub(
1056                     delegate.cancelledOrFilled(state.orderHash)
1057                 );
1058                 state.amountS = amount.mul(state.amountS) / state.amountB;
1059                 state.lrcFee = amount.mul(state.lrcFee) / state.amountB;
1060                 state.amountB = amount;
1061             } else {
1062                 amount = state.amountS.tolerantSub(
1063                     delegate.cancelledOrFilled(state.orderHash)
1064                 );
1065                 state.amountB = amount.mul(state.amountB) / state.amountS;
1066                 state.lrcFee = amount.mul(state.lrcFee) / state.amountS;
1067                 state.amountS = amount;
1068             }
1069             require(state.amountS > 0); // "amountS is zero");
1070             require(state.amountB > 0); // "amountB is zero");
1071             uint availableAmountS = getSpendable(delegate, state.tokenS, state.owner);
1072             require(availableAmountS > 0); // "order spendable amountS is zero");
1073             state.fillAmountS = (
1074                 state.amountS < availableAmountS ?
1075                 state.amountS : availableAmountS
1076             );
1077             require(state.fillAmountS > 0);
1078         }
1079     }
1080     /// @return Amount of ERC20 token that can be spent by this contract.
1081     function getSpendable(
1082         TokenTransferDelegate delegate,
1083         address tokenAddress,
1084         address tokenOwner
1085         )
1086         private
1087         view
1088         returns (uint)
1089     {
1090         ERC20 token = ERC20(tokenAddress);
1091         uint allowance = token.allowance(
1092             tokenOwner,
1093             address(delegate)
1094         );
1095         uint balance = token.balanceOf(tokenOwner);
1096         return (allowance < balance ? allowance : balance);
1097     }
1098     /// @dev verify input data's basic integrity.
1099     function verifyInputDataIntegrity(
1100         RingParams params,
1101         address[4][]  addressList,
1102         uint[6][]     uintArgsList,
1103         uint8[1][]    uint8ArgsList,
1104         bool[]        buyNoMoreThanAmountBList
1105         )
1106         private
1107         pure
1108     {
1109         require(params.miner != 0x0);
1110         require(params.ringSize == addressList.length);
1111         require(params.ringSize == uintArgsList.length);
1112         require(params.ringSize == uint8ArgsList.length);
1113         require(params.ringSize == buyNoMoreThanAmountBList.length);
1114         // Validate ring-mining related arguments.
1115         for (uint i = 0; i < params.ringSize; i++) {
1116             require(uintArgsList[i][5] > 0); // "order rateAmountS is zero");
1117         }
1118         //Check ring size
1119         require(params.ringSize > 1 && params.ringSize <= MAX_RING_SIZE); // "invalid ring size");
1120         uint sigSize = params.ringSize << 1;
1121         require(sigSize == params.vList.length);
1122         require(sigSize == params.rList.length);
1123         require(sigSize == params.sList.length);
1124     }
1125     /// @dev        assmble order parameters into Order struct.
1126     /// @return     A list of orders.
1127     function assembleOrders(
1128         RingParams params,
1129         TokenTransferDelegate delegate,
1130         address[4][]  addressList,
1131         uint[6][]     uintArgsList,
1132         uint8[1][]    uint8ArgsList,
1133         bool[]        buyNoMoreThanAmountBList
1134         )
1135         private
1136         view
1137         returns (OrderState[] memory orders)
1138     {
1139         orders = new OrderState[](params.ringSize);
1140         for (uint i = 0; i < params.ringSize; i++) {
1141             uint[6] memory uintArgs = uintArgsList[i];
1142             bool marginSplitAsFee = (params.feeSelections & (uint16(1) << i)) > 0;
1143             orders[i] = OrderState(
1144                 addressList[i][0],
1145                 addressList[i][1],
1146                 addressList[(i + 1) % params.ringSize][1],
1147                 addressList[i][2],
1148                 addressList[i][3],
1149                 uintArgs[2],
1150                 uintArgs[3],
1151                 uintArgs[0],
1152                 uintArgs[1],
1153                 uintArgs[4],
1154                 buyNoMoreThanAmountBList[i],
1155                 marginSplitAsFee,
1156                 bytes32(0),
1157                 uint8ArgsList[i][0],
1158                 uintArgs[5],
1159                 uintArgs[1],
1160                 0,   // fillAmountS
1161                 0,   // lrcReward
1162                 0,   // lrcFee
1163                 0,   // splitS
1164                 0    // splitB
1165             );
1166             validateOrder(orders[i]);
1167             bytes32 orderHash = calculateOrderHash(orders[i]);
1168             orders[i].orderHash = orderHash;
1169             verifySignature(
1170                 orders[i].owner,
1171                 orderHash,
1172                 params.vList[i],
1173                 params.rList[i],
1174                 params.sList[i]
1175             );
1176             params.ringHash ^= orderHash;
1177         }
1178         validateOrdersCutoffs(orders, delegate);
1179         params.ringHash = keccak256(
1180             params.ringHash,
1181             params.miner,
1182             params.feeSelections
1183         );
1184     }
1185     /// @dev validate order's parameters are OK.
1186     function validateOrder(
1187         OrderState order
1188         )
1189         private
1190         view
1191     {
1192         require(order.owner != 0x0); // invalid order owner
1193         require(order.tokenS != 0x0); // invalid order tokenS
1194         require(order.tokenB != 0x0); // invalid order tokenB
1195         require(order.amountS != 0); // invalid order amountS
1196         require(order.amountB != 0); // invalid order amountB
1197         require(order.marginSplitPercentage <= MARGIN_SPLIT_PERCENTAGE_BASE);
1198         // invalid order marginSplitPercentage
1199         require(order.validSince <= block.timestamp); // order is too early to match
1200         require(order.validUntil > block.timestamp); // order is expired
1201     }
1202     function validateOrdersCutoffs(OrderState[] orders, TokenTransferDelegate delegate)
1203         private
1204         view
1205     {
1206         address[] memory owners = new address[](orders.length);
1207         bytes20[] memory tradingPairs = new bytes20[](orders.length);
1208         uint[] memory validSinceTimes = new uint[](orders.length);
1209         for (uint i = 0; i < orders.length; i++) {
1210             owners[i] = orders[i].owner;
1211             tradingPairs[i] = bytes20(orders[i].tokenS) ^ bytes20(orders[i].tokenB);
1212             validSinceTimes[i] = orders[i].validSince;
1213         }
1214         delegate.checkCutoffsBatch(owners, tradingPairs, validSinceTimes);
1215     }
1216     /// @dev Get the Keccak-256 hash of order with specified parameters.
1217     function calculateOrderHash(
1218         OrderState order
1219         )
1220         private
1221         pure
1222         returns (bytes32)
1223     {
1224         return keccak256(
1225             delegateAddress,
1226             order.owner,
1227             order.tokenS,
1228             order.tokenB,
1229             order.wallet,
1230             order.authAddr,
1231             order.amountS,
1232             order.amountB,
1233             order.validSince,
1234             order.validUntil,
1235             order.lrcFee,
1236             order.buyNoMoreThanAmountB,
1237             order.marginSplitPercentage
1238         );
1239     }
1240     /// @dev Verify signer's signature.
1241     function verifySignature(
1242         address signer,
1243         bytes32 hash,
1244         uint8   v,
1245         bytes32 r,
1246         bytes32 s
1247         )
1248         private
1249         pure
1250     {
1251         require(
1252             signer == ecrecover(
1253                 keccak256("\x19Ethereum Signed Message:\n32", hash),
1254                 v,
1255                 r,
1256                 s
1257             )
1258         ); // "invalid signature");
1259     }
1260     function getTradingPairCutoffs(
1261         address orderOwner,
1262         address token1,
1263         address token2
1264         )
1265         public
1266         view
1267         returns (uint)
1268     {
1269         bytes20 tokenPair = bytes20(token1) ^ bytes20(token2);
1270         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
1271         return delegate.tradingPairCutoffs(orderOwner, tokenPair);
1272     }
1273 }