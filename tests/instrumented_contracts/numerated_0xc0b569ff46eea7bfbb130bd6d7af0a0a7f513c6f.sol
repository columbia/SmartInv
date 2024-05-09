1 // File: contracts/loopring/iface/IBrokerRegistry.sol
2 
3 /*
4 
5   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
6 
7   Licensed under the Apache License, Version 2.0 (the "License");
8   you may not use this file except in compliance with the License.
9   You may obtain a copy of the License at
10 
11   http://www.apache.org/licenses/LICENSE-2.0
12 
13   Unless required by applicable law or agreed to in writing, software
14   distributed under the License is distributed on an "AS IS" BASIS,
15   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
16   See the License for the specific language governing permissions and
17   limitations under the License.
18 */
19 pragma solidity 0.5.7;
20 
21 
22 /// @title IBrokerRegistry
23 /// @dev A broker is an account that can submit orders on behalf of other
24 ///      accounts. When registering a broker, the owner can also specify a
25 ///      pre-deployed BrokerInterceptor to hook into the exchange smart contracts.
26 /// @author Daniel Wang - <daniel@loopring.org>.
27 contract IBrokerRegistry {
28     event BrokerRegistered(
29         address owner,
30         address broker,
31         address interceptor
32     );
33 
34     event BrokerUnregistered(
35         address owner,
36         address broker,
37         address interceptor
38     );
39 
40     event AllBrokersUnregistered(
41         address owner
42     );
43 
44     /// @dev   Validates if the broker was registered for the order owner and
45     ///        returns the possible BrokerInterceptor to be used.
46     /// @param owner The owner of the order
47     /// @param broker The broker of the order
48     /// @return True if the broker was registered for the owner
49     ///         and the BrokerInterceptor to use.
50     function getBroker(
51         address owner,
52         address broker
53         )
54         external
55         view
56         returns(
57             bool registered,
58             address interceptor
59         );
60 
61     /// @dev   Gets all registered brokers for an owner.
62     /// @param owner The owner
63     /// @param start The start index of the list of brokers
64     /// @param count The number of brokers to return
65     /// @return The list of requested brokers and corresponding BrokerInterceptors
66     function getBrokers(
67         address owner,
68         uint    start,
69         uint    count
70         )
71         external
72         view
73         returns (
74             address[] memory brokers,
75             address[] memory interceptors
76         );
77 
78     /// @dev   Registers a broker for msg.sender and an optional
79     ///        corresponding BrokerInterceptor.
80     /// @param broker The broker to register
81     /// @param interceptor The optional BrokerInterceptor to use (0x0 allowed)
82     function registerBroker(
83         address broker,
84         address interceptor
85         )
86         external;
87 
88     /// @dev   Unregisters a broker for msg.sender
89     /// @param broker The broker to unregister
90     function unregisterBroker(
91         address broker
92         )
93         external;
94 
95     /// @dev   Unregisters all brokers for msg.sender
96     function unregisterAllBrokers(
97         )
98         external;
99 }
100 
101 // File: contracts/loopring/iface/IBurnRateTable.sol
102 
103 /*
104 
105   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
106 
107   Licensed under the Apache License, Version 2.0 (the "License");
108   you may not use this file except in compliance with the License.
109   You may obtain a copy of the License at
110 
111   http://www.apache.org/licenses/LICENSE-2.0
112 
113   Unless required by applicable law or agreed to in writing, software
114   distributed under the License is distributed on an "AS IS" BASIS,
115   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
116   See the License for the specific language governing permissions and
117   limitations under the License.
118 */
119 pragma solidity 0.5.7;
120 
121 
122 /// @author Brecht Devos - <brecht@loopring.org>
123 /// @title IBurnRateTable - A contract for managing burn rates for tokens
124 contract IBurnRateTable {
125 
126     struct TokenData {
127         uint    tier;
128         uint    validUntil;
129     }
130 
131     mapping(address => TokenData) public tokens;
132 
133     uint public constant YEAR_TO_SECONDS = 31556952;
134 
135     // Tiers
136     uint8 public constant TIER_4 = 0;
137     uint8 public constant TIER_3 = 1;
138     uint8 public constant TIER_2 = 2;
139     uint8 public constant TIER_1 = 3;
140 
141     uint16 public constant BURN_BASE_PERCENTAGE           =                 100 * 10; // 100%
142 
143     // Cost of upgrading the tier level of a token in a percentage of the total LRC supply
144     uint16 public constant TIER_UPGRADE_COST_PERCENTAGE   =                        1; // 0.1%
145 
146     // Burn rates
147     // Matching
148     uint16 public constant BURN_MATCHING_TIER1            =                       25; // 2.5%
149     uint16 public constant BURN_MATCHING_TIER2            =                  15 * 10; //  15%
150     uint16 public constant BURN_MATCHING_TIER3            =                  30 * 10; //  30%
151     uint16 public constant BURN_MATCHING_TIER4            =                  50 * 10; //  50%
152     // P2P
153     uint16 public constant BURN_P2P_TIER1                 =                       25; // 2.5%
154     uint16 public constant BURN_P2P_TIER2                 =                  15 * 10; //  15%
155     uint16 public constant BURN_P2P_TIER3                 =                  30 * 10; //  30%
156     uint16 public constant BURN_P2P_TIER4                 =                  50 * 10; //  50%
157 
158     event TokenTierUpgraded(
159         address indexed addr,
160         uint            tier
161     );
162 
163     /// @dev   Returns the P2P and matching burn rate for the token.
164     /// @param token The token to get the burn rate for.
165     /// @return The burn rate. The P2P burn rate and matching burn rate
166     ///         are packed together in the lowest 4 bytes.
167     ///         (2 bytes P2P, 2 bytes matching)
168     function getBurnRate(
169         address token
170         )
171         external
172         view
173         returns (uint32 burnRate);
174 
175     /// @dev   Returns the tier of a token.
176     /// @param token The token to get the token tier for.
177     /// @return The tier of the token
178     function getTokenTier(
179         address token
180         )
181         public
182         view
183         returns (uint);
184 
185     /// @dev   Upgrades the tier of a token. Before calling this function,
186     ///        msg.sender needs to approve this contract for the neccessary funds.
187     /// @param token The token to upgrade the tier for.
188     /// @return True if successful, false otherwise.
189     function upgradeTokenTier(
190         address token
191         )
192         external
193         returns (bool);
194 
195 }
196 
197 // File: contracts/loopring/iface/IFeeHolder.sol
198 
199 /*
200 
201   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
202 
203   Licensed under the Apache License, Version 2.0 (the "License");
204   you may not use this file except in compliance with the License.
205   You may obtain a copy of the License at
206 
207   http://www.apache.org/licenses/LICENSE-2.0
208 
209   Unless required by applicable law or agreed to in writing, software
210   distributed under the License is distributed on an "AS IS" BASIS,
211   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
212   See the License for the specific language governing permissions and
213   limitations under the License.
214 */
215 pragma solidity 0.5.7;
216 
217 
218 /// @author Kongliang Zhong - <kongliang@loopring.org>
219 /// @title IFeeHolder - A contract holding fees.
220 contract IFeeHolder {
221 
222     event TokenWithdrawn(
223         address owner,
224         address token,
225         uint value
226     );
227 
228     // A map of all fee balances
229     mapping(address => mapping(address => uint)) public feeBalances;
230 
231     // A map of all the nonces for a withdrawTokenFor request
232     mapping(address => uint) public nonces;
233 
234     /// @dev   Allows withdrawing the tokens to be burned by
235     ///        authorized contracts.
236     /// @param token The token to be used to burn buy and burn LRC
237     /// @param value The amount of tokens to withdraw
238     function withdrawBurned(
239         address token,
240         uint value
241         )
242         external
243         returns (bool success);
244 
245     /// @dev   Allows withdrawing the fee payments funds
246     ///        msg.sender is the recipient of the fee and the address
247     ///        to which the tokens will be sent.
248     /// @param token The token to withdraw
249     /// @param value The amount of tokens to withdraw
250     function withdrawToken(
251         address token,
252         uint value
253         )
254         external
255         returns (bool success);
256 
257     /// @dev   Allows withdrawing the fee payments funds by providing a
258     ///        a signature
259     function withdrawTokenFor(
260       address owner,
261       address token,
262       uint value,
263       address recipient,
264       uint feeValue,
265       address feeRecipient,
266       uint nonce,
267       bytes calldata signature
268       )
269       external
270       returns (bool success);
271 
272     function batchAddFeeBalances(
273         bytes32[] calldata batch
274         )
275         external;
276 }
277 
278 // File: contracts/loopring/iface/IOrderBook.sol
279 
280 /*
281 
282   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
283 
284   Licensed under the Apache License, Version 2.0 (the "License");
285   you may not use this file except in compliance with the License.
286   You may obtain a copy of the License at
287 
288   http://www.apache.org/licenses/LICENSE-2.0
289 
290   Unless required by applicable law or agreed to in writing, software
291   distributed under the License is distributed on an "AS IS" BASIS,
292   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
293   See the License for the specific language governing permissions and
294   limitations under the License.
295 */
296 pragma solidity 0.5.7;
297 
298 
299 /// @title IOrderBook
300 /// @author Daniel Wang - <daniel@loopring.org>.
301 /// @author Kongliang Zhong - <kongliang@loopring.org>.
302 contract IOrderBook {
303     // The map of registered order hashes
304     mapping(bytes32 => bool) public orderSubmitted;
305 
306     /// @dev  Event emitted when an order was successfully submitted
307     ///        orderHash      The hash of the order
308     ///        orderData      The data of the order as passed to submitOrder()
309     event OrderSubmitted(
310         bytes32 orderHash,
311         bytes   orderData
312     );
313 
314     /// @dev   Submits an order to the on-chain order book.
315     ///        No signature is needed. The order can only be sumbitted by its
316     ///        owner or its broker (the owner can be the address of a contract).
317     /// @param orderData The data of the order. Contains all fields that are used
318     ///        for the order hash calculation.
319     ///        See OrderHelper.updateHash() for detailed information.
320     function submitOrder(
321         bytes calldata orderData
322         )
323         external
324         returns (bytes32);
325 }
326 
327 // File: contracts/loopring/iface/IOrderRegistry.sol
328 
329 /*
330 
331   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
332 
333   Licensed under the Apache License, Version 2.0 (the "License");
334   you may not use this file except in compliance with the License.
335   You may obtain a copy of the License at
336 
337   http://www.apache.org/licenses/LICENSE-2.0
338 
339   Unless required by applicable law or agreed to in writing, software
340   distributed under the License is distributed on an "AS IS" BASIS,
341   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
342   See the License for the specific language governing permissions and
343   limitations under the License.
344 */
345 pragma solidity 0.5.7;
346 
347 
348 /// @title IOrderRegistry
349 /// @author Daniel Wang - <daniel@loopring.org>.
350 contract IOrderRegistry {
351 
352     /// @dev   Returns wether the order hash was registered in the registry.
353     /// @param broker The broker of the order
354     /// @param orderHash The hash of the order
355     /// @return True if the order hash was registered, else false.
356     function isOrderHashRegistered(
357         address broker,
358         bytes32 orderHash
359         )
360         external
361         view
362         returns (bool);
363 
364     /// @dev   Registers an order in the registry.
365     ///        msg.sender needs to be the broker of the order.
366     /// @param orderHash The hash of the order
367     function registerOrderHash(
368         bytes32 orderHash
369         )
370         external;
371 }
372 
373 // File: contracts/loopring/impl/BrokerData.sol
374 
375 pragma solidity 0.5.7;
376 
377 library BrokerData {
378 
379   struct BrokerOrder {
380     address owner;
381     bytes32 orderHash;
382     uint fillAmountB;
383     uint requestedAmountS;
384     uint requestedFeeAmount;
385     address tokenRecipient;
386     bytes extraData;
387   }
388 
389   struct BrokerApprovalRequest {
390     BrokerOrder[] orders;
391     address tokenS;
392     address tokenB;
393     address feeToken;
394     uint totalFillAmountB;
395     uint totalRequestedAmountS;
396     uint totalRequestedFeeAmount;
397   }
398 
399   struct BrokerInterceptorReport {
400     address owner;
401     address broker;
402     bytes32 orderHash;
403     address tokenB;
404     address tokenS;
405     address feeToken;
406     uint fillAmountB;
407     uint spentAmountS;
408     uint spentFeeAmount;
409     address tokenRecipient;
410     bytes extraData;
411   }
412 
413 }
414 
415 // File: contracts/loopring/iface/ITradeDelegate.sol
416 
417 /*
418 
419   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
420 
421   Licensed under the Apache License, Version 2.0 (the "License");
422   you may not use this file except in compliance with the License.
423   You may obtain a copy of the License at
424 
425   http://www.apache.org/licenses/LICENSE-2.0
426 
427   Unless required by applicable law or agreed to in writing, software
428   distributed under the License is distributed on an "AS IS" BASIS,
429   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
430   See the License for the specific language governing permissions and
431   limitations under the License.
432 */
433 pragma solidity 0.5.7;
434 pragma experimental ABIEncoderV2;
435 
436 
437 /// @title ITradeDelegate
438 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
439 /// versions of Loopring protocol to avoid ERC20 re-authorization.
440 /// @author Daniel Wang - <daniel@loopring.org>.
441 contract ITradeDelegate {
442 
443     function isTrustedSubmitter(address submitter) public view returns (bool);
444 
445     function batchTransfer(
446         bytes32[] calldata batch
447     ) external;
448 
449     function brokerTransfer(
450         address token,
451         address broker,
452         address recipient,
453         uint amount
454     ) external;
455 
456     function proxyBrokerRequestAllowance(
457         BrokerData.BrokerApprovalRequest memory request,
458         address broker
459     ) public returns (bool);
460 
461 
462     /// @dev Add a Loopring protocol address.
463     /// @param addr A loopring protocol address.
464     function authorizeAddress(
465         address addr
466         )
467         external;
468 
469     /// @dev Remove a Loopring protocol address.
470     /// @param addr A loopring protocol address.
471     function deauthorizeAddress(
472         address addr
473         )
474         external;
475 
476     function isAddressAuthorized(
477         address addr
478         )
479         public
480         view
481         returns (bool);
482 
483 
484     function suspend()
485         external;
486 
487     function resume()
488         external;
489 
490     function kill()
491         external;
492 }
493 
494 // File: contracts/loopring/iface/ITradeHistory.sol
495 
496 /*
497 
498   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
499 
500   Licensed under the Apache License, Version 2.0 (the "License");
501   you may not use this file except in compliance with the License.
502   You may obtain a copy of the License at
503 
504   http://www.apache.org/licenses/LICENSE-2.0
505 
506   Unless required by applicable law or agreed to in writing, software
507   distributed under the License is distributed on an "AS IS" BASIS,
508   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
509   See the License for the specific language governing permissions and
510   limitations under the License.
511 */
512 pragma solidity 0.5.7;
513 
514 
515 /// @title ITradeHistory
516 /// @dev Stores the trade history and cancelled data of orders
517 /// @author Brecht Devos - <brecht@loopring.org>.
518 contract ITradeHistory {
519 
520     // The following map is used to keep trace of order fill and cancellation
521     // history.
522     mapping (bytes32 => uint) public filled;
523 
524     // This map is used to keep trace of order's cancellation history.
525     mapping (address => mapping (bytes32 => bool)) public cancelled;
526 
527     // A map from a broker to its cutoff timestamp.
528     mapping (address => uint) public cutoffs;
529 
530     // A map from a broker to its trading-pair cutoff timestamp.
531     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
532 
533     // A map from a broker to an order owner to its cutoff timestamp.
534     mapping (address => mapping (address => uint)) public cutoffsOwner;
535 
536     // A map from a broker to an order owner to its trading-pair cutoff timestamp.
537     mapping (address => mapping (address => mapping (bytes20 => uint))) public tradingPairCutoffsOwner;
538 
539 
540     function batchUpdateFilled(
541         bytes32[] calldata filledInfo
542         )
543         external;
544 
545     function setCancelled(
546         address broker,
547         bytes32 orderHash
548         )
549         external;
550 
551     function setCutoffs(
552         address broker,
553         uint cutoff
554         )
555         external;
556 
557     function setTradingPairCutoffs(
558         address broker,
559         bytes20 tokenPair,
560         uint cutoff
561         )
562         external;
563 
564     function setCutoffsOfOwner(
565         address broker,
566         address owner,
567         uint cutoff
568         )
569         external;
570 
571     function setTradingPairCutoffsOfOwner(
572         address broker,
573         address owner,
574         bytes20 tokenPair,
575         uint cutoff
576         )
577         external;
578 
579     function batchGetFilledAndCheckCancelled(
580         bytes32[] calldata orderInfo
581         )
582         external
583         view
584         returns (uint[] memory fills);
585 
586 
587     /// @dev Add a Loopring protocol address.
588     /// @param addr A loopring protocol address.
589     function authorizeAddress(
590         address addr
591         )
592         external;
593 
594     /// @dev Remove a Loopring protocol address.
595     /// @param addr A loopring protocol address.
596     function deauthorizeAddress(
597         address addr
598         )
599         external;
600 
601     function isAddressAuthorized(
602         address addr
603         )
604         public
605         view
606         returns (bool);
607 
608 
609     function suspend()
610         external;
611 
612     function resume()
613         external;
614 
615     function kill()
616         external;
617 }
618 
619 // File: contracts/loopring/impl/Data.sol
620 
621 /*
622 
623   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
624 
625   Licensed under the Apache License, Version 2.0 (the "License");
626   you may not use this file except in compliance with the License.
627   You may obtain a copy of the License at
628 
629   http://www.apache.org/licenses/LICENSE-2.0
630 
631   Unless required by applicable law or agreed to in writing, software
632   distributed under the License is distributed on an "AS IS" BASIS,
633   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
634   See the License for the specific language governing permissions and
635   limitations under the License.
636 */
637 pragma solidity 0.5.7;
638 
639 
640 
641 
642 
643 
644 
645 
646 
647 library Data {
648 
649     enum TokenType { ERC20 }
650 
651     struct Header {
652         uint version;
653         uint numOrders;
654         uint numRings;
655         uint numSpendables;
656     }
657 
658     struct BrokerAction {
659         bytes32 hash;
660         address broker;
661         uint[] orderIndices;
662         uint numOrders;
663         uint[] transferIndices;
664         uint numTransfers;
665         address tokenS;
666         address tokenB;
667         address feeToken;
668         address delegate;
669     }
670 
671     struct BrokerTransfer {
672         bytes32 hash;
673         address token;
674         uint amount;
675         address recipient;
676     }
677 
678     struct Context {
679         address lrcTokenAddress;
680         ITradeDelegate  delegate;
681         ITradeHistory   tradeHistory;
682         IBrokerRegistry orderBrokerRegistry;
683         IOrderRegistry  orderRegistry;
684         IFeeHolder feeHolder;
685         IOrderBook orderBook;
686         IBurnRateTable burnRateTable;
687         uint64 ringIndex;
688         uint feePercentageBase;
689         bytes32[] tokenBurnRates;
690         uint feeData;
691         uint feePtr;
692         uint transferData;
693         uint transferPtr;
694         BrokerData.BrokerOrder[] brokerOrders;
695         BrokerAction[] brokerActions;
696         BrokerTransfer[] brokerTransfers;
697         uint numBrokerOrders;
698         uint numBrokerActions;
699         uint numBrokerTransfers;
700     }
701 
702     struct Mining {
703         // required fields
704         address feeRecipient;
705 
706         // optional fields
707         address miner;
708         bytes   sig;
709 
710         // computed fields
711         bytes32 hash;
712         address interceptor;
713     }
714 
715     struct Spendable {
716         bool initialized;
717         uint amount;
718         uint reserved;
719     }
720 
721     struct Order {
722         uint      version;
723 
724         // required fields
725         address   owner;
726         address   tokenS;
727         address   tokenB;
728         uint      amountS;
729         uint      amountB;
730         uint      validSince;
731         Spendable tokenSpendableS;
732         Spendable tokenSpendableFee;
733 
734         // optional fields
735         address   dualAuthAddr;
736         address   broker;
737         Spendable brokerSpendableS;
738         Spendable brokerSpendableFee;
739         address   orderInterceptor;
740         address   wallet;
741         uint      validUntil;
742         bytes     sig;
743         bytes     dualAuthSig;
744         bool      allOrNone;
745         address   feeToken;
746         uint      feeAmount;
747         int16     waiveFeePercentage;
748         uint16    tokenSFeePercentage;    // Pre-trading
749         uint16    tokenBFeePercentage;   // Post-trading
750         address   tokenRecipient;
751         uint16    walletSplitPercentage;
752 
753         // computed fields
754         bool    P2P;
755         bytes32 hash;
756         address brokerInterceptor;
757         uint    filledAmountS;
758         uint    initialFilledAmountS;
759         bool    valid;
760 
761         TokenType tokenTypeS;
762         TokenType tokenTypeB;
763         TokenType tokenTypeFee;
764         bytes32 trancheS;
765         bytes32 trancheB;
766         uint    maxPrimaryFillAmount;
767         bool    transferFirstAsMaker;
768         bytes   transferDataS;
769     }
770 
771     struct Participation {
772         // required fields
773         Order order;
774 
775         // computed fields
776         uint splitS;
777         uint feeAmount;
778         uint feeAmountS;
779         uint feeAmountB;
780         uint rebateFee;
781         uint rebateS;
782         uint rebateB;
783         uint fillAmountS;
784         uint fillAmountB;
785     }
786 
787     struct Ring {
788         uint size;
789         Participation[] participations;
790         bytes32 hash;
791         uint minerFeesToOrdersPercentage;
792         bool valid;
793     }
794 
795     struct RingIndices {
796         uint index0;
797         uint index1;
798     }
799 
800     struct FeeContext {
801         Data.Ring ring;
802         Data.Context ctx;
803         address feeRecipient;
804         uint walletPercentage;
805         int16 waiveFeePercentage;
806         address owner;
807         address wallet;
808         bool P2P;
809     }
810 
811 //    struct SubmitRingsRequest {
812 //        Data.Mining  mining;
813 //        Data.Order[] orders;
814 //        Data.RingIndices[]  ringIndices;
815 //    }
816 
817 }
818 
819 // File: contracts/loopring/lib/BytesUtil.sol
820 
821 /*
822 
823   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
824 
825   Licensed under the Apache License, Version 2.0 (the "License");
826   you may not use this file except in compliance with the License.
827   You may obtain a copy of the License at
828 
829   http://www.apache.org/licenses/LICENSE-2.0
830 
831   Unless required by applicable law or agreed to in writing, software
832   distributed under the License is distributed on an "AS IS" BASIS,
833   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
834   See the License for the specific language governing permissions and
835   limitations under the License.
836 */
837 pragma solidity 0.5.7;
838 
839 
840 /// @title Utility Functions for bytes
841 /// @author Daniel Wang - <daniel@loopring.org>
842 library BytesUtil {
843     function bytesToBytes32(
844         bytes memory b,
845         uint offset
846         )
847         internal
848         pure
849         returns (bytes32)
850     {
851         return bytes32(bytesToUintX(b, offset, 32));
852     }
853 
854     function bytesToUint(
855         bytes memory b,
856         uint offset
857         )
858         internal
859         pure
860         returns (uint)
861     {
862         return bytesToUintX(b, offset, 32);
863     }
864 
865     function bytesToAddress(
866         bytes memory b,
867         uint offset
868         )
869         internal
870         pure
871         returns (address)
872     {
873         return address(bytesToUintX(b, offset, 20) & 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
874     }
875 
876     function bytesToUint16(
877         bytes memory b,
878         uint offset
879         )
880         internal
881         pure
882         returns (uint16)
883     {
884         return uint16(bytesToUintX(b, offset, 2) & 0xFFFF);
885     }
886 
887     function bytesToUintX(
888         bytes memory b,
889         uint offset,
890         uint numBytes
891         )
892         private
893         pure
894         returns (uint data)
895     {
896         require(b.length >= offset + numBytes, "INVALID_SIZE");
897         assembly {
898             data := mload(add(add(b, numBytes), offset))
899         }
900     }
901 
902     function subBytes(
903         bytes memory b,
904         uint offset
905         )
906         internal
907         pure
908         returns (bytes memory data)
909     {
910         require(b.length >= offset + 32, "INVALID_SIZE");
911         assembly {
912             data := add(add(b, 32), offset)
913         }
914     }
915 }
916 
917 // File: contracts/loopring/lib/MultihashUtil.sol
918 
919 /*
920 
921   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
922 
923   Licensed under the Apache License, Version 2.0 (the "License");
924   you may not use this file except in compliance with the License.
925   You may obtain a copy of the License at
926 
927   http://www.apache.org/licenses/LICENSE-2.0
928 
929   Unless required by applicable law or agreed to in writing, software
930   distributed under the License is distributed on an "AS IS" BASIS,
931   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
932   See the License for the specific language governing permissions and
933   limitations under the License.
934 */
935 pragma solidity 0.5.7;
936 
937 
938 
939 /// @title Utility Functions for Multihash signature verificaiton
940 /// @author Daniel Wang - <daniel@loopring.org>
941 /// For more information:
942 ///   - https://github.com/saurfang/ipfs-multihash-on-solidity
943 ///   - https://github.com/multiformats/multihash
944 ///   - https://github.com/multiformats/js-multihash
945 library MultihashUtil {
946 
947     enum HashAlgorithm { Ethereum, EIP712 }
948 
949     string public constant SIG_PREFIX = "\x19Ethereum Signed Message:\n32";
950 
951     function verifySignature(
952         address signer,
953         bytes32 plaintext,
954         bytes memory multihash
955         )
956         internal
957         pure
958         returns (bool)
959     {
960         uint length = multihash.length;
961         require(length >= 2, "invalid multihash format");
962         uint8 algorithm;
963         uint8 size;
964         assembly {
965             algorithm := mload(add(multihash, 1))
966             size := mload(add(multihash, 2))
967         }
968         require(length == (2 + size), "bad multihash size");
969 
970         if (algorithm == uint8(HashAlgorithm.Ethereum)) {
971             require(signer != address(0x0), "invalid signer address");
972             require(size == 65, "bad Ethereum multihash size");
973             bytes32 hash;
974             uint8 v;
975             bytes32 r;
976             bytes32 s;
977             assembly {
978                 let data := mload(0x40)
979                 mstore(data, 0x19457468657265756d205369676e6564204d6573736167653a0a333200000000) // SIG_PREFIX
980                 mstore(add(data, 28), plaintext)                                                 // plaintext
981                 hash := keccak256(data, 60)                                                      // 28 + 32
982                 // Extract v, r and s from the multihash data
983                 v := mload(add(multihash, 3))
984                 r := mload(add(multihash, 35))
985                 s := mload(add(multihash, 67))
986             }
987             return signer == ecrecover(
988                 hash,
989                 v,
990                 r,
991                 s
992             );
993         } else if (algorithm == uint8(HashAlgorithm.EIP712)) {
994             require(signer != address(0x0), "invalid signer address");
995             require(size == 65, "bad EIP712 multihash size");
996             uint8 v;
997             bytes32 r;
998             bytes32 s;
999             assembly {
1000                 // Extract v, r and s from the multihash data
1001                 v := mload(add(multihash, 3))
1002                 r := mload(add(multihash, 35))
1003                 s := mload(add(multihash, 67))
1004             }
1005             return signer == ecrecover(
1006                 plaintext,
1007                 v,
1008                 r,
1009                 s
1010             );
1011         } else {
1012             return false;
1013         }
1014     }
1015 }
1016 
1017 // File: contracts/loopring/helper/MiningHelper.sol
1018 
1019 /*
1020 
1021   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1022 
1023   Licensed under the Apache License, Version 2.0 (the "License");
1024   you may not use this file except in compliance with the License.
1025   You may obtain a copy of the License at
1026 
1027   http://www.apache.org/licenses/LICENSE-2.0
1028 
1029   Unless required by applicable law or agreed to in writing, software
1030   distributed under the License is distributed on an "AS IS" BASIS,
1031   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1032   See the License for the specific language governing permissions and
1033   limitations under the License.
1034 */
1035 pragma solidity 0.5.7;
1036 
1037 
1038 
1039 
1040 /// @title MiningHelper
1041 /// @author Daniel Wang - <daniel@loopring.org>.
1042 library MiningHelper {
1043 
1044 //    function updateMinerAndInterceptor(
1045 //        Data.Mining memory mining
1046 //        )
1047 //        internal
1048 //        pure
1049 //    {
1050 //
1051 //        if (mining.miner == address(0x0)) {
1052 //            mining.miner = mining.feeRecipient;
1053 //        }
1054 //
1055 //        // We do not support any interceptors for now
1056 //        /* else { */
1057 //        /*     (bool registered, address interceptor) = ctx.minerBrokerRegistry.getBroker( */
1058 //        /*         mining.feeRecipient, */
1059 //        /*         mining.miner */
1060 //        /*     ); */
1061 //        /*     if (registered) { */
1062 //        /*         mining.interceptor = interceptor; */
1063 //        /*     } */
1064 //        /* } */
1065 //    }
1066 
1067     function updateHash(
1068         Data.Mining memory mining,
1069         Data.Ring[] memory rings
1070         )
1071         internal
1072         pure
1073     {
1074         bytes32 hash;
1075         assembly {
1076             let ring := mload(add(rings, 32))                               // rings[0]
1077             let ringHashes := mload(add(ring, 64))                          // ring.hash
1078             for { let i := 1 } lt(i, mload(rings)) { i := add(i, 1) } {
1079                 ring := mload(add(rings, mul(add(i, 1), 32)))               // rings[i]
1080                 ringHashes := xor(ringHashes, mload(add(ring, 64)))         // ring.hash
1081             }
1082             let data := mload(0x40)
1083             data := add(data, 12)
1084             // Store data back to front to allow overwriting data at the front because of padding
1085             mstore(add(data, 40), ringHashes)                               // ringHashes
1086             mstore(sub(add(data, 20), 12), mload(add(mining, 32)))          // mining.miner
1087             mstore(sub(data, 12),          mload(add(mining,  0)))          // mining.feeRecipient
1088             hash := keccak256(data, 72)                                     // 20 + 20 + 32
1089         }
1090         mining.hash = hash;
1091     }
1092 
1093     function checkMinerSignature(
1094         Data.Mining memory mining
1095         )
1096         internal
1097         view
1098         returns (bool)
1099     {
1100         if (mining.sig.length == 0) {
1101             return (msg.sender == mining.miner);
1102         } else {
1103             return MultihashUtil.verifySignature(
1104                 mining.miner,
1105                 mining.hash,
1106                 mining.sig
1107             );
1108         }
1109     }
1110 
1111 }
1112 
1113 // File: contracts/loopring/lib/ERC20.sol
1114 
1115 /*
1116 
1117   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1118 
1119   Licensed under the Apache License, Version 2.0 (the "License");
1120   you may not use this file except in compliance with the License.
1121   You may obtain a copy of the License at
1122 
1123   http://www.apache.org/licenses/LICENSE-2.0
1124 
1125   Unless required by applicable law or agreed to in writing, software
1126   distributed under the License is distributed on an "AS IS" BASIS,
1127   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1128   See the License for the specific language governing permissions and
1129   limitations under the License.
1130 */
1131 pragma solidity 0.5.7;
1132 
1133 
1134 /// @title ERC20 Token Interface
1135 /// @dev see https://github.com/ethereum/EIPs/issues/20
1136 /// @author Daniel Wang - <daniel@loopring.org>
1137 contract ERC20 {
1138     function totalSupply()
1139         public
1140         view
1141         returns (uint256);
1142 
1143     function balanceOf(
1144         address who
1145         )
1146         public
1147         view
1148         returns (uint256);
1149 
1150     function allowance(
1151         address owner,
1152         address spender
1153         )
1154         public
1155         view
1156         returns (uint256);
1157 
1158     function transfer(
1159         address to,
1160         uint256 value
1161         )
1162         public
1163         returns (bool);
1164 
1165     function transferFrom(
1166         address from,
1167         address to,
1168         uint256 value
1169         )
1170         public
1171         returns (bool);
1172 
1173     function approve(
1174         address spender,
1175         uint256 value
1176         )
1177         public
1178         returns (bool);
1179 }
1180 
1181 // File: contracts/loopring/lib/MathUint.sol
1182 
1183 /*
1184 
1185   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1186 
1187   Licensed under the Apache License, Version 2.0 (the "License");
1188   you may not use this file except in compliance with the License.
1189   You may obtain a copy of the License at
1190 
1191   http://www.apache.org/licenses/LICENSE-2.0
1192 
1193   Unless required by applicable law or agreed to in writing, software
1194   distributed under the License is distributed on an "AS IS" BASIS,
1195   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1196   See the License for the specific language governing permissions and
1197   limitations under the License.
1198 */
1199 pragma solidity 0.5.7;
1200 
1201 
1202 /// @title Utility Functions for uint
1203 /// @author Daniel Wang - <daniel@loopring.org>
1204 library MathUint {
1205 
1206     function mul(
1207         uint a,
1208         uint b
1209         )
1210         internal
1211         pure
1212         returns (uint c)
1213     {
1214         c = a * b;
1215         require(a == 0 || c / a == b, "INVALID_VALUE_MULTIPLY");
1216     }
1217 
1218     function sub(
1219         uint a,
1220         uint b
1221         )
1222         internal
1223         pure
1224         returns (uint)
1225     {
1226         require(b <= a, "INVALID_VALUE_SUB");
1227         return a - b;
1228     }
1229 
1230     function add(
1231         uint a,
1232         uint b
1233         )
1234         internal
1235         pure
1236         returns (uint c)
1237     {
1238         c = a + b;
1239         require(c >= a, "INVALID_VALUE_ADD");
1240     }
1241 
1242     function hasRoundingError(
1243         uint value,
1244         uint numerator,
1245         uint denominator
1246         )
1247         internal
1248         pure
1249         returns (bool)
1250     {
1251         uint multiplied = mul(value, numerator);
1252         uint remainder = multiplied % denominator;
1253         // Return true if the rounding error is larger than 1%
1254         return mul(remainder, 100) > multiplied;
1255     }
1256 }
1257 
1258 // File: contracts/loopring/iface/IBrokerDelegate.sol
1259 
1260 /*
1261 
1262   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1263 
1264   Licensed under the Apache License, Version 2.0 (the "License");
1265   you may not use this file except in compliance with the License.
1266   You may obtain a copy of the License at
1267 
1268   http://www.apache.org/licenses/LICENSE-2.0
1269 
1270   Unless required by applicable law or agreed to in writing, software
1271   distributed under the License is distributed on an "AS IS" BASIS,
1272   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1273   See the License for the specific language governing permissions and
1274   limitations under the License.
1275 */
1276 
1277 pragma solidity 0.5.7;
1278 
1279 
1280 /**
1281  * @title IBrokerDelegate
1282  * @author Zack Rubenstein
1283  */
1284 interface IBrokerDelegate {
1285 
1286   /*
1287    * Loopring requests an allowance be set on a given token for a specified amount. Order details
1288    * are provided (tokenS, totalAmountS, tokenB, totalAmountB, orderTokenRecipient, extraOrderData)
1289    * to aid in any calculations or on-chain exchange of assets that may be required. The last 4
1290    * parameters concern the actual token approval being requested of the broker.
1291    *
1292    * @returns Whether or not onOrderFillReport should be called for orders using this broker
1293    */
1294   function brokerRequestAllowance(BrokerData.BrokerApprovalRequest calldata request) external returns (bool);
1295 
1296   /*
1297    * After Loopring performs all of the transfers necessary to complete all the submitted
1298    * rings it will call this function for every order's brokerInterceptor (if set) passing
1299    * along the final fill counts for tokenB, tokenS and feeToken. This allows actions to be
1300    * performed on a per-order basis after all tokenS/feeToken funds have left the order owner's
1301    * possesion and the tokenB funds have been transfered to the order owner's intended recipient
1302    */
1303   function onOrderFillReport(BrokerData.BrokerInterceptorReport calldata fillReport) external;
1304 
1305   /*
1306    * Get the available token balance controlled by the broker on behalf of an address (owner)
1307    */
1308   function brokerBalanceOf(address owner, address token) external view returns (uint);
1309 }
1310 
1311 // File: contracts/loopring/helper/OrderHelper.sol
1312 
1313 /*
1314 
1315   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1316 
1317   Licensed under the Apache License, Version 2.0 (the "License");
1318   you may not use this file except in compliance with the License.
1319   You may obtain a copy of the License at
1320 
1321   http://www.apache.org/licenses/LICENSE-2.0
1322 
1323   Unless required by applicable law or agreed to in writing, software
1324   distributed under the License is distributed on an "AS IS" BASIS,
1325   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1326   See the License for the specific language governing permissions and
1327   limitations under the License.
1328 */
1329 pragma solidity 0.5.7;
1330 
1331 
1332 
1333 
1334 
1335 
1336 /// @title OrderHelper
1337 /// @author Daniel Wang - <daniel@loopring.org>.
1338 library OrderHelper {
1339     using MathUint      for uint;
1340 
1341     string constant internal EIP191_HEADER = "\x19\x01";
1342     string constant internal EIP712_DOMAIN_NAME = "Loopring Protocol";
1343     string constant internal EIP712_DOMAIN_VERSION = "2";
1344     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(
1345         abi.encodePacked(
1346             "EIP712Domain(",
1347             "string name,",
1348             "string version",
1349             ")"
1350         )
1351     );
1352     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(
1353         abi.encodePacked(
1354             "Order(",
1355             "uint amountS,",
1356             "uint amountB,",
1357             "uint feeAmount,",
1358             "uint validSince,",
1359             "uint validUntil,",
1360             "address owner,",
1361             "address tokenS,",
1362             "address tokenB,",
1363             "address dualAuthAddr,",
1364             "address broker,",
1365             "address orderInterceptor,",
1366             "address wallet,",
1367             "address tokenRecipient,",
1368             "address feeToken,",
1369             "uint16 walletSplitPercentage,",
1370             "uint16 tokenSFeePercentage,",
1371             "uint16 tokenBFeePercentage,",
1372             "bool allOrNone,",
1373             "uint8 tokenTypeS,",
1374             "uint8 tokenTypeB,",
1375             "uint8 tokenTypeFee,",
1376             "bytes32 trancheS,",
1377             "bytes32 trancheB,",
1378             "bytes transferDataS",
1379             ")"
1380         )
1381     );
1382     bytes32 constant internal EIP712_DOMAIN_HASH = keccak256(
1383         abi.encodePacked(
1384             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1385             keccak256(bytes(EIP712_DOMAIN_NAME)),
1386             keccak256(bytes(EIP712_DOMAIN_VERSION))
1387         )
1388     );
1389 
1390     function updateHash(Data.Order memory order)
1391         internal
1392         pure
1393     {
1394         // Pre-calculated EIP712_ORDER_SCHEMA_HASH amd EIP712_DOMAIN_HASH because
1395         // the solidity compiler doesn't correctly pre-calculate them for us.
1396         bytes32 _EIP712_ORDER_SCHEMA_HASH = 0x40b942178d2a51f1f61934268590778feb8114db632db7d88537c98d2b05c5f2;
1397         bytes32 _EIP712_DOMAIN_HASH = 0xaea25658c273c666156bd427f83a666135fcde6887a6c25fc1cd1562bc4f3f34;
1398 
1399 //         bytes32 message = keccak256(
1400 //             abi.encode(
1401 //                 EIP712_ORDER_SCHEMA_HASH,
1402 //                 order.amountS,
1403 //                 order.amountB,
1404 //                 order.feeAmount,
1405 //                 order.validSince,
1406 //                 order.validUntil,
1407 //                 order.owner,
1408 //                 order.tokenS,
1409 //                 order.tokenB,
1410 //                 order.dualAuthAddr,
1411 //                 order.broker,
1412 //                 order.orderInterceptor,
1413 //                 order.wallet,
1414 //                 order.tokenRecipient,
1415 //                 order.feeToken,
1416 //                 order.walletSplitPercentage,
1417 //                 order.tokenSFeePercentage,
1418 //                 order.tokenBFeePercentage,
1419 //                 order.allOrNone,
1420 //                 order.tokenTypeS,
1421 //                 order.tokenTypeB,
1422 //                 order.tokenTypeFee,
1423 //                 order.trancheS,
1424 //                 order.trancheB,
1425 //                 order.transferDataS
1426 //             )
1427 //         );
1428 //         order.hash = keccak256(
1429 //            abi.encodePacked(
1430 //                EIP191_HEADER,
1431 //                EIP712_DOMAIN_HASH,
1432 //                message
1433 //            )
1434 //        );
1435 
1436         bytes32 hash;
1437         assembly {
1438             // Calculate the hash for transferDataS separately
1439             let transferDataS := mload(add(order, 1248))         // order.transferDataS
1440             let transferDataSHash := keccak256(add(transferDataS, 32), mload(transferDataS))
1441 
1442             let ptr := mload(64)
1443             mstore(add(ptr,   0), _EIP712_ORDER_SCHEMA_HASH)     // EIP712_ORDER_SCHEMA_HASH
1444             mstore(add(ptr,  32), mload(add(order, 128)))        // order.amountS
1445             mstore(add(ptr,  64), mload(add(order, 160)))        // order.amountB
1446             mstore(add(ptr,  96), mload(add(order, 640)))        // order.feeAmount
1447             mstore(add(ptr, 128), mload(add(order, 192)))        // order.validSince
1448             mstore(add(ptr, 160), mload(add(order, 480)))        // order.validUntil
1449             mstore(add(ptr, 192), mload(add(order,  32)))        // order.owner
1450             mstore(add(ptr, 224), mload(add(order,  64)))        // order.tokenS
1451             mstore(add(ptr, 256), mload(add(order,  96)))        // order.tokenB
1452             mstore(add(ptr, 288), mload(add(order, 288)))        // order.dualAuthAddr
1453             mstore(add(ptr, 320), mload(add(order, 320)))        // order.broker
1454             mstore(add(ptr, 352), mload(add(order, 416)))        // order.orderInterceptor
1455             mstore(add(ptr, 384), mload(add(order, 448)))        // order.wallet
1456             mstore(add(ptr, 416), mload(add(order, 768)))        // order.tokenRecipient
1457             mstore(add(ptr, 448), mload(add(order, 608)))        // order.feeToken
1458             mstore(add(ptr, 480), mload(add(order, 800)))        // order.walletSplitPercentage
1459             mstore(add(ptr, 512), mload(add(order, 704)))        // order.tokenSFeePercentage
1460             mstore(add(ptr, 544), mload(add(order, 736)))        // order.tokenBFeePercentage
1461             mstore(add(ptr, 576), mload(add(order, 576)))        // order.allOrNone
1462             mstore(add(ptr, 608), mload(add(order, 1024)))       // order.tokenTypeS
1463             mstore(add(ptr, 640), mload(add(order, 1056)))       // order.tokenTypeB
1464             mstore(add(ptr, 672), mload(add(order, 1088)))       // order.tokenTypeFee
1465             mstore(add(ptr, 704), mload(add(order, 1120)))       // order.trancheS
1466             mstore(add(ptr, 736), mload(add(order, 1152)))       // order.trancheB
1467             mstore(add(ptr, 768), transferDataSHash)             // keccak256(order.transferDataS)
1468             let message := keccak256(ptr, 800)                   // 25 * 32
1469 
1470             mstore(add(ptr,  0), 0x1901)                         // EIP191_HEADER
1471             mstore(add(ptr, 32), _EIP712_DOMAIN_HASH)            // EIP712_DOMAIN_HASH
1472             mstore(add(ptr, 64), message)                        // message
1473             hash := keccak256(add(ptr, 30), 66)                  // 2 + 32 + 32
1474         }
1475 
1476         order.hash = hash;
1477     }
1478 
1479     function check(
1480         Data.Order memory order,
1481         Data.Context memory ctx
1482         )
1483         internal
1484         view
1485     {
1486         // If the order was already partially filled
1487         // we don't have to check all of the infos and the signature again
1488         if(order.filledAmountS == 0) {
1489             validateAllInfo(order, ctx);
1490             checkOwnerSignature(order, ctx);
1491         } else {
1492             validateUnstableInfo(order, ctx);
1493         }
1494 
1495         order.P2P = (order.tokenSFeePercentage > 0 || order.tokenBFeePercentage > 0);
1496     }
1497 
1498     function validateAllInfo(
1499         Data.Order memory order,
1500         Data.Context memory ctx
1501         )
1502         internal
1503         view
1504     {
1505         bool valid = true;
1506         valid = valid && (order.version == 0); // unsupported order version
1507         valid = valid && (order.owner != address(0x0)); // invalid order owner
1508         valid = valid && (order.tokenS != address(0x0)); // invalid order tokenS
1509         valid = valid && (order.tokenB != address(0x0)); // invalid order tokenB
1510         valid = valid && (order.amountS != 0); // invalid order amountS
1511         valid = valid && (order.amountB != 0); // invalid order amountB
1512         valid = valid && (order.feeToken != address(0x0)); // invalid fee token
1513 
1514         valid = valid && (order.tokenSFeePercentage < ctx.feePercentageBase); // invalid tokenS percentage
1515         valid = valid && (order.tokenBFeePercentage < ctx.feePercentageBase); // invalid tokenB percentage
1516         valid = valid && (order.walletSplitPercentage <= 100); // invalid wallet split percentage
1517 
1518         // We only support ERC20 for now
1519         valid = valid && (order.tokenTypeS == Data.TokenType.ERC20 && order.trancheS == 0x0);
1520         valid = valid && (order.tokenTypeFee == Data.TokenType.ERC20);
1521 
1522         // NOTICE: replaced to allow orders to specify market's primary token (to denote order side)
1523         // valid = valid && (order.tokenTypeB == Data.TokenType.ERC20 && order.trancheB == 0x0);
1524         valid = valid && (order.tokenTypeB == Data.TokenType.ERC20) && (
1525             bytes32ToAddress(order.trancheB) == order.tokenB ||
1526             bytes32ToAddress(order.trancheB) == order.tokenS
1527         );
1528 
1529         // NOTICE: commented to allow order.transferDataS to be used for dApps building on Loopring
1530         // valid = valid && (order.transferDataS.length == 0);
1531 
1532         valid = valid && (order.validSince <= (now + 300)); // order is too early to match
1533 
1534         valid = valid && (!order.allOrNone); // We don't support allOrNone
1535 
1536         require(valid, "INVALID_STABLE_DATA");
1537 
1538         order.valid = order.valid && valid;
1539 
1540         validateUnstableInfo(order, ctx);
1541     }
1542 
1543 
1544     function validateUnstableInfo(
1545         Data.Order memory order,
1546         Data.Context memory ctx
1547         )
1548         internal
1549         view
1550     {
1551         bool valid = true;
1552         valid = valid && (order.validUntil == 0 || order.validUntil > now - 300);  // order is expired
1553         valid = valid && (order.waiveFeePercentage <= int16(ctx.feePercentageBase)); // invalid waive percentage
1554         valid = valid && (order.waiveFeePercentage >= -int16(ctx.feePercentageBase)); // invalid waive percentage
1555         if (order.dualAuthAddr != address(0x0)) {
1556             // if dualAuthAddr exists, dualAuthSig must be exist.
1557             require(order.dualAuthSig.length > 0, "MISSING_DUAL_AUTH_SIGNATURE");
1558         }
1559         require(valid, "INVALID_UNSTABLE_DATA");
1560         order.valid = order.valid && valid;
1561     }
1562 
1563 
1564     function isBuy(Data.Order memory order) internal pure returns (bool) {
1565         return bytes32ToAddress(order.trancheB) == order.tokenB;
1566     }
1567 
1568     function checkOwnerSignature(
1569         Data.Order memory order,
1570         Data.Context memory ctx
1571         )
1572         internal
1573         view
1574     {
1575         if (order.sig.length == 0) {
1576             bool registered = ctx.orderRegistry.isOrderHashRegistered(
1577                 order.owner,
1578                 order.hash
1579             );
1580 
1581             if (!registered) {
1582                 order.valid = order.valid && ctx.orderBook.orderSubmitted(order.hash);
1583             }
1584         } else {
1585             require(order.valid, "INVALID_ORDER_DATA");
1586             order.valid = order.valid && MultihashUtil.verifySignature(
1587                 order.owner,
1588                 order.hash,
1589                 order.sig
1590             );
1591             require(order.valid, "INVALID_SIGNATURE");
1592         }
1593     }
1594 
1595     function checkDualAuthSignature(
1596         Data.Order memory order,
1597         bytes32 miningHash
1598         )
1599         internal
1600         pure
1601     {
1602         if (order.dualAuthSig.length != 0) {
1603             order.valid = order.valid && MultihashUtil.verifySignature(
1604                 order.dualAuthAddr,
1605                 miningHash,
1606                 order.dualAuthSig
1607             );
1608             require(order.valid, 'INVALID_DUAL_AUTH_SIGNATURE');
1609         }
1610     }
1611 
1612     function getBrokerHash(Data.Order memory order) internal pure returns (bytes32) {
1613         return keccak256(abi.encodePacked(order.broker, order.tokenS, order.tokenB, order.feeToken));
1614     }
1615 
1616     function getSpendableS(
1617         Data.Order memory order,
1618         Data.Context memory ctx
1619         )
1620         internal
1621         view
1622         returns (uint)
1623     {
1624         return getSpendable(
1625             order,
1626             ctx.delegate,
1627             order.tokenS,
1628             order.owner,
1629             order.tokenSpendableS
1630         );
1631     }
1632 
1633     function getSpendableFee(
1634         Data.Order memory order,
1635         Data.Context memory ctx
1636         )
1637         internal
1638         view
1639         returns (uint)
1640     {
1641         return getSpendable(
1642             order,
1643             ctx.delegate,
1644             order.feeToken,
1645             order.owner,
1646             order.tokenSpendableFee
1647         );
1648     }
1649 
1650     function reserveAmountS(
1651         Data.Order memory order,
1652         uint amount
1653         )
1654         internal
1655         pure
1656     {
1657         order.tokenSpendableS.reserved += amount;
1658     }
1659 
1660     function reserveAmountFee(
1661         Data.Order memory order,
1662         uint amount
1663         )
1664         internal
1665         pure
1666     {
1667         order.tokenSpendableFee.reserved += amount;
1668     }
1669 
1670     function resetReservations(
1671         Data.Order memory order
1672         )
1673         internal
1674         pure
1675     {
1676         order.tokenSpendableS.reserved = 0;
1677         order.tokenSpendableFee.reserved = 0;
1678     }
1679 
1680     /// @return Amount of ERC20 token that can be spent by this contract.
1681     function getERC20Spendable(
1682         Data.Order memory order,
1683         ITradeDelegate delegate,
1684         address tokenAddress,
1685         address owner
1686         )
1687         private
1688         view
1689         returns (uint spendable)
1690     {
1691         if (order.broker == address(0x0)) {
1692             ERC20 token = ERC20(tokenAddress);
1693             spendable = token.allowance(
1694                 owner,
1695                 address(delegate)
1696             );
1697             if (spendable != 0) {
1698                 uint balance = token.balanceOf(owner);
1699                 spendable = (balance < spendable) ? balance : spendable;
1700             }
1701         } else {
1702             IBrokerDelegate broker = IBrokerDelegate(order.broker);
1703             spendable = broker.brokerBalanceOf(owner, tokenAddress);
1704         }
1705     }
1706 
1707     function getSpendable(
1708         Data.Order memory order,
1709         ITradeDelegate delegate,
1710         address tokenAddress,
1711         address owner,
1712         Data.Spendable memory tokenSpendable
1713         )
1714         private
1715         view
1716         returns (uint spendable)
1717     {
1718         if (!tokenSpendable.initialized) {
1719             tokenSpendable.amount = getERC20Spendable(
1720                 order,
1721                 delegate,
1722                 tokenAddress,
1723                 owner
1724             );
1725             tokenSpendable.initialized = true;
1726         }
1727         spendable = tokenSpendable.amount.sub(tokenSpendable.reserved);
1728     }
1729 
1730     function bytes32ToAddress(bytes32 data) private pure returns (address) {
1731         return address(uint160(uint256(data)));
1732     }
1733 }
1734 
1735 // File: contracts/loopring/iface/IRingSubmitter.sol
1736 
1737 /*
1738 
1739   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1740 
1741   Licensed under the Apache License, Version 2.0 (the "License");
1742   you may not use this file except in compliance with the License.
1743   You may obtain a copy of the License at
1744 
1745   http://www.apache.org/licenses/LICENSE-2.0
1746 
1747   Unless required by applicable law or agreed to in writing, software
1748   distributed under the License is distributed on an "AS IS" BASIS,
1749   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1750   See the License for the specific language governing permissions and
1751   limitations under the License.
1752 */
1753 pragma solidity 0.5.7;
1754 
1755 
1756 /// @title IRingSubmitter
1757 /// @author Daniel Wang - <daniel@loopring.org>
1758 /// @author Kongliang Zhong - <kongliang@loopring.org>
1759 contract IRingSubmitter {
1760     uint16  public constant FEE_PERCENTAGE_BASE = 1000;
1761 
1762     /// @dev  Event emitted when a ring was successfully mined
1763     ///        _ringIndex     The index of the ring
1764     ///        _ringHash      The hash of the ring
1765     ///        _feeRecipient  The recipient of the matching fee
1766     ///        _fills         The info of the orders in the ring stored like:
1767     ///                       [orderHash, owner, tokenS, amountS, split, feeAmount, feeAmountS, feeAmountB]
1768     event RingMined(
1769         uint            _ringIndex,
1770         bytes32 indexed _ringHash,
1771         address indexed _feeRecipient,
1772         bytes           _fills
1773     );
1774 
1775     /// @dev   Event emitted when a ring was not successfully mined
1776     ///         _ringHash  The hash of the ring
1777     event InvalidRing(
1778         bytes32 _ringHash
1779     );
1780 
1781     /// @dev   Event emitted when fee rebates are distributed (waiveFeePercentage < 0)
1782     ///         _ringHash   The hash of the ring whose order(s) will receive the rebate
1783     ///         _orderHash  The hash of the order that will receive the rebate
1784     ///         _feeToken   The address of the token that will be paid to the _orderHash's owner
1785     ///         _feeAmount  The amount to be paid to the owner
1786     event DistributeFeeRebate(
1787         bytes32 indexed _ringHash,
1788         bytes32 indexed _orderHash,
1789         address         _feeToken,
1790         uint            _feeAmount
1791     );
1792 
1793 //    /// @dev   Submit order-rings for validation and settlement.
1794 //    /// @param data ABI encoded struct containing ring data.
1795 //    function submitRings(
1796 //        Data.SubmitRingsRequest calldata data
1797 //    ) external;
1798 
1799     /// @dev   Submit order-rings for validation and settlement.
1800     /// @param data Packed data of all rings.
1801     function submitRings(
1802         bytes calldata data
1803     ) external;
1804 }
1805 
1806 // File: contracts/loopring/helper/ParticipationHelper.sol
1807 
1808 /*
1809 
1810   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1811 
1812   Licensed under the Apache License, Version 2.0 (the "License");
1813   you may not use this file except in compliance with the License.
1814   You may obtain a copy of the License at
1815 
1816   http://www.apache.org/licenses/LICENSE-2.0
1817 
1818   Unless required by applicable law or agreed to in writing, software
1819   distributed under the License is distributed on an "AS IS" BASIS,
1820   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1821   See the License for the specific language governing permissions and
1822   limitations under the License.
1823 */
1824 pragma solidity 0.5.7;
1825 
1826 
1827 
1828 
1829 
1830 /// @title ParticipationHelper
1831 /// @author Daniel Wang - <daniel@loopring.org>.
1832 library ParticipationHelper {
1833     using MathUint for uint;
1834     using OrderHelper for Data.Order;
1835 
1836     function setMaxFillAmounts(
1837         Data.Participation memory p,
1838         Data.Context memory ctx
1839         )
1840         internal
1841         view
1842     {
1843         uint spendableS = p.order.getSpendableS(ctx);
1844         uint remainingS = p.order.amountS.sub(p.order.filledAmountS);
1845         p.fillAmountS = (spendableS < remainingS) ? spendableS : remainingS;
1846 
1847         if (!p.order.P2P) {
1848             // No need to check the fee balance of the owner if feeToken == tokenB,
1849             // fillAmountB will be used to pay the fee.
1850             if (!(p.order.feeToken == p.order.tokenB &&
1851                   // p.order.owner == p.order.tokenRecipient &&
1852                   p.order.feeAmount <= p.order.amountB)) {
1853                 // Check how much fee needs to be paid. We limit fillAmountS to how much
1854                 // fee the order owner can pay.
1855                 uint feeAmount = p.order.feeAmount.mul(p.fillAmountS) / p.order.amountS;
1856                 if (feeAmount > 0) {
1857                     uint spendableFee = p.order.getSpendableFee(ctx);
1858                     if (p.order.feeToken == p.order.tokenS && p.fillAmountS + feeAmount > spendableS) {
1859                         assert(spendableFee == spendableS);
1860                         // Equally divide the available tokens between fillAmountS and feeAmount
1861                         uint totalAmount = p.order.amountS.add(p.order.feeAmount);
1862                         p.fillAmountS = spendableS.mul(p.order.amountS) / totalAmount;
1863                         feeAmount = spendableS.mul(p.order.feeAmount) / totalAmount;
1864                     } else if (feeAmount > spendableFee) {
1865                         // Scale down fillAmountS so the available feeAmount is sufficient
1866                         feeAmount = spendableFee;
1867                         p.fillAmountS = feeAmount.mul(p.order.amountS) / p.order.feeAmount;
1868                     }
1869                 }
1870             }
1871         }
1872 
1873 
1874         if(p.order.isBuy()) {
1875             // If it's a BUY that means tokenB is the primary. That's how much we care about getting. Therefore there's
1876             // no need to scale the order based on spendableS.
1877             p.fillAmountB = p.order.amountB;
1878         } else {
1879             p.fillAmountB = p.fillAmountS.mul(p.order.amountB) / p.order.amountS;
1880         }
1881 
1882         // If relay sets max primary fill amount, re-balance max fill amounts if needed
1883         if (p.order.maxPrimaryFillAmount > 0) {
1884             if (p.order.isBuy() && p.order.maxPrimaryFillAmount < p.fillAmountB) {
1885                 p.fillAmountB = p.order.maxPrimaryFillAmount;
1886                 p.fillAmountS = p.fillAmountB.mul(p.order.amountS) / p.order.amountB;
1887             } else if (!p.order.isBuy() && p.order.maxPrimaryFillAmount < p.fillAmountS) {
1888                 p.fillAmountS = p.order.maxPrimaryFillAmount;
1889                 p.fillAmountB = p.fillAmountS.mul(p.order.amountB) / p.order.amountS;
1890             }
1891         }
1892     }
1893 
1894     function calculateFees(
1895         Data.Participation memory p,
1896         Data.Participation memory prevP,
1897         Data.Context memory ctx
1898         )
1899         internal
1900         view
1901         returns (bool)
1902     {
1903         if (p.order.P2P) {
1904             // Calculate P2P fees
1905             p.feeAmount = 0;
1906             p.feeAmountS = p.fillAmountS.mul(p.order.tokenSFeePercentage) / ctx.feePercentageBase;
1907             p.feeAmountB = p.fillAmountB.mul(p.order.tokenBFeePercentage) / ctx.feePercentageBase;
1908         } else {
1909             // Calculate matching fees
1910             p.feeAmountS = 0;
1911             p.feeAmountB = 0;
1912 
1913             // Use primary token fill ratio to calculate fee
1914             // if it's a BUY order, use the amount B (tokenB is the primary)
1915             // if it's a SELL order, use the amount S (tokenS is the primary)
1916             if (p.order.isBuy()) {
1917                 p.feeAmount = p.order.feeAmount.mul(p.fillAmountB) / p.order.amountB;
1918             } else {
1919                 p.feeAmount = p.order.feeAmount.mul(p.fillAmountS) / p.order.amountS;
1920             }
1921 
1922             // If feeToken == tokenB AND owner == tokenRecipient, try to pay using fillAmountB
1923 
1924             if (p.order.feeToken == p.order.tokenB &&
1925                 // p.order.owner == p.order.tokenRecipient &&
1926                 p.fillAmountB >= p.feeAmount) {
1927                 p.feeAmountB = p.feeAmount;
1928                 p.feeAmount = 0;
1929             }
1930 
1931             if (p.feeAmount > 0) {
1932                 // Make sure we can pay the feeAmount
1933                 uint spendableFee = p.order.getSpendableFee(ctx);
1934                 if (p.feeAmount > spendableFee) {
1935                     // This normally should not happen, but this is possible when self-trading
1936                     return false;
1937                 } else {
1938                     p.order.reserveAmountFee(p.feeAmount);
1939                 }
1940             }
1941         }
1942 
1943         if ((p.fillAmountS - p.feeAmountS) >= prevP.fillAmountB) {
1944             // NOTICE: this line commented as order recipient should receive the margin
1945             // p.splitS = (p.fillAmountS - p.feeAmountS) - prevP.fillAmountB;
1946 
1947             p.fillAmountS = prevP.fillAmountB + p.feeAmountS;
1948             return true;
1949         } else {
1950             revert('INVALID_FEES');
1951             // return false;
1952         }
1953     }
1954 
1955     function checkFills(
1956         Data.Participation memory p
1957         )
1958         internal
1959         pure
1960         returns (bool valid)
1961     {
1962         // NOTICE: deprecated logic, order recipient can get better price as they receive margin
1963         // Check if the rounding error of the calculated fillAmountB is larger than 1%.
1964         // If that's the case, this partipation in invalid
1965         // p.fillAmountB := p.fillAmountS.mul(p.order.amountB) / p.order.amountS
1966         // valid = !MathUint.hasRoundingError(
1967         //     p.fillAmountS,
1968         //     p.order.amountB,
1969         //     p.order.amountS
1970         // );
1971 
1972         // We at least need to buy and sell something
1973         valid = p.fillAmountS > 0;
1974         valid = valid && p.fillAmountB > 0;
1975 
1976         require(valid, 'INVALID_FILLS');
1977     }
1978 
1979     function adjustOrderState(
1980         Data.Participation memory p
1981         )
1982         internal
1983         pure
1984     {
1985         // Update filled amount
1986         p.order.filledAmountS += p.fillAmountS + p.splitS;
1987 
1988         // Update spendables
1989         uint totalAmountS = p.fillAmountS;
1990         uint totalAmountFee = p.feeAmount;
1991         p.order.tokenSpendableS.amount = p.order.tokenSpendableS.amount.sub(totalAmountS);
1992         p.order.tokenSpendableFee.amount = p.order.tokenSpendableFee.amount.sub(totalAmountFee);
1993     }
1994 
1995 }
1996 
1997 // File: contracts/loopring/helper/RingHelper.sol
1998 
1999 /*
2000 
2001   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
2002 
2003   Licensed under the Apache License, Version 2.0 (the "License");
2004   you may not use this file except in compliance with the License.
2005   You may obtain a copy of the License at
2006 
2007   http://www.apache.org/licenses/LICENSE-2.0
2008 
2009   Unless required by applicable law or agreed to in writing, software
2010   distributed under the License is distributed on an "AS IS" BASIS,
2011   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2012   See the License for the specific language governing permissions and
2013   limitations under the License.
2014 */
2015 pragma solidity 0.5.7;
2016 
2017 
2018 
2019 
2020 
2021 
2022 
2023 
2024 
2025 
2026 /// @title RingHelper
2027 library RingHelper {
2028     using MathUint for uint;
2029     using OrderHelper for Data.Order;
2030     using ParticipationHelper for Data.Participation;
2031 
2032     /// @dev   Event emitted when fee rebates are distributed (waiveFeePercentage < 0)
2033     ///         _ringHash   The hash of the ring whose order(s) will receive the rebate
2034     ///         _orderHash  The hash of the order that will receive the rebate
2035     ///         _feeToken   The address of the token that will be paid to the _orderHash's owner
2036     ///         _feeAmount  The amount to be paid to the owner
2037     event DistributeFeeRebate(
2038         bytes32 indexed _ringHash,
2039         bytes32 indexed _orderHash,
2040         address         _feeToken,
2041         uint            _feeAmount
2042     );
2043 
2044     function updateHash(
2045         Data.Ring memory ring
2046         )
2047         internal
2048         pure
2049     {
2050         uint ringSize = ring.size;
2051         bytes32 hash;
2052         assembly {
2053             let data := mload(0x40)
2054             let ptr := data
2055             let participations := mload(add(ring, 32))                                  // ring.participations
2056             for { let i := 0 } lt(i, ringSize) { i := add(i, 1) } {
2057                 let participation := mload(add(participations, add(32, mul(i, 32))))    // participations[i]
2058                 let order := mload(participation)                                       // participation.order
2059 
2060                 let waiveFeePercentage := and(mload(add(order, 672)), 0xFFFF)           // order.waiveFeePercentage
2061                 let orderHash := mload(add(order, 864))                                 // order.hash
2062 
2063                 mstore(add(ptr, 2), waiveFeePercentage)
2064                 mstore(ptr, orderHash)
2065 
2066                 ptr := add(ptr, 34)
2067             }
2068             hash := keccak256(data, sub(ptr, data))
2069         }
2070         ring.hash = hash;
2071     }
2072 
2073     function calculateFillAmountAndFee(
2074         Data.Ring memory ring,
2075         Data.Context memory ctx
2076         )
2077         internal
2078         view
2079     {
2080         // Invalid order data could cause a divide by zero in the calculations
2081         if (!ring.valid) {
2082             return;
2083         }
2084 
2085         uint i;
2086         uint prevIndex;
2087 
2088         for (i = 0; i < ring.size; i++) {
2089             ring.participations[i].setMaxFillAmounts(
2090                 ctx
2091             );
2092         }
2093 
2094         // Match the orders
2095         Data.Participation memory taker = ring.participations[0];
2096         Data.Participation memory maker = ring.participations[1];
2097 
2098         if (taker.order.isBuy()) {
2099             uint spread = matchRing(taker, maker);
2100             taker.fillAmountS = maker.fillAmountB; // For BUY orders owner can sell less to get what is wanted (keeps spread)
2101             taker.splitS = spread;
2102         } else {
2103             matchRing(maker, taker);
2104             taker.fillAmountB = maker.fillAmountS; // For SELL orders owner sells max and can get more than expected (spends spread)
2105             taker.splitS = 0;
2106         }
2107 
2108         maker.splitS = 0;
2109 
2110         // Validate matched orders
2111         for (i = 0; i < ring.size; i++) {
2112             // Check if the fill amounts of the participation are valid
2113             ring.valid = ring.valid && ring.participations[i].checkFills();
2114 
2115             // Reserve the total amount tokenS used for all the orders
2116             // (e.g. the owner of order 0 could use LRC as feeToken in order 0, while
2117             // the same owner can also sell LRC in order 2).
2118             ring.participations[i].order.reserveAmountS(ring.participations[i].fillAmountS);
2119         }
2120 
2121         for (i = 0; i < ring.size; i++) {
2122             prevIndex = (i + ring.size - 1) % ring.size;
2123 
2124             bool valid = ring.participations[i].calculateFees(ring.participations[prevIndex], ctx);
2125             if (!valid) {
2126                 ring.valid = false;
2127                 break;
2128             }
2129 
2130             int16 waiveFeePercentage = ring.participations[i].order.waiveFeePercentage;
2131             if (waiveFeePercentage < 0) {
2132                 ring.minerFeesToOrdersPercentage += uint(-waiveFeePercentage);
2133             }
2134         }
2135         // Miner can only distribute 100% of its fees to all orders combined
2136         ring.valid = ring.valid && (ring.minerFeesToOrdersPercentage <= ctx.feePercentageBase);
2137 
2138         // Ring calculations are done. Make sure te remove all spendable reservations for this ring
2139         for (i = 0; i < ring.size; i++) {
2140             ring.participations[i].order.resetReservations();
2141         }
2142     }
2143 
2144     function matchRing(
2145         Data.Participation memory buyer,
2146         Data.Participation memory seller
2147         )
2148         internal
2149         pure
2150         returns (uint)
2151     {
2152         if (buyer.fillAmountB < seller.fillAmountS) {
2153             // Amount seller wants less than amount maker sells
2154             seller.fillAmountS = buyer.fillAmountB;
2155             seller.fillAmountB = seller.fillAmountS.mul(seller.order.amountB) / seller.order.amountS;
2156         } else {
2157             buyer.fillAmountB = seller.fillAmountS;
2158             buyer.fillAmountS = buyer.fillAmountB.mul(buyer.order.amountS) / buyer.order.amountB;
2159         }
2160 
2161         require(buyer.fillAmountS >= seller.fillAmountB, "NOT_MATCHABLE");
2162         return buyer.fillAmountS.sub(seller.fillAmountB); // Return spread
2163     }
2164 
2165     function calculateOrderFillAmounts(
2166         Data.Context memory ctx,
2167         Data.Participation memory p,
2168         Data.Participation memory prevP,
2169         uint i,
2170         uint smallest
2171         )
2172         internal
2173         pure
2174         returns (uint smallest_)
2175     {
2176         // Default to the same smallest index
2177         smallest_ = smallest;
2178 
2179         uint postFeeFillAmountS = p.fillAmountS;
2180         uint tokenSFeePercentage = p.order.tokenSFeePercentage;
2181         if (tokenSFeePercentage > 0) {
2182             uint feeAmountS = p.fillAmountS.mul(tokenSFeePercentage) / ctx.feePercentageBase;
2183             postFeeFillAmountS = p.fillAmountS - feeAmountS;
2184         }
2185 
2186         if (prevP.fillAmountB > postFeeFillAmountS) {
2187             smallest_ = i;
2188             prevP.fillAmountB = postFeeFillAmountS;
2189             prevP.fillAmountS = postFeeFillAmountS.mul(prevP.order.amountS) / prevP.order.amountB;
2190         }
2191     }
2192 
2193     function checkOrdersValid(
2194         Data.Ring memory ring
2195         )
2196         internal
2197         pure
2198     {
2199         // NOTICE: deprecated logic, rings must be of size 2 now
2200         // ring.valid = ring.valid && (ring.size > 1 && ring.size <= 8); // invalid ring size
2201         
2202         ring.valid = ring.valid && ring.size == 2;
2203 
2204         // Ring must consist of a buy and a sell
2205         ring.valid = ring.valid && (
2206             (ring.participations[0].order.isBuy() && !ring.participations[1].order.isBuy()) ||
2207             (ring.participations[1].order.isBuy() && !ring.participations[0].order.isBuy())
2208         );
2209 
2210         for (uint i = 0; i < ring.size; i++) {
2211             uint prev = (i + ring.size - 1) % ring.size;
2212             ring.valid = ring.valid && ring.participations[i].order.valid;
2213             ring.valid = ring.valid && ring.participations[i].order.tokenS == ring.participations[prev].order.tokenB;
2214             ring.valid = ring.valid && !ring.participations[i].order.P2P; // No longer support P2P orders
2215         }
2216     }
2217 
2218 //    function checkForSubRings(
2219 //        Data.Ring memory ring
2220 //        )
2221 //        internal
2222 //        pure
2223 //    {
2224 //        for (uint i = 0; i < ring.size - 1; i++) {
2225 //            address tokenS = ring.participations[i].order.tokenS;
2226 //            for (uint j = i + 1; j < ring.size; j++) {
2227 //                ring.valid = ring.valid && (tokenS != ring.participations[j].order.tokenS);
2228 //            }
2229 //        }
2230 //    }
2231 
2232     function adjustOrderStates(
2233         Data.Ring memory ring
2234         )
2235         internal
2236         pure
2237     {
2238         // Adjust the orders
2239         for (uint i = 0; i < ring.size; i++) {
2240             ring.participations[i].adjustOrderState();
2241         }
2242     }
2243 
2244     function doPayments(
2245         Data.Ring memory ring,
2246         Data.Context memory ctx,
2247         Data.Mining memory mining
2248         )
2249         internal
2250     {
2251         payFees(ring, ctx, mining);
2252         transferTokens(ring, ctx, mining.feeRecipient);
2253     }
2254 
2255     function generateFills(
2256         Data.Ring memory ring,
2257         uint destPtr
2258         )
2259         internal
2260         pure
2261         returns (uint fill)
2262     {
2263         uint ringSize = ring.size;
2264         uint fillSize = 8 * 32;
2265         assembly {
2266             fill := destPtr
2267             let participations := mload(add(ring, 32))                                 // ring.participations
2268 
2269             for { let i := 0 } lt(i, ringSize) { i := add(i, 1) } {
2270                 let participation := mload(add(participations, add(32, mul(i, 32))))   // participations[i]
2271                 let order := mload(participation)                                      // participation.order
2272 
2273                 // Calculate the actual fees paid after rebate
2274                 let feeAmount := sub(
2275                     mload(add(participation, 64)),                                      // participation.feeAmount
2276                     mload(add(participation, 160))                                      // participation.rebateFee
2277                 )
2278                 let feeAmountS := sub(
2279                     mload(add(participation, 96)),                                      // participation.feeAmountS
2280                     mload(add(participation, 192))                                      // participation.rebateFeeS
2281                 )
2282                 let feeAmountB := sub(
2283                     mload(add(participation, 128)),                                     // participation.feeAmountB
2284                     mload(add(participation, 224))                                      // participation.rebateFeeB
2285                 )
2286 
2287                 mstore(add(fill,   0), mload(add(order, 864)))                         // order.hash
2288                 mstore(add(fill,  32), mload(add(order,  32)))                         // order.owner
2289                 mstore(add(fill,  64), mload(add(order,  64)))                         // order.tokenS
2290                 mstore(add(fill,  96), mload(add(participation, 256)))                 // participation.fillAmountS
2291                 mstore(add(fill, 128), mload(add(participation,  32)))                 // participation.splitS
2292                 mstore(add(fill, 160), feeAmount)                                      // feeAmount
2293                 mstore(add(fill, 192), feeAmountS)                                     // feeAmountS
2294                 mstore(add(fill, 224), feeAmountB)                                     // feeAmountB
2295 
2296                 fill := add(fill, fillSize)
2297             }
2298         }
2299     }
2300 
2301     function transferTokens(
2302         Data.Ring memory ring,
2303         Data.Context memory ctx,
2304         address feeRecipient
2305         )
2306         internal
2307         pure
2308     {
2309         Data.Participation memory taker = ring.participations[0];
2310         Data.Participation memory maker = ring.participations[1];
2311 
2312         if (maker.order.transferFirstAsMaker) {
2313             transferTokensForParticipation(ctx, feeRecipient, maker, taker);
2314             transferTokensForParticipation(ctx, feeRecipient, taker, maker);
2315         } else {
2316             transferTokensForParticipation(ctx, feeRecipient, taker, maker);
2317             transferTokensForParticipation(ctx, feeRecipient, maker, taker);
2318         }
2319     }
2320 
2321     function transferTokensForParticipation(
2322         Data.Context memory ctx,
2323         address feeRecipient,
2324         Data.Participation memory p,
2325         Data.Participation memory prevP
2326         )
2327         internal
2328         pure
2329         returns (uint)
2330     {
2331         // If the buyer needs to pay fees in tokenB, the seller needs
2332         // to send the tokenS amount to the fee holder contract
2333         uint amountSToBuyer = p.fillAmountS
2334             .sub(p.feeAmountS)
2335             .sub(prevP.feeAmountB.sub(prevP.rebateB)); // buyer fee amount after rebate
2336 
2337         uint amountSToFeeHolder = p.feeAmountS
2338             .sub(p.rebateS)
2339             .add(prevP.feeAmountB.sub(prevP.rebateB)); // buyer fee amount after rebate
2340 
2341         uint amountFeeToFeeHolder = p.feeAmount
2342             .sub(p.rebateFee);
2343 
2344 
2345         if (p.order.tokenS == p.order.feeToken) {
2346             amountSToFeeHolder = amountSToFeeHolder.add(amountFeeToFeeHolder);
2347             amountFeeToFeeHolder = 0;
2348         }
2349 
2350         // Transfers
2351         if (p.order.broker == address(0x0)) {
2352             ctx.transferPtr = addTokenTransfer(
2353                 ctx.transferData,
2354                 ctx.transferPtr,
2355                 p.order.tokenS,
2356                 p.order.owner,
2357                 prevP.order.tokenRecipient,
2358                 amountSToBuyer
2359             );
2360 
2361             ctx.transferPtr = addTokenTransfer(
2362                 ctx.transferData,
2363                 ctx.transferPtr,
2364                 p.order.feeToken,
2365                 p.order.owner,
2366                 address(ctx.feeHolder),
2367                 amountFeeToFeeHolder
2368             );
2369 
2370             ctx.transferPtr = addTokenTransfer(
2371                 ctx.transferData,
2372                 ctx.transferPtr,
2373                 p.order.tokenS,
2374                 p.order.owner,
2375                 address(ctx.feeHolder),
2376                 amountSToFeeHolder
2377             );
2378         } else {
2379             
2380             // Calculates amount received from other participant
2381             uint receivableAmountB = prevP.fillAmountS
2382                 .sub(prevP.feeAmountS)
2383                 .sub(p.feeAmountB.sub(p.rebateB)); // seller fee amount after rebate
2384 
2385             addBrokerTokenTransfer(
2386                 ctx,
2387                 p,
2388                 receivableAmountB, // receivable amount incremented/set in called function for order
2389                 p.order.tokenS,
2390                 prevP.order.tokenRecipient,
2391                 amountSToBuyer,
2392                 false
2393             );
2394 
2395             addBrokerTokenTransfer(
2396                 ctx,
2397                 p,
2398                 0, // receivable amount set to 0 for fee transfers
2399                 p.order.feeToken,
2400                 address(ctx.feeHolder),
2401                 amountFeeToFeeHolder,
2402                 true // this transfer concerns the fee token
2403             );
2404 
2405             addBrokerTokenTransfer(
2406                 ctx,
2407                 p,
2408                 0, // receivable amount set to 0 for fee transfers
2409                 p.order.tokenS,
2410                 address(ctx.feeHolder),
2411                 amountSToFeeHolder,
2412                 false
2413             );
2414         }
2415         
2416 
2417         // NOTICE: Dolomite does not take the margin ever. We still track it for the order's history.
2418         // ctx.transferPtr = addTokenTransfer(
2419         //     ctx.transferData,
2420         //     ctx.transferPtr,
2421         //     p.order.tokenS,
2422         //     p.order.owner,
2423         //     feeRecipient,
2424         //     p.splitS
2425         // );
2426     }
2427 
2428     function addBrokerTokenTransfer(
2429         Data.Context memory ctx,
2430         Data.Participation memory participation,
2431         uint receivableAmount,
2432         address requestToken, 
2433         address recipient,
2434         uint requestAmount,
2435         bool isForFeeToken
2436     )
2437         internal
2438         pure
2439     {
2440         if (requestAmount > 0) {
2441             bytes32 actionHash = participation.order.getBrokerHash();
2442             bytes32 transferHash = keccak256(abi.encodePacked(actionHash, requestToken, recipient));
2443             
2444             Data.BrokerAction memory action;
2445             bool isActionNewlyCreated = false;
2446 
2447             uint index = 0;
2448             bool found = false;
2449 
2450             // Find a preexisting BrokerAction
2451             for (index = 0; index < ctx.numBrokerActions; index++) {
2452                 if (ctx.brokerActions[index].hash == actionHash) {
2453                     action = ctx.brokerActions[index];
2454                     found = true;
2455                     break;
2456                 }
2457             }
2458 
2459             // If none exist, create a new BrokerAction
2460             if (!found) {
2461                 action = Data.BrokerAction({
2462                     hash: actionHash,
2463                     broker: participation.order.broker,
2464                     orderIndices: new uint[](ctx.brokerOrders.length),
2465                     numOrders: 0,
2466                     transferIndices: new uint[](ctx.brokerTransfers.length * 3),
2467                     numTransfers: 0,
2468                     tokenS: participation.order.tokenS,
2469                     tokenB: participation.order.tokenB,
2470                     feeToken: participation.order.feeToken,
2471                     delegate: address(ctx.delegate)
2472                 });
2473                 ctx.brokerActions[ctx.numBrokerActions] = action;
2474                 ctx.numBrokerActions += 1;
2475                 isActionNewlyCreated = true;
2476             } else {
2477                 found = false;
2478             }
2479 
2480             // Find a preexisting BrokerOrder for the participant's order from those registered with the action
2481             if (!isActionNewlyCreated) {
2482                 for (index = 0; index < action.numOrders; index++) {
2483                     if (ctx.brokerOrders[action.orderIndices[index]].orderHash == participation.order.hash) {
2484                         BrokerData.BrokerOrder memory brokerOrder = ctx.brokerOrders[action.orderIndices[index]];
2485                         brokerOrder.fillAmountB += receivableAmount;
2486                         
2487                         if (isForFeeToken) {
2488                             brokerOrder.requestedFeeAmount += requestAmount;
2489                         } else {
2490                             brokerOrder.requestedAmountS += requestAmount;
2491                         }
2492 
2493                         found = true;
2494                         break;
2495                     }
2496                 }
2497             }
2498             
2499             // If none exist, create a new BrokerOrder
2500             if (!found) {
2501                 ctx.brokerOrders[ctx.numBrokerOrders] = BrokerData.BrokerOrder({
2502                     owner: participation.order.owner,
2503                     orderHash: participation.order.hash,
2504                     fillAmountB: receivableAmount,
2505                     requestedAmountS: isForFeeToken ? 0 : requestAmount,
2506                     requestedFeeAmount: isForFeeToken ? requestAmount : 0,
2507                     tokenRecipient: participation.order.tokenRecipient,
2508                     extraData: participation.order.transferDataS
2509                 });
2510                 action.orderIndices[action.numOrders] = ctx.numBrokerOrders;
2511                 action.numOrders += 1;
2512                 ctx.numBrokerOrders += 1;
2513             } else {
2514                 found = false;
2515             }
2516 
2517             // Find a preexisting BrokerTransfer from those registered with the action
2518             if (!isActionNewlyCreated) {
2519                 for (index = 0; index < action.numTransfers; index++) {
2520                     if (ctx.brokerTransfers[action.transferIndices[index]].hash == transferHash) {
2521                         Data.BrokerTransfer memory transfer = ctx.brokerTransfers[action.transferIndices[index]];
2522                         transfer.amount += requestAmount;
2523                         found = true;
2524                         break;
2525                     }
2526                 }
2527             }
2528 
2529             // If none exist, create a new BrokerTransfer
2530             if (!found) {
2531                 ctx.brokerTransfers[ctx.numBrokerTransfers] = Data.BrokerTransfer(transferHash, requestToken, requestAmount, recipient);
2532                 action.transferIndices[action.numTransfers] = ctx.numBrokerTransfers;
2533                 action.numTransfers += 1;
2534                 ctx.numBrokerTransfers += 1;
2535             }
2536         }
2537     }
2538 
2539     function addTokenTransfer(
2540         uint data,
2541         uint ptr,
2542         address token,
2543         address from,
2544         address to,
2545         uint amount
2546         )
2547         internal
2548         pure
2549         returns (uint)
2550     {
2551         if (amount > 0 && from != to) {
2552             assembly {
2553                 // Try to find an existing fee payment of the same token to the same owner
2554                 let addNew := 1
2555                 for { let p := data } lt(p, ptr) { p := add(p, 128) } {
2556                     let dataToken := mload(add(p,  0))
2557                     let dataFrom := mload(add(p, 32))
2558                     let dataTo := mload(add(p, 64))
2559                     // if(token == dataToken && from == dataFrom && to == dataTo)
2560                     if and(and(eq(token, dataToken), eq(from, dataFrom)), eq(to, dataTo)) {
2561                         let dataAmount := mload(add(p, 96))
2562                         // dataAmount = amount.add(dataAmount);
2563                         dataAmount := add(amount, dataAmount)
2564                         // require(dataAmount >= amount) (safe math)
2565                         if lt(dataAmount, amount) {
2566                             revert(0, 0)
2567                         }
2568                         mstore(add(p, 96), dataAmount)
2569                         addNew := 0
2570                         // End the loop
2571                         p := ptr
2572                     }
2573                 }
2574                 // Add a new transfer
2575                 if eq(addNew, 1) {
2576                     mstore(add(ptr,  0), token)
2577                     mstore(add(ptr, 32), from)
2578                     mstore(add(ptr, 64), to)
2579                     mstore(add(ptr, 96), amount)
2580                     ptr := add(ptr, 128)
2581                 }
2582             }
2583             return ptr;
2584         } else {
2585             return ptr;
2586         }
2587     }
2588 
2589     function payFees(
2590         Data.Ring memory ring,
2591         Data.Context memory ctx,
2592         Data.Mining memory mining
2593         )
2594         internal
2595     {
2596         Data.FeeContext memory feeCtx;
2597         feeCtx.ring = ring;
2598         feeCtx.ctx = ctx;
2599         feeCtx.feeRecipient = mining.feeRecipient;
2600         for (uint i = 0; i < ring.size; i++) {
2601             payFeesForParticipation(
2602                 feeCtx,
2603                 ring.participations[i]
2604             );
2605         }
2606     }
2607 
2608     function payFeesForParticipation(
2609         Data.FeeContext memory feeCtx,
2610         Data.Participation memory p
2611         )
2612         internal
2613         returns (uint)
2614     {
2615         feeCtx.walletPercentage = p.order.P2P ? 100 : (
2616             (p.order.wallet == address(0x0) ? 0 : p.order.walletSplitPercentage)
2617         );
2618         feeCtx.waiveFeePercentage = p.order.waiveFeePercentage;
2619         feeCtx.owner = p.order.owner;
2620         feeCtx.wallet = p.order.wallet;
2621         feeCtx.P2P = p.order.P2P;
2622 
2623         p.rebateFee = payFeesAndBurn(
2624             feeCtx,
2625             p.order.feeToken,
2626             p.feeAmount
2627         );
2628         p.rebateS = payFeesAndBurn(
2629             feeCtx,
2630             p.order.tokenS,
2631             p.feeAmountS
2632         );
2633         p.rebateB = payFeesAndBurn(
2634             feeCtx,
2635             p.order.tokenB,
2636             p.feeAmountB
2637         );
2638     }
2639 
2640     function payFeesAndBurn(
2641         Data.FeeContext memory feeCtx,
2642         address token,
2643         uint totalAmount
2644         )
2645         internal
2646         returns (uint)
2647     {
2648         if (totalAmount == 0) {
2649             return 0;
2650         }
2651 
2652         uint amount = totalAmount;
2653         // No need to pay any fees in a P2P order without a wallet
2654         // (but the fee amount is a part of amountS of the order, so the fee amount is rebated).
2655         if (feeCtx.P2P && feeCtx.wallet == address(0x0)) {
2656             amount = 0;
2657         }
2658 
2659         uint feeToWallet = 0;
2660         uint minerFee = 0;
2661         uint minerFeeBurn = 0;
2662         uint walletFeeBurn = 0;
2663         if (amount > 0) {
2664             feeToWallet = amount.mul(feeCtx.walletPercentage) / 100;
2665             minerFee = amount - feeToWallet;
2666 
2667             // Miner can waive fees for this order. If waiveFeePercentage > 0 this is a simple reduction in fees.
2668             if (feeCtx.waiveFeePercentage > 0) {
2669                 minerFee = minerFee.mul(
2670                     feeCtx.ctx.feePercentageBase - uint(feeCtx.waiveFeePercentage)) /
2671                     feeCtx.ctx.feePercentageBase;
2672             } else if (feeCtx.waiveFeePercentage < 0) {
2673                 // No fees need to be paid by this order
2674                 minerFee = 0;
2675             }
2676 
2677             uint32 burnRate = getBurnRate(feeCtx, token);
2678             assert(burnRate <= feeCtx.ctx.feePercentageBase);
2679 
2680             // Miner fee
2681             minerFeeBurn = minerFee.mul(burnRate) / feeCtx.ctx.feePercentageBase;
2682             minerFee = minerFee - minerFeeBurn;
2683             // Wallet fee
2684             walletFeeBurn = feeToWallet.mul(burnRate) / feeCtx.ctx.feePercentageBase;
2685             feeToWallet = feeToWallet - walletFeeBurn;
2686 
2687             // Pay the wallet
2688             feeCtx.ctx.feePtr = addFeePayment(
2689                 feeCtx.ctx.feeData,
2690                 feeCtx.ctx.feePtr,
2691                 token,
2692                 feeCtx.wallet,
2693                 feeToWallet
2694             );
2695 
2696             // Pay the burn rate with the feeHolder as owner
2697             feeCtx.ctx.feePtr = addFeePayment(
2698                 feeCtx.ctx.feeData,
2699                 feeCtx.ctx.feePtr,
2700                 token,
2701                 address(feeCtx.ctx.feeHolder),
2702                 minerFeeBurn + walletFeeBurn
2703             );
2704 
2705             // Fees can be paid out in different tokens so we can't easily accumulate the total fee
2706             // that needs to be paid out to order owners. So we pay out each part out here to all
2707             // orders that need it.
2708             uint feeToMiner = minerFee;
2709             if (feeCtx.ring.minerFeesToOrdersPercentage > 0 && minerFee > 0) {
2710                 // Pay out the fees to the orders
2711                 distributeMinerFeeToOwners(
2712                     feeCtx,
2713                     token,
2714                     minerFee
2715                 );
2716                 // Subtract all fees the miner pays to the orders
2717                 feeToMiner = minerFee.mul(feeCtx.ctx.feePercentageBase -
2718                     feeCtx.ring.minerFeesToOrdersPercentage) /
2719                     feeCtx.ctx.feePercentageBase;
2720             }
2721 
2722             // Pay the miner
2723             feeCtx.ctx.feePtr = addFeePayment(
2724                 feeCtx.ctx.feeData,
2725                 feeCtx.ctx.feePtr,
2726                 token,
2727                 feeCtx.feeRecipient,
2728                 feeToMiner
2729             );
2730         }
2731 
2732         // Calculate the total fee payment after possible discounts (burn rebate + fee waiving)
2733         // and return the total rebate
2734         return totalAmount.sub((feeToWallet + minerFee) + (minerFeeBurn + walletFeeBurn));
2735     }
2736 
2737     function getBurnRate(
2738         Data.FeeContext memory feeCtx,
2739         address token
2740         )
2741         internal
2742         view
2743         returns (uint32)
2744     {
2745         bytes32[] memory tokenBurnRates = feeCtx.ctx.tokenBurnRates;
2746         uint length = tokenBurnRates.length;
2747         for (uint i = 0; i < length; i += 2) {
2748             if (token == address(bytes20(tokenBurnRates[i]))) {
2749                 uint32 burnRate = uint32(bytes4(tokenBurnRates[i + 1]));
2750                 return feeCtx.P2P ? (burnRate / 0x10000) : (burnRate & 0xFFFF);
2751             }
2752         }
2753         // Not found, add it to the list
2754         uint32 burnRate = feeCtx.ctx.burnRateTable.getBurnRate(token);
2755         assembly {
2756             let ptr := add(tokenBurnRates, mul(add(1, length), 32))
2757             mstore(ptr, token)                              // token
2758             mstore(add(ptr, 32), burnRate)                  // burn rate
2759             mstore(tokenBurnRates, add(length, 2))          // length
2760         }
2761         return feeCtx.P2P ? (burnRate / 0x10000) : (burnRate & 0xFFFF);
2762     }
2763 
2764     function distributeMinerFeeToOwners(
2765         Data.FeeContext memory feeCtx,
2766         address token,
2767         uint minerFee
2768         )
2769         internal
2770     {
2771         for (uint i = 0; i < feeCtx.ring.size; i++) {
2772             if (feeCtx.ring.participations[i].order.waiveFeePercentage < 0) {
2773                 uint feeToOwner = minerFee
2774                     .mul(uint(-feeCtx.ring.participations[i].order.waiveFeePercentage)) / feeCtx.ctx.feePercentageBase;
2775 
2776                 emit DistributeFeeRebate(feeCtx.ring.hash, feeCtx.ring.participations[i].order.hash, token, feeToOwner);
2777 
2778                 feeCtx.ctx.feePtr = addFeePayment(
2779                     feeCtx.ctx.feeData,
2780                     feeCtx.ctx.feePtr,
2781                     token,
2782                     feeCtx.ring.participations[i].order.owner,
2783                     feeToOwner);
2784             }
2785         }
2786     }
2787 
2788     function addFeePayment(
2789         uint data,
2790         uint ptr,
2791         address token,
2792         address owner,
2793         uint amount
2794         )
2795         internal
2796         pure
2797         returns (uint)
2798     {
2799         if (amount == 0) {
2800             return ptr;
2801         } else {
2802             assembly {
2803                 // Try to find an existing fee payment of the same token to the same owner
2804                 let addNew := 1
2805                 for { let p := data } lt(p, ptr) { p := add(p, 96) } {
2806                     let dataToken := mload(add(p,  0))
2807                     let dataOwner := mload(add(p, 32))
2808                     // if(token == dataToken && owner == dataOwner)
2809                     if and(eq(token, dataToken), eq(owner, dataOwner)) {
2810                         let dataAmount := mload(add(p, 64))
2811                         // dataAmount = amount.add(dataAmount);
2812                         dataAmount := add(amount, dataAmount)
2813                         // require(dataAmount >= amount) (safe math)
2814                         if lt(dataAmount, amount) {
2815                             revert(0, 0)
2816                         }
2817                         mstore(add(p, 64), dataAmount)
2818                         addNew := 0
2819                         // End the loop
2820                         p := ptr
2821                     }
2822                 }
2823                 // Add a new fee payment
2824                 if eq(addNew, 1) {
2825                     mstore(add(ptr,  0), token)
2826                     mstore(add(ptr, 32), owner)
2827                     mstore(add(ptr, 64), amount)
2828                     ptr := add(ptr, 96)
2829                 }
2830             }
2831             return ptr;
2832         }
2833     }
2834 
2835 }
2836 
2837 // File: contracts/loopring/iface/Errors.sol
2838 
2839 /*
2840 
2841   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
2842 
2843   Licensed under the Apache License, Version 2.0 (the "License");
2844   you may not use this file except in compliance with the License.
2845   You may obtain a copy of the License at
2846 
2847   http://www.apache.org/licenses/LICENSE-2.0
2848 
2849   Unless required by applicable law or agreed to in writing, software
2850   distributed under the License is distributed on an "AS IS" BASIS,
2851   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2852   See the License for the specific language governing permissions and
2853   limitations under the License.
2854 */
2855 pragma solidity 0.5.7;
2856 
2857 
2858 /// @title Errors
2859 contract Errors {
2860     string constant ZERO_VALUE                 = "ZERO_VALUE";
2861     string constant ZERO_ADDRESS               = "ZERO_ADDRESS";
2862     string constant INVALID_VALUE              = "INVALID_VALUE";
2863     string constant INVALID_ADDRESS            = "INVALID_ADDRESS";
2864     string constant INVALID_SIZE               = "INVALID_SIZE";
2865     string constant INVALID_MINER_SIGNATURE    = "INVALID_MINER_SIGNATURE";
2866     string constant INVALID_STATE              = "INVALID_STATE";
2867     string constant NOT_FOUND                  = "NOT_FOUND";
2868     string constant ALREADY_EXIST              = "ALREADY_EXIST";
2869     string constant REENTRY                    = "REENTRY";
2870     string constant UNAUTHORIZED               = "UNAUTHORIZED";
2871     string constant UNIMPLEMENTED              = "UNIMPLEMENTED";
2872     string constant UNSUPPORTED                = "UNSUPPORTED";
2873     string constant TRANSFER_FAILURE           = "TRANSFER_FAILURE";
2874     string constant BROKER_TRANSFER_FAILURE    = "BROKER_TRANSFER_FAILURE";
2875     string constant WITHDRAWAL_FAILURE         = "WITHDRAWAL_FAILURE";
2876     string constant BURN_FAILURE               = "BURN_FAILURE";
2877     string constant BURN_RATE_FROZEN           = "BURN_RATE_FROZEN";
2878     string constant BURN_RATE_MINIMIZED        = "BURN_RATE_MINIMIZED";
2879     string constant UNAUTHORIZED_ONCHAIN_ORDER = "UNAUTHORIZED_ONCHAIN_ORDER";
2880     string constant INVALID_CANDIDATE          = "INVALID_CANDIDATE";
2881     string constant ALREADY_VOTED              = "ALREADY_VOTED";
2882     string constant NOT_OWNER                  = "NOT_OWNER";
2883 }
2884 
2885 // File: contracts/loopring/lib/NoDefaultFunc.sol
2886 
2887 /*
2888 
2889   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
2890 
2891   Licensed under the Apache License, Version 2.0 (the "License");
2892   you may not use this file except in compliance with the License.
2893   You may obtain a copy of the License at
2894 
2895   http://www.apache.org/licenses/LICENSE-2.0
2896 
2897   Unless required by applicable law or agreed to in writing, software
2898   distributed under the License is distributed on an "AS IS" BASIS,
2899   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2900   See the License for the specific language governing permissions and
2901   limitations under the License.
2902 */
2903 pragma solidity 0.5.7;
2904 
2905 
2906 
2907 /// @title NoDefaultFunc
2908 /// @dev Disable default functions.
2909 contract NoDefaultFunc is Errors {
2910     function ()
2911         external
2912         payable
2913     {
2914         revert(UNSUPPORTED);
2915     }
2916 }
2917 
2918 // File: contracts/loopring/lib/ERC20SafeTransfer.sol
2919 
2920 /*
2921 
2922   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
2923 
2924   Licensed under the Apache License, Version 2.0 (the "License");
2925   you may not use this file except in compliance with the License.
2926   You may obtain a copy of the License at
2927 
2928   http://www.apache.org/licenses/LICENSE-2.0
2929 
2930   Unless required by applicable law or agreed to in writing, software
2931   distributed under the License is distributed on an "AS IS" BASIS,
2932   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2933   See the License for the specific language governing permissions and
2934   limitations under the License.
2935 */
2936 pragma solidity 0.5.7;
2937 
2938 
2939 /// @title ERC20 safe transfer
2940 /// @dev see https://github.com/sec-bit/badERC20Fix
2941 /// @author Brecht Devos - <brecht@loopring.org>
2942 library ERC20SafeTransfer {
2943 
2944     function safeTransfer(
2945         address token,
2946         address to,
2947         uint256 value)
2948         internal
2949         returns (bool success)
2950     {
2951         // A transfer is successful when 'call' is successful and depending on the token:
2952         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
2953         // - A single boolean is returned: this boolean needs to be true (non-zero)
2954 
2955         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
2956         bytes memory callData = abi.encodeWithSelector(
2957             bytes4(0xa9059cbb),
2958             to,
2959             value
2960         );
2961         (success, ) = token.call(callData);
2962         return checkReturnValue(success);
2963     }
2964 
2965     function safeTransferFrom(
2966         address token,
2967         address from,
2968         address to,
2969         uint256 value)
2970         internal
2971         returns (bool success)
2972     {
2973         // A transferFrom is successful when 'call' is successful and depending on the token:
2974         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
2975         // - A single boolean is returned: this boolean needs to be true (non-zero)
2976 
2977         // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
2978         bytes memory callData = abi.encodeWithSelector(
2979             bytes4(0x23b872dd),
2980             from,
2981             to,
2982             value
2983         );
2984         (success, ) = token.call(callData);
2985         return checkReturnValue(success);
2986     }
2987 
2988     function checkReturnValue(
2989         bool success
2990         )
2991         internal
2992         pure
2993         returns (bool)
2994     {
2995         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
2996         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
2997         // - A single boolean is returned: this boolean needs to be true (non-zero)
2998         if (success) {
2999             assembly {
3000                 switch returndatasize()
3001                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
3002                 case 0 {
3003                     success := 1
3004                 }
3005                 // Standard ERC20: a single boolean value is returned which needs to be true
3006                 case 32 {
3007                     returndatacopy(0, 0, 32)
3008                     success := mload(0)
3009                 }
3010                 // None of the above: not successful
3011                 default {
3012                     success := 0
3013                 }
3014             }
3015         }
3016         return success;
3017     }
3018 
3019 }
3020 
3021 // File: contracts/loopring/impl/ExchangeDeserializer.sol
3022 
3023 /*
3024 
3025   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
3026 
3027   Licensed under the Apache License, Version 2.0 (the "License");
3028   you may not use this file except in compliance with the License.
3029   You may obtain a copy of the License at
3030 
3031   http://www.apache.org/licenses/LICENSE-2.0
3032 
3033   Unless required by applicable law or agreed to in writing, software
3034   distributed under the License is distributed on an "AS IS" BASIS,
3035   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3036   See the License for the specific language governing permissions and
3037   limitations under the License.
3038 */
3039 pragma solidity 0.5.7;
3040 
3041 
3042 
3043 
3044 /// @title Deserializes the data passed to submitRings
3045 /// @author Daniel Wang - <daniel@loopring.org>,
3046 library ExchangeDeserializer {
3047     using BytesUtil     for bytes;
3048 
3049     function deserializeRingIndices(
3050         Data.Order[] memory orders,
3051         Data.RingIndices[] memory ringIndices
3052     ) internal
3053         view returns (
3054             Data.Ring[] memory rings
3055         ) {
3056         rings = new Data.Ring[](ringIndices.length);
3057         for (uint i = 0; i < ringIndices.length; i++) {
3058             rings[i].size = 2;
3059             rings[i].participations = new Data.Participation[](2);
3060 
3061             rings[i].participations[0] = Data.Participation({
3062                 order: orders[ringIndices[i].index0],
3063                 splitS: uint(0),
3064                 feeAmount: uint(0),
3065                 feeAmountS: uint(0),
3066                 feeAmountB: uint(0),
3067                 rebateFee: uint(0),
3068                 rebateS: uint(0),
3069                 rebateB: uint(0),
3070                 fillAmountS: uint(0),
3071                 fillAmountB: uint(0)
3072             });
3073 
3074             rings[i].participations[1] = Data.Participation({
3075                 order: orders[ringIndices[i].index1],
3076                 splitS: uint(0),
3077                 feeAmount: uint(0),
3078                 feeAmountS: uint(0),
3079                 feeAmountB: uint(0),
3080                 rebateFee: uint(0),
3081                 rebateS: uint(0),
3082                 rebateB: uint(0),
3083                 fillAmountS: uint(0),
3084                 fillAmountB: uint(0)
3085             });
3086 
3087             rings[i].hash = bytes32(0);
3088             rings[i].minerFeesToOrdersPercentage = uint(0);
3089             rings[i].valid = true;
3090         }
3091     }
3092 
3093     function deserialize(
3094         address lrcTokenAddress,
3095         bytes memory data
3096         )
3097         internal
3098         view
3099         returns (
3100             Data.Mining memory mining,
3101             Data.Order[] memory orders,
3102             Data.Ring[] memory rings
3103         )
3104     {
3105         // Read the header
3106         Data.Header memory header;
3107         header.version = data.bytesToUint16(0);
3108         header.numOrders = data.bytesToUint16(2);
3109         header.numRings = data.bytesToUint16(4);
3110         header.numSpendables = data.bytesToUint16(6);
3111 
3112         // Validation
3113         require(header.version == 0, "Unsupported serialization format");
3114         require(header.numOrders > 0, "Invalid number of orders");
3115         require(header.numRings > 0, "Invalid number of rings");
3116         require(header.numSpendables > 0, "Invalid number of spendables");
3117 
3118         // Calculate data pointers
3119         uint dataPtr;
3120         assembly {
3121             dataPtr := data
3122         }
3123         uint miningDataPtr = dataPtr + 8;
3124         uint orderDataPtr = miningDataPtr + 3 * 2;
3125         uint ringDataPtr = orderDataPtr + (32 * header.numOrders) * 2;
3126         uint dataBlobPtr = ringDataPtr + (header.numRings * 9) + 32;
3127 
3128         // The data stream needs to be at least large enough for the
3129         // header/mining/orders/rings data + 64 bytes of zeros in the data blob.
3130         require(data.length >= (dataBlobPtr - dataPtr) + 32, "Invalid input data");
3131 
3132         // Setup the rings
3133         mining = setupMiningData(dataBlobPtr, miningDataPtr + 2);
3134         orders = setupOrders(dataBlobPtr, orderDataPtr + 2, header.numOrders, header.numSpendables, lrcTokenAddress);
3135         rings = assembleRings(ringDataPtr + 1, header.numRings, orders);
3136     }
3137 
3138     function setupMiningData(
3139         uint data,
3140         uint tablesPtr
3141         )
3142         internal
3143         view
3144         returns (Data.Mining memory mining)
3145     {
3146         bytes memory emptyBytes = new bytes(0);
3147         uint offset;
3148 
3149         assembly {
3150             // Default to transaction origin for feeRecipient
3151             mstore(add(data, 20), origin)
3152 
3153             // mining.feeRecipient
3154             offset := mul(and(mload(add(tablesPtr,  0)), 0xFFFF), 4)
3155             mstore(
3156                 add(mining,   0),
3157                 mload(add(add(data, 20), offset))
3158             )
3159 
3160             // Restore default to 0
3161             mstore(add(data, 20), 0)
3162 
3163             // mining.miner
3164             offset := mul(and(mload(add(tablesPtr,  2)), 0xFFFF), 4)
3165             mstore(
3166                 add(mining,  32),
3167                 mload(add(add(data, 20), offset))
3168             )
3169 
3170             // Default to empty bytes array
3171             mstore(add(data, 32), emptyBytes)
3172 
3173             // mining.sig
3174             offset := mul(and(mload(add(tablesPtr,  4)), 0xFFFF), 4)
3175             mstore(
3176                 add(mining, 64),
3177                 add(data, add(offset, 32))
3178             )
3179 
3180             // Restore default to 0
3181             mstore(add(data, 32), 0)
3182         }
3183     }
3184 
3185     function setupOrders(
3186         uint data,
3187         uint tablesPtr,
3188         uint numOrders,
3189         uint numSpendables,
3190         address lrcTokenAddress
3191         )
3192         internal
3193         pure
3194         returns (Data.Order[] memory orders)
3195     {
3196         bytes memory emptyBytes = new bytes(0);
3197         uint orderStructSize = 40 * 32;
3198         // Memory for orders length + numOrders order pointers
3199         uint arrayDataSize = (1 + numOrders) * 32;
3200         Data.Spendable[] memory spendableList = new Data.Spendable[](numSpendables);
3201         uint offset;
3202 
3203         assembly {
3204             // Allocate memory for all orders
3205             orders := mload(0x40)
3206             mstore(add(orders, 0), numOrders)                       // orders.length
3207             // Reserve the memory for the orders array
3208             mstore(0x40, add(orders, add(arrayDataSize, mul(orderStructSize, numOrders))))
3209 
3210             for { let i := 0 } lt(i, numOrders) { i := add(i, 1) } {
3211                 let order := add(orders, add(arrayDataSize, mul(orderStructSize, i)))
3212 
3213                 // Store the memory location of this order in the orders array
3214                 mstore(add(orders, mul(add(1, i), 32)), order)
3215 
3216                 // order.version
3217                 offset := and(mload(add(tablesPtr,  0)), 0xFFFF)
3218                 mstore(
3219                     add(order,   0),
3220                     offset
3221                 )
3222 
3223                 // order.owner
3224                 offset := mul(and(mload(add(tablesPtr,  2)), 0xFFFF), 4)
3225                 mstore(
3226                     add(order,  32),
3227                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3228                 )
3229 
3230                 // order.tokenS
3231                 offset := mul(and(mload(add(tablesPtr,  4)), 0xFFFF), 4)
3232                 mstore(
3233                     add(order,  64),
3234                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3235                 )
3236 
3237                 // order.tokenB
3238                 offset := mul(and(mload(add(tablesPtr,  6)), 0xFFFF), 4)
3239                 mstore(
3240                     add(order,  96),
3241                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3242                 )
3243 
3244                 // order.amountS
3245                 offset := mul(and(mload(add(tablesPtr,  8)), 0xFFFF), 4)
3246                 mstore(
3247                     add(order, 128),
3248                     mload(add(add(data, 32), offset))
3249                 )
3250 
3251                 // order.amountB
3252                 offset := mul(and(mload(add(tablesPtr, 10)), 0xFFFF), 4)
3253                 mstore(
3254                     add(order, 160),
3255                     mload(add(add(data, 32), offset))
3256                 )
3257 
3258                 // order.validSince
3259                 offset := mul(and(mload(add(tablesPtr, 12)), 0xFFFF), 4)
3260                 mstore(
3261                     add(order, 192),
3262                     and(mload(add(add(data, 4), offset)), 0xFFFFFFFF)
3263                 )
3264 
3265                 // order.tokenSpendableS
3266                 offset := and(mload(add(tablesPtr, 14)), 0xFFFF)
3267                 // Force the spendable index to 0 if it's invalid
3268                 offset := mul(offset, lt(offset, numSpendables))
3269                 mstore(
3270                     add(order, 224),
3271                     mload(add(spendableList, mul(add(offset, 1), 32)))
3272                 )
3273 
3274                 // order.tokenSpendableFee
3275                 offset := and(mload(add(tablesPtr, 16)), 0xFFFF)
3276                 // Force the spendable index to 0 if it's invalid
3277                 offset := mul(offset, lt(offset, numSpendables))
3278                 mstore(
3279                     add(order, 256),
3280                     mload(add(spendableList, mul(add(offset, 1), 32)))
3281                 )
3282 
3283                 // order.dualAuthAddr
3284                 offset := mul(and(mload(add(tablesPtr, 18)), 0xFFFF), 4)
3285                 mstore(
3286                     add(order, 288),
3287                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3288                 )
3289 
3290                 // order.broker
3291                 offset := mul(and(mload(add(tablesPtr, 20)), 0xFFFF), 4)
3292                 mstore(
3293                     add(order, 320),
3294                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3295                 )
3296 
3297                 // order.orderInterceptor
3298                 offset := mul(and(mload(add(tablesPtr, 22)), 0xFFFF), 4)
3299                 mstore(
3300                     add(order, 416),
3301                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3302                 )
3303 
3304                 // order.wallet
3305                 offset := mul(and(mload(add(tablesPtr, 24)), 0xFFFF), 4)
3306                 mstore(
3307                     add(order, 448),
3308                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3309                 )
3310 
3311                 // order.validUntil
3312                 offset := mul(and(mload(add(tablesPtr, 26)), 0xFFFF), 4)
3313                 mstore(
3314                     add(order, 480),
3315                     and(mload(add(add(data,  4), offset)), 0xFFFFFFFF)
3316                 )
3317 
3318                 // Default to empty bytes array for value sig and dualAuthSig
3319                 mstore(add(data, 32), emptyBytes)
3320 
3321                 // order.sig
3322                 offset := mul(and(mload(add(tablesPtr, 28)), 0xFFFF), 4)
3323                 mstore(
3324                     add(order, 512),
3325                     add(data, add(offset, 32))
3326                 )
3327 
3328                 // order.dualAuthSig
3329                 offset := mul(and(mload(add(tablesPtr, 30)), 0xFFFF), 4)
3330                 mstore(
3331                     add(order, 544),
3332                     add(data, add(offset, 32))
3333                 )
3334 
3335                 // Restore default to 0
3336                 mstore(add(data, 32), 0)
3337 
3338                 // order.allOrNone
3339                 offset := and(mload(add(tablesPtr, 32)), 0xFFFF)
3340                 mstore(
3341                     add(order, 576),
3342                     gt(offset, 0)
3343                 )
3344 
3345                 // lrcTokenAddress is the default value for feeToken
3346                 mstore(add(data, 20), lrcTokenAddress)
3347 
3348                 // order.feeToken
3349                 offset := mul(and(mload(add(tablesPtr, 34)), 0xFFFF), 4)
3350                 mstore(
3351                     add(order, 608),
3352                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3353                 )
3354 
3355                 // Restore default to 0
3356                 mstore(add(data, 20), 0)
3357 
3358                 // order.feeAmount
3359                 offset := mul(and(mload(add(tablesPtr, 36)), 0xFFFF), 4)
3360                 mstore(
3361                     add(order, 640),
3362                     mload(add(add(data, 32), offset))
3363                 )
3364 
3365                 // order.waiveFeePercentage
3366                 offset := and(mload(add(tablesPtr, 38)), 0xFFFF)
3367                 mstore(
3368                     add(order, 672),
3369                     offset
3370                 )
3371 
3372                 // order.tokenSFeePercentage
3373                 offset := and(mload(add(tablesPtr, 40)), 0xFFFF)
3374                 mstore(
3375                     add(order, 704),
3376                     offset
3377                 )
3378 
3379                 // order.tokenBFeePercentage
3380                 offset := and(mload(add(tablesPtr, 42)), 0xFFFF)
3381                 mstore(
3382                     add(order, 736),
3383                     offset
3384                 )
3385 
3386                 // The owner is the default value of tokenRecipient
3387                 mstore(add(data, 20), mload(add(order, 32)))                // order.owner
3388 
3389                 // order.tokenRecipient
3390                 offset := mul(and(mload(add(tablesPtr, 44)), 0xFFFF), 4)
3391                 mstore(
3392                     add(order, 768),
3393                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
3394                 )
3395 
3396                 // Restore default to 0
3397                 mstore(add(data, 20), 0)
3398 
3399                 // order.walletSplitPercentage
3400                 offset := and(mload(add(tablesPtr, 46)), 0xFFFF)
3401                 mstore(
3402                     add(order, 800),
3403                     offset
3404                 )
3405 
3406                 // order.tokenTypeS
3407                 offset := and(mload(add(tablesPtr, 48)), 0xFFFF)
3408                 mstore(
3409                     add(order, 1024),
3410                     offset
3411                 )
3412 
3413                 // order.tokenTypeB
3414                 offset := and(mload(add(tablesPtr, 50)), 0xFFFF)
3415                 mstore(
3416                     add(order, 1056),
3417                     offset
3418                 )
3419 
3420                 // order.tokenTypeFee
3421                 offset := and(mload(add(tablesPtr, 52)), 0xFFFF)
3422                 mstore(
3423                     add(order, 1088),
3424                     offset
3425                 )
3426 
3427                 // order.trancheS
3428                 offset := mul(and(mload(add(tablesPtr, 54)), 0xFFFF), 4)
3429                 mstore(
3430                     add(order, 1120),
3431                     mload(add(add(data, 32), offset))
3432                 )
3433 
3434                 // order.trancheB
3435                 offset := mul(and(mload(add(tablesPtr, 56)), 0xFFFF), 4)
3436                 mstore(
3437                     add(order, 1152),
3438                     mload(add(add(data, 32), offset))
3439                 )
3440 
3441                 // Restore default to 0
3442                 mstore(add(data, 20), 0)
3443 
3444                 // order.maxPrimaryFillAmount
3445                 offset := mul(and(mload(add(tablesPtr, 58)), 0xFFFF), 4)
3446                 mstore(
3447                     add(order, 1184),
3448                     mload(add(add(data, 32), offset))
3449                 )
3450 
3451                 // order.allOrNone
3452                 offset := and(mload(add(tablesPtr, 60)), 0xFFFF)
3453                 mstore(
3454                     add(order, 1216),
3455                     gt(offset, 0)
3456                 )
3457 
3458                 // Default to empty bytes array for transferDataS
3459                 mstore(add(data, 32), emptyBytes)
3460 
3461                 // order.transferDataS
3462                 offset := mul(and(mload(add(tablesPtr, 62)), 0xFFFF), 4)
3463                 mstore(
3464                     add(order, 1248),
3465                     add(data, add(offset, 32))
3466                 )
3467 
3468                 // Restore default to 0
3469                 mstore(add(data, 32), 0)
3470 
3471                 // Set default  values
3472                 mstore(add(order, 832), 0)         // order.P2P
3473                 mstore(add(order, 864), 0)         // order.hash
3474                 mstore(add(order, 896), 0)         // order.brokerInterceptor
3475                 mstore(add(order, 928), 0)         // order.filledAmountS
3476                 mstore(add(order, 960), 0)         // order.initialFilledAmountS
3477                 mstore(add(order, 992), 1)         // order.valid
3478 
3479                 // Advance to the next order
3480                 tablesPtr := add(tablesPtr, 64)
3481             }
3482         }
3483     }
3484 
3485     function assembleRings(
3486         uint data,
3487         uint numRings,
3488         Data.Order[] memory orders
3489         )
3490         internal
3491         pure
3492         returns (Data.Ring[] memory rings)
3493     {
3494         uint ringsArrayDataSize = (1 + numRings) * 32;
3495         uint ringStructSize = 5 * 32;
3496         uint participationStructSize = 10 * 32;
3497 
3498         assembly {
3499             // Allocate memory for all rings
3500             rings := mload(0x40)
3501             mstore(add(rings, 0), numRings)                      // rings.length
3502             // Reserve the memory for the rings array
3503             mstore(0x40, add(rings, add(ringsArrayDataSize, mul(ringStructSize, numRings))))
3504 
3505             for { let r := 0 } lt(r, numRings) { r := add(r, 1) } {
3506                 let ring := add(rings, add(ringsArrayDataSize, mul(ringStructSize, r)))
3507 
3508                 // Store the memory location of this ring in the rings array
3509                 mstore(add(rings, mul(add(r, 1), 32)), ring)
3510 
3511                 // Get the ring size
3512                 let ringSize := and(mload(data), 0xFF)
3513                 data := add(data, 1)
3514 
3515                 // require(ringsSize <= 8)
3516                 if gt(ringSize, 8) {
3517                     revert(0, 0)
3518                 }
3519 
3520                 // Allocate memory for all participations
3521                 let participations := mload(0x40)
3522                 mstore(add(participations, 0), ringSize)         // participations.length
3523                 // Memory for participations length + ringSize participation pointers
3524                 let participationsData := add(participations, mul(add(1, ringSize), 32))
3525                 // Reserve the memory for the participations
3526                 mstore(0x40, add(participationsData, mul(participationStructSize, ringSize)))
3527 
3528                 // Initialize ring properties
3529                 mstore(add(ring,   0), ringSize)                 // ring.size
3530                 mstore(add(ring,  32), participations)           // ring.participations
3531                 mstore(add(ring,  64), 0)                        // ring.hash
3532                 mstore(add(ring,  96), 0)                        // ring.minerFeesToOrdersPercentage
3533                 mstore(add(ring, 128), 1)                        // ring.valid
3534 
3535                 for { let i := 0 } lt(i, ringSize) { i := add(i, 1) } {
3536                     let participation := add(participationsData, mul(participationStructSize, i))
3537 
3538                     // Store the memory location of this participation in the participations array
3539                     mstore(add(participations, mul(add(i, 1), 32)), participation)
3540 
3541                     // Get the order index
3542                     let orderIndex := and(mload(data), 0xFF)
3543                     // require(orderIndex < orders.length)
3544                     if iszero(lt(orderIndex, mload(orders))) {
3545                         revert(0, 0)
3546                     }
3547                     data := add(data, 1)
3548 
3549                     // participation.order
3550                     mstore(
3551                         add(participation,   0),
3552                         mload(add(orders, mul(add(orderIndex, 1), 32)))
3553                     )
3554 
3555                     // Set default values
3556                     mstore(add(participation,  32), 0)          // participation.splitS
3557                     mstore(add(participation,  64), 0)          // participation.feeAmount
3558                     mstore(add(participation,  96), 0)          // participation.feeAmountS
3559                     mstore(add(participation, 128), 0)          // participation.feeAmountB
3560                     mstore(add(participation, 160), 0)          // participation.rebateFee
3561                     mstore(add(participation, 192), 0)          // participation.rebateS
3562                     mstore(add(participation, 224), 0)          // participation.rebateB
3563                     mstore(add(participation, 256), 0)          // participation.fillAmountS
3564                     mstore(add(participation, 288), 0)          // participation.fillAmountB
3565                 }
3566 
3567                 // Advance to the next ring
3568                 data := add(data, sub(8, ringSize))
3569             }
3570         }
3571     }
3572 }
3573 
3574 // File: contracts/loopring/impl/RingSubmitter.sol
3575 
3576 /*
3577 
3578   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
3579 
3580   Licensed under the Apache License, Version 2.0 (the "License");
3581   you may not use this file except in compliance with the License.
3582   You may obtain a copy of the License at
3583 
3584   http://www.apache.org/licenses/LICENSE-2.0
3585 
3586   Unless required by applicable law or agreed to in writing, software
3587   distributed under the License is distributed on an "AS IS" BASIS,
3588   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3589   See the License for the specific language governing permissions and
3590   limitations under the License.
3591 */
3592 pragma solidity 0.5.7;
3593 
3594 
3595 
3596 
3597 
3598 
3599 
3600 
3601 
3602 
3603 
3604 
3605 
3606 
3607 
3608 
3609 
3610 
3611 
3612 /// @title An Implementation of IRingSubmitter.
3613 /// @author Daniel Wang - <daniel@loopring.org>,
3614 /// @author Kongliang Zhong - <kongliang@loopring.org>
3615 /// @author Brechtpd - <brecht@loopring.org>
3616 /// Recognized contributing developers from the community:
3617 ///     https://github.com/rainydio
3618 ///     https://github.com/BenjaminPrice
3619 ///     https://github.com/jonasshen
3620 ///     https://github.com/Hephyrius
3621 contract RingSubmitter is IRingSubmitter, NoDefaultFunc {
3622     using MathUint          for uint;
3623     using BytesUtil         for bytes;
3624     using OrderHelper       for Data.Order;
3625     using RingHelper        for Data.Ring;
3626     using MiningHelper      for Data.Mining;
3627     using ERC20SafeTransfer for address;
3628 
3629     address public  lrcTokenAddress             = address(0x0);
3630     address public  wethTokenAddress            = address(0x0);
3631     address public  delegateAddress             = address(0x0);
3632     address public  tradeHistoryAddress         = address(0x0);
3633     address public  orderBrokerRegistryAddress  = address(0x0);
3634     address public  orderRegistryAddress        = address(0x0);
3635     address public  feeHolderAddress            = address(0x0);
3636     address public  orderBookAddress            = address(0x0);
3637     address public  burnRateTableAddress        = address(0x0);
3638 
3639     uint64  public  ringIndex                   = 0;
3640 
3641     constructor(
3642         address _lrcTokenAddress,
3643         address _wethTokenAddress,
3644         address _delegateAddress,
3645         address _tradeHistoryAddress,
3646         address _orderBrokerRegistryAddress,
3647         address _orderRegistryAddress,
3648         address _feeHolderAddress,
3649         address _orderBookAddress,
3650         address _burnRateTableAddress
3651         )
3652         public
3653     {
3654         require(_lrcTokenAddress != address(0x0), ZERO_ADDRESS);
3655         require(_wethTokenAddress != address(0x0), ZERO_ADDRESS);
3656         require(_delegateAddress != address(0x0), ZERO_ADDRESS);
3657         require(_tradeHistoryAddress != address(0x0), ZERO_ADDRESS);
3658         require(_orderBrokerRegistryAddress != address(0x0), ZERO_ADDRESS);
3659         require(_orderRegistryAddress != address(0x0), ZERO_ADDRESS);
3660         require(_feeHolderAddress != address(0x0), ZERO_ADDRESS);
3661         require(_orderBookAddress != address(0x0), ZERO_ADDRESS);
3662         require(_burnRateTableAddress != address(0x0), ZERO_ADDRESS);
3663 
3664         lrcTokenAddress = _lrcTokenAddress;
3665         wethTokenAddress = _wethTokenAddress;
3666         delegateAddress = _delegateAddress;
3667         tradeHistoryAddress = _tradeHistoryAddress;
3668         orderBrokerRegistryAddress = _orderBrokerRegistryAddress;
3669         orderRegistryAddress = _orderRegistryAddress;
3670         feeHolderAddress = _feeHolderAddress;
3671         orderBookAddress = _orderBookAddress;
3672         burnRateTableAddress = _burnRateTableAddress;
3673     }
3674 
3675     function submitRings(
3676         bytes calldata data
3677     ) external {
3678         (
3679             Data.Mining  memory mining,
3680             Data.Order[] memory orders,
3681             Data.Ring[]  memory rings
3682         ) = ExchangeDeserializer.deserialize(lrcTokenAddress, data);
3683         submitRings(mining, orders, rings);
3684     }
3685 
3686 //    function submitRings(
3687 //        Data.SubmitRingsRequest memory request
3688 //    ) public {
3689 //        Data.Ring[] memory rings = ExchangeDeserializer.deserializeRingIndices(request.orders, request.ringIndices);
3690 //        submitRings(request.mining, request.orders, rings);
3691 //    }
3692 
3693     function submitRings(
3694         Data.Mining  memory mining,
3695         Data.Order[] memory orders,
3696         Data.Ring[]  memory rings
3697         )
3698         internal
3699     {
3700         uint i;
3701         bytes32[] memory tokenBurnRates;
3702 
3703         Data.Context memory ctx = Data.Context(
3704             lrcTokenAddress,
3705             ITradeDelegate(delegateAddress),
3706             ITradeHistory(tradeHistoryAddress),
3707             IBrokerRegistry(orderBrokerRegistryAddress),
3708             IOrderRegistry(orderRegistryAddress),
3709             IFeeHolder(feeHolderAddress),
3710             IOrderBook(orderBookAddress),
3711             IBurnRateTable(burnRateTableAddress),
3712             ringIndex,
3713             FEE_PERCENTAGE_BASE,
3714             tokenBurnRates,
3715             0,
3716             0,
3717             0,
3718             0,
3719             new BrokerData.BrokerOrder[](orders.length),
3720             new Data.BrokerAction[](orders.length),
3721             new Data.BrokerTransfer[](orders.length * 3),
3722             0,
3723             0,
3724             0
3725         );
3726 
3727         // Set the highest bit of ringIndex to '1' (IN STORAGE!)
3728         ringIndex = ctx.ringIndex | (1 << 63);
3729 
3730         // Check if the highest bit of ringIndex is '1'
3731         require((ctx.ringIndex >> 63) == 0, REENTRY);
3732 
3733         // Allocate memory that is used to batch things for all rings
3734         setupLists(ctx, orders, rings);
3735 
3736         for (i = 0; i < orders.length; i++) {
3737             orders[i].updateHash();
3738         }
3739 
3740         batchGetFilledAndCheckCancelled(ctx, orders);
3741 
3742         for (i = 0; i < orders.length; i++) {
3743             orders[i].check(ctx);
3744             // An order can only be sent once
3745             for (uint j = i + 1; j < orders.length; j++) {
3746                 require(orders[i].hash != orders[j].hash, "DUPLICATE_HASH");
3747             }
3748         }
3749 
3750         for (i = 0; i < rings.length; i++) {
3751             rings[i].updateHash();
3752         }
3753 
3754         // Update miner if it's set to the default value
3755         if (mining.miner == address(0x0)) {
3756             mining.miner = mining.feeRecipient;
3757         }
3758 
3759         if(!ITradeDelegate(delegateAddress).isTrustedSubmitter(tx.origin)) {
3760             // Only check the miner signature if the submitter isn't "trusted".
3761             mining.updateHash(rings);
3762             require(mining.checkMinerSignature(), INVALID_MINER_SIGNATURE);
3763 
3764             // We only need to check the dual auth signatures of submitters that aren't "trusted"
3765             for (i = 0; i < orders.length; i++) {
3766                 // We don't need to verify the dual author signature again if it uses the same
3767                 // dual author address as the previous order (the miner can optimize the order of the orders
3768                 // so this happens as much as possible). We don't need to check if the signature is the same
3769                 // because the same mining hash is signed for all orders.
3770                 if(i > 0 && orders[i].dualAuthAddr == orders[i - 1].dualAuthAddr) {
3771                     continue;
3772                 }
3773                 orders[i].checkDualAuthSignature(mining.hash);
3774             }
3775         }
3776 
3777     for (i = 0; i < rings.length; i++) {
3778             Data.Ring memory ring = rings[i];
3779             ring.checkOrdersValid();
3780             // ring.checkForSubRings(); // We only submit rings of size 2 - there's no need to check for sub-rings
3781             ring.calculateFillAmountAndFee(ctx);
3782             if (ring.valid) {
3783                 ring.adjustOrderStates();
3784             }
3785         }
3786 
3787         for (i = 0; i < rings.length; i++) {
3788             Data.Ring memory ring = rings[i];
3789             if (ring.valid) {
3790                 // Only settle rings we have checked to be valid
3791                 ring.doPayments(ctx, mining);
3792                 emitRingMinedEvent(
3793                     ring,
3794                     ctx.ringIndex++,
3795                     mining.feeRecipient
3796                 );
3797             } else {
3798                 emit InvalidRing(ring.hash);
3799             }
3800         }
3801 
3802         // Do all token transfers for all rings
3803         batchTransferTokens(ctx);
3804         // Do all broker token transfers for all rings
3805         batchBrokerTransferTokens(ctx, orders);
3806         // Do all fee payments for all rings
3807         batchPayFees(ctx);
3808         // Update all order stats
3809         updateOrdersStats(ctx, orders);
3810 
3811         // Update ringIndex while setting the highest bit of ringIndex back to '0'
3812         ringIndex = ctx.ringIndex;
3813     }
3814 
3815     function emitRingMinedEvent(
3816         Data.Ring memory ring,
3817         uint _ringIndex,
3818         address feeRecipient
3819         )
3820         internal
3821     {
3822         bytes32 ringHash = ring.hash;
3823         // keccak256("RingMined(uint256,bytes32,address,bytes)")
3824         bytes32 ringMinedSignature = 0xb2ef4bc5209dff0c46d5dfddb2b68a23bd4820e8f33107fde76ed15ba90695c9;
3825         uint fillsSize = ring.size * 8 * 32;
3826 
3827         uint data;
3828         uint ptr;
3829         assembly {
3830             data := mload(0x40)
3831             ptr := data
3832             mstore(ptr, _ringIndex)                     // ring index data
3833             mstore(add(ptr, 32), 0x40)                  // offset to fills data
3834             mstore(add(ptr, 64), fillsSize)             // fills length
3835             ptr := add(ptr, 96)
3836         }
3837         ptr = ring.generateFills(ptr);
3838 
3839         assembly {
3840             log3(
3841                 data,                                   // data start
3842                 sub(ptr, data),                         // data length
3843                 ringMinedSignature,                     // Topic 0: RingMined signature
3844                 ringHash,                               // Topic 1: ring hash
3845                 feeRecipient                            // Topic 2: feeRecipient
3846             )
3847         }
3848     }
3849 
3850     function setupLists(
3851         Data.Context memory ctx,
3852         Data.Order[] memory orders,
3853         Data.Ring[] memory rings
3854         )
3855         internal
3856         pure
3857     {
3858         setupTokenBurnRateList(ctx, orders);
3859         setupFeePaymentList(ctx, rings);
3860         setupTokenTransferList(ctx, rings);
3861     }
3862 
3863     function setupTokenBurnRateList(
3864         Data.Context memory ctx,
3865         Data.Order[] memory orders
3866         )
3867         internal
3868         pure
3869     {
3870         // Allocate enough memory to store burn rates for all tokens even
3871         // if every token is unique (max 2 unique tokens / order)
3872         uint maxNumTokenBurnRates = orders.length * 2;
3873         bytes32[] memory tokenBurnRates;
3874         assembly {
3875             tokenBurnRates := mload(0x40)
3876             mstore(tokenBurnRates, 0)                               // tokenBurnRates.length
3877             mstore(0x40, add(
3878                 tokenBurnRates,
3879                 add(32, mul(maxNumTokenBurnRates, 64))
3880             ))
3881         }
3882         ctx.tokenBurnRates = tokenBurnRates;
3883     }
3884 
3885     function setupFeePaymentList(
3886         Data.Context memory ctx,
3887         Data.Ring[] memory rings
3888         )
3889         internal
3890         pure
3891     {
3892         uint totalMaxSizeFeePayments = 0;
3893         for (uint i = 0; i < rings.length; i++) {
3894             // Up to (ringSize + 3) * 3 payments per order (because of fee sharing by miner)
3895             // (3 x 32 bytes for every fee payment)
3896             uint ringSize = rings[i].size;
3897             uint maxSize = (ringSize + 3) * 3 * ringSize * 3;
3898             totalMaxSizeFeePayments += maxSize;
3899         }
3900         // Store the data directly in the call data format as expected by batchAddFeeBalances:
3901         // - 0x00: batchAddFeeBalances selector (4 bytes)
3902         // - 0x04: parameter offset (batchAddFeeBalances has a single function parameter) (32 bytes)
3903         // - 0x24: length of the array passed into the function (32 bytes)
3904         // - 0x44: the array data (32 bytes x length)
3905         bytes4 batchAddFeeBalancesSelector = ctx.feeHolder.batchAddFeeBalances.selector;
3906         uint ptr;
3907         assembly {
3908             let data := mload(0x40)
3909             mstore(data, batchAddFeeBalancesSelector)
3910             mstore(add(data, 4), 32)
3911             ptr := add(data, 68)
3912             mstore(0x40, add(ptr, mul(totalMaxSizeFeePayments, 32)))
3913         }
3914         ctx.feeData = ptr;
3915         ctx.feePtr = ptr;
3916     }
3917 
3918     function setupTokenTransferList(
3919         Data.Context memory ctx,
3920         Data.Ring[] memory rings
3921         )
3922         internal
3923         pure
3924     {
3925         uint totalMaxSizeTransfers = 0;
3926         for (uint i = 0; i < rings.length; i++) {
3927             // Up to 4 transfers per order
3928             // (4 x 32 bytes for every transfer)
3929             uint maxSize = 4 * rings[i].size * 4;
3930             totalMaxSizeTransfers += maxSize;
3931         }
3932         // Store the data directly in the call data format as expected by batchTransfer:
3933         // - 0x00: batchTransfer selector (4 bytes)
3934         // - 0x04: parameter offset (batchTransfer has a single function parameter) (32 bytes)
3935         // - 0x24: length of the array passed into the function (32 bytes)
3936         // - 0x44: the array data (32 bytes x length)
3937         bytes4 batchTransferSelector = ctx.delegate.batchTransfer.selector;
3938         uint ptr;
3939         assembly {
3940             let data := mload(0x40)
3941             mstore(data, batchTransferSelector)
3942             mstore(add(data, 4), 32)
3943             ptr := add(data, 68)
3944             mstore(0x40, add(ptr, mul(totalMaxSizeTransfers, 32)))
3945         }
3946         ctx.transferData = ptr;
3947         ctx.transferPtr = ptr;
3948     }
3949 
3950     function updateOrdersStats(
3951         Data.Context memory ctx,
3952         Data.Order[] memory orders
3953         )
3954         internal
3955     {
3956         // Store the data directly in the call data format as expected by batchUpdateFilled:
3957         // - 0x00: batchUpdateFilled selector (4 bytes)
3958         // - 0x04: parameter offset (batchUpdateFilled has a single function parameter) (32 bytes)
3959         // - 0x24: length of the array passed into the function (32 bytes)
3960         // - 0x44: the array data (32 bytes x length)
3961         // For every (valid) order we store 2 words:
3962         // - order.hash
3963         // - order.filledAmountS after all rings
3964         bytes4 batchUpdateFilledSelector = ctx.tradeHistory.batchUpdateFilled.selector;
3965         address _tradeHistoryAddress = address(ctx.tradeHistory);
3966         assembly {
3967             let data := mload(0x40)
3968             mstore(data, batchUpdateFilledSelector)
3969             mstore(add(data, 4), 32)
3970             let ptr := add(data, 68)
3971             let arrayLength := 0
3972             for { let i := 0 } lt(i, mload(orders)) { i := add(i, 1) } {
3973                 let order := mload(add(orders, mul(add(i, 1), 32)))
3974                 let filledAmount := mload(add(order, 928))                               // order.filledAmountS
3975                 let initialFilledAmount := mload(add(order, 960))                        // order.initialFilledAmountS
3976                 let filledAmountChanged := iszero(eq(filledAmount, initialFilledAmount))
3977                 // if (order.valid && filledAmountChanged)
3978                 if and(gt(mload(add(order, 992)), 0), filledAmountChanged) {             // order.valid
3979                     mstore(add(ptr,   0), mload(add(order, 864)))                        // order.hash
3980                     mstore(add(ptr,  32), filledAmount)
3981 
3982                     ptr := add(ptr, 64)
3983                     arrayLength := add(arrayLength, 2)
3984                 }
3985             }
3986 
3987             // Only do the external call if the list is not empty
3988             if gt(arrayLength, 0) {
3989                 mstore(add(data, 36), arrayLength)      // filledInfo.length
3990 
3991                 let success := call(
3992                     gas,                                // forward all gas
3993                     _tradeHistoryAddress,               // external address
3994                     0,                                  // wei
3995                     data,                               // input start
3996                     sub(ptr, data),                     // input length
3997                     data,                               // output start
3998                     0                                   // output length
3999                 )
4000                 if eq(success, 0) {
4001                     // Propagate the revert message
4002                     returndatacopy(0, 0, returndatasize())
4003                     revert(0, returndatasize())
4004                 }
4005             }
4006         }
4007     }
4008 
4009     function batchGetFilledAndCheckCancelled(
4010         Data.Context memory ctx,
4011         Data.Order[] memory orders
4012         )
4013         internal
4014     {
4015         // Store the data in the call data format as expected by batchGetFilledAndCheckCancelled:
4016         // - 0x00: batchGetFilledAndCheckCancelled selector (4 bytes)
4017         // - 0x04: parameter offset (batchGetFilledAndCheckCancelled has a single function parameter) (32 bytes)
4018         // - 0x24: length of the array passed into the function (32 bytes)
4019         // - 0x44: the array data (32 bytes x length)
4020         // For every order we store 5 words:
4021         // - order.broker
4022         // - order.owner
4023         // - order.hash
4024         // - order.validSince
4025         // - The trading pair of the order: order.tokenS ^ order.tokenB
4026         bytes4 batchGetFilledAndCheckCancelledSelector = ctx.tradeHistory.batchGetFilledAndCheckCancelled.selector;
4027         address _tradeHistoryAddress = address(ctx.tradeHistory);
4028         assembly {
4029             let data := mload(0x40)
4030             mstore(data, batchGetFilledAndCheckCancelledSelector)
4031             mstore(add(data,  4), 32)
4032             mstore(add(data, 36), mul(mload(orders), 5))                // orders.length
4033             let ptr := add(data, 68)
4034             for { let i := 0 } lt(i, mload(orders)) { i := add(i, 1) } {
4035                 let order := mload(add(orders, mul(add(i, 1), 32)))     // orders[i]
4036                 mstore(add(ptr,   0), mload(add(order, 320)))           // order.broker
4037                 mstore(add(ptr,  32), mload(add(order,  32)))           // order.owner
4038                 mstore(add(ptr,  64), mload(add(order, 864)))           // order.hash
4039                 mstore(add(ptr,  96), mload(add(order, 192)))           // order.validSince
4040                 // bytes20(order.tokenS) ^ bytes20(order.tokenB)        // tradingPair
4041                 mstore(add(ptr, 128), mul(
4042                     xor(
4043                         mload(add(order, 64)),                 // order.tokenS
4044                         mload(add(order, 96))                  // order.tokenB
4045                     ),
4046                     0x1000000000000000000000000)               // shift left 12 bytes (bytes20 is padded on the right)
4047                 )
4048                 ptr := add(ptr, 160)                                    // 5 * 32
4049             }
4050             // Return data is stored just like the call data without the signature:
4051             // 0x00: Offset to data
4052             // 0x20: Array length
4053             // 0x40: Array data
4054             let returnDataSize := mul(add(2, mload(orders)), 32)
4055             let success := call(
4056                 gas,                                // forward all gas
4057                 _tradeHistoryAddress,               // external address
4058                 0,                                  // wei
4059                 data,                               // input start
4060                 sub(ptr, data),                     // input length
4061                 data,                               // output start
4062                 returnDataSize                      // output length
4063             )
4064             // Check if the call was successful and the return data is the expected size
4065             if or(eq(success, 0), iszero(eq(returndatasize(), returnDataSize))) {
4066                 if eq(success, 0) {
4067                     // Propagate the revert message
4068                     returndatacopy(0, 0, returndatasize())
4069                     revert(0, returndatasize())
4070                 }
4071                 revert(0, 0)
4072             }
4073             for { let i := 0 } lt(i, mload(orders)) { i := add(i, 1) } {
4074                 let order := mload(add(orders, mul(add(i, 1), 32)))     // orders[i]
4075                 let fill := mload(add(data,  mul(add(i, 2), 32)))       // fills[i]
4076                 mstore(add(order, 928), fill)                           // order.filledAmountS
4077                 mstore(add(order, 960), fill)                           // order.initialFilledAmountS
4078                 // If fills[i] == ~uint(0) the order was cancelled
4079                 // order.valid = order.valid && (order.filledAmountS != ~uint(0))
4080                 mstore(add(order, 992),                                 // order.valid
4081                     and(
4082                         gt(mload(add(order, 992)), 0),                  // order.valid
4083                         iszero(eq(fill, not(0)))                        // fill != ~uint(0
4084                     )
4085                 )
4086             }
4087         }
4088     }
4089 
4090     function batchBrokerTransferTokens(Data.Context memory ctx, Data.Order[] memory orders) internal {
4091         BrokerData.BrokerInterceptorReport[] memory reportQueue = new BrokerData.BrokerInterceptorReport[](orders.length);
4092         uint reportCount = 0;
4093 
4094         for (uint i = 0; i < ctx.numBrokerActions; i++) {
4095             Data.BrokerAction memory action = ctx.brokerActions[i];
4096             BrokerData.BrokerApprovalRequest memory request = BrokerData.BrokerApprovalRequest({
4097                 orders: new BrokerData.BrokerOrder[](action.numOrders),
4098                 tokenS: action.tokenS,
4099                 tokenB: action.tokenB,
4100                 feeToken: action.feeToken,
4101                 totalFillAmountB: 0,
4102                 totalRequestedAmountS: 0,
4103                 totalRequestedFeeAmount: 0
4104             });
4105 
4106             for (uint b = 0; b < action.numOrders; b++) {
4107                 request.orders[b] = ctx.brokerOrders[action.orderIndices[b]];
4108                 request.totalFillAmountB += request.orders[b].fillAmountB;
4109                 request.totalRequestedAmountS += request.orders[b].requestedAmountS;
4110                 request.totalRequestedFeeAmount += request.orders[b].requestedFeeAmount;
4111             }
4112 
4113             bool requiresReport = ctx.delegate.proxyBrokerRequestAllowance(request, action.broker);
4114 
4115             if (requiresReport) {
4116                 for (uint k = 0; k < request.orders.length; k++) {
4117                     reportQueue[reportCount] = BrokerData.BrokerInterceptorReport({
4118                         owner: request.orders[k].owner,
4119                         broker: action.broker,
4120                         orderHash: request.orders[k].orderHash,
4121                         tokenB: action.tokenB,
4122                         tokenS: action.tokenS,
4123                         feeToken: action.feeToken,
4124                         fillAmountB: request.orders[k].fillAmountB,
4125                         spentAmountS: request.orders[k].requestedAmountS,
4126                         spentFeeAmount: request.orders[k].requestedFeeAmount,
4127                         tokenRecipient: request.orders[k].tokenRecipient,
4128                         extraData: request.orders[k].extraData
4129                     });
4130                     reportCount += 1;
4131                 }
4132             }
4133 
4134             for (uint j = 0; j < action.numTransfers; j++) {
4135                 Data.BrokerTransfer memory transfer = ctx.brokerTransfers[action.transferIndices[j]];
4136 
4137                 if (transfer.recipient != action.broker) {
4138                     ctx.delegate.brokerTransfer(transfer.token, action.broker, transfer.recipient, transfer.amount);
4139                 }
4140             }
4141         }
4142 
4143         for (uint m = 0; m < reportCount; m++) {
4144             IBrokerDelegate(reportQueue[m].broker).onOrderFillReport(reportQueue[m]);
4145         }
4146     }
4147 
4148     function batchTransferTokens(
4149         Data.Context memory ctx
4150         )
4151         internal
4152     {
4153         // Check if there are any transfers
4154         if (ctx.transferData == ctx.transferPtr) {
4155             return;
4156         }
4157         // We stored the token transfers in the call data as expected by batchTransfer.
4158         // The only thing we still need to do is update the final length of the array and call
4159         // the function on the TradeDelegate contract with the generated data.
4160         address _tradeDelegateAddress = address(ctx.delegate);
4161         uint arrayLength = (ctx.transferPtr - ctx.transferData) / 32;
4162         uint data = ctx.transferData - 68;
4163         uint ptr = ctx.transferPtr;
4164         assembly {
4165             mstore(add(data, 36), arrayLength)      // batch.length
4166 
4167             let success := call(
4168                 gas,                                // forward all gas
4169                 _tradeDelegateAddress,              // external address
4170                 0,                                  // wei
4171                 data,                               // input start
4172                 sub(ptr, data),                     // input length
4173                 data,                               // output start
4174                 0                                   // output length
4175             )
4176             if eq(success, 0) {
4177                 // Propagate the revert message
4178                 returndatacopy(0, 0, returndatasize())
4179                 revert(0, returndatasize())
4180             }
4181         }
4182     }
4183 
4184     function batchPayFees(
4185         Data.Context memory ctx
4186         )
4187         internal
4188     {
4189         // Check if there are any fee payments
4190         if (ctx.feeData == ctx.feePtr) {
4191             return;
4192         }
4193         // We stored the fee payments in the call data as expected by batchAddFeeBalances.
4194         // The only thing we still need to do is update the final length of the array and call
4195         // the function on the FeeHolder contract with the generated data.
4196         address _feeHolderAddress = address(ctx.feeHolder);
4197         uint arrayLength = (ctx.feePtr - ctx.feeData) / 32;
4198         uint data = ctx.feeData - 68;
4199         uint ptr = ctx.feePtr;
4200         assembly {
4201             mstore(add(data, 36), arrayLength)      // batch.length
4202 
4203             let success := call(
4204                 gas,                                // forward all gas
4205                 _feeHolderAddress,                  // external address
4206                 0,                                  // wei
4207                 data,                               // input start
4208                 sub(ptr, data),                     // input length
4209                 data,                               // output start
4210                 0                                   // output length
4211             )
4212             if eq(success, 0) {
4213                 // Propagate the revert message
4214                 returndatacopy(0, 0, returndatasize())
4215                 revert(0, returndatasize())
4216             }
4217         }
4218     }
4219 
4220 }