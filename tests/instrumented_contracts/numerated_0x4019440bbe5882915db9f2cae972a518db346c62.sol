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
14 /// @title Utility Functions for uint8
15 /// @author Kongliang Zhong - <kongliang@loopring.org>,
16 /// @author Daniel Wang - <daniel@loopring.org>.
17 library MathUint8 {
18     function xorReduce(
19         uint8[] arr,
20         uint    len
21         )
22         internal
23         pure
24         returns (uint8 res)
25     {
26         res = arr[0];
27         for (uint i = 1; i < len; i++) {
28             res ^= arr[i];
29         }
30     }
31 }
32 /*
33   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
34   Licensed under the Apache License, Version 2.0 (the "License");
35   you may not use this file except in compliance with the License.
36   You may obtain a copy of the License at
37   http://www.apache.org/licenses/LICENSE-2.0
38   Unless required by applicable law or agreed to in writing, software
39   distributed under the License is distributed on an "AS IS" BASIS,
40   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
41   See the License for the specific language governing permissions and
42   limitations under the License.
43 */
44 /// @title Utility Functions for uint
45 /// @author Daniel Wang - <daniel@loopring.org>
46 library MathUint {
47     function mul(uint a, uint b) internal pure returns (uint c) {
48         c = a * b;
49         require(a == 0 || c / a == b);
50     }
51     function sub(uint a, uint b) internal pure returns (uint) {
52         require(b <= a);
53         return a - b;
54     }
55     function add(uint a, uint b) internal pure returns (uint c) {
56         c = a + b;
57         require(c >= a);
58     }
59     function tolerantSub(uint a, uint b) internal pure returns (uint c) {
60         return (a >= b) ? a - b : 0;
61     }
62     /// @dev calculate the square of Coefficient of Variation (CV)
63     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
64     function cvsquare(
65         uint[] arr,
66         uint scale
67         )
68         internal
69         pure
70         returns (uint)
71     {
72         uint len = arr.length;
73         require(len > 1);
74         require(scale > 0);
75         uint avg = 0;
76         for (uint i = 0; i < len; i++) {
77             avg += arr[i];
78         }
79         avg = avg / len;
80         if (avg == 0) {
81             return 0;
82         }
83         uint cvs = 0;
84         uint s;
85         uint item;
86         for (i = 0; i < len; i++) {
87             item = arr[i];
88             s = item > avg ? item - avg : avg - item;
89             cvs += mul(s, s);
90         }
91         return ((mul(mul(cvs, scale), scale) / avg) / avg) / (len - 1);
92     }
93 }
94 /*
95   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
96   Licensed under the Apache License, Version 2.0 (the "License");
97   you may not use this file except in compliance with the License.
98   You may obtain a copy of the License at
99   http://www.apache.org/licenses/LICENSE-2.0
100   Unless required by applicable law or agreed to in writing, software
101   distributed under the License is distributed on an "AS IS" BASIS,
102   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
103   See the License for the specific language governing permissions and
104   limitations under the License.
105 */
106 /// @title Utility Functions for byte32
107 /// @author Kongliang Zhong - <kongliang@loopring.org>,
108 /// @author Daniel Wang - <daniel@loopring.org>.
109 library MathBytes32 {
110     function xorReduce(
111         bytes32[]   arr,
112         uint        len
113         )
114         internal
115         pure
116         returns (bytes32 res)
117     {
118         res = arr[0];
119         for (uint i = 1; i < len; i++) {
120             res ^= arr[i];
121         }
122     }
123 }
124 /*
125   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
126   Licensed under the Apache License, Version 2.0 (the "License");
127   you may not use this file except in compliance with the License.
128   You may obtain a copy of the License at
129   http://www.apache.org/licenses/LICENSE-2.0
130   Unless required by applicable law or agreed to in writing, software
131   distributed under the License is distributed on an "AS IS" BASIS,
132   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
133   See the License for the specific language governing permissions and
134   limitations under the License.
135 */
136 /// @title Utility Functions for address
137 /// @author Daniel Wang - <daniel@loopring.org>
138 library AddressUtil {
139     function isContract(address addr)
140         internal
141         view
142         returns (bool)
143     {
144         if (addr == 0x0) {
145             return false;
146         } else {
147             uint size;
148             assembly { size := extcodesize(addr) }
149             return size > 0;
150         }
151     }
152 }
153 /*
154   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
155   Licensed under the Apache License, Version 2.0 (the "License");
156   you may not use this file except in compliance with the License.
157   You may obtain a copy of the License at
158   http://www.apache.org/licenses/LICENSE-2.0
159   Unless required by applicable law or agreed to in writing, software
160   distributed under the License is distributed on an "AS IS" BASIS,
161   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
162   See the License for the specific language governing permissions and
163   limitations under the License.
164 */
165 /*
166   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
167   Licensed under the Apache License, Version 2.0 (the "License");
168   you may not use this file except in compliance with the License.
169   You may obtain a copy of the License at
170   http://www.apache.org/licenses/LICENSE-2.0
171   Unless required by applicable law or agreed to in writing, software
172   distributed under the License is distributed on an "AS IS" BASIS,
173   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
174   See the License for the specific language governing permissions and
175   limitations under the License.
176 */
177 /// @title ERC20 Token Interface
178 /// @dev see https://github.com/ethereum/EIPs/issues/20
179 /// @author Daniel Wang - <daniel@loopring.org>
180 contract ERC20 {
181     function balanceOf(address who) view public returns (uint256);
182     function allowance(address owner, address spender) view public returns (uint256);
183     function transfer(address to, uint256 value) public returns (bool);
184     function transferFrom(address from, address to, uint256 value) public returns (bool);
185     function approve(address spender, uint256 value) public returns (bool);
186 }
187 /*
188   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
189   Licensed under the Apache License, Version 2.0 (the "License");
190   you may not use this file except in compliance with the License.
191   You may obtain a copy of the License at
192   http://www.apache.org/licenses/LICENSE-2.0
193   Unless required by applicable law or agreed to in writing, software
194   distributed under the License is distributed on an "AS IS" BASIS,
195   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
196   See the License for the specific language governing permissions and
197   limitations under the License.
198 */
199 /// @title Loopring Token Exchange Protocol Contract Interface
200 /// @author Daniel Wang - <daniel@loopring.org>
201 /// @author Kongliang Zhong - <kongliang@loopring.org>
202 contract LoopringProtocol {
203     ////////////////////////////////////////////////////////////////////////////
204     /// Constants                                                            ///
205     ////////////////////////////////////////////////////////////////////////////
206     uint8   public constant MARGIN_SPLIT_PERCENTAGE_BASE = 100;
207     ////////////////////////////////////////////////////////////////////////////
208     /// Events                                                               ///
209     ////////////////////////////////////////////////////////////////////////////
210     /// @dev Event to emit if a ring is successfully mined.
211     /// _amountsList is an array of:
212     /// [_amountS, _amountB, _lrcReward, _lrcFee, splitS, splitB].
213     event RingMined(
214         uint                _ringIndex,
215         bytes32     indexed _ringHash,
216         address             _miner,
217         address             _feeRecipient,
218         bytes32[]           _orderHashList,
219         uint[6][]           _amountsList
220     );
221     event OrderCancelled(
222         bytes32     indexed _orderHash,
223         uint                _amountCancelled
224     );
225     event AllOrdersCancelled(
226         address     indexed _address,
227         uint                _cutoff
228     );
229     event OrdersCancelled(
230         address     indexed _address,
231         address             _token1,
232         address             _token2,
233         uint                _cutoff
234     );
235     ////////////////////////////////////////////////////////////////////////////
236     /// Functions                                                            ///
237     ////////////////////////////////////////////////////////////////////////////
238     /// @dev Cancel a order. cancel amount(amountS or amountB) can be specified
239     ///      in orderValues.
240     /// @param addresses          owner, tokenS, tokenB, authAddr
241     /// @param orderValues        amountS, amountB, validSince (second),
242     ///                           validUntil (second), lrcFee, walletId, and
243     ///                           cancelAmount.
244     /// @param buyNoMoreThanAmountB -
245     ///                           This indicates when a order should be considered
246     ///                           as 'completely filled'.
247     /// @param marginSplitPercentage -
248     ///                           Percentage of margin split to share with miner.
249     /// @param v                  Order ECDSA signature parameter v.
250     /// @param r                  Order ECDSA signature parameters r.
251     /// @param s                  Order ECDSA signature parameters s.
252     function cancelOrder(
253         address[4] addresses,
254         uint[7]    orderValues,
255         bool       buyNoMoreThanAmountB,
256         uint8      marginSplitPercentage,
257         uint8      v,
258         bytes32    r,
259         bytes32    s
260         ) external;
261     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
262     ///        is smaller than or equal to the new value of the address's cutoff
263     ///        timestamp, for a specific trading pair.
264     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
265     ///        if it is 0.
266     function cancelAllOrdersByTradingPair(
267         address token1,
268         address token2,
269         uint cutoff
270         ) external;
271     /// @dev   Set a cutoff timestamp to invalidate all orders whose timestamp
272     ///        is smaller than or equal to the new value of the address's cutoff
273     ///        timestamp.
274     /// @param cutoff The cutoff timestamp, will default to `block.timestamp`
275     ///        if it is 0.
276     function cancelAllOrders(uint cutoff) external;
277     /// @dev Submit a order-ring for validation and settlement.
278     /// @param addressList  List of each order's owner, tokenS, and authAddr.
279     ///                     Note that next order's `tokenS` equals this order's
280     ///                     `tokenB`.
281     /// @param uintArgsList List of uint-type arguments in this order:
282     ///                     amountS, amountB, validSince (second),
283     ///                     validUntil (second), lrcFee, rateAmountS, and walletId.
284     /// @param uint8ArgsList -
285     ///                     List of unit8-type arguments, in this order:
286     ///                     marginSplitPercentageList.
287     /// @param buyNoMoreThanAmountBList -
288     ///                     This indicates when a order should be considered
289     /// @param vList        List of v for each order. This list is 1-larger than
290     ///                     the previous lists, with the last element being the
291     ///                     v value of the ring signature.
292     /// @param rList        List of r for each order. This list is 1-larger than
293     ///                     the previous lists, with the last element being the
294     ///                     r value of the ring signature.
295     /// @param sList        List of s for each order. This list is 1-larger than
296     ///                     the previous lists, with the last element being the
297     ///                     s value of the ring signature.
298     /// @param minerId      The address pair that miner registered in NameRegistry.
299     ///                     The address pair contains a signer address and a fee
300     ///                     recipient address.
301     ///                     The signer address is used for sign this tx.
302     ///                     The Recipient address for fee collection. If this is
303     ///                     '0x0', all fees will be paid to the address who had
304     ///                     signed this transaction, not `msg.sender`. Noted if
305     ///                     LRC need to be paid back to order owner as the result
306     ///                     of fee selection model, LRC will also be sent from
307     ///                     this address.
308     /// @param feeSelections -
309     ///                     Bits to indicate fee selections. `1` represents margin
310     ///                     split and `0` represents LRC as fee.
311     function submitRing(
312         address[3][]    addressList,
313         uint[7][]       uintArgsList,
314         uint8[1][]      uint8ArgsList,
315         bool[]          buyNoMoreThanAmountBList,
316         uint8[]         vList,
317         bytes32[]       rList,
318         bytes32[]       sList,
319         uint            minerId,
320         uint16          feeSelections
321         ) public;
322 }
323 /*
324   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
325   Licensed under the Apache License, Version 2.0 (the "License");
326   you may not use this file except in compliance with the License.
327   You may obtain a copy of the License at
328   http://www.apache.org/licenses/LICENSE-2.0
329   Unless required by applicable law or agreed to in writing, software
330   distributed under the License is distributed on an "AS IS" BASIS,
331   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
332   See the License for the specific language governing permissions and
333   limitations under the License.
334 */
335 /// @title Ethereum Address Register Contract
336 /// @dev This contract maintains a name service for addresses and miner.
337 /// @author Kongliang Zhong - <kongliang@loopring.org>,
338 /// @author Daniel Wang - <daniel@loopring.org>,
339 contract NameRegistry {
340     uint public nextId = 0;
341     mapping (uint    => Participant) public participantMap;
342     mapping (address => NameInfo)    public nameInfoMap;
343     mapping (bytes12 => address)     public ownerMap;
344     mapping (address => string)      public nameMap;
345     struct NameInfo {
346         bytes12  name;
347         uint[]   participantIds;
348     }
349     struct Participant {
350         address feeRecipient;
351         address signer;
352         bytes12 name;
353         address owner;
354     }
355     event NameRegistered (
356         string            name,
357         address   indexed owner
358     );
359     event NameUnregistered (
360         string             name,
361         address    indexed owner
362     );
363     event OwnershipTransfered (
364         bytes12            name,
365         address            oldOwner,
366         address            newOwner
367     );
368     event ParticipantRegistered (
369         bytes12           name,
370         address   indexed owner,
371         uint      indexed participantId,
372         address           singer,
373         address           feeRecipient
374     );
375     event ParticipantUnregistered (
376         uint    participantId,
377         address owner
378     );
379     function registerName(string name)
380         external
381     {
382         require(isNameValid(name));
383         bytes12 nameBytes = stringToBytes12(name);
384         require(ownerMap[nameBytes] == 0x0);
385         require(stringToBytes12(nameMap[msg.sender]) == bytes12(0x0));
386         nameInfoMap[msg.sender] = NameInfo(nameBytes, new uint[](0));
387         ownerMap[nameBytes] = msg.sender;
388         nameMap[msg.sender] = name;
389         emit NameRegistered(name, msg.sender);
390     }
391     function unregisterName(string name)
392         external
393     {
394         NameInfo storage nameInfo = nameInfoMap[msg.sender];
395         uint[] storage participantIds = nameInfo.participantIds;
396         bytes12 nameBytes = stringToBytes12(name);
397         require(nameInfo.name == nameBytes);
398         for (uint i = 0; i < participantIds.length; i++) {
399             delete participantMap[participantIds[i]];
400         }
401         delete nameInfoMap[msg.sender];
402         delete nameMap[msg.sender];
403         delete ownerMap[nameBytes];
404         emit NameUnregistered(name, msg.sender);
405     }
406     function transferOwnership(address newOwner)
407         external
408     {
409         require(newOwner != 0x0);
410         require(nameInfoMap[newOwner].name.length == 0);
411         NameInfo storage nameInfo = nameInfoMap[msg.sender];
412         string storage name = nameMap[msg.sender];
413         uint[] memory participantIds = nameInfo.participantIds;
414         for (uint i = 0; i < participantIds.length; i ++) {
415             Participant storage p = participantMap[participantIds[i]];
416             p.owner = newOwner;
417         }
418         delete nameInfoMap[msg.sender];
419         delete nameMap[msg.sender];
420         nameInfoMap[newOwner] = nameInfo;
421         nameMap[newOwner] = name;
422         emit OwnershipTransfered(nameInfo.name, msg.sender, newOwner);
423     }
424     /* function addParticipant(address feeRecipient) */
425     /*     external */
426     /*     returns (uint) */
427     /* { */
428     /*     return addParticipant(feeRecipient, feeRecipient); */
429     /* } */
430     function addParticipant(
431         address feeRecipient,
432         address singer
433         )
434         external
435         returns (uint)
436     {
437         require(feeRecipient != 0x0 && singer != 0x0);
438         NameInfo storage nameInfo = nameInfoMap[msg.sender];
439         bytes12 name = nameInfo.name;
440         require(name.length > 0);
441         Participant memory participant = Participant(
442             feeRecipient,
443             singer,
444             name,
445             msg.sender
446         );
447         uint participantId = ++nextId;
448         participantMap[participantId] = participant;
449         nameInfo.participantIds.push(participantId);
450         emit ParticipantRegistered(
451             name,
452             msg.sender,
453             participantId,
454             singer,
455             feeRecipient
456         );
457         return participantId;
458     }
459     function removeParticipant(uint participantId)
460         external
461     {
462         require(msg.sender == participantMap[participantId].owner);
463         NameInfo storage nameInfo = nameInfoMap[msg.sender];
464         uint[] storage participantIds = nameInfo.participantIds;
465         delete participantMap[participantId];
466         uint len = participantIds.length;
467         for (uint i = 0; i < len; i ++) {
468             if (participantId == participantIds[i]) {
469                 participantIds[i] = participantIds[len - 1];
470                 participantIds.length -= 1;
471             }
472         }
473         emit ParticipantUnregistered(participantId, msg.sender);
474     }
475     function getParticipantById(uint id)
476         external
477         view
478         returns (address feeRecipient, address signer)
479     {
480         Participant storage addressSet = participantMap[id];
481         feeRecipient = addressSet.feeRecipient;
482         signer = addressSet.signer;
483     }
484     function getFeeRecipientById(uint id)
485         external
486         view
487         returns (address feeRecipient)
488     {
489         Participant storage addressSet = participantMap[id];
490         feeRecipient = addressSet.feeRecipient;
491     }
492     function getParticipantIds(string name, uint start, uint count)
493         external
494         view
495         returns (uint[] idList)
496     {
497         bytes12 nameBytes = stringToBytes12(name);
498         address owner = ownerMap[nameBytes];
499         require(owner != 0x0);
500         NameInfo storage nameInfo = nameInfoMap[owner];
501         uint[] storage pIds = nameInfo.participantIds;
502         uint len = pIds.length;
503         if (start >= len) {
504             return;
505         }
506         uint end = start + count;
507         if (end > len) {
508             end = len;
509         }
510         if (start == end) {
511             return;
512         }
513         idList = new uint[](end - start);
514         for (uint i = start; i < end; i ++) {
515             idList[i - start] = pIds[i];
516         }
517     }
518     function getOwner(string name)
519         external
520         view
521         returns (address)
522     {
523         bytes12 nameBytes = stringToBytes12(name);
524         return ownerMap[nameBytes];
525     }
526     function isNameValid(string name)
527         internal
528         pure
529         returns (bool)
530     {
531         bytes memory temp = bytes(name);
532         return temp.length >= 6 && temp.length <= 12;
533     }
534     function stringToBytes12(string str)
535         internal
536         pure
537         returns (bytes12 result)
538     {
539         assembly {
540             result := mload(add(str, 32))
541         }
542     }
543 }
544 /*
545   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
546   Licensed under the Apache License, Version 2.0 (the "License");
547   you may not use this file except in compliance with the License.
548   You may obtain a copy of the License at
549   http://www.apache.org/licenses/LICENSE-2.0
550   Unless required by applicable law or agreed to in writing, software
551   distributed under the License is distributed on an "AS IS" BASIS,
552   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
553   See the License for the specific language governing permissions and
554   limitations under the License.
555 */
556 /*
557   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
558   Licensed under the Apache License, Version 2.0 (the "License");
559   you may not use this file except in compliance with the License.
560   You may obtain a copy of the License at
561   http://www.apache.org/licenses/LICENSE-2.0
562   Unless required by applicable law or agreed to in writing, software
563   distributed under the License is distributed on an "AS IS" BASIS,
564   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
565   See the License for the specific language governing permissions and
566   limitations under the License.
567 */
568 /*
569   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
570   Licensed under the Apache License, Version 2.0 (the "License");
571   you may not use this file except in compliance with the License.
572   You may obtain a copy of the License at
573   http://www.apache.org/licenses/LICENSE-2.0
574   Unless required by applicable law or agreed to in writing, software
575   distributed under the License is distributed on an "AS IS" BASIS,
576   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
577   See the License for the specific language governing permissions and
578   limitations under the License.
579 */
580 /// @title Ownable
581 /// @dev The Ownable contract has an owner address, and provides basic
582 ///      authorization control functions, this simplifies the implementation of
583 ///      "user permissions".
584 contract Ownable {
585     address public owner;
586     event OwnershipTransferred(
587         address indexed previousOwner,
588         address indexed newOwner
589     );
590     /// @dev The Ownable constructor sets the original `owner` of the contract
591     ///      to the sender.
592     function Ownable() public {
593         owner = msg.sender;
594     }
595     /// @dev Throws if called by any account other than the owner.
596     modifier onlyOwner() {
597         require(msg.sender == owner);
598         _;
599     }
600     /// @dev Allows the current owner to transfer control of the contract to a
601     ///      newOwner.
602     /// @param newOwner The address to transfer ownership to.
603     function transferOwnership(address newOwner) onlyOwner public {
604         require(newOwner != 0x0);
605         emit OwnershipTransferred(owner, newOwner);
606         owner = newOwner;
607     }
608 }
609 /// @title Claimable
610 /// @dev Extension for the Ownable contract, where the ownership needs
611 ///      to be claimed. This allows the new owner to accept the transfer.
612 contract Claimable is Ownable {
613     address public pendingOwner;
614     /// @dev Modifier throws if called by any account other than the pendingOwner.
615     modifier onlyPendingOwner() {
616         require(msg.sender == pendingOwner);
617         _;
618     }
619     /// @dev Allows the current owner to set the pendingOwner address.
620     /// @param newOwner The address to transfer ownership to.
621     function transferOwnership(address newOwner) onlyOwner public {
622         require(newOwner != 0x0 && newOwner != owner);
623         pendingOwner = newOwner;
624     }
625     /// @dev Allows the pendingOwner address to finalize the transfer.
626     function claimOwnership() onlyPendingOwner public {
627         emit OwnershipTransferred(owner, pendingOwner);
628         owner = pendingOwner;
629         pendingOwner = 0x0;
630     }
631 }
632 /// @title Token Register Contract
633 /// @dev This contract maintains a list of tokens the Protocol supports.
634 /// @author Kongliang Zhong - <kongliang@loopring.org>,
635 /// @author Daniel Wang - <daniel@loopring.org>.
636 contract TokenRegistry is Claimable {
637     using AddressUtil for address;
638     address tokenMintAddr;
639     address[] public addresses;
640     mapping (address => TokenInfo) addressMap;
641     mapping (string => address) symbolMap;
642     ////////////////////////////////////////////////////////////////////////////
643     /// Structs                                                              ///
644     ////////////////////////////////////////////////////////////////////////////
645     struct TokenInfo {
646         uint   pos;      // 0 mens unregistered; if > 0, pos + 1 is the
647                          // token's position in `addresses`.
648         string symbol;   // Symbol of the token
649     }
650     ////////////////////////////////////////////////////////////////////////////
651     /// Events                                                               ///
652     ////////////////////////////////////////////////////////////////////////////
653     event TokenRegistered(address addr, string symbol);
654     event TokenUnregistered(address addr, string symbol);
655     ////////////////////////////////////////////////////////////////////////////
656     /// Public Functions                                                     ///
657     ////////////////////////////////////////////////////////////////////////////
658     /// @dev Disable default function.
659     function () payable public {
660         revert();
661     }
662     function TokenRegistry(address _tokenMintAddr) public
663     {
664         require(_tokenMintAddr.isContract());
665         tokenMintAddr = _tokenMintAddr;
666     }
667     function registerToken(
668         address addr,
669         string  symbol
670         )
671         external
672         onlyOwner
673     {
674         registerTokenInternal(addr, symbol);
675     }
676     function registerMintedToken(
677         address addr,
678         string  symbol
679         )
680         external
681     {
682         require(msg.sender == tokenMintAddr);
683         registerTokenInternal(addr, symbol);
684     }
685     function unregisterToken(
686         address addr,
687         string  symbol
688         )
689         external
690         onlyOwner
691     {
692         require(addr != 0x0);
693         require(symbolMap[symbol] == addr);
694         delete symbolMap[symbol];
695         uint pos = addressMap[addr].pos;
696         require(pos != 0);
697         delete addressMap[addr];
698         // We will replace the token we need to unregister with the last token
699         // Only the pos of the last token will need to be updated
700         address lastToken = addresses[addresses.length - 1];
701         // Don't do anything if the last token is the one we want to delete
702         if (addr != lastToken) {
703             // Swap with the last token and update the pos
704             addresses[pos - 1] = lastToken;
705             addressMap[lastToken].pos = pos;
706         }
707         addresses.length--;
708         emit TokenUnregistered(addr, symbol);
709     }
710     function areAllTokensRegistered(address[] addressList)
711         external
712         view
713         returns (bool)
714     {
715         for (uint i = 0; i < addressList.length; i++) {
716             if (addressMap[addressList[i]].pos == 0) {
717                 return false;
718             }
719         }
720         return true;
721     }
722     function getAddressBySymbol(string symbol)
723         external
724         view
725         returns (address)
726     {
727         return symbolMap[symbol];
728     }
729     function isTokenRegisteredBySymbol(string symbol)
730         public
731         view
732         returns (bool)
733     {
734         return symbolMap[symbol] != 0x0;
735     }
736     function isTokenRegistered(address addr)
737         public
738         view
739         returns (bool)
740     {
741         return addressMap[addr].pos != 0;
742     }
743     function getTokens(
744         uint start,
745         uint count
746         )
747         public
748         view
749         returns (address[] addressList)
750     {
751         uint num = addresses.length;
752         if (start >= num) {
753             return;
754         }
755         uint end = start + count;
756         if (end > num) {
757             end = num;
758         }
759         if (start == num) {
760             return;
761         }
762         addressList = new address[](end - start);
763         for (uint i = start; i < end; i++) {
764             addressList[i - start] = addresses[i];
765         }
766     }
767     function registerTokenInternal(
768         address addr,
769         string  symbol
770         )
771         internal
772     {
773         require(0x0 != addr);
774         require(bytes(symbol).length > 0);
775         require(0x0 == symbolMap[symbol]);
776         require(0 == addressMap[addr].pos);
777         addresses.push(addr);
778         symbolMap[symbol] = addr;
779         addressMap[addr] = TokenInfo(addresses.length, symbol);
780         emit TokenRegistered(addr, symbol);
781     }
782 }
783 /*
784   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
785   Licensed under the Apache License, Version 2.0 (the "License");
786   you may not use this file except in compliance with the License.
787   You may obtain a copy of the License at
788   http://www.apache.org/licenses/LICENSE-2.0
789   Unless required by applicable law or agreed to in writing, software
790   distributed under the License is distributed on an "AS IS" BASIS,
791   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
792   See the License for the specific language governing permissions and
793   limitations under the License.
794 */
795 /// @title TokenTransferDelegate
796 /// @dev Acts as a middle man to transfer ERC20 tokens on behalf of different
797 /// versions of Loopring protocol to avoid ERC20 re-authorization.
798 /// @author Daniel Wang - <daniel@loopring.org>.
799 contract TokenTransferDelegate is Claimable {
800     using MathUint for uint;
801     ////////////////////////////////////////////////////////////////////////////
802     /// Variables                                                            ///
803     ////////////////////////////////////////////////////////////////////////////
804     mapping(address => AddressInfo) private addressInfos;
805     address public latestAddress;
806     ////////////////////////////////////////////////////////////////////////////
807     /// Structs                                                              ///
808     ////////////////////////////////////////////////////////////////////////////
809     struct AddressInfo {
810         address previous;
811         uint32  index;
812         bool    authorized;
813     }
814     ////////////////////////////////////////////////////////////////////////////
815     /// Modifiers                                                            ///
816     ////////////////////////////////////////////////////////////////////////////
817     modifier onlyAuthorized() {
818         require(addressInfos[msg.sender].authorized);
819         _;
820     }
821     ////////////////////////////////////////////////////////////////////////////
822     /// Events                                                               ///
823     ////////////////////////////////////////////////////////////////////////////
824     event AddressAuthorized(address indexed addr, uint32 number);
825     event AddressDeauthorized(address indexed addr, uint32 number);
826     ////////////////////////////////////////////////////////////////////////////
827     /// Public Functions                                                     ///
828     ////////////////////////////////////////////////////////////////////////////
829     /// @dev Disable default function.
830     function () payable public {
831         revert();
832     }
833     /// @dev Add a Loopring protocol address.
834     /// @param addr A loopring protocol address.
835     function authorizeAddress(address addr)
836         onlyOwner
837         external
838     {
839         AddressInfo storage addrInfo = addressInfos[addr];
840         if (addrInfo.index != 0) { // existing
841             if (addrInfo.authorized == false) { // re-authorize
842                 addrInfo.authorized = true;
843                 emit AddressAuthorized(addr, addrInfo.index);
844             }
845         } else {
846             address prev = latestAddress;
847             if (prev == 0x0) {
848                 addrInfo.index = 1;
849                 addrInfo.authorized = true;
850             } else {
851                 addrInfo.previous = prev;
852                 addrInfo.index = addressInfos[prev].index + 1;
853             }
854             addrInfo.authorized = true;
855             latestAddress = addr;
856             emit AddressAuthorized(addr, addrInfo.index);
857         }
858     }
859     /// @dev Remove a Loopring protocol address.
860     /// @param addr A loopring protocol address.
861     function deauthorizeAddress(address addr)
862         onlyOwner
863         external
864     {
865         uint32 index = addressInfos[addr].index;
866         if (index != 0) {
867             addressInfos[addr].authorized = false;
868             emit AddressDeauthorized(addr, index);
869         }
870     }
871     function getLatestAuthorizedAddresses(uint max)
872         external
873         view
874         returns (address[] addresses)
875     {
876         addresses = new address[](max);
877         address addr = latestAddress;
878         AddressInfo memory addrInfo;
879         uint count = 0;
880         while (addr != 0x0 && count < max) {
881             addrInfo = addressInfos[addr];
882             if (addrInfo.index == 0) {
883                 break;
884             }
885             addresses[count++] = addr;
886             addr = addrInfo.previous;
887         }
888     }
889     /// @dev Invoke ERC20 transferFrom method.
890     /// @param token Address of token to transfer.
891     /// @param from Address to transfer token from.
892     /// @param to Address to transfer token to.
893     /// @param value Amount of token to transfer.
894     function transferToken(
895         address token,
896         address from,
897         address to,
898         uint    value)
899         onlyAuthorized
900         external
901     {
902         if (value > 0 && from != to && to != 0x0) {
903             require(
904                 ERC20(token).transferFrom(from, to, value)
905             );
906         }
907     }
908     function batchTransferToken(
909         address lrcTokenAddress,
910         address minerFeeRecipient,
911         uint8 walletSplitPercentage,
912         bytes32[] batch)
913         onlyAuthorized
914         external
915     {
916         uint len = batch.length;
917         require(len % 7 == 0);
918         require(walletSplitPercentage > 0 && walletSplitPercentage < 100);
919         ERC20 lrc = ERC20(lrcTokenAddress);
920         for (uint i = 0; i < len; i += 7) {
921             address owner = address(batch[i]);
922             address prevOwner = address(batch[(i + len - 7) % len]);
923             // Pay token to previous order, or to miner as previous order's
924             // margin split or/and this order's margin split.
925             ERC20 token = ERC20(address(batch[i + 1]));
926             // Here batch[i + 2] has been checked not to be 0.
927             if (owner != prevOwner) {
928                 require(
929                     token.transferFrom(
930                         owner,
931                         prevOwner,
932                         uint(batch[i + 2])
933                     )
934                 );
935             }
936             // Miner pays LRx fee to order owner
937             uint lrcReward = uint(batch[i + 4]);
938             if (lrcReward != 0 && minerFeeRecipient != owner) {
939                 require(
940                     lrc.transferFrom(
941                         minerFeeRecipient,
942                         owner,
943                         lrcReward
944                     )
945                 );
946             }
947             // Split margin-split income between miner and wallet
948             splitPayFee(
949                 token,
950                 uint(batch[i + 3]),
951                 owner,
952                 minerFeeRecipient,
953                 address(batch[i + 6]),
954                 walletSplitPercentage
955             );
956             // Split LRx fee income between miner and wallet
957             splitPayFee(
958                 lrc,
959                 uint(batch[i + 5]),
960                 owner,
961                 minerFeeRecipient,
962                 address(batch[i + 6]),
963                 walletSplitPercentage
964             );
965         }
966     }
967     function isAddressAuthorized(address addr)
968         public
969         view
970         returns (bool)
971     {
972         return addressInfos[addr].authorized;
973     }
974     function splitPayFee(
975         ERC20   token,
976         uint    fee,
977         address owner,
978         address minerFeeRecipient,
979         address walletFeeRecipient,
980         uint    walletSplitPercentage
981         )
982         internal
983     {
984         if (fee == 0) {
985             return;
986         }
987         uint walletFee = (walletFeeRecipient == 0x0) ? 0 : fee.mul(walletSplitPercentage) / 100;
988         uint minerFee = fee - walletFee;
989         if (walletFee > 0 && walletFeeRecipient != owner) {
990             require(
991                 token.transferFrom(
992                     owner,
993                     walletFeeRecipient,
994                     walletFee
995                 )
996             );
997         }
998         if (minerFee > 0 && minerFeeRecipient != 0x0 && minerFeeRecipient != owner) {
999             require(
1000                 token.transferFrom(
1001                     owner,
1002                     minerFeeRecipient,
1003                     minerFee
1004                 )
1005             );
1006         }
1007     }
1008 }
1009 /// @title Loopring Token Exchange Protocol Implementation Contract
1010 /// @author Daniel Wang - <daniel@loopring.org>,
1011 /// @author Kongliang Zhong - <kongliang@loopring.org>
1012 ///
1013 /// Recognized contributing developers from the community:
1014 ///     https://github.com/Brechtpd
1015 ///     https://github.com/rainydio
1016 ///     https://github.com/BenjaminPrice
1017 ///     https://github.com/jonasshen
1018 contract LoopringProtocolImpl is LoopringProtocol {
1019     using AddressUtil   for address;
1020     using MathBytes32   for bytes32[];
1021     using MathUint      for uint;
1022     using MathUint8     for uint8[];
1023     ////////////////////////////////////////////////////////////////////////////
1024     /// Variables                                                            ///
1025     ////////////////////////////////////////////////////////////////////////////
1026     address public  lrcTokenAddress             = 0xEF68e7C694F40c8202821eDF525dE3782458639f;
1027     address public  tokenRegistryAddress        = 0xaD3407deDc56A1F69389Edc191b770F0c935Ea37;
1028     address public  delegateAddress             = 0x7b126ab811f278f288bf1d62d47334351dA20d1d;
1029     address public  nameRegistryAddress         = 0xC897816C1A6DB4A2923b7D75d9B812e2f62cF504;
1030     uint64  public  ringIndex                   = 0;
1031     uint8   public  walletSplitPercentage       = 20;
1032     // Exchange rate (rate) is the amount to sell or sold divided by the amount
1033     // to buy or bought.
1034     //
1035     // Rate ratio is the ratio between executed rate and an order's original
1036     // rate.
1037     //
1038     // To require all orders' rate ratios to have coefficient ofvariation (CV)
1039     // smaller than 2.5%, for an example , rateRatioCVSThreshold should be:
1040     //     `(0.025 * RATE_RATIO_SCALE)^2` or 62500.
1041     uint    public constant rateRatioCVSThreshold        = 62500;
1042 
1043     uint    public constant MAX_RING_SIZE       = 16;
1044     uint    public constant RATE_RATIO_SCALE    = 10000;
1045     uint64  public constant ENTERED_MASK        = 1 << 63;
1046     // The following map is used to keep trace of order fill and cancellation
1047     // history.
1048     mapping (bytes32 => uint) public cancelledOrFilled;
1049     // This map is used to keep trace of order's cancellation history.
1050     mapping (bytes32 => uint) public cancelled;
1051     // A map from address to its cutoff timestamp.
1052     mapping (address => uint) public cutoffs;
1053     // A map from address to its trading-pair cutoff timestamp.
1054     mapping (address => mapping (bytes20 => uint)) public tradingPairCutoffs;
1055     ////////////////////////////////////////////////////////////////////////////
1056     /// Structs                                                              ///
1057     ////////////////////////////////////////////////////////////////////////////
1058     struct Rate {
1059         uint amountS;
1060         uint amountB;
1061     }
1062     /// @param tokenS       Token to sell.
1063     /// @param tokenB       Token to buy.
1064     /// @param amountS      Maximum amount of tokenS to sell.
1065     /// @param amountB      Minimum amount of tokenB to buy if all amountS sold.
1066     /// @param authAddr     An address to verify miner has access to the order's
1067     ///                     auth private-key.
1068     /// @param validSince   Indicating when this order should be treated as
1069     ///                     valid for trading, in second.
1070     /// @param validUntil   Indicating when this order should be treated as
1071     ///                     expired, in second.
1072     /// @param lrcFee       Max amount of LRC to pay for miner. The real amount
1073     ///                     to pay is proportional to fill amount.
1074     /// @param buyNoMoreThanAmountB -
1075     ///                     If true, this order does not accept buying more
1076     ///                     than `amountB`.
1077     /// @param walletId     The id of the wallet that generated this order.
1078     /// @param marginSplitPercentage -
1079     ///                     The percentage of margin paid to miner.
1080     /// @param v            ECDSA signature parameter v.
1081     /// @param r            ECDSA signature parameters r.
1082     /// @param s            ECDSA signature parameters s.
1083     struct Order {
1084         address owner;
1085         address tokenS;
1086         address tokenB;
1087         address authAddr;
1088         uint    validSince;
1089         uint    validUntil;
1090         uint    amountS;
1091         uint    amountB;
1092         uint    lrcFee;
1093         bool    buyNoMoreThanAmountB;
1094         uint    walletId;
1095         uint8   marginSplitPercentage;
1096     }
1097     /// @param order        The original order
1098     /// @param orderHash    The order's hash
1099     /// @param feeSelection -
1100     ///                     A miner-supplied value indicating if LRC (value = 0)
1101     ///                     or margin split is choosen by the miner (value = 1).
1102     ///                     We may support more fee model in the future.
1103     /// @param rate         Exchange rate provided by miner.
1104     /// @param fillAmountS  Amount of tokenS to sell, calculated by protocol.
1105     /// @param lrcReward    The amount of LRC paid by miner to order owner in
1106     ///                     exchange for margin split.
1107     /// @param lrcFee       The amount of LR paid by order owner to miner.
1108     /// @param splitS      TokenS paid to miner.
1109     /// @param splitB      TokenB paid to miner.
1110     struct OrderState {
1111         Order   order;
1112         bytes32 orderHash;
1113         bool    marginSplitAsFee;
1114         Rate    rate;
1115         uint    fillAmountS;
1116         uint    lrcReward;
1117         uint    lrcFee;
1118         uint    splitS;
1119         uint    splitB;
1120     }
1121     /// @dev A struct to capture parameters passed to submitRing method and
1122     ///      various of other variables used across the submitRing core logics.
1123     struct RingParams {
1124         address[3][]  addressList;
1125         uint[7][]     uintArgsList;
1126         uint8[1][]    uint8ArgsList;
1127         bool[]        buyNoMoreThanAmountBList;
1128         uint8[]       vList;
1129         bytes32[]     rList;
1130         bytes32[]     sList;
1131         uint          minerId;
1132         uint          ringSize;         // computed
1133         uint16        feeSelections;
1134         address       ringMiner;        // queried
1135         address       feeRecipient;     // queried
1136         bytes32       ringHash;         // computed
1137     }
1138     ////////////////////////////////////////////////////////////////////////////
1139     /// Constructor                                                          ///
1140     ////////////////////////////////////////////////////////////////////////////
1141 
1142     ////////////////////////////////////////////////////////////////////////////
1143     /// Public Functions                                                     ///
1144     ////////////////////////////////////////////////////////////////////////////
1145     /// @dev Disable default function.
1146     function () payable public {
1147         revert();
1148     }
1149     function cancelOrder(
1150         address[4] addresses,
1151         uint[7]    orderValues,
1152         bool       buyNoMoreThanAmountB,
1153         uint8      marginSplitPercentage,
1154         uint8      v,
1155         bytes32    r,
1156         bytes32    s
1157         )
1158         external
1159     {
1160         uint cancelAmount = orderValues[6];
1161         require(cancelAmount > 0); // "amount to cancel is zero");
1162         Order memory order = Order(
1163             addresses[0],
1164             addresses[1],
1165             addresses[2],
1166             addresses[3],
1167             orderValues[2],
1168             orderValues[3],
1169             orderValues[0],
1170             orderValues[1],
1171             orderValues[4],
1172             buyNoMoreThanAmountB,
1173             orderValues[5],
1174             marginSplitPercentage
1175         );
1176         require(msg.sender == order.owner); // "cancelOrder not submitted by order owner");
1177         bytes32 orderHash = calculateOrderHash(order);
1178         verifySignature(
1179             order.owner,
1180             orderHash,
1181             v,
1182             r,
1183             s
1184         );
1185         cancelled[orderHash] = cancelled[orderHash].add(cancelAmount);
1186         cancelledOrFilled[orderHash] = cancelledOrFilled[orderHash].add(cancelAmount);
1187         emit OrderCancelled(orderHash, cancelAmount);
1188     }
1189     function cancelAllOrdersByTradingPair(
1190         address token1,
1191         address token2,
1192         uint    cutoff
1193         )
1194         external
1195     {
1196         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
1197         bytes20 tokenPair = bytes20(token1) ^ bytes20(token2);
1198         require(tradingPairCutoffs[msg.sender][tokenPair] < t); // "attempted to set cutoff to a smaller value"
1199         tradingPairCutoffs[msg.sender][tokenPair] = t;
1200         emit OrdersCancelled(
1201             msg.sender,
1202             token1,
1203             token2,
1204             t
1205         );
1206     }
1207     function cancelAllOrders(uint cutoff)
1208         external
1209     {
1210         uint t = (cutoff == 0 || cutoff >= block.timestamp) ? block.timestamp : cutoff;
1211         require(cutoffs[msg.sender] < t); // "attempted to set cutoff to a smaller value"
1212         cutoffs[msg.sender] = t;
1213         emit AllOrdersCancelled(msg.sender, t);
1214     }
1215     function submitRing(
1216         address[3][]  addressList,
1217         uint[7][]     uintArgsList,
1218         uint8[1][]    uint8ArgsList,
1219         bool[]        buyNoMoreThanAmountBList,
1220         uint8[]       vList,
1221         bytes32[]     rList,
1222         bytes32[]     sList,
1223         uint          minerId,
1224         uint16        feeSelections
1225         )
1226         public
1227     {
1228         // Check if the highest bit of ringIndex is '1'.
1229         require(ringIndex & ENTERED_MASK != ENTERED_MASK); // "attempted to re-ent submitRing function");
1230         // Set the highest bit of ringIndex to '1'.
1231         ringIndex |= ENTERED_MASK;
1232         RingParams memory params = RingParams(
1233             addressList,
1234             uintArgsList,
1235             uint8ArgsList,
1236             buyNoMoreThanAmountBList,
1237             vList,
1238             rList,
1239             sList,
1240             minerId,
1241             addressList.length,
1242             feeSelections,
1243             0x0,        // ringMiner
1244             0x0,        // feeRecipient
1245             0x0         // ringHash
1246         );
1247         verifyInputDataIntegrity(params);
1248         updateFeeRecipient(params);
1249         // Assemble input data into structs so we can pass them to other functions.
1250         // This method also calculates ringHash, therefore it must be called before
1251         // calling `verifyRingSignatures`.
1252         OrderState[] memory orders = assembleOrders(params);
1253         verifyRingSignatures(params);
1254         verifyTokensRegistered(params);
1255         handleRing(params, orders);
1256         ringIndex = (ringIndex ^ ENTERED_MASK) + 1;
1257     }
1258     ////////////////////////////////////////////////////////////////////////////
1259     /// Internal & Private Functions                                         ///
1260     ////////////////////////////////////////////////////////////////////////////
1261     /// @dev Validate a ring.
1262     function verifyRingHasNoSubRing(
1263         uint          ringSize,
1264         OrderState[]  orders
1265         )
1266         private
1267         pure
1268     {
1269         // Check the ring has no sub-ring.
1270         for (uint i = 0; i < ringSize - 1; i++) {
1271             address tokenS = orders[i].order.tokenS;
1272             for (uint j = i + 1; j < ringSize; j++) {
1273                 require(tokenS != orders[j].order.tokenS); // "found sub-ring");
1274             }
1275         }
1276     }
1277     /// @dev Verify the ringHash has been signed with each order's auth private
1278     ///      keys as well as the miner's private key.
1279     function verifyRingSignatures(RingParams params)
1280         private
1281         pure
1282     {
1283         uint j;
1284         for (uint i = 0; i < params.ringSize; i++) {
1285             j = i + params.ringSize;
1286             verifySignature(
1287                 params.addressList[i][2],  // authAddr
1288                 params.ringHash,
1289                 params.vList[j],
1290                 params.rList[j],
1291                 params.sList[j]
1292             );
1293         }
1294         if (params.ringMiner != 0x0) {
1295             j++;
1296             verifySignature(
1297                 params.ringMiner,
1298                 params.ringHash,
1299                 params.vList[j],
1300                 params.rList[j],
1301                 params.sList[j]
1302             );
1303         }
1304     }
1305     function verifyTokensRegistered(RingParams params)
1306         private
1307         view
1308     {
1309         // Extract the token addresses
1310         address[] memory tokens = new address[](params.ringSize);
1311         for (uint i = 0; i < params.ringSize; i++) {
1312             tokens[i] = params.addressList[i][1];
1313         }
1314         // Test all token addresses at once
1315         require(
1316             TokenRegistry(tokenRegistryAddress).areAllTokensRegistered(tokens)
1317         ); // "token not registered");
1318     }
1319     function updateFeeRecipient(RingParams params)
1320         private
1321         view
1322     {
1323         if (params.minerId == 0) {
1324             params.feeRecipient = msg.sender;
1325         } else {
1326             (params.feeRecipient, params.ringMiner) = NameRegistry(
1327                 nameRegistryAddress
1328             ).getParticipantById(
1329                 params.minerId
1330             );
1331             if (params.feeRecipient == 0x0) {
1332                 params.feeRecipient = msg.sender;
1333             }
1334         }
1335         uint sigSize = params.ringSize * 2;
1336         if (params.ringMiner != 0x0) {
1337             sigSize += 1;
1338         }
1339         require(sigSize == params.vList.length); // "ring data is inconsistent - vList");
1340         require(sigSize == params.rList.length); // "ring data is inconsistent - rList");
1341         require(sigSize == params.sList.length); // "ring data is inconsistent - sList");
1342     }
1343     function handleRing(
1344         RingParams    params,
1345         OrderState[]  orders
1346         )
1347         private
1348     {
1349         uint64 _ringIndex = ringIndex ^ ENTERED_MASK;
1350         address _lrcTokenAddress = lrcTokenAddress;
1351         TokenTransferDelegate delegate = TokenTransferDelegate(delegateAddress);
1352         // Do the hard work.
1353         verifyRingHasNoSubRing(params.ringSize, orders);
1354         // Exchange rates calculation are performed by ring-miners as solidity
1355         // cannot get power-of-1/n operation, therefore we have to verify
1356         // these rates are correct.
1357         verifyMinerSuppliedFillRates(params.ringSize, orders);
1358         // Scale down each order independently by substracting amount-filled and
1359         // amount-cancelled. Order owner's current balance and allowance are
1360         // not taken into consideration in these operations.
1361         scaleRingBasedOnHistoricalRecords(delegate, params.ringSize, orders);
1362         // Based on the already verified exchange rate provided by ring-miners,
1363         // we can furthur scale down orders based on token balance and allowance,
1364         // then find the smallest order of the ring, then calculate each order's
1365         // `fillAmountS`.
1366         calculateRingFillAmount(params.ringSize, orders);
1367         // Calculate each order's `lrcFee` and `lrcRewrard` and splict how much
1368         // of `fillAmountS` shall be paid to matching order or miner as margin
1369         // split.
1370         calculateRingFees(
1371             delegate,
1372             params.ringSize,
1373             orders,
1374             params.feeRecipient,
1375             _lrcTokenAddress
1376         );
1377         /// Make transfers.
1378         bytes32[] memory orderHashList;
1379         uint[6][] memory amountsList;
1380         (orderHashList, amountsList) = settleRing(
1381             delegate,
1382             params.ringSize,
1383             orders,
1384             params.feeRecipient,
1385             _lrcTokenAddress
1386         );
1387         emit RingMined(
1388             _ringIndex,
1389             params.ringHash,
1390             params.ringMiner,
1391             params.feeRecipient,
1392             orderHashList,
1393             amountsList
1394         );
1395     }
1396     function settleRing(
1397         TokenTransferDelegate delegate,
1398         uint          ringSize,
1399         OrderState[]  orders,
1400         address       feeRecipient,
1401         address       _lrcTokenAddress
1402         )
1403         private
1404         returns (
1405         bytes32[] memory orderHashList,
1406         uint[6][] memory amountsList)
1407     {
1408         bytes32[] memory batch = new bytes32[](ringSize * 7); // ringSize * (owner + tokenS + 4 amounts + walletAddrress)
1409         orderHashList = new bytes32[](ringSize);
1410         amountsList = new uint[6][](ringSize);
1411         uint p = 0;
1412         for (uint i = 0; i < ringSize; i++) {
1413             OrderState memory state = orders[i];
1414             Order memory order = state.order;
1415             uint prevSplitB = orders[(i + ringSize - 1) % ringSize].splitB;
1416             uint nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1417             // Store owner and tokenS of every order
1418             batch[p] = bytes32(order.owner);
1419             batch[p + 1] = bytes32(order.tokenS);
1420             // Store all amounts
1421             batch[p + 2] = bytes32(state.fillAmountS - prevSplitB);
1422             batch[p + 3] = bytes32(prevSplitB + state.splitS);
1423             batch[p + 4] = bytes32(state.lrcReward);
1424             batch[p + 5] = bytes32(state.lrcFee);
1425             if (order.walletId != 0) {
1426                 batch[p + 6] = bytes32(NameRegistry(nameRegistryAddress).getFeeRecipientById(order.walletId));
1427             } else {
1428                 batch[p + 6] = bytes32(0x0);
1429             }
1430             p += 7;
1431             // Update fill records
1432             if (order.buyNoMoreThanAmountB) {
1433                 cancelledOrFilled[state.orderHash] += nextFillAmountS;
1434             } else {
1435                 cancelledOrFilled[state.orderHash] += state.fillAmountS;
1436             }
1437             orderHashList[i] = state.orderHash;
1438             amountsList[i][0] = state.fillAmountS + state.splitS;
1439             amountsList[i][1] = nextFillAmountS - state.splitB;
1440             amountsList[i][2] = state.lrcReward;
1441             amountsList[i][3] = state.lrcFee;
1442             amountsList[i][4] = state.splitS;
1443             amountsList[i][5] = state.splitB;
1444         }
1445         // Do all transactions
1446         delegate.batchTransferToken(
1447             _lrcTokenAddress,
1448             feeRecipient,
1449             walletSplitPercentage,
1450             batch
1451         );
1452     }
1453     /// @dev Verify miner has calculte the rates correctly.
1454     function verifyMinerSuppliedFillRates(
1455         uint          ringSize,
1456         OrderState[]  orders
1457         )
1458         private
1459         view
1460     {
1461         uint[] memory rateRatios = new uint[](ringSize);
1462         uint _rateRatioScale = RATE_RATIO_SCALE;
1463         for (uint i = 0; i < ringSize; i++) {
1464             uint s1b0 = orders[i].rate.amountS.mul(orders[i].order.amountB);
1465             uint s0b1 = orders[i].order.amountS.mul(orders[i].rate.amountB);
1466             require(s1b0 <= s0b1); // "miner supplied exchange rate provides invalid discount");
1467             rateRatios[i] = _rateRatioScale.mul(s1b0) / s0b1;
1468         }
1469         uint cvs = MathUint.cvsquare(rateRatios, _rateRatioScale);
1470         require(cvs <= rateRatioCVSThreshold); // "miner supplied exchange rate is not evenly discounted");
1471     }
1472     /// @dev Calculate each order's fee or LRC reward.
1473     function calculateRingFees(
1474         TokenTransferDelegate delegate,
1475         uint            ringSize,
1476         OrderState[]    orders,
1477         address         feeRecipient,
1478         address         _lrcTokenAddress
1479         )
1480         private
1481         view
1482     {
1483         bool checkedMinerLrcSpendable = false;
1484         uint minerLrcSpendable = 0;
1485         uint8 _marginSplitPercentageBase = MARGIN_SPLIT_PERCENTAGE_BASE;
1486         uint nextFillAmountS;
1487         for (uint i = 0; i < ringSize; i++) {
1488             OrderState memory state = orders[i];
1489             uint lrcReceiable = 0;
1490             if (state.lrcFee == 0) {
1491                 // When an order's LRC fee is 0 or smaller than the specified fee,
1492                 // we help miner automatically select margin-split.
1493                 state.marginSplitAsFee = true;
1494                 state.order.marginSplitPercentage = _marginSplitPercentageBase;
1495             } else {
1496                 uint lrcSpendable = getSpendable(
1497                     delegate,
1498                     _lrcTokenAddress,
1499                     state.order.owner
1500                 );
1501                 // If the order is selling LRC, we need to calculate how much LRC
1502                 // is left that can be used as fee.
1503                 if (state.order.tokenS == _lrcTokenAddress) {
1504                     lrcSpendable -= state.fillAmountS;
1505                 }
1506                 // If the order is buyign LRC, it will has more to pay as fee.
1507                 if (state.order.tokenB == _lrcTokenAddress) {
1508                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1509                     lrcReceiable = nextFillAmountS;
1510                 }
1511                 uint lrcTotal = lrcSpendable + lrcReceiable;
1512                 // If order doesn't have enough LRC, set margin split to 100%.
1513                 if (lrcTotal < state.lrcFee) {
1514                     state.lrcFee = lrcTotal;
1515                     state.order.marginSplitPercentage = _marginSplitPercentageBase;
1516                 }
1517                 if (state.lrcFee == 0) {
1518                     state.marginSplitAsFee = true;
1519                 }
1520             }
1521             if (!state.marginSplitAsFee) {
1522                 if (lrcReceiable > 0) {
1523                     if (lrcReceiable >= state.lrcFee) {
1524                         state.splitB = state.lrcFee;
1525                         state.lrcFee = 0;
1526                     } else {
1527                         state.splitB = lrcReceiable;
1528                         state.lrcFee -= lrcReceiable;
1529                     }
1530                 }
1531             } else {
1532                 // Only check the available miner balance when absolutely needed
1533                 if (!checkedMinerLrcSpendable && minerLrcSpendable < state.lrcFee) {
1534                     checkedMinerLrcSpendable = true;
1535                     minerLrcSpendable = getSpendable(delegate, _lrcTokenAddress, feeRecipient);
1536                 }
1537                 // Only calculate split when miner has enough LRC;
1538                 // otherwise all splits are 0.
1539                 if (minerLrcSpendable >= state.lrcFee) {
1540                     nextFillAmountS = orders[(i + 1) % ringSize].fillAmountS;
1541                     uint split;
1542                     if (state.order.buyNoMoreThanAmountB) {
1543                         split = (nextFillAmountS.mul(
1544                             state.order.amountS
1545                         ) / state.order.amountB).sub(
1546                             state.fillAmountS
1547                         );
1548                     } else {
1549                         split = nextFillAmountS.sub(
1550                             state.fillAmountS.mul(
1551                                 state.order.amountB
1552                             ) / state.order.amountS
1553                         );
1554                     }
1555                     if (state.order.marginSplitPercentage != _marginSplitPercentageBase) {
1556                         split = split.mul(
1557                             state.order.marginSplitPercentage
1558                         ) / _marginSplitPercentageBase;
1559                     }
1560                     if (state.order.buyNoMoreThanAmountB) {
1561                         state.splitS = split;
1562                     } else {
1563                         state.splitB = split;
1564                     }
1565                     // This implicits order with smaller index in the ring will
1566                     // be paid LRC reward first, so the orders in the ring does
1567                     // mater.
1568                     if (split > 0) {
1569                         minerLrcSpendable -= state.lrcFee;
1570                         state.lrcReward = state.lrcFee;
1571                     }
1572                 }
1573                 state.lrcFee = 0;
1574             }
1575         }
1576     }
1577     /// @dev Calculate each order's fill amount.
1578     function calculateRingFillAmount(
1579         uint          ringSize,
1580         OrderState[]  orders
1581         )
1582         private
1583         pure
1584     {
1585         uint smallestIdx = 0;
1586         uint i;
1587         uint j;
1588         for (i = 0; i < ringSize; i++) {
1589             j = (i + 1) % ringSize;
1590             smallestIdx = calculateOrderFillAmount(
1591                 orders[i],
1592                 orders[j],
1593                 i,
1594                 j,
1595                 smallestIdx
1596             );
1597         }
1598         for (i = 0; i < smallestIdx; i++) {
1599             calculateOrderFillAmount(
1600                 orders[i],
1601                 orders[(i + 1) % ringSize],
1602                 0,               // Not needed
1603                 0,               // Not needed
1604                 0                // Not needed
1605             );
1606         }
1607     }
1608     /// @return The smallest order's index.
1609     function calculateOrderFillAmount(
1610         OrderState        state,
1611         OrderState        next,
1612         uint              i,
1613         uint              j,
1614         uint              smallestIdx
1615         )
1616         private
1617         pure
1618         returns (uint newSmallestIdx)
1619     {
1620         // Default to the same smallest index
1621         newSmallestIdx = smallestIdx;
1622         uint fillAmountB = state.fillAmountS.mul(
1623             state.rate.amountB
1624         ) / state.rate.amountS;
1625         if (state.order.buyNoMoreThanAmountB) {
1626             if (fillAmountB > state.order.amountB) {
1627                 fillAmountB = state.order.amountB;
1628                 state.fillAmountS = fillAmountB.mul(
1629                     state.rate.amountS
1630                 ) / state.rate.amountB;
1631                 newSmallestIdx = i;
1632             }
1633             state.lrcFee = state.order.lrcFee.mul(
1634                 fillAmountB
1635             ) / state.order.amountB;
1636         } else {
1637             state.lrcFee = state.order.lrcFee.mul(
1638                 state.fillAmountS
1639             ) / state.order.amountS;
1640         }
1641         if (fillAmountB <= next.fillAmountS) {
1642             next.fillAmountS = fillAmountB;
1643         } else {
1644             newSmallestIdx = j;
1645         }
1646     }
1647     /// @dev Scale down all orders based on historical fill or cancellation
1648     ///      stats but key the order's original exchange rate.
1649     function scaleRingBasedOnHistoricalRecords(
1650         TokenTransferDelegate delegate,
1651         uint ringSize,
1652         OrderState[] orders
1653         )
1654         private
1655         view
1656     {
1657         for (uint i = 0; i < ringSize; i++) {
1658             OrderState memory state = orders[i];
1659             Order memory order = state.order;
1660             uint amount;
1661             if (order.buyNoMoreThanAmountB) {
1662                 amount = order.amountB.tolerantSub(
1663                     cancelledOrFilled[state.orderHash]
1664                 );
1665                 order.amountS = amount.mul(order.amountS) / order.amountB;
1666                 order.lrcFee = amount.mul(order.lrcFee) / order.amountB;
1667                 order.amountB = amount;
1668             } else {
1669                 amount = order.amountS.tolerantSub(
1670                     cancelledOrFilled[state.orderHash]
1671                 );
1672                 order.amountB = amount.mul(order.amountB) / order.amountS;
1673                 order.lrcFee = amount.mul(order.lrcFee) / order.amountS;
1674                 order.amountS = amount;
1675             }
1676             require(order.amountS > 0); // "amountS is zero");
1677             require(order.amountB > 0); // "amountB is zero");
1678             uint availableAmountS = getSpendable(delegate, order.tokenS, order.owner);
1679             require(availableAmountS > 0); // "order spendable amountS is zero");
1680             state.fillAmountS = (
1681                 order.amountS < availableAmountS ?
1682                 order.amountS : availableAmountS
1683             );
1684         }
1685     }
1686     /// @return Amount of ERC20 token that can be spent by this contract.
1687     function getSpendable(
1688         TokenTransferDelegate delegate,
1689         address tokenAddress,
1690         address tokenOwner
1691         )
1692         private
1693         view
1694         returns (uint)
1695     {
1696         ERC20 token = ERC20(tokenAddress);
1697         uint allowance = token.allowance(
1698             tokenOwner,
1699             address(delegate)
1700         );
1701         uint balance = token.balanceOf(tokenOwner);
1702         return (allowance < balance ? allowance : balance);
1703     }
1704     /// @dev verify input data's basic integrity.
1705     function verifyInputDataIntegrity(RingParams params)
1706         private
1707         pure
1708     {
1709         require(params.ringSize == params.addressList.length); // "ring data is inconsistent - addressList");
1710         require(params.ringSize == params.uintArgsList.length); // "ring data is inconsistent - uintArgsList");
1711         require(params.ringSize == params.uint8ArgsList.length); // "ring data is inconsistent - uint8ArgsList");
1712         require(params.ringSize == params.buyNoMoreThanAmountBList.length); // "ring data is inconsistent - buyNoMoreThanAmountBList");
1713         // Validate ring-mining related arguments.
1714         for (uint i = 0; i < params.ringSize; i++) {
1715             require(params.uintArgsList[i][5] > 0); // "order rateAmountS is zero");
1716         }
1717         //Check ring size
1718         require(params.ringSize > 1 && params.ringSize <= MAX_RING_SIZE); // "invalid ring size");
1719     }
1720     /// @dev        assmble order parameters into Order struct.
1721     /// @return     A list of orders.
1722     function assembleOrders(RingParams params)
1723         private
1724         view
1725         returns (OrderState[] memory orders)
1726     {
1727         orders = new OrderState[](params.ringSize);
1728         for (uint i = 0; i < params.ringSize; i++) {
1729             Order memory order = Order(
1730                 params.addressList[i][0],
1731                 params.addressList[i][1],
1732                 params.addressList[(i + 1) % params.ringSize][1],
1733                 params.addressList[i][2],
1734                 params.uintArgsList[i][2],
1735                 params.uintArgsList[i][3],
1736                 params.uintArgsList[i][0],
1737                 params.uintArgsList[i][1],
1738                 params.uintArgsList[i][4],
1739                 params.buyNoMoreThanAmountBList[i],
1740                 params.uintArgsList[i][6],
1741                 params.uint8ArgsList[i][0]
1742             );
1743             validateOrder(order);
1744             bytes32 orderHash = calculateOrderHash(order);
1745             verifySignature(
1746                 order.owner,
1747                 orderHash,
1748                 params.vList[i],
1749                 params.rList[i],
1750                 params.sList[i]
1751             );
1752             bool marginSplitAsFee = (params.feeSelections & (uint16(1) << i)) > 0;
1753             orders[i] = OrderState(
1754                 order,
1755                 orderHash,
1756                 marginSplitAsFee,
1757                 Rate(params.uintArgsList[i][5], order.amountB),
1758                 0,   // fillAmountS
1759                 0,   // lrcReward
1760                 0,   // lrcFee
1761                 0,   // splitS
1762                 0    // splitB
1763             );
1764             params.ringHash ^= orderHash;
1765         }
1766         params.ringHash = keccak256(
1767             params.ringHash,
1768             params.minerId,
1769             params.feeSelections
1770         );
1771     }
1772     /// @dev validate order's parameters are OK.
1773     function validateOrder(Order order)
1774         private
1775         view
1776     {
1777         require(order.owner != 0x0); // invalid order owner
1778         require(order.tokenS != 0x0); // invalid order tokenS
1779         require(order.tokenB != 0x0); // invalid order tokenB
1780         require(order.amountS != 0); // invalid order amountS
1781         require(order.amountB != 0); // invalid order amountB
1782         require(order.marginSplitPercentage <= MARGIN_SPLIT_PERCENTAGE_BASE); // invalid order marginSplitPercentage
1783         require(order.validSince <= block.timestamp); // order is too early to match
1784         require(order.validUntil > block.timestamp); // order is expired
1785         bytes20 tradingPair = bytes20(order.tokenS) ^ bytes20(order.tokenB);
1786         require(order.validSince > tradingPairCutoffs[order.owner][tradingPair]); // order trading pair is cut off
1787         require(order.validSince > cutoffs[order.owner]); // order is cut off
1788     }
1789     /// @dev Get the Keccak-256 hash of order with specified parameters.
1790     function calculateOrderHash(Order order)
1791         private
1792         view
1793         returns (bytes32)
1794     {
1795         return keccak256(
1796             address(this),
1797             order.owner,
1798             order.tokenS,
1799             order.tokenB,
1800             order.authAddr,
1801             order.amountS,
1802             order.amountB,
1803             order.validSince,
1804             order.validUntil,
1805             order.lrcFee,
1806             order.buyNoMoreThanAmountB,
1807             order.walletId,
1808             order.marginSplitPercentage
1809         );
1810     }
1811     /// @dev Verify signer's signature.
1812     function verifySignature(
1813         address signer,
1814         bytes32 hash,
1815         uint8   v,
1816         bytes32 r,
1817         bytes32 s
1818         )
1819         private
1820         pure
1821     {
1822         require(
1823             signer == ecrecover(
1824                 keccak256("\x19Ethereum Signed Message:\n32", hash),
1825                 v,
1826                 r,
1827                 s
1828             )
1829         ); // "invalid signature");
1830     }
1831     function getTradingPairCutoffs(address orderOwner, address token1, address token2)
1832         public
1833         view
1834         returns (uint)
1835     {
1836         bytes20 tokenPair = bytes20(token1) ^ bytes20(token2);
1837         return tradingPairCutoffs[orderOwner][tokenPair];
1838     }
1839 }