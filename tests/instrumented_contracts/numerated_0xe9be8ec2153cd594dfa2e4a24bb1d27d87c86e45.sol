1 /*
2 
3   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9   http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 */
17 pragma solidity 0.5.2;
18 
19 
20 /// @title Utility Functions for bytes
21 /// @author Daniel Wang - <daniel@loopring.org>
22 library BytesUtil {
23     function bytesToBytes32(
24         bytes memory b,
25         uint offset
26         )
27         internal
28         pure
29         returns (bytes32)
30     {
31         return bytes32(bytesToUintX(b, offset, 32));
32     }
33 
34     function bytesToUint(
35         bytes memory b,
36         uint offset
37         )
38         internal
39         pure
40         returns (uint)
41     {
42         return bytesToUintX(b, offset, 32);
43     }
44 
45     function bytesToAddress(
46         bytes memory b,
47         uint offset
48         )
49         internal
50         pure
51         returns (address)
52     {
53         return address(bytesToUintX(b, offset, 20) & 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
54     }
55 
56     function bytesToUint16(
57         bytes memory b,
58         uint offset
59         )
60         internal
61         pure
62         returns (uint16)
63     {
64         return uint16(bytesToUintX(b, offset, 2) & 0xFFFF);
65     }
66 
67     function bytesToUintX(
68         bytes memory b,
69         uint offset,
70         uint numBytes
71         )
72         private
73         pure
74         returns (uint data)
75     {
76         require(b.length >= offset + numBytes, "INVALID_SIZE");
77         assembly {
78             data := mload(add(add(b, numBytes), offset))
79         }
80     }
81 
82     function subBytes(
83         bytes memory b,
84         uint offset
85         )
86         internal
87         pure
88         returns (bytes memory data)
89     {
90         require(b.length >= offset + 32, "INVALID_SIZE");
91         assembly {
92             data := add(add(b, 32), offset)
93         }
94     }
95 }
96 /*
97 
98   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
99 
100   Licensed under the Apache License, Version 2.0 (the "License");
101   you may not use this file except in compliance with the License.
102   You may obtain a copy of the License at
103 
104   http://www.apache.org/licenses/LICENSE-2.0
105 
106   Unless required by applicable law or agreed to in writing, software
107   distributed under the License is distributed on an "AS IS" BASIS,
108   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
109   See the License for the specific language governing permissions and
110   limitations under the License.
111 */
112 
113 
114 
115 /// @title Utility Functions for uint
116 /// @author Daniel Wang - <daniel@loopring.org>
117 library MathUint {
118 
119     function mul(
120         uint a,
121         uint b
122         )
123         internal
124         pure
125         returns (uint c)
126     {
127         c = a * b;
128         require(a == 0 || c / a == b, "INVALID_VALUE");
129     }
130 
131     function sub(
132         uint a,
133         uint b
134         )
135         internal
136         pure
137         returns (uint)
138     {
139         require(b <= a, "INVALID_VALUE");
140         return a - b;
141     }
142 
143     function add(
144         uint a,
145         uint b
146         )
147         internal
148         pure
149         returns (uint c)
150     {
151         c = a + b;
152         require(c >= a, "INVALID_VALUE");
153     }
154 
155     function hasRoundingError(
156         uint value,
157         uint numerator,
158         uint denominator
159         )
160         internal
161         pure
162         returns (bool)
163     {
164         uint multiplied = mul(value, numerator);
165         uint remainder = multiplied % denominator;
166         // Return true if the rounding error is larger than 1%
167         return mul(remainder, 100) > multiplied;
168     }
169 }
170 /*
171 
172   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
173 
174   Licensed under the Apache License, Version 2.0 (the "License");
175   you may not use this file except in compliance with the License.
176   You may obtain a copy of the License at
177 
178   http://www.apache.org/licenses/LICENSE-2.0
179 
180   Unless required by applicable law or agreed to in writing, software
181   distributed under the License is distributed on an "AS IS" BASIS,
182   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
183   See the License for the specific language governing permissions and
184   limitations under the License.
185 */
186 
187 
188 
189 /// @title ITradeHistory
190 /// @dev Stores the trade history and cancelled data of orders
191 /// @author Brecht Devos - <brecht@loopring.org>.
192 contract ITradeHistory {
193 
194     // The following map is used to keep trace of order fill and cancellation
195     // history.
196     mapping (bytes32 => uint) public filled;
197 
198     // This map is used to keep trace of order's cancellation history.
199     mapping (address => mapping (bytes32 => bool)) public cancelled;
200 
201     // A map from a broker to its cutoff timestamp.
202     mapping (address => uint) public cutoffs;
203 
204     // A map from a broker to its trading-pair cutoff timestamp.
205     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
206 
207     // A map from a broker to an order owner to its cutoff timestamp.
208     mapping (address => mapping (address => uint)) public cutoffsOwner;
209 
210     // A map from a broker to an order owner to its trading-pair cutoff timestamp.
211     mapping (address => mapping (address => mapping (bytes20 => uint))) public tradingPairCutoffsOwner;
212 
213 
214     function batchUpdateFilled(
215         bytes32[] calldata filledInfo
216         )
217         external;
218 
219     function setCancelled(
220         address broker,
221         bytes32 orderHash
222         )
223         external;
224 
225     function setCutoffs(
226         address broker,
227         uint cutoff
228         )
229         external;
230 
231     function setTradingPairCutoffs(
232         address broker,
233         bytes20 tokenPair,
234         uint cutoff
235         )
236         external;
237 
238     function setCutoffsOfOwner(
239         address broker,
240         address owner,
241         uint cutoff
242         )
243         external;
244 
245     function setTradingPairCutoffsOfOwner(
246         address broker,
247         address owner,
248         bytes20 tokenPair,
249         uint cutoff
250         )
251         external;
252 
253     function batchGetFilledAndCheckCancelled(
254         bytes32[] calldata orderInfo
255         )
256         external
257         view
258         returns (uint[] memory fills);
259 
260 
261     /// @dev Add a Loopring protocol address.
262     /// @param addr A loopring protocol address.
263     function authorizeAddress(
264         address addr
265         )
266         external;
267 
268     /// @dev Remove a Loopring protocol address.
269     /// @param addr A loopring protocol address.
270     function deauthorizeAddress(
271         address addr
272         )
273         external;
274 
275     function isAddressAuthorized(
276         address addr
277         )
278         public
279         view
280         returns (bool);
281 
282 
283     function suspend()
284         external;
285 
286     function resume()
287         external;
288 
289     function kill()
290         external;
291 }
292 /*
293 
294   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
295 
296   Licensed under the Apache License, Version 2.0 (the "License");
297   you may not use this file except in compliance with the License.
298   You may obtain a copy of the License at
299 
300   http://www.apache.org/licenses/LICENSE-2.0
301 
302   Unless required by applicable law or agreed to in writing, software
303   distributed under the License is distributed on an "AS IS" BASIS,
304   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
305   See the License for the specific language governing permissions and
306   limitations under the License.
307 */
308 
309 
310 
311 /// @title ITradeDelegate
312 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
313 /// versions of Loopring protocol to avoid ERC20 re-authorization.
314 /// @author Daniel Wang - <daniel@loopring.org>.
315 contract ITradeDelegate {
316 
317     function batchTransfer(
318         bytes32[] calldata batch
319         )
320         external;
321 
322 
323     /// @dev Add a Loopring protocol address.
324     /// @param addr A loopring protocol address.
325     function authorizeAddress(
326         address addr
327         )
328         external;
329 
330     /// @dev Remove a Loopring protocol address.
331     /// @param addr A loopring protocol address.
332     function deauthorizeAddress(
333         address addr
334         )
335         external;
336 
337     function isAddressAuthorized(
338         address addr
339         )
340         public
341         view
342         returns (bool);
343 
344 
345     function suspend()
346         external;
347 
348     function resume()
349         external;
350 
351     function kill()
352         external;
353 }
354 /*
355 
356   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
357 
358   Licensed under the Apache License, Version 2.0 (the "License");
359   you may not use this file except in compliance with the License.
360   You may obtain a copy of the License at
361 
362   http://www.apache.org/licenses/LICENSE-2.0
363 
364   Unless required by applicable law or agreed to in writing, software
365   distributed under the License is distributed on an "AS IS" BASIS,
366   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
367   See the License for the specific language governing permissions and
368   limitations under the License.
369 */
370 
371 
372 
373 /// @title IOrderRegistry
374 /// @author Daniel Wang - <daniel@loopring.org>.
375 contract IOrderRegistry {
376 
377     /// @dev   Returns wether the order hash was registered in the registry.
378     /// @param broker The broker of the order
379     /// @param orderHash The hash of the order
380     /// @return True if the order hash was registered, else false.
381     function isOrderHashRegistered(
382         address broker,
383         bytes32 orderHash
384         )
385         external
386         view
387         returns (bool);
388 
389     /// @dev   Registers an order in the registry.
390     ///        msg.sender needs to be the broker of the order.
391     /// @param orderHash The hash of the order
392     function registerOrderHash(
393         bytes32 orderHash
394         )
395         external;
396 }
397 /*
398 
399   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
400 
401   Licensed under the Apache License, Version 2.0 (the "License");
402   you may not use this file except in compliance with the License.
403   You may obtain a copy of the License at
404 
405   http://www.apache.org/licenses/LICENSE-2.0
406 
407   Unless required by applicable law or agreed to in writing, software
408   distributed under the License is distributed on an "AS IS" BASIS,
409   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
410   See the License for the specific language governing permissions and
411   limitations under the License.
412 */
413 
414 
415 
416 /// @title IOrderBook
417 /// @author Daniel Wang - <daniel@loopring.org>.
418 /// @author Kongliang Zhong - <kongliang@loopring.org>.
419 contract IOrderBook {
420     // The map of registered order hashes
421     mapping(bytes32 => bool) public orderSubmitted;
422 
423     /// @dev  Event emitted when an order was successfully submitted
424     ///        orderHash      The hash of the order
425     ///        orderData      The data of the order as passed to submitOrder()
426     event OrderSubmitted(
427         bytes32 orderHash,
428         bytes   orderData
429     );
430 
431     /// @dev   Submits an order to the on-chain order book.
432     ///        No signature is needed. The order can only be sumbitted by its
433     ///        owner or its broker (the owner can be the address of a contract).
434     /// @param orderData The data of the order. Contains all fields that are used
435     ///        for the order hash calculation.
436     ///        See OrderHelper.updateHash() for detailed information.
437     function submitOrder(
438         bytes calldata orderData
439         )
440         external
441         returns (bytes32);
442 }
443 /*
444 
445   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
446 
447   Licensed under the Apache License, Version 2.0 (the "License");
448   you may not use this file except in compliance with the License.
449   You may obtain a copy of the License at
450 
451   http://www.apache.org/licenses/LICENSE-2.0
452 
453   Unless required by applicable law or agreed to in writing, software
454   distributed under the License is distributed on an "AS IS" BASIS,
455   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
456   See the License for the specific language governing permissions and
457   limitations under the License.
458 */
459 
460 
461 
462 /// @author Kongliang Zhong - <kongliang@loopring.org>
463 /// @title IFeeHolder - A contract holding fees.
464 contract IFeeHolder {
465 
466     event TokenWithdrawn(
467         address owner,
468         address token,
469         uint value
470     );
471 
472     // A map of all fee balances
473     mapping(address => mapping(address => uint)) public feeBalances;
474 
475     /// @dev   Allows withdrawing the tokens to be burned by
476     ///        authorized contracts.
477     /// @param token The token to be used to burn buy and burn LRC
478     /// @param value The amount of tokens to withdraw
479     function withdrawBurned(
480         address token,
481         uint value
482         )
483         external
484         returns (bool success);
485 
486     /// @dev   Allows withdrawing the fee payments funds
487     ///        msg.sender is the recipient of the fee and the address
488     ///        to which the tokens will be sent.
489     /// @param token The token to withdraw
490     /// @param value The amount of tokens to withdraw
491     function withdrawToken(
492         address token,
493         uint value
494         )
495         external
496         returns (bool success);
497 
498     function batchAddFeeBalances(
499         bytes32[] calldata batch
500         )
501         external;
502 }
503 /*
504 
505   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
506 
507   Licensed under the Apache License, Version 2.0 (the "License");
508   you may not use this file except in compliance with the License.
509   You may obtain a copy of the License at
510 
511   http://www.apache.org/licenses/LICENSE-2.0
512 
513   Unless required by applicable law or agreed to in writing, software
514   distributed under the License is distributed on an "AS IS" BASIS,
515   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
516   See the License for the specific language governing permissions and
517   limitations under the License.
518 */
519 
520 
521 
522 /// @author Brecht Devos - <brecht@loopring.org>
523 /// @title IBurnRateTable - A contract for managing burn rates for tokens
524 contract IBurnRateTable {
525 
526     struct TokenData {
527         uint    tier;
528         uint    validUntil;
529     }
530 
531     mapping(address => TokenData) public tokens;
532 
533     uint public constant YEAR_TO_SECONDS = 31556952;
534 
535     // Tiers
536     uint8 public constant TIER_4 = 0;
537     uint8 public constant TIER_3 = 1;
538     uint8 public constant TIER_2 = 2;
539     uint8 public constant TIER_1 = 3;
540 
541     uint16 public constant BURN_BASE_PERCENTAGE           =                 100 * 10; // 100%
542 
543     // Cost of upgrading the tier level of a token in a percentage of the total LRC supply
544     uint16 public constant TIER_UPGRADE_COST_PERCENTAGE   =                        1; // 0.1%
545 
546     // Burn rates
547     // Matching
548     uint16 public constant BURN_MATCHING_TIER1            =                       25; // 2.5%
549     uint16 public constant BURN_MATCHING_TIER2            =                  15 * 10; //  15%
550     uint16 public constant BURN_MATCHING_TIER3            =                  30 * 10; //  30%
551     uint16 public constant BURN_MATCHING_TIER4            =                  50 * 10; //  50%
552     // P2P
553     uint16 public constant BURN_P2P_TIER1                 =                       25; // 2.5%
554     uint16 public constant BURN_P2P_TIER2                 =                  15 * 10; //  15%
555     uint16 public constant BURN_P2P_TIER3                 =                  30 * 10; //  30%
556     uint16 public constant BURN_P2P_TIER4                 =                  50 * 10; //  50%
557 
558     event TokenTierUpgraded(
559         address indexed addr,
560         uint            tier
561     );
562 
563     /// @dev   Returns the P2P and matching burn rate for the token.
564     /// @param token The token to get the burn rate for.
565     /// @return The burn rate. The P2P burn rate and matching burn rate
566     ///         are packed together in the lowest 4 bytes.
567     ///         (2 bytes P2P, 2 bytes matching)
568     function getBurnRate(
569         address token
570         )
571         external
572         view
573         returns (uint32 burnRate);
574 
575     /// @dev   Returns the tier of a token.
576     /// @param token The token to get the token tier for.
577     /// @return The tier of the token
578     function getTokenTier(
579         address token
580         )
581         public
582         view
583         returns (uint);
584 
585     /// @dev   Upgrades the tier of a token. Before calling this function,
586     ///        msg.sender needs to approve this contract for the neccessary funds.
587     /// @param token The token to upgrade the tier for.
588     /// @return True if successful, false otherwise.
589     function upgradeTokenTier(
590         address token
591         )
592         external
593         returns (bool);
594 
595 }
596 /*
597 
598   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
599 
600   Licensed under the Apache License, Version 2.0 (the "License");
601   you may not use this file except in compliance with the License.
602   You may obtain a copy of the License at
603 
604   http://www.apache.org/licenses/LICENSE-2.0
605 
606   Unless required by applicable law or agreed to in writing, software
607   distributed under the License is distributed on an "AS IS" BASIS,
608   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
609   See the License for the specific language governing permissions and
610   limitations under the License.
611 */
612 
613 
614 
615 /// @title IBrokerRegistry
616 /// @dev A broker is an account that can submit orders on behalf of other
617 ///      accounts. When registering a broker, the owner can also specify a
618 ///      pre-deployed BrokerInterceptor to hook into the exchange smart contracts.
619 /// @author Daniel Wang - <daniel@loopring.org>.
620 contract IBrokerRegistry {
621     event BrokerRegistered(
622         address owner,
623         address broker,
624         address interceptor
625     );
626 
627     event BrokerUnregistered(
628         address owner,
629         address broker,
630         address interceptor
631     );
632 
633     event AllBrokersUnregistered(
634         address owner
635     );
636 
637     /// @dev   Validates if the broker was registered for the order owner and
638     ///        returns the possible BrokerInterceptor to be used.
639     /// @param owner The owner of the order
640     /// @param broker The broker of the order
641     /// @return True if the broker was registered for the owner
642     ///         and the BrokerInterceptor to use.
643     function getBroker(
644         address owner,
645         address broker
646         )
647         external
648         view
649         returns(
650             bool registered,
651             address interceptor
652         );
653 
654     /// @dev   Gets all registered brokers for an owner.
655     /// @param owner The owner
656     /// @param start The start index of the list of brokers
657     /// @param count The number of brokers to return
658     /// @return The list of requested brokers and corresponding BrokerInterceptors
659     function getBrokers(
660         address owner,
661         uint    start,
662         uint    count
663         )
664         external
665         view
666         returns (
667             address[] memory brokers,
668             address[] memory interceptors
669         );
670 
671     /// @dev   Registers a broker for msg.sender and an optional
672     ///        corresponding BrokerInterceptor.
673     /// @param broker The broker to register
674     /// @param interceptor The optional BrokerInterceptor to use (0x0 allowed)
675     function registerBroker(
676         address broker,
677         address interceptor
678         )
679         external;
680 
681     /// @dev   Unregisters a broker for msg.sender
682     /// @param broker The broker to unregister
683     function unregisterBroker(
684         address broker
685         )
686         external;
687 
688     /// @dev   Unregisters all brokers for msg.sender
689     function unregisterAllBrokers(
690         )
691         external;
692 }
693 /*
694 
695   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
696 
697   Licensed under the Apache License, Version 2.0 (the "License");
698   you may not use this file except in compliance with the License.
699   You may obtain a copy of the License at
700 
701   http://www.apache.org/licenses/LICENSE-2.0
702 
703   Unless required by applicable law or agreed to in writing, software
704   distributed under the License is distributed on an "AS IS" BASIS,
705   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
706   See the License for the specific language governing permissions and
707   limitations under the License.
708 */
709 
710 
711 
712 
713 
714 /// @title Utility Functions for Multihash signature verificaiton
715 /// @author Daniel Wang - <daniel@loopring.org>
716 /// For more information:
717 ///   - https://github.com/saurfang/ipfs-multihash-on-solidity
718 ///   - https://github.com/multiformats/multihash
719 ///   - https://github.com/multiformats/js-multihash
720 library MultihashUtil {
721 
722     enum HashAlgorithm { Ethereum, EIP712 }
723 
724     string public constant SIG_PREFIX = "\x19Ethereum Signed Message:\n32";
725 
726     function verifySignature(
727         address signer,
728         bytes32 plaintext,
729         bytes memory multihash
730         )
731         internal
732         pure
733         returns (bool)
734     {
735         uint length = multihash.length;
736         require(length >= 2, "invalid multihash format");
737         uint8 algorithm;
738         uint8 size;
739         assembly {
740             algorithm := mload(add(multihash, 1))
741             size := mload(add(multihash, 2))
742         }
743         require(length == (2 + size), "bad multihash size");
744 
745         if (algorithm == uint8(HashAlgorithm.Ethereum)) {
746             require(signer != address(0x0), "invalid signer address");
747             require(size == 65, "bad Ethereum multihash size");
748             bytes32 hash;
749             uint8 v;
750             bytes32 r;
751             bytes32 s;
752             assembly {
753                 let data := mload(0x40)
754                 mstore(data, 0x19457468657265756d205369676e6564204d6573736167653a0a333200000000) // SIG_PREFIX
755                 mstore(add(data, 28), plaintext)                                                 // plaintext
756                 hash := keccak256(data, 60)                                                      // 28 + 32
757                 // Extract v, r and s from the multihash data
758                 v := mload(add(multihash, 3))
759                 r := mload(add(multihash, 35))
760                 s := mload(add(multihash, 67))
761             }
762             return signer == ecrecover(
763                 hash,
764                 v,
765                 r,
766                 s
767             );
768         } else if (algorithm == uint8(HashAlgorithm.EIP712)) {
769             require(signer != address(0x0), "invalid signer address");
770             require(size == 65, "bad EIP712 multihash size");
771             uint8 v;
772             bytes32 r;
773             bytes32 s;
774             assembly {
775                 // Extract v, r and s from the multihash data
776                 v := mload(add(multihash, 3))
777                 r := mload(add(multihash, 35))
778                 s := mload(add(multihash, 67))
779             }
780             return signer == ecrecover(
781                 plaintext,
782                 v,
783                 r,
784                 s
785             );
786         } else {
787             return false;
788         }
789     }
790 }
791 
792 /*
793 
794   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
795 
796   Licensed under the Apache License, Version 2.0 (the "License");
797   you may not use this file except in compliance with the License.
798   You may obtain a copy of the License at
799 
800   http://www.apache.org/licenses/LICENSE-2.0
801 
802   Unless required by applicable law or agreed to in writing, software
803   distributed under the License is distributed on an "AS IS" BASIS,
804   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
805   See the License for the specific language governing permissions and
806   limitations under the License.
807 */
808 
809 
810 
811 /// @title ERC20 Token Interface
812 /// @dev see https://github.com/ethereum/EIPs/issues/20
813 /// @author Daniel Wang - <daniel@loopring.org>
814 contract ERC20 {
815     function totalSupply()
816         public
817         view
818         returns (uint256);
819 
820     function balanceOf(
821         address who
822         )
823         public
824         view
825         returns (uint256);
826 
827     function allowance(
828         address owner,
829         address spender
830         )
831         public
832         view
833         returns (uint256);
834 
835     function transfer(
836         address to,
837         uint256 value
838         )
839         public
840         returns (bool);
841 
842     function transferFrom(
843         address from,
844         address to,
845         uint256 value
846         )
847         public
848         returns (bool);
849 
850     function approve(
851         address spender,
852         uint256 value
853         )
854         public
855         returns (bool);
856 
857     function verifyTransfer(
858         address from,
859         address to,
860         uint256 amount,
861         bytes memory data
862         )
863         public
864         returns (bool);
865 }
866 /*
867 
868   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
869 
870   Licensed under the Apache License, Version 2.0 (the "License");
871   you may not use this file except in compliance with the License.
872   You may obtain a copy of the License at
873 
874   http://www.apache.org/licenses/LICENSE-2.0
875 
876   Unless required by applicable law or agreed to in writing, software
877   distributed under the License is distributed on an "AS IS" BASIS,
878   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
879   See the License for the specific language governing permissions and
880   limitations under the License.
881 */
882 
883 
884 
885 
886 
887 
888 
889 
890 
891 
892 
893 library Data {
894 
895     enum TokenType { ERC20 }
896 
897     struct Header {
898         uint version;
899         uint numOrders;
900         uint numRings;
901         uint numSpendables;
902     }
903 
904     struct Context {
905         address lrcTokenAddress;
906         ITradeDelegate  delegate;
907         ITradeHistory   tradeHistory;
908         IBrokerRegistry orderBrokerRegistry;
909         IOrderRegistry  orderRegistry;
910         IFeeHolder feeHolder;
911         IOrderBook orderBook;
912         IBurnRateTable burnRateTable;
913         uint64 ringIndex;
914         uint feePercentageBase;
915         bytes32[] tokenBurnRates;
916         uint feeData;
917         uint feePtr;
918         uint transferData;
919         uint transferPtr;
920     }
921 
922     struct Mining {
923         // required fields
924         address feeRecipient;
925 
926         // optional fields
927         address miner;
928         bytes   sig;
929 
930         // computed fields
931         bytes32 hash;
932         address interceptor;
933     }
934 
935     struct Spendable {
936         bool initialized;
937         uint amount;
938         uint reserved;
939     }
940 
941     struct Order {
942         uint      version;
943 
944         // required fields
945         address   owner;
946         address   tokenS;
947         address   tokenB;
948         uint      amountS;
949         uint      amountB;
950         uint      validSince;
951         Spendable tokenSpendableS;
952         Spendable tokenSpendableFee;
953 
954         // optional fields
955         address   dualAuthAddr;
956         address   broker;
957         Spendable brokerSpendableS;
958         Spendable brokerSpendableFee;
959         address   orderInterceptor;
960         address   wallet;
961         uint      validUntil;
962         bytes     sig;
963         bytes     dualAuthSig;
964         bool      allOrNone;
965         address   feeToken;
966         uint      feeAmount;
967         int16     waiveFeePercentage;
968         uint16    tokenSFeePercentage;    // Pre-trading
969         uint16    tokenBFeePercentage;   // Post-trading
970         address   tokenRecipient;
971         uint16    walletSplitPercentage;
972 
973         // computed fields
974         bool    P2P;
975         bytes32 hash;
976         address brokerInterceptor;
977         uint    filledAmountS;
978         uint    initialFilledAmountS;
979         bool    valid;
980 
981         TokenType tokenTypeS;
982         TokenType tokenTypeB;
983         TokenType tokenTypeFee;
984         bytes32 trancheS;
985         bytes32 trancheB;
986         bytes   transferDataS;
987     }
988 
989     struct Participation {
990         // required fields
991         Order order;
992 
993         // computed fields
994         uint splitS;
995         uint feeAmount;
996         uint feeAmountS;
997         uint feeAmountB;
998         uint rebateFee;
999         uint rebateS;
1000         uint rebateB;
1001         uint fillAmountS;
1002         uint fillAmountB;
1003     }
1004 
1005     struct Ring{
1006         uint size;
1007         Participation[] participations;
1008         bytes32 hash;
1009         uint minerFeesToOrdersPercentage;
1010         bool valid;
1011     }
1012 
1013     struct FeeContext {
1014         Data.Ring ring;
1015         Data.Context ctx;
1016         address feeRecipient;
1017         uint walletPercentage;
1018         int16 waiveFeePercentage;
1019         address owner;
1020         address wallet;
1021         bool P2P;
1022     }
1023 }
1024 /*
1025 
1026   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1027 
1028   Licensed under the Apache License, Version 2.0 (the "License");
1029   you may not use this file except in compliance with the License.
1030   You may obtain a copy of the License at
1031 
1032   http://www.apache.org/licenses/LICENSE-2.0
1033 
1034   Unless required by applicable law or agreed to in writing, software
1035   distributed under the License is distributed on an "AS IS" BASIS,
1036   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1037   See the License for the specific language governing permissions and
1038   limitations under the License.
1039 */
1040 
1041 
1042 
1043 /// @title IRingSubmitter
1044 /// @author Daniel Wang - <daniel@loopring.org>
1045 /// @author Kongliang Zhong - <kongliang@loopring.org>
1046 contract IRingSubmitter {
1047     uint16  public constant FEE_PERCENTAGE_BASE = 1000;
1048 
1049     /// @dev  Event emitted when a ring was successfully mined
1050     ///        _ringIndex     The index of the ring
1051     ///        _ringHash      The hash of the ring
1052     ///        _feeRecipient  The recipient of the matching fee
1053     ///        _fills         The info of the orders in the ring stored like:
1054     ///                       [orderHash, owner, tokenS, amountS, split, feeAmount, feeAmountS, feeAmountB]
1055     event RingMined(
1056         uint            _ringIndex,
1057         bytes32 indexed _ringHash,
1058         address indexed _feeRecipient,
1059         bytes           _fills
1060     );
1061 
1062     /// @dev   Event emitted when a ring was not successfully mined
1063     ///         _ringHash  The hash of the ring
1064     event InvalidRing(
1065         bytes32 _ringHash
1066     );
1067 
1068     /// @dev   Submit order-rings for validation and settlement.
1069     /// @param data Packed data of all rings.
1070     function submitRings(
1071         bytes calldata data
1072         )
1073         external;
1074 }
1075 /*
1076 
1077   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1078 
1079   Licensed under the Apache License, Version 2.0 (the "License");
1080   you may not use this file except in compliance with the License.
1081   You may obtain a copy of the License at
1082 
1083   http://www.apache.org/licenses/LICENSE-2.0
1084 
1085   Unless required by applicable law or agreed to in writing, software
1086   distributed under the License is distributed on an "AS IS" BASIS,
1087   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1088   See the License for the specific language governing permissions and
1089   limitations under the License.
1090 */
1091 
1092 
1093 /*
1094 
1095   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1096 
1097   Licensed under the Apache License, Version 2.0 (the "License");
1098   you may not use this file except in compliance with the License.
1099   You may obtain a copy of the License at
1100 
1101   http://www.apache.org/licenses/LICENSE-2.0
1102 
1103   Unless required by applicable law or agreed to in writing, software
1104   distributed under the License is distributed on an "AS IS" BASIS,
1105   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1106   See the License for the specific language governing permissions and
1107   limitations under the License.
1108 */
1109 
1110 
1111 
1112 
1113 
1114 
1115 /// @title MiningHelper
1116 /// @author Daniel Wang - <daniel@loopring.org>.
1117 library MiningHelper {
1118 
1119     function updateMinerAndInterceptor(
1120         Data.Mining memory mining
1121         )
1122         internal
1123         pure
1124     {
1125 
1126         if (mining.miner == address(0x0)) {
1127             mining.miner = mining.feeRecipient;
1128         }
1129 
1130         // We do not support any interceptors for now
1131         /* else { */
1132         /*     (bool registered, address interceptor) = ctx.minerBrokerRegistry.getBroker( */
1133         /*         mining.feeRecipient, */
1134         /*         mining.miner */
1135         /*     ); */
1136         /*     if (registered) { */
1137         /*         mining.interceptor = interceptor; */
1138         /*     } */
1139         /* } */
1140     }
1141 
1142     function updateHash(
1143         Data.Mining memory mining,
1144         Data.Ring[] memory rings
1145         )
1146         internal
1147         pure
1148     {
1149         bytes32 hash;
1150         assembly {
1151             let ring := mload(add(rings, 32))                               // rings[0]
1152             let ringHashes := mload(add(ring, 64))                          // ring.hash
1153             for { let i := 1 } lt(i, mload(rings)) { i := add(i, 1) } {
1154                 ring := mload(add(rings, mul(add(i, 1), 32)))               // rings[i]
1155                 ringHashes := xor(ringHashes, mload(add(ring, 64)))         // ring.hash
1156             }
1157             let data := mload(0x40)
1158             data := add(data, 12)
1159             // Store data back to front to allow overwriting data at the front because of padding
1160             mstore(add(data, 40), ringHashes)                               // ringHashes
1161             mstore(sub(add(data, 20), 12), mload(add(mining, 32)))          // mining.miner
1162             mstore(sub(data, 12),          mload(add(mining,  0)))          // mining.feeRecipient
1163             hash := keccak256(data, 72)                                     // 20 + 20 + 32
1164         }
1165         mining.hash = hash;
1166     }
1167 
1168     function checkMinerSignature(
1169         Data.Mining memory mining
1170         )
1171         internal
1172         view
1173         returns (bool)
1174     {
1175         if (mining.sig.length == 0) {
1176             return (msg.sender == mining.miner);
1177         } else {
1178             return MultihashUtil.verifySignature(
1179                 mining.miner,
1180                 mining.hash,
1181                 mining.sig
1182             );
1183         }
1184     }
1185 
1186 }
1187 
1188 /*
1189 
1190   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1191 
1192   Licensed under the Apache License, Version 2.0 (the "License");
1193   you may not use this file except in compliance with the License.
1194   You may obtain a copy of the License at
1195 
1196   http://www.apache.org/licenses/LICENSE-2.0
1197 
1198   Unless required by applicable law or agreed to in writing, software
1199   distributed under the License is distributed on an "AS IS" BASIS,
1200   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1201   See the License for the specific language governing permissions and
1202   limitations under the License.
1203 */
1204 
1205 
1206 
1207 
1208 
1209 
1210 
1211 
1212 /// @title OrderHelper
1213 /// @author Daniel Wang - <daniel@loopring.org>.
1214 library OrderHelper {
1215     using MathUint      for uint;
1216 
1217     string constant internal EIP191_HEADER = "\x19\x01";
1218     string constant internal EIP712_DOMAIN_NAME = "Loopring Protocol";
1219     string constant internal EIP712_DOMAIN_VERSION = "2";
1220     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(
1221         abi.encodePacked(
1222             "EIP712Domain(",
1223             "string name,",
1224             "string version",
1225             ")"
1226         )
1227     );
1228     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(
1229         abi.encodePacked(
1230             "Order(",
1231             "uint amountS,",
1232             "uint amountB,",
1233             "uint feeAmount,",
1234             "uint validSince,",
1235             "uint validUntil,",
1236             "address owner,",
1237             "address tokenS,",
1238             "address tokenB,",
1239             "address dualAuthAddr,",
1240             "address broker,",
1241             "address orderInterceptor,",
1242             "address wallet,",
1243             "address tokenRecipient,",
1244             "address feeToken,",
1245             "uint16 walletSplitPercentage,",
1246             "uint16 tokenSFeePercentage,",
1247             "uint16 tokenBFeePercentage,",
1248             "bool allOrNone,",
1249             "uint8 tokenTypeS,",
1250             "uint8 tokenTypeB,",
1251             "uint8 tokenTypeFee,",
1252             "bytes32 trancheS,",
1253             "bytes32 trancheB,",
1254             "bytes transferDataS",
1255             ")"
1256         )
1257     );
1258     bytes32 constant internal EIP712_DOMAIN_HASH = keccak256(
1259         abi.encodePacked(
1260             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1261             keccak256(bytes(EIP712_DOMAIN_NAME)),
1262             keccak256(bytes(EIP712_DOMAIN_VERSION))
1263         )
1264     );
1265 
1266     function updateHash(Data.Order memory order)
1267         internal
1268         pure
1269     {
1270         /* bytes32 message = keccak256( */
1271         /*     abi.encode( */
1272         /*         EIP712_ORDER_SCHEMA_HASH, */
1273         /*         order.amountS, */
1274         /*         order.amountB, */
1275         /*         order.feeAmount, */
1276         /*         order.validSince, */
1277         /*         order.validUntil, */
1278         /*         order.owner, */
1279         /*         order.tokenS, */
1280         /*         order.tokenB, */
1281         /*         order.dualAuthAddr, */
1282         /*         order.broker, */
1283         /*         order.orderInterceptor, */
1284         /*         order.wallet, */
1285         /*         order.tokenRecipient */
1286         /*         order.feeToken, */
1287         /*         order.walletSplitPercentage, */
1288         /*         order.tokenSFeePercentage, */
1289         /*         order.tokenBFeePercentage, */
1290         /*         order.allOrNone, */
1291         /*         order.tokenTypeS, */
1292         /*         order.tokenTypeB, */
1293         /*         order.tokenTypeFee, */
1294         /*         order.trancheS, */
1295         /*         order.trancheB, */
1296         /*         order.transferDataS */
1297         /*     ) */
1298         /* ); */
1299         /* order.hash = keccak256( */
1300         /*    abi.encodePacked( */
1301         /*        EIP191_HEADER, */
1302         /*        EIP712_DOMAIN_HASH, */
1303         /*        message */
1304         /*    ) */
1305         /*); */
1306 
1307         // Precalculated EIP712_ORDER_SCHEMA_HASH amd EIP712_DOMAIN_HASH because
1308         // the solidity compiler doesn't correctly precalculate them for us.
1309         bytes32 _EIP712_ORDER_SCHEMA_HASH = 0x40b942178d2a51f1f61934268590778feb8114db632db7d88537c98d2b05c5f2;
1310         bytes32 _EIP712_DOMAIN_HASH = 0xaea25658c273c666156bd427f83a666135fcde6887a6c25fc1cd1562bc4f3f34;
1311 
1312         bytes32 hash;
1313         assembly {
1314             // Calculate the hash for transferDataS separately
1315             let transferDataS := mload(add(order, 1184))              // order.transferDataS
1316             let transferDataSHash := keccak256(add(transferDataS, 32), mload(transferDataS))
1317 
1318             let ptr := mload(64)
1319             mstore(add(ptr,   0), _EIP712_ORDER_SCHEMA_HASH)     // EIP712_ORDER_SCHEMA_HASH
1320             mstore(add(ptr,  32), mload(add(order, 128)))        // order.amountS
1321             mstore(add(ptr,  64), mload(add(order, 160)))        // order.amountB
1322             mstore(add(ptr,  96), mload(add(order, 640)))        // order.feeAmount
1323             mstore(add(ptr, 128), mload(add(order, 192)))        // order.validSince
1324             mstore(add(ptr, 160), mload(add(order, 480)))        // order.validUntil
1325             mstore(add(ptr, 192), mload(add(order,  32)))        // order.owner
1326             mstore(add(ptr, 224), mload(add(order,  64)))        // order.tokenS
1327             mstore(add(ptr, 256), mload(add(order,  96)))        // order.tokenB
1328             mstore(add(ptr, 288), mload(add(order, 288)))        // order.dualAuthAddr
1329             mstore(add(ptr, 320), mload(add(order, 320)))        // order.broker
1330             mstore(add(ptr, 352), mload(add(order, 416)))        // order.orderInterceptor
1331             mstore(add(ptr, 384), mload(add(order, 448)))        // order.wallet
1332             mstore(add(ptr, 416), mload(add(order, 768)))        // order.tokenRecipient
1333             mstore(add(ptr, 448), mload(add(order, 608)))        // order.feeToken
1334             mstore(add(ptr, 480), mload(add(order, 800)))        // order.walletSplitPercentage
1335             mstore(add(ptr, 512), mload(add(order, 704)))        // order.tokenSFeePercentage
1336             mstore(add(ptr, 544), mload(add(order, 736)))        // order.tokenBFeePercentage
1337             mstore(add(ptr, 576), mload(add(order, 576)))        // order.allOrNone
1338             mstore(add(ptr, 608), mload(add(order, 1024)))       // order.tokenTypeS
1339             mstore(add(ptr, 640), mload(add(order, 1056)))       // order.tokenTypeB
1340             mstore(add(ptr, 672), mload(add(order, 1088)))       // order.tokenTypeFee
1341             mstore(add(ptr, 704), mload(add(order, 1120)))       // order.trancheS
1342             mstore(add(ptr, 736), mload(add(order, 1152)))       // order.trancheB
1343             mstore(add(ptr, 768), transferDataSHash)             // keccak256(order.transferDataS)
1344             let message := keccak256(ptr, 800)                   // 25 * 32
1345 
1346             mstore(add(ptr,  0), 0x1901)                         // EIP191_HEADER
1347             mstore(add(ptr, 32), _EIP712_DOMAIN_HASH)            // EIP712_DOMAIN_HASH
1348             mstore(add(ptr, 64), message)                        // message
1349             hash := keccak256(add(ptr, 30), 66)                  // 2 + 32 + 32
1350         }
1351         order.hash = hash;
1352     }
1353 
1354     function updateBrokerAndInterceptor(
1355         Data.Order memory order,
1356         Data.Context memory ctx
1357         )
1358         internal
1359         view
1360     {
1361         if (order.broker == address(0x0)) {
1362             order.broker = order.owner;
1363         } else {
1364             bool registered;
1365             (registered, /*order.brokerInterceptor*/) = ctx.orderBrokerRegistry.getBroker(
1366                 order.owner,
1367                 order.broker
1368             );
1369             order.valid = order.valid && registered;
1370         }
1371     }
1372 
1373     function check(
1374         Data.Order memory order,
1375         Data.Context memory ctx
1376         )
1377         internal
1378         view
1379     {
1380         // If the order was already partially filled
1381         // we don't have to check all of the infos and the signature again
1382         if(order.filledAmountS == 0) {
1383             validateAllInfo(order, ctx);
1384             checkBrokerSignature(order, ctx);
1385         } else {
1386             validateUnstableInfo(order, ctx);
1387         }
1388 
1389         checkP2P(order);
1390     }
1391 
1392     function validateAllInfo(
1393         Data.Order memory order,
1394         Data.Context memory ctx
1395         )
1396         internal
1397         view
1398     {
1399         bool valid = true;
1400         valid = valid && (order.version == 0); // unsupported order version
1401         valid = valid && (order.owner != address(0x0)); // invalid order owner
1402         valid = valid && (order.tokenS != address(0x0)); // invalid order tokenS
1403         valid = valid && (order.tokenB != address(0x0)); // invalid order tokenB
1404         valid = valid && (order.amountS != 0); // invalid order amountS
1405         valid = valid && (order.amountB != 0); // invalid order amountB
1406         valid = valid && (order.feeToken != address(0x0)); // invalid fee token
1407 
1408         valid = valid && (order.tokenSFeePercentage < ctx.feePercentageBase); // invalid tokenS percentage
1409         valid = valid && (order.tokenBFeePercentage < ctx.feePercentageBase); // invalid tokenB percentage
1410         valid = valid && (order.walletSplitPercentage <= 100); // invalid wallet split percentage
1411 
1412         // We only support ERC20 for now
1413         valid = valid && (order.tokenTypeS == Data.TokenType.ERC20 && order.trancheS == 0x0);
1414         valid = valid && (order.tokenTypeB == Data.TokenType.ERC20 && order.trancheB == 0x0);
1415         valid = valid && (order.tokenTypeFee == Data.TokenType.ERC20);
1416         valid = valid && (order.transferDataS.length == 0);
1417 
1418         valid = valid && (order.validSince <= now); // order is too early to match
1419 
1420         order.valid = order.valid && valid;
1421 
1422         validateUnstableInfo(order, ctx);
1423     }
1424 
1425 
1426     function validateUnstableInfo(
1427         Data.Order memory order,
1428         Data.Context memory ctx
1429         )
1430         internal
1431         view
1432     {
1433         bool valid = true;
1434         valid = valid && (order.validUntil == 0 || order.validUntil > now);  // order is expired
1435         valid = valid && (order.waiveFeePercentage <= int16(ctx.feePercentageBase)); // invalid waive percentage
1436         valid = valid && (order.waiveFeePercentage >= -int16(ctx.feePercentageBase)); // invalid waive percentage
1437         if (order.dualAuthAddr != address(0x0)) { // if dualAuthAddr exists, dualAuthSig must be exist.
1438             valid = valid && (order.dualAuthSig.length > 0);
1439         }
1440         order.valid = order.valid && valid;
1441     }
1442 
1443 
1444     function checkP2P(
1445         Data.Order memory order
1446         )
1447         internal
1448         pure
1449     {
1450         order.P2P = (order.tokenSFeePercentage > 0 || order.tokenBFeePercentage > 0);
1451     }
1452 
1453 
1454     function checkBrokerSignature(
1455         Data.Order memory order,
1456         Data.Context memory ctx
1457         )
1458         internal
1459         view
1460     {
1461         if (order.sig.length == 0) {
1462             bool registered = ctx.orderRegistry.isOrderHashRegistered(
1463                 order.broker,
1464                 order.hash
1465             );
1466 
1467             if (!registered) {
1468                 order.valid = order.valid && ctx.orderBook.orderSubmitted(order.hash);
1469             }
1470         } else {
1471             order.valid = order.valid && MultihashUtil.verifySignature(
1472                 order.broker,
1473                 order.hash,
1474                 order.sig
1475             );
1476         }
1477     }
1478 
1479     function checkDualAuthSignature(
1480         Data.Order memory order,
1481         bytes32 miningHash
1482         )
1483         internal
1484         pure
1485     {
1486         if (order.dualAuthSig.length != 0) {
1487             order.valid = order.valid && MultihashUtil.verifySignature(
1488                 order.dualAuthAddr,
1489                 miningHash,
1490                 order.dualAuthSig
1491             );
1492         }
1493     }
1494 
1495     function validateAllOrNone(
1496         Data.Order memory order
1497         )
1498         internal
1499         pure
1500     {
1501         // Check if this order needs to be completely filled
1502         if(order.allOrNone) {
1503             order.valid = order.valid && (order.filledAmountS == order.amountS);
1504         }
1505     }
1506 
1507     function getSpendableS(
1508         Data.Order memory order,
1509         Data.Context memory ctx
1510         )
1511         internal
1512         view
1513         returns (uint)
1514     {
1515         return getSpendable(
1516             ctx.delegate,
1517             order.tokenS,
1518             order.owner,
1519             order.tokenSpendableS
1520         );
1521     }
1522 
1523     function getSpendableFee(
1524         Data.Order memory order,
1525         Data.Context memory ctx
1526         )
1527         internal
1528         view
1529         returns (uint)
1530     {
1531         return getSpendable(
1532             ctx.delegate,
1533             order.feeToken,
1534             order.owner,
1535             order.tokenSpendableFee
1536         );
1537     }
1538 
1539     function reserveAmountS(
1540         Data.Order memory order,
1541         uint amount
1542         )
1543         internal
1544         pure
1545     {
1546         order.tokenSpendableS.reserved += amount;
1547     }
1548 
1549     function reserveAmountFee(
1550         Data.Order memory order,
1551         uint amount
1552         )
1553         internal
1554         pure
1555     {
1556         order.tokenSpendableFee.reserved += amount;
1557     }
1558 
1559     function resetReservations(
1560         Data.Order memory order
1561         )
1562         internal
1563         pure
1564     {
1565         order.tokenSpendableS.reserved = 0;
1566         order.tokenSpendableFee.reserved = 0;
1567     }
1568 
1569     /// @return Amount of ERC20 token that can be spent by this contract.
1570     function getERC20Spendable(
1571         ITradeDelegate delegate,
1572         address tokenAddress,
1573         address owner
1574         )
1575         private
1576         view
1577         returns (uint spendable)
1578     {
1579         ERC20 token = ERC20(tokenAddress);
1580         spendable = token.allowance(
1581             owner,
1582             address(delegate)
1583         );
1584         if (spendable != 0) {
1585             uint balance = token.balanceOf(owner);
1586             spendable = (balance < spendable) ? balance : spendable;
1587         }
1588     }
1589 
1590     function getSpendable(
1591         ITradeDelegate delegate,
1592         address tokenAddress,
1593         address owner,
1594         Data.Spendable memory tokenSpendable
1595         )
1596         private
1597         view
1598         returns (uint spendable)
1599     {
1600         if (!tokenSpendable.initialized) {
1601             tokenSpendable.amount = getERC20Spendable(
1602                 delegate,
1603                 tokenAddress,
1604                 owner
1605             );
1606             tokenSpendable.initialized = true;
1607         }
1608         spendable = tokenSpendable.amount.sub(tokenSpendable.reserved);
1609     }
1610 }
1611 
1612 /*
1613 
1614   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1615 
1616   Licensed under the Apache License, Version 2.0 (the "License");
1617   you may not use this file except in compliance with the License.
1618   You may obtain a copy of the License at
1619 
1620   http://www.apache.org/licenses/LICENSE-2.0
1621 
1622   Unless required by applicable law or agreed to in writing, software
1623   distributed under the License is distributed on an "AS IS" BASIS,
1624   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1625   See the License for the specific language governing permissions and
1626   limitations under the License.
1627 */
1628 
1629 
1630 
1631 
1632 
1633 
1634 
1635 
1636 /*
1637 
1638   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
1639 
1640   Licensed under the Apache License, Version 2.0 (the "License");
1641   you may not use this file except in compliance with the License.
1642   You may obtain a copy of the License at
1643 
1644   http://www.apache.org/licenses/LICENSE-2.0
1645 
1646   Unless required by applicable law or agreed to in writing, software
1647   distributed under the License is distributed on an "AS IS" BASIS,
1648   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1649   See the License for the specific language governing permissions and
1650   limitations under the License.
1651 */
1652 
1653 
1654 
1655 
1656 
1657 
1658 
1659 /// @title ParticipationHelper
1660 /// @author Daniel Wang - <daniel@loopring.org>.
1661 library ParticipationHelper {
1662     using MathUint for uint;
1663     using OrderHelper for Data.Order;
1664 
1665     function setMaxFillAmounts(
1666         Data.Participation memory p,
1667         Data.Context memory ctx
1668         )
1669         internal
1670         view
1671     {
1672         uint spendableS = p.order.getSpendableS(ctx);
1673         uint remainingS = p.order.amountS.sub(p.order.filledAmountS);
1674         p.fillAmountS = (spendableS < remainingS) ? spendableS : remainingS;
1675 
1676         if (!p.order.P2P) {
1677             // No need to check the fee balance of the owner if feeToken == tokenB,
1678             // fillAmountB will be used to pay the fee.
1679             if (!(p.order.feeToken == p.order.tokenB &&
1680                   p.order.owner == p.order.tokenRecipient &&
1681                   p.order.feeAmount <= p.order.amountB)) {
1682                 // Check how much fee needs to be paid. We limit fillAmountS to how much
1683                 // fee the order owner can pay.
1684                 uint feeAmount = p.order.feeAmount.mul(p.fillAmountS) / p.order.amountS;
1685                 if (feeAmount > 0) {
1686                     uint spendableFee = p.order.getSpendableFee(ctx);
1687                     if (p.order.feeToken == p.order.tokenS && p.fillAmountS + feeAmount > spendableS) {
1688                         assert(spendableFee == spendableS);
1689                         // Equally divide the available tokens between fillAmountS and feeAmount
1690                         uint totalAmount = p.order.amountS.add(p.order.feeAmount);
1691                         p.fillAmountS = spendableS.mul(p.order.amountS) / totalAmount;
1692                         feeAmount = spendableS.mul(p.order.feeAmount) / totalAmount;
1693                     } else if (feeAmount > spendableFee) {
1694                         // Scale down fillAmountS so the available feeAmount is sufficient
1695                         feeAmount = spendableFee;
1696                         p.fillAmountS = feeAmount.mul(p.order.amountS) / p.order.feeAmount;
1697                     }
1698                 }
1699             }
1700         }
1701 
1702         p.fillAmountB = p.fillAmountS.mul(p.order.amountB) / p.order.amountS;
1703     }
1704 
1705     function calculateFees(
1706         Data.Participation memory p,
1707         Data.Participation memory prevP,
1708         Data.Context memory ctx
1709         )
1710         internal
1711         view
1712         returns (bool)
1713     {
1714         if (p.order.P2P) {
1715             // Calculate P2P fees
1716             p.feeAmount = 0;
1717             p.feeAmountS = p.fillAmountS.mul(p.order.tokenSFeePercentage) / ctx.feePercentageBase;
1718             p.feeAmountB = p.fillAmountB.mul(p.order.tokenBFeePercentage) / ctx.feePercentageBase;
1719         } else {
1720             // Calculate matching fees
1721             p.feeAmount = p.order.feeAmount.mul(p.fillAmountS) / p.order.amountS;
1722             p.feeAmountS = 0;
1723             p.feeAmountB = 0;
1724 
1725             // If feeToken == tokenB AND owner == tokenRecipient, try to pay using fillAmountB
1726 
1727             if (p.order.feeToken == p.order.tokenB &&
1728                 p.order.owner == p.order.tokenRecipient &&
1729                 p.fillAmountB >= p.feeAmount) {
1730                 p.feeAmountB = p.feeAmount;
1731                 p.feeAmount = 0;
1732             }
1733 
1734             if (p.feeAmount > 0) {
1735                 // Make sure we can pay the feeAmount
1736                 uint spendableFee = p.order.getSpendableFee(ctx);
1737                 if (p.feeAmount > spendableFee) {
1738                     // This normally should not happen, but this is possible when self-trading
1739                     return false;
1740                 } else {
1741                     p.order.reserveAmountFee(p.feeAmount);
1742                 }
1743             }
1744         }
1745 
1746         if ((p.fillAmountS - p.feeAmountS) >= prevP.fillAmountB) {
1747             // The miner (or in a P2P case, the taker) gets the margin
1748             p.splitS = (p.fillAmountS - p.feeAmountS) - prevP.fillAmountB;
1749             p.fillAmountS = prevP.fillAmountB + p.feeAmountS;
1750             return true;
1751         } else {
1752             return false;
1753         }
1754     }
1755 
1756     function checkFills(
1757         Data.Participation memory p
1758         )
1759         internal
1760         pure
1761         returns (bool valid)
1762     {
1763         // Check if the rounding error of the calculated fillAmountB is larger than 1%.
1764         // If that's the case, this partipation in invalid
1765         // p.fillAmountB := p.fillAmountS.mul(p.order.amountB) / p.order.amountS
1766         valid = !MathUint.hasRoundingError(
1767             p.fillAmountS,
1768             p.order.amountB,
1769             p.order.amountS
1770         );
1771 
1772         // We at least need to buy and sell something
1773         valid = valid && p.fillAmountS > 0;
1774         valid = valid && p.fillAmountB > 0;
1775     }
1776 
1777     function adjustOrderState(
1778         Data.Participation memory p
1779         )
1780         internal
1781         pure
1782     {
1783         // Update filled amount
1784         p.order.filledAmountS += p.fillAmountS + p.splitS;
1785 
1786         // Update spendables
1787         uint totalAmountS = p.fillAmountS + p.splitS;
1788         uint totalAmountFee = p.feeAmount;
1789         p.order.tokenSpendableS.amount = p.order.tokenSpendableS.amount.sub(totalAmountS);
1790         p.order.tokenSpendableFee.amount = p.order.tokenSpendableFee.amount.sub(totalAmountFee);
1791         if (p.order.brokerInterceptor != address(0x0)) {
1792             p.order.brokerSpendableS.amount = p.order.brokerSpendableS.amount.sub(totalAmountS);
1793             p.order.brokerSpendableFee.amount = p.order.brokerSpendableFee.amount.sub(totalAmountFee);
1794         }
1795     }
1796 
1797     function revertOrderState(
1798         Data.Participation memory p
1799         )
1800         internal
1801         pure
1802     {
1803         // Revert filled amount
1804         p.order.filledAmountS = p.order.filledAmountS.sub(p.fillAmountS + p.splitS);
1805 
1806         // We do not revert any spendables. Rings will not get rebalanced so this doesn't matter.
1807     }
1808 
1809 }
1810 
1811 
1812 
1813 /// @title RingHelper
1814 library RingHelper {
1815     using MathUint for uint;
1816     using OrderHelper for Data.Order;
1817     using ParticipationHelper for Data.Participation;
1818 
1819     function updateHash(
1820         Data.Ring memory ring
1821         )
1822         internal
1823         pure
1824     {
1825         uint ringSize = ring.size;
1826         bytes32 hash;
1827         assembly {
1828             let data := mload(0x40)
1829             let ptr := data
1830             let participations := mload(add(ring, 32))                                  // ring.participations
1831             for { let i := 0 } lt(i, ringSize) { i := add(i, 1) } {
1832                 let participation := mload(add(participations, add(32, mul(i, 32))))    // participations[i]
1833                 let order := mload(participation)                                       // participation.order
1834 
1835                 let waiveFeePercentage := and(mload(add(order, 672)), 0xFFFF)           // order.waiveFeePercentage
1836                 let orderHash := mload(add(order, 864))                                 // order.hash
1837 
1838                 mstore(add(ptr, 2), waiveFeePercentage)
1839                 mstore(ptr, orderHash)
1840 
1841                 ptr := add(ptr, 34)
1842             }
1843             hash := keccak256(data, sub(ptr, data))
1844         }
1845         ring.hash = hash;
1846     }
1847 
1848     function calculateFillAmountAndFee(
1849         Data.Ring memory ring,
1850         Data.Context memory ctx
1851         )
1852         internal
1853     {
1854         // Invalid order data could cause a divide by zero in the calculations
1855         if (!ring.valid) {
1856             return;
1857         }
1858 
1859         uint i;
1860         int j;
1861         uint prevIndex;
1862 
1863         for (i = 0; i < ring.size; i++) {
1864             ring.participations[i].setMaxFillAmounts(
1865                 ctx
1866             );
1867         }
1868 
1869         uint smallest = 0;
1870         for (j = int(ring.size) - 1; j >= 0; j--) {
1871             prevIndex = (uint(j) + ring.size - 1) % ring.size;
1872             smallest = calculateOrderFillAmounts(
1873                 ctx,
1874                 ring.participations[uint(j)],
1875                 ring.participations[prevIndex],
1876                 uint(j),
1877                 smallest
1878             );
1879         }
1880         for (j = int(ring.size) - 1; j >= int(smallest); j--) {
1881             prevIndex = (uint(j) + ring.size - 1) % ring.size;
1882             calculateOrderFillAmounts(
1883                 ctx,
1884                 ring.participations[uint(j)],
1885                 ring.participations[prevIndex],
1886                 uint(j),
1887                 smallest
1888             );
1889         }
1890 
1891         for (i = 0; i < ring.size; i++) {
1892             // Check if the fill amounts of the participation are valid
1893             ring.valid = ring.valid && ring.participations[i].checkFills();
1894 
1895             // Reserve the total amount tokenS used for all the orders
1896             // (e.g. the owner of order 0 could use LRC as feeToken in order 0, while
1897             // the same owner can also sell LRC in order 2).
1898             ring.participations[i].order.reserveAmountS(ring.participations[i].fillAmountS);
1899         }
1900 
1901         for (i = 0; i < ring.size; i++) {
1902             prevIndex = (i + ring.size - 1) % ring.size;
1903 
1904             // Check if we can transfer the tokens (if ST-20)
1905             ring.valid = ring.valid && verifyTransferProxy(
1906                 ring.participations[i].order.tokenS,
1907                 ring.participations[i].order.owner,
1908                 ring.participations[prevIndex].order.tokenRecipient,
1909                 ring.participations[i].fillAmountS
1910             );
1911 
1912             bool valid = ring.participations[i].calculateFees(ring.participations[prevIndex], ctx);
1913             if (!valid) {
1914                 ring.valid = false;
1915                 break;
1916             }
1917 
1918             int16 waiveFeePercentage = ring.participations[i].order.waiveFeePercentage;
1919             if (waiveFeePercentage < 0) {
1920                 ring.minerFeesToOrdersPercentage += uint(-waiveFeePercentage);
1921             }
1922         }
1923         // Miner can only distribute 100% of its fees to all orders combined
1924         ring.valid = ring.valid && (ring.minerFeesToOrdersPercentage <= ctx.feePercentageBase);
1925 
1926         // Ring calculations are done. Make sure te remove all spendable reservations for this ring
1927         for (i = 0; i < ring.size; i++) {
1928             ring.participations[i].order.resetReservations();
1929         }
1930     }
1931 
1932     // ST-20: transfer, transferFrom must respect the result of verifyTransfer
1933     function verifyTransferProxy(
1934         address token,
1935         address from,
1936         address to,
1937         uint256 amount
1938         )
1939         internal
1940         returns (bool)
1941     {
1942         bytes memory callData = abi.encodeWithSelector(
1943             ERC20(token).verifyTransfer.selector,
1944             from,
1945             to,
1946             amount,
1947             new bytes(0)
1948         );
1949         (bool success, bytes memory returnData) = token.call(callData);
1950         // We expect a single boolean as the return value
1951         if (success && returnData.length == 32) {
1952             // Check if a boolean was returned
1953             assembly {
1954                 success := mload(add(returnData, 32))
1955             }
1956             return success;
1957         } else {
1958             // No function found, normal ERC20 token
1959             return true;
1960         }
1961     }
1962 
1963     function calculateOrderFillAmounts(
1964         Data.Context memory ctx,
1965         Data.Participation memory p,
1966         Data.Participation memory prevP,
1967         uint i,
1968         uint smallest
1969         )
1970         internal
1971         pure
1972         returns (uint smallest_)
1973     {
1974         // Default to the same smallest index
1975         smallest_ = smallest;
1976 
1977         uint postFeeFillAmountS = p.fillAmountS;
1978         uint tokenSFeePercentage = p.order.tokenSFeePercentage;
1979         if (tokenSFeePercentage > 0) {
1980             uint feeAmountS = p.fillAmountS.mul(tokenSFeePercentage) / ctx.feePercentageBase;
1981             postFeeFillAmountS = p.fillAmountS - feeAmountS;
1982         }
1983 
1984         if (prevP.fillAmountB > postFeeFillAmountS) {
1985             smallest_ = i;
1986             prevP.fillAmountB = postFeeFillAmountS;
1987             prevP.fillAmountS = postFeeFillAmountS.mul(prevP.order.amountS) / prevP.order.amountB;
1988         }
1989     }
1990 
1991     function checkOrdersValid(
1992         Data.Ring memory ring
1993         )
1994         internal
1995         pure
1996     {
1997         ring.valid = ring.valid && (ring.size > 1 && ring.size <= 8); // invalid ring size
1998         for (uint i = 0; i < ring.size; i++) {
1999             uint prev = (i + ring.size - 1) % ring.size;
2000             ring.valid = ring.valid && ring.participations[i].order.valid;
2001             ring.valid = ring.valid && ring.participations[i].order.tokenS == ring.participations[prev].order.tokenB;
2002         }
2003     }
2004 
2005     function checkForSubRings(
2006         Data.Ring memory ring
2007         )
2008         internal
2009         pure
2010     {
2011         for (uint i = 0; i < ring.size - 1; i++) {
2012             address tokenS = ring.participations[i].order.tokenS;
2013             for (uint j = i + 1; j < ring.size; j++) {
2014                 ring.valid = ring.valid && (tokenS != ring.participations[j].order.tokenS);
2015             }
2016         }
2017     }
2018 
2019     function adjustOrderStates(
2020         Data.Ring memory ring
2021         )
2022         internal
2023         pure
2024     {
2025         // Adjust the orders
2026         for (uint i = 0; i < ring.size; i++) {
2027             ring.participations[i].adjustOrderState();
2028         }
2029     }
2030 
2031 
2032     function revertOrderStats(
2033         Data.Ring memory ring
2034         )
2035         internal
2036         pure
2037     {
2038         for (uint i = 0; i < ring.size; i++) {
2039             ring.participations[i].revertOrderState();
2040         }
2041     }
2042 
2043     function doPayments(
2044         Data.Ring memory ring,
2045         Data.Context memory ctx,
2046         Data.Mining memory mining
2047         )
2048         internal
2049         view
2050     {
2051         payFees(ring, ctx, mining);
2052         transferTokens(ring, ctx, mining.feeRecipient);
2053     }
2054 
2055     function generateFills(
2056         Data.Ring memory ring,
2057         uint destPtr
2058         )
2059         internal
2060         pure
2061         returns (uint fill)
2062     {
2063         uint ringSize = ring.size;
2064         uint fillSize = 8 * 32;
2065         assembly {
2066             fill := destPtr
2067             let participations := mload(add(ring, 32))                                 // ring.participations
2068 
2069             for { let i := 0 } lt(i, ringSize) { i := add(i, 1) } {
2070                 let participation := mload(add(participations, add(32, mul(i, 32))))   // participations[i]
2071                 let order := mload(participation)                                      // participation.order
2072 
2073                 // Calculate the actual fees paid after rebate
2074                 let feeAmount := sub(
2075                     mload(add(participation, 64)),                                      // participation.feeAmount
2076                     mload(add(participation, 160))                                      // participation.rebateFee
2077                 )
2078                 let feeAmountS := sub(
2079                     mload(add(participation, 96)),                                      // participation.feeAmountS
2080                     mload(add(participation, 192))                                      // participation.rebateFeeS
2081                 )
2082                 let feeAmountB := sub(
2083                     mload(add(participation, 128)),                                     // participation.feeAmountB
2084                     mload(add(participation, 224))                                      // participation.rebateFeeB
2085                 )
2086 
2087                 mstore(add(fill,   0), mload(add(order, 864)))                         // order.hash
2088                 mstore(add(fill,  32), mload(add(order,  32)))                         // order.owner
2089                 mstore(add(fill,  64), mload(add(order,  64)))                         // order.tokenS
2090                 mstore(add(fill,  96), mload(add(participation, 256)))                 // participation.fillAmountS
2091                 mstore(add(fill, 128), mload(add(participation,  32)))                 // participation.splitS
2092                 mstore(add(fill, 160), feeAmount)                                      // feeAmount
2093                 mstore(add(fill, 192), feeAmountS)                                     // feeAmountS
2094                 mstore(add(fill, 224), feeAmountB)                                     // feeAmountB
2095 
2096                 fill := add(fill, fillSize)
2097             }
2098         }
2099     }
2100 
2101     function transferTokens(
2102         Data.Ring memory ring,
2103         Data.Context memory ctx,
2104         address feeRecipient
2105         )
2106         internal
2107         pure
2108     {
2109         for (uint i = 0; i < ring.size; i++) {
2110             transferTokensForParticipation(
2111                 ctx,
2112                 feeRecipient,
2113                 ring.participations[i],
2114                 ring.participations[(i + ring.size - 1) % ring.size]
2115             );
2116         }
2117     }
2118 
2119     function transferTokensForParticipation(
2120         Data.Context memory ctx,
2121         address feeRecipient,
2122         Data.Participation memory p,
2123         Data.Participation memory prevP
2124         )
2125         internal
2126         pure
2127         returns (uint)
2128     {
2129         uint buyerFeeAmountAfterRebateB = prevP.feeAmountB.sub(prevP.rebateB);
2130 
2131         // If the buyer needs to pay fees in tokenB, the seller needs
2132         // to send the tokenS amount to the fee holder contract
2133         uint amountSToBuyer = p.fillAmountS
2134             .sub(p.feeAmountS)
2135             .sub(buyerFeeAmountAfterRebateB);
2136 
2137         uint amountSToFeeHolder = p.feeAmountS
2138             .sub(p.rebateS)
2139             .add(buyerFeeAmountAfterRebateB);
2140 
2141         uint amountFeeToFeeHolder = p.feeAmount
2142             .sub(p.rebateFee);
2143 
2144         if (p.order.tokenS == p.order.feeToken) {
2145             amountSToFeeHolder = amountSToFeeHolder.add(amountFeeToFeeHolder);
2146             amountFeeToFeeHolder = 0;
2147         }
2148 
2149         // Transfers
2150         ctx.transferPtr = addTokenTransfer(
2151             ctx.transferData,
2152             ctx.transferPtr,
2153             p.order.feeToken,
2154             p.order.owner,
2155             address(ctx.feeHolder),
2156             amountFeeToFeeHolder
2157         );
2158         ctx.transferPtr = addTokenTransfer(
2159             ctx.transferData,
2160             ctx.transferPtr,
2161             p.order.tokenS,
2162             p.order.owner,
2163             address(ctx.feeHolder),
2164             amountSToFeeHolder
2165         );
2166         ctx.transferPtr = addTokenTransfer(
2167             ctx.transferData,
2168             ctx.transferPtr,
2169             p.order.tokenS,
2170             p.order.owner,
2171             prevP.order.tokenRecipient,
2172             amountSToBuyer
2173         );
2174 
2175         // Miner (or for P2P the taker) gets the margin without sharing it with the wallet or burning
2176         ctx.transferPtr = addTokenTransfer(
2177             ctx.transferData,
2178             ctx.transferPtr,
2179             p.order.tokenS,
2180             p.order.owner,
2181             feeRecipient,
2182             p.splitS
2183         );
2184     }
2185 
2186     function addTokenTransfer(
2187         uint data,
2188         uint ptr,
2189         address token,
2190         address from,
2191         address to,
2192         uint amount
2193         )
2194         internal
2195         pure
2196         returns (uint)
2197     {
2198         if (amount > 0 && from != to) {
2199             assembly {
2200                 // Try to find an existing fee payment of the same token to the same owner
2201                 let addNew := 1
2202                 for { let p := data } lt(p, ptr) { p := add(p, 128) } {
2203                     let dataToken := mload(add(p,  0))
2204                     let dataFrom := mload(add(p, 32))
2205                     let dataTo := mload(add(p, 64))
2206                     // if(token == dataToken && from == dataFrom && to == dataTo)
2207                     if and(and(eq(token, dataToken), eq(from, dataFrom)), eq(to, dataTo)) {
2208                         let dataAmount := mload(add(p, 96))
2209                         // dataAmount = amount.add(dataAmount);
2210                         dataAmount := add(amount, dataAmount)
2211                         // require(dataAmount >= amount) (safe math)
2212                         if lt(dataAmount, amount) {
2213                             revert(0, 0)
2214                         }
2215                         mstore(add(p, 96), dataAmount)
2216                         addNew := 0
2217                         // End the loop
2218                         p := ptr
2219                     }
2220                 }
2221                 // Add a new transfer
2222                 if eq(addNew, 1) {
2223                     mstore(add(ptr,  0), token)
2224                     mstore(add(ptr, 32), from)
2225                     mstore(add(ptr, 64), to)
2226                     mstore(add(ptr, 96), amount)
2227                     ptr := add(ptr, 128)
2228                 }
2229             }
2230             return ptr;
2231         } else {
2232             return ptr;
2233         }
2234     }
2235 
2236     function payFees(
2237         Data.Ring memory ring,
2238         Data.Context memory ctx,
2239         Data.Mining memory mining
2240         )
2241         internal
2242         view
2243     {
2244         Data.FeeContext memory feeCtx;
2245         feeCtx.ring = ring;
2246         feeCtx.ctx = ctx;
2247         feeCtx.feeRecipient = mining.feeRecipient;
2248         for (uint i = 0; i < ring.size; i++) {
2249             payFeesForParticipation(
2250                 feeCtx,
2251                 ring.participations[i]
2252             );
2253         }
2254     }
2255 
2256     function payFeesForParticipation(
2257         Data.FeeContext memory feeCtx,
2258         Data.Participation memory p
2259         )
2260         internal
2261         view
2262         returns (uint)
2263     {
2264         feeCtx.walletPercentage = p.order.P2P ? 100 : (
2265             (p.order.wallet == address(0x0) ? 0 : p.order.walletSplitPercentage)
2266         );
2267         feeCtx.waiveFeePercentage = p.order.waiveFeePercentage;
2268         feeCtx.owner = p.order.owner;
2269         feeCtx.wallet = p.order.wallet;
2270         feeCtx.P2P = p.order.P2P;
2271 
2272         p.rebateFee = payFeesAndBurn(
2273             feeCtx,
2274             p.order.feeToken,
2275             p.feeAmount
2276         );
2277         p.rebateS = payFeesAndBurn(
2278             feeCtx,
2279             p.order.tokenS,
2280             p.feeAmountS
2281         );
2282         p.rebateB = payFeesAndBurn(
2283             feeCtx,
2284             p.order.tokenB,
2285             p.feeAmountB
2286         );
2287     }
2288 
2289     function payFeesAndBurn(
2290         Data.FeeContext memory feeCtx,
2291         address token,
2292         uint totalAmount
2293         )
2294         internal
2295         view
2296         returns (uint)
2297     {
2298         if (totalAmount == 0) {
2299             return 0;
2300         }
2301 
2302         uint amount = totalAmount;
2303         // No need to pay any fees in a P2P order without a wallet
2304         // (but the fee amount is a part of amountS of the order, so the fee amount is rebated).
2305         if (feeCtx.P2P && feeCtx.wallet == address(0x0)) {
2306             amount = 0;
2307         }
2308 
2309         uint feeToWallet = 0;
2310         uint minerFee = 0;
2311         uint minerFeeBurn = 0;
2312         uint walletFeeBurn = 0;
2313         if (amount > 0) {
2314             feeToWallet = amount.mul(feeCtx.walletPercentage) / 100;
2315             minerFee = amount - feeToWallet;
2316 
2317             // Miner can waive fees for this order. If waiveFeePercentage > 0 this is a simple reduction in fees.
2318             if (feeCtx.waiveFeePercentage > 0) {
2319                 minerFee = minerFee.mul(
2320                     feeCtx.ctx.feePercentageBase - uint(feeCtx.waiveFeePercentage)) /
2321                     feeCtx.ctx.feePercentageBase;
2322             } else if (feeCtx.waiveFeePercentage < 0) {
2323                 // No fees need to be paid by this order
2324                 minerFee = 0;
2325             }
2326 
2327             uint32 burnRate = getBurnRate(feeCtx, token);
2328             assert(burnRate <= feeCtx.ctx.feePercentageBase);
2329 
2330             // Miner fee
2331             minerFeeBurn = minerFee.mul(burnRate) / feeCtx.ctx.feePercentageBase;
2332             minerFee = minerFee - minerFeeBurn;
2333             // Wallet fee
2334             walletFeeBurn = feeToWallet.mul(burnRate) / feeCtx.ctx.feePercentageBase;
2335             feeToWallet = feeToWallet - walletFeeBurn;
2336 
2337             // Pay the wallet
2338             feeCtx.ctx.feePtr = addFeePayment(
2339                 feeCtx.ctx.feeData,
2340                 feeCtx.ctx.feePtr,
2341                 token,
2342                 feeCtx.wallet,
2343                 feeToWallet
2344             );
2345 
2346             // Pay the burn rate with the feeHolder as owner
2347             feeCtx.ctx.feePtr = addFeePayment(
2348                 feeCtx.ctx.feeData,
2349                 feeCtx.ctx.feePtr,
2350                 token,
2351                 address(feeCtx.ctx.feeHolder),
2352                 minerFeeBurn + walletFeeBurn
2353             );
2354 
2355             // Fees can be paid out in different tokens so we can't easily accumulate the total fee
2356             // that needs to be paid out to order owners. So we pay out each part out here to all
2357             // orders that need it.
2358             uint feeToMiner = minerFee;
2359             if (feeCtx.ring.minerFeesToOrdersPercentage > 0 && minerFee > 0) {
2360                 // Pay out the fees to the orders
2361                 distributeMinerFeeToOwners(
2362                     feeCtx,
2363                     token,
2364                     minerFee
2365                 );
2366                 // Subtract all fees the miner pays to the orders
2367                 feeToMiner = minerFee.mul(feeCtx.ctx.feePercentageBase -
2368                     feeCtx.ring.minerFeesToOrdersPercentage) /
2369                     feeCtx.ctx.feePercentageBase;
2370             }
2371 
2372             // Pay the miner
2373             feeCtx.ctx.feePtr = addFeePayment(
2374                 feeCtx.ctx.feeData,
2375                 feeCtx.ctx.feePtr,
2376                 token,
2377                 feeCtx.feeRecipient,
2378                 feeToMiner
2379             );
2380         }
2381 
2382         // Calculate the total fee payment after possible discounts (burn rebate + fee waiving)
2383         // and return the total rebate
2384         return totalAmount.sub((feeToWallet + minerFee) + (minerFeeBurn + walletFeeBurn));
2385     }
2386 
2387     function getBurnRate(
2388         Data.FeeContext memory feeCtx,
2389         address token
2390         )
2391         internal
2392         view
2393         returns (uint32)
2394     {
2395         bytes32[] memory tokenBurnRates = feeCtx.ctx.tokenBurnRates;
2396         uint length = tokenBurnRates.length;
2397         for (uint i = 0; i < length; i += 2) {
2398             if (token == address(bytes20(tokenBurnRates[i]))) {
2399                 uint32 burnRate = uint32(bytes4(tokenBurnRates[i + 1]));
2400                 return feeCtx.P2P ? (burnRate / 0x10000) : (burnRate & 0xFFFF);
2401             }
2402         }
2403         // Not found, add it to the list
2404         uint32 burnRate = feeCtx.ctx.burnRateTable.getBurnRate(token);
2405         assembly {
2406             let ptr := add(tokenBurnRates, mul(add(1, length), 32))
2407             mstore(ptr, token)                              // token
2408             mstore(add(ptr, 32), burnRate)                  // burn rate
2409             mstore(tokenBurnRates, add(length, 2))          // length
2410         }
2411         return feeCtx.P2P ? (burnRate / 0x10000) : (burnRate & 0xFFFF);
2412     }
2413 
2414     function distributeMinerFeeToOwners(
2415         Data.FeeContext memory feeCtx,
2416         address token,
2417         uint minerFee
2418         )
2419         internal
2420         pure
2421     {
2422         for (uint i = 0; i < feeCtx.ring.size; i++) {
2423             if (feeCtx.ring.participations[i].order.waiveFeePercentage < 0) {
2424                 uint feeToOwner = minerFee
2425                     .mul(uint(-feeCtx.ring.participations[i].order.waiveFeePercentage)) / feeCtx.ctx.feePercentageBase;
2426 
2427                 feeCtx.ctx.feePtr = addFeePayment(
2428                     feeCtx.ctx.feeData,
2429                     feeCtx.ctx.feePtr,
2430                     token,
2431                     feeCtx.ring.participations[i].order.owner,
2432                     feeToOwner);
2433             }
2434         }
2435     }
2436 
2437     function addFeePayment(
2438         uint data,
2439         uint ptr,
2440         address token,
2441         address owner,
2442         uint amount
2443         )
2444         internal
2445         pure
2446         returns (uint)
2447     {
2448         if (amount == 0) {
2449             return ptr;
2450         } else {
2451             assembly {
2452                 // Try to find an existing fee payment of the same token to the same owner
2453                 let addNew := 1
2454                 for { let p := data } lt(p, ptr) { p := add(p, 96) } {
2455                     let dataToken := mload(add(p,  0))
2456                     let dataOwner := mload(add(p, 32))
2457                     // if(token == dataToken && owner == dataOwner)
2458                     if and(eq(token, dataToken), eq(owner, dataOwner)) {
2459                         let dataAmount := mload(add(p, 64))
2460                         // dataAmount = amount.add(dataAmount);
2461                         dataAmount := add(amount, dataAmount)
2462                         // require(dataAmount >= amount) (safe math)
2463                         if lt(dataAmount, amount) {
2464                             revert(0, 0)
2465                         }
2466                         mstore(add(p, 64), dataAmount)
2467                         addNew := 0
2468                         // End the loop
2469                         p := ptr
2470                     }
2471                 }
2472                 // Add a new fee payment
2473                 if eq(addNew, 1) {
2474                     mstore(add(ptr,  0), token)
2475                     mstore(add(ptr, 32), owner)
2476                     mstore(add(ptr, 64), amount)
2477                     ptr := add(ptr, 96)
2478                 }
2479             }
2480             return ptr;
2481         }
2482     }
2483 
2484 }
2485 
2486 
2487 
2488 
2489 
2490 
2491 
2492 
2493 
2494 
2495 
2496 
2497 
2498 /*
2499 
2500   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
2501 
2502   Licensed under the Apache License, Version 2.0 (the "License");
2503   you may not use this file except in compliance with the License.
2504   You may obtain a copy of the License at
2505 
2506   http://www.apache.org/licenses/LICENSE-2.0
2507 
2508   Unless required by applicable law or agreed to in writing, software
2509   distributed under the License is distributed on an "AS IS" BASIS,
2510   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2511   See the License for the specific language governing permissions and
2512   limitations under the License.
2513 */
2514 
2515 
2516 /*
2517 
2518   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
2519 
2520   Licensed under the Apache License, Version 2.0 (the "License");
2521   you may not use this file except in compliance with the License.
2522   You may obtain a copy of the License at
2523 
2524   http://www.apache.org/licenses/LICENSE-2.0
2525 
2526   Unless required by applicable law or agreed to in writing, software
2527   distributed under the License is distributed on an "AS IS" BASIS,
2528   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2529   See the License for the specific language governing permissions and
2530   limitations under the License.
2531 */
2532 
2533 
2534 
2535 /// @title Errors
2536 contract Errors {
2537     string constant ZERO_VALUE                 = "ZERO_VALUE";
2538     string constant ZERO_ADDRESS               = "ZERO_ADDRESS";
2539     string constant INVALID_VALUE              = "INVALID_VALUE";
2540     string constant INVALID_ADDRESS            = "INVALID_ADDRESS";
2541     string constant INVALID_SIZE               = "INVALID_SIZE";
2542     string constant INVALID_SIG                = "INVALID_SIG";
2543     string constant INVALID_STATE              = "INVALID_STATE";
2544     string constant NOT_FOUND                  = "NOT_FOUND";
2545     string constant ALREADY_EXIST              = "ALREADY_EXIST";
2546     string constant REENTRY                    = "REENTRY";
2547     string constant UNAUTHORIZED               = "UNAUTHORIZED";
2548     string constant UNIMPLEMENTED              = "UNIMPLEMENTED";
2549     string constant UNSUPPORTED                = "UNSUPPORTED";
2550     string constant TRANSFER_FAILURE           = "TRANSFER_FAILURE";
2551     string constant WITHDRAWAL_FAILURE         = "WITHDRAWAL_FAILURE";
2552     string constant BURN_FAILURE               = "BURN_FAILURE";
2553     string constant BURN_RATE_FROZEN           = "BURN_RATE_FROZEN";
2554     string constant BURN_RATE_MINIMIZED        = "BURN_RATE_MINIMIZED";
2555     string constant UNAUTHORIZED_ONCHAIN_ORDER = "UNAUTHORIZED_ONCHAIN_ORDER";
2556     string constant INVALID_CANDIDATE          = "INVALID_CANDIDATE";
2557     string constant ALREADY_VOTED              = "ALREADY_VOTED";
2558     string constant NOT_OWNER                  = "NOT_OWNER";
2559 }
2560 
2561 
2562 
2563 /// @title NoDefaultFunc
2564 /// @dev Disable default functions.
2565 contract NoDefaultFunc is Errors {
2566     function ()
2567         external
2568         payable
2569     {
2570         revert(UNSUPPORTED);
2571     }
2572 }
2573 
2574 
2575 
2576 /*
2577 
2578   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
2579 
2580   Licensed under the Apache License, Version 2.0 (the "License");
2581   you may not use this file except in compliance with the License.
2582   You may obtain a copy of the License at
2583 
2584   http://www.apache.org/licenses/LICENSE-2.0
2585 
2586   Unless required by applicable law or agreed to in writing, software
2587   distributed under the License is distributed on an "AS IS" BASIS,
2588   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2589   See the License for the specific language governing permissions and
2590   limitations under the License.
2591 */
2592 
2593 
2594 
2595 
2596 
2597 
2598 /// @title Deserializes the data passed to submitRings
2599 /// @author Daniel Wang - <daniel@loopring.org>,
2600 library ExchangeDeserializer {
2601     using BytesUtil     for bytes;
2602 
2603     function deserialize(
2604         address lrcTokenAddress,
2605         bytes memory data
2606         )
2607         internal
2608         view
2609         returns (
2610             Data.Mining memory mining,
2611             Data.Order[] memory orders,
2612             Data.Ring[] memory rings
2613         )
2614     {
2615         // Read the header
2616         Data.Header memory header;
2617         header.version = data.bytesToUint16(0);
2618         header.numOrders = data.bytesToUint16(2);
2619         header.numRings = data.bytesToUint16(4);
2620         header.numSpendables = data.bytesToUint16(6);
2621 
2622         // Validation
2623         require(header.version == 0, "Unsupported serialization format");
2624         require(header.numOrders > 0, "Invalid number of orders");
2625         require(header.numRings > 0, "Invalid number of rings");
2626         require(header.numSpendables > 0, "Invalid number of spendables");
2627 
2628         // Calculate data pointers
2629         uint dataPtr;
2630         assembly {
2631             dataPtr := data
2632         }
2633         uint miningDataPtr = dataPtr + 8;
2634         uint orderDataPtr = miningDataPtr + 3 * 2;
2635         uint ringDataPtr = orderDataPtr + (30 * header.numOrders) * 2;
2636         uint dataBlobPtr = ringDataPtr + (header.numRings * 9) + 32;
2637 
2638         // The data stream needs to be at least large enough for the
2639         // header/mining/orders/rings data + 64 bytes of zeros in the data blob.
2640         require(data.length >= (dataBlobPtr - dataPtr) + 32, "Invalid input data");
2641 
2642         // Setup the rings
2643         mining = setupMiningData(dataBlobPtr, miningDataPtr + 2);
2644         orders = setupOrders(dataBlobPtr, orderDataPtr + 2, header.numOrders, header.numSpendables, lrcTokenAddress);
2645         rings = assembleRings(ringDataPtr + 1, header.numRings, orders);
2646     }
2647 
2648     function setupMiningData(
2649         uint data,
2650         uint tablesPtr
2651         )
2652         internal
2653         view
2654         returns (Data.Mining memory mining)
2655     {
2656         bytes memory emptyBytes = new bytes(0);
2657         uint offset;
2658 
2659         assembly {
2660             // Default to transaction origin for feeRecipient
2661             mstore(add(data, 20), origin)
2662 
2663             // mining.feeRecipient
2664             offset := mul(and(mload(add(tablesPtr,  0)), 0xFFFF), 4)
2665             mstore(
2666                 add(mining,   0),
2667                 mload(add(add(data, 20), offset))
2668             )
2669 
2670             // Restore default to 0
2671             mstore(add(data, 20), 0)
2672 
2673             // mining.miner
2674             offset := mul(and(mload(add(tablesPtr,  2)), 0xFFFF), 4)
2675             mstore(
2676                 add(mining,  32),
2677                 mload(add(add(data, 20), offset))
2678             )
2679 
2680             // Default to empty bytes array
2681             mstore(add(data, 32), emptyBytes)
2682 
2683             // mining.sig
2684             offset := mul(and(mload(add(tablesPtr,  4)), 0xFFFF), 4)
2685             mstore(
2686                 add(mining, 64),
2687                 add(data, add(offset, 32))
2688             )
2689 
2690             // Restore default to 0
2691             mstore(add(data, 32), 0)
2692         }
2693     }
2694 
2695     function setupOrders(
2696         uint data,
2697         uint tablesPtr,
2698         uint numOrders,
2699         uint numSpendables,
2700         address lrcTokenAddress
2701         )
2702         internal
2703         pure
2704         returns (Data.Order[] memory orders)
2705     {
2706         bytes memory emptyBytes = new bytes(0);
2707         uint orderStructSize = 38 * 32;
2708         // Memory for orders length + numOrders order pointers
2709         uint arrayDataSize = (1 + numOrders) * 32;
2710         Data.Spendable[] memory spendableList = new Data.Spendable[](numSpendables);
2711         uint offset;
2712 
2713         assembly {
2714             // Allocate memory for all orders
2715             orders := mload(0x40)
2716             mstore(add(orders, 0), numOrders)                       // orders.length
2717             // Reserve the memory for the orders array
2718             mstore(0x40, add(orders, add(arrayDataSize, mul(orderStructSize, numOrders))))
2719 
2720             for { let i := 0 } lt(i, numOrders) { i := add(i, 1) } {
2721                 let order := add(orders, add(arrayDataSize, mul(orderStructSize, i)))
2722 
2723                 // Store the memory location of this order in the orders array
2724                 mstore(add(orders, mul(add(1, i), 32)), order)
2725 
2726                 // order.version
2727                 offset := and(mload(add(tablesPtr,  0)), 0xFFFF)
2728                 mstore(
2729                     add(order,   0),
2730                     offset
2731                 )
2732 
2733                 // order.owner
2734                 offset := mul(and(mload(add(tablesPtr,  2)), 0xFFFF), 4)
2735                 mstore(
2736                     add(order,  32),
2737                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2738                 )
2739 
2740                 // order.tokenS
2741                 offset := mul(and(mload(add(tablesPtr,  4)), 0xFFFF), 4)
2742                 mstore(
2743                     add(order,  64),
2744                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2745                 )
2746 
2747                 // order.tokenB
2748                 offset := mul(and(mload(add(tablesPtr,  6)), 0xFFFF), 4)
2749                 mstore(
2750                     add(order,  96),
2751                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2752                 )
2753 
2754                 // order.amountS
2755                 offset := mul(and(mload(add(tablesPtr,  8)), 0xFFFF), 4)
2756                 mstore(
2757                     add(order, 128),
2758                     mload(add(add(data, 32), offset))
2759                 )
2760 
2761                 // order.amountB
2762                 offset := mul(and(mload(add(tablesPtr, 10)), 0xFFFF), 4)
2763                 mstore(
2764                     add(order, 160),
2765                     mload(add(add(data, 32), offset))
2766                 )
2767 
2768                 // order.validSince
2769                 offset := mul(and(mload(add(tablesPtr, 12)), 0xFFFF), 4)
2770                 mstore(
2771                     add(order, 192),
2772                     and(mload(add(add(data, 4), offset)), 0xFFFFFFFF)
2773                 )
2774 
2775                 // order.tokenSpendableS
2776                 offset := and(mload(add(tablesPtr, 14)), 0xFFFF)
2777                 // Force the spendable index to 0 if it's invalid
2778                 offset := mul(offset, lt(offset, numSpendables))
2779                 mstore(
2780                     add(order, 224),
2781                     mload(add(spendableList, mul(add(offset, 1), 32)))
2782                 )
2783 
2784                 // order.tokenSpendableFee
2785                 offset := and(mload(add(tablesPtr, 16)), 0xFFFF)
2786                 // Force the spendable index to 0 if it's invalid
2787                 offset := mul(offset, lt(offset, numSpendables))
2788                 mstore(
2789                     add(order, 256),
2790                     mload(add(spendableList, mul(add(offset, 1), 32)))
2791                 )
2792 
2793                 // order.dualAuthAddr
2794                 offset := mul(and(mload(add(tablesPtr, 18)), 0xFFFF), 4)
2795                 mstore(
2796                     add(order, 288),
2797                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2798                 )
2799 
2800                 // order.broker
2801                 offset := mul(and(mload(add(tablesPtr, 20)), 0xFFFF), 4)
2802                 mstore(
2803                     add(order, 320),
2804                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2805                 )
2806 
2807                 // order.orderInterceptor
2808                 offset := mul(and(mload(add(tablesPtr, 22)), 0xFFFF), 4)
2809                 mstore(
2810                     add(order, 416),
2811                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2812                 )
2813 
2814                 // order.wallet
2815                 offset := mul(and(mload(add(tablesPtr, 24)), 0xFFFF), 4)
2816                 mstore(
2817                     add(order, 448),
2818                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2819                 )
2820 
2821                 // order.validUntil
2822                 offset := mul(and(mload(add(tablesPtr, 26)), 0xFFFF), 4)
2823                 mstore(
2824                     add(order, 480),
2825                     and(mload(add(add(data,  4), offset)), 0xFFFFFFFF)
2826                 )
2827 
2828                 // Default to empty bytes array for value sig and dualAuthSig
2829                 mstore(add(data, 32), emptyBytes)
2830 
2831                 // order.sig
2832                 offset := mul(and(mload(add(tablesPtr, 28)), 0xFFFF), 4)
2833                 mstore(
2834                     add(order, 512),
2835                     add(data, add(offset, 32))
2836                 )
2837 
2838                 // order.dualAuthSig
2839                 offset := mul(and(mload(add(tablesPtr, 30)), 0xFFFF), 4)
2840                 mstore(
2841                     add(order, 544),
2842                     add(data, add(offset, 32))
2843                 )
2844 
2845                 // Restore default to 0
2846                 mstore(add(data, 32), 0)
2847 
2848                 // order.allOrNone
2849                 offset := and(mload(add(tablesPtr, 32)), 0xFFFF)
2850                 mstore(
2851                     add(order, 576),
2852                     gt(offset, 0)
2853                 )
2854 
2855                 // lrcTokenAddress is the default value for feeToken
2856                 mstore(add(data, 20), lrcTokenAddress)
2857 
2858                 // order.feeToken
2859                 offset := mul(and(mload(add(tablesPtr, 34)), 0xFFFF), 4)
2860                 mstore(
2861                     add(order, 608),
2862                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2863                 )
2864 
2865                 // Restore default to 0
2866                 mstore(add(data, 20), 0)
2867 
2868                 // order.feeAmount
2869                 offset := mul(and(mload(add(tablesPtr, 36)), 0xFFFF), 4)
2870                 mstore(
2871                     add(order, 640),
2872                     mload(add(add(data, 32), offset))
2873                 )
2874 
2875                 // order.waiveFeePercentage
2876                 offset := and(mload(add(tablesPtr, 38)), 0xFFFF)
2877                 mstore(
2878                     add(order, 672),
2879                     offset
2880                 )
2881 
2882                 // order.tokenSFeePercentage
2883                 offset := and(mload(add(tablesPtr, 40)), 0xFFFF)
2884                 mstore(
2885                     add(order, 704),
2886                     offset
2887                 )
2888 
2889                 // order.tokenBFeePercentage
2890                 offset := and(mload(add(tablesPtr, 42)), 0xFFFF)
2891                 mstore(
2892                     add(order, 736),
2893                     offset
2894                 )
2895 
2896                 // The owner is the default value of tokenRecipient
2897                 mstore(add(data, 20), mload(add(order, 32)))                // order.owner
2898 
2899                 // order.tokenRecipient
2900                 offset := mul(and(mload(add(tablesPtr, 44)), 0xFFFF), 4)
2901                 mstore(
2902                     add(order, 768),
2903                     and(mload(add(add(data, 20), offset)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2904                 )
2905 
2906                 // Restore default to 0
2907                 mstore(add(data, 20), 0)
2908 
2909                 // order.walletSplitPercentage
2910                 offset := and(mload(add(tablesPtr, 46)), 0xFFFF)
2911                 mstore(
2912                     add(order, 800),
2913                     offset
2914                 )
2915 
2916                 // order.tokenTypeS
2917                 offset := and(mload(add(tablesPtr, 48)), 0xFFFF)
2918                 mstore(
2919                     add(order, 1024),
2920                     offset
2921                 )
2922 
2923                 // order.tokenTypeB
2924                 offset := and(mload(add(tablesPtr, 50)), 0xFFFF)
2925                 mstore(
2926                     add(order, 1056),
2927                     offset
2928                 )
2929 
2930                 // order.tokenTypeFee
2931                 offset := and(mload(add(tablesPtr, 52)), 0xFFFF)
2932                 mstore(
2933                     add(order, 1088),
2934                     offset
2935                 )
2936 
2937                 // order.trancheS
2938                 offset := mul(and(mload(add(tablesPtr, 54)), 0xFFFF), 4)
2939                 mstore(
2940                     add(order, 1120),
2941                     mload(add(add(data, 32), offset))
2942                 )
2943 
2944                 // order.trancheB
2945                 offset := mul(and(mload(add(tablesPtr, 56)), 0xFFFF), 4)
2946                 mstore(
2947                     add(order, 1152),
2948                     mload(add(add(data, 32), offset))
2949                 )
2950 
2951                 // Default to empty bytes array for transferDataS
2952                 mstore(add(data, 32), emptyBytes)
2953 
2954                 // order.transferDataS
2955                 offset := mul(and(mload(add(tablesPtr, 58)), 0xFFFF), 4)
2956                 mstore(
2957                     add(order, 1184),
2958                     add(data, add(offset, 32))
2959                 )
2960 
2961                 // Restore default to 0
2962                 mstore(add(data, 32), 0)
2963 
2964                 // Set default  values
2965                 mstore(add(order, 832), 0)         // order.P2P
2966                 mstore(add(order, 864), 0)         // order.hash
2967                 mstore(add(order, 896), 0)         // order.brokerInterceptor
2968                 mstore(add(order, 928), 0)         // order.filledAmountS
2969                 mstore(add(order, 960), 0)         // order.initialFilledAmountS
2970                 mstore(add(order, 992), 1)         // order.valid
2971 
2972                 // Advance to the next order
2973                 tablesPtr := add(tablesPtr, 60)
2974             }
2975         }
2976     }
2977 
2978     function assembleRings(
2979         uint data,
2980         uint numRings,
2981         Data.Order[] memory orders
2982         )
2983         internal
2984         pure
2985         returns (Data.Ring[] memory rings)
2986     {
2987         uint ringsArrayDataSize = (1 + numRings) * 32;
2988         uint ringStructSize = 5 * 32;
2989         uint participationStructSize = 10 * 32;
2990 
2991         assembly {
2992             // Allocate memory for all rings
2993             rings := mload(0x40)
2994             mstore(add(rings, 0), numRings)                      // rings.length
2995             // Reserve the memory for the rings array
2996             mstore(0x40, add(rings, add(ringsArrayDataSize, mul(ringStructSize, numRings))))
2997 
2998             for { let r := 0 } lt(r, numRings) { r := add(r, 1) } {
2999                 let ring := add(rings, add(ringsArrayDataSize, mul(ringStructSize, r)))
3000 
3001                 // Store the memory location of this ring in the rings array
3002                 mstore(add(rings, mul(add(r, 1), 32)), ring)
3003 
3004                 // Get the ring size
3005                 let ringSize := and(mload(data), 0xFF)
3006                 data := add(data, 1)
3007 
3008                 // require(ringsSize <= 8)
3009                 if gt(ringSize, 8) {
3010                     revert(0, 0)
3011                 }
3012 
3013                 // Allocate memory for all participations
3014                 let participations := mload(0x40)
3015                 mstore(add(participations, 0), ringSize)         // participations.length
3016                 // Memory for participations length + ringSize participation pointers
3017                 let participationsData := add(participations, mul(add(1, ringSize), 32))
3018                 // Reserve the memory for the participations
3019                 mstore(0x40, add(participationsData, mul(participationStructSize, ringSize)))
3020 
3021                 // Initialize ring properties
3022                 mstore(add(ring,   0), ringSize)                 // ring.size
3023                 mstore(add(ring,  32), participations)           // ring.participations
3024                 mstore(add(ring,  64), 0)                        // ring.hash
3025                 mstore(add(ring,  96), 0)                        // ring.minerFeesToOrdersPercentage
3026                 mstore(add(ring, 128), 1)                        // ring.valid
3027 
3028                 for { let i := 0 } lt(i, ringSize) { i := add(i, 1) } {
3029                     let participation := add(participationsData, mul(participationStructSize, i))
3030 
3031                     // Store the memory location of this participation in the participations array
3032                     mstore(add(participations, mul(add(i, 1), 32)), participation)
3033 
3034                     // Get the order index
3035                     let orderIndex := and(mload(data), 0xFF)
3036                     // require(orderIndex < orders.length)
3037                     if iszero(lt(orderIndex, mload(orders))) {
3038                         revert(0, 0)
3039                     }
3040                     data := add(data, 1)
3041 
3042                     // participation.order
3043                     mstore(
3044                         add(participation,   0),
3045                         mload(add(orders, mul(add(orderIndex, 1), 32)))
3046                     )
3047 
3048                     // Set default values
3049                     mstore(add(participation,  32), 0)          // participation.splitS
3050                     mstore(add(participation,  64), 0)          // participation.feeAmount
3051                     mstore(add(participation,  96), 0)          // participation.feeAmountS
3052                     mstore(add(participation, 128), 0)          // participation.feeAmountB
3053                     mstore(add(participation, 160), 0)          // participation.rebateFee
3054                     mstore(add(participation, 192), 0)          // participation.rebateS
3055                     mstore(add(participation, 224), 0)          // participation.rebateB
3056                     mstore(add(participation, 256), 0)          // participation.fillAmountS
3057                     mstore(add(participation, 288), 0)          // participation.fillAmountB
3058                 }
3059 
3060                 // Advance to the next ring
3061                 data := add(data, sub(8, ringSize))
3062             }
3063         }
3064     }
3065 }
3066 
3067 
3068 
3069 /// @title An Implementation of IRingSubmitter.
3070 /// @author Daniel Wang - <daniel@loopring.org>,
3071 /// @author Kongliang Zhong - <kongliang@loopring.org>
3072 /// @author Brechtpd - <brecht@loopring.org>
3073 /// Recognized contributing developers from the community:
3074 ///     https://github.com/rainydio
3075 ///     https://github.com/BenjaminPrice
3076 ///     https://github.com/jonasshen
3077 ///     https://github.com/Hephyrius
3078 contract RingSubmitter is IRingSubmitter, NoDefaultFunc {
3079     using MathUint      for uint;
3080     using BytesUtil     for bytes;
3081     using OrderHelper     for Data.Order;
3082     using RingHelper      for Data.Ring;
3083     using MiningHelper    for Data.Mining;
3084 
3085     address public constant lrcTokenAddress             = 0xEF68e7C694F40c8202821eDF525dE3782458639f;
3086     address public constant wethTokenAddress            = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
3087     address public constant delegateAddress             = 0xb258f5C190faDAB30B5fF0D6ab7E32a646A4BaAe;
3088     address public constant tradeHistoryAddress         = 0xBF5a37670B3DE1E606EC68bE3558c536b2008669;
3089     address public constant orderBrokerRegistryAddress  = 0x4e1E917F030556788AB3C9d8D0971Ebf0d5439E9;
3090     address public constant orderRegistryAddress        = 0x6fb707F15Ab3657Dc52776b057B33cB7D95e4E90;
3091     address public constant feeHolderAddress            = 0x5beaEA36efA78F43a6d61145817FDFf6A9929e60;
3092     address public constant orderBookAddress            = 0xaC0F8a27012fe8dc5a0bB7f5fc7170934F7e3577;
3093     address public constant burnRateTableAddress        = 0x20D90aefBA13F044C5d23c48C3b07e2E43a006DB;
3094 
3095     uint64  public  ringIndex                   = 0;
3096 
3097     uint    public constant MAX_RING_SIZE       = 8;
3098 
3099     struct SubmitRingsParam {
3100         uint16[]    encodeSpecs;
3101         uint16      miningSpec;
3102         uint16[]    orderSpecs;
3103         uint8[][]   ringSpecs;
3104         address[]   addressList;
3105         uint[]      uintList;
3106         bytes[]     bytesList;
3107     }
3108 
3109     /* constructor( */
3110     /*     address _lrcTokenAddress, */
3111     /*     address _wethTokenAddress, */
3112     /*     address _delegateAddress, */
3113     /*     address _tradeHistoryAddress, */
3114     /*     address _orderBrokerRegistryAddress, */
3115     /*     address _orderRegistryAddress, */
3116     /*     address _feeHolderAddress, */
3117     /*     address _orderBookAddress, */
3118     /*     address _burnRateTableAddress */
3119     /*     ) */
3120     /*     public */
3121     /* { */
3122     /*     require(_lrcTokenAddress != address(0x0), ZERO_ADDRESS); */
3123     /*     require(_wethTokenAddress != address(0x0), ZERO_ADDRESS); */
3124     /*     require(_delegateAddress != address(0x0), ZERO_ADDRESS); */
3125     /*     require(_tradeHistoryAddress != address(0x0), ZERO_ADDRESS); */
3126     /*     require(_orderBrokerRegistryAddress != address(0x0), ZERO_ADDRESS); */
3127     /*     require(_orderRegistryAddress != address(0x0), ZERO_ADDRESS); */
3128     /*     require(_feeHolderAddress != address(0x0), ZERO_ADDRESS); */
3129     /*     require(_orderBookAddress != address(0x0), ZERO_ADDRESS); */
3130     /*     require(_burnRateTableAddress != address(0x0), ZERO_ADDRESS); */
3131 
3132     /*     lrcTokenAddress = _lrcTokenAddress; */
3133     /*     wethTokenAddress = _wethTokenAddress; */
3134     /*     delegateAddress = _delegateAddress; */
3135     /*     tradeHistoryAddress = _tradeHistoryAddress; */
3136     /*     orderBrokerRegistryAddress = _orderBrokerRegistryAddress; */
3137     /*     orderRegistryAddress = _orderRegistryAddress; */
3138     /*     feeHolderAddress = _feeHolderAddress; */
3139     /*     orderBookAddress = _orderBookAddress; */
3140     /*     burnRateTableAddress = _burnRateTableAddress; */
3141     /* } */
3142 
3143     function submitRings(
3144         bytes calldata data
3145         )
3146         external
3147     {
3148         uint i;
3149         bytes32[] memory tokenBurnRates;
3150         Data.Context memory ctx = Data.Context(
3151             lrcTokenAddress,
3152             ITradeDelegate(delegateAddress),
3153             ITradeHistory(tradeHistoryAddress),
3154             IBrokerRegistry(orderBrokerRegistryAddress),
3155             IOrderRegistry(orderRegistryAddress),
3156             IFeeHolder(feeHolderAddress),
3157             IOrderBook(orderBookAddress),
3158             IBurnRateTable(burnRateTableAddress),
3159             ringIndex,
3160             FEE_PERCENTAGE_BASE,
3161             tokenBurnRates,
3162             0,
3163             0,
3164             0,
3165             0
3166         );
3167 
3168         // Check if the highest bit of ringIndex is '1'
3169         require((ctx.ringIndex >> 63) == 0, REENTRY);
3170 
3171         // Set the highest bit of ringIndex to '1' (IN STORAGE!)
3172         ringIndex = ctx.ringIndex | (1 << 63);
3173 
3174         (
3175             Data.Mining  memory mining,
3176             Data.Order[] memory orders,
3177             Data.Ring[]  memory rings
3178         ) = ExchangeDeserializer.deserialize(lrcTokenAddress, data);
3179 
3180         // Allocate memory that is used to batch things for all rings
3181         setupLists(ctx, orders, rings);
3182 
3183         for (i = 0; i < orders.length; i++) {
3184             orders[i].updateHash();
3185             orders[i].updateBrokerAndInterceptor(ctx);
3186         }
3187 
3188         batchGetFilledAndCheckCancelled(ctx, orders);
3189 
3190         for (i = 0; i < orders.length; i++) {
3191             orders[i].check(ctx);
3192             // An order can only be sent once
3193             for (uint j = i + 1; j < orders.length; j++) {
3194                 require(orders[i].hash != orders[j].hash, INVALID_VALUE);
3195             }
3196         }
3197 
3198         for (i = 0; i < rings.length; i++) {
3199             rings[i].updateHash();
3200         }
3201 
3202         mining.updateHash(rings);
3203         mining.updateMinerAndInterceptor();
3204         require(mining.checkMinerSignature(), INVALID_SIG);
3205 
3206         for (i = 0; i < orders.length; i++) {
3207             // We don't need to verify the dual author signature again if it uses the same
3208             // dual author address as the previous order (the miner can optimize the order of the orders
3209             // so this happens as much as possible). We don't need to check if the signature is the same
3210             // because the same mining hash is signed for all orders.
3211             if(i > 0 && orders[i].dualAuthAddr == orders[i - 1].dualAuthAddr) {
3212                 continue;
3213             }
3214             orders[i].checkDualAuthSignature(mining.hash);
3215         }
3216 
3217         for (i = 0; i < rings.length; i++) {
3218             Data.Ring memory ring = rings[i];
3219             ring.checkOrdersValid();
3220             ring.checkForSubRings();
3221             ring.calculateFillAmountAndFee(ctx);
3222             if (ring.valid) {
3223                 ring.adjustOrderStates();
3224             }
3225         }
3226 
3227         // Check if the allOrNone orders are completely filled over all rings
3228         // This can invalidate rings
3229         checkRings(orders, rings);
3230 
3231         for (i = 0; i < rings.length; i++) {
3232             Data.Ring memory ring = rings[i];
3233             if (ring.valid) {
3234                 // Only settle rings we have checked to be valid
3235                 ring.doPayments(ctx, mining);
3236                 emitRingMinedEvent(
3237                     ring,
3238                     ctx.ringIndex++,
3239                     mining.feeRecipient
3240                 );
3241             } else {
3242                 emit InvalidRing(ring.hash);
3243             }
3244         }
3245 
3246         // Do all token transfers for all rings
3247         batchTransferTokens(ctx);
3248         // Do all fee payments for all rings
3249         batchPayFees(ctx);
3250         // Update all order stats
3251         updateOrdersStats(ctx, orders);
3252 
3253         // Update ringIndex while setting the highest bit of ringIndex back to '0'
3254         ringIndex = ctx.ringIndex;
3255     }
3256 
3257     function checkRings(
3258         Data.Order[] memory orders,
3259         Data.Ring[] memory rings
3260         )
3261         internal
3262         pure
3263     {
3264         // Check if allOrNone orders are completely filled
3265         // When a ring is turned invalid because of an allOrNone order we have to
3266         // recheck the other rings again because they may contain other allOrNone orders
3267         // that may not be completely filled anymore.
3268         bool reevaluateRings = true;
3269         while (reevaluateRings) {
3270             reevaluateRings = false;
3271             for (uint i = 0; i < orders.length; i++) {
3272                 if (orders[i].valid) {
3273                     orders[i].validateAllOrNone();
3274                     // Check if the order valid status has changed
3275                     reevaluateRings = reevaluateRings || !orders[i].valid;
3276                 }
3277             }
3278             if (reevaluateRings) {
3279                 for (uint i = 0; i < rings.length; i++) {
3280                     Data.Ring memory ring = rings[i];
3281                     if (ring.valid) {
3282                         ring.checkOrdersValid();
3283                         if (!ring.valid) {
3284                             // If the ring was valid before the completely filled check we have to revert the filled amountS
3285                             // of the orders in the ring. This is a bit awkward so maybe there's a better solution.
3286                             ring.revertOrderStats();
3287                         }
3288                     }
3289                 }
3290             }
3291         }
3292     }
3293 
3294     function emitRingMinedEvent(
3295         Data.Ring memory ring,
3296         uint _ringIndex,
3297         address feeRecipient
3298         )
3299         internal
3300     {
3301         bytes32 ringHash = ring.hash;
3302         // keccak256("RingMined(uint256,bytes32,address,bytes)")
3303         bytes32 ringMinedSignature = 0xb2ef4bc5209dff0c46d5dfddb2b68a23bd4820e8f33107fde76ed15ba90695c9;
3304         uint fillsSize = ring.size * 8 * 32;
3305 
3306         uint data;
3307         uint ptr;
3308         assembly {
3309             data := mload(0x40)
3310             ptr := data
3311             mstore(ptr, _ringIndex)                     // ring index data
3312             mstore(add(ptr, 32), 0x40)                  // offset to fills data
3313             mstore(add(ptr, 64), fillsSize)             // fills length
3314             ptr := add(ptr, 96)
3315         }
3316         ptr = ring.generateFills(ptr);
3317 
3318         assembly {
3319             log3(
3320                 data,                                   // data start
3321                 sub(ptr, data),                         // data length
3322                 ringMinedSignature,                     // Topic 0: RingMined signature
3323                 ringHash,                               // Topic 1: ring hash
3324                 feeRecipient                            // Topic 2: feeRecipient
3325             )
3326         }
3327     }
3328 
3329     function setupLists(
3330         Data.Context memory ctx,
3331         Data.Order[] memory orders,
3332         Data.Ring[] memory rings
3333         )
3334         internal
3335         pure
3336     {
3337         setupTokenBurnRateList(ctx, orders);
3338         setupFeePaymentList(ctx, rings);
3339         setupTokenTransferList(ctx, rings);
3340     }
3341 
3342     function setupTokenBurnRateList(
3343         Data.Context memory ctx,
3344         Data.Order[] memory orders
3345         )
3346         internal
3347         pure
3348     {
3349         // Allocate enough memory to store burn rates for all tokens even
3350         // if every token is unique (max 2 unique tokens / order)
3351         uint maxNumTokenBurnRates = orders.length * 2;
3352         bytes32[] memory tokenBurnRates;
3353         assembly {
3354             tokenBurnRates := mload(0x40)
3355             mstore(tokenBurnRates, 0)                               // tokenBurnRates.length
3356             mstore(0x40, add(
3357                 tokenBurnRates,
3358                 add(32, mul(maxNumTokenBurnRates, 64))
3359             ))
3360         }
3361         ctx.tokenBurnRates = tokenBurnRates;
3362     }
3363 
3364     function setupFeePaymentList(
3365         Data.Context memory ctx,
3366         Data.Ring[] memory rings
3367         )
3368         internal
3369         pure
3370     {
3371         uint totalMaxSizeFeePayments = 0;
3372         for (uint i = 0; i < rings.length; i++) {
3373             // Up to (ringSize + 3) * 3 payments per order (because of fee sharing by miner)
3374             // (3 x 32 bytes for every fee payment)
3375             uint ringSize = rings[i].size;
3376             uint maxSize = (ringSize + 3) * 3 * ringSize * 3;
3377             totalMaxSizeFeePayments += maxSize;
3378         }
3379         // Store the data directly in the call data format as expected by batchAddFeeBalances:
3380         // - 0x00: batchAddFeeBalances selector (4 bytes)
3381         // - 0x04: parameter offset (batchAddFeeBalances has a single function parameter) (32 bytes)
3382         // - 0x24: length of the array passed into the function (32 bytes)
3383         // - 0x44: the array data (32 bytes x length)
3384         bytes4 batchAddFeeBalancesSelector = ctx.feeHolder.batchAddFeeBalances.selector;
3385         uint ptr;
3386         assembly {
3387             let data := mload(0x40)
3388             mstore(data, batchAddFeeBalancesSelector)
3389             mstore(add(data, 4), 32)
3390             ptr := add(data, 68)
3391             mstore(0x40, add(ptr, mul(totalMaxSizeFeePayments, 32)))
3392         }
3393         ctx.feeData = ptr;
3394         ctx.feePtr = ptr;
3395     }
3396 
3397     function setupTokenTransferList(
3398         Data.Context memory ctx,
3399         Data.Ring[] memory rings
3400         )
3401         internal
3402         pure
3403     {
3404         uint totalMaxSizeTransfers = 0;
3405         for (uint i = 0; i < rings.length; i++) {
3406             // Up to 4 transfers per order
3407             // (4 x 32 bytes for every transfer)
3408             uint maxSize = 4 * rings[i].size * 4;
3409             totalMaxSizeTransfers += maxSize;
3410         }
3411         // Store the data directly in the call data format as expected by batchTransfer:
3412         // - 0x00: batchTransfer selector (4 bytes)
3413         // - 0x04: parameter offset (batchTransfer has a single function parameter) (32 bytes)
3414         // - 0x24: length of the array passed into the function (32 bytes)
3415         // - 0x44: the array data (32 bytes x length)
3416         bytes4 batchTransferSelector = ctx.delegate.batchTransfer.selector;
3417         uint ptr;
3418         assembly {
3419             let data := mload(0x40)
3420             mstore(data, batchTransferSelector)
3421             mstore(add(data, 4), 32)
3422             ptr := add(data, 68)
3423             mstore(0x40, add(ptr, mul(totalMaxSizeTransfers, 32)))
3424         }
3425         ctx.transferData = ptr;
3426         ctx.transferPtr = ptr;
3427     }
3428 
3429     function updateOrdersStats(
3430         Data.Context memory ctx,
3431         Data.Order[] memory orders
3432         )
3433         internal
3434     {
3435         // Store the data directly in the call data format as expected by batchUpdateFilled:
3436         // - 0x00: batchUpdateFilled selector (4 bytes)
3437         // - 0x04: parameter offset (batchUpdateFilled has a single function parameter) (32 bytes)
3438         // - 0x24: length of the array passed into the function (32 bytes)
3439         // - 0x44: the array data (32 bytes x length)
3440         // For every (valid) order we store 2 words:
3441         // - order.hash
3442         // - order.filledAmountS after all rings
3443         bytes4 batchUpdateFilledSelector = ctx.tradeHistory.batchUpdateFilled.selector;
3444         address _tradeHistoryAddress = address(ctx.tradeHistory);
3445         assembly {
3446             let data := mload(0x40)
3447             mstore(data, batchUpdateFilledSelector)
3448             mstore(add(data, 4), 32)
3449             let ptr := add(data, 68)
3450             let arrayLength := 0
3451             for { let i := 0 } lt(i, mload(orders)) { i := add(i, 1) } {
3452                 let order := mload(add(orders, mul(add(i, 1), 32)))
3453                 let filledAmount := mload(add(order, 928))                               // order.filledAmountS
3454                 let initialFilledAmount := mload(add(order, 960))                        // order.initialFilledAmountS
3455                 let filledAmountChanged := iszero(eq(filledAmount, initialFilledAmount))
3456                 // if (order.valid && filledAmountChanged)
3457                 if and(gt(mload(add(order, 992)), 0), filledAmountChanged) {             // order.valid
3458                     mstore(add(ptr,   0), mload(add(order, 864)))                        // order.hash
3459                     mstore(add(ptr,  32), filledAmount)
3460 
3461                     ptr := add(ptr, 64)
3462                     arrayLength := add(arrayLength, 2)
3463                 }
3464             }
3465 
3466             // Only do the external call if the list is not empty
3467             if gt(arrayLength, 0) {
3468                 mstore(add(data, 36), arrayLength)      // filledInfo.length
3469 
3470                 let success := call(
3471                     gas,                                // forward all gas
3472                     _tradeHistoryAddress,               // external address
3473                     0,                                  // wei
3474                     data,                               // input start
3475                     sub(ptr, data),                     // input length
3476                     data,                               // output start
3477                     0                                   // output length
3478                 )
3479                 if eq(success, 0) {
3480                     // Propagate the revert message
3481                     returndatacopy(0, 0, returndatasize())
3482                     revert(0, returndatasize())
3483                 }
3484             }
3485         }
3486     }
3487 
3488     function batchGetFilledAndCheckCancelled(
3489         Data.Context memory ctx,
3490         Data.Order[] memory orders
3491         )
3492         internal
3493     {
3494         // Store the data in the call data format as expected by batchGetFilledAndCheckCancelled:
3495         // - 0x00: batchGetFilledAndCheckCancelled selector (4 bytes)
3496         // - 0x04: parameter offset (batchGetFilledAndCheckCancelled has a single function parameter) (32 bytes)
3497         // - 0x24: length of the array passed into the function (32 bytes)
3498         // - 0x44: the array data (32 bytes x length)
3499         // For every order we store 5 words:
3500         // - order.broker
3501         // - order.owner
3502         // - order.hash
3503         // - order.validSince
3504         // - The trading pair of the order: order.tokenS ^ order.tokenB
3505         bytes4 batchGetFilledAndCheckCancelledSelector = ctx.tradeHistory.batchGetFilledAndCheckCancelled.selector;
3506         address _tradeHistoryAddress = address(ctx.tradeHistory);
3507         assembly {
3508             let data := mload(0x40)
3509             mstore(data, batchGetFilledAndCheckCancelledSelector)
3510             mstore(add(data,  4), 32)
3511             mstore(add(data, 36), mul(mload(orders), 5))                // orders.length
3512             let ptr := add(data, 68)
3513             for { let i := 0 } lt(i, mload(orders)) { i := add(i, 1) } {
3514                 let order := mload(add(orders, mul(add(i, 1), 32)))     // orders[i]
3515                 mstore(add(ptr,   0), mload(add(order, 320)))           // order.broker
3516                 mstore(add(ptr,  32), mload(add(order,  32)))           // order.owner
3517                 mstore(add(ptr,  64), mload(add(order, 864)))           // order.hash
3518                 mstore(add(ptr,  96), mload(add(order, 192)))           // order.validSince
3519                 // bytes20(order.tokenS) ^ bytes20(order.tokenB)        // tradingPair
3520                 mstore(add(ptr, 128), mul(
3521                     xor(
3522                         mload(add(order, 64)),                 // order.tokenS
3523                         mload(add(order, 96))                  // order.tokenB
3524                     ),
3525                     0x1000000000000000000000000)               // shift left 12 bytes (bytes20 is padded on the right)
3526                 )
3527                 ptr := add(ptr, 160)                                    // 5 * 32
3528             }
3529             // Return data is stored just like the call data without the signature:
3530             // 0x00: Offset to data
3531             // 0x20: Array length
3532             // 0x40: Array data
3533             let returnDataSize := mul(add(2, mload(orders)), 32)
3534             let success := call(
3535                 gas,                                // forward all gas
3536                 _tradeHistoryAddress,               // external address
3537                 0,                                  // wei
3538                 data,                               // input start
3539                 sub(ptr, data),                     // input length
3540                 data,                               // output start
3541                 returnDataSize                      // output length
3542             )
3543             // Check if the call was successful and the return data is the expected size
3544             if or(eq(success, 0), iszero(eq(returndatasize(), returnDataSize))) {
3545                 if eq(success, 0) {
3546                     // Propagate the revert message
3547                     returndatacopy(0, 0, returndatasize())
3548                     revert(0, returndatasize())
3549                 }
3550                 revert(0, 0)
3551             }
3552             for { let i := 0 } lt(i, mload(orders)) { i := add(i, 1) } {
3553                 let order := mload(add(orders, mul(add(i, 1), 32)))     // orders[i]
3554                 let fill := mload(add(data,  mul(add(i, 2), 32)))       // fills[i]
3555                 mstore(add(order, 928), fill)                           // order.filledAmountS
3556                 mstore(add(order, 960), fill)                           // order.initialFilledAmountS
3557                 // If fills[i] == ~uint(0) the order was cancelled
3558                 // order.valid = order.valid && (order.filledAmountS != ~uint(0))
3559                 mstore(add(order, 992),                                 // order.valid
3560                     and(
3561                         gt(mload(add(order, 992)), 0),                  // order.valid
3562                         iszero(eq(fill, not(0)))                        // fill != ~uint(0
3563                     )
3564                 )
3565             }
3566         }
3567     }
3568 
3569     function batchTransferTokens(
3570         Data.Context memory ctx
3571         )
3572         internal
3573     {
3574         // Check if there are any transfers
3575         if (ctx.transferData == ctx.transferPtr) {
3576             return;
3577         }
3578         // We stored the token transfers in the call data as expected by batchTransfer.
3579         // The only thing we still need to do is update the final length of the array and call
3580         // the function on the TradeDelegate contract with the generated data.
3581         address _tradeDelegateAddress = address(ctx.delegate);
3582         uint arrayLength = (ctx.transferPtr - ctx.transferData) / 32;
3583         uint data = ctx.transferData - 68;
3584         uint ptr = ctx.transferPtr;
3585         assembly {
3586             mstore(add(data, 36), arrayLength)      // batch.length
3587 
3588             let success := call(
3589                 gas,                                // forward all gas
3590                 _tradeDelegateAddress,              // external address
3591                 0,                                  // wei
3592                 data,                               // input start
3593                 sub(ptr, data),                     // input length
3594                 data,                               // output start
3595                 0                                   // output length
3596             )
3597             if eq(success, 0) {
3598                 // Propagate the revert message
3599                 returndatacopy(0, 0, returndatasize())
3600                 revert(0, returndatasize())
3601             }
3602         }
3603     }
3604 
3605     function batchPayFees(
3606         Data.Context memory ctx
3607         )
3608         internal
3609     {
3610         // Check if there are any fee payments
3611         if (ctx.feeData == ctx.feePtr) {
3612             return;
3613         }
3614         // We stored the fee payments in the call data as expected by batchAddFeeBalances.
3615         // The only thing we still need to do is update the final length of the array and call
3616         // the function on the FeeHolder contract with the generated data.
3617         address _feeHolderAddress = address(ctx.feeHolder);
3618         uint arrayLength = (ctx.feePtr - ctx.feeData) / 32;
3619         uint data = ctx.feeData - 68;
3620         uint ptr = ctx.feePtr;
3621         assembly {
3622             mstore(add(data, 36), arrayLength)      // batch.length
3623 
3624             let success := call(
3625                 gas,                                // forward all gas
3626                 _feeHolderAddress,                  // external address
3627                 0,                                  // wei
3628                 data,                               // input start
3629                 sub(ptr, data),                     // input length
3630                 data,                               // output start
3631                 0                                   // output length
3632             )
3633             if eq(success, 0) {
3634                 // Propagate the revert message
3635                 returndatacopy(0, 0, returndatasize())
3636                 revert(0, returndatasize())
3637             }
3638         }
3639     }
3640 
3641 }